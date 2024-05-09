1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.17;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @dev Interface for the optional metadata functions from the ERC20 standard.
27  *
28  * _Available since v4.1._
29  */
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function decimals() external view returns (uint8);
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _setOwner(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _setOwner(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 
104 /**
105  * @dev Implementation of the {IERC20} interface.
106  */
107 contract ERC20 is Context, IERC20, IERC20Metadata {
108     mapping(address => uint256) private _balances;
109 
110     mapping(address => mapping(address => uint256)) private _allowances;
111 
112     uint256 private _totalSupply;
113 
114     string private _name;
115     string private _symbol;
116 
117     /**
118      * @dev Sets the values for {name} and {symbol}.
119      *
120      */
121     constructor(string memory name_, string memory symbol_) {
122         _name = name_;
123         _symbol = symbol_;
124     }
125 
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     /**
134      * @dev Returns the symbol of the token, usually a shorter version of the
135      * name.
136      */
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     /**
142      * @dev Returns the number of decimals used to get its user representation.
143      */
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     /**
149      * @dev See {IERC20-totalSupply}.
150      */
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     /**
156      * @dev See {IERC20-balanceOf}.
157      */
158     function balanceOf(address account) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     /**
163      * @dev See {IERC20-transfer}.
164      *
165      */
166     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     /**
172      * @dev See {IERC20-allowance}.
173      */
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     /**
179      * @dev See {IERC20-approve}.
180      */
181     function approve(address spender, uint256 amount) public virtual override returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     /**
187      * @dev See {IERC20-transferFrom}.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) public virtual override returns (bool) {
194         _transfer(sender, recipient, amount);
195 
196         uint256 currentAllowance = _allowances[sender][_msgSender()];
197         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
198         unchecked {
199             _approve(sender, _msgSender(), currentAllowance - amount);
200         }
201 
202         return true;
203     }
204 
205     /**
206      * @dev Atomically increases the allowance granted to `spender` by the caller.
207      *
208      */
209     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
210         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
211         return true;
212     }
213 
214     /**
215      * @dev Atomically decreases the allowance granted to `spender` by the caller.
216      *
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
219         uint256 currentAllowance = _allowances[_msgSender()][spender];
220         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
221         unchecked {
222             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
223         }
224 
225         return true;
226     }
227 
228     /**
229      * @dev Moves `amount` of tokens from `sender` to `recipient`.
230      *
231      */
232     function _transfer(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) internal virtual {
237         require(sender != address(0), "ERC20: transfer from the zero address");
238         require(recipient != address(0), "ERC20: transfer to the zero address");
239 
240         _beforeTokenTransfer(sender, recipient, amount);
241 
242         uint256 senderBalance = _balances[sender];
243         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
244         unchecked {
245             _balances[sender] = senderBalance - amount;
246         }
247         _balances[recipient] += amount;
248 
249         emit Transfer(sender, recipient, amount);
250 
251         _afterTokenTransfer(sender, recipient, amount);
252     }
253 
254     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
255      * the total supply.
256      */
257     function _createTotalSupply(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: mint to the zero address");
259 
260         _beforeTokenTransfer(address(0), account, amount);
261 
262         _totalSupply += amount;
263         _balances[account] += amount;
264         emit Transfer(address(0), account, amount);
265 
266         _afterTokenTransfer(address(0), account, amount);
267     }
268 
269    
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
272      *
273      */
274     function _approve(
275         address owner,
276         address spender,
277         uint256 amount
278     ) internal virtual {
279         require(owner != address(0), "ERC20: approve from the zero address");
280         require(spender != address(0), "ERC20: approve to the zero address");
281 
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     /**
287      * @dev Hook that is called before any transfer of tokens. This includes
288      * minting and burning.
289      */
290     function _beforeTokenTransfer(
291         address from,
292         address to,
293         uint256 amount
294     ) internal virtual {}
295 
296     /**
297      * @dev Hook that is called after any transfer of tokens. This includes
298      * minting and burning.
299      */
300     function _afterTokenTransfer(
301         address from,
302         address to,
303         uint256 amount
304     ) internal virtual {}
305 }
306 
307 
308 interface IUniswapV2Router01 {
309     function factory() external pure returns (address);
310     function WETH() external pure returns (address);
311 
312     function addLiquidity(
313         address tokenA,
314         address tokenB,
315         uint amountADesired,
316         uint amountBDesired,
317         uint amountAMin,
318         uint amountBMin,
319         address to,
320         uint deadline
321     ) external returns (uint amountA, uint amountB, uint liquidity);
322     function addLiquidityETH(
323         address token,
324         uint amountTokenDesired,
325         uint amountTokenMin,
326         uint amountETHMin,
327         address to,
328         uint deadline
329     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
330     function removeLiquidity(
331         address tokenA,
332         address tokenB,
333         uint liquidity,
334         uint amountAMin,
335         uint amountBMin,
336         address to,
337         uint deadline
338     ) external returns (uint amountA, uint amountB);
339     function removeLiquidityETH(
340         address token,
341         uint liquidity,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline
346     ) external returns (uint amountToken, uint amountETH);
347     function removeLiquidityWithPermit(
348         address tokenA,
349         address tokenB,
350         uint liquidity,
351         uint amountAMin,
352         uint amountBMin,
353         address to,
354         uint deadline,
355         bool approveMax, uint8 v, bytes32 r, bytes32 s
356     ) external returns (uint amountA, uint amountB);
357     function removeLiquidityETHWithPermit(
358         address token,
359         uint liquidity,
360         uint amountTokenMin,
361         uint amountETHMin,
362         address to,
363         uint deadline,
364         bool approveMax, uint8 v, bytes32 r, bytes32 s
365     ) external returns (uint amountToken, uint amountETH);
366     function swapExactTokensForTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external returns (uint[] memory amounts);
373     function swapTokensForExactTokens(
374         uint amountOut,
375         uint amountInMax,
376         address[] calldata path,
377         address to,
378         uint deadline
379     ) external returns (uint[] memory amounts);
380     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
381         external
382         payable
383         returns (uint[] memory amounts);
384     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
385         external
386         returns (uint[] memory amounts);
387     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
388         external
389         returns (uint[] memory amounts);
390     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
391         external
392         payable
393         returns (uint[] memory amounts);
394 
395     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
396     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
397     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
398     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
399     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
400 }
401 
402 interface IUniswapV2Router02 is IUniswapV2Router01 {
403     function removeLiquidityETHSupportingFeeOnTransferTokens(
404         address token,
405         uint liquidity,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external returns (uint amountETH);
411     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline,
418         bool approveMax, uint8 v, bytes32 r, bytes32 s
419     ) external returns (uint amountETH);
420 
421     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
422         uint amountIn,
423         uint amountOutMin,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external;
428     function swapExactETHForTokensSupportingFeeOnTransferTokens(
429         uint amountOutMin,
430         address[] calldata path,
431         address to,
432         uint deadline
433     ) external payable;
434     function swapExactTokensForETHSupportingFeeOnTransferTokens(
435         uint amountIn,
436         uint amountOutMin,
437         address[] calldata path,
438         address to,
439         uint deadline
440     ) external;
441 }
442 
443 interface IUniswapV2Factory {
444     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
445 
446     function feeTo() external view returns (address);
447     function feeToSetter() external view returns (address);
448 
449     function getPair(address tokenA, address tokenB) external view returns (address pair);
450     function allPairs(uint) external view returns (address pair);
451     function allPairsLength() external view returns (uint);
452 
453     function createPair(address tokenA, address tokenB) external returns (address pair);
454 
455     function setFeeTo(address) external;
456     function setFeeToSetter(address) external;
457 }
458 
459 /**
460  * @dev Wrappers over Solidity's arithmetic operations.
461  */
462 library SignedSafeMath {
463     /**
464      * @dev Returns the multiplication of two signed integers, reverting on
465      * overflow.
466      */
467     function mul(int256 a, int256 b) internal pure returns (int256) {
468         return a * b;
469     }
470 
471     /**
472      * @dev Returns the integer division of two signed integers. Reverts on
473      * division by zero. The result is rounded towards zero.
474      */
475     function div(int256 a, int256 b) internal pure returns (int256) {
476         return a / b;
477     }
478 
479     /**
480      * @dev Returns the subtraction of two signed integers, reverting on
481      * overflow.
482      */
483     function sub(int256 a, int256 b) internal pure returns (int256) {
484         return a - b;
485     }
486 
487     /**
488      * @dev Returns the addition of two signed integers, reverting on
489      * overflow.
490      */
491     function add(int256 a, int256 b) internal pure returns (int256) {
492         return a + b;
493     }
494 }
495 
496 // CAUTION
497 // This version of SafeMath should only be used with Solidity 0.8 or later,
498 // because it relies on the compiler's built in overflow checks.
499  
500 library SafeMath {
501     /**
502      * @dev Returns the addition of two unsigned integers, with an overflow flag.
503      *
504      * _Available since v3.4._
505      */
506     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
507         unchecked {
508             uint256 c = a + b;
509             if (c < a) return (false, 0);
510             return (true, c);
511         }
512     }
513 
514     /**
515      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
516      *
517      * _Available since v3.4._
518      */
519     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
520         unchecked {
521             if (b > a) return (false, 0);
522             return (true, a - b);
523         }
524     }
525 
526     /**
527      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
528      *
529      * _Available since v3.4._
530      */
531     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
532         unchecked {
533             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
534             // benefit is lost if 'b' is also tested.
535             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
536             if (a == 0) return (true, 0);
537             uint256 c = a * b;
538             if (c / a != b) return (false, 0);
539             return (true, c);
540         }
541     }
542 
543     /**
544      * @dev Returns the division of two unsigned integers, with a division by zero flag.
545      *
546      * _Available since v3.4._
547      */
548     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
549         unchecked {
550             if (b == 0) return (false, 0);
551             return (true, a / b);
552         }
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
557      *
558      * _Available since v3.4._
559      */
560     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
561         unchecked {
562             if (b == 0) return (false, 0);
563             return (true, a % b);
564         }
565     }
566 
567     /**
568      * @dev Returns the addition of two unsigned integers, reverting on
569      * overflow.
570      */
571     function add(uint256 a, uint256 b) internal pure returns (uint256) {
572         return a + b;
573     }
574 
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting on
577      * overflow (when the result is negative).
578      */
579     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a - b;
581     }
582 
583     /**
584      * @dev Returns the multiplication of two unsigned integers, reverting on
585      * overflow.
586      */
587     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
588         return a * b;
589     }
590 
591     /**
592      * @dev Returns the integer division of two unsigned integers, reverting on
593      * division by zero. The result is rounded towards zero.
594      */
595     function div(uint256 a, uint256 b) internal pure returns (uint256) {
596         return a / b;
597     }
598 
599     /**
600      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
601      * reverting when dividing by zero.
602      */
603     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
604         return a % b;
605     }
606 
607     /**
608      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
609      * overflow (when the result is negative).
610      */
611     function sub(
612         uint256 a,
613         uint256 b,
614         string memory errorMessage
615     ) internal pure returns (uint256) {
616         unchecked {
617             require(b <= a, errorMessage);
618             return a - b;
619         }
620     }
621 
622     /**
623      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
624      * division by zero. The result is rounded towards zero.
625      */
626     function div(
627         uint256 a,
628         uint256 b,
629         string memory errorMessage
630     ) internal pure returns (uint256) {
631         unchecked {
632             require(b > 0, errorMessage);
633             return a / b;
634         }
635     }
636 
637     /**
638      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
639      * reverting with custom message when dividing by zero.
640      */
641     function mod(
642         uint256 a,
643         uint256 b,
644         string memory errorMessage
645     ) internal pure returns (uint256) {
646         unchecked {
647             require(b > 0, errorMessage);
648             return a % b;
649         }
650     }
651 }
652 
653 /**
654  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
655  * checks.
656  */
657 library SafeCast {
658     /**
659      * @dev Returns the downcasted uint224 from uint256, reverting on
660      * overflow (when the input is greater than largest uint224).
661      */
662     function toUint224(uint256 value) internal pure returns (uint224) {
663         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
664         return uint224(value);
665     }
666 
667     /**
668      * @dev Returns the downcasted uint128 from uint256, reverting on
669      * overflow (when the input is greater than largest uint128).
670      */
671     function toUint128(uint256 value) internal pure returns (uint128) {
672         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
673         return uint128(value);
674     }
675 
676     /**
677      * @dev Returns the downcasted uint96 from uint256, reverting on
678      * overflow (when the input is greater than largest uint96).
679      */
680     function toUint96(uint256 value) internal pure returns (uint96) {
681         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
682         return uint96(value);
683     }
684 
685     /**
686      * @dev Returns the downcasted uint64 from uint256, reverting on
687      * overflow (when the input is greater than largest uint64).
688      */
689     function toUint64(uint256 value) internal pure returns (uint64) {
690         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
691         return uint64(value);
692     }
693 
694     /**
695      * @dev Returns the downcasted uint32 from uint256, reverting on
696      * overflow (when the input is greater than largest uint32).
697      */
698     function toUint32(uint256 value) internal pure returns (uint32) {
699         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
700         return uint32(value);
701     }
702 
703     /**
704      * @dev Returns the downcasted uint16 from uint256, reverting on
705      * overflow (when the input is greater than largest uint16).
706      */
707     function toUint16(uint256 value) internal pure returns (uint16) {
708         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
709         return uint16(value);
710     }
711 
712     /**
713      * @dev Returns the downcasted uint8 from uint256, reverting on
714      * overflow (when the input is greater than largest uint8).
715      */
716     function toUint8(uint256 value) internal pure returns (uint8) {
717         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
718         return uint8(value);
719     }
720 
721     /**
722      * @dev Converts a signed int256 into an unsigned uint256.
723      *
724      * Requirements:
725      *
726      * - input must be greater than or equal to 0.
727      */
728     function toUint256(int256 value) internal pure returns (uint256) {
729         require(value >= 0, "SafeCast: value must be positive");
730         return uint256(value);
731     }
732 
733     /**
734      * @dev Returns the downcasted int128 from int256, reverting on
735      * overflow (when the input is less than smallest int128 or
736      */
737     function toInt128(int256 value) internal pure returns (int128) {
738         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
739         return int128(value);
740     }
741 
742     /**
743      * @dev Returns the downcasted int64 from int256, reverting on
744      * overflow (when the input is less than smallest int64 or
745      */
746     function toInt64(int256 value) internal pure returns (int64) {
747         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
748         return int64(value);
749     }
750 
751     /**
752      * @dev Returns the downcasted int32 from int256, reverting on
753      * overflow (when the input is less than smallest int32 or
754      */
755     function toInt32(int256 value) internal pure returns (int32) {
756         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
757         return int32(value);
758     }
759 
760     /**
761      * @dev Returns the downcasted int16 from int256, reverting on
762      * overflow (when the input is less than smallest int16 or
763      */
764     function toInt16(int256 value) internal pure returns (int16) {
765         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
766         return int16(value);
767     }
768 
769     /**
770      * @dev Returns the downcasted int8 from int256, reverting on
771      * overflow (when the input is less than smallest int8 or
772      */
773     function toInt8(int256 value) internal pure returns (int8) {
774         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
775         return int8(value);
776     }
777 
778     /**
779      * @dev Converts an unsigned uint256 into a signed int256.
780      */
781     function toInt256(uint256 value) internal pure returns (int256) {
782         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
783         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
784         return int256(value);
785     }
786 }
787 
788 contract BB is ERC20, Ownable {
789 
790     using SafeMath for uint256;
791 
792     IUniswapV2Router02 public uniswapV2Router;
793     address public immutable uniswapV2Pair;
794 
795     uint256 public liquidityTokens;
796     uint256 public buyBackTokens;
797     uint256 public liquidityBuyFee = 2; 
798     uint256 public devBuyFee = 14; 
799     uint256 public devSellFee = 15; 
800     uint256 public liquiditySellFee = 15;
801     uint256 public devTransferFee = 8; 
802     uint256 public liquidityTransferFee = 8;
803     uint256 public maxBuyTransactionAmount = 220000 * (10**18);
804     uint256 public maxSellTransactionAmount = 220000 * (10**18);
805     uint256 public swapTokensAtAmount = 4000 * (10**18);
806     uint256 public maxWalletToken = 220000 * (10**18);
807 
808     address payable public buybackWallet = payable(0xfebB0033c348ce91C19d7B075134ec7A7e044e1b);
809     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
810 
811     bool private inSwapAndLiquify;
812     bool public swapAndLiquifyEnabled = true;
813     bool public launched = false;
814   
815     // exlcude from fees
816     mapping (address => bool) private _isExcludedFromFees;
817     mapping (address => bool) public _isBlacklisted;
818     
819     event SwapAndLiquifyEnabledUpdated(bool enabled);
820     event SwapEthForTokens(uint256 amountIn, address[] path);
821     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
822     event ExcludeFromFees(address indexed account, bool isExcluded);
823     event MaxWalletAmountUpdated(uint256 prevValue, uint256 newValue);
824 
825     event SwapAndLiquify(
826         uint256 tokensSwapped,
827         uint256 ethReceived,
828         uint256 tokensIntoLiqudity
829     );
830 
831     modifier lockTheSwap {
832         inSwapAndLiquify = true;
833         _;
834         inSwapAndLiquify = false;
835     }
836 
837     constructor() ERC20("BUY BACK", "$BB") {
838     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Ethereum mainnet
839     	
840          // Create a uniswap pair for this new token
841         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
842             .createPair(address(this), _uniswapV2Router.WETH());
843 
844         uniswapV2Router = _uniswapV2Router;
845         uniswapV2Pair = _uniswapV2Pair;
846 
847 
848         // exclude from paying fees or having max transaction amount
849         excludeFromFees(owner(), true);
850         excludeFromFees(address(this), true);
851         excludeFromFees(address(buybackWallet), true);
852         
853         /*
854             internal function  that is only called here,
855             and CANNOT be called ever again
856         */
857         _createTotalSupply(owner(), 22000000 * (10**18));
858     }
859 
860     function setLaunchStatus(bool launched_) public onlyOwner {
861         launched = launched_;
862     }
863 
864     function _transfer(
865         address from,
866         address to,
867         uint256 amount
868     ) internal override {
869         require(from != address(0), "ERC20: transfer from the zero address");
870         require(to != address(0), "ERC20: transfer to the zero address");
871         require(!_isBlacklisted[from] && !_isBlacklisted[to], "To/from address is blacklisted!");
872 
873         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
874             require(launched, "Not Launched.");
875         }
876        
877         if(amount == 0) {
878             super._transfer(from, to, 0);
879             return;
880         }
881 
882         if (from==uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
883             uint256 contractBalanceRecepient = balanceOf(to);
884             require(contractBalanceRecepient + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
885         }
886 
887         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && from==uniswapV2Pair){
888             require(amount <= maxBuyTransactionAmount, "amount exceeds the maxBuyTransactionAmount.");
889         }
890 
891         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to] && to==uniswapV2Pair){
892             require(amount <= maxSellTransactionAmount, "amount exceeds the maxSellTransactionAmount.");
893         }
894     
895         if(!inSwapAndLiquify && to==uniswapV2Pair && 
896             swapAndLiquifyEnabled && 
897             (buyBackTokens >= swapTokensAtAmount ||
898             liquidityTokens >= swapTokensAtAmount))
899         {
900             swapAndLiquify();
901         }
902              
903 
904         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
905             uint256 buyBackShare;
906             uint256 liquidityShare;
907             
908             if(from == uniswapV2Pair) { //BUY
909                 if(devBuyFee > 0) {
910                     buyBackShare = amount.mul(devBuyFee).div(100);
911                     buyBackTokens += buyBackShare;
912                     super._transfer(from, address(this), buyBackShare);
913                 }
914                 if(liquidityBuyFee > 0) {
915                     liquidityShare = amount.mul(liquidityBuyFee).div(100);
916                     liquidityTokens += liquidityShare;
917                     super._transfer(from, address(this), liquidityShare);
918                 }
919             }
920             else if(to == uniswapV2Pair) {//SELL
921                 if(devSellFee > 0) {
922                     buyBackShare = amount.mul(devSellFee).div(100);
923                     buyBackTokens += buyBackShare;
924                     super._transfer(from, address(this), buyBackShare);
925                 }
926                 if(liquiditySellFee > 0) {
927                     liquidityShare = amount.mul(liquiditySellFee).div(100);
928                     liquidityTokens += liquidityShare;
929                     super._transfer(from, address(this), liquidityShare);
930                 }
931             } else { //Transfer
932                 if(devTransferFee > 0) {
933                     buyBackShare = amount.mul(devTransferFee).div(100);
934                     buyBackTokens += buyBackShare;
935                     super._transfer(from, address(this), buyBackShare);
936                 }
937                 if(liquidityTransferFee > 0) {
938                     liquidityShare = amount.mul(liquidityTransferFee).div(100);
939                     liquidityTokens += liquidityShare;
940                     super._transfer(from, address(this), liquidityShare);
941                 }
942             } 
943             amount = amount.sub(buyBackShare.add(liquidityShare));
944         }
945 
946         super._transfer(from, to, amount);
947 
948     }
949 
950     function swapAndLiquify() private lockTheSwap {
951         uint256 contractTokenBalance = balanceOf(address(this));
952         if(liquidityTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
953             // split the contract balance into halves
954             uint256 half = swapTokensAtAmount.div(2);
955             uint256 otherHalf = swapTokensAtAmount.sub(half);
956 
957             // capture the contract's current ETH balance.
958             uint256 initialBalance = address(this).balance;
959 
960             // swap tokens for ETH
961             swapTokensForEth(half, address(this));
962 
963             // how much ETH did we just swap into?
964             uint256 newBalance = address(this).balance.sub(initialBalance);
965 
966             // add liquidity to uniswap
967             addLiquidity(otherHalf, newBalance);
968             emit SwapAndLiquify(half, newBalance, otherHalf);
969             liquidityTokens -= swapTokensAtAmount;
970         }
971 
972         if(buyBackTokens >= swapTokensAtAmount && contractTokenBalance >= swapTokensAtAmount) {
973             swapTokensForEth(swapTokensAtAmount, buybackWallet);
974             buyBackTokens -= swapTokensAtAmount;
975         }
976 
977     }
978 
979     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
980         // approve token transfer to cover all possible scenarios
981         _approve(address(this), address(uniswapV2Router), tokenAmount);
982 
983         // add the liquidity
984         uniswapV2Router.addLiquidityETH{value: ethAmount}(
985             address(this),
986             tokenAmount,
987             0, // slippage is unavoidable
988             0, // slippage is unavoidable
989             owner(),
990             block.timestamp
991         );
992     }
993 
994     function swapTokensForEth(uint256 tokenAmount, address _to) private {
995         // generate the uniswap pair path of token -> weth
996         address[] memory path = new address[](2);
997         path[0] = address(this);
998         path[1] = uniswapV2Router.WETH();
999 
1000         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
1001           _approve(address(this), address(uniswapV2Router), ~uint256(0));
1002         }
1003 
1004         // make the swap
1005         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1006             tokenAmount,
1007             0, // accept any amount of ETH
1008             path,
1009             _to,
1010             block.timestamp
1011         );
1012         
1013     }
1014 
1015     function changeBuyFees(uint256 _liqFee, uint256 _devFee) public onlyOwner() {
1016         require(_liqFee.add(_devFee) <= 49, "tax too high");
1017         liquidityBuyFee = _liqFee;
1018         devBuyFee = _devFee;
1019     }
1020 
1021     function changeSellFees(uint256 _devFee, uint256 _liqFee) public onlyOwner() {
1022         require(_devFee.add(_liqFee) <= 49, "tax too high");
1023         devSellFee = _devFee;
1024         liquiditySellFee = _liqFee;
1025     }
1026 
1027     function changeTransferFees(uint256 _devFee, uint256 _liqFee) public onlyOwner() {
1028         require(_devFee.add(_liqFee) <= 49, "tax too high");
1029         devTransferFee = _devFee;
1030         liquidityTransferFee = _liqFee;
1031     }
1032 
1033     function updateBuyBackWallet(address payable _buybackWallet) public onlyOwner {  
1034         buybackWallet = _buybackWallet;
1035     }
1036 
1037     function setMaxBuyTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1038         maxBuyTransactionAmount = _maxTxAmount;
1039         require(maxBuyTransactionAmount >= totalSupply().div(100), "value too low");
1040     }
1041 
1042     function setMaxSellTransactionAmount(uint256 _maxTxAmount) public onlyOwner {
1043         maxSellTransactionAmount = _maxTxAmount;
1044         require(maxSellTransactionAmount >= totalSupply().div(100), "value too low");
1045     }
1046     
1047     function excludeFromFees(address account, bool excluded) public onlyOwner {
1048         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
1049         _isExcludedFromFees[account] = excluded;
1050 
1051         emit ExcludeFromFees(account, excluded);
1052     }
1053 
1054     function changeBlacklist(address account, bool isBlacklisted_) public onlyOwner {
1055         _isBlacklisted[account] = isBlacklisted_;
1056     }
1057 
1058     function SetSwapTokensAtAmount(uint256 newLimit) external onlyOwner {
1059         swapTokensAtAmount = newLimit;
1060     }
1061     
1062     function isExcludedFromFees(address account) public view returns(bool) {
1063         return _isExcludedFromFees[account];
1064     }
1065     
1066     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1067         swapAndLiquifyEnabled = _enabled;
1068         emit SwapAndLiquifyEnabledUpdated(_enabled);
1069     }
1070 
1071     function setMaxWalletToken(uint256 _newValue) external onlyOwner {
1072         uint256 prevValue = maxWalletToken;
1073   	    maxWalletToken = _newValue;
1074         require(maxWalletToken >= totalSupply().div(100), "value too low");
1075         emit MaxWalletAmountUpdated(prevValue, _newValue);
1076   	}
1077 
1078     receive() external payable {
1079 
1080   	}
1081     
1082 }