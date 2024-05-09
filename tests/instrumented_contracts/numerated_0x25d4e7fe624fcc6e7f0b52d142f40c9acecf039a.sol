1 /* Just like a dog Kennel protects
2  your furry friend from harm,
3   Kennel safeguards your valuable tokens against rug pulls. 
4   Launching first on the Ethereum blockchain,
5    Kennel is the secure solution for locking your liquidity pool tokens on SHIBARIUM*/
6 
7 //  Telegram: https://t.me/KennelLocker
8 //  Twitter:  https://twitter.com/KennelLocker
9 //  Medium:   https://medium.com/@KennelLocker
10 //  Website:  https://kennellocker.io/
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.10;
13 pragma experimental ABIEncoderV2;
14 
15 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
16 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
17 
18 /* pragma solidity ^0.8.0; */
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
41 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
42 
43 /* pragma solidity ^0.8.0; */
44 
45 /* import "../utils/Context.sol"; */
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 /* pragma solidity ^0.8.0; */
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
201 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 /* pragma solidity ^0.8.0; */
204 
205 /* import "../IERC20.sol"; */
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
230 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
231 
232 /* pragma solidity ^0.8.0; */
233 
234 /* import "./IERC20.sol"; */
235 /* import "./extensions/IERC20Metadata.sol"; */
236 /* import "../../utils/Context.sol"; */
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public virtual override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * Requirements:
372      *
373      * - `sender` and `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``sender``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) public virtual override returns (bool) {
383         _transfer(sender, recipient, amount);
384 
385         uint256 currentAllowance = _allowances[sender][_msgSender()];
386         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
387         unchecked {
388             _approve(sender, _msgSender(), currentAllowance - amount);
389         }
390 
391         return true;
392     }
393 
394     /**
395      * @dev Moves `amount` of tokens from `sender` to `recipient`.
396      *
397      * This internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(
409         address sender,
410         address recipient,
411         uint256 amount
412     ) internal virtual {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _beforeTokenTransfer(sender, recipient, amount);
417 
418         uint256 senderBalance = _balances[sender];
419         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
420         unchecked {
421             _balances[sender] = senderBalance - amount;
422         }
423         _balances[recipient] += amount;
424 
425         emit Transfer(sender, recipient, amount);
426 
427         _afterTokenTransfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a {Transfer} event with `from` set to the zero address.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal virtual {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _beforeTokenTransfer(address(0), account, amount);
443 
444         _totalSupply += amount;
445         _balances[account] += amount;
446         emit Transfer(address(0), account, amount);
447 
448         _afterTokenTransfer(address(0), account, amount);
449     }
450 
451 
452     /**
453      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
454      *
455      * This internal function is equivalent to `approve`, and can be used to
456      * e.g. set automatic allowances for certain subsystems, etc.
457      *
458      * Emits an {Approval} event.
459      *
460      * Requirements:
461      *
462      * - `owner` cannot be the zero address.
463      * - `spender` cannot be the zero address.
464      */
465     function _approve(
466         address owner,
467         address spender,
468         uint256 amount
469     ) internal virtual {
470         require(owner != address(0), "ERC20: approve from the zero address");
471         require(spender != address(0), "ERC20: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     /**
478      * @dev Hook that is called before any transfer of tokens. This includes
479      * minting and burning.
480      *
481      * Calling conditions:
482      *
483      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
484      * will be transferred to `to`.
485      * - when `from` is zero, `amount` tokens will be minted for `to`.
486      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
487      * - `from` and `to` are never both zero.
488      *
489      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
490      */
491     function _beforeTokenTransfer(
492         address from,
493         address to,
494         uint256 amount
495     ) internal virtual {}
496 
497     /**
498      * @dev Hook that is called after any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * has been transferred to `to`.
505      * - when `from` is zero, `amount` tokens have been minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _afterTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 }
517 
518 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
519 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
520 
521 /* pragma solidity ^0.8.0; */
522 
523 // CAUTION
524 // This version of SafeMath should only be used with Solidity 0.8 or later,
525 // because it relies on the compiler's built in overflow checks.
526 
527 /**
528  * @dev Wrappers over Solidity's arithmetic operations.
529  *
530  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
531  * now has built in overflow checking.
532  */
533 library SafeMath {
534     /**
535      * @dev Returns the addition of two unsigned integers, with an overflow flag.
536      *
537      * _Available since v3.4._
538      */
539     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
540         unchecked {
541             uint256 c = a + b;
542             if (c < a) return (false, 0);
543             return (true, c);
544         }
545     }
546 
547     /**
548      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
549      *
550      * _Available since v3.4._
551      */
552     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
553         unchecked {
554             if (b > a) return (false, 0);
555             return (true, a - b);
556         }
557     }
558 
559     /**
560      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
561      *
562      * _Available since v3.4._
563      */
564     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
565         unchecked {
566             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
567             // benefit is lost if 'b' is also tested.
568             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
569             if (a == 0) return (true, 0);
570             uint256 c = a * b;
571             if (c / a != b) return (false, 0);
572             return (true, c);
573         }
574     }
575 
576     /**
577      * @dev Returns the division of two unsigned integers, with a division by zero flag.
578      *
579      * _Available since v3.4._
580      */
581     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
582         unchecked {
583             if (b == 0) return (false, 0);
584             return (true, a / b);
585         }
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             if (b == 0) return (false, 0);
596             return (true, a % b);
597         }
598     }
599 
600     /**
601      * @dev Returns the addition of two unsigned integers, reverting on
602      * overflow.
603      *
604      * Counterpart to Solidity's `+` operator.
605      *
606      * Requirements:
607      *
608      * - Addition cannot overflow.
609      */
610     function add(uint256 a, uint256 b) internal pure returns (uint256) {
611         return a + b;
612     }
613 
614     /**
615      * @dev Returns the subtraction of two unsigned integers, reverting on
616      * overflow (when the result is negative).
617      *
618      * Counterpart to Solidity's `-` operator.
619      *
620      * Requirements:
621      *
622      * - Subtraction cannot overflow.
623      */
624     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
625         return a - b;
626     }
627 
628     /**
629      * @dev Returns the multiplication of two unsigned integers, reverting on
630      * overflow.
631      *
632      * Counterpart to Solidity's `*` operator.
633      *
634      * Requirements:
635      *
636      * - Multiplication cannot overflow.
637      */
638     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a * b;
640     }
641 
642     /**
643      * @dev Returns the integer division of two unsigned integers, reverting on
644      * division by zero. The result is rounded towards zero.
645      *
646      * Counterpart to Solidity's `/` operator.
647      *
648      * Requirements:
649      *
650      * - The divisor cannot be zero.
651      */
652     function div(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a / b;
654     }
655 
656     /**
657      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
658      * reverting when dividing by zero.
659      *
660      * Counterpart to Solidity's `%` operator. This function uses a `revert`
661      * opcode (which leaves remaining gas untouched) while Solidity uses an
662      * invalid opcode to revert (consuming all remaining gas).
663      *
664      * Requirements:
665      *
666      * - The divisor cannot be zero.
667      */
668     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
669         return a % b;
670     }
671 
672     /**
673      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
674      * overflow (when the result is negative).
675      *
676      * CAUTION: This function is deprecated because it requires allocating memory for the error
677      * message unnecessarily. For custom revert reasons use {trySub}.
678      *
679      * Counterpart to Solidity's `-` operator.
680      *
681      * Requirements:
682      *
683      * - Subtraction cannot overflow.
684      */
685     function sub(
686         uint256 a,
687         uint256 b,
688         string memory errorMessage
689     ) internal pure returns (uint256) {
690         unchecked {
691             require(b <= a, errorMessage);
692             return a - b;
693         }
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator. Note: this function uses a
701      * `revert` opcode (which leaves remaining gas untouched) while Solidity
702      * uses an invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function div(
709         uint256 a,
710         uint256 b,
711         string memory errorMessage
712     ) internal pure returns (uint256) {
713         unchecked {
714             require(b > 0, errorMessage);
715             return a / b;
716         }
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * reverting with custom message when dividing by zero.
722      *
723      * CAUTION: This function is deprecated because it requires allocating memory for the error
724      * message unnecessarily. For custom revert reasons use {tryMod}.
725      *
726      * Counterpart to Solidity's `%` operator. This function uses a `revert`
727      * opcode (which leaves remaining gas untouched) while Solidity uses an
728      * invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function mod(
735         uint256 a,
736         uint256 b,
737         string memory errorMessage
738     ) internal pure returns (uint256) {
739         unchecked {
740             require(b > 0, errorMessage);
741             return a % b;
742         }
743     }
744 }
745 
746 interface IUniswapV2Factory {
747     event PairCreated(
748         address indexed token0,
749         address indexed token1,
750         address pair,
751         uint256
752     );
753 
754     function createPair(address tokenA, address tokenB)
755         external
756         returns (address pair);
757 }
758 
759 interface IUniswapV2Router02 {
760     function factory() external pure returns (address);
761 
762     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
763         uint256 amountIn,
764         uint256 amountOutMin,
765         address[] calldata path,
766         address to,
767         uint256 deadline
768     ) external;
769 }
770 
771 contract KENNEL is ERC20, Ownable {
772     using SafeMath for uint256;
773 
774     IUniswapV2Router02 public immutable uniswapV2Router;
775     address public immutable uniswapV2Pair;
776     address public constant deadAddress = address(0xdead);
777     address public ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
778 
779     bool private swapping;
780 
781     address public deployerAddress;
782     address public lpLocker;
783 
784     address private devWallet;
785 
786     uint256 public maxTransactionAmount;
787     uint256 public swapTokensAtAmount;
788     uint256 public maxWallet;
789 
790     bool public limitsInEffect = true;
791     bool public tradingActive = false;
792     bool public swapEnabled = true;
793 
794     uint256 public buyTotalFees;
795     uint256 public buydevfee;
796     uint256 public buyLiquidityFee;
797 
798     uint256 public sellTotalFees;
799     uint256 public selldevfee;
800     uint256 public sellLiquidityFee;
801 
802     /******************/
803 
804     // exlcude from fees and max transaction amount
805     mapping(address => bool) private _isExcludedFromFees;
806     mapping(address => bool) public _isExcludedMaxTransactionAmount;
807 
808 
809     event ExcludeFromFees(address indexed account, bool isExcluded);
810 
811     event devWalletUpdated(
812         address indexed newWallet,
813         address indexed oldWallet
814     );
815 
816     constructor() ERC20("Kennel", "KENNEL") {
817         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
818             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
819         );
820 
821         excludeFromMaxTransaction(address(_uniswapV2Router), true);
822         uniswapV2Router = _uniswapV2Router;
823 
824         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
825             .createPair(address(this), ETH);
826         excludeFromMaxTransaction(address(uniswapV2Pair), true);
827 
828 
829         uint256 _buydevfee = 20;
830         uint256 _buyLiquidityFee = 5;
831 
832         uint256 _selldevfee = 20;
833         uint256 _sellLiquidityFee = 5;
834 
835         uint256 totalSupply = 100_000_000_000 * 1e18;
836 
837         maxTransactionAmount =  totalSupply * 20 / 1000; // 1% from total supply maxTransactionAmountTxn
838         maxWallet = totalSupply * 20 / 1000; // 2% from total supply maxWallet
839         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
840 
841         buydevfee = _buydevfee;
842         buyLiquidityFee = _buyLiquidityFee;
843         buyTotalFees = buydevfee + buyLiquidityFee;
844 
845         selldevfee = _selldevfee;
846         sellLiquidityFee = _sellLiquidityFee;
847         sellTotalFees = selldevfee + sellLiquidityFee;
848 
849         devWallet = address(msg.sender); // set as dev wallet
850         deployerAddress = address(msg.sender); 
851         lpLocker = address(msg.sender); 
852 
853         // exclude from paying fees or having max transaction amount
854         excludeFromFees(owner(), true);
855         excludeFromFees(address(this), true);
856         excludeFromFees(address(0xdead), true);
857         excludeFromFees(deployerAddress, true); // Deployer Address
858         excludeFromFees(lpLocker, true); // LP Locker
859 
860         excludeFromMaxTransaction(owner(), true);
861         excludeFromMaxTransaction(address(this), true);
862         excludeFromMaxTransaction(address(0xdead), true);
863         excludeFromMaxTransaction(deployerAddress, true); // Deployer Address
864         excludeFromMaxTransaction(lpLocker, true); // LP Locker
865 
866         /*
867             _mint is an internal function in ERC20.sol that is only called here,
868             and CANNOT be called ever again
869         */
870         _mint(msg.sender, totalSupply);
871     }
872 
873     receive() external payable {}
874 
875     // once enabled, can never be turned off
876     function enableTrading() external onlyOwner {
877         tradingActive = true;
878         swapEnabled = true;
879     }
880 
881     // remove limits after token is stable
882     function removeLimits() external onlyOwner returns (bool) {
883         limitsInEffect = false;
884         return true;
885     }
886 
887     // change the minimum amount of tokens to sell from fees
888     function updateSwapTokensAtAmount(uint256 newAmount)
889         external
890         onlyOwner
891         returns (bool)
892     {
893         require(
894             newAmount >= (totalSupply() * 1) / 100000,
895             "Swap amount cannot be lower than 0.001% total supply."
896         );
897         require(
898             newAmount <= (totalSupply() * 5) / 1000,
899             "Swap amount cannot be higher than 0.5% total supply."
900         );
901         swapTokensAtAmount = newAmount;
902         return true;
903     }
904 
905     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
906         require(
907             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
908             "Cannot set maxTransactionAmount lower than 0.1%"
909         );
910         maxTransactionAmount = newNum * (10**18);
911     }
912 
913     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
914         require(
915             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
916             "Cannot set maxWallet lower than 0.5%"
917         );
918         maxWallet = newNum * (10**18);
919     }
920 
921     function excludeFromMaxTransaction(address updAds, bool isEx)
922         public
923         onlyOwner
924     {
925         _isExcludedMaxTransactionAmount[updAds] = isEx;
926     }
927 
928     // only use to disable contract sales if absolutely necessary (emergency use only)
929     function updateSwapEnabled(bool enabled) external onlyOwner {
930         swapEnabled = enabled;
931     }
932 
933     function updateBuyFees(
934         uint256 _devfee,
935         uint256 _liquidityFee
936     ) external onlyOwner {
937         buydevfee = _devfee;
938         buyLiquidityFee = _liquidityFee;
939         buyTotalFees = buydevfee + buyLiquidityFee;
940         require(buyTotalFees <= 30, "Must keep fees at 10% or less");
941     }
942 
943     function updateSellFees(
944         uint256 _devfee,
945         uint256 _liquidityFee
946     ) external onlyOwner {
947         selldevfee = _devfee;
948         sellLiquidityFee = _liquidityFee;
949         sellTotalFees = selldevfee + sellLiquidityFee;
950         require(sellTotalFees <= 50, "Must keep fees at 10% or less");
951     }
952 
953     function excludeFromFees(address account, bool excluded) public onlyOwner {
954         _isExcludedFromFees[account] = excluded;
955         emit ExcludeFromFees(account, excluded);
956     }
957 
958     function updateDevWallet(address newDevWallet)
959         external
960         onlyOwner
961     {
962         emit devWalletUpdated(newDevWallet, devWallet);
963         devWallet = newDevWallet;
964     }
965 
966 
967     function isExcludedFromFees(address account) public view returns (bool) {
968         return _isExcludedFromFees[account];
969     }
970 
971     function _transfer(
972         address from,
973         address to,
974         uint256 amount
975     ) internal override {
976         require(from != address(0), "ERC20: transfer from the zero address");
977         require(to != address(0), "ERC20: transfer to the zero address");
978 
979         if (amount == 0) {
980             super._transfer(from, to, 0);
981             return;
982         }
983 
984         if (limitsInEffect) {
985             if (
986                 from != owner() &&
987                 to != owner() &&
988                 to != address(0) &&
989                 to != address(0xdead) &&
990                 !swapping
991             ) {
992                 if (!tradingActive) {
993                     require(
994                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
995                         "Trading is not active."
996                     );
997                 }
998 
999                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1000                 //when buy
1001                 if (
1002                     from == uniswapV2Pair &&
1003                     !_isExcludedMaxTransactionAmount[to]
1004                 ) {
1005                     require(
1006                         amount <= maxTransactionAmount,
1007                         "Buy transfer amount exceeds the maxTransactionAmount."
1008                     );
1009                     require(
1010                         amount + balanceOf(to) <= maxWallet,
1011                         "Max wallet exceeded"
1012                     );
1013                 }
1014                 else if (!_isExcludedMaxTransactionAmount[to]) {
1015                     require(
1016                         amount + balanceOf(to) <= maxWallet,
1017                         "Max wallet exceeded"
1018                     );
1019                 }
1020             }
1021         }
1022 
1023         uint256 contractTokenBalance = balanceOf(address(this));
1024 
1025         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1026 
1027         if (
1028             canSwap &&
1029             swapEnabled &&
1030             !swapping &&
1031             to == uniswapV2Pair &&
1032             !_isExcludedFromFees[from] &&
1033             !_isExcludedFromFees[to]
1034         ) {
1035             swapping = true;
1036 
1037             swapBack();
1038 
1039             swapping = false;
1040         }
1041 
1042         bool takeFee = !swapping;
1043 
1044         // if any account belongs to _isExcludedFromFee account then remove the fee
1045         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1046             takeFee = false;
1047         }
1048 
1049         uint256 fees = 0;
1050         uint256 tokensForLiquidity = 0;
1051         uint256 tokensForDev = 0;
1052         // only take fees on buys/sells, do not take on wallet transfers
1053         if (takeFee) {
1054             // on sell
1055             if (to == uniswapV2Pair && sellTotalFees > 0) {
1056                 fees = amount.mul(sellTotalFees).div(100);
1057                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1058                 tokensForDev = (fees * selldevfee) / sellTotalFees;
1059             }
1060             // on buy
1061             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1062                 fees = amount.mul(buyTotalFees).div(100);
1063                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1064                 tokensForDev = (fees * buydevfee) / buyTotalFees;
1065             }
1066 
1067             if (fees> 0) {
1068                 super._transfer(from, address(this), fees);
1069             }
1070             if (tokensForLiquidity > 0) {
1071                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1072             }
1073 
1074             amount -= fees;
1075         }
1076 
1077         super._transfer(from, to, amount);
1078     }
1079 
1080     function swapTokensForETH(uint256 tokenAmount) private {
1081         // generate the uniswap pair path of token -> weth
1082         address[] memory path = new address[](2);
1083         path[0] = address(this);
1084         path[1] = ETH;
1085 
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087 
1088         // make the swap
1089         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1090             tokenAmount,
1091             0, // accept any amount of WETH
1092             path,
1093             devWallet,
1094             block.timestamp
1095         );
1096     }
1097 
1098     function swapBack() private {
1099         uint256 contractBalance = balanceOf(address(this));
1100         if (contractBalance == 0) {
1101             return;
1102         }
1103 
1104         if (contractBalance > swapTokensAtAmount * 20) {
1105             contractBalance = swapTokensAtAmount * 20;
1106         }
1107 
1108         swapTokensForETH(contractBalance);
1109     }
1110 
1111 }