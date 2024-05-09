1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _setOwner(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _setOwner(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _setOwner(newOwner);
83     }
84 
85     function _setOwner(address newOwner) private {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations.
98  *
99  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
100  * now has built in overflow checking.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, with an overflow flag.
105      *
106      * _Available since v3.4._
107      */
108     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             uint256 c = a + b;
111             if (c < a) return (false, 0);
112             return (true, c);
113         }
114     }
115 
116     /**
117      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
118      *
119      * _Available since v3.4._
120      */
121     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             if (b > a) return (false, 0);
124             return (true, a - b);
125         }
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136             // benefit is lost if 'b' is also tested.
137             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138             if (a == 0) return (true, 0);
139             uint256 c = a * b;
140             if (c / a != b) return (false, 0);
141             return (true, c);
142         }
143     }
144 
145     /**
146      * @dev Returns the division of two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a / b);
154         }
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             if (b == 0) return (false, 0);
165             return (true, a % b);
166         }
167     }
168 
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      *
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a + b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting on
185      * overflow (when the result is negative).
186      *
187      * Counterpart to Solidity's `-` operator.
188      *
189      * Requirements:
190      *
191      * - Subtraction cannot overflow.
192      */
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a - b;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a * b;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers, reverting on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator.
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a % b;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243      * overflow (when the result is negative).
244      *
245      * CAUTION: This function is deprecated because it requires allocating memory for the error
246      * message unnecessarily. For custom revert reasons use {trySub}.
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      *
252      * - Subtraction cannot overflow.
253      */
254     function sub(
255         uint256 a,
256         uint256 b,
257         string memory errorMessage
258     ) internal pure returns (uint256) {
259         unchecked {
260             require(b <= a, errorMessage);
261             return a - b;
262         }
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(
278         uint256 a,
279         uint256 b,
280         string memory errorMessage
281     ) internal pure returns (uint256) {
282         unchecked {
283             require(b > 0, errorMessage);
284             return a / b;
285         }
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * reverting with custom message when dividing by zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryMod}.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b > 0, errorMessage);
310             return a % b;
311         }
312     }
313 }
314 
315 
316 contract Traitsniffer is Ownable {
317     uint256 public trialPrice = 100000000000000000;
318     uint256 constant private DAY_IN_UNIX = 86400;
319     uint256 private trialTimestamp = 3600;
320     bool public trialIsActive = false;
321     bool public saleIsActive = false;
322 
323     mapping (address => bool) private whitelisted;
324     mapping (address => uint256) private userToTimeRegistered;
325     mapping (address => uint256) private trialToTime;
326 
327     address[] private registeredAddresses;
328     Subscription[] private subscriptionPlans;
329 
330     struct Subscription {
331         uint _price;
332         uint _days;
333     }
334 
335     constructor() {
336         subscriptionPlans.push(Subscription(300000000000000000,14));
337         subscriptionPlans.push(Subscription(500000000000000000,30));
338         subscriptionPlans.push(Subscription(800000000000000000,60));
339     }
340 
341     function register(uint _id) public payable {
342         require(msg.value == getPrice(_id), "Incorrect ETH value");
343         require(saleIsActive, "Sale not active");
344         require(subscriptionPlans[_id]._days > 0, "ID does not exist");
345         require(userToTimeRegistered[msg.sender] == 0, "Already registered");
346         require(whitelisted[msg.sender] == false, "Already whitelisted");
347 
348         registeredAddresses.push(msg.sender);
349         userToTimeRegistered[msg.sender] = block.timestamp + (DAY_IN_UNIX * subscriptionPlans[_id]._days);
350     }
351 
352     function updateSubscription(uint _id) public payable{
353         require(msg.value == getPrice(_id), "Incorrect ETH value");
354         require(subscriptionPlans[_id]._days > 0, "ID does not exist.");
355 
356         uint256 expireTime = userToTimeRegistered[msg.sender];
357         uint256 timestamp = block.timestamp;
358         require(saleIsActive || expireTime > timestamp, "Max users reached");
359         require(expireTime > 1, "User must register first");
360 
361         if (expireTime < timestamp) {
362             // Previous subscription has expired
363             userToTimeRegistered[msg.sender] = timestamp + (DAY_IN_UNIX * subscriptionPlans[_id]._days);
364         } else {
365             // Still has an active subscription but wants to add time
366             userToTimeRegistered[msg.sender] = expireTime + (DAY_IN_UNIX * subscriptionPlans[_id]._days);
367         }
368     }
369 
370     function buyTrial() public payable {
371         require(trialIsActive, "Trial buying closed");
372         require(msg.value == trialPrice, "Incorrect ETH value");
373 
374         trialToTime[msg.sender] = block.timestamp + trialTimestamp;
375     }
376 
377     function migrateExistingUsers(address[] memory _addresses, uint256[] memory _timestamps) external onlyOwner {
378         for (uint i = 0; i < _addresses.length; i++) {
379             registeredAddresses.push(_addresses[i]);
380             userToTimeRegistered[_addresses[i]] = _timestamps[i];
381         }
382     }
383 
384     function flipTrialState() external onlyOwner {
385         trialIsActive = !trialIsActive;
386     }
387 
388     function flipSaleState() external onlyOwner {
389             saleIsActive = !saleIsActive;
390     }
391 
392     function isTrial(address _address) external view returns (bool) {
393         return trialToTime[_address] > block.timestamp;
394     }
395 
396     function hasAccess(address _address) external view returns (bool) {
397         return userToTimeRegistered[_address] > block.timestamp ||
398                 whitelisted[_address] == true ||
399                 trialToTime[_address] > block.timestamp;
400     }
401 
402     function getTimestamp(address _address) external view returns (uint256) {
403         if (whitelisted[_address] == true) {
404             return 1;
405         } else if (trialToTime[_address] > block.timestamp){
406             return trialToTime[_address];
407         } else {
408             return userToTimeRegistered[_address];
409         }
410     }
411 
412     function getActiveSubCount() public view returns(uint) {
413         uint activeSubCount;
414         uint256 timestamp = block.timestamp;
415         for(uint i = 0; i < registeredAddresses.length; i++) {
416             if (userToTimeRegistered[registeredAddresses[i]] > timestamp) {
417                 activeSubCount++;
418             }
419         }
420         return activeSubCount;
421     }
422 
423     function getAllSubscribers() external view returns (address[] memory) {
424         uint count = getActiveSubCount();
425         address [] memory activeUsers = new address[](count);
426         uint x;
427         uint256 timestamp = block.timestamp;
428 
429         for(uint i = 0; i < registeredAddresses.length; i++) {
430             address current = registeredAddresses[i];
431             if (userToTimeRegistered[current] > timestamp) {
432                 activeUsers[x++] = current;
433             }
434         }
435         return activeUsers;
436     }
437 
438     function getWhitelisted() external view returns(address[] memory) {
439         uint whitelistedCount;
440         for(uint i = 0; i < registeredAddresses.length; i++) {
441             if (whitelisted[registeredAddresses[i]] == true) {
442                 whitelistedCount++;
443             }
444         }
445         uint count = whitelistedCount;
446         address[] memory whitelistedUsers = new address[](count);
447 
448         uint x;
449         for (uint i = 0; i < registeredAddresses.length; i++) {
450             address current = registeredAddresses[i];
451             if (whitelisted[current] == true) {
452                 whitelistedUsers[x] = current;
453                 x++;
454             }
455         }
456         return whitelistedUsers;
457     }
458 
459     function getPrice(uint _id) public view returns(uint256) {
460         return subscriptionPlans[_id]._price;
461     }
462 
463     function setPrice(uint _planId, uint256 _price) public onlyOwner {
464         subscriptionPlans[_planId]._price = _price;
465     }
466 
467     function setTrialPeriod(uint256 _time) external onlyOwner {
468         trialTimestamp = _time;
469     }
470 
471     function setTrialPrice(uint256 _price) external onlyOwner {
472         trialPrice = _price;
473     }
474 
475     function giveTrial(address _address, uint256 _timestamp) external onlyOwner {
476         trialToTime[_address] = _timestamp;
477     }
478 
479     function setTimestampForAddress(address _address, uint256 _timestamp) external onlyOwner {
480         if (userToTimeRegistered[_address] == 0) {
481             registeredAddresses.push(_address);
482         }
483         userToTimeRegistered[_address] = _timestamp;
484     }
485 
486     function whitelistAddress(address _address) external onlyOwner {
487         require(whitelisted[_address] == false, "Already whitelisted");
488         if (userToTimeRegistered[_address] == 0) {
489             registeredAddresses.push(_address);
490         }
491         whitelisted[_address] = true;
492     }
493 
494     function removeAddressFromWhitelist(address _address) external onlyOwner {
495         require(whitelisted[_address] == true, "Not whitelisted");
496         delete whitelisted[_address];
497     }
498 
499     function isRegistered(address _address) public view returns (bool) {
500         for(uint i = 0; i < registeredAddresses.length; i++) {
501             if (registeredAddresses[i] == _address ) {
502                 return true;
503             }
504         }
505         return false;
506     }
507 
508     function isWhitelisted(address _address) external view returns (bool) {
509         return whitelisted[_address];
510     }
511 
512     function withdraw() public onlyOwner {
513         uint balance = address(this).balance;
514         payable(msg.sender).transfer(balance);
515     }
516 }