1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 contract ERC20Interface {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed from, address indexed spender, uint256 value);
81     string public symbol;
82 
83     function totalSupply() constant returns (uint256 supply);
84     function balanceOf(address _owner) constant returns (uint256 balance);
85     function transfer(address _to, uint256 _value) returns (bool success);
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
87     function approve(address _spender, uint256 _value) returns (bool success);
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 }
90 
91 
92 /**
93  * @title Generic owned destroyable contract
94  */
95 contract Object is Owned {
96     /**
97     *  Common result code. Means everything is fine.
98     */
99     uint constant OK = 1;
100     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
101 
102     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
103         for(uint i=0;i<tokens.length;i++) {
104             address token = tokens[i];
105             uint balance = ERC20Interface(token).balanceOf(this);
106             if(balance != 0)
107                 ERC20Interface(token).transfer(_to,balance);
108         }
109         return OK;
110     }
111 
112     function checkOnlyContractOwner() internal constant returns(uint) {
113         if (contractOwner == msg.sender) {
114             return OK;
115         }
116 
117         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
118     }
119 }
120 
121 
122 /**
123 * @title SafeMath
124 * @dev Math operations with safety checks that throw on error
125 */
126 library SafeMath {
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a * b;
129         assert(a == 0 || c / a == b);
130         return c;
131     }
132 
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         // assert(b > 0); // Solidity automatically throws when dividing by 0
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         assert(b <= a);
142         return a - b;
143     }
144 
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         assert(c >= a);
148         return c;
149     }
150 }
151 
152 
153 contract GroupsAccessManagerEmitter {
154 
155     event UserCreated(address user);
156     event UserDeleted(address user);
157     event GroupCreated(bytes32 groupName);
158     event GroupActivated(bytes32 groupName);
159     event GroupDeactivated(bytes32 groupName);
160     event UserToGroupAdded(address user, bytes32 groupName);
161     event UserFromGroupRemoved(address user, bytes32 groupName);
162 }
163 
164 
165 /// @title Group Access Manager
166 ///
167 /// Base implementation
168 /// This contract serves as group manager
169 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
170 
171     uint constant USER_MANAGER_SCOPE = 111000;
172     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
173     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
174     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
175     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
176     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
177     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
178     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
179     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
180     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
181 
182     using SafeMath for uint;
183 
184     struct Member {
185         address addr;
186         uint groupsCount;
187         mapping(bytes32 => uint) groupName2index;
188         mapping(uint => uint) index2globalIndex;
189     }
190 
191     struct Group {
192         bytes32 name;
193         uint priority;
194         uint membersCount;
195         mapping(address => uint) memberAddress2index;
196         mapping(uint => uint) index2globalIndex;
197     }
198 
199     uint public membersCount;
200     mapping(uint => address) index2memberAddress;
201     mapping(address => uint) memberAddress2index;
202     mapping(address => Member) address2member;
203 
204     uint public groupsCount;
205     mapping(uint => bytes32) index2groupName;
206     mapping(bytes32 => uint) groupName2index;
207     mapping(bytes32 => Group) groupName2group;
208     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
209 
210     function() payable public {
211         revert();
212     }
213 
214     /// @notice Register user
215     /// Can be called only by contract owner
216     ///
217     /// @param _user user address
218     ///
219     /// @return code
220     function registerUser(address _user) external onlyContractOwner returns (uint) {
221         require(_user != 0x0);
222 
223         if (isRegisteredUser(_user)) {
224             return USER_MANAGER_MEMBER_ALREADY_EXIST;
225         }
226 
227         uint _membersCount = membersCount.add(1);
228         membersCount = _membersCount;
229         memberAddress2index[_user] = _membersCount;
230         index2memberAddress[_membersCount] = _user;
231         address2member[_user] = Member(_user, 0);
232 
233         UserCreated(_user);
234         return OK;
235     }
236 
237     /// @notice Discard user registration
238     /// Can be called only by contract owner
239     ///
240     /// @param _user user address
241     ///
242     /// @return code
243     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
244         require(_user != 0x0);
245 
246         uint _memberIndex = memberAddress2index[_user];
247         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
248             return USER_MANAGER_INVALID_INVOCATION;
249         }
250 
251         uint _membersCount = membersCount;
252         delete memberAddress2index[_user];
253         if (_memberIndex != _membersCount) {
254             address _lastUser = index2memberAddress[_membersCount];
255             index2memberAddress[_memberIndex] = _lastUser;
256             memberAddress2index[_lastUser] = _memberIndex;
257         }
258         delete address2member[_user];
259         delete index2memberAddress[_membersCount];
260         delete memberAddress2index[_user];
261         membersCount = _membersCount.sub(1);
262 
263         UserDeleted(_user);
264         return OK;
265     }
266 
267     /// @notice Create group
268     /// Can be called only by contract owner
269     ///
270     /// @param _groupName group name
271     /// @param _priority group priority
272     ///
273     /// @return code
274     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
275         require(_groupName != bytes32(0));
276 
277         if (isGroupExists(_groupName)) {
278             return USER_MANAGER_GROUP_ALREADY_EXIST;
279         }
280 
281         uint _groupsCount = groupsCount.add(1);
282         groupName2index[_groupName] = _groupsCount;
283         index2groupName[_groupsCount] = _groupName;
284         groupName2group[_groupName] = Group(_groupName, _priority, 0);
285         groupsCount = _groupsCount;
286 
287         GroupCreated(_groupName);
288         return OK;
289     }
290 
291     /// @notice Change group status
292     /// Can be called only by contract owner
293     ///
294     /// @param _groupName group name
295     /// @param _blocked block status
296     ///
297     /// @return code
298     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
299         require(isGroupExists(_groupName));
300         groupsBlocked[_groupName] = _blocked;
301         return OK;
302     }
303 
304     /// @notice Add users in group
305     /// Can be called only by contract owner
306     ///
307     /// @param _groupName group name
308     /// @param _users user array
309     ///
310     /// @return code
311     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
312         require(isGroupExists(_groupName));
313 
314         Group storage _group = groupName2group[_groupName];
315         uint _groupMembersCount = _group.membersCount;
316 
317         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
318             address _user = _users[_userIdx];
319             uint _memberIndex = memberAddress2index[_user];
320             require(_memberIndex != 0);
321 
322             if (_group.memberAddress2index[_user] != 0) {
323                 continue;
324             }
325 
326             _groupMembersCount = _groupMembersCount.add(1);
327             _group.memberAddress2index[_user] = _groupMembersCount;
328             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
329 
330             _addGroupToMember(_user, _groupName);
331 
332             UserToGroupAdded(_user, _groupName);
333         }
334         _group.membersCount = _groupMembersCount;
335 
336         return OK;
337     }
338 
339     /// @notice Remove users in group
340     /// Can be called only by contract owner
341     ///
342     /// @param _groupName group name
343     /// @param _users user array
344     ///
345     /// @return code
346     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
347         require(isGroupExists(_groupName));
348 
349         Group storage _group = groupName2group[_groupName];
350         uint _groupMembersCount = _group.membersCount;
351 
352         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
353             address _user = _users[_userIdx];
354             uint _memberIndex = memberAddress2index[_user];
355             uint _groupMemberIndex = _group.memberAddress2index[_user];
356 
357             if (_memberIndex == 0 || _groupMemberIndex == 0) {
358                 continue;
359             }
360 
361             if (_groupMemberIndex != _groupMembersCount) {
362                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
363                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
364                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
365                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
366             }
367             delete _group.memberAddress2index[_user];
368             delete _group.index2globalIndex[_groupMembersCount];
369             _groupMembersCount = _groupMembersCount.sub(1);
370 
371             _removeGroupFromMember(_user, _groupName);
372 
373             UserFromGroupRemoved(_user, _groupName);
374         }
375         _group.membersCount = _groupMembersCount;
376 
377         return OK;
378     }
379 
380     /// @notice Check is user registered
381     ///
382     /// @param _user user address
383     ///
384     /// @return status
385     function isRegisteredUser(address _user) public view returns (bool) {
386         return memberAddress2index[_user] != 0;
387     }
388 
389     /// @notice Check is user in group
390     ///
391     /// @param _groupName user array
392     /// @param _user user array
393     ///
394     /// @return status
395     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
396         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
397     }
398 
399     /// @notice Check is group exist
400     ///
401     /// @param _groupName group name
402     ///
403     /// @return status
404     function isGroupExists(bytes32 _groupName) public view returns (bool) {
405         return groupName2index[_groupName] != 0;
406     }
407 
408     /// @notice Get current group names
409     ///
410     /// @return group names
411     function getGroups() public view returns (bytes32[] _groups) {
412         uint _groupsCount = groupsCount;
413         _groups = new bytes32[](_groupsCount);
414         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
415             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
416         }
417     }
418 
419     // PRIVATE
420 
421     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
422         Member storage _member = address2member[_user];
423         uint _memberGroupsCount = _member.groupsCount;
424         uint _memberGroupIndex = _member.groupName2index[_groupName];
425         if (_memberGroupIndex != _memberGroupsCount) {
426             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
427             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
428             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
429             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
430         }
431         delete _member.groupName2index[_groupName];
432         delete _member.index2globalIndex[_memberGroupsCount];
433         _member.groupsCount = _memberGroupsCount.sub(1);
434     }
435 
436     function _addGroupToMember(address _user, bytes32 _groupName) private {
437         Member storage _member = address2member[_user];
438         uint _memberGroupsCount = _member.groupsCount.add(1);
439         _member.groupName2index[_groupName] = _memberGroupsCount;
440         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
441         _member.groupsCount = _memberGroupsCount;
442     }
443 }
444 
445 contract PendingManagerEmitter {
446 
447     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
448     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
449 
450     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
451     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
452     event ProtectionTxDone(bytes32 key);
453     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
454     event ProtectionTxCancelled(bytes32 key);
455     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
456     event TxDeleted(bytes32 key);
457 
458     event Error(uint errorCode);
459 
460     function _emitError(uint _errorCode) internal returns (uint) {
461         Error(_errorCode);
462         return _errorCode;
463     }
464 }
465 
466 contract PendingManagerInterface {
467 
468     function signIn(address _contract) external returns (uint);
469     function signOut(address _contract) external returns (uint);
470 
471     function addPolicyRule(
472         bytes4 _sig, 
473         address _contract, 
474         bytes32 _groupName, 
475         uint _acceptLimit, 
476         uint _declineLimit 
477         ) 
478         external returns (uint);
479         
480     function removePolicyRule(
481         bytes4 _sig, 
482         address _contract, 
483         bytes32 _groupName
484         ) 
485         external returns (uint);
486 
487     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
488     function deleteTx(bytes32 _key) external returns (uint);
489 
490     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
491     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
492     function revoke(bytes32 _key) external returns (uint);
493 
494     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
495     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
496         bytes32[] _groupNames,
497         uint[] _acceptLimits,
498         uint[] _declineLimits,
499         uint _totalAcceptedLimit,
500         uint _totalDeclinedLimit
501         );
502 }
503 
504 /// @title PendingManager
505 ///
506 /// Base implementation
507 /// This contract serves as pending manager for transaction status
508 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
509 
510     uint constant NO_RECORDS_WERE_FOUND = 4;
511     uint constant PENDING_MANAGER_SCOPE = 4000;
512     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
513     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
514     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
515     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
516     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
517     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
518     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
519     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
520     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
521     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
522     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
523 
524     using SafeMath for uint;
525 
526     enum GuardState {
527         Decline, Confirmed, InProcess
528     }
529 
530     struct Requirements {
531         bytes32 groupName;
532         uint acceptLimit;
533         uint declineLimit;
534     }
535 
536     struct Policy {
537         uint groupsCount;
538         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
539         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
540         
541         uint totalAcceptedLimit;
542         uint totalDeclinedLimit;
543 
544         uint securesCount;
545         mapping(uint => uint) index2txIndex;
546         mapping(uint => uint) txIndex2index;
547     }
548 
549     struct Vote {
550         bytes32 groupName;
551         bool accepted;
552     }
553 
554     struct Guard {
555         GuardState state;
556         uint basePolicyIndex;
557 
558         uint alreadyAccepted;
559         uint alreadyDeclined;
560         
561         mapping(address => Vote) votes; // member address => vote
562         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
563         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
564     }
565 
566     address public accessManager;
567 
568     mapping(address => bool) public authorized;
569 
570     uint public policiesCount;
571     mapping(uint => bytes32) index2PolicyId; // index => policy hash
572     mapping(bytes32 => uint) policyId2Index; // policy hash => index
573     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
574 
575     uint public txCount;
576     mapping(uint => bytes32) index2txKey;
577     mapping(bytes32 => uint) txKey2index; // tx key => index
578     mapping(bytes32 => Guard) txKey2guard;
579 
580     /// @dev Execution is allowed only by authorized contract
581     modifier onlyAuthorized {
582         if (authorized[msg.sender] || address(this) == msg.sender) {
583             _;
584         }
585     }
586 
587     /// @dev Pending Manager's constructor
588     ///
589     /// @param _accessManager access manager's address
590     function PendingManager(address _accessManager) public {
591         require(_accessManager != 0x0);
592         accessManager = _accessManager;
593     }
594 
595     function() payable public {
596         revert();
597     }
598 
599     /// @notice Update access manager address
600     ///
601     /// @param _accessManager access manager's address
602     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
603         require(_accessManager != 0x0);
604         accessManager = _accessManager;
605         return OK;
606     }
607 
608     /// @notice Sign in contract
609     ///
610     /// @param _contract contract's address
611     function signIn(address _contract) external onlyContractOwner returns (uint) {
612         require(_contract != 0x0);
613         authorized[_contract] = true;
614         return OK;
615     }
616 
617     /// @notice Sign out contract
618     ///
619     /// @param _contract contract's address
620     function signOut(address _contract) external onlyContractOwner returns (uint) {
621         require(_contract != 0x0);
622         delete authorized[_contract];
623         return OK;
624     }
625 
626     /// @notice Register new policy rule
627     /// Can be called only by contract owner
628     ///
629     /// @param _sig target method signature
630     /// @param _contract target contract address
631     /// @param _groupName group's name
632     /// @param _acceptLimit accepted vote limit
633     /// @param _declineLimit decline vote limit
634     ///
635     /// @return code
636     function addPolicyRule(
637         bytes4 _sig,
638         address _contract,
639         bytes32 _groupName,
640         uint _acceptLimit,
641         uint _declineLimit
642     )
643     onlyContractOwner
644     external
645     returns (uint)
646     {
647         require(_sig != 0x0);
648         require(_contract != 0x0);
649         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
650         require(_acceptLimit != 0);
651         require(_declineLimit != 0);
652 
653         bytes32 _policyHash = keccak256(_sig, _contract);
654         
655         if (policyId2Index[_policyHash] == 0) {
656             uint _policiesCount = policiesCount.add(1);
657             index2PolicyId[_policiesCount] = _policyHash;
658             policyId2Index[_policyHash] = _policiesCount;
659             policiesCount = _policiesCount;
660         }
661 
662         Policy storage _policy = policyId2policy[_policyHash];
663         uint _policyGroupsCount = _policy.groupsCount;
664 
665         if (_policy.groupName2index[_groupName] == 0) {
666             _policyGroupsCount += 1;
667             _policy.groupName2index[_groupName] = _policyGroupsCount;
668             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
669             _policy.groupsCount = _policyGroupsCount;
670         }
671 
672         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
673         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
674         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
675         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
676         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
677         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
678 
679         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
680         return OK;
681     }
682 
683     /// @notice Remove policy rule
684     /// Can be called only by contract owner
685     ///
686     /// @param _groupName group's name
687     ///
688     /// @return code
689     function removePolicyRule(
690         bytes4 _sig,
691         address _contract,
692         bytes32 _groupName
693     ) 
694     onlyContractOwner 
695     external 
696     returns (uint) 
697     {
698         require(_sig != bytes4(0));
699         require(_contract != 0x0);
700         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
701 
702         bytes32 _policyHash = keccak256(_sig, _contract);
703         Policy storage _policy = policyId2policy[_policyHash];
704         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
705 
706         if (_policyGroupNameIndex == 0) {
707             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
708         }
709 
710         uint _policyGroupsCount = _policy.groupsCount;
711         if (_policyGroupNameIndex != _policyGroupsCount) {
712             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
713             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
714             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
715         }
716 
717         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
718         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
719 
720         delete _policy.groupName2index[_groupName];
721         delete _policy.participatedGroups[_policyGroupsCount];
722         _policy.groupsCount = _policyGroupsCount.sub(1);
723 
724         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
725         return OK;
726     }
727 
728     /// @notice Add transaction
729     ///
730     /// @param _key transaction id
731     ///
732     /// @return code
733     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
734         require(_key != bytes32(0));
735         require(_sig != bytes4(0));
736         require(_contract != 0x0);
737 
738         bytes32 _policyHash = keccak256(_sig, _contract);
739         require(isPolicyExist(_policyHash));
740 
741         if (isTxExist(_key)) {
742             return _emitError(PENDING_DUPLICATE_TX);
743         }
744 
745         if (_policyHash == bytes32(0)) {
746             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
747         }
748 
749         uint _index = txCount.add(1);
750         txCount = _index;
751         index2txKey[_index] = _key;
752         txKey2index[_key] = _index;
753 
754         Guard storage _guard = txKey2guard[_key];
755         _guard.basePolicyIndex = policyId2Index[_policyHash];
756         _guard.state = GuardState.InProcess;
757 
758         Policy storage _policy = policyId2policy[_policyHash];
759         uint _counter = _policy.securesCount.add(1);
760         _policy.securesCount = _counter;
761         _policy.index2txIndex[_counter] = _index;
762         _policy.txIndex2index[_index] = _counter;
763 
764         ProtectionTxAdded(_key, _policyHash, block.number);
765         return OK;
766     }
767 
768     /// @notice Delete transaction
769     /// @param _key transaction id
770     /// @return code
771     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
772         require(_key != bytes32(0));
773 
774         if (!isTxExist(_key)) {
775             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
776         }
777 
778         uint _txsCount = txCount;
779         uint _txIndex = txKey2index[_key];
780         if (_txIndex != _txsCount) {
781             bytes32 _last = index2txKey[txCount];
782             index2txKey[_txIndex] = _last;
783             txKey2index[_last] = _txIndex;
784         }
785 
786         delete txKey2index[_key];
787         delete index2txKey[_txsCount];
788         txCount = _txsCount.sub(1);
789 
790         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
791         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
792         uint _counter = _policy.securesCount;
793         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
794         if (_policyTxIndex != _counter) {
795             uint _movedTxIndex = _policy.index2txIndex[_counter];
796             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
797             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
798         }
799 
800         delete _policy.index2txIndex[_counter];
801         delete _policy.txIndex2index[_txIndex];
802         _policy.securesCount = _counter.sub(1);
803 
804         TxDeleted(_key);
805         return OK;
806     }
807 
808     /// @notice Accept transaction
809     /// Can be called only by registered user in GroupsAccessManager
810     ///
811     /// @param _key transaction id
812     ///
813     /// @return code
814     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
815         if (!isTxExist(_key)) {
816             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
817         }
818 
819         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
820             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
821         }
822 
823         Guard storage _guard = txKey2guard[_key];
824         if (_guard.state != GuardState.InProcess) {
825             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
826         }
827 
828         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
829             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
830         }
831 
832         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
833         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
834         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
835         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
836             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
837         }
838 
839         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
840         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
841         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
842         _guard.alreadyAccepted = _alreadyAcceptedCount;
843 
844         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
845 
846         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
847             _guard.state = GuardState.Confirmed;
848             ProtectionTxDone(_key);
849         }
850 
851         return OK;
852     }
853 
854     /// @notice Decline transaction
855     /// Can be called only by registered user in GroupsAccessManager
856     ///
857     /// @param _key transaction id
858     ///
859     /// @return code
860     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
861         if (!isTxExist(_key)) {
862             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
863         }
864 
865         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
866             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
867         }
868 
869         Guard storage _guard = txKey2guard[_key];
870         if (_guard.state != GuardState.InProcess) {
871             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
872         }
873 
874         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
875             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
876         }
877 
878         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
879         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
880         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
881         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
882             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
883         }
884 
885         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
886         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
887         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
888         _guard.alreadyDeclined = _alreadyDeclinedCount;
889 
890 
891         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
892 
893         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
894             _guard.state = GuardState.Decline;
895             ProtectionTxCancelled(_key);
896         }
897 
898         return OK;
899     }
900 
901     /// @notice Revoke user votes for transaction
902     /// Can be called only by contract owner
903     ///
904     /// @param _key transaction id
905     /// @param _user target user address
906     ///
907     /// @return code
908     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
909         return _revoke(_key, _user);
910     }
911 
912     /// @notice Revoke vote for transaction
913     /// Can be called only by authorized user
914     /// @param _key transaction id
915     /// @return code
916     function revoke(bytes32 _key) external returns (uint) {
917         return _revoke(_key, msg.sender);
918     }
919 
920     /// @notice Check transaction status
921     /// @param _key transaction id
922     /// @return code
923     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
924         require(_key != bytes32(0));
925 
926         if (!isTxExist(_key)) {
927             return NO_RECORDS_WERE_FOUND;
928         }
929 
930         Guard storage _guard = txKey2guard[_key];
931         return _guard.state == GuardState.InProcess
932         ? PENDING_MANAGER_IN_PROCESS
933         : _guard.state == GuardState.Confirmed
934         ? OK
935         : PENDING_MANAGER_REJECTED;
936     }
937 
938 
939     /// @notice Check policy details
940     ///
941     /// @return _groupNames group names included in policies
942     /// @return _acceptLimits accept limit for group
943     /// @return _declineLimits decline limit for group
944     function getPolicyDetails(bytes4 _sig, address _contract)
945     public
946     view
947     returns (
948         bytes32[] _groupNames,
949         uint[] _acceptLimits,
950         uint[] _declineLimits,
951         uint _totalAcceptedLimit,
952         uint _totalDeclinedLimit
953     ) {
954         require(_sig != bytes4(0));
955         require(_contract != 0x0);
956         
957         bytes32 _policyHash = keccak256(_sig, _contract);
958         uint _policyIdx = policyId2Index[_policyHash];
959         if (_policyIdx == 0) {
960             return;
961         }
962 
963         Policy storage _policy = policyId2policy[_policyHash];
964         uint _policyGroupsCount = _policy.groupsCount;
965         _groupNames = new bytes32[](_policyGroupsCount);
966         _acceptLimits = new uint[](_policyGroupsCount);
967         _declineLimits = new uint[](_policyGroupsCount);
968 
969         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
970             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
971             _groupNames[_idx] = _requirements.groupName;
972             _acceptLimits[_idx] = _requirements.acceptLimit;
973             _declineLimits[_idx] = _requirements.declineLimit;
974         }
975 
976         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
977     }
978 
979     /// @notice Check policy include target group
980     /// @param _policyHash policy hash (sig, contract address)
981     /// @param _groupName group id
982     /// @return bool
983     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
984         Policy storage _policy = policyId2policy[_policyHash];
985         return _policy.groupName2index[_groupName] != 0;
986     }
987 
988     /// @notice Check is policy exist
989     /// @param _policyHash policy hash (sig, contract address)
990     /// @return bool
991     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
992         return policyId2Index[_policyHash] != 0;
993     }
994 
995     /// @notice Check is transaction exist
996     /// @param _key transaction id
997     /// @return bool
998     function isTxExist(bytes32 _key) public view returns (bool){
999         return txKey2index[_key] != 0;
1000     }
1001 
1002     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1003         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1004             _guard.state = GuardState.Decline;
1005         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1006             _guard.state = GuardState.Confirmed;
1007         } else if (_guard.state != GuardState.InProcess) {
1008             _guard.state = GuardState.InProcess;
1009         }
1010     }
1011 
1012     function _revoke(bytes32 _key, address _user) private returns (uint) {
1013         require(_key != bytes32(0));
1014         require(_user != 0x0);
1015 
1016         if (!isTxExist(_key)) {
1017             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1018         }
1019 
1020         Guard storage _guard = txKey2guard[_key];
1021         if (_guard.state != GuardState.InProcess) {
1022             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1023         }
1024 
1025         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1026         if (_votedGroupName == bytes32(0)) {
1027             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1028         }
1029 
1030         bool isAcceptedVote = _guard.votes[_user].accepted;
1031         if (isAcceptedVote) {
1032             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1033             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1034         } else {
1035             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1036             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1037 
1038         }
1039 
1040         delete _guard.votes[_user];
1041 
1042         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1043         return OK;
1044     }
1045 }