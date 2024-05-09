1 /**
2  *Submitted for verification at BscScan.com on 2023-01-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6  
7 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/math/SafeMath.sol
8  
9 pragma solidity ^0.8.0;
10  
11 // CAUTION
12 // This version of SafeMath should only be used with Solidity 0.8 or later,
13 // because it relies on the compiler's built in overflow checks.
14  
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations.
17  *
18  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
19  * now has built in overflow checking.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             uint256 c = a + b;
30             if (c < a) return (false, 0);
31             return (true, c);
32         }
33     }
34  
35     /**
36      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b > a) return (false, 0);
43             return (true, a - b);
44         }
45     }
46  
47     /**
48      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55             // benefit is lost if 'b' is also tested.
56             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63  
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75  
76     /**
77      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87  
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101  
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115  
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129  
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143  
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159  
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179  
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202  
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a % b;
222         }
223     }
224 }
225  
226 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
227  
228  
229 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
230  
231 pragma solidity ^0.8.0;
232  
233 /**
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247  
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252  
253 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
254  
255  
256 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
257  
258 pragma solidity ^0.8.0;
259  
260  
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 abstract contract Ownable is Context {
274     address private _owner;
275  
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277  
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor() {
282         _transferOwnership(_msgSender());
283     }
284  
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         _checkOwner();
290         _;
291     }
292  
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299  
300     /**
301      * @dev Throws if the sender is not the owner.
302      */
303     function _checkOwner() internal view virtual {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305     }
306  
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public virtual onlyOwner {
315         _transferOwnership(address(0));
316     }
317  
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _transferOwnership(newOwner);
325     }
326  
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Internal function without access restriction.
330      */
331     function _transferOwnership(address newOwner) internal virtual {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337  
338 // File: pwr.sol
339  
340  
341  
342 pragma solidity ^0.8.7;
343  
344  
345  
346 /**
347  * @dev Interfaces
348  */
349  
350 interface IUniswapV2Factory {
351     function createPair(address tokenA, address tokenB) external returns (address pair);
352 }
353  
354 interface IUniswapV2Router01 {
355     function factory() external pure returns (address);
356     function WETH() external pure returns (address);
357  
358     function addLiquidity(
359         address tokenA,
360         address tokenB,
361         uint256 amountADesired,
362         uint256 amountBDesired,
363         uint256 amountAMin,
364         uint256 amountBMin,
365         address to,
366         uint256 deadline
367     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
368     function addLiquidityETH(
369         address token,
370         uint256 amountTokenDesired,
371         uint256 amountTokenMin,
372         uint256 amountETHMin,
373         address to,
374         uint256 deadline
375     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
376     function removeLiquidity(
377         address tokenA,
378         address tokenB,
379         uint256 liquidity,
380         uint256 amountAMin,
381         uint256 amountBMin,
382         address to,
383         uint256 deadline
384     ) external returns (uint256 amountA, uint256 amountB);
385     function removeLiquidityETH(
386         address token,
387         uint256 liquidity,
388         uint256 amountTokenMin,
389         uint256 amountETHMin,
390         address to,
391         uint256 deadline
392     ) external returns (uint256 amountToken, uint256 amountETH);
393     function removeLiquidityWithPermit(
394         address tokenA,
395         address tokenB,
396         uint256 liquidity,
397         uint256 amountAMin,
398         uint256 amountBMin,
399         address to,
400         uint256 deadline,
401         bool approveMax, uint8 v, bytes32 r, bytes32 s
402     ) external returns (uint256 amountA, uint256 amountB);
403     function removeLiquidityETHWithPermit(
404         address token,
405         uint256 liquidity,
406         uint256 amountTokenMin,
407         uint256 amountETHMin,
408         address to,
409         uint256 deadline,
410         bool approveMax, uint8 v, bytes32 r, bytes32 s
411     ) external returns (uint256 amountToken, uint256 amountETH);
412     function swapExactTokensForTokens(
413         uint256 amountIn,
414         uint256 amountOutMin,
415         address[] calldata path,
416         address to,
417         uint256 deadline
418     ) external returns (uint256[] memory amounts);
419     function swapTokensForExactTokens(
420         uint256 amountOut,
421         uint256 amountInMax,
422         address[] calldata path,
423         address to,
424         uint256 deadline
425     ) external returns (uint256[] memory amounts);
426     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
427         external
428         payable
429         returns (uint256[] memory amounts);
430     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline)
431         external
432         returns (uint256[] memory amounts);
433     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
434         external
435         returns (uint256[] memory amounts);
436     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline)
437         external
438         payable
439         returns (uint256[] memory amounts);
440  
441     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
442     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
443     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
444     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
445     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
446 }
447  
448 interface IUniswapV2Router02 is IUniswapV2Router01{
449     function removeLiquidityETHSupportingFeeOnTransferTokens(
450         address token,
451         uint256 liquidity,
452         uint256 amountTokenMin,
453         uint256 amountETHMin,
454         address to,
455         uint256 deadline
456     ) external returns (uint256 amountETH);
457     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
458         address token,
459         uint256 liquidity,
460         uint256 amountTokenMin,
461         uint256 amountETHMin,
462         address to,
463         uint256 deadline,
464         bool approveMax, uint8 v, bytes32 r, bytes32 s
465     ) external returns (uint256 amountETH);
466  
467     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
468         uint256 amountIn,
469         uint256 amountOutMin,
470         address[] calldata path,
471         address to,
472         uint256 deadline
473     ) external;
474     function swapExactETHForTokensSupportingFeeOnTransferTokens(
475         uint256 amountOutMin,
476         address[] calldata path,
477         address to,
478         uint256 deadline
479     ) external payable;
480     function swapExactTokensForETHSupportingFeeOnTransferTokens(
481         uint256 amountIn,
482         uint256 amountOutMin,
483         address[] calldata path,
484         address to,
485         uint256 deadline
486     ) external;
487 }
488  
489 /**
490  * @dev Interface of the ERC20 standard as defined in the EIP.
491  */
492 interface IERC20 {
493     function totalSupply() external view returns (uint256);
494     function balanceOf(address account) external view returns (uint256);
495     function transfer(address to, uint256 amount) external returns (bool);
496     function allowance(address owner, address spender) external view returns (uint256);
497     function approve(address spender, uint256 amount) external returns (bool);
498  
499     /**
500      * @dev Returns the decimals places of the token.
501      */
502     function decimals() external view returns (uint8);
503  
504     /**
505      * @dev Moves `amount` tokens from `from` to `to` using the
506      * allowance mechanism. `amount` is then deducted from the caller's
507      * allowance.
508      *
509      * Returns a boolean value indicating whether the operation succeeded.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transferFrom(
514         address from,
515         address to,
516         uint256 amount
517     ) external returns (bool);
518  
519     /**
520      * @dev Emitted when `value` tokens are moved from one account (`from`) to
521      * another (`to`).
522      *
523      * Note that `value` may be zero.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 value);
526  
527     /**
528      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
529      * a call to {approve}. `value` is the new allowance.
530      */
531     event Approval(address indexed owner, address indexed spender, uint256 value);
532 }
533  
534 /**
535  * @dev Interface for the optional metadata functions from the ERC20 standard.
536  *
537  * _Available since v4.1._
538  */
539 interface IERC20Metadata is IERC20 {
540     /**
541      * @dev Returns the name of the token.
542      */
543     function name() external view returns (string memory);
544  
545     /**
546      * @dev Returns the symbol of the token.
547      */
548     function symbol() external view returns (string memory);
549 }
550  
551 contract PWRCASH is Context, IERC20, IERC20Metadata, Ownable {
552     receive() external payable {}
553  
554     event SendNative(bool _wallet);
555  
556     using SafeMath for uint256;
557  
558     mapping(address => uint256) private _balances;
559  
560     mapping(address => mapping(address => uint256)) private _allowances;
561 
562     address public tAddress1;
563  
564     uint256 _totalSupply;
565     string private _name;
566     string private _symbol;
567     uint8 private _decimals;
568  
569     mapping (string => uint256) txCut;
570  
571     mapping (address => bool) public cutExempt;
572     mapping (address => bool) public txExempt;
573  
574     // taxes for differnet levels
575  
576     struct TokenCut {
577         uint256 forMarketing;
578         uint256 forFarming;
579     }
580  
581     struct TxLimit {
582         uint256 buyLimit;
583         uint256 sellLimit;
584         bool inactive;
585     }
586  
587     TxLimit txLimits;
588  
589     struct SwapToken {
590         uint256 swapTokensAt;
591         uint256 lastSwap;
592         uint256 swapDelay;
593         uint256 minToSend;
594     }
595  
596     SwapToken public swapTokens;
597  
598     IUniswapV2Router02 public uniswapV2Router;
599     address public uniswapV2Pair;
600  
601     constructor() {
602         _name = "PWRCASH";
603         _symbol = "PWRC";
604         _decimals = 18;
605         _totalSupply = 100_000_000 * (10 ** decimals());
606 
607         tAddress1 = msg.sender;
608  
609         cutExempt[msg.sender] = true;
610         txExempt[msg.sender] = true;
611         cutExempt[address(this)] = true;
612         txExempt[address(this)] = true;
613         cutExempt[tAddress1] = true;
614         txExempt[tAddress1] = true;
615  
616         /**
617             - marketing, farming
618         */
619         txCut["marketingBuy"] = 75; // 1%
620         txCut["farmingBuy"] = 75;
621  
622         txCut["marketingSell"] = 75;
623         txCut["farmingSell"] = 75;
624  
625         /**
626             Set default tx limits
627             - buy limit, sell limit
628         */
629         txLimits.buyLimit = _totalSupply.div(100);
630         txLimits.sellLimit = _totalSupply.div(400);
631  
632         swapTokens.swapTokensAt = _totalSupply.div(1794);
633         swapTokens.minToSend = 1 ether;
634         swapTokens.swapDelay = 5 minutes;
635  
636         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
637         uniswapV2Router = _uniswapV2Router;
638         _approve(address(this), address(uniswapV2Router), _totalSupply);
639         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
640         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
641  
642         approve(address(uniswapV2Router), _totalSupply);
643         cutExempt[address(uniswapV2Router)] = true;
644  
645         _balances[msg.sender] = _totalSupply;
646         emit Transfer(address(0), msg.sender, _totalSupply);
647     }
648  
649     /**
650         Sets buy/sell transaction cut
651     */
652     event Cuts(
653         uint256 _marketingBuy,
654         uint256 _farmingBuy,
655         uint256 _marketingSell,
656         uint256 _farmingSell
657     );
658     
659 
660     // Remove cut forever
661     function removeCuts() external onlyOwner {
662         txCut["marketingBuy"] = 0;
663         txCut["farmingBuy"] = 0;
664  
665         txCut["marketingSell"] = 0;
666         txCut["farmingSell"] = 0;
667  
668         emit Cuts(
669             0,
670             0,
671             0,
672             0
673         );
674     }
675  
676     /**
677         Returns buy/sell transaction
678     */
679     function getCut() public view returns(
680         uint256 marketingBuy,
681         uint256 farmingBuy,
682         uint256 marketingSell,
683         uint256 farmingSell
684     ) {
685         return (
686             txCut["marketingBuy"],
687             txCut["farmingBuy"],
688             txCut["marketingSell"],
689             txCut["farmingSell"]
690         );
691     }
692  
693     /**
694         Sets the tax collector contracts
695     */
696     function setTaxAddress(address _tAddress1) external onlyOwner {
697         tAddress1 = _tAddress1;
698     }
699  
700     /**
701         Sets the tax free trading for the specific address
702     */
703     function setCutExempt(address _address, bool _value) external onlyOwner {
704         cutExempt[_address] = _value;
705     }
706  
707     /**
708         Sets the limit free trading for the specific address
709     */
710     function setTxExempt(address _address, bool _value) external onlyOwner {
711         txExempt[_address] = _value;
712     }
713  
714     /**
715         Remove limits forever
716     */
717     function removeLimits() external onlyOwner {
718         txLimits.inactive = true;
719     }
720  
721     /**
722         Sell tokens at
723     */
724     function setSwapTokens(uint256 _swapTokensAt, uint256 _lastSwap, uint256 _delay, uint256 _minToSend) external onlyOwner {
725         swapTokens.swapTokensAt = _swapTokensAt;
726         swapTokens.lastSwap = _lastSwap;
727         swapTokens.swapDelay = _delay;
728         swapTokens.minToSend = _minToSend;
729     }
730  
731     /**
732         Returns the sell/buy limits & cooldown period
733     */
734     function getTxLimits() public view returns(uint256 buyLimit, uint256 sellLimit, bool inactive) {
735         return (txLimits.buyLimit, txLimits.sellLimit, txLimits.inactive);
736     }
737  
738     /**
739         Checks the BUY transaction limits for the specific user with the sent amount
740     */
741     function checkBuyTx(address _sender, uint256 _amount) internal view {
742         require(
743             txLimits.inactive == true ||
744             txExempt[_sender] == true ||
745             _amount < txLimits.buyLimit,
746             "Buy transaction limit reached!"
747         );
748     }
749  
750     /**
751         Checks the SELL transaction limits for the specific user with the sent amount
752     */
753     function checkSellTx(address _sender, uint256 _amount) internal view {
754         require(
755             txLimits.inactive == true ||
756             txExempt[_sender] == true ||
757             _amount < txLimits.sellLimit,
758             "Sell transaction limit reached!"
759         );
760     }
761  
762     /**
763         Automatic swap
764     */
765  
766     function swapTokensForNative(uint256 _amount) internal {
767         address[] memory path = new address[](2);
768         path[0] = address(this);
769         path[1] = uniswapV2Router.WETH();
770         _approve(address(this), address(uniswapV2Router), _amount);
771         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
772             _amount,
773             0,
774             path,
775             address(this),
776             block.timestamp
777         );
778     }
779  
780     function manualSwapTokensForNative(uint256 _amount) external onlyOwner {
781         address[] memory path = new address[](2);
782         path[0] = address(this);
783         path[1] = uniswapV2Router.WETH();
784         _approve(address(this), address(uniswapV2Router), _amount);
785         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
786             _amount,
787             0,
788             path,
789             address(this),
790             block.timestamp
791         );
792     }
793  
794     function manualSendNative() external onlyOwner {
795         uint256 contractNativeBalance = address(this).balance;
796         sendNativeTokens(contractNativeBalance);
797     }
798  
799     function withdrawAnyToken(address payable _to, IERC20 _token) public onlyOwner {
800         _token.transfer(_to, _token.balanceOf(address(this)));
801     }
802  
803     function sendNativeTokens(uint256 _amount) private {
804         payable(tAddress1).transfer(_amount);
805     }
806  
807    /**
808      * @dev Returns the name of the token.
809      */
810     function name() public view virtual override returns (string memory) {
811         return _name;
812     }
813  
814     /**
815      * @dev Returns the symbol of the token, usually a shorter version of the
816      * name.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821  
822     function decimals() public view virtual override returns (uint8) {
823         return _decimals;
824     }
825  
826     function totalSupply() public view virtual override returns (uint256) {
827         return _totalSupply;
828     }
829  
830     function balanceOf(address account) public view virtual override returns (uint256) {
831         return _balances[account];
832     }
833  
834     /**
835      * @dev See {IERC20-transfer}.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - the caller must have a balance of at least `amount`.
841      */
842     function transfer(address to, uint256 amount) public virtual override returns (bool) {
843         address owner = _msgSender();
844         _transfer(owner, to, amount);
845         return true;
846     }
847  
848     /**
849      * @dev See {IERC20-allowance}.
850      */
851     function allowance(address owner, address spender) public view virtual override returns (uint256) {
852         return _allowances[owner][spender];
853     }
854  
855     /**
856      * @dev See {IERC20-approve}.
857      *
858      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
859      * `transferFrom`. This is semantically equivalent to an infinite approval.
860      *
861      * Requirements:
862      *
863      * - `spender` cannot be the zero address.
864      */
865     function approve(address spender, uint256 amount) public virtual override returns (bool) {
866         address owner = _msgSender();
867         _approve(owner, spender, amount);
868         return true;
869     }
870  
871     /**
872      * @dev See {IERC20-transferFrom}.
873      *
874      * Emits an {Approval} event indicating the updated allowance. This is not
875      * required by the EIP. See the note at the beginning of {ERC20}.
876      *
877      * NOTE: Does not update the allowance if the current allowance
878      * is the maximum `uint256`.
879      *
880      * Requirements:
881      *
882      * - `from` and `to` cannot be the zero address.
883      * - `from` must have a balance of at least `amount`.
884      * - the caller must have allowance for ``from``'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 amount
891     ) public virtual override returns (bool) {
892         address spender = _msgSender();
893         _spendAllowance(from, spender, amount);
894         _transfer(from, to, amount);
895         return true;
896     }
897  
898     /**
899      * @dev Atomically increases the allowance granted to `spender` by the caller.
900      *
901      * This is an alternative to {approve} that can be used as a mitigation for
902      * problems described in {IERC20-approve}.
903      *
904      * Emits an {Approval} event indicating the updated allowance.
905      *
906      * Requirements:
907      *
908      * - `spender` cannot be the zero address.
909      */
910     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
911         address owner = _msgSender();
912         _approve(owner, spender, allowance(owner, spender) + addedValue);
913         return true;
914     }
915  
916     /**
917      * @dev Atomically decreases the allowance granted to `spender` by the caller.
918      *
919      * This is an alternative to {approve} that can be used as a mitigation for
920      * problems described in {IERC20-approve}.
921      *
922      * Emits an {Approval} event indicating the updated allowance.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      * - `spender` must have allowance for the caller of at least
928      * `subtractedValue`.
929      */
930     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
931         address owner = _msgSender();
932         uint256 currentAllowance = allowance(owner, spender);
933         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
934         unchecked {
935             _approve(owner, spender, currentAllowance - subtractedValue);
936         }
937  
938         return true;
939     }
940  
941     /**
942      * @dev Moves `amount` of tokens from `sender` to `recipient`.
943      *
944      * This internal function is equivalent to {transfer}, and can be used to
945      * e.g. implement automatic token fees, slashing mechanisms, etc.
946      *
947      * Emits a {Transfer} event.
948      *
949      * Requirements:
950      *
951      * - `from` cannot be the zero address.
952      * - `to` cannot be the zero address.
953      * - `from` must have a balance of at least `amount`.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 amount
959     ) internal virtual {
960         require(from != address(0), "ERC20: transfer from the zero address");
961         require(to != address(0), "ERC20: transfer to the zero address");
962  
963         uint256 fromBalance = _balances[from];
964         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
965  
966         uint256 marketingCut;
967         uint256 farmingCut;
968  
969         bool hasCut = true;
970  
971         // BUY
972         if(from == uniswapV2Pair) {
973  
974             checkBuyTx(to, amount);
975  
976             marketingCut = txCut["marketingBuy"];
977             farmingCut = txCut["farmingBuy"];
978         }
979         // SELL
980         else if(to == uniswapV2Pair) {
981             checkSellTx(from, amount);
982  
983             marketingCut = txCut["marketingSell"];
984             farmingCut = txCut["farmingSell"];
985         }
986  
987         unchecked {
988             _balances[from] = fromBalance - amount;
989         }
990  
991         if(cutExempt[to] || cutExempt[from]) {
992             hasCut = false;
993         }
994  
995         if(hasCut && (to == uniswapV2Pair || from == uniswapV2Pair)) {
996             TokenCut memory TokenCuts;
997             TokenCuts.forMarketing = amount.mul(marketingCut).div(10000);
998             TokenCuts.forFarming = amount.mul(farmingCut).div(10000);
999  
1000             uint256 totalCuts =
1001                 TokenCuts.forMarketing
1002                 .add(TokenCuts.forFarming);
1003  
1004             amount = amount.sub(totalCuts);
1005  
1006             _balances[address(this)] += totalCuts; // farming, marketing
1007             emit Transfer(from, address(this), totalCuts);
1008  
1009             // If active we do swap
1010             uint256 contractTokenBalance = _balances[address(this)];
1011  
1012             if (
1013                 contractTokenBalance > swapTokens.swapTokensAt &&
1014                 block.timestamp > swapTokens.lastSwap + swapTokens.swapDelay &&
1015                 to == uniswapV2Pair
1016             ) {
1017  
1018                 // Random tokens between 0 - 50000
1019                 uint256 randomTokens = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 50000) * 10**18;
1020  
1021                 // Balance can be 15% more
1022                 if(contractTokenBalance > (swapTokens.swapTokensAt.add(randomTokens)).mul(1500).div(10000)) {
1023                     swapTokensForNative(swapTokens.swapTokensAt.add(randomTokens));
1024                 }
1025  
1026                 swapTokens.lastSwap = block.timestamp;
1027  
1028                 if(address(this).balance > swapTokens.minToSend) {
1029                     sendNativeTokens(address(this).balance);
1030                  }
1031             }
1032         }
1033  
1034         _balances[to] += amount;
1035         emit Transfer(from, to, amount);
1036     }
1037  
1038     /**
1039      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1040      *
1041      * This internal function is equivalent to `approve`, and can be used to
1042      * e.g. set automatic allowances for certain subsystems, etc.
1043      *
1044      * Emits an {Approval} event.
1045      *
1046      * Requirements:
1047      *
1048      * - `owner` cannot be the zero address.
1049      * - `spender` cannot be the zero address.
1050      */
1051     function _approve(
1052         address owner,
1053         address spender,
1054         uint256 amount
1055     ) internal virtual {
1056         require(owner != address(0), "ERC20: approve from the zero address");
1057         require(spender != address(0), "ERC20: approve to the zero address");
1058  
1059         _allowances[owner][spender] = amount;
1060         emit Approval(owner, spender, amount);
1061     }
1062  
1063     /**
1064      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1065      *
1066      * Does not update the allowance amount in case of infinite allowance.
1067      * Revert if not enough allowance is available.
1068      *
1069      * Might emit an {Approval} event.
1070      */
1071     function _spendAllowance(
1072         address owner,
1073         address spender,
1074         uint256 amount
1075     ) internal virtual {
1076         uint256 currentAllowance = allowance(owner, spender);
1077         if (currentAllowance != type(uint256).max) {
1078             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1079             unchecked {
1080                 _approve(owner, spender, currentAllowance - amount);
1081             }
1082         }
1083     }
1084  
1085     /**
1086      * @dev Destroys `amount` tokens from `account`, reducing the
1087      * total supply.
1088      *
1089      * Emits a {Transfer} event with `to` set to the zero address.
1090      *
1091      * Requirements:
1092      *
1093      * - `account` cannot be the zero address.
1094      * - `account` must have at least `amount` tokens.
1095      */
1096     function _burn(address account, uint256 amount) internal virtual {
1097         require(account != address(0), "ERC20: burn from the zero address");
1098  
1099         uint256 accountBalance = _balances[account];
1100         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1101         unchecked {
1102             _balances[account] = accountBalance - amount;
1103             // Overflow not possible: amount <= accountBalance <= totalSupply.
1104             _totalSupply -= amount;
1105         }
1106  
1107         emit Transfer(account, address(0), amount);
1108     }
1109  
1110     /**
1111      * @dev Destroys `amount` tokens from the caller.
1112      *
1113      * See {ERC20-_burn}.
1114      */
1115     function burn(uint256 amount) public virtual {
1116         _burn(_msgSender(), amount);
1117     }
1118 }