pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_BDO_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = BDO , token 2 = WBNB
  address public constant __BDO = address(0x190b589cf9Fb8DDEabBFeae36a813FFb2A702454);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __BDO_BNB = address(0x74690f829fec83ea424ee1F1654041b2491A7bE9);

  address public constant __BDO_BNB_V2 = address(0x4288706624e3dD839b069216eB03B8B9819C10d2);

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
    uint256 minBDOOut, uint256 minBNBOut,
    uint256 minBDOContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __BDO_BNB, "Can only migrate if the underlying is BDO/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__BDO_BNB).balanceOf(address(this));
    IBEP20(__BDO_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__BDO_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountBDO, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __BDO,
      __BNB,
      v1Liquidity,
      minBDOOut,
      minBNBOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountBDO, amountBNB);

    require(IBEP20(__BDO_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__BDO).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BDO).safeApprove(__PANCAKE_NEW_ROUTER, amountBDO);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 bdoContributed,
      uint256 bnbContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __BDO,
        __BNB,
        amountBDO, // amountADesired
        amountBNB, // amountBDesired
        minBDOContribution, // amountAMin
        minBNBContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(bdoContributed, bnbContributed, v2Liquidity);

    _setUnderlying(__BDO_BNB_V2);
    require(underlying() == __BDO_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 bdoLeft = IBEP20(__BDO).balanceOf(address(this));
    if (bdoLeft > 0) {
      IBEP20(__BDO).transfer(__governance, bdoLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
