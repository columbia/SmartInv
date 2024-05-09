1 /*
2 
3 The life and story of the developer of $MUKI is a real-life legend and exemplifies the desire
4 required to become a successful sovereign of your own realm. The benevolent King of the Mountain,
5 leader of the mining dwarves, has made it his goal to bring prosperity to all of those who will join him.
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.10;
11 pragma experimental ABIEncoderV2;
12 
13 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 /* pragma solidity ^0.8.0; */
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
38 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
39 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
40 
41 /* pragma solidity ^0.8.0; */
42 
43 /* import "../utils/Context.sol"; */
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
116 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
117 
118 /* pragma solidity ^0.8.0; */
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `sender` to `recipient` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) external returns (bool);
182 
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
199 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
200 
201 /* pragma solidity ^0.8.0; */
202 
203 /* import "../IERC20.sol"; */
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
228 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
229 
230 /* pragma solidity ^0.8.0; */
231 
232 /* import "./IERC20.sol"; */
233 /* import "./extensions/IERC20Metadata.sol"; */
234 /* import "../../utils/Context.sol"; */
235 
236 /**
237  * @dev Implementation of the {IERC20} interface.
238  *
239  * This implementation is agnostic to the way tokens are created. This means
240  * that a supply mechanism has to be added in a derived contract using {_mint}.
241  * For a generic mechanism see {ERC20PresetMinterPauser}.
242  *
243  * TIP: For a detailed writeup see our guide
244  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
245  * to implement supply mechanisms].
246  *
247  * We have followed general OpenZeppelin Contracts guidelines: functions revert
248  * instead returning `false` on failure. This behavior is nonetheless
249  * conventional and does not conflict with the expectations of ERC20
250  * applications.
251  *
252  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
253  * This allows applications to reconstruct the allowance for all accounts just
254  * by listening to said events. Other implementations of the EIP may not emit
255  * these events, as it isn't required by the specification.
256  *
257  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
258  * functions have been added to mitigate the well-known issues around setting
259  * allowances. See {IERC20-approve}.
260  */
261 contract ERC20 is Context, IERC20, IERC20Metadata {
262     mapping(address => uint256) private _balances;
263 
264     mapping(address => mapping(address => uint256)) private _allowances;
265 
266     uint256 private _totalSupply;
267 
268     string private _name;
269     string private _symbol;
270 
271     /**
272      * @dev Sets the values for {name} and {symbol}.
273      *
274      * The default value of {decimals} is 18. To select a different value for
275      * {decimals} you should overload it.
276      *
277      * All two of these values are immutable: they can only be set once during
278      * construction.
279      */
280     constructor(string memory name_, string memory symbol_) {
281         _name = name_;
282         _symbol = symbol_;
283     }
284 
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     /**
293      * @dev Returns the symbol of the token, usually a shorter version of the
294      * name.
295      */
296     function symbol() public view virtual override returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @dev Returns the number of decimals used to get its user representation.
302      * For example, if `decimals` equals `2`, a balance of `505` tokens should
303      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
304      *
305      * Tokens usually opt for a value of 18, imitating the relationship between
306      * Ether and Wei. This is the value {ERC20} uses, unless this function is
307      * overridden;
308      *
309      * NOTE: This information is only used for _display_ purposes: it in
310      * no way affects any of the arithmetic of the contract, including
311      * {IERC20-balanceOf} and {IERC20-transfer}.
312      */
313     function decimals() public view virtual override returns (uint8) {
314         return 18;
315     }
316 
317     /**
318      * @dev See {IERC20-totalSupply}.
319      */
320     function totalSupply() public view virtual override returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {IERC20-balanceOf}.
326      */
327     function balanceOf(address account) public view virtual override returns (uint256) {
328         return _balances[account];
329     }
330 
331     /**
332      * @dev See {IERC20-transfer}.
333      *
334      * Requirements:
335      *
336      * - `recipient` cannot be the zero address.
337      * - the caller must have a balance of at least `amount`.
338      */
339     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
340         _transfer(_msgSender(), recipient, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender) public view virtual override returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {IERC20-approve}.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public virtual override returns (bool) {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * Requirements:
370      *
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for ``sender``'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) public virtual override returns (bool) {
381         _transfer(sender, recipient, amount);
382 
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
385         unchecked {
386             _approve(sender, _msgSender(), currentAllowance - amount);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Moves `amount` of tokens from `sender` to `recipient`.
394      *
395      * This internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         uint256 senderBalance = _balances[sender];
417         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
418         unchecked {
419             _balances[sender] = senderBalance - amount;
420         }
421         _balances[recipient] += amount;
422 
423         emit Transfer(sender, recipient, amount);
424 
425         _afterTokenTransfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a {Transfer} event with `from` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _beforeTokenTransfer(address(0), account, amount);
441 
442         _totalSupply += amount;
443         _balances[account] += amount;
444         emit Transfer(address(0), account, amount);
445 
446         _afterTokenTransfer(address(0), account, amount);
447     }
448 
449 
450     /**
451      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
452      *
453      * This internal function is equivalent to `approve`, and can be used to
454      * e.g. set automatic allowances for certain subsystems, etc.
455      *
456      * Emits an {Approval} event.
457      *
458      * Requirements:
459      *
460      * - `owner` cannot be the zero address.
461      * - `spender` cannot be the zero address.
462      */
463     function _approve(
464         address owner,
465         address spender,
466         uint256 amount
467     ) internal virtual {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470 
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     /**
476      * @dev Hook that is called before any transfer of tokens. This includes
477      * minting and burning.
478      *
479      * Calling conditions:
480      *
481      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
482      * will be transferred to `to`.
483      * - when `from` is zero, `amount` tokens will be minted for `to`.
484      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
485      * - `from` and `to` are never both zero.
486      *
487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
488      */
489     function _beforeTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 
495     /**
496      * @dev Hook that is called after any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * has been transferred to `to`.
503      * - when `from` is zero, `amount` tokens have been minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _afterTokenTransfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal virtual {}
514 }
515 
516 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
517 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
518 
519 /* pragma solidity ^0.8.0; */
520 
521 // CAUTION
522 // This version of SafeMath should only be used with Solidity 0.8 or later,
523 // because it relies on the compiler's built in overflow checks.
524 
525 /**
526  * @dev Wrappers over Solidity's arithmetic operations.
527  *
528  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
529  * now has built in overflow checking.
530  */
531 library SafeMath {
532     /**
533      * @dev Returns the addition of two unsigned integers, with an overflow flag.
534      *
535      * _Available since v3.4._
536      */
537     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
538         unchecked {
539             uint256 c = a + b;
540             if (c < a) return (false, 0);
541             return (true, c);
542         }
543     }
544 
545     /**
546      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
547      *
548      * _Available since v3.4._
549      */
550     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
551         unchecked {
552             if (b > a) return (false, 0);
553             return (true, a - b);
554         }
555     }
556 
557     /**
558      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
559      *
560      * _Available since v3.4._
561      */
562     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
563         unchecked {
564             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
565             // benefit is lost if 'b' is also tested.
566             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
567             if (a == 0) return (true, 0);
568             uint256 c = a * b;
569             if (c / a != b) return (false, 0);
570             return (true, c);
571         }
572     }
573 
574     /**
575      * @dev Returns the division of two unsigned integers, with a division by zero flag.
576      *
577      * _Available since v3.4._
578      */
579     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             if (b == 0) return (false, 0);
582             return (true, a / b);
583         }
584     }
585 
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
588      *
589      * _Available since v3.4._
590      */
591     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             if (b == 0) return (false, 0);
594             return (true, a % b);
595         }
596     }
597 
598     /**
599      * @dev Returns the addition of two unsigned integers, reverting on
600      * overflow.
601      *
602      * Counterpart to Solidity's `+` operator.
603      *
604      * Requirements:
605      *
606      * - Addition cannot overflow.
607      */
608     function add(uint256 a, uint256 b) internal pure returns (uint256) {
609         return a + b;
610     }
611 
612     /**
613      * @dev Returns the subtraction of two unsigned integers, reverting on
614      * overflow (when the result is negative).
615      *
616      * Counterpart to Solidity's `-` operator.
617      *
618      * Requirements:
619      *
620      * - Subtraction cannot overflow.
621      */
622     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a - b;
624     }
625 
626     /**
627      * @dev Returns the multiplication of two unsigned integers, reverting on
628      * overflow.
629      *
630      * Counterpart to Solidity's `*` operator.
631      *
632      * Requirements:
633      *
634      * - Multiplication cannot overflow.
635      */
636     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a * b;
638     }
639 
640     /**
641      * @dev Returns the integer division of two unsigned integers, reverting on
642      * division by zero. The result is rounded towards zero.
643      *
644      * Counterpart to Solidity's `/` operator.
645      *
646      * Requirements:
647      *
648      * - The divisor cannot be zero.
649      */
650     function div(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a / b;
652     }
653 
654     /**
655      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
656      * reverting when dividing by zero.
657      *
658      * Counterpart to Solidity's `%` operator. This function uses a `revert`
659      * opcode (which leaves remaining gas untouched) while Solidity uses an
660      * invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a % b;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
672      * overflow (when the result is negative).
673      *
674      * CAUTION: This function is deprecated because it requires allocating memory for the error
675      * message unnecessarily. For custom revert reasons use {trySub}.
676      *
677      * Counterpart to Solidity's `-` operator.
678      *
679      * Requirements:
680      *
681      * - Subtraction cannot overflow.
682      */
683     function sub(
684         uint256 a,
685         uint256 b,
686         string memory errorMessage
687     ) internal pure returns (uint256) {
688         unchecked {
689             require(b <= a, errorMessage);
690             return a - b;
691         }
692     }
693 
694     /**
695      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
696      * division by zero. The result is rounded towards zero.
697      *
698      * Counterpart to Solidity's `/` operator. Note: this function uses a
699      * `revert` opcode (which leaves remaining gas untouched) while Solidity
700      * uses an invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(
707         uint256 a,
708         uint256 b,
709         string memory errorMessage
710     ) internal pure returns (uint256) {
711         unchecked {
712             require(b > 0, errorMessage);
713             return a / b;
714         }
715     }
716 
717     /**
718      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
719      * reverting with custom message when dividing by zero.
720      *
721      * CAUTION: This function is deprecated because it requires allocating memory for the error
722      * message unnecessarily. For custom revert reasons use {tryMod}.
723      *
724      * Counterpart to Solidity's `%` operator. This function uses a `revert`
725      * opcode (which leaves remaining gas untouched) while Solidity uses an
726      * invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function mod(
733         uint256 a,
734         uint256 b,
735         string memory errorMessage
736     ) internal pure returns (uint256) {
737         unchecked {
738             require(b > 0, errorMessage);
739             return a % b;
740         }
741     }
742 }
743 
744 interface IUniswapV2Factory {
745     event PairCreated(
746         address indexed token0,
747         address indexed token1,
748         address pair,
749         uint256
750     );
751 
752     function createPair(address tokenA, address tokenB)
753         external
754         returns (address pair);
755 }
756 
757 interface IUniswapV2Router02 {
758     function factory() external pure returns (address);
759 
760     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
761         uint256 amountIn,
762         uint256 amountOutMin,
763         address[] calldata path,
764         address to,
765         uint256 deadline
766     ) external;
767 }
768 
769 contract TheMiningDwarf is ERC20, Ownable {
770     using SafeMath for uint256;
771 
772     IUniswapV2Router02 public immutable uniswapV2Router;
773     address public immutable uniswapV2Pair;
774     address public constant deadAddress = address(0xdead);
775     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
776     bool private swapping;
777 
778     address public devWallet;
779 
780     uint256 public maxTransactionAmount;
781     uint256 public swapTokensAtAmount;
782     uint256 public maxWallet;
783 
784     bool public limitsInEffect = true;
785     bool public tradingActive = false;
786     bool public swapEnabled = false;
787 
788     uint256 public buyTotalFees;
789     uint256 public buyDevFee;
790     uint256 public buyLiquidityFee;
791 
792     uint256 public sellTotalFees;
793     uint256 public sellDevFee;
794     uint256 public sellLiquidityFee;
795 
796     /******************/
797 
798     // exlcude from fees and max transaction amount
799     mapping(address => bool) private _isExcludedFromFees;
800     mapping(address => bool) public _isExcludedMaxTransactionAmount;
801 
802 
803     event ExcludeFromFees(address indexed account, bool isExcluded);
804 
805     event devWalletUpdated(
806         address indexed newWallet,
807         address indexed oldWallet
808     );
809 
810     constructor() ERC20("The Mining Dwarf", "MUKI") {
811         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
812             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
813         );
814 
815         excludeFromMaxTransaction(address(_uniswapV2Router), true);
816         uniswapV2Router = _uniswapV2Router;
817 
818         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
819             .createPair(address(this), USDC);
820         excludeFromMaxTransaction(address(uniswapV2Pair), true);
821 
822 
823         uint256 _buyDevFee = 4;
824         uint256 _buyLiquidityFee = 1;
825 
826         uint256 _sellDevFee = 4;
827         uint256 _sellLiquidityFee = 1;
828 
829         uint256 totalSupply = 100_000_000_000 * 1e18;
830 
831         maxTransactionAmount =  totalSupply * 1 / 100; // 1% from total supply maxTransactionAmountTxn
832         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
833         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
834 
835         buyDevFee = _buyDevFee;
836         buyLiquidityFee = _buyLiquidityFee;
837         buyTotalFees = buyDevFee + buyLiquidityFee;
838 
839         sellDevFee = _sellDevFee;
840         sellLiquidityFee = _sellLiquidityFee;
841         sellTotalFees = sellDevFee + sellLiquidityFee;
842 
843         devWallet = address(0xd4c62FC07b01E56b0C88DBDDA1442AF7F5b1aBF7); // set as dev wallet
844 
845         // exclude from paying fees or having max transaction amount
846         excludeFromFees(owner(), true);
847         excludeFromFees(address(this), true);
848         excludeFromFees(address(0xdead), true);
849 
850         excludeFromMaxTransaction(owner(), true);
851         excludeFromMaxTransaction(address(this), true);
852         excludeFromMaxTransaction(address(0xdead), true);
853 
854         /*
855             _mint is an internal function in ERC20.sol that is only called here,
856             and CANNOT be called ever again
857         */
858         _mint(msg.sender, totalSupply);
859     }
860 
861     receive() external payable {}
862 
863     // once enabled, can never be turned off
864     function enableTrading() external onlyOwner {
865         tradingActive = true;
866         swapEnabled = true;
867     }
868 
869     // remove limits after token is stable
870     function removeLimits() external onlyOwner returns (bool) {
871         limitsInEffect = false;
872         return true;
873     }
874 
875     // change the minimum amount of tokens to sell from fees
876     function updateSwapTokensAtAmount(uint256 newAmount)
877         external
878         onlyOwner
879         returns (bool)
880     {
881         require(
882             newAmount >= (totalSupply() * 1) / 100000,
883             "Swap amount cannot be lower than 0.001% total supply."
884         );
885         require(
886             newAmount <= (totalSupply() * 5) / 1000,
887             "Swap amount cannot be higher than 0.5% total supply."
888         );
889         swapTokensAtAmount = newAmount;
890         return true;
891     }
892 
893     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
894         require(
895             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
896             "Cannot set maxTransactionAmount lower than 0.1%"
897         );
898         maxTransactionAmount = newNum * (10**18);
899     }
900 
901     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
902         require(
903             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
904             "Cannot set maxWallet lower than 0.5%"
905         );
906         maxWallet = newNum * (10**18);
907     }
908 
909     function excludeFromMaxTransaction(address updAds, bool isEx)
910         public
911         onlyOwner
912     {
913         _isExcludedMaxTransactionAmount[updAds] = isEx;
914     }
915 
916     // only use to disable contract sales if absolutely necessary (emergency use only)
917     function updateSwapEnabled(bool enabled) external onlyOwner {
918         swapEnabled = enabled;
919     }
920 
921     function updateBuyFees(
922         uint256 _devFee,
923         uint256 _liquidityFee
924     ) external onlyOwner {
925         buyDevFee = _devFee;
926         buyLiquidityFee = _liquidityFee;
927         buyTotalFees = buyDevFee + buyLiquidityFee;
928         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
929     }
930 
931     function updateSellFees(
932         uint256 _devFee,
933         uint256 _liquidityFee
934     ) external onlyOwner {
935         sellDevFee = _devFee;
936         sellLiquidityFee = _liquidityFee;
937         sellTotalFees = sellDevFee + sellLiquidityFee;
938         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
939     }
940 
941     function excludeFromFees(address account, bool excluded) public onlyOwner {
942         _isExcludedFromFees[account] = excluded;
943         emit ExcludeFromFees(account, excluded);
944     }
945 
946     function updateDevWallet(address newDevWallet)
947         external
948         onlyOwner
949     {
950         emit devWalletUpdated(newDevWallet, devWallet);
951         devWallet = newDevWallet;
952     }
953 
954 
955     function isExcludedFromFees(address account) public view returns (bool) {
956         return _isExcludedFromFees[account];
957     }
958 
959     function _transfer(
960         address from,
961         address to,
962         uint256 amount
963     ) internal override {
964         require(from != address(0), "ERC20: transfer from the zero address");
965         require(to != address(0), "ERC20: transfer to the zero address");
966 
967         if (amount == 0) {
968             super._transfer(from, to, 0);
969             return;
970         }
971 
972         if (limitsInEffect) {
973             if (
974                 from != owner() &&
975                 to != owner() &&
976                 to != address(0) &&
977                 to != address(0xdead) &&
978                 !swapping
979             ) {
980                 if (!tradingActive) {
981                     require(
982                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
983                         "Trading is not active."
984                     );
985                 }
986 
987                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
988                 //when buy
989                 if (
990                     from == uniswapV2Pair &&
991                     !_isExcludedMaxTransactionAmount[to]
992                 ) {
993                     require(
994                         amount <= maxTransactionAmount,
995                         "Buy transfer amount exceeds the maxTransactionAmount."
996                     );
997                     require(
998                         amount + balanceOf(to) <= maxWallet,
999                         "Max wallet exceeded"
1000                     );
1001                 }
1002                 else if (!_isExcludedMaxTransactionAmount[to]) {
1003                     require(
1004                         amount + balanceOf(to) <= maxWallet,
1005                         "Max wallet exceeded"
1006                     );
1007                 }
1008             }
1009         }
1010 
1011         uint256 contractTokenBalance = balanceOf(address(this));
1012 
1013         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1014 
1015         if (
1016             canSwap &&
1017             swapEnabled &&
1018             !swapping &&
1019             to == uniswapV2Pair &&
1020             !_isExcludedFromFees[from] &&
1021             !_isExcludedFromFees[to]
1022         ) {
1023             swapping = true;
1024 
1025             swapBack();
1026 
1027             swapping = false;
1028         }
1029 
1030         bool takeFee = !swapping;
1031 
1032         // if any account belongs to _isExcludedFromFee account then remove the fee
1033         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1034             takeFee = false;
1035         }
1036 
1037         uint256 fees = 0;
1038         uint256 tokensForLiquidity = 0;
1039         uint256 tokensForDev = 0;
1040         // only take fees on buys/sells, do not take on wallet transfers
1041         if (takeFee) {
1042             // on sell
1043             if (to == uniswapV2Pair && sellTotalFees > 0) {
1044                 fees = amount.mul(sellTotalFees).div(100);
1045                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1046                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1047             }
1048             // on buy
1049             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1050                 fees = amount.mul(buyTotalFees).div(100);
1051                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1052                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1053             }
1054 
1055             if (fees> 0) {
1056                 super._transfer(from, address(this), fees);
1057             }
1058             if (tokensForLiquidity > 0) {
1059                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1060             }
1061 
1062             amount -= fees;
1063         }
1064 
1065         super._transfer(from, to, amount);
1066     }
1067 
1068     function swapTokensForUSDC(uint256 tokenAmount) private {
1069         // generate the uniswap pair path of token -> weth
1070         address[] memory path = new address[](2);
1071         path[0] = address(this);
1072         path[1] = USDC;
1073 
1074         _approve(address(this), address(uniswapV2Router), tokenAmount);
1075 
1076         // make the swap
1077         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1078             tokenAmount,
1079             0, // accept any amount of USDC
1080             path,
1081             devWallet,
1082             block.timestamp
1083         );
1084     }
1085 
1086     function swapBack() private {
1087         uint256 contractBalance = balanceOf(address(this));
1088         if (contractBalance == 0) {
1089             return;
1090         }
1091 
1092         if (contractBalance > swapTokensAtAmount * 20) {
1093             contractBalance = swapTokensAtAmount * 20;
1094         }
1095 
1096         swapTokensForUSDC(contractBalance);
1097     }
1098 
1099 }