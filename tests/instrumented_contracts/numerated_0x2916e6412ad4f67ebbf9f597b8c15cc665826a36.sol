1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /// @title ServiceAllowance.
34 ///
35 /// Provides a way to delegate operation allowance decision to a service contract
36 contract ServiceAllowance {
37     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
38 }
39 
40 /**
41  * @title Owned contract with safe ownership pass.
42  *
43  * Note: all the non constant functions return false instead of throwing in case if state change
44  * didn't happen yet.
45  */
46 contract Owned {
47     /**
48      * Contract owner address
49      */
50     address public contractOwner;
51 
52     /**
53      * Contract owner address
54      */
55     address public pendingContractOwner;
56 
57     function Owned() {
58         contractOwner = msg.sender;
59     }
60 
61     /**
62     * @dev Owner check modifier
63     */
64     modifier onlyContractOwner() {
65         if (contractOwner == msg.sender) {
66             _;
67         }
68     }
69 
70     /**
71      * @dev Destroy contract and scrub a data
72      * @notice Only owner can call it
73      */
74     function destroy() onlyContractOwner {
75         suicide(msg.sender);
76     }
77 
78     /**
79      * Prepares ownership pass.
80      *
81      * Can only be called by current owner.
82      *
83      * @param _to address of the next owner. 0x0 is not allowed.
84      *
85      * @return success.
86      */
87     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
88         if (_to  == 0x0) {
89             return false;
90         }
91 
92         pendingContractOwner = _to;
93         return true;
94     }
95 
96     /**
97      * Finalize ownership pass.
98      *
99      * Can only be called by pending owner.
100      *
101      * @return success.
102      */
103     function claimContractOwnership() returns(bool) {
104         if (pendingContractOwner != msg.sender) {
105             return false;
106         }
107 
108         contractOwner = pendingContractOwner;
109         delete pendingContractOwner;
110 
111         return true;
112     }
113 }
114 
115 contract ERC20Interface {
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed from, address indexed spender, uint256 value);
118     string public symbol;
119 
120     function totalSupply() constant returns (uint256 supply);
121     function balanceOf(address _owner) constant returns (uint256 balance);
122     function transfer(address _to, uint256 _value) returns (bool success);
123     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
124     function approve(address _spender, uint256 _value) returns (bool success);
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
126 }
127 
128 /**
129  * @title Generic owned destroyable contract
130  */
131 contract Object is Owned {
132     /**
133     *  Common result code. Means everything is fine.
134     */
135     uint constant OK = 1;
136     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
137 
138     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
139         for(uint i=0;i<tokens.length;i++) {
140             address token = tokens[i];
141             uint balance = ERC20Interface(token).balanceOf(this);
142             if(balance != 0)
143                 ERC20Interface(token).transfer(_to,balance);
144         }
145         return OK;
146     }
147 
148     function checkOnlyContractOwner() internal constant returns(uint) {
149         if (contractOwner == msg.sender) {
150             return OK;
151         }
152 
153         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
154     }
155 }
156 
157 contract OracleContractAdapter is Object {
158 
159     event OracleAdded(address _oracle);
160     event OracleRemoved(address _oracle);
161 
162     mapping(address => bool) public oracles;
163 
164     /// @dev Allow access only for oracle
165     modifier onlyOracle {
166         if (oracles[msg.sender]) {
167             _;
168         }
169     }
170 
171     modifier onlyOracleOrOwner {
172         if (oracles[msg.sender] || msg.sender == contractOwner) {
173             _;
174         }
175     }
176 
177     /// @notice Add oracles to whitelist.
178     ///
179     /// @param _whitelist user list.
180     function addOracles(address[] _whitelist) 
181     onlyContractOwner 
182     external 
183     returns (uint) 
184     {
185         for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {
186             address _oracle = _whitelist[_idx];
187             if (_oracle != 0x0 && !oracles[_oracle]) {
188                 oracles[_oracle] = true;
189                 _emitOracleAdded(_oracle);
190             }
191         }
192         return OK;
193     }
194 
195     /// @notice Removes oracles from whitelist.
196     ///
197     /// @param _blacklist user in whitelist.
198     function removeOracles(address[] _blacklist) 
199     onlyContractOwner 
200     external 
201     returns (uint) 
202     {
203         for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {
204             address _oracle = _blacklist[_idx];
205             if (_oracle != 0x0 && oracles[_oracle]) {
206                 delete oracles[_oracle];
207                 _emitOracleRemoved(_oracle);
208             }
209         }
210         return OK;
211     }
212 
213     function _emitOracleAdded(address _oracle) internal {
214         OracleAdded(_oracle);
215     }
216 
217     function _emitOracleRemoved(address _oracle) internal {
218         OracleRemoved(_oracle);
219     }
220 }
221 
222 contract TreasuryEmitter {
223     event TreasuryDeposited(bytes32 userKey, uint value, uint lockupDate);
224     event TreasuryWithdrawn(bytes32 userKey, uint value);
225 }
226 
227 contract ERC20 {
228     event Transfer(address indexed from, address indexed to, uint256 value);
229     event Approval(address indexed from, address indexed spender, uint256 value);
230     string public symbol;
231 
232     function totalSupply() constant returns (uint256 supply);
233     function balanceOf(address _owner) constant returns (uint256 balance);
234     function transfer(address _to, uint256 _value) returns (bool success);
235     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
236     function approve(address _spender, uint256 _value) returns (bool success);
237     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
238 }
239 
240 
241 
242 
243 /// @title Treasury contract.
244 ///
245 /// Treasury for CCs deposits for particular fund with bmc-days calculations.
246 /// Accept BMC deposits from Continuous Contributors via oracle and
247 /// calculates bmc-days metric for each CC's role.
248 contract Treasury is OracleContractAdapter, ServiceAllowance, TreasuryEmitter {
249 
250     /* ERROR CODES */
251 
252     uint constant PERCENT_PRECISION = 10000;
253 
254     uint constant TREASURY_ERROR_SCOPE = 108000;
255     uint constant TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE = TREASURY_ERROR_SCOPE + 1;
256 
257     using SafeMath for uint;
258 
259     struct LockedDeposits {
260         uint counter;
261         mapping(uint => uint) index2Date;
262         mapping(uint => uint) date2deposit;
263     }
264 
265     struct Period {
266         uint transfersCount;
267         uint totalBmcDays;
268         uint bmcDaysPerDay;
269         uint startDate;
270         mapping(bytes32 => uint) user2bmcDays;
271         mapping(bytes32 => uint) user2lastTransferIdx;
272         mapping(bytes32 => uint) user2balance;
273         mapping(uint => uint) transfer2date;
274     }
275 
276     /* FIELDS */
277 
278     address token;
279     address profiterole;
280     uint periodsCount;
281 
282     mapping(uint => Period) periods;
283     mapping(uint => uint) periodDate2periodIdx;
284     mapping(bytes32 => uint) user2lastPeriodParticipated;
285     mapping(bytes32 => LockedDeposits) user2lockedDeposits;
286 
287     /* MODIFIERS */
288 
289     /// @dev Only profiterole contract allowed to invoke guarded functions
290     modifier onlyProfiterole {
291         require(profiterole == msg.sender);
292         _;
293     }
294 
295     /* PUBLIC */
296     
297     function Treasury(address _token) public {
298         require(address(_token) != 0x0);
299         token = _token;
300         periodsCount = 1;
301     }
302 
303     function init(address _profiterole) public onlyContractOwner returns (uint) {
304         require(_profiterole != 0x0);
305         profiterole = _profiterole;
306         return OK;
307     }
308 
309     /// @notice Do not accept Ether transfers
310     function() payable public {
311         revert();
312     }
313 
314     /* EXTERNAL */
315 
316     /// @notice Deposits tokens on behalf of users
317     /// Allowed only for oracle.
318     ///
319     /// @param _userKey aggregated user key (user ID + role ID)
320     /// @param _value amount of tokens to deposit
321     /// @param _feeAmount amount of tokens that will be taken from _value as fee
322     /// @param _feeAddress destination address for fee transfer
323     /// @param _lockupDate lock up date for deposit. Until that date the deposited value couldn't be withdrawn
324     ///
325     /// @return result code of an operation
326     function deposit(bytes32 _userKey, uint _value, uint _feeAmount, address _feeAddress, uint _lockupDate) external onlyOracle returns (uint) {
327         require(_userKey != bytes32(0));
328         require(_value != 0);
329         require(_feeAmount < _value);
330 
331         ERC20 _token = ERC20(token);
332         if (_token.allowance(msg.sender, address(this)) < _value) {
333             return TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE;
334         }
335 
336         uint _depositedAmount = _value - _feeAmount;
337         _makeDepositForPeriod(_userKey, _depositedAmount, _lockupDate);
338 
339         uint _periodsCount = periodsCount;
340         user2lastPeriodParticipated[_userKey] = _periodsCount;
341         delete periods[_periodsCount].startDate;
342 
343         if (!_token.transferFrom(msg.sender, address(this), _value)) {
344             revert();
345         }
346 
347         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
348             revert();
349         }
350 
351         TreasuryDeposited(_userKey, _depositedAmount, _lockupDate);
352         return OK;
353     }
354 
355     /// @notice Withdraws deposited tokens on behalf of users
356     /// Allowed only for oracle
357     ///
358     /// @param _userKey aggregated user key (user ID + role ID)
359     /// @param _value an amount of tokens that is requrested to withdraw
360     /// @param _withdrawAddress address to withdraw; should not be 0x0
361     /// @param _feeAmount amount of tokens that will be taken from _value as fee
362     /// @param _feeAddress destination address for fee transfer
363     ///
364     /// @return result of an operation
365     function withdraw(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {
366         require(_userKey != bytes32(0));
367         require(_value != 0);
368         require(_feeAmount < _value);
369 
370         _makeWithdrawForPeriod(_userKey, _value);
371         uint _periodsCount = periodsCount;
372         user2lastPeriodParticipated[_userKey] = periodsCount;
373         delete periods[_periodsCount].startDate;
374 
375         ERC20 _token = ERC20(token);
376         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
377             revert();
378         }
379 
380         uint _withdrawnAmount = _value - _feeAmount;
381         if (!_token.transfer(_withdrawAddress, _withdrawnAmount)) {
382             revert();
383         }
384 
385         TreasuryWithdrawn(_userKey, _withdrawnAmount);
386         return OK;
387     }
388 
389     /// @notice Gets shares (in percents) the user has on provided date
390     ///
391     /// @param _userKey aggregated user key (user ID + role ID)
392     /// @param _date date where period ends
393     ///
394     /// @return percent from total amount of bmc-days the treasury has on this date.
395     /// Use PERCENT_PRECISION to get right precision
396     function getSharesPercentForPeriod(bytes32 _userKey, uint _date) public view returns (uint) {
397         uint _periodIdx = periodDate2periodIdx[_date];
398         if (_date != 0 && _periodIdx == 0) {
399             return 0;
400         }
401 
402         if (_date == 0) {
403             _date = now;
404             _periodIdx = periodsCount;
405         }
406 
407         uint _bmcDays = _getBmcDaysAmountForUser(_userKey, _date, _periodIdx);
408         uint _totalBmcDeposit = _getTotalBmcDaysAmount(_date, _periodIdx);
409         return _totalBmcDeposit != 0 ? _bmcDays * PERCENT_PRECISION / _totalBmcDeposit : 0;
410     }
411 
412     /// @notice Gets user balance that is deposited
413     /// @param _userKey aggregated user key (user ID + role ID)
414     /// @return an amount of tokens deposited on behalf of user
415     function getUserBalance(bytes32 _userKey) public view returns (uint) {
416         uint _lastPeriodForUser = user2lastPeriodParticipated[_userKey];
417         if (_lastPeriodForUser == 0) {
418             return 0;
419         }
420 
421         if (_lastPeriodForUser <= periodsCount.sub(1)) {
422             return periods[_lastPeriodForUser].user2balance[_userKey];
423         }
424 
425         return periods[periodsCount].user2balance[_userKey];
426     }
427 
428     /// @notice Gets amount of locked deposits for user
429     /// @param _userKey aggregated user key (user ID + role ID)
430     /// @return an amount of tokens locked
431     function getLockedUserBalance(bytes32 _userKey) public returns (uint) {
432         return _syncLockedDepositsAmount(_userKey);
433     }
434 
435     /// @notice Gets list of locked up deposits with dates when they will be available to withdraw
436     /// @param _userKey aggregated user key (user ID + role ID)
437     /// @return {
438     ///     "_lockupDates": "list of lockup dates of deposits",
439     ///     "_deposits": "list of deposits"
440     /// }
441     function getLockedUserDeposits(bytes32 _userKey) public view returns (uint[] _lockupDates, uint[] _deposits) {
442         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
443         uint _lockedDepositsCounter = _lockedDeposits.counter;
444         _lockupDates = new uint[](_lockedDepositsCounter);
445         _deposits = new uint[](_lockedDepositsCounter);
446 
447         uint _pointer = 0;
448         for (uint _idx = 1; _idx < _lockedDepositsCounter; ++_idx) {
449             uint _lockDate = _lockedDeposits.index2Date[_idx];
450 
451             if (_lockDate > now) {
452                 _lockupDates[_pointer] = _lockDate;
453                 _deposits[_pointer] = _lockedDeposits.date2deposit[_lockDate];
454                 ++_pointer;
455             }
456         }
457     }
458 
459     /// @notice Gets total amount of bmc-day accumulated due provided date
460     /// @param _date date where period ends
461     /// @return an amount of bmc-days
462     function getTotalBmcDaysAmount(uint _date) public view returns (uint) {
463         return _getTotalBmcDaysAmount(_date, periodsCount);
464     }
465 
466     /// @notice Makes a checkpoint to start counting a new period
467     /// @dev Should be used only by Profiterole contract
468     function addDistributionPeriod() public onlyProfiterole returns (uint) {
469         uint _periodsCount = periodsCount;
470         uint _nextPeriod = _periodsCount.add(1);
471         periodDate2periodIdx[now] = _periodsCount;
472 
473         Period storage _previousPeriod = periods[_periodsCount];
474         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
475         periods[_nextPeriod].startDate = now;
476         periods[_nextPeriod].bmcDaysPerDay = _previousPeriod.bmcDaysPerDay;
477         periods[_nextPeriod].totalBmcDays = _totalBmcDeposit;
478         periodsCount = _nextPeriod;
479 
480         return OK;
481     }
482 
483     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
484         return true;
485     }
486 
487     /* INTERNAL */
488 
489     function _makeDepositForPeriod(bytes32 _userKey, uint _value, uint _lockupDate) internal {
490         Period storage _transferPeriod = periods[periodsCount];
491 
492         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, periodsCount);
493         _transferPeriod.totalBmcDays = _getTotalBmcDaysAmount(now, periodsCount);
494         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.add(_value);
495 
496         uint _userBalance = getUserBalance(_userKey);
497         uint _updatedTransfersCount = _transferPeriod.transfersCount.add(1);
498         _transferPeriod.transfersCount = _updatedTransfersCount;
499         _transferPeriod.transfer2date[_transferPeriod.transfersCount] = now;
500         _transferPeriod.user2balance[_userKey] = _userBalance.add(_value);
501         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransfersCount;
502 
503         _registerLockedDeposits(_userKey, _value, _lockupDate);
504     }
505 
506     function _makeWithdrawForPeriod(bytes32 _userKey, uint _value) internal {
507         uint _userBalance = getUserBalance(_userKey);
508         uint _lockedBalance = _syncLockedDepositsAmount(_userKey);
509         require(_userBalance.sub(_lockedBalance) >= _value);
510 
511         uint _periodsCount = periodsCount;
512         Period storage _transferPeriod = periods[_periodsCount];
513 
514         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, _periodsCount);
515         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
516         _transferPeriod.totalBmcDays = _totalBmcDeposit;
517         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.sub(_value);
518 
519         uint _updatedTransferCount = _transferPeriod.transfersCount.add(1);
520         _transferPeriod.transfer2date[_updatedTransferCount] = now;
521         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransferCount;
522         _transferPeriod.user2balance[_userKey] = _userBalance.sub(_value);
523         _transferPeriod.transfersCount = _updatedTransferCount;
524     }
525 
526     function _registerLockedDeposits(bytes32 _userKey, uint _amount, uint _lockupDate) internal {
527         if (_lockupDate <= now) {
528             return;
529         }
530 
531         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
532         uint _lockedBalance = _lockedDeposits.date2deposit[_lockupDate];
533 
534         if (_lockedBalance == 0) {
535             uint _lockedDepositsCounter = _lockedDeposits.counter.add(1);
536             _lockedDeposits.counter = _lockedDepositsCounter;
537             _lockedDeposits.index2Date[_lockedDepositsCounter] = _lockupDate;
538         }
539         _lockedDeposits.date2deposit[_lockupDate] = _lockedBalance.add(_amount);
540     }
541 
542     function _syncLockedDepositsAmount(bytes32 _userKey) internal returns (uint _lockedSum) {
543         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
544         uint _lockedDepositsCounter = _lockedDeposits.counter;
545 
546         for (uint _idx = 1; _idx <= _lockedDepositsCounter; ++_idx) {
547             uint _lockDate = _lockedDeposits.index2Date[_idx];
548 
549             if (_lockDate <= now) {
550                 _lockedDeposits.index2Date[_idx] = _lockedDeposits.index2Date[_lockedDepositsCounter];
551 
552                 delete _lockedDeposits.index2Date[_lockedDepositsCounter];
553                 delete _lockedDeposits.date2deposit[_lockDate];
554 
555                 _lockedDepositsCounter = _lockedDepositsCounter.sub(1);
556                 continue;
557             }
558 
559             _lockedSum = _lockedSum.add(_lockedDeposits.date2deposit[_lockDate]);
560         }
561 
562         _lockedDeposits.counter = _lockedDepositsCounter;
563     }
564 
565     function _getBmcDaysAmountForUser(bytes32 _userKey, uint _date, uint _periodIdx) internal view returns (uint) {
566         uint _lastPeriodForUserIdx = user2lastPeriodParticipated[_userKey];
567         if (_lastPeriodForUserIdx == 0) {
568             return 0;
569         }
570 
571         Period storage _transferPeriod = _lastPeriodForUserIdx <= _periodIdx ? periods[_lastPeriodForUserIdx] : periods[_periodIdx];
572         uint _lastTransferDate = _transferPeriod.transfer2date[_transferPeriod.user2lastTransferIdx[_userKey]];
573         // NOTE: It is an intended substraction separation to correctly round dates
574         uint _daysLong = (_date / 1 days) - (_lastTransferDate / 1 days);
575         uint _bmcDays = _transferPeriod.user2bmcDays[_userKey];
576         return _bmcDays.add(_transferPeriod.user2balance[_userKey] * _daysLong);
577     }
578 
579     /* PRIVATE */
580 
581     function _getTotalBmcDaysAmount(uint _date, uint _periodIdx) private view returns (uint) {
582         Period storage _depositPeriod = periods[_periodIdx];
583         uint _transfersCount = _depositPeriod.transfersCount;
584         uint _lastRecordedDate = _transfersCount != 0 ? _depositPeriod.transfer2date[_transfersCount] : _depositPeriod.startDate;
585 
586         if (_lastRecordedDate == 0) {
587             return 0;
588         }
589 
590         // NOTE: It is an intended substraction separation to correctly round dates
591         uint _daysLong = (_date / 1 days).sub((_lastRecordedDate / 1 days));
592         uint _totalBmcDeposit = _depositPeriod.totalBmcDays.add(_depositPeriod.bmcDaysPerDay.mul(_daysLong));
593         return _totalBmcDeposit;
594     }
595 }