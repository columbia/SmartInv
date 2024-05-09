1 /**
2 
3 Paranoia — project addressing misperceptions growing around the celebrated tech 
4 in financial circles, blockchain.
5 
6 "Your mind is working at its best when you're being paranoid. You explore 
7 every avenue and possibilty of your situation at high speed with total clarity."
8 
9 Read manifesto here:
10 https://paranoiawake.com
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.10;
16 pragma experimental ABIEncoderV2;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to {approve}. `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 /**
209  * @dev Implementation of the {IERC20} interface.
210  *
211  * This implementation is agnostic to the way tokens are created. This means
212  * that a supply mechanism has to be added in a derived contract using {_mint}.
213  * For a generic mechanism see {ERC20PresetMinterPauser}.
214  *
215  * TIP: For a detailed writeup see our guide
216  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
217  * to implement supply mechanisms].
218  *
219  * We have followed general OpenZeppelin Contracts guidelines: functions revert
220  * instead returning `false` on failure. This behavior is nonetheless
221  * conventional and does not conflict with the expectations of ERC20
222  * applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract ERC20 is Context, IERC20, IERC20Metadata {
234     mapping(address => uint256) private _balances;
235 
236     mapping(address => mapping(address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The default value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) {
253         _name = name_;
254         _symbol = symbol_;
255     }
256 
257     /**
258      * @dev Returns the name of the token.
259      */
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @dev Returns the symbol of the token, usually a shorter version of the
266      * name.
267      */
268     function symbol() public view virtual override returns (string memory) {
269         return _symbol;
270     }
271 
272     /**
273      * @dev Returns the number of decimals used to get its user representation.
274      * For example, if `decimals` equals `2`, a balance of `505` tokens should
275      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
276      *
277      * Tokens usually opt for a value of 18, imitating the relationship between
278      * Ether and Wei. This is the value {ERC20} uses, unless this function is
279      * overridden;
280      *
281      * NOTE: This information is only used for _display_ purposes: it in
282      * no way affects any of the arithmetic of the contract, including
283      * {IERC20-balanceOf} and {IERC20-transfer}.
284      */
285     function decimals() public view virtual override returns (uint8) {
286         return 18;
287     }
288 
289     /**
290      * @dev See {IERC20-totalSupply}.
291      */
292     function totalSupply() public view virtual override returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev See {IERC20-balanceOf}.
298      */
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `recipient` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
312         _transfer(_msgSender(), recipient, amount);
313         return true;
314     }
315 
316     /**
317      * @dev See {IERC20-allowance}.
318      */
319     function allowance(address owner, address spender) public view virtual override returns (uint256) {
320         return _allowances[owner][spender];
321     }
322 
323     /**
324      * @dev See {IERC20-approve}.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         _approve(_msgSender(), spender, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-transferFrom}.
337      *
338      * Emits an {Approval} event indicating the updated allowance. This is not
339      * required by the EIP. See the note at the beginning of {ERC20}.
340      *
341      * Requirements:
342      *
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      * - the caller must have allowance for ``sender``'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354 
355         uint256 currentAllowance = _allowances[sender][_msgSender()];
356         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
357         unchecked {
358             _approve(sender, _msgSender(), currentAllowance - amount);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Moves `amount` of tokens from `sender` to `recipient`.
366      *
367      * This internal function is equivalent to {transfer}, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a {Transfer} event.
371      *
372      * Requirements:
373      *
374      * - `sender` cannot be the zero address.
375      * - `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      */
378     function _transfer(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) internal virtual {
383         require(sender != address(0), "ERC20: transfer from the zero address");
384         require(recipient != address(0), "ERC20: transfer to the zero address");
385 
386         _beforeTokenTransfer(sender, recipient, amount);
387 
388         uint256 senderBalance = _balances[sender];
389         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[sender] = senderBalance - amount;
392         }
393         _balances[recipient] += amount;
394 
395         emit Transfer(sender, recipient, amount);
396 
397         _afterTokenTransfer(sender, recipient, amount);
398     }
399 
400     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
401      * the total supply.
402      *
403      * Emits a {Transfer} event with `from` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      */
409     function _mint(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: mint to the zero address");
411 
412         _beforeTokenTransfer(address(0), account, amount);
413 
414         _totalSupply += amount;
415         _balances[account] += amount;
416         emit Transfer(address(0), account, amount);
417 
418         _afterTokenTransfer(address(0), account, amount);
419     }
420 
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442 
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446 
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 
467     /**
468      * @dev Hook that is called after any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * has been transferred to `to`.
475      * - when `from` is zero, `amount` tokens have been minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _afterTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 }
487 
488 /**
489  * @dev Wrappers over Solidity's arithmetic operations.
490  *
491  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
492  * now has built in overflow checking.
493  */
494 library SafeMath {
495     /**
496      * @dev Returns the addition of two unsigned integers, with an overflow flag.
497      *
498      * _Available since v3.4._
499      */
500     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
501         unchecked {
502             uint256 c = a + b;
503             if (c < a) return (false, 0);
504             return (true, c);
505         }
506     }
507 
508     /**
509      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
510      *
511      * _Available since v3.4._
512      */
513     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
514         unchecked {
515             if (b > a) return (false, 0);
516             return (true, a - b);
517         }
518     }
519 
520     /**
521      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
522      *
523      * _Available since v3.4._
524      */
525     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
526         unchecked {
527             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
528             // benefit is lost if 'b' is also tested.
529             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
530             if (a == 0) return (true, 0);
531             uint256 c = a * b;
532             if (c / a != b) return (false, 0);
533             return (true, c);
534         }
535     }
536 
537     /**
538      * @dev Returns the division of two unsigned integers, with a division by zero flag.
539      *
540      * _Available since v3.4._
541      */
542     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
543         unchecked {
544             if (b == 0) return (false, 0);
545             return (true, a / b);
546         }
547     }
548 
549     /**
550      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             if (b == 0) return (false, 0);
557             return (true, a % b);
558         }
559     }
560 
561     /**
562      * @dev Returns the addition of two unsigned integers, reverting on
563      * overflow.
564      *
565      * Counterpart to Solidity's `+` operator.
566      *
567      * Requirements:
568      *
569      * - Addition cannot overflow.
570      */
571     function add(uint256 a, uint256 b) internal pure returns (uint256) {
572         return a + b;
573     }
574 
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting on
577      * overflow (when the result is negative).
578      *
579      * Counterpart to Solidity's `-` operator.
580      *
581      * Requirements:
582      *
583      * - Subtraction cannot overflow.
584      */
585     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
586         return a - b;
587     }
588 
589     /**
590      * @dev Returns the multiplication of two unsigned integers, reverting on
591      * overflow.
592      *
593      * Counterpart to Solidity's `*` operator.
594      *
595      * Requirements:
596      *
597      * - Multiplication cannot overflow.
598      */
599     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
600         return a * b;
601     }
602 
603     /**
604      * @dev Returns the integer division of two unsigned integers, reverting on
605      * division by zero. The result is rounded towards zero.
606      *
607      * Counterpart to Solidity's `/` operator.
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function div(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a / b;
615     }
616 
617     /**
618      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
619      * reverting when dividing by zero.
620      *
621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
622      * opcode (which leaves remaining gas untouched) while Solidity uses an
623      * invalid opcode to revert (consuming all remaining gas).
624      *
625      * Requirements:
626      *
627      * - The divisor cannot be zero.
628      */
629     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a % b;
631     }
632 
633     /**
634      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
635      * overflow (when the result is negative).
636      *
637      * CAUTION: This function is deprecated because it requires allocating memory for the error
638      * message unnecessarily. For custom revert reasons use {trySub}.
639      *
640      * Counterpart to Solidity's `-` operator.
641      *
642      * Requirements:
643      *
644      * - Subtraction cannot overflow.
645      */
646     function sub(
647         uint256 a,
648         uint256 b,
649         string memory errorMessage
650     ) internal pure returns (uint256) {
651         unchecked {
652             require(b <= a, errorMessage);
653             return a - b;
654         }
655     }
656 
657     /**
658      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
659      * division by zero. The result is rounded towards zero.
660      *
661      * Counterpart to Solidity's `/` operator. Note: this function uses a
662      * `revert` opcode (which leaves remaining gas untouched) while Solidity
663      * uses an invalid opcode to revert (consuming all remaining gas).
664      *
665      * Requirements:
666      *
667      * - The divisor cannot be zero.
668      */
669     function div(
670         uint256 a,
671         uint256 b,
672         string memory errorMessage
673     ) internal pure returns (uint256) {
674         unchecked {
675             require(b > 0, errorMessage);
676             return a / b;
677         }
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
682      * reverting with custom message when dividing by zero.
683      *
684      * CAUTION: This function is deprecated because it requires allocating memory for the error
685      * message unnecessarily. For custom revert reasons use {tryMod}.
686      *
687      * Counterpart to Solidity's `%` operator. This function uses a `revert`
688      * opcode (which leaves remaining gas untouched) while Solidity uses an
689      * invalid opcode to revert (consuming all remaining gas).
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function mod(
696         uint256 a,
697         uint256 b,
698         string memory errorMessage
699     ) internal pure returns (uint256) {
700         unchecked {
701             require(b > 0, errorMessage);
702             return a % b;
703         }
704     }
705 }
706 
707 interface IUniswapV2Factory {
708     event PairCreated(
709         address indexed token0,
710         address indexed token1,
711         address pair,
712         uint256
713     );
714 
715     function createPair(address tokenA, address tokenB)
716         external
717         returns (address pair);
718 }
719 
720 interface IUniswapV2Router02 {
721     function factory() external pure returns (address);
722 
723     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
724         uint256 amountIn,
725         uint256 amountOutMin,
726         address[] calldata path,
727         address to,
728         uint256 deadline
729     ) external;
730 }
731 
732 contract Paranoia is ERC20, Ownable {
733     using SafeMath for uint256;
734 
735     IUniswapV2Router02 public immutable uniswapV2Router;
736     address public immutable uniswapV2Pair;
737     address public pairedToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
738 
739     bool private swapping;
740 
741     address public treasuryWallet;
742 
743     uint256 public maxTransactionAmount;
744     uint256 public swapTokensAtAmount;
745     uint256 public maxWallet;
746 
747     bool public limitsInEffect = true;
748     bool public tradingActive = false;
749     bool public swapEnabled = false;
750 
751     uint256 public buyTotalFees;
752     uint256 public buyTreasuryFee;
753     uint256 public buyLiquidityFee;
754 
755     uint256 public sellTotalFees;
756     uint256 public sellTreasuryFee;
757     uint256 public sellLiquidityFee;
758 
759     // exclude from fees and max transaction amount
760     mapping(address => bool) private _isExcludedFromFees;
761     mapping(address => bool) public _isExcludedMaxTransactionAmount;
762 
763 
764     event ExcludeFromFees(address indexed account, bool isExcluded);
765 
766     event treasuryWalletUpdated(
767         address indexed newWallet,
768         address indexed oldWallet
769     );
770 
771     constructor() ERC20("Paranoia", "WAKE") {
772         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
773             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
774         );
775 
776         excludeFromMaxTransaction(address(_uniswapV2Router), true);
777         uniswapV2Router = _uniswapV2Router;
778 
779         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
780             .createPair(address(this), pairedToken);
781         excludeFromMaxTransaction(address(uniswapV2Pair), true);
782 
783 
784         uint256 _buyTreasuryFee = 6;
785         uint256 _buyLiquidityFee = 0;
786 
787         uint256 _sellTreasuryFee = 99;
788         uint256 _sellLiquidityFee = 0;
789 
790         /**
791         Angel number 6 symbolizes finances, material possessions, and the 
792         anxieties that we face in our daily lives. Humility and unconditional 
793         love are also related.
794         If this number has appeared in front of you, it means that all your 
795         problems will be solved soon.
796         */
797 
798         uint256 totalSupply = 666_666_666 * 1e18;
799 
800         maxTransactionAmount =  totalSupply * 1 / 100; // 1% 
801         maxWallet = totalSupply * 2 / 100; // 2% 
802         swapTokensAtAmount = (totalSupply * 20) / 10000; // 0.2%
803 
804         buyTreasuryFee = _buyTreasuryFee;
805         buyLiquidityFee = _buyLiquidityFee;
806         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
807 
808         sellTreasuryFee = _sellTreasuryFee;
809         sellLiquidityFee = _sellLiquidityFee;
810         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
811 
812         treasuryWallet = address(0x66666D861c91080F63665f60edE09437Ef176050); // set as treasury wallet
813 
814         // exclude from paying fees or having max transaction amount
815         excludeFromFees(owner(), true);
816         excludeFromFees(address(this), true);
817         excludeFromFees(address(0xdead), true);
818 
819         excludeFromMaxTransaction(owner(), true);
820         excludeFromMaxTransaction(address(this), true);
821         excludeFromMaxTransaction(address(0xdead), true);
822 
823         /*
824             _mint is an internal function in ERC20.sol that is only called here,
825             and CANNOT be called ever again
826         */
827         _mint(msg.sender, totalSupply);
828     }
829 
830     receive() external payable {}
831 
832     // once enabled, can never be turned off
833     function enableTrading() external onlyOwner {
834         tradingActive = true;
835         swapEnabled = true;
836     }
837 
838     // remove limits after token is stable
839     function removeLimits() external onlyOwner returns (bool) {
840         limitsInEffect = false;
841         return true;
842     }
843 
844     // change the minimum amount of tokens to sell from fees
845     function updateSwapTokensAtAmount(uint256 newAmount)
846         external
847         onlyOwner
848         returns (bool)
849     {
850         require(
851             newAmount >= (totalSupply() * 1) / 100000,
852             "Swap amount cannot be lower than 0.001% total supply."
853         );
854         require(
855             newAmount <= (totalSupply() * 5) / 1000,
856             "Swap amount cannot be higher than 0.5% total supply."
857         );
858         swapTokensAtAmount = newAmount;
859         return true;
860     }
861 
862     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
863         require(
864             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
865             "Cannot set maxTransactionAmount lower than 0.1%"
866         );
867         maxTransactionAmount = newNum * (10**18);
868     }
869 
870     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
871         require(
872             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
873             "Cannot set maxWallet lower than 0.5%"
874         );
875         maxWallet = newNum * (10**18);
876     }
877 
878     function excludeFromMaxTransaction(address updAds, bool isEx)
879         public
880         onlyOwner
881     {
882         _isExcludedMaxTransactionAmount[updAds] = isEx;
883     }
884 
885     // only use to disable contract sales if absolutely necessary (emergency use only)
886     function updateSwapEnabled(bool enabled) external onlyOwner {
887         swapEnabled = enabled;
888     }
889 
890     function updateBuyFees(
891         uint256 _treasuryFee,
892         uint256 _liquidityFee
893     ) external onlyOwner {
894         buyTreasuryFee = _treasuryFee;
895         buyLiquidityFee = _liquidityFee;
896         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
897         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
898     }
899 
900     function updateSellFees(
901         uint256 _treasuryFee,
902         uint256 _liquidityFee
903     ) external onlyOwner {
904         sellTreasuryFee = _treasuryFee;
905         sellLiquidityFee = _liquidityFee;
906         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
907         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
908     }
909 
910     function excludeFromFees(address account, bool excluded) public onlyOwner {
911         _isExcludedFromFees[account] = excluded;
912         emit ExcludeFromFees(account, excluded);
913     }
914 
915     function updateTreasuryWallet(address newTreasuryWallet)
916         external
917         onlyOwner
918     {
919         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
920         treasuryWallet = newTreasuryWallet;
921     }
922 
923 
924     function isExcludedFromFees(address account) public view returns (bool) {
925         return _isExcludedFromFees[account];
926     }
927 
928     function _transfer(
929         address from,
930         address to,
931         uint256 amount
932     ) internal override {
933         require(from != address(0), "ERC20: transfer from the zero address");
934         require(to != address(0), "ERC20: transfer to the zero address");
935 
936         if (amount == 0) {
937             super._transfer(from, to, 0);
938             return;
939         }
940 
941         if (limitsInEffect) {
942             if (
943                 from != owner() &&
944                 to != owner() &&
945                 to != address(0) &&
946                 to != address(0xdead) &&
947                 !swapping
948             ) {
949                 if (!tradingActive) {
950                     require(
951                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
952                         "Trading is not active."
953                     );
954                 }
955 
956                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
957                 //when buy
958                 if (
959                     from == uniswapV2Pair &&
960                     !_isExcludedMaxTransactionAmount[to]
961                 ) {
962                     require(
963                         amount <= maxTransactionAmount,
964                         "Buy transfer amount exceeds the maxTransactionAmount."
965                     );
966                     require(
967                         amount + balanceOf(to) <= maxWallet,
968                         "Max wallet exceeded"
969                     );
970                 }
971                 else if (!_isExcludedMaxTransactionAmount[to]) {
972                     require(
973                         amount + balanceOf(to) <= maxWallet,
974                         "Max wallet exceeded"
975                     );
976                 }
977             }
978         }
979 
980         uint256 contractTokenBalance = balanceOf(address(this));
981 
982         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
983 
984         if (
985             canSwap &&
986             swapEnabled &&
987             !swapping &&
988             to == uniswapV2Pair &&
989             !_isExcludedFromFees[from] &&
990             !_isExcludedFromFees[to]
991         ) {
992             swapping = true;
993 
994             swapBack();
995 
996             swapping = false;
997         }
998 
999         bool takeFee = !swapping;
1000 
1001         // if any account belongs to _isExcludedFromFee account then remove the fee
1002         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1003             takeFee = false;
1004         }
1005 
1006         uint256 fees = 0;
1007         uint256 tokensForLiquidity = 0;
1008         uint256 tokensForTreasury = 0;
1009         // only take fees on buys/sells, do not take on wallet transfers
1010         if (takeFee) {
1011             // on sell
1012             if (to == uniswapV2Pair && sellTotalFees > 0) {
1013                 fees = amount.mul(sellTotalFees).div(100);
1014                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1015                 tokensForTreasury = (fees * sellTreasuryFee) / sellTotalFees;
1016             }
1017             // on buy
1018             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1019                 fees = amount.mul(buyTotalFees).div(100);
1020                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1021                 tokensForTreasury = (fees * buyTreasuryFee) / buyTotalFees;
1022             }
1023 
1024             if (fees> 0) {
1025                 super._transfer(from, address(this), fees);
1026             }
1027             if (tokensForLiquidity > 0) {
1028                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1029             }
1030 
1031             amount -= fees;
1032         }
1033 
1034         super._transfer(from, to, amount);
1035     }
1036 
1037     function swapTokensForPairedToken(uint256 tokenAmount) private {
1038         // generate the uniswap pair path of token -> weth
1039         address[] memory path = new address[](2);
1040         path[0] = address(this);
1041         path[1] = pairedToken;
1042 
1043         _approve(address(this), address(uniswapV2Router), tokenAmount);
1044 
1045         // make the swap
1046         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1047             tokenAmount,
1048             0, // accept any amount of pairedToken
1049             path,
1050             treasuryWallet,
1051             block.timestamp
1052         );
1053     }
1054 
1055     function swapBack() private {
1056         uint256 contractBalance = balanceOf(address(this));
1057         if (contractBalance == 0) {
1058             return;
1059         }
1060 
1061         if (contractBalance > swapTokensAtAmount * 20) {
1062             contractBalance = swapTokensAtAmount * 20;
1063         }
1064 
1065         swapTokensForPairedToken(contractBalance);
1066     }
1067 
1068 }