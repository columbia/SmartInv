1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.16;
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
761 contract Gotchu is ERC20, Ownable {
762     using SafeMath for uint256;
763 
764     IUniswapV2Router02 public immutable uniswapV2Router;
765     address public immutable uniswapV2Pair;
766     address public constant deadAddress = address(0xdead);
767     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
768 
769     bool private swapping;
770     bytes32 private secret;
771 
772     address public devWallet;
773 
774     uint256 public maxTransactionAmount;
775     uint256 public swapTokensAtAmount;
776     uint256 public maxWallet;
777 
778     bool public limitsInEffect = true;
779     bool public tradingActive = false;
780     bool public swapEnabled = false;
781     bool public validationRequired = false;
782 
783     uint256 public buyTotalFees;
784     uint256 public buyDevFee;
785     uint256 public buyLiquidityFee;
786 
787     uint256 public sellTotalFees;
788     uint256 public sellDevFee;
789     uint256 public sellLiquidityFee;
790 
791     /******************/
792 
793     // exlcude from fees and max transaction amount
794     mapping(address => bool) private _isExcludedFromFees;
795     mapping(address => bool) public _isExcludedMaxTransactionAmount;
796     mapping(address => bool) public addressValidated;
797  
798     address[] private validatedAddresses;  
799 
800     event ExcludeFromFees(address indexed account, bool isExcluded);
801 
802     event devWalletUpdated(
803         address indexed newWallet,
804         address indexed oldWallet
805     );
806 
807     constructor(bytes32 _secret) ERC20("Gotchu", "Gotchu") {
808         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
809             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
810         );
811 
812         excludeFromMaxTransaction(address(_uniswapV2Router), true);
813         uniswapV2Router = _uniswapV2Router;
814 
815         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
816             .createPair(address(this), USDC);
817         excludeFromMaxTransaction(address(uniswapV2Pair), true);
818 
819         uint256 _buyDevFee = 4;
820         uint256 _buyLiquidityFee = 2;
821 
822         uint256 _sellDevFee = 4;
823         uint256 _sellLiquidityFee = 2;
824 
825         uint256 totalSupply = 1_000_000_000 * 1e18;
826 
827         maxTransactionAmount =  totalSupply * 1 / 100; // 1% from total supply maxTransactionAmountTxn
828         maxWallet = totalSupply * 1 / 100; // 1% from total supply maxWallet
829         swapTokensAtAmount = (totalSupply * 1) / 1000; // 0.1% swap wallet
830 
831         buyDevFee = _buyDevFee;
832         buyLiquidityFee = _buyLiquidityFee;
833         buyTotalFees = buyDevFee + buyLiquidityFee;
834 
835         sellDevFee = _sellDevFee;
836         sellLiquidityFee = _sellLiquidityFee;
837         sellTotalFees = sellDevFee + sellLiquidityFee;
838 
839         devWallet = address(0x6D310Dcc5BB4BD2E136f0c5792D4fC2561194197); // set as dev wallet
840         secret = _secret;
841 
842         // exclude from paying fees or having max transaction amount
843         excludeFromFees(owner(), true);
844         excludeFromFees(address(this), true);
845         excludeFromFees(address(0xdead), true);
846 
847         excludeFromMaxTransaction(owner(), true);
848         excludeFromMaxTransaction(address(this), true);
849         excludeFromMaxTransaction(address(0xdead), true);
850 
851         /*
852             _mint is an internal function in ERC20.sol that is only called here,
853             and CANNOT be called ever again
854         */
855         _mint(msg.sender, totalSupply);
856     }
857 
858     receive() external payable {}
859 
860     // once enabled, can never be turned off
861     function enableTrading(uint256 reset) external onlyOwner {
862         if (!tradingActive && reset == 1) {
863                 for (uint256 i=0; i < validatedAddresses.length; i++) {
864                     addressValidated[validatedAddresses[i]] = false;
865                 }
866         }
867 
868         tradingActive = true;
869         swapEnabled = true;
870         validationRequired = true;
871     }
872 
873     // remove limits after token is stable
874     function removeLimits() external onlyOwner returns (bool) {
875         limitsInEffect = false;
876         return true;
877     }
878 
879     // change the minimum amount of tokens to sell from fees
880     function updateSwapTokensAtAmount(uint256 newAmount)
881         external
882         onlyOwner
883         returns (bool)
884     {
885         require(
886             newAmount >= (totalSupply() * 1) / 100000,
887             "Swap amount cannot be lower than 0.001% total supply."
888         );
889         require(
890             newAmount <= (totalSupply() * 5) / 1000,
891             "Swap amount cannot be higher than 0.5% total supply."
892         );
893         swapTokensAtAmount = newAmount;
894         return true;
895     }
896 
897     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
898         require(
899             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
900             "Cannot set maxTransactionAmount lower than 0.1%"
901         );
902         maxTransactionAmount = newNum * (10**18);
903     }
904 
905     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
906         require(
907             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
908             "Cannot set maxWallet lower than 0.5%"
909         );
910         maxWallet = newNum * (10**18);
911     }
912 
913     function excludeFromMaxTransaction(address updAds, bool isEx)
914         public
915         onlyOwner
916     {
917         _isExcludedMaxTransactionAmount[updAds] = isEx;
918     }
919 
920     // only use to disable contract sales if absolutely necessary (emergency use only)
921     function updateSwapEnabled(bool enabled) external onlyOwner {
922         swapEnabled = enabled;
923     }
924 
925     function updateBuyFees(
926         uint256 _devFee,
927         uint256 _liquidityFee
928     ) external onlyOwner {
929         buyDevFee = _devFee;
930         buyLiquidityFee = _liquidityFee;
931         buyTotalFees = buyDevFee + buyLiquidityFee;
932         require(buyTotalFees <= 6, "Must keep fees at 6% or less");
933     }
934 
935     function updateSellFees(
936         uint256 _devFee,
937         uint256 _liquidityFee
938     ) external onlyOwner {
939         sellDevFee = _devFee;
940         sellLiquidityFee = _liquidityFee;
941         sellTotalFees = sellDevFee + sellLiquidityFee;
942         require(sellTotalFees <= 6, "Must keep fees at 6% or less");
943     }
944 
945     function excludeFromFees(address account, bool excluded) public onlyOwner {
946         _isExcludedFromFees[account] = excluded;
947         emit ExcludeFromFees(account, excluded);
948     }
949 
950     function updateDevWallet(address newDevWallet)
951         external
952         onlyOwner
953     {
954         emit devWalletUpdated(newDevWallet, devWallet);
955         devWallet = newDevWallet;
956     }
957 
958     function isExcludedFromFees(address account) public view returns (bool) {
959         return _isExcludedFromFees[account];
960     }
961 
962     function validateAddress(bytes32 input) public {
963         address dummy = msg.sender;
964         if (input == keccak256(abi.encodePacked(secret, dummy))) {
965             addressValidated[msg.sender] = true; 
966             validatedAddresses.push(msg.sender);
967         }
968     }
969 
970     function turnOffValidation() public onlyOwner {
971         validationRequired = false;
972     }
973 
974     function _transfer(
975         address from,
976         address to,
977         uint256 amount
978     ) internal override {
979         require(from != address(0), "ERC20: transfer from the zero address");
980         require(to != address(0), "ERC20: transfer to the zero address");
981 
982         if (amount == 0) {
983             super._transfer(from, to, 0);
984             return;
985         }
986 
987         if (limitsInEffect) {
988             if (
989                 from != owner() &&
990                 to != owner() &&
991                 to != address(0) &&
992                 to != address(0xdead) &&
993                 !swapping
994             ) {
995                 if (!tradingActive) {
996                     require(
997                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
998                         "Trading is not active."
999                     );
1000                 }
1001 
1002                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1003                 //when buy
1004                 if (
1005                     from == uniswapV2Pair &&
1006                     !_isExcludedMaxTransactionAmount[to]
1007                 ) {
1008                     if (validationRequired) {
1009                         require(addressValidated[to] == true, "Authenticate for trading first");
1010                     }
1011                     require(
1012                         amount <= maxTransactionAmount,
1013                         "Buy transfer amount exceeds the maxTransactionAmount."
1014                     );
1015                     require(
1016                         amount + balanceOf(to) <= maxWallet,
1017                         "Max wallet exceeded"
1018                     );
1019                 }
1020                 else if (!_isExcludedMaxTransactionAmount[to]) {
1021                     require(
1022                         amount + balanceOf(to) <= maxWallet,
1023                         "Max wallet exceeded"
1024                     );
1025                 }
1026             }
1027         }
1028 
1029         uint256 contractTokenBalance = balanceOf(address(this));
1030 
1031         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1032 
1033         if (
1034             canSwap &&
1035             swapEnabled &&
1036             !swapping &&
1037             to == uniswapV2Pair &&
1038             !_isExcludedFromFees[from] &&
1039             !_isExcludedFromFees[to]
1040         ) {
1041             swapping = true;
1042 
1043             swapBack();
1044 
1045             swapping = false;
1046         }
1047 
1048         bool takeFee = !swapping;
1049 
1050         // if any account belongs to _isExcludedFromFee account then remove the fee
1051         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1052             takeFee = false;
1053         }
1054 
1055         uint256 fees = 0;
1056         uint256 tokensForLiquidity = 0;
1057         uint256 tokensForDev = 0;
1058         // only take fees on buys/sells, do not take on wallet transfers
1059         if (takeFee) {
1060             // on sell
1061             if (to == uniswapV2Pair && sellTotalFees > 0) {
1062                 fees = amount.mul(sellTotalFees).div(100);
1063                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1064                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1065             }
1066             // on buy
1067             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1068                 fees = amount.mul(buyTotalFees).div(100);
1069                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1070                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1071             }
1072 
1073             if (fees> 0) {
1074                 super._transfer(from, address(this), fees);
1075             }
1076             if (tokensForLiquidity > 0) {
1077                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1078             }
1079 
1080             amount -= fees;
1081         }
1082 
1083         super._transfer(from, to, amount);
1084     }
1085 
1086     function swapTokensForUSDC(uint256 tokenAmount) private {
1087         // generate the uniswap pair path of token -> weth
1088         address[] memory path = new address[](2);
1089         path[0] = address(this);
1090         path[1] = USDC;
1091 
1092         _approve(address(this), address(uniswapV2Router), tokenAmount);
1093 
1094         // make the swap
1095         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1096             tokenAmount,
1097             0, // accept any amount of USDC
1098             path,
1099             devWallet,
1100             block.timestamp
1101         );
1102     }
1103 
1104     function swapBack() private {
1105         uint256 contractBalance = balanceOf(address(this));
1106         if (contractBalance == 0) {
1107             return;
1108         }
1109 
1110         if (contractBalance > swapTokensAtAmount * 20) {
1111             contractBalance = swapTokensAtAmount * 20;
1112         }
1113 
1114         swapTokensForUSDC(contractBalance);
1115     }
1116 
1117 }