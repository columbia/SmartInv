1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   // replace with proper zeppelin smart contract
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     if (msg.sender != owner)
13       throw;
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0))
19       owner = newOwner;
20   }
21 }
22 
23 
24 contract Destructable is Ownable {
25   function selfdestruct() external onlyOwner {
26     // free ethereum network state when done
27     selfdestruct(owner);
28   }
29 }
30 
31 
32 contract Math {
33   // scale of the emulated fixed point operations
34   uint constant public FP_SCALE = 10000;
35 
36   // todo: should be a library
37   function divRound(uint v, uint d) internal constant returns(uint) {
38     // round up if % is half or more
39     return (v + (d/2)) / d;
40   }
41 
42   function absDiff(uint v1, uint v2) public constant returns(uint) {
43     return v1 > v2 ? v1 - v2 : v2 - v1;
44   }
45 
46   function safeMul(uint a, uint b) public constant returns (uint) {
47     uint c = a * b;
48     if (a == 0 || c / a == b)
49       return c;
50     else
51       throw;
52   }
53 
54   function safeAdd(uint a, uint b) internal constant returns (uint) {
55     uint c = a + b;
56     if (!(c>=a && c>=b))
57       throw;
58     return c;
59   }
60 }
61 
62 
63 contract TimeSource {
64   uint32 private mockNow;
65 
66   function currentTime() public constant returns (uint32) {
67     // we do not support dates much into future (Sun, 07 Feb 2106 06:28:15 GMT)
68     if (block.timestamp > 0xFFFFFFFF)
69       throw;
70     return mockNow > 0 ? mockNow : uint32(block.timestamp);
71   }
72 
73   function mockTime(uint32 t) public {
74     // no mocking on mainnet
75     if (block.number > 3316029)
76       throw;
77     mockNow = t;
78   }
79 }
80 
81 
82 contract BaseOptionsConverter {
83 
84   // modifiers are inherited, check `owned` pattern
85   //   http://solidity.readthedocs.io/en/develop/contracts.html#function-modifiers
86   modifier onlyESOP() {
87     if (msg.sender != getESOP())
88       throw;
89     _;
90   }
91 
92   // returns ESOP address which is a sole executor of exerciseOptions function
93   function getESOP() public constant returns (address);
94   // deadline for employees to exercise options
95   function getExercisePeriodDeadline() public constant returns (uint32);
96 
97   // exercise of options for given employee and amount, please note that employee address may be 0
98   // .. in which case the intention is to burn options
99   function exerciseOptions(address employee, uint poolOptions, uint extraOptions, uint bonusOptions,
100     bool agreeToAcceleratedVestingBonusConditions) onlyESOP public;
101 }
102 
103 contract ESOPTypes {
104   // enums are numbered starting from 0. NotSet is used to check for non existing mapping
105   enum EmployeeState { NotSet, WaitingForSignature, Employed, Terminated, OptionsExercised }
106   // please note that 32 bit unsigned int is used to represent UNIX time which is enough to represent dates until Sun, 07 Feb 2106 06:28:15 GMT
107   // storage access is optimized so struct layout is important
108   struct Employee {
109       // when vesting starts
110       uint32 issueDate;
111       // wait for employee signature until that time
112       uint32 timeToSign;
113       // date when employee was terminated, 0 for not terminated
114       uint32 terminatedAt;
115       // when fade out starts, 0 for not set, initally == terminatedAt
116       // used only when calculating options returned to pool
117       uint32 fadeoutStarts;
118       // poolOptions employee gets (exit bonus not included)
119       uint32 poolOptions;
120       // extra options employee gets (neufund will not this option)
121       uint32 extraOptions;
122       // time at which employee got suspended, 0 - not suspended
123       uint32 suspendedAt;
124       // what is employee current status, takes 8 bit in storage
125       EmployeeState state;
126       // index in iterable mapping
127       uint16 idx;
128       // reserve until full 256 bit word
129       //uint24 reserved;
130   }
131 
132   function serializeEmployee(Employee memory employee)
133     internal
134     constant
135     returns(uint[9] emp)
136   {
137       // guess what: struct layout in memory is aligned to word (256 bits)
138       // struct in storage is byte aligned
139       assembly {
140         // return memory aligned struct as array of words
141         // I just wonder when 'employee' memory is deallocated
142         // answer: memory is not deallocated until transaction ends
143         emp := employee
144       }
145   }
146 
147   function deserializeEmployee(uint[9] serializedEmployee)
148     internal
149     constant
150     returns (Employee memory emp)
151   {
152       assembly { emp := serializedEmployee }
153   }
154 }
155 
156 
157 contract CodeUpdateable is Ownable {
158     // allows to stop operations and migrate data to different contract
159     enum CodeUpdateState { CurrentCode, OngoingUpdate /*, CodeUpdated*/}
160     CodeUpdateState public codeUpdateState;
161 
162     modifier isCurrentCode() {
163       if (codeUpdateState != CodeUpdateState.CurrentCode)
164         throw;
165       _;
166     }
167 
168     modifier inCodeUpdate() {
169       if (codeUpdateState != CodeUpdateState.OngoingUpdate)
170         throw;
171       _;
172     }
173 
174     function beginCodeUpdate() public onlyOwner isCurrentCode {
175       codeUpdateState = CodeUpdateState.OngoingUpdate;
176     }
177 
178     function cancelCodeUpdate() public onlyOwner inCodeUpdate {
179       codeUpdateState = CodeUpdateState.CurrentCode;
180     }
181 
182     function completeCodeUpdate() public onlyOwner inCodeUpdate {
183       selfdestruct(owner);
184     }
185 }
186 
187 contract EmployeesList is ESOPTypes, Ownable, Destructable {
188   event CreateEmployee(address indexed e, uint32 poolOptions, uint32 extraOptions, uint16 idx);
189   event UpdateEmployee(address indexed e, uint32 poolOptions, uint32 extraOptions, uint16 idx);
190   event ChangeEmployeeState(address indexed e, EmployeeState oldState, EmployeeState newState);
191   event RemoveEmployee(address indexed e);
192   mapping (address => Employee) employees;
193   // addresses in the mapping, ever
194   address[] public addresses;
195 
196   function size() external constant returns (uint16) {
197     return uint16(addresses.length);
198   }
199 
200   function setEmployee(address e, uint32 issueDate, uint32 timeToSign, uint32 terminatedAt, uint32 fadeoutStarts,
201     uint32 poolOptions, uint32 extraOptions, uint32 suspendedAt, EmployeeState state)
202     external
203     onlyOwner
204     returns (bool isNew)
205   {
206     uint16 empIdx = employees[e].idx;
207     if (empIdx == 0) {
208       // new element
209       uint size = addresses.length;
210       if (size == 0xFFFF)
211         throw;
212       isNew = true;
213       empIdx = uint16(size + 1);
214       addresses.push(e);
215       CreateEmployee(e, poolOptions, extraOptions, empIdx);
216     } else {
217       isNew = false;
218       UpdateEmployee(e, poolOptions, extraOptions, empIdx);
219     }
220     employees[e] = Employee({
221         issueDate: issueDate,
222         timeToSign: timeToSign,
223         terminatedAt: terminatedAt,
224         fadeoutStarts: fadeoutStarts,
225         poolOptions: poolOptions,
226         extraOptions: extraOptions,
227         suspendedAt: suspendedAt,
228         state: state,
229         idx: empIdx
230       });
231   }
232 
233   function changeState(address e, EmployeeState state)
234     external
235     onlyOwner
236   {
237     if (employees[e].idx == 0)
238       throw;
239     ChangeEmployeeState(e, employees[e].state, state);
240     employees[e].state = state;
241   }
242 
243   function setFadeoutStarts(address e, uint32 fadeoutStarts)
244     external
245     onlyOwner
246   {
247     if (employees[e].idx == 0)
248       throw;
249     UpdateEmployee(e, employees[e].poolOptions, employees[e].extraOptions, employees[e].idx);
250     employees[e].fadeoutStarts = fadeoutStarts;
251   }
252 
253   function removeEmployee(address e)
254     external
255     onlyOwner
256     returns (bool)
257   {
258     uint16 empIdx = employees[e].idx;
259     if (empIdx > 0) {
260         delete employees[e];
261         delete addresses[empIdx-1];
262         RemoveEmployee(e);
263         return true;
264     }
265     return false;
266   }
267 
268   function terminateEmployee(address e, uint32 issueDate, uint32 terminatedAt, uint32 fadeoutStarts, EmployeeState state)
269     external
270     onlyOwner
271   {
272     if (state != EmployeeState.Terminated)
273         throw;
274     Employee employee = employees[e]; // gets reference to storage and optimizer does it with one SSTORE
275     if (employee.idx == 0)
276       throw;
277     ChangeEmployeeState(e, employee.state, state);
278     employee.state = state;
279     employee.issueDate = issueDate;
280     employee.terminatedAt = terminatedAt;
281     employee.fadeoutStarts = fadeoutStarts;
282     employee.suspendedAt = 0;
283     UpdateEmployee(e, employee.poolOptions, employee.extraOptions, employee.idx);
284   }
285 
286   function getEmployee(address e)
287     external
288     constant
289     returns (uint32, uint32, uint32, uint32, uint32, uint32, uint32, EmployeeState)
290   {
291       Employee employee = employees[e];
292       if (employee.idx == 0)
293         throw;
294       // where is struct zip/unzip :>
295       return (employee.issueDate, employee.timeToSign, employee.terminatedAt, employee.fadeoutStarts,
296         employee.poolOptions, employee.extraOptions, employee.suspendedAt, employee.state);
297   }
298 
299    function hasEmployee(address e)
300      external
301      constant
302      returns (bool)
303    {
304       // this is very inefficient - whole word is loaded just to check this
305       return employees[e].idx != 0;
306     }
307 
308   function getSerializedEmployee(address e)
309     external
310     constant
311     returns (uint[9])
312   {
313     Employee memory employee = employees[e];
314     if (employee.idx == 0)
315       throw;
316     return serializeEmployee(employee);
317   }
318 }
319 
320 
321 contract ERC20OptionsConverter is BaseOptionsConverter, TimeSource, Math {
322   // see base class for explanations
323   address esopAddress;
324   uint32 exercisePeriodDeadline;
325   // balances for converted options
326   mapping(address => uint) internal balances;
327   // total supply
328   uint public totalSupply;
329 
330   // deadline for all options conversion including company's actions
331   uint32 public optionsConversionDeadline;
332 
333   event Transfer(address indexed from, address indexed to, uint value);
334 
335   modifier converting() {
336     // throw after deadline
337     if (currentTime() >= exercisePeriodDeadline)
338       throw;
339     _;
340   }
341 
342   modifier converted() {
343     // throw before deadline
344     if (currentTime() < optionsConversionDeadline)
345       throw;
346     _;
347   }
348 
349 
350   function getESOP() public constant returns (address) {
351     return esopAddress;
352   }
353 
354   function getExercisePeriodDeadline() public constant returns(uint32) {
355     return exercisePeriodDeadline;
356   }
357 
358   function exerciseOptions(address employee, uint poolOptions, uint extraOptions, uint bonusOptions,
359     bool agreeToAcceleratedVestingBonusConditions)
360     public
361     onlyESOP
362     converting
363   {
364     // if no overflow on totalSupply, no overflows later
365     uint options = safeAdd(safeAdd(poolOptions, extraOptions), bonusOptions);
366     totalSupply = safeAdd(totalSupply, options);
367     balances[employee] += options;
368     Transfer(0, employee, options);
369   }
370 
371   function transfer(address _to, uint _value) converted public {
372     if (balances[msg.sender] < _value)
373       throw;
374     balances[msg.sender] -= _value;
375     balances[_to] += _value;
376     Transfer(msg.sender, _to, _value);
377   }
378 
379   function balanceOf(address _owner) constant public returns (uint balance) {
380     return balances[_owner];
381   }
382 
383   function () payable {
384     throw;
385   }
386 
387   function ERC20OptionsConverter(address esop, uint32 exerciseDeadline, uint32 conversionDeadline) {
388     esopAddress = esop;
389     exercisePeriodDeadline = exerciseDeadline;
390     optionsConversionDeadline = conversionDeadline;
391   }
392 }
393 
394 contract ESOPMigration {
395   modifier onlyOldESOP() {
396     if (msg.sender != getOldESOP())
397       throw;
398     _;
399   }
400 
401   // returns ESOP address which is a sole executor of exerciseOptions function
402   function getOldESOP() public constant returns (address);
403 
404   // migrate employee to new ESOP contract, throws if not possible
405   // in simplest case new ESOP contract should derive from this contract and implement abstract methods
406   // employees list is available for inspection by employee address
407   // poolOptions and extraOption is amount of options transferred out of old ESOP contract
408   function migrate(address employee, uint poolOptions, uint extraOptions) onlyOldESOP public;
409 }
410 
411 contract ESOP is ESOPTypes, CodeUpdateable, TimeSource {
412   // employee changed events
413   event ESOPOffered(address indexed employee, address company, uint32 poolOptions, uint32 extraOptions);
414   event EmployeeSignedToESOP(address indexed employee);
415   event SuspendEmployee(address indexed employee, uint32 suspendedAt);
416   event ContinueSuspendedEmployee(address indexed employee, uint32 continuedAt, uint32 suspendedPeriod);
417   event TerminateEmployee(address indexed employee, address company, uint32 terminatedAt, TerminationType termType);
418   event EmployeeOptionsExercised(address indexed employee, address exercisedFor, uint32 poolOptions, bool disableAcceleratedVesting);
419   event EmployeeMigrated(address indexed employee, address migration, uint pool, uint extra);
420   // esop changed events
421   event ESOPOpened(address company);
422   event OptionsConversionOffered(address company, address converter, uint32 convertedAt, uint32 exercisePeriodDeadline);
423   enum ESOPState { New, Open, Conversion }
424   // use retrun codes until revert opcode is implemented
425   enum ReturnCodes { OK, InvalidEmployeeState, TooLate, InvalidParameters, TooEarly  }
426   // event raised when return code from a function is not OK, when OK is returned one of events above is raised
427   event ReturnCode(ReturnCodes rc);
428   enum TerminationType { Regular, BadLeaver }
429 
430   //CONFIG
431   OptionsCalculator public optionsCalculator;
432   // total poolOptions in The Pool
433   uint public totalPoolOptions;
434   // ipfs hash of document establishing this ESOP
435   bytes public ESOPLegalWrapperIPFSHash;
436   // company address
437   address public companyAddress;
438   // root of immutable root of trust pointing to given ESOP implementation
439   address public rootOfTrust;
440   // default period for employee signature
441   uint32 constant public MINIMUM_MANUAL_SIGN_PERIOD = 2 weeks;
442 
443   // STATE
444   // poolOptions that remain to be assigned
445   uint public remainingPoolOptions;
446   // state of ESOP
447   ESOPState public esopState; // automatically sets to Open (0)
448   // list of employees
449   EmployeesList public employees;
450   // how many extra options inserted
451   uint public totalExtraOptions;
452   // when conversion event happened
453   uint32 public conversionOfferedAt;
454   // employee conversion deadline
455   uint32 public exerciseOptionsDeadline;
456   // option conversion proxy
457   BaseOptionsConverter public optionsConverter;
458 
459   // migration destinations per employee
460   mapping (address => ESOPMigration) private migrations;
461 
462   modifier hasEmployee(address e) {
463     // will throw on unknown address
464     if (!employees.hasEmployee(e))
465       throw;
466     _;
467   }
468 
469   modifier onlyESOPNew() {
470     if (esopState != ESOPState.New)
471       throw;
472     _;
473   }
474 
475   modifier onlyESOPOpen() {
476     if (esopState != ESOPState.Open)
477       throw;
478     _;
479   }
480 
481   modifier onlyESOPConversion() {
482     if (esopState != ESOPState.Conversion)
483       throw;
484     _;
485   }
486 
487   modifier onlyCompany() {
488     if (companyAddress != msg.sender)
489       throw;
490     _;
491   }
492 
493   function distributeAndReturnToPool(uint distributedOptions, uint idx)
494     internal
495     returns (uint)
496   {
497     // enumerate all employees that were offered poolOptions after than fromIdx -1 employee
498     Employee memory emp;
499     for (uint i = idx; i < employees.size(); i++) {
500       address ea = employees.addresses(i);
501       if (ea != 0) { // address(0) is deleted employee
502         emp = _loademp(ea);
503         // skip employees with no poolOptions and terminated employees
504         if (emp.poolOptions > 0 && ( emp.state == EmployeeState.WaitingForSignature || emp.state == EmployeeState.Employed) ) {
505           uint newoptions = optionsCalculator.calcNewEmployeePoolOptions(distributedOptions);
506           emp.poolOptions += uint32(newoptions);
507           distributedOptions -= uint32(newoptions);
508           _saveemp(ea, emp);
509         }
510       }
511     }
512     return distributedOptions;
513   }
514 
515   function removeEmployeesWithExpiredSignaturesAndReturnFadeout()
516     onlyESOPOpen
517     isCurrentCode
518     public
519   {
520     // removes employees that didn't sign and sends their poolOptions back to the pool
521     // computes fadeout for terminated employees and returns it to pool
522     // we let anyone to call that method and spend gas on it
523     Employee memory emp;
524     uint32 ct = currentTime();
525     for (uint i = 0; i < employees.size(); i++) {
526       address ea = employees.addresses(i);
527       if (ea != 0) { // address(0) is deleted employee
528         var ser = employees.getSerializedEmployee(ea);
529         emp = deserializeEmployee(ser);
530         // remove employees with expired signatures
531         if (emp.state == EmployeeState.WaitingForSignature && ct > emp.timeToSign) {
532           remainingPoolOptions += distributeAndReturnToPool(emp.poolOptions, i+1);
533           totalExtraOptions -= emp.extraOptions;
534           // actually this just sets address to 0 so iterator can continue
535           employees.removeEmployee(ea);
536         }
537         // return fadeout to pool
538         if (emp.state == EmployeeState.Terminated && ct > emp.fadeoutStarts) {
539           var (returnedPoolOptions, returnedExtraOptions) = optionsCalculator.calculateFadeoutToPool(ct, ser);
540           if (returnedPoolOptions > 0 || returnedExtraOptions > 0) {
541             employees.setFadeoutStarts(ea, ct);
542             // options from fadeout are not distributed to other employees but returned to pool
543             remainingPoolOptions += returnedPoolOptions;
544             // we maintain extraPool for easier statistics
545             totalExtraOptions -= returnedExtraOptions;
546           }
547         }
548       }
549     }
550   }
551 
552   function openESOP(uint32 pTotalPoolOptions, bytes pESOPLegalWrapperIPFSHash)
553     external
554     onlyCompany
555     onlyESOPNew
556     isCurrentCode
557     returns (ReturnCodes)
558   {
559     // options are stored in unit32
560     if (pTotalPoolOptions > 1100000 || pTotalPoolOptions < 10000) {
561       return _logerror(ReturnCodes.InvalidParameters);
562     }
563 
564     totalPoolOptions = pTotalPoolOptions;
565     remainingPoolOptions = totalPoolOptions;
566     ESOPLegalWrapperIPFSHash = pESOPLegalWrapperIPFSHash;
567 
568     esopState = ESOPState.Open;
569     ESOPOpened(companyAddress);
570     return ReturnCodes.OK;
571   }
572 
573   function offerOptionsToEmployee(address e, uint32 issueDate, uint32 timeToSign, uint32 extraOptions, bool poolCleanup)
574     external
575     onlyESOPOpen
576     onlyCompany
577     isCurrentCode
578     returns (ReturnCodes)
579   {
580     // do not add twice
581     if (employees.hasEmployee(e)) {
582       return _logerror(ReturnCodes.InvalidEmployeeState);
583     }
584     if (timeToSign < currentTime() + MINIMUM_MANUAL_SIGN_PERIOD) {
585       return _logerror(ReturnCodes.TooLate);
586     }
587     if (poolCleanup) {
588       // recover poolOptions for employees with expired signatures
589       // return fade out to pool
590       removeEmployeesWithExpiredSignaturesAndReturnFadeout();
591     }
592     uint poolOptions = optionsCalculator.calcNewEmployeePoolOptions(remainingPoolOptions);
593     if (poolOptions > 0xFFFFFFFF)
594       throw;
595     Employee memory emp = Employee({
596       issueDate: issueDate, timeToSign: timeToSign, terminatedAt: 0, fadeoutStarts: 0, poolOptions: uint32(poolOptions),
597       extraOptions: extraOptions, suspendedAt: 0, state: EmployeeState.WaitingForSignature, idx: 0
598     });
599     _saveemp(e, emp);
600     remainingPoolOptions -= poolOptions;
601     totalExtraOptions += extraOptions;
602     ESOPOffered(e, companyAddress, uint32(poolOptions), extraOptions);
603     return ReturnCodes.OK;
604   }
605 
606   // todo: implement group add someday, however func distributeAndReturnToPool gets very complicated
607   // todo: function calcNewEmployeePoolOptions(uint remaining, uint8 groupSize)
608   // todo: function addNewEmployeesToESOP(address[] emps, uint32 issueDate, uint32 timeToSign)
609 
610   function offerOptionsToEmployeeOnlyExtra(address e, uint32 issueDate, uint32 timeToSign, uint32 extraOptions)
611     external
612     onlyESOPOpen
613     onlyCompany
614     isCurrentCode
615     returns (ReturnCodes)
616   {
617     // do not add twice
618     if (employees.hasEmployee(e)) {
619       return _logerror(ReturnCodes.InvalidEmployeeState);
620     }
621     if (timeToSign < currentTime() + MINIMUM_MANUAL_SIGN_PERIOD) {
622       return _logerror(ReturnCodes.TooLate);
623     }
624     Employee memory emp = Employee({
625       issueDate: issueDate, timeToSign: timeToSign, terminatedAt: 0, fadeoutStarts: 0, poolOptions: 0,
626       extraOptions: extraOptions, suspendedAt: 0, state: EmployeeState.WaitingForSignature, idx: 0
627     });
628     _saveemp(e, emp);
629     totalExtraOptions += extraOptions;
630     ESOPOffered(e, companyAddress, 0, extraOptions);
631     return ReturnCodes.OK;
632   }
633 
634   function increaseEmployeeExtraOptions(address e, uint32 extraOptions)
635     external
636     onlyESOPOpen
637     onlyCompany
638     isCurrentCode
639     hasEmployee(e)
640     returns (ReturnCodes)
641   {
642     Employee memory emp = _loademp(e);
643     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.WaitingForSignature) {
644       return _logerror(ReturnCodes.InvalidEmployeeState);
645     }
646     emp.extraOptions += extraOptions;
647     _saveemp(e, emp);
648     totalExtraOptions += extraOptions;
649     ESOPOffered(e, companyAddress, 0, extraOptions);
650     return ReturnCodes.OK;
651   }
652 
653   function employeeSignsToESOP()
654     external
655     hasEmployee(msg.sender)
656     onlyESOPOpen
657     isCurrentCode
658     returns (ReturnCodes)
659   {
660     Employee memory emp = _loademp(msg.sender);
661     if (emp.state != EmployeeState.WaitingForSignature) {
662       return _logerror(ReturnCodes.InvalidEmployeeState);
663     }
664     uint32 t = currentTime();
665     if (t > emp.timeToSign) {
666       remainingPoolOptions += distributeAndReturnToPool(emp.poolOptions, emp.idx);
667       totalExtraOptions -= emp.extraOptions;
668       employees.removeEmployee(msg.sender);
669       return _logerror(ReturnCodes.TooLate);
670     }
671     employees.changeState(msg.sender, EmployeeState.Employed);
672     EmployeeSignedToESOP(msg.sender);
673     return ReturnCodes.OK;
674   }
675 
676   function toggleEmployeeSuspension(address e, uint32 toggledAt)
677     external
678     onlyESOPOpen
679     onlyCompany
680     hasEmployee(e)
681     isCurrentCode
682     returns (ReturnCodes)
683   {
684     Employee memory emp = _loademp(e);
685     if (emp.state != EmployeeState.Employed) {
686       return _logerror(ReturnCodes.InvalidEmployeeState);
687     }
688     if (emp.suspendedAt == 0) {
689       //suspend action
690       emp.suspendedAt = toggledAt;
691       SuspendEmployee(e, toggledAt);
692     } else {
693       if (emp.suspendedAt > toggledAt) {
694         return _logerror(ReturnCodes.TooLate);
695       }
696       uint32 suspendedPeriod = toggledAt - emp.suspendedAt;
697       // move everything by suspension period by changing issueDate
698       emp.issueDate += suspendedPeriod;
699       emp.suspendedAt = 0;
700       ContinueSuspendedEmployee(e, toggledAt, suspendedPeriod);
701     }
702     _saveemp(e, emp);
703     return ReturnCodes.OK;
704   }
705 
706   function terminateEmployee(address e, uint32 terminatedAt, uint8 terminationType)
707     external
708     onlyESOPOpen
709     onlyCompany
710     hasEmployee(e)
711     isCurrentCode
712     returns (ReturnCodes)
713   {
714     // terminates an employee
715     TerminationType termType = TerminationType(terminationType);
716     Employee memory emp = _loademp(e);
717     // todo: check termination time against issueDate
718     if (terminatedAt < emp.issueDate) {
719       return _logerror(ReturnCodes.InvalidParameters);
720     }
721     if (emp.state == EmployeeState.WaitingForSignature)
722       termType = TerminationType.BadLeaver;
723     else if (emp.state != EmployeeState.Employed) {
724       return _logerror(ReturnCodes.InvalidEmployeeState);
725     }
726     // how many poolOptions returned to pool
727     uint returnedOptions;
728     uint returnedExtraOptions;
729     if (termType == TerminationType.Regular) {
730       // regular termination, compute suspension
731       if (emp.suspendedAt > 0 && emp.suspendedAt < terminatedAt)
732         emp.issueDate += terminatedAt - emp.suspendedAt;
733       // vesting applies
734       returnedOptions = emp.poolOptions - optionsCalculator.calculateVestedOptions(terminatedAt, emp.issueDate, emp.poolOptions);
735       returnedExtraOptions = emp.extraOptions - optionsCalculator.calculateVestedOptions(terminatedAt, emp.issueDate, emp.extraOptions);
736       employees.terminateEmployee(e, emp.issueDate, terminatedAt, terminatedAt, EmployeeState.Terminated);
737     } else if (termType == TerminationType.BadLeaver) {
738       // bad leaver - employee is kicked out from ESOP, return all poolOptions
739       returnedOptions = emp.poolOptions;
740       returnedExtraOptions = emp.extraOptions;
741       employees.removeEmployee(e);
742     }
743     remainingPoolOptions += distributeAndReturnToPool(returnedOptions, emp.idx);
744     totalExtraOptions -= returnedExtraOptions;
745     TerminateEmployee(e, companyAddress, terminatedAt, termType);
746     return ReturnCodes.OK;
747   }
748 
749   function offerOptionsConversion(BaseOptionsConverter converter)
750     external
751     onlyESOPOpen
752     onlyCompany
753     isCurrentCode
754     returns (ReturnCodes)
755   {
756     uint32 offerMadeAt = currentTime();
757     if (converter.getExercisePeriodDeadline() - offerMadeAt < MINIMUM_MANUAL_SIGN_PERIOD) {
758       return _logerror(ReturnCodes.TooLate);
759     }
760     // exerciseOptions must be callable by us
761     if (converter.getESOP() != address(this)) {
762       return _logerror(ReturnCodes.InvalidParameters);
763     }
764     // return to pool everything we can
765     removeEmployeesWithExpiredSignaturesAndReturnFadeout();
766     // from now vesting and fadeout stops, no new employees may be added
767     conversionOfferedAt = offerMadeAt;
768     exerciseOptionsDeadline = converter.getExercisePeriodDeadline();
769     optionsConverter = converter;
770     // this is very irreversible
771     esopState = ESOPState.Conversion;
772     OptionsConversionOffered(companyAddress, address(converter), offerMadeAt, exerciseOptionsDeadline);
773     return ReturnCodes.OK;
774   }
775 
776   function exerciseOptionsInternal(uint32 calcAtTime, address employee, address exerciseFor,
777     bool disableAcceleratedVesting)
778     internal
779     returns (ReturnCodes)
780   {
781     Employee memory emp = _loademp(employee);
782     if (emp.state == EmployeeState.OptionsExercised) {
783       return _logerror(ReturnCodes.InvalidEmployeeState);
784     }
785     // if we are burning options then send 0
786     if (exerciseFor != address(0)) {
787       var (pool, extra, bonus) = optionsCalculator.calculateOptionsComponents(serializeEmployee(emp),
788         calcAtTime, conversionOfferedAt, disableAcceleratedVesting);
789       }
790     // call before options conversion contract to prevent re-entry
791     employees.changeState(employee, EmployeeState.OptionsExercised);
792     // exercise options in the name of employee and assign those to exerciseFor
793     optionsConverter.exerciseOptions(exerciseFor, pool, extra, bonus, !disableAcceleratedVesting);
794     EmployeeOptionsExercised(employee, exerciseFor, uint32(pool + extra + bonus), !disableAcceleratedVesting);
795     return ReturnCodes.OK;
796   }
797 
798   function employeeExerciseOptions(bool agreeToAcceleratedVestingBonusConditions)
799     external
800     onlyESOPConversion
801     hasEmployee(msg.sender)
802     isCurrentCode
803     returns (ReturnCodes)
804   {
805     uint32 ct = currentTime();
806     if (ct > exerciseOptionsDeadline) {
807       return _logerror(ReturnCodes.TooLate);
808     }
809     return exerciseOptionsInternal(ct, msg.sender, msg.sender, !agreeToAcceleratedVestingBonusConditions);
810   }
811 
812   function employeeDenyExerciseOptions()
813     external
814     onlyESOPConversion
815     hasEmployee(msg.sender)
816     isCurrentCode
817     returns (ReturnCodes)
818   {
819     uint32 ct = currentTime();
820     if (ct > exerciseOptionsDeadline) {
821       return _logerror(ReturnCodes.TooLate);
822     }
823     // burn the options by sending to 0
824     return exerciseOptionsInternal(ct, msg.sender, address(0), true);
825   }
826 
827   function exerciseExpiredEmployeeOptions(address e, bool disableAcceleratedVesting)
828     external
829     onlyESOPConversion
830     onlyCompany
831     hasEmployee(e)
832     isCurrentCode
833   returns (ReturnCodes)
834   {
835     // company can convert options for any employee that did not converted (after deadline)
836     uint32 ct = currentTime();
837     if (ct <= exerciseOptionsDeadline) {
838       return _logerror(ReturnCodes.TooEarly);
839     }
840     return exerciseOptionsInternal(ct, e, companyAddress, disableAcceleratedVesting);
841   }
842 
843   function allowEmployeeMigration(address employee, ESOPMigration migration)
844     external
845     onlyESOPOpen
846     hasEmployee(employee)
847     onlyCompany
848     isCurrentCode
849     returns (ReturnCodes)
850   {
851     if (address(migration) == 0)
852       throw;
853     // only employed and terminated users may migrate
854     Employee memory emp = _loademp(employee);
855     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.Terminated) {
856       return _logerror(ReturnCodes.InvalidEmployeeState);
857     }
858     migrations[employee] = migration; // can be cleared with 0 address
859     return ReturnCodes.OK;
860   }
861 
862   function employeeMigratesToNewESOP(ESOPMigration migration)
863     external
864     onlyESOPOpen
865     hasEmployee(msg.sender)
866     isCurrentCode
867     returns (ReturnCodes)
868   {
869     // employee may migrate to new ESOP contract with different rules
870     // if migration not set up by company then throw
871     if (address(migration) == 0 || migrations[msg.sender] != migration)
872       throw;
873     // first give back what you already own
874     removeEmployeesWithExpiredSignaturesAndReturnFadeout();
875     // only employed and terminated users may migrate
876     Employee memory emp = _loademp(msg.sender);
877     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.Terminated) {
878       return _logerror(ReturnCodes.InvalidEmployeeState);
879     }
880     // with accelerated vesting if possible - take out all possible options
881     var (pool, extra, _) = optionsCalculator.calculateOptionsComponents(serializeEmployee(emp), currentTime(), 0, false);
882     delete migrations[msg.sender];
883     // execute migration procedure
884     migration.migrate(msg.sender, pool, extra);
885     // extra options are moved to new contract
886     totalExtraOptions -= emp.state == EmployeeState.Employed ? emp.extraOptions : extra;
887     // pool options are moved to new contract and removed from The Pool
888     // please note that separate Pool will manage migrated options and
889     // algorithm that returns to pool and distributes will not be used
890     totalPoolOptions -= emp.state == EmployeeState.Employed ? emp.poolOptions : pool;
891     // gone from current contract
892     employees.removeEmployee(msg.sender);
893     EmployeeMigrated(msg.sender, migration, pool, extra);
894     return ReturnCodes.OK;
895   }
896 
897   function calcEffectiveOptionsForEmployee(address e, uint32 calcAtTime)
898     public
899     constant
900     hasEmployee(e)
901     isCurrentCode
902     returns (uint)
903   {
904     return optionsCalculator.calculateOptions(employees.getSerializedEmployee(e), calcAtTime, conversionOfferedAt, false);
905   }
906 
907   function _logerror(ReturnCodes c) private returns (ReturnCodes) {
908     ReturnCode(c);
909     return c;
910   }
911 
912   function _loademp(address e) private constant returns (Employee memory) {
913     return deserializeEmployee(employees.getSerializedEmployee(e));
914   }
915 
916   function _saveemp(address e, Employee memory emp) private {
917     employees.setEmployee(e, emp.issueDate, emp.timeToSign, emp.terminatedAt, emp.fadeoutStarts, emp.poolOptions,
918       emp.extraOptions, emp.suspendedAt, emp.state);
919   }
920 
921   function completeCodeUpdate() public onlyOwner inCodeUpdate {
922     employees.transferOwnership(msg.sender);
923     CodeUpdateable.completeCodeUpdate();
924   }
925 
926   function()
927       payable
928   {
929       throw;
930   }
931 
932   function ESOP(address company, address pRootOfTrust, OptionsCalculator pOptionsCalculator, EmployeesList pEmployeesList) {
933     //esopState = ESOPState.New; // thats initial value
934     companyAddress = company;
935     rootOfTrust = pRootOfTrust;
936     employees = pEmployeesList;
937     optionsCalculator = pOptionsCalculator;
938   }
939 }
940 
941 
942 
943 
944 contract OptionsCalculator is Ownable, Destructable, Math, ESOPTypes {
945   // cliff duration in seconds
946   uint public cliffPeriod;
947   // vesting duration in seconds
948   uint public vestingPeriod;
949   // maximum promille that can fade out
950   uint public maxFadeoutPromille;
951   // minimal options after fadeout
952   function residualAmountPromille() public constant returns(uint) { return FP_SCALE - maxFadeoutPromille; }
953   // exit bonus promille
954   uint public bonusOptionsPromille;
955   // per mille of unassigned poolOptions that new employee gets
956   uint public newEmployeePoolPromille;
957   // options per share
958   uint public optionsPerShare;
959   // options strike price
960   uint constant public STRIKE_PRICE = 1;
961   // company address
962   address public companyAddress;
963   // checks if calculator i initialized
964   function hasParameters() public constant returns(bool) { return optionsPerShare > 0; }
965 
966   modifier onlyCompany() {
967     if (companyAddress != msg.sender)
968       throw;
969     _;
970   }
971 
972   function calcNewEmployeePoolOptions(uint remainingPoolOptions)
973     public
974     constant
975     returns (uint)
976   {
977     return divRound(remainingPoolOptions * newEmployeePoolPromille, FP_SCALE);
978   }
979 
980   function calculateVestedOptions(uint t, uint vestingStarts, uint options)
981     public
982     constant
983     returns (uint)
984   {
985     if (t <= vestingStarts)
986       return 0;
987     // apply vesting
988     uint effectiveTime = t - vestingStarts;
989     // if within cliff nothing is due
990     if (effectiveTime < cliffPeriod)
991       return 0;
992     else
993       return  effectiveTime < vestingPeriod ? divRound(options * effectiveTime, vestingPeriod) : options;
994   }
995 
996   function applyFadeoutToOptions(uint32 t, uint32 issueDate, uint32 terminatedAt, uint options, uint vestedOptions)
997     public
998     constant
999     returns (uint)
1000   {
1001     if (t < terminatedAt)
1002       return vestedOptions;
1003     uint timefromTermination = t - terminatedAt;
1004     // fadeout duration equals to employment duration
1005     uint employmentPeriod = terminatedAt - issueDate;
1006     // minimum value of options at the end of fadeout, it is a % of all employee's options
1007     uint minFadeValue = divRound(options * (FP_SCALE - maxFadeoutPromille), FP_SCALE);
1008     // however employee cannot have more than options after fadeout than he was vested at termination
1009     if (minFadeValue >= vestedOptions)
1010       return vestedOptions;
1011     return timefromTermination > employmentPeriod ?
1012       minFadeValue  :
1013       (minFadeValue + divRound((vestedOptions - minFadeValue) * (employmentPeriod - timefromTermination), employmentPeriod));
1014   }
1015 
1016   function calculateOptionsComponents(uint[9] employee, uint32 calcAtTime, uint32 conversionOfferedAt,
1017     bool disableAcceleratedVesting)
1018     public
1019     constant
1020     returns (uint, uint, uint)
1021   {
1022     // returns tuple of (vested pool options, vested extra options, bonus)
1023     Employee memory emp = deserializeEmployee(employee);
1024     // no options for converted options or when esop is not singed
1025     if (emp.state == EmployeeState.OptionsExercised || emp.state == EmployeeState.WaitingForSignature)
1026       return (0,0,0);
1027     // no options when esop is being converted and conversion deadline expired
1028     bool isESOPConverted = conversionOfferedAt > 0 && calcAtTime >= conversionOfferedAt; // this function time-travels
1029     uint issuedOptions = emp.poolOptions + emp.extraOptions;
1030     // employee with no options
1031     if (issuedOptions == 0)
1032       return (0,0,0);
1033     // if emp is terminated but we calc options before term, simulate employed again
1034     if (calcAtTime < emp.terminatedAt && emp.terminatedAt > 0)
1035       emp.state = EmployeeState.Employed;
1036     uint vestedOptions = issuedOptions;
1037     bool accelerateVesting = isESOPConverted && emp.state == EmployeeState.Employed && !disableAcceleratedVesting;
1038     if (!accelerateVesting) {
1039       // choose vesting time
1040       uint32 calcVestingAt = emp.state ==
1041         // if terminated then vesting calculated at termination
1042         EmployeeState.Terminated ? emp.terminatedAt :
1043         // if employee is supended then compute vesting at suspension time
1044         (emp.suspendedAt > 0 && emp.suspendedAt < calcAtTime ? emp.suspendedAt :
1045         // if conversion offer then vesting calucated at time the offer was made
1046         conversionOfferedAt > 0 ? conversionOfferedAt :
1047         // otherwise use current time
1048         calcAtTime);
1049       vestedOptions = calculateVestedOptions(calcVestingAt, emp.issueDate, issuedOptions);
1050     }
1051     // calc fadeout for terminated employees
1052     if (emp.state == EmployeeState.Terminated) {
1053       // use conversion event time to compute fadeout to stop fadeout on conversion IF not after conversion date
1054       vestedOptions = applyFadeoutToOptions(isESOPConverted ? conversionOfferedAt : calcAtTime,
1055         emp.issueDate, emp.terminatedAt, issuedOptions, vestedOptions);
1056     }
1057     var (vestedPoolOptions, vestedExtraOptions) = extractVestedOptionsComponents(emp.poolOptions, emp.extraOptions, vestedOptions);
1058     // if (vestedPoolOptions + vestedExtraOptions != vestedOptions) throw;
1059     return  (vestedPoolOptions, vestedExtraOptions,
1060       accelerateVesting ? divRound(vestedPoolOptions*bonusOptionsPromille, FP_SCALE) : 0 );
1061   }
1062 
1063   function calculateOptions(uint[9] employee, uint32 calcAtTime, uint32 conversionOfferedAt, bool disableAcceleratedVesting)
1064     public
1065     constant
1066     returns (uint)
1067   {
1068     var (vestedPoolOptions, vestedExtraOptions, bonus) = calculateOptionsComponents(employee, calcAtTime,
1069       conversionOfferedAt, disableAcceleratedVesting);
1070     return vestedPoolOptions + vestedExtraOptions + bonus;
1071   }
1072 
1073   function extractVestedOptionsComponents(uint issuedPoolOptions, uint issuedExtraOptions, uint vestedOptions)
1074     public
1075     constant
1076     returns (uint, uint)
1077   {
1078     // breaks down vested options into pool options and extra options components
1079     if (issuedExtraOptions == 0)
1080       return (vestedOptions, 0);
1081     uint poolOptions = divRound(issuedPoolOptions*vestedOptions, issuedPoolOptions + issuedExtraOptions);
1082     return (poolOptions, vestedOptions - poolOptions);
1083   }
1084 
1085   function calculateFadeoutToPool(uint32 t, uint[9] employee)
1086     public
1087     constant
1088     returns (uint, uint)
1089   {
1090     Employee memory emp = deserializeEmployee(employee);
1091 
1092     uint vestedOptions = calculateVestedOptions(emp.terminatedAt, emp.issueDate, emp.poolOptions);
1093     uint returnedPoolOptions = applyFadeoutToOptions(emp.fadeoutStarts, emp.issueDate, emp.terminatedAt, emp.poolOptions, vestedOptions) -
1094       applyFadeoutToOptions(t, emp.issueDate, emp.terminatedAt, emp.poolOptions, vestedOptions);
1095     uint vestedExtraOptions = calculateVestedOptions(emp.terminatedAt, emp.issueDate, emp.extraOptions);
1096     uint returnedExtraOptions = applyFadeoutToOptions(emp.fadeoutStarts, emp.issueDate, emp.terminatedAt, emp.extraOptions, vestedExtraOptions) -
1097       applyFadeoutToOptions(t, emp.issueDate, emp.terminatedAt, emp.extraOptions, vestedExtraOptions);
1098 
1099     return (returnedPoolOptions, returnedExtraOptions);
1100   }
1101 
1102   function simulateOptions(uint32 issueDate, uint32 terminatedAt, uint32 poolOptions,
1103     uint32 extraOptions, uint32 suspendedAt, uint8 employeeState, uint32 calcAtTime)
1104     public
1105     constant
1106     returns (uint)
1107   {
1108     Employee memory emp = Employee({issueDate: issueDate, terminatedAt: terminatedAt,
1109       poolOptions: poolOptions, extraOptions: extraOptions, state: EmployeeState(employeeState),
1110       timeToSign: issueDate+2 weeks, fadeoutStarts: terminatedAt, suspendedAt: suspendedAt,
1111       idx:1});
1112     return calculateOptions(serializeEmployee(emp), calcAtTime, 0, false);
1113   }
1114 
1115   function setParameters(uint32 pCliffPeriod, uint32 pVestingPeriod, uint32 pResidualAmountPromille,
1116     uint32 pBonusOptionsPromille, uint32 pNewEmployeePoolPromille, uint32 pOptionsPerShare)
1117     external
1118     onlyCompany
1119   {
1120     if (pResidualAmountPromille > FP_SCALE || pBonusOptionsPromille > FP_SCALE || pNewEmployeePoolPromille > FP_SCALE
1121      || pOptionsPerShare == 0)
1122       throw;
1123     if (pCliffPeriod > pVestingPeriod)
1124       throw;
1125     // initialization cannot be called for a second time
1126     if (hasParameters())
1127       throw;
1128     cliffPeriod = pCliffPeriod;
1129     vestingPeriod = pVestingPeriod;
1130     maxFadeoutPromille = FP_SCALE - pResidualAmountPromille;
1131     bonusOptionsPromille = pBonusOptionsPromille;
1132     newEmployeePoolPromille = pNewEmployeePoolPromille;
1133     optionsPerShare = pOptionsPerShare;
1134   }
1135 
1136   function OptionsCalculator(address pCompanyAddress) {
1137     companyAddress = pCompanyAddress;
1138   }
1139 }
1140 
1141 contract ProceedsOptionsConverter is Ownable, ERC20OptionsConverter {
1142   mapping (address => uint) internal withdrawals;
1143   uint[] internal payouts;
1144 
1145   function makePayout() converted payable onlyOwner public {
1146     // it does not make sense to distribute less than ether
1147     if (msg.value < 1 ether)
1148       throw;
1149     payouts.push(msg.value);
1150   }
1151 
1152   function withdraw() converted public returns (uint) {
1153     // withdraw for msg.sender
1154     uint balance = balanceOf(msg.sender);
1155     if (balance == 0)
1156       return 0;
1157     uint paymentId = withdrawals[msg.sender];
1158     // if all payouts for given token holder executed then exit
1159     if (paymentId == payouts.length)
1160       return 0;
1161     uint payout = 0;
1162     for (uint i = paymentId; i<payouts.length; i++) {
1163       // it is safe to make payouts pro-rata: (1) token supply will not change - check converted/conversion modifiers
1164       // -- (2) balances will not change: check transfer override which limits transfer between accounts
1165       // NOTE: safeMul throws on overflow, can lock users out of their withdrawals if balance is very high
1166       // @remco I know. any suggestions? expression below gives most precision
1167       uint thisPayout = divRound(safeMul(payouts[i], balance), totalSupply);
1168       payout += thisPayout;
1169     }
1170     // change now to prevent re-entry (not necessary due to low send() gas limit)
1171     withdrawals[msg.sender] = payouts.length;
1172     if (payout > 0) {
1173       // now modify payout within 1000 weis as we had rounding errors coming from pro-rata amounts
1174       // @remco maximum rounding error is (num_employees * num_payments) / 2 with the mean 0
1175       // --- 1000 wei is still nothing, please explain me what problem you see here
1176       if ( absDiff(this.balance, payout) < 1000 wei )
1177         payout = this.balance; // send all
1178       //if(!msg.sender.call.value(payout)()) // re entry test
1179       //  throw;
1180       if (!msg.sender.send(payout))
1181         throw;
1182     }
1183     return payout;
1184   }
1185 
1186   function transfer(address _to, uint _value) public converted {
1187     // if anything was withdrawn then block transfer to prevent multiple withdrawals
1188     // todo: we could allow transfer to new account (no token balance)
1189     // todo: we could allow transfer between account that fully withdrawn (but what's the point? -token has 0 value then)
1190     // todo: there are a few other edge cases where there's transfer and no double spending
1191     if (withdrawals[_to] > 0 || withdrawals[msg.sender] > 0)
1192       throw;
1193     ERC20OptionsConverter.transfer(_to, _value);
1194   }
1195 
1196   function ProceedsOptionsConverter(address esop, uint32 exerciseDeadline, uint32 conversionDeadline)
1197     ERC20OptionsConverter(esop, exerciseDeadline, conversionDeadline)
1198   {
1199   }
1200 }
1201 
1202 contract RoT is Ownable {
1203     address public ESOPAddress;
1204     event ESOPAndCompanySet(address ESOPAddress, address companyAddress);
1205 
1206     function setESOP(address ESOP, address company) public onlyOwner {
1207       // owner sets ESOP and company only once then passes ownership to company
1208       // initially owner is a developer/admin
1209       ESOPAddress = ESOP;
1210       transferOwnership(company);
1211       ESOPAndCompanySet(ESOP, company);
1212     }
1213 
1214     function killOnUnsupportedFork() public onlyOwner {
1215       // this method may only be called by company on unsupported forks
1216       delete ESOPAddress;
1217       selfdestruct(owner);
1218     }
1219 }