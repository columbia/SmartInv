1 pragma solidity 0.4.24;
2 
3 
4 contract DSNote {
5     event LogNote(
6         bytes4   indexed  sig,
7         address  indexed  guy,
8         bytes32  indexed  foo,
9         bytes32  indexed  bar,
10         uint              wad,
11         bytes             fax
12     ) anonymous;
13 
14     modifier note {
15         bytes32 foo;
16         bytes32 bar;
17 
18         assembly {
19             foo := calldataload(4)
20             bar := calldataload(36)
21         }
22 
23         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
24 
25         _;
26     }
27 }
28 
29 
30 contract ErrorUtils {
31 
32     event LogError(string methodSig, string errMsg);
33     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
34     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
35 
36 }
37 
38 
39 contract DSMath {
40     function add(uint x, uint y) internal pure returns (uint z) {
41         require((z = x + y) >= x);
42     }
43     function sub(uint x, uint y) internal pure returns (uint z) {
44         require((z = x - y) <= x);
45     }
46     function mul(uint x, uint y) internal pure returns (uint z) {
47         require(y == 0 || (z = x * y) / y == x);
48     }
49 
50     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
51     function div(uint x, uint y) internal pure returns (uint z) {
52         z = x / y;
53     }
54 
55     function min(uint x, uint y) internal pure returns (uint z) {
56         return x <= y ? x : y;
57     }
58     function max(uint x, uint y) internal pure returns (uint z) {
59         return x >= y ? x : y;
60     }
61     function imin(int x, int y) internal pure returns (int z) {
62         return x <= y ? x : y;
63     }
64     function imax(int x, int y) internal pure returns (int z) {
65         return x >= y ? x : y;
66     }
67 
68     uint constant WAD = 10 ** 18;
69     uint constant RAY = 10 ** 27;
70 
71     function wmul(uint x, uint y) internal pure returns (uint z) {
72         z = add(mul(x, y), WAD / 2) / WAD;
73     }
74     function rmul(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, y), RAY / 2) / RAY;
76     }
77     function wdiv(uint x, uint y) internal pure returns (uint z) {
78         z = add(mul(x, WAD), y / 2) / y;
79     }
80     function rdiv(uint x, uint y) internal pure returns (uint z) {
81         z = add(mul(x, RAY), y / 2) / y;
82     }
83 
84     // This famous algorithm is called "exponentiation by squaring"
85     // and calculates x^n with x as fixed-point and n as regular unsigned.
86     //
87     // It's O(log n), instead of O(n) for naive repeated multiplication.
88     //
89     // These facts are why it works:
90     //
91     //  If n is even, then x^n = (x^2)^(n/2).
92     //  If n is odd,  then x^n = x * x^(n-1),
93     //   and applying the equation for even x gives
94     //    x^n = x * (x^2)^((n-1) / 2).
95     //
96     //  Also, EVM division is flooring and
97     //    floor[(n-1) / 2] = floor[n / 2].
98     //
99     function rpow(uint x, uint n) internal pure returns (uint z) {
100         z = n % 2 != 0 ? x : RAY;
101 
102         for (n /= 2; n != 0; n /= 2) {
103             x = rmul(x, x);
104 
105             if (n % 2 != 0) {
106                 z = rmul(z, x);
107             }
108         }
109     }
110 }
111 
112 
113 contract DateTime {
114 
115     struct _DateTime {
116         uint16 year;
117         uint8 month;
118         uint8 day;
119         uint8 hour;
120         uint8 minute;
121         uint8 second;
122         uint8 weekday;
123     }
124 
125     uint constant DAY_IN_SECONDS = 86400;
126     uint constant YEAR_IN_SECONDS = 31536000;
127     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
128 
129     uint constant HOUR_IN_SECONDS = 3600;
130     uint constant MINUTE_IN_SECONDS = 60;
131 
132     uint16 constant ORIGIN_YEAR = 1970;
133 
134     function isLeapYear(uint16 year) public pure returns (bool) {
135         if (year % 4 != 0) {
136             return false;
137         }
138         if (year % 100 != 0) {
139             return true;
140         }
141         if (year % 400 != 0) {
142             return false;
143         }
144         return true;
145     }
146 
147     function leapYearsBefore(uint year) public pure returns (uint) {
148         year -= 1;
149         return year / 4 - year / 100 + year / 400;
150     }
151 
152     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
153         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
154             return 31;
155         }
156         else if (month == 4 || month == 6 || month == 9 || month == 11) {
157             return 30;
158         }
159         else if (isLeapYear(year)) {
160             return 29;
161         }
162         else {
163             return 28;
164         }
165     }
166 
167     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
168         uint secondsAccountedFor = 0;
169         uint buf;
170         uint8 i;
171 
172         // Year
173         dt.year = getYear(timestamp);
174         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
175 
176         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
177         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
178 
179         // Month
180         uint secondsInMonth;
181         for (i = 1; i <= 12; i++) {
182             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
183             if (secondsInMonth + secondsAccountedFor > timestamp) {
184                 dt.month = i;
185                 break;
186             }
187             secondsAccountedFor += secondsInMonth;
188         }
189 
190         // Day
191         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
192             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
193                 dt.day = i;
194                 break;
195             }
196             secondsAccountedFor += DAY_IN_SECONDS;
197         }
198 
199         // Hour
200         dt.hour = getHour(timestamp);
201 
202         // Minute
203         dt.minute = getMinute(timestamp);
204 
205         // Second
206         dt.second = getSecond(timestamp);
207 
208         // Day of week.
209         dt.weekday = getWeekday(timestamp);
210     }
211 
212     function getYear(uint timestamp) public pure returns (uint16) {
213         uint secondsAccountedFor = 0;
214         uint16 year;
215         uint numLeapYears;
216 
217         // Year
218         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
219         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
220 
221         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
222         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
223 
224         while (secondsAccountedFor > timestamp) {
225             if (isLeapYear(uint16(year - 1))) {
226                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
227             }
228             else {
229                 secondsAccountedFor -= YEAR_IN_SECONDS;
230             }
231             year -= 1;
232         }
233         return year;
234     }
235 
236     function getMonth(uint timestamp) public pure returns (uint8) {
237         return parseTimestamp(timestamp).month;
238     }
239 
240     function getDay(uint timestamp) public pure returns (uint8) {
241         return parseTimestamp(timestamp).day;
242     }
243 
244     function getHour(uint timestamp) public pure returns (uint8) {
245         return uint8((timestamp / 60 / 60) % 24);
246     }
247 
248     function getMinute(uint timestamp) public pure returns (uint8) {
249         return uint8((timestamp / 60) % 60);
250     }
251 
252     function getSecond(uint timestamp) public pure returns (uint8) {
253         return uint8(timestamp % 60);
254     }
255 
256     function getWeekday(uint timestamp) public pure returns (uint8) {
257         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
258     }
259 
260     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
261         return toTimestamp(year, month, day, 0, 0, 0);
262     }
263 
264     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
265         return toTimestamp(year, month, day, hour, 0, 0);
266     }
267 
268     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
269         return toTimestamp(year, month, day, hour, minute, 0);
270     }
271 
272     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
273         uint16 i;
274 
275         // Year
276         for (i = ORIGIN_YEAR; i < year; i++) {
277             if (isLeapYear(i)) {
278                 timestamp += LEAP_YEAR_IN_SECONDS;
279             }
280             else {
281                 timestamp += YEAR_IN_SECONDS;
282             }
283         }
284 
285         // Month
286         uint8[12] memory monthDayCounts;
287         monthDayCounts[0] = 31;
288         if (isLeapYear(year)) {
289             monthDayCounts[1] = 29;
290         }
291         else {
292             monthDayCounts[1] = 28;
293         }
294         monthDayCounts[2] = 31;
295         monthDayCounts[3] = 30;
296         monthDayCounts[4] = 31;
297         monthDayCounts[5] = 30;
298         monthDayCounts[6] = 31;
299         monthDayCounts[7] = 31;
300         monthDayCounts[8] = 30;
301         monthDayCounts[9] = 31;
302         monthDayCounts[10] = 30;
303         monthDayCounts[11] = 31;
304 
305         for (i = 1; i < month; i++) {
306             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
307         }
308 
309         // Day
310         timestamp += DAY_IN_SECONDS * (day - 1);
311 
312         // Hour
313         timestamp += HOUR_IN_SECONDS * (hour);
314 
315         // Minute
316         timestamp += MINUTE_IN_SECONDS * (minute);
317 
318         // Second
319         timestamp += second;
320 
321         return timestamp;
322     }
323 }
324 
325 
326 contract WETH9 {
327     string public name     = "Wrapped Ether";
328     string public symbol   = "WETH";
329     uint8  public decimals = 18;
330 
331     event  Approval(address indexed _owner, address indexed _spender, uint _value);
332     event  Transfer(address indexed _from, address indexed _to, uint _value);
333     event  Deposit(address indexed _owner, uint _value);
334     event  Withdrawal(address indexed _owner, uint _value);
335 
336     mapping (address => uint)                       public  balanceOf;
337     mapping (address => mapping (address => uint))  public  allowance;
338 
339     function() public payable {
340         deposit();
341     }
342 
343     function deposit() public payable {
344         balanceOf[msg.sender] += msg.value;
345         Deposit(msg.sender, msg.value);
346     }
347 
348     function withdraw(uint wad) public {
349         require(balanceOf[msg.sender] >= wad);
350         balanceOf[msg.sender] -= wad;
351         msg.sender.transfer(wad);
352         Withdrawal(msg.sender, wad);
353     }
354 
355     function totalSupply() public view returns (uint) {
356         return this.balance;
357     }
358 
359     function approve(address guy, uint wad) public returns (bool) {
360         allowance[msg.sender][guy] = wad;
361         Approval(msg.sender, guy, wad);
362         return true;
363     }
364 
365     function transfer(address dst, uint wad) public returns (bool) {
366         return transferFrom(msg.sender, dst, wad);
367     }
368 
369     function transferFrom(address src, address dst, uint wad)
370         public
371         returns (bool)
372     {
373         require(balanceOf[src] >= wad);
374 
375         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
376             require(allowance[src][msg.sender] >= wad);
377             allowance[src][msg.sender] -= wad;
378         }
379 
380         balanceOf[src] -= wad;
381         balanceOf[dst] += wad;
382 
383         Transfer(src, dst, wad);
384 
385         return true;
386     }
387 }
388 
389 
390 contract Utils {
391 
392     modifier addressValid(address _address) {
393         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
394         _;
395     }
396 
397 }
398 
399 
400 contract Proxy {
401 
402     address masterCopy;
403 
404     constructor(address _masterCopy)
405         public
406     {
407         require(_masterCopy != 0, "Invalid master copy address provided");
408         masterCopy = _masterCopy;
409     }
410 
411     function ()
412         external
413         payable
414     {
415         // solium-disable-next-line security/no-inline-assembly
416         assembly {
417             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
418             calldatacopy(0, 0, calldatasize())
419             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
420             returndatacopy(0, 0, returndatasize())
421             if eq(success, 0) { revert(0, returndatasize()) }
422             return(0, returndatasize())
423         }
424     }
425 
426     function implementation()
427         public
428         view
429         returns (address)
430     {
431         return masterCopy;
432     }
433 
434     function proxyType()
435         public
436         pure
437         returns (uint256)
438     {
439         return 2;
440     }
441 }
442 
443 
444 contract DSAuthority {
445     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
446 }
447 
448 
449 contract DSAuthEvents {
450     event LogSetAuthority (address indexed authority);
451     event LogSetOwner     (address indexed owner);
452 }
453 
454 
455 contract DSAuth is DSAuthEvents {
456     DSAuthority  public  authority;
457     address      public  owner;
458 
459     constructor() public {
460         owner = msg.sender;
461         emit LogSetOwner(msg.sender);
462     }
463 
464     function setOwner(address owner_)
465         public
466         auth
467     {
468         owner = owner_;
469         emit LogSetOwner(owner);
470     }
471 
472     function setAuthority(DSAuthority authority_)
473         public
474         auth
475     {
476         authority = authority_;
477         emit LogSetAuthority(authority);
478     }
479 
480     modifier auth {
481         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
482         _;
483     }
484 
485     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
486         if (src == address(this)) {
487             return true;
488         } else if (src == owner) {
489             return true;
490         } else if (authority == DSAuthority(0)) {
491             return false;
492         } else {
493             return authority.canCall(src, this, sig);
494         }
495     }
496 }
497 
498 
499 contract MasterCopy {
500     address masterCopy;
501 
502     function changeMasterCopy(address _masterCopy)
503         public
504     {
505         require(_masterCopy != 0, "Invalid master copy address provided");
506         masterCopy = _masterCopy;
507     }
508 }
509 
510 
511 interface ERC20 {
512 
513     function name() public view returns(string);
514     function symbol() public view returns(string);
515     function decimals() public view returns(uint8);
516     function totalSupply() public view returns (uint);
517 
518     function balanceOf(address tokenOwner) public view returns (uint balance);
519     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
520     function transfer(address to, uint tokens) public returns (bool success);
521     function approve(address spender, uint tokens) public returns (bool success);
522     function transferFrom(address from, address to, uint tokens) public returns (bool success);
523 
524     event Transfer(address indexed from, address indexed to, uint tokens);
525     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
526 }
527 
528 
529 contract Config is DSNote, DSAuth, Utils {
530 
531     WETH9 public weth9;
532     mapping (address => bool) public isAccountHandler;
533     mapping (address => bool) public isAdmin;
534     address[] public admins;
535     bool public disableAdminControl = false;
536     
537     event LogAdminAdded(address indexed _admin, address _by);
538     event LogAdminRemoved(address indexed _admin, address _by);
539 
540     constructor() public {
541         admins.push(msg.sender);
542         isAdmin[msg.sender] = true;
543     }
544 
545     modifier onlyAdmin(){
546         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
547         _;
548     }
549 
550     function setWETH9
551     (
552         address _weth9
553     ) 
554         public
555         auth
556         note
557         addressValid(_weth9) 
558     {
559         weth9 = WETH9(_weth9);
560     }
561 
562     function setAccountHandler
563     (
564         address _accountHandler,
565         bool _isAccountHandler
566     )
567         public
568         auth
569         note
570         addressValid(_accountHandler)
571     {
572         isAccountHandler[_accountHandler] = _isAccountHandler;
573     }
574 
575     function toggleAdminsControl() 
576         public
577         auth
578         note
579     {
580         disableAdminControl = !disableAdminControl;
581     }
582 
583     function isAdminValid(address _admin)
584         public
585         view
586         returns (bool)
587     {
588         if(disableAdminControl) {
589             return true;
590         } else {
591             return isAdmin[_admin];
592         }
593     }
594 
595     function getAllAdmins()
596         public
597         view
598         returns(address[])
599     {
600         return admins;
601     }
602 
603     function addAdmin
604     (
605         address _admin
606     )
607         external
608         note
609         onlyAdmin
610         addressValid(_admin)
611     {   
612         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
613 
614         admins.push(_admin);
615         isAdmin[_admin] = true;
616 
617         emit LogAdminAdded(_admin, msg.sender);
618     }
619 
620     function removeAdmin
621     (
622         address _admin
623     ) 
624         external
625         note
626         onlyAdmin
627         addressValid(_admin)
628     {   
629         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
630         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
631 
632         isAdmin[_admin] = false;
633 
634         for (uint i = 0; i < admins.length - 1; i++) {
635             if (admins[i] == _admin) {
636                 admins[i] = admins[admins.length - 1];
637                 admins.length -= 1;
638                 break;
639             }
640         }
641 
642         emit LogAdminRemoved(_admin, msg.sender);
643     }
644 }
645 
646 
647 library ECRecovery {
648 
649     function recover(bytes32 _hash, bytes _sig)
650         internal
651         pure
652     returns (address)
653     {
654         bytes32 r;
655         bytes32 s;
656         uint8 v;
657 
658         if (_sig.length != 65) {
659             return (address(0));
660         }
661 
662         assembly {
663             r := mload(add(_sig, 32))
664             s := mload(add(_sig, 64))
665             v := byte(0, mload(add(_sig, 96)))
666         }
667 
668         if (v < 27) {
669             v += 27;
670         }
671 
672         if (v != 27 && v != 28) {
673             return (address(0));
674         } else {
675             return ecrecover(_hash, v, r, s);
676         }
677     }
678 
679     function toEthSignedMessageHash(bytes32 _hash)
680         internal
681         pure
682     returns (bytes32)
683     {
684         return keccak256(
685             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
686         );
687     }
688 }
689 
690 
691 contract Utils2 {
692     using ECRecovery for bytes32;
693     
694     function _recoverSigner(bytes32 _hash, bytes _signature) 
695         internal
696         pure
697         returns(address _signer)
698     {
699         return _hash.toEthSignedMessageHash().recover(_signature);
700     }
701 
702 }
703 
704 
705 contract DSThing is DSNote, DSAuth, DSMath {
706 
707     function S(string s) internal pure returns (bytes4) {
708         return bytes4(keccak256(s));
709     }
710 
711 }
712 
713 
714 interface KyberNetworkProxy {
715 
716     function maxGasPrice() public view returns(uint);
717     function getUserCapInWei(address user) public view returns(uint);
718     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
719     function enabled() public view returns(bool);
720     function info(bytes32 id) public view returns(uint);
721 
722     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) public returns(uint);
723     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint);
724     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint);
725 
726     function getExpectedRate
727     (
728         ERC20 src,
729         ERC20 dest, 
730         uint srcQty
731     ) 
732         public
733         view
734         returns 
735     (
736         uint expectedRate,
737         uint slippageRate
738     );
739 
740     function tradeWithHint
741     (
742         ERC20 src,
743         uint srcAmount,
744         ERC20 dest,
745         address destAddress,
746         uint maxDestAmount,
747         uint minConversionRate,
748         address walletId,
749         bytes hint
750     )
751         public 
752         payable 
753         returns(uint);
754         
755 }
756 
757 
758 contract DSStop is DSNote, DSAuth {
759 
760     bool public stopped = false;
761 
762     modifier whenNotStopped {
763         require(!stopped, "DSStop::_ FEATURE_STOPPED");
764         _;
765     }
766 
767     modifier whenStopped {
768         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
769         _;
770     }
771 
772     function stop() public auth note {
773         stopped = true;
774     }
775     function start() public auth note {
776         stopped = false;
777     }
778 
779 }
780 
781 
782 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
783 
784     address[] public users;
785     mapping (address => bool) public isUser;
786     mapping (bytes32 => bool) public actionCompleted;
787 
788     WETH9 public weth9;
789     Config public config;
790     bool public isInitialized = false;
791 
792     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
793     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
794     event LogUserAdded(address indexed user, address by);
795     event LogUserRemoved(address indexed user, address by);
796 
797     modifier initialized() {
798         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
799         _;
800     }
801 
802     modifier userExists(address _user) {
803         require(isUser[_user], "Account::_ INVALID_USER");
804         _;
805     }
806 
807     modifier userDoesNotExist(address _user) {
808         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
809         _;
810     }
811 
812     modifier onlyHandler(){
813         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
814         _;
815     }
816 
817     function init(address _user, address _config) public {
818         users.push(_user);
819         isUser[_user] = true;
820         config = Config(_config);
821         weth9 = config.weth9();
822         isInitialized = true;
823     }
824     
825     function getAllUsers() public view returns (address[]) {
826         return users;
827     }
828 
829     function balanceFor(address _token) public view returns (uint _balance){
830         _balance = ERC20(_token).balanceOf(this);
831     }
832     
833     function transferBySystem
834     (   
835         address _token,
836         address _to,
837         uint _value
838     ) 
839         external 
840         onlyHandler
841         note 
842         initialized
843     {
844         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
845         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
846 
847         emit LogTransferBySystem(_token, _to, _value, msg.sender);
848     }
849     
850     function transferByUser
851     (   
852         address _token,
853         address _to,
854         uint _value,
855         uint _salt,
856         bytes _signature
857     ) 
858         external
859         addressValid(_to)
860         note
861         initialized
862     {
863         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
864 
865         if(actionCompleted[actionHash]) {
866             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
867             return;
868         }
869 
870         if(ERC20(_token).balanceOf(this) < _value){
871             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
872             return;
873         }
874 
875         address signer = _recoverSigner(actionHash, _signature);
876 
877         if(!isUser[signer]) {
878             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
879             return;
880         }
881 
882         actionCompleted[actionHash] = true;
883         
884         if (_token == address(weth9)) {
885             weth9.withdraw(_value);
886             _to.transfer(_value);
887         } else {
888             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
889         }
890 
891         emit LogTransferByUser(_token, _to, _value, signer);
892     }
893 
894     function addUser
895     (
896         address _user,
897         uint _salt,
898         bytes _signature
899     )
900         external 
901         note 
902         addressValid(_user)
903         userDoesNotExist(_user)
904         initialized
905     {   
906         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
907         if(actionCompleted[actionHash])
908         {
909             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
910             return;
911         }
912 
913         address signer = _recoverSigner(actionHash, _signature);
914 
915         if(!isUser[signer]) {
916             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
917             return;
918         }
919 
920         actionCompleted[actionHash] = true;
921 
922         users.push(_user);
923         isUser[_user] = true;
924 
925         emit LogUserAdded(_user, signer);
926     }
927 
928     function removeUser
929     (
930         address _user,
931         uint _salt,
932         bytes _signature
933     ) 
934         external
935         note
936         userExists(_user) 
937         initialized
938     {   
939         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
940 
941         if(actionCompleted[actionHash]) {
942             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
943             return;
944         }
945 
946         address signer = _recoverSigner(actionHash, _signature);
947         
948         // discussed with ratnesh -> 9-Jan-2019
949         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
950         if(!isUser[signer]){
951             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
952             return;
953         }
954         
955         actionCompleted[actionHash] = true;
956 
957         // should delete value from isUser map? delete isUser[_user]?
958         isUser[_user] = false;
959         for (uint i = 0; i < users.length - 1; i++) {
960             if (users[i] == _user) {
961                 users[i] = users[users.length - 1];
962                 users.length -= 1;
963                 break;
964             }
965         }
966 
967         emit LogUserRemoved(_user, signer);
968     }
969 
970     function _getTransferActionHash
971     ( 
972         address _token,
973         address _to,
974         uint _value,
975         uint _salt
976     ) 
977         internal
978         view
979         returns (bytes32)
980     {
981         return keccak256(
982             abi.encodePacked(
983                 address(this),
984                 _token,
985                 _to,
986                 _value,
987                 _salt
988             )
989         );
990     }
991 
992     function _getUserActionHash
993     ( 
994         address _user,
995         string _action,
996         uint _salt
997     ) 
998         internal
999         view
1000         returns (bytes32)
1001     {
1002         return keccak256(
1003             abi.encodePacked(
1004                 address(this),
1005                 _user,
1006                 _action,
1007                 _salt
1008             )
1009         );
1010     }
1011 
1012     // to directly send ether to contract
1013     function() external payable {
1014         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
1015 
1016         if(msg.sender != address(weth9)){
1017             weth9.deposit.value(msg.value)();
1018         }
1019     }
1020     
1021 }
1022 
1023 
1024 contract AccountFactory is DSStop, Utils {
1025     Config public config;
1026     mapping (address => bool) public isAccount;
1027     mapping (address => address[]) public userToAccounts;
1028     address[] public accounts;
1029 
1030     address public accountMaster;
1031 
1032     constructor
1033     (
1034         Config _config, 
1035         address _accountMaster
1036     ) 
1037     public 
1038     {
1039         config = _config;
1040         accountMaster = _accountMaster;
1041     }
1042 
1043     event LogAccountCreated(address indexed user, address indexed account, address by);
1044 
1045     modifier onlyAdmin() {
1046         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
1047         _;
1048     }
1049 
1050     function setConfig(Config _config) external note auth addressValid(_config) {
1051         config = _config;
1052     }
1053 
1054     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
1055         accountMaster = _accountMaster;
1056     }
1057 
1058     function newAccount(address _user)
1059         public
1060         note
1061         onlyAdmin
1062         addressValid(config)
1063         addressValid(accountMaster)
1064         whenNotStopped
1065         returns 
1066         (
1067             Account _account
1068         ) 
1069     {
1070         address proxy = new Proxy(accountMaster);
1071         _account = Account(proxy);
1072         _account.init(_user, config);
1073 
1074         accounts.push(_account);
1075         userToAccounts[_user].push(_account);
1076         isAccount[_account] = true;
1077 
1078         emit LogAccountCreated(_user, _account, msg.sender);
1079     }
1080     
1081     function batchNewAccount(address[] _users) public note onlyAdmin {
1082         for (uint i = 0; i < _users.length; i++) {
1083             newAccount(_users[i]);
1084         }
1085     }
1086 
1087     function getAllAccounts() public view returns (address[]) {
1088         return accounts;
1089     }
1090 
1091     function getAccountsForUser(address _user) public view returns (address[]) {
1092         return userToAccounts[_user];
1093     }
1094 
1095 }
1096 
1097 
1098 contract Escrow is DSNote, DSAuth {
1099 
1100     event LogTransfer(address indexed token, address indexed to, uint value);
1101     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
1102 
1103     function transfer
1104     (
1105         address _token,
1106         address _to,
1107         uint _value
1108     )
1109         public
1110         note
1111         auth
1112     {
1113         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
1114         emit LogTransfer(_token, _to, _value);
1115     }
1116 
1117     function transferFromAccount
1118     (
1119         address _account,
1120         address _token,
1121         address _to,
1122         uint _value
1123     )
1124         public
1125         note
1126         auth
1127     {   
1128         Account(_account).transferBySystem(_token, _to, _value);
1129         emit LogTransferFromAccount(_account, _token, _to, _value);
1130     }
1131 
1132 }
1133 
1134 
1135 contract KyberConnector is DSNote, DSAuth, Utils {
1136     KyberNetworkProxy public kyber;
1137 
1138     constructor(KyberNetworkProxy _kyber) public {
1139         kyber = _kyber;
1140     }
1141 
1142     function setKyber(KyberNetworkProxy _kyber) 
1143         public
1144         auth
1145         addressValid(_kyber)
1146     {
1147         kyber = _kyber;
1148     }
1149 
1150     event LogTrade
1151     (
1152         address indexed _from,
1153         address indexed _srcToken,
1154         address indexed _destToken,
1155         uint _srcTokenValue,
1156         uint _maxDestTokenValue,
1157         uint _destTokenValue,
1158         uint _srcTokenValueLeft
1159     );
1160 
1161     function trade
1162     (   
1163         Escrow _escrow,
1164         ERC20 _srcToken,
1165         ERC20 _destToken,
1166         uint _srcTokenValue,
1167         uint _maxDestTokenValue
1168     )
1169         external
1170         note
1171         auth
1172         returns (uint _destTokenValue, uint _srcTokenValueLeft)
1173     {   
1174         require(address(_srcToken) != address(_destToken), "KyberConnector::process TOKEN_ADDRS_SHOULD_NOT_MATCH");
1175 
1176         uint _slippageRate;
1177         (, _slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcTokenValue);
1178 
1179         uint initialSrcTokenBalance = _srcToken.balanceOf(this);
1180 
1181         require(_srcToken.balanceOf(_escrow) >= _srcTokenValue, "KyberConnector::process INSUFFICIENT_BALANCE_IN_ESCROW");
1182         _escrow.transfer(_srcToken, this, _srcTokenValue);
1183 
1184         require(_srcToken.approve(kyber, 0), "KyberConnector::process SRC_APPROVAL_FAILED");
1185         require(_srcToken.approve(kyber, _srcTokenValue), "KyberConnector::process SRC_APPROVAL_FAILED");
1186         
1187         _destTokenValue = kyber.tradeWithHint(
1188             _srcToken,
1189             _srcTokenValue,
1190             _destToken,
1191             this,
1192             _maxDestTokenValue,
1193             _slippageRate, //0, // no min coversation rate
1194             address(0), // TODO: check if needed
1195             ""// bytes(0) 
1196         );
1197 
1198         _srcTokenValueLeft = _srcToken.balanceOf(this) - initialSrcTokenBalance;
1199 
1200         require(_transfer(_destToken, _escrow, _destTokenValue), "KyberConnector::process DEST_TOKEN_TRANSFER_FAILED");
1201         require(_transfer(_srcToken, _escrow, _srcTokenValueLeft), "KyberConnector::process SRC_TOKEN_TRANSFER_FAILED");
1202 
1203         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _maxDestTokenValue, _destTokenValue, _srcTokenValueLeft);
1204     } 
1205 
1206     function getExpectedRate(ERC20 _srcToken, ERC20 _destToken, uint _srcTokenValue) 
1207         public
1208         view
1209         returns(uint _expectedRate, uint _slippageRate)
1210     {
1211         (_expectedRate, _slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcTokenValue);
1212     }
1213 
1214     function isTradeFeasible(ERC20 _srcToken, ERC20 _destToken, uint _srcTokenValue) 
1215         public
1216         view
1217         returns(bool)
1218     {
1219         uint slippageRate; 
1220 
1221         (, slippageRate) = getExpectedRate(
1222             ERC20(_srcToken),
1223             ERC20(_destToken),
1224             _srcTokenValue
1225         );
1226 
1227         return slippageRate == 0 ? false : true;
1228     }
1229 
1230     function _transfer
1231     (
1232         ERC20 _token,
1233         address _to,
1234         uint _value
1235     )
1236         internal
1237         returns (bool)
1238     {
1239         return _token.transfer(_to, _value);
1240     }
1241 }
1242 
1243 
1244 contract Reserve is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1245 
1246     Escrow public escrow;
1247     AccountFactory public accountFactory;
1248     DateTime public dateTime;
1249     Config public config;
1250     uint public deployTimestamp;
1251 
1252     string constant public VERSION = "1.0.0";
1253 
1254     uint public TIME_INTERVAL = 1 days;
1255     
1256     constructor
1257     (
1258         Escrow _escrow,
1259         AccountFactory _accountFactory,
1260         DateTime _dateTime,
1261         Config _config
1262     ) 
1263     public 
1264     {
1265         escrow = _escrow;
1266         accountFactory = _accountFactory;
1267         dateTime = _dateTime;
1268         config = _config;
1269         deployTimestamp = now - (4 * TIME_INTERVAL);
1270     }
1271 
1272     function setEscrow(Escrow _escrow) 
1273         public 
1274         note 
1275         auth
1276         addressValid(_escrow)
1277     {
1278         escrow = _escrow;
1279     }
1280 
1281     function setAccountFactory(AccountFactory _accountFactory) 
1282         public 
1283         note 
1284         auth
1285         addressValid(_accountFactory)
1286     {
1287         accountFactory = _accountFactory;
1288     }
1289 
1290     function setDateTime(DateTime _dateTime) 
1291         public 
1292         note 
1293         auth
1294         addressValid(_dateTime)
1295     {
1296         dateTime = _dateTime;
1297     }
1298 
1299     function setConfig(Config _config) 
1300         public 
1301         note 
1302         auth
1303         addressValid(_config)
1304     {
1305         config = _config;
1306     }
1307 
1308     struct Order {
1309         address account;
1310         address token;
1311         address byUser;
1312         uint value;
1313         uint duration;
1314         uint expirationTimestamp;
1315         uint salt;
1316         uint createdTimestamp;
1317         bytes32 orderHash;
1318     }
1319 
1320     bytes32[] public orders;
1321     mapping (bytes32 => Order) public hashToOrder;
1322     mapping (bytes32 => bool) public isOrder;
1323     mapping (address => bytes32[]) public accountToOrders;
1324     mapping (bytes32 => bool) public cancelledOrders;
1325 
1326     // per day
1327     mapping (uint => mapping(address => uint)) public deposits;
1328     mapping (uint => mapping(address => uint)) public withdrawals;
1329     mapping (uint => mapping(address => uint)) public profits;
1330     mapping (uint => mapping(address => uint)) public losses;
1331 
1332     mapping (uint => mapping(address => uint)) public reserves;
1333     mapping (address => uint) public lastReserveRuns;
1334 
1335     mapping (address => mapping(address => uint)) surplus;
1336 
1337     mapping (bytes32 => CumulativeRun) public orderToCumulative;
1338 
1339     struct CumulativeRun {
1340         uint timestamp;
1341         uint value;
1342     }
1343 
1344     modifier onlyAdmin() {
1345         require(config.isAdminValid(msg.sender), "Reserve::_ INVALID_ADMIN_ACCOUNT");
1346         _;
1347     }
1348 
1349     event LogOrderCreated(
1350         bytes32 indexed orderHash,
1351         address indexed account,
1352         address indexed token,
1353         address byUser,
1354         uint value,
1355         uint expirationTimestamp
1356     );
1357 
1358     event LogOrderCancelled(
1359         bytes32 indexed orderHash,
1360         address indexed by
1361     );
1362 
1363     event LogReserveValuesUpdated(
1364         address indexed token, 
1365         uint indexed updatedTill,
1366         uint reserve,
1367         uint profit,
1368         uint loss
1369     );
1370 
1371     event LogOrderCumulativeUpdated(
1372         bytes32 indexed orderHash,
1373         uint updatedTill,
1374         uint value
1375     );
1376 
1377     event LogRelease(
1378         address indexed token,
1379         address indexed to,
1380         uint value,
1381         address by
1382     );
1383 
1384     event LogLock(
1385         address indexed token,
1386         address indexed from,
1387         uint value,
1388         uint profit,
1389         uint loss,
1390         address by
1391     );
1392 
1393     event LogLockSurplus(
1394         address indexed forToken, 
1395         address indexed token,
1396         address from,
1397         uint value
1398     );
1399 
1400     event LogTransferSurplus(
1401         address indexed forToken,
1402         address indexed token,
1403         address to, 
1404         uint value
1405     );
1406     
1407     function createOrder
1408     (
1409         address[3] _orderAddresses,
1410         uint[3] _orderValues,
1411         bytes _signature
1412     ) 
1413         public
1414         note
1415         onlyAdmin
1416         whenNotStopped
1417     {
1418         Order memory order = _composeOrder(_orderAddresses, _orderValues);
1419         address signer = _recoverSigner(order.orderHash, _signature);
1420 
1421         if(signer != order.byUser){
1422             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_ORDER_CREATOR");
1423             return;
1424         }
1425         
1426         if(isOrder[order.orderHash]){
1427             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "ORDER_ALREADY_EXISTS");
1428             return;
1429         }
1430 
1431         if(!accountFactory.isAccount(order.account)){
1432             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_ACCOUNT");
1433             return;
1434         }
1435 
1436         if(!Account(order.account).isUser(signer)){
1437             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1438             return;
1439         }
1440                 
1441         if(!_isOrderValid(order)) {
1442             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_PARAMETERS");
1443             return;
1444         }
1445 
1446         if(ERC20(order.token).balanceOf(order.account) < order.value){
1447             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
1448             return;
1449         }
1450 
1451         escrow.transferFromAccount(order.account, order.token, address(escrow), order.value);
1452         
1453         orders.push(order.orderHash);
1454         hashToOrder[order.orderHash] = order;
1455         isOrder[order.orderHash] = true;
1456         accountToOrders[order.account].push(order.orderHash);
1457 
1458         uint dateTimestamp = _getDateTimestamp(now);
1459 
1460         deposits[dateTimestamp][order.token] = add(deposits[dateTimestamp][order.token], order.value);
1461         
1462         orderToCumulative[order.orderHash].timestamp = _getDateTimestamp(order.createdTimestamp);
1463         orderToCumulative[order.orderHash].value = order.value;
1464 
1465         emit LogOrderCreated(
1466             order.orderHash,
1467             order.account,
1468             order.token,
1469             order.byUser,
1470             order.value,
1471             order.expirationTimestamp
1472         );
1473     }
1474 
1475     function cancelOrder
1476     (
1477         bytes32 _orderHash,
1478         bytes _signature
1479     )
1480         external
1481         note
1482         onlyAdmin
1483     {   
1484         if(!isOrder[_orderHash]) {
1485             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_DOES_NOT_EXIST");
1486             return;
1487         }
1488 
1489         if(cancelledOrders[_orderHash]){
1490             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_ALREADY_CANCELLED");
1491             return;
1492         }
1493 
1494         Order memory order = hashToOrder[_orderHash];
1495 
1496         bytes32 cancelOrderHash = _generateActionOrderHash(_orderHash, "CANCEL_RESERVE_ORDER");
1497         address signer = _recoverSigner(cancelOrderHash, _signature);
1498         
1499         if(!Account(order.account).isUser(signer)){
1500             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1501             return;
1502         }
1503         
1504         doCancelOrder(order);
1505     }
1506     
1507     function processOrder
1508     (
1509         bytes32 _orderHash
1510     ) 
1511         external 
1512         note
1513         onlyAdmin
1514     {
1515         if(!isOrder[_orderHash]) {
1516             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_DOES_NOT_EXIST");
1517             return;
1518         }
1519 
1520         if(cancelledOrders[_orderHash]){
1521             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_ALREADY_CANCELLED");
1522             return;
1523         }
1524 
1525         Order memory order = hashToOrder[_orderHash];
1526 
1527         if(now > _getDateTimestamp(order.expirationTimestamp)) {
1528             doCancelOrder(order);
1529         } else {
1530             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::processOrder", "ORDER_NOT_EXPIRED");
1531         }
1532     }
1533 
1534     function doCancelOrder(Order _order) 
1535         internal
1536     {   
1537         uint valueToTransfer = orderToCumulative[_order.orderHash].value;
1538 
1539         if(ERC20(_order.token).balanceOf(escrow) < valueToTransfer){
1540             emit LogErrorWithHintBytes32(_order.orderHash, "Reserve::doCancel", "INSUFFICIENT_BALANCE_IN_ESCROW");
1541             return;
1542         }
1543 
1544         uint nowDateTimestamp = _getDateTimestamp(now);
1545         cancelledOrders[_order.orderHash] = true;
1546         withdrawals[nowDateTimestamp][_order.token] = add(withdrawals[nowDateTimestamp][_order.token], valueToTransfer);
1547 
1548         escrow.transfer(_order.token, _order.account, valueToTransfer);
1549         emit LogOrderCancelled(_order.orderHash, msg.sender);
1550     }
1551 
1552     function release(address _token, address _to, uint _value) 
1553         external
1554         note
1555         auth
1556     {   
1557         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::release INSUFFICIENT_BALANCE_IN_ESCROW");
1558         escrow.transfer(_token, _to, _value);
1559         emit LogRelease(_token, _to, _value, msg.sender);
1560     }
1561 
1562     // _value includes profit/loss as well
1563     function lock(address _token, address _from, uint _value, uint _profit, uint _loss)
1564         external
1565         note
1566         auth
1567     {   
1568         require(!(_profit == 0 && _loss == 0), "Reserve::lock INVALID_PROFIT_LOSS_VALUES");
1569         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lock INSUFFICIENT_BALANCE");
1570             
1571         if(accountFactory.isAccount(_from)) {
1572             escrow.transferFromAccount(_from, _token, address(escrow), _value);
1573         } else {
1574             Escrow(_from).transfer(_token, address(escrow), _value);
1575         }
1576         
1577         uint dateTimestamp = _getDateTimestamp(now);
1578 
1579         if (_profit > 0){
1580             profits[dateTimestamp][_token] = add(profits[dateTimestamp][_token], _profit);
1581         } else if (_loss > 0) {
1582             losses[dateTimestamp][_token] = add(losses[dateTimestamp][_token], _loss);
1583         }
1584 
1585         emit LogLock(_token, _from, _value, _profit, _loss, msg.sender);
1586     }
1587 
1588     // to lock collateral if cannot be liquidated e.g. not enough reserves in kyber
1589     function lockSurplus(address _from, address _forToken, address _token, uint _value) 
1590         external
1591         note
1592         auth
1593     {
1594         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lockSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1595 
1596         Escrow(_from).transfer(_token, address(escrow), _value);
1597         surplus[_forToken][_token] = add(surplus[_forToken][_token], _value);
1598 
1599         emit LogLockSurplus(_forToken, _token, _from, _value);
1600     }
1601 
1602     // to transfer surplus collateral out of the system to trade on other platforms and put back in terms of 
1603     // principal to reserve manually using an account or surplus escrow
1604     // should work in tandem with lock method when transferring back principal
1605     function transferSurplus(address _to, address _forToken, address _token, uint _value) 
1606         external
1607         note
1608         auth
1609     {
1610         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::transferSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1611         require(surplus[_forToken][_token] >= _value, "Reserve::transferSurplus INSUFFICIENT_SURPLUS");
1612 
1613         surplus[_forToken][_token] = sub(surplus[_forToken][_token], _value);
1614         escrow.transfer(_token, _to, _value);
1615 
1616         emit LogTransferSurplus(_forToken, _token, _to, _value);
1617     }
1618 
1619     function updateReserveValues(address _token, uint _forDays)
1620         public
1621         note
1622         onlyAdmin
1623     {   
1624         uint lastReserveRun = lastReserveRuns[_token];
1625 
1626         if (lastReserveRun == 0) {
1627             lastReserveRun = _getDateTimestamp(deployTimestamp) - TIME_INTERVAL;
1628         }
1629 
1630         uint nowDateTimestamp = _getDateTimestamp(now);
1631         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastReserveRun) / TIME_INTERVAL;
1632 
1633         if(updatesLeft == 0) {
1634             emit LogErrorWithHintAddress(_token, "Reserve::updateReserveValues", "RESERVE_VALUES_UP_TO_DATE");
1635             return;
1636         }
1637 
1638         uint counter = updatesLeft;
1639 
1640         if(updatesLeft > _forDays && _forDays > 0) {
1641             counter = _forDays;
1642         }
1643 
1644         for (uint i = 0; i < counter; i++) {
1645             reserves[lastReserveRun + TIME_INTERVAL][_token] = sub(
1646                 sub(
1647                     add(
1648                         add(
1649                             reserves[lastReserveRun][_token],
1650                             deposits[lastReserveRun + TIME_INTERVAL][_token]
1651                         ),
1652                         profits[lastReserveRun + TIME_INTERVAL][_token]
1653                     ),
1654                     losses[lastReserveRun + TIME_INTERVAL][_token]
1655                 ),
1656                 withdrawals[lastReserveRun + TIME_INTERVAL][_token]
1657             );
1658             lastReserveRuns[_token] = lastReserveRun + TIME_INTERVAL;
1659             lastReserveRun = lastReserveRuns[_token];
1660             
1661             emit LogReserveValuesUpdated(
1662                 _token,
1663                 lastReserveRun,
1664                 reserves[lastReserveRun][_token],
1665                 profits[lastReserveRun][_token],
1666                 losses[lastReserveRun][_token]
1667             );
1668             
1669         }
1670     }
1671 
1672     function updateOrderCumulativeValueBatch(bytes32[] _orderHashes, uint[] _forDays) 
1673         public
1674         note
1675         onlyAdmin
1676     {   
1677         if(_orderHashes.length != _forDays.length) {
1678             emit LogError("Reserve::updateOrderCumulativeValueBatch", "ARGS_ARRAYLENGTH_MISMATCH");
1679             return;
1680         }
1681 
1682         for(uint i = 0; i < _orderHashes.length; i++) {
1683             updateOrderCumulativeValue(_orderHashes[i], _forDays[i]);
1684         }
1685     }
1686 
1687     function updateOrderCumulativeValue
1688     (
1689         bytes32 _orderHash, 
1690         uint _forDays
1691     ) 
1692         public
1693         note
1694         onlyAdmin 
1695     {
1696         if(!isOrder[_orderHash]) {
1697             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_DOES_NOT_EXIST");
1698             return;
1699         }
1700 
1701         if(cancelledOrders[_orderHash]) {
1702             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_ALREADY_CANCELLED");
1703             return;
1704         }
1705         
1706         Order memory order = hashToOrder[_orderHash];
1707         CumulativeRun storage cumulativeRun = orderToCumulative[_orderHash];
1708         
1709         uint profitsAccrued = 0;
1710         uint lossesAccrued = 0;
1711         uint cumulativeValue = 0;
1712         uint counter = 0;
1713 
1714         uint lastOrderRun = cumulativeRun.timestamp;
1715         uint nowDateTimestamp = _getDateTimestamp(now);
1716 
1717         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastOrderRun) / TIME_INTERVAL;
1718 
1719         if(updatesLeft == 0) {
1720             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_VALUES_UP_TO_DATE");
1721             return;
1722         }
1723 
1724         counter = updatesLeft;
1725 
1726         if(updatesLeft > _forDays && _forDays > 0) {
1727             counter = _forDays;
1728         }
1729 
1730         for (uint i = 0; i < counter; i++){
1731             cumulativeValue = cumulativeRun.value;
1732             lastOrderRun = cumulativeRun.timestamp;
1733 
1734             if(lastReserveRuns[order.token] < lastOrderRun) {
1735                 emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "RESERVE_VALUES_NOT_UPDATED");
1736                 emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1737                 return;
1738             }
1739 
1740             profitsAccrued = div(
1741                 mul(profits[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1742                 reserves[lastOrderRun][order.token]
1743             );
1744                 
1745             lossesAccrued = div(
1746                 mul(losses[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1747                 reserves[lastOrderRun][order.token]
1748             );
1749 
1750             cumulativeValue = sub(add(cumulativeValue, profitsAccrued), lossesAccrued);
1751 
1752             cumulativeRun.timestamp = lastOrderRun + TIME_INTERVAL;
1753             cumulativeRun.value = cumulativeValue;
1754         }
1755         
1756         emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1757     }
1758 
1759     function getAllOrders() 
1760         public
1761         view 
1762         returns 
1763         (
1764             bytes32[]
1765         ) 
1766     {
1767         return orders;
1768     }
1769 
1770     function getOrdersForAccount(address _account) 
1771         public
1772         view 
1773         returns 
1774         (
1775             bytes32[]
1776         )
1777     {
1778         return accountToOrders[_account];
1779     }
1780 
1781     function getOrder(bytes32 _orderHash)
1782         public 
1783         view 
1784         returns 
1785         (
1786             address _account,
1787             address _token,
1788             address _byUser,
1789             uint _value,
1790             uint _expirationTimestamp,
1791             uint _salt,
1792             uint _createdTimestamp
1793         )
1794     {   
1795         Order memory order = hashToOrder[_orderHash];
1796         return (
1797             order.account,
1798             order.token,
1799             order.byUser,
1800             order.value,
1801             order.expirationTimestamp,
1802             order.salt,
1803             order.createdTimestamp
1804         );
1805     }
1806 
1807     function _isOrderValid(Order _order)
1808         internal
1809         view
1810         returns (bool)
1811     {
1812         if(_order.account == address(0) || _order.byUser == address(0)
1813          || _order.value <= 0
1814          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
1815             return false;
1816         }
1817 
1818         if(isOrder[_order.orderHash]) {
1819             return false;
1820         }
1821 
1822         if(cancelledOrders[_order.orderHash]) {
1823             return false;
1824         }
1825 
1826         return true;
1827     }
1828 
1829     function _composeOrder(address[3] _orderAddresses, uint[3] _orderValues)
1830         internal
1831         view
1832         returns (Order _order)
1833     {
1834         Order memory order = Order({
1835             account: _orderAddresses[0],
1836             token: _orderAddresses[1],
1837             byUser: _orderAddresses[2],
1838             value: _orderValues[0],
1839             createdTimestamp: now,
1840             duration: _orderValues[1],
1841             expirationTimestamp: add(now, _orderValues[1]),
1842             salt: _orderValues[2],
1843             orderHash: bytes32(0)
1844         });
1845 
1846         order.orderHash = _generateCreateOrderHash(order);
1847 
1848         return order;
1849     }
1850 
1851     function _generateCreateOrderHash(Order _order)
1852         internal
1853         pure //view
1854         returns (bytes32 _orderHash)
1855     {
1856         return keccak256(
1857             abi.encodePacked(
1858  //              address(this),
1859                 _order.account,
1860                 _order.token,
1861                 _order.value,
1862                 _order.duration,
1863                 _order.salt
1864             )
1865         );
1866     }
1867 
1868     function _generateActionOrderHash
1869     (
1870         bytes32 _orderHash,
1871         string _action
1872     )
1873         internal
1874         pure //view
1875         returns (bytes32 _repayOrderHash)
1876     {
1877         return keccak256(
1878             abi.encodePacked(
1879 //                address(this),
1880                 _orderHash,
1881                 _action
1882             )
1883         );
1884     }
1885 
1886     function _getDateTimestamp(uint _timestamp) 
1887         internal
1888         view
1889         returns (uint)
1890     {
1891         // 1 day
1892         return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp));
1893     } 
1894 
1895 }
1896 
1897 
1898 contract Kernel is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1899 
1900     Escrow public escrow;
1901     AccountFactory public accountFactory;
1902     Reserve public reserve;
1903     address public feeWallet;
1904     Config public config;
1905     KyberConnector public kyberConnector;
1906     
1907     string constant public VERSION = "1.0.0";
1908 
1909     constructor
1910     (
1911         Escrow _escrow,
1912         AccountFactory _accountFactory,
1913         Reserve _reserve,
1914         address _feeWallet,
1915         Config _config,
1916         KyberConnector _kyberConnector
1917     ) 
1918     public 
1919     {
1920         escrow = _escrow;
1921         accountFactory = _accountFactory;
1922         reserve = _reserve;
1923         feeWallet = _feeWallet;
1924         config = _config;
1925         kyberConnector = _kyberConnector;
1926     }
1927 
1928     function setEscrow(Escrow _escrow) 
1929         public 
1930         note 
1931         auth
1932         addressValid(_escrow)
1933     {
1934         escrow = _escrow;
1935     }
1936 
1937     function setAccountFactory(AccountFactory _accountFactory)
1938         public 
1939         note 
1940         auth
1941         addressValid(_accountFactory)
1942     {
1943         accountFactory = _accountFactory;
1944     }
1945 
1946     function setReserve(Reserve _reserve)
1947         public 
1948         note 
1949         auth
1950         addressValid(_reserve)
1951     {
1952         reserve = _reserve;
1953     }
1954 
1955     function setConfig(Config _config)
1956         public 
1957         note 
1958         auth
1959         addressValid(_config)
1960     {
1961         config = _config;
1962     }
1963 
1964     function setKyberConnector(KyberConnector _kyberConnector)
1965         public 
1966         note 
1967         auth
1968         addressValid(_kyberConnector)
1969     {
1970         kyberConnector = _kyberConnector;
1971     }
1972 
1973     function setFeeWallet(address _feeWallet) 
1974         public 
1975         note 
1976         auth
1977         addressValid(_feeWallet)
1978     {
1979         feeWallet = _feeWallet;
1980     }
1981 
1982     event LogOrderCreated(
1983         bytes32 indexed orderHash,
1984         address indexed account,
1985         address indexed principalToken,
1986         address collateralToken,
1987         address byUser,
1988         uint principalAmount,
1989         uint collateralAmount,
1990         uint premium, // should be in wad?
1991         uint expirationTimestamp,
1992         uint fee
1993     );
1994 
1995     event LogOrderRepaid(
1996         bytes32 indexed orderHash,
1997         uint  valueRepaid
1998     );
1999 
2000     event LogOrderDefaulted(
2001         bytes32 indexed orderHash,
2002         string reason
2003     );
2004 
2005     struct Order {
2006         address account;
2007         address byUser;
2008         address principalToken; 
2009         address collateralToken;
2010         uint principalAmount;
2011         uint collateralAmount;
2012         uint premium;
2013         uint duration;
2014         uint expirationTimestamp;
2015         uint salt;
2016         uint fee;
2017         uint createdTimestamp;
2018         bytes32 orderHash;
2019     }
2020 
2021     bytes32[] public orders;
2022     mapping (bytes32 => Order) public hashToOrder;
2023     mapping (bytes32 => bool) public isOrder;
2024     mapping (address => bytes32[]) public accountToOrders;
2025     
2026     mapping (bytes32 => bool) public isRepaid;
2027     mapping (bytes32 => bool) public isDefaulted;
2028 
2029     modifier onlyAdmin() {
2030         require(config.isAdminValid(msg.sender), "Kernel::_ INVALID_ADMIN_ACCOUNT");
2031         _;
2032     }
2033 
2034     // add price to check collateralisation ratio?
2035     function createOrder
2036     (
2037         address[4] _orderAddresses,
2038         uint[6] _orderValues,
2039         bytes _signature
2040     )    
2041         external
2042         note
2043         onlyAdmin
2044         whenNotStopped
2045     {   
2046         Order memory order = _composeOrder(_orderAddresses, _orderValues);
2047         address signer = _recoverSigner(order.orderHash, _signature);
2048 
2049         if(signer != order.byUser) {
2050             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","SIGNER_NOT_ORDER_CREATOR");
2051             return;
2052         }
2053 
2054         if(isOrder[order.orderHash]){
2055             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","ORDER_ALREADY_EXISTS");
2056             return;
2057         }
2058 
2059         if(!accountFactory.isAccount(order.account)){
2060             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INVALID_ORDER_ACCOUNT");
2061             return;
2062         }
2063 
2064         if(!Account(order.account).isUser(signer)) {
2065             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2066             return;
2067         }
2068 
2069         if(!_isOrderValid(order)){
2070             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INVALID_ORDER_PARAMETERS");
2071             return;
2072         }
2073 
2074         if(ERC20(order.collateralToken).balanceOf(order.account) < order.collateralAmount){
2075             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INSUFFICIENT_COLLATERAL_IN_ACCOUNT");
2076             return;
2077         }
2078 
2079         if(ERC20(order.principalToken).balanceOf(reserve.escrow()) < order.principalAmount){
2080             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INSUFFICIENT_FUNDS_IN_RESERVE");
2081             return;
2082         }
2083         
2084         orders.push(order.orderHash);
2085         hashToOrder[order.orderHash] = order;
2086         isOrder[order.orderHash] = true;
2087         accountToOrders[order.account].push(order.orderHash);
2088 
2089         escrow.transferFromAccount(order.account, order.collateralToken, address(escrow), order.collateralAmount);
2090         reserve.release(order.principalToken, order.account, order.principalAmount);
2091     
2092         emit LogOrderCreated(
2093             order.orderHash,
2094             order.account,
2095             order.principalToken,
2096             order.collateralToken,
2097             order.byUser,
2098             order.principalAmount,
2099             order.collateralAmount,
2100             order.premium,
2101             order.expirationTimestamp,
2102             order.fee
2103         );
2104     }
2105 
2106     function getExpectedRepayValue(bytes32 _orderHash) 
2107         public
2108         view
2109         returns (uint)
2110     {
2111         Order memory order = hashToOrder[_orderHash];
2112         uint profits = sub(div(mul(order.principalAmount, order.premium), WAD), order.fee);
2113         uint valueToRepay = add(order.principalAmount, profits);
2114 
2115         return valueToRepay;
2116     }
2117 
2118     function repay
2119     (
2120         bytes32 _orderHash,
2121         uint _value,
2122         bytes _signature
2123     ) 
2124         external
2125         note
2126         onlyAdmin
2127     {   
2128         if(!isOrder[_orderHash]){
2129             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_DOES_NOT_EXIST");
2130             return;
2131         }
2132 
2133         if(isRepaid[_orderHash]){
2134             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_ALREADY_REPAID");
2135             return;
2136         }
2137 
2138         if(isDefaulted[_orderHash]){
2139             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_ALREADY_DEFAULTED");
2140             return;
2141         }
2142         
2143         bytes32 repayOrderHash = _generateRepayOrderHash(_orderHash, _value);
2144         address signer = _recoverSigner(repayOrderHash, _signature);
2145 
2146         Order memory order = hashToOrder[_orderHash];
2147         
2148         if(!Account(order.account).isUser(signer)){
2149             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2150             return;
2151         }
2152 
2153         if(ERC20(order.principalToken).balanceOf(order.account) < _value){
2154             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","INSUFFICIENT_BALANCE_IN_ACCOUNT");
2155             return;
2156         }
2157 
2158         uint profits = sub(div(mul(order.principalAmount, order.premium), WAD), order.fee);
2159         uint valueToRepay = add(order.principalAmount, profits);
2160 
2161         if(valueToRepay > _value){
2162             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","INSUFFICIENT_REPAYMENT");
2163             return;
2164         }
2165 
2166         escrow.transferFromAccount(order.account, order.principalToken, feeWallet, order.fee);
2167         reserve.lock(order.principalToken, order.account, valueToRepay, profits, 0);
2168         escrow.transfer(order.collateralToken, order.account, order.collateralAmount);
2169 
2170         isRepaid[order.orderHash] = true;
2171 
2172         emit LogOrderRepaid(
2173             order.orderHash,
2174             _value
2175         );
2176     }
2177 
2178     function process
2179     (
2180         bytes32 _orderHash,
2181         uint _principalPerCollateral // in WAD
2182     )
2183         external
2184         note
2185         onlyAdmin
2186     {   
2187         if(!isOrder[_orderHash]){
2188             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_DOES_NOT_EXIST");
2189             return;
2190         }
2191 
2192         if(isRepaid[_orderHash]){
2193             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_ALREADY_REPAID");
2194             return;
2195         }
2196 
2197         if(isDefaulted[_orderHash]){
2198             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_ALREADY_DEFAULTED");
2199             return;
2200         }
2201 
2202         Order memory order = hashToOrder[_orderHash];
2203 
2204         bool isDefault = false;
2205         string memory reason = "";
2206 
2207         if(now > order.expirationTimestamp) {
2208             isDefault = true;
2209             reason = "DUE_DATE_PASSED";
2210         } else if (!_isCollateralizationSafe(order, _principalPerCollateral)) {
2211             isDefault = true;
2212             reason = "COLLATERAL_UNSAFE";
2213         }
2214 
2215         isDefaulted[_orderHash] = isDefault;
2216 
2217         if(isDefault) {
2218             if (!kyberConnector.isTradeFeasible(
2219                     ERC20(order.collateralToken), 
2220                     ERC20(order.principalToken),
2221                     order.collateralAmount)
2222                 )
2223             {
2224                 reserve.lockSurplus(
2225                     escrow,
2226                     order.principalToken,
2227                     order.collateralToken,
2228                     order.collateralAmount
2229                 );
2230                 
2231             } else {
2232                 _performLiquidation(order);
2233             }
2234             
2235             emit LogOrderDefaulted(order.orderHash, reason);
2236         }
2237 
2238     }
2239 
2240     function _performLiquidation(Order _order) 
2241         internal
2242     {
2243         uint premiumValue = div(mul(_order.principalAmount, _order.premium), WAD);
2244         uint valueToRepay = add(_order.principalAmount, premiumValue);
2245 
2246         uint principalFromCollateral;
2247         uint collateralLeft;
2248         
2249         (principalFromCollateral, collateralLeft) = kyberConnector.trade(
2250             escrow,
2251             ERC20(_order.collateralToken), 
2252             ERC20(_order.principalToken),
2253             _order.collateralAmount,
2254             valueToRepay
2255         );
2256 
2257         if (principalFromCollateral >= valueToRepay) {
2258             escrow.transfer(_order.principalToken, feeWallet, _order.fee);
2259 
2260             reserve.lock(
2261                 _order.principalToken,
2262                 escrow,
2263                 sub(principalFromCollateral, _order.fee),
2264                 sub(sub(principalFromCollateral,_order.principalAmount), _order.fee),
2265                 0
2266             );
2267 
2268             escrow.transfer(_order.collateralToken, _order.account, collateralLeft);
2269 
2270         } else if((principalFromCollateral < valueToRepay) && (principalFromCollateral >= _order.principalAmount)) {
2271             reserve.lock(
2272                 _order.principalToken,
2273                 escrow,
2274                 principalFromCollateral,
2275                 sub(principalFromCollateral, _order.principalAmount),
2276                 0
2277             );
2278 
2279         } else {
2280             reserve.lock(
2281                 _order.principalToken,
2282                 escrow,
2283                 principalFromCollateral,
2284                 0,
2285                 sub(_order.principalAmount, principalFromCollateral)
2286             );
2287 
2288         }
2289     }
2290 
2291     function _isCollateralizationSafe(Order _order, uint _principalPerCollateral)
2292         internal 
2293         pure
2294         returns (bool)
2295     {
2296         uint totalCollateralValueInPrincipal = div(
2297             mul(_order.collateralAmount, _principalPerCollateral),
2298             WAD);
2299         
2300         uint premiumValue = div(mul(_order.principalAmount, _order.premium), WAD);
2301         uint premiumValueBuffer = div(mul(premiumValue, 3), 100); 
2302         uint valueToRepay = add(add(_order.principalAmount, premiumValue), premiumValueBuffer);
2303 
2304         if (totalCollateralValueInPrincipal < valueToRepay) {
2305             return false;
2306         }
2307 
2308         return true;
2309     }
2310 
2311     function _generateRepayOrderHash
2312     (
2313         bytes32 _orderHash,
2314         uint _value
2315     )
2316         internal
2317         pure //view
2318         returns (bytes32 _repayOrderHash)
2319     {
2320         return keccak256(
2321             abi.encodePacked(
2322                 //address(this),
2323                 _orderHash,
2324                 _value
2325             )
2326         );
2327     }
2328 
2329     function _isOrderValid(Order _order)
2330         internal
2331         view
2332         returns (bool)
2333     {
2334         if(_order.account == address(0) || _order.byUser == address(0) 
2335          || _order.principalToken == address(0) || _order.collateralToken == address(0) 
2336          || (_order.collateralToken == _order.principalToken)
2337          || _order.principalAmount <= 0 || _order.collateralAmount <= 0
2338          || _order.premium <= 0
2339          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
2340             return false;
2341         }
2342 
2343         return true;
2344     }
2345 
2346     function _composeOrder
2347     (
2348         address[4] _orderAddresses,
2349         uint[6] _orderValues
2350     )
2351         internal
2352         view
2353         returns (Order _order)
2354     {
2355         Order memory order = Order({
2356             account: _orderAddresses[0], 
2357             byUser: _orderAddresses[1],
2358             principalToken: _orderAddresses[2],
2359             collateralToken: _orderAddresses[3],
2360             principalAmount: _orderValues[0],
2361             collateralAmount: _orderValues[1],
2362             premium: _orderValues[2],
2363             duration: _orderValues[3],
2364             expirationTimestamp: add(now, _orderValues[3]),
2365             salt: _orderValues[4],
2366             fee: _orderValues[5],
2367             createdTimestamp: now,
2368             orderHash: bytes32(0)
2369         });
2370 
2371         order.orderHash = _generateOrderHash(order);
2372     
2373         return order;
2374     }
2375 
2376     function _generateOrderHash(Order _order)
2377         internal
2378         pure //view
2379         returns (bytes32 _orderHash)
2380     {
2381         return keccak256(
2382             abi.encodePacked(
2383                 //address(this),
2384                 _order.account,
2385                 _order.principalToken,
2386                 _order.collateralToken,
2387                 _order.principalAmount,
2388                 _order.collateralAmount,
2389                 _order.premium,
2390                 _order.duration,
2391                 _order.salt,
2392                 _order.fee
2393             )
2394         );
2395     }
2396 
2397     function getAllOrders()
2398         public 
2399         view
2400         returns 
2401         (
2402             bytes32[]
2403         )
2404     {
2405         return orders;
2406     }
2407 
2408     function getOrder(bytes32 _orderHash)
2409         public 
2410         view 
2411         returns 
2412         (
2413             address _account,
2414             address _byUser,
2415             address _principalToken,
2416             address _collateralToken,
2417             uint _principalAmount,
2418             uint _collateralAmount,
2419             uint _premium,
2420             uint _expirationTimestamp,
2421             uint _salt,
2422             uint _fee,
2423             uint _createdTimestamp
2424         )
2425     {   
2426         Order memory order = hashToOrder[_orderHash];
2427         return (
2428             order.account,
2429             order.byUser,
2430             order.principalToken,
2431             order.collateralToken,
2432             order.principalAmount,
2433             order.collateralAmount,
2434             order.premium,
2435             order.expirationTimestamp,
2436             order.salt,
2437             order.fee,
2438             order.createdTimestamp
2439         );
2440     }
2441 
2442     function getOrdersForAccount(address _account) 
2443         public
2444         view 
2445         returns
2446         (
2447             bytes32[]
2448         )
2449     {
2450         return accountToOrders[_account];
2451     }
2452 
2453 }