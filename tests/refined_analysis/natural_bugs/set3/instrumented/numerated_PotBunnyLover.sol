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
34 * SOFTWARE.
35 */
36 
37 import "@openzeppelin/contracts/math/Math.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
39 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
40 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
41 
42 import {PotConstant} from "../library/PotConstant.sol";
43 
44 import "../interfaces/IBunnyPool.sol";
45 import "../interfaces/IMasterChef.sol";
46 import "../interfaces/IZap.sol";
47 import "../interfaces/IPriceCalculator.sol";
48 import "../interfaces/legacy/IStrategyLegacy.sol";
49 
50 import "../vaults/VaultController.sol";
51 
52 import "./PotController.sol";
53 
54 contract PotBunnyLover is VaultController, PotController {
55     using SafeMath for uint;
56     using SafeBEP20 for IBEP20;
57 
58     /* ========== CONSTANT ========== */
59 
60     address public constant TIMELOCK_ADDRESS = 0x85c9162A51E03078bdCd08D4232Bab13ed414cC3;
61 
62     IBEP20 private constant BUNNY = IBEP20(0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51);
63     IBEP20 private constant WBNB = IBEP20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
64     IBEP20 private constant CAKE = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
65     IPriceCalculator private constant priceCalculator = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
66     IZap private constant ZapBSC = IZap(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
67     IStrategyLegacy private constant BUNNYPool = IStrategyLegacy(0xCADc8CB26c8C7cB46500E61171b5F27e9bd7889D);
68 
69     uint private constant WEIGHT_BASE = 1000;
70 
71     /* ========== STATE VARIABLES ========== */
72 
73     PotConstant.PotState public state;
74 
75     uint public pid;
76     uint public minAmount;
77     uint public maxAmount;
78     uint public burnRatio;
79 
80     uint private _totalSupply;  // total principal
81     uint private _currentSupply;
82     uint private _donateSupply;
83     uint private _totalHarvested;
84 
85     uint private _totalWeight;  // for select winner
86     uint private _currentUsers;
87 
88     mapping(address => uint) private _available;
89     mapping(address => uint) private _donation;
90 
91     mapping(address => uint) private _depositedAt;
92     mapping(address => uint) private _participateCount;
93     mapping(address => uint) private _lastParticipatedPot;
94 
95     mapping(uint => PotConstant.PotHistory) private _histories;
96 
97     bytes32 private _treeKey;
98     uint private _boostDuration;
99     address private _bunnyPool;
100 
101     /* ========== MODIFIERS ========== */
102 
103     modifier onlyValidState(PotConstant.PotState _state) {
104         require(state == _state, "BunnyPot: invalid pot state");
105         _;
106     }
107 
108     modifier onlyValidDeposit(uint amount) {
109         require(_available[msg.sender] == 0 || _depositedAt[msg.sender] >= startedAt, "BunnyPot: cannot deposit before claim");
110         require(amount >= minAmount && amount.add(_available[msg.sender]) <= maxAmount, "BunnyPot: invalid input amount");
111         if (_available[msg.sender] == 0) {
112             _participateCount[msg.sender] = _participateCount[msg.sender].add(1);
113             _currentUsers = _currentUsers.add(1);
114         }
115         _;
116     }
117 
118     /* ========== EVENTS ========== */
119 
120     event Deposited(address indexed user, uint amount);
121     event Claimed(address indexed user, uint amount);
122 
123     /* ========== INITIALIZER ========== */
124 
125     receive() external payable {}
126 
127     function initialize() external initializer {
128         __VaultController_init(BUNNY);
129 
130         _stakingToken.safeApprove(address(ZapBSC), uint(-1));
131 
132         burnRatio = 10;
133         state = PotConstant.PotState.Cooked;
134         _boostDuration = 4 hours;
135     }
136 
137     /* ========== VIEW FUNCTIONS ========== */
138 
139     function totalValueInUSD() public view returns (uint valueInUSD) {
140         (, valueInUSD) = priceCalculator.valueOfAsset(address(_stakingToken), _totalSupply);
141     }
142 
143     function availableOf(address account) public view returns (uint) {
144         return _available[account];
145     }
146 
147     function weightOf(address _account) public view returns (uint, uint, uint) {
148         return (_timeWeight(_account), _countWeight(_account), _valueWeight(_account));
149     }
150 
151     function depositedAt(address account) public view returns (uint) {
152         return _depositedAt[account];
153     }
154 
155     function winnersOf(uint _potId) public view returns (address[] memory) {
156         return _histories[_potId].winners;
157     }
158 
159     function potInfoOf(address _account) public view returns (PotConstant.PotInfo memory, PotConstant.PotInfoMe memory) {
160         (, uint valueInUSD) = priceCalculator.valueOfAsset(address(_stakingToken), 1e18);
161 
162         PotConstant.PotInfo memory info;
163         info.potId = potId;
164         info.state = state;
165         info.supplyCurrent = _currentSupply;
166         info.supplyDonation = _donateSupply;
167         info.supplyInUSD = _currentSupply.add(_donateSupply).mul(valueInUSD).div(1e18);
168         info.rewards = _totalHarvested.mul(100 - burnRatio).div(100);
169         info.rewardsInUSD = _totalHarvested.mul(100 - burnRatio).div(100).mul(valueInUSD).div(1e18);
170         info.minAmount = minAmount;
171         info.maxAmount = maxAmount;
172         info.avgOdds = _totalWeight > 0 && _currentUsers > 0 ? _totalWeight.div(_currentUsers).mul(100e18).div(_totalWeight) : 0;
173         info.startedAt = startedAt;
174 
175         PotConstant.PotInfoMe memory infoMe;
176         infoMe.wTime = _timeWeight(_account);
177         infoMe.wCount = _countWeight(_account);
178         infoMe.wValue = _valueWeight(_account);
179         infoMe.odds = _totalWeight > 0 ? _calculateWeight(_account).mul(100e18).div(_totalWeight) : 0;
180         infoMe.available = availableOf(_account);
181         infoMe.lastParticipatedPot = _lastParticipatedPot[_account];
182         infoMe.depositedAt = depositedAt(_account);
183         return (info, infoMe);
184     }
185 
186     function potHistoryOf(uint _potId) public view returns (PotConstant.PotHistory memory) {
187         return _histories[_potId];
188     }
189 
190     function boostDuration() external view returns (uint) {
191         return _boostDuration;
192     }
193 
194     /* ========== MUTATIVE FUNCTIONS ========== */
195 
196     function deposit(uint amount) public onlyValidState(PotConstant.PotState.Opened) onlyValidDeposit(amount) {
197         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
198         address account = msg.sender;
199         _stakingToken.safeTransferFrom(account, address(this), amount);
200 
201         _currentSupply = _currentSupply.add(amount);
202         _available[account] = _available[account].add(amount);
203 
204         _lastParticipatedPot[account] = potId;
205         _depositedAt[account] = block.timestamp;
206         _totalSupply = _totalSupply.add(amount);
207 
208         bytes32 accountID = bytes32(uint256(account));
209         uint weightBefore = getWeight(_getTreeKey(), accountID);
210         uint weightCurrent = _calculateWeight(account);
211         _totalWeight = _totalWeight.sub(weightBefore).add(weightCurrent);
212         setWeight(_getTreeKey(), weightCurrent, accountID);
213 
214         IBunnyPool(_bunnyPool).deposit(amount);
215         emit Deposited(account, amount);
216     }
217 
218     function stepToNext() public onlyValidState(PotConstant.PotState.Opened) {
219         address account = msg.sender;
220         uint amount = _available[account];
221         require(amount > 0 && _lastParticipatedPot[account] < potId, "BunnyPot: is not participant");
222         uint available = Math.min(maxAmount, amount);
223 
224         address[] memory winners = potHistoryOf(_lastParticipatedPot[account]).winners;
225         for (uint i = 0; i < winners.length; i++) {
226             if (winners[i] == account) {
227                 revert("BunnyPot: winner can't step to next");
228             }
229         }
230 
231         _participateCount[account] = _participateCount[account].add(1);
232         _currentUsers = _currentUsers.add(1);
233         _currentSupply = _currentSupply.add(available);
234         _lastParticipatedPot[account] = potId;
235         _depositedAt[account] = block.timestamp;
236 
237         bytes32 accountID = bytes32(uint256(account));
238 
239         uint weightCurrent = _calculateWeight(account);
240         _totalWeight = _totalWeight.add(weightCurrent);
241         setWeight(_getTreeKey(), weightCurrent, accountID);
242 
243         if (amount > available) {
244             uint diff = amount.sub(available);
245             _available[account] = available;
246             _totalSupply = _totalSupply.sub(diff);
247             IBunnyPool(_bunnyPool).withdraw(diff);
248             _stakingToken.safeTransfer(account, diff);
249         }
250     }
251 
252     function withdrawAll() public {
253         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
254         address account = msg.sender;
255         uint amount = _available[account];
256         require(amount > 0 && _lastParticipatedPot[account] < potId, "BunnyPot: is not participant");
257 
258         _totalSupply = _totalSupply.sub(amount);
259         delete _available[account];
260 
261         IBunnyPool(_bunnyPool).withdraw(amount);
262 
263         _stakingToken.safeTransfer(account, amount);
264 
265         emit Claimed(account, amount);
266     }
267 
268     function depositDonation(uint amount) public onlyWhitelisted {
269         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
270         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
271         _totalSupply = _totalSupply.add(amount);
272         _donateSupply = _donateSupply.add(amount);
273         _donation[msg.sender] = _donation[msg.sender].add(amount);
274 
275         IBunnyPool(_bunnyPool).deposit(amount);
276 
277         _harvest();
278     }
279 
280     function withdrawDonation() public onlyWhitelisted {
281         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
282         uint amount = _donation[msg.sender];
283         _totalSupply = _totalSupply.sub(amount);
284         _donateSupply = _donateSupply.sub(amount);
285         delete _donation[msg.sender];
286 
287         IBunnyPool(_bunnyPool).withdraw(amount);
288         _stakingToken.safeTransfer(msg.sender, amount);
289         _harvest();
290     }
291 
292     /* ========== RESTRICTED FUNCTIONS ========== */
293 
294     function setAmountMinMax(uint _min, uint _max) external onlyKeeper onlyValidState(PotConstant.PotState.Cooked) {
295         minAmount = _min;
296         maxAmount = _max;
297     }
298 
299     function openPot() external onlyKeeper onlyValidState(PotConstant.PotState.Cooked) {
300         state = PotConstant.PotState.Opened;
301         _overCook();
302 
303         potId = potId + 1;
304         startedAt = block.timestamp;
305 
306         _totalWeight = 0;
307         _currentSupply = 0;
308         _currentUsers = 0;
309         _totalHarvested = 0;
310 
311         _treeKey = bytes32(potId);
312         createTree(_getTreeKey());
313     }
314 
315     function closePot() external onlyKeeper onlyValidState(PotConstant.PotState.Opened) {
316         state = PotConstant.PotState.Closed;
317     }
318 
319     function overCook() external onlyKeeper onlyValidState(PotConstant.PotState.Closed) {
320         state = PotConstant.PotState.Cooked;
321         getRandomNumber(_totalWeight);
322     }
323 
324     function harvest() external onlyKeeper {
325         if (_totalSupply == 0) return;
326 
327         _harvest();
328     }
329 
330     function sweep() external onlyOwner {
331         uint balance = BUNNY.balanceOf(address(this));
332         if (balance > _totalSupply) {
333             BUNNY.safeTransfer(owner(), balance.sub(_totalSupply));
334         }
335 
336         uint balanceWBNB = WBNB.balanceOf(address(this));
337         if (balanceWBNB > 0) {
338             WBNB.safeTransfer(owner(), balanceWBNB);
339         }
340     }
341 
342     function setBurnRatio(uint _burnRatio) external onlyOwner {
343         require(_burnRatio <= 100, "BunnyPot: invalid range");
344         burnRatio = _burnRatio;
345     }
346 
347     function setBoostDuration(uint duration) external onlyOwner {
348         _boostDuration = duration;
349     }
350 
351     function setBunnyPool(address bunnyPool) external onlyOwner {
352         _stakingToken.approve(address(BUNNYPool), 0);
353         if (_bunnyPool != address(0)) {
354             _stakingToken.approve(address(_bunnyPool), 0);
355         }
356 
357         _bunnyPool = bunnyPool;
358 
359         _stakingToken.approve(_bunnyPool, uint(-1));
360         if (CAKE.allowance(address(this), address(ZapBSC)) == 0) {
361             CAKE.approve(address(ZapBSC), uint(-1));
362         }
363     }
364 
365     /* ========== PRIVATE FUNCTIONS ========== */
366 
367     function _harvest() private {
368         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
369         if (_totalSupply == 0) return;
370 
371         uint before = BUNNY.balanceOf(address(this));
372         uint beforeBNB = address(this).balance;
373         uint beforeCAKE = CAKE.balanceOf(address(this));
374 
375         IBunnyPool(_bunnyPool).getReward();
376 
377         uint amountIn = 0;
378         if (address(this).balance.sub(beforeBNB) > 0) {
379             amountIn = address(this).balance.sub(beforeBNB).mul(
380                 _currentSupply.add(_donateSupply).add(_totalHarvested)
381             ).div(_totalSupply);
382             ZapBSC.zapIn{value : amountIn}(address(BUNNY));
383         }
384 
385         if (CAKE.balanceOf(address(this)).sub(beforeCAKE) > 0) {
386             amountIn = CAKE.balanceOf(address(this)).sub(beforeCAKE).mul(
387                 _currentSupply.add(_donateSupply).add(_totalHarvested)
388             ).div(_totalSupply);
389             ZapBSC.zapInToken(address(CAKE), amountIn, address(BUNNY));
390         }
391 
392         uint harvested = BUNNY.balanceOf(address(this)).sub(before);
393         if (harvested == 0) return;
394 
395         _totalHarvested = _totalHarvested.add(harvested);
396         _totalSupply = _totalSupply.add(harvested);
397 
398         IBunnyPool(_bunnyPool).deposit(harvested);
399     }
400 
401     function _overCook() private {
402         require(_bunnyPool != address(0), "PotBunnyLover: BunnyPool must set");
403         if (_totalWeight == 0) return;
404 
405         uint buyback = _totalHarvested.mul(burnRatio).div(100);
406         _totalHarvested = _totalHarvested.sub(buyback);
407         uint winnerCount = Math.max(1, _totalHarvested.div(1000e18));
408 
409         if (buyback > 0) {
410             IBunnyPool(_bunnyPool).withdraw(buyback);
411             BUNNY.safeTransfer(TIMELOCK_ADDRESS, buyback);
412         }
413 
414         PotConstant.PotHistory memory history;
415         history.potId = potId;
416         history.users = _currentUsers;
417         history.rewardPerWinner = winnerCount > 0 ? _totalHarvested.div(winnerCount) : 0;
418         history.date = block.timestamp;
419         history.winners = new address[](winnerCount);
420 
421         for (uint i = 0; i < winnerCount; i++) {
422             uint rn = uint256(keccak256(abi.encode(_randomness, i))).mod(_totalWeight);
423             address selected = draw(_getTreeKey(), rn);
424 
425             _available[selected] = _available[selected].add(_totalHarvested.div(winnerCount));
426             history.winners[i] = selected;
427             delete _participateCount[selected];
428         }
429 
430         _histories[potId] = history;
431     }
432 
433     function _calculateWeight(address account) private view returns (uint) {
434         if (_depositedAt[account] < startedAt) return 0;
435 
436         uint wTime = _timeWeight(account);
437         uint wCount = _countWeight(account);
438         uint wValue = _valueWeight(account);
439         return wTime.mul(wCount).mul(wValue).div(100);
440     }
441 
442     function _timeWeight(address account) private view returns (uint) {
443         if (_depositedAt[account] < startedAt) return 0;
444 
445         uint timestamp = _depositedAt[account].sub(startedAt);
446         if (timestamp < _boostDuration) {
447             return 28;
448         } else if (timestamp < _boostDuration.mul(2)) {
449             return 24;
450         } else if (timestamp < _boostDuration.mul(3)) {
451             return 20;
452         } else if (timestamp < _boostDuration.mul(4)) {
453             return 16;
454         } else if (timestamp < _boostDuration.mul(5)) {
455             return 12;
456         } else {
457             return 8;
458         }
459     }
460 
461     function _countWeight(address account) private view returns (uint) {
462         uint count = _participateCount[account];
463         if (count >= 13) {
464             return 40;
465         } else if (count >= 9) {
466             return 30;
467         } else if (count >= 5) {
468             return 20;
469         } else {
470             return 10;
471         }
472     }
473 
474     function _valueWeight(address account) private view returns (uint) {
475         uint amount = _available[account];
476         uint denom = Math.max(minAmount, 1);
477         return Math.min(amount.mul(10).div(denom), maxAmount.mul(10).div(denom));
478     }
479 
480     function _getTreeKey() private view returns (bytes32) {
481         return _treeKey == bytes32(0) ? keccak256("Bunny/MultipleWinnerPot") : _treeKey;
482     }
483 
484     /* ========== MIGRATION ========== */
485 
486     function migrate() external onlyOwner {
487         require(_bunnyPool != address(0), "PotBunnyLover: must set BunnyPool");
488         uint before = BUNNY.balanceOf(address(this));
489         uint beforeWBNB = IBEP20(WBNB).balanceOf(address(this));
490 
491         BUNNYPool.withdrawAll();
492 
493         uint harvested = WBNB.balanceOf(address(this)).sub(beforeWBNB);
494         harvested = harvested.mul(_currentSupply.add(_donateSupply).add(_totalHarvested)).div(_totalSupply);
495 
496         ZapBSC.zapInToken(address(WBNB), harvested, address(BUNNY));
497         IBunnyPool(_bunnyPool).deposit(BUNNY.balanceOf(address(this)).sub(before));
498     }
499 }