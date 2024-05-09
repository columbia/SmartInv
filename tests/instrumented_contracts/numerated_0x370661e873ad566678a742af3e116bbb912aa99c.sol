1 pragma solidity 0.8.17;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13 
14     function transferFrom(
15         address sender,
16         address recipient,
17         uint256 amount
18     ) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 /**
25  * @dev Interface for the optional metadata functions from the ERC20 standard.
26  *
27  * _Available since v4.1._
28  */
29 interface IERC20Metadata is IERC20 {
30     function name() external view returns (string memory);
31     function symbol() external view returns (string memory);
32     function decimals() external view returns (uint8);
33 }
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         return msg.data;
42     }
43 }
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _setOwner(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 /**
104  * @dev Implementation of the {IERC20} interface.
105  */
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     mapping(address => uint256) private _balances;
108 
109     mapping(address => mapping(address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115 
116     /**
117      * @dev Sets the values for {name} and {symbol}.
118      *
119      */
120     constructor(string memory name_, string memory symbol_) {
121         _name = name_;
122         _symbol = symbol_;
123     }
124 
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     /**
133      * @dev Returns the symbol of the token, usually a shorter version of the
134      * name.
135      */
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     /**
141      * @dev Returns the number of decimals used to get its user representation.
142      */
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     /**
148      * @dev See {IERC20-totalSupply}.
149      */
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155      * @dev See {IERC20-balanceOf}.
156      */
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     /**
162      * @dev See {IERC20-transfer}.
163      *
164      */
165     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     /**
171      * @dev See {IERC20-allowance}.
172      */
173     function allowance(address owner, address spender) public view virtual override returns (uint256) {
174         return _allowances[owner][spender];
175     }
176 
177     /**
178      * @dev See {IERC20-approve}.
179      */
180     function approve(address spender, uint256 amount) public virtual override returns (bool) {
181         _approve(_msgSender(), spender, amount);
182         return true;
183     }
184 
185     /**
186      * @dev See {IERC20-transferFrom}.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) public virtual override returns (bool) {
193         _transfer(sender, recipient, amount);
194 
195         uint256 currentAllowance = _allowances[sender][_msgSender()];
196         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
197         unchecked {
198             _approve(sender, _msgSender(), currentAllowance - amount);
199         }
200 
201         return true;
202     }
203 
204     /**
205      * @dev Atomically increases the allowance granted to `spender` by the caller.
206      *
207      */
208     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
209         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
210         return true;
211     }
212 
213     /**
214      * @dev Atomically decreases the allowance granted to `spender` by the caller.
215      *
216      */
217     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
218         uint256 currentAllowance = _allowances[_msgSender()][spender];
219         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
220         unchecked {
221             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
222         }
223 
224         return true;
225     }
226 
227     /**
228      * @dev Moves `amount` of tokens from `sender` to `recipient`.
229      *
230      */
231     function _transfer(
232         address sender,
233         address recipient,
234         uint256 amount
235     ) internal virtual {
236         require(sender != address(0), "ERC20: transfer from the zero address");
237         require(recipient != address(0), "ERC20: transfer to the zero address");
238 
239         _beforeTokenTransfer(sender, recipient, amount);
240 
241         uint256 senderBalance = _balances[sender];
242         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
243         unchecked {
244             _balances[sender] = senderBalance - amount;
245         }
246         _balances[recipient] += amount;
247 
248         emit Transfer(sender, recipient, amount);
249 
250         _afterTokenTransfer(sender, recipient, amount);
251     }
252 
253     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
254      * the total supply.
255      */
256     function _createTotalSupply(address account, uint256 amount) internal virtual {
257         require(account != address(0), "ERC20: mint to the zero address");
258 
259         _beforeTokenTransfer(address(0), account, amount);
260 
261         _totalSupply += amount;
262         _balances[account] += amount;
263         emit Transfer(address(0), account, amount);
264 
265         _afterTokenTransfer(address(0), account, amount);
266     }
267 
268    
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
271      *
272      */
273     function _approve(
274         address owner,
275         address spender,
276         uint256 amount
277     ) internal virtual {
278         require(owner != address(0), "ERC20: approve from the zero address");
279         require(spender != address(0), "ERC20: approve to the zero address");
280 
281         _allowances[owner][spender] = amount;
282         emit Approval(owner, spender, amount);
283     }
284 
285     /**
286      * @dev Hook that is called before any transfer of tokens. This includes
287      * minting and burning.
288      */
289     function _beforeTokenTransfer(
290         address from,
291         address to,
292         uint256 amount
293     ) internal virtual {}
294 
295     /**
296      * @dev Hook that is called after any transfer of tokens. This includes
297      * minting and burning.
298      */
299     function _afterTokenTransfer(
300         address from,
301         address to,
302         uint256 amount
303     ) internal virtual {}
304 }
305 
306 
307 interface IUniswapV2Router01 {
308     function factory() external pure returns (address);
309     function WETH() external pure returns (address);
310 
311     function addLiquidity(
312         address tokenA,
313         address tokenB,
314         uint amountADesired,
315         uint amountBDesired,
316         uint amountAMin,
317         uint amountBMin,
318         address to,
319         uint deadline
320     ) external returns (uint amountA, uint amountB, uint liquidity);
321     function addLiquidityETH(
322         address token,
323         uint amountTokenDesired,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline
328     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
329     function removeLiquidity(
330         address tokenA,
331         address tokenB,
332         uint liquidity,
333         uint amountAMin,
334         uint amountBMin,
335         address to,
336         uint deadline
337     ) external returns (uint amountA, uint amountB);
338     function removeLiquidityETH(
339         address token,
340         uint liquidity,
341         uint amountTokenMin,
342         uint amountETHMin,
343         address to,
344         uint deadline
345     ) external returns (uint amountToken, uint amountETH);
346     function removeLiquidityWithPermit(
347         address tokenA,
348         address tokenB,
349         uint liquidity,
350         uint amountAMin,
351         uint amountBMin,
352         address to,
353         uint deadline,
354         bool approveMax, uint8 v, bytes32 r, bytes32 s
355     ) external returns (uint amountA, uint amountB);
356     function removeLiquidityETHWithPermit(
357         address token,
358         uint liquidity,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline,
363         bool approveMax, uint8 v, bytes32 r, bytes32 s
364     ) external returns (uint amountToken, uint amountETH);
365     function swapExactTokensForTokens(
366         uint amountIn,
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external returns (uint[] memory amounts);
372     function swapTokensForExactTokens(
373         uint amountOut,
374         uint amountInMax,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external returns (uint[] memory amounts);
379     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
380         external
381         payable
382         returns (uint[] memory amounts);
383     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
384         external
385         returns (uint[] memory amounts);
386     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
387         external
388         returns (uint[] memory amounts);
389     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
390         external
391         payable
392         returns (uint[] memory amounts);
393 
394     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
395     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
396     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
397     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
398     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
399 }
400 
401 interface IUniswapV2Router02 is IUniswapV2Router01 {
402     function removeLiquidityETHSupportingFeeOnTransferTokens(
403         address token,
404         uint liquidity,
405         uint amountTokenMin,
406         uint amountETHMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountETH);
410     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
411         address token,
412         uint liquidity,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline,
417         bool approveMax, uint8 v, bytes32 r, bytes32 s
418     ) external returns (uint amountETH);
419 
420     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
421         uint amountIn,
422         uint amountOutMin,
423         address[] calldata path,
424         address to,
425         uint deadline
426     ) external;
427     function swapExactETHForTokensSupportingFeeOnTransferTokens(
428         uint amountOutMin,
429         address[] calldata path,
430         address to,
431         uint deadline
432     ) external payable;
433     function swapExactTokensForETHSupportingFeeOnTransferTokens(
434         uint amountIn,
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external;
440 }
441 
442 interface IUniswapV2Factory {
443     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
444 
445     function feeTo() external view returns (address);
446     function feeToSetter() external view returns (address);
447 
448     function getPair(address tokenA, address tokenB) external view returns (address pair);
449     function allPairs(uint) external view returns (address pair);
450     function allPairsLength() external view returns (uint);
451 
452     function createPair(address tokenA, address tokenB) external returns (address pair);
453 
454     function setFeeTo(address) external;
455     function setFeeToSetter(address) external;
456 }
457 
458 /**
459  * @dev Wrappers over Solidity's arithmetic operations.
460  */
461 library SignedSafeMath {
462     /**
463      * @dev Returns the multiplication of two signed integers, reverting on
464      * overflow.
465      */
466     function mul(int256 a, int256 b) internal pure returns (int256) {
467         return a * b;
468     }
469 
470     /**
471      * @dev Returns the integer division of two signed integers. Reverts on
472      * division by zero. The result is rounded towards zero.
473      */
474     function div(int256 a, int256 b) internal pure returns (int256) {
475         return a / b;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two signed integers, reverting on
480      * overflow.
481      */
482     function sub(int256 a, int256 b) internal pure returns (int256) {
483         return a - b;
484     }
485 
486     /**
487      * @dev Returns the addition of two signed integers, reverting on
488      * overflow.
489      */
490     function add(int256 a, int256 b) internal pure returns (int256) {
491         return a + b;
492     }
493 }
494 
495 // CAUTION
496 // This version of SafeMath should only be used with Solidity 0.8 or later,
497 // because it relies on the compiler's built in overflow checks.
498  
499 library SafeMath {
500     /**
501      * @dev Returns the addition of two unsigned integers, with an overflow flag.
502      *
503      * _Available since v3.4._
504      */
505     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
506         unchecked {
507             uint256 c = a + b;
508             if (c < a) return (false, 0);
509             return (true, c);
510         }
511     }
512 
513     /**
514      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
515      *
516      * _Available since v3.4._
517      */
518     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
519         unchecked {
520             if (b > a) return (false, 0);
521             return (true, a - b);
522         }
523     }
524 
525     /**
526      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
527      *
528      * _Available since v3.4._
529      */
530     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
531         unchecked {
532             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
533             // benefit is lost if 'b' is also tested.
534             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
535             if (a == 0) return (true, 0);
536             uint256 c = a * b;
537             if (c / a != b) return (false, 0);
538             return (true, c);
539         }
540     }
541 
542     /**
543      * @dev Returns the division of two unsigned integers, with a division by zero flag.
544      *
545      * _Available since v3.4._
546      */
547     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
548         unchecked {
549             if (b == 0) return (false, 0);
550             return (true, a / b);
551         }
552     }
553 
554     /**
555      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
556      *
557      * _Available since v3.4._
558      */
559     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
560         unchecked {
561             if (b == 0) return (false, 0);
562             return (true, a % b);
563         }
564     }
565 
566     /**
567      * @dev Returns the addition of two unsigned integers, reverting on
568      * overflow.
569      */
570     function add(uint256 a, uint256 b) internal pure returns (uint256) {
571         return a + b;
572     }
573 
574     /**
575      * @dev Returns the subtraction of two unsigned integers, reverting on
576      * overflow (when the result is negative).
577      */
578     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
579         return a - b;
580     }
581 
582     /**
583      * @dev Returns the multiplication of two unsigned integers, reverting on
584      * overflow.
585      */
586     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a * b;
588     }
589 
590     /**
591      * @dev Returns the integer division of two unsigned integers, reverting on
592      * division by zero. The result is rounded towards zero.
593      */
594     function div(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a / b;
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
600      * reverting when dividing by zero.
601      */
602     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
603         return a % b;
604     }
605 
606     /**
607      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
608      * overflow (when the result is negative).
609      */
610     function sub(
611         uint256 a,
612         uint256 b,
613         string memory errorMessage
614     ) internal pure returns (uint256) {
615         unchecked {
616             require(b <= a, errorMessage);
617             return a - b;
618         }
619     }
620 
621     /**
622      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
623      * division by zero. The result is rounded towards zero.
624      */
625     function div(
626         uint256 a,
627         uint256 b,
628         string memory errorMessage
629     ) internal pure returns (uint256) {
630         unchecked {
631             require(b > 0, errorMessage);
632             return a / b;
633         }
634     }
635 
636     /**
637      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
638      * reverting with custom message when dividing by zero.
639      */
640     function mod(
641         uint256 a,
642         uint256 b,
643         string memory errorMessage
644     ) internal pure returns (uint256) {
645         unchecked {
646             require(b > 0, errorMessage);
647             return a % b;
648         }
649     }
650 }
651 
652 /**
653  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
654  * checks.
655  */
656 library SafeCast {
657     /**
658      * @dev Returns the downcasted uint224 from uint256, reverting on
659      * overflow (when the input is greater than largest uint224).
660      */
661     function toUint224(uint256 value) internal pure returns (uint224) {
662         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
663         return uint224(value);
664     }
665 
666     /**
667      * @dev Returns the downcasted uint128 from uint256, reverting on
668      * overflow (when the input is greater than largest uint128).
669      */
670     function toUint128(uint256 value) internal pure returns (uint128) {
671         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
672         return uint128(value);
673     }
674 
675     /**
676      * @dev Returns the downcasted uint96 from uint256, reverting on
677      * overflow (when the input is greater than largest uint96).
678      */
679     function toUint96(uint256 value) internal pure returns (uint96) {
680         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
681         return uint96(value);
682     }
683 
684     /**
685      * @dev Returns the downcasted uint64 from uint256, reverting on
686      * overflow (when the input is greater than largest uint64).
687      */
688     function toUint64(uint256 value) internal pure returns (uint64) {
689         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
690         return uint64(value);
691     }
692 
693     /**
694      * @dev Returns the downcasted uint32 from uint256, reverting on
695      * overflow (when the input is greater than largest uint32).
696      */
697     function toUint32(uint256 value) internal pure returns (uint32) {
698         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
699         return uint32(value);
700     }
701 
702     /**
703      * @dev Returns the downcasted uint16 from uint256, reverting on
704      * overflow (when the input is greater than largest uint16).
705      */
706     function toUint16(uint256 value) internal pure returns (uint16) {
707         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
708         return uint16(value);
709     }
710 
711     /**
712      * @dev Returns the downcasted uint8 from uint256, reverting on
713      * overflow (when the input is greater than largest uint8).
714      */
715     function toUint8(uint256 value) internal pure returns (uint8) {
716         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
717         return uint8(value);
718     }
719 
720     /**
721      * @dev Converts a signed int256 into an unsigned uint256.
722      *
723      * Requirements:
724      *
725      * - input must be greater than or equal to 0.
726      */
727     function toUint256(int256 value) internal pure returns (uint256) {
728         require(value >= 0, "SafeCast: value must be positive");
729         return uint256(value);
730     }
731 
732     /**
733      * @dev Returns the downcasted int128 from int256, reverting on
734      * overflow (when the input is less than smallest int128 or
735      */
736     function toInt128(int256 value) internal pure returns (int128) {
737         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
738         return int128(value);
739     }
740 
741     /**
742      * @dev Returns the downcasted int64 from int256, reverting on
743      * overflow (when the input is less than smallest int64 or
744      */
745     function toInt64(int256 value) internal pure returns (int64) {
746         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
747         return int64(value);
748     }
749 
750     /**
751      * @dev Returns the downcasted int32 from int256, reverting on
752      * overflow (when the input is less than smallest int32 or
753      */
754     function toInt32(int256 value) internal pure returns (int32) {
755         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
756         return int32(value);
757     }
758 
759     /**
760      * @dev Returns the downcasted int16 from int256, reverting on
761      * overflow (when the input is less than smallest int16 or
762      */
763     function toInt16(int256 value) internal pure returns (int16) {
764         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
765         return int16(value);
766     }
767 
768     /**
769      * @dev Returns the downcasted int8 from int256, reverting on
770      * overflow (when the input is less than smallest int8 or
771      */
772     function toInt8(int256 value) internal pure returns (int8) {
773         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
774         return int8(value);
775     }
776 
777     /**
778      * @dev Converts an unsigned uint256 into a signed int256.
779      */
780     function toInt256(uint256 value) internal pure returns (int256) {
781         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
782         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
783         return int256(value);
784     }
785 }
786 
787 contract LinuxExchange is ERC20, Ownable {
788 
789     using SafeMath for uint256;
790 
791     IUniswapV2Router02 public uniswapV2Router;
792     address public immutable uniswapV2Pair;
793 
794     uint256 public liquidityTokens;
795     uint256 public devTokens;
796     uint256 public liquidityBuyFee = 1; 
797     uint256 public devBuyFee = 6; 
798     uint256 public devSellFee = 6; 
799     uint256 public burnSellFee = 1;
800     uint256 public maxBuyTransactionAmount = 2000000 * (10**18);
801     uint256 public maxSellTransactionAmount = 2000000 * (10**18);
802     uint256 public swapTokensAtAmount = 2000000 * (10**18);
803     uint256 public maxWalletToken = 2000000 * (10**18);
804 
805     address payable public devWallet = payable(0xD290DaeCdAcB20fC36124770dBd6647ca84593FD);
806     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
807 
808     bool private inSwapAndLiquify;
809     bool public swapAndLiquifyEnabled = true;
810   
811     // exlcude from fees
812     mapping (address => bool) private _isExcludedFromFees;
813     
814     event SwapAndLiquifyEnabledUpdated(bool enabled);
815     event SwapEthForTokens(uint256 amountIn, address[] path);
816     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
817     event ExcludeFromFees(address indexed account, bool isExcluded);
818     event MaxWalletAmountUpdated(uint256 prevValue, uint256 newValue);
819 
820     event SwapAndLiquify(
821         uint256 tokensSwapped,
822         uint256 ethReceived,
823         uint256 tokensIntoLiqudity
824     );
825 
826     modifier lockTheSwap {
827         inSwapAndLiquify = true;
828         _;
829         inSwapAndLiquify = false;
830     }
831 
832     constructor() ERC20("LinuxExchange", "LIX") {
833     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
834          // Create a uniswap pair for this new token
835         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
836             .createPair(address(this), _uniswapV2Router.WETH());
837 
838         uniswapV2Router = _uniswapV2Router;
839         uniswapV2Pair = _uniswapV2Pair;
840 
841 
842         // exclude from paying fees or having max transaction amount
843         excludeFromFees(owner(), true);
844         excludeFromFees(address(this), true);
845         excludeFromFees(devWallet, true);
846         
847         /*
848             internal function  that is only called here,
849             and CANNOT be called ever again
850         */
851         _createTotalSupply(owner(), 100000000 * (10**18));
852     }
853 
854     function _transfer(
855         address from,
856         address to,
857         uint256 amount
858     ) internal override {
859         require(from != address(0), "ERC20: transfer from the zero address");
860         require(to != address(0), "ERC20: transfer to the zero address");
861        
862         if(amount == 0) {
863             super._transfer(from, to, 0);
864             return;
865         }
866 
867         if (from==uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
868             uint256 contractBalanceRecepient = balanceOf(to);
869             require(contractBalanceRecepient + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
870         }
871 
872         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && from==uniswapV2Pair){
873             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
874         }
875 
876         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && to==uniswapV2Pair){
877             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
878         }
879     
880         if(!inSwapAndLiquify && to==uniswapV2Pair && 
881             swapAndLiquifyEnabled && 
882             (devTokens >= swapTokensAtAmount ||
883             liquidityTokens >= swapTokensAtAmount))
884         {
885             swapAndLiquify();
886         }
887              
888 
889         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
890             uint256 devShare;
891             uint256 liquidityShare;
892             uint256 burnShare;
893             
894             if(from==uniswapV2Pair) {
895                 
896                 if(devBuyFee > 0) {
897                     devShare = amount.mul(devBuyFee).div(100);
898                     devTokens += devShare;
899                     super._transfer(from, address(this), devShare);
900                 }
901 
902                 if(liquidityBuyFee > 0) {
903                     liquidityShare = amount.mul(liquidityBuyFee).div(100);
904                     liquidityTokens += liquidityShare;
905                     super._transfer(from, address(this), liquidityShare);
906                 }
907 
908             }
909 
910             if(to==uniswapV2Pair) {
911                
912                 if(devSellFee > 0) {
913                     devShare = amount.mul(devSellFee).div(100);
914                     devTokens += devShare;
915                     super._transfer(from, address(this), devShare);
916                 }
917 
918                 if(burnSellFee > 0) {
919                     burnShare = amount.mul(burnSellFee).div(100);
920                     super._transfer(from, deadWallet, burnShare);
921                 }
922 
923             }
924 
925             amount = amount.sub(devShare.add(liquidityShare).add(burnShare));
926 
927         }
928 
929         super._transfer(from, to, amount);
930 
931     }
932 
933     function swapAndLiquify() private lockTheSwap {
934         uint256 contractTokenBalance = balanceOf(address(this));
935         if(liquidityTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
936             // split the contract balance into halves
937             uint256 half = swapTokensAtAmount.div(2);
938             uint256 otherHalf = swapTokensAtAmount.sub(half);
939 
940             // capture the contract's current ETH balance.
941             uint256 initialBalance = address(this).balance;
942 
943             // swap tokens for ETH
944             swapTokensForEth(half, address(this));
945 
946             // how much ETH did we just swap into?
947             uint256 newBalance = address(this).balance.sub(initialBalance);
948 
949             // add liquidity to uniswap
950             addLiquidity(otherHalf, newBalance);
951             emit SwapAndLiquify(half, newBalance, otherHalf);
952             liquidityTokens -= swapTokensAtAmount;
953         }
954 
955         if(devTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
956             swapTokensForEth(swapTokensAtAmount, devWallet);
957             devTokens -= swapTokensAtAmount;
958         }
959 
960     }
961 
962     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
963         // approve token transfer to cover all possible scenarios
964         _approve(address(this), address(uniswapV2Router), tokenAmount);
965 
966         // add the liquidity
967         uniswapV2Router.addLiquidityETH{value: ethAmount}(
968             address(this),
969             tokenAmount,
970             0, // slippage is unavoidable
971             0, // slippage is unavoidable
972             owner(),
973             block.timestamp
974         );
975     }
976 
977     function swapTokensForEth(uint256 tokenAmount, address _to) private {
978         // generate the uniswap pair path of token -> weth
979         address[] memory path = new address[](2);
980         path[0] = address(this);
981         path[1] = uniswapV2Router.WETH();
982 
983         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
984           _approve(address(this), address(uniswapV2Router), ~uint256(0));
985         }
986 
987         // make the swap
988         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
989             tokenAmount,
990             0, // accept any amount of ETH
991             path,
992             _to,
993             block.timestamp
994         );
995         
996     }
997 
998     function removeBuyFee(uint256 _liqFee, uint256 _devFee) public onlyOwner() {
999         require(_liqFee.add(_devFee) <= 5, "tax too high");
1000         liquidityBuyFee = _liqFee;
1001         devBuyFee = _devFee;
1002     }
1003 
1004     function removeSellFee(uint256 _devFee, uint256 _burnFee) public onlyOwner() {
1005         require(_devFee.add(_burnFee) <= 5, "tax too high");
1006         devSellFee = _devFee;
1007         burnSellFee = _burnFee;
1008     }
1009 
1010     function updateDevWallet(address payable _devWallet) public onlyOwner {  
1011         devWallet = _devWallet;
1012     }
1013 
1014     function setMaxBuyTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1015         maxBuyTransactionAmount = _maxTxAmount;
1016         require(maxBuyTransactionAmount >= totalSupply().div(500), "value too low");
1017     }
1018 
1019     function setMaxSellTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1020         maxSellTransactionAmount = _maxTxAmount;
1021         require(maxSellTransactionAmount >= totalSupply().div(500), "value too low");
1022     }
1023     
1024     function excludeFromFees(address account, bool excluded) public onlyOwner {
1025         require(_isExcludedFromFees[account] != excluded );
1026         _isExcludedFromFees[account] = excluded;
1027 
1028         emit ExcludeFromFees(account, excluded);
1029     }
1030 
1031     function SetSwapTokensAtAmount(uint256 newLimit) external onlyOwner {
1032         swapTokensAtAmount = newLimit;
1033     }
1034     
1035     function isExcludedFromFees(address account) public view returns(bool) {
1036         return _isExcludedFromFees[account];
1037     }
1038     
1039     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1040         swapAndLiquifyEnabled = _enabled;
1041         emit SwapAndLiquifyEnabledUpdated(_enabled);
1042     }
1043 
1044     function setMaxWalletToken(uint256 _newValue) external onlyOwner {
1045         uint256 prevValue = maxWalletToken;
1046   	    maxWalletToken = _newValue;
1047         require(maxWalletToken >= totalSupply().div(500), "value too low");
1048         emit MaxWalletAmountUpdated(prevValue, _newValue);
1049   	}
1050 
1051     receive() external payable {
1052 
1053   	}
1054     
1055 }