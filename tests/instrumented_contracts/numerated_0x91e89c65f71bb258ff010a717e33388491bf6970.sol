1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-15
3 */
4 
5 
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Internal function without access restriction.
68      */
69     function _transferOwnership(address newOwner) internal virtual {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
77 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
78 
79 /* pragma solidity ^0.8.0; */
80 
81 /**
82  * @dev Interface of the ERC20 standard as defined in the EIP.
83  */
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Returns the remaining number of tokens that `spender` will be
106      * allowed to spend on behalf of `owner` through {transferFrom}. This is
107      * zero by default.
108      *
109      * This value changes when {approve} or {transferFrom} are called.
110      */
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     /**
114      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * IMPORTANT: Beware that changing an allowance with this method brings the risk
119      * that someone may use both the old and the new allowance by unfortunate
120      * transaction ordering. One possible solution to mitigate this race
121      * condition is to first reduce the spender's allowance to 0 and set the
122      * desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address spender, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Moves `amount` tokens from `sender` to `recipient` using the
131      * allowance mechanism. `amount` is then deducted from the caller's
132      * allowance.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address sender,
140         address recipient,
141         uint256 amount
142     ) external returns (bool);
143 
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
160 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
161 
162 /* pragma solidity ^0.8.0; */
163 
164 /* import "../IERC20.sol"; */
165 
166 /**
167  * @dev Interface for the optional metadata functions from the ERC20 standard.
168  *
169  * _Available since v4.1._
170  */
171 interface IERC20Metadata is IERC20 {
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() external view returns (string memory);
176 
177     /**
178      * @dev Returns the symbol of the token.
179      */
180     function symbol() external view returns (string memory);
181 
182     /**
183      * @dev Returns the decimals places of the token.
184      */
185     function decimals() external view returns (uint8);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
189 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "./IERC20.sol"; */
194 /* import "./extensions/IERC20Metadata.sol"; */
195 /* import "../../utils/Context.sol"; */
196 
197 /**
198  * @dev Implementation of the {IERC20} interface.
199  *
200  * This implementation is agnostic to the way tokens are created. This means
201  * that a supply mechanism has to be added in a derived contract using {_mint}.
202  * For a generic mechanism see {ERC20PresetMinterPauser}.
203  *
204  * TIP: For a detailed writeup see our guide
205  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
206  * to implement supply mechanisms].
207  *
208  * We have followed general OpenZeppelin Contracts guidelines: functions revert
209  * instead returning `false` on failure. This behavior is nonetheless
210  * conventional and does not conflict with the expectations of ERC20
211  * applications.
212  *
213  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
214  * This allows applications to reconstruct the allowance for all accounts just
215  * by listening to said events. Other implementations of the EIP may not emit
216  * these events, as it isn't required by the specification.
217  *
218  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See {IERC20-approve}.
221  */
222 contract ERC20 is Context, IERC20, IERC20Metadata {
223     mapping(address => uint256) private _balances;
224 
225     mapping(address => mapping(address => uint256)) private _allowances;
226 
227     uint256 private _totalSupply;
228 
229     string private _name;
230     string private _symbol;
231 
232     /**
233      * @dev Sets the values for {name} and {symbol}.
234      *
235      * The default value of {decimals} is 18. To select a different value for
236      * {decimals} you should overload it.
237      *
238      * All two of these values are immutable: they can only be set once during
239      * construction.
240      */
241     constructor(string memory name_, string memory symbol_) {
242         _name = name_;
243         _symbol = symbol_;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view virtual override returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view virtual override returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei. This is the value {ERC20} uses, unless this function is
268      * overridden;
269      *
270      * NOTE: This information is only used for _display_ purposes: it in
271      * no way affects any of the arithmetic of the contract, including
272      * {IERC20-balanceOf} and {IERC20-transfer}.
273      */
274     function decimals() public view virtual override returns (uint8) {
275         return 18;
276     }
277 
278     /**
279      * @dev See {IERC20-totalSupply}.
280      */
281     function totalSupply() public view virtual override returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286      * @dev See {IERC20-balanceOf}.
287      */
288     function balanceOf(address account) public view virtual override returns (uint256) {
289         return _balances[account];
290     }
291 
292     /**
293      * @dev See {IERC20-transfer}.
294      *
295      * Requirements:
296      *
297      * - `recipient` cannot be the zero address.
298      * - the caller must have a balance of at least `amount`.
299      */
300     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
301         _transfer(_msgSender(), recipient, amount);
302         return true;
303     }
304 
305     /**
306      * @dev See {IERC20-allowance}.
307      */
308     function allowance(address owner, address spender) public view virtual override returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     /**
313      * @dev See {IERC20-approve}.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function approve(address spender, uint256 amount) public virtual override returns (bool) {
320         _approve(_msgSender(), spender, amount);
321         return true;
322     }
323 
324     /**
325      * @dev See {IERC20-transferFrom}.
326      *
327      * Emits an {Approval} event indicating the updated allowance. This is not
328      * required by the EIP. See the note at the beginning of {ERC20}.
329      *
330      * Requirements:
331      *
332      * - `sender` and `recipient` cannot be the zero address.
333      * - `sender` must have a balance of at least `amount`.
334      * - the caller must have allowance for ``sender``'s tokens of at least
335      * `amount`.
336      */
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) public virtual override returns (bool) {
342         _transfer(sender, recipient, amount);
343 
344         uint256 currentAllowance = _allowances[sender][_msgSender()];
345         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
346         unchecked {
347             _approve(sender, _msgSender(), currentAllowance - amount);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `sender` to `recipient`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(sender, recipient, amount);
376 
377         uint256 senderBalance = _balances[sender];
378         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[sender] = senderBalance - amount;
381         }
382         _balances[recipient] += amount;
383 
384         emit Transfer(sender, recipient, amount);
385 
386         _afterTokenTransfer(sender, recipient, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
413      *
414      * This internal function is equivalent to `approve`, and can be used to
415      * e.g. set automatic allowances for certain subsystems, etc.
416      *
417      * Emits an {Approval} event.
418      *
419      * Requirements:
420      *
421      * - `owner` cannot be the zero address.
422      * - `spender` cannot be the zero address.
423      */
424     function _approve(
425         address owner,
426         address spender,
427         uint256 amount
428     ) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
443      * will be transferred to `to`.
444      * - when `from` is zero, `amount` tokens will be minted for `to`.
445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
446      * - `from` and `to` are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(
451         address from,
452         address to,
453         uint256 amount
454     ) internal virtual {}
455 
456     /**
457      * @dev Hook that is called after any transfer of tokens. This includes
458      * minting and burning.
459      *
460      * Calling conditions:
461      *
462      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
463      * has been transferred to `to`.
464      * - when `from` is zero, `amount` tokens have been minted for `to`.
465      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
466      * - `from` and `to` are never both zero.
467      *
468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
469      */
470     function _afterTokenTransfer(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {}
475 }
476 
477 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
478 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
479 
480 /* pragma solidity ^0.8.0; */
481 
482 // CAUTION
483 // This version of SafeMath should only be used with Solidity 0.8 or later,
484 // because it relies on the compiler's built in overflow checks.
485 
486 /**
487  * @dev Wrappers over Solidity's arithmetic operations.
488  *
489  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
490  * now has built in overflow checking.
491  */
492 library SafeMath {
493     /**
494      * @dev Returns the addition of two unsigned integers, with an overflow flag.
495      *
496      * _Available since v3.4._
497      */
498     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
499         unchecked {
500             uint256 c = a + b;
501             if (c < a) return (false, 0);
502             return (true, c);
503         }
504     }
505 
506     /**
507      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
508      *
509      * _Available since v3.4._
510      */
511     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
512         unchecked {
513             if (b > a) return (false, 0);
514             return (true, a - b);
515         }
516     }
517 
518     /**
519      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
520      *
521      * _Available since v3.4._
522      */
523     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
524         unchecked {
525             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526             // benefit is lost if 'b' is also tested.
527             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
528             if (a == 0) return (true, 0);
529             uint256 c = a * b;
530             if (c / a != b) return (false, 0);
531             return (true, c);
532         }
533     }
534 
535     /**
536      * @dev Returns the division of two unsigned integers, with a division by zero flag.
537      *
538      * _Available since v3.4._
539      */
540     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
541         unchecked {
542             if (b == 0) return (false, 0);
543             return (true, a / b);
544         }
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
549      *
550      * _Available since v3.4._
551      */
552     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
553         unchecked {
554             if (b == 0) return (false, 0);
555             return (true, a % b);
556         }
557     }
558 
559     /**
560      * @dev Returns the addition of two unsigned integers, reverting on
561      * overflow.
562      *
563      * Counterpart to Solidity's `+` operator.
564      *
565      * Requirements:
566      *
567      * - Addition cannot overflow.
568      */
569     function add(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a + b;
571     }
572 
573     /**
574      * @dev Returns the subtraction of two unsigned integers, reverting on
575      * overflow (when the result is negative).
576      *
577      * Counterpart to Solidity's `-` operator.
578      *
579      * Requirements:
580      *
581      * - Subtraction cannot overflow.
582      */
583     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
584         return a - b;
585     }
586 
587     /**
588      * @dev Returns the multiplication of two unsigned integers, reverting on
589      * overflow.
590      *
591      * Counterpart to Solidity's `*` operator.
592      *
593      * Requirements:
594      *
595      * - Multiplication cannot overflow.
596      */
597     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a * b;
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers, reverting on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator.
606      *
607      * Requirements:
608      *
609      * - The divisor cannot be zero.
610      */
611     function div(uint256 a, uint256 b) internal pure returns (uint256) {
612         return a / b;
613     }
614 
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
617      * reverting when dividing by zero.
618      *
619      * Counterpart to Solidity's `%` operator. This function uses a `revert`
620      * opcode (which leaves remaining gas untouched) while Solidity uses an
621      * invalid opcode to revert (consuming all remaining gas).
622      *
623      * Requirements:
624      *
625      * - The divisor cannot be zero.
626      */
627     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a % b;
629     }
630 
631     /**
632      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
633      * overflow (when the result is negative).
634      *
635      * CAUTION: This function is deprecated because it requires allocating memory for the error
636      * message unnecessarily. For custom revert reasons use {trySub}.
637      *
638      * Counterpart to Solidity's `-` operator.
639      *
640      * Requirements:
641      *
642      * - Subtraction cannot overflow.
643      */
644     function sub(
645         uint256 a,
646         uint256 b,
647         string memory errorMessage
648     ) internal pure returns (uint256) {
649         unchecked {
650             require(b <= a, errorMessage);
651             return a - b;
652         }
653     }
654 
655     /**
656      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
657      * division by zero. The result is rounded towards zero.
658      *
659      * Counterpart to Solidity's `/` operator. Note: this function uses a
660      * `revert` opcode (which leaves remaining gas untouched) while Solidity
661      * uses an invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function div(
668         uint256 a,
669         uint256 b,
670         string memory errorMessage
671     ) internal pure returns (uint256) {
672         unchecked {
673             require(b > 0, errorMessage);
674             return a / b;
675         }
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
680      * reverting with custom message when dividing by zero.
681      *
682      * CAUTION: This function is deprecated because it requires allocating memory for the error
683      * message unnecessarily. For custom revert reasons use {tryMod}.
684      *
685      * Counterpart to Solidity's `%` operator. This function uses a `revert`
686      * opcode (which leaves remaining gas untouched) while Solidity uses an
687      * invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function mod(
694         uint256 a,
695         uint256 b,
696         string memory errorMessage
697     ) internal pure returns (uint256) {
698         unchecked {
699             require(b > 0, errorMessage);
700             return a % b;
701         }
702     }
703 }
704 
705 interface IUniswapV2Factory {
706     event PairCreated(
707         address indexed token0,
708         address indexed token1,
709         address pair,
710         uint256
711     );
712 
713     function createPair(address tokenA, address tokenB)
714         external
715         returns (address pair);
716 }
717 
718 interface IUniswapV2Router02 {
719     function factory() external pure returns (address);
720 
721     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
722         uint256 amountIn,
723         uint256 amountOutMin,
724         address[] calldata path,
725         address to,
726         uint256 deadline
727     ) external;
728 }
729 
730 contract HalfTsuka is ERC20, Ownable {
731     using SafeMath for uint256;
732 
733     IUniswapV2Router02 public immutable uniswapV2Router;
734     address public immutable uniswapV2Pair;
735     address public constant deadAddress = address(0xdead);
736     address public TSUKA = 0xc5fB36dd2fb59d3B98dEfF88425a3F425Ee469eD;
737 
738     bool private swapping;
739 
740     address public devWallet;
741 
742     uint256 public maxTransactionAmount;
743     uint256 public swapTokensAtAmount;
744     uint256 public maxWallet;
745 
746     bool public limitsInEffect = true;
747     bool public tradingActive = false;
748     bool public swapEnabled = true;
749 
750     uint256 public buyTotalFees;
751     uint256 public buyDevFee;
752     uint256 public buyLiquidityFee;
753 
754     uint256 public sellTotalFees;
755     uint256 public sellDevFee;
756     uint256 public sellLiquidityFee;
757 
758     /******************/
759 
760     // exlcude from fees and max transaction amount
761     mapping(address => bool) private _isExcludedFromFees;
762     mapping(address => bool) public _isExcludedMaxTransactionAmount;
763 
764 
765     event ExcludeFromFees(address indexed account, bool isExcluded);
766 
767     event devWalletUpdated(
768         address indexed newWallet,
769         address indexed oldWallet
770     );
771 
772     constructor() ERC20("half Tsuka", "TSUKA0.5") {
773         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
774 
775         excludeFromMaxTransaction(address(_uniswapV2Router), true);
776         uniswapV2Router = _uniswapV2Router;
777 
778         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
779             .createPair(address(this), TSUKA);
780         excludeFromMaxTransaction(address(uniswapV2Pair), true);
781 
782 
783         uint256 _buyDevFee = 20;
784         uint256 _buyLiquidityFee = 0;
785 
786         uint256 _sellDevFee = 20;
787         uint256 _sellLiquidityFee = 0;
788 
789         uint256 totalSupply = 1_000_000 * 1e18;
790 
791         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
792         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
793         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
794 
795         buyDevFee = _buyDevFee;
796         buyLiquidityFee = _buyLiquidityFee;
797         buyTotalFees = buyDevFee + buyLiquidityFee;
798 
799         sellDevFee = _sellDevFee;
800         sellLiquidityFee = _sellLiquidityFee;
801         sellTotalFees = sellDevFee + sellLiquidityFee;
802 
803         devWallet = address(0x740c3F3D05E39d2f16455DAb9CABf33942c185d1); 
804 
805         // exclude from paying fees or having max transaction amount
806         excludeFromFees(owner(), true);
807         excludeFromFees(address(this), true);
808         excludeFromFees(address(0xdead), true);
809 
810         excludeFromMaxTransaction(owner(), true);
811         excludeFromMaxTransaction(address(this), true);
812         excludeFromMaxTransaction(address(0xdead), true);
813 
814         /*
815             _mint is an internal function in ERC20.sol that is only called here,
816             and CANNOT be called ever again
817         */
818         _mint(msg.sender, totalSupply);
819     }
820 
821     receive() external payable {}
822 
823     // once enabled, can never be turned off
824     function enableTrading() external onlyOwner {
825         tradingActive = true;
826         swapEnabled = true;
827     }
828 
829     // remove limits after token is stable
830     function removeLimits() external onlyOwner returns (bool) {
831         limitsInEffect = false;
832         return true;
833     }
834 
835     // change the minimum amount of tokens to sell from fees
836     function updateSwapTokensAtAmount(uint256 newAmount)
837         external
838         onlyOwner
839         returns (bool)
840     {
841         require(
842             newAmount >= (totalSupply() * 1) / 100000,
843             "Swap amount cannot be lower than 0.001% total supply."
844         );
845         require(
846             newAmount <= (totalSupply() * 5) / 1000,
847             "Swap amount cannot be higher than 0.5% total supply."
848         );
849         swapTokensAtAmount = newAmount;
850         return true;
851     }
852 
853     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
854         require(
855             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
856             "Cannot set maxTransactionAmount lower than 0.1%"
857         );
858         maxTransactionAmount = newNum * (10**18);
859     }
860 
861     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
862         require(
863             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
864             "Cannot set maxWallet lower than 0.5%"
865         );
866         maxWallet = newNum * (10**18);
867     }
868 
869     function excludeFromMaxTransaction(address updAds, bool isEx)
870         public
871         onlyOwner
872     {
873         _isExcludedMaxTransactionAmount[updAds] = isEx;
874     }
875 
876     // only use to disable contract sales if absolutely necessary (emergency use only)
877     function updateSwapEnabled(bool enabled) external onlyOwner {
878         swapEnabled = enabled;
879     }
880 
881     function updateBuyFees(
882         uint256 _devFee,
883         uint256 _liquidityFee
884     ) external onlyOwner {
885         buyDevFee = _devFee;
886         buyLiquidityFee = _liquidityFee;
887         buyTotalFees = buyDevFee + buyLiquidityFee;
888         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
889     }
890 
891     function updateSellFees(
892         uint256 _devFee,
893         uint256 _liquidityFee
894     ) external onlyOwner {
895         sellDevFee = _devFee;
896         sellLiquidityFee = _liquidityFee;
897         sellTotalFees = sellDevFee + sellLiquidityFee;
898         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
899     }
900 
901     function excludeFromFees(address account, bool excluded) public onlyOwner {
902         _isExcludedFromFees[account] = excluded;
903         emit ExcludeFromFees(account, excluded);
904     }
905 
906     function updateDevWallet(address newDevWallet)
907         external
908         onlyOwner
909     {
910         emit devWalletUpdated(newDevWallet, devWallet);
911         devWallet = newDevWallet;
912     }
913 
914 
915     function isExcludedFromFees(address account) public view returns (bool) {
916         return _isExcludedFromFees[account];
917     }
918 
919     function _transfer(
920         address from,
921         address to,
922         uint256 amount
923     ) internal override {
924         require(from != address(0), "ERC20: transfer from the zero address");
925         require(to != address(0), "ERC20: transfer to the zero address");
926 
927         if (amount == 0) {
928             super._transfer(from, to, 0);
929             return;
930         }
931 
932         if (limitsInEffect) {
933             if (
934                 from != owner() &&
935                 to != owner() &&
936                 to != address(0) &&
937                 to != address(0xdead) &&
938                 !swapping
939             ) {
940                 if (!tradingActive) {
941                     require(
942                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
943                         "Trading is not active."
944                     );
945                 }
946 
947                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
948                 //when buy
949                 if (
950                     from == uniswapV2Pair &&
951                     !_isExcludedMaxTransactionAmount[to]
952                 ) {
953                     require(
954                         amount <= maxTransactionAmount,
955                         "Buy transfer amount exceeds the maxTransactionAmount."
956                     );
957                     require(
958                         amount + balanceOf(to) <= maxWallet,
959                         "Max wallet exceeded"
960                     );
961                 }
962                 else if (!_isExcludedMaxTransactionAmount[to]) {
963                     require(
964                         amount + balanceOf(to) <= maxWallet,
965                         "Max wallet exceeded"
966                     );
967                 }
968             }
969         }
970 
971         uint256 contractTokenBalance = balanceOf(address(this));
972 
973         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
974 
975         if (
976             canSwap &&
977             swapEnabled &&
978             !swapping &&
979             to == uniswapV2Pair &&
980             !_isExcludedFromFees[from] &&
981             !_isExcludedFromFees[to]
982         ) {
983             swapping = true;
984 
985             swapBack();
986 
987             swapping = false;
988         }
989 
990         bool takeFee = !swapping;
991 
992         // if any account belongs to _isExcludedFromFee account then remove the fee
993         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
994             takeFee = false;
995         }
996 
997         uint256 fees = 0;
998         uint256 tokensForLiquidity = 0;
999         uint256 tokensForDev = 0;
1000         // only take fees on buys/sells, do not take on wallet transfers
1001         if (takeFee) {
1002             // on sell
1003             if (to == uniswapV2Pair && sellTotalFees > 0) {
1004                 fees = amount.mul(sellTotalFees).div(100);
1005                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1006                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1007             }
1008             // on buy
1009             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1010                 fees = amount.mul(buyTotalFees).div(100);
1011                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1012                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1013             }
1014 
1015             if (fees> 0) {
1016                 super._transfer(from, address(this), fees);
1017             }
1018             if (tokensForLiquidity > 0) {
1019                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1020             }
1021 
1022             amount -= fees;
1023         }
1024 
1025         super._transfer(from, to, amount);
1026     }
1027 
1028     function swapTokensForTSUKA(uint256 tokenAmount) private {
1029         // generate the uniswap pair path of token -> weth
1030         address[] memory path = new address[](2);
1031         path[0] = address(this);
1032         path[1] = TSUKA;
1033 
1034         _approve(address(this), address(uniswapV2Router), tokenAmount);
1035 
1036         // make the swap
1037         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1038             tokenAmount,
1039             0, // accept any amount of TSUKA
1040             path,
1041             devWallet,
1042             block.timestamp
1043         );
1044     }
1045 
1046     function swapBack() private {
1047         uint256 contractBalance = balanceOf(address(this));
1048         if (contractBalance == 0) {
1049             return;
1050         }
1051 
1052         if (contractBalance > swapTokensAtAmount * 20) {
1053             contractBalance = swapTokensAtAmount * 20;
1054         }
1055 
1056         swapTokensForTSUKA(contractBalance);
1057     }
1058 
1059 }