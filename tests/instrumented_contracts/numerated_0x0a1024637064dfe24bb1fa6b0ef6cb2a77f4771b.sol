1 abstract contract Context {
2     function _msgSender() internal view virtual returns (address) {
3         return msg.sender;
4     }
5 
6     function _msgData() internal view virtual returns (bytes calldata) {
7         return msg.data;
8     }
9 }
10 
11 
12 abstract contract Ownable is Context {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Initializes the contract setting the deployer as the initial owner.
19      */
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     /**
25      * @dev Returns the address of the current owner.
26      */
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     /**
40      * @dev Leaves the contract without owner. It will not be possible to call
41      * `onlyOwner` functions anymore. Can only be called by the current owner.
42      *
43      * NOTE: Renouncing ownership will leave the contract without an owner,
44      * thereby removing any functionality that is only available to the owner.
45      */
46     function renounceOwnership() public virtual onlyOwner {
47         _transferOwnership(address(0));
48     }
49 
50     /**
51      * @dev Transfers ownership of the contract to a new account (`newOwner`).
52      * Can only be called by the current owner.
53      */
54     function transferOwnership(address newOwner) public virtual onlyOwner {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         _transferOwnership(newOwner);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Internal function without access restriction.
62      */
63     function _transferOwnership(address newOwner) internal virtual {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
71 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
72 
73 /* pragma solidity ^0.8.0; */
74 
75 /**
76  * @dev Interface of the ERC20 standard as defined in the EIP.
77  */
78 interface IERC20 {
79     /**
80      * @dev Returns the amount of tokens in existence.
81      */
82     function totalSupply() external view returns (uint256);
83 
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function balanceOf(address account) external view returns (uint256);
88 
89     /**
90      * @dev Moves `amount` tokens from the caller's account to `recipient`.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transfer(address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Returns the remaining number of tokens that `spender` will be
100      * allowed to spend on behalf of `owner` through {transferFrom}. This is
101      * zero by default.
102      *
103      * This value changes when {approve} or {transferFrom} are called.
104      */
105     function allowance(address owner, address spender) external view returns (uint256);
106 
107     /**
108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
113      * that someone may use both the old and the new allowance by unfortunate
114      * transaction ordering. One possible solution to mitigate this race
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Moves `amount` tokens from `sender` to `recipient` using the
125      * allowance mechanism. `amount` is then deducted from the caller's
126      * allowance.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) external returns (bool);
137 
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
154 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
155 
156 /* pragma solidity ^0.8.0; */
157 
158 /* import "../IERC20.sol"; */
159 
160 /**
161  * @dev Interface for the optional metadata functions from the ERC20 standard.
162  *
163  * _Available since v4.1._
164  */
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170 
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175 
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181 
182 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
183 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
184 
185 /* pragma solidity ^0.8.0; */
186 
187 /* import "./IERC20.sol"; */
188 /* import "./extensions/IERC20Metadata.sol"; */
189 /* import "../../utils/Context.sol"; */
190 
191 /**
192  * @dev Implementation of the {IERC20} interface.
193  *
194  * This implementation is agnostic to the way tokens are created. This means
195  * that a supply mechanism has to be added in a derived contract using {_mint}.
196  * For a generic mechanism see {ERC20PresetMinterPauser}.
197  *
198  * TIP: For a detailed writeup see our guide
199  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
200  * to implement supply mechanisms].
201  *
202  * We have followed general OpenZeppelin Contracts guidelines: functions revert
203  * instead returning `false` on failure. This behavior is nonetheless
204  * conventional and does not conflict with the expectations of ERC20
205  * applications.
206  *
207  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
208  * This allows applications to reconstruct the allowance for all accounts just
209  * by listening to said events. Other implementations of the EIP may not emit
210  * these events, as it isn't required by the specification.
211  *
212  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
213  * functions have been added to mitigate the well-known issues around setting
214  * allowances. See {IERC20-approve}.
215  */
216 contract ERC20 is Context, IERC20, IERC20Metadata {
217     mapping(address => uint256) private _balances;
218 
219     mapping(address => mapping(address => uint256)) private _allowances;
220 
221     uint256 private _totalSupply;
222 
223     string private _name;
224     string private _symbol;
225 
226     /**
227      * @dev Sets the values for {name} and {symbol}.
228      *
229      * The default value of {decimals} is 18. To select a different value for
230      * {decimals} you should overload it.
231      *
232      * All two of these values are immutable: they can only be set once during
233      * construction.
234      */
235     constructor(string memory name_, string memory symbol_) {
236         _name = name_;
237         _symbol = symbol_;
238     }
239 
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() public view virtual override returns (string memory) {
244         return _name;
245     }
246 
247     /**
248      * @dev Returns the symbol of the token, usually a shorter version of the
249      * name.
250      */
251     function symbol() public view virtual override returns (string memory) {
252         return _symbol;
253     }
254 
255     /**
256      * @dev Returns the number of decimals used to get its user representation.
257      * For example, if `decimals` equals `2`, a balance of `505` tokens should
258      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
259      *
260      * Tokens usually opt for a value of 18, imitating the relationship between
261      * Ether and Wei. This is the value {ERC20} uses, unless this function is
262      * overridden;
263      *
264      * NOTE: This information is only used for _display_ purposes: it in
265      * no way affects any of the arithmetic of the contract, including
266      * {IERC20-balanceOf} and {IERC20-transfer}.
267      */
268     function decimals() public view virtual override returns (uint8) {
269         return 18;
270     }
271 
272     /**
273      * @dev See {IERC20-totalSupply}.
274      */
275     function totalSupply() public view virtual override returns (uint256) {
276         return _totalSupply;
277     }
278 
279     /**
280      * @dev See {IERC20-balanceOf}.
281      */
282     function balanceOf(address account) public view virtual override returns (uint256) {
283         return _balances[account];
284     }
285 
286     /**
287      * @dev See {IERC20-transfer}.
288      *
289      * Requirements:
290      *
291      * - `recipient` cannot be the zero address.
292      * - the caller must have a balance of at least `amount`.
293      */
294     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
295         _transfer(_msgSender(), recipient, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-allowance}.
301      */
302     function allowance(address owner, address spender) public view virtual override returns (uint256) {
303         return _allowances[owner][spender];
304     }
305 
306     /**
307      * @dev See {IERC20-approve}.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function approve(address spender, uint256 amount) public virtual override returns (bool) {
314         _approve(_msgSender(), spender, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-transferFrom}.
320      *
321      * Emits an {Approval} event indicating the updated allowance. This is not
322      * required by the EIP. See the note at the beginning of {ERC20}.
323      *
324      * Requirements:
325      *
326      * - `sender` and `recipient` cannot be the zero address.
327      * - `sender` must have a balance of at least `amount`.
328      * - the caller must have allowance for ``sender``'s tokens of at least
329      * `amount`.
330      */
331     function transferFrom(
332         address sender,
333         address recipient,
334         uint256 amount
335     ) public virtual override returns (bool) {
336         _transfer(sender, recipient, amount);
337 
338         uint256 currentAllowance = _allowances[sender][_msgSender()];
339         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
340         unchecked {
341             _approve(sender, _msgSender(), currentAllowance - amount);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `sender` to `recipient`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(sender, recipient, amount);
370 
371         uint256 senderBalance = _balances[sender];
372         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
373         unchecked {
374             _balances[sender] = senderBalance - amount;
375         }
376         _balances[recipient] += amount;
377 
378         emit Transfer(sender, recipient, amount);
379 
380         _afterTokenTransfer(sender, recipient, amount);
381     }
382 
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: mint to the zero address");
394 
395         _beforeTokenTransfer(address(0), account, amount);
396 
397         _totalSupply += amount;
398         _balances[account] += amount;
399         emit Transfer(address(0), account, amount);
400 
401         _afterTokenTransfer(address(0), account, amount);
402     }
403 
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(
419         address owner,
420         address spender,
421         uint256 amount
422     ) internal virtual {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425 
426         _allowances[owner][spender] = amount;
427         emit Approval(owner, spender, amount);
428     }
429 
430     /**
431      * @dev Hook that is called before any transfer of tokens. This includes
432      * minting and burning.
433      *
434      * Calling conditions:
435      *
436      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
437      * will be transferred to `to`.
438      * - when `from` is zero, `amount` tokens will be minted for `to`.
439      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
440      * - `from` and `to` are never both zero.
441      *
442      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
443      */
444     function _beforeTokenTransfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {}
449 
450     /**
451      * @dev Hook that is called after any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * has been transferred to `to`.
458      * - when `from` is zero, `amount` tokens have been minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _afterTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 }
470 
471 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
472 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
473 
474 /* pragma solidity ^0.8.0; */
475 
476 // CAUTION
477 // This version of SafeMath should only be used with Solidity 0.8 or later,
478 // because it relies on the compiler's built in overflow checks.
479 
480 /**
481  * @dev Wrappers over Solidity's arithmetic operations.
482  *
483  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
484  * now has built in overflow checking.
485  */
486 library SafeMath {
487     /**
488      * @dev Returns the addition of two unsigned integers, with an overflow flag.
489      *
490      * _Available since v3.4._
491      */
492     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
493         unchecked {
494             uint256 c = a + b;
495             if (c < a) return (false, 0);
496             return (true, c);
497         }
498     }
499 
500     /**
501      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
502      *
503      * _Available since v3.4._
504      */
505     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
506         unchecked {
507             if (b > a) return (false, 0);
508             return (true, a - b);
509         }
510     }
511 
512     /**
513      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
514      *
515      * _Available since v3.4._
516      */
517     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
518         unchecked {
519             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520             // benefit is lost if 'b' is also tested.
521             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
522             if (a == 0) return (true, 0);
523             uint256 c = a * b;
524             if (c / a != b) return (false, 0);
525             return (true, c);
526         }
527     }
528 
529     /**
530      * @dev Returns the division of two unsigned integers, with a division by zero flag.
531      *
532      * _Available since v3.4._
533      */
534     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
535         unchecked {
536             if (b == 0) return (false, 0);
537             return (true, a / b);
538         }
539     }
540 
541     /**
542      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
543      *
544      * _Available since v3.4._
545      */
546     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
547         unchecked {
548             if (b == 0) return (false, 0);
549             return (true, a % b);
550         }
551     }
552 
553     /**
554      * @dev Returns the addition of two unsigned integers, reverting on
555      * overflow.
556      *
557      * Counterpart to Solidity's `+` operator.
558      *
559      * Requirements:
560      *
561      * - Addition cannot overflow.
562      */
563     function add(uint256 a, uint256 b) internal pure returns (uint256) {
564         return a + b;
565     }
566 
567     /**
568      * @dev Returns the subtraction of two unsigned integers, reverting on
569      * overflow (when the result is negative).
570      *
571      * Counterpart to Solidity's `-` operator.
572      *
573      * Requirements:
574      *
575      * - Subtraction cannot overflow.
576      */
577     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
578         return a - b;
579     }
580 
581     /**
582      * @dev Returns the multiplication of two unsigned integers, reverting on
583      * overflow.
584      *
585      * Counterpart to Solidity's `*` operator.
586      *
587      * Requirements:
588      *
589      * - Multiplication cannot overflow.
590      */
591     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
592         return a * b;
593     }
594 
595     /**
596      * @dev Returns the integer division of two unsigned integers, reverting on
597      * division by zero. The result is rounded towards zero.
598      *
599      * Counterpart to Solidity's `/` operator.
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function div(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a / b;
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
611      * reverting when dividing by zero.
612      *
613      * Counterpart to Solidity's `%` operator. This function uses a `revert`
614      * opcode (which leaves remaining gas untouched) while Solidity uses an
615      * invalid opcode to revert (consuming all remaining gas).
616      *
617      * Requirements:
618      *
619      * - The divisor cannot be zero.
620      */
621     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
622         return a % b;
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
627      * overflow (when the result is negative).
628      *
629      * CAUTION: This function is deprecated because it requires allocating memory for the error
630      * message unnecessarily. For custom revert reasons use {trySub}.
631      *
632      * Counterpart to Solidity's `-` operator.
633      *
634      * Requirements:
635      *
636      * - Subtraction cannot overflow.
637      */
638     function sub(
639         uint256 a,
640         uint256 b,
641         string memory errorMessage
642     ) internal pure returns (uint256) {
643         unchecked {
644             require(b <= a, errorMessage);
645             return a - b;
646         }
647     }
648 
649     /**
650      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
651      * division by zero. The result is rounded towards zero.
652      *
653      * Counterpart to Solidity's `/` operator. Note: this function uses a
654      * `revert` opcode (which leaves remaining gas untouched) while Solidity
655      * uses an invalid opcode to revert (consuming all remaining gas).
656      *
657      * Requirements:
658      *
659      * - The divisor cannot be zero.
660      */
661     function div(
662         uint256 a,
663         uint256 b,
664         string memory errorMessage
665     ) internal pure returns (uint256) {
666         unchecked {
667             require(b > 0, errorMessage);
668             return a / b;
669         }
670     }
671 
672     /**
673      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
674      * reverting with custom message when dividing by zero.
675      *
676      * CAUTION: This function is deprecated because it requires allocating memory for the error
677      * message unnecessarily. For custom revert reasons use {tryMod}.
678      *
679      * Counterpart to Solidity's `%` operator. This function uses a `revert`
680      * opcode (which leaves remaining gas untouched) while Solidity uses an
681      * invalid opcode to revert (consuming all remaining gas).
682      *
683      * Requirements:
684      *
685      * - The divisor cannot be zero.
686      */
687     function mod(
688         uint256 a,
689         uint256 b,
690         string memory errorMessage
691     ) internal pure returns (uint256) {
692         unchecked {
693             require(b > 0, errorMessage);
694             return a % b;
695         }
696     }
697 }
698 
699 interface IUniswapV2Factory {
700     event PairCreated(
701         address indexed token0,
702         address indexed token1,
703         address pair,
704         uint256
705     );
706 
707     function createPair(address tokenA, address tokenB)
708         external
709         returns (address pair);
710 }
711 
712 interface IUniswapV2Router02 {
713     function factory() external pure returns (address);
714 
715     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
716         uint256 amountIn,
717         uint256 amountOutMin,
718         address[] calldata path,
719         address to,
720         uint256 deadline
721     ) external;
722 }
723 
724 contract HalfPEPE is ERC20, Ownable {
725     using SafeMath for uint256;
726 
727     IUniswapV2Router02 public immutable uniswapV2Router;
728     address public immutable uniswapV2Pair;
729     address public constant deadAddress = address(0xdead);
730     address public PEPE = 0x6982508145454Ce325dDbE47a25d4ec3d2311933;
731 
732     bool private swapping;
733 
734     address public devWallet;
735 
736     uint256 public maxTransactionAmount;
737     uint256 public swapTokensAtAmount;
738     uint256 public maxWallet;
739 
740     bool public limitsInEffect = true;
741     bool public tradingActive = false;
742     bool public swapEnabled = true;
743 
744     uint256 public buyTotalFees;
745     uint256 public buyDevFee;
746     uint256 public buyLiquidityFee;
747 
748     uint256 public sellTotalFees;
749     uint256 public sellDevFee;
750     uint256 public sellLiquidityFee;
751 
752     /******************/
753 
754     // exlcude from fees and max transaction amount
755     mapping(address => bool) private _isExcludedFromFees;
756     mapping(address => bool) public _isExcludedMaxTransactionAmount;
757 
758 
759     event ExcludeFromFees(address indexed account, bool isExcluded);
760 
761     event devWalletUpdated(
762         address indexed newWallet,
763         address indexed oldWallet
764     );
765 
766     constructor() ERC20("Half Pepe", "PEPE0.5") {
767         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
768 
769         excludeFromMaxTransaction(address(_uniswapV2Router), true);
770         uniswapV2Router = _uniswapV2Router;
771 
772         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
773             .createPair(address(this), PEPE);
774         excludeFromMaxTransaction(address(uniswapV2Pair), true);
775 
776 
777         uint256 _buyDevFee = 25;
778         uint256 _buyLiquidityFee = 0;
779 
780         uint256 _sellDevFee = 50;
781         uint256 _sellLiquidityFee = 0;
782 
783         uint256 totalSupply = 1_000_000 * 1e18;
784 
785         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
786         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
787         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
788 
789         buyDevFee = _buyDevFee;
790         buyLiquidityFee = _buyLiquidityFee;
791         buyTotalFees = buyDevFee + buyLiquidityFee;
792 
793         sellDevFee = _sellDevFee;
794         sellLiquidityFee = _sellLiquidityFee;
795         sellTotalFees = sellDevFee + sellLiquidityFee;
796 
797         devWallet = address(0x915a22cEF855CfA6469E18bfcfC22b8a7A403EfE); 
798 
799         // exclude from paying fees or having max transaction amount
800         excludeFromFees(owner(), true);
801         excludeFromFees(address(this), true);
802         excludeFromFees(address(0xdead), true);
803 
804         excludeFromMaxTransaction(owner(), true);
805         excludeFromMaxTransaction(address(this), true);
806         excludeFromMaxTransaction(address(0xdead), true);
807 
808         /*
809             _mint is an internal function in ERC20.sol that is only called here,
810             and CANNOT be called ever again
811         */
812         _mint(msg.sender, totalSupply);
813     }
814 
815     receive() external payable {}
816 
817     // once enabled, can never be turned off
818     function enableTrading() external onlyOwner {
819         tradingActive = true;
820         swapEnabled = true;
821     }
822 
823     // remove limits after token is stable
824     function removeLimits() external onlyOwner returns (bool) {
825         limitsInEffect = false;
826         return true;
827     }
828 
829     // change the minimum amount of tokens to sell from fees
830     function updateSwapTokensAtAmount(uint256 newAmount)
831         external
832         onlyOwner
833         returns (bool)
834     {
835         require(
836             newAmount >= (totalSupply() * 1) / 100000,
837             "Swap amount cannot be lower than 0.001% total supply."
838         );
839         require(
840             newAmount <= (totalSupply() * 5) / 1000,
841             "Swap amount cannot be higher than 0.5% total supply."
842         );
843         swapTokensAtAmount = newAmount;
844         return true;
845     }
846 
847     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
848         require(
849             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
850             "Cannot set maxTransactionAmount lower than 0.1%"
851         );
852         maxTransactionAmount = newNum * (10**18);
853     }
854 
855     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
856         require(
857             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
858             "Cannot set maxWallet lower than 0.5%"
859         );
860         maxWallet = newNum * (10**18);
861     }
862 
863     function excludeFromMaxTransaction(address updAds, bool isEx)
864         public
865         onlyOwner
866     {
867         _isExcludedMaxTransactionAmount[updAds] = isEx;
868     }
869 
870     // only use to disable contract sales if absolutely necessary (emergency use only)
871     function updateSwapEnabled(bool enabled) external onlyOwner {
872         swapEnabled = enabled;
873     }
874 
875     function updateBuyFees(
876         uint256 _devFee,
877         uint256 _liquidityFee
878     ) external onlyOwner {
879         buyDevFee = _devFee;
880         buyLiquidityFee = _liquidityFee;
881         buyTotalFees = buyDevFee + buyLiquidityFee;
882         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
883     }
884 
885     function updateSellFees(
886         uint256 _devFee,
887         uint256 _liquidityFee
888     ) external onlyOwner {
889         sellDevFee = _devFee;
890         sellLiquidityFee = _liquidityFee;
891         sellTotalFees = sellDevFee + sellLiquidityFee;
892         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
893     }
894 
895     function excludeFromFees(address account, bool excluded) public onlyOwner {
896         _isExcludedFromFees[account] = excluded;
897         emit ExcludeFromFees(account, excluded);
898     }
899 
900     function updateDevWallet(address newDevWallet)
901         external
902         onlyOwner
903     {
904         emit devWalletUpdated(newDevWallet, devWallet);
905         devWallet = newDevWallet;
906     }
907 
908 
909     function isExcludedFromFees(address account) public view returns (bool) {
910         return _isExcludedFromFees[account];
911     }
912 
913     function _transfer(
914         address from,
915         address to,
916         uint256 amount
917     ) internal override {
918         require(from != address(0), "ERC20: transfer from the zero address");
919         require(to != address(0), "ERC20: transfer to the zero address");
920 
921         if (amount == 0) {
922             super._transfer(from, to, 0);
923             return;
924         }
925 
926         if (limitsInEffect) {
927             if (
928                 from != owner() &&
929                 to != owner() &&
930                 to != address(0) &&
931                 to != address(0xdead) &&
932                 !swapping
933             ) {
934                 if (!tradingActive) {
935                     require(
936                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
937                         "Trading is not active."
938                     );
939                 }
940 
941                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
942                 //when buy
943                 if (
944                     from == uniswapV2Pair &&
945                     !_isExcludedMaxTransactionAmount[to]
946                 ) {
947                     require(
948                         amount <= maxTransactionAmount,
949                         "Buy transfer amount exceeds the maxTransactionAmount."
950                     );
951                     require(
952                         amount + balanceOf(to) <= maxWallet,
953                         "Max wallet exceeded"
954                     );
955                 }
956                 else if (!_isExcludedMaxTransactionAmount[to]) {
957                     require(
958                         amount + balanceOf(to) <= maxWallet,
959                         "Max wallet exceeded"
960                     );
961                 }
962             }
963         }
964 
965         uint256 contractTokenBalance = balanceOf(address(this));
966 
967         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
968 
969         if (
970             canSwap &&
971             swapEnabled &&
972             !swapping &&
973             to == uniswapV2Pair &&
974             !_isExcludedFromFees[from] &&
975             !_isExcludedFromFees[to]
976         ) {
977             swapping = true;
978 
979             swapBack();
980 
981             swapping = false;
982         }
983 
984         bool takeFee = !swapping;
985 
986         // if any account belongs to _isExcludedFromFee account then remove the fee
987         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
988             takeFee = false;
989         }
990 
991         uint256 fees = 0;
992         uint256 tokensForLiquidity = 0;
993         uint256 tokensForDev = 0;
994         // only take fees on buys/sells, do not take on wallet transfers
995         if (takeFee) {
996             // on sell
997             if (to == uniswapV2Pair && sellTotalFees > 0) {
998                 fees = amount.mul(sellTotalFees).div(100);
999                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1000                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1001             }
1002             // on buy
1003             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1004                 fees = amount.mul(buyTotalFees).div(100);
1005                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1006                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1007             }
1008 
1009             if (fees> 0) {
1010                 super._transfer(from, address(this), fees);
1011             }
1012             if (tokensForLiquidity > 0) {
1013                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1014             }
1015 
1016             amount -= fees;
1017         }
1018 
1019         super._transfer(from, to, amount);
1020     }
1021 
1022     function swapTokensForPEPE(uint256 tokenAmount) private {
1023         // generate the uniswap pair path of token -> weth
1024         address[] memory path = new address[](2);
1025         path[0] = address(this);
1026         path[1] = PEPE;
1027 
1028         _approve(address(this), address(uniswapV2Router), tokenAmount);
1029 
1030         // make the swap
1031         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1032             tokenAmount,
1033             0, // accept any amount of PEPE
1034             path,
1035             devWallet,
1036             block.timestamp
1037         );
1038     }
1039 
1040     function swapBack() private {
1041         uint256 contractBalance = balanceOf(address(this));
1042         if (contractBalance == 0) {
1043             return;
1044         }
1045 
1046         if (contractBalance > swapTokensAtAmount * 20) {
1047             contractBalance = swapTokensAtAmount * 20;
1048         }
1049 
1050         swapTokensForPEPE(contractBalance);
1051     }
1052 
1053 }