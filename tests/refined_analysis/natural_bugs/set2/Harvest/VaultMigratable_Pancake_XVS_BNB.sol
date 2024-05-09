//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_XVS_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = BNB , token 2 = XVS
  address public constant __XVS = address(0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __XVS_BNB = address(0x41182c32F854dd97bA0e0B1816022e0aCB2fc0bb);

  address public constant __XVS_BNB_V2 = address(0x7EB5D86FD78f3852a3e0e064f2842d45a3dB6EA2);

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
    uint256 minXVSOut, uint256 minBNBOut,
    uint256 minXVSContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __XVS_BNB, "Can only migrate if the underlying is XVS/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__XVS_BNB).balanceOf(address(this));
    IBEP20(__XVS_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__XVS_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountBNB, uint256 amountXVS) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __BNB,
      __XVS,
      v1Liquidity,
      minBNBOut,
      minXVSOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountBNB, amountXVS);

    require(IBEP20(__XVS_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__XVS).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__XVS).safeApprove(__PANCAKE_NEW_ROUTER, amountXVS);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 bnbContributed,
      uint256 xvsContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __BNB,
        __XVS,
        amountBNB, // amountADesire
        amountXVS, // amountBDesired
        minBNBContribution, // amountAMin
        minXVSContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(bnbContributed, xvsContributed, v2Liquidity);

    _setUnderlying(__XVS_BNB_V2);
    require(underlying() == __XVS_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 busdLeft = IBEP20(__XVS).balanceOf(address(this));
    if (busdLeft > 0) {
      IBEP20(__XVS).transfer(__governance, busdLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
