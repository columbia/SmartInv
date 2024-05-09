1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-22
3 */
4 
5 pragma solidity 0.6.12;
6 
7 // SPDX-License-Identifier: BSD-3-Clause
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 /**
40  * @dev Library for managing
41  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
42  * types.
43  *
44  * Sets have the following properties:
45  *
46  * - Elements are added, removed, and checked for existence in constant time
47  * (O(1)).
48  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
49  *
50  * ```
51  * contract Example {
52  *     // Add the library methods
53  *     using EnumerableSet for EnumerableSet.AddressSet;
54  *
55  *     // Declare a set state variable
56  *     EnumerableSet.AddressSet private mySet;
57  * }
58  * ```
59  *
60  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
61  * (`UintSet`) are supported.
62  */
63 library EnumerableSet {
64     // To implement this library for multiple types with as little code
65     // repetition as possible, we write it in terms of a generic Set type with
66     // bytes32 values.
67     // The Set implementation uses private functions, and user-facing
68     // implementations (such as AddressSet) are just wrappers around the
69     // underlying Set.
70     // This means that we can only create new EnumerableSets for types that fit
71     // in bytes32.
72 
73     struct Set {
74         // Storage of set values
75         bytes32[] _values;
76 
77         // Position of the value in the `values` array, plus 1 because index 0
78         // means a value is not in the set.
79         mapping (bytes32 => uint256) _indexes;
80     }
81 
82     /**
83      * @dev Add a value to a set. O(1).
84      *
85      * Returns true if the value was added to the set, that is if it was not
86      * already present.
87      */
88     function _add(Set storage set, bytes32 value) private returns (bool) {
89         if (!_contains(set, value)) {
90             set._values.push(value);
91             // The value is stored at length-1, but we add 1 to all indexes
92             // and use 0 as a sentinel value
93             set._indexes[value] = set._values.length;
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     /**
101      * @dev Removes a value from a set. O(1).
102      *
103      * Returns true if the value was removed from the set, that is if it was
104      * present.
105      */
106     function _remove(Set storage set, bytes32 value) private returns (bool) {
107         // We read and store the value's index to prevent multiple reads from the same storage slot
108         uint256 valueIndex = set._indexes[value];
109 
110         if (valueIndex != 0) { // Equivalent to contains(set, value)
111             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
112             // the array, and then remove the last element (sometimes called as 'swap and pop').
113             // This modifies the order of the array, as noted in {at}.
114 
115             uint256 toDeleteIndex = valueIndex - 1;
116             uint256 lastIndex = set._values.length - 1;
117 
118             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
119             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
120 
121             bytes32 lastvalue = set._values[lastIndex];
122 
123             // Move the last value to the index where the value to delete is
124             set._values[toDeleteIndex] = lastvalue;
125             // Update the index for the moved value
126             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
127 
128             // Delete the slot where the moved value was stored
129             set._values.pop();
130 
131             // Delete the index for the deleted slot
132             delete set._indexes[value];
133 
134             return true;
135         } else {
136             return false;
137         }
138     }
139 
140     /**
141      * @dev Returns true if the value is in the set. O(1).
142      */
143     function _contains(Set storage set, bytes32 value) private view returns (bool) {
144         return set._indexes[value] != 0;
145     }
146 
147     /**
148      * @dev Returns the number of values on the set. O(1).
149      */
150     function _length(Set storage set) private view returns (uint256) {
151         return set._values.length;
152     }
153 
154    /**
155     * @dev Returns the value stored at position `index` in the set. O(1).
156     *
157     * Note that there are no guarantees on the ordering of values inside the
158     * array, and it may change when more values are added or removed.
159     *
160     * Requirements:
161     *
162     * - `index` must be strictly less than {length}.
163     */
164     function _at(Set storage set, uint256 index) private view returns (bytes32) {
165         require(set._values.length > index, "EnumerableSet: index out of bounds");
166         return set._values[index];
167     }
168 
169     // AddressSet
170 
171     struct AddressSet {
172         Set _inner;
173     }
174 
175     /**
176      * @dev Add a value to a set. O(1).
177      *
178      * Returns true if the value was added to the set, that is if it was not
179      * already present.
180      */
181     function add(AddressSet storage set, address value) internal returns (bool) {
182         return _add(set._inner, bytes32(uint256(value)));
183     }
184 
185     /**
186      * @dev Removes a value from a set. O(1).
187      *
188      * Returns true if the value was removed from the set, that is if it was
189      * present.
190      */
191     function remove(AddressSet storage set, address value) internal returns (bool) {
192         return _remove(set._inner, bytes32(uint256(value)));
193     }
194 
195     /**
196      * @dev Returns true if the value is in the set. O(1).
197      */
198     function contains(AddressSet storage set, address value) internal view returns (bool) {
199         return _contains(set._inner, bytes32(uint256(value)));
200     }
201 
202     /**
203      * @dev Returns the number of values in the set. O(1).
204      */
205     function length(AddressSet storage set) internal view returns (uint256) {
206         return _length(set._inner);
207     }
208 
209    /**
210     * @dev Returns the value stored at position `index` in the set. O(1).
211     *
212     * Note that there are no guarantees on the ordering of values inside the
213     * array, and it may change when more values are added or removed.
214     *
215     * Requirements:
216     *
217     * - `index` must be strictly less than {length}.
218     */
219     function at(AddressSet storage set, uint256 index) internal view returns (address) {
220         return address(uint256(_at(set._inner, index)));
221     }
222 
223 
224     // UintSet
225 
226     struct UintSet {
227         Set _inner;
228     }
229 
230     /**
231      * @dev Add a value to a set. O(1).
232      *
233      * Returns true if the value was added to the set, that is if it was not
234      * already present.
235      */
236     function add(UintSet storage set, uint256 value) internal returns (bool) {
237         return _add(set._inner, bytes32(value));
238     }
239 
240     /**
241      * @dev Removes a value from a set. O(1).
242      *
243      * Returns true if the value was removed from the set, that is if it was
244      * present.
245      */
246     function remove(UintSet storage set, uint256 value) internal returns (bool) {
247         return _remove(set._inner, bytes32(value));
248     }
249 
250     /**
251      * @dev Returns true if the value is in the set. O(1).
252      */
253     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
254         return _contains(set._inner, bytes32(value));
255     }
256 
257     /**
258      * @dev Returns the number of values on the set. O(1).
259      */
260     function length(UintSet storage set) internal view returns (uint256) {
261         return _length(set._inner);
262     }
263 
264    /**
265     * @dev Returns the value stored at position `index` in the set. O(1).
266     *
267     * Note that there are no guarantees on the ordering of values inside the
268     * array, and it may change when more values are added or removed.
269     *
270     * Requirements:
271     *
272     * - `index` must be strictly less than {length}.
273     */
274     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
275         return uint256(_at(set._inner, index));
276     }
277 }
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public admin;
286 
287 
288   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290 
291   /**
292    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293    * account.
294    */
295   constructor() public {
296     admin = msg.sender;
297   }
298 
299 
300   /**
301    * @dev Throws if called by any account other than the owner.
302    */
303   modifier onlyOwner() {
304     require(msg.sender == admin);
305     _;
306   }
307 
308 
309   /**
310    * @dev Allows the current owner to transfer control of the contract to a newOwner.
311    * @param newOwner The address to transfer ownership to.
312    */
313   function transferOwnership(address newOwner) onlyOwner public {
314     require(newOwner != address(0));
315     emit OwnershipTransferred(admin, newOwner);
316     admin = newOwner;
317   }
318 }
319 
320 
321 interface Token {
322     function transferFrom(address, address, uint) external returns (bool);
323     function transfer(address, uint) external returns (bool);
324 }
325 
326 contract Pool1 is Ownable {
327     using SafeMath for uint;
328     using EnumerableSet for EnumerableSet.AddressSet;
329     
330     event RewardsTransferred(address holder, uint amount);
331     
332     // yfilend token contract address
333     address public tokenAddress;
334     
335     // reward rate % per year
336     uint public rewardRate = 92000;
337     uint public rewardInterval = 365 days;
338     
339     // staking fee percent
340     uint public stakingFeeRate = 0;
341     
342     // unstaking fee percent
343     uint public unstakingFeeRate = 0;
344     
345     // unstaking possible Time
346     uint public PossibleUnstakeTime = 48 hours;
347     
348     uint public totalClaimedRewards = 0;
349     uint private FundedTokens;
350     
351     
352     bool public stakingStatus = false;
353     
354     EnumerableSet.AddressSet private holders;
355     
356     mapping (address => uint) public depositedTokens;
357     mapping (address => uint) public stakingTime;
358     mapping (address => uint) public lastClaimedTime;
359     mapping (address => uint) public totalEarnedTokens;
360     
361 /*=============================ADMINISTRATIVE FUNCTIONS ==================================*/
362 
363     function setTokenAddresses(address _tokenAddr) public onlyOwner returns(bool){
364      require(_tokenAddr != address(0), "Invalid address format is not supported");
365      tokenAddress = _tokenAddr;
366     
367         
368     }
369     
370     function stakingFeeRateSet(uint _stakingFeeRate, uint _unstakingFeeRate) public onlyOwner returns(bool){
371      stakingFeeRate = _stakingFeeRate;
372      unstakingFeeRate = _unstakingFeeRate;
373     
374      }
375      
376      function rewardRateSet(uint _rewardRate) public onlyOwner returns(bool){
377      rewardRate = _rewardRate;
378     
379      }
380      
381      function StakingReturnsAmountSet(uint _poolreward) public onlyOwner returns(bool){
382      FundedTokens = _poolreward;
383     
384      }
385     
386     function possibleUnstakeTimeSet(uint _possibleUnstakeTime) public onlyOwner returns(bool){
387         
388      PossibleUnstakeTime = _possibleUnstakeTime;
389     
390      }
391      
392     function rewardIntervalSet(uint _rewardInterval) public onlyOwner returns(bool){
393         
394      rewardInterval = _rewardInterval;
395     
396      }
397     
398     function allowStaking(bool _status) public onlyOwner returns(bool){
399         require(tokenAddress != address(0), "Interracting token address is not yet configured");
400         stakingStatus = _status;
401     }
402     
403     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
404         if (_tokenAddr == tokenAddress) {
405             if (_amount > getFundedTokens()) {
406                 revert();
407             }
408             totalClaimedRewards = totalClaimedRewards.add(_amount);
409         }
410         Token(_tokenAddr).transfer(_to, _amount);
411     }
412     
413     
414     function updateAccount(address account) private {
415         uint unclaimedDivs = getUnclaimedDivs(account);
416         if (unclaimedDivs > 0) {
417             require(Token(tokenAddress).transfer(account, unclaimedDivs), "Could not transfer tokens.");
418             totalEarnedTokens[account] = totalEarnedTokens[account].add(unclaimedDivs);
419             totalClaimedRewards = totalClaimedRewards.add(unclaimedDivs);
420             emit RewardsTransferred(account, unclaimedDivs);
421         }
422         lastClaimedTime[account] = now;
423     }
424     
425     function getUnclaimedDivs(address _holder) public view returns (uint) {
426         
427         if (!holders.contains(_holder)) return 0;
428         if (depositedTokens[_holder] == 0) return 0;
429 
430         uint timeDiff = now.sub(lastClaimedTime[_holder]);
431         
432         uint stakedAmount = depositedTokens[_holder];
433         
434         uint unclaimedDivs = stakedAmount
435                             .mul(rewardRate)
436                             .mul(timeDiff)
437                             .div(rewardInterval)
438                             .div(1e4);
439             
440         return unclaimedDivs;
441     }
442     
443     function getNumberOfHolders() public view returns (uint) {
444         return holders.length();
445     }
446     
447     function farm(uint amountToStake) public {
448         require(stakingStatus == true, "Staking is not yet initialized");
449         require(amountToStake > 0, "Cannot deposit 0 Tokens");
450         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
451         
452         updateAccount(msg.sender);
453         
454         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
455         uint amountAfterFee = amountToStake.sub(fee);
456         require(Token(tokenAddress).transfer(admin, fee), "Could not transfer deposit fee.");
457         
458         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
459         
460         if (!holders.contains(msg.sender)) {
461             holders.add(msg.sender);
462             stakingTime[msg.sender] = now;
463         }
464     }
465     
466     function unfarm(uint amountToWithdraw) public {
467         
468         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
469         
470         require(now.sub(stakingTime[msg.sender]) > PossibleUnstakeTime, "You have not staked for a while yet, kindly wait a bit more");
471         
472         updateAccount(msg.sender);
473         
474         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
475         uint amountAfterFee = amountToWithdraw.sub(fee);
476         
477         require(Token(tokenAddress).transfer(admin, fee), "Could not transfer withdraw fee.");
478         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
479         
480         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
481         
482         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
483             holders.remove(msg.sender);
484         }
485     }
486     
487     function harvest() public {
488         updateAccount(msg.sender);
489     }
490     
491     function getFundedTokens() public view returns (uint) {
492         if (totalClaimedRewards >= FundedTokens) {
493             return 0;
494         }
495         uint remaining = FundedTokens.sub(totalClaimedRewards);
496         return remaining;
497     }
498     
499    
500 }