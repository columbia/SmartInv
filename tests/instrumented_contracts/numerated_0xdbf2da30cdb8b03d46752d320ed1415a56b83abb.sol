1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Owned contract with safe ownership pass.
36  *
37  * Note: all the non constant functions return false instead of throwing in case if state change
38  * didn't happen yet.
39  */
40 contract Owned {
41     /**
42      * Contract owner address
43      */
44     address public contractOwner;
45 
46     /**
47      * Contract owner address
48      */
49     address public pendingContractOwner;
50 
51     function Owned() {
52         contractOwner = msg.sender;
53     }
54 
55     /**
56     * @dev Owner check modifier
57     */
58     modifier onlyContractOwner() {
59         if (contractOwner == msg.sender) {
60             _;
61         }
62     }
63 
64     /**
65      * @dev Destroy contract and scrub a data
66      * @notice Only owner can call it
67      */
68     function destroy() onlyContractOwner {
69         suicide(msg.sender);
70     }
71 
72     /**
73      * Prepares ownership pass.
74      *
75      * Can only be called by current owner.
76      *
77      * @param _to address of the next owner. 0x0 is not allowed.
78      *
79      * @return success.
80      */
81     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
82         if (_to  == 0x0) {
83             return false;
84         }
85 
86         pendingContractOwner = _to;
87         return true;
88     }
89 
90     /**
91      * Finalize ownership pass.
92      *
93      * Can only be called by pending owner.
94      *
95      * @return success.
96      */
97     function claimContractOwnership() returns(bool) {
98         if (pendingContractOwner != msg.sender) {
99             return false;
100         }
101 
102         contractOwner = pendingContractOwner;
103         delete pendingContractOwner;
104 
105         return true;
106     }
107 }
108 
109 
110 contract ERC20Interface {
111     event Transfer(address indexed from, address indexed to, uint256 value);
112     event Approval(address indexed from, address indexed spender, uint256 value);
113     string public symbol;
114 
115     function totalSupply() constant returns (uint256 supply);
116     function balanceOf(address _owner) constant returns (uint256 balance);
117     function transfer(address _to, uint256 _value) returns (bool success);
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
119     function approve(address _spender, uint256 _value) returns (bool success);
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
121 }
122 
123 /**
124  * @title Generic owned destroyable contract
125  */
126 contract Object is Owned {
127     /**
128     *  Common result code. Means everything is fine.
129     */
130     uint constant OK = 1;
131     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
132 
133     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
134         for(uint i=0;i<tokens.length;i++) {
135             address token = tokens[i];
136             uint balance = ERC20Interface(token).balanceOf(this);
137             if(balance != 0)
138                 ERC20Interface(token).transfer(_to,balance);
139         }
140         return OK;
141     }
142 
143     function checkOnlyContractOwner() internal constant returns(uint) {
144         if (contractOwner == msg.sender) {
145             return OK;
146         }
147 
148         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
149     }
150 }
151 
152 contract GroupsAccessManagerEmitter {
153 
154     event UserCreated(address user);
155     event UserDeleted(address user);
156     event GroupCreated(bytes32 groupName);
157     event GroupActivated(bytes32 groupName);
158     event GroupDeactivated(bytes32 groupName);
159     event UserToGroupAdded(address user, bytes32 groupName);
160     event UserFromGroupRemoved(address user, bytes32 groupName);
161 }
162 
163 
164 /// @title Group Access Manager
165 ///
166 /// Base implementation
167 /// This contract serves as group manager
168 contract GroupsAccessManager is Object, GroupsAccessManagerEmitter {
169 
170     uint constant USER_MANAGER_SCOPE = 111000;
171     uint constant USER_MANAGER_MEMBER_ALREADY_EXIST = USER_MANAGER_SCOPE + 1;
172     uint constant USER_MANAGER_GROUP_ALREADY_EXIST = USER_MANAGER_SCOPE + 2;
173     uint constant USER_MANAGER_OBJECT_ALREADY_SECURED = USER_MANAGER_SCOPE + 3;
174     uint constant USER_MANAGER_CONFIRMATION_HAS_COMPLETED = USER_MANAGER_SCOPE + 4;
175     uint constant USER_MANAGER_USER_HAS_CONFIRMED = USER_MANAGER_SCOPE + 5;
176     uint constant USER_MANAGER_NOT_ENOUGH_GAS = USER_MANAGER_SCOPE + 6;
177     uint constant USER_MANAGER_INVALID_INVOCATION = USER_MANAGER_SCOPE + 7;
178     uint constant USER_MANAGER_DONE = USER_MANAGER_SCOPE + 11;
179     uint constant USER_MANAGER_CANCELLED = USER_MANAGER_SCOPE + 12;
180 
181     using SafeMath for uint;
182 
183     struct Member {
184         address addr;
185         uint groupsCount;
186         mapping(bytes32 => uint) groupName2index;
187         mapping(uint => uint) index2globalIndex;
188     }
189 
190     struct Group {
191         bytes32 name;
192         uint priority;
193         uint membersCount;
194         mapping(address => uint) memberAddress2index;
195         mapping(uint => uint) index2globalIndex;
196     }
197 
198     uint public membersCount;
199     mapping(uint => address) index2memberAddress;
200     mapping(address => uint) memberAddress2index;
201     mapping(address => Member) address2member;
202 
203     uint public groupsCount;
204     mapping(uint => bytes32) index2groupName;
205     mapping(bytes32 => uint) groupName2index;
206     mapping(bytes32 => Group) groupName2group;
207     mapping(bytes32 => bool) public groupsBlocked; // if groupName => true, then couldn't be used for confirmation
208 
209     function() payable public {
210         revert();
211     }
212 
213     /// @notice Register user
214     /// Can be called only by contract owner
215     ///
216     /// @param _user user address
217     ///
218     /// @return code
219     function registerUser(address _user) external onlyContractOwner returns (uint) {
220         require(_user != 0x0);
221 
222         if (isRegisteredUser(_user)) {
223             return USER_MANAGER_MEMBER_ALREADY_EXIST;
224         }
225 
226         uint _membersCount = membersCount.add(1);
227         membersCount = _membersCount;
228         memberAddress2index[_user] = _membersCount;
229         index2memberAddress[_membersCount] = _user;
230         address2member[_user] = Member(_user, 0);
231 
232         UserCreated(_user);
233         return OK;
234     }
235 
236     /// @notice Discard user registration
237     /// Can be called only by contract owner
238     ///
239     /// @param _user user address
240     ///
241     /// @return code
242     function unregisterUser(address _user) external onlyContractOwner returns (uint) {
243         require(_user != 0x0);
244 
245         uint _memberIndex = memberAddress2index[_user];
246         if (_memberIndex == 0 || address2member[_user].groupsCount != 0) {
247             return USER_MANAGER_INVALID_INVOCATION;
248         }
249 
250         uint _membersCount = membersCount;
251         delete memberAddress2index[_user];
252         if (_memberIndex != _membersCount) {
253             address _lastUser = index2memberAddress[_membersCount];
254             index2memberAddress[_memberIndex] = _lastUser;
255             memberAddress2index[_lastUser] = _memberIndex;
256         }
257         delete address2member[_user];
258         delete index2memberAddress[_membersCount];
259         delete memberAddress2index[_user];
260         membersCount = _membersCount.sub(1);
261 
262         UserDeleted(_user);
263         return OK;
264     }
265 
266     /// @notice Create group
267     /// Can be called only by contract owner
268     ///
269     /// @param _groupName group name
270     /// @param _priority group priority
271     ///
272     /// @return code
273     function createGroup(bytes32 _groupName, uint _priority) external onlyContractOwner returns (uint) {
274         require(_groupName != bytes32(0));
275 
276         if (isGroupExists(_groupName)) {
277             return USER_MANAGER_GROUP_ALREADY_EXIST;
278         }
279 
280         uint _groupsCount = groupsCount.add(1);
281         groupName2index[_groupName] = _groupsCount;
282         index2groupName[_groupsCount] = _groupName;
283         groupName2group[_groupName] = Group(_groupName, _priority, 0);
284         groupsCount = _groupsCount;
285 
286         GroupCreated(_groupName);
287         return OK;
288     }
289 
290     /// @notice Change group status
291     /// Can be called only by contract owner
292     ///
293     /// @param _groupName group name
294     /// @param _blocked block status
295     ///
296     /// @return code
297     function changeGroupActiveStatus(bytes32 _groupName, bool _blocked) external onlyContractOwner returns (uint) {
298         require(isGroupExists(_groupName));
299         groupsBlocked[_groupName] = _blocked;
300         return OK;
301     }
302 
303     /// @notice Add users in group
304     /// Can be called only by contract owner
305     ///
306     /// @param _groupName group name
307     /// @param _users user array
308     ///
309     /// @return code
310     function addUsersToGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
311         require(isGroupExists(_groupName));
312 
313         Group storage _group = groupName2group[_groupName];
314         uint _groupMembersCount = _group.membersCount;
315 
316         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
317             address _user = _users[_userIdx];
318             uint _memberIndex = memberAddress2index[_user];
319             require(_memberIndex != 0);
320 
321             if (_group.memberAddress2index[_user] != 0) {
322                 continue;
323             }
324 
325             _groupMembersCount = _groupMembersCount.add(1);
326             _group.memberAddress2index[_user] = _groupMembersCount;
327             _group.index2globalIndex[_groupMembersCount] = _memberIndex;
328 
329             _addGroupToMember(_user, _groupName);
330 
331             UserToGroupAdded(_user, _groupName);
332         }
333         _group.membersCount = _groupMembersCount;
334 
335         return OK;
336     }
337 
338     /// @notice Remove users in group
339     /// Can be called only by contract owner
340     ///
341     /// @param _groupName group name
342     /// @param _users user array
343     ///
344     /// @return code
345     function removeUsersFromGroup(bytes32 _groupName, address[] _users) external onlyContractOwner returns (uint) {
346         require(isGroupExists(_groupName));
347 
348         Group storage _group = groupName2group[_groupName];
349         uint _groupMembersCount = _group.membersCount;
350 
351         for (uint _userIdx = 0; _userIdx < _users.length; ++_userIdx) {
352             address _user = _users[_userIdx];
353             uint _memberIndex = memberAddress2index[_user];
354             uint _groupMemberIndex = _group.memberAddress2index[_user];
355 
356             if (_memberIndex == 0 || _groupMemberIndex == 0) {
357                 continue;
358             }
359 
360             if (_groupMemberIndex != _groupMembersCount) {
361                 uint _lastUserGlobalIndex = _group.index2globalIndex[_groupMembersCount];
362                 address _lastUser = index2memberAddress[_lastUserGlobalIndex];
363                 _group.index2globalIndex[_groupMemberIndex] = _lastUserGlobalIndex;
364                 _group.memberAddress2index[_lastUser] = _groupMemberIndex;
365             }
366             delete _group.memberAddress2index[_user];
367             delete _group.index2globalIndex[_groupMembersCount];
368             _groupMembersCount = _groupMembersCount.sub(1);
369 
370             _removeGroupFromMember(_user, _groupName);
371 
372             UserFromGroupRemoved(_user, _groupName);
373         }
374         _group.membersCount = _groupMembersCount;
375 
376         return OK;
377     }
378 
379     /// @notice Check is user registered
380     ///
381     /// @param _user user address
382     ///
383     /// @return status
384     function isRegisteredUser(address _user) public view returns (bool) {
385         return memberAddress2index[_user] != 0;
386     }
387 
388     /// @notice Check is user in group
389     ///
390     /// @param _groupName user array
391     /// @param _user user array
392     ///
393     /// @return status
394     function isUserInGroup(bytes32 _groupName, address _user) public view returns (bool) {
395         return isRegisteredUser(_user) && address2member[_user].groupName2index[_groupName] != 0;
396     }
397 
398     /// @notice Check is group exist
399     ///
400     /// @param _groupName group name
401     ///
402     /// @return status
403     function isGroupExists(bytes32 _groupName) public view returns (bool) {
404         return groupName2index[_groupName] != 0;
405     }
406 
407     /// @notice Get current group names
408     ///
409     /// @return group names
410     function getGroups() public view returns (bytes32[] _groups) {
411         uint _groupsCount = groupsCount;
412         _groups = new bytes32[](_groupsCount);
413         for (uint _groupIdx = 0; _groupIdx < _groupsCount; ++_groupIdx) {
414             _groups[_groupIdx] = index2groupName[_groupIdx + 1];
415         }
416     }
417 
418     // PRIVATE
419 
420     function _removeGroupFromMember(address _user, bytes32 _groupName) private {
421         Member storage _member = address2member[_user];
422         uint _memberGroupsCount = _member.groupsCount;
423         uint _memberGroupIndex = _member.groupName2index[_groupName];
424         if (_memberGroupIndex != _memberGroupsCount) {
425             uint _lastGroupGlobalIndex = _member.index2globalIndex[_memberGroupsCount];
426             bytes32 _lastGroupName = index2groupName[_lastGroupGlobalIndex];
427             _member.index2globalIndex[_memberGroupIndex] = _lastGroupGlobalIndex;
428             _member.groupName2index[_lastGroupName] = _memberGroupIndex;
429         }
430         delete _member.groupName2index[_groupName];
431         delete _member.index2globalIndex[_memberGroupsCount];
432         _member.groupsCount = _memberGroupsCount.sub(1);
433     }
434 
435     function _addGroupToMember(address _user, bytes32 _groupName) private {
436         Member storage _member = address2member[_user];
437         uint _memberGroupsCount = _member.groupsCount.add(1);
438         _member.groupName2index[_groupName] = _memberGroupsCount;
439         _member.index2globalIndex[_memberGroupsCount] = groupName2index[_groupName];
440         _member.groupsCount = _memberGroupsCount;
441     }
442 }