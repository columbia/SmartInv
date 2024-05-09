1 pragma solidity 0.4.24;
2 
3 contract SelfAuthorized {
4     modifier authorized() {
5         require(msg.sender == address(this), "Method can only be called from this contract");
6         _;
7     }
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
20 contract WETH9 {
21     string public name     = "Wrapped Ether";
22     string public symbol   = "WETH";
23     uint8  public decimals = 18;
24 
25     event  Approval(address indexed _owner, address indexed _spender, uint _value);
26     event  Transfer(address indexed _from, address indexed _to, uint _value);
27     event  Deposit(address indexed _owner, uint _value);
28     event  Withdrawal(address indexed _owner, uint _value);
29 
30     mapping (address => uint)                       public  balanceOf;
31     mapping (address => mapping (address => uint))  public  allowance;
32 
33     function() public payable {
34         deposit();
35     }
36 
37     function deposit() public payable {
38         balanceOf[msg.sender] += msg.value;
39         Deposit(msg.sender, msg.value);
40     }
41 
42     function withdraw(uint wad) public {
43         require(balanceOf[msg.sender] >= wad);
44         balanceOf[msg.sender] -= wad;
45         msg.sender.transfer(wad);
46         Withdrawal(msg.sender, wad);
47     }
48 
49     function totalSupply() public view returns (uint) {
50         return this.balance;
51     }
52 
53     function approve(address guy, uint wad) public returns (bool) {
54         allowance[msg.sender][guy] = wad;
55         Approval(msg.sender, guy, wad);
56         return true;
57     }
58 
59     function transfer(address dst, uint wad) public returns (bool) {
60         return transferFrom(msg.sender, dst, wad);
61     }
62 
63     function transferFrom(address src, address dst, uint wad)
64         public
65         returns (bool)
66     {
67         require(balanceOf[src] >= wad);
68 
69         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
70             require(allowance[src][msg.sender] >= wad);
71             allowance[src][msg.sender] -= wad;
72         }
73 
74         balanceOf[src] -= wad;
75         balanceOf[dst] += wad;
76 
77         Transfer(src, dst, wad);
78 
79         return true;
80     }
81 }
82 
83 
84 contract Utils {
85 
86     modifier addressValid(address _address) {
87         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
88         _;
89     }
90 
91 }
92 
93 
94 contract DSAuthority {
95     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
96 }
97 
98 
99 contract DSAuthEvents {
100     event LogSetAuthority (address indexed authority);
101     event LogSetOwner     (address indexed owner);
102 }
103 
104 
105 contract DSAuth is DSAuthEvents {
106     DSAuthority  public  authority;
107     address      public  owner;
108 
109     constructor() public {
110         owner = msg.sender;
111         emit LogSetOwner(msg.sender);
112     }
113 
114     function setOwner(address owner_)
115         public
116         auth
117     {
118         owner = owner_;
119         emit LogSetOwner(owner);
120     }
121 
122     function setAuthority(DSAuthority authority_)
123         public
124         auth
125     {
126         authority = authority_;
127         emit LogSetAuthority(authority);
128     }
129 
130     modifier auth {
131         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
132         _;
133     }
134 
135     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
136         if (src == address(this)) {
137             return true;
138         } else if (src == owner) {
139             return true;
140         } else if (authority == DSAuthority(0)) {
141             return false;
142         } else {
143             return authority.canCall(src, this, sig);
144         }
145     }
146 }
147 
148 
149 contract DSNote {
150     event LogNote(
151         bytes4   indexed  sig,
152         address  indexed  guy,
153         bytes32  indexed  foo,
154         bytes32  indexed  bar,
155         uint              wad,
156         bytes             fax
157     ) anonymous;
158 
159     modifier note {
160         bytes32 foo;
161         bytes32 bar;
162 
163         assembly {
164             foo := calldataload(4)
165             bar := calldataload(36)
166         }
167 
168         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
169 
170         _;
171     }
172 }
173 
174 
175 interface ERC20 {
176 
177     function name() external view returns(string);
178     function symbol() external view returns(string);
179     function decimals() external view returns(uint8);
180     function totalSupply() external view returns (uint);
181 
182     function balanceOf(address tokenOwner) external view returns (uint balance);
183     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
184     function transfer(address to, uint tokens) external returns (bool success);
185     function approve(address spender, uint tokens) external returns (bool success);
186     function transferFrom(address from, address to, uint tokens) external returns (bool success);
187 
188     event Transfer(address indexed from, address indexed to, uint tokens);
189     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
190 }
191 
192 
193 contract MasterCopy is SelfAuthorized {
194   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
195   // It should also always be ensured that the address is stored alone (uses a full word)
196     address masterCopy;
197 
198   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
199   /// @param _masterCopy New contract address.
200     function changeMasterCopy(address _masterCopy)
201         public
202         authorized
203     {
204         // Master copy address cannot be null.
205         require(_masterCopy != 0, "Invalid master copy address provided");
206         masterCopy = _masterCopy;
207     }
208 }
209 
210 
211 contract Config is DSNote, DSAuth, Utils {
212 
213     WETH9 public weth9;
214     mapping (address => bool) public isAccountHandler;
215     mapping (address => bool) public isAdmin;
216     address[] public admins;
217     bool public disableAdminControl = false;
218     
219     event LogAdminAdded(address indexed _admin, address _by);
220     event LogAdminRemoved(address indexed _admin, address _by);
221 
222     constructor() public {
223         admins.push(msg.sender);
224         isAdmin[msg.sender] = true;
225     }
226 
227     modifier onlyAdmin(){
228         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
229         _;
230     }
231 
232     function setWETH9
233     (
234         address _weth9
235     ) 
236         public
237         auth
238         note
239         addressValid(_weth9) 
240     {
241         weth9 = WETH9(_weth9);
242     }
243 
244     function setAccountHandler
245     (
246         address _accountHandler,
247         bool _isAccountHandler
248     )
249         public
250         auth
251         note
252         addressValid(_accountHandler)
253     {
254         isAccountHandler[_accountHandler] = _isAccountHandler;
255     }
256 
257     function toggleAdminsControl() 
258         public
259         auth
260         note
261     {
262         disableAdminControl = !disableAdminControl;
263     }
264 
265     function isAdminValid(address _admin)
266         public
267         view
268         returns (bool)
269     {
270         if(disableAdminControl) {
271             return true;
272         } else {
273             return isAdmin[_admin];
274         }
275     }
276 
277     function getAllAdmins()
278         public
279         view
280         returns(address[])
281     {
282         return admins;
283     }
284 
285     function addAdmin
286     (
287         address _admin
288     )
289         external
290         note
291         onlyAdmin
292         addressValid(_admin)
293     {   
294         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
295 
296         admins.push(_admin);
297         isAdmin[_admin] = true;
298 
299         emit LogAdminAdded(_admin, msg.sender);
300     }
301 
302     function removeAdmin
303     (
304         address _admin
305     ) 
306         external
307         note
308         onlyAdmin
309         addressValid(_admin)
310     {   
311         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
312         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
313 
314         isAdmin[_admin] = false;
315 
316         for (uint i = 0; i < admins.length - 1; i++) {
317             if (admins[i] == _admin) {
318                 admins[i] = admins[admins.length - 1];
319                 admins.length -= 1;
320                 break;
321             }
322         }
323 
324         emit LogAdminRemoved(_admin, msg.sender);
325     }
326 }
327 
328 
329 
330 library ECRecovery {
331 
332     function recover(bytes32 _hash, bytes _sig)
333         internal
334         pure
335     returns (address)
336     {
337         bytes32 r;
338         bytes32 s;
339         uint8 v;
340 
341         if (_sig.length != 65) {
342             return (address(0));
343         }
344 
345         assembly {
346             r := mload(add(_sig, 32))
347             s := mload(add(_sig, 64))
348             v := byte(0, mload(add(_sig, 96)))
349         }
350 
351         if (v < 27) {
352             v += 27;
353         }
354 
355         if (v != 27 && v != 28) {
356             return (address(0));
357         } else {
358             return ecrecover(_hash, v, r, s);
359         }
360     }
361 
362     function toEthSignedMessageHash(bytes32 _hash)
363         internal
364         pure
365     returns (bytes32)
366     {
367         return keccak256(
368             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
369         );
370     }
371 }
372 
373 
374 contract Utils2 {
375     using ECRecovery for bytes32;
376     
377     function _recoverSigner(bytes32 _hash, bytes _signature) 
378         internal
379         pure
380         returns(address _signer)
381     {
382         return _hash.toEthSignedMessageHash().recover(_signature);
383     }
384 
385 }
386 
387 
388 
389 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
390 
391     address[] public users;
392     mapping (address => bool) public isUser;
393     mapping (bytes32 => bool) public actionCompleted;
394 
395     WETH9 public weth9;
396     Config public config;
397     bool public isInitialized = false;
398 
399     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
400     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
401     event LogUserAdded(address indexed user, address by);
402     event LogUserRemoved(address indexed user, address by);
403     event LogImplChanged(address indexed newImpl, address indexed oldImpl);
404 
405     modifier initialized() {
406         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
407         _;
408     }
409 
410     modifier notInitialized() {
411         require(!isInitialized, "Account::_ ACCOUNT_ALREADY_INITIALIZED");
412         _;
413     }
414 
415     modifier userExists(address _user) {
416         require(isUser[_user], "Account::_ INVALID_USER");
417         _;
418     }
419 
420     modifier userDoesNotExist(address _user) {
421         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
422         _;
423     }
424 
425     modifier onlyAdmin() {
426         require(config.isAdminValid(msg.sender), "Account::_ INVALID_ADMIN_ACCOUNT");
427         _;
428     }
429 
430     modifier onlyHandler(){
431         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
432         _;
433     }
434 
435     function init(address _user, address _config)
436         public 
437         notInitialized
438     {
439         users.push(_user);
440         isUser[_user] = true;
441         config = Config(_config);
442         weth9 = config.weth9();
443         isInitialized = true;
444     }
445     
446     function getAllUsers() public view returns (address[]) {
447         return users;
448     }
449 
450     function balanceFor(address _token) public view returns (uint _balance){
451         _balance = ERC20(_token).balanceOf(this);
452     }
453     
454     function transferBySystem
455     (   
456         address _token,
457         address _to,
458         uint _value
459     ) 
460         external 
461         onlyHandler
462         note 
463         initialized
464     {
465         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
466         ERC20(_token).transfer(_to, _value);
467 
468         emit LogTransferBySystem(_token, _to, _value, msg.sender);
469     }
470     
471     function transferByUser
472     (   
473         address _token,
474         address _to,
475         uint _value,
476         uint _salt,
477         bytes _signature
478     )
479         external
480         addressValid(_to)
481         note
482         initialized
483         onlyAdmin
484     {
485         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
486 
487         if(actionCompleted[actionHash]) {
488             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
489             return;
490         }
491 
492         if(ERC20(_token).balanceOf(this) < _value){
493             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
494             return;
495         }
496 
497         address signer = _recoverSigner(actionHash, _signature);
498 
499         if(!isUser[signer]) {
500             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
501             return;
502         }
503 
504         actionCompleted[actionHash] = true;
505         
506         if (_token == address(weth9)) {
507             weth9.withdraw(_value);
508             _to.transfer(_value);
509         } else {
510             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
511         }
512 
513         emit LogTransferByUser(_token, _to, _value, signer);
514     }
515 
516     function addUser
517     (
518         address _user,
519         uint _salt,
520         bytes _signature
521     )
522         external 
523         note 
524         addressValid(_user)
525         userDoesNotExist(_user)
526         initialized
527         onlyAdmin
528     {   
529         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
530         if(actionCompleted[actionHash])
531         {
532             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
533             return;
534         }
535 
536         address signer = _recoverSigner(actionHash, _signature);
537 
538         if(!isUser[signer]) {
539             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
540             return;
541         }
542 
543         actionCompleted[actionHash] = true;
544 
545         users.push(_user);
546         isUser[_user] = true;
547 
548         emit LogUserAdded(_user, signer);
549     }
550 
551     function removeUser
552     (
553         address _user,
554         uint _salt,
555         bytes _signature
556     ) 
557         external
558         note
559         userExists(_user) 
560         initialized
561         onlyAdmin
562     {   
563         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
564 
565         if(actionCompleted[actionHash]) {
566             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
567             return;
568         }
569 
570         address signer = _recoverSigner(actionHash, _signature);
571         
572         if(users.length == 1){
573             emit LogError("Account::removeUser",  "ACC_SHOULD_HAVE_ATLEAST_ONE_USER");
574             return;
575         }
576         
577         if(!isUser[signer]){
578             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
579             return;
580         }
581         
582         actionCompleted[actionHash] = true;
583 
584         // should delete value from isUser map? delete isUser[_user]?
585         isUser[_user] = false;
586         for (uint i = 0; i < users.length - 1; i++) {
587             if (users[i] == _user) {
588                 users[i] = users[users.length - 1];
589                 users.length -= 1;
590                 break;
591             }
592         }
593 
594         emit LogUserRemoved(_user, signer);
595     }
596 
597     function _getTransferActionHash
598     ( 
599         address _token,
600         address _to,
601         uint _value,
602         uint _salt
603     ) 
604         internal
605         view
606         returns (bytes32)
607     {
608         return keccak256(
609             abi.encodePacked(
610                 address(this),
611                 _token,
612                 _to,
613                 _value,
614                 _salt
615             )
616         );
617     }
618 
619     function _getUserActionHash
620     ( 
621         address _user,
622         string _action,
623         uint _salt
624     ) 
625         internal
626         view
627         returns (bytes32)
628     {
629         return keccak256(
630             abi.encodePacked(
631                 address(this),
632                 _user,
633                 _action,
634                 _salt
635             )
636         );
637     }
638 
639     // to directly send ether to contract
640     function() external payable {
641         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
642 
643         if(msg.sender != address(weth9)){
644             weth9.deposit.value(msg.value)();
645         }
646     }
647 
648     function changeImpl
649     (
650         address _to,
651         uint _salt,
652         bytes _signature
653     )
654         external 
655         note 
656         addressValid(_to)
657         initialized
658         onlyAdmin
659     {   
660         bytes32 actionHash = _getUserActionHash(_to, "CHANGE_ACCOUNT_IMPLEMENTATION", _salt);
661         if(actionCompleted[actionHash])
662         {
663             emit LogError("Account::changeImpl", "ACTION_ALREADY_PERFORMED");
664             return;
665         }
666 
667         address signer = _recoverSigner(actionHash, _signature);
668 
669         if(!isUser[signer]) {
670             emit LogError("Account::changeImpl", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
671             return;
672         }
673 
674         actionCompleted[actionHash] = true;
675 
676         address oldImpl = masterCopy;
677         this.changeMasterCopy(_to);
678         
679         emit LogImplChanged(_to, oldImpl);
680     }
681 
682 }