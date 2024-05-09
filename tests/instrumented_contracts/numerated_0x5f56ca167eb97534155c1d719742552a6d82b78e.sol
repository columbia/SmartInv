1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Owned contract with safe ownership pass.
6  *
7  * Note: all the non constant functions return false instead of throwing in case if state change
8  * didn't happen yet.
9  */
10 contract Owned {
11     /**
12      * Contract owner address
13      */
14     address public contractOwner;
15 
16     /**
17      * Contract owner address
18      */
19     address public pendingContractOwner;
20 
21     function Owned() {
22         contractOwner = msg.sender;
23     }
24 
25     /**
26     * @dev Owner check modifier
27     */
28     modifier onlyContractOwner() {
29         if (contractOwner == msg.sender) {
30             _;
31         }
32     }
33 
34     /**
35      * @dev Destroy contract and scrub a data
36      * @notice Only owner can call it
37      */
38     function destroy() onlyContractOwner {
39         suicide(msg.sender);
40     }
41 
42     /**
43      * Prepares ownership pass.
44      *
45      * Can only be called by current owner.
46      *
47      * @param _to address of the next owner. 0x0 is not allowed.
48      *
49      * @return success.
50      */
51     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
52         if (_to  == 0x0) {
53             return false;
54         }
55 
56         pendingContractOwner = _to;
57         return true;
58     }
59 
60     /**
61      * Finalize ownership pass.
62      *
63      * Can only be called by pending owner.
64      *
65      * @return success.
66      */
67     function claimContractOwnership() returns(bool) {
68         if (pendingContractOwner != msg.sender) {
69             return false;
70         }
71 
72         contractOwner = pendingContractOwner;
73         delete pendingContractOwner;
74 
75         return true;
76     }
77 }
78 
79 /**
80 * @title SafeMath
81 * @dev Math operations with safety checks that throw on error
82 */
83 library SafeMath {
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a * b;
86         assert(a == 0 || c / a == b);
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // assert(b > 0); // Solidity automatically throws when dividing by 0
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         assert(c >= a);
105         return c;
106     }
107 }
108 
109 contract ERC20 {
110     event Transfer(address indexed from, address indexed to, uint256 value);
111     event Approval(address indexed from, address indexed spender, uint256 value);
112     string public symbol;
113 
114     function totalSupply() constant returns (uint256 supply);
115     function balanceOf(address _owner) constant returns (uint256 balance);
116     function transfer(address _to, uint256 _value) returns (bool success);
117     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
118     function approve(address _spender, uint256 _value) returns (bool success);
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
120 }
121 
122 
123 contract ATxProxy is ERC20 {
124     
125     bytes32 public smbl;
126     address public platform;
127 
128     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
129     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
130     function __approve(address _spender, uint _value, address _sender) public returns (bool);
131     function getLatestVersion() public returns (address);
132     function init(address _bmcPlatform, string _symbol, string _name) public;
133     function proposeUpgrade(address _newVersion) public;
134 }
135 
136 /// @title Provides possibility manage holders? country limits and limits for holders.
137 contract DataControllerInterface {
138 
139     /// @notice Checks user is holder.
140     /// @param _address - checking address.
141     /// @return `true` if _address is registered holder, `false` otherwise.
142     function isHolderAddress(address _address) public view returns (bool);
143 
144     function allowance(address _user) public view returns (uint);
145 
146     function changeAllowance(address _holder, uint _value) public returns (uint);
147 }
148 /// @title ServiceController
149 ///
150 /// Base implementation
151 /// Serves for managing service instances
152 contract ServiceControllerInterface {
153 
154     /// @notice Check target address is service
155     /// @param _address target address
156     /// @return `true` when an address is a service, `false` otherwise
157     function isService(address _address) public view returns (bool);
158 }
159 
160 
161 
162 contract ATxAssetInterface {
163 
164     DataControllerInterface public dataController;
165     ServiceControllerInterface public serviceController;
166 
167     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
168     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
169     function __approve(address _spender, uint _value, address _sender) public returns (bool);
170     function __process(bytes /*_data*/, address /*_sender*/) payable public {
171         revert();
172     }
173 }
174 
175 contract AssetProxy is ERC20 {
176     
177     bytes32 public smbl;
178     address public platform;
179 
180     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
181     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
182     function __approve(address _spender, uint _value, address _sender) public returns (bool);
183     function getLatestVersion() public returns (address);
184     function init(address _bmcPlatform, string _symbol, string _name) public;
185     function proposeUpgrade(address _newVersion) public;
186 }
187 
188 
189 contract BasicAsset is ATxAssetInterface {
190 
191     // Assigned asset proxy contract, immutable.
192     address public proxy;
193 
194     /**
195      * Only assigned proxy is allowed to call.
196      */
197     modifier onlyProxy() {
198         if (proxy == msg.sender) {
199             _;
200         }
201     }
202 
203     /**
204      * Sets asset proxy address.
205      *
206      * Can be set only once.
207      *
208      * @param _proxy asset proxy contract address.
209      *
210      * @return success.
211      * @dev function is final, and must not be overridden.
212      */
213     function init(address _proxy) public returns (bool) {
214         if (address(proxy) != 0x0) {
215             return false;
216         }
217         proxy = _proxy;
218         return true;
219     }
220 
221     /**
222      * Passes execution into virtual function.
223      *
224      * Can only be called by assigned asset proxy.
225      *
226      * @return success.
227      * @dev function is final, and must not be overridden.
228      */
229     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyProxy returns (bool) {
230         return _transferWithReference(_to, _value, _reference, _sender);
231     }
232 
233     /**
234      * Passes execution into virtual function.
235      *
236      * Can only be called by assigned asset proxy.
237      *
238      * @return success.
239      * @dev function is final, and must not be overridden.
240      */
241     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyProxy returns (bool) {
242         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
243     }
244 
245     /**
246      * Passes execution into virtual function.
247      *
248      * Can only be called by assigned asset proxy.
249      *
250      * @return success.
251      * @dev function is final, and must not be overridden.
252      */
253     function __approve(address _spender, uint _value, address _sender) public onlyProxy returns (bool) {
254         return _approve(_spender, _value, _sender);
255     }
256 
257     /**
258      * Calls back without modifications.
259      *
260      * @return success.
261      * @dev function is virtual, and meant to be overridden.
262      */
263     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns (bool) {
264         return AssetProxy(proxy).__transferWithReference(_to, _value, _reference, _sender);
265     }
266 
267     /**
268      * Calls back without modifications.
269      *
270      * @return success.
271      * @dev function is virtual, and meant to be overridden.
272      */
273     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns (bool) {
274         return AssetProxy(proxy).__transferFromWithReference(_from, _to, _value, _reference, _sender);
275     }
276 
277     /**
278      * Calls back without modifications.
279      *
280      * @return success.
281      * @dev function is virtual, and meant to be overridden.
282      */
283     function _approve(address _spender, uint _value, address _sender) internal returns (bool) {
284         return AssetProxy(proxy).__approve(_spender, _value, _sender);
285     }
286 }
287 
288 
289 /// @title ServiceAllowance.
290 ///
291 /// Provides a way to delegate operation allowance decision to a service contract
292 contract ServiceAllowance {
293     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
294 }
295 
296 contract ERC20Interface {
297     event Transfer(address indexed from, address indexed to, uint256 value);
298     event Approval(address indexed from, address indexed spender, uint256 value);
299     string public symbol;
300 
301     function totalSupply() constant returns (uint256 supply);
302     function balanceOf(address _owner) constant returns (uint256 balance);
303     function transfer(address _to, uint256 _value) returns (bool success);
304     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
305     function approve(address _spender, uint256 _value) returns (bool success);
306     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
307 }
308 
309 /**
310  * @title Generic owned destroyable contract
311  */
312 contract Object is Owned {
313     /**
314     *  Common result code. Means everything is fine.
315     */
316     uint constant OK = 1;
317     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
318 
319     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
320         for(uint i=0;i<tokens.length;i++) {
321             address token = tokens[i];
322             uint balance = ERC20Interface(token).balanceOf(this);
323             if(balance != 0)
324                 ERC20Interface(token).transfer(_to,balance);
325         }
326         return OK;
327     }
328 
329     function checkOnlyContractOwner() internal constant returns(uint) {
330         if (contractOwner == msg.sender) {
331             return OK;
332         }
333 
334         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
335     }
336 }
337 
338 contract GroupsAccessManagerEmitter {
339 
340     event UserCreated(address user);
341     event UserDeleted(address user);
342     event GroupCreated(bytes32 groupName);
343     event GroupActivated(bytes32 groupName);
344     event GroupDeactivated(bytes32 groupName);
345     event UserToGroupAdded(address user, bytes32 groupName);
346     event UserFromGroupRemoved(address user, bytes32 groupName);
347 }
348 
349 
350 /// @title Group Access Manager
351 ///
352 /// Base implementation
353 /// This contract serves as group manager
354 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
355 
356     uint constant USER_MANAGER_SCOPE = 111000;
357     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
358     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
359     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
360     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
361     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
362     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
363     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
364     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
365     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
366 
367     using SafeMath for uint;
368 
369     struct Member {
370         address addr;
371         uint groupsCount;
372         mapping(bytes32 => uint) groupName2index;
373         mapping(uint => uint) index2globalIndex;
374     }
375 
376     struct Group {
377         bytes32 name;
378         uint priority;
379         uint membersCount;
380         mapping(address => uint) memberAddress2index;
381         mapping(uint => uint) index2globalIndex;
382     }
383 
384     uint public membersCount;
385     mapping(uint => address) index2memberAddress;
386     mapping(address => uint) memberAddress2index;
387     mapping(address => Member) address2member;
388 
389     uint public groupsCount;
390     mapping(uint => bytes32) index2groupName;
391     mapping(bytes32 => uint) groupName2index;
392     mapping(bytes32 => Group) groupName2group;
393     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
394 
395     function() payable public {
396         revert();
397     }
398 
399     /// @notice Register user
400     /// Can be called only by contract owner
401     ///
402     /// @param _user user address
403     ///
404     /// @return code
405     function registerUser(address _user) external onlyContractOwner returns (uint) {
406         require(_user != 0x0);
407 
408         if (isRegisteredUser(_user)) {
409             return USER_MANAGER_MEMBER_ALREADY_EXIST;
410         }
411 
412         uint _membersCount = membersCount.add(1);
413         membersCount = _membersCount;
414         memberAddress2index[_user] = _membersCount;
415         index2memberAddress[_membersCount] = _user;
416         address2member[_user] = Member(_user, 0);
417 
418         UserCreated(_user);
419         return OK;
420     }
421 
422     /// @notice Discard user registration
423     /// Can be called only by contract owner
424     ///
425     /// @param _user user address
426     ///
427     /// @return code
428     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
429         require(_user != 0x0);
430 
431         uint _memberIndex = memberAddress2index[_user];
432         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
433             return USER_MANAGER_INVALID_INVOCATION;
434         }
435 
436         uint _membersCount = membersCount;
437         delete memberAddress2index[_user];
438         if (_memberIndex != _membersCount) {
439             address _lastUser = index2memberAddress[_membersCount];
440             index2memberAddress[_memberIndex] = _lastUser;
441             memberAddress2index[_lastUser] = _memberIndex;
442         }
443         delete address2member[_user];
444         delete index2memberAddress[_membersCount];
445         delete memberAddress2index[_user];
446         membersCount = _membersCount.sub(1);
447 
448         UserDeleted(_user);
449         return OK;
450     }
451 
452     /// @notice Create group
453     /// Can be called only by contract owner
454     ///
455     /// @param _groupName group name
456     /// @param _priority group priority
457     ///
458     /// @return code
459     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
460         require(_groupName != bytes32(0));
461 
462         if (isGroupExists(_groupName)) {
463             return USER_MANAGER_GROUP_ALREADY_EXIST;
464         }
465 
466         uint _groupsCount = groupsCount.add(1);
467         groupName2index[_groupName] = _groupsCount;
468         index2groupName[_groupsCount] = _groupName;
469         groupName2group[_groupName] = Group(_groupName, _priority, 0);
470         groupsCount = _groupsCount;
471 
472         GroupCreated(_groupName);
473         return OK;
474     }
475 
476     /// @notice Change group status
477     /// Can be called only by contract owner
478     ///
479     /// @param _groupName group name
480     /// @param _blocked block status
481     ///
482     /// @return code
483     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
484         require(isGroupExists(_groupName));
485         groupsBlocked[_groupName] = _blocked;
486         return OK;
487     }
488 
489     /// @notice Add users in group
490     /// Can be called only by contract owner
491     ///
492     /// @param _groupName group name
493     /// @param _users user array
494     ///
495     /// @return code
496     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
497         require(isGroupExists(_groupName));
498 
499         Group storage _group = groupName2group[_groupName];
500         uint _groupMembersCount = _group.membersCount;
501 
502         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
503             address _user = _users[_userIdx];
504             uint _memberIndex = memberAddress2index[_user];
505             require(_memberIndex != 0);
506 
507             if (_group.memberAddress2index[_user] != 0) {
508                 continue;
509             }
510 
511             _groupMembersCount = _groupMembersCount.add(1);
512             _group.memberAddress2index[_user] = _groupMembersCount;
513             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
514 
515             _addGroupToMember(_user, _groupName);
516 
517             UserToGroupAdded(_user, _groupName);
518         }
519         _group.membersCount = _groupMembersCount;
520 
521         return OK;
522     }
523 
524     /// @notice Remove users in group
525     /// Can be called only by contract owner
526     ///
527     /// @param _groupName group name
528     /// @param _users user array
529     ///
530     /// @return code
531     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
532         require(isGroupExists(_groupName));
533 
534         Group storage _group = groupName2group[_groupName];
535         uint _groupMembersCount = _group.membersCount;
536 
537         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
538             address _user = _users[_userIdx];
539             uint _memberIndex = memberAddress2index[_user];
540             uint _groupMemberIndex = _group.memberAddress2index[_user];
541 
542             if (_memberIndex == 0 || _groupMemberIndex == 0) {
543                 continue;
544             }
545 
546             if (_groupMemberIndex != _groupMembersCount) {
547                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
548                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
549                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
550                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
551             }
552             delete _group.memberAddress2index[_user];
553             delete _group.index2globalIndex[_groupMembersCount];
554             _groupMembersCount = _groupMembersCount.sub(1);
555 
556             _removeGroupFromMember(_user, _groupName);
557 
558             UserFromGroupRemoved(_user, _groupName);
559         }
560         _group.membersCount = _groupMembersCount;
561 
562         return OK;
563     }
564 
565     /// @notice Check is user registered
566     ///
567     /// @param _user user address
568     ///
569     /// @return status
570     function isRegisteredUser(address _user) public view returns (bool) {
571         return memberAddress2index[_user] != 0;
572     }
573 
574     /// @notice Check is user in group
575     ///
576     /// @param _groupName user array
577     /// @param _user user array
578     ///
579     /// @return status
580     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
581         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
582     }
583 
584     /// @notice Check is group exist
585     ///
586     /// @param _groupName group name
587     ///
588     /// @return status
589     function isGroupExists(bytes32 _groupName) public view returns (bool) {
590         return groupName2index[_groupName] != 0;
591     }
592 
593     /// @notice Get current group names
594     ///
595     /// @return group names
596     function getGroups() public view returns (bytes32[] _groups) {
597         uint _groupsCount = groupsCount;
598         _groups = new bytes32[](_groupsCount);
599         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
600             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
601         }
602     }
603 
604     // PRIVATE
605 
606     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
607         Member storage _member = address2member[_user];
608         uint _memberGroupsCount = _member.groupsCount;
609         uint _memberGroupIndex = _member.groupName2index[_groupName];
610         if (_memberGroupIndex != _memberGroupsCount) {
611             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
612             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
613             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
614             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
615         }
616         delete _member.groupName2index[_groupName];
617         delete _member.index2globalIndex[_memberGroupsCount];
618         _member.groupsCount = _memberGroupsCount.sub(1);
619     }
620 
621     function _addGroupToMember(address _user, bytes32 _groupName) private {
622         Member storage _member = address2member[_user];
623         uint _memberGroupsCount = _member.groupsCount.add(1);
624         _member.groupName2index[_groupName] = _memberGroupsCount;
625         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
626         _member.groupsCount = _memberGroupsCount;
627     }
628 }
629 
630 contract PendingManagerEmitter {
631 
632     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
633     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
634 
635     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
636     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
637     event ProtectionTxDone(bytes32 key);
638     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
639     event ProtectionTxCancelled(bytes32 key);
640     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
641     event TxDeleted(bytes32 key);
642 
643     event Error(uint errorCode);
644 
645     function _emitError(uint _errorCode) internal returns (uint) {
646         Error(_errorCode);
647         return _errorCode;
648     }
649 }
650 
651 contract PendingManagerInterface {
652 
653     function signIn(address _contract) external returns (uint);
654     function signOut(address _contract) external returns (uint);
655 
656     function addPolicyRule(
657         bytes4 _sig, 
658         address _contract, 
659         bytes32 _groupName, 
660         uint _acceptLimit, 
661         uint _declineLimit 
662         ) 
663         external returns (uint);
664         
665     function removePolicyRule(
666         bytes4 _sig, 
667         address _contract, 
668         bytes32 _groupName
669         ) 
670         external returns (uint);
671 
672     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
673     function deleteTx(bytes32 _key) external returns (uint);
674 
675     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
676     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
677     function revoke(bytes32 _key) external returns (uint);
678 
679     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
680     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
681         bytes32[] _groupNames,
682         uint[] _acceptLimits,
683         uint[] _declineLimits,
684         uint _totalAcceptedLimit,
685         uint _totalDeclinedLimit
686         );
687 }
688 
689 /// @title PendingManager
690 ///
691 /// Base implementation
692 /// This contract serves as pending manager for transaction status
693 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
694 
695     uint constant NO_RECORDS_WERE_FOUND = 4;
696     uint constant PENDING_MANAGER_SCOPE = 4000;
697     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
698     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
699     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
700     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
701     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
702     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
703     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
704     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
705     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
706     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
707     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
708 
709     using SafeMath for uint;
710 
711     enum GuardState {
712         Decline, Confirmed, InProcess
713     }
714 
715     struct Requirements {
716         bytes32 groupName;
717         uint acceptLimit;
718         uint declineLimit;
719     }
720 
721     struct Policy {
722         uint groupsCount;
723         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
724         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
725         
726         uint totalAcceptedLimit;
727         uint totalDeclinedLimit;
728 
729         uint securesCount;
730         mapping(uint => uint) index2txIndex;
731         mapping(uint => uint) txIndex2index;
732     }
733 
734     struct Vote {
735         bytes32 groupName;
736         bool accepted;
737     }
738 
739     struct Guard {
740         GuardState state;
741         uint basePolicyIndex;
742 
743         uint alreadyAccepted;
744         uint alreadyDeclined;
745         
746         mapping(address => Vote) votes; // member address => vote
747         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
748         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
749     }
750 
751     address public accessManager;
752 
753     mapping(address => bool) public authorized;
754 
755     uint public policiesCount;
756     mapping(uint => bytes32) index2PolicyId; // index => policy hash
757     mapping(bytes32 => uint) policyId2Index; // policy hash => index
758     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
759 
760     uint public txCount;
761     mapping(uint => bytes32) index2txKey;
762     mapping(bytes32 => uint) txKey2index; // tx key => index
763     mapping(bytes32 => Guard) txKey2guard;
764 
765     /// @dev Execution is allowed only by authorized contract
766     modifier onlyAuthorized {
767         if (authorized[msg.sender] || address(this) == msg.sender) {
768             _;
769         }
770     }
771 
772     /// @dev Pending Manager's constructor
773     ///
774     /// @param _accessManager access manager's address
775     function PendingManager(address _accessManager) public {
776         require(_accessManager != 0x0);
777         accessManager = _accessManager;
778     }
779 
780     function() payable public {
781         revert();
782     }
783 
784     /// @notice Update access manager address
785     ///
786     /// @param _accessManager access manager's address
787     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
788         require(_accessManager != 0x0);
789         accessManager = _accessManager;
790         return OK;
791     }
792 
793     /// @notice Sign in contract
794     ///
795     /// @param _contract contract's address
796     function signIn(address _contract) external onlyContractOwner returns (uint) {
797         require(_contract != 0x0);
798         authorized[_contract] = true;
799         return OK;
800     }
801 
802     /// @notice Sign out contract
803     ///
804     /// @param _contract contract's address
805     function signOut(address _contract) external onlyContractOwner returns (uint) {
806         require(_contract != 0x0);
807         delete authorized[_contract];
808         return OK;
809     }
810 
811     /// @notice Register new policy rule
812     /// Can be called only by contract owner
813     ///
814     /// @param _sig target method signature
815     /// @param _contract target contract address
816     /// @param _groupName group's name
817     /// @param _acceptLimit accepted vote limit
818     /// @param _declineLimit decline vote limit
819     ///
820     /// @return code
821     function addPolicyRule(
822         bytes4 _sig,
823         address _contract,
824         bytes32 _groupName,
825         uint _acceptLimit,
826         uint _declineLimit
827     )
828     onlyContractOwner
829     external
830     returns (uint)
831     {
832         require(_sig != 0x0);
833         require(_contract != 0x0);
834         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
835         require(_acceptLimit != 0);
836         require(_declineLimit != 0);
837 
838         bytes32 _policyHash = keccak256(_sig, _contract);
839         
840         if (policyId2Index[_policyHash] == 0) {
841             uint _policiesCount = policiesCount.add(1);
842             index2PolicyId[_policiesCount] = _policyHash;
843             policyId2Index[_policyHash] = _policiesCount;
844             policiesCount = _policiesCount;
845         }
846 
847         Policy storage _policy = policyId2policy[_policyHash];
848         uint _policyGroupsCount = _policy.groupsCount;
849 
850         if (_policy.groupName2index[_groupName] == 0) {
851             _policyGroupsCount += 1;
852             _policy.groupName2index[_groupName] = _policyGroupsCount;
853             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
854             _policy.groupsCount = _policyGroupsCount;
855         }
856 
857         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
858         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
859         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
860         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
861         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
862         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
863 
864         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
865         return OK;
866     }
867 
868     /// @notice Remove policy rule
869     /// Can be called only by contract owner
870     ///
871     /// @param _groupName group's name
872     ///
873     /// @return code
874     function removePolicyRule(
875         bytes4 _sig,
876         address _contract,
877         bytes32 _groupName
878     ) 
879     onlyContractOwner 
880     external 
881     returns (uint) 
882     {
883         require(_sig != bytes4(0));
884         require(_contract != 0x0);
885         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
886 
887         bytes32 _policyHash = keccak256(_sig, _contract);
888         Policy storage _policy = policyId2policy[_policyHash];
889         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
890 
891         if (_policyGroupNameIndex == 0) {
892             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
893         }
894 
895         uint _policyGroupsCount = _policy.groupsCount;
896         if (_policyGroupNameIndex != _policyGroupsCount) {
897             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
898             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
899             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
900         }
901 
902         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
903         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
904 
905         delete _policy.groupName2index[_groupName];
906         delete _policy.participatedGroups[_policyGroupsCount];
907         _policy.groupsCount = _policyGroupsCount.sub(1);
908 
909         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
910         return OK;
911     }
912 
913     /// @notice Add transaction
914     ///
915     /// @param _key transaction id
916     ///
917     /// @return code
918     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
919         require(_key != bytes32(0));
920         require(_sig != bytes4(0));
921         require(_contract != 0x0);
922 
923         bytes32 _policyHash = keccak256(_sig, _contract);
924         require(isPolicyExist(_policyHash));
925 
926         if (isTxExist(_key)) {
927             return _emitError(PENDING_DUPLICATE_TX);
928         }
929 
930         if (_policyHash == bytes32(0)) {
931             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
932         }
933 
934         uint _index = txCount.add(1);
935         txCount = _index;
936         index2txKey[_index] = _key;
937         txKey2index[_key] = _index;
938 
939         Guard storage _guard = txKey2guard[_key];
940         _guard.basePolicyIndex = policyId2Index[_policyHash];
941         _guard.state = GuardState.InProcess;
942 
943         Policy storage _policy = policyId2policy[_policyHash];
944         uint _counter = _policy.securesCount.add(1);
945         _policy.securesCount = _counter;
946         _policy.index2txIndex[_counter] = _index;
947         _policy.txIndex2index[_index] = _counter;
948 
949         ProtectionTxAdded(_key, _policyHash, block.number);
950         return OK;
951     }
952 
953     /// @notice Delete transaction
954     /// @param _key transaction id
955     /// @return code
956     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
957         require(_key != bytes32(0));
958 
959         if (!isTxExist(_key)) {
960             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
961         }
962 
963         uint _txsCount = txCount;
964         uint _txIndex = txKey2index[_key];
965         if (_txIndex != _txsCount) {
966             bytes32 _last = index2txKey[txCount];
967             index2txKey[_txIndex] = _last;
968             txKey2index[_last] = _txIndex;
969         }
970 
971         delete txKey2index[_key];
972         delete index2txKey[_txsCount];
973         txCount = _txsCount.sub(1);
974 
975         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
976         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
977         uint _counter = _policy.securesCount;
978         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
979         if (_policyTxIndex != _counter) {
980             uint _movedTxIndex = _policy.index2txIndex[_counter];
981             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
982             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
983         }
984 
985         delete _policy.index2txIndex[_counter];
986         delete _policy.txIndex2index[_txIndex];
987         _policy.securesCount = _counter.sub(1);
988 
989         TxDeleted(_key);
990         return OK;
991     }
992 
993     /// @notice Accept transaction
994     /// Can be called only by registered user in GroupsAccessManager
995     ///
996     /// @param _key transaction id
997     ///
998     /// @return code
999     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1000         if (!isTxExist(_key)) {
1001             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1002         }
1003 
1004         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1005             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1006         }
1007 
1008         Guard storage _guard = txKey2guard[_key];
1009         if (_guard.state != GuardState.InProcess) {
1010             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1011         }
1012 
1013         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
1014             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1015         }
1016 
1017         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1018         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1019         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
1020         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
1021             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1022         }
1023 
1024         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
1025         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
1026         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
1027         _guard.alreadyAccepted = _alreadyAcceptedCount;
1028 
1029         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
1030 
1031         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
1032             _guard.state = GuardState.Confirmed;
1033             ProtectionTxDone(_key);
1034         }
1035 
1036         return OK;
1037     }
1038 
1039     /// @notice Decline transaction
1040     /// Can be called only by registered user in GroupsAccessManager
1041     ///
1042     /// @param _key transaction id
1043     ///
1044     /// @return code
1045     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1046         if (!isTxExist(_key)) {
1047             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1048         }
1049 
1050         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1051             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1052         }
1053 
1054         Guard storage _guard = txKey2guard[_key];
1055         if (_guard.state != GuardState.InProcess) {
1056             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1057         }
1058 
1059         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
1060             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1061         }
1062 
1063         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1064         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1065         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
1066         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
1067             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1068         }
1069 
1070         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
1071         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
1072         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
1073         _guard.alreadyDeclined = _alreadyDeclinedCount;
1074 
1075 
1076         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
1077 
1078         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
1079             _guard.state = GuardState.Decline;
1080             ProtectionTxCancelled(_key);
1081         }
1082 
1083         return OK;
1084     }
1085 
1086     /// @notice Revoke user votes for transaction
1087     /// Can be called only by contract owner
1088     ///
1089     /// @param _key transaction id
1090     /// @param _user target user address
1091     ///
1092     /// @return code
1093     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
1094         return _revoke(_key, _user);
1095     }
1096 
1097     /// @notice Revoke vote for transaction
1098     /// Can be called only by authorized user
1099     /// @param _key transaction id
1100     /// @return code
1101     function revoke(bytes32 _key) external returns (uint) {
1102         return _revoke(_key, msg.sender);
1103     }
1104 
1105     /// @notice Check transaction status
1106     /// @param _key transaction id
1107     /// @return code
1108     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
1109         require(_key != bytes32(0));
1110 
1111         if (!isTxExist(_key)) {
1112             return NO_RECORDS_WERE_FOUND;
1113         }
1114 
1115         Guard storage _guard = txKey2guard[_key];
1116         return _guard.state == GuardState.InProcess
1117         ? PENDING_MANAGER_IN_PROCESS
1118         : _guard.state == GuardState.Confirmed
1119         ? OK
1120         : PENDING_MANAGER_REJECTED;
1121     }
1122 
1123 
1124     /// @notice Check policy details
1125     ///
1126     /// @return _groupNames group names included in policies
1127     /// @return _acceptLimits accept limit for group
1128     /// @return _declineLimits decline limit for group
1129     function getPolicyDetails(bytes4 _sig, address _contract)
1130     public
1131     view
1132     returns (
1133         bytes32[] _groupNames,
1134         uint[] _acceptLimits,
1135         uint[] _declineLimits,
1136         uint _totalAcceptedLimit,
1137         uint _totalDeclinedLimit
1138     ) {
1139         require(_sig != bytes4(0));
1140         require(_contract != 0x0);
1141         
1142         bytes32 _policyHash = keccak256(_sig, _contract);
1143         uint _policyIdx = policyId2Index[_policyHash];
1144         if (_policyIdx == 0) {
1145             return;
1146         }
1147 
1148         Policy storage _policy = policyId2policy[_policyHash];
1149         uint _policyGroupsCount = _policy.groupsCount;
1150         _groupNames = new bytes32[](_policyGroupsCount);
1151         _acceptLimits = new uint[](_policyGroupsCount);
1152         _declineLimits = new uint[](_policyGroupsCount);
1153 
1154         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1155             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1156             _groupNames[_idx] = _requirements.groupName;
1157             _acceptLimits[_idx] = _requirements.acceptLimit;
1158             _declineLimits[_idx] = _requirements.declineLimit;
1159         }
1160 
1161         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1162     }
1163 
1164     /// @notice Check policy include target group
1165     /// @param _policyHash policy hash (sig, contract address)
1166     /// @param _groupName group id
1167     /// @return bool
1168     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1169         Policy storage _policy = policyId2policy[_policyHash];
1170         return _policy.groupName2index[_groupName] != 0;
1171     }
1172 
1173     /// @notice Check is policy exist
1174     /// @param _policyHash policy hash (sig, contract address)
1175     /// @return bool
1176     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1177         return policyId2Index[_policyHash] != 0;
1178     }
1179 
1180     /// @notice Check is transaction exist
1181     /// @param _key transaction id
1182     /// @return bool
1183     function isTxExist(bytes32 _key) public view returns (bool){
1184         return txKey2index[_key] != 0;
1185     }
1186 
1187     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1188         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1189             _guard.state = GuardState.Decline;
1190         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1191             _guard.state = GuardState.Confirmed;
1192         } else if (_guard.state != GuardState.InProcess) {
1193             _guard.state = GuardState.InProcess;
1194         }
1195     }
1196 
1197     function _revoke(bytes32 _key, address _user) private returns (uint) {
1198         require(_key != bytes32(0));
1199         require(_user != 0x0);
1200 
1201         if (!isTxExist(_key)) {
1202             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1203         }
1204 
1205         Guard storage _guard = txKey2guard[_key];
1206         if (_guard.state != GuardState.InProcess) {
1207             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1208         }
1209 
1210         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1211         if (_votedGroupName == bytes32(0)) {
1212             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1213         }
1214 
1215         bool isAcceptedVote = _guard.votes[_user].accepted;
1216         if (isAcceptedVote) {
1217             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1218             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1219         } else {
1220             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1221             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1222 
1223         }
1224 
1225         delete _guard.votes[_user];
1226 
1227         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1228         return OK;
1229     }
1230 }
1231 
1232 
1233 
1234 /// @title MultiSigAdapter
1235 ///
1236 /// Abstract implementation
1237 /// This contract serves as transaction signer
1238 contract MultiSigAdapter is Object {
1239 
1240     uint constant MULTISIG_ADDED = 3;
1241     uint constant NO_RECORDS_WERE_FOUND = 4;
1242 
1243     modifier isAuthorized {
1244         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1245             _;
1246         }
1247     }
1248 
1249     /// @notice Get pending address
1250     /// @dev abstract. Needs child implementation
1251     ///
1252     /// @return pending address
1253     function getPendingManager() public view returns (address);
1254 
1255     /// @notice Sign current transaction and add it to transaction pending queue
1256     ///
1257     /// @return code
1258     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1259         bytes32 _txHash = _getKey(_args, _block);
1260         address _manager = getPendingManager();
1261 
1262         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1263         if (_code != NO_RECORDS_WERE_FOUND) {
1264             return _code;
1265         }
1266 
1267         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1268             revert();
1269         }
1270 
1271         return MULTISIG_ADDED;
1272     }
1273 
1274     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1275         bytes32 _txHash = _getKey(_args, _block);
1276         address _manager = getPendingManager();
1277         return PendingManager(_manager).isTxExist(_txHash);
1278     }
1279 
1280     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1281         _block = _block != 0 ? _block : block.number;
1282         _txHash = keccak256(msg.sig, _args, _block);
1283     }
1284 }
1285 
1286 
1287 
1288 /// @title ServiceController
1289 ///
1290 /// Base implementation
1291 /// Serves for managing service instances
1292 contract ServiceController is MultiSigAdapter {
1293 
1294     uint constant SERVICE_CONTROLLER = 350000;
1295     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1296     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1297     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1298     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1299 
1300     address public profiterole;
1301     address public treasury;
1302     address public pendingManager;
1303     address public proxy;
1304 
1305     mapping(address => bool) public sideServices;
1306     mapping(address => bool) emissionProviders;
1307     mapping(address => bool) burningMans;
1308 
1309     /// @notice Default ServiceController's constructor
1310     ///
1311     /// @param _pendingManager pending manager address
1312     /// @param _proxy ERC20 proxy address
1313     /// @param _profiterole profiterole address
1314     /// @param _treasury treasury address
1315     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1316         require(_pendingManager != 0x0);
1317         require(_proxy != 0x0);
1318         require(_profiterole != 0x0);
1319         require(_treasury != 0x0);
1320         pendingManager = _pendingManager;
1321         proxy = _proxy;
1322         profiterole = _profiterole;
1323         treasury = _treasury;
1324     }
1325 
1326     /// @notice Return pending manager address
1327     ///
1328     /// @return code
1329     function getPendingManager() public view returns (address) {
1330         return pendingManager;
1331     }
1332 
1333     /// @notice Add emission provider
1334     ///
1335     /// @param _provider emission provider address
1336     ///
1337     /// @return code
1338     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1339         if (emissionProviders[_provider]) {
1340             return SERVICE_CONTROLLER_EMISSION_EXIST;
1341         }
1342         _code = _multisig(keccak256(_provider), _block);
1343         if (OK != _code) {
1344             return _code;
1345         }
1346 
1347         emissionProviders[_provider] = true;
1348         return OK;
1349     }
1350 
1351     /// @notice Remove emission provider
1352     ///
1353     /// @param _provider emission provider address
1354     ///
1355     /// @return code
1356     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1357         _code = _multisig(keccak256(_provider), _block);
1358         if (OK != _code) {
1359             return _code;
1360         }
1361 
1362         delete emissionProviders[_provider];
1363         return OK;
1364     }
1365 
1366     /// @notice Add burning man
1367     ///
1368     /// @param _burningMan burning man address
1369     ///
1370     /// @return code
1371     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1372         if (burningMans[_burningMan]) {
1373             return SERVICE_CONTROLLER_BURNING_MAN_EXIST;
1374         }
1375 
1376         _code = _multisig(keccak256(_burningMan), _block);
1377         if (OK != _code) {
1378             return _code;
1379         }
1380 
1381         burningMans[_burningMan] = true;
1382         return OK;
1383     }
1384 
1385     /// @notice Remove burning man
1386     ///
1387     /// @param _burningMan burning man address
1388     ///
1389     /// @return code
1390     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1391         _code = _multisig(keccak256(_burningMan), _block);
1392         if (OK != _code) {
1393             return _code;
1394         }
1395 
1396         delete burningMans[_burningMan];
1397         return OK;
1398     }
1399 
1400     /// @notice Update a profiterole address
1401     ///
1402     /// @param _profiterole profiterole address
1403     ///
1404     /// @return result code of an operation
1405     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1406         _code = _multisig(keccak256(_profiterole), _block);
1407         if (OK != _code) {
1408             return _code;
1409         }
1410 
1411         profiterole = _profiterole;
1412         return OK;
1413     }
1414 
1415     /// @notice Update a treasury address
1416     ///
1417     /// @param _treasury treasury address
1418     ///
1419     /// @return result code of an operation
1420     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1421         _code = _multisig(keccak256(_treasury), _block);
1422         if (OK != _code) {
1423             return _code;
1424         }
1425 
1426         treasury = _treasury;
1427         return OK;
1428     }
1429 
1430     /// @notice Update pending manager address
1431     ///
1432     /// @param _pendingManager pending manager address
1433     ///
1434     /// @return result code of an operation
1435     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1436         _code = _multisig(keccak256(_pendingManager), _block);
1437         if (OK != _code) {
1438             return _code;
1439         }
1440 
1441         pendingManager = _pendingManager;
1442         return OK;
1443     }
1444 
1445     function addSideService(address _service, uint _block) public returns (uint _code) {
1446         if (sideServices[_service]) {
1447             return SERVICE_CONTROLLER_SERVICE_EXIST;
1448         }
1449         _code = _multisig(keccak256(_service), _block);
1450         if (OK != _code) {
1451             return _code;
1452         }
1453 
1454         sideServices[_service] = true;
1455         return OK;
1456     }
1457 
1458     function removeSideService(address _service, uint _block) public returns (uint _code) {
1459         _code = _multisig(keccak256(_service), _block);
1460         if (OK != _code) {
1461             return _code;
1462         }
1463 
1464         delete sideServices[_service];
1465         return OK;
1466     }
1467 
1468     /// @notice Check target address is service
1469     ///
1470     /// @param _address target address
1471     ///
1472     /// @return `true` when an address is a service, `false` otherwise
1473     function isService(address _address) public view returns (bool check) {
1474         return _address == profiterole ||
1475             _address == treasury || 
1476             _address == proxy || 
1477             _address == pendingManager || 
1478             emissionProviders[_address] || 
1479             burningMans[_address] ||
1480             sideServices[_address];
1481     }
1482 }
1483 
1484 contract OracleMethodAdapter is Object {
1485 
1486     event OracleAdded(bytes4 _sig, address _oracle);
1487     event OracleRemoved(bytes4 _sig, address _oracle);
1488 
1489     mapping(bytes4 => mapping(address => bool)) public oracles;
1490 
1491     /// @dev Allow access only for oracle
1492     modifier onlyOracle {
1493         if (oracles[msg.sig][msg.sender]) {
1494             _;
1495         }
1496     }
1497 
1498     modifier onlyOracleOrOwner {
1499         if (oracles[msg.sig][msg.sender] || msg.sender == contractOwner) {
1500             _;
1501         }
1502     }
1503 
1504     function addOracles(bytes4[] _signatures, address[] _oracles) onlyContractOwner external returns (uint) {
1505         require(_signatures.length == _oracles.length);
1506         bytes4 _sig;
1507         address _oracle;
1508         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
1509             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
1510             if (!oracles[_sig][_oracle]) {
1511                 oracles[_sig][_oracle] = true;
1512                 _emitOracleAdded(_sig, _oracle);
1513             }
1514         }
1515         return OK;
1516     }
1517 
1518     function removeOracles(bytes4[] _signatures, address[] _oracles) onlyContractOwner external returns (uint) {
1519         require(_signatures.length == _oracles.length);
1520         bytes4 _sig;
1521         address _oracle;
1522         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
1523             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
1524             if (oracles[_sig][_oracle]) {
1525                 delete oracles[_sig][_oracle];
1526                 _emitOracleRemoved(_sig, _oracle);
1527             }
1528         }
1529         return OK;
1530     }
1531 
1532     function _emitOracleAdded(bytes4 _sig, address _oracle) internal {
1533         OracleAdded(_sig, _oracle);
1534     }
1535 
1536     function _emitOracleRemoved(bytes4 _sig, address _oracle) internal {
1537         OracleRemoved(_sig, _oracle);
1538     }
1539 
1540 }
1541 
1542 contract Platform {
1543     mapping(bytes32 => address) public proxies;
1544     function name(bytes32 _symbol) public view returns (string);
1545     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
1546     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
1547     function totalSupply(bytes32 _symbol) public view returns (uint);
1548     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
1549     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
1550     function baseUnit(bytes32 _symbol) public view returns (uint8);
1551     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
1552     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
1553     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
1554     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
1555     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
1556     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
1557     function isReissuable(bytes32 _symbol) public view returns (bool);
1558     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
1559 }
1560 
1561 
1562 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
1563 
1564     // Timespan for users to review the new implementation and make decision.
1565     uint constant UPGRADE_FREEZE_TIME = 3 days;
1566 
1567     using SafeMath for uint;
1568 
1569     /**
1570      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
1571      */
1572     event UpgradeProposal(address newVersion);
1573 
1574     // Current asset implementation contract address.
1575     address latestVersion;
1576 
1577     // Proposed next asset implementation contract address.
1578     address pendingVersion;
1579 
1580     // Upgrade freeze-time start.
1581     uint pendingVersionTimestamp;
1582 
1583     // Assigned platform, immutable.
1584     Platform public platform;
1585 
1586     // Assigned symbol, immutable.
1587     bytes32 public smbl;
1588 
1589     // Assigned name, immutable.
1590     string public name;
1591 
1592     /**
1593      * Only platform is allowed to call.
1594      */
1595     modifier onlyPlatform() {
1596         if (msg.sender == address(platform)) {
1597             _;
1598         }
1599     }
1600 
1601     /**
1602      * Only current asset owner is allowed to call.
1603      */
1604     modifier onlyAssetOwner() {
1605         if (platform.isOwner(msg.sender, smbl)) {
1606             _;
1607         }
1608     }
1609 
1610     /**
1611      * Only asset implementation contract assigned to sender is allowed to call.
1612      */
1613     modifier onlyAccess(address _sender) {
1614         if (getLatestVersion() == msg.sender) {
1615             _;
1616         }
1617     }
1618 
1619     /**
1620      * Resolves asset implementation contract for the caller and forwards there transaction data,
1621      * along with the value. This allows for proxy interface growth.
1622      */
1623     function() public payable {
1624         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
1625     }
1626 
1627     /**
1628      * Sets platform address, assigns symbol and name.
1629      *
1630      * Can be set only once.
1631      *
1632      * @param _platform platform contract address.
1633      * @param _symbol assigned symbol.
1634      * @param _name assigned name.
1635      *
1636      * @return success.
1637      */
1638     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
1639         if (address(platform) != 0x0) {
1640             return false;
1641         }
1642         platform = _platform;
1643         symbol = _symbol;
1644         smbl = stringToBytes32(_symbol);
1645         name = _name;
1646         return true;
1647     }
1648 
1649     /**
1650      * Returns asset total supply.
1651      *
1652      * @return asset total supply.
1653      */
1654     function totalSupply() public view returns (uint) {
1655         return platform.totalSupply(smbl);
1656     }
1657 
1658     /**
1659      * Returns asset balance for a particular holder.
1660      *
1661      * @param _owner holder address.
1662      *
1663      * @return holder balance.
1664      */
1665     function balanceOf(address _owner) public view returns (uint) {
1666         return platform.balanceOf(_owner, smbl);
1667     }
1668 
1669     /**
1670      * Returns asset allowance from one holder to another.
1671      *
1672      * @param _from holder that allowed spending.
1673      * @param _spender holder that is allowed to spend.
1674      *
1675      * @return holder to spender allowance.
1676      */
1677     function allowance(address _from, address _spender) public view returns (uint) {
1678         return platform.allowance(_from, _spender, smbl);
1679     }
1680 
1681     /**
1682      * Returns asset decimals.
1683      *
1684      * @return asset decimals.
1685      */
1686     function decimals() public view returns (uint8) {
1687         return platform.baseUnit(smbl);
1688     }
1689 
1690     /**
1691      * Transfers asset balance from the caller to specified receiver.
1692      *
1693      * @param _to holder address to give to.
1694      * @param _value amount to transfer.
1695      *
1696      * @return success.
1697      */
1698     function transfer(address _to, uint _value) public returns (bool) {
1699         if (_to != 0x0) {
1700             return _transferWithReference(_to, _value, "");
1701         }
1702         else {
1703             return false;
1704         }
1705     }
1706 
1707     /**
1708      * Transfers asset balance from the caller to specified receiver adding specified comment.
1709      *
1710      * @param _to holder address to give to.
1711      * @param _value amount to transfer.
1712      * @param _reference transfer comment to be included in a platform's Transfer event.
1713      *
1714      * @return success.
1715      */
1716     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
1717         if (_to != 0x0) {
1718             return _transferWithReference(_to, _value, _reference);
1719         }
1720         else {
1721             return false;
1722         }
1723     }
1724 
1725     /**
1726      * Performs transfer call on the platform by the name of specified sender.
1727      *
1728      * Can only be called by asset implementation contract assigned to sender.
1729      *
1730      * @param _to holder address to give to.
1731      * @param _value amount to transfer.
1732      * @param _reference transfer comment to be included in a platform's Transfer event.
1733      * @param _sender initial caller.
1734      *
1735      * @return success.
1736      */
1737     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
1738         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
1739     }
1740 
1741     /**
1742      * Prforms allowance transfer of asset balance between holders.
1743      *
1744      * @param _from holder address to take from.
1745      * @param _to holder address to give to.
1746      * @param _value amount to transfer.
1747      *
1748      * @return success.
1749      */
1750     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
1751         if (_to != 0x0) {
1752             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
1753         }
1754         else {
1755             return false;
1756         }
1757     }
1758 
1759     /**
1760      * Performs allowance transfer call on the platform by the name of specified sender.
1761      *
1762      * Can only be called by asset implementation contract assigned to sender.
1763      *
1764      * @param _from holder address to take from.
1765      * @param _to holder address to give to.
1766      * @param _value amount to transfer.
1767      * @param _reference transfer comment to be included in a platform's Transfer event.
1768      * @param _sender initial caller.
1769      *
1770      * @return success.
1771      */
1772     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
1773         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
1774     }
1775 
1776     /**
1777      * Sets asset spending allowance for a specified spender.
1778      *
1779      * @param _spender holder address to set allowance to.
1780      * @param _value amount to allow.
1781      *
1782      * @return success.
1783      */
1784     function approve(address _spender, uint _value) public returns (bool) {
1785         if (_spender != 0x0) {
1786             return _getAsset().__approve(_spender, _value, msg.sender);
1787         }
1788         else {
1789             return false;
1790         }
1791     }
1792 
1793     /**
1794      * Performs allowance setting call on the platform by the name of specified sender.
1795      *
1796      * Can only be called by asset implementation contract assigned to sender.
1797      *
1798      * @param _spender holder address to set allowance to.
1799      * @param _value amount to allow.
1800      * @param _sender initial caller.
1801      *
1802      * @return success.
1803      */
1804     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
1805         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
1806     }
1807 
1808     /**
1809      * Emits ERC20 Transfer event on this contract.
1810      *
1811      * Can only be, and, called by assigned platform when asset transfer happens.
1812      */
1813     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
1814         Transfer(_from, _to, _value);
1815     }
1816 
1817     /**
1818      * Emits ERC20 Approval event on this contract.
1819      *
1820      * Can only be, and, called by assigned platform when asset allowance set happens.
1821      */
1822     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
1823         Approval(_from, _spender, _value);
1824     }
1825 
1826     /**
1827      * Returns current asset implementation contract address.
1828      *
1829      * @return asset implementation contract address.
1830      */
1831     function getLatestVersion() public view returns (address) {
1832         return latestVersion;
1833     }
1834 
1835     /**
1836      * Returns proposed next asset implementation contract address.
1837      *
1838      * @return asset implementation contract address.
1839      */
1840     function getPendingVersion() public view returns (address) {
1841         return pendingVersion;
1842     }
1843 
1844     /**
1845      * Returns upgrade freeze-time start.
1846      *
1847      * @return freeze-time start.
1848      */
1849     function getPendingVersionTimestamp() public view returns (uint) {
1850         return pendingVersionTimestamp;
1851     }
1852 
1853     /**
1854      * Propose next asset implementation contract address.
1855      *
1856      * Can only be called by current asset owner.
1857      *
1858      * Note: freeze-time should not be applied for the initial setup.
1859      *
1860      * @param _newVersion asset implementation contract address.
1861      *
1862      * @return success.
1863      */
1864     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
1865         // Should not already be in the upgrading process.
1866         if (pendingVersion != 0x0) {
1867             return false;
1868         }
1869         // New version address should be other than 0x0.
1870         if (_newVersion == 0x0) {
1871             return false;
1872         }
1873         // Don't apply freeze-time for the initial setup.
1874         if (latestVersion == 0x0) {
1875             latestVersion = _newVersion;
1876             return true;
1877         }
1878         pendingVersion = _newVersion;
1879         pendingVersionTimestamp = now;
1880         UpgradeProposal(_newVersion);
1881         return true;
1882     }
1883 
1884     /**
1885      * Cancel the pending upgrade process.
1886      *
1887      * Can only be called by current asset owner.
1888      *
1889      * @return success.
1890      */
1891     function purgeUpgrade() public onlyAssetOwner returns (bool) {
1892         if (pendingVersion == 0x0) {
1893             return false;
1894         }
1895         delete pendingVersion;
1896         delete pendingVersionTimestamp;
1897         return true;
1898     }
1899 
1900     /**
1901      * Finalize an upgrade process setting new asset implementation contract address.
1902      *
1903      * Can only be called after an upgrade freeze-time.
1904      *
1905      * @return success.
1906      */
1907     function commitUpgrade() public returns (bool) {
1908         if (pendingVersion == 0x0) {
1909             return false;
1910         }
1911         if (pendingVersionTimestamp.add(UPGRADE_FREEZE_TIME) > now) {
1912             return false;
1913         }
1914         latestVersion = pendingVersion;
1915         delete pendingVersion;
1916         delete pendingVersionTimestamp;
1917         return true;
1918     }
1919 
1920     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
1921         return true;
1922     }
1923 
1924     /**
1925      * Returns asset implementation contract for current caller.
1926      *
1927      * @return asset implementation contract.
1928      */
1929     function _getAsset() internal view returns (ATxAssetInterface) {
1930         return ATxAssetInterface(getLatestVersion());
1931     }
1932 
1933     /**
1934      * Resolves asset implementation contract for the caller and forwards there arguments along with
1935      * the caller address.
1936      *
1937      * @return success.
1938      */
1939     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
1940         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
1941     }
1942 
1943     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
1944         assembly {
1945             result := mload(add(source, 32))
1946         }
1947     }
1948 }
1949 
1950 contract DataControllerEmitter {
1951 
1952     event CountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount);
1953     event CountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount);
1954 
1955     event HolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode);
1956     event HolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
1957     event HolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
1958     event HolderOperationalChanged(bytes32 _externalHolderId, bool _operational);
1959 
1960     event DayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
1961     event MonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
1962 
1963     event Error(uint _errorCode);
1964 
1965     function _emitHolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
1966         HolderAddressAdded(_externalHolderId, _holderPrototype, _accessIndex);
1967     }
1968 
1969     function _emitHolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
1970         HolderAddressRemoved(_externalHolderId, _holderPrototype, _accessIndex);
1971     }
1972 
1973     function _emitHolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode) internal {
1974         HolderRegistered(_externalHolderId, _accessIndex, _countryCode);
1975     }
1976 
1977     function _emitHolderOperationalChanged(bytes32 _externalHolderId, bool _operational) internal {
1978         HolderOperationalChanged(_externalHolderId, _operational);
1979     }
1980 
1981     function _emitCountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
1982         CountryCodeAdded(_countryCode, _countryId, _maxHolderCount);
1983     }
1984 
1985     function _emitCountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
1986         CountryCodeChanged(_countryCode, _countryId, _maxHolderCount);
1987     }
1988 
1989     function _emitDayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
1990         DayLimitChanged(_externalHolderId, _from, _to);
1991     }
1992 
1993     function _emitMonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
1994         MonthLimitChanged(_externalHolderId, _from, _to);
1995     }
1996 
1997     function _emitError(uint _errorCode) internal returns (uint) {
1998         Error(_errorCode);
1999         return _errorCode;
2000     }
2001 }
2002 
2003 
2004 /// @title Provides possibility manage holders? country limits and limits for holders.
2005 contract DataController is OracleMethodAdapter, DataControllerEmitter {
2006 
2007     /* CONSTANTS */
2008 
2009     uint constant DATA_CONTROLLER = 109000;
2010     uint constant DATA_CONTROLLER_ERROR = DATA_CONTROLLER + 1;
2011     uint constant DATA_CONTROLLER_CURRENT_WRONG_LIMIT = DATA_CONTROLLER + 2;
2012     uint constant DATA_CONTROLLER_WRONG_ALLOWANCE = DATA_CONTROLLER + 3;
2013     uint constant DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS = DATA_CONTROLLER + 4;
2014 
2015     uint constant MAX_TOKEN_HOLDER_NUMBER = 2 ** 256 - 1;
2016 
2017     using SafeMath for uint;
2018 
2019     /* STRUCTS */
2020 
2021     /// @title HoldersData couldn't be public because of internal structures, so needed to provide getters for different parts of _holderData
2022     struct HoldersData {
2023         uint countryCode;
2024         uint sendLimPerDay;
2025         uint sendLimPerMonth;
2026         bool operational;
2027         bytes text;
2028         uint holderAddressCount;
2029         mapping(uint => address) index2Address;
2030         mapping(address => uint) address2Index;
2031     }
2032 
2033     struct CountryLimits {
2034         uint countryCode;
2035         uint maxTokenHolderNumber;
2036         uint currentTokenHolderNumber;
2037     }
2038 
2039     /* FIELDS */
2040 
2041     address public withdrawal;
2042     address assetAddress;
2043     address public serviceController;
2044 
2045     mapping(address => uint) public allowance;
2046 
2047     // Iterable mapping pattern is used for holders.
2048     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
2049     uint public holdersCount;
2050     mapping(uint => HoldersData) holders;
2051     mapping(address => bytes32) holderAddress2Id;
2052     mapping(bytes32 => uint) public holderIndex;
2053 
2054     // This is an access address mapping. Many addresses may have access to a single holder.
2055     uint public countriesCount;
2056     mapping(uint => CountryLimits) countryLimitsList;
2057     mapping(uint => uint) countryIndex;
2058 
2059     /* MODIFIERS */
2060 
2061     modifier onlyWithdrawal {
2062         if (msg.sender != withdrawal) {
2063             revert();
2064         }
2065         _;
2066     }
2067 
2068     modifier onlyAsset {
2069         if (msg.sender == assetAddress) {
2070             _;
2071         }
2072     }
2073 
2074     modifier onlyContractOwner {
2075         if (msg.sender == contractOwner) {
2076             _;
2077         }
2078     }
2079 
2080     /// @notice Constructor for _holderData controller.
2081     /// @param _serviceController service controller
2082     function DataController(address _serviceController, address _asset) public {
2083         require(_serviceController != 0x0);
2084         require(_asset != 0x0);
2085 
2086         serviceController = _serviceController;
2087         assetAddress = _asset;
2088     }
2089 
2090     function() payable public {
2091         revert();
2092     }
2093 
2094     function setWithdraw(address _withdrawal) onlyContractOwner external returns (uint) {
2095         require(_withdrawal != 0x0);
2096         withdrawal = _withdrawal;
2097         return OK;
2098     }
2099 
2100 
2101     function getPendingManager() public view returns (address) {
2102         return ServiceController(serviceController).getPendingManager();
2103     }
2104 
2105     function getHolderInfo(bytes32 _externalHolderId) public view returns (
2106         uint _countryCode,
2107         uint _limPerDay,
2108         uint _limPerMonth,
2109         bool _operational,
2110         bytes _text
2111     ) {
2112         HoldersData storage _data = holders[holderIndex[_externalHolderId]];
2113         return (_data.countryCode, _data.sendLimPerDay, _data.sendLimPerMonth, _data.operational, _data.text);
2114     }
2115 
2116     function getHolderAddresses(bytes32 _externalHolderId) public view returns (address[] _addresses) {
2117         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2118         uint _addressesCount = _holderData.holderAddressCount;
2119         _addresses = new address[](_addressesCount);
2120         for (uint _holderAddressIdx = 0; _holderAddressIdx < _addressesCount; ++_holderAddressIdx) {
2121             _addresses[_holderAddressIdx] = _holderData.index2Address[_holderAddressIdx + 1];
2122         }
2123     }
2124 
2125     function getHolderCountryCode(bytes32 _externalHolderId) public view returns (uint) {
2126         return holders[holderIndex[_externalHolderId]].countryCode;
2127     }
2128 
2129     function getHolderExternalIdByAddress(address _address) public view returns (bytes32) {
2130         return holderAddress2Id[_address];
2131     }
2132 
2133     /// @notice Checks user is holder.
2134     /// @param _address checking address.
2135     /// @return `true` if _address is registered holder, `false` otherwise.
2136     function isRegisteredAddress(address _address) public view returns (bool) {
2137         return holderIndex[holderAddress2Id[_address]] != 0;
2138     }
2139 
2140     function isHolderOwnAddress(bytes32 _externalHolderId, address _address) public view returns (bool) {
2141         uint _holderIndex = holderIndex[_externalHolderId];
2142         if (_holderIndex == 0) {
2143             return false;
2144         }
2145         return holders[_holderIndex].address2Index[_address] != 0;
2146     }
2147 
2148     function getCountryInfo(uint _countryCode) public view returns (uint _maxHolderNumber, uint _currentHolderCount) {
2149         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2150         return (_data.maxTokenHolderNumber, _data.currentTokenHolderNumber);
2151     }
2152 
2153     function getCountryLimit(uint _countryCode) public view returns (uint limit) {
2154         uint _index = countryIndex[_countryCode];
2155         require(_index != 0);
2156         return countryLimitsList[_index].maxTokenHolderNumber;
2157     }
2158 
2159     function addCountryCode(uint _countryCode) onlyContractOwner public returns (uint) {
2160         var (,_created) = _createCountryId(_countryCode);
2161         if (!_created) {
2162             return _emitError(DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS);
2163         }
2164         return OK;
2165     }
2166 
2167     /// @notice Returns holder id for the specified address, creates it if needed.
2168     /// @param _externalHolderId holder address.
2169     /// @param _countryCode country code.
2170     /// @return error code.
2171     function registerHolder(bytes32 _externalHolderId, address _holderAddress, uint _countryCode) onlyOracleOrOwner external returns (uint) {
2172         require(_holderAddress != 0x0);
2173         uint _holderIndex = holderIndex[holderAddress2Id[_holderAddress]];
2174         require(_holderIndex == 0);
2175 
2176         _createCountryId(_countryCode);
2177         _holderIndex = holdersCount.add(1);
2178         holdersCount = _holderIndex;
2179 
2180         HoldersData storage _holderData = holders[_holderIndex];
2181         _holderData.countryCode = _countryCode;
2182         _holderData.operational = true;
2183         _holderData.sendLimPerDay = MAX_TOKEN_HOLDER_NUMBER;
2184         _holderData.sendLimPerMonth = MAX_TOKEN_HOLDER_NUMBER;
2185         uint _firstAddressIndex = 1;
2186         _holderData.holderAddressCount = _firstAddressIndex;
2187         _holderData.address2Index[_holderAddress] = _firstAddressIndex;
2188         _holderData.index2Address[_firstAddressIndex] = _holderAddress;
2189         holderIndex[_externalHolderId] = _holderIndex;
2190         holderAddress2Id[_holderAddress] = _externalHolderId;
2191 
2192         _emitHolderRegistered(_externalHolderId, _holderIndex, _countryCode);
2193         return OK;
2194     }
2195 
2196     /// @notice Adds new address equivalent to holder.
2197     /// @param _externalHolderId external holder identifier.
2198     /// @param _newAddress adding address.
2199     /// @return error code.
2200     function addHolderAddress(bytes32 _externalHolderId, address _newAddress) onlyOracleOrOwner external returns (uint) {
2201         uint _holderIndex = holderIndex[_externalHolderId];
2202         require(_holderIndex != 0);
2203 
2204         uint _newAddressId = holderIndex[holderAddress2Id[_newAddress]];
2205         require(_newAddressId == 0);
2206 
2207         HoldersData storage _holderData = holders[_holderIndex];
2208 
2209         if (_holderData.address2Index[_newAddress] == 0) {
2210             _holderData.holderAddressCount = _holderData.holderAddressCount.add(1);
2211             _holderData.address2Index[_newAddress] = _holderData.holderAddressCount;
2212             _holderData.index2Address[_holderData.holderAddressCount] = _newAddress;
2213         }
2214 
2215         holderAddress2Id[_newAddress] = _externalHolderId;
2216 
2217         _emitHolderAddressAdded(_externalHolderId, _newAddress, _holderIndex);
2218         return OK;
2219     }
2220 
2221     /// @notice Remove an address owned by a holder.
2222     /// @param _externalHolderId external holder identifier.
2223     /// @param _address removing address.
2224     /// @return error code.
2225     function removeHolderAddress(bytes32 _externalHolderId, address _address) onlyOracleOrOwner external returns (uint) {
2226         uint _holderIndex = holderIndex[_externalHolderId];
2227         require(_holderIndex != 0);
2228 
2229         HoldersData storage _holderData = holders[_holderIndex];
2230 
2231         uint _tempIndex = _holderData.address2Index[_address];
2232         require(_tempIndex != 0);
2233 
2234         address _lastAddress = _holderData.index2Address[_holderData.holderAddressCount];
2235         _holderData.address2Index[_lastAddress] = _tempIndex;
2236         _holderData.index2Address[_tempIndex] = _lastAddress;
2237         delete _holderData.address2Index[_address];
2238         _holderData.holderAddressCount = _holderData.holderAddressCount.sub(1);
2239 
2240         delete holderAddress2Id[_address];
2241 
2242         _emitHolderAddressRemoved(_externalHolderId, _address, _holderIndex);
2243         return OK;
2244     }
2245 
2246     /// @notice Change operational status for holder.
2247     /// Can be accessed by contract owner or oracle only.
2248     ///
2249     /// @param _externalHolderId external holder identifier.
2250     /// @param _operational operational status.
2251     ///
2252     /// @return result code.
2253     function changeOperational(bytes32 _externalHolderId, bool _operational) onlyOracleOrOwner external returns (uint) {
2254         uint _holderIndex = holderIndex[_externalHolderId];
2255         require(_holderIndex != 0);
2256 
2257         holders[_holderIndex].operational = _operational;
2258 
2259         _emitHolderOperationalChanged(_externalHolderId, _operational);
2260         return OK;
2261     }
2262 
2263     /// @notice Changes text for holder.
2264     /// Can be accessed by contract owner or oracle only.
2265     ///
2266     /// @param _externalHolderId external holder identifier.
2267     /// @param _text changing text.
2268     ///
2269     /// @return result code.
2270     function updateTextForHolder(bytes32 _externalHolderId, bytes _text) onlyOracleOrOwner external returns (uint) {
2271         uint _holderIndex = holderIndex[_externalHolderId];
2272         require(_holderIndex != 0);
2273 
2274         holders[_holderIndex].text = _text;
2275         return OK;
2276     }
2277 
2278     /// @notice Updates limit per day for holder.
2279     ///
2280     /// Can be accessed by contract owner only.
2281     ///
2282     /// @param _externalHolderId external holder identifier.
2283     /// @param _limit limit value.
2284     ///
2285     /// @return result code.
2286     function updateLimitPerDay(bytes32 _externalHolderId, uint _limit) onlyOracleOrOwner external returns (uint) {
2287         uint _holderIndex = holderIndex[_externalHolderId];
2288         require(_holderIndex != 0);
2289 
2290         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2291         holders[_holderIndex].sendLimPerDay = _limit;
2292 
2293         _emitDayLimitChanged(_externalHolderId, _currentLimit, _limit);
2294         return OK;
2295     }
2296 
2297     /// @notice Updates limit per month for holder.
2298     /// Can be accessed by contract owner or oracle only.
2299     ///
2300     /// @param _externalHolderId external holder identifier.
2301     /// @param _limit limit value.
2302     ///
2303     /// @return result code.
2304     function updateLimitPerMonth(bytes32 _externalHolderId, uint _limit) onlyOracleOrOwner external returns (uint) {
2305         uint _holderIndex = holderIndex[_externalHolderId];
2306         require(_holderIndex != 0);
2307 
2308         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2309         holders[_holderIndex].sendLimPerMonth = _limit;
2310 
2311         _emitMonthLimitChanged(_externalHolderId, _currentLimit, _limit);
2312         return OK;
2313     }
2314 
2315     /// @notice Change country limits.
2316     /// Can be accessed by contract owner or oracle only.
2317     ///
2318     /// @param _countryCode country code.
2319     /// @param _limit limit value.
2320     ///
2321     /// @return result code.
2322     function changeCountryLimit(uint _countryCode, uint _limit) onlyOracleOrOwner external returns (uint) {
2323         uint _countryIndex = countryIndex[_countryCode];
2324         require(_countryIndex != 0);
2325 
2326         uint _currentTokenHolderNumber = countryLimitsList[_countryIndex].currentTokenHolderNumber;
2327         if (_currentTokenHolderNumber > _limit) {
2328             return DATA_CONTROLLER_CURRENT_WRONG_LIMIT;
2329         }
2330 
2331         countryLimitsList[_countryIndex].maxTokenHolderNumber = _limit;
2332         
2333         _emitCountryCodeChanged(_countryIndex, _countryCode, _limit);
2334         return OK;
2335     }
2336 
2337     function withdrawFrom(address _holderAddress, uint _value) public onlyAsset returns (uint) {
2338         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2339         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2340         _holderData.sendLimPerDay = _holderData.sendLimPerDay.sub(_value);
2341         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.sub(_value);
2342         return OK;
2343     }
2344 
2345     function depositTo(address _holderAddress, uint _value) public onlyAsset returns (uint) {
2346         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2347         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2348         _holderData.sendLimPerDay = _holderData.sendLimPerDay.add(_value);
2349         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.add(_value);
2350         return OK;
2351     }
2352 
2353     function updateCountryHoldersCount(uint _countryCode, uint _updatedHolderCount) public onlyAsset returns (uint) {
2354         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2355         assert(_data.maxTokenHolderNumber >= _updatedHolderCount);
2356         _data.currentTokenHolderNumber = _updatedHolderCount;
2357         return OK;
2358     }
2359 
2360     function changeAllowance(address _from, uint _value) public onlyWithdrawal returns (uint) {
2361         ServiceController _serviceController = ServiceController(serviceController);
2362         ATxAssetProxy token = ATxAssetProxy(_serviceController.proxy());
2363         if (token.balanceOf(_from) < _value) {
2364             return DATA_CONTROLLER_WRONG_ALLOWANCE;
2365         }
2366         allowance[_from] = _value;
2367         return OK;
2368     }
2369 
2370     function _createCountryId(uint _countryCode) internal returns (uint, bool _created) {
2371         uint countryId = countryIndex[_countryCode];
2372         if (countryId == 0) {
2373             uint _countriesCount = countriesCount;
2374             countryId = _countriesCount.add(1);
2375             countriesCount = countryId;
2376             CountryLimits storage limits = countryLimitsList[countryId];
2377             limits.countryCode = _countryCode;
2378             limits.maxTokenHolderNumber = MAX_TOKEN_HOLDER_NUMBER;
2379 
2380             countryIndex[_countryCode] = countryId;
2381             _emitCountryCodeAdded(countryIndex[_countryCode], _countryCode, MAX_TOKEN_HOLDER_NUMBER);
2382 
2383             _created = true;
2384         }
2385 
2386         return (countryId, _created);
2387     }
2388 }
2389 
2390 /// @title Contract that will work with ERC223 tokens.
2391 interface ERC223ReceivingInterface {
2392 
2393 	/// @notice Standard ERC223 function that will handle incoming token transfers.
2394 	/// @param _from  Token sender address.
2395 	/// @param _value Amount of tokens.
2396 	/// @param _data  Transaction metadata.
2397     function tokenFallback(address _from, uint _value, bytes _data) external;
2398 }
2399 
2400 /// @title ATx Asset implementation contract.
2401 ///
2402 /// Basic asset implementation contract, without any additional logic.
2403 /// Every other asset implementation contracts should derive from this one.
2404 /// Receives calls from the proxy, and calls back immediately without arguments modification.
2405 ///
2406 /// Note: all the non constant functions return false instead of throwing in case if state change
2407 /// didn't happen yet.
2408 contract ATxAsset is BasicAsset, Owned {
2409 
2410     uint public constant OK = 1;
2411 
2412     using SafeMath for uint;
2413 
2414     enum Roles {
2415         Holder,
2416         Service,
2417         Other
2418     }
2419 
2420     ServiceController public serviceController;
2421     DataController public dataController;
2422     uint public lockupDate;
2423 
2424     /// @notice Default constructor for ATxAsset.
2425     function ATxAsset() public {
2426     }
2427 
2428     function() payable public {
2429         revert();
2430     }
2431 
2432     /// @notice Init function for ATxAsset.
2433     ///
2434     /// @param _proxy - atx asset proxy.
2435     /// @param _serviceController - service controoler.
2436     /// @param _dataController - data controller.
2437     /// @param _lockupDate - th lockup date.
2438     function initAtx(
2439         address _proxy, 
2440         address _serviceController, 
2441         address _dataController, 
2442         uint _lockupDate
2443     ) 
2444     onlyContractOwner 
2445     public 
2446     returns (bool) 
2447     {
2448         require(_serviceController != 0x0);
2449         require(_dataController != 0x0);
2450         require(_proxy != 0x0);
2451         require(_lockupDate > now || _lockupDate == 0);
2452 
2453         if (!super.init(ATxProxy(_proxy))) {
2454             return false;
2455         }
2456 
2457         serviceController = ServiceController(_serviceController);
2458         dataController = DataController(_dataController);
2459         lockupDate = _lockupDate;
2460         return true;
2461     }
2462 
2463     /// @notice Performs transfer call on the platform by the name of specified sender.
2464     ///
2465     /// @dev Can only be called by proxy asset.
2466     ///
2467     /// @param _to holder address to give to.
2468     /// @param _value amount to transfer.
2469     /// @param _reference transfer comment to be included in a platform's Transfer event.
2470     /// @param _sender initial caller.
2471     ///
2472     /// @return success.
2473     function __transferWithReference(
2474         address _to, 
2475         uint _value, 
2476         string _reference, 
2477         address _sender
2478     ) 
2479     onlyProxy 
2480     public 
2481     returns (bool) 
2482     {
2483         var (_fromRole, _toRole) = _getParticipantRoles(_sender, _to);
2484 
2485         if (!_checkTransferAllowance(_to, _toRole, _value, _sender, _fromRole)) {
2486             return false;
2487         }
2488 
2489         if (!_isValidCountryLimits(_to, _toRole, _value, _sender, _fromRole)) {
2490             return false;
2491         }
2492 
2493         if (!super.__transferWithReference(_to, _value, _reference, _sender)) {
2494             return false;
2495         }
2496 
2497         _updateTransferLimits(_to, _toRole, _value, _sender, _fromRole);
2498         _contractFallbackERC223(_sender, _to, _value);
2499 
2500         return true;
2501     }
2502 
2503     /// @notice Performs allowance transfer call on the platform by the name of specified sender.
2504     ///
2505     /// @dev Can only be called by proxy asset.
2506     ///
2507     /// @param _from holder address to take from.
2508     /// @param _to holder address to give to.
2509     /// @param _value amount to transfer.
2510     /// @param _reference transfer comment to be included in a platform's Transfer event.
2511     /// @param _sender initial caller.
2512     ///
2513     /// @return success.
2514     function __transferFromWithReference(
2515         address _from, 
2516         address _to, 
2517         uint _value, 
2518         string _reference, 
2519         address _sender
2520     ) 
2521     public 
2522     onlyProxy 
2523     returns (bool) 
2524     {
2525         var (_fromRole, _toRole) = _getParticipantRoles(_from, _to);
2526 
2527         // @note Special check for operational withdraw.
2528         bool _isTransferFromHolderToContractOwner = (_fromRole == Roles.Holder) && 
2529             (contractOwner == _to) && 
2530             (dataController.allowance(_from) >= _value) && 
2531             super.__transferFromWithReference(_from, _to, _value, _reference, _sender);
2532         if (_isTransferFromHolderToContractOwner) {
2533             return true;
2534         }
2535 
2536         if (!_checkTransferAllowanceFrom(_to, _toRole, _value, _from, _fromRole, _sender)) {
2537             return false;
2538         }
2539 
2540         if (!_isValidCountryLimits(_to, _toRole, _value, _from, _fromRole)) {
2541             return false;
2542         }
2543 
2544         if (!super.__transferFromWithReference(_from, _to, _value, _reference, _sender)) {
2545             return false;
2546         }
2547 
2548         _updateTransferLimits(_to, _toRole, _value, _from, _fromRole);
2549         _contractFallbackERC223(_from, _to, _value);
2550 
2551         return true;
2552     }
2553 
2554     /* INTERNAL */
2555 
2556     function _contractFallbackERC223(address _from, address _to, uint _value) internal {
2557         uint _codeLength;
2558         assembly {
2559             _codeLength := extcodesize(_to)
2560         }
2561 
2562         if (_codeLength > 0) {
2563             ERC223ReceivingInterface _receiver = ERC223ReceivingInterface(_to);
2564             bytes memory _empty;
2565             _receiver.tokenFallback(_from, _value, _empty);
2566         }
2567     }
2568 
2569     function _isTokenActive() internal view returns (bool) {
2570         return now > lockupDate;
2571     }
2572 
2573     function _checkTransferAllowance(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) internal view returns (bool) {
2574         if (_to == proxy) {
2575             return false;
2576         }
2577 
2578         bool _canTransferFromService = _fromRole == Roles.Service && ServiceAllowance(_from).isTransferAllowed(_from, _to, _from, proxy, _value);
2579         bool _canTransferToService = _toRole == Roles.Service && ServiceAllowance(_to).isTransferAllowed(_from, _to, _from, proxy, _value);
2580         bool _canTransferToHolder = _toRole == Roles.Holder && _couldDepositToHolder(_to, _value);
2581 
2582         bool _canTransferFromHolder;
2583 
2584         if (_isTokenActive()) {
2585             _canTransferFromHolder = _fromRole == Roles.Holder && _couldWithdrawFromHolder(_from, _value);
2586         } else {
2587             _canTransferFromHolder = _fromRole == Roles.Holder && _couldWithdrawFromHolder(_from, _value) && _from == contractOwner;
2588         }
2589 
2590         return (_canTransferFromHolder || _canTransferFromService) && (_canTransferToHolder || _canTransferToService);
2591     }
2592 
2593     function _checkTransferAllowanceFrom(
2594         address _to, 
2595         Roles _toRole, 
2596         uint _value, 
2597         address _from, 
2598         Roles _fromRole, 
2599         address
2600     ) 
2601     internal 
2602     view 
2603     returns (bool) 
2604     {
2605         return _checkTransferAllowance(_to, _toRole, _value, _from, _fromRole);
2606     }
2607 
2608     function _isValidWithdrawLimits(uint _sendLimPerDay, uint _sendLimPerMonth, uint _value) internal pure returns (bool) {
2609         return !(_value > _sendLimPerDay || _value > _sendLimPerMonth);
2610     }
2611 
2612     function _isValidDepositCountry(
2613         uint _value,
2614         uint _withdrawCountryCode,
2615         uint _withdrawBalance,
2616         uint _countryCode,
2617         uint _balance,
2618         uint _currentHolderCount,
2619         uint _maxHolderNumber
2620     )
2621     internal
2622     pure
2623     returns (bool)
2624     {
2625         return _isNoNeedInCountryLimitChange(_value, _withdrawCountryCode, _withdrawBalance, _countryCode, _balance, _currentHolderCount, _maxHolderNumber)
2626         ? true
2627         : _isValidDepositCountry(_balance, _currentHolderCount, _maxHolderNumber);
2628     }
2629 
2630     function _isNoNeedInCountryLimitChange(
2631         uint _value,
2632         uint _withdrawCountryCode,
2633         uint _withdrawBalance,
2634         uint _countryCode,
2635         uint _balance,
2636         uint _currentHolderCount,
2637         uint _maxHolderNumber
2638     )
2639     internal
2640     pure
2641     returns (bool)
2642     {
2643         bool _needToIncrementCountryHolderCount = _balance == 0;
2644         bool _needToDecrementCountryHolderCount = _withdrawBalance == _value;
2645         bool _shouldOverflowCountryHolderCount = _currentHolderCount == _maxHolderNumber;
2646 
2647         return _withdrawCountryCode == _countryCode && _needToDecrementCountryHolderCount && _needToIncrementCountryHolderCount && _shouldOverflowCountryHolderCount;
2648     }
2649 
2650     function _updateCountries(
2651         uint _value,
2652         uint _withdrawCountryCode,
2653         uint _withdrawBalance,
2654         uint _withdrawCurrentHolderCount,
2655         uint _countryCode,
2656         uint _balance,
2657         uint _currentHolderCount,
2658         uint _maxHolderNumber
2659     )
2660     internal
2661     {
2662         if (_isNoNeedInCountryLimitChange(_value, _withdrawCountryCode, _withdrawBalance, _countryCode, _balance, _currentHolderCount, _maxHolderNumber)) {
2663             return;
2664         }
2665 
2666         _updateWithdrawCountry(_value, _withdrawCountryCode, _withdrawBalance, _withdrawCurrentHolderCount);
2667         _updateDepositCountry(_countryCode, _balance, _currentHolderCount);
2668     }
2669 
2670     function _updateWithdrawCountry(
2671         uint _value,
2672         uint _countryCode,
2673         uint _balance,
2674         uint _currentHolderCount
2675     )
2676     internal
2677     {
2678         if (_value == _balance && OK != dataController.updateCountryHoldersCount(_countryCode, _currentHolderCount.sub(1))) {
2679             revert();
2680         }
2681     }
2682 
2683     function _updateDepositCountry(
2684         uint _countryCode,
2685         uint _balance,
2686         uint _currentHolderCount
2687     )
2688     internal
2689     {
2690         if (_balance == 0 && OK != dataController.updateCountryHoldersCount(_countryCode, _currentHolderCount.add(1))) {
2691             revert();
2692         }
2693     }
2694 
2695     function _getParticipantRoles(address _from, address _to) private view returns (Roles _fromRole, Roles _toRole) {
2696         _fromRole = dataController.isRegisteredAddress(_from) ? Roles.Holder : (serviceController.isService(_from) ? Roles.Service : Roles.Other);
2697         _toRole = dataController.isRegisteredAddress(_to) ? Roles.Holder : (serviceController.isService(_to) ? Roles.Service : Roles.Other);
2698     }
2699 
2700     function _couldWithdrawFromHolder(address _holder, uint _value) private view returns (bool) {
2701         bytes32 _holderId = dataController.getHolderExternalIdByAddress(_holder);
2702         var (, _limPerDay, _limPerMonth, _operational,) = dataController.getHolderInfo(_holderId);
2703         return _operational ? _isValidWithdrawLimits(_limPerDay, _limPerMonth, _value) : false;
2704     }
2705 
2706     function _couldDepositToHolder(address _holder, uint) private view returns (bool) {
2707         bytes32 _holderId = dataController.getHolderExternalIdByAddress(_holder);
2708         var (,,, _operational,) = dataController.getHolderInfo(_holderId);
2709         return _operational;
2710     }
2711 
2712     //TODO need additional check: not clear check of country limit:
2713     function _isValidDepositCountry(uint _balance, uint _currentHolderCount, uint _maxHolderNumber) private pure returns (bool) {
2714         return !(_balance == 0 && _currentHolderCount == _maxHolderNumber);
2715     }
2716 
2717     function _getHoldersInfo(address _to, Roles _toRole, uint, address _from, Roles _fromRole)
2718     private
2719     view
2720     returns (
2721         uint _fromCountryCode,
2722         uint _fromBalance,
2723         uint _toCountryCode,
2724         uint _toCountryCurrentHolderCount,
2725         uint _toCountryMaxHolderNumber,
2726         uint _toBalance
2727     ) {
2728         bytes32 _holderId;
2729         if (_toRole == Roles.Holder) {
2730             _holderId = dataController.getHolderExternalIdByAddress(_to);
2731             _toCountryCode = dataController.getHolderCountryCode(_holderId);
2732             (_toCountryCurrentHolderCount, _toCountryMaxHolderNumber) = dataController.getCountryInfo(_toCountryCode);
2733             _toBalance = ERC20Interface(proxy).balanceOf(_to);
2734         }
2735 
2736         if (_fromRole == Roles.Holder) {
2737             _holderId = dataController.getHolderExternalIdByAddress(_from);
2738             _fromCountryCode = dataController.getHolderCountryCode(_holderId);
2739             _fromBalance = ERC20Interface(proxy).balanceOf(_from);
2740         }
2741     }
2742 
2743     function _isValidCountryLimits(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) private view returns (bool) {
2744         var (
2745         _fromCountryCode,
2746         _fromBalance,
2747         _toCountryCode,
2748         _toCountryCurrentHolderCount,
2749         _toCountryMaxHolderNumber,
2750         _toBalance
2751         ) = _getHoldersInfo(_to, _toRole, _value, _from, _fromRole);
2752 
2753         //TODO not clear for which case this check
2754         bool _isValidLimitFromHolder = _fromRole == _toRole && _fromRole == Roles.Holder && !_isValidDepositCountry(_value, _fromCountryCode, _fromBalance, _toCountryCode, _toBalance, _toCountryCurrentHolderCount, _toCountryMaxHolderNumber);
2755         bool _isValidLimitsToHolder = _toRole == Roles.Holder && !_isValidDepositCountry(_toBalance, _toCountryCurrentHolderCount, _toCountryMaxHolderNumber);
2756 
2757         return !(_isValidLimitFromHolder || _isValidLimitsToHolder);
2758     }
2759 
2760     function _updateTransferLimits(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) private {
2761         var (
2762         _fromCountryCode,
2763         _fromBalance,
2764         _toCountryCode,
2765         _toCountryCurrentHolderCount,
2766         _toCountryMaxHolderNumber,
2767         _toBalance
2768         ) = _getHoldersInfo(_to, _toRole, _value, _from, _fromRole);
2769 
2770         if (_fromRole == Roles.Holder && OK != dataController.withdrawFrom(_from, _value)) {
2771             revert();
2772         }
2773 
2774         if (_toRole == Roles.Holder && OK != dataController.depositTo(_from, _value)) {
2775             revert();
2776         }
2777 
2778         uint _fromCountryCurrentHolderCount;
2779         if (_fromRole == Roles.Holder && _fromRole == _toRole) {
2780             (_fromCountryCurrentHolderCount,) = dataController.getCountryInfo(_fromCountryCode);
2781             _updateCountries(
2782                 _value,
2783                 _fromCountryCode,
2784                 _fromBalance,
2785                 _fromCountryCurrentHolderCount,
2786                 _toCountryCode,
2787                 _toBalance,
2788                 _toCountryCurrentHolderCount,
2789                 _toCountryMaxHolderNumber
2790             );
2791         } else if (_fromRole == Roles.Holder) {
2792             (_fromCountryCurrentHolderCount,) = dataController.getCountryInfo(_fromCountryCode);
2793             _updateWithdrawCountry(_value, _fromCountryCode, _fromBalance, _fromCountryCurrentHolderCount);
2794         } else if (_toRole == Roles.Holder) {
2795             _updateDepositCountry(_toCountryCode, _toBalance, _toCountryCurrentHolderCount);
2796         }
2797     }
2798 }
2799 
2800 
2801 
2802 /// @title ATx Asset implementation contract.
2803 ///
2804 /// Basic asset implementation contract, without any additional logic.
2805 /// Every other asset implementation contracts should derive from this one.
2806 /// Receives calls from the proxy, and calls back immediately without arguments modification.
2807 ///
2808 /// Note: all the non constant functions return false instead of throwing in case if state change
2809 /// didn't happen yet.
2810 contract XMIAsset is ATxAsset {
2811 }