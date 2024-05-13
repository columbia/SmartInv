1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
5 import { IUniswapV2Router } from "./interfaces/IUniswapV2Router.sol";
6 import { IERC20Token } from "./interfaces/IERC20Token.sol";
7 import { FundsRecovery } from "./FundsRecovery.sol";
8 import { Utils } from "./Utils.sol";
9 
10 interface IdentityRegistry {
11     function isRegistered(address _identity) external view returns (bool);
12     function minimalHermesStake() external view returns (uint256);
13     function getChannelAddress(address _identity, address _hermesId) external view returns (address);
14     function getBeneficiary(address _identity) external view returns (address);
15     function setBeneficiary(address _identity, address _newBeneficiary, bytes memory _signature) external;
16 }
17 
18 // Hermes (channel balance provided by Herms, no staking/loans)
19 contract HermesImplementation is FundsRecovery, Utils {
20     using ECDSA for bytes32;
21 
22     string constant STAKE_RETURN_PREFIX = "Stake return request";
23     uint256 constant DELAY_SECONDS = 259200;   // 3 days
24     uint256 constant UNIT_SECONDS = 3600;      // 1 unit = 1 hour = 3600 seconds
25     uint16 constant PUNISHMENT_PERCENT = 4;    // 0.04%
26 
27     IdentityRegistry internal registry;
28     address internal operator;                 // TODO have master operator who could change operator or manage funds
29 
30     uint256 internal totalStake;               // total amount staked by providers
31 
32     uint256 internal minStake;                 // minimal possible provider's stake (channel opening during promise settlement will use it)
33     uint256 internal maxStake;                 // maximal allowed provider's stake
34     uint256 internal hermesStake;              // hermes stake is used to prove hermes' sustainability
35     uint256 internal closingTimelock;          // blocknumber after which getting stake back will become possible
36     IUniswapV2Router internal dex;             // any uniswap v2 compatible dex router address
37 
38     enum Status { Active, Paused, Punishment, Closed } // hermes states
39     Status internal status;
40 
41     struct HermesFee {
42         uint16 value;                      // subprocent amount. e.g. 2.5% = 250
43         uint64 validFrom;                  // timestamp from which fee is valid
44     }
45     HermesFee public lastFee;              // default fee to look for
46     HermesFee public previousFee;          // previous fee is used if last fee is still not active
47 
48     // Our channel don't have balance, because we're always rebalancing into stake amount.
49     struct Channel {
50         uint256 settled;                   // total amount already settled by provider
51         uint256 stake;                     // amount staked by identity to guarante channel size, it also serves as channel balance
52         uint256 lastUsedNonce;             // last known nonce, is used to protect signature based calls from replay attack
53         uint256 timelock;                  // blocknumber after which channel balance can be decreased
54     }
55     mapping(bytes32 => Channel) public channels;
56 
57     struct Punishment {
58         uint256 activationBlockTime;       // block timestamp in which punishment was activated
59         uint256 amount;                    // total amount of tokens locked because of punishment
60     }
61     Punishment public punishment;
62 
63     function getOperator() public view returns (address) {
64         return operator;
65     }
66 
67     function getChannelId(address _identity) public view returns (bytes32) {
68         return keccak256(abi.encodePacked(_identity, address(this)));
69     }
70 
71     function getChannelId(address _identity, string memory _type) public view returns (bytes32) {
72         return keccak256(abi.encodePacked(_identity, address(this), _type));
73     }
74 
75     function getRegistry() public view returns (address) {
76         return address(registry);
77     }
78 
79     function getActiveFee() public view returns (uint256) {
80         HermesFee memory _activeFee = (block.timestamp >= lastFee.validFrom) ? lastFee : previousFee;
81         return uint256(_activeFee.value);
82     }
83 
84     function getHermesStake() public view returns (uint256) {
85         return hermesStake;
86     }
87 
88     function getStakeThresholds() public view returns (uint256, uint256) {
89         return (minStake, maxStake);
90     }
91 
92     // Returns hermes state
93     // Active - all operations are allowed.
94     // Paused - no new channel openings.
95     // Punishment - don't allow to open new channels, rebalance and withdraw funds.
96     // Closed - no new channels, no rebalance, no stake increase.
97     function getStatus() public view returns (Status) {
98         return status;
99     }
100 
101     event PromiseSettled(address indexed identity, bytes32 indexed channelId, address indexed beneficiary, uint256 amountSentToBeneficiary, uint256 fees, bytes32 lock);
102     event NewStake(bytes32 indexed channelId, uint256 stakeAmount);
103     event MinStakeValueUpdated(uint256 newMinStake);
104     event MaxStakeValueUpdated(uint256 newMaxStake);
105     event HermesFeeUpdated(uint16 newFee, uint64 validFrom);
106     event HermesClosed(uint256 blockTimestamp);
107     event ChannelOpeningPaused();
108     event ChannelOpeningActivated();
109     event FundsWithdrawned(uint256 amount, address beneficiary);
110     event HermesStakeIncreased(uint256 newStake);
111     event HermesPunishmentActivated(uint256 activationBlockTime);
112     event HermesPunishmentDeactivated();
113     event HermesStakeReturned(address beneficiary);
114 
115     /*
116       ------------------------------------------- SETUP -------------------------------------------
117     */
118 
119     // Because of proxy pattern this function is used insted of constructor.
120     // Have to be called right after proxy deployment.
121     function initialize(address _token, address _operator, uint16 _fee, uint256 _minStake, uint256 _maxStake, address payable _dexAddress) public virtual {
122         require(!isInitialized(), "Hermes: have to be not initialized");
123         require(_token != address(0), "Hermes: token can't be deployd into zero address");
124         require(_operator != address(0), "Hermes: operator have to be set");
125         require(_fee <= 5000, "Hermes: fee can't be bigger than 50%");
126         require(_maxStake > _minStake, "Hermes: maxStake have to be bigger than minStake");
127 
128         registry = IdentityRegistry(msg.sender);
129         token = IERC20Token(_token);
130         operator = _operator;
131         lastFee = HermesFee(_fee, uint64(block.timestamp));
132         minStake = _minStake;
133         maxStake = _maxStake;
134         hermesStake = token.balanceOf(address(this));
135 
136         // Approving all myst for dex, because MYST token's `transferFrom` is cheaper when there is approval of uint(-1)
137         token.approve(_dexAddress, type(uint256).max);
138         dex = IUniswapV2Router(_dexAddress);
139 
140         transferOwnership(_operator);
141     }
142 
143     function isInitialized() public view returns (bool) {
144         return operator != address(0);
145     }
146 
147     /*
148       -------------------------------------- MAIN FUNCTIONALITY -----------------------------------
149     */
150 
151     // Open incoming payments (also known as provider) channel. Can be called only by Registry.
152     function openChannel(address _identity, uint256 _amountToStake) public {
153         require(msg.sender == address(registry), "Hermes: only registry can open channels");
154         require(getStatus() == Status.Active, "Hermes: have to be in active state");
155         require(_amountToStake >= minStake, "Hermes: min stake amount not reached");
156         _increaseStake(getChannelId(_identity), _amountToStake, false);
157     }
158 
159     // Settle promise
160     // _preimage is random number generated by receiver used in HTLC
161     function _settlePromise(
162         bytes32 _channelId,
163         uint256 _amount,
164         uint256 _transactorFee,
165         bytes32 _preimage,
166         bytes memory _signature,
167         bool _takeFee,
168         bool _ignoreStake
169     ) private returns (uint256, uint256) {
170         require(
171             isHermesActive(),
172             "Hermes: hermes have to be in active state"
173         ); // if hermes is not active, then users can only take stake back
174         require(
175             validatePromise(_channelId, _amount, _transactorFee, _preimage, _signature),
176             "Hermes: have to be properly signed payment promise"
177         );
178 
179         Channel storage _channel = channels[_channelId];
180         require(_channel.settled > 0 || _channel.stake >= minStake || _ignoreStake, "Hermes: not enough stake");
181 
182         // If there are not enough funds to rebalance we have to enable punishment mode.
183         uint256 _availableBalance = availableBalance();
184         if (_availableBalance < _channel.stake) {
185             status = Status.Punishment;
186             punishment.activationBlockTime = block.timestamp;
187             emit HermesPunishmentActivated(block.timestamp);
188         }
189 
190         // Calculate amount of tokens to be claimed.
191         uint256 _unpaidAmount = _amount - _channel.settled;
192         require(_unpaidAmount > _transactorFee, "Hermes: amount to settle should cover transactor fee");
193 
194         // It is not allowed to settle more than maxStake / _channel.stake and than available balance.
195         uint256 _maxSettlementAmount = max(maxStake, _channel.stake);
196         if (_unpaidAmount > _availableBalance || _unpaidAmount > _maxSettlementAmount) {
197                _unpaidAmount = min(_availableBalance, _maxSettlementAmount);
198         }
199 
200         _channel.settled = _channel.settled + _unpaidAmount; // Increase already paid amount.
201         uint256 _fees = _transactorFee + (_takeFee ? calculateHermesFee(_unpaidAmount) : 0);
202 
203         // Pay transactor fee
204         if (_transactorFee > 0) {
205             token.transfer(msg.sender, _transactorFee);
206         }
207 
208         uint256 _amountToTransfer = _unpaidAmount -_fees;
209 
210         return (_amountToTransfer, _fees);
211     }
212 
213     function settlePromise(address _identity, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _signature) public {
214         address _beneficiary = registry.getBeneficiary(_identity);
215         require(_beneficiary != address(0), "Hermes: identity have to be registered, beneficiary have to be set");
216 
217         // Settle promise and transfer calculated amount into beneficiary wallet
218         bytes32 _channelId = getChannelId(_identity);
219         (uint256 _amountToTransfer, uint256 _fees) = _settlePromise(_channelId, _amount, _transactorFee, _preimage, _signature, true, false);
220         token.transfer(_beneficiary, _amountToTransfer);
221 
222         emit PromiseSettled(_identity, _channelId, _beneficiary, _amountToTransfer, _fees, _preimage);
223     }
224 
225     function payAndSettle(address _identity, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _signature, address _beneficiary, bytes memory _beneficiarySignature) public {
226         bytes32 _channelId = getChannelId(_identity, "withdrawal");
227 
228         // Validate beneficiary to be signed by identity and be attached to given promise
229         address _signer = keccak256(abi.encodePacked(getChainID(), _channelId, _amount, _preimage, _beneficiary)).recover(_beneficiarySignature);
230         require(_signer == _identity, "Hermes: payAndSettle request should be properly signed");
231 
232         (uint256 _amountToTransfer, uint256 _fees) = _settlePromise(_channelId, _amount, _transactorFee, _preimage, _signature, false, true);
233         token.transfer(_beneficiary, _amountToTransfer);
234 
235         emit PromiseSettled(_identity, _channelId, _beneficiary, _amountToTransfer, _fees, _preimage);
236     }
237 
238     function settleWithBeneficiary(address _identity, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _promiseSignature, address _newBeneficiary, bytes memory _beneficiarySignature) public {
239         // Update beneficiary address
240         registry.setBeneficiary(_identity, _newBeneficiary, _beneficiarySignature);
241 
242         // Settle promise and transfer calculated amount into beneficiary wallet
243         bytes32 _channelId = getChannelId(_identity);
244         (uint256 _amountToTransfer, uint256 _fees) = _settlePromise(_channelId, _amount, _transactorFee, _preimage, _promiseSignature, true, false);
245         token.transfer(_newBeneficiary, _amountToTransfer);
246 
247         emit PromiseSettled(_identity, _channelId, _newBeneficiary, _amountToTransfer, _fees, _preimage);
248     }
249 
250     function settleWithDEX(address _identity, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _signature) public {
251         address _beneficiary = registry.getBeneficiary(_identity);
252         require(_beneficiary != address(0), "Hermes: identity have to be registered, beneficiary have to be set");
253 
254         // Calculate amount to transfer and settle promise
255         bytes32 _channelId = getChannelId(_identity);
256         (uint256 _amountToTransfer, uint256 _fees) = _settlePromise(_channelId, _amount, _transactorFee, _preimage, _signature, true, false);
257 
258         // Transfer funds into beneficiary wallet via DEX
259         uint amountOutMin = 0;
260         address[] memory path = new address[](2);
261         path[0] = address(token);
262         path[1] = dex.WETH();
263 
264         dex.swapExactTokensForETH(_amountToTransfer, amountOutMin, path, _beneficiary, block.timestamp);
265 
266         emit PromiseSettled(_identity, _channelId, _beneficiary, _amountToTransfer, _fees, _preimage);
267     }
268 
269     /*
270       -------------------------------------- STAKE MANAGEMENT --------------------------------------
271     */
272 
273     function _increaseStake(bytes32 _channelId, uint256 _amountToAdd, bool _duringSettlement) internal {
274         Channel storage _channel = channels[_channelId];
275         uint256 _newStakeAmount = _channel.stake +_amountToAdd;
276         require(_newStakeAmount <= maxStake, "Hermes: total amount to stake can't be bigger than maximally allowed");
277         require(_newStakeAmount >= minStake, "Hermes: stake can't be less than required min stake");
278 
279         // We don't transfer tokens during settlements, they already locked in hermes contract.
280         if (!_duringSettlement) {
281             require(token.transferFrom(msg.sender, address(this), _amountToAdd), "Hermes: token transfer should succeed");
282         }
283 
284         _channel.stake = _newStakeAmount;
285         totalStake = totalStake + _amountToAdd;
286 
287         emit NewStake(_channelId, _newStakeAmount);
288     }
289 
290     // Anyone can increase channel's capacity by staking more into hermes
291     function increaseStake(bytes32 _channelId, uint256 _amount) public {
292         require(getStatus() != Status.Closed, "Hermes: should be not closed");
293         _increaseStake(_channelId, _amount, false);
294     }
295 
296     // Settlement which will increase channel stake instead of transfering funds into beneficiary wallet.
297     function settleIntoStake(address _identity, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _signature) public {
298         bytes32 _channelId = getChannelId(_identity);
299         (uint256 _stakeIncreaseAmount, uint256 _paidFees) = _settlePromise(_channelId, _amount, _transactorFee, _preimage, _signature, true, true);
300         emit PromiseSettled(_identity, _channelId, address(this), _stakeIncreaseAmount, _paidFees, _preimage);
301         _increaseStake(_channelId, _stakeIncreaseAmount, true);
302     }
303 
304     // Withdraw part of stake. This will also decrease channel balance.
305     function decreaseStake(address _identity, uint256 _amount, uint256 _transactorFee, bytes memory _signature) public {
306         bytes32 _channelId = getChannelId(_identity);
307         require(isChannelOpened(_channelId), "Hermes: channel has to be opened");
308         require(_amount >= _transactorFee, "Hermes: amount should be bigger than transactor fee");
309 
310         Channel storage _channel = channels[_channelId];
311         require(_amount <= _channel.stake, "Hermes: can't withdraw more than the current stake");
312 
313         // Verify signature
314         _channel.lastUsedNonce = _channel.lastUsedNonce + 1;
315         address _signer = keccak256(abi.encodePacked(STAKE_RETURN_PREFIX, getChainID(), _channelId, _amount, _transactorFee, _channel.lastUsedNonce)).recover(_signature);
316         require(getChannelId(_signer) == _channelId, "Hermes: have to be signed by channel party");
317 
318         uint256 _newStakeAmount = _channel.stake - _amount;
319         require(_newStakeAmount == 0 || _newStakeAmount >= minStake, "Hermes: stake can't be less than required min stake");
320 
321         // Update channel state
322         _channel.stake = _newStakeAmount;
323         totalStake = totalStake - _amount;
324 
325         // Pay transactor fee then withdraw the rest
326         if (_transactorFee > 0) {
327             token.transfer(msg.sender, _transactorFee);
328         }
329 
330         address _beneficiary = registry.getBeneficiary(_identity);
331         token.transfer(_beneficiary, _amount - _transactorFee);
332 
333         emit NewStake(_channelId, _newStakeAmount);
334     }
335 
336     /*
337       ---------------------------------------------------------------------------------------------
338     */
339 
340     // Hermes is in Emergency situation when its status is `Punishment`.
341     function resolveEmergency() public {
342         require(getStatus() == Status.Punishment, "Hermes: should be in punishment status");
343 
344         // No punishment during first time unit
345         uint256 _unit = getUnitTime();
346         uint256 _timePassed = block.timestamp - punishment.activationBlockTime;
347         uint256 _punishmentUnits = round(_timePassed, _unit) / _unit - 1;
348 
349         // Using 0.04% of total channels amount per time unit
350         uint256 _punishmentAmount = _punishmentUnits * round(totalStake * PUNISHMENT_PERCENT, 100) / 100;
351         punishment.amount = punishment.amount + _punishmentAmount;  // XXX alternativelly we could send tokens into BlackHole (0x0000000...)
352 
353         uint256 _shouldHave = minimalExpectedBalance() + maxStake;  // hermes should have funds for at least one maxStake settlement
354         uint256 _currentBalance = token.balanceOf(address(this));
355 
356         // If there are not enough available funds, they have to be topupped from msg.sender.
357         if (_currentBalance < _shouldHave) {
358             token.transferFrom(msg.sender, address(this), _shouldHave - _currentBalance);
359         }
360 
361         // Disable punishment mode
362         status = Status.Active;
363 
364         emit HermesPunishmentDeactivated();
365     }
366 
367     function getUnitTime() internal pure virtual returns (uint256) {
368         return UNIT_SECONDS;
369     }
370 
371     function setMinStake(uint256 _newMinStake) public onlyOwner {
372         require(isHermesActive(), "Hermes: has to be active");
373         require(_newMinStake < maxStake, "Hermes: minStake has to be smaller than maxStake");
374         minStake = _newMinStake;
375         emit MinStakeValueUpdated(_newMinStake);
376     }
377 
378     function setMaxStake(uint256 _newMaxStake) public onlyOwner {
379         require(isHermesActive(), "Hermes: has to be active");
380         require(_newMaxStake > minStake, "Hermes: maxStake has to be bigger than minStake");
381         maxStake = _newMaxStake;
382         emit MaxStakeValueUpdated(_newMaxStake);
383     }
384 
385     function setHermesFee(uint16 _newFee) public onlyOwner {
386         require(getStatus() != Status.Closed, "Hermes: should be not closed");
387         require(_newFee <= 5000, "Hermes: fee can't be bigger than 50%");
388         require(block.timestamp >= lastFee.validFrom, "Hermes: can't update inactive fee");
389 
390         // New fee will start be valid after delay time will pass
391         uint64 _validFrom = uint64(getTimelock());
392 
393         previousFee = lastFee;
394         lastFee = HermesFee(_newFee, _validFrom);
395 
396         emit HermesFeeUpdated(_newFee, _validFrom);
397     }
398 
399     function increaseHermesStake(uint256 _additionalStake) public onlyOwner {
400         if (availableBalance() < _additionalStake) {
401             uint256 _diff = _additionalStake - availableBalance();
402             token.transferFrom(msg.sender, address(this), _diff);
403         }
404 
405         hermesStake = hermesStake + _additionalStake;
406 
407         emit HermesStakeIncreased(hermesStake);
408     }
409 
410     // Hermes's available funds withdrawal. Can be done only if hermes is not closed and not in punishment mode.
411     // Hermes can't withdraw stake, locked in channel funds and funds lended to him.
412     function withdraw(address _beneficiary, uint256 _amount) public onlyOwner {
413         require(isHermesActive(), "Hermes: have to be active");
414         require(availableBalance() >= _amount, "Hermes: should be enough funds available to withdraw");
415 
416         token.transfer(_beneficiary, _amount);
417 
418         emit FundsWithdrawned(_amount, _beneficiary);
419     }
420 
421     // Returns funds amount not locked in any channel, not staked and not lended from providers.
422     function availableBalance() public view returns (uint256) {
423         uint256 _totalLockedAmount = minimalExpectedBalance();
424         uint256 _currentBalance = token.balanceOf(address(this));
425         if (_totalLockedAmount > _currentBalance) {
426             return uint256(0);
427         }
428         return _currentBalance - _totalLockedAmount;
429     }
430 
431     // Returns true if channel is opened.
432     function isChannelOpened(bytes32 _channelId) public view returns (bool) {
433         return channels[_channelId].settled != 0 || channels[_channelId].stake != 0;
434     }
435 
436     // If Hermes is not closed and is not in punishment mode, he is active.
437     function isHermesActive() public view returns (bool) {
438         Status _status = getStatus();
439         return _status != Status.Punishment && _status != Status.Closed;
440     }
441 
442     function pauseChannelOpening() public onlyOwner {
443         require(getStatus() == Status.Active, "Hermes: have to be in active state");
444         status = Status.Paused;
445         emit ChannelOpeningPaused();
446     }
447 
448     function activateChannelOpening() public onlyOwner {
449         require(getStatus() == Status.Paused, "Hermes: have to be in paused state");
450         status = Status.Active;
451         emit ChannelOpeningActivated();
452     }
453 
454     function closeHermes() public onlyOwner {
455         require(isHermesActive(), "Hermes: should be active");
456         status = Status.Closed;
457         closingTimelock = getEmergencyTimelock();
458         emit HermesClosed(block.timestamp);
459     }
460 
461     function getStakeBack(address _beneficiary) public onlyOwner {
462         require(getStatus() == Status.Closed, "Hermes: have to be closed");
463         require(block.timestamp > closingTimelock, "Hermes: timelock period should be already passed");
464 
465         uint256 _amount = token.balanceOf(address(this)) - punishment.amount;
466         token.transfer(_beneficiary, _amount);
467 
468         emit HermesStakeReturned(_beneficiary);
469     }
470 
471     /*
472       ------------------------------------------ HELPERS ------------------------------------------
473     */
474     // Returns timestamp until which exit request should be locked
475     function getTimelock() internal view virtual returns (uint256) {
476         return block.timestamp + DELAY_SECONDS;
477     }
478 
479     function calculateHermesFee(uint256 _amount) public view returns (uint256) {
480         return round((_amount * getActiveFee() / 100), 100) / 100;
481     }
482 
483     // Funds which always have to be holded in hermes smart contract.
484     function minimalExpectedBalance() public view returns (uint256) {
485         return max(hermesStake, punishment.amount) + totalStake;
486     }
487 
488     function getEmergencyTimelock() internal view virtual returns (uint256) {
489         return block.timestamp + DELAY_SECONDS * 100; // 300 days
490     }
491 
492     function validatePromise(bytes32 _channelId, uint256 _amount, uint256 _transactorFee, bytes32 _preimage, bytes memory _signature) public view returns (bool) {
493         bytes32 _hashlock = keccak256(abi.encodePacked(_preimage));
494         address _signer = keccak256(abi.encodePacked(getChainID(), _channelId, _amount, _transactorFee, _hashlock)).recover(_signature);
495         return _signer == operator;
496     }
497 }
