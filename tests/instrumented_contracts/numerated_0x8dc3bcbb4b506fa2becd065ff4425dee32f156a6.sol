1 pragma solidity 0.4.24;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
15     function div(uint x, uint y) internal pure returns (uint z) {
16         z = x / y;
17     }
18 
19     function min(uint x, uint y) internal pure returns (uint z) {
20         return x <= y ? x : y;
21     }
22     function max(uint x, uint y) internal pure returns (uint z) {
23         return x >= y ? x : y;
24     }
25     function imin(int x, int y) internal pure returns (int z) {
26         return x <= y ? x : y;
27     }
28     function imax(int x, int y) internal pure returns (int z) {
29         return x >= y ? x : y;
30     }
31 
32     uint constant WAD = 10 ** 18;
33     uint constant RAY = 10 ** 27;
34 
35     function wmul(uint x, uint y) internal pure returns (uint z) {
36         z = add(mul(x, y), WAD / 2) / WAD;
37     }
38     function rmul(uint x, uint y) internal pure returns (uint z) {
39         z = add(mul(x, y), RAY / 2) / RAY;
40     }
41     function wdiv(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, WAD), y / 2) / y;
43     }
44     function rdiv(uint x, uint y) internal pure returns (uint z) {
45         z = add(mul(x, RAY), y / 2) / y;
46     }
47 
48     // This famous algorithm is called "exponentiation by squaring"
49     // and calculates x^n with x as fixed-point and n as regular unsigned.
50     //
51     // It's O(log n), instead of O(n) for naive repeated multiplication.
52     //
53     // These facts are why it works:
54     //
55     //  If n is even, then x^n = (x^2)^(n/2).
56     //  If n is odd,  then x^n = x * x^(n-1),
57     //   and applying the equation for even x gives
58     //    x^n = x * (x^2)^((n-1) / 2).
59     //
60     //  Also, EVM division is flooring and
61     //    floor[(n-1) / 2] = floor[n / 2].
62     //
63     function rpow(uint x, uint n) internal pure returns (uint z) {
64         z = n % 2 != 0 ? x : RAY;
65 
66         for (n /= 2; n != 0; n /= 2) {
67             x = rmul(x, x);
68 
69             if (n % 2 != 0) {
70                 z = rmul(z, x);
71             }
72         }
73     }
74 }
75 interface ERC20 {
76 
77     function name() external view returns(string);
78     function symbol() external view returns(string);
79     function decimals() external view returns(uint8);
80     function totalSupply() external view returns (uint);
81 
82     function balanceOf(address tokenOwner) external view returns (uint balance);
83     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
84     function transfer(address to, uint tokens) external returns (bool success);
85     function approve(address spender, uint tokens) external returns (bool success);
86     function transferFrom(address from, address to, uint tokens) external returns (bool success);
87 
88     event Transfer(address indexed from, address indexed to, uint tokens);
89     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
90 }
91 contract Utils {
92 
93     modifier addressValid(address _address) {
94         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
95         _;
96     }
97 
98 }
99 contract ErrorUtils {
100 
101     event LogError(string methodSig, string errMsg);
102     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
103     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
104 
105 }
106 contract DSAuthority {
107     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
108 }
109 
110 contract DSAuthEvents {
111     event LogSetAuthority (address indexed authority);
112     event LogSetOwner     (address indexed owner);
113 }
114 
115 contract DSAuth is DSAuthEvents {
116     DSAuthority  public  authority;
117     address      public  owner;
118 
119     constructor() public {
120         owner = msg.sender;
121         emit LogSetOwner(msg.sender);
122     }
123 
124     function setOwner(address owner_)
125         public
126         auth
127     {
128         owner = owner_;
129         emit LogSetOwner(owner);
130     }
131 
132     function setAuthority(DSAuthority authority_)
133         public
134         auth
135     {
136         authority = authority_;
137         emit LogSetAuthority(authority);
138     }
139 
140     modifier auth {
141         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
142         _;
143     }
144 
145     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
146         if (src == address(this)) {
147             return true;
148         } else if (src == owner) {
149             return true;
150         } else if (authority == DSAuthority(0)) {
151             return false;
152         } else {
153             return authority.canCall(src, this, sig);
154         }
155     }
156 }
157 contract DSNote {
158     event LogNote(
159         bytes4   indexed  sig,
160         address  indexed  guy,
161         bytes32  indexed  foo,
162         bytes32  indexed  bar,
163         uint              wad,
164         bytes             fax
165     ) anonymous;
166 
167     modifier note {
168         bytes32 foo;
169         bytes32 bar;
170 
171         assembly {
172             foo := calldataload(4)
173             bar := calldataload(36)
174         }
175 
176         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
177 
178         _;
179     }
180 }
181 contract SelfAuthorized {
182     modifier authorized() {
183         require(msg.sender == address(this), "Method can only be called from this contract");
184         _;
185     }
186 }
187 contract DateTime {
188     /*
189         *  Date and Time utilities for ethereum contracts
190         *
191         */
192     struct _DateTime {
193         uint16 year;
194         uint8 month;
195         uint8 day;
196         uint8 hour;
197         uint8 minute;
198         uint8 second;
199         uint8 weekday;
200     }
201 
202     uint constant DAY_IN_SECONDS = 86400;
203     uint constant YEAR_IN_SECONDS = 31536000;
204     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
205 
206     uint constant HOUR_IN_SECONDS = 3600;
207     uint constant MINUTE_IN_SECONDS = 60;
208 
209     uint16 constant ORIGIN_YEAR = 1970;
210 
211     function isLeapYear(uint16 year) public pure returns (bool) {
212         if (year % 4 != 0) {
213             return false;
214         }
215         if (year % 100 != 0) {
216             return true;
217         }
218         if (year % 400 != 0) {
219             return false;
220         }
221         return true;
222     }
223 
224     function leapYearsBefore(uint year) public pure returns (uint) {
225         year -= 1;
226         return year / 4 - year / 100 + year / 400;
227     }
228 
229     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
230         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
231             return 31;
232         }
233         else if (month == 4 || month == 6 || month == 9 || month == 11) {
234             return 30;
235         }
236         else if (isLeapYear(year)) {
237             return 29;
238         }
239         else {
240             return 28;
241         }
242     }
243 
244     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
245         uint secondsAccountedFor = 0;
246         uint buf;
247         uint8 i;
248 
249         // Year
250         dt.year = getYear(timestamp);
251         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
252 
253         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
254         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
255 
256         // Month
257         uint secondsInMonth;
258         for (i = 1; i <= 12; i++) {
259             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
260             if (secondsInMonth + secondsAccountedFor > timestamp) {
261                 dt.month = i;
262                 break;
263             }
264             secondsAccountedFor += secondsInMonth;
265         }
266 
267         // Day
268         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
269             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
270                 dt.day = i;
271                 break;
272             }
273             secondsAccountedFor += DAY_IN_SECONDS;
274         }
275 
276         // Hour
277         dt.hour = getHour(timestamp);
278 
279         // Minute
280         dt.minute = getMinute(timestamp);
281 
282         // Second
283         dt.second = getSecond(timestamp);
284 
285         // Day of week.
286         dt.weekday = getWeekday(timestamp);
287     }
288 
289     function getYear(uint timestamp) public pure returns (uint16) {
290         uint secondsAccountedFor = 0;
291         uint16 year;
292         uint numLeapYears;
293 
294         // Year
295         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
296         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
297 
298         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
299         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
300 
301         while (secondsAccountedFor > timestamp) {
302             if (isLeapYear(uint16(year - 1))) {
303                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
304             }
305             else {
306                 secondsAccountedFor -= YEAR_IN_SECONDS;
307             }
308             year -= 1;
309         }
310         return year;
311     }
312 
313     function getMonth(uint timestamp) public pure returns (uint8) {
314         return parseTimestamp(timestamp).month;
315     }
316 
317     function getDay(uint timestamp) public pure returns (uint8) {
318         return parseTimestamp(timestamp).day;
319     }
320 
321     function getHour(uint timestamp) public pure returns (uint8) {
322         return uint8((timestamp / 60 / 60) % 24);
323     }
324 
325     function getMinute(uint timestamp) public pure returns (uint8) {
326         return uint8((timestamp / 60) % 60);
327     }
328 
329     function getSecond(uint timestamp) public pure returns (uint8) {
330         return uint8(timestamp % 60);
331     }
332 
333     function getWeekday(uint timestamp) public pure returns (uint8) {
334         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
335     }
336 
337     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
338         return toTimestamp(year, month, day, 0, 0, 0);
339     }
340 
341     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
342         return toTimestamp(year, month, day, hour, 0, 0);
343     }
344 
345     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
346         return toTimestamp(year, month, day, hour, minute, 0);
347     }
348 
349     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
350         uint16 i;
351 
352         // Year
353         for (i = ORIGIN_YEAR; i < year; i++) {
354             if (isLeapYear(i)) {
355                 timestamp += LEAP_YEAR_IN_SECONDS;
356             }
357             else {
358                 timestamp += YEAR_IN_SECONDS;
359             }
360         }
361 
362         // Month
363         uint8[12] memory monthDayCounts;
364         monthDayCounts[0] = 31;
365         if (isLeapYear(year)) {
366             monthDayCounts[1] = 29;
367         }
368         else {
369             monthDayCounts[1] = 28;
370         }
371         monthDayCounts[2] = 31;
372         monthDayCounts[3] = 30;
373         monthDayCounts[4] = 31;
374         monthDayCounts[5] = 30;
375         monthDayCounts[6] = 31;
376         monthDayCounts[7] = 31;
377         monthDayCounts[8] = 30;
378         monthDayCounts[9] = 31;
379         monthDayCounts[10] = 30;
380         monthDayCounts[11] = 31;
381 
382         for (i = 1; i < month; i++) {
383             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
384         }
385 
386         // Day
387         timestamp += DAY_IN_SECONDS * (day - 1);
388 
389         // Hour
390         timestamp += HOUR_IN_SECONDS * (hour);
391 
392         // Minute
393         timestamp += MINUTE_IN_SECONDS * (minute);
394 
395         // Second
396         timestamp += second;
397 
398         return timestamp;
399     }
400 }
401 contract WETH9 {
402     string public name     = "Wrapped Ether";
403     string public symbol   = "WETH";
404     uint8  public decimals = 18;
405 
406     event  Approval(address indexed _owner, address indexed _spender, uint _value);
407     event  Transfer(address indexed _from, address indexed _to, uint _value);
408     event  Deposit(address indexed _owner, uint _value);
409     event  Withdrawal(address indexed _owner, uint _value);
410 
411     mapping (address => uint)                       public  balanceOf;
412     mapping (address => mapping (address => uint))  public  allowance;
413 
414     function() public payable {
415         deposit();
416     }
417 
418     function deposit() public payable {
419         balanceOf[msg.sender] += msg.value;
420         Deposit(msg.sender, msg.value);
421     }
422 
423     function withdraw(uint wad) public {
424         require(balanceOf[msg.sender] >= wad);
425         balanceOf[msg.sender] -= wad;
426         msg.sender.transfer(wad);
427         Withdrawal(msg.sender, wad);
428     }
429 
430     function totalSupply() public view returns (uint) {
431         return this.balance;
432     }
433 
434     function approve(address guy, uint wad) public returns (bool) {
435         allowance[msg.sender][guy] = wad;
436         Approval(msg.sender, guy, wad);
437         return true;
438     }
439 
440     function transfer(address dst, uint wad) public returns (bool) {
441         return transferFrom(msg.sender, dst, wad);
442     }
443 
444     function transferFrom(address src, address dst, uint wad)
445         public
446         returns (bool)
447     {
448         require(balanceOf[src] >= wad);
449 
450         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
451             require(allowance[src][msg.sender] >= wad);
452             allowance[src][msg.sender] -= wad;
453         }
454 
455         balanceOf[src] -= wad;
456         balanceOf[dst] += wad;
457 
458         Transfer(src, dst, wad);
459 
460         return true;
461     }
462 }
463 
464 contract Proxy {
465 
466     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
467     address masterCopy;
468 
469     /// @dev Constructor function sets address of master copy contract.
470     /// @param _masterCopy Master copy address.
471     constructor(address _masterCopy)
472         public
473     {
474         require(_masterCopy != 0, "Invalid master copy address provided");
475         masterCopy = _masterCopy;
476     }
477 
478     /// @dev Fallback function forwards all transactions and returns all received return data.
479     function ()
480         external
481         payable
482     {
483         // solium-disable-next-line security/no-inline-assembly
484         assembly {
485             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
486             calldatacopy(0, 0, calldatasize())
487             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
488             returndatacopy(0, 0, returndatasize())
489             if eq(success, 0) { revert(0, returndatasize()) }
490             return(0, returndatasize())
491         }
492     }
493 
494     function implementation()
495         public
496         view
497         returns (address)
498     {
499         return masterCopy;
500     }
501 
502     function proxyType()
503         public
504         pure
505         returns (uint256)
506     {
507         return 2;
508     }
509 }
510 
511 contract DSStop is DSNote, DSAuth {
512 
513     bool public stopped = false;
514 
515     modifier whenNotStopped {
516         require(!stopped, "DSStop::_ FEATURE_STOPPED");
517         _;
518     }
519 
520     modifier whenStopped {
521         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
522         _;
523     }
524 
525     function stop() public auth note {
526         stopped = true;
527     }
528     function start() public auth note {
529         stopped = false;
530     }
531 
532 }
533 interface KyberNetworkProxy {
534 
535     function maxGasPrice() external view returns(uint);
536     function getUserCapInWei(address user) external view returns(uint);
537     function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
538     function enabled() external view returns(bool);
539     function info(bytes32 id) external view returns(uint);
540 
541     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) external returns(uint);
542     function swapEtherToToken(ERC20 token, uint minConversionRate) external payable returns(uint);
543     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) external returns(uint);
544 
545     function getExpectedRate
546     (
547         ERC20 src,
548         ERC20 dest, 
549         uint srcQty
550     ) 
551         external
552         view
553         returns 
554     (
555         uint expectedRate,
556         uint slippageRate
557     );
558 
559     function tradeWithHint
560     (
561         ERC20 src,
562         uint srcAmount,
563         ERC20 dest,
564         address destAddress,
565         uint maxDestAmount,
566         uint minConversionRate,
567         address walletId,
568         bytes hint
569     )
570         external 
571         payable 
572         returns(uint);
573         
574 }
575 
576 library ECRecovery {
577 
578     function recover(bytes32 _hash, bytes _sig)
579         internal
580         pure
581     returns (address)
582     {
583         bytes32 r;
584         bytes32 s;
585         uint8 v;
586 
587         if (_sig.length != 65) {
588             return (address(0));
589         }
590 
591         assembly {
592             r := mload(add(_sig, 32))
593             s := mload(add(_sig, 64))
594             v := byte(0, mload(add(_sig, 96)))
595         }
596 
597         if (v < 27) {
598             v += 27;
599         }
600 
601         if (v != 27 && v != 28) {
602             return (address(0));
603         } else {
604             return ecrecover(_hash, v, r, s);
605         }
606     }
607 
608     function toEthSignedMessageHash(bytes32 _hash)
609         internal
610         pure
611     returns (bytes32)
612     {
613         return keccak256(
614             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
615         );
616     }
617 }
618 
619 
620 contract Utils2 {
621     using ECRecovery for bytes32;
622     
623     function _recoverSigner(bytes32 _hash, bytes _signature) 
624         internal
625         pure
626         returns(address _signer)
627     {
628         return _hash.toEthSignedMessageHash().recover(_signature);
629     }
630 
631 }
632 
633 
634 contract DSThing is DSNote, DSAuth, DSMath {
635 
636     function S(string s) internal pure returns (bytes4) {
637         return bytes4(keccak256(s));
638     }
639 
640 }
641 
642 
643 contract MasterCopy is SelfAuthorized {
644   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
645   // It should also always be ensured that the address is stored alone (uses a full word)
646     address masterCopy;
647 
648   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
649   /// @param _masterCopy New contract address.
650     function changeMasterCopy(address _masterCopy)
651         public
652         authorized
653     {
654         // Master copy address cannot be null.
655         require(_masterCopy != 0, "Invalid master copy address provided");
656         masterCopy = _masterCopy;
657     }
658 }
659 
660 
661 contract Config is DSNote, DSAuth, Utils {
662 
663     WETH9 public weth9;
664     mapping (address => bool) public isAccountHandler;
665     mapping (address => bool) public isAdmin;
666     address[] public admins;
667     bool public disableAdminControl = false;
668     
669     event LogAdminAdded(address indexed _admin, address _by);
670     event LogAdminRemoved(address indexed _admin, address _by);
671 
672     constructor() public {
673         admins.push(msg.sender);
674         isAdmin[msg.sender] = true;
675     }
676 
677     modifier onlyAdmin(){
678         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
679         _;
680     }
681 
682     function setWETH9
683     (
684         address _weth9
685     ) 
686         public
687         auth
688         note
689         addressValid(_weth9) 
690     {
691         weth9 = WETH9(_weth9);
692     }
693 
694     function setAccountHandler
695     (
696         address _accountHandler,
697         bool _isAccountHandler
698     )
699         public
700         auth
701         note
702         addressValid(_accountHandler)
703     {
704         isAccountHandler[_accountHandler] = _isAccountHandler;
705     }
706 
707     function toggleAdminsControl() 
708         public
709         auth
710         note
711     {
712         disableAdminControl = !disableAdminControl;
713     }
714 
715     function isAdminValid(address _admin)
716         public
717         view
718         returns (bool)
719     {
720         if(disableAdminControl) {
721             return true;
722         } else {
723             return isAdmin[_admin];
724         }
725     }
726 
727     function getAllAdmins()
728         public
729         view
730         returns(address[])
731     {
732         return admins;
733     }
734 
735     function addAdmin
736     (
737         address _admin
738     )
739         external
740         note
741         onlyAdmin
742         addressValid(_admin)
743     {   
744         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
745 
746         admins.push(_admin);
747         isAdmin[_admin] = true;
748 
749         emit LogAdminAdded(_admin, msg.sender);
750     }
751 
752     function removeAdmin
753     (
754         address _admin
755     ) 
756         external
757         note
758         onlyAdmin
759         addressValid(_admin)
760     {   
761         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
762         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
763 
764         isAdmin[_admin] = false;
765 
766         for (uint i = 0; i < admins.length - 1; i++) {
767             if (admins[i] == _admin) {
768                 admins[i] = admins[admins.length - 1];
769                 admins.length -= 1;
770                 break;
771             }
772         }
773 
774         emit LogAdminRemoved(_admin, msg.sender);
775     }
776 }
777 
778 
779 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
780 
781     address[] public users;
782     mapping (address => bool) public isUser;
783     mapping (bytes32 => bool) public actionCompleted;
784 
785     WETH9 public weth9;
786     Config public config;
787     bool public isInitialized = false;
788 
789     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
790     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
791     event LogUserAdded(address indexed user, address by);
792     event LogUserRemoved(address indexed user, address by);
793     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
794 
795     modifier initialized() {
796         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
797         _;
798     }
799 
800     modifier notInitialized() {
801         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
802         _;
803     }
804 
805     modifier userExists(address _user) {
806         require(isUser[_user], "Account::_ INVALID_USER");
807         _;
808     }
809 
810     modifier userDoesNotExist(address _user) {
811         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
812         _;
813     }
814 
815     modifier onlyAdmin() {
816         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
817         _;
818     }
819 
820     modifier onlyHandler(){
821         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
822         _;
823     }
824 
825     function init(address _user, address _config)
826         public 
827         notInitialized
828     {
829         users.push(_user);
830         isUser[_user] = true;
831         config = Config(_config);
832         weth9 = config.weth9();
833         isInitialized = true;
834     }
835     
836     function getAllUsers() public view returns (address[]) {
837         return users;
838     }
839 
840     function balanceFor(address _token) public view returns (uint _balance){
841         _balance = ERC20(_token).balanceOf(this);
842     }
843     
844     function transferBySystem
845     (   
846         address _token,
847         address _to,
848         uint _value
849     ) 
850         external 
851         onlyHandler
852         note 
853         initialized
854     {
855         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
856         ERC20(_token).transfer(_to, _value);
857 
858         emit LogTransferBySystem(_token, _to, _value, msg.sender);
859     }
860     
861     function transferByUser
862     (   
863         address _token,
864         address _to,
865         uint _value,
866         uint _salt,
867         bytes _signature
868     )
869         external
870         addressValid(_to)
871         note
872         initialized
873         onlyAdmin
874     {
875         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
876 
877         if(actionCompleted[actionHash]) {
878             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
879             return;
880         }
881 
882         if(ERC20(_token).balanceOf(this) < _value){
883             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
884             return;
885         }
886 
887         address signer = _recoverSigner(actionHash, _signature);
888 
889         if(!isUser[signer]) {
890             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
891             return;
892         }
893 
894         actionCompleted[actionHash] = true;
895         
896         if (_token == address(weth9)) {
897             weth9.withdraw(_value);
898             _to.transfer(_value);
899         } else {
900             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
901         }
902 
903         emit LogTransferByUser(_token, _to, _value, signer);
904     }
905 
906     function addUser
907     (
908         address _user,
909         uint _salt,
910         bytes _signature
911     )
912         external 
913         note 
914         addressValid(_user)
915         userDoesNotExist(_user)
916         initialized
917         onlyAdmin
918     {   
919         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
920         if(actionCompleted[actionHash])
921         {
922             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
923             return;
924         }
925 
926         address signer = _recoverSigner(actionHash, _signature);
927 
928         if(!isUser[signer]) {
929             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
930             return;
931         }
932 
933         actionCompleted[actionHash] = true;
934 
935         users.push(_user);
936         isUser[_user] = true;
937 
938         emit LogUserAdded(_user, signer);
939     }
940 
941     function removeUser
942     (
943         address _user,
944         uint _salt,
945         bytes _signature
946     ) 
947         external
948         note
949         userExists(_user) 
950         initialized
951         onlyAdmin
952     {   
953         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
954 
955         if(actionCompleted[actionHash]) {
956             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
957             return;
958         }
959 
960         address signer = _recoverSigner(actionHash, _signature);
961         
962         if(users.length == 1){
963             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
964             return;
965         }
966         
967         if(!isUser[signer]){
968             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
969             return;
970         }
971         
972         actionCompleted[actionHash] = true;
973 
974         // should delete value from isUser map? delete isUser[_user]?
975         isUser[_user] = false;
976         for (uint i = 0; i < users.length - 1; i++) {
977             if (users[i] == _user) {
978                 users[i] = users[users.length - 1];
979                 users.length -= 1;
980                 break;
981             }
982         }
983 
984         emit LogUserRemoved(_user, signer);
985     }
986 
987     function _getTransferActionHash
988     ( 
989         address _token,
990         address _to,
991         uint _value,
992         uint _salt
993     ) 
994         internal
995         view
996         returns (bytes32)
997     {
998         return keccak256(
999             abi.encodePacked(
1000                 address(this),
1001                 _token,
1002                 _to,
1003                 _value,
1004                 _salt
1005             )
1006         );
1007     }
1008 
1009     function _getUserActionHash
1010     ( 
1011         address _user,
1012         string _action,
1013         uint _salt
1014     ) 
1015         internal
1016         view
1017         returns (bytes32)
1018     {
1019         return keccak256(
1020             abi.encodePacked(
1021                 address(this),
1022                 _user,
1023                 _action,
1024                 _salt
1025             )
1026         );
1027     }
1028 
1029     // to directly send ether to contract
1030     function() external payable {
1031         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
1032 
1033         if(msg.sender != address(weth9)){
1034             weth9.deposit.value(msg.value)();
1035         }
1036     }
1037 
1038     function changeImpl
1039     (
1040         address _to,
1041         uint _salt,
1042         bytes _signature
1043     )
1044         external 
1045         note 
1046         addressValid(_to)
1047         initialized
1048         onlyAdmin
1049     {   
1050         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
1051         if(actionCompleted[actionHash])
1052         {
1053             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
1054             return;
1055         }
1056 
1057         address signer = _recoverSigner(actionHash, _signature);
1058 
1059         if(!isUser[signer]) {
1060             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1061             return;
1062         }
1063 
1064         actionCompleted[actionHash] = true;
1065 
1066         address oldImpl = masterCopy;
1067         this.changeMasterCopy(_to);
1068         
1069         emit LogImplChanged(_to, oldImpl);
1070     }
1071 
1072 }
1073 
1074 
1075 contract AccountFactory is DSStop, Utils {
1076     Config public config;
1077     mapping (address => bool) public isAccount;
1078     mapping (address => address[]) public userToAccounts;
1079     address[] public accounts;
1080 
1081     address public accountMaster;
1082 
1083     constructor
1084     (
1085         Config _config, 
1086         address _accountMaster
1087     ) 
1088     public 
1089     {
1090         config = _config;
1091         accountMaster = _accountMaster;
1092     }
1093 
1094     event LogAccountCreated(address indexed user, address indexed account, address by);
1095 
1096     modifier onlyAdmin() {
1097         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
1098         _;
1099     }
1100 
1101     function setConfig(Config _config) external note auth addressValid(_config) {
1102         config = _config;
1103     }
1104 
1105     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
1106         accountMaster = _accountMaster;
1107     }
1108 
1109     function newAccount(address _user)
1110         public
1111         note
1112         onlyAdmin
1113         addressValid(config)
1114         addressValid(accountMaster)
1115         whenNotStopped
1116         returns 
1117         (
1118             Account _account
1119         ) 
1120     {
1121         address proxy = new Proxy(accountMaster);
1122         _account = Account(proxy);
1123         _account.init(_user, config);
1124 
1125         accounts.push(_account);
1126         userToAccounts[_user].push(_account);
1127         isAccount[_account] = true;
1128 
1129         emit LogAccountCreated(_user, _account, msg.sender);
1130     }
1131     
1132     function batchNewAccount(address[] _users) public note onlyAdmin {
1133         for (uint i = 0; i < _users.length; i++) {
1134             newAccount(_users[i]);
1135         }
1136     }
1137 
1138     function getAllAccounts() public view returns (address[]) {
1139         return accounts;
1140     }
1141 
1142     function getAccountsForUser(address _user) public view returns (address[]) {
1143         return userToAccounts[_user];
1144     }
1145 
1146 }
1147 contract Escrow is DSNote, DSAuth {
1148 
1149     event LogTransfer(address indexed token, address indexed to, uint value);
1150     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
1151 
1152     function transfer
1153     (
1154         address _token,
1155         address _to,
1156         uint _value
1157     )
1158         public
1159         note
1160         auth
1161     {
1162         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
1163         emit LogTransfer(_token, _to, _value);
1164     }
1165 
1166     function transferFromAccount
1167     (
1168         address _account,
1169         address _token,
1170         address _to,
1171         uint _value
1172     )
1173         public
1174         note
1175         auth
1176     {   
1177         Account(_account).transferBySystem(_token, _to, _value);
1178         emit LogTransferFromAccount(_account, _token, _to, _value);
1179     }
1180 
1181 }
1182 
1183 // issue with deploying multiple instances of same type in truffle, hence the following two contracts
1184 contract KernelEscrow is Escrow {
1185 
1186 }
1187 
1188 contract ReserveEscrow is Escrow {
1189     
1190 }
1191 interface ExchangeConnector {
1192 
1193     function tradeWithInputFixed
1194     (   
1195         Escrow _escrow,
1196         address _srcToken,
1197         address _destToken,
1198         uint _srcTokenValue
1199     )
1200         external
1201         returns (uint _destTokenValue, uint _srcTokenValueLeft);
1202 
1203     function tradeWithOutputFixed
1204     (   
1205         Escrow _escrow,
1206         address _srcToken,
1207         address _destToken,
1208         uint _srcTokenValue,
1209         uint _maxDestTokenValue
1210     )
1211         external
1212         returns (uint _destTokenValue, uint _srcTokenValueLeft);
1213     
1214 
1215     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
1216         external
1217         view
1218         returns(uint _expectedRate, uint _slippageRate);
1219     
1220     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
1221         external
1222         view
1223         returns(bool);
1224 
1225 }
1226 
1227 
1228 contract Reserve is DSStop, DSThing, Utils, Utils2, ErrorUtils {
1229 
1230     Escrow public escrow;
1231     AccountFactory public accountFactory;
1232     DateTime public dateTime;
1233     Config public config;
1234     uint public deployTimestamp;
1235 
1236     string constant public VERSION = "1.0.0";
1237 
1238     uint public TIME_INTERVAL = 1 days;
1239     //uint public TIME_INTERVAL = 1 hours;
1240     
1241     constructor
1242     (
1243         Escrow _escrow,
1244         AccountFactory _accountFactory,
1245         DateTime _dateTime,
1246         Config _config
1247     ) 
1248     public 
1249     {
1250         escrow = _escrow;
1251         accountFactory = _accountFactory;
1252         dateTime = _dateTime;
1253         config = _config;
1254         deployTimestamp = now - (4 * TIME_INTERVAL);
1255     }
1256 
1257     function setEscrow(Escrow _escrow) 
1258         public 
1259         note 
1260         auth
1261         addressValid(_escrow)
1262     {
1263         escrow = _escrow;
1264     }
1265 
1266     function setAccountFactory(AccountFactory _accountFactory) 
1267         public 
1268         note 
1269         auth
1270         addressValid(_accountFactory)
1271     {
1272         accountFactory = _accountFactory;
1273     }
1274 
1275     function setDateTime(DateTime _dateTime) 
1276         public 
1277         note 
1278         auth
1279         addressValid(_dateTime)
1280     {
1281         dateTime = _dateTime;
1282     }
1283 
1284     function setConfig(Config _config) 
1285         public 
1286         note 
1287         auth
1288         addressValid(_config)
1289     {
1290         config = _config;
1291     }
1292 
1293     struct Order {
1294         address account;
1295         address token;
1296         address byUser;
1297         uint value;
1298         uint duration;
1299         uint expirationTimestamp;
1300         uint salt;
1301         uint createdTimestamp;
1302         bytes32 orderHash;
1303     }
1304 
1305     bytes32[] public orders;
1306     mapping (bytes32 => Order) public hashToOrder;
1307     mapping (bytes32 => bool) public isOrder;
1308     mapping (address => bytes32[]) public accountToOrders;
1309     mapping (bytes32 => bool) public cancelledOrders;
1310 
1311     // per day
1312     mapping (uint => mapping(address => uint)) public deposits;
1313     mapping (uint => mapping(address => uint)) public withdrawals;
1314     mapping (uint => mapping(address => uint)) public profits;
1315     mapping (uint => mapping(address => uint)) public losses;
1316 
1317     mapping (uint => mapping(address => uint)) public reserves;
1318     mapping (address => uint) public lastReserveRuns;
1319 
1320     mapping (address => mapping(address => uint)) public surplus;
1321 
1322     mapping (bytes32 => CumulativeRun) public orderToCumulative;
1323 
1324     struct CumulativeRun {
1325         uint timestamp;
1326         uint value;
1327     }
1328 
1329     modifier onlyAdmin() {
1330         require(config.isAdminValid(msg.sender), "Reserve::_ INVALID_ADMIN_ACCOUNT");
1331         _;
1332     }
1333 
1334     event LogOrderCreated(
1335         bytes32 indexed orderHash,
1336         address indexed account,
1337         address indexed token,
1338         address byUser,
1339         uint value,
1340         uint expirationTimestamp
1341     );
1342 
1343     event LogOrderCancelled(
1344         bytes32 indexed orderHash,
1345         address indexed by
1346     );
1347 
1348     event LogReserveValuesUpdated(
1349         address indexed token, 
1350         uint indexed updatedTill,
1351         uint reserve,
1352         uint profit,
1353         uint loss
1354     );
1355 
1356     event LogOrderCumulativeUpdated(
1357         bytes32 indexed orderHash,
1358         uint updatedTill,
1359         uint value
1360     );
1361 
1362     event LogRelease(
1363         address indexed token,
1364         address indexed to,
1365         uint value,
1366         address by
1367     );
1368 
1369     event LogLock(
1370         address indexed token,
1371         address indexed from,
1372         uint value,
1373         uint profit,
1374         uint loss,
1375         address by
1376     );
1377 
1378     event LogLockSurplus(
1379         address indexed forToken, 
1380         address indexed token,
1381         address from,
1382         uint value
1383     );
1384 
1385     event LogTransferSurplus(
1386         address indexed forToken,
1387         address indexed token,
1388         address to, 
1389         uint value
1390     );
1391     
1392     function createOrder
1393     (
1394         address[3] _orderAddresses,
1395         uint[3] _orderValues,
1396         bytes _signature
1397     ) 
1398         public
1399         note
1400         onlyAdmin
1401         whenNotStopped
1402     {
1403         Order memory order = _composeOrder(_orderAddresses, _orderValues);
1404         address signer = _recoverSigner(order.orderHash, _signature);
1405 
1406         if(signer != order.byUser){
1407             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_ORDER_CREATOR");
1408             return;
1409         }
1410         
1411         if(isOrder[order.orderHash]){
1412             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "ORDER_ALREADY_EXISTS");
1413             return;
1414         }
1415 
1416         if(!accountFactory.isAccount(order.account)){
1417             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_ACCOUNT");
1418             return;
1419         }
1420 
1421         if(!Account(order.account).isUser(signer)){
1422             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1423             return;
1424         }
1425                 
1426         if(!_isOrderValid(order)) {
1427             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INVALID_ORDER_PARAMETERS");
1428             return;
1429         }
1430 
1431         if(ERC20(order.token).balanceOf(order.account) < order.value){
1432             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::createOrder", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
1433             return;
1434         }
1435 
1436         escrow.transferFromAccount(order.account, order.token, address(escrow), order.value);
1437         
1438         orders.push(order.orderHash);
1439         hashToOrder[order.orderHash] = order;
1440         isOrder[order.orderHash] = true;
1441         accountToOrders[order.account].push(order.orderHash);
1442 
1443         uint dateTimestamp = _getDateTimestamp(now);
1444 
1445         deposits[dateTimestamp][order.token] = add(deposits[dateTimestamp][order.token], order.value);
1446         
1447         orderToCumulative[order.orderHash].timestamp = _getDateTimestamp(order.createdTimestamp);
1448         orderToCumulative[order.orderHash].value = order.value;
1449 
1450         emit LogOrderCreated(
1451             order.orderHash,
1452             order.account,
1453             order.token,
1454             order.byUser,
1455             order.value,
1456             order.expirationTimestamp
1457         );
1458     }
1459 
1460     function cancelOrder
1461     (
1462         bytes32 _orderHash,
1463         bytes _signature
1464     )
1465         external
1466         note
1467         onlyAdmin
1468     {   
1469         if(!isOrder[_orderHash]) {
1470             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_DOES_NOT_EXIST");
1471             return;
1472         }
1473 
1474         if(cancelledOrders[_orderHash]){
1475             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "ORDER_ALREADY_CANCELLED");
1476             return;
1477         }
1478 
1479         Order memory order = hashToOrder[_orderHash];
1480 
1481         bytes32 cancelOrderHash = _generateActionOrderHash(_orderHash, "CANCEL_RESERVE_ORDER");
1482         address signer = _recoverSigner(cancelOrderHash, _signature);
1483         
1484         if(!Account(order.account).isUser(signer)){
1485             emit LogErrorWithHintBytes32(_orderHash,"Reserve::createOrder", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
1486             return;
1487         }
1488         
1489         doCancelOrder(order);
1490     }
1491     
1492     function processOrder
1493     (
1494         bytes32 _orderHash
1495     ) 
1496         external 
1497         note
1498         onlyAdmin
1499     {
1500         if(!isOrder[_orderHash]) {
1501             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_DOES_NOT_EXIST");
1502             return;
1503         }
1504 
1505         if(cancelledOrders[_orderHash]){
1506             emit LogErrorWithHintBytes32(_orderHash,"Reserve::processOrder", "ORDER_ALREADY_CANCELLED");
1507             return;
1508         }
1509 
1510         Order memory order = hashToOrder[_orderHash];
1511 
1512         if(now > _getDateTimestamp(order.expirationTimestamp)) {
1513             doCancelOrder(order);
1514         } else {
1515             emit LogErrorWithHintBytes32(order.orderHash, "Reserve::processOrder", "ORDER_NOT_EXPIRED");
1516         }
1517     }
1518 
1519     function doCancelOrder(Order _order) 
1520         internal
1521     {   
1522         uint valueToTransfer = orderToCumulative[_order.orderHash].value;
1523 
1524         if(ERC20(_order.token).balanceOf(escrow) < valueToTransfer){
1525             emit LogErrorWithHintBytes32(_order.orderHash, "Reserve::doCancel", "INSUFFICIENT_BALANCE_IN_ESCROW");
1526             return;
1527         }
1528 
1529         uint nowDateTimestamp = _getDateTimestamp(now);
1530         cancelledOrders[_order.orderHash] = true;
1531         withdrawals[nowDateTimestamp][_order.token] = add(withdrawals[nowDateTimestamp][_order.token], valueToTransfer);
1532 
1533         escrow.transfer(_order.token, _order.account, valueToTransfer);
1534         emit LogOrderCancelled(_order.orderHash, msg.sender);
1535     }
1536 
1537     function release(address _token, address _to, uint _value) 
1538         external
1539         note
1540         auth
1541     {   
1542         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::release INSUFFICIENT_BALANCE_IN_ESCROW");
1543         escrow.transfer(_token, _to, _value);
1544         emit LogRelease(_token, _to, _value, msg.sender);
1545     }
1546 
1547     // _value includes profit/loss as well
1548     function lock(address _token, address _from, uint _value, uint _profit, uint _loss)
1549         external
1550         note
1551         auth
1552     {   
1553         require(!(_profit == 0 && _loss == 0), "Reserve::lock INVALID_PROFIT_LOSS_VALUES");
1554         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lock INSUFFICIENT_BALANCE");
1555             
1556         if(accountFactory.isAccount(_from)) {
1557             escrow.transferFromAccount(_from, _token, address(escrow), _value);
1558         } else {
1559             Escrow(_from).transfer(_token, address(escrow), _value);
1560         }
1561         
1562         uint dateTimestamp = _getDateTimestamp(now);
1563 
1564         if (_profit > 0){
1565             profits[dateTimestamp][_token] = add(profits[dateTimestamp][_token], _profit);
1566         } else if (_loss > 0) {
1567             losses[dateTimestamp][_token] = add(losses[dateTimestamp][_token], _loss);
1568         }
1569 
1570         emit LogLock(_token, _from, _value, _profit, _loss, msg.sender);
1571     }
1572 
1573     // to lock collateral if cannot be liquidated e.g. not enough reserves in kyber
1574     function lockSurplus(address _from, address _forToken, address _token, uint _value) 
1575         external
1576         note
1577         auth
1578     {
1579         require(ERC20(_token).balanceOf(_from) >= _value, "Reserve::lockSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1580 
1581         Escrow(_from).transfer(_token, address(escrow), _value);
1582         surplus[_forToken][_token] = add(surplus[_forToken][_token], _value);
1583 
1584         emit LogLockSurplus(_forToken, _token, _from, _value);
1585     }
1586 
1587     // to transfer surplus collateral out of the system to trade on other platforms and put back in terms of 
1588     // principal to reserve manually using an account or surplus escrow
1589     // should work in tandem with lock method when transferring back principal
1590     function transferSurplus(address _to, address _forToken, address _token, uint _value) 
1591         external
1592         note
1593         auth
1594     {
1595         require(ERC20(_token).balanceOf(escrow) >= _value, "Reserve::transferSurplus INSUFFICIENT_BALANCE_IN_ESCROW");
1596         require(surplus[_forToken][_token] >= _value, "Reserve::transferSurplus INSUFFICIENT_SURPLUS");
1597 
1598         surplus[_forToken][_token] = sub(surplus[_forToken][_token], _value);
1599         escrow.transfer(_token, _to, _value);
1600 
1601         emit LogTransferSurplus(_forToken, _token, _to, _value);
1602     }
1603 
1604     function updateReserveValues(address _token, uint _forDays)
1605         public
1606         note
1607         onlyAdmin
1608     {   
1609         uint lastReserveRun = lastReserveRuns[_token];
1610 
1611         if (lastReserveRun == 0) {
1612             lastReserveRun = _getDateTimestamp(deployTimestamp) - TIME_INTERVAL;
1613         }
1614 
1615         uint nowDateTimestamp = _getDateTimestamp(now);
1616         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastReserveRun) / TIME_INTERVAL;
1617 
1618         if(updatesLeft == 0) {
1619             emit LogErrorWithHintAddress(_token, "Reserve::updateReserveValues", "RESERVE_VALUES_UP_TO_DATE");
1620             return;
1621         }
1622 
1623         uint counter = updatesLeft;
1624 
1625         if(updatesLeft > _forDays && _forDays > 0) {
1626             counter = _forDays;
1627         }
1628 
1629         for (uint i = 0; i < counter; i++) {
1630             reserves[lastReserveRun + TIME_INTERVAL][_token] = sub(
1631                 sub(
1632                     add(
1633                         add(
1634                             reserves[lastReserveRun][_token],
1635                             deposits[lastReserveRun + TIME_INTERVAL][_token]
1636                         ),
1637                         profits[lastReserveRun + TIME_INTERVAL][_token]
1638                     ),
1639                     losses[lastReserveRun + TIME_INTERVAL][_token]
1640                 ),
1641                 withdrawals[lastReserveRun + TIME_INTERVAL][_token]
1642             );
1643             lastReserveRuns[_token] = lastReserveRun + TIME_INTERVAL;
1644             lastReserveRun = lastReserveRuns[_token];
1645             
1646             emit LogReserveValuesUpdated(
1647                 _token,
1648                 lastReserveRun,
1649                 reserves[lastReserveRun][_token],
1650                 profits[lastReserveRun][_token],
1651                 losses[lastReserveRun][_token]
1652             );
1653             
1654         }
1655     }
1656 
1657     function updateOrderCumulativeValueBatch(bytes32[] _orderHashes, uint[] _forDays) 
1658         public
1659         note
1660         onlyAdmin
1661     {   
1662         if(_orderHashes.length != _forDays.length) {
1663             emit LogError("Reserve::updateOrderCumulativeValueBatch", "ARGS_ARRAYLENGTH_MISMATCH");
1664             return;
1665         }
1666 
1667         for(uint i = 0; i < _orderHashes.length; i++) {
1668             updateOrderCumulativeValue(_orderHashes[i], _forDays[i]);
1669         }
1670     }
1671 
1672     function updateOrderCumulativeValue
1673     (
1674         bytes32 _orderHash, 
1675         uint _forDays
1676     ) 
1677         public
1678         note
1679         onlyAdmin 
1680     {
1681         if(!isOrder[_orderHash]) {
1682             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_DOES_NOT_EXIST");
1683             return;
1684         }
1685 
1686         if(cancelledOrders[_orderHash]) {
1687             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_ALREADY_CANCELLED");
1688             return;
1689         }
1690         
1691         Order memory order = hashToOrder[_orderHash];
1692         CumulativeRun storage cumulativeRun = orderToCumulative[_orderHash];
1693         
1694         uint profitsAccrued = 0;
1695         uint lossesAccrued = 0;
1696         uint cumulativeValue = 0;
1697         uint counter = 0;
1698 
1699         uint lastOrderRun = cumulativeRun.timestamp;
1700         uint nowDateTimestamp = _getDateTimestamp(now);
1701 
1702         uint updatesLeft = ((nowDateTimestamp - TIME_INTERVAL) - lastOrderRun) / TIME_INTERVAL;
1703 
1704         if(updatesLeft == 0) {
1705             emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "ORDER_VALUES_UP_TO_DATE");
1706             return;
1707         }
1708 
1709         counter = updatesLeft;
1710 
1711         if(updatesLeft > _forDays && _forDays > 0) {
1712             counter = _forDays;
1713         }
1714 
1715         for (uint i = 0; i < counter; i++){
1716             cumulativeValue = cumulativeRun.value;
1717             lastOrderRun = cumulativeRun.timestamp;
1718 
1719             if(lastReserveRuns[order.token] < lastOrderRun) {
1720                 emit LogErrorWithHintBytes32(_orderHash, "Reserve::updateOrderCumulativeValue", "RESERVE_VALUES_NOT_UPDATED");
1721                 emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1722                 return;
1723             }
1724 
1725             profitsAccrued = div(
1726                 mul(profits[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1727                 reserves[lastOrderRun][order.token]
1728             );
1729                 
1730             lossesAccrued = div(
1731                 mul(losses[lastOrderRun + TIME_INTERVAL][order.token], cumulativeValue),
1732                 reserves[lastOrderRun][order.token]
1733             );
1734 
1735             cumulativeValue = sub(add(cumulativeValue, profitsAccrued), lossesAccrued);
1736 
1737             cumulativeRun.timestamp = lastOrderRun + TIME_INTERVAL;
1738             cumulativeRun.value = cumulativeValue;
1739         }
1740         
1741         emit LogOrderCumulativeUpdated(_orderHash, cumulativeRun.timestamp, cumulativeRun.value);
1742     }
1743 
1744     function getAllOrders() 
1745         public
1746         view 
1747         returns 
1748         (
1749             bytes32[]
1750         ) 
1751     {
1752         return orders;
1753     }
1754 
1755     function getOrdersForAccount(address _account) 
1756         public
1757         view 
1758         returns 
1759         (
1760             bytes32[]
1761         )
1762     {
1763         return accountToOrders[_account];
1764     }
1765 
1766     function getOrder(bytes32 _orderHash)
1767         public 
1768         view 
1769         returns 
1770         (
1771             address _account,
1772             address _token,
1773             address _byUser,
1774             uint _value,
1775             uint _expirationTimestamp,
1776             uint _salt,
1777             uint _createdTimestamp
1778         )
1779     {   
1780         Order memory order = hashToOrder[_orderHash];
1781         return (
1782             order.account,
1783             order.token,
1784             order.byUser,
1785             order.value,
1786             order.expirationTimestamp,
1787             order.salt,
1788             order.createdTimestamp
1789         );
1790     }
1791 
1792     function _isOrderValid(Order _order)
1793         internal
1794         view
1795         returns (bool)
1796     {
1797         if(_order.account == address(0) || _order.byUser == address(0)
1798          || _order.value <= 0
1799          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
1800             return false;
1801         }
1802 
1803         if(isOrder[_order.orderHash]) {
1804             return false;
1805         }
1806 
1807         if(cancelledOrders[_order.orderHash]) {
1808             return false;
1809         }
1810 
1811         return true;
1812     }
1813 
1814     function _composeOrder(address[3] _orderAddresses, uint[3] _orderValues)
1815         internal
1816         view
1817         returns (Order _order)
1818     {
1819         Order memory order = Order({
1820             account: _orderAddresses[0],
1821             token: _orderAddresses[1],
1822             byUser: _orderAddresses[2],
1823             value: _orderValues[0],
1824             createdTimestamp: now,
1825             duration: _orderValues[1],
1826             expirationTimestamp: add(now, _orderValues[1]),
1827             salt: _orderValues[2],
1828             orderHash: bytes32(0)
1829         });
1830 
1831         order.orderHash = _generateCreateOrderHash(order);
1832 
1833         return order;
1834     }
1835 
1836     function _generateCreateOrderHash(Order _order)
1837         internal
1838         pure //view
1839         returns (bytes32 _orderHash)
1840     {
1841         return keccak256(
1842             abi.encodePacked(
1843  //              address(this),
1844                 _order.account,
1845                 _order.token,
1846                 _order.value,
1847                 _order.duration,
1848                 _order.salt
1849             )
1850         );
1851     }
1852 
1853     function _generateActionOrderHash
1854     (
1855         bytes32 _orderHash,
1856         string _action
1857     )
1858         internal
1859         pure //view
1860         returns (bytes32 _repayOrderHash)
1861     {
1862         return keccak256(
1863             abi.encodePacked(
1864 //                address(this),
1865                 _orderHash,
1866                 _action
1867             )
1868         );
1869     }
1870 
1871     function _getDateTimestamp(uint _timestamp) 
1872         internal
1873         view
1874         returns (uint)
1875     {
1876         // 1 day
1877         return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp));
1878         // 1 hour
1879         //return dateTime.toTimestamp(dateTime.getYear(_timestamp), dateTime.getMonth(_timestamp), dateTime.getDay(_timestamp), dateTime.getHour(_timestamp));
1880     } 
1881 
1882 }
1883 contract KyberConnector is ExchangeConnector, DSThing, Utils {
1884     KyberNetworkProxy public kyber;
1885     address public feeWallet;
1886 
1887     uint constant internal KYBER_MAX_QTY = (10**28);
1888 
1889     constructor(KyberNetworkProxy _kyber, address _feeWallet) public {
1890         kyber = _kyber;
1891         feeWallet = _feeWallet;
1892     }
1893 
1894     function setKyber(KyberNetworkProxy _kyber) 
1895         public
1896         auth
1897         addressValid(_kyber)
1898     {
1899         kyber = _kyber;
1900     }
1901 
1902     function setFeeWallet(address _feeWallet) 
1903         public 
1904         note 
1905         auth
1906         addressValid(_feeWallet)
1907     {
1908         feeWallet = _feeWallet;
1909     }
1910     
1911 
1912     event LogTrade
1913     (
1914         address indexed _from,
1915         address indexed _srcToken,
1916         address indexed _destToken,
1917         uint _srcTokenValue,
1918         uint _maxDestTokenValue,
1919         uint _destTokenValue,
1920         uint _srcTokenValueLeft,
1921         uint _exchangeRate
1922     );
1923 
1924     function tradeWithInputFixed
1925     (   
1926         Escrow _escrow,
1927         address _srcToken,
1928         address _destToken,
1929         uint _srcTokenValue
1930     )
1931         public    
1932         note
1933         auth
1934         returns (uint _destTokenValue, uint _srcTokenValueLeft)
1935     {
1936         return tradeWithOutputFixed(_escrow, _srcToken, _destToken, _srcTokenValue, KYBER_MAX_QTY);
1937     }
1938 
1939     function tradeWithOutputFixed
1940     (   
1941         Escrow _escrow,
1942         address _srcToken,
1943         address _destToken,
1944         uint _srcTokenValue,
1945         uint _maxDestTokenValue
1946     )
1947         public
1948         note
1949         auth
1950         returns (uint _destTokenValue, uint _srcTokenValueLeft)
1951     {   
1952         require(_srcToken != _destToken, "KyberConnector::tradeWithOutputFixed TOKEN_ADDRS_SHOULD_NOT_MATCH");
1953 
1954         uint _slippageRate;
1955         (, _slippageRate) = getExpectedRate(_srcToken, _destToken, _srcTokenValue);
1956 
1957         uint initialSrcTokenBalance = ERC20(_srcToken).balanceOf(this);
1958 
1959         require(ERC20(_srcToken).balanceOf(_escrow) >= _srcTokenValue, "KyberConnector::tradeWithOutputFixed INSUFFICIENT_BALANCE_IN_ESCROW");
1960         _escrow.transfer(_srcToken, this, _srcTokenValue);
1961 
1962         require(ERC20(_srcToken).approve(kyber, 0), "KyberConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
1963         require(ERC20(_srcToken).approve(kyber, _srcTokenValue), "KyberConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
1964         
1965         _destTokenValue = kyber.tradeWithHint(
1966             ERC20(_srcToken),
1967             _srcTokenValue,
1968             ERC20(_destToken),
1969             this,
1970             _maxDestTokenValue,
1971             _slippageRate, // no min coversation rate
1972             feeWallet, 
1973             new bytes(0)
1974         );
1975 
1976         _srcTokenValueLeft = sub(ERC20(_srcToken).balanceOf(this), initialSrcTokenBalance);
1977 
1978         require(_transfer(_destToken, _escrow, _destTokenValue), "KyberConnector::tradeWithOutputFixed DEST_TOKEN_TRANSFER_FAILED");
1979         
1980         if(_srcTokenValueLeft > 0) {
1981             require(_transfer(_srcToken, _escrow, _srcTokenValueLeft), "KyberConnector::tradeWithOutputFixed SRC_TOKEN_TRANSFER_FAILED");
1982         }
1983 
1984         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _maxDestTokenValue, _destTokenValue, _srcTokenValueLeft, _slippageRate);
1985     } 
1986 
1987     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
1988         public
1989         view
1990         returns(uint _expectedRate, uint _slippageRate)
1991     {
1992         (_expectedRate, _slippageRate) = kyber.getExpectedRate(ERC20(_srcToken), ERC20(_destToken), _srcTokenValue);
1993     }
1994 
1995     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
1996         public
1997         view
1998         returns(bool)
1999     {
2000         uint slippageRate; 
2001 
2002         (, slippageRate) = getExpectedRate(
2003             _srcToken,
2004             _destToken,
2005             _srcTokenValue
2006         );
2007 
2008         return slippageRate != 0;
2009     }
2010 
2011     function _transfer
2012     (
2013         address _token,
2014         address _to,
2015         uint _value
2016     )
2017         internal
2018         returns (bool)
2019     {
2020         return ERC20(_token).transfer(_to, _value);
2021     }
2022 }
2023 contract Kernel is DSStop, DSThing, Utils, Utils2, ErrorUtils {
2024 
2025     Escrow public escrow;
2026     AccountFactory public accountFactory;
2027     Reserve public reserve;
2028     address public feeWallet;
2029     Config public config;
2030     KyberConnector public kyberConnector;
2031     
2032     string constant public VERSION = "1.0.0";
2033 
2034     constructor
2035     (
2036         Escrow _escrow,
2037         AccountFactory _accountFactory,
2038         Reserve _reserve,
2039         address _feeWallet,
2040         Config _config,
2041         KyberConnector _kyberConnector
2042     ) 
2043     public 
2044     {
2045         escrow = _escrow;
2046         accountFactory = _accountFactory;
2047         reserve = _reserve;
2048         feeWallet = _feeWallet;
2049         config = _config;
2050         kyberConnector = _kyberConnector;
2051     }
2052 
2053     function setEscrow(Escrow _escrow) 
2054         public 
2055         note 
2056         auth
2057         addressValid(_escrow)
2058     {
2059         escrow = _escrow;
2060     }
2061 
2062     function setAccountFactory(AccountFactory _accountFactory)
2063         public 
2064         note 
2065         auth
2066         addressValid(_accountFactory)
2067     {
2068         accountFactory = _accountFactory;
2069     }
2070 
2071     function setReserve(Reserve _reserve)
2072         public 
2073         note 
2074         auth
2075         addressValid(_reserve)
2076     {
2077         reserve = _reserve;
2078     }
2079 
2080     function setConfig(Config _config)
2081         public 
2082         note 
2083         auth
2084         addressValid(_config)
2085     {
2086         config = _config;
2087     }
2088 
2089     function setKyberConnector(KyberConnector _kyberConnector)
2090         public 
2091         note 
2092         auth
2093         addressValid(_kyberConnector)
2094     {
2095         kyberConnector = _kyberConnector;
2096     }
2097 
2098     function setFeeWallet(address _feeWallet) 
2099         public 
2100         note 
2101         auth
2102         addressValid(_feeWallet)
2103     {
2104         feeWallet = _feeWallet;
2105     }
2106 
2107     event LogOrderCreated(
2108         bytes32 indexed orderHash,
2109         address indexed account,
2110         address indexed principalToken,
2111         address collateralToken,
2112         address byUser,
2113         uint principalAmount,
2114         uint collateralAmount,
2115         uint premium, // should be in wad?
2116         uint expirationTimestamp,
2117         uint fee
2118     );
2119 
2120     event LogOrderRepaid(
2121         bytes32 indexed orderHash,
2122         uint  valueRepaid
2123     );
2124 
2125     event LogOrderDefaulted(
2126         bytes32 indexed orderHash,
2127         string reason
2128     );
2129 
2130     struct Order {
2131         address account;
2132         address byUser;
2133         address principalToken; 
2134         address collateralToken;
2135         uint principalAmount;
2136         uint collateralAmount;
2137         uint premium;
2138         uint duration;
2139         uint expirationTimestamp;
2140         uint salt;
2141         uint fee;
2142         uint createdTimestamp;
2143         bytes32 orderHash;
2144     }
2145 
2146     bytes32[] public orders;
2147     mapping (bytes32 => Order) public hashToOrder;
2148     mapping (bytes32 => bool) public isOrder;
2149     mapping (address => bytes32[]) public accountToOrders;
2150     
2151     mapping (bytes32 => bool) public isRepaid;
2152     mapping (bytes32 => bool) public isDefaulted;
2153 
2154     modifier onlyAdmin() {
2155         require(config.isAdminValid(msg.sender), "Kernel::_ INVALID_ADMIN_ACCOUNT");
2156         _;
2157     }
2158 
2159     // add price to check collateralisation ratio?
2160     function createOrder
2161     (
2162         address[4] _orderAddresses,
2163         uint[6] _orderValues,
2164         bytes _signature
2165     )    
2166         external
2167         note
2168         onlyAdmin
2169         whenNotStopped
2170     {   
2171         Order memory order = _composeOrder(_orderAddresses, _orderValues);
2172         address signer = _recoverSigner(order.orderHash, _signature);
2173 
2174         if(signer != order.byUser) {
2175             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","SIGNER_NOT_ORDER_CREATOR");
2176             return;
2177         }
2178 
2179         if(isOrder[order.orderHash]){
2180             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","ORDER_ALREADY_EXISTS");
2181             return;
2182         }
2183 
2184         if(!accountFactory.isAccount(order.account)){
2185             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INVALID_ORDER_ACCOUNT");
2186             return;
2187         }
2188 
2189         if(!Account(order.account).isUser(signer)) {
2190             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2191             return;
2192         }
2193 
2194         if(!_isOrderValid(order)){
2195             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INVALID_ORDER_PARAMETERS");
2196             return;
2197         }
2198 
2199         if(ERC20(order.collateralToken).balanceOf(order.account) < order.collateralAmount){
2200             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INSUFFICIENT_COLLATERAL_IN_ACCOUNT");
2201             return;
2202         }
2203 
2204         if(ERC20(order.principalToken).balanceOf(reserve.escrow()) < order.principalAmount){
2205             emit LogErrorWithHintBytes32(order.orderHash, "Kernel::createOrder","INSUFFICIENT_FUNDS_IN_RESERVE");
2206             return;
2207         }
2208         
2209         orders.push(order.orderHash);
2210         hashToOrder[order.orderHash] = order;
2211         isOrder[order.orderHash] = true;
2212         accountToOrders[order.account].push(order.orderHash);
2213 
2214         escrow.transferFromAccount(order.account, order.collateralToken, address(escrow), order.collateralAmount);
2215         reserve.release(order.principalToken, order.account, order.principalAmount);
2216     
2217         emit LogOrderCreated(
2218             order.orderHash,
2219             order.account,
2220             order.principalToken,
2221             order.collateralToken,
2222             order.byUser,
2223             order.principalAmount,
2224             order.collateralAmount,
2225             order.premium,
2226             order.expirationTimestamp,
2227             order.fee
2228         );
2229     }
2230 
2231     function getExpectedRepayValue(bytes32 _orderHash) 
2232         public
2233         view
2234         returns (uint)
2235     {
2236         Order memory order = hashToOrder[_orderHash];
2237         uint profits = sub(div(mul(order.principalAmount, order.premium), WAD), order.fee);
2238         uint valueToRepay = add(order.principalAmount, profits);
2239 
2240         return valueToRepay;
2241     }
2242 
2243     function repay
2244     (
2245         bytes32 _orderHash,
2246         uint _value,
2247         bytes _signature
2248     ) 
2249         external
2250         note
2251         onlyAdmin
2252     {   
2253         if(!isOrder[_orderHash]){
2254             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_DOES_NOT_EXIST");
2255             return;
2256         }
2257 
2258         if(isRepaid[_orderHash]){
2259             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_ALREADY_REPAID");
2260             return;
2261         }
2262 
2263         if(isDefaulted[_orderHash]){
2264             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","ORDER_ALREADY_DEFAULTED");
2265             return;
2266         }
2267         
2268         bytes32 repayOrderHash = _generateRepayOrderHash(_orderHash, _value);
2269         address signer = _recoverSigner(repayOrderHash, _signature);
2270 
2271         Order memory order = hashToOrder[_orderHash];
2272         
2273         if(!Account(order.account).isUser(signer)){
2274             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
2275             return;
2276         }
2277 
2278         if(ERC20(order.principalToken).balanceOf(order.account) < _value){
2279             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","INSUFFICIENT_BALANCE_IN_ACCOUNT");
2280             return;
2281         }
2282 
2283         uint profits = sub(div(mul(order.principalAmount, order.premium), WAD), order.fee);
2284         uint valueToRepay = add(order.principalAmount, profits);
2285 
2286         if(valueToRepay > _value){
2287             emit LogErrorWithHintBytes32(_orderHash, "Kernel::repay","INSUFFICIENT_REPAYMENT");
2288             return;
2289         }
2290 
2291         if(order.fee > 0) {
2292             escrow.transferFromAccount(order.account, order.principalToken, feeWallet, order.fee);
2293         }
2294 
2295         reserve.lock(order.principalToken, order.account, valueToRepay, profits, 0);
2296         escrow.transfer(order.collateralToken, order.account, order.collateralAmount);
2297 
2298         isRepaid[order.orderHash] = true;
2299 
2300         emit LogOrderRepaid(
2301             order.orderHash,
2302             _value
2303         );
2304     }
2305 
2306     function process
2307     (
2308         bytes32 _orderHash,
2309         uint _principalPerCollateral // in WAD
2310     )
2311         external
2312         note
2313         onlyAdmin
2314     {   
2315         if(!isOrder[_orderHash]){
2316             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_DOES_NOT_EXIST");
2317             return;
2318         }
2319 
2320         if(isRepaid[_orderHash]){
2321             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_ALREADY_REPAID");
2322             return;
2323         }
2324 
2325         if(isDefaulted[_orderHash]){
2326             emit LogErrorWithHintBytes32(_orderHash, "Kernel::process","ORDER_ALREADY_DEFAULTED");
2327             return;
2328         }
2329 
2330         Order memory order = hashToOrder[_orderHash];
2331 
2332         bool isDefault = false;
2333         string memory reason = "";
2334 
2335         if(now > order.expirationTimestamp) {
2336             isDefault = true;
2337             reason = "DUE_DATE_PASSED";
2338         } else if (!_isCollateralizationSafe(order, _principalPerCollateral)) {
2339             isDefault = true;
2340             reason = "COLLATERAL_UNSAFE";
2341         }
2342 
2343         isDefaulted[_orderHash] = isDefault;
2344 
2345         if(isDefault) {
2346             _performLiquidation(order);
2347             emit LogOrderDefaulted(order.orderHash, reason);
2348         }
2349 
2350     }
2351 
2352     function _performLiquidation(Order _order) 
2353         internal
2354     {
2355         uint premiumValue = div(mul(_order.principalAmount, _order.premium), WAD);
2356         uint valueToRepay = add(_order.principalAmount, premiumValue);
2357 
2358         uint principalFromCollateral;
2359         uint collateralLeft;
2360         
2361         (principalFromCollateral, collateralLeft) = kyberConnector.tradeWithOutputFixed(
2362             escrow,
2363             ERC20(_order.collateralToken), 
2364             ERC20(_order.principalToken),
2365             _order.collateralAmount,
2366             valueToRepay
2367         );
2368 
2369         if (principalFromCollateral >= valueToRepay) {
2370             if(_order.fee > 0) {
2371                 escrow.transfer(_order.principalToken, feeWallet, _order.fee);
2372             }
2373 
2374             reserve.lock(
2375                 _order.principalToken,
2376                 escrow,
2377                 sub(principalFromCollateral, _order.fee),
2378                 sub(sub(principalFromCollateral,_order.principalAmount), _order.fee),
2379                 0
2380             );
2381 
2382             escrow.transfer(_order.collateralToken, _order.account, collateralLeft);
2383 
2384         } else if((principalFromCollateral < valueToRepay) && (principalFromCollateral >= _order.principalAmount)) {
2385 
2386             reserve.lock(
2387                 _order.principalToken,
2388                 escrow,
2389                 principalFromCollateral,
2390                 sub(principalFromCollateral, _order.principalAmount),
2391                 0
2392             );
2393 
2394         } else {
2395 
2396             reserve.lock(
2397                 _order.principalToken,
2398                 escrow,
2399                 principalFromCollateral,
2400                 0,
2401                 sub(_order.principalAmount, principalFromCollateral)
2402             );
2403 
2404         }
2405     }
2406 
2407     function _isCollateralizationSafe(Order _order, uint _principalPerCollateral)
2408         internal 
2409         pure
2410         returns (bool)
2411     {
2412         uint totalCollateralValueInPrincipal = div(
2413             mul(_order.collateralAmount, _principalPerCollateral),
2414             WAD);
2415         
2416         uint premiumValue = div(mul(_order.principalAmount, _order.premium), WAD);
2417         uint premiumValueBuffer = div(mul(premiumValue, 3), 100); // hardcoded -> can be passed through order?
2418         uint valueToRepay = add(add(_order.principalAmount, premiumValue), premiumValueBuffer);
2419 
2420         if (totalCollateralValueInPrincipal < valueToRepay) {
2421             return false;
2422         }
2423 
2424         return true;
2425     }
2426 
2427     function _generateRepayOrderHash
2428     (
2429         bytes32 _orderHash,
2430         uint _value
2431     )
2432         internal
2433         view
2434         returns (bytes32 _repayOrderHash)
2435     {
2436         return keccak256(
2437             abi.encodePacked(
2438                 address(this),
2439                 _orderHash,
2440                 _value
2441             )
2442         );
2443     }
2444 
2445     function _isOrderValid(Order _order)
2446         internal
2447         pure
2448         returns (bool)
2449     {
2450         if(_order.account == address(0) || _order.byUser == address(0) 
2451          || _order.principalToken == address(0) || _order.collateralToken == address(0) 
2452          || (_order.collateralToken == _order.principalToken)
2453          || _order.principalAmount <= 0 || _order.collateralAmount <= 0
2454          || _order.premium <= 0
2455          || _order.expirationTimestamp <= _order.createdTimestamp || _order.salt <= 0) {
2456             return false;
2457         }
2458 
2459         return true;
2460     }
2461 
2462     function _composeOrder
2463     (
2464         address[4] _orderAddresses,
2465         uint[6] _orderValues
2466     )
2467         internal
2468         view
2469         returns (Order _order)
2470     {
2471         Order memory order = Order({
2472             account: _orderAddresses[0], 
2473             byUser: _orderAddresses[1],
2474             principalToken: _orderAddresses[2],
2475             collateralToken: _orderAddresses[3],
2476             principalAmount: _orderValues[0],
2477             collateralAmount: _orderValues[1],
2478             premium: _orderValues[2],
2479             duration: _orderValues[3],
2480             expirationTimestamp: add(now, _orderValues[3]),
2481             salt: _orderValues[4],
2482             fee: _orderValues[5],
2483             createdTimestamp: now,
2484             orderHash: bytes32(0)
2485         });
2486 
2487         order.orderHash = _generateOrderHash(order);
2488     
2489         return order;
2490     }
2491 
2492     function _generateOrderHash(Order _order)
2493         internal
2494         view
2495         returns (bytes32 _orderHash)
2496     {
2497         return keccak256(
2498             abi.encodePacked(
2499                 address(this),
2500                 _order.account,
2501                 _order.principalToken,
2502                 _order.collateralToken,
2503                 _order.principalAmount,
2504                 _order.collateralAmount,
2505                 _order.premium,
2506                 _order.duration,
2507                 _order.salt,
2508                 _order.fee
2509             )
2510         );
2511     }
2512 
2513     function getAllOrders()
2514         public 
2515         view
2516         returns 
2517         (
2518             bytes32[]
2519         )
2520     {
2521         return orders;
2522     }
2523 
2524     function getOrder(bytes32 _orderHash)
2525         public 
2526         view 
2527         returns 
2528         (
2529             address _account,
2530             address _byUser,
2531             address _principalToken,
2532             address _collateralToken,
2533             uint _principalAmount,
2534             uint _collateralAmount,
2535             uint _premium,
2536             uint _expirationTimestamp,
2537             uint _salt,
2538             uint _fee,
2539             uint _createdTimestamp
2540         )
2541     {   
2542         Order memory order = hashToOrder[_orderHash];
2543         return (
2544             order.account,
2545             order.byUser,
2546             order.principalToken,
2547             order.collateralToken,
2548             order.principalAmount,
2549             order.collateralAmount,
2550             order.premium,
2551             order.expirationTimestamp,
2552             order.salt,
2553             order.fee,
2554             order.createdTimestamp
2555         );
2556     }
2557 
2558     function getOrdersForAccount(address _account) 
2559         public
2560         view 
2561         returns
2562         (
2563             bytes32[]
2564         )
2565     {
2566         return accountToOrders[_account];
2567     }
2568 
2569 }