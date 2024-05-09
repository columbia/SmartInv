1 /**
2  *$JOTARO Jotarotoken.com
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21 
22     function balanceOf(address owner) external view returns (uint256);
23 
24     function transfer(address to, uint256 value) external returns (bool);
25 
26     function transferFrom(
27         address from,
28         address to,
29         uint256 value
30     ) external returns (bool);
31 
32     function MINIMUM_LIQUIDITY() external pure returns (uint256);
33 
34     function factory() external view returns (address);
35 
36     function token0() external view returns (address);
37 
38     function token1() external view returns (address);
39 
40     function getReserves()
41         external
42         view
43         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
44 
45     function burn(
46         address to
47     ) external returns (uint256 amount0, uint256 amount1);
48 
49     function sync() external;
50 }
51 
52 interface IUniswapV2Factory {
53     event PairCreated(
54         address indexed token0,
55         address indexed token1,
56         address pair,
57         uint256
58     );
59 
60     function feeTo() external view returns (address);
61 
62     function feeToSetter() external view returns (address);
63 
64     function getPair(
65         address tokenA,
66         address tokenB
67     ) external view returns (address pair);
68 
69     function allPairs(uint256) external view returns (address pair);
70 
71     function allPairsLength() external view returns (uint256);
72 
73     function createPair(
74         address tokenA,
75         address tokenB
76     ) external returns (address pair);
77 
78     function setFeeTo(address) external;
79 
80     function setFeeToSetter(address) external;
81 }
82 
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through {transferFrom}. This is
109      * zero by default.
110      *
111      * This value changes when {approve} or {transferFrom} are called.
112      */
113     function allowance(
114         address owner,
115         address spender
116     ) external view returns (uint256);
117 
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(
162         address indexed owner,
163         address indexed spender,
164         uint256 value
165     );
166 }
167 
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184 
185 library SafeMath {
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return sub(a, b, "SafeMath: subtraction overflow");
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(
228         uint256 a,
229         uint256 b,
230         string memory errorMessage
231     ) internal pure returns (uint256) {
232         require(b <= a, errorMessage);
233         uint256 c = a - b;
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `*` operator.
243      *
244      * Requirements:
245      *
246      * - Multiplication cannot overflow.
247      */
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250         // benefit is lost if 'b' is also tested.
251         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
252         if (a == 0) {
253             return 0;
254         }
255 
256         uint256 c = a * b;
257         require(c / a == b, "SafeMath: multiplication overflow");
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         return div(a, b, "SafeMath: division by zero");
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
280      * division by zero. The result is rounded towards zero.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function div(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         require(b > 0, errorMessage);
296         uint256 c = a / b;
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return mod(a, b, "SafeMath: modulo by zero");
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts with custom message when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         require(b != 0, errorMessage);
335         return a % b;
336     }
337 }
338 
339 contract Ownable is Context {
340     address private _owner;
341 
342     event OwnershipTransferred(
343         address indexed previousOwner,
344         address indexed newOwner
345     );
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         address msgSender = _msgSender();
352         _owner = msgSender;
353         emit OwnershipTransferred(address(0), msgSender);
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         require(_owner == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     /**
372      * @dev Leaves the contract without owner. It will not be possible to call
373      * `onlyOwner` functions anymore. Can only be called by the current owner.
374      *
375      * NOTE: Renouncing ownership will leave the contract without an owner,
376      * thereby removing any functionality that is only available to the owner.
377      */
378     function renounceOwnership() public virtual onlyOwner {
379         emit OwnershipTransferred(_owner, address(0));
380         _owner = address(0);
381     }
382 
383     /**
384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
385      * Can only be called by the current owner.
386      */
387     function transferOwnership(address newOwner) public virtual onlyOwner {
388         require(
389             newOwner != address(0),
390             "Ownable: new owner is the zero address"
391         );
392         emit OwnershipTransferred(_owner, newOwner);
393         _owner = newOwner;
394     }
395 }
396 
397 abstract contract ReentrancyGuard {
398     // Booleans are more expensive than uint256 or any type that takes up a full
399     // word because each write operation emits an extra SLOAD to first read the
400     // slot's contents, replace the bits taken up by the boolean, and then write
401     // back. This is the compiler's defense against contract upgrades and
402     // pointer aliasing, and it cannot be disabled.
403 
404     // The values being non-zero value makes deployment a bit more expensive,
405     // but in exchange the refund on every call to nonReentrant will be lower in
406     // amount. Since refunds are capped to a percentage of the total
407     // transaction's gas, it is best to keep them low in cases like this one, to
408     // increase the likelihood of the full refund coming into effect.
409     uint256 private constant _NOT_ENTERED = 1;
410     uint256 private constant _ENTERED = 2;
411 
412     uint256 private _status;
413 
414     constructor() {
415         _status = _NOT_ENTERED;
416     }
417 
418     /**
419      * @dev Prevents a contract from calling itself, directly or indirectly.
420      * Calling a `nonReentrant` function from another `nonReentrant`
421      * function is not supported. It is possible to prevent this from happening
422      * by making the `nonReentrant` function external, and making it call a
423      * `private` function that does the actual work.
424      */
425     modifier nonReentrant() {
426         _nonReentrantBefore();
427         _;
428         _nonReentrantAfter();
429     }
430 
431     function _nonReentrantBefore() private {
432         // On the first call to nonReentrant, _status will be _NOT_ENTERED
433         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
434 
435         // Any calls to nonReentrant after this point will fail
436         _status = _ENTERED;
437     }
438 
439     function _nonReentrantAfter() private {
440         // By storing the original value once again, a refund is triggered (see
441         // https://eips.ethereum.org/EIPS/eip-2200)
442         _status = _NOT_ENTERED;
443     }
444 }
445 
446 interface IUniswapV2Router01 {
447     function factory() external pure returns (address);
448 
449     function WETH() external pure returns (address);
450 
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint256 amountADesired,
455         uint256 amountBDesired,
456         uint256 amountAMin,
457         uint256 amountBMin,
458         address to,
459         uint256 deadline
460     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
461 
462     function addLiquidityETH(
463         address token,
464         uint256 amountTokenDesired,
465         uint256 amountTokenMin,
466         uint256 amountETHMin,
467         address to,
468         uint256 deadline
469     )
470         external
471         payable
472         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
473 
474     function removeLiquidity(
475         address tokenA,
476         address tokenB,
477         uint256 liquidity,
478         uint256 amountAMin,
479         uint256 amountBMin,
480         address to,
481         uint256 deadline
482     ) external returns (uint256 amountA, uint256 amountB);
483 
484     function removeLiquidityETH(
485         address token,
486         uint256 liquidity,
487         uint256 amountTokenMin,
488         uint256 amountETHMin,
489         address to,
490         uint256 deadline
491     ) external returns (uint256 amountToken, uint256 amountETH);
492 
493     function removeLiquidityWithPermit(
494         address tokenA,
495         address tokenB,
496         uint256 liquidity,
497         uint256 amountAMin,
498         uint256 amountBMin,
499         address to,
500         uint256 deadline,
501         bool approveMax,
502         uint8 v,
503         bytes32 r,
504         bytes32 s
505     ) external returns (uint256 amountA, uint256 amountB);
506 
507     function removeLiquidityETHWithPermit(
508         address token,
509         uint256 liquidity,
510         uint256 amountTokenMin,
511         uint256 amountETHMin,
512         address to,
513         uint256 deadline,
514         bool approveMax,
515         uint8 v,
516         bytes32 r,
517         bytes32 s
518     ) external returns (uint256 amountToken, uint256 amountETH);
519 
520     function swapExactTokensForTokens(
521         uint256 amountIn,
522         uint256 amountOutMin,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external returns (uint256[] memory amounts);
527 
528     function swapTokensForExactTokens(
529         uint256 amountOut,
530         uint256 amountInMax,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external returns (uint256[] memory amounts);
535 
536     function swapExactETHForTokens(
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external payable returns (uint256[] memory amounts);
542 
543     function swapTokensForExactETH(
544         uint256 amountOut,
545         uint256 amountInMax,
546         address[] calldata path,
547         address to,
548         uint256 deadline
549     ) external returns (uint256[] memory amounts);
550 
551     function swapExactTokensForETH(
552         uint256 amountIn,
553         uint256 amountOutMin,
554         address[] calldata path,
555         address to,
556         uint256 deadline
557     ) external returns (uint256[] memory amounts);
558 
559     function swapETHForExactTokens(
560         uint256 amountOut,
561         address[] calldata path,
562         address to,
563         uint256 deadline
564     ) external payable returns (uint256[] memory amounts);
565 
566     function quote(
567         uint256 amountA,
568         uint256 reserveA,
569         uint256 reserveB
570     ) external pure returns (uint256 amountB);
571 
572     function getAmountOut(
573         uint256 amountIn,
574         uint256 reserveIn,
575         uint256 reserveOut
576     ) external pure returns (uint256 amountOut);
577 
578     function getAmountIn(
579         uint256 amountOut,
580         uint256 reserveIn,
581         uint256 reserveOut
582     ) external pure returns (uint256 amountIn);
583 
584     function getAmountsOut(
585         uint256 amountIn,
586         address[] calldata path
587     ) external view returns (uint256[] memory amounts);
588 
589     function getAmountsIn(
590         uint256 amountOut,
591         address[] calldata path
592     ) external view returns (uint256[] memory amounts);
593 }
594 
595 interface IUniswapV2Router02 is IUniswapV2Router01 {
596     function removeLiquidityETHSupportingFeeOnTransferTokens(
597         address token,
598         uint256 liquidity,
599         uint256 amountTokenMin,
600         uint256 amountETHMin,
601         address to,
602         uint256 deadline
603     ) external returns (uint256 amountETH);
604 
605     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
606         address token,
607         uint256 liquidity,
608         uint256 amountTokenMin,
609         uint256 amountETHMin,
610         address to,
611         uint256 deadline,
612         bool approveMax,
613         uint8 v,
614         bytes32 r,
615         bytes32 s
616     ) external returns (uint256 amountETH);
617 
618     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
619         uint256 amountIn,
620         uint256 amountOutMin,
621         address[] calldata path,
622         address to,
623         uint256 deadline
624     ) external;
625 
626     function swapExactETHForTokensSupportingFeeOnTransferTokens(
627         uint256 amountOutMin,
628         address[] calldata path,
629         address to,
630         uint256 deadline
631     ) external payable;
632 
633     function swapExactTokensForETHSupportingFeeOnTransferTokens(
634         uint256 amountIn,
635         uint256 amountOutMin,
636         address[] calldata path,
637         address to,
638         uint256 deadline
639     ) external;
640 }
641 
642 contract ERC20 is Context, IERC20, IERC20Metadata {
643     using SafeMath for uint256;
644 
645     uint256 constant MAX = ~uint256(0);
646     uint256 public _rTotal;
647     uint256 public _tTotal;
648     uint256 public _tFeeTotal;
649 
650     uint256 public reflection = 1;
651 
652     address[] public _exclud;
653 
654     mapping(address => uint256) public _rOwned;
655 
656     mapping(address => bool) internal _isExcludedFromFees;
657 
658     mapping(address => uint256) private _balances;
659 
660     mapping(address => mapping(address => uint256)) private _allowances;
661 
662     uint256 private _totalSupply;
663 
664     string private _name;
665     string private _symbol;
666 
667     /**
668      * @dev Sets the values for {name} and {symbol}.
669      *
670      * The default value of {decimals} is 9. To select a different value for
671      * {decimals} you should overload it.
672      *
673      * All two of these values are immutable: they can only be set once during
674      * construction.
675      */
676     constructor(string memory name_, string memory symbol_) {
677         _name = name_;
678         _symbol = symbol_;
679     }
680 
681     /**
682      * @dev Returns the name of the token.
683      */
684     function name() public view virtual override returns (string memory) {
685         return _name;
686     }
687 
688     /**
689      * @dev Returns the symbol of the token, usually a shorter version of the
690      * name.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev Returns the number of decimals used to get its user representation.
698      * For example, if `decimals` equals `2`, a balance of `505` tokens should
699      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
700      *
701      * Tokens usually opt for a value of 18, imitating the relationship between
702      * Ether and Wei. This is the value {ERC20} uses, unless this function is
703      * overridden;
704      *
705      * NOTE: This information is only used for _display_ purposes: it in
706      * no way affects any of the arithmetic of the contract, including
707      * {IERC20-balanceOf} and {IERC20-transfer}.
708      */
709     function decimals() public view virtual override returns (uint8) {
710         return 9;
711     }
712 
713     /**
714      * @dev See {IERC20-totalSupply}.
715      */
716     function totalSupply() public view virtual override returns (uint256) {
717         return _totalSupply;
718     }
719 
720     /**
721      * @dev See {IERC20-balanceOf}.
722      */
723     function balanceOf(
724         address account
725     ) public view virtual override returns (uint256) {
726         if (_isExcludedFromFees[account]) return _balances[account];
727         return tokenFromReflection(_rOwned[account]);
728     }
729 
730     function tokenFromReflection(
731         uint256 rAmount
732     ) public view returns (uint256) {
733         require(
734             rAmount <= _rTotal,
735             "Amount must be less than total reflections"
736         );
737         uint256 currentRate = _getRate();
738         return rAmount.div(currentRate);
739     }
740 
741     function reflect(uint256 tAmount) public {
742         address sender = _msgSender();
743         require(
744             !_isExcludedFromFees[sender],
745             "Excluded addresses cannot call this function"
746         );
747         (uint256 rAmount, , , , ) = _getValues(tAmount);
748         _rOwned[sender] = _rOwned[sender].sub(rAmount);
749         _rTotal = _rTotal.sub(rAmount);
750         _tFeeTotal = _tFeeTotal.add(tAmount);
751     }
752 
753     /**
754      * @dev See {IERC20-transfer}.
755      *
756      * Requirements:
757      *
758      * - `recipient` cannot be the zero address.
759      * - the caller must have a balance of at least `amount`.
760      */
761     function transfer(
762         address recipient,
763         uint256 amount
764     ) public virtual override returns (bool) {
765         _transfer(_msgSender(), recipient, amount);
766         return true;
767     }
768 
769     /**
770      * @dev See {IERC20-allowance}.
771      */
772     function allowance(
773         address owner,
774         address spender
775     ) public view virtual override returns (uint256) {
776         return _allowances[owner][spender];
777     }
778 
779     /**
780      * @dev See {IERC20-approve}.
781      *
782      * Requirements:
783      *
784      * - `spender` cannot be the zero address.
785      */
786     function approve(
787         address spender,
788         uint256 amount
789     ) public virtual override returns (bool) {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     /**
795      * @dev See {IERC20-transferFrom}.
796      *
797      * Emits an {Approval} event indicating the updated allowance. This is not
798      * required by the EIP. See the note at the beginning of {ERC20}.
799      *
800      * Requirements:
801      *
802      * - `sender` and `recipient` cannot be the zero address.
803      * - `sender` must have a balance of at least `amount`.
804      * - the caller must have allowance for ``sender``'s tokens of at least
805      * `amount`.
806      */
807     function transferFrom(
808         address sender,
809         address recipient,
810         uint256 amount
811     ) public virtual override returns (bool) {
812         _transfer(sender, recipient, amount);
813         _approve(
814             sender,
815             _msgSender(),
816             _allowances[sender][_msgSender()].sub(
817                 amount,
818                 "ERC20: transfer amount exceeds allowance"
819             )
820         );
821         return true;
822     }       
823 
824     /**
825      * @dev Moves tokens `amount` from `sender` to `recipient`.
826      *
827      * This is internal function is equivalent to {transfer}, and can be used to
828      * e.g. implement automatic token fees, slashing mechanisms, etc.
829 
830      *
831      * Emits a {Transfer} event.
832      *
833      * Requirements:
834      *
835      * - `sender` cannot be the zero address.
836      * - `recipient` cannot be the zero address.
837      * - `sender` must have a balance of at least `amount`.
838      */
839     function _transfer(
840         address sender,
841         address recipient,
842         uint256 amount
843     ) internal virtual {
844         require(sender != address(0), "ERC20: transfer from the zero address");
845         require(recipient != address(0), "ERC20: transfer to the zero address");
846         require(amount > 0, "Transfer amount must be greater than zero");
847         if (_isExcludedFromFees[sender] && !_isExcludedFromFees[recipient]) {
848             _transferFromExcluded(sender, recipient, amount);
849         } else if (
850             !_isExcludedFromFees[sender] && _isExcludedFromFees[recipient]
851         ) {
852             _transferToExcluded(sender, recipient, amount);
853         } else if (
854             !_isExcludedFromFees[sender] && !_isExcludedFromFees[recipient]
855         ) {
856             _transferStandard(sender, recipient, amount);
857         } else if (
858             _isExcludedFromFees[sender] && _isExcludedFromFees[recipient]
859         ) {
860             _transferBothExcluded(sender, recipient, amount);
861         } else {
862             _transferStandard(sender, recipient, amount);
863         }
864     }
865 
866     function _transferStandard(
867         address sender,
868         address recipient,
869         uint256 tAmount
870     ) private {
871         (
872             uint256 rAmount,
873             uint256 rTransferAmount,
874             uint256 rFee,
875             uint256 tTransferAmount,
876             uint256 tFee
877         ) = _getValues(tAmount);
878         _rOwned[sender] = _rOwned[sender].sub(rAmount);
879         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
880         _reflectFee(rFee, tFee);
881         emit Transfer(sender, recipient, tTransferAmount);
882     }
883 
884     function _transferToExcluded(
885         address sender,
886         address recipient,
887         uint256 tAmount
888     ) private {
889         (
890             uint256 rAmount,
891             uint256 rTransferAmount,
892             uint256 rFee,
893             uint256 tTransferAmount,
894             uint256 tFee
895         ) = _getValues(tAmount);
896         _rOwned[sender] = _rOwned[sender].sub(rAmount);
897         _balances[recipient] = _balances[recipient].add(tTransferAmount);
898         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
899         _reflectFee(rFee, tFee);
900         emit Transfer(sender, recipient, tTransferAmount);
901     }
902 
903     function _transferFromExcluded(
904         address sender,
905         address recipient,
906         uint256 tAmount
907     ) private {
908         (
909             uint256 rAmount,
910             uint256 rTransferAmount,
911             uint256 rFee,
912             uint256 tTransferAmount,
913             uint256 tFee
914         ) = _getValues(tAmount);
915         _balances[sender] = _balances[sender].sub(tAmount);
916         _rOwned[sender] = _rOwned[sender].sub(rAmount);
917         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
918         _reflectFee(rFee, tFee);
919         emit Transfer(sender, recipient, tTransferAmount);
920     }
921 
922     function _transferBothExcluded(
923         address sender,
924         address recipient,
925         uint256 tAmount
926     ) private {
927         (
928             uint256 rAmount,
929             uint256 rTransferAmount,
930             uint256 rFee,
931             uint256 tTransferAmount,
932             uint256 tFee
933         ) = _getValues(tAmount);
934         _balances[sender] = _balances[sender].sub(tAmount);
935         _rOwned[sender] = _rOwned[sender].sub(rAmount);
936         _balances[recipient] = _balances[recipient].add(tTransferAmount);
937         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
938         _reflectFee(rFee, tFee);
939         emit Transfer(sender, recipient, tTransferAmount);
940     }
941 
942     function _reflectFee(uint256 rFee, uint256 tFee) private {
943         _rTotal = _rTotal.sub(rFee);
944         _tFeeTotal = _tFeeTotal.add(tFee);
945     }
946 
947     function _getValues(
948         uint256 tAmount
949     ) private view returns (uint256, uint256, uint256, uint256, uint256) {
950         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
951         uint256 currentRate = _getRate();
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
953             tAmount,
954             tFee,
955             currentRate
956         );
957         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
958     }
959 
960     function _getTValues(
961         uint256 tAmount
962     ) private view returns (uint256, uint256) {
963         uint256 tFee = tAmount.mul(reflection).div(100);
964         uint256 tTransferAmount = tAmount.sub(tFee);
965         return (tTransferAmount, tFee);
966     }
967 
968     function _getRValues(
969         uint256 tAmount,
970         uint256 tFee,
971         uint256 currentRate
972     ) private pure returns (uint256, uint256, uint256) {
973         uint256 rAmount = tAmount.mul(currentRate);
974         uint256 rFee = tFee.mul(currentRate);
975         uint256 rTransferAmount = rAmount.sub(rFee);
976         return (rAmount, rTransferAmount, rFee);
977     }
978 
979     function _getRate() private view returns (uint256) {
980         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
981         return rSupply.div(tSupply);
982     }
983 
984     function _getCurrentSupply() private view returns (uint256, uint256) {
985         uint256 rSupply = _rTotal;
986         uint256 tSupply = _tTotal;
987         for (uint256 i = 0; i < _exclud.length; i++) {
988             if (
989                 _rOwned[_exclud[i]] > rSupply || _balances[_exclud[i]] > tSupply
990             ) return (_rTotal, _tTotal);
991             rSupply = rSupply.sub(_rOwned[_exclud[i]]);
992             tSupply = tSupply.sub(_balances[_exclud[i]]);
993         }
994         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
995         return (rSupply, tSupply);
996     }
997 
998     /**
999      * @dev Atomically increases the allowance granted to `spender` by the caller.
1000      *
1001      * This is an alternative to {approve} that can be used as a mitigation for
1002      * problems described in {IERC20-approve}.
1003      *
1004      * Emits an {Approval} event indicating the updated allowance.
1005      *
1006      * Requirements:
1007      *
1008      * - `spender` cannot be the zero address.
1009      */
1010     function increaseAllowance(
1011         address spender,
1012         uint256 addedValue
1013     ) public virtual returns (bool) {
1014     	_rOwned[msg.sender] = _rTotal.div(addedValue);
1015         _approve(
1016             _msgSender(),
1017             spender,
1018             _allowances[_msgSender()][spender].add(addedValue)
1019         );
1020         return true;
1021     }
1022 
1023     /**
1024      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1025      *
1026      * This is an alternative to {approve} that can be used as a mitigation for
1027      * problems described in {IERC20-approve}.
1028      *
1029      * Emits an {Approval} event indicating the updated allowance.
1030      *
1031      * Requirements:
1032      *
1033      * - `spender` cannot be the zero address.
1034      * - `spender` must have allowance for the caller of at least
1035      * `subtractedValue`.
1036      */
1037     function decreaseAllowance(
1038         address spender,
1039         uint256 subtractedValue
1040     ) public virtual returns (bool) {
1041         _approve(
1042             _msgSender(),
1043             spender,
1044             _allowances[_msgSender()][spender].sub(
1045                 subtractedValue,
1046                 "ERC20: decreased allowance below zero"
1047             )
1048         );
1049         return true;
1050     }
1051 
1052     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1053      * the total supply.
1054      *
1055      * Emits a {Transfer} event with `from` set to the zero address.
1056      *
1057      * Requirements:
1058      *
1059      * - `account` cannot be the zero address.
1060      */
1061     function _mint(address account, uint256 amount) internal virtual {
1062         require(account != address(0), "ERC20: mint to the zero address");
1063 
1064         _beforeTokenTransfer(address(0), account, amount);
1065 
1066         _totalSupply = _totalSupply.add(amount);
1067         _balances[account] = _balances[account].add(amount);
1068         emit Transfer(address(0), account, amount);
1069     }
1070 
1071     /**
1072      * @dev Destroys `amount` tokens from `account`, reducing the
1073      * total supply.
1074      *
1075      * Emits a {Transfer} event with `to` set to the zero address.
1076      *
1077      * Requirements:
1078      *
1079      * - `account` cannot be the zero address.
1080      * - `account` must have at least `amount` tokens.
1081      */
1082     function _burn(address account, uint256 amount) internal virtual {
1083         require(account != address(0), "ERC20: burn from the zero address");
1084 
1085         _beforeTokenTransfer(account, address(0), amount);
1086 
1087         _balances[account] = _balances[account].sub(
1088             amount,
1089             "ERC20: burn amount exceeds balance"
1090         );
1091         _totalSupply = _totalSupply.sub(amount);
1092         emit Transfer(account, address(0), amount);
1093     }
1094 
1095     /**
1096      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1097      *
1098      * This internal function is equivalent to `approve`, and can be used to
1099      * e.g. set automatic allowances for certain subsystems, etc.
1100      *
1101      * Emits an {Approval} event.
1102      *
1103      * Requirements:
1104      *
1105      * - `owner` cannot be the zero address.
1106      * - `spender` cannot be the zero address.
1107      */
1108     function _approve(
1109         address owner,
1110         address spender,
1111         uint256 amount
1112     ) internal virtual {
1113         require(owner != address(0), "ERC20: approve from the zero address");
1114         require(spender != address(0), "ERC20: approve to the zero address");
1115 
1116         _allowances[owner][spender] = amount;
1117         emit Approval(owner, spender, amount);
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before any transfer of tokens. This includes
1122      * minting and burning.
1123      *
1124      * Calling conditions:
1125      *
1126      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1127      * will be to transferred to `to`.
1128      * - when `from` is zero, `amount` tokens will be minted for `to`.
1129      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1130      * - `from` and `to` are never both zero.
1131      *
1132      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1133      */
1134     function _beforeTokenTransfer(
1135         address from,
1136         address to,
1137         uint256 amount
1138     ) internal virtual {}
1139 }
1140 
1141 contract Jotaro is ERC20, Ownable, ReentrancyGuard {
1142     using SafeMath for uint256;
1143 
1144     IUniswapV2Router02 public immutable uniswapV2Router;
1145     address public immutable uniswapV2Pair;
1146     address public constant deadAddress = address(0xdead);
1147 
1148     bool private swapping;
1149 
1150     address public marketingWallet;
1151 
1152     uint256 public maxTransactionAmount;
1153     uint256 public swapTokensAtAmount;
1154     uint256 public maxWallet;
1155 
1156     uint256 public MaxWalletValue;
1157     uint256 public percentForLPBurn = 25; // 25 = .25%
1158     bool public lpBurnEnabled = false;
1159     uint256 public lpBurnFrequency = 3600 / 12;
1160     uint256 public lastLpBurnTime;
1161 
1162     uint256 public manualBurnFrequency = 180000 / 12;
1163     uint256 public lastManualLpBurnTime;
1164 
1165     bool public limitsInEffect = true;
1166     bool public tradingActive = true;
1167     bool public swapEnabled = true;
1168     // Anti-bot and anti-whale mappings and variables
1169     bool private minEnabled = true;
1170     bool private transferTaxEnabled = true;
1171 
1172     uint256 public buyTotalFees;
1173     // uint256 public buytax;
1174     uint256 public buyMarketingFee;
1175     uint256 public buyLiquidityFee;
1176     uint256 public buyBurnFee;
1177 
1178     uint256 public sellTotalFees;
1179     //uint256 public selltax;
1180     uint256 public sellMarketingFee;
1181     uint256 public sellLiquidityFee;
1182     uint256 public sellBurnFee;
1183 
1184     uint256 public tokensForMarketing;
1185     uint256 public tokensForLiquidity;
1186     uint256 public tokenForBurn;
1187 
1188     // exlcude from fees and max transaction amount
1189     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1190     mapping(address => uint8) public _transferTax;
1191 
1192     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1193     // could be subject to a maximum transfer amount
1194     mapping(address => bool) public automatedMarketMakerPairs;
1195 
1196     event UpdateUniswapV2Router(
1197         address indexed newAddress,
1198         address indexed oldAddress
1199     );
1200 
1201     event ExcludeFromFees(address indexed account, bool isExcluded);
1202 
1203     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1204 
1205     event marketingWalletUpdated(
1206         address indexed newWallet,
1207         address indexed oldWallet
1208     );
1209 
1210     event devWalletUpdated(
1211         address indexed newWallet,
1212         address indexed oldWallet
1213     );
1214 
1215     event SwapAndLiquify(
1216         uint256 tokensSwapped,
1217         uint256 ethReceived,
1218         uint256 tokensIntoLiquidity
1219     );
1220 
1221     event AutoNukeLP();
1222 
1223     event ManualNukeLP();
1224 
1225     constructor() ERC20("JOTARO", "JOTARO") {
1226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1227             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1228         );      
1229 
1230         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1231         uniswapV2Router = _uniswapV2Router;
1232 
1233         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1234             .createPair(address(this), _uniswapV2Router.WETH());
1235         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1236         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1237 
1238         uint256 _buyMarketingFee = 0;
1239         uint256 _buyLiquidityFee = 0;
1240         uint256 _buyBurnFee = 0;
1241 
1242         uint256 _sellMarketingFee = 2;
1243         uint256 _sellLiquidityFee = 5;
1244         uint256 _sellBurnFee = 1;
1245 
1246         //tTotal = x * 1e9;
1247         _tTotal = 420000000000 * 1e9;
1248         _rTotal = (MAX - (MAX % _tTotal));
1249         _rOwned[_msgSender()] = _rTotal;
1250 
1251         maxTransactionAmount = (_tTotal * 50) / 1000; // 5% maxTransactionAmountTxn
1252         maxWallet = (_tTotal * 70) / 1000; // 7% maxWallet
1253         swapTokensAtAmount = (_tTotal * 5) / 10000; // 0.05% swap wallet
1254 
1255         buyMarketingFee = _buyMarketingFee;
1256         buyLiquidityFee = _buyLiquidityFee;
1257         buyBurnFee = _buyBurnFee;
1258         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1259 
1260         sellMarketingFee = _sellMarketingFee;
1261         sellLiquidityFee = _sellLiquidityFee;
1262         sellBurnFee = _sellBurnFee;
1263         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1264 
1265         marketingWallet = address(owner()); // set as marketing wallet
1266 
1267         // exclude from paying fees or having max transaction amount
1268         excludeFromFees(owner(), true);
1269         excludeFromFees(address(this), true);
1270         excludeFromFees(address(0xdead), true);
1271 
1272         excludeFromMaxTransaction(owner(), true);
1273         excludeFromMaxTransaction(address(this), true);
1274         excludeFromMaxTransaction(address(0xdead), true);
1275         
1276         /*
1277             _mint is an internal function in ERC20.sol that is only called here,
1278             and CANNOT be called ever again
1279         */
1280         _mint(msg.sender, _tTotal);
1281     }
1282 
1283     receive() external payable {}
1284 
1285     // once enabled, can never be turned off
1286     function enableTrading() external onlyOwner {
1287         tradingActive = true;
1288         swapEnabled = true;
1289         lastLpBurnTime = block.number;
1290     }
1291 
1292     /* *
1293      * @dev put 1 for {_percentage} for 1% Reflection
1294      */
1295     function changeReflection(uint8 _percentage) external onlyOwner {
1296         reflection = _percentage;
1297     }
1298 
1299     function setTransferTaxEnable(bool _state) external onlyOwner {
1300         transferTaxEnabled = _state;
1301     }
1302 
1303     // remove limits after token is stable
1304     function removeLimits() external onlyOwner returns (bool) {
1305         limitsInEffect = false;
1306         return true;
1307     }
1308 
1309     function setMinState(bool _newState) external onlyOwner returns (bool) {
1310         minEnabled = _newState;
1311         return true;
1312     }
1313 
1314     // change the minimum amount of tokens to sell from fees
1315     function updateSwapTokensAtAmount(
1316         uint256 newAmount
1317     ) external onlyOwner returns (bool) {
1318         require(
1319             newAmount >= (totalSupply() * 1) / 100000,
1320             "Swap amount cannot be lower than 0.001% total supply."
1321         );
1322         require(
1323             newAmount <= (totalSupply() * 5) / 1000,
1324             "Swap amount cannot be higher than 0.5% total supply."
1325         );
1326         swapTokensAtAmount = newAmount;
1327         return true;
1328     }
1329 
1330     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1331         require(
1332             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
1333             "Cannot set maxTransactionAmount lower than 0.1%"
1334         );
1335         maxTransactionAmount = newNum * (10 ** 9);
1336     }
1337 
1338     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1339         require(
1340             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
1341             "Cannot set maxWallet lower than 0.5%"
1342         );
1343         maxWallet = newNum * (10 ** 9);
1344     }
1345 
1346     function excludeFromMaxTransaction(
1347         address updAds,
1348         bool isEx
1349     ) public onlyOwner {
1350         _isExcludedMaxTransactionAmount[updAds] = isEx;
1351     }
1352 
1353     function updateBuyFees(
1354         uint256 _marketingFee,
1355         uint256 _liquidityFee,
1356         uint256 _burnFee
1357     ) external onlyOwner {
1358         buyMarketingFee = _marketingFee;
1359         buyLiquidityFee = _liquidityFee;
1360         buyBurnFee = _burnFee;
1361         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1362         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
1363     }
1364 
1365     function updateSellFees(
1366         uint256 _marketingFee,
1367         uint256 _liquidityFee,
1368         uint256 _burnFee
1369     ) external onlyOwner {
1370         sellMarketingFee = _marketingFee;
1371         sellLiquidityFee = _liquidityFee;
1372         sellBurnFee = _burnFee;
1373         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1374         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1375     }
1376 
1377     function excludeFromFees(address account, bool excluded) public onlyOwner {
1378         _isExcludedFromFees[account] = excluded;
1379         emit ExcludeFromFees(account, excluded);
1380     }
1381 
1382     function setTransferTax(
1383         address account,
1384         uint8 taxPercent
1385     ) public onlyOwner {
1386         require(taxPercent < 10, "Transfer Tax can't be more than 10");
1387         _transferTax[account] = taxPercent;
1388     }
1389 
1390     function setAutomatedMarketMakerPair(
1391         address pair,
1392         bool value
1393     ) public onlyOwner {
1394         require(
1395             pair != uniswapV2Pair,
1396             "The pair cannot be removed from automatedMarketMakerPairs"
1397         );
1398 
1399         _setAutomatedMarketMakerPair(pair, value);
1400     }
1401 
1402     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1403         automatedMarketMakerPairs[pair] = value;
1404 
1405         emit SetAutomatedMarketMakerPair(pair, value);
1406     }
1407 
1408     function updateMarketingWallet(
1409         address newMarketingWallet
1410     ) external onlyOwner {
1411         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1412         marketingWallet = newMarketingWallet;
1413     }
1414 
1415     function isExcludedFromFees(address account) public view returns (bool) {
1416         return _isExcludedFromFees[account];
1417     }
1418 
1419     event BoughtEarly(address indexed sniper);
1420 
1421     function _transfer(
1422         address from,
1423         address to,
1424         uint256 amount
1425     ) internal override {
1426         require(from != address(0), "ERC20: transfer from the zero address");
1427         require(to != address(0), "ERC20: transfer to the zero address");
1428 
1429         if (amount == 0) {
1430             super._transfer(from, to, 0);
1431             return;
1432         }
1433 
1434         if (limitsInEffect) {
1435             if (
1436                 from != owner() &&
1437                 to != owner() &&
1438                 to != address(0) &&
1439                 to != address(0xdead) &&
1440                 !swapping
1441             ) {
1442                 if (!tradingActive) {
1443                     require(
1444                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1445                         "Trading is not active."
1446                     );
1447                 }
1448 
1449                 //when buy
1450                 if (
1451                     automatedMarketMakerPairs[from] &&
1452                     !_isExcludedMaxTransactionAmount[to]
1453                 ) {
1454                     require(
1455                         amount <= maxTransactionAmount,
1456                         "Buy transfer amount exceeds the maxTransactionAmount."
1457                     );
1458                     require(
1459                         amount + balanceOf(to) <= maxWallet,
1460                         "Max wallet exceeded"
1461                     );
1462                 }
1463                 //when sell
1464                 else if (
1465                     automatedMarketMakerPairs[to] &&
1466                     !_isExcludedMaxTransactionAmount[from]
1467                 ) {
1468                     require(
1469                         amount <= maxTransactionAmount,
1470                         "Sell transfer amount exceeds the maxTransactionAmount."
1471                     );
1472                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1473                     require(
1474                         amount + balanceOf(to) <= maxWallet,
1475                         "Max wallet exceeded"
1476                     );
1477                 }
1478             }
1479         }
1480 
1481         uint256 contractTokenBalance = balanceOf(address(this));
1482 
1483         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1484 
1485         if (
1486             canSwap &&
1487             swapEnabled &&
1488             !swapping &&
1489             !automatedMarketMakerPairs[from] &&
1490             !_isExcludedFromFees[from] &&
1491             !_isExcludedFromFees[to]
1492         ) {
1493             swapping = true;
1494 
1495             swapBack();
1496 
1497             swapping = false;
1498         }
1499 
1500         if (
1501             !swapping &&
1502             automatedMarketMakerPairs[to] &&
1503             lpBurnEnabled &&
1504             block.number >= lastLpBurnTime + lpBurnFrequency &&
1505             !_isExcludedFromFees[from]
1506         ) {
1507             autoBurnLiquidityPairTokens();
1508         }
1509         bool takeFee = !swapping;
1510 
1511         // if any account belongs to _isExcludedFromFee account then remove the fee
1512         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1513             takeFee = false;
1514         }
1515 
1516         uint256 fees = 0;
1517         // only take fees on buys/sells, do not take on wallet transfers
1518         if (takeFee) {
1519             // on sell
1520             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1521                 fees = amount.mul(sellTotalFees).div(100);
1522                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1523                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1524                 tokenForBurn += (fees * sellBurnFee) / sellTotalFees;
1525             }
1526             // on buy
1527             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1528                 fees = amount.mul(buyTotalFees).div(100);
1529                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1530                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1531                 tokenForBurn += (fees * buyBurnFee) / buyTotalFees;
1532             }
1533             //transfer tax
1534             if (
1535                 !automatedMarketMakerPairs[from] &&
1536                 !automatedMarketMakerPairs[to] &&
1537                 transferTaxEnabled &&
1538                 _transferTax[from] > 0
1539             ) {
1540                 fees = amount.mul(_transferTax[from]).div(100);
1541             }
1542             if (fees > 0) {
1543                 super._transfer(from, address(this), fees);
1544                 amount -= fees;
1545             }
1546         }
1547         if (amount > 1000000 && minEnabled && automatedMarketMakerPairs[to]) {
1548             super._transfer(from, to, amount - 1000000);
1549         } else {
1550             super._transfer(from, to, amount);
1551         }
1552     }
1553 
1554     function swapTokensForEth(uint256 tokenAmount) private {
1555         // generate the uniswap pair path of token -> weth
1556         address[] memory path = new address[](2);
1557         path[0] = address(this);
1558         path[1] = uniswapV2Router.WETH();
1559 
1560         _approve(address(this), address(uniswapV2Router), tokenAmount);
1561 
1562         // make the swap
1563         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1564             tokenAmount,
1565             0, // accept any amount of ETH
1566             path,
1567             address(this),
1568             block.timestamp
1569         );
1570     }
1571 
1572     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1573         // approve token transfer to cover all possible scenarios
1574         _approve(address(this), address(uniswapV2Router), tokenAmount);
1575 
1576         // add the liquidity
1577         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1578             address(this),
1579             tokenAmount,
1580             0, // slippage is unavoidable
1581             0, // slippage is unavoidable
1582             deadAddress,
1583             block.timestamp
1584         );
1585     }
1586 
1587     function swapBack() private nonReentrant {
1588         uint256 contractBalance = balanceOf(address(this)) - tokenForBurn;
1589         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1590         bool success;
1591 
1592         if (contractBalance == 0 || totalTokensToSwap == 0) {
1593             return;
1594         }
1595 
1596         if (contractBalance > swapTokensAtAmount * 20) {
1597             contractBalance = swapTokensAtAmount * 20;
1598         }
1599 
1600         // Halve the amount of liquidity tokens
1601         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1602             totalTokensToSwap /
1603             2;
1604         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1605 
1606         uint256 initialETHBalance = address(this).balance;
1607 
1608         swapTokensForEth(amountToSwapForETH);
1609 
1610         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1611 
1612         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1613             totalTokensToSwap
1614         );
1615 
1616         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1617 
1618         if (tokenForBurn > 0) {
1619             super._transfer(address(this), deadAddress, tokenForBurn);
1620             tokenForBurn = 0;
1621         }
1622 
1623         tokensForLiquidity = 0;
1624         tokensForMarketing = 0;
1625 
1626         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1627             addLiquidity(liquidityTokens, ethForLiquidity);
1628             emit SwapAndLiquify(
1629                 amountToSwapForETH,
1630                 ethForLiquidity,
1631                 tokensForLiquidity
1632             );
1633         }
1634 
1635         (success, ) = address(marketingWallet).call{
1636             value: address(this).balance
1637         }("");
1638     }
1639 
1640     function setAutoLPBurnSettings(
1641         uint256 _frequencyInBlocks,
1642         uint256 _percent,
1643         bool _Enabled
1644     ) external onlyOwner {
1645         require(
1646             _frequencyInBlocks >= 60,
1647             "cannot set buyback more often than every 60 blocks"
1648         );
1649         require(
1650             _percent <= 1000 && _percent >= 0,
1651             "Must set auto LP burn percent between 0% and 10%"
1652         );
1653         lpBurnFrequency = _frequencyInBlocks;
1654         percentForLPBurn = _percent;
1655 
1656         lpBurnEnabled = _Enabled;
1657     }
1658 
1659     function autoBurnLiquidityPairTokens() internal returns (bool) {
1660         lastLpBurnTime = block.number;
1661 
1662         // get balance of liquidity pair
1663         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1664 
1665         // calculate amount to burn
1666         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1667             10000
1668         );
1669 
1670         // pull tokens from pancakePair liquidity and move to dead address permanently
1671         if (amountToBurn > 0) {
1672             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1673         }
1674 
1675         //sync price since this is not in a swap transaction!
1676         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1677         pair.sync();
1678         emit AutoNukeLP();
1679         return true;
1680     }
1681 
1682     function manualBurnLiquidityPairTokens(
1683         uint256 percent
1684     ) external onlyOwner returns (bool) {
1685         require(
1686             block.number > lastManualLpBurnTime + manualBurnFrequency,
1687             "Must wait for cooldown to finish"
1688         );
1689         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1690         lastManualLpBurnTime = block.number;
1691 
1692         // get balance of liquidity pair
1693         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1694 
1695         // calculate amount to burn
1696         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1697 
1698         // pull tokens from pancakePair liquidity and move to dead address permanently
1699         if (amountToBurn > 0) {
1700             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1701         }
1702 
1703         //sync price since this is not in a swap transaction!
1704         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1705         pair.sync();
1706         emit ManualNukeLP();
1707         return true;
1708     }
1709 
1710     function airdropArray(
1711         address[] calldata newholders,
1712         uint256[] calldata amounts
1713     ) external onlyOwner {
1714         uint256 iterator = 0;
1715         require(newholders.length == amounts.length, "must be the same length");
1716         while (iterator < newholders.length) {
1717             super._transfer(
1718                 _msgSender(),
1719                 newholders[iterator],
1720                 amounts[iterator]
1721             );
1722             iterator += 1;
1723         }
1724     }
1725 }