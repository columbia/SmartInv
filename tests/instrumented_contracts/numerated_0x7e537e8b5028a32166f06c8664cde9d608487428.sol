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
316 interface Token {
317     function transferFrom(address, address, uint) external returns (bool);
318     function transfer(address, uint) external returns (bool);
319 }
320 
321 interface IUniswapV2Router01 {
322     function factory() external pure returns (address);
323     function WETH() external pure returns (address);
324 
325     function addLiquidity(
326         address tokenA,
327         address tokenB,
328         uint amountADesired,
329         uint amountBDesired,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountA, uint amountB, uint liquidity);
335     function addLiquidityETH(
336         address token,
337         uint amountTokenDesired,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
343     function removeLiquidity(
344         address tokenA,
345         address tokenB,
346         uint liquidity,
347         uint amountAMin,
348         uint amountBMin,
349         address to,
350         uint deadline
351     ) external returns (uint amountA, uint amountB);
352     function removeLiquidityETH(
353         address token,
354         uint liquidity,
355         uint amountTokenMin,
356         uint amountETHMin,
357         address to,
358         uint deadline
359     ) external returns (uint amountToken, uint amountETH);
360     function removeLiquidityWithPermit(
361         address tokenA,
362         address tokenB,
363         uint liquidity,
364         uint amountAMin,
365         uint amountBMin,
366         address to,
367         uint deadline,
368         bool approveMax, uint8 v, bytes32 r, bytes32 s
369     ) external returns (uint amountA, uint amountB);
370     function removeLiquidityETHWithPermit(
371         address token,
372         uint liquidity,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline,
377         bool approveMax, uint8 v, bytes32 r, bytes32 s
378     ) external returns (uint amountToken, uint amountETH);
379     function swapExactTokensForTokens(
380         uint amountIn,
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external returns (uint[] memory amounts);
386     function swapTokensForExactTokens(
387         uint amountOut,
388         uint amountInMax,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external returns (uint[] memory amounts);
393     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
394         external
395         payable
396         returns (uint[] memory amounts);
397     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
398         external
399         returns (uint[] memory amounts);
400     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
401         external
402         returns (uint[] memory amounts);
403     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
404         external
405         payable
406         returns (uint[] memory amounts);
407 
408     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
409     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
410     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
411     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
412     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
413 }
414 
415 interface IUniswapV2Router02 is IUniswapV2Router01 {
416     function removeLiquidityETHSupportingFeeOnTransferTokens(
417         address token,
418         uint liquidity,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     ) external returns (uint amountETH);
424     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
425         address token,
426         uint liquidity,
427         uint amountTokenMin,
428         uint amountETHMin,
429         address to,
430         uint deadline,
431         bool approveMax, uint8 v, bytes32 r, bytes32 s
432     ) external returns (uint amountETH);
433 
434     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
435         uint amountIn,
436         uint amountOutMin,
437         address[] calldata path,
438         address to,
439         uint deadline
440     ) external;
441     function swapExactETHForTokensSupportingFeeOnTransferTokens(
442         uint amountOutMin,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external payable;
447     function swapExactTokensForETHSupportingFeeOnTransferTokens(
448         uint amountIn,
449         uint amountOutMin,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external;
454 }
455 
456 contract DaiVaultTimely is Ownable {
457     using SafeMath for uint;
458     using EnumerableSet for EnumerableSet.AddressSet;
459     
460     event RewardsTransferred(address holder, uint amount);
461     
462     address public constant uniswapV2router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
463     
464     IUniswapV2Router02 router = IUniswapV2Router02(uniswapV2router);
465     
466     // trusted deposit token contract address
467     address public constant trustedDepositTokenAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
468     // trusted reward token contract address
469     address public constant trustedRewardTokenAddress = 0xf4CD3d3Fda8d7Fd6C5a500203e38640A70Bf9577;
470     // reward rate
471     uint public rewardRatePercentX100 = 24e2;
472     uint public constant rewardInterval = 365 days;
473     uint public cliffTime = 72 hours;
474     uint public withdrawFeePercentX100 = 50;
475     
476     uint public totalClaimedRewards = 0;
477     
478     uint public vaultDuration = 365 days;
479     
480     // admin can transfer out reward tokens from this contract one month after vault has ended
481     uint public adminCanClaimAfter = 395 days;
482     
483     uint public vaultDeployTime;
484     uint public adminClaimableTime;
485     uint public vaultEndTime;
486     
487     EnumerableSet.AddressSet private holders;
488     
489     mapping (address => uint) public depositedTokens;
490     mapping (address => uint) public depositTime;
491     mapping (address => uint) public lastClaimedTime;
492     mapping (address => uint) public totalEarnedTokens;
493     
494     constructor () public {
495         vaultDeployTime = now;
496         vaultEndTime = vaultDeployTime.add(vaultDuration);
497         adminClaimableTime = vaultDeployTime.add(adminCanClaimAfter);
498     }
499     
500     function getTokenPerDaiUniswap() public view returns (uint) {
501         address[] memory _path = new address[](3);
502         _path[0] = trustedDepositTokenAddress;
503         _path[1] = router.WETH();
504         _path[2] = trustedRewardTokenAddress;
505         uint[] memory _amts = router.getAmountsOut(1e18, _path);
506         return _amts[2];
507     }
508     
509     function updateAccount(address account) private {
510         uint pendingDivs = getPendingDivs(account);
511         if (pendingDivs > 0) {
512             require(Token(trustedRewardTokenAddress).transfer(account, pendingDivs.mul(getTokenPerDaiUniswap()).div(1e18)), "Could not transfer tokens.");
513             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
514             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
515             emit RewardsTransferred(account, pendingDivs);
516         }
517         lastClaimedTime[account] = now;
518     }
519     
520     
521    
522     
523     function getPendingDivs(address _holder) public view returns (uint) {
524         if (!holders.contains(_holder)) return 0;
525         if (depositedTokens[_holder] == 0) return 0;
526         
527         uint timeDiff;
528         uint _now = now;
529         if (_now > vaultEndTime) {
530             _now = vaultEndTime;
531         }
532         
533         if (lastClaimedTime[_holder] >= _now) {
534             timeDiff = 0;
535         } else {
536             timeDiff = _now.sub(lastClaimedTime[_holder]);
537         }
538 
539         uint depositedAmount = depositedTokens[_holder];
540         
541         uint pendingDivs = depositedAmount
542                             .mul(rewardRatePercentX100)
543                             .mul(timeDiff)
544                             .div(rewardInterval)
545                             .div(1e4);
546             
547         return pendingDivs;
548     }
549     
550     function getNumberOfHolders() public view returns (uint) {
551         return holders.length();
552     }
553     
554     
555     function deposit(uint amountToDeposit) public {
556         require(amountToDeposit > 0, "Cannot deposit 0 Tokens");
557         require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");
558         
559         updateAccount(msg.sender);
560         
561         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToDeposit);
562         
563         if (!holders.contains(msg.sender)) {
564             holders.add(msg.sender);
565             depositTime[msg.sender] = now;
566         }
567     }
568     
569     function withdraw(uint amountToWithdraw) public {
570         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens");
571         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
572         require(now.sub(depositTime[msg.sender]) > cliffTime, "You recently deposited!, please wait before withdrawing.");
573         
574         updateAccount(msg.sender);
575         
576         uint fee = amountToWithdraw.mul(withdrawFeePercentX100).div(1e4);
577         uint amountAfterFee = amountToWithdraw.sub(fee);
578     
579         require(Token(trustedDepositTokenAddress).transfer(owner, fee), "Could not transfer fee!");
580         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
581         
582         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
583         
584         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
585             holders.remove(msg.sender);
586         }
587     }
588     
589     // emergency withdraw without caring about pending earnings
590     // pending earnings will be lost / set to 0 if used emergency withdraw
591     function emergencyWithdraw(uint amountToWithdraw) public {
592         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens");
593         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
594         require(now.sub(depositTime[msg.sender]) > cliffTime, "You recently deposited!, please wait before withdrawing.");
595 
596         // set pending earnings to 0 here
597         lastClaimedTime[msg.sender] = now;
598     
599         uint fee = amountToWithdraw.mul(withdrawFeePercentX100).div(1e4);
600         uint amountAfterFee = amountToWithdraw.sub(fee);
601     
602         require(Token(trustedDepositTokenAddress).transfer(owner, fee), "Could not transfer fee!");
603         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
604         
605         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
606         
607         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
608             holders.remove(msg.sender);
609         }
610     }
611     
612     function claim() public {
613         updateAccount(msg.sender);
614     }
615     
616     function getDepositorsList(uint startIndex, uint endIndex) 
617         public 
618         view 
619         returns (address[] memory stakers, 
620             uint[] memory stakingTimestamps, 
621             uint[] memory lastClaimedTimeStamps,
622             uint[] memory stakedTokens) {
623         require (startIndex < endIndex);
624         
625         uint length = endIndex.sub(startIndex);
626         address[] memory _stakers = new address[](length);
627         uint[] memory _stakingTimestamps = new uint[](length);
628         uint[] memory _lastClaimedTimeStamps = new uint[](length);
629         uint[] memory _stakedTokens = new uint[](length);
630         
631         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
632             address staker = holders.at(i);
633             uint listIndex = i.sub(startIndex);
634             _stakers[listIndex] = staker;
635             _stakingTimestamps[listIndex] = depositTime[staker];
636             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
637             _stakedTokens[listIndex] = depositedTokens[staker];
638         }
639         
640         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
641     }
642 
643     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
644     // Admin cannot transfer out deposit tokens from this smart contract
645     // Admin can transfer out reward tokens from this address once adminClaimableTime has reached
646     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
647         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out Deposit Tokens from this contract!");
648         
649         require((_tokenAddr != trustedRewardTokenAddress) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens yet!");
650         
651         Token(_tokenAddr).transfer(_to, _amount);
652     }
653 }