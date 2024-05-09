1 // SPDX-License-Identifier: MIT
2 
3 // Website: https://worldcupfrens.com/
4 // Medium: https://medium.com/@worldcupfrens
5 // TG: https://t.me/WorldCupFrens
6 
7 pragma solidity ^0.8.10;
8 pragma experimental ABIEncoderV2;
9 
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 /* pragma solidity ^0.8.0; */
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
36 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
37 
38 /* pragma solidity ^0.8.0; */
39 
40 /* import "../utils/Context.sol"; */
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
113 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
114 
115 /* pragma solidity ^0.8.0; */
116 
117 /**
118  * @dev Interface of the ERC20 standard as defined in the EIP.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
196 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
197 
198 /* pragma solidity ^0.8.0; */
199 
200 /* import "../IERC20.sol"; */
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
225 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
226 
227 /* pragma solidity ^0.8.0; */
228 
229 /* import "./IERC20.sol"; */
230 /* import "./extensions/IERC20Metadata.sol"; */
231 /* import "../../utils/Context.sol"; */
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Moves `amount` of tokens from `sender` to `recipient`.
391      *
392      * This internal function is equivalent to {transfer}, and can be used to
393      * e.g. implement automatic token fees, slashing mechanisms, etc.
394      *
395      * Emits a {Transfer} event.
396      *
397      * Requirements:
398      *
399      * - `sender` cannot be the zero address.
400      * - `recipient` cannot be the zero address.
401      * - `sender` must have a balance of at least `amount`.
402      */
403     function _transfer(
404         address sender,
405         address recipient,
406         uint256 amount
407     ) internal virtual {
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411         _beforeTokenTransfer(sender, recipient, amount);
412 
413         uint256 senderBalance = _balances[sender];
414         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
415         unchecked {
416             _balances[sender] = senderBalance - amount;
417         }
418         _balances[recipient] += amount;
419 
420         emit Transfer(sender, recipient, amount);
421 
422         _afterTokenTransfer(sender, recipient, amount);
423     }
424 
425     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
426      * the total supply.
427      *
428      * Emits a {Transfer} event with `from` set to the zero address.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      */
434     function _mint(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: mint to the zero address");
436 
437         _beforeTokenTransfer(address(0), account, amount);
438 
439         _totalSupply += amount;
440         _balances[account] += amount;
441         emit Transfer(address(0), account, amount);
442 
443         _afterTokenTransfer(address(0), account, amount);
444     }
445 
446 
447     /**
448      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
449      *
450      * This internal function is equivalent to `approve`, and can be used to
451      * e.g. set automatic allowances for certain subsystems, etc.
452      *
453      * Emits an {Approval} event.
454      *
455      * Requirements:
456      *
457      * - `owner` cannot be the zero address.
458      * - `spender` cannot be the zero address.
459      */
460     function _approve(
461         address owner,
462         address spender,
463         uint256 amount
464     ) internal virtual {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Hook that is called before any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * will be transferred to `to`.
480      * - when `from` is zero, `amount` tokens will be minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _beforeTokenTransfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {}
491 
492     /**
493      * @dev Hook that is called after any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * has been transferred to `to`.
500      * - when `from` is zero, `amount` tokens have been minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _afterTokenTransfer(
507         address from,
508         address to,
509         uint256 amount
510     ) internal virtual {}
511 }
512 
513 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
514 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
515 
516 /* pragma solidity ^0.8.0; */
517 
518 // CAUTION
519 // This version of SafeMath should only be used with Solidity 0.8 or later,
520 // because it relies on the compiler's built in overflow checks.
521 
522 /**
523  * @dev Wrappers over Solidity's arithmetic operations.
524  *
525  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
526  * now has built in overflow checking.
527  */
528 library SafeMath {
529     /**
530      * @dev Returns the addition of two unsigned integers, with an overflow flag.
531      *
532      * _Available since v3.4._
533      */
534     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
535         unchecked {
536             uint256 c = a + b;
537             if (c < a) return (false, 0);
538             return (true, c);
539         }
540     }
541 
542     /**
543      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
544      *
545      * _Available since v3.4._
546      */
547     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
548         unchecked {
549             if (b > a) return (false, 0);
550             return (true, a - b);
551         }
552     }
553 
554     /**
555      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
556      *
557      * _Available since v3.4._
558      */
559     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
560         unchecked {
561             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
562             // benefit is lost if 'b' is also tested.
563             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
564             if (a == 0) return (true, 0);
565             uint256 c = a * b;
566             if (c / a != b) return (false, 0);
567             return (true, c);
568         }
569     }
570 
571     /**
572      * @dev Returns the division of two unsigned integers, with a division by zero flag.
573      *
574      * _Available since v3.4._
575      */
576     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
577         unchecked {
578             if (b == 0) return (false, 0);
579             return (true, a / b);
580         }
581     }
582 
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
585      *
586      * _Available since v3.4._
587      */
588     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         unchecked {
590             if (b == 0) return (false, 0);
591             return (true, a % b);
592         }
593     }
594 
595     /**
596      * @dev Returns the addition of two unsigned integers, reverting on
597      * overflow.
598      *
599      * Counterpart to Solidity's `+` operator.
600      *
601      * Requirements:
602      *
603      * - Addition cannot overflow.
604      */
605     function add(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a + b;
607     }
608 
609     /**
610      * @dev Returns the subtraction of two unsigned integers, reverting on
611      * overflow (when the result is negative).
612      *
613      * Counterpart to Solidity's `-` operator.
614      *
615      * Requirements:
616      *
617      * - Subtraction cannot overflow.
618      */
619     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
620         return a - b;
621     }
622 
623     /**
624      * @dev Returns the multiplication of two unsigned integers, reverting on
625      * overflow.
626      *
627      * Counterpart to Solidity's `*` operator.
628      *
629      * Requirements:
630      *
631      * - Multiplication cannot overflow.
632      */
633     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a * b;
635     }
636 
637     /**
638      * @dev Returns the integer division of two unsigned integers, reverting on
639      * division by zero. The result is rounded towards zero.
640      *
641      * Counterpart to Solidity's `/` operator.
642      *
643      * Requirements:
644      *
645      * - The divisor cannot be zero.
646      */
647     function div(uint256 a, uint256 b) internal pure returns (uint256) {
648         return a / b;
649     }
650 
651     /**
652      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
653      * reverting when dividing by zero.
654      *
655      * Counterpart to Solidity's `%` operator. This function uses a `revert`
656      * opcode (which leaves remaining gas untouched) while Solidity uses an
657      * invalid opcode to revert (consuming all remaining gas).
658      *
659      * Requirements:
660      *
661      * - The divisor cannot be zero.
662      */
663     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
664         return a % b;
665     }
666 
667     /**
668      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
669      * overflow (when the result is negative).
670      *
671      * CAUTION: This function is deprecated because it requires allocating memory for the error
672      * message unnecessarily. For custom revert reasons use {trySub}.
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      *
678      * - Subtraction cannot overflow.
679      */
680     function sub(
681         uint256 a,
682         uint256 b,
683         string memory errorMessage
684     ) internal pure returns (uint256) {
685         unchecked {
686             require(b <= a, errorMessage);
687             return a - b;
688         }
689     }
690 
691     /**
692      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
693      * division by zero. The result is rounded towards zero.
694      *
695      * Counterpart to Solidity's `/` operator. Note: this function uses a
696      * `revert` opcode (which leaves remaining gas untouched) while Solidity
697      * uses an invalid opcode to revert (consuming all remaining gas).
698      *
699      * Requirements:
700      *
701      * - The divisor cannot be zero.
702      */
703     function div(
704         uint256 a,
705         uint256 b,
706         string memory errorMessage
707     ) internal pure returns (uint256) {
708         unchecked {
709             require(b > 0, errorMessage);
710             return a / b;
711         }
712     }
713 
714     /**
715      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
716      * reverting with custom message when dividing by zero.
717      *
718      * CAUTION: This function is deprecated because it requires allocating memory for the error
719      * message unnecessarily. For custom revert reasons use {tryMod}.
720      *
721      * Counterpart to Solidity's `%` operator. This function uses a `revert`
722      * opcode (which leaves remaining gas untouched) while Solidity uses an
723      * invalid opcode to revert (consuming all remaining gas).
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function mod(
730         uint256 a,
731         uint256 b,
732         string memory errorMessage
733     ) internal pure returns (uint256) {
734         unchecked {
735             require(b > 0, errorMessage);
736             return a % b;
737         }
738     }
739 }
740 
741 interface IUniswapV2Factory {
742     event PairCreated(
743         address indexed token0,
744         address indexed token1,
745         address pair,
746         uint256
747     );
748 
749     function createPair(address tokenA, address tokenB)
750         external
751         returns (address pair);
752 }
753 
754 interface IUniswapV2Router02 {
755     function factory() external pure returns (address);
756 
757     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
758         uint256 amountIn,
759         uint256 amountOutMin,
760         address[] calldata path,
761         address to,
762         uint256 deadline
763     ) external;
764 }
765 
766 contract WCF is ERC20, Ownable {
767     using SafeMath for uint256;
768 
769     IUniswapV2Router02 public immutable uniswapV2Router;
770     address public immutable uniswapV2Pair;
771     address public constant deadAddress = address(0xdead);
772     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; 
773     bool private swapping;
774 
775     address public devWallet;
776 
777     uint256 public maxTransactionAmount;
778     uint256 public swapTokensAtAmount;
779     uint256 public maxWallet;
780 
781     bool public limitsInEffect = true;
782     bool public tradingActive = false;
783     bool public swapEnabled = false;
784 
785     uint256 public buyTotalFees;
786     uint256 public buyDevFee;
787     uint256 public buyLiquidityFee;
788 
789     uint256 public sellTotalFees;
790     uint256 public sellDevFee;
791     uint256 public sellLiquidityFee;
792 
793     /******************/
794 
795     // exlcude from fees and max transaction amount
796     mapping(address => bool) private _isExcludedFromFees;
797     mapping(address => bool) public _isExcludedMaxTransactionAmount;
798 
799 
800     event ExcludeFromFees(address indexed account, bool isExcluded);
801 
802     event devWalletUpdated(
803         address indexed newWallet,
804         address indexed oldWallet
805     );
806 
807     constructor() ERC20("WORLDCUPFRENS", "WCF") {
808         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
809             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
810         );
811 
812         excludeFromMaxTransaction(address(_uniswapV2Router), true);
813         uniswapV2Router = _uniswapV2Router;
814 
815         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
816             .createPair(address(this), USDC);
817         excludeFromMaxTransaction(address(uniswapV2Pair), true);
818 
819 
820         uint256 _buyDevFee = 4;
821         uint256 _buyLiquidityFee = 3;
822 
823         uint256 _sellDevFee = 4;
824         uint256 _sellLiquidityFee = 3;
825 
826         uint256 totalSupply = 1_000_000_000_000_000 * 1e18;
827 
828         maxTransactionAmount =  totalSupply * 1 / 100; // maxTransactionAmountTxn
829         maxWallet = totalSupply * 1 / 100; // maxWallet
830         swapTokensAtAmount = (totalSupply * 5) / 10000; // swapamount
831 
832         buyDevFee = _buyDevFee;
833         buyLiquidityFee = _buyLiquidityFee;
834         buyTotalFees = buyDevFee + buyLiquidityFee;
835 
836         sellDevFee = _sellDevFee;
837         sellLiquidityFee = _sellLiquidityFee;
838         sellTotalFees = sellDevFee + sellLiquidityFee;
839 
840         devWallet = address(0x3FAceb24FB55132e7606485249A2193c3B803509);
841 
842         // exclude from paying fees or having max transaction amount
843         excludeFromFees(owner(), true);
844         excludeFromFees(address(this), true);
845         excludeFromFees(address(0xdead), true);
846 
847         excludeFromMaxTransaction(owner(), true);
848         excludeFromMaxTransaction(address(this), true);
849         excludeFromMaxTransaction(address(0xdead), true);
850 
851         /*
852             _mint is an internal function in ERC20.sol that is only called here,
853             and CANNOT be called ever again
854         */
855         _mint(msg.sender, totalSupply);
856     }
857 
858     receive() external payable {}
859 
860     // once enabled, can never be turned off
861     function enableTrading() external onlyOwner {
862         tradingActive = true;
863         swapEnabled = true;
864     }
865 
866     // remove limits after token is stable
867     function removeLimits() external onlyOwner returns (bool) {
868         limitsInEffect = false;
869         return true;
870     }
871 
872     // change the minimum amount of tokens to sell from fees
873     function updateSwapTokensAtAmount(uint256 newAmount)
874         external
875         onlyOwner
876         returns (bool)
877     {
878         require(
879             newAmount >= (totalSupply() * 1) / 100000,
880             "Swap amount cannot be lower than 0.001% total supply."
881         );
882         require(
883             newAmount <= (totalSupply() * 5) / 1000,
884             "Swap amount cannot be higher than 0.5% total supply."
885         );
886         swapTokensAtAmount = newAmount;
887         return true;
888     }
889 
890     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
891         require(
892             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
893             "Cannot set maxTransactionAmount lower than 0.1%"
894         );
895         maxTransactionAmount = newNum * (10**18);
896     }
897 
898     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
899         require(
900             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
901             "Cannot set maxWallet lower than 0.5%"
902         );
903         maxWallet = newNum * (10**18);
904     }
905 
906     function excludeFromMaxTransaction(address updAds, bool isEx)
907         public
908         onlyOwner
909     {
910         _isExcludedMaxTransactionAmount[updAds] = isEx;
911     }
912 
913     // only use to disable contract sales if absolutely necessary (emergency use only)
914     function updateSwapEnabled(bool enabled) external onlyOwner {
915         swapEnabled = enabled;
916     }
917 
918     function updateBuyFees(
919         uint256 _devFee,
920         uint256 _liquidityFee
921     ) external onlyOwner {
922         buyDevFee = _devFee;
923         buyLiquidityFee = _liquidityFee;
924         buyTotalFees = buyDevFee + buyLiquidityFee;
925         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
926     }
927 
928     function updateSellFees(
929         uint256 _devFee,
930         uint256 _liquidityFee
931     ) external onlyOwner {
932         sellDevFee = _devFee;
933         sellLiquidityFee = _liquidityFee;
934         sellTotalFees = sellDevFee + sellLiquidityFee;
935         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
936     }
937 
938     function excludeFromFees(address account, bool excluded) public onlyOwner {
939         _isExcludedFromFees[account] = excluded;
940         emit ExcludeFromFees(account, excluded);
941     }
942 
943     function updateDevWallet(address newDevWallet)
944         external
945         onlyOwner
946     {
947         emit devWalletUpdated(newDevWallet, devWallet);
948         devWallet = newDevWallet;
949     }
950 
951 
952     function isExcludedFromFees(address account) public view returns (bool) {
953         return _isExcludedFromFees[account];
954     }
955 
956     function _transfer(
957         address from,
958         address to,
959         uint256 amount
960     ) internal override {
961         require(from != address(0), "ERC20: transfer from the zero address");
962         require(to != address(0), "ERC20: transfer to the zero address");
963 
964         if (amount == 0) {
965             super._transfer(from, to, 0);
966             return;
967         }
968 
969         if (limitsInEffect) {
970             if (
971                 from != owner() &&
972                 to != owner() &&
973                 to != address(0) &&
974                 to != address(0xdead) &&
975                 !swapping
976             ) {
977                 if (!tradingActive) {
978                     require(
979                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
980                         "Trading is not active."
981                     );
982                 }
983 
984                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
985                 //when buy
986                 if (
987                     from == uniswapV2Pair &&
988                     !_isExcludedMaxTransactionAmount[to]
989                 ) {
990                     require(
991                         amount <= maxTransactionAmount,
992                         "Buy transfer amount exceeds the maxTransactionAmount."
993                     );
994                     require(
995                         amount + balanceOf(to) <= maxWallet,
996                         "Max wallet exceeded"
997                     );
998                 }
999                 else if (!_isExcludedMaxTransactionAmount[to]) {
1000                     require(
1001                         amount + balanceOf(to) <= maxWallet,
1002                         "Max wallet exceeded"
1003                     );
1004                 }
1005             }
1006         }
1007 
1008         uint256 contractTokenBalance = balanceOf(address(this));
1009 
1010         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1011 
1012         if (
1013             canSwap &&
1014             swapEnabled &&
1015             !swapping &&
1016             to == uniswapV2Pair &&
1017             !_isExcludedFromFees[from] &&
1018             !_isExcludedFromFees[to]
1019         ) {
1020             swapping = true;
1021 
1022             swapBack();
1023 
1024             swapping = false;
1025         }
1026 
1027         bool takeFee = !swapping;
1028 
1029         // if any account belongs to _isExcludedFromFee account then remove the fee
1030         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1031             takeFee = false;
1032         }
1033 
1034         uint256 fees = 0;
1035         uint256 tokensForLiquidity = 0;
1036         uint256 tokensForDev = 0;
1037         // only take fees on buys/sells, do not take on wallet transfers
1038         if (takeFee) {
1039             // on sell
1040             if (to == uniswapV2Pair && sellTotalFees > 0) {
1041                 fees = amount.mul(sellTotalFees).div(100);
1042                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1043                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1044             }
1045             // on buy
1046             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1047                 fees = amount.mul(buyTotalFees).div(100);
1048                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1049                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1050             }
1051 
1052             if (fees> 0) {
1053                 super._transfer(from, address(this), fees);
1054             }
1055             if (tokensForLiquidity > 0) {
1056                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1057             }
1058 
1059             amount -= fees;
1060         }
1061 
1062         super._transfer(from, to, amount);
1063     }
1064 
1065     function swapTokensForUSDC(uint256 tokenAmount) private {
1066         // generate the uniswap pair path of token -> weth
1067         address[] memory path = new address[](2);
1068         path[0] = address(this);
1069         path[1] = USDC;
1070 
1071         _approve(address(this), address(uniswapV2Router), tokenAmount);
1072 
1073         // make the swap
1074         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1075             tokenAmount,
1076             0, // accept any amount of USDC
1077             path,
1078             devWallet,
1079             block.timestamp
1080         );
1081     }
1082 
1083     function swapBack() private {
1084         uint256 contractBalance = balanceOf(address(this));
1085         if (contractBalance == 0) {
1086             return;
1087         }
1088 
1089         if (contractBalance > swapTokensAtAmount * 20) {
1090             contractBalance = swapTokensAtAmount * 20;
1091         }
1092 
1093         swapTokensForUSDC(contractBalance);
1094     }
1095 
1096 }