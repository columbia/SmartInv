1 pragma solidity 0.4.24;
2 
3 
4 interface UniswapFactory {
5     function getExchange(address token) external view returns (address exchange);
6     function getToken(address exchange) external view returns (address token);
7     function getTokenWithId(uint256 tokenId) external view returns (address token);
8 }
9 
10 
11 contract ErrorUtils {
12 
13     event LogError(string methodSig, string errMsg);
14     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
15     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
16 
17 }
18 
19 
20 contract SelfAuthorized {
21     modifier authorized() {
22         require(msg.sender == address(this), "Method can only be called from this contract");
23         _;
24     }
25 }
26 
27 
28 contract DSNote {
29     event LogNote(
30         bytes4   indexed  sig,
31         address  indexed  guy,
32         bytes32  indexed  foo,
33         bytes32  indexed  bar,
34         uint              wad,
35         bytes             fax
36     ) anonymous;
37 
38     modifier note {
39         bytes32 foo;
40         bytes32 bar;
41 
42         assembly {
43             foo := calldataload(4)
44             bar := calldataload(36)
45         }
46 
47         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
48 
49         _;
50     }
51 }
52 
53 
54 contract DSAuthority {
55     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
56 }
57 
58 
59 contract DSAuthEvents {
60     event LogSetAuthority (address indexed authority);
61     event LogSetOwner     (address indexed owner);
62 }
63 
64 
65 contract DSAuth is DSAuthEvents {
66     DSAuthority  public  authority;
67     address      public  owner;
68 
69     constructor() public {
70         owner = msg.sender;
71         emit LogSetOwner(msg.sender);
72     }
73 
74     function setOwner(address owner_)
75         public
76         auth
77     {
78         owner = owner_;
79         emit LogSetOwner(owner);
80     }
81 
82     function setAuthority(DSAuthority authority_)
83         public
84         auth
85     {
86         authority = authority_;
87         emit LogSetAuthority(authority);
88     }
89 
90     modifier auth {
91         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
92         _;
93     }
94 
95     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
96         if (src == address(this)) {
97             return true;
98         } else if (src == owner) {
99             return true;
100         } else if (authority == DSAuthority(0)) {
101             return false;
102         } else {
103             return authority.canCall(src, this, sig);
104         }
105     }
106 }
107 
108 
109 contract WETH9 {
110     string public name     = "Wrapped Ether";
111     string public symbol   = "WETH";
112     uint8  public decimals = 18;
113 
114     event  Approval(address indexed _owner, address indexed _spender, uint _value);
115     event  Transfer(address indexed _from, address indexed _to, uint _value);
116     event  Deposit(address indexed _owner, uint _value);
117     event  Withdrawal(address indexed _owner, uint _value);
118 
119     mapping (address => uint)                       public  balanceOf;
120     mapping (address => mapping (address => uint))  public  allowance;
121 
122     function() public payable {
123         deposit();
124     }
125 
126     function deposit() public payable {
127         balanceOf[msg.sender] += msg.value;
128         Deposit(msg.sender, msg.value);
129     }
130 
131     function withdraw(uint wad) public {
132         require(balanceOf[msg.sender] >= wad);
133         balanceOf[msg.sender] -= wad;
134         msg.sender.transfer(wad);
135         Withdrawal(msg.sender, wad);
136     }
137 
138     function totalSupply() public view returns (uint) {
139         return this.balance;
140     }
141 
142     function approve(address guy, uint wad) public returns (bool) {
143         allowance[msg.sender][guy] = wad;
144         Approval(msg.sender, guy, wad);
145         return true;
146     }
147 
148     function transfer(address dst, uint wad) public returns (bool) {
149         return transferFrom(msg.sender, dst, wad);
150     }
151 
152     function transferFrom(address src, address dst, uint wad)
153         public
154         returns (bool)
155     {
156         require(balanceOf[src] >= wad);
157 
158         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
159             require(allowance[src][msg.sender] >= wad);
160             allowance[src][msg.sender] -= wad;
161         }
162 
163         balanceOf[src] -= wad;
164         balanceOf[dst] += wad;
165 
166         Transfer(src, dst, wad);
167 
168         return true;
169     }
170 }
171 
172 
173 contract UniswapExchange {
174 
175     // Address of ERC20 token sold on this exchange
176     function tokenAddress() external view returns (address token);
177     // Address of Uniswap Factory
178     function factoryAddress() external view returns (address factory);
179     
180     // Get Prices
181     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
182     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
183     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
184     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
185 
186     // Trade ETH to ERC20
187     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
188     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
189     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
190     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
191 
192     // Trade ERC20 to ETH
193     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
194     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
195     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
196     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
197 
198     // Trade ERC20 to ERC20
199     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
200     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
201     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
202     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
203 
204 }
205 
206 
207 interface ERC20 {
208 
209     function name() external view returns(string);
210     function symbol() external view returns(string);
211     function decimals() external view returns(uint8);
212     function totalSupply() external view returns (uint);
213 
214     function balanceOf(address tokenOwner) external view returns (uint balance);
215     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
216     function transfer(address to, uint tokens) external returns (bool success);
217     function approve(address spender, uint tokens) external returns (bool success);
218     function transferFrom(address from, address to, uint tokens) external returns (bool success);
219 
220     event Transfer(address indexed from, address indexed to, uint tokens);
221     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
222 }
223 
224 
225 contract Utils {
226 
227     modifier addressValid(address _address) {
228         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
229         _;
230     }
231 
232 }
233 
234 
235 contract DSMath {
236     function add(uint x, uint y) internal pure returns (uint z) {
237         require((z = x + y) >= x);
238     }
239     function sub(uint x, uint y) internal pure returns (uint z) {
240         require((z = x - y) <= x);
241     }
242     function mul(uint x, uint y) internal pure returns (uint z) {
243         require(y == 0 || (z = x * y) / y == x);
244     }
245 
246     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
247     function div(uint x, uint y) internal pure returns (uint z) {
248         z = x / y;
249     }
250 
251     function min(uint x, uint y) internal pure returns (uint z) {
252         return x <= y ? x : y;
253     }
254     function max(uint x, uint y) internal pure returns (uint z) {
255         return x >= y ? x : y;
256     }
257     function imin(int x, int y) internal pure returns (int z) {
258         return x <= y ? x : y;
259     }
260     function imax(int x, int y) internal pure returns (int z) {
261         return x >= y ? x : y;
262     }
263 
264     uint constant WAD = 10 ** 18;
265     uint constant RAY = 10 ** 27;
266 
267     function wmul(uint x, uint y) internal pure returns (uint z) {
268         z = add(mul(x, y), WAD / 2) / WAD;
269     }
270     function rmul(uint x, uint y) internal pure returns (uint z) {
271         z = add(mul(x, y), RAY / 2) / RAY;
272     }
273     function wdiv(uint x, uint y) internal pure returns (uint z) {
274         z = add(mul(x, WAD), y / 2) / y;
275     }
276     function rdiv(uint x, uint y) internal pure returns (uint z) {
277         z = add(mul(x, RAY), y / 2) / y;
278     }
279 
280     // This famous algorithm is called "exponentiation by squaring"
281     // and calculates x^n with x as fixed-point and n as regular unsigned.
282     //
283     // It's O(log n), instead of O(n) for naive repeated multiplication.
284     //
285     // These facts are why it works:
286     //
287     //  If n is even, then x^n = (x^2)^(n/2).
288     //  If n is odd,  then x^n = x * x^(n-1),
289     //   and applying the equation for even x gives
290     //    x^n = x * (x^2)^((n-1) / 2).
291     //
292     //  Also, EVM division is flooring and
293     //    floor[(n-1) / 2] = floor[n / 2].
294     //
295     function rpow(uint x, uint n) internal pure returns (uint z) {
296         z = n % 2 != 0 ? x : RAY;
297 
298         for (n /= 2; n != 0; n /= 2) {
299             x = rmul(x, x);
300 
301             if (n % 2 != 0) {
302                 z = rmul(z, x);
303             }
304         }
305     }
306 }
307 
308 
309 library ECRecovery {
310 
311     function recover(bytes32 _hash, bytes _sig)
312         internal
313         pure
314     returns (address)
315     {
316         bytes32 r;
317         bytes32 s;
318         uint8 v;
319 
320         if (_sig.length != 65) {
321             return (address(0));
322         }
323 
324         assembly {
325             r := mload(add(_sig, 32))
326             s := mload(add(_sig, 64))
327             v := byte(0, mload(add(_sig, 96)))
328         }
329 
330         if (v < 27) {
331             v += 27;
332         }
333 
334         if (v != 27 && v != 28) {
335             return (address(0));
336         } else {
337             return ecrecover(_hash, v, r, s);
338         }
339     }
340 
341     function toEthSignedMessageHash(bytes32 _hash)
342         internal
343         pure
344     returns (bytes32)
345     {
346         return keccak256(
347             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
348         );
349     }
350 }
351 
352 
353 contract Utils2 {
354     using ECRecovery for bytes32;
355     
356     function _recoverSigner(bytes32 _hash, bytes _signature) 
357         internal
358         pure
359         returns(address _signer)
360     {
361         return _hash.toEthSignedMessageHash().recover(_signature);
362     }
363 
364 }
365 
366 
367 contract DSThing is DSNote, DSAuth, DSMath {
368 
369     function S(string s) internal pure returns (bytes4) {
370         return bytes4(keccak256(s));
371     }
372 
373 }
374 
375 
376 contract MasterCopy is SelfAuthorized {
377   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
378   // It should also always be ensured that the address is stored alone (uses a full word)
379     address masterCopy;
380 
381   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
382   /// @param _masterCopy New contract address.
383     function changeMasterCopy(address _masterCopy)
384         public
385         authorized
386     {
387         // Master copy address cannot be null.
388         require(_masterCopy != 0, "Invalid master copy address provided");
389         masterCopy = _masterCopy;
390     }
391 }
392 
393 
394 
395 contract Config is DSNote, DSAuth, Utils {
396 
397     WETH9 public weth9;
398     mapping (address => bool) public isAccountHandler;
399     mapping (address => bool) public isAdmin;
400     address[] public admins;
401     bool public disableAdminControl = false;
402     
403     event LogAdminAdded(address indexed _admin, address _by);
404     event LogAdminRemoved(address indexed _admin, address _by);
405 
406     constructor() public {
407         admins.push(msg.sender);
408         isAdmin[msg.sender] = true;
409     }
410 
411     modifier onlyAdmin(){
412         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
413         _;
414     }
415 
416     function setWETH9
417     (
418         address _weth9
419     ) 
420         public
421         auth
422         note
423         addressValid(_weth9) 
424     {
425         weth9 = WETH9(_weth9);
426     }
427 
428     function setAccountHandler
429     (
430         address _accountHandler,
431         bool _isAccountHandler
432     )
433         public
434         auth
435         note
436         addressValid(_accountHandler)
437     {
438         isAccountHandler[_accountHandler] = _isAccountHandler;
439     }
440 
441     function toggleAdminsControl() 
442         public
443         auth
444         note
445     {
446         disableAdminControl = !disableAdminControl;
447     }
448 
449     function isAdminValid(address _admin)
450         public
451         view
452         returns (bool)
453     {
454         if(disableAdminControl) {
455             return true;
456         } else {
457             return isAdmin[_admin];
458         }
459     }
460 
461     function getAllAdmins()
462         public
463         view
464         returns(address[])
465     {
466         return admins;
467     }
468 
469     function addAdmin
470     (
471         address _admin
472     )
473         external
474         note
475         onlyAdmin
476         addressValid(_admin)
477     {   
478         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
479 
480         admins.push(_admin);
481         isAdmin[_admin] = true;
482 
483         emit LogAdminAdded(_admin, msg.sender);
484     }
485 
486     function removeAdmin
487     (
488         address _admin
489     ) 
490         external
491         note
492         onlyAdmin
493         addressValid(_admin)
494     {   
495         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
496         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
497 
498         isAdmin[_admin] = false;
499 
500         for (uint i = 0; i < admins.length - 1; i++) {
501             if (admins[i] == _admin) {
502                 admins[i] = admins[admins.length - 1];
503                 admins.length -= 1;
504                 break;
505             }
506         }
507 
508         emit LogAdminRemoved(_admin, msg.sender);
509     }
510 }
511 
512 
513 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
514 
515     address[] public users;
516     mapping (address => bool) public isUser;
517     mapping (bytes32 => bool) public actionCompleted;
518 
519     WETH9 public weth9;
520     Config public config;
521     bool public isInitialized = false;
522 
523     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
524     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
525     event LogUserAdded(address indexed user, address by);
526     event LogUserRemoved(address indexed user, address by);
527     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
528 
529     modifier initialized() {
530         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
531         _;
532     }
533 
534     modifier notInitialized() {
535         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
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
549     modifier onlyAdmin() {
550         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
551         _;
552     }
553 
554     modifier onlyHandler(){
555         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
556         _;
557     }
558 
559     function init(address _user, address _config)
560         public 
561         notInitialized
562     {
563         users.push(_user);
564         isUser[_user] = true;
565         config = Config(_config);
566         weth9 = config.weth9();
567         isInitialized = true;
568     }
569     
570     function getAllUsers() public view returns (address[]) {
571         return users;
572     }
573 
574     function balanceFor(address _token) public view returns (uint _balance){
575         _balance = ERC20(_token).balanceOf(this);
576     }
577     
578     function transferBySystem
579     (   
580         address _token,
581         address _to,
582         uint _value
583     ) 
584         external 
585         onlyHandler
586         note 
587         initialized
588     {
589         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
590         ERC20(_token).transfer(_to, _value);
591 
592         emit LogTransferBySystem(_token, _to, _value, msg.sender);
593     }
594     
595     function transferByUser
596     (   
597         address _token,
598         address _to,
599         uint _value,
600         uint _salt,
601         bytes _signature
602     )
603         external
604         addressValid(_to)
605         note
606         initialized
607         onlyAdmin
608     {
609         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
610 
611         if(actionCompleted[actionHash]) {
612             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
613             return;
614         }
615 
616         if(ERC20(_token).balanceOf(this) < _value){
617             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
618             return;
619         }
620 
621         address signer = _recoverSigner(actionHash, _signature);
622 
623         if(!isUser[signer]) {
624             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
625             return;
626         }
627 
628         actionCompleted[actionHash] = true;
629         
630         if (_token == address(weth9)) {
631             weth9.withdraw(_value);
632             _to.transfer(_value);
633         } else {
634             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
635         }
636 
637         emit LogTransferByUser(_token, _to, _value, signer);
638     }
639 
640     function addUser
641     (
642         address _user,
643         uint _salt,
644         bytes _signature
645     )
646         external 
647         note 
648         addressValid(_user)
649         userDoesNotExist(_user)
650         initialized
651         onlyAdmin
652     {   
653         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
654         if(actionCompleted[actionHash])
655         {
656             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
657             return;
658         }
659 
660         address signer = _recoverSigner(actionHash, _signature);
661 
662         if(!isUser[signer]) {
663             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
664             return;
665         }
666 
667         actionCompleted[actionHash] = true;
668 
669         users.push(_user);
670         isUser[_user] = true;
671 
672         emit LogUserAdded(_user, signer);
673     }
674 
675     function removeUser
676     (
677         address _user,
678         uint _salt,
679         bytes _signature
680     ) 
681         external
682         note
683         userExists(_user) 
684         initialized
685         onlyAdmin
686     {   
687         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
688 
689         if(actionCompleted[actionHash]) {
690             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
691             return;
692         }
693 
694         address signer = _recoverSigner(actionHash, _signature);
695         
696         if(users.length == 1){
697             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
698             return;
699         }
700         
701         if(!isUser[signer]){
702             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
703             return;
704         }
705         
706         actionCompleted[actionHash] = true;
707 
708         // should delete value from isUser map? delete isUser[_user]?
709         isUser[_user] = false;
710         for (uint i = 0; i < users.length - 1; i++) {
711             if (users[i] == _user) {
712                 users[i] = users[users.length - 1];
713                 users.length -= 1;
714                 break;
715             }
716         }
717 
718         emit LogUserRemoved(_user, signer);
719     }
720 
721     function _getTransferActionHash
722     ( 
723         address _token,
724         address _to,
725         uint _value,
726         uint _salt
727     ) 
728         internal
729         view
730         returns (bytes32)
731     {
732         return keccak256(
733             abi.encodePacked(
734                 address(this),
735                 _token,
736                 _to,
737                 _value,
738                 _salt
739             )
740         );
741     }
742 
743     function _getUserActionHash
744     ( 
745         address _user,
746         string _action,
747         uint _salt
748     ) 
749         internal
750         view
751         returns (bytes32)
752     {
753         return keccak256(
754             abi.encodePacked(
755                 address(this),
756                 _user,
757                 _action,
758                 _salt
759             )
760         );
761     }
762 
763     // to directly send ether to contract
764     function() external payable {
765         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
766 
767         if(msg.sender != address(weth9)){
768             weth9.deposit.value(msg.value)();
769         }
770     }
771 
772     function changeImpl
773     (
774         address _to,
775         uint _salt,
776         bytes _signature
777     )
778         external 
779         note 
780         addressValid(_to)
781         initialized
782         onlyAdmin
783     {   
784         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
785         if(actionCompleted[actionHash])
786         {
787             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
788             return;
789         }
790 
791         address signer = _recoverSigner(actionHash, _signature);
792 
793         if(!isUser[signer]) {
794             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
795             return;
796         }
797 
798         actionCompleted[actionHash] = true;
799 
800         address oldImpl = masterCopy;
801         this.changeMasterCopy(_to);
802         
803         emit LogImplChanged(_to, oldImpl);
804     }
805 
806 }
807 
808 
809 contract Escrow is DSNote, DSAuth {
810 
811     event LogTransfer(address indexed token, address indexed to, uint value);
812     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
813 
814     function transfer
815     (
816         address _token,
817         address _to,
818         uint _value
819     )
820         public
821         note
822         auth
823     {
824         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
825         emit LogTransfer(_token, _to, _value);
826     }
827 
828     function transferFromAccount
829     (
830         address _account,
831         address _token,
832         address _to,
833         uint _value
834     )
835         public
836         note
837         auth
838     {   
839         Account(_account).transferBySystem(_token, _to, _value);
840         emit LogTransferFromAccount(_account, _token, _to, _value);
841     }
842 
843 }
844 
845 // issue with deploying multiple instances of same type in truffle, hence the following two contracts
846 contract KernelEscrow is Escrow {
847 
848 }
849 
850 contract ReserveEscrow is Escrow {
851     
852 }
853 
854 
855 interface ExchangeConnector {
856 
857     function tradeWithInputFixed
858     (   
859         Escrow _escrow,
860         address _srcToken,
861         address _destToken,
862         uint _srcTokenValue
863     )
864         external
865         returns (uint _destTokenValue, uint _srcTokenValueLeft);
866 
867     function tradeWithOutputFixed
868     (   
869         Escrow _escrow,
870         address _srcToken,
871         address _destToken,
872         uint _srcTokenValue,
873         uint _maxDestTokenValue
874     )
875         external
876         returns (uint _destTokenValue, uint _srcTokenValueLeft);
877     
878 
879     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
880         external
881         view
882         returns(uint _expectedRate, uint _slippageRate);
883     
884     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue) 
885         external
886         view
887         returns(bool);
888 
889 }
890 
891 
892 contract UniswapConnector is ExchangeConnector, DSThing, Utils {
893     UniswapFactory public uniswapFactory;
894 
895     uint constant internal TOKEN_ALLOWED_SLIPPAGE = 4 * (10**16);
896     uint constant internal DEADLINE_DURATION = 2 * 60 * 60; // 2 hr
897 
898     constructor(UniswapFactory _uniswapFactory) public {
899         uniswapFactory = _uniswapFactory;
900     }
901 
902     function setUniswapFactory(UniswapFactory _uniswapFactory) 
903         public
904         auth
905         addressValid(_uniswapFactory)
906     {
907         uniswapFactory = _uniswapFactory;
908     }
909 
910     event LogTrade
911     (
912         address indexed _from,
913         address indexed _srcToken,
914         address indexed _destToken,
915         uint _srcTokenValue,
916         uint _maxDestTokenValue,
917         uint _destTokenValue,
918         uint _srcTokenValueLeft, 
919         uint _exchangeRate
920     );
921 
922     
923     function tradeWithInputFixed
924     (   
925         Escrow _escrow,
926         address _srcToken,
927         address _destToken,
928         uint _srcTokenValue
929     )
930         public    
931         note
932         auth
933         returns (uint _destTokenValue, uint _srcTokenValueLeft)
934     {      
935         require(_srcToken != _destToken, "UniswapConnector::_validateTradeInputs TOKEN_ADDRS_SHOULD_NOT_MATCH");
936         require(_isExchangeAvailable(_srcToken), "UniswapConnector::_validateTradeInputs NO_EXCHNAGE_FOUND_FOR_SOURCE");
937         require(_isExchangeAvailable(_destToken), "UniswapConnector::_validateTradeInputs NO_EXCHNAGE_FOUND_FOR_DEST");
938         require(ERC20(_srcToken).balanceOf(_escrow) >= _srcTokenValue, "UniswapConnector::_validateTradeInputs INSUFFICIENT_BALANCE_IN_ESCROW");
939 
940         uint initialSrcTokenBalance = ERC20(_srcToken).balanceOf(this);
941         uint initialDestTokenBalance = ERC20(_destToken).balanceOf(this);
942         _escrow.transfer(_srcToken, this, _srcTokenValue);
943 
944         address uniswapExchangeAddr = uniswapFactory.getExchange(_srcToken);
945         
946         ERC20(_srcToken).approve(uniswapExchangeAddr, 0);
947         ERC20(_srcToken).approve(uniswapExchangeAddr, _srcTokenValue);
948         
949         uint exchangeRate = _performTradeWithInputFixed(_srcToken, _destToken, _srcTokenValue);
950 
951         _srcTokenValueLeft = sub(ERC20(_srcToken).balanceOf(this), initialSrcTokenBalance);
952         _destTokenValue = sub(ERC20(_destToken).balanceOf(this), initialDestTokenBalance);
953 
954         _transfer(_destToken, _escrow, _destTokenValue);
955 
956         if (_srcTokenValueLeft > 0) {
957             _transfer(_srcToken, _escrow, _srcTokenValueLeft);
958         }
959         
960         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _destTokenValue, _destTokenValue, _srcTokenValueLeft, exchangeRate);
961     }
962 
963     function tradeWithOutputFixed
964     (   
965         Escrow _escrow,
966         address _srcToken,
967         address _destToken,
968         uint _srcTokenValue,
969         uint _maxDestTokenValue
970     )
971         public
972         note
973         auth
974         returns (uint _destTokenValue, uint _srcTokenValueLeft)
975     {   
976 
977         require(_srcToken != _destToken, "UniswapConnector::_validateTradeInputs TOKEN_ADDRS_SHOULD_NOT_MATCH");
978         require(_isExchangeAvailable(_srcToken), "UniswapConnector::_validateTradeInputs NO_EXCHNAGE_FOUND_FOR_SOURCE");
979         require(_isExchangeAvailable(_destToken), "UniswapConnector::_validateTradeInputs NO_EXCHNAGE_FOUND_FOR_DEST");
980         require(ERC20(_srcToken).balanceOf(_escrow) >= _srcTokenValue, "UniswapConnector::_validateTradeInputs INSUFFICIENT_BALANCE_IN_ESCROW");
981 
982         uint initialSrcTokenBalance = ERC20(_srcToken).balanceOf(this);
983         uint initialDestTokenBalance = ERC20(_destToken).balanceOf(this);
984         _escrow.transfer(_srcToken, this, _srcTokenValue);
985 
986         address uniswapExchangeAddr = uniswapFactory.getExchange(_srcToken);
987 
988         require(ERC20(_srcToken).approve(uniswapExchangeAddr, 0), "UniswapConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
989         require(ERC20(_srcToken).approve(uniswapExchangeAddr, _srcTokenValue), "UniswapConnector::tradeWithOutputFixed SRC_APPROVAL_FAILED");
990 
991         uint exchangeRate = _performTradeWithOutputFixed(_srcToken, _destToken, _maxDestTokenValue);
992 
993         _srcTokenValueLeft = sub(ERC20(_srcToken).balanceOf(this), initialSrcTokenBalance);
994         _destTokenValue = sub(ERC20(_destToken).balanceOf(this), initialDestTokenBalance);
995 
996         require(_transfer(_destToken, _escrow, _destTokenValue), "UniswapConnector::tradeWithOutputFixed DEST_TOKEN_TRANSFER_FAILED");
997 
998         if(_srcTokenValueLeft > 0){
999             require(_transfer(_srcToken, _escrow, _srcTokenValueLeft), "UniswapConnector::tradeWithOutputFixed SRC_TOKEN_TRANSFER_FAILED");
1000         }
1001 
1002         emit LogTrade(_escrow, _srcToken, _destToken, _srcTokenValue, _maxDestTokenValue, _destTokenValue, _srcTokenValueLeft, exchangeRate);
1003     } 
1004     
1005     function getExpectedRate(address _srcToken, address _destToken, uint _srcTokenValue) 
1006         public
1007         view
1008         returns(uint _expectedRate, uint _slippageRate)
1009     {
1010         if(address(_srcToken) == address(_destToken)) {
1011             return (0, 0);
1012         }
1013 
1014         if(!_isExchangeAvailable(_srcToken) || !_isExchangeAvailable(_destToken)) {
1015             return (0, 0);
1016         }
1017 
1018         uint inputValue = _srcTokenValue; 
1019         uint outputValue; 
1020         uint exchangeRate;
1021 
1022         (outputValue, exchangeRate) = _calcValuesForTokenToTokenInput(_srcToken, _destToken, inputValue);
1023         // todo: make slippage 0 if its too low, define a low value
1024         _expectedRate = exchangeRate;
1025         _slippageRate = div(mul(exchangeRate, sub(WAD, TOKEN_ALLOWED_SLIPPAGE)), WAD);
1026     }
1027 
1028     function isTradeFeasible(address _srcToken, address _destToken, uint _srcTokenValue)
1029         public
1030         view
1031         returns(bool)
1032     {
1033         uint slippageRate; 
1034 
1035         (, slippageRate) = getExpectedRate(
1036             _srcToken,
1037             _destToken,
1038             _srcTokenValue
1039         );
1040 
1041             return slippageRate == 0 ? false : true;
1042     }
1043     
1044     function _isExchangeAvailable(address _token)
1045         internal
1046         view
1047         returns(bool)
1048     {
1049         address uniswapExchangeAddr = uniswapFactory.getExchange(_token);
1050         return (uniswapExchangeAddr != address(0));
1051     }
1052 
1053     function _performTradeWithInputFixed(
1054         address _srcToken,
1055         address _destToken,
1056         uint _srcTokenValue
1057     )
1058         internal
1059         returns (uint _exchangeRate)
1060     {
1061         address uniswapExchangeAddr = uniswapFactory.getExchange(_srcToken);
1062         UniswapExchange exchange = UniswapExchange(uniswapExchangeAddr);
1063 
1064         uint inputValue = _srcTokenValue;
1065         uint outputValue;
1066 
1067         (outputValue, _exchangeRate) = _calcValuesForTokenToTokenInput(_srcToken, _destToken, inputValue);
1068         
1069         exchange.tokenToTokenSwapInput(
1070             inputValue,
1071             div(mul(outputValue, sub(WAD, TOKEN_ALLOWED_SLIPPAGE)), WAD),
1072             1,
1073             add(now,DEADLINE_DURATION),
1074             _destToken
1075         );
1076 
1077     }
1078 
1079     function _performTradeWithOutputFixed(
1080         address _srcToken,
1081         address _destToken,
1082         uint _maxDestTokenValue
1083     )
1084         internal
1085         returns (uint _exchangeRate)
1086     {
1087         address uniswapExchangeAddr = uniswapFactory.getExchange(_srcToken);
1088         UniswapExchange exchange = UniswapExchange(uniswapExchangeAddr);
1089 
1090         uint outputValue = _maxDestTokenValue;
1091         uint inputValue; 
1092         uint inputValueB;
1093    
1094         (inputValue, _exchangeRate, inputValueB) = _calcValuesForTokenToTokenOutput(_srcToken, _destToken, outputValue);
1095         
1096         exchange.tokenToTokenSwapOutput(
1097             outputValue,
1098             div(mul(inputValue, add(WAD, TOKEN_ALLOWED_SLIPPAGE)),WAD),
1099             div(mul(inputValueB, add(WAD, 20 * (10**16))),WAD),
1100             add(now,DEADLINE_DURATION),
1101             _destToken
1102         );
1103     }
1104 
1105     function _calcValuesForTokenToTokenOutput
1106     (
1107         address _srcToken,
1108         address _destToken,
1109         uint _maxDestTokenValue
1110     )
1111         internal
1112         view
1113         returns
1114         (
1115             uint _inputValue,
1116             uint _exchangeRate,
1117             uint _inputValueB
1118         )
1119     {
1120         uint inputReserveA;
1121         uint outputReserveA;
1122         uint inputReserveB;
1123         uint outputReserveB;
1124 
1125         (inputReserveA, outputReserveA, inputReserveB, outputReserveB) = _fetchReserveValues(_srcToken, _destToken);
1126 
1127         uint outputValue = _maxDestTokenValue;
1128         uint outputAmountB = _maxDestTokenValue;
1129         uint inputAmountB = _calculateEtherTokenInput(outputAmountB, inputReserveB, outputReserveB);
1130 
1131         // redundant variable for readability of the formala
1132         // inputAmount from the first swap becomes outputAmount of the second swap
1133         uint outputAmountA = inputAmountB;
1134         uint inputAmountA = _calculateEtherTokenInput(outputAmountA, inputReserveA, outputReserveA);
1135 
1136         _inputValue = inputAmountA;
1137         _exchangeRate = div(mul(outputValue, WAD), _inputValue);
1138         _inputValueB = inputAmountB;
1139     }
1140  
1141     function _calcValuesForTokenToTokenInput
1142     (
1143         address _srcToken,
1144         address _destToken,
1145         uint _srcTokenValue
1146     ) 
1147         internal
1148         view
1149         returns
1150         (
1151             uint _outputValue,
1152             uint _exchangeRate
1153         )
1154     {   
1155         uint inputReserveA;
1156         uint outputReserveA;
1157         uint inputReserveB;
1158         uint outputReserveB;
1159 
1160         (inputReserveA, outputReserveA, inputReserveB, outputReserveB) = _fetchReserveValues(_srcToken, _destToken);
1161 
1162         uint inputValue = _srcTokenValue;
1163         uint inputAmountA = inputValue;
1164 
1165         uint outputAmountA = _calculateEtherTokenOutput(inputAmountA, inputReserveA, outputReserveA);
1166 
1167         // redundant variable for readability of the formala
1168         // outputAmount from the first swap becomes inputAmount of the second swap
1169         uint inputAmountB = outputAmountA;
1170         uint outputAmountB = _calculateEtherTokenOutput(inputAmountB, inputReserveB, outputReserveB);
1171 
1172         _outputValue = outputAmountB;
1173         _exchangeRate = div(mul(_outputValue, WAD), inputValue);
1174     }
1175 
1176     function _fetchReserveValues(address _srcToken, address _destToken)
1177         internal
1178         view
1179         returns(
1180             uint _inputReserveA,
1181             uint _outputReserveA,
1182             uint _inputReserveB,
1183             uint _outputReserveB
1184         )
1185     {
1186         address exchangeAddrA = uniswapFactory.getExchange(_srcToken);
1187         address exchangeAddrB = uniswapFactory.getExchange(_destToken);
1188 
1189         _inputReserveA = ERC20(_srcToken).balanceOf(exchangeAddrA);
1190         _outputReserveA = address(exchangeAddrA).balance;
1191 
1192         _inputReserveB = address(exchangeAddrB).balance;
1193         _outputReserveB = ERC20(_destToken).balanceOf(exchangeAddrB);
1194     }
1195 
1196     function _calculateEtherTokenOutput(uint _inputAmount, uint _inputReserve, uint _outputReserve) 
1197         internal
1198         pure
1199         returns (uint)
1200     {
1201         uint numerator = mul(mul(_inputAmount, _outputReserve), 997);
1202         uint denominator = add(mul(_inputReserve,1000), mul(_inputAmount, 997));
1203 
1204         return div(numerator, denominator);
1205     }
1206 
1207     function _calculateEtherTokenInput(uint _outputAmount, uint _inputReserve, uint _outputReserve)
1208         internal
1209         pure
1210         returns (uint)
1211     {
1212         uint numerator = mul(mul(_outputAmount, _inputReserve), 1000);
1213         uint denominator = mul(sub(_outputReserve, _outputAmount), 997);
1214 
1215         return add(div(numerator, denominator), 1);
1216     }
1217 
1218     function _transfer
1219     (
1220         address _token,
1221         address _to,
1222         uint _value
1223     )
1224         internal
1225         returns (bool)
1226     {
1227         return ERC20(_token).transfer(_to, _value);
1228     }
1229 }