1 pragma solidity ^0.4.15;
2 
3 
4 
5 
6 
7 
8 
9 library DateTime {
10         /*
11          *  Date and Time utilities for ethereum contracts
12          *
13          */
14         struct _DateTime {
15                 uint16 year;
16                 uint8 month;
17                 uint8 day;
18                 uint8 hour;
19                 uint8 minute;
20                 uint8 second;
21                 uint8 weekday;
22         }
23 
24         uint private constant DAY_IN_SECONDS = 86400;
25         uint private constant YEAR_IN_SECONDS = 31536000;
26         uint private constant LEAP_YEAR_IN_SECONDS = 31622400;
27 
28         uint private constant HOUR_IN_SECONDS = 3600;
29         uint private constant MINUTE_IN_SECONDS = 60;
30 
31         uint16 private constant ORIGIN_YEAR = 1970;
32 
33         function isLeapYear(uint16 year) public constant returns (bool) {
34                 if (year % 4 != 0) {
35                         return false;
36                 }
37                 if (year % 100 != 0) {
38                         return true;
39                 }
40                 if (year % 400 != 0) {
41                         return false;
42                 }
43                 return true;
44         }
45 
46         function leapYearsBefore(uint year) public constant  returns (uint) {
47                 year -= 1;
48                 return year / 4 - year / 100 + year / 400;
49         }
50 
51         function getDaysInMonth(uint8 month, uint16 year) public constant  returns (uint8) {
52                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
53                         return 31;
54                 }
55                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
56                         return 30;
57                 }
58                 else if (isLeapYear(year)) {
59                         return 29;
60                 }
61                 else {
62                         return 28;
63                 }
64         }
65 
66         function parseTimestamp(uint timestamp) internal constant returns (_DateTime dt) {
67                 uint secondsAccountedFor = 0;
68                 uint buf;
69                 uint8 i;
70 
71                 // Year
72                 dt.year = getYear(timestamp);
73                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
74 
75                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
76                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
77 
78                 // Month
79                 uint secondsInMonth;
80                 for (i = 1; i <= 12; i++) {
81                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
82                         if (secondsInMonth + secondsAccountedFor > timestamp) {
83                                 dt.month = i;
84                                 break;
85                         }
86                         secondsAccountedFor += secondsInMonth;
87                 }
88 
89                 // Day
90                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
91                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
92                                 dt.day = i;
93                                 break;
94                         }
95                         secondsAccountedFor += DAY_IN_SECONDS;
96                 }
97 
98                 // Hour
99                 dt.hour = getHour(timestamp);
100 
101                 // Minute
102                 dt.minute = getMinute(timestamp);
103 
104                 // Second
105                 dt.second = getSecond(timestamp);
106 
107                 // Day of week.
108                 dt.weekday = getWeekday(timestamp);
109         }
110 
111         function getYear(uint timestamp) public constant returns (uint16) {
112                 uint secondsAccountedFor = 0;
113                 uint16 year;
114                 uint numLeapYears;
115 
116                 // Year
117                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
118                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
119 
120                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
121                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
122 
123                 while (secondsAccountedFor > timestamp) {
124                         if (isLeapYear(uint16(year - 1))) {
125                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
126                         }
127                         else {
128                                 secondsAccountedFor -= YEAR_IN_SECONDS;
129                         }
130                         year -= 1;
131                 }
132                 return year;
133         }
134 
135         function getMonth(uint timestamp) public constant returns (uint8) {
136                 return parseTimestamp(timestamp).month;
137         }
138 
139         function getDay(uint timestamp) public constant returns (uint8) {
140                 return parseTimestamp(timestamp).day;
141         }
142 
143         function getHour(uint timestamp) public constant returns (uint8) {
144                 return uint8((timestamp / 60 / 60) % 24);
145         }
146 
147         function getMinute(uint timestamp) public constant returns (uint8) {
148                 return uint8((timestamp / 60) % 60);
149         }
150 
151         function getSecond(uint timestamp) public constant returns (uint8) {
152                 return uint8(timestamp % 60);
153         }
154 
155         function getWeekday(uint timestamp) public constant returns (uint8) {
156                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
157         }
158 
159         function toTimestamp(uint16 year, uint8 month, uint8 day) public constant returns (uint timestamp) {
160                 return toTimestamp(year, month, day, 0, 0, 0);
161         }
162 
163         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public constant returns (uint timestamp) {
164                 return toTimestamp(year, month, day, hour, 0, 0);
165         }
166 
167         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public constant returns (uint timestamp) {
168                 return toTimestamp(year, month, day, hour, minute, 0);
169         }
170 
171         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public constant returns (uint timestamp) {
172                 uint16 i;
173 
174                 // Year
175                 for (i = ORIGIN_YEAR; i < year; i++) {
176                         if (isLeapYear(i)) {
177                                 timestamp += LEAP_YEAR_IN_SECONDS;
178                         }
179                         else {
180                                 timestamp += YEAR_IN_SECONDS;
181                         }
182                 }
183 
184                 // Month
185                 uint8[12] memory monthDayCounts;
186                 monthDayCounts[0] = 31;
187                 if (isLeapYear(year)) {
188                         monthDayCounts[1] = 29;
189                 }
190                 else {
191                         monthDayCounts[1] = 28;
192                 }
193                 monthDayCounts[2] = 31;
194                 monthDayCounts[3] = 30;
195                 monthDayCounts[4] = 31;
196                 monthDayCounts[5] = 30;
197                 monthDayCounts[6] = 31;
198                 monthDayCounts[7] = 31;
199                 monthDayCounts[8] = 30;
200                 monthDayCounts[9] = 31;
201                 monthDayCounts[10] = 30;
202                 monthDayCounts[11] = 31;
203 
204                 for (i = 1; i < month; i++) {
205                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
206                 }
207 
208                 // Day
209                 timestamp += DAY_IN_SECONDS * (day - 1);
210 
211                 // Hour
212                 timestamp += HOUR_IN_SECONDS * (hour);
213 
214                 // Minute
215                 timestamp += MINUTE_IN_SECONDS * (minute);
216 
217                 // Second
218                 timestamp += second;
219 
220                 return timestamp;
221         }
222 
223 		// -1 t1 < t2
224 		// 0  t1 == t2
225 		// 1  t1 > t2
226 		function compareDatesWithoutTime(uint t1, uint t2) public constant returns (int res)
227 		{
228 			_DateTime memory dt1 = parseTimestamp(t1);
229 			_DateTime memory dt2 = parseTimestamp(t2);
230 
231 			res = compareInts(dt1.year, dt2.year);
232 			if (res == 0)
233 			{
234 				res = compareInts(dt1.month, dt2.month);
235 				if (res == 0)
236 				{
237 					res = compareInts(dt1.day, dt2.day);
238 				}
239 			}
240 		}
241 
242 
243 		//  t2 -> MoveIn or MoveOut day in GMT, will be counted as beginning of a day
244 		//  t1 -> Current System DateTime
245 		// -1 t1 before t2
246 		//--------------------------------
247 		// 0  t1 same day as t2
248 		// 1  t1 after t2
249 		function compareDateTimesForContract(uint t1, uint t2) public constant returns (int res)
250 		{
251 		    uint endOfDay = t2 + (60 * 60 * 24);
252 		    res = 0;
253 		    
254 		    if (t2 <= t1 && t1 <= endOfDay)
255 		    {
256 		        res = 0;
257 		    }
258 		    else if (t2 > t1)
259 		    {
260 		        res = -1;
261 		    }
262 		    else if (t1 > endOfDay)
263 		    {
264 		        res = 1;
265 		    }
266 		}	
267 
268 
269 		// -1 n1 < n2
270 		// 0  n1 == n2
271 		// 1  n1 > n2
272 		function compareInts(int n1, int n2) internal constant returns (int res)
273 		{
274 			if (n1 == n2)
275 			{
276 				res = 0;
277 			}
278 			else if (n1 < n2)
279 			{
280 				res = -1;
281 			}
282 			else if (n1 > n2)
283 			{
284 				res = 1;
285 			}
286 		}
287 }
288 
289 // ----------------------------------------------------------------------------
290 // ERC Token Standard #20 Interface
291 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
292 // ----------------------------------------------------------------------------
293 contract ERC20Interface {
294     function totalSupply() public constant returns (uint);
295     function balanceOf(address tokenOwner) public constant returns (uint balance);
296     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
297     function transfer(address to, uint tokens) public returns (bool success);
298     function approve(address spender, uint tokens) public returns (bool success);
299     function transferFrom(address from, address to, uint tokens) public returns (bool success);
300 
301     event Transfer(address indexed from, address indexed to, uint tokens);
302     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
303 }
304 
305 
306 library BaseEscrowLib
307 {
308     struct EscrowContractState { 
309 		uint _CurrentDate;
310 		uint _CreatedDate;
311 		int _RentPerDay;
312 		uint _MoveInDate;
313 		uint _MoveOutDate;				
314 		int _TotalAmount;					
315 		int _SecDeposit;
316 		int _State;	
317 		uint _ActualMoveInDate;
318 		uint _ActualMoveOutDate;
319 		address _landlord;
320 		address _tenant;
321 		bool _TenantConfirmedMoveIn;		
322 		bool _MisrepSignaled;			
323 		string _DoorLockData;
324 		address _ContractAddress;		
325 		ERC20Interface _tokenApi;
326 		int _landlBal;
327 		int _tenantBal;
328 		int _Id;
329 		int _CancelPolicy;
330 		uint _Balance;
331 		string _Guid;
332     }
333 
334     //Define public constants
335 	//Pre-Move In
336 	int internal constant ContractStateActive = 1;
337 	int internal constant ContractStateCancelledByTenant = 2;
338 	int internal constant ContractStateCancelledByLandlord = 3;
339 
340 	//Move-In
341 	int internal constant ContractStateTerminatedMisrep = 4;
342 
343 	//Living
344 	int internal constant ContractStateEarlyTerminatedByTenant = 5;
345 	int internal constant ContractStateEarlyTerminatedByTenantSecDep = 6;
346 	int internal constant ContractStateEarlyTerminatedByLandlord = 7;		
347 
348 	//Move-Out
349 	int internal constant ContractStateTerminatedOK = 8;	
350 	int internal constant ContractStateTerminatedSecDep = 9;
351 	
352 	//Stages
353 	int internal constant ContractStagePreMoveIn = 0;
354 	int internal constant ContractStageLiving = 1;
355 	int internal constant ContractStageTermination = 2;
356 
357 	//Action
358 	int internal constant ActionKeyTerminate = 0;
359 	int internal constant ActionKeyMoveIn = 1;	
360 	int internal constant ActionKeyTerminateMisrep = 2;	
361 	int internal constant ActionKeyPropOk = 3;
362 	int internal constant ActionKeyClaimDeposit = 4;
363 
364 	//Log
365 	int internal constant LogMessageInfo = 0;
366 	int internal constant LogMessageWarning = 1;
367 	int internal constant LogMessageError = 2;
368 
369 	event logEvent(int stage, int atype, uint timestamp, string guid, string text);
370 
371 
372 	//DEBUG or TESTNET
373 	//bool private constant EnableSimulatedCurrentDate = true;
374 
375 	//RELEASE
376 	bool private constant EnableSimulatedCurrentDate = false;
377 
378 
379 	//LogEvent wrapper
380 	function ContractLogEvent(int stage, int atype, uint timestamp, string guid, string text) public
381 	{
382 		logEvent(stage, atype, timestamp, guid, text);
383 	}
384 
385 	//Constant function wrappers
386 	function GetContractStateActive() public constant returns (int)
387 	{
388 		return ContractStateActive;
389 	}
390 
391 	function GetContractStateCancelledByTenant() public constant returns (int)
392 	{
393 		return ContractStateCancelledByTenant;
394 	}
395 
396 	function GetContractStateCancelledByLandlord() public constant returns (int)
397 	{
398 		return ContractStateCancelledByLandlord;
399 	}
400 	
401 	function GetContractStateTerminatedMisrep() public constant returns (int)
402 	{
403 		return ContractStateTerminatedMisrep;
404 	}
405 
406 	function GetContractStateEarlyTerminatedByTenant() public constant returns (int)
407 	{
408 		return ContractStateEarlyTerminatedByTenant;
409 	}
410 
411 	function GetContractStateEarlyTerminatedByTenantSecDep() public constant returns (int)
412 	{
413 		return ContractStateEarlyTerminatedByTenantSecDep;
414 	}
415 
416 	function GetContractStateEarlyTerminatedByLandlord() public constant returns (int)
417 	{
418 		return ContractStateEarlyTerminatedByLandlord;		
419 	}
420 
421 	function GetContractStateTerminatedOK() public constant returns (int)
422 	{
423 		return ContractStateTerminatedOK;	
424 	}
425 
426 	function GetContractStateTerminatedSecDep() public constant returns (int)
427 	{
428 		return ContractStateTerminatedSecDep;
429 	}
430 	
431 	function GetContractStagePreMoveIn() public constant returns (int)
432 	{
433 		return ContractStagePreMoveIn;
434 	}
435 
436 	function GetContractStageLiving() public constant returns (int)
437 	{
438 		return ContractStageLiving;
439 	}
440 
441 	function GetContractStageTermination() public constant returns (int)
442 	{
443 		return ContractStageTermination;
444 	}
445 	
446 	function GetLogMessageInfo() public constant returns (int)
447 	{
448 		return LogMessageInfo;
449 	}
450 
451 	function GetLogMessageWarning() public constant returns (int)
452 	{
453 		return LogMessageWarning;
454 	}
455 
456 	function GetLogMessageError() public constant returns (int)
457 	{
458 		return LogMessageError;
459 	}
460 
461 
462 	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
463 	function initialize(EscrowContractState storage self) {
464 
465 		//Check parameters
466 		//all dates must be in the future
467 
468 		require(self._CurrentDate < self._MoveInDate);
469 		require(self._MoveInDate < self._MoveOutDate);
470 							
471 		int nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
472 		int nPotentialBillableAmount = nPotentialBillableDays * (self._RentPerDay);
473 		
474 		//Limit 2 months stay
475 		require (nPotentialBillableDays <= 60); 
476 
477 		self._TotalAmount = nPotentialBillableAmount + self._SecDeposit;
478 				
479 		//Sec Deposit should not be more than 30 perecent
480 		require (self._SecDeposit / nPotentialBillableAmount * 100 <= 30);
481 				
482 
483 		self._TenantConfirmedMoveIn = false;
484 		self._MisrepSignaled = false;
485 		self._State = GetContractStateActive();
486 		self._ActualMoveInDate = 0;
487 		self._ActualMoveOutDate = 0;
488 		self._landlBal = 0;
489 		self._tenantBal = 0;
490 	}
491 
492 
493 	function TerminateContract(EscrowContractState storage self, int tenantBal, int landlBal, int state) public
494 	{
495 		int stage = GetCurrentStage(self);
496 		uint nCurrentDate = GetCurrentDate(self);
497 		int nActualBalance = int(GetContractBalance(self));
498 
499 		if (nActualBalance == 0)
500 		{
501 		    //If it was unfunded, just change state
502 		    self._State = state;   
503 		}
504 		else if (self._State == ContractStateActive && state != ContractStateActive)
505 		{
506 			//Check if some balances are negative
507 			if (landlBal < 0)
508 			{
509 				tenantBal += landlBal;
510 				landlBal = 0;
511 			}
512 
513 			if (tenantBal < 0) {
514 				landlBal += tenantBal;
515 				tenantBal = 0;
516 			}
517 
518 			//Check if balances exceed total amount
519 			if ((landlBal + tenantBal) > nActualBalance)
520 			{
521 				var nOverrun = (landlBal + tenantBal) - self._TotalAmount;
522 				landlBal -= (nOverrun / 2);
523 				tenantBal -= (nOverrun / 2);
524 			}
525 
526 			self._State = state;
527 
528 			string memory strState = "";
529 
530 			if (state == ContractStateTerminatedOK)
531 			{
532 				strState = " State is: OK";
533 			}
534 			else if (state == ContractStateEarlyTerminatedByTenant)
535 			{
536 				strState = " State is: Early terminated by tenant";
537 			}
538 			else if (state == ContractStateEarlyTerminatedByTenantSecDep)
539 			{
540 				strState = " State is: Early terminated by tenant, Security Deposit claimed";
541 			}
542 			else if (state == ContractStateEarlyTerminatedByLandlord)
543 			{
544 				strState = " State is: Early terminated by landlord";
545 			}
546 			else if (state == ContractStateCancelledByTenant)
547 			{
548 				strState = " State is: Cancelled by tenant";
549 			}
550 			else if (state == ContractStateCancelledByLandlord)
551 			{
552 				strState = " State is: Cancelled by landlord";
553 			}
554 			else if (state == ContractStateTerminatedSecDep)
555 			{
556 				strState = " State is: Security Deposit claimed";
557 			}
558 		
559 			
560 			
561 			bytes32 b1;
562 			bytes32 b2;
563 			b1 = uintToBytes(uint(landlBal));
564 			b2 = uintToBytes(uint(tenantBal));
565 
566                         /*
567 		    string memory s1;
568 		    string memory s2;	
569 		    s1 = bytes32ToString(b1);
570 		    s2 = bytes32ToString(b2);
571                         */
572 			
573 			string memory strMessage = strConcat(
574 			    "Contract is termintaing. Landlord balance is _$b_", 
575 			    bytes32ToString(b1), 
576 			    "_$e_, Tenant balance is _$b_", 
577 			    bytes32ToString(b2));
578 
579             
580 			string memory strMessage2 = strConcat(
581 				strMessage,
582 				"_$e_.",
583 				strState
584 			);
585 
586             string memory sGuid;
587             sGuid = self._Guid;
588 			
589             logEvent(stage, LogMessageInfo, nCurrentDate, sGuid, strMessage2);
590             
591 			//Send tokens
592 			self._landlBal = landlBal;
593 			self._tenantBal = tenantBal;
594 		}	
595 	}
596 
597 	function GetCurrentStage(EscrowContractState storage self) public constant returns (int stage)
598 	{
599 		uint nCurrentDate = GetCurrentDate(self);
600 		uint nActualBalance = GetContractBalance(self);
601         
602         stage = ContractStagePreMoveIn;
603         
604 		if (self._State == ContractStateActive && uint(self._TotalAmount) > nActualBalance)
605 		{
606 			//Contract unfunded
607 			stage = ContractStagePreMoveIn;
608 		}		
609 		else if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) < 0)
610 		{
611 			stage = ContractStagePreMoveIn;
612 		}
613 		else if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) >= 0 && 
614 		         DateTime.compareDateTimesForContract(nCurrentDate, self._MoveOutDate) < 0 && 
615 		         self._TenantConfirmedMoveIn)
616 		{
617 			stage = ContractStageLiving;
618 		}
619 		else if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveOutDate) >= 0)
620 		{
621 			stage = ContractStageTermination;
622 		}	
623 	}
624 
625 
626 
627 	///Helper functions
628 	function SimulateCurrentDate(EscrowContractState storage self, uint n) public
629 	{
630 		if (EnableSimulatedCurrentDate)
631 		{
632 			self._CurrentDate = n;
633 			//int stage = GetCurrentStage(self);
634 			//logEvent(stage, LogMessageInfo, self._CurrentDate, "SimulateCurrentDate was called.");	
635 		}
636 	}
637 	
638 	
639 	
640 	function GetCurrentDate(EscrowContractState storage self) public constant returns (uint nCurrentDate)
641 	{
642 		if (EnableSimulatedCurrentDate)
643 		{
644 			nCurrentDate = self._CurrentDate;
645 		}
646 		else
647 		{
648 			nCurrentDate = now;
649 		}	
650 	}
651 
652 	function GetContractBalance(EscrowContractState storage self) public returns (uint res)
653 	{
654 	    res = self._Balance;
655 	}
656 
657 
658 	function splitBalanceAccordingToRatings(int balance, int tenantScore, int landlScore) public constant returns (int tenantBal, int landlBal)
659 	{
660 		if (tenantScore == landlScore) {
661 			//Just split in two 
662 			tenantBal = balance / 2;
663 			landlBal = balance / 2;
664 		}
665 		else if (tenantScore == 0)
666 		{
667 			tenantBal = 0;
668 			landlBal = balance;			
669 		}
670 		else if (landlScore == 0) {
671 			tenantBal = balance;
672 			landlBal = 0;
673 		}
674 		else if (tenantScore > landlScore) {			
675 			landlBal = ((landlScore * balance / 2) / tenantScore);
676 			tenantBal = balance - landlBal;			
677 		}
678 		else if (tenantScore < landlScore) {			
679 			tenantBal = ((tenantScore * balance / 2) / landlScore);
680 			landlBal = balance - tenantBal;			
681 		}		
682 	}
683 
684 	function formatDate(uint dt) public constant returns (string strDate)
685 	{
686 		bytes32 b1;
687 		bytes32 b2;
688 		bytes32 b3;
689 		b1 = uintToBytes(uint(DateTime.getMonth(dt)));
690 		b2 = uintToBytes(uint(DateTime.getDay(dt)));
691 		b3 = uintToBytes(uint(DateTime.getYear(dt)));
692 		string memory s1;
693 		string memory s2;	
694 		string memory s3;
695 		s1 = bytes32ToString(b1);
696 		s2 = bytes32ToString(b2);
697 		s3 = bytes32ToString(b3);
698 		
699 		string memory strDate1 = strConcat(s1, "/", s2, "/");
700 		strDate = strConcat(strDate1, s3);			
701 	}
702 	
703 
704     function strConcat(string _a, string _b, string _c, string _d, string _e) internal constant returns (string){
705         bytes memory _ba = bytes(_a);
706         bytes memory _bb = bytes(_b);
707         bytes memory _bc = bytes(_c);
708         bytes memory _bd = bytes(_d);
709         bytes memory _be = bytes(_e);
710         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
711         bytes memory babcde = bytes(abcde);
712         uint k = 0;
713         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
714         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
715         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
716         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
717         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
718         return string(babcde);
719     }
720     
721     function strConcat(string _a, string _b, string _c, string _d) internal constant returns (string) {
722         return strConcat(_a, _b, _c, _d, "");
723     }
724     
725     function strConcat(string _a, string _b, string _c) internal constant returns (string) {
726         return strConcat(_a, _b, _c, "", "");
727     }
728     
729     function strConcat(string _a, string _b) internal constant returns (string) {
730         return strConcat(_a, _b, "", "", "");
731     } 
732     
733     function bytes32ToString(bytes32 x) internal constant returns (string) {
734         bytes memory bytesString = new bytes(32);
735         uint charCount = 0;
736         for (uint j = 0; j < 32; j++) {
737             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
738             if (char != 0) {
739                 bytesString[charCount] = char;
740                 charCount++;
741             }
742         }
743         bytes memory bytesStringTrimmed = new bytes(charCount);
744         for (j = 0; j < charCount; j++) {
745             bytesStringTrimmed[j] = bytesString[j];
746         }
747         return string(bytesStringTrimmed);
748     }
749 
750     function bytes32ArrayToString(bytes32[] data) internal constant returns (string) {
751         bytes memory bytesString = new bytes(data.length * 32);
752         uint urlLength;
753         for (uint i=0; i<data.length; i++) {
754             for (uint j=0; j<32; j++) {
755                 byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j)));
756                 if (char != 0) {
757                     bytesString[urlLength] = char;
758                     urlLength += 1;
759                 }
760             }
761         }
762         bytes memory bytesStringTrimmed = new bytes(urlLength);
763         for (i=0; i<urlLength; i++) {
764             bytesStringTrimmed[i] = bytesString[i];
765         }
766         return string(bytesStringTrimmed);
767     }  
768     
769     
770     function uintToBytes(uint v) internal constant returns (bytes32 ret) {
771         if (v == 0) {
772             ret = '0';
773         }
774         else {
775             while (v > 0) {
776                 ret = bytes32(uint(ret) / (2 ** 8));
777                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
778                 v /= 10;
779             }
780         }
781         return ret;
782     }
783 
784     /// @dev Converts a numeric string to it's unsigned integer representation.
785     /// @param v The string to be converted.
786     function bytesToUInt(bytes32 v) internal constant returns (uint ret) {
787         if (v == 0x0) {
788             throw;
789         }
790 
791         uint digit;
792 
793         for (uint i = 0; i < 32; i++) {
794             digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
795             if (digit == 0) {
796                 break;
797             }
798             else if (digit < 48 || digit > 57) {
799                 throw;
800             }
801             ret *= 10;
802             ret += (digit - 48);
803         }
804         return ret;
805     }    
806 
807 
808 }
809 
810 
811 library FlexibleEscrowLib
812 {
813 	using BaseEscrowLib for BaseEscrowLib.EscrowContractState;
814 
815     //Cancel days
816 	int internal constant FreeCancelBeforeMoveInDays = 14;
817 
818 	//Expiration
819 	int internal constant ExpireAfterMoveOutDays = 14;
820 		    
821 
822     
823 	function TenantTerminate(BaseEscrowLib.EscrowContractState storage self) public
824     {
825 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
826 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
827 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
828 		int tenantBal = 0;
829 		int landlBal = 0;
830 		int state = 0; 
831 		bool bProcessed = false;
832         string memory sGuid;
833         sGuid = self._Guid;
834 
835 		if (nActualBalance == 0)
836 		{
837 			//If contract is unfunded, just cancel it
838 			state = BaseEscrowLib.GetContractStateCancelledByTenant();
839 			bProcessed = true;			
840 		}
841 		else if (nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn())
842 		{			
843 			int nDaysBeforeMoveIn = (int)(self._MoveInDate - nCurrentDate) / (60 * 60 * 24);
844 			if (nDaysBeforeMoveIn < FreeCancelBeforeMoveInDays)
845 			{
846 				//Pay cancel fee
847 				//Contract must be fully funded
848 				require(self._RentPerDay <= nActualBalance);
849 
850 				//Cancellation fee is one day rent
851 				tenantBal = nActualBalance - self._RentPerDay;
852 				landlBal = self._RentPerDay;
853 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
854 				bProcessed = true;
855 
856 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow. Cancellation fee will be withheld from tenant.");										
857 			}
858 			else
859 			{
860 				//No cancel fee
861 				tenantBal = nActualBalance;
862 				landlBal = 0;
863 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
864 				bProcessed = true;
865 
866 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow.");
867 			}					
868 		}
869 		else if (nCurrentStage == BaseEscrowLib.GetContractStageLiving())
870 		{
871 			state = 0;
872 			self._ActualMoveOutDate = nCurrentDate;
873 			bProcessed = true;
874 			//In this case landlord will close escrow
875 
876 			BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant signaled early move-out");
877 		}
878 		else if (nCurrentStage == BaseEscrowLib.GetContractStageTermination())
879 		{
880 			//If landlord did not close the escrow, and if it is expired, tenant may only pay for rent without sec deposit
881 			int nDaysAfterMoveOut = (int)(nCurrentDate - self._MoveOutDate) / (60 * 60 * 24);
882 
883 			if (nDaysAfterMoveOut > ExpireAfterMoveOutDays)
884 			{
885 				int nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
886 				require(self._RentPerDay * nPotentialBillableDays <= nActualBalance);
887 
888 				landlBal = self._RentPerDay * nPotentialBillableDays;
889 				tenantBal = nActualBalance - landlBal;
890 				bProcessed = true;
891 				state = BaseEscrowLib.GetContractStateTerminatedOK();
892 
893 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant closed escrow because it was expired");
894 			}
895 		}
896 
897 		require(bProcessed);
898 		if (state > 0)
899 		{
900 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
901 		}
902 
903     }
904     
905     function TenantMoveIn(BaseEscrowLib.EscrowContractState storage self) public
906     {
907 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
908 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
909 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
910 		string memory sGuid;
911         sGuid = self._Guid;
912 				
913 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= self._TotalAmount && 
914 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) >= 0);
915 
916         BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant signaled move-in");
917 
918 		self._TenantConfirmedMoveIn = true;
919     } 
920 	       
921     function TenantTerminateMisrep(BaseEscrowLib.EscrowContractState storage self) public
922     {
923 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
924 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
925 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
926 		int tenantBal = 0;
927 		int landlBal = 0;
928         string memory sGuid;
929         sGuid = self._Guid;
930 
931 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= self._RentPerDay && 
932 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) == 0);
933 
934 		(tenantBal, landlBal) = BaseEscrowLib.splitBalanceAccordingToRatings(self._RentPerDay,0,0);
935 					
936 		tenantBal = nActualBalance - landlBal;
937 		
938 		BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant signaled misrepresentation and terminated escrow!");
939 		self._MisrepSignaled = true;
940 
941 		BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,BaseEscrowLib.GetContractStateTerminatedMisrep());	         
942     }    
943 	
944 	function LandlordTerminate(BaseEscrowLib.EscrowContractState storage self, uint SecDeposit) public
945 	{
946 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
947 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
948 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
949 		int tenantBal = 0;
950 		int landlBal = 0;
951 		int state = 0; 
952 		bool bProcessed = false;
953 		int nPotentialBillableDays = 0;
954         string memory sGuid;
955         sGuid = self._Guid;
956 
957 		if (nActualBalance == 0)
958 		{
959 			//If contract is unfunded, just cancel it
960 			state = BaseEscrowLib.GetContractStateCancelledByLandlord();
961 			bProcessed = true;			
962 		}
963 		else if (nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn())
964 		{	
965 			if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) > 0 && 
966 				!self._TenantConfirmedMoveIn)
967 			{
968 				//Landlord gets cancell fee if tenant did not signal anything after move in date
969 				tenantBal = nActualBalance - self._RentPerDay;	
970 				landlBal = self._RentPerDay;
971 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
972 				bProcessed = true;
973 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Landlord cancelled escrow. Tenant did not show up and will pay cancellation fee.");								
974 			}
975 			else
976 			{		        				
977 				//No cancel fee
978 				tenantBal = nActualBalance;
979 				landlBal = 0;
980 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
981 				bProcessed = true;
982 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord cancelled esqrow");								
983 			}
984 		}
985 		else if (nCurrentStage == BaseEscrowLib.GetContractStageLiving())
986 		{
987 			nPotentialBillableDays = (int)(nCurrentDate - self._MoveInDate) / (60 * 60 * 24);
988 			
989 			if (self._ActualMoveOutDate == 0)
990 			{
991 				//If landlord initiates it, he cannot claim sec deposit
992 				require(nActualBalance >= nPotentialBillableDays * self._RentPerDay);
993 				state = BaseEscrowLib.GetContractStateEarlyTerminatedByLandlord();
994 				landlBal = nPotentialBillableDays * self._RentPerDay;
995 				tenantBal = nActualBalance - landlBal;
996 				bProcessed = true;
997 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled early move-out");
998 			}
999 			else{
1000 				//If tenant initiates it, landlord can claim sec deposit, and tenant pays for one extra day
1001 				require(int(SecDeposit) <= self._SecDeposit && nActualBalance >= (nPotentialBillableDays + 1) * self._RentPerDay + int(SecDeposit));
1002 				
1003 				if (SecDeposit == 0)
1004 				{
1005 					state = BaseEscrowLib.GetContractStateEarlyTerminatedByTenant();
1006 				}
1007 				else
1008 				{
1009 					BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled Security Deposit");
1010 					state = BaseEscrowLib.GetContractStateEarlyTerminatedByTenantSecDep();
1011 				}
1012 
1013 				landlBal = (nPotentialBillableDays + 1) * self._RentPerDay + int(SecDeposit);
1014 				tenantBal = nActualBalance - landlBal;
1015 				bProcessed = true;
1016 			}
1017 		}
1018 		else if (nCurrentStage == BaseEscrowLib.GetContractStageTermination())
1019 		{
1020 			nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1021 			require(int(SecDeposit) <= self._SecDeposit && nActualBalance >= nPotentialBillableDays * self._RentPerDay + int(SecDeposit));
1022 			if (SecDeposit == 0)
1023 			{
1024 				state = BaseEscrowLib.GetContractStateTerminatedOK();
1025 			}
1026 			else
1027 			{
1028 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled Security Deposit");
1029 				state = BaseEscrowLib.GetContractStateTerminatedSecDep();
1030 			}
1031 			landlBal = nPotentialBillableDays * self._RentPerDay + int(SecDeposit);
1032 			tenantBal = nActualBalance - landlBal;
1033 			bProcessed = true;
1034 		}
1035 
1036 		require(bProcessed);
1037 		if (state > 0)
1038 		{
1039 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
1040 		}	
1041 	}
1042 }
1043 
1044 library ModerateEscrowLib
1045 {
1046 	using BaseEscrowLib for BaseEscrowLib.EscrowContractState;
1047 
1048     //Cancel days
1049 	int internal constant FreeCancelBeforeMoveInDays = 30;
1050 
1051 	//Expiration
1052 	int internal constant ExpireAfterMoveOutDays = 14;
1053 		    
1054     
1055 	function TenantTerminate(BaseEscrowLib.EscrowContractState storage self) public
1056     {
1057 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1058 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1059 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1060 		int tenantBal = 0;
1061 		int landlBal = 0;
1062 		int state = 0; 
1063 		bool bProcessed = false;
1064         string memory sGuid;
1065         sGuid = self._Guid;
1066 
1067 		if (nActualBalance == 0)
1068 		{
1069 			//If contract is unfunded, just cancel it
1070 			state = BaseEscrowLib.GetContractStateCancelledByTenant();
1071 			bProcessed = true;			
1072 		}
1073 		else if (nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn())
1074 		{			
1075 			int nDaysBeforeMoveIn = (int)(self._MoveInDate - nCurrentDate) / (60 * 60 * 24);
1076 			if (nDaysBeforeMoveIn < FreeCancelBeforeMoveInDays)
1077 			{
1078 				//Pay cancel fee
1079 				//Contract must be fully funded
1080 
1081 				int cancelFee = (self._TotalAmount - self._SecDeposit) / 2;
1082 
1083 				require(cancelFee <= nActualBalance);
1084 
1085 				//Cancellation fee is half of the rent to pay
1086 				tenantBal = nActualBalance - cancelFee;
1087 				landlBal = cancelFee;
1088 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
1089 				bProcessed = true;
1090 
1091 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow. Cancellation fee will be withheld from tenant.");										
1092 			}
1093 			else
1094 			{
1095 				//No cancel fee
1096 				tenantBal = nActualBalance;
1097 				landlBal = 0;
1098 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
1099 				bProcessed = true;
1100 
1101 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow.");
1102 			}					
1103 		}
1104 		else if (nCurrentStage == BaseEscrowLib.GetContractStageLiving())
1105 		{
1106 			state = 0;
1107 			self._ActualMoveOutDate = nCurrentDate;
1108 			bProcessed = true;
1109 			//In this case landlord will close escrow
1110 
1111 			BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant signaled early move-out");
1112 		}
1113 		else if (nCurrentStage == BaseEscrowLib.GetContractStageTermination())
1114 		{
1115 			//If landlord did not close the escrow, and if it is expired, tenant may only pay for rent without sec deposit
1116 			int nDaysAfterMoveOut = (int)(nCurrentDate - self._MoveOutDate) / (60 * 60 * 24);
1117 
1118 			if (nDaysAfterMoveOut > ExpireAfterMoveOutDays)
1119 			{
1120 				int nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1121 				require(self._RentPerDay * nPotentialBillableDays <= nActualBalance);
1122 
1123 				landlBal = self._RentPerDay * nPotentialBillableDays;
1124 				tenantBal = nActualBalance - landlBal;
1125 				bProcessed = true;
1126 				state = BaseEscrowLib.GetContractStateTerminatedOK();
1127 
1128 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant closed escrow because it was expired");
1129 			}
1130 		}
1131 
1132 		require(bProcessed);
1133 		if (state > 0)
1134 		{
1135 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
1136 		}
1137 
1138     }
1139     
1140     function TenantMoveIn(BaseEscrowLib.EscrowContractState storage self) public
1141     {
1142 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1143 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1144 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1145         string memory sGuid;
1146         sGuid = self._Guid;
1147 				
1148 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= self._TotalAmount && 
1149 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) >= 0);
1150 
1151         BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant signaled move-in");
1152 
1153 		self._TenantConfirmedMoveIn = true;
1154     } 
1155 	       
1156     function TenantTerminateMisrep(BaseEscrowLib.EscrowContractState storage self) public
1157     {
1158 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1159 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1160 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1161 		int tenantBal = 0;
1162 		int landlBal = 0;
1163 		int cancelFee = (self._TotalAmount - self._SecDeposit) / 2;
1164         string memory sGuid;
1165         sGuid = self._Guid;
1166 
1167 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= cancelFee && 
1168 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) == 0);
1169 
1170 		(tenantBal, landlBal) = BaseEscrowLib.splitBalanceAccordingToRatings(cancelFee,0,0);
1171 					
1172 		tenantBal = nActualBalance - landlBal;
1173 		
1174 		BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant signaled misrepresentation and terminated escrow!");
1175 		self._MisrepSignaled = true;
1176 
1177 		BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,BaseEscrowLib.GetContractStateTerminatedMisrep());	         
1178     }    
1179 	
1180 	function LandlordTerminate(BaseEscrowLib.EscrowContractState storage self, uint SecDeposit) public
1181 	{
1182 		//int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1183 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1184 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1185 		int tenantBal = 0;
1186 		int landlBal = 0;
1187 		int state = 0; 
1188 		bool bProcessed = false;
1189 		int nPotentialBillableDays = 0;
1190 		int cancelFee = (self._TotalAmount - self._SecDeposit) / 2;
1191         string memory sGuid;
1192         sGuid = self._Guid;
1193 
1194 		if (nActualBalance == 0)
1195 		{
1196 			//If contract is unfunded, just cancel it
1197 			state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1198 			bProcessed = true;			
1199 		}
1200 		else if (BaseEscrowLib.GetCurrentStage(self) == BaseEscrowLib.GetContractStagePreMoveIn())
1201 		{	
1202 			if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) > 0 && 
1203 				!self._TenantConfirmedMoveIn)
1204 			{
1205 				//Landlord gets cancell fee if tenant did not signal anything after move in date
1206 				tenantBal = nActualBalance - cancelFee;	
1207 				landlBal = cancelFee;
1208 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1209 				bProcessed = true;
1210 				BaseEscrowLib.ContractLogEvent(BaseEscrowLib.GetCurrentStage(self), BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Landlord cancelled escrow. Tenant did not show up and will pay cancellation fee.");								
1211 			}
1212 			else
1213 			{		        				
1214 				//No cancel fee
1215 				tenantBal = nActualBalance;
1216 				landlBal = 0;
1217 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1218 				bProcessed = true;
1219 				BaseEscrowLib.ContractLogEvent(BaseEscrowLib.GetCurrentStage(self), BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord cancelled esqrow");								
1220 			}
1221 		}
1222 		else if (BaseEscrowLib.GetCurrentStage(self) == BaseEscrowLib.GetContractStageLiving())
1223 		{
1224 			nPotentialBillableDays = (int)(nCurrentDate - self._MoveInDate) / (60 * 60 * 24);
1225 			
1226 			if (self._ActualMoveOutDate == 0)
1227 			{
1228 				//If landlord initiates it, he cannot claim sec deposit
1229 				require(nActualBalance >= nPotentialBillableDays * self._RentPerDay);
1230 				state = BaseEscrowLib.GetContractStateEarlyTerminatedByLandlord();
1231 				landlBal = nPotentialBillableDays * self._RentPerDay;
1232 				tenantBal = nActualBalance - landlBal;
1233 				bProcessed = true;
1234 				BaseEscrowLib.ContractLogEvent(BaseEscrowLib.GetCurrentStage(self), BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled early move-out");
1235 			}
1236 			else{
1237 				//If tenant initiates it, landlord can claim sec deposit, and tenant pays cancellation fee
1238 				int nContractBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1239 				cancelFee = (nContractBillableDays - nPotentialBillableDays) * self._RentPerDay / 2;
1240 
1241 				require(int(SecDeposit) <= self._SecDeposit && nActualBalance >= (nPotentialBillableDays * self._RentPerDay + int(SecDeposit) + cancelFee));
1242 				
1243 				if (SecDeposit == 0)
1244 				{
1245 					state = BaseEscrowLib.GetContractStateEarlyTerminatedByTenant();
1246 				}
1247 				else
1248 				{
1249 					BaseEscrowLib.ContractLogEvent(BaseEscrowLib.GetCurrentStage(self), BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled Security Deposit");
1250 					state = BaseEscrowLib.GetContractStateEarlyTerminatedByTenantSecDep();
1251 				}
1252 
1253 				landlBal = nPotentialBillableDays * self._RentPerDay + int(SecDeposit) + cancelFee;
1254 				tenantBal = nActualBalance - landlBal;
1255 				bProcessed = true;
1256 			}
1257 		}
1258 		else if (BaseEscrowLib.GetCurrentStage(self) == BaseEscrowLib.GetContractStageTermination())
1259 		{
1260 			nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1261 			require(int(SecDeposit) <= self._SecDeposit && nActualBalance >= nPotentialBillableDays * self._RentPerDay + int(SecDeposit));
1262 			if (SecDeposit == 0)
1263 			{
1264 				state = BaseEscrowLib.GetContractStateTerminatedOK();
1265 			}
1266 			else
1267 			{
1268 				BaseEscrowLib.ContractLogEvent(BaseEscrowLib.GetCurrentStage(self), BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled Security Deposit");
1269 				state = BaseEscrowLib.GetContractStateTerminatedSecDep();
1270 			}
1271 			landlBal = nPotentialBillableDays * self._RentPerDay + int(SecDeposit);
1272 			tenantBal = nActualBalance - landlBal;
1273 			bProcessed = true;
1274 		}
1275 
1276 		require(bProcessed);
1277 		if (state > 0)
1278 		{
1279 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
1280 		}	
1281 	}
1282 }
1283 
1284 library StrictEscrowLib
1285 {
1286 	using BaseEscrowLib for BaseEscrowLib.EscrowContractState;
1287 
1288     //Cancel days
1289 	int internal constant FreeCancelBeforeMoveInDays = 60;
1290 
1291 	//Expiration
1292 	int internal constant ExpireAfterMoveOutDays = 14;
1293 		    
1294     
1295 	function TenantTerminate(BaseEscrowLib.EscrowContractState storage self) public
1296     {
1297 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1298 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1299 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1300 		int tenantBal = 0;
1301 		int landlBal = 0;
1302 		int state = 0; 
1303 		bool bProcessed = false;
1304         string memory sGuid;
1305         sGuid = self._Guid;
1306 
1307 
1308 		if (nActualBalance == 0)
1309 		{
1310 			//If contract is unfunded, just cancel it
1311 			state = BaseEscrowLib.GetContractStateCancelledByTenant();
1312 			bProcessed = true;			
1313 		}
1314 		else if (nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn())
1315 		{			
1316 			int nDaysBeforeMoveIn = (int)(self._MoveInDate - nCurrentDate) / (60 * 60 * 24);
1317 			if (nDaysBeforeMoveIn < FreeCancelBeforeMoveInDays)
1318 			{
1319 				//Pay cancel fee
1320 				int cancelFee = self._TotalAmount - self._SecDeposit;
1321 
1322 				//Contract must be fully funded
1323 				require(cancelFee <= nActualBalance);
1324 
1325 				//Cancel fee is the whole rent
1326 				tenantBal = nActualBalance - cancelFee;
1327 				landlBal = cancelFee;
1328 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
1329 				bProcessed = true;
1330 
1331 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow. Cancellation fee will be withheld from tenant.");										
1332 			}
1333 			else
1334 			{
1335 				//No cancel fee
1336 				tenantBal = nActualBalance;
1337 				landlBal = 0;
1338 				state = BaseEscrowLib.GetContractStateCancelledByTenant();
1339 				bProcessed = true;
1340 
1341 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant cancelled escrow.");
1342 			}					
1343 		}
1344 		else if (nCurrentStage == BaseEscrowLib.GetContractStageTermination())
1345 		{
1346 			//If landlord did not close the escrow, and if it is expired, tenant may only pay for rent without sec deposit
1347 			int nDaysAfterMoveOut = (int)(nCurrentDate - self._MoveOutDate) / (60 * 60 * 24);
1348 
1349 			if (nDaysAfterMoveOut > ExpireAfterMoveOutDays)
1350 			{
1351 				int nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1352 				require(self._RentPerDay * nPotentialBillableDays <= nActualBalance);
1353 
1354 				landlBal = self._RentPerDay * nPotentialBillableDays;
1355 				tenantBal = nActualBalance - landlBal;
1356 				bProcessed = true;
1357 				state = BaseEscrowLib.GetContractStateTerminatedOK();
1358 
1359 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant closed escrow because it was expired");
1360 			}
1361 		}
1362 
1363 		require(bProcessed);
1364 		if (state > 0)
1365 		{
1366 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
1367 		}
1368     }
1369     
1370     function TenantMoveIn(BaseEscrowLib.EscrowContractState storage self) public
1371     {
1372 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1373 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1374 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1375         string memory sGuid;
1376         sGuid = self._Guid;
1377 
1378 				
1379 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= self._TotalAmount && 
1380 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) >= 0);
1381 
1382         BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Tenant signaled move-in");
1383 
1384 		self._TenantConfirmedMoveIn = true;
1385     } 
1386 	       
1387     function TenantTerminateMisrep(BaseEscrowLib.EscrowContractState storage self) public
1388     {
1389 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1390 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1391 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1392 		int tenantBal = 0;
1393 		int landlBal = 0;
1394 		int cancelFee = self._TotalAmount - self._SecDeposit;
1395         string memory sGuid;
1396         sGuid = self._Guid;
1397 
1398 		require(nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn() && nActualBalance >= cancelFee && 
1399 				DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) == 0);
1400 		
1401 		//For strict escrow, give everything to landl
1402 		landlBal = cancelFee;			
1403 		tenantBal = nActualBalance - landlBal;
1404 		
1405 		BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Tenant signaled misrepresentation and terminated escrow!");
1406 		self._MisrepSignaled = true;
1407 
1408 		BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,BaseEscrowLib.GetContractStateTerminatedMisrep());    
1409 	}    
1410 	
1411 	function LandlordTerminate(BaseEscrowLib.EscrowContractState storage self, uint SecDeposit) public
1412 	{
1413 		int nCurrentStage = BaseEscrowLib.GetCurrentStage(self);
1414 		uint nCurrentDate = BaseEscrowLib.GetCurrentDate(self);
1415 		int nActualBalance = int(BaseEscrowLib.GetContractBalance(self));
1416 		int tenantBal = 0;
1417 		int landlBal = 0;
1418 		int state = 0; 
1419 		bool bProcessed = false;
1420 		int nPotentialBillableDays = 0;
1421 		int cancelFee = self._TotalAmount - self._SecDeposit;
1422         string memory sGuid;
1423         sGuid = self._Guid;
1424 
1425 		if (nActualBalance == 0)
1426 		{
1427 			//If contract is unfunded, just cancel it
1428 			state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1429 			bProcessed = true;			
1430 		}
1431 		else if (nCurrentStage == BaseEscrowLib.GetContractStagePreMoveIn())
1432 		{	
1433 			if (DateTime.compareDateTimesForContract(nCurrentDate, self._MoveInDate) > 0 && 
1434 				!self._TenantConfirmedMoveIn)
1435 			{
1436 				//Landlord gets cancell fee if tenant did not signal anything after move in date
1437 				tenantBal = nActualBalance - cancelFee;	
1438 				landlBal = cancelFee;
1439 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1440 				bProcessed = true;
1441 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageWarning(), nCurrentDate, sGuid, "Landlord cancelled escrow. Tenant did not show up and will pay cancellation fee.");								
1442 			}
1443 			else
1444 			{		        				
1445 				//No cancel fee
1446 				tenantBal = nActualBalance;
1447 				landlBal = 0;
1448 				state = BaseEscrowLib.GetContractStateCancelledByLandlord();
1449 				bProcessed = true;
1450 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord cancelled esqrow");								
1451 			}
1452 		}
1453 		else if (nCurrentStage == BaseEscrowLib.GetContractStageLiving())
1454 		{
1455 			nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1456 			
1457 
1458 			//If landlord initiates it, he cannot claim sec deposit
1459 			require(nActualBalance >= nPotentialBillableDays * self._RentPerDay);
1460 			state = BaseEscrowLib.GetContractStateEarlyTerminatedByLandlord();
1461 			landlBal = nPotentialBillableDays * self._RentPerDay;
1462 			tenantBal = nActualBalance - landlBal;
1463 			bProcessed = true;
1464 			BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled early move-out");			
1465 		}
1466 		else if (nCurrentStage == BaseEscrowLib.GetContractStageTermination())
1467 		{
1468 			nPotentialBillableDays = (int)(self._MoveOutDate - self._MoveInDate) / (60 * 60 * 24);
1469 			require(int(SecDeposit) <= self._SecDeposit && nActualBalance >= nPotentialBillableDays * self._RentPerDay + int(SecDeposit));
1470 			if (SecDeposit == 0)
1471 			{
1472 				state = BaseEscrowLib.GetContractStateTerminatedOK();
1473 			}
1474 			else
1475 			{
1476 				BaseEscrowLib.ContractLogEvent(nCurrentStage, BaseEscrowLib.GetLogMessageInfo(), nCurrentDate, sGuid, "Landlord signaled Security Deposit");
1477 				state = BaseEscrowLib.GetContractStateTerminatedSecDep();
1478 			}
1479 			landlBal = nPotentialBillableDays * self._RentPerDay + int(SecDeposit);
1480 			tenantBal = nActualBalance - landlBal;
1481 			bProcessed = true;
1482 		}
1483 
1484 		require(bProcessed);
1485 		if (state > 0)
1486 		{
1487 			BaseEscrowLib.TerminateContract(self,tenantBal,landlBal,state);
1488 		}	
1489 	}
1490 }
1491 
1492 /**
1493  * @title Ownable
1494  * @dev The Ownable contract has an owner address, and provides basic authorization control
1495  * functions, this simplifies the implementation of "user permissions".
1496  */
1497 contract Ownable {
1498   address private owner_;
1499 
1500   
1501   event OwnershipTransferred(
1502     address indexed previousOwner,
1503     address indexed newOwner
1504   );
1505 
1506 
1507   /**
1508    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1509    * account.
1510    */
1511   function Ownable() public {
1512     owner_ = msg.sender;
1513   }
1514 
1515   /**
1516    * @return the address of the owner.
1517    */
1518   function owner() public constant returns(address) {
1519     return owner_;
1520   }
1521 
1522   /**
1523    * @dev Throws if called by any account other than the owner.
1524    */
1525   modifier onlyOwner() {
1526     require(msg.sender == owner_);
1527     _;
1528   }
1529 
1530 
1531   /**
1532    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1533    * @param _newOwner The address to transfer ownership to.
1534    */
1535   function transferOwnership(address _newOwner) public onlyOwner {
1536     _transferOwnership(_newOwner);
1537   }
1538 
1539   /**
1540    * @dev Transfers control of the contract to a newOwner.
1541    * @param _newOwner The address to transfer ownership to.
1542    */
1543   function _transferOwnership(address _newOwner) internal {
1544     require(_newOwner != address(0));
1545     OwnershipTransferred(owner_, _newOwner);
1546     owner_ = _newOwner;
1547   }
1548 }
1549 
1550 contract StayBitContractFactory is Ownable
1551 {
1552     struct EscrowTokenInfo { 
1553 		uint _RentMin;  //Min value for rent per day
1554 		uint _RentMax;  //Max value for rent per day
1555 		address _ContractAddress; //Token address
1556 		uint _ContractFeeBal;  //Earned balance
1557     }
1558 
1559 	using BaseEscrowLib for BaseEscrowLib.EscrowContractState;
1560     mapping(bytes32 => BaseEscrowLib.EscrowContractState) private contracts;
1561 	mapping(uint => EscrowTokenInfo) private supportedTokens;
1562 	bool private CreateEnabled; // Enables / disables creation of new contracts
1563 	bool private PercentageFee;  // true - percentage fee per contract false - fixed fee per contract
1564 	uint ContractFee;  //Either fixed amount or percentage
1565 		
1566 	event contractCreated(int rentPerDay, int cancelPolicy, uint moveInDate, uint moveOutDate, int secDeposit, address landlord, uint tokenId, int Id, string Guid, uint extraAmount);
1567 	event contractTerminated(int Id, string Guid, int State);
1568 
1569 	function StayBitContractFactory()
1570 	{
1571 		CreateEnabled = true;
1572 		PercentageFee = false;
1573 		ContractFee = 0;
1574 	}
1575 
1576 	function SetFactoryParams(bool enable, bool percFee, uint contrFee) public onlyOwner
1577 	{
1578 		CreateEnabled = enable;	
1579 		PercentageFee = percFee;
1580 		ContractFee = contrFee;
1581 	}
1582 
1583 	function GetFeeBalance(uint tokenId) public constant returns (uint)
1584 	{
1585 		return supportedTokens[tokenId]._ContractFeeBal;
1586 	}
1587 
1588 	function WithdrawFeeBalance(uint tokenId, address to, uint amount) public onlyOwner
1589 	{	    
1590 		require(supportedTokens[tokenId]._RentMax > 0);		
1591 		require(supportedTokens[tokenId]._ContractFeeBal >= amount);		
1592 		supportedTokens[tokenId]._ContractFeeBal -= amount;		
1593 		ERC20Interface tokenApi = ERC20Interface(supportedTokens[tokenId]._ContractAddress);
1594 		tokenApi.transfer(to, amount);
1595 	}
1596 
1597 
1598 	function SetTokenInfo(uint tokenId, address tokenAddress, uint rentMin, uint rentMax) public onlyOwner
1599 	{
1600 		supportedTokens[tokenId]._RentMin = rentMin;
1601 		supportedTokens[tokenId]._RentMax = rentMax;
1602 		supportedTokens[tokenId]._ContractAddress = tokenAddress;
1603 	}
1604 
1605 	function CalculateCreateFee(uint amount) public constant returns (uint)
1606 	{
1607 		uint result = 0;
1608 		if (PercentageFee)
1609 		{
1610 			result = amount * ContractFee / 100;
1611 		}
1612 		else
1613 		{
1614 			result = ContractFee;
1615 		}
1616 		return result;
1617 	}
1618 
1619 
1620     //75, 1, 1533417601, 1534281601, 100, "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "", "0x4514d8d91a10bda73c10e2b8ffd99cb9646620a9", 1, "test"
1621 	function CreateContract(int rentPerDay, int cancelPolicy, uint moveInDate, uint moveOutDate, int secDeposit, address landlord, string doorLockData, uint tokenId, int Id, string Guid, uint extraAmount) public
1622 	{
1623 		//It must be enabled
1624 		require (CreateEnabled && rentPerDay > 0 && secDeposit > 0 && moveInDate > 0 && moveOutDate > 0 && landlord != address(0) && landlord != msg.sender && Id > 0);
1625 
1626 		//Token must be supported
1627 		require(supportedTokens[tokenId]._RentMax > 0);
1628 
1629 		//Rent per day values must be within range for this token
1630 		require(supportedTokens[tokenId]._RentMin <= uint(rentPerDay) && supportedTokens[tokenId]._RentMax >= uint(rentPerDay));
1631 
1632 		//Check that we support cancel policy
1633 		//TESTNET
1634 		//require (cancelPolicy == 1 || cancelPolicy == 2 || cancelPolicy == 3);
1635 
1636 		//PRODUCTION
1637 		require (cancelPolicy == 1 || cancelPolicy == 2);
1638 
1639 		//Check that GUID does not exist		
1640 		require (contracts[keccak256(Guid)]._Id == 0);
1641 
1642 		contracts[keccak256(Guid)]._CurrentDate = now;
1643 		contracts[keccak256(Guid)]._CreatedDate = now;
1644 		contracts[keccak256(Guid)]._RentPerDay = rentPerDay;
1645 		contracts[keccak256(Guid)]._MoveInDate = moveInDate;
1646 		contracts[keccak256(Guid)]._MoveOutDate = moveOutDate;
1647 		contracts[keccak256(Guid)]._SecDeposit = secDeposit;
1648 		contracts[keccak256(Guid)]._DoorLockData = doorLockData;
1649 		contracts[keccak256(Guid)]._landlord = landlord;
1650 		contracts[keccak256(Guid)]._tenant = msg.sender;
1651 		contracts[keccak256(Guid)]._ContractAddress = this;		
1652 		contracts[keccak256(Guid)]._tokenApi = ERC20Interface(supportedTokens[tokenId]._ContractAddress);
1653 		contracts[keccak256(Guid)]._Id = Id;
1654 		contracts[keccak256(Guid)]._Guid = Guid;
1655 		contracts[keccak256(Guid)]._CancelPolicy = cancelPolicy;
1656 
1657 		contracts[keccak256(Guid)].initialize();
1658 
1659 		uint256 startBalance = contracts[keccak256(Guid)]._tokenApi.balanceOf(this);
1660 
1661 		//Calculate our fees
1662 		supportedTokens[tokenId]._ContractFeeBal += CalculateCreateFee(uint(contracts[keccak256(Guid)]._TotalAmount));
1663 
1664 		//Check that tenant has funds
1665 		require(extraAmount + uint(contracts[keccak256(Guid)]._TotalAmount) + CalculateCreateFee(uint(contracts[keccak256(Guid)]._TotalAmount)) <= contracts[keccak256(Guid)]._tokenApi.balanceOf(msg.sender));
1666 
1667 		//Fund. Token fee, if any, will be witheld here 
1668 		contracts[keccak256(Guid)]._tokenApi.transferFrom(msg.sender, this, extraAmount + uint(contracts[keccak256(Guid)]._TotalAmount) + CalculateCreateFee(uint(contracts[keccak256(Guid)]._TotalAmount)));
1669 
1670 		//We need to measure balance diff because some tokens (TrueUSD) charge fees per transfer
1671 		contracts[keccak256(Guid)]._Balance = contracts[keccak256(Guid)]._tokenApi.balanceOf(this) - startBalance - CalculateCreateFee(uint(contracts[keccak256(Guid)]._TotalAmount));
1672 
1673 		//Check that balance is still greater than contract's amount
1674 		require(contracts[keccak256(Guid)]._Balance >= uint(contracts[keccak256(Guid)]._TotalAmount));
1675 
1676 		//raise event
1677 		contractCreated(rentPerDay, cancelPolicy, moveInDate, moveOutDate, secDeposit, landlord, tokenId, Id, Guid, extraAmount);
1678 	}
1679 
1680 	function() payable
1681 	{	
1682 		revert();
1683 	}
1684 
1685 	function SimulateCurrentDate(uint n, string Guid) public {
1686 	    if (contracts[keccak256(Guid)]._Id != 0)
1687 		{
1688 			contracts[keccak256(Guid)].SimulateCurrentDate(n);
1689 		}
1690 	}
1691 	
1692 	
1693 	function GetContractInfo(string Guid) public constant returns (uint curDate, int escrState, int escrStage, bool tenantMovedIn, uint actualBalance, bool misrepSignaled, string doorLockData, int calcAmount, uint actualMoveOutDate, int cancelPolicy)
1694 	{
1695 		if (contracts[keccak256(Guid)]._Id != 0)
1696 		{
1697 			actualBalance = contracts[keccak256(Guid)].GetContractBalance();
1698 			curDate = contracts[keccak256(Guid)].GetCurrentDate();
1699 			tenantMovedIn = contracts[keccak256(Guid)]._TenantConfirmedMoveIn;
1700 			misrepSignaled = contracts[keccak256(Guid)]._MisrepSignaled;
1701 			doorLockData = contracts[keccak256(Guid)]._DoorLockData;
1702 			escrStage = contracts[keccak256(Guid)].GetCurrentStage();
1703 			escrState = contracts[keccak256(Guid)]._State;
1704 			calcAmount = contracts[keccak256(Guid)]._TotalAmount;
1705 			actualMoveOutDate = contracts[keccak256(Guid)]._ActualMoveOutDate;
1706 			cancelPolicy = contracts[keccak256(Guid)]._CancelPolicy;
1707 		}
1708 	}
1709 		
1710 	function TenantTerminate(string Guid) public
1711 	{
1712 		if (contracts[keccak256(Guid)]._Id != 0)
1713 		{
1714 			require(contracts[keccak256(Guid)]._State == BaseEscrowLib.GetContractStateActive() && msg.sender == contracts[keccak256(Guid)]._tenant);
1715 
1716 			if (contracts[keccak256(Guid)]._CancelPolicy == 1)
1717 			{
1718 				FlexibleEscrowLib.TenantTerminate(contracts[keccak256(Guid)]);
1719 			}
1720 			else if (contracts[keccak256(Guid)]._CancelPolicy == 2)
1721 			{
1722 				ModerateEscrowLib.TenantTerminate(contracts[keccak256(Guid)]);
1723 			}
1724 			else if (contracts[keccak256(Guid)]._CancelPolicy == 3)
1725 			{
1726 				StrictEscrowLib.TenantTerminate(contracts[keccak256(Guid)]);
1727 			}
1728 			else{
1729 				revert();
1730 				return;
1731 			}
1732 
1733 			SendTokens(Guid);
1734 
1735 			//Raise event
1736 			contractTerminated(contracts[keccak256(Guid)]._Id, Guid, contracts[keccak256(Guid)]._State);
1737 
1738 		}
1739 	}
1740 
1741 	function TenantTerminateMisrep(string Guid) public
1742 	{	
1743 		if (contracts[keccak256(Guid)]._Id != 0)
1744 		{
1745 			require(contracts[keccak256(Guid)]._State == BaseEscrowLib.GetContractStateActive() && msg.sender == contracts[keccak256(Guid)]._tenant);
1746 
1747 			if (contracts[keccak256(Guid)]._CancelPolicy == 1)
1748 			{
1749 				FlexibleEscrowLib.TenantTerminateMisrep(contracts[keccak256(Guid)]);
1750 			}
1751 			else if (contracts[keccak256(Guid)]._CancelPolicy == 2)
1752 			{
1753 				ModerateEscrowLib.TenantTerminateMisrep(contracts[keccak256(Guid)]);
1754 			}
1755 			else if (contracts[keccak256(Guid)]._CancelPolicy == 3)
1756 			{
1757 				StrictEscrowLib.TenantTerminateMisrep(contracts[keccak256(Guid)]);
1758 			}
1759 			else{
1760 				revert();
1761 				return;
1762 			}
1763 
1764 			SendTokens(Guid);
1765 
1766 			//Raise event
1767 			contractTerminated(contracts[keccak256(Guid)]._Id, Guid, contracts[keccak256(Guid)]._State);
1768 		}
1769 	}
1770     
1771 	function TenantMoveIn(string Guid) public
1772 	{	
1773 		if (contracts[keccak256(Guid)]._Id != 0)
1774 		{
1775 			require(contracts[keccak256(Guid)]._State == BaseEscrowLib.GetContractStateActive() && msg.sender == contracts[keccak256(Guid)]._tenant);
1776 
1777 			if (contracts[keccak256(Guid)]._CancelPolicy == 1)
1778 			{
1779 				FlexibleEscrowLib.TenantMoveIn(contracts[keccak256(Guid)]);
1780 			}
1781 			else if (contracts[keccak256(Guid)]._CancelPolicy == 2)
1782 			{
1783 				ModerateEscrowLib.TenantMoveIn(contracts[keccak256(Guid)]);
1784 			}
1785 			else if (contracts[keccak256(Guid)]._CancelPolicy == 3)
1786 			{
1787 				StrictEscrowLib.TenantMoveIn(contracts[keccak256(Guid)]);
1788 			}
1789 			else{
1790 				revert();
1791 			}
1792 		}
1793 	}
1794 
1795 	function LandlordTerminate(uint SecDeposit, string Guid) public
1796 	{		
1797 		if (contracts[keccak256(Guid)]._Id != 0)
1798 		{
1799 			require(SecDeposit >= 0 && SecDeposit <= uint256(contracts[keccak256(Guid)]._SecDeposit));
1800 			require(contracts[keccak256(Guid)]._State == BaseEscrowLib.GetContractStateActive() && msg.sender == contracts[keccak256(Guid)]._landlord);
1801 
1802 			if (contracts[keccak256(Guid)]._CancelPolicy == 1)
1803 			{
1804 				FlexibleEscrowLib.LandlordTerminate(contracts[keccak256(Guid)], SecDeposit);
1805 			}
1806 			else if (contracts[keccak256(Guid)]._CancelPolicy == 2)
1807 			{
1808 				ModerateEscrowLib.LandlordTerminate(contracts[keccak256(Guid)], SecDeposit);
1809 			}
1810 			else if (contracts[keccak256(Guid)]._CancelPolicy == 3)
1811 			{
1812 				StrictEscrowLib.LandlordTerminate(contracts[keccak256(Guid)], SecDeposit);
1813 			}
1814 			else{
1815 				revert();
1816 				return;
1817 			}
1818 
1819 			SendTokens(Guid);
1820 
1821 			//Raise event
1822 			contractTerminated(contracts[keccak256(Guid)]._Id, Guid, contracts[keccak256(Guid)]._State);
1823 		}
1824 	}
1825 
1826 	function SendTokens(string Guid) private
1827 	{		
1828 		if (contracts[keccak256(Guid)]._Id != 0)
1829 		{
1830 			if (contracts[keccak256(Guid)]._landlBal > 0)
1831 			{	
1832 				uint landlBal = uint(contracts[keccak256(Guid)]._landlBal);
1833 				contracts[keccak256(Guid)]._landlBal = 0;		
1834 				contracts[keccak256(Guid)]._tokenApi.transfer(contracts[keccak256(Guid)]._landlord, landlBal);
1835 				contracts[keccak256(Guid)]._Balance -= landlBal;						
1836 			}
1837 	    
1838 			if (contracts[keccak256(Guid)]._tenantBal > 0)
1839 			{			
1840 				uint tenantBal = uint(contracts[keccak256(Guid)]._tenantBal);
1841 				contracts[keccak256(Guid)]._tenantBal = 0;
1842 				contracts[keccak256(Guid)]._tokenApi.transfer(contracts[keccak256(Guid)]._tenant, tenantBal);			
1843 				contracts[keccak256(Guid)]._Balance -= tenantBal;
1844 			}
1845 		}			    
1846 	}
1847 }