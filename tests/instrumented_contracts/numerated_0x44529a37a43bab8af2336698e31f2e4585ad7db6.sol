1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 interface IERC20 {
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7 }
8 
9 library Address {
10     function isContract(address account) internal view returns (bool) {
11         bytes32 codehash;
12         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
13         // solhint-disable-next-line no-inline-assembly
14         assembly { codehash := extcodehash(account) }
15         return (codehash != 0x0 && codehash != accountHash);
16     }
17 }
18 
19 library SafeERC20 {
20     using Address for address;
21 
22     function safeTransfer(IERC20 token, address to, uint value) internal {
23         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
24     }
25 
26     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
27         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
28     }
29 
30     function callOptionalReturn(IERC20 token, bytes memory data) private {
31         require(address(token).isContract(), "SafeERC20: call to non-contract");
32 
33         // solhint-disable-next-line avoid-low-level-calls
34         (bool success, bytes memory returndata) = address(token).call(data);
35         require(success, "SafeERC20: low-level call failed");
36 
37         if (returndata.length > 0) { // Return data is optional
38             // solhint-disable-next-line max-line-length
39             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
40         }
41     }
42 }
43 
44 interface ve {
45     function balanceOfAtNFT(uint _tokenId, uint _block) external view returns (uint);
46     function balanceOfNFTAt(uint _tokenId, uint _t) external view returns (uint);
47     function totalSupplyAt(uint _block) external view returns (uint);
48     function totalSupplyAtT(uint t) external view returns (uint);
49     function ownerOf(uint) external view returns (address);
50     function create_lock(uint _value, uint _lock_duration) external returns (uint);
51 }
52 
53 contract Reward {
54     using SafeERC20 for IERC20;
55 
56     struct EpochInfo {
57         uint startTime;
58         uint endTime;
59         uint rewardPerSecond; // totalReward * RewardMultiplier / (endBlock - startBlock)
60         uint totalPower;
61         uint startBlock;
62     }
63 
64     /// @dev Ve nft
65     address public immutable _ve;
66     /// @dev reward erc20 token, USDT
67     address public immutable rewardToken;
68     /// @dev RewardMultiplier
69     uint immutable RewardMultiplier = 10000000;
70     /// @dev BlockMultiplier
71     uint immutable BlockMultiplier = 1000000000000000000;
72 
73     /// @dev reward epochs.
74     EpochInfo[] public epochInfo;
75 
76     /// @dev user's last claim time.
77     mapping(uint => mapping(uint => uint)) public userLastClaimTime; // tokenId -> epoch id -> last claim timestamp\
78 
79     address public admin;
80     address public pendingAdmin;
81 
82     modifier onlyAdmin() {
83         require(msg.sender == admin);
84         _;
85     }
86 
87     event LogClaimReward(uint tokenId, uint reward);
88     event LogAddEpoch(uint epochId, EpochInfo epochInfo);
89     event LogAddEpoch(uint startTime, uint epochLength, uint epochCount, uint startEpochId);
90     event LogTransferAdmin(address pendingAdmin);
91     event LogAcceptAdmin(address admin);
92 
93     constructor (
94         address _ve_,
95         address rewardToken_
96     ) {
97         admin = msg.sender;
98         _ve = _ve_;
99         rewardToken = rewardToken_;
100         // add init point
101         addCheckpoint();
102     }
103     
104     struct Point {
105         uint256 ts;
106         uint256 blk; // block
107     }
108 
109     /// @dev list of checkpoints, used in getBlockByTime
110     Point[] public point_history;
111    
112     /// @notice add checkpoint to point_history
113     /// called in constructor, addEpoch, addEpochBatch and claimReward
114     /// point_history increments without repetition, length always >= 1
115     function addCheckpoint() internal {
116         point_history.push(Point(block.timestamp, block.number));
117     }
118     
119     /// @notice estimate last block number before given time
120     /// @return blockNumber
121     function getBlockByTime(uint _time) public view returns (uint) {
122         // Binary search
123         uint _min = 0;
124         uint _max = point_history.length - 1; // asserting length >= 2
125         for (uint i = 0; i < 128; ++i) {
126             // Will be always enough for 128-bit numbers
127             if (_min >= _max) {
128                 break;
129             }
130             uint _mid = (_min + _max + 1) / 2;
131             if (point_history[_mid].ts <= _time) {
132                 _min = _mid;
133             } else {
134                 _max = _mid - 1;
135             }
136         }
137 
138         Point memory point0 = point_history[_min];
139         Point memory point1 = point_history[_min + 1];
140         if (_time == point0.ts) {
141             return point0.blk;
142         }
143         // asserting point0.blk < point1.blk, point0.ts < point1.ts
144         uint block_slope; // dblock/dt
145         block_slope = (BlockMultiplier * (point1.blk - point0.blk)) / (point1.ts - point0.ts);
146         uint dblock = (block_slope * (_time - point0.ts)) / BlockMultiplier;
147         return point0.blk + dblock;
148     }
149 
150     function withdrawFee(uint amount) external onlyAdmin {
151         IERC20(rewardToken).safeTransfer(admin, amount);
152     }
153 
154     function transferAdmin(address _admin) external onlyAdmin {
155         pendingAdmin = _admin;
156         emit LogTransferAdmin(pendingAdmin);
157     }
158 
159     function acceptAdmin() external {
160         require(msg.sender == pendingAdmin);
161         admin = pendingAdmin;
162         pendingAdmin = address(0);
163         emit LogAcceptAdmin(admin);
164     }
165 
166     /// @notice add one epoch
167     /// @return epochId
168     /// @return accurateTotalReward
169     function addEpoch(uint startTime, uint endTime, uint totalReward) external onlyAdmin returns(uint, uint) {
170         assert(block.timestamp < endTime && startTime < endTime);
171         if (epochInfo.length > 0) {
172             require(epochInfo[epochInfo.length - 1].endTime <= startTime);
173         }
174         (uint epochId, uint accurateTotalReward) = _addEpoch(startTime, endTime, totalReward);
175         uint lastPointTime = point_history[point_history.length - 1].ts;
176         if (lastPointTime < block.timestamp) {
177             addCheckpoint();
178         }
179         emit LogAddEpoch(epochId, epochInfo[epochId]);
180         return (epochId, accurateTotalReward);
181     }
182 
183     /// @notice add a batch of continuous epochs
184     /// @return firstEpochId
185     /// @return lastEpochId
186     /// @return accurateTotalReward
187     function addEpochBatch(uint startTime, uint epochLength, uint epochCount, uint totalReward) external onlyAdmin returns(uint, uint, uint) {
188         require(block.timestamp < startTime + epochLength);
189         if (epochInfo.length > 0) {
190             require(epochInfo[epochInfo.length - 1].endTime <= startTime);
191         }
192         uint _reward = totalReward / epochCount;
193         uint _epochId;
194         uint accurateTR;
195         uint _start = startTime;
196         uint _end = _start + epochLength;
197         for (uint i = 0; i < epochCount; i++) {
198             (_epochId, accurateTR) = _addEpoch(_start, _end, _reward);
199             _start = _end;
200             _end = _start + epochLength;
201         }
202         uint lastPointTime = point_history[point_history.length - 1].ts;
203         if (lastPointTime < block.timestamp) {
204             addCheckpoint();
205         }
206         emit LogAddEpoch(startTime, epochLength, epochCount, _epochId + 1 - epochCount);
207         return (_epochId + 1 - epochCount, _epochId, accurateTR * epochCount);
208     }
209 
210     /// @notice add one epoch
211     /// @return epochId
212     /// @return accurateTotalReward
213     function _addEpoch(uint startTime, uint endTime, uint totalReward) internal returns(uint, uint) {
214         uint rewardPerSecond = totalReward * RewardMultiplier / (endTime - startTime);
215         uint epochId = epochInfo.length;
216         epochInfo.push(EpochInfo(startTime, endTime, rewardPerSecond, 1, 1));
217         uint accurateTotalReward = (endTime - startTime) * rewardPerSecond / RewardMultiplier;
218         return (epochId, accurateTotalReward);
219     }
220 
221     /// @notice set epoch reward
222     function updateEpochReward(uint epochId, uint totalReward) external onlyAdmin {
223         require(block.timestamp < epochInfo[epochId].startTime);
224         epochInfo[epochId].rewardPerSecond = totalReward * RewardMultiplier / (epochInfo[epochId].endTime - epochInfo[epochId].startTime);
225     }
226 
227     /// @notice query pending reward by epoch
228     /// @return pendingReward
229     /// @return finished
230     /// panic when block.timestamp < epoch.startTime
231     function _pendingRewardSingle(uint tokenId, uint lastClaimTime, EpochInfo memory epoch) internal view returns (uint, bool) {
232         uint last = lastClaimTime >= epoch.startTime ? lastClaimTime : epoch.startTime;
233         if (last >= epoch.endTime) {
234             return (0, true);
235         }
236         if (epoch.totalPower == 0) {
237             return (0, true);
238         }
239         
240         uint end = block.timestamp;
241         bool finished = false;
242         if (end > epoch.endTime) {
243             end = epoch.endTime;
244             finished = true;
245         }
246 
247         uint power = ve(_ve).balanceOfAtNFT(tokenId, epoch.startBlock);
248         
249         uint reward = epoch.rewardPerSecond * (end - last) * power / (epoch.totalPower * RewardMultiplier);
250         return (reward, finished);
251     }
252 
253     function checkpointAndCheckEpoch(uint epochId) public {
254         uint lastPointTime = point_history[point_history.length - 1].ts;
255         if (lastPointTime < block.timestamp) {
256             addCheckpoint();
257         }
258         checkEpoch(epochId);
259     }
260 
261     function checkEpoch(uint epochId) internal {
262         if (epochInfo[epochId].startBlock == 1) {
263             epochInfo[epochId].startBlock = getBlockByTime(epochInfo[epochId].startTime);
264         }
265         if (epochInfo[epochId].totalPower == 1) {
266             epochInfo[epochId].totalPower = ve(_ve).totalSupplyAt(epochInfo[epochId].startBlock);
267         }
268     }
269 
270     struct Interval {
271         uint startEpoch;
272         uint endEpoch;
273     }
274 
275     struct IntervalReward {
276         uint startEpoch;
277         uint endEpoch;
278         uint reward;
279     }
280 
281     function claimRewardMany(uint[] calldata tokenIds, Interval[][] calldata intervals) public returns (uint[] memory rewards) {
282         require(tokenIds.length == intervals.length, "length not equal");
283         rewards = new uint[] (tokenIds.length);
284         for (uint i = 0; i < tokenIds.length; i++) {
285             rewards[i] = claimReward(tokenIds[i], intervals[i]);
286         }
287         return rewards;
288     }
289 
290     function claimReward(uint tokenId, Interval[] calldata intervals) public returns (uint reward) {
291         for (uint i = 0; i < intervals.length; i++) {
292             reward += claimReward(tokenId, intervals[i].startEpoch, intervals[i].endEpoch);
293         }
294         return reward;
295     }
296 
297     /// @notice claim reward in range
298     function claimReward(uint tokenId, uint startEpoch, uint endEpoch) public returns (uint reward) {
299         require(msg.sender == ve(_ve).ownerOf(tokenId));
300         require(endEpoch < epochInfo.length, "claim out of range");
301         EpochInfo memory epoch;
302         uint lastPointTime = point_history[point_history.length - 1].ts;
303         for (uint i = startEpoch; i <= endEpoch; i++) {
304             epoch = epochInfo[i];
305             if (block.timestamp < epoch.startTime) {
306                 break;
307             }
308             if (lastPointTime < epoch.startTime) {
309                 // this branch runs 0 or 1 time
310                 lastPointTime = block.timestamp;
311                 addCheckpoint();
312             }
313             checkEpoch(i);
314             (uint reward_i, bool finished) = _pendingRewardSingle(tokenId, userLastClaimTime[tokenId][i], epochInfo[i]);
315             if (reward_i > 0) {
316                 reward += reward_i;
317                 userLastClaimTime[tokenId][i] = block.timestamp;
318             }
319             if (!finished) {
320                 break;
321             }
322         }
323         IERC20(rewardToken).safeTransfer(ve(_ve).ownerOf(tokenId), reward);
324         emit LogClaimReward(tokenId, reward);
325         return reward;
326     }
327 
328     /// @notice get epoch by time
329     function getEpochIdByTime(uint _time) view public returns (uint) {
330         assert(epochInfo[0].startTime <= _time);
331         if (_time > epochInfo[epochInfo.length - 1].startTime) {
332             return epochInfo.length - 1;
333         }
334         // Binary search
335         uint _min = 0;
336         uint _max = epochInfo.length - 1; // asserting length >= 2
337         for (uint i = 0; i < 128; ++i) {
338             // Will be always enough for 128-bit numbers
339             if (_min >= _max) {
340                 break;
341             }
342             uint _mid = (_min + _max + 1) / 2;
343             if (epochInfo[_mid].startTime <= _time) {
344                 _min = _mid;
345             } else {
346                 _max = _mid - 1;
347             }
348         }
349         return _min;
350     }
351 
352     /**
353     External read functions
354      */
355     struct RewardInfo {
356         uint epochId;
357         uint reward;
358     }
359 
360     uint constant MaxQueryLength = 50;
361 
362     /// @notice get epoch info
363     /// @return startTime
364     /// @return endTime
365     /// @return totalReward
366     function getEpochInfo(uint epochId) public view returns (uint, uint, uint) {
367         if (epochId >= epochInfo.length) {
368             return (0,0,0);
369         }
370         EpochInfo memory epoch = epochInfo[epochId];
371         uint totalReward = (epoch.endTime - epoch.startTime) * epoch.rewardPerSecond / RewardMultiplier;
372         return (epoch.startTime, epoch.endTime, totalReward);
373     }
374 
375     function getCurrentEpochId() public view returns (uint) {
376         uint currentEpochId = getEpochIdByTime(block.timestamp);
377         return currentEpochId;
378     }
379 
380     /// @notice only for external view functions
381     /// Time beyond last checkpoint resulting in inconsistent estimated block number.
382     function getBlockByTimeWithoutLastCheckpoint(uint _time) public view returns (uint) {
383         if (point_history[point_history.length - 1].ts >= _time) {
384             return getBlockByTime(_time);
385         }
386         Point memory point0 = point_history[point_history.length - 1];
387         if (_time == point0.ts) {
388             return point0.blk;
389         }
390         uint block_slope;
391         block_slope = (BlockMultiplier * (block.number - point0.blk)) / (block.timestamp - point0.ts);
392         uint dblock = (block_slope * (_time - point0.ts)) / BlockMultiplier;
393         return point0.blk + dblock;
394     }
395 
396     function getEpochStartBlock(uint epochId) public view returns (uint) {
397         if (epochInfo[epochId].startBlock == 1) {
398             return getBlockByTimeWithoutLastCheckpoint(epochInfo[epochId].startTime);
399         }
400         return epochInfo[epochId].startBlock;
401     }
402 
403     function getEpochTotalPower(uint epochId) public view returns (uint) {
404         if (epochInfo[epochId].totalPower == 1) {
405             uint blk = getEpochStartBlock(epochId);
406             if (blk > block.number) {
407                 return ve(_ve).totalSupplyAtT(epochInfo[epochId].startTime);
408             }
409             return ve(_ve).totalSupplyAt(blk);
410         }
411         return epochInfo[epochId].totalPower;
412     }
413 
414     /// @notice get user's power at epochId
415     function getUserPower(uint tokenId, uint epochId) view public returns (uint) {
416         EpochInfo memory epoch = epochInfo[epochId];
417         uint blk = getBlockByTimeWithoutLastCheckpoint(epoch.startTime);
418         if (blk < block.number) {
419             return ve(_ve).balanceOfAtNFT(tokenId, blk);
420         }
421         return ve(_ve).balanceOfNFTAt(tokenId, epochInfo[epochId].startTime);
422     }
423 
424     /// @notice
425     /// Current epoch reward is inaccurate
426     /// because the checkpoint may not have been added.
427     function getPendingRewardSingle(uint tokenId, uint epochId) public view returns (uint reward, bool finished) {
428         if (epochId > getCurrentEpochId()) {
429             return (0, false);
430         }
431         EpochInfo memory epoch = epochInfo[epochId];
432         uint startBlock = getEpochStartBlock(epochId);
433         uint totalPower = getEpochTotalPower(epochId);
434         if (totalPower == 0) {
435             return (0, true);
436         }
437         uint power = ve(_ve).balanceOfAtNFT(tokenId, startBlock);
438 
439         uint last = userLastClaimTime[tokenId][epochId];
440         last = last >= epoch.startTime ? last : epoch.startTime;
441         if (last >= epoch.endTime) {
442             return (0, true);
443         }
444         
445         uint end = block.timestamp;
446         finished = false;
447         if (end > epoch.endTime) {
448             end = epoch.endTime;
449             finished = true;
450         }
451         
452         reward = epoch.rewardPerSecond * (end - last) * power / (totalPower * RewardMultiplier);
453         return (reward, finished);
454     }
455 
456     /// @notice get claimable reward
457     function pendingReward(uint tokenId, uint start, uint end) public view returns (IntervalReward[] memory intervalRewards) {
458         uint current = getCurrentEpochId();
459         require(start <= end);
460         if (end > current) {
461             end = current;
462         }
463         RewardInfo[] memory rewards = new RewardInfo[](end - start + 1);
464         for (uint i = start; i <= end; i++) {
465             if (block.timestamp < epochInfo[i].startTime) {
466                 break;
467             }
468             (uint reward_i,) = getPendingRewardSingle(tokenId, i);
469             rewards[i-start] = RewardInfo(i, reward_i);
470         }
471 
472         // omit zero rewards and convert epoch list to intervals
473         IntervalReward[] memory intervalRewards_0 = new IntervalReward[] (rewards.length);
474         uint intv = 0;
475         uint intvCursor = 0;
476         uint sum = 0;
477         for (uint i = 0; i < rewards.length; i++) {
478             if (rewards[i].reward == 0) {
479                 if (i != intvCursor) {
480                     intervalRewards_0[intv] = IntervalReward(rewards[intvCursor].epochId, rewards[i-1].epochId, sum);
481                     intv++;
482                     sum = 0;
483                 }
484                 intvCursor = i + 1;
485                 continue;
486             }
487             sum += rewards[i].reward;
488         }
489         if (sum > 0) {
490             intervalRewards_0[intv] = IntervalReward(rewards[intvCursor].epochId, rewards[rewards.length-1].epochId, sum);
491             intervalRewards = new IntervalReward[] (intv+1);
492             // Copy interval array
493             for (uint i = 0; i < intv+1; i++) {
494                 intervalRewards[i] = intervalRewards_0[i];
495             }
496         } else {
497             intervalRewards = new IntervalReward[] (intv);
498             // Copy interval array
499             for (uint i = 0; i < intv; i++) {
500                 intervalRewards[i] = intervalRewards_0[i];
501             }
502         }
503         
504         return intervalRewards;
505     }
506 }