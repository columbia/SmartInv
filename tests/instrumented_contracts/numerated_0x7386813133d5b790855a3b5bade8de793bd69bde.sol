1 /**
2 Hassuru Kamoku
3 Watashi wa mite iru
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity ^0.8.10;
8 pragma experimental ABIEncoderV2;
9 
10 
11 /* pragma solidity ^0.8.0; */
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
25 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
26 
27 /* pragma solidity ^0.8.0; */
28 
29 /* import "../utils/Context.sol"; */
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
102 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
103 
104 /* pragma solidity ^0.8.0; */
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
185 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
186 
187 /* pragma solidity ^0.8.0; */
188 
189 /* import "../IERC20.sol"; */
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
214 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
215 
216 /* pragma solidity ^0.8.0; */
217 
218 /* import "./IERC20.sol"; */
219 /* import "./extensions/IERC20Metadata.sol"; */
220 /* import "../../utils/Context.sol"; */
221 
222 /**
223  * @dev Implementation of the {IERC20} interface.
224  *
225  * This implementation is agnostic to the way tokens are created. This means
226  * that a supply mechanism has to be added in a derived contract using {_mint}.
227  * For a generic mechanism see {ERC20PresetMinterPauser}.
228  *
229  * TIP: For a detailed writeup see our guide
230  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
231  * to implement supply mechanisms].
232  *
233  * We have followed general OpenZeppelin Contracts guidelines: functions revert
234  * instead returning `false` on failure. This behavior is nonetheless
235  * conventional and does not conflict with the expectations of ERC20
236  * applications.
237  *
238  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
239  * This allows applications to reconstruct the allowance for all accounts just
240  * by listening to said events. Other implementations of the EIP may not emit
241  * these events, as it isn't required by the specification.
242  *
243  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
244  * functions have been added to mitigate the well-known issues around setting
245  * allowances. See {IERC20-approve}.
246  */
247 contract ERC20 is Context, IERC20, IERC20Metadata {
248     mapping(address => uint256) private _balances;
249 
250     mapping(address => mapping(address => uint256)) private _allowances;
251 
252     uint256 private _totalSupply;
253 
254     string private _name;
255     string private _symbol;
256 
257     /**
258      * @dev Sets the values for {name} and {symbol}.
259      *
260      * The default value of {decimals} is 18. To select a different value for
261      * {decimals} you should overload it.
262      *
263      * All two of these values are immutable: they can only be set once during
264      * construction.
265      */
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     /**
272      * @dev Returns the name of the token.
273      */
274     function name() public view virtual override returns (string memory) {
275         return _name;
276     }
277 
278     /**
279      * @dev Returns the symbol of the token, usually a shorter version of the
280      * name.
281      */
282     function symbol() public view virtual override returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @dev Returns the number of decimals used to get its user representation.
288      * For example, if `decimals` equals `2`, a balance of `505` tokens should
289      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
290      *
291      * Tokens usually opt for a value of 18, imitating the relationship between
292      * Ether and Wei. This is the value {ERC20} uses, unless this function is
293      * overridden;
294      *
295      * NOTE: This information is only used for _display_ purposes: it in
296      * no way affects any of the arithmetic of the contract, including
297      * {IERC20-balanceOf} and {IERC20-transfer}.
298      */
299     function decimals() public view virtual override returns (uint8) {
300         return 18;
301     }
302 
303     /**
304      * @dev See {IERC20-totalSupply}.
305      */
306     function totalSupply() public view virtual override returns (uint256) {
307         return _totalSupply;
308     }
309 
310     /**
311      * @dev See {IERC20-balanceOf}.
312      */
313     function balanceOf(address account) public view virtual override returns (uint256) {
314         return _balances[account];
315     }
316 
317     /**
318      * @dev See {IERC20-transfer}.
319      *
320      * Requirements:
321      *
322      * - `recipient` cannot be the zero address.
323      * - the caller must have a balance of at least `amount`.
324      */
325     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
326         _transfer(_msgSender(), recipient, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-allowance}.
332      */
333     function allowance(address owner, address spender) public view virtual override returns (uint256) {
334         return _allowances[owner][spender];
335     }
336 
337     /**
338      * @dev See {IERC20-approve}.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function approve(address spender, uint256 amount) public virtual override returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-transferFrom}.
351      *
352      * Emits an {Approval} event indicating the updated allowance. This is not
353      * required by the EIP. See the note at the beginning of {ERC20}.
354      *
355      * Requirements:
356      *
357      * - `sender` and `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      * - the caller must have allowance for ``sender``'s tokens of at least
360      * `amount`.
361      */
362     function transferFrom(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) public virtual override returns (bool) {
367         _transfer(sender, recipient, amount);
368 
369         uint256 currentAllowance = _allowances[sender][_msgSender()];
370         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
371         unchecked {
372             _approve(sender, _msgSender(), currentAllowance - amount);
373         }
374 
375         return true;
376     }
377 
378     /**
379      * @dev Moves `amount` of tokens from `sender` to `recipient`.
380      *
381      * This internal function is equivalent to {transfer}, and can be used to
382      * e.g. implement automatic token fees, slashing mechanisms, etc.
383      *
384      * Emits a {Transfer} event.
385      *
386      * Requirements:
387      *
388      * - `sender` cannot be the zero address.
389      * - `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      */
392     function _transfer(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) internal virtual {
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         _beforeTokenTransfer(sender, recipient, amount);
401 
402         uint256 senderBalance = _balances[sender];
403         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
404         unchecked {
405             _balances[sender] = senderBalance - amount;
406         }
407         _balances[recipient] += amount;
408 
409         emit Transfer(sender, recipient, amount);
410 
411         _afterTokenTransfer(sender, recipient, amount);
412     }
413 
414     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
415      * the total supply.
416      *
417      * Emits a {Transfer} event with `from` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      */
423     function _mint(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: mint to the zero address");
425 
426         _beforeTokenTransfer(address(0), account, amount);
427 
428         _totalSupply += amount;
429         _balances[account] += amount;
430         emit Transfer(address(0), account, amount);
431 
432         _afterTokenTransfer(address(0), account, amount);
433     }
434 
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
438      *
439      * This internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an {Approval} event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(
450         address owner,
451         address spender,
452         uint256 amount
453     ) internal virtual {
454         require(owner != address(0), "ERC20: approve from the zero address");
455         require(spender != address(0), "ERC20: approve to the zero address");
456 
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460 
461     /**
462      * @dev Hook that is called before any transfer of tokens. This includes
463      * minting and burning.
464      *
465      * Calling conditions:
466      *
467      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
468      * will be transferred to `to`.
469      * - when `from` is zero, `amount` tokens will be minted for `to`.
470      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
471      * - `from` and `to` are never both zero.
472      *
473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
474      */
475     function _beforeTokenTransfer(
476         address from,
477         address to,
478         uint256 amount
479     ) internal virtual {}
480 
481     /**
482      * @dev Hook that is called after any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * has been transferred to `to`.
489      * - when `from` is zero, `amount` tokens have been minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _afterTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 }
501 
502 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
503 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
504 
505 /* pragma solidity ^0.8.0; */
506 
507 // CAUTION
508 // This version of SafeMath should only be used with Solidity 0.8 or later,
509 // because it relies on the compiler's built in overflow checks.
510 
511 /**
512  * @dev Wrappers over Solidity's arithmetic operations.
513  *
514  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
515  * now has built in overflow checking.
516  */
517 library SafeMath {
518     /**
519      * @dev Returns the addition of two unsigned integers, with an overflow flag.
520      *
521      * _Available since v3.4._
522      */
523     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
524         unchecked {
525             uint256 c = a + b;
526             if (c < a) return (false, 0);
527             return (true, c);
528         }
529     }
530 
531     /**
532      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
533      *
534      * _Available since v3.4._
535      */
536     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
537         unchecked {
538             if (b > a) return (false, 0);
539             return (true, a - b);
540         }
541     }
542 
543     /**
544      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
545      *
546      * _Available since v3.4._
547      */
548     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
549         unchecked {
550             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
551             // benefit is lost if 'b' is also tested.
552             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
553             if (a == 0) return (true, 0);
554             uint256 c = a * b;
555             if (c / a != b) return (false, 0);
556             return (true, c);
557         }
558     }
559 
560     /**
561      * @dev Returns the division of two unsigned integers, with a division by zero flag.
562      *
563      * _Available since v3.4._
564      */
565     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
566         unchecked {
567             if (b == 0) return (false, 0);
568             return (true, a / b);
569         }
570     }
571 
572     /**
573      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             if (b == 0) return (false, 0);
580             return (true, a % b);
581         }
582     }
583 
584     /**
585      * @dev Returns the addition of two unsigned integers, reverting on
586      * overflow.
587      *
588      * Counterpart to Solidity's `+` operator.
589      *
590      * Requirements:
591      *
592      * - Addition cannot overflow.
593      */
594     function add(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a + b;
596     }
597 
598     /**
599      * @dev Returns the subtraction of two unsigned integers, reverting on
600      * overflow (when the result is negative).
601      *
602      * Counterpart to Solidity's `-` operator.
603      *
604      * Requirements:
605      *
606      * - Subtraction cannot overflow.
607      */
608     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
609         return a - b;
610     }
611 
612     /**
613      * @dev Returns the multiplication of two unsigned integers, reverting on
614      * overflow.
615      *
616      * Counterpart to Solidity's `*` operator.
617      *
618      * Requirements:
619      *
620      * - Multiplication cannot overflow.
621      */
622     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a * b;
624     }
625 
626     /**
627      * @dev Returns the integer division of two unsigned integers, reverting on
628      * division by zero. The result is rounded towards zero.
629      *
630      * Counterpart to Solidity's `/` operator.
631      *
632      * Requirements:
633      *
634      * - The divisor cannot be zero.
635      */
636     function div(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a / b;
638     }
639 
640     /**
641      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
642      * reverting when dividing by zero.
643      *
644      * Counterpart to Solidity's `%` operator. This function uses a `revert`
645      * opcode (which leaves remaining gas untouched) while Solidity uses an
646      * invalid opcode to revert (consuming all remaining gas).
647      *
648      * Requirements:
649      *
650      * - The divisor cannot be zero.
651      */
652     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a % b;
654     }
655 
656     /**
657      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
658      * overflow (when the result is negative).
659      *
660      * CAUTION: This function is deprecated because it requires allocating memory for the error
661      * message unnecessarily. For custom revert reasons use {trySub}.
662      *
663      * Counterpart to Solidity's `-` operator.
664      *
665      * Requirements:
666      *
667      * - Subtraction cannot overflow.
668      */
669     function sub(
670         uint256 a,
671         uint256 b,
672         string memory errorMessage
673     ) internal pure returns (uint256) {
674         unchecked {
675             require(b <= a, errorMessage);
676             return a - b;
677         }
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator. Note: this function uses a
685      * `revert` opcode (which leaves remaining gas untouched) while Solidity
686      * uses an invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function div(
693         uint256 a,
694         uint256 b,
695         string memory errorMessage
696     ) internal pure returns (uint256) {
697         unchecked {
698             require(b > 0, errorMessage);
699             return a / b;
700         }
701     }
702 
703     /**
704      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
705      * reverting with custom message when dividing by zero.
706      *
707      * CAUTION: This function is deprecated because it requires allocating memory for the error
708      * message unnecessarily. For custom revert reasons use {tryMod}.
709      *
710      * Counterpart to Solidity's `%` operator. This function uses a `revert`
711      * opcode (which leaves remaining gas untouched) while Solidity uses an
712      * invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function mod(
719         uint256 a,
720         uint256 b,
721         string memory errorMessage
722     ) internal pure returns (uint256) {
723         unchecked {
724             require(b > 0, errorMessage);
725             return a % b;
726         }
727     }
728 }
729 
730 interface IUniswapV2Factory {
731     event PairCreated(
732         address indexed token0,
733         address indexed token1,
734         address pair,
735         uint256
736     );
737 
738     function createPair(address tokenA, address tokenB)
739         external
740         returns (address pair);
741 }
742 
743 interface IUniswapV2Router02 {
744     function factory() external pure returns (address);
745 
746     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
747         uint256 amountIn,
748         uint256 amountOutMin,
749         address[] calldata path,
750         address to,
751         uint256 deadline
752     ) external;
753 }
754 
755 contract Kamoku is ERC20, Ownable {
756     using SafeMath for uint256;
757 
758     IUniswapV2Router02 public immutable uniswapV2Router;
759     address public immutable uniswapV2Pair;
760     address public constant deadAddress = address(0xdead);
761     address public ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
762 
763     bool private swapping;
764 
765     address public devWallet;
766 
767     uint256 public maxTransactionAmount;
768     uint256 public swapTokensAtAmount;
769     uint256 public maxWallet;
770 
771     bool public limitsInEffect = true;
772     bool public tradingActive = false;
773     bool public swapEnabled = false;
774 
775     uint256 public buyTotalFees;
776     uint256 public buyDevFee;
777     uint256 public buyLiquidityFee;
778 
779     uint256 public sellTotalFees;
780     uint256 public sellDevFee;
781     uint256 public sellLiquidityFee;
782 
783     /******************/
784 
785     // exlcude from fees and max transaction amount
786     mapping(address => bool) private _isExcludedFromFees;
787     mapping(address => bool) public _isExcludedMaxTransactionAmount;
788 
789 
790     event ExcludeFromFees(address indexed account, bool isExcluded);
791 
792     event devWalletUpdated(
793         address indexed newWallet,
794         address indexed oldWallet
795     );
796 
797     constructor() ERC20("Hassuru", "Kamoku") {
798         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
799             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
800         );
801 
802         excludeFromMaxTransaction(address(_uniswapV2Router), true);
803         uniswapV2Router = _uniswapV2Router;
804 
805         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
806             .createPair(address(this), ETH);
807         excludeFromMaxTransaction(address(uniswapV2Pair), true);
808 
809 
810         uint256 _buyDevFee = 15;
811         uint256 _buyLiquidityFee = 0;
812 
813         uint256 _sellDevFee = 15;
814         uint256 _sellLiquidityFee = 0;
815 
816         uint256 totalSupply = 109_876_543_210 * 1e18;
817 
818         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
819         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
820         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
821 
822         buyDevFee = _buyDevFee;
823         buyLiquidityFee = _buyLiquidityFee;
824         buyTotalFees = buyDevFee + buyLiquidityFee;
825 
826         sellDevFee = _sellDevFee;
827         sellLiquidityFee = _sellLiquidityFee;
828         sellTotalFees = sellDevFee + sellLiquidityFee;
829 
830         devWallet = address(0x87a607Aa7C3e86e6E75A4a3691E3cd9cbe399B5d); 
831 
832         // exclude from paying fees or having max transaction amount
833         excludeFromFees(owner(), true);
834         excludeFromFees(address(this), true);
835         excludeFromFees(address(0xdead), true);
836         excludeFromFees(address(0x87a607Aa7C3e86e6E75A4a3691E3cd9cbe399B5d), true);
837         excludeFromFees(address(0x930f9b1448305eC41BcB4a5efBE1D39eD25b23d0), true);
838         excludeFromFees(address(0x930f9b1448305eC41BcB4a5efBE1D39eD25b23d0), true);
839 
840 
841         excludeFromMaxTransaction(owner(), true);
842         excludeFromMaxTransaction(address(this), true);
843         excludeFromMaxTransaction(address(0xdead), true);
844 
845         /*
846             _mint is an internal function in ERC20.sol that is only called here,
847             and CANNOT be called ever again
848         */
849         _mint(msg.sender, totalSupply);
850     }
851 
852     receive() external payable {}
853 
854     // once enabled, can never be turned off
855     function enableTrading() external onlyOwner {
856         tradingActive = true;
857         swapEnabled = true;
858     }
859 
860     // remove limits after token is stable
861     function removeLimits() external onlyOwner returns (bool) {
862         limitsInEffect = false;
863         return true;
864     }
865 
866     // change the minimum amount of tokens to sell from fees
867     function updateSwapTokensAtAmount(uint256 newAmount)
868         external
869         onlyOwner
870         returns (bool)
871     {
872         require(
873             newAmount >= (totalSupply() * 1) / 100000,
874             "Swap amount cannot be lower than 0.001% total supply."
875         );
876         require(
877             newAmount <= (totalSupply() * 5) / 1000,
878             "Swap amount cannot be higher than 0.5% total supply."
879         );
880         swapTokensAtAmount = newAmount;
881         return true;
882     }
883 
884     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
885         require(
886             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
887             "Cannot set maxTransactionAmount lower than 0.1%"
888         );
889         maxTransactionAmount = newNum * (10**18);
890     }
891 
892     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
893         require(
894             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
895             "Cannot set maxWallet lower than 0.5%"
896         );
897         maxWallet = newNum * (10**18);
898     }
899 
900     function excludeFromMaxTransaction(address updAds, bool isEx)
901         public
902         onlyOwner
903     {
904         _isExcludedMaxTransactionAmount[updAds] = isEx;
905     }
906 
907     // only use to disable contract sales if absolutely necessary (emergency use only)
908     function updateSwapEnabled(bool enabled) external onlyOwner {
909         swapEnabled = enabled;
910     }
911 
912     function updateBuyFees(
913         uint256 _devFee,
914         uint256 _liquidityFee
915     ) external onlyOwner {
916         buyDevFee = _devFee;
917         buyLiquidityFee = _liquidityFee;
918         buyTotalFees = buyDevFee + buyLiquidityFee;
919         require(buyTotalFees <= 45, "Must keep fees at 49% or less ;)" );
920     }
921 
922     function updateSellFees(
923         uint256 _devFee,
924         uint256 _liquidityFee
925     ) external onlyOwner {
926         sellDevFee = _devFee;
927         sellLiquidityFee = _liquidityFee;
928         sellTotalFees = sellDevFee + sellLiquidityFee;
929         require(sellTotalFees <= 45, "Must keep fees at 30% or less ;)");
930     }
931 
932     function excludeFromFees(address account, bool excluded) public onlyOwner {
933         _isExcludedFromFees[account] = excluded;
934         emit ExcludeFromFees(account, excluded);
935     }
936 
937     function updateDevWallet(address newDevWallet)
938         external
939         onlyOwner
940     {
941         emit devWalletUpdated(newDevWallet, devWallet);
942         devWallet = newDevWallet;
943     }
944 
945 
946     function isExcludedFromFees(address account) public view returns (bool) {
947         return _isExcludedFromFees[account];
948     }
949 
950     function _transfer(
951         address from,
952         address to,
953         uint256 amount
954     ) internal override {
955         require(from != address(0), "ERC20: transfer from the zero address");
956         require(to != address(0), "ERC20: transfer to the zero address");
957 
958         if (amount == 0) {
959             super._transfer(from, to, 0);
960             return;
961         }
962 
963         if (limitsInEffect) {
964             if (
965                 from != owner() &&
966                 to != owner() &&
967                 to != address(0) &&
968                 to != address(0xdead) &&
969                 !swapping
970             ) {
971                 if (!tradingActive) {
972                     require(
973                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
974                         "Trading is not active."
975                     );
976                 }
977 
978                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
979                 //when buy
980                 if (
981                     from == uniswapV2Pair &&
982                     !_isExcludedMaxTransactionAmount[to]
983                 ) {
984                     require(
985                         amount <= maxTransactionAmount,
986                         "Buy transfer amount exceeds the maxTransactionAmount."
987                     );
988                     require(
989                         amount + balanceOf(to) <= maxWallet,
990                         "Max wallet exceeded"
991                     );
992                 }
993                 else if (!_isExcludedMaxTransactionAmount[to]) {
994                     require(
995                         amount + balanceOf(to) <= maxWallet,
996                         "Max wallet exceeded"
997                     );
998                 }
999             }
1000         }
1001 
1002         uint256 contractTokenBalance = balanceOf(address(this));
1003 
1004         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1005 
1006         if (
1007             canSwap &&
1008             swapEnabled &&
1009             !swapping &&
1010             to == uniswapV2Pair &&
1011             !_isExcludedFromFees[from] &&
1012             !_isExcludedFromFees[to]
1013         ) {
1014             swapping = true;
1015 
1016             swapBack();
1017 
1018             swapping = false;
1019         }
1020 
1021         bool takeFee = !swapping;
1022 
1023         // if any account belongs to _isExcludedFromFee account then remove the fee
1024         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1025             takeFee = false;
1026         }
1027 
1028         uint256 fees = 0;
1029         uint256 tokensForLiquidity = 0;
1030         uint256 tokensForDev = 0;
1031         // only take fees on buys/sells, do not take on wallet transfers
1032         if (takeFee) {
1033             // on sell
1034             if (to == uniswapV2Pair && sellTotalFees > 0) {
1035                 fees = amount.mul(sellTotalFees).div(100);
1036                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1037                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1038             }
1039             // on buy
1040             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1041                 fees = amount.mul(buyTotalFees).div(100);
1042                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1043                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1044             }
1045 
1046             if (fees> 0) {
1047                 super._transfer(from, address(this), fees);
1048             }
1049             if (tokensForLiquidity > 0) {
1050                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1051             }
1052 
1053             amount -= fees;
1054         }
1055 
1056         super._transfer(from, to, amount);
1057     }
1058 
1059     function swapTokensForETH(uint256 tokenAmount) private {
1060         // generate the uniswap pair path of token -> weth
1061         address[] memory path = new address[](2);
1062         path[0] = address(this);
1063         path[1] = ETH;
1064 
1065         _approve(address(this), address(uniswapV2Router), tokenAmount);
1066 
1067         // make the swap
1068         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1069             tokenAmount,
1070             0, // accept any amount of ETH
1071             path,
1072             devWallet,
1073             block.timestamp
1074         );
1075     }
1076 
1077     function swapBack() private {
1078         uint256 contractBalance = balanceOf(address(this));
1079         if (contractBalance == 0) {
1080             return;
1081         }
1082 
1083         if (contractBalance > swapTokensAtAmount * 20) {
1084             contractBalance = swapTokensAtAmount * 20;
1085         }
1086 
1087         swapTokensForETH(contractBalance);
1088     }
1089 
1090 }