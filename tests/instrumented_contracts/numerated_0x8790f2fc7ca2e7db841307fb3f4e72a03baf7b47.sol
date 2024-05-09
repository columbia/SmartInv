1 /****
2 
3 Welcome to SpillWays!
4 
5 The place where your business is none of our business.
6 
7 Created as a viable alternative to Tornado Cash, SpillWays is comprised of a fully decentralized protocol for private transactions on Ethereum. Fast, secure and scalable.
8 
9 Token Details
10 Network: ERC-20
11 100 million supply
12 
13 6% Buy
14 -3% Dev
15 -3% Liquidity
16 
17 6% Sell
18 -3% Dev
19 -3% Liquidity
20 
21 Join Our Community!
22 Medium :https://spillways.medium.com/
23 Telegram :https://t.me/SpillWaysJoin
24 Twitter :https://twitter.com/spillways10
25 Website :https://spillways.finance/
26 
27 ***/
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
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _transferOwnership(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _transferOwnership(newOwner);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Internal function without access restriction.
89      */
90     function _transferOwnership(address newOwner) internal virtual {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
98 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
99 
100 /* pragma solidity ^0.8.0; */
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
181 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
182 
183 /* pragma solidity ^0.8.0; */
184 
185 /* import "../IERC20.sol"; */
186 
187 /**
188  * @dev Interface for the optional metadata functions from the ERC20 standard.
189  *
190  * _Available since v4.1._
191  */
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208 
209 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
210 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
211 
212 /* pragma solidity ^0.8.0; */
213 
214 /* import "./IERC20.sol"; */
215 /* import "./extensions/IERC20Metadata.sol"; */
216 /* import "../../utils/Context.sol"; */
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin Contracts guidelines: functions revert
230  * instead returning `false` on failure. This behavior is nonetheless
231  * conventional and does not conflict with the expectations of ERC20
232  * applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     /**
254      * @dev Sets the values for {name} and {symbol}.
255      *
256      * The default value of {decimals} is 18. To select a different value for
257      * {decimals} you should overload it.
258      *
259      * All two of these values are immutable: they can only be set once during
260      * construction.
261      */
262     constructor(string memory name_, string memory symbol_) {
263         _name = name_;
264         _symbol = symbol_;
265     }
266 
267     /**
268      * @dev Returns the name of the token.
269      */
270     function name() public view virtual override returns (string memory) {
271         return _name;
272     }
273 
274     /**
275      * @dev Returns the symbol of the token, usually a shorter version of the
276      * name.
277      */
278     function symbol() public view virtual override returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @dev Returns the number of decimals used to get its user representation.
284      * For example, if `decimals` equals `2`, a balance of `505` tokens should
285      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
286      *
287      * Tokens usually opt for a value of 18, imitating the relationship between
288      * Ether and Wei. This is the value {ERC20} uses, unless this function is
289      * overridden;
290      *
291      * NOTE: This information is only used for _display_ purposes: it in
292      * no way affects any of the arithmetic of the contract, including
293      * {IERC20-balanceOf} and {IERC20-transfer}.
294      */
295     function decimals() public view virtual override returns (uint8) {
296         return 18;
297     }
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view virtual override returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329     function allowance(address owner, address spender) public view virtual override returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     /**
334      * @dev See {IERC20-approve}.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * Requirements:
352      *
353      * - `sender` and `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      * - the caller must have allowance for ``sender``'s tokens of at least
356      * `amount`.
357      */
358     function transferFrom(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) public virtual override returns (bool) {
363         _transfer(sender, recipient, amount);
364 
365         uint256 currentAllowance = _allowances[sender][_msgSender()];
366         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
367         unchecked {
368             _approve(sender, _msgSender(), currentAllowance - amount);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Moves `amount` of tokens from `sender` to `recipient`.
376      *
377      * This internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) internal virtual {
393         require(sender != address(0), "ERC20: transfer from the zero address");
394         require(recipient != address(0), "ERC20: transfer to the zero address");
395 
396         _beforeTokenTransfer(sender, recipient, amount);
397 
398         uint256 senderBalance = _balances[sender];
399         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
400         unchecked {
401             _balances[sender] = senderBalance - amount;
402         }
403         _balances[recipient] += amount;
404 
405         emit Transfer(sender, recipient, amount);
406 
407         _afterTokenTransfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
427 
428         _afterTokenTransfer(address(0), account, amount);
429     }
430 
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Hook that is called before any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * will be transferred to `to`.
465      * - when `from` is zero, `amount` tokens will be minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 
477     /**
478      * @dev Hook that is called after any transfer of tokens. This includes
479      * minting and burning.
480      *
481      * Calling conditions:
482      *
483      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
484      * has been transferred to `to`.
485      * - when `from` is zero, `amount` tokens have been minted for `to`.
486      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
487      * - `from` and `to` are never both zero.
488      *
489      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
490      */
491     function _afterTokenTransfer(
492         address from,
493         address to,
494         uint256 amount
495     ) internal virtual {}
496 }
497 
498 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
499 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
500 
501 /* pragma solidity ^0.8.0; */
502 
503 // CAUTION
504 // This version of SafeMath should only be used with Solidity 0.8 or later,
505 // because it relies on the compiler's built in overflow checks.
506 
507 /**
508  * @dev Wrappers over Solidity's arithmetic operations.
509  *
510  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
511  * now has built in overflow checking.
512  */
513 library SafeMath {
514     /**
515      * @dev Returns the addition of two unsigned integers, with an overflow flag.
516      *
517      * _Available since v3.4._
518      */
519     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
520         unchecked {
521             uint256 c = a + b;
522             if (c < a) return (false, 0);
523             return (true, c);
524         }
525     }
526 
527     /**
528      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
529      *
530      * _Available since v3.4._
531      */
532     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
533         unchecked {
534             if (b > a) return (false, 0);
535             return (true, a - b);
536         }
537     }
538 
539     /**
540      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
541      *
542      * _Available since v3.4._
543      */
544     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
545         unchecked {
546             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
547             // benefit is lost if 'b' is also tested.
548             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
549             if (a == 0) return (true, 0);
550             uint256 c = a * b;
551             if (c / a != b) return (false, 0);
552             return (true, c);
553         }
554     }
555 
556     /**
557      * @dev Returns the division of two unsigned integers, with a division by zero flag.
558      *
559      * _Available since v3.4._
560      */
561     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
562         unchecked {
563             if (b == 0) return (false, 0);
564             return (true, a / b);
565         }
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
570      *
571      * _Available since v3.4._
572      */
573     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574         unchecked {
575             if (b == 0) return (false, 0);
576             return (true, a % b);
577         }
578     }
579 
580     /**
581      * @dev Returns the addition of two unsigned integers, reverting on
582      * overflow.
583      *
584      * Counterpart to Solidity's `+` operator.
585      *
586      * Requirements:
587      *
588      * - Addition cannot overflow.
589      */
590     function add(uint256 a, uint256 b) internal pure returns (uint256) {
591         return a + b;
592     }
593 
594     /**
595      * @dev Returns the subtraction of two unsigned integers, reverting on
596      * overflow (when the result is negative).
597      *
598      * Counterpart to Solidity's `-` operator.
599      *
600      * Requirements:
601      *
602      * - Subtraction cannot overflow.
603      */
604     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
605         return a - b;
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `*` operator.
613      *
614      * Requirements:
615      *
616      * - Multiplication cannot overflow.
617      */
618     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a * b;
620     }
621 
622     /**
623      * @dev Returns the integer division of two unsigned integers, reverting on
624      * division by zero. The result is rounded towards zero.
625      *
626      * Counterpart to Solidity's `/` operator.
627      *
628      * Requirements:
629      *
630      * - The divisor cannot be zero.
631      */
632     function div(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a / b;
634     }
635 
636     /**
637      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
638      * reverting when dividing by zero.
639      *
640      * Counterpart to Solidity's `%` operator. This function uses a `revert`
641      * opcode (which leaves remaining gas untouched) while Solidity uses an
642      * invalid opcode to revert (consuming all remaining gas).
643      *
644      * Requirements:
645      *
646      * - The divisor cannot be zero.
647      */
648     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a % b;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
654      * overflow (when the result is negative).
655      *
656      * CAUTION: This function is deprecated because it requires allocating memory for the error
657      * message unnecessarily. For custom revert reasons use {trySub}.
658      *
659      * Counterpart to Solidity's `-` operator.
660      *
661      * Requirements:
662      *
663      * - Subtraction cannot overflow.
664      */
665     function sub(
666         uint256 a,
667         uint256 b,
668         string memory errorMessage
669     ) internal pure returns (uint256) {
670         unchecked {
671             require(b <= a, errorMessage);
672             return a - b;
673         }
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator. Note: this function uses a
681      * `revert` opcode (which leaves remaining gas untouched) while Solidity
682      * uses an invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(
689         uint256 a,
690         uint256 b,
691         string memory errorMessage
692     ) internal pure returns (uint256) {
693         unchecked {
694             require(b > 0, errorMessage);
695             return a / b;
696         }
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
701      * reverting with custom message when dividing by zero.
702      *
703      * CAUTION: This function is deprecated because it requires allocating memory for the error
704      * message unnecessarily. For custom revert reasons use {tryMod}.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function mod(
715         uint256 a,
716         uint256 b,
717         string memory errorMessage
718     ) internal pure returns (uint256) {
719         unchecked {
720             require(b > 0, errorMessage);
721             return a % b;
722         }
723     }
724 }
725 
726 interface IUniswapV2Factory {
727     event PairCreated(
728         address indexed token0,
729         address indexed token1,
730         address pair,
731         uint256
732     );
733 
734     function createPair(address tokenA, address tokenB)
735         external
736         returns (address pair);
737 }
738 
739 interface IUniswapV2Router02 {
740     function factory() external pure returns (address);
741 
742     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
743         uint256 amountIn,
744         uint256 amountOutMin,
745         address[] calldata path,
746         address to,
747         uint256 deadline
748     ) external;
749 }
750 
751 contract SpillWays is ERC20, Ownable {
752     using SafeMath for uint256;
753 
754     IUniswapV2Router02 public immutable uniswapV2Router;
755     address public immutable uniswapV2Pair;
756     address public constant deadAddress = address(0xdead);
757     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
758 
759     bool private swapping;
760 
761     address public devWallet;
762 
763     uint256 public maxTransactionAmount;
764     uint256 public swapTokensAtAmount;
765     uint256 public maxWallet;
766 
767     bool public limitsInEffect = true;
768     bool public tradingActive = false;
769     bool public swapEnabled = true;
770 
771     uint256 public buyTotalFees;
772     uint256 public buyDevFee;
773     uint256 public buyLiquidityFee;
774 
775     uint256 public sellTotalFees;
776     uint256 public sellDevFee;
777     uint256 public sellLiquidityFee;
778 
779     /******************/
780 
781     // exlcude from fees and max transaction amount
782     mapping(address => bool) private _isExcludedFromFees;
783     mapping(address => bool) public _isExcludedMaxTransactionAmount;
784 
785 
786     event ExcludeFromFees(address indexed account, bool isExcluded);
787 
788     event devWalletUpdated(
789         address indexed newWallet,
790         address indexed oldWallet
791     );
792 
793     constructor() ERC20("SpillWays", "SpillWays") {
794         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
795 
796         excludeFromMaxTransaction(address(_uniswapV2Router), true);
797         uniswapV2Router = _uniswapV2Router;
798 
799         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
800             .createPair(address(this), USDC);
801         excludeFromMaxTransaction(address(uniswapV2Pair), true);
802 
803 
804         uint256 _buyDevFee = 6;
805         uint256 _buyLiquidityFee = 0;
806 
807         uint256 _sellDevFee = 6;
808         uint256 _sellLiquidityFee = 0;
809 
810         uint256 totalSupply = 100_000_000 * 1e18;
811 
812         maxTransactionAmount =  totalSupply * 1 / 100; // 2% from total supply maxTransactionAmountTxn
813         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
814         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
815 
816         buyDevFee = _buyDevFee;
817         buyLiquidityFee = _buyLiquidityFee;
818         buyTotalFees = buyDevFee + buyLiquidityFee;
819 
820         sellDevFee = _sellDevFee;
821         sellLiquidityFee = _sellLiquidityFee;
822         sellTotalFees = sellDevFee + sellLiquidityFee;
823 
824         devWallet = address(0x618f5F2C385602D49215F51d4551A0F27BE65D64); // set as dev wallet
825 
826         // exclude from paying fees or having max transaction amount
827         excludeFromFees(owner(), true);
828         excludeFromFees(address(this), true);
829         excludeFromFees(address(0xdead), true);
830 
831         excludeFromMaxTransaction(owner(), true);
832         excludeFromMaxTransaction(address(this), true);
833         excludeFromMaxTransaction(address(0xdead), true);
834 
835         /*
836             _mint is an internal function in ERC20.sol that is only called here,
837             and CANNOT be called ever again
838         */
839         _mint(msg.sender, totalSupply);
840     }
841 
842     receive() external payable {}
843 
844     // once enabled, can never be turned off
845     function enableTrading() external onlyOwner {
846         tradingActive = true;
847         swapEnabled = true;
848     }
849 
850     // remove limits after token is stable
851     function removeLimits() external onlyOwner returns (bool) {
852         limitsInEffect = false;
853         return true;
854     }
855 
856     // change the minimum amount of tokens to sell from fees
857     function updateSwapTokensAtAmount(uint256 newAmount)
858         external
859         onlyOwner
860         returns (bool)
861     {
862         require(
863             newAmount >= (totalSupply() * 1) / 100000,
864             "Swap amount cannot be lower than 0.001% total supply."
865         );
866         require(
867             newAmount <= (totalSupply() * 5) / 1000,
868             "Swap amount cannot be higher than 0.5% total supply."
869         );
870         swapTokensAtAmount = newAmount;
871         return true;
872     }
873 
874     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
875         require(
876             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
877             "Cannot set maxTransactionAmount lower than 0.1%"
878         );
879         maxTransactionAmount = newNum * (10**18);
880     }
881 
882     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
883         require(
884             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
885             "Cannot set maxWallet lower than 0.5%"
886         );
887         maxWallet = newNum * (10**18);
888     }
889 
890     function excludeFromMaxTransaction(address updAds, bool isEx)
891         public
892         onlyOwner
893     {
894         _isExcludedMaxTransactionAmount[updAds] = isEx;
895     }
896 
897     // only use to disable contract sales if absolutely necessary (emergency use only)
898     function updateSwapEnabled(bool enabled) external onlyOwner {
899         swapEnabled = enabled;
900     }
901 
902     function updateBuyFees(
903         uint256 _devFee,
904         uint256 _liquidityFee
905     ) external onlyOwner {
906         buyDevFee = _devFee;
907         buyLiquidityFee = _liquidityFee;
908         buyTotalFees = buyDevFee + buyLiquidityFee;
909         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
910     }
911 
912     function updateSellFees(
913         uint256 _devFee,
914         uint256 _liquidityFee
915     ) external onlyOwner {
916         sellDevFee = _devFee;
917         sellLiquidityFee = _liquidityFee;
918         sellTotalFees = sellDevFee + sellLiquidityFee;
919         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
920     }
921 
922     function excludeFromFees(address account, bool excluded) public onlyOwner {
923         _isExcludedFromFees[account] = excluded;
924         emit ExcludeFromFees(account, excluded);
925     }
926 
927     function updateDevWallet(address newDevWallet)
928         external
929         onlyOwner
930     {
931         emit devWalletUpdated(newDevWallet, devWallet);
932         devWallet = newDevWallet;
933     }
934 
935 
936     function isExcludedFromFees(address account) public view returns (bool) {
937         return _isExcludedFromFees[account];
938     }
939 
940     function _transfer(
941         address from,
942         address to,
943         uint256 amount
944     ) internal override {
945         require(from != address(0), "ERC20: transfer from the zero address");
946         require(to != address(0), "ERC20: transfer to the zero address");
947 
948         if (amount == 0) {
949             super._transfer(from, to, 0);
950             return;
951         }
952 
953         if (limitsInEffect) {
954             if (
955                 from != owner() &&
956                 to != owner() &&
957                 to != address(0) &&
958                 to != address(0xdead) &&
959                 !swapping
960             ) {
961                 if (!tradingActive) {
962                     require(
963                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
964                         "Trading is not active."
965                     );
966                 }
967 
968                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
969                 //when buy
970                 if (
971                     from == uniswapV2Pair &&
972                     !_isExcludedMaxTransactionAmount[to]
973                 ) {
974                     require(
975                         amount <= maxTransactionAmount,
976                         "Buy transfer amount exceeds the maxTransactionAmount."
977                     );
978                     require(
979                         amount + balanceOf(to) <= maxWallet,
980                         "Max wallet exceeded"
981                     );
982                 }
983                 else if (!_isExcludedMaxTransactionAmount[to]) {
984                     require(
985                         amount + balanceOf(to) <= maxWallet,
986                         "Max wallet exceeded"
987                     );
988                 }
989             }
990         }
991 
992         uint256 contractTokenBalance = balanceOf(address(this));
993 
994         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
995 
996         if (
997             canSwap &&
998             swapEnabled &&
999             !swapping &&
1000             to == uniswapV2Pair &&
1001             !_isExcludedFromFees[from] &&
1002             !_isExcludedFromFees[to]
1003         ) {
1004             swapping = true;
1005 
1006             swapBack();
1007 
1008             swapping = false;
1009         }
1010 
1011         bool takeFee = !swapping;
1012 
1013         // if any account belongs to _isExcludedFromFee account then remove the fee
1014         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1015             takeFee = false;
1016         }
1017 
1018         uint256 fees = 0;
1019         uint256 tokensForLiquidity = 0;
1020         uint256 tokensForDev = 0;
1021         // only take fees on buys/sells, do not take on wallet transfers
1022         if (takeFee) {
1023             // on sell
1024             if (to == uniswapV2Pair && sellTotalFees > 0) {
1025                 fees = amount.mul(sellTotalFees).div(100);
1026                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1027                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1028             }
1029             // on buy
1030             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1031                 fees = amount.mul(buyTotalFees).div(100);
1032                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1033                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1034             }
1035 
1036             if (fees> 0) {
1037                 super._transfer(from, address(this), fees);
1038             }
1039             if (tokensForLiquidity > 0) {
1040                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1041             }
1042 
1043             amount -= fees;
1044         }
1045 
1046         super._transfer(from, to, amount);
1047     }
1048 
1049     function swapTokensForUSDC(uint256 tokenAmount) private {
1050         // generate the uniswap pair path of token -> weth
1051         address[] memory path = new address[](2);
1052         path[0] = address(this);
1053         path[1] = USDC;
1054 
1055         _approve(address(this), address(uniswapV2Router), tokenAmount);
1056 
1057         // make the swap
1058         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1059             tokenAmount,
1060             0, // accept any amount of USDC
1061             path,
1062             devWallet,
1063             block.timestamp
1064         );
1065     }
1066 
1067     function swapBack() private {
1068         uint256 contractBalance = balanceOf(address(this));
1069         if (contractBalance == 0) {
1070             return;
1071         }
1072 
1073         if (contractBalance > swapTokensAtAmount * 20) {
1074             contractBalance = swapTokensAtAmount * 20;
1075         }
1076 
1077         swapTokensForUSDC(contractBalance);
1078     }
1079 
1080 }