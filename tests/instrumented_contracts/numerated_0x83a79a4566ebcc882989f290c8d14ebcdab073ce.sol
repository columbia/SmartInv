1 // File: erc-20.sol
2 
3 /****
4 
5 https://medium.com/@majiERC
6 
7 https://twitter.com/majiERC
8 
9 ***/
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev Initializes the contract setting the deployer as the initial owner.
28      */
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Internal function without access restriction.
71      */
72     function _transferOwnership(address newOwner) internal virtual {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
80 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
81 
82 /* pragma solidity ^0.8.0; */
83 
84 /**
85  * @dev Interface of the ERC20 standard as defined in the EIP.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
163 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
164 
165 /* pragma solidity ^0.8.0; */
166 
167 /* import "../IERC20.sol"; */
168 
169 /**
170  * @dev Interface for the optional metadata functions from the ERC20 standard.
171  *
172  * _Available since v4.1._
173  */
174 interface IERC20Metadata is IERC20 {
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() external view returns (string memory);
179 
180     /**
181      * @dev Returns the symbol of the token.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the decimals places of the token.
187      */
188     function decimals() external view returns (uint8);
189 }
190 
191 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
192 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
193 
194 /* pragma solidity ^0.8.0; */
195 
196 /* import "./IERC20.sol"; */
197 /* import "./extensions/IERC20Metadata.sol"; */
198 /* import "../../utils/Context.sol"; */
199 
200 /**
201  * @dev Implementation of the {IERC20} interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using {_mint}.
205  * For a generic mechanism see {ERC20PresetMinterPauser}.
206  *
207  * TIP: For a detailed writeup see our guide
208  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
209  * to implement supply mechanisms].
210  *
211  * We have followed general OpenZeppelin Contracts guidelines: functions revert
212  * instead returning `false` on failure. This behavior is nonetheless
213  * conventional and does not conflict with the expectations of ERC20
214  * applications.
215  *
216  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
217  * This allows applications to reconstruct the allowance for all accounts just
218  * by listening to said events. Other implementations of the EIP may not emit
219  * these events, as it isn't required by the specification.
220  *
221  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
222  * functions have been added to mitigate the well-known issues around setting
223  * allowances. See {IERC20-approve}.
224  */
225 contract ERC20 is Context, IERC20, IERC20Metadata {
226     mapping(address => uint256) private _balances;
227 
228     mapping(address => mapping(address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     string private _name;
233     string private _symbol;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}.
237      *
238      * The default value of {decimals} is 18. To select a different value for
239      * {decimals} you should overload it.
240      *
241      * All two of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor(string memory name_, string memory symbol_) {
245         _name = name_;
246         _symbol = symbol_;
247     }
248 
249     /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view virtual override returns (string memory) {
253         return _name;
254     }
255 
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263 
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
271      * overridden;
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view virtual override returns (uint8) {
278         return 18;
279     }
280 
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view virtual override returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294 
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(_msgSender(), recipient, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314 
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * Requirements:
334      *
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public virtual override returns (bool) {
345         _transfer(sender, recipient, amount);
346 
347         uint256 currentAllowance = _allowances[sender][_msgSender()];
348         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
349         unchecked {
350             _approve(sender, _msgSender(), currentAllowance - amount);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `sender` to `recipient`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `sender` cannot be the zero address.
367      * - `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) internal virtual {
375         require(sender != address(0), "ERC20: transfer from the zero address");
376         require(recipient != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(sender, recipient, amount);
379 
380         uint256 senderBalance = _balances[sender];
381         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[sender] = senderBalance - amount;
384         }
385         _balances[recipient] += amount;
386 
387         emit Transfer(sender, recipient, amount);
388 
389         _afterTokenTransfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         _balances[account] += amount;
408         emit Transfer(address(0), account, amount);
409 
410         _afterTokenTransfer(address(0), account, amount);
411     }
412 
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 
459     /**
460      * @dev Hook that is called after any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * has been transferred to `to`.
467      * - when `from` is zero, `amount` tokens have been minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _afterTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479 
480 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
481 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
482 
483 /* pragma solidity ^0.8.0; */
484 
485 // CAUTION
486 // This version of SafeMath should only be used with Solidity 0.8 or later,
487 // because it relies on the compiler's built in overflow checks.
488 
489 /**
490  * @dev Wrappers over Solidity's arithmetic operations.
491  *
492  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
493  * now has built in overflow checking.
494  */
495 library SafeMath {
496     /**
497      * @dev Returns the addition of two unsigned integers, with an overflow flag.
498      *
499      * _Available since v3.4._
500      */
501     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
502         unchecked {
503             uint256 c = a + b;
504             if (c < a) return (false, 0);
505             return (true, c);
506         }
507     }
508 
509     /**
510      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
511      *
512      * _Available since v3.4._
513      */
514     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
515         unchecked {
516             if (b > a) return (false, 0);
517             return (true, a - b);
518         }
519     }
520 
521     /**
522      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
523      *
524      * _Available since v3.4._
525      */
526     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
527         unchecked {
528             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
529             // benefit is lost if 'b' is also tested.
530             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
531             if (a == 0) return (true, 0);
532             uint256 c = a * b;
533             if (c / a != b) return (false, 0);
534             return (true, c);
535         }
536     }
537 
538     /**
539      * @dev Returns the division of two unsigned integers, with a division by zero flag.
540      *
541      * _Available since v3.4._
542      */
543     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
544         unchecked {
545             if (b == 0) return (false, 0);
546             return (true, a / b);
547         }
548     }
549 
550     /**
551      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
552      *
553      * _Available since v3.4._
554      */
555     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         unchecked {
557             if (b == 0) return (false, 0);
558             return (true, a % b);
559         }
560     }
561 
562     /**
563      * @dev Returns the addition of two unsigned integers, reverting on
564      * overflow.
565      *
566      * Counterpart to Solidity's `+` operator.
567      *
568      * Requirements:
569      *
570      * - Addition cannot overflow.
571      */
572     function add(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a + b;
574     }
575 
576     /**
577      * @dev Returns the subtraction of two unsigned integers, reverting on
578      * overflow (when the result is negative).
579      *
580      * Counterpart to Solidity's `-` operator.
581      *
582      * Requirements:
583      *
584      * - Subtraction cannot overflow.
585      */
586     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a - b;
588     }
589 
590     /**
591      * @dev Returns the multiplication of two unsigned integers, reverting on
592      * overflow.
593      *
594      * Counterpart to Solidity's `*` operator.
595      *
596      * Requirements:
597      *
598      * - Multiplication cannot overflow.
599      */
600     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a * b;
602     }
603 
604     /**
605      * @dev Returns the integer division of two unsigned integers, reverting on
606      * division by zero. The result is rounded towards zero.
607      *
608      * Counterpart to Solidity's `/` operator.
609      *
610      * Requirements:
611      *
612      * - The divisor cannot be zero.
613      */
614     function div(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a / b;
616     }
617 
618     /**
619      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
620      * reverting when dividing by zero.
621      *
622      * Counterpart to Solidity's `%` operator. This function uses a `revert`
623      * opcode (which leaves remaining gas untouched) while Solidity uses an
624      * invalid opcode to revert (consuming all remaining gas).
625      *
626      * Requirements:
627      *
628      * - The divisor cannot be zero.
629      */
630     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
631         return a % b;
632     }
633 
634     /**
635      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
636      * overflow (when the result is negative).
637      *
638      * CAUTION: This function is deprecated because it requires allocating memory for the error
639      * message unnecessarily. For custom revert reasons use {trySub}.
640      *
641      * Counterpart to Solidity's `-` operator.
642      *
643      * Requirements:
644      *
645      * - Subtraction cannot overflow.
646      */
647     function sub(
648         uint256 a,
649         uint256 b,
650         string memory errorMessage
651     ) internal pure returns (uint256) {
652         unchecked {
653             require(b <= a, errorMessage);
654             return a - b;
655         }
656     }
657 
658     /**
659      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
660      * division by zero. The result is rounded towards zero.
661      *
662      * Counterpart to Solidity's `/` operator. Note: this function uses a
663      * `revert` opcode (which leaves remaining gas untouched) while Solidity
664      * uses an invalid opcode to revert (consuming all remaining gas).
665      *
666      * Requirements:
667      *
668      * - The divisor cannot be zero.
669      */
670     function div(
671         uint256 a,
672         uint256 b,
673         string memory errorMessage
674     ) internal pure returns (uint256) {
675         unchecked {
676             require(b > 0, errorMessage);
677             return a / b;
678         }
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
683      * reverting with custom message when dividing by zero.
684      *
685      * CAUTION: This function is deprecated because it requires allocating memory for the error
686      * message unnecessarily. For custom revert reasons use {tryMod}.
687      *
688      * Counterpart to Solidity's `%` operator. This function uses a `revert`
689      * opcode (which leaves remaining gas untouched) while Solidity uses an
690      * invalid opcode to revert (consuming all remaining gas).
691      *
692      * Requirements:
693      *
694      * - The divisor cannot be zero.
695      */
696     function mod(
697         uint256 a,
698         uint256 b,
699         string memory errorMessage
700     ) internal pure returns (uint256) {
701         unchecked {
702             require(b > 0, errorMessage);
703             return a % b;
704         }
705     }
706 }
707 
708 interface IUniswapV2Factory {
709     event PairCreated(
710         address indexed token0,
711         address indexed token1,
712         address pair,
713         uint256
714     );
715 
716     function createPair(address tokenA, address tokenB)
717         external
718         returns (address pair);
719 }
720 
721 interface IUniswapV2Router02 {
722     function factory() external pure returns (address);
723 
724     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
725         uint256 amountIn,
726         uint256 amountOutMin,
727         address[] calldata path,
728         address to,
729         uint256 deadline
730     ) external;
731 }
732 
733 contract maji is ERC20, Ownable {
734     using SafeMath for uint256;
735 
736     IUniswapV2Router02 public immutable uniswapV2Router;
737     address public immutable uniswapV2Pair;
738     address public constant deadAddress = address(0xdead);
739     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
740 
741     bool private swapping;
742 
743     address public devWallet;
744 
745     uint256 public maxTransactionAmount;
746     uint256 public swapTokensAtAmount;
747     uint256 public maxWallet;
748 
749     bool public limitsInEffect = true;
750     bool public tradingActive = false;
751     bool public swapEnabled = true;
752 
753     uint256 public buyTotalFees;
754     uint256 public buyDevFee;
755     uint256 public buyLiquidityFee;
756 
757     uint256 public sellTotalFees;
758     uint256 public sellDevFee;
759     uint256 public sellLiquidityFee;
760 
761     /******************/
762 
763     // exlcude from fees and max transaction amount
764     mapping(address => bool) private _isExcludedFromFees;
765     mapping(address => bool) public _isExcludedMaxTransactionAmount;
766 
767 
768     event ExcludeFromFees(address indexed account, bool isExcluded);
769 
770     event devWalletUpdated(
771         address indexed newWallet,
772         address indexed oldWallet
773     );
774 
775     constructor() ERC20("Maji", "MAJI") {
776         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
777 
778         excludeFromMaxTransaction(address(_uniswapV2Router), true);
779         uniswapV2Router = _uniswapV2Router;
780 
781         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
782             .createPair(address(this), USDC);
783         excludeFromMaxTransaction(address(uniswapV2Pair), true);
784 
785 
786         uint256 _buyDevFee = 2;
787         uint256 _buyLiquidityFee = 0;
788 
789         uint256 _sellDevFee = 3;
790         uint256 _sellLiquidityFee = 0;
791 
792         uint256 totalSupply = 100_000_000 * 1e18;
793 
794         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
795         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
796         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
797 
798         buyDevFee = _buyDevFee;
799         buyLiquidityFee = _buyLiquidityFee;
800         buyTotalFees = buyDevFee + buyLiquidityFee;
801 
802         sellDevFee = _sellDevFee;
803         sellLiquidityFee = _sellLiquidityFee;
804         sellTotalFees = sellDevFee + sellLiquidityFee;
805 
806         devWallet = address(0x4cA8f1b4Bd58992d6de8b85bFc684414c019D2ae); // set as dev wallet
807 
808         // exclude from paying fees or having max transaction amount
809         excludeFromFees(owner(), true);
810         excludeFromFees(address(this), true);
811         excludeFromFees(address(0xdead), true);
812 
813         excludeFromMaxTransaction(owner(), true);
814         excludeFromMaxTransaction(address(this), true);
815         excludeFromMaxTransaction(address(0xdead), true);
816 
817         /*
818             _mint is an internal function in ERC20.sol that is only called here,
819             and CANNOT be called ever again
820         */
821         _mint(msg.sender, totalSupply);
822     }
823 
824     receive() external payable {}
825 
826     // once enabled, can never be turned off
827     function enableTrading() external onlyOwner {
828         tradingActive = true;
829         swapEnabled = true;
830     }
831 
832     // remove limits after token is stable
833     function removeLimits() external onlyOwner returns (bool) {
834         limitsInEffect = false;
835         return true;
836     }
837 
838     // change the minimum amount of tokens to sell from fees
839     function updateSwapTokensAtAmount(uint256 newAmount)
840         external
841         onlyOwner
842         returns (bool)
843     {
844         require(
845             newAmount >= (totalSupply() * 1) / 100000,
846             "Swap amount cannot be lower than 0.001% total supply."
847         );
848         require(
849             newAmount <= (totalSupply() * 5) / 1000,
850             "Swap amount cannot be higher than 0.5% total supply."
851         );
852         swapTokensAtAmount = newAmount;
853         return true;
854     }
855 
856     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
857         require(
858             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
859             "Cannot set maxTransactionAmount lower than 0.1%"
860         );
861         maxTransactionAmount = newNum * (10**18);
862     }
863 
864     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
865         require(
866             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
867             "Cannot set maxWallet lower than 0.5%"
868         );
869         maxWallet = newNum * (10**18);
870     }
871 
872     function excludeFromMaxTransaction(address updAds, bool isEx)
873         public
874         onlyOwner
875     {
876         _isExcludedMaxTransactionAmount[updAds] = isEx;
877     }
878 
879     // only use to disable contract sales if absolutely necessary (emergency use only)
880     function updateSwapEnabled(bool enabled) external onlyOwner {
881         swapEnabled = enabled;
882     }
883 
884     function updateBuyFees(
885         uint256 _devFee,
886         uint256 _liquidityFee
887     ) external onlyOwner {
888         buyDevFee = _devFee;
889         buyLiquidityFee = _liquidityFee;
890         buyTotalFees = buyDevFee + buyLiquidityFee;
891         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
892     }
893 
894     function updateSellFees(
895         uint256 _devFee,
896         uint256 _liquidityFee
897     ) external onlyOwner {
898         sellDevFee = _devFee;
899         sellLiquidityFee = _liquidityFee;
900         sellTotalFees = sellDevFee + sellLiquidityFee;
901         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
902     }
903 
904     function excludeFromFees(address account, bool excluded) public onlyOwner {
905         _isExcludedFromFees[account] = excluded;
906         emit ExcludeFromFees(account, excluded);
907     }
908 
909     function updateDevWallet(address newDevWallet)
910         external
911         onlyOwner
912     {
913         emit devWalletUpdated(newDevWallet, devWallet);
914         devWallet = newDevWallet;
915     }
916 
917 
918     function isExcludedFromFees(address account) public view returns (bool) {
919         return _isExcludedFromFees[account];
920     }
921 
922     function _transfer(
923         address from,
924         address to,
925         uint256 amount
926     ) internal override {
927         require(from != address(0), "ERC20: transfer from the zero address");
928         require(to != address(0), "ERC20: transfer to the zero address");
929 
930         if (amount == 0) {
931             super._transfer(from, to, 0);
932             return;
933         }
934 
935         if (limitsInEffect) {
936             if (
937                 from != owner() &&
938                 to != owner() &&
939                 to != address(0) &&
940                 to != address(0xdead) &&
941                 !swapping
942             ) {
943                 if (!tradingActive) {
944                     require(
945                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
946                         "Trading is not active."
947                     );
948                 }
949 
950                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
951                 //when buy
952                 if (
953                     from == uniswapV2Pair &&
954                     !_isExcludedMaxTransactionAmount[to]
955                 ) {
956                     require(
957                         amount <= maxTransactionAmount,
958                         "Buy transfer amount exceeds the maxTransactionAmount."
959                     );
960                     require(
961                         amount + balanceOf(to) <= maxWallet,
962                         "Max wallet exceeded"
963                     );
964                 }
965                 else if (!_isExcludedMaxTransactionAmount[to]) {
966                     require(
967                         amount + balanceOf(to) <= maxWallet,
968                         "Max wallet exceeded"
969                     );
970                 }
971             }
972         }
973 
974         uint256 contractTokenBalance = balanceOf(address(this));
975 
976         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
977 
978         if (
979             canSwap &&
980             swapEnabled &&
981             !swapping &&
982             to == uniswapV2Pair &&
983             !_isExcludedFromFees[from] &&
984             !_isExcludedFromFees[to]
985         ) {
986             swapping = true;
987 
988             swapBack();
989 
990             swapping = false;
991         }
992 
993         bool takeFee = !swapping;
994 
995         // if any account belongs to _isExcludedFromFee account then remove the fee
996         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
997             takeFee = false;
998         }
999 
1000         uint256 fees = 0;
1001         uint256 tokensForLiquidity = 0;
1002         uint256 tokensForDev = 0;
1003         // only take fees on buys/sells, do not take on wallet transfers
1004         if (takeFee) {
1005             // on sell
1006             if (to == uniswapV2Pair && sellTotalFees > 0) {
1007                 fees = amount.mul(sellTotalFees).div(100);
1008                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1009                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1010             }
1011             // on buy
1012             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1013                 fees = amount.mul(buyTotalFees).div(100);
1014                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1015                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1016             }
1017 
1018             if (fees> 0) {
1019                 super._transfer(from, address(this), fees);
1020             }
1021             if (tokensForLiquidity > 0) {
1022                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1023             }
1024 
1025             amount -= fees;
1026         }
1027 
1028         super._transfer(from, to, amount);
1029     }
1030 
1031     function swapTokensForUSDC(uint256 tokenAmount) private {
1032         // generate the uniswap pair path of token -> weth
1033         address[] memory path = new address[](2);
1034         path[0] = address(this);
1035         path[1] = USDC;
1036 
1037         _approve(address(this), address(uniswapV2Router), tokenAmount);
1038 
1039         // make the swap
1040         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1041             tokenAmount,
1042             0, // accept any amount of USDC
1043             path,
1044             devWallet,
1045             block.timestamp
1046         );
1047     }
1048 
1049     function swapBack() private {
1050         uint256 contractBalance = balanceOf(address(this));
1051         if (contractBalance == 0) {
1052             return;
1053         }
1054 
1055         if (contractBalance > swapTokensAtAmount * 20) {
1056             contractBalance = swapTokensAtAmount * 20;
1057         }
1058 
1059         swapTokensForUSDC(contractBalance);
1060     }
1061 
1062 }