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
91 /**
92  * @title Generic owned destroyable contract
93  */
94 contract Object is Owned {
95     /**
96     *  Common result code. Means everything is fine.
97     */
98     uint constant OK = 1;
99     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
100 
101     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
102         for(uint i=0;i<tokens.length;i++) {
103             address token = tokens[i];
104             uint balance = ERC20Interface(token).balanceOf(this);
105             if(balance != 0)
106                 ERC20Interface(token).transfer(_to,balance);
107         }
108         return OK;
109     }
110 
111     function checkOnlyContractOwner() internal constant returns(uint) {
112         if (contractOwner == msg.sender) {
113             return OK;
114         }
115 
116         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
117     }
118 }
119 
120 /**
121 * @title SafeMath
122 * @dev Math operations with safety checks that throw on error
123 */
124 library SafeMath {
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a * b;
127         assert(a == 0 || c / a == b);
128         return c;
129     }
130 
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // assert(b > 0); // Solidity automatically throws when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135         return c;
136     }
137 
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         assert(c >= a);
146         return c;
147     }
148 }
149 
150 contract GroupsAccessManagerEmitter {
151 
152     event UserCreated(address user);
153     event UserDeleted(address user);
154     event GroupCreated(bytes32 groupName);
155     event GroupActivated(bytes32 groupName);
156     event GroupDeactivated(bytes32 groupName);
157     event UserToGroupAdded(address user, bytes32 groupName);
158     event UserFromGroupRemoved(address user, bytes32 groupName);
159 
160     event Error(uint errorCode);
161 
162     function _emitError(uint _errorCode) internal returns (uint) {
163         Error(_errorCode);
164         return _errorCode;
165     }
166 }
167 
168 /// @title Group Access Manager
169 ///
170 /// Base implementation
171 /// This contract serves as group manager
172 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
173 
174     uint constant USER_MANAGER_SCOPE = 111000;
175     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
176     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
177     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
178     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
179     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
180     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
181     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
182     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
183     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
184 
185     using SafeMath for uint;
186 
187     struct Member {
188         address addr;
189         uint groupsCount;
190         mapping(bytes32 => uint) groupName2index;
191         mapping(uint => uint) index2globalIndex;
192     }
193 
194     struct Group {
195         bytes32 name;
196         uint priority;
197         uint membersCount;
198         mapping(address => uint) memberAddress2index;
199         mapping(uint => uint) index2globalIndex;
200     }
201 
202     uint public membersCount;
203     mapping(uint => address) public index2memberAddress;
204     mapping(address => uint) public memberAddress2index;
205     mapping(address => Member) address2member;
206 
207     uint public groupsCount;
208     mapping(uint => bytes32) public index2groupName;
209     mapping(bytes32 => uint) public groupName2index;
210     mapping(bytes32 => Group) groupName2group;
211     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
212 
213     function() payable public {
214         revert();
215     }
216 
217     /// @notice Register user
218     /// Can be called only by contract owner
219     ///
220     /// @param _user user address
221     ///
222     /// @return code
223     function registerUser(address _user) external onlyContractOwner returns (uint) {
224         require(_user != 0x0);
225 
226         if (isRegisteredUser(_user)) {
227             return _emitError(USER_MANAGER_MEMBER_ALREADY_EXIST);
228         }
229 
230         uint _membersCount = membersCount.add(1);
231         membersCount = _membersCount;
232         memberAddress2index[_user] = _membersCount;
233         index2memberAddress[_membersCount] = _user;
234         address2member[_user] = Member(_user, 0);
235 
236         UserCreated(_user);
237         return OK;
238     }
239 
240     /// @notice Discard user registration
241     /// Can be called only by contract owner
242     ///
243     /// @param _user user address
244     ///
245     /// @return code
246     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
247         require(_user != 0x0);
248 
249         uint _memberIndex = memberAddress2index[_user];
250         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
251             return _emitError(USER_MANAGER_INVALID_INVOCATION);
252         }
253 
254         uint _membersCount = membersCount;
255         delete memberAddress2index[_user];
256         if (_memberIndex != _membersCount) {
257             address _lastUser = index2memberAddress[_membersCount];
258             index2memberAddress[_memberIndex] = _lastUser;
259             memberAddress2index[_lastUser] = _memberIndex;
260         }
261         delete address2member[_user];
262         delete index2memberAddress[_membersCount];
263         delete memberAddress2index[_user];
264         membersCount = _membersCount.sub(1);
265 
266         UserDeleted(_user);
267         return OK;
268     }
269 
270     /// @notice Create group
271     /// Can be called only by contract owner
272     ///
273     /// @param _groupName group name
274     /// @param _priority group priority
275     ///
276     /// @return code
277     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
278         require(_groupName != bytes32(0));
279 
280         if (isGroupExists(_groupName)) {
281             return _emitError(USER_MANAGER_GROUP_ALREADY_EXIST);
282         }
283 
284         uint _groupsCount = groupsCount.add(1);
285         groupName2index[_groupName] = _groupsCount;
286         index2groupName[_groupsCount] = _groupName;
287         groupName2group[_groupName] = Group(_groupName, _priority, 0);
288         groupsCount = _groupsCount;
289 
290         GroupCreated(_groupName);
291         return OK;
292     }
293 
294     /// @notice Change group status
295     /// Can be called only by contract owner
296     ///
297     /// @param _groupName group name
298     /// @param _blocked block status
299     ///
300     /// @return code
301     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
302         require(isGroupExists(_groupName));
303         groupsBlocked[_groupName] = _blocked;
304         return OK;
305     }
306 
307     /// @notice Add users in group
308     /// Can be called only by contract owner
309     ///
310     /// @param _groupName group name
311     /// @param _users user array
312     ///
313     /// @return code
314     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
315         require(isGroupExists(_groupName));
316 
317         Group storage _group = groupName2group[_groupName];
318         uint _groupMembersCount = _group.membersCount;
319 
320         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
321             address _user = _users[_userIdx];
322             uint _memberIndex = memberAddress2index[_user];
323             require(_memberIndex != 0);
324 
325             if (_group.memberAddress2index[_user] != 0) {
326                 continue;
327             }
328 
329             _groupMembersCount = _groupMembersCount.add(1);
330             _group.memberAddress2index[_user] = _groupMembersCount;
331             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
332 
333             _addGroupToMember(_user, _groupName);
334 
335             UserToGroupAdded(_user, _groupName);
336         }
337         _group.membersCount = _groupMembersCount;
338 
339         return OK;
340     }
341 
342     /// @notice Remove users in group
343     /// Can be called only by contract owner
344     ///
345     /// @param _groupName group name
346     /// @param _users user array
347     ///
348     /// @return code
349     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
350         require(isGroupExists(_groupName));
351 
352         Group storage _group = groupName2group[_groupName];
353         uint _groupMembersCount = _group.membersCount;
354 
355         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
356             address _user = _users[_userIdx];
357             uint _memberIndex = memberAddress2index[_user];
358             uint _groupMemberIndex = _group.memberAddress2index[_user];
359 
360             if (_memberIndex == 0 || _groupMemberIndex == 0) {
361                 continue;
362             }
363 
364             if (_groupMemberIndex != _groupMembersCount) {
365                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
366                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
367                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
368                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
369             }
370             delete _group.memberAddress2index[_user];
371             delete _group.index2globalIndex[_groupMembersCount];
372             _groupMembersCount = _groupMembersCount.sub(1);
373 
374             _removeGroupFromMember(_user, _groupName);
375 
376             UserFromGroupRemoved(_user, _groupName);
377         }
378         _group.membersCount = _groupMembersCount;
379 
380         return OK;
381     }
382 
383     /// @notice Check is user registered
384     ///
385     /// @param _user user address
386     ///
387     /// @return status
388     function isRegisteredUser(address _user) public view returns (bool) {
389         return memberAddress2index[_user] != 0;
390     }
391 
392     /// @notice Check is user in group
393     ///
394     /// @param _groupName user array
395     /// @param _user user array
396     ///
397     /// @return status
398     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
399         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
400     }
401 
402     /// @notice Check is group exist
403     ///
404     /// @param _groupName group name
405     ///
406     /// @return status
407     function isGroupExists(bytes32 _groupName) public view returns (bool) {
408         return groupName2index[_groupName] != 0;
409     }
410 
411     /// @notice Get current group names
412     ///
413     /// @return group names
414     function getGroups() public view returns (bytes32[] _groups) {
415         uint _groupsCount = groupsCount;
416         _groups = new bytes32[](_groupsCount);
417         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
418             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
419         }
420     }
421 
422     /// @notice Gets group members
423     function getGroupMembers(bytes32 _groupName) 
424     public 
425     view 
426     returns (address[] _members) 
427     {
428         if (!isGroupExists(_groupName)) {
429             return;
430         }
431 
432         Group storage _group = groupName2group[_groupName];
433         uint _membersCount = _group.membersCount;
434         if (_membersCount == 0) {
435             return;
436         }
437 
438         _members = new address[](_membersCount);
439         for (uint _userIdx = 0; _userIdx < _membersCount; ++_userIdx) {
440             uint _memberIdx = _group.index2globalIndex[_userIdx + 1];
441             _members[_userIdx] = index2memberAddress[_memberIdx];
442         }
443     }
444 
445     /// @notice Gets a list of groups where passed user is a member
446     function getUserGroups(address _user)
447     public
448     view
449     returns (bytes32[] _groups)
450     {
451         if (!isRegisteredUser(_user)) {
452             return;
453         }
454 
455         Member storage _member = address2member[_user];
456         uint _groupsCount = _member.groupsCount;
457         if (_groupsCount == 0) {
458             return;
459         }
460 
461         _groups = new bytes32[](_groupsCount);
462         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
463             uint _groupNameIdx = _member.index2globalIndex[_groupIdx + 1];
464             _groups[_groupIdx] = index2groupName[_groupNameIdx];
465         }
466 
467     }
468 
469     // PRIVATE
470 
471     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
472         Member storage _member = address2member[_user];
473         uint _memberGroupsCount = _member.groupsCount;
474         uint _memberGroupIndex = _member.groupName2index[_groupName];
475         if (_memberGroupIndex != _memberGroupsCount) {
476             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
477             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
478             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
479             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
480         }
481         delete _member.groupName2index[_groupName];
482         delete _member.index2globalIndex[_memberGroupsCount];
483         _member.groupsCount = _memberGroupsCount.sub(1);
484     }
485 
486     function _addGroupToMember(address _user, bytes32 _groupName) private {
487         Member storage _member = address2member[_user];
488         uint _memberGroupsCount = _member.groupsCount.add(1);
489         _member.groupName2index[_groupName] = _memberGroupsCount;
490         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
491         _member.groupsCount = _memberGroupsCount;
492     }
493 }
494 
495 contract PendingManagerEmitter {
496 
497     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
498     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
499 
500     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
501     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
502     event ProtectionTxDone(bytes32 key);
503     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
504     event ProtectionTxCancelled(bytes32 key);
505     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
506     event TxDeleted(bytes32 key);
507 
508     event Error(uint errorCode);
509 
510     function _emitError(uint _errorCode) internal returns (uint) {
511         Error(_errorCode);
512         return _errorCode;
513     }
514 }
515 
516 contract PendingManagerInterface {
517 
518     function signIn(address _contract) external returns (uint);
519     function signOut(address _contract) external returns (uint);
520 
521     function addPolicyRule(
522         bytes4 _sig, 
523         address _contract, 
524         bytes32 _groupName, 
525         uint _acceptLimit, 
526         uint _declineLimit 
527         ) 
528         external returns (uint);
529         
530     function removePolicyRule(
531         bytes4 _sig, 
532         address _contract, 
533         bytes32 _groupName
534         ) 
535         external returns (uint);
536 
537     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
538     function deleteTx(bytes32 _key) external returns (uint);
539 
540     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
541     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
542     function revoke(bytes32 _key) external returns (uint);
543 
544     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
545     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
546         bytes32[] _groupNames,
547         uint[] _acceptLimits,
548         uint[] _declineLimits,
549         uint _totalAcceptedLimit,
550         uint _totalDeclinedLimit
551         );
552 }
553 
554 /// @title PendingManager
555 ///
556 /// Base implementation
557 /// This contract serves as pending manager for transaction status
558 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
559 
560     uint constant NO_RECORDS_WERE_FOUND = 4;
561     uint constant PENDING_MANAGER_SCOPE = 4000;
562     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
563     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
564     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
565     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
566     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
567     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
568     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
569     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
570     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
571     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
572     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
573 
574     using SafeMath for uint;
575 
576     enum GuardState {
577         Decline, Confirmed, InProcess
578     }
579 
580     struct Requirements {
581         bytes32 groupName;
582         uint acceptLimit;
583         uint declineLimit;
584     }
585 
586     struct Policy {
587         uint groupsCount;
588         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
589         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
590         
591         uint totalAcceptedLimit;
592         uint totalDeclinedLimit;
593 
594         bytes4 sig;
595         address contractAddress;
596 
597         uint securesCount;
598         mapping(uint => uint) index2txIndex;
599         mapping(uint => uint) txIndex2index;
600     }
601 
602     struct Vote {
603         bytes32 groupName;
604         bool accepted;
605     }
606 
607     struct Guard {
608         GuardState state;
609         uint basePolicyIndex;
610 
611         uint alreadyAccepted;
612         uint alreadyDeclined;
613         
614         mapping(address => Vote) votes; // member address => vote
615         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
616         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
617     }
618 
619     address public accessManager;
620 
621     mapping(address => bool) public authorized;
622 
623     uint public policiesCount;
624     mapping(uint => bytes32) public index2PolicyId; // index => policy hash
625     mapping(bytes32 => uint) public policyId2Index; // policy hash => index
626     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
627 
628     uint public txCount;
629     mapping(uint => bytes32) public index2txKey;
630     mapping(bytes32 => uint) public txKey2index; // tx key => index
631     mapping(bytes32 => Guard) txKey2guard;
632 
633     /// @dev Execution is allowed only by authorized contract
634     modifier onlyAuthorized {
635         if (authorized[msg.sender] || address(this) == msg.sender) {
636             _;
637         }
638     }
639 
640     /// @dev Pending Manager's constructor
641     ///
642     /// @param _accessManager access manager's address
643     function PendingManager(address _accessManager) public {
644         require(_accessManager != 0x0);
645         accessManager = _accessManager;
646     }
647 
648     function() payable public {
649         revert();
650     }
651 
652     /// @notice Update access manager address
653     ///
654     /// @param _accessManager access manager's address
655     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
656         require(_accessManager != 0x0);
657         accessManager = _accessManager;
658         return OK;
659     }
660 
661     /// @notice Sign in contract
662     ///
663     /// @param _contract contract's address
664     function signIn(address _contract) external onlyContractOwner returns (uint) {
665         require(_contract != 0x0);
666         authorized[_contract] = true;
667         return OK;
668     }
669 
670     /// @notice Sign out contract
671     ///
672     /// @param _contract contract's address
673     function signOut(address _contract) external onlyContractOwner returns (uint) {
674         require(_contract != 0x0);
675         delete authorized[_contract];
676         return OK;
677     }
678 
679     /// @notice Register new policy rule
680     /// Can be called only by contract owner
681     ///
682     /// @param _sig target method signature
683     /// @param _contract target contract address
684     /// @param _groupName group's name
685     /// @param _acceptLimit accepted vote limit
686     /// @param _declineLimit decline vote limit
687     ///
688     /// @return code
689     function addPolicyRule(
690         bytes4 _sig,
691         address _contract,
692         bytes32 _groupName,
693         uint _acceptLimit,
694         uint _declineLimit
695     )
696     onlyContractOwner
697     external
698     returns (uint)
699     {
700         require(_sig != 0x0);
701         require(_contract != 0x0);
702         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
703         require(_acceptLimit != 0);
704         require(_declineLimit != 0);
705 
706         bytes32 _policyHash = keccak256(_sig, _contract);
707         
708         if (policyId2Index[_policyHash] == 0) {
709             uint _policiesCount = policiesCount.add(1);
710             index2PolicyId[_policiesCount] = _policyHash;
711             policyId2Index[_policyHash] = _policiesCount;
712             policiesCount = _policiesCount;
713         }
714 
715         Policy storage _policy = policyId2policy[_policyHash];
716         uint _policyGroupsCount = _policy.groupsCount;
717 
718         if (_policy.groupName2index[_groupName] == 0) {
719             _policyGroupsCount += 1;
720             _policy.groupName2index[_groupName] = _policyGroupsCount;
721             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
722             _policy.groupsCount = _policyGroupsCount;
723             _policy.sig = _sig;
724             _policy.contractAddress = _contract;
725         }
726 
727         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
728         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
729         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
730         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
731         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
732         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
733 
734         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
735         return OK;
736     }
737 
738     /// @notice Remove policy rule
739     /// Can be called only by contract owner
740     ///
741     /// @param _groupName group's name
742     ///
743     /// @return code
744     function removePolicyRule(
745         bytes4 _sig,
746         address _contract,
747         bytes32 _groupName
748     ) 
749     onlyContractOwner 
750     external 
751     returns (uint) 
752     {
753         require(_sig != bytes4(0));
754         require(_contract != 0x0);
755         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
756 
757         bytes32 _policyHash = keccak256(_sig, _contract);
758         Policy storage _policy = policyId2policy[_policyHash];
759         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
760 
761         if (_policyGroupNameIndex == 0) {
762             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
763         }
764 
765         uint _policyGroupsCount = _policy.groupsCount;
766         if (_policyGroupNameIndex != _policyGroupsCount) {
767             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
768             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
769             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
770         }
771 
772         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
773         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
774 
775         delete _policy.groupName2index[_groupName];
776         delete _policy.participatedGroups[_policyGroupsCount];
777         _policy.groupsCount = _policyGroupsCount.sub(1);
778 
779         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
780         return OK;
781     }
782 
783     /// @notice Add transaction
784     ///
785     /// @param _key transaction id
786     ///
787     /// @return code
788     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
789         require(_key != bytes32(0));
790         require(_sig != bytes4(0));
791         require(_contract != 0x0);
792 
793         bytes32 _policyHash = keccak256(_sig, _contract);
794         require(isPolicyExist(_policyHash));
795 
796         if (isTxExist(_key)) {
797             return _emitError(PENDING_DUPLICATE_TX);
798         }
799 
800         if (_policyHash == bytes32(0)) {
801             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
802         }
803 
804         uint _index = txCount.add(1);
805         txCount = _index;
806         index2txKey[_index] = _key;
807         txKey2index[_key] = _index;
808 
809         Guard storage _guard = txKey2guard[_key];
810         _guard.basePolicyIndex = policyId2Index[_policyHash];
811         _guard.state = GuardState.InProcess;
812 
813         Policy storage _policy = policyId2policy[_policyHash];
814         uint _counter = _policy.securesCount.add(1);
815         _policy.securesCount = _counter;
816         _policy.index2txIndex[_counter] = _index;
817         _policy.txIndex2index[_index] = _counter;
818 
819         ProtectionTxAdded(_key, _policyHash, block.number);
820         return OK;
821     }
822 
823     /// @notice Delete transaction
824     /// @param _key transaction id
825     /// @return code
826     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
827         require(_key != bytes32(0));
828 
829         if (!isTxExist(_key)) {
830             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
831         }
832 
833         uint _txsCount = txCount;
834         uint _txIndex = txKey2index[_key];
835         if (_txIndex != _txsCount) {
836             bytes32 _last = index2txKey[txCount];
837             index2txKey[_txIndex] = _last;
838             txKey2index[_last] = _txIndex;
839         }
840 
841         delete txKey2index[_key];
842         delete index2txKey[_txsCount];
843         txCount = _txsCount.sub(1);
844 
845         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
846         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
847         uint _counter = _policy.securesCount;
848         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
849         if (_policyTxIndex != _counter) {
850             uint _movedTxIndex = _policy.index2txIndex[_counter];
851             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
852             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
853         }
854 
855         delete _policy.index2txIndex[_counter];
856         delete _policy.txIndex2index[_txIndex];
857         _policy.securesCount = _counter.sub(1);
858 
859         TxDeleted(_key);
860         return OK;
861     }
862 
863     /// @notice Accept transaction
864     /// Can be called only by registered user in GroupsAccessManager
865     ///
866     /// @param _key transaction id
867     ///
868     /// @return code
869     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
870         if (!isTxExist(_key)) {
871             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
872         }
873 
874         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
875             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
876         }
877 
878         Guard storage _guard = txKey2guard[_key];
879         if (_guard.state != GuardState.InProcess) {
880             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
881         }
882 
883         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
884             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
885         }
886 
887         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
888         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
889         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
890         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
891             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
892         }
893 
894         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
895         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
896         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
897         _guard.alreadyAccepted = _alreadyAcceptedCount;
898 
899         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
900 
901         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
902             _guard.state = GuardState.Confirmed;
903             ProtectionTxDone(_key);
904         }
905 
906         return OK;
907     }
908 
909     /// @notice Decline transaction
910     /// Can be called only by registered user in GroupsAccessManager
911     ///
912     /// @param _key transaction id
913     ///
914     /// @return code
915     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
916         if (!isTxExist(_key)) {
917             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
918         }
919 
920         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
921             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
922         }
923 
924         Guard storage _guard = txKey2guard[_key];
925         if (_guard.state != GuardState.InProcess) {
926             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
927         }
928 
929         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
930             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
931         }
932 
933         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
934         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
935         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
936         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
937             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
938         }
939 
940         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
941         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
942         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
943         _guard.alreadyDeclined = _alreadyDeclinedCount;
944 
945 
946         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
947 
948         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
949             _guard.state = GuardState.Decline;
950             ProtectionTxCancelled(_key);
951         }
952 
953         return OK;
954     }
955 
956     /// @notice Revoke user votes for transaction
957     /// Can be called only by contract owner
958     ///
959     /// @param _key transaction id
960     /// @param _user target user address
961     ///
962     /// @return code
963     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
964         return _revoke(_key, _user);
965     }
966 
967     /// @notice Revoke vote for transaction
968     /// Can be called only by authorized user
969     /// @param _key transaction id
970     /// @return code
971     function revoke(bytes32 _key) external returns (uint) {
972         return _revoke(_key, msg.sender);
973     }
974 
975     /// @notice Check transaction status
976     /// @param _key transaction id
977     /// @return code
978     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
979         require(_key != bytes32(0));
980 
981         if (!isTxExist(_key)) {
982             return NO_RECORDS_WERE_FOUND;
983         }
984 
985         Guard storage _guard = txKey2guard[_key];
986         return _guard.state == GuardState.InProcess
987         ? PENDING_MANAGER_IN_PROCESS
988         : _guard.state == GuardState.Confirmed
989         ? OK
990         : PENDING_MANAGER_REJECTED;
991     }
992 
993 
994     /// @notice Check policy details
995     ///
996     /// @return _groupNames group names included in policies
997     /// @return _acceptLimits accept limit for group
998     /// @return _declineLimits decline limit for group
999     function getPolicyDetails(bytes4 _sig, address _contract)
1000     public
1001     view
1002     returns (
1003         bytes32[] _groupNames,
1004         uint[] _acceptLimits,
1005         uint[] _declineLimits,
1006         uint _totalAcceptedLimit,
1007         uint _totalDeclinedLimit
1008     ) {
1009         require(_sig != bytes4(0));
1010         require(_contract != 0x0);
1011         
1012         bytes32 _policyHash = keccak256(_sig, _contract);
1013         (_groupNames, _acceptLimits, _declineLimits, _totalAcceptedLimit, _totalDeclinedLimit, ) = getPolicyDetailsByHash(_policyHash);
1014     }
1015 
1016     /// @notice Check policy details
1017     function getPolicyDetailsByHash(bytes32 _policyHash)
1018     public 
1019     view 
1020     returns (
1021         bytes32[] _groupNames,
1022         uint[] _acceptLimits,
1023         uint[] _declineLimits,
1024         uint _totalAcceptedLimit,
1025         uint _totalDeclinedLimit,
1026         bytes4 _sig,
1027         address _contract
1028     ) {
1029         uint _policyIdx = policyId2Index[_policyHash];
1030         if (_policyIdx == 0) {
1031             return;
1032         }
1033 
1034         Policy storage _policy = policyId2policy[_policyHash];
1035         uint _policyGroupsCount = _policy.groupsCount;
1036         _groupNames = new bytes32[](_policyGroupsCount);
1037         _acceptLimits = new uint[](_policyGroupsCount);
1038         _declineLimits = new uint[](_policyGroupsCount);
1039 
1040         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1041             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1042             _groupNames[_idx] = _requirements.groupName;
1043             _acceptLimits[_idx] = _requirements.acceptLimit;
1044             _declineLimits[_idx] = _requirements.declineLimit;
1045         }
1046 
1047         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1048         (_sig, _contract) = (_policy.sig, _policy.contractAddress);
1049     }
1050 
1051     /// @notice Check policy include target group
1052     /// @param _policyHash policy hash (sig, contract address)
1053     /// @param _groupName group id
1054     /// @return bool
1055     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1056         Policy storage _policy = policyId2policy[_policyHash];
1057         return _policy.groupName2index[_groupName] != 0;
1058     }
1059 
1060     /// @notice Check is policy exist
1061     /// @param _policyHash policy hash (sig, contract address)
1062     /// @return bool
1063     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1064         return policyId2Index[_policyHash] != 0;
1065     }
1066 
1067     /// @notice Gets list of txs (paginated)
1068     function getTxs(uint _fromIdx, uint _maxLen) 
1069     public 
1070     view 
1071     returns (
1072         bytes32[] _txKeys,
1073         bytes32[] _policyHashes,
1074         uint[] _alreadyAccepted,
1075         uint[] _alreadyDeclined,
1076         uint[] _states
1077     ) {
1078         uint _count = txCount;
1079         require(_fromIdx < _count);
1080         _maxLen = (_fromIdx + _maxLen <= _count) ? _maxLen : (_count - _fromIdx);
1081 
1082         _txKeys = new bytes32[](_maxLen);
1083         _policyHashes = new bytes32[](_maxLen);
1084         _alreadyAccepted = new uint[](_maxLen);
1085         _alreadyDeclined = new uint[](_maxLen);
1086         _states = new uint[](_maxLen);
1087         uint _pointer = 0;
1088         for (uint _txIdx = _fromIdx; _txIdx < _fromIdx + _maxLen; ++_fromIdx) {
1089             bytes32 _txKey = index2txKey[_txIdx + 1];
1090             _txKeys[_pointer] = _txKey;
1091 
1092             Guard storage _guard = txKey2guard[_txKey];
1093             _policyHashes[_pointer] = index2PolicyId[_guard.basePolicyIndex];
1094             _alreadyAccepted[_pointer] = _guard.alreadyAccepted;
1095             _alreadyDeclined[_pointer] = _guard.alreadyDeclined;
1096             _states[_pointer] = uint(_guard.state);
1097             _pointer += 1;
1098         }
1099     }
1100 
1101     /// @notice Gets details about voting for a tx
1102     function getTxVoteDetails(bytes32 _txKey)
1103     public
1104     view 
1105     returns (
1106         bytes32[] _groupNames,
1107         uint[] _acceptedCount,
1108         uint[] _acceptLimit,
1109         uint[] _declinedCount,
1110         uint[] _declineLimit,
1111         uint _state
1112     ) {
1113         if (txKey2index[_txKey] == 0) {
1114             return;
1115         }
1116 
1117         Guard storage _guard = txKey2guard[_txKey];
1118         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1119         uint _groupsCount = _policy.groupsCount;
1120         _groupNames = new bytes32[](_groupsCount);
1121         _acceptedCount = new uint[](_groupsCount);
1122         _acceptLimit = new uint[](_groupsCount);
1123         _declinedCount = new uint[](_groupsCount);
1124         _declineLimit = new uint[](_groupsCount);
1125         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
1126             Requirements storage _requirement = _policy.participatedGroups[_groupIdx];
1127             bytes32 _groupName = _requirement.groupName;
1128             _groupNames[_groupIdx] = _groupName;
1129             _acceptedCount[_groupIdx] = _guard.acceptedCount[_groupName];
1130             _acceptLimit[_groupIdx] = _requirement.acceptLimit;
1131             _declinedCount[_groupIdx] = _guard.declinedCount[_groupName];
1132             _declineLimit[_groupIdx] = _requirement.declineLimit;
1133         }
1134 
1135         _state = uint(_guard.state);
1136     }
1137 
1138     /// @notice Get singe decision vote of a user for a tx
1139     function getVoteAtTxForUser(bytes32 _txKey, address _user)
1140     public
1141     view
1142     returns (
1143         bytes32 _groupName,
1144         bool _accepted
1145     ) {
1146         if (txKey2index[_txKey] == 0) {
1147             return;
1148         }
1149 
1150         Guard storage _guard = txKey2guard[_txKey];
1151         Vote memory _vote = _guard.votes[_user];
1152         (_groupName, _accepted) = (_vote.groupName, _vote.accepted);
1153     }
1154 
1155     /// @notice Check is transaction exist
1156     /// @param _key transaction id
1157     /// @return bool
1158     function isTxExist(bytes32 _key) public view returns (bool){
1159         return txKey2index[_key] != 0;
1160     }
1161 
1162     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1163         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1164             _guard.state = GuardState.Decline;
1165         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1166             _guard.state = GuardState.Confirmed;
1167         } else if (_guard.state != GuardState.InProcess) {
1168             _guard.state = GuardState.InProcess;
1169         }
1170     }
1171 
1172     function _revoke(bytes32 _key, address _user) private returns (uint) {
1173         require(_key != bytes32(0));
1174         require(_user != 0x0);
1175 
1176         if (!isTxExist(_key)) {
1177             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1178         }
1179 
1180         Guard storage _guard = txKey2guard[_key];
1181         if (_guard.state != GuardState.InProcess) {
1182             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1183         }
1184 
1185         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1186         if (_votedGroupName == bytes32(0)) {
1187             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1188         }
1189 
1190         bool isAcceptedVote = _guard.votes[_user].accepted;
1191         if (isAcceptedVote) {
1192             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1193             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1194         } else {
1195             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1196             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1197 
1198         }
1199 
1200         delete _guard.votes[_user];
1201 
1202         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1203         return OK;
1204     }
1205 }