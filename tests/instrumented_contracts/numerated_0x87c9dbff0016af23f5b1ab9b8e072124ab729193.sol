1 // File: contracts/library/ERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 interface ERC20 {
6 
7     function totalSupply() public view returns (uint);
8     function balanceOf(address owner) public view returns (uint);
9     function allowance(address owner, address spender) public view returns (uint);
10     function transfer(address to, uint value) public returns (bool);
11     function transferFrom(address from, address to, uint value) public returns (bool);
12     function approve(address spender, uint value) public returns (bool);
13 
14 }
15 
16 // File: contracts/library/Ownable.sol
17 
18 pragma solidity ^0.4.24;
19 
20 contract Ownable {
21 
22     address public owner;
23 
24     modifier onlyOwner {
25         require(isOwner(msg.sender));
26         _;
27     }
28 
29     function Ownable() public {
30         owner = msg.sender;
31     }
32 
33     function transferOwnership(address _newOwner) public onlyOwner {
34         owner = _newOwner;
35     }
36 
37     function isOwner(address _address) public view returns (bool) {
38         return owner == _address;
39     }
40 }
41 
42 // File: contracts/library/SafeMath.sol
43 
44 pragma solidity ^0.4.24;
45 
46 library SafeMath {
47 
48     function mul(uint a, uint b) internal pure returns (uint) {
49         uint c = a * b;
50         assert(a == 0 || c / a == b);
51         return c;
52     }
53 
54     function div(uint a, uint b) internal pure returns (uint) {
55         assert(b > 0);
56         uint c = a / b;
57         assert(a == b * c + a % b);
58         return c;
59     }
60 
61     function sub(uint a, uint b) internal pure returns (uint) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     function add(uint a, uint b) internal pure returns (uint) {
67         uint c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 
72     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
73         return a >= b ? a : b;
74     }
75 
76     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
77         return a < b ? a : b;
78     }
79 
80     function max256(uint a, uint b) internal pure returns (uint) {
81         return a >= b ? a : b;
82     }
83 
84     function min256(uint a, uint b) internal pure returns (uint) {
85         return a < b ? a : b;
86     }
87 }
88 
89 // File: contracts/library/Pausable.sol
90 
91 pragma solidity ^0.4.24;
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is not paused.
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is paused.
115    */
116   modifier whenPaused() {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() onlyOwner whenNotPaused public {
125     paused = true;
126     emit Pause();
127   }
128 
129   /**
130    * @dev called by the owner to unpause, returns to normal state
131    */
132   function unpause() onlyOwner whenPaused public {
133     paused = false;
134     emit Unpause();
135   }
136 }
137 
138 // File: contracts/library/Whitelist.sol
139 
140 pragma solidity ^0.4.24;
141 
142 
143 
144 /**
145  * @title Whitelist
146  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
147  * @dev This simplifies the implementation of "user permissions".
148  */
149 contract Whitelist is Ownable {
150   mapping(address => bool) public whitelist;
151 
152   event WhitelistedAddressAdded(address addr);
153   event WhitelistedAddressRemoved(address addr);
154 
155   /**
156    * @dev Throws if called by any account that's not whitelisted.
157    */
158   modifier onlyWhitelisted() {
159     require(whitelist[msg.sender]);
160     _;
161   }
162 
163   /**
164    * @dev add an address to the whitelist
165    * @param addr address
166    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
167    */
168   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
169     if (!whitelist[addr]) {
170       whitelist[addr] = true;
171       emit WhitelistedAddressAdded(addr);
172       success = true;
173     }
174   }
175 
176   /**
177    * @dev add addresses to the whitelist
178    * @param addrs addresses
179    * @return true if at least one address was added to the whitelist,
180    * false if all addresses were already in the whitelist
181    */
182   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
183     for (uint256 i = 0; i < addrs.length; i++) {
184       if (addAddressToWhitelist(addrs[i])) {
185         success = true;
186       }
187     }
188   }
189 
190   /**
191    * @dev remove an address from the whitelist
192    * @param addr address
193    * @return true if the address was removed from the whitelist,
194    * false if the address wasn't in the whitelist in the first place
195    */
196   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
197     if (whitelist[addr]) {
198       whitelist[addr] = false;
199       emit WhitelistedAddressRemoved(addr);
200       success = true;
201     }
202   }
203 
204   /**
205    * @dev remove addresses from the whitelist
206    * @param addrs addresses
207    * @return true if at least one address was removed from the whitelist,
208    * false if all addresses weren't in the whitelist in the first place
209    */
210   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
211     for (uint256 i = 0; i < addrs.length; i++) {
212       if (removeAddressFromWhitelist(addrs[i])) {
213         success = true;
214       }
215     }
216   }
217 
218 }
219 
220 // File: contracts/Staking.sol
221 
222 pragma solidity ^0.4.24;
223 
224 
225 
226 
227 
228 
229 /**
230  * @title Staking and voting contract.
231  * @author IoTeX Team
232  *
233  */
234 contract Staking is Pausable, Whitelist {
235     using SafeMath for uint256;
236 
237     // Events to be emitted
238     event BucketCreated(uint256 bucketIndex, bytes12 canName, uint256 amount, uint256 stakeDuration, bool nonDecay, bytes data);
239     event BucketUpdated(uint256 bucketIndex, bytes12 canName, uint256 stakeDuration, uint256 stakeStartTime, bool nonDecay, address bucketOwner, bytes data);
240     event BucketUnstake(uint256 bucketIndex, bytes12 canName, uint256 amount, bytes data);
241     event BucketWithdraw(uint256 bucketIndex, bytes12 canName, uint256 amount, bytes data);
242     // TODO add change owner event which is not covered by BucketUpdated event
243 
244     // IOTX used for staking
245     ERC20 stakingToken;
246 
247     // Unit is epoch
248     uint256 public constant minStakeDuration = 0;
249     uint256 public constant maxStakeDuration = 350;
250     uint256 public constant minStakeAmount = 100 * 10 ** 18;
251     uint256 public constant unStakeDuration = 3;
252 
253     uint256 public constant maxBucketsPerAddr = 500;
254     uint256 public constant secondsPerEpoch = 86400;
255 
256     // Core data structure to track staking/voting status
257     struct Bucket {
258         bytes12 canName;            // Candidate name, which maps to public keys by NameRegistration.sol
259         uint256 stakedAmount;       // Number of tokens
260         uint256 stakeDuration;      // Stake duration, unit: second since epoch
261         uint256 stakeStartTime;     // Staking start time, unit: second since epoch
262         bool nonDecay;              // Nondecay staking -- staking for N epochs consistently without decaying
263         uint256 unstakeStartTime;   // unstake timestamp, unit: second since epoch
264         address bucketOwner;        // Owner of this bucket, usually the one who created it but can be someone else
265         uint256 createTime;         // bucket firstly create time
266         uint256 prev;               // Prev non-zero bucket index
267         uint256 next;               // Next non-zero bucket index
268     }
269     mapping(uint256 => Bucket) public buckets;
270     uint256 bucketCount; // number of total buckets. used to track the last used index for the bucket
271 
272     // Map from owner address to array of bucket indexes.
273     mapping(address => uint256[]) public stakeholders;
274 
275     /**
276      * @dev Modifier that checks that this given bucket can be updated/deleted by msg.sender
277      * @param _address address to transfer tokens from
278      * @param _bucketIndex uint256 the index of the bucket
279      */
280     modifier canTouchBucket(address _address, uint256 _bucketIndex) {
281         require(_address != address(0));
282         require(buckets[_bucketIndex].bucketOwner == msg.sender, "sender is not the owner.");
283         _;
284     }
285 
286     /**
287      * @dev Modifier that check if a duration meets requirement
288      * @param _duration uint256 duration to check
289      */
290     modifier checkStakeDuration(uint256 _duration) {
291         require(_duration >= minStakeDuration && _duration <= maxStakeDuration, "The stake duration is too small or large");
292         require(_duration % 7 == 0, "The stake duration should be multiple of 7");
293         _;
294     }
295 
296     /**
297      * @dev Constructor function
298      * @param _stakingTokenAddr address The address of the token contract used for staking
299      */
300     constructor(address _stakingTokenAddr) public {
301         stakingToken = ERC20(_stakingTokenAddr);
302         // create one bucket to initialize the double linked list
303         buckets[0] = Bucket("", 1, 0, block.timestamp, true, 0, msg.sender, block.timestamp, 0, 0);
304         stakeholders[msg.sender].push(0);
305         bucketCount = 1;
306     }
307 
308     function getActiveBucketIdxImpl(uint256 _prevIndex, uint256 _limit) internal returns(uint256 count, uint256[] indexes) {
309         require (_limit > 0 && _limit < 5000);
310         Bucket memory bucket = buckets[_prevIndex];
311         require(bucket.next > 0, "cannot find bucket based on input index.");
312 
313         indexes = new uint256[](_limit);
314         uint256 i = 0;
315         for (i = 0; i < _limit; i++) {
316             while (bucket.next > 0 && buckets[bucket.next].unstakeStartTime > 0) { // unstaked.
317                 bucket = buckets[bucket.next]; // skip
318             }
319             if (bucket.next == 0) { // no new bucket
320                 break;
321             }
322             indexes[i] = bucket.next;
323             bucket = buckets[bucket.next];
324         }
325         return (i, indexes);
326     }
327 
328     function getActiveBucketIdx(uint256 _prevIndex, uint256 _limit) external view returns(uint256 count, uint256[] indexes) {
329         return getActiveBucketIdxImpl(_prevIndex, _limit);
330     }
331 
332     /**
333      * @dev Get active buckets for a range of indexes
334      * @param _prevIndex uint256 the starting index. starting from 0, ending at the last. (putting 0,2 will return 1,2.)
335      * @param _limit uint256 the number of non zero buckets to fetch after the start index
336      * @return (uint256, uint256[], uint256[], uint256[], uint256[], bytes, address[])
337      *  count, index array, stakeStartTime array, duration array, decay array, stakedAmount array, concat stakedFor, ownerAddress array
338      */
339     function getActiveBuckets(uint256 _prevIndex, uint256 _limit) external view returns(uint256 count,
340             uint256[] indexes, uint256[] stakeStartTimes, uint256[] stakeDurations, bool[] decays, uint256[] stakedAmounts, bytes12[] canNames, address[] owners) {
341 
342         (count, indexes) = getActiveBucketIdxImpl(_prevIndex, _limit);
343         stakeStartTimes = new uint256[](count);
344         stakeDurations = new uint256[](count);
345         decays = new bool[](count);
346         stakedAmounts = new uint256[](count);
347         canNames = new bytes12[](count);
348         owners = new address[](count);
349 
350         for (uint256 i = 0; i < count; i++) {
351             Bucket memory bucket = buckets[indexes[i]];
352             stakeStartTimes[i] = bucket.stakeStartTime;
353             stakeDurations[i] = bucket.stakeDuration;
354             decays[i] = !bucket.nonDecay;
355             stakedAmounts[i] = bucket.stakedAmount;
356             canNames[i] = bucket.canName;
357             owners[i] = bucket.bucketOwner;
358 
359         }
360 
361         return (count, indexes, stakeStartTimes, stakeDurations, decays, stakedAmounts, canNames, owners);
362     }
363 
364 
365     function getActiveBucketCreateTimes(uint256 _prevIndex, uint256 _limit) external view returns(uint256 count,
366             uint256[] indexes, uint256[] createTimes) {
367         (count, indexes) = getActiveBucketIdxImpl(_prevIndex, _limit);
368         createTimes = new uint256[](count);
369         for (uint256 i = 0; i < count; i++) {
370             createTimes[i] = buckets[indexes[i]].createTime;
371         }
372         return (count, indexes, createTimes);
373     }
374 
375     /**
376      * @dev Get bucket indexes from a given address
377      * @param _owner address onwer of the buckets
378      * @return (uint256[])
379      */
380     function getBucketIndexesByAddress(address _owner) external view returns(uint256[]) {
381         return stakeholders[_owner];
382     }
383 
384     /**
385      * @notice Extend the stake to stakeDuration from current time and/or set nonDecay.
386      * @notice MUST trigger BucketUpdated event
387      * @param _bucketIndex uint256 the index of the bucket
388      * @param _stakeDuration uint256 the desired duration of staking.
389      * @param _nonDecay bool if auto restake
390      * @param _data bytes optional data to include in the emitted event
391      */
392     function restake(uint256 _bucketIndex, uint256 _stakeDuration, bool _nonDecay, bytes _data)
393             external whenNotPaused canTouchBucket(msg.sender, _bucketIndex) checkStakeDuration(_stakeDuration) {
394         require(block.timestamp.add(_stakeDuration * secondsPerEpoch) >=
395                 buckets[_bucketIndex].stakeStartTime.add(buckets[_bucketIndex].stakeDuration * secondsPerEpoch),
396                 "current stake duration not finished.");
397         if (buckets[_bucketIndex].nonDecay) {
398           require(_stakeDuration >= buckets[_bucketIndex].stakeDuration, "cannot reduce the stake duration.");
399         }
400         buckets[_bucketIndex].stakeDuration = _stakeDuration;
401         buckets[_bucketIndex].stakeStartTime = block.timestamp;
402         buckets[_bucketIndex].nonDecay = _nonDecay;
403         buckets[_bucketIndex].unstakeStartTime = 0;
404         emitBucketUpdated(_bucketIndex, _data);
405     }
406 
407     /*
408      * @notice Vote for another candidate with the tokens that are already staked in the given bucket
409      * @notice MUST trigger BucketUpdated event
410      * @param _bucketIndex uint256 the index of the bucket
411      * @param canName bytes the IoTeX address of the candidate the tokens are staked for
412      * @param _data bytes optional data to include in the emitted event
413      */
414     function revote(uint256 _bucketIndex, bytes12 _canName, bytes _data)
415             external whenNotPaused canTouchBucket(msg.sender, _bucketIndex) {
416         require(buckets[_bucketIndex].unstakeStartTime == 0, "cannot revote during unstaking.");
417         buckets[_bucketIndex].canName = _canName;
418         emitBucketUpdated(_bucketIndex, _data);
419     }
420 
421     /*
422      * @notice Set the new owner of a given bucket, the sender must be whitelisted to do so to avoid spam
423      * @notice MUST trigger BucketUpdated event
424      * @param _name bytes12 the name of the candidate the tokens are staked for
425      * @param _bucketIndex uint256 optional data to include in the Stake event
426      * @param _data bytes optional data to include in the emitted event
427      */
428     function setBucketOwner(uint256 _bucketIndex, address _newOwner, bytes _data)
429             external whenNotPaused onlyWhitelisted canTouchBucket(msg.sender, _bucketIndex) {
430         removeBucketIndex(_bucketIndex);
431         buckets[_bucketIndex].bucketOwner = _newOwner;
432         stakeholders[_newOwner].push(_bucketIndex);
433         // TODO split event.
434         emitBucketUpdated(_bucketIndex, _data);
435     }
436 
437     /**
438      * @notice Unstake a certain amount of tokens from a given bucket.
439      * @notice MUST trigger BucketUnstake event
440      * @param _bucketIndex uint256 the index of the bucket
441      * @param _data bytes optional data to include in the emitted event
442      */
443     function unstake(uint256 _bucketIndex, bytes _data)
444             external whenNotPaused canTouchBucket(msg.sender, _bucketIndex) {
445         require(_bucketIndex > 0, "bucket 0 cannot be unstaked and withdrawn.");
446         require(!buckets[_bucketIndex].nonDecay, "Cannot unstake with nonDecay flag. Need to disable non-decay mode first.");
447         require(buckets[_bucketIndex].stakeStartTime.add(buckets[_bucketIndex].stakeDuration * secondsPerEpoch) <= block.timestamp,
448             "Staking time does not expire yet. Please wait until staking expires.");
449         require(buckets[_bucketIndex].unstakeStartTime == 0, "Unstaked already. No need to unstake again.");
450         buckets[_bucketIndex].unstakeStartTime = block.timestamp;
451         emit BucketUnstake(_bucketIndex, buckets[_bucketIndex].canName, buckets[_bucketIndex].stakedAmount, _data);
452     }
453 
454     /**
455      * @notice this SHOULD return the given amount of tokens to the user, if unstaking is currently not possible the function MUST revert
456      * @notice MUST trigger BucketWithdraw event
457      * @param _bucketIndex uint256 the index of the bucket
458      * @param _data bytes optional data to include in the emitted event
459      */
460     function withdraw(uint256 _bucketIndex, bytes _data)
461             external whenNotPaused canTouchBucket(msg.sender, _bucketIndex) {
462         require(buckets[_bucketIndex].unstakeStartTime > 0, "Please unstake first before withdraw.");
463         require(
464             buckets[_bucketIndex].unstakeStartTime.add(unStakeDuration * secondsPerEpoch) <= block.timestamp,
465             "Stakeholder needs to wait for 3 days before withdrawing tokens.");
466 
467         // fix double linked list
468         uint256 prev = buckets[_bucketIndex].prev;
469         uint256 next = buckets[_bucketIndex].next;
470         buckets[prev].next = next;
471         buckets[next].prev = prev;
472 
473         uint256 amount = buckets[_bucketIndex].stakedAmount;
474         bytes12 canName = buckets[_bucketIndex].canName;
475         address bucketowner = buckets[_bucketIndex].bucketOwner;
476         buckets[_bucketIndex].stakedAmount = 0;
477         removeBucketIndex(_bucketIndex);
478         delete buckets[_bucketIndex];
479 
480         require(stakingToken.transfer(bucketowner, amount), "Unable to withdraw stake");
481         emit BucketWithdraw(_bucketIndex, canName, amount, _data);
482     }
483 
484     /**
485      * @notice Returns the total of tokens staked from all addresses
486      * @return uint256 The number of tokens staked from all addresses
487      */
488     function totalStaked() public view returns (uint256) {
489         return stakingToken.balanceOf(this);
490     }
491 
492     /**
493      * @notice Address of the token being used by the staking interface
494      * @return address The address of the ERC20 token used for staking
495      */
496     function token() public view returns(address) {
497         return stakingToken;
498     }
499 
500     /**
501      * @notice Emit BucketUpdated event
502      */
503     function emitBucketUpdated(uint256 _bucketIndex, bytes _data) internal {
504         Bucket memory b = buckets[_bucketIndex];
505         emit BucketUpdated(_bucketIndex, b.canName, b.stakeDuration, b.stakeStartTime, b.nonDecay, b.bucketOwner, _data);
506     }
507 
508     /**
509      * @dev  Create a bucket and vote for a given canName.
510      * @param _canName bytes The IoTeX address of the candidate the stake is being created for
511      * @param _amount uint256 The duration to lock the tokens for
512      * @param _stakeDuration bytes the desired duration of the staking
513      * @param _nonDecay bool if auto restake
514      * @param _data bytes optional data to include in the emitted event
515      * @return uint236 the index of new bucket
516      */
517     function createBucket(bytes12 _canName, uint256 _amount, uint256 _stakeDuration, bool _nonDecay, bytes _data)
518             external whenNotPaused checkStakeDuration(_stakeDuration) returns (uint256) {
519         require(_amount >= minStakeAmount, "amount should >= 100.");
520         require(stakeholders[msg.sender].length <= maxBucketsPerAddr, "One address can have up limited buckets");
521         require(stakingToken.transferFrom(msg.sender, this, _amount), "Stake required"); // transfer token to contract
522         // add a new bucket to the end of buckets array and fix the double linked list.
523         buckets[bucketCount] = Bucket(_canName, _amount, _stakeDuration, block.timestamp, _nonDecay, 0, msg.sender, block.timestamp, buckets[0].prev, 0);
524         buckets[buckets[0].prev].next = bucketCount;
525         buckets[0].prev = bucketCount;
526         stakeholders[msg.sender].push(bucketCount);
527         bucketCount++;
528         emit BucketCreated(bucketCount-1, _canName, _amount, _stakeDuration, _nonDecay, _data);
529         return bucketCount-1;
530     }
531 
532     /**
533      * @dev Remove the bucket index from stakeholders map
534      * @param _bucketidx uint256 the bucket index
535      */
536     function removeBucketIndex(uint256 _bucketidx) internal {
537         address owner = buckets[_bucketidx].bucketOwner;
538         require(stakeholders[owner].length > 0, "Expect the owner has at least one bucket index");
539 
540         uint256 i = 0;
541         for (; i < stakeholders[owner].length; i++) {
542           if(stakeholders[owner][i] == _bucketidx) {
543                 break;
544           }
545         }
546         for (; i < stakeholders[owner].length - 1; i++) {
547           stakeholders[owner][i] = stakeholders[owner][i + 1];
548         }
549         stakeholders[owner].length--;
550     }
551 }