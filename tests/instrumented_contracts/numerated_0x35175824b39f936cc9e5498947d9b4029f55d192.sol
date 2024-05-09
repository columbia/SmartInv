1 pragma solidity 0.4.24;
2 
3 
4 contract WETH9 {
5     string public name     = "Wrapped Ether";
6     string public symbol   = "WETH";
7     uint8  public decimals = 18;
8 
9     event  Approval(address indexed _owner, address indexed _spender, uint _value);
10     event  Transfer(address indexed _from, address indexed _to, uint _value);
11     event  Deposit(address indexed _owner, uint _value);
12     event  Withdrawal(address indexed _owner, uint _value);
13 
14     mapping (address => uint)                       public  balanceOf;
15     mapping (address => mapping (address => uint))  public  allowance;
16 
17     function() public payable {
18         deposit();
19     }
20 
21     function deposit() public payable {
22         balanceOf[msg.sender] += msg.value;
23         Deposit(msg.sender, msg.value);
24     }
25 
26     function withdraw(uint wad) public {
27         require(balanceOf[msg.sender] >= wad);
28         balanceOf[msg.sender] -= wad;
29         msg.sender.transfer(wad);
30         Withdrawal(msg.sender, wad);
31     }
32 
33     function totalSupply() public view returns (uint) {
34         return this.balance;
35     }
36 
37     function approve(address guy, uint wad) public returns (bool) {
38         allowance[msg.sender][guy] = wad;
39         Approval(msg.sender, guy, wad);
40         return true;
41     }
42 
43     function transfer(address dst, uint wad) public returns (bool) {
44         return transferFrom(msg.sender, dst, wad);
45     }
46 
47     function transferFrom(address src, address dst, uint wad)
48         public
49         returns (bool)
50     {
51         require(balanceOf[src] >= wad);
52 
53         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
54             require(allowance[src][msg.sender] >= wad);
55             allowance[src][msg.sender] -= wad;
56         }
57 
58         balanceOf[src] -= wad;
59         balanceOf[dst] += wad;
60 
61         Transfer(src, dst, wad);
62 
63         return true;
64     }
65 }
66 
67 
68 contract Utils {
69 
70     modifier addressValid(address _address) {
71         require(_address != address(0), "Utils::_ INVALID_ADDRESS");
72         _;
73     }
74 
75 }
76 
77 
78 contract DSAuthority {
79     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
80 }
81 
82 
83 contract DSAuthEvents {
84     event LogSetAuthority (address indexed authority);
85     event LogSetOwner     (address indexed owner);
86 }
87 
88 
89 contract DSAuth is DSAuthEvents {
90     DSAuthority  public  authority;
91     address      public  owner;
92 
93     constructor() public {
94         owner = msg.sender;
95         emit LogSetOwner(msg.sender);
96     }
97 
98     function setOwner(address owner_)
99         public
100         auth
101     {
102         owner = owner_;
103         emit LogSetOwner(owner);
104     }
105 
106     function setAuthority(DSAuthority authority_)
107         public
108         auth
109     {
110         authority = authority_;
111         emit LogSetAuthority(authority);
112     }
113 
114     modifier auth {
115         require(isAuthorized(msg.sender, msg.sig), "DSAuth::_ SENDER_NOT_AUTHORIZED");
116         _;
117     }
118 
119     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
120         if (src == address(this)) {
121             return true;
122         } else if (src == owner) {
123             return true;
124         } else if (authority == DSAuthority(0)) {
125             return false;
126         } else {
127             return authority.canCall(src, this, sig);
128         }
129     }
130 }
131 
132 
133 contract DSNote {
134     event LogNote(
135         bytes4   indexed  sig,
136         address  indexed  guy,
137         bytes32  indexed  foo,
138         bytes32  indexed  bar,
139         uint              wad,
140         bytes             fax
141     ) anonymous;
142 
143     modifier note {
144         bytes32 foo;
145         bytes32 bar;
146 
147         assembly {
148             foo := calldataload(4)
149             bar := calldataload(36)
150         }
151 
152         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
153 
154         _;
155     }
156 }
157 
158 
159 interface ERC20 {
160 
161     function name() public view returns(string);
162     function symbol() public view returns(string);
163     function decimals() public view returns(uint8);
164     function totalSupply() public view returns (uint);
165 
166     function balanceOf(address tokenOwner) public view returns (uint balance);
167     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
168     function transfer(address to, uint tokens) public returns (bool success);
169     function approve(address spender, uint tokens) public returns (bool success);
170     function transferFrom(address from, address to, uint tokens) public returns (bool success);
171 
172     event Transfer(address indexed from, address indexed to, uint tokens);
173     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
174 }
175 
176 
177 contract MasterCopy {
178 
179     address masterCopy;
180 
181     function changeMasterCopy(address _masterCopy)
182         public
183     {
184         require(_masterCopy != 0, "Invalid master copy address provided");
185         masterCopy = _masterCopy;
186     }
187 }
188 
189 
190 contract ErrorUtils {
191 
192     event LogError(string methodSig, string errMsg);
193     event LogErrorWithHintBytes32(bytes32 indexed bytes32Value, string methodSig, string errMsg);
194     event LogErrorWithHintAddress(address indexed addressValue, string methodSig, string errMsg);
195 
196 }
197 
198 
199 contract Config is DSNote, DSAuth, Utils {
200 
201     WETH9 public weth9;
202     mapping (address => bool) public isAccountHandler;
203     mapping (address => bool) public isAdmin;
204     address[] public admins;
205     bool public disableAdminControl = false;
206     
207     event LogAdminAdded(address indexed _admin, address _by);
208     event LogAdminRemoved(address indexed _admin, address _by);
209 
210     constructor() public {
211         admins.push(msg.sender);
212         isAdmin[msg.sender] = true;
213     }
214 
215     modifier onlyAdmin(){
216         require(isAdmin[msg.sender], "Config::_ SENDER_NOT_AUTHORIZED");
217         _;
218     }
219 
220     function setWETH9
221     (
222         address _weth9
223     ) 
224         public
225         auth
226         note
227         addressValid(_weth9) 
228     {
229         weth9 = WETH9(_weth9);
230     }
231 
232     function setAccountHandler
233     (
234         address _accountHandler,
235         bool _isAccountHandler
236     )
237         public
238         auth
239         note
240         addressValid(_accountHandler)
241     {
242         isAccountHandler[_accountHandler] = _isAccountHandler;
243     }
244 
245     function toggleAdminsControl() 
246         public
247         auth
248         note
249     {
250         disableAdminControl = !disableAdminControl;
251     }
252 
253     function isAdminValid(address _admin)
254         public
255         view
256         returns (bool)
257     {
258         if(disableAdminControl) {
259             return true;
260         } else {
261             return isAdmin[_admin];
262         }
263     }
264 
265     function getAllAdmins()
266         public
267         view
268         returns(address[])
269     {
270         return admins;
271     }
272 
273     function addAdmin
274     (
275         address _admin
276     )
277         external
278         note
279         onlyAdmin
280         addressValid(_admin)
281     {   
282         require(!isAdmin[_admin], "Config::addAdmin ADMIN_ALREADY_EXISTS");
283 
284         admins.push(_admin);
285         isAdmin[_admin] = true;
286 
287         emit LogAdminAdded(_admin, msg.sender);
288     }
289 
290     function removeAdmin
291     (
292         address _admin
293     ) 
294         external
295         note
296         onlyAdmin
297         addressValid(_admin)
298     {   
299         require(isAdmin[_admin], "Config::removeAdmin ADMIN_DOES_NOT_EXIST");
300         require(msg.sender != _admin, "Config::removeAdmin ADMIN_NOT_AUTHORIZED");
301 
302         isAdmin[_admin] = false;
303 
304         for (uint i = 0; i < admins.length - 1; i++) {
305             if (admins[i] == _admin) {
306                 admins[i] = admins[admins.length - 1];
307                 admins.length -= 1;
308                 break;
309             }
310         }
311 
312         emit LogAdminRemoved(_admin, msg.sender);
313     }
314 }
315 
316 
317 library ECRecovery {
318 
319     function recover(bytes32 _hash, bytes _sig)
320         internal
321         pure
322     returns (address)
323     {
324         bytes32 r;
325         bytes32 s;
326         uint8 v;
327 
328         if (_sig.length != 65) {
329             return (address(0));
330         }
331 
332         assembly {
333             r := mload(add(_sig, 32))
334             s := mload(add(_sig, 64))
335             v := byte(0, mload(add(_sig, 96)))
336         }
337 
338         if (v < 27) {
339             v += 27;
340         }
341 
342         if (v != 27 && v != 28) {
343             return (address(0));
344         } else {
345             return ecrecover(_hash, v, r, s);
346         }
347     }
348 
349     function toEthSignedMessageHash(bytes32 _hash)
350         internal
351         pure
352     returns (bytes32)
353     {
354         return keccak256(
355             abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
356         );
357     }
358 }
359 
360 
361 contract Utils2 {
362     using ECRecovery for bytes32;
363     
364     function _recoverSigner(bytes32 _hash, bytes _signature) 
365         internal
366         pure
367         returns(address _signer)
368     {
369         return _hash.toEthSignedMessageHash().recover(_signature);
370     }
371 
372 }
373 
374 
375 contract Account is MasterCopy, DSNote, Utils, Utils2, ErrorUtils {
376 
377     address[] public users;
378     mapping (address => bool) public isUser;
379     mapping (bytes32 => bool) public actionCompleted;
380 
381     WETH9 public weth9;
382     Config public config;
383     bool public isInitialized = false;
384 
385     event LogTransferBySystem(address indexed token, address indexed to, uint value, address by);
386     event LogTransferByUser(address indexed token, address indexed to, uint value, address by);
387     event LogUserAdded(address indexed user, address by);
388     event LogUserRemoved(address indexed user, address by);
389 
390     modifier initialized() {
391         require(isInitialized, "Account::_ ACCOUNT_NOT_INITIALIZED");
392         _;
393     }
394 
395     modifier userExists(address _user) {
396         require(isUser[_user], "Account::_ INVALID_USER");
397         _;
398     }
399 
400     modifier userDoesNotExist(address _user) {
401         require(!isUser[_user], "Account::_ USER_DOES_NOT_EXISTS");
402         _;
403     }
404 
405     modifier onlyHandler(){
406         require(config.isAccountHandler(msg.sender), "Account::_ INVALID_ACC_HANDLER");
407         _;
408     }
409 
410     function init(address _user, address _config) public {
411         users.push(_user);
412         isUser[_user] = true;
413         config = Config(_config);
414         weth9 = config.weth9();
415         isInitialized = true;
416     }
417     
418     function getAllUsers() public view returns (address[]) {
419         return users;
420     }
421 
422     function balanceFor(address _token) public view returns (uint _balance){
423         _balance = ERC20(_token).balanceOf(this);
424     }
425     
426     function transferBySystem
427     (   
428         address _token,
429         address _to,
430         uint _value
431     ) 
432         external 
433         onlyHandler
434         note 
435         initialized
436     {
437         require(ERC20(_token).balanceOf(this) >= _value, "Account::transferBySystem INSUFFICIENT_BALANCE_IN_ACCOUNT");
438         require(ERC20(_token).transfer(_to, _value), "Account::transferBySystem TOKEN_TRANSFER_FAILED");
439 
440         emit LogTransferBySystem(_token, _to, _value, msg.sender);
441     }
442     
443     function transferByUser
444     (   
445         address _token,
446         address _to,
447         uint _value,
448         uint _salt,
449         bytes _signature
450     ) 
451         external
452         addressValid(_to)
453         note
454         initialized
455     {
456         bytes32 actionHash = _getTransferActionHash(_token, _to, _value, _salt);
457 
458         if(actionCompleted[actionHash]) {
459             emit LogError("Account::transferByUser", "ACTION_ALREADY_PERFORMED");
460             return;
461         }
462 
463         if(ERC20(_token).balanceOf(this) < _value){
464             emit LogError("Account::transferByUser", "INSUFFICIENT_BALANCE_IN_ACCOUNT");
465             return;
466         }
467 
468         address signer = _recoverSigner(actionHash, _signature);
469 
470         if(!isUser[signer]) {
471             emit LogError("Account::transferByUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
472             return;
473         }
474 
475         actionCompleted[actionHash] = true;
476         
477         if (_token == address(weth9)) {
478             weth9.withdraw(_value);
479             _to.transfer(_value);
480         } else {
481             require(ERC20(_token).transfer(_to, _value), "Account::transferByUser TOKEN_TRANSFER_FAILED");
482         }
483 
484         emit LogTransferByUser(_token, _to, _value, signer);
485     }
486 
487     function addUser
488     (
489         address _user,
490         uint _salt,
491         bytes _signature
492     )
493         external 
494         note 
495         addressValid(_user)
496         userDoesNotExist(_user)
497         initialized
498     {   
499         bytes32 actionHash = _getUserActionHash(_user, "ADD_USER", _salt);
500         if(actionCompleted[actionHash])
501         {
502             emit LogError("Account::addUser", "ACTION_ALREADY_PERFORMED");
503             return;
504         }
505 
506         address signer = _recoverSigner(actionHash, _signature);
507 
508         if(!isUser[signer]) {
509             emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
510             return;
511         }
512 
513         actionCompleted[actionHash] = true;
514 
515         users.push(_user);
516         isUser[_user] = true;
517 
518         emit LogUserAdded(_user, signer);
519     }
520 
521     function removeUser
522     (
523         address _user,
524         uint _salt,
525         bytes _signature
526     ) 
527         external
528         note
529         userExists(_user) 
530         initialized
531     {   
532         bytes32 actionHash = _getUserActionHash(_user, "REMOVE_USER", _salt);
533 
534         if(actionCompleted[actionHash]) {
535             emit LogError("Account::removeUser", "ACTION_ALREADY_PERFORMED");
536             return;
537         }
538 
539         address signer = _recoverSigner(actionHash, _signature);
540         
541         // require(signer != _user, "Account::removeUser SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
542         if(!isUser[signer]){
543             emit LogError("Account::removeUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
544             return;
545         }
546         
547         actionCompleted[actionHash] = true;
548 
549         isUser[_user] = false;
550         for (uint i = 0; i < users.length - 1; i++) {
551             if (users[i] == _user) {
552                 users[i] = users[users.length - 1];
553                 users.length -= 1;
554                 break;
555             }
556         }
557 
558         emit LogUserRemoved(_user, signer);
559     }
560 
561     function _getTransferActionHash
562     ( 
563         address _token,
564         address _to,
565         uint _value,
566         uint _salt
567     ) 
568         internal
569         view
570         returns (bytes32)
571     {
572         return keccak256(
573             abi.encodePacked(
574                 address(this),
575                 _token,
576                 _to,
577                 _value,
578                 _salt
579             )
580         );
581     }
582 
583     function _getUserActionHash
584     ( 
585         address _user,
586         string _action,
587         uint _salt
588     ) 
589         internal
590         view
591         returns (bytes32)
592     {
593         return keccak256(
594             abi.encodePacked(
595                 address(this),
596                 _user,
597                 _action,
598                 _salt
599             )
600         );
601     }
602 
603     // to directly send ether to contract
604     function() external payable {
605         require(msg.data.length == 0 && msg.value > 0, "Account::fallback INVALID_ETHER_TRANSFER");
606 
607         if(msg.sender != address(weth9)){
608             weth9.deposit.value(msg.value)();
609         }
610     }
611     
612 }