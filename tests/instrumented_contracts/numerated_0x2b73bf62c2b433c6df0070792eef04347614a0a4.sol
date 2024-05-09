1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 contract ERC20Interface {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed from, address indexed spender, uint256 value);
81     string public symbol;
82 
83     function totalSupply() constant returns (uint256 supply);
84     function balanceOf(address _owner) constant returns (uint256 balance);
85     function transfer(address _to, uint256 _value) returns (bool success);
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
87     function approve(address _spender, uint256 _value) returns (bool success);
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 }
90 
91 /**
92  * @title Generic owned destroyable contract
93  */
94 contract Object is Owned {
95     /**
96     *  Common result code. Means everything is fine.
97     */
98     uint constant OK = 1;
99     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
100 
101     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
102         for(uint i=0;i<tokens.length;i++) {
103             address token = tokens[i];
104             uint balance = ERC20Interface(token).balanceOf(this);
105             if(balance != 0)
106                 ERC20Interface(token).transfer(_to,balance);
107         }
108         return OK;
109     }
110 
111     function checkOnlyContractOwner() internal constant returns(uint) {
112         if (contractOwner == msg.sender) {
113             return OK;
114         }
115 
116         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
117     }
118 }
119 
120 /**
121 * @title SafeMath
122 * @dev Math operations with safety checks that throw on error
123 */
124 library SafeMath {
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a * b;
127         assert(a == 0 || c / a == b);
128         return c;
129     }
130 
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // assert(b > 0); // Solidity automatically throws when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135         return c;
136     }
137 
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         assert(c >= a);
146         return c;
147     }
148 }
149 
150 contract OracleContractAdapter is Object {
151 
152     event OracleAdded(address _oracle);
153     event OracleRemoved(address _oracle);
154 
155     mapping(address => bool) public oracles;
156 
157     /// @dev Allow access only for oracle
158     modifier onlyOracle {
159         if (oracles[msg.sender]) {
160             _;
161         }
162     }
163 
164     modifier onlyOracleOrOwner {
165         if (oracles[msg.sender] || msg.sender == contractOwner) {
166             _;
167         }
168     }
169 
170     /// @notice Add oracles to whitelist.
171     ///
172     /// @param _whitelist user list.
173     function addOracles(address[] _whitelist) 
174     onlyContractOwner 
175     external 
176     returns (uint) 
177     {
178         for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {
179             address _oracle = _whitelist[_idx];
180             if (_oracle != 0x0 && !oracles[_oracle]) {
181                 oracles[_oracle] = true;
182                 _emitOracleAdded(_oracle);
183             }
184         }
185         return OK;
186     }
187 
188     /// @notice Removes oracles from whitelist.
189     ///
190     /// @param _blacklist user in whitelist.
191     function removeOracles(address[] _blacklist) 
192     onlyContractOwner 
193     external 
194     returns (uint) 
195     {
196         for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {
197             address _oracle = _blacklist[_idx];
198             if (_oracle != 0x0 && oracles[_oracle]) {
199                 delete oracles[_oracle];
200                 _emitOracleRemoved(_oracle);
201             }
202         }
203         return OK;
204     }
205 
206     function _emitOracleAdded(address _oracle) internal {
207         OracleAdded(_oracle);
208     }
209 
210     function _emitOracleRemoved(address _oracle) internal {
211         OracleRemoved(_oracle);
212     }
213 }
214 
215 /// @title ServiceAllowance.
216 ///
217 /// Provides a way to delegate operation allowance decision to a service contract
218 contract ServiceAllowance {
219     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
220 }
221 
222 /// @title DepositWalletInterface
223 ///
224 /// Defines an interface for a wallet that can be deposited/withdrawn by 3rd contract
225 contract DepositWalletInterface {
226     function deposit(address _asset, address _from, uint256 amount) public returns (uint);
227     function withdraw(address _asset, address _to, uint256 amount) public returns (uint);
228 }
229 
230 contract ProfiteroleEmitter {
231 
232     event DepositPendingAdded(uint amount, address from, uint timestamp);
233     event BonusesWithdrawn(bytes32 userKey, uint amount, uint timestamp);
234 
235     event Error(uint errorCode);
236 
237     function _emitError(uint _errorCode) internal returns (uint) {
238         Error(_errorCode);
239         return _errorCode;
240     }
241 }
242 
243 contract TreasuryEmitter {
244     event TreasuryDeposited(bytes32 userKey, uint value, uint lockupDate);
245     event TreasuryWithdrawn(bytes32 userKey, uint value);
246 }
247 
248 contract ERC20 {
249     event Transfer(address indexed from, address indexed to, uint256 value);
250     event Approval(address indexed from, address indexed spender, uint256 value);
251     string public symbol;
252 
253     function totalSupply() constant returns (uint256 supply);
254     function balanceOf(address _owner) constant returns (uint256 balance);
255     function transfer(address _to, uint256 _value) returns (bool success);
256     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
257     function approve(address _spender, uint256 _value) returns (bool success);
258     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
259 }
260 
261 
262 
263 
264 /// @title Treasury contract.
265 ///
266 /// Treasury for CCs deposits for particular fund with bmc-days calculations.
267 /// Accept BMC deposits from Continuous Contributors via oracle and
268 /// calculates bmc-days metric for each CC's role.
269 contract Treasury is OracleContractAdapter, ServiceAllowance, TreasuryEmitter {
270 
271     /* ERROR CODES */
272 
273     uint constant PERCENT_PRECISION = 10000;
274 
275     uint constant TREASURY_ERROR_SCOPE = 108000;
276     uint constant TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE = TREASURY_ERROR_SCOPE + 1;
277 
278     using SafeMath for uint;
279 
280     struct LockedDeposits {
281         uint counter;
282         mapping(uint => uint) index2Date;
283         mapping(uint => uint) date2deposit;
284     }
285 
286     struct Period {
287         uint transfersCount;
288         uint totalBmcDays;
289         uint bmcDaysPerDay;
290         uint startDate;
291         mapping(bytes32 => uint) user2bmcDays;
292         mapping(bytes32 => uint) user2lastTransferIdx;
293         mapping(bytes32 => uint) user2balance;
294         mapping(uint => uint) transfer2date;
295     }
296 
297     /* FIELDS */
298 
299     address token;
300     address profiterole;
301     uint periodsCount;
302 
303     mapping(uint => Period) periods;
304     mapping(uint => uint) periodDate2periodIdx;
305     mapping(bytes32 => uint) user2lastPeriodParticipated;
306     mapping(bytes32 => LockedDeposits) user2lockedDeposits;
307 
308     /* MODIFIERS */
309 
310     /// @dev Only profiterole contract allowed to invoke guarded functions
311     modifier onlyProfiterole {
312         require(profiterole == msg.sender);
313         _;
314     }
315 
316     /* PUBLIC */
317     
318     function Treasury(address _token) public {
319         require(address(_token) != 0x0);
320         token = _token;
321         periodsCount = 1;
322     }
323 
324     function init(address _profiterole) public onlyContractOwner returns (uint) {
325         require(_profiterole != 0x0);
326         profiterole = _profiterole;
327         return OK;
328     }
329 
330     /// @notice Do not accept Ether transfers
331     function() payable public {
332         revert();
333     }
334 
335     /* EXTERNAL */
336 
337     /// @notice Deposits tokens on behalf of users
338     /// Allowed only for oracle.
339     ///
340     /// @param _userKey aggregated user key (user ID + role ID)
341     /// @param _value amount of tokens to deposit
342     /// @param _feeAmount amount of tokens that will be taken from _value as fee
343     /// @param _feeAddress destination address for fee transfer
344     /// @param _lockupDate lock up date for deposit. Until that date the deposited value couldn't be withdrawn
345     ///
346     /// @return result code of an operation
347     function deposit(bytes32 _userKey, uint _value, uint _feeAmount, address _feeAddress, uint _lockupDate) external onlyOracle returns (uint) {
348         require(_userKey != bytes32(0));
349         require(_value != 0);
350         require(_feeAmount < _value);
351 
352         ERC20 _token = ERC20(token);
353         if (_token.allowance(msg.sender, address(this)) < _value) {
354             return TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE;
355         }
356 
357         uint _depositedAmount = _value - _feeAmount;
358         _makeDepositForPeriod(_userKey, _depositedAmount, _lockupDate);
359 
360         uint _periodsCount = periodsCount;
361         user2lastPeriodParticipated[_userKey] = _periodsCount;
362         delete periods[_periodsCount].startDate;
363 
364         if (!_token.transferFrom(msg.sender, address(this), _value)) {
365             revert();
366         }
367 
368         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
369             revert();
370         }
371 
372         TreasuryDeposited(_userKey, _depositedAmount, _lockupDate);
373         return OK;
374     }
375 
376     /// @notice Withdraws deposited tokens on behalf of users
377     /// Allowed only for oracle
378     ///
379     /// @param _userKey aggregated user key (user ID + role ID)
380     /// @param _value an amount of tokens that is requrested to withdraw
381     /// @param _withdrawAddress address to withdraw; should not be 0x0
382     /// @param _feeAmount amount of tokens that will be taken from _value as fee
383     /// @param _feeAddress destination address for fee transfer
384     ///
385     /// @return result of an operation
386     function withdraw(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {
387         require(_userKey != bytes32(0));
388         require(_value != 0);
389         require(_feeAmount < _value);
390 
391         _makeWithdrawForPeriod(_userKey, _value);
392         uint _periodsCount = periodsCount;
393         user2lastPeriodParticipated[_userKey] = periodsCount;
394         delete periods[_periodsCount].startDate;
395 
396         ERC20 _token = ERC20(token);
397         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
398             revert();
399         }
400 
401         uint _withdrawnAmount = _value - _feeAmount;
402         if (!_token.transfer(_withdrawAddress, _withdrawnAmount)) {
403             revert();
404         }
405 
406         TreasuryWithdrawn(_userKey, _withdrawnAmount);
407         return OK;
408     }
409 
410     /// @notice Gets shares (in percents) the user has on provided date
411     ///
412     /// @param _userKey aggregated user key (user ID + role ID)
413     /// @param _date date where period ends
414     ///
415     /// @return percent from total amount of bmc-days the treasury has on this date.
416     /// Use PERCENT_PRECISION to get right precision
417     function getSharesPercentForPeriod(bytes32 _userKey, uint _date) public view returns (uint) {
418         uint _periodIdx = periodDate2periodIdx[_date];
419         if (_date != 0 && _periodIdx == 0) {
420             return 0;
421         }
422 
423         if (_date == 0) {
424             _date = now;
425             _periodIdx = periodsCount;
426         }
427 
428         uint _bmcDays = _getBmcDaysAmountForUser(_userKey, _date, _periodIdx);
429         uint _totalBmcDeposit = _getTotalBmcDaysAmount(_date, _periodIdx);
430         return _totalBmcDeposit != 0 ? _bmcDays * PERCENT_PRECISION / _totalBmcDeposit : 0;
431     }
432 
433     /// @notice Gets user balance that is deposited
434     /// @param _userKey aggregated user key (user ID + role ID)
435     /// @return an amount of tokens deposited on behalf of user
436     function getUserBalance(bytes32 _userKey) public view returns (uint) {
437         uint _lastPeriodForUser = user2lastPeriodParticipated[_userKey];
438         if (_lastPeriodForUser == 0) {
439             return 0;
440         }
441 
442         if (_lastPeriodForUser <= periodsCount.sub(1)) {
443             return periods[_lastPeriodForUser].user2balance[_userKey];
444         }
445 
446         return periods[periodsCount].user2balance[_userKey];
447     }
448 
449     /// @notice Gets amount of locked deposits for user
450     /// @param _userKey aggregated user key (user ID + role ID)
451     /// @return an amount of tokens locked
452     function getLockedUserBalance(bytes32 _userKey) public returns (uint) {
453         return _syncLockedDepositsAmount(_userKey);
454     }
455 
456     /// @notice Gets list of locked up deposits with dates when they will be available to withdraw
457     /// @param _userKey aggregated user key (user ID + role ID)
458     /// @return {
459     ///     "_lockupDates": "list of lockup dates of deposits",
460     ///     "_deposits": "list of deposits"
461     /// }
462     function getLockedUserDeposits(bytes32 _userKey) public view returns (uint[] _lockupDates, uint[] _deposits) {
463         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
464         uint _lockedDepositsCounter = _lockedDeposits.counter;
465         _lockupDates = new uint[](_lockedDepositsCounter);
466         _deposits = new uint[](_lockedDepositsCounter);
467 
468         uint _pointer = 0;
469         for (uint _idx = 1; _idx < _lockedDepositsCounter; ++_idx) {
470             uint _lockDate = _lockedDeposits.index2Date[_idx];
471 
472             if (_lockDate > now) {
473                 _lockupDates[_pointer] = _lockDate;
474                 _deposits[_pointer] = _lockedDeposits.date2deposit[_lockDate];
475                 ++_pointer;
476             }
477         }
478     }
479 
480     /// @notice Gets total amount of bmc-day accumulated due provided date
481     /// @param _date date where period ends
482     /// @return an amount of bmc-days
483     function getTotalBmcDaysAmount(uint _date) public view returns (uint) {
484         return _getTotalBmcDaysAmount(_date, periodsCount);
485     }
486 
487     /// @notice Makes a checkpoint to start counting a new period
488     /// @dev Should be used only by Profiterole contract
489     function addDistributionPeriod() public onlyProfiterole returns (uint) {
490         uint _periodsCount = periodsCount;
491         uint _nextPeriod = _periodsCount.add(1);
492         periodDate2periodIdx[now] = _periodsCount;
493 
494         Period storage _previousPeriod = periods[_periodsCount];
495         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
496         periods[_nextPeriod].startDate = now;
497         periods[_nextPeriod].bmcDaysPerDay = _previousPeriod.bmcDaysPerDay;
498         periods[_nextPeriod].totalBmcDays = _totalBmcDeposit;
499         periodsCount = _nextPeriod;
500 
501         return OK;
502     }
503 
504     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
505         return true;
506     }
507 
508     /* INTERNAL */
509 
510     function _makeDepositForPeriod(bytes32 _userKey, uint _value, uint _lockupDate) internal {
511         Period storage _transferPeriod = periods[periodsCount];
512 
513         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, periodsCount);
514         _transferPeriod.totalBmcDays = _getTotalBmcDaysAmount(now, periodsCount);
515         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.add(_value);
516 
517         uint _userBalance = getUserBalance(_userKey);
518         uint _updatedTransfersCount = _transferPeriod.transfersCount.add(1);
519         _transferPeriod.transfersCount = _updatedTransfersCount;
520         _transferPeriod.transfer2date[_transferPeriod.transfersCount] = now;
521         _transferPeriod.user2balance[_userKey] = _userBalance.add(_value);
522         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransfersCount;
523 
524         _registerLockedDeposits(_userKey, _value, _lockupDate);
525     }
526 
527     function _makeWithdrawForPeriod(bytes32 _userKey, uint _value) internal {
528         uint _userBalance = getUserBalance(_userKey);
529         uint _lockedBalance = _syncLockedDepositsAmount(_userKey);
530         require(_userBalance.sub(_lockedBalance) >= _value);
531 
532         uint _periodsCount = periodsCount;
533         Period storage _transferPeriod = periods[_periodsCount];
534 
535         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, _periodsCount);
536         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
537         _transferPeriod.totalBmcDays = _totalBmcDeposit;
538         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.sub(_value);
539 
540         uint _updatedTransferCount = _transferPeriod.transfersCount.add(1);
541         _transferPeriod.transfer2date[_updatedTransferCount] = now;
542         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransferCount;
543         _transferPeriod.user2balance[_userKey] = _userBalance.sub(_value);
544         _transferPeriod.transfersCount = _updatedTransferCount;
545     }
546 
547     function _registerLockedDeposits(bytes32 _userKey, uint _amount, uint _lockupDate) internal {
548         if (_lockupDate <= now) {
549             return;
550         }
551 
552         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
553         uint _lockedBalance = _lockedDeposits.date2deposit[_lockupDate];
554 
555         if (_lockedBalance == 0) {
556             uint _lockedDepositsCounter = _lockedDeposits.counter.add(1);
557             _lockedDeposits.counter = _lockedDepositsCounter;
558             _lockedDeposits.index2Date[_lockedDepositsCounter] = _lockupDate;
559         }
560         _lockedDeposits.date2deposit[_lockupDate] = _lockedBalance.add(_amount);
561     }
562 
563     function _syncLockedDepositsAmount(bytes32 _userKey) internal returns (uint _lockedSum) {
564         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
565         uint _lockedDepositsCounter = _lockedDeposits.counter;
566 
567         for (uint _idx = 1; _idx <= _lockedDepositsCounter; ++_idx) {
568             uint _lockDate = _lockedDeposits.index2Date[_idx];
569 
570             if (_lockDate <= now) {
571                 _lockedDeposits.index2Date[_idx] = _lockedDeposits.index2Date[_lockedDepositsCounter];
572 
573                 delete _lockedDeposits.index2Date[_lockedDepositsCounter];
574                 delete _lockedDeposits.date2deposit[_lockDate];
575 
576                 _lockedDepositsCounter = _lockedDepositsCounter.sub(1);
577                 continue;
578             }
579 
580             _lockedSum = _lockedSum.add(_lockedDeposits.date2deposit[_lockDate]);
581         }
582 
583         _lockedDeposits.counter = _lockedDepositsCounter;
584     }
585 
586     function _getBmcDaysAmountForUser(bytes32 _userKey, uint _date, uint _periodIdx) internal view returns (uint) {
587         uint _lastPeriodForUserIdx = user2lastPeriodParticipated[_userKey];
588         if (_lastPeriodForUserIdx == 0) {
589             return 0;
590         }
591 
592         Period storage _transferPeriod = _lastPeriodForUserIdx <= _periodIdx ? periods[_lastPeriodForUserIdx] : periods[_periodIdx];
593         uint _lastTransferDate = _transferPeriod.transfer2date[_transferPeriod.user2lastTransferIdx[_userKey]];
594         // NOTE: It is an intended substraction separation to correctly round dates
595         uint _daysLong = (_date / 1 days) - (_lastTransferDate / 1 days);
596         uint _bmcDays = _transferPeriod.user2bmcDays[_userKey];
597         return _bmcDays.add(_transferPeriod.user2balance[_userKey] * _daysLong);
598     }
599 
600     /* PRIVATE */
601 
602     function _getTotalBmcDaysAmount(uint _date, uint _periodIdx) private view returns (uint) {
603         Period storage _depositPeriod = periods[_periodIdx];
604         uint _transfersCount = _depositPeriod.transfersCount;
605         uint _lastRecordedDate = _transfersCount != 0 ? _depositPeriod.transfer2date[_transfersCount] : _depositPeriod.startDate;
606 
607         if (_lastRecordedDate == 0) {
608             return 0;
609         }
610 
611         // NOTE: It is an intended substraction separation to correctly round dates
612         uint _daysLong = (_date / 1 days).sub((_lastRecordedDate / 1 days));
613         uint _totalBmcDeposit = _depositPeriod.totalBmcDays.add(_depositPeriod.bmcDaysPerDay.mul(_daysLong));
614         return _totalBmcDeposit;
615     }
616 }
617 
618 /// @title Profiterole contract
619 /// Collector and distributor for creation and redemption fees.
620 /// Accepts bonus tokens from EmissionProvider, BurningMan or other distribution source.
621 /// Calculates CCs shares in bonuses. Uses Treasury Contract as source of shares in bmc-days.
622 /// Allows to withdraw bonuses on request.
623 contract Profiterole is OracleContractAdapter, ServiceAllowance, ProfiteroleEmitter {
624 
625     uint constant PERCENT_PRECISION = 10000;
626 
627     uint constant PROFITEROLE_ERROR_SCOPE = 102000;
628     uint constant PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE = PROFITEROLE_ERROR_SCOPE + 1;
629     uint constant PROFITEROLE_ERROR_INSUFFICIENT_BONUS_BALANCE = PROFITEROLE_ERROR_SCOPE + 2;
630     uint constant PROFITEROLE_ERROR_TRANSFER_ERROR = PROFITEROLE_ERROR_SCOPE + 3;
631 
632     using SafeMath for uint;
633 
634     struct Balance {
635         uint left;
636         bool initialized;
637     }
638 
639     struct Deposit {
640         uint balance;
641         uint left;
642         uint nextDepositDate;
643         mapping(bytes32 => Balance) leftToWithdraw;
644     }
645 
646     struct UserBalance {
647         uint lastWithdrawDate;
648     }
649 
650     mapping(address => bool) distributionSourcesList;
651     mapping(bytes32 => UserBalance) bonusBalances;
652     mapping(uint => Deposit) public distributionDeposits;
653 
654     uint public firstDepositDate;
655     uint public lastDepositDate;
656 
657     address public bonusToken;
658     address public treasury;
659     address public wallet;
660 
661     /// @dev Guards functions only for distributionSource invocations
662     modifier onlyDistributionSource {
663         if (!distributionSourcesList[msg.sender]) {
664             revert();
665         }
666         _;
667     }
668 
669     function Profiterole(address _bonusToken, address _treasury, address _wallet) public {
670         require(_bonusToken != 0x0);
671         require(_treasury != 0x0);
672         require(_wallet != 0x0);
673 
674         bonusToken = _bonusToken;
675         treasury = _treasury;
676         wallet = _wallet;
677     }
678 
679     function() payable public {
680         revert();
681     }
682 
683     /* EXTERNAL */
684 
685     /// @notice Sets new treasury address
686     /// Only for contract owner.
687     function updateTreasury(address _treasury) external onlyContractOwner returns (uint) {
688         require(_treasury != 0x0);
689         treasury = _treasury;
690         return OK;
691     }
692 
693     /// @notice Sets new wallet address for profiterole
694     /// Only for contract owner.
695     function updateWallet(address _wallet) external onlyContractOwner returns (uint) {
696         require(_wallet != 0x0);
697         wallet = _wallet;
698         return OK;
699     }
700 
701     /// @notice Add distribution sources to whitelist.
702     ///
703     /// @param _whitelist addresses list.
704     function addDistributionSources(address[] _whitelist) external onlyContractOwner returns (uint) {
705         for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {
706             distributionSourcesList[_whitelist[_idx]] = true;
707         }
708         return OK;
709     }
710 
711     /// @notice Removes distribution sources from whitelist.
712     /// Only for contract owner.
713     ///
714     /// @param _blacklist addresses in whitelist.
715     function removeDistributionSources(address[] _blacklist) external onlyContractOwner returns (uint) {
716         for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {
717             delete distributionSourcesList[_blacklist[_idx]];
718         }
719         return OK;
720     }
721 
722     /// @notice Allows to withdraw user's bonuses that he deserves due to Treasury shares for
723     /// every distribution period.
724     /// Only oracles allowed to invoke this function.
725     ///
726     /// @param _userKey aggregated user key (user ID + role ID) on behalf of whom bonuses will be withdrawn
727     /// @param _value an amount of tokens to withdraw
728     /// @param _withdrawAddress destination address of withdrawal (usually user's address)
729     /// @param _feeAmount an amount of fee that will be taken from resulted _value
730     /// @param _feeAddress destination address of fee transfer
731     ///
732     /// @return result code of an operation
733     function withdrawBonuses(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {
734         require(_userKey != bytes32(0));
735         require(_value != 0);
736         require(_feeAmount < _value);
737         require(_withdrawAddress != 0x0);
738 
739         DepositWalletInterface _wallet = DepositWalletInterface(wallet);
740         ERC20Interface _bonusToken = ERC20Interface(bonusToken);
741         if (_bonusToken.balanceOf(_wallet) < _value) {
742             return _emitError(PROFITEROLE_ERROR_INSUFFICIENT_BONUS_BALANCE);
743         }
744 
745         if (OK != _withdrawBonuses(_userKey, _value)) {
746             revert();
747         }
748 
749         if (!(_feeAddress == 0x0 || _feeAmount == 0 || OK == _wallet.withdraw(_bonusToken, _feeAddress, _feeAmount))) {
750             revert();
751         }
752 
753         if (OK != _wallet.withdraw(_bonusToken, _withdrawAddress, _value - _feeAmount)) {
754             revert();
755         }
756 
757         BonusesWithdrawn(_userKey, _value, now);
758         return OK;
759     }
760 
761     /* PUBLIC */
762 
763     /// @notice Gets total amount of bonuses user has during all distribution periods
764     /// @param _userKey aggregated user key (user ID + role ID)
765     /// @return _sum available amount of bonuses to withdraw
766     function getTotalBonusesAmountAvailable(bytes32 _userKey) public view returns (uint _sum) {
767         uint _startDate = _getCalculationStartDate(_userKey);
768         Treasury _treasury = Treasury(treasury);
769 
770         for (
771             uint _endDate = lastDepositDate;
772             _startDate <= _endDate && _startDate != 0;
773             _startDate = distributionDeposits[_startDate].nextDepositDate
774         ) {
775             Deposit storage _pendingDeposit = distributionDeposits[_startDate];
776             Balance storage _userBalance = _pendingDeposit.leftToWithdraw[_userKey];
777 
778             if (_userBalance.initialized) {
779                 _sum = _sum.add(_userBalance.left);
780             } else {
781                 uint _sharesPercent = _treasury.getSharesPercentForPeriod(_userKey, _startDate);
782                 _sum = _sum.add(_pendingDeposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION));
783             }
784         }
785     }
786 
787     /// @notice Gets an amount of bonuses user has for concrete distribution date
788     /// @param _userKey aggregated user key (user ID + role ID)
789     /// @param _distributionDate date of distribution operation
790     /// @return available amount of bonuses to withdraw for selected distribution date
791     function getBonusesAmountAvailable(bytes32 _userKey, uint _distributionDate) public view returns (uint) {
792         Deposit storage _deposit = distributionDeposits[_distributionDate];
793         if (_deposit.leftToWithdraw[_userKey].initialized) {
794             return _deposit.leftToWithdraw[_userKey].left;
795         }
796 
797         uint _sharesPercent = Treasury(treasury).getSharesPercentForPeriod(_userKey, _distributionDate);
798         return _deposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION);
799     }
800 
801     /// @notice Gets total amount of deposits that has left after users' bonus withdrawals
802     /// @return amount of deposits available for bonus payments
803     function getTotalDepositsAmountLeft() public view returns (uint _amount) {
804         uint _lastDepositDate = lastDepositDate;
805         for (
806             uint _startDate = firstDepositDate;
807             _startDate <= _lastDepositDate || _startDate != 0;
808             _startDate = distributionDeposits[_startDate].nextDepositDate
809         ) {
810             _amount = _amount.add(distributionDeposits[_startDate].left);
811         }
812     }
813 
814     /// @notice Gets an amount of deposits that has left after users' bonus withdrawals for selected date
815     /// @param _distributionDate date of distribution operation
816     /// @return amount of deposits available for bonus payments for concrete distribution date
817     function getDepositsAmountLeft(uint _distributionDate) public view returns (uint _amount) {
818         return distributionDeposits[_distributionDate].left;
819     }
820 
821     /// @notice Makes checkmark and deposits tokens on profiterole account
822     /// to pay them later as bonuses for Treasury shares holders. Timestamp of transaction
823     /// counts as the distribution period date.
824     /// Only addresses that were added as a distributionSource are allowed to call this function.
825     ///
826     /// @param _amount an amount of tokens to distribute
827     ///
828     /// @return result code of an operation.
829     /// PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE, PROFITEROLE_ERROR_TRANSFER_ERROR errors
830     /// are possible
831     function distributeBonuses(uint _amount) public onlyDistributionSource returns (uint) {
832 
833         ERC20Interface _bonusToken = ERC20Interface(bonusToken);
834 
835         if (_bonusToken.allowance(msg.sender, address(this)) < _amount) {
836             return _emitError(PROFITEROLE_ERROR_INSUFFICIENT_DISTRIBUTION_BALANCE);
837         }
838 
839         if (!_bonusToken.transferFrom(msg.sender, wallet, _amount)) {
840             return _emitError(PROFITEROLE_ERROR_TRANSFER_ERROR);
841         }
842 
843         if (firstDepositDate == 0) {
844             firstDepositDate = now;
845         }
846 
847         uint _lastDepositDate = lastDepositDate;
848         if (_lastDepositDate != 0) {
849             distributionDeposits[_lastDepositDate].nextDepositDate = now;
850         }
851 
852         lastDepositDate = now;
853         distributionDeposits[now] = Deposit(_amount, _amount, 0);
854 
855         Treasury(treasury).addDistributionPeriod();
856 
857         DepositPendingAdded(_amount, msg.sender, now);
858         return OK;
859     }
860 
861     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
862         return false;
863     }
864 
865     /* PRIVATE */
866 
867     function _getCalculationStartDate(bytes32 _userKey) private view returns (uint _startDate) {
868         _startDate = bonusBalances[_userKey].lastWithdrawDate;
869         return _startDate != 0 ? _startDate : firstDepositDate;
870     }
871 
872     function _withdrawBonuses(bytes32 _userKey, uint _value) private returns (uint) {
873         uint _startDate = _getCalculationStartDate(_userKey);
874         uint _lastWithdrawDate = _startDate;
875         Treasury _treasury = Treasury(treasury);
876 
877         for (
878             uint _endDate = lastDepositDate;
879             _startDate <= _endDate && _startDate != 0 && _value > 0;
880             _startDate = distributionDeposits[_startDate].nextDepositDate
881         ) {
882             uint _balanceToWithdraw = _withdrawBonusesFromDeposit(_userKey, _startDate, _value, _treasury);
883             _value = _value.sub(_balanceToWithdraw);
884         }
885 
886         if (_lastWithdrawDate != _startDate) {
887             bonusBalances[_userKey].lastWithdrawDate = _lastWithdrawDate;
888         }
889 
890         if (_value > 0) {
891             revert();
892         }
893 
894         return OK;
895     }
896 
897     function _withdrawBonusesFromDeposit(bytes32 _userKey, uint _periodDate, uint _value, Treasury _treasury) private returns (uint) {
898         Deposit storage _pendingDeposit = distributionDeposits[_periodDate];
899         Balance storage _userBalance = _pendingDeposit.leftToWithdraw[_userKey];
900 
901         uint _balanceToWithdraw;
902         if (_userBalance.initialized) {
903             _balanceToWithdraw = _userBalance.left;
904         } else {
905             uint _sharesPercent = _treasury.getSharesPercentForPeriod(_userKey, _periodDate);
906             _balanceToWithdraw = _pendingDeposit.balance.mul(_sharesPercent).div(PERCENT_PRECISION);
907             _userBalance.initialized = true;
908         }
909 
910         if (_balanceToWithdraw > _value) {
911             _userBalance.left = _balanceToWithdraw - _value;
912             _balanceToWithdraw = _value;
913         } else {
914             delete _userBalance.left;
915         }
916 
917         _pendingDeposit.left = _pendingDeposit.left.sub(_balanceToWithdraw);
918         return _balanceToWithdraw;
919     }
920 }
921 
922 /// @title EmissionProviderEmitter
923 ///
924 /// Organizes and provides a set of events specific for EmissionProvider's role
925 contract EmissionProviderEmitter {
926 
927     event Error(uint errorCode);
928     event Emission(bytes32 smbl, address to, uint value);
929     event HardcapFinishedManually();
930     event Destruction();
931 
932     function _emitError(uint _errorCode) internal returns (uint) {
933         Error(_errorCode);
934         return _errorCode;
935     }
936 
937     function _emitEmission(bytes32 _smbl, address _to, uint _value) internal {
938         Emission(_smbl, _to, _value);
939     }
940 
941     function _emitHardcapFinishedManually() internal {
942         HardcapFinishedManually();
943     }
944 
945     function _emitDestruction() internal {
946         Destruction();
947     }
948 }
949 
950 contract Token is ERC20 {
951     
952     bytes32 public smbl;
953     address public platform;
954 
955     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
956     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
957     function __approve(address _spender, uint _value, address _sender) public returns (bool);
958     function getLatestVersion() public returns (address);
959     function init(address _bmcPlatform, string _symbol, string _name) public;
960     function proposeUpgrade(address _newVersion) public;
961 }
962 
963 contract Platform {
964     mapping(bytes32 => address) public proxies;
965     function name(bytes32 _symbol) public view returns (string);
966     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
967     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
968     function totalSupply(bytes32 _symbol) public view returns (uint);
969     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
970     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
971     function baseUnit(bytes32 _symbol) public view returns (uint8);
972     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
973     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
974     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
975     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
976     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
977     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
978     function isReissuable(bytes32 _symbol) public view returns (bool);
979     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
980 }
981 
982 
983 /// @title EmissionProvider.
984 ///
985 /// Provides participation registration and token volume issuance called Emission Event.
986 /// Full functionality of EmissionProvider issuance will be available after adding a smart contract
987 /// as part-owner of an ATx asset in asset's platform
988 contract EmissionProvider is OracleContractAdapter, ServiceAllowance, EmissionProviderEmitter {
989 
990     uint constant EMISSION_PROVIDER_ERROR_SCOPE = 107000;
991     uint constant EMISSION_PROVIDER_ERROR_WRONG_STATE = EMISSION_PROVIDER_ERROR_SCOPE + 1;
992     uint constant EMISSION_PROVIDER_ERROR_INSUFFICIENT_BMC = EMISSION_PROVIDER_ERROR_SCOPE + 2;
993     uint constant EMISSION_PROVIDER_ERROR_INTERNAL = EMISSION_PROVIDER_ERROR_SCOPE + 3;
994 
995     using SafeMath for uint;
996 
997     enum State {
998         Init, Waiting, Sale, Reached, Destructed
999     }
1000 
1001     uint public startDate;
1002     uint public endDate;
1003 
1004     uint public tokenSoftcapIssued;
1005     uint public tokenSoftcap;
1006 
1007     uint tokenHardcapIssuedValue;
1008     uint tokenHardcapValue;
1009 
1010     address public token;
1011     address public bonusToken;
1012     address public profiterole;
1013 
1014     mapping(address => bool) public whitelist;
1015 
1016     bool public destructed;
1017     bool finishedHardcap;
1018     bool needInitialization;
1019 
1020     /// @dev Deny any access except during sale period (it's time for sale && hardcap haven't reached yet)
1021     modifier onlySale {
1022         var (hardcapState, softcapState) = getState();
1023         if (!(State.Sale == hardcapState || State.Sale == softcapState)) {
1024             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1025             assembly {
1026                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1027                 return (0, 32)
1028             }
1029         }
1030         _;
1031     }
1032 
1033     /// @dev Deny any access before all sales will be finished
1034     modifier onlySaleFinished {
1035         var (hardcapState, softcapState) = getState();
1036         if (hardcapState < State.Reached || softcapState < State.Reached) {
1037             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1038             assembly {
1039                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1040                 return (0, 32)
1041             }
1042         }
1043         _;
1044     }
1045     /// @dev Deny any access before hardcap will be reached
1046     modifier notHardcapReached {
1047         var (state,) = getState();
1048         if (state >= State.Reached) {
1049             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1050             assembly {
1051                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1052                 return (0, 32)
1053             }
1054         }
1055         _;
1056     }
1057 
1058     /// @dev Deny any access before softcap will be reached
1059     modifier notSoftcapReached {
1060         var (, state) = getState();
1061         if (state >= State.Reached) {
1062             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1063             assembly {
1064                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1065                 return (0, 32)
1066             }
1067         }
1068         _;
1069     }
1070 
1071     /// @dev Guards from calls to the contract in destructed state
1072     modifier notDestructed {
1073         if (destructed) {
1074             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1075             assembly {
1076                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1077                 return (0, 32)
1078             }
1079         }
1080         _;
1081     }
1082 
1083     /// @dev Deny any access except the contract is not in init state
1084     modifier onlyInit {
1085         var (state,) = getState();
1086         if (state != State.Init) {
1087             _emitError(EMISSION_PROVIDER_ERROR_WRONG_STATE);
1088             assembly {
1089                 mstore(0, 107001) // EMISSION_PROVIDER_ERROR_WRONG_STATE
1090                 return (0, 32)
1091             }
1092         }
1093         _;
1094     }
1095 
1096     /// @dev Allow access only for whitelisted users
1097     modifier onlyAllowed(address _account) {
1098         if (whitelist[_account]) {
1099             _;
1100         }
1101     }
1102 
1103     /// @notice Constructor for EmissionProvider.
1104     ///
1105     /// @param _token token that will be served by EmissionProvider
1106     /// @param _bonusToken shares token used for fee distribution
1107     /// @param _profiterole address of fee destination
1108     /// @param _startDate start date of emission event
1109     /// @param _endDate end date of emission event
1110     /// @param _tokenHardcap max amount of tokens that are allowed to issue. After reaching this number emission will be stopped.
1111     function EmissionProvider(
1112         address _token,
1113         address _bonusToken,
1114         address _profiterole,
1115         uint _startDate,
1116         uint _endDate,
1117         uint _tokenSoftcap,
1118         uint _tokenHardcap
1119     )
1120     public
1121     {
1122         require(_token != 0x0);
1123         require(_bonusToken != 0x0);
1124 
1125         require(_profiterole != 0x0);
1126 
1127         require(_startDate != 0);
1128         require(_endDate > _startDate);
1129 
1130         require(_tokenSoftcap != 0);
1131         require(_tokenHardcap >= _tokenSoftcap);
1132 
1133         require(Profiterole(_profiterole).bonusToken() == _bonusToken);
1134 
1135         token = _token;
1136         bonusToken = _bonusToken;
1137         profiterole = _profiterole;
1138         startDate = _startDate;
1139         endDate = _endDate;
1140         tokenSoftcap = _tokenSoftcap;
1141         tokenHardcapValue = _tokenHardcap - _tokenSoftcap;
1142         needInitialization = true;
1143     }
1144 
1145     /// @dev Payable function. Don't accept any Ether
1146     function() public payable {
1147         revert();
1148     }
1149 
1150     /// @notice Initialization
1151     /// Issue new ATx tokens for Softcap. After contract goes in Sale state
1152     function init() public onlyContractOwner onlyInit returns (uint) {
1153         needInitialization = false;
1154         bytes32 _symbol = Token(token).smbl();
1155         if (OK != Platform(Token(token).platform()).reissueAsset(_symbol, tokenSoftcap)) {
1156             revert();
1157         }
1158         return OK;
1159     }
1160 
1161     /// @notice Gets absolute hardcap value which means it will be greater than softcap value.
1162     /// Actual value will be equal to `tokenSoftcap - tokenHardcap`
1163     function tokenHardcap() public view returns (uint) {
1164         return tokenSoftcap + tokenHardcapValue;
1165     }
1166 
1167     /// @notice Gets absolute issued hardcap volume which means it will be greater than softcap value.
1168     /// Actual value will be equal to `tokenSoftcap - tokenHardcapIssued`
1169     function tokenHardcapIssued() public view returns (uint) {
1170         return tokenSoftcap + tokenHardcapIssuedValue;
1171     }
1172 
1173     /// @notice Gets current state of Emission Provider. State changes over time or reaching buyback goals.
1174     /// @return state of a Emission Provider. 'Init', 'Waiting', 'Sale', 'HardcapReached', 'Destructed` values are possible
1175     function getState() public view returns (State, State) {
1176         if (needInitialization) {
1177             return (State.Init, State.Init);
1178         }
1179 
1180         if (destructed) {
1181             return (State.Destructed, State.Destructed);
1182         }
1183 
1184         if (now < startDate) {
1185             return (State.Waiting, State.Waiting);
1186         }
1187 
1188         State _hardcapState = (finishedHardcap || (tokenHardcapIssuedValue == tokenHardcapValue) || (now > endDate))
1189         ? State.Reached
1190         : State.Sale;
1191 
1192         State _softcapState = (tokenSoftcapIssued == tokenSoftcap)
1193         ? State.Reached
1194         : State.Sale;
1195 
1196         return (_hardcapState, _softcapState);
1197     }
1198 
1199     /// @notice Add users to whitelist.
1200     /// @param _whitelist user list.
1201     function addUsers(address[] _whitelist) public onlyOracleOrOwner onlySale returns (uint) {
1202         for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {
1203             whitelist[_whitelist[_idx]] = true;
1204         }
1205         return OK;
1206     }
1207 
1208     /// @notice Removes users from whitelist.
1209     /// @param _blacklist user in whitelist.
1210     function removeUsers(address[] _blacklist) public onlyOracleOrOwner onlySale returns (uint) {
1211         for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {
1212             delete whitelist[_blacklist[_idx]];
1213         }
1214         return OK;
1215     }
1216 
1217     /// @notice Issue tokens for user.
1218     /// Access allowed only for oracle while the sale period is active.
1219     ///
1220     /// @param _token address for token.
1221     /// @param _for user address.
1222     /// @param _value token amount,
1223     function issueHardcapToken(
1224         address _token, 
1225         address _for, 
1226         uint _value
1227     ) 
1228     onlyOracle 
1229     onlyAllowed(_for) 
1230     onlySale 
1231     notHardcapReached 
1232     public
1233     returns (uint) 
1234     {
1235         require(_token == token);
1236         require(_value != 0);
1237 
1238         uint _tokenHardcap = tokenHardcapValue;
1239         uint _issued = tokenHardcapIssuedValue;
1240         if (_issued.add(_value) > _tokenHardcap) {
1241             _value = _tokenHardcap.sub(_issued);
1242         }
1243 
1244         tokenHardcapIssuedValue = _issued.add(_value);
1245 
1246         bytes32 _symbol = Token(_token).smbl();
1247         if (OK != Platform(Token(_token).platform()).reissueAsset(_symbol, _value)) {
1248             revert();
1249         }
1250 
1251         if (!Token(_token).transfer(_for, _value)) {
1252             revert();
1253         }
1254 
1255         _emitEmission(_symbol, _for, _value);
1256         return OK;
1257     }
1258 
1259     /// @notice Issue tokens for user.
1260     /// Access allowed only for oracle while the sale period is active.
1261     ///
1262     /// @param _token address for token.
1263     /// @param _for user address.
1264     /// @param _value token amount,
1265     function issueSoftcapToken(
1266         address _token, 
1267         address _for, 
1268         uint _value
1269     ) 
1270     onlyOracle
1271     onlyAllowed(_for)
1272     onlySale
1273     notSoftcapReached
1274     public
1275     returns (uint)
1276     {
1277         require(_token == token);
1278         require(_value != 0);
1279 
1280         uint _tokenSoftcap = tokenSoftcap;
1281         uint _issued = tokenSoftcapIssued;
1282         if (_issued.add(_value) > _tokenSoftcap) {
1283             _value = _tokenSoftcap.sub(_issued);
1284         }
1285 
1286         tokenSoftcapIssued = _issued.add(_value);
1287 
1288         if (!Token(_token).transfer(_for, _value)) {
1289             revert();
1290         }
1291 
1292         _emitEmission(Token(_token).smbl(), _for, _value);
1293         return OK;
1294     }
1295 
1296     /// @notice Performs finish hardcap manually
1297     /// Only by contract owner and in sale period
1298     function finishHardcap() public onlyContractOwner onlySale notHardcapReached returns (uint) {
1299         finishedHardcap = true;
1300         _emitHardcapFinishedManually();
1301         return OK;
1302     }
1303 
1304     /// @notice Performs distribution of sent BMC tokens and send them to Profiterole address
1305     /// Only by oracle address and after reaching hardcap conditions
1306     function distributeBonuses() public onlyOracleOrOwner onlySaleFinished notDestructed returns (uint) {
1307         ERC20Interface _token = ERC20Interface(bonusToken);
1308         uint _balance = _token.balanceOf(address(this));
1309 
1310         if (_balance == 0) {
1311             return _emitError(EMISSION_PROVIDER_ERROR_INSUFFICIENT_BMC);
1312         }
1313 
1314         Profiterole _profiterole = Profiterole(profiterole);
1315         if (!_token.approve(address(_profiterole), _balance)) {
1316             return _emitError(EMISSION_PROVIDER_ERROR_INTERNAL);
1317         }
1318 
1319         if (OK != _profiterole.distributeBonuses(_balance)) {
1320             revert();
1321         }
1322 
1323         return OK;
1324     }
1325 
1326     /// @notice Activates distruction.
1327     /// Access allowed only by contract owner after distruction
1328     function activateDestruction() public onlyContractOwner onlySaleFinished notDestructed returns (uint) {
1329         destructed = true;
1330         _emitDestruction();
1331         return OK;
1332     }
1333 
1334     /* ServiceAllowance */
1335 
1336     /// @notice Restricts transfers only for:
1337     /// 1) oracle and only ATx tokens;
1338     /// 2) from itself to holder
1339     function isTransferAllowed(address _from, address _to, address, address _token, uint) public view returns (bool) {
1340         if (_token == token &&
1341             ((oracles[_from] && _to == address(this)) ||
1342             (_from == address(this) && whitelist[_to]))
1343         ) {
1344             return true;
1345         }
1346     }
1347 
1348     function tokenFallback(address _sender, uint, bytes) external {
1349         require(msg.sender == Token(token).getLatestVersion());
1350         require(oracles[_sender]);
1351     }
1352 }