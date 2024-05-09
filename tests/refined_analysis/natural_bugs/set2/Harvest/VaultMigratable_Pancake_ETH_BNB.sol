//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_ETH_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = ETH , token 2 = WBNB
  address public constant __ETH = address(0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __ETH_BNB = address(0x70D8929d04b60Af4fb9B58713eBcf18765aDE422);

  address public constant __ETH_BNB_V2 = address(0x74E4716E431f45807DCF19f284c7aA99F18a4fbc);

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
    uint256 minETHOut, uint256 minBNBOut,
    uint256 minETHContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __ETH_BNB, "Can only migrate if the underlying is ETH/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__ETH_BNB).balanceOf(address(this));
    IBEP20(__ETH_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__ETH_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountETH, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __ETH,
      __BNB,
      v1Liquidity,
      minETHOut,
      minBNBOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountETH, amountBNB);

    require(IBEP20(__ETH_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__ETH).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__ETH).safeApprove(__PANCAKE_NEW_ROUTER, amountETH);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 ethContributed,
      uint256 bnbContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __ETH,
        __BNB,
        amountETH, // amountADesired
        amountBNB, // amountBDesired
        minETHContribution, // amountAMin
        minBNBContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(ethContributed, bnbContributed, v2Liquidity);

    _setUnderlying(__ETH_BNB_V2);
    require(underlying() == __ETH_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 busdLeft = IBEP20(__ETH).balanceOf(address(this));
    if (busdLeft > 0) {
      IBEP20(__ETH).transfer(__governance, busdLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
