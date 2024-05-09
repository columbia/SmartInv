1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.17;
4 
5 /**************************************
6 ***************************************
7 Telegram: https://t.me/XLabs_erc      
8 Website: https://xlabs.site/      
9 Twitter: https://twitter.com/XlabsBot
10 ***************************************
11 ***************************************
12 */
13 
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 /**
36  * @dev Interface for the optional metadata functions from the ERC20 standard.
37  *
38  * _Available since v4.1._
39  */
40 interface IERC20Metadata is IERC20 {
41     function name() external view returns (string memory);
42     function symbol() external view returns (string memory);
43     function decimals() external view returns (uint8);
44 }
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         return msg.data;
53     }
54 }
55 
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _setOwner(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _setOwner(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _setOwner(newOwner);
104     }
105 
106     function _setOwner(address newOwner) private {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 /**
115  * @dev Implementation of the {IERC20} interface.
116  */
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     /**
128      * @dev Sets the values for {name} and {symbol}.
129      *
130      */
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     /**
137      * @dev Returns the name of the token.
138      */
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     /**
144      * @dev Returns the symbol of the token, usually a shorter version of the
145      * name.
146      */
147     function symbol() public view virtual override returns (string memory) {
148         return _symbol;
149     }
150 
151     /**
152      * @dev Returns the number of decimals used to get its user representation.
153      */
154     function decimals() public view virtual override returns (uint8) {
155         return 18;
156     }
157 
158     /**
159      * @dev See {IERC20-totalSupply}.
160      */
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     /**
166      * @dev See {IERC20-balanceOf}.
167      */
168     function balanceOf(address account) public view virtual override returns (uint256) {
169         return _balances[account];
170     }
171 
172     /**
173      * @dev See {IERC20-transfer}.
174      *
175      */
176     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     /**
182      * @dev See {IERC20-allowance}.
183      */
184     function allowance(address owner, address spender) public view virtual override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     /**
189      * @dev See {IERC20-approve}.
190      */
191     function approve(address spender, uint256 amount) public virtual override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-transferFrom}.
198      */
199     function transferFrom(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) public virtual override returns (bool) {
204         _transfer(sender, recipient, amount);
205 
206         uint256 currentAllowance = _allowances[sender][_msgSender()];
207         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
208         unchecked {
209             _approve(sender, _msgSender(), currentAllowance - amount);
210         }
211 
212         return true;
213     }
214 
215     /**
216      * @dev Atomically increases the allowance granted to `spender` by the caller.
217      *
218      */
219     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
221         return true;
222     }
223 
224     /**
225      * @dev Atomically decreases the allowance granted to `spender` by the caller.
226      *
227      */
228     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
229         uint256 currentAllowance = _allowances[_msgSender()][spender];
230         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
231         unchecked {
232             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
233         }
234 
235         return true;
236     }
237 
238     /**
239      * @dev Moves `amount` of tokens from `sender` to `recipient`.
240      *
241      */
242     function _transfer(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) internal virtual {
247         require(sender != address(0), "ERC20: transfer from the zero address");
248         require(recipient != address(0), "ERC20: transfer to the zero address");
249 
250         _beforeTokenTransfer(sender, recipient, amount);
251 
252         uint256 senderBalance = _balances[sender];
253         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
254         unchecked {
255             _balances[sender] = senderBalance - amount;
256         }
257         _balances[recipient] += amount;
258 
259         emit Transfer(sender, recipient, amount);
260 
261         _afterTokenTransfer(sender, recipient, amount);
262     }
263 
264     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
265      * the total supply.
266      */
267     function _createTotalSupply(address account, uint256 amount) internal virtual {
268         require(account != address(0), "ERC20: mint to the zero address");
269 
270         _beforeTokenTransfer(address(0), account, amount);
271 
272         _totalSupply += amount;
273         _balances[account] += amount;
274         emit Transfer(address(0), account, amount);
275 
276         _afterTokenTransfer(address(0), account, amount);
277     }
278 
279    
280     /**
281      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
282      *
283      */
284     function _approve(
285         address owner,
286         address spender,
287         uint256 amount
288     ) internal virtual {
289         require(owner != address(0), "ERC20: approve from the zero address");
290         require(spender != address(0), "ERC20: approve to the zero address");
291 
292         _allowances[owner][spender] = amount;
293         emit Approval(owner, spender, amount);
294     }
295 
296     /**
297      * @dev Hook that is called before any transfer of tokens. This includes
298      * minting and burning.
299      */
300     function _beforeTokenTransfer(
301         address from,
302         address to,
303         uint256 amount
304     ) internal virtual {}
305 
306     /**
307      * @dev Hook that is called after any transfer of tokens. This includes
308      * minting and burning.
309      */
310     function _afterTokenTransfer(
311         address from,
312         address to,
313         uint256 amount
314     ) internal virtual {}
315 }
316 
317 
318 interface IUniswapV2Router01 {
319     function factory() external pure returns (address);
320     function WETH() external pure returns (address);
321 
322     function addLiquidity(
323         address tokenA,
324         address tokenB,
325         uint amountADesired,
326         uint amountBDesired,
327         uint amountAMin,
328         uint amountBMin,
329         address to,
330         uint deadline
331     ) external returns (uint amountA, uint amountB, uint liquidity);
332     function addLiquidityETH(
333         address token,
334         uint amountTokenDesired,
335         uint amountTokenMin,
336         uint amountETHMin,
337         address to,
338         uint deadline
339     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
340     function removeLiquidity(
341         address tokenA,
342         address tokenB,
343         uint liquidity,
344         uint amountAMin,
345         uint amountBMin,
346         address to,
347         uint deadline
348     ) external returns (uint amountA, uint amountB);
349     function removeLiquidityETH(
350         address token,
351         uint liquidity,
352         uint amountTokenMin,
353         uint amountETHMin,
354         address to,
355         uint deadline
356     ) external returns (uint amountToken, uint amountETH);
357     function removeLiquidityWithPermit(
358         address tokenA,
359         address tokenB,
360         uint liquidity,
361         uint amountAMin,
362         uint amountBMin,
363         address to,
364         uint deadline,
365         bool approveMax, uint8 v, bytes32 r, bytes32 s
366     ) external returns (uint amountA, uint amountB);
367     function removeLiquidityETHWithPermit(
368         address token,
369         uint liquidity,
370         uint amountTokenMin,
371         uint amountETHMin,
372         address to,
373         uint deadline,
374         bool approveMax, uint8 v, bytes32 r, bytes32 s
375     ) external returns (uint amountToken, uint amountETH);
376     function swapExactTokensForTokens(
377         uint amountIn,
378         uint amountOutMin,
379         address[] calldata path,
380         address to,
381         uint deadline
382     ) external returns (uint[] memory amounts);
383     function swapTokensForExactTokens(
384         uint amountOut,
385         uint amountInMax,
386         address[] calldata path,
387         address to,
388         uint deadline
389     ) external returns (uint[] memory amounts);
390     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
391         external
392         payable
393         returns (uint[] memory amounts);
394     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
395         external
396         returns (uint[] memory amounts);
397     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
398         external
399         returns (uint[] memory amounts);
400     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
401         external
402         payable
403         returns (uint[] memory amounts);
404 
405     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
406     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
407     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
408     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
409     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
410 }
411 
412 interface IUniswapV2Router02 is IUniswapV2Router01 {
413     function removeLiquidityETHSupportingFeeOnTransferTokens(
414         address token,
415         uint liquidity,
416         uint amountTokenMin,
417         uint amountETHMin,
418         address to,
419         uint deadline
420     ) external returns (uint amountETH);
421     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
422         address token,
423         uint liquidity,
424         uint amountTokenMin,
425         uint amountETHMin,
426         address to,
427         uint deadline,
428         bool approveMax, uint8 v, bytes32 r, bytes32 s
429     ) external returns (uint amountETH);
430 
431     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
432         uint amountIn,
433         uint amountOutMin,
434         address[] calldata path,
435         address to,
436         uint deadline
437     ) external;
438     function swapExactETHForTokensSupportingFeeOnTransferTokens(
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline
443     ) external payable;
444     function swapExactTokensForETHSupportingFeeOnTransferTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external;
451 }
452 
453 interface IUniswapV2Factory {
454     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
455 
456     function feeTo() external view returns (address);
457     function feeToSetter() external view returns (address);
458 
459     function getPair(address tokenA, address tokenB) external view returns (address pair);
460     function allPairs(uint) external view returns (address pair);
461     function allPairsLength() external view returns (uint);
462 
463     function createPair(address tokenA, address tokenB) external returns (address pair);
464 
465     function setFeeTo(address) external;
466     function setFeeToSetter(address) external;
467 }
468 
469 /**
470  * @dev Wrappers over Solidity's arithmetic operations.
471  */
472 library SignedSafeMath {
473     /**
474      * @dev Returns the multiplication of two signed integers, reverting on
475      * overflow.
476      */
477     function mul(int256 a, int256 b) internal pure returns (int256) {
478         return a * b;
479     }
480 
481     /**
482      * @dev Returns the integer division of two signed integers. Reverts on
483      * division by zero. The result is rounded towards zero.
484      */
485     function div(int256 a, int256 b) internal pure returns (int256) {
486         return a / b;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two signed integers, reverting on
491      * overflow.
492      */
493     function sub(int256 a, int256 b) internal pure returns (int256) {
494         return a - b;
495     }
496 
497     /**
498      * @dev Returns the addition of two signed integers, reverting on
499      * overflow.
500      */
501     function add(int256 a, int256 b) internal pure returns (int256) {
502         return a + b;
503     }
504 }
505 
506 // CAUTION
507 // This version of SafeMath should only be used with Solidity 0.8 or later,
508 // because it relies on the compiler's built in overflow checks.
509  
510 library SafeMath {
511     /**
512      * @dev Returns the addition of two unsigned integers, with an overflow flag.
513      *
514      * _Available since v3.4._
515      */
516     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
517         unchecked {
518             uint256 c = a + b;
519             if (c < a) return (false, 0);
520             return (true, c);
521         }
522     }
523 
524     /**
525      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
526      *
527      * _Available since v3.4._
528      */
529     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             if (b > a) return (false, 0);
532             return (true, a - b);
533         }
534     }
535 
536     /**
537      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
538      *
539      * _Available since v3.4._
540      */
541     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
544             // benefit is lost if 'b' is also tested.
545             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
546             if (a == 0) return (true, 0);
547             uint256 c = a * b;
548             if (c / a != b) return (false, 0);
549             return (true, c);
550         }
551     }
552 
553     /**
554      * @dev Returns the division of two unsigned integers, with a division by zero flag.
555      *
556      * _Available since v3.4._
557      */
558     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             if (b == 0) return (false, 0);
561             return (true, a / b);
562         }
563     }
564 
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b == 0) return (false, 0);
573             return (true, a % b);
574         }
575     }
576 
577     /**
578      * @dev Returns the addition of two unsigned integers, reverting on
579      * overflow.
580      */
581     function add(uint256 a, uint256 b) internal pure returns (uint256) {
582         return a + b;
583     }
584 
585     /**
586      * @dev Returns the subtraction of two unsigned integers, reverting on
587      * overflow (when the result is negative).
588      */
589     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
590         return a - b;
591     }
592 
593     /**
594      * @dev Returns the multiplication of two unsigned integers, reverting on
595      * overflow.
596      */
597     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a * b;
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers, reverting on
603      * division by zero. The result is rounded towards zero.
604      */
605     function div(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a / b;
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
611      * reverting when dividing by zero.
612      */
613     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a % b;
615     }
616 
617     /**
618      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
619      * overflow (when the result is negative).
620      */
621     function sub(
622         uint256 a,
623         uint256 b,
624         string memory errorMessage
625     ) internal pure returns (uint256) {
626         unchecked {
627             require(b <= a, errorMessage);
628             return a - b;
629         }
630     }
631 
632     /**
633      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
634      * division by zero. The result is rounded towards zero.
635      */
636     function div(
637         uint256 a,
638         uint256 b,
639         string memory errorMessage
640     ) internal pure returns (uint256) {
641         unchecked {
642             require(b > 0, errorMessage);
643             return a / b;
644         }
645     }
646 
647     /**
648      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
649      * reverting with custom message when dividing by zero.
650      */
651     function mod(
652         uint256 a,
653         uint256 b,
654         string memory errorMessage
655     ) internal pure returns (uint256) {
656         unchecked {
657             require(b > 0, errorMessage);
658             return a % b;
659         }
660     }
661 }
662 
663 /**
664  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
665  * checks.
666  */
667 library SafeCast {
668     /**
669      * @dev Returns the downcasted uint224 from uint256, reverting on
670      * overflow (when the input is greater than largest uint224).
671      */
672     function toUint224(uint256 value) internal pure returns (uint224) {
673         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
674         return uint224(value);
675     }
676 
677     /**
678      * @dev Returns the downcasted uint128 from uint256, reverting on
679      * overflow (when the input is greater than largest uint128).
680      */
681     function toUint128(uint256 value) internal pure returns (uint128) {
682         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
683         return uint128(value);
684     }
685 
686     /**
687      * @dev Returns the downcasted uint96 from uint256, reverting on
688      * overflow (when the input is greater than largest uint96).
689      */
690     function toUint96(uint256 value) internal pure returns (uint96) {
691         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
692         return uint96(value);
693     }
694 
695     /**
696      * @dev Returns the downcasted uint64 from uint256, reverting on
697      * overflow (when the input is greater than largest uint64).
698      */
699     function toUint64(uint256 value) internal pure returns (uint64) {
700         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
701         return uint64(value);
702     }
703 
704     /**
705      * @dev Returns the downcasted uint32 from uint256, reverting on
706      * overflow (when the input is greater than largest uint32).
707      */
708     function toUint32(uint256 value) internal pure returns (uint32) {
709         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
710         return uint32(value);
711     }
712 
713     /**
714      * @dev Returns the downcasted uint16 from uint256, reverting on
715      * overflow (when the input is greater than largest uint16).
716      */
717     function toUint16(uint256 value) internal pure returns (uint16) {
718         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
719         return uint16(value);
720     }
721 
722     /**
723      * @dev Returns the downcasted uint8 from uint256, reverting on
724      * overflow (when the input is greater than largest uint8).
725      */
726     function toUint8(uint256 value) internal pure returns (uint8) {
727         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
728         return uint8(value);
729     }
730 
731     /**
732      * @dev Converts a signed int256 into an unsigned uint256.
733      *
734      * Requirements:
735      *
736      * - input must be greater than or equal to 0.
737      */
738     function toUint256(int256 value) internal pure returns (uint256) {
739         require(value >= 0, "SafeCast: value must be positive");
740         return uint256(value);
741     }
742 
743     /**
744      * @dev Returns the downcasted int128 from int256, reverting on
745      * overflow (when the input is less than smallest int128 or
746      */
747     function toInt128(int256 value) internal pure returns (int128) {
748         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
749         return int128(value);
750     }
751 
752     /**
753      * @dev Returns the downcasted int64 from int256, reverting on
754      * overflow (when the input is less than smallest int64 or
755      */
756     function toInt64(int256 value) internal pure returns (int64) {
757         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
758         return int64(value);
759     }
760 
761     /**
762      * @dev Returns the downcasted int32 from int256, reverting on
763      * overflow (when the input is less than smallest int32 or
764      */
765     function toInt32(int256 value) internal pure returns (int32) {
766         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
767         return int32(value);
768     }
769 
770     /**
771      * @dev Returns the downcasted int16 from int256, reverting on
772      * overflow (when the input is less than smallest int16 or
773      */
774     function toInt16(int256 value) internal pure returns (int16) {
775         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
776         return int16(value);
777     }
778 
779     /**
780      * @dev Returns the downcasted int8 from int256, reverting on
781      * overflow (when the input is less than smallest int8 or
782      */
783     function toInt8(int256 value) internal pure returns (int8) {
784         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
785         return int8(value);
786     }
787 
788     /**
789      * @dev Converts an unsigned uint256 into a signed int256.
790      */
791     function toInt256(uint256 value) internal pure returns (int256) {
792         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
793         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
794         return int256(value);
795     }
796 }
797 
798 contract Xlabs is ERC20, Ownable {
799 
800     using SafeMath for uint256;
801 
802     IUniswapV2Router02 public uniswapV2Router;
803     address public immutable uniswapV2Pair;
804 
805     uint256 public liquidityTokens;
806     uint256 public devTokens;
807     uint256 public liquidityBuyFee = 2; 
808     uint256 public devBuyFee = 18; 
809     uint256 public devSellFee = 40; 
810     uint256 public burnSellFee = 0;
811     uint256 public maxBuyTransactionAmount = 210000 * (10**18);
812     uint256 public maxSellTransactionAmount = 210000 * (10**18);
813     uint256 public swapTokensAtAmount = 3000 * (10**18);
814     uint256 public maxWalletToken = 210000 * (10**18);
815 
816     address payable public devWallet = payable(0xadFFf160f7622b86563e98A7A3c09aAF338FEF19);
817     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
818 
819     bool private inSwapAndLiquify;
820     bool public swapAndLiquifyEnabled = true;
821   
822     // exlcude from fees
823     mapping (address => bool) private _isExcludedFromFees;
824     
825     event SwapAndLiquifyEnabledUpdated(bool enabled);
826     event SwapEthForTokens(uint256 amountIn, address[] path);
827     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
828     event ExcludeFromFees(address indexed account, bool isExcluded);
829     event MaxWalletAmountUpdated(uint256 prevValue, uint256 newValue);
830 
831     event SwapAndLiquify(
832         uint256 tokensSwapped,
833         uint256 ethReceived,
834         uint256 tokensIntoLiqudity
835     );
836 
837     modifier lockTheSwap {
838         inSwapAndLiquify = true;
839         _;
840         inSwapAndLiquify = false;
841     }
842 
843     constructor() ERC20("Xlabs", "Xlabs") {
844     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
845          // Create a uniswap pair for this new token
846         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
847             .createPair(address(this), _uniswapV2Router.WETH());
848 
849         uniswapV2Router = _uniswapV2Router;
850         uniswapV2Pair = _uniswapV2Pair;
851 
852 
853         // exclude from paying fees or having max transaction amount
854         excludeFromFees(owner(), true);
855         excludeFromFees(address(this), true);
856         excludeFromFees(devWallet, true);
857         
858         /*
859             internal function  that is only called here,
860             and CANNOT be called ever again
861         */
862         _createTotalSupply(owner(), 21000000 * (10**18));
863     }
864 
865     function _transfer(
866         address from,
867         address to,
868         uint256 amount
869     ) internal override {
870         require(from != address(0), "ERC20: transfer from the zero address");
871         require(to != address(0), "ERC20: transfer to the zero address");
872        
873         if(amount == 0) {
874             super._transfer(from, to, 0);
875             return;
876         }
877 
878         if (from==uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
879             uint256 contractBalanceRecepient = balanceOf(to);
880             require(contractBalanceRecepient + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
881         }
882 
883         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && from==uniswapV2Pair){
884             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
885         }
886 
887         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && to==uniswapV2Pair){
888             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
889         }
890     
891         if(!inSwapAndLiquify && to==uniswapV2Pair && 
892             swapAndLiquifyEnabled && 
893             (devTokens >= swapTokensAtAmount ||
894             liquidityTokens >= swapTokensAtAmount))
895         {
896             swapAndLiquify();
897         }
898              
899 
900         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
901             uint256 devShare;
902             uint256 liquidityShare;
903             uint256 burnShare;
904             
905             if(from==uniswapV2Pair) {
906                 
907                 if(devBuyFee > 0) {
908                     devShare = amount.mul(devBuyFee).div(100);
909                     devTokens += devShare;
910                     super._transfer(from, address(this), devShare);
911                 }
912 
913                 if(liquidityBuyFee > 0) {
914                     liquidityShare = amount.mul(liquidityBuyFee).div(100);
915                     liquidityTokens += liquidityShare;
916                     super._transfer(from, address(this), liquidityShare);
917                 }
918 
919             }
920 
921             if(to==uniswapV2Pair) {
922                
923                 if(devSellFee > 0) {
924                     devShare = amount.mul(devSellFee).div(100);
925                     devTokens += devShare;
926                     super._transfer(from, address(this), devShare);
927                 }
928 
929                 if(burnSellFee > 0) {
930                     burnShare = amount.mul(burnSellFee).div(100);
931                     super._transfer(from, deadWallet, burnShare);
932                 }
933 
934             }
935 
936             amount = amount.sub(devShare.add(liquidityShare).add(burnShare));
937 
938         }
939 
940         super._transfer(from, to, amount);
941 
942     }
943 
944     function swapAndLiquify() private lockTheSwap {
945         uint256 contractTokenBalance = balanceOf(address(this));
946         if(liquidityTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
947             // split the contract balance into halves
948             uint256 half = swapTokensAtAmount.div(2);
949             uint256 otherHalf = swapTokensAtAmount.sub(half);
950 
951             // capture the contract's current ETH balance.
952             uint256 initialBalance = address(this).balance;
953 
954             // swap tokens for ETH
955             swapTokensForEth(half, address(this));
956 
957             // how much ETH did we just swap into?
958             uint256 newBalance = address(this).balance.sub(initialBalance);
959 
960             // add liquidity to uniswap
961             addLiquidity(otherHalf, newBalance);
962             emit SwapAndLiquify(half, newBalance, otherHalf);
963             liquidityTokens -= swapTokensAtAmount;
964         }
965 
966         if(devTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
967             swapTokensForEth(swapTokensAtAmount, devWallet);
968             devTokens -= swapTokensAtAmount;
969         }
970 
971     }
972 
973     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974         // approve token transfer to cover all possible scenarios
975         _approve(address(this), address(uniswapV2Router), tokenAmount);
976 
977         // add the liquidity
978         uniswapV2Router.addLiquidityETH{value: ethAmount}(
979             address(this),
980             tokenAmount,
981             0, // slippage is unavoidable
982             0, // slippage is unavoidable
983             owner(),
984             block.timestamp
985         );
986     }
987 
988     function swapTokensForEth(uint256 tokenAmount, address _to) private {
989         // generate the uniswap pair path of token -> weth
990         address[] memory path = new address[](2);
991         path[0] = address(this);
992         path[1] = uniswapV2Router.WETH();
993 
994         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
995           _approve(address(this), address(uniswapV2Router), ~uint256(0));
996         }
997 
998         // make the swap
999         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1000             tokenAmount,
1001             0, // accept any amount of ETH
1002             path,
1003             _to,
1004             block.timestamp
1005         );
1006         
1007     }
1008 
1009     function removeBuyFee(uint256 _liqFee, uint256 _devFee) public onlyOwner() {
1010         require(_liqFee.add(_devFee) <= 5, "tax too high");
1011         liquidityBuyFee = _liqFee;
1012         devBuyFee = _devFee;
1013     }
1014 
1015     function removeSellFee(uint256 _devFee, uint256 _burnFee) public onlyOwner() {
1016         require(_devFee.add(_burnFee) <= 5, "tax too high");
1017         devSellFee = _devFee;
1018         burnSellFee = _burnFee;
1019     }
1020 
1021     function updateDevWallet(address payable _devWallet) public onlyOwner {  
1022         devWallet = _devWallet;
1023     }
1024 
1025     function setMaxBuyTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1026         maxBuyTransactionAmount = _maxTxAmount;
1027         require(maxBuyTransactionAmount >= totalSupply().div(500), "value too low");
1028     }
1029 
1030     function setMaxSellTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1031         maxSellTransactionAmount = _maxTxAmount;
1032         require(maxSellTransactionAmount >= totalSupply().div(500), "value too low");
1033     }
1034     
1035     function excludeFromFees(address account, bool excluded) public onlyOwner {
1036         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
1037         _isExcludedFromFees[account] = excluded;
1038 
1039         emit ExcludeFromFees(account, excluded);
1040     }
1041 
1042     function SetSwapTokensAtAmount(uint256 newLimit) external onlyOwner {
1043         swapTokensAtAmount = newLimit;
1044     }
1045     
1046     function isExcludedFromFees(address account) public view returns(bool) {
1047         return _isExcludedFromFees[account];
1048     }
1049     
1050     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1051         swapAndLiquifyEnabled = _enabled;
1052         emit SwapAndLiquifyEnabledUpdated(_enabled);
1053     }
1054 
1055     function setMaxWalletToken(uint256 _newValue) external onlyOwner {
1056         uint256 prevValue = maxWalletToken;
1057   	    maxWalletToken = _newValue;
1058         require(maxWalletToken >= totalSupply().div(500), "value too low");
1059         emit MaxWalletAmountUpdated(prevValue, _newValue);
1060   	}
1061 
1062     receive() external payable {
1063 
1064   	}
1065     
1066 }