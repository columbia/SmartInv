1 // File: erc-20.sol
2 
3 /**
4 
5 Who can be sure?
6 
7 */
8 
9 pragma solidity ^0.8.10;
10 pragma experimental ABIEncoderV2;
11 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _transferOwnership(newOwner);
48     }
49 
50     function _transferOwnership(address newOwner) internal virtual {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function decimals() external view returns (uint8);
85 }
86 
87 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
88 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
89 
90 /* pragma solidity ^0.8.0; */
91 
92 /* import "./IERC20.sol"; */
93 /* import "./extensions/IERC20Metadata.sol"; */
94 /* import "../../utils/Context.sol"; */
95 
96 /**
97  * @dev Implementation of the {IERC20} interface.
98  *
99  * This implementation is agnostic to the way tokens are created. This means
100  * that a supply mechanism has to be added in a derived contract using {_mint}.
101  * For a generic mechanism see {ERC20PresetMinterPauser}.
102  *
103  * TIP: For a detailed writeup see our guide
104  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
105  * to implement supply mechanisms].
106  *
107  * We have followed general OpenZeppelin Contracts guidelines: functions revert
108  * instead returning `false` on failure. This behavior is nonetheless
109  * conventional and does not conflict with the expectations of ERC20
110  * applications.
111  *
112  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
113  * This allows applications to reconstruct the allowance for all accounts just
114  * by listening to said events. Other implementations of the EIP may not emit
115  * these events, as it isn't required by the specification.
116  *
117  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
118  * functions have been added to mitigate the well-known issues around setting
119  * allowances. See {IERC20-approve}.
120  */
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     /**
132      * @dev Sets the values for {name} and {symbol}.
133      *
134      * The default value of {decimals} is 18. To select a different value for
135      * {decimals} you should overload it.
136      *
137      * All two of these values are immutable: they can only be set once during
138      * construction.
139      */
140     constructor(string memory name_, string memory symbol_) {
141         _name = name_;
142         _symbol = symbol_;
143     }
144 
145     /**
146      * @dev Returns the name of the token.
147      */
148     function name() public view virtual override returns (string memory) {
149         return _name;
150     }
151 
152     /**
153      * @dev Returns the symbol of the token, usually a shorter version of the
154      * name.
155      */
156     function symbol() public view virtual override returns (string memory) {
157         return _symbol;
158     }
159 
160     /**
161      * @dev Returns the number of decimals used to get its user representation.
162      * For example, if `decimals` equals `2`, a balance of `505` tokens should
163      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
164      *
165      * Tokens usually opt for a value of 18, imitating the relationship between
166      * Ether and Wei. This is the value {ERC20} uses, unless this function is
167      * overridden;
168      *
169      * NOTE: This information is only used for _display_ purposes: it in
170      * no way affects any of the arithmetic of the contract, including
171      * {IERC20-balanceOf} and {IERC20-transfer}.
172      */
173     function decimals() public view virtual override returns (uint8) {
174         return 18;
175     }
176 
177     /**
178      * @dev See {IERC20-totalSupply}.
179      */
180     function totalSupply() public view virtual override returns (uint256) {
181         return _totalSupply;
182     }
183 
184     /**
185      * @dev See {IERC20-balanceOf}.
186      */
187     function balanceOf(address account) public view virtual override returns (uint256) {
188         return _balances[account];
189     }
190 
191     /**
192      * @dev See {IERC20-transfer}.
193      *
194      * Requirements:
195      *
196      * - `recipient` cannot be the zero address.
197      * - the caller must have a balance of at least `amount`.
198      */
199     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     /**
205      * @dev See {IERC20-allowance}.
206      */
207     function allowance(address owner, address spender) public view virtual override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     /**
212      * @dev See {IERC20-approve}.
213      *
214      * Requirements:
215      *
216      * - `spender` cannot be the zero address.
217      */
218     function approve(address spender, uint256 amount) public virtual override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-transferFrom}.
225      *
226      * Emits an {Approval} event indicating the updated allowance. This is not
227      * required by the EIP. See the note at the beginning of {ERC20}.
228      *
229      * Requirements:
230      *
231      * - `sender` and `recipient` cannot be the zero address.
232      * - `sender` must have a balance of at least `amount`.
233      * - the caller must have allowance for ``sender``'s tokens of at least
234      * `amount`.
235      */
236     function transferFrom(
237         address sender,
238         address recipient,
239         uint256 amount
240     ) public virtual override returns (bool) {
241         _transfer(sender, recipient, amount);
242 
243         uint256 currentAllowance = _allowances[sender][_msgSender()];
244         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
245         unchecked {
246             _approve(sender, _msgSender(), currentAllowance - amount);
247         }
248 
249         return true;
250     }
251 
252     /**
253      * @dev Moves `amount` of tokens from `sender` to `recipient`.
254      *
255      * This internal function is equivalent to {transfer}, and can be used to
256      * e.g. implement automatic token fees, slashing mechanisms, etc.
257      *
258      * Emits a {Transfer} event.
259      *
260      * Requirements:
261      *
262      * - `sender` cannot be the zero address.
263      * - `recipient` cannot be the zero address.
264      * - `sender` must have a balance of at least `amount`.
265      */
266     function _transfer(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) internal virtual {
271         require(sender != address(0), "ERC20: transfer from the zero address");
272         require(recipient != address(0), "ERC20: transfer to the zero address");
273 
274         _beforeTokenTransfer(sender, recipient, amount);
275 
276         uint256 senderBalance = _balances[sender];
277         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
278         unchecked {
279             _balances[sender] = senderBalance - amount;
280         }
281         _balances[recipient] += amount;
282 
283         emit Transfer(sender, recipient, amount);
284 
285         _afterTokenTransfer(sender, recipient, amount);
286     }
287 
288     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
289      * the total supply.
290      *
291      * Emits a {Transfer} event with `from` set to the zero address.
292      *
293      * Requirements:
294      *
295      * - `account` cannot be the zero address.
296      */
297     function _mint(address account, uint256 amount) internal virtual {
298         require(account != address(0), "ERC20: mint to the zero address");
299 
300         _beforeTokenTransfer(address(0), account, amount);
301 
302         _totalSupply += amount;
303         _balances[account] += amount;
304         emit Transfer(address(0), account, amount);
305 
306         _afterTokenTransfer(address(0), account, amount);
307     }
308 
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
312      *
313      * This internal function is equivalent to `approve`, and can be used to
314      * e.g. set automatic allowances for certain subsystems, etc.
315      *
316      * Emits an {Approval} event.
317      *
318      * Requirements:
319      *
320      * - `owner` cannot be the zero address.
321      * - `spender` cannot be the zero address.
322      */
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) internal virtual {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330 
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     /**
336      * @dev Hook that is called before any transfer of tokens. This includes
337      * minting and burning.
338      *
339      * Calling conditions:
340      *
341      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
342      * will be transferred to `to`.
343      * - when `from` is zero, `amount` tokens will be minted for `to`.
344      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
345      * - `from` and `to` are never both zero.
346      *
347      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
348      */
349     function _beforeTokenTransfer(
350         address from,
351         address to,
352         uint256 amount
353     ) internal virtual {}
354 
355     /**
356      * @dev Hook that is called after any transfer of tokens. This includes
357      * minting and burning.
358      *
359      * Calling conditions:
360      *
361      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
362      * has been transferred to `to`.
363      * - when `from` is zero, `amount` tokens have been minted for `to`.
364      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
365      * - `from` and `to` are never both zero.
366      *
367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
368      */
369     function _afterTokenTransfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {}
374 }
375 
376 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
377 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
378 
379 /* pragma solidity ^0.8.0; */
380 
381 // CAUTION
382 // This version of SafeMath should only be used with Solidity 0.8 or later,
383 // because it relies on the compiler's built in overflow checks.
384 
385 /**
386  * @dev Wrappers over Solidity's arithmetic operations.
387  *
388  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
389  * now has built in overflow checking.
390  */
391 library SafeMath {
392     /**
393      * @dev Returns the addition of two unsigned integers, with an overflow flag.
394      *
395      * _Available since v3.4._
396      */
397     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         unchecked {
399             uint256 c = a + b;
400             if (c < a) return (false, 0);
401             return (true, c);
402         }
403     }
404 
405     /**
406      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
407      *
408      * _Available since v3.4._
409      */
410     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
411         unchecked {
412             if (b > a) return (false, 0);
413             return (true, a - b);
414         }
415     }
416 
417     /**
418      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
419      *
420      * _Available since v3.4._
421      */
422     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
423         unchecked {
424             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425             // benefit is lost if 'b' is also tested.
426             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
427             if (a == 0) return (true, 0);
428             uint256 c = a * b;
429             if (c / a != b) return (false, 0);
430             return (true, c);
431         }
432     }
433 
434     /**
435      * @dev Returns the division of two unsigned integers, with a division by zero flag.
436      *
437      * _Available since v3.4._
438      */
439     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
440         unchecked {
441             if (b == 0) return (false, 0);
442             return (true, a / b);
443         }
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
448      *
449      * _Available since v3.4._
450      */
451     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
452         unchecked {
453             if (b == 0) return (false, 0);
454             return (true, a % b);
455         }
456     }
457 
458     /**
459      * @dev Returns the addition of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `+` operator.
463      *
464      * Requirements:
465      *
466      * - Addition cannot overflow.
467      */
468     function add(uint256 a, uint256 b) internal pure returns (uint256) {
469         return a + b;
470     }
471 
472     /**
473      * @dev Returns the subtraction of two unsigned integers, reverting on
474      * overflow (when the result is negative).
475      *
476      * Counterpart to Solidity's `-` operator.
477      *
478      * Requirements:
479      *
480      * - Subtraction cannot overflow.
481      */
482     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
483         return a - b;
484     }
485 
486     /**
487      * @dev Returns the multiplication of two unsigned integers, reverting on
488      * overflow.
489      *
490      * Counterpart to Solidity's `*` operator.
491      *
492      * Requirements:
493      *
494      * - Multiplication cannot overflow.
495      */
496     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
497         return a * b;
498     }
499 
500     /**
501      * @dev Returns the integer division of two unsigned integers, reverting on
502      * division by zero. The result is rounded towards zero.
503      *
504      * Counterpart to Solidity's `/` operator.
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function div(uint256 a, uint256 b) internal pure returns (uint256) {
511         return a / b;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * reverting when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         return a % b;
528     }
529 
530     /**
531      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
532      * overflow (when the result is negative).
533      *
534      * CAUTION: This function is deprecated because it requires allocating memory for the error
535      * message unnecessarily. For custom revert reasons use {trySub}.
536      *
537      * Counterpart to Solidity's `-` operator.
538      *
539      * Requirements:
540      *
541      * - Subtraction cannot overflow.
542      */
543     function sub(
544         uint256 a,
545         uint256 b,
546         string memory errorMessage
547     ) internal pure returns (uint256) {
548         unchecked {
549             require(b <= a, errorMessage);
550             return a - b;
551         }
552     }
553 
554     /**
555      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
556      * division by zero. The result is rounded towards zero.
557      *
558      * Counterpart to Solidity's `/` operator. Note: this function uses a
559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
560      * uses an invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(
567         uint256 a,
568         uint256 b,
569         string memory errorMessage
570     ) internal pure returns (uint256) {
571         unchecked {
572             require(b > 0, errorMessage);
573             return a / b;
574         }
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * reverting with custom message when dividing by zero.
580      *
581      * CAUTION: This function is deprecated because it requires allocating memory for the error
582      * message unnecessarily. For custom revert reasons use {tryMod}.
583      *
584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
585      * opcode (which leaves remaining gas untouched) while Solidity uses an
586      * invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function mod(
593         uint256 a,
594         uint256 b,
595         string memory errorMessage
596     ) internal pure returns (uint256) {
597         unchecked {
598             require(b > 0, errorMessage);
599             return a % b;
600         }
601     }
602 }
603 
604 interface IUniswapV2Factory {
605     event PairCreated(
606         address indexed token0,
607         address indexed token1,
608         address pair,
609         uint256
610     );
611 
612     function createPair(address tokenA, address tokenB)
613         external
614         returns (address pair);
615 }
616 
617 interface IUniswapV2Router02 {
618     function factory() external pure returns (address);
619 
620     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
621         uint256 amountIn,
622         uint256 amountOutMin,
623         address[] calldata path,
624         address to,
625         uint256 deadline
626     ) external;
627 }
628 
629 contract kujira  is ERC20, Ownable {
630     using SafeMath for uint256;
631 
632     IUniswapV2Router02 public immutable uniswapV2Router;
633     address public immutable uniswapV2Pair;
634     address public constant deadAddress = address(0xdead);
635     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
636 
637     bool private swapping;
638 
639     address public devWallet;
640 
641     uint256 public maxTransactionAmount;
642     uint256 public swapTokensAtAmount;
643     uint256 public maxWallet;
644 
645     bool public limitsInEffect = true;
646     bool public tradingActive = false;
647     bool public swapEnabled = false;
648 
649     uint256 public buyTotalFees;
650     uint256 public buyDevFee;
651     uint256 public buyLiquidityFee;
652 
653     uint256 public sellTotalFees;
654     uint256 public sellDevFee;
655     uint256 public sellLiquidityFee;
656 
657     /******************/
658 
659     // exlcude from fees and max transaction amount
660     mapping(address => bool) private _isExcludedFromFees;
661     mapping(address => bool) public _isExcludedMaxTransactionAmount;
662 
663 
664     event ExcludeFromFees(address indexed account, bool isExcluded);
665 
666     event devWalletUpdated(
667         address indexed newWallet,
668         address indexed oldWallet
669     );
670 
671     constructor() ERC20("Kujira", "KUJIRA") {
672         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
673 
674         excludeFromMaxTransaction(address(_uniswapV2Router), true);
675         uniswapV2Router = _uniswapV2Router;
676 
677         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
678             .createPair(address(this), WETH);
679         excludeFromMaxTransaction(address(uniswapV2Pair), true);
680 
681 
682         uint256 _buyDevFee = 2;
683         uint256 _buyLiquidityFee = 1;
684 
685         uint256 _sellDevFee = 2;
686         uint256 _sellLiquidityFee = 1;
687 
688         uint256 totalSupply = 100_000_000_000 * 1e18;
689 
690         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
691         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
692         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
693 
694         buyDevFee = _buyDevFee;
695         buyLiquidityFee = _buyLiquidityFee;
696         buyTotalFees = buyDevFee + buyLiquidityFee;
697 
698         sellDevFee = _sellDevFee;
699         sellLiquidityFee = _sellLiquidityFee;
700         sellTotalFees = sellDevFee + sellLiquidityFee;
701 
702         devWallet = address(0x134Ab8a3Bc0dDAcAe9161F3D1666E8873cAF255b); // set as dev wallet
703 
704         // exclude from paying fees or having max transaction amount
705         excludeFromFees(owner(), true);
706         excludeFromFees(address(this), true);
707         excludeFromFees(address(0xdead), true);
708 
709         excludeFromMaxTransaction(owner(), true);
710         excludeFromMaxTransaction(address(this), true);
711         excludeFromMaxTransaction(address(0xdead), true);
712 
713         /*
714             _mint is an internal function in ERC20.sol that is only called here,
715             and CANNOT be called ever again
716         */
717         _mint(msg.sender, totalSupply);
718     }
719 
720     receive() external payable {}
721 
722     // once enabled, can never be turned off
723     function enableTrading() external onlyOwner {
724         tradingActive = true;
725         swapEnabled = true;
726     }
727 
728     // remove limits after token is stable
729     function removeLimits() external onlyOwner returns (bool) {
730         limitsInEffect = false;
731         return true;
732     }
733 
734     // change the minimum amount of tokens to sell from fees
735     function updateSwapTokensAtAmount(uint256 newAmount)
736         external
737         onlyOwner
738         returns (bool)
739     {
740         require(
741             newAmount >= (totalSupply() * 1) / 100000,
742             "Swap amount cannot be lower than 0.001% total supply."
743         );
744         require(
745             newAmount <= (totalSupply() * 5) / 1000,
746             "Swap amount cannot be higher than 0.5% total supply."
747         );
748         swapTokensAtAmount = newAmount;
749         return true;
750     }
751 
752     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
753         require(
754             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
755             "Cannot set maxTransactionAmount lower than 0.1%"
756         );
757         maxTransactionAmount = newNum * (10**18);
758     }
759 
760     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
761         require(
762             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
763             "Cannot set maxWallet lower than 0.5%"
764         );
765         maxWallet = newNum * (10**18);
766     }
767 
768     function excludeFromMaxTransaction(address updAds, bool isEx)
769         public
770         onlyOwner
771     {
772         _isExcludedMaxTransactionAmount[updAds] = isEx;
773     }
774 
775     // only use to disable contract sales if absolutely necessary (emergency use only)
776     function updateSwapEnabled(bool enabled) external onlyOwner {
777         swapEnabled = enabled;
778     }
779 
780     function updateBuyFees(
781         uint256 _devFee,
782         uint256 _liquidityFee
783     ) external onlyOwner {
784         buyDevFee = _devFee;
785         buyLiquidityFee = _liquidityFee;
786         buyTotalFees = buyDevFee + buyLiquidityFee;
787         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
788     }
789 
790     function updateSellFees(
791         uint256 _devFee,
792         uint256 _liquidityFee
793     ) external onlyOwner {
794         sellDevFee = _devFee;
795         sellLiquidityFee = _liquidityFee;
796         sellTotalFees = sellDevFee + sellLiquidityFee;
797         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
798     }
799 
800     function excludeFromFees(address account, bool excluded) public onlyOwner {
801         _isExcludedFromFees[account] = excluded;
802         emit ExcludeFromFees(account, excluded);
803     }
804 
805     function updateDevWallet(address newDevWallet)
806         external
807         onlyOwner
808     {
809         emit devWalletUpdated(newDevWallet, devWallet);
810         devWallet = newDevWallet;
811     }
812 
813 
814     function isExcludedFromFees(address account) public view returns (bool) {
815         return _isExcludedFromFees[account];
816     }
817 
818     function _transfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal override {
823         require(from != address(0), "ERC20: transfer from the zero address");
824         require(to != address(0), "ERC20: transfer to the zero address");
825 
826         if (amount == 0) {
827             super._transfer(from, to, 0);
828             return;
829         }
830 
831         if (limitsInEffect) {
832             if (
833                 from != owner() &&
834                 to != owner() &&
835                 to != address(0) &&
836                 to != address(0xdead) &&
837                 !swapping
838             ) {
839                 if (!tradingActive) {
840                     require(
841                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
842                         "Trading is not active."
843                     );
844                 }
845 
846                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
847                 //when buy
848                 if (
849                     from == uniswapV2Pair &&
850                     !_isExcludedMaxTransactionAmount[to]
851                 ) {
852                     require(
853                         amount <= maxTransactionAmount,
854                         "Buy transfer amount exceeds the maxTransactionAmount."
855                     );
856                     require(
857                         amount + balanceOf(to) <= maxWallet,
858                         "Max wallet exceeded"
859                     );
860                 }
861                 else if (!_isExcludedMaxTransactionAmount[to]) {
862                     require(
863                         amount + balanceOf(to) <= maxWallet,
864                         "Max wallet exceeded"
865                     );
866                 }
867             }
868         }
869 
870         uint256 contractTokenBalance = balanceOf(address(this));
871 
872         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
873 
874         if (
875             canSwap &&
876             swapEnabled &&
877             !swapping &&
878             to == uniswapV2Pair &&
879             !_isExcludedFromFees[from] &&
880             !_isExcludedFromFees[to]
881         ) {
882             swapping = true;
883 
884             swapBack();
885 
886             swapping = false;
887         }
888 
889         bool takeFee = !swapping;
890 
891         // if any account belongs to _isExcludedFromFee account then remove the fee
892         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
893             takeFee = false;
894         }
895 
896         uint256 fees = 0;
897         uint256 tokensForLiquidity = 0;
898         uint256 tokensForDev = 0;
899         // only take fees on buys/sells, do not take on wallet transfers
900         if (takeFee) {
901             // on sell
902             if (to == uniswapV2Pair && sellTotalFees > 0) {
903                 fees = amount.mul(sellTotalFees).div(100);
904                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
905                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
906             }
907             // on buy
908             else if (from == uniswapV2Pair && buyTotalFees > 0) {
909                 fees = amount.mul(buyTotalFees).div(100);
910                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
911                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
912             }
913 
914             if (fees> 0) {
915                 super._transfer(from, address(this), fees);
916             }
917             if (tokensForLiquidity > 0) {
918                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
919             }
920 
921             amount -= fees;
922         }
923 
924         super._transfer(from, to, amount);
925     }
926 
927     function swapTokensForETH(uint256 tokenAmount) private {
928         // generate the uniswap pair path of token -> weth
929         address[] memory path = new address[](2);
930         path[0] = address(this);
931         path[1] = WETH;
932 
933         _approve(address(this), address(uniswapV2Router), tokenAmount);
934 
935         // make the swap
936         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
937             tokenAmount,
938             0, // accept any amount of ETH
939             path,
940             devWallet,
941             block.timestamp
942         );
943     }
944 
945     function swapBack() private {
946         uint256 contractBalance = balanceOf(address(this));
947         if (contractBalance == 0) {
948             return;
949         }
950 
951         if (contractBalance > swapTokensAtAmount * 20) {
952             contractBalance = swapTokensAtAmount * 20;
953         }
954 
955         swapTokensForETH(contractBalance);
956     }
957 
958 }