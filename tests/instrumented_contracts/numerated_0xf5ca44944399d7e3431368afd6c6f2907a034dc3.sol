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
78 /**
79 * @title SafeMath
80 * @dev Math operations with safety checks that throw on error
81 */
82 library SafeMath {
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a * b;
85         assert(a == 0 || c / a == b);
86         return c;
87     }
88 
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // assert(b > 0); // Solidity automatically throws when dividing by 0
91         uint256 c = a / b;
92         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         assert(b <= a);
98         return a - b;
99     }
100 
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 }
107 
108 /// @title Provides possibility manage holders? country limits and limits for holders.
109 contract DataControllerInterface {
110 
111     /// @notice Checks user is holder.
112     /// @param _address - checking address.
113     /// @return `true` if _address is registered holder, `false` otherwise.
114     function isHolderAddress(address _address) public view returns (bool);
115 
116     function allowance(address _user) public view returns (uint);
117 
118     function changeAllowance(address _holder, uint _value) public returns (uint);
119 }
120 
121 /// @title ServiceController
122 ///
123 /// Base implementation
124 /// Serves for managing service instances
125 contract ServiceControllerInterface {
126 
127     /// @notice Check target address is service
128     /// @param _address target address
129     /// @return `true` when an address is a service, `false` otherwise
130     function isService(address _address) public view returns (bool);
131 }
132 
133 contract ATxAssetInterface {
134 
135     DataControllerInterface public dataController;
136     ServiceControllerInterface public serviceController;
137 
138     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
139     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
140     function __approve(address _spender, uint _value, address _sender) public returns (bool);
141     function __process(bytes /*_data*/, address /*_sender*/) payable public {
142         revert();
143     }
144 }
145 
146 
147 contract ERC20 {
148     event Transfer(address indexed from, address indexed to, uint256 value);
149     event Approval(address indexed from, address indexed spender, uint256 value);
150     string public symbol;
151 
152     function totalSupply() constant returns (uint256 supply);
153     function balanceOf(address _owner) constant returns (uint256 balance);
154     function transfer(address _to, uint256 _value) returns (bool success);
155     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
156     function approve(address _spender, uint256 _value) returns (bool success);
157     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
158 }
159 
160 contract AssetProxy is ERC20 {
161     
162     bytes32 public smbl;
163     address public platform;
164 
165     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
166     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
167     function __approve(address _spender, uint _value, address _sender) public returns (bool);
168     function getLatestVersion() public returns (address);
169     function init(address _bmcPlatform, string _symbol, string _name) public;
170     function proposeUpgrade(address _newVersion) public;
171 }
172 
173 contract BasicAsset is ATxAssetInterface {
174 
175     // Assigned asset proxy contract, immutable.
176     address public proxy;
177 
178     /**
179      * Only assigned proxy is allowed to call.
180      */
181     modifier onlyProxy() {
182         if (proxy == msg.sender) {
183             _;
184         }
185     }
186 
187     /**
188      * Sets asset proxy address.
189      *
190      * Can be set only once.
191      *
192      * @param _proxy asset proxy contract address.
193      *
194      * @return success.
195      * @dev function is final, and must not be overridden.
196      */
197     function init(address _proxy) public returns (bool) {
198         if (address(proxy) != 0x0) {
199             return false;
200         }
201         proxy = _proxy;
202         return true;
203     }
204 
205     /**
206      * Passes execution into virtual function.
207      *
208      * Can only be called by assigned asset proxy.
209      *
210      * @return success.
211      * @dev function is final, and must not be overridden.
212      */
213     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyProxy returns (bool) {
214         return _transferWithReference(_to, _value, _reference, _sender);
215     }
216 
217     /**
218      * Passes execution into virtual function.
219      *
220      * Can only be called by assigned asset proxy.
221      *
222      * @return success.
223      * @dev function is final, and must not be overridden.
224      */
225     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyProxy returns (bool) {
226         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
227     }
228 
229     /**
230      * Passes execution into virtual function.
231      *
232      * Can only be called by assigned asset proxy.
233      *
234      * @return success.
235      * @dev function is final, and must not be overridden.
236      */
237     function __approve(address _spender, uint _value, address _sender) public onlyProxy returns (bool) {
238         return _approve(_spender, _value, _sender);
239     }
240 
241     /**
242      * Calls back without modifications.
243      *
244      * @return success.
245      * @dev function is virtual, and meant to be overridden.
246      */
247     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns (bool) {
248         return AssetProxy(proxy).__transferWithReference(_to, _value, _reference, _sender);
249     }
250 
251     /**
252      * Calls back without modifications.
253      *
254      * @return success.
255      * @dev function is virtual, and meant to be overridden.
256      */
257     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns (bool) {
258         return AssetProxy(proxy).__transferFromWithReference(_from, _to, _value, _reference, _sender);
259     }
260 
261     /**
262      * Calls back without modifications.
263      *
264      * @return success.
265      * @dev function is virtual, and meant to be overridden.
266      */
267     function _approve(address _spender, uint _value, address _sender) internal returns (bool) {
268         return AssetProxy(proxy).__approve(_spender, _value, _sender);
269     }
270 }
271 
272 /// @title ServiceAllowance.
273 ///
274 /// Provides a way to delegate operation allowance decision to a service contract
275 contract ServiceAllowance {
276     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
277 }
278 
279 contract ERC20Interface {
280     event Transfer(address indexed from, address indexed to, uint256 value);
281     event Approval(address indexed from, address indexed spender, uint256 value);
282     string public symbol;
283 
284     function totalSupply() constant returns (uint256 supply);
285     function balanceOf(address _owner) constant returns (uint256 balance);
286     function transfer(address _to, uint256 _value) returns (bool success);
287     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
288     function approve(address _spender, uint256 _value) returns (bool success);
289     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
290 }
291 
292 /**
293  * @title Generic owned destroyable contract
294  */
295 contract Object is Owned {
296     /**
297     *  Common result code. Means everything is fine.
298     */
299     uint constant OK = 1;
300     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
301 
302     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
303         for(uint i=0;i<tokens.length;i++) {
304             address token = tokens[i];
305             uint balance = ERC20Interface(token).balanceOf(this);
306             if(balance != 0)
307                 ERC20Interface(token).transfer(_to,balance);
308         }
309         return OK;
310     }
311 
312     function checkOnlyContractOwner() internal constant returns(uint) {
313         if (contractOwner == msg.sender) {
314             return OK;
315         }
316 
317         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
318     }
319 }
320 
321 contract GroupsAccessManagerEmitter {
322 
323     event UserCreated(address user);
324     event UserDeleted(address user);
325     event GroupCreated(bytes32 groupName);
326     event GroupActivated(bytes32 groupName);
327     event GroupDeactivated(bytes32 groupName);
328     event UserToGroupAdded(address user, bytes32 groupName);
329     event UserFromGroupRemoved(address user, bytes32 groupName);
330 }
331 
332 /// @title Group Access Manager
333 ///
334 /// Base implementation
335 /// This contract serves as group manager
336 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
337 
338     uint constant USER_MANAGER_SCOPE = 111000;
339     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
340     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
341     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
342     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
343     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
344     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
345     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
346     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
347     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
348 
349     using SafeMath for uint;
350 
351     struct Member {
352         address addr;
353         uint groupsCount;
354         mapping(bytes32 => uint) groupName2index;
355         mapping(uint => uint) index2globalIndex;
356     }
357 
358     struct Group {
359         bytes32 name;
360         uint priority;
361         uint membersCount;
362         mapping(address => uint) memberAddress2index;
363         mapping(uint => uint) index2globalIndex;
364     }
365 
366     uint public membersCount;
367     mapping(uint => address) index2memberAddress;
368     mapping(address => uint) memberAddress2index;
369     mapping(address => Member) address2member;
370 
371     uint public groupsCount;
372     mapping(uint => bytes32) index2groupName;
373     mapping(bytes32 => uint) groupName2index;
374     mapping(bytes32 => Group) groupName2group;
375     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
376 
377     function() payable public {
378         revert();
379     }
380 
381     /// @notice Register user
382     /// Can be called only by contract owner
383     ///
384     /// @param _user user address
385     ///
386     /// @return code
387     function registerUser(address _user) external onlyContractOwner returns (uint) {
388         require(_user != 0x0);
389 
390         if (isRegisteredUser(_user)) {
391             return USER_MANAGER_MEMBER_ALREADY_EXIST;
392         }
393 
394         uint _membersCount = membersCount.add(1);
395         membersCount = _membersCount;
396         memberAddress2index[_user] = _membersCount;
397         index2memberAddress[_membersCount] = _user;
398         address2member[_user] = Member(_user, 0);
399 
400         UserCreated(_user);
401         return OK;
402     }
403 
404     /// @notice Discard user registration
405     /// Can be called only by contract owner
406     ///
407     /// @param _user user address
408     ///
409     /// @return code
410     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
411         require(_user != 0x0);
412 
413         uint _memberIndex = memberAddress2index[_user];
414         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
415             return USER_MANAGER_INVALID_INVOCATION;
416         }
417 
418         uint _membersCount = membersCount;
419         delete memberAddress2index[_user];
420         if (_memberIndex != _membersCount) {
421             address _lastUser = index2memberAddress[_membersCount];
422             index2memberAddress[_memberIndex] = _lastUser;
423             memberAddress2index[_lastUser] = _memberIndex;
424         }
425         delete address2member[_user];
426         delete index2memberAddress[_membersCount];
427         delete memberAddress2index[_user];
428         membersCount = _membersCount.sub(1);
429 
430         UserDeleted(_user);
431         return OK;
432     }
433 
434     /// @notice Create group
435     /// Can be called only by contract owner
436     ///
437     /// @param _groupName group name
438     /// @param _priority group priority
439     ///
440     /// @return code
441     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
442         require(_groupName != bytes32(0));
443 
444         if (isGroupExists(_groupName)) {
445             return USER_MANAGER_GROUP_ALREADY_EXIST;
446         }
447 
448         uint _groupsCount = groupsCount.add(1);
449         groupName2index[_groupName] = _groupsCount;
450         index2groupName[_groupsCount] = _groupName;
451         groupName2group[_groupName] = Group(_groupName, _priority, 0);
452         groupsCount = _groupsCount;
453 
454         GroupCreated(_groupName);
455         return OK;
456     }
457 
458     /// @notice Change group status
459     /// Can be called only by contract owner
460     ///
461     /// @param _groupName group name
462     /// @param _blocked block status
463     ///
464     /// @return code
465     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
466         require(isGroupExists(_groupName));
467         groupsBlocked[_groupName] = _blocked;
468         return OK;
469     }
470 
471     /// @notice Add users in group
472     /// Can be called only by contract owner
473     ///
474     /// @param _groupName group name
475     /// @param _users user array
476     ///
477     /// @return code
478     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
479         require(isGroupExists(_groupName));
480 
481         Group storage _group = groupName2group[_groupName];
482         uint _groupMembersCount = _group.membersCount;
483 
484         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
485             address _user = _users[_userIdx];
486             uint _memberIndex = memberAddress2index[_user];
487             require(_memberIndex != 0);
488 
489             if (_group.memberAddress2index[_user] != 0) {
490                 continue;
491             }
492 
493             _groupMembersCount = _groupMembersCount.add(1);
494             _group.memberAddress2index[_user] = _groupMembersCount;
495             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
496 
497             _addGroupToMember(_user, _groupName);
498 
499             UserToGroupAdded(_user, _groupName);
500         }
501         _group.membersCount = _groupMembersCount;
502 
503         return OK;
504     }
505 
506     /// @notice Remove users in group
507     /// Can be called only by contract owner
508     ///
509     /// @param _groupName group name
510     /// @param _users user array
511     ///
512     /// @return code
513     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
514         require(isGroupExists(_groupName));
515 
516         Group storage _group = groupName2group[_groupName];
517         uint _groupMembersCount = _group.membersCount;
518 
519         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
520             address _user = _users[_userIdx];
521             uint _memberIndex = memberAddress2index[_user];
522             uint _groupMemberIndex = _group.memberAddress2index[_user];
523 
524             if (_memberIndex == 0 || _groupMemberIndex == 0) {
525                 continue;
526             }
527 
528             if (_groupMemberIndex != _groupMembersCount) {
529                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
530                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
531                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
532                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
533             }
534             delete _group.memberAddress2index[_user];
535             delete _group.index2globalIndex[_groupMembersCount];
536             _groupMembersCount = _groupMembersCount.sub(1);
537 
538             _removeGroupFromMember(_user, _groupName);
539 
540             UserFromGroupRemoved(_user, _groupName);
541         }
542         _group.membersCount = _groupMembersCount;
543 
544         return OK;
545     }
546 
547     /// @notice Check is user registered
548     ///
549     /// @param _user user address
550     ///
551     /// @return status
552     function isRegisteredUser(address _user) public view returns (bool) {
553         return memberAddress2index[_user] != 0;
554     }
555 
556     /// @notice Check is user in group
557     ///
558     /// @param _groupName user array
559     /// @param _user user array
560     ///
561     /// @return status
562     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
563         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
564     }
565 
566     /// @notice Check is group exist
567     ///
568     /// @param _groupName group name
569     ///
570     /// @return status
571     function isGroupExists(bytes32 _groupName) public view returns (bool) {
572         return groupName2index[_groupName] != 0;
573     }
574 
575     /// @notice Get current group names
576     ///
577     /// @return group names
578     function getGroups() public view returns (bytes32[] _groups) {
579         uint _groupsCount = groupsCount;
580         _groups = new bytes32[](_groupsCount);
581         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
582             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
583         }
584     }
585 
586     // PRIVATE
587 
588     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
589         Member storage _member = address2member[_user];
590         uint _memberGroupsCount = _member.groupsCount;
591         uint _memberGroupIndex = _member.groupName2index[_groupName];
592         if (_memberGroupIndex != _memberGroupsCount) {
593             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
594             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
595             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
596             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
597         }
598         delete _member.groupName2index[_groupName];
599         delete _member.index2globalIndex[_memberGroupsCount];
600         _member.groupsCount = _memberGroupsCount.sub(1);
601     }
602 
603     function _addGroupToMember(address _user, bytes32 _groupName) private {
604         Member storage _member = address2member[_user];
605         uint _memberGroupsCount = _member.groupsCount.add(1);
606         _member.groupName2index[_groupName] = _memberGroupsCount;
607         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
608         _member.groupsCount = _memberGroupsCount;
609     }
610 }
611 
612 contract PendingManagerEmitter {
613 
614     event PolicyRuleAdded(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName, uint acceptLimit, uint declinesLimit);
615     event PolicyRuleRemoved(bytes4 sig, address contractAddress, bytes32 key, bytes32 groupName);
616 
617     event ProtectionTxAdded(bytes32 key, bytes32 sig, uint blockNumber);
618     event ProtectionTxAccepted(bytes32 key, address indexed sender, bytes32 groupNameVoted);
619     event ProtectionTxDone(bytes32 key);
620     event ProtectionTxDeclined(bytes32 key, address indexed sender, bytes32 groupNameVoted);
621     event ProtectionTxCancelled(bytes32 key);
622     event ProtectionTxVoteRevoked(bytes32 key, address indexed sender, bytes32 groupNameVoted);
623     event TxDeleted(bytes32 key);
624 
625     event Error(uint errorCode);
626 
627     function _emitError(uint _errorCode) internal returns (uint) {
628         Error(_errorCode);
629         return _errorCode;
630     }
631 }
632 
633 contract PendingManagerInterface {
634 
635     function signIn(address _contract) external returns (uint);
636     function signOut(address _contract) external returns (uint);
637 
638     function addPolicyRule(
639         bytes4 _sig, 
640         address _contract, 
641         bytes32 _groupName, 
642         uint _acceptLimit, 
643         uint _declineLimit 
644         ) 
645         external returns (uint);
646         
647     function removePolicyRule(
648         bytes4 _sig, 
649         address _contract, 
650         bytes32 _groupName
651         ) 
652         external returns (uint);
653 
654     function addTx(bytes32 _key, bytes4 _sig, address _contract) external returns (uint);
655     function deleteTx(bytes32 _key) external returns (uint);
656 
657     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
658     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint);
659     function revoke(bytes32 _key) external returns (uint);
660 
661     function hasConfirmedRecord(bytes32 _key) public view returns (uint);
662     function getPolicyDetails(bytes4 _sig, address _contract) public view returns (
663         bytes32[] _groupNames,
664         uint[] _acceptLimits,
665         uint[] _declineLimits,
666         uint _totalAcceptedLimit,
667         uint _totalDeclinedLimit
668         );
669 }
670 
671 /// @title PendingManager
672 ///
673 /// Base implementation
674 /// This contract serves as pending manager for transaction status
675 contract PendingManager is Object, PendingManagerEmitter, PendingManagerInterface {
676 
677     uint constant NO_RECORDS_WERE_FOUND = 4;
678     uint constant PENDING_MANAGER_SCOPE = 4000;
679     uint constant PENDING_MANAGER_INVALID_INVOCATION = PENDING_MANAGER_SCOPE + 1;
680     uint constant PENDING_MANAGER_HASNT_VOTED = PENDING_MANAGER_SCOPE + 2;
681     uint constant PENDING_DUPLICATE_TX = PENDING_MANAGER_SCOPE + 3;
682     uint constant PENDING_MANAGER_CONFIRMED = PENDING_MANAGER_SCOPE + 4;
683     uint constant PENDING_MANAGER_REJECTED = PENDING_MANAGER_SCOPE + 5;
684     uint constant PENDING_MANAGER_IN_PROCESS = PENDING_MANAGER_SCOPE + 6;
685     uint constant PENDING_MANAGER_TX_DOESNT_EXIST = PENDING_MANAGER_SCOPE + 7;
686     uint constant PENDING_MANAGER_TX_WAS_DECLINED = PENDING_MANAGER_SCOPE + 8;
687     uint constant PENDING_MANAGER_TX_WAS_NOT_CONFIRMED = PENDING_MANAGER_SCOPE + 9;
688     uint constant PENDING_MANAGER_INSUFFICIENT_GAS = PENDING_MANAGER_SCOPE + 10;
689     uint constant PENDING_MANAGER_POLICY_NOT_FOUND = PENDING_MANAGER_SCOPE + 11;
690 
691     using SafeMath for uint;
692 
693     enum GuardState {
694         Decline, Confirmed, InProcess
695     }
696 
697     struct Requirements {
698         bytes32 groupName;
699         uint acceptLimit;
700         uint declineLimit;
701     }
702 
703     struct Policy {
704         uint groupsCount;
705         mapping(uint => Requirements) participatedGroups; // index => globalGroupIndex
706         mapping(bytes32 => uint) groupName2index; // groupName => localIndex
707         
708         uint totalAcceptedLimit;
709         uint totalDeclinedLimit;
710 
711         uint securesCount;
712         mapping(uint => uint) index2txIndex;
713         mapping(uint => uint) txIndex2index;
714     }
715 
716     struct Vote {
717         bytes32 groupName;
718         bool accepted;
719     }
720 
721     struct Guard {
722         GuardState state;
723         uint basePolicyIndex;
724 
725         uint alreadyAccepted;
726         uint alreadyDeclined;
727         
728         mapping(address => Vote) votes; // member address => vote
729         mapping(bytes32 => uint) acceptedCount; // groupName => how many from group has already accepted
730         mapping(bytes32 => uint) declinedCount; // groupName => how many from group has already declined
731     }
732 
733     address public accessManager;
734 
735     mapping(address => bool) public authorized;
736 
737     uint public policiesCount;
738     mapping(uint => bytes32) index2PolicyId; // index => policy hash
739     mapping(bytes32 => uint) policyId2Index; // policy hash => index
740     mapping(bytes32 => Policy) policyId2policy; // policy hash => policy struct
741 
742     uint public txCount;
743     mapping(uint => bytes32) index2txKey;
744     mapping(bytes32 => uint) txKey2index; // tx key => index
745     mapping(bytes32 => Guard) txKey2guard;
746 
747     /// @dev Execution is allowed only by authorized contract
748     modifier onlyAuthorized {
749         if (authorized[msg.sender] || address(this) == msg.sender) {
750             _;
751         }
752     }
753 
754     /// @dev Pending Manager's constructor
755     ///
756     /// @param _accessManager access manager's address
757     function PendingManager(address _accessManager) public {
758         require(_accessManager != 0x0);
759         accessManager = _accessManager;
760     }
761 
762     function() payable public {
763         revert();
764     }
765 
766     /// @notice Update access manager address
767     ///
768     /// @param _accessManager access manager's address
769     function setAccessManager(address _accessManager) external onlyContractOwner returns (uint) {
770         require(_accessManager != 0x0);
771         accessManager = _accessManager;
772         return OK;
773     }
774 
775     /// @notice Sign in contract
776     ///
777     /// @param _contract contract's address
778     function signIn(address _contract) external onlyContractOwner returns (uint) {
779         require(_contract != 0x0);
780         authorized[_contract] = true;
781         return OK;
782     }
783 
784     /// @notice Sign out contract
785     ///
786     /// @param _contract contract's address
787     function signOut(address _contract) external onlyContractOwner returns (uint) {
788         require(_contract != 0x0);
789         delete authorized[_contract];
790         return OK;
791     }
792 
793     /// @notice Register new policy rule
794     /// Can be called only by contract owner
795     ///
796     /// @param _sig target method signature
797     /// @param _contract target contract address
798     /// @param _groupName group's name
799     /// @param _acceptLimit accepted vote limit
800     /// @param _declineLimit decline vote limit
801     ///
802     /// @return code
803     function addPolicyRule(
804         bytes4 _sig,
805         address _contract,
806         bytes32 _groupName,
807         uint _acceptLimit,
808         uint _declineLimit
809     )
810     onlyContractOwner
811     external
812     returns (uint)
813     {
814         require(_sig != 0x0);
815         require(_contract != 0x0);
816         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
817         require(_acceptLimit != 0);
818         require(_declineLimit != 0);
819 
820         bytes32 _policyHash = keccak256(_sig, _contract);
821         
822         if (policyId2Index[_policyHash] == 0) {
823             uint _policiesCount = policiesCount.add(1);
824             index2PolicyId[_policiesCount] = _policyHash;
825             policyId2Index[_policyHash] = _policiesCount;
826             policiesCount = _policiesCount;
827         }
828 
829         Policy storage _policy = policyId2policy[_policyHash];
830         uint _policyGroupsCount = _policy.groupsCount;
831 
832         if (_policy.groupName2index[_groupName] == 0) {
833             _policyGroupsCount += 1;
834             _policy.groupName2index[_groupName] = _policyGroupsCount;
835             _policy.participatedGroups[_policyGroupsCount].groupName = _groupName;
836             _policy.groupsCount = _policyGroupsCount;
837         }
838 
839         uint _previousAcceptLimit = _policy.participatedGroups[_policyGroupsCount].acceptLimit;
840         uint _previousDeclineLimit = _policy.participatedGroups[_policyGroupsCount].declineLimit;
841         _policy.participatedGroups[_policyGroupsCount].acceptLimit = _acceptLimit;
842         _policy.participatedGroups[_policyGroupsCount].declineLimit = _declineLimit;
843         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_previousAcceptLimit).add(_acceptLimit);
844         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_previousDeclineLimit).add(_declineLimit);
845 
846         PolicyRuleAdded(_sig, _contract, _policyHash, _groupName, _acceptLimit, _declineLimit);
847         return OK;
848     }
849 
850     /// @notice Remove policy rule
851     /// Can be called only by contract owner
852     ///
853     /// @param _groupName group's name
854     ///
855     /// @return code
856     function removePolicyRule(
857         bytes4 _sig,
858         address _contract,
859         bytes32 _groupName
860     ) 
861     onlyContractOwner 
862     external 
863     returns (uint) 
864     {
865         require(_sig != bytes4(0));
866         require(_contract != 0x0);
867         require(GroupsAccessManager(accessManager).isGroupExists(_groupName));
868 
869         bytes32 _policyHash = keccak256(_sig, _contract);
870         Policy storage _policy = policyId2policy[_policyHash];
871         uint _policyGroupNameIndex = _policy.groupName2index[_groupName];
872 
873         if (_policyGroupNameIndex == 0) {
874             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
875         }
876 
877         uint _policyGroupsCount = _policy.groupsCount;
878         if (_policyGroupNameIndex != _policyGroupsCount) {
879             Requirements storage _requirements = _policy.participatedGroups[_policyGroupsCount];
880             _policy.participatedGroups[_policyGroupNameIndex] = _requirements;
881             _policy.groupName2index[_requirements.groupName] = _policyGroupNameIndex;
882         }
883 
884         _policy.totalAcceptedLimit = _policy.totalAcceptedLimit.sub(_policy.participatedGroups[_policyGroupsCount].acceptLimit);
885         _policy.totalDeclinedLimit = _policy.totalDeclinedLimit.sub(_policy.participatedGroups[_policyGroupsCount].declineLimit);
886 
887         delete _policy.groupName2index[_groupName];
888         delete _policy.participatedGroups[_policyGroupsCount];
889         _policy.groupsCount = _policyGroupsCount.sub(1);
890 
891         PolicyRuleRemoved(_sig, _contract, _policyHash, _groupName);
892         return OK;
893     }
894 
895     /// @notice Add transaction
896     ///
897     /// @param _key transaction id
898     ///
899     /// @return code
900     function addTx(bytes32 _key, bytes4 _sig, address _contract) external onlyAuthorized returns (uint) {
901         require(_key != bytes32(0));
902         require(_sig != bytes4(0));
903         require(_contract != 0x0);
904 
905         bytes32 _policyHash = keccak256(_sig, _contract);
906         require(isPolicyExist(_policyHash));
907 
908         if (isTxExist(_key)) {
909             return _emitError(PENDING_DUPLICATE_TX);
910         }
911 
912         if (_policyHash == bytes32(0)) {
913             return _emitError(PENDING_MANAGER_POLICY_NOT_FOUND);
914         }
915 
916         uint _index = txCount.add(1);
917         txCount = _index;
918         index2txKey[_index] = _key;
919         txKey2index[_key] = _index;
920 
921         Guard storage _guard = txKey2guard[_key];
922         _guard.basePolicyIndex = policyId2Index[_policyHash];
923         _guard.state = GuardState.InProcess;
924 
925         Policy storage _policy = policyId2policy[_policyHash];
926         uint _counter = _policy.securesCount.add(1);
927         _policy.securesCount = _counter;
928         _policy.index2txIndex[_counter] = _index;
929         _policy.txIndex2index[_index] = _counter;
930 
931         ProtectionTxAdded(_key, _policyHash, block.number);
932         return OK;
933     }
934 
935     /// @notice Delete transaction
936     /// @param _key transaction id
937     /// @return code
938     function deleteTx(bytes32 _key) external onlyContractOwner returns (uint) {
939         require(_key != bytes32(0));
940 
941         if (!isTxExist(_key)) {
942             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
943         }
944 
945         uint _txsCount = txCount;
946         uint _txIndex = txKey2index[_key];
947         if (_txIndex != _txsCount) {
948             bytes32 _last = index2txKey[txCount];
949             index2txKey[_txIndex] = _last;
950             txKey2index[_last] = _txIndex;
951         }
952 
953         delete txKey2index[_key];
954         delete index2txKey[_txsCount];
955         txCount = _txsCount.sub(1);
956 
957         uint _basePolicyIndex = txKey2guard[_key].basePolicyIndex;
958         Policy storage _policy = policyId2policy[index2PolicyId[_basePolicyIndex]];
959         uint _counter = _policy.securesCount;
960         uint _policyTxIndex = _policy.txIndex2index[_txIndex];
961         if (_policyTxIndex != _counter) {
962             uint _movedTxIndex = _policy.index2txIndex[_counter];
963             _policy.index2txIndex[_policyTxIndex] = _movedTxIndex;
964             _policy.txIndex2index[_movedTxIndex] = _policyTxIndex;
965         }
966 
967         delete _policy.index2txIndex[_counter];
968         delete _policy.txIndex2index[_txIndex];
969         _policy.securesCount = _counter.sub(1);
970 
971         TxDeleted(_key);
972         return OK;
973     }
974 
975     /// @notice Accept transaction
976     /// Can be called only by registered user in GroupsAccessManager
977     ///
978     /// @param _key transaction id
979     ///
980     /// @return code
981     function accept(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
982         if (!isTxExist(_key)) {
983             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
984         }
985 
986         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
987             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
988         }
989 
990         Guard storage _guard = txKey2guard[_key];
991         if (_guard.state != GuardState.InProcess) {
992             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
993         }
994 
995         if (_guard.votes[msg.sender].groupName != bytes32(0) && _guard.votes[msg.sender].accepted) {
996             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
997         }
998 
999         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1000         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1001         uint _groupAcceptedVotesCount = _guard.acceptedCount[_votingGroupName];
1002         if (_groupAcceptedVotesCount == _policy.participatedGroups[_policyGroupIndex].acceptLimit) {
1003             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1004         }
1005 
1006         _guard.votes[msg.sender] = Vote(_votingGroupName, true);
1007         _guard.acceptedCount[_votingGroupName] = _groupAcceptedVotesCount + 1;
1008         uint _alreadyAcceptedCount = _guard.alreadyAccepted + 1;
1009         _guard.alreadyAccepted = _alreadyAcceptedCount;
1010 
1011         ProtectionTxAccepted(_key, msg.sender, _votingGroupName);
1012 
1013         if (_alreadyAcceptedCount == _policy.totalAcceptedLimit) {
1014             _guard.state = GuardState.Confirmed;
1015             ProtectionTxDone(_key);
1016         }
1017 
1018         return OK;
1019     }
1020 
1021     /// @notice Decline transaction
1022     /// Can be called only by registered user in GroupsAccessManager
1023     ///
1024     /// @param _key transaction id
1025     ///
1026     /// @return code
1027     function decline(bytes32 _key, bytes32 _votingGroupName) external returns (uint) {
1028         if (!isTxExist(_key)) {
1029             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1030         }
1031 
1032         if (!GroupsAccessManager(accessManager).isUserInGroup(_votingGroupName, msg.sender)) {
1033             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1034         }
1035 
1036         Guard storage _guard = txKey2guard[_key];
1037         if (_guard.state != GuardState.InProcess) {
1038             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1039         }
1040 
1041         if (_guard.votes[msg.sender].groupName != bytes32(0) && !_guard.votes[msg.sender].accepted) {
1042             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1043         }
1044 
1045         Policy storage _policy = policyId2policy[index2PolicyId[_guard.basePolicyIndex]];
1046         uint _policyGroupIndex = _policy.groupName2index[_votingGroupName];
1047         uint _groupDeclinedVotesCount = _guard.declinedCount[_votingGroupName];
1048         if (_groupDeclinedVotesCount == _policy.participatedGroups[_policyGroupIndex].declineLimit) {
1049             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1050         }
1051 
1052         _guard.votes[msg.sender] = Vote(_votingGroupName, false);
1053         _guard.declinedCount[_votingGroupName] = _groupDeclinedVotesCount + 1;
1054         uint _alreadyDeclinedCount = _guard.alreadyDeclined + 1;
1055         _guard.alreadyDeclined = _alreadyDeclinedCount;
1056 
1057 
1058         ProtectionTxDeclined(_key, msg.sender, _votingGroupName);
1059 
1060         if (_alreadyDeclinedCount == _policy.totalDeclinedLimit) {
1061             _guard.state = GuardState.Decline;
1062             ProtectionTxCancelled(_key);
1063         }
1064 
1065         return OK;
1066     }
1067 
1068     /// @notice Revoke user votes for transaction
1069     /// Can be called only by contract owner
1070     ///
1071     /// @param _key transaction id
1072     /// @param _user target user address
1073     ///
1074     /// @return code
1075     function forceRejectVotes(bytes32 _key, address _user) external onlyContractOwner returns (uint) {
1076         return _revoke(_key, _user);
1077     }
1078 
1079     /// @notice Revoke vote for transaction
1080     /// Can be called only by authorized user
1081     /// @param _key transaction id
1082     /// @return code
1083     function revoke(bytes32 _key) external returns (uint) {
1084         return _revoke(_key, msg.sender);
1085     }
1086 
1087     /// @notice Check transaction status
1088     /// @param _key transaction id
1089     /// @return code
1090     function hasConfirmedRecord(bytes32 _key) public view returns (uint) {
1091         require(_key != bytes32(0));
1092 
1093         if (!isTxExist(_key)) {
1094             return NO_RECORDS_WERE_FOUND;
1095         }
1096 
1097         Guard storage _guard = txKey2guard[_key];
1098         return _guard.state == GuardState.InProcess
1099         ? PENDING_MANAGER_IN_PROCESS
1100         : _guard.state == GuardState.Confirmed
1101         ? OK
1102         : PENDING_MANAGER_REJECTED;
1103     }
1104 
1105 
1106     /// @notice Check policy details
1107     ///
1108     /// @return _groupNames group names included in policies
1109     /// @return _acceptLimits accept limit for group
1110     /// @return _declineLimits decline limit for group
1111     function getPolicyDetails(bytes4 _sig, address _contract)
1112     public
1113     view
1114     returns (
1115         bytes32[] _groupNames,
1116         uint[] _acceptLimits,
1117         uint[] _declineLimits,
1118         uint _totalAcceptedLimit,
1119         uint _totalDeclinedLimit
1120     ) {
1121         require(_sig != bytes4(0));
1122         require(_contract != 0x0);
1123         
1124         bytes32 _policyHash = keccak256(_sig, _contract);
1125         uint _policyIdx = policyId2Index[_policyHash];
1126         if (_policyIdx == 0) {
1127             return;
1128         }
1129 
1130         Policy storage _policy = policyId2policy[_policyHash];
1131         uint _policyGroupsCount = _policy.groupsCount;
1132         _groupNames = new bytes32[](_policyGroupsCount);
1133         _acceptLimits = new uint[](_policyGroupsCount);
1134         _declineLimits = new uint[](_policyGroupsCount);
1135 
1136         for (uint _idx = 0; _idx < _policyGroupsCount; ++_idx) {
1137             Requirements storage _requirements = _policy.participatedGroups[_idx + 1];
1138             _groupNames[_idx] = _requirements.groupName;
1139             _acceptLimits[_idx] = _requirements.acceptLimit;
1140             _declineLimits[_idx] = _requirements.declineLimit;
1141         }
1142 
1143         (_totalAcceptedLimit, _totalDeclinedLimit) = (_policy.totalAcceptedLimit, _policy.totalDeclinedLimit);
1144     }
1145 
1146     /// @notice Check policy include target group
1147     /// @param _policyHash policy hash (sig, contract address)
1148     /// @param _groupName group id
1149     /// @return bool
1150     function isGroupInPolicy(bytes32 _policyHash, bytes32 _groupName) public view returns (bool) {
1151         Policy storage _policy = policyId2policy[_policyHash];
1152         return _policy.groupName2index[_groupName] != 0;
1153     }
1154 
1155     /// @notice Check is policy exist
1156     /// @param _policyHash policy hash (sig, contract address)
1157     /// @return bool
1158     function isPolicyExist(bytes32 _policyHash) public view returns (bool) {
1159         return policyId2Index[_policyHash] != 0;
1160     }
1161 
1162     /// @notice Check is transaction exist
1163     /// @param _key transaction id
1164     /// @return bool
1165     function isTxExist(bytes32 _key) public view returns (bool){
1166         return txKey2index[_key] != 0;
1167     }
1168 
1169     function _updateTxState(Policy storage _policy, Guard storage _guard, uint confirmedAmount, uint declineAmount) private {
1170         if (declineAmount != 0 && _guard.state != GuardState.Decline) {
1171             _guard.state = GuardState.Decline;
1172         } else if (confirmedAmount >= _policy.groupsCount && _guard.state != GuardState.Confirmed) {
1173             _guard.state = GuardState.Confirmed;
1174         } else if (_guard.state != GuardState.InProcess) {
1175             _guard.state = GuardState.InProcess;
1176         }
1177     }
1178 
1179     function _revoke(bytes32 _key, address _user) private returns (uint) {
1180         require(_key != bytes32(0));
1181         require(_user != 0x0);
1182 
1183         if (!isTxExist(_key)) {
1184             return _emitError(PENDING_MANAGER_TX_DOESNT_EXIST);
1185         }
1186 
1187         Guard storage _guard = txKey2guard[_key];
1188         if (_guard.state != GuardState.InProcess) {
1189             return _emitError(PENDING_MANAGER_INVALID_INVOCATION);
1190         }
1191 
1192         bytes32 _votedGroupName = _guard.votes[_user].groupName;
1193         if (_votedGroupName == bytes32(0)) {
1194             return _emitError(PENDING_MANAGER_HASNT_VOTED);
1195         }
1196 
1197         bool isAcceptedVote = _guard.votes[_user].accepted;
1198         if (isAcceptedVote) {
1199             _guard.acceptedCount[_votedGroupName] = _guard.acceptedCount[_votedGroupName].sub(1);
1200             _guard.alreadyAccepted = _guard.alreadyAccepted.sub(1);
1201         } else {
1202             _guard.declinedCount[_votedGroupName] = _guard.declinedCount[_votedGroupName].sub(1);
1203             _guard.alreadyDeclined = _guard.alreadyDeclined.sub(1);
1204 
1205         }
1206 
1207         delete _guard.votes[_user];
1208 
1209         ProtectionTxVoteRevoked(_key, _user, _votedGroupName);
1210         return OK;
1211     }
1212 }
1213 
1214 /// @title MultiSigAdapter
1215 ///
1216 /// Abstract implementation
1217 /// This contract serves as transaction signer
1218 contract MultiSigAdapter is Object {
1219 
1220     uint constant MULTISIG_ADDED = 3;
1221     uint constant NO_RECORDS_WERE_FOUND = 4;
1222 
1223     modifier isAuthorized {
1224         if (msg.sender == contractOwner || msg.sender == getPendingManager()) {
1225             _;
1226         }
1227     }
1228 
1229     /// @notice Get pending address
1230     /// @dev abstract. Needs child implementation
1231     ///
1232     /// @return pending address
1233     function getPendingManager() public view returns (address);
1234 
1235     /// @notice Sign current transaction and add it to transaction pending queue
1236     ///
1237     /// @return code
1238     function _multisig(bytes32 _args, uint _block) internal returns (uint _code) {
1239         bytes32 _txHash = _getKey(_args, _block);
1240         address _manager = getPendingManager();
1241 
1242         _code = PendingManager(_manager).hasConfirmedRecord(_txHash);
1243         if (_code != NO_RECORDS_WERE_FOUND) {
1244             return _code;
1245         }
1246 
1247         if (OK != PendingManager(_manager).addTx(_txHash, msg.sig, address(this))) {
1248             revert();
1249         }
1250 
1251         return MULTISIG_ADDED;
1252     }
1253 
1254     function _isTxExistWithArgs(bytes32 _args, uint _block) internal view returns (bool) {
1255         bytes32 _txHash = _getKey(_args, _block);
1256         address _manager = getPendingManager();
1257         return PendingManager(_manager).isTxExist(_txHash);
1258     }
1259 
1260     function _getKey(bytes32 _args, uint _block) private view returns (bytes32 _txHash) {
1261         _block = _block != 0 ? _block : block.number;
1262         _txHash = keccak256(msg.sig, _args, _block);
1263     }
1264 }
1265 
1266 /// @title ServiceController
1267 ///
1268 /// Base implementation
1269 /// Serves for managing service instances
1270 contract ServiceController is MultiSigAdapter {
1271 
1272     event Error(uint _errorCode);
1273 
1274     uint constant SERVICE_CONTROLLER = 350000;
1275     uint constant SERVICE_CONTROLLER_EMISSION_EXIST = SERVICE_CONTROLLER + 1;
1276     uint constant SERVICE_CONTROLLER_BURNING_MAN_EXIST = SERVICE_CONTROLLER + 2;
1277     uint constant SERVICE_CONTROLLER_ALREADY_INITIALIZED = SERVICE_CONTROLLER + 3;
1278     uint constant SERVICE_CONTROLLER_SERVICE_EXIST = SERVICE_CONTROLLER + 4;
1279 
1280     address public profiterole;
1281     address public treasury;
1282     address public pendingManager;
1283     address public proxy;
1284 
1285     uint public sideServicesCount;
1286     mapping(uint => address) public index2sideService;
1287     mapping(address => uint) public sideService2index;
1288     mapping(address => bool) public sideServices;
1289 
1290     uint public emissionProvidersCount;
1291     mapping(uint => address) public index2emissionProvider;
1292     mapping(address => uint) public emissionProvider2index;
1293     mapping(address => bool) public emissionProviders;
1294 
1295     uint public burningMansCount;
1296     mapping(uint => address) public index2burningMan;
1297     mapping(address => uint) public burningMan2index;
1298     mapping(address => bool) public burningMans;
1299 
1300     /// @notice Default ServiceController's constructor
1301     ///
1302     /// @param _pendingManager pending manager address
1303     /// @param _proxy ERC20 proxy address
1304     /// @param _profiterole profiterole address
1305     /// @param _treasury treasury address
1306     function ServiceController(address _pendingManager, address _proxy, address _profiterole, address _treasury) public {
1307         require(_pendingManager != 0x0);
1308         require(_proxy != 0x0);
1309         require(_profiterole != 0x0);
1310         require(_treasury != 0x0);
1311         pendingManager = _pendingManager;
1312         proxy = _proxy;
1313         profiterole = _profiterole;
1314         treasury = _treasury;
1315     }
1316 
1317     /// @notice Return pending manager address
1318     ///
1319     /// @return code
1320     function getPendingManager() public view returns (address) {
1321         return pendingManager;
1322     }
1323 
1324     /// @notice Add emission provider
1325     ///
1326     /// @param _provider emission provider address
1327     ///
1328     /// @return code
1329     function addEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1330         if (emissionProviders[_provider]) {
1331             return _emitError(SERVICE_CONTROLLER_EMISSION_EXIST);
1332         }
1333         _code = _multisig(keccak256(_provider), _block);
1334         if (OK != _code) {
1335             return _code;
1336         }
1337 
1338         emissionProviders[_provider] = true;
1339         uint _count = emissionProvidersCount + 1;
1340         index2emissionProvider[_count] = _provider;
1341         emissionProvider2index[_provider] = _count;
1342         emissionProvidersCount = _count;
1343 
1344         return OK;
1345     }
1346 
1347     /// @notice Remove emission provider
1348     ///
1349     /// @param _provider emission provider address
1350     ///
1351     /// @return code
1352     function removeEmissionProvider(address _provider, uint _block) public returns (uint _code) {
1353         _code = _multisig(keccak256(_provider), _block);
1354         if (OK != _code) {
1355             return _code;
1356         }
1357 
1358         uint _idx = emissionProvider2index[_provider];
1359         uint _lastIdx = emissionProvidersCount;
1360         if (_idx != 0) {
1361             if (_idx != _lastIdx) {
1362                 address _lastEmissionProvider = index2emissionProvider[_lastIdx];
1363                 index2emissionProvider[_idx] = _lastEmissionProvider;
1364                 emissionProvider2index[_lastEmissionProvider] = _idx;
1365             }
1366 
1367             delete emissionProvider2index[_provider];
1368             delete index2emissionProvider[_lastIdx];
1369             delete emissionProviders[_provider];
1370             emissionProvidersCount = _lastIdx - 1;
1371         }
1372 
1373         return OK;
1374     }
1375 
1376     /// @notice Add burning man
1377     ///
1378     /// @param _burningMan burning man address
1379     ///
1380     /// @return code
1381     function addBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1382         if (burningMans[_burningMan]) {
1383             return _emitError(SERVICE_CONTROLLER_BURNING_MAN_EXIST);
1384         }
1385 
1386         _code = _multisig(keccak256(_burningMan), _block);
1387         if (OK != _code) {
1388             return _code;
1389         }
1390 
1391         burningMans[_burningMan] = true;
1392         uint _count = burningMansCount + 1;
1393         index2burningMan[_count] = _burningMan;
1394         burningMan2index[_burningMan] = _count;
1395         burningMansCount = _count;
1396 
1397         return OK;
1398     }
1399 
1400     /// @notice Remove burning man
1401     ///
1402     /// @param _burningMan burning man address
1403     ///
1404     /// @return code
1405     function removeBurningMan(address _burningMan, uint _block) public returns (uint _code) {
1406         _code = _multisig(keccak256(_burningMan), _block);
1407         if (OK != _code) {
1408             return _code;
1409         }
1410 
1411         uint _idx = burningMan2index[_burningMan];
1412         uint _lastIdx = burningMansCount;
1413         if (_idx != 0) {
1414             if (_idx != _lastIdx) {
1415                 address _lastBurningMan = index2burningMan[_lastIdx];
1416                 index2burningMan[_idx] = _lastBurningMan;
1417                 burningMan2index[_lastBurningMan] = _idx;
1418             }
1419             
1420             delete burningMan2index[_burningMan];
1421             delete index2burningMan[_lastIdx];
1422             delete burningMans[_burningMan];
1423             burningMansCount = _lastIdx - 1;
1424         }
1425 
1426         return OK;
1427     }
1428 
1429     /// @notice Update a profiterole address
1430     ///
1431     /// @param _profiterole profiterole address
1432     ///
1433     /// @return result code of an operation
1434     function updateProfiterole(address _profiterole, uint _block) public returns (uint _code) {
1435         _code = _multisig(keccak256(_profiterole), _block);
1436         if (OK != _code) {
1437             return _code;
1438         }
1439 
1440         profiterole = _profiterole;
1441         return OK;
1442     }
1443 
1444     /// @notice Update a treasury address
1445     ///
1446     /// @param _treasury treasury address
1447     ///
1448     /// @return result code of an operation
1449     function updateTreasury(address _treasury, uint _block) public returns (uint _code) {
1450         _code = _multisig(keccak256(_treasury), _block);
1451         if (OK != _code) {
1452             return _code;
1453         }
1454 
1455         treasury = _treasury;
1456         return OK;
1457     }
1458 
1459     /// @notice Update pending manager address
1460     ///
1461     /// @param _pendingManager pending manager address
1462     ///
1463     /// @return result code of an operation
1464     function updatePendingManager(address _pendingManager, uint _block) public returns (uint _code) {
1465         _code = _multisig(keccak256(_pendingManager), _block);
1466         if (OK != _code) {
1467             return _code;
1468         }
1469 
1470         pendingManager = _pendingManager;
1471         return OK;
1472     }
1473 
1474     function addSideService(address _service, uint _block) public returns (uint _code) {
1475         if (sideServices[_service]) {
1476             return SERVICE_CONTROLLER_SERVICE_EXIST;
1477         }
1478         _code = _multisig(keccak256(_service), _block);
1479         if (OK != _code) {
1480             return _code;
1481         }
1482 
1483         sideServices[_service] = true;
1484         uint _count = sideServicesCount + 1;
1485         index2sideService[_count] = _service;
1486         sideService2index[_service] = _count;
1487         sideServicesCount = _count;
1488 
1489         return OK;
1490     }
1491 
1492     function removeSideService(address _service, uint _block) public returns (uint _code) {
1493         _code = _multisig(keccak256(_service), _block);
1494         if (OK != _code) {
1495             return _code;
1496         }
1497 
1498         uint _idx = sideService2index[_service];
1499         uint _lastIdx = sideServicesCount;
1500         if (_idx != 0) {
1501             if (_idx != _lastIdx) {
1502                 address _lastSideService = index2sideService[_lastIdx];
1503                 index2sideService[_idx] = _lastSideService;
1504                 sideService2index[_lastSideService] = _idx;
1505             }
1506             
1507             delete sideService2index[_service];
1508             delete index2sideService[_lastIdx];
1509             delete sideServices[_service];
1510             sideServicesCount = _lastIdx - 1;
1511         }
1512 
1513         return OK;
1514     }
1515 
1516     function getEmissionProviders()
1517     public
1518     view
1519     returns (address[] _emissionProviders)
1520     {
1521         _emissionProviders = new address[](emissionProvidersCount);
1522         for (uint _idx = 0; _idx < _emissionProviders.length; ++_idx) {
1523             _emissionProviders[_idx] = index2emissionProvider[_idx + 1];
1524         }
1525     }
1526 
1527     function getBurningMans()
1528     public
1529     view
1530     returns (address[] _burningMans)
1531     {
1532         _burningMans = new address[](burningMansCount);
1533         for (uint _idx = 0; _idx < _burningMans.length; ++_idx) {
1534             _burningMans[_idx] = index2burningMan[_idx + 1];
1535         }
1536     }
1537 
1538     function getSideServices()
1539     public
1540     view
1541     returns (address[] _sideServices)
1542     {
1543         _sideServices = new address[](sideServicesCount);
1544         for (uint _idx = 0; _idx < _sideServices.length; ++_idx) {
1545             _sideServices[_idx] = index2sideService[_idx + 1];
1546         }
1547     }
1548 
1549     /// @notice Check target address is service
1550     ///
1551     /// @param _address target address
1552     ///
1553     /// @return `true` when an address is a service, `false` otherwise
1554     function isService(address _address) public view returns (bool check) {
1555         return _address == profiterole ||
1556             _address == treasury || 
1557             _address == proxy || 
1558             _address == pendingManager || 
1559             emissionProviders[_address] || 
1560             burningMans[_address] ||
1561             sideServices[_address];
1562     }
1563 
1564     function _emitError(uint _errorCode) internal returns (uint) {
1565         Error(_errorCode);
1566         return _errorCode;
1567     }
1568 }
1569 
1570 contract OracleMethodAdapter is Object {
1571 
1572     event OracleAdded(bytes4 _sig, address _oracle);
1573     event OracleRemoved(bytes4 _sig, address _oracle);
1574 
1575     mapping(bytes4 => mapping(address => bool)) public oracles;
1576 
1577     /// @dev Allow access only for oracle
1578     modifier onlyOracle {
1579         if (oracles[msg.sig][msg.sender]) {
1580             _;
1581         }
1582     }
1583 
1584     modifier onlyOracleOrOwner {
1585         if (oracles[msg.sig][msg.sender] || msg.sender == contractOwner) {
1586             _;
1587         }
1588     }
1589 
1590     function addOracles(
1591         bytes4[] _signatures, 
1592         address[] _oracles
1593     ) 
1594     onlyContractOwner 
1595     external 
1596     returns (uint) 
1597     {
1598         require(_signatures.length == _oracles.length);
1599         bytes4 _sig;
1600         address _oracle;
1601         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
1602             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
1603             if (_oracle != 0x0 
1604                 && _sig != bytes4(0) 
1605                 && !oracles[_sig][_oracle]
1606             ) {
1607                 oracles[_sig][_oracle] = true;
1608                 _emitOracleAdded(_sig, _oracle);
1609             }
1610         }
1611         return OK;
1612     }
1613 
1614     function removeOracles(
1615         bytes4[] _signatures, 
1616         address[] _oracles
1617     ) 
1618     onlyContractOwner 
1619     external 
1620     returns (uint) 
1621     {
1622         require(_signatures.length == _oracles.length);
1623         bytes4 _sig;
1624         address _oracle;
1625         for (uint _idx = 0; _idx < _signatures.length; ++_idx) {
1626             (_sig, _oracle) = (_signatures[_idx], _oracles[_idx]);
1627             if (_oracle != 0x0 
1628                 && _sig != bytes4(0) 
1629                 && oracles[_sig][_oracle]
1630             ) {
1631                 delete oracles[_sig][_oracle];
1632                 _emitOracleRemoved(_sig, _oracle);
1633             }
1634         }
1635         return OK;
1636     }
1637 
1638     function _emitOracleAdded(bytes4 _sig, address _oracle) internal {
1639         OracleAdded(_sig, _oracle);
1640     }
1641 
1642     function _emitOracleRemoved(bytes4 _sig, address _oracle) internal {
1643         OracleRemoved(_sig, _oracle);
1644     }
1645 
1646 }
1647 
1648 
1649 
1650 contract Platform {
1651     mapping(bytes32 => address) public proxies;
1652     function name(bytes32 _symbol) public view returns (string);
1653     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
1654     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
1655     function totalSupply(bytes32 _symbol) public view returns (uint);
1656     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
1657     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
1658     function baseUnit(bytes32 _symbol) public view returns (uint8);
1659     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
1660     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
1661     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
1662     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
1663     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
1664     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
1665     function isReissuable(bytes32 _symbol) public view returns (bool);
1666     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
1667 }
1668 
1669 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
1670 
1671     using SafeMath for uint;
1672 
1673     /**
1674      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
1675      */
1676     event UpgradeProposal(address newVersion);
1677 
1678     // Current asset implementation contract address.
1679     address latestVersion;
1680 
1681     // Assigned platform, immutable.
1682     Platform public platform;
1683 
1684     // Assigned symbol, immutable.
1685     bytes32 public smbl;
1686 
1687     // Assigned name, immutable.
1688     string public name;
1689 
1690     /**
1691      * Only platform is allowed to call.
1692      */
1693     modifier onlyPlatform() {
1694         if (msg.sender == address(platform)) {
1695             _;
1696         }
1697     }
1698 
1699     /**
1700      * Only current asset owner is allowed to call.
1701      */
1702     modifier onlyAssetOwner() {
1703         if (platform.isOwner(msg.sender, smbl)) {
1704             _;
1705         }
1706     }
1707 
1708     /**
1709      * Only asset implementation contract assigned to sender is allowed to call.
1710      */
1711     modifier onlyAccess(address _sender) {
1712         if (getLatestVersion() == msg.sender) {
1713             _;
1714         }
1715     }
1716 
1717     /**
1718      * Resolves asset implementation contract for the caller and forwards there transaction data,
1719      * along with the value. This allows for proxy interface growth.
1720      */
1721     function() public payable {
1722         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
1723     }
1724 
1725     /**
1726      * Sets platform address, assigns symbol and name.
1727      *
1728      * Can be set only once.
1729      *
1730      * @param _platform platform contract address.
1731      * @param _symbol assigned symbol.
1732      * @param _name assigned name.
1733      *
1734      * @return success.
1735      */
1736     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
1737         if (address(platform) != 0x0) {
1738             return false;
1739         }
1740         platform = _platform;
1741         symbol = _symbol;
1742         smbl = stringToBytes32(_symbol);
1743         name = _name;
1744         return true;
1745     }
1746 
1747     /**
1748      * Returns asset total supply.
1749      *
1750      * @return asset total supply.
1751      */
1752     function totalSupply() public view returns (uint) {
1753         return platform.totalSupply(smbl);
1754     }
1755 
1756     /**
1757      * Returns asset balance for a particular holder.
1758      *
1759      * @param _owner holder address.
1760      *
1761      * @return holder balance.
1762      */
1763     function balanceOf(address _owner) public view returns (uint) {
1764         return platform.balanceOf(_owner, smbl);
1765     }
1766 
1767     /**
1768      * Returns asset allowance from one holder to another.
1769      *
1770      * @param _from holder that allowed spending.
1771      * @param _spender holder that is allowed to spend.
1772      *
1773      * @return holder to spender allowance.
1774      */
1775     function allowance(address _from, address _spender) public view returns (uint) {
1776         return platform.allowance(_from, _spender, smbl);
1777     }
1778 
1779     /**
1780      * Returns asset decimals.
1781      *
1782      * @return asset decimals.
1783      */
1784     function decimals() public view returns (uint8) {
1785         return platform.baseUnit(smbl);
1786     }
1787 
1788     /**
1789      * Transfers asset balance from the caller to specified receiver.
1790      *
1791      * @param _to holder address to give to.
1792      * @param _value amount to transfer.
1793      *
1794      * @return success.
1795      */
1796     function transfer(address _to, uint _value) public returns (bool) {
1797         if (_to != 0x0) {
1798             return _transferWithReference(_to, _value, "");
1799         }
1800         else {
1801             return false;
1802         }
1803     }
1804 
1805     /**
1806      * Transfers asset balance from the caller to specified receiver adding specified comment.
1807      *
1808      * @param _to holder address to give to.
1809      * @param _value amount to transfer.
1810      * @param _reference transfer comment to be included in a platform's Transfer event.
1811      *
1812      * @return success.
1813      */
1814     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
1815         if (_to != 0x0) {
1816             return _transferWithReference(_to, _value, _reference);
1817         }
1818         else {
1819             return false;
1820         }
1821     }
1822 
1823     /**
1824      * Performs transfer call on the platform by the name of specified sender.
1825      *
1826      * Can only be called by asset implementation contract assigned to sender.
1827      *
1828      * @param _to holder address to give to.
1829      * @param _value amount to transfer.
1830      * @param _reference transfer comment to be included in a platform's Transfer event.
1831      * @param _sender initial caller.
1832      *
1833      * @return success.
1834      */
1835     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
1836         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
1837     }
1838 
1839     /**
1840      * Prforms allowance transfer of asset balance between holders.
1841      *
1842      * @param _from holder address to take from.
1843      * @param _to holder address to give to.
1844      * @param _value amount to transfer.
1845      *
1846      * @return success.
1847      */
1848     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
1849         if (_to != 0x0) {
1850             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
1851         }
1852         else {
1853             return false;
1854         }
1855     }
1856 
1857     /**
1858      * Performs allowance transfer call on the platform by the name of specified sender.
1859      *
1860      * Can only be called by asset implementation contract assigned to sender.
1861      *
1862      * @param _from holder address to take from.
1863      * @param _to holder address to give to.
1864      * @param _value amount to transfer.
1865      * @param _reference transfer comment to be included in a platform's Transfer event.
1866      * @param _sender initial caller.
1867      *
1868      * @return success.
1869      */
1870     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
1871         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
1872     }
1873 
1874     /**
1875      * Sets asset spending allowance for a specified spender.
1876      *
1877      * @param _spender holder address to set allowance to.
1878      * @param _value amount to allow.
1879      *
1880      * @return success.
1881      */
1882     function approve(address _spender, uint _value) public returns (bool) {
1883         if (_spender != 0x0) {
1884             return _getAsset().__approve(_spender, _value, msg.sender);
1885         }
1886         else {
1887             return false;
1888         }
1889     }
1890 
1891     /**
1892      * Performs allowance setting call on the platform by the name of specified sender.
1893      *
1894      * Can only be called by asset implementation contract assigned to sender.
1895      *
1896      * @param _spender holder address to set allowance to.
1897      * @param _value amount to allow.
1898      * @param _sender initial caller.
1899      *
1900      * @return success.
1901      */
1902     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
1903         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
1904     }
1905 
1906     /**
1907      * Emits ERC20 Transfer event on this contract.
1908      *
1909      * Can only be, and, called by assigned platform when asset transfer happens.
1910      */
1911     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
1912         Transfer(_from, _to, _value);
1913     }
1914 
1915     /**
1916      * Emits ERC20 Approval event on this contract.
1917      *
1918      * Can only be, and, called by assigned platform when asset allowance set happens.
1919      */
1920     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
1921         Approval(_from, _spender, _value);
1922     }
1923 
1924     /**
1925      * Returns current asset implementation contract address.
1926      *
1927      * @return asset implementation contract address.
1928      */
1929     function getLatestVersion() public view returns (address) {
1930         return latestVersion;
1931     }
1932 
1933     /**
1934      * Propose next asset implementation contract address.
1935      *
1936      * Can only be called by current asset owner.
1937      *
1938      * Note: freeze-time should not be applied for the initial setup.
1939      *
1940      * @param _newVersion asset implementation contract address.
1941      *
1942      * @return success.
1943      */
1944     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
1945         // New version address should be other than 0x0.
1946         if (_newVersion == 0x0) {
1947             return false;
1948         }
1949         
1950         latestVersion = _newVersion;
1951 
1952         UpgradeProposal(_newVersion); 
1953         return true;
1954     }
1955 
1956     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
1957         return true;
1958     }
1959 
1960     /**
1961      * Returns asset implementation contract for current caller.
1962      *
1963      * @return asset implementation contract.
1964      */
1965     function _getAsset() internal view returns (ATxAssetInterface) {
1966         return ATxAssetInterface(getLatestVersion());
1967     }
1968 
1969     /**
1970      * Resolves asset implementation contract for the caller and forwards there arguments along with
1971      * the caller address.
1972      *
1973      * @return success.
1974      */
1975     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
1976         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
1977     }
1978 
1979     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
1980         assembly {
1981             result := mload(add(source, 32))
1982         }
1983     }
1984 }
1985 
1986 contract DataControllerEmitter {
1987 
1988     event CountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount);
1989     event CountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount);
1990 
1991     event HolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode);
1992     event HolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
1993     event HolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex);
1994     event HolderOperationalChanged(bytes32 _externalHolderId, bool _operational);
1995 
1996     event DayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
1997     event MonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to);
1998 
1999     event Error(uint _errorCode);
2000 
2001     function _emitHolderAddressAdded(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
2002         HolderAddressAdded(_externalHolderId, _holderPrototype, _accessIndex);
2003     }
2004 
2005     function _emitHolderAddressRemoved(bytes32 _externalHolderId, address _holderPrototype, uint _accessIndex) internal {
2006         HolderAddressRemoved(_externalHolderId, _holderPrototype, _accessIndex);
2007     }
2008 
2009     function _emitHolderRegistered(bytes32 _externalHolderId, uint _accessIndex, uint _countryCode) internal {
2010         HolderRegistered(_externalHolderId, _accessIndex, _countryCode);
2011     }
2012 
2013     function _emitHolderOperationalChanged(bytes32 _externalHolderId, bool _operational) internal {
2014         HolderOperationalChanged(_externalHolderId, _operational);
2015     }
2016 
2017     function _emitCountryCodeAdded(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
2018         CountryCodeAdded(_countryCode, _countryId, _maxHolderCount);
2019     }
2020 
2021     function _emitCountryCodeChanged(uint _countryCode, uint _countryId, uint _maxHolderCount) internal {
2022         CountryCodeChanged(_countryCode, _countryId, _maxHolderCount);
2023     }
2024 
2025     function _emitDayLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
2026         DayLimitChanged(_externalHolderId, _from, _to);
2027     }
2028 
2029     function _emitMonthLimitChanged(bytes32 _externalHolderId, uint _from, uint _to) internal {
2030         MonthLimitChanged(_externalHolderId, _from, _to);
2031     }
2032 
2033     function _emitError(uint _errorCode) internal returns (uint) {
2034         Error(_errorCode);
2035         return _errorCode;
2036     }
2037 }
2038 
2039 /// @title Provides possibility manage holders? country limits and limits for holders.
2040 contract DataController is OracleMethodAdapter, DataControllerEmitter {
2041 
2042     /* CONSTANTS */
2043 
2044     uint constant DATA_CONTROLLER = 109000;
2045     uint constant DATA_CONTROLLER_ERROR = DATA_CONTROLLER + 1;
2046     uint constant DATA_CONTROLLER_CURRENT_WRONG_LIMIT = DATA_CONTROLLER + 2;
2047     uint constant DATA_CONTROLLER_WRONG_ALLOWANCE = DATA_CONTROLLER + 3;
2048     uint constant DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS = DATA_CONTROLLER + 4;
2049 
2050     uint constant MAX_TOKEN_HOLDER_NUMBER = 2 ** 256 - 1;
2051 
2052     using SafeMath for uint;
2053 
2054     /* STRUCTS */
2055 
2056     /// @title HoldersData couldn't be public because of internal structures, so needed to provide getters for different parts of _holderData
2057     struct HoldersData {
2058         uint countryCode;
2059         uint sendLimPerDay;
2060         uint sendLimPerMonth;
2061         bool operational;
2062         bytes text;
2063         uint holderAddressCount;
2064         mapping(uint => address) index2Address;
2065         mapping(address => uint) address2Index;
2066     }
2067 
2068     struct CountryLimits {
2069         uint countryCode;
2070         uint maxTokenHolderNumber;
2071         uint currentTokenHolderNumber;
2072     }
2073 
2074     /* FIELDS */
2075 
2076     address public withdrawal;
2077     address assetAddress;
2078     address public serviceController;
2079 
2080     mapping(address => uint) public allowance;
2081 
2082     // Iterable mapping pattern is used for holders.
2083     /// @dev This is an access address mapping. Many addresses may have access to a single holder.
2084     uint public holdersCount;
2085     mapping(uint => HoldersData) holders;
2086     mapping(address => bytes32) holderAddress2Id;
2087     mapping(bytes32 => uint) public holderIndex;
2088 
2089     // This is an access address mapping. Many addresses may have access to a single holder.
2090     uint public countriesCount;
2091     mapping(uint => CountryLimits) countryLimitsList;
2092     mapping(uint => uint) countryIndex;
2093 
2094     /* MODIFIERS */
2095 
2096     modifier onlyWithdrawal {
2097         if (msg.sender != withdrawal) {
2098             revert();
2099         }
2100         _;
2101     }
2102 
2103     modifier onlyAsset {
2104         if (msg.sender == _getATxToken().getLatestVersion()) {
2105             _;
2106         }
2107     }
2108 
2109     modifier onlyContractOwner {
2110         if (msg.sender == contractOwner) {
2111             _;
2112         }
2113     }
2114 
2115     /// @notice Constructor for _holderData controller.
2116     /// @param _serviceController service controller
2117     function DataController(address _serviceController) public {
2118         require(_serviceController != 0x0);
2119 
2120         serviceController = _serviceController;
2121     }
2122 
2123     function() payable public {
2124         revert();
2125     }
2126 
2127     function setWithdraw(address _withdrawal) onlyContractOwner external returns (uint) {
2128         require(_withdrawal != 0x0);
2129         withdrawal = _withdrawal;
2130         return OK;
2131     }
2132 
2133     function setServiceController(address _serviceController) 
2134     onlyContractOwner
2135     external
2136     returns (uint)
2137     {
2138         require(_serviceController != 0x0);
2139         
2140         serviceController = _serviceController;
2141         return OK;
2142     }
2143 
2144 
2145     function getPendingManager() public view returns (address) {
2146         return ServiceController(serviceController).getPendingManager();
2147     }
2148 
2149     function getHolderInfo(bytes32 _externalHolderId) public view returns (
2150         uint _countryCode,
2151         uint _limPerDay,
2152         uint _limPerMonth,
2153         bool _operational,
2154         bytes _text
2155     ) {
2156         HoldersData storage _data = holders[holderIndex[_externalHolderId]];
2157         return (_data.countryCode, _data.sendLimPerDay, _data.sendLimPerMonth, _data.operational, _data.text);
2158     }
2159 
2160     function getHolderAddresses(bytes32 _externalHolderId) public view returns (address[] _addresses) {
2161         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2162         uint _addressesCount = _holderData.holderAddressCount;
2163         _addresses = new address[](_addressesCount);
2164         for (uint _holderAddressIdx = 0; _holderAddressIdx < _addressesCount; ++_holderAddressIdx) {
2165             _addresses[_holderAddressIdx] = _holderData.index2Address[_holderAddressIdx + 1];
2166         }
2167     }
2168 
2169     function getHolderCountryCode(bytes32 _externalHolderId) public view returns (uint) {
2170         return holders[holderIndex[_externalHolderId]].countryCode;
2171     }
2172 
2173     function getHolderExternalIdByAddress(address _address) public view returns (bytes32) {
2174         return holderAddress2Id[_address];
2175     }
2176 
2177     /// @notice Checks user is holder.
2178     /// @param _address checking address.
2179     /// @return `true` if _address is registered holder, `false` otherwise.
2180     function isRegisteredAddress(address _address) public view returns (bool) {
2181         return holderIndex[holderAddress2Id[_address]] != 0;
2182     }
2183 
2184     function isHolderOwnAddress(
2185         bytes32 _externalHolderId, 
2186         address _address
2187     ) 
2188     public 
2189     view 
2190     returns (bool) 
2191     {
2192         uint _holderIndex = holderIndex[_externalHolderId];
2193         if (_holderIndex == 0) {
2194             return false;
2195         }
2196         return holders[_holderIndex].address2Index[_address] != 0;
2197     }
2198 
2199     function getCountryInfo(uint _countryCode) 
2200     public 
2201     view 
2202     returns (
2203         uint _maxHolderNumber, 
2204         uint _currentHolderCount
2205     ) {
2206         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2207         return (_data.maxTokenHolderNumber, _data.currentTokenHolderNumber);
2208     }
2209 
2210     function getCountryLimit(uint _countryCode) public view returns (uint limit) {
2211         uint _index = countryIndex[_countryCode];
2212         require(_index != 0);
2213         return countryLimitsList[_index].maxTokenHolderNumber;
2214     }
2215 
2216     function addCountryCode(uint _countryCode) onlyContractOwner public returns (uint) {
2217         var (,_created) = _createCountryId(_countryCode);
2218         if (!_created) {
2219             return _emitError(DATA_CONTROLLER_COUNTRY_CODE_ALREADY_EXISTS);
2220         }
2221         return OK;
2222     }
2223 
2224     /// @notice Returns holder id for the specified address, creates it if needed.
2225     /// @param _externalHolderId holder address.
2226     /// @param _countryCode country code.
2227     /// @return error code.
2228     function registerHolder(
2229         bytes32 _externalHolderId, 
2230         address _holderAddress, 
2231         uint _countryCode
2232     ) 
2233     onlyOracleOrOwner 
2234     external 
2235     returns (uint) 
2236     {
2237         require(_holderAddress != 0x0);
2238         require(holderIndex[_externalHolderId] == 0);
2239         uint _holderIndex = holderIndex[holderAddress2Id[_holderAddress]];
2240         require(_holderIndex == 0);
2241 
2242         _createCountryId(_countryCode);
2243         _holderIndex = holdersCount.add(1);
2244         holdersCount = _holderIndex;
2245 
2246         HoldersData storage _holderData = holders[_holderIndex];
2247         _holderData.countryCode = _countryCode;
2248         _holderData.operational = true;
2249         _holderData.sendLimPerDay = MAX_TOKEN_HOLDER_NUMBER;
2250         _holderData.sendLimPerMonth = MAX_TOKEN_HOLDER_NUMBER;
2251         uint _firstAddressIndex = 1;
2252         _holderData.holderAddressCount = _firstAddressIndex;
2253         _holderData.address2Index[_holderAddress] = _firstAddressIndex;
2254         _holderData.index2Address[_firstAddressIndex] = _holderAddress;
2255         holderIndex[_externalHolderId] = _holderIndex;
2256         holderAddress2Id[_holderAddress] = _externalHolderId;
2257 
2258         _emitHolderRegistered(_externalHolderId, _holderIndex, _countryCode);
2259         return OK;
2260     }
2261 
2262     /// @notice Adds new address equivalent to holder.
2263     /// @param _externalHolderId external holder identifier.
2264     /// @param _newAddress adding address.
2265     /// @return error code.
2266     function addHolderAddress(
2267         bytes32 _externalHolderId, 
2268         address _newAddress
2269     ) 
2270     onlyOracleOrOwner 
2271     external 
2272     returns (uint) 
2273     {
2274         uint _holderIndex = holderIndex[_externalHolderId];
2275         require(_holderIndex != 0);
2276 
2277         uint _newAddressId = holderIndex[holderAddress2Id[_newAddress]];
2278         require(_newAddressId == 0);
2279 
2280         HoldersData storage _holderData = holders[_holderIndex];
2281 
2282         if (_holderData.address2Index[_newAddress] == 0) {
2283             _holderData.holderAddressCount = _holderData.holderAddressCount.add(1);
2284             _holderData.address2Index[_newAddress] = _holderData.holderAddressCount;
2285             _holderData.index2Address[_holderData.holderAddressCount] = _newAddress;
2286         }
2287 
2288         holderAddress2Id[_newAddress] = _externalHolderId;
2289 
2290         _emitHolderAddressAdded(_externalHolderId, _newAddress, _holderIndex);
2291         return OK;
2292     }
2293 
2294     /// @notice Remove an address owned by a holder.
2295     /// @param _externalHolderId external holder identifier.
2296     /// @param _address removing address.
2297     /// @return error code.
2298     function removeHolderAddress(
2299         bytes32 _externalHolderId, 
2300         address _address
2301     ) 
2302     onlyOracleOrOwner 
2303     external 
2304     returns (uint) 
2305     {
2306         uint _holderIndex = holderIndex[_externalHolderId];
2307         require(_holderIndex != 0);
2308 
2309         HoldersData storage _holderData = holders[_holderIndex];
2310 
2311         uint _tempIndex = _holderData.address2Index[_address];
2312         require(_tempIndex != 0);
2313 
2314         address _lastAddress = _holderData.index2Address[_holderData.holderAddressCount];
2315         _holderData.address2Index[_lastAddress] = _tempIndex;
2316         _holderData.index2Address[_tempIndex] = _lastAddress;
2317         delete _holderData.address2Index[_address];
2318         _holderData.holderAddressCount = _holderData.holderAddressCount.sub(1);
2319 
2320         delete holderAddress2Id[_address];
2321 
2322         _emitHolderAddressRemoved(_externalHolderId, _address, _holderIndex);
2323         return OK;
2324     }
2325 
2326     /// @notice Change operational status for holder.
2327     /// Can be accessed by contract owner or oracle only.
2328     ///
2329     /// @param _externalHolderId external holder identifier.
2330     /// @param _operational operational status.
2331     ///
2332     /// @return result code.
2333     function changeOperational(
2334         bytes32 _externalHolderId, 
2335         bool _operational
2336     ) 
2337     onlyOracleOrOwner 
2338     external 
2339     returns (uint) 
2340     {
2341         uint _holderIndex = holderIndex[_externalHolderId];
2342         require(_holderIndex != 0);
2343 
2344         holders[_holderIndex].operational = _operational;
2345 
2346         _emitHolderOperationalChanged(_externalHolderId, _operational);
2347         return OK;
2348     }
2349 
2350     /// @notice Changes text for holder.
2351     /// Can be accessed by contract owner or oracle only.
2352     ///
2353     /// @param _externalHolderId external holder identifier.
2354     /// @param _text changing text.
2355     ///
2356     /// @return result code.
2357     function updateTextForHolder(
2358         bytes32 _externalHolderId, 
2359         bytes _text
2360     ) 
2361     onlyOracleOrOwner 
2362     external 
2363     returns (uint) 
2364     {
2365         uint _holderIndex = holderIndex[_externalHolderId];
2366         require(_holderIndex != 0);
2367 
2368         holders[_holderIndex].text = _text;
2369         return OK;
2370     }
2371 
2372     /// @notice Updates limit per day for holder.
2373     ///
2374     /// Can be accessed by contract owner only.
2375     ///
2376     /// @param _externalHolderId external holder identifier.
2377     /// @param _limit limit value.
2378     ///
2379     /// @return result code.
2380     function updateLimitPerDay(
2381         bytes32 _externalHolderId, 
2382         uint _limit
2383     ) 
2384     onlyOracleOrOwner 
2385     external 
2386     returns (uint) 
2387     {
2388         uint _holderIndex = holderIndex[_externalHolderId];
2389         require(_holderIndex != 0);
2390 
2391         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2392         holders[_holderIndex].sendLimPerDay = _limit;
2393 
2394         _emitDayLimitChanged(_externalHolderId, _currentLimit, _limit);
2395         return OK;
2396     }
2397 
2398     /// @notice Updates limit per month for holder.
2399     /// Can be accessed by contract owner or oracle only.
2400     ///
2401     /// @param _externalHolderId external holder identifier.
2402     /// @param _limit limit value.
2403     ///
2404     /// @return result code.
2405     function updateLimitPerMonth(
2406         bytes32 _externalHolderId, 
2407         uint _limit
2408     ) 
2409     onlyOracleOrOwner 
2410     external 
2411     returns (uint) 
2412     {
2413         uint _holderIndex = holderIndex[_externalHolderId];
2414         require(_holderIndex != 0);
2415 
2416         uint _currentLimit = holders[_holderIndex].sendLimPerDay;
2417         holders[_holderIndex].sendLimPerMonth = _limit;
2418 
2419         _emitMonthLimitChanged(_externalHolderId, _currentLimit, _limit);
2420         return OK;
2421     }
2422 
2423     /// @notice Change country limits.
2424     /// Can be accessed by contract owner or oracle only.
2425     ///
2426     /// @param _countryCode country code.
2427     /// @param _limit limit value.
2428     ///
2429     /// @return result code.
2430     function changeCountryLimit(
2431         uint _countryCode, 
2432         uint _limit
2433     ) 
2434     onlyOracleOrOwner 
2435     external 
2436     returns (uint) 
2437     {
2438         uint _countryIndex = countryIndex[_countryCode];
2439         require(_countryIndex != 0);
2440 
2441         uint _currentTokenHolderNumber = countryLimitsList[_countryIndex].currentTokenHolderNumber;
2442         if (_currentTokenHolderNumber > _limit) {
2443             return _emitError(DATA_CONTROLLER_CURRENT_WRONG_LIMIT);
2444         }
2445 
2446         countryLimitsList[_countryIndex].maxTokenHolderNumber = _limit;
2447         
2448         _emitCountryCodeChanged(_countryIndex, _countryCode, _limit);
2449         return OK;
2450     }
2451 
2452     function withdrawFrom(
2453         address _holderAddress, 
2454         uint _value
2455     ) 
2456     onlyAsset 
2457     public 
2458     returns (uint) 
2459     {
2460         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2461         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2462         _holderData.sendLimPerDay = _holderData.sendLimPerDay.sub(_value);
2463         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.sub(_value);
2464         return OK;
2465     }
2466 
2467     function depositTo(
2468         address _holderAddress, 
2469         uint _value
2470     ) 
2471     onlyAsset 
2472     public 
2473     returns (uint) 
2474     {
2475         bytes32 _externalHolderId = holderAddress2Id[_holderAddress];
2476         HoldersData storage _holderData = holders[holderIndex[_externalHolderId]];
2477         _holderData.sendLimPerDay = _holderData.sendLimPerDay.add(_value);
2478         _holderData.sendLimPerMonth = _holderData.sendLimPerMonth.add(_value);
2479         return OK;
2480     }
2481 
2482     function updateCountryHoldersCount(
2483         uint _countryCode, 
2484         uint _updatedHolderCount
2485     ) 
2486     public 
2487     onlyAsset 
2488     returns (uint) 
2489     {
2490         CountryLimits storage _data = countryLimitsList[countryIndex[_countryCode]];
2491         assert(_data.maxTokenHolderNumber >= _updatedHolderCount);
2492         _data.currentTokenHolderNumber = _updatedHolderCount;
2493         return OK;
2494     }
2495 
2496     function changeAllowance(address _from, uint _value) public onlyWithdrawal returns (uint) {
2497         ATxAssetProxy token = _getATxToken();
2498         if (token.balanceOf(_from) < _value) {
2499             return _emitError(DATA_CONTROLLER_WRONG_ALLOWANCE);
2500         }
2501         allowance[_from] = _value;
2502         return OK;
2503     }
2504 
2505     function _createCountryId(uint _countryCode) internal returns (uint, bool _created) {
2506         uint countryId = countryIndex[_countryCode];
2507         if (countryId == 0) {
2508             uint _countriesCount = countriesCount;
2509             countryId = _countriesCount.add(1);
2510             countriesCount = countryId;
2511             CountryLimits storage limits = countryLimitsList[countryId];
2512             limits.countryCode = _countryCode;
2513             limits.maxTokenHolderNumber = MAX_TOKEN_HOLDER_NUMBER;
2514 
2515             countryIndex[_countryCode] = countryId;
2516             _emitCountryCodeAdded(countryIndex[_countryCode], _countryCode, MAX_TOKEN_HOLDER_NUMBER);
2517 
2518             _created = true;
2519         }
2520 
2521         return (countryId, _created);
2522     }
2523 
2524     function _getATxToken() private view returns (ATxAssetProxy) {
2525         ServiceController _serviceController = ServiceController(serviceController);
2526         return ATxAssetProxy(_serviceController.proxy());
2527     }
2528 }
2529 
2530 /// @title Contract that will work with ERC223 tokens.
2531 interface ERC223ReceivingInterface {
2532 
2533 	/// @notice Standard ERC223 function that will handle incoming token transfers.
2534 	/// @param _from  Token sender address.
2535 	/// @param _value Amount of tokens.
2536 	/// @param _data  Transaction metadata.
2537     function tokenFallback(address _from, uint _value, bytes _data) external;
2538 }
2539 
2540 contract ATxProxy is ERC20 {
2541     
2542     bytes32 public smbl;
2543     address public platform;
2544 
2545     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
2546     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
2547     function __approve(address _spender, uint _value, address _sender) public returns (bool);
2548     function getLatestVersion() public returns (address);
2549     function init(address _bmcPlatform, string _symbol, string _name) public;
2550     function proposeUpgrade(address _newVersion) public;
2551 }
2552 
2553 
2554 
2555 
2556 
2557 
2558 
2559 /// @title ATx Asset implementation contract.
2560 ///
2561 /// Basic asset implementation contract, without any additional logic.
2562 /// Every other asset implementation contracts should derive from this one.
2563 /// Receives calls from the proxy, and calls back immediately without arguments modification.
2564 ///
2565 /// Note: all the non constant functions return false instead of throwing in case if state change
2566 /// didn't happen yet.
2567 contract ATxAsset is BasicAsset, Owned {
2568 
2569     uint public constant OK = 1;
2570 
2571     using SafeMath for uint;
2572 
2573     enum Roles {
2574         Holder,
2575         Service,
2576         Other
2577     }
2578 
2579     ServiceController public serviceController;
2580     DataController public dataController;
2581     uint public lockupDate;
2582 
2583     /// @notice Default constructor for ATxAsset.
2584     function ATxAsset() public {
2585     }
2586 
2587     function() payable public {
2588         revert();
2589     }
2590 
2591     /// @notice Init function for ATxAsset.
2592     ///
2593     /// @param _proxy - atx asset proxy.
2594     /// @param _serviceController - service controoler.
2595     /// @param _dataController - data controller.
2596     /// @param _lockupDate - th lockup date.
2597     function initAtx(
2598         address _proxy, 
2599         address _serviceController, 
2600         address _dataController, 
2601         uint _lockupDate
2602     ) 
2603     onlyContractOwner 
2604     public 
2605     returns (bool) 
2606     {
2607         require(_serviceController != 0x0);
2608         require(_dataController != 0x0);
2609         require(_proxy != 0x0);
2610         require(_lockupDate > now || _lockupDate == 0);
2611 
2612         if (!super.init(ATxProxy(_proxy))) {
2613             return false;
2614         }
2615 
2616         serviceController = ServiceController(_serviceController);
2617         dataController = DataController(_dataController);
2618         lockupDate = _lockupDate;
2619         return true;
2620     }
2621 
2622     /// @notice Performs transfer call on the platform by the name of specified sender.
2623     ///
2624     /// @dev Can only be called by proxy asset.
2625     ///
2626     /// @param _to holder address to give to.
2627     /// @param _value amount to transfer.
2628     /// @param _reference transfer comment to be included in a platform's Transfer event.
2629     /// @param _sender initial caller.
2630     ///
2631     /// @return success.
2632     function __transferWithReference(
2633         address _to, 
2634         uint _value, 
2635         string _reference, 
2636         address _sender
2637     ) 
2638     onlyProxy 
2639     public 
2640     returns (bool) 
2641     {
2642         var (_fromRole, _toRole) = _getParticipantRoles(_sender, _to);
2643 
2644         if (!_checkTransferAllowance(_to, _toRole, _value, _sender, _fromRole)) {
2645             return false;
2646         }
2647 
2648         if (!_isValidCountryLimits(_to, _toRole, _value, _sender, _fromRole)) {
2649             return false;
2650         }
2651 
2652         if (!super.__transferWithReference(_to, _value, _reference, _sender)) {
2653             return false;
2654         }
2655 
2656         _updateTransferLimits(_to, _toRole, _value, _sender, _fromRole);
2657         _contractFallbackERC223(_sender, _to, _value);
2658 
2659         return true;
2660     }
2661 
2662     /// @notice Performs allowance transfer call on the platform by the name of specified sender.
2663     ///
2664     /// @dev Can only be called by proxy asset.
2665     ///
2666     /// @param _from holder address to take from.
2667     /// @param _to holder address to give to.
2668     /// @param _value amount to transfer.
2669     /// @param _reference transfer comment to be included in a platform's Transfer event.
2670     /// @param _sender initial caller.
2671     ///
2672     /// @return success.
2673     function __transferFromWithReference(
2674         address _from, 
2675         address _to, 
2676         uint _value, 
2677         string _reference, 
2678         address _sender
2679     ) 
2680     public 
2681     onlyProxy 
2682     returns (bool) 
2683     {
2684         var (_fromRole, _toRole) = _getParticipantRoles(_from, _to);
2685 
2686         // @note Special check for operational withdraw.
2687         bool _isTransferFromHolderToContractOwner = (_fromRole == Roles.Holder) && 
2688             (contractOwner == _to) && 
2689             (dataController.allowance(_from) >= _value) && 
2690             super.__transferFromWithReference(_from, _to, _value, _reference, _sender);
2691         if (_isTransferFromHolderToContractOwner) {
2692             return true;
2693         }
2694 
2695         if (!_checkTransferAllowanceFrom(_to, _toRole, _value, _from, _fromRole, _sender)) {
2696             return false;
2697         }
2698 
2699         if (!_isValidCountryLimits(_to, _toRole, _value, _from, _fromRole)) {
2700             return false;
2701         }
2702 
2703         if (!super.__transferFromWithReference(_from, _to, _value, _reference, _sender)) {
2704             return false;
2705         }
2706 
2707         _updateTransferLimits(_to, _toRole, _value, _from, _fromRole);
2708         _contractFallbackERC223(_from, _to, _value);
2709 
2710         return true;
2711     }
2712 
2713     /* INTERNAL */
2714 
2715     function _contractFallbackERC223(address _from, address _to, uint _value) internal {
2716         uint _codeLength;
2717         assembly {
2718             _codeLength := extcodesize(_to)
2719         }
2720 
2721         if (_codeLength > 0) {
2722             ERC223ReceivingInterface _receiver = ERC223ReceivingInterface(_to);
2723             bytes memory _empty;
2724             _receiver.tokenFallback(_from, _value, _empty);
2725         }
2726     }
2727 
2728     function _isTokenActive() internal view returns (bool) {
2729         return now > lockupDate;
2730     }
2731 
2732     function _checkTransferAllowance(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) internal view returns (bool) {
2733         if (_to == proxy) {
2734             return false;
2735         }
2736 
2737         bool _canTransferFromService = _fromRole == Roles.Service && ServiceAllowance(_from).isTransferAllowed(_from, _to, _from, proxy, _value);
2738         bool _canTransferToService = _toRole == Roles.Service && ServiceAllowance(_to).isTransferAllowed(_from, _to, _from, proxy, _value);
2739         bool _canTransferToHolder = _toRole == Roles.Holder && _couldDepositToHolder(_to, _value);
2740 
2741         bool _canTransferFromHolder;
2742 
2743         if (_isTokenActive()) {
2744             _canTransferFromHolder = _fromRole == Roles.Holder && _couldWithdrawFromHolder(_from, _value);
2745         } else {
2746             _canTransferFromHolder = _fromRole == Roles.Holder && _couldWithdrawFromHolder(_from, _value) && _from == contractOwner;
2747         }
2748 
2749         return (_canTransferFromHolder || _canTransferFromService) && (_canTransferToHolder || _canTransferToService);
2750     }
2751 
2752     function _checkTransferAllowanceFrom(
2753         address _to, 
2754         Roles _toRole, 
2755         uint _value, 
2756         address _from, 
2757         Roles _fromRole, 
2758         address
2759     ) 
2760     internal 
2761     view 
2762     returns (bool) 
2763     {
2764         return _checkTransferAllowance(_to, _toRole, _value, _from, _fromRole);
2765     }
2766 
2767     function _isValidWithdrawLimits(uint _sendLimPerDay, uint _sendLimPerMonth, uint _value) internal pure returns (bool) {
2768         return !(_value > _sendLimPerDay || _value > _sendLimPerMonth);
2769     }
2770 
2771     function _isValidDepositCountry(
2772         uint _value,
2773         uint _withdrawCountryCode,
2774         uint _withdrawBalance,
2775         uint _countryCode,
2776         uint _balance,
2777         uint _currentHolderCount,
2778         uint _maxHolderNumber
2779     )
2780     internal
2781     pure
2782     returns (bool)
2783     {
2784         return _isNoNeedInCountryLimitChange(_value, _withdrawCountryCode, _withdrawBalance, _countryCode, _balance, _currentHolderCount, _maxHolderNumber)
2785         ? true
2786         : _isValidDepositCountry(_balance, _currentHolderCount, _maxHolderNumber);
2787     }
2788 
2789     function _isNoNeedInCountryLimitChange(
2790         uint _value,
2791         uint _withdrawCountryCode,
2792         uint _withdrawBalance,
2793         uint _countryCode,
2794         uint _balance,
2795         uint _currentHolderCount,
2796         uint _maxHolderNumber
2797     )
2798     internal
2799     pure
2800     returns (bool)
2801     {
2802         bool _needToIncrementCountryHolderCount = _balance == 0;
2803         bool _needToDecrementCountryHolderCount = _withdrawBalance == _value;
2804         bool _shouldOverflowCountryHolderCount = _currentHolderCount == _maxHolderNumber;
2805 
2806         return _withdrawCountryCode == _countryCode && _needToDecrementCountryHolderCount && _needToIncrementCountryHolderCount && _shouldOverflowCountryHolderCount;
2807     }
2808 
2809     function _updateCountries(
2810         uint _value,
2811         uint _withdrawCountryCode,
2812         uint _withdrawBalance,
2813         uint _withdrawCurrentHolderCount,
2814         uint _countryCode,
2815         uint _balance,
2816         uint _currentHolderCount,
2817         uint _maxHolderNumber
2818     )
2819     internal
2820     {
2821         if (_isNoNeedInCountryLimitChange(_value, _withdrawCountryCode, _withdrawBalance, _countryCode, _balance, _currentHolderCount, _maxHolderNumber)) {
2822             return;
2823         }
2824 
2825         _updateWithdrawCountry(_value, _withdrawCountryCode, _withdrawBalance, _withdrawCurrentHolderCount);
2826         _updateDepositCountry(_countryCode, _balance, _currentHolderCount);
2827     }
2828 
2829     function _updateWithdrawCountry(
2830         uint _value,
2831         uint _countryCode,
2832         uint _balance,
2833         uint _currentHolderCount
2834     )
2835     internal
2836     {
2837         if (_value == _balance && OK != dataController.updateCountryHoldersCount(_countryCode, _currentHolderCount.sub(1))) {
2838             revert();
2839         }
2840     }
2841 
2842     function _updateDepositCountry(
2843         uint _countryCode,
2844         uint _balance,
2845         uint _currentHolderCount
2846     )
2847     internal
2848     {
2849         if (_balance == 0 && OK != dataController.updateCountryHoldersCount(_countryCode, _currentHolderCount.add(1))) {
2850             revert();
2851         }
2852     }
2853 
2854     function _getParticipantRoles(address _from, address _to) private view returns (Roles _fromRole, Roles _toRole) {
2855         _fromRole = dataController.isRegisteredAddress(_from) ? Roles.Holder : (serviceController.isService(_from) ? Roles.Service : Roles.Other);
2856         _toRole = dataController.isRegisteredAddress(_to) ? Roles.Holder : (serviceController.isService(_to) ? Roles.Service : Roles.Other);
2857     }
2858 
2859     function _couldWithdrawFromHolder(address _holder, uint _value) private view returns (bool) {
2860         bytes32 _holderId = dataController.getHolderExternalIdByAddress(_holder);
2861         var (, _limPerDay, _limPerMonth, _operational,) = dataController.getHolderInfo(_holderId);
2862         return _operational ? _isValidWithdrawLimits(_limPerDay, _limPerMonth, _value) : false;
2863     }
2864 
2865     function _couldDepositToHolder(address _holder, uint) private view returns (bool) {
2866         bytes32 _holderId = dataController.getHolderExternalIdByAddress(_holder);
2867         var (,,, _operational,) = dataController.getHolderInfo(_holderId);
2868         return _operational;
2869     }
2870 
2871     //TODO need additional check: not clear check of country limit:
2872     function _isValidDepositCountry(uint _balance, uint _currentHolderCount, uint _maxHolderNumber) private pure returns (bool) {
2873         return !(_balance == 0 && _currentHolderCount == _maxHolderNumber);
2874     }
2875 
2876     function _getHoldersInfo(address _to, Roles _toRole, uint, address _from, Roles _fromRole)
2877     private
2878     view
2879     returns (
2880         uint _fromCountryCode,
2881         uint _fromBalance,
2882         uint _toCountryCode,
2883         uint _toCountryCurrentHolderCount,
2884         uint _toCountryMaxHolderNumber,
2885         uint _toBalance
2886     ) {
2887         bytes32 _holderId;
2888         if (_toRole == Roles.Holder) {
2889             _holderId = dataController.getHolderExternalIdByAddress(_to);
2890             _toCountryCode = dataController.getHolderCountryCode(_holderId);
2891             (_toCountryCurrentHolderCount, _toCountryMaxHolderNumber) = dataController.getCountryInfo(_toCountryCode);
2892             _toBalance = ERC20Interface(proxy).balanceOf(_to);
2893         }
2894 
2895         if (_fromRole == Roles.Holder) {
2896             _holderId = dataController.getHolderExternalIdByAddress(_from);
2897             _fromCountryCode = dataController.getHolderCountryCode(_holderId);
2898             _fromBalance = ERC20Interface(proxy).balanceOf(_from);
2899         }
2900     }
2901 
2902     function _isValidCountryLimits(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) private view returns (bool) {
2903         var (
2904         _fromCountryCode,
2905         _fromBalance,
2906         _toCountryCode,
2907         _toCountryCurrentHolderCount,
2908         _toCountryMaxHolderNumber,
2909         _toBalance
2910         ) = _getHoldersInfo(_to, _toRole, _value, _from, _fromRole);
2911 
2912         //TODO not clear for which case this check
2913         bool _isValidLimitFromHolder = _fromRole == _toRole && _fromRole == Roles.Holder && !_isValidDepositCountry(_value, _fromCountryCode, _fromBalance, _toCountryCode, _toBalance, _toCountryCurrentHolderCount, _toCountryMaxHolderNumber);
2914         bool _isValidLimitsToHolder = _toRole == Roles.Holder && !_isValidDepositCountry(_toBalance, _toCountryCurrentHolderCount, _toCountryMaxHolderNumber);
2915 
2916         return !(_isValidLimitFromHolder || _isValidLimitsToHolder);
2917     }
2918 
2919     function _updateTransferLimits(address _to, Roles _toRole, uint _value, address _from, Roles _fromRole) private {
2920         var (
2921         _fromCountryCode,
2922         _fromBalance,
2923         _toCountryCode,
2924         _toCountryCurrentHolderCount,
2925         _toCountryMaxHolderNumber,
2926         _toBalance
2927         ) = _getHoldersInfo(_to, _toRole, _value, _from, _fromRole);
2928 
2929         if (_fromRole == Roles.Holder && OK != dataController.withdrawFrom(_from, _value)) {
2930             revert();
2931         }
2932 
2933         if (_toRole == Roles.Holder && OK != dataController.depositTo(_from, _value)) {
2934             revert();
2935         }
2936 
2937         uint _fromCountryCurrentHolderCount;
2938         if (_fromRole == Roles.Holder && _fromRole == _toRole) {
2939             (_fromCountryCurrentHolderCount,) = dataController.getCountryInfo(_fromCountryCode);
2940             _updateCountries(
2941                 _value,
2942                 _fromCountryCode,
2943                 _fromBalance,
2944                 _fromCountryCurrentHolderCount,
2945                 _toCountryCode,
2946                 _toBalance,
2947                 _toCountryCurrentHolderCount,
2948                 _toCountryMaxHolderNumber
2949             );
2950         } else if (_fromRole == Roles.Holder) {
2951             (_fromCountryCurrentHolderCount,) = dataController.getCountryInfo(_fromCountryCode);
2952             _updateWithdrawCountry(_value, _fromCountryCode, _fromBalance, _fromCountryCurrentHolderCount);
2953         } else if (_toRole == Roles.Holder) {
2954             _updateDepositCountry(_toCountryCode, _toBalance, _toCountryCurrentHolderCount);
2955         }
2956     }
2957 }
2958 
2959 /// @title ATx Asset implementation contract.
2960 ///
2961 /// Basic asset implementation contract, without any additional logic.
2962 /// Every other asset implementation contracts should derive from this one.
2963 /// Receives calls from the proxy, and calls back immediately without arguments modification.
2964 ///
2965 /// Note: all the non constant functions return false instead of throwing in case if state change
2966 /// didn't happen yet.
2967 contract Asset is ATxAsset {
2968 }