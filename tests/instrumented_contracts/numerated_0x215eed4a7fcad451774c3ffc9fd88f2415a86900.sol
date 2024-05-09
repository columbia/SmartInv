1 // And there appeared a great wonder in heaven; a woman clothed with the sun, and the moon under her feet, and upon her head a crown of twelve stars: Revelation 12:1
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.10;
6 pragma experimental ABIEncoderV2;
7 
8 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
10 
11 /* pragma solidity ^0.8.0; */
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
34 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
35 
36 /* pragma solidity ^0.8.0; */
37 
38 /* import "../utils/Context.sol"; */
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 /* pragma solidity ^0.8.0; */
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 /* pragma solidity ^0.8.0; */
197 
198 /* import "../IERC20.sol"; */
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
223 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
224 
225 /* pragma solidity ^0.8.0; */
226 
227 /* import "./IERC20.sol"; */
228 /* import "./extensions/IERC20Metadata.sol"; */
229 /* import "../../utils/Context.sol"; */
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view virtual override returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public virtual override returns (bool) {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * Requirements:
365      *
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``sender``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         _transfer(sender, recipient, amount);
377 
378         uint256 currentAllowance = _allowances[sender][_msgSender()];
379         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Moves `amount` of tokens from `sender` to `recipient`.
389      *
390      * This internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `sender` cannot be the zero address.
398      * - `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      */
401     function _transfer(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) internal virtual {
406         require(sender != address(0), "ERC20: transfer from the zero address");
407         require(recipient != address(0), "ERC20: transfer to the zero address");
408 
409         _beforeTokenTransfer(sender, recipient, amount);
410 
411         uint256 senderBalance = _balances[sender];
412         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
413         unchecked {
414             _balances[sender] = senderBalance - amount;
415         }
416         _balances[recipient] += amount;
417 
418         emit Transfer(sender, recipient, amount);
419 
420         _afterTokenTransfer(sender, recipient, amount);
421     }
422 
423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
424      * the total supply.
425      *
426      * Emits a {Transfer} event with `from` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      */
432     function _mint(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: mint to the zero address");
434 
435         _beforeTokenTransfer(address(0), account, amount);
436 
437         _totalSupply += amount;
438         _balances[account] += amount;
439         emit Transfer(address(0), account, amount);
440 
441         _afterTokenTransfer(address(0), account, amount);
442     }
443 
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 
490     /**
491      * @dev Hook that is called after any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * has been transferred to `to`.
498      * - when `from` is zero, `amount` tokens have been minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _afterTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 }
510 
511 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
512 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
513 
514 /* pragma solidity ^0.8.0; */
515 
516 // CAUTION
517 // This version of SafeMath should only be used with Solidity 0.8 or later,
518 // because it relies on the compiler's built in overflow checks.
519 
520 /**
521  * @dev Wrappers over Solidity's arithmetic operations.
522  *
523  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
524  * now has built in overflow checking.
525  */
526 library SafeMath {
527     /**
528      * @dev Returns the addition of two unsigned integers, with an overflow flag.
529      *
530      * _Available since v3.4._
531      */
532     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
533         unchecked {
534             uint256 c = a + b;
535             if (c < a) return (false, 0);
536             return (true, c);
537         }
538     }
539 
540     /**
541      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
542      *
543      * _Available since v3.4._
544      */
545     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
546         unchecked {
547             if (b > a) return (false, 0);
548             return (true, a - b);
549         }
550     }
551 
552     /**
553      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
560             // benefit is lost if 'b' is also tested.
561             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
562             if (a == 0) return (true, 0);
563             uint256 c = a * b;
564             if (c / a != b) return (false, 0);
565             return (true, c);
566         }
567     }
568 
569     /**
570      * @dev Returns the division of two unsigned integers, with a division by zero flag.
571      *
572      * _Available since v3.4._
573      */
574     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             if (b == 0) return (false, 0);
577             return (true, a / b);
578         }
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
583      *
584      * _Available since v3.4._
585      */
586     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             if (b == 0) return (false, 0);
589             return (true, a % b);
590         }
591     }
592 
593     /**
594      * @dev Returns the addition of two unsigned integers, reverting on
595      * overflow.
596      *
597      * Counterpart to Solidity's `+` operator.
598      *
599      * Requirements:
600      *
601      * - Addition cannot overflow.
602      */
603     function add(uint256 a, uint256 b) internal pure returns (uint256) {
604         return a + b;
605     }
606 
607     /**
608      * @dev Returns the subtraction of two unsigned integers, reverting on
609      * overflow (when the result is negative).
610      *
611      * Counterpart to Solidity's `-` operator.
612      *
613      * Requirements:
614      *
615      * - Subtraction cannot overflow.
616      */
617     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
618         return a - b;
619     }
620 
621     /**
622      * @dev Returns the multiplication of two unsigned integers, reverting on
623      * overflow.
624      *
625      * Counterpart to Solidity's `*` operator.
626      *
627      * Requirements:
628      *
629      * - Multiplication cannot overflow.
630      */
631     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
632         return a * b;
633     }
634 
635     /**
636      * @dev Returns the integer division of two unsigned integers, reverting on
637      * division by zero. The result is rounded towards zero.
638      *
639      * Counterpart to Solidity's `/` operator.
640      *
641      * Requirements:
642      *
643      * - The divisor cannot be zero.
644      */
645     function div(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a / b;
647     }
648 
649     /**
650      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
651      * reverting when dividing by zero.
652      *
653      * Counterpart to Solidity's `%` operator. This function uses a `revert`
654      * opcode (which leaves remaining gas untouched) while Solidity uses an
655      * invalid opcode to revert (consuming all remaining gas).
656      *
657      * Requirements:
658      *
659      * - The divisor cannot be zero.
660      */
661     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
662         return a % b;
663     }
664 
665     /**
666      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
667      * overflow (when the result is negative).
668      *
669      * CAUTION: This function is deprecated because it requires allocating memory for the error
670      * message unnecessarily. For custom revert reasons use {trySub}.
671      *
672      * Counterpart to Solidity's `-` operator.
673      *
674      * Requirements:
675      *
676      * - Subtraction cannot overflow.
677      */
678     function sub(
679         uint256 a,
680         uint256 b,
681         string memory errorMessage
682     ) internal pure returns (uint256) {
683         unchecked {
684             require(b <= a, errorMessage);
685             return a - b;
686         }
687     }
688 
689     /**
690      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
691      * division by zero. The result is rounded towards zero.
692      *
693      * Counterpart to Solidity's `/` operator. Note: this function uses a
694      * `revert` opcode (which leaves remaining gas untouched) while Solidity
695      * uses an invalid opcode to revert (consuming all remaining gas).
696      *
697      * Requirements:
698      *
699      * - The divisor cannot be zero.
700      */
701     function div(
702         uint256 a,
703         uint256 b,
704         string memory errorMessage
705     ) internal pure returns (uint256) {
706         unchecked {
707             require(b > 0, errorMessage);
708             return a / b;
709         }
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * reverting with custom message when dividing by zero.
715      *
716      * CAUTION: This function is deprecated because it requires allocating memory for the error
717      * message unnecessarily. For custom revert reasons use {tryMod}.
718      *
719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
720      * opcode (which leaves remaining gas untouched) while Solidity uses an
721      * invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      *
725      * - The divisor cannot be zero.
726      */
727     function mod(
728         uint256 a,
729         uint256 b,
730         string memory errorMessage
731     ) internal pure returns (uint256) {
732         unchecked {
733             require(b > 0, errorMessage);
734             return a % b;
735         }
736     }
737 }
738 
739 interface IUniswapV2Factory {
740     event PairCreated(
741         address indexed token0,
742         address indexed token1,
743         address pair,
744         uint256
745     );
746 
747     function createPair(address tokenA, address tokenB)
748         external
749         returns (address pair);
750 }
751 
752 interface IUniswapV2Router02 {
753     function factory() external pure returns (address);
754 
755     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
756         uint256 amountIn,
757         uint256 amountOutMin,
758         address[] calldata path,
759         address to,
760         uint256 deadline
761     ) external;
762 }
763 
764 contract revelation is ERC20, Ownable {
765     using SafeMath for uint256;
766 
767     IUniswapV2Router02 public immutable uniswapV2Router;
768     address public immutable uniswapV2Pair;
769     address public constant deadAddress = address(0xdead);
770     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
771 
772     bool private swapping;
773 
774     address public devWallet;
775 
776     uint256 public maxTransactionAmount;
777     uint256 public swapTokensAtAmount;
778     uint256 public maxWallet;
779 
780     bool public limitsInEffect = true;
781     bool public tradingActive = false;
782     bool public swapEnabled = false;
783 
784     uint256 public buyTotalFees;
785     uint256 public buyDevFee;
786     uint256 public buyLiquidityFee;
787 
788     uint256 public sellTotalFees;
789     uint256 public sellDevFee;
790     uint256 public sellLiquidityFee;
791 
792     /******************/
793 
794     // exlcude from fees and max transaction amount
795     mapping(address => bool) private _isExcludedFromFees;
796     mapping(address => bool) public _isExcludedMaxTransactionAmount;
797 
798 
799     event ExcludeFromFees(address indexed account, bool isExcluded);
800 
801     event devWalletUpdated(
802         address indexed newWallet,
803         address indexed oldWallet
804     );
805 
806     constructor() ERC20("Revelation 12", "SAINT") {
807         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
808             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
809         );
810 
811         excludeFromMaxTransaction(address(_uniswapV2Router), true);
812         uniswapV2Router = _uniswapV2Router;
813 
814         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
815             .createPair(address(this), USDC);
816         excludeFromMaxTransaction(address(uniswapV2Pair), true);
817 
818 
819         uint256 _buyDevFee = 3;
820         uint256 _buyLiquidityFee = 0;
821 
822         uint256 _sellDevFee = 3;
823         uint256 _sellLiquidityFee = 0;
824 
825         uint256 totalSupply = 1_000_000_000 * 1e18;
826 
827         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
828         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
829         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
830 
831         buyDevFee = _buyDevFee;
832         buyLiquidityFee = _buyLiquidityFee;
833         buyTotalFees = buyDevFee + buyLiquidityFee;
834 
835         sellDevFee = _sellDevFee;
836         sellLiquidityFee = _sellLiquidityFee;
837         sellTotalFees = sellDevFee + sellLiquidityFee;
838 
839         devWallet = address(0xAF197C412dcD5CBa3f5628c1B7af43976e0268E9); // set as dev wallet
840 
841         // exclude from paying fees or having max transaction amount
842         excludeFromFees(owner(), true);
843         excludeFromFees(address(this), true);
844         excludeFromFees(address(0xdead), true);
845 
846         excludeFromMaxTransaction(owner(), true);
847         excludeFromMaxTransaction(address(this), true);
848         excludeFromMaxTransaction(address(0xdead), true);
849 
850         /*
851             _mint is an internal function in ERC20.sol that is only called here,
852             and CANNOT be called ever again
853         */
854         _mint(msg.sender, totalSupply);
855     }
856 
857     receive() external payable {}
858 
859     // once enabled, can never be turned off
860     function enableTrading() external onlyOwner {
861         tradingActive = true;
862         swapEnabled = true;
863     }
864 
865     // remove limits after token is stable
866     function removeLimits() external onlyOwner returns (bool) {
867         limitsInEffect = false;
868         return true;
869     }
870 
871     // change the minimum amount of tokens to sell from fees
872     function updateSwapTokensAtAmount(uint256 newAmount)
873         external
874         onlyOwner
875         returns (bool)
876     {
877         require(
878             newAmount >= (totalSupply() * 1) / 100000,
879             "Swap amount cannot be lower than 0.001% total supply."
880         );
881         require(
882             newAmount <= (totalSupply() * 5) / 1000,
883             "Swap amount cannot be higher than 0.5% total supply."
884         );
885         swapTokensAtAmount = newAmount;
886         return true;
887     }
888 
889     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
890         require(
891             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
892             "Cannot set maxTransactionAmount lower than 0.1%"
893         );
894         maxTransactionAmount = newNum * (10**18);
895     }
896 
897     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
898         require(
899             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
900             "Cannot set maxWallet lower than 0.5%"
901         );
902         maxWallet = newNum * (10**18);
903     }
904 
905     function excludeFromMaxTransaction(address updAds, bool isEx)
906         public
907         onlyOwner
908     {
909         _isExcludedMaxTransactionAmount[updAds] = isEx;
910     }
911 
912     // only use to disable contract sales if absolutely necessary (emergency use only)
913     function updateSwapEnabled(bool enabled) external onlyOwner {
914         swapEnabled = enabled;
915     }
916 
917     function updateBuyFees(
918         uint256 _devFee,
919         uint256 _liquidityFee
920     ) external onlyOwner {
921         buyDevFee = _devFee;
922         buyLiquidityFee = _liquidityFee;
923         buyTotalFees = buyDevFee + buyLiquidityFee;
924         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
925     }
926 
927     function updateSellFees(
928         uint256 _devFee,
929         uint256 _liquidityFee
930     ) external onlyOwner {
931         sellDevFee = _devFee;
932         sellLiquidityFee = _liquidityFee;
933         sellTotalFees = sellDevFee + sellLiquidityFee;
934         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
935     }
936 
937     function excludeFromFees(address account, bool excluded) public onlyOwner {
938         _isExcludedFromFees[account] = excluded;
939         emit ExcludeFromFees(account, excluded);
940     }
941 
942     function updateDevWallet(address newDevWallet)
943         external
944         onlyOwner
945     {
946         emit devWalletUpdated(newDevWallet, devWallet);
947         devWallet = newDevWallet;
948     }
949 
950 
951     function isExcludedFromFees(address account) public view returns (bool) {
952         return _isExcludedFromFees[account];
953     }
954 
955     function _transfer(
956         address from,
957         address to,
958         uint256 amount
959     ) internal override {
960         require(from != address(0), "ERC20: transfer from the zero address");
961         require(to != address(0), "ERC20: transfer to the zero address");
962 
963         if (amount == 0) {
964             super._transfer(from, to, 0);
965             return;
966         }
967 
968         if (limitsInEffect) {
969             if (
970                 from != owner() &&
971                 to != owner() &&
972                 to != address(0) &&
973                 to != address(0xdead) &&
974                 !swapping
975             ) {
976                 if (!tradingActive) {
977                     require(
978                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
979                         "Trading is not active."
980                     );
981                 }
982 
983                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
984                 //when buy
985                 if (
986                     from == uniswapV2Pair &&
987                     !_isExcludedMaxTransactionAmount[to]
988                 ) {
989                     require(
990                         amount <= maxTransactionAmount,
991                         "Buy transfer amount exceeds the maxTransactionAmount."
992                     );
993                     require(
994                         amount + balanceOf(to) <= maxWallet,
995                         "Max wallet exceeded"
996                     );
997                 }
998                 else if (!_isExcludedMaxTransactionAmount[to]) {
999                     require(
1000                         amount + balanceOf(to) <= maxWallet,
1001                         "Max wallet exceeded"
1002                     );
1003                 }
1004             }
1005         }
1006 
1007         uint256 contractTokenBalance = balanceOf(address(this));
1008 
1009         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1010 
1011         if (
1012             canSwap &&
1013             swapEnabled &&
1014             !swapping &&
1015             to == uniswapV2Pair &&
1016             !_isExcludedFromFees[from] &&
1017             !_isExcludedFromFees[to]
1018         ) {
1019             swapping = true;
1020 
1021             swapBack();
1022 
1023             swapping = false;
1024         }
1025 
1026         bool takeFee = !swapping;
1027 
1028         // if any account belongs to _isExcludedFromFee account then remove the fee
1029         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1030             takeFee = false;
1031         }
1032 
1033         uint256 fees = 0;
1034         uint256 tokensForLiquidity = 0;
1035         uint256 tokensForDev = 0;
1036         // only take fees on buys/sells, do not take on wallet transfers
1037         if (takeFee) {
1038             // on sell
1039             if (to == uniswapV2Pair && sellTotalFees > 0) {
1040                 fees = amount.mul(sellTotalFees).div(100);
1041                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1042                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1043             }
1044             // on buy
1045             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1046                 fees = amount.mul(buyTotalFees).div(100);
1047                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1048                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1049             }
1050 
1051             if (fees> 0) {
1052                 super._transfer(from, address(this), fees);
1053             }
1054             if (tokensForLiquidity > 0) {
1055                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1056             }
1057 
1058             amount -= fees;
1059         }
1060 
1061         super._transfer(from, to, amount);
1062     }
1063 
1064     function swapTokensForUSDC(uint256 tokenAmount) private {
1065         // generate the uniswap pair path of token -> weth
1066         address[] memory path = new address[](2);
1067         path[0] = address(this);
1068         path[1] = USDC;
1069 
1070         _approve(address(this), address(uniswapV2Router), tokenAmount);
1071 
1072         // make the swap
1073         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1074             tokenAmount,
1075             0, // accept any amount of USDC
1076             path,
1077             devWallet,
1078             block.timestamp
1079         );
1080     }
1081 
1082     function swapBack() private {
1083         uint256 contractBalance = balanceOf(address(this));
1084         if (contractBalance == 0) {
1085             return;
1086         }
1087 
1088         if (contractBalance > swapTokensAtAmount * 20) {
1089             contractBalance = swapTokensAtAmount * 20;
1090         }
1091 
1092         swapTokensForUSDC(contractBalance);
1093     }
1094 
1095 }