1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File srcBuild/Gauge.sol
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.11;
7 
8 library Math {
9     function max(uint a, uint b) internal pure returns (uint) {
10         return a >= b ? a : b;
11     }
12     function min(uint a, uint b) internal pure returns (uint) {
13         return a < b ? a : b;
14     }
15 }
16 
17 interface erc20 {
18     function totalSupply() external view returns (uint256);
19     function transfer(address recipient, uint amount) external returns (bool);
20     function balanceOf(address) external view returns (uint);
21     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
22     function approve(address spender, uint value) external returns (bool);
23 }
24 
25 interface ve {
26     function token() external view returns (address);
27     function balanceOfNFT(uint) external view returns (uint);
28     function isApprovedOrOwner(address, uint) external view returns (bool);
29     function isUnlocked() external view returns (bool);
30     function locked__end(uint) external view returns (uint);
31     function create_lock_for(uint, uint, address) external returns (uint);
32     function deposit_for(uint, uint) external;
33     function ownerOf(uint) external view returns (address);
34     function transferFrom(address, address, uint) external;
35 }
36 
37 interface IBribe {
38     function notifyRewardAmount(address token, uint amount) external;
39     function left(address token) external view returns (uint);
40 }
41 
42 interface Voter {
43     function attachTokenToGauge(uint _tokenId, address account) external;
44     function detachTokenFromGauge(uint _tokenId, address account) external;
45     function emitDeposit(uint _tokenId, address account, uint amount) external;
46     function emitWithdraw(uint _tokenId, address account, uint amount) external;
47     function distribute(address _gauge) external;
48 }
49 
50 // Gauges are used to incentivize pools, they emit reward tokens over 7 days for staked LP tokens
51 contract Gauge {
52 
53     address public immutable stake; // the asset token that needs to be staked for rewards
54     address public immutable _ve; // the ve token used for gauges
55     address public immutable bribe;
56     address public immutable voter;
57 
58     bool internal depositsOpen;
59     uint public derivedSupply;
60     mapping(address => uint) public derivedBalances;
61 
62     uint internal constant DURATION = 7 days; // rewards are released over 7 days
63     uint internal constant PRECISION = 10 ** 18;
64 
65     // default snx staking contract implementation
66     mapping(address => uint) public rewardRate;
67     mapping(address => uint) public periodFinish;
68     mapping(address => uint) public lastUpdateTime;
69     mapping(address => uint) public rewardPerTokenStored;
70 
71     mapping(address => mapping(address => uint)) public lastEarn;
72     mapping(address => mapping(address => uint)) public userRewardPerTokenStored;
73 
74     mapping(address => uint) public tokenIds;
75 
76     uint public totalSupply;
77     mapping(address => uint) public balanceOf;
78 
79     address[] public rewards;
80     mapping(address => bool) public isReward;
81 
82     /// @notice A checkpoint for marking balance
83     struct Checkpoint {
84         uint timestamp;
85         uint balanceOf;
86     }
87 
88     /// @notice A checkpoint for marking reward rate
89     struct RewardPerTokenCheckpoint {
90         uint timestamp;
91         uint rewardPerToken;
92     }
93 
94     /// @notice A checkpoint for marking supply
95     struct SupplyCheckpoint {
96         uint timestamp;
97         uint supply;
98     }
99 
100     /// @notice A record of balance checkpoints for each account, by index
101     mapping (address => mapping (uint => Checkpoint)) public checkpoints;
102     /// @notice The number of checkpoints for each account
103     mapping (address => uint) public numCheckpoints;
104     /// @notice A record of balance checkpoints for each token, by index
105     mapping (uint => SupplyCheckpoint) public supplyCheckpoints;
106     /// @notice The number of checkpoints
107     uint public supplyNumCheckpoints;
108     /// @notice A record of balance checkpoints for each token, by index
109     mapping (address => mapping (uint => RewardPerTokenCheckpoint)) public rewardPerTokenCheckpoints;
110     /// @notice The number of checkpoints for each token
111     mapping (address => uint) public rewardPerTokenNumCheckpoints;
112 
113     event Deposit(address indexed from, uint tokenId, uint amount);
114     event Withdraw(address indexed from, uint tokenId, uint amount);
115     event NotifyReward(address indexed from, address indexed reward, uint amount);
116     event ClaimRewards(address indexed from, address indexed reward, uint amount);
117 
118     constructor(address _stake, address _bribe, address __ve, address _voter) {
119         stake = _stake;
120         bribe = _bribe;
121         _ve = __ve;
122         voter = _voter;
123         depositsOpen = true;
124         _safeApprove(ve(__ve).token(), __ve, type(uint).max);
125     }
126 
127     modifier whenDepositsOpen() {
128         require(depositsOpen, "This gauge is not open for deposits");
129         _;
130     }
131 
132     function stopDeposits() external {
133         require(msg.sender == voter, "must be from voter");
134         depositsOpen = false;
135     }
136 
137     function openDeposits() external {
138         require(msg.sender == voter, "must be from voter");
139         depositsOpen = true;
140     }
141 
142     function isDepositsOpen() external view returns (bool) {
143         return depositsOpen;
144     }
145 
146     // simple re-entrancy check
147     uint internal _unlocked = 1;
148     modifier lock() {
149         require(_unlocked == 1);
150         _unlocked = 2;
151         _;
152         _unlocked = 1;
153     }
154 
155     /**
156     * @notice Determine the prior balance for an account as of a block number
157     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
158     * @param account The address of the account to check
159     * @param timestamp The timestamp to get the balance at
160     * @return The balance the account had as of the given block
161     */
162     function getPriorBalanceIndex(address account, uint timestamp) public view returns (uint) {
163         uint nCheckpoints = numCheckpoints[account];
164         if (nCheckpoints == 0) {
165             return 0;
166         }
167 
168         // First check most recent balance
169         if (checkpoints[account][nCheckpoints - 1].timestamp <= timestamp) {
170             return (nCheckpoints - 1);
171         }
172 
173         // Next check implicit zero balance
174         if (checkpoints[account][0].timestamp > timestamp) {
175             return 0;
176         }
177 
178         uint lower = 0;
179         uint upper = nCheckpoints - 1;
180         while (upper > lower) {
181             uint center = upper - (upper - lower) / 2; // ceil, avoiding overflow
182             Checkpoint memory cp = checkpoints[account][center];
183             if (cp.timestamp == timestamp) {
184                 return center;
185             } else if (cp.timestamp < timestamp) {
186                 lower = center;
187             } else {
188                 upper = center - 1;
189             }
190         }
191         return lower;
192     }
193 
194     function getPriorSupplyIndex(uint timestamp) public view returns (uint) {
195         uint nCheckpoints = supplyNumCheckpoints;
196         if (nCheckpoints == 0) {
197             return 0;
198         }
199 
200         // First check most recent balance
201         if (supplyCheckpoints[nCheckpoints - 1].timestamp <= timestamp) {
202             return (nCheckpoints - 1);
203         }
204 
205         // Next check implicit zero balance
206         if (supplyCheckpoints[0].timestamp > timestamp) {
207             return 0;
208         }
209 
210         uint lower = 0;
211         uint upper = nCheckpoints - 1;
212         while (upper > lower) {
213             uint center = upper - (upper - lower) / 2; // ceil, avoiding overflow
214             SupplyCheckpoint memory cp = supplyCheckpoints[center];
215             if (cp.timestamp == timestamp) {
216                 return center;
217             } else if (cp.timestamp < timestamp) {
218                 lower = center;
219             } else {
220                 upper = center - 1;
221             }
222         }
223         return lower;
224     }
225 
226     function getPriorRewardPerToken(address token, uint timestamp) public view returns (uint, uint) {
227         uint nCheckpoints = rewardPerTokenNumCheckpoints[token];
228         if (nCheckpoints == 0) {
229             return (0,0);
230         }
231 
232         // First check most recent balance
233         if (rewardPerTokenCheckpoints[token][nCheckpoints - 1].timestamp <= timestamp) {
234             return (rewardPerTokenCheckpoints[token][nCheckpoints - 1].rewardPerToken, rewardPerTokenCheckpoints[token][nCheckpoints - 1].timestamp);
235         }
236 
237         // Next check implicit zero balance
238         if (rewardPerTokenCheckpoints[token][0].timestamp > timestamp) {
239             return (0,0);
240         }
241 
242         uint lower = 0;
243         uint upper = nCheckpoints - 1;
244         while (upper > lower) {
245             uint center = upper - (upper - lower) / 2; // ceil, avoiding overflow
246             RewardPerTokenCheckpoint memory cp = rewardPerTokenCheckpoints[token][center];
247             if (cp.timestamp == timestamp) {
248                 return (cp.rewardPerToken, cp.timestamp);
249             } else if (cp.timestamp < timestamp) {
250                 lower = center;
251             } else {
252                 upper = center - 1;
253             }
254         }
255         return (rewardPerTokenCheckpoints[token][lower].rewardPerToken, rewardPerTokenCheckpoints[token][lower].timestamp);
256     }
257 
258     function _writeCheckpoint(address account, uint balance) internal {
259         uint _timestamp = block.timestamp;
260         uint _nCheckPoints = numCheckpoints[account];
261 
262         if (_nCheckPoints > 0 && checkpoints[account][_nCheckPoints - 1].timestamp == _timestamp) {
263             checkpoints[account][_nCheckPoints - 1].balanceOf = balance;
264         } else {
265             checkpoints[account][_nCheckPoints] = Checkpoint(_timestamp, balance);
266             numCheckpoints[account] = _nCheckPoints + 1;
267         }
268     }
269 
270     function _writeRewardPerTokenCheckpoint(address token, uint reward, uint timestamp) internal {
271         uint _nCheckPoints = rewardPerTokenNumCheckpoints[token];
272 
273         if (_nCheckPoints > 0 && rewardPerTokenCheckpoints[token][_nCheckPoints - 1].timestamp == timestamp) {
274             rewardPerTokenCheckpoints[token][_nCheckPoints - 1].rewardPerToken = reward;
275         } else {
276             rewardPerTokenCheckpoints[token][_nCheckPoints] = RewardPerTokenCheckpoint(timestamp, reward);
277             rewardPerTokenNumCheckpoints[token] = _nCheckPoints + 1;
278         }
279     }
280 
281     function _writeSupplyCheckpoint() internal {
282         uint _nCheckPoints = supplyNumCheckpoints;
283         uint _timestamp = block.timestamp;
284 
285         if (_nCheckPoints > 0 && supplyCheckpoints[_nCheckPoints - 1].timestamp == _timestamp) {
286             supplyCheckpoints[_nCheckPoints - 1].supply = derivedSupply;
287         } else {
288             supplyCheckpoints[_nCheckPoints] = SupplyCheckpoint(_timestamp, derivedSupply);
289             supplyNumCheckpoints = _nCheckPoints + 1;
290         }
291     }
292 
293     function rewardsListLength() external view returns (uint) {
294         return rewards.length;
295     }
296 
297     // returns the last time the reward was modified or periodFinish if the reward has ended
298     function lastTimeRewardApplicable(address token) public view returns (uint) {
299         return Math.min(block.timestamp, periodFinish[token]);
300     }
301 
302     function getReward(address account, address[] memory tokens) external lock {
303         require(msg.sender == account || msg.sender == voter);
304         _unlocked = 1;
305         Voter(voter).distribute(address(this));
306         _unlocked = 2;
307 
308         for (uint i = 0; i < tokens.length; i++) {
309             (rewardPerTokenStored[tokens[i]], lastUpdateTime[tokens[i]]) = _updateRewardPerToken(tokens[i]);
310 
311             uint _reward = earned(tokens[i], account);
312             lastEarn[tokens[i]][account] = block.timestamp;
313             userRewardPerTokenStored[tokens[i]][account] = rewardPerTokenStored[tokens[i]];
314             if (_reward > 0) {
315                 //setup gauges to send you veAPHRA while token is unlocked
316               if (ve(_ve).isUnlocked()) {
317                   _safeTransfer(tokens[i], account, _reward);
318               } else {
319                   uint tokenId = tokenIds[msg.sender];
320 
321                   if (tokenId == 0 || block.timestamp > ve(_ve).locked__end(tokenId)) {
322 
323                       //set initial lock for 8 weeks
324                       tokenIds[msg.sender] = ve(_ve).create_lock_for(_reward, DURATION * 8, msg.sender);
325                   } else {
326                       ve(_ve).deposit_for(tokenId, _reward);
327                   }
328               }
329             }
330             emit ClaimRewards(msg.sender, tokens[i], _reward);
331         }
332 
333         uint _derivedBalance = derivedBalances[account];
334         derivedSupply -= _derivedBalance;
335         _derivedBalance = derivedBalance(account);
336         derivedBalances[account] = _derivedBalance;
337         derivedSupply += _derivedBalance;
338 
339         _writeCheckpoint(account, derivedBalances[account]);
340         _writeSupplyCheckpoint();
341     }
342 
343     function rewardPerToken(address token) public view returns (uint) {
344         if (derivedSupply == 0) {
345             return rewardPerTokenStored[token];
346         }
347         return rewardPerTokenStored[token] + ((lastTimeRewardApplicable(token) - Math.min(lastUpdateTime[token], periodFinish[token])) * rewardRate[token] * PRECISION / derivedSupply);
348     }
349 
350     function derivedBalance(address account) public view returns (uint) {
351         uint _tokenId = tokenIds[account];
352         uint _balance = balanceOf[account];
353         uint _derived = _balance * 40 / 100;
354         uint _adjusted = 0;
355         uint _supply = erc20(_ve).totalSupply();
356         //only activate boosts on ve unlock
357         if (account == ve(_ve).ownerOf(_tokenId) && _supply > 0 && ve(_ve).isUnlocked()) {
358             _adjusted = ve(_ve).balanceOfNFT(_tokenId);
359             _adjusted = (totalSupply * _adjusted / _supply) * 60 / 100;
360         }
361         return Math.min((_derived + _adjusted), _balance);
362     }
363 
364     function batchRewardPerToken(address token, uint maxRuns) external {
365         (rewardPerTokenStored[token], lastUpdateTime[token])  = _batchRewardPerToken(token, maxRuns);
366     }
367 
368     function _batchRewardPerToken(address token, uint maxRuns) internal returns (uint, uint) {
369         uint _startTimestamp = lastUpdateTime[token];
370         uint reward = rewardPerTokenStored[token];
371 
372         if (supplyNumCheckpoints == 0) {
373             return (reward, _startTimestamp);
374         }
375 
376         if (rewardRate[token] == 0) {
377             return (reward, block.timestamp);
378         }
379 
380         uint _startIndex = getPriorSupplyIndex(_startTimestamp);
381         uint _endIndex = Math.min(supplyNumCheckpoints-1, maxRuns);
382 
383         for (uint i = _startIndex; i < _endIndex; i++) {
384             SupplyCheckpoint memory sp0 = supplyCheckpoints[i];
385             if (sp0.supply > 0) {
386                 SupplyCheckpoint memory sp1 = supplyCheckpoints[i+1];
387                 (uint _reward, uint _endTime) = _calcRewardPerToken(token, sp1.timestamp, sp0.timestamp, sp0.supply, _startTimestamp);
388                 reward += _reward;
389                 _writeRewardPerTokenCheckpoint(token, reward, _endTime);
390                 _startTimestamp = _endTime;
391             }
392         }
393 
394         return (reward, _startTimestamp);
395     }
396 
397     function _calcRewardPerToken(address token, uint timestamp1, uint timestamp0, uint supply, uint startTimestamp) internal view returns (uint, uint) {
398         uint endTime = Math.max(timestamp1, startTimestamp);
399         return (((Math.min(endTime, periodFinish[token]) - Math.min(Math.max(timestamp0, startTimestamp), periodFinish[token])) * rewardRate[token] * PRECISION / supply), endTime);
400     }
401 
402     function _updateRewardPerToken(address token) internal returns (uint, uint) {
403         uint _startTimestamp = lastUpdateTime[token];
404         uint reward = rewardPerTokenStored[token];
405 
406         if (supplyNumCheckpoints == 0) {
407             return (reward, _startTimestamp);
408         }
409 
410         if (rewardRate[token] == 0) {
411             return (reward, block.timestamp);
412         }
413 
414         uint _startIndex = getPriorSupplyIndex(_startTimestamp);
415         uint _endIndex = supplyNumCheckpoints-1;
416 
417         if (_endIndex - _startIndex > 1) {
418             for (uint i = _startIndex; i < _endIndex-1; i++) {
419                 SupplyCheckpoint memory sp0 = supplyCheckpoints[i];
420                 if (sp0.supply > 0) {
421                     SupplyCheckpoint memory sp1 = supplyCheckpoints[i+1];
422                     (uint _reward, uint _endTime) = _calcRewardPerToken(token, sp1.timestamp, sp0.timestamp, sp0.supply, _startTimestamp);
423                     reward += _reward;
424                     _writeRewardPerTokenCheckpoint(token, reward, _endTime);
425                     _startTimestamp = _endTime;
426                 }
427             }
428         }
429 
430         SupplyCheckpoint memory sp = supplyCheckpoints[_endIndex];
431         if (sp.supply > 0) {
432             (uint _reward,) = _calcRewardPerToken(token, lastTimeRewardApplicable(token), Math.max(sp.timestamp, _startTimestamp), sp.supply, _startTimestamp);
433             reward += _reward;
434             _writeRewardPerTokenCheckpoint(token, reward, block.timestamp);
435             _startTimestamp = block.timestamp;
436         }
437 
438         return (reward, _startTimestamp);
439     }
440 
441     // earned is an estimation, it won't be exact till the supply > rewardPerToken calculations have run
442     function earned(address token, address account) public view returns (uint) {
443         uint _startTimestamp = Math.max(lastEarn[token][account], rewardPerTokenCheckpoints[token][0].timestamp);
444         if (numCheckpoints[account] == 0) {
445             return 0;
446         }
447 
448         uint _startIndex = getPriorBalanceIndex(account, _startTimestamp);
449         uint _endIndex = numCheckpoints[account]-1;
450 
451         uint reward = 0;
452 
453         if (_endIndex - _startIndex > 1) {
454             for (uint i = _startIndex; i < _endIndex-1; i++) {
455                 Checkpoint memory cp0 = checkpoints[account][i];
456                 Checkpoint memory cp1 = checkpoints[account][i+1];
457                 (uint _rewardPerTokenStored0,) = getPriorRewardPerToken(token, cp0.timestamp);
458                 (uint _rewardPerTokenStored1,) = getPriorRewardPerToken(token, cp1.timestamp);
459                 reward += cp0.balanceOf * (_rewardPerTokenStored1 - _rewardPerTokenStored0) / PRECISION;
460             }
461         }
462 
463         Checkpoint memory cp = checkpoints[account][_endIndex];
464         (uint _rewardPerTokenStored,) = getPriorRewardPerToken(token, cp.timestamp);
465         reward += cp.balanceOf * (rewardPerToken(token) - Math.max(_rewardPerTokenStored, userRewardPerTokenStored[token][account])) / PRECISION;
466 
467         return reward;
468     }
469 
470     function depositAll(uint tokenId) external {
471         deposit(erc20(stake).balanceOf(msg.sender), tokenId);
472     }
473 
474     function deposit(uint amount, uint tokenId) public whenDepositsOpen lock {
475         require(amount > 0);
476 
477         _safeTransferFrom(stake, msg.sender, address(this), amount);
478         totalSupply += amount;
479         balanceOf[msg.sender] += amount;
480 
481         if (tokenId > 0) {
482             require(ve(_ve).ownerOf(tokenId) == msg.sender);
483             if (tokenIds[msg.sender] == 0) {
484                 tokenIds[msg.sender] = tokenId;
485                 Voter(voter).attachTokenToGauge(tokenId, msg.sender);
486             }
487             require(tokenIds[msg.sender] == tokenId);
488         } else {
489             tokenId = tokenIds[msg.sender];
490         }
491 
492         uint _derivedBalance = derivedBalances[msg.sender];
493         derivedSupply -= _derivedBalance;
494         _derivedBalance = derivedBalance(msg.sender);
495         derivedBalances[msg.sender] = _derivedBalance;
496         derivedSupply += _derivedBalance;
497 
498         _writeCheckpoint(msg.sender, _derivedBalance);
499         _writeSupplyCheckpoint();
500 
501         Voter(voter).emitDeposit(tokenId, msg.sender, amount);
502         emit Deposit(msg.sender, tokenId, amount);
503     }
504 
505     function withdrawAll() external {
506         withdraw(balanceOf[msg.sender]);
507     }
508 
509     function withdraw(uint amount) public {
510         uint tokenId = 0;
511         if (amount == balanceOf[msg.sender]) {
512             tokenId = tokenIds[msg.sender];
513         }
514         withdrawToken(amount, tokenId);
515     }
516 
517     function withdrawToken(uint amount, uint tokenId) public lock {
518         totalSupply -= amount;
519         balanceOf[msg.sender] -= amount;
520         _safeTransfer(stake, msg.sender, amount);
521 
522         if (tokenId > 0) {
523             require(tokenId == tokenIds[msg.sender]);
524             tokenIds[msg.sender] = 0;
525             Voter(voter).detachTokenFromGauge(tokenId, msg.sender);
526         } else {
527             tokenId = tokenIds[msg.sender];
528         }
529 
530         uint _derivedBalance = derivedBalances[msg.sender];
531         derivedSupply -= _derivedBalance;
532         _derivedBalance = derivedBalance(msg.sender);
533         derivedBalances[msg.sender] = _derivedBalance;
534         derivedSupply += _derivedBalance;
535 
536         _writeCheckpoint(msg.sender, derivedBalances[msg.sender]);
537         _writeSupplyCheckpoint();
538 
539         Voter(voter).emitWithdraw(tokenId, msg.sender, amount);
540         emit Withdraw(msg.sender, tokenId, amount);
541     }
542 
543     function left(address token) external view returns (uint) {
544         if (block.timestamp >= periodFinish[token]) return 0;
545         uint _remaining = periodFinish[token] - block.timestamp;
546         return _remaining * rewardRate[token];
547     }
548 
549     function notifyRewardAmount(address token, uint amount) external lock {
550         require(token != stake);
551         require(amount > 0);
552         if (rewardRate[token] == 0) _writeRewardPerTokenCheckpoint(token, 0, block.timestamp);
553         (rewardPerTokenStored[token], lastUpdateTime[token]) = _updateRewardPerToken(token);
554 
555         if (block.timestamp >= periodFinish[token]) {
556             _safeTransferFrom(token, msg.sender, address(this), amount);
557             rewardRate[token] = amount / DURATION;
558         } else {
559             uint _remaining = periodFinish[token] - block.timestamp;
560             uint _left = _remaining * rewardRate[token];
561             require(amount > _left);
562             _safeTransferFrom(token, msg.sender, address(this), amount);
563             rewardRate[token] = (amount + _left) / DURATION;
564         }
565         require(rewardRate[token] > 0);
566         uint balance = erc20(token).balanceOf(address(this));
567         require(rewardRate[token] <= balance / DURATION, "Provided reward too high");
568         periodFinish[token] = block.timestamp + DURATION;
569         if (!isReward[token]) {
570             isReward[token] = true;
571             rewards.push(token);
572         }
573 
574         emit NotifyReward(msg.sender, token, amount);
575     }
576 
577     function _safeTransfer(address token, address to, uint256 value) internal {
578         require(token.code.length > 0);
579         (bool success, bytes memory data) =
580         token.call(abi.encodeWithSelector(erc20.transfer.selector, to, value));
581         require(success && (data.length == 0 || abi.decode(data, (bool))));
582     }
583 
584     function _safeTransferFrom(address token, address from, address to, uint256 value) internal {
585         require(token.code.length > 0);
586         (bool success, bytes memory data) =
587         token.call(abi.encodeWithSelector(erc20.transferFrom.selector, from, to, value));
588         require(success && (data.length == 0 || abi.decode(data, (bool))));
589     }
590 
591     function _safeApprove(address token, address spender, uint256 value) internal {
592         require(token.code.length > 0);
593         (bool success, bytes memory data) =
594         token.call(abi.encodeWithSelector(erc20.approve.selector, spender, value));
595         require(success && (data.length == 0 || abi.decode(data, (bool))));
596     }
597 }
598 
599 contract GaugeFactory {
600     address public last_gauge;
601 
602     function createGauge(address _asset, address _bribe, address _ve) external returns (address) {
603         last_gauge = address(new Gauge(_asset, _bribe, _ve, msg.sender));
604         return last_gauge;
605     }
606 
607     function createGaugeSingle(address _asset, address _bribe, address _ve, address _voter) external returns (address) {
608         last_gauge = address(new Gauge(_asset, _bribe, _ve, _voter));
609         return last_gauge;
610     }
611 }