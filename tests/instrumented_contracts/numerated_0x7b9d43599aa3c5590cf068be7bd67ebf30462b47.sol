1 // SPDX-License-Identifier: agpl-3.0
2 
3 // File: openzeppelin-solidity/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: openzeppelin-solidity/contracts/access/Ownable.sol
33 
34 pragma solidity ^0.6.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Contract module that helps prevent reentrant calls to a function.
106  *
107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
108  * available, which can be applied to functions to make sure there are no nested
109  * (reentrant) calls to them.
110  *
111  * Note that because there is a single `nonReentrant` guard, functions marked as
112  * `nonReentrant` may not call one another. This can be worked around by making
113  * those functions `private`, and then adding `external` `nonReentrant` entry
114  * points to them.
115  *
116  * TIP: If you would like to learn more about reentrancy and alternative ways
117  * to protect against it, check out our blog post
118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
119  */
120 contract ReentrancyGuard {
121     bool private _notEntered;
122 
123     constructor () internal {
124         // Storing an initial non-zero value makes deployment a bit more
125         // expensive, but in exchange the refund on every call to nonReentrant
126         // will be lower in amount. Since refunds are capped to a percetange of
127         // the total transaction's gas, it is best to keep them low in cases
128         // like this one, to increase the likelihood of the full refund coming
129         // into effect.
130         _notEntered = true;
131     }
132 
133     /**
134      * @dev Prevents a contract from calling itself, directly or indirectly.
135      * Calling a `nonReentrant` function from another `nonReentrant`
136      * function is not supported. It is possible to prevent this from happening
137      * by making the `nonReentrant` function external, and make it call a
138      * `private` function that does the actual work.
139      */
140     modifier nonReentrant() {
141         // On the first call to nonReentrant, _notEntered will be true
142         require(_notEntered, "ReentrancyGuard: reentrant call");
143 
144         // Any calls to nonReentrant after this point will fail
145         _notEntered = false;
146 
147         _;
148 
149         // By storing the original value once again, a refund is triggered (see
150         // https://eips.ethereum.org/EIPS/eip-2200)
151         _notEntered = true;
152     }
153 }
154 
155 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
156 
157 pragma solidity ^0.6.0;
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `recipient`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `sender` to `recipient` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 }
232 
233 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
234 
235 pragma solidity ^0.6.0;
236 
237 /**
238  * @dev Wrappers over Solidity's arithmetic operations with added overflow
239  * checks.
240  *
241  * Arithmetic operations in Solidity wrap on overflow. This can easily result
242  * in bugs, because programmers usually assume that an overflow raises an
243  * error, which is the standard behavior in high level programming languages.
244  * `SafeMath` restores this intuition by reverting the transaction when an
245  * operation overflows.
246  *
247  * Using this library instead of the unchecked operations eliminates an entire
248  * class of bugs, so it's recommended to use it always.
249  */
250 library SafeMath {
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      * - Addition cannot overflow.
259      */
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         require(c >= a, "SafeMath: addition overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting on
269      * overflow (when the result is negative).
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return sub(a, b, "SafeMath: subtraction overflow");
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      * - Subtraction cannot overflow.
288      */
289     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b <= a, errorMessage);
291         uint256 c = a - b;
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the multiplication of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      * - Multiplication cannot overflow.
304      */
305     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
307         // benefit is lost if 'b' is also tested.
308         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
309         if (a == 0) {
310             return 0;
311         }
312 
313         uint256 c = a * b;
314         require(c / a == b, "SafeMath: multiplication overflow");
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers. Reverts on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      * - The divisor cannot be zero.
329      */
330     function div(uint256 a, uint256 b) internal pure returns (uint256) {
331         return div(a, b, "SafeMath: division by zero");
332     }
333 
334     /**
335      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
336      * division by zero. The result is rounded towards zero.
337      *
338      * Counterpart to Solidity's `/` operator. Note: this function uses a
339      * `revert` opcode (which leaves remaining gas untouched) while Solidity
340      * uses an invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      * - The divisor cannot be zero.
344      */
345     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
346         // Solidity only automatically asserts when dividing by 0
347         require(b > 0, errorMessage);
348         uint256 c = a / b;
349         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
350 
351         return c;
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * Reverts when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      * - The divisor cannot be zero.
364      */
365     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
366         return mod(a, b, "SafeMath: modulo by zero");
367     }
368 
369     /**
370      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
371      * Reverts with custom message when dividing by zero.
372      *
373      * Counterpart to Solidity's `%` operator. This function uses a `revert`
374      * opcode (which leaves remaining gas untouched) while Solidity uses an
375      * invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
381         require(b != 0, errorMessage);
382         return a % b;
383     }
384 }
385 
386 // File: openzeppelin-solidity/contracts/utils/Address.sol
387 
388 pragma solidity ^0.6.2;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
413         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
414         // for accounts without code, i.e. `keccak256('')`
415         bytes32 codehash;
416         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
417         // solhint-disable-next-line no-inline-assembly
418         assembly { codehash := extcodehash(account) }
419         return (codehash != accountHash && codehash != 0x0);
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * IMPORTANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
442         (bool success, ) = recipient.call{ value: amount }("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 }
446 
447 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
448 
449 pragma solidity ^0.6.0;
450 
451 
452 
453 
454 
455 /**
456  * @dev Implementation of the {IERC20} interface.
457  *
458  * This implementation is agnostic to the way tokens are created. This means
459  * that a supply mechanism has to be added in a derived contract using {_mint}.
460  * For a generic mechanism see {ERC20MinterPauser}.
461  *
462  * TIP: For a detailed writeup see our guide
463  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
464  * to implement supply mechanisms].
465  *
466  * We have followed general OpenZeppelin guidelines: functions revert instead
467  * of returning `false` on failure. This behavior is nonetheless conventional
468  * and does not conflict with the expectations of ERC20 applications.
469  *
470  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
471  * This allows applications to reconstruct the allowance for all accounts just
472  * by listening to said events. Other implementations of the EIP may not emit
473  * these events, as it isn't required by the specification.
474  *
475  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
476  * functions have been added to mitigate the well-known issues around setting
477  * allowances. See {IERC20-approve}.
478  */
479 contract ERC20 is Context, IERC20 {
480     using SafeMath for uint256;
481     using Address for address;
482 
483     mapping (address => uint256) private _balances;
484 
485     mapping (address => mapping (address => uint256)) private _allowances;
486 
487     uint256 private _totalSupply;
488 
489     string private _name;
490     string private _symbol;
491     uint8 private _decimals;
492 
493     /**
494      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
495      * a default value of 18.
496      *
497      * To select a different value for {decimals}, use {_setupDecimals}.
498      *
499      * All three of these values are immutable: they can only be set once during
500      * construction.
501      */
502     constructor (string memory name, string memory symbol) public {
503         _name = name;
504         _symbol = symbol;
505         _decimals = 18;
506     }
507 
508     /**
509      * @dev Returns the name of the token.
510      */
511     function name() public view returns (string memory) {
512         return _name;
513     }
514 
515     /**
516      * @dev Returns the symbol of the token, usually a shorter version of the
517      * name.
518      */
519     function symbol() public view returns (string memory) {
520         return _symbol;
521     }
522 
523     /**
524      * @dev Returns the number of decimals used to get its user representation.
525      * For example, if `decimals` equals `2`, a balance of `505` tokens should
526      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
527      *
528      * Tokens usually opt for a value of 18, imitating the relationship between
529      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
530      * called.
531      *
532      * NOTE: This information is only used for _display_ purposes: it in
533      * no way affects any of the arithmetic of the contract, including
534      * {IERC20-balanceOf} and {IERC20-transfer}.
535      */
536     function decimals() public view returns (uint8) {
537         return _decimals;
538     }
539 
540     /**
541      * @dev See {IERC20-totalSupply}.
542      */
543     function totalSupply() public view override returns (uint256) {
544         return _totalSupply;
545     }
546 
547     /**
548      * @dev See {IERC20-balanceOf}.
549      */
550     function balanceOf(address account) public view override returns (uint256) {
551         return _balances[account];
552     }
553 
554     /**
555      * @dev See {IERC20-transfer}.
556      *
557      * Requirements:
558      *
559      * - `recipient` cannot be the zero address.
560      * - the caller must have a balance of at least `amount`.
561      */
562     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
563         _transfer(_msgSender(), recipient, amount);
564         return true;
565     }
566 
567     /**
568      * @dev See {IERC20-allowance}.
569      */
570     function allowance(address owner, address spender) public view virtual override returns (uint256) {
571         return _allowances[owner][spender];
572     }
573 
574     /**
575      * @dev See {IERC20-approve}.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      */
581     function approve(address spender, uint256 amount) public virtual override returns (bool) {
582         _approve(_msgSender(), spender, amount);
583         return true;
584     }
585 
586     /**
587      * @dev See {IERC20-transferFrom}.
588      *
589      * Emits an {Approval} event indicating the updated allowance. This is not
590      * required by the EIP. See the note at the beginning of {ERC20};
591      *
592      * Requirements:
593      * - `sender` and `recipient` cannot be the zero address.
594      * - `sender` must have a balance of at least `amount`.
595      * - the caller must have allowance for ``sender``'s tokens of at least
596      * `amount`.
597      */
598     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
599         _transfer(sender, recipient, amount);
600         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
601         return true;
602     }
603 
604     /**
605      * @dev Atomically increases the allowance granted to `spender` by the caller.
606      *
607      * This is an alternative to {approve} that can be used as a mitigation for
608      * problems described in {IERC20-approve}.
609      *
610      * Emits an {Approval} event indicating the updated allowance.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      */
616     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
617         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
618         return true;
619     }
620 
621     /**
622      * @dev Atomically decreases the allowance granted to `spender` by the caller.
623      *
624      * This is an alternative to {approve} that can be used as a mitigation for
625      * problems described in {IERC20-approve}.
626      *
627      * Emits an {Approval} event indicating the updated allowance.
628      *
629      * Requirements:
630      *
631      * - `spender` cannot be the zero address.
632      * - `spender` must have allowance for the caller of at least
633      * `subtractedValue`.
634      */
635     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
636         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
637         return true;
638     }
639 
640     /**
641      * @dev Moves tokens `amount` from `sender` to `recipient`.
642      *
643      * This is internal function is equivalent to {transfer}, and can be used to
644      * e.g. implement automatic token fees, slashing mechanisms, etc.
645      *
646      * Emits a {Transfer} event.
647      *
648      * Requirements:
649      *
650      * - `sender` cannot be the zero address.
651      * - `recipient` cannot be the zero address.
652      * - `sender` must have a balance of at least `amount`.
653      */
654     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
655         require(sender != address(0), "ERC20: transfer from the zero address");
656         require(recipient != address(0), "ERC20: transfer to the zero address");
657 
658         _beforeTokenTransfer(sender, recipient, amount);
659 
660         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
661         _balances[recipient] = _balances[recipient].add(amount);
662         emit Transfer(sender, recipient, amount);
663     }
664 
665     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
666      * the total supply.
667      *
668      * Emits a {Transfer} event with `from` set to the zero address.
669      *
670      * Requirements
671      *
672      * - `to` cannot be the zero address.
673      */
674     function _mint(address account, uint256 amount) internal virtual {
675         require(account != address(0), "ERC20: mint to the zero address");
676 
677         _beforeTokenTransfer(address(0), account, amount);
678 
679         _totalSupply = _totalSupply.add(amount);
680         _balances[account] = _balances[account].add(amount);
681         emit Transfer(address(0), account, amount);
682     }
683 
684     /**
685      * @dev Destroys `amount` tokens from `account`, reducing the
686      * total supply.
687      *
688      * Emits a {Transfer} event with `to` set to the zero address.
689      *
690      * Requirements
691      *
692      * - `account` cannot be the zero address.
693      * - `account` must have at least `amount` tokens.
694      */
695     function _burn(address account, uint256 amount) internal virtual {
696         require(account != address(0), "ERC20: burn from the zero address");
697 
698         _beforeTokenTransfer(account, address(0), amount);
699 
700         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
701         _totalSupply = _totalSupply.sub(amount);
702         emit Transfer(account, address(0), amount);
703     }
704 
705     /**
706      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
707      *
708      * This is internal function is equivalent to `approve`, and can be used to
709      * e.g. set automatic allowances for certain subsystems, etc.
710      *
711      * Emits an {Approval} event.
712      *
713      * Requirements:
714      *
715      * - `owner` cannot be the zero address.
716      * - `spender` cannot be the zero address.
717      */
718     function _approve(address owner, address spender, uint256 amount) internal virtual {
719         require(owner != address(0), "ERC20: approve from the zero address");
720         require(spender != address(0), "ERC20: approve to the zero address");
721 
722         _allowances[owner][spender] = amount;
723         emit Approval(owner, spender, amount);
724     }
725 
726     /**
727      * @dev Sets {decimals} to a value other than the default one of 18.
728      *
729      * WARNING: This function should only be called from the constructor. Most
730      * applications that interact with token contracts will not expect
731      * {decimals} to ever change, and may work incorrectly if it does.
732      */
733     function _setupDecimals(uint8 decimals_) internal {
734         _decimals = decimals_;
735     }
736 
737     /**
738      * @dev Hook that is called before any transfer of tokens. This includes
739      * minting and burning.
740      *
741      * Calling conditions:
742      *
743      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
744      * will be to transferred to `to`.
745      * - when `from` is zero, `amount` tokens will be minted for `to`.
746      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
747      * - `from` and `to` are never both zero.
748      *
749      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
750      */
751     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
752 }
753 
754 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
755 
756 pragma solidity ^0.6.0;
757 
758 
759 
760 
761 /**
762  * @title SafeERC20
763  * @dev Wrappers around ERC20 operations that throw on failure (when the token
764  * contract returns false). Tokens that return no value (and instead revert or
765  * throw on failure) are also supported, non-reverting calls are assumed to be
766  * successful.
767  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
768  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
769  */
770 library SafeERC20 {
771     using SafeMath for uint256;
772     using Address for address;
773 
774     function safeTransfer(IERC20 token, address to, uint256 value) internal {
775         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
776     }
777 
778     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
779         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
780     }
781 
782     function safeApprove(IERC20 token, address spender, uint256 value) internal {
783         // safeApprove should only be called when setting an initial allowance,
784         // or when resetting it to zero. To increase and decrease it, use
785         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
786         // solhint-disable-next-line max-line-length
787         require((value == 0) || (token.allowance(address(this), spender) == 0),
788             "SafeERC20: approve from non-zero to non-zero allowance"
789         );
790         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
791     }
792 
793     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
794         uint256 newAllowance = token.allowance(address(this), spender).add(value);
795         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
796     }
797 
798     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
799         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
800         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
801     }
802 
803     /**
804      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
805      * on the return value: the return value is optional (but if data is returned, it must not be false).
806      * @param token The token targeted by the call.
807      * @param data The call data (encoded using abi.encode or one of its variants).
808      */
809     function _callOptionalReturn(IERC20 token, bytes memory data) private {
810         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
811         // we're implementing it ourselves.
812 
813         // A Solidity high level call has three parts:
814         //  1. The target address is checked to verify it contains contract code
815         //  2. The call itself is made, and success asserted
816         //  3. The return value is decoded, which in turn checks the size of the returned data.
817         // solhint-disable-next-line max-line-length
818         require(address(token).isContract(), "SafeERC20: call to non-contract");
819 
820         // solhint-disable-next-line avoid-low-level-calls
821         (bool success, bytes memory returndata) = address(token).call(data);
822         require(success, "SafeERC20: low-level call failed");
823 
824         if (returndata.length > 0) { // Return data is optional
825             // solhint-disable-next-line max-line-length
826             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
827         }
828     }
829 }
830 
831 // File: contracts/MxxConverter.sol
832 
833 // This program is free software: you can redistribute it and/or modify
834 // it under the terms of the GNU General Public License as published by
835 // the Free Software Foundation, either version 3 of the License, or
836 // (at your option) any later version.
837 
838 // This program is distributed in the hope that it will be useful,
839 // but WITHOUT ANY WARRANTY; without even the implied warranty of
840 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
841 // GNU General Public License for more details.
842 
843 // You should have received a copy of the GNU General Public License
844 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
845 
846 pragma solidity ^0.6.0;
847 
848 
849 
850 
851 
852 
853 /**
854  * @title Mxx Converter Contract
855  * @notice Contract to allow a user to deposit Mxx token to be converted to bMxx on the binance smart chain.
856  */
857 
858 contract MxxConverter is Ownable, ReentrancyGuard {
859     // Using SafeMath Library to prevent integer overflow
860     using SafeMath for uint256;
861 
862     // Using SafeERC20 for ERC20
863     using SafeERC20 for ERC20;
864 
865     /**
866      * @dev - A struct to store each conversion details
867      * @notice amount - The amount of Mxx to be converted
868      * @notice fromAddress - user's address on ETH chain
869      * @notice toAddress - destination address on BSC chain
870      * @notice startTime - Start Time of the conversion
871      * @notice endTime - End time of the conversion
872      * @notice status - The status of this conversion
873      */
874     struct ConversionDetails {
875         uint256 amount;
876         uint256 feePcnt;
877         address fromAddress;
878         address toAddress;
879         uint48  startTime;
880         uint48  endTime;
881         Status  status;
882     }
883 
884     /**
885      * @dev - A enum to store the status of each cobversion
886      */
887     enum Status {Invalid, New, Completed, Refunded}
888 
889     /**
890      * @dev - Events
891      */
892     event NewConversion(
893         uint256 index,
894         address indexed from,
895         address indexed to,
896         uint256 amount,
897         uint256 feePcnt,
898         uint256 timeStamp
899     );
900     event ConversionCompleted(uint256 id);
901     event ConversionRefunded(uint256 id);
902 
903     /**
904      * @dev - Variable to store Official MXX ERC20 token address
905      */
906     address public MXX_ADDRESS;
907 
908     /**
909      * @dev - Address to store the Official MXX Burn Address
910      */
911     address public BURN_ADDRESS;
912 
913     /**
914      * @dev - The grand total number of Mxx that can be converted to BSC.
915      */
916     uint256 internal constant MAX_CONVERTABLE = 415_000_000e8;
917 
918     /**
919      * @dev - The remaining amount of Mxx availabe for conversion.
920      */
921     uint256 public availableMxxAmt;
922 
923     /**
924      * @dev - An incremental number to track the index of the next conversion.
925      */
926     uint256 public index;
927 
928     /**
929      * @dev - An mapping for all conversion details.
930      */
931     mapping(uint256 => ConversionDetails) public allConversions;
932 
933     /**
934      * @dev - The fee percent for each conversion. Default is 1_000_000 (ie 1%). 1e8 is 100%
935      */
936     uint256 public feePcnt = 1_000_000;
937 
938      /**
939      * @dev - The max fee is 10%
940      */
941     uint256 public constant MAX_FEE_PCNT = 10_000_000;
942 
943     constructor(address mxx, address burnAddress) public Ownable() {
944         availableMxxAmt = MAX_CONVERTABLE;
945         MXX_ADDRESS = mxx;
946         BURN_ADDRESS = burnAddress;
947     }
948 
949     /**
950      * @dev This function allows a user to deposit Mxx and start a conversion.
951      * @param _toBscAddress - The BSC destination address.
952      * @param _amount - The amount of Mxx to convert.
953      */
954     function depositForConversion(address _toBscAddress, uint256 _amount)
955         external
956         nonReentrant()
957     {
958         require(_amount != 0, "Amount cannot be 0");
959         require(_amount <= availableMxxAmt, "Amount exceeded");
960         require(_toBscAddress != address(0), "Invalid BSC address");
961 
962         ERC20(MXX_ADDRESS).safeTransferFrom(msg.sender, address(this), _amount);
963 
964         allConversions[index] = ConversionDetails(
965             _amount,
966             feePcnt,
967             msg.sender,
968             _toBscAddress,
969             uint48(now),
970             0,
971             Status.New
972         );
973 
974         emit NewConversion(
975             index,
976             msg.sender,
977             _toBscAddress,
978             _amount,
979             feePcnt,
980             block.timestamp
981         );
982 
983         index = index.add(1);
984         availableMxxAmt = availableMxxAmt.sub(_amount);
985     }
986 
987     /**
988      * @dev This function allows owner to set a conversion as completed.
989      * @param _index - The index of the conversion
990      * Access Control: Only Owner
991      */
992     function completeConversion(uint256 _index)
993         external
994         onlyOwner()
995         nonReentrant()
996     {
997         require(_index < index, "Index out of range");
998 
999         ConversionDetails memory details = allConversions[_index];
1000         require(details.status == Status.New, "Invalid Status");
1001 
1002         ERC20(MXX_ADDRESS).safeTransfer(BURN_ADDRESS, details.amount);
1003 
1004         details.status = Status.Completed;
1005         details.endTime = uint48(now);
1006         allConversions[_index] = details;
1007 
1008         emit ConversionCompleted(_index);
1009     }
1010 
1011     /**
1012      * @dev This function allows owner to perform a refund for a conversion item.
1013      * @param _index - The index of the conversion
1014      * Access Control: Only Owner
1015      */
1016     function refund(uint256 _index) external onlyOwner() nonReentrant() {
1017         require(_index < index, "Index out of range");
1018 
1019         ConversionDetails memory details = allConversions[_index];
1020         require(details.status == Status.New, "Invalid Status");
1021 
1022         ERC20(MXX_ADDRESS).safeTransfer(details.fromAddress, details.amount);
1023 
1024         details.status = Status.Refunded;
1025         details.endTime = uint48(now);
1026         allConversions[_index] = details;
1027 
1028         emit ConversionRefunded(_index);
1029     }
1030 
1031     /**
1032      * @dev This function allows owner to set a new fee.
1033      * @param _fee - The fee
1034      * Access Control: Only Owner
1035      */
1036     function setFee(uint256 _fee) external onlyOwner() {
1037         require(_fee <= MAX_FEE_PCNT, "Max fee exceeded");
1038         feePcnt = _fee;
1039     }
1040 }