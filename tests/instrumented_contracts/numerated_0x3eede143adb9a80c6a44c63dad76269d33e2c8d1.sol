1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 // CAUTION
73 // This version of SafeMath should only be used with Solidity 0.8 or later,
74 // because it relies on the compiler's built in overflow checks.
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations.
78  *
79  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
80  * now has built in overflow checking.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, with an overflow flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             uint256 c = a + b;
91             if (c < a) return (false, 0);
92             return (true, c);
93         }
94     }
95 
96     /**
97      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             if (b > a) return (false, 0);
104             return (true, a - b);
105         }
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116             // benefit is lost if 'b' is also tested.
117             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118             if (a == 0) return (true, 0);
119             uint256 c = a * b;
120             if (c / a != b) return (false, 0);
121             return (true, c);
122         }
123     }
124 
125     /**
126      * @dev Returns the division of two unsigned integers, with a division by zero flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b == 0) return (false, 0);
133             return (true, a / b);
134         }
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             if (b == 0) return (false, 0);
145             return (true, a % b);
146         }
147     }
148 
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a + b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a * b;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator.
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a / b;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a % b;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
223      * overflow (when the result is negative).
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {trySub}.
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b <= a, errorMessage);
241             return a - b;
242         }
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a / b;
265         }
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * reverting with custom message when dividing by zero.
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {tryMod}.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a % b;
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Context.sol
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 
323 
324 
325 pragma solidity ^0.8.0;
326 
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor() {
349         _setOwner(_msgSender());
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _setOwner(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         _setOwner(newOwner);
385     }
386 
387     function _setOwner(address newOwner) private {
388         address oldOwner = _owner;
389         _owner = newOwner;
390         emit OwnershipTransferred(oldOwner, newOwner);
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Interface of the ERC20 standard as defined in the EIP.
402  */
403 interface IERC20 {
404     /**
405      * @dev Returns the amount of tokens in existence.
406      */
407     function totalSupply() external view returns (uint256);
408 
409     /**
410      * @dev Returns the amount of tokens owned by `account`.
411      */
412     function balanceOf(address account) external view returns (uint256);
413 
414     /**
415      * @dev Moves `amount` tokens from the caller's account to `recipient`.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transfer(address recipient, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Returns the remaining number of tokens that `spender` will be
425      * allowed to spend on behalf of `owner` through {transferFrom}. This is
426      * zero by default.
427      *
428      * This value changes when {approve} or {transferFrom} are called.
429      */
430     function allowance(address owner, address spender) external view returns (uint256);
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * IMPORTANT: Beware that changing an allowance with this method brings the risk
438      * that someone may use both the old and the new allowance by unfortunate
439      * transaction ordering. One possible solution to mitigate this race
440      * condition is to first reduce the spender's allowance to 0 and set the
441      * desired value afterwards:
442      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address spender, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Moves `amount` tokens from `sender` to `recipient` using the
450      * allowance mechanism. `amount` is then deducted from the caller's
451      * allowance.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) external returns (bool);
462 
463     /**
464      * @dev Emitted when `value` tokens are moved from one account (`from`) to
465      * another (`to`).
466      *
467      * Note that `value` may be zero.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 value);
470 
471     /**
472      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
473      * a call to {approve}. `value` is the new allowance.
474      */
475     event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Interface for the optional metadata functions from the ERC20 standard.
487  *
488  * _Available since v4.1._
489  */
490 interface IERC20Metadata is IERC20 {
491     /**
492      * @dev Returns the name of the token.
493      */
494     function name() external view returns (string memory);
495 
496     /**
497      * @dev Returns the symbol of the token.
498      */
499     function symbol() external view returns (string memory);
500 
501     /**
502      * @dev Returns the decimals places of the token.
503      */
504     function decimals() external view returns (uint8);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 
514 
515 
516 /**
517  * @dev Implementation of the {IERC20} interface.
518  *
519  * This implementation is agnostic to the way tokens are created. This means
520  * that a supply mechanism has to be added in a derived contract using {_mint}.
521  * For a generic mechanism see {ERC20PresetMinterPauser}.
522  *
523  * TIP: For a detailed writeup see our guide
524  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
525  * to implement supply mechanisms].
526  *
527  * We have followed general OpenZeppelin Contracts guidelines: functions revert
528  * instead returning `false` on failure. This behavior is nonetheless
529  * conventional and does not conflict with the expectations of ERC20
530  * applications.
531  *
532  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
533  * This allows applications to reconstruct the allowance for all accounts just
534  * by listening to said events. Other implementations of the EIP may not emit
535  * these events, as it isn't required by the specification.
536  *
537  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
538  * functions have been added to mitigate the well-known issues around setting
539  * allowances. See {IERC20-approve}.
540  */
541 contract ERC20 is Context, IERC20, IERC20Metadata {
542     mapping(address => uint256) private _balances;
543 
544     mapping(address => mapping(address => uint256)) private _allowances;
545 
546     uint256 private _totalSupply;
547 
548     string private _name;
549     string private _symbol;
550 
551     /**
552      * @dev Sets the values for {name} and {symbol}.
553      *
554      * The default value of {decimals} is 18. To select a different value for
555      * {decimals} you should overload it.
556      *
557      * All two of these values are immutable: they can only be set once during
558      * construction.
559      */
560     constructor(string memory name_, string memory symbol_) {
561         _name = name_;
562         _symbol = symbol_;
563     }
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() public view virtual override returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the symbol of the token, usually a shorter version of the
574      * name.
575      */
576     function symbol() public view virtual override returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the number of decimals used to get its user representation.
582      * For example, if `decimals` equals `2`, a balance of `505` tokens should
583      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
584      *
585      * Tokens usually opt for a value of 18, imitating the relationship between
586      * Ether and Wei. This is the value {ERC20} uses, unless this function is
587      * overridden;
588      *
589      * NOTE: This information is only used for _display_ purposes: it in
590      * no way affects any of the arithmetic of the contract, including
591      * {IERC20-balanceOf} and {IERC20-transfer}.
592      */
593     function decimals() public view virtual override returns (uint8) {
594         return 18;
595     }
596 
597     /**
598      * @dev See {IERC20-totalSupply}.
599      */
600     function totalSupply() public view virtual override returns (uint256) {
601         return _totalSupply;
602     }
603 
604     /**
605      * @dev See {IERC20-balanceOf}.
606      */
607     function balanceOf(address account) public view virtual override returns (uint256) {
608         return _balances[account];
609     }
610 
611     /**
612      * @dev See {IERC20-transfer}.
613      *
614      * Requirements:
615      *
616      * - `recipient` cannot be the zero address.
617      * - the caller must have a balance of at least `amount`.
618      */
619     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
620         _transfer(_msgSender(), recipient, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-allowance}.
626      */
627     function allowance(address owner, address spender) public view virtual override returns (uint256) {
628         return _allowances[owner][spender];
629     }
630 
631     /**
632      * @dev See {IERC20-approve}.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      */
638     function approve(address spender, uint256 amount) public virtual override returns (bool) {
639         _approve(_msgSender(), spender, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-transferFrom}.
645      *
646      * Emits an {Approval} event indicating the updated allowance. This is not
647      * required by the EIP. See the note at the beginning of {ERC20}.
648      *
649      * Requirements:
650      *
651      * - `sender` and `recipient` cannot be the zero address.
652      * - `sender` must have a balance of at least `amount`.
653      * - the caller must have allowance for ``sender``'s tokens of at least
654      * `amount`.
655      */
656     function transferFrom(
657         address sender,
658         address recipient,
659         uint256 amount
660     ) public virtual override returns (bool) {
661         _transfer(sender, recipient, amount);
662 
663         uint256 currentAllowance = _allowances[sender][_msgSender()];
664         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
665         unchecked {
666             _approve(sender, _msgSender(), currentAllowance - amount);
667         }
668 
669         return true;
670     }
671 
672     /**
673      * @dev Atomically increases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      */
684     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
685         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
686         return true;
687     }
688 
689     /**
690      * @dev Atomically decreases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      * - `spender` must have allowance for the caller of at least
701      * `subtractedValue`.
702      */
703     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
704         uint256 currentAllowance = _allowances[_msgSender()][spender];
705         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
706         unchecked {
707             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
708         }
709 
710         return true;
711     }
712 
713     /**
714      * @dev Moves `amount` of tokens from `sender` to `recipient`.
715      *
716      * This internal function is equivalent to {transfer}, and can be used to
717      * e.g. implement automatic token fees, slashing mechanisms, etc.
718      *
719      * Emits a {Transfer} event.
720      *
721      * Requirements:
722      *
723      * - `sender` cannot be the zero address.
724      * - `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      */
727     function _transfer(
728         address sender,
729         address recipient,
730         uint256 amount
731     ) internal virtual {
732         require(sender != address(0), "ERC20: transfer from the zero address");
733         require(recipient != address(0), "ERC20: transfer to the zero address");
734 
735         _beforeTokenTransfer(sender, recipient, amount);
736 
737         uint256 senderBalance = _balances[sender];
738         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
739         unchecked {
740             _balances[sender] = senderBalance - amount;
741         }
742         _balances[recipient] += amount;
743 
744         emit Transfer(sender, recipient, amount);
745 
746         _afterTokenTransfer(sender, recipient, amount);
747     }
748 
749     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
750      * the total supply.
751      *
752      * Emits a {Transfer} event with `from` set to the zero address.
753      *
754      * Requirements:
755      *
756      * - `account` cannot be the zero address.
757      */
758     function _mint(address account, uint256 amount) internal virtual {
759         require(account != address(0), "ERC20: mint to the zero address");
760 
761         _beforeTokenTransfer(address(0), account, amount);
762 
763         _totalSupply += amount;
764         _balances[account] += amount;
765         emit Transfer(address(0), account, amount);
766 
767         _afterTokenTransfer(address(0), account, amount);
768     }
769 
770     /**
771      * @dev Destroys `amount` tokens from `account`, reducing the
772      * total supply.
773      *
774      * Emits a {Transfer} event with `to` set to the zero address.
775      *
776      * Requirements:
777      *
778      * - `account` cannot be the zero address.
779      * - `account` must have at least `amount` tokens.
780      */
781     function _burn(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: burn from the zero address");
783 
784         _beforeTokenTransfer(account, address(0), amount);
785 
786         uint256 accountBalance = _balances[account];
787         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
788         unchecked {
789             _balances[account] = accountBalance - amount;
790         }
791         _totalSupply -= amount;
792 
793         emit Transfer(account, address(0), amount);
794 
795         _afterTokenTransfer(account, address(0), amount);
796     }
797 
798     /**
799      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
800      *
801      * This internal function is equivalent to `approve`, and can be used to
802      * e.g. set automatic allowances for certain subsystems, etc.
803      *
804      * Emits an {Approval} event.
805      *
806      * Requirements:
807      *
808      * - `owner` cannot be the zero address.
809      * - `spender` cannot be the zero address.
810      */
811     function _approve(
812         address owner,
813         address spender,
814         uint256 amount
815     ) internal virtual {
816         require(owner != address(0), "ERC20: approve from the zero address");
817         require(spender != address(0), "ERC20: approve to the zero address");
818 
819         _allowances[owner][spender] = amount;
820         emit Approval(owner, spender, amount);
821     }
822 
823     /**
824      * @dev Hook that is called before any transfer of tokens. This includes
825      * minting and burning.
826      *
827      * Calling conditions:
828      *
829      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
830      * will be transferred to `to`.
831      * - when `from` is zero, `amount` tokens will be minted for `to`.
832      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
833      * - `from` and `to` are never both zero.
834      *
835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
836      */
837     function _beforeTokenTransfer(
838         address from,
839         address to,
840         uint256 amount
841     ) internal virtual {}
842 
843     /**
844      * @dev Hook that is called after any transfer of tokens. This includes
845      * minting and burning.
846      *
847      * Calling conditions:
848      *
849      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
850      * has been transferred to `to`.
851      * - when `from` is zero, `amount` tokens have been minted for `to`.
852      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
853      * - `from` and `to` are never both zero.
854      *
855      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
856      */
857     function _afterTokenTransfer(
858         address from,
859         address to,
860         uint256 amount
861     ) internal virtual {}
862 }
863 
864 // File: contracts/LeedoERC20.sol
865 
866 /**
867  * @dev LEEDO ERC20 Token Contract
868  *
869  *  _              ______      
870  * | |             |  _  \     
871  * | |     ___  ___| | | |___  
872  * | |    / _ \/ _ \ | | / _ \ 
873  * | |___|  __/  __/ |/ / (_) |
874  * \_____/\___|\___|___/ \___/ 
875  * LEEDO Project
876  */
877 
878 pragma solidity ^0.8.0;
879 
880 interface ILeedoNft {
881     
882     function balanceOf(address owner) external view returns (uint balance);
883     function ownerOf(uint tokenId) external view returns (address owner);
884     function getConsonants(uint tokenId) external view returns(string[3] memory);
885     function getGenes(uint tokenId) external view returns (uint8[8] memory);
886     function getConsonantsIndex(uint tokenId) external view returns (uint8[3] memory);
887 }
888 
889 interface ILeedoNftVault {
890     
891     function ownerOf(uint tokenId) external view returns (address owner);
892     function lastBlocks(address addr) external view returns (uint black);
893 }
894 
895 contract LeedoERC20 is ERC20, Ownable, ReentrancyGuard {
896     using SafeMath for uint;
897 
898     bool public daoInitialized = false;
899     address private _daoAddr;
900     address private _nftAddr;
901     address private _nftVaultAddr;
902     address private _raffleAddr;
903     uint public claimBlocksRequired = 200000; //about 31 days
904     uint private _decimal = 10**uint(decimals());    
905     uint public rafflePrize = 100000 * 20;
906     uint public nftMintableWeiAmount = (138000000 - 21000000) * _decimal; //117,000,000 * decimal
907     uint public daoMintableAmount = 175000000 + 70000000 + 70000000 + 210000000; //525,000,000
908     uint public marketingMintableAmount = 35000000;
909     uint public daoTimelock;
910     uint public timeLockDuration = 24 hours;
911     uint public season = 0;
912 
913     mapping(uint => mapping(uint => bool)) public claims; //season => (tokendId => bool)
914     mapping(uint => uint) public claimCount; //season => count
915 
916     modifier onlyDao() {
917         require(_daoAddr == _msgSender(), "ERC20: caller is not the DAO address!");
918         _;
919     } 
920     
921     modifier onlyNftVault() {
922         require(_nftVaultAddr == _msgSender(), "ERC20: caller is not the NftVault address!");
923         _;
924     }         
925     
926     //nftAddr = 0xBE5C953DD0ddB0Ce033a98f36C981F1B74d3B33f; //mainnet   
927     //raffleAddr = 0xb109173Ab57Dab7F954Ef8F10D87a5bFDB740EEB; //mainnet
928     constructor(address _nftAddress, address _raffleAddress) ERC20('LEEDO Project ERC20', 'LEEDO') {
929         _nftAddr = _nftAddress;
930         _raffleAddr = _raffleAddress;
931     }    
932 
933     function mintRafflePrize() external onlyOwner returns (bool) {
934         require(_safeMint(_raffleAddr, rafflePrize.mul(_decimal)), 'ERC20: Minting failed');
935         rafflePrize = 0;
936         return true;
937     }
938     
939     function setNftVaultAddr(address _vault) external onlyOwner {
940         _nftVaultAddr = _vault;
941     }
942     
943     function mintNftVaultRewards(address _to, uint _amount) external onlyNftVault returns (bool) {
944         //_amount is in wei
945         require(_amount <= nftMintableWeiAmount, 'ERC20: Amount is more than allowed');
946         nftMintableWeiAmount = nftMintableWeiAmount.sub(_amount);
947         require(_safeMint(_to, _amount), 'ERC20: Minting failed');
948         return true;
949     }
950     
951     function mintDev(address _devAddr, uint _amount) external onlyOwner returns (bool) {
952         require(_amount <= marketingMintableAmount, 'ERC20: Amount is more than allowed');
953         marketingMintableAmount = marketingMintableAmount.sub(_amount);
954         require(_safeMint(_devAddr, _amount.mul(_decimal)), 'ERC20: Minting failed');
955         return true;
956     }
957 
958     function initializeDao(address _daoAddress) public onlyOwner {
959         require(!daoInitialized, 'ERC20: DAO is already initialized');
960         _daoAddr = _daoAddress;
961         daoInitialized = true;
962     }
963     
964     function setDaoAddr(address _daoAddress) public onlyDao {
965         require(daoInitialized, 'ERC20: DAO is not initialized');
966         _daoAddr = _daoAddress;
967     }    
968 
969     function unlockDaoMint() public onlyDao {
970         daoTimelock = block.timestamp + timeLockDuration;
971     }
972 
973     function daoMint(uint _amount) public onlyDao returns (bool) {
974         require(daoTimelock != 0 && daoTimelock <= block.timestamp, 'ERC20: Wait _daoTimelock passes');
975         require(_amount <= daoMintableAmount, 'ERC20:  Amount is more than allowed');
976         daoMintableAmount = daoMintableAmount.sub(_amount); 
977         require(_safeMint(_daoAddr, _amount.mul(_decimal)), 'ERC20: Minting failed');
978         daoTimelock = 0;
979         return true;
980     }
981     
982     function daoSetSeason(uint _season) external onlyDao {
983         season = _season;
984     }    
985     
986     function setDaoMintable(uint _amount) external onlyDao {
987         daoMintableAmount = _amount;
988     }
989 
990     function setNftAddress(address _newAddress) external onlyDao {
991         _nftAddr = _newAddress;
992     }
993 
994     function setNftVaultAddrByDao(address _vault) external onlyDao {
995         _nftVaultAddr = _vault;
996     }    
997     
998     function _safeMint(address _to, uint _amount) private nonReentrant returns (bool) {
999         _mint(_to, _amount); //in wei
1000         return true;
1001     }
1002     
1003     function claim(uint[] calldata _tokenIds) external returns (uint) {
1004         require(_tokenIds.length <= 20, 'ERC20: maximum bulk claims is 20 cards per tx');
1005         ILeedoNftVault sNFT = ILeedoNftVault(_nftVaultAddr); //only Staked NFT can claim  
1006         require(sNFT.lastBlocks(_msgSender()) + claimBlocksRequired < block.number, 'ERC20: does not meet claimBlockRequired');
1007         uint total;
1008         for (uint i=0; i<_tokenIds.length; i++) {
1009             uint tokenId = _tokenIds[i];
1010             require(tokenId > 0 && tokenId < 9577, 'ERC20: tokenId is invalid'); 
1011             require(claims[season][tokenId] == false, 'ERC20: tokenId is already claimed');
1012             require(_msgSender() == sNFT.ownerOf(tokenId), 'ERC20: Only Staked NFT owner can claim');
1013             
1014             uint amount = calcRewards(tokenId); 
1015             claims[season][tokenId] = true;        
1016             claimCount[season] += 1;
1017             total = total.add(amount);
1018         }
1019         require(_safeMint(_msgSender(), total.mul(_decimal)), 'SquidERC20: Minting failed');      
1020         return total;
1021     }    
1022     
1023     function calcRewards(uint _tokenId) public view returns (uint) {        
1024         ILeedoNft NFT = ILeedoNft(_nftAddr);        
1025         uint8[3] memory consonants = NFT.getConsonantsIndex(_tokenId);
1026         uint8[8] memory genes = NFT.getGenes(_tokenId);        
1027         
1028         uint geneSSum;
1029         uint left = consonants[0];
1030         uint center = consonants[1];
1031         uint right = consonants[2];
1032         uint consFactor;
1033         uint timeFactor = 141 * (16000 - claimCount[season]) / 9000; //1 -> 250  9576 -> 100 
1034         uint tokenIdFactor;
1035         if (_tokenId <= 100) {
1036             tokenIdFactor = 200;
1037         } else if (_tokenId <= 1000) {
1038             tokenIdFactor = 150;
1039         } else {
1040             tokenIdFactor = 100;
1041         }
1042         
1043         for (uint i=0; i<8; i++) {
1044             geneSSum += uint(genes[i]).mul(uint(genes[i]));
1045         }
1046         if (geneSSum < 100) {
1047             geneSSum = 100;
1048         } else if (geneSSum > 648) {
1049             geneSSum = 648;
1050         }
1051         if (timeFactor < 100) {
1052             timeFactor = 100;
1053         }
1054 
1055         if (left == 7 && center == 14 && right == 4) { 
1056             consFactor = 2;
1057         } else if (left == center && left == center && center == right) {
1058             consFactor = 10;
1059         } else if (left == 7 && left == 4 && center == 14) {            
1060             consFactor = 5;
1061         } else if (left == 4 && left == 7 && center == 14) {                        
1062             consFactor = 5;
1063         } else if (left == 4 && left == 14 && center == 7) {                        
1064             consFactor = 5;
1065         } else if (left == 14 && left == 7 && center == 4) {                                
1066             consFactor = 5;
1067         } else if (left == 14 && left == 4 && center == 7) {                                                
1068             consFactor = 5;
1069         } else if ((left == 4 && left == center) || (left == 4 && left == right)) {            
1070             consFactor = 3;
1071         } else if ((left == 14 && left == center) || (left == 14 && left == right)) {
1072             consFactor = 3;
1073         } else if ((left == 7 && left == center) || (left == 7 && left == right)) {
1074             consFactor = 3;
1075         } else if (center == 4 && center == right )  {            
1076             consFactor = 3;
1077         } else if (center == 14 && center == right ) {                    
1078             consFactor = 3;
1079         } else if (center == 7 && center == right ) {                                
1080             consFactor = 3;            
1081         } else {
1082             consFactor = 1;
1083         }
1084         return  (geneSSum * tokenIdFactor * consFactor * timeFactor) / 2000;  
1085     }
1086     
1087     function daoAddr() external view returns (address) {
1088         return _daoAddr;
1089     }
1090     
1091     function nftAddr() external view returns (address) {
1092         return _nftAddr;
1093     }
1094     
1095     function nftVaultAddr() external view returns (address) {
1096         return _nftVaultAddr;
1097     }
1098     
1099     function raffleAddr() external view returns (address) {
1100         return _raffleAddr;
1101     }
1102 }