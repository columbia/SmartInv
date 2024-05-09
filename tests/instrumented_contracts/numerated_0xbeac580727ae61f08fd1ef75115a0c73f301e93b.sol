1 // SPDX-License-Identifier: SimPL-2.0
2 pragma solidity 0.6.12;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         return mod(a, b, "SafeMath: modulo by zero");
48     }
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 }
54 
55 library Address {
56     function isContract(address account) internal view returns (bool) {
57         uint256 size;
58         assembly { size := extcodesize(account) }
59         return size > 0;
60     }
61     function sendValue(address payable recipient, uint256 amount) internal {
62         require(address(this).balance >= amount, "Address: insufficient balance");
63         (bool success, ) = recipient.call{ value: amount }("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
67       return functionCall(target, data, "Address: low-level call failed");
68     }
69     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
70         return _functionCallWithValue(target, data, 0, errorMessage);
71     }
72     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
73         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
74     }
75     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
76         require(address(this).balance >= value, "Address: insufficient balance for call");
77         return _functionCallWithValue(target, data, value, errorMessage);
78     }
79     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
80         require(isContract(target), "Address: call to non-contract");
81         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
82         if (success) {
83             return returndata;
84         } else {
85             if (returndata.length > 0) {
86                 assembly {
87                     let returndata_size := mload(returndata)
88                     revert(add(32, returndata), returndata_size)
89                 }
90             } else {
91                 revert(errorMessage);
92             }
93         }
94     }
95 }
96 
97 
98 library SafeERC20 {
99     using SafeMath for uint256;
100     using Address for address;
101     function safeTransfer(IERC20 token, address to, uint256 value) internal {
102         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
103     }
104 
105     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
106         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
107     }
108     function safeApprove(IERC20 token, address spender, uint256 value) internal {
109         require((value == 0) || (token.allowance(address(this), spender) == 0),
110             "SafeERC20: approve from non-zero to non-zero allowance"
111         );
112         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
113     }
114     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
115         uint256 newAllowance = token.allowance(address(this), spender).add(value);
116         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
117     }
118     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
120         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
121     }
122     function _callOptionalReturn(IERC20 token, bytes memory data) private {
123         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
124         if (returndata.length > 0) { // Return data is optional
125             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
126         }
127     }
128 }
129 
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address payable) {
132         return msg.sender;
133     }
134     function _msgData() internal view virtual returns (bytes memory) {
135         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
136         return msg.data;
137     }
138 }
139 contract Ownable is Context {
140     address private _owner;
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142     constructor () internal {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         emit OwnershipTransferred(address(0), msgSender);
146     }
147     function owner() public view returns (address) {
148         return _owner;
149     }
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154     function renounceOwnership() public virtual onlyOwner {
155         emit OwnershipTransferred(_owner, address(0));
156         _owner = address(0);
157     }
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 library EnumerableSet {
166     // To implement this library for multiple types with as little code
167     // repetition as possible, we write it in terms of a generic Set type with
168     // bytes32 values.
169     // The Set implementation uses private functions, and user-facing
170     // implementations (such as AddressSet) are just wrappers around the
171     // underlying Set.
172     // This means that we can only create new EnumerableSets for types that fit
173     // in bytes32.
174 
175     struct Set {
176         // Storage of set values
177         bytes32[] _values;
178 
179         // Position of the value in the `values` array, plus 1 because index 0
180         // means a value is not in the set.
181         mapping (bytes32 => uint256) _indexes;
182     }
183 
184     /**
185      * @dev Add a value to a set. O(1).
186      *
187      * Returns true if the value was added to the set, that is if it was not
188      * already present.
189      */
190     function _add(Set storage set, bytes32 value) private returns (bool) {
191         if (!_contains(set, value)) {
192             set._values.push(value);
193             // The value is stored at length-1, but we add 1 to all indexes
194             // and use 0 as a sentinel value
195             set._indexes[value] = set._values.length;
196             return true;
197         } else {
198             return false;
199         }
200     }
201 
202     /**
203      * @dev Removes a value from a set. O(1).
204      *
205      * Returns true if the value was removed from the set, that is if it was
206      * present.
207      */
208     function _remove(Set storage set, bytes32 value) private returns (bool) {
209         // We read and store the value's index to prevent multiple reads from the same storage slot
210         uint256 valueIndex = set._indexes[value];
211 
212         if (valueIndex != 0) { // Equivalent to contains(set, value)
213             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
214             // the array, and then remove the last element (sometimes called as 'swap and pop').
215             // This modifies the order of the array, as noted in {at}.
216 
217             uint256 toDeleteIndex = valueIndex - 1;
218             uint256 lastIndex = set._values.length - 1;
219 
220             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
221             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
222 
223             bytes32 lastvalue = set._values[lastIndex];
224 
225             // Move the last value to the index where the value to delete is
226             set._values[toDeleteIndex] = lastvalue;
227             // Update the index for the moved value
228             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
229 
230             // Delete the slot where the moved value was stored
231             set._values.pop();
232 
233             // Delete the index for the deleted slot
234             delete set._indexes[value];
235 
236             return true;
237         } else {
238             return false;
239         }
240     }
241 
242     /**
243      * @dev Returns true if the value is in the set. O(1).
244      */
245     function _contains(Set storage set, bytes32 value) private view returns (bool) {
246         return set._indexes[value] != 0;
247     }
248 
249     /**
250      * @dev Returns the number of values on the set. O(1).
251      */
252     function _length(Set storage set) private view returns (uint256) {
253         return set._values.length;
254     }
255 
256    /**
257     * @dev Returns the value stored at position `index` in the set. O(1).
258     *
259     * Note that there are no guarantees on the ordering of values inside the
260     * array, and it may change when more values are added or removed.
261     *
262     * Requirements:
263     *
264     * - `index` must be strictly less than {length}.
265     */
266     function _at(Set storage set, uint256 index) private view returns (bytes32) {
267         require(set._values.length > index, "EnumerableSet: index out of bounds");
268         return set._values[index];
269     }
270 
271     // AddressSet
272 
273     struct AddressSet {
274         Set _inner;
275     }
276 
277     /**
278      * @dev Add a value to a set. O(1).
279      *
280      * Returns true if the value was added to the set, that is if it was not
281      * already present.
282      */
283     function add(AddressSet storage set, address value) internal returns (bool) {
284         return _add(set._inner, bytes32(uint256(value)));
285     }
286 
287     /**
288      * @dev Removes a value from a set. O(1).
289      *
290      * Returns true if the value was removed from the set, that is if it was
291      * present.
292      */
293     function remove(AddressSet storage set, address value) internal returns (bool) {
294         return _remove(set._inner, bytes32(uint256(value)));
295     }
296 
297     /**
298      * @dev Returns true if the value is in the set. O(1).
299      */
300     function contains(AddressSet storage set, address value) internal view returns (bool) {
301         return _contains(set._inner, bytes32(uint256(value)));
302     }
303 
304     /**
305      * @dev Returns the number of values in the set. O(1).
306      */
307     function length(AddressSet storage set) internal view returns (uint256) {
308         return _length(set._inner);
309     }
310 
311    /**
312     * @dev Returns the value stored at position `index` in the set. O(1).
313     *
314     * Note that there are no guarantees on the ordering of values inside the
315     * array, and it may change when more values are added or removed.
316     *
317     * Requirements:
318     *
319     * - `index` must be strictly less than {length}.
320     */
321     function at(AddressSet storage set, uint256 index) internal view returns (address) {
322         return address(uint256(_at(set._inner, index)));
323     }
324 
325 
326     // UintSet
327 
328     struct UintSet {
329         Set _inner;
330     }
331 
332     /**
333      * @dev Add a value to a set. O(1).
334      *
335      * Returns true if the value was added to the set, that is if it was not
336      * already present.
337      */
338     function add(UintSet storage set, uint256 value) internal returns (bool) {
339         return _add(set._inner, bytes32(value));
340     }
341 
342     /**
343      * @dev Removes a value from a set. O(1).
344      *
345      * Returns true if the value was removed from the set, that is if it was
346      * present.
347      */
348     function remove(UintSet storage set, uint256 value) internal returns (bool) {
349         return _remove(set._inner, bytes32(value));
350     }
351 
352     /**
353      * @dev Returns true if the value is in the set. O(1).
354      */
355     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
356         return _contains(set._inner, bytes32(value));
357     }
358 
359     /**
360      * @dev Returns the number of values on the set. O(1).
361      */
362     function length(UintSet storage set) internal view returns (uint256) {
363         return _length(set._inner);
364     }
365 
366    /**
367     * @dev Returns the value stored at position `index` in the set. O(1).
368     *
369     * Note that there are no guarantees on the ordering of values inside the
370     * array, and it may change when more values are added or removed.
371     *
372     * Requirements:
373     *
374     * - `index` must be strictly less than {length}.
375     */
376     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
377         return uint256(_at(set._inner, index));
378     }
379 }
380 
381 interface IMigrator {
382     function migrate(IERC20 token) external returns (IERC20);
383 }
384 interface IAward {
385     function addFreeAward(address _user, uint256 _amount) external;
386     function addAward(address _user, uint256 _amount) external;
387     function withdraw(uint256 _amount) external;
388     function destroy(uint256 amount) external;
389 }
390 
391 contract LPStaking is Ownable {
392     using SafeMath for uint256;
393     using SafeERC20 for IERC20;
394 
395     // Info of each user.
396     struct UserInfo {
397         uint256 amount;         // How many LP tokens the user has provided.
398         uint256 rewardDebt;     // Reward debt. See explanation below.
399         uint256 lockRewards;    // lock rewards when not migrated
400         uint256 stakeBlocks;    // number of blocks containing staking;
401         uint256 lastBlock;      // the last block.number when update shares;
402         uint256 accStakeShares; // accumulate stakes: ∑(amount * stakeBlocks);
403     }
404 
405     // Info of each pool.
406     struct PoolInfo {
407         IERC20 lpToken;           // Address of LP token contract.
408         uint256 allocPoint;       // How many allocation points assigned to this pool. Token to distribute per block.
409         uint256 lastRewardBlock;  // Last block number that Token distribution occurs.
410         uint256 accTokenPerShare; // Accumulated Token per share, times 1e12. See below.
411     }
412 
413     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
414     IMigrator public migrator;
415     // The block number when Token mining starts.
416     uint256 immutable public startBlock;
417     // The block number when Token mining ends.
418     uint256 immutable public endBlock;
419     // Reward token created per block.
420     uint256 public tokenPerBlock = 755 * 10 ** 16;
421 
422     mapping(address => bool) public poolIn;
423     // Info of each pool.
424     PoolInfo[] public poolInfo;
425     // Info of each user that stakes LP tokens.
426     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
427     // Total allocation poitns. Must be the sum of all allocation points in all pools.
428     uint256 public totalAllocPoint = 0;
429 
430     bool public migrated;
431     IAward award;
432 
433     event Add(uint256 allocPoint, address lpToken, bool withUpdate);
434     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
435     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
436     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
437     event SetMigrator(address indexed newMigrator);
438     event Migrate(uint256 pid, address indexed lpToken, address indexed newToken);
439     event Initialization(address award, uint256 tokenPerBlock, uint256 startBlock, uint256 endBlock);
440     event Set(uint256 pid, uint256 allocPoint, bool withUpdate);
441     event UpdatePool(uint256 pid, uint256 accTokenPerShare, uint256 lastRewardBlock);
442 
443     constructor(
444         IAward _award,
445         uint256 _tokenPerBlock,
446         uint256 _startBlock,
447         uint256 _endBlock
448     ) public {
449         require(_startBlock < _endBlock, "LPStaking: invalid block range");
450         award = _award;
451         tokenPerBlock = _tokenPerBlock;
452         startBlock = _startBlock;
453         endBlock = _endBlock;
454         emit Initialization(address(_award), _tokenPerBlock, _startBlock, _endBlock);
455     }
456 
457     function poolLength() external view returns (uint256) {
458         return poolInfo.length;
459     }
460 
461     // Add a new lp to the pool. Can only be called by the owner.
462     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
463     function add(uint256 _allocPoint, address _lpToken, bool _withUpdate) public onlyOwner {
464         require(!poolIn[_lpToken], "LPStaking: duplicate lpToken");
465         if (_withUpdate) {
466             batchUpdatePools();
467         }
468         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
469         totalAllocPoint = totalAllocPoint.add(_allocPoint);
470         poolInfo.push(PoolInfo({
471             lpToken : IERC20(_lpToken),
472             allocPoint : _allocPoint,
473             lastRewardBlock : lastRewardBlock,
474             accTokenPerShare : 0
475             }));
476         poolIn[_lpToken] = true;
477         emit Add(_allocPoint, _lpToken, _withUpdate);
478     }
479 
480     // Update the given pool's Token allocation point. Can only be called by the owner.
481     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
482         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
483         if (_withUpdate) {
484             batchUpdatePools();
485         }
486         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
487         poolInfo[_pid].allocPoint = _allocPoint;
488         emit Set(_pid, _allocPoint, _withUpdate);
489     }
490 
491     // Set the migrator contract. Can only be called by the owner.
492     function setMigrator(IMigrator _migrator) public onlyOwner {
493         migrator = _migrator;
494         emit SetMigrator(address(_migrator));
495     }
496 
497     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
498     function migrate(uint256 _pid) public {
499         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
500         require(address(migrator) != address(0), "migrate: no migrator");
501         PoolInfo storage pool = poolInfo[_pid];
502         IERC20 lpToken = pool.lpToken;
503         uint256 bal = lpToken.balanceOf(address(this));
504         lpToken.safeApprove(address(migrator), bal);
505         IERC20 newLpToken = migrator.migrate(lpToken);
506         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
507         pool.lpToken = newLpToken;
508         emit Migrate(_pid, address(lpToken), address(newLpToken));
509     }
510 
511     function setMigrated() onlyOwner public {
512         migrated = true;
513     }
514 
515     // Return reward multiplier over the given _from to _to block.
516     function getMultiplier(uint256 _from, uint256 _to) private view returns (uint256) {
517         if (_to <= endBlock) {
518             return _to.sub(_from);
519         } else if (_from >= endBlock) {
520             return 0;
521         } else {
522             return endBlock.sub(_from);
523         }
524     }
525 
526     // View function to see pending Token on frontend.
527     function pendingShares(uint256 _pid, address _user) external view returns (uint256) {
528         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
529         PoolInfo storage pool = poolInfo[_pid];
530         UserInfo storage user = userInfo[_pid][_user];
531         uint256 accTokenPerShare = pool.accTokenPerShare;
532         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
533         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
534             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
535             uint256 rewards = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
536             accTokenPerShare = accTokenPerShare.add(rewards.mul(1e12).div(lpSupply));
537         }
538         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
539     }
540 
541     // Update reward vairables for all pools. Be careful of gas spending!
542     function batchUpdatePools() public {
543         uint256 length = poolInfo.length;
544         for (uint256 pid = 0; pid < length; ++pid) {
545             updatePool(pid);
546         }
547     }
548 
549     // Update reward variables of the given pool to be up-to-date.
550     function updatePool(uint256 _pid) public {
551         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
552         PoolInfo storage pool = poolInfo[_pid];
553         if (block.number > pool.lastRewardBlock) {
554             uint256 lpSupply = pool.lpToken.balanceOf(address(this));
555             if (lpSupply == 0) {
556                 pool.lastRewardBlock = block.number;
557             } else {
558                 uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
559                 uint256 rewards = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
560                 pool.accTokenPerShare = pool.accTokenPerShare.add(rewards.mul(1e12).div(lpSupply));
561                 pool.lastRewardBlock = block.number;
562             }
563         }
564         emit UpdatePool(_pid, pool.accTokenPerShare, pool.lastRewardBlock);
565     }
566 
567     function shareAwards(uint256 _pid) private {
568         PoolInfo storage pool = poolInfo[_pid];
569         UserInfo storage user = userInfo[_pid][msg.sender];
570         updatePool(_pid);
571         uint256 pending = 0;
572         if (user.amount > 0) {
573             pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
574 
575             uint256 num = block.number - user.lastBlock;
576             user.stakeBlocks = user.stakeBlocks.add(num);
577             user.accStakeShares = user.accStakeShares.add(user.amount.mul(num));
578         }
579         if (migrated) {
580             uint256 locked = user.lockRewards.add(pending);
581             user.lockRewards = 0;
582             uint256 audit = user.stakeBlocks.mul(user.amount);
583             if (user.accStakeShares > audit) {
584                 uint256 _locked = locked.mul(audit).div(user.accStakeShares);
585                 award.destroy(locked.sub(_locked));
586                 locked = _locked;
587             }
588             if (locked > 0) {
589                 award.addAward(msg.sender, locked);
590             }
591         } else {
592             user.lockRewards = user.lockRewards.add(pending);
593         }
594         user.lastBlock = block.number;
595     }
596 
597     // Deposit LP tokens to Staking for shares allocation.
598     function deposit(uint256 _pid, uint256 _amount) public {
599         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
600         PoolInfo storage pool = poolInfo[_pid];
601         UserInfo storage user = userInfo[_pid][msg.sender];
602         shareAwards(_pid);
603         pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
604         user.amount = user.amount.add(_amount);
605         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
606         emit Deposit(msg.sender, _pid, _amount);
607     }
608 
609     // Withdraw LP tokens from LPStaking.
610     function withdraw(uint256 _pid, uint256 _amount) public {
611         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
612         PoolInfo storage pool = poolInfo[_pid];
613         UserInfo storage user = userInfo[_pid][msg.sender];
614         require(user.amount >= _amount, "withdraw: not good");
615         shareAwards(_pid);
616         user.amount = user.amount.sub(_amount);
617         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
618         pool.lpToken.safeTransfer(msg.sender, _amount);
619         emit Withdraw(msg.sender, _pid, _amount);
620     }
621 
622     // Withdraw without caring about rewards. EMERGENCY ONLY.
623     function emergencyWithdraw(uint256 _pid) public {
624         require(_pid < poolInfo.length, "LPStaking: pool index overflow");
625         PoolInfo storage pool = poolInfo[_pid];
626         UserInfo storage user = userInfo[_pid][msg.sender];
627         pool.lpToken.safeTransfer(msg.sender, user.amount);
628         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
629         user.amount = 0;
630         user.rewardDebt = 0;
631     }
632 }