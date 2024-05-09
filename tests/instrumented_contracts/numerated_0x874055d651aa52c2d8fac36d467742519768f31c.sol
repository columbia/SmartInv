1 pragma solidity ^0.4.11;
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
159 }
160 
161 /// @title Group Access Manager
162 ///
163 /// Base implementation
164 /// This contract serves as group manager
165 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
166 
167     uint constant USER_MANAGER_SCOPE = 111000;
168     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
169     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
170     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
171     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
172     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
173     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
174     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
175     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
176     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
177 
178     using SafeMath for uint;
179 
180     struct Member {
181         address addr;
182         uint groupsCount;
183         mapping(bytes32 => uint) groupName2index;
184         mapping(uint => uint) index2globalIndex;
185     }
186 
187     struct Group {
188         bytes32 name;
189         uint priority;
190         uint membersCount;
191         mapping(address => uint) memberAddress2index;
192         mapping(uint => uint) index2globalIndex;
193     }
194 
195     uint public membersCount;
196     mapping(uint => address) index2memberAddress;
197     mapping(address => uint) memberAddress2index;
198     mapping(address => Member) address2member;
199 
200     uint public groupsCount;
201     mapping(uint => bytes32) index2groupName;
202     mapping(bytes32 => uint) groupName2index;
203     mapping(bytes32 => Group) groupName2group;
204     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
205 
206     function() payable public {
207         revert();
208     }
209 
210     /// @notice Register user
211     /// Can be called only by contract owner
212     ///
213     /// @param _user user address
214     ///
215     /// @return code
216     function registerUser(address _user) external onlyContractOwner returns (uint) {
217         require(_user != 0x0);
218 
219         if (isRegisteredUser(_user)) {
220             return USER_MANAGER_MEMBER_ALREADY_EXIST;
221         }
222 
223         uint _membersCount = membersCount.add(1);
224         membersCount = _membersCount;
225         memberAddress2index[_user] = _membersCount;
226         index2memberAddress[_membersCount] = _user;
227         address2member[_user] = Member(_user, 0);
228 
229         UserCreated(_user);
230         return OK;
231     }
232 
233     /// @notice Discard user registration
234     /// Can be called only by contract owner
235     ///
236     /// @param _user user address
237     ///
238     /// @return code
239     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
240         require(_user != 0x0);
241 
242         uint _memberIndex = memberAddress2index[_user];
243         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
244             return USER_MANAGER_INVALID_INVOCATION;
245         }
246 
247         uint _membersCount = membersCount;
248         delete memberAddress2index[_user];
249         if (_memberIndex != _membersCount) {
250             address _lastUser = index2memberAddress[_membersCount];
251             index2memberAddress[_memberIndex] = _lastUser;
252             memberAddress2index[_lastUser] = _memberIndex;
253         }
254         delete address2member[_user];
255         delete index2memberAddress[_membersCount];
256         delete memberAddress2index[_user];
257         membersCount = _membersCount.sub(1);
258 
259         UserDeleted(_user);
260         return OK;
261     }
262 
263     /// @notice Create group
264     /// Can be called only by contract owner
265     ///
266     /// @param _groupName group name
267     /// @param _priority group priority
268     ///
269     /// @return code
270     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
271         require(_groupName != bytes32(0));
272 
273         if (isGroupExists(_groupName)) {
274             return USER_MANAGER_GROUP_ALREADY_EXIST;
275         }
276 
277         uint _groupsCount = groupsCount.add(1);
278         groupName2index[_groupName] = _groupsCount;
279         index2groupName[_groupsCount] = _groupName;
280         groupName2group[_groupName] = Group(_groupName, _priority, 0);
281         groupsCount = _groupsCount;
282 
283         GroupCreated(_groupName);
284         return OK;
285     }
286 
287     /// @notice Change group status
288     /// Can be called only by contract owner
289     ///
290     /// @param _groupName group name
291     /// @param _blocked block status
292     ///
293     /// @return code
294     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
295         require(isGroupExists(_groupName));
296         groupsBlocked[_groupName] = _blocked;
297         return OK;
298     }
299 
300     /// @notice Add users in group
301     /// Can be called only by contract owner
302     ///
303     /// @param _groupName group name
304     /// @param _users user array
305     ///
306     /// @return code
307     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
308         require(isGroupExists(_groupName));
309 
310         Group storage _group = groupName2group[_groupName];
311         uint _groupMembersCount = _group.membersCount;
312 
313         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
314             address _user = _users[_userIdx];
315             uint _memberIndex = memberAddress2index[_user];
316             require(_memberIndex != 0);
317 
318             if (_group.memberAddress2index[_user] != 0) {
319                 continue;
320             }
321 
322             _groupMembersCount = _groupMembersCount.add(1);
323             _group.memberAddress2index[_user] = _groupMembersCount;
324             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
325 
326             _addGroupToMember(_user, _groupName);
327 
328             UserToGroupAdded(_user, _groupName);
329         }
330         _group.membersCount = _groupMembersCount;
331 
332         return OK;
333     }
334 
335     /// @notice Remove users in group
336     /// Can be called only by contract owner
337     ///
338     /// @param _groupName group name
339     /// @param _users user array
340     ///
341     /// @return code
342     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
343         require(isGroupExists(_groupName));
344 
345         Group storage _group = groupName2group[_groupName];
346         uint _groupMembersCount = _group.membersCount;
347 
348         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
349             address _user = _users[_userIdx];
350             uint _memberIndex = memberAddress2index[_user];
351             uint _groupMemberIndex = _group.memberAddress2index[_user];
352 
353             if (_memberIndex == 0 || _groupMemberIndex == 0) {
354                 continue;
355             }
356 
357             if (_groupMemberIndex != _groupMembersCount) {
358                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
359                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
360                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
361                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
362             }
363             delete _group.memberAddress2index[_user];
364             delete _group.index2globalIndex[_groupMembersCount];
365             _groupMembersCount = _groupMembersCount.sub(1);
366 
367             _removeGroupFromMember(_user, _groupName);
368 
369             UserFromGroupRemoved(_user, _groupName);
370         }
371         _group.membersCount = _groupMembersCount;
372 
373         return OK;
374     }
375 
376     /// @notice Check is user registered
377     ///
378     /// @param _user user address
379     ///
380     /// @return status
381     function isRegisteredUser(address _user) public view returns (bool) {
382         return memberAddress2index[_user] != 0;
383     }
384 
385     /// @notice Check is user in group
386     ///
387     /// @param _groupName user array
388     /// @param _user user array
389     ///
390     /// @return status
391     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
392         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
393     }
394 
395     /// @notice Check is group exist
396     ///
397     /// @param _groupName group name
398     ///
399     /// @return status
400     function isGroupExists(bytes32 _groupName) public view returns (bool) {
401         return groupName2index[_groupName] != 0;
402     }
403 
404     /// @notice Get current group names
405     ///
406     /// @return group names
407     function getGroups() public view returns (bytes32[] _groups) {
408         uint _groupsCount = groupsCount;
409         _groups = new bytes32[](_groupsCount);
410         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
411             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
412         }
413     }
414 
415     // PRIVATE
416 
417     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
418         Member storage _member = address2member[_user];
419         uint _memberGroupsCount = _member.groupsCount;
420         uint _memberGroupIndex = _member.groupName2index[_groupName];
421         if (_memberGroupIndex != _memberGroupsCount) {
422             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
423             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
424             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
425             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
426         }
427         delete _member.groupName2index[_groupName];
428         delete _member.index2globalIndex[_memberGroupsCount];
429         _member.groupsCount = _memberGroupsCount.sub(1);
430     }
431 
432     function _addGroupToMember(address _user, bytes32 _groupName) private {
433         Member storage _member = address2member[_user];
434         uint _memberGroupsCount = _member.groupsCount.add(1);
435         _member.groupName2index[_groupName] = _memberGroupsCount;
436         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
437         _member.groupsCount = _memberGroupsCount;
438     }
439 }
440 
441 contract PendingManagerEmitter {
442 
443     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
444     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
445 
446     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
447     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
448     event ProtectionTxDone(bytes32 key);
449     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
450     event ProtectionTxCancelled(bytes32 key);
451     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
452     event TxDeleted(bytes32 key);
453 
454     event Error(uint errorCode);
455 
456     function _emitError(uint _errorCode) internal returns (uint) {
457         Error(_errorCode);
458         return _errorCode;
459     }
460 }
461 
462 contract PendingManagerInterface {
463 
464     function signIn(address _contract) external returns (uint);
465     function signOut(address _contract) external returns (uint);
466 
467     function addPolicyRule(
468         bytes4 _sig, 
469         address _contract, 
470         bytes32 _groupName, 
471         uint _acceptLimit, 
472         uint _declineLimit 
473         ) 
474         external returns (uint);
475         
476     function removePolicyRule(
477         bytes4 _sig, 
478         address _contract, 
479         bytes32 _groupName
480         ) 
481         external returns (uint);
482 
483     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
484     function deleteTx(bytes32 _key) external returns (uint);
485 
486     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
487     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
488     function revoke(bytes32 _key) external returns (uint);
489 
490     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
491     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
492         bytes32[] _groupNames,
493         uint[] _acceptLimits,
494         uint[] _declineLimits,
495         uint _totalAcceptedLimit,
496         uint _totalDeclinedLimit
497         );
498 }
499 
500 /// @title PendingManager
501 ///
502 /// Base implementation
503 /// This contract serves as pending manager for transaction status
504 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
505 
506     uint constant NO_RECORDS_WERE_FOUND = 4;
507     uint constant PENDING_MANAGER_SCOPE = 4000;
508     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
509     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
510     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
511     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
512     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
513     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
514     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
515     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
516     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
517     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
518     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
519 
520     using SafeMath for uint;
521 
522     enum GuardState {
523         Decline, Confirmed, InProcess
524     }
525 
526     struct Requirements {
527         bytes32 groupName;
528         uint acceptLimit;
529         uint declineLimit;
530     }
531 
532     struct Policy {
533         uint groupsCount;
534         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
535         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
536         
537         uint totalAcceptedLimit;
538         uint totalDeclinedLimit;
539 
540         uint securesCount;
541         mapping(uint => uint) index2txIndex;
542         mapping(uint => uint) txIndex2index;
543     }
544 
545     struct Vote {
546         bytes32 groupName;
547         bool accepted;
548     }
549 
550     struct Guard {
551         GuardState state;
552         uint basePolicyIndex;
553 
554         uint alreadyAccepted;
555         uint alreadyDeclined;
556         
557         mapping(address => Vote) votes; // member address => vote
558         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
559         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
560     }
561 
562     address public accessManager;
563 
564     mapping(address => bool) public authorized;
565 
566     uint public policiesCount;
567     mapping(uint => bytes32) index2PolicyId; // index => policy hash
568     mapping(bytes32 => uint) policyId2Index; // policy hash => index
569     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
570 
571     uint public txCount;
572     mapping(uint => bytes32) index2txKey;
573     mapping(bytes32 => uint) txKey2index; // tx key => index
574     mapping(bytes32 => Guard) txKey2guard;
575 
576     /// @dev Execution is allowed only by authorized contract
577     modifier onlyAuthorized {
578         if (authorized[msg.sender] || address(this) == msg.sender) {
579             _;
580         }
581     }
582 
583     /// @dev Pending Manager's constructor
584     ///
585     /// @param _accessManager access manager's address
586     function PendingManager(address _accessManager) public {
587         require(_accessManager != 0x0);
588         accessManager = _accessManager;
589     }
590 
591     function() payable public {
592         revert();
593     }
594 
595     /// @notice Update access manager address
596     ///
597     /// @param _accessManager access manager's address
598     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
599         require(_accessManager != 0x0);
600         accessManager = _accessManager;
601         return OK;
602     }
603 
604     /// @notice Sign in contract
605     ///
606     /// @param _contract contract's address
607     function signIn(address _contract) external onlyContractOwner returns (uint) {
608         require(_contract != 0x0);
609         authorized[_contract] = true;
610         return OK;
611     }
612 
613     /// @notice Sign out contract
614     ///
615     /// @param _contract contract's address
616     function signOut(address _contract) external onlyContractOwner returns (uint) {
617         require(_contract != 0x0);
618         delete authorized[_contract];
619         return OK;
620     }
621 
622     /// @notice Register new policy rule
623     /// Can be called only by contract owner
624     ///
625     /// @param _sig target method signature
626     /// @param _contract target contract address
627     /// @param _groupName group's name
628     /// @param _acceptLimit accepted vote limit
629     /// @param _declineLimit decline vote limit
630     ///
631     /// @return code
632     function addPolicyRule(
633         bytes4 _sig,
634         address _contract,
635         bytes32 _groupName,
636         uint _acceptLimit,
637         uint _declineLimit
638     )
639     onlyContractOwner
640     external
641     returns (uint)
642     {
643         require(_sig != 0x0);
644         require(_contract != 0x0);
645         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
646         require(_acceptLimit != 0);
647         require(_declineLimit != 0);
648 
649         bytes32 _policyHash = keccak256(_sig, _contract);
650         
651         if (policyId2Index[_policyHash] == 0) {
652             uint _policiesCount = policiesCount.add(1);
653             index2PolicyId[_policiesCount] = _policyHash;
654             policyId2Index[_policyHash] = _policiesCount;
655             policiesCount = _policiesCount;
656         }
657 
658         Policy storage _policy = policyId2policy[_policyHash];
659         uint _policyGroupsCount = _policy.groupsCount;
660 
661         if (_policy.groupName2index[_groupName] == 0) {
662             _policyGroupsCount += 1;
663             _policy.groupName2index[_groupName] = _policyGroupsCount;
664             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
665             _policy.groupsCount = _policyGroupsCount;
666         }
667 
668         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
669         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
670         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
671         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
672         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
673         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
674 
675         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
676         return OK;
677     }
678 
679     /// @notice Remove policy rule
680     /// Can be called only by contract owner
681     ///
682     /// @param _groupName group's name
683     ///
684     /// @return code
685     function removePolicyRule(
686         bytes4 _sig,
687         address _contract,
688         bytes32 _groupName
689     ) 
690     onlyContractOwner 
691     external 
692     returns (uint) 
693     {
694         require(_sig != bytes4(0));
695         require(_contract != 0x0);
696         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
697 
698         bytes32 _policyHash = keccak256(_sig, _contract);
699         Policy storage _policy = policyId2policy[_policyHash];
700         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
701 
702         if (_policyGroupNameIndex == 0) {
703             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
704         }
705 
706         uint _policyGroupsCount = _policy.groupsCount;
707         if (_policyGroupNameIndex != _policyGroupsCount) {
708             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
709             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
710             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
711         }
712 
713         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
714         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
715 
716         delete _policy.groupName2index[_groupName];
717         delete _policy.participatedGroups[_policyGroupsCount];
718         _policy.groupsCount = _policyGroupsCount.sub(1);
719 
720         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
721         return OK;
722     }
723 
724     /// @notice Add transaction
725     ///
726     /// @param _key transaction id
727     ///
728     /// @return code
729     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
730         require(_key != bytes32(0));
731         require(_sig != bytes4(0));
732         require(_contract != 0x0);
733 
734         bytes32 _policyHash = keccak256(_sig, _contract);
735         require(isPolicyExist(_policyHash));
736 
737         if (isTxExist(_key)) {
738             return _emitError(PENDING_DUPLICATE_TX);
739         }
740 
741         if (_policyHash == bytes32(0)) {
742             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
743         }
744 
745         uint _index = txCount.add(1);
746         txCount = _index;
747         index2txKey[_index] = _key;
748         txKey2index[_key] = _index;
749 
750         Guard storage _guard = txKey2guard[_key];
751         _guard.basePolicyIndex = policyId2Index[_policyHash];
752         _guard.state = GuardState.InProcess;
753 
754         Policy storage _policy = policyId2policy[_policyHash];
755         uint _counter = _policy.securesCount.add(1);
756         _policy.securesCount = _counter;
757         _policy.index2txIndex[_counter] = _index;
758         _policy.txIndex2index[_index] = _counter;
759 
760         ProtectionTxAdded(_key, _policyHash, block.number);
761         return OK;
762     }
763 
764     /// @notice Delete transaction
765     /// @param _key transaction id
766     /// @return code
767     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
768         require(_key != bytes32(0));
769 
770         if (!isTxExist(_key)) {
771             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
772         }
773 
774         uint _txsCount = txCount;
775         uint _txIndex = txKey2index[_key];
776         if (_txIndex != _txsCount) {
777             bytes32 _last = index2txKey[txCount];
778             index2txKey[_txIndex] = _last;
779             txKey2index[_last] = _txIndex;
780         }
781 
782         delete txKey2index[_key];
783         delete index2txKey[_txsCount];
784         txCount = _txsCount.sub(1);
785 
786         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
787         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
788         uint _counter = _policy.securesCount;
789         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
790         if (_policyTxIndex != _counter) {
791             uint _movedTxIndex = _policy.index2txIndex[_counter];
792             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
793             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
794         }
795 
796         delete _policy.index2txIndex[_counter];
797         delete _policy.txIndex2index[_txIndex];
798         _policy.securesCount = _counter.sub(1);
799 
800         TxDeleted(_key);
801         return OK;
802     }
803 
804     /// @notice Accept transaction
805     /// Can be called only by registered user in GroupsAccessManager
806     ///
807     /// @param _key transaction id
808     ///
809     /// @return code
810     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
811         if (!isTxExist(_key)) {
812             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
813         }
814 
815         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
816             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
817         }
818 
819         Guard storage _guard = txKey2guard[_key];
820         if (_guard.state != GuardState.InProcess) {
821             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
822         }
823 
824         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
825             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
826         }
827 
828         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
829         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
830         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
831         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
832             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
833         }
834 
835         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
836         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
837         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
838         _guard.alreadyAccepted = _alreadyAcceptedCount;
839 
840         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
841 
842         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
843             _guard.state = GuardState.Confirmed;
844             ProtectionTxDone(_key);
845         }
846 
847         return OK;
848     }
849 
850     /// @notice Decline transaction
851     /// Can be called only by registered user in GroupsAccessManager
852     ///
853     /// @param _key transaction id
854     ///
855     /// @return code
856     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
857         if (!isTxExist(_key)) {
858             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
859         }
860 
861         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
862             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
863         }
864 
865         Guard storage _guard = txKey2guard[_key];
866         if (_guard.state != GuardState.InProcess) {
867             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
868         }
869 
870         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
871             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
872         }
873 
874         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
875         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
876         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
877         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
878             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
879         }
880 
881         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
882         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
883         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
884         _guard.alreadyDeclined = _alreadyDeclinedCount;
885 
886 
887         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
888 
889         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
890             _guard.state = GuardState.Decline;
891             ProtectionTxCancelled(_key);
892         }
893 
894         return OK;
895     }
896 
897     /// @notice Revoke user votes for transaction
898     /// Can be called only by contract owner
899     ///
900     /// @param _key transaction id
901     /// @param _user target user address
902     ///
903     /// @return code
904     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
905         return _revoke(_key, _user);
906     }
907 
908     /// @notice Revoke vote for transaction
909     /// Can be called only by authorized user
910     /// @param _key transaction id
911     /// @return code
912     function revoke(bytes32 _key) external returns (uint) {
913         return _revoke(_key, msg.sender);
914     }
915 
916     /// @notice Check transaction status
917     /// @param _key transaction id
918     /// @return code
919     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
920         require(_key != bytes32(0));
921 
922         if (!isTxExist(_key)) {
923             return NO_RECORDS_WERE_FOUND;
924         }
925 
926         Guard storage _guard = txKey2guard[_key];
927         return _guard.state == GuardState.InProcess
928         ? PENDING_MANAGER_IN_PROCESS
929         : _guard.state == GuardState.Confirmed
930         ? OK
931         : PENDING_MANAGER_REJECTED;
932     }
933 
934 
935     /// @notice Check policy details
936     ///
937     /// @return _groupNames group names included in policies
938     /// @return _acceptLimits accept limit for group
939     /// @return _declineLimits decline limit for group
940     function getPolicyDetails(bytes4 _sig, address _contract)
941     public
942     view
943     returns (
944         bytes32[] _groupNames,
945         uint[] _acceptLimits,
946         uint[] _declineLimits,
947         uint _totalAcceptedLimit,
948         uint _totalDeclinedLimit
949     ) {
950         require(_sig != bytes4(0));
951         require(_contract != 0x0);
952         
953         bytes32 _policyHash = keccak256(_sig, _contract);
954         uint _policyIdx = policyId2Index[_policyHash];
955         if (_policyIdx == 0) {
956             return;
957         }
958 
959         Policy storage _policy = policyId2policy[_policyHash];
960         uint _policyGroupsCount = _policy.groupsCount;
961         _groupNames = new bytes32[](_policyGroupsCount);
962         _acceptLimits = new uint[](_policyGroupsCount);
963         _declineLimits = new uint[](_policyGroupsCount);
964 
965         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
966             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
967             _groupNames[_idx] = _requirements.groupName;
968             _acceptLimits[_idx] = _requirements.acceptLimit;
969             _declineLimits[_idx] = _requirements.declineLimit;
970         }
971 
972         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
973     }
974 
975     /// @notice Check policy include target group
976     /// @param _policyHash policy hash (sig, contract address)
977     /// @param _groupName group id
978     /// @return bool
979     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
980         Policy storage _policy = policyId2policy[_policyHash];
981         return _policy.groupName2index[_groupName] != 0;
982     }
983 
984     /// @notice Check is policy exist
985     /// @param _policyHash policy hash (sig, contract address)
986     /// @return bool
987     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
988         return policyId2Index[_policyHash] != 0;
989     }
990 
991     /// @notice Check is transaction exist
992     /// @param _key transaction id
993     /// @return bool
994     function isTxExist(bytes32 _key) public view returns (bool){
995         return txKey2index[_key] != 0;
996     }
997 
998     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
999         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1000             _guard.state = GuardState.Decline;
1001         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1002             _guard.state = GuardState.Confirmed;
1003         } else if (_guard.state != GuardState.InProcess) {
1004             _guard.state = GuardState.InProcess;
1005         }
1006     }
1007 
1008     function _revoke(bytes32 _key, address _user) private returns (uint) {
1009         require(_key != bytes32(0));
1010         require(_user != 0x0);
1011 
1012         if (!isTxExist(_key)) {
1013             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1014         }
1015 
1016         Guard storage _guard = txKey2guard[_key];
1017         if (_guard.state != GuardState.InProcess) {
1018             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1019         }
1020 
1021         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1022         if (_votedGroupName == bytes32(0)) {
1023             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1024         }
1025 
1026         bool isAcceptedVote = _guard.votes[_user].accepted;
1027         if (isAcceptedVote) {
1028             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1029             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1030         } else {
1031             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1032             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1033 
1034         }
1035 
1036         delete _guard.votes[_user];
1037 
1038         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1039         return OK;
1040     }
1041 }
1042 
1043 /// @title MultiSigAdapter
1044 ///
1045 /// Abstract implementation
1046 /// This contract serves as transaction signer
1047 contract MultiSigAdapter is Object {
1048 
1049     uint constant MULTISIG_ADDED = 3;
1050     uint constant NO_RECORDS_WERE_FOUND = 4;
1051 
1052     modifier isAuthorized {
1053         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1054             _;
1055         }
1056     }
1057 
1058     /// @notice Get pending address
1059     /// @dev abstract. Needs child implementation
1060     ///
1061     /// @return pending address
1062     function getPendingManager() public view returns (address);
1063 
1064     /// @notice Sign current transaction and add it to transaction pending queue
1065     ///
1066     /// @return code
1067     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1068         bytes32 _txHash = _getKey(_args, _block);
1069         address _manager = getPendingManager();
1070 
1071         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1072         if (_code != NO_RECORDS_WERE_FOUND) {
1073             return _code;
1074         }
1075 
1076         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1077             revert();
1078         }
1079 
1080         return MULTISIG_ADDED;
1081     }
1082 
1083     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1084         bytes32 _txHash = _getKey(_args, _block);
1085         address _manager = getPendingManager();
1086         return PendingManager(_manager).isTxExist(_txHash);
1087     }
1088 
1089     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1090         _block = _block != 0 ? _block : block.number;
1091         _txHash = keccak256(msg.sig, _args, _block);
1092     }
1093 }
1094 
1095 /// @title ServiceController
1096 ///
1097 /// Base implementation
1098 /// Serves for managing service instances
1099 contract ServiceController is MultiSigAdapter {
1100 
1101     event Error(uint _errorCode);
1102 
1103     uint constant SERVICE_CONTROLLER = 350000;
1104     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1105     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1106     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1107     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1108 
1109     address public profiterole;
1110     address public treasury;
1111     address public pendingManager;
1112     address public proxy;
1113 
1114     uint public sideServicesCount;
1115     mapping(uint => address) public index2sideService;
1116     mapping(address => uint) public sideService2index;
1117     mapping(address => bool) public sideServices;
1118 
1119     uint public emissionProvidersCount;
1120     mapping(uint => address) public index2emissionProvider;
1121     mapping(address => uint) public emissionProvider2index;
1122     mapping(address => bool) public emissionProviders;
1123 
1124     uint public burningMansCount;
1125     mapping(uint => address) public index2burningMan;
1126     mapping(address => uint) public burningMan2index;
1127     mapping(address => bool) public burningMans;
1128 
1129     /// @notice Default ServiceController's constructor
1130     ///
1131     /// @param _pendingManager pending manager address
1132     /// @param _proxy ERC20 proxy address
1133     /// @param _profiterole profiterole address
1134     /// @param _treasury treasury address
1135     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1136         require(_pendingManager != 0x0);
1137         require(_proxy != 0x0);
1138         require(_profiterole != 0x0);
1139         require(_treasury != 0x0);
1140         pendingManager = _pendingManager;
1141         proxy = _proxy;
1142         profiterole = _profiterole;
1143         treasury = _treasury;
1144     }
1145 
1146     /// @notice Return pending manager address
1147     ///
1148     /// @return code
1149     function getPendingManager() public view returns (address) {
1150         return pendingManager;
1151     }
1152 
1153     /// @notice Add emission provider
1154     ///
1155     /// @param _provider emission provider address
1156     ///
1157     /// @return code
1158     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1159         if (emissionProviders[_provider]) {
1160             return _emitError(SERVICE_CONTROLLER_EMISSION_EXIST);
1161         }
1162         _code = _multisig(keccak256(_provider), _block);
1163         if (OK != _code) {
1164             return _code;
1165         }
1166 
1167         emissionProviders[_provider] = true;
1168         uint _count = emissionProvidersCount + 1;
1169         index2emissionProvider[_count] = _provider;
1170         emissionProvider2index[_provider] = _count;
1171         emissionProvidersCount = _count;
1172 
1173         return OK;
1174     }
1175 
1176     /// @notice Remove emission provider
1177     ///
1178     /// @param _provider emission provider address
1179     ///
1180     /// @return code
1181     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1182         _code = _multisig(keccak256(_provider), _block);
1183         if (OK != _code) {
1184             return _code;
1185         }
1186 
1187         uint _idx = emissionProvider2index[_provider];
1188         uint _lastIdx = emissionProvidersCount;
1189         if (_idx != 0) {
1190             if (_idx != _lastIdx) {
1191                 address _lastEmissionProvider = index2emissionProvider[_lastIdx];
1192                 index2emissionProvider[_idx] = _lastEmissionProvider;
1193                 emissionProvider2index[_lastEmissionProvider] = _idx;
1194             }
1195 
1196             delete emissionProvider2index[_provider];
1197             delete index2emissionProvider[_lastIdx];
1198             delete emissionProviders[_provider];
1199             emissionProvidersCount = _lastIdx - 1;
1200         }
1201 
1202         return OK;
1203     }
1204 
1205     /// @notice Add burning man
1206     ///
1207     /// @param _burningMan burning man address
1208     ///
1209     /// @return code
1210     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1211         if (burningMans[_burningMan]) {
1212             return _emitError(SERVICE_CONTROLLER_BURNING_MAN_EXIST);
1213         }
1214 
1215         _code = _multisig(keccak256(_burningMan), _block);
1216         if (OK != _code) {
1217             return _code;
1218         }
1219 
1220         burningMans[_burningMan] = true;
1221         uint _count = burningMansCount + 1;
1222         index2burningMan[_count] = _burningMan;
1223         burningMan2index[_burningMan] = _count;
1224         burningMansCount = _count;
1225 
1226         return OK;
1227     }
1228 
1229     /// @notice Remove burning man
1230     ///
1231     /// @param _burningMan burning man address
1232     ///
1233     /// @return code
1234     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1235         _code = _multisig(keccak256(_burningMan), _block);
1236         if (OK != _code) {
1237             return _code;
1238         }
1239 
1240         uint _idx = burningMan2index[_burningMan];
1241         uint _lastIdx = burningMansCount;
1242         if (_idx != 0) {
1243             if (_idx != _lastIdx) {
1244                 address _lastBurningMan = index2burningMan[_lastIdx];
1245                 index2burningMan[_idx] = _lastBurningMan;
1246                 burningMan2index[_lastBurningMan] = _idx;
1247             }
1248             
1249             delete burningMan2index[_burningMan];
1250             delete index2burningMan[_lastIdx];
1251             delete burningMans[_burningMan];
1252             burningMansCount = _lastIdx - 1;
1253         }
1254 
1255         return OK;
1256     }
1257 
1258     /// @notice Update a profiterole address
1259     ///
1260     /// @param _profiterole profiterole address
1261     ///
1262     /// @return result code of an operation
1263     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1264         _code = _multisig(keccak256(_profiterole), _block);
1265         if (OK != _code) {
1266             return _code;
1267         }
1268 
1269         profiterole = _profiterole;
1270         return OK;
1271     }
1272 
1273     /// @notice Update a treasury address
1274     ///
1275     /// @param _treasury treasury address
1276     ///
1277     /// @return result code of an operation
1278     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1279         _code = _multisig(keccak256(_treasury), _block);
1280         if (OK != _code) {
1281             return _code;
1282         }
1283 
1284         treasury = _treasury;
1285         return OK;
1286     }
1287 
1288     /// @notice Update pending manager address
1289     ///
1290     /// @param _pendingManager pending manager address
1291     ///
1292     /// @return result code of an operation
1293     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1294         _code = _multisig(keccak256(_pendingManager), _block);
1295         if (OK != _code) {
1296             return _code;
1297         }
1298 
1299         pendingManager = _pendingManager;
1300         return OK;
1301     }
1302 
1303     function addSideService(address _service, uint _block) public returns (uint _code) {
1304         if (sideServices[_service]) {
1305             return SERVICE_CONTROLLER_SERVICE_EXIST;
1306         }
1307         _code = _multisig(keccak256(_service), _block);
1308         if (OK != _code) {
1309             return _code;
1310         }
1311 
1312         sideServices[_service] = true;
1313         uint _count = sideServicesCount + 1;
1314         index2sideService[_count] = _service;
1315         sideService2index[_service] = _count;
1316         sideServicesCount = _count;
1317 
1318         return OK;
1319     }
1320 
1321     function removeSideService(address _service, uint _block) public returns (uint _code) {
1322         _code = _multisig(keccak256(_service), _block);
1323         if (OK != _code) {
1324             return _code;
1325         }
1326 
1327         uint _idx = sideService2index[_service];
1328         uint _lastIdx = sideServicesCount;
1329         if (_idx != 0) {
1330             if (_idx != _lastIdx) {
1331                 address _lastSideService = index2sideService[_lastIdx];
1332                 index2sideService[_idx] = _lastSideService;
1333                 sideService2index[_lastSideService] = _idx;
1334             }
1335             
1336             delete sideService2index[_service];
1337             delete index2sideService[_lastIdx];
1338             delete sideServices[_service];
1339             sideServicesCount = _lastIdx - 1;
1340         }
1341 
1342         return OK;
1343     }
1344 
1345     function getEmissionProviders()
1346     public
1347     view
1348     returns (address[] _emissionProviders)
1349     {
1350         _emissionProviders = new address[](emissionProvidersCount);
1351         for (uint _idx = 0; _idx < _emissionProviders.length; ++_idx) {
1352             _emissionProviders[_idx] = index2emissionProvider[_idx + 1];
1353         }
1354     }
1355 
1356     function getBurningMans()
1357     public
1358     view
1359     returns (address[] _burningMans)
1360     {
1361         _burningMans = new address[](burningMansCount);
1362         for (uint _idx = 0; _idx < _burningMans.length; ++_idx) {
1363             _burningMans[_idx] = index2burningMan[_idx + 1];
1364         }
1365     }
1366 
1367     function getSideServices()
1368     public
1369     view
1370     returns (address[] _sideServices)
1371     {
1372         _sideServices = new address[](sideServicesCount);
1373         for (uint _idx = 0; _idx < _sideServices.length; ++_idx) {
1374             _sideServices[_idx] = index2sideService[_idx + 1];
1375         }
1376     }
1377 
1378     /// @notice Check target address is service
1379     ///
1380     /// @param _address target address
1381     ///
1382     /// @return `true` when an address is a service, `false` otherwise
1383     function isService(address _address) public view returns (bool check) {
1384         return _address == profiterole ||
1385             _address == treasury || 
1386             _address == proxy || 
1387             _address == pendingManager || 
1388             emissionProviders[_address] || 
1389             burningMans[_address] ||
1390             sideServices[_address];
1391     }
1392 
1393     function _emitError(uint _errorCode) internal returns (uint) {
1394         Error(_errorCode);
1395         return _errorCode;
1396     }
1397 }