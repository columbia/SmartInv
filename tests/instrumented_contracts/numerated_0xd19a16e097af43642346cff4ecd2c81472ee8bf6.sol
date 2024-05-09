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
180     function addOracles(address[] _whitelist) external onlyContractOwner returns (uint)    {
181         for (uint _idx = 0; _idx < _whitelist.length; ++_idx) {
182             address _oracle = _whitelist[_idx];
183             if (!oracles[_oracle]) {
184                 oracles[_oracle] = true;
185                 _emitOracleAdded(_oracle);
186             }
187         }
188         return OK;
189     }
190 
191     /// @notice Removes oracles from whitelist.
192     ///
193     /// @param _blacklist user in whitelist.
194     function removeOracles(address[] _blacklist) external onlyContractOwner returns (uint)    {
195         for (uint _idx = 0; _idx < _blacklist.length; ++_idx) {
196             address _oracle = _blacklist[_idx];
197             if (oracles[_oracle]) {
198                 delete oracles[_oracle];
199                 _emitOracleRemoved(_oracle);
200             }
201         }
202         return OK;
203     }
204 
205     function _emitOracleAdded(address _oracle) internal {
206         OracleAdded(_oracle);
207     }
208 
209     function _emitOracleRemoved(address _oracle) internal {
210         OracleRemoved(_oracle);
211     }
212 }
213 
214 contract TreasuryEmitter {
215     event TreasuryDeposited(bytes32 userKey, uint value, uint lockupDate);
216     event TreasuryWithdrawn(bytes32 userKey, uint value);
217 }
218 
219 contract ERC20 {
220     event Transfer(address indexed from, address indexed to, uint256 value);
221     event Approval(address indexed from, address indexed spender, uint256 value);
222     string public symbol;
223 
224     function totalSupply() constant returns (uint256 supply);
225     function balanceOf(address _owner) constant returns (uint256 balance);
226     function transfer(address _to, uint256 _value) returns (bool success);
227     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
228     function approve(address _spender, uint256 _value) returns (bool success);
229     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
230 }
231 
232 
233 
234 /// @title Treasury contract.
235 ///
236 /// Treasury for CCs deposits for particular fund with bmc-days calculations.
237 /// Accept BMC deposits from Continuous Contributors via oracle and
238 /// calculates bmc-days metric for each CC's role.
239 contract Treasury is OracleContractAdapter, ServiceAllowance, TreasuryEmitter {
240 
241     /* ERROR CODES */
242 
243     uint constant PERCENT_PRECISION = 10000;
244 
245     uint constant TREASURY_ERROR_SCOPE = 108000;
246     uint constant TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE = TREASURY_ERROR_SCOPE + 1;
247 
248     using SafeMath for uint;
249 
250     struct LockedDeposits {
251         uint counter;
252         mapping(uint => uint) index2Date;
253         mapping(uint => uint) date2deposit;
254     }
255 
256     struct Period {
257         uint transfersCount;
258         uint totalBmcDays;
259         uint bmcDaysPerDay;
260         uint startDate;
261         mapping(bytes32 => uint) user2bmcDays;
262         mapping(bytes32 => uint) user2lastTransferIdx;
263         mapping(bytes32 => uint) user2balance;
264         mapping(uint => uint) transfer2date;
265     }
266 
267     /* FIELDS */
268 
269     address token;
270     address profiterole;
271     uint periodsCount;
272 
273     mapping(uint => Period) periods;
274     mapping(uint => uint) periodDate2periodIdx;
275     mapping(bytes32 => uint) user2lastPeriodParticipated;
276     mapping(bytes32 => LockedDeposits) user2lockedDeposits;
277 
278     /* MODIFIERS */
279 
280     /// @dev Only profiterole contract allowed to invoke guarded functions
281     modifier onlyProfiterole {
282         require(profiterole == msg.sender);
283         _;
284     }
285 
286     /* PUBLIC */
287     
288     function Treasury(address _token) public {
289         require(address(_token) != 0x0);
290         token = _token;
291         periodsCount = 1;
292     }
293 
294     function init(address _profiterole) public onlyContractOwner returns (uint) {
295         require(_profiterole != 0x0);
296         profiterole = _profiterole;
297         return OK;
298     }
299 
300     /// @notice Do not accept Ether transfers
301     function() payable public {
302         revert();
303     }
304 
305     /* EXTERNAL */
306 
307     /// @notice Deposits tokens on behalf of users
308     /// Allowed only for oracle.
309     ///
310     /// @param _userKey aggregated user key (user ID + role ID)
311     /// @param _value amount of tokens to deposit
312     /// @param _feeAmount amount of tokens that will be taken from _value as fee
313     /// @param _feeAddress destination address for fee transfer
314     /// @param _lockupDate lock up date for deposit. Until that date the deposited value couldn't be withdrawn
315     ///
316     /// @return result code of an operation
317     function deposit(bytes32 _userKey, uint _value, uint _feeAmount, address _feeAddress, uint _lockupDate) external onlyOracle returns (uint) {
318         require(_userKey != bytes32(0));
319         require(_value != 0);
320         require(_feeAmount < _value);
321 
322         ERC20 _token = ERC20(token);
323         if (_token.allowance(msg.sender, address(this)) < _value) {
324             return TREASURY_ERROR_TOKEN_NOT_SET_ALLOWANCE;
325         }
326 
327         uint _depositedAmount = _value - _feeAmount;
328         _makeDepositForPeriod(_userKey, _depositedAmount, _lockupDate);
329 
330         uint _periodsCount = periodsCount;
331         user2lastPeriodParticipated[_userKey] = _periodsCount;
332         delete periods[_periodsCount].startDate;
333 
334         if (!_token.transferFrom(msg.sender, address(this), _value)) {
335             revert();
336         }
337 
338         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
339             revert();
340         }
341 
342         TreasuryDeposited(_userKey, _depositedAmount, _lockupDate);
343         return OK;
344     }
345 
346     /// @notice Withdraws deposited tokens on behalf of users
347     /// Allowed only for oracle
348     ///
349     /// @param _userKey aggregated user key (user ID + role ID)
350     /// @param _value an amount of tokens that is requrested to withdraw
351     /// @param _withdrawAddress address to withdraw; should not be 0x0
352     /// @param _feeAmount amount of tokens that will be taken from _value as fee
353     /// @param _feeAddress destination address for fee transfer
354     ///
355     /// @return result of an operation
356     function withdraw(bytes32 _userKey, uint _value, address _withdrawAddress, uint _feeAmount, address _feeAddress) external onlyOracle returns (uint) {
357         require(_userKey != bytes32(0));
358         require(_value != 0);
359         require(_feeAmount < _value);
360 
361         _makeWithdrawForPeriod(_userKey, _value);
362         uint _periodsCount = periodsCount;
363         user2lastPeriodParticipated[_userKey] = periodsCount;
364         delete periods[_periodsCount].startDate;
365 
366         ERC20 _token = ERC20(token);
367         if (!(_feeAddress == 0x0 || _feeAmount == 0 || _token.transfer(_feeAddress, _feeAmount))) {
368             revert();
369         }
370 
371         uint _withdrawnAmount = _value - _feeAmount;
372         if (!_token.transfer(_withdrawAddress, _withdrawnAmount)) {
373             revert();
374         }
375 
376         TreasuryWithdrawn(_userKey, _withdrawnAmount);
377         return OK;
378     }
379 
380     /// @notice Gets shares (in percents) the user has on provided date
381     ///
382     /// @param _userKey aggregated user key (user ID + role ID)
383     /// @param _date date where period ends
384     ///
385     /// @return percent from total amount of bmc-days the treasury has on this date.
386     /// Use PERCENT_PRECISION to get right precision
387     function getSharesPercentForPeriod(bytes32 _userKey, uint _date) public view returns (uint) {
388         uint _periodIdx = periodDate2periodIdx[_date];
389         if (_date != 0 && _periodIdx == 0) {
390             return 0;
391         }
392 
393         if (_date == 0) {
394             _date = now;
395             _periodIdx = periodsCount;
396         }
397 
398         uint _bmcDays = _getBmcDaysAmountForUser(_userKey, _date, _periodIdx);
399         uint _totalBmcDeposit = _getTotalBmcDaysAmount(_date, _periodIdx);
400         return _totalBmcDeposit != 0 ? _bmcDays * PERCENT_PRECISION / _totalBmcDeposit : 0;
401     }
402 
403     /// @notice Gets user balance that is deposited
404     /// @param _userKey aggregated user key (user ID + role ID)
405     /// @return an amount of tokens deposited on behalf of user
406     function getUserBalance(bytes32 _userKey) public view returns (uint) {
407         uint _lastPeriodForUser = user2lastPeriodParticipated[_userKey];
408         if (_lastPeriodForUser == 0) {
409             return 0;
410         }
411 
412         if (_lastPeriodForUser <= periodsCount.sub(1)) {
413             return periods[_lastPeriodForUser].user2balance[_userKey];
414         }
415 
416         return periods[periodsCount].user2balance[_userKey];
417     }
418 
419     /// @notice Gets amount of locked deposits for user
420     /// @param _userKey aggregated user key (user ID + role ID)
421     /// @return an amount of tokens locked
422     function getLockedUserBalance(bytes32 _userKey) public returns (uint) {
423         return _syncLockedDepositsAmount(_userKey);
424     }
425 
426     /// @notice Gets list of locked up deposits with dates when they will be available to withdraw
427     /// @param _userKey aggregated user key (user ID + role ID)
428     /// @return {
429     ///     "_lockupDates": "list of lockup dates of deposits",
430     ///     "_deposits": "list of deposits"
431     /// }
432     function getLockedUserDeposits(bytes32 _userKey) public view returns (uint[] _lockupDates, uint[] _deposits) {
433         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
434         uint _lockedDepositsCounter = _lockedDeposits.counter;
435         _lockupDates = new uint[](_lockedDepositsCounter);
436         _deposits = new uint[](_lockedDepositsCounter);
437 
438         uint _pointer = 0;
439         for (uint _idx = 1; _idx < _lockedDepositsCounter; ++_idx) {
440             uint _lockDate = _lockedDeposits.index2Date[_idx];
441 
442             if (_lockDate > now) {
443                 _lockupDates[_pointer] = _lockDate;
444                 _deposits[_pointer] = _lockedDeposits.date2deposit[_lockDate];
445                 ++_pointer;
446             }
447         }
448     }
449 
450     /// @notice Gets total amount of bmc-day accumulated due provided date
451     /// @param _date date where period ends
452     /// @return an amount of bmc-days
453     function getTotalBmcDaysAmount(uint _date) public view returns (uint) {
454         return _getTotalBmcDaysAmount(_date, periodsCount);
455     }
456 
457     /// @notice Makes a checkpoint to start counting a new period
458     /// @dev Should be used only by Profiterole contract
459     function addDistributionPeriod() public onlyProfiterole returns (uint) {
460         uint _periodsCount = periodsCount;
461         uint _nextPeriod = _periodsCount.add(1);
462         periodDate2periodIdx[now] = _periodsCount;
463 
464         Period storage _previousPeriod = periods[_periodsCount];
465         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
466         periods[_nextPeriod].startDate = now;
467         periods[_nextPeriod].bmcDaysPerDay = _previousPeriod.bmcDaysPerDay;
468         periods[_nextPeriod].totalBmcDays = _totalBmcDeposit;
469         periodsCount = _nextPeriod;
470 
471         return OK;
472     }
473 
474     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
475         return true;
476     }
477 
478     /* INTERNAL */
479 
480     function _makeDepositForPeriod(bytes32 _userKey, uint _value, uint _lockupDate) internal {
481         Period storage _transferPeriod = periods[periodsCount];
482 
483         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, periodsCount);
484         _transferPeriod.totalBmcDays = _getTotalBmcDaysAmount(now, periodsCount);
485         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.add(_value);
486 
487         uint _userBalance = getUserBalance(_userKey);
488         uint _updatedTransfersCount = _transferPeriod.transfersCount.add(1);
489         _transferPeriod.transfersCount = _updatedTransfersCount;
490         _transferPeriod.transfer2date[_transferPeriod.transfersCount] = now;
491         _transferPeriod.user2balance[_userKey] = _userBalance.add(_value);
492         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransfersCount;
493 
494         _registerLockedDeposits(_userKey, _value, _lockupDate);
495     }
496 
497     function _makeWithdrawForPeriod(bytes32 _userKey, uint _value) internal {
498         uint _userBalance = getUserBalance(_userKey);
499         uint _lockedBalance = _syncLockedDepositsAmount(_userKey);
500         require(_userBalance.sub(_lockedBalance) >= _value);
501 
502         uint _periodsCount = periodsCount;
503         Period storage _transferPeriod = periods[_periodsCount];
504 
505         _transferPeriod.user2bmcDays[_userKey] = _getBmcDaysAmountForUser(_userKey, now, _periodsCount);
506         uint _totalBmcDeposit = _getTotalBmcDaysAmount(now, _periodsCount);
507         _transferPeriod.totalBmcDays = _totalBmcDeposit;
508         _transferPeriod.bmcDaysPerDay = _transferPeriod.bmcDaysPerDay.sub(_value);
509 
510         uint _updatedTransferCount = _transferPeriod.transfersCount.add(1);
511         _transferPeriod.transfer2date[_updatedTransferCount] = now;
512         _transferPeriod.user2lastTransferIdx[_userKey] = _updatedTransferCount;
513         _transferPeriod.user2balance[_userKey] = _userBalance.sub(_value);
514         _transferPeriod.transfersCount = _updatedTransferCount;
515     }
516 
517     function _registerLockedDeposits(bytes32 _userKey, uint _amount, uint _lockupDate) internal {
518         if (_lockupDate <= now) {
519             return;
520         }
521 
522         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
523         uint _lockedBalance = _lockedDeposits.date2deposit[_lockupDate];
524 
525         if (_lockedBalance == 0) {
526             uint _lockedDepositsCounter = _lockedDeposits.counter.add(1);
527             _lockedDeposits.counter = _lockedDepositsCounter;
528             _lockedDeposits.index2Date[_lockedDepositsCounter] = _lockupDate;
529         }
530         _lockedDeposits.date2deposit[_lockupDate] = _lockedBalance.add(_amount);
531     }
532 
533     function _syncLockedDepositsAmount(bytes32 _userKey) internal returns (uint _lockedSum) {
534         LockedDeposits storage _lockedDeposits = user2lockedDeposits[_userKey];
535         uint _lockedDepositsCounter = _lockedDeposits.counter;
536 
537         for (uint _idx = 1; _idx <= _lockedDepositsCounter; ++_idx) {
538             uint _lockDate = _lockedDeposits.index2Date[_idx];
539 
540             if (_lockDate <= now) {
541                 _lockedDeposits.index2Date[_idx] = _lockedDeposits.index2Date[_lockedDepositsCounter];
542 
543                 delete _lockedDeposits.index2Date[_lockedDepositsCounter];
544                 delete _lockedDeposits.date2deposit[_lockDate];
545 
546                 _lockedDepositsCounter = _lockedDepositsCounter.sub(1);
547                 continue;
548             }
549 
550             _lockedSum = _lockedSum.add(_lockedDeposits.date2deposit[_lockDate]);
551         }
552 
553         _lockedDeposits.counter = _lockedDepositsCounter;
554     }
555 
556     function _getBmcDaysAmountForUser(bytes32 _userKey, uint _date, uint _periodIdx) internal view returns (uint) {
557         uint _lastPeriodForUserIdx = user2lastPeriodParticipated[_userKey];
558         if (_lastPeriodForUserIdx == 0) {
559             return 0;
560         }
561 
562         Period storage _transferPeriod = _lastPeriodForUserIdx <= _periodIdx ? periods[_lastPeriodForUserIdx] : periods[_periodIdx];
563         uint _lastTransferDate = _transferPeriod.transfer2date[_transferPeriod.user2lastTransferIdx[_userKey]];
564         // NOTE: It is an intended substraction separation to correctly round dates
565         uint _daysLong = (_date / 1 days) - (_lastTransferDate / 1 days);
566         uint _bmcDays = _transferPeriod.user2bmcDays[_userKey];
567         return _bmcDays.add(_transferPeriod.user2balance[_userKey] * _daysLong);
568     }
569 
570     /* PRIVATE */
571 
572     function _getTotalBmcDaysAmount(uint _date, uint _periodIdx) private view returns (uint) {
573         Period storage _depositPeriod = periods[_periodIdx];
574         uint _transfersCount = _depositPeriod.transfersCount;
575         uint _lastRecordedDate = _transfersCount != 0 ? _depositPeriod.transfer2date[_transfersCount] : _depositPeriod.startDate;
576 
577         if (_lastRecordedDate == 0) {
578             return 0;
579         }
580 
581         // NOTE: It is an intended substraction separation to correctly round dates
582         uint _daysLong = (_date / 1 days).sub((_lastRecordedDate / 1 days));
583         uint _totalBmcDeposit = _depositPeriod.totalBmcDays.add(_depositPeriod.bmcDaysPerDay.mul(_daysLong));
584         return _totalBmcDeposit;
585     }
586 }