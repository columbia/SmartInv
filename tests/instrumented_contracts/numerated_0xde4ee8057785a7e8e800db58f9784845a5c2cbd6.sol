1 {{
2   "language": "Solidity",
3   "sources": {
4     "./Address.sol": {
5 	  "content": "// SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
32         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
33         // for accounts without code, i.e. `keccak256('')`
34         bytes32 codehash;
35         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { codehash := extcodehash(account) }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, \"Address: insufficient balance\");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }(\"\");
62         require(success, \"Address: unable to send value, recipient may have reverted\");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, \"Address: low-level call failed\");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, \"Address: insufficient balance for call\");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), \"Address: call to non-contract\");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 "
147     },
148     "./Context.sol": {
149 	  "content": "// SPDX-License-Identifier: MIT
150 
151 pragma solidity ^0.7.0;
152 
153 /*
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with GSN meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address payable) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes memory) {
169         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
170         return msg.data;
171     }
172 }
173 "
174     },
175     "./Dexe.sol": {
176 	  "content": "// SPDX-License-Identifier: MIT
177 pragma solidity 0.7.0;
178 pragma experimental ABIEncoderV2;
179 
180 import './Ownable.sol';
181 import './SafeMath.sol';
182 import './ERC20Burnable.sol';
183 
184 import './IPriceFeed.sol';
185 import './IDexe.sol';
186 
187 library ExtraMath {
188     using SafeMath for uint;
189 
190     function divCeil(uint _a, uint _b) internal pure returns(uint) {
191         if (_a.mod(_b) > 0) {
192             return (_a / _b).add(1);
193         }
194         return _a / _b;
195     }
196 
197     function toUInt8(uint _a) internal pure returns(uint8) {
198         require(_a <= uint8(-1), 'uint8 overflow');
199         return uint8(_a);
200     }
201 
202     function toUInt32(uint _a) internal pure returns(uint32) {
203         require(_a <= uint32(-1), 'uint32 overflow');
204         return uint32(_a);
205     }
206 
207     function toUInt120(uint _a) internal pure returns(uint120) {
208         require(_a <= uint120(-1), 'uint120 overflow');
209         return uint120(_a);
210     }
211 
212     function toUInt128(uint _a) internal pure returns(uint128) {
213         require(_a <= uint128(-1), 'uint128 overflow');
214         return uint128(_a);
215     }
216 }
217 
218 contract Dexe is Ownable, ERC20Burnable, IDexe {
219     using ExtraMath for *;
220     using SafeMath for *;
221 
222     uint private constant DEXE = 10**18;
223     uint private constant USDC = 10**6;
224     uint private constant USDT = 10**6;
225     uint private constant MONTH = 30 days;
226     uint public constant ROUND_SIZE_BASE = 190_476;
227     uint public constant ROUND_SIZE = ROUND_SIZE_BASE * DEXE;
228     uint public constant FIRST_ROUND_SIZE_BASE = 1_000_000;
229 
230 
231     IERC20 public usdcToken;
232     IERC20 public usdtToken;
233     IPriceFeed public usdtPriceFeed; // Provides USDC per 1 * USDT
234     IPriceFeed public dexePriceFeed; // Provides USDC per 1 * DEXE
235     IPriceFeed public ethPriceFeed; // Provides USDC per 1 * ETH
236 
237     // Deposits are immediately transferred here.
238     address payable public treasury;
239 
240     enum LockType {
241         Staking,
242         Foundation,
243         Team,
244         Partnership,
245         School,
246         Marketing
247     }
248 
249     enum ForceReleaseType {
250         X7,
251         X10,
252         X15,
253         X20
254     }
255 
256     struct LockConfig {
257         uint32 releaseStart;
258         uint32 vesting;
259     }
260 
261     struct Lock {
262         uint128 balance; // Total locked.
263         uint128 released; // Released so far.
264     }
265 
266     uint public averagePrice; // 2-10 rounds average.
267     uint public override launchedAfter; // How many seconds passed between sale end and product launch.
268 
269     mapping(uint => mapping(address => HolderRound)) internal _holderRounds;
270     mapping(address => UserInfo) internal _usersInfo;
271     mapping(address => BalanceInfo) internal _balanceInfo;
272 
273     mapping(LockType => LockConfig) public lockConfigs;
274     mapping(LockType => mapping(address => Lock)) public locks;
275 
276     mapping(address => mapping(ForceReleaseType => bool)) public forceReleased;
277 
278     uint constant ROUND_DURATION_SEC = 86400;
279     uint constant TOTAL_ROUNDS = 22;
280 
281     struct Round {
282         uint120 totalDeposited; // USDC
283         uint128 roundPrice; // USDC per 1 * DEXE
284     }
285 
286     mapping(uint => Round) public rounds; // Indexes are 1-22.
287 
288     // Sunday, September 28, 2020 12:00:00 PM GMT
289     uint public constant tokensaleStartDate = 1601294400;
290     uint public override constant tokensaleEndDate = tokensaleStartDate + ROUND_DURATION_SEC * TOTAL_ROUNDS;
291 
292     event NoteDeposit(address sender, uint value, bytes data);
293     event Note(address sender, bytes data);
294 
295     modifier noteDeposit() {
296         emit NoteDeposit(_msgSender(), msg.value, msg.data);
297         _;
298     }
299 
300     modifier note() {
301         emit Note(_msgSender(), msg.data);
302         _;
303     }
304 
305     constructor(address _distributor) ERC20('Dexe', 'DEXE') {
306         _mint(address(this), 99_000_000 * DEXE);
307 
308         // Market Liquidity Fund.
309         _mint(_distributor, 1_000_000 * DEXE);
310 
311         // Staking rewards are locked on the Dexe itself.
312         locks[LockType.Staking][address(this)].balance = 10_000_000.mul(DEXE).toUInt128();
313 
314         locks[LockType.Foundation][_distributor].balance = 33_000_000.mul(DEXE).toUInt128();
315         locks[LockType.Team][_distributor].balance = 20_000_000.mul(DEXE).toUInt128();
316         locks[LockType.Partnership][_distributor].balance = 16_000_000.mul(DEXE).toUInt128();
317         locks[LockType.School][_distributor].balance = 10_000_000.mul(DEXE).toUInt128();
318         locks[LockType.Marketing][_distributor].balance = 5_000_000.mul(DEXE).toUInt128();
319 
320         lockConfigs[LockType.Staking].releaseStart = (tokensaleEndDate).toUInt32();
321         lockConfigs[LockType.Staking].vesting = (365 days).toUInt32();
322 
323         lockConfigs[LockType.Foundation].releaseStart = (tokensaleEndDate + 365 days).toUInt32();
324         lockConfigs[LockType.Foundation].vesting = (1460 days).toUInt32();
325 
326         lockConfigs[LockType.Team].releaseStart = (tokensaleEndDate + 180 days).toUInt32();
327         lockConfigs[LockType.Team].vesting = (730 days).toUInt32();
328 
329         lockConfigs[LockType.Partnership].releaseStart = (tokensaleEndDate + 90 days).toUInt32();
330         lockConfigs[LockType.Partnership].vesting = (365 days).toUInt32();
331 
332         lockConfigs[LockType.School].releaseStart = (tokensaleEndDate + 60 days).toUInt32();
333         lockConfigs[LockType.School].vesting = (365 days).toUInt32();
334 
335         lockConfigs[LockType.Marketing].releaseStart = (tokensaleEndDate + 30 days).toUInt32();
336         lockConfigs[LockType.Marketing].vesting = (365 days).toUInt32();
337 
338         treasury = payable(_distributor);
339     }
340 
341     function setUSDTTokenAddress(IERC20 _address) external onlyOwner() note() {
342         usdtToken = _address;
343     }
344 
345     function setUSDCTokenAddress(IERC20 _address) external onlyOwner() note() {
346         usdcToken = _address;
347     }
348 
349     function setUSDTFeed(IPriceFeed _address) external onlyOwner() note() {
350         usdtPriceFeed = _address;
351     }
352 
353     function setDEXEFeed(IPriceFeed _address) external onlyOwner() note() {
354         dexePriceFeed = _address;
355     }
356 
357     function setETHFeed(IPriceFeed _address) external onlyOwner() note() {
358         ethPriceFeed = _address;
359     }
360 
361     function setTreasury(address payable _address) external onlyOwner() note() {
362         require(_address != address(0), 'Not zero address required');
363 
364         treasury = _address;
365     }
366 
367     function addToWhitelist(address _address, uint _limit) external onlyOwner() note() {
368         _updateWhitelist(_address, _limit);
369     }
370 
371     function removeFromWhitelist(address _address) external onlyOwner() note() {
372         _updateWhitelist(_address, 0);
373     }
374 
375     function _updateWhitelist(address _address, uint _limit) private {
376         _usersInfo[_address].firstRoundLimit = _limit.toUInt120();
377     }
378 
379     // For UI purposes.
380     function getAllRounds() external view returns(Round[22] memory) {
381         Round[22] memory _result;
382         for (uint i = 1; i <= 22; i++) {
383             _result[i-1] = rounds[i];
384         }
385         return _result;
386     }
387 
388     // For UI purposes.
389     function getFullHolderInfo(address _holder) external view
390     returns(
391         UserInfo memory _info,
392         HolderRound[22] memory _rounds,
393         Lock[6] memory _locks,
394         bool _isWhitelisted,
395         bool[4] memory _forceReleases,
396         uint _balance
397     ) {
398         _info = _usersInfo[_holder];
399         for (uint i = 1; i <= 22; i++) {
400             _rounds[i-1] = _holderRounds[i][_holder];
401         }
402         for (uint i = 0; i < 6; i++) {
403             _locks[i] = locks[LockType(i)][_holder];
404         }
405         _isWhitelisted = _usersInfo[_holder].firstRoundLimit > 0;
406         for (uint i = 0; i < 4; i++) {
407             _forceReleases[i] = forceReleased[_holder][ForceReleaseType(i)];
408         }
409         _balance = balanceOf(_holder);
410         return (_info, _rounds, _locks, _isWhitelisted, _forceReleases, _balance);
411     }
412 
413     // Excludes possibility of unexpected price change.
414     function prepareDistributionPrecise(uint _round, uint _botPriceLimit, uint _topPriceLimit)
415     external onlyOwner() note() {
416         uint _currentPrice = updateAndGetCurrentPrice();
417         require(_botPriceLimit <= _currentPrice && _currentPrice <= _topPriceLimit,
418            'Price is out of range');
419 
420         _prepareDistribution(_round);
421     }
422 
423     // Should be performed in the last hour of every round.
424     function prepareDistribution(uint _round) external onlyOwner() note() {
425         _prepareDistribution(_round);
426     }
427 
428     function _prepareDistribution(uint _round) private {
429         require(isRoundDepositsEnded(_round),
430             'Deposit round not ended');
431 
432         Round memory _localRound = rounds[_round];
433         require(_localRound.roundPrice == 0, 'Round already prepared');
434         require(_round > 0 && _round < 23, 'Round is not valid');
435 
436         if (_round == 1) {
437             _localRound.roundPrice = _localRound.totalDeposited.divCeil(FIRST_ROUND_SIZE_BASE).toUInt128();
438 
439             // If nobody deposited.
440             if (_localRound.roundPrice == 0) {
441                 _localRound.roundPrice = 1;
442             }
443             rounds[_round].roundPrice = _localRound.roundPrice;
444             return;
445         }
446 
447         require(isRoundPrepared(_round.sub(1)), 'Previous round not prepared');
448 
449         uint _localRoundPrice = updateAndGetCurrentPrice();
450         uint _totalTokensSold = _localRound.totalDeposited.mul(DEXE) / _localRoundPrice;
451 
452         if (_totalTokensSold < ROUND_SIZE) {
453             // Apply 0-10% discount based on how much tokens left. Empty round applies 10% discount.
454             _localRound.roundPrice =
455                 (uint(9).mul(ROUND_SIZE_BASE).mul(_localRoundPrice).add(_localRound.totalDeposited)).divCeil(
456                 uint(10).mul(ROUND_SIZE_BASE)).toUInt128();
457             uint _discountedTokensSold = _localRound.totalDeposited.mul(DEXE) / _localRound.roundPrice;
458 
459             rounds[_round].roundPrice = _localRound.roundPrice;
460             _burn(address(this), ROUND_SIZE.sub(_discountedTokensSold));
461         } else {
462             // Round overflown, calculate price based on even spread of available tokens.
463             rounds[_round].roundPrice = _localRound.totalDeposited.divCeil(ROUND_SIZE_BASE).toUInt128();
464         }
465 
466         if (_round == 10) {
467             uint _averagePrice;
468             for (uint i = 2; i <= 10; i++) {
469                 _averagePrice = _averagePrice.add(rounds[i].roundPrice);
470             }
471 
472             averagePrice = _averagePrice / 9;
473         }
474     }
475 
476     // Receive tokens/rewards for all processed rounds.
477     function receiveAll() public {
478         _receiveAll(_msgSender());
479     }
480 
481     function _receiveAll(address _holder) private {
482         // Holder received everything.
483         if (_holderRounds[TOTAL_ROUNDS][_holder].status == HolderRoundStatus.Received) {
484             return;
485         }
486 
487         // Holder didn't participate in the sale.
488         if (_usersInfo[_holder].firstRoundDeposited == 0) {
489             return;
490         }
491 
492         if (_notPassed(tokensaleStartDate)) {
493             return;
494         }
495 
496         uint _currentRound = currentRound();
497 
498         for (uint i = _usersInfo[_holder].firstRoundDeposited; i < _currentRound; i++) {
499             // Skip received rounds.
500             if (_holderRounds[i][_holder].status == HolderRoundStatus.Received) {
501                 continue;
502             }
503 
504             Round memory _localRound = rounds[i];
505             require(_localRound.roundPrice > 0, 'Round is not prepared');
506 
507             _holderRounds[i][_holder].status = HolderRoundStatus.Received;
508             _receiveDistribution(i, _holder, _localRound);
509             _receiveRewards(i, _holder, _localRound);
510         }
511     }
512 
513     // Receive tokens based on the deposit.
514     function _receiveDistribution(uint _round, address _holder, Round memory _localRound) private {
515         HolderRound memory _holderRound = _holderRounds[_round][_holder];
516         uint _balance = _holderRound.deposited.mul(DEXE) / _localRound.roundPrice;
517 
518         uint _endBalance = _holderRound.endBalance.add(_balance);
519         _holderRounds[_round][_holder].endBalance = _endBalance.toUInt128();
520         if (_round < TOTAL_ROUNDS) {
521             _holderRounds[_round.add(1)][_holder].endBalance =
522                 _holderRounds[_round.add(1)][_holder].endBalance.add(_endBalance).toUInt128();
523         }
524         _transfer(address(this), _holder, _balance);
525     }
526 
527     // Receive rewards based on the last round balance, participation in 1st round and this round fill.
528     function _receiveRewards(uint _round, address _holder, Round memory _localRound) private {
529         if (_round > 21) {
530             return;
531         }
532         HolderRound memory _holderRound = _holderRounds[_round][_holder];
533 
534         uint _reward;
535         if (_round == 1) {
536             // First round is always 5%.
537             _reward = (_holderRound.endBalance).mul(5) / 100;
538         } else {
539             uint _x2 = 1;
540             uint _previousRoundBalance = _holderRounds[_round.sub(1)][_holder].endBalance;
541 
542             // Double reward if increased balance since last round by 1%+.
543             if (_previousRoundBalance > 0 &&
544                 (_previousRoundBalance.mul(101) / 100) < _holderRound.endBalance)
545             {
546                 _x2 = 2;
547             }
548 
549             uint _roundPrice = _localRound.roundPrice;
550             uint _totalDeposited = _localRound.totalDeposited;
551             uint _holderBalance = _holderRound.endBalance;
552             uint _minPercent = 2;
553             uint _maxBonusPercent = 6;
554             if (_holderRounds[1][_holder].endBalance > 0) {
555                 _minPercent = 5;
556                 _maxBonusPercent = 15;
557             }
558             // Apply reward modifiers in the following way:
559             // 1. If participated in round 1, then the base is 5%, otherwise 2%.
560             // 2. Depending on the round fill 0-100% get extra 15-0% (round 1 participants) or 6-0%.
561             // 3. Double reward if increased balance since last round by 1%+.
562             _reward = _minPercent.add(_maxBonusPercent).mul(_roundPrice).mul(ROUND_SIZE_BASE)
563                 .sub(_maxBonusPercent.mul(_totalDeposited)).mul(_holderBalance).mul(_x2) /
564                 100.mul(_roundPrice).mul(ROUND_SIZE_BASE);
565         }
566 
567         uint _rewardsLeft = locks[LockType.Staking][address(this)].balance;
568         // If not enough left, give everything.
569         if (_rewardsLeft < _reward) {
570             _reward = _rewardsLeft;
571         }
572 
573         locks[LockType.Staking][_holder].balance =
574             locks[LockType.Staking][_holder].balance.add(_reward).toUInt128();
575         locks[LockType.Staking][address(this)].balance = _rewardsLeft.sub(_reward).toUInt128();
576     }
577 
578     function depositUSDT(uint _amount) external note() {
579         usdtToken.transferFrom(_msgSender(), treasury, _amount);
580         uint _usdcAmount = _amount.mul(usdtPriceFeed.updateAndConsult()) / USDT;
581         _deposit(_usdcAmount);
582     }
583 
584     function depositETH() payable external noteDeposit() {
585         _depositETH();
586     }
587 
588     receive() payable external noteDeposit() {
589         _depositETH();
590     }
591 
592     function _depositETH() private {
593         treasury.transfer(msg.value);
594         uint _usdcAmount = msg.value.mul(ethPriceFeed.updateAndConsult()) / 1 ether;
595         _deposit(_usdcAmount);
596     }
597 
598     function depositUSDC(uint _amount) external note() {
599         usdcToken.transferFrom(_msgSender(), treasury, _amount);
600         _deposit(_amount);
601     }
602 
603     function _deposit(uint _amount) private {
604         uint _depositRound = depositRound();
605         uint _newDeposited = _holderRounds[_depositRound][_msgSender()].deposited.add(_amount);
606         uint _limit = _usersInfo[_msgSender()].firstRoundLimit;
607         if (_depositRound == 1) {
608             require(_limit > 0, 'Not whitelisted');
609             require(_newDeposited <= _limit, 'Deposit limit is reached');
610         }
611         require(_amount >= 1 * USDC, 'Less than minimum amount 1 usdc');
612 
613         _holderRounds[_depositRound][_msgSender()].deposited = _newDeposited.toUInt120();
614 
615         rounds[_depositRound].totalDeposited = rounds[_depositRound].totalDeposited.add(_amount).toUInt120();
616 
617         if (_usersInfo[_msgSender()].firstRoundDeposited == 0) {
618             _usersInfo[_msgSender()].firstRoundDeposited = _depositRound.toUInt8();
619         }
620     }
621 
622     // In case someone will send USDC/USDT/SomeToken directly.
623     function withdrawLocked(IERC20 _token, address _receiver, uint _amount) external onlyOwner() note() {
624         require(address(_token) != address(this), 'Cannot withdraw this');
625         _token.transfer(_receiver, _amount);
626     }
627 
628     function currentRound() public view returns(uint) {
629         require(_passed(tokensaleStartDate), 'Tokensale not started yet');
630         if (_passed(tokensaleEndDate)) {
631             return 23;
632         }
633 
634         return _since(tokensaleStartDate).divCeil(ROUND_DURATION_SEC);
635     }
636 
637     // Deposit round ends 1 hour before the end of each round.
638     function depositRound() public view returns(uint) {
639         require(_passed(tokensaleStartDate), 'Tokensale not started yet');
640         require(_notPassed(tokensaleEndDate.sub(1 hours)), 'Deposits ended');
641 
642         return _since(tokensaleStartDate).add(1 hours).divCeil(ROUND_DURATION_SEC);
643     }
644 
645     function isRoundDepositsEnded(uint _round) public view returns(bool) {
646         return _passed(ROUND_DURATION_SEC.mul(_round).add(tokensaleStartDate).sub(1 hours));
647     }
648 
649     function isRoundPrepared(uint _round) public view returns(bool) {
650         return rounds[_round].roundPrice > 0;
651     }
652 
653     function currentPrice() public view returns(uint) {
654         return dexePriceFeed.consult();
655     }
656 
657     function updateAndGetCurrentPrice() public returns(uint) {
658         return dexePriceFeed.updateAndConsult();
659     }
660 
661     function _passed(uint _time) private view returns(bool) {
662         return block.timestamp > _time;
663     }
664 
665     function _notPassed(uint _time) private view returns(bool) {
666         return _not(_passed(_time));
667     }
668 
669     function _not(bool _condition) private pure returns(bool) {
670         return !_condition;
671     }
672 
673     // Get released tokens to the main balance.
674     function releaseLock(LockType _lock) external note() {
675         _release(_lock, _msgSender());
676     }
677 
678     // Assign locked tokens to another holder.
679     function transferLock(LockType _lockType, address _to, uint _amount) external note() {
680         receiveAll();
681         Lock memory _lock = locks[_lockType][_msgSender()];
682         require(_lock.released == 0, 'Cannot transfer after release');
683         require(_lock.balance >= _amount, 'Insuffisient locked funds');
684 
685         locks[_lockType][_msgSender()].balance = _lock.balance.sub(_amount).toUInt128();
686         locks[_lockType][_to].balance = locks[_lockType][_to].balance.add(_amount).toUInt128();
687     }
688 
689     function _release(LockType _lockType, address _holder) private {
690         LockConfig memory _lockConfig = lockConfigs[_lockType];
691         require(_passed(_lockConfig.releaseStart),
692             'Releasing has no started yet');
693 
694         Lock memory _lock = locks[_lockType][_holder];
695         uint _balance = _lock.balance;
696         uint _released = _lock.released;
697 
698         uint _balanceToRelease =
699             _balance.mul(_since(_lockConfig.releaseStart)) / _lockConfig.vesting;
700 
701         // If more than enough time already passed, release what is left.
702         if (_balanceToRelease > _balance) {
703             _balanceToRelease = _balance;
704         }
705 
706         require(_balanceToRelease > _released, 'Insufficient unlocked');
707 
708         // Underflow cannot happen here, SafeMath usage left for code style.
709         uint _amount = _balanceToRelease.sub(_released);
710 
711         locks[_lockType][_holder].released = _balanceToRelease.toUInt128();
712         _transfer(address(this), _holder, _amount);
713     }
714 
715 
716     // Wrap call to updateAndGetCurrentPrice() function before froceReleaseStaking on UI to get
717     // most up-to-date price.
718     // In case price increased enough since average, allow holders to release Staking rewards with a fee.
719     function forceReleaseStaking(ForceReleaseType _forceReleaseType) external note() {
720         uint _currentRound = currentRound();
721         require(_currentRound > 10, 'Only after 10 round');
722         receiveAll();
723         Lock memory _lock = locks[LockType.Staking][_msgSender()];
724         require(_lock.balance > 0, 'Nothing to force unlock');
725 
726         uint _priceMul;
727         uint _unlockedPart;
728         uint _receivedPart;
729 
730         if (_forceReleaseType == ForceReleaseType.X7) {
731             _priceMul = 7;
732             _unlockedPart = 10;
733             _receivedPart = 86;
734         } else if (_forceReleaseType == ForceReleaseType.X10) {
735             _priceMul = 10;
736             _unlockedPart = 15;
737             _receivedPart = 80;
738         } else if (_forceReleaseType == ForceReleaseType.X15) {
739             _priceMul = 15;
740             _unlockedPart = 20;
741             _receivedPart = 70;
742         } else {
743             _priceMul = 20;
744             _unlockedPart = 30;
745             _receivedPart = 60;
746         }
747 
748         require(_not(forceReleased[_msgSender()][_forceReleaseType]), 'Already force released');
749 
750         forceReleased[_msgSender()][_forceReleaseType] = true;
751 
752         require(updateAndGetCurrentPrice() >= averagePrice.mul(_priceMul), 'Current price is too small');
753 
754         uint _balance = _lock.balance.sub(_lock.released);
755 
756         uint _released = _balance.mul(_unlockedPart) / 100;
757         uint _receiveAmount = _released.mul(_receivedPart) / 100;
758         uint _burned = _released.sub(_receiveAmount);
759 
760         locks[LockType.Staking][_msgSender()].released = _lock.released.add(_released).toUInt128();
761 
762         if (_currentRound <= TOTAL_ROUNDS) {
763             _holderRounds[_currentRound][_msgSender()].endBalance =
764                 _holderRounds[_currentRound][_msgSender()].endBalance.add(_receiveAmount).toUInt128();
765         }
766         _burn(address(this), _burned);
767         _transfer(address(this), _msgSender(), _receiveAmount);
768     }
769 
770     function launchProduct() external onlyOwner() note() {
771         require(_passed(tokensaleEndDate), 'Tokensale is not ended yet');
772         require(launchedAfter == 0, 'Product already launched');
773         require(isTokensaleProcessed(), 'Tokensale is not processed');
774 
775         launchedAfter = _since(tokensaleEndDate);
776     }
777 
778     function isTokensaleProcessed() private view returns(bool) {
779         return rounds[TOTAL_ROUNDS].roundPrice > 0;
780     }
781 
782     // Zero address and Dexe itself are not considered as valid holders.
783     function _isHolder(address _addr) private view returns(bool) {
784         if (_addr == address(this) || _addr == address(0)) {
785             return false;
786         }
787         return true;
788     }
789 
790     // Happen before every transfer to update all the metrics.
791     function _beforeTokenTransfer(address _from, address _to, uint _amount) internal override {
792         if (_isHolder(_from)) {
793             // Automatically receive tokens/rewards for previous rounds.
794             _receiveAll(_from);
795         }
796 
797         if (_notPassed(tokensaleEndDate)) {
798             uint _round = 1;
799             if (_passed(tokensaleStartDate)) {
800                 _round = currentRound();
801             }
802 
803             if (_isHolder(_from)) {
804                 _holderRounds[_round][_from].endBalance =
805                     _holderRounds[_round][_from].endBalance.sub(_amount).toUInt128();
806             }
807             if (_isHolder(_to)) {
808                 UserInfo memory _userToInfo = _usersInfo[_to];
809                 if (_userToInfo.firstRoundDeposited == 0) {
810                     _usersInfo[_to].firstRoundDeposited = _round.toUInt8();
811                 }
812                 if (_from != address(this)) {
813                     _holderRounds[_round][_to].endBalance =
814                         _holderRounds[_round][_to].endBalance.add(_amount).toUInt128();
815                 }
816             }
817         }
818 
819         if (launchedAfter == 0) {
820             if (_isHolder(_from)) {
821                 _usersInfo[_from].balanceBeforeLaunch = _usersInfo[_from].balanceBeforeLaunch.sub(_amount).toUInt128();
822             }
823             if (_isHolder(_to)) {
824                 _usersInfo[_to].balanceBeforeLaunch = _usersInfo[_to].balanceBeforeLaunch.add(_amount).toUInt128();
825                 if (_balanceInfo[_to].firstBalanceChange == 0) {
826                     _balanceInfo[_to].firstBalanceChange = block.timestamp.toUInt32();
827                     _balanceInfo[_to].lastBalanceChange = block.timestamp.toUInt32();
828                 }
829             }
830         }
831         _updateBalanceAverage(_from);
832         _updateBalanceAverage(_to);
833     }
834 
835     function _since(uint _timestamp) private view returns(uint) {
836         return block.timestamp.sub(_timestamp);
837     }
838 
839     function launchDate() public override view returns(uint) {
840         uint _launchedAfter = launchedAfter;
841         if (_launchedAfter == 0) {
842             return 0;
843         }
844         return tokensaleEndDate.add(_launchedAfter);
845     }
846 
847     function _calculateBalanceAverage(address _holder) private view returns(BalanceInfo memory) {
848         BalanceInfo memory _user = _balanceInfo[_holder];
849         if (!_isHolder(_holder)) {
850             return _user;
851         }
852 
853         uint _lastBalanceChange = _user.lastBalanceChange;
854         uint _balance = balanceOf(_holder);
855         uint _launchDate = launchDate();
856         bool _notLaunched = _launchDate == 0;
857         uint _accumulatorTillNow = _user.balanceAccumulator
858             .add(_balance.mul(_since(_lastBalanceChange)));
859 
860         if (_notLaunched) {
861             // Last update happened in the current before launch period.
862             _user.balanceAccumulator = _accumulatorTillNow;
863             _user.balanceAverage = (_accumulatorTillNow /
864                 _since(_user.firstBalanceChange)).toUInt128();
865             _user.lastBalanceChange = block.timestamp.toUInt32();
866             return _user;
867         }
868 
869         // Calculating the end of the last average period.
870         uint _timeEndpoint = _since(_launchDate).div(MONTH).mul(MONTH).add(_launchDate);
871         if (_lastBalanceChange >= _timeEndpoint) {
872             // Last update happened in the current average period.
873             _user.balanceAccumulator = _accumulatorTillNow;
874         } else {
875             // Last update happened before the current average period.
876             uint _sinceLastBalanceChangeToEndpoint = _timeEndpoint.sub(_lastBalanceChange);
877             uint _accumulatorAtTheEndpoint = _user.balanceAccumulator
878                 .add(_balance.mul(_sinceLastBalanceChangeToEndpoint));
879 
880             if (_timeEndpoint == _launchDate) {
881                 // Last update happened before the launch period.
882                 _user.balanceAverage = (_accumulatorAtTheEndpoint /
883                     _timeEndpoint.sub(_user.firstBalanceChange)).toUInt128();
884             } else if (_sinceLastBalanceChangeToEndpoint <= MONTH) {
885                 // Last update happened in the previous average period.
886                 _user.balanceAverage = (_accumulatorAtTheEndpoint / MONTH).toUInt128();
887             } else {
888                 // Last update happened before the previous average period.
889                 _user.balanceAverage = _balance.toUInt128();
890             }
891 
892             _user.balanceAccumulator = _balance.mul(_since(_timeEndpoint));
893         }
894 
895         _user.lastBalanceChange = block.timestamp.toUInt32();
896         return _user;
897     }
898 
899     function _updateBalanceAverage(address _holder) private {
900         if (_balanceInfo[_holder].lastBalanceChange == block.timestamp) {
901             return;
902         }
903         _balanceInfo[_holder] = _calculateBalanceAverage(_holder);
904     }
905 
906     function getAverageBalance(address _holder) external override view returns(uint) {
907         return _calculateBalanceAverage(_holder).balanceAverage;
908     }
909 
910     function firstBalanceChange(address _holder) external override view returns(uint) {
911         return _balanceInfo[_holder].firstBalanceChange;
912     }
913 
914     function holderRounds(uint _round, address _holder) external override view returns(
915         HolderRound memory
916     ) {
917         return _holderRounds[_round][_holder];
918     }
919 
920     function usersInfo(address _holder) external override view returns(
921         UserInfo memory
922     ) {
923         return _usersInfo[_holder];
924     }
925 }
926 "
927     },
928 	"./ERC20.sol": {
929 	  "content": "// SPDX-License-Identifier: MIT
930 
931 pragma solidity ^0.7.0;
932 
933 import \"./Context.sol\";
934 import \"./IERC20.sol\";
935 import \"./SafeMath.sol\";
936 import \"./Address.sol\";
937 
938 /**
939  * @dev Implementation of the {IERC20} interface.
940  *
941  * This implementation is agnostic to the way tokens are created. This means
942  * that a supply mechanism has to be added in a derived contract using {_mint}.
943  * For a generic mechanism see {ERC20PresetMinterPauser}.
944  *
945  * TIP: For a detailed writeup see our guide
946  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
947  * to implement supply mechanisms].
948  *
949  * We have followed general OpenZeppelin guidelines: functions revert instead
950  * of returning `false` on failure. This behavior is nonetheless conventional
951  * and does not conflict with the expectations of ERC20 applications.
952  *
953  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
954  * This allows applications to reconstruct the allowance for all accounts just
955  * by listening to said events. Other implementations of the EIP may not emit
956  * these events, as it isn't required by the specification.
957  *
958  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
959  * functions have been added to mitigate the well-known issues around setting
960  * allowances. See {IERC20-approve}.
961  */
962 contract ERC20 is Context, IERC20 {
963     using SafeMath for uint256;
964     using Address for address;
965 
966     mapping (address => uint256) private _balances;
967 
968     mapping (address => mapping (address => uint256)) private _allowances;
969 
970     uint256 private _totalSupply;
971 
972     string private _name;
973     string private _symbol;
974     uint8 private _decimals;
975 
976     /**
977      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
978      * a default value of 18.
979      *
980      * To select a different value for {decimals}, use {_setupDecimals}.
981      *
982      * All three of these values are immutable: they can only be set once during
983      * construction.
984      */
985     constructor (string memory name, string memory symbol) {
986         _name = name;
987         _symbol = symbol;
988         _decimals = 18;
989     }
990 
991     /**
992      * @dev Returns the name of the token.
993      */
994     function name() public view returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev Returns the symbol of the token, usually a shorter version of the
1000      * name.
1001      */
1002     function symbol() public view returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev Returns the number of decimals used to get its user representation.
1008      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1009      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1010      *
1011      * Tokens usually opt for a value of 18, imitating the relationship between
1012      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1013      * called.
1014      *
1015      * NOTE: This information is only used for _display_ purposes: it in
1016      * no way affects any of the arithmetic of the contract, including
1017      * {IERC20-balanceOf} and {IERC20-transfer}.
1018      */
1019     function decimals() public view returns (uint8) {
1020         return _decimals;
1021     }
1022 
1023     /**
1024      * @dev See {IERC20-totalSupply}.
1025      */
1026     function totalSupply() public view override returns (uint256) {
1027         return _totalSupply;
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-balanceOf}.
1032      */
1033     function balanceOf(address account) public view override returns (uint256) {
1034         return _balances[account];
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-transfer}.
1039      *
1040      * Requirements:
1041      *
1042      * - `recipient` cannot be the zero address.
1043      * - the caller must have a balance of at least `amount`.
1044      */
1045     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1046         _transfer(_msgSender(), recipient, amount);
1047         return true;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-allowance}.
1052      */
1053     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1054         return _allowances[owner][spender];
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-approve}.
1059      *
1060      * Requirements:
1061      *
1062      * - `spender` cannot be the zero address.
1063      */
1064     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1065         _approve(_msgSender(), spender, amount);
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev See {IERC20-transferFrom}.
1071      *
1072      * Emits an {Approval} event indicating the updated allowance. This is not
1073      * required by the EIP. See the note at the beginning of {ERC20};
1074      *
1075      * Requirements:
1076      * - `sender` and `recipient` cannot be the zero address.
1077      * - `sender` must have a balance of at least `amount`.
1078      * - the caller must have allowance for ``sender``'s tokens of at least
1079      * `amount`.
1080      */
1081     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1082         _transfer(sender, recipient, amount);
1083         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev Atomically increases the allowance granted to `spender` by the caller.
1089      *
1090      * This is an alternative to {approve} that can be used as a mitigation for
1091      * problems described in {IERC20-approve}.
1092      *
1093      * Emits an {Approval} event indicating the updated allowance.
1094      *
1095      * Requirements:
1096      *
1097      * - `spender` cannot be the zero address.
1098      */
1099     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1101         return true;
1102     }
1103 
1104     /**
1105      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1106      *
1107      * This is an alternative to {approve} that can be used as a mitigation for
1108      * problems described in {IERC20-approve}.
1109      *
1110      * Emits an {Approval} event indicating the updated allowance.
1111      *
1112      * Requirements:
1113      *
1114      * - `spender` cannot be the zero address.
1115      * - `spender` must have allowance for the caller of at least
1116      * `subtractedValue`.
1117      */
1118     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1119         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));
1120         return true;
1121     }
1122 
1123     /**
1124      * @dev Moves tokens `amount` from `sender` to `recipient`.
1125      *
1126      * This is internal function is equivalent to {transfer}, and can be used to
1127      * e.g. implement automatic token fees, slashing mechanisms, etc.
1128      *
1129      * Emits a {Transfer} event.
1130      *
1131      * Requirements:
1132      *
1133      * - `sender` cannot be the zero address.
1134      * - `recipient` cannot be the zero address.
1135      * - `sender` must have a balance of at least `amount`.
1136      */
1137     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1138         require(sender != address(0), \"ERC20: transfer from the zero address\");
1139         require(recipient != address(0), \"ERC20: transfer to the zero address\");
1140 
1141         _beforeTokenTransfer(sender, recipient, amount);
1142 
1143         _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");
1144         _balances[recipient] = _balances[recipient].add(amount);
1145         emit Transfer(sender, recipient, amount);
1146     }
1147 
1148     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1149      * the total supply.
1150      *
1151      * Emits a {Transfer} event with `from` set to the zero address.
1152      *
1153      * Requirements
1154      *
1155      * - `to` cannot be the zero address.
1156      */
1157     function _mint(address account, uint256 amount) internal virtual {
1158         require(account != address(0), \"ERC20: mint to the zero address\");
1159 
1160         _beforeTokenTransfer(address(0), account, amount);
1161 
1162         _totalSupply = _totalSupply.add(amount);
1163         _balances[account] = _balances[account].add(amount);
1164         emit Transfer(address(0), account, amount);
1165     }
1166 
1167     /**
1168      * @dev Destroys `amount` tokens from `account`, reducing the
1169      * total supply.
1170      *
1171      * Emits a {Transfer} event with `to` set to the zero address.
1172      *
1173      * Requirements
1174      *
1175      * - `account` cannot be the zero address.
1176      * - `account` must have at least `amount` tokens.
1177      */
1178     function _burn(address account, uint256 amount) internal virtual {
1179         require(account != address(0), \"ERC20: burn from the zero address\");
1180 
1181         _beforeTokenTransfer(account, address(0), amount);
1182 
1183         _balances[account] = _balances[account].sub(amount, \"ERC20: burn amount exceeds balance\");
1184         _totalSupply = _totalSupply.sub(amount);
1185         emit Transfer(account, address(0), amount);
1186     }
1187 
1188     /**
1189      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1190      *
1191      * This internal function is equivalent to `approve`, and can be used to
1192      * e.g. set automatic allowances for certain subsystems, etc.
1193      *
1194      * Emits an {Approval} event.
1195      *
1196      * Requirements:
1197      *
1198      * - `owner` cannot be the zero address.
1199      * - `spender` cannot be the zero address.
1200      */
1201     function _approve(address owner, address spender, uint256 amount) internal virtual {
1202         require(owner != address(0), \"ERC20: approve from the zero address\");
1203         require(spender != address(0), \"ERC20: approve to the zero address\");
1204 
1205         _allowances[owner][spender] = amount;
1206         emit Approval(owner, spender, amount);
1207     }
1208 
1209     /**
1210      * @dev Sets {decimals} to a value other than the default one of 18.
1211      *
1212      * WARNING: This function should only be called from the constructor. Most
1213      * applications that interact with token contracts will not expect
1214      * {decimals} to ever change, and may work incorrectly if it does.
1215      */
1216     function _setupDecimals(uint8 decimals_) internal {
1217         _decimals = decimals_;
1218     }
1219 
1220     /**
1221      * @dev Hook that is called before any transfer of tokens. This includes
1222      * minting and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1227      * will be to transferred to `to`.
1228      * - when `from` is zero, `amount` tokens will be minted for `to`.
1229      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1230      * - `from` and `to` are never both zero.
1231      *
1232      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1233      */
1234     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1235 }
1236 "
1237     },
1238     "./ERC20Burnable.sol": {
1239 	  "content": "// SPDX-License-Identifier: MIT
1240 
1241 pragma solidity ^0.7.0;
1242 
1243 import \"./Context.sol\";
1244 import \"./ERC20.sol\";
1245 
1246 /**
1247  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1248  * tokens and those that they have an allowance for, in a way that can be
1249  * recognized off-chain (via event analysis).
1250  */
1251 abstract contract ERC20Burnable is Context, ERC20 {
1252     using SafeMath for uint256;
1253 
1254     /**
1255      * @dev Destroys `amount` tokens from the caller.
1256      *
1257      * See {ERC20-_burn}.
1258      */
1259     function burn(uint256 amount) public virtual {
1260         _burn(_msgSender(), amount);
1261     }
1262 
1263     /**
1264      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1265      * allowance.
1266      *
1267      * See {ERC20-_burn} and {ERC20-allowance}.
1268      *
1269      * Requirements:
1270      *
1271      * - the caller must have allowance for ``accounts``'s tokens of at least
1272      * `amount`.
1273      */
1274     function burnFrom(address account, uint256 amount) public virtual {
1275         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, \"ERC20: burn amount exceeds allowance\");
1276 
1277         _approve(account, _msgSender(), decreasedAllowance);
1278         _burn(account, amount);
1279     }
1280 }
1281 "
1282     },
1283 	"./IDexe.sol": {
1284 	  "content": "// SPDX-License-Identifier: MIT
1285 pragma solidity 0.7.0;
1286 pragma experimental ABIEncoderV2;
1287 
1288 import './IERC20.sol';
1289 
1290 interface IDexe is IERC20 {
1291     enum HolderRoundStatus {None, Received}
1292 
1293     struct HolderRound {
1294         uint120 deposited; // USDC
1295         uint128 endBalance; // DEXE
1296         HolderRoundStatus status;
1297     }
1298 
1299     struct UserInfo {
1300         uint128 balanceBeforeLaunch; // Final balance before product launch.
1301         uint120 firstRoundLimit; // limit of USDC that could deposited in first round
1302         uint8 firstRoundDeposited; // First round when holder made a deposit or received DEXE.
1303     }
1304 
1305     struct BalanceInfo {
1306         uint32 firstBalanceChange; // Timestamp of first tokens receive.
1307         uint32 lastBalanceChange; // Timestamp of last balance change.
1308         uint128 balanceAverage; // Average balance for the previous period.
1309         uint balanceAccumulator; // Accumulates average for current period.
1310     }
1311 
1312     function launchedAfter() external view returns (uint);
1313     function launchDate() external view returns(uint);
1314     function tokensaleEndDate() external view returns (uint);
1315     function holderRounds(uint _round, address _holder) external view returns(HolderRound memory);
1316     function usersInfo(address _holder) external view returns(UserInfo memory);
1317     function getAverageBalance(address _holder) external view returns(uint);
1318     function firstBalanceChange(address _holder) external view returns(uint);
1319 }
1320 "
1321     },
1322 	"./IERC20.sol": {
1323 	  "content": "// SPDX-License-Identifier: MIT
1324 
1325 pragma solidity ^0.7.0;
1326 
1327 /**
1328  * @dev Interface of the ERC20 standard as defined in the EIP.
1329  */
1330 interface IERC20 {
1331     /**
1332      * @dev Returns the amount of tokens in existence.
1333      */
1334     function totalSupply() external view returns (uint256);
1335 
1336     /**
1337      * @dev Returns the amount of tokens owned by `account`.
1338      */
1339     function balanceOf(address account) external view returns (uint256);
1340 
1341     /**
1342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1343      *
1344      * Returns a boolean value indicating whether the operation succeeded.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function transfer(address recipient, uint256 amount) external returns (bool);
1349 
1350     /**
1351      * @dev Returns the remaining number of tokens that `spender` will be
1352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1353      * zero by default.
1354      *
1355      * This value changes when {approve} or {transferFrom} are called.
1356      */
1357     function allowance(address owner, address spender) external view returns (uint256);
1358 
1359     /**
1360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1361      *
1362      * Returns a boolean value indicating whether the operation succeeded.
1363      *
1364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1365      * that someone may use both the old and the new allowance by unfortunate
1366      * transaction ordering. One possible solution to mitigate this race
1367      * condition is to first reduce the spender's allowance to 0 and set the
1368      * desired value afterwards:
1369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1370      *
1371      * Emits an {Approval} event.
1372      */
1373     function approve(address spender, uint256 amount) external returns (bool);
1374 
1375     /**
1376      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1377      * allowance mechanism. `amount` is then deducted from the caller's
1378      * allowance.
1379      *
1380      * Returns a boolean value indicating whether the operation succeeded.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1385 
1386     /**
1387      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1388      * another (`to`).
1389      *
1390      * Note that `value` may be zero.
1391      */
1392     event Transfer(address indexed from, address indexed to, uint256 value);
1393 
1394     /**
1395      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1396      * a call to {approve}. `value` is the new allowance.
1397      */
1398     event Approval(address indexed owner, address indexed spender, uint256 value);
1399 }
1400 "
1401     },
1402 	"./Ownable.sol": {
1403 	  "content": "// SPDX-License-Identifier: MIT
1404 
1405 pragma solidity ^0.7.0;
1406 
1407 import \"./Context.sol\";
1408 /**
1409  * @dev Contract module which provides a basic access control mechanism, where
1410  * there is an account (an owner) that can be granted exclusive access to
1411  * specific functions.
1412  *
1413  * By default, the owner account will be the one that deploys the contract. This
1414  * can later be changed with {transferOwnership}.
1415  *
1416  * This module is used through inheritance. It will make available the modifier
1417  * `onlyOwner`, which can be applied to your functions to restrict their use to
1418  * the owner.
1419  */
1420 contract Ownable is Context {
1421     address private _owner;
1422 
1423     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1424 
1425     /**
1426      * @dev Initializes the contract setting the deployer as the initial owner.
1427      */
1428     constructor () {
1429         address msgSender = _msgSender();
1430         _owner = msgSender;
1431         emit OwnershipTransferred(address(0), msgSender);
1432     }
1433 
1434     /**
1435      * @dev Returns the address of the current owner.
1436      */
1437     function owner() public view returns (address) {
1438         return _owner;
1439     }
1440 
1441     /**
1442      * @dev Throws if called by any account other than the owner.
1443      */
1444     modifier onlyOwner() {
1445         require(_owner == _msgSender(), \"Ownable: caller is not the owner\");
1446         _;
1447     }
1448 
1449     /**
1450      * @dev Leaves the contract without owner. It will not be possible to call
1451      * `onlyOwner` functions anymore. Can only be called by the current owner.
1452      *
1453      * NOTE: Renouncing ownership will leave the contract without an owner,
1454      * thereby removing any functionality that is only available to the owner.
1455      */
1456     function renounceOwnership() public virtual onlyOwner {
1457         emit OwnershipTransferred(_owner, address(0));
1458         _owner = address(0);
1459     }
1460 
1461     /**
1462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1463      * Can only be called by the current owner.
1464      */
1465     function transferOwnership(address newOwner) public virtual onlyOwner {
1466         require(newOwner != address(0), \"Ownable: new owner is the zero address\");
1467         emit OwnershipTransferred(_owner, newOwner);
1468         _owner = newOwner;
1469     }
1470 }
1471 "
1472     },
1473 	"./IPriceFeed.sol": {
1474 	  "content": "// SPDX-License-Identifier: MIT
1475 pragma solidity >= 0.6.5 <= 0.7.0;
1476 
1477 interface IPriceFeed {
1478     function update() external returns(uint);
1479     function consult() external view returns (uint);
1480     function updateAndConsult() external returns (uint);
1481 }
1482 "
1483     },
1484 	"./SafeMath.sol": {
1485 	  "content": "// SPDX-License-Identifier: MIT
1486 
1487 pragma solidity ^0.7.0;
1488 
1489 /**
1490  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1491  * checks.
1492  *
1493  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1494  * in bugs, because programmers usually assume that an overflow raises an
1495  * error, which is the standard behavior in high level programming languages.
1496  * `SafeMath` restores this intuition by reverting the transaction when an
1497  * operation overflows.
1498  *
1499  * Using this library instead of the unchecked operations eliminates an entire
1500  * class of bugs, so it's recommended to use it always.
1501  */
1502 library SafeMath {
1503     /**
1504      * @dev Returns the addition of two unsigned integers, reverting on
1505      * overflow.
1506      *
1507      * Counterpart to Solidity's `+` operator.
1508      *
1509      * Requirements:
1510      *
1511      * - Addition cannot overflow.
1512      */
1513     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1514         uint256 c = a + b;
1515         require(c >= a, \"SafeMath: addition overflow\");
1516 
1517         return c;
1518     }
1519 
1520     /**
1521      * @dev Returns the subtraction of two unsigned integers, reverting on
1522      * overflow (when the result is negative).
1523      *
1524      * Counterpart to Solidity's `-` operator.
1525      *
1526      * Requirements:
1527      *
1528      * - Subtraction cannot overflow.
1529      */
1530     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1531         return sub(a, b, \"SafeMath: subtraction overflow\");
1532     }
1533 
1534     /**
1535      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1536      * overflow (when the result is negative).
1537      *
1538      * Counterpart to Solidity's `-` operator.
1539      *
1540      * Requirements:
1541      *
1542      * - Subtraction cannot overflow.
1543      */
1544     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1545         require(b <= a, errorMessage);
1546         uint256 c = a - b;
1547 
1548         return c;
1549     }
1550 
1551     /**
1552      * @dev Returns the multiplication of two unsigned integers, reverting on
1553      * overflow.
1554      *
1555      * Counterpart to Solidity's `*` operator.
1556      *
1557      * Requirements:
1558      *
1559      * - Multiplication cannot overflow.
1560      */
1561     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1562         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1563         // benefit is lost if 'b' is also tested.
1564         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1565         if (a == 0) {
1566             return 0;
1567         }
1568 
1569         uint256 c = a * b;
1570         require(c / a == b, \"SafeMath: multiplication overflow\");
1571 
1572         return c;
1573     }
1574 
1575     /**
1576      * @dev Returns the integer division of two unsigned integers. Reverts on
1577      * division by zero. The result is rounded towards zero.
1578      *
1579      * Counterpart to Solidity's `/` operator. Note: this function uses a
1580      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1581      * uses an invalid opcode to revert (consuming all remaining gas).
1582      *
1583      * Requirements:
1584      *
1585      * - The divisor cannot be zero.
1586      */
1587     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1588         return div(a, b, \"SafeMath: division by zero\");
1589     }
1590 
1591     /**
1592      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1593      * division by zero. The result is rounded towards zero.
1594      *
1595      * Counterpart to Solidity's `/` operator. Note: this function uses a
1596      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1597      * uses an invalid opcode to revert (consuming all remaining gas).
1598      *
1599      * Requirements:
1600      *
1601      * - The divisor cannot be zero.
1602      */
1603     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1604         require(b > 0, errorMessage);
1605         uint256 c = a / b;
1606         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1607 
1608         return c;
1609     }
1610 
1611     /**
1612      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1613      * Reverts when dividing by zero.
1614      *
1615      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1616      * opcode (which leaves remaining gas untouched) while Solidity uses an
1617      * invalid opcode to revert (consuming all remaining gas).
1618      *
1619      * Requirements:
1620      *
1621      * - The divisor cannot be zero.
1622      */
1623     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1624         return mod(a, b, \"SafeMath: modulo by zero\");
1625     }
1626 
1627     /**
1628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1629      * Reverts with custom message when dividing by zero.
1630      *
1631      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1632      * opcode (which leaves remaining gas untouched) while Solidity uses an
1633      * invalid opcode to revert (consuming all remaining gas).
1634      *
1635      * Requirements:
1636      *
1637      * - The divisor cannot be zero.
1638      */
1639     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1640         require(b != 0, errorMessage);
1641         return a % b;
1642     }
1643 }
1644 "
1645     }
1646   },
1647   "settings": {
1648    "evmVersion":"istanbul",
1649    "libraries":{
1650    },
1651    "metadata":{
1652       "bytecodeHash":"ipfs"
1653    },
1654    "optimizer":{
1655       "enabled":true,
1656       "runs":10000
1657    },
1658    "remappings":[],
1659    "outputSelection": {
1660       "*": {
1661         "*": [
1662 			"metadata",
1663 			"abi",
1664 			"evm.deployedBytecode",
1665 			"evm.bytecode"
1666         ]
1667       }
1668     }
1669   }
1670 }}