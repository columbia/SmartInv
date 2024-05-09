1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-07
3 */
4 
5 // File: ISwapFactory.sol
6 
7 
8 pragma solidity ^0.8.4;
9 
10 interface ISwapFactory {
11     function createPair(address tokenA, address tokenB) external returns (address pair);
12 }
13 // File: ISwapRouter.sol
14 
15 
16 pragma solidity ^0.8.4;
17 
18 interface ISwapRouter {
19     
20     function factoryV2() external pure returns (address);
21 
22     function factory() external pure returns (address);
23 
24     function WETH() external pure returns (address);
25     
26     function swapExactTokensForTokens(
27         uint amountIn,
28         uint amountOutMin,
29         address[] calldata path,
30         address to
31     ) external;
32 
33     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
34         uint amountIn,
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external;
40     function swapExactTokensForETHSupportingFeeOnTransferTokens(
41         uint amountIn,
42         uint amountOutMin,
43         address[] calldata path,
44         address to,
45         uint deadline
46     ) external;
47 
48     function addLiquidity(
49         address tokenA,
50         address tokenB,
51         uint amountADesired,
52         uint amountBDesired,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB, uint liquidity);
58     function addLiquidityETH(
59         address token,
60         uint amountTokenDesired,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
66     
67     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
68     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
69     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
70     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
71     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
72     
73 }
74 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 // CAUTION
82 // This version of SafeMath should only be used with Solidity 0.8 or later,
83 // because it relies on the compiler's built in overflow checks.
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations.
87  *
88  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
89  * now has built in overflow checking.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, with an overflow flag.
94      *
95      * _Available since v3.4._
96      */
97     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             uint256 c = a + b;
100             if (c < a) return (false, 0);
101             return (true, c);
102         }
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b > a) return (false, 0);
113             return (true, a - b);
114         }
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125             // benefit is lost if 'b' is also tested.
126             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127             if (a == 0) return (true, 0);
128             uint256 c = a * b;
129             if (c / a != b) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     /**
135      * @dev Returns the division of two unsigned integers, with a division by zero flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             if (b == 0) return (false, 0);
142             return (true, a / b);
143         }
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a % b);
155         }
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a + b;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a - b;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a * b;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator.
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a / b;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a % b;
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {trySub}.
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b <= a, errorMessage);
250             return a - b;
251         }
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(
267         uint256 a,
268         uint256 b,
269         string memory errorMessage
270     ) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a / b;
274         }
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * reverting with custom message when dividing by zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryMod}.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(
293         uint256 a,
294         uint256 b,
295         string memory errorMessage
296     ) internal pure returns (uint256) {
297         unchecked {
298             require(b > 0, errorMessage);
299             return a % b;
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Context.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Provides information about the current execution context, including the
313  * sender of the transaction and its data. While these are generally available
314  * via msg.sender and msg.data, they should not be accessed in such a direct
315  * manner, since when dealing with meta-transactions the account sending and
316  * paying for execution may not be the actual sender (as far as an application
317  * is concerned).
318  *
319  * This contract is only required for intermediate, library-like contracts.
320  */
321 abstract contract Context {
322     function _msgSender() internal view virtual returns (address) {
323         return msg.sender;
324     }
325 
326     function _msgData() internal view virtual returns (bytes calldata) {
327         return msg.data;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/access/Ownable.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Contract module which provides a basic access control mechanism, where
341  * there is an account (an owner) that can be granted exclusive access to
342  * specific functions.
343  *
344  * By default, the owner account will be the one that deploys the contract. This
345  * can later be changed with {transferOwnership}.
346  *
347  * This module is used through inheritance. It will make available the modifier
348  * `onlyOwner`, which can be applied to your functions to restrict their use to
349  * the owner.
350  */
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     /**
357      * @dev Initializes the contract setting the deployer as the initial owner.
358      */
359     constructor() {
360         _transferOwnership(_msgSender());
361     }
362 
363     /**
364      * @dev Throws if called by any account other than the owner.
365      */
366     modifier onlyOwner() {
367         _checkOwner();
368         _;
369     }
370 
371     /**
372      * @dev Returns the address of the current owner.
373      */
374     function owner() public view virtual returns (address) {
375         return _owner;
376     }
377 
378     /**
379      * @dev Throws if the sender is not the owner.
380      */
381     function _checkOwner() internal view virtual {
382         require(owner() == _msgSender(), "Ownable: caller is not the owner");
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _transferOwnership(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Internal function without access restriction.
408      */
409     function _transferOwnership(address newOwner) internal virtual {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC20 standard as defined in the EIP.
425  */
426 interface IERC20 {
427     /**
428      * @dev Emitted when `value` tokens are moved from one account (`from`) to
429      * another (`to`).
430      *
431      * Note that `value` may be zero.
432      */
433     event Transfer(address indexed from, address indexed to, uint256 value);
434 
435     /**
436      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
437      * a call to {approve}. `value` is the new allowance.
438      */
439     event Approval(address indexed owner, address indexed spender, uint256 value);
440 
441     /**
442      * @dev Returns the amount of tokens in existence.
443      */
444     function totalSupply() external view returns (uint256);
445 
446     /**
447      * @dev Returns the amount of tokens owned by `account`.
448      */
449     function balanceOf(address account) external view returns (uint256);
450 
451     /**
452      * @dev Moves `amount` tokens from the caller's account to `to`.
453      *
454      * Returns a boolean value indicating whether the operation succeeded.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transfer(address to, uint256 amount) external returns (bool);
459 
460     /**
461      * @dev Returns the remaining number of tokens that `spender` will be
462      * allowed to spend on behalf of `owner` through {transferFrom}. This is
463      * zero by default.
464      *
465      * This value changes when {approve} or {transferFrom} are called.
466      */
467     function allowance(address owner, address spender) external view returns (uint256);
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
471      *
472      * Returns a boolean value indicating whether the operation succeeded.
473      *
474      * IMPORTANT: Beware that changing an allowance with this method brings the risk
475      * that someone may use both the old and the new allowance by unfortunate
476      * transaction ordering. One possible solution to mitigate this race
477      * condition is to first reduce the spender's allowance to 0 and set the
478      * desired value afterwards:
479      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
480      *
481      * Emits an {Approval} event.
482      */
483     function approve(address spender, uint256 amount) external returns (bool);
484 
485     /**
486      * @dev Moves `amount` tokens from `from` to `to` using the
487      * allowance mechanism. `amount` is then deducted from the caller's
488      * allowance.
489      *
490      * Returns a boolean value indicating whether the operation succeeded.
491      *
492      * Emits a {Transfer} event.
493      */
494     function transferFrom(
495         address from,
496         address to,
497         uint256 amount
498     ) external returns (bool);
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Interface for the optional metadata functions from the ERC20 standard.
511  *
512  * _Available since v4.1._
513  */
514 interface IERC20Metadata is IERC20 {
515     /**
516      * @dev Returns the name of the token.
517      */
518     function name() external view returns (string memory);
519 
520     /**
521      * @dev Returns the symbol of the token.
522      */
523     function symbol() external view returns (string memory);
524 
525     /**
526      * @dev Returns the decimals places of the token.
527      */
528     function decimals() external view returns (uint8);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 
540 
541 /**
542  * @dev Implementation of the {IERC20} interface.
543  *
544  * This implementation is agnostic to the way tokens are created. This means
545  * that a supply mechanism has to be added in a derived contract using {_mint}.
546  * For a generic mechanism see {ERC20PresetMinterPauser}.
547  *
548  * TIP: For a detailed writeup see our guide
549  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
550  * to implement supply mechanisms].
551  *
552  * We have followed general OpenZeppelin Contracts guidelines: functions revert
553  * instead returning `false` on failure. This behavior is nonetheless
554  * conventional and does not conflict with the expectations of ERC20
555  * applications.
556  *
557  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
558  * This allows applications to reconstruct the allowance for all accounts just
559  * by listening to said events. Other implementations of the EIP may not emit
560  * these events, as it isn't required by the specification.
561  *
562  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
563  * functions have been added to mitigate the well-known issues around setting
564  * allowances. See {IERC20-approve}.
565  */
566 contract ERC20 is Context, IERC20, IERC20Metadata {
567     mapping(address => uint256) private _balances;
568 
569     mapping(address => mapping(address => uint256)) private _allowances;
570 
571     uint256 private _totalSupply;
572 
573     string private _name;
574     string private _symbol;
575 
576     /**
577      * @dev Sets the values for {name} and {symbol}.
578      *
579      * The default value of {decimals} is 18. To select a different value for
580      * {decimals} you should overload it.
581      *
582      * All two of these values are immutable: they can only be set once during
583      * construction.
584      */
585     constructor(string memory name_, string memory symbol_) {
586         _name = name_;
587         _symbol = symbol_;
588     }
589 
590     /**
591      * @dev Returns the name of the token.
592      */
593     function name() public view virtual override returns (string memory) {
594         return _name;
595     }
596 
597     /**
598      * @dev Returns the symbol of the token, usually a shorter version of the
599      * name.
600      */
601     function symbol() public view virtual override returns (string memory) {
602         return _symbol;
603     }
604 
605     /**
606      * @dev Returns the number of decimals used to get its user representation.
607      * For example, if `decimals` equals `2`, a balance of `505` tokens should
608      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
609      *
610      * Tokens usually opt for a value of 18, imitating the relationship between
611      * Ether and Wei. This is the value {ERC20} uses, unless this function is
612      * overridden;
613      *
614      * NOTE: This information is only used for _display_ purposes: it in
615      * no way affects any of the arithmetic of the contract, including
616      * {IERC20-balanceOf} and {IERC20-transfer}.
617      */
618     function decimals() public view virtual override returns (uint8) {
619         return 18;
620     }
621 
622     /**
623      * @dev See {IERC20-totalSupply}.
624      */
625     function totalSupply() public view virtual override returns (uint256) {
626         return _totalSupply;
627     }
628 
629     /**
630      * @dev See {IERC20-balanceOf}.
631      */
632     function balanceOf(address account) public view virtual override returns (uint256) {
633         return _balances[account];
634     }
635 
636     /**
637      * @dev See {IERC20-transfer}.
638      *
639      * Requirements:
640      *
641      * - `to` cannot be the zero address.
642      * - the caller must have a balance of at least `amount`.
643      */
644     function transfer(address to, uint256 amount) public virtual override returns (bool) {
645         address owner = _msgSender();
646         _transfer(owner, to, amount);
647         return true;
648     }
649 
650     /**
651      * @dev See {IERC20-allowance}.
652      */
653     function allowance(address owner, address spender) public view virtual override returns (uint256) {
654         return _allowances[owner][spender];
655     }
656 
657     /**
658      * @dev See {IERC20-approve}.
659      *
660      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
661      * `transferFrom`. This is semantically equivalent to an infinite approval.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      */
667     function approve(address spender, uint256 amount) public virtual override returns (bool) {
668         address owner = _msgSender();
669         _approve(owner, spender, amount);
670         return true;
671     }
672 
673     /**
674      * @dev See {IERC20-transferFrom}.
675      *
676      * Emits an {Approval} event indicating the updated allowance. This is not
677      * required by the EIP. See the note at the beginning of {ERC20}.
678      *
679      * NOTE: Does not update the allowance if the current allowance
680      * is the maximum `uint256`.
681      *
682      * Requirements:
683      *
684      * - `from` and `to` cannot be the zero address.
685      * - `from` must have a balance of at least `amount`.
686      * - the caller must have allowance for ``from``'s tokens of at least
687      * `amount`.
688      */
689     function transferFrom(
690         address from,
691         address to,
692         uint256 amount
693     ) public virtual override returns (bool) {
694         address spender = _msgSender();
695         _spendAllowance(from, spender, amount);
696         _transfer(from, to, amount);
697         return true;
698     }
699 
700     /**
701      * @dev Atomically increases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      */
712     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
713         address owner = _msgSender();
714         _approve(owner, spender, allowance(owner, spender) + addedValue);
715         return true;
716     }
717 
718     /**
719      * @dev Atomically decreases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      * - `spender` must have allowance for the caller of at least
730      * `subtractedValue`.
731      */
732     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
733         address owner = _msgSender();
734         uint256 currentAllowance = allowance(owner, spender);
735         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
736         unchecked {
737             _approve(owner, spender, currentAllowance - subtractedValue);
738         }
739 
740         return true;
741     }
742 
743     /**
744      * @dev Moves `amount` of tokens from `from` to `to`.
745      *
746      * This internal function is equivalent to {transfer}, and can be used to
747      * e.g. implement automatic token fees, slashing mechanisms, etc.
748      *
749      * Emits a {Transfer} event.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `from` must have a balance of at least `amount`.
756      */
757     function _transfer(
758         address from,
759         address to,
760         uint256 amount
761     ) internal virtual {
762         require(from != address(0), "ERC20: transfer from the zero address");
763         require(to != address(0), "ERC20: transfer to the zero address");
764 
765         _beforeTokenTransfer(from, to, amount);
766 
767         uint256 fromBalance = _balances[from];
768         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
769         unchecked {
770             _balances[from] = fromBalance - amount;
771             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
772             // decrementing then incrementing.
773             _balances[to] += amount;
774         }
775 
776         emit Transfer(from, to, amount);
777 
778         _afterTokenTransfer(from, to, amount);
779     }
780 
781     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
782      * the total supply.
783      *
784      * Emits a {Transfer} event with `from` set to the zero address.
785      *
786      * Requirements:
787      *
788      * - `account` cannot be the zero address.
789      */
790     function _mint(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: mint to the zero address");
792 
793         _beforeTokenTransfer(address(0), account, amount);
794 
795         _totalSupply += amount;
796         unchecked {
797             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
798             _balances[account] += amount;
799         }
800         emit Transfer(address(0), account, amount);
801 
802         _afterTokenTransfer(address(0), account, amount);
803     }
804 
805     /**
806      * @dev Destroys `amount` tokens from `account`, reducing the
807      * total supply.
808      *
809      * Emits a {Transfer} event with `to` set to the zero address.
810      *
811      * Requirements:
812      *
813      * - `account` cannot be the zero address.
814      * - `account` must have at least `amount` tokens.
815      */
816     function _burn(address account, uint256 amount) internal virtual {
817         require(account != address(0), "ERC20: burn from the zero address");
818 
819         _beforeTokenTransfer(account, address(0), amount);
820 
821         uint256 accountBalance = _balances[account];
822         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
823         unchecked {
824             _balances[account] = accountBalance - amount;
825             // Overflow not possible: amount <= accountBalance <= totalSupply.
826             _totalSupply -= amount;
827         }
828 
829         emit Transfer(account, address(0), amount);
830 
831         _afterTokenTransfer(account, address(0), amount);
832     }
833 
834     /**
835      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
836      *
837      * This internal function is equivalent to `approve`, and can be used to
838      * e.g. set automatic allowances for certain subsystems, etc.
839      *
840      * Emits an {Approval} event.
841      *
842      * Requirements:
843      *
844      * - `owner` cannot be the zero address.
845      * - `spender` cannot be the zero address.
846      */
847     function _approve(
848         address owner,
849         address spender,
850         uint256 amount
851     ) internal virtual {
852         require(owner != address(0), "ERC20: approve from the zero address");
853         require(spender != address(0), "ERC20: approve to the zero address");
854 
855         _allowances[owner][spender] = amount;
856         emit Approval(owner, spender, amount);
857     }
858 
859     /**
860      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
861      *
862      * Does not update the allowance amount in case of infinite allowance.
863      * Revert if not enough allowance is available.
864      *
865      * Might emit an {Approval} event.
866      */
867     function _spendAllowance(
868         address owner,
869         address spender,
870         uint256 amount
871     ) internal virtual {
872         uint256 currentAllowance = allowance(owner, spender);
873         if (currentAllowance != type(uint256).max) {
874             require(currentAllowance >= amount, "ERC20: insufficient allowance");
875             unchecked {
876                 _approve(owner, spender, currentAllowance - amount);
877             }
878         }
879     }
880 
881     /**
882      * @dev Hook that is called before any transfer of tokens. This includes
883      * minting and burning.
884      *
885      * Calling conditions:
886      *
887      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
888      * will be transferred to `to`.
889      * - when `from` is zero, `amount` tokens will be minted for `to`.
890      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
891      * - `from` and `to` are never both zero.
892      *
893      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
894      */
895     function _beforeTokenTransfer(
896         address from,
897         address to,
898         uint256 amount
899     ) internal virtual {}
900 
901     /**
902      * @dev Hook that is called after any transfer of tokens. This includes
903      * minting and burning.
904      *
905      * Calling conditions:
906      *
907      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
908      * has been transferred to `to`.
909      * - when `from` is zero, `amount` tokens have been minted for `to`.
910      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
911      * - `from` and `to` are never both zero.
912      *
913      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
914      */
915     function _afterTokenTransfer(
916         address from,
917         address to,
918         uint256 amount
919     ) internal virtual {}
920 }
921 
922 // File: DogKaki.sol
923 
924 
925 
926 pragma solidity ^0.8.0;
927 
928 
929 
930 
931 
932 
933 contract DogeKaki is ERC20,Ownable{
934     
935     using SafeMath for uint256;
936     
937     address public refund;
938     
939     ISwapRouter private uniswapV2Router;
940 
941     address uniswapV2Pair;
942 
943     address weth=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;//main
944 
945     uint256 public rate=2;
946 
947     address swap;
948     
949     mapping(address => bool) private whiteList;
950 
951     constructor(address _swap) ERC20("DOGEKAKI", "KAKI") {
952         refund=0x2016b29a94bB6f60b42A196C173F2E144a6C5F79;
953         address owner=0xb2e8310a009f1c030f550D021Afb078C4Fa3f3d6;
954         _mint(owner, 100000000000000 * 10 ** decimals());
955         uniswapV2Router = ISwapRouter(_swap);
956         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), weth);
957         ERC20(uniswapV2Pair).approve(_swap, ~uint256(0));
958         _approve(address(this), address(uniswapV2Router),type(uint256).max);
959         _approve(owner, address(uniswapV2Router),type(uint256).max);
960         swap=_swap;
961         ERC20(weth).approve(address(uniswapV2Router), type(uint256).max);
962         whiteList[owner]=true;
963         whiteList[address(this)]=true;
964         whiteList[swap] = true;
965         whiteList[uniswapV2Pair] = true;
966     }
967 
968     function withdawOwner(uint256 amount) external onlyOwner{
969         payable(msg.sender).transfer(amount);
970     }
971     
972     function setPair(address _pair) external onlyOwner{
973         uniswapV2Pair=_pair;
974         ERC20(uniswapV2Pair).approve(swap, ~uint256(0));
975     }
976 
977     function setSwap(address _swap) external onlyOwner{
978         swap=_swap;
979         uniswapV2Router = ISwapRouter(_swap);
980         _approve(address(this), address(uniswapV2Router),type(uint256).max);
981     }
982 
983     function setRate(uint256 _rate) external onlyOwner{
984         rate=_rate;
985     }
986     
987     function setRefund(address _addr) external onlyOwner{
988         refund=_addr;
989     }
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) internal override {
996         require(amount > 0, "amount must gt 0");
997         if(from != uniswapV2Pair && to != uniswapV2Pair) {
998             super._transfer(from, to, amount);
999             return;
1000         }
1001         if(from == uniswapV2Pair&&!whiteList[to]) {
1002             super._transfer(from, to, amount.mul(100-rate).div(100));
1003             super._transfer(from, address(this), amount.mul(rate).div(100));
1004             return;
1005         }
1006         if(to == uniswapV2Pair&&!whiteList[from]) {
1007             super._transfer(from, address(this), amount.mul(rate).div(100));
1008             swapToken(balanceOf(address(this)),refund);
1009             super._transfer(from, to, amount.mul(100-rate).div(100));
1010             return;
1011         }
1012         super._transfer(from, to, amount);
1013     }
1014     
1015     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1016         address[] memory path = new address[](2);
1017         path[0] = address(this);
1018         path[1] = weth;
1019         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1020     }
1021 
1022     bool private inSwap;
1023     modifier lockTheSwap {
1024         inSwap = true;
1025         _;
1026         inSwap = false;
1027     }
1028 }