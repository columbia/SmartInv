1 pragma solidity ^0.4.21;
2 
3 // zeppelin-solidity: 1.9.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     if (a == 0) {
56       return 0;
57     }
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 contract Membership is Ownable {
92   using SafeMath for uint;
93 
94   mapping(address => bool) public isAdmin;
95   mapping(address => uint) public userToMemberIndex;
96   mapping(uint => uint[]) public tierToMemberIndexes;
97 
98   struct Member {
99     address addr;
100     uint tier;
101     uint tierIndex;
102     uint memberIndex;
103   }
104 
105   Member[] private members;
106 
107   event NewMember(address user, uint tier);
108   event UpdatedMemberTier(address user, uint oldTier, uint newTier);
109   event RemovedMember(address user, uint tier);
110 
111   modifier onlyAdmin() {
112     require(isAdmin[msg.sender]);
113     _;
114   }
115 
116   modifier isValidTier(uint _tier) {
117     require(_tier >= 1 && _tier <= 4);
118     _;
119   }
120 
121   modifier notTryingToChangeFromTier1(address _user, uint _tier) {
122     require(members[userToMemberIndex[_user]].tier != _tier);
123     _;
124   }
125 
126 
127   modifier isMember(address _user) {
128     require(userToMemberIndex[_user] != 0);
129     _;
130   }
131 
132   modifier isValidAddr(address _trgt) {
133     require(_trgt != address(0));
134     _;
135   }
136 
137   constructor() public {
138     Member memory member = Member(address(0), 0, 0, 0);
139     members.push(member);
140   }
141 
142   function addAdmin(address _user)
143     external
144     onlyOwner
145   {
146     isAdmin[_user] = true;
147   }
148 
149   function removeMember(address _user)
150     external
151     onlyAdmin
152     isValidAddr(_user)
153     isMember(_user)
154   {
155     uint index = userToMemberIndex[_user];
156     require(index != 0);
157 
158     Member memory removingMember = members[index];
159 
160     uint tier = removingMember.tier;
161 
162     uint lastTierIndex = tierToMemberIndexes[removingMember.tier].length - 1;
163     uint lastTierMemberIndex = tierToMemberIndexes[removingMember.tier][lastTierIndex];
164     Member storage lastTierMember = members[lastTierMemberIndex];
165     lastTierMember.tierIndex = removingMember.tierIndex;
166     tierToMemberIndexes[removingMember.tier][removingMember.tierIndex] = lastTierMember.memberIndex;
167     tierToMemberIndexes[removingMember.tier].length--;
168 
169     Member storage lastMember = members[members.length - 1];
170     if (lastMember.addr != removingMember.addr) {
171       userToMemberIndex[lastMember.addr] = removingMember.memberIndex;
172       tierToMemberIndexes[lastMember.tier][lastMember.tierIndex] = removingMember.memberIndex;
173       lastMember.memberIndex = removingMember.memberIndex;
174       members[removingMember.memberIndex] = lastMember;
175     }
176     userToMemberIndex[removingMember.addr] = 0;
177     members.length--;
178 
179     emit RemovedMember(_user, tier);
180   }
181 
182   function addNewMember(address _user, uint _tier)
183     internal
184   {
185     // it's a new member
186     uint memberIndex = members.length; // + 1; // add 1 to keep index 0 unoccupied
187     uint tierIndex = tierToMemberIndexes[_tier].length;
188 
189     Member memory newMember = Member(_user, _tier, tierIndex, memberIndex);
190 
191     members.push(newMember);
192     userToMemberIndex[_user] = memberIndex;
193     tierToMemberIndexes[_tier].push(memberIndex);
194 
195     emit NewMember(_user, _tier);
196   }
197 
198   function updateExistingMember(address _user, uint _newTier)
199     internal
200   {
201     // this user is a member in another tier, remove him from that tier,
202     // and add him to the new tier
203     Member storage existingMember = members[userToMemberIndex[_user]];
204 
205     uint oldTier = existingMember.tier;
206     uint tierIndex = existingMember.tierIndex;
207     uint lastTierIndex = tierToMemberIndexes[oldTier].length - 1;
208 
209     if (tierToMemberIndexes[oldTier].length > 1 && tierIndex != lastTierIndex) {
210       Member storage lastMember = members[tierToMemberIndexes[oldTier][lastTierIndex]];
211       tierToMemberIndexes[oldTier][tierIndex] = lastMember.memberIndex;
212       lastMember.tierIndex = tierIndex;
213     }
214 
215     tierToMemberIndexes[oldTier].length--;
216     tierToMemberIndexes[_newTier].push(existingMember.memberIndex);
217 
218     existingMember.tier = _newTier;
219     existingMember.tierIndex = tierToMemberIndexes[_newTier].length - 1;
220 
221     emit UpdatedMemberTier(_user, oldTier, _newTier);
222   }
223 
224   function setMemberTier(address _user, uint _tier)
225     external
226     onlyAdmin
227     isValidAddr(_user)
228     isValidTier(_tier)
229   {
230     if (userToMemberIndex[_user] == 0) {
231       addNewMember(_user, _tier);
232     } else {
233       uint currentTier = members[userToMemberIndex[_user]].tier;
234       if (currentTier != _tier) {
235         // user's in tier 1 are lifetime tier 1 users
236         require(currentTier != 1);
237 
238         updateExistingMember(_user, _tier);
239       }
240     }
241   }
242 
243   function getTierOfMember(address _user)
244     external
245     view
246     returns (uint)
247   {
248     return members[userToMemberIndex[_user]].tier;
249   }
250 
251   function getMembersOfTier(uint _tier)
252     external
253     view
254     returns (address[])
255   {
256     address[] memory addressesOfTier = new address[](tierToMemberIndexes[_tier].length);
257 
258     for (uint i = 0; i < tierToMemberIndexes[_tier].length; i++) {
259       addressesOfTier[i] = members[tierToMemberIndexes[_tier][i]].addr;
260     }
261 
262     return addressesOfTier;
263   }
264 
265   function getMembersOfTierCount(uint _tier)
266     external
267     view
268     returns (uint)
269   {
270     return tierToMemberIndexes[_tier].length;
271   }
272 
273   function getMembersCount()
274     external
275     view
276     returns (uint)
277   {
278     if (members.length == 0) {
279       return 0;
280     } else {
281       // remove sentinel at index zero from count
282       return members.length - 1;
283     }
284   }
285 
286   function getMemberByIdx(uint _idx)
287     external
288     view
289     returns (address, uint)
290   {
291     Member memory member = members[_idx];
292 
293     return (member.addr, member.tier);
294   }
295 
296   function isUserMember(address _user)
297     external
298     view
299     returns (bool)
300   {
301     return userToMemberIndex[_user] != 0;
302   }
303 
304   function getMemberIdxOfUser(address _user)
305     external
306     view
307     returns (uint)
308   {
309     return userToMemberIndex[_user];
310   }
311 }