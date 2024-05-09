1 pragma solidity 0.6.12;
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
281   address public admin;
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
292     admin = msg.sender;
293   }
294 
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == admin);
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
311     emit OwnershipTransferred(admin, newOwner);
312     admin = newOwner;
313   }
314 }
315 
316 
317 interface Token {
318     function transferFrom(address, address, uint) external returns (bool);
319     function transfer(address, uint) external returns (bool);
320 }
321 
322 contract Pool1 is Ownable {
323     using SafeMath for uint;
324     using EnumerableSet for EnumerableSet.AddressSet;
325     
326     event RewardsTransferred(address holder, uint amount);
327     
328     // yfilend token contract address
329     address public tokenAddress;
330     
331     // reward rate % per year
332     uint public rewardRate = 6000;
333     uint public rewardInterval = 365 days;
334     
335     // staking fee percent
336     uint public stakingFeeRate = 0;
337     
338     // unstaking fee percent
339     uint public unstakingFeeRate = 0;
340     
341     // unstaking possible Time
342     uint public PossibleUnstakeTime = 48 hours;
343     
344     uint public totalClaimedRewards = 0;
345     uint private FundedTokens;
346     
347     
348     bool public stakingStatus = false;
349     
350     EnumerableSet.AddressSet private holders;
351     
352     mapping (address => uint) public depositedTokens;
353     mapping (address => uint) public stakingTime;
354     mapping (address => uint) public lastClaimedTime;
355     mapping (address => uint) public totalEarnedTokens;
356     
357 /*=============================ADMINISTRATIVE FUNCTIONS ==================================*/
358 
359     function setTokenAddresses(address _tokenAddr) public onlyOwner returns(bool){
360      require(_tokenAddr != address(0), "Invalid address format is not supported");
361      tokenAddress = _tokenAddr;
362     
363         
364     }
365     
366     function stakingFeeRateSet(uint _stakingFeeRate, uint _unstakingFeeRate) public onlyOwner returns(bool){
367      stakingFeeRate = _stakingFeeRate;
368      unstakingFeeRate = _unstakingFeeRate;
369     
370      }
371      
372      function rewardRateSet(uint _rewardRate) public onlyOwner returns(bool){
373      rewardRate = _rewardRate;
374     
375      }
376      
377      function StakingReturnsAmountSet(uint _poolreward) public onlyOwner returns(bool){
378      FundedTokens = _poolreward;
379     
380      }
381     
382     function possibleUnstakeTimeSet(uint _possibleUnstakeTime) public onlyOwner returns(bool){
383         
384      PossibleUnstakeTime = _possibleUnstakeTime;
385     
386      }
387      
388     function rewardIntervalSet(uint _rewardInterval) public onlyOwner returns(bool){
389         
390      rewardInterval = _rewardInterval;
391     
392      }
393     
394     function allowStaking(bool _status) public onlyOwner returns(bool){
395         require(tokenAddress != address(0), "Interracting token address is not yet configured");
396         stakingStatus = _status;
397     }
398     
399     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
400         if (_tokenAddr == tokenAddress) {
401             if (_amount > getFundedTokens()) {
402                 revert();
403             }
404             totalClaimedRewards = totalClaimedRewards.add(_amount);
405         }
406         Token(_tokenAddr).transfer(_to, _amount);
407     }
408     
409     
410     function updateAccount(address account) private {
411         uint unclaimedDivs = getUnclaimedDivs(account);
412         if (unclaimedDivs > 0) {
413             require(Token(tokenAddress).transfer(account, unclaimedDivs), "Could not transfer tokens.");
414             totalEarnedTokens[account] = totalEarnedTokens[account].add(unclaimedDivs);
415             totalClaimedRewards = totalClaimedRewards.add(unclaimedDivs);
416             emit RewardsTransferred(account, unclaimedDivs);
417         }
418         lastClaimedTime[account] = now;
419     }
420     
421     function getUnclaimedDivs(address _holder) public view returns (uint) {
422         
423         if (!holders.contains(_holder)) return 0;
424         if (depositedTokens[_holder] == 0) return 0;
425 
426         uint timeDiff = now.sub(lastClaimedTime[_holder]);
427         
428         uint stakedAmount = depositedTokens[_holder];
429         
430         uint unclaimedDivs = stakedAmount
431                             .mul(rewardRate)
432                             .mul(timeDiff)
433                             .div(rewardInterval)
434                             .div(1e4);
435             
436         return unclaimedDivs;
437     }
438     
439     function getNumberOfHolders() public view returns (uint) {
440         return holders.length();
441     }
442     
443     function place(uint amountToStake) public {
444         require(stakingStatus == true, "Staking is not yet initialized");
445         require(amountToStake > 0, "Cannot deposit 0 Tokens");
446         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
447         
448         updateAccount(msg.sender);
449         
450         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
451         uint amountAfterFee = amountToStake.sub(fee);
452         require(Token(tokenAddress).transfer(admin, fee), "Could not transfer deposit fee.");
453         
454         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
455         
456         if (!holders.contains(msg.sender)) {
457             holders.add(msg.sender);
458             stakingTime[msg.sender] = now;
459         }
460     }
461     
462     function lift(uint amountToWithdraw) public {
463         
464         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
465         
466         require(now.sub(stakingTime[msg.sender]) > PossibleUnstakeTime, "You have not staked for a while yet, kindly wait a bit more");
467         
468         updateAccount(msg.sender);
469         
470         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
471         uint amountAfterFee = amountToWithdraw.sub(fee);
472         
473         require(Token(tokenAddress).transfer(admin, fee), "Could not transfer withdraw fee.");
474         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
475         
476         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
477         
478         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
479             holders.remove(msg.sender);
480         }
481     }
482     
483     function claimYields() public {
484         updateAccount(msg.sender);
485     }
486     
487     function getFundedTokens() public view returns (uint) {
488         if (totalClaimedRewards >= FundedTokens) {
489             return 0;
490         }
491         uint remaining = FundedTokens.sub(totalClaimedRewards);
492         return remaining;
493     }
494     
495    
496 }