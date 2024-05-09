1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 /**
86  * @dev Optional functions from the ERC20 standard.
87  */
88 contract ERC20Detailed is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     /**
94      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
95      * these values are immutable: they can only be set once during
96      * construction.
97      */
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     /**
112      * @dev Returns the symbol of the token, usually a shorter version of the
113      * name.
114      */
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118 
119     /**
120      * @dev Returns the number of decimals used to get its user representation.
121      * For example, if `decimals` equals `2`, a balance of `505` tokens should
122      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
123      *
124      * Tokens usually opt for a value of 18, imitating the relationship between
125      * Ether and Wei.
126      *
127      * NOTE: This information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * {IERC20-balanceOf} and {IERC20-transfer}.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/GSN/Context.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /*
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with GSN meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 contract Context {
151     // Empty internal constructor, to prevent people from mistakenly deploying
152     // an instance of this contract, which should be used via inheritance.
153     constructor () internal { }
154     // solhint-disable-previous-line no-empty-blocks
155 
156     function _msgSender() internal view returns (address payable) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view returns (bytes memory) {
161         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/math/SafeMath.sol
167 
168 pragma solidity ^0.5.0;
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      *
222      * _Available since v2.4.0._
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 pragma solidity ^0.5.0;
328 
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20Mintable}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     /**
366      * @dev See {IERC20-totalSupply}.
367      */
368     function totalSupply() public view returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373      * @dev See {IERC20-balanceOf}.
374      */
375     function balanceOf(address account) public view returns (uint256) {
376         return _balances[account];
377     }
378 
379     /**
380      * @dev See {IERC20-transfer}.
381      *
382      * Requirements:
383      *
384      * - `recipient` cannot be the zero address.
385      * - the caller must have a balance of at least `amount`.
386      */
387     function transfer(address recipient, uint256 amount) public returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-allowance}.
394      */
395     function allowance(address owner, address spender) public view returns (uint256) {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See {IERC20-approve}.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 amount) public returns (bool) {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20};
416      *
417      * Requirements:
418      * - `sender` and `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      * - the caller must have allowance for `sender`'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
424         _transfer(sender, recipient, amount);
425         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
443         return true;
444     }
445 
446     /**
447      * @dev Atomically decreases the allowance granted to `spender` by the caller.
448      *
449      * This is an alternative to {approve} that can be used as a mitigation for
450      * problems described in {IERC20-approve}.
451      *
452      * Emits an {Approval} event indicating the updated allowance.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      * - `spender` must have allowance for the caller of at least
458      * `subtractedValue`.
459      */
460     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(address sender, address recipient, uint256 amount) internal {
480         require(sender != address(0), "ERC20: transfer from the zero address");
481         require(recipient != address(0), "ERC20: transfer to the zero address");
482 
483         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
484         _balances[recipient] = _balances[recipient].add(amount);
485         emit Transfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements
494      *
495      * - `to` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _totalSupply = _totalSupply.add(amount);
501         _balances[account] = _balances[account].add(amount);
502         emit Transfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _totalSupply = _totalSupply.sub(amount);
521         emit Transfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
526      *
527      * This is internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
547      * from the caller's allowance.
548      *
549      * See {_burn} and {_approve}.
550      */
551     function _burnFrom(address account, uint256 amount) internal {
552         _burn(account, amount);
553         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
554     }
555 }
556 
557 // File: @openzeppelin/contracts/ownership/Ownable.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @dev Contract module which provides a basic access control mechanism, where
563  * there is an account (an owner) that can be granted exclusive access to
564  * specific functions.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor () internal {
579         address msgSender = _msgSender();
580         _owner = msgSender;
581         emit OwnershipTransferred(address(0), msgSender);
582     }
583 
584     /**
585      * @dev Returns the address of the current owner.
586      */
587     function owner() public view returns (address) {
588         return _owner;
589     }
590 
591     /**
592      * @dev Throws if called by any account other than the owner.
593      */
594     modifier onlyOwner() {
595         require(isOwner(), "Ownable: caller is not the owner");
596         _;
597     }
598 
599     /**
600      * @dev Returns true if the caller is the current owner.
601      */
602     function isOwner() public view returns (bool) {
603         return _msgSender() == _owner;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public onlyOwner {
623         _transferOwnership(newOwner);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      */
629     function _transferOwnership(address newOwner) internal {
630         require(newOwner != address(0), "Ownable: new owner is the zero address");
631         emit OwnershipTransferred(_owner, newOwner);
632         _owner = newOwner;
633     }
634 }
635 
636 // File: contracts/managment/Constants.sol
637 
638 pragma solidity 0.5.17;
639 
640 
641 contract Constants {
642     // Permissions bit constants
643     uint256 public constant CAN_MINT_TOKENS = 0;
644     uint256 public constant CAN_BURN_TOKENS = 1;
645     uint256 public constant CAN_UPDATE_STATE = 2;
646     uint256 public constant CAN_LOCK_TOKENS = 3;
647     uint256 public constant CAN_UPDATE_PRICE = 4;
648     uint256 public constant CAN_INTERACT_WITH_ALLOCATOR = 5;
649     uint256 public constant CAN_SET_ALLOCATOR_MAX_SUPPLY = 6;
650     uint256 public constant CAN_PAUSE_TOKENS = 7;
651     uint256 public constant ECLIUDED_ADDRESSES = 8;
652     uint256 public constant WHITELISTED = 9;
653     uint256 public constant SIGNERS = 10;
654     uint256 public constant EXTERNAL_CONTRIBUTORS = 11;
655     uint256 public constant CAN_SEE_BALANCE = 12;
656     uint256 public constant CAN_CANCEL_TRANSACTION = 13;
657     uint256 public constant CAN_ALLOCATE_REFERRAL_TOKENS = 14;
658     uint256 public constant CAN_SET_REFERRAL_MAX_SUPPLY = 15;
659     uint256 public constant MANUAL_TOKENS_ALLOCATION = 16;
660     uint256 public constant CAN_SET_WHITELISTED = 17;
661 
662     // Contract Registry keys
663     uint256 public constant CONTRACT_TOKEN = 1;
664     uint256 public constant CONTRACT_PRICING = 2;
665     uint256 public constant CONTRACT_CROWDSALE = 3;
666     uint256 public constant CONTRACT_ALLOCATOR = 4;
667     uint256 public constant CONTRACT_AGENT = 5;
668     uint256 public constant CONTRACT_FORWARDER = 6;
669     uint256 public constant CONTRACT_REFERRAL = 7;
670     uint256 public constant CONTRACT_STATS = 8;
671     uint256 public constant CONTRACT_LOCKUP = 9;
672 
673     uint256 public constant YEAR_IN_SECONDS = 31556952;
674     uint256 public constant SIX_MONTHS =  15778476;
675     uint256 public constant MONTH_IN_SECONDS = 2629746;
676 
677     string public constant ERROR_ACCESS_DENIED = "ERROR_ACCESS_DENIED";
678     string public constant ERROR_WRONG_AMOUNT = "ERROR_WRONG_AMOUNT";
679     string public constant ERROR_NO_CONTRACT = "ERROR_NO_CONTRACT";
680     string public constant ERROR_NOT_AVAILABLE = "ERROR_NOT_AVAILABLE";
681 }
682 
683 // File: contracts/managment/Management.sol
684 
685 pragma solidity 0.5.17;
686 
687 
688 
689 
690 contract Management is Ownable, Constants {
691 
692     // Contract Registry
693     mapping (uint256 => address payable) public contractRegistry;
694 
695     // Permissions
696     mapping (address => mapping(uint256 => bool)) public permissions;
697 
698     event PermissionsSet(
699         address subject, 
700         uint256 permission, 
701         bool value
702     );
703 
704     event ContractRegistered(
705         uint256 key,
706         address source,
707         address target
708     );
709 
710     function setPermission(
711         address _address, 
712         uint256 _permission, 
713         bool _value
714     )
715         public
716         onlyOwner
717     {
718         permissions[_address][_permission] = _value;
719         emit PermissionsSet(_address, _permission, _value);
720     }
721 
722     function registerContract(
723         uint256 _key, 
724         address payable _target
725     ) 
726         public 
727         onlyOwner 
728     {
729         contractRegistry[_key] = _target;
730         emit ContractRegistered(_key, address(0), _target);
731     }
732 
733     function setWhitelisted(
734         address _address,
735         bool _value
736     )
737         public
738     {
739         require(
740             permissions[msg.sender][CAN_SET_WHITELISTED] == true,
741             ERROR_ACCESS_DENIED
742         );
743 
744         permissions[_address][WHITELISTED] = _value;
745 
746         emit PermissionsSet(_address, WHITELISTED, _value);
747     }
748 
749 }
750 
751 // File: contracts/managment/Managed.sol
752 
753 pragma solidity 0.5.17;
754 
755 
756 
757 
758 
759 
760 contract Managed is Ownable, Constants {
761 
762     using SafeMath for uint256;
763 
764     Management public management;
765 
766     modifier requirePermission(uint256 _permissionBit) {
767         require(
768             hasPermission(msg.sender, _permissionBit),
769             ERROR_ACCESS_DENIED
770         );
771         _;
772     }
773 
774     modifier canCallOnlyRegisteredContract(uint256 _key) {
775         require(
776             msg.sender == management.contractRegistry(_key),
777             ERROR_ACCESS_DENIED
778         );
779         _;
780     }
781 
782     modifier requireContractExistsInRegistry(uint256 _key) {
783         require(
784             management.contractRegistry(_key) != address(0),
785             ERROR_NO_CONTRACT
786         );
787         _;
788     }
789 
790     constructor(address _managementAddress) public {
791         management = Management(_managementAddress);
792     }
793 
794     function setManagementContract(address _management) public onlyOwner {
795         require(address(0) != _management, ERROR_NO_CONTRACT);
796 
797         management = Management(_management);
798     }
799 
800     function hasPermission(address _subject, uint256 _permissionBit)
801         internal
802         view
803         returns (bool)
804     {
805         return management.permissions(_subject, _permissionBit);
806     }
807 
808 }
809 
810 // File: contracts/LockupContract.sol
811 
812 pragma solidity 0.5.17;
813 
814 
815 
816 
817 contract LockupContract is Managed {
818     using SafeMath for uint256;
819 
820     uint256 public constant PERCENT_ABS_MAX = 100;
821     bool public isPostponedStart;
822     uint256 public postponedStartDate;
823 
824     mapping(address => uint256[]) public lockedAllocationData;
825 
826     mapping(address => uint256) public manuallyLockedBalances;
827 
828     event Lock(address holderAddress, uint256 amount);
829 
830     constructor(address _management) public Managed(_management) {
831         isPostponedStart = true;
832     }
833 
834     function isTransferAllowed(
835         address _address,
836         uint256 _value,
837         uint256 _time,
838         uint256 _holderBalance
839     )
840     external
841     view
842     returns (bool)
843     {
844         uint256 unlockedBalance = getUnlockedBalance(
845             _address,
846             _time,
847             _holderBalance
848         );
849         if (unlockedBalance >= _value) {
850             return true;
851         }
852         return false;
853     }
854 
855     function allocationLog(
856         address _address,
857         uint256 _amount,
858         uint256 _startingAt,
859         uint256 _lockPeriodInSeconds,
860         uint256 _initialUnlockInPercent,
861         uint256 _releasePeriodInSeconds
862     )
863         public
864         requirePermission(CAN_LOCK_TOKENS)
865     {
866         lockedAllocationData[_address].push(_startingAt);
867         if (_initialUnlockInPercent > 0) {
868             _amount = _amount.mul(uint256(PERCENT_ABS_MAX)
869                 .sub(_initialUnlockInPercent)).div(PERCENT_ABS_MAX);
870         }
871         lockedAllocationData[_address].push(_amount);
872         lockedAllocationData[_address].push(_lockPeriodInSeconds);
873         lockedAllocationData[_address].push(_releasePeriodInSeconds);
874         emit Lock(_address, _amount);
875     }
876 
877     function getUnlockedBalance(
878         address _address,
879         uint256 _time,
880         uint256 _holderBalance
881     )
882         public
883         view
884         returns (uint256)
885     {
886         uint256 blockedAmount = manuallyLockedBalances[_address];
887 
888         if (lockedAllocationData[_address].length == 0) {
889             return _holderBalance.sub(blockedAmount);
890         }
891         uint256[] memory  addressLockupData = lockedAllocationData[_address];
892         for (uint256 i = 0; i < addressLockupData.length / 4; i++) {
893             uint256 lockedAt = addressLockupData[i.mul(4)];
894             uint256 lockedBalance = addressLockupData[i.mul(4).add(1)];
895             uint256 lockPeriodInSeconds = addressLockupData[i.mul(4).add(2)];
896             uint256 _releasePeriodInSeconds = addressLockupData[
897                 i.mul(4).add(3)
898             ];
899             if (lockedAt == 0 && true == isPostponedStart) {
900                 if (postponedStartDate == 0) {
901                     blockedAmount = blockedAmount.add(lockedBalance);
902                     continue;
903                 }
904                 lockedAt = postponedStartDate;
905             }
906             if (lockedAt > _time) {
907                 blockedAmount = blockedAmount.add(lockedBalance);
908                 continue;
909             }
910             if (lockedAt.add(lockPeriodInSeconds) > _time) {
911                 if (lockedBalance == 0) {
912                     blockedAmount = _holderBalance;
913                     break;
914                 } else {
915                     uint256 tokensUnlocked;
916                     if (_releasePeriodInSeconds > 0) {
917                         uint256 duration = (_time.sub(lockedAt))
918                             .div(_releasePeriodInSeconds);
919                         tokensUnlocked = lockedBalance.mul(duration)
920                             .mul(_releasePeriodInSeconds)
921                             .div(lockPeriodInSeconds);
922                     }
923                     blockedAmount = blockedAmount
924                         .add(lockedBalance)
925                         .sub(tokensUnlocked);
926                 }
927             }
928         }
929 
930         return _holderBalance.sub(blockedAmount);
931     }
932 
933     function setManuallyLockedForAddress (
934         address _holder,
935         uint256 _balance
936     )
937         public
938         requirePermission(CAN_LOCK_TOKENS)
939     {
940         manuallyLockedBalances[_holder] = _balance;
941     }
942 
943     function setPostponedStartDate(uint256 _postponedStartDate)
944         public
945         requirePermission(CAN_LOCK_TOKENS)
946     {
947         postponedStartDate = _postponedStartDate;
948 
949     }
950 }
951 
952 // File: @openzeppelin/contracts/access/Roles.sol
953 
954 pragma solidity ^0.5.0;
955 
956 /**
957  * @title Roles
958  * @dev Library for managing addresses assigned to a Role.
959  */
960 library Roles {
961     struct Role {
962         mapping (address => bool) bearer;
963     }
964 
965     /**
966      * @dev Give an account access to this role.
967      */
968     function add(Role storage role, address account) internal {
969         require(!has(role, account), "Roles: account already has role");
970         role.bearer[account] = true;
971     }
972 
973     /**
974      * @dev Remove an account's access to this role.
975      */
976     function remove(Role storage role, address account) internal {
977         require(has(role, account), "Roles: account does not have role");
978         role.bearer[account] = false;
979     }
980 
981     /**
982      * @dev Check if an account has this role.
983      * @return bool
984      */
985     function has(Role storage role, address account) internal view returns (bool) {
986         require(account != address(0), "Roles: account is the zero address");
987         return role.bearer[account];
988     }
989 }
990 
991 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
992 
993 pragma solidity ^0.5.0;
994 
995 
996 
997 contract MinterRole is Context {
998     using Roles for Roles.Role;
999 
1000     event MinterAdded(address indexed account);
1001     event MinterRemoved(address indexed account);
1002 
1003     Roles.Role private _minters;
1004 
1005     constructor () internal {
1006         _addMinter(_msgSender());
1007     }
1008 
1009     modifier onlyMinter() {
1010         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1011         _;
1012     }
1013 
1014     function isMinter(address account) public view returns (bool) {
1015         return _minters.has(account);
1016     }
1017 
1018     function addMinter(address account) public onlyMinter {
1019         _addMinter(account);
1020     }
1021 
1022     function renounceMinter() public {
1023         _removeMinter(_msgSender());
1024     }
1025 
1026     function _addMinter(address account) internal {
1027         _minters.add(account);
1028         emit MinterAdded(account);
1029     }
1030 
1031     function _removeMinter(address account) internal {
1032         _minters.remove(account);
1033         emit MinterRemoved(account);
1034     }
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1038 
1039 pragma solidity ^0.5.0;
1040 
1041 
1042 
1043 /**
1044  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1045  * which have permission to mint (create) new tokens as they see fit.
1046  *
1047  * At construction, the deployer of the contract is the only minter.
1048  */
1049 contract ERC20Mintable is ERC20, MinterRole {
1050     /**
1051      * @dev See {ERC20-_mint}.
1052      *
1053      * Requirements:
1054      *
1055      * - the caller must have the {MinterRole}.
1056      */
1057     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1058         _mint(account, amount);
1059         return true;
1060     }
1061 }
1062 
1063 // File: contracts/allocator/TokenAllocator.sol
1064 
1065 pragma solidity 0.5.17;
1066 
1067 
1068 
1069 /// @title TokenAllocator
1070 /// @author Applicature
1071 /// @notice Contract responsible for defining distribution logic of tokens.
1072 /// @dev Base class
1073 contract TokenAllocator is Managed {
1074 
1075     uint256 public maxSupply;
1076 
1077     constructor(uint256 _maxSupply, address _management)
1078         public
1079         Managed(_management)
1080     {
1081         maxSupply = _maxSupply;
1082     }
1083 
1084     function allocate(
1085         address _holder,
1086         uint256 _tokens,
1087         uint256 _allocatedTokens
1088     )
1089         public
1090         requirePermission(CAN_INTERACT_WITH_ALLOCATOR)
1091     {
1092         require(
1093             tokensAvailable(_allocatedTokens) >= _tokens,
1094             ERROR_WRONG_AMOUNT
1095         );
1096         internalAllocate(_holder, _tokens);
1097     }
1098 
1099     function updateMaxSupply(uint256 _maxSupply)
1100         internal
1101         requirePermission(CAN_INTERACT_WITH_ALLOCATOR)
1102     {
1103         maxSupply = _maxSupply;
1104     }
1105 
1106     /// @notice Check whether contract is initialised
1107     /// @return true if initialized
1108     function isInitialized() public view returns (bool) {
1109         if (
1110             address(management) == address(0) ||
1111             management.contractRegistry(CONTRACT_TOKEN) == address(0) ||
1112             management.contractRegistry(CONTRACT_ALLOCATOR) != address(this)
1113         ) {
1114             return false;
1115         }
1116         return true;
1117     }
1118 
1119     /// @return available tokens
1120     function tokensAvailable(uint256 _allocatedTokens)
1121         public
1122         view
1123         returns (uint256)
1124     {
1125         return maxSupply.sub(_allocatedTokens);
1126     }
1127 
1128     function internalAllocate(
1129         address _holder,
1130         uint256 _tokens
1131     )
1132         internal;
1133 }
1134 
1135 // File: contracts/allocator/MintableTokenAllocator.sol
1136 
1137 pragma solidity 0.5.17;
1138 
1139 
1140 
1141 
1142 /// @title MintableTokenAllocator
1143 /// @author Applicature
1144 /// @notice Contract responsible for defining distribution logic of tokens.
1145 /// @dev implementation
1146 contract MintableTokenAllocator is TokenAllocator {
1147 
1148     constructor(uint256 _maxSupply, address _management)
1149         public
1150         TokenAllocator(_maxSupply, _management)
1151     {}
1152 
1153     /// @notice Check whether contract is initialised
1154     /// @return true if initialized
1155     function isInitialized() public view returns (bool) {
1156         return (
1157             super.isInitialized() &&
1158             hasPermission(address(this), CAN_MINT_TOKENS)
1159         );
1160     }
1161 
1162 
1163     function decreaseCap(uint256 _valueToSubtract)
1164         public
1165         requirePermission(CAN_INTERACT_WITH_ALLOCATOR)
1166         requireContractExistsInRegistry(CONTRACT_TOKEN)
1167     {
1168         require(
1169             maxSupply.sub(_valueToSubtract) >= ERC20Mintable(
1170                 management.contractRegistry(CONTRACT_TOKEN)
1171             ).totalSupply(),
1172             ERROR_WRONG_AMOUNT
1173         );
1174         updateMaxSupply(maxSupply.sub(_valueToSubtract));
1175     }
1176 
1177     function internalAllocate(
1178         address _holder,
1179         uint256 _tokens
1180     )
1181         internal
1182         requireContractExistsInRegistry(CONTRACT_TOKEN)
1183         requirePermission(CAN_INTERACT_WITH_ALLOCATOR)
1184     {
1185         ERC20Mintable(management.contractRegistry(CONTRACT_TOKEN))
1186             .mint(_holder, _tokens);
1187     }
1188 
1189 }
1190 
1191 // File: contracts/CLIAllocator.sol
1192 
1193 pragma solidity 0.5.17;
1194 
1195 
1196 
1197 
1198 contract CLIAllocator is MintableTokenAllocator {
1199 
1200     /* solium-disable */
1201     address public constant strategicPartners = 0xd5249aB86Ef7cE0651DF1b111E607f59950514c3;
1202     address public constant promotionsBounty = 0x38069DD2C6D385a7dE7dbB90eF74E23B12D124e3;
1203     address public constant shareholders = 0xA210F19b4C1c52dB213f88fdCA76fD83859052FA;
1204     address public constant advisors = 0x5d6019C130158FC00bc4Dc1edc949Fa84b8ad098;
1205     address public constant pharmaIndustrialTrials = 0x880574A5b701e017C254840063DFBd1f59dF9a15;
1206     address public constant managementTeam = 0x1e2Ce74Bc0a9A9fB2D6b3f630d585E0c00FF66B0;
1207     address public constant teamIncentive = 0xD4184B19170af014c595EF0b0321760d89918B95;
1208     address public constant publicSaleTokensHolder = 0x9ED362b5A8aF29CBC06548ba5C2f40978ca48Ec1;
1209     address public constant applicature = 0x63e638d15462037161003a6083A9c4AeD50f8F73;
1210 
1211     uint256 public constant strategicPartnersTokensAmount = 20000000e18;
1212     uint256 public constant promotionsBountyTokensAmount = 5200000e18;
1213     uint256 public constant shareholdersTokensAmount = 25000000e18;
1214     uint256 public constant advisorsTokensAmount = 8000000e18;
1215     uint256 public constant applicatureTokensAmount = 2000000e18;
1216     uint256 public constant pharmaIndustrialTrialsTokensAmount = 10000000e18;
1217     uint256 public constant managementTeamTokensAmount = 25000000e18;
1218     uint256 public constant teamIncentiveTokensAmount = 24000000e18;
1219     uint256 public constant publicSaleTokensAmount = 60000000e18;
1220     /* solium-enable */
1221 
1222     bool public isAllocated;
1223 
1224     constructor(uint256 _maxSupply, address _management)
1225         public
1226         MintableTokenAllocator(_maxSupply, _management)
1227     {
1228 
1229     }
1230 
1231     function increasePublicSaleCap(uint256 valueToAdd)
1232         external
1233         canCallOnlyRegisteredContract(CONTRACT_CROWDSALE)
1234     {
1235         internalAllocate(publicSaleTokensHolder, valueToAdd);
1236     }
1237 
1238     function unlockManuallyLockedBalances(address _holder)
1239         public
1240         requirePermission(CAN_LOCK_TOKENS)
1241     {
1242         LockupContract lockupContract = LockupContract(
1243             management.contractRegistry(CONTRACT_LOCKUP)
1244         );
1245         lockupContract.setManuallyLockedForAddress(
1246             _holder,
1247             0
1248         );
1249     }
1250 
1251     function allocateRequiredTokensToHolders() public {
1252         require(isAllocated == false, ERROR_NOT_AVAILABLE);
1253         isAllocated = true;
1254         allocateTokensWithSimpleLockUp();
1255         allocateTokensWithComplicatedLockup();
1256         allocateTokensWithManualUnlock();
1257         allocatePublicSale();
1258     }
1259 
1260     function allocatePublicSale() private {
1261         internalAllocate(publicSaleTokensHolder, publicSaleTokensAmount);
1262     }
1263 
1264     function allocateTokensWithSimpleLockUp() private {
1265         LockupContract lockupContract = LockupContract(
1266             management.contractRegistry(CONTRACT_LOCKUP)
1267         );
1268         internalAllocate(strategicPartners, strategicPartnersTokensAmount);
1269 
1270         internalAllocate(promotionsBounty, promotionsBountyTokensAmount);
1271         lockupContract.allocationLog(
1272             promotionsBounty,
1273             promotionsBountyTokensAmount,
1274             0,
1275             SIX_MONTHS,
1276             0,
1277             SIX_MONTHS
1278         );
1279         internalAllocate(advisors, advisorsTokensAmount);
1280         lockupContract.allocationLog(
1281             advisors,
1282             advisorsTokensAmount,
1283             0,
1284             SIX_MONTHS,
1285             0,
1286             SIX_MONTHS
1287         );
1288         internalAllocate(applicature, applicatureTokensAmount);
1289         // 25% each  6 months
1290         lockupContract.allocationLog(
1291             applicature,
1292             applicatureTokensAmount,
1293             0,
1294             SIX_MONTHS.mul(4),
1295             0,
1296             SIX_MONTHS
1297         );
1298     }
1299 
1300     function allocateTokensWithComplicatedLockup() private {
1301         LockupContract lockupContract = LockupContract(
1302             management.contractRegistry(CONTRACT_LOCKUP)
1303         );
1304 
1305         internalAllocate(shareholders, shareholdersTokensAmount);
1306         lockupContract.allocationLog(
1307             shareholders,
1308             shareholdersTokensAmount.div(5),
1309             0,
1310             SIX_MONTHS,
1311             0,
1312             SIX_MONTHS
1313         );
1314         lockupContract.allocationLog(
1315             shareholders,
1316             shareholdersTokensAmount.sub(shareholdersTokensAmount.div(5)),
1317             0,
1318             uint256(48).mul(MONTH_IN_SECONDS),
1319             0,
1320             YEAR_IN_SECONDS
1321         );
1322 
1323         internalAllocate(managementTeam, managementTeamTokensAmount);
1324         lockupContract.allocationLog(
1325             managementTeam,
1326             managementTeamTokensAmount.mul(2).div(5),
1327             0,
1328             SIX_MONTHS,
1329             50,
1330             SIX_MONTHS
1331         );
1332         lockupContract.allocationLog(
1333             managementTeam,
1334             managementTeamTokensAmount.sub(
1335                 managementTeamTokensAmount.mul(2).div(5)
1336             ),
1337             0,
1338             uint256(36).mul(MONTH_IN_SECONDS),
1339             0,
1340             YEAR_IN_SECONDS
1341         );
1342     }
1343 
1344     function allocateTokensWithManualUnlock() private {
1345         LockupContract lockupContract = LockupContract(
1346             management.contractRegistry(CONTRACT_LOCKUP)
1347         );
1348 
1349         internalAllocate(
1350             pharmaIndustrialTrials,
1351             pharmaIndustrialTrialsTokensAmount
1352         );
1353         lockupContract.setManuallyLockedForAddress(
1354             pharmaIndustrialTrials,
1355             pharmaIndustrialTrialsTokensAmount
1356         );
1357         internalAllocate(teamIncentive, teamIncentiveTokensAmount);
1358         lockupContract.setManuallyLockedForAddress(
1359             teamIncentive,
1360             teamIncentiveTokensAmount
1361         );
1362     }
1363 }
1364 
1365 // File: contracts/CLIToken.sol
1366 
1367 pragma solidity 0.5.17;
1368 
1369 
1370 
1371 
1372 
1373 
1374 
1375 contract CLIToken is ERC20, ERC20Detailed, Managed {
1376 
1377     modifier requireUnlockedBalance(
1378         address _address,
1379         uint256 _value,
1380         uint256 _time,
1381         uint256 _holderBalance
1382     ) {
1383 
1384         require(
1385             LockupContract(
1386                 management.contractRegistry(CONTRACT_LOCKUP)
1387             ).isTransferAllowed(
1388                 _address,
1389                 _value,
1390                 _time,
1391                 _holderBalance
1392             ),
1393             ERROR_NOT_AVAILABLE
1394         );
1395         _;
1396     }
1397 
1398     constructor(
1399         address _management
1400     )
1401         public
1402         ERC20Detailed("ClinTex", "CTI", 18)
1403         Managed(_management)
1404     {
1405         _mint(0x8FAE27b50457C10556C45798c34f73AE263282a6, 151000000000000000);
1406     }
1407 
1408     function mint(
1409         address _account,
1410         uint256 _amount
1411     )
1412         public
1413         requirePermission(CAN_MINT_TOKENS)
1414         canCallOnlyRegisteredContract(CONTRACT_ALLOCATOR)
1415         returns (bool)
1416     {
1417         require(
1418             _amount <= CLIAllocator(
1419                 management.contractRegistry(CONTRACT_ALLOCATOR)
1420             ).tokensAvailable(totalSupply()),
1421             ERROR_WRONG_AMOUNT
1422         );
1423         _mint(_account, _amount);
1424         return true;
1425     }
1426 
1427     function transfer(
1428         address _to,
1429         uint256 _tokens
1430     )
1431         public
1432         requireUnlockedBalance(
1433             msg.sender,
1434             _tokens,
1435             block.timestamp,
1436             balanceOf(msg.sender)
1437         )
1438         returns (bool)
1439     {
1440         super.transfer(_to, _tokens);
1441 
1442         return true;
1443     }
1444 
1445     function transferFrom(
1446         address _holder,
1447         address _to,
1448         uint256 _tokens
1449     )
1450         public
1451         requireUnlockedBalance(
1452             _holder,
1453             _tokens,
1454             block.timestamp,
1455             balanceOf(_holder)
1456         )
1457         returns (bool)
1458     {
1459         super.transferFrom(_holder, _to, _tokens);
1460 
1461         return true;
1462     }
1463 
1464     function burn(uint256 value)
1465         public
1466         requirePermission(CAN_BURN_TOKENS)
1467         requireUnlockedBalance(
1468             msg.sender,
1469             value,
1470             block.timestamp,
1471             balanceOf(msg.sender)
1472         )
1473     {
1474         require(balanceOf(msg.sender) >= value, ERROR_WRONG_AMOUNT);
1475         super._burn(msg.sender, value);
1476     }
1477 }