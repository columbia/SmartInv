1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 import "../Vault.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
8 
9 import "../interface/pancakeswap/IPancakeRouter02.sol";
10 
11 interface IBASSwap {
12   function swap(uint256 amount) external;
13 }
14 
15 contract VaultMigratable_Pancake_BUSD_BNB is Vault {
16   using SafeBEP20 for IBEP20;
17 
18   // token 1 = BNB , token 2 = BUSD
19   address public constant __BUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
20   address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
21 
22   address public constant __BUSD_BNB = address(0x1B96B92314C44b159149f7E0303511fB2Fc4774f);
23   address public constant __BUSD_BNB_V2 = address(0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16);
24 
25   address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
26   address public constant __PANCAKE_NEW_ROUTER = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
27 
28   address public constant __governance = address(0xf00dD244228F51547f0563e60bCa65a30FBF5f7f);
29 
30   event Migrated(uint256 v1Liquidity, uint256 v2Liquidity);
31   event LiquidityRemoved(uint256 v1Liquidity, uint256 amountToken1, uint256 amountToken2);
32   event LiquidityProvided(uint256 token1Contributed, uint256 token2Contributed, uint256 v2Liquidity);
33 
34   constructor() public {
35   }
36 
37   /**
38   * Migrates the vault from the BAS/DAI underlying to BASV2/DAI underlying
39   */
40   function migrateUnderlying(
41     uint256 minBUSDOut, uint256 minBNBOut,
42     uint256 minBUSDContribution, uint256 minBNBContribution
43   ) public onlyControllerOrGovernance {
44     require(underlying() == __BUSD_BNB, "Can only migrate if the underlying is BUSD/BNB");
45     withdrawAll();
46 
47     uint256 v1Liquidity = IBEP20(__BUSD_BNB).balanceOf(address(this));
48     IBEP20(__BUSD_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
49     IBEP20(__BUSD_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);
50 
51     (uint256 amountBUSD, uint256 amountBNB) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
52       __BUSD,
53       __BNB,
54       v1Liquidity,
55       minBUSDOut,
56       minBNBOut,
57       address(this),
58       block.timestamp
59     );
60     emit LiquidityRemoved(v1Liquidity, amountBNB, amountBUSD);
61 
62     require(IBEP20(__BUSD_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");
63 
64     IBEP20(__BUSD).safeApprove(__PANCAKE_NEW_ROUTER, 0);
65     IBEP20(__BUSD).safeApprove(__PANCAKE_NEW_ROUTER, amountBUSD);
66     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, 0);
67     IBEP20(__BNB).safeApprove(__PANCAKE_NEW_ROUTER, amountBNB);
68 
69     (uint256 busdContributed,
70       uint256 bnbContributed,
71       uint256 v2Liquidity) = IPancakeRouter02(__PANCAKE_NEW_ROUTER).addLiquidity(
72         __BUSD,
73         __BNB,
74         amountBUSD, // amountADesired
75         amountBNB, // amountBDesired
76         minBUSDContribution, // amountAMin
77         minBNBContribution, // amountBMin
78         address(this),
79         block.timestamp);
80 
81     emit LiquidityProvided(bnbContributed, busdContributed, v2Liquidity);
82 
83     _setUnderlying(__BUSD_BNB_V2);
84     require(underlying() == __BUSD_BNB_V2, "underlying switch failed");
85     _setStrategy(address(0));
86 
87     uint256 busdLeft = IBEP20(__BUSD).balanceOf(address(this));
88     if (busdLeft > 0) {
89       IBEP20(__BUSD).transfer(__governance, busdLeft);
90     }
91     uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
92     if (bnbLeft > 0) {
93       IBEP20(__BNB).transfer(__governance, bnbLeft);
94     }
95 
96     emit Migrated(v1Liquidity, v2Liquidity);
97   }
98 }
