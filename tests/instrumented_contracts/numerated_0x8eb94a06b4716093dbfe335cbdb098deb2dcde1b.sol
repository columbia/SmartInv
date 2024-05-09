1 /****
2 
3 
4 Telegram: https://t.me/HalfShibaInz
5 
6 *****/
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Internal function without access restriction.
69      */
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
78 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
79 
80 /* pragma solidity ^0.8.0; */
81 
82 /**
83  * @dev Interface of the ERC20 standard as defined in the EIP.
84  */
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
161 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
162 
163 /* pragma solidity ^0.8.0; */
164 
165 /* import "../IERC20.sol"; */
166 
167 /**
168  * @dev Interface for the optional metadata functions from the ERC20 standard.
169  *
170  * _Available since v4.1._
171  */
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177 
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182 
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "./IERC20.sol"; */
195 /* import "./extensions/IERC20Metadata.sol"; */
196 /* import "../../utils/Context.sol"; */
197 
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20PresetMinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     mapping(address => uint256) private _balances;
225 
226     mapping(address => mapping(address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232 
233     /**
234      * @dev Sets the values for {name} and {symbol}.
235      *
236      * The default value of {decimals} is 18. To select a different value for
237      * {decimals} you should overload it.
238      *
239      * All two of these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor(string memory name_, string memory symbol_) {
243         _name = name_;
244         _symbol = symbol_;
245     }
246 
247     /**
248      * @dev Returns the name of the token.
249      */
250     function name() public view virtual override returns (string memory) {
251         return _name;
252     }
253 
254     /**
255      * @dev Returns the symbol of the token, usually a shorter version of the
256      * name.
257      */
258     function symbol() public view virtual override returns (string memory) {
259         return _symbol;
260     }
261 
262     /**
263      * @dev Returns the number of decimals used to get its user representation.
264      * For example, if `decimals` equals `2`, a balance of `505` tokens should
265      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
266      *
267      * Tokens usually opt for a value of 18, imitating the relationship between
268      * Ether and Wei. This is the value {ERC20} uses, unless this function is
269      * overridden;
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view virtual override returns (uint8) {
276         return 18;
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See {IERC20-transfer}.
295      *
296      * Requirements:
297      *
298      * - `recipient` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
302         _transfer(_msgSender(), recipient, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-allowance}.
308      */
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See {IERC20-approve}.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function approve(address spender, uint256 amount) public virtual override returns (bool) {
321         _approve(_msgSender(), spender, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-transferFrom}.
327      *
328      * Emits an {Approval} event indicating the updated allowance. This is not
329      * required by the EIP. See the note at the beginning of {ERC20}.
330      *
331      * Requirements:
332      *
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      * - the caller must have allowance for ``sender``'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) public virtual override returns (bool) {
343         _transfer(sender, recipient, amount);
344 
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
347         unchecked {
348             _approve(sender, _msgSender(), currentAllowance - amount);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Moves `amount` of tokens from `sender` to `recipient`.
356      *
357      * This internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         uint256 senderBalance = _balances[sender];
379         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
380         unchecked {
381             _balances[sender] = senderBalance - amount;
382         }
383         _balances[recipient] += amount;
384 
385         emit Transfer(sender, recipient, amount);
386 
387         _afterTokenTransfer(sender, recipient, amount);
388     }
389 
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401 
402         _beforeTokenTransfer(address(0), account, amount);
403 
404         _totalSupply += amount;
405         _balances[account] += amount;
406         emit Transfer(address(0), account, amount);
407 
408         _afterTokenTransfer(address(0), account, amount);
409     }
410 
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 
457     /**
458      * @dev Hook that is called after any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * has been transferred to `to`.
465      * - when `from` is zero, `amount` tokens have been minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _afterTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 }
477 
478 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
479 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
480 
481 /* pragma solidity ^0.8.0; */
482 
483 // CAUTION
484 // This version of SafeMath should only be used with Solidity 0.8 or later,
485 // because it relies on the compiler's built in overflow checks.
486 
487 /**
488  * @dev Wrappers over Solidity's arithmetic operations.
489  *
490  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
491  * now has built in overflow checking.
492  */
493 library SafeMath {
494     /**
495      * @dev Returns the addition of two unsigned integers, with an overflow flag.
496      *
497      * _Available since v3.4._
498      */
499     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
500         unchecked {
501             uint256 c = a + b;
502             if (c < a) return (false, 0);
503             return (true, c);
504         }
505     }
506 
507     /**
508      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
509      *
510      * _Available since v3.4._
511      */
512     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
513         unchecked {
514             if (b > a) return (false, 0);
515             return (true, a - b);
516         }
517     }
518 
519     /**
520      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
521      *
522      * _Available since v3.4._
523      */
524     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
525         unchecked {
526             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
527             // benefit is lost if 'b' is also tested.
528             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
529             if (a == 0) return (true, 0);
530             uint256 c = a * b;
531             if (c / a != b) return (false, 0);
532             return (true, c);
533         }
534     }
535 
536     /**
537      * @dev Returns the division of two unsigned integers, with a division by zero flag.
538      *
539      * _Available since v3.4._
540      */
541     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             if (b == 0) return (false, 0);
544             return (true, a / b);
545         }
546     }
547 
548     /**
549      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
550      *
551      * _Available since v3.4._
552      */
553     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
554         unchecked {
555             if (b == 0) return (false, 0);
556             return (true, a % b);
557         }
558     }
559 
560     /**
561      * @dev Returns the addition of two unsigned integers, reverting on
562      * overflow.
563      *
564      * Counterpart to Solidity's `+` operator.
565      *
566      * Requirements:
567      *
568      * - Addition cannot overflow.
569      */
570     function add(uint256 a, uint256 b) internal pure returns (uint256) {
571         return a + b;
572     }
573 
574     /**
575      * @dev Returns the subtraction of two unsigned integers, reverting on
576      * overflow (when the result is negative).
577      *
578      * Counterpart to Solidity's `-` operator.
579      *
580      * Requirements:
581      *
582      * - Subtraction cannot overflow.
583      */
584     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
585         return a - b;
586     }
587 
588     /**
589      * @dev Returns the multiplication of two unsigned integers, reverting on
590      * overflow.
591      *
592      * Counterpart to Solidity's `*` operator.
593      *
594      * Requirements:
595      *
596      * - Multiplication cannot overflow.
597      */
598     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
599         return a * b;
600     }
601 
602     /**
603      * @dev Returns the integer division of two unsigned integers, reverting on
604      * division by zero. The result is rounded towards zero.
605      *
606      * Counterpart to Solidity's `/` operator.
607      *
608      * Requirements:
609      *
610      * - The divisor cannot be zero.
611      */
612     function div(uint256 a, uint256 b) internal pure returns (uint256) {
613         return a / b;
614     }
615 
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
618      * reverting when dividing by zero.
619      *
620      * Counterpart to Solidity's `%` operator. This function uses a `revert`
621      * opcode (which leaves remaining gas untouched) while Solidity uses an
622      * invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      *
626      * - The divisor cannot be zero.
627      */
628     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a % b;
630     }
631 
632     /**
633      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
634      * overflow (when the result is negative).
635      *
636      * CAUTION: This function is deprecated because it requires allocating memory for the error
637      * message unnecessarily. For custom revert reasons use {trySub}.
638      *
639      * Counterpart to Solidity's `-` operator.
640      *
641      * Requirements:
642      *
643      * - Subtraction cannot overflow.
644      */
645     function sub(
646         uint256 a,
647         uint256 b,
648         string memory errorMessage
649     ) internal pure returns (uint256) {
650         unchecked {
651             require(b <= a, errorMessage);
652             return a - b;
653         }
654     }
655 
656     /**
657      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
658      * division by zero. The result is rounded towards zero.
659      *
660      * Counterpart to Solidity's `/` operator. Note: this function uses a
661      * `revert` opcode (which leaves remaining gas untouched) while Solidity
662      * uses an invalid opcode to revert (consuming all remaining gas).
663      *
664      * Requirements:
665      *
666      * - The divisor cannot be zero.
667      */
668     function div(
669         uint256 a,
670         uint256 b,
671         string memory errorMessage
672     ) internal pure returns (uint256) {
673         unchecked {
674             require(b > 0, errorMessage);
675             return a / b;
676         }
677     }
678 
679     /**
680      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
681      * reverting with custom message when dividing by zero.
682      *
683      * CAUTION: This function is deprecated because it requires allocating memory for the error
684      * message unnecessarily. For custom revert reasons use {tryMod}.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(
695         uint256 a,
696         uint256 b,
697         string memory errorMessage
698     ) internal pure returns (uint256) {
699         unchecked {
700             require(b > 0, errorMessage);
701             return a % b;
702         }
703     }
704 }
705 
706 interface IUniswapV2Factory {
707     event PairCreated(
708         address indexed token0,
709         address indexed token1,
710         address pair,
711         uint256
712     );
713 
714     function createPair(address tokenA, address tokenB)
715         external
716         returns (address pair);
717 }
718 
719 interface IUniswapV2Router02 {
720     function factory() external pure returns (address);
721 
722     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
723         uint256 amountIn,
724         uint256 amountOutMin,
725         address[] calldata path,
726         address to,
727         uint256 deadline
728     ) external;
729 }
730 
731 contract HalfShibaInu is ERC20, Ownable {
732     using SafeMath for uint256;
733 
734     IUniswapV2Router02 public immutable uniswapV2Router;
735     address public immutable uniswapV2Pair;
736     address public constant deadAddress = address(0xdead);
737     address public SHIB = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
738 
739     bool private swapping;
740 
741     address public devWallet;
742 
743     uint256 public maxTransactionAmount;
744     uint256 public swapTokensAtAmount;
745     uint256 public maxWallet;
746 
747     bool public limitsInEffect = true;
748     bool public tradingActive = false;
749     bool public swapEnabled = true;
750 
751     uint256 public buyTotalFees;
752     uint256 public buyDevFee;
753     uint256 public buyLiquidityFee;
754 
755     uint256 public sellTotalFees;
756     uint256 public sellDevFee;
757     uint256 public sellLiquidityFee;
758 
759     /******************/
760 
761     // exlcude from fees and max transaction amount
762     mapping(address => bool) private _isExcludedFromFees;
763     mapping(address => bool) public _isExcludedMaxTransactionAmount;
764 
765 
766     event ExcludeFromFees(address indexed account, bool isExcluded);
767 
768     event devWalletUpdated(
769         address indexed newWallet,
770         address indexed oldWallet
771     );
772 
773     constructor() ERC20("Half Shiba Inu", "SHIB0.5") {
774         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
775 
776         excludeFromMaxTransaction(address(_uniswapV2Router), true);
777         uniswapV2Router = _uniswapV2Router;
778 
779         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
780             .createPair(address(this), SHIB);
781         excludeFromMaxTransaction(address(uniswapV2Pair), true);
782 
783 
784         uint256 _buyDevFee = 20;
785         uint256 _buyLiquidityFee = 0;
786 
787         uint256 _sellDevFee = 20;
788         uint256 _sellLiquidityFee = 0;
789 
790         uint256 totalSupply = 1_000_000 * 1e18;
791 
792         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
793         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
794         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
795 
796         buyDevFee = _buyDevFee;
797         buyLiquidityFee = _buyLiquidityFee;
798         buyTotalFees = buyDevFee + buyLiquidityFee;
799 
800         sellDevFee = _sellDevFee;
801         sellLiquidityFee = _sellLiquidityFee;
802         sellTotalFees = sellDevFee + sellLiquidityFee;
803 
804         devWallet = address(0xA1aFE06cE0232AD266228309A91cA31CDA1dd9F7); 
805 
806         // exclude from paying fees or having max transaction amount
807         excludeFromFees(owner(), true);
808         excludeFromFees(address(this), true);
809         excludeFromFees(address(0xdead), true);
810 
811         excludeFromMaxTransaction(owner(), true);
812         excludeFromMaxTransaction(address(this), true);
813         excludeFromMaxTransaction(address(0xdead), true);
814 
815         /*
816             _mint is an internal function in ERC20.sol that is only called here,
817             and CANNOT be called ever again
818         */
819         _mint(msg.sender, totalSupply);
820     }
821 
822     receive() external payable {}
823 
824     // once enabled, can never be turned off
825     function enableTrading() external onlyOwner {
826         tradingActive = true;
827         swapEnabled = true;
828     }
829 
830     // remove limits after token is stable
831     function removeLimits() external onlyOwner returns (bool) {
832         limitsInEffect = false;
833         return true;
834     }
835 
836     // change the minimum amount of tokens to sell from fees
837     function updateSwapTokensAtAmount(uint256 newAmount)
838         external
839         onlyOwner
840         returns (bool)
841     {
842         require(
843             newAmount >= (totalSupply() * 1) / 100000,
844             "Swap amount cannot be lower than 0.001% total supply."
845         );
846         require(
847             newAmount <= (totalSupply() * 5) / 1000,
848             "Swap amount cannot be higher than 0.5% total supply."
849         );
850         swapTokensAtAmount = newAmount;
851         return true;
852     }
853 
854     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
855         require(
856             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
857             "Cannot set maxTransactionAmount lower than 0.1%"
858         );
859         maxTransactionAmount = newNum * (10**18);
860     }
861 
862     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
863         require(
864             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
865             "Cannot set maxWallet lower than 0.5%"
866         );
867         maxWallet = newNum * (10**18);
868     }
869 
870     function excludeFromMaxTransaction(address updAds, bool isEx)
871         public
872         onlyOwner
873     {
874         _isExcludedMaxTransactionAmount[updAds] = isEx;
875     }
876 
877     // only use to disable contract sales if absolutely necessary (emergency use only)
878     function updateSwapEnabled(bool enabled) external onlyOwner {
879         swapEnabled = enabled;
880     }
881 
882     function updateBuyFees(
883         uint256 _devFee,
884         uint256 _liquidityFee
885     ) external onlyOwner {
886         buyDevFee = _devFee;
887         buyLiquidityFee = _liquidityFee;
888         buyTotalFees = buyDevFee + buyLiquidityFee;
889         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
890     }
891 
892     function updateSellFees(
893         uint256 _devFee,
894         uint256 _liquidityFee
895     ) external onlyOwner {
896         sellDevFee = _devFee;
897         sellLiquidityFee = _liquidityFee;
898         sellTotalFees = sellDevFee + sellLiquidityFee;
899         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
900     }
901 
902     function excludeFromFees(address account, bool excluded) public onlyOwner {
903         _isExcludedFromFees[account] = excluded;
904         emit ExcludeFromFees(account, excluded);
905     }
906 
907     function updateDevWallet(address newDevWallet)
908         external
909         onlyOwner
910     {
911         emit devWalletUpdated(newDevWallet, devWallet);
912         devWallet = newDevWallet;
913     }
914 
915 
916     function isExcludedFromFees(address account) public view returns (bool) {
917         return _isExcludedFromFees[account];
918     }
919 
920     function _transfer(
921         address from,
922         address to,
923         uint256 amount
924     ) internal override {
925         require(from != address(0), "ERC20: transfer from the zero address");
926         require(to != address(0), "ERC20: transfer to the zero address");
927 
928         if (amount == 0) {
929             super._transfer(from, to, 0);
930             return;
931         }
932 
933         if (limitsInEffect) {
934             if (
935                 from != owner() &&
936                 to != owner() &&
937                 to != address(0) &&
938                 to != address(0xdead) &&
939                 !swapping
940             ) {
941                 if (!tradingActive) {
942                     require(
943                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
944                         "Trading is not active."
945                     );
946                 }
947 
948                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
949                 //when buy
950                 if (
951                     from == uniswapV2Pair &&
952                     !_isExcludedMaxTransactionAmount[to]
953                 ) {
954                     require(
955                         amount <= maxTransactionAmount,
956                         "Buy transfer amount exceeds the maxTransactionAmount."
957                     );
958                     require(
959                         amount + balanceOf(to) <= maxWallet,
960                         "Max wallet exceeded"
961                     );
962                 }
963                 else if (!_isExcludedMaxTransactionAmount[to]) {
964                     require(
965                         amount + balanceOf(to) <= maxWallet,
966                         "Max wallet exceeded"
967                     );
968                 }
969             }
970         }
971 
972         uint256 contractTokenBalance = balanceOf(address(this));
973 
974         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
975 
976         if (
977             canSwap &&
978             swapEnabled &&
979             !swapping &&
980             to == uniswapV2Pair &&
981             !_isExcludedFromFees[from] &&
982             !_isExcludedFromFees[to]
983         ) {
984             swapping = true;
985 
986             swapBack();
987 
988             swapping = false;
989         }
990 
991         bool takeFee = !swapping;
992 
993         // if any account belongs to _isExcludedFromFee account then remove the fee
994         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
995             takeFee = false;
996         }
997 
998         uint256 fees = 0;
999         uint256 tokensForLiquidity = 0;
1000         uint256 tokensForDev = 0;
1001         // only take fees on buys/sells, do not take on wallet transfers
1002         if (takeFee) {
1003             // on sell
1004             if (to == uniswapV2Pair && sellTotalFees > 0) {
1005                 fees = amount.mul(sellTotalFees).div(100);
1006                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1007                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1008             }
1009             // on buy
1010             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1011                 fees = amount.mul(buyTotalFees).div(100);
1012                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1013                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1014             }
1015 
1016             if (fees> 0) {
1017                 super._transfer(from, address(this), fees);
1018             }
1019             if (tokensForLiquidity > 0) {
1020                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1021             }
1022 
1023             amount -= fees;
1024         }
1025 
1026         super._transfer(from, to, amount);
1027     }
1028 
1029     function swapTokensForSHIB(uint256 tokenAmount) private {
1030         // generate the uniswap pair path of token -> weth
1031         address[] memory path = new address[](2);
1032         path[0] = address(this);
1033         path[1] = SHIB;
1034 
1035         _approve(address(this), address(uniswapV2Router), tokenAmount);
1036 
1037         // make the swap
1038         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1039             tokenAmount,
1040             0, // accept any amount of SHIB
1041             path,
1042             devWallet,
1043             block.timestamp
1044         );
1045     }
1046 
1047     function swapBack() private {
1048         uint256 contractBalance = balanceOf(address(this));
1049         if (contractBalance == 0) {
1050             return;
1051         }
1052 
1053         if (contractBalance > swapTokensAtAmount * 20) {
1054             contractBalance = swapTokensAtAmount * 20;
1055         }
1056 
1057         swapTokensForSHIB(contractBalance);
1058     }
1059 
1060 }