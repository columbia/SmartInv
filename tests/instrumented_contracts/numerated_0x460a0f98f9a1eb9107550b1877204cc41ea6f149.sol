1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 /**
6  * YFOX Dual Staking
7  * Regular Staking APR:
8  *   - Yearly: 360 days = 200% 
9  *   - Monthly: 30 days = 16.66%
10  *   - Weekly: 7 Days = 3.88%
11  *   - Daily: 24 Hours = 0.55%
12  *   - Hourly: 60 Minutes = 0.02%
13  * 
14  * FD (Fixed Deposit Staking) APR:
15  *   - Yearly: 360 days = 250%
16  * Interest on fixed deposit staking is added at a daily rate of 0.69%
17  * 
18  * Staking ends after 12 months
19  * Stakers can still unstake for 1 month after staking has ended
20  * After 13 months admin has the right to claim remaining YFOX from the smart contract
21  *
22  * 
23  */
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @dev Library for managing
57  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
58  * types.
59  *
60  * Sets have the following properties:
61  *
62  * - Elements are added, removed, and checked for existence in constant time
63  * (O(1)).
64  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
65  *
66  * ```
67  * contract Example {
68  *     // Add the library methods
69  *     using EnumerableSet for EnumerableSet.AddressSet;
70  *
71  *     // Declare a set state variable
72  *     EnumerableSet.AddressSet private mySet;
73  * }
74  * ```
75  *
76  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
77  * (`UintSet`) are supported.
78  */
79 library EnumerableSet {
80     // To implement this library for multiple types with as little code
81     // repetition as possible, we write it in terms of a generic Set type with
82     // bytes32 values.
83     // The Set implementation uses private functions, and user-facing
84     // implementations (such as AddressSet) are just wrappers around the
85     // underlying Set.
86     // This means that we can only create new EnumerableSets for types that fit
87     // in bytes32.
88 
89     struct Set {
90         // Storage of set values
91         bytes32[] _values;
92 
93         // Position of the value in the `values` array, plus 1 because index 0
94         // means a value is not in the set.
95         mapping (bytes32 => uint256) _indexes;
96     }
97 
98     /**
99      * @dev Add a value to a set. O(1).
100      *
101      * Returns true if the value was added to the set, that is if it was not
102      * already present.
103      */
104     function _add(Set storage set, bytes32 value) private returns (bool) {
105         if (!_contains(set, value)) {
106             set._values.push(value);
107             // The value is stored at length-1, but we add 1 to all indexes
108             // and use 0 as a sentinel value
109             set._indexes[value] = set._values.length;
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Removes a value from a set. O(1).
118      *
119      * Returns true if the value was removed from the set, that is if it was
120      * present.
121      */
122     function _remove(Set storage set, bytes32 value) private returns (bool) {
123         // We read and store the value's index to prevent multiple reads from the same storage slot
124         uint256 valueIndex = set._indexes[value];
125 
126         if (valueIndex != 0) { // Equivalent to contains(set, value)
127             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
128             // the array, and then remove the last element (sometimes called as 'swap and pop').
129             // This modifies the order of the array, as noted in {at}.
130 
131             uint256 toDeleteIndex = valueIndex - 1;
132             uint256 lastIndex = set._values.length - 1;
133 
134             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
135             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
136 
137             bytes32 lastvalue = set._values[lastIndex];
138 
139             // Move the last value to the index where the value to delete is
140             set._values[toDeleteIndex] = lastvalue;
141             // Update the index for the moved value
142             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
143 
144             // Delete the slot where the moved value was stored
145             set._values.pop();
146 
147             // Delete the index for the deleted slot
148             delete set._indexes[value];
149 
150             return true;
151         } else {
152             return false;
153         }
154     }
155 
156     /**
157      * @dev Returns true if the value is in the set. O(1).
158      */
159     function _contains(Set storage set, bytes32 value) private view returns (bool) {
160         return set._indexes[value] != 0;
161     }
162 
163     /**
164      * @dev Returns the number of values on the set. O(1).
165      */
166     function _length(Set storage set) private view returns (uint256) {
167         return set._values.length;
168     }
169 
170    /**
171     * @dev Returns the value stored at position `index` in the set. O(1).
172     *
173     * Note that there are no guarantees on the ordering of values inside the
174     * array, and it may change when more values are added or removed.
175     *
176     * Requirements:
177     *
178     * - `index` must be strictly less than {length}.
179     */
180     function _at(Set storage set, uint256 index) private view returns (bytes32) {
181         require(set._values.length > index, "EnumerableSet: index out of bounds");
182         return set._values[index];
183     }
184 
185     // AddressSet
186 
187     struct AddressSet {
188         Set _inner;
189     }
190 
191     /**
192      * @dev Add a value to a set. O(1).
193      *
194      * Returns true if the value was added to the set, that is if it was not
195      * already present.
196      */
197     function add(AddressSet storage set, address value) internal returns (bool) {
198         return _add(set._inner, bytes32(uint256(value)));
199     }
200 
201     /**
202      * @dev Removes a value from a set. O(1).
203      *
204      * Returns true if the value was removed from the set, that is if it was
205      * present.
206      */
207     function remove(AddressSet storage set, address value) internal returns (bool) {
208         return _remove(set._inner, bytes32(uint256(value)));
209     }
210 
211     /**
212      * @dev Returns true if the value is in the set. O(1).
213      */
214     function contains(AddressSet storage set, address value) internal view returns (bool) {
215         return _contains(set._inner, bytes32(uint256(value)));
216     }
217 
218     /**
219      * @dev Returns the number of values in the set. O(1).
220      */
221     function length(AddressSet storage set) internal view returns (uint256) {
222         return _length(set._inner);
223     }
224 
225    /**
226     * @dev Returns the value stored at position `index` in the set. O(1).
227     *
228     * Note that there are no guarantees on the ordering of values inside the
229     * array, and it may change when more values are added or removed.
230     *
231     * Requirements:
232     *
233     * - `index` must be strictly less than {length}.
234     */
235     function at(AddressSet storage set, uint256 index) internal view returns (address) {
236         return address(uint256(_at(set._inner, index)));
237     }
238 
239 
240     // UintSet
241 
242     struct UintSet {
243         Set _inner;
244     }
245 
246     /**
247      * @dev Add a value to a set. O(1).
248      *
249      * Returns true if the value was added to the set, that is if it was not
250      * already present.
251      */
252     function add(UintSet storage set, uint256 value) internal returns (bool) {
253         return _add(set._inner, bytes32(value));
254     }
255 
256     /**
257      * @dev Removes a value from a set. O(1).
258      *
259      * Returns true if the value was removed from the set, that is if it was
260      * present.
261      */
262     function remove(UintSet storage set, uint256 value) internal returns (bool) {
263         return _remove(set._inner, bytes32(value));
264     }
265 
266     /**
267      * @dev Returns true if the value is in the set. O(1).
268      */
269     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
270         return _contains(set._inner, bytes32(value));
271     }
272 
273     /**
274      * @dev Returns the number of values on the set. O(1).
275      */
276     function length(UintSet storage set) internal view returns (uint256) {
277         return _length(set._inner);
278     }
279 
280    /**
281     * @dev Returns the value stored at position `index` in the set. O(1).
282     *
283     * Note that there are no guarantees on the ordering of values inside the
284     * array, and it may change when more values are added or removed.
285     *
286     * Requirements:
287     *
288     * - `index` must be strictly less than {length}.
289     */
290     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
291         return uint256(_at(set._inner, index));
292     }
293 }
294 
295 /**
296  * @title Ownable
297  * @dev The Ownable contract has an owner address, and provides basic authorization control
298  * functions, this simplifies the implementation of "user permissions".
299  */
300 contract Ownable {
301   address public owner;
302 
303 
304   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306 
307   /**
308    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
309    * account.
310    */
311   constructor() public {
312     owner = msg.sender;
313   }
314 
315 
316   /**
317    * @dev Throws if called by any account other than the owner.
318    */
319   modifier onlyOwner() {
320     require(msg.sender == owner);
321     _;
322   }
323 
324 
325   /**
326    * @dev Allows the current owner to transfer control of the contract to a newOwner.
327    * @param newOwner The address to transfer ownership to.
328    */
329   function transferOwnership(address newOwner) onlyOwner public {
330     require(newOwner != address(0));
331     emit OwnershipTransferred(owner, newOwner);
332     owner = newOwner;
333   }
334 }
335 
336 
337 interface Token {
338     function transferFrom(address, address, uint) external returns (bool);
339     function transfer(address, uint) external returns (bool);
340 }
341 
342 contract Staking is Ownable {
343     using SafeMath for uint;
344     using EnumerableSet for EnumerableSet.AddressSet;
345     
346     event RewardsTransferred(address holder, uint amount);
347     
348     // reward token contract address
349     address public constant tokenAddress = 0x706CB9E741CBFee00Ad5b3f5ACc8bd44D1644a74;
350     
351     // reward rate 200.00% per year
352     uint public constant rewardRate = 20000;
353     // FD reward rate 250.00% per year
354     uint public constant rewardRateFD = 25000;
355     
356     uint public constant rewardInterval = 360 days;
357     uint public constant adminCanClaimAfter = 30 days;
358     
359     // No fee for FD
360     
361     // staking fee 1.00 percent
362     uint public constant stakingFeeRate = 100;
363     
364     // unstaking fee 0.50 percent
365     uint public constant unstakingFeeRate = 50;
366     
367     // unstaking possible after 48 hours
368     uint public constant cliffTime = 48 hours;
369     
370     
371     uint public totalClaimedRewards = 0;
372     
373     EnumerableSet.AddressSet private holders;
374     EnumerableSet.AddressSet private holdersFD;
375     
376     mapping (address => uint) public depositedTokens;
377     mapping (address => uint) public stakingTime;
378     mapping (address => uint) public lastClaimedTime;
379     
380     mapping (address => uint) public depositedTokensFD;
381     mapping (address => uint) public stakingTimeFD;
382     mapping (address => uint) public lastClaimedTimeFD;
383     
384     mapping (address => uint) public totalEarnedTokens;
385     mapping (address => uint) public totalEarnedTokensFD;
386     
387     uint public stakingDeployTime;
388     uint public stakingEndTime;
389     uint public adminClaimableTime;
390     
391     constructor() public {
392         uint _now = now;
393         stakingDeployTime = _now;
394         stakingEndTime = stakingDeployTime.add(rewardInterval);
395         adminClaimableTime = stakingEndTime.add(adminCanClaimAfter);
396     }
397     
398     function updateAccount(address account) private {
399         uint pendingDivs = getPendingDivs(account);
400         if (pendingDivs > 0) {
401             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
402             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
403             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
404             emit RewardsTransferred(account, pendingDivs);
405         }
406         lastClaimedTime[account] = now;
407     }
408     
409     function updateAccountFD(address account) private {
410         uint pendingDivs = getPendingDivsFD(account);
411         if (pendingDivs > 0) {
412             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
413             totalEarnedTokensFD[account] = totalEarnedTokensFD[account].add(pendingDivs);
414             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
415             emit RewardsTransferred(account, pendingDivs);
416         }
417         lastClaimedTimeFD[account] = now;
418     }
419     
420     function getPendingDivs(address _holder) public view returns (uint) {
421         if (!holders.contains(_holder)) return 0;
422         if (depositedTokens[_holder] == 0) return 0;
423         
424         uint timeDiff;
425         uint _now = now;
426         if (_now > stakingEndTime) {
427             _now = stakingEndTime;
428         }
429         
430         if (lastClaimedTime[_holder] >= _now) {
431             timeDiff = 0;
432         } else {
433             timeDiff = _now.sub(lastClaimedTime[_holder]);
434         }
435     
436         
437         uint stakedAmount = depositedTokens[_holder];
438         
439         uint pendingDivs = stakedAmount
440                             .mul(rewardRate)
441                             .mul(timeDiff)
442                             .div(rewardInterval)
443                             .div(1e4);
444             
445         return pendingDivs;
446     }
447     
448     function getPendingDivsFD(address _holder) public view returns (uint) {
449         if (!holdersFD.contains(_holder)) return 0;
450         if (depositedTokensFD[_holder] == 0) return 0;
451 
452         uint timeDiff;
453         uint _now = now;
454         if (_now > stakingEndTime) {
455             _now = stakingEndTime;
456         }
457         
458         if (lastClaimedTimeFD[_holder] >= _now) {
459             timeDiff = 0;
460         } else {
461             timeDiff = _now.sub(lastClaimedTimeFD[_holder]);
462         }
463         
464         uint stakedAmount = depositedTokensFD[_holder];
465         
466         uint pendingDivs = stakedAmount
467                             .mul(rewardRateFD)
468                             .mul(timeDiff)
469                             .div(rewardInterval)
470                             .div(1e4);
471             
472         return pendingDivs;
473     }
474     
475     function getNumberOfHolders() public view returns (uint) {
476         return holders.length();
477     }
478     function getNumberOfHoldersFD() public view returns (uint) {
479         return holdersFD.length();
480     }
481     
482     
483     function stake(uint amountToStake) public {
484         require(amountToStake > 0, "Cannot deposit 0 Tokens");
485         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
486         
487         updateAccount(msg.sender);
488         
489         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
490         uint amountAfterFee = amountToStake.sub(fee);
491         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");
492         
493         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
494         
495         if (!holders.contains(msg.sender)) {
496             holders.add(msg.sender);
497             stakingTime[msg.sender] = now;
498         }
499     }
500     
501     function stakeFD(uint amountToStake) public {
502         require(amountToStake > 0, "Cannot deposit 0 Tokens");
503         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
504         
505         updateAccountFD(msg.sender);
506         
507         depositedTokensFD[msg.sender] = depositedTokensFD[msg.sender].add(amountToStake);
508         
509         if (!holdersFD.contains(msg.sender)) {
510             holdersFD.add(msg.sender);
511             stakingTimeFD[msg.sender] = now;
512         }
513     }
514     
515     function unstake(uint amountToWithdraw) public {
516         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
517         
518         require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
519         
520         updateAccount(msg.sender);
521         
522         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
523         uint amountAfterFee = amountToWithdraw.sub(fee);
524         
525         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");
526         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
527         
528         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
529         
530         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
531             holders.remove(msg.sender);
532         }
533     }
534     
535     function unstakeFD(uint amountToWithdraw) public {
536         require(depositedTokensFD[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
537         
538         require(now > stakingEndTime, "Cannot unstake FD before staking ends.");
539         
540         updateAccountFD(msg.sender);
541         
542         require(Token(tokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
543         
544         depositedTokensFD[msg.sender] = depositedTokensFD[msg.sender].sub(amountToWithdraw);
545         
546         if (holdersFD.contains(msg.sender) && depositedTokensFD[msg.sender] == 0) {
547             holdersFD.remove(msg.sender);
548         }
549     }
550     
551     function claim() public {
552         updateAccount(msg.sender);
553     }
554     
555     function claimFD() public {
556         updateAccountFD(msg.sender);
557     }
558     
559     function getStakersList(uint startIndex, uint endIndex) 
560         public 
561         view 
562         returns (address[] memory stakers, 
563             uint[] memory stakingTimestamps, 
564             uint[] memory lastClaimedTimeStamps,
565             uint[] memory stakedTokens) {
566         require (startIndex < endIndex);
567         
568         uint length = endIndex.sub(startIndex);
569         address[] memory _stakers = new address[](length);
570         uint[] memory _stakingTimestamps = new uint[](length);
571         uint[] memory _lastClaimedTimeStamps = new uint[](length);
572         uint[] memory _stakedTokens = new uint[](length);
573         
574         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
575             address staker = holders.at(i);
576             uint listIndex = i.sub(startIndex);
577             _stakers[listIndex] = staker;
578             _stakingTimestamps[listIndex] = stakingTime[staker];
579             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
580             _stakedTokens[listIndex] = depositedTokens[staker];
581         }
582         
583         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
584     }
585     
586     function getStakersListFD(uint startIndex, uint endIndex) 
587         public 
588         view 
589         returns (address[] memory stakers, 
590             uint[] memory stakingTimestamps, 
591             uint[] memory lastClaimedTimeStamps,
592             uint[] memory stakedTokens) {
593         require (startIndex < endIndex);
594         
595         uint length = endIndex.sub(startIndex);
596         address[] memory _stakers = new address[](length);
597         uint[] memory _stakingTimestamps = new uint[](length);
598         uint[] memory _lastClaimedTimeStamps = new uint[](length);
599         uint[] memory _stakedTokens = new uint[](length);
600         
601         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
602             address staker = holdersFD.at(i);
603             uint listIndex = i.sub(startIndex);
604             _stakers[listIndex] = staker;
605             _stakingTimestamps[listIndex] = stakingTimeFD[staker];
606             _lastClaimedTimeStamps[listIndex] = lastClaimedTimeFD[staker];
607             _stakedTokens[listIndex] = depositedTokensFD[staker];
608         }
609         
610         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
611     }
612     
613     
614     uint private constant stakingAndDaoTokens = 6900e6;
615     
616     function getStakingAndDaoAmount() public view returns (uint) {
617         if (totalClaimedRewards >= stakingAndDaoTokens) {
618             return 0;
619         }
620         uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
621         return remaining;
622     }
623     
624     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
625     // Admin cannot transfer out YFOX from this smart contract till 1 month after staking ends
626     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
627         require((_tokenAddr != tokenAddress) || (now > adminClaimableTime), "Cannot Transfer Out YFOX till 13 months of launch!");
628         Token(_tokenAddr).transfer(_to, _amount);
629     }
630 }