// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "./interface/IVBNB.sol";
import "./interface/CompleteVToken.sol";
import "./wbnb/WBNB.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

contract VenusInteractorInitializable is Initializable, ReentrancyGuardUpgradeable {

  using SafeMath for uint256;
  using SafeBEP20 for IBEP20;

  address public constant _wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  bytes32 internal constant _INTERACTOR_UNDERLYING_SLOT = 0x3e9f9f7ea72bae20746fd93eefa9f38d4f124c4ea7b6f6d6641f8cca268c5697;
  bytes32 internal constant _VTOKEN_SLOT = 0xd10d7aea8cd8c74e560aafdc0a5d3820e89ad384815628d13908d84a477ec585;
  bytes32 internal constant _COMPTROLLER_SLOT = 0xd6eb26dcc0c659c2dac09757ba602511aadae03cd65090aa8c177fb971879dd6;

  constructor() public {
    assert(_INTERACTOR_UNDERLYING_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.underlying")) - 1));
    assert(_VTOKEN_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.vtoken")) - 1));
    assert(_COMPTROLLER_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.comptroller")) - 1));
  }

  function initialize(
    address _underlying,
    address _vtoken,
    address _comptroller
  ) public initializer {
    __ReentrancyGuard_init();
    // Comptroller:
    _setComptroller(_comptroller);
    _setInteractorUnderlying(_underlying);
    _setVToken(_vtoken);

    // Enter the market
    address[] memory vTokens = new address[](1);
    vTokens[0] = _vtoken;
    ComptrollerInterface(comptroller()).enterMarkets(vTokens);

  }

  /**
  * Supplies BNB to Venus
  * Unwraps WBNB to BNB, then invoke the special mint for vBNB
  * We ask to supply "amount", if the "amount" we asked to supply is
  * more than balance (what we really have), then only supply balance.
  * If we the "amount" we want to supply is less than balance, then
  * only supply that amount.
  */
  function _supplyBNBInWBNB(uint256 amountInWBNB) internal nonReentrant {
    // underlying here is WBNB
    uint256 balance = IBEP20(_underlying()).balanceOf(address(this)); // supply at most "balance"
    if (amountInWBNB < balance) {
      balance = amountInWBNB; // only supply the "amount" if its less than what we have
    }
    WBNB wbnb = WBNB(payable(_wbnb));
    wbnb.withdraw(balance); // Unwrapping
    IVBNB(vToken()).mint{value: balance}();
  }

  /**
  * Redeems BNB from Venus
  * receives BNB. Wrap all the BNB that is in this contract.
  */
  function _redeemBNBInvTokens(uint256 amountVTokens) internal nonReentrant {
    _redeemInVTokens(amountVTokens);
    WBNB wbnb = WBNB(payable(_wbnb));
    wbnb.deposit{value: address(this).balance}();
  }

  /**
  * Supplies to Venus
  */
  function _supply(uint256 amount) internal returns(uint256) {
    uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
    if (amount < balance) {
      balance = amount;
    }
    IBEP20(_underlying()).safeApprove(vToken(), 0);
    IBEP20(_underlying()).safeApprove(vToken(), balance);
    uint256 mintResult = CompleteVToken(vToken()).mint(balance);
    require(mintResult == 0, "Supplying failed");
    return balance;
  }

  /**
  * Borrows against the collateral
  */
  function _borrow(uint256 amountUnderlying) internal {
    // Borrow, check the balance for this contract's address
    uint256 result = CompleteVToken(vToken()).borrow(amountUnderlying);
    require(result == 0, "Borrow failed");
  }

  /**
  * Borrows against the collateral
  */
  function _borrowInWBNB(uint256 amountUnderlying) internal {
    // Borrow BNB, wraps into WBNB
    uint256 result = CompleteVToken(vToken()).borrow(amountUnderlying);
    require(result == 0, "Borrow failed");
    WBNB wbnb = WBNB(payable(_wbnb));
    wbnb.deposit{value: address(this).balance}();
  }

  /**
  * Repays a loan
  */
  function _repay(uint256 amountUnderlying) internal {
    IBEP20(_underlying()).safeApprove(vToken(), 0);
    IBEP20(_underlying()).safeApprove(vToken(), amountUnderlying);
    CompleteVToken(vToken()).repayBorrow(amountUnderlying);
    IBEP20(_underlying()).safeApprove(vToken(), 0);
  }

  /**
  * Repays a loan in BNB
  */
  function _repayInWBNB(uint256 amountUnderlying) internal {
    WBNB wbnb = WBNB(payable(_wbnb));
    wbnb.withdraw(amountUnderlying); // Unwrapping
    IVBNB(vToken()).repayBorrow{value: amountUnderlying}();
  }

  /**
  * Redeem liquidity in vTokens
  */
  function _redeemInVTokens(uint256 amountVTokens) internal {
    if(amountVTokens > 0){
      CompleteVToken(vToken()).redeem(amountVTokens);
    }
  }

  /**
  * Redeem liquidity in underlying
  */
  function _redeemUnderlying(uint256 amountUnderlying) internal {
    if (amountUnderlying > 0) {
      CompleteVToken(vToken()).redeemUnderlying(amountUnderlying);
    }
  }

  /**
  * Redeem liquidity in underlying
  */
  function redeemUnderlyingInWBNB(uint256 amountUnderlying) internal {
    if (amountUnderlying > 0) {
      _redeemUnderlying(amountUnderlying);
      WBNB wbnb = WBNB(payable(_wbnb));
      wbnb.deposit{value: address(this).balance}();
    }
  }

  /**
  * Get XVS
  */
  function claimVenus() public {
    address[] memory markets = new address[](1);
    markets[0] = address(vToken());
    ComptrollerInterface(comptroller()).claimVenus(address(this), markets);
  }

  /**
  * Redeem the minimum of the WBNB we own, and the WBNB that the vToken can
  * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently
  */
  function redeemMaximumWBNB() internal {
    // amount of WBNB in contract
    uint256 available = CompleteVToken(vToken()).getCash();
    // amount of WBNB we own
    uint256 owned = CompleteVToken(vToken()).balanceOfUnderlying(address(this));

    // redeem the most we can redeem
    redeemUnderlyingInWBNB(available < owned ? available : owned);
  }

  function redeemMaximumWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
    // amount of liquidity in Venus
    uint256 available = CompleteVToken(vToken()).getCash();
    // amount we supplied
    uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    // amount we borrowed
    uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));

    while (borrowed > borrowMinThreshold) {
      uint256 requiredCollateral = borrowed
        .mul(collateralFactorDenominator)
        .add(collateralFactorNumerator.div(2))
        .div(collateralFactorNumerator);

      // redeem just as much as needed to repay the loan
      uint256 wantToRedeem = supplied.sub(requiredCollateral);
      _redeemUnderlying(MathUpgradeable.min(wantToRedeem, available));

      // now we can repay our borrowed amount
      uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
      _repay(MathUpgradeable.min(borrowed, balance));

      // update the parameters
      available = CompleteVToken(vToken()).getCash();
      borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
      supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    }

    // redeem the most we can redeem
    _redeemUnderlying(MathUpgradeable.min(available, supplied));
  }

  function redeemMaximumWBNBWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
    // amount of liquidity in Venus
    uint256 available = CompleteVToken(vToken()).getCash();
    // amount of WBNB we supplied
    uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    // amount of WBNB we borrowed
    uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));

    while (borrowed > borrowMinThreshold) {
      uint256 requiredCollateral = borrowed
        .mul(collateralFactorDenominator)
        .add(collateralFactorNumerator.div(2))
        .div(collateralFactorNumerator);

      // redeem just as much as needed to repay the loan
      uint256 wantToRedeem = supplied.sub(requiredCollateral);
      redeemUnderlyingInWBNB(MathUpgradeable.min(wantToRedeem, available));

      // now we can repay our borrowed amount
      uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
      _repayInWBNB(MathUpgradeable.min(borrowed, balance));

      // update the parameters
      available = CompleteVToken(vToken()).getCash();
      borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
      supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
    }

    // redeem the most we can redeem
    redeemUnderlyingInWBNB(MathUpgradeable.min(available, supplied));
  }

  function getLiquidity() external view returns(uint256) {
    return CompleteVToken(vToken()).getCash();
  }

  function redeemMaximumToken() internal {
    // amount of tokens in vtoken
    uint256 available = CompleteVToken(vToken()).getCash();
    // amount of tokens we own
    uint256 owned = CompleteVToken(vToken()).balanceOfUnderlying(address(this));

    // redeem the most we can redeem
    _redeemUnderlying(available < owned ? available : owned);
  }

  receive() external payable {} // this is needed for the WBNB unwrapping

  function _setInteractorUnderlying(address _address) internal {
    _setAddress(_INTERACTOR_UNDERLYING_SLOT, _address);
  }

  function _underlying() internal virtual view returns (address) {
    return _getAddress(_INTERACTOR_UNDERLYING_SLOT);
  }

  function _setVToken(address _address) internal {
    _setAddress(_VTOKEN_SLOT, _address);
  }

  function vToken() public virtual view returns (address) {
    return _getAddress(_VTOKEN_SLOT);
  }

  function _setComptroller(address _address) internal {
    _setAddress(_COMPTROLLER_SLOT, _address);
  }

  function comptroller() public virtual view returns (address) {
    return _getAddress(_COMPTROLLER_SLOT);
  }

  function _setAddress(bytes32 slot, address _address) internal {
    // solhint-disable-next-line no-inline-assembly
    assembly {
      sstore(slot, _address)
    }
  }

  function _getAddress(bytes32 slot) internal view returns (address str) {
    // solhint-disable-next-line no-inline-assembly
    assembly {
      str := sload(slot)
    }
  }
}
