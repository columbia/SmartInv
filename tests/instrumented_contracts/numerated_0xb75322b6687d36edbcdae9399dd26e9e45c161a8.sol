1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Owned contract with safe ownership pass.
35  *
36  * Note: all the non constant functions return false instead of throwing in case if state change
37  * didn't happen yet.
38  */
39 contract Owned {
40     /**
41      * Contract owner address
42      */
43     address public contractOwner;
44 
45     /**
46      * Contract owner address
47      */
48     address public pendingContractOwner;
49 
50     function Owned() {
51         contractOwner = msg.sender;
52     }
53 
54     /**
55     * @dev Owner check modifier
56     */
57     modifier onlyContractOwner() {
58         if (contractOwner == msg.sender) {
59             _;
60         }
61     }
62 
63     /**
64      * @dev Destroy contract and scrub a data
65      * @notice Only owner can call it
66      */
67     function destroy() onlyContractOwner {
68         suicide(msg.sender);
69     }
70 
71     /**
72      * Prepares ownership pass.
73      *
74      * Can only be called by current owner.
75      *
76      * @param _to address of the next owner. 0x0 is not allowed.
77      *
78      * @return success.
79      */
80     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
81         if (_to  == 0x0) {
82             return false;
83         }
84 
85         pendingContractOwner = _to;
86         return true;
87     }
88 
89     /**
90      * Finalize ownership pass.
91      *
92      * Can only be called by pending owner.
93      *
94      * @return success.
95      */
96     function claimContractOwnership() returns(bool) {
97         if (pendingContractOwner != msg.sender) {
98             return false;
99         }
100 
101         contractOwner = pendingContractOwner;
102         delete pendingContractOwner;
103 
104         return true;
105     }
106 }
107 
108 contract ERC20Interface {
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(address indexed from, address indexed spender, uint256 value);
111     string public symbol;
112 
113     function totalSupply() constant returns (uint256 supply);
114     function balanceOf(address _owner) constant returns (uint256 balance);
115     function transfer(address _to, uint256 _value) returns (bool success);
116     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
117     function approve(address _spender, uint256 _value) returns (bool success);
118     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
119 }
120 
121 /**
122  * @title Generic owned destroyable contract
123  */
124 contract Object is Owned {
125     /**
126     *  Common result code. Means everything is fine.
127     */
128     uint constant OK = 1;
129     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
130 
131     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
132         for(uint i=0;i<tokens.length;i++) {
133             address token = tokens[i];
134             uint balance = ERC20Interface(token).balanceOf(this);
135             if(balance != 0)
136                 ERC20Interface(token).transfer(_to,balance);
137         }
138         return OK;
139     }
140 
141     function checkOnlyContractOwner() internal constant returns(uint) {
142         if (contractOwner == msg.sender) {
143             return OK;
144         }
145 
146         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
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