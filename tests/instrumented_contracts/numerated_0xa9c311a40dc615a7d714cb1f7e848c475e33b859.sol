1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7f6a1666fac8ecff5dd467d0938069bc221ea9e0/contracts/utils/math/SafeMath.sol
2  
3  
4  
5 pragma solidity ^0.8.0;
6  
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10  
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30  
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42  
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59  
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71  
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83  
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97  
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111  
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125  
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139  
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155  
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         }
174     }
175  
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         }
197     }
198  
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a % b;
218         }
219     }
220 }
221  
222 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
223  
224  
225 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
226  
227 pragma solidity ^0.8.0;
228  
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243  
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248  
249 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
250  
251  
252 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
253  
254 pragma solidity ^0.8.0;
255  
256  
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271  
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273  
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280  
281     /**
282      * @dev Throws if called by any account other than the owner.
283      */
284     modifier onlyOwner() {
285         _checkOwner();
286         _;
287     }
288  
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295  
296     /**
297      * @dev Throws if the sender is not the owner.
298      */
299     function _checkOwner() internal view virtual {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301     }
302  
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _transferOwnership(address(0));
312     }
313  
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _transferOwnership(newOwner);
321     }
322  
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Internal function without access restriction.
326      */
327     function _transferOwnership(address newOwner) internal virtual {
328         address oldOwner = _owner;
329         _owner = newOwner;
330         emit OwnershipTransferred(oldOwner, newOwner);
331     }
332 }
333  
334 // File: poms.sol
335  
336  
337  
338 pragma solidity ^0.8.7;
339  
340  
341  
342 /**
343  * @dev Interfaces
344  */
345  
346 interface IUniswapV2Factory {
347     function createPair(address tokenA, address tokenB) external returns (address pair);
348 }
349  
350 interface IUniswapV2Router01 {
351     function factory() external pure returns (address);
352     function WETH() external pure returns (address);
353  
354     function addLiquidity(
355         address tokenA,
356         address tokenB,
357         uint amountADesired,
358         uint amountBDesired,
359         uint amountAMin,
360         uint amountBMin,
361         address to,
362         uint deadline
363     ) external returns (uint amountA, uint amountB, uint liquidity);
364     function addLiquidityETH(
365         address token,
366         uint amountTokenDesired,
367         uint amountTokenMin,
368         uint amountETHMin,
369         address to,
370         uint deadline
371     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
372     function removeLiquidity(
373         address tokenA,
374         address tokenB,
375         uint liquidity,
376         uint amountAMin,
377         uint amountBMin,
378         address to,
379         uint deadline
380     ) external returns (uint amountA, uint amountB);
381     function removeLiquidityETH(
382         address token,
383         uint liquidity,
384         uint amountTokenMin,
385         uint amountETHMin,
386         address to,
387         uint deadline
388     ) external returns (uint amountToken, uint amountETH);
389     function removeLiquidityWithPermit(
390         address tokenA,
391         address tokenB,
392         uint liquidity,
393         uint amountAMin,
394         uint amountBMin,
395         address to,
396         uint deadline,
397         bool approveMax, uint8 v, bytes32 r, bytes32 s
398     ) external returns (uint amountA, uint amountB);
399     function removeLiquidityETHWithPermit(
400         address token,
401         uint liquidity,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline,
406         bool approveMax, uint8 v, bytes32 r, bytes32 s
407     ) external returns (uint amountToken, uint amountETH);
408     function swapExactTokensForTokens(
409         uint amountIn,
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external returns (uint[] memory amounts);
415     function swapTokensForExactTokens(
416         uint amountOut,
417         uint amountInMax,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external returns (uint[] memory amounts);
422     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
423         external
424         payable
425         returns (uint[] memory amounts);
426     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
427         external
428         returns (uint[] memory amounts);
429     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
430         external
431         returns (uint[] memory amounts);
432     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
433         external
434         payable
435         returns (uint[] memory amounts);
436  
437     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
438     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
439     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
440     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
441     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
442 }
443  
444 interface IUniswapV2Router02 is IUniswapV2Router01{
445     function removeLiquidityETHSupportingFeeOnTransferTokens(
446         address token,
447         uint liquidity,
448         uint amountTokenMin,
449         uint amountETHMin,
450         address to,
451         uint deadline
452     ) external returns (uint amountETH);
453     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
454         address token,
455         uint liquidity,
456         uint amountTokenMin,
457         uint amountETHMin,
458         address to,
459         uint deadline,
460         bool approveMax, uint8 v, bytes32 r, bytes32 s
461     ) external returns (uint amountETH);
462  
463     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
464         uint amountIn,
465         uint amountOutMin,
466         address[] calldata path,
467         address to,
468         uint deadline
469     ) external;
470     function swapExactETHForTokensSupportingFeeOnTransferTokens(
471         uint amountOutMin,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external payable;
476     function swapExactTokensForETHSupportingFeeOnTransferTokens(
477         uint amountIn,
478         uint amountOutMin,
479         address[] calldata path,
480         address to,
481         uint deadline
482     ) external;
483 }
484  
485 /**
486  * @dev Interface of the ERC20 standard as defined in the EIP.
487  */
488 interface IERC20 {
489     function totalSupply() external view returns (uint256);
490     function balanceOf(address account) external view returns (uint256);
491     function transfer(address to, uint256 amount) external returns (bool);
492     function allowance(address owner, address spender) external view returns (uint256);
493     function approve(address spender, uint256 amount) external returns (bool);
494  
495     /**
496      * @dev Returns the decimals places of the token.
497      */
498     function decimals() external view returns (uint8);
499  
500     /**
501      * @dev Moves `amount` tokens from `from` to `to` using the
502      * allowance mechanism. `amount` is then deducted from the caller's
503      * allowance.
504      *
505      * Returns a boolean value indicating whether the operation succeeded.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(
510         address from,
511         address to,
512         uint256 amount
513     ) external returns (bool);
514  
515     /**
516      * @dev Emitted when `value` tokens are moved from one account (`from`) to
517      * another (`to`).
518      *
519      * Note that `value` may be zero.
520      */
521     event Transfer(address indexed from, address indexed to, uint256 value);
522  
523     /**
524      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
525      * a call to {approve}. `value` is the new allowance.
526      */
527     event Approval(address indexed owner, address indexed spender, uint256 value);
528 }
529  
530 /**
531  * @dev Interface for the optional metadata functions from the ERC20 standard.
532  *
533  * _Available since v4.1._
534  */
535 interface IERC20Metadata is IERC20 {
536     /**
537      * @dev Returns the name of the token.
538      */
539     function name() external view returns (string memory);
540  
541     /**
542      * @dev Returns the symbol of the token.
543      */
544     function symbol() external view returns (string memory);
545 }
546  
547 contract PBLToken is Context, IERC20, IERC20Metadata, Ownable {
548     receive() external payable {}
549  
550     event SendNative(bool _wallet);
551  
552     using SafeMath for uint256;
553  
554     mapping(address => uint256) private _balances;
555  
556     mapping(address => mapping(address => uint256)) private _allowances;
557  
558     uint256 _totalSupply;
559     string private _name;
560     string private _symbol;
561     uint8 private _decimals;
562  
563     // fees & addresses
564     mapping (string => uint) txFees;
565  
566     mapping (address => bool) public feeExempt;
567     mapping (address => bool) public txLimitExempt;
568  
569     address public farmingAddress = msg.sender;
570     address public taxAddress = msg.sender;
571     address public nativeTokenAddress = msg.sender;
572  
573     // taxes for differnet levels
574  
575     struct TokenFee {
576         uint forMarketing;
577         uint forDev;
578         uint forFarming;
579     }
580  
581     struct TxLimit {
582         uint buyLimit;
583         uint sellLimit;
584         uint cooldown;
585         bool inactive;
586         mapping(address => uint) buys;
587         mapping(address => uint) sells;
588         mapping(address => uint) lastTx;
589     }
590  
591     TxLimit txLimits;
592  
593     struct SwapToken {
594         uint swapTokensAt;
595         uint lastSwap;
596         uint swapDelay;
597         uint minToSend;
598     }
599  
600     SwapToken public swapTokens;
601  
602     IUniswapV2Router02 public uniswapV2Router;
603     address public uniswapV2Pair;
604  
605     constructor() {
606         _name = "POM Blend";
607         _symbol = "PBL";
608         _decimals = 18;
609         _totalSupply = 100_000_000 * (10 ** decimals());
610  
611         feeExempt[msg.sender] = true;
612         txLimitExempt[msg.sender] = true;
613         feeExempt[address(this)] = true;
614         txLimitExempt[address(this)] = true;
615         feeExempt[farmingAddress] = true;
616         txLimitExempt[farmingAddress] = true;
617         feeExempt[taxAddress] = true;
618         txLimitExempt[taxAddress] = true;
619         feeExempt[nativeTokenAddress] = true;
620         txLimitExempt[nativeTokenAddress] = true;
621  
622         /**
623             Set default buy/sell tx fees (no tax on transfers)
624             - marketing, dev, liqudity, farming
625         */
626         txFees["marketingBuy"] = 100; // 1%
627         txFees["liqBuy"] = 250;
628         txFees["farmingBuy"] = 100;
629  
630         txFees["marketingSell"] = 200;
631         txFees["liqSell"] = 500;
632         txFees["farmingSell"] = 200;
633  
634         /**
635             Set default tx limits
636             - Cooldown, buy limit, sell limit
637         */
638         txLimits.cooldown = 30 seconds;
639         txLimits.buyLimit = _totalSupply.div(100);
640         txLimits.sellLimit = _totalSupply.div(100);
641  
642         swapTokens.swapTokensAt = _totalSupply.div(1394); // 0.1%
643         swapTokens.minToSend = 10_000 ether;
644         swapTokens.swapDelay = 1 minutes;
645  
646         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
647         uniswapV2Router = _uniswapV2Router;
648         _approve(address(this), address(uniswapV2Router), _totalSupply);
649         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
650         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
651  
652         approve(address(uniswapV2Router), _totalSupply);
653         feeExempt[address(uniswapV2Router)] = true;
654  
655         _balances[msg.sender] = _totalSupply;
656         emit Transfer(address(0), msg.sender, _totalSupply);
657     }
658  
659     /**
660         Sets buy/sell transaction fees
661     */
662     event Fees(
663         uint _marketingBuy,
664         uint _liqBuy,
665         uint _farmingBuy,
666         uint _marketingSell,
667         uint _liqSell,
668         uint _farmingSell
669     );
670  
671     function setFees(
672         uint _marketingBuy,
673         uint _liqBuy,
674         uint _farmingBuy,
675         uint _marketingSell,
676         uint _liqSell,
677         uint _farmingSell
678     ) external onlyOwner {
679         require(_marketingBuy <= 800, "Marketing fee is too high!");
680         require(_liqBuy <= 800, "Dev fee is too high!");
681         require(_farmingBuy <= 800, "Farming fee is too high!");
682         require(_marketingSell <= 800, "Marketing fee is too high!");
683         require(_liqSell <= 800, "Dev fee is too high!");
684         require(_farmingSell <= 800, "Farming fee is too high!");
685  
686         txFees["marketingBuy"] = _marketingBuy;
687         txFees["liqBuy"] = _liqBuy;
688         txFees["farmingBuy"] = _farmingBuy;
689  
690         txFees["marketingSell"] = _marketingSell;
691         txFees["liqSell"] = _liqSell;
692         txFees["farmingSell"] = _farmingSell;
693  
694         emit Fees(
695             _marketingBuy,
696             _liqBuy,
697             _farmingBuy,
698             _marketingSell,
699             _liqSell,
700             _farmingSell
701         );
702     }
703  
704     /**
705         Returns buy/sell transaction fees
706     */
707     function getFees() public view returns(
708         uint marketingBuy,
709         uint liqBuy,
710         uint farmingBuy,
711         uint marketingSell,
712         uint liqSell,
713         uint farmingSell
714     ) {
715         return (
716             txFees["marketingBuy"],
717             txFees["liqBuy"],
718             txFees["farmingBuy"],
719             txFees["marketingSell"],
720             txFees["liqSell"],
721             txFees["farmingSell"]
722         );
723     }
724  
725     /**
726         Sets the tax collector contracts
727     */
728     function setTaxAddress(address _farmingAddress, address _taxAddress, address _nativeTokenAddress) external onlyOwner {
729         farmingAddress = _farmingAddress;
730         taxAddress = _taxAddress;
731         nativeTokenAddress = _nativeTokenAddress;
732     }
733  
734     /**
735         Sets the tax free trading for the specific address
736     */
737     function setFeeExempt(address _address, bool _value) external onlyOwner {
738         feeExempt[_address] = _value;
739     }
740  
741     /**
742         Sets the limit free trading for the specific address
743     */
744     function setTxLimitExempt(address _address, bool _value) external onlyOwner {
745         txLimitExempt[_address] = _value;
746     }
747  
748     /**
749         Sets the sell/buy limits & cooldown period
750     */
751     function setTxLimits(uint _buyLimit, uint _sellLimit, uint _cooldown, bool _inactive) external onlyOwner {
752         require(_buyLimit >= _totalSupply.div(200), "Buy transaction limit is too low!"); // 0.5%
753         require(_sellLimit >= _totalSupply.div(400), "Sell transaction limit is too low!"); // 0.25%
754         require(_cooldown <= 30 minutes, "Cooldown should be 30 minutes or less!");
755  
756         txLimits.buyLimit = _buyLimit;
757         txLimits.sellLimit = _sellLimit;
758         txLimits.cooldown = _cooldown;
759         txLimits.inactive = _inactive;
760     }
761  
762     /**
763         Sell tokens at
764     */
765     function setSwapTokens(uint _swapTokensAt, uint _lastSwap, uint _delay) external onlyOwner {
766         swapTokens.swapTokensAt = _swapTokensAt;
767         swapTokens.lastSwap = _lastSwap;
768         swapTokens.swapDelay = _delay;
769     }
770  
771     /**
772         Returns the sell/buy limits & cooldown period
773     */
774     function getTxLimits() public view returns(uint buyLimit, uint sellLimit, uint cooldown, bool inactive) {
775         return (txLimits.buyLimit, txLimits.sellLimit, txLimits.cooldown, txLimits.inactive);
776     }
777  
778     /**
779         Checks the BUY transaction limits for the specific user with the sent amount
780     */
781     function checkBuyTxLimit(address _sender, uint256 _amount) internal view {
782         require(
783             txLimits.inactive == true ||
784             txLimitExempt[_sender] == true ||
785             txLimits.buys[_sender].add(_amount) < txLimits.buyLimit ||
786             (txLimits.buys[_sender].add(_amount) > txLimits.buyLimit &&
787             txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp),
788             "Buy transaction limit reached!"
789         );
790     }
791  
792     /**
793         Checks the SELL transaction limits for the specific user with the sent amount
794     */
795     function checkSellTxLimit(address _sender, uint256 _amount) internal view {
796         require(
797             txLimits.inactive == true ||
798             txLimitExempt[_sender] == true ||
799             txLimits.sells[_sender].add(_amount) < txLimits.sellLimit ||
800             (txLimits.sells[_sender].add(_amount) > txLimits.sellLimit &&
801             txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp),
802             "Sell transaction limit reached!"
803         );
804     }
805  
806     /**
807         Saves the recent buy/sell transactions
808         The function used by _transfer() when the cooldown/tx limit is active
809     */
810     function setRecentTx(bool _isSell, address _sender, uint _amount) internal {
811         if(txLimits.lastTx[_sender].add(txLimits.cooldown) < block.timestamp) {
812             _isSell ? txLimits.sells[_sender] = _amount : txLimits.buys[_sender] = _amount;
813         } else {
814             _isSell ? txLimits.sells[_sender] += _amount : txLimits.buys[_sender] += _amount;
815         }
816  
817         txLimits.lastTx[_sender] = block.timestamp;
818     }
819  
820     /**
821         Returns the recent buys, sells and the last transaction for the specific wallet
822     */
823     function getRecentTx(address _address) public view returns(uint buys, uint sells, uint lastTx) {
824         return (txLimits.buys[_address], txLimits.sells[_address], txLimits.lastTx[_address]);
825     }
826  
827     /**
828         Automatic swap
829     */
830  
831     function swapTokensForNative(uint256 _amount) internal {
832         address[] memory path = new address[](2);
833         path[0] = address(this);
834         path[1] = uniswapV2Router.WETH();
835         _approve(address(this), address(uniswapV2Router), _amount);
836         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
837             _amount,
838             0,
839             path,
840             address(this),
841             block.timestamp
842         );
843     }
844  
845     function manualSwapTokensForNative(uint256 _amount) external onlyOwner {
846         address[] memory path = new address[](2);
847         path[0] = address(this);
848         path[1] = uniswapV2Router.WETH();
849         _approve(address(this), address(uniswapV2Router), _amount);
850         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
851             _amount,
852             0,
853             path,
854             address(this),
855             block.timestamp
856         );
857     }
858  
859     function manualSendNative() external onlyOwner {
860         uint256 contractNativeBalance = address(this).balance;
861         sendNativeTokens(contractNativeBalance);
862     }
863  
864     function sendNativeTokens(uint256 _amount) private {
865  
866         (bool success, ) = payable(nativeTokenAddress).call{value: _amount.div(3)}("");
867         (bool success2, ) = payable(farmingAddress).call{value: _amount.div(3)}("");
868         (bool success3, ) = payable(taxAddress).call{value: _amount.div(3)}("");
869  
870         emit SendNative(success);
871         emit SendNative(success2);
872         emit SendNative(success3);
873     }
874  
875     function withdrawAnyToken(address payable _to, IERC20 _token) public onlyOwner {
876         _token.transfer(_to, _token.balanceOf(address(this)));
877     }
878  
879     /**
880      * @dev Returns the name of the token.
881      */
882     function name() public view virtual override returns (string memory) {
883         return _name;
884     }
885  
886     /**
887      * @dev Returns the symbol of the token, usually a shorter version of the
888      * name.
889      */
890     function symbol() public view virtual override returns (string memory) {
891         return _symbol;
892     }
893  
894     function decimals() public view virtual override returns (uint8) {
895         return _decimals;
896     }
897  
898     function totalSupply() public view virtual override returns (uint256) {
899         return _totalSupply;
900     }
901  
902     function balanceOf(address account) public view virtual override returns (uint256) {
903         return _balances[account];
904     }
905  
906     /**
907      * @dev See {IERC20-transfer}.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - the caller must have a balance of at least `amount`.
913      */
914     function transfer(address to, uint256 amount) public virtual override returns (bool) {
915         address owner = _msgSender();
916         _transfer(owner, to, amount);
917         return true;
918     }
919  
920     /**
921      * @dev See {IERC20-allowance}.
922      */
923     function allowance(address owner, address spender) public view virtual override returns (uint256) {
924         return _allowances[owner][spender];
925     }
926  
927     /**
928      * @dev See {IERC20-approve}.
929      *
930      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
931      * `transferFrom`. This is semantically equivalent to an infinite approval.
932      *
933      * Requirements:
934      *
935      * - `spender` cannot be the zero address.
936      */
937     function approve(address spender, uint256 amount) public virtual override returns (bool) {
938         address owner = _msgSender();
939         _approve(owner, spender, amount);
940         return true;
941     }
942  
943     /**
944      * @dev See {IERC20-transferFrom}.
945      *
946      * Emits an {Approval} event indicating the updated allowance. This is not
947      * required by the EIP. See the note at the beginning of {ERC20}.
948      *
949      * NOTE: Does not update the allowance if the current allowance
950      * is the maximum `uint256`.
951      *
952      * Requirements:
953      *
954      * - `from` and `to` cannot be the zero address.
955      * - `from` must have a balance of at least `amount`.
956      * - the caller must have allowance for ``from``'s tokens of at least
957      * `amount`.
958      */
959     function transferFrom(
960         address from,
961         address to,
962         uint256 amount
963     ) public virtual override returns (bool) {
964         address spender = _msgSender();
965         _spendAllowance(from, spender, amount);
966         _transfer(from, to, amount);
967         return true;
968     }
969  
970     /**
971      * @dev Atomically increases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      */
982     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
983         address owner = _msgSender();
984         _approve(owner, spender, allowance(owner, spender) + addedValue);
985         return true;
986     }
987  
988     /**
989      * @dev Atomically decreases the allowance granted to `spender` by the caller.
990      *
991      * This is an alternative to {approve} that can be used as a mitigation for
992      * problems described in {IERC20-approve}.
993      *
994      * Emits an {Approval} event indicating the updated allowance.
995      *
996      * Requirements:
997      *
998      * - `spender` cannot be the zero address.
999      * - `spender` must have allowance for the caller of at least
1000      * `subtractedValue`.
1001      */
1002     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1003         address owner = _msgSender();
1004         uint256 currentAllowance = allowance(owner, spender);
1005         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1006         unchecked {
1007             _approve(owner, spender, currentAllowance - subtractedValue);
1008         }
1009  
1010         return true;
1011     }
1012  
1013     /**
1014      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1015      *
1016      * This internal function is equivalent to {transfer}, and can be used to
1017      * e.g. implement automatic token fees, slashing mechanisms, etc.
1018      *
1019      * Emits a {Transfer} event.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `to` cannot be the zero address.
1025      * - `from` must have a balance of at least `amount`.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 amount
1031     ) internal virtual {
1032         require(from != address(0), "ERC20: transfer from the zero address");
1033         require(to != address(0), "ERC20: transfer to the zero address");
1034  
1035         uint256 fromBalance = _balances[from];
1036         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1037  
1038         uint marketingFee;
1039         uint devFee;
1040         uint farmingFee;
1041  
1042         bool hasFees = true;
1043  
1044         // BUY
1045         if(from == uniswapV2Pair) {
1046             // Add bots to blacklist before launch on buy
1047  
1048             checkBuyTxLimit(to, amount);
1049  
1050             setRecentTx(false, to, amount);
1051  
1052             marketingFee = txFees["marketingBuy"];
1053             devFee = txFees["liqBuy"];
1054             farmingFee = txFees["farmingBuy"];
1055         }
1056         // SELL
1057         else if(to == uniswapV2Pair) {
1058             checkSellTxLimit(from, amount);
1059  
1060             setRecentTx(true, from, amount);
1061  
1062             marketingFee = txFees["marketingSell"];
1063             devFee = txFees["liqSell"];
1064             farmingFee = txFees["farmingSell"];
1065         }
1066  
1067         unchecked {
1068             _balances[from] = fromBalance - amount;
1069         }
1070  
1071         if(feeExempt[to] || feeExempt[from]) {
1072             hasFees = false;
1073         }
1074  
1075         if(hasFees && (to == uniswapV2Pair || from == uniswapV2Pair)) {
1076             TokenFee memory TokenFees;
1077             TokenFees.forMarketing = amount.mul(marketingFee).div(10000);
1078             TokenFees.forDev = amount.mul(devFee).div(10000);
1079             TokenFees.forFarming = amount.mul(farmingFee).div(10000);
1080  
1081             uint totalFees =
1082                 TokenFees.forMarketing
1083                 .add(TokenFees.forDev)
1084                 .add(TokenFees.forFarming);
1085  
1086             amount = amount.sub(totalFees);
1087  
1088             _balances[address(this)] += totalFees; // dev, lp, marketing fees
1089             emit Transfer(from, address(this), totalFees);
1090  
1091             // If active we do swap
1092             uint256 contractTokenBalance = _balances[address(this)];
1093  
1094             if (
1095                 contractTokenBalance > swapTokens.swapTokensAt &&
1096                 block.timestamp > swapTokens.lastSwap + swapTokens.swapDelay &&
1097                 to == uniswapV2Pair
1098             ) {
1099                 // Balance can be 10% more
1100                 if(contractTokenBalance > swapTokens.swapTokensAt.mul(1100).div(1000)) {
1101                     swapTokensForNative(swapTokens.swapTokensAt);
1102                 } else {
1103                     swapTokensForNative(contractTokenBalance);
1104                 }
1105  
1106                 swapTokens.lastSwap = block.timestamp;
1107  
1108                 uint256 contractNativeBalance = address(this).balance;
1109  
1110                 if(contractNativeBalance > swapTokens.minToSend) {
1111                     sendNativeTokens(contractNativeBalance);
1112                 }
1113             }
1114         }
1115  
1116         _balances[to] += amount;
1117         emit Transfer(from, to, amount);
1118     }
1119  
1120     /**
1121      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1122      *
1123      * This internal function is equivalent to `approve`, and can be used to
1124      * e.g. set automatic allowances for certain subsystems, etc.
1125      *
1126      * Emits an {Approval} event.
1127      *
1128      * Requirements:
1129      *
1130      * - `owner` cannot be the zero address.
1131      * - `spender` cannot be the zero address.
1132      */
1133     function _approve(
1134         address owner,
1135         address spender,
1136         uint256 amount
1137     ) internal virtual {
1138         require(owner != address(0), "ERC20: approve from the zero address");
1139         require(spender != address(0), "ERC20: approve to the zero address");
1140  
1141         _allowances[owner][spender] = amount;
1142         emit Approval(owner, spender, amount);
1143     }
1144  
1145     /**
1146      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1147      *
1148      * Does not update the allowance amount in case of infinite allowance.
1149      * Revert if not enough allowance is available.
1150      *
1151      * Might emit an {Approval} event.
1152      */
1153     function _spendAllowance(
1154         address owner,
1155         address spender,
1156         uint256 amount
1157     ) internal virtual {
1158         uint256 currentAllowance = allowance(owner, spender);
1159         if (currentAllowance != type(uint256).max) {
1160             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1161             unchecked {
1162                 _approve(owner, spender, currentAllowance - amount);
1163             }
1164         }
1165     }
1166  
1167     /**
1168      * @dev Destroys `amount` tokens from `account`, reducing the
1169      * total supply.
1170      *
1171      * Emits a {Transfer} event with `to` set to the zero address.
1172      *
1173      * Requirements:
1174      *
1175      * - `account` cannot be the zero address.
1176      * - `account` must have at least `amount` tokens.
1177      */
1178     function _burn(address account, uint256 amount) internal virtual {
1179         require(account != address(0), "ERC20: burn from the zero address");
1180  
1181         uint256 accountBalance = _balances[account];
1182         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1183         unchecked {
1184             _balances[account] = accountBalance - amount;
1185             // Overflow not possible: amount <= accountBalance <= totalSupply.
1186             _totalSupply -= amount;
1187         }
1188  
1189         emit Transfer(account, address(0), amount);
1190     }
1191  
1192     /**
1193      * @dev Destroys `amount` tokens from the caller.
1194      *
1195      * See {ERC20-_burn}.
1196      */
1197     function burn(uint256 amount) public virtual {
1198         _burn(_msgSender(), amount);
1199     }
1200 }