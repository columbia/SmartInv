// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_BUSD_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = BNB , token 2 = BUSD
  address public constant __BUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __BUSD_BNB = address(0x1B96B92314C44b159149f7E0303511fB2Fc4774f);
  address public constant __BUSD_BNB_V2 = address(0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16);

  address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
  address public constant __PANCAKE_NEW_ROUTER = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);

  address public constant __governance = address(0xf00dD244228F51547f0563e60bCa65a30FBF5f7f);

  event Migrated(uint256 v1Liquidity, uint256 v2Liquidity);
  event LiquidityRemoved(uint256 v1Liquidity, uint256 amountToken1, uint256 amountToken2);
  event LiquidityProvided(uint256 token1Contributed, uint256 token2Contributed, uint256 v2Liquidity);

  constructor() public {
  }

  /**
  * Migrates the vault from the BAS/DAI underlying to BASV2/DAI underlying
  */
  function migrateUnderlying(
    uint256 minBUSDOut, uint256 minBNBOut,
    uint256 minBUSDContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __BUSD_BNB, "Can only migrate if the underlying is BUSD/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__BUSD_BNB).balanceOf(address(this));
    IBEP20(__BUSD_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__BUSD_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountBUSD, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __BUSD,
      __BNB,
      v1Liquidity,
      minBUSDOut,
      minBNBOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountBNB, amountBUSD);

    require(IBEP20(__BUSD_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__BUSD).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BUSD).safeApprove(__PANCAKE_NEW_ROUTER, amountBUSD);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 busdContributed,
      uint256 bnbContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __BUSD,
        __BNB,
        amountBUSD, // amountADesired
        amountBNB, // amountBDesired
        minBUSDContribution, // amountAMin
        minBNBContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(bnbContributed, busdContributed, v2Liquidity);

    _setUnderlying(__BUSD_BNB_V2);
    require(underlying() == __BUSD_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 busdLeft = IBEP20(__BUSD).balanceOf(address(this));
    if (busdLeft > 0) {
      IBEP20(__BUSD).transfer(__governance, busdLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
