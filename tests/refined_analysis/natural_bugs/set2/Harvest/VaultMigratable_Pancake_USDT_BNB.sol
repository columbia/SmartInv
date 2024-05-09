//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_USDT_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = USDT , token 2 = WBNB
  address public constant __USDT = address(0x55d398326f99059fF775485246999027B3197955);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __USDT_BNB = address(0x20bCC3b8a0091dDac2d0BC30F68E6CBb97de59Cd);

  address public constant __USDT_BNB_V2 = address(0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE);

  address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
  address public constant __PANCAKE_NEW_ROUTER = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);

  address public constant __governance = address(0xf00dD244228F51547f0563e60bCa65a30FBF5f7f);

  event Migrated(uint256 v1Liquidity, uint256 v2Liquidity);
  event LiquidityRemoved(uint256 v1Liquidity, uint256 amountToken1, uint256 amountToken2);
  event LiquidityProvided(uint256 token1Contributed, uint256 token2Contributed, uint256 v2Liquidity);

  constructor() public {
  }

  /**
  * Migrates the vault from the underlying to underlying v2
  */
  function migrateUnderlying(
    uint256 minUSDTOut, uint256 minBNBOut,
    uint256 minUSDTContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __USDT_BNB, "Can only migrate if the underlying is USDT/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__USDT_BNB).balanceOf(address(this));
    IBEP20(__USDT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__USDT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountUSDT, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __USDT,
      __BNB,
      v1Liquidity,
      minUSDTOut,
      minBNBOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountUSDT, amountBNB);

    require(IBEP20(__USDT_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__USDT).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__USDT).safeApprove(__PANCAKE_NEW_ROUTER, amountUSDT);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 usdtContributed,
      uint256 bnbContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __USDT,
        __BNB,
        amountUSDT, // amountADesired
        amountBNB, // amountBDesired
        minUSDTContribution, // amountAMin
        minBNBContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(usdtContributed, bnbContributed, v2Liquidity);

    _setUnderlying(__USDT_BNB_V2);
    require(underlying() == __USDT_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 busdLeft = IBEP20(__USDT).balanceOf(address(this));
    if (busdLeft > 0) {
      IBEP20(__USDT).transfer(__governance, busdLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
