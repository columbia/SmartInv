1 /**
2 
3 Let's put the culture and the class back into the space. $HABIBI is a widely recognized word across different cultures and is often used as a symbol of unity and love between people of different backgrounds.
4 
5 $HABIBI is here to unite all degens around cryptospehere!
6 
7 $HABIBI will be stealth launched with no presale, contract renounced and LP locked for 2 months with extensions on the roadmap. 
8 
9 Twitter: https://twitter.com/habibierc/
10 Telegram: https://t.me/habibierc
11 Website:  https://sheikhfroghabibi.com
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.19;
17 pragma experimental ABIEncoderV2;
18 
19 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
20 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
21 
22 /* pragma solidity ^0.8.0; */
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
45 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
46 
47 /* pragma solidity ^0.8.0; */
48 
49 /* import "../utils/Context.sol"; */
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
123 
124 /* pragma solidity ^0.8.0; */
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
205 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 /* pragma solidity ^0.8.0; */
208 
209 /* import "../IERC20.sol"; */
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
234 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
235 
236 /* pragma solidity ^0.8.0; */
237 
238 /* import "./IERC20.sol"; */
239 /* import "./extensions/IERC20Metadata.sol"; */
240 /* import "../../utils/Context.sol"; */
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `recipient` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * Requirements:
376      *
377      * - `sender` and `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``sender``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388 
389         uint256 currentAllowance = _allowances[sender][_msgSender()];
390         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
391         unchecked {
392             _approve(sender, _msgSender(), currentAllowance - amount);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Moves `amount` of tokens from `sender` to `recipient`.
400      *
401      * This internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(
413         address sender,
414         address recipient,
415         uint256 amount
416     ) internal virtual {
417         require(sender != address(0), "ERC20: transfer from the zero address");
418         require(recipient != address(0), "ERC20: transfer to the zero address");
419 
420         _beforeTokenTransfer(sender, recipient, amount);
421 
422         uint256 senderBalance = _balances[sender];
423         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
424         unchecked {
425             _balances[sender] = senderBalance - amount;
426         }
427         _balances[recipient] += amount;
428 
429         emit Transfer(sender, recipient, amount);
430 
431         _afterTokenTransfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `account` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal virtual {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _beforeTokenTransfer(address(0), account, amount);
447 
448         _totalSupply += amount;
449         _balances[account] += amount;
450         emit Transfer(address(0), account, amount);
451 
452         _afterTokenTransfer(address(0), account, amount);
453     }
454 
455 
456     /**
457      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
458      *
459      * This internal function is equivalent to `approve`, and can be used to
460      * e.g. set automatic allowances for certain subsystems, etc.
461      *
462      * Emits an {Approval} event.
463      *
464      * Requirements:
465      *
466      * - `owner` cannot be the zero address.
467      * - `spender` cannot be the zero address.
468      */
469     function _approve(
470         address owner,
471         address spender,
472         uint256 amount
473     ) internal virtual {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Hook that is called before any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * will be transferred to `to`.
489      * - when `from` is zero, `amount` tokens will be minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _beforeTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 
501     /**
502      * @dev Hook that is called after any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * has been transferred to `to`.
509      * - when `from` is zero, `amount` tokens have been minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _afterTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 }
521 
522 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
523 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
524 
525 /* pragma solidity ^0.8.0; */
526 
527 // CAUTION
528 // This version of SafeMath should only be used with Solidity 0.8 or later,
529 // because it relies on the compiler's built in overflow checks.
530 
531 /**
532  * @dev Wrappers over Solidity's arithmetic operations.
533  *
534  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
535  * now has built in overflow checking.
536  */
537 library SafeMath {
538     /**
539      * @dev Returns the addition of two unsigned integers, with an overflow flag.
540      *
541      * _Available since v3.4._
542      */
543     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
544         unchecked {
545             uint256 c = a + b;
546             if (c < a) return (false, 0);
547             return (true, c);
548         }
549     }
550 
551     /**
552      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
553      *
554      * _Available since v3.4._
555      */
556     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
557         unchecked {
558             if (b > a) return (false, 0);
559             return (true, a - b);
560         }
561     }
562 
563     /**
564      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
565      *
566      * _Available since v3.4._
567      */
568     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
569         unchecked {
570             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
571             // benefit is lost if 'b' is also tested.
572             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
573             if (a == 0) return (true, 0);
574             uint256 c = a * b;
575             if (c / a != b) return (false, 0);
576             return (true, c);
577         }
578     }
579 
580     /**
581      * @dev Returns the division of two unsigned integers, with a division by zero flag.
582      *
583      * _Available since v3.4._
584      */
585     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
586         unchecked {
587             if (b == 0) return (false, 0);
588             return (true, a / b);
589         }
590     }
591 
592     /**
593      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
594      *
595      * _Available since v3.4._
596      */
597     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             if (b == 0) return (false, 0);
600             return (true, a % b);
601         }
602     }
603 
604     /**
605      * @dev Returns the addition of two unsigned integers, reverting on
606      * overflow.
607      *
608      * Counterpart to Solidity's `+` operator.
609      *
610      * Requirements:
611      *
612      * - Addition cannot overflow.
613      */
614     function add(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a + b;
616     }
617 
618     /**
619      * @dev Returns the subtraction of two unsigned integers, reverting on
620      * overflow (when the result is negative).
621      *
622      * Counterpart to Solidity's `-` operator.
623      *
624      * Requirements:
625      *
626      * - Subtraction cannot overflow.
627      */
628     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a - b;
630     }
631 
632     /**
633      * @dev Returns the multiplication of two unsigned integers, reverting on
634      * overflow.
635      *
636      * Counterpart to Solidity's `*` operator.
637      *
638      * Requirements:
639      *
640      * - Multiplication cannot overflow.
641      */
642     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a * b;
644     }
645 
646     /**
647      * @dev Returns the integer division of two unsigned integers, reverting on
648      * division by zero. The result is rounded towards zero.
649      *
650      * Counterpart to Solidity's `/` operator.
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function div(uint256 a, uint256 b) internal pure returns (uint256) {
657         return a / b;
658     }
659 
660     /**
661      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
662      * reverting when dividing by zero.
663      *
664      * Counterpart to Solidity's `%` operator. This function uses a `revert`
665      * opcode (which leaves remaining gas untouched) while Solidity uses an
666      * invalid opcode to revert (consuming all remaining gas).
667      *
668      * Requirements:
669      *
670      * - The divisor cannot be zero.
671      */
672     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a % b;
674     }
675 
676     /**
677      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
678      * overflow (when the result is negative).
679      *
680      * CAUTION: This function is deprecated because it requires allocating memory for the error
681      * message unnecessarily. For custom revert reasons use {trySub}.
682      *
683      * Counterpart to Solidity's `-` operator.
684      *
685      * Requirements:
686      *
687      * - Subtraction cannot overflow.
688      */
689     function sub(
690         uint256 a,
691         uint256 b,
692         string memory errorMessage
693     ) internal pure returns (uint256) {
694         unchecked {
695             require(b <= a, errorMessage);
696             return a - b;
697         }
698     }
699 
700     /**
701      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
702      * division by zero. The result is rounded towards zero.
703      *
704      * Counterpart to Solidity's `/` operator. Note: this function uses a
705      * `revert` opcode (which leaves remaining gas untouched) while Solidity
706      * uses an invalid opcode to revert (consuming all remaining gas).
707      *
708      * Requirements:
709      *
710      * - The divisor cannot be zero.
711      */
712     function div(
713         uint256 a,
714         uint256 b,
715         string memory errorMessage
716     ) internal pure returns (uint256) {
717         unchecked {
718             require(b > 0, errorMessage);
719             return a / b;
720         }
721     }
722 
723     /**
724      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
725      * reverting with custom message when dividing by zero.
726      *
727      * CAUTION: This function is deprecated because it requires allocating memory for the error
728      * message unnecessarily. For custom revert reasons use {tryMod}.
729      *
730      * Counterpart to Solidity's `%` operator. This function uses a `revert`
731      * opcode (which leaves remaining gas untouched) while Solidity uses an
732      * invalid opcode to revert (consuming all remaining gas).
733      *
734      * Requirements:
735      *
736      * - The divisor cannot be zero.
737      */
738     function mod(
739         uint256 a,
740         uint256 b,
741         string memory errorMessage
742     ) internal pure returns (uint256) {
743         unchecked {
744             require(b > 0, errorMessage);
745             return a % b;
746         }
747     }
748 }
749 
750 interface IUniswapV2Factory {
751     event PairCreated(
752         address indexed token0,
753         address indexed token1,
754         address pair,
755         uint256
756     );
757 
758     function createPair(address tokenA, address tokenB)
759         external
760         returns (address pair);
761 }
762 
763 interface IUniswapV2Router02 {
764     function factory() external pure returns (address);
765 
766     function WETH() external pure returns (address);
767 
768     function swapExactTokensForETHSupportingFeeOnTransferTokens(
769         uint256 amountIn,
770         uint256 amountOutMin,
771         address[] calldata path,
772         address to,
773         uint256 deadline
774     ) external;
775 }
776 
777 contract Habibi is ERC20, Ownable {
778     using SafeMath for uint256;
779 
780     IUniswapV2Router02 public immutable uniswapV2Router;
781     address public immutable uniswapV2Pair;
782     address public constant deadAddress = address(0xdead);
783 
784     bool private swapping;
785 
786     address public marketingWallet;
787 
788     uint256 public maxTransactionAmount;
789     uint256 public swapTokensAtAmount;
790     uint256 public maxWallet;
791 
792     bool public limitsInEffect = true;
793     bool public tradingActive = false;
794 
795     uint256 public buyFee;
796     uint256 public sellFee;
797 
798     /******************/
799 
800     // exlcude from fees and max transaction amount
801     mapping(address => bool) private _isExcludedFromFees;
802     mapping(address => bool) public _isExcludedMaxTransactionAmount;
803 
804 
805     event ExcludeFromFees(address indexed account, bool isExcluded);
806 
807     event marketingWalletUpdated(
808         address indexed newWallet,
809         address indexed oldWallet
810     );
811 
812     constructor() ERC20("Sheikh Frog", "HABIBI") {
813         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
814             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
815         );
816 
817         excludeFromMaxTransaction(address(_uniswapV2Router), true);
818         uniswapV2Router = _uniswapV2Router;
819 
820         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
821             .createPair(address(this), _uniswapV2Router.WETH());
822         excludeFromMaxTransaction(address(uniswapV2Pair), true);
823 
824         uint256 _buyFee = 0;
825         uint256 _sellFee = 0;
826 
827         uint256 totalSupply = 100_000_000 * 1e18;
828 
829         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply 
830         maxWallet = totalSupply * 2 / 100; // 2% from total supply 
831         swapTokensAtAmount = (totalSupply * 40) / 100000; // 0.035% swap wallet
832 
833         buyFee = _buyFee;
834         sellFee = _sellFee;
835 
836         marketingWallet = address(0x8e2dd7B16587a4729D8382847c9E6E5D7eD58BDE); // marketing wallet
837 
838         // exclude from paying fees or having max transaction amount
839         excludeFromFees(owner(), true);
840         excludeFromFees(marketingWallet, true);
841         excludeFromFees(address(this), true);
842         excludeFromFees(address(0xdead), true);
843 
844         excludeFromMaxTransaction(owner(), true);
845         excludeFromMaxTransaction(marketingWallet, true);
846         excludeFromMaxTransaction(address(this), true);
847         excludeFromMaxTransaction(address(0xdead), true);
848 
849         /*
850             _mint is an internal function in ERC20.sol that is only called here,
851             and CANNOT be called ever again
852         */
853         _mint(msg.sender, totalSupply);
854     }
855 
856     receive() external payable {}
857 
858     // once enabled, can never be turned off
859     function enableTrading() external onlyOwner {
860         tradingActive = true;
861     }
862 
863     // remove limits after token is stable
864     function removeLimits() external onlyOwner returns (bool) {
865         limitsInEffect = false;
866         return true;
867     }
868 
869     // change the minimum amount of tokens to sell from fees
870     function updateSwapTokensAtAmount(uint256 newAmount)
871         external
872         onlyOwner
873         returns (bool)
874     {
875         require(
876             newAmount >= (totalSupply() * 1) / 100000,
877             "Swap amount cannot be lower than 0.001% total supply."
878         );
879         require(
880             newAmount <= (totalSupply() * 5) / 1000,
881             "Swap amount cannot be higher than 0.5% total supply."
882         );
883         swapTokensAtAmount = newAmount;
884         return true;
885     }
886 
887     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
888         require(
889             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
890             "Cannot set maxTransactionAmount lower than 0.1%"
891         );
892         maxTransactionAmount = newNum * (10**18);
893     }
894 
895     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
896         require(
897             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
898             "Cannot set maxWallet lower than 0.5%"
899         );
900         maxWallet = newNum * (10**18);
901     }
902 
903     function excludeFromMaxTransaction(address updAds, bool isEx)
904         public
905         onlyOwner
906     {
907         _isExcludedMaxTransactionAmount[updAds] = isEx;
908     }
909 
910     function updateFees(
911         uint256 _buyFee,
912         uint256 _sellFee
913     ) external onlyOwner {
914         buyFee = _buyFee;
915         sellFee = _sellFee;
916         require(buyFee.div(2) <= 25, "Buy tax too high");
917         require(sellFee.div(2) <= 25, "Sell tax too high");
918     }
919 
920     function excludeFromFees(address account, bool excluded) public onlyOwner {
921         _isExcludedFromFees[account] = excluded;
922         emit ExcludeFromFees(account, excluded);
923     }
924 
925     function updateMarketingWallet(address newMarketingWallet)
926         external
927         onlyOwner
928     {
929         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
930         marketingWallet = newMarketingWallet;
931     }
932 
933     function isExcludedFromFees(address account) public view returns (bool) {
934         return _isExcludedFromFees[account];
935     }
936 
937     function _transfer(
938         address from,
939         address to,
940         uint256 amount
941     ) internal override {
942         require(from != address(0), "ERC20: transfer from the zero address");
943         require(to != address(0), "ERC20: transfer to the zero address");
944 
945         if (amount == 0) {
946             super._transfer(from, to, 0);
947             return;
948         }
949 
950         if (limitsInEffect) {
951             if (
952                 from != owner() &&
953                 to != owner() &&
954                 to != address(0) &&
955                 to != address(0xdead) &&
956                 !swapping
957             ) {
958                 if (!tradingActive) {
959                     require(
960                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
961                         "Trading is not active."
962                     );
963                 }
964 
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
994             !swapping &&
995             to == uniswapV2Pair &&
996             !_isExcludedFromFees[from] &&
997             !_isExcludedFromFees[to]
998         ) {
999             swapping = true;
1000 
1001             swapBack();
1002 
1003             swapping = false;
1004         }
1005 
1006         bool takeFee = !swapping;
1007 
1008         // if any account belongs to _isExcludedFromFee account then remove the fee
1009         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1010             takeFee = false;
1011         }
1012 
1013         uint256 fees = 0;
1014         // only take fees on buys/sells, do not take on wallet transfers
1015         if (takeFee) {
1016             // on sell
1017             if (to == uniswapV2Pair && sellFee > 0) {
1018                 fees = amount.mul(sellFee).div(100);
1019             }
1020             // on buy
1021             else if (from == uniswapV2Pair && buyFee > 0) {
1022                 fees = amount.mul(buyFee).div(100);
1023             }
1024 
1025             if (fees > 0) {
1026                 super._transfer(from, address(this), fees);
1027             }
1028 
1029             amount -= fees;
1030         }
1031 
1032         super._transfer(from, to, amount);
1033     }
1034 
1035     function swapTokensForETH(uint256 tokenAmount) private {
1036         // generate the uniswap pair path of token -> weth
1037         address[] memory path = new address[](2);
1038         path[0] = address(this);
1039         path[1] = uniswapV2Router.WETH();
1040 
1041         _approve(address(this), address(uniswapV2Router), tokenAmount);
1042 
1043         // make the swap
1044         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1045             tokenAmount,
1046             0, // accept any amount of ETH
1047             path,
1048             marketingWallet,
1049             block.timestamp
1050         );
1051     }
1052 
1053     function swapBack() private {
1054         uint256 contractBalance = balanceOf(address(this));
1055         if (contractBalance == 0) {
1056             return;
1057         }
1058 
1059         if (contractBalance > swapTokensAtAmount * 20) {
1060             contractBalance = swapTokensAtAmount * 20;
1061         }
1062 
1063         swapTokensForETH(contractBalance);
1064     }
1065 
1066 }