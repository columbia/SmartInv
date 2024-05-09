1 pragma solidity 0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
5 // Subject to the MIT license.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, errorMessage);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot underflow.
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction underflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot underflow.
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, errorMessage);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers.
124      * Reverts on division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers.
139      * Reverts with custom message on division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 /**
190  * @title Roles
191  * @dev Library for managing addresses assigned to a Role.
192  */
193 library Roles {
194     struct Role {
195         mapping (address => bool) bearer;
196     }
197 
198     /**
199      * @dev give an account access to this role
200      */
201     function add(Role storage role, address account) internal {
202         require(account != address(0));
203         require(!has(role, account));
204 
205         role.bearer[account] = true;
206     }
207 
208     /**
209      * @dev remove an account's access to this role
210      */
211     function remove(Role storage role, address account) internal {
212         require(account != address(0));
213         require(has(role, account));
214 
215         role.bearer[account] = false;
216     }
217 
218     /**
219      * @dev check if an account has this role
220      * @return bool
221      */
222     function has(Role storage role, address account) internal view returns (bool) {
223         require(account != address(0));
224         return role.bearer[account];
225     }
226 }
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 /*
307  * @dev Provides information about the current execution context, including the
308  * sender of the transaction and its data. While these are generally available
309  * via msg.sender and msg.data, they should not be accessed in such a direct
310  * manner, since when dealing with GSN meta-transactions the account sending and
311  * paying for execution may not be the actual sender (as far as an application
312  * is concerned).
313  *
314  * This contract is only required for intermediate, library-like contracts.
315  */
316 contract Context {
317     // Empty internal constructor, to prevent people from mistakenly deploying
318     // an instance of this contract, which should be used via inheritance.
319     constructor() internal {}
320 
321     function _msgSender() internal view returns (address payable) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view returns (bytes memory) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 /**
332  * @dev Contract module which provides a basic access control mechanism, where
333  * there is an account (an owner) that can be granted exclusive access to
334  * specific functions.
335  *
336  * By default, the owner account will be the one that deploys the contract. This
337  * can later be changed with {transferOwnership}.
338  *
339  * This module is used through inheritance. It will make available the modifier
340  * `onlyOwner`, which can be applied to your functions to restrict their use to
341  * the owner.
342  */
343 contract Ownable is Context {
344     address private _owner;
345 
346     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
347 
348     /**
349      * @dev Initializes the contract setting the deployer as the initial owner.
350      */
351     constructor() internal {
352         address msgSender = _msgSender();
353         _owner = msgSender;
354         emit OwnershipTransferred(address(0), msgSender);
355     }
356 
357     /**
358      * @dev Returns the address of the current owner.
359      */
360     function owner() public view returns (address) {
361         return _owner;
362     }
363 
364     /**
365      * @dev Throws if called by any account other than the owner.
366      */
367     modifier onlyOwner() {
368         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
369         _;
370     }
371 
372     /**
373      * @dev Leaves the contract without owner. It will not be possible to call
374      * `onlyOwner` functions anymore. Can only be called by the current owner.
375      *
376      * NOTE: Renouncing ownership will leave the contract without an owner,
377      * thereby removing any functionality that is only available to the owner.
378      */
379     function renounceOwnership() public onlyOwner {
380         emit OwnershipTransferred(_owner, address(0));
381         _owner = address(0);
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Can only be called by the current owner.
387      */
388     function transferOwnership(address newOwner) public onlyOwner {
389         _transferOwnership(newOwner);
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      */
395     function _transferOwnership(address newOwner) internal {
396         require(newOwner != address(0), 'Ownable: new owner is the zero address');
397         emit OwnershipTransferred(_owner, newOwner);
398         _owner = newOwner;
399     }
400 }
401 
402 // ----------------------------------------------------------------------------
403 // Contract function to receive approval and execute function in one call
404 // ----------------------------------------------------------------------------
405 contract ApproveAndCallFallBack {
406     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
407 }
408 
409 contract PauserRole {
410     using Roles for Roles.Role;
411 
412     event PauserAdded(address indexed account);
413     event PauserRemoved(address indexed account);
414 
415     Roles.Role private _pausers;
416 
417     constructor () internal {
418         _addPauser(msg.sender);
419     }
420 
421     modifier onlyPauser() {
422         require(isPauser(msg.sender));
423         _;
424     }
425 
426     function isPauser(address account) public view returns (bool) {
427         return _pausers.has(account);
428     }
429 
430     function addPauser(address account) public onlyPauser {
431         _addPauser(account);
432     }
433 
434     function renouncePauser() public {
435         _removePauser(msg.sender);
436     }
437 
438     function _addPauser(address account) internal {
439         _pausers.add(account);
440         emit PauserAdded(account);
441     }
442 
443     function _removePauser(address account) internal {
444         _pausers.remove(account);
445         emit PauserRemoved(account);
446     }
447 }
448 
449 /**
450  * @title Pausable
451  * @dev Base contract which allows children to implement an emergency stop mechanism.
452  */
453 contract Pausable is PauserRole {
454     event Paused(address account);
455     event Unpaused(address account);
456 
457     bool private _paused;
458 
459     constructor () internal {
460         _paused = false;
461     }
462 
463     /**
464      * @return true if the contract is paused, false otherwise.
465      */
466     function paused() public view returns (bool) {
467         return _paused;
468     }
469 
470     /**
471      * @dev Modifier to make a function callable only when the contract is not paused.
472      */
473     modifier whenNotPaused() {
474         require(!_paused);
475         _;
476     }
477 
478     /**
479      * @dev Modifier to make a function callable only when the contract is paused.
480      */
481     modifier whenPaused() {
482         require(_paused);
483         _;
484     }
485 
486     /**
487      * @dev called by the owner to pause, triggers stopped state
488      */
489     function pause() public onlyPauser whenNotPaused {
490         _paused = true;
491         emit Paused(msg.sender);
492     }
493 
494     /**
495      * @dev called by the owner to unpause, returns to normal state
496      */
497     function unpause() public onlyPauser whenPaused {
498         _paused = false;
499         emit Unpaused(msg.sender);
500     }
501 }
502 
503 contract MGG is Ownable, Pausable {
504     /// @notice EIP-20 token name for this token
505     string public constant name = "MetaGaming Guild";
506 
507     /// @notice EIP-20 token symbol for this token
508     string public constant symbol = "MGG";
509 
510     /// @notice EIP-20 token decimals for this token
511     uint8 public constant decimals = 18;
512 
513     /// @notice Total number of tokens in circulation
514     uint public totalSupply = 1_000_000_000e18; // 1 billion MGG
515 
516     /// @notice Allowance amounts on behalf of others
517     mapping (address => mapping (address => uint96)) internal allowances;
518 
519     /// @notice Official record of token balances for each account
520     mapping (address => uint96) internal balances;
521 
522     /// @notice A record of each accounts delegate
523     mapping (address => address) public delegates;
524 
525     /// @notice A checkpoint for marking number of votes from a given block
526     struct Checkpoint {
527         uint32 fromBlock;
528         uint96 votes;
529     }
530 
531     /// @notice A record of votes checkpoints for each account, by index
532     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
533 
534     /// @notice The number of checkpoints for each account
535     mapping (address => uint32) public numCheckpoints;
536 
537     /// @notice The EIP-712 typehash for the contract's domain
538     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
539 
540     /// @notice The EIP-712 typehash for the delegation struct used by the contract
541     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
542 
543     /// @notice The EIP-712 typehash for the permit struct used by the contract
544     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
545 
546     /// @notice A record of states for signing / validating signatures
547     mapping (address => uint) public nonces;
548 
549     /// @notice An event thats emitted when an account changes its delegate
550     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
551 
552     /// @notice An event thats emitted when a delegate account's vote balance changes
553     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
554 
555     /// @notice The standard EIP-20 transfer event
556     event Transfer(address indexed from, address indexed to, uint256 amount);
557 
558     /// @notice The standard EIP-20 approval event
559     event Approval(address indexed owner, address indexed spender, uint256 amount);
560 
561     /// @notice The Admin Token Recovery event
562     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
563 
564     /// @notice The standard EIP-20 burn event
565     event Burn(address indexed from, uint256 value);
566 
567     /**
568      * @notice Construct a new DGG token
569      * @param account The initial account to grant all the tokens
570      */
571     constructor(address account) public {
572         balances[account] = uint96(totalSupply);
573         _moveDelegates(address(0), account, uint96(totalSupply));
574         emit Transfer(address(0), account, totalSupply);
575     }
576 
577     /**
578      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
579      * @param account The address of the account holding the funds
580      * @param spender The address of the account spending the funds
581      * @return The number of tokens approved
582      */
583     function allowance(address account, address spender) external view returns (uint) {
584         return allowances[account][spender];
585     }
586 
587     /**
588      * @notice Approve `spender` to transfer up to `amount` from `src`
589      * @dev This will overwrite the approval amount for `spender`
590      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
591      * @param spender The address of the account which may transfer tokens
592      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
593      * @return Whether or not the approval succeeded
594      */
595     function approve(address spender, uint rawAmount) external whenNotPaused returns (bool) {
596         uint96 amount;
597         if (rawAmount == uint(-1)) {
598             amount = uint96(-1);
599         } else {
600             amount = safe96(rawAmount, "MGG::approve: amount exceeds 96 bits");
601         }
602 
603         allowances[msg.sender][spender] = amount;
604 
605         emit Approval(msg.sender, spender, amount);
606         return true;
607     }
608 
609     /**
610      * @notice Triggers an approval from owner to spends
611      * @param owner The address to approve from
612      * @param spender The address to be approved
613      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
614      * @param deadline The time at which to expire the signature
615      * @param v The recovery byte of the signature
616      * @param r Half of the ECDSA signature pair
617      * @param s Half of the ECDSA signature pair
618      */
619     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
620         uint96 amount;
621         if (rawAmount == uint(-1)) {
622             amount = uint96(-1);
623         } else {
624             amount = safe96(rawAmount, "MGG::permit: amount exceeds 96 bits");
625         }
626 
627         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
628         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
629         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
630         address signatory = ecrecover(digest, v, r, s);
631         require(signatory != address(0), "MGG::permit: invalid signature");
632         require(signatory == owner, "MGG::permit: unauthorized");
633         require(now <= deadline, "MGG::permit: signature expired");
634 
635         allowances[owner][spender] = amount;
636 
637         emit Approval(owner, spender, amount);
638     }
639 
640     /**
641      * @notice Get the number of tokens held by the `account`
642      * @param account The address of the account to get the balance of
643      * @return The number of tokens held
644      */
645     function balanceOf(address account) external view returns (uint) {
646         return balances[account];
647     }
648 
649     /**
650      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
651      * @param dst The address of the destination account
652      * @param rawAmount The number of tokens to transfer
653      * @return Whether or not the transfer succeeded
654      */
655     function transfer(address dst, uint rawAmount) external whenNotPaused returns (bool) {
656         uint96 amount = safe96(rawAmount, "MGG::transfer: amount exceeds 96 bits");
657         _transferTokens(msg.sender, dst, amount);
658         return true;
659     }
660 
661     /**
662      * @notice Transfer `amount` tokens from `src` to `dst`
663      * @param src The address of the source account
664      * @param dst The address of the destination account
665      * @param rawAmount The number of tokens to transfer
666      * @return Whether or not the transfer succeeded
667      */
668     function transferFrom(address src, address dst, uint rawAmount) external whenNotPaused returns (bool) {
669         address spender = msg.sender;
670         uint96 spenderAllowance = allowances[src][spender];
671         uint96 amount = safe96(rawAmount, "MGG::transferFrom: amount exceeds 96 bits");
672 
673         if (spender != src && spenderAllowance != uint96(-1)) {
674             uint96 newAllowance = sub96(spenderAllowance, amount, "MGG::transferFrom: transfer amount exceeds spender allowance");
675             allowances[src][spender] = newAllowance;
676 
677             emit Approval(src, spender, newAllowance);
678         }
679 
680         _transferTokens(src, dst, amount);
681         return true;
682     }
683 
684     /**
685      * @notice Delegate votes from `msg.sender` to `delegatee`
686      * @param delegatee The address to delegate votes to
687      */
688     function delegate(address delegatee) public {
689         return _delegate(msg.sender, delegatee);
690     }
691 
692     /**
693      * @notice Delegates votes from signatory to `delegatee`
694      * @param delegatee The address to delegate votes to
695      * @param nonce The contract state required to match the signature
696      * @param expiry The time at which to expire the signature
697      * @param v The recovery byte of the signature
698      * @param r Half of the ECDSA signature pair
699      * @param s Half of the ECDSA signature pair
700      */
701     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
702         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
703         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
704         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
705         address signatory = ecrecover(digest, v, r, s);
706         require(signatory != address(0), "MGG::delegateBySig: invalid signature");
707         require(nonce == nonces[signatory]++, "MGG::delegateBySig: invalid nonce");
708         require(now <= expiry, "MGG::delegateBySig: signature expired");
709         return _delegate(signatory, delegatee);
710     }
711 
712     /**
713      * @notice Gets the current votes balance for `account`
714      * @param account The address to get votes balance
715      * @return The number of current votes for `account`
716      */
717     function getCurrentVotes(address account) external view returns (uint96) {
718         uint32 nCheckpoints = numCheckpoints[account];
719         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
720     }
721 
722     /**
723      * @notice Determine the prior number of votes for an account as of a block number
724      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
725      * @param account The address of the account to check
726      * @param blockNumber The block number to get the vote balance at
727      * @return The number of votes the account had as of the given block
728      */
729     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
730         require(blockNumber < block.number, "MGG::getPriorVotes: not yet determined");
731 
732         uint32 nCheckpoints = numCheckpoints[account];
733         if (nCheckpoints == 0) {
734             return 0;
735         }
736 
737         // First check most recent balance
738         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
739             return checkpoints[account][nCheckpoints - 1].votes;
740         }
741 
742         // Next check implicit zero balance
743         if (checkpoints[account][0].fromBlock > blockNumber) {
744             return 0;
745         }
746 
747         uint32 lower = 0;
748         uint32 upper = nCheckpoints - 1;
749         while (upper > lower) {
750             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
751             Checkpoint memory cp = checkpoints[account][center];
752             if (cp.fromBlock == blockNumber) {
753                 return cp.votes;
754             } else if (cp.fromBlock < blockNumber) {
755                 lower = center;
756             } else {
757                 upper = center - 1;
758             }
759         }
760         return checkpoints[account][lower].votes;
761     }
762 
763     function _delegate(address delegator, address delegatee) internal {
764         address currentDelegate = delegates[delegator];
765         uint96 delegatorBalance = balances[delegator];
766         delegates[delegator] = delegatee;
767 
768         emit DelegateChanged(delegator, currentDelegate, delegatee);
769 
770         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
771     }
772 
773     function _transferTokens(address src, address dst, uint96 amount) internal {
774         require(src != address(0), "MGG::_transferTokens: cannot transfer from the zero address");
775         require(dst != address(0), "MGG::_transferTokens: cannot transfer to the zero address");
776 
777         balances[src] = sub96(balances[src], amount, "MGG::_transferTokens: transfer amount exceeds balance");
778         balances[dst] = add96(balances[dst], amount, "MGG::_transferTokens: transfer amount overflows");
779         emit Transfer(src, dst, amount);
780 
781         _moveDelegates(delegates[src], delegates[dst], amount);
782     }
783 
784     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
785         if (srcRep != dstRep && amount > 0) {
786             if (srcRep != address(0)) {
787                 uint32 srcRepNum = numCheckpoints[srcRep];
788                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
789                 uint96 srcRepNew = sub96(srcRepOld, amount, "MGG::_moveDelegates: vote amount underflows");
790                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
791             }
792 
793             if (dstRep != address(0)) {
794                 uint32 dstRepNum = numCheckpoints[dstRep];
795                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
796                 uint96 dstRepNew = add96(dstRepOld, amount, "MGG::_moveDelegates: vote amount overflows");
797                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
798             }
799         }
800     }
801 
802     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
803       uint32 blockNumber = safe32(block.number, "MGG::_writeCheckpoint: block number exceeds 32 bits");
804 
805       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
806           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
807       } else {
808           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
809           numCheckpoints[delegatee] = nCheckpoints + 1;
810       }
811 
812       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
813     }
814 
815     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
816         require(n < 2**32, errorMessage);
817         return uint32(n);
818     }
819 
820     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
821         require(n < 2**96, errorMessage);
822         return uint96(n);
823     }
824 
825     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
826         uint96 c = a + b;
827         require(c >= a, errorMessage);
828         return c;
829     }
830 
831     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
832         require(b <= a, errorMessage);
833         return a - b;
834     }
835 
836     function getChainId() internal pure returns (uint) {
837         uint256 chainId;
838         assembly { chainId := chainid() }
839         return chainId;
840     }
841 
842     /**
843      * @notice It allows the admin to retrieve lost tokens sent to the contract
844      * @param _tokenAddress: the address of the token to withdraw
845      * @param _tokenAmount: the number of tokens to withdraw
846      * @dev This function is only callable by admin.
847      */
848     function retrieveLostTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
849         require(_tokenAddress != address(0), "MGG::retrieveLostTokens: Invalid _tokenAddress");
850 
851         IERC20(_tokenAddress).transfer(address(msg.sender), _tokenAmount);
852 
853         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
854     }
855     
856     function burn(uint rawAmount) public returns (bool success) {
857         uint96 amount = safe96(rawAmount, "MGG::burn: amount exceeds 96 bits");
858         require(balances[msg.sender] >= amount, "MGG::burn: not enough balance");   // Check if the sender has enough
859         balances[msg.sender] = sub96(balances[msg.sender], amount, "MGG::burn: burn amount exceeds balance");  // Subtract from the sender
860         totalSupply = SafeMath.sub(totalSupply, rawAmount);  // Updates totalSupply
861         _moveDelegates(msg.sender, address(0), amount);
862         emit Burn(msg.sender, rawAmount);
863         return true;
864     }
865 
866     /**
867      * @notice Token owner can approve for spender to transferFrom(...) tokens from the token owner's account. The spender contract function receiveApproval(...) is then executed   
868      * @param spender address The address which will spend the funds
869      * @param rawAmount uint256 The amount of tokens to be spent
870      * @param data bytes Additional data with no specified format, sent in call to `spender`
871      */
872     function approveAndCall(address spender, uint rawAmount, bytes memory data) public returns (bool success) {
873         uint96 amount = safe96(rawAmount, "MGG::approveAndCall: amount exceeds 96 bits");
874         allowances[msg.sender][spender] = amount;
875         emit Approval(msg.sender, spender, amount);
876         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, rawAmount, address(this), data);
877         return true;
878     }
879 }