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
227 
228 contract ERC20 {
229     event Transfer(address indexed from, address indexed to, uint256 value);
230     event Approval(address indexed from, address indexed spender, uint256 value);
231     string public symbol;
232 
233     function totalSupply() constant returns (uint256 supply);
234     function balanceOf(address _owner) constant returns (uint256 balance);
235     function transfer(address _to, uint256 _value) returns (bool success);
236     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
237     function approve(address _spender, uint256 _value) returns (bool success);
238     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
239 }
240 
241 
242 
243 
244 /// @title Treasury contract.
245 ///
246 /// Treasury for CCs deposits for particular fund with bmc-days calculations.
247 /// Accept BMC deposits from Continuous Contributors via oracle and
248 /// calculates bmc-days metric for each CC's role.
249 contract Treasury is OracleContractAdapter, ServiceAllowance, TreasuryEmitter {
250 
251     /* ERROR CODES */
252 
253     uint constant PERCENT_PRECISION = 10000;
254 
255     uint constant TREASURY_ERROR_SCOPE = 108000;
256     uint constant TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE = TREASURY_ERROR_SCOPE + 1;
257 
258     using SafeMath for uint;
259 
260     struct LockedDeposits {
261         uint counter;
262         mapping(uint => uint) index2Date;
263         mapping(uint => uint) date2deposit;
264     }
265 
266     struct Period {
267         uint transfersCount;
268         uint totalBmcDays;
269         uint bmcDaysPerDay;
270         uint startDate;
271         mapping(bytes32 => uint) user2bmcDays;
272         mapping(bytes32 => uint) user2lastTransferIdx;
273         mapping(bytes32 => uint) user2balance;
274         mapping(uint => uint) transfer2date;
275     }
276 
277     /* FIELDS */
278 
279     address token;
280     address profiterole;
281     uint periodsCount;
282 
283     mapping(uint => Period) periods;
284     mapping(uint => uint) periodDate2periodIdx;
285     mapping(bytes32 => uint) user2lastPeriodParticipated;
286     mapping(bytes32 => LockedDeposits) user2lockedDeposits;
287 
288     /* MODIFIERS */
289 
290     /// @dev Only profiterole contract allowed to invoke guarded functions
291     modifier onlyProfiterole {
292         require(profiterole == msg.sender);
293         _;
294     }
295 
296     /* PUBLIC */
297     
298     function Treasury(address _token) public {
299         require(address(_token) != 0x0);
300         token = _token;
301         periodsCount = 1;
302     }
303 
304     function init(address _profiterole) public onlyContractOwner returns (uint) {
305         require(_profiterole != 0x0);
306         profiterole = _profiterole;
307         return OK;
308     }
309 
310     /// @notice Do not accept Ether transfers
311     function() payable public {
312         revert();
313     }
314 
315     /* EXTERNAL */
316 
317     /// @notice Deposits tokens on behalf of users
318     /// Allowed only for oracle.
319     ///
320     /// @param _userKey aggregated user key (user ID + role ID)
321     /// @param _value amount of tokens to deposit
322     /// @param _feeAmount amount of tokens that will be taken from _value as fee
323     /// @param _feeAddress destination address for fee transfer
324     /// @param _lockupDate lock up date for deposit. Until that date the deposited value couldn't be withdrawn
325     ///
326     /// @return result code of an operation
327     function deposit(bytes32 _userKey, uint _value, uint _feeAmount, address _feeAddress, uint _lockupDate) external onlyOracle returns (uint) {
328         require(_userKey != bytes32(0));
329         require(_value != 0);
330         require(_feeAmount < _value);
331 
332         ERC20 _token = ERC20(token);
333         if (_token.allowance(msg.sender, address(this)) < _value) {
334             return TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE;
335         }
336 
337         uint _depositedAmount = _value - _feeAmount;
338         _makeDepositForPeriod(_userKey, _depositedAmount, _lockupDate);
339 
340         uint _periodsCount = periodsCount;
341         user2lastPeriodParticipated[_userKey] = _periodsCount;
342         delete periods[_periodsCount].startDate;
343 
344         if (!_token.transferFrom(msg.sender, address(this), _value)) {
345             revert();
346         }
347 
348         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
349             revert();
350         }
351 
352         TreasuryDeposited(_userKey, _depositedAmount, _lockupDate);
353         return OK;
354     }
355 
356     /// @notice Withdraws deposited tokens on behalf of users
357     /// Allowed only for oracle
358     ///
359     /// @param _userKey aggregated user key (user ID + role ID)
360     /// @param _value an amount of tokens that is requrested to withdraw
361     /// @param _withdrawAddress address to withdraw; should not be 0x0
362     /// @param _feeAmount amount of tokens that will be taken from _value as fee
363     /// @param _feeAddress destination address for fee transfer
364     ///
365     /// @return result of an operation
366     function withdraw(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {
367         require(_userKey != bytes32(0));
368         require(_value != 0);
369         require(_feeAmount < _value);
370 
371         _makeWithdrawForPeriod(_userKey, _value);
372         uint _periodsCount = periodsCount;
373         user2lastPeriodParticipated[_userKey] = periodsCount;
374         delete periods[_periodsCount].startDate;
375 
376         ERC20 _token = ERC20(token);
377         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
378             revert();
379         }
380 
381         uint _withdrawnAmount = _value - _feeAmount;
382         if (!_token.transfer(_withdrawAddress, _withdrawnAmount)) {
383             revert();
384         }
385 
386         TreasuryWithdrawn(_userKey, _withdrawnAmount);
387         return OK;
388     }
389 
390     /// @notice Gets shares (in percents) the user has on provided date
391     ///
392     /// @param _userKey aggregated user key (user ID + role ID)
393     /// @param _date date where period ends
394     ///
395     /// @return percent from total amount of bmc-days the treasury has on this date.
396     /// Use PERCENT_PRECISION to get right precision
397     function getSharesPercentForPeriod(bytes32 _userKey, uint _date) public view returns (uint) {
398         uint _periodIdx = periodDate2periodIdx[_date];
399         if (_date != 0 && _periodIdx == 0) {
400             return 0;
401         }
402 
403         if (_date == 0) {
404             _date = now;
405             _periodIdx = periodsCount;
406         }
407 
408         uint _bmcDays = _getBmcDaysAmountForUser(_userKey, _date, _periodIdx);
409         uint _totalBmcDeposit = _getTotalBmcDaysAmount(_date, _periodIdx);
410         return _totalBmcDeposit != 0 ? _bmcDays * PERCENT_PRECISION / _totalBmcDeposit : 0;
411     }
412 
413     /// @notice Gets user balance that is deposited
414     /// @param _userKey aggregated user key (user ID + role ID)
415     /// @return an amount of tokens deposited on behalf of user
416     function getUserBalance(bytes32 _userKey) public view returns (uint) {
417         uint _lastPeriodForUser = user2lastPeriodParticipated[_userKey];
418         if (_lastPeriodForUser == 0) {
419             return 0;
420         }
421 
422         if (_lastPeriodForUser <= periodsCount.sub(1)) {
423             return periods[_lastPeriodForUser].user2balance[_userKey];
424         }
425 
426         return periods[periodsCount].user2balance[_userKey];
427     }
428 
429     /// @notice Gets amount of locked deposits for user
430     /// @param _userKey aggregated user key (user ID + role ID)
431     /// @return an amount of tokens locked
432     function getLockedUserBalance(bytes32 _userKey) public returns (uint) {
433         return _syncLockedDepositsAmount(_userKey);
434     }
435 
436     /// @notice Gets list of locked up deposits with dates when they will be available to withdraw
437     /// @param _userKey aggregated user key (user ID + role ID)
438     /// @return {
439     ///     "_lockupDates": "list of lockup dates of deposits",
440     ///     "_deposits": "list of deposits"
441     /// }
442     function getLockedUserDeposits(bytes32 _userKey) public view returns (uint[] _lockupDates, uint[] _deposits) {
443         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
444         uint _lockedDepositsCounter = _lockedDeposits.counter;
445         _lockupDates = new uint[](_lockedDepositsCounter);
446         _deposits = new uint[](_lockedDepositsCounter);
447 
448         uint _pointer = 0;
449         for (uint _idx = 1; _idx < _lockedDepositsCounter; ++_idx) {
450             uint _lockDate = _lockedDeposits.index2Date[_idx];
451 
452             if (_lockDate > now) {
453                 _lockupDates[_pointer] = _lockDate;
454                 _deposits[_pointer] = _lockedDeposits.date2deposit[_lockDate];
455                 ++_pointer;
456             }
457         }
458     }
459 
460     /// @notice Gets total amount of bmc-day accumulated due provided date
461     /// @param _date date where period ends
462     /// @return an amount of bmc-days
463     function getTotalBmcDaysAmount(uint _date) public view returns (uint) {
464         return _getTotalBmcDaysAmount(_date, periodsCount);
465     }
466 
467     /// @notice Makes a checkpoint to start counting a new period
468     /// @dev Should be used only by Profiterole contract
469     function addDistributionPeriod() public onlyProfiterole returns (uint) {
470         uint _periodsCount = periodsCount;
471         uint _nextPeriod = _periodsCount.add(1);
472         periodDate2periodIdx[now] = _periodsCount;
473 
474         Period storage _previousPeriod = periods[_periodsCount];
475         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
476         periods[_nextPeriod].startDate = now;
477         periods[_nextPeriod].bmcDaysPerDay = _previousPeriod.bmcDaysPerDay;
478         periods[_nextPeriod].totalBmcDays = _totalBmcDeposit;
479         periodsCount = _nextPeriod;
480 
481         return OK;
482     }
483 
484     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
485         return true;
486     }
487 
488     /* INTERNAL */
489 
490     function _makeDepositForPeriod(bytes32 _userKey, uint _value, uint _lockupDate) internal {
491         Period storage _transferPeriod = periods[periodsCount];
492 
493         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, periodsCount);
494         _transferPeriod.totalBmcDays = _getTotalBmcDaysAmount(now, periodsCount);
495         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.add(_value);
496 
497         uint _userBalance = getUserBalance(_userKey);
498         uint _updatedTransfersCount = _transferPeriod.transfersCount.add(1);
499         _transferPeriod.transfersCount = _updatedTransfersCount;
500         _transferPeriod.transfer2date[_transferPeriod.transfersCount] = now;
501         _transferPeriod.user2balance[_userKey] = _userBalance.add(_value);
502         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransfersCount;
503 
504         _registerLockedDeposits(_userKey, _value, _lockupDate);
505     }
506 
507     function _makeWithdrawForPeriod(bytes32 _userKey, uint _value) internal {
508         uint _userBalance = getUserBalance(_userKey);
509         uint _lockedBalance = _syncLockedDepositsAmount(_userKey);
510         require(_userBalance.sub(_lockedBalance) >= _value);
511 
512         uint _periodsCount = periodsCount;
513         Period storage _transferPeriod = periods[_periodsCount];
514 
515         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, _periodsCount);
516         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
517         _transferPeriod.totalBmcDays = _totalBmcDeposit;
518         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.sub(_value);
519 
520         uint _updatedTransferCount = _transferPeriod.transfersCount.add(1);
521         _transferPeriod.transfer2date[_updatedTransferCount] = now;
522         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransferCount;
523         _transferPeriod.user2balance[_userKey] = _userBalance.sub(_value);
524         _transferPeriod.transfersCount = _updatedTransferCount;
525     }
526 
527     function _registerLockedDeposits(bytes32 _userKey, uint _amount, uint _lockupDate) internal {
528         if (_lockupDate <= now) {
529             return;
530         }
531 
532         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
533         uint _lockedBalance = _lockedDeposits.date2deposit[_lockupDate];
534 
535         if (_lockedBalance == 0) {
536             uint _lockedDepositsCounter = _lockedDeposits.counter.add(1);
537             _lockedDeposits.counter = _lockedDepositsCounter;
538             _lockedDeposits.index2Date[_lockedDepositsCounter] = _lockupDate;
539         }
540         _lockedDeposits.date2deposit[_lockupDate] = _lockedBalance.add(_amount);
541     }
542 
543     function _syncLockedDepositsAmount(bytes32 _userKey) internal returns (uint _lockedSum) {
544         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
545         uint _lockedDepositsCounter = _lockedDeposits.counter;
546 
547         for (uint _idx = 1; _idx <= _lockedDepositsCounter; ++_idx) {
548             uint _lockDate = _lockedDeposits.index2Date[_idx];
549 
550             if (_lockDate <= now) {
551                 _lockedDeposits.index2Date[_idx] = _lockedDeposits.index2Date[_lockedDepositsCounter];
552 
553                 delete _lockedDeposits.index2Date[_lockedDepositsCounter];
554                 delete _lockedDeposits.date2deposit[_lockDate];
555 
556                 _lockedDepositsCounter = _lockedDepositsCounter.sub(1);
557                 continue;
558             }
559 
560             _lockedSum = _lockedSum.add(_lockedDeposits.date2deposit[_lockDate]);
561         }
562 
563         _lockedDeposits.counter = _lockedDepositsCounter;
564     }
565 
566     function _getBmcDaysAmountForUser(bytes32 _userKey, uint _date, uint _periodIdx) internal view returns (uint) {
567         uint _lastPeriodForUserIdx = user2lastPeriodParticipated[_userKey];
568         if (_lastPeriodForUserIdx == 0) {
569             return 0;
570         }
571 
572         Period storage _transferPeriod = _lastPeriodForUserIdx <= _periodIdx ? periods[_lastPeriodForUserIdx] : periods[_periodIdx];
573         uint _lastTransferDate = _transferPeriod.transfer2date[_transferPeriod.user2lastTransferIdx[_userKey]];
574         // NOTE: It is an intended substraction separation to correctly round dates
575         uint _daysLong = (_date / 1 days) - (_lastTransferDate / 1 days);
576         uint _bmcDays = _transferPeriod.user2bmcDays[_userKey];
577         return _bmcDays.add(_transferPeriod.user2balance[_userKey] * _daysLong);
578     }
579 
580     /* PRIVATE */
581 
582     function _getTotalBmcDaysAmount(uint _date, uint _periodIdx) private view returns (uint) {
583         Period storage _depositPeriod = periods[_periodIdx];
584         uint _transfersCount = _depositPeriod.transfersCount;
585         uint _lastRecordedDate = _transfersCount != 0 ? _depositPeriod.transfer2date[_transfersCount] : _depositPeriod.startDate;
586 
587         if (_lastRecordedDate == 0) {
588             return 0;
589         }
590 
591         // NOTE: It is an intended substraction separation to correctly round dates
592         uint _daysLong = (_date / 1 days).sub((_lastRecordedDate / 1 days));
593         uint _totalBmcDeposit = _depositPeriod.totalBmcDays.add(_depositPeriod.bmcDaysPerDay.mul(_daysLong));
594         return _totalBmcDeposit;
595     }
596 }