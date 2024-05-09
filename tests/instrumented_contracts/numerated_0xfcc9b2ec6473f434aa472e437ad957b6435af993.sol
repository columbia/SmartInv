1 //https://t.me/HalfBoneERC
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     /**
27      * @dev Returns the address of the current owner.
28      */
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     /**
42      * @dev Leaves the contract without owner. It will not be possible to call
43      * `onlyOwner` functions anymore. Can only be called by the current owner.
44      *
45      * NOTE: Renouncing ownership will leave the contract without an owner,
46      * thereby removing any functionality that is only available to the owner.
47      */
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52     /**
53      * @dev Transfers ownership of the contract to a new account (`newOwner`).
54      * Can only be called by the current owner.
55      */
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _transferOwnership(newOwner);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Internal function without access restriction.
64      */
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
73 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
74 
75 /* pragma solidity ^0.8.0; */
76 
77 /**
78  * @dev Interface of the ERC20 standard as defined in the EIP.
79  */
80 interface IERC20 {
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90 
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `recipient`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Returns the remaining number of tokens that `spender` will be
102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
103      * zero by default.
104      *
105      * This value changes when {approve} or {transferFrom} are called.
106      */
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     /**
110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
115      * that someone may use both the old and the new allowance by unfortunate
116      * transaction ordering. One possible solution to mitigate this race
117      * condition is to first reduce the spender's allowance to 0 and set the
118      * desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address spender, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Moves `amount` tokens from `sender` to `recipient` using the
127      * allowance mechanism. `amount` is then deducted from the caller's
128      * allowance.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) external returns (bool);
139 
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
156 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
157 
158 /* pragma solidity ^0.8.0; */
159 
160 /* import "../IERC20.sol"; */
161 
162 /**
163  * @dev Interface for the optional metadata functions from the ERC20 standard.
164  *
165  * _Available since v4.1._
166  */
167 interface IERC20Metadata is IERC20 {
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() external view returns (string memory);
172 
173     /**
174      * @dev Returns the symbol of the token.
175      */
176     function symbol() external view returns (string memory);
177 
178     /**
179      * @dev Returns the decimals places of the token.
180      */
181     function decimals() external view returns (uint8);
182 }
183 
184 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
185 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
186 
187 /* pragma solidity ^0.8.0; */
188 
189 /* import "./IERC20.sol"; */
190 /* import "./extensions/IERC20Metadata.sol"; */
191 /* import "../../utils/Context.sol"; */
192 
193 /**
194  * @dev Implementation of the {IERC20} interface.
195  *
196  * This implementation is agnostic to the way tokens are created. This means
197  * that a supply mechanism has to be added in a derived contract using {_mint}.
198  * For a generic mechanism see {ERC20PresetMinterPauser}.
199  *
200  * TIP: For a detailed writeup see our guide
201  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
202  * to implement supply mechanisms].
203  *
204  * We have followed general OpenZeppelin Contracts guidelines: functions revert
205  * instead returning `false` on failure. This behavior is nonetheless
206  * conventional and does not conflict with the expectations of ERC20
207  * applications.
208  *
209  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
210  * This allows applications to reconstruct the allowance for all accounts just
211  * by listening to said events. Other implementations of the EIP may not emit
212  * these events, as it isn't required by the specification.
213  *
214  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
215  * functions have been added to mitigate the well-known issues around setting
216  * allowances. See {IERC20-approve}.
217  */
218 contract ERC20 is Context, IERC20, IERC20Metadata {
219     mapping(address => uint256) private _balances;
220 
221     mapping(address => mapping(address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     string private _name;
226     string private _symbol;
227 
228     /**
229      * @dev Sets the values for {name} and {symbol}.
230      *
231      * The default value of {decimals} is 18. To select a different value for
232      * {decimals} you should overload it.
233      *
234      * All two of these values are immutable: they can only be set once during
235      * construction.
236      */
237     constructor(string memory name_, string memory symbol_) {
238         _name = name_;
239         _symbol = symbol_;
240     }
241 
242     /**
243      * @dev Returns the name of the token.
244      */
245     function name() public view virtual override returns (string memory) {
246         return _name;
247     }
248 
249     /**
250      * @dev Returns the symbol of the token, usually a shorter version of the
251      * name.
252      */
253     function symbol() public view virtual override returns (string memory) {
254         return _symbol;
255     }
256 
257     /**
258      * @dev Returns the number of decimals used to get its user representation.
259      * For example, if `decimals` equals `2`, a balance of `505` tokens should
260      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
261      *
262      * Tokens usually opt for a value of 18, imitating the relationship between
263      * Ether and Wei. This is the value {ERC20} uses, unless this function is
264      * overridden;
265      *
266      * NOTE: This information is only used for _display_ purposes: it in
267      * no way affects any of the arithmetic of the contract, including
268      * {IERC20-balanceOf} and {IERC20-transfer}.
269      */
270     function decimals() public view virtual override returns (uint8) {
271         return 18;
272     }
273 
274     /**
275      * @dev See {IERC20-totalSupply}.
276      */
277     function totalSupply() public view virtual override returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See {IERC20-balanceOf}.
283      */
284     function balanceOf(address account) public view virtual override returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See {IERC20-transfer}.
290      *
291      * Requirements:
292      *
293      * - `recipient` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-allowance}.
303      */
304     function allowance(address owner, address spender) public view virtual override returns (uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     /**
309      * @dev See {IERC20-approve}.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function approve(address spender, uint256 amount) public virtual override returns (bool) {
316         _approve(_msgSender(), spender, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-transferFrom}.
322      *
323      * Emits an {Approval} event indicating the updated allowance. This is not
324      * required by the EIP. See the note at the beginning of {ERC20}.
325      *
326      * Requirements:
327      *
328      * - `sender` and `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      * - the caller must have allowance for ``sender``'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(
334         address sender,
335         address recipient,
336         uint256 amount
337     ) public virtual override returns (bool) {
338         _transfer(sender, recipient, amount);
339 
340         uint256 currentAllowance = _allowances[sender][_msgSender()];
341         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
342         unchecked {
343             _approve(sender, _msgSender(), currentAllowance - amount);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 
452     /**
453      * @dev Hook that is called after any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * has been transferred to `to`.
460      * - when `from` is zero, `amount` tokens have been minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _afterTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 }
472 
473 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
474 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
475 
476 /* pragma solidity ^0.8.0; */
477 
478 // CAUTION
479 // This version of SafeMath should only be used with Solidity 0.8 or later,
480 // because it relies on the compiler's built in overflow checks.
481 
482 /**
483  * @dev Wrappers over Solidity's arithmetic operations.
484  *
485  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
486  * now has built in overflow checking.
487  */
488 library SafeMath {
489     /**
490      * @dev Returns the addition of two unsigned integers, with an overflow flag.
491      *
492      * _Available since v3.4._
493      */
494     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
495         unchecked {
496             uint256 c = a + b;
497             if (c < a) return (false, 0);
498             return (true, c);
499         }
500     }
501 
502     /**
503      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
504      *
505      * _Available since v3.4._
506      */
507     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
508         unchecked {
509             if (b > a) return (false, 0);
510             return (true, a - b);
511         }
512     }
513 
514     /**
515      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
516      *
517      * _Available since v3.4._
518      */
519     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
520         unchecked {
521             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522             // benefit is lost if 'b' is also tested.
523             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524             if (a == 0) return (true, 0);
525             uint256 c = a * b;
526             if (c / a != b) return (false, 0);
527             return (true, c);
528         }
529     }
530 
531     /**
532      * @dev Returns the division of two unsigned integers, with a division by zero flag.
533      *
534      * _Available since v3.4._
535      */
536     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
537         unchecked {
538             if (b == 0) return (false, 0);
539             return (true, a / b);
540         }
541     }
542 
543     /**
544      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
545      *
546      * _Available since v3.4._
547      */
548     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
549         unchecked {
550             if (b == 0) return (false, 0);
551             return (true, a % b);
552         }
553     }
554 
555     /**
556      * @dev Returns the addition of two unsigned integers, reverting on
557      * overflow.
558      *
559      * Counterpart to Solidity's `+` operator.
560      *
561      * Requirements:
562      *
563      * - Addition cannot overflow.
564      */
565     function add(uint256 a, uint256 b) internal pure returns (uint256) {
566         return a + b;
567     }
568 
569     /**
570      * @dev Returns the subtraction of two unsigned integers, reverting on
571      * overflow (when the result is negative).
572      *
573      * Counterpart to Solidity's `-` operator.
574      *
575      * Requirements:
576      *
577      * - Subtraction cannot overflow.
578      */
579     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a - b;
581     }
582 
583     /**
584      * @dev Returns the multiplication of two unsigned integers, reverting on
585      * overflow.
586      *
587      * Counterpart to Solidity's `*` operator.
588      *
589      * Requirements:
590      *
591      * - Multiplication cannot overflow.
592      */
593     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a * b;
595     }
596 
597     /**
598      * @dev Returns the integer division of two unsigned integers, reverting on
599      * division by zero. The result is rounded towards zero.
600      *
601      * Counterpart to Solidity's `/` operator.
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function div(uint256 a, uint256 b) internal pure returns (uint256) {
608         return a / b;
609     }
610 
611     /**
612      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
613      * reverting when dividing by zero.
614      *
615      * Counterpart to Solidity's `%` operator. This function uses a `revert`
616      * opcode (which leaves remaining gas untouched) while Solidity uses an
617      * invalid opcode to revert (consuming all remaining gas).
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a % b;
625     }
626 
627     /**
628      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
629      * overflow (when the result is negative).
630      *
631      * CAUTION: This function is deprecated because it requires allocating memory for the error
632      * message unnecessarily. For custom revert reasons use {trySub}.
633      *
634      * Counterpart to Solidity's `-` operator.
635      *
636      * Requirements:
637      *
638      * - Subtraction cannot overflow.
639      */
640     function sub(
641         uint256 a,
642         uint256 b,
643         string memory errorMessage
644     ) internal pure returns (uint256) {
645         unchecked {
646             require(b <= a, errorMessage);
647             return a - b;
648         }
649     }
650 
651     /**
652      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
653      * division by zero. The result is rounded towards zero.
654      *
655      * Counterpart to Solidity's `/` operator. Note: this function uses a
656      * `revert` opcode (which leaves remaining gas untouched) while Solidity
657      * uses an invalid opcode to revert (consuming all remaining gas).
658      *
659      * Requirements:
660      *
661      * - The divisor cannot be zero.
662      */
663     function div(
664         uint256 a,
665         uint256 b,
666         string memory errorMessage
667     ) internal pure returns (uint256) {
668         unchecked {
669             require(b > 0, errorMessage);
670             return a / b;
671         }
672     }
673 
674     /**
675      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
676      * reverting with custom message when dividing by zero.
677      *
678      * CAUTION: This function is deprecated because it requires allocating memory for the error
679      * message unnecessarily. For custom revert reasons use {tryMod}.
680      *
681      * Counterpart to Solidity's `%` operator. This function uses a `revert`
682      * opcode (which leaves remaining gas untouched) while Solidity uses an
683      * invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      *
687      * - The divisor cannot be zero.
688      */
689     function mod(
690         uint256 a,
691         uint256 b,
692         string memory errorMessage
693     ) internal pure returns (uint256) {
694         unchecked {
695             require(b > 0, errorMessage);
696             return a % b;
697         }
698     }
699 }
700 
701 interface IUniswapV2Factory {
702     event PairCreated(
703         address indexed token0,
704         address indexed token1,
705         address pair,
706         uint256
707     );
708 
709     function createPair(address tokenA, address tokenB)
710         external
711         returns (address pair);
712 }
713 
714 interface IUniswapV2Router02 {
715     function factory() external pure returns (address);
716 
717     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
718         uint256 amountIn,
719         uint256 amountOutMin,
720         address[] calldata path,
721         address to,
722         uint256 deadline
723     ) external;
724 }
725 
726 contract HalfBone is ERC20, Ownable {
727     using SafeMath for uint256;
728 
729     IUniswapV2Router02 public immutable uniswapV2Router;
730     address public immutable uniswapV2Pair;
731     address public constant deadAddress = address(0xdead);
732     address public BONE = 0x9813037ee2218799597d83D4a5B6F3b6778218d9;
733 
734     bool private swapping;
735 
736     address public devWallet;
737 
738     uint256 public maxTransactionAmount;
739     uint256 public swapTokensAtAmount;
740     uint256 public maxWallet;
741 
742     bool public limitsInEffect = true;
743     bool public tradingActive = false;
744     bool public swapEnabled = true;
745 
746     uint256 public buyTotalFees;
747     uint256 public buyDevFee;
748     uint256 public buyLiquidityFee;
749 
750     uint256 public sellTotalFees;
751     uint256 public sellDevFee;
752     uint256 public sellLiquidityFee;
753 
754     /******************/
755 
756     // exlcude from fees and max transaction amount
757     mapping(address => bool) private _isExcludedFromFees;
758     mapping(address => bool) public _isExcludedMaxTransactionAmount;
759 
760 
761     event ExcludeFromFees(address indexed account, bool isExcluded);
762 
763     event devWalletUpdated(
764         address indexed newWallet,
765         address indexed oldWallet
766     );
767 
768     constructor() ERC20("Half Bone", "BONE0.5") {
769         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
770 
771         excludeFromMaxTransaction(address(_uniswapV2Router), true);
772         uniswapV2Router = _uniswapV2Router;
773 
774         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
775             .createPair(address(this), BONE);
776         excludeFromMaxTransaction(address(uniswapV2Pair), true);
777 
778 
779         uint256 _buyDevFee = 20;
780         uint256 _buyLiquidityFee = 0;
781 
782         uint256 _sellDevFee = 20;
783         uint256 _sellLiquidityFee = 0;
784 
785         uint256 totalSupply = 1_000_000 * 1e18;
786 
787         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
788         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
789         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
790 
791         buyDevFee = _buyDevFee;
792         buyLiquidityFee = _buyLiquidityFee;
793         buyTotalFees = buyDevFee + buyLiquidityFee;
794 
795         sellDevFee = _sellDevFee;
796         sellLiquidityFee = _sellLiquidityFee;
797         sellTotalFees = sellDevFee + sellLiquidityFee;
798 
799         devWallet = address(0x4F8127BA5b1CE8520531B28bE2f3c9E9941AC5b5); 
800 
801         // exclude from paying fees or having max transaction amount
802         excludeFromFees(owner(), true);
803         excludeFromFees(address(this), true);
804         excludeFromFees(address(0xdead), true);
805 
806         excludeFromMaxTransaction(owner(), true);
807         excludeFromMaxTransaction(address(this), true);
808         excludeFromMaxTransaction(address(0xdead), true);
809 
810         /*
811             _mint is an internal function in ERC20.sol that is only called here,
812             and CANNOT be called ever again
813         */
814         _mint(msg.sender, totalSupply);
815     }
816 
817     receive() external payable {}
818 
819     // once enabled, can never be turned off
820     function enableTrading() external onlyOwner {
821         tradingActive = true;
822         swapEnabled = true;
823     }
824 
825     // remove limits after token is stable
826     function removeLimits() external onlyOwner returns (bool) {
827         limitsInEffect = false;
828         return true;
829     }
830 
831     // change the minimum amount of tokens to sell from fees
832     function updateSwapTokensAtAmount(uint256 newAmount)
833         external
834         onlyOwner
835         returns (bool)
836     {
837         require(
838             newAmount >= (totalSupply() * 1) / 100000,
839             "Swap amount cannot be lower than 0.001% total supply."
840         );
841         require(
842             newAmount <= (totalSupply() * 5) / 1000,
843             "Swap amount cannot be higher than 0.5% total supply."
844         );
845         swapTokensAtAmount = newAmount;
846         return true;
847     }
848 
849     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
850         require(
851             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
852             "Cannot set maxTransactionAmount lower than 0.1%"
853         );
854         maxTransactionAmount = newNum * (10**18);
855     }
856 
857     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
858         require(
859             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
860             "Cannot set maxWallet lower than 0.5%"
861         );
862         maxWallet = newNum * (10**18);
863     }
864 
865     function excludeFromMaxTransaction(address updAds, bool isEx)
866         public
867         onlyOwner
868     {
869         _isExcludedMaxTransactionAmount[updAds] = isEx;
870     }
871 
872     // only use to disable contract sales if absolutely necessary (emergency use only)
873     function updateSwapEnabled(bool enabled) external onlyOwner {
874         swapEnabled = enabled;
875     }
876 
877     function updateBuyFees(
878         uint256 _devFee,
879         uint256 _liquidityFee
880     ) external onlyOwner {
881         buyDevFee = _devFee;
882         buyLiquidityFee = _liquidityFee;
883         buyTotalFees = buyDevFee + buyLiquidityFee;
884         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
885     }
886 
887     function updateSellFees(
888         uint256 _devFee,
889         uint256 _liquidityFee
890     ) external onlyOwner {
891         sellDevFee = _devFee;
892         sellLiquidityFee = _liquidityFee;
893         sellTotalFees = sellDevFee + sellLiquidityFee;
894         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
895     }
896 
897     function excludeFromFees(address account, bool excluded) public onlyOwner {
898         _isExcludedFromFees[account] = excluded;
899         emit ExcludeFromFees(account, excluded);
900     }
901 
902     function updateDevWallet(address newDevWallet)
903         external
904         onlyOwner
905     {
906         emit devWalletUpdated(newDevWallet, devWallet);
907         devWallet = newDevWallet;
908     }
909 
910 
911     function isExcludedFromFees(address account) public view returns (bool) {
912         return _isExcludedFromFees[account];
913     }
914 
915     function _transfer(
916         address from,
917         address to,
918         uint256 amount
919     ) internal override {
920         require(from != address(0), "ERC20: transfer from the zero address");
921         require(to != address(0), "ERC20: transfer to the zero address");
922 
923         if (amount == 0) {
924             super._transfer(from, to, 0);
925             return;
926         }
927 
928         if (limitsInEffect) {
929             if (
930                 from != owner() &&
931                 to != owner() &&
932                 to != address(0) &&
933                 to != address(0xdead) &&
934                 !swapping
935             ) {
936                 if (!tradingActive) {
937                     require(
938                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
939                         "Trading is not active."
940                     );
941                 }
942 
943                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
944                 //when buy
945                 if (
946                     from == uniswapV2Pair &&
947                     !_isExcludedMaxTransactionAmount[to]
948                 ) {
949                     require(
950                         amount <= maxTransactionAmount,
951                         "Buy transfer amount exceeds the maxTransactionAmount."
952                     );
953                     require(
954                         amount + balanceOf(to) <= maxWallet,
955                         "Max wallet exceeded"
956                     );
957                 }
958                 else if (!_isExcludedMaxTransactionAmount[to]) {
959                     require(
960                         amount + balanceOf(to) <= maxWallet,
961                         "Max wallet exceeded"
962                     );
963                 }
964             }
965         }
966 
967         uint256 contractTokenBalance = balanceOf(address(this));
968 
969         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
970 
971         if (
972             canSwap &&
973             swapEnabled &&
974             !swapping &&
975             to == uniswapV2Pair &&
976             !_isExcludedFromFees[from] &&
977             !_isExcludedFromFees[to]
978         ) {
979             swapping = true;
980 
981             swapBack();
982 
983             swapping = false;
984         }
985 
986         bool takeFee = !swapping;
987 
988         // if any account belongs to _isExcludedFromFee account then remove the fee
989         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
990             takeFee = false;
991         }
992 
993         uint256 fees = 0;
994         uint256 tokensForLiquidity = 0;
995         uint256 tokensForDev = 0;
996         // only take fees on buys/sells, do not take on wallet transfers
997         if (takeFee) {
998             // on sell
999             if (to == uniswapV2Pair && sellTotalFees > 0) {
1000                 fees = amount.mul(sellTotalFees).div(100);
1001                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1002                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1003             }
1004             // on buy
1005             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1006                 fees = amount.mul(buyTotalFees).div(100);
1007                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1008                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1009             }
1010 
1011             if (fees> 0) {
1012                 super._transfer(from, address(this), fees);
1013             }
1014             if (tokensForLiquidity > 0) {
1015                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1016             }
1017 
1018             amount -= fees;
1019         }
1020 
1021         super._transfer(from, to, amount);
1022     }
1023 
1024     function swapTokensForBONE(uint256 tokenAmount) private {
1025         // generate the uniswap pair path of token -> weth
1026         address[] memory path = new address[](2);
1027         path[0] = address(this);
1028         path[1] = BONE;
1029 
1030         _approve(address(this), address(uniswapV2Router), tokenAmount);
1031 
1032         // make the swap
1033         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1034             tokenAmount,
1035             0, // accept any amount of BONE
1036             path,
1037             devWallet,
1038             block.timestamp
1039         );
1040     }
1041 
1042     function swapBack() private {
1043         uint256 contractBalance = balanceOf(address(this));
1044         if (contractBalance == 0) {
1045             return;
1046         }
1047 
1048         if (contractBalance > swapTokensAtAmount * 20) {
1049             contractBalance = swapTokensAtAmount * 20;
1050         }
1051 
1052         swapTokensForBONE(contractBalance);
1053     }
1054 
1055 }