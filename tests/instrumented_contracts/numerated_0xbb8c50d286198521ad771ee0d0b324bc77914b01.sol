1 /**
2 
3 #PUMPTOBER the month where all your degen wishes come true.
4 
5 Just imagine....market getting green, memecoins are pumping, and #PUMPTOBER is leading the way!
6 
7 It is that time of the year again, when all hope in the simple degen life gets restored!
8 
9 Are you ready for the pump?
10 
11 
12 Telegram: https://t.me/pumptobertoken
13 Twitter: https://twitter.com/PumptoberEth
14 
15 */
16 
17 pragma solidity ^0.8.10;
18 pragma experimental ABIEncoderV2;
19 
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
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         _transferOwnership(_msgSender());
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * NOTE: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public virtual onlyOwner {
65         _transferOwnership(address(0));
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Can only be called by the current owner.
71      */
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         _transferOwnership(newOwner);
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Internal function without access restriction.
80      */
81     function _transferOwnership(address newOwner) internal virtual {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
89 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
90 
91 /* pragma solidity ^0.8.0; */
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
172 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
173 
174 /* pragma solidity ^0.8.0; */
175 
176 /* import "../IERC20.sol"; */
177 
178 /**
179  * @dev Interface for the optional metadata functions from the ERC20 standard.
180  *
181  * _Available since v4.1._
182  */
183 interface IERC20Metadata is IERC20 {
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the symbol of the token.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the decimals places of the token.
196      */
197     function decimals() external view returns (uint8);
198 }
199 
200 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
201 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
202 
203 /* pragma solidity ^0.8.0; */
204 
205 /* import "./IERC20.sol"; */
206 /* import "./extensions/IERC20Metadata.sol"; */
207 /* import "../../utils/Context.sol"; */
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin Contracts guidelines: functions revert
221  * instead returning `false` on failure. This behavior is nonetheless
222  * conventional and does not conflict with the expectations of ERC20
223  * applications.
224  *
225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
226  * This allows applications to reconstruct the allowance for all accounts just
227  * by listening to said events. Other implementations of the EIP may not emit
228  * these events, as it isn't required by the specification.
229  *
230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
231  * functions have been added to mitigate the well-known issues around setting
232  * allowances. See {IERC20-approve}.
233  */
234 contract ERC20 is Context, IERC20, IERC20Metadata {
235     mapping(address => uint256) private _balances;
236 
237     mapping(address => mapping(address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     string private _name;
242     string private _symbol;
243 
244     /**
245      * @dev Sets the values for {name} and {symbol}.
246      *
247      * The default value of {decimals} is 18. To select a different value for
248      * {decimals} you should overload it.
249      *
250      * All two of these values are immutable: they can only be set once during
251      * construction.
252      */
253     constructor(string memory name_, string memory symbol_) {
254         _name = name_;
255         _symbol = symbol_;
256     }
257 
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264 
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view virtual override returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
280      * overridden;
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view virtual override returns (uint8) {
287         return 18;
288     }
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view virtual override returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view virtual override returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * Requirements:
343      *
344      * - `sender` and `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `amount`.
346      * - the caller must have allowance for ``sender``'s tokens of at least
347      * `amount`.
348      */
349     function transferFrom(
350         address sender,
351         address recipient,
352         uint256 amount
353     ) public virtual override returns (bool) {
354         _transfer(sender, recipient, amount);
355 
356         uint256 currentAllowance = _allowances[sender][_msgSender()];
357         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
358         unchecked {
359             _approve(sender, _msgSender(), currentAllowance - amount);
360         }
361 
362         return true;
363     }
364 
365     /**
366      * @dev Moves `amount` of tokens from `sender` to `recipient`.
367      *
368      * This internal function is equivalent to {transfer}, and can be used to
369      * e.g. implement automatic token fees, slashing mechanisms, etc.
370      *
371      * Emits a {Transfer} event.
372      *
373      * Requirements:
374      *
375      * - `sender` cannot be the zero address.
376      * - `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      */
379     function _transfer(
380         address sender,
381         address recipient,
382         uint256 amount
383     ) internal virtual {
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386 
387         _beforeTokenTransfer(sender, recipient, amount);
388 
389         uint256 senderBalance = _balances[sender];
390         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
391         unchecked {
392             _balances[sender] = senderBalance - amount;
393         }
394         _balances[recipient] += amount;
395 
396         emit Transfer(sender, recipient, amount);
397 
398         _afterTokenTransfer(sender, recipient, amount);
399     }
400 
401     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
402      * the total supply.
403      *
404      * Emits a {Transfer} event with `from` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      */
410     function _mint(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: mint to the zero address");
412 
413         _beforeTokenTransfer(address(0), account, amount);
414 
415         _totalSupply += amount;
416         _balances[account] += amount;
417         emit Transfer(address(0), account, amount);
418 
419         _afterTokenTransfer(address(0), account, amount);
420     }
421 
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(
437         address owner,
438         address spender,
439         uint256 amount
440     ) internal virtual {
441         require(owner != address(0), "ERC20: approve from the zero address");
442         require(spender != address(0), "ERC20: approve to the zero address");
443 
444         _allowances[owner][spender] = amount;
445         emit Approval(owner, spender, amount);
446     }
447 
448     /**
449      * @dev Hook that is called before any transfer of tokens. This includes
450      * minting and burning.
451      *
452      * Calling conditions:
453      *
454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
455      * will be transferred to `to`.
456      * - when `from` is zero, `amount` tokens will be minted for `to`.
457      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
458      * - `from` and `to` are never both zero.
459      *
460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
461      */
462     function _beforeTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 
468     /**
469      * @dev Hook that is called after any transfer of tokens. This includes
470      * minting and burning.
471      *
472      * Calling conditions:
473      *
474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
475      * has been transferred to `to`.
476      * - when `from` is zero, `amount` tokens have been minted for `to`.
477      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
478      * - `from` and `to` are never both zero.
479      *
480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
481      */
482     function _afterTokenTransfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {}
487 }
488 
489 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
490 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
491 
492 /* pragma solidity ^0.8.0; */
493 
494 // CAUTION
495 // This version of SafeMath should only be used with Solidity 0.8 or later,
496 // because it relies on the compiler's built in overflow checks.
497 
498 /**
499  * @dev Wrappers over Solidity's arithmetic operations.
500  *
501  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
502  * now has built in overflow checking.
503  */
504 library SafeMath {
505     /**
506      * @dev Returns the addition of two unsigned integers, with an overflow flag.
507      *
508      * _Available since v3.4._
509      */
510     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
511         unchecked {
512             uint256 c = a + b;
513             if (c < a) return (false, 0);
514             return (true, c);
515         }
516     }
517 
518     /**
519      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
520      *
521      * _Available since v3.4._
522      */
523     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
524         unchecked {
525             if (b > a) return (false, 0);
526             return (true, a - b);
527         }
528     }
529 
530     /**
531      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
532      *
533      * _Available since v3.4._
534      */
535     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
536         unchecked {
537             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
538             // benefit is lost if 'b' is also tested.
539             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
540             if (a == 0) return (true, 0);
541             uint256 c = a * b;
542             if (c / a != b) return (false, 0);
543             return (true, c);
544         }
545     }
546 
547     /**
548      * @dev Returns the division of two unsigned integers, with a division by zero flag.
549      *
550      * _Available since v3.4._
551      */
552     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
553         unchecked {
554             if (b == 0) return (false, 0);
555             return (true, a / b);
556         }
557     }
558 
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
561      *
562      * _Available since v3.4._
563      */
564     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
565         unchecked {
566             if (b == 0) return (false, 0);
567             return (true, a % b);
568         }
569     }
570 
571     /**
572      * @dev Returns the addition of two unsigned integers, reverting on
573      * overflow.
574      *
575      * Counterpart to Solidity's `+` operator.
576      *
577      * Requirements:
578      *
579      * - Addition cannot overflow.
580      */
581     function add(uint256 a, uint256 b) internal pure returns (uint256) {
582         return a + b;
583     }
584 
585     /**
586      * @dev Returns the subtraction of two unsigned integers, reverting on
587      * overflow (when the result is negative).
588      *
589      * Counterpart to Solidity's `-` operator.
590      *
591      * Requirements:
592      *
593      * - Subtraction cannot overflow.
594      */
595     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
596         return a - b;
597     }
598 
599     /**
600      * @dev Returns the multiplication of two unsigned integers, reverting on
601      * overflow.
602      *
603      * Counterpart to Solidity's `*` operator.
604      *
605      * Requirements:
606      *
607      * - Multiplication cannot overflow.
608      */
609     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a * b;
611     }
612 
613     /**
614      * @dev Returns the integer division of two unsigned integers, reverting on
615      * division by zero. The result is rounded towards zero.
616      *
617      * Counterpart to Solidity's `/` operator.
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function div(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a / b;
625     }
626 
627     /**
628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
629      * reverting when dividing by zero.
630      *
631      * Counterpart to Solidity's `%` operator. This function uses a `revert`
632      * opcode (which leaves remaining gas untouched) while Solidity uses an
633      * invalid opcode to revert (consuming all remaining gas).
634      *
635      * Requirements:
636      *
637      * - The divisor cannot be zero.
638      */
639     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
640         return a % b;
641     }
642 
643     /**
644      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
645      * overflow (when the result is negative).
646      *
647      * CAUTION: This function is deprecated because it requires allocating memory for the error
648      * message unnecessarily. For custom revert reasons use {trySub}.
649      *
650      * Counterpart to Solidity's `-` operator.
651      *
652      * Requirements:
653      *
654      * - Subtraction cannot overflow.
655      */
656     function sub(
657         uint256 a,
658         uint256 b,
659         string memory errorMessage
660     ) internal pure returns (uint256) {
661         unchecked {
662             require(b <= a, errorMessage);
663             return a - b;
664         }
665     }
666 
667     /**
668      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
669      * division by zero. The result is rounded towards zero.
670      *
671      * Counterpart to Solidity's `/` operator. Note: this function uses a
672      * `revert` opcode (which leaves remaining gas untouched) while Solidity
673      * uses an invalid opcode to revert (consuming all remaining gas).
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function div(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b > 0, errorMessage);
686             return a / b;
687         }
688     }
689 
690     /**
691      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
692      * reverting with custom message when dividing by zero.
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {tryMod}.
696      *
697      * Counterpart to Solidity's `%` operator. This function uses a `revert`
698      * opcode (which leaves remaining gas untouched) while Solidity uses an
699      * invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function mod(
706         uint256 a,
707         uint256 b,
708         string memory errorMessage
709     ) internal pure returns (uint256) {
710         unchecked {
711             require(b > 0, errorMessage);
712             return a % b;
713         }
714     }
715 }
716 
717 interface IUniswapV2Factory {
718     event PairCreated(
719         address indexed token0,
720         address indexed token1,
721         address pair,
722         uint256
723     );
724 
725     function createPair(address tokenA, address tokenB)
726         external
727         returns (address pair);
728 }
729 
730 interface IUniswapV2Router02 {
731     function factory() external pure returns (address);
732 
733     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
734         uint256 amountIn,
735         uint256 amountOutMin,
736         address[] calldata path,
737         address to,
738         uint256 deadline
739     ) external;
740 }
741 
742 contract Pumptober is ERC20, Ownable {
743     using SafeMath for uint256;
744 
745     IUniswapV2Router02 public immutable uniswapV2Router;
746     address public immutable uniswapV2Pair;
747     address public constant deadAddress = address(0xdead);
748     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
749     uint256 public PUMPTOBER_START = 1664582400;
750 
751     bool private swapping;
752 
753     address public devWallet;
754 
755     uint256 public maxTransactionAmount;
756     uint256 public swapTokensAtAmount;
757     uint256 public maxWallet;
758 
759     bool public limitsInEffect = true;
760     bool public tradingActive = false;
761     bool public swapEnabled = false;
762 
763     uint256 public buyTotalFees;
764     uint256 public buyDevFee;
765     uint256 public buyLiquidityFee;
766     uint256 public pumptoberBuyDevFee;
767     uint256 public pumptoberBuyLiquidityFee;
768 
769     uint256 public sellTotalFees;
770     uint256 public sellDevFee;
771     uint256 public sellLiquidityFee;
772     uint256 public pumptoberSellDevFee;
773     uint256 public pumptoberSellLiquidityFee;
774 
775     /******************/
776 
777     // exlcude from fees and max transaction amount
778     mapping(address => bool) private _isExcludedFromFees;
779     mapping(address => bool) public _isExcludedMaxTransactionAmount;
780 
781 
782     event ExcludeFromFees(address indexed account, bool isExcluded);
783 
784     event devWalletUpdated(
785         address indexed newWallet,
786         address indexed oldWallet
787     );
788 
789     constructor() ERC20("Pumptober", "PUMPTOBER") {
790         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
791 
792         excludeFromMaxTransaction(address(_uniswapV2Router), true);
793         uniswapV2Router = _uniswapV2Router;
794 
795         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
796             .createPair(address(this), WETH);
797         excludeFromMaxTransaction(address(uniswapV2Pair), true);
798 
799 
800         uint256 _buyDevFee = 5;
801         uint256 _buyLiquidityFee = 5;
802         uint256 _pumptoberBuyDevFee = 1;
803         uint256 _pumptoberBuyLiquidityFee = 0;
804 
805         uint256 _sellDevFee = 20;
806         uint256 _sellLiquidityFee = 20;
807         uint256 _pumptoberSellDevFee = 3;
808         uint256 _pumptoberSellLiquidityFee = 0;
809 
810         uint256 totalSupply = 10_000_000 * 1e18;
811 
812         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
813         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
814         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
815 
816         buyDevFee = _buyDevFee;
817         buyLiquidityFee = _buyLiquidityFee;
818         pumptoberBuyDevFee = _pumptoberBuyDevFee;
819         pumptoberBuyLiquidityFee = _pumptoberBuyLiquidityFee;
820         buyTotalFees = buyDevFee + buyLiquidityFee;
821 
822         sellDevFee = _sellDevFee;
823         sellLiquidityFee = _sellLiquidityFee;
824         pumptoberSellDevFee = _pumptoberSellDevFee;
825         pumptoberSellLiquidityFee = _pumptoberSellLiquidityFee;
826         sellTotalFees = sellDevFee + sellLiquidityFee;
827 
828         devWallet = address(0x6a064c6A0968279f8f8Cbb075fc577181f94Ff93); // set as dev wallet
829 
830         // exclude from paying fees or having max transaction amount
831         excludeFromFees(owner(), true);
832         excludeFromFees(devWallet, true);
833         excludeFromFees(address(this), true);
834         excludeFromFees(address(0xdead), true);
835 
836         excludeFromMaxTransaction(owner(), true);
837         excludeFromMaxTransaction(devWallet, true);
838         excludeFromMaxTransaction(address(this), true);
839         excludeFromMaxTransaction(address(0xdead), true);
840 
841         /*
842             _mint is an internal function in ERC20.sol that is only called here,
843             and CANNOT be called ever again
844         */
845         _mint(msg.sender, totalSupply);
846     }
847 
848     receive() external payable {}
849 
850     // once enabled, can never be turned off
851     function enableTrading() external onlyOwner {
852         tradingActive = true;
853         swapEnabled = true;
854     }
855 
856     // remove limits after token is stable
857     function removeLimits() external onlyOwner returns (bool) {
858         limitsInEffect = false;
859         return true;
860     }
861 
862     // change the minimum amount of tokens to sell from fees
863     function updateSwapTokensAtAmount(uint256 newAmount)
864         external
865         onlyOwner
866         returns (bool)
867     {
868         require(
869             newAmount >= (totalSupply() * 1) / 100000,
870             "Swap amount cannot be lower than 0.001% total supply."
871         );
872         require(
873             newAmount <= (totalSupply() * 5) / 1000,
874             "Swap amount cannot be higher than 0.5% total supply."
875         );
876         swapTokensAtAmount = newAmount;
877         return true;
878     }
879 
880     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
881         require(
882             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
883             "Cannot set maxTransactionAmount lower than 0.1%"
884         );
885         maxTransactionAmount = newNum * (10**18);
886     }
887 
888     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
889         require(
890             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
891             "Cannot set maxWallet lower than 0.5%"
892         );
893         maxWallet = newNum * (10**18);
894     }
895 
896     function excludeFromMaxTransaction(address updAds, bool isEx)
897         public
898         onlyOwner
899     {
900         _isExcludedMaxTransactionAmount[updAds] = isEx;
901     }
902 
903     // only use to disable contract sales if absolutely necessary (emergency use only)
904     function updateSwapEnabled(bool enabled) external onlyOwner {
905         swapEnabled = enabled;
906     }
907 
908     function updateBuyFees(
909         uint256 _devFee,
910         uint256 _liquidityFee
911     ) external onlyOwner {
912         buyDevFee = _devFee;
913         buyLiquidityFee = _liquidityFee;
914         buyTotalFees = buyDevFee + buyLiquidityFee;
915         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
916     }
917 
918     function updateSellFees(
919         uint256 _devFee,
920         uint256 _liquidityFee
921     ) external onlyOwner {
922         sellDevFee = _devFee;
923         sellLiquidityFee = _liquidityFee;
924         sellTotalFees = sellDevFee + sellLiquidityFee;
925         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
926     }
927 
928     function excludeFromFees(address account, bool excluded) public onlyOwner {
929         _isExcludedFromFees[account] = excluded;
930         emit ExcludeFromFees(account, excluded);
931     }
932 
933     function updateDevWallet(address newDevWallet)
934         external
935         onlyOwner
936     {
937         emit devWalletUpdated(newDevWallet, devWallet);
938         devWallet = newDevWallet;
939     }
940 
941 
942     function isExcludedFromFees(address account) public view returns (bool) {
943         return _isExcludedFromFees[account];
944     }
945 
946     function _transfer(
947         address from,
948         address to,
949         uint256 amount
950     ) internal override {
951         require(from != address(0), "ERC20: transfer from the zero address");
952         require(to != address(0), "ERC20: transfer to the zero address");
953 
954         if (amount == 0) {
955             super._transfer(from, to, 0);
956             return;
957         }
958 
959         if (
960             buyDevFee != pumptoberBuyDevFee &&
961             sellDevFee != pumptoberSellDevFee &&
962             block.timestamp > PUMPTOBER_START
963         ) {
964             buyDevFee = pumptoberBuyDevFee;
965             buyLiquidityFee = pumptoberBuyLiquidityFee;
966             buyTotalFees = buyDevFee + buyLiquidityFee;
967 
968             sellDevFee = pumptoberSellDevFee;
969             sellLiquidityFee = pumptoberSellLiquidityFee;
970             sellTotalFees = sellDevFee + sellLiquidityFee;
971         }
972 
973         if (limitsInEffect) {
974             if (
975                 from != owner() &&
976                 to != owner() &&
977                 to != address(0) &&
978                 to != address(0xdead) &&
979                 !swapping
980             ) {
981                 if (!tradingActive) {
982                     require(
983                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
984                         "Trading is not active."
985                     );
986                 }
987 
988                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
989                 //when buy
990                 if (
991                     from == uniswapV2Pair &&
992                     !_isExcludedMaxTransactionAmount[to]
993                 ) {
994                     require(
995                         amount <= maxTransactionAmount,
996                         "Buy transfer amount exceeds the maxTransactionAmount."
997                     );
998                     require(
999                         amount + balanceOf(to) <= maxWallet,
1000                         "Max wallet exceeded"
1001                     );
1002                 }
1003                 else if (!_isExcludedMaxTransactionAmount[to]) {
1004                     require(
1005                         amount + balanceOf(to) <= maxWallet,
1006                         "Max wallet exceeded"
1007                     );
1008                 }
1009             }
1010         }
1011 
1012         uint256 contractTokenBalance = balanceOf(address(this));
1013 
1014         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1015 
1016         if (
1017             canSwap &&
1018             swapEnabled &&
1019             !swapping &&
1020             to == uniswapV2Pair &&
1021             !_isExcludedFromFees[from] &&
1022             !_isExcludedFromFees[to]
1023         ) {
1024             swapping = true;
1025 
1026             swapBack();
1027 
1028             swapping = false;
1029         }
1030 
1031         bool takeFee = !swapping;
1032 
1033         // if any account belongs to _isExcludedFromFee account then remove the fee
1034         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1035             takeFee = false;
1036         }
1037 
1038         uint256 fees = 0;
1039         uint256 tokensForLiquidity = 0;
1040         uint256 tokensForDev = 0;
1041         // only take fees on buys/sells, do not take on wallet transfers
1042         if (takeFee) {
1043             // on sell
1044             if (to == uniswapV2Pair && sellTotalFees > 0) {
1045                 fees = amount.mul(sellTotalFees).div(100);
1046                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1047                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1048             }
1049             // on buy
1050             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1051                 fees = amount.mul(buyTotalFees).div(100);
1052                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1053                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1054             }
1055 
1056             if (fees> 0) {
1057                 super._transfer(from, address(this), fees);
1058             }
1059             if (tokensForLiquidity > 0) {
1060                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1061             }
1062 
1063             amount -= fees;
1064         }
1065 
1066         super._transfer(from, to, amount);
1067     }
1068 
1069     function swapTokensForETH(uint256 tokenAmount) private {
1070         // generate the uniswap pair path of token -> weth
1071         address[] memory path = new address[](2);
1072         path[0] = address(this);
1073         path[1] = WETH;
1074 
1075         _approve(address(this), address(uniswapV2Router), tokenAmount);
1076 
1077         // make the swap
1078         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1079             tokenAmount,
1080             0, // accept any amount of ETH
1081             path,
1082             devWallet,
1083             block.timestamp
1084         );
1085     }
1086 
1087     function swapBack() private {
1088         uint256 contractBalance = balanceOf(address(this));
1089         if (contractBalance == 0) {
1090             return;
1091         }
1092 
1093         if (contractBalance > swapTokensAtAmount * 20) {
1094             contractBalance = swapTokensAtAmount * 20;
1095         }
1096 
1097         swapTokensForETH(contractBalance);
1098     }
1099 
1100     function airdropToWallets(
1101         address[] memory airdropWallets,
1102         uint256[] memory amount
1103     ) external onlyOwner {
1104         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1105         require(airdropWallets.length <= 100, "Wallets list length must be <= 100");
1106         for (uint256 i = 0; i < airdropWallets.length; i++) {
1107             address wallet = airdropWallets[i];
1108             uint256 airdropAmount = amount[i] * (10**decimals());
1109             super._transfer(msg.sender, wallet, airdropAmount);
1110         }
1111     }
1112 
1113 }