1 // File: erc-20.sol
2 
3 /**
4 
5 */
6 
7 pragma solidity ^0.8.10;
8 pragma experimental ABIEncoderV2;
9 
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 /* pragma solidity ^0.8.0; */
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
26 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
27 
28 /* pragma solidity ^0.8.0; */
29 
30 /* import "../utils/Context.sol"; */
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
103 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
104 
105 /* pragma solidity ^0.8.0; */
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
186 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
187 
188 /* pragma solidity ^0.8.0; */
189 
190 /* import "../IERC20.sol"; */
191 
192 /**
193  * @dev Interface for the optional metadata functions from the ERC20 standard.
194  *
195  * _Available since v4.1._
196  */
197 interface IERC20Metadata is IERC20 {
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the symbol of the token.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the decimals places of the token.
210      */
211     function decimals() external view returns (uint8);
212 }
213 
214 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
216 
217 /* pragma solidity ^0.8.0; */
218 
219 /* import "./IERC20.sol"; */
220 /* import "./extensions/IERC20Metadata.sol"; */
221 /* import "../../utils/Context.sol"; */
222 
223 /**
224  * @dev Implementation of the {IERC20} interface.
225  *
226  * This implementation is agnostic to the way tokens are created. This means
227  * that a supply mechanism has to be added in a derived contract using {_mint}.
228  * For a generic mechanism see {ERC20PresetMinterPauser}.
229  *
230  * TIP: For a detailed writeup see our guide
231  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
232  * to implement supply mechanisms].
233  *
234  * We have followed general OpenZeppelin Contracts guidelines: functions revert
235  * instead returning `false` on failure. This behavior is nonetheless
236  * conventional and does not conflict with the expectations of ERC20
237  * applications.
238  *
239  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
240  * This allows applications to reconstruct the allowance for all accounts just
241  * by listening to said events. Other implementations of the EIP may not emit
242  * these events, as it isn't required by the specification.
243  *
244  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
245  * functions have been added to mitigate the well-known issues around setting
246  * allowances. See {IERC20-approve}.
247  */
248 contract ERC20 is Context, IERC20, IERC20Metadata {
249     mapping(address => uint256) private _balances;
250 
251     mapping(address => mapping(address => uint256)) private _allowances;
252 
253     uint256 private _totalSupply;
254 
255     string private _name;
256     string private _symbol;
257 
258     /**
259      * @dev Sets the values for {name} and {symbol}.
260      *
261      * The default value of {decimals} is 18. To select a different value for
262      * {decimals} you should overload it.
263      *
264      * All two of these values are immutable: they can only be set once during
265      * construction.
266      */
267     constructor(string memory name_, string memory symbol_) {
268         _name = name_;
269         _symbol = symbol_;
270     }
271 
272     /**
273      * @dev Returns the name of the token.
274      */
275     function name() public view virtual override returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @dev Returns the symbol of the token, usually a shorter version of the
281      * name.
282      */
283     function symbol() public view virtual override returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @dev Returns the number of decimals used to get its user representation.
289      * For example, if `decimals` equals `2`, a balance of `505` tokens should
290      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
291      *
292      * Tokens usually opt for a value of 18, imitating the relationship between
293      * Ether and Wei. This is the value {ERC20} uses, unless this function is
294      * overridden;
295      *
296      * NOTE: This information is only used for _display_ purposes: it in
297      * no way affects any of the arithmetic of the contract, including
298      * {IERC20-balanceOf} and {IERC20-transfer}.
299      */
300     function decimals() public view virtual override returns (uint8) {
301         return 18;
302     }
303 
304     /**
305      * @dev See {IERC20-totalSupply}.
306      */
307     function totalSupply() public view virtual override returns (uint256) {
308         return _totalSupply;
309     }
310 
311     /**
312      * @dev See {IERC20-balanceOf}.
313      */
314     function balanceOf(address account) public view virtual override returns (uint256) {
315         return _balances[account];
316     }
317 
318     /**
319      * @dev See {IERC20-transfer}.
320      *
321      * Requirements:
322      *
323      * - `recipient` cannot be the zero address.
324      * - the caller must have a balance of at least `amount`.
325      */
326     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
327         _transfer(_msgSender(), recipient, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-allowance}.
333      */
334     function allowance(address owner, address spender) public view virtual override returns (uint256) {
335         return _allowances[owner][spender];
336     }
337 
338     /**
339      * @dev See {IERC20-approve}.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount) public virtual override returns (bool) {
346         _approve(_msgSender(), spender, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-transferFrom}.
352      *
353      * Emits an {Approval} event indicating the updated allowance. This is not
354      * required by the EIP. See the note at the beginning of {ERC20}.
355      *
356      * Requirements:
357      *
358      * - `sender` and `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      * - the caller must have allowance for ``sender``'s tokens of at least
361      * `amount`.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) public virtual override returns (bool) {
368         _transfer(sender, recipient, amount);
369 
370         uint256 currentAllowance = _allowances[sender][_msgSender()];
371         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
372         unchecked {
373             _approve(sender, _msgSender(), currentAllowance - amount);
374         }
375 
376         return true;
377     }
378 
379     /**
380      * @dev Moves `amount` of tokens from `sender` to `recipient`.
381      *
382      * This internal function is equivalent to {transfer}, and can be used to
383      * e.g. implement automatic token fees, slashing mechanisms, etc.
384      *
385      * Emits a {Transfer} event.
386      *
387      * Requirements:
388      *
389      * - `sender` cannot be the zero address.
390      * - `recipient` cannot be the zero address.
391      * - `sender` must have a balance of at least `amount`.
392      */
393     function _transfer(
394         address sender,
395         address recipient,
396         uint256 amount
397     ) internal virtual {
398         require(sender != address(0), "ERC20: transfer from the zero address");
399         require(recipient != address(0), "ERC20: transfer to the zero address");
400 
401         _beforeTokenTransfer(sender, recipient, amount);
402 
403         uint256 senderBalance = _balances[sender];
404         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
405         unchecked {
406             _balances[sender] = senderBalance - amount;
407         }
408         _balances[recipient] += amount;
409 
410         emit Transfer(sender, recipient, amount);
411 
412         _afterTokenTransfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _beforeTokenTransfer(address(0), account, amount);
428 
429         _totalSupply += amount;
430         _balances[account] += amount;
431         emit Transfer(address(0), account, amount);
432 
433         _afterTokenTransfer(address(0), account, amount);
434     }
435 
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 
482     /**
483      * @dev Hook that is called after any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * has been transferred to `to`.
490      * - when `from` is zero, `amount` tokens have been minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _afterTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 }
502 
503 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
504 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
505 
506 /* pragma solidity ^0.8.0; */
507 
508 // CAUTION
509 // This version of SafeMath should only be used with Solidity 0.8 or later,
510 // because it relies on the compiler's built in overflow checks.
511 
512 /**
513  * @dev Wrappers over Solidity's arithmetic operations.
514  *
515  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
516  * now has built in overflow checking.
517  */
518 library SafeMath {
519     /**
520      * @dev Returns the addition of two unsigned integers, with an overflow flag.
521      *
522      * _Available since v3.4._
523      */
524     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
525         unchecked {
526             uint256 c = a + b;
527             if (c < a) return (false, 0);
528             return (true, c);
529         }
530     }
531 
532     /**
533      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
534      *
535      * _Available since v3.4._
536      */
537     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
538         unchecked {
539             if (b > a) return (false, 0);
540             return (true, a - b);
541         }
542     }
543 
544     /**
545      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
546      *
547      * _Available since v3.4._
548      */
549     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
550         unchecked {
551             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
552             // benefit is lost if 'b' is also tested.
553             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
554             if (a == 0) return (true, 0);
555             uint256 c = a * b;
556             if (c / a != b) return (false, 0);
557             return (true, c);
558         }
559     }
560 
561     /**
562      * @dev Returns the division of two unsigned integers, with a division by zero flag.
563      *
564      * _Available since v3.4._
565      */
566     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             if (b == 0) return (false, 0);
569             return (true, a / b);
570         }
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             if (b == 0) return (false, 0);
581             return (true, a % b);
582         }
583     }
584 
585     /**
586      * @dev Returns the addition of two unsigned integers, reverting on
587      * overflow.
588      *
589      * Counterpart to Solidity's `+` operator.
590      *
591      * Requirements:
592      *
593      * - Addition cannot overflow.
594      */
595     function add(uint256 a, uint256 b) internal pure returns (uint256) {
596         return a + b;
597     }
598 
599     /**
600      * @dev Returns the subtraction of two unsigned integers, reverting on
601      * overflow (when the result is negative).
602      *
603      * Counterpart to Solidity's `-` operator.
604      *
605      * Requirements:
606      *
607      * - Subtraction cannot overflow.
608      */
609     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a - b;
611     }
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, reverting on
615      * overflow.
616      *
617      * Counterpart to Solidity's `*` operator.
618      *
619      * Requirements:
620      *
621      * - Multiplication cannot overflow.
622      */
623     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a * b;
625     }
626 
627     /**
628      * @dev Returns the integer division of two unsigned integers, reverting on
629      * division by zero. The result is rounded towards zero.
630      *
631      * Counterpart to Solidity's `/` operator.
632      *
633      * Requirements:
634      *
635      * - The divisor cannot be zero.
636      */
637     function div(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a / b;
639     }
640 
641     /**
642      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
643      * reverting when dividing by zero.
644      *
645      * Counterpart to Solidity's `%` operator. This function uses a `revert`
646      * opcode (which leaves remaining gas untouched) while Solidity uses an
647      * invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a % b;
655     }
656 
657     /**
658      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
659      * overflow (when the result is negative).
660      *
661      * CAUTION: This function is deprecated because it requires allocating memory for the error
662      * message unnecessarily. For custom revert reasons use {trySub}.
663      *
664      * Counterpart to Solidity's `-` operator.
665      *
666      * Requirements:
667      *
668      * - Subtraction cannot overflow.
669      */
670     function sub(
671         uint256 a,
672         uint256 b,
673         string memory errorMessage
674     ) internal pure returns (uint256) {
675         unchecked {
676             require(b <= a, errorMessage);
677             return a - b;
678         }
679     }
680 
681     /**
682      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
683      * division by zero. The result is rounded towards zero.
684      *
685      * Counterpart to Solidity's `/` operator. Note: this function uses a
686      * `revert` opcode (which leaves remaining gas untouched) while Solidity
687      * uses an invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function div(
694         uint256 a,
695         uint256 b,
696         string memory errorMessage
697     ) internal pure returns (uint256) {
698         unchecked {
699             require(b > 0, errorMessage);
700             return a / b;
701         }
702     }
703 
704     /**
705      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
706      * reverting with custom message when dividing by zero.
707      *
708      * CAUTION: This function is deprecated because it requires allocating memory for the error
709      * message unnecessarily. For custom revert reasons use {tryMod}.
710      *
711      * Counterpart to Solidity's `%` operator. This function uses a `revert`
712      * opcode (which leaves remaining gas untouched) while Solidity uses an
713      * invalid opcode to revert (consuming all remaining gas).
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function mod(
720         uint256 a,
721         uint256 b,
722         string memory errorMessage
723     ) internal pure returns (uint256) {
724         unchecked {
725             require(b > 0, errorMessage);
726             return a % b;
727         }
728     }
729 }
730 
731 interface IUniswapV2Factory {
732     event PairCreated(
733         address indexed token0,
734         address indexed token1,
735         address pair,
736         uint256
737     );
738 
739     function createPair(address tokenA, address tokenB)
740         external
741         returns (address pair);
742 }
743 
744 interface IUniswapV2Router02 {
745     function factory() external pure returns (address);
746 
747     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
748         uint256 amountIn,
749         uint256 amountOutMin,
750         address[] calldata path,
751         address to,
752         uint256 deadline
753     ) external;
754 }
755 
756 contract TheDragonPearl is ERC20, Ownable {
757     using SafeMath for uint256;
758 
759     IUniswapV2Router02 public immutable uniswapV2Router;
760     address public immutable uniswapV2Pair;
761     address public constant deadAddress = address(0xdead);
762     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
763 
764     bool private swapping;
765 
766     address public devWallet;
767 
768     uint256 public maxTransactionAmount;
769     uint256 public swapTokensAtAmount;
770     uint256 public maxWallet;
771 
772     bool public limitsInEffect = true;
773     bool public tradingActive = false;
774     bool public swapEnabled = false;
775 
776     uint256 public buyTotalFees;
777     uint256 public buyDevFee;
778     uint256 public buyLiquidityFee;
779 
780     uint256 public sellTotalFees;
781     uint256 public sellDevFee;
782     uint256 public sellLiquidityFee;
783 
784     /******************/
785 
786     // exlcude from fees and max transaction amount
787     mapping(address => bool) private _isExcludedFromFees;
788     mapping(address => bool) public _isExcludedMaxTransactionAmount;
789 
790 
791     event ExcludeFromFees(address indexed account, bool isExcluded);
792 
793     event devWalletUpdated(
794         address indexed newWallet,
795         address indexed oldWallet
796     );
797 
798     constructor() ERC20("The Dragon Pearl", "PEARL") {
799         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
800 
801         excludeFromMaxTransaction(address(_uniswapV2Router), true);
802         uniswapV2Router = _uniswapV2Router;
803 
804         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
805             .createPair(address(this), USDC);
806         excludeFromMaxTransaction(address(uniswapV2Pair), true);
807 
808 
809         uint256 _buyDevFee = 1;
810         uint256 _buyLiquidityFee = 1;
811 
812         uint256 _sellDevFee = 2;
813         uint256 _sellLiquidityFee = 0;
814 
815         uint256 totalSupply = 100_000_000_000 * 1e18;
816 
817         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
818         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
819         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
820 
821         buyDevFee = _buyDevFee;
822         buyLiquidityFee = _buyLiquidityFee;
823         buyTotalFees = buyDevFee + buyLiquidityFee;
824 
825         sellDevFee = _sellDevFee;
826         sellLiquidityFee = _sellLiquidityFee;
827         sellTotalFees = sellDevFee + sellLiquidityFee;
828 
829         devWallet = address(0xd669b3325aDf9da25dc7faA3f406Ab6e424aF93c); // set as dev wallet
830 
831         // exclude from paying fees or having max transaction amount
832         excludeFromFees(owner(), true);
833         excludeFromFees(address(this), true);
834         excludeFromFees(address(0xdead), true);
835 
836         excludeFromMaxTransaction(owner(), true);
837         excludeFromMaxTransaction(address(this), true);
838         excludeFromMaxTransaction(address(0xdead), true);
839 
840         /*
841             _mint is an internal function in ERC20.sol that is only called here,
842             and CANNOT be called ever again
843         */
844         _mint(msg.sender, totalSupply);
845     }
846 
847     receive() external payable {}
848 
849     // once enabled, can never be turned off
850     function enableTrading() external onlyOwner {
851         tradingActive = true;
852         swapEnabled = true;
853     }
854 
855     // remove limits after token is stable
856     function removeLimits() external onlyOwner returns (bool) {
857         limitsInEffect = false;
858         return true;
859     }
860 
861     // change the minimum amount of tokens to sell from fees
862     function updateSwapTokensAtAmount(uint256 newAmount)
863         external
864         onlyOwner
865         returns (bool)
866     {
867         require(
868             newAmount >= (totalSupply() * 1) / 100000,
869             "Swap amount cannot be lower than 0.001% total supply."
870         );
871         require(
872             newAmount <= (totalSupply() * 5) / 1000,
873             "Swap amount cannot be higher than 0.5% total supply."
874         );
875         swapTokensAtAmount = newAmount;
876         return true;
877     }
878 
879     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
880         require(
881             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
882             "Cannot set maxTransactionAmount lower than 0.1%"
883         );
884         maxTransactionAmount = newNum * (10**18);
885     }
886 
887     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
888         require(
889             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
890             "Cannot set maxWallet lower than 0.5%"
891         );
892         maxWallet = newNum * (10**18);
893     }
894 
895     function excludeFromMaxTransaction(address updAds, bool isEx)
896         public
897         onlyOwner
898     {
899         _isExcludedMaxTransactionAmount[updAds] = isEx;
900     }
901 
902     // only use to disable contract sales if absolutely necessary (emergency use only)
903     function updateSwapEnabled(bool enabled) external onlyOwner {
904         swapEnabled = enabled;
905     }
906 
907     function updateBuyFees(
908         uint256 _devFee,
909         uint256 _liquidityFee
910     ) external onlyOwner {
911         buyDevFee = _devFee;
912         buyLiquidityFee = _liquidityFee;
913         buyTotalFees = buyDevFee + buyLiquidityFee;
914         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
915     }
916 
917     function updateSellFees(
918         uint256 _devFee,
919         uint256 _liquidityFee
920     ) external onlyOwner {
921         sellDevFee = _devFee;
922         sellLiquidityFee = _liquidityFee;
923         sellTotalFees = sellDevFee + sellLiquidityFee;
924         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
925     }
926 
927     function excludeFromFees(address account, bool excluded) public onlyOwner {
928         _isExcludedFromFees[account] = excluded;
929         emit ExcludeFromFees(account, excluded);
930     }
931 
932     function updateDevWallet(address newDevWallet)
933         external
934         onlyOwner
935     {
936         emit devWalletUpdated(newDevWallet, devWallet);
937         devWallet = newDevWallet;
938     }
939 
940 
941     function isExcludedFromFees(address account) public view returns (bool) {
942         return _isExcludedFromFees[account];
943     }
944 
945     function _transfer(
946         address from,
947         address to,
948         uint256 amount
949     ) internal override {
950         require(from != address(0), "ERC20: transfer from the zero address");
951         require(to != address(0), "ERC20: transfer to the zero address");
952 
953         if (amount == 0) {
954             super._transfer(from, to, 0);
955             return;
956         }
957 
958         if (limitsInEffect) {
959             if (
960                 from != owner() &&
961                 to != owner() &&
962                 to != address(0) &&
963                 to != address(0xdead) &&
964                 !swapping
965             ) {
966                 if (!tradingActive) {
967                     require(
968                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
969                         "Trading is not active."
970                     );
971                 }
972 
973                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
974                 //when buy
975                 if (
976                     from == uniswapV2Pair &&
977                     !_isExcludedMaxTransactionAmount[to]
978                 ) {
979                     require(
980                         amount <= maxTransactionAmount,
981                         "Buy transfer amount exceeds the maxTransactionAmount."
982                     );
983                     require(
984                         amount + balanceOf(to) <= maxWallet,
985                         "Max wallet exceeded"
986                     );
987                 }
988                 else if (!_isExcludedMaxTransactionAmount[to]) {
989                     require(
990                         amount + balanceOf(to) <= maxWallet,
991                         "Max wallet exceeded"
992                     );
993                 }
994             }
995         }
996 
997         uint256 contractTokenBalance = balanceOf(address(this));
998 
999         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1000 
1001         if (
1002             canSwap &&
1003             swapEnabled &&
1004             !swapping &&
1005             to == uniswapV2Pair &&
1006             !_isExcludedFromFees[from] &&
1007             !_isExcludedFromFees[to]
1008         ) {
1009             swapping = true;
1010 
1011             swapBack();
1012 
1013             swapping = false;
1014         }
1015 
1016         bool takeFee = !swapping;
1017 
1018         // if any account belongs to _isExcludedFromFee account then remove the fee
1019         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1020             takeFee = false;
1021         }
1022 
1023         uint256 fees = 0;
1024         uint256 tokensForLiquidity = 0;
1025         uint256 tokensForDev = 0;
1026         // only take fees on buys/sells, do not take on wallet transfers
1027         if (takeFee) {
1028             // on sell
1029             if (to == uniswapV2Pair && sellTotalFees > 0) {
1030                 fees = amount.mul(sellTotalFees).div(100);
1031                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1032                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1033             }
1034             // on buy
1035             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1036                 fees = amount.mul(buyTotalFees).div(100);
1037                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1038                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1039             }
1040 
1041             if (fees> 0) {
1042                 super._transfer(from, address(this), fees);
1043             }
1044             if (tokensForLiquidity > 0) {
1045                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1046             }
1047 
1048             amount -= fees;
1049         }
1050 
1051         super._transfer(from, to, amount);
1052     }
1053 
1054     function swapTokensForUSDC(uint256 tokenAmount) private {
1055         // generate the uniswap pair path of token -> weth
1056         address[] memory path = new address[](2);
1057         path[0] = address(this);
1058         path[1] = USDC;
1059 
1060         _approve(address(this), address(uniswapV2Router), tokenAmount);
1061 
1062         // make the swap
1063         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1064             tokenAmount,
1065             0, // accept any amount of USDC
1066             path,
1067             devWallet,
1068             block.timestamp
1069         );
1070     }
1071 
1072     function swapBack() private {
1073         uint256 contractBalance = balanceOf(address(this));
1074         if (contractBalance == 0) {
1075             return;
1076         }
1077 
1078         if (contractBalance > swapTokensAtAmount * 20) {
1079             contractBalance = swapTokensAtAmount * 20;
1080         }
1081 
1082         swapTokensForUSDC(contractBalance);
1083     }
1084 
1085 }