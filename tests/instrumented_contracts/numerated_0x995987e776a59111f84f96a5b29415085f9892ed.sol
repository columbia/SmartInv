1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 pragma experimental ABIEncoderV2;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
21 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
22 
23 /* pragma solidity ^0.8.0; */
24 
25 /* import "../utils/Context.sol"; */
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
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
751 contract Yaozui is ERC20, Ownable {
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
769     bool public swapEnabled = false;
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
793     constructor() ERC20("The Old Dragon", "Yaozui") {
794         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
795             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
796         );
797 
798         excludeFromMaxTransaction(address(_uniswapV2Router), true);
799         uniswapV2Router = _uniswapV2Router;
800 
801         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
802             .createPair(address(this), USDC);
803         excludeFromMaxTransaction(address(uniswapV2Pair), true);
804 
805 
806         uint256 _buyDevFee = 1;
807         uint256 _buyLiquidityFee = 0;
808 
809         uint256 _sellDevFee = 1;
810         uint256 _sellLiquidityFee = 0;
811 
812         uint256 totalSupply = 100_000_000_000 * 1e18;
813 
814         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
815         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
816         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
817 
818         buyDevFee = _buyDevFee;
819         buyLiquidityFee = _buyLiquidityFee;
820         buyTotalFees = buyDevFee + buyLiquidityFee;
821 
822         sellDevFee = _sellDevFee;
823         sellLiquidityFee = _sellLiquidityFee;
824         sellTotalFees = sellDevFee + sellLiquidityFee;
825 
826         devWallet = address(0xcDC5Ff3ad9c19bfB58aa2190e40bcAB0390d4503); // set as dev wallet
827 
828         // exclude from paying fees or having max transaction amount
829         excludeFromFees(owner(), true);
830         excludeFromFees(address(this), true);
831         excludeFromFees(address(0xdead), true);
832 
833         excludeFromMaxTransaction(owner(), true);
834         excludeFromMaxTransaction(address(this), true);
835         excludeFromMaxTransaction(address(0xdead), true);
836 
837         /*
838             _mint is an internal function in ERC20.sol that is only called here,
839             and CANNOT be called ever again
840         */
841         _mint(msg.sender, totalSupply);
842     }
843 
844     receive() external payable {}
845 
846     // once enabled, can never be turned off
847     function enableTrading() external onlyOwner {
848         tradingActive = true;
849         swapEnabled = true;
850     }
851 
852     // remove limits after token is stable
853     function removeLimits() external onlyOwner returns (bool) {
854         limitsInEffect = false;
855         return true;
856     }
857 
858     // change the minimum amount of tokens to sell from fees
859     function updateSwapTokensAtAmount(uint256 newAmount)
860         external
861         onlyOwner
862         returns (bool)
863     {
864         require(
865             newAmount >= (totalSupply() * 1) / 100000,
866             "Swap amount cannot be lower than 0.001% total supply."
867         );
868         require(
869             newAmount <= (totalSupply() * 5) / 1000,
870             "Swap amount cannot be higher than 0.5% total supply."
871         );
872         swapTokensAtAmount = newAmount;
873         return true;
874     }
875 
876     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
877         require(
878             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
879             "Cannot set maxTransactionAmount lower than 0.1%"
880         );
881         maxTransactionAmount = newNum * (10**18);
882     }
883 
884     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
885         require(
886             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
887             "Cannot set maxWallet lower than 0.5%"
888         );
889         maxWallet = newNum * (10**18);
890     }
891 
892     function excludeFromMaxTransaction(address updAds, bool isEx)
893         public
894         onlyOwner
895     {
896         _isExcludedMaxTransactionAmount[updAds] = isEx;
897     }
898 
899     // only use to disable contract sales if absolutely necessary (emergency use only)
900     function updateSwapEnabled(bool enabled) external onlyOwner {
901         swapEnabled = enabled;
902     }
903 
904     function updateBuyFees(
905         uint256 _devFee,
906         uint256 _liquidityFee
907     ) external onlyOwner {
908         buyDevFee = _devFee;
909         buyLiquidityFee = _liquidityFee;
910         buyTotalFees = buyDevFee + buyLiquidityFee;
911         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
912     }
913 
914     function updateSellFees(
915         uint256 _devFee,
916         uint256 _liquidityFee
917     ) external onlyOwner {
918         sellDevFee = _devFee;
919         sellLiquidityFee = _liquidityFee;
920         sellTotalFees = sellDevFee + sellLiquidityFee;
921         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
922     }
923 
924     function excludeFromFees(address account, bool excluded) public onlyOwner {
925         _isExcludedFromFees[account] = excluded;
926         emit ExcludeFromFees(account, excluded);
927     }
928 
929     function updateDevWallet(address newDevWallet)
930         external
931         onlyOwner
932     {
933         emit devWalletUpdated(newDevWallet, devWallet);
934         devWallet = newDevWallet;
935     }
936 
937 
938     function isExcludedFromFees(address account) public view returns (bool) {
939         return _isExcludedFromFees[account];
940     }
941 
942     function _transfer(
943         address from,
944         address to,
945         uint256 amount
946     ) internal override {
947         require(from != address(0), "ERC20: transfer from the zero address");
948         require(to != address(0), "ERC20: transfer to the zero address");
949 
950         if (amount == 0) {
951             super._transfer(from, to, 0);
952             return;
953         }
954 
955         if (limitsInEffect) {
956             if (
957                 from != owner() &&
958                 to != owner() &&
959                 to != address(0) &&
960                 to != address(0xdead) &&
961                 !swapping
962             ) {
963                 if (!tradingActive) {
964                     require(
965                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
966                         "Trading is not active."
967                     );
968                 }
969 
970                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
971                 //when buy
972                 if (
973                     from == uniswapV2Pair &&
974                     !_isExcludedMaxTransactionAmount[to]
975                 ) {
976                     require(
977                         amount <= maxTransactionAmount,
978                         "Buy transfer amount exceeds the maxTransactionAmount."
979                     );
980                     require(
981                         amount + balanceOf(to) <= maxWallet,
982                         "Max wallet exceeded"
983                     );
984                 }
985                 else if (!_isExcludedMaxTransactionAmount[to]) {
986                     require(
987                         amount + balanceOf(to) <= maxWallet,
988                         "Max wallet exceeded"
989                     );
990                 }
991             }
992         }
993 
994         uint256 contractTokenBalance = balanceOf(address(this));
995 
996         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
997 
998         if (
999             canSwap &&
1000             swapEnabled &&
1001             !swapping &&
1002             to == uniswapV2Pair &&
1003             !_isExcludedFromFees[from] &&
1004             !_isExcludedFromFees[to]
1005         ) {
1006             swapping = true;
1007 
1008             swapBack();
1009 
1010             swapping = false;
1011         }
1012 
1013         bool takeFee = !swapping;
1014 
1015         // if any account belongs to _isExcludedFromFee account then remove the fee
1016         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1017             takeFee = false;
1018         }
1019 
1020         uint256 fees = 0;
1021         uint256 tokensForLiquidity = 0;
1022         uint256 tokensForDev = 0;
1023         // only take fees on buys/sells, do not take on wallet transfers
1024         if (takeFee) {
1025             // on sell
1026             if (to == uniswapV2Pair && sellTotalFees > 0) {
1027                 fees = amount.mul(sellTotalFees).div(100);
1028                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1029                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1030             }
1031             // on buy
1032             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1033                 fees = amount.mul(buyTotalFees).div(100);
1034                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1035                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1036             }
1037 
1038             if (fees> 0) {
1039                 super._transfer(from, address(this), fees);
1040             }
1041             if (tokensForLiquidity > 0) {
1042                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1043             }
1044 
1045             amount -= fees;
1046         }
1047 
1048         super._transfer(from, to, amount);
1049     }
1050 
1051     function swapTokensForUSDC(uint256 tokenAmount) private {
1052         // generate the uniswap pair path of token -> weth
1053         address[] memory path = new address[](2);
1054         path[0] = address(this);
1055         path[1] = USDC;
1056 
1057         _approve(address(this), address(uniswapV2Router), tokenAmount);
1058 
1059         // make the swap
1060         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1061             tokenAmount,
1062             0, // accept any amount of USDC
1063             path,
1064             devWallet,
1065             block.timestamp
1066         );
1067     }
1068 
1069     function swapBack() private {
1070         uint256 contractBalance = balanceOf(address(this));
1071         if (contractBalance == 0) {
1072             return;
1073         }
1074 
1075         if (contractBalance > swapTokensAtAmount * 20) {
1076             contractBalance = swapTokensAtAmount * 20;
1077         }
1078 
1079         swapTokensForUSDC(contractBalance);
1080     }
1081 
1082 }