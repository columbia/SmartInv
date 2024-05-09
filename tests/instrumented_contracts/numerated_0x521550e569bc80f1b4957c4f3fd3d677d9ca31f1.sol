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
12 
13 contract DSNote {
14     event LogNote(
15         bytes4   indexed  sig,
16         address  indexed  guy,
17         bytes32  indexed  foo,
18         bytes32  indexed  bar,
19         uint              wad,
20         bytes             fax
21     ) anonymous;
22 
23     modifier note {
24         bytes32 foo;
25         bytes32 bar;
26 
27         assembly {
28             foo := calldataload(4)
29             bar := calldataload(36)
30         }
31 
32         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
33 
34         _;
35     }
36 }
37 
38 
39 contract WETH9 {
40     string public name     = "Wrapped Ether";
41     string public symbol   = "WETH";
42     uint8  public decimals = 18;
43 
44     event  Approval(address indexed _owner, address indexed _spender, uint _value);
45     event  Transfer(address indexed _from, address indexed _to, uint _value);
46     event  Deposit(address indexed _owner, uint _value);
47     event  Withdrawal(address indexed _owner, uint _value);
48 
49     mapping (address => uint)                       public  balanceOf;
50     mapping (address => mapping (address => uint))  public  allowance;
51 
52     function() public payable {
53         deposit();
54     }
55 
56     function deposit() public payable {
57         balanceOf[msg.sender] += msg.value;
58         Deposit(msg.sender, msg.value);
59     }
60 
61     function withdraw(uint wad) public {
62         require(balanceOf[msg.sender] >= wad);
63         balanceOf[msg.sender] -= wad;
64         msg.sender.transfer(wad);
65         Withdrawal(msg.sender, wad);
66     }
67 
68     function totalSupply() public view returns (uint) {
69         return this.balance;
70     }
71 
72     function approve(address guy, uint wad) public returns (bool) {
73         allowance[msg.sender][guy] = wad;
74         Approval(msg.sender, guy, wad);
75         return true;
76     }
77 
78     function transfer(address dst, uint wad) public returns (bool) {
79         return transferFrom(msg.sender, dst, wad);
80     }
81 
82     function transferFrom(address src, address dst, uint wad)
83         public
84         returns (bool)
85     {
86         require(balanceOf[src] >= wad);
87 
88         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
89             require(allowance[src][msg.sender] >= wad);
90             allowance[src][msg.sender] -= wad;
91         }
92 
93         balanceOf[src] -= wad;
94         balanceOf[dst] += wad;
95 
96         Transfer(src, dst, wad);
97 
98         return true;
99     }
100 }
101 
102 interface ERC20 {
103 
104     function name() external view returns(string);
105     function symbol() external view returns(string);
106     function decimals() external view returns(uint8);
107     function totalSupply() external view returns (uint);
108 
109     function balanceOf(address tokenOwner) external view returns (uint balance);
110     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
111     function transfer(address to, uint tokens) external returns (bool success);
112     function approve(address spender, uint tokens) external returns (bool success);
113     function transferFrom(address from, address to, uint tokens) external returns (bool success);
114 
115     event Transfer(address indexed from, address indexed to, uint tokens);
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117 }
118 contract DSAuthority {
119     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
120 }
121 
122 contract DSAuthEvents {
123     event LogSetAuthority (address indexed authority);
124     event LogSetOwner     (address indexed owner);
125 }
126 
127 contract DSAuth is DSAuthEvents {
128     DSAuthority  public  authority;
129     address      public  owner;
130 
131     constructor() public {
132         owner = msg.sender;
133         emit LogSetOwner(msg.sender);
134     }
135 
136     function setOwner(address owner_)
137         public
138         auth
139     {
140         owner = owner_;
141         emit LogSetOwner(owner);
142     }
143 
144     function setAuthority(DSAuthority authority_)
145         public
146         auth
147     {
148         authority = authority_;
149         emit LogSetAuthority(authority);
150     }
151 
152     modifier auth {
153         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
154         _;
155     }
156 
157     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
158         if (src == address(this)) {
159             return true;
160         } else if (src == owner) {
161             return true;
162         } else if (authority == DSAuthority(0)) {
163             return false;
164         } else {
165             return authority.canCall(src, this, sig);
166         }
167     }
168 }
169 
170 
171 contract ErrorUtils {
172 
173     event LogError(string methodSig, string errMsg);
174     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
175     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
176 
177 }
178 
179 
180 contract SelfAuthorized {
181     modifier authorized() {
182         require(msg.sender == address(this), "Method can only be called from this contract");
183         _;
184     }
185 }
186 
187 
188 contract DSMath {
189     function add(uint x, uint y) internal pure returns (uint z) {
190         require((z = x + y) >= x);
191     }
192     function sub(uint x, uint y) internal pure returns (uint z) {
193         require((z = x - y) <= x);
194     }
195     function mul(uint x, uint y) internal pure returns (uint z) {
196         require(y == 0 || (z = x * y) / y == x);
197     }
198 
199     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
200     function div(uint x, uint y) internal pure returns (uint z) {
201         z = x / y;
202     }
203 
204     function min(uint x, uint y) internal pure returns (uint z) {
205         return x <= y ? x : y;
206     }
207     function max(uint x, uint y) internal pure returns (uint z) {
208         return x >= y ? x : y;
209     }
210     function imin(int x, int y) internal pure returns (int z) {
211         return x <= y ? x : y;
212     }
213     function imax(int x, int y) internal pure returns (int z) {
214         return x >= y ? x : y;
215     }
216 
217     uint constant WAD = 10 ** 18;
218     uint constant RAY = 10 ** 27;
219 
220     function wmul(uint x, uint y) internal pure returns (uint z) {
221         z = add(mul(x, y), WAD / 2) / WAD;
222     }
223     function rmul(uint x, uint y) internal pure returns (uint z) {
224         z = add(mul(x, y), RAY / 2) / RAY;
225     }
226     function wdiv(uint x, uint y) internal pure returns (uint z) {
227         z = add(mul(x, WAD), y / 2) / y;
228     }
229     function rdiv(uint x, uint y) internal pure returns (uint z) {
230         z = add(mul(x, RAY), y / 2) / y;
231     }
232 
233     // This famous algorithm is called "exponentiation by squaring"
234     // and calculates x^n with x as fixed-point and n as regular unsigned.
235     //
236     // It's O(log n), instead of O(n) for naive repeated multiplication.
237     //
238     // These facts are why it works:
239     //
240     //  If n is even, then x^n = (x^2)^(n/2).
241     //  If n is odd,  then x^n = x * x^(n-1),
242     //   and applying the equation for even x gives
243     //    x^n = x * (x^2)^((n-1) / 2).
244     //
245     //  Also, EVM division is flooring and
246     //    floor[(n-1) / 2] = floor[n / 2].
247     //
248     function rpow(uint x, uint n) internal pure returns (uint z) {
249         z = n % 2 != 0 ? x : RAY;
250 
251         for (n /= 2; n != 0; n /= 2) {
252             x = rmul(x, x);
253 
254             if (n % 2 != 0) {
255                 z = rmul(z, x);
256             }
257         }
258     }
259 }
260 
261 
262 contract MasterCopy is SelfAuthorized {
263   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
264   // It should also always be ensured that the address is stored alone (uses a full word)
265     address masterCopy;
266 
267   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
268   /// @param _masterCopy New contract address.
269     function changeMasterCopy(address _masterCopy)
270         public
271         authorized
272     {
273         // Master copy address cannot be null.
274         require(_masterCopy != 0, "Invalid master copy address provided");
275         masterCopy = _masterCopy;
276     }
277 }
278 
279 interface KyberNetworkProxy {
280 
281     function maxGasPrice() external view returns(uint);
282     function getUserCapInWei(address user) external view returns(uint);
283     function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
284     function enabled() external view returns(bool);
285     function info(bytes32 id) external view returns(uint);
286 
287     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) external returns(uint);
288     function swapEtherToToken(ERC20 token, uint minConversionRate) external payable returns(uint);
289     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) external returns(uint);
290 
291     function getExpectedRate
292     (
293         ERC20 src,
294         ERC20 dest, 
295         uint srcQty
296     ) 
297         external
298         view
299         returns 
300     (
301         uint expectedRate,
302         uint slippageRate
303     );
304 
305     function tradeWithHint
306     (
307         ERC20 src,
308         uint srcAmount,
309         ERC20 dest,
310         address destAddress,
311         uint maxDestAmount,
312         uint minConversionRate,
313         address walletId,
314         bytes hint
315     )
316         external 
317         payable 
318         returns(uint);
319         
320 }
321 
322 contract DSThing is DSNote, DSAuth, DSMath {
323 
324     function S(string s) internal pure returns (bytes4) {
325         return bytes4(keccak256(s));
326     }
327 
328 }
329 
330 
331 contract Config is DSNote, DSAuth, Utils {
332 
333     WETH9 public weth9;
334     mapping (address => bool) public isAccountHandler;
335     mapping (address => bool) public isAdmin;
336     address[] public admins;
337     bool public disableAdminControl = false;
338     
339     event LogAdminAdded(address indexed _admin, address _by);
340     event LogAdminRemoved(address indexed _admin, address _by);
341 
342     constructor() public {
343         admins.push(msg.sender);
344         isAdmin[msg.sender] = true;
345     }
346 
347     modifier onlyAdmin(){
348         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
349         _;
350     }
351 
352     function setWETH9
353     (
354         address _weth9
355     ) 
356         public
357         auth
358         note
359         addressValid(_weth9) 
360     {
361         weth9 = WETH9(_weth9);
362     }
363 
364     function setAccountHandler
365     (
366         address _accountHandler,
367         bool _isAccountHandler
368     )
369         public
370         auth
371         note
372         addressValid(_accountHandler)
373     {
374         isAccountHandler[_accountHandler] = _isAccountHandler;
375     }
376 
377     function toggleAdminsControl() 
378         public
379         auth
380         note
381     {
382         disableAdminControl = !disableAdminControl;
383     }
384 
385     function isAdminValid(address _admin)
386         public
387         view
388         returns (bool)
389     {
390         if(disableAdminControl) {
391             return true;
392         } else {
393             return isAdmin[_admin];
394         }
395     }
396 
397     function getAllAdmins()
398         public
399         view
400         returns(address[])
401     {
402         return admins;
403     }
404 
405     function addAdmin
406     (
407         address _admin
408     )
409         external
410         note
411         onlyAdmin
412         addressValid(_admin)
413     {   
414         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
415 
416         admins.push(_admin);
417         isAdmin[_admin] = true;
418 
419         emit LogAdminAdded(_admin, msg.sender);
420     }
421 
422     function removeAdmin
423     (
424         address _admin
425     ) 
426         external
427         note
428         onlyAdmin
429         addressValid(_admin)
430     {   
431         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
432         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
433 
434         isAdmin[_admin] = false;
435 
436         for (uint i = 0; i < admins.length - 1; i++) {
437             if (admins[i] == _admin) {
438                 admins[i] = admins[admins.length - 1];
439                 admins.length -= 1;
440                 break;
441             }
442         }
443 
444         emit LogAdminRemoved(_admin, msg.sender);
445     }
446 }
447 
448 library ECRecovery {
449 
450     function recover(bytes32 _hash, bytes _sig)
451         internal
452         pure
453     returns (address)
454     {
455         bytes32 r;
456         bytes32 s;
457         uint8 v;
458 
459         if (_sig.length != 65) {
460             return (address(0));
461         }
462 
463         assembly {
464             r := mload(add(_sig, 32))
465             s := mload(add(_sig, 64))
466             v := byte(0, mload(add(_sig, 96)))
467         }
468 
469         if (v < 27) {
470             v += 27;
471         }
472 
473         if (v != 27 && v != 28) {
474             return (address(0));
475         } else {
476             return ecrecover(_hash, v, r, s);
477         }
478     }
479 
480     function toEthSignedMessageHash(bytes32 _hash)
481         internal
482         pure
483     returns (bytes32)
484     {
485         return keccak256(
486             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
487         );
488     }
489 }
490 
491 
492 contract Utils2 {
493     using ECRecovery for bytes32;
494     
495     function _recoverSigner(bytes32 _hash, bytes _signature) 
496         internal
497         pure
498         returns(address _signer)
499     {
500         return _hash.toEthSignedMessageHash().recover(_signature);
501     }
502 
503 }
504 
505 
506 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
507 
508     address[] public users;
509     mapping (address => bool) public isUser;
510     mapping (bytes32 => bool) public actionCompleted;
511 
512     WETH9 public weth9;
513     Config public config;
514     bool public isInitialized = false;
515 
516     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
517     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
518     event LogUserAdded(address indexed user, address by);
519     event LogUserRemoved(address indexed user, address by);
520     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
521 
522     modifier initialized() {
523         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
524         _;
525     }
526 
527     modifier notInitialized() {
528         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
529         _;
530     }
531 
532     modifier userExists(address _user) {
533         require(isUser[_user], "Account::_ INVALID_USER");
534         _;
535     }
536 
537     modifier userDoesNotExist(address _user) {
538         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
539         _;
540     }
541 
542     modifier onlyAdmin() {
543         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
544         _;
545     }
546 
547     modifier onlyHandler(){
548         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
549         _;
550     }
551 
552     function init(address _user, address _config)
553         public 
554         notInitialized
555     {
556         users.push(_user);
557         isUser[_user] = true;
558         config = Config(_config);
559         weth9 = config.weth9();
560         isInitialized = true;
561     }
562     
563     function getAllUsers() public view returns (address[]) {
564         return users;
565     }
566 
567     function balanceFor(address _token) public view returns (uint _balance){
568         _balance = ERC20(_token).balanceOf(this);
569     }
570     
571     function transferBySystem
572     (   
573         address _token,
574         address _to,
575         uint _value
576     ) 
577         external 
578         onlyHandler
579         note 
580         initialized
581     {
582         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
583         ERC20(_token).transfer(_to, _value);
584 
585         emit LogTransferBySystem(_token, _to, _value, msg.sender);
586     }
587     
588     function transferByUser
589     (   
590         address _token,
591         address _to,
592         uint _value,
593         uint _salt,
594         bytes _signature
595     )
596         external
597         addressValid(_to)
598         note
599         initialized
600         onlyAdmin
601     {
602         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
603 
604         if(actionCompleted[actionHash]) {
605             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
606             return;
607         }
608 
609         if(ERC20(_token).balanceOf(this) < _value){
610             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
611             return;
612         }
613 
614         address signer = _recoverSigner(actionHash, _signature);
615 
616         if(!isUser[signer]) {
617             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
618             return;
619         }
620 
621         actionCompleted[actionHash] = true;
622         
623         if (_token == address(weth9)) {
624             weth9.withdraw(_value);
625             _to.transfer(_value);
626         } else {
627             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
628         }
629 
630         emit LogTransferByUser(_token, _to, _value, signer);
631     }
632 
633     function addUser
634     (
635         address _user,
636         uint _salt,
637         bytes _signature
638     )
639         external 
640         note 
641         addressValid(_user)
642         userDoesNotExist(_user)
643         initialized
644         onlyAdmin
645     {   
646         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
647         if(actionCompleted[actionHash])
648         {
649             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
650             return;
651         }
652 
653         address signer = _recoverSigner(actionHash, _signature);
654 
655         if(!isUser[signer]) {
656             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
657             return;
658         }
659 
660         actionCompleted[actionHash] = true;
661 
662         users.push(_user);
663         isUser[_user] = true;
664 
665         emit LogUserAdded(_user, signer);
666     }
667 
668     function removeUser
669     (
670         address _user,
671         uint _salt,
672         bytes _signature
673     ) 
674         external
675         note
676         userExists(_user) 
677         initialized
678         onlyAdmin
679     {   
680         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
681 
682         if(actionCompleted[actionHash]) {
683             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
684             return;
685         }
686 
687         address signer = _recoverSigner(actionHash, _signature);
688         
689         if(users.length == 1){
690             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
691             return;
692         }
693         
694         if(!isUser[signer]){
695             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
696             return;
697         }
698         
699         actionCompleted[actionHash] = true;
700 
701         // should delete value from isUser map? delete isUser[_user]?
702         isUser[_user] = false;
703         for (uint i = 0; i < users.length - 1; i++) {
704             if (users[i] == _user) {
705                 users[i] = users[users.length - 1];
706                 users.length -= 1;
707                 break;
708             }
709         }
710 
711         emit LogUserRemoved(_user, signer);
712     }
713 
714     function _getTransferActionHash
715     ( 
716         address _token,
717         address _to,
718         uint _value,
719         uint _salt
720     ) 
721         internal
722         view
723         returns (bytes32)
724     {
725         return keccak256(
726             abi.encodePacked(
727                 address(this),
728                 _token,
729                 _to,
730                 _value,
731                 _salt
732             )
733         );
734     }
735 
736     function _getUserActionHash
737     ( 
738         address _user,
739         string _action,
740         uint _salt
741     ) 
742         internal
743         view
744         returns (bytes32)
745     {
746         return keccak256(
747             abi.encodePacked(
748                 address(this),
749                 _user,
750                 _action,
751                 _salt
752             )
753         );
754     }
755 
756     // to directly send ether to contract
757     function() external payable {
758         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
759 
760         if(msg.sender != address(weth9)){
761             weth9.deposit.value(msg.value)();
762         }
763     }
764 
765     function changeImpl
766     (
767         address _to,
768         uint _salt,
769         bytes _signature
770     )
771         external 
772         note 
773         addressValid(_to)
774         initialized
775         onlyAdmin
776     {   
777         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
778         if(actionCompleted[actionHash])
779         {
780             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
781             return;
782         }
783 
784         address signer = _recoverSigner(actionHash, _signature);
785 
786         if(!isUser[signer]) {
787             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
788             return;
789         }
790 
791         actionCompleted[actionHash] = true;
792 
793         address oldImpl = masterCopy;
794         this.changeMasterCopy(_to);
795         
796         emit LogImplChanged(_to, oldImpl);
797     }
798 
799 }
800 
801 
802 contract Escrow is DSNote, DSAuth {
803 
804     event LogTransfer(address indexed token, address indexed to, uint value);
805     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
806 
807     function transfer
808     (
809         address _token,
810         address _to,
811         uint _value
812     )
813         public
814         note
815         auth
816     {
817         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
818         emit LogTransfer(_token, _to, _value);
819     }
820 
821     function transferFromAccount
822     (
823         address _account,
824         address _token,
825         address _to,
826         uint _value
827     )
828         public
829         note
830         auth
831     {   
832         Account(_account).transferBySystem(_token, _to, _value);
833         emit LogTransferFromAccount(_account, _token, _to, _value);
834     }
835 
836 }
837 
838 // issue with deploying multiple instances of same type in truffle, hence the following two contracts
839 contract KernelEscrow is Escrow {
840 
841 }
842 
843 contract ReserveEscrow is Escrow {
844     
845 }
846 
847 
848 interface ExchangeConnector {
849 
850     function tradeWithInputFixed
851     (   
852         Escrow _escrow,
853         address _srcToken,
854         address _destToken,
855         uint _srcTokenValue
856     )
857         external
858         returns (uint _destTokenValue, uint _srcTokenValueLeft);
859 
860     function tradeWithOutputFixed
861     (   
862         Escrow _escrow,
863         address _srcToken,
864         address _destToken,
865         uint _srcTokenValue,
866         uint _maxDestTokenValue
867     )
868         external
869         returns (uint _destTokenValue, uint _srcTokenValueLeft);
870     
871 
872     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
873         external
874         view
875         returns(uint _expectedRate, uint _slippageRate);
876     
877     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
878         external
879         view
880         returns(bool);
881 
882 }
883 contract KyberConnector is ExchangeConnector, DSThing, Utils {
884     KyberNetworkProxy public kyber;
885     address public feeWallet;
886 
887     uint constant internal KYBER_MAX_QTY = (10**28);
888 
889     constructor(KyberNetworkProxy _kyber, address _feeWallet) public {
890         kyber = _kyber;
891         feeWallet = _feeWallet;
892     }
893 
894     function setKyber(KyberNetworkProxy _kyber) 
895         public
896         auth
897         addressValid(_kyber)
898     {
899         kyber = _kyber;
900     }
901 
902     function setFeeWallet(address _feeWallet) 
903         public 
904         note 
905         auth
906         addressValid(_feeWallet)
907     {
908         feeWallet = _feeWallet;
909     }
910     
911 
912     event LogTrade
913     (
914         address indexed _from,
915         address indexed _srcToken,
916         address indexed _destToken,
917         uint _srcTokenValue,
918         uint _maxDestTokenValue,
919         uint _destTokenValue,
920         uint _srcTokenValueLeft,
921         uint _exchangeRate
922     );
923 
924     function tradeWithInputFixed
925     (   
926         Escrow _escrow,
927         address _srcToken,
928         address _destToken,
929         uint _srcTokenValue
930     )
931         public    
932         note
933         auth
934         returns (uint _destTokenValue, uint _srcTokenValueLeft)
935     {
936         return tradeWithOutputFixed(_escrow, _srcToken, _destToken, _srcTokenValue, KYBER_MAX_QTY);
937     }
938 
939     function tradeWithOutputFixed
940     (   
941         Escrow _escrow,
942         address _srcToken,
943         address _destToken,
944         uint _srcTokenValue,
945         uint _maxDestTokenValue
946     )
947         public
948         note
949         auth
950         returns (uint _destTokenValue, uint _srcTokenValueLeft)
951     {   
952         require(_srcToken != _destToken, "KyberConnector::tradeWithOutputFixed TOKEN_ADDRS_SHOULD_NOT_MATCH");
953 
954         uint _slippageRate;
955         (, _slippageRate) = getExpectedRate(_srcToken, _destToken, _srcTokenValue);
956 
957         uint initialSrcTokenBalance = ERC20(_srcToken).balanceOf(this);
958 
959         require(ERC20(_srcToken).balanceOf(_escrow) >= _srcTokenValue, "KyberConnector::tradeWithOutputFixed INSUFFICIENT_BALANCE_IN_ESCROW");
960         _escrow.transfer(_srcToken, this, _srcTokenValue);
961 
962         require(ERC20(_srcToken).approve(kyber, 0), "KyberConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
963         require(ERC20(_srcToken).approve(kyber, _srcTokenValue), "KyberConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
964         
965         _destTokenValue = kyber.tradeWithHint(
966             ERC20(_srcToken),
967             _srcTokenValue,
968             ERC20(_destToken),
969             this,
970             _maxDestTokenValue,
971             _slippageRate, // no min coversation rate
972             feeWallet, 
973             ""
974         );
975 
976         _srcTokenValueLeft = sub(ERC20(_srcToken).balanceOf(this), initialSrcTokenBalance);
977 
978         require(_transfer(_destToken, _escrow, _destTokenValue), "KyberConnector::tradeWithOutputFixed DEST_TOKEN_TRANSFER_FAILED");
979         
980         if(_srcTokenValueLeft > 0) {
981             require(_transfer(_srcToken, _escrow, _srcTokenValueLeft), "KyberConnector::tradeWithOutputFixed SRC_TOKEN_TRANSFER_FAILED");
982         }
983 
984         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _maxDestTokenValue, _destTokenValue, _srcTokenValueLeft, _slippageRate);
985     } 
986 
987     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
988         public
989         view
990         returns(uint _expectedRate, uint _slippageRate)
991     {
992         (_expectedRate, _slippageRate) = kyber.getExpectedRate(ERC20(_srcToken), ERC20(_destToken), _srcTokenValue);
993     }
994 
995     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
996         public
997         view
998         returns(bool)
999     {
1000         uint slippageRate; 
1001 
1002         (, slippageRate) = getExpectedRate(
1003             _srcToken,
1004             _destToken,
1005             _srcTokenValue
1006         );
1007 
1008          return slippageRate == 0 ? false : true;
1009     }
1010 
1011     function _transfer
1012     (
1013         address _token,
1014         address _to,
1015         uint _value
1016     )
1017         internal
1018         returns (bool)
1019     {
1020         return ERC20(_token).transfer(_to, _value);
1021     }
1022 }