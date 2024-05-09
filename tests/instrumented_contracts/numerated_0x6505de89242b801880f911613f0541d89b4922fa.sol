1 pragma solidity ^0.5.0;
2 
3 
4 
5 /// @title SelfAuthorized - authorizes current contract to perform actions
6 /// @author Richard Meissner - <richard@gnosis.pm>
7 contract SelfAuthorized {
8     modifier authorized() {
9         require(msg.sender == address(this), "Method can only be called from this contract");
10         _;
11     }
12 }
13 
14 
15 /// @title MasterCopy - Base for master copy contracts (should always be first super contract)
16 /// @author Richard Meissner - <richard@gnosis.pm>
17 contract MasterCopy is SelfAuthorized {
18   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
19   // It should also always be ensured that the address is stored alone (uses a full word)
20     address masterCopy;
21 
22   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
23   /// @param _masterCopy New contract address.
24     function changeMasterCopy(address _masterCopy)
25         public
26         authorized
27     {
28         // Master copy address cannot be null.
29         require(_masterCopy != address(0), "Invalid master copy address provided");
30         masterCopy = _masterCopy;
31     }
32 }
33 
34 
35 /// @title Enum - Collection of enums
36 /// @author Richard Meissner - <richard@gnosis.pm>
37 contract Enum {
38     enum Operation {
39         Call,
40         DelegateCall,
41         Create
42     }
43 }
44 
45 
46 /// @title EtherPaymentFallback - A contract that has a fallback to accept ether payments
47 /// @author Richard Meissner - <richard@gnosis.pm>
48 contract EtherPaymentFallback {
49 
50     /// @dev Fallback function accepts Ether transactions.
51     function ()
52         external
53         payable
54     {
55 
56     }
57 }
58 
59 
60 /// @title Executor - A contract that can execute transactions
61 /// @author Richard Meissner - <richard@gnosis.pm>
62 contract Executor is EtherPaymentFallback {
63 
64     event ContractCreation(address newContract);
65 
66     function execute(address to, uint256 value, bytes memory data, Enum.Operation operation, uint256 txGas)
67         internal
68         returns (bool success)
69     {
70         if (operation == Enum.Operation.Call)
71             success = executeCall(to, value, data, txGas);
72         else if (operation == Enum.Operation.DelegateCall)
73             success = executeDelegateCall(to, data, txGas);
74         else {
75             address newContract = executeCreate(data);
76             success = newContract != address(0);
77             emit ContractCreation(newContract);
78         }
79     }
80 
81     function executeCall(address to, uint256 value, bytes memory data, uint256 txGas)
82         internal
83         returns (bool success)
84     {
85         // solium-disable-next-line security/no-inline-assembly
86         assembly {
87             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
88         }
89     }
90 
91     function executeDelegateCall(address to, bytes memory data, uint256 txGas)
92         internal
93         returns (bool success)
94     {
95         // solium-disable-next-line security/no-inline-assembly
96         assembly {
97             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
98         }
99     }
100 
101     function executeCreate(bytes memory data)
102         internal
103         returns (address newContract)
104     {
105         // solium-disable-next-line security/no-inline-assembly
106         assembly {
107             newContract := create(0, add(data, 0x20), mload(data))
108         }
109     }
110 }
111 
112 
113 /// @title Module Manager - A contract that manages modules that can execute transactions via this contract
114 /// @author Stefan George - <stefan@gnosis.pm>
115 /// @author Richard Meissner - <richard@gnosis.pm>
116 contract ModuleManager is SelfAuthorized, Executor {
117 
118     event EnabledModule(Module module);
119     event DisabledModule(Module module);
120 
121     address public constant SENTINEL_MODULES = address(0x1);
122 
123     mapping (address => address) internal modules;
124     
125     function setupModules(address to, bytes memory data)
126         internal
127     {
128         require(modules[SENTINEL_MODULES] == address(0), "Modules have already been initialized");
129         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
130         if (to != address(0))
131             // Setup has to complete successfully or transaction fails.
132             require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
133     }
134 
135     /// @dev Allows to add a module to the whitelist.
136     ///      This can only be done via a Safe transaction.
137     /// @param module Module to be whitelisted.
138     function enableModule(Module module)
139         public
140         authorized
141     {
142         // Module address cannot be null or sentinel.
143         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
144         // Module cannot be added twice.
145         require(modules[address(module)] == address(0), "Module has already been added");
146         modules[address(module)] = modules[SENTINEL_MODULES];
147         modules[SENTINEL_MODULES] = address(module);
148         emit EnabledModule(module);
149     }
150 
151     /// @dev Allows to remove a module from the whitelist.
152     ///      This can only be done via a Safe transaction.
153     /// @param prevModule Module that pointed to the module to be removed in the linked list
154     /// @param module Module to be removed.
155     function disableModule(Module prevModule, Module module)
156         public
157         authorized
158     {
159         // Validate module address and check that it corresponds to module index.
160         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
161         require(modules[address(prevModule)] == address(module), "Invalid prevModule, module pair provided");
162         modules[address(prevModule)] = modules[address(module)];
163         modules[address(module)] = address(0);
164         emit DisabledModule(module);
165     }
166 
167     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
168     /// @param to Destination address of module transaction.
169     /// @param value Ether value of module transaction.
170     /// @param data Data payload of module transaction.
171     /// @param operation Operation type of module transaction.
172     function execTransactionFromModule(address to, uint256 value, bytes memory data, Enum.Operation operation)
173         public
174         returns (bool success)
175     {
176         // Only whitelisted modules are allowed.
177         require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "Method can only be called from an enabled module");
178         // Execute transaction without further confirmations.
179         success = execute(to, value, data, operation, gasleft());
180     }
181 
182     /// @dev Returns array of modules.
183     /// @return Array of modules.
184     function getModules()
185         public
186         view
187         returns (address[] memory)
188     {
189         // Calculate module count
190         uint256 moduleCount = 0;
191         address currentModule = modules[SENTINEL_MODULES];
192         while(currentModule != SENTINEL_MODULES) {
193             currentModule = modules[currentModule];
194             moduleCount ++;
195         }
196         address[] memory array = new address[](moduleCount);
197 
198         // populate return array
199         moduleCount = 0;
200         currentModule = modules[SENTINEL_MODULES];
201         while(currentModule != SENTINEL_MODULES) {
202             array[moduleCount] = currentModule;
203             currentModule = modules[currentModule];
204             moduleCount ++;
205         }
206         return array;
207     }
208 }
209 
210 
211 /// @title Module - Base class for modules.
212 /// @author Stefan George - <stefan@gnosis.pm>
213 /// @author Richard Meissner - <richard@gnosis.pm>
214 contract Module is MasterCopy {
215 
216     ModuleManager public manager;
217 
218     modifier authorized() {
219         require(msg.sender == address(manager), "Method can only be called from manager");
220         _;
221     }
222 
223     function setManager()
224         internal
225     {
226         // manager can only be 0 at initalization of contract.
227         // Check ensures that setup function can only be called once.
228         require(address(manager) == address(0), "Manager has already been set");
229         manager = ModuleManager(msg.sender);
230     }
231 }
232 
233 /// @title OwnerManager - Manages a set of owners and a threshold to perform actions.
234 /// @author Stefan George - <stefan@gnosis.pm>
235 /// @author Richard Meissner - <richard@gnosis.pm>
236 contract OwnerManager is SelfAuthorized {
237 
238     event AddedOwner(address owner);
239     event RemovedOwner(address owner);
240     event ChangedThreshold(uint256 threshold);
241 
242     address public constant SENTINEL_OWNERS = address(0x1);
243 
244     mapping(address => address) internal owners;
245     uint256 ownerCount;
246     uint256 internal threshold;
247 
248     /// @dev Setup function sets initial storage of contract.
249     /// @param _owners List of Safe owners.
250     /// @param _threshold Number of required confirmations for a Safe transaction.
251     function setupOwners(address[] memory _owners, uint256 _threshold)
252         internal
253     {
254         // Threshold can only be 0 at initialization.
255         // Check ensures that setup function can only be called once.
256         require(threshold == 0, "Owners have already been setup");
257         // Validate that threshold is smaller than number of added owners.
258         require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
259         // There has to be at least one Safe owner.
260         require(_threshold >= 1, "Threshold needs to be greater than 0");
261         // Initializing Safe owners.
262         address currentOwner = SENTINEL_OWNERS;
263         for (uint256 i = 0; i < _owners.length; i++) {
264             // Owner address cannot be null.
265             address owner = _owners[i];
266             require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
267             // No duplicate owners allowed.
268             require(owners[owner] == address(0), "Duplicate owner address provided");
269             owners[currentOwner] = owner;
270             currentOwner = owner;
271         }
272         owners[currentOwner] = SENTINEL_OWNERS;
273         ownerCount = _owners.length;
274         threshold = _threshold;
275     }
276 
277     /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
278     ///      This can only be done via a Safe transaction.
279     /// @param owner New owner address.
280     /// @param _threshold New threshold.
281     function addOwnerWithThreshold(address owner, uint256 _threshold)
282         public
283         authorized
284     {
285         // Owner address cannot be null.
286         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
287         // No duplicate owners allowed.
288         require(owners[owner] == address(0), "Address is already an owner");
289         owners[owner] = owners[SENTINEL_OWNERS];
290         owners[SENTINEL_OWNERS] = owner;
291         ownerCount++;
292         emit AddedOwner(owner);
293         // Change threshold if threshold was changed.
294         if (threshold != _threshold)
295             changeThreshold(_threshold);
296     }
297 
298     /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
299     ///      This can only be done via a Safe transaction.
300     /// @param prevOwner Owner that pointed to the owner to be removed in the linked list
301     /// @param owner Owner address to be removed.
302     /// @param _threshold New threshold.
303     function removeOwner(address prevOwner, address owner, uint256 _threshold)
304         public
305         authorized
306     {
307         // Only allow to remove an owner, if threshold can still be reached.
308         require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
309         // Validate owner address and check that it corresponds to owner index.
310         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
311         require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
312         owners[prevOwner] = owners[owner];
313         owners[owner] = address(0);
314         ownerCount--;
315         emit RemovedOwner(owner);
316         // Change threshold if threshold was changed.
317         if (threshold != _threshold)
318             changeThreshold(_threshold);
319     }
320 
321     /// @dev Allows to swap/replace an owner from the Safe with another address.
322     ///      This can only be done via a Safe transaction.
323     /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
324     /// @param oldOwner Owner address to be replaced.
325     /// @param newOwner New owner address.
326     function swapOwner(address prevOwner, address oldOwner, address newOwner)
327         public
328         authorized
329     {
330         // Owner address cannot be null.
331         require(newOwner != address(0) && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
332         // No duplicate owners allowed.
333         require(owners[newOwner] == address(0), "Address is already an owner");
334         // Validate oldOwner address and check that it corresponds to owner index.
335         require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
336         require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
337         owners[newOwner] = owners[oldOwner];
338         owners[prevOwner] = newOwner;
339         owners[oldOwner] = address(0);
340         emit RemovedOwner(oldOwner);
341         emit AddedOwner(newOwner);
342     }
343 
344     /// @dev Allows to update the number of required confirmations by Safe owners.
345     ///      This can only be done via a Safe transaction.
346     /// @param _threshold New threshold.
347     function changeThreshold(uint256 _threshold)
348         public
349         authorized
350     {
351         // Validate that threshold is smaller than number of owners.
352         require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
353         // There has to be at least one Safe owner.
354         require(_threshold >= 1, "Threshold needs to be greater than 0");
355         threshold = _threshold;
356         emit ChangedThreshold(threshold);
357     }
358 
359     function getThreshold()
360         public
361         view
362         returns (uint256)
363     {
364         return threshold;
365     }
366 
367     function isOwner(address owner)
368         public
369         view
370         returns (bool)
371     {
372         return owner != SENTINEL_OWNERS && owners[owner] != address(0);
373     }
374 
375     /// @dev Returns array of owners.
376     /// @return Array of Safe owners.
377     function getOwners()
378         public
379         view
380         returns (address[] memory)
381     {
382         address[] memory array = new address[](ownerCount);
383 
384         // populate return array
385         uint256 index = 0;
386         address currentOwner = owners[SENTINEL_OWNERS];
387         while(currentOwner != SENTINEL_OWNERS) {
388             array[index] = currentOwner;
389             currentOwner = owners[currentOwner];
390             index ++;
391         }
392         return array;
393     }
394 }
395 
396 /// @title GEnum - Collection of enums for subscriptions
397 /// @author Andrew Redden - <andrew@groundhog.network>
398 contract GEnum {
399     enum SubscriptionStatus {
400         INIT,
401         TRIAL,
402         VALID,
403         CANCELLED,
404         EXPIRED
405     }
406 
407     enum Period {
408         INIT,
409         DAY,
410         WEEK,
411         MONTH,
412         YEAR
413     }
414 }
415 
416 
417 /// @title SignatureDecoder - Decodes signatures that a encoded as bytes
418 /// @author Ricardo Guilherme Schmidt (Status Research & Development GmbH) 
419 /// @author Richard Meissner - <richard@gnosis.pm>
420 contract SignatureDecoder {
421     
422     /// @dev Recovers address who signed the message 
423     /// @param messageHash operation ethereum signed message hash
424     /// @param messageSignature message `txHash` signature
425     /// @param pos which signature to read
426     function recoverKey (
427         bytes32 messageHash, 
428         bytes memory messageSignature,
429         uint256 pos
430     )
431         internal
432         pure
433         returns (address) 
434     {
435         uint8 v;
436         bytes32 r;
437         bytes32 s;
438         (v, r, s) = signatureSplit(messageSignature, pos);
439         return ecrecover(messageHash, v, r, s);
440     }
441 
442     /// @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`
443     /// @param pos which signature to read
444     /// @param signatures concatenated rsv signatures
445     function signatureSplit(bytes memory signatures, uint256 pos)
446         internal
447         pure
448         returns (uint8 v, bytes32 r, bytes32 s)
449     {
450         // The signature format is a compact form of:
451         //   {bytes32 r}{bytes32 s}{uint8 v}
452         // Compact means, uint8 is not padded to 32 bytes.
453         // solium-disable-next-line security/no-inline-assembly
454         assembly {
455             let signaturePos := mul(0x41, pos)
456             r := mload(add(signatures, add(signaturePos, 0x20)))
457             s := mload(add(signatures, add(signaturePos, 0x40)))
458             // Here we are loading the last 32 bytes, including 31 bytes
459             // of 's'. There is no 'mload8' to do this.
460             //
461             // 'byte' is not working due to the Solidity parser, so lets
462             // use the second best option, 'and'
463             v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
464         }
465     }
466 }
467 
468 // ----------------------------------------------------------------------------
469 // BokkyPooBah's DateTime Library v1.00
470 //
471 // A gas-efficient Solidity date and time library
472 //
473 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
474 //
475 // Tested date range 1970/01/01 to 2345/12/31
476 //
477 // Conventions:
478 // Unit      | Range         | Notes
479 // :-------- |:-------------:|:-----
480 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
481 // year      | 1970 ... 2345 |
482 // month     | 1 ... 12      |
483 // day       | 1 ... 31      |
484 // hour      | 0 ... 23      |
485 // minute    | 0 ... 59      |
486 // second    | 0 ... 59      |
487 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
488 //
489 //
490 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018.
491 //
492 // GNU Lesser General Public License 3.0
493 // https://www.gnu.org/licenses/lgpl-3.0.en.html
494 // ----------------------------------------------------------------------------
495 
496 library BokkyPooBahsDateTimeLibrary {
497 
498     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
499     uint constant SECONDS_PER_HOUR = 60 * 60;
500     uint constant SECONDS_PER_MINUTE = 60;
501     int constant OFFSET19700101 = 2440588;
502 
503     uint constant DOW_MON = 1;
504     uint constant DOW_TUE = 2;
505     uint constant DOW_WED = 3;
506     uint constant DOW_THU = 4;
507     uint constant DOW_FRI = 5;
508     uint constant DOW_SAT = 6;
509     uint constant DOW_SUN = 7;
510 
511     // ------------------------------------------------------------------------
512     // Calculate the number of days from 1970/01/01 to year/month/day using
513     // the date conversion algorithm from
514     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
515     // and subtracting the offset 2440588 so that 1970/01/01 is day 0
516     //
517     // days = day
518     //      - 32075
519     //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
520     //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
521     //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
522     //      - offset
523     // ------------------------------------------------------------------------
524     function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
525         require(year >= 1970);
526         int _year = int(year);
527         int _month = int(month);
528         int _day = int(day);
529 
530         int __days = _day
531         - 32075
532         + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
533         + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
534         - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
535         - OFFSET19700101;
536 
537         _days = uint(__days);
538     }
539 
540     // ------------------------------------------------------------------------
541     // Calculate year/month/day from the number of days since 1970/01/01 using
542     // the date conversion algorithm from
543     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
544     // and adding the offset 2440588 so that 1970/01/01 is day 0
545     //
546     // int L = days + 68569 + offset
547     // int N = 4 * L / 146097
548     // L = L - (146097 * N + 3) / 4
549     // year = 4000 * (L + 1) / 1461001
550     // L = L - 1461 * year / 4 + 31
551     // month = 80 * L / 2447
552     // dd = L - 2447 * month / 80
553     // L = month / 11
554     // month = month + 2 - 12 * L
555     // year = 100 * (N - 49) + year + L
556     // ------------------------------------------------------------------------
557     function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
558         int __days = int(_days);
559 
560         int L = __days + 68569 + OFFSET19700101;
561         int N = 4 * L / 146097;
562         L = L - (146097 * N + 3) / 4;
563         int _year = 4000 * (L + 1) / 1461001;
564         L = L - 1461 * _year / 4 + 31;
565         int _month = 80 * L / 2447;
566         int _day = L - 2447 * _month / 80;
567         L = _month / 11;
568         _month = _month + 2 - 12 * L;
569         _year = 100 * (N - 49) + _year + L;
570 
571         year = uint(_year);
572         month = uint(_month);
573         day = uint(_day);
574     }
575 
576     function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
577         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
578     }
579     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
580         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
581     }
582     function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
583         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
584     }
585     function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
586         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
587         uint secs = timestamp % SECONDS_PER_DAY;
588         hour = secs / SECONDS_PER_HOUR;
589         secs = secs % SECONDS_PER_HOUR;
590         minute = secs / SECONDS_PER_MINUTE;
591         second = secs % SECONDS_PER_MINUTE;
592     }
593 
594     function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
595         if (year >= 1970 && month > 0 && month <= 12) {
596             uint daysInMonth = _getDaysInMonth(year, month);
597             if (day > 0 && day <= daysInMonth) {
598                 valid = true;
599             }
600         }
601     }
602     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
603         if (isValidDate(year, month, day)) {
604             if (hour < 24 && minute < 60 && second < 60) {
605                 valid = true;
606             }
607         }
608     }
609     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
610         uint year;
611         uint month;
612         uint day;
613         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
614         leapYear = _isLeapYear(year);
615     }
616     function _isLeapYear(uint year) internal pure returns (bool leapYear) {
617         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
618     }
619     function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
620         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
621     }
622     function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
623         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
624     }
625     function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
626         uint year;
627         uint month;
628         uint day;
629         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
630         daysInMonth = _getDaysInMonth(year, month);
631     }
632     function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
633         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
634             daysInMonth = 31;
635         } else if (month != 2) {
636             daysInMonth = 30;
637         } else {
638             daysInMonth = _isLeapYear(year) ? 29 : 28;
639         }
640     }
641     // 1 = Monday, 7 = Sunday
642     function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
643         uint _days = timestamp / SECONDS_PER_DAY;
644         dayOfWeek = (_days + 3) % 7 + 1;
645     }
646 
647     function getYear(uint timestamp) internal pure returns (uint year) {
648         uint month;
649         uint day;
650         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
651     }
652     function getMonth(uint timestamp) internal pure returns (uint month) {
653         uint year;
654         uint day;
655         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
656     }
657     function getDay(uint timestamp) internal pure returns (uint day) {
658         uint year;
659         uint month;
660         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
661     }
662     function getHour(uint timestamp) internal pure returns (uint hour) {
663         uint secs = timestamp % SECONDS_PER_DAY;
664         hour = secs / SECONDS_PER_HOUR;
665     }
666     function getMinute(uint timestamp) internal pure returns (uint minute) {
667         uint secs = timestamp % SECONDS_PER_HOUR;
668         minute = secs / SECONDS_PER_MINUTE;
669     }
670     function getSecond(uint timestamp) internal pure returns (uint second) {
671         second = timestamp % SECONDS_PER_MINUTE;
672     }
673 
674     function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
675         uint year;
676         uint month;
677         uint day;
678         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
679         year += _years;
680         uint daysInMonth = _getDaysInMonth(year, month);
681         if (day > daysInMonth) {
682             day = daysInMonth;
683         }
684         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
685         require(newTimestamp >= timestamp);
686     }
687     function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
688         uint year;
689         uint month;
690         uint day;
691         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
692         month += _months;
693         year += (month - 1) / 12;
694         month = (month - 1) % 12 + 1;
695         uint daysInMonth = _getDaysInMonth(year, month);
696         if (day > daysInMonth) {
697             day = daysInMonth;
698         }
699         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
700         require(newTimestamp >= timestamp);
701     }
702     function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
703         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
704         require(newTimestamp >= timestamp);
705     }
706     function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
707         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
708         require(newTimestamp >= timestamp);
709     }
710     function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
711         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
712         require(newTimestamp >= timestamp);
713     }
714     function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
715         newTimestamp = timestamp + _seconds;
716         require(newTimestamp >= timestamp);
717     }
718 
719     function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
720         uint year;
721         uint month;
722         uint day;
723         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
724         year -= _years;
725         uint daysInMonth = _getDaysInMonth(year, month);
726         if (day > daysInMonth) {
727             day = daysInMonth;
728         }
729         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
730         require(newTimestamp <= timestamp);
731     }
732     function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
733         uint year;
734         uint month;
735         uint day;
736         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
737         uint yearMonth = year * 12 + (month - 1) - _months;
738         year = yearMonth / 12;
739         month = yearMonth % 12 + 1;
740         uint daysInMonth = _getDaysInMonth(year, month);
741         if (day > daysInMonth) {
742             day = daysInMonth;
743         }
744         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
745         require(newTimestamp <= timestamp);
746     }
747     function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
748         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
749         require(newTimestamp <= timestamp);
750     }
751     function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
752         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
753         require(newTimestamp <= timestamp);
754     }
755     function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
756         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
757         require(newTimestamp <= timestamp);
758     }
759     function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
760         newTimestamp = timestamp - _seconds;
761         require(newTimestamp <= timestamp);
762     }
763 
764     function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
765         require(fromTimestamp <= toTimestamp);
766         uint fromYear;
767         uint fromMonth;
768         uint fromDay;
769         uint toYear;
770         uint toMonth;
771         uint toDay;
772         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
773         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
774         _years = toYear - fromYear;
775     }
776     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
777         require(fromTimestamp <= toTimestamp);
778         uint fromYear;
779         uint fromMonth;
780         uint fromDay;
781         uint toYear;
782         uint toMonth;
783         uint toDay;
784         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
785         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
786         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
787     }
788     function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
789         require(fromTimestamp <= toTimestamp);
790         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
791     }
792     function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
793         require(fromTimestamp <= toTimestamp);
794         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
795     }
796     function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
797         require(fromTimestamp <= toTimestamp);
798         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
799     }
800     function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
801         require(fromTimestamp <= toTimestamp);
802         _seconds = toTimestamp - fromTimestamp;
803     }
804 }
805 /// math.sol -- mixin for inline numerical wizardry
806 
807 // This program is free software: you can redistribute it and/or modify
808 // it under the terms of the GNU General Public License as published by
809 // the Free Software Foundation, either version 3 of the License, or
810 // (at your option) any later version.
811 
812 // This program is distributed in the hope that it will be useful,
813 // but WITHOUT ANY WARRANTY; without even the implied warranty of
814 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
815 // GNU General Public License for more details.
816 
817 // You should have received a copy of the GNU General Public License
818 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
819 
820 
821 library DSMath {
822     function add(uint x, uint y) internal pure returns (uint z) {
823         require((z = x + y) >= x);
824     }
825     function sub(uint x, uint y) internal pure returns (uint z) {
826         require((z = x - y) <= x);
827     }
828     function mul(uint x, uint y) internal pure returns (uint z) {
829         require(y == 0 || (z = x * y) / y == x);
830     }
831 
832     function min(uint x, uint y) internal pure returns (uint z) {
833         return x <= y ? x : y;
834     }
835     function max(uint x, uint y) internal pure returns (uint z) {
836         return x >= y ? x : y;
837     }
838     function imin(int x, int y) internal pure returns (int z) {
839         return x <= y ? x : y;
840     }
841     function imax(int x, int y) internal pure returns (int z) {
842         return x >= y ? x : y;
843     }
844 
845     uint constant WAD = 10 ** 18;
846     uint constant RAY = 10 ** 27;
847 
848     function wmul(uint x, uint y) internal pure returns (uint z) {
849         z = add(mul(x, y), WAD / 2) / WAD;
850     }
851     function rmul(uint x, uint y) internal pure returns (uint z) {
852         z = add(mul(x, y), RAY / 2) / RAY;
853     }
854     function wdiv(uint x, uint y) internal pure returns (uint z) {
855         z = add(mul(x, WAD), y / 2) / y;
856     }
857     function rdiv(uint x, uint y) internal pure returns (uint z) {
858         z = add(mul(x, RAY), y / 2) / y;
859     }
860 
861     function tmul(uint x, uint y, uint z) internal pure returns (uint a) {
862         require(z != 0);
863         a = add(mul(x, y), z / 2) / z;
864     }
865 
866     function tdiv(uint x, uint y, uint z) internal pure returns (uint a) {
867         a = add(mul(x, z), y / 2) / y;
868     }
869 
870     // This famous algorithm is called "exponentiation by squaring"
871     // and calculates x^n with x as fixed-point and n as regular unsigned.
872     //
873     // It's O(log n), instead of O(n) for naive repeated multiplication.
874     //
875     // These facts are why it works:
876     //
877     //  If n is even, then x^n = (x^2)^(n/2).
878     //  If n is odd,  then x^n = x * x^(n-1),
879     //   and applying the equation for even x gives
880     //    x^n = x * (x^2)^((n-1) / 2).
881     //
882     //  Also, EVM division is flooring and
883     //    floor[(n-1) / 2] = floor[n / 2].
884     //
885     function rpow(uint x, uint n) internal pure returns (uint z) {
886         z = n % 2 != 0 ? x : RAY;
887 
888         for (n /= 2; n != 0; n /= 2) {
889             x = rmul(x, x);
890 
891             if (n % 2 != 0) {
892                 z = rmul(z, x);
893             }
894         }
895     }
896 }
897 
898 
899 interface OracleRegistry {
900 
901     function read(
902         uint256 currencyPair
903     ) external view returns (bytes32);
904 
905     function getNetworkExecutor()
906     external
907     view
908     returns (address);
909 
910     function getNetworkWallet()
911     external
912     view
913     returns (address payable);
914 
915     function getNetworkFee(address asset)
916     external
917     view
918     returns (uint256 fee);
919 }
920 
921 /// @title SubscriptionModule - A module with support for Subscription Payments
922 /// @author Andrew Redden - <andrew@groundhog.network>
923 contract SubscriptionModule is Module, SignatureDecoder {
924 
925     using BokkyPooBahsDateTimeLibrary for uint256;
926     using DSMath for uint256;
927     string public constant NAME = "Groundhog";
928     string public constant VERSION = "0.1.0";
929 
930     bytes32 public domainSeparator;
931     address public oracleRegistry;
932 
933     //keccak256(
934     //    "EIP712Domain(address verifyingContract)"
935     //);
936     bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;
937 
938     //keccak256(
939     //  "SafeSubTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 dataGas,uint256 gasPrice,address gasToken,address refundReceiver,bytes meta)"
940     //)
941     bytes32 public constant SAFE_SUB_TX_TYPEHASH = 0x4494907805e3ceba396741b2837174bdf548ec2cbe03f5448d7fa8f6b1aaf98e;
942 
943     //keccak256(
944     //  "SafeSubCancelTx(bytes32 subscriptionHash,string action)"
945     //)
946     bytes32 public constant SAFE_SUB_CANCEL_TX_TYPEHASH = 0xef5a0c558cb538697e29722572248a2340a367e5079b08a00b35ef5dd1e66faa;
947 
948     mapping(bytes32 => Meta) public subscriptions;
949 
950     struct Meta {
951         GEnum.SubscriptionStatus status;
952         uint256 nextWithdraw;
953         uint256 endDate;
954         uint256 cycle;
955     }
956 
957     event NextPayment(
958         bytes32 indexed subscriptionHash,
959         uint256 nextWithdraw
960     );
961 
962     event OraclizedDenomination(
963         bytes32 indexed subscriptionHash,
964         uint256 dynPriceFormat,
965         uint256 conversionRate,
966         uint256 paymentTotal
967     );
968     event StatusChanged(
969         bytes32 indexed subscriptionHash,
970         GEnum.SubscriptionStatus prev,
971         GEnum.SubscriptionStatus next
972     );
973 
974     /// @dev Setup function sets manager
975     function setup(
976         address _oracleRegistry
977     )
978     public
979     {
980         setManager();
981 
982         require(
983             domainSeparator == 0,
984             "SubscriptionModule::setup: INVALID_STATE: DOMAIN_SEPARATOR_SET"
985         );
986 
987         domainSeparator = keccak256(
988             abi.encode(
989                 DOMAIN_SEPARATOR_TYPEHASH,
990                 address(this)
991             )
992         );
993 
994         require(
995             oracleRegistry == address(0),
996             "SubscriptionModule::setup: INVALID_STATE: ORACLE_REGISTRY_SET"
997         );
998 
999         oracleRegistry = _oracleRegistry;
1000     }
1001 
1002     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
1003     ///      Note: The fees are always transferred, even if the user transaction fails.
1004     /// @param to Destination address of Safe transaction.
1005     /// @param value Ether value of Safe transaction.
1006     /// @param data Data payload of Safe transaction.
1007     /// @param operation Operation type of Safe transaction.
1008     /// @param safeTxGas Gas that should be used for the Safe transaction.
1009     /// @param dataGas Gas costs for data used to trigger the safe transaction and to pay the payment transfer
1010     /// @param gasPrice Gas price that should be used for the payment calculation.
1011     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
1012     /// @param refundReceiver payout address or 0 if tx.origin
1013     /// @param meta Packed bytes data {address refundReceiver (required}, {uint256 period (required}, {uint256 offChainID (required}, {uint256 endDate (optional}
1014     /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint2568 v})
1015     /// @return success boolean value of execution
1016 
1017     function execSubscription(
1018         address to,
1019         uint256 value,
1020         bytes memory data,
1021         Enum.Operation operation,
1022         uint256 safeTxGas,
1023         uint256 dataGas,
1024         uint256 gasPrice,
1025         address gasToken,
1026         address payable refundReceiver,
1027         bytes memory meta,
1028         bytes memory signatures
1029     )
1030     public
1031     returns
1032     (
1033         bool
1034     )
1035     {
1036         uint256 startGas = gasleft();
1037 
1038         bytes memory subHashData = encodeSubscriptionData(
1039             to, value, data, operation, // Transaction info
1040             safeTxGas, dataGas, gasPrice, gasToken,
1041             refundReceiver, meta
1042         );
1043 
1044         require(
1045             gasleft() >= safeTxGas,
1046             "SubscriptionModule::execSubscription: INVALID_DATA: WALLET_TX_GAS"
1047         );
1048 
1049         require(
1050             _checkHash(
1051                 keccak256(subHashData), signatures
1052             ),
1053             "SubscriptionModule::execSubscription: INVALID_DATA: SIGNATURES"
1054         );
1055 
1056         _paySubscription(
1057             to, value, data, operation,
1058             keccak256(subHashData), meta
1059         );
1060 
1061         // We transfer the calculated tx costs to the refundReceiver to avoid sending it to intermediate contracts that have made calls
1062         if (gasPrice > 0) {
1063             _handleTxPayment(
1064                 startGas,
1065                 dataGas,
1066                 gasPrice,
1067                 gasToken,
1068                 refundReceiver
1069             );
1070         }
1071 
1072         return true;
1073     }
1074 
1075     function _processMeta(
1076         bytes memory meta
1077     )
1078     internal
1079     view
1080     returns (
1081         uint256 conversionRate,
1082         uint256[4] memory outMeta
1083     )
1084     {
1085         require(
1086             meta.length == 160,
1087             "SubscriptionModule::_processMeta: INVALID_DATA: META_LENGTH"
1088         );
1089 
1090 
1091         (
1092         uint256 oracle,
1093         uint256 period,
1094         uint256 offChainID,
1095         uint256 startDate,
1096         uint256 endDate
1097         ) = abi.decode(
1098             meta,
1099             (uint, uint, uint, uint, uint) //5 slots
1100         );
1101 
1102         if (oracle != uint256(0)) {
1103 
1104             bytes32 rate = OracleRegistry(oracleRegistry).read(oracle);
1105             conversionRate = uint256(rate);
1106         } else {
1107             conversionRate = uint256(0);
1108         }
1109 
1110         return (conversionRate, [period, offChainID, startDate, endDate]);
1111     }
1112 
1113     function _paySubscription(
1114         address to,
1115         uint256 value,
1116         bytes memory data,
1117         Enum.Operation operation,
1118         bytes32 subscriptionHash,
1119         bytes memory meta
1120     )
1121     internal
1122     {
1123         uint256 conversionRate;
1124         uint256[4] memory processedMetaData;
1125 
1126         (conversionRate, processedMetaData) = _processMeta(meta);
1127 
1128         bool processPayment = _processSub(subscriptionHash, processedMetaData);
1129 
1130         if (processPayment) {
1131 
1132             //Oracle Registry address data is in slot1
1133             if (conversionRate != uint256(0)) {
1134 
1135                 //when in priceFeed format, price feeds are denominated in Ether but converted to the feed pairing
1136                 //ETHUSD, WBTC/USD
1137                 require(
1138                     value > 1.00 ether,
1139                     "SubscriptionModule::_paySubscription: INVALID_FORMAT: DYNAMIC_PRICE_FORMAT"
1140                 );
1141 
1142                 uint256 payment = value.wdiv(conversionRate);
1143 
1144                 emit OraclizedDenomination(
1145                     subscriptionHash,
1146                     value,
1147                     conversionRate,
1148                     payment
1149                 );
1150 
1151                 value = payment;
1152             }
1153 
1154             require(
1155                 manager.execTransactionFromModule(to, value, data, operation),
1156                 "SubscriptionModule::_paySubscription: INVALID_EXEC: PAY_SUB"
1157             );
1158         }
1159     }
1160 
1161     function _handleTxPayment(
1162         uint256 gasUsed,
1163         uint256 dataGas,
1164         uint256 gasPrice,
1165         address gasToken,
1166         address payable refundReceiver
1167     )
1168     internal
1169     {
1170         uint256 amount = gasUsed.sub(gasleft()).add(dataGas).mul(gasPrice);
1171         // solium-disable-next-line security/no-tx-origin
1172         address receiver = refundReceiver == address(0) ? tx.origin : refundReceiver;
1173 
1174         if (gasToken == address(0)) {
1175 
1176             // solium-disable-next-line security/no-send
1177             require(
1178                 manager.execTransactionFromModule(receiver, amount, "0x", Enum.Operation.Call),
1179                 "SubscriptionModule::_handleTxPayment: FAILED_EXEC: PAYMENT_ETH"
1180             );
1181         } else {
1182 
1183             bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", receiver, amount);
1184             // solium-disable-next-line security/no-inline-assembly
1185             require(
1186                 manager.execTransactionFromModule(gasToken, 0, data, Enum.Operation.Call),
1187                 "SubscriptionModule::_handleTxPayment: FAILED_EXEC: PAYMENT_GAS_TOKEN"
1188             );
1189         }
1190     }
1191 
1192     function _checkHash(
1193         bytes32 hash,
1194         bytes memory signatures
1195     )
1196     internal
1197     view
1198     returns (
1199         bool valid
1200     )
1201     {
1202         // There cannot be an owner with address 0.
1203         address lastOwner = address(0);
1204         address currentOwner;
1205         uint256 i;
1206         uint256 threshold = OwnerManager(address(manager)).getThreshold();
1207         // Validate threshold is reached.
1208         valid = false;
1209 
1210         for (i = 0; i < threshold; i++) {
1211 
1212             currentOwner = recoverKey(
1213                 hash,
1214                 signatures, i
1215             );
1216 
1217             require(
1218                 OwnerManager(address(manager)).isOwner(currentOwner),
1219                 "SubscriptionModule::_checkHash: INVALID_DATA: SIGNATURE_NOT_OWNER"
1220             );
1221 
1222             require(
1223                 currentOwner > lastOwner,
1224                 "SubscriptionModule::_checkHash: INVALID_DATA: SIGNATURE_OUT_ORDER"
1225             );
1226 
1227             lastOwner = currentOwner;
1228         }
1229 
1230         valid = true;
1231     }
1232 
1233 
1234     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
1235     ///      Note: The fees are always transferred, even if the user transaction fails.
1236     /// @param subscriptionHash bytes32 hash of on chain sub
1237     /// @return bool isValid returns the validity of the subscription
1238     function isValidSubscription(
1239         bytes32 subscriptionHash,
1240         bytes memory signatures
1241     )
1242     public
1243     view
1244     returns (bool isValid)
1245     {
1246 
1247         Meta storage sub = subscriptions[subscriptionHash];
1248 
1249         //exit early if we can
1250         if (sub.status == GEnum.SubscriptionStatus.INIT) {
1251             return _checkHash(
1252                 subscriptionHash,
1253                 signatures
1254             );
1255         }
1256 
1257         if (sub.status == GEnum.SubscriptionStatus.EXPIRED || sub.status == GEnum.SubscriptionStatus.CANCELLED) {
1258 
1259             require(
1260                 sub.endDate != 0,
1261                 "SubscriptionModule::isValidSubscription: INVALID_STATE: SUB_STATUS"
1262             );
1263 
1264             isValid = (now <= sub.endDate);
1265         } else if (
1266             (sub.status == GEnum.SubscriptionStatus.TRIAL && sub.nextWithdraw <= now)
1267             ||
1268             (sub.status == GEnum.SubscriptionStatus.VALID)
1269         ) {
1270             isValid = true;
1271         } else {
1272             isValid = false;
1273         }
1274     }
1275 
1276     function cancelSubscriptionAsManager(
1277         bytes32 subscriptionHash
1278     )
1279     authorized
1280     public
1281     returns (bool) {
1282 
1283         _cancelSubscription(subscriptionHash);
1284 
1285         return true;
1286     }
1287 
1288     function cancelSubscriptionAsRecipient(
1289         address to,
1290         uint256 value,
1291         bytes memory data,
1292         Enum.Operation operation,
1293         uint256 safeTxGas,
1294         uint256 dataGas,
1295         uint256 gasPrice,
1296         address gasToken,
1297         address refundReceiver,
1298         bytes memory meta,
1299         bytes memory signatures
1300     )
1301     public
1302     returns (bool) {
1303 
1304 
1305         bytes memory subHashData = encodeSubscriptionData(
1306             to, value, data, operation, // Transaction info
1307             safeTxGas, dataGas, gasPrice, gasToken,
1308             refundReceiver, meta
1309         );
1310 
1311         require(
1312             _checkHash(keccak256(subHashData), signatures),
1313             "SubscriptionModule::cancelSubscriptionAsRecipient: INVALID_DATA: SIGNATURES"
1314         );
1315 
1316         //if no value, assume its an ERC20 token, remove the to argument from the data
1317         if (value == uint(0)) {
1318 
1319             address recipient;
1320             // solium-disable-next-line security/no-inline-assembly
1321             assembly {
1322                 recipient := div(mload(add(add(data, 0x20), 16)), 0x1000000000000000000000000)
1323             }
1324             require(msg.sender == recipient, "SubscriptionModule::isRecipient: MSG_SENDER_NOT_RECIPIENT_ERC");
1325         } else {
1326 
1327             //we are sending ETH, so check the sender matches to argument
1328             require(msg.sender == to, "SubscriptionModule::isRecipient: MSG_SENDER_NOT_RECIPIENT_ETH");
1329         }
1330 
1331         _cancelSubscription(keccak256(subHashData));
1332 
1333         return true;
1334     }
1335 
1336 
1337     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that
1338     /// submitted the transaction.
1339     /// @return bool hash of on sub to revoke or cancel
1340     function cancelSubscription(
1341         bytes32 subscriptionHash,
1342         bytes memory signatures
1343     )
1344     public
1345     returns (bool)
1346     {
1347 
1348         bytes32 cancelHash = getSubscriptionActionHash(subscriptionHash, "cancel");
1349 
1350         require(
1351             _checkHash(cancelHash, signatures),
1352             "SubscriptionModule::cancelSubscription: INVALID_DATA: SIGNATURES_INVALID"
1353         );
1354 
1355         _cancelSubscription(subscriptionHash);
1356 
1357         return true;
1358     }
1359 
1360 
1361     function _cancelSubscription(bytes32 subscriptionHash)
1362     internal
1363     {
1364 
1365         Meta storage sub = subscriptions[subscriptionHash];
1366 
1367 
1368         require(
1369             (sub.status != GEnum.SubscriptionStatus.CANCELLED && sub.status != GEnum.SubscriptionStatus.EXPIRED),
1370             "SubscriptionModule::_cancelSubscription: INVALID_STATE: SUB_STATUS"
1371         );
1372 
1373         emit StatusChanged(
1374             subscriptionHash,
1375             sub.status,
1376             GEnum.SubscriptionStatus.CANCELLED
1377         );
1378 
1379         sub.status = GEnum.SubscriptionStatus.CANCELLED;
1380 
1381         if (sub.status != GEnum.SubscriptionStatus.INIT) {
1382             sub.endDate = sub.nextWithdraw;
1383         }
1384 
1385         sub.nextWithdraw = 0;
1386 
1387         emit NextPayment(
1388             subscriptionHash,
1389             sub.nextWithdraw
1390         );
1391     }
1392 
1393     /// @dev used to help mitigate stack issues
1394     /// @return bool
1395     function _processSub(
1396         bytes32 subscriptionHash,
1397         uint256[4] memory processedMeta
1398     )
1399     internal
1400     returns (bool)
1401     {
1402         uint256 period = processedMeta[0];
1403         uint256 offChainID = processedMeta[1];
1404         uint256 startDate = processedMeta[2];
1405         uint256 endDate = processedMeta[3];
1406 
1407         uint256 withdrawHolder;
1408         Meta storage sub = subscriptions[subscriptionHash];
1409 
1410         require(
1411             (sub.status != GEnum.SubscriptionStatus.EXPIRED && sub.status != GEnum.SubscriptionStatus.CANCELLED),
1412             "SubscriptionModule::_processSub: INVALID_STATE: SUB_STATUS"
1413         );
1414 
1415 
1416         if (sub.status == GEnum.SubscriptionStatus.INIT) {
1417 
1418             if (endDate != 0) {
1419 
1420                 require(
1421                     endDate >= now,
1422                     "SubscriptionModule::_processSub: INVALID_DATA: SUB_END_DATE"
1423                 );
1424                 sub.endDate = endDate;
1425             }
1426 
1427             if (startDate != 0) {
1428 
1429                 require(
1430                     startDate >= now,
1431                     "SubscriptionModule::_processSub: INVALID_DATA: SUB_START_DATE"
1432                 );
1433                 sub.nextWithdraw = startDate;
1434                 sub.status = GEnum.SubscriptionStatus.TRIAL;
1435 
1436                 emit StatusChanged(
1437                     subscriptionHash,
1438                     GEnum.SubscriptionStatus.INIT,
1439                     GEnum.SubscriptionStatus.TRIAL
1440                 );
1441                 //emit here because of early method exit after trial setup
1442                 emit NextPayment(
1443                     subscriptionHash,
1444                     sub.nextWithdraw
1445                 );
1446 
1447                 return false;
1448             } else {
1449 
1450                 sub.nextWithdraw = now;
1451                 sub.status = GEnum.SubscriptionStatus.VALID;
1452                 emit StatusChanged(
1453                     subscriptionHash,
1454                     GEnum.SubscriptionStatus.INIT,
1455                     GEnum.SubscriptionStatus.VALID
1456                 );
1457             }
1458 
1459         } else if (sub.status == GEnum.SubscriptionStatus.TRIAL) {
1460 
1461             require(
1462                 now >= startDate,
1463                 "SubscriptionModule::_processSub: INVALID_STATE: SUB_START_DATE"
1464             );
1465             sub.nextWithdraw = now;
1466             sub.status = GEnum.SubscriptionStatus.VALID;
1467 
1468             emit StatusChanged(
1469                 subscriptionHash,
1470                 GEnum.SubscriptionStatus.TRIAL,
1471                 GEnum.SubscriptionStatus.VALID
1472             );
1473         }
1474 
1475         require(
1476             sub.status == GEnum.SubscriptionStatus.VALID,
1477             "SubscriptionModule::_processSub: INVALID_STATE: SUB_STATUS"
1478         );
1479 
1480         require(
1481             now >= sub.nextWithdraw && sub.nextWithdraw != 0,
1482             "SubscriptionModule::_processSub: INVALID_STATE: SUB_NEXT_WITHDRAW"
1483         );
1484 
1485         if (
1486             period == uint256(GEnum.Period.DAY)
1487         ) {
1488             withdrawHolder = BokkyPooBahsDateTimeLibrary.addDays(sub.nextWithdraw, 1);
1489         } else if (
1490             period == uint256(GEnum.Period.WEEK)
1491         ) {
1492             withdrawHolder = BokkyPooBahsDateTimeLibrary.addDays(sub.nextWithdraw, 7);
1493         } else if (
1494             period == uint256(GEnum.Period.MONTH)
1495         ) {
1496             withdrawHolder = BokkyPooBahsDateTimeLibrary.addMonths(sub.nextWithdraw, 1);
1497         } else if (
1498             period == uint256(GEnum.Period.YEAR)
1499         ) {
1500             withdrawHolder = BokkyPooBahsDateTimeLibrary.addYears(sub.nextWithdraw, 1);
1501         } else {
1502             revert("SubscriptionModule::_processSub: INVALID_DATA: PERIOD");
1503         }
1504 
1505         //if a subscription is expiring and its next withdraw timeline is beyond hte time of the expiration
1506         //modify the status
1507         if (sub.endDate != 0 && withdrawHolder >= sub.endDate) {
1508 
1509             sub.nextWithdraw = 0;
1510             emit StatusChanged(
1511                 subscriptionHash,
1512                 sub.status,
1513                 GEnum.SubscriptionStatus.EXPIRED
1514             );
1515             sub.status = GEnum.SubscriptionStatus.EXPIRED;
1516         } else {
1517             sub.nextWithdraw = withdrawHolder;
1518         }
1519 
1520         emit NextPayment(
1521             subscriptionHash,
1522             sub.nextWithdraw
1523         );
1524 
1525         return true;
1526     }
1527 
1528 
1529     function getSubscriptionMetaBytes(
1530         uint256 oracle,
1531         uint256 period,
1532         uint256 offChainID,
1533         uint256 startDate,
1534         uint256 endDate
1535     )
1536     public
1537     pure
1538     returns (bytes memory)
1539     {
1540         return abi.encodePacked(
1541             oracle,
1542             period,
1543             offChainID,
1544             startDate,
1545             endDate
1546         );
1547     }
1548 
1549     /// @dev Returns hash to be signed by owners.
1550     /// @param to Destination address.
1551     /// @param value Ether value.
1552     /// @param data Data payload.
1553     /// @param operation Operation type.
1554     /// @param safeTxGas Gas that should be used for the safe transaction.
1555     /// @param dataGas Gas costs for data used to trigger the safe transaction.
1556     /// @param gasPrice Maximum gas price that should be used for this transaction.
1557     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
1558     /// @param meta bytes refundReceiver / period / offChainID / endDate
1559     /// @return Subscription hash.
1560     function getSubscriptionHash(
1561         address to,
1562         uint256 value,
1563         bytes memory data,
1564         Enum.Operation operation,
1565         uint256 safeTxGas,
1566         uint256 dataGas,
1567         uint256 gasPrice,
1568         address gasToken,
1569         address refundReceiver,
1570         bytes memory meta
1571     )
1572     public
1573     view
1574     returns (bytes32)
1575     {
1576         return keccak256(
1577             encodeSubscriptionData(
1578                 to,
1579                 value,
1580                 data,
1581                 operation,
1582                 safeTxGas,
1583                 dataGas,
1584                 gasPrice,
1585                 gasToken,
1586                 refundReceiver,
1587                 meta
1588             )
1589         );
1590     }
1591 
1592     /// @dev Returns hash to be signed by owners for cancelling a subscription
1593     function getSubscriptionActionHash(
1594         bytes32 subscriptionHash,
1595         string memory action
1596     )
1597     public
1598     view
1599     returns (bytes32)
1600     {
1601 
1602         bytes32 safeSubCancelTxHash = keccak256(
1603             abi.encode(
1604                 SAFE_SUB_CANCEL_TX_TYPEHASH,
1605                 subscriptionHash,
1606                 keccak256(abi.encodePacked(action))
1607             )
1608         );
1609 
1610         return keccak256(
1611             abi.encodePacked(
1612                 byte(0x19),
1613                 byte(0x01),
1614                 domainSeparator,
1615                 safeSubCancelTxHash
1616             )
1617         );
1618     }
1619 
1620 
1621     /// @dev Returns the bytes that are hashed to be signed by owners.
1622     /// @param to Destination address.
1623     /// @param value Ether value.
1624     /// @param data Data payload.
1625     /// @param operation Operation type.
1626     /// @param safeTxGas Fas that should be used for the safe transaction.
1627     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
1628     /// @param meta bytes packed data(refund address, period, offChainID, endDate
1629     /// @return Subscription hash bytes.
1630     function encodeSubscriptionData(
1631         address to,
1632         uint256 value,
1633         bytes memory data,
1634         Enum.Operation operation,
1635         uint256 safeTxGas,
1636         uint256 dataGas,
1637         uint256 gasPrice,
1638         address gasToken,
1639         address refundReceiver,
1640         bytes memory meta
1641     )
1642     public
1643     view
1644     returns (bytes memory)
1645     {
1646         bytes32 safeSubTxHash = keccak256(
1647             abi.encode(
1648                 SAFE_SUB_TX_TYPEHASH,
1649                 to,
1650                 value,
1651                 keccak256(data),
1652                 operation,
1653                 safeTxGas,
1654                 dataGas,
1655                 gasPrice,
1656                 gasToken,
1657                 refundReceiver,
1658                 keccak256(meta)
1659             )
1660         );
1661 
1662         return abi.encodePacked(
1663             byte(0x19),
1664             byte(0x01),
1665             domainSeparator,
1666             safeSubTxHash
1667         );
1668     }
1669 
1670     /// @dev Allows to estimate a Safe transaction.
1671     ///      This method is only meant for estimation purpose, therfore two different protection mechanism against execution in a transaction have been made:
1672     ///      1.) The method can only be called from the safe itself
1673     ///      2.) The response is returned with a revert
1674     ///      When estimating set `from` to the address of the safe.
1675     ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
1676     /// @param to Destination address of Safe transaction.
1677     /// @param value Ether value of Safe transaction.
1678     /// @param data Data payload of Safe transaction.
1679     /// @param operation Operation type of Safe transaction.
1680     /// @param meta meta data of subscription agreement
1681     /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
1682     function requiredTxGas(
1683         address to,
1684         uint256 value,
1685         bytes memory data,
1686         Enum.Operation operation,
1687         bytes memory meta
1688     )
1689     public
1690     returns (uint256)
1691     {
1692         //check to ensure this method doesn't actually get executed outside of a call function
1693         require(
1694             msg.sender == address(this),
1695             "SubscriptionModule::requiredTxGas: INVALID_DATA: MSG_SENDER"
1696 
1697         );
1698 
1699         uint256 startGas = gasleft();
1700         // We don't provide an error message here, as we use it to return the estimate
1701         // solium-disable-next-line error-reason
1702 
1703         (uint256 conversionRate, uint256[4] memory pMeta) = _processMeta(meta);
1704 
1705         //Oracle Registry address data is in slot1
1706         if (conversionRate != uint256(0)) {
1707 
1708             require(
1709                 value > 1.00 ether,
1710                 "SubscriptionModule::requiredTxGas: INVALID_FORMAT: DYNAMIC_PRICE_FORMAT"
1711             );
1712 
1713             uint256 payment = value.wdiv(conversionRate);
1714             value = payment;
1715         }
1716 
1717         require(
1718             manager.execTransactionFromModule(to, value, data, operation),
1719             "SubscriptionModule::requiredTxGas: INVALID_EXEC: SUB_PAY"
1720         );
1721 
1722         uint256 requiredGas = startGas.sub(gasleft());
1723         // Convert response to string and return via error message
1724         revert(string(abi.encodePacked(requiredGas)));
1725 
1726     }
1727 }