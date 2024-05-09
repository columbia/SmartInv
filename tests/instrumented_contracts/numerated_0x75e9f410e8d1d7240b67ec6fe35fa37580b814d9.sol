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
322 contract VaultProRata is Ownable {
323     using SafeMath for uint;
324     using EnumerableSet for EnumerableSet.AddressSet;
325     
326     event RewardsTransferred(address holder, uint amount);
327     event RewardsDisbursed(uint amount);
328     
329     // deposit token contract address
330     address public trustedDepositTokenAddress = 0x84E34df6F8F85f15D24Ec8e347D32F1184089a14;
331     address public trustedRewardTokenAddress = 0xf4CD3d3Fda8d7Fd6C5a500203e38640A70Bf9577; 
332     uint public adminCanClaimAfter = 395 days;
333     uint public withdrawFeePercentX100 = 50;
334     uint public disburseAmount = 20e18;
335     uint public disburseDuration = 30 days;
336     uint public cliffTime = 72 hours;
337     
338     
339     uint public disbursePercentX100 = 10000;
340     
341     uint public contractDeployTime;
342     uint public adminClaimableTime;
343     uint public lastDisburseTime;
344     
345     constructor() public {
346         contractDeployTime = now;
347         adminClaimableTime = contractDeployTime.add(adminCanClaimAfter);
348         lastDisburseTime = contractDeployTime;
349     }
350 
351     
352     uint public totalClaimedRewards = 0;
353     
354     EnumerableSet.AddressSet private holders;
355     
356     mapping (address => uint) public depositedTokens;
357     mapping (address => uint) public depositTime;
358     mapping (address => uint) public lastClaimedTime;
359     mapping (address => uint) public totalEarnedTokens;
360     mapping (address => uint) public lastDivPoints;
361     
362     uint public totalTokensDisbursed = 0;
363     uint public contractBalance = 0;
364     
365     uint public totalDivPoints = 0;
366     uint public totalTokens = 0;
367 
368     uint internal pointMultiplier = 1e18;
369     
370     function addContractBalance(uint amount) public onlyOwner {
371         require(Token(trustedRewardTokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
372         contractBalance = contractBalance.add(amount);
373     }
374     
375     
376     function updateAccount(address account) private {
377         uint pendingDivs = getPendingDivs(account);
378         if (pendingDivs > 0) {
379             require(Token(trustedRewardTokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
380             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
381             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
382             emit RewardsTransferred(account, pendingDivs);
383         }
384         lastClaimedTime[account] = now;
385         lastDivPoints[account] = totalDivPoints;
386     }
387     
388     function getPendingDivs(address _holder) public view returns (uint) {
389         if (!holders.contains(_holder)) return 0;
390         if (depositedTokens[_holder] == 0) return 0;
391         
392         uint newDivPoints = totalDivPoints.sub(lastDivPoints[_holder]);
393 
394         uint depositedAmount = depositedTokens[_holder];
395         
396         uint pendingDivs = depositedAmount.mul(newDivPoints).div(pointMultiplier);
397             
398         return pendingDivs;
399     }
400     
401     function getNumberOfHolders() public view returns (uint) {
402         return holders.length();
403     }
404     
405     
406     function deposit(uint amountToDeposit) public {
407         require(amountToDeposit > 0, "Cannot deposit 0 Tokens");
408         
409         updateAccount(msg.sender);
410         
411         require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");
412         
413         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToDeposit);
414         totalTokens = totalTokens.add(amountToDeposit);
415         
416         if (!holders.contains(msg.sender)) {
417             holders.add(msg.sender);
418             depositTime[msg.sender] = now;
419         }
420     }
421     
422     function withdraw(uint amountToWithdraw) public {
423         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
424         require(now.sub(depositTime[msg.sender]) > cliffTime, "Please wait before withdrawing!");
425 
426         updateAccount(msg.sender);
427         
428         uint fee = amountToWithdraw.mul(withdrawFeePercentX100).div(1e4);
429         uint amountAfterFee = amountToWithdraw.sub(fee);
430         
431         require(Token(trustedDepositTokenAddress).transfer(owner, fee), "Could not transfer fee!");
432 
433         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
434         
435         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
436         totalTokens = totalTokens.sub(amountToWithdraw);
437         
438         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
439             holders.remove(msg.sender);
440         }
441     }
442     
443     // withdraw without caring about Rewards
444     function emergencyWithdraw(uint amountToWithdraw) public {
445         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
446         require(now.sub(depositTime[msg.sender]) > cliffTime, "Please wait before withdrawing!");
447 
448         lastClaimedTime[msg.sender] = now;
449         lastDivPoints[msg.sender] = totalDivPoints;
450         
451         uint fee = amountToWithdraw.mul(withdrawFeePercentX100).div(1e4);
452         uint amountAfterFee = amountToWithdraw.sub(fee);
453         
454         require(Token(trustedDepositTokenAddress).transfer(owner, fee), "Could not transfer fee!");
455 
456         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
457         
458         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
459         totalTokens = totalTokens.sub(amountToWithdraw);
460         
461         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
462             holders.remove(msg.sender);
463         }
464     }
465     
466     function claim() public {
467         updateAccount(msg.sender);
468     }
469     
470     function distributeDivs(uint amount) private {
471         if (totalTokens == 0) return;
472         totalDivPoints = totalDivPoints.add(amount.mul(pointMultiplier).div(totalTokens));
473         emit RewardsDisbursed(amount);
474     }
475     
476     function disburseTokens() public onlyOwner {
477         uint amount = getPendingDisbursement();
478         
479         // uint contractBalance = Token(trustedRewardTokenAddress).balanceOf(address(this));
480         
481         if (contractBalance < amount) {
482             amount = contractBalance;
483         }
484         if (amount == 0) return;
485         distributeDivs(amount);
486         contractBalance = contractBalance.sub(amount);
487         lastDisburseTime = now;
488         
489     }
490     
491     function getPendingDisbursement() public view returns (uint) {
492         uint timeDiff = now.sub(lastDisburseTime);
493         uint pendingDisburse = disburseAmount
494                                     .mul(disbursePercentX100)
495                                     .mul(timeDiff)
496                                     .div(disburseDuration)
497                                     .div(10000);
498         return pendingDisburse;
499     }
500     
501     function getDepositorsList(uint startIndex, uint endIndex) 
502         public 
503         view 
504         returns (address[] memory stakers, 
505             uint[] memory stakingTimestamps, 
506             uint[] memory lastClaimedTimeStamps,
507             uint[] memory stakedTokens) {
508         require (startIndex < endIndex);
509         
510         uint length = endIndex.sub(startIndex);
511         address[] memory _stakers = new address[](length);
512         uint[] memory _stakingTimestamps = new uint[](length);
513         uint[] memory _lastClaimedTimeStamps = new uint[](length);
514         uint[] memory _stakedTokens = new uint[](length);
515         
516         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
517             address staker = holders.at(i);
518             uint listIndex = i.sub(startIndex);
519             _stakers[listIndex] = staker;
520             _stakingTimestamps[listIndex] = depositTime[staker];
521             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
522             _stakedTokens[listIndex] = depositedTokens[staker];
523         }
524         
525         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
526     }
527     
528 
529     // function to allow owner to claim *other* ERC20 tokens sent to this contract
530     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
531         // require(_tokenAddr != trustedRewardTokenAddress && _tokenAddr != trustedDepositTokenAddress, "Cannot send out reward tokens or staking tokens!");
532         
533         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out deposit tokens from this vault!");
534         require((_tokenAddr != trustedRewardTokenAddress) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens yet!");
535         
536         Token(_tokenAddr).transfer(_to, _amount);
537     }
538 }