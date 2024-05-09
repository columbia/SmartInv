1 pragma solidity 0.4.24;
2 
3 
4 contract MasterCopy {
5     address masterCopy;
6 
7     function changeMasterCopy(address _masterCopy)
8         public
9     {
10         require(_masterCopy != 0, "Invalid master copy address provided");
11         masterCopy = _masterCopy;
12     }
13 }
14 
15 
16 contract DSNote {
17     event LogNote(
18         bytes4   indexed  sig,
19         address  indexed  guy,
20         bytes32  indexed  foo,
21         bytes32  indexed  bar,
22         uint              wad,
23         bytes             fax
24     ) anonymous;
25 
26     modifier note {
27         bytes32 foo;
28         bytes32 bar;
29 
30         assembly {
31             foo := calldataload(4)
32             bar := calldataload(36)
33         }
34 
35         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
36 
37         _;
38     }
39 }
40 
41 
42 contract DSMath {
43     function add(uint x, uint y) internal pure returns (uint z) {
44         require((z = x + y) >= x);
45     }
46     function sub(uint x, uint y) internal pure returns (uint z) {
47         require((z = x - y) <= x);
48     }
49     function mul(uint x, uint y) internal pure returns (uint z) {
50         require(y == 0 || (z = x * y) / y == x);
51     }
52 
53     // custom : not in original DSMath, putting it here for consistency, copied from SafeMath
54     function div(uint x, uint y) internal pure returns (uint z) {
55         z = x / y;
56     }
57 
58     function min(uint x, uint y) internal pure returns (uint z) {
59         return x <= y ? x : y;
60     }
61     function max(uint x, uint y) internal pure returns (uint z) {
62         return x >= y ? x : y;
63     }
64     function imin(int x, int y) internal pure returns (int z) {
65         return x <= y ? x : y;
66     }
67     function imax(int x, int y) internal pure returns (int z) {
68         return x >= y ? x : y;
69     }
70 
71     uint constant WAD = 10 ** 18;
72     uint constant RAY = 10 ** 27;
73 
74     function wmul(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, y), WAD / 2) / WAD;
76     }
77     function rmul(uint x, uint y) internal pure returns (uint z) {
78         z = add(mul(x, y), RAY / 2) / RAY;
79     }
80     function wdiv(uint x, uint y) internal pure returns (uint z) {
81         z = add(mul(x, WAD), y / 2) / y;
82     }
83     function rdiv(uint x, uint y) internal pure returns (uint z) {
84         z = add(mul(x, RAY), y / 2) / y;
85     }
86 
87     // This famous algorithm is called "exponentiation by squaring"
88     // and calculates x^n with x as fixed-point and n as regular unsigned.
89     //
90     // It's O(log n), instead of O(n) for naive repeated multiplication.
91     //
92     // These facts are why it works:
93     //
94     //  If n is even, then x^n = (x^2)^(n/2).
95     //  If n is odd,  then x^n = x * x^(n-1),
96     //   and applying the equation for even x gives
97     //    x^n = x * (x^2)^((n-1) / 2).
98     //
99     //  Also, EVM division is flooring and
100     //    floor[(n-1) / 2] = floor[n / 2].
101     //
102     function rpow(uint x, uint n) internal pure returns (uint z) {
103         z = n % 2 != 0 ? x : RAY;
104 
105         for (n /= 2; n != 0; n /= 2) {
106             x = rmul(x, x);
107 
108             if (n % 2 != 0) {
109                 z = rmul(z, x);
110             }
111         }
112     }
113 }
114 
115 
116 contract Utils {
117 
118     modifier addressValid(address _address) {
119         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
120         _;
121     }
122 
123 }
124 
125 
126 interface ERC20 {
127 
128     function name() public view returns(string);
129     function symbol() public view returns(string);
130     function decimals() public view returns(uint8);
131     function totalSupply() public view returns (uint);
132 
133     function balanceOf(address tokenOwner) public view returns (uint balance);
134     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
135     function transfer(address to, uint tokens) public returns (bool success);
136     function approve(address spender, uint tokens) public returns (bool success);
137     function transferFrom(address from, address to, uint tokens) public returns (bool success);
138 
139     event Transfer(address indexed from, address indexed to, uint tokens);
140     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
141 }
142 
143 
144 contract WETH9 {
145     string public name     = "Wrapped Ether";
146     string public symbol   = "WETH";
147     uint8  public decimals = 18;
148 
149     event  Approval(address indexed _owner, address indexed _spender, uint _value);
150     event  Transfer(address indexed _from, address indexed _to, uint _value);
151     event  Deposit(address indexed _owner, uint _value);
152     event  Withdrawal(address indexed _owner, uint _value);
153 
154     mapping (address => uint)                       public  balanceOf;
155     mapping (address => mapping (address => uint))  public  allowance;
156 
157     function() public payable {
158         deposit();
159     }
160 
161     function deposit() public payable {
162         balanceOf[msg.sender] += msg.value;
163         Deposit(msg.sender, msg.value);
164     }
165 
166     function withdraw(uint wad) public {
167         require(balanceOf[msg.sender] >= wad);
168         balanceOf[msg.sender] -= wad;
169         msg.sender.transfer(wad);
170         Withdrawal(msg.sender, wad);
171     }
172 
173     function totalSupply() public view returns (uint) {
174         return this.balance;
175     }
176 
177     function approve(address guy, uint wad) public returns (bool) {
178         allowance[msg.sender][guy] = wad;
179         Approval(msg.sender, guy, wad);
180         return true;
181     }
182 
183     function transfer(address dst, uint wad) public returns (bool) {
184         return transferFrom(msg.sender, dst, wad);
185     }
186 
187     function transferFrom(address src, address dst, uint wad)
188         public
189         returns (bool)
190     {
191         require(balanceOf[src] >= wad);
192 
193         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
194             require(allowance[src][msg.sender] >= wad);
195             allowance[src][msg.sender] -= wad;
196         }
197 
198         balanceOf[src] -= wad;
199         balanceOf[dst] += wad;
200 
201         Transfer(src, dst, wad);
202 
203         return true;
204     }
205 }
206 
207 
208 contract ErrorUtils {
209     event LogError(string methodSig, string errMsg);
210     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
211     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
212 
213 }
214 
215 
216 contract DSAuthority {
217     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
218 }
219 
220 
221 contract DSAuthEvents {
222     event LogSetAuthority (address indexed authority);
223     event LogSetOwner     (address indexed owner);
224 }
225 
226 
227 contract DSAuth is DSAuthEvents {
228     DSAuthority  public  authority;
229     address      public  owner;
230 
231     constructor() public {
232         owner = msg.sender;
233         emit LogSetOwner(msg.sender);
234     }
235 
236     function setOwner(address owner_)
237         public
238         auth
239     {
240         owner = owner_;
241         emit LogSetOwner(owner);
242     }
243 
244     function setAuthority(DSAuthority authority_)
245         public
246         auth
247     {
248         authority = authority_;
249         emit LogSetAuthority(authority);
250     }
251 
252     modifier auth {
253         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
254         _;
255     }
256 
257     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
258         if (src == address(this)) {
259             return true;
260         } else if (src == owner) {
261             return true;
262         } else if (authority == DSAuthority(0)) {
263             return false;
264         } else {
265             return authority.canCall(src, this, sig);
266         }
267     }
268 }
269 
270 
271 contract DSThing is DSNote, DSAuth, DSMath {
272 
273     function S(string s) internal pure returns (bytes4) {
274         return bytes4(keccak256(s));
275     }
276 
277 }
278 
279 
280 contract Config is DSNote, DSAuth, Utils {
281 
282     WETH9 public weth9;
283     mapping (address => bool) public isAccountHandler;
284     mapping (address => bool) public isAdmin;
285     address[] public admins;
286     bool public disableAdminControl = false;
287     
288     event LogAdminAdded(address indexed _admin, address _by);
289     event LogAdminRemoved(address indexed _admin, address _by);
290 
291     constructor() public {
292         admins.push(msg.sender);
293         isAdmin[msg.sender] = true;
294     }
295 
296     modifier onlyAdmin(){
297         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
298         _;
299     }
300 
301     function setWETH9
302     (
303         address _weth9
304     ) 
305         public
306         auth
307         note
308         addressValid(_weth9) 
309     {
310         weth9 = WETH9(_weth9);
311     }
312 
313     function setAccountHandler
314     (
315         address _accountHandler,
316         bool _isAccountHandler
317     )
318         public
319         auth
320         note
321         addressValid(_accountHandler)
322     {
323         isAccountHandler[_accountHandler] = _isAccountHandler;
324     }
325 
326     function toggleAdminsControl() 
327         public
328         auth
329         note
330     {
331         disableAdminControl = !disableAdminControl;
332     }
333 
334     function isAdminValid(address _admin)
335         public
336         view
337         returns (bool)
338     {
339         if(disableAdminControl) {
340             return true;
341         } else {
342             return isAdmin[_admin];
343         }
344     }
345 
346     function getAllAdmins()
347         public
348         view
349         returns(address[])
350     {
351         return admins;
352     }
353 
354     function addAdmin
355     (
356         address _admin
357     )
358         external
359         note
360         onlyAdmin
361         addressValid(_admin)
362     {   
363         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
364 
365         admins.push(_admin);
366         isAdmin[_admin] = true;
367 
368         emit LogAdminAdded(_admin, msg.sender);
369     }
370 
371     function removeAdmin
372     (
373         address _admin
374     ) 
375         external
376         note
377         onlyAdmin
378         addressValid(_admin)
379     {   
380         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
381         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
382 
383         isAdmin[_admin] = false;
384 
385         for (uint i = 0; i < admins.length - 1; i++) {
386             if (admins[i] == _admin) {
387                 admins[i] = admins[admins.length - 1];
388                 admins.length -= 1;
389                 break;
390             }
391         }
392 
393         emit LogAdminRemoved(_admin, msg.sender);
394     }
395 }
396 
397 library ECRecovery {
398 
399     function recover(bytes32 _hash, bytes _sig)
400         internal
401         pure
402     returns (address)
403     {
404         bytes32 r;
405         bytes32 s;
406         uint8 v;
407 
408         if (_sig.length != 65) {
409             return (address(0));
410         }
411 
412         assembly {
413             r := mload(add(_sig, 32))
414             s := mload(add(_sig, 64))
415             v := byte(0, mload(add(_sig, 96)))
416         }
417 
418         if (v < 27) {
419             v += 27;
420         }
421 
422         if (v != 27 && v != 28) {
423             return (address(0));
424         } else {
425             return ecrecover(_hash, v, r, s);
426         }
427     }
428 
429     function toEthSignedMessageHash(bytes32 _hash)
430         internal
431         pure
432     returns (bytes32)
433     {
434         return keccak256(
435             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
436         );
437     }
438 }
439 
440 
441 contract Utils2 {
442     using ECRecovery for bytes32;
443     
444     function _recoverSigner(bytes32 _hash, bytes _signature) 
445         internal
446         pure
447         returns(address _signer)
448     {
449         return _hash.toEthSignedMessageHash().recover(_signature);
450     }
451 
452 }
453 
454 
455 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
456 
457     address[] public users;
458     mapping (address => bool) public isUser;
459     mapping (bytes32 => bool) public actionCompleted;
460 
461     WETH9 public weth9;
462     Config public config;
463     bool public isInitialized = false;
464 
465     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
466     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
467     event LogUserAdded(address indexed user, address by);
468     event LogUserRemoved(address indexed user, address by);
469 
470     modifier initialized() {
471         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
472         _;
473     }
474 
475     modifier userExists(address _user) {
476         require(isUser[_user], "Account::_ INVALID_USER");
477         _;
478     }
479 
480     modifier userDoesNotExist(address _user) {
481         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
482         _;
483     }
484 
485     modifier onlyHandler(){
486         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
487         _;
488     }
489 
490     function init(address _user, address _config) public {
491         users.push(_user);
492         isUser[_user] = true;
493         config = Config(_config);
494         weth9 = config.weth9();
495         isInitialized = true;
496     }
497     
498     function getAllUsers() public view returns (address[]) {
499         return users;
500     }
501 
502     function balanceFor(address _token) public view returns (uint _balance){
503         _balance = ERC20(_token).balanceOf(this);
504     }
505     
506     function transferBySystem
507     (   
508         address _token,
509         address _to,
510         uint _value
511     ) 
512         external 
513         onlyHandler
514         note 
515         initialized
516     {
517         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
518         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
519 
520         emit LogTransferBySystem(_token, _to, _value, msg.sender);
521     }
522     
523     function transferByUser
524     (   
525         address _token,
526         address _to,
527         uint _value,
528         uint _salt,
529         bytes _signature
530     ) 
531         external
532         addressValid(_to)
533         note
534         initialized
535     {
536         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
537 
538         if(actionCompleted[actionHash]) {
539             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
540             return;
541         }
542 
543         if(ERC20(_token).balanceOf(this) < _value){
544             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
545             return;
546         }
547 
548         address signer = _recoverSigner(actionHash, _signature);
549 
550         if(!isUser[signer]) {
551             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
552             return;
553         }
554 
555         actionCompleted[actionHash] = true;
556         
557         if (_token == address(weth9)) {
558             weth9.withdraw(_value);
559             _to.transfer(_value);
560         } else {
561             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
562         }
563 
564         emit LogTransferByUser(_token, _to, _value, signer);
565     }
566 
567     function addUser
568     (
569         address _user,
570         uint _salt,
571         bytes _signature
572     )
573         external 
574         note 
575         addressValid(_user)
576         userDoesNotExist(_user)
577         initialized
578     {   
579         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
580         if(actionCompleted[actionHash])
581         {
582             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
583             return;
584         }
585 
586         address signer = _recoverSigner(actionHash, _signature);
587 
588         if(!isUser[signer]) {
589             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
590             return;
591         }
592 
593         actionCompleted[actionHash] = true;
594 
595         users.push(_user);
596         isUser[_user] = true;
597 
598         emit LogUserAdded(_user, signer);
599     }
600 
601     function removeUser
602     (
603         address _user,
604         uint _salt,
605         bytes _signature
606     ) 
607         external
608         note
609         userExists(_user) 
610         initialized
611     {   
612         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
613 
614         if(actionCompleted[actionHash]) {
615             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
616             return;
617         }
618 
619         address signer = _recoverSigner(actionHash, _signature);
620         
621         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
622         if(!isUser[signer]){
623             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
624             return;
625         }
626         
627         actionCompleted[actionHash] = true;
628 
629         isUser[_user] = false;
630         for (uint i = 0; i < users.length - 1; i++) {
631             if (users[i] == _user) {
632                 users[i] = users[users.length - 1];
633                 users.length -= 1;
634                 break;
635             }
636         }
637 
638         emit LogUserRemoved(_user, signer);
639     }
640 
641     function _getTransferActionHash
642     ( 
643         address _token,
644         address _to,
645         uint _value,
646         uint _salt
647     ) 
648         internal
649         view
650         returns (bytes32)
651     {
652         return keccak256(
653             abi.encodePacked(
654                 address(this),
655                 _token,
656                 _to,
657                 _value,
658                 _salt
659             )
660         );
661     }
662 
663     function _getUserActionHash
664     ( 
665         address _user,
666         string _action,
667         uint _salt
668     ) 
669         internal
670         view
671         returns (bytes32)
672     {
673         return keccak256(
674             abi.encodePacked(
675                 address(this),
676                 _user,
677                 _action,
678                 _salt
679             )
680         );
681     }
682 
683     // to directly send ether to contract
684     function() external payable {
685         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
686 
687         if(msg.sender != address(weth9)){
688             weth9.deposit.value(msg.value)();
689         }
690     }
691     
692 }
693 
694 
695 contract Escrow is DSNote, DSAuth {
696 
697     event LogTransfer(address indexed token, address indexed to, uint value);
698     event LogTransferFromAccount(address indexed account, address indexed token, address indexed to, uint value);
699 
700     function transfer
701     (
702         address _token,
703         address _to,
704         uint _value
705     )
706         public
707         note
708         auth
709     {
710         require(ERC20(_token).transfer(_to, _value), "Escrow::transfer TOKEN_TRANSFER_FAILED");
711         emit LogTransfer(_token, _to, _value);
712     }
713 
714     function transferFromAccount
715     (
716         address _account,
717         address _token,
718         address _to,
719         uint _value
720     )
721         public
722         note
723         auth
724     {   
725         Account(_account).transferBySystem(_token, _to, _value);
726         emit LogTransferFromAccount(_account, _token, _to, _value);
727     }
728 
729 }
730 
731 contract KernelEscrow is Escrow {
732 
733 }