1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
80 
81 /**
82  * @title Contactable token
83  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
84  * contact information.
85  */
86 contract Contactable is Ownable{
87 
88     string public contactInformation;
89 
90     /**
91      * @dev Allows the owner to set a string with their contact information.
92      * @param info The contact information to attach to the contract.
93      */
94     function setContactInformation(string info) onlyOwner public {
95          contactInformation = info;
96      }
97 }
98 
99 // File: contracts/MonethaUsers.sol
100 
101 /**
102  *  @title MonethaUsers
103  *
104  *  MonethaUsers stores basic user information, i.e. his nickname and reputation score
105  */
106 contract MonethaUsers is Contactable {
107 
108     using SafeMath for uint256;
109 
110     string constant VERSION = "0.1";
111 
112     struct User {
113         string name;
114         uint256 starScore;
115         uint256 reputationScore;
116         uint256 signedDealsCount;
117         string nickname;
118         bool isVerified;
119     }
120 
121     mapping (address => User) public users;
122 
123     event UpdatedSignedDealsCount(address indexed _userAddress, uint256 _newSignedDealsCount);
124     event UpdatedStarScore(address indexed _userAddress, uint256 _newStarScore);
125     event UpdatedReputationScore(address indexed _userAddress, uint256 _newReputationScore);
126     event UpdatedNickname(address indexed _userAddress, string _newNickname);
127     event UpdatedIsVerified(address indexed _userAddress, bool _newIsVerified);
128     event UpdatedName(address indexed _userAddress, string _newName);
129     event UpdatedTrustScore(address indexed _userAddress, uint256 _newStarScore, uint256 _newReputationScore);
130     event UserRegistered(address indexed _userAddress, string _name, uint256 _starScore, uint256 _reputationScore, uint256 _signedDealsCount, string _nickname, bool _isVerified);
131     event UpdatedUserDetails(address indexed _userAddress, uint256 _newStarScore, uint256 _newReputationScore, uint256 _newSignedDealsCount, bool _newIsVerified);
132     event UpdatedUser(address indexed _userAddress, string _name, uint256 _newStarScore, uint256 _newReputationScore, uint256 _newSignedDealsCount, string _newNickname, bool _newIsVerified);
133 
134     /**
135      *  registerUser associates a Monetha user's ethereum address with his nickname and trust score
136      *  @param _userAddress address of user's wallet
137      *  @param _name corresponds to use's nickname
138      *  @param _starScore represents user's star score
139      *  @param _reputationScore represents user's reputation score
140      *  @param _signedDealsCount represents user's signed deal count
141      *  @param _nickname represents user's nickname
142      *  @param _isVerified represents whether user is verified (KYC'ed)
143      */
144     function registerUser(address _userAddress, string _name, uint256 _starScore, uint256 _reputationScore, uint256 _signedDealsCount, string _nickname, bool _isVerified)
145         external onlyOwner
146     {
147         User storage user = users[_userAddress];
148 
149         user.name = _name;
150         user.starScore = _starScore;
151         user.reputationScore = _reputationScore;
152         user.signedDealsCount = _signedDealsCount;
153         user.nickname = _nickname;
154         user.isVerified = _isVerified;
155 
156         emit UserRegistered(_userAddress, _name, _starScore, _reputationScore, _signedDealsCount, _nickname, _isVerified);
157     }
158 
159     /**
160      *  updateStarScore updates the star score of a Monetha user
161      *  @param _userAddress address of user's wallet
162      *  @param _updatedStars represents user's new star score
163      */
164     function updateStarScore(address _userAddress, uint256 _updatedStars)
165         external onlyOwner
166     {
167         users[_userAddress].starScore = _updatedStars;
168 
169         emit UpdatedStarScore(_userAddress, _updatedStars);
170     }
171 
172     /**
173      *  updateStarScoreInBulk updates the star score of Monetha users in bulk
174      */
175     function updateStarScoreInBulk(address[] _userAddresses, uint256[] _starScores)
176         external onlyOwner
177     {
178         require(_userAddresses.length == _starScores.length);
179 
180         for (uint256 i = 0; i < _userAddresses.length; i++) {
181             users[_userAddresses[i]].starScore = _starScores[i];
182 
183             emit UpdatedStarScore(_userAddresses[i], _starScores[i]);
184         }
185     }
186 
187     /**
188      *  updateReputationScore updates the reputation score of a Monetha user
189      *  @param _userAddress address of user's wallet
190      *  @param _updatedReputation represents user's new reputation score
191      */
192     function updateReputationScore(address _userAddress, uint256 _updatedReputation)
193         external onlyOwner
194     {
195         users[_userAddress].reputationScore = _updatedReputation;
196 
197         emit UpdatedReputationScore(_userAddress, _updatedReputation);
198     }
199 
200     /**
201      *  updateReputationScoreInBulk updates the reputation score of a Monetha users in bulk
202      */
203     function updateReputationScoreInBulk(address[] _userAddresses, uint256[] _reputationScores)
204         external onlyOwner
205     {
206         require(_userAddresses.length == _reputationScores.length);
207 
208         for (uint256 i = 0; i < _userAddresses.length; i++) {
209             users[_userAddresses[i]].reputationScore = _reputationScores[i];
210 
211             emit UpdatedReputationScore(_userAddresses[i],  _reputationScores[i]);
212         }
213     }
214 
215     /**
216      *  updateTrustScore updates the trust score of a Monetha user
217      *  @param _userAddress address of user's wallet
218      *  @param _updatedStars represents user's new star score
219      *  @param _updatedReputation represents user's new reputation score
220      */
221     function updateTrustScore(address _userAddress, uint256 _updatedStars, uint256 _updatedReputation)
222         external onlyOwner
223     {
224         users[_userAddress].starScore = _updatedStars;
225         users[_userAddress].reputationScore = _updatedReputation;
226 
227         emit UpdatedTrustScore(_userAddress, _updatedStars, _updatedReputation);
228     }
229 
230      /**
231      *  updateTrustScoreInBulk updates the trust score of Monetha users in bulk
232      */
233     function updateTrustScoreInBulk(address[] _userAddresses, uint256[] _starScores, uint256[] _reputationScores)
234         external onlyOwner
235     {
236         require(_userAddresses.length == _starScores.length);
237         require(_userAddresses.length == _reputationScores.length);
238 
239         for (uint256 i = 0; i < _userAddresses.length; i++) {
240             users[_userAddresses[i]].starScore = _starScores[i];
241             users[_userAddresses[i]].reputationScore = _reputationScores[i];
242 
243             emit UpdatedTrustScore(_userAddresses[i], _starScores[i], _reputationScores[i]);
244         }
245     }
246 
247     /**
248      *  updateSignedDealsCount updates the signed deals count of a Monetha user
249      *  @param _userAddress address of user's wallet
250      *  @param _updatedSignedDeals represents user's new signed deals count
251      */
252     function updateSignedDealsCount(address _userAddress, uint256 _updatedSignedDeals)
253         external onlyOwner
254     {
255         users[_userAddress].signedDealsCount = _updatedSignedDeals;
256 
257         emit UpdatedSignedDealsCount(_userAddress, _updatedSignedDeals);
258     }
259 
260     /**
261      *  updateSignedDealsCountInBulk updates the signed deals count of Monetha users in bulk
262      */
263     function updateSignedDealsCountInBulk(address[] _userAddresses, uint256[] _updatedSignedDeals)
264         external onlyOwner
265     {
266         require(_userAddresses.length == _updatedSignedDeals.length);
267 
268         for (uint256 i = 0; i < _userAddresses.length; i++) {
269             users[_userAddresses[i]].signedDealsCount = _updatedSignedDeals[i];
270 
271             emit UpdatedSignedDealsCount(_userAddresses[i], _updatedSignedDeals[i]);
272         }
273     }
274 
275     /**
276      *  updateNickname updates user's nickname
277      *  @param _userAddress address of user's wallet
278      *  @param _updatedNickname represents user's new nickname
279      */
280     function updateNickname(address _userAddress, string _updatedNickname)
281         external onlyOwner
282     {
283         users[_userAddress].nickname = _updatedNickname;
284 
285         emit UpdatedNickname(_userAddress, _updatedNickname);
286     }
287 
288     /**
289      *  updateIsVerified updates user's verified status
290      *  @param _userAddress address of user's wallet
291      *  @param _isVerified represents user's new verification status
292      */
293     function updateIsVerified(address _userAddress, bool _isVerified)
294         external onlyOwner
295     {
296         users[_userAddress].isVerified = _isVerified;
297 
298         emit UpdatedIsVerified(_userAddress, _isVerified);
299     }
300 
301     /**
302      *  updateIsVerifiedInBulk updates nicknames of Monetha users in bulk
303      */
304     function updateIsVerifiedInBulk(address[] _userAddresses, bool[] _updatedIsVerfied)
305         external onlyOwner
306     {
307         require(_userAddresses.length == _updatedIsVerfied.length);
308 
309         for (uint256 i = 0; i < _userAddresses.length; i++) {
310             users[_userAddresses[i]].isVerified = _updatedIsVerfied[i];
311 
312             emit UpdatedIsVerified(_userAddresses[i], _updatedIsVerfied[i]);
313         }
314     }
315 
316     /**
317      *  updateUserDetailsInBulk updates details of Monetha users in bulk
318      */
319     function updateUserDetailsInBulk(address[] _userAddresses, uint256[] _starScores, uint256[] _reputationScores, uint256[] _signedDealsCount, bool[] _isVerified)
320         external onlyOwner
321     {
322         require(_userAddresses.length == _starScores.length);
323         require(_userAddresses.length == _reputationScores.length);
324         require(_userAddresses.length == _signedDealsCount.length);
325         require(_userAddresses.length == _isVerified.length);
326 
327         for (uint256 i = 0; i < _userAddresses.length; i++) {
328             users[_userAddresses[i]].starScore = _starScores[i];
329             users[_userAddresses[i]].reputationScore = _reputationScores[i];
330             users[_userAddresses[i]].signedDealsCount = _signedDealsCount[i];
331             users[_userAddresses[i]].isVerified = _isVerified[i];
332 
333             emit UpdatedUserDetails(_userAddresses[i], _starScores[i], _reputationScores[i], _signedDealsCount[i], _isVerified[i]);
334         }
335     }
336 
337     /**
338      *  updateName updates the name of a Monetha user
339      *  @param _userAddress address of user's wallet
340      *  @param _updatedName represents user's new name
341      */
342     function updateName(address _userAddress, string _updatedName)
343         external onlyOwner
344     {
345         users[_userAddress].name = _updatedName;
346 
347         emit UpdatedName(_userAddress, _updatedName);
348     }
349 
350     /**
351      *  updateUser updates single user details
352      */
353     function updateUser(address _userAddress, string _updatedName, uint256 _updatedStarScore, uint256 _updatedReputationScore, uint256 _updatedSignedDealsCount, string _updatedNickname, bool _updatedIsVerified)
354         external onlyOwner
355     {
356         users[_userAddress].name = _updatedName;
357         users[_userAddress].starScore = _updatedStarScore;
358         users[_userAddress].reputationScore = _updatedReputationScore;
359         users[_userAddress].signedDealsCount = _updatedSignedDealsCount;
360         users[_userAddress].nickname = _updatedNickname;
361         users[_userAddress].isVerified = _updatedIsVerified;
362 
363         emit UpdatedUser(_userAddress, _updatedName, _updatedStarScore, _updatedReputationScore, _updatedSignedDealsCount, _updatedNickname, _updatedIsVerified);
364     }
365 }