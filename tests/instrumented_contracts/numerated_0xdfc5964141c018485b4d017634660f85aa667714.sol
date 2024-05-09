1 // SPDX-License-Identifier: Unlicensed
2 // https://t.me/DejitaruOdin
3 // https://twitter.com/DejitaruOdin
4 // https://www.dejitaruodin.com
5 // https://medium.com/@thorsonofodin_76457/dejitaru-odin-c48e8b0463fc
6 // https://www.dejitaruodin.com/OdinWhitepaper.html
7 pragma solidity 0.8.12;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     /**
33      * @dev Returns the address of the current owner.
34      */
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(owner() == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * NOTE: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public virtual onlyOwner {
55         _transferOwnership(address(0));
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Internal function without access restriction.
70      */
71     function _transferOwnership(address newOwner) internal virtual {
72         address oldOwner = _owner;
73         _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75     }
76 }
77 
78 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
79 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
80 
81 /* pragma solidity ^0.8.0; */
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP.
85  */
86 interface IERC20 {
87     /**
88      * @dev Returns the amount of tokens in existence.
89      */
90     function totalSupply() external view returns (uint256);
91 
92     /**
93      * @dev Returns the amount of tokens owned by `account`.
94      */
95     function balanceOf(address account) external view returns (uint256);
96 
97     /**
98      * @dev Moves `amount` tokens from the caller's account to `recipient`.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transfer(address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through {transferFrom}. This is
109      * zero by default.
110      *
111      * This value changes when {approve} or {transferFrom} are called.
112      */
113     function allowance(address owner, address spender) external view returns (uint256);
114 
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * IMPORTANT: Beware that changing an allowance with this method brings the risk
121      * that someone may use both the old and the new allowance by unfortunate
122      * transaction ordering. One possible solution to mitigate this race
123      * condition is to first reduce the spender's allowance to 0 and set the
124      * desired value afterwards:
125      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Moves `amount` tokens from `sender` to `recipient` using the
133      * allowance mechanism. `amount` is then deducted from the caller's
134      * allowance.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) external returns (bool);
145 
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
162 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
163 
164 /* pragma solidity ^0.8.0; */
165 
166 /* import "../IERC20.sol"; */
167 
168 /**
169  * @dev Interface for the optional metadata functions from the ERC20 standard.
170  *
171  * _Available since v4.1._
172  */
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178 
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183 
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189 
190 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
192 
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "./IERC20.sol"; */
196 /* import "./extensions/IERC20Metadata.sol"; */
197 /* import "../../utils/Context.sol"; */
198 
199 /**
200  * @dev Implementation of the {IERC20} interface.
201  *
202  * This implementation is agnostic to the way tokens are created. This means
203  * that a supply mechanism has to be added in a derived contract using {_mint}.
204  * For a generic mechanism see {ERC20PresetMinterPauser}.
205  *
206  * TIP: For a detailed writeup see our guide
207  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
208  * to implement supply mechanisms].
209  *
210  * We have followed general OpenZeppelin Contracts guidelines: functions revert
211  * instead returning `false` on failure. This behavior is nonetheless
212  * conventional and does not conflict with the expectations of ERC20
213  * applications.
214  *
215  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
216  * This allows applications to reconstruct the allowance for all accounts just
217  * by listening to said events. Other implementations of the EIP may not emit
218  * these events, as it isn't required by the specification.
219  *
220  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
221  * functions have been added to mitigate the well-known issues around setting
222  * allowances. See {IERC20-approve}.
223  */
224 contract ERC20 is Context, IERC20, IERC20Metadata {
225     mapping(address => uint256) private _balances;
226 
227     mapping(address => mapping(address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}.
236      *
237      * The default value of {decimals} is 18. To select a different value for
238      * {decimals} you should overload it.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the value {ERC20} uses, unless this function is
270      * overridden;
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-transferFrom}.
328      *
329      * Emits an {Approval} event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of {ERC20}.
331      *
332      * Requirements:
333      *
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) public virtual override returns (bool) {
344         _transfer(sender, recipient, amount);
345 
346         uint256 currentAllowance = _allowances[sender][_msgSender()];
347         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
348         unchecked {
349             _approve(sender, _msgSender(), currentAllowance - amount);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `sender` cannot be the zero address.
366      * - `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(sender, recipient, amount);
378 
379         uint256 senderBalance = _balances[sender];
380         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[sender] = senderBalance - amount;
383         }
384         _balances[recipient] += amount;
385 
386         emit Transfer(sender, recipient, amount);
387 
388         _afterTokenTransfer(sender, recipient, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 
458     /**
459      * @dev Hook that is called after any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * has been transferred to `to`.
466      * - when `from` is zero, `amount` tokens have been minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _afterTokenTransfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal virtual {}
477 }
478 
479 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
480 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
481 
482 /* pragma solidity ^0.8.0; */
483 
484 // CAUTION
485 // This version of SafeMath should only be used with Solidity 0.8 or later,
486 // because it relies on the compiler's built in overflow checks.
487 
488 /**
489  * @dev Wrappers over Solidity's arithmetic operations.
490  *
491  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
492  * now has built in overflow checking.
493  */
494 library SafeMath {
495     /**
496      * @dev Returns the addition of two unsigned integers, with an overflow flag.
497      *
498      * _Available since v3.4._
499      */
500     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
501         unchecked {
502             uint256 c = a + b;
503             if (c < a) return (false, 0);
504             return (true, c);
505         }
506     }
507 
508     /**
509      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
510      *
511      * _Available since v3.4._
512      */
513     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
514         unchecked {
515             if (b > a) return (false, 0);
516             return (true, a - b);
517         }
518     }
519 
520     /**
521      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
522      *
523      * _Available since v3.4._
524      */
525     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
526         unchecked {
527             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
528             // benefit is lost if 'b' is also tested.
529             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
530             if (a == 0) return (true, 0);
531             uint256 c = a * b;
532             if (c / a != b) return (false, 0);
533             return (true, c);
534         }
535     }
536 
537     /**
538      * @dev Returns the division of two unsigned integers, with a division by zero flag.
539      *
540      * _Available since v3.4._
541      */
542     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
543         unchecked {
544             if (b == 0) return (false, 0);
545             return (true, a / b);
546         }
547     }
548 
549     /**
550      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             if (b == 0) return (false, 0);
557             return (true, a % b);
558         }
559     }
560 
561     /**
562      * @dev Returns the addition of two unsigned integers, reverting on
563      * overflow.
564      *
565      * Counterpart to Solidity's `+` operator.
566      *
567      * Requirements:
568      *
569      * - Addition cannot overflow.
570      */
571     function add(uint256 a, uint256 b) internal pure returns (uint256) {
572         return a + b;
573     }
574 
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting on
577      * overflow (when the result is negative).
578      *
579      * Counterpart to Solidity's `-` operator.
580      *
581      * Requirements:
582      *
583      * - Subtraction cannot overflow.
584      */
585     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
586         return a - b;
587     }
588 
589     /**
590      * @dev Returns the multiplication of two unsigned integers, reverting on
591      * overflow.
592      *
593      * Counterpart to Solidity's `*` operator.
594      *
595      * Requirements:
596      *
597      * - Multiplication cannot overflow.
598      */
599     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
600         return a * b;
601     }
602 
603     /**
604      * @dev Returns the integer division of two unsigned integers, reverting on
605      * division by zero. The result is rounded towards zero.
606      *
607      * Counterpart to Solidity's `/` operator.
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function div(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a / b;
615     }
616 
617     /**
618      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
619      * reverting when dividing by zero.
620      *
621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
622      * opcode (which leaves remaining gas untouched) while Solidity uses an
623      * invalid opcode to revert (consuming all remaining gas).
624      *
625      * Requirements:
626      *
627      * - The divisor cannot be zero.
628      */
629     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a % b;
631     }
632 
633     /**
634      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
635      * overflow (when the result is negative).
636      *
637      * CAUTION: This function is deprecated because it requires allocating memory for the error
638      * message unnecessarily. For custom revert reasons use {trySub}.
639      *
640      * Counterpart to Solidity's `-` operator.
641      *
642      * Requirements:
643      *
644      * - Subtraction cannot overflow.
645      */
646     function sub(
647         uint256 a,
648         uint256 b,
649         string memory errorMessage
650     ) internal pure returns (uint256) {
651         unchecked {
652             require(b <= a, errorMessage);
653             return a - b;
654         }
655     }
656 
657     /**
658      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
659      * division by zero. The result is rounded towards zero.
660      *
661      * Counterpart to Solidity's `/` operator. Note: this function uses a
662      * `revert` opcode (which leaves remaining gas untouched) while Solidity
663      * uses an invalid opcode to revert (consuming all remaining gas).
664      *
665      * Requirements:
666      *
667      * - The divisor cannot be zero.
668      */
669     function div(
670         uint256 a,
671         uint256 b,
672         string memory errorMessage
673     ) internal pure returns (uint256) {
674         unchecked {
675             require(b > 0, errorMessage);
676             return a / b;
677         }
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
682      * reverting with custom message when dividing by zero.
683      *
684      * CAUTION: This function is deprecated because it requires allocating memory for the error
685      * message unnecessarily. For custom revert reasons use {tryMod}.
686      *
687      * Counterpart to Solidity's `%` operator. This function uses a `revert`
688      * opcode (which leaves remaining gas untouched) while Solidity uses an
689      * invalid opcode to revert (consuming all remaining gas).
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function mod(
696         uint256 a,
697         uint256 b,
698         string memory errorMessage
699     ) internal pure returns (uint256) {
700         unchecked {
701             require(b > 0, errorMessage);
702             return a % b;
703         }
704     }
705 }
706 
707 interface IUniswapV2Factory {
708     event PairCreated(
709         address indexed token0,
710         address indexed token1,
711         address pair,
712         uint256
713     );
714 
715     function createPair(address tokenA, address tokenB)
716         external
717         returns (address pair);
718 }
719 
720 interface IUniswapV2Router02 {
721     function factory() external pure returns (address);
722 
723     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
724         uint256 amountIn,
725         uint256 amountOutMin,
726         address[] calldata path,
727         address to,
728         uint256 deadline
729     ) external;
730 }
731 
732 contract DejitaruOdin is ERC20, Ownable {
733     using SafeMath for uint256;
734 
735     IUniswapV2Router02 public immutable uniswapV2Router;
736     address public immutable uniswapV2Pair;
737     address public constant deadAddress = address(0xdead);
738     address public TSUKA = 0xc5fB36dd2fb59d3B98dEfF88425a3F425Ee469eD;
739 
740     bool private swapping;
741 
742     address public devWallet;
743 
744     uint256 public maxTransactionAmount;
745     uint256 public swapTokensAtAmount;
746     uint256 public maxWallet;
747 
748     bool public limitsInEffect = true;
749     bool public tradingActive = false;
750     bool public swapEnabled = true;
751 
752     uint256 public buyTotalFees;
753     uint256 public buyDevFee;
754     uint256 public buyLiquidityFee;
755 
756     uint256 public sellTotalFees;
757     uint256 public sellDevFee;
758     uint256 public sellLiquidityFee;
759 
760     /******************/
761 
762     // exlcude from fees and max transaction amount
763     mapping(address => bool) private _isExcludedFromFees;
764     mapping(address => bool) public _isExcludedMaxTransactionAmount;
765 
766 
767     event ExcludeFromFees(address indexed account, bool isExcluded);
768 
769     event devWalletUpdated(
770         address indexed newWallet,
771         address indexed oldWallet
772     );
773 
774     constructor() ERC20("Dejitaru Odin", "ODIN") {
775         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
776 
777         excludeFromMaxTransaction(address(_uniswapV2Router), true);
778         uniswapV2Router = _uniswapV2Router;
779 
780         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
781             .createPair(address(this), TSUKA);
782         excludeFromMaxTransaction(address(uniswapV2Pair), true);
783 
784 
785         uint256 _buyDevFee = 10;
786         uint256 _buyLiquidityFee = 0;
787 
788         uint256 _sellDevFee = 10;
789         uint256 _sellLiquidityFee = 0;
790 
791         uint256 totalSupply = 500_000_000 * 1e18;
792 
793         maxTransactionAmount =  totalSupply * 3 / 100; // 3% from total supply maxTransactionAmountTxn
794         maxWallet = totalSupply * 3 / 100; // 3% from total supply maxWallet
795         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
796 
797         buyDevFee = _buyDevFee;
798         buyLiquidityFee = _buyLiquidityFee;
799         buyTotalFees = buyDevFee + buyLiquidityFee;
800 
801         sellDevFee = _sellDevFee;
802         sellLiquidityFee = _sellLiquidityFee;
803         sellTotalFees = sellDevFee + sellLiquidityFee;
804 
805         devWallet = address(0xdCf0DAC62a73d4C706d9b9E94d43338007310667); 
806 
807         // exclude from paying fees or having max transaction amount
808         excludeFromFees(owner(), true);
809         excludeFromFees(address(this), true);
810         excludeFromFees(address(0xdead), true);
811 
812         excludeFromMaxTransaction(owner(), true);
813         excludeFromMaxTransaction(address(this), true);
814         excludeFromMaxTransaction(address(0xdead), true);
815 
816         /*
817             _mint is an internal function in ERC20.sol that is only called here,
818             and CANNOT be called ever again
819         */
820         _mint(msg.sender, totalSupply);
821     }
822 
823     receive() external payable {}
824 
825     // once enabled, can never be turned off
826     function enableTrading() external onlyOwner {
827         tradingActive = true;
828         swapEnabled = true;
829     }
830 
831     // remove limits after token is stable
832     function removeLimits() external onlyOwner returns (bool) {
833         limitsInEffect = false;
834         return true;
835     }
836 
837     // change the minimum amount of tokens to sell from fees
838     function updateSwapTokensAtAmount(uint256 newAmount)
839         external
840         onlyOwner
841         returns (bool)
842     {
843         require(
844             newAmount >= (totalSupply() * 1) / 100000,
845             "Swap amount cannot be lower than 0.001% total supply."
846         );
847         require(
848             newAmount <= (totalSupply() * 5) / 1000,
849             "Swap amount cannot be higher than 0.5% total supply."
850         );
851         swapTokensAtAmount = newAmount;
852         return true;
853     }
854 
855     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
856         require(
857             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
858             "Cannot set maxTransactionAmount lower than 0.1%"
859         );
860         maxTransactionAmount = newNum * (10**18);
861     }
862 
863     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
864         require(
865             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
866             "Cannot set maxWallet lower than 0.5%"
867         );
868         maxWallet = newNum * (10**18);
869     }
870 
871     function excludeFromMaxTransaction(address updAds, bool isEx)
872         public
873         onlyOwner
874     {
875         _isExcludedMaxTransactionAmount[updAds] = isEx;
876     }
877 
878     // only use to disable contract sales if absolutely necessary (emergency use only)
879     function updateSwapEnabled(bool enabled) external onlyOwner {
880         swapEnabled = enabled;
881     }
882 
883     function updateBuyFees(
884         uint256 _devFee,
885         uint256 _liquidityFee
886     ) external onlyOwner {
887         buyDevFee = _devFee;
888         buyLiquidityFee = _liquidityFee;
889         buyTotalFees = buyDevFee + buyLiquidityFee;
890     }
891 
892     function updateSellFees(
893         uint256 _devFee,
894         uint256 _liquidityFee
895     ) external onlyOwner {
896         sellDevFee = _devFee;
897         sellLiquidityFee = _liquidityFee;
898         sellTotalFees = sellDevFee + sellLiquidityFee;
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