1 pragma solidity >=0.4.21 <0.6.0;
2 
3 
4 library SafeMath {
5     
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         
29         
30         
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45 
46     
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         
52 
53         return c;
54     }
55 
56     
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return mod(a, b, "SafeMath: modulo by zero");
59     }
60 
61     
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b != 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 contract Context {
69     
70     
71     constructor () internal { }
72     
73 
74     function _msgSender() internal view returns (address payable) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view returns (bytes memory) {
79         this; 
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     
90     constructor () internal {
91         _owner = _msgSender();
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     
101     modifier onlyOwner() {
102         require(isOwner(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     
107     function isOwner() public view returns (bool) {
108         return _msgSender() == _owner;
109     }
110 
111     
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     
123     function _transferOwnership(address newOwner) internal {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 interface IERC20 {
131     
132     function totalSupply() external view returns (uint256);
133 
134     
135     function balanceOf(address account) external view returns (uint256);
136 
137     
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 contract ERC20 is Context, IERC20 {
157     using SafeMath for uint256;
158 
159     mapping (address => uint256) private _balances;
160 
161     mapping (address => mapping (address => uint256)) private _allowances;
162 
163     uint256 private _totalSupply;
164 
165     
166     function totalSupply() public view returns (uint256) {
167         return _totalSupply;
168     }
169 
170     
171     function balanceOf(address account) public view returns (uint256) {
172         return _balances[account];
173     }
174 
175     
176     function transfer(address recipient, uint256 amount) public returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     
182     function allowance(address owner, address spender) public view returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     
187     function approve(address spender, uint256 amount) public returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     
193     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
202         return true;
203     }
204 
205     
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
208         return true;
209     }
210 
211     
212     function _transfer(address sender, address recipient, uint256 amount) internal {
213         require(sender != address(0), "ERC20: transfer from the zero address");
214         require(recipient != address(0), "ERC20: transfer to the zero address");
215 
216         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
217         _balances[recipient] = _balances[recipient].add(amount);
218         emit Transfer(sender, recipient, amount);
219     }
220 
221     
222     function _mint(address account, uint256 amount) internal {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _totalSupply = _totalSupply.add(amount);
226         _balances[account] = _balances[account].add(amount);
227         emit Transfer(address(0), account, amount);
228     }
229 
230      
231     function _burn(address account, uint256 amount) internal {
232         require(account != address(0), "ERC20: burn from the zero address");
233 
234         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
235         _totalSupply = _totalSupply.sub(amount);
236         emit Transfer(account, address(0), amount);
237     }
238 
239     
240     function _approve(address owner, address spender, uint256 amount) internal {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     
249     function _burnFrom(address account, uint256 amount) internal {
250         _burn(account, amount);
251         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
252     }
253 }
254 
255 contract ERC20Detailed is IERC20 {
256     string private _name;
257     string private _symbol;
258     uint8 private _decimals;
259 
260     
261     constructor (string memory name, string memory symbol, uint8 decimals) public {
262         _name = name;
263         _symbol = symbol;
264         _decimals = decimals;
265     }
266 
267     
268     function name() public view returns (string memory) {
269         return _name;
270     }
271 
272     
273     function symbol() public view returns (string memory) {
274         return _symbol;
275     }
276 
277     
278     function decimals() public view returns (uint8) {
279         return _decimals;
280     }
281 }
282 
283 library DateTime {
284 
285     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
286     uint constant SECONDS_PER_HOUR = 60 * 60;
287     uint constant SECONDS_PER_MINUTE = 60;
288     int constant OFFSET19700101 = 2440588;
289 
290     uint constant DOW_MON = 1;
291     uint constant DOW_TUE = 2;
292     uint constant DOW_WED = 3;
293     uint constant DOW_THU = 4;
294     uint constant DOW_FRI = 5;
295     uint constant DOW_SAT = 6;
296     uint constant DOW_SUN = 7;
297 
298     
299     
300     
301     
302     
303     
304     
305     
306     
307     
308     
309     
310     
311     function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
312         require(year >= 1970);
313         int _year = int(year);
314         int _month = int(month);
315         int _day = int(day);
316 
317         int __days = _day
318           - 32075
319           + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
320           + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
321           - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
322           - OFFSET19700101;
323 
324         _days = uint(__days);
325     }
326 
327     
328     
329     
330     
331     
332     
333     
334     
335     
336     
337     
338     
339     
340     
341     
342     
343     
344     function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
345         int __days = int(_days);
346 
347         int L = __days + 68569 + OFFSET19700101;
348         int N = 4 * L / 146097;
349         L = L - (146097 * N + 3) / 4;
350         int _year = 4000 * (L + 1) / 1461001;
351         L = L - 1461 * _year / 4 + 31;
352         int _month = 80 * L / 2447;
353         int _day = L - 2447 * _month / 80;
354         L = _month / 11;
355         _month = _month + 2 - 12 * L;
356         _year = 100 * (N - 49) + _year + L;
357 
358         year = uint(_year);
359         month = uint(_month);
360         day = uint(_day);
361     }
362 
363     function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
364         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
365     }
366     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
367         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
368     }
369     function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
370         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
371     }
372     function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
373         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
374         uint secs = timestamp % SECONDS_PER_DAY;
375         hour = secs / SECONDS_PER_HOUR;
376         secs = secs % SECONDS_PER_HOUR;
377         minute = secs / SECONDS_PER_MINUTE;
378         second = secs % SECONDS_PER_MINUTE;
379     }
380 
381     function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
382         if (year >= 1970 && month > 0 && month <= 12) {
383             uint daysInMonth = _getDaysInMonth(year, month);
384             if (day > 0 && day <= daysInMonth) {
385                 valid = true;
386             }
387         }
388     }
389     function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
390         if (isValidDate(year, month, day)) {
391             if (hour < 24 && minute < 60 && second < 60) {
392                 valid = true;
393             }
394         }
395     }
396     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
397         uint year;
398         uint month;
399         uint day;
400         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
401         leapYear = _isLeapYear(year);
402     }
403     function _isLeapYear(uint year) internal pure returns (bool leapYear) {
404         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
405     }
406     function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
407         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
408     }
409     function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
410         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
411     }
412     function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
413         uint year;
414         uint month;
415         uint day;
416         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
417         daysInMonth = _getDaysInMonth(year, month);
418     }
419     function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
420         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
421             daysInMonth = 31;
422         } else if (month != 2) {
423             daysInMonth = 30;
424         } else {
425             daysInMonth = _isLeapYear(year) ? 29 : 28;
426         }
427     }
428     
429     function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
430         uint _days = timestamp / SECONDS_PER_DAY;
431         dayOfWeek = (_days + 3) % 7 + 1;
432     }
433 
434     function getYear(uint timestamp) internal pure returns (uint year) {
435         uint month;
436         uint day;
437         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
438     }
439     function getMonth(uint timestamp) internal pure returns (uint month) {
440         uint year;
441         uint day;
442         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
443     }
444     function getDay(uint timestamp) internal pure returns (uint day) {
445         uint year;
446         uint month;
447         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
448     }
449     function getHour(uint timestamp) internal pure returns (uint hour) {
450         uint secs = timestamp % SECONDS_PER_DAY;
451         hour = secs / SECONDS_PER_HOUR;
452     }
453     function getMinute(uint timestamp) internal pure returns (uint minute) {
454         uint secs = timestamp % SECONDS_PER_HOUR;
455         minute = secs / SECONDS_PER_MINUTE;
456     }
457     function getSecond(uint timestamp) internal pure returns (uint second) {
458         second = timestamp % SECONDS_PER_MINUTE;
459     }
460 
461     function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
462         uint year;
463         uint month;
464         uint day;
465         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
466         year += _years;
467         uint daysInMonth = _getDaysInMonth(year, month);
468         if (day > daysInMonth) {
469             day = daysInMonth;
470         }
471         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
472         require(newTimestamp >= timestamp);
473     }
474     function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
475         uint year;
476         uint month;
477         uint day;
478         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
479         month += _months;
480         year += (month - 1) / 12;
481         month = (month - 1) % 12 + 1;
482         uint daysInMonth = _getDaysInMonth(year, month);
483         if (day > daysInMonth) {
484             day = daysInMonth;
485         }
486         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
487         require(newTimestamp >= timestamp);
488     }
489     function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
490         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
491         require(newTimestamp >= timestamp);
492     }
493     function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
494         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
495         require(newTimestamp >= timestamp);
496     }
497     function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
498         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
499         require(newTimestamp >= timestamp);
500     }
501     function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
502         newTimestamp = timestamp + _seconds;
503         require(newTimestamp >= timestamp);
504     }
505 
506     function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
507         uint year;
508         uint month;
509         uint day;
510         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
511         year -= _years;
512         uint daysInMonth = _getDaysInMonth(year, month);
513         if (day > daysInMonth) {
514             day = daysInMonth;
515         }
516         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
517         require(newTimestamp <= timestamp);
518     }
519     function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
520         uint year;
521         uint month;
522         uint day;
523         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
524         uint yearMonth = year * 12 + (month - 1) - _months;
525         year = yearMonth / 12;
526         month = yearMonth % 12 + 1;
527         uint daysInMonth = _getDaysInMonth(year, month);
528         if (day > daysInMonth) {
529             day = daysInMonth;
530         }
531         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
532         require(newTimestamp <= timestamp);
533     }
534     function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
535         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
536         require(newTimestamp <= timestamp);
537     }
538     function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
539         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
540         require(newTimestamp <= timestamp);
541     }
542     function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
543         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
544         require(newTimestamp <= timestamp);
545     }
546     function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
547         newTimestamp = timestamp - _seconds;
548         require(newTimestamp <= timestamp);
549     }
550 
551     function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
552         require(fromTimestamp <= toTimestamp);
553         uint fromYear;
554         uint fromMonth;
555         uint fromDay;
556         uint toYear;
557         uint toMonth;
558         uint toDay;
559         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
560         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
561         _years = toYear - fromYear;
562     }
563     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
564         require(fromTimestamp <= toTimestamp);
565         uint fromYear;
566         uint fromMonth;
567         uint fromDay;
568         uint toYear;
569         uint toMonth;
570         uint toDay;
571         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
572         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
573         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
574     }
575     function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
576         require(fromTimestamp <= toTimestamp);
577         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
578     }
579     function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
580         require(fromTimestamp <= toTimestamp);
581         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
582     }
583     function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
584         require(fromTimestamp <= toTimestamp);
585         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
586     }
587     function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
588         require(fromTimestamp <= toTimestamp);
589         _seconds = toTimestamp - fromTimestamp;
590     }
591 }
592 
593 contract Sestrel is Ownable, ERC20, ERC20Detailed {
594     using SafeMath for uint;
595     using DateTime for uint;
596 
597     uint private TOTAL_TOKENS = 27777777;
598 
599     uint private _decimalsMul;
600 
601     
602     uint private _deployedAt;
603 
604     
605     uint private _frozenUntil;
606 
607     
608     mapping (address => bool) private _ambassadors;
609 
610     event AmbassadorAdded(address addr, uint amount);
611 
612     constructor () public ERC20Detailed("Sestrel", "STL", 18) {
613 
614         _decimalsMul = 10 ** uint(decimals());
615 
616         _deployedAt = now;
617         _frozenUntil = _deployedAt.addMonths(18);
618 
619         
620         _mint(owner(), TOTAL_TOKENS.mul(_decimalsMul));
621     }
622 
623     function renounceOwnership() public onlyOwner {
624         revert("Sestrel: renouncing is not allowed");
625     }
626 
627     
628     function transferOwnership(address newOwner) public onlyOwner {
629         transfer(newOwner, balanceOf(owner()));
630         super.transferOwnership(newOwner);
631     }
632 
633     function deployedAt() public view
634         returns (uint year, uint month, uint day) {
635 
636         return DateTime.timestampToDate(_deployedAt);
637     }
638     function frozenUntil() public view
639         returns (uint year, uint month, uint day) {
640 
641         return DateTime.timestampToDate(_frozenUntil);
642     }
643 
644     
645     
646     
647     
648     
649 
650     
651     function addAmbassador(address addr, uint amount) public onlyOwner
652         returns (bool) {
653 
654         require(addr != address(0), "Sestrel: the zero address (0x) can not be an ambassador");
655         require(addr != owner(), "Sestrel: the owner can not be an ambassador");
656         require(!_ambassadors[addr], "Sestrel: this address is already owned by an ambassador");
657 
658         _transfer(owner(), addr, amount);
659 
660         _ambassadors[addr] = true;
661 
662         emit AmbassadorAdded(addr, amount);
663 
664         return true;
665     }
666     function isAmbassador(address addr) public view returns (bool) {
667         return _ambassadors[addr];
668     }
669 
670     function _limitAmbassador() internal view {
671         require(
672             !_ambassadors[_msgSender()]
673             || now >= _frozenUntil, "Sestrel: ambassador action currently frozen"
674         );
675     }
676     function transfer(address recipient, uint amount) public
677         returns (bool) {
678 
679         _limitAmbassador();
680         return super.transfer(recipient, amount);
681     }
682     
683     function increaseAllowance(address spender, uint256 addedValue) public
684         returns (bool) {
685 
686         _limitAmbassador();
687         return super.increaseAllowance(spender, addedValue);
688     }
689 
690     function authorHash() public pure returns (string memory) {
691         return "b0b00f105d7755713edb705b6635ac5cf12d97702a65d16e1dba22dfddb65e27";
692     }
693 }