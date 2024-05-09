// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0;

import "./interface/IMasterChef.sol";
import "../interface/IStrategy.sol";

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";

import "../interface/IVault.sol";
import "../upgradability/BaseUpgradeableStrategy.sol";
import "../interface/pancakeswap/IPancakePair.sol";
import "../interface/pancakeswap/IPancakeRouter02.sol";

contract GeneralMasterChefStrategyNewRouter is BaseUpgradeableStrategy {
  using SafeMath for uint256;
  using SafeBEP20 for IBEP20;

  address constant public pancakeswapRouterV2 = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);

  // additional storage slots (on top of BaseUpgradeableStrategy ones) are defined here
  bytes32 internal constant _POOLID_SLOT = 0x3fd729bfa2e28b7806b03a6e014729f59477b530f995be4d51defc9dad94810b;
  bytes32 internal constant _IS_LP_ASSET_SLOT = 0xc2f3dabf55b1bdda20d5cf5fcba9ba765dfc7c9dbaf28674ce46d43d60d58768;

  // this would be reset on each upgrade
  mapping (address => address[]) public pancakeswapRoutes;
  uint256 public pendingReward;

  constructor() public BaseUpgradeableStrategy() {
    assert(_POOLID_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.poolId")) - 1));
    assert(_IS_LP_ASSET_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.isLpAsset")) - 1));
  }

  function initializeStrategy(
    address _storage,
    address _underlying,
    address _vault,
    address _rewardPool,
    address _rewardToken,
    uint256 _poolID,
    bool _isLpToken
  ) public initializer {

    BaseUpgradeableStrategy.initialize(
      _storage,
      _underlying,
      _vault,
      _rewardPool,
      _rewardToken,
      80, // profit sharing numerator
      1000, // profit sharing denominator
      true, // sell
      1e16, // sell floor
      12 hours // implementation change delay
    );

    address _lpt;
    (_lpt,,,) = IMasterChef(rewardPool()).poolInfo(_poolID);
    require(_lpt == underlying(), "Pool Info does not match underlying");
    _setPoolId(_poolID);

    if (_isLpToken) {
      address uniLPComponentToken0 = IPancakePair(underlying()).token0();
      address uniLPComponentToken1 = IPancakePair(underlying()).token1();

      // these would be required to be initialized separately by governance
      pancakeswapRoutes[uniLPComponentToken0] = new address[](0);
      pancakeswapRoutes[uniLPComponentToken1] = new address[](0);
    } else {
      pancakeswapRoutes[underlying()] = new address[](0);
    }

    setBoolean(_IS_LP_ASSET_SLOT, _isLpToken);
  }

  modifier updatePendingReward() {
    _;
    pendingReward = IBEP20(rewardToken()).balanceOf(address(this));
  }

  function depositArbCheck() public pure returns(bool) {
    return true;
  }

  function rewardPoolBalance() internal view returns (uint256 bal) {
      (bal,) = IMasterChef(rewardPool()).userInfo(poolId(), address(this));
  }

  function unsalvagableTokens(address token) public view returns (bool) {
    return (token == rewardToken() || token == underlying());
  }

  function enterRewardPool() updatePendingReward internal {
    uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));
    IBEP20(underlying()).safeApprove(rewardPool(), 0);
    IBEP20(underlying()).safeApprove(rewardPool(), entireBalance);

    IMasterChef(rewardPool()).deposit(poolId(), entireBalance);
  }

  /*
  *   In case there are some issues discovered about the pool or underlying asset
  *   Governance can exit the pool properly
  *   The function is only used for emergency to exit the pool
  */
  function emergencyExit() updatePendingReward public onlyGovernance {
    uint256 bal = rewardPoolBalance();
    IMasterChef(rewardPool()).withdraw(poolId(), bal);
    _setPausedInvesting(true);
  }

  /*
  *   Resumes the ability to invest into the underlying reward pools
  */
  function continueInvesting() public onlyGovernance {
    _setPausedInvesting(false);
  }

  function setLiquidationPath(address _token, address [] memory _route) public onlyGovernance {
    require(_route[0] == rewardToken(), "Path should start with rewardToken");
    require(_route[_route.length-1] == _token, "Path should end with given Token");
    pancakeswapRoutes[_token] = _route;
  }

  // We assume that all the tradings can be done on Pancakeswap
  function _liquidateReward(uint256 rewardBalance) internal {
    if (!sell() || rewardBalance < sellFloor()) {
      // Profits can be disabled for possible simplified and rapid exit
      emit ProfitsNotCollected(sell(), rewardBalance < sellFloor());
      return;
    }

    notifyProfitInRewardToken(rewardBalance);
    uint256 remainingRewardBalance = IBEP20(rewardToken()).balanceOf(address(this));

    if (remainingRewardBalance == 0) {
      return;
    }

    // allow Pancakeswap to sell our reward
    IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, 0);
    IBEP20(rewardToken()).safeApprove(pancakeswapRouterV2, remainingRewardBalance);

    // we can accept 1 as minimum because this is called only by a trusted role
    uint256 amountOutMin = 1;

    if (isLpAsset()) {
      address uniLPComponentToken0 = IPancakePair(underlying()).token0();
      address uniLPComponentToken1 = IPancakePair(underlying()).token1();

      uint256 toToken0 = remainingRewardBalance.div(2);
      uint256 toToken1 = remainingRewardBalance.sub(toToken0);

      uint256 token0Amount;

      if (pancakeswapRoutes[uniLPComponentToken0].length > 1) {
        // if we need to liquidate the token0
        IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
          toToken0,
          amountOutMin,
          pancakeswapRoutes[uniLPComponentToken0],
          address(this),
          block.timestamp
        );
        token0Amount = IBEP20(uniLPComponentToken0).balanceOf(address(this));
      } else {
        // otherwise we assme token0 is the reward token itself
        token0Amount = toToken0;
      }

      uint256 token1Amount;

      if (pancakeswapRoutes[uniLPComponentToken1].length > 1) {
        // sell reward token to token1
        IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
          toToken1,
          amountOutMin,
          pancakeswapRoutes[uniLPComponentToken1],
          address(this),
          block.timestamp
        );
        token1Amount = IBEP20(uniLPComponentToken1).balanceOf(address(this));
      } else {
        token1Amount = toToken1;
      }

      // provide token0 and token1 to Pancake
      IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, 0);
      IBEP20(uniLPComponentToken0).safeApprove(pancakeswapRouterV2, token0Amount);

      IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, 0);
      IBEP20(uniLPComponentToken1).safeApprove(pancakeswapRouterV2, token1Amount);

      // we provide liquidity to Pancake
      uint256 liquidity;
      (,,liquidity) = IPancakeRouter02(pancakeswapRouterV2).addLiquidity(
        uniLPComponentToken0,
        uniLPComponentToken1,
        token0Amount,
        token1Amount,
        1,  // we are willing to take whatever the pair gives us
        1,  // we are willing to take whatever the pair gives us
        address(this),
        block.timestamp
      );
    } else {
      if (underlying() != rewardToken()) {
        IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
          remainingRewardBalance,
          amountOutMin,
          pancakeswapRoutes[underlying()],
          address(this),
          block.timestamp
        );
      }
    }
  }

  /*
  *   Stakes everything the strategy holds into the reward pool
  */
  function investAllUnderlying() internal onlyNotPausedInvesting {
    // this check is needed, because most of the SNX reward pools will revert if
    // you try to stake(0).
    if(IBEP20(underlying()).balanceOf(address(this)) > 0) {
      enterRewardPool();
    }
  }

  /*
  *   Withdraws all the asset to the vault
  */
  function withdrawAllToVault() updatePendingReward public restricted {
    if (address(rewardPool()) != address(0)) {
      uint256 bal = rewardPoolBalance();
      if (bal != 0) {
        IMasterChef(rewardPool()).withdraw(poolId(), bal);
      }
    }
    if (underlying() != rewardToken()) {
      uint256 rewardBalance = IBEP20(rewardToken()).balanceOf(address(this));
      _liquidateReward(rewardBalance);
    }
    IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
  }

  /*
  *   Withdraws all the asset to the vault
  */
  function withdrawToVault(uint256 amount) updatePendingReward public restricted {
    // Typically there wouldn't be any amount here
    // however, it is possible because of the emergencyExit
    uint256 entireBalance = IBEP20(underlying()).balanceOf(address(this));

    if(amount > entireBalance){
      // While we have the check above, we still using SafeMath below
      // for the peace of mind (in case something gets changed in between)
      uint256 needToWithdraw = amount.sub(entireBalance);
      uint256 toWithdraw = MathUpgradeable.min(rewardPoolBalance(), needToWithdraw);
      IMasterChef(rewardPool()).withdraw(poolId(), toWithdraw);
    }

    IBEP20(underlying()).safeTransfer(vault(), amount);
  }

  /*
  *   Note that we currently do not have a mechanism here to include the
  *   amount of reward that is accrued.
  */
  function investedUnderlyingBalance() external view returns (uint256) {
    if (rewardPool() == address(0)) {
      return IBEP20(underlying()).balanceOf(address(this));
    }
    // Adding the amount locked in the reward pool and the amount that is somehow in this contract
    // both are in the units of "underlying"
    // The second part is needed because there is the emergency exit mechanism
    // which would break the assumption that all the funds are always inside of the reward pool
    return rewardPoolBalance().add(IBEP20(underlying()).balanceOf(address(this)));
  }

  /*
  *   Governance or Controller can claim coins that are somehow transferred into the contract
  *   Note that they cannot come in take away coins that are used and defined in the strategy itself
  */
  function salvage(address recipient, address token, uint256 amount) external onlyControllerOrGovernance {
     // To make sure that governance cannot come in and take away the coins
    require(!unsalvagableTokens(token), "token is defined as not salvagable");
    IBEP20(token).safeTransfer(recipient, amount);
  }

  /*
  *   Get the reward, sell it in exchange for underlying, invest what you got.
  *   It's not much, but it's honest work.
  *
  *   Note that although `onlyNotPausedInvesting` is not added here,
  *   calling `investAllUnderlying()` affectively blocks the usage of `doHardWork`
  *   when the investing is being paused by governance.
  */
  function doHardWork() updatePendingReward external onlyNotPausedInvesting restricted {
    uint256 bal = rewardPoolBalance();
    if (bal != 0) {
      uint256 rewardBalanceBefore = IBEP20(rewardToken()).balanceOf(address(this));
      IMasterChef(rewardPool()).withdraw(poolId(), 0);
      uint256 rewardBalanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
      uint256 claimedReward = rewardBalanceAfter.sub(rewardBalanceBefore).add(pendingReward);
      _liquidateReward(claimedReward);
    }

    investAllUnderlying();
  }

  /**
  * Can completely disable claiming rewards and selling. Good for emergency withdraw in the
  * simplest possible way.
  */
  function setSell(bool s) public onlyGovernance {
    _setSell(s);
  }

  /**
  * Sets the minimum amount needed to trigger a sale.
  */
  function setSellFloor(uint256 floor) public onlyGovernance {
    _setSellFloor(floor);
  }

  // masterchef rewards pool ID
  function _setPoolId(uint256 _value) internal {
    setUint256(_POOLID_SLOT, _value);
  }

  function poolId() public view returns (uint256) {
    return getUint256(_POOLID_SLOT);
  }

  function isLpAsset() public view returns (bool) {
    return getBoolean(_IS_LP_ASSET_SLOT);
  }

  function finalizeUpgrade() external onlyGovernance {
    _finalizeUpgrade();
    // reset the liquidation paths
    // they need to be re-set manually
    if (isLpAsset()) {
      pancakeswapRoutes[IPancakePair(underlying()).token0()] = new address[](0);
      pancakeswapRoutes[IPancakePair(underlying()).token1()] = new address[](0);
    } else {
      pancakeswapRoutes[underlying()] = new address[](0);
    }
  }
}
