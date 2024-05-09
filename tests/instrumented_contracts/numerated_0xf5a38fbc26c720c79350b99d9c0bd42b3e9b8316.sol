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
75 
76 contract ErrorUtils {
77     event LogError(string methodSig, string errMsg);
78     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
79     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
80 
81 }
82 
83 
84 contract Proxy {
85 
86     address masterCopy;
87 
88     constructor(address _masterCopy)
89         public
90     {
91         require(_masterCopy != 0, "Invalid master copy address provided");
92         masterCopy = _masterCopy;
93     }
94 
95     function ()
96         external
97         payable
98     {
99         // solium-disable-next-line security/no-inline-assembly
100         assembly {
101             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
102             calldatacopy(0, 0, calldatasize())
103             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
104             returndatacopy(0, 0, returndatasize())
105             if eq(success, 0) { revert(0, returndatasize()) }
106             return(0, returndatasize())
107         }
108     }
109 
110     function implementation()
111         public
112         view
113         returns (address)
114     {
115         return masterCopy;
116     }
117 
118     function proxyType()
119         public
120         pure
121         returns (uint256)
122     {
123         return 2;
124     }
125 }
126 
127 
128 contract DSAuthority {
129     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
130 }
131 
132 
133 contract DSAuthEvents {
134     event LogSetAuthority (address indexed authority);
135     event LogSetOwner     (address indexed owner);
136 }
137 
138 
139 contract DSAuth is DSAuthEvents {
140     DSAuthority  public  authority;
141     address      public  owner;
142 
143     constructor() public {
144         owner = msg.sender;
145         emit LogSetOwner(msg.sender);
146     }
147 
148     function setOwner(address owner_)
149         public
150         auth
151     {
152         owner = owner_;
153         emit LogSetOwner(owner);
154     }
155 
156     function setAuthority(DSAuthority authority_)
157         public
158         auth
159     {
160         authority = authority_;
161         emit LogSetAuthority(authority);
162     }
163 
164     modifier auth {
165         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
166         _;
167     }
168 
169     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
170         if (src == address(this)) {
171             return true;
172         } else if (src == owner) {
173             return true;
174         } else if (authority == DSAuthority(0)) {
175             return false;
176         } else {
177             return authority.canCall(src, this, sig);
178         }
179     }
180 }
181 
182 contract DSNote {
183     event LogNote(
184         bytes4   indexed  sig,
185         address  indexed  guy,
186         bytes32  indexed  foo,
187         bytes32  indexed  bar,
188         uint              wad,
189         bytes             fax
190     ) anonymous;
191 
192     modifier note {
193         bytes32 foo;
194         bytes32 bar;
195 
196         assembly {
197             foo := calldataload(4)
198             bar := calldataload(36)
199         }
200 
201         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
202 
203         _;
204     }
205 }
206 
207 
208 interface ERC20 {
209 
210     function name() public view returns(string);
211     function symbol() public view returns(string);
212     function decimals() public view returns(uint8);
213     function totalSupply() public view returns (uint);
214 
215     function balanceOf(address tokenOwner) public view returns (uint balance);
216     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
217     function transfer(address to, uint tokens) public returns (bool success);
218     function approve(address spender, uint tokens) public returns (bool success);
219     function transferFrom(address from, address to, uint tokens) public returns (bool success);
220 
221     event Transfer(address indexed from, address indexed to, uint tokens);
222     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
223 }
224 
225 
226 contract MasterCopy {
227     address masterCopy;
228 
229     function changeMasterCopy(address _masterCopy)
230         public
231     {
232         require(_masterCopy != 0, "Invalid master copy address provided");
233         masterCopy = _masterCopy;
234     }
235 }
236 
237 contract Utils {
238 
239     modifier addressValid(address _address) {
240         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
241         _;
242     }
243 
244 }
245 
246 
247 contract WETH9 {
248     string public name     = "Wrapped Ether";
249     string public symbol   = "WETH";
250     uint8  public decimals = 18;
251 
252     event  Approval(address indexed _owner, address indexed _spender, uint _value);
253     event  Transfer(address indexed _from, address indexed _to, uint _value);
254     event  Deposit(address indexed _owner, uint _value);
255     event  Withdrawal(address indexed _owner, uint _value);
256 
257     mapping (address => uint)                       public  balanceOf;
258     mapping (address => mapping (address => uint))  public  allowance;
259 
260     function() public payable {
261         deposit();
262     }
263 
264     function deposit() public payable {
265         balanceOf[msg.sender] += msg.value;
266         Deposit(msg.sender, msg.value);
267     }
268 
269     function withdraw(uint wad) public {
270         require(balanceOf[msg.sender] >= wad);
271         balanceOf[msg.sender] -= wad;
272         msg.sender.transfer(wad);
273         Withdrawal(msg.sender, wad);
274     }
275 
276     function totalSupply() public view returns (uint) {
277         return this.balance;
278     }
279 
280     function approve(address guy, uint wad) public returns (bool) {
281         allowance[msg.sender][guy] = wad;
282         Approval(msg.sender, guy, wad);
283         return true;
284     }
285 
286     function transfer(address dst, uint wad) public returns (bool) {
287         return transferFrom(msg.sender, dst, wad);
288     }
289 
290     function transferFrom(address src, address dst, uint wad)
291         public
292         returns (bool)
293     {
294         require(balanceOf[src] >= wad);
295 
296         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
297             require(allowance[src][msg.sender] >= wad);
298             allowance[src][msg.sender] -= wad;
299         }
300 
301         balanceOf[src] -= wad;
302         balanceOf[dst] += wad;
303 
304         Transfer(src, dst, wad);
305 
306         return true;
307     }
308 }
309 
310 
311 contract DSThing is DSNote, DSAuth, DSMath {
312 
313     function S(string s) internal pure returns (bytes4) {
314         return bytes4(keccak256(s));
315     }
316 
317 }
318 
319 
320 library ECRecovery {
321 
322     function recover(bytes32 _hash, bytes _sig)
323         internal
324         pure
325     returns (address)
326     {
327         bytes32 r;
328         bytes32 s;
329         uint8 v;
330 
331         if (_sig.length != 65) {
332             return (address(0));
333         }
334 
335         assembly {
336             r := mload(add(_sig, 32))
337             s := mload(add(_sig, 64))
338             v := byte(0, mload(add(_sig, 96)))
339         }
340 
341         if (v < 27) {
342             v += 27;
343         }
344 
345         if (v != 27 && v != 28) {
346             return (address(0));
347         } else {
348             return ecrecover(_hash, v, r, s);
349         }
350     }
351 
352     function toEthSignedMessageHash(bytes32 _hash)
353         internal
354         pure
355     returns (bytes32)
356     {
357         return keccak256(
358             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
359         );
360     }
361 }
362 
363 contract Utils2 {
364     using ECRecovery for bytes32;
365     
366     function _recoverSigner(bytes32 _hash, bytes _signature) 
367         internal
368         pure
369         returns(address _signer)
370     {
371         return _hash.toEthSignedMessageHash().recover(_signature);
372     }
373 
374 }
375 
376 
377 contract Config is DSNote, DSAuth, Utils {
378 
379     WETH9 public weth9;
380     mapping (address => bool) public isAccountHandler;
381     mapping (address => bool) public isAdmin;
382     address[] public admins;
383     bool public disableAdminControl = false;
384     
385     event LogAdminAdded(address indexed _admin, address _by);
386     event LogAdminRemoved(address indexed _admin, address _by);
387 
388     constructor() public {
389         admins.push(msg.sender);
390         isAdmin[msg.sender] = true;
391     }
392 
393     modifier onlyAdmin(){
394         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
395         _;
396     }
397 
398     function setWETH9
399     (
400         address _weth9
401     ) 
402         public
403         auth
404         note
405         addressValid(_weth9) 
406     {
407         weth9 = WETH9(_weth9);
408     }
409 
410     function setAccountHandler
411     (
412         address _accountHandler,
413         bool _isAccountHandler
414     )
415         public
416         auth
417         note
418         addressValid(_accountHandler)
419     {
420         isAccountHandler[_accountHandler] = _isAccountHandler;
421     }
422 
423     function toggleAdminsControl() 
424         public
425         auth
426         note
427     {
428         disableAdminControl = !disableAdminControl;
429     }
430 
431     function isAdminValid(address _admin)
432         public
433         view
434         returns (bool)
435     {
436         if(disableAdminControl) {
437             return true;
438         } else {
439             return isAdmin[_admin];
440         }
441     }
442 
443     function getAllAdmins()
444         public
445         view
446         returns(address[])
447     {
448         return admins;
449     }
450 
451     function addAdmin
452     (
453         address _admin
454     )
455         external
456         note
457         onlyAdmin
458         addressValid(_admin)
459     {   
460         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
461 
462         admins.push(_admin);
463         isAdmin[_admin] = true;
464 
465         emit LogAdminAdded(_admin, msg.sender);
466     }
467 
468     function removeAdmin
469     (
470         address _admin
471     ) 
472         external
473         note
474         onlyAdmin
475         addressValid(_admin)
476     {   
477         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
478         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
479 
480         isAdmin[_admin] = false;
481 
482         for (uint i = 0; i < admins.length - 1; i++) {
483             if (admins[i] == _admin) {
484                 admins[i] = admins[admins.length - 1];
485                 admins.length -= 1;
486                 break;
487             }
488         }
489 
490         emit LogAdminRemoved(_admin, msg.sender);
491     }
492 }
493 
494 
495 contract DSStop is DSNote, DSAuth {
496 
497     bool public stopped = false;
498 
499     modifier whenNotStopped {
500         require(!stopped, "DSStop::_ FEATURE_STOPPED");
501         _;
502     }
503 
504     modifier whenStopped {
505         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
506         _;
507     }
508 
509     function stop() public auth note {
510         stopped = true;
511     }
512     function start() public auth note {
513         stopped = false;
514     }
515 
516 }
517 
518 
519 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
520 
521     address[] public users;
522     mapping (address => bool) public isUser;
523     mapping (bytes32 => bool) public actionCompleted;
524 
525     WETH9 public weth9;
526     Config public config;
527     bool public isInitialized = false;
528 
529     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
530     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
531     event LogUserAdded(address indexed user, address by);
532     event LogUserRemoved(address indexed user, address by);
533 
534     modifier initialized() {
535         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
536         _;
537     }
538 
539     modifier userExists(address _user) {
540         require(isUser[_user], "Account::_ INVALID_USER");
541         _;
542     }
543 
544     modifier userDoesNotExist(address _user) {
545         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
546         _;
547     }
548 
549     modifier onlyHandler(){
550         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
551         _;
552     }
553 
554     function init(address _user, address _config) public {
555         users.push(_user);
556         isUser[_user] = true;
557         config = Config(_config);
558         weth9 = config.weth9();
559         isInitialized = true;
560     }
561     
562     function getAllUsers() public view returns (address[]) {
563         return users;
564     }
565 
566     function balanceFor(address _token) public view returns (uint _balance){
567         _balance = ERC20(_token).balanceOf(this);
568     }
569     
570     function transferBySystem
571     (   
572         address _token,
573         address _to,
574         uint _value
575     ) 
576         external 
577         onlyHandler
578         note 
579         initialized
580     {
581         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
582         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
583 
584         emit LogTransferBySystem(_token, _to, _value, msg.sender);
585     }
586     
587     function transferByUser
588     (   
589         address _token,
590         address _to,
591         uint _value,
592         uint _salt,
593         bytes _signature
594     ) 
595         external
596         addressValid(_to)
597         note
598         initialized
599     {
600         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
601 
602         if(actionCompleted[actionHash]) {
603             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
604             return;
605         }
606 
607         if(ERC20(_token).balanceOf(this) < _value){
608             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
609             return;
610         }
611 
612         address signer = _recoverSigner(actionHash, _signature);
613 
614         if(!isUser[signer]) {
615             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
616             return;
617         }
618 
619         actionCompleted[actionHash] = true;
620         
621         if (_token == address(weth9)) {
622             weth9.withdraw(_value);
623             _to.transfer(_value);
624         } else {
625             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
626         }
627 
628         emit LogTransferByUser(_token, _to, _value, signer);
629     }
630 
631     function addUser
632     (
633         address _user,
634         uint _salt,
635         bytes _signature
636     )
637         external 
638         note 
639         addressValid(_user)
640         userDoesNotExist(_user)
641         initialized
642     {   
643         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
644         if(actionCompleted[actionHash])
645         {
646             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
647             return;
648         }
649 
650         address signer = _recoverSigner(actionHash, _signature);
651 
652         if(!isUser[signer]) {
653             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
654             return;
655         }
656 
657         actionCompleted[actionHash] = true;
658 
659         users.push(_user);
660         isUser[_user] = true;
661 
662         emit LogUserAdded(_user, signer);
663     }
664 
665     function removeUser
666     (
667         address _user,
668         uint _salt,
669         bytes _signature
670     ) 
671         external
672         note
673         userExists(_user) 
674         initialized
675     {   
676         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
677 
678         if(actionCompleted[actionHash]) {
679             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
680             return;
681         }
682 
683         address signer = _recoverSigner(actionHash, _signature);
684         
685         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
686         if(!isUser[signer]){
687             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
688             return;
689         }
690         
691         actionCompleted[actionHash] = true;
692 
693         isUser[_user] = false;
694         for (uint i = 0; i < users.length - 1; i++) {
695             if (users[i] == _user) {
696                 users[i] = users[users.length - 1];
697                 users.length -= 1;
698                 break;
699             }
700         }
701 
702         emit LogUserRemoved(_user, signer);
703     }
704 
705     function _getTransferActionHash
706     ( 
707         address _token,
708         address _to,
709         uint _value,
710         uint _salt
711     ) 
712         internal
713         view
714         returns (bytes32)
715     {
716         return keccak256(
717             abi.encodePacked(
718                 address(this),
719                 _token,
720                 _to,
721                 _value,
722                 _salt
723             )
724         );
725     }
726 
727     function _getUserActionHash
728     ( 
729         address _user,
730         string _action,
731         uint _salt
732     ) 
733         internal
734         view
735         returns (bytes32)
736     {
737         return keccak256(
738             abi.encodePacked(
739                 address(this),
740                 _user,
741                 _action,
742                 _salt
743             )
744         );
745     }
746 
747     // to directly send ether to contract
748     function() external payable {
749         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
750 
751         if(msg.sender != address(weth9)){
752             weth9.deposit.value(msg.value)();
753         }
754     }
755     
756 }
757 
758 
759 contract AccountFactory is DSStop, Utils {
760     Config public config;
761     mapping (address => bool) public isAccount;
762     mapping (address => address[]) public userToAccounts;
763     address[] public accounts;
764 
765     address public accountMaster;
766 
767     constructor
768     (
769         Config _config, 
770         address _accountMaster
771     ) 
772     public 
773     {
774         config = _config;
775         accountMaster = _accountMaster;
776     }
777 
778     event LogAccountCreated(address indexed user, address indexed account, address by);
779 
780     modifier onlyAdmin() {
781         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
782         _;
783     }
784 
785     function setConfig(Config _config) external note auth addressValid(_config) {
786         config = _config;
787     }
788 
789     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
790         accountMaster = _accountMaster;
791     }
792 
793     function newAccount(address _user)
794         public
795         note
796         onlyAdmin
797         addressValid(config)
798         addressValid(accountMaster)
799         whenNotStopped
800         returns 
801         (
802             Account _account
803         ) 
804     {
805         address proxy = new Proxy(accountMaster);
806         _account = Account(proxy);
807         _account.init(_user, config);
808 
809         accounts.push(_account);
810         userToAccounts[_user].push(_account);
811         isAccount[_account] = true;
812 
813         emit LogAccountCreated(_user, _account, msg.sender);
814     }
815     
816     function batchNewAccount(address[] _users) public note onlyAdmin {
817         for (uint i = 0; i < _users.length; i++) {
818             newAccount(_users[i]);
819         }
820     }
821 
822     function getAllAccounts() public view returns (address[]) {
823         return accounts;
824     }
825 
826     function getAccountsForUser(address _user) public view returns (address[]) {
827         return userToAccounts[_user];
828     }
829 
830 }