1 /* Introducing Shiba Nodes (SHINO), the newest addition to the Shibarium network.
2 Shiba Nodes will be responsible for verifying transactions, maintaining
3 a copy of the blockchain, and participating in the consensus process. 
4 In return for these services, validators are rewarded with a share of the network’s transaction fees.*/
5 
6 // → Telegram: https://t.me/ShibaNodesERC
7 // → Twitter:  https://twitter.com/ShibaNodesERC
8 // → Website:  https://shibanodes.io/
9 // → Medium:   https://medium.com/@ShibaNodes
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.10;
12 pragma experimental ABIEncoderV2;
13 
14 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
15 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
16 
17 /* pragma solidity ^0.8.0; */
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
40 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
41 
42 /* pragma solidity ^0.8.0; */
43 
44 /* import "../utils/Context.sol"; */
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
117 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
118 
119 /* pragma solidity ^0.8.0; */
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external returns (bool);
183 
184     /**
185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
186      * another (`to`).
187      *
188      * Note that `value` may be zero.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     /**
193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
194      * a call to {approve}. `value` is the new allowance.
195      */
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 /* pragma solidity ^0.8.0; */
203 
204 /* import "../IERC20.sol"; */
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
229 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
230 
231 /* pragma solidity ^0.8.0; */
232 
233 /* import "./IERC20.sol"; */
234 /* import "./extensions/IERC20Metadata.sol"; */
235 /* import "../../utils/Context.sol"; */
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view virtual override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public virtual override returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * Requirements:
371      *
372      * - `sender` and `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      * - the caller must have allowance for ``sender``'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(
378         address sender,
379         address recipient,
380         uint256 amount
381     ) public virtual override returns (bool) {
382         _transfer(sender, recipient, amount);
383 
384         uint256 currentAllowance = _allowances[sender][_msgSender()];
385         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
386         unchecked {
387             _approve(sender, _msgSender(), currentAllowance - amount);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Moves `amount` of tokens from `sender` to `recipient`.
395      *
396      * This internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `sender` cannot be the zero address.
404      * - `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      */
407     function _transfer(
408         address sender,
409         address recipient,
410         uint256 amount
411     ) internal virtual {
412         require(sender != address(0), "ERC20: transfer from the zero address");
413         require(recipient != address(0), "ERC20: transfer to the zero address");
414 
415         _beforeTokenTransfer(sender, recipient, amount);
416 
417         uint256 senderBalance = _balances[sender];
418         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
419         unchecked {
420             _balances[sender] = senderBalance - amount;
421         }
422         _balances[recipient] += amount;
423 
424         emit Transfer(sender, recipient, amount);
425 
426         _afterTokenTransfer(sender, recipient, amount);
427     }
428 
429     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
430      * the total supply.
431      *
432      * Emits a {Transfer} event with `from` set to the zero address.
433      *
434      * Requirements:
435      *
436      * - `account` cannot be the zero address.
437      */
438     function _mint(address account, uint256 amount) internal virtual {
439         require(account != address(0), "ERC20: mint to the zero address");
440 
441         _beforeTokenTransfer(address(0), account, amount);
442 
443         _totalSupply += amount;
444         _balances[account] += amount;
445         emit Transfer(address(0), account, amount);
446 
447         _afterTokenTransfer(address(0), account, amount);
448     }
449 
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
453      *
454      * This internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471 
472         _allowances[owner][spender] = amount;
473         emit Approval(owner, spender, amount);
474     }
475 
476     /**
477      * @dev Hook that is called before any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * will be transferred to `to`.
484      * - when `from` is zero, `amount` tokens will be minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {}
495 
496     /**
497      * @dev Hook that is called after any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * has been transferred to `to`.
504      * - when `from` is zero, `amount` tokens have been minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _afterTokenTransfer(
511         address from,
512         address to,
513         uint256 amount
514     ) internal virtual {}
515 }
516 
517 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
518 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
519 
520 /* pragma solidity ^0.8.0; */
521 
522 // CAUTION
523 // This version of SafeMath should only be used with Solidity 0.8 or later,
524 // because it relies on the compiler's built in overflow checks.
525 
526 /**
527  * @dev Wrappers over Solidity's arithmetic operations.
528  *
529  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
530  * now has built in overflow checking.
531  */
532 library SafeMath {
533     /**
534      * @dev Returns the addition of two unsigned integers, with an overflow flag.
535      *
536      * _Available since v3.4._
537      */
538     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             uint256 c = a + b;
541             if (c < a) return (false, 0);
542             return (true, c);
543         }
544     }
545 
546     /**
547      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
548      *
549      * _Available since v3.4._
550      */
551     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
552         unchecked {
553             if (b > a) return (false, 0);
554             return (true, a - b);
555         }
556     }
557 
558     /**
559      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
560      *
561      * _Available since v3.4._
562      */
563     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
564         unchecked {
565             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
566             // benefit is lost if 'b' is also tested.
567             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
568             if (a == 0) return (true, 0);
569             uint256 c = a * b;
570             if (c / a != b) return (false, 0);
571             return (true, c);
572         }
573     }
574 
575     /**
576      * @dev Returns the division of two unsigned integers, with a division by zero flag.
577      *
578      * _Available since v3.4._
579      */
580     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             if (b == 0) return (false, 0);
583             return (true, a / b);
584         }
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
589      *
590      * _Available since v3.4._
591      */
592     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             if (b == 0) return (false, 0);
595             return (true, a % b);
596         }
597     }
598 
599     /**
600      * @dev Returns the addition of two unsigned integers, reverting on
601      * overflow.
602      *
603      * Counterpart to Solidity's `+` operator.
604      *
605      * Requirements:
606      *
607      * - Addition cannot overflow.
608      */
609     function add(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a + b;
611     }
612 
613     /**
614      * @dev Returns the subtraction of two unsigned integers, reverting on
615      * overflow (when the result is negative).
616      *
617      * Counterpart to Solidity's `-` operator.
618      *
619      * Requirements:
620      *
621      * - Subtraction cannot overflow.
622      */
623     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a - b;
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, reverting on
629      * overflow.
630      *
631      * Counterpart to Solidity's `*` operator.
632      *
633      * Requirements:
634      *
635      * - Multiplication cannot overflow.
636      */
637     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a * b;
639     }
640 
641     /**
642      * @dev Returns the integer division of two unsigned integers, reverting on
643      * division by zero. The result is rounded towards zero.
644      *
645      * Counterpart to Solidity's `/` operator.
646      *
647      * Requirements:
648      *
649      * - The divisor cannot be zero.
650      */
651     function div(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a / b;
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
657      * reverting when dividing by zero.
658      *
659      * Counterpart to Solidity's `%` operator. This function uses a `revert`
660      * opcode (which leaves remaining gas untouched) while Solidity uses an
661      * invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a % b;
669     }
670 
671     /**
672      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
673      * overflow (when the result is negative).
674      *
675      * CAUTION: This function is deprecated because it requires allocating memory for the error
676      * message unnecessarily. For custom revert reasons use {trySub}.
677      *
678      * Counterpart to Solidity's `-` operator.
679      *
680      * Requirements:
681      *
682      * - Subtraction cannot overflow.
683      */
684     function sub(
685         uint256 a,
686         uint256 b,
687         string memory errorMessage
688     ) internal pure returns (uint256) {
689         unchecked {
690             require(b <= a, errorMessage);
691             return a - b;
692         }
693     }
694 
695     /**
696      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
697      * division by zero. The result is rounded towards zero.
698      *
699      * Counterpart to Solidity's `/` operator. Note: this function uses a
700      * `revert` opcode (which leaves remaining gas untouched) while Solidity
701      * uses an invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function div(
708         uint256 a,
709         uint256 b,
710         string memory errorMessage
711     ) internal pure returns (uint256) {
712         unchecked {
713             require(b > 0, errorMessage);
714             return a / b;
715         }
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * reverting with custom message when dividing by zero.
721      *
722      * CAUTION: This function is deprecated because it requires allocating memory for the error
723      * message unnecessarily. For custom revert reasons use {tryMod}.
724      *
725      * Counterpart to Solidity's `%` operator. This function uses a `revert`
726      * opcode (which leaves remaining gas untouched) while Solidity uses an
727      * invalid opcode to revert (consuming all remaining gas).
728      *
729      * Requirements:
730      *
731      * - The divisor cannot be zero.
732      */
733     function mod(
734         uint256 a,
735         uint256 b,
736         string memory errorMessage
737     ) internal pure returns (uint256) {
738         unchecked {
739             require(b > 0, errorMessage);
740             return a % b;
741         }
742     }
743 }
744 
745 interface IUniswapV2Factory {
746     event PairCreated(
747         address indexed token0,
748         address indexed token1,
749         address pair,
750         uint256
751     );
752 
753     function createPair(address tokenA, address tokenB)
754         external
755         returns (address pair);
756 }
757 
758 interface IUniswapV2Router02 {
759     function factory() external pure returns (address);
760 
761     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
762         uint256 amountIn,
763         uint256 amountOutMin,
764         address[] calldata path,
765         address to,
766         uint256 deadline
767     ) external;
768 }
769 
770 contract SHINO is ERC20, Ownable {
771     using SafeMath for uint256;
772 
773     IUniswapV2Router02 public immutable uniswapV2Router;
774     address public immutable uniswapV2Pair;
775     address public constant deadAddress = address(0xdead);
776     address public ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
777 
778     bool private swapping;
779 
780     address private devWallet;
781 
782     uint256 public maxTransactionAmount;
783     uint256 public swapTokensAtAmount;
784     uint256 public maxWallet;
785 
786     bool public limitsInEffect = true;
787     bool public tradingActive = false;
788     bool public swapEnabled = true;
789 
790     uint256 public buyTotalFees;
791     uint256 public buydevfee;
792     uint256 public buyLiquidityFee;
793 
794     uint256 public sellTotalFees;
795     uint256 public selldevfee;
796     uint256 public sellLiquidityFee;
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
807     event devWalletUpdated(
808         address indexed newWallet,
809         address indexed oldWallet
810     );
811 
812     constructor() ERC20("Shiba Nodes", "SHINO") {
813         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
814             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
815         );
816 
817         excludeFromMaxTransaction(address(_uniswapV2Router), true);
818         uniswapV2Router = _uniswapV2Router;
819 
820         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
821             .createPair(address(this), ETH);
822         excludeFromMaxTransaction(address(uniswapV2Pair), true);
823 
824 
825         uint256 _buydevfee = 20;
826         uint256 _buyLiquidityFee = 5;
827 
828         uint256 _selldevfee = 20;
829         uint256 _sellLiquidityFee = 5;
830 
831         uint256 totalSupply = 1_000_000_000 * 1e18;
832 
833         maxTransactionAmount =  totalSupply * 20 / 1000; // 1% from total supply maxTransactionAmountTxn
834         maxWallet = totalSupply * 20 / 1000; // 2% from total supply maxWallet
835         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
836 
837         buydevfee = _buydevfee;
838         buyLiquidityFee = _buyLiquidityFee;
839         buyTotalFees = buydevfee + buyLiquidityFee;
840 
841         selldevfee = _selldevfee;
842         sellLiquidityFee = _sellLiquidityFee;
843         sellTotalFees = selldevfee + sellLiquidityFee;
844 
845         devWallet = address(msg.sender); // set as dev wallet
846 
847         // exclude from paying fees or having max transaction amount
848         excludeFromFees(owner(), true);
849         excludeFromFees(address(this), true);
850         excludeFromFees(address(0xdead), true);
851 
852         excludeFromMaxTransaction(owner(), true);
853         excludeFromMaxTransaction(address(this), true);
854         excludeFromMaxTransaction(address(0xdead), true);
855 
856         /*
857             _mint is an internal function in ERC20.sol that is only called here,
858             and CANNOT be called ever again
859         */
860         _mint(msg.sender, totalSupply);
861     }
862 
863     receive() external payable {}
864 
865     // once enabled, can never be turned off
866     function enableTrading() external onlyOwner {
867         tradingActive = true;
868         swapEnabled = true;
869     }
870 
871     // remove limits after token is stable
872     function removeLimits() external onlyOwner returns (bool) {
873         limitsInEffect = false;
874         return true;
875     }
876 
877     // change the minimum amount of tokens to sell from fees
878     function updateSwapTokensAtAmount(uint256 newAmount)
879         external
880         onlyOwner
881         returns (bool)
882     {
883         require(
884             newAmount >= (totalSupply() * 1) / 100000,
885             "Swap amount cannot be lower than 0.001% total supply."
886         );
887         require(
888             newAmount <= (totalSupply() * 5) / 1000,
889             "Swap amount cannot be higher than 0.5% total supply."
890         );
891         swapTokensAtAmount = newAmount;
892         return true;
893     }
894 
895     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
896         require(
897             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
898             "Cannot set maxTransactionAmount lower than 0.1%"
899         );
900         maxTransactionAmount = newNum * (10**18);
901     }
902 
903     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
904         require(
905             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
906             "Cannot set maxWallet lower than 0.5%"
907         );
908         maxWallet = newNum * (10**18);
909     }
910 
911     function excludeFromMaxTransaction(address updAds, bool isEx)
912         public
913         onlyOwner
914     {
915         _isExcludedMaxTransactionAmount[updAds] = isEx;
916     }
917 
918     // only use to disable contract sales if absolutely necessary (emergency use only)
919     function updateSwapEnabled(bool enabled) external onlyOwner {
920         swapEnabled = enabled;
921     }
922 
923     function updateBuyFees(
924         uint256 _devfee,
925         uint256 _liquidityFee
926     ) external onlyOwner {
927         buydevfee = _devfee;
928         buyLiquidityFee = _liquidityFee;
929         buyTotalFees = buydevfee + buyLiquidityFee;
930         require(buyTotalFees <= 30, "Must keep fees at 10% or less");
931     }
932 
933     function updateSellFees(
934         uint256 _devfee,
935         uint256 _liquidityFee
936     ) external onlyOwner {
937         selldevfee = _devfee;
938         sellLiquidityFee = _liquidityFee;
939         sellTotalFees = selldevfee + sellLiquidityFee;
940         require(sellTotalFees <= 50, "Must keep fees at 10% or less");
941     }
942 
943     function excludeFromFees(address account, bool excluded) public onlyOwner {
944         _isExcludedFromFees[account] = excluded;
945         emit ExcludeFromFees(account, excluded);
946     }
947 
948     function updateDevWallet(address newDevWallet)
949         external
950         onlyOwner
951     {
952         emit devWalletUpdated(newDevWallet, devWallet);
953         devWallet = newDevWallet;
954     }
955 
956 
957     function isExcludedFromFees(address account) public view returns (bool) {
958         return _isExcludedFromFees[account];
959     }
960 
961     function _transfer(
962         address from,
963         address to,
964         uint256 amount
965     ) internal override {
966         require(from != address(0), "ERC20: transfer from the zero address");
967         require(to != address(0), "ERC20: transfer to the zero address");
968 
969         if (amount == 0) {
970             super._transfer(from, to, 0);
971             return;
972         }
973 
974         if (limitsInEffect) {
975             if (
976                 from != owner() &&
977                 to != owner() &&
978                 to != address(0) &&
979                 to != address(0xdead) &&
980                 !swapping
981             ) {
982                 if (!tradingActive) {
983                     require(
984                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
985                         "Trading is not active."
986                     );
987                 }
988 
989                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
990                 //when buy
991                 if (
992                     from == uniswapV2Pair &&
993                     !_isExcludedMaxTransactionAmount[to]
994                 ) {
995                     require(
996                         amount <= maxTransactionAmount,
997                         "Buy transfer amount exceeds the maxTransactionAmount."
998                     );
999                     require(
1000                         amount + balanceOf(to) <= maxWallet,
1001                         "Max wallet exceeded"
1002                     );
1003                 }
1004                 else if (!_isExcludedMaxTransactionAmount[to]) {
1005                     require(
1006                         amount + balanceOf(to) <= maxWallet,
1007                         "Max wallet exceeded"
1008                     );
1009                 }
1010             }
1011         }
1012 
1013         uint256 contractTokenBalance = balanceOf(address(this));
1014 
1015         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1016 
1017         if (
1018             canSwap &&
1019             swapEnabled &&
1020             !swapping &&
1021             to == uniswapV2Pair &&
1022             !_isExcludedFromFees[from] &&
1023             !_isExcludedFromFees[to]
1024         ) {
1025             swapping = true;
1026 
1027             swapBack();
1028 
1029             swapping = false;
1030         }
1031 
1032         bool takeFee = !swapping;
1033 
1034         // if any account belongs to _isExcludedFromFee account then remove the fee
1035         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1036             takeFee = false;
1037         }
1038 
1039         uint256 fees = 0;
1040         uint256 tokensForLiquidity = 0;
1041         uint256 tokensForDev = 0;
1042         // only take fees on buys/sells, do not take on wallet transfers
1043         if (takeFee) {
1044             // on sell
1045             if (to == uniswapV2Pair && sellTotalFees > 0) {
1046                 fees = amount.mul(sellTotalFees).div(100);
1047                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1048                 tokensForDev = (fees * selldevfee) / sellTotalFees;
1049             }
1050             // on buy
1051             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1052                 fees = amount.mul(buyTotalFees).div(100);
1053                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1054                 tokensForDev = (fees * buydevfee) / buyTotalFees;
1055             }
1056 
1057             if (fees> 0) {
1058                 super._transfer(from, address(this), fees);
1059             }
1060             if (tokensForLiquidity > 0) {
1061                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1062             }
1063 
1064             amount -= fees;
1065         }
1066 
1067         super._transfer(from, to, amount);
1068     }
1069 
1070     function swapTokensForETH(uint256 tokenAmount) private {
1071         // generate the uniswap pair path of token -> weth
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = ETH;
1075 
1076         _approve(address(this), address(uniswapV2Router), tokenAmount);
1077 
1078         // make the swap
1079         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1080             tokenAmount,
1081             0, // accept any amount of WETH
1082             path,
1083             devWallet,
1084             block.timestamp
1085         );
1086     }
1087 
1088     function swapBack() private {
1089         uint256 contractBalance = balanceOf(address(this));
1090         if (contractBalance == 0) {
1091             return;
1092         }
1093 
1094         if (contractBalance > swapTokensAtAmount * 20) {
1095             contractBalance = swapTokensAtAmount * 20;
1096         }
1097 
1098         swapTokensForETH(contractBalance);
1099     }
1100 
1101 }