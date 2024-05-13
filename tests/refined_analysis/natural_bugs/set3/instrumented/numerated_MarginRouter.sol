1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
5 import "../libraries/UniswapStyleLib.sol";
6 
7 import "./RoleAware.sol";
8 import "./Fund.sol";
9 import "../interfaces/IMarginTrading.sol";
10 import "./Lending.sol";
11 import "./Admin.sol";
12 import "./IncentivizedHolder.sol";
13 
14 /// @title Top level transaction controller
15 contract MarginRouter is RoleAware, IncentivizedHolder, Ownable {
16     /// @notice wrapped ETH ERC20 contract
17     address public immutable WETH;
18     uint256 public constant mswapFeesPer10k = 10;
19 
20     /// emitted when a trader depoits on cross margin
21     event CrossDeposit(
22         address trader,
23         address depositToken,
24         uint256 depositAmount
25     );
26     /// emitted whenever a trade happens
27     event CrossTrade(
28         address trader,
29         address inToken,
30         uint256 inTokenAmount,
31         uint256 inTokenBorrow,
32         address outToken,
33         uint256 outTokenAmount,
34         uint256 outTokenExtinguish
35     );
36     /// emitted when a trader withdraws funds
37     event CrossWithdraw(
38         address trader,
39         address withdrawToken,
40         uint256 withdrawAmount
41     );
42     /// emitted upon sucessfully borrowing
43     event CrossBorrow(
44         address trader,
45         address borrowToken,
46         uint256 borrowAmount
47     );
48 
49     /// emmited on deposit-borrow-withdraw
50     event CrossOvercollateralizedBorrow(
51         address trader,
52         address depositToken,
53         uint256 depositAmount,
54         address borrowToken,
55         uint256 withdrawAmount
56     );
57 
58     modifier ensure(uint256 deadline) {
59         require(deadline >= block.timestamp, "Trade has expired");
60         _;
61     }
62 
63     constructor(address _WETH, address _roles) RoleAware(_roles) {
64         WETH = _WETH;
65     }
66 
67     /// @notice traders call this to deposit funds on cross margin
68     function crossDeposit(address depositToken, uint256 depositAmount)
69         external
70     {
71         Fund(fund()).depositFor(msg.sender, depositToken, depositAmount);
72 
73         uint256 extinguishAmount =
74             IMarginTrading(marginTrading()).registerDeposit(
75                 msg.sender,
76                 depositToken,
77                 depositAmount
78             );
79         if (extinguishAmount > 0) {
80             Lending(lending()).payOff(depositToken, extinguishAmount);
81             withdrawClaim(msg.sender, depositToken, extinguishAmount);
82         }
83         emit CrossDeposit(msg.sender, depositToken, depositAmount);
84     }
85 
86     /// @notice deposit wrapped ehtereum into cross margin account
87     function crossDepositETH() external payable {
88         Fund(fund()).depositToWETH{value: msg.value}();
89         uint256 extinguishAmount =
90             IMarginTrading(marginTrading()).registerDeposit(
91                 msg.sender,
92                 WETH,
93                 msg.value
94             );
95         if (extinguishAmount > 0) {
96             Lending(lending()).payOff(WETH, extinguishAmount);
97             withdrawClaim(msg.sender, WETH, extinguishAmount);
98         }
99         emit CrossDeposit(msg.sender, WETH, msg.value);
100     }
101 
102     /// @notice withdraw deposits/earnings from cross margin account
103     function crossWithdraw(address withdrawToken, uint256 withdrawAmount)
104         external
105     {
106         IMarginTrading(marginTrading()).registerWithdrawal(
107             msg.sender,
108             withdrawToken,
109             withdrawAmount
110         );
111         Fund(fund()).withdraw(withdrawToken, msg.sender, withdrawAmount);
112         emit CrossWithdraw(msg.sender, withdrawToken, withdrawAmount);
113     }
114 
115     /// @notice withdraw ethereum from cross margin account
116     function crossWithdrawETH(uint256 withdrawAmount) external {
117         IMarginTrading(marginTrading()).registerWithdrawal(
118             msg.sender,
119             WETH,
120             withdrawAmount
121         );
122         Fund(fund()).withdrawETH(msg.sender, withdrawAmount);
123     }
124 
125     /// @notice borrow into cross margin trading account
126     function crossBorrow(address borrowToken, uint256 borrowAmount) external {
127         Lending(lending()).registerBorrow(borrowToken, borrowAmount);
128         IMarginTrading(marginTrading()).registerBorrow(
129             msg.sender,
130             borrowToken,
131             borrowAmount
132         );
133 
134         stakeClaim(msg.sender, borrowToken, borrowAmount);
135         emit CrossBorrow(msg.sender, borrowToken, borrowAmount);
136     }
137 
138     /// @notice convenience function to perform overcollateralized borrowing
139     /// against a cross margin account.
140     /// @dev caution: the account still has to have a positive balaance at the end
141     /// of the withdraw. So an underwater account may not be able to withdraw
142     function crossOvercollateralizedBorrow(
143         address depositToken,
144         uint256 depositAmount,
145         address borrowToken,
146         uint256 withdrawAmount
147     ) external {
148         Fund(fund()).depositFor(msg.sender, depositToken, depositAmount);
149 
150         Lending(lending()).registerBorrow(borrowToken, withdrawAmount);
151         IMarginTrading(marginTrading()).registerOvercollateralizedBorrow(
152             msg.sender,
153             depositToken,
154             depositAmount,
155             borrowToken,
156             withdrawAmount
157         );
158 
159         Fund(fund()).withdraw(borrowToken, msg.sender, withdrawAmount);
160         stakeClaim(msg.sender, borrowToken, withdrawAmount);
161         emit CrossOvercollateralizedBorrow(
162             msg.sender,
163             depositToken,
164             depositAmount,
165             borrowToken,
166             withdrawAmount
167         );
168     }
169 
170     /// @notice close an account that is no longer borrowing and return gains
171     function crossCloseAccount() external {
172         (address[] memory holdingTokens, uint256[] memory holdingAmounts) =
173             IMarginTrading(marginTrading()).getHoldingAmounts(msg.sender);
174 
175         // requires all debts paid off
176         IMarginTrading(marginTrading()).registerLiquidation(msg.sender);
177 
178         for (uint256 i; holdingTokens.length > i; i++) {
179             Fund(fund()).withdraw(
180                 holdingTokens[i],
181                 msg.sender,
182                 holdingAmounts[i]
183             );
184         }
185     }
186 
187     // **** SWAP ****
188     /// @dev requires the initial amount to have already been sent to the first pair
189     function _swap(
190         uint256[] memory amounts,
191         address[] memory pairs,
192         address[] memory tokens,
193         address _to
194     ) internal virtual {
195         address outToken = tokens[tokens.length - 1];
196         uint256 startingBalance = IERC20(outToken).balanceOf(_to);
197         for (uint256 i; i < pairs.length; i++) {
198             (address input, address output) = (tokens[i], tokens[i + 1]);
199             (address token0, ) = UniswapStyleLib.sortTokens(input, output);
200 
201             uint256 amountOut = amounts[i + 1];
202 
203             (uint256 amount0Out, uint256 amount1Out) =
204                 input == token0
205                     ? (uint256(0), amountOut)
206                     : (amountOut, uint256(0));
207 
208             address to = i < pairs.length - 1 ? pairs[i + 1] : _to;
209             IUniswapV2Pair pair = IUniswapV2Pair(pairs[i]);
210             pair.swap(amount0Out, amount1Out, to, new bytes(0));
211         }
212 
213         uint256 endingBalance = IERC20(outToken).balanceOf(_to);
214         require(
215             endingBalance >= startingBalance + amounts[amounts.length - 1],
216             "Defective AMM route; balances don't match"
217         );
218     }
219 
220     /// @dev internal helper swapping exact token for token on AMM
221     function _swapExactT4T(
222         uint256[] memory amounts,
223         uint256 amountOutMin,
224         address[] calldata pairs,
225         address[] calldata tokens
226     ) internal {
227         require(
228             amounts[amounts.length - 1] >= amountOutMin,
229             "MarginRouter: INSUFFICIENT_OUTPUT_AMOUNT"
230         );
231         Fund(fund()).withdraw(tokens[0], pairs[0], amounts[0]);
232         _swap(amounts, pairs, tokens, fund());
233     }
234 
235     /// @notice make swaps on AMM using protocol funds, only for authorized contracts
236     function authorizedSwapExactT4T(
237         uint256 amountIn,
238         uint256 amountOutMin,
239         address[] calldata pairs,
240         address[] calldata tokens
241     ) external returns (uint256[] memory amounts) {
242         require(
243             isAuthorizedFundTrader(msg.sender),
244             "Calling contract is not authorized to trade with protocl funds"
245         );
246         amounts = UniswapStyleLib.getAmountsOut(amountIn, pairs, tokens);
247         _swapExactT4T(amounts, amountOutMin, pairs, tokens);
248     }
249 
250     // @dev internal helper swapping exact token for token on on AMM
251     function _swapT4ExactT(
252         uint256[] memory amounts,
253         uint256 amountInMax,
254         address[] calldata pairs,
255         address[] calldata tokens
256     ) internal {
257         // TODO minimum trade?
258         require(
259             amounts[0] <= amountInMax,
260             "MarginRouter: EXCESSIVE_INPUT_AMOUNT"
261         );
262         Fund(fund()).withdraw(tokens[0], pairs[0], amounts[0]);
263         _swap(amounts, pairs, tokens, fund());
264     }
265 
266     //// @notice swap protocol funds on AMM, only for authorized
267     function authorizedSwapT4ExactT(
268         uint256 amountOut,
269         uint256 amountInMax,
270         address[] calldata pairs,
271         address[] calldata tokens
272     ) external returns (uint256[] memory amounts) {
273         require(
274             isAuthorizedFundTrader(msg.sender),
275             "Calling contract is not authorized to trade with protocl funds"
276         );
277         amounts = UniswapStyleLib.getAmountsIn(amountOut, pairs, tokens);
278         _swapT4ExactT(amounts, amountInMax, pairs, tokens);
279     }
280 
281     /// @notice entry point for swapping tokens held in cross margin account
282     function crossSwapExactTokensForTokens(
283         uint256 amountIn,
284         uint256 amountOutMin,
285         address[] calldata pairs,
286         address[] calldata tokens,
287         uint256 deadline
288     ) external ensure(deadline) returns (uint256[] memory amounts) {
289         // calc fees
290         uint256 fees = takeFeesFromInput(amountIn);
291 
292         // swap
293         amounts = UniswapStyleLib.getAmountsOut(amountIn - fees, pairs, tokens);
294 
295         // checks that trader is within allowed lending bounds
296         registerTrade(
297             msg.sender,
298             tokens[0],
299             tokens[tokens.length - 1],
300             amountIn,
301             amounts[amounts.length - 1]
302         );
303 
304         _swapExactT4T(amounts, amountOutMin, pairs, tokens);
305     }
306 
307     /// @notice entry point for swapping tokens held in cross margin account
308     function crossSwapTokensForExactTokens(
309         uint256 amountOut,
310         uint256 amountInMax,
311         address[] calldata pairs,
312         address[] calldata tokens,
313         uint256 deadline
314     ) external ensure(deadline) returns (uint256[] memory amounts) {
315         // swap
316         amounts = UniswapStyleLib.getAmountsIn(
317             amountOut + takeFeesFromOutput(amountOut),
318             pairs,
319             tokens
320         );
321 
322         // checks that trader is within allowed lending bounds
323         registerTrade(
324             msg.sender,
325             tokens[0],
326             tokens[tokens.length - 1],
327             amounts[0],
328             amountOut
329         );
330 
331         _swapT4ExactT(amounts, amountInMax, pairs, tokens);
332     }
333 
334     /// @dev helper function does all the work of telling other contracts
335     /// about a trade
336     function registerTrade(
337         address trader,
338         address inToken,
339         address outToken,
340         uint256 inAmount,
341         uint256 outAmount
342     ) internal {
343         (uint256 extinguishAmount, uint256 borrowAmount) =
344             IMarginTrading(marginTrading()).registerTradeAndBorrow(
345                 trader,
346                 inToken,
347                 outToken,
348                 inAmount,
349                 outAmount
350             );
351         if (extinguishAmount > 0) {
352             Lending(lending()).payOff(outToken, extinguishAmount);
353             withdrawClaim(trader, outToken, extinguishAmount);
354         }
355         if (borrowAmount > 0) {
356             Lending(lending()).registerBorrow(inToken, borrowAmount);
357             stakeClaim(trader, inToken, borrowAmount);
358         }
359 
360         emit CrossTrade(
361             trader,
362             inToken,
363             inAmount,
364             borrowAmount,
365             outToken,
366             outAmount,
367             extinguishAmount
368         );
369     }
370 
371     function getAmountsOut(
372         uint256 inAmount,
373         address[] calldata pairs,
374         address[] calldata tokens
375     ) external view returns (uint256[] memory) {
376         return UniswapStyleLib.getAmountsOut(inAmount, pairs, tokens);
377     }
378 
379     function getAmountsIn(
380         uint256 outAmount,
381         address[] calldata pairs,
382         address[] calldata tokens
383     ) external view returns (uint256[] memory) {
384         return UniswapStyleLib.getAmountsIn(outAmount, pairs, tokens);
385     }
386 
387     function takeFeesFromOutput(uint256 amount)
388         internal
389         pure
390         returns (uint256 fees)
391     {
392         fees = (mswapFeesPer10k * amount) / 10_000;
393     }
394 
395     function takeFeesFromInput(uint256 amount)
396         internal
397         pure
398         returns (uint256 fees)
399     {
400         fees = (mswapFeesPer10k * amount) / (10_000 + mswapFeesPer10k);
401     }
402 }
