1 
2 pragma solidity 0.6.12;
3 
4 // SPDX-License-Identifier: BSD-3-Clause
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @dev Library for managing
38  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
39  * types.
40  *
41  * Sets have the following properties:
42  *
43  * - Elements are added, removed, and checked for existence in constant time
44  * (O(1)).
45  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
46  *
47  * ```
48  * contract Example {
49  *     // Add the library methods
50  *     using EnumerableSet for EnumerableSet.AddressSet;
51  *
52  *     // Declare a set state variable
53  *     EnumerableSet.AddressSet private mySet;
54  * }
55  * ```
56  *
57  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
58  * (`UintSet`) are supported.
59  */
60 library EnumerableSet {
61     // To implement this library for multiple types with as little code
62     // repetition as possible, we write it in terms of a generic Set type with
63     // bytes32 values.
64     // The Set implementation uses private functions, and user-facing
65     // implementations (such as AddressSet) are just wrappers around the
66     // underlying Set.
67     // This means that we can only create new EnumerableSets for types that fit
68     // in bytes32.
69 
70     struct Set {
71         // Storage of set values
72         bytes32[] _values;
73 
74         // Position of the value in the `values` array, plus 1 because index 0
75         // means a value is not in the set.
76         mapping (bytes32 => uint256) _indexes;
77     }
78 
79     /**
80      * @dev Add a value to a set. O(1).
81      *
82      * Returns true if the value was added to the set, that is if it was not
83      * already present.
84      */
85     function _add(Set storage set, bytes32 value) private returns (bool) {
86         if (!_contains(set, value)) {
87             set._values.push(value);
88             // The value is stored at length-1, but we add 1 to all indexes
89             // and use 0 as a sentinel value
90             set._indexes[value] = set._values.length;
91             return true;
92         } else {
93             return false;
94         }
95     }
96 
97     /**
98      * @dev Removes a value from a set. O(1).
99      *
100      * Returns true if the value was removed from the set, that is if it was
101      * present.
102      */
103     function _remove(Set storage set, bytes32 value) private returns (bool) {
104         // We read and store the value's index to prevent multiple reads from the same storage slot
105         uint256 valueIndex = set._indexes[value];
106 
107         if (valueIndex != 0) { // Equivalent to contains(set, value)
108             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
109             // the array, and then remove the last element (sometimes called as 'swap and pop').
110             // This modifies the order of the array, as noted in {at}.
111 
112             uint256 toDeleteIndex = valueIndex - 1;
113             uint256 lastIndex = set._values.length - 1;
114 
115             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
116             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
117 
118             bytes32 lastvalue = set._values[lastIndex];
119 
120             // Move the last value to the index where the value to delete is
121             set._values[toDeleteIndex] = lastvalue;
122             // Update the index for the moved value
123             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
124 
125             // Delete the slot where the moved value was stored
126             set._values.pop();
127 
128             // Delete the index for the deleted slot
129             delete set._indexes[value];
130 
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     /**
138      * @dev Returns true if the value is in the set. O(1).
139      */
140     function _contains(Set storage set, bytes32 value) private view returns (bool) {
141         return set._indexes[value] != 0;
142     }
143 
144     /**
145      * @dev Returns the number of values on the set. O(1).
146      */
147     function _length(Set storage set) private view returns (uint256) {
148         return set._values.length;
149     }
150 
151    /**
152     * @dev Returns the value stored at position `index` in the set. O(1).
153     *
154     * Note that there are no guarantees on the ordering of values inside the
155     * array, and it may change when more values are added or removed.
156     *
157     * Requirements:
158     *
159     * - `index` must be strictly less than {length}.
160     */
161     function _at(Set storage set, uint256 index) private view returns (bytes32) {
162         require(set._values.length > index, "EnumerableSet: index out of bounds");
163         return set._values[index];
164     }
165 
166     // AddressSet
167 
168     struct AddressSet {
169         Set _inner;
170     }
171 
172     /**
173      * @dev Add a value to a set. O(1).
174      *
175      * Returns true if the value was added to the set, that is if it was not
176      * already present.
177      */
178     function add(AddressSet storage set, address value) internal returns (bool) {
179         return _add(set._inner, bytes32(uint256(value)));
180     }
181 
182     /**
183      * @dev Removes a value from a set. O(1).
184      *
185      * Returns true if the value was removed from the set, that is if it was
186      * present.
187      */
188     function remove(AddressSet storage set, address value) internal returns (bool) {
189         return _remove(set._inner, bytes32(uint256(value)));
190     }
191 
192     /**
193      * @dev Returns true if the value is in the set. O(1).
194      */
195     function contains(AddressSet storage set, address value) internal view returns (bool) {
196         return _contains(set._inner, bytes32(uint256(value)));
197     }
198 
199     /**
200      * @dev Returns the number of values in the set. O(1).
201      */
202     function length(AddressSet storage set) internal view returns (uint256) {
203         return _length(set._inner);
204     }
205 
206    /**
207     * @dev Returns the value stored at position `index` in the set. O(1).
208     *
209     * Note that there are no guarantees on the ordering of values inside the
210     * array, and it may change when more values are added or removed.
211     *
212     * Requirements:
213     *
214     * - `index` must be strictly less than {length}.
215     */
216     function at(AddressSet storage set, uint256 index) internal view returns (address) {
217         return address(uint256(_at(set._inner, index)));
218     }
219 
220 
221     // UintSet
222 
223     struct UintSet {
224         Set _inner;
225     }
226 
227     /**
228      * @dev Add a value to a set. O(1).
229      *
230      * Returns true if the value was added to the set, that is if it was not
231      * already present.
232      */
233     function add(UintSet storage set, uint256 value) internal returns (bool) {
234         return _add(set._inner, bytes32(value));
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the value was removed from the set, that is if it was
241      * present.
242      */
243     function remove(UintSet storage set, uint256 value) internal returns (bool) {
244         return _remove(set._inner, bytes32(value));
245     }
246 
247     /**
248      * @dev Returns true if the value is in the set. O(1).
249      */
250     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
251         return _contains(set._inner, bytes32(value));
252     }
253 
254     /**
255      * @dev Returns the number of values on the set. O(1).
256      */
257     function length(UintSet storage set) internal view returns (uint256) {
258         return _length(set._inner);
259     }
260 
261    /**
262     * @dev Returns the value stored at position `index` in the set. O(1).
263     *
264     * Note that there are no guarantees on the ordering of values inside the
265     * array, and it may change when more values are added or removed.
266     *
267     * Requirements:
268     *
269     * - `index` must be strictly less than {length}.
270     */
271     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
272         return uint256(_at(set._inner, index));
273     }
274 }
275 
276 /**
277  * @title Ownable
278  * @dev The Ownable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract Ownable {
282   address public owner;
283 
284 
285   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287 
288   /**
289    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290    * account.
291    */
292   constructor() public {
293     owner = msg.sender;
294   }
295 
296 
297   /**
298    * @dev Throws if called by any account other than the owner.
299    */
300   modifier onlyOwner() {
301     require(msg.sender == owner);
302     _;
303   }
304 
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address newOwner) onlyOwner public {
311     require(newOwner != address(0));
312     emit OwnershipTransferred(owner, newOwner);
313     owner = newOwner;
314   }
315 }
316 
317 
318 interface Token {
319     function transferFrom(address, address, uint) external returns (bool);
320     function transfer(address, uint) external returns (bool);
321 }
322 
323 contract YfTETHERstaking is Ownable {
324     using SafeMath for uint;
325     using EnumerableSet for EnumerableSet.AddressSet;
326     
327     event RewardsTransferred(address holder, uint amount);
328     
329     // yftether token contract address
330     address public constant tokenAddress = 0x94F31aC896c9823D81cf9C2C93feCEeD4923218f;
331     
332     // reward rate 72.00% per year
333     uint public constant rewardRate = 7200;
334     uint public constant rewardInterval = 365 days;
335     
336     // staking fee 1.50 percent
337     uint public constant stakingFeeRate = 150;
338     
339     // unstaking fee 0.50 percent
340     uint public constant unstakingFeeRate = 50;
341     
342     // unstaking possible after 72 hours
343     uint public constant cliffTime = 72 hours;
344     
345     uint public totalClaimedRewards = 0;
346     
347     EnumerableSet.AddressSet private holders;
348     
349     mapping (address => uint) public depositedTokens;
350     mapping (address => uint) public stakingTime;
351     mapping (address => uint) public lastClaimedTime;
352     mapping (address => uint) public totalEarnedTokens;
353     
354     function updateAccount(address account) private {
355         uint pendingDivs = getPendingDivs(account);
356         if (pendingDivs > 0) {
357             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
358             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
359             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
360             emit RewardsTransferred(account, pendingDivs);
361         }
362         lastClaimedTime[account] = now;
363     }
364     
365     function getPendingDivs(address _holder) public view returns (uint) {
366         if (!holders.contains(_holder)) return 0;
367         if (depositedTokens[_holder] == 0) return 0;
368 
369         uint timeDiff = now.sub(lastClaimedTime[_holder]);
370         uint stakedAmount = depositedTokens[_holder];
371         
372         uint pendingDivs = stakedAmount
373                             .mul(rewardRate)
374                             .mul(timeDiff)
375                             .div(rewardInterval)
376                             .div(1e4);
377             
378         return pendingDivs;
379     }
380     
381     function getNumberOfHolders() public view returns (uint) {
382         return holders.length();
383     }
384     
385     
386     function deposit(uint amountToStake) public {
387         require(amountToStake > 0, "Cannot deposit 0 Tokens");
388         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
389         
390         updateAccount(msg.sender);
391         
392         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
393         uint amountAfterFee = amountToStake.sub(fee);
394         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");
395         
396         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
397         
398         if (!holders.contains(msg.sender)) {
399             holders.add(msg.sender);
400             stakingTime[msg.sender] = now;
401         }
402     }
403     
404     function withdraw(uint amountToWithdraw) public {
405         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
406         
407         require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
408         
409         updateAccount(msg.sender);
410         
411         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
412         uint amountAfterFee = amountToWithdraw.sub(fee);
413         
414         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");
415         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
416         
417         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
418         
419         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
420             holders.remove(msg.sender);
421         }
422     }
423     
424     function claimDivs() public {
425         updateAccount(msg.sender);
426     }
427     
428     function getStakersList(uint startIndex, uint endIndex) 
429         public 
430         view 
431         returns (address[] memory stakers, 
432             uint[] memory stakingTimestamps, 
433             uint[] memory lastClaimedTimeStamps,
434             uint[] memory stakedTokens) {
435         require (startIndex < endIndex);
436         
437         uint length = endIndex.sub(startIndex);
438         address[] memory _stakers = new address[](length);
439         uint[] memory _stakingTimestamps = new uint[](length);
440         uint[] memory _lastClaimedTimeStamps = new uint[](length);
441         uint[] memory _stakedTokens = new uint[](length);
442         
443         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
444             address staker = holders.at(i);
445             uint listIndex = i.sub(startIndex);
446             _stakers[listIndex] = staker;
447             _stakingTimestamps[listIndex] = stakingTime[staker];
448             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
449             _stakedTokens[listIndex] = depositedTokens[staker];
450         }
451         
452         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
453     }
454     
455     
456     uint private constant stakingAndDaoTokens = 5129e18;
457     
458     function getStakingAndDaoAmount() public view returns (uint) {
459         if (totalClaimedRewards >= stakingAndDaoTokens) {
460             return 0;
461         }
462         uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
463         return remaining;
464     }
465     
466     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
467     // Admin cannot transfer out YFTE from this smart contract
468     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
469         require (_tokenAddr != tokenAddress, "Cannot Transfer Out YFTE!");
470         Token(_tokenAddr).transfer(_to, _amount);
471     }
472 }