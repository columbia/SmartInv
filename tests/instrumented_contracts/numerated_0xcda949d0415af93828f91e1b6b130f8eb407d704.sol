1 pragma experimental ABIEncoderV2;
2 pragma solidity ^0.6.0;
3 
4 contract OfferStorage {
5 
6   mapping(address => bool) public accessAllowed;
7   mapping(address => mapping(uint => bool)) public userOfferClaim;
8   mapping(uint256 => address[]) public claimedUsers;
9 
10   constructor() public {
11     accessAllowed[msg.sender] = true;
12   }
13 
14   modifier platform() {
15     require(accessAllowed[msg.sender] == true);
16     _;
17   }
18 
19   function allowAccess(address _address) platform public {
20     accessAllowed[_address] = true;
21   }
22 
23   function denyAccess(address _address) platform public {
24     accessAllowed[_address] = false;
25   }
26 
27   function setUserClaim(address _address, uint offerId, bool status) platform public returns(bool) {
28     userOfferClaim[_address][offerId] = status;
29     if (status) {
30       claimedUsers[offerId].push(_address);
31     }
32     return true;
33   }
34 
35   function getClaimedUsersLength(uint _offerId) platform public view returns(uint256){
36       return claimedUsers[_offerId].length;
37   }
38 
39 }
40 
41 abstract contract OpenAlexalO {
42 
43     struct UserStruct {
44         bool isExist;
45         uint id;
46         uint referrerID;
47         uint currentLevel;
48         uint totalEarningEth;
49         address[] referral;
50         mapping(uint => uint) levelExpired;
51     }
52 
53     mapping (address => UserStruct) public users;
54     mapping (uint => address) public userList;
55     mapping (address => uint) public createdDate;
56 
57     function viewUserReferral(address _userAddress) virtual external view returns (address[] memory);
58 
59 }
60 
61 contract Offer {
62   OfferStorage public offerStorage;
63   OpenAlexalO public openAlexa;
64 
65   address payable public owner;
66 
67   struct UserStruct {
68     bool isExist;
69     uint id;
70     uint referrerID;
71     uint currentLevel;
72     uint totalEarningEth;
73     address[] referral;
74     mapping(uint => uint) levelExpired;
75   }
76 
77 
78   mapping(uint => uint) public offerActiveDate;
79 
80   uint public levelOneCashBackId;
81   uint public levelOneCashBackAmt;
82 
83   uint public goLevelSixId;
84   uint public goLevelSixAmt;
85 
86   uint public leadersPoolAmt;
87   uint public leadersPoolId;
88   uint public leadersPoolMaxUsers;
89 
90   event Claimed(address indexed _from, address indexed _to, uint256 _offerId, uint256 _value);
91 
92   modifier onlyActive(uint offerId) {
93     require(offerActiveDate[offerId] < openAlexa.createdDate(msg.sender), "Offer not active for user");
94     _;
95   }
96 
97   constructor(address offerStorageAddress, address payable openAlexaAddress) public {
98 
99     owner = msg.sender;
100 
101     offerStorage = OfferStorage(offerStorageAddress);
102     openAlexa = OpenAlexalO(openAlexaAddress);
103 
104     // unique id for each offer
105     levelOneCashBackId = 1;
106     goLevelSixId = 2;
107     leadersPoolId = 3;
108 
109     levelOneCashBackAmt = 0.03 ether;
110     goLevelSixAmt = 3 ether;
111     leadersPoolAmt = 102 ether;
112 
113     offerActiveDate[levelOneCashBackId] = 1588886820;
114     offerActiveDate[goLevelSixId] = 1588886820;
115     offerActiveDate[leadersPoolId] = 1588886820;
116 
117     leadersPoolMaxUsers = 21;
118 
119   }
120 
121   // stack to deep cant add modifier
122   function levelOneCashBackEligible(address _userAddress) view external
123   returns(
124     string [4] memory  _message,
125     uint _userId,
126     uint _userLevel,
127     uint _createdDate,
128     address[] memory _refs,
129     uint256[4] memory _refDates
130   ) {
131     if(offerActiveDate[levelOneCashBackId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";
132 
133     if (address(this).balance < levelOneCashBackAmt) _message[1] = "Contract Balance Low";
134 
135     if (offerStorage.userOfferClaim(_userAddress, levelOneCashBackId)) _message[2] = "Offer Already claimed";
136 
137     UserStruct memory user;
138     (, user.id, user.referrerID, user.currentLevel, ) = openAlexa.users(_userAddress);
139 
140     if (user.currentLevel < 2) _message[3] = "Level less than 2";
141 
142     // fetch his referrers
143     address[] memory refs = openAlexa.viewUserReferral(_userAddress);
144     uint256[4] memory temprefs;
145 
146     if (refs.length == 2) {
147       UserStruct memory ref1;
148       (, ref1.id, , , ) = openAlexa.users(refs[0]);
149       UserStruct memory ref2;
150       (, ref2.id, , , ) = openAlexa.users(refs[1]);
151       temprefs = [ref1.id, openAlexa.createdDate(refs[0]), ref2.id, openAlexa.createdDate(refs[1])];
152     }
153 
154     return (_message,
155       user.id,
156       user.currentLevel,
157       openAlexa.createdDate(_userAddress),
158       refs,
159       temprefs
160     );
161 
162   }
163 
164 
165   function claimLevelOneCashBack() public {
166     require(offerActiveDate[levelOneCashBackId] < openAlexa.createdDate(msg.sender), "Offer not active for User");
167     // check has claimed
168     require(!offerStorage.userOfferClaim(msg.sender, levelOneCashBackId), "Offer Already Claimed");
169     // check contract has funds
170     require(address(this).balance > levelOneCashBackAmt, "Contract Balance Low, try again after sometime");
171     // fetch his structure
172     UserStruct memory user;
173     (user.isExist,
174       user.id,
175       user.referrerID,
176       user.currentLevel,
177       user.totalEarningEth) = openAlexa.users(msg.sender);
178     // check level at 2
179     require(user.currentLevel >= 2, "Level not upgraded from 1");
180     // fetch his referrers
181     address[] memory children = openAlexa.viewUserReferral(msg.sender);
182     // check they are two
183     require(children.length == 2, "Two downlines not found");
184     // fetch their created at date
185     uint child1Date = openAlexa.createdDate(children[0]);
186     uint child2Date = openAlexa.createdDate(children[1]);
187     // fetch his created at date
188     uint userDate = openAlexa.createdDate(msg.sender);
189     // match date of user with u2 and u3 < 48 hrs
190     require(((child1Date - userDate) < 48 hours) && ((child2Date - userDate) < 48 hours), "Downline not registered within 48 hrs");
191     // all good transfer 0.03ETH
192     require((payable(msg.sender).send(levelOneCashBackAmt)), "Sending Offer Reward Failure");
193     // mark the address for address => (offerid => true/false)
194     require(offerStorage.setUserClaim(msg.sender, levelOneCashBackId, true), "Setting Claim failed");
195     emit Claimed(address(this), msg.sender, levelOneCashBackId, levelOneCashBackAmt);
196   }
197 
198   function getLine6Users(address[] memory users) public view returns(address[] memory) {
199 
200     uint level = 0;
201     uint totalLevels = 5;
202 
203     uint8[5] memory levelPartners = [4, 8, 16, 32, 64];
204 
205     address[] memory result = new address[](64);
206 
207     while (level < totalLevels) {
208       if(users.length == 0) return result;    
209       users = getEachLevelUsers(users, levelPartners[level]);
210       if (level == 4)
211         result = users;
212       level++;
213     }
214 
215     return result;
216 
217   }
218 
219   function getEachLevelUsers(address[] memory users, uint limit) public view returns(address[] memory) {
220     address[] memory total = new address[](limit);
221     uint index = 0;
222 
223     for (uint i = 0; i < users.length; i++) {
224       if (users[i] == address(0)) break;
225       address[] memory children = openAlexa.viewUserReferral(users[i]);
226       for (uint j = 0; j < children.length; j++) {
227         if (children[j] == address(0)) break;
228         total[index] = children[j];
229         index++;
230       }
231     }
232     return total;
233 
234   }
235 
236   function goLevelSixEligible(address _userAddress) view external
237   returns(
238     string [4] memory _message,
239     uint _userId,
240     uint _currentLevel,
241     address[] memory _refs,
242     address[] memory _lineSixrefs,
243     bool lineSixComplete
244   ) {
245     // string [4] memory message;
246     if(offerActiveDate[goLevelSixId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";
247      // check contract has funds
248     if (address(this).balance < goLevelSixAmt) _message[1] = "Contract Balance Low, try again after sometime";
249     // check has claimed
250     if (offerStorage.userOfferClaim(_userAddress, goLevelSixId)) _message[2] = "Offer Already Claimed";
251 
252     // fetch his structure
253     UserStruct memory user;
254     (, user.id,, user.currentLevel, ) = openAlexa.users(_userAddress);
255     // check level at 6
256     if (user.currentLevel < 4) _message[3] = "Minimum level 4 required";
257     // get referrals
258     address[] memory refs = openAlexa.viewUserReferral(_userAddress);
259     // refs at level 6
260     address[] memory lineSixrefs = getLine6Users(refs);
261 
262     return (_message,
263       user.id,
264       user.currentLevel,
265       refs,
266       lineSixrefs,
267       checkOfferClaimed(lineSixrefs, levelOneCashBackId)
268     );
269 
270   }
271 
272   function claimGoLevelSix() public {
273     require(offerActiveDate[goLevelSixId] < openAlexa.createdDate(msg.sender), "Offer not active for User");
274     // check has claimed
275     require(!offerStorage.userOfferClaim(msg.sender, goLevelSixId), "Offer Already claimed");
276     // check contract has funds
277     require(address(this).balance > goLevelSixAmt, "Contract Balance Low, try again after sometime");
278     // fetch his structure
279     UserStruct memory user;
280     (user.isExist,
281       user.id,
282       user.referrerID,
283       user.currentLevel,
284       user.totalEarningEth) = openAlexa.users(msg.sender);
285     // check level
286     require(user.currentLevel >= 4, "Minimum level expected is 4");
287     // get user register date
288     uint userDate = openAlexa.createdDate(msg.sender);
289     // match date of user with u2 and u3 < 48 hrs
290     require(((now - userDate) < 12 days), "User registration date passed 12 days");
291     // get referrals
292     address[] memory children = openAlexa.viewUserReferral(msg.sender);
293     // children at level 6
294     address[] memory line6children = getLine6Users(children);
295     // check they took offer 1
296     require(checkOfferClaimed(line6children, levelOneCashBackId), "Level 6 partners not claimed cashback offer");
297     // all good transfer 0.03ETH
298     require((payable(msg.sender).send(goLevelSixAmt)), "Sending Offer Failure");
299     // mark the address for address => (offerid => true/false)
300     require(offerStorage.setUserClaim(msg.sender, goLevelSixId, true), "Setting Claim failed");
301     emit Claimed(address(this), msg.sender, goLevelSixId, goLevelSixAmt);
302   }
303 
304   function leadersPoolEligible(address _userAddress) view external returns(
305     string [4] memory _message,
306     uint _userId,
307     uint _earnedEth,
308     uint _totalClaims,
309     uint _maxClaims,
310     uint _OfferAmt
311   ) {
312     if(offerActiveDate[leadersPoolId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";
313     UserStruct memory user;
314     (, user.id, , , user.totalEarningEth) = openAlexa.users(_userAddress);
315     if(offerStorage.getClaimedUsersLength(leadersPoolId) >= (leadersPoolMaxUsers)) _message[1] = "Offer Max users reached";
316     if (offerStorage.userOfferClaim(_userAddress, goLevelSixId)) _message[2] = "Offer Already Claimed";
317     if(user.totalEarningEth < leadersPoolAmt) _message[3] = "Earned ETH less than offer amount";
318     return (
319       _message,
320       user.id,
321       user.totalEarningEth,
322       offerStorage.getClaimedUsersLength(leadersPoolId),
323       leadersPoolMaxUsers,
324       leadersPoolAmt
325     );
326   }
327 
328   function claimLeadersPool() public {
329     require(offerActiveDate[leadersPoolId] < openAlexa.createdDate(msg.sender), "Offer not active for user");
330     require(!offerStorage.userOfferClaim(msg.sender, leadersPoolId), "Offer Already Claimed");
331     require(offerStorage.getClaimedUsersLength(leadersPoolId) < leadersPoolMaxUsers, "Offer claimed by max users");
332     // fetch his structure
333     UserStruct memory user;
334     (user.isExist,
335       user.id,
336       user.referrerID,
337       user.currentLevel,
338       user.totalEarningEth) = openAlexa.users(msg.sender);
339     require(user.currentLevel >= 1, "Minimum level expected is 1");
340     require(user.totalEarningEth >= leadersPoolAmt, "Earned ether less than required amount");
341     require(offerStorage.setUserClaim(msg.sender, leadersPoolId, true), "Setting Claim failed");
342     emit Claimed(address(this), msg.sender, leadersPoolId, leadersPoolAmt);
343 
344   }
345 
346   function checkOfferClaimed(address[] memory user, uint offerId) public view returns(bool) {
347     bool claimed;
348     for (uint i = 0; i < user.length; i++) {
349       claimed = true;
350       if (!offerStorage.userOfferClaim(user[i], offerId)) {
351         claimed = false;
352         break;
353       }
354     }
355 
356     return claimed;
357   }
358 
359   function getOfferClaimedUser(address userAddress, uint offerId) public view returns(
360       bool _isClaimed,
361       uint _userId,
362       uint _currentLevel,
363       uint _earnedEth,
364       uint _createdDate
365       ) {
366 
367     UserStruct memory user;
368     (, user.id, ,user.currentLevel,user.totalEarningEth) = openAlexa.users(userAddress);
369 
370     return (
371         offerStorage.userOfferClaim(userAddress, offerId),
372         user.id,
373         user.currentLevel,
374         user.totalEarningEth,
375         openAlexa.createdDate(userAddress)
376         );
377   }
378 
379   function addressToUser(address _user) public view returns(
380     bool _isExist,
381     uint _userId,
382     uint _refId,
383     uint _currentLevel,
384     uint _totalEarningEth,
385     uint _createdDate
386   ) {
387     UserStruct memory user;
388     (user.isExist,
389       user.id,
390       user.referrerID,
391       user.currentLevel,
392       user.totalEarningEth) = openAlexa.users(_user);
393 
394 
395     return (
396       user.isExist,
397       user.id,
398       user.referrerID,
399       user.currentLevel,
400       user.totalEarningEth,
401       openAlexa.createdDate(_user)
402     );
403   }
404   
405   function userIDtoAddress(uint _id) public view returns(address _userAddress){
406       return openAlexa.userList(_id);
407   }
408 
409   function getUserByOfferId(uint offerId, uint index) public view returns(
410     uint _length,
411     address _address
412   ) {
413     return (
414       offerStorage.getClaimedUsersLength(offerId),
415       offerStorage.claimedUsers(offerId, index)
416     );
417   }
418 
419 
420   function changeOfferDetails(uint _levelOneCashBackAmt, uint _goLevelSixAmt, uint _leadersPoolAmt, uint _leadersPoolMaxUsers) public {
421     require(msg.sender == owner, "Owner only!");
422     levelOneCashBackAmt = _levelOneCashBackAmt;
423     goLevelSixAmt = _goLevelSixAmt;
424     leadersPoolAmt = _leadersPoolAmt;
425     leadersPoolMaxUsers = _leadersPoolMaxUsers;
426   }
427 
428   function changeOfferActive(uint offerId, uint _startDate) public {
429     require(msg.sender == owner, "Owner only!");
430     offerActiveDate[offerId] = _startDate;
431   }
432 
433   function withdraw() public {
434     require(msg.sender == owner, "Owner only!");
435     owner.transfer(address(this).balance);
436   }
437   
438   function changeOwner(address payable newowner) public {
439     require(msg.sender == owner, "Owner only!");
440     owner = newowner;
441   }
442 
443   receive () payable external {
444     require(msg.sender == owner, "Owner only!");
445   }
446 
447 }