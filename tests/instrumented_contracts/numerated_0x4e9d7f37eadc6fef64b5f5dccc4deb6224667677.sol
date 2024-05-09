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
11 contract DSMath {
12     function add(uint x, uint y) internal pure returns (uint z) {
13         require((z = x + y) >= x);
14     }
15     function sub(uint x, uint y) internal pure returns (uint z) {
16         require((z = x - y) <= x);
17     }
18     function mul(uint x, uint y) internal pure returns (uint z) {
19         require(y == 0 || (z = x * y) / y == x);
20     }
21 
22     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
23     function div(uint x, uint y) internal pure returns (uint z) {
24         z = x / y;
25     }
26 
27     function min(uint x, uint y) internal pure returns (uint z) {
28         return x <= y ? x : y;
29     }
30     function max(uint x, uint y) internal pure returns (uint z) {
31         return x >= y ? x : y;
32     }
33     function imin(int x, int y) internal pure returns (int z) {
34         return x <= y ? x : y;
35     }
36     function imax(int x, int y) internal pure returns (int z) {
37         return x >= y ? x : y;
38     }
39 
40     uint constant WAD = 10 ** 18;
41     uint constant RAY = 10 ** 27;
42 
43     function wmul(uint x, uint y) internal pure returns (uint z) {
44         z = add(mul(x, y), WAD / 2) / WAD;
45     }
46     function rmul(uint x, uint y) internal pure returns (uint z) {
47         z = add(mul(x, y), RAY / 2) / RAY;
48     }
49     function wdiv(uint x, uint y) internal pure returns (uint z) {
50         z = add(mul(x, WAD), y / 2) / y;
51     }
52     function rdiv(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, RAY), y / 2) / y;
54     }
55 
56     // This famous algorithm is called "exponentiation by squaring"
57     // and calculates x^n with x as fixed-point and n as regular unsigned.
58     //
59     // It's O(log n), instead of O(n) for naive repeated multiplication.
60     //
61     // These facts are why it works:
62     //
63     //  If n is even, then x^n = (x^2)^(n/2).
64     //  If n is odd,  then x^n = x * x^(n-1),
65     //   and applying the equation for even x gives
66     //    x^n = x * (x^2)^((n-1) / 2).
67     //
68     //  Also, EVM division is flooring and
69     //    floor[(n-1) / 2] = floor[n / 2].
70     //
71     function rpow(uint x, uint n) internal pure returns (uint z) {
72         z = n % 2 != 0 ? x : RAY;
73 
74         for (n /= 2; n != 0; n /= 2) {
75             x = rmul(x, x);
76 
77             if (n % 2 != 0) {
78                 z = rmul(z, x);
79             }
80         }
81     }
82 }
83 contract SelfAuthorized {
84     modifier authorized() {
85         require(msg.sender == address(this), "Method can only be called from this contract");
86         _;
87     }
88 }
89 contract Proxy {
90 
91     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
92     address masterCopy;
93 
94     /// @dev Constructor function sets address of master copy contract.
95     /// @param _masterCopy Master copy address.
96     constructor(address _masterCopy)
97         public
98     {
99         require(_masterCopy != 0, "Invalid master copy address provided");
100         masterCopy = _masterCopy;
101     }
102 
103     /// @dev Fallback function forwards all transactions and returns all received return data.
104     function ()
105         external
106         payable
107     {
108         // solium-disable-next-line security/no-inline-assembly
109         assembly {
110             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
111             calldatacopy(0, 0, calldatasize())
112             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
113             returndatacopy(0, 0, returndatasize())
114             if eq(success, 0) { revert(0, returndatasize()) }
115             return(0, returndatasize())
116         }
117     }
118 
119     function implementation()
120         public
121         view
122         returns (address)
123     {
124         return masterCopy;
125     }
126 
127     function proxyType()
128         public
129         pure
130         returns (uint256)
131     {
132         return 2;
133     }
134 }
135 
136 contract WETH9 {
137     string public name     = "Wrapped Ether";
138     string public symbol   = "WETH";
139     uint8  public decimals = 18;
140 
141     event  Approval(address indexed _owner, address indexed _spender, uint _value);
142     event  Transfer(address indexed _from, address indexed _to, uint _value);
143     event  Deposit(address indexed _owner, uint _value);
144     event  Withdrawal(address indexed _owner, uint _value);
145 
146     mapping (address => uint)                       public  balanceOf;
147     mapping (address => mapping (address => uint))  public  allowance;
148 
149     function() public payable {
150         deposit();
151     }
152 
153     function deposit() public payable {
154         balanceOf[msg.sender] += msg.value;
155         Deposit(msg.sender, msg.value);
156     }
157 
158     function withdraw(uint wad) public {
159         require(balanceOf[msg.sender] >= wad);
160         balanceOf[msg.sender] -= wad;
161         msg.sender.transfer(wad);
162         Withdrawal(msg.sender, wad);
163     }
164 
165     function totalSupply() public view returns (uint) {
166         return this.balance;
167     }
168 
169     function approve(address guy, uint wad) public returns (bool) {
170         allowance[msg.sender][guy] = wad;
171         Approval(msg.sender, guy, wad);
172         return true;
173     }
174 
175     function transfer(address dst, uint wad) public returns (bool) {
176         return transferFrom(msg.sender, dst, wad);
177     }
178 
179     function transferFrom(address src, address dst, uint wad)
180         public
181         returns (bool)
182     {
183         require(balanceOf[src] >= wad);
184 
185         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
186             require(allowance[src][msg.sender] >= wad);
187             allowance[src][msg.sender] -= wad;
188         }
189 
190         balanceOf[src] -= wad;
191         balanceOf[dst] += wad;
192 
193         Transfer(src, dst, wad);
194 
195         return true;
196     }
197 }
198 
199 contract DSNote {
200     event LogNote(
201         bytes4   indexed  sig,
202         address  indexed  guy,
203         bytes32  indexed  foo,
204         bytes32  indexed  bar,
205         uint              wad,
206         bytes             fax
207     ) anonymous;
208 
209     modifier note {
210         bytes32 foo;
211         bytes32 bar;
212 
213         assembly {
214             foo := calldataload(4)
215             bar := calldataload(36)
216         }
217 
218         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
219 
220         _;
221     }
222 }
223 interface ERC20 {
224 
225     function name() public view returns(string);
226     function symbol() public view returns(string);
227     function decimals() public view returns(uint8);
228     function totalSupply() public view returns (uint);
229 
230     function balanceOf(address tokenOwner) public view returns (uint balance);
231     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
232     function transfer(address to, uint tokens) public returns (bool success);
233     function approve(address spender, uint tokens) public returns (bool success);
234     function transferFrom(address from, address to, uint tokens) public returns (bool success);
235 
236     event Transfer(address indexed from, address indexed to, uint tokens);
237     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
238 }
239 contract DSAuthority {
240     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
241 }
242 
243 contract DSAuthEvents {
244     event LogSetAuthority (address indexed authority);
245     event LogSetOwner     (address indexed owner);
246 }
247 
248 contract DSAuth is DSAuthEvents {
249     DSAuthority  public  authority;
250     address      public  owner;
251 
252     constructor() public {
253         owner = msg.sender;
254         emit LogSetOwner(msg.sender);
255     }
256 
257     function setOwner(address owner_)
258         public
259         auth
260     {
261         owner = owner_;
262         emit LogSetOwner(owner);
263     }
264 
265     function setAuthority(DSAuthority authority_)
266         public
267         auth
268     {
269         authority = authority_;
270         emit LogSetAuthority(authority);
271     }
272 
273     modifier auth {
274         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
275         _;
276     }
277 
278     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
279         if (src == address(this)) {
280             return true;
281         } else if (src == owner) {
282             return true;
283         } else if (authority == DSAuthority(0)) {
284             return false;
285         } else {
286             return authority.canCall(src, this, sig);
287         }
288     }
289 }
290 contract ErrorUtils {
291 
292     event LogError(string methodSig, string errMsg);
293     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
294     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
295 
296 }
297 contract MasterCopy is SelfAuthorized {
298   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
299   // It should also always be ensured that the address is stored alone (uses a full word)
300     address masterCopy;
301 
302   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
303   /// @param _masterCopy New contract address.
304     function changeMasterCopy(address _masterCopy)
305         public
306         authorized
307     {
308         // Master copy address cannot be null.
309         require(_masterCopy != 0, "Invalid master copy address provided");
310         masterCopy = _masterCopy;
311     }
312 }
313 
314 
315 library ECRecovery {
316 
317     function recover(bytes32 _hash, bytes _sig)
318         internal
319         pure
320     returns (address)
321     {
322         bytes32 r;
323         bytes32 s;
324         uint8 v;
325 
326         if (_sig.length != 65) {
327             return (address(0));
328         }
329 
330         assembly {
331             r := mload(add(_sig, 32))
332             s := mload(add(_sig, 64))
333             v := byte(0, mload(add(_sig, 96)))
334         }
335 
336         if (v < 27) {
337             v += 27;
338         }
339 
340         if (v != 27 && v != 28) {
341             return (address(0));
342         } else {
343             return ecrecover(_hash, v, r, s);
344         }
345     }
346 
347     function toEthSignedMessageHash(bytes32 _hash)
348         internal
349         pure
350     returns (bytes32)
351     {
352         return keccak256(
353             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
354         );
355     }
356 }
357 
358 
359 contract Utils2 {
360     using ECRecovery for bytes32;
361     
362     function _recoverSigner(bytes32 _hash, bytes _signature) 
363         internal
364         pure
365         returns(address _signer)
366     {
367         return _hash.toEthSignedMessageHash().recover(_signature);
368     }
369 
370 }
371 contract Config is DSNote, DSAuth, Utils {
372 
373     WETH9 public weth9;
374     mapping (address => bool) public isAccountHandler;
375     mapping (address => bool) public isAdmin;
376     address[] public admins;
377     bool public disableAdminControl = false;
378     
379     event LogAdminAdded(address indexed _admin, address _by);
380     event LogAdminRemoved(address indexed _admin, address _by);
381 
382     constructor() public {
383         admins.push(msg.sender);
384         isAdmin[msg.sender] = true;
385     }
386 
387     modifier onlyAdmin(){
388         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
389         _;
390     }
391 
392     function setWETH9
393     (
394         address _weth9
395     ) 
396         public
397         auth
398         note
399         addressValid(_weth9) 
400     {
401         weth9 = WETH9(_weth9);
402     }
403 
404     function setAccountHandler
405     (
406         address _accountHandler,
407         bool _isAccountHandler
408     )
409         public
410         auth
411         note
412         addressValid(_accountHandler)
413     {
414         isAccountHandler[_accountHandler] = _isAccountHandler;
415     }
416 
417     function toggleAdminsControl() 
418         public
419         auth
420         note
421     {
422         disableAdminControl = !disableAdminControl;
423     }
424 
425     function isAdminValid(address _admin)
426         public
427         view
428         returns (bool)
429     {
430         if(disableAdminControl) {
431             return true;
432         } else {
433             return isAdmin[_admin];
434         }
435     }
436 
437     function getAllAdmins()
438         public
439         view
440         returns(address[])
441     {
442         return admins;
443     }
444 
445     function addAdmin
446     (
447         address _admin
448     )
449         external
450         note
451         onlyAdmin
452         addressValid(_admin)
453     {   
454         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
455 
456         admins.push(_admin);
457         isAdmin[_admin] = true;
458 
459         emit LogAdminAdded(_admin, msg.sender);
460     }
461 
462     function removeAdmin
463     (
464         address _admin
465     ) 
466         external
467         note
468         onlyAdmin
469         addressValid(_admin)
470     {   
471         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
472         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
473 
474         isAdmin[_admin] = false;
475 
476         for (uint i = 0; i < admins.length - 1; i++) {
477             if (admins[i] == _admin) {
478                 admins[i] = admins[admins.length - 1];
479                 admins.length -= 1;
480                 break;
481             }
482         }
483 
484         emit LogAdminRemoved(_admin, msg.sender);
485     }
486 }
487 contract DSThing is DSNote, DSAuth, DSMath {
488 
489     function S(string s) internal pure returns (bytes4) {
490         return bytes4(keccak256(s));
491     }
492 
493 }
494 contract DSStop is DSNote, DSAuth {
495 
496     bool public stopped = false;
497 
498     modifier whenNotStopped {
499         require(!stopped, "DSStop::_ FEATURE_STOPPED");
500         _;
501     }
502 
503     modifier whenStopped {
504         require(stopped, "DSStop::_ FEATURE_NOT_STOPPED");
505         _;
506     }
507 
508     function stop() public auth note {
509         stopped = true;
510     }
511     function start() public auth note {
512         stopped = false;
513     }
514 
515 }
516 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
517 
518     address[] public users;
519     mapping (address => bool) public isUser;
520     mapping (bytes32 => bool) public actionCompleted;
521 
522     WETH9 public weth9;
523     Config public config;
524     bool public isInitialized = false;
525 
526     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
527     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
528     event LogUserAdded(address indexed user, address by);
529     event LogUserRemoved(address indexed user, address by);
530     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
531 
532     modifier initialized() {
533         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
534         _;
535     }
536 
537     modifier notInitialized() {
538         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
539         _;
540     }
541 
542     modifier userExists(address _user) {
543         require(isUser[_user], "Account::_ INVALID_USER");
544         _;
545     }
546 
547     modifier userDoesNotExist(address _user) {
548         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
549         _;
550     }
551 
552     modifier onlyAdmin() {
553         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
554         _;
555     }
556 
557     modifier onlyHandler(){
558         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
559         _;
560     }
561 
562     function init(address _user, address _config)
563         public 
564         notInitialized
565     {
566         users.push(_user);
567         isUser[_user] = true;
568         config = Config(_config);
569         weth9 = config.weth9();
570         isInitialized = true;
571     }
572     
573     function getAllUsers() public view returns (address[]) {
574         return users;
575     }
576 
577     function balanceFor(address _token) public view returns (uint _balance){
578         _balance = ERC20(_token).balanceOf(this);
579     }
580     
581     function transferBySystem
582     (   
583         address _token,
584         address _to,
585         uint _value
586     ) 
587         external 
588         onlyHandler
589         note 
590         initialized
591     {
592         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
593         ERC20(_token).transfer(_to, _value);
594 
595         emit LogTransferBySystem(_token, _to, _value, msg.sender);
596     }
597     
598     function transferByUser
599     (   
600         address _token,
601         address _to,
602         uint _value,
603         uint _salt,
604         bytes _signature
605     )
606         external
607         addressValid(_to)
608         note
609         initialized
610         onlyAdmin
611     {
612         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
613 
614         if(actionCompleted[actionHash]) {
615             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
616             return;
617         }
618 
619         if(ERC20(_token).balanceOf(this) < _value){
620             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
621             return;
622         }
623 
624         address signer = _recoverSigner(actionHash, _signature);
625 
626         if(!isUser[signer]) {
627             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
628             return;
629         }
630 
631         actionCompleted[actionHash] = true;
632         
633         if (_token == address(weth9)) {
634             weth9.withdraw(_value);
635             _to.transfer(_value);
636         } else {
637             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
638         }
639 
640         emit LogTransferByUser(_token, _to, _value, signer);
641     }
642 
643     function addUser
644     (
645         address _user,
646         uint _salt,
647         bytes _signature
648     )
649         external 
650         note 
651         addressValid(_user)
652         userDoesNotExist(_user)
653         initialized
654         onlyAdmin
655     {   
656         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
657         if(actionCompleted[actionHash])
658         {
659             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
660             return;
661         }
662 
663         address signer = _recoverSigner(actionHash, _signature);
664 
665         if(!isUser[signer]) {
666             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
667             return;
668         }
669 
670         actionCompleted[actionHash] = true;
671 
672         users.push(_user);
673         isUser[_user] = true;
674 
675         emit LogUserAdded(_user, signer);
676     }
677 
678     function removeUser
679     (
680         address _user,
681         uint _salt,
682         bytes _signature
683     ) 
684         external
685         note
686         userExists(_user) 
687         initialized
688         onlyAdmin
689     {   
690         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
691 
692         if(actionCompleted[actionHash]) {
693             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
694             return;
695         }
696 
697         address signer = _recoverSigner(actionHash, _signature);
698         
699         if(users.length == 1){
700             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
701             return;
702         }
703         
704         if(!isUser[signer]){
705             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
706             return;
707         }
708         
709         actionCompleted[actionHash] = true;
710 
711         // should delete value from isUser map? delete isUser[_user]?
712         isUser[_user] = false;
713         for (uint i = 0; i < users.length - 1; i++) {
714             if (users[i] == _user) {
715                 users[i] = users[users.length - 1];
716                 users.length -= 1;
717                 break;
718             }
719         }
720 
721         emit LogUserRemoved(_user, signer);
722     }
723 
724     function _getTransferActionHash
725     ( 
726         address _token,
727         address _to,
728         uint _value,
729         uint _salt
730     ) 
731         internal
732         view
733         returns (bytes32)
734     {
735         return keccak256(
736             abi.encodePacked(
737                 address(this),
738                 _token,
739                 _to,
740                 _value,
741                 _salt
742             )
743         );
744     }
745 
746     function _getUserActionHash
747     ( 
748         address _user,
749         string _action,
750         uint _salt
751     ) 
752         internal
753         view
754         returns (bytes32)
755     {
756         return keccak256(
757             abi.encodePacked(
758                 address(this),
759                 _user,
760                 _action,
761                 _salt
762             )
763         );
764     }
765 
766     // to directly send ether to contract
767     function() external payable {
768         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
769 
770         if(msg.sender != address(weth9)){
771             weth9.deposit.value(msg.value)();
772         }
773     }
774 
775     function changeImpl
776     (
777         address _to,
778         uint _salt,
779         bytes _signature
780     )
781         external 
782         note 
783         addressValid(_to)
784         initialized
785         onlyAdmin
786     {   
787         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
788         if(actionCompleted[actionHash])
789         {
790             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
791             return;
792         }
793 
794         address signer = _recoverSigner(actionHash, _signature);
795 
796         if(!isUser[signer]) {
797             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
798             return;
799         }
800 
801         actionCompleted[actionHash] = true;
802 
803         address oldImpl = masterCopy;
804         this.changeMasterCopy(_to);
805         
806         emit LogImplChanged(_to, oldImpl);
807     }
808 
809 }
810 contract AccountFactory is DSStop, Utils {
811     Config public config;
812     mapping (address => bool) public isAccount;
813     mapping (address => address[]) public userToAccounts;
814     address[] public accounts;
815 
816     address public accountMaster;
817 
818     constructor
819     (
820         Config _config, 
821         address _accountMaster
822     ) 
823     public 
824     {
825         config = _config;
826         accountMaster = _accountMaster;
827     }
828 
829     event LogAccountCreated(address indexed user, address indexed account, address by);
830 
831     modifier onlyAdmin() {
832         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
833         _;
834     }
835 
836     function setConfig(Config _config) external note auth addressValid(_config) {
837         config = _config;
838     }
839 
840     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
841         accountMaster = _accountMaster;
842     }
843 
844     function newAccount(address _user)
845         public
846         note
847         onlyAdmin
848         addressValid(config)
849         addressValid(accountMaster)
850         whenNotStopped
851         returns 
852         (
853             Account _account
854         ) 
855     {
856         address proxy = new Proxy(accountMaster);
857         _account = Account(proxy);
858         _account.init(_user, config);
859 
860         accounts.push(_account);
861         userToAccounts[_user].push(_account);
862         isAccount[_account] = true;
863 
864         emit LogAccountCreated(_user, _account, msg.sender);
865     }
866     
867     function batchNewAccount(address[] _users) public note onlyAdmin {
868         for (uint i = 0; i < _users.length; i++) {
869             newAccount(_users[i]);
870         }
871     }
872 
873     function getAllAccounts() public view returns (address[]) {
874         return accounts;
875     }
876 
877     function getAccountsForUser(address _user) public view returns (address[]) {
878         return userToAccounts[_user];
879     }
880 
881 }
882 contract AccountFactoryV2 is DSStop, Utils {
883     Config public config;
884     mapping (address => bool) public isAccountValid;
885     mapping (address => address[]) public userToAccounts;
886     address[] public accounts;
887 
888     address public accountMaster;
889     AccountFactory accountFactoryV1;
890 
891     constructor
892     (
893         Config _config, 
894         address _accountMaster,
895         AccountFactory _accountFactoryV1
896     ) 
897     public 
898     {
899         config = _config;
900         accountMaster = _accountMaster;
901         accountFactoryV1 = _accountFactoryV1;
902     }
903 
904     event LogAccountCreated(address indexed user, address indexed account, address by);
905 
906     modifier onlyAdmin() {
907         require(config.isAdminValid(msg.sender), "AccountFactory::_ INVALID_ADMIN_ACCOUNT");
908         _;
909     }
910 
911     function setConfig(Config _config) external note auth addressValid(_config) {
912         config = _config;
913     }
914 
915     function setAccountMaster(address _accountMaster) external note auth addressValid(_accountMaster) {
916         accountMaster = _accountMaster;
917     }
918 
919     function setAccountFactoryV1(AccountFactory _accountFactoryV1) external note auth addressValid(_accountFactoryV1) {
920         accountFactoryV1 = _accountFactoryV1;
921     }
922 
923 
924     function newAccount(address _user)
925         public
926         note
927         addressValid(config)
928         addressValid(accountMaster)
929         whenNotStopped
930         returns 
931         (
932             Account _account
933         ) 
934     {
935         address proxy = new Proxy(accountMaster);
936         _account = Account(proxy);
937         _account.init(_user, config);
938 
939         accounts.push(_account);
940         userToAccounts[_user].push(_account);
941         isAccountValid[_account] = true;
942 
943         emit LogAccountCreated(_user, _account, msg.sender);
944     }
945     
946     function batchNewAccount(address[] _users) external note onlyAdmin {
947         for (uint i = 0; i < _users.length; i++) {
948             newAccount(_users[i]);
949         }
950     }
951 
952     function getAllAccounts() public view returns (address[]) {
953         uint accLengthV2 = accounts.length; // 1
954         uint accLengthV1 = accountFactoryV1.getAllAccounts().length; // 1
955         uint accLength = accLengthV2 + accLengthV1; // 2
956 
957         address[] memory accs = new address[](accLength);
958 
959         for(uint i = 0; i < accLength; i++){
960             if(i < accLengthV2) { 
961                 accs[i] = accounts[i];
962             } else {
963                 accs[i] = accountFactoryV1.accounts(i - accLengthV2);
964             }
965         }
966 
967         return accs;
968     }
969 
970     function getAccountsForUser(address _user) public view returns (address[]) {
971         uint userToAccLengthV2 = userToAccounts[_user].length;
972         uint userToAccLengthV1 = accountFactoryV1.getAccountsForUser(_user).length;
973         uint userToAccLength = userToAccLengthV2 + userToAccLengthV1;
974         
975         address[] memory userToAcc = new address[](userToAccLength);
976 
977         for(uint i = 0; i < userToAccLength; i++){
978             if(i < userToAccLengthV2) {
979                 userToAcc[i] = userToAccounts[_user][i];
980             } else {
981                 userToAcc[i] = accountFactoryV1.userToAccounts(_user, i - userToAccLengthV2);
982             }
983         }
984 
985         return userToAcc;
986     }
987 
988     function isAccount(address _account) public view returns (bool) {
989         return isAccountValid[_account] || accountFactoryV1.isAccount(_account);
990     }
991 
992 }