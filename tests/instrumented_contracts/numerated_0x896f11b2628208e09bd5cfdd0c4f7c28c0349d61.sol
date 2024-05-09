1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address private _owner;
78 
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() internal {
89     _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipTransferred(_owner, address(0));
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 // File: contracts/CoinPledge.sol
146 
147 /// @title CoinPledge
148 /// @author Igor Yalovoy
149 /// @notice Reach your goals and have fun with friends
150 /// @dev All function calls are currently implement without side effects
151 /// @web: ylv.io
152 /// @email: to@ylv.io
153 /// @gitHub: https://github.com/ylv-io/coinpledge/tree/master
154 /// @twitter: https://twitter.com/ylv_io
155 
156 // Proofs:
157 // Public commitment as a motivator for weight loss (https://onlinelibrary.wiley.com/doi/pdf/10.1002/mar.20316)
158 
159 
160 pragma solidity ^0.4.24;
161 
162 
163 
164 contract CoinPledge is Ownable {
165 
166   using SafeMath for uint256;
167 
168   uint constant daysToResolve = 7 days;
169   uint constant bonusPercentage = 50;
170   uint constant serviceFeePercentage = 10;
171   uint constant minBonus = 1 finney;
172 
173   struct Challenge {
174     address user;
175     string name;
176     uint value;
177     address mentor;
178     uint startDate;
179     uint time;
180     uint mentorFee;
181 
182     bool successed;
183     bool resolved;
184   }
185 
186   struct User {
187     address addr;
188     string name;
189   }
190 
191   // Events
192   event NewChallenge(
193     uint indexed challengeId,
194     address indexed user,
195     string name,
196     uint value,
197     address indexed mentor,
198     uint startDate,
199     uint time,
200     uint mentorFee
201   );
202 
203   event ChallengeResolved(
204     uint indexed challengeId,
205     address indexed user,
206     address indexed mentor,
207     bool decision
208   );
209 
210   event BonusFundChanged(
211     address indexed user,
212     uint value
213   );
214 
215   event NewUsername(
216     address indexed addr,
217     string name
218   );
219 
220 
221   event Donation(
222     string name,
223     string url,
224     uint value,
225     uint timestamp
226   );
227 
228   /// @notice indicated is game over or not
229   bool public isGameOver;
230 
231   /// @notice All Challenges
232   Challenge[] public challenges;
233 
234   mapping(uint => address) public challengeToUser;
235   mapping(address => uint) public userToChallengeCount;
236 
237   mapping(uint => address) public challengeToMentor;
238   mapping(address => uint) public mentorToChallengeCount;
239 
240   /// @notice All Users
241   mapping(address => User) public users;
242   address[] public allUsers;
243   mapping(string => address) private usernameToAddress;
244   
245   /// @notice User's bonuses
246   mapping(address => uint) public bonusFund;
247 
248   /// @notice Can access only if game is not over
249   modifier gameIsNotOver() {
250     require(!isGameOver, "Game should be not over");
251     _;
252   }
253 
254   /// @notice Can access only if game is over
255   modifier gameIsOver() {
256     require(isGameOver, "Game should be over");
257     _;
258   }
259 
260   /// @notice Get Bonus Fund For User
261   function getBonusFund(address user)
262   external
263   view
264   returns(uint) {
265     return bonusFund[user];
266   }
267 
268   /// @notice Get Users Lenght
269   function getUsersCount()
270   external
271   view
272   returns(uint) {
273     return allUsers.length;
274   }
275 
276   /// @notice Get Challenges For User
277   function getChallengesForUser(address user)
278   external
279   view
280   returns(uint[]) {
281     require(userToChallengeCount[user] > 0, "Has zero challenges");
282 
283     uint[] memory result = new uint[](userToChallengeCount[user]);
284     uint counter = 0;
285     for (uint i = 0; i < challenges.length; i++) {
286       if (challengeToUser[i] == user)
287       {
288         result[counter] = i;
289         counter++;
290       }
291     }
292     return result;
293   }
294 
295   /// @notice Get Challenges For Mentor
296   function getChallengesForMentor(address mentor)
297   external
298   view
299   returns(uint[]) {
300     require(mentorToChallengeCount[mentor] > 0, "Has zero challenges");
301 
302     uint[] memory result = new uint[](mentorToChallengeCount[mentor]);
303     uint counter = 0;
304     for (uint i = 0; i < challenges.length; i++) {
305       if (challengeToMentor[i] == mentor)
306       {
307         result[counter] = i;
308         counter++;
309       }
310     }
311     return result;
312   }
313   
314   /// @notice Ends game
315   function gameOver()
316   external
317   gameIsNotOver
318   onlyOwner {
319     isGameOver = true;
320   }
321 
322   /// @notice Set Username
323   function setUsername(string name)
324   external
325   gameIsNotOver {
326     require(bytes(name).length > 2, "Provide a name longer than 2 chars");
327     require(bytes(name).length <= 32, "Provide a name shorter than 33 chars");
328     require(users[msg.sender].addr == address(0x0), "You already have a name");
329     require(usernameToAddress[name] == address(0x0), "Name already taken");
330 
331     users[msg.sender] = User(msg.sender, name);
332     usernameToAddress[name] = msg.sender;
333     allUsers.push(msg.sender);
334 
335     emit NewUsername(msg.sender, name);
336   }
337 
338   /// @notice Creates Challenge
339   function createChallenge(string name, string mentor, uint time, uint mentorFee)
340   external
341   payable
342   gameIsNotOver
343   returns (uint retId) {
344     require(msg.value >= 0.01 ether, "Has to stake more than 0.01 ether");
345     require(mentorFee >= 0 ether, "Can't be negative");
346     require(mentorFee <= msg.value, "Can't be bigger than stake");
347     require(bytes(mentor).length > 0, "Has to be a mentor");
348     require(usernameToAddress[mentor] != address(0x0), "Mentor has to be registered");
349     require(time > 0, "Time has to be greater than zero");
350 
351     address mentorAddr = usernameToAddress[mentor];
352 
353     require(msg.sender != mentorAddr, "Can't be mentor to yourself");
354 
355     uint startDate = block.timestamp;
356     uint id = challenges.push(Challenge(msg.sender, name, msg.value, mentorAddr, startDate, time, mentorFee, false, false)) - 1;
357 
358     challengeToUser[id] = msg.sender;
359     userToChallengeCount[msg.sender]++;
360 
361     challengeToMentor[id] = mentorAddr;
362     mentorToChallengeCount[mentorAddr]++;
363 
364     emit NewChallenge(id, msg.sender, name, msg.value, mentorAddr, startDate, time, mentorFee);
365 
366     return id;
367   }
368 
369   /// @notice Resolves Challenge
370   function resolveChallenge(uint challengeId, bool decision)
371   external
372   gameIsNotOver {
373     Challenge storage challenge = challenges[challengeId];
374     
375     require(challenge.resolved == false, "Challenge already resolved.");
376 
377     // if more time passed than endDate + daysToResolve, then user can resolve himself
378     if(block.timestamp < (challenge.startDate + challenge.time + daysToResolve))
379       require(challenge.mentor == msg.sender, "You are not the mentor for this challenge.");
380     else require((challenge.user == msg.sender) || (challenge.mentor == msg.sender), "You are not the user or mentor for this challenge.");
381 
382     uint mentorFee;
383     uint serviceFee;
384     
385     address user = challengeToUser[challengeId];
386     address mentor = challengeToMentor[challengeId];
387 
388     // write decision
389     challenge.successed = decision;
390     challenge.resolved = true;
391 
392     uint remainingValue = challenge.value;
393 
394     // mentor & service fee
395     if(challenge.mentorFee > 0) {
396       serviceFee = challenge.mentorFee.div(100).mul(serviceFeePercentage);
397       mentorFee = challenge.mentorFee.div(100).mul(100 - serviceFeePercentage);
398     }
399     
400     if(challenge.mentorFee > 0)
401       remainingValue = challenge.value.sub(challenge.mentorFee);
402 
403     uint valueToPay;
404 
405     if(decision) {
406       // value to pay back to user
407       valueToPay = remainingValue;
408       // credit bouns if any
409       uint currentBonus = bonusFund[user];
410       if(currentBonus > 0)
411       {
412         uint bonusValue = bonusFund[user].div(100).mul(bonusPercentage);
413         if(currentBonus <= minBonus)
414           bonusValue = currentBonus;
415         bonusFund[user] -= bonusValue;
416         emit BonusFundChanged(user, bonusFund[user]);
417 
418         valueToPay += bonusValue;
419       }
420     }
421     else {
422       bonusFund[user] += remainingValue;
423       emit BonusFundChanged(user, bonusFund[user]);
424     }
425 
426     // pay back to the challenger
427     if(valueToPay > 0)
428       user.transfer(valueToPay);
429 
430     if(mentorFee > 0)
431       mentor.transfer(mentorFee);
432 
433     if(serviceFee > 0)
434       owner().transfer(serviceFee);
435 
436     emit ChallengeResolved(challengeId, user, mentor, decision);
437   }
438 
439   function withdraw()
440   external
441   gameIsOver {
442     require(bonusFund[msg.sender] > 0, "You do not have any funds");
443 
444     uint funds = bonusFund[msg.sender];
445     bonusFund[msg.sender] = 0;
446     msg.sender.transfer(funds);
447   }
448 
449   function donate(string name, string url)
450   external
451   payable
452   gameIsNotOver {
453     owner().transfer(msg.value);
454     emit Donation(name, url, msg.value, block.timestamp);
455   }
456 }