1 // SPDX-License-Identifier: MIT
2 
3 /** Telegram : https://t.me/ZeroXAutoPortal
4 Website : https://0xAuto.io
5 Twitter : https://twitter.com/0xAutoERC
6 Medium : https://medium.com/@0xAutoBot/introducing-0xswift-bot-the-fastest-token-deployer-for-uniswap-v2-and-beyond-72ec3f169ef
7 **/
8 pragma solidity ^0.8.10;
9 pragma experimental ABIEncoderV2;
10 
11 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
12 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
13 
14 /* pragma solidity ^0.8.0; */
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
37 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
38 
39 /* pragma solidity ^0.8.0; */
40 
41 /* import "../utils/Context.sol"; */
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
114 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
115 
116 /* pragma solidity ^0.8.0; */
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
197 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 /* pragma solidity ^0.8.0; */
200 
201 /* import "../IERC20.sol"; */
202 
203 /**
204  * @dev Interface for the optional metadata functions from the ERC20 standard.
205  *
206  * _Available since v4.1._
207  */
208 interface IERC20Metadata is IERC20 {
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the symbol of the token.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the decimals places of the token.
221      */
222     function decimals() external view returns (uint8);
223 }
224 
225 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
227 
228 /* pragma solidity ^0.8.0; */
229 
230 /* import "./IERC20.sol"; */
231 /* import "./extensions/IERC20Metadata.sol"; */
232 /* import "../../utils/Context.sol"; */
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * We have followed general OpenZeppelin Contracts guidelines: functions revert
246  * instead returning `false` on failure. This behavior is nonetheless
247  * conventional and does not conflict with the expectations of ERC20
248  * applications.
249  *
250  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See {IERC20-approve}.
258  */
259 contract ERC20 is Context, IERC20, IERC20Metadata {
260     mapping(address => uint256) private _balances;
261 
262     mapping(address => mapping(address => uint256)) private _allowances;
263 
264     uint256 private _totalSupply;
265 
266     string private _name;
267     string private _symbol;
268 
269     /**
270      * @dev Sets the values for {name} and {symbol}.
271      *
272      * The default value of {decimals} is 18. To select a different value for
273      * {decimals} you should overload it.
274      *
275      * All two of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name_, string memory symbol_) {
279         _name = name_;
280         _symbol = symbol_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view virtual override returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei. This is the value {ERC20} uses, unless this function is
305      * overridden;
306      *
307      * NOTE: This information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * {IERC20-balanceOf} and {IERC20-transfer}.
310      */
311     function decimals() public view virtual override returns (uint8) {
312         return 18;
313     }
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view virtual override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view virtual override returns (uint256) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `recipient` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
338         _transfer(_msgSender(), recipient, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-allowance}.
344      */
345     function allowance(address owner, address spender) public view virtual override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     /**
350      * @dev See {IERC20-approve}.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function approve(address spender, uint256 amount) public virtual override returns (bool) {
357         _approve(_msgSender(), spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20}.
366      *
367      * Requirements:
368      *
369      * - `sender` and `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      * - the caller must have allowance for ``sender``'s tokens of at least
372      * `amount`.
373      */
374     function transferFrom(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) public virtual override returns (bool) {
379         _transfer(sender, recipient, amount);
380 
381         uint256 currentAllowance = _allowances[sender][_msgSender()];
382         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
383         unchecked {
384             _approve(sender, _msgSender(), currentAllowance - amount);
385         }
386 
387         return true;
388     }
389 
390     /**
391      * @dev Moves `amount` of tokens from `sender` to `recipient`.
392      *
393      * This internal function is equivalent to {transfer}, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a {Transfer} event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(
405         address sender,
406         address recipient,
407         uint256 amount
408     ) internal virtual {
409         require(sender != address(0), "ERC20: transfer from the zero address");
410         require(recipient != address(0), "ERC20: transfer to the zero address");
411 
412         _beforeTokenTransfer(sender, recipient, amount);
413 
414         uint256 senderBalance = _balances[sender];
415         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
416         unchecked {
417             _balances[sender] = senderBalance - amount;
418         }
419         _balances[recipient] += amount;
420 
421         emit Transfer(sender, recipient, amount);
422 
423         _afterTokenTransfer(sender, recipient, amount);
424     }
425 
426     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
427      * the total supply.
428      *
429      * Emits a {Transfer} event with `from` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      */
435     function _mint(address account, uint256 amount) internal virtual {
436         require(account != address(0), "ERC20: mint to the zero address");
437 
438         _beforeTokenTransfer(address(0), account, amount);
439 
440         _totalSupply += amount;
441         _balances[account] += amount;
442         emit Transfer(address(0), account, amount);
443 
444         _afterTokenTransfer(address(0), account, amount);
445     }
446 
447 
448     /**
449      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
450      *
451      * This internal function is equivalent to `approve`, and can be used to
452      * e.g. set automatic allowances for certain subsystems, etc.
453      *
454      * Emits an {Approval} event.
455      *
456      * Requirements:
457      *
458      * - `owner` cannot be the zero address.
459      * - `spender` cannot be the zero address.
460      */
461     function _approve(
462         address owner,
463         address spender,
464         uint256 amount
465     ) internal virtual {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     /**
474      * @dev Hook that is called before any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * will be transferred to `to`.
481      * - when `from` is zero, `amount` tokens will be minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _beforeTokenTransfer(
488         address from,
489         address to,
490         uint256 amount
491     ) internal virtual {}
492 
493     /**
494      * @dev Hook that is called after any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * has been transferred to `to`.
501      * - when `from` is zero, `amount` tokens have been minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _afterTokenTransfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {}
512 }
513 
514 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
515 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
516 
517 /* pragma solidity ^0.8.0; */
518 
519 // CAUTION
520 // This version of SafeMath should only be used with Solidity 0.8 or later,
521 // because it relies on the compiler's built in overflow checks.
522 
523 /**
524  * @dev Wrappers over Solidity's arithmetic operations.
525  *
526  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
527  * now has built in overflow checking.
528  */
529 library SafeMath {
530     /**
531      * @dev Returns the addition of two unsigned integers, with an overflow flag.
532      *
533      * _Available since v3.4._
534      */
535     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
536         unchecked {
537             uint256 c = a + b;
538             if (c < a) return (false, 0);
539             return (true, c);
540         }
541     }
542 
543     /**
544      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
545      *
546      * _Available since v3.4._
547      */
548     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
549         unchecked {
550             if (b > a) return (false, 0);
551             return (true, a - b);
552         }
553     }
554 
555     /**
556      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
557      *
558      * _Available since v3.4._
559      */
560     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
561         unchecked {
562             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
563             // benefit is lost if 'b' is also tested.
564             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
565             if (a == 0) return (true, 0);
566             uint256 c = a * b;
567             if (c / a != b) return (false, 0);
568             return (true, c);
569         }
570     }
571 
572     /**
573      * @dev Returns the division of two unsigned integers, with a division by zero flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             if (b == 0) return (false, 0);
580             return (true, a / b);
581         }
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
586      *
587      * _Available since v3.4._
588      */
589     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
590         unchecked {
591             if (b == 0) return (false, 0);
592             return (true, a % b);
593         }
594     }
595 
596     /**
597      * @dev Returns the addition of two unsigned integers, reverting on
598      * overflow.
599      *
600      * Counterpart to Solidity's `+` operator.
601      *
602      * Requirements:
603      *
604      * - Addition cannot overflow.
605      */
606     function add(uint256 a, uint256 b) internal pure returns (uint256) {
607         return a + b;
608     }
609 
610     /**
611      * @dev Returns the subtraction of two unsigned integers, reverting on
612      * overflow (when the result is negative).
613      *
614      * Counterpart to Solidity's `-` operator.
615      *
616      * Requirements:
617      *
618      * - Subtraction cannot overflow.
619      */
620     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
621         return a - b;
622     }
623 
624     /**
625      * @dev Returns the multiplication of two unsigned integers, reverting on
626      * overflow.
627      *
628      * Counterpart to Solidity's `*` operator.
629      *
630      * Requirements:
631      *
632      * - Multiplication cannot overflow.
633      */
634     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
635         return a * b;
636     }
637 
638     /**
639      * @dev Returns the integer division of two unsigned integers, reverting on
640      * division by zero. The result is rounded towards zero.
641      *
642      * Counterpart to Solidity's `/` operator.
643      *
644      * Requirements:
645      *
646      * - The divisor cannot be zero.
647      */
648     function div(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a / b;
650     }
651 
652     /**
653      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
654      * reverting when dividing by zero.
655      *
656      * Counterpart to Solidity's `%` operator. This function uses a `revert`
657      * opcode (which leaves remaining gas untouched) while Solidity uses an
658      * invalid opcode to revert (consuming all remaining gas).
659      *
660      * Requirements:
661      *
662      * - The divisor cannot be zero.
663      */
664     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a % b;
666     }
667 
668     /**
669      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
670      * overflow (when the result is negative).
671      *
672      * CAUTION: This function is deprecated because it requires allocating memory for the error
673      * message unnecessarily. For custom revert reasons use {trySub}.
674      *
675      * Counterpart to Solidity's `-` operator.
676      *
677      * Requirements:
678      *
679      * - Subtraction cannot overflow.
680      */
681     function sub(
682         uint256 a,
683         uint256 b,
684         string memory errorMessage
685     ) internal pure returns (uint256) {
686         unchecked {
687             require(b <= a, errorMessage);
688             return a - b;
689         }
690     }
691 
692     /**
693      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
694      * division by zero. The result is rounded towards zero.
695      *
696      * Counterpart to Solidity's `/` operator. Note: this function uses a
697      * `revert` opcode (which leaves remaining gas untouched) while Solidity
698      * uses an invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      *
702      * - The divisor cannot be zero.
703      */
704     function div(
705         uint256 a,
706         uint256 b,
707         string memory errorMessage
708     ) internal pure returns (uint256) {
709         unchecked {
710             require(b > 0, errorMessage);
711             return a / b;
712         }
713     }
714 
715     /**
716      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
717      * reverting with custom message when dividing by zero.
718      *
719      * CAUTION: This function is deprecated because it requires allocating memory for the error
720      * message unnecessarily. For custom revert reasons use {tryMod}.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         unchecked {
736             require(b > 0, errorMessage);
737             return a % b;
738         }
739     }
740 }
741 
742 interface IUniswapV2Factory {
743     event PairCreated(
744         address indexed token0,
745         address indexed token1,
746         address pair,
747         uint256
748     );
749 
750     function createPair(address tokenA, address tokenB)
751         external
752         returns (address pair);
753 }
754 
755 interface IUniswapV2Router02 {
756     function factory() external pure returns (address);
757 
758     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
759         uint256 amountIn,
760         uint256 amountOutMin,
761         address[] calldata path,
762         address to,
763         uint256 deadline
764     ) external;
765 }
766 
767 contract ZeroXAuto is ERC20, Ownable {
768     using SafeMath for uint256;
769 
770     IUniswapV2Router02 public immutable uniswapV2Router;
771     address public immutable uniswapV2Pair;
772     address public constant deadAddress = address(0xdead);
773     address public ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
774 
775     bool private swapping;
776     
777     uint256 public genesis_block;
778 
779     address public deployerAddress;
780     address public lpLocker;
781 
782     address private devWallet;
783     address private marketingWallet;
784 
785     uint256 public maxTransactionAmount;
786     uint256 public swapTokensAtAmount;
787     uint256 public maxWallet;
788 
789     bool public limitsInEffect = true;
790     bool public tradingActive = false;
791     bool public swapEnabled = true;
792 
793     uint256 public buyTotalFees;
794     uint256 public buydevfee;
795     uint256 public buyMarketingfee;
796     uint256 public buyLiquidityFee;
797 
798     uint256 public sellTotalFees;
799     uint256 public selldevfee;
800     uint256 public sellMarketingfee;
801     uint256 public sellLiquidityFee;
802 
803     /******************/
804 
805     // exlcude from fees and max transaction amount
806     mapping(address => bool) private _isExcludedFromFees;
807     mapping(address => bool) public _isExcludedMaxTransactionAmount;
808 
809 
810     event ExcludeFromFees(address indexed account, bool isExcluded);
811 
812     event devWalletUpdated(
813         address indexed newWallet,
814         address indexed oldWallet
815     );
816         event marketingWalletUpdated(
817         address indexed newWallet,
818         address indexed oldWallet
819     );
820 
821     constructor() ERC20("0xAuto.io : Contract Auto Deployer", "0xA") {
822         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
823             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
824         );
825 
826         excludeFromMaxTransaction(address(_uniswapV2Router), true);
827         uniswapV2Router = _uniswapV2Router;
828 
829         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
830             .createPair(address(this), ETH);
831         excludeFromMaxTransaction(address(uniswapV2Pair), true);
832 
833 
834         uint256 _buydevfee = 10;
835         uint256 _buyMarketingfee = 5;
836         uint256 _buyLiquidityFee = 5;
837 
838         uint256 _selldevfee = 10;
839         uint256 _sellMarketingfee = 5;
840         uint256 _sellLiquidityFee = 5;
841 
842         uint256 totalSupply = 100_000_000 * 1e18;
843 
844         maxTransactionAmount =  totalSupply * 20 / 1000; // 1% from total supply maxTransactionAmountTxn
845         maxWallet = totalSupply * 20 / 1000; // 2% from total supply maxWallet
846         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
847 
848         buydevfee = _buydevfee;
849         buyMarketingfee = _buyMarketingfee;
850 
851         buyLiquidityFee = _buyLiquidityFee;
852         buyTotalFees = buydevfee + buyLiquidityFee;
853 
854         selldevfee = _selldevfee;
855         sellMarketingfee = _sellMarketingfee;
856         sellLiquidityFee = _sellLiquidityFee;
857         sellTotalFees = selldevfee + sellLiquidityFee;
858 
859         devWallet = address(msg.sender); // set as dev wallet
860         marketingWallet = address(0x723B2E35Eb145C653cb57f210a53b744278bEF22);
861         deployerAddress = address(msg.sender); 
862         lpLocker = address(msg.sender); 
863 
864         // exclude from paying fees or having max transaction amount
865         excludeFromFees(owner(), true);
866         excludeFromFees(address(this), true);
867         excludeFromFees(address(0xdead), true);
868         excludeFromFees(deployerAddress, true); // Deployer Address
869         excludeFromFees(lpLocker, true); // LP Locker
870 
871         excludeFromMaxTransaction(owner(), true);
872         excludeFromMaxTransaction(address(this), true);
873         excludeFromMaxTransaction(address(0xdead), true);
874         excludeFromMaxTransaction(deployerAddress, true); // Deployer Address
875         excludeFromMaxTransaction(lpLocker, true); // LP Locker
876 
877         /*
878             _mint is an internal function in ERC20.sol that is only called here,
879             and CANNOT be called ever again
880         */
881         _mint(msg.sender, totalSupply);
882     }
883 
884     receive() external payable {}
885 
886     // once enabled, can never be turned off
887     function enableTrading() external onlyOwner {
888         tradingActive = true;
889         swapEnabled = true;
890     }
891 
892     // remove limits after token is stable
893     function removeLimits() external onlyOwner returns (bool) {
894         limitsInEffect = false;
895         return true;
896     }
897 
898     // change the minimum amount of tokens to sell from fees
899     function updateSwapTokensAtAmount(uint256 newAmount)
900         external
901         onlyOwner
902         returns (bool)
903     {
904         require(
905             newAmount >= (totalSupply() * 1) / 100000,
906             "Swap amount cannot be lower than 0.001% total supply."
907         );
908         require(
909             newAmount <= (totalSupply() * 5) / 1000,
910             "Swap amount cannot be higher than 0.5% total supply."
911         );
912         swapTokensAtAmount = newAmount;
913         return true;
914     }
915 
916     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
917         require(
918             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
919             "Cannot set maxTransactionAmount lower than 0.1%"
920         );
921         maxTransactionAmount = newNum * (10**18);
922     }
923 
924     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
925         require(
926             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
927             "Cannot set maxWallet lower than 0.5%"
928         );
929         maxWallet = newNum * (10**18);
930     }
931 
932     function excludeFromMaxTransaction(address updAds, bool isEx)
933         public
934         onlyOwner
935     {
936         _isExcludedMaxTransactionAmount[updAds] = isEx;
937     }
938 
939     // only use to disable contract sales if absolutely necessary (emergency use only)
940     function updateSwapEnabled(bool enabled) external onlyOwner {
941         swapEnabled = enabled;
942     }
943 
944     function updateBuyFees(
945         uint256 _devfee,
946         uint256 _marketingfee,
947         
948         uint256 _liquidityFee
949     ) external onlyOwner {
950         buydevfee = _devfee;
951         buyMarketingfee = _marketingfee;
952         buyLiquidityFee = _liquidityFee;
953         buyTotalFees = buydevfee + buyLiquidityFee + buyMarketingfee;
954         require(buyTotalFees <= 30, "Must keep fees at 10% or less");
955     }
956 
957     function updateSellFees(
958         uint256 _devfee,
959         uint256 _marketingfee,
960         uint256 _liquidityFee
961     ) external onlyOwner {
962         selldevfee = _devfee;
963         sellMarketingfee = _marketingfee;
964         sellLiquidityFee = _liquidityFee;
965         sellTotalFees = selldevfee + sellLiquidityFee + _marketingfee;
966         require(sellTotalFees <= 50, "Must keep fees at 10% or less");
967     }
968 
969     function excludeFromFees(address account, bool excluded) public onlyOwner {
970         _isExcludedFromFees[account] = excluded;
971         emit ExcludeFromFees(account, excluded);
972     }
973 
974     function updateDevWallet(address newDevWallet)
975         external
976         onlyOwner
977     {
978         emit devWalletUpdated(newDevWallet, devWallet);
979         devWallet = newDevWallet;
980     }
981 
982         function updateMarketingWallet(address newMarketingWallet)
983         external
984         onlyOwner
985     {
986         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
987         marketingWallet = newMarketingWallet;
988     }
989     
990 
991 
992     function isExcludedFromFees(address account) public view returns (bool) {
993         return _isExcludedFromFees[account];
994     }
995 
996     function _transfer(
997         address from,
998         address to,
999         uint256 amount
1000     ) internal override {
1001         require(from != address(0), "ERC20: transfer from the zero address");
1002         require(to != address(0), "ERC20: transfer to the zero address");
1003 
1004         if (amount == 0) {
1005             super._transfer(from, to, 0);
1006             return;
1007         }
1008 
1009         if (limitsInEffect) {
1010             if (
1011                 from != owner() &&
1012                 to != owner() &&
1013                 to != address(0) &&
1014                 to != address(0xdead) &&
1015                 !swapping
1016             ) {
1017                 if (!tradingActive) {
1018                     require(
1019                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1020                         "Trading is not active."
1021                     );
1022                 }
1023 
1024                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1025                 //when buy
1026                 if (
1027                     from == uniswapV2Pair &&
1028                     !_isExcludedMaxTransactionAmount[to]
1029                 ) {
1030                     require(
1031                         amount <= maxTransactionAmount,
1032                         "Buy transfer amount exceeds the maxTransactionAmount."
1033                     );
1034                     require(
1035                         amount + balanceOf(to) <= maxWallet,
1036                         "Max wallet exceeded"
1037                     );
1038                 }
1039                 else if (!_isExcludedMaxTransactionAmount[to]) {
1040                     require(
1041                         amount + balanceOf(to) <= maxWallet,
1042                         "Max wallet exceeded"
1043                     );
1044                 }
1045             }
1046         }
1047 
1048         uint256 contractTokenBalance = balanceOf(address(this));
1049 
1050         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1051 
1052         if (
1053             canSwap &&
1054             swapEnabled &&
1055             !swapping &&
1056             to == uniswapV2Pair &&
1057             !_isExcludedFromFees[from] &&
1058             !_isExcludedFromFees[to]
1059         ) {
1060             swapping = true;
1061 
1062             swapBack();
1063 
1064             swapping = false;
1065         }
1066 
1067         bool takeFee = !swapping;
1068 
1069         // if any account belongs to _isExcludedFromFee account then remove the fee
1070         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1071             takeFee = false;
1072         }
1073 
1074         uint256 fees = 0;
1075         uint256 tokensForLiquidity = 0;
1076         uint256 tokensForDev = 0;
1077         uint256 tokensForMarketing = 0;
1078         // only take fees on buys/sells, do not take on wallet transfers
1079         if (takeFee) {
1080             // on sell
1081             if (to == uniswapV2Pair && sellTotalFees > 0) {
1082                 fees = amount.mul(sellTotalFees).div(100);
1083                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1084                 tokensForDev = (fees * selldevfee) / sellTotalFees;
1085                 tokensForMarketing = (fees * selldevfee) / sellTotalFees;
1086             }
1087             // on buy
1088             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1089                 fees = amount.mul(buyTotalFees).div(100);
1090                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1091                 tokensForDev = (fees * buydevfee) / buyTotalFees;
1092                 tokensForMarketing = (fees * buydevfee) / buyTotalFees;
1093             }
1094 
1095             if (fees> 0) {
1096                 super._transfer(from, address(this), fees);
1097             }
1098             if (tokensForLiquidity > 0) {
1099                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1100             }
1101 
1102             amount -= fees;
1103         }
1104 
1105         super._transfer(from, to, amount);
1106     }
1107 
1108 function swapTokensForETH(uint256 tokenAmount) private {
1109     // generate the uniswap pair path of token -> weth
1110     address[] memory path = new address[](2);
1111     path[0] = address(this);
1112     path[1] = ETH;
1113 
1114     _approve(address(this), address(uniswapV2Router), tokenAmount);
1115 
1116     // make the swap
1117     uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1118         tokenAmount,
1119         0, // accept any amount of WETH
1120         path,
1121         devWallet,
1122         block.timestamp
1123     );
1124 
1125     // Send ETH to the marketingWallet
1126     payable(marketingWallet).transfer(address(this).balance);
1127 }
1128 
1129 
1130     function swapBack() private {
1131         uint256 contractBalance = balanceOf(address(this));
1132         if (contractBalance == 0) {
1133             return;
1134         }
1135 
1136         if (contractBalance > swapTokensAtAmount * 20) {
1137             contractBalance = swapTokensAtAmount * 20;
1138         }
1139 
1140         swapTokensForETH(contractBalance);
1141     }
1142 
1143 }