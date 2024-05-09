1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/access/Roles.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title Roles
75  * @dev Library for managing addresses assigned to a Role.
76  */
77 library Roles {
78     struct Role {
79         mapping (address => bool) bearer;
80     }
81 
82     /**
83      * @dev give an account access to this role
84      */
85     function add(Role storage role, address account) internal {
86         require(account != address(0));
87         require(!has(role, account));
88 
89         role.bearer[account] = true;
90     }
91 
92     /**
93      * @dev remove an account's access to this role
94      */
95     function remove(Role storage role, address account) internal {
96         require(account != address(0));
97         require(has(role, account));
98 
99         role.bearer[account] = false;
100     }
101 
102     /**
103      * @dev check if an account has this role
104      * @return bool
105      */
106     function has(Role storage role, address account) internal view returns (bool) {
107         require(account != address(0));
108         return role.bearer[account];
109     }
110 }
111 
112 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
113 
114 pragma solidity ^0.5.2;
115 
116 
117 contract PauserRole {
118     using Roles for Roles.Role;
119 
120     event PauserAdded(address indexed account);
121     event PauserRemoved(address indexed account);
122 
123     Roles.Role private _pausers;
124 
125     constructor () internal {
126         _addPauser(msg.sender);
127     }
128 
129     modifier onlyPauser() {
130         require(isPauser(msg.sender));
131         _;
132     }
133 
134     function isPauser(address account) public view returns (bool) {
135         return _pausers.has(account);
136     }
137 
138     function addPauser(address account) public onlyPauser {
139         _addPauser(account);
140     }
141 
142     function renouncePauser() public {
143         _removePauser(msg.sender);
144     }
145 
146     function _addPauser(address account) internal {
147         _pausers.add(account);
148         emit PauserAdded(account);
149     }
150 
151     function _removePauser(address account) internal {
152         _pausers.remove(account);
153         emit PauserRemoved(account);
154     }
155 }
156 
157 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
158 
159 pragma solidity ^0.5.2;
160 
161 
162 /**
163  * @title Pausable
164  * @dev Base contract which allows children to implement an emergency stop mechanism.
165  */
166 contract Pausable is PauserRole {
167     event Paused(address account);
168     event Unpaused(address account);
169 
170     bool private _paused;
171 
172     constructor () internal {
173         _paused = false;
174     }
175 
176     /**
177      * @return true if the contract is paused, false otherwise.
178      */
179     function paused() public view returns (bool) {
180         return _paused;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is not paused.
185      */
186     modifier whenNotPaused() {
187         require(!_paused);
188         _;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is paused.
193      */
194     modifier whenPaused() {
195         require(_paused);
196         _;
197     }
198 
199     /**
200      * @dev called by the owner to pause, triggers stopped state
201      */
202     function pause() public onlyPauser whenNotPaused {
203         _paused = true;
204         emit Paused(msg.sender);
205     }
206 
207     /**
208      * @dev called by the owner to unpause, returns to normal state
209      */
210     function unpause() public onlyPauser whenPaused {
211         _paused = false;
212         emit Unpaused(msg.sender);
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
217 
218 pragma solidity ^0.5.2;
219 
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232      * account.
233      */
234     constructor () internal {
235         _owner = msg.sender;
236         emit OwnershipTransferred(address(0), _owner);
237     }
238 
239     /**
240      * @return the address of the owner.
241      */
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         require(isOwner());
251         _;
252     }
253 
254     /**
255      * @return true if `msg.sender` is the owner of the contract.
256      */
257     function isOwner() public view returns (bool) {
258         return msg.sender == _owner;
259     }
260 
261     /**
262      * @dev Allows the current owner to relinquish control of the contract.
263      * It will not be possible to call the functions with the `onlyOwner`
264      * modifier anymore.
265      * @notice Renouncing ownership will leave the contract without an owner,
266      * thereby removing any functionality that is only available to the owner.
267      */
268     function renounceOwnership() public onlyOwner {
269         emit OwnershipTransferred(_owner, address(0));
270         _owner = address(0);
271     }
272 
273     /**
274      * @dev Allows the current owner to transfer control of the contract to a newOwner.
275      * @param newOwner The address to transfer ownership to.
276      */
277     function transferOwnership(address newOwner) public onlyOwner {
278         _transferOwnership(newOwner);
279     }
280 
281     /**
282      * @dev Transfers control of the contract to a newOwner.
283      * @param newOwner The address to transfer ownership to.
284      */
285     function _transferOwnership(address newOwner) internal {
286         require(newOwner != address(0));
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 }
291 
292 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
293 
294 pragma solidity ^0.5.2;
295 
296 /**
297  * @title Helps contracts guard against reentrancy attacks.
298  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
299  * @dev If you mark a function `nonReentrant`, you should also
300  * mark it `external`.
301  */
302 contract ReentrancyGuard {
303     /// @dev counter to allow mutex lock with only one SSTORE operation
304     uint256 private _guardCounter;
305 
306     constructor () internal {
307         // The counter starts at one to prevent changing it from zero to a non-zero
308         // value, which is a more expensive operation.
309         _guardCounter = 1;
310     }
311 
312     /**
313      * @dev Prevents a contract from calling itself, directly or indirectly.
314      * Calling a `nonReentrant` function from another `nonReentrant`
315      * function is not supported. It is possible to prevent this from happening
316      * by making the `nonReentrant` function external, and make it call a
317      * `private` function that does the actual work.
318      */
319     modifier nonReentrant() {
320         _guardCounter += 1;
321         uint256 localCounter = _guardCounter;
322         _;
323         require(localCounter == _guardCounter);
324     }
325 }
326 
327 // File: openzeppelin-solidity/contracts/drafts/SignedSafeMath.sol
328 
329 pragma solidity ^0.5.2;
330 
331 /**
332  * @title SignedSafeMath
333  * @dev Signed math operations with safety checks that revert on error
334  */
335 library SignedSafeMath {
336     int256 constant private INT256_MIN = -2**255;
337 
338     /**
339      * @dev Multiplies two signed integers, reverts on overflow.
340      */
341     function mul(int256 a, int256 b) internal pure returns (int256) {
342         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
343         // benefit is lost if 'b' is also tested.
344         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
345         if (a == 0) {
346             return 0;
347         }
348 
349         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
350 
351         int256 c = a * b;
352         require(c / a == b);
353 
354         return c;
355     }
356 
357     /**
358      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
359      */
360     function div(int256 a, int256 b) internal pure returns (int256) {
361         require(b != 0); // Solidity only automatically asserts when dividing by 0
362         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
363 
364         int256 c = a / b;
365 
366         return c;
367     }
368 
369     /**
370      * @dev Subtracts two signed integers, reverts on overflow.
371      */
372     function sub(int256 a, int256 b) internal pure returns (int256) {
373         int256 c = a - b;
374         require((b >= 0 && c <= a) || (b < 0 && c > a));
375 
376         return c;
377     }
378 
379     /**
380      * @dev Adds two signed integers, reverts on overflow.
381      */
382     function add(int256 a, int256 b) internal pure returns (int256) {
383         int256 c = a + b;
384         require((b >= 0 && c >= a) || (b < 0 && c < a));
385 
386         return c;
387     }
388 }
389 
390 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
391 
392 pragma solidity ^0.5.2;
393 
394 /**
395  * @title ERC20 interface
396  * @dev see https://eips.ethereum.org/EIPS/eip-20
397  */
398 interface IERC20 {
399     function transfer(address to, uint256 value) external returns (bool);
400 
401     function approve(address spender, uint256 value) external returns (bool);
402 
403     function transferFrom(address from, address to, uint256 value) external returns (bool);
404 
405     function totalSupply() external view returns (uint256);
406 
407     function balanceOf(address who) external view returns (uint256);
408 
409     function allowance(address owner, address spender) external view returns (uint256);
410 
411     event Transfer(address indexed from, address indexed to, uint256 value);
412 
413     event Approval(address indexed owner, address indexed spender, uint256 value);
414 }
415 
416 // File: openzeppelin-solidity/contracts/utils/Address.sol
417 
418 pragma solidity ^0.5.2;
419 
420 /**
421  * Utility library of inline functions on addresses
422  */
423 library Address {
424     /**
425      * Returns whether the target address is a contract
426      * @dev This function will return false if invoked during the constructor of a contract,
427      * as the code is not actually created until after the constructor finishes.
428      * @param account address of the account to check
429      * @return whether the target address is a contract
430      */
431     function isContract(address account) internal view returns (bool) {
432         uint256 size;
433         // XXX Currently there is no better way to check if there is a contract in an address
434         // than to check the size of the code at that address.
435         // See https://ethereum.stackexchange.com/a/14016/36603
436         // for more details about how this works.
437         // TODO Check this again before the Serenity release, because all addresses will be
438         // contracts then.
439         // solhint-disable-next-line no-inline-assembly
440         assembly { size := extcodesize(account) }
441         return size > 0;
442     }
443 }
444 
445 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
446 
447 pragma solidity ^0.5.2;
448 
449 
450 
451 
452 /**
453  * @title SafeERC20
454  * @dev Wrappers around ERC20 operations that throw on failure (when the token
455  * contract returns false). Tokens that return no value (and instead revert or
456  * throw on failure) are also supported, non-reverting calls are assumed to be
457  * successful.
458  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
459  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
460  */
461 library SafeERC20 {
462     using SafeMath for uint256;
463     using Address for address;
464 
465     function safeTransfer(IERC20 token, address to, uint256 value) internal {
466         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
467     }
468 
469     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
470         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
471     }
472 
473     function safeApprove(IERC20 token, address spender, uint256 value) internal {
474         // safeApprove should only be called when setting an initial allowance,
475         // or when resetting it to zero. To increase and decrease it, use
476         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
477         require((value == 0) || (token.allowance(address(this), spender) == 0));
478         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
479     }
480 
481     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
482         uint256 newAllowance = token.allowance(address(this), spender).add(value);
483         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
484     }
485 
486     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
487         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
488         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
489     }
490 
491     /**
492      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
493      * on the return value: the return value is optional (but if data is returned, it must equal true).
494      * @param token The token targeted by the call.
495      * @param data The call data (encoded using abi.encode or one of its variants).
496      */
497     function callOptionalReturn(IERC20 token, bytes memory data) private {
498         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
499         // we're implementing it ourselves.
500 
501         // A Solidity high level call has three parts:
502         //  1. The target address is checked to verify it contains contract code
503         //  2. The call itself is made, and success asserted
504         //  3. The return value is decoded, which in turn checks the size of the returned data.
505 
506         require(address(token).isContract());
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = address(token).call(data);
510         require(success);
511 
512         if (returndata.length > 0) { // Return data is optional
513             require(abi.decode(returndata, (bool)));
514         }
515     }
516 }
517 
518 // File: contracts/interfaces/IERC1594Capped.sol
519 
520 pragma solidity 0.5.4;
521 
522 
523 interface IERC1594Capped {
524     function balanceOf(address who) external view returns (uint256);
525     function cap() external view returns (uint256);
526     function totalRedeemed() external view returns (uint256);
527 }
528 
529 // File: contracts/interfaces/IRewards.sol
530 
531 pragma solidity 0.5.4;
532 
533 
534 interface IRewards {
535     event Deposited(address indexed from, uint amount);
536     event Withdrawn(address indexed from, uint amount);
537     event Reclaimed(uint amount);
538 
539     function deposit(uint amount) external;
540     function withdraw() external;
541     function reclaimRewards() external;
542     function claimedRewards(address payee) external view returns (uint);
543     function unclaimedRewards(address payee) external view returns (uint);
544     function supply() external view returns (uint);
545     function isRunning() external view returns (bool);
546 }
547 
548 // File: contracts/interfaces/IRewardsUpdatable.sol
549 
550 pragma solidity 0.5.4;
551 
552 
553 interface IRewardsUpdatable {
554     event NotifierUpdated(address implementation);
555 
556     function updateOnTransfer(address from, address to, uint amount) external returns (bool);
557     function updateOnBurn(address account, uint amount) external returns (bool);
558     function setRewardsNotifier(address notifier) external;
559 }
560 
561 // File: contracts/interfaces/IRewardable.sol
562 
563 pragma solidity 0.5.4;
564 
565 
566 
567 interface IRewardable {
568     event RewardsUpdated(address implementation);
569 
570     function setRewards(IRewardsUpdatable rewards) external;
571 }
572 
573 // File: contracts/roles/RewarderRole.sol
574 
575 pragma solidity 0.5.4;
576 
577 
578 
579 // @notice Rewarders are capable of managing the Rewards contract and depositing PAY rewards.
580 contract RewarderRole {
581     using Roles for Roles.Role;
582 
583     event RewarderAdded(address indexed account);
584     event RewarderRemoved(address indexed account);
585 
586     Roles.Role internal _rewarders;
587 
588     modifier onlyRewarder() {
589         require(isRewarder(msg.sender), "Only Rewarders can execute this function.");
590         _;
591     }
592 
593     constructor() internal {
594         _addRewarder(msg.sender);
595     }    
596 
597     function isRewarder(address account) public view returns (bool) {
598         return _rewarders.has(account);
599     }
600 
601     function addRewarder(address account) public onlyRewarder {
602         _addRewarder(account);
603     }
604 
605     function renounceRewarder() public {
606         _removeRewarder(msg.sender);
607     }
608   
609     function _addRewarder(address account) internal {
610         _rewarders.add(account);
611         emit RewarderAdded(account);
612     }
613 
614     function _removeRewarder(address account) internal {
615         _rewarders.remove(account);
616         emit RewarderRemoved(account);
617     }
618 }
619 
620 // File: contracts/roles/ModeratorRole.sol
621 
622 pragma solidity 0.5.4;
623 
624 
625 
626 // @notice Moderators are able to modify whitelists and transfer permissions in Moderator contracts.
627 contract ModeratorRole {
628     using Roles for Roles.Role;
629 
630     event ModeratorAdded(address indexed account);
631     event ModeratorRemoved(address indexed account);
632 
633     Roles.Role internal _moderators;
634 
635     modifier onlyModerator() {
636         require(isModerator(msg.sender), "Only Moderators can execute this function.");
637         _;
638     }
639 
640     constructor() internal {
641         _addModerator(msg.sender);
642     }
643 
644     function isModerator(address account) public view returns (bool) {
645         return _moderators.has(account);
646     }
647 
648     function addModerator(address account) public onlyModerator {
649         _addModerator(account);
650     }
651 
652     function renounceModerator() public {
653         _removeModerator(msg.sender);
654     }    
655 
656     function _addModerator(address account) internal {
657         _moderators.add(account);
658         emit ModeratorAdded(account);
659     }    
660 
661     function _removeModerator(address account) internal {
662         _moderators.remove(account);
663         emit ModeratorRemoved(account);
664     }
665 }
666 
667 // File: contracts/lib/Whitelistable.sol
668 
669 pragma solidity 0.5.4;
670 
671 
672 
673 contract Whitelistable is ModeratorRole {
674     event Whitelisted(address account);
675     event Unwhitelisted(address account);
676 
677     mapping (address => bool) public isWhitelisted;
678 
679     modifier onlyWhitelisted(address account) {
680         require(isWhitelisted[account], "Account is not whitelisted.");
681         _;
682     }
683 
684     modifier onlyNotWhitelisted(address account) {
685         require(!isWhitelisted[account], "Account is whitelisted.");
686         _;
687     }
688 
689     function whitelist(address account) external onlyModerator {
690         require(account != address(0), "Cannot whitelist zero address.");
691         require(account != msg.sender, "Cannot whitelist self.");
692         require(!isWhitelisted[account], "Address already whitelisted.");
693         isWhitelisted[account] = true;
694         emit Whitelisted(account);
695     }
696 
697     function unwhitelist(address account) external onlyModerator {
698         require(account != address(0), "Cannot unwhitelist zero address.");
699         require(account != msg.sender, "Cannot unwhitelist self.");
700         require(isWhitelisted[account], "Address not whitelisted.");
701         isWhitelisted[account] = false;
702         emit Unwhitelisted(account);
703     }
704 }
705 
706 // File: contracts/rewards/Rewards.sol
707 
708 pragma solidity 0.5.4;
709 
710 
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 
721 
722 
723 
724 /**
725 * @notice This contract determines the amount of rewards each user is entitled to and allows users to withdraw their rewards.
726 * @dev The rewards (in the form of a 'rewardsToken') are calculated based on a percentage ownership of a 'rewardableToken'.
727 * The rewards calculation takes into account token movements using a 'damping' factor.
728 * This contract makes use of pull payments over push payments to avoid DoS vulnerabilities.
729 */
730 contract Rewards is IRewards, IRewardsUpdatable, RewarderRole, Pausable, Ownable, ReentrancyGuard, Whitelistable {
731     using SafeERC20 for IERC20;
732     using SafeMath for uint;
733     using SignedSafeMath for int;
734 
735     IERC1594Capped private rewardableToken; // Rewardable tokens gives rewards when held.
736     IERC20 private rewardsToken; // Rewards tokens are given out as rewards.
737     address private rewardsNotifier; // Contract address where token movements are broadcast from.
738 
739     bool public isRunning = true;
740     uint public maxShares; // Total TENX cap. Constant amount.
741     uint public totalRewards; // The current size of the global pool of PAY rewards. Can decrease because of TENX burning.
742     uint public totalDepositedRewards; // Total PAY rewards deposited for users so far. Monotonically increasing.
743     uint public totalClaimedRewards; // Amount of rewards claimed by users so far. Monotonically increasing.
744     mapping(address => int) private _dampings; // Balancing factor to account for rewardable token movements.
745     mapping(address => uint) public claimedRewards; // Claimed PAY rewards per user.
746 
747     event Deposited(address indexed from, uint amount);
748     event Withdrawn(address indexed from, uint amount);
749     event Reclaimed(uint amount);
750     event NotifierUpdated(address implementation);
751 
752     constructor(IERC1594Capped _rewardableToken, IERC20 _rewardsToken) public {
753         uint _cap = _rewardableToken.cap();
754         require(_cap != 0, "Shares token cap must be non-zero.");
755         maxShares = _cap;
756         rewardableToken = _rewardableToken;
757         rewardsToken = _rewardsToken;
758         rewardsNotifier = address(_rewardableToken);
759     }
760 
761     /**
762     * @notice Modifier to check that functions are only callable by a predefined address.
763     */   
764     modifier onlyRewardsNotifier() {
765         require(msg.sender == rewardsNotifier, "Can only be called by the rewards notifier contract.");
766         _;
767     }
768 
769     /**
770     * @notice Modifier to check that the Rewards contract is currently running.
771     */
772     modifier whenRunning() {
773         require(isRunning, "Rewards contract has stopped running.");
774         _;
775     }
776 
777     function () external payable { // Ether fallback function
778         require(msg.value == 0, "Received non-zero msg.value.");
779         withdraw(); // solhint-disable-line
780     }
781 
782     /**
783     * Releases a specified amount of rewards to all shares token holders.
784     * @dev The rewards each user is allocated to receive is calculated dynamically.
785     * Note that the contract needs to hold sufficient rewards token balance to disburse rewards.
786     * @param _amount Amount of reward tokens to allocate to token holders.
787     */
788     function deposit(uint _amount) external onlyRewarder whenRunning whenNotPaused {
789         require(_amount != 0, "Deposit amount must non-zero.");
790         totalDepositedRewards = totalDepositedRewards.add(_amount);
791         totalRewards = totalRewards.add(_amount);
792         address from = msg.sender;
793         emit Deposited(from, _amount);
794 
795         rewardsToken.safeTransferFrom(msg.sender, address(this), _amount); // [External contract call to PAYToken]
796     }
797 
798     /**
799     * @notice Links a RewardsNotifier contract to update this contract on token movements.
800     * @param _notifier Contract address.
801     */
802     function setRewardsNotifier(address _notifier) external onlyOwner {
803         require(address(_notifier) != address(0), "Rewards address must not be a zero address.");
804         require(Address.isContract(address(_notifier)), "Address must point to a contract.");
805         rewardsNotifier = _notifier;
806         emit NotifierUpdated(_notifier);
807     }
808 
809     /**
810     * @notice Updates a damping factor to account for token transfers in the dynamic rewards calculation.
811     * @dev This function adds +X damping to senders and -X damping to recipients, where X is _dampingChange().
812     * This function is called in TENXToken `transfer()` and `transferFrom()`.
813     * @param _from Sender address
814     * @param _to Recipient address
815     * @param _value Token movement amount
816     */
817     function updateOnTransfer(address _from, address _to, uint _value) external onlyRewardsNotifier nonReentrant returns (bool) {
818         int fromUserShareChange = int(_value); // <_from> sends their _value to <_to>, change is positive
819         int fromDampingChange = _dampingChange(totalShares(), totalRewards, fromUserShareChange);
820 
821         int toUserShareChange = int(_value).mul(-1); // <_to> receives _value from <_from>, change is negative
822         int toDampingChange = _dampingChange(totalShares(), totalRewards, toUserShareChange);
823 
824         assert((fromDampingChange.add(toDampingChange)) == 0);
825 
826         _dampings[_from] = damping(_from).add(fromDampingChange);
827         _dampings[_to] = damping(_to).add(toDampingChange);
828         return true;
829     }
830 
831     /**
832     * @notice Updates a damping factor to account for token butning in the dynamic rewards calculation.
833     * @param _account address
834     * @param _value Token burn amount
835     */
836     function updateOnBurn(address _account, uint _value) external onlyRewardsNotifier nonReentrant returns (bool) { 
837         uint totalSharesBeforeBurn = totalShares().add(_value); // In Rewardable.sol, this is executed after the burn has deducted totalShares()
838         uint redeemableRewards = _value.mul(totalRewards).div(totalSharesBeforeBurn); // Calculate amount of rewards the burned amount is entitled to
839         totalRewards = totalRewards.sub(redeemableRewards); // Remove redeemable rewards from the global pool
840         _dampings[_account] = damping(_account).add(int(redeemableRewards)); // Only _account is able to withdraw the unclaimed redeemed rewards
841         return true;
842     }
843 
844     /**
845     * @notice Emergency fallback to drain the contract's balance of PAY tokens.
846     */
847     function reclaimRewards() external onlyOwner {
848         uint256 balance = rewardsToken.balanceOf(address(this));
849         isRunning = false;
850         rewardsToken.safeTransfer(owner(), balance);
851         emit Reclaimed(balance);
852     }
853 
854    /**
855     * @notice Withdraw your balance of PAY rewards.
856     * @dev Only the unclaimed rewards amount can be withdrawn by a user.
857     */
858     function withdraw() public whenRunning whenNotPaused onlyWhitelisted(msg.sender) nonReentrant {
859         address payee = msg.sender;
860         uint unclaimedReward = unclaimedRewards(payee);
861         require(unclaimedReward > 0, "Unclaimed reward must be non-zero to withdraw.");
862         require(supply() >= unclaimedReward, "Rewards contract must have sufficient PAY to disburse.");
863 
864         claimedRewards[payee] = claimedRewards[payee].add(unclaimedReward); // Add amount to claimed rewards balance
865         totalClaimedRewards = totalClaimedRewards.add(unclaimedReward);
866         emit Withdrawn(payee, unclaimedReward);
867 
868         // Send PAY reward to payee
869         rewardsToken.safeTransfer(payee, unclaimedReward); // [External contract call]
870     }
871 
872     /**
873     * @notice Returns this contract's current reward token supply.
874     * @dev The contract must have sufficient PAY allowance to deposit() rewards.
875     * @return Total PAY balance of this contract
876     */
877     function supply() public view returns (uint) {
878         return rewardsToken.balanceOf(address(this));
879     }
880 
881     /**
882     * @notice Returns the reward model's denominator. Used to calculate user rewards.
883     * @dev The denominator is = INITIAL TOKEN CAP - TOTAL REWARDABLE TOKENS REDEEMED.
884     * @return denominator
885     */
886     function totalShares() public view returns (uint) {
887         uint totalRedeemed = rewardableToken.totalRedeemed();
888         return maxShares.sub(totalRedeemed);
889     }
890 
891     /**
892     * @notice Returns the amount of a user's unclaimed (= total allocated - claimed) rewards. 
893     * @param _payee User address.
894     * @return total unclaimed rewards for user
895     */
896     function unclaimedRewards(address _payee) public view returns(uint) {
897         require(_payee != address(0), "Payee must not be a zero address.");
898         uint totalUserReward = totalUserRewards(_payee);
899         if (totalUserReward == uint(0)) {
900             return 0;
901         }
902 
903         uint unclaimedReward = totalUserReward.sub(claimedRewards[_payee]);
904         return unclaimedReward;
905     }
906 
907     /**
908     * @notice Returns a user's total PAY rewards.
909     * @param _payee User address.
910     * @return total claimed + unclaimed rewards for user
911     */
912     function totalUserRewards(address _payee) internal view returns (uint) {
913         require(_payee != address(0), "Payee must not be a zero address.");
914         uint userShares = rewardableToken.balanceOf(_payee); // [External contract call]
915         int userDamping = damping(_payee);
916         uint result = _totalUserRewards(totalShares(), totalRewards, userShares, userDamping);
917         return result;
918     }    
919 
920     /**
921     * @notice Calculate a user's damping factor change. 
922     * @dev The damping factor is used to take into account token movements in the rewards calculation.
923     * dampingChange = total PAY rewards * percentage change in a user's TENX shares
924     * @param _totalShares Total TENX cap (constant ~200M.)
925     * @param _totalRewards The current size of the global pool of PAY rewards.
926     * @param _sharesChange The user's change in TENX balance. Can be positive or negative.
927     * @return damping change for a given change in tokens
928     */
929     function _dampingChange(
930         uint _totalShares,
931         uint _totalRewards,
932         int _sharesChange
933     ) internal pure returns (int) {
934         return int(_totalRewards).mul(_sharesChange).div(int(_totalShares));
935     }
936 
937     /**
938     * @notice Calculates a user's total allocated (claimed + unclaimed) rewards.    
939     * @dev The user's total allocated rewards = (percentage of user's TENX shares * total PAY rewards) + user's damping factor
940     * @param _totalShares Total TENX cap (constant.)
941     * @param _totalRewards Total PAY rewards deposited so far.
942     * @param _userShares The user's TENX balance.
943     * @param _userDamping The user's damping factor.
944     * @return total claimed + unclaimed rewards for user
945     */
946     function _totalUserRewards(
947         uint _totalShares,
948         uint _totalRewards,
949         uint _userShares,
950         int _userDamping
951     ) internal pure returns (uint) {
952         uint maxUserReward = _userShares.mul(_totalRewards).div(_totalShares);
953         int userReward = int(maxUserReward).add(_userDamping);
954         uint result = (userReward > 0 ? uint(userReward) : 0);
955         return result;
956     }
957 
958     function damping(address account) internal view returns (int) {
959         return _dampings[account];
960     }
961 }