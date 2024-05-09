1 pragma solidity ^0.4.18;
2 
3 contract DateTime {
4         /*
5          *  Date and Time utilities for ethereum contracts
6          *
7          */
8         struct _DateTime {
9                 uint16 year;
10                 uint8 month;
11                 uint8 day;
12                 uint8 hour;
13                 uint8 minute;
14                 uint8 second;
15                 uint8 weekday;
16         }
17 
18         uint constant DAY_IN_SECONDS = 86400;
19         uint constant YEAR_IN_SECONDS = 31536000;
20         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
21 
22         uint constant HOUR_IN_SECONDS = 3600;
23         uint constant MINUTE_IN_SECONDS = 60;
24 
25         uint16 constant ORIGIN_YEAR = 1970;
26 
27         function isLeapYear(uint16 year) public pure returns (bool) {
28                 if (year % 4 != 0) {
29                         return false;
30                 }
31                 if (year % 100 != 0) {
32                         return true;
33                 }
34                 if (year % 400 != 0) {
35                         return false;
36                 }
37                 return true;
38         }
39 
40         function leapYearsBefore(uint year) public pure returns (uint) {
41                 year -= 1;
42                 return year / 4 - year / 100 + year / 400;
43         }
44 
45         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
46                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
47                         return 31;
48                 }
49                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
50                         return 30;
51                 }
52                 else if (isLeapYear(year)) {
53                         return 29;
54                 }
55                 else {
56                         return 28;
57                 }
58         }
59 
60         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
61                 uint secondsAccountedFor = 0;
62                 uint buf;
63                 uint8 i;
64 
65                 // Year
66                 dt.year = getYear(timestamp);
67                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
68 
69                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
70                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
71 
72                 // Month
73                 uint secondsInMonth;
74                 for (i = 1; i <= 12; i++) {
75                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
76                         if (secondsInMonth + secondsAccountedFor > timestamp) {
77                                 dt.month = i;
78                                 break;
79                         }
80                         secondsAccountedFor += secondsInMonth;
81                 }
82 
83                 // Day
84                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
85                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
86                                 dt.day = i;
87                                 break;
88                         }
89                         secondsAccountedFor += DAY_IN_SECONDS;
90                 }
91 
92                 // Hour
93                 dt.hour = getHour(timestamp);
94 
95                 // Minute
96                 dt.minute = getMinute(timestamp);
97 
98                 // Second
99                 dt.second = getSecond(timestamp);
100 
101                 // Day of week.
102                 dt.weekday = getWeekday(timestamp);
103         }
104 
105         function getYear(uint timestamp) public pure returns (uint16) {
106                 uint secondsAccountedFor = 0;
107                 uint16 year;
108                 uint numLeapYears;
109 
110                 // Year
111                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
112                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
113 
114                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
115                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
116 
117                 while (secondsAccountedFor > timestamp) {
118                         if (isLeapYear(uint16(year - 1))) {
119                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
120                         }
121                         else {
122                                 secondsAccountedFor -= YEAR_IN_SECONDS;
123                         }
124                         year -= 1;
125                 }
126                 return year;
127         }
128 
129         function getMonth(uint timestamp) public pure returns (uint8) {
130                 return parseTimestamp(timestamp).month;
131         }
132 
133         function getDay(uint timestamp) public pure returns (uint8) {
134                 return parseTimestamp(timestamp).day;
135         }
136 
137         function getHour(uint timestamp) public pure returns (uint8) {
138                 return uint8((timestamp / 60 / 60) % 24);
139         }
140 
141         function getMinute(uint timestamp) public pure returns (uint8) {
142                 return uint8((timestamp / 60) % 60);
143         }
144 
145         function getSecond(uint timestamp) public pure returns (uint8) {
146                 return uint8(timestamp % 60);
147         }
148 
149         function getWeekday(uint timestamp) public pure returns (uint8) {
150                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
151         }
152 
153         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
154                 return toTimestamp(year, month, day, 0, 0, 0);
155         }
156 
157         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
158                 return toTimestamp(year, month, day, hour, 0, 0);
159         }
160 
161         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
162                 return toTimestamp(year, month, day, hour, minute, 0);
163         }
164 
165         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
166                 uint16 i;
167 
168                 // Year
169                 for (i = ORIGIN_YEAR; i < year; i++) {
170                         if (isLeapYear(i)) {
171                                 timestamp += LEAP_YEAR_IN_SECONDS;
172                         }
173                         else {
174                                 timestamp += YEAR_IN_SECONDS;
175                         }
176                 }
177 
178                 // Month
179                 uint8[12] memory monthDayCounts;
180                 monthDayCounts[0] = 31;
181                 if (isLeapYear(year)) {
182                         monthDayCounts[1] = 29;
183                 }
184                 else {
185                         monthDayCounts[1] = 28;
186                 }
187                 monthDayCounts[2] = 31;
188                 monthDayCounts[3] = 30;
189                 monthDayCounts[4] = 31;
190                 monthDayCounts[5] = 30;
191                 monthDayCounts[6] = 31;
192                 monthDayCounts[7] = 31;
193                 monthDayCounts[8] = 30;
194                 monthDayCounts[9] = 31;
195                 monthDayCounts[10] = 30;
196                 monthDayCounts[11] = 31;
197 
198                 for (i = 1; i < month; i++) {
199                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
200                 }
201 
202                 // Day
203                 timestamp += DAY_IN_SECONDS * (day - 1);
204 
205                 // Hour
206                 timestamp += HOUR_IN_SECONDS * (hour);
207 
208                 // Minute
209                 timestamp += MINUTE_IN_SECONDS * (minute);
210 
211                 // Second
212                 timestamp += second;
213 
214                 return timestamp;
215         }
216 }
217 
218 contract ERC20xVariables {
219     address public creator;
220     address public lib;
221 
222     uint256 constant public MAX_UINT256 = 2**256 - 1;
223     mapping(address => uint) public balances;
224     mapping(address => mapping(address => uint)) public allowed;
225 
226     uint8 public constant decimals = 18;
227     string public name;
228     string public symbol;
229     uint public totalSupply;
230 
231     event Transfer(address indexed _from, address indexed _to, uint256 _value);
232     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
233 
234     event Created(address creator, uint supply);
235 
236     function balanceOf(address _owner) public view returns (uint256 balance) {
237         return balances[_owner];
238     }
239 
240     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
241         return allowed[_owner][_spender];
242     }
243 }
244 
245 contract ERC20x is ERC20xVariables {
246 
247     function transfer(address _to, uint256 _value) public returns (bool success) {
248         _transferBalance(msg.sender, _to, _value);
249         emit Transfer(msg.sender, _to, _value);
250         return true;
251     }
252 
253     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
254         uint256 allowance = allowed[_from][msg.sender];
255         require(allowance >= _value);
256         _transferBalance(_from, _to, _value);
257         if (allowance < MAX_UINT256) {
258             allowed[_from][msg.sender] -= _value;
259         }
260         emit Transfer(_from, _to, _value);
261         return true;
262     }
263 
264     function approve(address _spender, uint256 _value) public returns (bool success) {
265         allowed[msg.sender][_spender] = _value;
266         emit Approval(msg.sender, _spender, _value);
267         return true;
268     }
269 
270     function transferToContract(address _to, uint256 _value, bytes data) public returns (bool) {
271         _transferBalance(msg.sender, _to, _value);
272         bytes4 sig = bytes4(keccak256("receiveTokens(address,uint256,bytes)"));
273         require(_to.call(sig, msg.sender, _value, data));
274         emit Transfer(msg.sender, _to, _value);
275         return true;
276     }
277 
278     function _transferBalance(address _from, address _to, uint _value) internal {
279         require(balances[_from] >= _value);
280         balances[_from] -= _value;
281         balances[_to] += _value;
282     }
283 }
284 
285 contract VariableSupplyToken is ERC20x {
286     function grant(address to, uint256 amount) public {
287         require(msg.sender == creator);
288         require(balances[to] + amount >= amount);
289         balances[to] += amount;
290         totalSupply += amount;
291     }
292 
293     function burn(address from, uint amount) public {
294         require(msg.sender == creator);
295         require(balances[from] >= amount);
296         balances[from] -= amount;
297         totalSupply -= amount;
298     }
299 }
300 
301 contract OptionToken is ERC20xVariables {
302 
303     constructor(string _name, string _symbol, address _lib) public {
304         creator = msg.sender;
305         lib = _lib;
306         name = _name;
307         symbol = _symbol;
308     }
309 
310     function() public {
311         require(
312             lib.delegatecall(msg.data)
313         );
314     }
315 }
316 
317 // we don't store much state here either
318 contract Token is VariableSupplyToken {
319     constructor() public {
320         creator = msg.sender;
321         name = "Decentralized Settlement Facility Token";
322         symbol = "DSF";
323 
324         // this needs to be here to avoid zero initialization of token rights.
325         totalSupply = 1;
326         balances[0x0] = 1;
327     }
328 }
329 
330 contract Protocol is DateTime {
331     
332     address public lib;
333     ERC20x public usdERC20;
334     Token public protocolToken;
335 
336     // We use "flavor" because type is a reserved word in many programming languages
337     enum Flavor {
338         Call,
339         Put
340     }
341 
342     struct OptionSeries {
343         uint expiration;
344         Flavor flavor;
345         uint strike;
346     }
347 
348     uint public constant DURATION = 12 hours;
349     uint public constant HALF_DURATION = DURATION / 2;
350 
351     mapping(bytes32 => address) public seriesToken;
352     mapping(address => uint) public openInterest;
353     mapping(address => uint) public earlyExercised;
354     mapping(address => uint) public totalInterest;
355     mapping(address => mapping(address => uint)) public writers;
356     mapping(address => OptionSeries) public seriesInfo;
357     mapping(address => uint) public holdersSettlement;
358 
359     bytes4 public constant GRANT = bytes4(keccak256("grant(address,uint256)"));
360     bytes4 public constant BURN = bytes4(keccak256("burn(address,uint256)"));
361 
362     bytes4 public constant RECEIVE_ETH = bytes4(keccak256("receiveETH(address,uint256)"));
363     bytes4 public constant RECEIVE_USD = bytes4(keccak256("receiveUSD(address,uint256)"));
364 
365     uint public deployed;
366 
367     mapping(address => uint) public expectValue;
368     bool isAuction;
369 
370     uint public constant ONE_MILLION = 1000000;
371 
372     // maximum token holder rights capped at 3.7% of total supply?
373     // Why 3.7%?
374     // I could make up some fancy explanation
375     // and use the phrase "byzantine fault tolerance" somehow
376     // Or I could just say that 3.7% allows for a total of 27 independent actors
377     // that are all receiving the maximum benefit, and it solves all the other
378     // issues of disincentivizing centralization and "rich get richer" mechanics, so I chose 27 'cause it just has a nice "decentralized" feel to it.
379     // 21 would have been fine, as few as ten probably would have been ok 'cause people can just pool anyways
380     // up to a thousand or so probably wouldn't have hurt either.
381     // In the end it really doesn't matter as long as the game ends up being played fairly.
382 
383     // I'm sure someone will take my system and parameterize it differently at some point and bill it as a totally new product.
384     uint public constant PREFERENCE_MAX = 0.037 ether;
385 
386     constructor(address _usd) public {
387         lib = new VariableSupplyToken();
388         protocolToken = new Token();
389         usdERC20 = ERC20x(_usd);
390         deployed = now;
391     }
392 
393     function() public payable {
394         revert();
395     }
396 
397     event SeriesIssued(address series);
398 
399     function issue(uint expiration, Flavor flavor, uint strike) public returns (address) {
400         require(strike >= 20 ether);
401         require(strike % 20 ether == 0);
402         require(strike <= 10000 ether);
403 
404         // require expiration to be at noon UTC
405         require(expiration % 86400 == 43200);
406 
407         // valid expirations: 7n + 1 where n = (unix timestamp / 86400)
408         require(((expiration / 86400) + 2) % 7 == 0);
409         require(expiration > now + 12 hours);
410         require(expiration < now + 365 days);
411 
412         // compute the symbol based on datetime library
413         _DateTime memory exp = parseTimestamp(expiration);
414 
415         uint strikeCode = strike / 1 ether;
416 
417         string memory name = _name(exp, flavor, strikeCode);
418 
419         string memory symbol = _symbol(exp, flavor, strikeCode);
420 
421         bytes32 id = _seriesHash(expiration, flavor, strike);
422         require(seriesToken[id] == address(0));
423         address series = new OptionToken(name, symbol, lib);
424         seriesToken[id] = series;
425         seriesInfo[series] = OptionSeries(expiration, flavor, strike);
426         emit SeriesIssued(series);
427         return series;
428     }
429 
430     function _name(_DateTime exp, Flavor flavor, uint strikeCode) private pure returns (string) {
431         return string(
432             abi.encodePacked(
433                 _monthName(exp.month),
434                 " ",
435                 uint2str(exp.day),
436                 " ",
437                 uint2str(strikeCode),
438                 "-",
439                 flavor == Flavor.Put ? "PUT" : "CALL"
440             )
441         );
442     }
443 
444     function _symbol(_DateTime exp, Flavor flavor, uint strikeCode) private pure returns (string) {
445         uint monthChar = 64 + exp.month;
446         if (flavor == Flavor.Put) {
447             monthChar += 12;
448         }
449 
450         uint dayChar = 65 + (exp.day - 1) / 7;
451 
452         return string(
453             abi.encodePacked(
454                 "∆",
455                 byte(monthChar),
456                 byte(dayChar),
457                 uint2str(strikeCode)
458             )
459         );
460     }
461 
462     function open(address _series, uint amount) public payable returns (bool) {
463         OptionSeries memory series = seriesInfo[_series];
464 
465         bytes32 id = _seriesHash(series.expiration, series.flavor, series.strike);
466         require(seriesToken[id] == _series);
467         require(_series.call(GRANT, msg.sender, amount));
468 
469         require(now < series.expiration);
470 
471         if (series.flavor == Flavor.Call) {
472             require(msg.value == amount);
473         } else {
474             require(msg.value == 0);
475             uint escrow = amount * series.strike;
476             require(escrow / amount == series.strike);
477             escrow /= 1 ether;
478             require(usdERC20.transferFrom(msg.sender, this, escrow));
479         }
480         
481         openInterest[_series] += amount;
482         totalInterest[_series] += amount;
483         writers[_series][msg.sender] += amount;
484 
485         return true;
486     }
487 
488     function close(address _series, uint amount) public {
489         OptionSeries memory series = seriesInfo[_series];
490 
491         require(now < series.expiration);
492         require(openInterest[_series] >= amount);
493         require(_series.call(BURN, msg.sender, amount));
494 
495         require(writers[_series][msg.sender] >= amount);
496         writers[_series][msg.sender] -= amount;
497         openInterest[_series] -= amount;
498         totalInterest[_series] -= amount;
499         
500         if (series.flavor == Flavor.Call) {
501             msg.sender.transfer(amount);
502         } else {
503             require(
504                 usdERC20.transfer(msg.sender, amount * series.strike / 1 ether));
505         }
506     }
507     
508     function exercise(address _series, uint amount) public payable {
509         OptionSeries memory series = seriesInfo[_series];
510 
511         require(now < series.expiration);
512         require(openInterest[_series] >= amount);
513         require(_series.call(BURN, msg.sender, amount));
514 
515         uint usd = amount * series.strike;
516         require(usd / amount == series.strike);
517         usd /= 1 ether;
518 
519         openInterest[_series] -= amount;
520         earlyExercised[_series] += amount;
521 
522         if (series.flavor == Flavor.Call) {
523             msg.sender.transfer(amount);
524             require(msg.value == 0);
525             require(usdERC20.transferFrom(msg.sender, this, usd));
526         } else {
527             require(msg.value == amount);
528             require(usdERC20.transfer(msg.sender, usd));
529         }
530     }
531     
532     function receive() public payable {
533         require(expectValue[msg.sender] == msg.value);
534         expectValue[msg.sender] = 0;
535     }
536 
537     function bid(address _series, uint amount) public payable {
538 
539         require(isAuction == false);
540         isAuction = true;
541 
542         OptionSeries memory series = seriesInfo[_series];
543 
544         uint start = series.expiration;
545         uint time = now + _timePreference(msg.sender);
546 
547         require(time > start);
548         require(time < start + DURATION);
549 
550         uint elapsed = time - start;
551 
552         amount = _min(amount, openInterest[_series]);
553 
554         if ((now - deployed) / 1 weeks < 8) {
555             _grantReward(msg.sender, amount);
556         }
557 
558         openInterest[_series] -= amount;
559 
560         uint offer;
561         uint givGet;
562         bool result;
563 
564         if (series.flavor == Flavor.Call) {
565             require(msg.value == 0);
566 
567             offer = (series.strike * DURATION) / elapsed;
568             givGet = offer * amount / 1 ether;
569             holdersSettlement[_series] += givGet - amount * series.strike / 1 ether;
570 
571             bool hasFunds = usdERC20.balanceOf(msg.sender) >= givGet && usdERC20.allowance(msg.sender, this) >= givGet;
572 
573             if (hasFunds) {
574                 msg.sender.transfer(amount);
575             } else {
576                 result = msg.sender.call.value(amount)(RECEIVE_ETH, _series, amount);
577                 require(result);
578             }
579 
580             require(usdERC20.transferFrom(msg.sender, this, givGet));
581         } else {
582             offer = (DURATION * 1 ether * 1 ether) / (series.strike * elapsed);
583             givGet = (amount * 1 ether) / offer;
584 
585             holdersSettlement[_series] += amount * series.strike / 1 ether - givGet;
586             require(usdERC20.transfer(msg.sender, givGet));
587 
588             if (msg.value == 0) {
589                 require(expectValue[msg.sender] == 0);
590                 expectValue[msg.sender] = amount;
591 
592                 result = msg.sender.call(RECEIVE_USD, _series, givGet);
593                 require(result);
594                 require(expectValue[msg.sender] == 0);
595             } else {
596                 require(msg.value >= amount);
597                 msg.sender.transfer(msg.value - amount);
598             }
599         }
600 
601         isAuction = false;
602     }
603 
604     function redeem(address _series) public {
605         OptionSeries memory series = seriesInfo[_series];
606 
607         require(now > series.expiration + DURATION);
608 
609         uint unsettledPercent = openInterest[_series] * 1 ether / totalInterest[_series];
610         uint exercisedPercent = (totalInterest[_series] - openInterest[_series]) * 1 ether / totalInterest[_series];
611         uint owed;
612 
613         if (series.flavor == Flavor.Call) {
614             owed = writers[_series][msg.sender] * unsettledPercent / 1 ether;
615             if (owed > 0) {
616                 msg.sender.transfer(owed);
617             }
618 
619             owed = writers[_series][msg.sender] * exercisedPercent / 1 ether;
620             owed = owed * series.strike / 1 ether;
621             if (owed > 0) {
622                 require(usdERC20.transfer(msg.sender, owed));
623             }
624         } else {
625             owed = writers[_series][msg.sender] * unsettledPercent / 1 ether;
626             owed = owed * series.strike / 1 ether;
627             if (owed > 0) {
628                 require(usdERC20.transfer(msg.sender, owed));
629             }
630 
631             owed = writers[_series][msg.sender] * exercisedPercent / 1 ether;
632             if (owed > 0) {
633                 msg.sender.transfer(owed);
634             }
635         }
636 
637         writers[_series][msg.sender] = 0;
638     }
639 
640     function settle(address _series) public {
641         OptionSeries memory series = seriesInfo[_series];
642         require(now > series.expiration + DURATION);
643 
644         uint bal = ERC20x(_series).balanceOf(msg.sender);
645         require(_series.call(BURN, msg.sender, bal));
646 
647         uint percent = bal * 1 ether / (totalInterest[_series] - earlyExercised[_series]);
648         uint owed = holdersSettlement[_series] * percent / 1 ether;
649         require(usdERC20.transfer(msg.sender, owed));
650     }
651 
652     function _timePreference(address from) public view returns (uint) {
653         return (_unsLn(_preference(from) * 1000000 + 1 ether) * 171) / 1 ether;
654     }
655 
656     function _grantReward(address to, uint amount) private {
657         uint percentOfMax = _preference(to) * 1 ether / PREFERENCE_MAX;
658         require(percentOfMax <= 1 ether);
659         uint percentGrant = 1 ether - percentOfMax;
660 
661 
662         uint elapsed = (now - deployed) / 1 weeks;
663         elapsed = _min(elapsed, 7);
664         uint div = 10**elapsed;
665         uint reward = percentGrant * (amount * (ONE_MILLION / div)) / 1 ether;
666 
667         require(address(protocolToken).call(GRANT, to, reward));
668     }
669 
670     function _preference(address from) public view returns (uint) {
671         return _min(
672             protocolToken.balanceOf(from) * 1 ether / protocolToken.totalSupply(),
673             PREFERENCE_MAX
674         );
675     }
676 
677     function _min(uint a, uint b) pure public returns (uint) {
678         if (a > b)
679             return b;
680         return a;
681     }
682 
683     function _max(uint a, uint b) pure public returns (uint) {
684         if (a > b)
685             return a;
686         return b;
687     }
688     
689     function _seriesHash(uint expiration, Flavor flavor, uint strike) public pure returns (bytes32) {
690         return keccak256(abi.encodePacked(expiration, flavor, strike));
691     }
692 
693     function _monthName(uint month) public pure returns (string) {
694         string[12] memory names = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
695         return names[month-1];
696     }
697 
698     function _unsLn(uint x) pure public returns (uint log) {
699         log = 0;
700         
701         // not a true ln function, we can't represent the negatives
702         if (x < 1 ether)
703             return 0;
704 
705         while (x >= 1.5 ether) {
706             log += 0.405465 ether;
707             x = x * 2 / 3;
708         }
709         
710         x = x - 1 ether;
711         uint y = x;
712         uint i = 1;
713 
714         while (i < 10) {
715             log += (y / i);
716             i = i + 1;
717             y = y * x / 1 ether;
718             log -= (y / i);
719             i = i + 1;
720             y = y * x / 1 ether;
721         }
722          
723         return(log);
724     }
725 
726     function uint2str(uint i) internal pure returns (string){
727         if (i == 0) return "0";
728         uint j = i;
729         uint len;
730         while (j != 0){
731             len++;
732             j /= 10;
733         }
734         bytes memory bstr = new bytes(len);
735         uint k = len - 1;
736         while (i != 0){
737             bstr[k--] = byte(48 + i % 10);
738             i /= 10;
739         }
740         return string(bstr);
741     }
742 }