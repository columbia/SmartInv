1 pragma solidity 0.4.24;
2 
3 contract DSAuthority {
4     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
5 }
6 
7 
8 contract DSAuthEvents {
9     event LogSetAuthority (address indexed authority);
10     event LogSetOwner     (address indexed owner);
11 }
12 
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 
58 contract Proxy {
59 
60     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
61     address masterCopy;
62 
63     /// @dev Constructor function sets address of master copy contract.
64     /// @param _masterCopy Master copy address.
65     constructor(address _masterCopy)
66         public
67     {
68         require(_masterCopy != 0, "Invalid master copy address provided");
69         masterCopy = _masterCopy;
70     }
71 
72     /// @dev Fallback function forwards all transactions and returns all received return data.
73     function ()
74         external
75         payable
76     {
77         // solium-disable-next-line security/no-inline-assembly
78         assembly {
79             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
80             calldatacopy(0, 0, calldatasize())
81             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
82             returndatacopy(0, 0, returndatasize())
83             if eq(success, 0) { revert(0, returndatasize()) }
84             return(0, returndatasize())
85         }
86     }
87 
88     function implementation()
89         public
90         view
91         returns (address)
92     {
93         return masterCopy;
94     }
95 
96     function proxyType()
97         public
98         pure
99         returns (uint256)
100     {
101         return 2;
102     }
103 }
104 
105 
106 contract ErrorUtils {
107 
108     event LogError(string methodSig, string errMsg);
109     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
110     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
111 
112 }
113 
114 
115 contract DSMath {
116     function add(uint x, uint y) internal pure returns (uint z) {
117         require((z = x + y) >= x);
118     }
119     function sub(uint x, uint y) internal pure returns (uint z) {
120         require((z = x - y) <= x);
121     }
122     function mul(uint x, uint y) internal pure returns (uint z) {
123         require(y == 0 || (z = x * y) / y == x);
124     }
125 
126     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
127     function div(uint x, uint y) internal pure returns (uint z) {
128         z = x / y;
129     }
130 
131     function min(uint x, uint y) internal pure returns (uint z) {
132         return x <= y ? x : y;
133     }
134     function max(uint x, uint y) internal pure returns (uint z) {
135         return x >= y ? x : y;
136     }
137     function imin(int x, int y) internal pure returns (int z) {
138         return x <= y ? x : y;
139     }
140     function imax(int x, int y) internal pure returns (int z) {
141         return x >= y ? x : y;
142     }
143 
144     uint constant WAD = 10 ** 18;
145     uint constant RAY = 10 ** 27;
146 
147     function wmul(uint x, uint y) internal pure returns (uint z) {
148         z = add(mul(x, y), WAD / 2) / WAD;
149     }
150     function rmul(uint x, uint y) internal pure returns (uint z) {
151         z = add(mul(x, y), RAY / 2) / RAY;
152     }
153     function wdiv(uint x, uint y) internal pure returns (uint z) {
154         z = add(mul(x, WAD), y / 2) / y;
155     }
156     function rdiv(uint x, uint y) internal pure returns (uint z) {
157         z = add(mul(x, RAY), y / 2) / y;
158     }
159 
160     // This famous algorithm is called "exponentiation by squaring"
161     // and calculates x^n with x as fixed-point and n as regular unsigned.
162     //
163     // It's O(log n), instead of O(n) for naive repeated multiplication.
164     //
165     // These facts are why it works:
166     //
167     //  If n is even, then x^n = (x^2)^(n/2).
168     //  If n is odd,  then x^n = x * x^(n-1),
169     //   and applying the equation for even x gives
170     //    x^n = x * (x^2)^((n-1) / 2).
171     //
172     //  Also, EVM division is flooring and
173     //    floor[(n-1) / 2] = floor[n / 2].
174     //
175     function rpow(uint x, uint n) internal pure returns (uint z) {
176         z = n % 2 != 0 ? x : RAY;
177 
178         for (n /= 2; n != 0; n /= 2) {
179             x = rmul(x, x);
180 
181             if (n % 2 != 0) {
182                 z = rmul(z, x);
183             }
184         }
185     }
186 }
187 
188 
189 contract SelfAuthorized {
190     modifier authorized() {
191         require(msg.sender == address(this), "Method can only be called from this contract");
192         _;
193     }
194 }
195 
196 
197 contract DSNote {
198     event LogNote(
199         bytes4   indexed  sig,
200         address  indexed  guy,
201         bytes32  indexed  foo,
202         bytes32  indexed  bar,
203         uint              wad,
204         bytes             fax
205     ) anonymous;
206 
207     modifier note {
208         bytes32 foo;
209         bytes32 bar;
210 
211         assembly {
212             foo := calldataload(4)
213             bar := calldataload(36)
214         }
215 
216         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
217 
218         _;
219     }
220 }
221 
222 
223 contract Utils {
224 
225     modifier addressValid(address _address) {
226         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
227         _;
228     }
229 
230 }
231 
232 
233 contract WETH9 {
234     string public name     = "Wrapped Ether";
235     string public symbol   = "WETH";
236     uint8  public decimals = 18;
237 
238     event  Approval(address indexed _owner, address indexed _spender, uint _value);
239     event  Transfer(address indexed _from, address indexed _to, uint _value);
240     event  Deposit(address indexed _owner, uint _value);
241     event  Withdrawal(address indexed _owner, uint _value);
242 
243     mapping (address => uint)                       public  balanceOf;
244     mapping (address => mapping (address => uint))  public  allowance;
245 
246     function() public payable {
247         deposit();
248     }
249 
250     function deposit() public payable {
251         balanceOf[msg.sender] += msg.value;
252         Deposit(msg.sender, msg.value);
253     }
254 
255     function withdraw(uint wad) public {
256         require(balanceOf[msg.sender] >= wad);
257         balanceOf[msg.sender] -= wad;
258         msg.sender.transfer(wad);
259         Withdrawal(msg.sender, wad);
260     }
261 
262     function totalSupply() public view returns (uint) {
263         return this.balance;
264     }
265 
266     function approve(address guy, uint wad) public returns (bool) {
267         allowance[msg.sender][guy] = wad;
268         Approval(msg.sender, guy, wad);
269         return true;
270     }
271 
272     function transfer(address dst, uint wad) public returns (bool) {
273         return transferFrom(msg.sender, dst, wad);
274     }
275 
276     function transferFrom(address src, address dst, uint wad)
277         public
278         returns (bool)
279     {
280         require(balanceOf[src] >= wad);
281 
282         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
283             require(allowance[src][msg.sender] >= wad);
284             allowance[src][msg.sender] -= wad;
285         }
286 
287         balanceOf[src] -= wad;
288         balanceOf[dst] += wad;
289 
290         Transfer(src, dst, wad);
291 
292         return true;
293     }
294 }
295 
296 
297 contract DateTime {
298     /*
299         *  Date and Time utilities for ethereum contracts
300         *
301         */
302     struct _DateTime {
303         uint16 year;
304         uint8 month;
305         uint8 day;
306         uint8 hour;
307         uint8 minute;
308         uint8 second;
309         uint8 weekday;
310     }
311 
312     uint constant DAY_IN_SECONDS = 86400;
313     uint constant YEAR_IN_SECONDS = 31536000;
314     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
315 
316     uint constant HOUR_IN_SECONDS = 3600;
317     uint constant MINUTE_IN_SECONDS = 60;
318 
319     uint16 constant ORIGIN_YEAR = 1970;
320 
321     function isLeapYear(uint16 year) public pure returns (bool) {
322         if (year % 4 != 0) {
323             return false;
324         }
325         if (year % 100 != 0) {
326             return true;
327         }
328         if (year % 400 != 0) {
329             return false;
330         }
331         return true;
332     }
333 
334     function leapYearsBefore(uint year) public pure returns (uint) {
335         year -= 1;
336         return year / 4 - year / 100 + year / 400;
337     }
338 
339     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
340         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
341             return 31;
342         }
343         else if (month == 4 || month == 6 || month == 9 || month == 11) {
344             return 30;
345         }
346         else if (isLeapYear(year)) {
347             return 29;
348         }
349         else {
350             return 28;
351         }
352     }
353 
354     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
355         uint secondsAccountedFor = 0;
356         uint buf;
357         uint8 i;
358 
359         // Year
360         dt.year = getYear(timestamp);
361         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
362 
363         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
364         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
365 
366         // Month
367         uint secondsInMonth;
368         for (i = 1; i <= 12; i++) {
369             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
370             if (secondsInMonth + secondsAccountedFor > timestamp) {
371                 dt.month = i;
372                 break;
373             }
374             secondsAccountedFor += secondsInMonth;
375         }
376 
377         // Day
378         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
379             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
380                 dt.day = i;
381                 break;
382             }
383             secondsAccountedFor += DAY_IN_SECONDS;
384         }
385 
386         // Hour
387         dt.hour = getHour(timestamp);
388 
389         // Minute
390         dt.minute = getMinute(timestamp);
391 
392         // Second
393         dt.second = getSecond(timestamp);
394 
395         // Day of week.
396         dt.weekday = getWeekday(timestamp);
397     }
398 
399     function getYear(uint timestamp) public pure returns (uint16) {
400         uint secondsAccountedFor = 0;
401         uint16 year;
402         uint numLeapYears;
403 
404         // Year
405         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
406         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
407 
408         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
409         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
410 
411         while (secondsAccountedFor > timestamp) {
412             if (isLeapYear(uint16(year - 1))) {
413                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
414             }
415             else {
416                 secondsAccountedFor -= YEAR_IN_SECONDS;
417             }
418             year -= 1;
419         }
420         return year;
421     }
422 
423     function getMonth(uint timestamp) public pure returns (uint8) {
424         return parseTimestamp(timestamp).month;
425     }
426 
427     function getDay(uint timestamp) public pure returns (uint8) {
428         return parseTimestamp(timestamp).day;
429     }
430 
431     function getHour(uint timestamp) public pure returns (uint8) {
432         return uint8((timestamp / 60 / 60) % 24);
433     }
434 
435     function getMinute(uint timestamp) public pure returns (uint8) {
436         return uint8((timestamp / 60) % 60);
437     }
438 
439     function getSecond(uint timestamp) public pure returns (uint8) {
440         return uint8(timestamp % 60);
441     }
442 
443     function getWeekday(uint timestamp) public pure returns (uint8) {
444         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
445     }
446 
447     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
448         return toTimestamp(year, month, day, 0, 0, 0);
449     }
450 
451     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
452         return toTimestamp(year, month, day, hour, 0, 0);
453     }
454 
455     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
456         return toTimestamp(year, month, day, hour, minute, 0);
457     }
458 
459     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
460         uint16 i;
461 
462         // Year
463         for (i = ORIGIN_YEAR; i < year; i++) {
464             if (isLeapYear(i)) {
465                 timestamp += LEAP_YEAR_IN_SECONDS;
466             }
467             else {
468                 timestamp += YEAR_IN_SECONDS;
469             }
470         }
471 
472         // Month
473         uint8[12] memory monthDayCounts;
474         monthDayCounts[0] = 31;
475         if (isLeapYear(year)) {
476             monthDayCounts[1] = 29;
477         }
478         else {
479             monthDayCounts[1] = 28;
480         }
481         monthDayCounts[2] = 31;
482         monthDayCounts[3] = 30;
483         monthDayCounts[4] = 31;
484         monthDayCounts[5] = 30;
485         monthDayCounts[6] = 31;
486         monthDayCounts[7] = 31;
487         monthDayCounts[8] = 30;
488         monthDayCounts[9] = 31;
489         monthDayCounts[10] = 30;
490         monthDayCounts[11] = 31;
491 
492         for (i = 1; i < month; i++) {
493             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
494         }
495 
496         // Day
497         timestamp += DAY_IN_SECONDS * (day - 1);
498 
499         // Hour
500         timestamp += HOUR_IN_SECONDS * (hour);
501 
502         // Minute
503         timestamp += MINUTE_IN_SECONDS * (minute);
504 
505         // Second
506         timestamp += second;
507 
508         return timestamp;
509     }
510 }
511 
512 
513 interface ERC20 {
514 
515     function name() external view returns(string);
516     function symbol() external view returns(string);
517     function decimals() external view returns(uint8);
518     function totalSupply() external view returns (uint);
519 
520     function balanceOf(address tokenOwner) external view returns (uint balance);
521     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
522     function transfer(address to, uint tokens) external returns (bool success);
523     function approve(address spender, uint tokens) external returns (bool success);
524     function transferFrom(address from, address to, uint tokens) external returns (bool success);
525 
526     event Transfer(address indexed from, address indexed to, uint tokens);
527     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
528 }
529 
530 
531 contract MasterCopy is SelfAuthorized {
532   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
533   // It should also always be ensured that the address is stored alone (uses a full word)
534     address masterCopy;
535 
536   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
537   /// @param _masterCopy New contract address.
538     function changeMasterCopy(address _masterCopy)
539         public
540         authorized
541     {
542         // Master copy address cannot be null.
543         require(_masterCopy != 0, "Invalid master copy address provided");
544         masterCopy = _masterCopy;
545     }
546 }
547 
548 
549 contract Config is DSNote, DSAuth, Utils {
550 
551     WETH9 public weth9;
552     mapping (address => bool) public isAccountHandler;
553     mapping (address => bool) public isAdmin;
554     address[] public admins;
555     bool public disableAdminControl = false;
556     
557     event LogAdminAdded(address indexed _admin, address _by);
558     event LogAdminRemoved(address indexed _admin, address _by);
559 
560     constructor() public {
561         admins.push(msg.sender);
562         isAdmin[msg.sender] = true;
563     }
564 
565     modifier onlyAdmin(){
566         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
567         _;
568     }
569 
570     function setWETH9
571     (
572         address _weth9
573     ) 
574         public
575         auth
576         note
577         addressValid(_weth9) 
578     {
579         weth9 = WETH9(_weth9);
580     }
581 
582     function setAccountHandler
583     (
584         address _accountHandler,
585         bool _isAccountHandler
586     )
587         public
588         auth
589         note
590         addressValid(_accountHandler)
591     {
592         isAccountHandler[_accountHandler] = _isAccountHandler;
593     }
594 
595     function toggleAdminsControl() 
596         public
597         auth
598         note
599     {
600         disableAdminControl = !disableAdminControl;
601     }
602 
603     function isAdminValid(address _admin)
604         public
605         view
606         returns (bool)
607     {
608         if(disableAdminControl) {
609             return true;
610         } else {
611             return isAdmin[_admin];
612         }
613     }
614 
615     function getAllAdmins()
616         public
617         view
618         returns(address[])
619     {
620         return admins;
621     }
622 
623     function addAdmin
624     (
625         address _admin
626     )
627         external
628         note
629         onlyAdmin
630         addressValid(_admin)
631     {   
632         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
633 
634         admins.push(_admin);
635         isAdmin[_admin] = true;
636 
637         emit LogAdminAdded(_admin, msg.sender);
638     }
639 
640     function removeAdmin
641     (
642         address _admin
643     ) 
644         external
645         note
646         onlyAdmin
647         addressValid(_admin)
648     {   
649         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
650         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
651 
652         isAdmin[_admin] = false;
653 
654         for (uint i = 0; i < admins.length - 1; i++) {
655             if (admins[i] == _admin) {
656                 admins[i] = admins[admins.length - 1];
657                 admins.length -= 1;
658                 break;
659             }
660         }
661 
662         emit LogAdminRemoved(_admin, msg.sender);
663     }
664 }
665 
666 
667 library ECRecovery {
668 
669     function recover(bytes32 _hash, bytes _sig)
670         internal
671         pure
672     returns (address)
673     {
674         bytes32 r;
675         bytes32 s;
676         uint8 v;
677 
678         if (_sig.length != 65) {
679             return (address(0));
680         }
681 
682         assembly {
683             r := mload(add(_sig, 32))
684             s := mload(add(_sig, 64))
685             v := byte(0, mload(add(_sig, 96)))
686         }
687 
688         if (v < 27) {
689             v += 27;
690         }
691 
692         if (v != 27 && v != 28) {
693             return (address(0));
694         } else {
695             return ecrecover(_hash, v, r, s);
696         }
697     }
698 
699     function toEthSignedMessageHash(bytes32 _hash)
700         internal
701         pure
702     returns (bytes32)
703     {
704         return keccak256(
705             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
706         );
707     }
708 }
709 
710 
711 contract Utils2 {
712     using ECRecovery for bytes32;
713     
714     function _recoverSigner(bytes32 _hash, bytes _signature) 
715         internal
716         pure
717         returns(address _signer)
718     {
719         return _hash.toEthSignedMessageHash().recover(_signature);
720     }
721 
722 }
723 
724 
725 contract DSThing is DSNote, DSAuth, DSMath {
726 
727     function S(string s) internal pure returns (bytes4) {
728         return bytes4(keccak256(s));
729     }
730 
731 }
732 
733 
734 contract DSStop is DSNote, DSAuth {
735 
736     bool public stopped = false;
737 
738     modifier whenNotStopped {
739         require(!stopped, "DSStop::_ FEATURE_STOPPED");
740         _;
741     }
742 
743     modifier whenStopped {
744         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
745         _;
746     }
747 
748     function stop() public auth note {
749         stopped = true;
750     }
751     function start() public auth note {
752         stopped = false;
753     }
754 
755 }
756 
757 
758 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
759 
760     address[] public users;
761     mapping (address => bool) public isUser;
762     mapping (bytes32 => bool) public actionCompleted;
763 
764     WETH9 public weth9;
765     Config public config;
766     bool public isInitialized = false;
767 
768     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
769     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
770     event LogUserAdded(address indexed user, address by);
771     event LogUserRemoved(address indexed user, address by);
772     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
773 
774     modifier initialized() {
775         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
776         _;
777     }
778 
779     modifier notInitialized() {
780         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
781         _;
782     }
783 
784     modifier userExists(address _user) {
785         require(isUser[_user], "Account::_ INVALID_USER");
786         _;
787     }
788 
789     modifier userDoesNotExist(address _user) {
790         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
791         _;
792     }
793 
794     modifier onlyAdmin() {
795         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
796         _;
797     }
798 
799     modifier onlyHandler(){
800         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
801         _;
802     }
803 
804     function init(address _user, address _config)
805         public 
806         notInitialized
807     {
808         users.push(_user);
809         isUser[_user] = true;
810         config = Config(_config);
811         weth9 = config.weth9();
812         isInitialized = true;
813     }
814     
815     function getAllUsers() public view returns (address[]) {
816         return users;
817     }
818 
819     function balanceFor(address _token) public view returns (uint _balance){
820         _balance = ERC20(_token).balanceOf(this);
821     }
822     
823     function transferBySystem
824     (   
825         address _token,
826         address _to,
827         uint _value
828     ) 
829         external 
830         onlyHandler
831         note 
832         initialized
833     {
834         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
835         ERC20(_token).transfer(_to, _value);
836 
837         emit LogTransferBySystem(_token, _to, _value, msg.sender);
838     }
839     
840     function transferByUser
841     (   
842         address _token,
843         address _to,
844         uint _value,
845         uint _salt,
846         bytes _signature
847     )
848         external
849         addressValid(_to)
850         note
851         initialized
852         onlyAdmin
853     {
854         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
855 
856         if(actionCompleted[actionHash]) {
857             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
858             return;
859         }
860 
861         if(ERC20(_token).balanceOf(this) < _value){
862             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
863             return;
864         }
865 
866         address signer = _recoverSigner(actionHash, _signature);
867 
868         if(!isUser[signer]) {
869             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
870             return;
871         }
872 
873         actionCompleted[actionHash] = true;
874         
875         if (_token == address(weth9)) {
876             weth9.withdraw(_value);
877             _to.transfer(_value);
878         } else {
879             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
880         }
881 
882         emit LogTransferByUser(_token, _to, _value, signer);
883     }
884 
885     function addUser
886     (
887         address _user,
888         uint _salt,
889         bytes _signature
890     )
891         external 
892         note 
893         addressValid(_user)
894         userDoesNotExist(_user)
895         initialized
896         onlyAdmin
897     {   
898         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
899         if(actionCompleted[actionHash])
900         {
901             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
902             return;
903         }
904 
905         address signer = _recoverSigner(actionHash, _signature);
906 
907         if(!isUser[signer]) {
908             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
909             return;
910         }
911 
912         actionCompleted[actionHash] = true;
913 
914         users.push(_user);
915         isUser[_user] = true;
916 
917         emit LogUserAdded(_user, signer);
918     }
919 
920     function removeUser
921     (
922         address _user,
923         uint _salt,
924         bytes _signature
925     ) 
926         external
927         note
928         userExists(_user) 
929         initialized
930         onlyAdmin
931     {   
932         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
933 
934         if(actionCompleted[actionHash]) {
935             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
936             return;
937         }
938 
939         address signer = _recoverSigner(actionHash, _signature);
940         
941         if(users.length == 1){
942             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
943             return;
944         }
945         
946         if(!isUser[signer]){
947             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
948             return;
949         }
950         
951         actionCompleted[actionHash] = true;
952 
953         // should delete value from isUser map? delete isUser[_user]?
954         isUser[_user] = false;
955         for (uint i = 0; i < users.length - 1; i++) {
956             if (users[i] == _user) {
957                 users[i] = users[users.length - 1];
958                 users.length -= 1;
959                 break;
960             }
961         }
962 
963         emit LogUserRemoved(_user, signer);
964     }
965 
966     function _getTransferActionHash
967     ( 
968         address _token,
969         address _to,
970         uint _value,
971         uint _salt
972     ) 
973         internal
974         view
975         returns (bytes32)
976     {
977         return keccak256(
978             abi.encodePacked(
979                 address(this),
980                 _token,
981                 _to,
982                 _value,
983                 _salt
984             )
985         );
986     }
987 
988     function _getUserActionHash
989     ( 
990         address _user,
991         string _action,
992         uint _salt
993     ) 
994         internal
995         view
996         returns (bytes32)
997     {
998         return keccak256(
999             abi.encodePacked(
1000                 address(this),
1001                 _user,
1002                 _action,
1003                 _salt
1004             )
1005         );
1006     }
1007 
1008     // to directly send ether to contract
1009     function() external payable {
1010         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
1011 
1012         if(msg.sender != address(weth9)){
1013             weth9.deposit.value(msg.value)();
1014         }
1015     }
1016 
1017     function changeImpl
1018     (
1019         address _to,
1020         uint _salt,
1021         bytes _signature
1022     )
1023         external 
1024         note 
1025         addressValid(_to)
1026         initialized
1027         onlyAdmin
1028     {   
1029         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
1030         if(actionCompleted[actionHash])
1031         {
1032             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
1033             return;
1034         }
1035 
1036         address signer = _recoverSigner(actionHash, _signature);
1037 
1038         if(!isUser[signer]) {
1039             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1040             return;
1041         }
1042 
1043         actionCompleted[actionHash] = true;
1044 
1045         address oldImpl = masterCopy;
1046         this.changeMasterCopy(_to);
1047         
1048         emit LogImplChanged(_to, oldImpl);
1049     }
1050 
1051 }
1052 
1053 
1054 contract AccountFactory is DSStop, Utils {
1055     Config public config;
1056     mapping (address => bool) public isAccount;
1057     mapping (address => address[]) public userToAccounts;
1058     address[] public accounts;
1059 
1060     address public accountMaster;
1061 
1062     constructor
1063     (
1064         Config _config, 
1065         address _accountMaster
1066     ) 
1067     public 
1068     {
1069         config = _config;
1070         accountMaster = _accountMaster;
1071     }
1072 
1073     event LogAccountCreated(address indexed user, address indexed account, address by);
1074 
1075     modifier onlyAdmin() {
1076         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
1077         _;
1078     }
1079 
1080     function setConfig(Config _config) external note auth addressValid(_config) {
1081         config = _config;
1082     }
1083 
1084     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
1085         accountMaster = _accountMaster;
1086     }
1087 
1088     function newAccount(address _user)
1089         public
1090         note
1091         onlyAdmin
1092         addressValid(config)
1093         addressValid(accountMaster)
1094         whenNotStopped
1095         returns 
1096         (
1097             Account _account
1098         ) 
1099     {
1100         address proxy = new Proxy(accountMaster);
1101         _account = Account(proxy);
1102         _account.init(_user, config);
1103 
1104         accounts.push(_account);
1105         userToAccounts[_user].push(_account);
1106         isAccount[_account] = true;
1107 
1108         emit LogAccountCreated(_user, _account, msg.sender);
1109     }
1110     
1111     function batchNewAccount(address[] _users) public note onlyAdmin {
1112         for (uint i = 0; i < _users.length; i++) {
1113             newAccount(_users[i]);
1114         }
1115     }
1116 
1117     function getAllAccounts() public view returns (address[]) {
1118         return accounts;
1119     }
1120 
1121     function getAccountsForUser(address _user) public view returns (address[]) {
1122         return userToAccounts[_user];
1123     }
1124 
1125 }
1126 
1127 
1128 contract Escrow is DSNote, DSAuth {
1129 
1130     event LogTransfer(address indexed token, address indexed to, uint value);
1131     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
1132 
1133     function transfer
1134     (
1135         address _token,
1136         address _to,
1137         uint _value
1138     )
1139         public
1140         note
1141         auth
1142     {
1143         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
1144         emit LogTransfer(_token, _to, _value);
1145     }
1146 
1147     function transferFromAccount
1148     (
1149         address _account,
1150         address _token,
1151         address _to,
1152         uint _value
1153     )
1154         public
1155         note
1156         auth
1157     {   
1158         Account(_account).transferBySystem(_token, _to, _value);
1159         emit LogTransferFromAccount(_account, _token, _to, _value);
1160     }
1161 
1162 }
1163 
1164 // issue with deploying multiple instances of same type in truffle, hence the following two contracts
1165 contract KernelEscrow is Escrow {
1166 
1167 }
1168 
1169 contract ReserveEscrow is Escrow {
1170     
1171 }
1172 
1173 
1174 contract Reserve is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1175 
1176     Escrow public escrow;
1177     AccountFactory public accountFactory;
1178     DateTime public dateTime;
1179     Config public config;
1180     uint public deployTimestamp;
1181 
1182     string constant public VERSION = "1.0.0";
1183 
1184     uint public TIME_INTERVAL = 1 days;
1185     //uint public TIME_INTERVAL = 1 hours;
1186     
1187     constructor
1188     (
1189         Escrow _escrow,
1190         AccountFactory _accountFactory,
1191         DateTime _dateTime,
1192         Config _config
1193     ) 
1194     public 
1195     {
1196         escrow = _escrow;
1197         accountFactory = _accountFactory;
1198         dateTime = _dateTime;
1199         config = _config;
1200         deployTimestamp = now - (4 * TIME_INTERVAL);
1201     }
1202 
1203     function setEscrow(Escrow _escrow) 
1204         public 
1205         note 
1206         auth
1207         addressValid(_escrow)
1208     {
1209         escrow = _escrow;
1210     }
1211 
1212     function setAccountFactory(AccountFactory _accountFactory) 
1213         public 
1214         note 
1215         auth
1216         addressValid(_accountFactory)
1217     {
1218         accountFactory = _accountFactory;
1219     }
1220 
1221     function setDateTime(DateTime _dateTime) 
1222         public 
1223         note 
1224         auth
1225         addressValid(_dateTime)
1226     {
1227         dateTime = _dateTime;
1228     }
1229 
1230     function setConfig(Config _config) 
1231         public 
1232         note 
1233         auth
1234         addressValid(_config)
1235     {
1236         config = _config;
1237     }
1238 
1239     struct Order {
1240         address account;
1241         address token;
1242         address byUser;
1243         uint value;
1244         uint duration;
1245         uint expirationTimestamp;
1246         uint salt;
1247         uint createdTimestamp;
1248         bytes32 orderHash;
1249     }
1250 
1251     bytes32[] public orders;
1252     mapping (bytes32 => Order) public hashToOrder;
1253     mapping (bytes32 => bool) public isOrder;
1254     mapping (address => bytes32[]) public accountToOrders;
1255     mapping (bytes32 => bool) public cancelledOrders;
1256 
1257     // per day
1258     mapping (uint => mapping(address => uint)) public deposits;
1259     mapping (uint => mapping(address => uint)) public withdrawals;
1260     mapping (uint => mapping(address => uint)) public profits;
1261     mapping (uint => mapping(address => uint)) public losses;
1262 
1263     mapping (uint => mapping(address => uint)) public reserves;
1264     mapping (address => uint) public lastReserveRuns;
1265 
1266     mapping (address => mapping(address => uint)) public surplus;
1267 
1268     mapping (bytes32 => CumulativeRun) public orderToCumulative;
1269 
1270     struct CumulativeRun {
1271         uint timestamp;
1272         uint value;
1273     }
1274 
1275     modifier onlyAdmin() {
1276         require(config.isAdminValid(msg.sender), "Reserve::_ INVALID_ADMIN_ACCOUNT");
1277         _;
1278     }
1279 
1280     event LogOrderCreated(
1281         bytes32 indexed orderHash,
1282         address indexed account,
1283         address indexed token,
1284         address byUser,
1285         uint value,
1286         uint expirationTimestamp
1287     );
1288 
1289     event LogOrderCancelled(
1290         bytes32 indexed orderHash,
1291         address indexed by
1292     );
1293 
1294     event LogReserveValuesUpdated(
1295         address indexed token, 
1296         uint indexed updatedTill,
1297         uint reserve,
1298         uint profit,
1299         uint loss
1300     );
1301 
1302     event LogOrderCumulativeUpdated(
1303         bytes32 indexed orderHash,
1304         uint updatedTill,
1305         uint value
1306     );
1307 
1308     event LogRelease(
1309         address indexed token,
1310         address indexed to,
1311         uint value,
1312         address by
1313     );
1314 
1315     event LogLock(
1316         address indexed token,
1317         address indexed from,
1318         uint value,
1319         uint profit,
1320         uint loss,
1321         address by
1322     );
1323 
1324     event LogLockSurplus(
1325         address indexed forToken, 
1326         address indexed token,
1327         address from,
1328         uint value
1329     );
1330 
1331     event LogTransferSurplus(
1332         address indexed forToken,
1333         address indexed token,
1334         address to, 
1335         uint value
1336     );
1337     
1338     function createOrder
1339     (
1340         address[3] _orderAddresses,
1341         uint[3] _orderValues,
1342         bytes _signature
1343     ) 
1344         public
1345         note
1346         onlyAdmin
1347         whenNotStopped
1348     {
1349         Order memory order = _composeOrder(_orderAddresses, _orderValues);
1350         address signer = _recoverSigner(order.orderHash, _signature);
1351 
1352         if(signer != order.byUser){
1353             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_ORDER_CREATOR");
1354             return;
1355         }
1356         
1357         if(isOrder[order.orderHash]){
1358             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "ORDER_ALREADY_EXISTS");
1359             return;
1360         }
1361 
1362         if(!accountFactory.isAccount(order.account)){
1363             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_ACCOUNT");
1364             return;
1365         }
1366 
1367         if(!Account(order.account).isUser(signer)){
1368             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1369             return;
1370         }
1371                 
1372         if(!_isOrderValid(order)) {
1373             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_PARAMETERS");
1374             return;
1375         }
1376 
1377         if(ERC20(order.token).balanceOf(order.account) < order.value){
1378             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
1379             return;
1380         }
1381 
1382         escrow.transferFromAccount(order.account, order.token, address(escrow), order.value);
1383         
1384         orders.push(order.orderHash);
1385         hashToOrder[order.orderHash] = order;
1386         isOrder[order.orderHash] = true;
1387         accountToOrders[order.account].push(order.orderHash);
1388 
1389         uint dateTimestamp = _getDateTimestamp(now);
1390 
1391         deposits[dateTimestamp][order.token] = add(deposits[dateTimestamp][order.token], order.value);
1392         
1393         orderToCumulative[order.orderHash].timestamp = _getDateTimestamp(order.createdTimestamp);
1394         orderToCumulative[order.orderHash].value = order.value;
1395 
1396         emit LogOrderCreated(
1397             order.orderHash,
1398             order.account,
1399             order.token,
1400             order.byUser,
1401             order.value,
1402             order.expirationTimestamp
1403         );
1404     }
1405 
1406     function cancelOrder
1407     (
1408         bytes32 _orderHash,
1409         bytes _signature
1410     )
1411         external
1412         note
1413         onlyAdmin
1414     {   
1415         if(!isOrder[_orderHash]) {
1416             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_DOES_NOT_EXIST");
1417             return;
1418         }
1419 
1420         if(cancelledOrders[_orderHash]){
1421             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_ALREADY_CANCELLED");
1422             return;
1423         }
1424 
1425         Order memory order = hashToOrder[_orderHash];
1426 
1427         bytes32 cancelOrderHash = _generateActionOrderHash(_orderHash, "CANCEL_RESERVE_ORDER");
1428         address signer = _recoverSigner(cancelOrderHash, _signature);
1429         
1430         if(!Account(order.account).isUser(signer)){
1431             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1432             return;
1433         }
1434         
1435         doCancelOrder(order);
1436     }
1437     
1438     function processOrder
1439     (
1440         bytes32 _orderHash
1441     ) 
1442         external 
1443         note
1444         onlyAdmin
1445     {
1446         if(!isOrder[_orderHash]) {
1447             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_DOES_NOT_EXIST");
1448             return;
1449         }
1450 
1451         if(cancelledOrders[_orderHash]){
1452             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_ALREADY_CANCELLED");
1453             return;
1454         }
1455 
1456         Order memory order = hashToOrder[_orderHash];
1457 
1458         if(now > _getDateTimestamp(order.expirationTimestamp)) {
1459             doCancelOrder(order);
1460         } else {
1461             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::processOrder", "ORDER_NOT_EXPIRED");
1462         }
1463     }
1464 
1465     function doCancelOrder(Order _order) 
1466         internal
1467     {   
1468         uint valueToTransfer = orderToCumulative[_order.orderHash].value;
1469 
1470         if(ERC20(_order.token).balanceOf(escrow) < valueToTransfer){
1471             emit LogErrorWithHintBytes32(_order.orderHash, "Reserve::doCancel", "INSUFFICIENT_BALANCE_IN_ESCROW");
1472             return;
1473         }
1474 
1475         uint nowDateTimestamp = _getDateTimestamp(now);
1476         cancelledOrders[_order.orderHash] = true;
1477         withdrawals[nowDateTimestamp][_order.token] = add(withdrawals[nowDateTimestamp][_order.token], valueToTransfer);
1478 
1479         escrow.transfer(_order.token, _order.account, valueToTransfer);
1480         emit LogOrderCancelled(_order.orderHash, msg.sender);
1481     }
1482 
1483     function release(address _token, address _to, uint _value) 
1484         external
1485         note
1486         auth
1487     {   
1488         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::release INSUFFICIENT_BALANCE_IN_ESCROW");
1489         escrow.transfer(_token, _to, _value);
1490         emit LogRelease(_token, _to, _value, msg.sender);
1491     }
1492 
1493     // _value includes profit/loss as well
1494     function lock(address _token, address _from, uint _value, uint _profit, uint _loss)
1495         external
1496         note
1497         auth
1498     {   
1499         require(!(_profit == 0 && _loss == 0), "Reserve::lock INVALID_PROFIT_LOSS_VALUES");
1500         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lock INSUFFICIENT_BALANCE");
1501             
1502         if(accountFactory.isAccount(_from)) {
1503             escrow.transferFromAccount(_from, _token, address(escrow), _value);
1504         } else {
1505             Escrow(_from).transfer(_token, address(escrow), _value);
1506         }
1507         
1508         uint dateTimestamp = _getDateTimestamp(now);
1509 
1510         if (_profit > 0){
1511             profits[dateTimestamp][_token] = add(profits[dateTimestamp][_token], _profit);
1512         } else if (_loss > 0) {
1513             losses[dateTimestamp][_token] = add(losses[dateTimestamp][_token], _loss);
1514         }
1515 
1516         emit LogLock(_token, _from, _value, _profit, _loss, msg.sender);
1517     }
1518 
1519     // to lock collateral if cannot be liquidated e.g. not enough reserves in kyber
1520     function lockSurplus(address _from, address _forToken, address _token, uint _value) 
1521         external
1522         note
1523         auth
1524     {
1525         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lockSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1526 
1527         Escrow(_from).transfer(_token, address(escrow), _value);
1528         surplus[_forToken][_token] = add(surplus[_forToken][_token], _value);
1529 
1530         emit LogLockSurplus(_forToken, _token, _from, _value);
1531     }
1532 
1533     // to transfer surplus collateral out of the system to trade on other platforms and put back in terms of 
1534     // principal to reserve manually using an account or surplus escrow
1535     // should work in tandem with lock method when transferring back principal
1536     function transferSurplus(address _to, address _forToken, address _token, uint _value) 
1537         external
1538         note
1539         auth
1540     {
1541         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::transferSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1542         require(surplus[_forToken][_token] >= _value, "Reserve::transferSurplus INSUFFICIENT_SURPLUS");
1543 
1544         surplus[_forToken][_token] = sub(surplus[_forToken][_token], _value);
1545         escrow.transfer(_token, _to, _value);
1546 
1547         emit LogTransferSurplus(_forToken, _token, _to, _value);
1548     }
1549 
1550     function updateReserveValues(address _token, uint _forDays)
1551         public
1552         note
1553         onlyAdmin
1554     {   
1555         uint lastReserveRun = lastReserveRuns[_token];
1556 
1557         if (lastReserveRun == 0) {
1558             lastReserveRun = _getDateTimestamp(deployTimestamp) - TIME_INTERVAL;
1559         }
1560 
1561         uint nowDateTimestamp = _getDateTimestamp(now);
1562         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastReserveRun) / TIME_INTERVAL;
1563 
1564         if(updatesLeft == 0) {
1565             emit LogErrorWithHintAddress(_token, "Reserve::updateReserveValues", "RESERVE_VALUES_UP_TO_DATE");
1566             return;
1567         }
1568 
1569         uint counter = updatesLeft;
1570 
1571         if(updatesLeft > _forDays && _forDays > 0) {
1572             counter = _forDays;
1573         }
1574 
1575         for (uint i = 0; i < counter; i++) {
1576             reserves[lastReserveRun + TIME_INTERVAL][_token] = sub(
1577                 sub(
1578                     add(
1579                         add(
1580                             reserves[lastReserveRun][_token],
1581                             deposits[lastReserveRun + TIME_INTERVAL][_token]
1582                         ),
1583                         profits[lastReserveRun + TIME_INTERVAL][_token]
1584                     ),
1585                     losses[lastReserveRun + TIME_INTERVAL][_token]
1586                 ),
1587                 withdrawals[lastReserveRun + TIME_INTERVAL][_token]
1588             );
1589             lastReserveRuns[_token] = lastReserveRun + TIME_INTERVAL;
1590             lastReserveRun = lastReserveRuns[_token];
1591             
1592             emit LogReserveValuesUpdated(
1593                 _token,
1594                 lastReserveRun,
1595                 reserves[lastReserveRun][_token],
1596                 profits[lastReserveRun][_token],
1597                 losses[lastReserveRun][_token]
1598             );
1599             
1600         }
1601     }
1602 
1603     function updateOrderCumulativeValueBatch(bytes32[] _orderHashes, uint[] _forDays) 
1604         public
1605         note
1606         onlyAdmin
1607     {   
1608         if(_orderHashes.length != _forDays.length) {
1609             emit LogError("Reserve::updateOrderCumulativeValueBatch", "ARGS_ARRAYLENGTH_MISMATCH");
1610             return;
1611         }
1612 
1613         for(uint i = 0; i < _orderHashes.length; i++) {
1614             updateOrderCumulativeValue(_orderHashes[i], _forDays[i]);
1615         }
1616     }
1617 
1618     function updateOrderCumulativeValue
1619     (
1620         bytes32 _orderHash, 
1621         uint _forDays
1622     ) 
1623         public
1624         note
1625         onlyAdmin 
1626     {
1627         if(!isOrder[_orderHash]) {
1628             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_DOES_NOT_EXIST");
1629             return;
1630         }
1631 
1632         if(cancelledOrders[_orderHash]) {
1633             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_ALREADY_CANCELLED");
1634             return;
1635         }
1636         
1637         Order memory order = hashToOrder[_orderHash];
1638         CumulativeRun storage cumulativeRun = orderToCumulative[_orderHash];
1639         
1640         uint profitsAccrued = 0;
1641         uint lossesAccrued = 0;
1642         uint cumulativeValue = 0;
1643         uint counter = 0;
1644 
1645         uint lastOrderRun = cumulativeRun.timestamp;
1646         uint nowDateTimestamp = _getDateTimestamp(now);
1647 
1648         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastOrderRun) / TIME_INTERVAL;
1649 
1650         if(updatesLeft == 0) {
1651             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_VALUES_UP_TO_DATE");
1652             return;
1653         }
1654 
1655         counter = updatesLeft;
1656 
1657         if(updatesLeft > _forDays && _forDays > 0) {
1658             counter = _forDays;
1659         }
1660 
1661         for (uint i = 0; i < counter; i++){
1662             cumulativeValue = cumulativeRun.value;
1663             lastOrderRun = cumulativeRun.timestamp;
1664 
1665             if(lastReserveRuns[order.token] < lastOrderRun) {
1666                 emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "RESERVE_VALUES_NOT_UPDATED");
1667                 emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1668                 return;
1669             }
1670 
1671             profitsAccrued = div(
1672                 mul(profits[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1673                 reserves[lastOrderRun][order.token]
1674             );
1675                 
1676             lossesAccrued = div(
1677                 mul(losses[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1678                 reserves[lastOrderRun][order.token]
1679             );
1680 
1681             cumulativeValue = sub(add(cumulativeValue, profitsAccrued), lossesAccrued);
1682 
1683             cumulativeRun.timestamp = lastOrderRun + TIME_INTERVAL;
1684             cumulativeRun.value = cumulativeValue;
1685         }
1686         
1687         emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1688     }
1689 
1690     function getAllOrders() 
1691         public
1692         view 
1693         returns 
1694         (
1695             bytes32[]
1696         ) 
1697     {
1698         return orders;
1699     }
1700 
1701     function getOrdersForAccount(address _account) 
1702         public
1703         view 
1704         returns 
1705         (
1706             bytes32[]
1707         )
1708     {
1709         return accountToOrders[_account];
1710     }
1711 
1712     function getOrder(bytes32 _orderHash)
1713         public 
1714         view 
1715         returns 
1716         (
1717             address _account,
1718             address _token,
1719             address _byUser,
1720             uint _value,
1721             uint _expirationTimestamp,
1722             uint _salt,
1723             uint _createdTimestamp
1724         )
1725     {   
1726         Order memory order = hashToOrder[_orderHash];
1727         return (
1728             order.account,
1729             order.token,
1730             order.byUser,
1731             order.value,
1732             order.expirationTimestamp,
1733             order.salt,
1734             order.createdTimestamp
1735         );
1736     }
1737 
1738     function _isOrderValid(Order _order)
1739         internal
1740         view
1741         returns (bool)
1742     {
1743         if(_order.account == address(0) || _order.byUser == address(0)
1744          || _order.value <= 0
1745          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
1746             return false;
1747         }
1748 
1749         if(isOrder[_order.orderHash]) {
1750             return false;
1751         }
1752 
1753         if(cancelledOrders[_order.orderHash]) {
1754             return false;
1755         }
1756 
1757         return true;
1758     }
1759 
1760     function _composeOrder(address[3] _orderAddresses, uint[3] _orderValues)
1761         internal
1762         view
1763         returns (Order _order)
1764     {
1765         Order memory order = Order({
1766             account: _orderAddresses[0],
1767             token: _orderAddresses[1],
1768             byUser: _orderAddresses[2],
1769             value: _orderValues[0],
1770             createdTimestamp: now,
1771             duration: _orderValues[1],
1772             expirationTimestamp: add(now, _orderValues[1]),
1773             salt: _orderValues[2],
1774             orderHash: bytes32(0)
1775         });
1776 
1777         order.orderHash = _generateCreateOrderHash(order);
1778 
1779         return order;
1780     }
1781 
1782     function _generateCreateOrderHash(Order _order)
1783         internal
1784         pure //view
1785         returns (bytes32 _orderHash)
1786     {
1787         return keccak256(
1788             abi.encodePacked(
1789  //              address(this),
1790                 _order.account,
1791                 _order.token,
1792                 _order.value,
1793                 _order.duration,
1794                 _order.salt
1795             )
1796         );
1797     }
1798 
1799     function _generateActionOrderHash
1800     (
1801         bytes32 _orderHash,
1802         string _action
1803     )
1804         internal
1805         pure //view
1806         returns (bytes32 _repayOrderHash)
1807     {
1808         return keccak256(
1809             abi.encodePacked(
1810 //                address(this),
1811                 _orderHash,
1812                 _action
1813             )
1814         );
1815     }
1816 
1817     function _getDateTimestamp(uint _timestamp) 
1818         internal
1819         view
1820         returns (uint)
1821     {
1822         // 1 day
1823         return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp));
1824         // 1 hour
1825         //return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp), dateTime.getHour(_timestamp));
1826     } 
1827 
1828 }
1829 interface ExchangeConnector {
1830 
1831     function tradeWithInputFixed
1832     (   
1833         Escrow _escrow,
1834         address _srcToken,
1835         address _destToken,
1836         uint _srcTokenValue
1837     )
1838         external
1839         returns (uint _destTokenValue, uint _srcTokenValueLeft);
1840 
1841     function tradeWithOutputFixed
1842     (   
1843         Escrow _escrow,
1844         address _srcToken,
1845         address _destToken,
1846         uint _srcTokenValue,
1847         uint _maxDestTokenValue
1848     )
1849         external
1850         returns (uint _destTokenValue, uint _srcTokenValueLeft);
1851     
1852 
1853     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
1854         external
1855         view
1856         returns(uint _expectedRate, uint _slippageRate);
1857     
1858     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
1859         external
1860         view
1861         returns(bool);
1862 
1863 }
1864 
1865 
1866 contract MKernel is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1867     
1868     Escrow public escrow;
1869     AccountFactory public accountFactory;
1870     Reserve public reserve;
1871     address public feeWallet;
1872     Config public config;
1873     
1874     constructor
1875     (
1876         Escrow _escrow,
1877         AccountFactory _accountFactory,
1878         Reserve _reserve,
1879         address _feeWallet,
1880         Config _config
1881     ) 
1882     public 
1883     {
1884         escrow = _escrow;
1885         accountFactory = _accountFactory;
1886         reserve = _reserve;
1887         feeWallet = _feeWallet;
1888         config = _config;
1889     }
1890 
1891     function setEscrow(Escrow _escrow) 
1892         public 
1893         note 
1894         auth
1895         addressValid(_escrow)
1896     {
1897         escrow = _escrow;
1898     }
1899 
1900     function setAccountFactory(AccountFactory _accountFactory)
1901         public 
1902         note 
1903         auth
1904         addressValid(_accountFactory)
1905     {
1906         accountFactory = _accountFactory;
1907     }
1908 
1909     function setReserve(Reserve _reserve)
1910         public 
1911         note 
1912         auth
1913         addressValid(_reserve)
1914     {
1915         reserve = _reserve;
1916     }
1917 
1918     function setConfig(Config _config)
1919         public 
1920         note 
1921         auth
1922         addressValid(_config)
1923     {
1924         config = _config;
1925     }
1926 
1927     function setFeeWallet(address _feeWallet)
1928         public 
1929         note 
1930         auth
1931         addressValid(_feeWallet)
1932     {
1933         feeWallet = _feeWallet;
1934     }
1935     
1936     event LogOrderCreated(
1937         bytes32 indexed orderHash,
1938         uint tradeAmount,
1939         uint expirationTimestamp
1940     );
1941 
1942     event LogOrderLiquidatedByUser(
1943         bytes32 indexed orderHash
1944     );
1945 
1946     event LogOrderStoppedAtProfit(
1947         bytes32 indexed orderHash
1948     );
1949 
1950     event LogOrderDefaulted(
1951         bytes32 indexed orderHash,
1952         string reason
1953     );
1954 
1955     event LogNoActionPerformed(
1956         bytes32 indexed orderHash
1957     );
1958 
1959     event LogOrderSettlement(
1960         bytes32 indexed orderHash,
1961         uint valueRepaid,
1962         uint reserveProfit,
1963         uint reserveLoss,
1964         uint collateralLeft,
1965         uint userProfit,
1966         uint fee
1967     );
1968 
1969     struct Order {
1970         address account;
1971         address byUser;
1972         address principalToken; 
1973         address collateralToken;
1974         Trade trade;
1975         uint principalAmount;
1976         uint collateralAmount;
1977         uint premium;
1978         uint expirationTimestamp;
1979         uint duration;
1980         uint salt;
1981         uint fee;
1982         uint createdTimestamp;
1983         bytes32 orderHash;
1984     }
1985 
1986     struct Trade {
1987         address tradeToken;
1988         address closingToken;
1989         address exchangeConnector; //stores initial and then just used to pass around params
1990         uint stopProfit;
1991         uint stopLoss;
1992     }
1993 
1994     bytes32[] public orders;
1995     mapping (bytes32 => Order) public hashToOrder;
1996     mapping (bytes32 => bool) public isOrder;
1997     mapping (address => bytes32[]) public accountToOrders;
1998 
1999     mapping (bytes32 => uint) public initialTradeAmount;
2000     mapping (bytes32 => bool) public isLiquidated;
2001     mapping (bytes32 => bool) public isDefaulted;
2002 
2003     modifier onlyAdmin() {
2004         require(config.isAdminValid(msg.sender), "MKernel::_ INVALID_ADMIN_ACCOUNT");
2005         _;
2006     }
2007 
2008 
2009     function createOrder
2010     (
2011         address[6] _orderAddresses,
2012         uint[8] _orderValues,
2013         address _exchangeConnector,
2014         bytes _signature
2015     )    
2016         external
2017         note
2018         onlyAdmin
2019         whenNotStopped
2020         addressValid(_exchangeConnector)
2021     {
2022         Order memory order = _composeOrder(_orderAddresses, _orderValues);
2023         address signer = _recoverSigner(order.orderHash, _signature);
2024         order.trade.exchangeConnector = _exchangeConnector;
2025 
2026         if(signer != order.byUser) {
2027             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","SIGNER_NOT_ORDER_CREATOR");
2028             return;
2029         }
2030 
2031         if(isOrder[order.orderHash]){
2032             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","ORDER_ALREADY_EXISTS");
2033             return;
2034         }
2035 
2036         if(!accountFactory.isAccount(order.account)){
2037             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","INVALID_ORDER_ACCOUNT");
2038             return;
2039         }
2040 
2041         if(!Account(order.account).isUser(signer)) {
2042             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2043             return;
2044         }
2045 
2046         if(!_isOrderValid(order)){
2047             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","INVALID_ORDER_PARAMETERS");
2048             return;
2049         }
2050 
2051         if(ERC20(order.collateralToken).balanceOf(order.account) < order.collateralAmount){
2052             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","INSUFFICIENT_COLLATERAL_IN_ACCOUNT");
2053             return;
2054         }
2055 
2056         if(ERC20(order.principalToken).balanceOf(reserve.escrow()) < order.principalAmount){
2057             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","INSUFFICIENT_FUNDS_IN_RESERVE");
2058             return;
2059         }
2060 
2061         if(!_isTradeFeasible(order, order.principalToken, order.trade.tradeToken, order.principalAmount))
2062         {
2063             emit LogErrorWithHintBytes32(order.orderHash, "MKernel::createOrder","TRADE_NOT_FEASIBLE");
2064             return;
2065         }        
2066 
2067         
2068         orders.push(order.orderHash);
2069         hashToOrder[order.orderHash] = order;
2070         isOrder[order.orderHash] = true;
2071         accountToOrders[order.account].push(order.orderHash);
2072 
2073         escrow.transferFromAccount(order.account, order.collateralToken, address(escrow), order.collateralAmount);
2074         reserve.release(order.principalToken, address(escrow), order.principalAmount);
2075     
2076         (initialTradeAmount[order.orderHash],) = _tradeWithFixedInput(
2077             order,
2078             ERC20(order.principalToken),
2079             ERC20(order.trade.tradeToken),
2080             order.principalAmount
2081         );
2082 
2083         emit LogOrderCreated(
2084             order.orderHash,
2085             initialTradeAmount[order.orderHash],
2086             order.expirationTimestamp
2087         );
2088         
2089 
2090     }
2091 
2092     function liquidateOrder
2093     (
2094         bytes32 _orderHash,
2095         address _exchangeConnector,
2096         bytes _signature
2097     ) 
2098         external
2099         note
2100         onlyAdmin
2101         addressValid(_exchangeConnector)
2102     {
2103         if(!isOrder[_orderHash]){
2104             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder","ORDER_DOES_NOT_EXIST");
2105             return;
2106         }
2107         
2108         if(isLiquidated[_orderHash]){
2109             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder","ORDER_ALREADY_LIQUIDATED");
2110             return;
2111         }
2112 
2113         if(isDefaulted[_orderHash]){
2114             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder","ORDER_ALREADY_DEFAULTED");
2115             return;
2116         }
2117 
2118         bytes32 liquidateOrderHash = _generateLiquidateOrderHash(_orderHash);
2119         address signer = _recoverSigner(liquidateOrderHash, _signature);
2120 
2121         Order memory order = hashToOrder[_orderHash];
2122         order.trade.exchangeConnector = _exchangeConnector;
2123         
2124         if(!Account(order.account).isUser(signer)){
2125             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2126             return;
2127         }
2128 
2129         if(ERC20(order.trade.tradeToken).balanceOf(address(escrow)) < initialTradeAmount[_orderHash]){
2130             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder", "INSUFFICIENT_TRADE_BALANCE_IN_ESCROW");
2131             return;
2132         }
2133 
2134         if(ERC20(order.collateralToken).balanceOf(address(escrow)) < order.collateralAmount){
2135             emit LogErrorWithHintBytes32(_orderHash, "MKernel::liquidateOrder", "INSUFFICIENT_COLLATERAL_BALANCE_IN_ESCROW");
2136             return;
2137         }
2138 
2139         isLiquidated[order.orderHash] = true;
2140         _performOrderLiquidation(order);
2141 
2142         emit LogOrderLiquidatedByUser(_orderHash);
2143     }
2144 
2145     function processTradeForExpiry
2146     (
2147         bytes32 _orderHash,
2148         address _exchangeConnector
2149     )
2150         external
2151         note
2152         onlyAdmin
2153         addressValid(_exchangeConnector)
2154     {
2155         if(!isOrder[_orderHash]){
2156             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForExpiry","ORDER_DOES_NOT_EXIST");
2157             return;
2158         }
2159 
2160         if(isLiquidated[_orderHash]){
2161             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForExpiry","ORDER_ALREADY_LIQUIDATED");
2162             return;
2163         }
2164 
2165         if(isDefaulted[_orderHash]){
2166             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForExpiry","ORDER_ALREADY_DEFAULTED");
2167             return;
2168         }
2169         
2170 
2171         Order memory order = hashToOrder[_orderHash];
2172         order.trade.exchangeConnector = _exchangeConnector;
2173 
2174         if(ERC20(order.trade.tradeToken).balanceOf(address(escrow)) < initialTradeAmount[_orderHash]){
2175             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForExpiry", "INSUFFICIENT_TRADE_BALANCE_IN_ESCROW");
2176             return;
2177         }
2178 
2179         if(ERC20(order.collateralToken).balanceOf(address(escrow)) < order.collateralAmount){
2180             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForExpiry", "INSUFFICIENT_COLLATERAL_BALANCE_IN_ESCROW");
2181             return;
2182         }
2183 
2184         if(now > order.expirationTimestamp) {
2185             isDefaulted[order.orderHash] = true;
2186             _performOrderLiquidation(order);
2187             emit LogOrderDefaulted(order.orderHash, "MKERNEL_DUE_DATE_PASSED");
2188             return;
2189         }
2190 
2191         emit LogErrorWithHintBytes32(order.orderHash, "MKernel::processTradeForExpiry", "NO_ACTION_PERFORMED");
2192     }
2193 
2194 
2195     function processTradeForStopLoss
2196     (
2197         bytes32 _orderHash,
2198         address _exchangeConnector,
2199         uint[2] _tokenPrices,
2200         uint _bufferInPrincipal
2201     )
2202         external
2203         note
2204         onlyAdmin
2205         addressValid(_exchangeConnector)
2206     {   
2207         if(!isOrder[_orderHash]){
2208             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopLoss","ORDER_DOES_NOT_EXIST");
2209             return;
2210         }
2211 
2212         if(isLiquidated[_orderHash]){
2213             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopLoss","ORDER_ALREADY_LIQUIDATED");
2214             return;
2215         }
2216 
2217         if(isDefaulted[_orderHash]){
2218             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopLoss","ORDER_ALREADY_DEFAULTED");
2219             return;
2220         }
2221 
2222         Order memory order = hashToOrder[_orderHash];
2223         order.trade.exchangeConnector = _exchangeConnector;
2224 
2225         if(ERC20(order.trade.tradeToken).balanceOf(address(escrow)) < initialTradeAmount[_orderHash]){
2226             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopLoss", "INSUFFICIENT_TRADE_BALANCE_IN_ESCROW");
2227             return;
2228         }
2229 
2230         if(ERC20(order.collateralToken).balanceOf(address(escrow)) < order.collateralAmount){
2231             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopLoss", "INSUFFICIENT_COLLATERAL_BALANCE_IN_ESCROW");
2232             return;
2233         }
2234 
2235         if(!_isPositionAboveStopLoss(order, _tokenPrices, _bufferInPrincipal)) {
2236             isDefaulted[order.orderHash] = true;
2237             _performOrderLiquidation(order);
2238             emit LogOrderDefaulted(order.orderHash, "MKERNEL_ORDER_UNSAFE");
2239             return;
2240         }
2241 
2242         emit LogErrorWithHintBytes32(order.orderHash, "MKernel::processTradeForStopLoss", "NO_ACTION_PERFORMED");
2243     }
2244 
2245     function processTradeForStopProfit
2246     (
2247         bytes32 _orderHash,
2248         address _exchangeConnector,
2249         uint[2] _tokenPrices,
2250         uint _bufferInPrincipal
2251     )
2252         external
2253         note
2254         onlyAdmin
2255         addressValid(_exchangeConnector)
2256     {   
2257         if(!isOrder[_orderHash]){
2258             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopProfit","ORDER_DOES_NOT_EXIST");
2259             return;
2260         }
2261 
2262         if(isLiquidated[_orderHash]){
2263             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopProfit","ORDER_ALREADY_LIQUIDATED");
2264             return;
2265         }
2266 
2267         if(isDefaulted[_orderHash]){
2268             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopProfit","ORDER_ALREADY_DEFAULTED");
2269             return;
2270         }
2271 
2272         Order memory order = hashToOrder[_orderHash];
2273         order.trade.exchangeConnector = _exchangeConnector;
2274 
2275         if(ERC20(order.trade.tradeToken).balanceOf(address(escrow)) < initialTradeAmount[_orderHash]){
2276             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopProfit", "INSUFFICIENT_TRADE_BALANCE_IN_ESCROW");
2277             return;
2278         }
2279 
2280         if(ERC20(order.collateralToken).balanceOf(address(escrow)) < order.collateralAmount){
2281             emit LogErrorWithHintBytes32(_orderHash, "MKernel::processTradeForStopProfit", "INSUFFICIENT_COLLATERAL_BALANCE_IN_ESCROW");
2282             return;
2283         }
2284         
2285         if(_isPositionAboveStopProfit(order, _tokenPrices, _bufferInPrincipal)) {
2286             isLiquidated[order.orderHash] = true;
2287             _performOrderLiquidation(order);
2288             emit LogOrderStoppedAtProfit(order.orderHash);
2289             return;
2290         }
2291 
2292         emit LogErrorWithHintBytes32(order.orderHash, "MKernel::processTradeForStopProfit", "NO_ACTION_PERFORMED");
2293     }
2294 
2295     function _performOrderLiquidation(Order _order) 
2296         internal
2297     {   
2298         uint tradeAmount = initialTradeAmount[_order.orderHash];
2299         uint valueToRepay = add(_order.principalAmount, _order.premium);
2300         uint valueToRepayWithFee = add(valueToRepay, _order.fee);
2301     
2302         uint principalFromTrade = 0;
2303         uint principalFromCollateral = 0;
2304         uint principalNeededFromCollateral = 0;
2305         uint collateralLeft = 0;
2306         uint userProfit = 0;
2307         uint totalPrincipalAcquired = 0;
2308         uint orderFee = 0;
2309         
2310 
2311         
2312             (principalFromTrade,) = _tradeWithFixedInput(_order, _order.trade.tradeToken, _order.principalToken, tradeAmount);
2313 
2314             if(principalFromTrade >= valueToRepayWithFee) {
2315                 userProfit = sub(principalFromTrade, valueToRepayWithFee);
2316                 orderFee = _order.fee;
2317                 _performSettlement(_order, valueToRepay, _order.premium, 0, _order.collateralAmount, userProfit, orderFee);
2318             } else {
2319 
2320                 principalNeededFromCollateral = sub(valueToRepayWithFee, principalFromTrade);
2321 
2322                 if (_order.collateralToken == _order.principalToken) {
2323                     principalFromCollateral = principalNeededFromCollateral;
2324 
2325                     if(_order.collateralAmount >= principalNeededFromCollateral) {
2326                         collateralLeft = sub(_order.collateralAmount, principalNeededFromCollateral);
2327                     }
2328 
2329                 } else {
2330                     (principalFromCollateral, collateralLeft) = _tradeWithFixedOutput(_order, _order.collateralToken, _order.principalToken, _order.collateralAmount, principalNeededFromCollateral);    
2331                 }
2332 
2333                 if(principalFromCollateral >= principalNeededFromCollateral) {
2334                     orderFee = _order.fee;
2335                     _performSettlement(_order, valueToRepay, _order.premium, 0, collateralLeft, 0, orderFee);
2336                 } else {
2337                     totalPrincipalAcquired = add(principalFromTrade, principalFromCollateral);
2338                     _performSettlementAfterAllPossibleLiquidations(_order, totalPrincipalAcquired);
2339                 }
2340             }
2341                        
2342     }
2343 
2344     function _tradeWithFixedInput(Order _order, address _srcToken, address _destToken, uint _srcTokenValue)
2345         internal
2346         returns (uint _destTokenValue, uint _srcTokenValueLeft)
2347     {
2348         ExchangeConnector exchangeConnector = ExchangeConnector(_order.trade.exchangeConnector);
2349         return exchangeConnector.tradeWithInputFixed(
2350                     escrow,
2351                     _srcToken,
2352                     _destToken,
2353                     _srcTokenValue
2354         );
2355     }
2356 
2357     function _tradeWithFixedOutput(Order _order, address _srcToken, address _destToken, uint _srcTokenValue, uint _maxDestTokenValue)
2358         internal
2359         returns (uint _destTokenValue, uint _srcTokenValueLeft)
2360     {
2361         ExchangeConnector exchangeConnector = ExchangeConnector(_order.trade.exchangeConnector);
2362         return exchangeConnector.tradeWithOutputFixed(
2363                     escrow,
2364                     _srcToken,
2365                     _destToken,
2366                     _srcTokenValue,
2367                     _maxDestTokenValue
2368         );
2369     }
2370 
2371     function _isTradeFeasible(Order _order, address _srcToken, address _destToken, uint _srcTokenValue)
2372         internal
2373         view
2374         returns (bool)
2375     {   
2376         ExchangeConnector exchangeConnector = ExchangeConnector(_order.trade.exchangeConnector);
2377         return exchangeConnector.isTradeFeasible(_srcToken, _destToken, _srcTokenValue);
2378     }
2379 
2380     function _performSettlementAfterAllPossibleLiquidations
2381     (
2382         Order _order,
2383         uint _totalPrincipalAcquired
2384     )
2385         internal
2386     {
2387         uint valueToRepay = add(_order.principalAmount, _order.premium);
2388 
2389         if(_totalPrincipalAcquired >= valueToRepay) {
2390             _performSettlement(_order, valueToRepay, _order.premium, 0, 0, 0, sub(_totalPrincipalAcquired, valueToRepay));
2391         } else if((_totalPrincipalAcquired < valueToRepay) && (_totalPrincipalAcquired >= _order.principalAmount)) {
2392             _performSettlement(_order, _totalPrincipalAcquired, sub(_totalPrincipalAcquired, _order.principalAmount), 0, 0, 0, 0);
2393         } else {
2394             _performSettlement(_order, _totalPrincipalAcquired, 0, sub(_order.principalAmount, _totalPrincipalAcquired), 0, 0, 0);
2395         }
2396 
2397     }
2398 
2399     function _performSettlement
2400     (
2401         Order _order,
2402         uint _valueRepaid,
2403         uint _reserveProfit,
2404         uint _reserveLoss,
2405         uint _collateralLeft,
2406         uint _userProfit,
2407         uint _fee
2408     ) 
2409         internal 
2410     {
2411         uint closingFromPrincipal = 0;
2412         uint userEarnings = _userProfit;
2413 
2414         if(_fee > 0){
2415             escrow.transfer(_order.principalToken, feeWallet, _fee);
2416         }
2417         
2418         reserve.lock(_order.principalToken, escrow, _valueRepaid, _reserveProfit, _reserveLoss);
2419         
2420         if(_collateralLeft > 0) {
2421             escrow.transfer(_order.collateralToken, _order.account, _collateralLeft);    
2422         }
2423 
2424         if(_userProfit > 0) {
2425             if(_order.trade.closingToken == _order.principalToken || !_isTradeFeasible(_order, _order.principalToken, _order.trade.closingToken, _userProfit)) {
2426                 escrow.transfer(_order.principalToken, _order.account, _userProfit);
2427             } else {
2428                 (closingFromPrincipal,) = _tradeWithFixedInput(_order, _order.principalToken, _order.trade.closingToken, _userProfit);
2429                 escrow.transfer(_order.trade.closingToken, _order.account, closingFromPrincipal);
2430                 userEarnings = closingFromPrincipal;
2431             }
2432         }
2433 
2434         emit LogOrderSettlement(_order.orderHash, _valueRepaid, _reserveProfit, _reserveLoss, _collateralLeft, userEarnings, _fee);
2435     }
2436 
2437     function _isPositionAboveStopLoss(Order _order, uint[2] _tokenPrices, uint _bufferInPrincipal)
2438         internal 
2439         view
2440         returns (bool)
2441     {
2442         uint principalPerCollateral = _tokenPrices[0]; 
2443         uint principalPerTrade = _tokenPrices[1];
2444         uint tradeAmount = initialTradeAmount[_order.orderHash];
2445 
2446         uint valueToRepayWithFee = add(add(_order.principalAmount, _order.premium), _order.fee);
2447         uint totalCollateralValueInPrincipal = div(mul(_order.collateralAmount, principalPerCollateral), WAD);
2448         uint totalTradeValueInPrincipal = div(mul(tradeAmount, principalPerTrade), WAD);
2449 
2450         uint bufferValue = div(mul(_order.principalAmount, _bufferInPrincipal), WAD);
2451         uint minValueReq = div(mul(_order.trade.stopLoss, totalCollateralValueInPrincipal), WAD);
2452 
2453         if(add(valueToRepayWithFee, bufferValue) >= totalTradeValueInPrincipal && 
2454             sub(add(valueToRepayWithFee, bufferValue), totalTradeValueInPrincipal) >= minValueReq) 
2455         {
2456             return false;
2457         }
2458 
2459         return true;
2460     }
2461 
2462     function _isPositionAboveStopProfit(Order _order, uint[2] _tokenPrices, uint _bufferInPrincipal)
2463         internal 
2464         view
2465         returns (bool)
2466     {       
2467         if(_order.trade.stopProfit == 0) {
2468             return false;
2469         } else {
2470             uint principalPerTrade = _tokenPrices[1];
2471             uint tradeAmount = initialTradeAmount[_order.orderHash];
2472 
2473             uint valueToRepayWithFee = add(add(_order.principalAmount, _order.premium), _order.fee);
2474             uint totalTradeValueInPrincipal = div(mul(tradeAmount, principalPerTrade), WAD);
2475 
2476             uint stopProfitValue = div(mul(_order.principalAmount, _order.trade.stopProfit), WAD);
2477             uint bufferValue = div(mul(_order.principalAmount, _bufferInPrincipal), WAD);
2478 
2479             if(totalTradeValueInPrincipal >= add(add(valueToRepayWithFee, stopProfitValue), bufferValue)) {
2480                 return true;
2481             }
2482 
2483             return false;
2484         }
2485     }
2486 
2487     function _generateLiquidateOrderHash
2488     (
2489         bytes32 _orderHash
2490     )
2491         internal
2492         view
2493         returns (bytes32 _liquidateOrderHash)
2494     {
2495         return keccak256(
2496             abi.encodePacked(
2497                 address(this),
2498                 _orderHash,
2499                 "CANCEL_MKERNEL_ORDER"
2500             )
2501         );
2502     }
2503 
2504     function _isOrderValid(Order _order)
2505         internal
2506         pure
2507         returns (bool)
2508     {
2509         if(_order.account == address(0) || _order.byUser == address(0)
2510          || _order.principalToken == address(0) || _order.collateralToken == address(0)
2511          || _order.trade.closingToken == address(0)
2512          || _order.trade.tradeToken == address(0)
2513          || (_order.trade.tradeToken == _order.principalToken) || _order.trade.exchangeConnector == address(0)
2514          || _order.principalAmount == 0 || _order.collateralAmount == 0
2515          || _order.premium == 0
2516          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt == 0) {
2517             return false;
2518         }
2519 
2520         return true;
2521     }
2522 
2523     function _composeOrder
2524     (
2525         address[6] _orderAddresses,
2526         uint[8] _orderValues
2527     )
2528         internal
2529         view
2530         returns (Order _order)
2531     {   
2532         Trade memory trade = _composeTrade(_orderAddresses[4], _orderAddresses[5], _orderValues[6], _orderValues[7]);
2533 
2534         Order memory order = Order({
2535             account: _orderAddresses[0],
2536             byUser: _orderAddresses[1],
2537             principalToken: _orderAddresses[2],
2538             collateralToken: _orderAddresses[3],
2539             principalAmount: _orderValues[0],
2540             collateralAmount: _orderValues[1],
2541             premium: _orderValues[2],
2542             duration: _orderValues[3],
2543             expirationTimestamp: add(now, _orderValues[3]),
2544             salt: _orderValues[4],
2545             fee: _orderValues[5],
2546             createdTimestamp: now,
2547             orderHash: bytes32(0),
2548             trade: trade
2549         });
2550 
2551         order.orderHash = _generateOrderHash(order);
2552     
2553         return order;
2554     }
2555 
2556     function _composeTrade
2557     (
2558         address _tradeToken,
2559         address _closingToken,
2560         uint _stopProfit,
2561         uint _stopLoss
2562     )
2563         internal 
2564         pure
2565         returns (Trade _trade)
2566     {
2567         _trade = Trade({
2568             tradeToken: _tradeToken,
2569             closingToken: _closingToken,
2570             stopProfit: _stopProfit,
2571             stopLoss: _stopLoss,
2572             exchangeConnector: address(0)
2573         });
2574     }
2575 
2576     function _generateOrderHash(Order _order)
2577         internal
2578         view
2579         returns (bytes32 _orderHash)
2580     {
2581         return keccak256(
2582             abi.encodePacked(
2583                 address(this),
2584                 _generateOrderHash1(_order),
2585                 _generateOrderHash2(_order)
2586             )
2587         );
2588     }
2589 
2590     function _generateOrderHash1(Order _order)
2591         internal
2592         view
2593         returns (bytes32 _orderHash1) 
2594     {
2595         return keccak256(
2596             abi.encodePacked(
2597                 address(this),
2598                 _order.account,
2599                 _order.principalToken,
2600                 _order.collateralToken,
2601                 _order.principalAmount,
2602                 _order.collateralAmount,
2603                 _order.premium,
2604                 _order.duration,
2605                 _order.salt,
2606                 _order.fee
2607             )
2608         );
2609     }
2610 
2611     function _generateOrderHash2(Order _order)
2612         internal
2613         view
2614         returns (bytes32 _orderHash2)
2615     {
2616         return keccak256(
2617             abi.encodePacked(
2618                 address(this),
2619                 _order.trade.tradeToken,
2620                 _order.trade.closingToken,
2621                 _order.trade.stopProfit,
2622                 _order.trade.stopLoss,
2623                 _order.salt
2624             )
2625         );
2626     }
2627 
2628     function getAllOrders()
2629         public 
2630         view 
2631         returns 
2632         (
2633             bytes32[]
2634         )
2635     {
2636         return orders;
2637     }
2638 
2639     
2640     function getOrder(bytes32 _orderHash)
2641         public 
2642         view 
2643         returns 
2644         (
2645             address _account,
2646             address _byUser,
2647             address _principalToken,
2648             address _collateralToken,
2649             uint _principalAmount,
2650             uint _collateralAmount,
2651             uint _premium,
2652             uint _expirationTimestamp,
2653             uint _salt,
2654             uint _fee,
2655             uint _createdTimestamp
2656         )
2657     {   
2658         Order memory order = hashToOrder[_orderHash];
2659         return (
2660             order.account,
2661             order.byUser,
2662             order.principalToken,
2663             order.collateralToken,
2664             order.principalAmount,
2665             order.collateralAmount,
2666             order.premium,
2667             order.expirationTimestamp,
2668             order.salt,
2669             order.fee,
2670             order.createdTimestamp
2671         );
2672     }
2673 
2674     function getTrade(bytes32 _orderHash)
2675         public 
2676         view 
2677         returns 
2678         (
2679             address _tradeToken,
2680             address _closingToken,
2681             address _initExchangeConnector,
2682             uint _stopProfit,
2683             uint _stopLoss
2684         )
2685     {   
2686         Order memory order = hashToOrder[_orderHash];
2687         return (
2688             order.trade.tradeToken,
2689             order.trade.closingToken,
2690             order.trade.exchangeConnector,
2691             order.trade.stopProfit,
2692             order.trade.stopLoss
2693         );
2694     }
2695 
2696     function getOrdersForAccount(address _account) 
2697         public
2698         view 
2699         returns 
2700         (
2701             bytes32[]
2702         )
2703     {
2704         return accountToOrders[_account];
2705     }
2706 
2707 }