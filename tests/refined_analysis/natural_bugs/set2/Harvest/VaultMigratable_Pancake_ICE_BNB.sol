pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_ICE_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = BNB , token 2 = ICE
  address public constant __ICE = address(0xf16e81dce15B08F326220742020379B855B87DF9);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __ICE_BNB = address(0xFE3171B9c20d002376D4B0097207EDf54b02EA3B);

  address public constant __ICE_BNB_V2 = address(0x51F914a192a97408D991FddDAFB8F8537C5Ffb0a);

  address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
  address public constant __SUSHI_NEW_ROUTER = address(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);

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
    uint256 minICEOut, uint256 minBNBOut,
    uint256 minICEContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __ICE_BNB, "Can only migrate if the underlying is ICE/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__ICE_BNB).balanceOf(address(this));
    IBEP20(__ICE_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__ICE_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountBNB, uint256 amountICE) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __BNB,
      __ICE,
      v1Liquidity,
      minBNBOut,
      minICEOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountBNB, amountICE);

    require(IBEP20(__ICE_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__ICE).safeApprove(__SUSHI_NEW_ROUTER, 0);
    IBEP20(__ICE).safeApprove(__SUSHI_NEW_ROUTER, amountICE);
    IBEP20(__BNB).safeApprove(__SUSHI_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__SUSHI_NEW_ROUTER, amountBNB);

    (uint256 bnbContributed,
      uint256 iceContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__SUSHI_NEW_ROUTER).addLiquidity(
        __BNB,
        __ICE,
        amountBNB, // amountADesire
        amountICE, // amountBDesired
        minBNBContribution, // amountAMin
        minICEContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(bnbContributed, iceContributed, v2Liquidity);

    _setUnderlying(__ICE_BNB_V2);
    require(underlying() == __ICE_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 iceLeft = IBEP20(__ICE).balanceOf(address(this));
    if (iceLeft > 0) {
      IBEP20(__ICE).transfer(__governance, iceLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
