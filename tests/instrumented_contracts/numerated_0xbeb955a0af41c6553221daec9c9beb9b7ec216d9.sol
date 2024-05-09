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
322 contract YfDAIstaking is Ownable {
323     using SafeMath for uint;
324     using EnumerableSet for EnumerableSet.AddressSet;
325     
326     event RewardsTransferred(address holder, uint amount);
327     
328     // yfdai token contract address
329     address public constant tokenAddress = 0xf4CD3d3Fda8d7Fd6C5a500203e38640A70Bf9577;
330     
331     // reward rate 72.00% per year
332     uint public constant rewardRate = 7200;
333     uint public constant rewardInterval = 365 days;
334     
335     // staking fee 1.50 percent
336     uint public constant stakingFeeRate = 150;
337     
338     // unstaking fee 0.50 percent
339     uint public constant unstakingFeeRate = 50;
340     
341     // unstaking possible after 72 hours
342     uint public constant cliffTime = 72 hours;
343     
344     uint public totalClaimedRewards = 0;
345     
346     EnumerableSet.AddressSet private holders;
347     
348     mapping (address => uint) public depositedTokens;
349     mapping (address => uint) public stakingTime;
350     mapping (address => uint) public lastClaimedTime;
351     mapping (address => uint) public totalEarnedTokens;
352     
353     function updateAccount(address account) private {
354         uint pendingDivs = getPendingDivs(account);
355         if (pendingDivs > 0) {
356             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
357             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
358             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
359             emit RewardsTransferred(account, pendingDivs);
360         }
361         lastClaimedTime[account] = now;
362     }
363     
364     function getPendingDivs(address _holder) public view returns (uint) {
365         if (!holders.contains(_holder)) return 0;
366         if (depositedTokens[_holder] == 0) return 0;
367 
368         uint timeDiff = now.sub(lastClaimedTime[_holder]);
369         uint stakedAmount = depositedTokens[_holder];
370         
371         uint pendingDivs = stakedAmount
372                             .mul(rewardRate)
373                             .mul(timeDiff)
374                             .div(rewardInterval)
375                             .div(1e4);
376             
377         return pendingDivs;
378     }
379     
380     function getNumberOfHolders() public view returns (uint) {
381         return holders.length();
382     }
383     
384     
385     function deposit(uint amountToStake) public {
386         require(amountToStake > 0, "Cannot deposit 0 Tokens");
387         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
388         
389         updateAccount(msg.sender);
390         
391         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
392         uint amountAfterFee = amountToStake.sub(fee);
393         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");
394         
395         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
396         
397         if (!holders.contains(msg.sender)) {
398             holders.add(msg.sender);
399             stakingTime[msg.sender] = now;
400         }
401     }
402     
403     function withdraw(uint amountToWithdraw) public {
404         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
405         
406         require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
407         
408         updateAccount(msg.sender);
409         
410         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
411         uint amountAfterFee = amountToWithdraw.sub(fee);
412         
413         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");
414         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
415         
416         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
417         
418         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
419             holders.remove(msg.sender);
420         }
421     }
422     
423     function claimDivs() public {
424         updateAccount(msg.sender);
425     }
426     
427     
428     uint private constant stakingAndDaoTokens = 7350e18;
429     
430     function getStakingAndDaoAmount() public view returns (uint) {
431         if (totalClaimedRewards >= stakingAndDaoTokens) {
432             return 0;
433         }
434         uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
435         return remaining;
436     }
437     
438     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
439     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
440         if (_tokenAddr == tokenAddress) {
441             if (_amount > getStakingAndDaoAmount()) {
442                 revert();
443             }
444             totalClaimedRewards = totalClaimedRewards.add(_amount);
445         }
446         Token(_tokenAddr).transfer(_to, _amount);
447     }
448 }