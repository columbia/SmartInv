// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
import "./VenusInteractorInitializable.sol";
import "../interface/IVault.sol";
import "../upgradability/BaseUpgradeableStrategy.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

contract VenusFoldStrategy is BaseUpgradeableStrategy, VenusInteractorInitializable {

  using SafeMath for uint256;
  using SafeBEP20 for IBEP20;

  event ProfitNotClaimed();
  event TooLowBalance();

  address constant public pancakeswapRouterV2 = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
  bool public allowEmergencyLiquidityShortage = false;
  uint256 public borrowMinThreshold = 0;

  // additional storage slots (on top of BaseUpgradeableStrategy ones) are defined here
  bytes32 internal constant _COLLATERALFACTORNUMERATOR_SLOT = 0x129eccdfbcf3761d8e2f66393221fa8277b7623ad13ed7693a0025435931c64a;
  bytes32 internal constant _COLLATERALFACTORDENOMINATOR_SLOT = 0x606ec222bff56fc4394b829203993803e413c3116299fce7ba56d1e18ce68869;
  bytes32 internal constant _FOLDS_SLOT = 0xa62de150ef612c15565245b7898c849ef17c729d612c5cc6670d42dca253681b;

  uint256 public suppliedInUnderlying;
  uint256 public borrowedInUnderlying;
  address[] public liquidationPath;

  event Liquidated(
    uint256 amount
  );

  constructor() public BaseUpgradeableStrategy() {
    assert(_COLLATERALFACTORNUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorNumerator")) - 1));
    assert(_COLLATERALFACTORDENOMINATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.collateralFactorDenominator")) - 1));
    assert(_FOLDS_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.folds")) - 1));
  }

  function initializeStrategy(
    address _storage,
    address _underlying,
    address _vtoken,
    address _vault,
    address _comptroller,
    address _xvs,
    uint256 _collateralFactorNumerator,
    uint256 _collateralFactorDenominator,
    uint256 _folds
  )
  public initializer {
    BaseUpgradeableStrategy.initialize(
      _storage,
      _underlying,
      _vault,
      _comptroller,
      _xvs,
      80, // profit sharing numerator
      1000, // profit sharing denominator
      true, // sell
      1e16, // sell floor
      12 hours // implementation change delay
    );

    VenusInteractorInitializable.initialize(_underlying, _vtoken, _comptroller);

    require(IVault(_vault).underlying() == _underlying, "vault does not support underlying");
    _setCollateralFactorDenominator(_collateralFactorDenominator);
    _setCollateralFactorNumerator(_collateralFactorNumerator);
    _setFolds(_folds);
  }

  modifier updateSupplyInTheEnd() {
    _;
    suppliedInUnderlying = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    borrowedInUnderlying = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
  }

  function depositArbCheck() public pure returns (bool) {
    // there's no arb here.
    return true;
  }

  function unsalvagableTokens(address token) public view returns (bool) {
    return (token == rewardToken() || token == underlying() || token == vToken());
  }

  /**
  * The strategy invests by supplying the underlying as a collateral.
  */
  function investAllUnderlying() public restricted updateSupplyInTheEnd {
    uint256 balance = IBEP20(underlying()).balanceOf(address(this));
    // Check before supplying
    uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
    if (balance > 0) {
      _supply(balance);
    }
    if (supplied.mul(collateralFactorNumerator()) > borrowed.mul(collateralFactorDenominator()) || supplied == 0) {
      for (uint256 i = 0; i < folds(); i++) {
        uint256 borrowAmount = balance.mul(collateralFactorNumerator()).div(collateralFactorDenominator());
        _borrow(borrowAmount);
        balance = IBEP20(underlying()).balanceOf(address(this));
        if (balance > 0) {
          _supply(balance);
        }
      }
    }
  }

  /**
  * Exits Venus and transfers everything to the vault.
  */
  function withdrawAllToVault() external restricted updateSupplyInTheEnd {
    if (allowEmergencyLiquidityShortage) {
      withdrawMaximum();
    } else {
      withdrawAllWeInvested();
    }
    if (IBEP20(underlying()).balanceOf(address(this)) > 0) {
      IBEP20(underlying()).safeTransfer(vault(), IBEP20(underlying()).balanceOf(address(this)));
    }
  }

  function emergencyExit() external onlyGovernance updateSupplyInTheEnd {
    withdrawMaximum();
  }

  function withdrawMaximum() internal updateSupplyInTheEnd {
    if (sell()) {
      liquidateVenus();
    } else {
      emit ProfitNotClaimed();
    }
    redeemMaximum();
  }

  function withdrawAllWeInvested() internal updateSupplyInTheEnd {
    if (sell()) {
      liquidateVenus();
    } else {
      emit ProfitNotClaimed();
    }
    uint256 _currentSuppliedBalance = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    uint256 _currentBorrowedBalance = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));

    mustRedeemPartial(_currentSuppliedBalance.sub(_currentBorrowedBalance));
  }

  function withdrawToVault(uint256 amountUnderlying) external restricted updateSupplyInTheEnd {
    if (amountUnderlying <= IBEP20(underlying()).balanceOf(address(this))) {
      IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);
      return;
    }

    // get some of the underlying
    mustRedeemPartial(amountUnderlying);

    // transfer the amount requested (or the amount we have) back to vault()
    IBEP20(underlying()).safeTransfer(vault(), amountUnderlying);

    // invest back to Venus
    investAllUnderlying();
  }

  /**
  * Withdraws all assets, liquidates XVS, and invests again in the required ratio.
  */
  function doHardWork() public restricted {
    if (sell()) {
      liquidateVenus();
    } else {
      emit ProfitNotClaimed();
    }
    investAllUnderlying();
  }

  /**
  * Redeems maximum that can be redeemed from Venus.
  * Redeem the minimum of the underlying we own, and the underlying that the vToken can
  * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently.
  *
  * DOES NOT ensure that the strategy vUnderlying balance becomes 0.
  */
  function redeemMaximum() internal {
    redeemMaximumWithLoan(
      collateralFactorNumerator(),
      collateralFactorDenominator(),
      borrowMinThreshold
    );
  }

  /**
  * Redeems `amountUnderlying` or fails.
  */
  function mustRedeemPartial(uint256 amountUnderlying) internal {
    require(
      CompleteVToken(vToken()).getCash() >= amountUnderlying,
      "market cash cannot cover liquidity"
    );
    redeemMaximum();
    require(IBEP20(underlying()).balanceOf(address(this)) >= amountUnderlying, "Unable to withdraw the entire amountUnderlying");
  }

  /**
  * Salvages a token.
  */
  function salvage(address recipient, address token, uint256 amount) public onlyGovernance {
    // To make sure that governance cannot come in and take away the coins
    require(!unsalvagableTokens(token), "token is defined as not salvagable");
    IBEP20(token).safeTransfer(recipient, amount);
  }

  function liquidateVenus() internal {
    // Calculating rewardBalance is needed for the case underlying = reward token
    uint256 balance = IBEP20(rewardToken()).balanceOf(address(this));
    claimVenus();
    uint256 balanceAfter = IBEP20(rewardToken()).balanceOf(address(this));
    uint256 rewardBalance = balanceAfter.sub(balance);

    if (rewardBalance < sellFloor() || rewardBalance == 0) {
      emit TooLowBalance();
      return;
    }

    // give a profit share to fee forwarder, which re-distributes this to
    // the profit sharing pools
    notifyProfitInRewardToken(rewardBalance);

    balance = IBEP20(rewardToken()).balanceOf(address(this));

    emit Liquidated(balance);

    // no liquidation needed when underlying is reward token
    if (underlying() == rewardToken()) {
      return;
    }

    // we can accept 1 as minimum as this will be called by trusted roles only
    uint256 amountOutMin = 1;
    IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), 0);
    IBEP20(rewardToken()).safeApprove(address(pancakeswapRouterV2), balance);

    IPancakeRouter02(pancakeswapRouterV2).swapExactTokensForTokens(
      balance,
      amountOutMin,
      liquidationPath,
      address(this),
      block.timestamp
    );
  }

  /**
  * Returns the current balance. Ignores XVS that was not liquidated and invested.
  */
  function investedUnderlyingBalance() public view returns (uint256) {
    // underlying in this strategy + underlying redeemable from Venus + loan
    return IBEP20(underlying()).balanceOf(address(this))
    .add(suppliedInUnderlying)
    .sub(borrowedInUnderlying);
  }

  function setAllowLiquidityShortage(bool allowed) external restricted {
    allowEmergencyLiquidityShortage = allowed;
  }

  function setBorrowMinThreshold(uint256 threshold) public onlyGovernance {
    borrowMinThreshold = threshold;
  }

  // updating collateral factor
  // note 1: one should settle the loan first before calling this
  // note 2: collateralFactorDenominator is 1000, therefore, for 20%, you need 200
  function _setCollateralFactorNumerator(uint256 _numerator) internal {
    require(_numerator < uint(600).mul(collateralFactorDenominator()).div(1000), "Collateral factor cannot be this high");
    setUint256(_COLLATERALFACTORNUMERATOR_SLOT, _numerator);
  }

  function collateralFactorNumerator() public view returns (uint256) {
    return getUint256(_COLLATERALFACTORNUMERATOR_SLOT);
  }

  function _setCollateralFactorDenominator(uint256 _denominator) internal {
    setUint256(_COLLATERALFACTORDENOMINATOR_SLOT, _denominator);
  }

  function collateralFactorDenominator() public view returns (uint256) {
    return getUint256(_COLLATERALFACTORDENOMINATOR_SLOT);
  }

  function _setFolds(uint256 _folds) public onlyGovernance {
    setUint256(_FOLDS_SLOT, _folds);
  }

  function folds() public view returns (uint256) {
    return getUint256(_FOLDS_SLOT);
  }

  function setSellFloor(uint256 floor) public onlyGovernance {
    _setSellFloor(floor);
  }

  function setSell(bool s) public onlyGovernance {
    _setSell(s);
  }

  function finalizeUpgrade() external onlyGovernance updateSupplyInTheEnd {
    _finalizeUpgrade();
  }
}
