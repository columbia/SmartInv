1 /**
2 Deploying a contract should be as simple as making a swap.
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.10;
7 pragma experimental ABIEncoderV2;
8 
9 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 /* pragma solidity ^0.8.0; */
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
35 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
36 
37 /* pragma solidity ^0.8.0; */
38 
39 /* import "../utils/Context.sol"; */
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
112 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
113 
114 /* pragma solidity ^0.8.0; */
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
195 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
196 
197 /* pragma solidity ^0.8.0; */
198 
199 /* import "../IERC20.sol"; */
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
224 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
225 
226 /* pragma solidity ^0.8.0; */
227 
228 /* import "./IERC20.sol"; */
229 /* import "./extensions/IERC20Metadata.sol"; */
230 /* import "../../utils/Context.sol"; */
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
381         unchecked {
382             _approve(sender, _msgSender(), currentAllowance - amount);
383         }
384 
385         return true;
386     }
387 
388     /**
389      * @dev Moves `amount` of tokens from `sender` to `recipient`.
390      *
391      * This internal function is equivalent to {transfer}, and can be used to
392      * e.g. implement automatic token fees, slashing mechanisms, etc.
393      *
394      * Emits a {Transfer} event.
395      *
396      * Requirements:
397      *
398      * - `sender` cannot be the zero address.
399      * - `recipient` cannot be the zero address.
400      * - `sender` must have a balance of at least `amount`.
401      */
402     function _transfer(
403         address sender,
404         address recipient,
405         uint256 amount
406     ) internal virtual {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _beforeTokenTransfer(sender, recipient, amount);
411 
412         uint256 senderBalance = _balances[sender];
413         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
414         unchecked {
415             _balances[sender] = senderBalance - amount;
416         }
417         _balances[recipient] += amount;
418 
419         emit Transfer(sender, recipient, amount);
420 
421         _afterTokenTransfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements:
430      *
431      * - `account` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _beforeTokenTransfer(address(0), account, amount);
437 
438         _totalSupply += amount;
439         _balances[account] += amount;
440         emit Transfer(address(0), account, amount);
441 
442         _afterTokenTransfer(address(0), account, amount);
443     }
444 
445 
446     /**
447      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
448      *
449      * This internal function is equivalent to `approve`, and can be used to
450      * e.g. set automatic allowances for certain subsystems, etc.
451      *
452      * Emits an {Approval} event.
453      *
454      * Requirements:
455      *
456      * - `owner` cannot be the zero address.
457      * - `spender` cannot be the zero address.
458      */
459     function _approve(
460         address owner,
461         address spender,
462         uint256 amount
463     ) internal virtual {
464         require(owner != address(0), "ERC20: approve from the zero address");
465         require(spender != address(0), "ERC20: approve to the zero address");
466 
467         _allowances[owner][spender] = amount;
468         emit Approval(owner, spender, amount);
469     }
470 
471     /**
472      * @dev Hook that is called before any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * will be transferred to `to`.
479      * - when `from` is zero, `amount` tokens will be minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _beforeTokenTransfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {}
490 
491     /**
492      * @dev Hook that is called after any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * has been transferred to `to`.
499      * - when `from` is zero, `amount` tokens have been minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _afterTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 }
511 
512 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
513 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
514 
515 /* pragma solidity ^0.8.0; */
516 
517 // CAUTION
518 // This version of SafeMath should only be used with Solidity 0.8 or later,
519 // because it relies on the compiler's built in overflow checks.
520 
521 /**
522  * @dev Wrappers over Solidity's arithmetic operations.
523  *
524  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
525  * now has built in overflow checking.
526  */
527 library SafeMath {
528     /**
529      * @dev Returns the addition of two unsigned integers, with an overflow flag.
530      *
531      * _Available since v3.4._
532      */
533     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
534         unchecked {
535             uint256 c = a + b;
536             if (c < a) return (false, 0);
537             return (true, c);
538         }
539     }
540 
541     /**
542      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
543      *
544      * _Available since v3.4._
545      */
546     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
547         unchecked {
548             if (b > a) return (false, 0);
549             return (true, a - b);
550         }
551     }
552 
553     /**
554      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
555      *
556      * _Available since v3.4._
557      */
558     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
559         unchecked {
560             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
561             // benefit is lost if 'b' is also tested.
562             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
563             if (a == 0) return (true, 0);
564             uint256 c = a * b;
565             if (c / a != b) return (false, 0);
566             return (true, c);
567         }
568     }
569 
570     /**
571      * @dev Returns the division of two unsigned integers, with a division by zero flag.
572      *
573      * _Available since v3.4._
574      */
575     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
576         unchecked {
577             if (b == 0) return (false, 0);
578             return (true, a / b);
579         }
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
584      *
585      * _Available since v3.4._
586      */
587     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
588         unchecked {
589             if (b == 0) return (false, 0);
590             return (true, a % b);
591         }
592     }
593 
594     /**
595      * @dev Returns the addition of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `+` operator.
599      *
600      * Requirements:
601      *
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         return a + b;
606     }
607 
608     /**
609      * @dev Returns the subtraction of two unsigned integers, reverting on
610      * overflow (when the result is negative).
611      *
612      * Counterpart to Solidity's `-` operator.
613      *
614      * Requirements:
615      *
616      * - Subtraction cannot overflow.
617      */
618     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a - b;
620     }
621 
622     /**
623      * @dev Returns the multiplication of two unsigned integers, reverting on
624      * overflow.
625      *
626      * Counterpart to Solidity's `*` operator.
627      *
628      * Requirements:
629      *
630      * - Multiplication cannot overflow.
631      */
632     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a * b;
634     }
635 
636     /**
637      * @dev Returns the integer division of two unsigned integers, reverting on
638      * division by zero. The result is rounded towards zero.
639      *
640      * Counterpart to Solidity's `/` operator.
641      *
642      * Requirements:
643      *
644      * - The divisor cannot be zero.
645      */
646     function div(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a / b;
648     }
649 
650     /**
651      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
652      * reverting when dividing by zero.
653      *
654      * Counterpart to Solidity's `%` operator. This function uses a `revert`
655      * opcode (which leaves remaining gas untouched) while Solidity uses an
656      * invalid opcode to revert (consuming all remaining gas).
657      *
658      * Requirements:
659      *
660      * - The divisor cannot be zero.
661      */
662     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a % b;
664     }
665 
666     /**
667      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
668      * overflow (when the result is negative).
669      *
670      * CAUTION: This function is deprecated because it requires allocating memory for the error
671      * message unnecessarily. For custom revert reasons use {trySub}.
672      *
673      * Counterpart to Solidity's `-` operator.
674      *
675      * Requirements:
676      *
677      * - Subtraction cannot overflow.
678      */
679     function sub(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b <= a, errorMessage);
686             return a - b;
687         }
688     }
689 
690     /**
691      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
692      * division by zero. The result is rounded towards zero.
693      *
694      * Counterpart to Solidity's `/` operator. Note: this function uses a
695      * `revert` opcode (which leaves remaining gas untouched) while Solidity
696      * uses an invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function div(
703         uint256 a,
704         uint256 b,
705         string memory errorMessage
706     ) internal pure returns (uint256) {
707         unchecked {
708             require(b > 0, errorMessage);
709             return a / b;
710         }
711     }
712 
713     /**
714      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
715      * reverting with custom message when dividing by zero.
716      *
717      * CAUTION: This function is deprecated because it requires allocating memory for the error
718      * message unnecessarily. For custom revert reasons use {tryMod}.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(
729         uint256 a,
730         uint256 b,
731         string memory errorMessage
732     ) internal pure returns (uint256) {
733         unchecked {
734             require(b > 0, errorMessage);
735             return a % b;
736         }
737     }
738 }
739 
740 interface IUniswapV2Factory {
741     event PairCreated(
742         address indexed token0,
743         address indexed token1,
744         address pair,
745         uint256
746     );
747 
748     function createPair(address tokenA, address tokenB)
749         external
750         returns (address pair);
751 }
752 
753 interface IUniswapV2Router02 {
754     function factory() external pure returns (address);
755 
756     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
757         uint256 amountIn,
758         uint256 amountOutMin,
759         address[] calldata path,
760         address to,
761         uint256 deadline
762     ) external;
763 }
764 
765 contract PreMix is ERC20, Ownable {
766     using SafeMath for uint256;
767 
768     IUniswapV2Router02 public immutable uniswapV2Router;
769     address public immutable uniswapV2Pair;
770     address public constant deadAddress = address(0xdead);
771     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
772 
773     bool private swapping;
774 
775     address public devWallet;
776 
777     uint256 public maxTransactionAmount;
778     uint256 public swapTokensAtAmount;
779     uint256 public maxWallet;
780 
781     bool public limitsInEffect = true;
782     bool public tradingActive = false;
783     bool public swapEnabled = false;
784 
785     uint256 public buyTotalFees;
786     uint256 public buyDevFee;
787     uint256 public buyLiquidityFee;
788 
789     uint256 public sellTotalFees;
790     uint256 public sellDevFee;
791     uint256 public sellLiquidityFee;
792 
793     /******************/
794 
795     // exlcude from fees and max transaction amount
796     mapping(address => bool) private _isExcludedFromFees;
797     mapping(address => bool) public _isExcludedMaxTransactionAmount;
798 
799 
800     event ExcludeFromFees(address indexed account, bool isExcluded);
801 
802     event devWalletUpdated(
803         address indexed newWallet,
804         address indexed oldWallet
805     );
806 
807     constructor() ERC20("PreMix", "DEV") {
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
819 
820         uint256 _buyDevFee = 3;
821         uint256 _buyLiquidityFee = 3;
822 
823         uint256 _sellDevFee = 3;
824         uint256 _sellLiquidityFee = 3;
825 
826         uint256 totalSupply = 100_000_000_000 * 1e18;
827 
828         maxTransactionAmount =  totalSupply * 1 / 100; // 1% from total supply maxTransactionAmountTxn
829         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
830         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
831 
832         buyDevFee = _buyDevFee;
833         buyLiquidityFee = _buyLiquidityFee;
834         buyTotalFees = buyDevFee + buyLiquidityFee;
835 
836         sellDevFee = _sellDevFee;
837         sellLiquidityFee = _sellLiquidityFee;
838         sellTotalFees = sellDevFee + sellLiquidityFee;
839 
840         devWallet = address(0x488Fb03934ED10563aF2B5CD60E8434599Ba465f); // set as dev wallet
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
861     function enableTrading() external onlyOwner {
862         tradingActive = true;
863         swapEnabled = true;
864     }
865 
866     // remove limits after token is stable
867     function removeLimits() external onlyOwner returns (bool) {
868         limitsInEffect = false;
869         return true;
870     }
871 
872     // change the minimum amount of tokens to sell from fees
873     function updateSwapTokensAtAmount(uint256 newAmount)
874         external
875         onlyOwner
876         returns (bool)
877     {
878         require(
879             newAmount >= (totalSupply() * 1) / 100000,
880             "Swap amount cannot be lower than 0.001% total supply."
881         );
882         require(
883             newAmount <= (totalSupply() * 5) / 1000,
884             "Swap amount cannot be higher than 0.5% total supply."
885         );
886         swapTokensAtAmount = newAmount;
887         return true;
888     }
889 
890     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
891         require(
892             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
893             "Cannot set maxTransactionAmount lower than 0.1%"
894         );
895         maxTransactionAmount = newNum * (10**18);
896     }
897 
898     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
899         require(
900             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
901             "Cannot set maxWallet lower than 0.5%"
902         );
903         maxWallet = newNum * (10**18);
904     }
905 
906     function excludeFromMaxTransaction(address updAds, bool isEx)
907         public
908         onlyOwner
909     {
910         _isExcludedMaxTransactionAmount[updAds] = isEx;
911     }
912 
913     // only use to disable contract sales if absolutely necessary (emergency use only)
914     function updateSwapEnabled(bool enabled) external onlyOwner {
915         swapEnabled = enabled;
916     }
917 
918     function updateBuyFees(
919         uint256 _devFee,
920         uint256 _liquidityFee
921     ) external onlyOwner {
922         buyDevFee = _devFee;
923         buyLiquidityFee = _liquidityFee;
924         buyTotalFees = buyDevFee + buyLiquidityFee;
925         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
926     }
927 
928     function updateSellFees(
929         uint256 _devFee,
930         uint256 _liquidityFee
931     ) external onlyOwner {
932         sellDevFee = _devFee;
933         sellLiquidityFee = _liquidityFee;
934         sellTotalFees = sellDevFee + sellLiquidityFee;
935         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
936     }
937 
938     function excludeFromFees(address account, bool excluded) public onlyOwner {
939         _isExcludedFromFees[account] = excluded;
940         emit ExcludeFromFees(account, excluded);
941     }
942 
943     function updateDevWallet(address newDevWallet)
944         external
945         onlyOwner
946     {
947         emit devWalletUpdated(newDevWallet, devWallet);
948         devWallet = newDevWallet;
949     }
950 
951 
952     function isExcludedFromFees(address account) public view returns (bool) {
953         return _isExcludedFromFees[account];
954     }
955 
956     function _transfer(
957         address from,
958         address to,
959         uint256 amount
960     ) internal override {
961         require(from != address(0), "ERC20: transfer from the zero address");
962         require(to != address(0), "ERC20: transfer to the zero address");
963 
964         if (amount == 0) {
965             super._transfer(from, to, 0);
966             return;
967         }
968 
969         if (limitsInEffect) {
970             if (
971                 from != owner() &&
972                 to != owner() &&
973                 to != address(0) &&
974                 to != address(0xdead) &&
975                 !swapping
976             ) {
977                 if (!tradingActive) {
978                     require(
979                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
980                         "Trading is not active."
981                     );
982                 }
983 
984                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
985                 //when buy
986                 if (
987                     from == uniswapV2Pair &&
988                     !_isExcludedMaxTransactionAmount[to]
989                 ) {
990                     require(
991                         amount <= maxTransactionAmount,
992                         "Buy transfer amount exceeds the maxTransactionAmount."
993                     );
994                     require(
995                         amount + balanceOf(to) <= maxWallet,
996                         "Max wallet exceeded"
997                     );
998                 }
999                 else if (!_isExcludedMaxTransactionAmount[to]) {
1000                     require(
1001                         amount + balanceOf(to) <= maxWallet,
1002                         "Max wallet exceeded"
1003                     );
1004                 }
1005             }
1006         }
1007 
1008         uint256 contractTokenBalance = balanceOf(address(this));
1009 
1010         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1011 
1012         if (
1013             canSwap &&
1014             swapEnabled &&
1015             !swapping &&
1016             to == uniswapV2Pair &&
1017             !_isExcludedFromFees[from] &&
1018             !_isExcludedFromFees[to]
1019         ) {
1020             swapping = true;
1021 
1022             swapBack();
1023 
1024             swapping = false;
1025         }
1026 
1027         bool takeFee = !swapping;
1028 
1029         // if any account belongs to _isExcludedFromFee account then remove the fee
1030         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1031             takeFee = false;
1032         }
1033 
1034         uint256 fees = 0;
1035         uint256 tokensForLiquidity = 0;
1036         uint256 tokensForDev = 0;
1037         // only take fees on buys/sells, do not take on wallet transfers
1038         if (takeFee) {
1039             // on sell
1040             if (to == uniswapV2Pair && sellTotalFees > 0) {
1041                 fees = amount.mul(sellTotalFees).div(100);
1042                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1043                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1044             }
1045             // on buy
1046             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1047                 fees = amount.mul(buyTotalFees).div(100);
1048                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1049                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1050             }
1051 
1052             if (fees> 0) {
1053                 super._transfer(from, address(this), fees);
1054             }
1055             if (tokensForLiquidity > 0) {
1056                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1057             }
1058 
1059             amount -= fees;
1060         }
1061 
1062         super._transfer(from, to, amount);
1063     }
1064 
1065     function swapTokensForUSDC(uint256 tokenAmount) private {
1066         // generate the uniswap pair path of token -> weth
1067         address[] memory path = new address[](2);
1068         path[0] = address(this);
1069         path[1] = USDC;
1070 
1071         _approve(address(this), address(uniswapV2Router), tokenAmount);
1072 
1073         // make the swap
1074         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1075             tokenAmount,
1076             0, // accept any amount of USDC
1077             path,
1078             devWallet,
1079             block.timestamp
1080         );
1081     }
1082 
1083     function swapBack() private {
1084         uint256 contractBalance = balanceOf(address(this));
1085         if (contractBalance == 0) {
1086             return;
1087         }
1088 
1089         if (contractBalance > swapTokensAtAmount * 20) {
1090             contractBalance = swapTokensAtAmount * 20;
1091         }
1092 
1093         swapTokensForUSDC(contractBalance);
1094     }
1095 
1096 }