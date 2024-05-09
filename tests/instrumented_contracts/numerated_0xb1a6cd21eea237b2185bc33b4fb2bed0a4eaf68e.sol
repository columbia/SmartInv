1 pragma solidity 0.6.11;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @dev Library for managing
37  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
38  * types.
39  *
40  * Sets have the following properties:
41  *
42  * - Elements are added, removed, and checked for existence in constant time
43  * (O(1)).
44  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
45  *
46  * ```
47  * contract Example {
48  *     // Add the library methods
49  *     using EnumerableSet for EnumerableSet.AddressSet;
50  *
51  *     // Declare a set state variable
52  *     EnumerableSet.AddressSet private mySet;
53  * }
54  * ```
55  *
56  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
57  * (`UintSet`) are supported.
58  */
59 library EnumerableSet {
60     // To implement this library for multiple types with as little code
61     // repetition as possible, we write it in terms of a generic Set type with
62     // bytes32 values.
63     // The Set implementation uses private functions, and user-facing
64     // implementations (such as AddressSet) are just wrappers around the
65     // underlying Set.
66     // This means that we can only create new EnumerableSets for types that fit
67     // in bytes32.
68 
69     struct Set {
70         // Storage of set values
71         bytes32[] _values;
72 
73         // Position of the value in the `values` array, plus 1 because index 0
74         // means a value is not in the set.
75         mapping (bytes32 => uint256) _indexes;
76     }
77 
78     /**
79      * @dev Add a value to a set. O(1).
80      *
81      * Returns true if the value was added to the set, that is if it was not
82      * already present.
83      */
84     function _add(Set storage set, bytes32 value) private returns (bool) {
85         if (!_contains(set, value)) {
86             set._values.push(value);
87             // The value is stored at length-1, but we add 1 to all indexes
88             // and use 0 as a sentinel value
89             set._indexes[value] = set._values.length;
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     /**
97      * @dev Removes a value from a set. O(1).
98      *
99      * Returns true if the value was removed from the set, that is if it was
100      * present.
101      */
102     function _remove(Set storage set, bytes32 value) private returns (bool) {
103         // We read and store the value's index to prevent multiple reads from the same storage slot
104         uint256 valueIndex = set._indexes[value];
105 
106         if (valueIndex != 0) { // Equivalent to contains(set, value)
107             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
108             // the array, and then remove the last element (sometimes called as 'swap and pop').
109             // This modifies the order of the array, as noted in {at}.
110 
111             uint256 toDeleteIndex = valueIndex - 1;
112             uint256 lastIndex = set._values.length - 1;
113 
114             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
115             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
116 
117             bytes32 lastvalue = set._values[lastIndex];
118 
119             // Move the last value to the index where the value to delete is
120             set._values[toDeleteIndex] = lastvalue;
121             // Update the index for the moved value
122             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
123 
124             // Delete the slot where the moved value was stored
125             set._values.pop();
126 
127             // Delete the index for the deleted slot
128             delete set._indexes[value];
129 
130             return true;
131         } else {
132             return false;
133         }
134     }
135 
136     /**
137      * @dev Returns true if the value is in the set. O(1).
138      */
139     function _contains(Set storage set, bytes32 value) private view returns (bool) {
140         return set._indexes[value] != 0;
141     }
142 
143     /**
144      * @dev Returns the number of values on the set. O(1).
145      */
146     function _length(Set storage set) private view returns (uint256) {
147         return set._values.length;
148     }
149 
150    /**
151     * @dev Returns the value stored at position `index` in the set. O(1).
152     *
153     * Note that there are no guarantees on the ordering of values inside the
154     * array, and it may change when more values are added or removed.
155     *
156     * Requirements:
157     *
158     * - `index` must be strictly less than {length}.
159     */
160     function _at(Set storage set, uint256 index) private view returns (bytes32) {
161         require(set._values.length > index, "EnumerableSet: index out of bounds");
162         return set._values[index];
163     }
164 
165     // AddressSet
166 
167     struct AddressSet {
168         Set _inner;
169     }
170 
171     /**
172      * @dev Add a value to a set. O(1).
173      *
174      * Returns true if the value was added to the set, that is if it was not
175      * already present.
176      */
177     function add(AddressSet storage set, address value) internal returns (bool) {
178         return _add(set._inner, bytes32(uint256(value)));
179     }
180 
181     /**
182      * @dev Removes a value from a set. O(1).
183      *
184      * Returns true if the value was removed from the set, that is if it was
185      * present.
186      */
187     function remove(AddressSet storage set, address value) internal returns (bool) {
188         return _remove(set._inner, bytes32(uint256(value)));
189     }
190 
191     /**
192      * @dev Returns true if the value is in the set. O(1).
193      */
194     function contains(AddressSet storage set, address value) internal view returns (bool) {
195         return _contains(set._inner, bytes32(uint256(value)));
196     }
197 
198     /**
199      * @dev Returns the number of values in the set. O(1).
200      */
201     function length(AddressSet storage set) internal view returns (uint256) {
202         return _length(set._inner);
203     }
204 
205    /**
206     * @dev Returns the value stored at position `index` in the set. O(1).
207     *
208     * Note that there are no guarantees on the ordering of values inside the
209     * array, and it may change when more values are added or removed.
210     *
211     * Requirements:
212     *
213     * - `index` must be strictly less than {length}.
214     */
215     function at(AddressSet storage set, uint256 index) internal view returns (address) {
216         return address(uint256(_at(set._inner, index)));
217     }
218 
219 
220     // UintSet
221 
222     struct UintSet {
223         Set _inner;
224     }
225 
226     /**
227      * @dev Add a value to a set. O(1).
228      *
229      * Returns true if the value was added to the set, that is if it was not
230      * already present.
231      */
232     function add(UintSet storage set, uint256 value) internal returns (bool) {
233         return _add(set._inner, bytes32(value));
234     }
235 
236     /**
237      * @dev Removes a value from a set. O(1).
238      *
239      * Returns true if the value was removed from the set, that is if it was
240      * present.
241      */
242     function remove(UintSet storage set, uint256 value) internal returns (bool) {
243         return _remove(set._inner, bytes32(value));
244     }
245 
246     /**
247      * @dev Returns true if the value is in the set. O(1).
248      */
249     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
250         return _contains(set._inner, bytes32(value));
251     }
252 
253     /**
254      * @dev Returns the number of values on the set. O(1).
255      */
256     function length(UintSet storage set) internal view returns (uint256) {
257         return _length(set._inner);
258     }
259 
260    /**
261     * @dev Returns the value stored at position `index` in the set. O(1).
262     *
263     * Note that there are no guarantees on the ordering of values inside the
264     * array, and it may change when more values are added or removed.
265     *
266     * Requirements:
267     *
268     * - `index` must be strictly less than {length}.
269     */
270     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
271         return uint256(_at(set._inner, index));
272     }
273 }
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286 
287   /**
288    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289    * account.
290    */
291   constructor() public {
292     owner = msg.sender;
293   }
294 
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == owner);
301     _;
302   }
303 
304 
305   /**
306    * @dev Allows the current owner to transfer control of the contract to a newOwner.
307    * @param newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address newOwner) onlyOwner public {
310     require(newOwner != address(0));
311     emit OwnershipTransferred(owner, newOwner);
312     owner = newOwner;
313   }
314 }
315 
316 
317 interface Token {
318     function transferFrom(address, address, uint) external returns (bool);
319     function transfer(address, uint) external returns (bool);
320 }
321 
322 interface OldIERC20 {
323     function transfer(address, uint) external;
324 }
325 
326 contract FarmProRata is Ownable {
327     using SafeMath for uint;
328     using EnumerableSet for EnumerableSet.AddressSet;
329 
330     event RewardsTransferred(address holder, uint amount);
331     event RewardsDisbursed(uint amount);
332 
333     // deposit token contract address and reward token contract address
334     // these contracts are "trusted" and checked to not contain re-entrancy pattern
335     // to safely avoid checks-effects-interactions where needed to simplify logic
336     address public trustedDepositTokenAddress = 0xE32479d25b6Cb8c02507c3568813E11A37fa32CA;
337     address public trustedRewardTokenAddress = 0x692eb773E0b5B7A79EFac5A015C8b36A2577F65c; 
338 
339     // Amount of tokens
340     uint public disburseAmount = 2000e18;
341     // To be disbursed continuously over this duration
342     uint public disburseDuration = 180 days;
343 
344     // If there are any undistributed or unclaimed tokens left in contract after this time
345     // Admin can claim them
346     uint public adminCanClaimAfter = 210 days;
347 
348 
349     // do not change this => disburse 100% rewards over `disburseDuration`
350     uint public disbursePercentX100 = 100e2;
351 
352     uint public contractDeployTime;
353     uint public adminClaimableTime;
354     uint public lastDisburseTime;
355 
356     constructor() public {
357         contractDeployTime = now;
358         adminClaimableTime = contractDeployTime.add(adminCanClaimAfter);
359         lastDisburseTime = contractDeployTime;
360     }
361 
362     uint public totalClaimedRewards = 0;
363 
364     EnumerableSet.AddressSet private holders;
365 
366     mapping (address => uint) public depositedTokens;
367     mapping (address => uint) public depositTime;
368     mapping (address => uint) public lastClaimedTime;
369     mapping (address => uint) public totalEarnedTokens;
370     mapping (address => uint) public lastDivPoints;
371 
372     uint public totalTokensDisbursed = 0;
373     uint public contractBalance = 0;
374 
375     uint public totalDivPoints = 0;
376     uint public totalTokens = 0;
377 
378     uint internal pointMultiplier = 1e18;
379 
380     function addContractBalance(uint amount) public onlyOwner {
381         require(Token(trustedRewardTokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
382         contractBalance = contractBalance.add(amount);
383     }
384 
385 
386     function updateAccount(address account) private {
387         disburseTokens();
388         uint pendingDivs = getPendingDivs(account);
389         if (pendingDivs > 0) {
390             require(Token(trustedRewardTokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
391             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
392             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
393             emit RewardsTransferred(account, pendingDivs);
394         }
395         lastClaimedTime[account] = now;
396         lastDivPoints[account] = totalDivPoints;
397     }
398 
399     function getPendingDivs(address _holder) public view returns (uint) {
400         if (!holders.contains(_holder)) return 0;
401         if (depositedTokens[_holder] == 0) return 0;
402 
403         uint newDivPoints = totalDivPoints.sub(lastDivPoints[_holder]);
404 
405         uint depositedAmount = depositedTokens[_holder];
406 
407         uint pendingDivs = depositedAmount.mul(newDivPoints).div(pointMultiplier);
408 
409         return pendingDivs;
410     }
411 
412     function getEstimatedPendingDivs(address _holder) public view returns (uint) {
413         uint pendingDivs = getPendingDivs(_holder);
414         uint pendingDisbursement = getPendingDisbursement();
415         if (contractBalance < pendingDisbursement) {
416             pendingDisbursement = contractBalance;
417         }
418         uint depositedAmount = depositedTokens[_holder];
419         if (depositedAmount == 0) return 0;
420         if (totalTokens == 0) return 0;
421 
422         uint myShare = depositedAmount.mul(pendingDisbursement).div(totalTokens);
423 
424         return pendingDivs.add(myShare);
425     }
426 
427     function getNumberOfHolders() public view returns (uint) {
428         return holders.length();
429     }
430 
431 
432     function deposit(uint amountToDeposit) public {
433         require(amountToDeposit > 0, "Cannot deposit 0 Tokens");
434 
435         updateAccount(msg.sender);
436 
437         require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");
438 
439         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToDeposit);
440         totalTokens = totalTokens.add(amountToDeposit);
441 
442         if (!holders.contains(msg.sender)) {
443             holders.add(msg.sender);
444             depositTime[msg.sender] = now;
445         }
446     }
447 
448     function withdraw(uint amountToWithdraw) public {
449         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens!");
450 
451         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
452 
453         updateAccount(msg.sender);
454 
455         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
456 
457         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
458         totalTokens = totalTokens.sub(amountToWithdraw);
459 
460         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
461             holders.remove(msg.sender);
462         }
463     }
464 
465     // withdraw without caring about Rewards
466     function emergencyWithdraw(uint amountToWithdraw) public {
467         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens!");
468 
469         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
470 
471         // manual update account here without withdrawing pending rewards
472         disburseTokens();
473         lastClaimedTime[msg.sender] = now;
474         lastDivPoints[msg.sender] = totalDivPoints;
475 
476         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
477 
478         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
479         totalTokens = totalTokens.sub(amountToWithdraw);
480 
481         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
482             holders.remove(msg.sender);
483         }
484     }
485 
486     function claim() public {
487         updateAccount(msg.sender);
488     }
489 
490     function disburseTokens() private {
491         uint amount = getPendingDisbursement();
492 
493         // uint contractBalance = Token(trustedRewardTokenAddress).balanceOf(address(this));
494 
495         if (contractBalance < amount) {
496             amount = contractBalance;
497         }
498         if (amount == 0 || totalTokens == 0) return;
499 
500         totalDivPoints = totalDivPoints.add(amount.mul(pointMultiplier).div(totalTokens));
501         emit RewardsDisbursed(amount);
502 
503         contractBalance = contractBalance.sub(amount);
504         lastDisburseTime = now;
505 
506     }
507 
508     function getPendingDisbursement() public view returns (uint) {
509         uint timeDiff;
510         uint _now = now;
511         uint _stakingEndTime = contractDeployTime.add(disburseDuration);
512         if (_now > _stakingEndTime) {
513             _now = _stakingEndTime;
514         }
515         if (lastDisburseTime >= _now) {
516             timeDiff = 0;
517         } else {
518             timeDiff = _now.sub(lastDisburseTime);
519         }
520 
521         uint pendingDisburse = disburseAmount
522                                     .mul(disbursePercentX100)
523                                     .mul(timeDiff)
524                                     .div(disburseDuration)
525                                     .div(10000);
526         return pendingDisburse;
527     }
528 
529     function getDepositorsList(uint startIndex, uint endIndex)
530         public
531         view
532         returns (address[] memory stakers,
533             uint[] memory stakingTimestamps,
534             uint[] memory lastClaimedTimeStamps,
535             uint[] memory stakedTokens) {
536         require (startIndex < endIndex);
537 
538         uint length = endIndex.sub(startIndex);
539         address[] memory _stakers = new address[](length);
540         uint[] memory _stakingTimestamps = new uint[](length);
541         uint[] memory _lastClaimedTimeStamps = new uint[](length);
542         uint[] memory _stakedTokens = new uint[](length);
543 
544         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
545             address staker = holders.at(i);
546             uint listIndex = i.sub(startIndex);
547             _stakers[listIndex] = staker;
548             _stakingTimestamps[listIndex] = depositTime[staker];
549             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
550             _stakedTokens[listIndex] = depositedTokens[staker];
551         }
552 
553         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
554     }
555 
556 
557     // function to allow owner to claim *other* modern ERC20 tokens sent to this contract
558     function transferAnyERC20Token(address _tokenAddr, address _to, uint _amount) public onlyOwner {
559         // require(_tokenAddr != trustedRewardTokenAddress && _tokenAddr != trustedDepositTokenAddress, "Cannot send out reward tokens or staking tokens!");
560 
561         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out deposit tokens from this vault!");
562         require((_tokenAddr != trustedRewardTokenAddress) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens Yet!");
563         require(Token(_tokenAddr).transfer(_to, _amount), "Could not transfer out tokens!");
564     }
565 
566     // function to allow owner to claim *other* modern ERC20 tokens sent to this contract
567     function transferAnyOldERC20Token(address _tokenAddr, address _to, uint _amount) public onlyOwner {
568         // require(_tokenAddr != trustedRewardTokenAddress && _tokenAddr != trustedDepositTokenAddress, "Cannot send out reward tokens or staking tokens!");
569 
570         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out deposit tokens from this vault!");
571         require((_tokenAddr != trustedRewardTokenAddress) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens Yet!");
572 
573         OldIERC20(_tokenAddr).transfer(_to, _amount);
574     }
575 }