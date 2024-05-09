1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.10;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: IUniswapV2Factory
9 
10 interface IUniswapV2Factory {
11     event PairCreated(
12         address indexed token0,
13         address indexed token1,
14         address pair,
15         uint256
16     );
17 
18     function feeTo() external view returns (address);
19 
20     function feeToSetter() external view returns (address);
21 
22     function getPair(address tokenA, address tokenB)
23         external
24         view
25         returns (address pair);
26 
27     function allPairs(uint256) external view returns (address pair);
28 
29     function allPairsLength() external view returns (uint256);
30 
31     function createPair(address tokenA, address tokenB)
32         external
33         returns (address pair);
34 
35     function setFeeTo(address) external;
36 
37     function setFeeToSetter(address) external;
38 }
39 
40 // Part: IUniswapV2Pair
41 
42 interface IUniswapV2Pair {
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     function name() external pure returns (string memory);
51 
52     function symbol() external pure returns (string memory);
53 
54     function decimals() external pure returns (uint8);
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address owner) external view returns (uint256);
59 
60     function allowance(address owner, address spender)
61         external
62         view
63         returns (uint256);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transfer(address to, uint256 value) external returns (bool);
68 
69     function transferFrom(
70         address from,
71         address to,
72         uint256 value
73     ) external returns (bool);
74 
75     function DOMAIN_SEPARATOR() external view returns (bytes32);
76 
77     function PERMIT_TYPEHASH() external pure returns (bytes32);
78 
79     function nonces(address owner) external view returns (uint256);
80 
81     function permit(
82         address owner,
83         address spender,
84         uint256 value,
85         uint256 deadline,
86         uint8 v,
87         bytes32 r,
88         bytes32 s
89     ) external;
90 
91     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
92     event Burn(
93         address indexed sender,
94         uint256 amount0,
95         uint256 amount1,
96         address indexed to
97     );
98     event Swap(
99         address indexed sender,
100         uint256 amount0In,
101         uint256 amount1In,
102         uint256 amount0Out,
103         uint256 amount1Out,
104         address indexed to
105     );
106     event Sync(uint112 reserve0, uint112 reserve1);
107 
108     function MINIMUM_LIQUIDITY() external pure returns (uint256);
109 
110     function factory() external view returns (address);
111 
112     function token0() external view returns (address);
113 
114     function token1() external view returns (address);
115 
116     function getReserves()
117         external
118         view
119         returns (
120             uint112 reserve0,
121             uint112 reserve1,
122             uint32 blockTimestampLast
123         );
124 
125     function price0CumulativeLast() external view returns (uint256);
126 
127     function price1CumulativeLast() external view returns (uint256);
128 
129     function kLast() external view returns (uint256);
130 
131     function mint(address to) external returns (uint256 liquidity);
132 
133     function burn(address to)
134         external
135         returns (uint256 amount0, uint256 amount1);
136 
137     function swap(
138         uint256 amount0Out,
139         uint256 amount1Out,
140         address to,
141         bytes calldata data
142     ) external;
143 
144     function skim(address to) external;
145 
146     function sync() external;
147 
148     function initialize(address, address) external;
149 }
150 
151 // Part: IUniswapV2Router02
152 
153 interface IUniswapV2Router02 {
154     function factory() external pure returns (address);
155 
156     function WETH() external pure returns (address);
157 
158     function addLiquidity(
159         address tokenA,
160         address tokenB,
161         uint256 amountADesired,
162         uint256 amountBDesired,
163         uint256 amountAMin,
164         uint256 amountBMin,
165         address to,
166         uint256 deadline
167     )
168         external
169         returns (
170             uint256 amountA,
171             uint256 amountB,
172             uint256 liquidity
173         );
174 
175     function addLiquidityETH(
176         address token,
177         uint256 amountTokenDesired,
178         uint256 amountTokenMin,
179         uint256 amountETHMin,
180         address to,
181         uint256 deadline
182     )
183         external
184         payable
185         returns (
186             uint256 amountToken,
187             uint256 amountETH,
188             uint256 liquidity
189         );
190 
191     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
192         uint256 amountIn,
193         uint256 amountOutMin,
194         address[] calldata path,
195         address to,
196         uint256 deadline
197     ) external;
198 
199     function swapExactETHForTokensSupportingFeeOnTransferTokens(
200         uint256 amountOutMin,
201         address[] calldata path,
202         address to,
203         uint256 deadline
204     ) external payable;
205 
206     function swapExactTokensForETHSupportingFeeOnTransferTokens(
207         uint256 amountIn,
208         uint256 amountOutMin,
209         address[] calldata path,
210         address to,
211         uint256 deadline
212     ) external;
213 }
214 
215 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Context
216 
217 /**
218  * @dev Provides information about the current execution context, including the
219  * sender of the transaction and its data. While these are generally available
220  * via msg.sender and msg.data, they should not be accessed in such a direct
221  * manner, since when dealing with meta-transactions the account sending and
222  * paying for execution may not be the actual sender (as far as an application
223  * is concerned).
224  *
225  * This contract is only required for intermediate, library-like contracts.
226  */
227 abstract contract Context {
228     function _msgSender() internal view virtual returns (address) {
229         return msg.sender;
230     }
231 
232     function _msgData() internal view virtual returns (bytes calldata) {
233         return msg.data;
234     }
235 }
236 
237 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC20
238 
239 /**
240  * @dev Interface of the ERC20 standard as defined in the EIP.
241  */
242 interface IERC20 {
243     /**
244      * @dev Returns the amount of tokens in existence.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns the amount of tokens owned by `account`.
250      */
251     function balanceOf(address account) external view returns (uint256);
252 
253     /**
254      * @dev Moves `amount` tokens from the caller's account to `recipient`.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transfer(address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Returns the remaining number of tokens that `spender` will be
264      * allowed to spend on behalf of `owner` through {transferFrom}. This is
265      * zero by default.
266      *
267      * This value changes when {approve} or {transferFrom} are called.
268      */
269     function allowance(address owner, address spender) external view returns (uint256);
270 
271     /**
272      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * IMPORTANT: Beware that changing an allowance with this method brings the risk
277      * that someone may use both the old and the new allowance by unfortunate
278      * transaction ordering. One possible solution to mitigate this race
279      * condition is to first reduce the spender's allowance to 0 and set the
280      * desired value afterwards:
281      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282      *
283      * Emits an {Approval} event.
284      */
285     function approve(address spender, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Moves `amount` tokens from `sender` to `recipient` using the
289      * allowance mechanism. `amount` is then deducted from the caller's
290      * allowance.
291      *
292      * Returns a boolean value indicating whether the operation succeeded.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) external returns (bool);
301 
302     /**
303      * @dev Emitted when `value` tokens are moved from one account (`from`) to
304      * another (`to`).
305      *
306      * Note that `value` may be zero.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 value);
309 
310     /**
311      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
312      * a call to {approve}. `value` is the new allowance.
313      */
314     event Approval(address indexed owner, address indexed spender, uint256 value);
315 }
316 
317 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/SafeMath
318 
319 // CAUTION
320 // This version of SafeMath should only be used with Solidity 0.8 or later,
321 // because it relies on the compiler's built in overflow checks.
322 
323 /**
324  * @dev Wrappers over Solidity's arithmetic operations.
325  *
326  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
327  * now has built in overflow checking.
328  */
329 library SafeMath {
330     /**
331      * @dev Returns the addition of two unsigned integers, with an overflow flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         unchecked {
337             uint256 c = a + b;
338             if (c < a) return (false, 0);
339             return (true, c);
340         }
341     }
342 
343     /**
344      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
345      *
346      * _Available since v3.4._
347      */
348     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
349         unchecked {
350             if (b > a) return (false, 0);
351             return (true, a - b);
352         }
353     }
354 
355     /**
356      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
357      *
358      * _Available since v3.4._
359      */
360     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         unchecked {
362             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
363             // benefit is lost if 'b' is also tested.
364             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
365             if (a == 0) return (true, 0);
366             uint256 c = a * b;
367             if (c / a != b) return (false, 0);
368             return (true, c);
369         }
370     }
371 
372     /**
373      * @dev Returns the division of two unsigned integers, with a division by zero flag.
374      *
375      * _Available since v3.4._
376      */
377     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         unchecked {
379             if (b == 0) return (false, 0);
380             return (true, a / b);
381         }
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
386      *
387      * _Available since v3.4._
388      */
389     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
390         unchecked {
391             if (b == 0) return (false, 0);
392             return (true, a % b);
393         }
394     }
395 
396     /**
397      * @dev Returns the addition of two unsigned integers, reverting on
398      * overflow.
399      *
400      * Counterpart to Solidity's `+` operator.
401      *
402      * Requirements:
403      *
404      * - Addition cannot overflow.
405      */
406     function add(uint256 a, uint256 b) internal pure returns (uint256) {
407         return a + b;
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting on
412      * overflow (when the result is negative).
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      *
418      * - Subtraction cannot overflow.
419      */
420     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421         return a - b;
422     }
423 
424     /**
425      * @dev Returns the multiplication of two unsigned integers, reverting on
426      * overflow.
427      *
428      * Counterpart to Solidity's `*` operator.
429      *
430      * Requirements:
431      *
432      * - Multiplication cannot overflow.
433      */
434     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435         return a * b;
436     }
437 
438     /**
439      * @dev Returns the integer division of two unsigned integers, reverting on
440      * division by zero. The result is rounded towards zero.
441      *
442      * Counterpart to Solidity's `/` operator.
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function div(uint256 a, uint256 b) internal pure returns (uint256) {
449         return a / b;
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * reverting when dividing by zero.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
465         return a % b;
466     }
467 
468     /**
469      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
470      * overflow (when the result is negative).
471      *
472      * CAUTION: This function is deprecated because it requires allocating memory for the error
473      * message unnecessarily. For custom revert reasons use {trySub}.
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(
482         uint256 a,
483         uint256 b,
484         string memory errorMessage
485     ) internal pure returns (uint256) {
486         unchecked {
487             require(b <= a, errorMessage);
488             return a - b;
489         }
490     }
491 
492     /**
493      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
494      * division by zero. The result is rounded towards zero.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function div(
505         uint256 a,
506         uint256 b,
507         string memory errorMessage
508     ) internal pure returns (uint256) {
509         unchecked {
510             require(b > 0, errorMessage);
511             return a / b;
512         }
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * reverting with custom message when dividing by zero.
518      *
519      * CAUTION: This function is deprecated because it requires allocating memory for the error
520      * message unnecessarily. For custom revert reasons use {tryMod}.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(
531         uint256 a,
532         uint256 b,
533         string memory errorMessage
534     ) internal pure returns (uint256) {
535         unchecked {
536             require(b > 0, errorMessage);
537             return a % b;
538         }
539     }
540 }
541 
542 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/IERC20Metadata
543 
544 /**
545  * @dev Interface for the optional metadata functions from the ERC20 standard.
546  *
547  * _Available since v4.1._
548  */
549 interface IERC20Metadata is IERC20 {
550     /**
551      * @dev Returns the name of the token.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the symbol of the token.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the decimals places of the token.
562      */
563     function decimals() external view returns (uint8);
564 }
565 
566 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/Ownable
567 
568 /**
569  * @dev Contract module which provides a basic access control mechanism, where
570  * there is an account (an owner) that can be granted exclusive access to
571  * specific functions.
572  *
573  * By default, the owner account will be the one that deploys the contract. This
574  * can later be changed with {transferOwnership}.
575  *
576  * This module is used through inheritance. It will make available the modifier
577  * `onlyOwner`, which can be applied to your functions to restrict their use to
578  * the owner.
579  */
580 abstract contract Ownable is Context {
581     address private _owner;
582 
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584 
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor() {
589         _transferOwnership(_msgSender());
590     }
591 
592     /**
593      * @dev Returns the address of the current owner.
594      */
595     function owner() public view virtual returns (address) {
596         return _owner;
597     }
598 
599     /**
600      * @dev Throws if called by any account other than the owner.
601      */
602     modifier onlyOwner() {
603         require(owner() == _msgSender(), "Ownable: caller is not the owner");
604         _;
605     }
606 
607     /**
608      * @dev Leaves the contract without owner. It will not be possible to call
609      * `onlyOwner` functions anymore. Can only be called by the current owner.
610      *
611      * NOTE: Renouncing ownership will leave the contract without an owner,
612      * thereby removing any functionality that is only available to the owner.
613      */
614     function renounceOwnership() public virtual onlyOwner {
615         _transferOwnership(address(0));
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         _transferOwnership(newOwner);
625     }
626 
627     /**
628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
629      * Internal function without access restriction.
630      */
631     function _transferOwnership(address newOwner) internal virtual {
632         address oldOwner = _owner;
633         _owner = newOwner;
634         emit OwnershipTransferred(oldOwner, newOwner);
635     }
636 }
637 
638 // Part: OpenZeppelin/openzeppelin-contracts@4.4.2/ERC20
639 
640 /**
641  * @dev Implementation of the {IERC20} interface.
642  *
643  * This implementation is agnostic to the way tokens are created. This means
644  * that a supply mechanism has to be added in a derived contract using {_mint}.
645  * For a generic mechanism see {ERC20PresetMinterPauser}.
646  *
647  * TIP: For a detailed writeup see our guide
648  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
649  * to implement supply mechanisms].
650  *
651  * We have followed general OpenZeppelin Contracts guidelines: functions revert
652  * instead returning `false` on failure. This behavior is nonetheless
653  * conventional and does not conflict with the expectations of ERC20
654  * applications.
655  *
656  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
657  * This allows applications to reconstruct the allowance for all accounts just
658  * by listening to said events. Other implementations of the EIP may not emit
659  * these events, as it isn't required by the specification.
660  *
661  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
662  * functions have been added to mitigate the well-known issues around setting
663  * allowances. See {IERC20-approve}.
664  */
665 contract ERC20 is Context, IERC20, IERC20Metadata {
666     mapping(address => uint256) private _balances;
667 
668     mapping(address => mapping(address => uint256)) private _allowances;
669 
670     uint256 private _totalSupply;
671 
672     string private _name;
673     string private _symbol;
674 
675     /**
676      * @dev Sets the values for {name} and {symbol}.
677      *
678      * The default value of {decimals} is 18. To select a different value for
679      * {decimals} you should overload it.
680      *
681      * All two of these values are immutable: they can only be set once during
682      * construction.
683      */
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev Returns the name of the token.
691      */
692     function name() public view virtual override returns (string memory) {
693         return _name;
694     }
695 
696     /**
697      * @dev Returns the symbol of the token, usually a shorter version of the
698      * name.
699      */
700     function symbol() public view virtual override returns (string memory) {
701         return _symbol;
702     }
703 
704     /**
705      * @dev Returns the number of decimals used to get its user representation.
706      * For example, if `decimals` equals `2`, a balance of `505` tokens should
707      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
708      *
709      * Tokens usually opt for a value of 18, imitating the relationship between
710      * Ether and Wei. This is the value {ERC20} uses, unless this function is
711      * overridden;
712      *
713      * NOTE: This information is only used for _display_ purposes: it in
714      * no way affects any of the arithmetic of the contract, including
715      * {IERC20-balanceOf} and {IERC20-transfer}.
716      */
717     function decimals() public view virtual override returns (uint8) {
718         return 18;
719     }
720 
721     /**
722      * @dev See {IERC20-totalSupply}.
723      */
724     function totalSupply() public view virtual override returns (uint256) {
725         return _totalSupply;
726     }
727 
728     /**
729      * @dev See {IERC20-balanceOf}.
730      */
731     function balanceOf(address account) public view virtual override returns (uint256) {
732         return _balances[account];
733     }
734 
735     /**
736      * @dev See {IERC20-transfer}.
737      *
738      * Requirements:
739      *
740      * - `recipient` cannot be the zero address.
741      * - the caller must have a balance of at least `amount`.
742      */
743     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
744         _transfer(_msgSender(), recipient, amount);
745         return true;
746     }
747 
748     /**
749      * @dev See {IERC20-allowance}.
750      */
751     function allowance(address owner, address spender) public view virtual override returns (uint256) {
752         return _allowances[owner][spender];
753     }
754 
755     /**
756      * @dev See {IERC20-approve}.
757      *
758      * Requirements:
759      *
760      * - `spender` cannot be the zero address.
761      */
762     function approve(address spender, uint256 amount) public virtual override returns (bool) {
763         _approve(_msgSender(), spender, amount);
764         return true;
765     }
766 
767     /**
768      * @dev See {IERC20-transferFrom}.
769      *
770      * Emits an {Approval} event indicating the updated allowance. This is not
771      * required by the EIP. See the note at the beginning of {ERC20}.
772      *
773      * Requirements:
774      *
775      * - `sender` and `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      * - the caller must have allowance for ``sender``'s tokens of at least
778      * `amount`.
779      */
780     function transferFrom(
781         address sender,
782         address recipient,
783         uint256 amount
784     ) public virtual override returns (bool) {
785         _transfer(sender, recipient, amount);
786 
787         uint256 currentAllowance = _allowances[sender][_msgSender()];
788         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
789         unchecked {
790             _approve(sender, _msgSender(), currentAllowance - amount);
791         }
792 
793         return true;
794     }
795 
796     /**
797      * @dev Atomically increases the allowance granted to `spender` by the caller.
798      *
799      * This is an alternative to {approve} that can be used as a mitigation for
800      * problems described in {IERC20-approve}.
801      *
802      * Emits an {Approval} event indicating the updated allowance.
803      *
804      * Requirements:
805      *
806      * - `spender` cannot be the zero address.
807      */
808     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
810         return true;
811     }
812 
813     /**
814      * @dev Atomically decreases the allowance granted to `spender` by the caller.
815      *
816      * This is an alternative to {approve} that can be used as a mitigation for
817      * problems described in {IERC20-approve}.
818      *
819      * Emits an {Approval} event indicating the updated allowance.
820      *
821      * Requirements:
822      *
823      * - `spender` cannot be the zero address.
824      * - `spender` must have allowance for the caller of at least
825      * `subtractedValue`.
826      */
827     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
828         uint256 currentAllowance = _allowances[_msgSender()][spender];
829         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
830         unchecked {
831             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
832         }
833 
834         return true;
835     }
836 
837     /**
838      * @dev Moves `amount` of tokens from `sender` to `recipient`.
839      *
840      * This internal function is equivalent to {transfer}, and can be used to
841      * e.g. implement automatic token fees, slashing mechanisms, etc.
842      *
843      * Emits a {Transfer} event.
844      *
845      * Requirements:
846      *
847      * - `sender` cannot be the zero address.
848      * - `recipient` cannot be the zero address.
849      * - `sender` must have a balance of at least `amount`.
850      */
851     function _transfer(
852         address sender,
853         address recipient,
854         uint256 amount
855     ) internal virtual {
856         require(sender != address(0), "ERC20: transfer from the zero address");
857         require(recipient != address(0), "ERC20: transfer to the zero address");
858 
859         _beforeTokenTransfer(sender, recipient, amount);
860 
861         uint256 senderBalance = _balances[sender];
862         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
863         unchecked {
864             _balances[sender] = senderBalance - amount;
865         }
866         _balances[recipient] += amount;
867 
868         emit Transfer(sender, recipient, amount);
869 
870         _afterTokenTransfer(sender, recipient, amount);
871     }
872 
873     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
874      * the total supply.
875      *
876      * Emits a {Transfer} event with `from` set to the zero address.
877      *
878      * Requirements:
879      *
880      * - `account` cannot be the zero address.
881      */
882     function _mint(address account, uint256 amount) internal virtual {
883         require(account != address(0), "ERC20: mint to the zero address");
884 
885         _beforeTokenTransfer(address(0), account, amount);
886 
887         _totalSupply += amount;
888         _balances[account] += amount;
889         emit Transfer(address(0), account, amount);
890 
891         _afterTokenTransfer(address(0), account, amount);
892     }
893 
894     /**
895      * @dev Destroys `amount` tokens from `account`, reducing the
896      * total supply.
897      *
898      * Emits a {Transfer} event with `to` set to the zero address.
899      *
900      * Requirements:
901      *
902      * - `account` cannot be the zero address.
903      * - `account` must have at least `amount` tokens.
904      */
905     function _burn(address account, uint256 amount) internal virtual {
906         require(account != address(0), "ERC20: burn from the zero address");
907 
908         _beforeTokenTransfer(account, address(0), amount);
909 
910         uint256 accountBalance = _balances[account];
911         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
912         unchecked {
913             _balances[account] = accountBalance - amount;
914         }
915         _totalSupply -= amount;
916 
917         emit Transfer(account, address(0), amount);
918 
919         _afterTokenTransfer(account, address(0), amount);
920     }
921 
922     /**
923      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
924      *
925      * This internal function is equivalent to `approve`, and can be used to
926      * e.g. set automatic allowances for certain subsystems, etc.
927      *
928      * Emits an {Approval} event.
929      *
930      * Requirements:
931      *
932      * - `owner` cannot be the zero address.
933      * - `spender` cannot be the zero address.
934      */
935     function _approve(
936         address owner,
937         address spender,
938         uint256 amount
939     ) internal virtual {
940         require(owner != address(0), "ERC20: approve from the zero address");
941         require(spender != address(0), "ERC20: approve to the zero address");
942 
943         _allowances[owner][spender] = amount;
944         emit Approval(owner, spender, amount);
945     }
946 
947     /**
948      * @dev Hook that is called before any transfer of tokens. This includes
949      * minting and burning.
950      *
951      * Calling conditions:
952      *
953      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
954      * will be transferred to `to`.
955      * - when `from` is zero, `amount` tokens will be minted for `to`.
956      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
957      * - `from` and `to` are never both zero.
958      *
959      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
960      */
961     function _beforeTokenTransfer(
962         address from,
963         address to,
964         uint256 amount
965     ) internal virtual {}
966 
967     /**
968      * @dev Hook that is called after any transfer of tokens. This includes
969      * minting and burning.
970      *
971      * Calling conditions:
972      *
973      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
974      * has been transferred to `to`.
975      * - when `from` is zero, `amount` tokens have been minted for `to`.
976      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _afterTokenTransfer(
982         address from,
983         address to,
984         uint256 amount
985     ) internal virtual {}
986 }
987 
988 // File: Innit.sol
989 
990 contract Innit is ERC20, Ownable {
991 
992     using SafeMath for uint256;
993 
994     IUniswapV2Router02 public immutable uniswapV2Router;
995     address public immutable uniswapV2Pair;
996     address public constant deadAddress = address(0xdead);
997 
998     bool private swapping;
999 
1000     address public marketingWallet;
1001 
1002     uint256 public maxTransactionAmount;
1003     uint256 public swapTokensAtAmount;
1004     uint256 public maxWallet;
1005 
1006     uint256 public percentForLPBurn = 25; // 25 = .25%
1007     bool public lpBurnEnabled = true;
1008     uint256 public lpBurnFrequency = 3600 seconds;
1009     uint256 public lastLpBurnTime;
1010 
1011     uint256 public manualBurnFrequency = 30 minutes;
1012     uint256 public lastManualLpBurnTime;
1013 
1014     bool public limitsInEffect = true;
1015     bool public tradingActive = false;
1016     bool public swapEnabled = false;
1017 
1018     // Anti-bot and anti-whale mappings and variables
1019     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1020     bool public transferDelayEnabled = true;
1021 
1022     uint256 public buyTotalFees;
1023     uint256 public buyMarketingFee;
1024     uint256 public buyLiquidityFee;
1025 
1026     uint256 public sellTotalFees;
1027     uint256 public sellMarketingFee;
1028     uint256 public sellLiquidityFee;
1029 
1030     uint256 public tokensForMarketing;
1031     uint256 public tokensForLiquidity;
1032 
1033     /******************/
1034 
1035     // exlcude from fees and max transaction amount
1036     mapping(address => bool) private _isExcludedFromFees;
1037     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1038 
1039     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1040     // could be subject to a maximum transfer amount
1041     mapping(address => bool) public automatedMarketMakerPairs;
1042 
1043 
1044     event ExcludeFromFees(address indexed account, bool isExcluded);
1045 
1046     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1047 
1048     event marketingWalletUpdated(
1049         address indexed newWallet,
1050         address indexed oldWallet
1051     );
1052 
1053     event SwapAndLiquify(
1054         uint256 tokensSwapped,
1055         uint256 ethReceived,
1056         uint256 tokensIntoLiquidity
1057     );
1058 
1059     event AutoNukeLP();
1060 
1061     event ManualNukeLP();
1062 
1063     constructor() ERC20("InnitForTheTECH", "INNIT") {
1064         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1065             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1066         );
1067 
1068         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1069         uniswapV2Router = _uniswapV2Router;
1070 
1071         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1072             .createPair(address(this), _uniswapV2Router.WETH());
1073         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1074         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1075 
1076         uint256 _buyMarketingFee = 6;
1077         uint256 _buyLiquidityFee = 6;
1078 
1079         uint256 _sellMarketingFee = 9;
1080         uint256 _sellLiquidityFee = 6;
1081 
1082         uint256 totalSupply = 10_000_000_000 * 1e18;
1083 
1084         maxTransactionAmount = 50_000_001 * 1e18; // 0.5% from total supply maxTransactionAmountTxn
1085         maxWallet = 100_000_001 * 1e18; // 1% from total supply maxWallet
1086         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1087 
1088         buyMarketingFee = _buyMarketingFee;
1089         buyLiquidityFee = _buyLiquidityFee;
1090         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1091 
1092         sellMarketingFee = _sellMarketingFee;
1093         sellLiquidityFee = _sellLiquidityFee;
1094         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1095 
1096         marketingWallet = address(0x5015d21fA9B0B1Df3f8eA96C2fd6d59B455C4dB6); // set as marketing wallet
1097 
1098         // exclude from paying fees or having max transaction amount
1099         excludeFromFees(owner(), true);
1100         excludeFromFees(address(this), true);
1101         excludeFromFees(address(0xdead), true);
1102 
1103         excludeFromMaxTransaction(owner(), true);
1104         excludeFromMaxTransaction(address(this), true);
1105         excludeFromMaxTransaction(address(0xdead), true);
1106 
1107         /*
1108             _mint is an internal function in ERC20.sol that is only called here,
1109             and CANNOT be called ever again
1110         */
1111         _mint(msg.sender, totalSupply);
1112     }
1113 
1114     receive() external payable {}
1115 
1116     // once enabled, can never be turned off
1117     function tradeOn() external onlyOwner {
1118         tradingActive = true;
1119         swapEnabled = true;
1120         lastLpBurnTime = block.timestamp;
1121     }
1122 
1123     // remove limits after token is stable
1124     function removeLimits() external onlyOwner returns (bool) {
1125         limitsInEffect = false;
1126         return true;
1127     }
1128 
1129     // disable Transfer delay - cannot be re-enabled
1130     function disableTransferDelay() external onlyOwner returns (bool) {
1131         transferDelayEnabled = false;
1132         return true;
1133     }
1134 
1135     // change the minimum amount of tokens to sell from fees
1136     function updateSwapTokensAtAmount(uint256 newAmount)
1137         external
1138         onlyOwner
1139         returns (bool)
1140     {
1141         require(
1142             newAmount >= (totalSupply() * 1) / 100000,
1143             "Swap amount cannot be lower than 0.001% total supply."
1144         );
1145         require(
1146             newAmount <= (totalSupply() * 5) / 1000,
1147             "Swap amount cannot be higher than 0.5% total supply."
1148         );
1149         swapTokensAtAmount = newAmount;
1150         return true;
1151     }
1152 
1153     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1154         require(
1155             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1156             "Cannot set maxTransactionAmount lower than 0.1%"
1157         );
1158         maxTransactionAmount = newNum * (10**18);
1159     }
1160 
1161     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1162         require(
1163             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1164             "Cannot set maxWallet lower than 0.5%"
1165         );
1166         maxWallet = newNum * (10**18);
1167     }
1168 
1169     function excludeFromMaxTransaction(address updAds, bool isEx)
1170         public
1171         onlyOwner
1172     {
1173         _isExcludedMaxTransactionAmount[updAds] = isEx;
1174     }
1175 
1176     // only use to disable contract sales if absolutely necessary (emergency use only)
1177     function updateSwapEnabled(bool enabled) external onlyOwner {
1178         swapEnabled = enabled;
1179     }
1180 
1181     function updateBuyFees(
1182         uint256 _marketingFee,
1183         uint256 _liquidityFee
1184     ) external onlyOwner {
1185         buyMarketingFee = _marketingFee;
1186         buyLiquidityFee = _liquidityFee;
1187         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1188         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1189     }
1190 
1191     function updateSellFees(
1192         uint256 _marketingFee,
1193         uint256 _liquidityFee
1194     ) external onlyOwner {
1195         sellMarketingFee = _marketingFee;
1196         sellLiquidityFee = _liquidityFee;
1197         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1198         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1199     }
1200 
1201     function excludeFromFees(address account, bool excluded) public onlyOwner {
1202         _isExcludedFromFees[account] = excluded;
1203         emit ExcludeFromFees(account, excluded);
1204     }
1205 
1206     function setAutomatedMarketMakerPair(address pair, bool value)
1207         public
1208         onlyOwner
1209     {
1210         require(
1211             pair != uniswapV2Pair,
1212             "The pair cannot be removed from automatedMarketMakerPairs"
1213         );
1214 
1215         _setAutomatedMarketMakerPair(pair, value);
1216     }
1217 
1218     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1219         automatedMarketMakerPairs[pair] = value;
1220 
1221         emit SetAutomatedMarketMakerPair(pair, value);
1222     }
1223 
1224     function updateMarketingWallet(address newMarketingWallet)
1225         external
1226         onlyOwner
1227     {
1228         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1229         marketingWallet = newMarketingWallet;
1230     }
1231 
1232     function isExcludedFromFees(address account) public view returns (bool) {
1233         return _isExcludedFromFees[account];
1234     }
1235 
1236     function _transfer(
1237         address from,
1238         address to,
1239         uint256 amount
1240     ) internal override {
1241         require(from != address(0), "ERC20: transfer from the zero address");
1242         require(to != address(0), "ERC20: transfer to the zero address");
1243         require(amount > 0, "Transfer amount must be greater than zero");
1244 
1245         if (limitsInEffect) {
1246             if (
1247                 from != owner() &&
1248                 to != owner() &&
1249                 to != address(0xdead) &&
1250                 !swapping
1251             ) {
1252                 if (!tradingActive) {
1253                     require(
1254                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1255                         "Trading is not active."
1256                     );
1257                 }
1258 
1259                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1260                 if (transferDelayEnabled) {
1261                     if (
1262                         to != owner() &&
1263                         to != address(uniswapV2Router) &&
1264                         to != address(uniswapV2Pair)
1265                     ) {
1266                         require(
1267                             _holderLastTransferTimestamp[tx.origin] <
1268                                 block.number,
1269                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1270                         );
1271                         _holderLastTransferTimestamp[tx.origin] = block.number;
1272                     }
1273                 }
1274 
1275                 //when buy
1276                 if (
1277                     automatedMarketMakerPairs[from] &&
1278                     !_isExcludedMaxTransactionAmount[to]
1279                 ) {
1280                     require(
1281                         amount <= maxTransactionAmount,
1282                         "Buy transfer amount exceeds the maxTransactionAmount."
1283                     );
1284                     require(
1285                         amount + balanceOf(to) <= maxWallet,
1286                         "Max wallet exceeded"
1287                     );
1288                 }
1289                 //when sell
1290                 else if (
1291                     automatedMarketMakerPairs[to] &&
1292                     !_isExcludedMaxTransactionAmount[from]
1293                 ) {
1294                     require(
1295                         amount <= maxTransactionAmount,
1296                         "Sell transfer amount exceeds the maxTransactionAmount."
1297                     );
1298                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1299                     require(
1300                         amount + balanceOf(to) <= maxWallet,
1301                         "Max wallet exceeded"
1302                     );
1303                 }
1304             }
1305         }
1306 
1307         uint256 contractTokenBalance = balanceOf(address(this));
1308 
1309         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1310 
1311         if (
1312             canSwap &&
1313             swapEnabled &&
1314             !swapping &&
1315             !automatedMarketMakerPairs[from] &&
1316             !_isExcludedFromFees[from] &&
1317             !_isExcludedFromFees[to]
1318         ) {
1319             swapping = true;
1320 
1321             swapBack();
1322 
1323             swapping = false;
1324         }
1325 
1326         if (
1327             !swapping &&
1328             automatedMarketMakerPairs[to] &&
1329             lpBurnEnabled &&
1330             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1331             !_isExcludedFromFees[from]
1332         ) {
1333             autoBurnLiquidityPairTokens();
1334         }
1335 
1336         bool takeFee = !swapping;
1337 
1338         // if any account belongs to _isExcludedFromFee account then remove the fee
1339         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1340             takeFee = false;
1341         }
1342 
1343         uint256 fees = 0;
1344         // only take fees on buys/sells, do not take on wallet transfers
1345         if (takeFee) {
1346             // on sell
1347             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1348                 fees = amount.mul(sellTotalFees).div(100);
1349                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1350                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1351             }
1352             // on buy
1353             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1354                 fees = amount.mul(buyTotalFees).div(100);
1355                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1356                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1357             }
1358 
1359             if (fees > 0) {
1360                 super._transfer(from, address(this), fees);
1361             }
1362 
1363             amount -= fees;
1364         }
1365 
1366         super._transfer(from, to, amount);
1367     }
1368 
1369     function swapTokensForEth(uint256 tokenAmount) private {
1370         // generate the uniswap pair path of token -> weth
1371         address[] memory path = new address[](2);
1372         path[0] = address(this);
1373         path[1] = uniswapV2Router.WETH();
1374 
1375         _approve(address(this), address(uniswapV2Router), tokenAmount);
1376 
1377         // make the swap
1378         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1379             tokenAmount,
1380             0, // accept any amount of ETH
1381             path,
1382             address(this),
1383             block.timestamp
1384         );
1385     }
1386 
1387     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1388         // approve token transfer to cover all possible scenarios
1389         _approve(address(this), address(uniswapV2Router), tokenAmount);
1390 
1391         // add the liquidity
1392         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1393             address(this),
1394             tokenAmount,
1395             0, // slippage is unavoidable
1396             0, // slippage is unavoidable
1397             deadAddress,
1398             block.timestamp
1399         );
1400     }
1401 
1402     function swapBack() private {
1403         uint256 contractBalance = balanceOf(address(this));
1404         uint256 totalTokensToSwap = tokensForLiquidity +
1405             tokensForMarketing;
1406         bool success;
1407 
1408         if (contractBalance == 0 || totalTokensToSwap == 0) {
1409             return;
1410         }
1411 
1412         if (contractBalance > swapTokensAtAmount * 20) {
1413             contractBalance = swapTokensAtAmount * 20;
1414         }
1415 
1416         // Halve the amount of liquidity tokens
1417         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1418             totalTokensToSwap /
1419             2;
1420         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1421 
1422         uint256 initialETHBalance = address(this).balance;
1423 
1424         swapTokensForEth(amountToSwapForETH);
1425 
1426         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1427 
1428         uint256 totalTokensSwappedForEth = totalTokensToSwap.sub(tokensForLiquidity.div(2));
1429 
1430         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensSwappedForEth);
1431 
1432         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1433 
1434         tokensForLiquidity = 0;
1435         tokensForMarketing = 0;
1436 
1437         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1438             addLiquidity(liquidityTokens, ethForLiquidity);
1439             emit SwapAndLiquify(
1440                 amountToSwapForETH,
1441                 ethForLiquidity,
1442                 liquidityTokens
1443             );
1444         }
1445 
1446         (success, ) = address(marketingWallet).call{
1447         value: address(this).balance
1448         }("");
1449     }
1450 
1451     function setAutoLPBurnSettings(
1452         uint256 _frequencyInSeconds,
1453         uint256 _percent,
1454         bool _Enabled
1455     ) external onlyOwner {
1456         require(
1457             _frequencyInSeconds >= 600,
1458             "cannot set buyback more often than every 10 minutes"
1459         );
1460         require(
1461             _percent <= 1000 && _percent >= 0,
1462             "Must set auto LP burn percent between 0% and 10%"
1463         );
1464         lpBurnFrequency = _frequencyInSeconds;
1465         percentForLPBurn = _percent;
1466         lpBurnEnabled = _Enabled;
1467     }
1468 
1469     function autoBurnLiquidityPairTokens() internal returns (bool) {
1470         lastLpBurnTime = block.timestamp;
1471 
1472         // get balance of liquidity pair
1473         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1474 
1475         // calculate amount to burn
1476         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1477             10000
1478         );
1479 
1480         // pull tokens from uniswapV2Pair liquidity and move to dead address permanently
1481         if (amountToBurn > 0) {
1482             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1483         }
1484 
1485         //sync price since this is not in a swap transaction!
1486         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1487         pair.sync();
1488         emit AutoNukeLP();
1489         return true;
1490     }
1491 
1492     function manualBurnLiquidityPairTokens(uint256 percent)
1493         external
1494         onlyOwner
1495         returns (bool)
1496     {
1497         require(
1498             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1499             "Must wait for cooldown to finish"
1500         );
1501         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1502         lastManualLpBurnTime = block.timestamp;
1503 
1504         // get balance of liquidity pair
1505         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1506 
1507         // calculate amount to burn
1508         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1509 
1510         // pull tokens from uniswapV2Pair liquidity and move to dead address permanently
1511         if (amountToBurn > 0) {
1512             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1513         }
1514 
1515         //sync price since this is not in a swap transaction!
1516         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1517         pair.sync();
1518         emit ManualNukeLP();
1519         return true;
1520     }
1521 }
