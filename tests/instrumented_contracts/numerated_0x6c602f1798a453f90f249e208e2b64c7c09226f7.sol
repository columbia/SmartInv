1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
80 
81 /**
82  * @title Helps contracts guard against reentrancy attacks.
83  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
84  * @dev If you mark a function `nonReentrant`, you should also
85  * mark it `external`.
86  */
87 contract ReentrancyGuard {
88 
89   /// @dev counter to allow mutex lock with only one SSTORE operation
90   uint256 private _guardCounter;
91 
92   constructor() internal {
93     // The counter starts at one to prevent changing it from zero to a non-zero
94     // value, which is a more expensive operation.
95     _guardCounter = 1;
96   }
97 
98   /**
99    * @dev Prevents a contract from calling itself, directly or indirectly.
100    * Calling a `nonReentrant` function from another `nonReentrant`
101    * function is not supported. It is possible to prevent this from happening
102    * by making the `nonReentrant` function external, and make it call a
103    * `private` function that does the actual work.
104    */
105   modifier nonReentrant() {
106     _guardCounter += 1;
107     uint256 localCounter = _guardCounter;
108     _;
109     require(localCounter == _guardCounter);
110   }
111 
112 }
113 
114 // File: node_modules/openzeppelin-solidity/contracts/math/Safemath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 interface IERC20 {
187   function totalSupply() external view returns (uint256);
188 
189   function balanceOf(address who) external view returns (uint256);
190 
191   function allowance(address owner, address spender)
192     external view returns (uint256);
193 
194   function transfer(address to, uint256 value) external returns (bool);
195 
196   function approve(address spender, uint256 value)
197     external returns (bool);
198 
199   function transferFrom(address from, address to, uint256 value)
200     external returns (bool);
201 
202   event Transfer(
203     address indexed from,
204     address indexed to,
205     uint256 value
206   );
207 
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 // File: lib/CanReclaimToken.sol
216 
217 /**
218  * @title Contracts that should be able to recover tokens
219  * @author SylTi
220  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
221  * This will prevent any accidental loss of tokens.
222  */
223 contract CanReclaimToken is Ownable {
224 
225   /**
226    * @dev Reclaim all ERC20 compatible tokens
227    * @param token ERC20 The address of the token contract
228    */
229   function reclaimToken(IERC20 token) external onlyOwner {
230     if (address(token) == address(0)) {
231       owner().transfer(address(this).balance);
232       return;
233     }
234     uint256 balance = token.balanceOf(this);
235     token.transfer(owner(), balance);
236   }
237 
238 }
239 
240 // File: contracts/Mentoring.sol
241 
242 interface HEROES {
243   function getLevel(uint256 tokenId) external view returns (uint256);
244   function getGenes(uint256 tokenId) external view returns (uint256);
245   function getRace(uint256 tokenId) external view returns (uint256);
246   function lock(uint256 tokenId, uint256 lockedTo, bool onlyFreeze) external returns (bool);
247   function unlock(uint256 tokenId) external returns (bool);
248   function ownerOf(uint256 tokenId) external view returns (address);
249   function isCallerAgentOf(uint tokenId) external view returns (bool);
250   function addWin(uint256 tokenId, uint winsCount, uint levelUp) external returns (bool);
251   function addLoss(uint256 tokenId, uint256 lossesCount, uint levelDown) external returns (bool);
252 }
253 
254 
255 contract Mentoring is Ownable, ReentrancyGuard, CanReclaimToken  {
256   using SafeMath for uint256;
257 
258   event BecomeMentor(uint256 indexed mentorId);
259   event BreakMentoring(uint256 indexed mentorId);
260   event ChangeLevelPrice(uint256 indexed mentorId, uint256 newLevelPrice);
261   event Income(address source, uint256 amount);
262 
263   event StartLecture(uint256 indexed lectureId,
264     uint256 indexed mentorId,
265     uint256 indexed studentId,
266     uint256 mentorLevel,
267     uint256 studentLevel,
268     uint256 levelUp,
269     uint256 levelPrice,
270     uint256 startedAt,
271     uint256 endsAt);
272 
273 //  event Withdraw(address to, uint256 amount);
274 
275   struct Lecture {
276     uint256 mentorId;
277     uint256 studentId;
278     uint256 mentorLevel;
279     uint256 studentLevel;
280     uint256 levelUp;
281     uint256 levelPrice;
282 //    uint256 cost;
283     uint256 startedAt;
284     uint256 endsAt;
285   }
286 
287   HEROES public heroes;
288 
289   uint256 public fee = 290; //2.9%
290   uint256 public levelUpTime = 20 minutes;
291 
292   mapping(uint256 => uint256) internal prices;
293 
294   Lecture[] internal lectures;
295   /* tokenId => lecture index */
296   mapping(uint256 => uint256[]) studentToLecture;
297   mapping(uint256 => uint256[]) mentorToLecture;
298 
299   modifier onlyOwnerOf(uint256 _tokenId) {
300     require(heroes.ownerOf(_tokenId) == msg.sender);
301     _;
302   }
303 
304   constructor (HEROES _heroes) public {
305     require(address(_heroes) != address(0));
306     heroes = _heroes;
307 
308     //fix lectureId issue - add zero lecture
309     lectures.length = 1;
310   }
311 
312   /// @notice The fallback function payable
313   function() external payable {
314     require(msg.value > 0);
315     _flushBalance();
316   }
317 
318   function _flushBalance() private {
319     uint256 balance = address(this).balance;
320     if (balance > 0) {
321       address(heroes).transfer(balance);
322       emit Income(address(this), balance);
323     }
324   }
325 
326 
327   function _distributePayment(address _account, uint256 _amount) internal {
328     uint256 pcnt = _getPercent(_amount, fee);
329     uint256 amount = _amount.sub(pcnt);
330     _account.transfer(amount);
331   }
332 
333   /**
334    * Set fee
335    */
336   function setFee(uint256 _fee) external onlyOwner
337   {
338     fee = _fee;
339   }
340 
341   // MENTORING
342 
343   /**
344    * Set the one level up time
345    */
346 
347   function setLevelUpTime(uint256 _newLevelUpTime) external onlyOwner
348   {
349     levelUpTime = _newLevelUpTime;
350   }
351 
352   function isMentor(uint256 _mentorId) public view returns (bool)
353   {
354     //проверяем установлена ли цена обучения и текущий агент пресонажа =менторство
355     return heroes.isCallerAgentOf(_mentorId); // && prices[_mentorId] != 0;
356   }
357 
358   function inStudying(uint256 _tokenId) public view returns (bool) {
359     return now <= lectures[getLastLectureIdAsStudent(_tokenId)].endsAt;
360   }
361 
362   function inMentoring(uint256 _tokenId) public view returns (bool) {
363     return now <= lectures[getLastLectureIdAsMentor(_tokenId)].endsAt;
364   }
365 
366   function inLecture(uint256 _tokenId) public view returns (bool)
367   {
368     return inMentoring(_tokenId) || inStudying(_tokenId);
369   }
370 
371   /**
372    * Set the character as mentor
373    */
374   function becomeMentor(uint256 _mentorId, uint256 _levelPrice) external onlyOwnerOf(_mentorId) {
375     require(_levelPrice > 0);
376     require(heroes.lock(_mentorId, 0, false));
377     prices[_mentorId] = _levelPrice;
378     emit BecomeMentor(_mentorId);
379     emit ChangeLevelPrice(_mentorId, _levelPrice);
380   }
381 
382   /**
383    * Change price
384    */
385   function changeLevelPrice(uint256 _mentorId, uint256 _levelPrice) external onlyOwnerOf(_mentorId) {
386     require(_levelPrice > 0);
387     require(isMentor(_mentorId));
388     prices[_mentorId] = _levelPrice;
389     emit ChangeLevelPrice(_mentorId, _levelPrice);
390   }
391 
392   /**
393    * Break mentoring for character
394    */
395   function breakMentoring(uint256 _mentorId) external onlyOwnerOf(_mentorId)
396   {
397     require(heroes.unlock(_mentorId));
398     emit BreakMentoring(_mentorId);
399   }
400 
401   function getMentor(uint256 _mentorId) external view returns (uint256 level, uint256 price) {
402     require(isMentor(_mentorId));
403     return (heroes.getLevel(_mentorId), prices[_mentorId]);
404   }
405 
406   function _calcLevelIncrease(uint256 _mentorLevel, uint256 _studentLevel) internal pure returns (uint256) {
407     if (_mentorLevel < _studentLevel) {
408       return 0;
409     }
410     uint256 levelDiff = _mentorLevel - _studentLevel;
411     return (levelDiff >> 1) + (levelDiff & 1);
412   }
413 
414   /**
415    * calc full cost of study
416    */
417   function calcCost(uint256 _mentorId, uint256 _studentId) external view returns (uint256) {
418     uint256 levelUp = _calcLevelIncrease(heroes.getLevel(_mentorId), heroes.getLevel(_studentId));
419     return levelUp.mul(prices[_mentorId]);
420   }
421 
422   function isRaceSuitable(uint256 _mentorId, uint256 _studentId) public view returns (bool) {
423     uint256 mentorRace = heroes.getGenes(_mentorId) & 0xFFFF;
424     uint256 studentRace = heroes.getGenes(_studentId) & 0xFFFF;
425     return (mentorRace == 1 || mentorRace == studentRace);
426   }
427 
428   /**
429    * Start the study
430    */
431   function startLecture(uint256 _mentorId, uint256 _studentId) external payable onlyOwnerOf(_studentId) {
432     require(isMentor(_mentorId));
433 
434     // Check race
435     require(isRaceSuitable(_mentorId, _studentId));
436 
437     uint256 mentorLevel = heroes.getLevel(_mentorId);
438     uint256 studentLevel = heroes.getLevel(_studentId);
439 
440     uint256 levelUp = _calcLevelIncrease(mentorLevel, studentLevel);
441     require(levelUp > 0);
442 
443     // check sum is enough
444     uint256 cost = levelUp.mul(prices[_mentorId]);
445     require(cost == msg.value);
446 
447     Lecture memory lecture = Lecture({
448       mentorId : _mentorId,
449       studentId : _studentId,
450       mentorLevel: mentorLevel,
451       studentLevel: studentLevel,
452       levelUp: levelUp,
453       levelPrice : prices[_mentorId],
454       startedAt : now,
455       endsAt : now + levelUp.mul(levelUpTime)
456       });
457 
458     //locking mentor
459     require(heroes.lock(_mentorId, lecture.endsAt, true));
460 
461     //locking student
462     require(heroes.lock(_studentId, lecture.endsAt, true));
463 
464 
465     //save lecture
466     //id starts from 1
467     uint256 lectureId = lectures.push(lecture) - 1;
468 
469     studentToLecture[_studentId].push(lectureId);
470     mentorToLecture[_mentorId].push(lectureId);
471 
472     heroes.addWin(_studentId, 0, levelUp);
473 
474     emit StartLecture(
475       lectureId,
476       _mentorId,
477       _studentId,
478       lecture.mentorLevel,
479       lecture.studentLevel,
480       lecture.levelUp,
481       lecture.levelPrice,
482       lecture.startedAt,
483       lecture.endsAt
484     );
485 
486     _distributePayment(heroes.ownerOf(_mentorId), cost);
487 
488     _flushBalance();
489   }
490 
491   function lectureExists(uint256 _lectureId) public view returns (bool)
492   {
493     return (_lectureId > 0 && _lectureId < lectures.length);
494   }
495 
496   function getLecture(uint256 lectureId) external view returns (
497     uint256 mentorId,
498     uint256 studentId,
499     uint256 mentorLevel,
500     uint256 studentLevel,
501     uint256 levelUp,
502     uint256 levelPrice,
503     uint256 cost,
504     uint256 startedAt,
505     uint256 endsAt)
506   {
507     require(lectureExists(lectureId));
508     Lecture memory l = lectures[lectureId];
509     return (l.mentorId, l.studentId, l.mentorLevel, l.studentLevel, l.levelUp, l.levelPrice, l.levelUp.mul(l.levelPrice), l.startedAt, l.endsAt);
510   }
511 
512   function getLastLectureIdAsMentor(uint256 _tokenId) public view returns (uint256) {
513     return mentorToLecture[_tokenId].length > 0 ? mentorToLecture[_tokenId][mentorToLecture[_tokenId].length - 1] : 0;
514   }
515   function getLastLectureIdAsStudent(uint256 _tokenId) public view returns (uint256) {
516     return studentToLecture[_tokenId].length > 0 ? studentToLecture[_tokenId][studentToLecture[_tokenId].length - 1] : 0;
517   }
518  
519 
520   function getLastLecture(uint256 tokenId) external view returns (
521     uint256 lectureId,
522     uint256 mentorId,
523     uint256 studentId,
524     uint256 mentorLevel,
525     uint256 studentLevel,
526     uint256 levelUp,
527     uint256 levelPrice,
528     uint256 cost,
529     uint256 startedAt,
530     uint256 endsAt)
531   {
532     uint256 mentorLectureId = getLastLectureIdAsMentor(tokenId);
533     uint256 studentLectureId = getLastLectureIdAsStudent(tokenId);
534     lectureId = studentLectureId > mentorLectureId ? studentLectureId : mentorLectureId;
535     require(lectureExists(lectureId));
536     Lecture storage l = lectures[lectureId];
537     return (lectureId, l.mentorId, l.studentId, l.mentorLevel, l.studentLevel, l.levelUp, l.levelPrice, l.levelUp.mul(l.levelPrice), l.startedAt, l.endsAt);
538   }
539 
540   //// SERVICE
541   //1% - 100, 10% - 1000 50% - 5000
542   function _getPercent(uint256 _v, uint256 _p) internal pure returns (uint)    {
543     return _v.mul(_p).div(10000);
544   }
545 }