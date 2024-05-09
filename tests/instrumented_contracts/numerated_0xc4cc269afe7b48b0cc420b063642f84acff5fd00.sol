1 /**
2 
3 $HABIBI, Welcome to Qatar!
4 
5 Tax: 5/5
6 Total supply: 2022
7 Max transaction: 2%
8 Max wallet: 3%
9 
10 Twitter: https://twitter.com/Habibi_token/
11 Telegram: https://t.me/HabibiToken
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.17;
17 pragma experimental ABIEncoderV2;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev Initializes the contract setting the deployer as the initial owner.
36      */
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public virtual onlyOwner {
64         _transferOwnership(address(0));
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         _transferOwnership(newOwner);
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Internal function without access restriction.
79      */
80     function _transferOwnership(address newOwner) internal virtual {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
88 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
89 
90 /* pragma solidity ^0.8.0; */
91 
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) external returns (bool);
154 
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
171 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
172 
173 /* pragma solidity ^0.8.0; */
174 
175 /* import "../IERC20.sol"; */
176 
177 /**
178  * @dev Interface for the optional metadata functions from the ERC20 standard.
179  *
180  * _Available since v4.1._
181  */
182 interface IERC20Metadata is IERC20 {
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the symbol of the token.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the decimals places of the token.
195      */
196     function decimals() external view returns (uint8);
197 }
198 
199 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
200 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
201 
202 /* pragma solidity ^0.8.0; */
203 
204 /* import "./IERC20.sol"; */
205 /* import "./extensions/IERC20Metadata.sol"; */
206 /* import "../../utils/Context.sol"; */
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
488 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
489 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
490 
491 /* pragma solidity ^0.8.0; */
492 
493 // CAUTION
494 // This version of SafeMath should only be used with Solidity 0.8 or later,
495 // because it relies on the compiler's built in overflow checks.
496 
497 /**
498  * @dev Wrappers over Solidity's arithmetic operations.
499  *
500  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
501  * now has built in overflow checking.
502  */
503 library SafeMath {
504     /**
505      * @dev Returns the addition of two unsigned integers, with an overflow flag.
506      *
507      * _Available since v3.4._
508      */
509     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
510         unchecked {
511             uint256 c = a + b;
512             if (c < a) return (false, 0);
513             return (true, c);
514         }
515     }
516 
517     /**
518      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
519      *
520      * _Available since v3.4._
521      */
522     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
523         unchecked {
524             if (b > a) return (false, 0);
525             return (true, a - b);
526         }
527     }
528 
529     /**
530      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
531      *
532      * _Available since v3.4._
533      */
534     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
535         unchecked {
536             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
537             // benefit is lost if 'b' is also tested.
538             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
539             if (a == 0) return (true, 0);
540             uint256 c = a * b;
541             if (c / a != b) return (false, 0);
542             return (true, c);
543         }
544     }
545 
546     /**
547      * @dev Returns the division of two unsigned integers, with a division by zero flag.
548      *
549      * _Available since v3.4._
550      */
551     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
552         unchecked {
553             if (b == 0) return (false, 0);
554             return (true, a / b);
555         }
556     }
557 
558     /**
559      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
560      *
561      * _Available since v3.4._
562      */
563     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
564         unchecked {
565             if (b == 0) return (false, 0);
566             return (true, a % b);
567         }
568     }
569 
570     /**
571      * @dev Returns the addition of two unsigned integers, reverting on
572      * overflow.
573      *
574      * Counterpart to Solidity's `+` operator.
575      *
576      * Requirements:
577      *
578      * - Addition cannot overflow.
579      */
580     function add(uint256 a, uint256 b) internal pure returns (uint256) {
581         return a + b;
582     }
583 
584     /**
585      * @dev Returns the subtraction of two unsigned integers, reverting on
586      * overflow (when the result is negative).
587      *
588      * Counterpart to Solidity's `-` operator.
589      *
590      * Requirements:
591      *
592      * - Subtraction cannot overflow.
593      */
594     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a - b;
596     }
597 
598     /**
599      * @dev Returns the multiplication of two unsigned integers, reverting on
600      * overflow.
601      *
602      * Counterpart to Solidity's `*` operator.
603      *
604      * Requirements:
605      *
606      * - Multiplication cannot overflow.
607      */
608     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
609         return a * b;
610     }
611 
612     /**
613      * @dev Returns the integer division of two unsigned integers, reverting on
614      * division by zero. The result is rounded towards zero.
615      *
616      * Counterpart to Solidity's `/` operator.
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function div(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a / b;
624     }
625 
626     /**
627      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
628      * reverting when dividing by zero.
629      *
630      * Counterpart to Solidity's `%` operator. This function uses a `revert`
631      * opcode (which leaves remaining gas untouched) while Solidity uses an
632      * invalid opcode to revert (consuming all remaining gas).
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a % b;
640     }
641 
642     /**
643      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
644      * overflow (when the result is negative).
645      *
646      * CAUTION: This function is deprecated because it requires allocating memory for the error
647      * message unnecessarily. For custom revert reasons use {trySub}.
648      *
649      * Counterpart to Solidity's `-` operator.
650      *
651      * Requirements:
652      *
653      * - Subtraction cannot overflow.
654      */
655     function sub(
656         uint256 a,
657         uint256 b,
658         string memory errorMessage
659     ) internal pure returns (uint256) {
660         unchecked {
661             require(b <= a, errorMessage);
662             return a - b;
663         }
664     }
665 
666     /**
667      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
668      * division by zero. The result is rounded towards zero.
669      *
670      * Counterpart to Solidity's `/` operator. Note: this function uses a
671      * `revert` opcode (which leaves remaining gas untouched) while Solidity
672      * uses an invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function div(
679         uint256 a,
680         uint256 b,
681         string memory errorMessage
682     ) internal pure returns (uint256) {
683         unchecked {
684             require(b > 0, errorMessage);
685             return a / b;
686         }
687     }
688 
689     /**
690      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
691      * reverting with custom message when dividing by zero.
692      *
693      * CAUTION: This function is deprecated because it requires allocating memory for the error
694      * message unnecessarily. For custom revert reasons use {tryMod}.
695      *
696      * Counterpart to Solidity's `%` operator. This function uses a `revert`
697      * opcode (which leaves remaining gas untouched) while Solidity uses an
698      * invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      *
702      * - The divisor cannot be zero.
703      */
704     function mod(
705         uint256 a,
706         uint256 b,
707         string memory errorMessage
708     ) internal pure returns (uint256) {
709         unchecked {
710             require(b > 0, errorMessage);
711             return a % b;
712         }
713     }
714 }
715 
716 interface IUniswapV2Factory {
717     event PairCreated(
718         address indexed token0,
719         address indexed token1,
720         address pair,
721         uint256
722     );
723 
724     function createPair(address tokenA, address tokenB)
725         external
726         returns (address pair);
727 }
728 
729 interface IUniswapV2Router02 {
730     function factory() external pure returns (address);
731 
732     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
733         uint256 amountIn,
734         uint256 amountOutMin,
735         address[] calldata path,
736         address to,
737         uint256 deadline
738     ) external;
739 }
740 
741 contract Habibi is ERC20, Ownable {
742     using SafeMath for uint256;
743 
744     IUniswapV2Router02 public immutable uniswapV2Router;
745     address public immutable uniswapV2Pair;
746     address public constant deadAddress = address(0xdead);
747     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
748 
749     bool private swapping;
750 
751     address public devWallet;
752 
753     uint256 public maxTransactionAmount;
754     uint256 public swapTokensAtAmount;
755     uint256 public maxWallet;
756 
757     bool public limitsInEffect = true;
758     bool public tradingActive = false;
759     bool public swapEnabled = false;
760 
761     uint256 public buyTotalFees;
762     uint256 public buyDevFee;
763     uint256 public buyLiquidityFee;
764 
765     uint256 public sellTotalFees;
766     uint256 public sellDevFee;
767     uint256 public sellLiquidityFee;
768 
769     /******************/
770 
771     // exlcude from fees and max transaction amount
772     mapping(address => bool) private _isExcludedFromFees;
773     mapping(address => bool) public _isExcludedMaxTransactionAmount;
774 
775 
776     event ExcludeFromFees(address indexed account, bool isExcluded);
777 
778     event devWalletUpdated(
779         address indexed newWallet,
780         address indexed oldWallet
781     );
782 
783     constructor() ERC20("Welcome to Qatar", "HABIBI") {
784         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
785 
786         excludeFromMaxTransaction(address(_uniswapV2Router), true);
787         uniswapV2Router = _uniswapV2Router;
788 
789         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
790             .createPair(address(this), WETH);
791         excludeFromMaxTransaction(address(uniswapV2Pair), true);
792 
793 
794         uint256 _buyDevFee = 15;
795         uint256 _buyLiquidityFee = 0;
796 
797         uint256 _sellDevFee = 25;
798         uint256 _sellLiquidityFee = 0;
799 
800         uint256 totalSupply = 2_022 * 1e18;
801 
802         maxTransactionAmount =  totalSupply * 20 / 1000; // 2% from total supply maxTransactionAmountTxn
803         maxWallet = totalSupply * 30 / 1000; // 3% from total supply maxWallet
804         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
805 
806         buyDevFee = _buyDevFee;
807         buyLiquidityFee = _buyLiquidityFee;
808         buyTotalFees = buyDevFee + buyLiquidityFee;
809 
810         sellDevFee = _sellDevFee;
811         sellLiquidityFee = _sellLiquidityFee;
812         sellTotalFees = sellDevFee + sellLiquidityFee;
813 
814         devWallet = address(0x26A984a4F0899B5827d55ABa11E5De4997d5AF12); // set as dev wallet
815 
816         // exclude from paying fees or having max transaction amount
817         excludeFromFees(owner(), true);
818         excludeFromFees(devWallet, true);
819         excludeFromFees(address(this), true);
820         excludeFromFees(address(0xdead), true);
821 
822         excludeFromMaxTransaction(owner(), true);
823         excludeFromMaxTransaction(devWallet, true);
824         excludeFromMaxTransaction(address(this), true);
825         excludeFromMaxTransaction(address(0xdead), true);
826 
827         /*
828             _mint is an internal function in ERC20.sol that is only called here,
829             and CANNOT be called ever again
830         */
831         _mint(msg.sender, totalSupply);
832     }
833 
834     receive() external payable {}
835 
836     // once enabled, can never be turned off
837     function enableTrading() external onlyOwner {
838         tradingActive = true;
839         swapEnabled = true;
840     }
841 
842     // remove limits after token is stable
843     function removeLimits() external onlyOwner returns (bool) {
844         limitsInEffect = false;
845         return true;
846     }
847 
848     // change the minimum amount of tokens to sell from fees
849     function updateSwapTokensAtAmount(uint256 newAmount)
850         external
851         onlyOwner
852         returns (bool)
853     {
854         require(
855             newAmount >= (totalSupply() * 1) / 100000,
856             "Swap amount cannot be lower than 0.001% total supply."
857         );
858         require(
859             newAmount <= (totalSupply() * 5) / 1000,
860             "Swap amount cannot be higher than 0.5% total supply."
861         );
862         swapTokensAtAmount = newAmount;
863         return true;
864     }
865 
866     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
867         require(
868             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
869             "Cannot set maxTransactionAmount lower than 0.1%"
870         );
871         maxTransactionAmount = newNum * (10**18);
872     }
873 
874     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
875         require(
876             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
877             "Cannot set maxWallet lower than 0.5%"
878         );
879         maxWallet = newNum * (10**18);
880     }
881 
882     function excludeFromMaxTransaction(address updAds, bool isEx)
883         public
884         onlyOwner
885     {
886         _isExcludedMaxTransactionAmount[updAds] = isEx;
887     }
888 
889     // only use to disable contract sales if absolutely necessary (emergency use only)
890     function updateSwapEnabled(bool enabled) external onlyOwner {
891         swapEnabled = enabled;
892     }
893 
894     function updateBuyFees(
895         uint256 _devFee,
896         uint256 _liquidityFee
897     ) external onlyOwner {
898         buyDevFee = _devFee;
899         buyLiquidityFee = _liquidityFee;
900         buyTotalFees = buyDevFee + buyLiquidityFee;
901         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
902     }
903 
904     function updateSellFees(
905         uint256 _devFee,
906         uint256 _liquidityFee
907     ) external onlyOwner {
908         sellDevFee = _devFee;
909         sellLiquidityFee = _liquidityFee;
910         sellTotalFees = sellDevFee + sellLiquidityFee;
911         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
912     }
913 
914     function excludeFromFees(address account, bool excluded) public onlyOwner {
915         _isExcludedFromFees[account] = excluded;
916         emit ExcludeFromFees(account, excluded);
917     }
918 
919     function updateDevWallet(address newDevWallet)
920         external
921         onlyOwner
922     {
923         emit devWalletUpdated(newDevWallet, devWallet);
924         devWallet = newDevWallet;
925     }
926 
927 
928     function isExcludedFromFees(address account) public view returns (bool) {
929         return _isExcludedFromFees[account];
930     }
931 
932     function _transfer(
933         address from,
934         address to,
935         uint256 amount
936     ) internal override {
937         require(from != address(0), "ERC20: transfer from the zero address");
938         require(to != address(0), "ERC20: transfer to the zero address");
939 
940         if (amount == 0) {
941             super._transfer(from, to, 0);
942             return;
943         }
944 
945         if (limitsInEffect) {
946             if (
947                 from != owner() &&
948                 to != owner() &&
949                 to != address(0) &&
950                 to != address(0xdead) &&
951                 !swapping
952             ) {
953                 if (!tradingActive) {
954                     require(
955                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
956                         "Trading is not active."
957                     );
958                 }
959 
960                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
961                 //when buy
962                 if (
963                     from == uniswapV2Pair &&
964                     !_isExcludedMaxTransactionAmount[to]
965                 ) {
966                     require(
967                         amount <= maxTransactionAmount,
968                         "Buy transfer amount exceeds the maxTransactionAmount."
969                     );
970                     require(
971                         amount + balanceOf(to) <= maxWallet,
972                         "Max wallet exceeded"
973                     );
974                 }
975                 else if (!_isExcludedMaxTransactionAmount[to]) {
976                     require(
977                         amount + balanceOf(to) <= maxWallet,
978                         "Max wallet exceeded"
979                     );
980                 }
981             }
982         }
983 
984         uint256 contractTokenBalance = balanceOf(address(this));
985 
986         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
987 
988         if (
989             canSwap &&
990             swapEnabled &&
991             !swapping &&
992             to == uniswapV2Pair &&
993             !_isExcludedFromFees[from] &&
994             !_isExcludedFromFees[to]
995         ) {
996             swapping = true;
997 
998             swapBack();
999 
1000             swapping = false;
1001         }
1002 
1003         bool takeFee = !swapping;
1004 
1005         // if any account belongs to _isExcludedFromFee account then remove the fee
1006         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1007             takeFee = false;
1008         }
1009 
1010         uint256 fees = 0;
1011         uint256 tokensForLiquidity = 0;
1012         uint256 tokensForDev = 0;
1013         // only take fees on buys/sells, do not take on wallet transfers
1014         if (takeFee) {
1015             // on sell
1016             if (to == uniswapV2Pair && sellTotalFees > 0) {
1017                 fees = amount.mul(sellTotalFees).div(100);
1018                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1019                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1020             }
1021             // on buy
1022             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1023                 fees = amount.mul(buyTotalFees).div(100);
1024                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1025                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1026             }
1027 
1028             if (fees> 0) {
1029                 super._transfer(from, address(this), fees);
1030             }
1031             if (tokensForLiquidity > 0) {
1032                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1033             }
1034 
1035             amount -= fees;
1036         }
1037 
1038         super._transfer(from, to, amount);
1039     }
1040 
1041     function swapTokensForETH(uint256 tokenAmount) private {
1042         // generate the uniswap pair path of token -> weth
1043         address[] memory path = new address[](2);
1044         path[0] = address(this);
1045         path[1] = WETH;
1046 
1047         _approve(address(this), address(uniswapV2Router), tokenAmount);
1048 
1049         // make the swap
1050         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1051             tokenAmount,
1052             0, // accept any amount of ETH
1053             path,
1054             devWallet,
1055             block.timestamp
1056         );
1057     }
1058 
1059     function swapBack() private {
1060         uint256 contractBalance = balanceOf(address(this));
1061         if (contractBalance == 0) {
1062             return;
1063         }
1064 
1065         if (contractBalance > swapTokensAtAmount * 20) {
1066             contractBalance = swapTokensAtAmount * 20;
1067         }
1068 
1069         swapTokensForETH(contractBalance);
1070     }
1071 
1072 }