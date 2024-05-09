1 /**
2 *
3 * https://www.chungalungacoin.com/
4 * https://t.me/chungalunga
5 * https://twitter.com/chungalungacoin
6 *
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
12 
13 pragma solidity >=0.5.0;
14 
15 
16 interface IUniswapV2Factory {
17     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
18 
19     function feeTo() external view returns (address);
20     function feeToSetter() external view returns (address);
21 
22     function getPair(address tokenA, address tokenB) external view returns (address pair);
23     function allPairs(uint) external view returns (address pair);
24     function allPairsLength() external view returns (uint);
25 
26     function createPair(address tokenA, address tokenB) external returns (address pair);
27 
28     function setFeeTo(address) external;
29     function setFeeToSetter(address) external;
30 }
31 
32 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
33 
34 pragma solidity >=0.5.0;
35 
36 
37 interface IUniswapV2Pair {
38     event Approval(address indexed owner, address indexed spender, uint value);
39     event Transfer(address indexed from, address indexed to, uint value);
40 
41     function name() external pure returns (string memory);
42     function symbol() external pure returns (string memory);
43     function decimals() external pure returns (uint8);
44     function totalSupply() external view returns (uint);
45     function balanceOf(address owner) external view returns (uint);
46     function allowance(address owner, address spender) external view returns (uint);
47 
48     function approve(address spender, uint value) external returns (bool);
49     function transfer(address to, uint value) external returns (bool);
50     function transferFrom(address from, address to, uint value) external returns (bool);
51 
52     function DOMAIN_SEPARATOR() external view returns (bytes32);
53     function PERMIT_TYPEHASH() external pure returns (bytes32);
54     function nonces(address owner) external view returns (uint);
55 
56     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
57 
58     event Mint(address indexed sender, uint amount0, uint amount1);
59     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
60     event Swap(
61         address indexed sender,
62         uint amount0In,
63         uint amount1In,
64         uint amount0Out,
65         uint amount1Out,
66         address indexed to
67     );
68     event Sync(uint112 reserve0, uint112 reserve1);
69 
70     function MINIMUM_LIQUIDITY() external pure returns (uint);
71     function factory() external view returns (address);
72     function token0() external view returns (address);
73     function token1() external view returns (address);
74     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
75     function price0CumulativeLast() external view returns (uint);
76     function price1CumulativeLast() external view returns (uint);
77     function kLast() external view returns (uint);
78 
79     function mint(address to) external returns (uint liquidity);
80     function burn(address to) external returns (uint amount0, uint amount1);
81     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
82     function skim(address to) external;
83     function sync() external;
84 
85     function initialize(address, address) external;
86 }
87 
88 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
89 
90 pragma solidity >=0.6.2;
91 
92 
93 interface IUniswapV2Router01 {
94     function factory() external pure returns (address);
95     function WETH() external pure returns (address);
96 
97     function addLiquidity(
98         address tokenA,
99         address tokenB,
100         uint amountADesired,
101         uint amountBDesired,
102         uint amountAMin,
103         uint amountBMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountA, uint amountB, uint liquidity);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115     function removeLiquidity(
116         address tokenA,
117         address tokenB,
118         uint liquidity,
119         uint amountAMin,
120         uint amountBMin,
121         address to,
122         uint deadline
123     ) external returns (uint amountA, uint amountB);
124     function removeLiquidityETH(
125         address token,
126         uint liquidity,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external returns (uint amountToken, uint amountETH);
132     function removeLiquidityWithPermit(
133         address tokenA,
134         address tokenB,
135         uint liquidity,
136         uint amountAMin,
137         uint amountBMin,
138         address to,
139         uint deadline,
140         bool approveMax, uint8 v, bytes32 r, bytes32 s
141     ) external returns (uint amountA, uint amountB);
142     function removeLiquidityETHWithPermit(
143         address token,
144         uint liquidity,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline,
149         bool approveMax, uint8 v, bytes32 r, bytes32 s
150     ) external returns (uint amountToken, uint amountETH);
151     function swapExactTokensForTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external returns (uint[] memory amounts);
158     function swapTokensForExactTokens(
159         uint amountOut,
160         uint amountInMax,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external returns (uint[] memory amounts);
165     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
166         external
167         payable
168         returns (uint[] memory amounts);
169     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
170         external
171         returns (uint[] memory amounts);
172     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
173         external
174         returns (uint[] memory amounts);
175     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
176         external
177         payable
178         returns (uint[] memory amounts);
179 
180     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
181     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
182     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
183     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
184     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
185 }
186 
187 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
188 
189 pragma solidity >=0.6.2;
190 
191 
192 
193 interface IUniswapV2Router02 is IUniswapV2Router01 {
194     function removeLiquidityETHSupportingFeeOnTransferTokens(
195         address token,
196         uint liquidity,
197         uint amountTokenMin,
198         uint amountETHMin,
199         address to,
200         uint deadline
201     ) external returns (uint amountETH);
202     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
203         address token,
204         uint liquidity,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline,
209         bool approveMax, uint8 v, bytes32 r, bytes32 s
210     ) external returns (uint amountETH);
211 
212     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
213         uint amountIn,
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external;
219     function swapExactETHForTokensSupportingFeeOnTransferTokens(
220         uint amountOutMin,
221         address[] calldata path,
222         address to,
223         uint deadline
224     ) external payable;
225     function swapExactTokensForETHSupportingFeeOnTransferTokens(
226         uint amountIn,
227         uint amountOutMin,
228         address[] calldata path,
229         address to,
230         uint deadline
231     ) external;
232 }
233 
234 // File: contracts/interfaces/ISafetyControl.sol
235 
236 pragma solidity ^0.8.3;
237 
238 
239 /**
240  * Enables safety and general transaction restrictions control.
241  * 
242  * Safety control :
243  *  1. enabling/disabling anti pajeet system (APS). Can be called by admins to decide whether additional limitiations to sales should be imposed on not
244  *  2. enabling/disabling trade control  system (TCS).
245  *  3. enabling/disabling sending of tokens between accounts
246  *  
247  * General control:
248  *  1. presale period. During presale all taxes are disabled
249  *  2. trade. Before trade is open, no transactions are allowed
250  *  3. LP state control. Before LP has been created, trade cannot be opened.
251  * 
252  */
253 interface ISafetyControl {
254 
255     /**
256     * Defines state of APS after change of some of properties.
257     * Properties:
258     *   - enabled -> is APS enabled
259     *   - thresh -> number of tokens(in wei). If one holds more that this number than he cannot sell more than 20% of his tokens at once
260     *   - interval -> number of minutes between two consecutive sales
261     */
262     event APSStateUpdate (
263         bool enabled,
264         uint256 thresh,
265         uint256 interval
266     );
267     
268     /**
269      * Enables/disables Anti pajeet system.
270      * If enabled it will impose sale restrictions:
271      *   - cannot sell more than 0.2% of total supply at once
272 	 *   - if owns more than 1% total supply:
273 	 *	    - can sell at most 20% at once (but not more than 0.2 of total supply)
274 	 *	    - can sell once every hour
275      * 
276      * emits APSStateUpdate
277 	 * 
278 	 * @param enabled   Defines state of APS. true or false
279      */
280     function setAPS(bool enabled) external;
281 
282     /**
283      * Enables/disables Trade Control System.
284      * If enabled it will impose sale restrictions:
285      *   - max TX will be checked
286 	 *   - holders will not be able to purchase and hold more than _holderLimit tokens
287 	 *	 - single account can sell once every 2 mins
288 	 * 
289 	 * @param enabled   Defines state of TCS. true or false
290      */
291     function setTCS(bool enabled) external;
292 
293     /**
294      * Defines new Anti pajeet system threshold in percentage. Value supports single digit, Meaning 10 means 1%.
295      * Examples:
296      *    to set 1%: 10
297      *    to set 0.1%: 1
298      * 
299      * emits APSStateUpdate
300      *
301 	 * @param thresh  New threshold in percentage of total supply. Value supports single digit.
302      */
303     function setAPSThreshPercent(uint256 thresh) external;
304 
305     /**
306     * Defines new Anti pajeet system threshold in tokens. Minimal amount is 1000 tokens
307     * 
308     * emits APSStateUpdate
309     *
310 	* @param thresh  New threshold in token amount
311     */
312     function setAPSThreshAmount(uint256 thresh) external;
313 
314     /**
315     * Sets new interval user will have to wait in between two consecutive sales, if APS is enabled.
316     * Default value is 1 hour
317     * 
318     * 
319     * emits APSStateUpdate
320     *
321     * @param interval   interval between two consecutive sales, in minutes. E.g. 60 means 1 hour
322     */
323     function setAPSInterval(uint256 interval) external;
324     
325     /**
326      * Upon start of presale all taxes are disabled
327 	 * Once presale is stopped, taxes are enabled once more
328 	 * 
329 	 * @param start     Defines state of Presale. started or stopped
330      */
331     function setPreSale(bool start) external;
332     
333     /**
334      * Only once trading is open will transactions be allowed. 
335      * Trading is disabled by default.
336      * Liquidity MUST be proviided before trading can be opened
337      *
338      * @param on    true if trade is to be opened, otherwise false
339      */
340     function tradeCtrl(bool on) external;
341 
342     /**
343     * Enables/disables sharing of tokens between accounts.
344     * If enabled, sending tokens from one account to another is permitted. 
345     * If disabled, sending tokens from one account to another will be blocked.
346     *
347     * @param enabled    True if sending between account is permitter, otherwise false      
348     */
349     function setAccountShare(bool enabled) external;
350 
351 }
352 // File: contracts/interfaces/IFeeControl.sol
353 
354 pragma solidity ^0.8.3;
355 
356 
357 /**
358  * Defines control over:
359  *  - who will be paying fees
360  *  - when will fees be applied
361  */
362 interface IFeeControl {
363     event ExcludeFromFees (
364         address indexed account,
365         bool isExcluded
366     );
367     
368     event TakeFeeOnlyOnSwap (
369         bool enabled
370     );
371 	
372 	event MinTokensBeforeSwapUpdated (
373         uint256 minTokensBeforeSwap
374     );
375     
376     /**
377      * Exclude or include account in fee system. Excluded accounts don't pay any fee.
378      *
379      * @param account   Account address
380      * @param exclude   If true account will be excluded, otherwise it will be included in fee
381      */
382     function feeControl(address account, bool exclude) external;
383 
384     /**
385      * Is account excluded from paying fees?
386      *
387      * @param account   Account address
388      */
389     function isExcludedFromFee(address account) external view returns(bool);
390     /**
391      * Taking fee only on swaps.
392      * Emits TakeFeeOnlyOnSwap(true) event.
393      * 
394      * @param onSwap    Take fee only on swap (true) or always (false)
395      */
396      function takeFeeOnlyOnSwap(bool onSwap) external;
397      
398     /**
399 	* Changes number of tokens collected before swap can be triggered
400     * - emits MinTokensBeforeSwapUpdated event
401     *
402     * @param thresh     New number of tokens that must be collected before swap is triggered
403 	*/
404 	function changeSwapThresh(uint256 thresh) external;
405 }
406 // File: contracts/interfaces/IFee.sol
407 
408 pragma solidity ^0.8.3;
409 
410 
411 /**
412  * Defines Fees:
413  *  - marketing
414  *  - liquidity
415  * All fees are using 1 decimal: 1000 means 100%, 100 means 10%, 10 means 1%, 1 means 0.1%
416  */
417 interface IFee {
418     /**
419      * Struct of fees.
420      */
421     struct Fees {
422       uint256 marketingFee;
423       uint256 liquidityFee;
424     }
425     
426     /**
427      * Marketing wallet can be changed
428      *
429      * @param newWallet     Address of new marketing wallet
430      */
431     function changeMarketingWallet(address newWallet) external;
432 
433     /**
434 	* Changing fees. Distinguishes between buy and sell fees
435     *
436     * @param liquidityFee   New liquidity fee in percentage written as integer divisible by 1000. E.g. 5% => 0.05 => 50/1000 => 50
437     * @param marketingFee   New marketing fee in percentage written as integer divisible by 1000. E.g. 5% => 0.05 => 50/1000 => 50
438     * @param isBuy          Are fees for buy or not(for sale)
439 	*/
440     function setFees(uint256 liquidityFee, uint256 marketingFee, bool isBuy)  external;
441     
442     /**
443      * Control whether tokens collected from fees will be automatically swapped or not
444      *
445      * @param enable        True if swap should be enabled, otherwise false
446      */
447     function setSwapOfFeeTokens(bool enable) external;
448 }
449 // File: contracts/interfaces/IBlacklisting.sol
450 
451 pragma solidity ^0.8.3;
452 
453 
454 /**
455  * Some blacklisting/whitelisting functionalities:
456  *  - adding account to list of blacklisted/whitelisted accounts
457  *  - removing account from list of blacklisted/whitelisted accounts
458  *  - check whether account is blacklisted/whitelisted accounts (against internal list)
459  */
460 interface IBlacklisting {
461 
462     /**
463     * Sent once address is blacklisted.
464     */
465     event BlacklistedAddress(
466         address account
467     );
468 
469     /**
470      * Define account status in blacklist
471 	 *
472 	 * @param account   Account to be added or removed to/from blacklist
473 	 * @param add       Should account be added or removed from blacklist
474      */
475     function setBlacklist(address account, bool add) external;
476 
477     /**
478      * Define account status in whitelist
479 	 *
480 	 * @param account   Account to be added or removed to/from whitelist
481 	 * @param add       Should account be added or removed from whitelist
482      */
483     function setWhitelist(address account, bool add) external;
484     /**
485      * Checks whether account is blacklisted
486      */
487     function isBlacklisted(address account) external view returns(bool);
488 	/**
489      * Checks whether account is whitelisted
490      */
491     function isWhitelisted(address account) external view returns(bool);
492 
493     /**
494     *  Define fee charged to blacklist. Fee supports singe decimal place, i.e it should be multiplied by 10 to get unsigned int: 100 means 10%, 10 means 1% and 1 means 0.1%
495     */
496     function setBlacklistFee(uint256 blacklistFee) external;
497     
498 }
499 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
508  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
509  *
510  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
511  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
512  * need to send a transaction, and thus is not required to hold Ether at all.
513  */
514 interface IERC20Permit {
515     /**
516      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
517      * given ``owner``'s signed approval.
518      *
519      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
520      * ordering also apply here.
521      *
522      * Emits an {Approval} event.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      * - `deadline` must be a timestamp in the future.
528      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
529      * over the EIP712-formatted function arguments.
530      * - the signature must use ``owner``'s current nonce (see {nonces}).
531      *
532      * For more information on the signature format, see the
533      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
534      * section].
535      */
536     function permit(
537         address owner,
538         address spender,
539         uint256 value,
540         uint256 deadline,
541         uint8 v,
542         bytes32 r,
543         bytes32 s
544     ) external;
545 
546     /**
547      * @dev Returns the current nonce for `owner`. This value must be
548      * included whenever a signature is generated for {permit}.
549      *
550      * Every successful call to {permit} increases ``owner``'s nonce by one. This
551      * prevents a signature from being used multiple times.
552      */
553     function nonces(address owner) external view returns (uint256);
554 
555     /**
556      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
557      */
558     // solhint-disable-next-line func-name-mixedcase
559     function DOMAIN_SEPARATOR() external view returns (bytes32);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Interface of the ERC20 standard as defined in the EIP.
571  */
572 interface IERC20 {
573     /**
574      * @dev Emitted when `value` tokens are moved from one account (`from`) to
575      * another (`to`).
576      *
577      * Note that `value` may be zero.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 value);
580 
581     /**
582      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
583      * a call to {approve}. `value` is the new allowance.
584      */
585     event Approval(address indexed owner, address indexed spender, uint256 value);
586 
587     /**
588      * @dev Returns the amount of tokens in existence.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     /**
593      * @dev Returns the amount of tokens owned by `account`.
594      */
595     function balanceOf(address account) external view returns (uint256);
596 
597     /**
598      * @dev Moves `amount` tokens from the caller's account to `to`.
599      *
600      * Returns a boolean value indicating whether the operation succeeded.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transfer(address to, uint256 amount) external returns (bool);
605 
606     /**
607      * @dev Returns the remaining number of tokens that `spender` will be
608      * allowed to spend on behalf of `owner` through {transferFrom}. This is
609      * zero by default.
610      *
611      * This value changes when {approve} or {transferFrom} are called.
612      */
613     function allowance(address owner, address spender) external view returns (uint256);
614 
615     /**
616      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
617      *
618      * Returns a boolean value indicating whether the operation succeeded.
619      *
620      * IMPORTANT: Beware that changing an allowance with this method brings the risk
621      * that someone may use both the old and the new allowance by unfortunate
622      * transaction ordering. One possible solution to mitigate this race
623      * condition is to first reduce the spender's allowance to 0 and set the
624      * desired value afterwards:
625      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address spender, uint256 amount) external returns (bool);
630 
631     /**
632      * @dev Moves `amount` tokens from `from` to `to` using the
633      * allowance mechanism. `amount` is then deducted from the caller's
634      * allowance.
635      *
636      * Returns a boolean value indicating whether the operation succeeded.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 amount
644     ) external returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Interface for the optional metadata functions from the ERC20 standard.
657  *
658  * _Available since v4.1._
659  */
660 interface IERC20Metadata is IERC20 {
661     /**
662      * @dev Returns the name of the token.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the symbol of the token.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the decimals places of the token.
673      */
674     function decimals() external view returns (uint8);
675 }
676 
677 // File: contracts/interfaces/IChungalunga.sol
678 
679 pragma solidity ^0.8.3;
680 
681 
682 
683 
684 
685 
686 
687 interface IChungalunga is IERC20, IERC20Metadata, IBlacklisting, ISafetyControl, IFee, IFeeControl {
688     
689     event UpdateSwapV2Router (
690         address indexed newAddress
691     );
692     
693     event SwapAndLiquifyEnabledUpdated (
694         bool enabled
695     );
696 
697     event MarketingSwap (
698         uint256 tokensSwapped,
699         uint256 ethReceived,
700         bool success
701     );
702     
703     event SwapAndLiquify (
704         uint256 tokensSwapped,
705         uint256 ethReceived,
706         uint256 tokensIntoLiqudity
707     );
708 
709     /**
710     * Defines new state of properties TCS uses after some property was changed
711     * Properties:
712     *   - enabled ->is TCS system enabled
713     *   - maxTxLimit -> max number of tokens (in wei) one can sell/buy at once
714     *   - holderLimit -> max number of tokens one account can hold
715     *   - interval ->interval between two consecutive sales in minutes
716     */
717     event TCSStateUpdate (
718         bool enabled,
719         uint256 maxTxLimit,
720         uint256 holderLimit,
721         uint256 interval
722     );
723 
724 
725     /**
726     * (un)Setting *swapV2Pair address.
727     *
728     * @param pair       address of AMM pair
729     * @param value      true if it's to be treated as AMM pair, otherwise false
730     */
731     function setLPP(address pair, bool value) external;
732     
733     /**
734      * Max TX can be set either by providing percentage of total supply or exact amount.
735      *
736      * !MAX TX percentage MUST be between 1 and 10!
737      * 
738      * emits TCSStateUpdate
739      *
740      * @param maxTxPercent    new percentage used to calculate max number of tokens that can be transferred at the same time
741      */
742     function setMaxTxPercent(uint256 maxTxPercent) external;
743     /**
744      * max TX can be set either by providing percentage of total supply or exact amount.
745      *
746      * emits TCSStateUpdate
747      *
748      * @param maxTxAmount    new max number of tokens that can be transferred at the same time
749      */
750     function setMaxTxAmount(uint256 maxTxAmount) external;
751 
752     /**
753      * Excluded accounts are not limited by max TX amount.
754 	 * Included accounts are limited by max TX amount.
755      *
756      * @param account   account address
757      * @param exclude   true if account is to be excluded from max TX control. Otherwise false
758      */
759     function maxTxControl(address account, bool exclude) external;
760     /**
761      * Is account excluded from MAX TX limitations?
762      *
763      * @param account   account address
764      * @return          true if account is excluded, otherwise false
765      */
766     function isExcludedFromMaxTx(address account) external view returns(bool);
767 
768     /**
769     * Defines new limit to max token amount holder can possess.
770     *
771     * ! Holder limit MUST be greater than 0.5% total supply
772     *
773     * emits TCSStateUpdate
774     *
775     * @param limit      Max number of tokens one holder can possess
776     */
777     function setHolderLimit(uint256 limit) external;
778     
779     /**
780      * Once set, LP provisioning from liquidity fees will start. 
781      * Disabled by default. 
782      * Must be called manually
783      * - emits SwapAndLiquifyEnabledUpdated event
784      *
785      * @param enabled   true if swap is enabled, otherwise false
786      */
787     function setSwapAndLiquifyEnabled(bool enabled) external;
788     
789     /**
790      * It will exclude sale helper router address and presale router address from fee's and rewards
791      *
792      * @param helperRouter  address of router used by helper 
793      * @param presaleRouter address of presale router(contract) used by helper 
794      */
795     function setHelperSaleAddress(address helperRouter, address presaleRouter) external;
796     
797     /**
798      * Any leftover coin balance on contract can be transferred (withdrawn) to chosen account.
799      * Used to clear contract state.
800      *
801      * @param recipient     address of recipient
802      */
803     function withdrawLocked(address payable recipient) external;
804 
805     /**
806      * Function to withdraw collected fees to marketing wallet in case automatic swap is disabled.
807      * 
808      * ! Will fail it swap is not disabled
809      */
810     function withdrawFees() external;
811     
812     /**
813      * Updates address of V2 swap router
814      * - emits UpdateSwapV2Router event
815      *
816      * @param newAddress    address of swap router
817      */
818     function updateSwapV2Router(address newAddress) external;
819 
820     /**
821      * Starts whitelisted process. 
822      * Whitelisted process will is valid for limited time only starting from current time. 
823      * It will last for at most provided duration in minutes.
824      *
825      * @param duration      Duration in minutes. 
826      */
827     function wlProcess(uint256 duration) external;    
828 }
829 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
830 
831 
832 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 // CAUTION
837 // This version of SafeMath should only be used with Solidity 0.8 or later,
838 // because it relies on the compiler's built in overflow checks.
839 
840 /**
841  * @dev Wrappers over Solidity's arithmetic operations.
842  *
843  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
844  * now has built in overflow checking.
845  */
846 library SafeMath {
847     /**
848      * @dev Returns the addition of two unsigned integers, with an overflow flag.
849      *
850      * _Available since v3.4._
851      */
852     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
853         unchecked {
854             uint256 c = a + b;
855             if (c < a) return (false, 0);
856             return (true, c);
857         }
858     }
859 
860     /**
861      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
862      *
863      * _Available since v3.4._
864      */
865     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
866         unchecked {
867             if (b > a) return (false, 0);
868             return (true, a - b);
869         }
870     }
871 
872     /**
873      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
874      *
875      * _Available since v3.4._
876      */
877     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
878         unchecked {
879             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
880             // benefit is lost if 'b' is also tested.
881             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
882             if (a == 0) return (true, 0);
883             uint256 c = a * b;
884             if (c / a != b) return (false, 0);
885             return (true, c);
886         }
887     }
888 
889     /**
890      * @dev Returns the division of two unsigned integers, with a division by zero flag.
891      *
892      * _Available since v3.4._
893      */
894     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
895         unchecked {
896             if (b == 0) return (false, 0);
897             return (true, a / b);
898         }
899     }
900 
901     /**
902      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
903      *
904      * _Available since v3.4._
905      */
906     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
907         unchecked {
908             if (b == 0) return (false, 0);
909             return (true, a % b);
910         }
911     }
912 
913     /**
914      * @dev Returns the addition of two unsigned integers, reverting on
915      * overflow.
916      *
917      * Counterpart to Solidity's `+` operator.
918      *
919      * Requirements:
920      *
921      * - Addition cannot overflow.
922      */
923     function add(uint256 a, uint256 b) internal pure returns (uint256) {
924         return a + b;
925     }
926 
927     /**
928      * @dev Returns the subtraction of two unsigned integers, reverting on
929      * overflow (when the result is negative).
930      *
931      * Counterpart to Solidity's `-` operator.
932      *
933      * Requirements:
934      *
935      * - Subtraction cannot overflow.
936      */
937     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
938         return a - b;
939     }
940 
941     /**
942      * @dev Returns the multiplication of two unsigned integers, reverting on
943      * overflow.
944      *
945      * Counterpart to Solidity's `*` operator.
946      *
947      * Requirements:
948      *
949      * - Multiplication cannot overflow.
950      */
951     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
952         return a * b;
953     }
954 
955     /**
956      * @dev Returns the integer division of two unsigned integers, reverting on
957      * division by zero. The result is rounded towards zero.
958      *
959      * Counterpart to Solidity's `/` operator.
960      *
961      * Requirements:
962      *
963      * - The divisor cannot be zero.
964      */
965     function div(uint256 a, uint256 b) internal pure returns (uint256) {
966         return a / b;
967     }
968 
969     /**
970      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
971      * reverting when dividing by zero.
972      *
973      * Counterpart to Solidity's `%` operator. This function uses a `revert`
974      * opcode (which leaves remaining gas untouched) while Solidity uses an
975      * invalid opcode to revert (consuming all remaining gas).
976      *
977      * Requirements:
978      *
979      * - The divisor cannot be zero.
980      */
981     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
982         return a % b;
983     }
984 
985     /**
986      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
987      * overflow (when the result is negative).
988      *
989      * CAUTION: This function is deprecated because it requires allocating memory for the error
990      * message unnecessarily. For custom revert reasons use {trySub}.
991      *
992      * Counterpart to Solidity's `-` operator.
993      *
994      * Requirements:
995      *
996      * - Subtraction cannot overflow.
997      */
998     function sub(
999         uint256 a,
1000         uint256 b,
1001         string memory errorMessage
1002     ) internal pure returns (uint256) {
1003         unchecked {
1004             require(b <= a, errorMessage);
1005             return a - b;
1006         }
1007     }
1008 
1009     /**
1010      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1011      * division by zero. The result is rounded towards zero.
1012      *
1013      * Counterpart to Solidity's `/` operator. Note: this function uses a
1014      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1015      * uses an invalid opcode to revert (consuming all remaining gas).
1016      *
1017      * Requirements:
1018      *
1019      * - The divisor cannot be zero.
1020      */
1021     function div(
1022         uint256 a,
1023         uint256 b,
1024         string memory errorMessage
1025     ) internal pure returns (uint256) {
1026         unchecked {
1027             require(b > 0, errorMessage);
1028             return a / b;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1034      * reverting with custom message when dividing by zero.
1035      *
1036      * CAUTION: This function is deprecated because it requires allocating memory for the error
1037      * message unnecessarily. For custom revert reasons use {tryMod}.
1038      *
1039      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1040      * opcode (which leaves remaining gas untouched) while Solidity uses an
1041      * invalid opcode to revert (consuming all remaining gas).
1042      *
1043      * Requirements:
1044      *
1045      * - The divisor cannot be zero.
1046      */
1047     function mod(
1048         uint256 a,
1049         uint256 b,
1050         string memory errorMessage
1051     ) internal pure returns (uint256) {
1052         unchecked {
1053             require(b > 0, errorMessage);
1054             return a % b;
1055         }
1056     }
1057 }
1058 
1059 // File: @openzeppelin/contracts/utils/Address.sol
1060 
1061 
1062 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1063 
1064 pragma solidity ^0.8.1;
1065 
1066 /**
1067  * @dev Collection of functions related to the address type
1068  */
1069 library Address {
1070     /**
1071      * @dev Returns true if `account` is a contract.
1072      *
1073      * [IMPORTANT]
1074      * ====
1075      * It is unsafe to assume that an address for which this function returns
1076      * false is an externally-owned account (EOA) and not a contract.
1077      *
1078      * Among others, `isContract` will return false for the following
1079      * types of addresses:
1080      *
1081      *  - an externally-owned account
1082      *  - a contract in construction
1083      *  - an address where a contract will be created
1084      *  - an address where a contract lived, but was destroyed
1085      * ====
1086      *
1087      * [IMPORTANT]
1088      * ====
1089      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1090      *
1091      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1092      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1093      * constructor.
1094      * ====
1095      */
1096     function isContract(address account) internal view returns (bool) {
1097         // This method relies on extcodesize/address.code.length, which returns 0
1098         // for contracts in construction, since the code is only stored at the end
1099         // of the constructor execution.
1100 
1101         return account.code.length > 0;
1102     }
1103 
1104     /**
1105      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1106      * `recipient`, forwarding all available gas and reverting on errors.
1107      *
1108      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1109      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1110      * imposed by `transfer`, making them unable to receive funds via
1111      * `transfer`. {sendValue} removes this limitation.
1112      *
1113      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1114      *
1115      * IMPORTANT: because control is transferred to `recipient`, care must be
1116      * taken to not create reentrancy vulnerabilities. Consider using
1117      * {ReentrancyGuard} or the
1118      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1119      */
1120     function sendValue(address payable recipient, uint256 amount) internal {
1121         require(address(this).balance >= amount, "Address: insufficient balance");
1122 
1123         (bool success, ) = recipient.call{value: amount}("");
1124         require(success, "Address: unable to send value, recipient may have reverted");
1125     }
1126 
1127     /**
1128      * @dev Performs a Solidity function call using a low level `call`. A
1129      * plain `call` is an unsafe replacement for a function call: use this
1130      * function instead.
1131      *
1132      * If `target` reverts with a revert reason, it is bubbled up by this
1133      * function (like regular Solidity function calls).
1134      *
1135      * Returns the raw returned data. To convert to the expected return value,
1136      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1137      *
1138      * Requirements:
1139      *
1140      * - `target` must be a contract.
1141      * - calling `target` with `data` must not revert.
1142      *
1143      * _Available since v3.1._
1144      */
1145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1146         return functionCall(target, data, "Address: low-level call failed");
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1151      * `errorMessage` as a fallback revert reason when `target` reverts.
1152      *
1153      * _Available since v3.1._
1154      */
1155     function functionCall(
1156         address target,
1157         bytes memory data,
1158         string memory errorMessage
1159     ) internal returns (bytes memory) {
1160         return functionCallWithValue(target, data, 0, errorMessage);
1161     }
1162 
1163     /**
1164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1165      * but also transferring `value` wei to `target`.
1166      *
1167      * Requirements:
1168      *
1169      * - the calling contract must have an ETH balance of at least `value`.
1170      * - the called Solidity function must be `payable`.
1171      *
1172      * _Available since v3.1._
1173      */
1174     function functionCallWithValue(
1175         address target,
1176         bytes memory data,
1177         uint256 value
1178     ) internal returns (bytes memory) {
1179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1180     }
1181 
1182     /**
1183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1184      * with `errorMessage` as a fallback revert reason when `target` reverts.
1185      *
1186      * _Available since v3.1._
1187      */
1188     function functionCallWithValue(
1189         address target,
1190         bytes memory data,
1191         uint256 value,
1192         string memory errorMessage
1193     ) internal returns (bytes memory) {
1194         require(address(this).balance >= value, "Address: insufficient balance for call");
1195         require(isContract(target), "Address: call to non-contract");
1196 
1197         (bool success, bytes memory returndata) = target.call{value: value}(data);
1198         return verifyCallResult(success, returndata, errorMessage);
1199     }
1200 
1201     /**
1202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1203      * but performing a static call.
1204      *
1205      * _Available since v3.3._
1206      */
1207     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1208         return functionStaticCall(target, data, "Address: low-level static call failed");
1209     }
1210 
1211     /**
1212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1213      * but performing a static call.
1214      *
1215      * _Available since v3.3._
1216      */
1217     function functionStaticCall(
1218         address target,
1219         bytes memory data,
1220         string memory errorMessage
1221     ) internal view returns (bytes memory) {
1222         require(isContract(target), "Address: static call to non-contract");
1223 
1224         (bool success, bytes memory returndata) = target.staticcall(data);
1225         return verifyCallResult(success, returndata, errorMessage);
1226     }
1227 
1228     /**
1229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1230      * but performing a delegate call.
1231      *
1232      * _Available since v3.4._
1233      */
1234     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1235         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1236     }
1237 
1238     /**
1239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1240      * but performing a delegate call.
1241      *
1242      * _Available since v3.4._
1243      */
1244     function functionDelegateCall(
1245         address target,
1246         bytes memory data,
1247         string memory errorMessage
1248     ) internal returns (bytes memory) {
1249         require(isContract(target), "Address: delegate call to non-contract");
1250 
1251         (bool success, bytes memory returndata) = target.delegatecall(data);
1252         return verifyCallResult(success, returndata, errorMessage);
1253     }
1254 
1255     /**
1256      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1257      * revert reason using the provided one.
1258      *
1259      * _Available since v4.3._
1260      */
1261     function verifyCallResult(
1262         bool success,
1263         bytes memory returndata,
1264         string memory errorMessage
1265     ) internal pure returns (bytes memory) {
1266         if (success) {
1267             return returndata;
1268         } else {
1269             // Look for revert reason and bubble it up if present
1270             if (returndata.length > 0) {
1271                 // The easiest way to bubble the revert reason is using memory via assembly
1272                 /// @solidity memory-safe-assembly
1273                 assembly {
1274                     let returndata_size := mload(returndata)
1275                     revert(add(32, returndata), returndata_size)
1276                 }
1277             } else {
1278                 revert(errorMessage);
1279             }
1280         }
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1285 
1286 
1287 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 
1292 
1293 
1294 /**
1295  * @title SafeERC20
1296  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1297  * contract returns false). Tokens that return no value (and instead revert or
1298  * throw on failure) are also supported, non-reverting calls are assumed to be
1299  * successful.
1300  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1301  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1302  */
1303 library SafeERC20 {
1304     using Address for address;
1305 
1306     function safeTransfer(
1307         IERC20 token,
1308         address to,
1309         uint256 value
1310     ) internal {
1311         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1312     }
1313 
1314     function safeTransferFrom(
1315         IERC20 token,
1316         address from,
1317         address to,
1318         uint256 value
1319     ) internal {
1320         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1321     }
1322 
1323     /**
1324      * @dev Deprecated. This function has issues similar to the ones found in
1325      * {IERC20-approve}, and its usage is discouraged.
1326      *
1327      * Whenever possible, use {safeIncreaseAllowance} and
1328      * {safeDecreaseAllowance} instead.
1329      */
1330     function safeApprove(
1331         IERC20 token,
1332         address spender,
1333         uint256 value
1334     ) internal {
1335         // safeApprove should only be called when setting an initial allowance,
1336         // or when resetting it to zero. To increase and decrease it, use
1337         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1338         require(
1339             (value == 0) || (token.allowance(address(this), spender) == 0),
1340             "SafeERC20: approve from non-zero to non-zero allowance"
1341         );
1342         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1343     }
1344 
1345     function safeIncreaseAllowance(
1346         IERC20 token,
1347         address spender,
1348         uint256 value
1349     ) internal {
1350         uint256 newAllowance = token.allowance(address(this), spender) + value;
1351         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1352     }
1353 
1354     function safeDecreaseAllowance(
1355         IERC20 token,
1356         address spender,
1357         uint256 value
1358     ) internal {
1359         unchecked {
1360             uint256 oldAllowance = token.allowance(address(this), spender);
1361             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1362             uint256 newAllowance = oldAllowance - value;
1363             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1364         }
1365     }
1366 
1367     function safePermit(
1368         IERC20Permit token,
1369         address owner,
1370         address spender,
1371         uint256 value,
1372         uint256 deadline,
1373         uint8 v,
1374         bytes32 r,
1375         bytes32 s
1376     ) internal {
1377         uint256 nonceBefore = token.nonces(owner);
1378         token.permit(owner, spender, value, deadline, v, r, s);
1379         uint256 nonceAfter = token.nonces(owner);
1380         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1381     }
1382 
1383     /**
1384      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1385      * on the return value: the return value is optional (but if data is returned, it must not be false).
1386      * @param token The token targeted by the call.
1387      * @param data The call data (encoded using abi.encode or one of its variants).
1388      */
1389     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1390         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1391         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1392         // the target address contains contract code and also asserts for success in the low-level call.
1393 
1394         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1395         if (returndata.length > 0) {
1396             // Return data is optional
1397             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1398         }
1399     }
1400 }
1401 
1402 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
1403 
1404 
1405 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 /**
1410  * @dev Library for managing
1411  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1412  * types.
1413  *
1414  * Sets have the following properties:
1415  *
1416  * - Elements are added, removed, and checked for existence in constant time
1417  * (O(1)).
1418  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1419  *
1420  * ```
1421  * contract Example {
1422  *     // Add the library methods
1423  *     using EnumerableSet for EnumerableSet.AddressSet;
1424  *
1425  *     // Declare a set state variable
1426  *     EnumerableSet.AddressSet private mySet;
1427  * }
1428  * ```
1429  *
1430  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1431  * and `uint256` (`UintSet`) are supported.
1432  *
1433  * [WARNING]
1434  * ====
1435  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
1436  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1437  *
1438  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
1439  * ====
1440  */
1441 library EnumerableSet {
1442     // To implement this library for multiple types with as little code
1443     // repetition as possible, we write it in terms of a generic Set type with
1444     // bytes32 values.
1445     // The Set implementation uses private functions, and user-facing
1446     // implementations (such as AddressSet) are just wrappers around the
1447     // underlying Set.
1448     // This means that we can only create new EnumerableSets for types that fit
1449     // in bytes32.
1450 
1451     struct Set {
1452         // Storage of set values
1453         bytes32[] _values;
1454         // Position of the value in the `values` array, plus 1 because index 0
1455         // means a value is not in the set.
1456         mapping(bytes32 => uint256) _indexes;
1457     }
1458 
1459     /**
1460      * @dev Add a value to a set. O(1).
1461      *
1462      * Returns true if the value was added to the set, that is if it was not
1463      * already present.
1464      */
1465     function _add(Set storage set, bytes32 value) private returns (bool) {
1466         if (!_contains(set, value)) {
1467             set._values.push(value);
1468             // The value is stored at length-1, but we add 1 to all indexes
1469             // and use 0 as a sentinel value
1470             set._indexes[value] = set._values.length;
1471             return true;
1472         } else {
1473             return false;
1474         }
1475     }
1476 
1477     /**
1478      * @dev Removes a value from a set. O(1).
1479      *
1480      * Returns true if the value was removed from the set, that is if it was
1481      * present.
1482      */
1483     function _remove(Set storage set, bytes32 value) private returns (bool) {
1484         // We read and store the value's index to prevent multiple reads from the same storage slot
1485         uint256 valueIndex = set._indexes[value];
1486 
1487         if (valueIndex != 0) {
1488             // Equivalent to contains(set, value)
1489             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1490             // the array, and then remove the last element (sometimes called as 'swap and pop').
1491             // This modifies the order of the array, as noted in {at}.
1492 
1493             uint256 toDeleteIndex = valueIndex - 1;
1494             uint256 lastIndex = set._values.length - 1;
1495 
1496             if (lastIndex != toDeleteIndex) {
1497                 bytes32 lastValue = set._values[lastIndex];
1498 
1499                 // Move the last value to the index where the value to delete is
1500                 set._values[toDeleteIndex] = lastValue;
1501                 // Update the index for the moved value
1502                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1503             }
1504 
1505             // Delete the slot where the moved value was stored
1506             set._values.pop();
1507 
1508             // Delete the index for the deleted slot
1509             delete set._indexes[value];
1510 
1511             return true;
1512         } else {
1513             return false;
1514         }
1515     }
1516 
1517     /**
1518      * @dev Returns true if the value is in the set. O(1).
1519      */
1520     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1521         return set._indexes[value] != 0;
1522     }
1523 
1524     /**
1525      * @dev Returns the number of values on the set. O(1).
1526      */
1527     function _length(Set storage set) private view returns (uint256) {
1528         return set._values.length;
1529     }
1530 
1531     /**
1532      * @dev Returns the value stored at position `index` in the set. O(1).
1533      *
1534      * Note that there are no guarantees on the ordering of values inside the
1535      * array, and it may change when more values are added or removed.
1536      *
1537      * Requirements:
1538      *
1539      * - `index` must be strictly less than {length}.
1540      */
1541     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1542         return set._values[index];
1543     }
1544 
1545     /**
1546      * @dev Return the entire set in an array
1547      *
1548      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1549      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1550      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1551      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1552      */
1553     function _values(Set storage set) private view returns (bytes32[] memory) {
1554         return set._values;
1555     }
1556 
1557     // Bytes32Set
1558 
1559     struct Bytes32Set {
1560         Set _inner;
1561     }
1562 
1563     /**
1564      * @dev Add a value to a set. O(1).
1565      *
1566      * Returns true if the value was added to the set, that is if it was not
1567      * already present.
1568      */
1569     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1570         return _add(set._inner, value);
1571     }
1572 
1573     /**
1574      * @dev Removes a value from a set. O(1).
1575      *
1576      * Returns true if the value was removed from the set, that is if it was
1577      * present.
1578      */
1579     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1580         return _remove(set._inner, value);
1581     }
1582 
1583     /**
1584      * @dev Returns true if the value is in the set. O(1).
1585      */
1586     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1587         return _contains(set._inner, value);
1588     }
1589 
1590     /**
1591      * @dev Returns the number of values in the set. O(1).
1592      */
1593     function length(Bytes32Set storage set) internal view returns (uint256) {
1594         return _length(set._inner);
1595     }
1596 
1597     /**
1598      * @dev Returns the value stored at position `index` in the set. O(1).
1599      *
1600      * Note that there are no guarantees on the ordering of values inside the
1601      * array, and it may change when more values are added or removed.
1602      *
1603      * Requirements:
1604      *
1605      * - `index` must be strictly less than {length}.
1606      */
1607     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1608         return _at(set._inner, index);
1609     }
1610 
1611     /**
1612      * @dev Return the entire set in an array
1613      *
1614      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1615      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1616      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1617      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1618      */
1619     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1620         return _values(set._inner);
1621     }
1622 
1623     // AddressSet
1624 
1625     struct AddressSet {
1626         Set _inner;
1627     }
1628 
1629     /**
1630      * @dev Add a value to a set. O(1).
1631      *
1632      * Returns true if the value was added to the set, that is if it was not
1633      * already present.
1634      */
1635     function add(AddressSet storage set, address value) internal returns (bool) {
1636         return _add(set._inner, bytes32(uint256(uint160(value))));
1637     }
1638 
1639     /**
1640      * @dev Removes a value from a set. O(1).
1641      *
1642      * Returns true if the value was removed from the set, that is if it was
1643      * present.
1644      */
1645     function remove(AddressSet storage set, address value) internal returns (bool) {
1646         return _remove(set._inner, bytes32(uint256(uint160(value))));
1647     }
1648 
1649     /**
1650      * @dev Returns true if the value is in the set. O(1).
1651      */
1652     function contains(AddressSet storage set, address value) internal view returns (bool) {
1653         return _contains(set._inner, bytes32(uint256(uint160(value))));
1654     }
1655 
1656     /**
1657      * @dev Returns the number of values in the set. O(1).
1658      */
1659     function length(AddressSet storage set) internal view returns (uint256) {
1660         return _length(set._inner);
1661     }
1662 
1663     /**
1664      * @dev Returns the value stored at position `index` in the set. O(1).
1665      *
1666      * Note that there are no guarantees on the ordering of values inside the
1667      * array, and it may change when more values are added or removed.
1668      *
1669      * Requirements:
1670      *
1671      * - `index` must be strictly less than {length}.
1672      */
1673     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1674         return address(uint160(uint256(_at(set._inner, index))));
1675     }
1676 
1677     /**
1678      * @dev Return the entire set in an array
1679      *
1680      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1681      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1682      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1683      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1684      */
1685     function values(AddressSet storage set) internal view returns (address[] memory) {
1686         bytes32[] memory store = _values(set._inner);
1687         address[] memory result;
1688 
1689         /// @solidity memory-safe-assembly
1690         assembly {
1691             result := store
1692         }
1693 
1694         return result;
1695     }
1696 
1697     // UintSet
1698 
1699     struct UintSet {
1700         Set _inner;
1701     }
1702 
1703     /**
1704      * @dev Add a value to a set. O(1).
1705      *
1706      * Returns true if the value was added to the set, that is if it was not
1707      * already present.
1708      */
1709     function add(UintSet storage set, uint256 value) internal returns (bool) {
1710         return _add(set._inner, bytes32(value));
1711     }
1712 
1713     /**
1714      * @dev Removes a value from a set. O(1).
1715      *
1716      * Returns true if the value was removed from the set, that is if it was
1717      * present.
1718      */
1719     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1720         return _remove(set._inner, bytes32(value));
1721     }
1722 
1723     /**
1724      * @dev Returns true if the value is in the set. O(1).
1725      */
1726     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1727         return _contains(set._inner, bytes32(value));
1728     }
1729 
1730     /**
1731      * @dev Returns the number of values on the set. O(1).
1732      */
1733     function length(UintSet storage set) internal view returns (uint256) {
1734         return _length(set._inner);
1735     }
1736 
1737     /**
1738      * @dev Returns the value stored at position `index` in the set. O(1).
1739      *
1740      * Note that there are no guarantees on the ordering of values inside the
1741      * array, and it may change when more values are added or removed.
1742      *
1743      * Requirements:
1744      *
1745      * - `index` must be strictly less than {length}.
1746      */
1747     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1748         return uint256(_at(set._inner, index));
1749     }
1750 
1751     /**
1752      * @dev Return the entire set in an array
1753      *
1754      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1755      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1756      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1757      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1758      */
1759     function values(UintSet storage set) internal view returns (uint256[] memory) {
1760         bytes32[] memory store = _values(set._inner);
1761         uint256[] memory result;
1762 
1763         /// @solidity memory-safe-assembly
1764         assembly {
1765             result := store
1766         }
1767 
1768         return result;
1769     }
1770 }
1771 
1772 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1773 
1774 
1775 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1776 
1777 pragma solidity ^0.8.0;
1778 
1779 /**
1780  * @dev Interface of the ERC165 standard, as defined in the
1781  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1782  *
1783  * Implementers can declare support of contract interfaces, which can then be
1784  * queried by others ({ERC165Checker}).
1785  *
1786  * For an implementation, see {ERC165}.
1787  */
1788 interface IERC165 {
1789     /**
1790      * @dev Returns true if this contract implements the interface defined by
1791      * `interfaceId`. See the corresponding
1792      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1793      * to learn more about how these ids are created.
1794      *
1795      * This function call must use less than 30 000 gas.
1796      */
1797     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1798 }
1799 
1800 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1801 
1802 
1803 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1804 
1805 pragma solidity ^0.8.0;
1806 
1807 
1808 /**
1809  * @dev Implementation of the {IERC165} interface.
1810  *
1811  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1812  * for the additional interface id that will be supported. For example:
1813  *
1814  * ```solidity
1815  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1816  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1817  * }
1818  * ```
1819  *
1820  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1821  */
1822 abstract contract ERC165 is IERC165 {
1823     /**
1824      * @dev See {IERC165-supportsInterface}.
1825      */
1826     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1827         return interfaceId == type(IERC165).interfaceId;
1828     }
1829 }
1830 
1831 // File: @openzeppelin/contracts/utils/Strings.sol
1832 
1833 
1834 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1835 
1836 pragma solidity ^0.8.0;
1837 
1838 /**
1839  * @dev String operations.
1840  */
1841 library Strings {
1842     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1843     uint8 private constant _ADDRESS_LENGTH = 20;
1844 
1845     /**
1846      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1847      */
1848     function toString(uint256 value) internal pure returns (string memory) {
1849         // Inspired by OraclizeAPI's implementation - MIT licence
1850         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1851 
1852         if (value == 0) {
1853             return "0";
1854         }
1855         uint256 temp = value;
1856         uint256 digits;
1857         while (temp != 0) {
1858             digits++;
1859             temp /= 10;
1860         }
1861         bytes memory buffer = new bytes(digits);
1862         while (value != 0) {
1863             digits -= 1;
1864             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1865             value /= 10;
1866         }
1867         return string(buffer);
1868     }
1869 
1870     /**
1871      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1872      */
1873     function toHexString(uint256 value) internal pure returns (string memory) {
1874         if (value == 0) {
1875             return "0x00";
1876         }
1877         uint256 temp = value;
1878         uint256 length = 0;
1879         while (temp != 0) {
1880             length++;
1881             temp >>= 8;
1882         }
1883         return toHexString(value, length);
1884     }
1885 
1886     /**
1887      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1888      */
1889     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1890         bytes memory buffer = new bytes(2 * length + 2);
1891         buffer[0] = "0";
1892         buffer[1] = "x";
1893         for (uint256 i = 2 * length + 1; i > 1; --i) {
1894             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1895             value >>= 4;
1896         }
1897         require(value == 0, "Strings: hex length insufficient");
1898         return string(buffer);
1899     }
1900 
1901     /**
1902      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1903      */
1904     function toHexString(address addr) internal pure returns (string memory) {
1905         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1906     }
1907 }
1908 
1909 // File: @openzeppelin/contracts/access/IAccessControl.sol
1910 
1911 
1912 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1913 
1914 pragma solidity ^0.8.0;
1915 
1916 /**
1917  * @dev External interface of AccessControl declared to support ERC165 detection.
1918  */
1919 interface IAccessControl {
1920     /**
1921      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1922      *
1923      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1924      * {RoleAdminChanged} not being emitted signaling this.
1925      *
1926      * _Available since v3.1._
1927      */
1928     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1929 
1930     /**
1931      * @dev Emitted when `account` is granted `role`.
1932      *
1933      * `sender` is the account that originated the contract call, an admin role
1934      * bearer except when using {AccessControl-_setupRole}.
1935      */
1936     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1937 
1938     /**
1939      * @dev Emitted when `account` is revoked `role`.
1940      *
1941      * `sender` is the account that originated the contract call:
1942      *   - if using `revokeRole`, it is the admin role bearer
1943      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1944      */
1945     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1946 
1947     /**
1948      * @dev Returns `true` if `account` has been granted `role`.
1949      */
1950     function hasRole(bytes32 role, address account) external view returns (bool);
1951 
1952     /**
1953      * @dev Returns the admin role that controls `role`. See {grantRole} and
1954      * {revokeRole}.
1955      *
1956      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1957      */
1958     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1959 
1960     /**
1961      * @dev Grants `role` to `account`.
1962      *
1963      * If `account` had not been already granted `role`, emits a {RoleGranted}
1964      * event.
1965      *
1966      * Requirements:
1967      *
1968      * - the caller must have ``role``'s admin role.
1969      */
1970     function grantRole(bytes32 role, address account) external;
1971 
1972     /**
1973      * @dev Revokes `role` from `account`.
1974      *
1975      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1976      *
1977      * Requirements:
1978      *
1979      * - the caller must have ``role``'s admin role.
1980      */
1981     function revokeRole(bytes32 role, address account) external;
1982 
1983     /**
1984      * @dev Revokes `role` from the calling account.
1985      *
1986      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1987      * purpose is to provide a mechanism for accounts to lose their privileges
1988      * if they are compromised (such as when a trusted device is misplaced).
1989      *
1990      * If the calling account had been granted `role`, emits a {RoleRevoked}
1991      * event.
1992      *
1993      * Requirements:
1994      *
1995      * - the caller must be `account`.
1996      */
1997     function renounceRole(bytes32 role, address account) external;
1998 }
1999 
2000 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
2001 
2002 
2003 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
2004 
2005 pragma solidity ^0.8.0;
2006 
2007 
2008 /**
2009  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2010  */
2011 interface IAccessControlEnumerable is IAccessControl {
2012     /**
2013      * @dev Returns one of the accounts that have `role`. `index` must be a
2014      * value between 0 and {getRoleMemberCount}, non-inclusive.
2015      *
2016      * Role bearers are not sorted in any particular way, and their ordering may
2017      * change at any point.
2018      *
2019      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2020      * you perform all queries on the same block. See the following
2021      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2022      * for more information.
2023      */
2024     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2025 
2026     /**
2027      * @dev Returns the number of accounts that have `role`. Can be used
2028      * together with {getRoleMember} to enumerate all bearers of a role.
2029      */
2030     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2031 }
2032 
2033 // File: @openzeppelin/contracts/utils/Context.sol
2034 
2035 
2036 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2037 
2038 pragma solidity ^0.8.0;
2039 
2040 /**
2041  * @dev Provides information about the current execution context, including the
2042  * sender of the transaction and its data. While these are generally available
2043  * via msg.sender and msg.data, they should not be accessed in such a direct
2044  * manner, since when dealing with meta-transactions the account sending and
2045  * paying for execution may not be the actual sender (as far as an application
2046  * is concerned).
2047  *
2048  * This contract is only required for intermediate, library-like contracts.
2049  */
2050 abstract contract Context {
2051     function _msgSender() internal view virtual returns (address) {
2052         return msg.sender;
2053     }
2054 
2055     function _msgData() internal view virtual returns (bytes calldata) {
2056         return msg.data;
2057     }
2058 }
2059 
2060 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2061 
2062 
2063 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
2064 
2065 pragma solidity ^0.8.0;
2066 
2067 
2068 
2069 
2070 /**
2071  * @dev Implementation of the {IERC20} interface.
2072  *
2073  * This implementation is agnostic to the way tokens are created. This means
2074  * that a supply mechanism has to be added in a derived contract using {_mint}.
2075  * For a generic mechanism see {ERC20PresetMinterPauser}.
2076  *
2077  * TIP: For a detailed writeup see our guide
2078  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2079  * to implement supply mechanisms].
2080  *
2081  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2082  * instead returning `false` on failure. This behavior is nonetheless
2083  * conventional and does not conflict with the expectations of ERC20
2084  * applications.
2085  *
2086  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2087  * This allows applications to reconstruct the allowance for all accounts just
2088  * by listening to said events. Other implementations of the EIP may not emit
2089  * these events, as it isn't required by the specification.
2090  *
2091  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2092  * functions have been added to mitigate the well-known issues around setting
2093  * allowances. See {IERC20-approve}.
2094  */
2095 contract ERC20 is Context, IERC20, IERC20Metadata {
2096     mapping(address => uint256) private _balances;
2097 
2098     mapping(address => mapping(address => uint256)) private _allowances;
2099 
2100     uint256 private _totalSupply;
2101 
2102     string private _name;
2103     string private _symbol;
2104 
2105     /**
2106      * @dev Sets the values for {name} and {symbol}.
2107      *
2108      * The default value of {decimals} is 18. To select a different value for
2109      * {decimals} you should overload it.
2110      *
2111      * All two of these values are immutable: they can only be set once during
2112      * construction.
2113      */
2114     constructor(string memory name_, string memory symbol_) {
2115         _name = name_;
2116         _symbol = symbol_;
2117     }
2118 
2119     /**
2120      * @dev Returns the name of the token.
2121      */
2122     function name() public view virtual override returns (string memory) {
2123         return _name;
2124     }
2125 
2126     /**
2127      * @dev Returns the symbol of the token, usually a shorter version of the
2128      * name.
2129      */
2130     function symbol() public view virtual override returns (string memory) {
2131         return _symbol;
2132     }
2133 
2134     /**
2135      * @dev Returns the number of decimals used to get its user representation.
2136      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2137      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2138      *
2139      * Tokens usually opt for a value of 18, imitating the relationship between
2140      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2141      * overridden;
2142      *
2143      * NOTE: This information is only used for _display_ purposes: it in
2144      * no way affects any of the arithmetic of the contract, including
2145      * {IERC20-balanceOf} and {IERC20-transfer}.
2146      */
2147     function decimals() public view virtual override returns (uint8) {
2148         return 18;
2149     }
2150 
2151     /**
2152      * @dev See {IERC20-totalSupply}.
2153      */
2154     function totalSupply() public view virtual override returns (uint256) {
2155         return _totalSupply;
2156     }
2157 
2158     /**
2159      * @dev See {IERC20-balanceOf}.
2160      */
2161     function balanceOf(address account) public view virtual override returns (uint256) {
2162         return _balances[account];
2163     }
2164 
2165     /**
2166      * @dev See {IERC20-transfer}.
2167      *
2168      * Requirements:
2169      *
2170      * - `to` cannot be the zero address.
2171      * - the caller must have a balance of at least `amount`.
2172      */
2173     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2174         address owner = _msgSender();
2175         _transfer(owner, to, amount);
2176         return true;
2177     }
2178 
2179     /**
2180      * @dev See {IERC20-allowance}.
2181      */
2182     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2183         return _allowances[owner][spender];
2184     }
2185 
2186     /**
2187      * @dev See {IERC20-approve}.
2188      *
2189      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2190      * `transferFrom`. This is semantically equivalent to an infinite approval.
2191      *
2192      * Requirements:
2193      *
2194      * - `spender` cannot be the zero address.
2195      */
2196     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2197         address owner = _msgSender();
2198         _approve(owner, spender, amount);
2199         return true;
2200     }
2201 
2202     /**
2203      * @dev See {IERC20-transferFrom}.
2204      *
2205      * Emits an {Approval} event indicating the updated allowance. This is not
2206      * required by the EIP. See the note at the beginning of {ERC20}.
2207      *
2208      * NOTE: Does not update the allowance if the current allowance
2209      * is the maximum `uint256`.
2210      *
2211      * Requirements:
2212      *
2213      * - `from` and `to` cannot be the zero address.
2214      * - `from` must have a balance of at least `amount`.
2215      * - the caller must have allowance for ``from``'s tokens of at least
2216      * `amount`.
2217      */
2218     function transferFrom(
2219         address from,
2220         address to,
2221         uint256 amount
2222     ) public virtual override returns (bool) {
2223         address spender = _msgSender();
2224         _spendAllowance(from, spender, amount);
2225         _transfer(from, to, amount);
2226         return true;
2227     }
2228 
2229     /**
2230      * @dev Atomically increases the allowance granted to `spender` by the caller.
2231      *
2232      * This is an alternative to {approve} that can be used as a mitigation for
2233      * problems described in {IERC20-approve}.
2234      *
2235      * Emits an {Approval} event indicating the updated allowance.
2236      *
2237      * Requirements:
2238      *
2239      * - `spender` cannot be the zero address.
2240      */
2241     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2242         address owner = _msgSender();
2243         _approve(owner, spender, allowance(owner, spender) + addedValue);
2244         return true;
2245     }
2246 
2247     /**
2248      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2249      *
2250      * This is an alternative to {approve} that can be used as a mitigation for
2251      * problems described in {IERC20-approve}.
2252      *
2253      * Emits an {Approval} event indicating the updated allowance.
2254      *
2255      * Requirements:
2256      *
2257      * - `spender` cannot be the zero address.
2258      * - `spender` must have allowance for the caller of at least
2259      * `subtractedValue`.
2260      */
2261     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2262         address owner = _msgSender();
2263         uint256 currentAllowance = allowance(owner, spender);
2264         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2265         unchecked {
2266             _approve(owner, spender, currentAllowance - subtractedValue);
2267         }
2268 
2269         return true;
2270     }
2271 
2272     /**
2273      * @dev Moves `amount` of tokens from `from` to `to`.
2274      *
2275      * This internal function is equivalent to {transfer}, and can be used to
2276      * e.g. implement automatic token fees, slashing mechanisms, etc.
2277      *
2278      * Emits a {Transfer} event.
2279      *
2280      * Requirements:
2281      *
2282      * - `from` cannot be the zero address.
2283      * - `to` cannot be the zero address.
2284      * - `from` must have a balance of at least `amount`.
2285      */
2286     function _transfer(
2287         address from,
2288         address to,
2289         uint256 amount
2290     ) internal virtual {
2291         require(from != address(0), "ERC20: transfer from the zero address");
2292         require(to != address(0), "ERC20: transfer to the zero address");
2293 
2294         _beforeTokenTransfer(from, to, amount);
2295 
2296         uint256 fromBalance = _balances[from];
2297         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2298         unchecked {
2299             _balances[from] = fromBalance - amount;
2300         }
2301         _balances[to] += amount;
2302 
2303         emit Transfer(from, to, amount);
2304 
2305         _afterTokenTransfer(from, to, amount);
2306     }
2307 
2308     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2309      * the total supply.
2310      *
2311      * Emits a {Transfer} event with `from` set to the zero address.
2312      *
2313      * Requirements:
2314      *
2315      * - `account` cannot be the zero address.
2316      */
2317     function _mint(address account, uint256 amount) internal virtual {
2318         require(account != address(0), "ERC20: mint to the zero address");
2319 
2320         _beforeTokenTransfer(address(0), account, amount);
2321 
2322         _totalSupply += amount;
2323         _balances[account] += amount;
2324         emit Transfer(address(0), account, amount);
2325 
2326         _afterTokenTransfer(address(0), account, amount);
2327     }
2328 
2329     /**
2330      * @dev Destroys `amount` tokens from `account`, reducing the
2331      * total supply.
2332      *
2333      * Emits a {Transfer} event with `to` set to the zero address.
2334      *
2335      * Requirements:
2336      *
2337      * - `account` cannot be the zero address.
2338      * - `account` must have at least `amount` tokens.
2339      */
2340     function _burn(address account, uint256 amount) internal virtual {
2341         require(account != address(0), "ERC20: burn from the zero address");
2342 
2343         _beforeTokenTransfer(account, address(0), amount);
2344 
2345         uint256 accountBalance = _balances[account];
2346         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2347         unchecked {
2348             _balances[account] = accountBalance - amount;
2349         }
2350         _totalSupply -= amount;
2351 
2352         emit Transfer(account, address(0), amount);
2353 
2354         _afterTokenTransfer(account, address(0), amount);
2355     }
2356 
2357     /**
2358      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2359      *
2360      * This internal function is equivalent to `approve`, and can be used to
2361      * e.g. set automatic allowances for certain subsystems, etc.
2362      *
2363      * Emits an {Approval} event.
2364      *
2365      * Requirements:
2366      *
2367      * - `owner` cannot be the zero address.
2368      * - `spender` cannot be the zero address.
2369      */
2370     function _approve(
2371         address owner,
2372         address spender,
2373         uint256 amount
2374     ) internal virtual {
2375         require(owner != address(0), "ERC20: approve from the zero address");
2376         require(spender != address(0), "ERC20: approve to the zero address");
2377 
2378         _allowances[owner][spender] = amount;
2379         emit Approval(owner, spender, amount);
2380     }
2381 
2382     /**
2383      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2384      *
2385      * Does not update the allowance amount in case of infinite allowance.
2386      * Revert if not enough allowance is available.
2387      *
2388      * Might emit an {Approval} event.
2389      */
2390     function _spendAllowance(
2391         address owner,
2392         address spender,
2393         uint256 amount
2394     ) internal virtual {
2395         uint256 currentAllowance = allowance(owner, spender);
2396         if (currentAllowance != type(uint256).max) {
2397             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2398             unchecked {
2399                 _approve(owner, spender, currentAllowance - amount);
2400             }
2401         }
2402     }
2403 
2404     /**
2405      * @dev Hook that is called before any transfer of tokens. This includes
2406      * minting and burning.
2407      *
2408      * Calling conditions:
2409      *
2410      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2411      * will be transferred to `to`.
2412      * - when `from` is zero, `amount` tokens will be minted for `to`.
2413      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2414      * - `from` and `to` are never both zero.
2415      *
2416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2417      */
2418     function _beforeTokenTransfer(
2419         address from,
2420         address to,
2421         uint256 amount
2422     ) internal virtual {}
2423 
2424     /**
2425      * @dev Hook that is called after any transfer of tokens. This includes
2426      * minting and burning.
2427      *
2428      * Calling conditions:
2429      *
2430      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2431      * has been transferred to `to`.
2432      * - when `from` is zero, `amount` tokens have been minted for `to`.
2433      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2434      * - `from` and `to` are never both zero.
2435      *
2436      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2437      */
2438     function _afterTokenTransfer(
2439         address from,
2440         address to,
2441         uint256 amount
2442     ) internal virtual {}
2443 }
2444 
2445 // File: @openzeppelin/contracts/access/Ownable.sol
2446 
2447 
2448 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2449 
2450 pragma solidity ^0.8.0;
2451 
2452 
2453 /**
2454  * @dev Contract module which provides a basic access control mechanism, where
2455  * there is an account (an owner) that can be granted exclusive access to
2456  * specific functions.
2457  *
2458  * By default, the owner account will be the one that deploys the contract. This
2459  * can later be changed with {transferOwnership}.
2460  *
2461  * This module is used through inheritance. It will make available the modifier
2462  * `onlyOwner`, which can be applied to your functions to restrict their use to
2463  * the owner.
2464  */
2465 abstract contract Ownable is Context {
2466     address private _owner;
2467 
2468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2469 
2470     /**
2471      * @dev Initializes the contract setting the deployer as the initial owner.
2472      */
2473     constructor() {
2474         _transferOwnership(_msgSender());
2475     }
2476 
2477     /**
2478      * @dev Throws if called by any account other than the owner.
2479      */
2480     modifier onlyOwner() {
2481         _checkOwner();
2482         _;
2483     }
2484 
2485     /**
2486      * @dev Returns the address of the current owner.
2487      */
2488     function owner() public view virtual returns (address) {
2489         return _owner;
2490     }
2491 
2492     /**
2493      * @dev Throws if the sender is not the owner.
2494      */
2495     function _checkOwner() internal view virtual {
2496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2497     }
2498 
2499     /**
2500      * @dev Leaves the contract without owner. It will not be possible to call
2501      * `onlyOwner` functions anymore. Can only be called by the current owner.
2502      *
2503      * NOTE: Renouncing ownership will leave the contract without an owner,
2504      * thereby removing any functionality that is only available to the owner.
2505      */
2506     function renounceOwnership() public virtual onlyOwner {
2507         _transferOwnership(address(0));
2508     }
2509 
2510     /**
2511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2512      * Can only be called by the current owner.
2513      */
2514     function transferOwnership(address newOwner) public virtual onlyOwner {
2515         require(newOwner != address(0), "Ownable: new owner is the zero address");
2516         _transferOwnership(newOwner);
2517     }
2518 
2519     /**
2520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2521      * Internal function without access restriction.
2522      */
2523     function _transferOwnership(address newOwner) internal virtual {
2524         address oldOwner = _owner;
2525         _owner = newOwner;
2526         emit OwnershipTransferred(oldOwner, newOwner);
2527     }
2528 }
2529 
2530 // File: @openzeppelin/contracts/access/AccessControl.sol
2531 
2532 
2533 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
2534 
2535 pragma solidity ^0.8.0;
2536 
2537 
2538 
2539 
2540 
2541 /**
2542  * @dev Contract module that allows children to implement role-based access
2543  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2544  * members except through off-chain means by accessing the contract event logs. Some
2545  * applications may benefit from on-chain enumerability, for those cases see
2546  * {AccessControlEnumerable}.
2547  *
2548  * Roles are referred to by their `bytes32` identifier. These should be exposed
2549  * in the external API and be unique. The best way to achieve this is by
2550  * using `public constant` hash digests:
2551  *
2552  * ```
2553  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2554  * ```
2555  *
2556  * Roles can be used to represent a set of permissions. To restrict access to a
2557  * function call, use {hasRole}:
2558  *
2559  * ```
2560  * function foo() public {
2561  *     require(hasRole(MY_ROLE, msg.sender));
2562  *     ...
2563  * }
2564  * ```
2565  *
2566  * Roles can be granted and revoked dynamically via the {grantRole} and
2567  * {revokeRole} functions. Each role has an associated admin role, and only
2568  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2569  *
2570  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2571  * that only accounts with this role will be able to grant or revoke other
2572  * roles. More complex role relationships can be created by using
2573  * {_setRoleAdmin}.
2574  *
2575  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2576  * grant and revoke this role. Extra precautions should be taken to secure
2577  * accounts that have been granted it.
2578  */
2579 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2580     struct RoleData {
2581         mapping(address => bool) members;
2582         bytes32 adminRole;
2583     }
2584 
2585     mapping(bytes32 => RoleData) private _roles;
2586 
2587     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2588 
2589     /**
2590      * @dev Modifier that checks that an account has a specific role. Reverts
2591      * with a standardized message including the required role.
2592      *
2593      * The format of the revert reason is given by the following regular expression:
2594      *
2595      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2596      *
2597      * _Available since v4.1._
2598      */
2599     modifier onlyRole(bytes32 role) {
2600         _checkRole(role);
2601         _;
2602     }
2603 
2604     /**
2605      * @dev See {IERC165-supportsInterface}.
2606      */
2607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2608         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2609     }
2610 
2611     /**
2612      * @dev Returns `true` if `account` has been granted `role`.
2613      */
2614     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2615         return _roles[role].members[account];
2616     }
2617 
2618     /**
2619      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2620      * Overriding this function changes the behavior of the {onlyRole} modifier.
2621      *
2622      * Format of the revert message is described in {_checkRole}.
2623      *
2624      * _Available since v4.6._
2625      */
2626     function _checkRole(bytes32 role) internal view virtual {
2627         _checkRole(role, _msgSender());
2628     }
2629 
2630     /**
2631      * @dev Revert with a standard message if `account` is missing `role`.
2632      *
2633      * The format of the revert reason is given by the following regular expression:
2634      *
2635      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2636      */
2637     function _checkRole(bytes32 role, address account) internal view virtual {
2638         if (!hasRole(role, account)) {
2639             revert(
2640                 string(
2641                     abi.encodePacked(
2642                         "AccessControl: account ",
2643                         Strings.toHexString(uint160(account), 20),
2644                         " is missing role ",
2645                         Strings.toHexString(uint256(role), 32)
2646                     )
2647                 )
2648             );
2649         }
2650     }
2651 
2652     /**
2653      * @dev Returns the admin role that controls `role`. See {grantRole} and
2654      * {revokeRole}.
2655      *
2656      * To change a role's admin, use {_setRoleAdmin}.
2657      */
2658     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2659         return _roles[role].adminRole;
2660     }
2661 
2662     /**
2663      * @dev Grants `role` to `account`.
2664      *
2665      * If `account` had not been already granted `role`, emits a {RoleGranted}
2666      * event.
2667      *
2668      * Requirements:
2669      *
2670      * - the caller must have ``role``'s admin role.
2671      *
2672      * May emit a {RoleGranted} event.
2673      */
2674     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2675         _grantRole(role, account);
2676     }
2677 
2678     /**
2679      * @dev Revokes `role` from `account`.
2680      *
2681      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2682      *
2683      * Requirements:
2684      *
2685      * - the caller must have ``role``'s admin role.
2686      *
2687      * May emit a {RoleRevoked} event.
2688      */
2689     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2690         _revokeRole(role, account);
2691     }
2692 
2693     /**
2694      * @dev Revokes `role` from the calling account.
2695      *
2696      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2697      * purpose is to provide a mechanism for accounts to lose their privileges
2698      * if they are compromised (such as when a trusted device is misplaced).
2699      *
2700      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2701      * event.
2702      *
2703      * Requirements:
2704      *
2705      * - the caller must be `account`.
2706      *
2707      * May emit a {RoleRevoked} event.
2708      */
2709     function renounceRole(bytes32 role, address account) public virtual override {
2710         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2711 
2712         _revokeRole(role, account);
2713     }
2714 
2715     /**
2716      * @dev Grants `role` to `account`.
2717      *
2718      * If `account` had not been already granted `role`, emits a {RoleGranted}
2719      * event. Note that unlike {grantRole}, this function doesn't perform any
2720      * checks on the calling account.
2721      *
2722      * May emit a {RoleGranted} event.
2723      *
2724      * [WARNING]
2725      * ====
2726      * This function should only be called from the constructor when setting
2727      * up the initial roles for the system.
2728      *
2729      * Using this function in any other way is effectively circumventing the admin
2730      * system imposed by {AccessControl}.
2731      * ====
2732      *
2733      * NOTE: This function is deprecated in favor of {_grantRole}.
2734      */
2735     function _setupRole(bytes32 role, address account) internal virtual {
2736         _grantRole(role, account);
2737     }
2738 
2739     /**
2740      * @dev Sets `adminRole` as ``role``'s admin role.
2741      *
2742      * Emits a {RoleAdminChanged} event.
2743      */
2744     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2745         bytes32 previousAdminRole = getRoleAdmin(role);
2746         _roles[role].adminRole = adminRole;
2747         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2748     }
2749 
2750     /**
2751      * @dev Grants `role` to `account`.
2752      *
2753      * Internal function without access restriction.
2754      *
2755      * May emit a {RoleGranted} event.
2756      */
2757     function _grantRole(bytes32 role, address account) internal virtual {
2758         if (!hasRole(role, account)) {
2759             _roles[role].members[account] = true;
2760             emit RoleGranted(role, account, _msgSender());
2761         }
2762     }
2763 
2764     /**
2765      * @dev Revokes `role` from `account`.
2766      *
2767      * Internal function without access restriction.
2768      *
2769      * May emit a {RoleRevoked} event.
2770      */
2771     function _revokeRole(bytes32 role, address account) internal virtual {
2772         if (hasRole(role, account)) {
2773             _roles[role].members[account] = false;
2774             emit RoleRevoked(role, account, _msgSender());
2775         }
2776     }
2777 }
2778 
2779 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
2780 
2781 
2782 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
2783 
2784 pragma solidity ^0.8.0;
2785 
2786 
2787 
2788 
2789 /**
2790  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2791  */
2792 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
2793     using EnumerableSet for EnumerableSet.AddressSet;
2794 
2795     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2796 
2797     /**
2798      * @dev See {IERC165-supportsInterface}.
2799      */
2800     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2801         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
2802     }
2803 
2804     /**
2805      * @dev Returns one of the accounts that have `role`. `index` must be a
2806      * value between 0 and {getRoleMemberCount}, non-inclusive.
2807      *
2808      * Role bearers are not sorted in any particular way, and their ordering may
2809      * change at any point.
2810      *
2811      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2812      * you perform all queries on the same block. See the following
2813      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2814      * for more information.
2815      */
2816     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
2817         return _roleMembers[role].at(index);
2818     }
2819 
2820     /**
2821      * @dev Returns the number of accounts that have `role`. Can be used
2822      * together with {getRoleMember} to enumerate all bearers of a role.
2823      */
2824     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
2825         return _roleMembers[role].length();
2826     }
2827 
2828     /**
2829      * @dev Overload {_grantRole} to track enumerable memberships
2830      */
2831     function _grantRole(bytes32 role, address account) internal virtual override {
2832         super._grantRole(role, account);
2833         _roleMembers[role].add(account);
2834     }
2835 
2836     /**
2837      * @dev Overload {_revokeRole} to track enumerable memberships
2838      */
2839     function _revokeRole(bytes32 role, address account) internal virtual override {
2840         super._revokeRole(role, account);
2841         _roleMembers[role].remove(account);
2842     }
2843 }
2844 
2845 // File: contracts/Chungalunga.sol
2846 
2847 
2848 pragma solidity ^0.8.3;
2849 
2850 
2851 
2852 
2853 
2854 
2855 
2856 
2857 
2858 
2859 
2860 
2861 
2862 
2863 
2864 
2865 /**
2866 *
2867 * https://www.chungalungacoin.com/
2868 * https://t.me/chungalunga
2869 * https://twitter.com/chungalungacoin
2870 *
2871 */
2872 contract Chungalunga is IChungalunga, ERC20, Ownable, AccessControlEnumerable {
2873     using SafeMath for uint256;
2874     using Address for address;
2875     using SafeERC20 for IERC20;
2876 
2877     event StateProgress (
2878         bool liquidityAdded,
2879         bool whitelistStarted,
2880         bool tradeOpened
2881     );
2882 
2883     event WHStart (
2884         uint256 duration
2885     );
2886     
2887     struct TaxedValues{
2888       uint256 amount;
2889       uint256 tAmount;
2890       uint256 tMarketing;
2891       uint256 tLiquidity;
2892     }
2893 	
2894 	struct SwapValues{
2895 		uint256 tMarketing;
2896 		uint256 tLiquidity;
2897 		uint256 tHalfLiquidity;
2898 		uint256 tTotal;
2899 		uint256 swappedBalance;
2900 	}
2901 	
2902 	// 
2903 	// CONSTANTS
2904 	//
2905 	//uint256 private constant MAX = ~uint256(0);
2906 
2907 	/* Using 18 decimals */
2908 	uint8 private constant DECIMALS = 18;
2909 	
2910 	/* Total supply : 10_000_000_000 tokens (10 Billion) */
2911 	uint256 private constant TOKENS_INITIAL = 10 * 10 ** 9;
2912 	
2913 	/* Minimal number of tokens that must be collected before swap can be triggered: 1000. Real threshold cannot be set below this value */
2914 	uint256 private constant MIN_SWAP_THRESHOLD = 1 * 10 ** 3 * 10 ** uint256(DECIMALS);
2915 
2916     /* By what to divide calculated fee to compensate for supported decimals */
2917     uint256 private constant DECIMALS_FEES = 1000;
2918 	
2919 	/* Max amount of individual fee. 9.0% */
2920 	uint256 private constant LIMIT_FEES = 90;
2921 	
2922 	/* Max amount of total fees. 10.0% */
2923 	uint256 private constant LIMIT_TOTAL_FEES = 100;
2924 
2925     /* Number of minutes between 2 sales. 117 seconds */
2926     uint256 private constant TCS_TIME_INTERVAL = 117;
2927 	
2928 	/* Dead address */
2929 	address private constant deadAddress = 0x000000000000000000000000000000000000dEaD;
2930 	
2931 	bytes32 private constant ADMIN_ROLE = keccak256("CL_ADMIN_ROLE");
2932     bytes32 private constant CTRL_ROLE = keccak256("CL_CTRL_ROLE");
2933 	
2934 	// 
2935 	// MEMBERS
2936 	//
2937 	
2938 	/* How much can each address allow for another address */
2939     mapping (address => mapping (address => uint256)) private _allowances;
2940 	
2941 	/* Map of addresses and whether they are excluded from fee */
2942     mapping (address => bool) private _isExcludedFromFee;
2943     
2944     /* Map of addresses and whether they are excluded from max TX check */
2945     mapping (address => bool) private _isExcludedFromMaxTx;
2946     
2947     /* Map of blacklisted addresses */
2948     mapping(address => bool) private _blacklist;
2949 	
2950 	/* Map of whitelisted addresses */
2951     mapping(address => bool) private _whitelist;
2952 	
2953 	/* Fee that will be charged to blacklisted accounts. Default is 90% */
2954 	uint256 private _blacklistFee = 900;
2955     
2956     /* Marketing wallet address */
2957     address public marketingWalletAddress;
2958 
2959     /* Number of tokens currently pending swap for marketing */
2960     uint256 public tPendingMarketing;
2961     /* Number of tokens currently pending swap for liquidity */
2962     uint256 public tPendingLiquidity;
2963 	
2964 	/* Total tokens in wei. Will be created during initial mint in constructor */
2965     uint256 private _tokensTotal = TOKENS_INITIAL * 10 ** uint256(DECIMALS);
2966 	
2967 	/* Total fees taken so far */
2968     Fees private _totalTakenFees = Fees(
2969     {marketingFee: 0,
2970       liquidityFee: 0
2971     });
2972     
2973     Fees private _buyFees = Fees(
2974     {marketingFee: 40,
2975       liquidityFee: 10
2976     });
2977     
2978     Fees private _previousBuyFees = Fees(
2979      {marketingFee: _buyFees.marketingFee,
2980       liquidityFee: _buyFees.liquidityFee
2981     });
2982     
2983     Fees private _sellFees = Fees(
2984      {marketingFee: 40,
2985       liquidityFee: 10
2986     });
2987     
2988     Fees private _previousSellFees = Fees(
2989      {marketingFee: _sellFees.marketingFee,
2990       liquidityFee: _sellFees.liquidityFee
2991     });
2992     
2993 	/* Swap and liquify safety flag */
2994     bool private _inSwapAndLiquify;
2995 	
2996 	/* Whether swap and liquify is enabled or not. Enabled by default */
2997     bool private _swapAndLiquifyEnabled = true;
2998     
2999 	/* Anti Pajeet system */
3000     bool public apsEnabled = false;
3001 
3002     /* Trade control system */
3003     bool public tcsEnabled = false;
3004 
3005     /* Is whitelisted process active */
3006     bool private _whProcActive = false;
3007 
3008     /* When did whitelisted process start? */
3009     uint256 private _whStart = 0;
3010 
3011     /* Duration of whitelisted process */
3012     uint256 private _whDuration = 1;
3013 
3014     /* Account sharing system (sending of tokens between accounts. Disabled by default */
3015     bool private _accSharing = false;
3016 
3017     /* Anti Pajeet system threshold. If a single account holds more that that number of tokens APS limits will be applied */
3018     uint256 private _apsThresh = 20 * 10 ** 6 * 10 ** uint256(DECIMALS);
3019 
3020     /* Anti Pajeet system interval between two consecutive sales. In minutes. It defines when is the earlies user can sell depending on his last sale. Can be as low as 1 min. Defaults to 1440 mins (24 hours).  */
3021     uint256 private _apsInterval = 1440;
3022 	
3023 	/* Was LP provided? False by default */
3024 	bool public liquidityAdded = false;
3025 	
3026 	/* Is trade open? False by default */
3027 	bool public tradingOpen = false;
3028 	
3029 	/* Should tokens in marketing wallet be swapped automatically */
3030 	bool private _swapMarketingTokens = true;
3031 	
3032 	/* Should fees be applied only on swaps? Otherwise, all transactions will be taxed */
3033 	bool public feeOnlyOnSwap = false;
3034 	
3035 	/* Mapping of previous sales by address. Used to limit sell occurrence */
3036     mapping (address => uint256) private _previousSale;
3037 
3038     /* Mapping of previous buys by address. Used to limit buy occurrence */
3039     mapping (address => uint256) private _previousBuy;
3040     
3041 	/* Maximal transaction amount -> cannot be higher than available token supply. It will be dynamically adjusted upon start */
3042     uint256 private _maxTxAmount = 0;
3043 
3044     /* Maximal amount single holder can possess -> cannot be higher than available token supply. Initially it will be set to 1% of total supply. It will be dynamically adjusted */
3045     uint256 private _maxHolderAmount = (_tokensTotal * 1) / 100;
3046 	
3047 	/* Min number of tokens to trigger sell and add to liquidity. Initially, 300k tokens */
3048     uint256 private _swapThresh =  300 * 10 ** 3 * 10 ** uint256(DECIMALS);
3049 
3050     /* Number of block when liquidity was added */
3051     uint256 private _lpCreateBlock = 0;
3052 
3053     /* Number of block when WH process was started */
3054     uint256 private _whStartBlock = 0;
3055     
3056     /* *Swap V2 router */
3057     IUniswapV2Router02 private _swapV2Router;
3058     
3059     /* Swap V2 pair */
3060     address private _swapV2Pair;
3061 	
3062 	/* Map of AMMs. Special rules apply when AMM is "to" */
3063 	mapping (address => bool) public ammPairs;
3064     
3065     constructor () ERC20("Chungalunga", "CL") {
3066 		
3067         _changeMarketingWallet(address(0x69cEC9B2FFDfE02481fBDC372Cd885FE83F3f694));
3068 		
3069 		_setupRole(CTRL_ROLE, msg.sender);
3070 	
3071         // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D is RouterV2 on mainnet
3072         _setupSwap(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
3073         _setupExclusions();
3074 		
3075 		_setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
3076         _setRoleAdmin(CTRL_ROLE, ADMIN_ROLE);
3077 
3078         _setupRole(ADMIN_ROLE, msg.sender);
3079         _setupRole(ADMIN_ROLE, address(this));
3080 
3081         _setupRole(CTRL_ROLE, msg.sender);
3082         _setupRole(CTRL_ROLE, address(this));
3083 		
3084         _mint(msg.sender, _tokensTotal);
3085 		
3086 		transferOwnership(msg.sender);
3087     }
3088     
3089     //
3090     // EXTERNAL ACCESS
3091     //
3092 
3093 	function addCTRLMember(address account) public virtual onlyRole(ADMIN_ROLE) {
3094         grantRole(CTRL_ROLE, account);
3095     }
3096 
3097     function removeCTRLMember(address account) public virtual onlyRole(ADMIN_ROLE) {
3098         revokeRole(CTRL_ROLE, account);
3099     }
3100 
3101     function renounceAdminRole() public virtual onlyRole(ADMIN_ROLE) {
3102         revokeRole(CTRL_ROLE, msg.sender);
3103         revokeRole(ADMIN_ROLE, msg.sender);
3104     }
3105 
3106     /**
3107     * Fetches how many tokens were taken as fee so far
3108     *
3109     * @return (marketingFeeTokens, liquidityFeeTokens)
3110     */
3111     function totalTakenFees() public view returns (uint256, uint256) {
3112         return (_totalTakenFees.marketingFee, _totalTakenFees.liquidityFee);
3113     }
3114 
3115     /**
3116     * Fetches current fee settings: buy or sell.
3117     *
3118     * @param isBuy  true if buy fees are requested, otherwise false
3119     * @return (marketingFee, liquidityFee)
3120     */
3121     function currentFees(bool isBuy) public view returns (uint256, uint256) {
3122         if(isBuy){
3123             return (_buyFees.marketingFee, _buyFees.liquidityFee);
3124         } else {
3125             return (_sellFees.marketingFee, _sellFees.liquidityFee);
3126         }
3127     }
3128     
3129     function feeControl(address account, bool exclude) override external onlyRole(CTRL_ROLE) {
3130         _isExcludedFromFee[account] = exclude;
3131     }
3132     
3133     /* Check whether account is exclude from fee */
3134     function isExcludedFromFee(address account) override external view returns(bool) {
3135         return _isExcludedFromFee[account];
3136     }
3137     
3138     function maxTxControl(address account, bool exclude) external override onlyRole(CTRL_ROLE) {
3139         _isExcludedFromMaxTx[account] = exclude;
3140     }
3141     
3142     function isExcludedFromMaxTx(address account) public view override returns(bool) {
3143         return _isExcludedFromMaxTx[account];
3144     }
3145 
3146     function setHolderLimit(uint256 limit) external override onlyRole(CTRL_ROLE) {
3147         require(limit > 0 && limit < TOKENS_INITIAL, "HOLDER_LIMIT1");
3148 
3149         uint256 new_limit = limit * 10 ** uint256(DECIMALS);
3150 
3151         // new limit cannot be less than 0.5%
3152         require(new_limit > ((_tokensTotal * 5) / DECIMALS_FEES), "HOLDER_LIMIT2");
3153 
3154         _maxHolderAmount = new_limit;
3155 
3156         emit TCSStateUpdate(tcsEnabled, _maxTxAmount, _maxHolderAmount, TCS_TIME_INTERVAL);
3157     }
3158 
3159     /* It will exclude sale helper router address and presale router address from fee's and rewards */
3160     function setHelperSaleAddress(address helperRouter, address presaleRouter) external override onlyRole(CTRL_ROLE) {
3161         _excludeAccount(helperRouter, true);
3162         _excludeAccount(presaleRouter, true);
3163     }
3164 
3165     /* Enable Trade control system. Imposes limitations on buy/sell */
3166     function setTCS(bool enabled) override external onlyRole(CTRL_ROLE) {
3167         tcsEnabled = enabled;
3168 
3169         emit TCSStateUpdate(tcsEnabled, _maxTxAmount, _maxHolderAmount, TCS_TIME_INTERVAL);
3170     }
3171 
3172     /**
3173      * Returns TCS state:
3174      * - max TX amount in wei
3175      * - max holder amount in wei
3176      * - TCS buy/sell interval in minutes
3177      */
3178     function getTCSState() public view onlyRole(CTRL_ROLE) returns(uint256, uint256, uint256) {
3179         return (_maxTxAmount, _maxHolderAmount, TCS_TIME_INTERVAL);
3180     }
3181     
3182 	/* Enable anti-pajeet system. Imposes limitations on sale */
3183     function setAPS(bool enabled) override external onlyRole(CTRL_ROLE) {
3184         apsEnabled = enabled;
3185 
3186         emit APSStateUpdate(apsEnabled, _apsThresh, _apsInterval);
3187     }
3188 
3189 	/* Sets new APS threshold. It cannot be set to more than 5% */
3190     function setAPSThreshPercent(uint256 thresh) override external onlyRole(CTRL_ROLE) {
3191         require(thresh < 50, "APS-THRESH-PERCENT");
3192 
3193         _apsThresh = _tokensTotal.mul(thresh).div(DECIMALS_FEES);
3194 
3195         emit APSStateUpdate(apsEnabled, _apsThresh, _apsInterval);
3196     }
3197 
3198     function setAPSThreshAmount(uint256 thresh) override external onlyRole(CTRL_ROLE) {
3199         require(thresh > 1000 && thresh < TOKENS_INITIAL, "APS-THRESH-AMOUNT");
3200 
3201         _apsThresh = thresh * 10 ** uint256(DECIMALS);
3202 
3203         emit APSStateUpdate(apsEnabled, _apsThresh, _apsInterval);
3204     }
3205 
3206     /* Sets new min APS sale interval. In minutes */
3207     function setAPSInterval(uint256 interval) override external onlyRole(CTRL_ROLE) {
3208         require(interval > 0, "APS-INTERVAL-0");
3209 
3210         _apsInterval = interval;
3211 
3212         emit APSStateUpdate(apsEnabled, _apsThresh, _apsInterval);
3213     }
3214 
3215     /**
3216      * Returns APS state:
3217      * - threshold in tokens
3218      * - interval in minutes
3219      */
3220     function getAPSState() public view onlyRole(CTRL_ROLE) returns(uint256, uint256) {
3221         return (_apsThresh, _apsInterval);
3222     }
3223 
3224     /* wnables/disables account sharing: sending of tokens between accounts */
3225     function setAccountShare(bool enabled) override external onlyRole(CTRL_ROLE) {
3226         _accSharing = enabled;
3227     }
3228     
3229 	/* Changing marketing wallet */
3230     function changeMarketingWallet(address account) override external onlyRole(CTRL_ROLE) {
3231         _changeMarketingWallet(account);
3232     }
3233     
3234     function setFees(uint256 liquidityFee, uint256 marketingFee, bool isBuy) external override onlyRole(CTRL_ROLE) {
3235         // fees are setup so they can not exceed 10% in total
3236         // and specific limits for each one.
3237         require(marketingFee + liquidityFee <= LIMIT_TOTAL_FEES, "FEE-MAX");
3238        
3239         _setMarketingFeePercent(marketingFee, isBuy);
3240         _setLiquidityFeePercent(liquidityFee, isBuy);
3241     }
3242    
3243     /* Define MAX TX amount. In percentage of total supply */
3244     function setMaxTxPercent(uint256 maxTxPercent) override external onlyRole(CTRL_ROLE) {
3245         require(maxTxPercent <= 1000, "MAXTX_PERC_LIMIT");
3246         _maxTxAmount = _tokensTotal.mul(maxTxPercent).div(DECIMALS_FEES);
3247 
3248         emit TCSStateUpdate(tcsEnabled, _maxTxAmount, _maxHolderAmount, TCS_TIME_INTERVAL);
3249     }
3250     
3251 	/* Define MAX TX amount. In token count */
3252     function setMaxTxAmount(uint256 maxTxAmount) override external onlyRole(CTRL_ROLE) {
3253         require(maxTxAmount <= TOKENS_INITIAL, "MAXTX_AMNT_LIMIT");
3254         _maxTxAmount = maxTxAmount * 10 ** uint256(DECIMALS);
3255 
3256         emit TCSStateUpdate(tcsEnabled, _maxTxAmount, _maxHolderAmount, TCS_TIME_INTERVAL);
3257     }
3258 
3259     /* Enable LP provisioning */
3260     function setSwapAndLiquifyEnabled(bool enabled) override external onlyRole(CTRL_ROLE) {
3261         _swapAndLiquifyEnabled = enabled;
3262         emit SwapAndLiquifyEnabledUpdated(enabled);
3263     }
3264 	
3265 	/* Define new swap threshold. Cannot be less than MIN_SWAP_THRESHOLD: 1000 tokens */
3266 	function changeSwapThresh(uint256 thresh) override external onlyRole(CTRL_ROLE){
3267         uint256 newThresh = thresh * 10 ** uint256(DECIMALS);
3268 
3269 		require(newThresh > MIN_SWAP_THRESHOLD, "THRESH-LOW");
3270 
3271 		_swapThresh = newThresh;
3272 	}
3273 
3274     /* take a look at current swap threshold */
3275     function swapThresh() public view onlyRole(CTRL_ROLE) returns(uint256) {
3276         return _swapThresh;
3277     }
3278     
3279 	/* Once presale is done and LP is created, trading can be enabled for all. Only once this is set will normal transactions be completed successfully */
3280     function tradeCtrl(bool on) override external onlyRole(CTRL_ROLE) {
3281         require(liquidityAdded, "LIQ-NONE");
3282        _tradeCtrl(on);
3283     }
3284 
3285     function _tradeCtrl(bool on) internal {
3286         tradingOpen = on;
3287 
3288         emit StateProgress(true, true, true);
3289     }
3290 
3291     function wlProcess(uint256 duration) override external onlyRole(CTRL_ROLE) {
3292         require(liquidityAdded && _lpCreateBlock > 0, "LIQ-NONE");
3293         require(duration > 1, "WHT-DUR-LOW");
3294 
3295         _whStartBlock = block.number;
3296 
3297         _whProcActive = true;
3298         _whDuration = duration;
3299         _whStart = block.timestamp;
3300 
3301         // set MAX TX limit to 10M tokens
3302         _maxTxAmount = 10 * 10 ** 6 * 10 ** uint256(DECIMALS);
3303 
3304         // make sure trading is closed
3305         tradingOpen = false;
3306 
3307         // enable aps
3308         apsEnabled = true;
3309 
3310         // enable tcs
3311         tcsEnabled = true;
3312 
3313         // return APS thresh to 20M
3314         _apsThresh = 20 * 10 ** 6 * 10 ** uint256(DECIMALS);
3315 
3316         // emit current state
3317         emit StateProgress(true, true, false);
3318 
3319         // emit start of whitelist process
3320         emit WHStart(duration);
3321     }
3322 
3323 	/* Sets should tokens collected through fees be automatically swapped to ETH or not */
3324     function setSwapOfFeeTokens(bool enabled) override external onlyRole(CTRL_ROLE) {
3325         _swapMarketingTokens = enabled;
3326     }
3327     
3328 	/* Sets should fees be taken only on swap or on all transactions */
3329     function takeFeeOnlyOnSwap(bool onSwap) override external onlyRole(CTRL_ROLE) {
3330         feeOnlyOnSwap = onSwap;
3331         emit TakeFeeOnlyOnSwap(feeOnlyOnSwap);
3332     }
3333 	
3334 	/* Should be called once LP is created. Manually or programatically (by calling #addInitialLiquidity()) */
3335 	function defineLiquidityAdded() public onlyRole(CTRL_ROLE) {
3336         liquidityAdded = true;
3337 
3338         if(_lpCreateBlock == 0) {
3339             _lpCreateBlock = block.number;
3340         }
3341 
3342         emit StateProgress(true, false, false);
3343     }
3344     
3345 	/* withdraw any ETH balance stuck in contract */
3346     function withdrawLocked(address payable recipient) external override onlyRole(CTRL_ROLE) {
3347         require(recipient != address(0), 'ADDR-0');
3348         require(address(this).balance > 0, 'BAL-0');
3349 	
3350         uint256 amount = address(this).balance;
3351         // address(this).balance = 0;
3352     
3353         (bool success,) = payable(recipient).call{value: amount}('');
3354     
3355         if(!success) {
3356           revert();
3357         }
3358     }
3359 
3360     function withdrawFees() external override onlyRole(CTRL_ROLE) {
3361         require(!_swapAndLiquifyEnabled, "WITHDRAW-SWAP");
3362 
3363         super._transfer(address(this), marketingWalletAddress, balanceOf(address(this)));
3364 
3365         tPendingMarketing = 0;
3366         tPendingLiquidity = 0;
3367     }
3368     
3369     function isBlacklisted(address account) external view override returns(bool) {
3370         return _blacklist[account];
3371     }
3372 	
3373 	function isWhitelisted(address account) external view override returns(bool) {
3374         return _whitelist[account];
3375     }
3376     
3377     function setBlacklist(address account, bool add) external override onlyRole(CTRL_ROLE) {
3378 		_setBlacklist(account, add);
3379     }
3380     
3381     function setWhitelist(address account, bool add) external override onlyRole(CTRL_ROLE) {
3382         _whitelist[account] = add;
3383     }
3384 	
3385 	function setBlacklistFee(uint256 blacklistFee) external override onlyRole(CTRL_ROLE) {
3386 		_blacklistFee = blacklistFee;
3387 	}
3388 
3389     function _setBlacklist(address account, bool add) private {
3390         _blacklist[account] = add;
3391 
3392         emit BlacklistedAddress(account);
3393     }
3394 
3395     function bulkWhitelist(address[] calldata addrs, bool add) external onlyRole(CTRL_ROLE) {
3396         for (uint i=0; i<addrs.length; i++){
3397             _whitelist[addrs[i]] = add;
3398         }
3399     }
3400 
3401     function bulkBlacklist(address[] calldata addrs, bool add) external onlyRole(CTRL_ROLE) {
3402         for (uint i=0; i<addrs.length; i++){
3403             _blacklist[addrs[i]] = add;
3404         }
3405     }
3406 
3407     function provisionPrivate(address[] calldata addrs, uint256 amount) external onlyRole(CTRL_ROLE) {
3408         for (uint i=0; i<addrs.length; i++){
3409             super.transfer(addrs[i], amount);
3410         }
3411     }
3412 	
3413 	/* To be called whan presale begins/ends. It will remove/add fees */
3414 	function setPreSale(bool start) external override onlyRole(CTRL_ROLE) {
3415 		if(start) { // presale started
3416 			// remove all fees (buy)
3417 			_removeAllFee(true);
3418 			// remove all fees (sell)
3419 			_removeAllFee(false);
3420 		} else { // presale stopped
3421 			// restore all fees (buy)
3422 			_restoreAllFee(true);
3423 			// restore all fees (sell)
3424 			_restoreAllFee(false);
3425 		}
3426     }
3427     
3428     function updateSwapV2Router(address newAddress) external override onlyRole(CTRL_ROLE) {
3429         require(newAddress != address(0), "R2-1");
3430         _setupSwap(newAddress);
3431     }
3432     
3433      //to receive ETH from *swapV2Router when swaping. msg.data must be empty
3434     receive() external payable {}
3435 
3436     // Fallback function is called when msg.data is not empty
3437     //fallback() external payable {}
3438     
3439     //
3440     // PRIVATE ACCESS
3441     //
3442     
3443     function _setupSwap(address routerAddress) private {
3444         // Uniswap V2 router: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
3445         
3446         _swapV2Router = IUniswapV2Router02(routerAddress);
3447     
3448         // create a swap pair for this new token
3449         _swapV2Pair = IUniswapV2Factory(_swapV2Router.factory()).createPair(address(this), _swapV2Router.WETH());
3450 
3451 		_setAMMPair(address(_swapV2Pair), true);
3452 
3453         //_approve(owner(), address(_swapV2Router), type(uint256).max);
3454 
3455         _isExcludedFromMaxTx[address(_swapV2Router)] = true;
3456 
3457         _approve(owner(), address(_swapV2Router), type(uint256).max);
3458         ERC20(address(_swapV2Router.WETH())).approve(address(_swapV2Router), type(uint256).max);
3459         ERC20(address(_swapV2Router.WETH())).approve(address(this), type(uint256).max);
3460 		
3461 		emit UpdateSwapV2Router(routerAddress);
3462     }
3463 	
3464 	function setLPP(address pair, bool value) external override onlyRole(CTRL_ROLE) {
3465         _setAMMPair(pair, value);
3466 
3467         if (!liquidityAdded) {
3468             defineLiquidityAdded();
3469         }
3470     }
3471 
3472     function _setAMMPair(address pair, bool value) private {
3473         ammPairs[pair] = value;
3474 
3475         _isExcludedFromMaxTx[pair] = value;
3476     }
3477     
3478     function _excludeAccount(address addr, bool ex) private {
3479          _isExcludedFromFee[addr] = ex;
3480          _isExcludedFromMaxTx[addr] = ex;
3481     }
3482     
3483     function _setupExclusions() private {
3484         _excludeAccount(msg.sender, true);
3485         _excludeAccount(address(this), true);
3486         _excludeAccount(owner(), true);
3487 		_excludeAccount(deadAddress, true);
3488         _excludeAccount(marketingWalletAddress, true);
3489     }
3490     
3491     function _changeMarketingWallet(address addr) internal {
3492         require(addr != address(0), "ADDR-0");
3493         _excludeAccount(marketingWalletAddress, false);
3494 		
3495         marketingWalletAddress = addr;
3496 		
3497 		_excludeAccount(addr, true);
3498     }
3499     
3500     function _isBuy(address from) internal view returns(bool) {
3501         //return from == address(_swapV2Pair) || ammPairs[from];
3502         return ammPairs[from];
3503     }
3504     
3505     function _isSell(address to) internal view returns(bool) {
3506         //return to == address(_swapV2Pair) || ammPairs[to];
3507         return ammPairs[to];
3508     }
3509     
3510     function _checkTxLimit(address from, address to, uint256 amount) internal view {
3511         if (_isBuy(from)) { // buy
3512 			require(amount <= _maxTxAmount || _isExcludedFromMaxTx[to], "TX-LIMIT-BUY");
3513         } else  if (_isSell(to)) { // sell
3514             require(amount <= _maxTxAmount || _isExcludedFromMaxTx[from], "TX-LIMIT-SELL");
3515         } else { // transfer
3516 			require(amount <= _maxTxAmount || (_isExcludedFromMaxTx[from] || _isExcludedFromMaxTx[to]), "TX-LIMIT");
3517         }
3518     }
3519     
3520     function _setMarketingFeePercent(uint256 fee, bool isBuy) internal {
3521         require(fee <= LIMIT_FEES, "FEE-LIMIT-M");
3522         
3523         if(isBuy){
3524             _previousBuyFees.marketingFee = _buyFees.marketingFee;
3525             _buyFees.marketingFee = fee;
3526         } else {
3527             _previousSellFees.marketingFee = _sellFees.marketingFee;
3528             _sellFees.marketingFee = fee;
3529         }
3530     }
3531     
3532     function _setLiquidityFeePercent(uint256 liquidityFee, bool isBuy) internal {
3533         require(liquidityFee <= LIMIT_FEES, "FEE-LIMIT-L");
3534         
3535          if(isBuy){
3536             _previousBuyFees.liquidityFee = _buyFees.liquidityFee;
3537             _buyFees.liquidityFee = liquidityFee;
3538         } else {
3539             _previousSellFees.liquidityFee = _sellFees.liquidityFee;
3540             _sellFees.liquidityFee = liquidityFee;
3541         }
3542     }
3543 
3544     function _getValues(uint256 amount, bool isBuy) private view returns (TaxedValues memory totalValues) {
3545         totalValues.amount = amount;
3546         totalValues.tMarketing = _calculateMarketingFee(amount, isBuy);
3547         totalValues.tLiquidity = _calculateLiquidityFee(amount, isBuy);
3548         
3549         totalValues.tAmount = amount.sub(totalValues.tMarketing).sub(totalValues.tLiquidity);
3550         
3551         return totalValues;
3552     }
3553     
3554     function _calculateMarketingFee(uint256 amount, bool isBuy) private view returns (uint256) {
3555         if(isBuy){
3556             return _buyFees.marketingFee > 0 ?
3557                 amount.mul(_buyFees.marketingFee).div(DECIMALS_FEES) : 0;
3558         } else {
3559             return _sellFees.marketingFee > 0 ?
3560                 amount.mul(_sellFees.marketingFee).div(DECIMALS_FEES) : 0;
3561         }
3562     }
3563 
3564     function _calculateLiquidityFee(uint256 amount, bool isBuy) private view returns (uint256) {
3565         if(isBuy){
3566             return _buyFees.liquidityFee > 0 ?
3567                 amount.mul(_buyFees.liquidityFee).div(DECIMALS_FEES) : 0;
3568         } else {
3569             return _sellFees.liquidityFee > 0 ?
3570                 amount.mul(_sellFees.liquidityFee).div(DECIMALS_FEES) : 0; 
3571         }
3572     }
3573     
3574     function _removeAllFee(bool isBuy) private {
3575         if(isBuy){
3576             _previousBuyFees = _buyFees;
3577             _buyFees.liquidityFee = 0;
3578             _buyFees.marketingFee = 0;
3579         } else {
3580             _previousSellFees = _sellFees;
3581             _sellFees.liquidityFee = 0;
3582             _sellFees.marketingFee = 0;
3583         }
3584     }
3585     
3586     function _restoreAllFee(bool isBuy) private {
3587         if(isBuy){
3588             _buyFees = _previousBuyFees;
3589         } else {
3590             _sellFees = _previousSellFees;
3591         }
3592     }
3593     
3594     /**
3595     * Transfer codes:
3596     *   - FROM-ADDR-0 -> from address is 0
3597     *   - TO-ADDR-0 -> to address is 0
3598     *   - ADDR-0 -> if some address is 0 
3599     *   - CNT-0 -> if some amount is 0
3600     */
3601     function _transfer(
3602         address from,
3603         address to,
3604         uint256 amount
3605     ) internal override {
3606         require(from != address(0), "FROM-ADDR-0");
3607         require(to != address(0), "TO-ADDR-0");
3608         if (amount == 0) {
3609             super._transfer(from, to, 0);
3610             return;
3611         }
3612 
3613         if(_blacklist[from] || _blacklist[to]) {
3614 			_blacklistDefense(from, to, amount);
3615             return;
3616         }
3617 
3618         if (!_inSwapAndLiquify) {
3619 
3620             // whitelist process check
3621             _whitelistProcessCheck();
3622 
3623             // general rules of conduct
3624             _generalRules(from, to, amount);
3625 
3626             // TCS  (Trade Control System) check
3627             _tcsCheck(from, to, amount);
3628             
3629             // APS (Anti Pajeet System) check
3630             _apsCheck(from, to, amount);
3631 
3632             // DLP (Delayed Provision)
3633             _delayedProvision(from, to);
3634         }
3635 
3636         //indicates if fee should be deducted from transfer
3637         bool takeFee = !_inSwapAndLiquify;
3638 
3639         // if any account belongs to _isExcludedFromFee account then remove the fee
3640         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] ) {
3641             takeFee = false;
3642         }
3643 
3644         /*
3645         // take fee only on swaps depending on input flag
3646         if (feeOnlyOnSwap && !_isBuy(from) && !_isSell(to)) {
3647             takeFee = false;
3648         }
3649         */
3650         
3651         //transfer amount, it will take tax, special, liquidity fee
3652         _tokenTransfer(from, to, amount, takeFee);
3653     }
3654 
3655     function _defense(address from, address to, uint256 amount, uint256 fee) private {
3656 		uint256 tFee = amount * fee / DECIMALS_FEES;
3657 		uint256 tRest = amount - tFee;
3658 
3659         super._transfer(from, address(this), tFee);
3660         super._transfer(from, to, tRest);
3661 
3662         uint256 totalFeeP = 0;
3663         uint256 mFee = 0;
3664         uint256 lFee = 0;
3665         if (_isBuy(from)) {
3666             totalFeeP = _buyFees.liquidityFee + _buyFees.marketingFee;
3667             if (totalFeeP > 0) {
3668                 lFee = _buyFees.liquidityFee > 0 ? tFee * _buyFees.liquidityFee / totalFeeP : 0;
3669                 mFee = tFee - lFee;
3670             }
3671         } else {
3672             totalFeeP = _sellFees.liquidityFee + _sellFees.marketingFee;
3673             if (totalFeeP > 0) {
3674                 lFee = _sellFees.liquidityFee > 0 ? tFee * _sellFees.liquidityFee / totalFeeP : 0;
3675                 mFee = tFee - lFee;
3676             }
3677         }
3678 
3679         if (totalFeeP > 0) {
3680             tPendingMarketing += mFee;
3681             tPendingLiquidity += lFee;
3682             _totalTakenFees.marketingFee += mFee;
3683             _totalTakenFees.liquidityFee += lFee;
3684         }
3685 		
3686 	}
3687 	
3688 	function _blacklistDefense(address from, address to, uint256 amount) private {
3689         _defense(from, to, amount, _blacklistFee);		
3690 	}
3691 
3692     function _whitelistProcessCheck() private {
3693         if (_whProcActive) {
3694 
3695             require(block.number - _whStartBlock >= 2, "SNIPER-WL");
3696 
3697             if (_whStart + (_whDuration * 1 minutes) < block.timestamp) {
3698                 // whitelist process has expired. Disable it
3699                 _whProcActive = false;
3700 
3701             	// set MAX TX limit to 15M tokens
3702                 _maxTxAmount = 15 * 10 ** 6 * 10 ** uint256(DECIMALS);
3703 
3704                 // open trading
3705                 _tradeCtrl(true);
3706             }
3707         }
3708     }
3709 
3710     /**
3711     * GENERAL codes:
3712     *   - ACC-SHARE -> account sharing is disabled
3713     *   - TX-LIMIT-BUY -> transaction limit has been reached during buy
3714     *   - TX-LIMIT-SELL -> transaction limit has been reached during sell
3715     *   - TX-LIMIT -> transaction limit has been reached during share
3716     */
3717     function _generalRules(address from, address to, uint256 amount) private view {
3718 
3719         // acc sharing
3720         require(_accSharing || _isBuy(from) || _isSell(to) || from == owner() || to == owner(), "ACC-SHARE"); // either acc sharing is enabled, or at least one of from-to is AMM
3721 
3722         // anti bot
3723         if (!tradingOpen && liquidityAdded && from != owner() && to != owner()) {
3724 
3725             require(block.number - _lpCreateBlock >= 3, "SNIPER-LP" );
3726 
3727             require(_whProcActive && (_whitelist[from] || _whitelist[to]), "WH-ILLEGAL");
3728         }
3729 
3730         // check TX limit
3731         _checkTxLimit(from, to, amount);
3732 
3733     }
3734     
3735     
3736     /**
3737     * TCS codes:
3738     *   - TCS-HOLDER-LIMIT -> holder limit is exceeded
3739     *   - TCS-TIME -> must wait for at least 2min before another sell
3740     */
3741     function _tcsCheck(address from, address to, uint256 amount) private view {
3742         //
3743         // TCS (Trade Control System):
3744         // 1. trade imposes MAX tokens that single holder can possess
3745         // 2. buy/sell time limits of 2 mins
3746 		//
3747 
3748         if (tcsEnabled) {
3749 
3750             // check max holder amount limit
3751             if (_isBuy(from)) {
3752                 require(amount + balanceOf(to) <= _maxHolderAmount, "TCS-HOLDER-LIMIT");
3753             } else if(!_isSell(to)) {
3754                 require(amount + balanceOf(to) <= _maxHolderAmount, "TCS-HOLDER-LIMIT");
3755             }
3756 
3757             // buy/sell limit
3758             if (_isSell(to)) {
3759                 require( (_previousSale[from] + (TCS_TIME_INTERVAL * 1 seconds)) < block.timestamp, "TCS-TIME");
3760             } else if (_isBuy(from)) {
3761                 require( (_previousBuy[to] + (TCS_TIME_INTERVAL * 1 seconds)) < block.timestamp, "TCS-TIME");
3762             } else {
3763                 // token sharing 
3764                 require( (_previousSale[from] + (TCS_TIME_INTERVAL * 1 seconds)) < block.timestamp, "TCS-TIME");
3765                 require( (_previousBuy[to] + (TCS_TIME_INTERVAL * 1 seconds)) < block.timestamp, "TCS-TIME");
3766             }
3767         }
3768     }
3769     
3770     /**
3771     * APS codes:
3772     *   - APS-BALANCE -> cannot sell more than 20% of current balance if holds more than apsThresh tokens
3773     *   - APS-TIME -> must wait until _apsInterval passes before another sell
3774     */
3775     function _apsCheck(address from, address to, uint256 amount) view private {
3776         //
3777 		// APS (Anti Pajeet System):
3778 		// 1. can sell at most 20% of tokens in possession at once if holder has more than _apsThresh tokens
3779 		// 2. can sell once every _apsInterval (60) minutes
3780 		//
3781 		
3782         if (apsEnabled) {
3783             
3784             // Sell in progress
3785             if(_isSell(to)) {
3786 
3787                 uint256 fromBalance = balanceOf(from);	// how many tokens does account own
3788 
3789                 // if total number of tokens is above threshold, only 20% of tokens can be sold at once!
3790                 if(fromBalance >= _apsThresh) {
3791                     require(amount < (fromBalance / (5)), "APS-BALANCE");
3792                 }
3793 
3794                 // at most 1 sell every _apsInterval minutes (60 by default)
3795                 require( (_previousSale[from] + (_apsInterval * 1 minutes)) < block.timestamp, "APS-TIME");
3796             }
3797 			
3798         }
3799     }
3800 	
3801 	function _swapAndLiquifyAllFees() private {
3802         uint256 contractBalance = balanceOf(address(this));
3803 
3804         uint256 tTotal = tPendingLiquidity + tPendingMarketing;
3805         
3806         if(contractBalance == 0 || tTotal == 0 || tTotal < _swapThresh) {return;}
3807         
3808 		uint256 tLiqHalf = tPendingLiquidity > 0 ? contractBalance.mul(tPendingLiquidity).div(tTotal).div(2) : 0;
3809         uint256 amountToSwapForETH = contractBalance.sub(tLiqHalf);
3810         
3811         // starting contract's ETH balance
3812         uint256 initialBalance = address(this).balance;
3813 
3814 		// swap tokens for ETH
3815         _swapTokensForEth(amountToSwapForETH, address(this));
3816 		
3817 		// how much ETH did we just swap into?
3818         uint256 swappedBalance = address(this).balance.sub(initialBalance);
3819 		
3820 		// calculate ETH shares
3821 		uint256 cMarketing = swappedBalance.mul(tPendingMarketing).div(tTotal);
3822         uint256 cLiq = swappedBalance - cMarketing;
3823 
3824 		// liquify
3825 		if(tPendingLiquidity > 0 && cLiq > 0){
3826 		
3827 			//
3828 			// DLP (Delayed Liquidity Provision):
3829 			// - adding to liquidity only after some threshold has been met to avoid LP provision on every transaction
3830 			//  * NOTE: liquidity provision MUST be enabled first
3831 			//  * NOTE: don't enrich liquidity if sender is swap pair
3832 			//
3833 		
3834 			// add liquidity to LP
3835 			_addLiquidity(tLiqHalf, cLiq);
3836         
3837 			emit SwapAndLiquify(tLiqHalf, cLiq, tPendingLiquidity.sub(tLiqHalf));
3838 		}
3839         
3840 		// transfer to marketing
3841         (bool sent,) = address(marketingWalletAddress).call{value: cMarketing}("");
3842         emit MarketingSwap(tPendingMarketing, cMarketing, sent);
3843 
3844          // reset token count
3845         tPendingLiquidity = 0;
3846         tPendingMarketing = 0;
3847     }
3848     
3849     function _delayedProvision(address from, address to) private {
3850 
3851         if (
3852             !_inSwapAndLiquify &&
3853             !_isBuy(from) &&
3854             _swapAndLiquifyEnabled &&
3855             !_isExcludedFromFee[from] &&
3856             !_isExcludedFromFee[to]
3857         ) {
3858             _inSwapAndLiquify = true;
3859 			_swapAndLiquifyAllFees();
3860             _inSwapAndLiquify = false;
3861 		}
3862     }
3863 
3864     function _swapTokensForEth(uint256 tokenAmount, address account) private {
3865         // generate the uniswap pair path of token -> weth
3866 		address[] memory path = new address[](2);
3867         path[0] = address(this);
3868         path[1] = _swapV2Router.WETH();
3869 
3870         _approve(address(this), address(_swapV2Router), tokenAmount);
3871 
3872         // make the swap
3873         _swapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
3874             tokenAmount,
3875             0, // accept any amount of ETH
3876             path,
3877             account,
3878             block.timestamp
3879         );
3880     }
3881 
3882     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
3883         // approve token transfer to cover all possible scenarios
3884         _approve(address(this), address(_swapV2Router), tokenAmount);
3885 
3886         // add the liquidity
3887         _swapV2Router.addLiquidityETH{value: ethAmount}(
3888             address(this),
3889             tokenAmount,
3890             0, // slippage is unavoidable
3891             0, // slippage is unavoidable
3892             deadAddress,
3893             block.timestamp
3894         );
3895     }
3896 
3897     //this method is responsible for taking all fee, if takeFee is true
3898     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
3899         bool isBuy = _isBuy(sender);
3900 
3901         uint256 fees = 0;
3902         if (takeFee) {
3903             TaxedValues memory totalValues = _getValues(amount, isBuy);
3904 
3905             fees = totalValues.tMarketing + totalValues.tLiquidity;
3906 
3907             if(fees > 0) {
3908 
3909                 tPendingMarketing += totalValues.tMarketing;
3910                 tPendingLiquidity += totalValues.tLiquidity;
3911 
3912                 _totalTakenFees.marketingFee += totalValues.tMarketing;
3913                 _totalTakenFees.liquidityFee += totalValues.tLiquidity;
3914 
3915                 super._transfer(sender, address(this), fees);
3916 
3917                 amount -= fees;
3918             }
3919         }
3920 
3921         if (isBuy) {
3922             _previousBuy[recipient] = block.timestamp;
3923         } else if(_isSell(recipient)) {
3924             _previousSale[sender] = block.timestamp;
3925         } else {
3926             // token sharing
3927             _previousBuy[recipient] = block.timestamp;
3928             _previousSale[sender] = block.timestamp;
3929         }
3930 
3931         super._transfer(sender, recipient, amount);
3932 
3933     }
3934     
3935 }