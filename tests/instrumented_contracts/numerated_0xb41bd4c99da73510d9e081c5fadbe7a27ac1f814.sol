1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.9;
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // File: contracts\weth\IWETH.sol
83 
84 
85 
86 /**
87  * @title IIdeaToken
88  * @author Alexander Schlindwein
89  *
90  * @dev Simplified interface for WETH
91  */
92 interface IWETH {
93     function deposit() external payable;
94     function withdraw(uint wad) external;
95 }
96 
97 // File: contracts\uniswap\IUniswapV2Factory.sol
98 
99 
100 interface IUniswapV2Factory {
101     function getPair(address tokenA, address tokenB) external view returns (address);
102 }
103 
104 // File: contracts\uniswap\IUniswapV2Router01.sol
105 
106 
107 interface IUniswapV2Router01 {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129     function removeLiquidity(
130         address tokenA,
131         address tokenB,
132         uint liquidity,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB);
138     function removeLiquidityETH(
139         address token,
140         uint liquidity,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountToken, uint amountETH);
146     function swapExactTokensForTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external returns (uint[] memory amounts);
153     function swapTokensForExactTokens(
154         uint amountOut,
155         uint amountInMax,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external returns (uint[] memory amounts);
160     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
161         external
162         payable
163         returns (uint[] memory amounts);
164     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
165         external
166         returns (uint[] memory amounts);
167     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
168         external
169         returns (uint[] memory amounts);
170     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
171         external
172         payable
173         returns (uint[] memory amounts);
174     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
175     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
176     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
177     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
178 }
179 
180 // File: contracts\uniswap\IUniswapV2Router02.sol
181 
182 
183 interface IUniswapV2Router02 is IUniswapV2Router01 {
184     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
185         uint amountIn,
186         uint amountOutMin,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external;
191     function swapExactETHForTokensSupportingFeeOnTransferTokens(
192         uint amountOutMin,
193         address[] calldata path,
194         address to,
195         uint deadline
196     ) external payable;
197     function swapExactTokensForETHSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204 }
205 
206 // File: contracts\core\interfaces\IIdeaToken.sol
207 
208 
209 
210 /**
211  * @title IIdeaToken
212  * @author Alexander Schlindwein
213  */
214 interface IIdeaToken is IERC20 {
215     function initialize(string calldata __name, address owner) external;
216     function mint(address account, uint256 amount) external;
217     function burn(address account, uint256 amount) external;
218 }
219 
220 // File: contracts\core\nameVerifiers\IIdeaTokenNameVerifier.sol
221 
222 
223 /**
224  * @title IIdeaTokenNameVerifier
225  * @author Alexander Schlindwein
226  *
227  * Interface for token name verifiers
228  */
229 interface IIdeaTokenNameVerifier {
230     function verifyTokenName(string calldata name) external pure returns (bool);
231 }
232 
233 // File: contracts\core\interfaces\IIdeaTokenFactory.sol
234 
235 
236 
237 
238 
239 
240 /**
241  * @title IIdeaTokenFactory
242  * @author Alexander Schlindwein
243  */
244 
245 struct IDPair {
246     bool exists;
247     uint marketID;
248     uint tokenID;
249 }
250 
251 struct TokenInfo {
252     bool exists;
253     uint id;
254     string name;
255     IIdeaToken ideaToken;
256 }
257 
258 struct MarketDetails {
259     bool exists;
260     uint id;
261     string name;
262 
263     IIdeaTokenNameVerifier nameVerifier;
264     uint numTokens;
265 
266     uint baseCost;
267     uint priceRise;
268     uint hatchTokens;
269     uint tradingFeeRate;
270     uint platformFeeRate;
271 
272     bool allInterestToPlatform;
273 }
274 
275 interface IIdeaTokenFactory {
276     function addMarket(string calldata marketName, address nameVerifier,
277                        uint baseCost, uint priceRise, uint hatchTokens,
278                        uint tradingFeeRate, uint platformFeeRate, bool allInterestToPlatform) external;
279 
280     function addToken(string calldata tokenName, uint marketID, address lister) external;
281 
282     function isValidTokenName(string calldata tokenName, uint marketID) external view returns (bool);
283     function getMarketIDByName(string calldata marketName) external view returns (uint);
284     function getMarketDetailsByID(uint marketID) external view returns (MarketDetails memory);
285     function getMarketDetailsByName(string calldata marketName) external view returns (MarketDetails memory);
286     function getMarketDetailsByTokenAddress(address ideaToken) external view returns (MarketDetails memory);
287     function getNumMarkets() external view returns (uint);
288     function getTokenIDByName(string calldata tokenName, uint marketID) external view returns (uint);
289     function getTokenInfo(uint marketID, uint tokenID) external view returns (TokenInfo memory);
290     function getTokenIDPair(address token) external view returns (IDPair memory);
291     function setTradingFee(uint marketID, uint tradingFeeRate) external;
292     function setPlatformFee(uint marketID, uint platformFeeRate) external;
293     function setNameVerifier(uint marketID, address nameVerifier) external;
294 }
295 
296 // File: contracts\core\interfaces\IIdeaTokenExchange.sol
297 
298 
299 
300 /**
301  * @title IIdeaTokenExchange
302  * @author Alexander Schlindwein
303  */
304 
305 struct CostAndPriceAmounts {
306     uint total;
307     uint raw;
308     uint tradingFee;
309     uint platformFee;
310 }
311 
312 interface IIdeaTokenExchange {
313     function sellTokens(address ideaToken, uint amount, uint minPrice, address recipient) external;
314     function getPriceForSellingTokens(address ideaToken, uint amount) external view returns (uint);
315     function getPricesForSellingTokens(MarketDetails memory marketDetails, uint supply, uint amount, bool feesDisabled) external pure returns (CostAndPriceAmounts memory);
316     function buyTokens(address ideaToken, uint amount, uint fallbackAmount, uint cost, address recipient) external;
317     function getCostForBuyingTokens(address ideaToken, uint amount) external view returns (uint);
318     function getCostsForBuyingTokens(MarketDetails memory marketDetails, uint supply, uint amount, bool feesDisabled) external pure returns (CostAndPriceAmounts memory);
319     function setTokenOwner(address ideaToken, address owner) external;
320     function setPlatformOwner(uint marketID, address owner) external;
321     function withdrawTradingFee() external;
322     function withdrawTokenInterest(address token) external;
323     function withdrawPlatformInterest(uint marketID) external;
324     function withdrawPlatformFee(uint marketID) external;
325     function getInterestPayable(address token) external view returns (uint);
326     function getPlatformInterestPayable(uint marketID) external view returns (uint);
327     function getPlatformFeePayable(uint marketID) external view returns (uint);
328     function getTradingFeePayable() external view returns (uint);
329     function setAuthorizer(address authorizer) external;
330     function isTokenFeeDisabled(address ideaToken) external view returns (bool);
331     function setTokenFeeKillswitch(address ideaToken, bool set) external;
332 }
333 
334 // File: contracts\core\interfaces\IIdeaTokenVault.sol
335 
336 
337 /**
338  * @title IIdeaTokenVault
339  * @author Alexander Schlindwein
340  */
341 
342 struct LockedEntry {
343     uint lockedUntil;
344     uint lockedAmount;
345 }
346     
347 interface IIdeaTokenVault {
348     function lock(address ideaToken, uint amount, uint duration, address recipient) external;
349     function withdraw(address ideaToken, uint[] calldata untils, address recipient) external;
350     function getLockedEntries(address ideaToken, address user, uint maxEntries) external view returns (LockedEntry[] memory);
351 }
352 
353 // File: contracts\core\MultiAction.sol
354 
355 
356 
357 
358 /**
359  * @title MultiAction
360  * @author Alexander Schlindwein
361  *
362  * Allows to bundle multiple actions into one tx
363  */
364 contract MultiAction {
365 
366     // IdeaTokenExchange contract
367     IIdeaTokenExchange _ideaTokenExchange;
368     // IdeaTokenFactory contract
369     IIdeaTokenFactory _ideaTokenFactory;
370     // IdeaTokenVault contract
371     IIdeaTokenVault _ideaTokenVault;
372     // Dai contract
373     IERC20 public _dai;
374     // IUniswapV2Factory contract
375     IUniswapV2Factory public _uniswapV2Factory;
376     // IUniswapV2Router02 contract
377     IUniswapV2Router02 public _uniswapV2Router02;
378     // WETH contract
379     IWETH public _weth;
380 
381     /**
382      * @param ideaTokenExchange The address of the IdeaTokenExchange contract
383      * @param ideaTokenFactory The address of the IdeaTokenFactory contract
384      * @param ideaTokenVault The address of the IdeaTokenVault contract
385      * @param dai The address of the Dai token
386      * @param uniswapV2Router02 The address of the UniswapV2Router02 contract
387      * @param weth The address of the WETH token
388      */
389     constructor(address ideaTokenExchange,
390                 address ideaTokenFactory,
391                 address ideaTokenVault,
392                 address dai,
393                 address uniswapV2Router02,
394                 address weth) public {
395 
396         require(ideaTokenExchange != address(0) &&
397                 ideaTokenFactory != address(0) &&
398                 ideaTokenVault != address(0) &&
399                 dai != address(0) &&
400                 uniswapV2Router02 != address(0) &&
401                 weth != address(0),
402                 "invalid-params");
403 
404         _ideaTokenExchange = IIdeaTokenExchange(ideaTokenExchange);
405         _ideaTokenFactory = IIdeaTokenFactory(ideaTokenFactory);
406         _ideaTokenVault = IIdeaTokenVault(ideaTokenVault);
407         _dai = IERC20(dai);
408         _uniswapV2Router02 = IUniswapV2Router02(uniswapV2Router02);
409         _uniswapV2Factory = IUniswapV2Factory(IUniswapV2Router02(uniswapV2Router02).factory());
410         _weth = IWETH(weth);
411     }
412 
413     /**
414      * Converts inputCurrency to Dai on Uniswap and buys IdeaTokens
415      *
416      * @param inputCurrency The input currency
417      * @param ideaToken The IdeaToken to buy
418      * @param amount The amount of IdeaTokens to buy
419      * @param fallbackAmount The amount of IdeaTokens to buy if the original amount cannot be bought
420      * @param cost The maximum cost in input currency
421      * @param lockDuration The duration in seconds to lock the tokens
422      * @param recipient The recipient of the IdeaTokens
423      */
424     function convertAndBuy(address inputCurrency,
425                            address ideaToken,
426                            uint amount,
427                            uint fallbackAmount,
428                            uint cost,
429                            uint lockDuration,
430                            address recipient) external payable {
431 
432         IIdeaTokenExchange exchange = _ideaTokenExchange;
433 
434         uint buyAmount = amount;
435         uint buyCost = exchange.getCostForBuyingTokens(ideaToken, amount);
436         uint requiredInput = getInputForOutputInternal(inputCurrency, address(_dai), buyCost);
437 
438         if(requiredInput > cost) {
439             buyCost = exchange.getCostForBuyingTokens(ideaToken, fallbackAmount);
440             requiredInput = getInputForOutputInternal(inputCurrency, address(_dai), buyCost);
441             require(requiredInput <= cost, "slippage");
442             buyAmount = fallbackAmount;
443         }
444 
445         convertAndBuyInternal(inputCurrency, ideaToken, requiredInput, buyAmount, buyCost, lockDuration, recipient);
446     }
447 
448     /**
449      * Sells IdeaTokens and converts Dai to outputCurrency
450      *
451      * @param outputCurrency The output currency
452      * @param ideaToken The IdeaToken to sell
453      * @param amount The amount of IdeaTokens to sell
454      * @param minPrice The minimum price to receive for selling in outputCurrency
455      * @param recipient The recipient of the funds
456      */
457     function sellAndConvert(address outputCurrency,
458                             address ideaToken,
459                             uint amount,
460                             uint minPrice,
461                             address payable recipient) external {
462         
463         IIdeaTokenExchange exchange = _ideaTokenExchange;
464         IERC20 dai = _dai;
465 
466         uint sellPrice = exchange.getPriceForSellingTokens(ideaToken, amount);
467         uint output = getOutputForInputInternal(address(dai), outputCurrency, sellPrice);
468         require(output >= minPrice, "slippage");
469 
470         pullERC20Internal(ideaToken, msg.sender, amount);
471         exchange.sellTokens(ideaToken, amount, sellPrice, address(this));
472 
473         convertInternal(address(dai), outputCurrency, sellPrice, output);
474         if(outputCurrency == address(0)) {
475             recipient.transfer(output);
476         } else {
477             require(IERC20(outputCurrency).transfer(recipient, output), "transfer");
478         }
479     }
480 
481     /**
482      * Converts `inputCurrency` to Dai, adds a token and buys the added token
483      * 
484      * @param tokenName The name for the new IdeaToken
485      * @param marketID The ID of the market where the new token will be added
486      * @param inputCurrency The input currency to use for the purchase of the added token
487      * @param amount The amount of IdeaTokens to buy
488      * @param fallbackAmount The amount of IdeaTokens to buy if the original amount cannot be bought
489      * @param cost The maximum cost in input currency
490      * @param lockDuration The duration in seconds to lock the tokens
491      * @param recipient The recipient of the IdeaTokens
492      */
493     function convertAddAndBuy(string calldata tokenName,
494                               uint marketID,
495                               address inputCurrency,
496                               uint amount,
497                               uint fallbackAmount,
498                               uint cost,
499                               uint lockDuration,
500                               address recipient) external payable {
501 
502         IERC20 dai = _dai;
503 
504         uint buyAmount = amount;
505         uint buyCost = getBuyCostFromZeroSupplyInternal(marketID, buyAmount);
506         uint requiredInput = getInputForOutputInternal(inputCurrency, address(dai), buyCost);
507 
508         if(requiredInput > cost) {
509             buyCost = getBuyCostFromZeroSupplyInternal(marketID, fallbackAmount);
510             requiredInput = getInputForOutputInternal(inputCurrency, address(dai), buyCost);
511             require(requiredInput <= cost, "slippage");
512             buyAmount = fallbackAmount;
513         }
514 
515         address ideaToken = addTokenInternal(tokenName, marketID);
516         convertAndBuyInternal(inputCurrency, ideaToken, requiredInput, buyAmount, buyCost, lockDuration, recipient);
517     }
518 
519     /**
520      * Adds a token and buys it
521      * 
522      * @param tokenName The name for the new IdeaToken
523      * @param marketID The ID of the market where the new token will be added
524      * @param amount The amount of IdeaTokens to buy
525      * @param lockDuration The duration in seconds to lock the tokens
526      * @param recipient The recipient of the IdeaTokens
527      */
528     function addAndBuy(string calldata tokenName, uint marketID, uint amount, uint lockDuration, address recipient) external {
529         uint cost = getBuyCostFromZeroSupplyInternal(marketID, amount);
530         pullERC20Internal(address(_dai), msg.sender, cost);
531 
532         address ideaToken = addTokenInternal(tokenName, marketID);
533         
534         if(lockDuration > 0) {
535             buyAndLockInternal(ideaToken, amount, cost, lockDuration, recipient);
536         } else {
537             buyInternal(ideaToken, amount, cost, recipient);
538         }
539     }
540 
541     /**
542      * Buys a IdeaToken and locks it in the IdeaTokenVault
543      *
544      * @param ideaToken The IdeaToken to buy
545      * @param amount The amount of IdeaTokens to buy
546      * @param fallbackAmount The amount of IdeaTokens to buy if the original amount cannot be bought
547      * @param cost The maximum cost in input currency
548      * @param recipient The recipient of the IdeaTokens
549      */
550     function buyAndLock(address ideaToken, uint amount, uint fallbackAmount, uint cost, uint lockDuration, address recipient) external {
551 
552         IIdeaTokenExchange exchange = _ideaTokenExchange;
553 
554         uint buyAmount = amount;
555         uint buyCost = exchange.getCostForBuyingTokens(ideaToken, amount);
556         if(buyCost > cost) {
557             buyCost = exchange.getCostForBuyingTokens(ideaToken, fallbackAmount);
558             require(buyCost <= cost, "slippage");
559             buyAmount = fallbackAmount;
560         }
561 
562         pullERC20Internal(address(_dai), msg.sender, buyCost);
563         buyAndLockInternal(ideaToken, buyAmount, buyCost, lockDuration, recipient);
564     }
565 
566     /**
567      * Converts `inputCurrency` to Dai on Uniswap and buys an IdeaToken, optionally locking it in the IdeaTokenVault
568      *
569      * @param inputCurrency The input currency to use
570      * @param ideaToken The IdeaToken to buy
571      * @param input The amount of `inputCurrency` to sell
572      * @param amount The amount of IdeaTokens to buy
573      * @param cost The cost in Dai for purchasing `amount` IdeaTokens
574      * @param lockDuration The duration in seconds to lock the tokens
575      * @param recipient The recipient of the IdeaTokens
576      */
577     function convertAndBuyInternal(address inputCurrency, address ideaToken, uint input, uint amount, uint cost, uint lockDuration, address recipient) internal {
578         if(inputCurrency != address(0)) {
579             pullERC20Internal(inputCurrency, msg.sender, input);
580         }
581 
582         convertInternal(inputCurrency, address(_dai), input, cost);
583 
584         if(lockDuration > 0) {
585             buyAndLockInternal(ideaToken, amount, cost, lockDuration, recipient);
586         } else {
587             buyInternal(ideaToken, amount, cost, recipient);
588         }
589 
590         /*
591             If the user has paid with ETH and we had to fallback there will be ETH left.
592             Refund the remaining ETH to the user.
593         */
594         if(address(this).balance > 0) {
595             msg.sender.transfer(address(this).balance);
596         }
597     }
598 
599     /**
600      * Buys and locks an IdeaToken in the IdeaTokenVault
601      *
602      * @param ideaToken The IdeaToken to buy
603      * @param amount The amount of IdeaTokens to buy
604      * @param cost The cost in Dai for the purchase of `amount` IdeaTokens
605      * @param recipient The recipient of the locked IdeaTokens
606      */
607     function buyAndLockInternal(address ideaToken, uint amount, uint cost, uint lockDuration, address recipient) internal {
608 
609         IIdeaTokenVault vault = _ideaTokenVault;
610     
611         buyInternal(ideaToken, amount, cost, address(this));
612         require(IERC20(ideaToken).approve(address(vault), amount), "approve");
613         vault.lock(ideaToken, amount, lockDuration, recipient);
614     }
615 
616     /**
617      * Buys an IdeaToken
618      *
619      * @param ideaToken The IdeaToken to buy
620      * @param amount The amount of IdeaTokens to buy
621      * @param cost The cost in Dai for the purchase of `amount` IdeaTokens
622      * @param recipient The recipient of the bought IdeaTokens 
623      */
624     function buyInternal(address ideaToken, uint amount, uint cost, address recipient) internal {
625 
626         IIdeaTokenExchange exchange = _ideaTokenExchange;
627 
628         require(_dai.approve(address(exchange), cost), "approve");
629         exchange.buyTokens(ideaToken, amount, amount, cost, recipient);
630     }
631 
632     /**
633      * Adds a new IdeaToken
634      *
635      * @param tokenName The name of the new token
636      * @param marketID The ID of the market where the new token will be added
637      *
638      * @return The address of the new IdeaToken
639      */
640     function addTokenInternal(string memory tokenName, uint marketID) internal returns (address) {
641 
642         IIdeaTokenFactory factory = _ideaTokenFactory;
643 
644         factory.addToken(tokenName, marketID, msg.sender);
645         return address(factory.getTokenInfo(marketID, factory.getTokenIDByName(tokenName, marketID) ).ideaToken);
646     }
647 
648     /**
649      * Transfers ERC20 from an address to this contract
650      *
651      * @param token The ERC20 token to transfer
652      * @param from The address to transfer from
653      * @param amount The amount of tokens to transfer
654      */
655     function pullERC20Internal(address token, address from, uint amount) internal {
656         require(IERC20(token).allowance(from, address(this)) >= amount, "insufficient-allowance");
657         require(IERC20(token).transferFrom(from, address(this), amount), "transfer");
658     }
659 
660     /**
661      * Returns the cost for buying IdeaTokens on a given market from zero supply
662      *
663      * @param marketID The ID of the market on which the IdeaToken is listed
664      * @param amount The amount of IdeaTokens to buy
665      *
666      * @return The cost for buying IdeaTokens on a given market from zero supply
667      */
668     function getBuyCostFromZeroSupplyInternal(uint marketID, uint amount) internal view returns (uint) {
669         MarketDetails memory marketDetails = _ideaTokenFactory.getMarketDetailsByID(marketID);
670         require(marketDetails.exists, "invalid-market");
671 
672         return _ideaTokenExchange.getCostsForBuyingTokens(marketDetails, 0, amount, false).total;
673     }
674 
675     /**
676      * Returns the required input to get a given output from an Uniswap swap
677      *
678      * @param inputCurrency The input currency
679      * @param outputCurrency The output currency
680      * @param outputAmount The desired output amount 
681      *
682      * @return The required input to get a `outputAmount` from an Uniswap swap
683      */
684     function getInputForOutputInternal(address inputCurrency, address outputCurrency, uint outputAmount) internal view returns (uint) {
685         address[] memory path = getPathInternal(inputCurrency, outputCurrency);
686         return _uniswapV2Router02.getAmountsIn(outputAmount, path)[0];
687     }
688 
689     /**
690      * Returns the output for a given input for an Uniswap swap
691      *
692      * @param inputCurrency The input currency
693      * @param outputCurrency The output currency
694      * @param inputAmount The desired input amount 
695      *
696      * @return The output for `inputAmount` for an Uniswap swap
697      */
698     function getOutputForInputInternal(address inputCurrency, address outputCurrency, uint inputAmount) internal view returns (uint) {
699         address[] memory path = getPathInternal(inputCurrency, outputCurrency);
700         uint[] memory amountsOut = _uniswapV2Router02.getAmountsOut(inputAmount, path);
701         return amountsOut[amountsOut.length - 1];
702     }
703 
704     /**
705      * Returns the Uniswap path from `inputCurrency` to `outputCurrency`
706      *
707      * @param inputCurrency The input currency
708      * @param outputCurrency The output currency
709      *
710      * @return The Uniswap path from `inputCurrency` to `outputCurrency`
711      */
712     function getPathInternal(address inputCurrency, address outputCurrency) internal view returns (address[] memory) {
713 
714         address wethAddress = address(_weth);
715         address updatedInputCurrency = inputCurrency == address(0) ? wethAddress : inputCurrency;
716         address updatedOutputCurrency = outputCurrency == address(0) ? wethAddress : outputCurrency;
717 
718         IUniswapV2Factory uniswapFactory = _uniswapV2Factory;
719         if(uniswapFactory.getPair(updatedInputCurrency, updatedOutputCurrency) != address(0)) {
720             // Direct path exists
721              address[] memory path = new address[](2);
722              path[0] = updatedInputCurrency;
723              path[1] = updatedOutputCurrency;
724              return path;
725         }
726 
727         // Direct path does not exist
728         // Check for 3-hop path: input -> weth -> output
729 
730         require(uniswapFactory.getPair(updatedInputCurrency, wethAddress) != address(0) &&
731                 uniswapFactory.getPair(wethAddress, updatedOutputCurrency) != address(0),
732                 "no-path");
733 
734 
735         // 3-hop path exists
736         address[] memory path = new address[](3);
737         path[0] = updatedInputCurrency;
738         path[1] = wethAddress;
739         path[2] = updatedOutputCurrency;
740 
741         return path;
742     }
743 
744     /**
745      * Converts from `inputCurrency` to `outputCurrency` using Uniswap
746      *
747      * @param inputCurrency The input currency
748      * @param outputCurrency The output currency
749      * @param inputAmount The input amount
750      * @param outputAmount The output amount
751      */
752     function convertInternal(address inputCurrency, address outputCurrency, uint inputAmount, uint outputAmount) internal {
753         
754         IWETH weth = _weth;
755         IUniswapV2Router02 router = _uniswapV2Router02;
756 
757         address[] memory path = getPathInternal(inputCurrency, outputCurrency);
758     
759         IERC20 inputERC20;
760         if(inputCurrency == address(0)) {
761             // If the input is ETH we convert to WETH
762             weth.deposit{value: inputAmount}();
763             inputERC20 = IERC20(address(weth));
764         } else {
765             inputERC20 = IERC20(inputCurrency);
766         }
767 
768         require(inputERC20.approve(address(router), inputAmount), "router-approve");
769 
770         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(inputAmount,
771                                                                      outputAmount,
772                                                                      path,
773                                                                      address(this),
774                                                                      now + 1);
775 
776         if(outputCurrency == address(0)) {
777             // If the output is ETH we withdraw from WETH
778             weth.withdraw(outputAmount);
779         }
780     }
781 
782     /**
783      * Fallback required for WETH withdraw. Fails if sender is not WETH contract
784      */
785     receive() external payable {
786         require(msg.sender == address(_weth));
787     } 
788 }