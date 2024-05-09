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
13 contract DSAuthority {
14     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
15 }
16 
17 contract DSAuthEvents {
18     event LogSetAuthority (address indexed authority);
19     event LogSetOwner     (address indexed owner);
20 }
21 
22 contract DSAuth is DSAuthEvents {
23     DSAuthority  public  authority;
24     address      public  owner;
25 
26     constructor() public {
27         owner = msg.sender;
28         emit LogSetOwner(msg.sender);
29     }
30 
31     function setOwner(address owner_)
32         public
33         auth
34     {
35         owner = owner_;
36         emit LogSetOwner(owner);
37     }
38 
39     function setAuthority(DSAuthority authority_)
40         public
41         auth
42     {
43         authority = authority_;
44         emit LogSetAuthority(authority);
45     }
46 
47     modifier auth {
48         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
49         _;
50     }
51 
52     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
53         if (src == address(this)) {
54             return true;
55         } else if (src == owner) {
56             return true;
57         } else if (authority == DSAuthority(0)) {
58             return false;
59         } else {
60             return authority.canCall(src, this, sig);
61         }
62     }
63 }
64 
65 
66 contract DSNote {
67     event LogNote(
68         bytes4   indexed  sig,
69         address  indexed  guy,
70         bytes32  indexed  foo,
71         bytes32  indexed  bar,
72         uint              wad,
73         bytes             fax
74     ) anonymous;
75 
76     modifier note {
77         bytes32 foo;
78         bytes32 bar;
79 
80         assembly {
81             foo := calldataload(4)
82             bar := calldataload(36)
83         }
84 
85         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
86 
87         _;
88     }
89 }
90 
91 
92 contract DSMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x);
95     }
96     function sub(uint x, uint y) internal pure returns (uint z) {
97         require((z = x - y) <= x);
98     }
99     function mul(uint x, uint y) internal pure returns (uint z) {
100         require(y == 0 || (z = x * y) / y == x);
101     }
102 
103     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
104     function div(uint x, uint y) internal pure returns (uint z) {
105         z = x / y;
106     }
107 
108     function min(uint x, uint y) internal pure returns (uint z) {
109         return x <= y ? x : y;
110     }
111     function max(uint x, uint y) internal pure returns (uint z) {
112         return x >= y ? x : y;
113     }
114     function imin(int x, int y) internal pure returns (int z) {
115         return x <= y ? x : y;
116     }
117     function imax(int x, int y) internal pure returns (int z) {
118         return x >= y ? x : y;
119     }
120 
121     uint constant WAD = 10 ** 18;
122     uint constant RAY = 10 ** 27;
123 
124     function wmul(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, y), WAD / 2) / WAD;
126     }
127     function rmul(uint x, uint y) internal pure returns (uint z) {
128         z = add(mul(x, y), RAY / 2) / RAY;
129     }
130     function wdiv(uint x, uint y) internal pure returns (uint z) {
131         z = add(mul(x, WAD), y / 2) / y;
132     }
133     function rdiv(uint x, uint y) internal pure returns (uint z) {
134         z = add(mul(x, RAY), y / 2) / y;
135     }
136 
137     // This famous algorithm is called "exponentiation by squaring"
138     // and calculates x^n with x as fixed-point and n as regular unsigned.
139     //
140     // It's O(log n), instead of O(n) for naive repeated multiplication.
141     //
142     // These facts are why it works:
143     //
144     //  If n is even, then x^n = (x^2)^(n/2).
145     //  If n is odd,  then x^n = x * x^(n-1),
146     //   and applying the equation for even x gives
147     //    x^n = x * (x^2)^((n-1) / 2).
148     //
149     //  Also, EVM division is flooring and
150     //    floor[(n-1) / 2] = floor[n / 2].
151     //
152     function rpow(uint x, uint n) internal pure returns (uint z) {
153         z = n % 2 != 0 ? x : RAY;
154 
155         for (n /= 2; n != 0; n /= 2) {
156             x = rmul(x, x);
157 
158             if (n % 2 != 0) {
159                 z = rmul(z, x);
160             }
161         }
162     }
163 }
164 
165 
166 contract MasterCopy {
167     address masterCopy;
168 
169     function changeMasterCopy(address _masterCopy)
170         public
171     {
172 
173         require(_masterCopy != 0, "Invalid master copy address provided");
174         masterCopy = _masterCopy;
175     }
176 }
177 
178 
179 interface ERC20 {
180 
181     function name() public view returns(string);
182     function symbol() public view returns(string);
183     function decimals() public view returns(uint8);
184     function totalSupply() public view returns (uint);
185 
186     function balanceOf(address tokenOwner) public view returns (uint balance);
187     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
188     function transfer(address to, uint tokens) public returns (bool success);
189     function approve(address spender, uint tokens) public returns (bool success);
190     function transferFrom(address from, address to, uint tokens) public returns (bool success);
191 
192     event Transfer(address indexed from, address indexed to, uint tokens);
193     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
194 }
195 
196 
197 contract WETH9 {
198     string public name     = "Wrapped Ether";
199     string public symbol   = "WETH";
200     uint8  public decimals = 18;
201 
202     event  Approval(address indexed _owner, address indexed _spender, uint _value);
203     event  Transfer(address indexed _from, address indexed _to, uint _value);
204     event  Deposit(address indexed _owner, uint _value);
205     event  Withdrawal(address indexed _owner, uint _value);
206 
207     mapping (address => uint)                       public  balanceOf;
208     mapping (address => mapping (address => uint))  public  allowance;
209 
210     function() public payable {
211         deposit();
212     }
213 
214     function deposit() public payable {
215         balanceOf[msg.sender] += msg.value;
216         Deposit(msg.sender, msg.value);
217     }
218 
219     function withdraw(uint wad) public {
220         require(balanceOf[msg.sender] >= wad);
221         balanceOf[msg.sender] -= wad;
222         msg.sender.transfer(wad);
223         Withdrawal(msg.sender, wad);
224     }
225 
226     function totalSupply() public view returns (uint) {
227         return this.balance;
228     }
229 
230     function approve(address guy, uint wad) public returns (bool) {
231         allowance[msg.sender][guy] = wad;
232         Approval(msg.sender, guy, wad);
233         return true;
234     }
235 
236     function transfer(address dst, uint wad) public returns (bool) {
237         return transferFrom(msg.sender, dst, wad);
238     }
239 
240     function transferFrom(address src, address dst, uint wad)
241         public
242         returns (bool)
243     {
244         require(balanceOf[src] >= wad);
245 
246         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
247             require(allowance[src][msg.sender] >= wad);
248             allowance[src][msg.sender] -= wad;
249         }
250 
251         balanceOf[src] -= wad;
252         balanceOf[dst] += wad;
253 
254         Transfer(src, dst, wad);
255 
256         return true;
257     }
258 }
259 
260 
261 contract ErrorUtils {
262 
263     event LogError(string methodSig, string errMsg);
264     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
265     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
266 
267 }
268 
269 
270 contract DSThing is DSNote, DSAuth, DSMath {
271 
272     function S(string s) internal pure returns (bytes4) {
273         return bytes4(keccak256(s));
274     }
275 
276 }
277 
278 library ECRecovery {
279 
280     function recover(bytes32 _hash, bytes _sig)
281         internal
282         pure
283     returns (address)
284     {
285         bytes32 r;
286         bytes32 s;
287         uint8 v;
288 
289         if (_sig.length != 65) {
290             return (address(0));
291         }
292 
293         assembly {
294             r := mload(add(_sig, 32))
295             s := mload(add(_sig, 64))
296             v := byte(0, mload(add(_sig, 96)))
297         }
298 
299         if (v < 27) {
300             v += 27;
301         }
302 
303         if (v != 27 && v != 28) {
304             return (address(0));
305         } else {
306             return ecrecover(_hash, v, r, s);
307         }
308     }
309 
310     function toEthSignedMessageHash(bytes32 _hash)
311         internal
312         pure
313     returns (bytes32)
314     {
315         return keccak256(
316             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
317         );
318     }
319 }
320 
321 
322 contract Utils2 {
323     using ECRecovery for bytes32;
324     
325     function _recoverSigner(bytes32 _hash, bytes _signature) 
326         internal
327         pure
328         returns(address _signer)
329     {
330         return _hash.toEthSignedMessageHash().recover(_signature);
331     }
332 
333 }
334 
335 
336 contract Config is DSNote, DSAuth, Utils {
337 
338     WETH9 public weth9;
339     mapping (address => bool) public isAccountHandler;
340     mapping (address => bool) public isAdmin;
341     address[] public admins;
342     bool public disableAdminControl = false;
343     
344     event LogAdminAdded(address indexed _admin, address _by);
345     event LogAdminRemoved(address indexed _admin, address _by);
346 
347     constructor() public {
348         admins.push(msg.sender);
349         isAdmin[msg.sender] = true;
350     }
351 
352     modifier onlyAdmin(){
353         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
354         _;
355     }
356 
357     function setWETH9
358     (
359         address _weth9
360     ) 
361         public
362         auth
363         note
364         addressValid(_weth9) 
365     {
366         weth9 = WETH9(_weth9);
367     }
368 
369     function setAccountHandler
370     (
371         address _accountHandler,
372         bool _isAccountHandler
373     )
374         public
375         auth
376         note
377         addressValid(_accountHandler)
378     {
379         isAccountHandler[_accountHandler] = _isAccountHandler;
380     }
381 
382     function toggleAdminsControl() 
383         public
384         auth
385         note
386     {
387         disableAdminControl = !disableAdminControl;
388     }
389 
390     function isAdminValid(address _admin)
391         public
392         view
393         returns (bool)
394     {
395         if(disableAdminControl) {
396             return true;
397         } else {
398             return isAdmin[_admin];
399         }
400     }
401 
402     function getAllAdmins()
403         public
404         view
405         returns(address[])
406     {
407         return admins;
408     }
409 
410     function addAdmin
411     (
412         address _admin
413     )
414         external
415         note
416         onlyAdmin
417         addressValid(_admin)
418     {   
419         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
420 
421         admins.push(_admin);
422         isAdmin[_admin] = true;
423 
424         emit LogAdminAdded(_admin, msg.sender);
425     }
426 
427     function removeAdmin
428     (
429         address _admin
430     ) 
431         external
432         note
433         onlyAdmin
434         addressValid(_admin)
435     {   
436         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
437         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
438 
439         isAdmin[_admin] = false;
440 
441         for (uint i = 0; i < admins.length - 1; i++) {
442             if (admins[i] == _admin) {
443                 admins[i] = admins[admins.length - 1];
444                 admins.length -= 1;
445                 break;
446             }
447         }
448 
449         emit LogAdminRemoved(_admin, msg.sender);
450     }
451 }
452 
453 
454 interface KyberNetworkProxy {
455 
456     function maxGasPrice() public view returns(uint);
457     function getUserCapInWei(address user) public view returns(uint);
458     function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);
459     function enabled() public view returns(bool);
460     function info(bytes32 id) public view returns(uint);
461 
462     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minConversionRate) public returns(uint);
463     function swapEtherToToken(ERC20 token, uint minConversionRate) public payable returns(uint);
464     function swapTokenToEther(ERC20 token, uint srcAmount, uint minConversionRate) public returns(uint);
465 
466     function getExpectedRate
467     (
468         ERC20 src,
469         ERC20 dest, 
470         uint srcQty
471     ) 
472         public
473         view
474         returns 
475     (
476         uint expectedRate,
477         uint slippageRate
478     );
479 
480     function tradeWithHint
481     (
482         ERC20 src,
483         uint srcAmount,
484         ERC20 dest,
485         address destAddress,
486         uint maxDestAmount,
487         uint minConversionRate,
488         address walletId,
489         bytes hint
490     )
491         public 
492         payable 
493         returns(uint);
494         
495 }
496 
497 
498 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
499 
500     address[] public users;
501     mapping (address => bool) public isUser;
502     mapping (bytes32 => bool) public actionCompleted;
503 
504     WETH9 public weth9;
505     Config public config;
506     bool public isInitialized = false;
507 
508     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
509     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
510     event LogUserAdded(address indexed user, address by);
511     event LogUserRemoved(address indexed user, address by);
512 
513     modifier initialized() {
514         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
515         _;
516     }
517 
518     modifier userExists(address _user) {
519         require(isUser[_user], "Account::_ INVALID_USER");
520         _;
521     }
522 
523     modifier userDoesNotExist(address _user) {
524         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
525         _;
526     }
527 
528     modifier onlyHandler(){
529         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
530         _;
531     }
532 
533     function init(address _user, address _config) public {
534         users.push(_user);
535         isUser[_user] = true;
536         config = Config(_config);
537         weth9 = config.weth9();
538         isInitialized = true;
539     }
540     
541     function getAllUsers() public view returns (address[]) {
542         return users;
543     }
544 
545     function balanceFor(address _token) public view returns (uint _balance){
546         _balance = ERC20(_token).balanceOf(this);
547     }
548     
549     function transferBySystem
550     (   
551         address _token,
552         address _to,
553         uint _value
554     ) 
555         external 
556         onlyHandler
557         note 
558         initialized
559     {
560         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
561         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
562 
563         emit LogTransferBySystem(_token, _to, _value, msg.sender);
564     }
565     
566     function transferByUser
567     (   
568         address _token,
569         address _to,
570         uint _value,
571         uint _salt,
572         bytes _signature
573     ) 
574         external
575         addressValid(_to)
576         note
577         initialized
578     {
579         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
580 
581         if(actionCompleted[actionHash]) {
582             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
583             return;
584         }
585 
586         if(ERC20(_token).balanceOf(this) < _value){
587             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
588             return;
589         }
590 
591         address signer = _recoverSigner(actionHash, _signature);
592 
593         if(!isUser[signer]) {
594             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
595             return;
596         }
597 
598         actionCompleted[actionHash] = true;
599         
600         if (_token == address(weth9)) {
601             weth9.withdraw(_value);
602             _to.transfer(_value);
603         } else {
604             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
605         }
606 
607         emit LogTransferByUser(_token, _to, _value, signer);
608     }
609 
610     function addUser
611     (
612         address _user,
613         uint _salt,
614         bytes _signature
615     )
616         external 
617         note 
618         addressValid(_user)
619         userDoesNotExist(_user)
620         initialized
621     {   
622         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
623         if(actionCompleted[actionHash])
624         {
625             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
626             return;
627         }
628 
629         address signer = _recoverSigner(actionHash, _signature);
630 
631         if(!isUser[signer]) {
632             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
633             return;
634         }
635 
636         actionCompleted[actionHash] = true;
637 
638         users.push(_user);
639         isUser[_user] = true;
640 
641         emit LogUserAdded(_user, signer);
642     }
643 
644     function removeUser
645     (
646         address _user,
647         uint _salt,
648         bytes _signature
649     ) 
650         external
651         note
652         userExists(_user) 
653         initialized
654     {   
655         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
656 
657         if(actionCompleted[actionHash]) {
658             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
659             return;
660         }
661 
662         address signer = _recoverSigner(actionHash, _signature);
663         
664         // discussed with ratnesh -> 9-Jan-2019
665         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
666         if(!isUser[signer]){
667             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
668             return;
669         }
670         
671         actionCompleted[actionHash] = true;
672 
673         // should delete value from isUser map? delete isUser[_user]?
674         isUser[_user] = false;
675         for (uint i = 0; i < users.length - 1; i++) {
676             if (users[i] == _user) {
677                 users[i] = users[users.length - 1];
678                 users.length -= 1;
679                 break;
680             }
681         }
682 
683         emit LogUserRemoved(_user, signer);
684     }
685 
686     function _getTransferActionHash
687     ( 
688         address _token,
689         address _to,
690         uint _value,
691         uint _salt
692     ) 
693         internal
694         view
695         returns (bytes32)
696     {
697         return keccak256(
698             abi.encodePacked(
699                 address(this),
700                 _token,
701                 _to,
702                 _value,
703                 _salt
704             )
705         );
706     }
707 
708     function _getUserActionHash
709     ( 
710         address _user,
711         string _action,
712         uint _salt
713     ) 
714         internal
715         view
716         returns (bytes32)
717     {
718         return keccak256(
719             abi.encodePacked(
720                 address(this),
721                 _user,
722                 _action,
723                 _salt
724             )
725         );
726     }
727 
728     // to directly send ether to contract
729     function() external payable {
730         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
731 
732         if(msg.sender != address(weth9)){
733             weth9.deposit.value(msg.value)();
734         }
735     }
736     
737 }
738 
739 
740 contract Escrow is DSNote, DSAuth {
741 
742     event LogTransfer(address indexed token, address indexed to, uint value);
743     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
744 
745     function transfer
746     (
747         address _token,
748         address _to,
749         uint _value
750     )
751         public
752         note
753         auth
754     {
755         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
756         emit LogTransfer(_token, _to, _value);
757     }
758 
759     function transferFromAccount
760     (
761         address _account,
762         address _token,
763         address _to,
764         uint _value
765     )
766         public
767         note
768         auth
769     {   
770         Account(_account).transferBySystem(_token, _to, _value);
771         emit LogTransferFromAccount(_account, _token, _to, _value);
772     }
773 
774 }
775 
776 
777 contract KyberConnector is DSNote, DSAuth, Utils {
778     KyberNetworkProxy public kyber;
779 
780     constructor(KyberNetworkProxy _kyber) public {
781         kyber = _kyber;
782     }
783 
784     function setKyber(KyberNetworkProxy _kyber) 
785         public
786         auth
787         addressValid(_kyber)
788     {
789         kyber = _kyber;
790     }
791 
792     event LogTrade
793     (
794         address indexed _from,
795         address indexed _srcToken,
796         address indexed _destToken,
797         uint _srcTokenValue,
798         uint _maxDestTokenValue,
799         uint _destTokenValue,
800         uint _srcTokenValueLeft
801     );
802 
803     function trade
804     (   
805         Escrow _escrow,
806         ERC20 _srcToken,
807         ERC20 _destToken,
808         uint _srcTokenValue,
809         uint _maxDestTokenValue
810     )
811         external
812         note
813         auth
814         returns (uint _destTokenValue, uint _srcTokenValueLeft)
815     {   
816         require(address(_srcToken) != address(_destToken), "KyberConnector::process TOKEN_ADDRS_SHOULD_NOT_MATCH");
817 
818         uint _slippageRate;
819         (, _slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcTokenValue);
820 
821         uint initialSrcTokenBalance = _srcToken.balanceOf(this);
822 
823         require(_srcToken.balanceOf(_escrow) >= _srcTokenValue, "KyberConnector::process INSUFFICIENT_BALANCE_IN_ESCROW");
824         _escrow.transfer(_srcToken, this, _srcTokenValue);
825 
826         require(_srcToken.approve(kyber, 0), "KyberConnector::process SRC_APPROVAL_FAILED");
827         require(_srcToken.approve(kyber, _srcTokenValue), "KyberConnector::process SRC_APPROVAL_FAILED");
828         
829         _destTokenValue = kyber.tradeWithHint(
830             _srcToken,
831             _srcTokenValue,
832             _destToken,
833             this,
834             _maxDestTokenValue,
835             _slippageRate, //0, // no min coversation rate
836             address(0), // TODO: check if needed
837             ""// bytes(0) 
838         );
839 
840         _srcTokenValueLeft = _srcToken.balanceOf(this) - initialSrcTokenBalance;
841 
842         require(_transfer(_destToken, _escrow, _destTokenValue), "KyberConnector::process DEST_TOKEN_TRANSFER_FAILED");
843         require(_transfer(_srcToken, _escrow, _srcTokenValueLeft), "KyberConnector::process SRC_TOKEN_TRANSFER_FAILED");
844 
845         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _maxDestTokenValue, _destTokenValue, _srcTokenValueLeft);
846     } 
847 
848     function getExpectedRate(ERC20 _srcToken, ERC20 _destToken, uint _srcTokenValue) 
849         public
850         view
851         returns(uint _expectedRate, uint _slippageRate)
852     {
853         (_expectedRate, _slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcTokenValue);
854     }
855 
856     function isTradeFeasible(ERC20 _srcToken, ERC20 _destToken, uint _srcTokenValue) 
857         public
858         view
859         returns(bool)
860     {
861         uint slippageRate; 
862 
863         (, slippageRate) = getExpectedRate(
864             ERC20(_srcToken),
865             ERC20(_destToken),
866             _srcTokenValue
867         );
868 
869         return slippageRate == 0 ? false : true;
870     }
871 
872     function _transfer
873     (
874         ERC20 _token,
875         address _to,
876         uint _value
877     )
878         internal
879         returns (bool)
880     {
881         return _token.transfer(_to, _value);
882     }
883 }