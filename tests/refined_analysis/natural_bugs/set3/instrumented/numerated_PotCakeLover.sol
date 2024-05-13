1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 import "@openzeppelin/contracts/math/Math.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
39 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
40 
41 import {PotConstant} from "../library/PotConstant.sol";
42 
43 import "../interfaces/IMasterChef.sol";
44 import "../vaults/VaultController.sol";
45 import "../interfaces/IZap.sol";
46 import "../interfaces/IPriceCalculator.sol";
47 
48 import "./PotController.sol";
49 
50 contract PotCakeLover is VaultController, PotController {
51     using SafeMath for uint;
52     using SafeBEP20 for IBEP20;
53 
54     /* ========== CONSTANT ========== */
55 
56     address public constant TIMELOCK_ADDRESS = 0x85c9162A51E03078bdCd08D4232Bab13ed414cC3;
57 
58     IBEP20 private constant BUNNY = IBEP20(0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51);
59     IBEP20 private constant CAKE = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
60 
61     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
62     IPriceCalculator private constant priceCalculator = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
63     IZap private constant ZapBSC = IZap(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
64 
65     uint private constant WEIGHT_BASE = 1000;
66 
67     /* ========== STATE VARIABLES ========== */
68 
69     PotConstant.PotState public state;
70 
71     uint public pid;
72     uint public minAmount;
73     uint public maxAmount;
74     uint public burnRatio;
75 
76     uint private _totalSupply;  // total principal
77     uint private _currentSupply;
78     uint private _donateSupply;
79     uint private _totalHarvested;
80 
81     uint private _totalWeight;  // for select winner
82     uint private _currentUsers;
83 
84     mapping(address => uint) private _available;
85     mapping(address => uint) private _donation;
86 
87     mapping(address => uint) private _depositedAt;
88     mapping(address => uint) private _participateCount;
89     mapping(address => uint) private _lastParticipatedPot;
90 
91     mapping(uint => PotConstant.PotHistory) private _histories;
92 
93     bytes32 private _treeKey;
94     uint private _boostDuration;
95 
96     /* ========== MODIFIERS ========== */
97 
98     modifier onlyValidState(PotConstant.PotState _state) {
99         require(state == _state, "BunnyPot: invalid pot state");
100         _;
101     }
102 
103     modifier onlyValidDeposit(uint amount) {
104         require(_available[msg.sender] == 0 || _depositedAt[msg.sender] >= startedAt, "BunnyPot: cannot deposit before claim");
105         require(amount >= minAmount && amount.add(_available[msg.sender]) <= maxAmount, "BunnyPot: invalid input amount");
106         if (_available[msg.sender] == 0) {
107             _participateCount[msg.sender] = _participateCount[msg.sender].add(1);
108             _currentUsers = _currentUsers.add(1);
109         }
110         _;
111     }
112 
113     /* ========== EVENTS ========== */
114 
115     event Deposited(address indexed user, uint amount);
116     event Claimed(address indexed user, uint amount);
117 
118     /* ========== INITIALIZER ========== */
119 
120     function initialize(uint _pid, address _token) external initializer {
121         __VaultController_init(IBEP20(_token));
122 
123         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
124         _stakingToken.safeApprove(address(ZapBSC), uint(- 1));
125 
126         pid = _pid;
127         burnRatio = 10;
128         state = PotConstant.PotState.Cooked;
129         _boostDuration = 4 hours;
130     }
131 
132     /* ========== VIEW FUNCTIONS ========== */
133 
134     function totalValueInUSD() public view returns (uint valueInUSD) {
135         (, valueInUSD) = priceCalculator.valueOfAsset(address(_stakingToken), _totalSupply);
136     }
137 
138     function availableOf(address account) public view returns (uint) {
139         return _available[account];
140     }
141 
142     function weightOf(address _account) public view returns (uint, uint, uint) {
143         return (_timeWeight(_account), _countWeight(_account), _valueWeight(_account));
144     }
145 
146     function depositedAt(address account) public view returns (uint) {
147         return _depositedAt[account];
148     }
149 
150     function winnersOf(uint _potId) public view returns (address[] memory) {
151         return _histories[_potId].winners;
152     }
153 
154     function potInfoOf(address _account) public view returns (PotConstant.PotInfo memory, PotConstant.PotInfoMe memory) {
155         (, uint valueInUSD) = priceCalculator.valueOfAsset(address(_stakingToken), 1e18);
156 
157         PotConstant.PotInfo memory info;
158         info.potId = potId;
159         info.state = state;
160         info.supplyCurrent = _currentSupply;
161         info.supplyDonation = _donateSupply;
162         info.supplyInUSD = _currentSupply.add(_donateSupply).mul(valueInUSD).div(1e18);
163         info.rewards = _totalHarvested.mul(100 - burnRatio).div(100);
164         info.rewardsInUSD = _totalHarvested.mul(100 - burnRatio).div(100).mul(valueInUSD).div(1e18);
165         info.minAmount = minAmount;
166         info.maxAmount = maxAmount;
167         info.avgOdds = _totalWeight > 0 && _currentUsers > 0 ? _totalWeight.div(_currentUsers).mul(100e18).div(_totalWeight) : 0;
168         info.startedAt = startedAt;
169 
170         PotConstant.PotInfoMe memory infoMe;
171         infoMe.wTime = _timeWeight(_account);
172         infoMe.wCount = _countWeight(_account);
173         infoMe.wValue = _valueWeight(_account);
174         infoMe.odds = _totalWeight > 0 ? _calculateWeight(_account).mul(100e18).div(_totalWeight) : 0;
175         infoMe.available = availableOf(_account);
176         infoMe.lastParticipatedPot = _lastParticipatedPot[_account];
177         infoMe.depositedAt = depositedAt(_account);
178         return (info, infoMe);
179     }
180 
181     function potHistoryOf(uint _potId) public view returns (PotConstant.PotHistory memory) {
182         return _histories[_potId];
183     }
184 
185     function boostDuration() external view returns(uint) {
186         return _boostDuration;
187     }
188 
189     /* ========== MUTATIVE FUNCTIONS ========== */
190 
191     function deposit(uint amount) public onlyValidState(PotConstant.PotState.Opened) onlyValidDeposit(amount) {
192         address account = msg.sender;
193         _stakingToken.safeTransferFrom(account, address(this), amount);
194 
195         _currentSupply = _currentSupply.add(amount);
196         _available[account] = _available[account].add(amount);
197 
198         _lastParticipatedPot[account] = potId;
199         _depositedAt[account] = block.timestamp;
200 
201         bytes32 accountID = bytes32(uint256(account));
202         uint weightBefore = getWeight(_getTreeKey(), accountID);
203         uint weightCurrent = _calculateWeight(account);
204         _totalWeight = _totalWeight.sub(weightBefore).add(weightCurrent);
205         setWeight(_getTreeKey(), weightCurrent, accountID);
206 
207         _depositAndHarvest(amount);
208 
209         emit Deposited(account, amount);
210     }
211 
212     function stepToNext() public onlyValidState(PotConstant.PotState.Opened) {
213         address account = msg.sender;
214         uint amount = _available[account];
215         require(amount > 0 && _lastParticipatedPot[account] < potId, "BunnyPot: is not participant");
216 
217         uint available = Math.min(maxAmount, amount);
218 
219         address[] memory winners = potHistoryOf(_lastParticipatedPot[account]).winners;
220         for(uint i = 0; i < winners.length; i++) {
221             if (winners[i] == account) {
222                 revert("BunnyPot: winner can't step to next");
223             }
224         }
225 
226         _participateCount[account] = _participateCount[account].add(1);
227         _currentUsers = _currentUsers.add(1);
228         _currentSupply = _currentSupply.add(available);
229         _lastParticipatedPot[account] = potId;
230         _depositedAt[account] = block.timestamp;
231 
232         bytes32 accountID = bytes32(uint256(account));
233 
234         uint weightCurrent = _calculateWeight(account);
235         _totalWeight = _totalWeight.add(weightCurrent);
236         setWeight(_getTreeKey(), weightCurrent, accountID);
237 
238         if (amount > available) {
239             _stakingToken.safeTransfer(account, amount.sub(available));
240         }
241     }
242 
243     function withdrawAll() public {
244         address account = msg.sender;
245         uint amount = _available[account];
246         require(amount > 0 && _lastParticipatedPot[account] < potId, "BunnyPot: is not participant");
247 
248         delete _available[account];
249 
250         _withdrawAndHarvest(amount);
251         _stakingToken.safeTransfer(account, amount);
252 
253         emit Claimed(account, amount);
254     }
255 
256     function depositDonation(uint amount) public onlyWhitelisted {
257         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
258         _donateSupply = _donateSupply.add(amount);
259         _donation[msg.sender] = _donation[msg.sender].add(amount);
260 
261         _depositAndHarvest(amount);
262     }
263 
264     function withdrawDonation() public onlyWhitelisted {
265         uint amount = _donation[msg.sender];
266         _donateSupply = _donateSupply.sub(amount);
267         delete _donation[msg.sender];
268 
269         _withdrawAndHarvest(amount);
270         _stakingToken.safeTransfer(msg.sender, amount);
271     }
272 
273     /* ========== RESTRICTED FUNCTIONS ========== */
274 
275     function setAmountMinMax(uint _min, uint _max) external onlyKeeper onlyValidState(PotConstant.PotState.Cooked) {
276         minAmount = _min;
277         maxAmount = _max;
278     }
279 
280     function openPot() external onlyKeeper onlyValidState(PotConstant.PotState.Cooked) {
281         state = PotConstant.PotState.Opened;
282         _overCook();
283 
284         potId = potId + 1;
285         startedAt = block.timestamp;
286 
287         _totalWeight = 0;
288         _currentSupply = 0;
289         _totalHarvested = 0;
290         _currentUsers = 0;
291 
292         _treeKey = bytes32(potId);
293         createTree(_treeKey);
294     }
295 
296     function closePot() external onlyKeeper onlyValidState(PotConstant.PotState.Opened) {
297         state = PotConstant.PotState.Closed;
298         _harvest(_stakingToken.balanceOf(address(this)));
299     }
300 
301     function overCook() external onlyKeeper onlyValidState(PotConstant.PotState.Closed) {
302         state = PotConstant.PotState.Cooked;
303         getRandomNumber(_totalWeight);
304     }
305 
306     function harvest() external onlyKeeper {
307         if (_totalSupply == 0) return;
308         _withdrawAndHarvest(0);
309     }
310 
311     function sweep() external onlyOwner {
312         (uint staked,) = CAKE_MASTER_CHEF.userInfo(pid, address(this));
313         uint balance = _stakingToken.balanceOf(address(this));
314         uint extra = balance.add(staked).sub(_totalSupply);
315 
316         if (balance < extra) {
317             _withdrawStakingToken(extra.sub(balance));
318         }
319         _stakingToken.safeTransfer(owner(), extra);
320     }
321 
322     function setBurnRatio(uint _burnRatio) external onlyOwner {
323         require(_burnRatio <= 100, "BunnyPot: invalid range");
324         burnRatio = _burnRatio;
325     }
326 
327     function setBoostDuration(uint duration) external onlyOwner {
328         _boostDuration = duration;
329     }
330 
331     /* ========== PRIVATE FUNCTIONS ========== */
332 
333     function _depositStakingToken(uint amount) private returns (uint cakeHarvested) {
334         uint before = CAKE.balanceOf(address(this));
335         if (pid == 0) {
336             CAKE_MASTER_CHEF.enterStaking(amount);
337             cakeHarvested = CAKE.balanceOf(address(this)).add(amount).sub(before);
338         } else {
339             CAKE_MASTER_CHEF.deposit(pid, amount);
340             cakeHarvested = CAKE.balanceOf(address(this)).sub(before);
341         }
342     }
343 
344     function _withdrawStakingToken(uint amount) private returns (uint cakeHarvested) {
345         uint before = CAKE.balanceOf(address(this));
346         if (pid == 0) {
347             CAKE_MASTER_CHEF.leaveStaking(amount);
348             cakeHarvested = CAKE.balanceOf(address(this)).sub(amount).sub(before);
349         } else {
350             CAKE_MASTER_CHEF.withdraw(pid, amount);
351             cakeHarvested = CAKE.balanceOf(address(this)).sub(before);
352         }
353     }
354 
355     function _depositAndHarvest(uint amount) private {
356         uint cakeHarvested = _depositStakingToken(amount);
357         uint harvestShare = _totalSupply != 0 ? cakeHarvested.mul(_currentSupply.add(_donateSupply).add(_totalHarvested)).div(_totalSupply) : 0;
358         _totalHarvested = _totalHarvested.add(harvestShare);
359         _totalSupply = _totalSupply.add(harvestShare).add(amount);
360         _harvest(cakeHarvested);
361     }
362 
363     function _withdrawAndHarvest(uint amount) private {
364         uint cakeHarvested = _withdrawStakingToken(amount);
365         uint harvestShare = _totalSupply != 0 ? cakeHarvested.mul(_currentSupply.add(_donateSupply).add(_totalHarvested)).div(_totalSupply) : 0;
366         _totalHarvested = _totalHarvested.add(harvestShare);
367         _totalSupply = _totalSupply.add(harvestShare).sub(amount);
368         _harvest(cakeHarvested);
369     }
370 
371     function _harvest(uint amount) private {
372         if (amount == 0) return;
373 
374         if (pid == 0) {
375             CAKE_MASTER_CHEF.enterStaking(amount);
376         } else {
377             CAKE_MASTER_CHEF.deposit(pid, amount);
378         }
379     }
380 
381     function _overCook() private {
382         if (_totalWeight == 0) return;
383 
384         uint buyback = _totalHarvested.mul(burnRatio).div(100);
385         _totalHarvested = _totalHarvested.sub(buyback);
386         uint winnerCount = Math.max(1, _totalHarvested.div(1000e18));
387 
388 
389         if (buyback > 0) {
390             _withdrawStakingToken(buyback);
391             uint beforeBUNNY = BUNNY.balanceOf(address(this));
392             ZapBSC.zapInToken(address(_stakingToken), buyback, address(BUNNY));
393             BUNNY.safeTransfer(TIMELOCK_ADDRESS, BUNNY.balanceOf(address(this)).sub(beforeBUNNY));
394         }
395 
396         PotConstant.PotHistory memory history;
397         history.potId = potId;
398         history.users = _currentUsers;
399         history.rewardPerWinner = winnerCount > 0 ? _totalHarvested.div(winnerCount) : 0;
400         history.date = block.timestamp;
401         history.winners = new address[](winnerCount);
402 
403         for (uint i = 0; i < winnerCount; i++) {
404             uint rn = uint256(keccak256(abi.encode(_randomness, i))).mod(_totalWeight);
405             address selected = draw(_getTreeKey(), rn);
406 
407             _available[selected] = _available[selected].add(_totalHarvested.div(winnerCount));
408             history.winners[i] = selected;
409             delete _participateCount[selected];
410         }
411 
412         _histories[potId] = history;
413     }
414 
415     function _calculateWeight(address account) private view returns (uint) {
416         if (_depositedAt[account] < startedAt) return 0;
417 
418         uint wTime = _timeWeight(account);
419         uint wCount = _countWeight(account);
420         uint wValue = _valueWeight(account);
421         return wTime.mul(wCount).mul(wValue).div(100);
422     }
423 
424     function _timeWeight(address account) private view returns (uint) {
425         if (_depositedAt[account] < startedAt) return 0;
426 
427         uint timestamp = _depositedAt[account].sub(startedAt);
428         if (timestamp < _boostDuration) {
429             return 28;
430         } else if (timestamp < _boostDuration.mul(2)) {
431             return 24;
432         } else if (timestamp < _boostDuration.mul(3)) {
433             return 20;
434         } else if (timestamp < _boostDuration.mul(4)) {
435             return 16;
436         } else if (timestamp < _boostDuration.mul(5)) {
437             return 12;
438         } else {
439             return 8;
440         }
441     }
442 
443     function _countWeight(address account) private view returns (uint) {
444         uint count = _participateCount[account];
445         if (count >= 13) {
446             return 40;
447         } else if (count >= 9) {
448             return 30;
449         } else if (count >= 5) {
450             return 20;
451         } else {
452             return 10;
453         }
454     }
455 
456     function _valueWeight(address account) private view returns (uint) {
457         uint amount = _available[account];
458         uint denom = Math.max(minAmount, 1);
459         return Math.min(amount.mul(10).div(denom), maxAmount.mul(10).div(denom));
460     }
461 
462     function _getTreeKey() private view returns(bytes32) {
463         return _treeKey == bytes32(0) ? keccak256("Bunny/MultipleWinnerPot") : _treeKey;
464     }
465 }
