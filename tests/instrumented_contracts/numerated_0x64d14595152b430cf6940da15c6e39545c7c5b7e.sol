1 pragma solidity 0.4.24;
2 
3 contract Utils {
4 
5     modifier addressValid(address _address) {
6         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
7         _;
8     }
9 
10 }
11 
12 contract DSAuthority {
13     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
14 }
15 
16 
17 contract DSAuthEvents {
18     event LogSetAuthority (address indexed authority);
19     event LogSetOwner     (address indexed owner);
20 }
21 
22 
23 contract DSAuth is DSAuthEvents {
24     DSAuthority  public  authority;
25     address      public  owner;
26 
27     constructor() public {
28         owner = msg.sender;
29         emit LogSetOwner(msg.sender);
30     }
31 
32     function setOwner(address owner_)
33         public
34         auth
35     {
36         owner = owner_;
37         emit LogSetOwner(owner);
38     }
39 
40     function setAuthority(DSAuthority authority_)
41         public
42         auth
43     {
44         authority = authority_;
45         emit LogSetAuthority(authority);
46     }
47 
48     modifier auth {
49         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
50         _;
51     }
52 
53     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
54         if (src == address(this)) {
55             return true;
56         } else if (src == owner) {
57             return true;
58         } else if (authority == DSAuthority(0)) {
59             return false;
60         } else {
61             return authority.canCall(src, this, sig);
62         }
63     }
64 }
65 
66 
67 contract DateTime {
68     struct _DateTime {
69         uint16 year;
70         uint8 month;
71         uint8 day;
72         uint8 hour;
73         uint8 minute;
74         uint8 second;
75         uint8 weekday;
76     }
77 
78     uint constant DAY_IN_SECONDS = 86400;
79     uint constant YEAR_IN_SECONDS = 31536000;
80     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
81 
82     uint constant HOUR_IN_SECONDS = 3600;
83     uint constant MINUTE_IN_SECONDS = 60;
84 
85     uint16 constant ORIGIN_YEAR = 1970;
86 
87     function isLeapYear(uint16 year) public pure returns (bool) {
88         if (year % 4 != 0) {
89             return false;
90         }
91         if (year % 100 != 0) {
92             return true;
93         }
94         if (year % 400 != 0) {
95             return false;
96         }
97         return true;
98     }
99 
100     function leapYearsBefore(uint year) public pure returns (uint) {
101         year -= 1;
102         return year / 4 - year / 100 + year / 400;
103     }
104 
105     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
106         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
107             return 31;
108         }
109         else if (month == 4 || month == 6 || month == 9 || month == 11) {
110             return 30;
111         }
112         else if (isLeapYear(year)) {
113             return 29;
114         }
115         else {
116             return 28;
117         }
118     }
119 
120     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
121         uint secondsAccountedFor = 0;
122         uint buf;
123         uint8 i;
124 
125         // Year
126         dt.year = getYear(timestamp);
127         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
128 
129         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
130         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
131 
132         // Month
133         uint secondsInMonth;
134         for (i = 1; i <= 12; i++) {
135             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
136             if (secondsInMonth + secondsAccountedFor > timestamp) {
137                 dt.month = i;
138                 break;
139             }
140             secondsAccountedFor += secondsInMonth;
141         }
142 
143         // Day
144         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
145             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
146                 dt.day = i;
147                 break;
148             }
149             secondsAccountedFor += DAY_IN_SECONDS;
150         }
151 
152         // Hour
153         dt.hour = getHour(timestamp);
154 
155         // Minute
156         dt.minute = getMinute(timestamp);
157 
158         // Second
159         dt.second = getSecond(timestamp);
160 
161         // Day of week.
162         dt.weekday = getWeekday(timestamp);
163     }
164 
165     function getYear(uint timestamp) public pure returns (uint16) {
166         uint secondsAccountedFor = 0;
167         uint16 year;
168         uint numLeapYears;
169 
170         // Year
171         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
172         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
173 
174         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
175         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
176 
177         while (secondsAccountedFor > timestamp) {
178             if (isLeapYear(uint16(year - 1))) {
179                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
180             }
181             else {
182                 secondsAccountedFor -= YEAR_IN_SECONDS;
183             }
184             year -= 1;
185         }
186         return year;
187     }
188 
189     function getMonth(uint timestamp) public pure returns (uint8) {
190         return parseTimestamp(timestamp).month;
191     }
192 
193     function getDay(uint timestamp) public pure returns (uint8) {
194         return parseTimestamp(timestamp).day;
195     }
196 
197     function getHour(uint timestamp) public pure returns (uint8) {
198         return uint8((timestamp / 60 / 60) % 24);
199     }
200 
201     function getMinute(uint timestamp) public pure returns (uint8) {
202         return uint8((timestamp / 60) % 60);
203     }
204 
205     function getSecond(uint timestamp) public pure returns (uint8) {
206         return uint8(timestamp % 60);
207     }
208 
209     function getWeekday(uint timestamp) public pure returns (uint8) {
210         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
211     }
212 
213     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
214         return toTimestamp(year, month, day, 0, 0, 0);
215     }
216 
217     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
218         return toTimestamp(year, month, day, hour, 0, 0);
219     }
220 
221     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
222         return toTimestamp(year, month, day, hour, minute, 0);
223     }
224 
225     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
226         uint16 i;
227 
228         // Year
229         for (i = ORIGIN_YEAR; i < year; i++) {
230             if (isLeapYear(i)) {
231                 timestamp += LEAP_YEAR_IN_SECONDS;
232             }
233             else {
234                 timestamp += YEAR_IN_SECONDS;
235             }
236         }
237 
238         // Month
239         uint8[12] memory monthDayCounts;
240         monthDayCounts[0] = 31;
241         if (isLeapYear(year)) {
242             monthDayCounts[1] = 29;
243         }
244         else {
245             monthDayCounts[1] = 28;
246         }
247         monthDayCounts[2] = 31;
248         monthDayCounts[3] = 30;
249         monthDayCounts[4] = 31;
250         monthDayCounts[5] = 30;
251         monthDayCounts[6] = 31;
252         monthDayCounts[7] = 31;
253         monthDayCounts[8] = 30;
254         monthDayCounts[9] = 31;
255         monthDayCounts[10] = 30;
256         monthDayCounts[11] = 31;
257 
258         for (i = 1; i < month; i++) {
259             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
260         }
261 
262         // Day
263         timestamp += DAY_IN_SECONDS * (day - 1);
264 
265         // Hour
266         timestamp += HOUR_IN_SECONDS * (hour);
267 
268         // Minute
269         timestamp += MINUTE_IN_SECONDS * (minute);
270 
271         // Second
272         timestamp += second;
273 
274         return timestamp;
275     }
276 }
277 
278 
279 contract MasterCopy {
280     address masterCopy;
281 
282     function changeMasterCopy(address _masterCopy)
283         public
284     {
285         require(_masterCopy != 0, "Invalid master copy address provided");
286         masterCopy = _masterCopy;
287     }
288 }
289 
290 contract Proxy {
291 
292     address masterCopy;
293 
294     constructor(address _masterCopy)
295         public
296     {
297         require(_masterCopy != 0, "Invalid master copy address provided");
298         masterCopy = _masterCopy;
299     }
300 
301     function ()
302         external
303         payable
304     {
305         // solium-disable-next-line security/no-inline-assembly
306         assembly {
307             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
308             calldatacopy(0, 0, calldatasize())
309             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
310             returndatacopy(0, 0, returndatasize())
311             if eq(success, 0) { revert(0, returndatasize()) }
312             return(0, returndatasize())
313         }
314     }
315 
316     function implementation()
317         public
318         view
319         returns (address)
320     {
321         return masterCopy;
322     }
323 
324     function proxyType()
325         public
326         pure
327         returns (uint256)
328     {
329         return 2;
330     }
331 }
332 
333 contract ErrorUtils {
334 
335     event LogError(string methodSig, string errMsg);
336     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
337     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
338 
339 }
340 
341 
342 contract DSNote {
343     event LogNote(
344         bytes4   indexed  sig,
345         address  indexed  guy,
346         bytes32  indexed  foo,
347         bytes32  indexed  bar,
348         uint              wad,
349         bytes             fax
350     ) anonymous;
351 
352     modifier note {
353         bytes32 foo;
354         bytes32 bar;
355 
356         assembly {
357             foo := calldataload(4)
358             bar := calldataload(36)
359         }
360 
361         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
362 
363         _;
364     }
365 }
366 
367 
368 interface ERC20 {
369 
370     function name() public view returns(string);
371     function symbol() public view returns(string);
372     function decimals() public view returns(uint8);
373     function totalSupply() public view returns (uint);
374 
375     function balanceOf(address tokenOwner) public view returns (uint balance);
376     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
377     function transfer(address to, uint tokens) public returns (bool success);
378     function approve(address spender, uint tokens) public returns (bool success);
379     function transferFrom(address from, address to, uint tokens) public returns (bool success);
380 
381     event Transfer(address indexed from, address indexed to, uint tokens);
382     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
383 }
384 
385 
386 contract DSMath {
387     function add(uint x, uint y) internal pure returns (uint z) {
388         require((z = x + y) >= x);
389     }
390     function sub(uint x, uint y) internal pure returns (uint z) {
391         require((z = x - y) <= x);
392     }
393     function mul(uint x, uint y) internal pure returns (uint z) {
394         require(y == 0 || (z = x * y) / y == x);
395     }
396 
397     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
398     function div(uint x, uint y) internal pure returns (uint z) {
399         z = x / y;
400     }
401 
402     function min(uint x, uint y) internal pure returns (uint z) {
403         return x <= y ? x : y;
404     }
405     function max(uint x, uint y) internal pure returns (uint z) {
406         return x >= y ? x : y;
407     }
408     function imin(int x, int y) internal pure returns (int z) {
409         return x <= y ? x : y;
410     }
411     function imax(int x, int y) internal pure returns (int z) {
412         return x >= y ? x : y;
413     }
414 
415     uint constant WAD = 10 ** 18;
416     uint constant RAY = 10 ** 27;
417 
418     function wmul(uint x, uint y) internal pure returns (uint z) {
419         z = add(mul(x, y), WAD / 2) / WAD;
420     }
421     function rmul(uint x, uint y) internal pure returns (uint z) {
422         z = add(mul(x, y), RAY / 2) / RAY;
423     }
424     function wdiv(uint x, uint y) internal pure returns (uint z) {
425         z = add(mul(x, WAD), y / 2) / y;
426     }
427     function rdiv(uint x, uint y) internal pure returns (uint z) {
428         z = add(mul(x, RAY), y / 2) / y;
429     }
430 
431     // This famous algorithm is called "exponentiation by squaring"
432     // and calculates x^n with x as fixed-point and n as regular unsigned.
433     //
434     // It's O(log n), instead of O(n) for naive repeated multiplication.
435     //
436     // These facts are why it works:
437     //
438     //  If n is even, then x^n = (x^2)^(n/2).
439     //  If n is odd,  then x^n = x * x^(n-1),
440     //   and applying the equation for even x gives
441     //    x^n = x * (x^2)^((n-1) / 2).
442     //
443     //  Also, EVM division is flooring and
444     //    floor[(n-1) / 2] = floor[n / 2].
445     //
446     function rpow(uint x, uint n) internal pure returns (uint z) {
447         z = n % 2 != 0 ? x : RAY;
448 
449         for (n /= 2; n != 0; n /= 2) {
450             x = rmul(x, x);
451 
452             if (n % 2 != 0) {
453                 z = rmul(z, x);
454             }
455         }
456     }
457 }
458 
459 
460 contract WETH9 {
461     string public name     = "Wrapped Ether";
462     string public symbol   = "WETH";
463     uint8  public decimals = 18;
464 
465     event  Approval(address indexed _owner, address indexed _spender, uint _value);
466     event  Transfer(address indexed _from, address indexed _to, uint _value);
467     event  Deposit(address indexed _owner, uint _value);
468     event  Withdrawal(address indexed _owner, uint _value);
469 
470     mapping (address => uint)                       public  balanceOf;
471     mapping (address => mapping (address => uint))  public  allowance;
472 
473     function() public payable {
474         deposit();
475     }
476 
477     function deposit() public payable {
478         balanceOf[msg.sender] += msg.value;
479         Deposit(msg.sender, msg.value);
480     }
481 
482     function withdraw(uint wad) public {
483         require(balanceOf[msg.sender] >= wad);
484         balanceOf[msg.sender] -= wad;
485         msg.sender.transfer(wad);
486         Withdrawal(msg.sender, wad);
487     }
488 
489     function totalSupply() public view returns (uint) {
490         return this.balance;
491     }
492 
493     function approve(address guy, uint wad) public returns (bool) {
494         allowance[msg.sender][guy] = wad;
495         Approval(msg.sender, guy, wad);
496         return true;
497     }
498 
499     function transfer(address dst, uint wad) public returns (bool) {
500         return transferFrom(msg.sender, dst, wad);
501     }
502 
503     function transferFrom(address src, address dst, uint wad)
504         public
505         returns (bool)
506     {
507         require(balanceOf[src] >= wad);
508 
509         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
510             require(allowance[src][msg.sender] >= wad);
511             allowance[src][msg.sender] -= wad;
512         }
513 
514         balanceOf[src] -= wad;
515         balanceOf[dst] += wad;
516 
517         Transfer(src, dst, wad);
518 
519         return true;
520     }
521 }
522 
523 
524 contract DSStop is DSNote, DSAuth {
525 
526     bool public stopped = false;
527 
528     modifier whenNotStopped {
529         require(!stopped, "DSStop::_ FEATURE_STOPPED");
530         _;
531     }
532 
533     modifier whenStopped {
534         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
535         _;
536     }
537 
538     function stop() public auth note {
539         stopped = true;
540     }
541     function start() public auth note {
542         stopped = false;
543     }
544 
545 }
546 
547 
548 library ECRecovery {
549 
550     function recover(bytes32 _hash, bytes _sig)
551         internal
552         pure
553     returns (address)
554     {
555         bytes32 r;
556         bytes32 s;
557         uint8 v;
558 
559         if (_sig.length != 65) {
560             return (address(0));
561         }
562 
563         assembly {
564             r := mload(add(_sig, 32))
565             s := mload(add(_sig, 64))
566             v := byte(0, mload(add(_sig, 96)))
567         }
568 
569         if (v < 27) {
570             v += 27;
571         }
572 
573         if (v != 27 && v != 28) {
574             return (address(0));
575         } else {
576             return ecrecover(_hash, v, r, s);
577         }
578     }
579 
580     function toEthSignedMessageHash(bytes32 _hash)
581         internal
582         pure
583     returns (bytes32)
584     {
585         return keccak256(
586             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
587         );
588     }
589 }
590 
591 
592 contract Utils2 {
593     using ECRecovery for bytes32;
594     
595     function _recoverSigner(bytes32 _hash, bytes _signature) 
596         internal
597         pure
598         returns(address _signer)
599     {
600         return _hash.toEthSignedMessageHash().recover(_signature);
601     }
602 
603 }
604 
605 
606 contract Config is DSNote, DSAuth, Utils {
607 
608     WETH9 public weth9;
609     mapping (address => bool) public isAccountHandler;
610     mapping (address => bool) public isAdmin;
611     address[] public admins;
612     bool public disableAdminControl = false;
613     
614     event LogAdminAdded(address indexed _admin, address _by);
615     event LogAdminRemoved(address indexed _admin, address _by);
616 
617     constructor() public {
618         admins.push(msg.sender);
619         isAdmin[msg.sender] = true;
620     }
621 
622     modifier onlyAdmin(){
623         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
624         _;
625     }
626 
627     function setWETH9
628     (
629         address _weth9
630     ) 
631         public
632         auth
633         note
634         addressValid(_weth9) 
635     {
636         weth9 = WETH9(_weth9);
637     }
638 
639     function setAccountHandler
640     (
641         address _accountHandler,
642         bool _isAccountHandler
643     )
644         public
645         auth
646         note
647         addressValid(_accountHandler)
648     {
649         isAccountHandler[_accountHandler] = _isAccountHandler;
650     }
651 
652     function toggleAdminsControl() 
653         public
654         auth
655         note
656     {
657         disableAdminControl = !disableAdminControl;
658     }
659 
660     function isAdminValid(address _admin)
661         public
662         view
663         returns (bool)
664     {
665         if(disableAdminControl) {
666             return true;
667         } else {
668             return isAdmin[_admin];
669         }
670     }
671 
672     function getAllAdmins()
673         public
674         view
675         returns(address[])
676     {
677         return admins;
678     }
679 
680     function addAdmin
681     (
682         address _admin
683     )
684         external
685         note
686         onlyAdmin
687         addressValid(_admin)
688     {   
689         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
690 
691         admins.push(_admin);
692         isAdmin[_admin] = true;
693 
694         emit LogAdminAdded(_admin, msg.sender);
695     }
696 
697     function removeAdmin
698     (
699         address _admin
700     ) 
701         external
702         note
703         onlyAdmin
704         addressValid(_admin)
705     {   
706         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
707         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
708 
709         isAdmin[_admin] = false;
710 
711         for (uint i = 0; i < admins.length - 1; i++) {
712             if (admins[i] == _admin) {
713                 admins[i] = admins[admins.length - 1];
714                 admins.length -= 1;
715                 break;
716             }
717         }
718 
719         emit LogAdminRemoved(_admin, msg.sender);
720     }
721 }
722 
723 
724 contract DSThing is DSNote, DSAuth, DSMath {
725 
726     function S(string s) internal pure returns (bytes4) {
727         return bytes4(keccak256(s));
728     }
729 
730 }
731 
732 
733 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
734 
735     address[] public users;
736     mapping (address => bool) public isUser;
737     mapping (bytes32 => bool) public actionCompleted;
738 
739     WETH9 public weth9;
740     Config public config;
741     bool public isInitialized = false;
742 
743     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
744     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
745     event LogUserAdded(address indexed user, address by);
746     event LogUserRemoved(address indexed user, address by);
747 
748     modifier initialized() {
749         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
750         _;
751     }
752 
753     modifier userExists(address _user) {
754         require(isUser[_user], "Account::_ INVALID_USER");
755         _;
756     }
757 
758     modifier userDoesNotExist(address _user) {
759         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
760         _;
761     }
762 
763     modifier onlyHandler(){
764         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
765         _;
766     }
767 
768     function init(address _user, address _config) public {
769         users.push(_user);
770         isUser[_user] = true;
771         config = Config(_config);
772         weth9 = config.weth9();
773         isInitialized = true;
774     }
775     
776     function getAllUsers() public view returns (address[]) {
777         return users;
778     }
779 
780     function balanceFor(address _token) public view returns (uint _balance){
781         _balance = ERC20(_token).balanceOf(this);
782     }
783     
784     function transferBySystem
785     (   
786         address _token,
787         address _to,
788         uint _value
789     ) 
790         external 
791         onlyHandler
792         note 
793         initialized
794     {
795         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
796         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
797 
798         emit LogTransferBySystem(_token, _to, _value, msg.sender);
799     }
800     
801     function transferByUser
802     (   
803         address _token,
804         address _to,
805         uint _value,
806         uint _salt,
807         bytes _signature
808     ) 
809         external
810         addressValid(_to)
811         note
812         initialized
813     {
814         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
815 
816         if(actionCompleted[actionHash]) {
817             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
818             return;
819         }
820 
821         if(ERC20(_token).balanceOf(this) < _value){
822             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
823             return;
824         }
825 
826         address signer = _recoverSigner(actionHash, _signature);
827 
828         if(!isUser[signer]) {
829             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
830             return;
831         }
832 
833         actionCompleted[actionHash] = true;
834         
835         if (_token == address(weth9)) {
836             weth9.withdraw(_value);
837             _to.transfer(_value);
838         } else {
839             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
840         }
841 
842         emit LogTransferByUser(_token, _to, _value, signer);
843     }
844 
845     function addUser
846     (
847         address _user,
848         uint _salt,
849         bytes _signature
850     )
851         external 
852         note 
853         addressValid(_user)
854         userDoesNotExist(_user)
855         initialized
856     {   
857         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
858         if(actionCompleted[actionHash])
859         {
860             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
861             return;
862         }
863 
864         address signer = _recoverSigner(actionHash, _signature);
865 
866         if(!isUser[signer]) {
867             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
868             return;
869         }
870 
871         actionCompleted[actionHash] = true;
872 
873         users.push(_user);
874         isUser[_user] = true;
875 
876         emit LogUserAdded(_user, signer);
877     }
878 
879     function removeUser
880     (
881         address _user,
882         uint _salt,
883         bytes _signature
884     ) 
885         external
886         note
887         userExists(_user) 
888         initialized
889     {   
890         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
891 
892         if(actionCompleted[actionHash]) {
893             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
894             return;
895         }
896 
897         address signer = _recoverSigner(actionHash, _signature);
898         
899         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
900         if(!isUser[signer]){
901             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
902             return;
903         }
904         
905         actionCompleted[actionHash] = true;
906 
907         // should delete value from isUser map? delete isUser[_user]?
908         isUser[_user] = false;
909         for (uint i = 0; i < users.length - 1; i++) {
910             if (users[i] == _user) {
911                 users[i] = users[users.length - 1];
912                 users.length -= 1;
913                 break;
914             }
915         }
916 
917         emit LogUserRemoved(_user, signer);
918     }
919 
920     function _getTransferActionHash
921     ( 
922         address _token,
923         address _to,
924         uint _value,
925         uint _salt
926     ) 
927         internal
928         view
929         returns (bytes32)
930     {
931         return keccak256(
932             abi.encodePacked(
933                 address(this),
934                 _token,
935                 _to,
936                 _value,
937                 _salt
938             )
939         );
940     }
941 
942     function _getUserActionHash
943     ( 
944         address _user,
945         string _action,
946         uint _salt
947     ) 
948         internal
949         view
950         returns (bytes32)
951     {
952         return keccak256(
953             abi.encodePacked(
954                 address(this),
955                 _user,
956                 _action,
957                 _salt
958             )
959         );
960     }
961 
962     // to directly send ether to contract
963     function() external payable {
964         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
965 
966         if(msg.sender != address(weth9)){
967             weth9.deposit.value(msg.value)();
968         }
969     }
970     
971 }
972 
973 
974 contract AccountFactory is DSStop, Utils {
975     Config public config;
976     mapping (address => bool) public isAccount;
977     mapping (address => address[]) public userToAccounts;
978     address[] public accounts;
979 
980     address public accountMaster;
981 
982     constructor
983     (
984         Config _config, 
985         address _accountMaster
986     ) 
987     public 
988     {
989         config = _config;
990         accountMaster = _accountMaster;
991     }
992 
993     event LogAccountCreated(address indexed user, address indexed account, address by);
994 
995     modifier onlyAdmin() {
996         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
997         _;
998     }
999 
1000     function setConfig(Config _config) external note auth addressValid(_config) {
1001         config = _config;
1002     }
1003 
1004     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
1005         accountMaster = _accountMaster;
1006     }
1007 
1008     function newAccount(address _user)
1009         public
1010         note
1011         onlyAdmin
1012         addressValid(config)
1013         addressValid(accountMaster)
1014         whenNotStopped
1015         returns 
1016         (
1017             Account _account
1018         ) 
1019     {
1020         address proxy = new Proxy(accountMaster);
1021         _account = Account(proxy);
1022         _account.init(_user, config);
1023 
1024         accounts.push(_account);
1025         userToAccounts[_user].push(_account);
1026         isAccount[_account] = true;
1027 
1028         emit LogAccountCreated(_user, _account, msg.sender);
1029     }
1030     
1031     function batchNewAccount(address[] _users) public note onlyAdmin {
1032         for (uint i = 0; i < _users.length; i++) {
1033             newAccount(_users[i]);
1034         }
1035     }
1036 
1037     function getAllAccounts() public view returns (address[]) {
1038         return accounts;
1039     }
1040 
1041     function getAccountsForUser(address _user) public view returns (address[]) {
1042         return userToAccounts[_user];
1043     }
1044 
1045 }
1046 
1047 
1048 contract Escrow is DSNote, DSAuth {
1049 
1050     event LogTransfer(address indexed token, address indexed to, uint value);
1051     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
1052 
1053     function transfer
1054     (
1055         address _token,
1056         address _to,
1057         uint _value
1058     )
1059         public
1060         note
1061         auth
1062     {
1063         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
1064         emit LogTransfer(_token, _to, _value);
1065     }
1066 
1067     function transferFromAccount
1068     (
1069         address _account,
1070         address _token,
1071         address _to,
1072         uint _value
1073     )
1074         public
1075         note
1076         auth
1077     {   
1078         Account(_account).transferBySystem(_token, _to, _value);
1079         emit LogTransferFromAccount(_account, _token, _to, _value);
1080     }
1081 
1082 }
1083 
1084 
1085 contract Reserve is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1086 
1087     Escrow public escrow;
1088     AccountFactory public accountFactory;
1089     DateTime public dateTime;
1090     Config public config;
1091     uint public deployTimestamp;
1092 
1093     string constant public VERSION = "1.0.0";
1094 
1095     uint public TIME_INTERVAL = 1 days;
1096     
1097     constructor
1098     (
1099         Escrow _escrow,
1100         AccountFactory _accountFactory,
1101         DateTime _dateTime,
1102         Config _config
1103     ) 
1104     public 
1105     {
1106         escrow = _escrow;
1107         accountFactory = _accountFactory;
1108         dateTime = _dateTime;
1109         config = _config;
1110         deployTimestamp = now - (4 * TIME_INTERVAL);
1111     }
1112 
1113     function setEscrow(Escrow _escrow) 
1114         public 
1115         note 
1116         auth
1117         addressValid(_escrow)
1118     {
1119         escrow = _escrow;
1120     }
1121 
1122     function setAccountFactory(AccountFactory _accountFactory) 
1123         public 
1124         note 
1125         auth
1126         addressValid(_accountFactory)
1127     {
1128         accountFactory = _accountFactory;
1129     }
1130 
1131     function setDateTime(DateTime _dateTime) 
1132         public 
1133         note 
1134         auth
1135         addressValid(_dateTime)
1136     {
1137         dateTime = _dateTime;
1138     }
1139 
1140     function setConfig(Config _config) 
1141         public 
1142         note 
1143         auth
1144         addressValid(_config)
1145     {
1146         config = _config;
1147     }
1148 
1149     struct Order {
1150         address account;
1151         address token;
1152         address byUser;
1153         uint value;
1154         uint duration;
1155         uint expirationTimestamp;
1156         uint salt;
1157         uint createdTimestamp;
1158         bytes32 orderHash;
1159     }
1160 
1161     bytes32[] public orders;
1162     mapping (bytes32 => Order) public hashToOrder;
1163     mapping (bytes32 => bool) public isOrder;
1164     mapping (address => bytes32[]) public accountToOrders;
1165     mapping (bytes32 => bool) public cancelledOrders;
1166 
1167     // per day
1168     mapping (uint => mapping(address => uint)) public deposits;
1169     mapping (uint => mapping(address => uint)) public withdrawals;
1170     mapping (uint => mapping(address => uint)) public profits;
1171     mapping (uint => mapping(address => uint)) public losses;
1172 
1173     mapping (uint => mapping(address => uint)) public reserves;
1174     mapping (address => uint) public lastReserveRuns;
1175 
1176     mapping (address => mapping(address => uint)) surplus;
1177 
1178     mapping (bytes32 => CumulativeRun) public orderToCumulative;
1179 
1180     struct CumulativeRun {
1181         uint timestamp;
1182         uint value;
1183     }
1184 
1185     modifier onlyAdmin() {
1186         require(config.isAdminValid(msg.sender), "Reserve::_ INVALID_ADMIN_ACCOUNT");
1187         _;
1188     }
1189 
1190     event LogOrderCreated(
1191         bytes32 indexed orderHash,
1192         address indexed account,
1193         address indexed token,
1194         address byUser,
1195         uint value,
1196         uint expirationTimestamp
1197     );
1198 
1199     event LogOrderCancelled(
1200         bytes32 indexed orderHash,
1201         address indexed by
1202     );
1203 
1204     event LogReserveValuesUpdated(
1205         address indexed token, 
1206         uint indexed updatedTill,
1207         uint reserve,
1208         uint profit,
1209         uint loss
1210     );
1211 
1212     event LogOrderCumulativeUpdated(
1213         bytes32 indexed orderHash,
1214         uint updatedTill,
1215         uint value
1216     );
1217 
1218     event LogRelease(
1219         address indexed token,
1220         address indexed to,
1221         uint value,
1222         address by
1223     );
1224 
1225     event LogLock(
1226         address indexed token,
1227         address indexed from,
1228         uint value,
1229         uint profit,
1230         uint loss,
1231         address by
1232     );
1233 
1234     event LogLockSurplus(
1235         address indexed forToken, 
1236         address indexed token,
1237         address from,
1238         uint value
1239     );
1240 
1241     event LogTransferSurplus(
1242         address indexed forToken,
1243         address indexed token,
1244         address to, 
1245         uint value
1246     );
1247     
1248     function createOrder
1249     (
1250         address[3] _orderAddresses,
1251         uint[3] _orderValues,
1252         bytes _signature
1253     ) 
1254         public
1255         note
1256         onlyAdmin
1257         whenNotStopped
1258     {
1259         Order memory order = _composeOrder(_orderAddresses, _orderValues);
1260         address signer = _recoverSigner(order.orderHash, _signature);
1261 
1262         if(signer != order.byUser){
1263             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_ORDER_CREATOR");
1264             return;
1265         }
1266         
1267         if(isOrder[order.orderHash]){
1268             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "ORDER_ALREADY_EXISTS");
1269             return;
1270         }
1271 
1272         if(!accountFactory.isAccount(order.account)){
1273             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_ACCOUNT");
1274             return;
1275         }
1276 
1277         if(!Account(order.account).isUser(signer)){
1278             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1279             return;
1280         }
1281                 
1282         if(!_isOrderValid(order)) {
1283             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_PARAMETERS");
1284             return;
1285         }
1286 
1287         if(ERC20(order.token).balanceOf(order.account) < order.value){
1288             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
1289             return;
1290         }
1291 
1292         escrow.transferFromAccount(order.account, order.token, address(escrow), order.value);
1293         
1294         orders.push(order.orderHash);
1295         hashToOrder[order.orderHash] = order;
1296         isOrder[order.orderHash] = true;
1297         accountToOrders[order.account].push(order.orderHash);
1298 
1299         uint dateTimestamp = _getDateTimestamp(now);
1300 
1301         deposits[dateTimestamp][order.token] = add(deposits[dateTimestamp][order.token], order.value);
1302         
1303         orderToCumulative[order.orderHash].timestamp = _getDateTimestamp(order.createdTimestamp);
1304         orderToCumulative[order.orderHash].value = order.value;
1305 
1306         emit LogOrderCreated(
1307             order.orderHash,
1308             order.account,
1309             order.token,
1310             order.byUser,
1311             order.value,
1312             order.expirationTimestamp
1313         );
1314     }
1315 
1316     function cancelOrder
1317     (
1318         bytes32 _orderHash,
1319         bytes _signature
1320     )
1321         external
1322         note
1323         onlyAdmin
1324     {   
1325         if(!isOrder[_orderHash]) {
1326             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_DOES_NOT_EXIST");
1327             return;
1328         }
1329 
1330         if(cancelledOrders[_orderHash]){
1331             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_ALREADY_CANCELLED");
1332             return;
1333         }
1334 
1335         Order memory order = hashToOrder[_orderHash];
1336 
1337         bytes32 cancelOrderHash = _generateActionOrderHash(_orderHash, "CANCEL_RESERVE_ORDER");
1338         address signer = _recoverSigner(cancelOrderHash, _signature);
1339         
1340         if(!Account(order.account).isUser(signer)){
1341             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1342             return;
1343         }
1344         
1345         doCancelOrder(order);
1346     }
1347     
1348     function processOrder
1349     (
1350         bytes32 _orderHash
1351     ) 
1352         external 
1353         note
1354         onlyAdmin
1355     {
1356         if(!isOrder[_orderHash]) {
1357             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_DOES_NOT_EXIST");
1358             return;
1359         }
1360 
1361         if(cancelledOrders[_orderHash]){
1362             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_ALREADY_CANCELLED");
1363             return;
1364         }
1365 
1366         Order memory order = hashToOrder[_orderHash];
1367 
1368         if(now > _getDateTimestamp(order.expirationTimestamp)) {
1369             doCancelOrder(order);
1370         } else {
1371             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::processOrder", "ORDER_NOT_EXPIRED");
1372         }
1373     }
1374 
1375     function doCancelOrder(Order _order) 
1376         internal
1377     {   
1378         uint valueToTransfer = orderToCumulative[_order.orderHash].value;
1379 
1380         if(ERC20(_order.token).balanceOf(escrow) < valueToTransfer){
1381             emit LogErrorWithHintBytes32(_order.orderHash, "Reserve::doCancel", "INSUFFICIENT_BALANCE_IN_ESCROW");
1382             return;
1383         }
1384 
1385         uint nowDateTimestamp = _getDateTimestamp(now);
1386         cancelledOrders[_order.orderHash] = true;
1387         withdrawals[nowDateTimestamp][_order.token] = add(withdrawals[nowDateTimestamp][_order.token], valueToTransfer);
1388 
1389         escrow.transfer(_order.token, _order.account, valueToTransfer);
1390         emit LogOrderCancelled(_order.orderHash, msg.sender);
1391     }
1392 
1393     function release(address _token, address _to, uint _value) 
1394         external
1395         note
1396         auth
1397     {   
1398         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::release INSUFFICIENT_BALANCE_IN_ESCROW");
1399         escrow.transfer(_token, _to, _value);
1400         emit LogRelease(_token, _to, _value, msg.sender);
1401     }
1402 
1403     // _value includes profit/loss as well
1404     function lock(address _token, address _from, uint _value, uint _profit, uint _loss)
1405         external
1406         note
1407         auth
1408     {   
1409         require(!(_profit == 0 && _loss == 0), "Reserve::lock INVALID_PROFIT_LOSS_VALUES");
1410         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lock INSUFFICIENT_BALANCE");
1411             
1412         if(accountFactory.isAccount(_from)) {
1413             escrow.transferFromAccount(_from, _token, address(escrow), _value);
1414         } else {
1415             Escrow(_from).transfer(_token, address(escrow), _value);
1416         }
1417         
1418         uint dateTimestamp = _getDateTimestamp(now);
1419 
1420         if (_profit > 0){
1421             profits[dateTimestamp][_token] = add(profits[dateTimestamp][_token], _profit);
1422         } else if (_loss > 0) {
1423             losses[dateTimestamp][_token] = add(losses[dateTimestamp][_token], _loss);
1424         }
1425 
1426         emit LogLock(_token, _from, _value, _profit, _loss, msg.sender);
1427     }
1428 
1429     // to lock collateral if cannot be liquidated e.g. not enough reserves in kyber
1430     function lockSurplus(address _from, address _forToken, address _token, uint _value) 
1431         external
1432         note
1433         auth
1434     {
1435         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lockSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1436 
1437         Escrow(_from).transfer(_token, address(escrow), _value);
1438         surplus[_forToken][_token] = add(surplus[_forToken][_token], _value);
1439 
1440         emit LogLockSurplus(_forToken, _token, _from, _value);
1441     }
1442 
1443     // to transfer surplus collateral out of the system to trade on other platforms and put back in terms of 
1444     // principal to reserve manually using an account or surplus escrow
1445     // should work in tandem with lock method when transferring back principal
1446     function transferSurplus(address _to, address _forToken, address _token, uint _value) 
1447         external
1448         note
1449         auth
1450     {
1451         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::transferSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1452         require(surplus[_forToken][_token] >= _value, "Reserve::transferSurplus INSUFFICIENT_SURPLUS");
1453 
1454         surplus[_forToken][_token] = sub(surplus[_forToken][_token], _value);
1455         escrow.transfer(_token, _to, _value);
1456 
1457         emit LogTransferSurplus(_forToken, _token, _to, _value);
1458     }
1459 
1460     function updateReserveValues(address _token, uint _forDays)
1461         public
1462         note
1463         onlyAdmin
1464     {   
1465         uint lastReserveRun = lastReserveRuns[_token];
1466 
1467         if (lastReserveRun == 0) {
1468             lastReserveRun = _getDateTimestamp(deployTimestamp) - TIME_INTERVAL;
1469         }
1470 
1471         uint nowDateTimestamp = _getDateTimestamp(now);
1472         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastReserveRun) / TIME_INTERVAL;
1473 
1474         if(updatesLeft == 0) {
1475             emit LogErrorWithHintAddress(_token, "Reserve::updateReserveValues", "RESERVE_VALUES_UP_TO_DATE");
1476             return;
1477         }
1478 
1479         uint counter = updatesLeft;
1480 
1481         if(updatesLeft > _forDays && _forDays > 0) {
1482             counter = _forDays;
1483         }
1484 
1485         for (uint i = 0; i < counter; i++) {
1486             reserves[lastReserveRun + TIME_INTERVAL][_token] = sub(
1487                 sub(
1488                     add(
1489                         add(
1490                             reserves[lastReserveRun][_token],
1491                             deposits[lastReserveRun + TIME_INTERVAL][_token]
1492                         ),
1493                         profits[lastReserveRun + TIME_INTERVAL][_token]
1494                     ),
1495                     losses[lastReserveRun + TIME_INTERVAL][_token]
1496                 ),
1497                 withdrawals[lastReserveRun + TIME_INTERVAL][_token]
1498             );
1499             lastReserveRuns[_token] = lastReserveRun + TIME_INTERVAL;
1500             lastReserveRun = lastReserveRuns[_token];
1501             
1502             emit LogReserveValuesUpdated(
1503                 _token,
1504                 lastReserveRun,
1505                 reserves[lastReserveRun][_token],
1506                 profits[lastReserveRun][_token],
1507                 losses[lastReserveRun][_token]
1508             );
1509             
1510         }
1511     }
1512 
1513     function updateOrderCumulativeValueBatch(bytes32[] _orderHashes, uint[] _forDays) 
1514         public
1515         note
1516         onlyAdmin
1517     {   
1518         if(_orderHashes.length != _forDays.length) {
1519             emit LogError("Reserve::updateOrderCumulativeValueBatch", "ARGS_ARRAYLENGTH_MISMATCH");
1520             return;
1521         }
1522 
1523         for(uint i = 0; i < _orderHashes.length; i++) {
1524             updateOrderCumulativeValue(_orderHashes[i], _forDays[i]);
1525         }
1526     }
1527 
1528     function updateOrderCumulativeValue
1529     (
1530         bytes32 _orderHash, 
1531         uint _forDays
1532     ) 
1533         public
1534         note
1535         onlyAdmin 
1536     {
1537         if(!isOrder[_orderHash]) {
1538             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_DOES_NOT_EXIST");
1539             return;
1540         }
1541 
1542         if(cancelledOrders[_orderHash]) {
1543             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_ALREADY_CANCELLED");
1544             return;
1545         }
1546         
1547         Order memory order = hashToOrder[_orderHash];
1548         CumulativeRun storage cumulativeRun = orderToCumulative[_orderHash];
1549         
1550         uint profitsAccrued = 0;
1551         uint lossesAccrued = 0;
1552         uint cumulativeValue = 0;
1553         uint counter = 0;
1554 
1555         uint lastOrderRun = cumulativeRun.timestamp;
1556         uint nowDateTimestamp = _getDateTimestamp(now);
1557 
1558         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastOrderRun) / TIME_INTERVAL;
1559 
1560         if(updatesLeft == 0) {
1561             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_VALUES_UP_TO_DATE");
1562             return;
1563         }
1564 
1565         counter = updatesLeft;
1566 
1567         if(updatesLeft > _forDays && _forDays > 0) {
1568             counter = _forDays;
1569         }
1570 
1571         for (uint i = 0; i < counter; i++){
1572             cumulativeValue = cumulativeRun.value;
1573             lastOrderRun = cumulativeRun.timestamp;
1574 
1575             if(lastReserveRuns[order.token] < lastOrderRun) {
1576                 emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "RESERVE_VALUES_NOT_UPDATED");
1577                 emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1578                 return;
1579             }
1580 
1581             profitsAccrued = div(
1582                 mul(profits[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1583                 reserves[lastOrderRun][order.token]
1584             );
1585                 
1586             lossesAccrued = div(
1587                 mul(losses[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1588                 reserves[lastOrderRun][order.token]
1589             );
1590 
1591             cumulativeValue = sub(add(cumulativeValue, profitsAccrued), lossesAccrued);
1592 
1593             cumulativeRun.timestamp = lastOrderRun + TIME_INTERVAL;
1594             cumulativeRun.value = cumulativeValue;
1595         }
1596         
1597         emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1598     }
1599 
1600     function getAllOrders() 
1601         public
1602         view 
1603         returns 
1604         (
1605             bytes32[]
1606         ) 
1607     {
1608         return orders;
1609     }
1610 
1611     function getOrdersForAccount(address _account) 
1612         public
1613         view 
1614         returns 
1615         (
1616             bytes32[]
1617         )
1618     {
1619         return accountToOrders[_account];
1620     }
1621 
1622     function getOrder(bytes32 _orderHash)
1623         public 
1624         view 
1625         returns 
1626         (
1627             address _account,
1628             address _token,
1629             address _byUser,
1630             uint _value,
1631             uint _expirationTimestamp,
1632             uint _salt,
1633             uint _createdTimestamp
1634         )
1635     {   
1636         Order memory order = hashToOrder[_orderHash];
1637         return (
1638             order.account,
1639             order.token,
1640             order.byUser,
1641             order.value,
1642             order.expirationTimestamp,
1643             order.salt,
1644             order.createdTimestamp
1645         );
1646     }
1647 
1648     function _isOrderValid(Order _order)
1649         internal
1650         view
1651         returns (bool)
1652     {
1653         if(_order.account == address(0) || _order.byUser == address(0)
1654          || _order.value <= 0
1655          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
1656             return false;
1657         }
1658 
1659         if(isOrder[_order.orderHash]) {
1660             return false;
1661         }
1662 
1663         if(cancelledOrders[_order.orderHash]) {
1664             return false;
1665         }
1666 
1667         return true;
1668     }
1669 
1670     function _composeOrder(address[3] _orderAddresses, uint[3] _orderValues)
1671         internal
1672         view
1673         returns (Order _order)
1674     {
1675         Order memory order = Order({
1676             account: _orderAddresses[0],
1677             token: _orderAddresses[1],
1678             byUser: _orderAddresses[2],
1679             value: _orderValues[0],
1680             createdTimestamp: now,
1681             duration: _orderValues[1],
1682             expirationTimestamp: add(now, _orderValues[1]),
1683             salt: _orderValues[2],
1684             orderHash: bytes32(0)
1685         });
1686 
1687         order.orderHash = _generateCreateOrderHash(order);
1688 
1689         return order;
1690     }
1691 
1692     function _generateCreateOrderHash(Order _order)
1693         internal
1694         pure //view
1695         returns (bytes32 _orderHash)
1696     {
1697         return keccak256(
1698             abi.encodePacked(
1699  //              address(this),
1700                 _order.account,
1701                 _order.token,
1702                 _order.value,
1703                 _order.duration,
1704                 _order.salt
1705             )
1706         );
1707     }
1708 
1709     function _generateActionOrderHash
1710     (
1711         bytes32 _orderHash,
1712         string _action
1713     )
1714         internal
1715         pure //view
1716         returns (bytes32 _repayOrderHash)
1717     {
1718         return keccak256(
1719             abi.encodePacked(
1720 //                address(this),
1721                 _orderHash,
1722                 _action
1723             )
1724         );
1725     }
1726 
1727     function _getDateTimestamp(uint _timestamp) 
1728         internal
1729         view
1730         returns (uint)
1731     {
1732         return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp));
1733     } 
1734 
1735 }