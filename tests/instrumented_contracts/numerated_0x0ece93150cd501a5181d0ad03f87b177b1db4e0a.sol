1 pragma solidity ^0.4.8;
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
156 contract CodeUpdateable is Ownable {
157     // allows to stop operations and migrate data to different contract
158     enum CodeUpdateState { CurrentCode, OngoingUpdate /*, CodeUpdated*/}
159     CodeUpdateState public codeUpdateState;
160 
161     modifier isCurrentCode() {
162       if (codeUpdateState != CodeUpdateState.CurrentCode)
163         throw;
164       _;
165     }
166 
167     modifier inCodeUpdate() {
168       if (codeUpdateState != CodeUpdateState.OngoingUpdate)
169         throw;
170       _;
171     }
172 
173     function beginCodeUpdate() public onlyOwner isCurrentCode {
174       codeUpdateState = CodeUpdateState.OngoingUpdate;
175     }
176 
177     function cancelCodeUpdate() public onlyOwner inCodeUpdate {
178       codeUpdateState = CodeUpdateState.CurrentCode;
179     }
180 
181     function completeCodeUpdate() public onlyOwner inCodeUpdate {
182       selfdestruct(owner);
183     }
184 }
185 
186 contract EmployeesList is ESOPTypes, Ownable, Destructable {
187   event CreateEmployee(address indexed e, uint32 poolOptions, uint32 extraOptions, uint16 idx);
188   event UpdateEmployee(address indexed e, uint32 poolOptions, uint32 extraOptions, uint16 idx);
189   event ChangeEmployeeState(address indexed e, EmployeeState oldState, EmployeeState newState);
190   event RemoveEmployee(address indexed e);
191   mapping (address => Employee) employees;
192   // addresses in the mapping, ever
193   address[] public addresses;
194 
195   function size() external constant returns (uint16) {
196     return uint16(addresses.length);
197   }
198 
199   function setEmployee(address e, uint32 issueDate, uint32 timeToSign, uint32 terminatedAt, uint32 fadeoutStarts,
200     uint32 poolOptions, uint32 extraOptions, uint32 suspendedAt, EmployeeState state)
201     external
202     onlyOwner
203     returns (bool isNew)
204   {
205     uint16 empIdx = employees[e].idx;
206     if (empIdx == 0) {
207       // new element
208       uint size = addresses.length;
209       if (size == 0xFFFF)
210         throw;
211       isNew = true;
212       empIdx = uint16(size + 1);
213       addresses.push(e);
214       CreateEmployee(e, poolOptions, extraOptions, empIdx);
215     } else {
216       isNew = false;
217       UpdateEmployee(e, poolOptions, extraOptions, empIdx);
218     }
219     employees[e] = Employee({
220         issueDate: issueDate,
221         timeToSign: timeToSign,
222         terminatedAt: terminatedAt,
223         fadeoutStarts: fadeoutStarts,
224         poolOptions: poolOptions,
225         extraOptions: extraOptions,
226         suspendedAt: suspendedAt,
227         state: state,
228         idx: empIdx
229       });
230   }
231 
232   function changeState(address e, EmployeeState state)
233     external
234     onlyOwner
235   {
236     if (employees[e].idx == 0)
237       throw;
238     ChangeEmployeeState(e, employees[e].state, state);
239     employees[e].state = state;
240   }
241 
242   function setFadeoutStarts(address e, uint32 fadeoutStarts)
243     external
244     onlyOwner
245   {
246     if (employees[e].idx == 0)
247       throw;
248     UpdateEmployee(e, employees[e].poolOptions, employees[e].extraOptions, employees[e].idx);
249     employees[e].fadeoutStarts = fadeoutStarts;
250   }
251 
252   function removeEmployee(address e)
253     external
254     onlyOwner
255     returns (bool)
256   {
257     uint16 empIdx = employees[e].idx;
258     if (empIdx > 0) {
259         delete employees[e];
260         delete addresses[empIdx-1];
261         RemoveEmployee(e);
262         return true;
263     }
264     return false;
265   }
266 
267   function terminateEmployee(address e, uint32 issueDate, uint32 terminatedAt, uint32 fadeoutStarts, EmployeeState state)
268     external
269     onlyOwner
270   {
271     if (state != EmployeeState.Terminated)
272         throw;
273     Employee employee = employees[e]; // gets reference to storage and optimizer does it with one SSTORE
274     if (employee.idx == 0)
275       throw;
276     ChangeEmployeeState(e, employee.state, state);
277     employee.state = state;
278     employee.issueDate = issueDate;
279     employee.terminatedAt = terminatedAt;
280     employee.fadeoutStarts = fadeoutStarts;
281     employee.suspendedAt = 0;
282     UpdateEmployee(e, employee.poolOptions, employee.extraOptions, employee.idx);
283   }
284 
285   function getEmployee(address e)
286     external
287     constant
288     returns (uint32, uint32, uint32, uint32, uint32, uint32, uint32, EmployeeState)
289   {
290       Employee employee = employees[e];
291       if (employee.idx == 0)
292         throw;
293       // where is struct zip/unzip :>
294       return (employee.issueDate, employee.timeToSign, employee.terminatedAt, employee.fadeoutStarts,
295         employee.poolOptions, employee.extraOptions, employee.suspendedAt, employee.state);
296   }
297 
298    function hasEmployee(address e)
299      external
300      constant
301      returns (bool)
302    {
303       // this is very inefficient - whole word is loaded just to check this
304       return employees[e].idx != 0;
305     }
306 
307   function getSerializedEmployee(address e)
308     external
309     constant
310     returns (uint[9])
311   {
312     Employee memory employee = employees[e];
313     if (employee.idx == 0)
314       throw;
315     return serializeEmployee(employee);
316   }
317 }
318 
319 contract ERC20OptionsConverter is BaseOptionsConverter, TimeSource, Math {
320   // see base class for explanations
321   address esopAddress;
322   uint32 exercisePeriodDeadline;
323   // balances for converted options
324   mapping(address => uint) internal balances;
325   // total supply
326   uint public totalSupply;
327 
328   // deadline for all options conversion including company's actions
329   uint32 public optionsConversionDeadline;
330 
331   event Transfer(address indexed from, address indexed to, uint value);
332 
333   modifier converting() {
334     // throw after deadline
335     if (currentTime() >= exercisePeriodDeadline)
336       throw;
337     _;
338   }
339 
340   modifier converted() {
341     // throw before deadline
342     if (currentTime() < optionsConversionDeadline)
343       throw;
344     _;
345   }
346 
347 
348   function getESOP() public constant returns (address) {
349     return esopAddress;
350   }
351 
352   function getExercisePeriodDeadline() public constant returns(uint32) {
353     return exercisePeriodDeadline;
354   }
355 
356   function exerciseOptions(address employee, uint poolOptions, uint extraOptions, uint bonusOptions,
357     bool agreeToAcceleratedVestingBonusConditions)
358     public
359     onlyESOP
360     converting
361   {
362     // if no overflow on totalSupply, no overflows later
363     uint options = safeAdd(safeAdd(poolOptions, extraOptions), bonusOptions);
364     totalSupply = safeAdd(totalSupply, options);
365     balances[employee] += options;
366     Transfer(0, employee, options);
367   }
368 
369   function transfer(address _to, uint _value) converted public {
370     if (balances[msg.sender] < _value)
371       throw;
372     balances[msg.sender] -= _value;
373     balances[_to] += _value;
374     Transfer(msg.sender, _to, _value);
375   }
376 
377   function balanceOf(address _owner) constant public returns (uint balance) {
378     return balances[_owner];
379   }
380 
381   function () payable {
382     throw;
383   }
384 
385   function ERC20OptionsConverter(address esop, uint32 exerciseDeadline, uint32 conversionDeadline) {
386     esopAddress = esop;
387     exercisePeriodDeadline = exerciseDeadline;
388     optionsConversionDeadline = conversionDeadline;
389   }
390 }
391 
392 contract ESOPMigration {
393   modifier onlyOldESOP() {
394     if (msg.sender != getOldESOP())
395       throw;
396     _;
397   }
398 
399   // returns ESOP address which is a sole executor of exerciseOptions function
400   function getOldESOP() public constant returns (address);
401 
402   // migrate employee to new ESOP contract, throws if not possible
403   // in simplest case new ESOP contract should derive from this contract and implement abstract methods
404   // employees list is available for inspection by employee address
405   // poolOptions and extraOption is amount of options transferred out of old ESOP contract
406   function migrate(address employee, uint poolOptions, uint extraOptions) onlyOldESOP public;
407 }
408 
409 contract ESOP is ESOPTypes, CodeUpdateable, TimeSource {
410   // employee changed events
411   event ESOPOffered(address indexed employee, address company, uint32 poolOptions, uint32 extraOptions);
412   event EmployeeSignedToESOP(address indexed employee);
413   event SuspendEmployee(address indexed employee, uint32 suspendedAt);
414   event ContinueSuspendedEmployee(address indexed employee, uint32 continuedAt, uint32 suspendedPeriod);
415   event TerminateEmployee(address indexed employee, address company, uint32 terminatedAt, TerminationType termType);
416   event EmployeeOptionsExercised(address indexed employee, address exercisedFor, uint32 poolOptions, bool disableAcceleratedVesting);
417   event EmployeeMigrated(address indexed employee, address migration, uint pool, uint extra);
418   // esop changed events
419   event ESOPOpened(address company);
420   event OptionsConversionOffered(address company, address converter, uint32 convertedAt, uint32 exercisePeriodDeadline);
421   enum ESOPState { New, Open, Conversion }
422   // use retrun codes until revert opcode is implemented
423   enum ReturnCodes { OK, InvalidEmployeeState, TooLate, InvalidParameters, TooEarly  }
424   // event raised when return code from a function is not OK, when OK is returned one of events above is raised
425   event ReturnCode(ReturnCodes rc);
426   enum TerminationType { Regular, BadLeaver }
427 
428   //CONFIG
429   OptionsCalculator public optionsCalculator;
430   // total poolOptions in The Pool
431   uint public totalPoolOptions;
432   // ipfs hash of document establishing this ESOP
433   bytes public ESOPLegalWrapperIPFSHash;
434   // company address
435   address public companyAddress;
436   // root of immutable root of trust pointing to given ESOP implementation
437   address public rootOfTrust;
438   // default period for employee signature
439   uint32 constant public MINIMUM_MANUAL_SIGN_PERIOD = 2 weeks;
440 
441   // STATE
442   // poolOptions that remain to be assigned
443   uint public remainingPoolOptions;
444   // state of ESOP
445   ESOPState public esopState; // automatically sets to Open (0)
446   // list of employees
447   EmployeesList public employees;
448   // how many extra options inserted
449   uint public totalExtraOptions;
450   // when conversion event happened
451   uint32 public conversionOfferedAt;
452   // employee conversion deadline
453   uint32 public exerciseOptionsDeadline;
454   // option conversion proxy
455   BaseOptionsConverter public optionsConverter;
456 
457   // migration destinations per employee
458   mapping (address => ESOPMigration) private migrations;
459 
460   modifier hasEmployee(address e) {
461     // will throw on unknown address
462     if (!employees.hasEmployee(e))
463       throw;
464     _;
465   }
466 
467   modifier onlyESOPNew() {
468     if (esopState != ESOPState.New)
469       throw;
470     _;
471   }
472 
473   modifier onlyESOPOpen() {
474     if (esopState != ESOPState.Open)
475       throw;
476     _;
477   }
478 
479   modifier onlyESOPConversion() {
480     if (esopState != ESOPState.Conversion)
481       throw;
482     _;
483   }
484 
485   modifier onlyCompany() {
486     if (companyAddress != msg.sender)
487       throw;
488     _;
489   }
490 
491   function distributeAndReturnToPool(uint distributedOptions, uint idx)
492     internal
493     returns (uint)
494   {
495     // enumerate all employees that were offered poolOptions after than fromIdx -1 employee
496     Employee memory emp;
497     for (uint i = idx; i < employees.size(); i++) {
498       address ea = employees.addresses(i);
499       if (ea != 0) { // address(0) is deleted employee
500         emp = _loademp(ea);
501         // skip employees with no poolOptions and terminated employees
502         if (emp.poolOptions > 0 && ( emp.state == EmployeeState.WaitingForSignature || emp.state == EmployeeState.Employed) ) {
503           uint newoptions = optionsCalculator.calcNewEmployeePoolOptions(distributedOptions);
504           emp.poolOptions += uint32(newoptions);
505           distributedOptions -= uint32(newoptions);
506           _saveemp(ea, emp);
507         }
508       }
509     }
510     return distributedOptions;
511   }
512 
513   function removeEmployeesWithExpiredSignaturesAndReturnFadeout()
514     onlyESOPOpen
515     isCurrentCode
516     public
517   {
518     // removes employees that didn't sign and sends their poolOptions back to the pool
519     // computes fadeout for terminated employees and returns it to pool
520     // we let anyone to call that method and spend gas on it
521     Employee memory emp;
522     uint32 ct = currentTime();
523     for (uint i = 0; i < employees.size(); i++) {
524       address ea = employees.addresses(i);
525       if (ea != 0) { // address(0) is deleted employee
526         var ser = employees.getSerializedEmployee(ea);
527         emp = deserializeEmployee(ser);
528         // remove employees with expired signatures
529         if (emp.state == EmployeeState.WaitingForSignature && ct > emp.timeToSign) {
530           remainingPoolOptions += distributeAndReturnToPool(emp.poolOptions, i+1);
531           totalExtraOptions -= emp.extraOptions;
532           // actually this just sets address to 0 so iterator can continue
533           employees.removeEmployee(ea);
534         }
535         // return fadeout to pool
536         if (emp.state == EmployeeState.Terminated && ct > emp.fadeoutStarts) {
537           var (returnedPoolOptions, returnedExtraOptions) = optionsCalculator.calculateFadeoutToPool(ct, ser);
538           if (returnedPoolOptions > 0 || returnedExtraOptions > 0) {
539             employees.setFadeoutStarts(ea, ct);
540             // options from fadeout are not distributed to other employees but returned to pool
541             remainingPoolOptions += returnedPoolOptions;
542             // we maintain extraPool for easier statistics
543             totalExtraOptions -= returnedExtraOptions;
544           }
545         }
546       }
547     }
548   }
549 
550   function openESOP(uint32 pTotalPoolOptions, bytes pESOPLegalWrapperIPFSHash)
551     external
552     onlyCompany
553     onlyESOPNew
554     isCurrentCode
555     returns (ReturnCodes)
556   {
557     // options are stored in unit32
558     if (pTotalPoolOptions > 1100000 || pTotalPoolOptions < 10000) {
559       return _logerror(ReturnCodes.InvalidParameters);
560     }
561 
562     totalPoolOptions = pTotalPoolOptions;
563     remainingPoolOptions = totalPoolOptions;
564     ESOPLegalWrapperIPFSHash = pESOPLegalWrapperIPFSHash;
565 
566     esopState = ESOPState.Open;
567     ESOPOpened(companyAddress);
568     return ReturnCodes.OK;
569   }
570 
571   function offerOptionsToEmployee(address e, uint32 issueDate, uint32 timeToSign, uint32 extraOptions, bool poolCleanup)
572     external
573     onlyESOPOpen
574     onlyCompany
575     isCurrentCode
576     returns (ReturnCodes)
577   {
578     // do not add twice
579     if (employees.hasEmployee(e)) {
580       return _logerror(ReturnCodes.InvalidEmployeeState);
581     }
582     if (timeToSign < currentTime() + MINIMUM_MANUAL_SIGN_PERIOD) {
583       return _logerror(ReturnCodes.TooLate);
584     }
585     if (poolCleanup) {
586       // recover poolOptions for employees with expired signatures
587       // return fade out to pool
588       removeEmployeesWithExpiredSignaturesAndReturnFadeout();
589     }
590     uint poolOptions = optionsCalculator.calcNewEmployeePoolOptions(remainingPoolOptions);
591     if (poolOptions > 0xFFFFFFFF)
592       throw;
593     Employee memory emp = Employee({
594       issueDate: issueDate, timeToSign: timeToSign, terminatedAt: 0, fadeoutStarts: 0, poolOptions: uint32(poolOptions),
595       extraOptions: extraOptions, suspendedAt: 0, state: EmployeeState.WaitingForSignature, idx: 0
596     });
597     _saveemp(e, emp);
598     remainingPoolOptions -= poolOptions;
599     totalExtraOptions += extraOptions;
600     ESOPOffered(e, companyAddress, uint32(poolOptions), extraOptions);
601     return ReturnCodes.OK;
602   }
603 
604   // todo: implement group add someday, however func distributeAndReturnToPool gets very complicated
605   // todo: function calcNewEmployeePoolOptions(uint remaining, uint8 groupSize)
606   // todo: function addNewEmployeesToESOP(address[] emps, uint32 issueDate, uint32 timeToSign)
607 
608   function offerOptionsToEmployeeOnlyExtra(address e, uint32 issueDate, uint32 timeToSign, uint32 extraOptions)
609     external
610     onlyESOPOpen
611     onlyCompany
612     isCurrentCode
613     returns (ReturnCodes)
614   {
615     // do not add twice
616     if (employees.hasEmployee(e)) {
617       return _logerror(ReturnCodes.InvalidEmployeeState);
618     }
619     if (timeToSign < currentTime() + MINIMUM_MANUAL_SIGN_PERIOD) {
620       return _logerror(ReturnCodes.TooLate);
621     }
622     Employee memory emp = Employee({
623       issueDate: issueDate, timeToSign: timeToSign, terminatedAt: 0, fadeoutStarts: 0, poolOptions: 0,
624       extraOptions: extraOptions, suspendedAt: 0, state: EmployeeState.WaitingForSignature, idx: 0
625     });
626     _saveemp(e, emp);
627     totalExtraOptions += extraOptions;
628     ESOPOffered(e, companyAddress, 0, extraOptions);
629     return ReturnCodes.OK;
630   }
631 
632   function increaseEmployeeExtraOptions(address e, uint32 extraOptions)
633     external
634     onlyESOPOpen
635     onlyCompany
636     isCurrentCode
637     hasEmployee(e)
638     returns (ReturnCodes)
639   {
640     Employee memory emp = _loademp(e);
641     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.WaitingForSignature) {
642       return _logerror(ReturnCodes.InvalidEmployeeState);
643     }
644     emp.extraOptions += extraOptions;
645     _saveemp(e, emp);
646     totalExtraOptions += extraOptions;
647     ESOPOffered(e, companyAddress, 0, extraOptions);
648     return ReturnCodes.OK;
649   }
650 
651   function employeeSignsToESOP()
652     external
653     hasEmployee(msg.sender)
654     onlyESOPOpen
655     isCurrentCode
656     returns (ReturnCodes)
657   {
658     Employee memory emp = _loademp(msg.sender);
659     if (emp.state != EmployeeState.WaitingForSignature) {
660       return _logerror(ReturnCodes.InvalidEmployeeState);
661     }
662     uint32 t = currentTime();
663     if (t > emp.timeToSign) {
664       remainingPoolOptions += distributeAndReturnToPool(emp.poolOptions, emp.idx);
665       totalExtraOptions -= emp.extraOptions;
666       employees.removeEmployee(msg.sender);
667       return _logerror(ReturnCodes.TooLate);
668     }
669     employees.changeState(msg.sender, EmployeeState.Employed);
670     EmployeeSignedToESOP(msg.sender);
671     return ReturnCodes.OK;
672   }
673 
674   function toggleEmployeeSuspension(address e, uint32 toggledAt)
675     external
676     onlyESOPOpen
677     onlyCompany
678     hasEmployee(e)
679     isCurrentCode
680     returns (ReturnCodes)
681   {
682     Employee memory emp = _loademp(e);
683     if (emp.state != EmployeeState.Employed) {
684       return _logerror(ReturnCodes.InvalidEmployeeState);
685     }
686     if (emp.suspendedAt == 0) {
687       //suspend action
688       emp.suspendedAt = toggledAt;
689       SuspendEmployee(e, toggledAt);
690     } else {
691       if (emp.suspendedAt > toggledAt) {
692         return _logerror(ReturnCodes.TooLate);
693       }
694       uint32 suspendedPeriod = toggledAt - emp.suspendedAt;
695       // move everything by suspension period by changing issueDate
696       emp.issueDate += suspendedPeriod;
697       emp.suspendedAt = 0;
698       ContinueSuspendedEmployee(e, toggledAt, suspendedPeriod);
699     }
700     _saveemp(e, emp);
701     return ReturnCodes.OK;
702   }
703 
704   function terminateEmployee(address e, uint32 terminatedAt, uint8 terminationType)
705     external
706     onlyESOPOpen
707     onlyCompany
708     hasEmployee(e)
709     isCurrentCode
710     returns (ReturnCodes)
711   {
712     // terminates an employee
713     TerminationType termType = TerminationType(terminationType);
714     Employee memory emp = _loademp(e);
715     // todo: check termination time against issueDate
716     if (terminatedAt < emp.issueDate) {
717       return _logerror(ReturnCodes.InvalidParameters);
718     }
719     if (emp.state == EmployeeState.WaitingForSignature)
720       termType = TerminationType.BadLeaver;
721     else if (emp.state != EmployeeState.Employed) {
722       return _logerror(ReturnCodes.InvalidEmployeeState);
723     }
724     // how many poolOptions returned to pool
725     uint returnedOptions;
726     uint returnedExtraOptions;
727     if (termType == TerminationType.Regular) {
728       // regular termination, compute suspension
729       if (emp.suspendedAt > 0 && emp.suspendedAt < terminatedAt)
730         emp.issueDate += terminatedAt - emp.suspendedAt;
731       // vesting applies
732       returnedOptions = emp.poolOptions - optionsCalculator.calculateVestedOptions(terminatedAt, emp.issueDate, emp.poolOptions);
733       returnedExtraOptions = emp.extraOptions - optionsCalculator.calculateVestedOptions(terminatedAt, emp.issueDate, emp.extraOptions);
734       employees.terminateEmployee(e, emp.issueDate, terminatedAt, terminatedAt, EmployeeState.Terminated);
735     } else if (termType == TerminationType.BadLeaver) {
736       // bad leaver - employee is kicked out from ESOP, return all poolOptions
737       returnedOptions = emp.poolOptions;
738       returnedExtraOptions = emp.extraOptions;
739       employees.removeEmployee(e);
740     }
741     remainingPoolOptions += distributeAndReturnToPool(returnedOptions, emp.idx);
742     totalExtraOptions -= returnedExtraOptions;
743     TerminateEmployee(e, companyAddress, terminatedAt, termType);
744     return ReturnCodes.OK;
745   }
746 
747   function offerOptionsConversion(BaseOptionsConverter converter)
748     external
749     onlyESOPOpen
750     onlyCompany
751     isCurrentCode
752     returns (ReturnCodes)
753   {
754     uint32 offerMadeAt = currentTime();
755     if (converter.getExercisePeriodDeadline() - offerMadeAt < MINIMUM_MANUAL_SIGN_PERIOD) {
756       return _logerror(ReturnCodes.TooLate);
757     }
758     // exerciseOptions must be callable by us
759     if (converter.getESOP() != address(this)) {
760       return _logerror(ReturnCodes.InvalidParameters);
761     }
762     // return to pool everything we can
763     removeEmployeesWithExpiredSignaturesAndReturnFadeout();
764     // from now vesting and fadeout stops, no new employees may be added
765     conversionOfferedAt = offerMadeAt;
766     exerciseOptionsDeadline = converter.getExercisePeriodDeadline();
767     optionsConverter = converter;
768     // this is very irreversible
769     esopState = ESOPState.Conversion;
770     OptionsConversionOffered(companyAddress, address(converter), offerMadeAt, exerciseOptionsDeadline);
771     return ReturnCodes.OK;
772   }
773 
774   function exerciseOptionsInternal(uint32 calcAtTime, address employee, address exerciseFor,
775     bool disableAcceleratedVesting)
776     internal
777     returns (ReturnCodes)
778   {
779     Employee memory emp = _loademp(employee);
780     if (emp.state == EmployeeState.OptionsExercised) {
781       return _logerror(ReturnCodes.InvalidEmployeeState);
782     }
783     // if we are burning options then send 0
784     if (exerciseFor != address(0)) {
785       var (pool, extra, bonus) = optionsCalculator.calculateOptionsComponents(serializeEmployee(emp),
786         calcAtTime, conversionOfferedAt, disableAcceleratedVesting);
787       }
788     // call before options conversion contract to prevent re-entry
789     employees.changeState(employee, EmployeeState.OptionsExercised);
790     // exercise options in the name of employee and assign those to exerciseFor
791     optionsConverter.exerciseOptions(exerciseFor, pool, extra, bonus, !disableAcceleratedVesting);
792     EmployeeOptionsExercised(employee, exerciseFor, uint32(pool + extra + bonus), !disableAcceleratedVesting);
793     return ReturnCodes.OK;
794   }
795 
796   function employeeExerciseOptions(bool agreeToAcceleratedVestingBonusConditions)
797     external
798     onlyESOPConversion
799     hasEmployee(msg.sender)
800     isCurrentCode
801     returns (ReturnCodes)
802   {
803     uint32 ct = currentTime();
804     if (ct > exerciseOptionsDeadline) {
805       return _logerror(ReturnCodes.TooLate);
806     }
807     return exerciseOptionsInternal(ct, msg.sender, msg.sender, !agreeToAcceleratedVestingBonusConditions);
808   }
809 
810   function employeeDenyExerciseOptions()
811     external
812     onlyESOPConversion
813     hasEmployee(msg.sender)
814     isCurrentCode
815     returns (ReturnCodes)
816   {
817     uint32 ct = currentTime();
818     if (ct > exerciseOptionsDeadline) {
819       return _logerror(ReturnCodes.TooLate);
820     }
821     // burn the options by sending to 0
822     return exerciseOptionsInternal(ct, msg.sender, address(0), true);
823   }
824 
825   function exerciseExpiredEmployeeOptions(address e, bool disableAcceleratedVesting)
826     external
827     onlyESOPConversion
828     onlyCompany
829     hasEmployee(e)
830     isCurrentCode
831   returns (ReturnCodes)
832   {
833     // company can convert options for any employee that did not converted (after deadline)
834     uint32 ct = currentTime();
835     if (ct <= exerciseOptionsDeadline) {
836       return _logerror(ReturnCodes.TooEarly);
837     }
838     return exerciseOptionsInternal(ct, e, companyAddress, disableAcceleratedVesting);
839   }
840 
841   function allowEmployeeMigration(address employee, ESOPMigration migration)
842     external
843     onlyESOPOpen
844     hasEmployee(employee)
845     onlyCompany
846     isCurrentCode
847     returns (ReturnCodes)
848   {
849     if (address(migration) == 0)
850       throw;
851     // only employed and terminated users may migrate
852     Employee memory emp = _loademp(employee);
853     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.Terminated) {
854       return _logerror(ReturnCodes.InvalidEmployeeState);
855     }
856     migrations[employee] = migration; // can be cleared with 0 address
857     return ReturnCodes.OK;
858   }
859 
860   function employeeMigratesToNewESOP(ESOPMigration migration)
861     external
862     onlyESOPOpen
863     hasEmployee(msg.sender)
864     isCurrentCode
865     returns (ReturnCodes)
866   {
867     // employee may migrate to new ESOP contract with different rules
868     // if migration not set up by company then throw
869     if (address(migration) == 0 || migrations[msg.sender] != migration)
870       throw;
871     // first give back what you already own
872     removeEmployeesWithExpiredSignaturesAndReturnFadeout();
873     // only employed and terminated users may migrate
874     Employee memory emp = _loademp(msg.sender);
875     if (emp.state != EmployeeState.Employed && emp.state != EmployeeState.Terminated) {
876       return _logerror(ReturnCodes.InvalidEmployeeState);
877     }
878     // with accelerated vesting if possible - take out all possible options
879     var (pool, extra, _) = optionsCalculator.calculateOptionsComponents(serializeEmployee(emp), currentTime(), 0, false);
880     delete migrations[msg.sender];
881     // execute migration procedure
882     migration.migrate(msg.sender, pool, extra);
883     // extra options are moved to new contract
884     totalExtraOptions -= emp.state == EmployeeState.Employed ? emp.extraOptions : extra;
885     // pool options are moved to new contract and removed from The Pool
886     // please note that separate Pool will manage migrated options and
887     // algorithm that returns to pool and distributes will not be used
888     totalPoolOptions -= emp.state == EmployeeState.Employed ? emp.poolOptions : pool;
889     // gone from current contract
890     employees.removeEmployee(msg.sender);
891     EmployeeMigrated(msg.sender, migration, pool, extra);
892     return ReturnCodes.OK;
893   }
894 
895   function calcEffectiveOptionsForEmployee(address e, uint32 calcAtTime)
896     public
897     constant
898     hasEmployee(e)
899     isCurrentCode
900     returns (uint)
901   {
902     return optionsCalculator.calculateOptions(employees.getSerializedEmployee(e), calcAtTime, conversionOfferedAt, false);
903   }
904 
905   function _logerror(ReturnCodes c) private returns (ReturnCodes) {
906     ReturnCode(c);
907     return c;
908   }
909 
910   function _loademp(address e) private constant returns (Employee memory) {
911     return deserializeEmployee(employees.getSerializedEmployee(e));
912   }
913 
914   function _saveemp(address e, Employee memory emp) private {
915     employees.setEmployee(e, emp.issueDate, emp.timeToSign, emp.terminatedAt, emp.fadeoutStarts, emp.poolOptions,
916       emp.extraOptions, emp.suspendedAt, emp.state);
917   }
918 
919   function completeCodeUpdate() public onlyOwner inCodeUpdate {
920     employees.transferOwnership(msg.sender);
921     CodeUpdateable.completeCodeUpdate();
922   }
923 
924   function()
925       payable
926   {
927       throw;
928   }
929 
930   function ESOP(address company, address pRootOfTrust, OptionsCalculator pOptionsCalculator, EmployeesList pEmployeesList) {
931     //esopState = ESOPState.New; // thats initial value
932     companyAddress = company;
933     rootOfTrust = pRootOfTrust;
934     employees = pEmployeesList;
935     optionsCalculator = pOptionsCalculator;
936   }
937 }
938 
939 
940 contract Migrations is Destructable {
941   address public owner;
942   uint public last_completed_migration;
943 
944   modifier restricted() {
945     if (msg.sender == owner) _;
946   }
947 
948   function Migrations() {
949     owner = msg.sender;
950   }
951 
952   function setCompleted(uint completed) restricted {
953     last_completed_migration = completed;
954   }
955 
956   function upgrade(address new_address) restricted {
957     Migrations upgraded = Migrations(new_address);
958     upgraded.setCompleted(last_completed_migration);
959   }
960 }
961 
962 contract OptionsCalculator is Ownable, Destructable, Math, ESOPTypes {
963   // cliff duration in seconds
964   uint public cliffPeriod;
965   // vesting duration in seconds
966   uint public vestingPeriod;
967   // maximum promille that can fade out
968   uint public maxFadeoutPromille;
969   // minimal options after fadeout
970   function residualAmountPromille() public constant returns(uint) { return FP_SCALE - maxFadeoutPromille; }
971   // exit bonus promille
972   uint public bonusOptionsPromille;
973   // per mille of unassigned poolOptions that new employee gets
974   uint public newEmployeePoolPromille;
975   // options per share
976   uint public optionsPerShare;
977   // options strike price
978   uint constant public STRIKE_PRICE = 1;
979   // company address
980   address public companyAddress;
981   // checks if calculator i initialized
982   function hasParameters() public constant returns(bool) { return optionsPerShare > 0; }
983 
984   modifier onlyCompany() {
985     if (companyAddress != msg.sender)
986       throw;
987     _;
988   }
989 
990   function calcNewEmployeePoolOptions(uint remainingPoolOptions)
991     public
992     constant
993     returns (uint)
994   {
995     return divRound(remainingPoolOptions * newEmployeePoolPromille, FP_SCALE);
996   }
997 
998   function calculateVestedOptions(uint t, uint vestingStarts, uint options)
999     public
1000     constant
1001     returns (uint)
1002   {
1003     if (t <= vestingStarts)
1004       return 0;
1005     // apply vesting
1006     uint effectiveTime = t - vestingStarts;
1007     // if within cliff nothing is due
1008     if (effectiveTime < cliffPeriod)
1009       return 0;
1010     else
1011       return  effectiveTime < vestingPeriod ? divRound(options * effectiveTime, vestingPeriod) : options;
1012   }
1013 
1014   function applyFadeoutToOptions(uint32 t, uint32 issueDate, uint32 terminatedAt, uint options, uint vestedOptions)
1015     public
1016     constant
1017     returns (uint)
1018   {
1019     if (t < terminatedAt)
1020       return vestedOptions;
1021     uint timefromTermination = t - terminatedAt;
1022     // fadeout duration equals to employment duration
1023     uint employmentPeriod = terminatedAt - issueDate;
1024     // minimum value of options at the end of fadeout, it is a % of all employee's options
1025     uint minFadeValue = divRound(options * (FP_SCALE - maxFadeoutPromille), FP_SCALE);
1026     // however employee cannot have more than options after fadeout than he was vested at termination
1027     if (minFadeValue >= vestedOptions)
1028       return vestedOptions;
1029     return timefromTermination > employmentPeriod ?
1030       minFadeValue  :
1031       (minFadeValue + divRound((vestedOptions - minFadeValue) * (employmentPeriod - timefromTermination), employmentPeriod));
1032   }
1033 
1034   function calculateOptionsComponents(uint[9] employee, uint32 calcAtTime, uint32 conversionOfferedAt,
1035     bool disableAcceleratedVesting)
1036     public
1037     constant
1038     returns (uint, uint, uint)
1039   {
1040     // returns tuple of (vested pool options, vested extra options, bonus)
1041     Employee memory emp = deserializeEmployee(employee);
1042     // no options for converted options or when esop is not singed
1043     if (emp.state == EmployeeState.OptionsExercised || emp.state == EmployeeState.WaitingForSignature)
1044       return (0,0,0);
1045     // no options when esop is being converted and conversion deadline expired
1046     bool isESOPConverted = conversionOfferedAt > 0 && calcAtTime >= conversionOfferedAt; // this function time-travels
1047     uint issuedOptions = emp.poolOptions + emp.extraOptions;
1048     // employee with no options
1049     if (issuedOptions == 0)
1050       return (0,0,0);
1051     // if emp is terminated but we calc options before term, simulate employed again
1052     if (calcAtTime < emp.terminatedAt && emp.terminatedAt > 0)
1053       emp.state = EmployeeState.Employed;
1054     uint vestedOptions = issuedOptions;
1055     bool accelerateVesting = isESOPConverted && emp.state == EmployeeState.Employed && !disableAcceleratedVesting;
1056     if (!accelerateVesting) {
1057       // choose vesting time
1058       uint32 calcVestingAt = emp.state ==
1059         // if terminated then vesting calculated at termination
1060         EmployeeState.Terminated ? emp.terminatedAt :
1061         // if employee is supended then compute vesting at suspension time
1062         (emp.suspendedAt > 0 && emp.suspendedAt < calcAtTime ? emp.suspendedAt :
1063         // if conversion offer then vesting calucated at time the offer was made
1064         conversionOfferedAt > 0 ? conversionOfferedAt :
1065         // otherwise use current time
1066         calcAtTime);
1067       vestedOptions = calculateVestedOptions(calcVestingAt, emp.issueDate, issuedOptions);
1068     }
1069     // calc fadeout for terminated employees
1070     if (emp.state == EmployeeState.Terminated) {
1071       // use conversion event time to compute fadeout to stop fadeout on conversion IF not after conversion date
1072       vestedOptions = applyFadeoutToOptions(isESOPConverted ? conversionOfferedAt : calcAtTime,
1073         emp.issueDate, emp.terminatedAt, issuedOptions, vestedOptions);
1074     }
1075     var (vestedPoolOptions, vestedExtraOptions) = extractVestedOptionsComponents(emp.poolOptions, emp.extraOptions, vestedOptions);
1076     // if (vestedPoolOptions + vestedExtraOptions != vestedOptions) throw;
1077     return  (vestedPoolOptions, vestedExtraOptions,
1078       accelerateVesting ? divRound(vestedPoolOptions*bonusOptionsPromille, FP_SCALE) : 0 );
1079   }
1080 
1081   function calculateOptions(uint[9] employee, uint32 calcAtTime, uint32 conversionOfferedAt, bool disableAcceleratedVesting)
1082     public
1083     constant
1084     returns (uint)
1085   {
1086     var (vestedPoolOptions, vestedExtraOptions, bonus) = calculateOptionsComponents(employee, calcAtTime,
1087       conversionOfferedAt, disableAcceleratedVesting);
1088     return vestedPoolOptions + vestedExtraOptions + bonus;
1089   }
1090 
1091   function extractVestedOptionsComponents(uint issuedPoolOptions, uint issuedExtraOptions, uint vestedOptions)
1092     public
1093     constant
1094     returns (uint, uint)
1095   {
1096     // breaks down vested options into pool options and extra options components
1097     if (issuedExtraOptions == 0)
1098       return (vestedOptions, 0);
1099     uint poolOptions = divRound(issuedPoolOptions*vestedOptions, issuedPoolOptions + issuedExtraOptions);
1100     return (poolOptions, vestedOptions - poolOptions);
1101   }
1102 
1103   function calculateFadeoutToPool(uint32 t, uint[9] employee)
1104     public
1105     constant
1106     returns (uint, uint)
1107   {
1108     Employee memory emp = deserializeEmployee(employee);
1109 
1110     uint vestedOptions = calculateVestedOptions(emp.terminatedAt, emp.issueDate, emp.poolOptions);
1111     uint returnedPoolOptions = applyFadeoutToOptions(emp.fadeoutStarts, emp.issueDate, emp.terminatedAt, emp.poolOptions, vestedOptions) -
1112       applyFadeoutToOptions(t, emp.issueDate, emp.terminatedAt, emp.poolOptions, vestedOptions);
1113     uint vestedExtraOptions = calculateVestedOptions(emp.terminatedAt, emp.issueDate, emp.extraOptions);
1114     uint returnedExtraOptions = applyFadeoutToOptions(emp.fadeoutStarts, emp.issueDate, emp.terminatedAt, emp.extraOptions, vestedExtraOptions) -
1115       applyFadeoutToOptions(t, emp.issueDate, emp.terminatedAt, emp.extraOptions, vestedExtraOptions);
1116 
1117     return (returnedPoolOptions, returnedExtraOptions);
1118   }
1119 
1120   function simulateOptions(uint32 issueDate, uint32 terminatedAt, uint32 poolOptions,
1121     uint32 extraOptions, uint32 suspendedAt, uint8 employeeState, uint32 calcAtTime)
1122     public
1123     constant
1124     returns (uint)
1125   {
1126     Employee memory emp = Employee({issueDate: issueDate, terminatedAt: terminatedAt,
1127       poolOptions: poolOptions, extraOptions: extraOptions, state: EmployeeState(employeeState),
1128       timeToSign: issueDate+2 weeks, fadeoutStarts: terminatedAt, suspendedAt: suspendedAt,
1129       idx:1});
1130     return calculateOptions(serializeEmployee(emp), calcAtTime, 0, false);
1131   }
1132 
1133   function setParameters(uint32 pCliffPeriod, uint32 pVestingPeriod, uint32 pResidualAmountPromille,
1134     uint32 pBonusOptionsPromille, uint32 pNewEmployeePoolPromille, uint32 pOptionsPerShare)
1135     external
1136     onlyCompany
1137   {
1138     if (pResidualAmountPromille > FP_SCALE || pBonusOptionsPromille > FP_SCALE || pNewEmployeePoolPromille > FP_SCALE
1139      || pOptionsPerShare == 0)
1140       throw;
1141     if (pCliffPeriod > pVestingPeriod)
1142       throw;
1143     // initialization cannot be called for a second time
1144     if (hasParameters())
1145       throw;
1146     cliffPeriod = pCliffPeriod;
1147     vestingPeriod = pVestingPeriod;
1148     maxFadeoutPromille = FP_SCALE - pResidualAmountPromille;
1149     bonusOptionsPromille = pBonusOptionsPromille;
1150     newEmployeePoolPromille = pNewEmployeePoolPromille;
1151     optionsPerShare = pOptionsPerShare;
1152   }
1153 
1154   function OptionsCalculator(address pCompanyAddress) {
1155     companyAddress = pCompanyAddress;
1156   }
1157 }
1158 
1159 contract ProceedsOptionsConverter is Ownable, ERC20OptionsConverter {
1160   mapping (address => uint) internal withdrawals;
1161   uint[] internal payouts;
1162 
1163   function makePayout() converted payable onlyOwner public {
1164     // it does not make sense to distribute less than ether
1165     if (msg.value < 1 ether)
1166       throw;
1167     payouts.push(msg.value);
1168   }
1169 
1170   function withdraw() converted public returns (uint) {
1171     // withdraw for msg.sender
1172     uint balance = balanceOf(msg.sender);
1173     if (balance == 0)
1174       return 0;
1175     uint paymentId = withdrawals[msg.sender];
1176     // if all payouts for given token holder executed then exit
1177     if (paymentId == payouts.length)
1178       return 0;
1179     uint payout = 0;
1180     for (uint i = paymentId; i<payouts.length; i++) {
1181       // it is safe to make payouts pro-rata: (1) token supply will not change - check converted/conversion modifiers
1182       // -- (2) balances will not change: check transfer override which limits transfer between accounts
1183       // NOTE: safeMul throws on overflow, can lock users out of their withdrawals if balance is very high
1184       // @remco I know. any suggestions? expression below gives most precision
1185       uint thisPayout = divRound(safeMul(payouts[i], balance), totalSupply);
1186       payout += thisPayout;
1187     }
1188     // change now to prevent re-entry (not necessary due to low send() gas limit)
1189     withdrawals[msg.sender] = payouts.length;
1190     if (payout > 0) {
1191       // now modify payout within 1000 weis as we had rounding errors coming from pro-rata amounts
1192       // @remco maximum rounding error is (num_employees * num_payments) / 2 with the mean 0
1193       // --- 1000 wei is still nothing, please explain me what problem you see here
1194       if ( absDiff(this.balance, payout) < 1000 wei )
1195         payout = this.balance; // send all
1196       //if(!msg.sender.call.value(payout)()) // re entry test
1197       //  throw;
1198       if (!msg.sender.send(payout))
1199         throw;
1200     }
1201     return payout;
1202   }
1203 
1204   function transfer(address _to, uint _value) public converted {
1205     // if anything was withdrawn then block transfer to prevent multiple withdrawals
1206     // todo: we could allow transfer to new account (no token balance)
1207     // todo: we could allow transfer between account that fully withdrawn (but what's the point? -token has 0 value then)
1208     // todo: there are a few other edge cases where there's transfer and no double spending
1209     if (withdrawals[_to] > 0 || withdrawals[msg.sender] > 0)
1210       throw;
1211     ERC20OptionsConverter.transfer(_to, _value);
1212   }
1213 
1214   function ProceedsOptionsConverter(address esop, uint32 exerciseDeadline, uint32 conversionDeadline)
1215     ERC20OptionsConverter(esop, exerciseDeadline, conversionDeadline)
1216   {
1217   }
1218 }
1219 
1220 contract RoT is Ownable {
1221     address public ESOPAddress;
1222     event ESOPAndCompanySet(address ESOPAddress, address companyAddress);
1223 
1224     function setESOP(address ESOP, address company) public onlyOwner {
1225       // owner sets ESOP and company only once then passes ownership to company
1226       // initially owner is a developer/admin
1227       ESOPAddress = ESOP;
1228       transferOwnership(company);
1229       ESOPAndCompanySet(ESOP, company);
1230     }
1231 
1232     function killOnUnsupportedFork() public onlyOwner {
1233       // this method may only be called by company on unsupported forks
1234       delete ESOPAddress;
1235       selfdestruct(owner);
1236     }
1237 }