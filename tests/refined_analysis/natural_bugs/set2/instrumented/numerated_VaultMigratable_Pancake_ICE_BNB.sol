1 pragma solidity 0.6.12;
2 
3 import "../Vault.sol";
4 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
6 
7 import "../interface/pancakeswap/IPancakeRouter02.sol";
8 
9 interface IBASSwap {
10   function swap(uint256 amount) external;
11 }
12 
13 contract VaultMigratable_Pancake_ICE_BNB is Vault {
14   using SafeBEP20 for IBEP20;
15 
16   // token 1 = BNB , token 2 = ICE
17   address public constant __ICE = address(0xf16e81dce15B08F326220742020379B855B87DF9);
18   address public constant __BNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
19 
20   address public constant __ICE_BNB = address(0xFE3171B9c20d002376D4B0097207EDf54b02EA3B);
21 
22   address public constant __ICE_BNB_V2 = address(0x51F914a192a97408D991FddDAFB8F8537C5Ffb0a);
23 
24   address public constant __PANCAKE_OLD_ROUTER = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
25   address public constant __SUSHI_NEW_ROUTER = address(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
26 
27   address public constant __governance = address(0xf00dD244228F51547f0563e60bCa65a30FBF5f7f);
28 
29   event Migrated(uint256 v1Liquidity, uint256 v2Liquidity);
30   event LiquidityRemoved(uint256 v1Liquidity, uint256 amountToken1, uint256 amountToken2);
31   event LiquidityProvided(uint256 token1Contributed, uint256 token2Contributed, uint256 v2Liquidity);
32 
33   constructor() public {
34   }
35 
36   /**
37   * Migrates the vault from the underlying to underlying v2
38   */
39   function migrateUnderlying(
40     uint256 minICEOut, uint256 minBNBOut,
41     uint256 minICEContribution, uint256 minBNBContribution
42   ) public onlyControllerOrGovernance {
43     require(underlying() == __ICE_BNB, "Can only migrate if the underlying is ICE/BNB");
44     withdrawAll();
45 
46     uint256 v1Liquidity = IBEP20(__ICE_BNB).balanceOf(address(this));
47     IBEP20(__ICE_BNB).safeApprove(__PANCAKE_OLD_ROUTER, 0);
48     IBEP20(__ICE_BNB).safeApprove(__PANCAKE_OLD_ROUTER, v1Liquidity);
49 
50     (uint256 amountBNB, uint256 amountICE) = IPancakeRouter02(__PANCAKE_OLD_ROUTER).removeLiquidity(
51       __BNB,
52       __ICE,
53       v1Liquidity,
54       minBNBOut,
55       minICEOut,
56       address(this),
57       block.timestamp
58     );
59     emit LiquidityRemoved(v1Liquidity, amountBNB, amountICE);
60 
61     require(IBEP20(__ICE_BNB).balanceOf(address(this)) == 0, "Not all underlying was converted");
62 
63     IBEP20(__ICE).safeApprove(__SUSHI_NEW_ROUTER, 0);
64     IBEP20(__ICE).safeApprove(__SUSHI_NEW_ROUTER, amountICE);
65     IBEP20(__BNB).safeApprove(__SUSHI_NEW_ROUTER, 0);
66     IBEP20(__BNB).safeApprove(__SUSHI_NEW_ROUTER, amountBNB);
67 
68     (uint256 bnbContributed,
69       uint256 iceContributed,
70       uint256 v2Liquidity) = IPancakeRouter02(__SUSHI_NEW_ROUTER).addLiquidity(
71         __BNB,
72         __ICE,
73         amountBNB, // amountADesire
74         amountICE, // amountBDesired
75         minBNBContribution, // amountAMin
76         minICEContribution, // amountBMin
77         address(this),
78         block.timestamp);
79 
80     emit LiquidityProvided(bnbContributed, iceContributed, v2Liquidity);
81 
82     _setUnderlying(__ICE_BNB_V2);
83     require(underlying() == __ICE_BNB_V2, "underlying switch failed");
84     _setStrategy(address(0));
85 
86     uint256 iceLeft = IBEP20(__ICE).balanceOf(address(this));
87     if (iceLeft > 0) {
88       IBEP20(__ICE).transfer(__governance, iceLeft);
89     }
90     uint256 bnbLeft = IBEP20(__BNB).balanceOf(address(this));
91     if (bnbLeft > 0) {
92       IBEP20(__BNB).transfer(__governance, bnbLeft);
93     }
94 
95     emit Migrated(v1Liquidity, v2Liquidity);
96   }
97 }
