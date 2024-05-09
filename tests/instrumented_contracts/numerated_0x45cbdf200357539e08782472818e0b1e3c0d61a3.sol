1 /*
2 
3 1/1 tax for teh $Treat Community
4 1/1 tax to strenghen the liquidity
5 
6 
7 we are nearer then you think...
8 */
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.10;
11 pragma experimental ABIEncoderV2;
12 
13 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
27 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
28 
29 /* pragma solidity ^0.8.0; */
30 
31 /* import "../utils/Context.sol"; */
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _transferOwnership(_msgSender());
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(owner() == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     /**
61      * @dev Leaves the contract without owner. It will not be possible to call
62      * `onlyOwner` functions anymore. Can only be called by the current owner.
63      *
64      * NOTE: Renouncing ownership will leave the contract without an owner,
65      * thereby removing any functionality that is only available to the owner.
66      */
67     function renounceOwnership() public virtual onlyOwner {
68         _transferOwnership(address(0));
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _transferOwnership(newOwner);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Internal function without access restriction.
83      */
84     function _transferOwnership(address newOwner) internal virtual {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
92 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
93 
94 /* pragma solidity ^0.8.0; */
95 
96 /**
97  * @dev Interface of the ERC20 standard as defined in the EIP.
98  */
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158 
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
175 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
176 
177 /* pragma solidity ^0.8.0; */
178 
179 /* import "../IERC20.sol"; */
180 
181 /**
182  * @dev Interface for the optional metadata functions from the ERC20 standard.
183  *
184  * _Available since v4.1._
185  */
186 interface IERC20Metadata is IERC20 {
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the symbol of the token.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the decimals places of the token.
199      */
200     function decimals() external view returns (uint8);
201 }
202 
203 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
204 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
205 
206 /* pragma solidity ^0.8.0; */
207 
208 /* import "./IERC20.sol"; */
209 /* import "./extensions/IERC20Metadata.sol"; */
210 /* import "../../utils/Context.sol"; */
211 
212 /**
213  * @dev Implementation of the {IERC20} interface.
214  *
215  * This implementation is agnostic to the way tokens are created. This means
216  * that a supply mechanism has to be added in a derived contract using {_mint}.
217  * For a generic mechanism see {ERC20PresetMinterPauser}.
218  *
219  * TIP: For a detailed writeup see our guide
220  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
221  * to implement supply mechanisms].
222  *
223  * We have followed general OpenZeppelin Contracts guidelines: functions revert
224  * instead returning `false` on failure. This behavior is nonetheless
225  * conventional and does not conflict with the expectations of ERC20
226  * applications.
227  *
228  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See {IERC20-approve}.
236  */
237 contract ERC20 is Context, IERC20, IERC20Metadata {
238     mapping(address => uint256) private _balances;
239 
240     mapping(address => mapping(address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246 
247     /**
248      * @dev Sets the values for {name} and {symbol}.
249      *
250      * The default value of {decimals} is 18. To select a different value for
251      * {decimals} you should overload it.
252      *
253      * All two of these values are immutable: they can only be set once during
254      * construction.
255      */
256     constructor(string memory name_, string memory symbol_) {
257         _name = name_;
258         _symbol = symbol_;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view virtual override returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view virtual override returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei. This is the value {ERC20} uses, unless this function is
283      * overridden;
284      *
285      * NOTE: This information is only used for _display_ purposes: it in
286      * no way affects any of the arithmetic of the contract, including
287      * {IERC20-balanceOf} and {IERC20-transfer}.
288      */
289     function decimals() public view virtual override returns (uint8) {
290         return 18;
291     }
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view virtual override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view virtual override returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view virtual override returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20}.
344      *
345      * Requirements:
346      *
347      * - `sender` and `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      * - the caller must have allowance for ``sender``'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(
353         address sender,
354         address recipient,
355         uint256 amount
356     ) public virtual override returns (bool) {
357         _transfer(sender, recipient, amount);
358 
359         uint256 currentAllowance = _allowances[sender][_msgSender()];
360         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
361         unchecked {
362             _approve(sender, _msgSender(), currentAllowance - amount);
363         }
364 
365         return true;
366     }
367 
368     /**
369      * @dev Moves `amount` of tokens from `sender` to `recipient`.
370      *
371      * This internal function is equivalent to {transfer}, and can be used to
372      * e.g. implement automatic token fees, slashing mechanisms, etc.
373      *
374      * Emits a {Transfer} event.
375      *
376      * Requirements:
377      *
378      * - `sender` cannot be the zero address.
379      * - `recipient` cannot be the zero address.
380      * - `sender` must have a balance of at least `amount`.
381      */
382     function _transfer(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) internal virtual {
387         require(sender != address(0), "ERC20: transfer from the zero address");
388         require(recipient != address(0), "ERC20: transfer to the zero address");
389 
390         _beforeTokenTransfer(sender, recipient, amount);
391 
392         uint256 senderBalance = _balances[sender];
393         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
394         unchecked {
395             _balances[sender] = senderBalance - amount;
396         }
397         _balances[recipient] += amount;
398 
399         emit Transfer(sender, recipient, amount);
400 
401         _afterTokenTransfer(sender, recipient, amount);
402     }
403 
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415 
416         _beforeTokenTransfer(address(0), account, amount);
417 
418         _totalSupply += amount;
419         _balances[account] += amount;
420         emit Transfer(address(0), account, amount);
421 
422         _afterTokenTransfer(address(0), account, amount);
423     }
424 
425 
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
428      *
429      * This internal function is equivalent to `approve`, and can be used to
430      * e.g. set automatic allowances for certain subsystems, etc.
431      *
432      * Emits an {Approval} event.
433      *
434      * Requirements:
435      *
436      * - `owner` cannot be the zero address.
437      * - `spender` cannot be the zero address.
438      */
439     function _approve(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446 
447         _allowances[owner][spender] = amount;
448         emit Approval(owner, spender, amount);
449     }
450 
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 
471     /**
472      * @dev Hook that is called after any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * has been transferred to `to`.
479      * - when `from` is zero, `amount` tokens have been minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _afterTokenTransfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {}
490 }
491 
492 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
493 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
494 
495 /* pragma solidity ^0.8.0; */
496 
497 // CAUTION
498 // This version of SafeMath should only be used with Solidity 0.8 or later,
499 // because it relies on the compiler's built in overflow checks.
500 
501 /**
502  * @dev Wrappers over Solidity's arithmetic operations.
503  *
504  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
505  * now has built in overflow checking.
506  */
507 library SafeMath {
508     /**
509      * @dev Returns the addition of two unsigned integers, with an overflow flag.
510      *
511      * _Available since v3.4._
512      */
513     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
514         unchecked {
515             uint256 c = a + b;
516             if (c < a) return (false, 0);
517             return (true, c);
518         }
519     }
520 
521     /**
522      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
523      *
524      * _Available since v3.4._
525      */
526     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
527         unchecked {
528             if (b > a) return (false, 0);
529             return (true, a - b);
530         }
531     }
532 
533     /**
534      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
535      *
536      * _Available since v3.4._
537      */
538     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
541             // benefit is lost if 'b' is also tested.
542             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
543             if (a == 0) return (true, 0);
544             uint256 c = a * b;
545             if (c / a != b) return (false, 0);
546             return (true, c);
547         }
548     }
549 
550     /**
551      * @dev Returns the division of two unsigned integers, with a division by zero flag.
552      *
553      * _Available since v3.4._
554      */
555     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         unchecked {
557             if (b == 0) return (false, 0);
558             return (true, a / b);
559         }
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
564      *
565      * _Available since v3.4._
566      */
567     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
568         unchecked {
569             if (b == 0) return (false, 0);
570             return (true, a % b);
571         }
572     }
573 
574     /**
575      * @dev Returns the addition of two unsigned integers, reverting on
576      * overflow.
577      *
578      * Counterpart to Solidity's `+` operator.
579      *
580      * Requirements:
581      *
582      * - Addition cannot overflow.
583      */
584     function add(uint256 a, uint256 b) internal pure returns (uint256) {
585         return a + b;
586     }
587 
588     /**
589      * @dev Returns the subtraction of two unsigned integers, reverting on
590      * overflow (when the result is negative).
591      *
592      * Counterpart to Solidity's `-` operator.
593      *
594      * Requirements:
595      *
596      * - Subtraction cannot overflow.
597      */
598     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
599         return a - b;
600     }
601 
602     /**
603      * @dev Returns the multiplication of two unsigned integers, reverting on
604      * overflow.
605      *
606      * Counterpart to Solidity's `*` operator.
607      *
608      * Requirements:
609      *
610      * - Multiplication cannot overflow.
611      */
612     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613         return a * b;
614     }
615 
616     /**
617      * @dev Returns the integer division of two unsigned integers, reverting on
618      * division by zero. The result is rounded towards zero.
619      *
620      * Counterpart to Solidity's `/` operator.
621      *
622      * Requirements:
623      *
624      * - The divisor cannot be zero.
625      */
626     function div(uint256 a, uint256 b) internal pure returns (uint256) {
627         return a / b;
628     }
629 
630     /**
631      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
632      * reverting when dividing by zero.
633      *
634      * Counterpart to Solidity's `%` operator. This function uses a `revert`
635      * opcode (which leaves remaining gas untouched) while Solidity uses an
636      * invalid opcode to revert (consuming all remaining gas).
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a % b;
644     }
645 
646     /**
647      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
648      * overflow (when the result is negative).
649      *
650      * CAUTION: This function is deprecated because it requires allocating memory for the error
651      * message unnecessarily. For custom revert reasons use {trySub}.
652      *
653      * Counterpart to Solidity's `-` operator.
654      *
655      * Requirements:
656      *
657      * - Subtraction cannot overflow.
658      */
659     function sub(
660         uint256 a,
661         uint256 b,
662         string memory errorMessage
663     ) internal pure returns (uint256) {
664         unchecked {
665             require(b <= a, errorMessage);
666             return a - b;
667         }
668     }
669 
670     /**
671      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
672      * division by zero. The result is rounded towards zero.
673      *
674      * Counterpart to Solidity's `/` operator. Note: this function uses a
675      * `revert` opcode (which leaves remaining gas untouched) while Solidity
676      * uses an invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function div(
683         uint256 a,
684         uint256 b,
685         string memory errorMessage
686     ) internal pure returns (uint256) {
687         unchecked {
688             require(b > 0, errorMessage);
689             return a / b;
690         }
691     }
692 
693     /**
694      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
695      * reverting with custom message when dividing by zero.
696      *
697      * CAUTION: This function is deprecated because it requires allocating memory for the error
698      * message unnecessarily. For custom revert reasons use {tryMod}.
699      *
700      * Counterpart to Solidity's `%` operator. This function uses a `revert`
701      * opcode (which leaves remaining gas untouched) while Solidity uses an
702      * invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function mod(
709         uint256 a,
710         uint256 b,
711         string memory errorMessage
712     ) internal pure returns (uint256) {
713         unchecked {
714             require(b > 0, errorMessage);
715             return a % b;
716         }
717     }
718 }
719 
720 interface IUniswapV2Factory {
721     event PairCreated(
722         address indexed token0,
723         address indexed token1,
724         address pair,
725         uint256
726     );
727 
728     function createPair(address tokenA, address tokenB)
729         external
730         returns (address pair);
731 }
732 
733 interface IUniswapV2Router02 {
734     function factory() external pure returns (address);
735 
736     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
737         uint256 amountIn,
738         uint256 amountOutMin,
739         address[] calldata path,
740         address to,
741         uint256 deadline
742     ) external;
743 }
744 
745 contract SHI is ERC20, Ownable {
746     using SafeMath for uint256;
747 
748     IUniswapV2Router02 public immutable uniswapV2Router;
749     address public immutable uniswapV2Pair;
750     address public constant deadAddress = address(0xdead);
751     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
752 
753     bool private swapping;
754 
755     address public devWallet;
756 
757     uint256 public maxTransactionAmount;
758     uint256 public swapTokensAtAmount;
759     uint256 public maxWallet;
760 
761     bool public limitsInEffect = true;
762     bool public tradingActive = false;
763     bool public swapEnabled = false;
764 
765     uint256 public buyTotalFees;
766     uint256 public buyDevFee;
767     uint256 public buyLiquidityFee;
768 
769     uint256 public sellTotalFees;
770     uint256 public sellDevFee;
771     uint256 public sellLiquidityFee;
772 
773     /******************/
774 
775     // exlcude from fees and max transaction amount
776     mapping(address => bool) private _isExcludedFromFees;
777     mapping(address => bool) public _isExcludedMaxTransactionAmount;
778 
779 
780     event ExcludeFromFees(address indexed account, bool isExcluded);
781 
782     event devWalletUpdated(
783         address indexed newWallet,
784         address indexed oldWallet
785     );
786 
787     constructor() ERC20("SHI", "SHI") {
788         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
789             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
790         );
791 
792         excludeFromMaxTransaction(address(_uniswapV2Router), true);
793         uniswapV2Router = _uniswapV2Router;
794 
795         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
796             .createPair(address(this), USDC);
797         excludeFromMaxTransaction(address(uniswapV2Pair), true);
798 
799 
800         uint256 _buyDevFee = 10;
801         uint256 _buyLiquidityFee = 5;
802 
803         uint256 _sellDevFee = 45;
804         uint256 _sellLiquidityFee = 5;
805 
806         uint256 totalSupply = 999_999_999 * 1e18;
807 
808         maxTransactionAmount =  totalSupply * 1 / 100; // 1% from total supply maxTransactionAmountTxn
809         maxWallet = totalSupply * 1 / 100; // 1% from total supply maxWallet
810         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
811 
812         buyDevFee = _buyDevFee;
813         buyLiquidityFee = _buyLiquidityFee;
814         buyTotalFees = buyDevFee + buyLiquidityFee;
815 
816         sellDevFee = _sellDevFee;
817         sellLiquidityFee = _sellLiquidityFee;
818         sellTotalFees = sellDevFee + sellLiquidityFee;
819 
820         devWallet = address(0xC4d729d5c30073bCc31513bEBA2AeC00561a48B3); // set as dev wallet
821 
822         // exclude from paying fees or having max transaction amount
823         excludeFromFees(owner(), true);
824         excludeFromFees(address(this), true);
825         excludeFromFees(address(0xdead), true);
826 
827         excludeFromMaxTransaction(owner(), true);
828         excludeFromMaxTransaction(address(this), true);
829         excludeFromMaxTransaction(address(0xdead), true);
830 
831         /*
832             _mint is an internal function in ERC20.sol that is only called here,
833             and CANNOT be called ever again
834         */
835         _mint(msg.sender, totalSupply);
836     }
837 
838     receive() external payable {}
839 
840     // once enabled, can never be turned off
841     function enableTrading() external onlyOwner {
842         tradingActive = true;
843         swapEnabled = true;
844     }
845 
846     // remove limits after token is stable
847     function removeLimits() external onlyOwner returns (bool) {
848         limitsInEffect = false;
849         return true;
850     }
851 
852     // change the minimum amount of tokens to sell from fees
853     function updateSwapTokensAtAmount(uint256 newAmount)
854         external
855         onlyOwner
856         returns (bool)
857     {
858         require(
859             newAmount >= (totalSupply() * 1) / 100000,
860             "Swap amount cannot be lower than 0.001% total supply."
861         );
862         require(
863             newAmount <= (totalSupply() * 5) / 1000,
864             "Swap amount cannot be higher than 0.5% total supply."
865         );
866         swapTokensAtAmount = newAmount;
867         return true;
868     }
869 
870     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
871         require(
872             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
873             "Cannot set maxTransactionAmount lower than 0.1%"
874         );
875         maxTransactionAmount = newNum * (10**18);
876     }
877 
878     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
879         require(
880             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
881             "Cannot set maxWallet lower than 0.5%"
882         );
883         maxWallet = newNum * (10**18);
884     }
885 
886     function excludeFromMaxTransaction(address updAds, bool isEx)
887         public
888         onlyOwner
889     {
890         _isExcludedMaxTransactionAmount[updAds] = isEx;
891     }
892 
893     // only use to disable contract sales if absolutely necessary (emergency use only)
894     function updateSwapEnabled(bool enabled) external onlyOwner {
895         swapEnabled = enabled;
896     }
897 
898     function updateBuyFees(
899         uint256 _devFee,
900         uint256 _liquidityFee
901     ) external onlyOwner {
902         buyDevFee = _devFee;
903         buyLiquidityFee = _liquidityFee;
904         buyTotalFees = buyDevFee + buyLiquidityFee;
905         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
906     }
907 
908     function updateSellFees(
909         uint256 _devFee,
910         uint256 _liquidityFee
911     ) external onlyOwner {
912         sellDevFee = _devFee;
913         sellLiquidityFee = _liquidityFee;
914         sellTotalFees = sellDevFee + sellLiquidityFee;
915         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
916     }
917 
918     function excludeFromFees(address account, bool excluded) public onlyOwner {
919         _isExcludedFromFees[account] = excluded;
920         emit ExcludeFromFees(account, excluded);
921     }
922 
923     function updateDevWallet(address newDevWallet)
924         external
925         onlyOwner
926     {
927         emit devWalletUpdated(newDevWallet, devWallet);
928         devWallet = newDevWallet;
929     }
930 
931 
932     function isExcludedFromFees(address account) public view returns (bool) {
933         return _isExcludedFromFees[account];
934     }
935 
936     function _transfer(
937         address from,
938         address to,
939         uint256 amount
940     ) internal override {
941         require(from != address(0), "ERC20: transfer from the zero address");
942         require(to != address(0), "ERC20: transfer to the zero address");
943 
944         if (amount == 0) {
945             super._transfer(from, to, 0);
946             return;
947         }
948 
949         if (limitsInEffect) {
950             if (
951                 from != owner() &&
952                 to != owner() &&
953                 to != address(0) &&
954                 to != address(0xdead) &&
955                 !swapping
956             ) {
957                 if (!tradingActive) {
958                     require(
959                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
960                         "Trading is not active."
961                     );
962                 }
963 
964                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
965                 //when buy
966                 if (
967                     from == uniswapV2Pair &&
968                     !_isExcludedMaxTransactionAmount[to]
969                 ) {
970                     require(
971                         amount <= maxTransactionAmount,
972                         "Buy transfer amount exceeds the maxTransactionAmount."
973                     );
974                     require(
975                         amount + balanceOf(to) <= maxWallet,
976                         "Max wallet exceeded"
977                     );
978                 }
979                 else if (!_isExcludedMaxTransactionAmount[to]) {
980                     require(
981                         amount + balanceOf(to) <= maxWallet,
982                         "Max wallet exceeded"
983                     );
984                 }
985             }
986         }
987 
988         uint256 contractTokenBalance = balanceOf(address(this));
989 
990         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
991 
992         if (
993             canSwap &&
994             swapEnabled &&
995             !swapping &&
996             to == uniswapV2Pair &&
997             !_isExcludedFromFees[from] &&
998             !_isExcludedFromFees[to]
999         ) {
1000             swapping = true;
1001 
1002             swapBack();
1003 
1004             swapping = false;
1005         }
1006 
1007         bool takeFee = !swapping;
1008 
1009         // if any account belongs to _isExcludedFromFee account then remove the fee
1010         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1011             takeFee = false;
1012         }
1013 
1014         uint256 fees = 0;
1015         uint256 tokensForLiquidity = 0;
1016         uint256 tokensForDev = 0;
1017         // only take fees on buys/sells, do not take on wallet transfers
1018         if (takeFee) {
1019             // on sell
1020             if (to == uniswapV2Pair && sellTotalFees > 0) {
1021                 fees = amount.mul(sellTotalFees).div(100);
1022                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1023                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1024             }
1025             // on buy
1026             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1027                 fees = amount.mul(buyTotalFees).div(100);
1028                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1029                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1030             }
1031 
1032             if (fees> 0) {
1033                 super._transfer(from, address(this), fees);
1034             }
1035             if (tokensForLiquidity > 0) {
1036                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1037             }
1038 
1039             amount -= fees;
1040         }
1041 
1042         super._transfer(from, to, amount);
1043     }
1044 
1045     function swapTokensForUSDC(uint256 tokenAmount) private {
1046         // generate the uniswap pair path of token -> weth
1047         address[] memory path = new address[](2);
1048         path[0] = address(this);
1049         path[1] = USDC;
1050 
1051         _approve(address(this), address(uniswapV2Router), tokenAmount);
1052 
1053         // make the swap
1054         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1055             tokenAmount,
1056             0, // accept any amount of USDC
1057             path,
1058             devWallet,
1059             block.timestamp
1060         );
1061     }
1062 
1063     function swapBack() private {
1064         uint256 contractBalance = balanceOf(address(this));
1065         if (contractBalance == 0) {
1066             return;
1067         }
1068 
1069         if (contractBalance > swapTokensAtAmount * 20) {
1070             contractBalance = swapTokensAtAmount * 20;
1071         }
1072 
1073         swapTokensForUSDC(contractBalance);
1074     }
1075 
1076 }