1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 pragma experimental ABIEncoderV2;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
32 
33 /* pragma solidity ^0.8.0; */
34 
35 /* import "../utils/Context.sol"; */
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
108 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
109 
110 /* pragma solidity ^0.8.0; */
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
192 
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "../IERC20.sol"; */
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
220 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
221 
222 /* pragma solidity ^0.8.0; */
223 
224 /* import "./IERC20.sol"; */
225 /* import "./extensions/IERC20Metadata.sol"; */
226 /* import "../../utils/Context.sol"; */
227 
228 /**
229  * @dev Implementation of the {IERC20} interface.
230  *
231  * This implementation is agnostic to the way tokens are created. This means
232  * that a supply mechanism has to be added in a derived contract using {_mint}.
233  * For a generic mechanism see {ERC20PresetMinterPauser}.
234  *
235  * TIP: For a detailed writeup see our guide
236  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
237  * to implement supply mechanisms].
238  *
239  * We have followed general OpenZeppelin Contracts guidelines: functions revert
240  * instead returning `false` on failure. This behavior is nonetheless
241  * conventional and does not conflict with the expectations of ERC20
242  * applications.
243  *
244  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
245  * This allows applications to reconstruct the allowance for all accounts just
246  * by listening to said events. Other implementations of the EIP may not emit
247  * these events, as it isn't required by the specification.
248  *
249  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
250  * functions have been added to mitigate the well-known issues around setting
251  * allowances. See {IERC20-approve}.
252  */
253 contract ERC20 is Context, IERC20, IERC20Metadata {
254     mapping(address => uint256) private _balances;
255 
256     mapping(address => mapping(address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     string private _name;
261     string private _symbol;
262 
263     /**
264      * @dev Sets the values for {name} and {symbol}.
265      *
266      * The default value of {decimals} is 18. To select a different value for
267      * {decimals} you should overload it.
268      *
269      * All two of these values are immutable: they can only be set once during
270      * construction.
271      */
272     constructor(string memory name_, string memory symbol_) {
273         _name = name_;
274         _symbol = symbol_;
275     }
276 
277     /**
278      * @dev Returns the name of the token.
279      */
280     function name() public view virtual override returns (string memory) {
281         return _name;
282     }
283 
284     /**
285      * @dev Returns the symbol of the token, usually a shorter version of the
286      * name.
287      */
288     function symbol() public view virtual override returns (string memory) {
289         return _symbol;
290     }
291 
292     /**
293      * @dev Returns the number of decimals used to get its user representation.
294      * For example, if `decimals` equals `2`, a balance of `505` tokens should
295      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
296      *
297      * Tokens usually opt for a value of 18, imitating the relationship between
298      * Ether and Wei. This is the value {ERC20} uses, unless this function is
299      * overridden;
300      *
301      * NOTE: This information is only used for _display_ purposes: it in
302      * no way affects any of the arithmetic of the contract, including
303      * {IERC20-balanceOf} and {IERC20-transfer}.
304      */
305     function decimals() public view virtual override returns (uint8) {
306         return 18;
307     }
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view virtual override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view virtual override returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view virtual override returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public virtual override returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * Requirements:
362      *
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for ``sender``'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public virtual override returns (bool) {
373         _transfer(sender, recipient, amount);
374 
375         uint256 currentAllowance = _allowances[sender][_msgSender()];
376         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
377         unchecked {
378             _approve(sender, _msgSender(), currentAllowance - amount);
379         }
380 
381         return true;
382     }
383 
384     /**
385      * @dev Moves `amount` of tokens from `sender` to `recipient`.
386      *
387      * This internal function is equivalent to {transfer}, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a {Transfer} event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(
399         address sender,
400         address recipient,
401         uint256 amount
402     ) internal virtual {
403         require(sender != address(0), "ERC20: transfer from the zero address");
404         require(recipient != address(0), "ERC20: transfer to the zero address");
405 
406         _beforeTokenTransfer(sender, recipient, amount);
407 
408         uint256 senderBalance = _balances[sender];
409         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
410         unchecked {
411             _balances[sender] = senderBalance - amount;
412         }
413         _balances[recipient] += amount;
414 
415         emit Transfer(sender, recipient, amount);
416 
417         _afterTokenTransfer(sender, recipient, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _beforeTokenTransfer(address(0), account, amount);
433 
434         _totalSupply += amount;
435         _balances[account] += amount;
436         emit Transfer(address(0), account, amount);
437 
438         _afterTokenTransfer(address(0), account, amount);
439     }
440 
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
444      *
445      * This internal function is equivalent to `approve`, and can be used to
446      * e.g. set automatic allowances for certain subsystems, etc.
447      *
448      * Emits an {Approval} event.
449      *
450      * Requirements:
451      *
452      * - `owner` cannot be the zero address.
453      * - `spender` cannot be the zero address.
454      */
455     function _approve(
456         address owner,
457         address spender,
458         uint256 amount
459     ) internal virtual {
460         require(owner != address(0), "ERC20: approve from the zero address");
461         require(spender != address(0), "ERC20: approve to the zero address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     /**
468      * @dev Hook that is called before any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * will be transferred to `to`.
475      * - when `from` is zero, `amount` tokens will be minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _beforeTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 
487     /**
488      * @dev Hook that is called after any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * has been transferred to `to`.
495      * - when `from` is zero, `amount` tokens have been minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _afterTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 }
507 
508 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
509 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
510 
511 /* pragma solidity ^0.8.0; */
512 
513 // CAUTION
514 // This version of SafeMath should only be used with Solidity 0.8 or later,
515 // because it relies on the compiler's built in overflow checks.
516 
517 /**
518  * @dev Wrappers over Solidity's arithmetic operations.
519  *
520  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
521  * now has built in overflow checking.
522  */
523 library SafeMath {
524     /**
525      * @dev Returns the addition of two unsigned integers, with an overflow flag.
526      *
527      * _Available since v3.4._
528      */
529     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             uint256 c = a + b;
532             if (c < a) return (false, 0);
533             return (true, c);
534         }
535     }
536 
537     /**
538      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
539      *
540      * _Available since v3.4._
541      */
542     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
543         unchecked {
544             if (b > a) return (false, 0);
545             return (true, a - b);
546         }
547     }
548 
549     /**
550      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
557             // benefit is lost if 'b' is also tested.
558             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
559             if (a == 0) return (true, 0);
560             uint256 c = a * b;
561             if (c / a != b) return (false, 0);
562             return (true, c);
563         }
564     }
565 
566     /**
567      * @dev Returns the division of two unsigned integers, with a division by zero flag.
568      *
569      * _Available since v3.4._
570      */
571     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
572         unchecked {
573             if (b == 0) return (false, 0);
574             return (true, a / b);
575         }
576     }
577 
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
580      *
581      * _Available since v3.4._
582      */
583     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
584         unchecked {
585             if (b == 0) return (false, 0);
586             return (true, a % b);
587         }
588     }
589 
590     /**
591      * @dev Returns the addition of two unsigned integers, reverting on
592      * overflow.
593      *
594      * Counterpart to Solidity's `+` operator.
595      *
596      * Requirements:
597      *
598      * - Addition cannot overflow.
599      */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a + b;
602     }
603 
604     /**
605      * @dev Returns the subtraction of two unsigned integers, reverting on
606      * overflow (when the result is negative).
607      *
608      * Counterpart to Solidity's `-` operator.
609      *
610      * Requirements:
611      *
612      * - Subtraction cannot overflow.
613      */
614     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a - b;
616     }
617 
618     /**
619      * @dev Returns the multiplication of two unsigned integers, reverting on
620      * overflow.
621      *
622      * Counterpart to Solidity's `*` operator.
623      *
624      * Requirements:
625      *
626      * - Multiplication cannot overflow.
627      */
628     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a * b;
630     }
631 
632     /**
633      * @dev Returns the integer division of two unsigned integers, reverting on
634      * division by zero. The result is rounded towards zero.
635      *
636      * Counterpart to Solidity's `/` operator.
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a / b;
644     }
645 
646     /**
647      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
648      * reverting when dividing by zero.
649      *
650      * Counterpart to Solidity's `%` operator. This function uses a `revert`
651      * opcode (which leaves remaining gas untouched) while Solidity uses an
652      * invalid opcode to revert (consuming all remaining gas).
653      *
654      * Requirements:
655      *
656      * - The divisor cannot be zero.
657      */
658     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a % b;
660     }
661 
662     /**
663      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
664      * overflow (when the result is negative).
665      *
666      * CAUTION: This function is deprecated because it requires allocating memory for the error
667      * message unnecessarily. For custom revert reasons use {trySub}.
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      *
673      * - Subtraction cannot overflow.
674      */
675     function sub(
676         uint256 a,
677         uint256 b,
678         string memory errorMessage
679     ) internal pure returns (uint256) {
680         unchecked {
681             require(b <= a, errorMessage);
682             return a - b;
683         }
684     }
685 
686     /**
687      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
688      * division by zero. The result is rounded towards zero.
689      *
690      * Counterpart to Solidity's `/` operator. Note: this function uses a
691      * `revert` opcode (which leaves remaining gas untouched) while Solidity
692      * uses an invalid opcode to revert (consuming all remaining gas).
693      *
694      * Requirements:
695      *
696      * - The divisor cannot be zero.
697      */
698     function div(
699         uint256 a,
700         uint256 b,
701         string memory errorMessage
702     ) internal pure returns (uint256) {
703         unchecked {
704             require(b > 0, errorMessage);
705             return a / b;
706         }
707     }
708 
709     /**
710      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
711      * reverting with custom message when dividing by zero.
712      *
713      * CAUTION: This function is deprecated because it requires allocating memory for the error
714      * message unnecessarily. For custom revert reasons use {tryMod}.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function mod(
725         uint256 a,
726         uint256 b,
727         string memory errorMessage
728     ) internal pure returns (uint256) {
729         unchecked {
730             require(b > 0, errorMessage);
731             return a % b;
732         }
733     }
734 }
735 
736 interface IUniswapV2Factory {
737     event PairCreated(
738         address indexed token0,
739         address indexed token1,
740         address pair,
741         uint256
742     );
743 
744     function createPair(address tokenA, address tokenB)
745         external
746         returns (address pair);
747 }
748 
749 interface IUniswapV2Router02 {
750     function factory() external pure returns (address);
751 
752     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
753         uint256 amountIn,
754         uint256 amountOutMin,
755         address[] calldata path,
756         address to,
757         uint256 deadline
758     ) external;
759 }
760 
761 contract testitolono is ERC20, Ownable {
762     using SafeMath for uint256;
763 
764     IUniswapV2Router02 public immutable uniswapV2Router;
765     address public immutable uniswapV2Pair;
766     address public constant deadAddress = address(0xdead);
767     address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
768 
769     bool private swapping;
770 
771     address public devWallet;
772 
773     uint256 public maxTransactionAmount;
774     uint256 public swapTokensAtAmount;
775     uint256 public maxWallet;
776 
777     bool public limitsInEffect = true;
778     bool public tradingActive = false;
779     bool public swapEnabled = false;
780 
781     uint256 public buyTotalFees;
782     uint256 public buyDevFee;
783     uint256 public buyLiquidityFee;
784 
785     uint256 public sellTotalFees;
786     uint256 public sellDevFee;
787     uint256 public sellLiquidityFee;
788 
789     /******************/
790 
791     // exlcude from fees and max transaction amount
792     mapping(address => bool) private _isExcludedFromFees;
793     mapping(address => bool) public _isExcludedMaxTransactionAmount;
794 
795 
796     event ExcludeFromFees(address indexed account, bool isExcluded);
797 
798     event devWalletUpdated(
799         address indexed newWallet,
800         address indexed oldWallet
801     );
802 
803     constructor() ERC20("testiloni", "testi") {
804         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
805             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
806         );
807 
808         excludeFromMaxTransaction(address(_uniswapV2Router), true);
809         uniswapV2Router = _uniswapV2Router;
810 
811         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
812             .createPair(address(this), USDT);
813         excludeFromMaxTransaction(address(uniswapV2Pair), true);
814 
815 
816         uint256 _buyDevFee = 0;
817         uint256 _buyLiquidityFee = 5;
818 
819         uint256 _sellDevFee = 0;
820         uint256 _sellLiquidityFee = 5;
821 
822         uint256 totalSupply = 100_000_000_000 * 1e18;
823 
824         maxTransactionAmount =  totalSupply * 1 / 100; // 1% from total supply maxTransactionAmountTxn
825         maxWallet = totalSupply * 2 / 100; // 1% from total supply maxWallet
826         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
827 
828         buyDevFee = _buyDevFee;
829         buyLiquidityFee = _buyLiquidityFee;
830         buyTotalFees = buyDevFee + buyLiquidityFee;
831 
832         sellDevFee = _sellDevFee;
833         sellLiquidityFee = _sellLiquidityFee;
834         sellTotalFees = sellDevFee + sellLiquidityFee;
835 
836         devWallet = address(0x2D043A6dB731083a0Ab52E532Dd18DE21479De46); // set as dev wallet
837 
838         // exclude from paying fees or having max transaction amount
839         excludeFromFees(owner(), true);
840         excludeFromFees(address(this), true);
841         excludeFromFees(address(0xdead), true);
842 
843         excludeFromMaxTransaction(owner(), true);
844         excludeFromMaxTransaction(address(this), true);
845         excludeFromMaxTransaction(address(0xdead), true);
846 
847         /*
848             _mint is an internal function in ERC20.sol that is only called here,
849             and CANNOT be called ever again
850         */
851         _mint(msg.sender, totalSupply);
852     }
853 
854     receive() external payable {}
855 
856     // once enabled, can never be turned off
857     function enableTrading() external onlyOwner {
858         tradingActive = true;
859         swapEnabled = true;
860     }
861 
862     // remove limits after token is stable
863     function removeLimits() external onlyOwner returns (bool) {
864         limitsInEffect = false;
865         return true;
866     }
867 
868     // change the minimum amount of tokens to sell from fees
869     function updateSwapTokensAtAmount(uint256 newAmount)
870         external
871         onlyOwner
872         returns (bool)
873     {
874         require(
875             newAmount >= (totalSupply() * 1) / 100000,
876             "Swap amount cannot be lower than 0.001% total supply."
877         );
878         require(
879             newAmount <= (totalSupply() * 5) / 1000,
880             "Swap amount cannot be higher than 0.5% total supply."
881         );
882         swapTokensAtAmount = newAmount;
883         return true;
884     }
885 
886     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
887         require(
888             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
889             "Cannot set maxTransactionAmount lower than 0.1%"
890         );
891         maxTransactionAmount = newNum * (10**18);
892     }
893 
894     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
895         require(
896             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
897             "Cannot set maxWallet lower than 0.5%"
898         );
899         maxWallet = newNum * (10**18);
900     }
901 
902     function excludeFromMaxTransaction(address updAds, bool isEx)
903         public
904         onlyOwner
905     {
906         _isExcludedMaxTransactionAmount[updAds] = isEx;
907     }
908 
909     // only use to disable contract sales if absolutely necessary (emergency use only)
910     function updateSwapEnabled(bool enabled) external onlyOwner {
911         swapEnabled = enabled;
912     }
913 
914     function updateBuyFees(
915         uint256 _devFee,
916         uint256 _liquidityFee
917     ) external onlyOwner {
918         buyDevFee = _devFee;
919         buyLiquidityFee = _liquidityFee;
920         buyTotalFees = buyDevFee + buyLiquidityFee;
921         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
922     }
923 
924     function updateSellFees(
925         uint256 _devFee,
926         uint256 _liquidityFee
927     ) external onlyOwner {
928         sellDevFee = _devFee;
929         sellLiquidityFee = _liquidityFee;
930         sellTotalFees = sellDevFee + sellLiquidityFee;
931         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
932     }
933 
934     function excludeFromFees(address account, bool excluded) public onlyOwner {
935         _isExcludedFromFees[account] = excluded;
936         emit ExcludeFromFees(account, excluded);
937     }
938 
939     function updateDevWallet(address newDevWallet)
940         external
941         onlyOwner
942     {
943         emit devWalletUpdated(newDevWallet, devWallet);
944         devWallet = newDevWallet;
945     }
946 
947 
948     function isExcludedFromFees(address account) public view returns (bool) {
949         return _isExcludedFromFees[account];
950     }
951 
952     function _transfer(
953         address from,
954         address to,
955         uint256 amount
956     ) internal override {
957         require(from != address(0), "ERC20: transfer from the zero address");
958         require(to != address(0), "ERC20: transfer to the zero address");
959 
960         if (amount == 0) {
961             super._transfer(from, to, 0);
962             return;
963         }
964 
965         if (limitsInEffect) {
966             if (
967                 from != owner() &&
968                 to != owner() &&
969                 to != address(0) &&
970                 to != address(0xdead) &&
971                 !swapping
972             ) {
973                 if (!tradingActive) {
974                     require(
975                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
976                         "Trading is not active."
977                     );
978                 }
979 
980                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
981                 //when buy
982                 if (
983                     from == uniswapV2Pair &&
984                     !_isExcludedMaxTransactionAmount[to]
985                 ) {
986                     require(
987                         amount <= maxTransactionAmount,
988                         "Buy transfer amount exceeds the maxTransactionAmount."
989                     );
990                     require(
991                         amount + balanceOf(to) <= maxWallet,
992                         "Max wallet exceeded"
993                     );
994                 }
995                 else if (!_isExcludedMaxTransactionAmount[to]) {
996                     require(
997                         amount + balanceOf(to) <= maxWallet,
998                         "Max wallet exceeded"
999                     );
1000                 }
1001             }
1002         }
1003 
1004         uint256 contractTokenBalance = balanceOf(address(this));
1005 
1006         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1007 
1008         if (
1009             canSwap &&
1010             swapEnabled &&
1011             !swapping &&
1012             to == uniswapV2Pair &&
1013             !_isExcludedFromFees[from] &&
1014             !_isExcludedFromFees[to]
1015         ) {
1016             swapping = true;
1017 
1018             swapBack();
1019 
1020             swapping = false;
1021         }
1022 
1023         bool takeFee = !swapping;
1024 
1025         // if any account belongs to _isExcludedFromFee account then remove the fee
1026         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1027             takeFee = false;
1028         }
1029 
1030         uint256 fees = 0;
1031         uint256 tokensForLiquidity = 0;
1032         uint256 tokensForDev = 0;
1033         // only take fees on buys/sells, do not take on wallet transfers
1034         if (takeFee) {
1035             // on sell
1036             if (to == uniswapV2Pair && sellTotalFees > 0) {
1037                 fees = amount.mul(sellTotalFees).div(100);
1038                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1039                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1040             }
1041             // on buy
1042             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1043                 fees = amount.mul(buyTotalFees).div(100);
1044                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1045                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1046             }
1047 
1048             if (fees> 0) {
1049                 super._transfer(from, address(this), fees);
1050             }
1051             if (tokensForLiquidity > 0) {
1052                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1053             }
1054 
1055             amount -= fees;
1056         }
1057 
1058         super._transfer(from, to, amount);
1059     }
1060 
1061     function swapTokensForUSDT(uint256 tokenAmount) private {
1062         // generate the uniswap pair path of token -> weth
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = USDT;
1066 
1067         _approve(address(this), address(uniswapV2Router), tokenAmount);
1068 
1069         // make the swap
1070         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1071             tokenAmount,
1072             0, // accept any amount of USDT
1073             path,
1074             devWallet,
1075             block.timestamp
1076         );
1077     }
1078 
1079     function swapBack() private {
1080         uint256 contractBalance = balanceOf(address(this));
1081         if (contractBalance == 0) {
1082             return;
1083         }
1084 
1085         if (contractBalance > swapTokensAtAmount * 20) {
1086             contractBalance = swapTokensAtAmount * 20;
1087         }
1088 
1089         swapTokensForUSDT(contractBalance);
1090     }
1091 
1092 }