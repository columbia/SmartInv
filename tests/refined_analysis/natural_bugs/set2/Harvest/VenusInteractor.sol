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

contract VenusInteractor is ReentrancyGuardUpgradeable {

  using SafeMath for uint256;
  using SafeBEP20 for IBEP20;

  IBEP20 public underlying;
  IBEP20 public _wbnb = IBEP20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
  CompleteVToken public vtoken;
  ComptrollerInterface public comptroller;

  constructor(
    address _underlying,
    address _vtoken,
    address _comptroller
  ) public {
    // Comptroller:
    comptroller = ComptrollerInterface(_comptroller);

    underlying = IBEP20(_underlying);
    vtoken = CompleteVToken(_vtoken);

    // Enter the market
    address[] memory vTokens = new address[](1);
    vTokens[0] = _vtoken;
    comptroller.enterMarkets(vTokens);
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
    uint256 balance = underlying.balanceOf(address(this)); // supply at most "balance"
    if (amountInWBNB < balance) {
      balance = amountInWBNB; // only supply the "amount" if its less than what we have
    }
    WBNB wbnb = WBNB(payable(address(_wbnb)));
    wbnb.withdraw(balance); // Unwrapping
    IVBNB(address(vtoken)).mint{value: balance}();
  }

  /**
  * Redeems BNB from Venus
  * receives BNB. Wrap all the BNB that is in this contract.
  */
  function _redeemBNBInvTokens(uint256 amountVTokens) internal nonReentrant {
    _redeemInVTokens(amountVTokens);
    WBNB wbnb = WBNB(payable(address(_wbnb)));
    wbnb.deposit{value: address(this).balance}();
  }

  /**
  * Supplies to Venus
  */
  function _supply(uint256 amount) internal returns(uint256) {
    uint256 balance = underlying.balanceOf(address(this));
    if (amount < balance) {
      balance = amount;
    }
    underlying.safeApprove(address(vtoken), 0);
    underlying.safeApprove(address(vtoken), balance);
    uint256 mintResult = vtoken.mint(balance);
    require(mintResult == 0, "Supplying failed");
    return balance;
  }

  /**
  * Borrows against the collateral
  */
  function _borrow(uint256 amountUnderlying) internal {
    // Borrow, check the balance for this contract's address
    uint256 result = vtoken.borrow(amountUnderlying);
    require(result == 0, "Borrow failed");
  }

  /**
  * Borrows against the collateral
  */
  function _borrowInWBNB(uint256 amountUnderlying) internal {
    // Borrow BNB, wraps into WBNB
    uint256 result = vtoken.borrow(amountUnderlying);
    require(result == 0, "Borrow failed");
    WBNB wbnb = WBNB(payable(address(_wbnb)));
    wbnb.deposit{value: address(this).balance}();
  }

  /**
  * Repays a loan
  */
  function _repay(uint256 amountUnderlying) internal {
    underlying.safeApprove(address(vtoken), 0);
    underlying.safeApprove(address(vtoken), amountUnderlying);
    vtoken.repayBorrow(amountUnderlying);
    underlying.safeApprove(address(vtoken), 0);
  }

  /**
  * Repays a loan in BNB
  */
  function _repayInWBNB(uint256 amountUnderlying) internal {
    WBNB wbnb = WBNB(payable(address(_wbnb)));
    wbnb.withdraw(amountUnderlying); // Unwrapping
    IVBNB(address(vtoken)).repayBorrow{value: amountUnderlying}();
  }

  /**
  * Redeem liquidity in vTokens
  */
  function _redeemInVTokens(uint256 amountVTokens) internal {
    if(amountVTokens > 0){
      vtoken.redeem(amountVTokens);
    }
  }

  /**
  * Redeem liquidity in underlying
  */
  function _redeemUnderlying(uint256 amountUnderlying) internal {
    if (amountUnderlying > 0) {
      vtoken.redeemUnderlying(amountUnderlying);
    }
  }

  /**
  * Redeem liquidity in underlying
  */
  function redeemUnderlyingInWBNB(uint256 amountUnderlying) internal {
    if (amountUnderlying > 0) {
      _redeemUnderlying(amountUnderlying);
      WBNB wbnb = WBNB(payable(address(_wbnb)));
      wbnb.deposit{value: address(this).balance}();
    }
  }

  /**
  * Get XVS
  */
  function claimVenus() public {
    address[] memory markets = new address[](1);
    markets[0] = address(vtoken);
    comptroller.claimVenus(address(this), markets);
  }

  /**
  * Redeem the minimum of the WBNB we own, and the WBNB that the vToken can
  * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently
  */
  function redeemMaximumWBNB() internal {
    // amount of WBNB in contract
    uint256 available = vtoken.getCash();
    // amount of WBNB we own
    uint256 owned = vtoken.balanceOfUnderlying(address(this));

    // redeem the most we can redeem
    redeemUnderlyingInWBNB(available < owned ? available : owned);
  }

  function redeemMaximumWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
    // amount of liquidity in Venus
    uint256 available = vtoken.getCash();
    // amount we supplied
    uint256 supplied = vtoken.balanceOfUnderlying(address(this));
    // amount we borrowed
    uint256 borrowed = vtoken.borrowBalanceCurrent(address(this));

    while (borrowed > borrowMinThreshold) {
      uint256 requiredCollateral = borrowed
        .mul(collateralFactorDenominator)
        .add(collateralFactorNumerator.div(2))
        .div(collateralFactorNumerator);

      // redeem just as much as needed to repay the loan
      uint256 wantToRedeem = supplied.sub(requiredCollateral);
      _redeemUnderlying(MathUpgradeable.min(wantToRedeem, available));

      // now we can repay our borrowed amount
      uint256 balance = underlying.balanceOf(address(this));
      _repay(MathUpgradeable.min(borrowed, balance));

      // update the parameters
      available = vtoken.getCash();
      borrowed = vtoken.borrowBalanceCurrent(address(this));
      supplied = vtoken.balanceOfUnderlying(address(this));
    }

    // redeem the most we can redeem
    _redeemUnderlying(MathUpgradeable.min(available, supplied));
  }

  function redeemMaximumWBNBWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
    // amount of liquidity in Venus
    uint256 available = vtoken.getCash();
    // amount of WBNB we supplied
    uint256 supplied = vtoken.balanceOfUnderlying(address(this));
    // amount of WBNB we borrowed
    uint256 borrowed = vtoken.borrowBalanceCurrent(address(this));

    while (borrowed > borrowMinThreshold) {
      uint256 requiredCollateral = borrowed
        .mul(collateralFactorDenominator)
        .add(collateralFactorNumerator.div(2))
        .div(collateralFactorNumerator);

      // redeem just as much as needed to repay the loan
      uint256 wantToRedeem = supplied.sub(requiredCollateral);
      redeemUnderlyingInWBNB(MathUpgradeable.min(wantToRedeem, available));

      // now we can repay our borrowed amount
      uint256 balance = underlying.balanceOf(address(this));
      _repayInWBNB(MathUpgradeable.min(borrowed, balance));

      // update the parameters
      available = vtoken.getCash();
      borrowed = vtoken.borrowBalanceCurrent(address(this));
      supplied = vtoken.balanceOfUnderlying(address(this));
    }

    // redeem the most we can redeem
    redeemUnderlyingInWBNB(MathUpgradeable.min(available, supplied));
  }

  function getLiquidity() external view returns(uint256) {
    return vtoken.getCash();
  }

  function redeemMaximumToken() internal {
    // amount of tokens in vtoken
    uint256 available = vtoken.getCash();
    // amount of tokens we own
    uint256 owned = vtoken.balanceOfUnderlying(address(this));

    // redeem the most we can redeem
    _redeemUnderlying(available < owned ? available : owned);
  }

  receive() external payable {} // this is needed for the WBNB unwrapping
}
