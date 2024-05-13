1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../swapHandlers/ISwapHandler.sol";
7 
8 /*
9 
10 SwapHub is a generic swapping interface where users can select their desired swapping handler
11 without any changes needed to Euler contracts.
12 
13 When a user invokes a swap, the input amount (or maximum input) is transferred to the handler
14 contract. The handler contract should then perform the swap by whatever means it chooses,
15 then transfer back any remaining input and all the output. SwapHub will ensure that the
16 amounts returned satisfy the user's slippage settings and process the corresponding
17 withdrawal and deposit on behalf of the user.
18 
19 */
20 
21 /// @notice Common logic for executing and processing trades through external swap handler contracts
22 contract SwapHub is BaseLogic {
23     struct SwapCache {
24         address accountIn;
25         address accountOut;
26         address eTokenIn;
27         address eTokenOut;
28         AssetCache assetCacheIn;
29         AssetCache assetCacheOut;
30         uint preBalanceIn;
31         uint preBalanceOut;
32     }
33 
34     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__SWAPHUB, moduleGitCommit_) {}
35 
36     /// @notice Execute a trade using the requested swap handler
37     /// @param subAccountIdIn sub-account holding the sold token. 0 for primary, 1-255 for a sub-account
38     /// @param subAccountIdOut sub-account to receive the bought token. 0 for primary, 1-255 for a sub-account
39     /// @param swapHandler address of a swap handler to use
40     /// @param params struct defining the requested trade
41     function swap(uint subAccountIdIn, uint subAccountIdOut, address swapHandler, ISwapHandler.SwapParams memory params) external nonReentrant {
42         SwapCache memory cache = initSwap(subAccountIdIn, subAccountIdOut, params);
43 
44         emit RequestSwapHub(
45             cache.accountIn,
46             cache.accountOut,
47             params.underlyingIn,
48             params.underlyingOut,
49             params.amountIn,
50             params.amountOut,
51             params.mode,
52             swapHandler
53         );
54 
55         uint amountOut = swapInternal(cache, swapHandler, params);
56 
57         // Process deposit
58         uint amountOutDecoded = decodeExternalAmount(cache.assetCacheOut, amountOut);
59         uint amountOutInternal = underlyingAmountToBalance(cache.assetCacheOut, amountOutDecoded);
60         cache.assetCacheOut.poolSize = decodeExternalAmount(cache.assetCacheOut, cache.preBalanceOut + amountOut);
61         AssetStorage storage assetStorageOut = eTokenLookup[cache.eTokenOut];
62         increaseBalance(assetStorageOut, cache.assetCacheOut, cache.eTokenOut, cache.accountOut, amountOutInternal);
63         logAssetStatus(cache.assetCacheOut);
64 
65         // Check liquidity
66         checkLiquidity(cache.accountIn);
67 
68         // Depositing a token to the account with a pre-existing debt in that token creates a self-collateralized loan
69         // which may result in borrow isolation violation if other tokens are also borrowed on the account
70         if (cache.accountIn != cache.accountOut && assetStorageOut.users[cache.accountOut].owed != 0)
71             checkLiquidity(cache.accountOut);
72     }
73 
74     /// @notice Repay debt by selling another deposited token
75     /// @param subAccountIdIn sub-account holding the sold token. 0 for primary, 1-255 for a sub-account
76     /// @param subAccountIdOut sub-account to receive the bought token. 0 for primary, 1-255 for a sub-account
77     /// @param swapHandler address of a swap handler to use
78     /// @param params struct defining the requested trade
79     /// @param targetDebt how much debt should remain after calling the function
80     function swapAndRepay(uint subAccountIdIn, uint subAccountIdOut, address swapHandler, ISwapHandler.SwapParams memory params, uint targetDebt) external nonReentrant {
81         SwapCache memory cache = initSwap(subAccountIdIn, subAccountIdOut, params);
82 
83         emit RequestSwapHubRepay(
84             cache.accountIn,
85             cache.accountOut,
86             params.underlyingIn,
87             params.underlyingOut,
88             targetDebt,
89             swapHandler
90         );
91 
92         // Adjust params for repay
93         require(params.mode == 1, "e/swap-hub/repay-mode");
94 
95         AssetStorage storage assetStorageOut = eTokenLookup[cache.eTokenOut];
96         uint owed = getCurrentOwed(assetStorageOut, cache.assetCacheOut, cache.accountOut) / cache.assetCacheOut.underlyingDecimalsScaler;
97         require (owed > targetDebt, "e/swap-hub/target-debt");
98         params.amountOut = owed - targetDebt;
99 
100         uint amountOut = swapInternal(cache, swapHandler, params);
101 
102         // Process repay
103         cache.assetCacheOut.poolSize = decodeExternalAmount(cache.assetCacheOut, cache.preBalanceOut + amountOut);
104         decreaseBorrow(assetStorageOut, cache.assetCacheOut, assetStorageOut.dTokenAddress, cache.accountOut, decodeExternalAmount(cache.assetCacheOut, amountOut));
105         logAssetStatus(cache.assetCacheOut);
106 
107         // Check liquidity only for outgoing account, repay can't lower the health score or cause borrow isolation error
108         checkLiquidity(cache.accountIn);
109     }
110 
111     function swapInternal(SwapCache memory cache, address swapHandler, ISwapHandler.SwapParams memory params) private returns (uint) {
112         // Adjust requested amount in
113         (uint amountInScaled, uint amountInInternal) = withdrawAmounts(eTokenLookup[cache.eTokenIn], cache.assetCacheIn, cache.accountIn, params.amountIn);
114         require(cache.assetCacheIn.poolSize >= amountInScaled, "e/swap-hub/insufficient-pool-size");
115         params.amountIn = amountInScaled / cache.assetCacheIn.underlyingDecimalsScaler;
116 
117         // Supply handler, for exact output amount transfered serves as an implicit amount in max.
118         Utils.safeTransfer(params.underlyingIn, swapHandler, params.amountIn);
119 
120         // Invoke handler
121         ISwapHandler(swapHandler).executeSwap(params);
122 
123         // Verify output received, credit any returned input
124         uint postBalanceIn = callBalanceOf(cache.assetCacheIn, address(this));
125         uint postBalanceOut = callBalanceOf(cache.assetCacheOut, address(this));
126 
127         uint amountOutMin;
128         if (params.mode == 0) {
129             amountOutMin = params.amountOut;
130         } else {
131             require(params.amountOut > params.exactOutTolerance, "e/swap-hub/exact-out-tolerance");
132             unchecked { amountOutMin = params.amountOut - params.exactOutTolerance; }
133         }
134 
135         require(postBalanceOut >= cache.preBalanceOut + amountOutMin, "e/swap-hub/insufficient-output");
136         require(cache.preBalanceIn >= postBalanceIn, "e/swap-hub/positive-input");
137 
138         uint amountIn;
139         uint amountOut;
140         unchecked {
141             amountIn = cache.preBalanceIn - postBalanceIn;
142             amountOut = postBalanceOut - cache.preBalanceOut;
143         }
144 
145         // for exact output calculate amounts in post swap. Also when amount sold is not equal to requested (e.g. partial fill)
146         if (params.mode == 1 || amountIn != params.amountIn) {
147             amountInScaled = decodeExternalAmount(cache.assetCacheIn, amountIn);
148             amountInInternal = underlyingAmountToBalanceRoundUp(cache.assetCacheIn, amountInScaled);
149         }
150 
151         // Process withdraw
152         cache.assetCacheIn.poolSize = decodeExternalAmount(cache.assetCacheIn, postBalanceIn);
153         decreaseBalance(eTokenLookup[cache.eTokenIn], cache.assetCacheIn, cache.eTokenIn, cache.accountIn, amountInInternal);
154         logAssetStatus(cache.assetCacheIn);
155 
156         return amountOut;
157     }
158 
159     function initSwap(uint subAccountIdIn, uint subAccountIdOut, ISwapHandler.SwapParams memory params) private returns (SwapCache memory cache) {
160         require(params.underlyingIn != params.underlyingOut, "e/swap-hub/same");
161 
162         address msgSender = unpackTrailingParamMsgSender();
163         cache.accountIn = getSubAccount(msgSender, subAccountIdIn);
164         cache.accountOut = getSubAccount(msgSender, subAccountIdOut);
165 
166         updateAverageLiquidity(cache.accountIn);
167         if (cache.accountIn != cache.accountOut) updateAverageLiquidity(cache.accountOut);
168 
169         cache.eTokenIn = underlyingLookup[params.underlyingIn].eTokenAddress;
170         cache.eTokenOut = underlyingLookup[params.underlyingOut].eTokenAddress;
171 
172         require(cache.eTokenIn != address(0), "e/swap-hub/in-market-not-activated");
173         require(cache.eTokenOut != address(0), "e/swap-hub/out-market-not-activated");
174 
175         AssetStorage storage assetStorageIn = eTokenLookup[cache.eTokenIn];
176         AssetStorage storage assetStorageOut = eTokenLookup[cache.eTokenOut];
177 
178         cache.assetCacheIn = loadAssetCache(params.underlyingIn, assetStorageIn);
179         cache.assetCacheOut = loadAssetCache(params.underlyingOut, assetStorageOut);
180 
181         unchecked {
182             cache.preBalanceIn = cache.assetCacheIn.poolSize / cache.assetCacheIn.underlyingDecimalsScaler;
183             cache.preBalanceOut = cache.assetCacheOut.poolSize / cache.assetCacheOut.underlyingDecimalsScaler;
184         }
185     }
186 }
