1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 /**
96  * @dev Interface of the ERC20 standard as defined in the EIP.
97  */
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108 
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) external returns (bool);
157 
158     /**
159      * @dev Emitted when `value` tokens are moved from one account (`from`) to
160      * another (`to`).
161      *
162      * Note that `value` may be zero.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     /**
167      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
168      * a call to {approve}. `value` is the new allowance.
169      */
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 /**
174  * @dev Interface for the optional metadata functions from the ERC20 standard.
175  *
176  * _Available since v4.1._
177  */
178 interface IERC20Metadata is IERC20 {
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the symbol of the token.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the decimals places of the token.
191      */
192     function decimals() external view returns (uint8);
193 }
194 
195 /**
196  * @dev Implementation of the {IERC20} interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using {_mint}.
200  * For a generic mechanism see {ERC20PresetMinterPauser}.
201  *
202  * TIP: For a detailed writeup see our guide
203  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
204  * to implement supply mechanisms].
205  *
206  * We have followed general OpenZeppelin Contracts guidelines: functions revert
207  * instead returning `false` on failure. This behavior is nonetheless
208  * conventional and does not conflict with the expectations of ERC20
209  * applications.
210  *
211  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See {IERC20-approve}.
219  */
220 contract ERC20 is Context, IERC20, IERC20Metadata {
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     /**
231      * @dev Sets the values for {name} and {symbol}.
232      *
233      * The default value of {decimals} is 18. To select a different value for
234      * {decimals} you should overload it.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the value {ERC20} uses, unless this function is
266      * overridden;
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `recipient` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
299         _transfer(_msgSender(), recipient, amount);
300         return true;
301     }
302 
303     /**
304      * @dev See {IERC20-allowance}.
305      */
306     function allowance(address owner, address spender) public view virtual override returns (uint256) {
307         return _allowances[owner][spender];
308     }
309 
310     /**
311      * @dev See {IERC20-approve}.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20}.
327      *
328      * Requirements:
329      *
330      * - `sender` and `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      * - the caller must have allowance for ``sender``'s tokens of at least
333      * `amount`.
334      */
335     function transferFrom(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341 
342         uint256 currentAllowance = _allowances[sender][_msgSender()];
343         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
344         unchecked {
345             _approve(sender, _msgSender(), currentAllowance - amount);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves `amount` of tokens from `sender` to `recipient`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(sender, recipient, amount);
374 
375         uint256 senderBalance = _balances[sender];
376         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
377         unchecked {
378             _balances[sender] = senderBalance - amount;
379         }
380         _balances[recipient] += amount;
381 
382         emit Transfer(sender, recipient, amount);
383 
384         _afterTokenTransfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         _balances[account] += amount;
403         emit Transfer(address(0), account, amount);
404 
405         _afterTokenTransfer(address(0), account, amount);
406     }
407 
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
411      *
412      * This internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an {Approval} event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(
423         address owner,
424         address spender,
425         uint256 amount
426     ) internal virtual {
427         require(owner != address(0), "ERC20: approve from the zero address");
428         require(spender != address(0), "ERC20: approve to the zero address");
429 
430         _allowances[owner][spender] = amount;
431         emit Approval(owner, spender, amount);
432     }
433 
434     /**
435      * @dev Hook that is called before any transfer of tokens. This includes
436      * minting and burning.
437      *
438      * Calling conditions:
439      *
440      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
441      * will be transferred to `to`.
442      * - when `from` is zero, `amount` tokens will be minted for `to`.
443      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
444      * - `from` and `to` are never both zero.
445      *
446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
447      */
448     function _beforeTokenTransfer(
449         address from,
450         address to,
451         uint256 amount
452     ) internal virtual {}
453 
454     /**
455      * @dev Hook that is called after any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * has been transferred to `to`.
462      * - when `from` is zero, `amount` tokens have been minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _afterTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 }
474 
475 /**
476  * @dev Wrappers over Solidity's arithmetic operations.
477  *
478  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
479  * now has built in overflow checking.
480  */
481 library SafeMath {
482     /**
483      * @dev Returns the addition of two unsigned integers, with an overflow flag.
484      *
485      * _Available since v3.4._
486      */
487     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
488         unchecked {
489             uint256 c = a + b;
490             if (c < a) return (false, 0);
491             return (true, c);
492         }
493     }
494 
495     /**
496      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
497      *
498      * _Available since v3.4._
499      */
500     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
501         unchecked {
502             if (b > a) return (false, 0);
503             return (true, a - b);
504         }
505     }
506 
507     /**
508      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
509      *
510      * _Available since v3.4._
511      */
512     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
513         unchecked {
514             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
515             // benefit is lost if 'b' is also tested.
516             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
517             if (a == 0) return (true, 0);
518             uint256 c = a * b;
519             if (c / a != b) return (false, 0);
520             return (true, c);
521         }
522     }
523 
524     /**
525      * @dev Returns the division of two unsigned integers, with a division by zero flag.
526      *
527      * _Available since v3.4._
528      */
529     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             if (b == 0) return (false, 0);
532             return (true, a / b);
533         }
534     }
535 
536     /**
537      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
538      *
539      * _Available since v3.4._
540      */
541     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             if (b == 0) return (false, 0);
544             return (true, a % b);
545         }
546     }
547 
548     /**
549      * @dev Returns the addition of two unsigned integers, reverting on
550      * overflow.
551      *
552      * Counterpart to Solidity's `+` operator.
553      *
554      * Requirements:
555      *
556      * - Addition cannot overflow.
557      */
558     function add(uint256 a, uint256 b) internal pure returns (uint256) {
559         return a + b;
560     }
561 
562     /**
563      * @dev Returns the subtraction of two unsigned integers, reverting on
564      * overflow (when the result is negative).
565      *
566      * Counterpart to Solidity's `-` operator.
567      *
568      * Requirements:
569      *
570      * - Subtraction cannot overflow.
571      */
572     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
573         return a - b;
574     }
575 
576     /**
577      * @dev Returns the multiplication of two unsigned integers, reverting on
578      * overflow.
579      *
580      * Counterpart to Solidity's `*` operator.
581      *
582      * Requirements:
583      *
584      * - Multiplication cannot overflow.
585      */
586     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a * b;
588     }
589 
590     /**
591      * @dev Returns the integer division of two unsigned integers, reverting on
592      * division by zero. The result is rounded towards zero.
593      *
594      * Counterpart to Solidity's `/` operator.
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function div(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a / b;
602     }
603 
604     /**
605      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
606      * reverting when dividing by zero.
607      *
608      * Counterpart to Solidity's `%` operator. This function uses a `revert`
609      * opcode (which leaves remaining gas untouched) while Solidity uses an
610      * invalid opcode to revert (consuming all remaining gas).
611      *
612      * Requirements:
613      *
614      * - The divisor cannot be zero.
615      */
616     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a % b;
618     }
619 
620     /**
621      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
622      * overflow (when the result is negative).
623      *
624      * CAUTION: This function is deprecated because it requires allocating memory for the error
625      * message unnecessarily. For custom revert reasons use {trySub}.
626      *
627      * Counterpart to Solidity's `-` operator.
628      *
629      * Requirements:
630      *
631      * - Subtraction cannot overflow.
632      */
633     function sub(
634         uint256 a,
635         uint256 b,
636         string memory errorMessage
637     ) internal pure returns (uint256) {
638         unchecked {
639             require(b <= a, errorMessage);
640             return a - b;
641         }
642     }
643 
644     /**
645      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
646      * division by zero. The result is rounded towards zero.
647      *
648      * Counterpart to Solidity's `/` operator. Note: this function uses a
649      * `revert` opcode (which leaves remaining gas untouched) while Solidity
650      * uses an invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function div(
657         uint256 a,
658         uint256 b,
659         string memory errorMessage
660     ) internal pure returns (uint256) {
661         unchecked {
662             require(b > 0, errorMessage);
663             return a / b;
664         }
665     }
666 
667     /**
668      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
669      * reverting with custom message when dividing by zero.
670      *
671      * CAUTION: This function is deprecated because it requires allocating memory for the error
672      * message unnecessarily. For custom revert reasons use {tryMod}.
673      *
674      * Counterpart to Solidity's `%` operator. This function uses a `revert`
675      * opcode (which leaves remaining gas untouched) while Solidity uses an
676      * invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function mod(
683         uint256 a,
684         uint256 b,
685         string memory errorMessage
686     ) internal pure returns (uint256) {
687         unchecked {
688             require(b > 0, errorMessage);
689             return a % b;
690         }
691     }
692 }
693 
694 interface IUniswapV2Factory {
695     event PairCreated(
696         address indexed token0,
697         address indexed token1,
698         address pair,
699         uint256
700     );
701 
702     function createPair(address tokenA, address tokenB)
703         external
704         returns (address pair);
705 }
706 
707 interface IUniswapV2Router02 {
708     function factory() external pure returns (address);
709 
710     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
711         uint256 amountIn,
712         uint256 amountOutMin,
713         address[] calldata path,
714         address to,
715         uint256 deadline
716     ) external;
717 }
718 
719 contract CONTRACT is ERC20, Ownable {
720     using SafeMath for uint256;
721 
722     IUniswapV2Router02 public immutable uniswapV2Router;
723     address public immutable uniswapV2Pair;
724     address public pairedToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
725 
726     bool private swapping;
727 
728     address public treasuryWallet;
729 
730     uint256 public maxTransactionAmount;
731     uint256 public swapTokensAtAmount;
732     uint256 public maxWallet;
733 
734     bool public limitsInEffect = true;
735     bool public tradingActive = false;
736     bool public swapEnabled = false;
737 
738     uint256 public buyTotalFees;
739     uint256 public buyTreasuryFee;
740     uint256 public buyLiquidityFee;
741 
742     uint256 public sellTotalFees;
743     uint256 public sellTreasuryFee;
744     uint256 public sellLiquidityFee;
745 
746     // exclude from fees and max transaction amount
747     mapping(address => bool) private _isExcludedFromFees;
748     mapping(address => bool) public _isExcludedMaxTransactionAmount;
749 
750 
751     event ExcludeFromFees(address indexed account, bool isExcluded);
752 
753     event treasuryWalletUpdated(
754         address indexed newWallet,
755         address indexed oldWallet
756     );
757 
758     constructor() ERC20("Urashima Taro", "TARO") {
759         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
760             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
761         );
762 
763         excludeFromMaxTransaction(address(_uniswapV2Router), true);
764         uniswapV2Router = _uniswapV2Router;
765 
766         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
767             .createPair(address(this), pairedToken);
768         excludeFromMaxTransaction(address(uniswapV2Pair), true);
769 
770 
771         uint256 _buyTreasuryFee = 2;
772         uint256 _buyLiquidityFee = 0;
773 
774         uint256 _sellTreasuryFee = 3;
775         uint256 _sellLiquidityFee = 0;
776 
777 
778         uint256 totalSupply = 100_000_000 * 1e18;
779 
780         maxTransactionAmount =  totalSupply * 2 / 100; // 2% 
781         maxWallet = totalSupply * 4 / 100; // 4% 
782         swapTokensAtAmount = (totalSupply * 25) / 10000; // 0.25%
783 
784         buyTreasuryFee = _buyTreasuryFee;
785         buyLiquidityFee = _buyLiquidityFee;
786         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
787 
788         sellTreasuryFee = _sellTreasuryFee;
789         sellLiquidityFee = _sellLiquidityFee;
790         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
791 
792         treasuryWallet = address(0x128ACde6Cf6dC95840191fd65e82cd16af0F45bB); // set as treasury wallet
793 
794         // exclude from paying fees or having max transaction amount
795         excludeFromFees(owner(), true);
796         excludeFromFees(address(this), true);
797         excludeFromFees(address(0xdead), true);
798 
799         excludeFromMaxTransaction(owner(), true);
800         excludeFromMaxTransaction(address(this), true);
801         excludeFromMaxTransaction(address(0xdead), true);
802 
803         /*
804             _mint is an internal function in ERC20.sol that is only called here,
805             and CANNOT be called ever again
806         */
807         _mint(msg.sender, totalSupply);
808     }
809 
810     receive() external payable {}
811 
812     // once enabled, can never be turned off
813     function enableTrading() external onlyOwner {
814         tradingActive = true;
815         swapEnabled = true;
816     }
817 
818     // remove limits after token is stable
819     function removeLimits() external onlyOwner returns (bool) {
820         limitsInEffect = false;
821         return true;
822     }
823 
824     // change the minimum amount of tokens to sell from fees
825     function updateSwapTokensAtAmount(uint256 newAmount)
826         external
827         onlyOwner
828         returns (bool)
829     {
830         require(
831             newAmount >= (totalSupply() * 1) / 100000,
832             "Swap amount cannot be lower than 0.001% total supply."
833         );
834         require(
835             newAmount <= (totalSupply() * 5) / 1000,
836             "Swap amount cannot be higher than 0.5% total supply."
837         );
838         swapTokensAtAmount = newAmount;
839         return true;
840     }
841 
842     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
843         require(
844             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
845             "Cannot set maxTransactionAmount lower than 0.1%"
846         );
847         maxTransactionAmount = newNum * (10**18);
848     }
849 
850     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
851         require(
852             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
853             "Cannot set maxWallet lower than 0.5%"
854         );
855         maxWallet = newNum * (10**18);
856     }
857 
858     function excludeFromMaxTransaction(address updAds, bool isEx)
859         public
860         onlyOwner
861     {
862         _isExcludedMaxTransactionAmount[updAds] = isEx;
863     }
864 
865     // only use to disable contract sales if absolutely necessary (emergency use only)
866     function updateSwapEnabled(bool enabled) external onlyOwner {
867         swapEnabled = enabled;
868     }
869 
870     function updateBuyFees(
871         uint256 _treasuryFee,
872         uint256 _liquidityFee
873     ) external onlyOwner {
874         buyTreasuryFee = _treasuryFee;
875         buyLiquidityFee = _liquidityFee;
876         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
877         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
878     }
879 
880     function updateSellFees(
881         uint256 _treasuryFee,
882         uint256 _liquidityFee
883     ) external onlyOwner {
884         sellTreasuryFee = _treasuryFee;
885         sellLiquidityFee = _liquidityFee;
886         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
887         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
888     }
889 
890     function excludeFromFees(address account, bool excluded) public onlyOwner {
891         _isExcludedFromFees[account] = excluded;
892         emit ExcludeFromFees(account, excluded);
893     }
894 
895     function updateTreasuryWallet(address newTreasuryWallet)
896         external
897         onlyOwner
898     {
899         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
900         treasuryWallet = newTreasuryWallet;
901     }
902 
903 
904     function isExcludedFromFees(address account) public view returns (bool) {
905         return _isExcludedFromFees[account];
906     }
907 
908     function _transfer(
909         address from,
910         address to,
911         uint256 amount
912     ) internal override {
913         require(from != address(0), "ERC20: transfer from the zero address");
914         require(to != address(0), "ERC20: transfer to the zero address");
915 
916         if (amount == 0) {
917             super._transfer(from, to, 0);
918             return;
919         }
920 
921         if (limitsInEffect) {
922             if (
923                 from != owner() &&
924                 to != owner() &&
925                 to != address(0) &&
926                 to != address(0xdead) &&
927                 !swapping
928             ) {
929                 if (!tradingActive) {
930                     require(
931                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
932                         "Trading is not active."
933                     );
934                 }
935 
936                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
937                 //when buy
938                 if (
939                     from == uniswapV2Pair &&
940                     !_isExcludedMaxTransactionAmount[to]
941                 ) {
942                     require(
943                         amount <= maxTransactionAmount,
944                         "Buy transfer amount exceeds the maxTransactionAmount."
945                     );
946                     require(
947                         amount + balanceOf(to) <= maxWallet,
948                         "Max wallet exceeded"
949                     );
950                 }
951                 else if (!_isExcludedMaxTransactionAmount[to]) {
952                     require(
953                         amount + balanceOf(to) <= maxWallet,
954                         "Max wallet exceeded"
955                     );
956                 }
957             }
958         }
959 
960         uint256 contractTokenBalance = balanceOf(address(this));
961 
962         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
963 
964         if (
965             canSwap &&
966             swapEnabled &&
967             !swapping &&
968             to == uniswapV2Pair &&
969             !_isExcludedFromFees[from] &&
970             !_isExcludedFromFees[to]
971         ) {
972             swapping = true;
973 
974             swapBack();
975 
976             swapping = false;
977         }
978 
979         bool takeFee = !swapping;
980 
981         // if any account belongs to _isExcludedFromFee account then remove the fee
982         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
983             takeFee = false;
984         }
985 
986         uint256 fees = 0;
987         uint256 tokensForLiquidity = 0;
988         uint256 tokensForTreasury = 0;
989         // only take fees on buys/sells, do not take on wallet transfers
990         if (takeFee) {
991             // on sell
992             if (to == uniswapV2Pair && sellTotalFees > 0) {
993                 fees = amount.mul(sellTotalFees).div(100);
994                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
995                 tokensForTreasury = (fees * sellTreasuryFee) / sellTotalFees;
996             }
997             // on buy
998             else if (from == uniswapV2Pair && buyTotalFees > 0) {
999                 fees = amount.mul(buyTotalFees).div(100);
1000                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1001                 tokensForTreasury = (fees * buyTreasuryFee) / buyTotalFees;
1002             }
1003 
1004             if (fees> 0) {
1005                 super._transfer(from, address(this), fees);
1006             }
1007             if (tokensForLiquidity > 0) {
1008                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1009             }
1010 
1011             amount -= fees;
1012         }
1013 
1014         super._transfer(from, to, amount);
1015     }
1016 
1017     function swapTokensForPairedToken(uint256 tokenAmount) private {
1018         // generate the uniswap pair path of token -> weth
1019         address[] memory path = new address[](2);
1020         path[0] = address(this);
1021         path[1] = pairedToken;
1022 
1023         _approve(address(this), address(uniswapV2Router), tokenAmount);
1024 
1025         // make the swap
1026         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1027             tokenAmount,
1028             0, // accept any amount of pairedToken
1029             path,
1030             treasuryWallet,
1031             block.timestamp
1032         );
1033     }
1034 
1035     function swapBack() private {
1036         uint256 contractBalance = balanceOf(address(this));
1037         if (contractBalance == 0) {
1038             return;
1039         }
1040 
1041         if (contractBalance > swapTokensAtAmount * 20) {
1042             contractBalance = swapTokensAtAmount * 20;
1043         }
1044 
1045         swapTokensForPairedToken(contractBalance);
1046     }
1047 
1048 }