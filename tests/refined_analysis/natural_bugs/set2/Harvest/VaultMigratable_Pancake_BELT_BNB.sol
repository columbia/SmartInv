pragma solidity 0.6.12;

import "../Vault.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../interface/pancakeswap/IPancakeRouter02.sol";

interface IBASSwap {
  function swap(uint256 amount) external;
}

contract VaultMigratable_Pancake_BELT_BNB is Vault {
  using SafeBEP20 for IBEP20;

  // token 1 = BNB , token 2 = BELT
  address public constant __BELT = address(0xE0e514c71282b6f4e823703a39374Cf58dc3eA4f);
  address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

  address public constant __BELT_BNB = address(0x83B92D283cd279fF2e057BD86a95BdEfffED6faa);

  address public constant __BELT_BNB_V2 = address(0xF3Bc6FC080ffCC30d93dF48BFA2aA14b869554bb);

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
    uint256 minBELTOut, uint256 minBNBOut,
    uint256 minBELTContribution, uint256 minBNBContribution
  ) public onlyControllerOrGovernance {
    require(underlying() == __BELT_BNB, "Can only migrate if the underlying is BELT/BNB");
    withdrawAll();

    uint256 v1Liquidity = IBEP20(__BELT_BNB).balanceOf(address(this));
    IBEP20(__BELT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
    IBEP20(__BELT_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);

    (uint256 amountBNB, uint256 amountBELT) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
      __BNB,
      __BELT,
      v1Liquidity,
      minBNBOut,
      minBELTOut,
      address(this),
      block.timestamp
    );
    emit LiquidityRemoved(v1Liquidity, amountBNB, amountBELT);

    require(IBEP20(__BELT_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");

    IBEP20(__BELT).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BELT).safeApprove(__PANCAKE_NEW_ROUTER, amountBELT);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
    IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);

    (uint256 bnbContributed,
      uint256 beltContributed,
      uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
        __BNB,
        __BELT,
        amountBNB, // amountADesire
        amountBELT, // amountBDesired
        minBNBContribution, // amountAMin
        minBELTContribution, // amountBMin
        address(this),
        block.timestamp);

    emit LiquidityProvided(bnbContributed, beltContributed, v2Liquidity);

    _setUnderlying(__BELT_BNB_V2);
    require(underlying() == __BELT_BNB_V2, "underlying switch failed");
    _setStrategy(address(0));

    uint256 beltLeft = IBEP20(__BELT).balanceOf(address(this));
    if (beltLeft > 0) {
      IBEP20(__BELT).transfer(__governance, beltLeft);
    }
    uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
    if (bnbLeft > 0) {
      IBEP20(__BNB).transfer(__governance, bnbLeft);
    }

    emit Migrated(v1Liquidity, v2Liquidity);
  }
}
