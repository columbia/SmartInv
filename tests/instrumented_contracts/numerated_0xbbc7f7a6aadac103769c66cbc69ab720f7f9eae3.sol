1 // File: contracts/1404/IERC1404.sol
2 
3 pragma solidity 0.5.8;
4 
5 interface IERC1404 {
6     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
7     /// @param from Sending address
8     /// @param to Receiving address
9     /// @param value Amount of tokens being transferred
10     /// @return Code by which to reference message for rejection reasoning
11     /// @dev Overwrite with your custom transfer restriction logic
12     function detectTransferRestriction (address from, address to, uint256 value) external view returns (uint8);
13 
14     /// @notice Detects if a transferFrom will be reverted and if so returns an appropriate reference code
15     /// @param sender Transaction sending address
16     /// @param from Source of funds address
17     /// @param to Receiving address
18     /// @param value Amount of tokens being transferred
19     /// @return Code by which to reference message for rejection reasoning
20     /// @dev Overwrite with your custom transfer restriction logic
21     function detectTransferFromRestriction (address sender, address from, address to, uint256 value) external view returns (uint8);
22 
23     /// @notice Returns a human-readable message for a given restriction code
24     /// @param restrictionCode Identifier for looking up a message
25     /// @return Text showing the restriction's reasoning
26     /// @dev Overwrite with your custom message and restrictionCode handling
27     function messageForTransferRestriction (uint8 restrictionCode) external view returns (string memory);
28 }
29 
30 interface IERC1404getSuccessCode {
31     /// @notice Return the uint256 that represents the SUCCESS_CODE
32     /// @return uint256 SUCCESS_CODE
33     function getSuccessCode () external view returns (uint256);
34 }
35 
36 /**
37  * @title IERC1404Success
38  * @dev Combines IERC1404 and IERC1404getSuccessCode interfaces, to be implemented by the TransferRestrictions contract
39  */
40 contract IERC1404Success is IERC1404getSuccessCode, IERC1404 {
41 }
42 
43 // File: contracts/1404/IERC1404Validators.sol
44 
45 pragma solidity 0.5.8;
46 
47 /**
48  * @title IERC1404Validators
49  * @dev Interfaces implemented by the token contract to be called by the TransferRestrictions contract
50  */
51 interface IERC1404Validators {
52     /// @notice Returns the token balance for an account
53     /// @param account The address to get the token balance of
54     /// @return uint256 representing the token balance for the account
55     function balanceOf (address account) external view returns (uint256);
56 
57     /// @notice Returns a boolean indicating the paused state of the contract
58     /// @return true if contract is paused, false if unpaused
59     function paused () external view returns (bool);
60 
61     /// @notice Determine if sender and receiver are whitelisted, return true if both accounts are whitelisted
62     /// @param from The address sending tokens.
63     /// @param to The address receiving tokens.
64     /// @return true if both accounts are whitelisted, false if not
65     function checkWhitelists (address from, address to) external view returns (bool);
66 
67     /// @notice Determine if a users tokens are locked preventing a transfer
68     /// @param _address the address to retrieve the data from
69     /// @param amount the amount to send
70     /// @param balance the token balance of the sending account
71     /// @return true if user has sufficient unlocked token to transfer the requested amount, false if not
72     function checkTimelock (address _address, uint256 amount, uint256 balance) external view returns (bool);
73 }
74 
75 // File: @openzeppelin/contracts/access/Roles.sol
76 
77 pragma solidity ^0.5.0;
78 
79 /**
80  * @title Roles
81  * @dev Library for managing addresses assigned to a Role.
82  */
83 library Roles {
84     struct Role {
85         mapping (address => bool) bearer;
86     }
87 
88     /**
89      * @dev Give an account access to this role.
90      */
91     function add(Role storage role, address account) internal {
92         require(!has(role, account), "Roles: account already has role");
93         role.bearer[account] = true;
94     }
95 
96     /**
97      * @dev Remove an account's access to this role.
98      */
99     function remove(Role storage role, address account) internal {
100         require(has(role, account), "Roles: account does not have role");
101         role.bearer[account] = false;
102     }
103 
104     /**
105      * @dev Check if an account has this role.
106      * @return bool
107      */
108     function has(Role storage role, address account) internal view returns (bool) {
109         require(account != address(0), "Roles: account is the zero address");
110         return role.bearer[account];
111     }
112 }
113 
114 // File: contracts/roles/OwnerRole.sol
115 
116 pragma solidity 0.5.8;
117 
118 
119 contract OwnerRole {
120     using Roles for Roles.Role;
121 
122     event OwnerAdded(address indexed addedOwner, address indexed addedBy);
123     event OwnerRemoved(address indexed removedOwner, address indexed removedBy);
124 
125     Roles.Role private _owners;
126 
127     modifier onlyOwner() {
128         require(isOwner(msg.sender), "OwnerRole: caller does not have the Owner role");
129         _;
130     }
131 
132     function isOwner(address account) public view returns (bool) {
133         return _owners.has(account);
134     }
135 
136     function addOwner(address account) public onlyOwner {
137         _addOwner(account);
138     }
139 
140     function removeOwner(address account) public onlyOwner {
141         require(msg.sender != account, "Owners cannot remove themselves as owner");
142         _removeOwner(account);
143     }
144 
145     function _addOwner(address account) internal {
146         _owners.add(account);
147         emit OwnerAdded(account, msg.sender);
148     }
149 
150     function _removeOwner(address account) internal {
151         _owners.remove(account);
152         emit OwnerRemoved(account, msg.sender);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/GSN/Context.sol
157 
158 pragma solidity ^0.5.0;
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 contract Context {
171     // Empty internal constructor, to prevent people from mistakenly deploying
172     // an instance of this contract, which should be used via inheritance.
173     constructor () internal { }
174     // solhint-disable-previous-line no-empty-blocks
175 
176     function _msgSender() internal view returns (address payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view returns (bytes memory) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
187 
188 pragma solidity ^0.5.0;
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
192  * the optional functions; to access them see {ERC20Detailed}.
193  */
194 interface IERC20 {
195     /**
196      * @dev Returns the amount of tokens in existence.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns the amount of tokens owned by `account`.
202      */
203     function balanceOf(address account) external view returns (uint256);
204 
205     /**
206      * @dev Moves `amount` tokens from the caller's account to `recipient`.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transfer(address recipient, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Returns the remaining number of tokens that `spender` will be
216      * allowed to spend on behalf of `owner` through {transferFrom}. This is
217      * zero by default.
218      *
219      * This value changes when {approve} or {transferFrom} are called.
220      */
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     /**
224      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * IMPORTANT: Beware that changing an allowance with this method brings the risk
229      * that someone may use both the old and the new allowance by unfortunate
230      * transaction ordering. One possible solution to mitigate this race
231      * condition is to first reduce the spender's allowance to 0 and set the
232      * desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address spender, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Moves `amount` tokens from `sender` to `recipient` using the
241      * allowance mechanism. `amount` is then deducted from the caller's
242      * allowance.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Emitted when `value` tokens are moved from one account (`from`) to
252      * another (`to`).
253      *
254      * Note that `value` may be zero.
255      */
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 
258     /**
259      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
260      * a call to {approve}. `value` is the new allowance.
261      */
262     event Approval(address indexed owner, address indexed spender, uint256 value);
263 }
264 
265 // File: @openzeppelin/contracts/math/SafeMath.sol
266 
267 pragma solidity ^0.5.0;
268 
269 /**
270  * @dev Wrappers over Solidity's arithmetic operations with added overflow
271  * checks.
272  *
273  * Arithmetic operations in Solidity wrap on overflow. This can easily result
274  * in bugs, because programmers usually assume that an overflow raises an
275  * error, which is the standard behavior in high level programming languages.
276  * `SafeMath` restores this intuition by reverting the transaction when an
277  * operation overflows.
278  *
279  * Using this library instead of the unchecked operations eliminates an entire
280  * class of bugs, so it's recommended to use it always.
281  */
282 library SafeMath {
283     /**
284      * @dev Returns the addition of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `+` operator.
288      *
289      * Requirements:
290      * - Addition cannot overflow.
291      */
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         uint256 c = a + b;
294         require(c >= a, "SafeMath: addition overflow");
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      * - Subtraction cannot overflow.
307      */
308     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309         return sub(a, b, "SafeMath: subtraction overflow");
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      * - Subtraction cannot overflow.
320      *
321      * _Available since v2.4.0._
322      */
323     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b <= a, errorMessage);
325         uint256 c = a - b;
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the multiplication of two unsigned integers, reverting on
332      * overflow.
333      *
334      * Counterpart to Solidity's `*` operator.
335      *
336      * Requirements:
337      * - Multiplication cannot overflow.
338      */
339     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
340         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341         // benefit is lost if 'b' is also tested.
342         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
343         if (a == 0) {
344             return 0;
345         }
346 
347         uint256 c = a * b;
348         require(c / a == b, "SafeMath: multiplication overflow");
349 
350         return c;
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers. Reverts on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator. Note: this function uses a
358      * `revert` opcode (which leaves remaining gas untouched) while Solidity
359      * uses an invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      * - The divisor cannot be zero.
363      */
364     function div(uint256 a, uint256 b) internal pure returns (uint256) {
365         return div(a, b, "SafeMath: division by zero");
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      * - The divisor cannot be zero.
378      *
379      * _Available since v2.4.0._
380      */
381     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
382         // Solidity only automatically asserts when dividing by 0
383         require(b > 0, errorMessage);
384         uint256 c = a / b;
385         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
386 
387         return c;
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * Reverts when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      * - The divisor cannot be zero.
400      */
401     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
402         return mod(a, b, "SafeMath: modulo by zero");
403     }
404 
405     /**
406      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
407      * Reverts with custom message when dividing by zero.
408      *
409      * Counterpart to Solidity's `%` operator. This function uses a `revert`
410      * opcode (which leaves remaining gas untouched) while Solidity uses an
411      * invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      * - The divisor cannot be zero.
415      *
416      * _Available since v2.4.0._
417      */
418     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
419         require(b != 0, errorMessage);
420         return a % b;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 
430 
431 /**
432  * @dev Implementation of the {IERC20} interface.
433  *
434  * This implementation is agnostic to the way tokens are created. This means
435  * that a supply mechanism has to be added in a derived contract using {_mint}.
436  * For a generic mechanism see {ERC20Mintable}.
437  *
438  * TIP: For a detailed writeup see our guide
439  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
440  * to implement supply mechanisms].
441  *
442  * We have followed general OpenZeppelin guidelines: functions revert instead
443  * of returning `false` on failure. This behavior is nonetheless conventional
444  * and does not conflict with the expectations of ERC20 applications.
445  *
446  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
447  * This allows applications to reconstruct the allowance for all accounts just
448  * by listening to said events. Other implementations of the EIP may not emit
449  * these events, as it isn't required by the specification.
450  *
451  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
452  * functions have been added to mitigate the well-known issues around setting
453  * allowances. See {IERC20-approve}.
454  */
455 contract ERC20 is Context, IERC20 {
456     using SafeMath for uint256;
457 
458     mapping (address => uint256) private _balances;
459 
460     mapping (address => mapping (address => uint256)) private _allowances;
461 
462     uint256 private _totalSupply;
463 
464     /**
465      * @dev See {IERC20-totalSupply}.
466      */
467     function totalSupply() public view returns (uint256) {
468         return _totalSupply;
469     }
470 
471     /**
472      * @dev See {IERC20-balanceOf}.
473      */
474     function balanceOf(address account) public view returns (uint256) {
475         return _balances[account];
476     }
477 
478     /**
479      * @dev See {IERC20-transfer}.
480      *
481      * Requirements:
482      *
483      * - `recipient` cannot be the zero address.
484      * - the caller must have a balance of at least `amount`.
485      */
486     function transfer(address recipient, uint256 amount) public returns (bool) {
487         _transfer(_msgSender(), recipient, amount);
488         return true;
489     }
490 
491     /**
492      * @dev See {IERC20-allowance}.
493      */
494     function allowance(address owner, address spender) public view returns (uint256) {
495         return _allowances[owner][spender];
496     }
497 
498     /**
499      * @dev See {IERC20-approve}.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      */
505     function approve(address spender, uint256 amount) public returns (bool) {
506         _approve(_msgSender(), spender, amount);
507         return true;
508     }
509 
510     /**
511      * @dev See {IERC20-transferFrom}.
512      *
513      * Emits an {Approval} event indicating the updated allowance. This is not
514      * required by the EIP. See the note at the beginning of {ERC20};
515      *
516      * Requirements:
517      * - `sender` and `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      * - the caller must have allowance for `sender`'s tokens of at least
520      * `amount`.
521      */
522     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
523         _transfer(sender, recipient, amount);
524         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
525         return true;
526     }
527 
528     /**
529      * @dev Atomically increases the allowance granted to `spender` by the caller.
530      *
531      * This is an alternative to {approve} that can be used as a mitigation for
532      * problems described in {IERC20-approve}.
533      *
534      * Emits an {Approval} event indicating the updated allowance.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
541         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
542         return true;
543     }
544 
545     /**
546      * @dev Atomically decreases the allowance granted to `spender` by the caller.
547      *
548      * This is an alternative to {approve} that can be used as a mitigation for
549      * problems described in {IERC20-approve}.
550      *
551      * Emits an {Approval} event indicating the updated allowance.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      * - `spender` must have allowance for the caller of at least
557      * `subtractedValue`.
558      */
559     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
561         return true;
562     }
563 
564     /**
565      * @dev Moves tokens `amount` from `sender` to `recipient`.
566      *
567      * This is internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `sender` cannot be the zero address.
575      * - `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      */
578     function _transfer(address sender, address recipient, uint256 amount) internal {
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581 
582         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
583         _balances[recipient] = _balances[recipient].add(amount);
584         emit Transfer(sender, recipient, amount);
585     }
586 
587     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
588      * the total supply.
589      *
590      * Emits a {Transfer} event with `from` set to the zero address.
591      *
592      * Requirements
593      *
594      * - `to` cannot be the zero address.
595      */
596     function _mint(address account, uint256 amount) internal {
597         require(account != address(0), "ERC20: mint to the zero address");
598 
599         _totalSupply = _totalSupply.add(amount);
600         _balances[account] = _balances[account].add(amount);
601         emit Transfer(address(0), account, amount);
602     }
603 
604      /**
605      * @dev Destroys `amount` tokens from `account`, reducing the
606      * total supply.
607      *
608      * Emits a {Transfer} event with `to` set to the zero address.
609      *
610      * Requirements
611      *
612      * - `account` cannot be the zero address.
613      * - `account` must have at least `amount` tokens.
614      */
615     function _burn(address account, uint256 amount) internal {
616         require(account != address(0), "ERC20: burn from the zero address");
617 
618         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
619         _totalSupply = _totalSupply.sub(amount);
620         emit Transfer(account, address(0), amount);
621     }
622 
623     /**
624      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
625      *
626      * This is internal function is equivalent to `approve`, and can be used to
627      * e.g. set automatic allowances for certain subsystems, etc.
628      *
629      * Emits an {Approval} event.
630      *
631      * Requirements:
632      *
633      * - `owner` cannot be the zero address.
634      * - `spender` cannot be the zero address.
635      */
636     function _approve(address owner, address spender, uint256 amount) internal {
637         require(owner != address(0), "ERC20: approve from the zero address");
638         require(spender != address(0), "ERC20: approve to the zero address");
639 
640         _allowances[owner][spender] = amount;
641         emit Approval(owner, spender, amount);
642     }
643 
644     /**
645      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
646      * from the caller's allowance.
647      *
648      * See {_burn} and {_approve}.
649      */
650     function _burnFrom(address account, uint256 amount) internal {
651         _burn(account, amount);
652         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
653     }
654 }
655 
656 // File: contracts/roles/RevokerRole.sol
657 
658 pragma solidity 0.5.8;
659 
660 
661 contract RevokerRole is OwnerRole {
662 
663     event RevokerAdded(address indexed addedRevoker, address indexed addedBy);
664     event RevokerRemoved(address indexed removedRevoker, address indexed removedBy);
665 
666     Roles.Role private _revokers;
667 
668     modifier onlyRevoker() {
669         require(isRevoker(msg.sender), "RevokerRole: caller does not have the Revoker role");
670         _;
671     }
672 
673     function isRevoker(address account) public view returns (bool) {
674         return _revokers.has(account);
675     }
676 
677     function addRevoker(address account) public onlyOwner {
678         _addRevoker(account);
679     }
680 
681     function removeRevoker(address account) public onlyOwner {
682         _removeRevoker(account);
683     }
684 
685     function _addRevoker(address account) internal {
686         _revokers.add(account);
687         emit RevokerAdded(account, msg.sender);
688     }
689 
690     function _removeRevoker(address account) internal {
691         _revokers.remove(account);
692         emit RevokerRemoved(account, msg.sender);
693     }
694 }
695 
696 // File: contracts/capabilities/Revocable.sol
697 
698 pragma solidity 0.5.8;
699 
700 
701 
702 /**
703  * Allows an administrator to move tokens from a target account to their own.
704  */
705 contract Revocable is ERC20, RevokerRole {
706 
707   event Revoke(address indexed revoker, address indexed from, uint256 amount);
708 
709   function revoke(
710     address _from,
711     uint256 _amount
712   )
713     public
714     onlyRevoker
715     returns (bool)
716   {
717     ERC20._transfer(_from, msg.sender, _amount);
718     emit Revoke(msg.sender, _from, _amount);
719     return true;
720   }
721 }
722 
723 // File: contracts/roles/WhitelisterRole.sol
724 
725 pragma solidity 0.5.8;
726 
727 
728 contract WhitelisterRole is OwnerRole {
729 
730     event WhitelisterAdded(address indexed addedWhitelister, address indexed addedBy);
731     event WhitelisterRemoved(address indexed removedWhitelister, address indexed removedBy);
732 
733     Roles.Role private _whitelisters;
734 
735     modifier onlyWhitelister() {
736         require(isWhitelister(msg.sender), "WhitelisterRole: caller does not have the Whitelister role");
737         _;
738     }
739 
740     function isWhitelister(address account) public view returns (bool) {
741         return _whitelisters.has(account);
742     }
743 
744     function addWhitelister(address account) public onlyOwner {
745         _addWhitelister(account);
746     }
747 
748     function removeWhitelister(address account) public onlyOwner {
749         _removeWhitelister(account);
750     }
751 
752     function _addWhitelister(address account) internal {
753         _whitelisters.add(account);
754         emit WhitelisterAdded(account, msg.sender);
755     }
756 
757     function _removeWhitelister(address account) internal {
758         _whitelisters.remove(account);
759         emit WhitelisterRemoved(account, msg.sender);
760     }
761 }
762 
763 // File: contracts/capabilities/Whitelistable.sol
764 
765 pragma solidity 0.5.8;
766 
767 
768 /**
769  * @title Whitelistable
770  * @dev Allows tracking whether addressess are allowed to hold tokens.
771  */
772 contract Whitelistable is WhitelisterRole {
773 
774     event WhitelistUpdate(address _address, bool status, string data);
775 
776     // Tracks whether an address is whitelisted
777     // data field can track any external field (like a hash of personal details)
778     struct whiteListItem {
779         bool status;
780         string data;
781     }
782 
783     // white list status
784     mapping (address => whiteListItem) public whitelist;
785 
786     /**
787     * @dev Set a white list address
788     * @param to the address to be set
789     * @param status the whitelisting status (true for yes, false for no)
790     * @param data a string with data about the whitelisted address
791     */
792     function setWhitelist(address to, bool status, string memory data)  public onlyWhitelister returns(bool){
793         whitelist[to] = whiteListItem(status, data);
794         emit WhitelistUpdate(to, status, data);
795         return true;
796     }
797 
798     /**
799     * @dev Get the status of the whitelist
800     * @param _address the address to be check
801     */
802     function getWhitelistStatus(address _address) public view returns(bool){
803         return whitelist[_address].status;
804     }
805 
806     /**
807     * @dev Get the data of and address in the whitelist
808     * @param _address the address to retrieve the data from
809     */
810     function getWhitelistData(address _address) public view returns(string memory){
811         return whitelist[_address].data;
812     }
813 
814     /**
815     * @dev Determine if sender and receiver are whitelisted, return true if both accounts are whitelisted
816     * @param from The address sending tokens.
817     * @param to The address receiving tokens.
818     */
819     function checkWhitelists(address from, address to) external view returns (bool) {
820         return whitelist[from].status && whitelist[to].status;
821     }
822 }
823 
824 // File: contracts/roles/TimelockerRole.sol
825 
826 pragma solidity 0.5.8;
827 
828 
829 contract TimelockerRole is OwnerRole {
830 
831     event TimelockerAdded(address indexed addedTimelocker, address indexed addedBy);
832     event TimelockerRemoved(address indexed removedTimelocker, address indexed removedBy);
833 
834     Roles.Role private _timelockers;
835 
836     modifier onlyTimelocker() {
837         require(isTimelocker(msg.sender), "TimelockerRole: caller does not have the Timelocker role");
838         _;
839     }
840 
841     function isTimelocker(address account) public view returns (bool) {
842         return _timelockers.has(account);
843     }
844 
845     function addTimelocker(address account) public onlyOwner {
846         _addTimelocker(account);
847     }
848 
849     function removeTimelocker(address account) public onlyOwner {
850         _removeTimelocker(account);
851     }
852 
853     function _addTimelocker(address account) internal {
854         _timelockers.add(account);
855         emit TimelockerAdded(account, msg.sender);
856     }
857 
858     function _removeTimelocker(address account) internal {
859         _timelockers.remove(account);
860         emit TimelockerRemoved(account, msg.sender);
861     }
862 }
863 
864 // File: contracts/capabilities/Timelockable.sol
865 
866 pragma solidity 0.5.8;
867 
868 
869 
870 /**
871  * @title INX Timelockable
872  * @dev Lockup all or a portion of an accounts tokens until an expiration date
873  */
874 contract Timelockable is TimelockerRole {
875 
876     using SafeMath for uint256;
877 
878     struct lockupItem {
879         uint256 amount;
880         uint256 releaseTime;
881     }
882 
883     mapping (address => lockupItem) lockups;
884 
885     event AccountLock(address _address, uint256 amount, uint256 releaseTime);
886     event AccountRelease(address _address, uint256 amount);
887 
888 
889     /**
890     * @dev lock address and amount and lock it, set the release time
891     * @param _address the address to lock
892     * @param amount the amount to lock
893     * @param releaseTime of the locked amount (in seconds since the epoch)
894     */
895     function lock( address _address, uint256 amount, uint256 releaseTime) public onlyTimelocker returns (bool) {
896         require(releaseTime > block.timestamp, "Release time needs to be in the future");
897         require(_address != address(0), "Address must be valid for lockup");
898 
899         lockupItem memory _lockupItem = lockupItem(amount, releaseTime);
900         lockups[_address] = _lockupItem;
901         emit AccountLock(_address, amount, releaseTime);
902         return true;
903     }
904 
905     /**
906     * @dev release locked amount
907     * @param _address the address to retrieve the data from
908     * @param amountToRelease the amount to check
909     */
910     function release( address _address, uint256 amountToRelease) public onlyTimelocker returns(bool) {
911         require(_address != address(0), "Address must be valid for release");
912 
913         uint256 _lockedAmount = lockups[_address].amount;
914 
915         // nothing to release
916         if(_lockedAmount == 0){
917             emit AccountRelease(_address, 0);
918             return true;
919         }
920 
921         // extract release time for re-locking
922         uint256 _releaseTime = lockups[_address].releaseTime;
923 
924         // delete the lock entry
925         delete lockups[_address];
926 
927         if(_lockedAmount >= amountToRelease){
928            uint256 newLockedAmount = _lockedAmount.sub(amountToRelease);
929 
930            // re-lock the new locked balance
931            lock(_address, newLockedAmount, _releaseTime);
932            emit AccountRelease(_address, amountToRelease);
933            return true;
934         } else {
935             // if they requested to release more than the locked amount emit the event with the locked amount that has been released
936             emit AccountRelease(_address, _lockedAmount);
937             return true;
938         }
939     }
940 
941     /**
942     * @dev return true if the given account has enough unlocked tokens to send the requested amount
943     * @param _address the address to retrieve the data from
944     * @param amount the amount to send
945     * @param balance the token balance of the sending account
946     */
947     function checkTimelock(address _address, uint256 amount, uint256 balance) external view returns (bool) {
948         // if the user does not have enough tokens to send regardless of lock return true here
949         // the failure will still fail but this should make it explicit that the transfer failure is not
950         // due to locked tokens but because of too low token balance
951         if (balance < amount) {
952             return true;
953         }
954 
955         // get the sending addresses token balance that is not locked
956         uint256 nonLockedAmount = balance.sub(lockups[_address].amount);
957 
958         // determine if the sending address has enough free tokens to send the entire amount
959         bool notLocked = amount <= nonLockedAmount;
960 
961         // if the timelock is greater then the release time the time lock is expired
962         bool timeLockExpired = block.timestamp > lockups[_address].releaseTime;
963 
964         // if the timelock is expired OR the requested amount is available the transfer is not locked
965         if(timeLockExpired || notLocked){
966             return true;
967 
968         // if the timelocked is not expired AND the requested amount is not available the tranfer is locked
969         } else {
970             return false;
971         }
972     }
973 
974     /**
975     * @dev get address lockup info
976     * @param _address the address to retrieve the data from
977     * @return array of 2 uint256, release time (in seconds since the epoch) and amount (in INX)
978     */
979     function checkLockup(address _address) public view returns(uint256, uint256) {
980         // copy lockup data into memory
981         lockupItem memory _lockupItem = lockups[_address];
982 
983         return (_lockupItem.releaseTime, _lockupItem.amount);
984     }
985 }
986 
987 // File: contracts/roles/PauserRole.sol
988 
989 pragma solidity 0.5.8;
990 
991 
992 contract PauserRole is OwnerRole {
993 
994     event PauserAdded(address indexed addedPauser, address indexed addedBy);
995     event PauserRemoved(address indexed removedPauser, address indexed removedBy);
996 
997     Roles.Role private _pausers;
998 
999     modifier onlyPauser() {
1000         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
1001         _;
1002     }
1003 
1004     function isPauser(address account) public view returns (bool) {
1005         return _pausers.has(account);
1006     }
1007 
1008     function addPauser(address account) public onlyOwner {
1009         _addPauser(account);
1010     }
1011 
1012     function removePauser(address account) public onlyOwner {
1013         _removePauser(account);
1014     }
1015 
1016     function _addPauser(address account) internal {
1017         _pausers.add(account);
1018         emit PauserAdded(account, msg.sender);
1019     }
1020 
1021     function _removePauser(address account) internal {
1022         _pausers.remove(account);
1023         emit PauserRemoved(account, msg.sender);
1024     }
1025 }
1026 
1027 // File: contracts/capabilities/Pausable.sol
1028 
1029 pragma solidity 0.5.8;
1030 
1031 
1032 /**
1033  * Allows transfers on a token contract to be paused by an administrator.
1034  */
1035 contract Pausable is PauserRole {
1036     event Paused();
1037     event Unpaused();
1038 
1039     bool private _paused;
1040 
1041     /**
1042      * @return true if the contract is paused, false otherwise.
1043      */
1044     function paused() external view returns (bool) {
1045         return _paused;
1046     }
1047 
1048     /**
1049      * @dev internal function, triggers paused state
1050      */
1051     function _pause() internal {
1052         _paused = true;
1053         emit Paused();
1054     }
1055 
1056     /**
1057      * @dev internal function, returns to unpaused state
1058      */
1059     function _unpause() internal {
1060         _paused = false;
1061         emit Unpaused();
1062     }
1063 
1064      /**
1065      * @dev called by pauser role to pause, triggers stopped state
1066      */
1067     function pause() public onlyPauser {
1068         _pause();
1069     }
1070 
1071     /**
1072      * @dev called by pauer role to unpause, returns to normal state
1073      */
1074     function unpause() public onlyPauser {
1075         _unpause();
1076     }
1077 }
1078 
1079 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
1080 
1081 pragma solidity ^0.5.0;
1082 
1083 
1084 /**
1085  * @dev Optional functions from the ERC20 standard.
1086  */
1087 contract ERC20Detailed is IERC20 {
1088     string private _name;
1089     string private _symbol;
1090     uint8 private _decimals;
1091 
1092     /**
1093      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1094      * these values are immutable: they can only be set once during
1095      * construction.
1096      */
1097     constructor (string memory name, string memory symbol, uint8 decimals) public {
1098         _name = name;
1099         _symbol = symbol;
1100         _decimals = decimals;
1101     }
1102 
1103     /**
1104      * @dev Returns the name of the token.
1105      */
1106     function name() public view returns (string memory) {
1107         return _name;
1108     }
1109 
1110     /**
1111      * @dev Returns the symbol of the token, usually a shorter version of the
1112      * name.
1113      */
1114     function symbol() public view returns (string memory) {
1115         return _symbol;
1116     }
1117 
1118     /**
1119      * @dev Returns the number of decimals used to get its user representation.
1120      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1121      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1122      *
1123      * Tokens usually opt for a value of 18, imitating the relationship between
1124      * Ether and Wei.
1125      *
1126      * NOTE: This information is only used for _display_ purposes: it in
1127      * no way affects any of the arithmetic of the contract, including
1128      * {IERC20-balanceOf} and {IERC20-transfer}.
1129      */
1130     function decimals() public view returns (uint8) {
1131         return _decimals;
1132     }
1133 }
1134 
1135 // File: contracts/InxToken.sol
1136 
1137 pragma solidity 0.5.8;
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 contract InxToken is IERC1404, IERC1404Validators, IERC20, ERC20Detailed, OwnerRole, Revocable, Whitelistable, Timelockable, Pausable {
1150 
1151     // Token Details
1152     string constant TOKEN_NAME = "INX Token";
1153     string constant TOKEN_SYMBOL = "INX";
1154     uint8 constant TOKEN_DECIMALS = 18;
1155 
1156     // Token supply - 2 Hundred Million Tokens, with 18 decimal precision
1157     uint256 constant HUNDRED_MILLION = 100000000;
1158     uint256 constant TOKEN_SUPPLY = 2 * HUNDRED_MILLION * (10 ** uint256(TOKEN_DECIMALS));
1159 
1160     // This tracks the external contract where restriction logic is executed
1161     IERC1404Success private transferRestrictions;
1162 
1163     // Event tracking when restriction logic contract is updated
1164     event RestrictionsUpdated (address newRestrictionsAddress, address updatedBy);
1165 
1166     /**
1167     Constructor for the token to set readable details and mint all tokens
1168     to the specified owner.
1169     */
1170     constructor(address owner) public
1171         ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
1172     {
1173         _mint(owner, TOKEN_SUPPLY);
1174         _addOwner(owner);
1175     }
1176 
1177     /**
1178     Function that can only be called by an owner that updates the address
1179     with the ERC1404 Transfer Restrictions defined
1180     */
1181     function updateTransferRestrictions(address _newRestrictionsAddress)
1182         public
1183         onlyOwner
1184         returns (bool)
1185     {
1186         transferRestrictions = IERC1404Success(_newRestrictionsAddress);
1187         emit RestrictionsUpdated(address(transferRestrictions), msg.sender);
1188         return true;
1189     }
1190 
1191     /**
1192     The address with the Transfer Restrictions contract
1193     */
1194     function getRestrictionsAddress () public view returns (address) {
1195         return address(transferRestrictions);
1196     }
1197 
1198 
1199     /**
1200     This function detects whether a transfer should be restricted and not allowed.
1201     If the function returns SUCCESS_CODE (0) then it should be allowed.
1202     */
1203     function detectTransferRestriction (address from, address to, uint256 amount)
1204         public
1205         view
1206         returns (uint8)
1207     {
1208         // Verify the external contract is valid
1209         require(address(transferRestrictions) != address(0), 'TransferRestrictions contract must be set');
1210 
1211         // call detectTransferRestriction on the current transferRestrictions contract
1212         return transferRestrictions.detectTransferRestriction(from, to, amount);
1213     }
1214 
1215     /**
1216     This function detects whether a transferFrom should be restricted and not allowed.
1217     If the function returns SUCCESS_CODE (0) then it should be allowed.
1218     */
1219     function detectTransferFromRestriction (address sender, address from, address to, uint256 amount)
1220         public
1221         view
1222         returns (uint8)
1223     {
1224         // Verify the external contract is valid
1225         require(address(transferRestrictions) != address(0), 'TransferRestrictions contract must be set');
1226 
1227         // call detectTransferFromRestriction on the current transferRestrictions contract
1228         return  transferRestrictions.detectTransferFromRestriction(sender, from, to, amount);
1229     }
1230 
1231     /**
1232     This function allows a wallet or other client to get a human readable string to show
1233     a user if a transfer was restricted.  It should return enough information for the user
1234     to know why it failed.
1235     */
1236     function messageForTransferRestriction (uint8 restrictionCode)
1237         external
1238         view
1239         returns (string memory)
1240     {
1241         // call messageForTransferRestriction on the current transferRestrictions contract
1242         return transferRestrictions.messageForTransferRestriction(restrictionCode);
1243     }
1244 
1245     /**
1246     Evaluates whether a transfer should be allowed or not.
1247     */
1248     modifier notRestricted (address from, address to, uint256 value) {
1249         uint8 restrictionCode = transferRestrictions.detectTransferRestriction(from, to, value);
1250         require(restrictionCode == transferRestrictions.getSuccessCode(), transferRestrictions.messageForTransferRestriction(restrictionCode));
1251         _;
1252     }
1253 
1254     /**
1255     Evaluates whether a transferFrom should be allowed or not.
1256     */
1257     modifier notRestrictedTransferFrom (address sender, address from, address to, uint256 value) {
1258         uint8 transferFromRestrictionCode = transferRestrictions.detectTransferFromRestriction(sender, from, to, value);
1259         require(transferFromRestrictionCode == transferRestrictions.getSuccessCode(), transferRestrictions.messageForTransferRestriction(transferFromRestrictionCode));
1260         _;
1261     }
1262 
1263     /**
1264     Overrides the parent class token transfer function to enforce restrictions.
1265     */
1266     function transfer (address to, uint256 value)
1267         public
1268         notRestricted(msg.sender, to, value)
1269         returns (bool success)
1270     {
1271         success = ERC20.transfer(to, value);
1272     }
1273 
1274     /**
1275     Overrides the parent class token transferFrom function to enforce restrictions.
1276     */
1277     function transferFrom (address from, address to, uint256 value)
1278         public
1279         notRestrictedTransferFrom(msg.sender, from, to, value)
1280         returns (bool success)
1281     {
1282         success = ERC20.transferFrom(from, to, value);
1283     }
1284 }