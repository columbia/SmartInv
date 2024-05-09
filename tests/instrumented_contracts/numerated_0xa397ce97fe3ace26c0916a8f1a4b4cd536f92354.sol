1 pragma solidity 0.5.1;
2 
3 // File: contracts/lib/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner(), "Only the owner can call this function.");
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/lib/IERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 
83 interface IERC20 {
84 
85   function totalSupply() external view returns (uint256);
86 
87   function balanceOf(address who) external view returns (uint256);
88 
89   function allowance(address owner, address spender)
90     external view returns (uint256);
91 
92   // solhint-disable-next-line func-order
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   // solhint-disable-next-line func-order
96   function approve(address spender, uint256 value)
97     external returns (bool);
98 
99   // solhint-disable-next-line func-order
100   function transferFrom(address from, address to, uint256 value)
101     external returns (bool);
102 
103   // solhint-disable-next-line no-simple-event-func-name
104   event Transfer(
105     address indexed from,
106     address indexed to,
107     uint256 value
108   );
109 
110   event Approval(
111     address indexed owner,
112     address indexed spender,
113     uint256 value
114   );
115 }
116 
117 // File: contracts/lib/SafeMath.sol
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that revert on error
122  */
123 
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, reverts on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
133     if (a == 0) {
134       return 0;
135     }
136 
137     uint256 c = a * b;
138     require(c / a == b);
139 
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b > 0); // Solidity only automatically asserts when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     uint256 c = a - b;
160 
161     return c;
162   }
163 
164   /**
165   * @dev Adds two numbers, reverts on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256) {
168     uint256 c = a + b;
169     require(c >= a);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
176   * reverts when dividing by zero.
177   */
178   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179     require(b != 0);
180     return a % b;
181   }
182 }
183 
184 // File: contracts/lib/Roles.sol
185 
186 /**
187  * @title Roles
188  * @dev Library for managing addresses assigned to a Role.
189  */
190 library Roles {
191   struct Role {
192     mapping (address => bool) bearer;
193   }
194 
195   /**
196    * @dev give an account access to this role
197    */
198   function add(Role storage role, address account) internal {
199     require(account != address(0));
200     role.bearer[account] = true;
201   }
202 
203   /**
204    * @dev remove an account's access to this role
205    */
206   function remove(Role storage role, address account) internal {
207     require(account != address(0));
208     role.bearer[account] = false;
209   }
210 
211   /**
212    * @dev check if an account has this role
213    * @return bool
214    */
215   function has(Role storage role, address account)
216     internal
217     view
218     returns (bool)
219   {
220     require(account != address(0));
221     return role.bearer[account];
222   }
223 }
224 
225 // File: contracts/lib/PauserRole.sol
226 
227 contract PauserRole {
228   using Roles for Roles.Role;
229 
230   event PauserAdded(address indexed account);
231   event PauserRemoved(address indexed account);
232 
233   Roles.Role private pausers;
234 
235   constructor() public {
236     _addPauser(msg.sender);
237   }
238 
239   modifier onlyPauser() {
240     require(isPauser(msg.sender), "Can only be called by pauser.");
241     _;
242   }
243 
244   function isPauser(address account) public view returns (bool) {
245     return pausers.has(account);
246   }
247 
248   function addPauser(address account) public onlyPauser {
249     _addPauser(account);
250   }
251 
252   function renouncePauser() public {
253     _removePauser(msg.sender);
254   }
255 
256   function _addPauser(address account) internal {
257     pausers.add(account);
258     emit PauserAdded(account);
259   }
260 
261   function _removePauser(address account) internal {
262     pausers.remove(account);
263     emit PauserRemoved(account);
264   }
265 }
266 
267 // File: contracts/lib/Pausable.sol
268 
269 /**
270  * @title Pausable
271  * @dev Base contract which allows children to implement an emergency stop mechanism.
272  */
273 contract Pausable is PauserRole {
274   event Paused();
275   event Unpaused();
276 
277   bool private _paused = false;
278 
279   /**
280    * @return true if the contract is paused, false otherwise.
281    */
282   function paused() public view returns(bool) {
283     return _paused;
284   }
285 
286   /**
287    * @dev Modifier to make a function callable only when the contract is not paused.
288    */
289   modifier whenNotPaused() {
290     require(!_paused, "Cannot call when paused.");
291     _;
292   }
293 
294   /**
295    * @dev Modifier to make a function callable only when the contract is paused.
296    */
297   modifier whenPaused() {
298     require(_paused, "Can only call this when paused.");
299     _;
300   }
301 
302   /**
303    * @dev called by the owner to pause, triggers stopped state
304    */
305   function pause() public onlyPauser whenNotPaused {
306     _paused = true;
307     emit Paused();
308   }
309 
310   /**
311    * @dev called by the owner to unpause, returns to normal state
312    */
313   function unpause() public onlyPauser whenPaused {
314     _paused = false;
315     emit Unpaused();
316   }
317 }
318 
319 // File: contracts/lib/ValidatorRole.sol
320 
321 contract ValidatorRole {
322   using Roles for Roles.Role;
323 
324   event ValidatorAdded(address indexed account);
325   event ValidatorRemoved(address indexed account);
326 
327   Roles.Role private validators;
328 
329   constructor(address validator) public {
330     _addValidator(validator);
331   }
332 
333   modifier onlyValidator() {
334     require(
335       isValidator(msg.sender),
336       "This function can only be called by a validator."
337     );
338     _;
339   }
340 
341   function isValidator(address account) public view returns (bool) {
342     return validators.has(account);
343   }
344 
345   function addValidator(address account) public onlyValidator {
346     _addValidator(account);
347   }
348 
349   function renounceValidator() public {
350     _removeValidator(msg.sender);
351   }
352 
353   function _addValidator(address account) internal {
354     validators.add(account);
355     emit ValidatorAdded(account);
356   }
357 
358   function _removeValidator(address account) internal {
359     validators.remove(account);
360     emit ValidatorRemoved(account);
361   }
362 }
363 
364 // File: contracts/IxtProtect.sol
365 
366 /// @title IxtEvents
367 /// @notice Holds all events used by the IXTProtect contract
368 contract IxtEvents {
369 
370   event MemberAdded(
371     address indexed memberAddress,
372     bytes32 indexed membershipNumber,
373     bytes32 indexed invitationCode
374   );
375 
376   event StakeDeposited(
377     address indexed memberAddress,
378     bytes32 indexed membershipNumber,
379     uint256 stakeAmount
380   );
381 
382   event StakeWithdrawn(
383     address indexed memberAddress,
384     uint256 stakeAmount
385   );
386 
387   event RewardClaimed(
388     address indexed memberAddress,
389     uint256 rewardAmount
390   );
391 
392   event InvitationRewardGiven(
393     address indexed memberReceivingReward,
394     address indexed memberGivingReward,
395     uint256 rewardAmount
396   );
397 
398   event PoolDeposit(
399     address indexed depositer,
400     uint256 amount
401   );
402 
403   event PoolWithdraw(
404     address indexed withdrawer,
405     uint256 amount
406   );
407 
408   event AdminRemovedMember(
409     address indexed admin,
410     address indexed userAddress,
411     uint256 refundIssued
412   );
413 
414   event MemberDrained(
415     address indexed memberAddress,
416     uint256 amountRefunded
417   );
418 
419   event PoolDrained(
420     address indexed refundRecipient,
421     uint256 amountRefunded
422   );
423 
424   event ContractDrained(
425     address indexed drainInitiator
426   );
427 
428   event InvitationRewardChanged(
429     uint256 newInvitationReward
430   );
431 
432   event LoyaltyRewardChanged(
433     uint256 newLoyaltyRewardAmount
434   );
435 }
436 
437 /// @title RoleManager which inherits the Role-based functionality used
438 /// by the IXTProtect contract
439 contract RoleManager is Ownable, Pausable, ValidatorRole {
440 
441   constructor(address validator)
442     public
443     ValidatorRole(validator)
444   {}
445 }
446 
447 /// @title StakeManager which contains some of the stake-based state
448 /// used by the IXTProtect contract
449 contract StakeManager {
450 
451   /*      Function modifiers      */
452 
453   modifier isValidStakeLevel(StakeLevel level) {
454     require(
455       uint8(level) >= 0 && uint8(level) <= 2,
456       "Is not valid a staking level."
457     );
458     _;
459   }
460 
461   /*      Data types      */
462 
463   /// @dev The three levels of stake used within the IXTProtect platform
464   /// @dev Solidity enums are 0 based
465   enum StakeLevel { LOW, MEDIUM, HIGH }
466 
467   /*      Variable declarations      */
468 
469   /// @dev the defined staking amount for each level
470   uint256[3] public ixtStakingLevels;
471 
472   /*      Constructor      */
473 
474   /// @param _ixtStakingLevels the amount of stake used for each of the staking levels
475   /// used within the IXTProtect platform
476   constructor(
477     uint256[3] memory _ixtStakingLevels
478   ) public {
479     ixtStakingLevels = _ixtStakingLevels;
480   }
481 
482 }
483 
484 /// @title RewardManager which contains some of the reward-based state
485 /// used by the IXTProtect contract
486 contract RewardManager {
487 
488   /*      Variable declarations      */
489 
490   /// @dev the reward received when inviting someone
491   uint256 public invitationReward;
492   /// @dev the period after which a member gets a loyalty reward
493   uint256 public loyaltyPeriodDays;
494   /// @dev the rate used for calculation of the loyalty reward
495   uint256 public loyaltyRewardAmount;
496 
497   /*      Constructor      */
498 
499   /// @param _invitationReward the amount of reward used when a member uses an invitation code
500   /// @param _loyaltyPeriodDays the amount of days that will be used for the loyalty period
501   /// @param _loyaltyRewardAmount the rate used as a loyalty reward after every loyalty period
502   constructor(
503     uint256 _invitationReward,
504     uint256 _loyaltyPeriodDays,
505     uint256 _loyaltyRewardAmount
506   ) public {
507     require(
508       _loyaltyRewardAmount >= 0 &&
509       _loyaltyRewardAmount <= 100,
510       "Loyalty reward amount must be between 0 and 100."
511     );
512     invitationReward = _invitationReward;
513     loyaltyPeriodDays = _loyaltyPeriodDays;
514     loyaltyRewardAmount = _loyaltyRewardAmount;
515   }
516 
517 }
518 
519 /// @title IxtProtect
520 /// @notice Holds state and contains key logic which controls the IXTProtect platform
521 contract IxtProtect is IxtEvents, RoleManager, StakeManager, RewardManager {
522 
523   /*      Function modifiers      */
524 
525   modifier isNotMember(address memberAddress) {
526     require(
527       members[memberAddress].addedTimestamp == 0,
528       "Already a member."
529     );
530     _;
531   }
532 
533   modifier isMember(address memberAddress) {
534     require(
535       members[memberAddress].addedTimestamp != 0,
536       "User is not a member."
537     );
538     _;
539   }
540 
541   modifier notStaking(address memberAddress) {
542     require(
543       members[memberAddress].stakeTimestamp == 0,
544       "Member is staking already."
545     );
546     _;
547   }
548 
549   modifier staking(address memberAddress) {
550     require(
551       members[memberAddress].stakeTimestamp != 0,
552       "Member is not staking."
553     );
554     _;
555   }
556 
557   /*      Data types      */
558 
559   /// @dev data structure used to track state on each member using the platform
560   struct Member {
561     uint256 addedTimestamp;
562     uint256 stakeTimestamp;
563     uint256 startOfLoyaltyRewardEligibility;
564     bytes32 membershipNumber;
565     bytes32 invitationCode;
566     uint256 stakeBalance;
567     uint256 invitationRewards;
568     uint256 previouslyAppliedLoyaltyBalance;
569   }
570 
571   /*      Variable declarations      */
572 
573   /// @dev the IXT ERC20 Token contract
574   IERC20 public ixtToken;
575   /// @dev a mapping from member wallet addresses to Member struct
576   mapping(address => Member) public members;
577   /// @dev the same data as `members`, but iterable
578   address[] public membersArray;
579   /// @dev the total balance of all members
580   uint256 public totalMemberBalance;
581   /// @dev the total pool balance
582   uint256 public totalPoolBalance;
583   /// @notice a mapping from invitationCode => memberAddress, so invitation rewards can be applied.
584   mapping(bytes32 => address) public registeredInvitationCodes;
585  
586 
587   /*      Constants      */
588 
589   /// @dev the amount of decimals used by the IXT ERC20 token
590   uint256 public constant IXT_DECIMALS = 8;
591 
592   /*      Constructor      */
593 
594   /// @param _validator the address to use as the validator
595   /// @param _loyaltyPeriodDays the amount of days that will be used for the loyalty period
596   /// @param _ixtToken the address of the IXT ERC20 token to be used as stake and for rewards
597   /// @param _invitationReward the amount of reward used when a member uses an invitation code
598   /// @param _loyaltyRewardAmount the rate used as a loyalty reward after every loyalty period
599   /// @param _ixtStakingLevels three ascending amounts of IXT token to be used as staking levels
600   constructor(
601     address _validator,
602     uint256 _loyaltyPeriodDays,
603     address _ixtToken,
604     uint256 _invitationReward,
605     uint256 _loyaltyRewardAmount,
606     uint256[3] memory _ixtStakingLevels
607   )
608     public
609     RoleManager(_validator)
610     StakeManager(_ixtStakingLevels)
611     RewardManager(_invitationReward, _loyaltyPeriodDays, _loyaltyRewardAmount)
612   {
613     require(_ixtToken != address(0x0), "ixtToken address was set to 0.");
614     ixtToken = IERC20(_ixtToken);
615   }
616 
617   /*                            */
618   /*      PUBLIC FUNCTIONS      */
619   /*                            */
620 
621   /*      (member control)      */
622 
623   /// @notice Registers a new user as a member after the KYC process
624   /// @notice This function should not add the invitationCode
625   /// to the mapping yet, this should only happen after join
626   /// @notice This function can only be called by a "validator" which is set inside the
627   /// constructor
628   /// @param _membershipNumber the membership number of the member to authorise
629   /// @param _memberAddress the EOA address of the member to authorise
630   /// @param _invitationCode should be associated with *this* member in order to apply invitation rewards
631   /// @param _referralInvitationCode the invitation code of another member which is used to give the
632 
633   function addMember(
634     bytes32 _membershipNumber,
635     address _memberAddress,
636     bytes32 _invitationCode,
637     bytes32 _referralInvitationCode
638   ) 
639     public
640     onlyValidator
641     isNotMember(_memberAddress)
642     notStaking(_memberAddress)
643   {
644     require(
645       _memberAddress != address(0x0),
646       "Member address was set to 0."
647     );
648     Member memory member = Member({
649       addedTimestamp: block.timestamp,
650       stakeTimestamp: 0,
651       startOfLoyaltyRewardEligibility: 0,
652       membershipNumber: _membershipNumber,
653       invitationCode: _invitationCode,
654       stakeBalance: 0,
655       invitationRewards: 0,
656       previouslyAppliedLoyaltyBalance: 0
657     });
658     members[_memberAddress] = member;
659     membersArray.push(_memberAddress);
660 
661     /// @dev add this members invitation code to the mapping
662     registeredInvitationCodes[member.invitationCode] = _memberAddress;
663     /// @dev if the _referralInvitationCode is already registered, add on reward
664     address rewardMemberAddress = registeredInvitationCodes[_referralInvitationCode];
665     if (
666       rewardMemberAddress != address(0x0)
667     ) {
668       Member storage rewardee = members[rewardMemberAddress];
669       rewardee.invitationRewards = SafeMath.add(rewardee.invitationRewards, invitationReward);
670       emit InvitationRewardGiven(rewardMemberAddress, _memberAddress, invitationReward);
671     }
672 
673     emit MemberAdded(_memberAddress, _membershipNumber, _invitationCode);
674   }
675 
676   /// @notice Called by a member once they have been approved to join the scheme
677   /// @notice Before calling the prospective member *must* have approved the appropriate amount of
678   /// IXT token to be transferred by this contract
679   /// @param _stakeLevel the staking level used by this member. Note this is not the staking *amount*.
680   /// other member a reward upon *this* user joining.
681   function depositStake(
682     StakeLevel _stakeLevel
683   )
684     public
685     whenNotPaused()
686     isMember(msg.sender)
687     notStaking(msg.sender)
688     isValidStakeLevel(_stakeLevel)
689   {
690     uint256 amountDeposited = depositInternal(msg.sender, ixtStakingLevels[uint256(_stakeLevel)], false);
691     Member storage member = members[msg.sender];
692     member.stakeTimestamp = block.timestamp;
693     member.startOfLoyaltyRewardEligibility = block.timestamp;
694     /// @dev add this members invitation code to the mapping
695     registeredInvitationCodes[member.invitationCode] = msg.sender;
696     emit StakeDeposited(msg.sender, member.membershipNumber, amountDeposited);
697   }
698 
699   /// @notice Called by the member if they wish to withdraw the stake
700   /// @notice This function will return all stake and eligible reward balance back to the user
701   function withdrawStake()
702     public
703     whenNotPaused()
704     staking(msg.sender)
705   {
706 
707     uint256 stakeAmount = refundUserBalance(msg.sender);
708     delete registeredInvitationCodes[members[msg.sender].invitationCode];
709     Member storage member = members[msg.sender];
710     member.stakeTimestamp = 0;
711     member.startOfLoyaltyRewardEligibility = 0;
712     emit StakeWithdrawn(msg.sender, stakeAmount);
713   }
714 
715   /// @notice Called by the member if they wish to claim the rewards they are eligible
716   /// @notice This function will return all eligible reward balance back to the user
717   function claimRewards()
718     public
719     whenNotPaused()
720     staking(msg.sender)
721   {
722     uint256 rewardClaimed = claimRewardsInternal(msg.sender);
723     emit RewardClaimed(msg.sender, rewardClaimed);
724   }
725 
726   /*      (getter functions)      */
727 
728   /// @notice Called in order to get the number of members on the platform
729   /// @return length of the members array
730   function getMembersArrayLength() public view returns (uint256) {
731     return membersArray.length;
732   }
733 
734   /// @notice Called to obtain the account balance of any given member
735   /// @param memberAddress the address of the member to get the account balance for
736   /// @return the account balance of the member in question
737   function getAccountBalance(address memberAddress)
738     public
739     view
740     staking(memberAddress)
741     returns (uint256)
742   {
743     return getStakeBalance(memberAddress) +
744       getRewardBalance(memberAddress);
745   }
746 
747   /// @notice Called to obtain the stake balance of any given member
748   /// @param memberAddress the address of the member to get the stake balance for
749   /// @return the stake balance of the member in question
750   function getStakeBalance(address memberAddress)
751     public
752     view
753     staking(memberAddress)
754     returns (uint256)
755   {
756     return members[memberAddress].stakeBalance;
757   }
758 
759   /// @notice Called to obtain the reward balance of any given member
760   /// @param memberAddress the address of the member to get the total reward balance for
761   /// @return the total reward balance of the member in question
762   function getRewardBalance(address memberAddress)
763     public
764     view
765     staking(memberAddress)
766     returns (uint256)
767   {
768     return getInvitationRewardBalance(memberAddress) +
769       getLoyaltyRewardBalance(memberAddress);
770   }
771 
772   /// @notice Called to obtain the invitation reward balance of any given member
773   /// @param memberAddress the address of the member to get the invitation reward balance for
774   /// @return the invitation reward balance of the member in question
775   function getInvitationRewardBalance(address memberAddress)
776     public
777     view
778     staking(memberAddress)
779     returns (uint256)
780   {
781     return members[memberAddress].invitationRewards;
782   }
783 
784   /// @notice Called to obtain the loyalty reward balance of any given member
785   /// @param memberAddress the address of the member to get the loyalty reward balance for
786   /// @return the loyalty reward balance of the member in question
787   function getLoyaltyRewardBalance(address memberAddress)
788     public
789     view
790     staking(memberAddress)
791     returns (uint256 loyaltyReward)
792   {
793     uint256 loyaltyPeriodSeconds = loyaltyPeriodDays * 1 days;
794     Member storage thisMember = members[memberAddress];
795     uint256 elapsedTimeSinceEligible = block.timestamp - thisMember.startOfLoyaltyRewardEligibility;
796     loyaltyReward = thisMember.previouslyAppliedLoyaltyBalance;
797     if (elapsedTimeSinceEligible >= loyaltyPeriodSeconds) {
798       uint256 numWholePeriods = SafeMath.div(elapsedTimeSinceEligible, loyaltyPeriodSeconds);
799       uint256 rewardForEachPeriod = thisMember.stakeBalance * loyaltyRewardAmount / 100;
800       loyaltyReward += rewardForEachPeriod * numWholePeriods;
801     }
802   }
803 
804   /*      (admin functions)      */
805 
806   /// @notice Called by the admin to deposit extra IXT into the contract to be used as rewards
807   /// @notice This function can only be called by the contract owner
808   /// @param amountToDeposit the amount of IXT ERC20 token to deposit into the pool
809   function depositPool(uint256 amountToDeposit)
810     public
811     onlyOwner
812   {
813     uint256 amountDeposited = depositInternal(msg.sender, amountToDeposit, true);
814     emit PoolDeposit(msg.sender, amountDeposited);
815   }
816 
817   /// @notice Called by the admin to withdraw IXT from the pool balance
818   /// @notice This function can only be called by the contract owner
819   /// @param amountToWithdraw the amount of IXT ERC20 token to withdraw from the pool
820   function withdrawPool(uint256 amountToWithdraw)
821     public
822     onlyOwner
823   {
824     if (amountToWithdraw > 0) {
825       require(
826         totalPoolBalance >= amountToWithdraw &&
827         ixtToken.transfer(msg.sender, amountToWithdraw),
828         "Unable to withdraw this value of IXT."  
829       );
830       totalPoolBalance = SafeMath.sub(totalPoolBalance, amountToWithdraw);
831     }
832     emit PoolWithdraw(msg.sender, amountToWithdraw);
833   }
834 
835   /// @notice Called by an admin to remove a member from the platform
836   /// @notice This function can only be called by the contract owner
837   /// @notice The member will be automatically refunded their stake balance and any
838   /// unclaimed rewards as a result of being removed by the admin
839   /// @notice Can be called if user is authorised *or* joined
840   /// @param userAddress the address of the member that the admin wishes to remove
841   function removeMember(address userAddress)
842     public
843     isMember(userAddress)
844     onlyOwner
845   {
846     uint256 refund = cancelMembershipInternal(userAddress);
847     emit AdminRemovedMember(msg.sender, userAddress, refund);
848   }
849 
850   /// @notice Called by an admin in emergency situations only, will returns *ALL* stake balance
851   /// and reward balances back to the users. Any left over pool balance will be returned to the
852   /// contract owner.
853   /// @notice This function can only be called by the contract owner
854   function drain() public onlyOwner {
855     /// @dev Refund and delete all members
856     for (uint256 index = 0; index < membersArray.length; index++) {
857       address memberAddress = membersArray[index];
858       bool memberJoined = members[memberAddress].stakeTimestamp != 0;
859       uint256 amountRefunded = memberJoined ? refundUserBalance(memberAddress) : 0;
860 
861       delete registeredInvitationCodes[members[memberAddress].invitationCode];
862       delete members[memberAddress];
863 
864       emit MemberDrained(memberAddress, amountRefunded);
865     }
866     delete membersArray;
867 
868     /// @dev Refund the pool balance
869     require(
870       ixtToken.transfer(msg.sender, totalPoolBalance),
871       "Unable to withdraw this value of IXT."
872     );
873     totalPoolBalance = 0;
874     emit PoolDrained(msg.sender, totalPoolBalance);
875     
876     emit ContractDrained(msg.sender);
877   }
878 
879   /// @notice Called by the contract owner to set the invitation reward to be given to future members
880   /// @notice This function does not affect previously awarded invitation rewards
881   /// @param _invitationReward the amount that the invitation reward should be set to
882   function setInvitationReward(uint256 _invitationReward)
883     public
884     onlyOwner
885   {
886     invitationReward = _invitationReward;
887     emit InvitationRewardChanged(_invitationReward);
888   }
889 
890   /// @notice Called by the contract owner to set the loyalty reward rate to be given to future members
891   /// @notice This function does not affect previously awarded loyalty rewards
892   /// @notice The loyalty reward amount is actually a rate from 0 to 100 that is used to
893   /// calculate the proportion of stake balance that should be rewarded.
894   /// @param newLoyaltyRewardAmount the amount that the loyalty reward should be set to
895   function setLoyaltyRewardAmount(uint256 newLoyaltyRewardAmount)
896     public
897     onlyOwner
898   {
899     require(
900       newLoyaltyRewardAmount >= 0 &&
901       newLoyaltyRewardAmount <= 100,
902       "Loyalty reward amount must be between 0 and 100."
903     );
904     uint256 loyaltyPeriodSeconds = loyaltyPeriodDays * 1 days;
905     /// @dev Loop through all the current members and apply previous reward amounts
906     for (uint256 i = 0; i < membersArray.length; i++) {
907       Member storage thisMember = members[membersArray[i]];
908       uint256 elapsedTimeSinceEligible = block.timestamp - thisMember.startOfLoyaltyRewardEligibility;
909       if (elapsedTimeSinceEligible >= loyaltyPeriodSeconds) {
910         uint256 numWholePeriods = SafeMath.div(elapsedTimeSinceEligible, loyaltyPeriodSeconds);
911         uint256 rewardForEachPeriod = thisMember.stakeBalance * loyaltyRewardAmount / 100;
912         thisMember.previouslyAppliedLoyaltyBalance += rewardForEachPeriod * numWholePeriods;
913         thisMember.startOfLoyaltyRewardEligibility += numWholePeriods * loyaltyPeriodSeconds;
914       }
915     }
916     loyaltyRewardAmount = newLoyaltyRewardAmount;
917     emit LoyaltyRewardChanged(newLoyaltyRewardAmount);
918   }
919 
920   /*                              */
921   /*      INTERNAL FUNCTIONS      */
922   /*                              */
923 
924   function cancelMembershipInternal(address memberAddress)
925     internal
926     returns
927     (uint256 amountRefunded)
928   {
929     if(members[memberAddress].stakeTimestamp != 0) {
930       amountRefunded = refundUserBalance(memberAddress);
931     }
932 
933     delete registeredInvitationCodes[members[memberAddress].invitationCode];
934 
935     delete members[memberAddress];
936 
937     removeMemberFromArray(memberAddress);
938   }
939 
940   function refundUserBalance(
941     address memberAddress
942   ) 
943     internal
944     returns (uint256)
945   {
946     Member storage member = members[memberAddress];
947 
948     /// @dev Pool balance will be reduced inside this function
949     uint256 claimsRefunded = claimRewardsInternal(memberAddress);
950     uint256 stakeToRefund = member.stakeBalance;
951 
952     bool userStaking = member.stakeTimestamp != 0;
953     if (stakeToRefund > 0 && userStaking) {
954       require(
955         ixtToken.transfer(memberAddress, stakeToRefund),
956         "Unable to withdraw this value of IXT."  
957       );
958       totalMemberBalance = SafeMath.sub(totalMemberBalance, stakeToRefund);
959     }
960     member.stakeBalance = 0;
961     return claimsRefunded + stakeToRefund;
962   }
963 
964   function removeMemberFromArray(address memberAddress) internal {
965     /// @dev removing the member address from the membersArray
966     for (uint256 index; index < membersArray.length; index++) {
967       if (membersArray[index] == memberAddress) {
968         membersArray[index] = membersArray[membersArray.length - 1];
969         membersArray[membersArray.length - 1] = address(0);
970         membersArray.length -= 1;
971         break;
972       }
973     }
974   }
975 
976   function claimRewardsInternal(address memberAddress)
977     internal
978     returns (uint256 rewardAmount)
979   {
980     rewardAmount = getRewardBalance(memberAddress);
981 
982     if (rewardAmount == 0) {
983       return rewardAmount;
984     }
985 
986     require(
987       totalPoolBalance >= rewardAmount,
988       "Pool balance not sufficient to withdraw rewards."
989     );
990     require(
991       ixtToken.transfer(memberAddress, rewardAmount),
992       "Unable to withdraw this value of IXT."  
993     );
994     /// @dev we know this is safe as totalPoolBalance >= rewardAmount
995     totalPoolBalance -= rewardAmount;
996 
997     Member storage thisMember = members[memberAddress];
998     thisMember.previouslyAppliedLoyaltyBalance = 0;
999     thisMember.invitationRewards = 0;
1000 
1001     uint256 loyaltyPeriodSeconds = loyaltyPeriodDays * 1 days;
1002     uint256 elapsedTimeSinceEligible = block.timestamp - thisMember.startOfLoyaltyRewardEligibility;
1003     if (elapsedTimeSinceEligible >= loyaltyPeriodSeconds) {
1004       uint256 numWholePeriods = SafeMath.div(elapsedTimeSinceEligible, loyaltyPeriodSeconds);
1005       thisMember.startOfLoyaltyRewardEligibility += numWholePeriods * loyaltyPeriodSeconds;
1006     }
1007   }
1008 
1009   function depositInternal(
1010     address depositer,
1011     uint256 amount,
1012     bool isPoolDeposit
1013   ) 
1014     internal
1015     returns (uint256)
1016   {
1017     /// @dev Explicitly checking allowance & balance before transferFrom
1018     /// so we get the revert message.
1019     require(amount > 0, "Cannot deposit 0 IXT.");
1020     require(
1021       ixtToken.allowance(depositer, address(this)) >= amount &&
1022       ixtToken.balanceOf(depositer) >= amount &&
1023       ixtToken.transferFrom(depositer, address(this), amount),
1024       "Unable to deposit IXT - check allowance and balance."  
1025     );
1026     if (isPoolDeposit) {
1027       totalPoolBalance = SafeMath.add(totalPoolBalance, amount);
1028     } else {
1029       Member storage member = members[depositer];
1030       member.stakeBalance = SafeMath.add(member.stakeBalance, amount);
1031       totalMemberBalance = SafeMath.add(totalMemberBalance, amount);
1032     }
1033     return amount;
1034   }
1035 }