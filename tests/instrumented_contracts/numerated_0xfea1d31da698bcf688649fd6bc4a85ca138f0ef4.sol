1 contract DSNote {
2     event LogNote(
3         bytes4   indexed  sig,
4         address  indexed  guy,
5         bytes32  indexed  foo,
6         bytes32  indexed  bar,
7         uint256           wad,
8         bytes             fax
9     ) anonymous;
10 
11     modifier note {
12         bytes32 foo;
13         bytes32 bar;
14         uint256 wad;
15 
16         assembly {
17             foo := calldataload(4)
18             bar := calldataload(36)
19             wad := callvalue
20         }
21 
22         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
23 
24         _;
25     }
26 }
27 
28 contract DSAuthority {
29     function canCall(
30         address src, address dst, bytes4 sig
31     ) public view returns (bool);
32 }
33 
34 contract DSAuthEvents {
35     event LogSetAuthority (address indexed authority);
36     event LogSetOwner     (address indexed owner);
37 }
38 
39 contract DSAuth is DSAuthEvents {
40     DSAuthority  public  authority;
41     address      public  owner;
42 
43     constructor() public {
44         owner = msg.sender;
45         emit LogSetOwner(msg.sender);
46     }
47 
48     function setOwner(address owner_)
49         public
50         auth
51     {
52         owner = owner_;
53         emit LogSetOwner(owner);
54     }
55 
56     function setAuthority(DSAuthority authority_)
57         public
58         auth
59     {
60         authority = authority_;
61         emit LogSetAuthority(address(authority));
62     }
63 
64     modifier auth {
65         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
66         _;
67     }
68 
69     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
70         if (src == address(this)) {
71             return true;
72         } else if (src == owner) {
73             return true;
74         } else if (authority == DSAuthority(0)) {
75             return false;
76         } else {
77             return authority.canCall(src, address(this), sig);
78         }
79     }
80 }
81 
82 contract DSMath {
83     function add(uint x, uint y) internal pure returns (uint z) {
84         require((z = x + y) >= x, "ds-math-add-overflow");
85     }
86     function sub(uint x, uint y) internal pure returns (uint z) {
87         require((z = x - y) <= x, "ds-math-sub-underflow");
88     }
89     function mul(uint x, uint y) internal pure returns (uint z) {
90         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
91     }
92 
93     function min(uint x, uint y) internal pure returns (uint z) {
94         return x <= y ? x : y;
95     }
96     function max(uint x, uint y) internal pure returns (uint z) {
97         return x >= y ? x : y;
98     }
99     function imin(int x, int y) internal pure returns (int z) {
100         return x <= y ? x : y;
101     }
102     function imax(int x, int y) internal pure returns (int z) {
103         return x >= y ? x : y;
104     }
105 
106     uint constant WAD = 10 ** 18;
107     uint constant RAY = 10 ** 27;
108 
109     function wmul(uint x, uint y) internal pure returns (uint z) {
110         z = add(mul(x, y), WAD / 2) / WAD;
111     }
112     function rmul(uint x, uint y) internal pure returns (uint z) {
113         z = add(mul(x, y), RAY / 2) / RAY;
114     }
115     function wdiv(uint x, uint y) internal pure returns (uint z) {
116         z = add(mul(x, WAD), y / 2) / y;
117     }
118     function rdiv(uint x, uint y) internal pure returns (uint z) {
119         z = add(mul(x, RAY), y / 2) / y;
120     }
121 
122     // This famous algorithm is called "exponentiation by squaring"
123     // and calculates x^n with x as fixed-point and n as regular unsigned.
124     //
125     // It's O(log n), instead of O(n) for naive repeated multiplication.
126     //
127     // These facts are why it works:
128     //
129     //  If n is even, then x^n = (x^2)^(n/2).
130     //  If n is odd,  then x^n = x * x^(n-1),
131     //   and applying the equation for even x gives
132     //    x^n = x * (x^2)^((n-1) / 2).
133     //
134     //  Also, EVM division is flooring and
135     //    floor[(n-1) / 2] = floor[n / 2].
136     //
137     function rpow(uint x, uint n) internal pure returns (uint z) {
138         z = n % 2 != 0 ? x : RAY;
139 
140         for (n /= 2; n != 0; n /= 2) {
141             x = rmul(x, x);
142 
143             if (n % 2 != 0) {
144                 z = rmul(z, x);
145             }
146         }
147     }
148 }
149 
150 contract DSStop is DSNote, DSAuth {
151     bool public stopped;
152 
153     modifier stoppable {
154         require(!stopped, "ds-stop-is-stopped");
155         _;
156     }
157     function stop() public auth note {
158         stopped = true;
159     }
160     function start() public auth note {
161         stopped = false;
162     }
163 
164 }
165 
166 contract DSThing is DSAuth, DSNote, DSMath {
167     function S(string memory s) internal pure returns (bytes4) {
168         return bytes4(keccak256(abi.encodePacked(s)));
169     }
170 
171 }
172 
173 contract ERC20Events {
174     event Approval(address indexed src, address indexed guy, uint wad);
175     event Transfer(address indexed src, address indexed dst, uint wad);
176 }
177 
178 contract ERC20 is ERC20Events {
179     function totalSupply() public view returns (uint);
180     function balanceOf(address guy) public view returns (uint);
181     function allowance(address src, address guy) public view returns (uint);
182 
183     function approve(address guy, uint wad) public returns (bool);
184     function transfer(address dst, uint wad) public returns (bool);
185     function transferFrom(
186         address src, address dst, uint wad
187     ) public returns (bool);
188 }
189 
190 
191 contract DSTokenBase is ERC20, DSMath {
192     uint256                                            _supply;
193     mapping (address => uint256)                       _balances;
194     mapping (address => mapping (address => uint256))  _approvals;
195 
196     constructor(uint supply) public {
197         _balances[msg.sender] = supply;
198         _supply = supply;
199     }
200 
201     function totalSupply() public view returns (uint) {
202         return _supply;
203     }
204     function balanceOf(address src) public view returns (uint) {
205         return _balances[src];
206     }
207     function allowance(address src, address guy) public view returns (uint) {
208         return _approvals[src][guy];
209     }
210 
211     function transfer(address dst, uint wad) public returns (bool) {
212         return transferFrom(msg.sender, dst, wad);
213     }
214 
215     function transferFrom(address src, address dst, uint wad)
216         public
217         returns (bool)
218     {
219         if (src != msg.sender) {
220             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
221             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
222         }
223 
224         require(_balances[src] >= wad, "ds-token-insufficient-balance");
225         _balances[src] = sub(_balances[src], wad);
226         _balances[dst] = add(_balances[dst], wad);
227 
228         emit Transfer(src, dst, wad);
229 
230         return true;
231     }
232 
233     function approve(address guy, uint wad) public returns (bool) {
234         _approvals[msg.sender][guy] = wad;
235 
236         emit Approval(msg.sender, guy, wad);
237 
238         return true;
239     }
240 }
241 
242 contract DSToken is DSTokenBase(0), DSStop {
243 
244     bytes32  public  symbol;
245     uint256  public  decimals = 18; // standard token precision. override to customize
246 
247     constructor(bytes32 symbol_) public {
248         symbol = symbol_;
249     }
250 
251     event Mint(address indexed guy, uint wad);
252     event Burn(address indexed guy, uint wad);
253 
254     function approve(address guy) public stoppable returns (bool) {
255         return super.approve(guy, uint(-1));
256     }
257 
258     function approve(address guy, uint wad) public stoppable returns (bool) {
259         return super.approve(guy, wad);
260     }
261 
262     function transferFrom(address src, address dst, uint wad)
263         public
264         stoppable
265         returns (bool)
266     {
267         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
268             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
269             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
270         }
271 
272         require(_balances[src] >= wad, "ds-token-insufficient-balance");
273         _balances[src] = sub(_balances[src], wad);
274         _balances[dst] = add(_balances[dst], wad);
275 
276         emit Transfer(src, dst, wad);
277 
278         return true;
279     }
280 
281     function push(address dst, uint wad) public {
282         transferFrom(msg.sender, dst, wad);
283     }
284     function pull(address src, uint wad) public {
285         transferFrom(src, msg.sender, wad);
286     }
287     function move(address src, address dst, uint wad) public {
288         transferFrom(src, dst, wad);
289     }
290 
291     function mint(uint wad) public {
292         mint(msg.sender, wad);
293     }
294     function burn(uint wad) public {
295         burn(msg.sender, wad);
296     }
297     function mint(address guy, uint wad) public auth stoppable {
298         _balances[guy] = add(_balances[guy], wad);
299         _supply = add(_supply, wad);
300         emit Mint(guy, wad);
301     }
302     function burn(address guy, uint wad) public auth stoppable {
303         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
304             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
305             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
306         }
307 
308         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
309         _balances[guy] = sub(_balances[guy], wad);
310         _supply = sub(_supply, wad);
311         emit Burn(guy, wad);
312     }
313 
314     // Optional token name
315     bytes32   public  name = "";
316 
317     function setName(bytes32 name_) public auth {
318         name = name_;
319     }
320 }
321 
322 
323 
324 contract DSRoles is DSAuth, DSAuthority
325 {
326     mapping(address=>bool) _root_users;
327     mapping(address=>bytes32) _user_roles;
328     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
329     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
330 
331     function getUserRoles(address who)
332         public
333         view
334         returns (bytes32)
335     {
336         return _user_roles[who];
337     }
338 
339     function getCapabilityRoles(address code, bytes4 sig)
340         public
341         view
342         returns (bytes32)
343     {
344         return _capability_roles[code][sig];
345     }
346 
347     function isUserRoot(address who)
348         public
349         view
350         returns (bool)
351     {
352         return _root_users[who];
353     }
354 
355     function isCapabilityPublic(address code, bytes4 sig)
356         public
357         view
358         returns (bool)
359     {
360         return _public_capabilities[code][sig];
361     }
362 
363     function hasUserRole(address who, uint8 role)
364         public
365         view
366         returns (bool)
367     {
368         bytes32 roles = getUserRoles(who);
369         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
370         return bytes32(0) != roles & shifted;
371     }
372 
373     function canCall(address caller, address code, bytes4 sig)
374         public
375         view
376         returns (bool)
377     {
378         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
379             return true;
380         } else {
381             bytes32 has_roles = getUserRoles(caller);
382             bytes32 needs_one_of = getCapabilityRoles(code, sig);
383             return bytes32(0) != has_roles & needs_one_of;
384         }
385     }
386 
387     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
388         return (input ^ bytes32(uint(-1)));
389     }
390 
391     function setRootUser(address who, bool enabled)
392         public
393         auth
394     {
395         _root_users[who] = enabled;
396     }
397 
398     function setUserRole(address who, uint8 role, bool enabled)
399         public
400         auth
401     {
402         bytes32 last_roles = _user_roles[who];
403         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
404         if( enabled ) {
405             _user_roles[who] = last_roles | shifted;
406         } else {
407             _user_roles[who] = last_roles & BITNOT(shifted);
408         }
409     }
410 
411     function setPublicCapability(address code, bytes4 sig, bool enabled)
412         public
413         auth
414     {
415         _public_capabilities[code][sig] = enabled;
416     }
417 
418     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
419         public
420         auth
421     {
422         bytes32 last_roles = _capability_roles[code][sig];
423         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
424         if( enabled ) {
425             _capability_roles[code][sig] = last_roles | shifted;
426         } else {
427             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
428         }
429 
430     }
431 
432 }
433 
434 
435 contract DSChiefApprovals is DSThing {
436     mapping(bytes32=>address[]) public slates;
437     mapping(address=>bytes32) public votes;
438     mapping(address=>uint256) public approvals;
439     mapping(address=>uint256) public deposits;
440     DSToken public GOV; // voting token that gets locked up
441     DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms
442     address public hat; // the chieftain's hat
443 
444     uint256 public MAX_YAYS;
445 
446     event Etch(bytes32 indexed slate);
447 
448     // IOU constructed outside this contract reduces deployment costs significantly
449     // lock/free/vote are quite sensitive to token invariants. Caution is advised.
450     constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public
451     {
452         GOV = GOV_;
453         IOU = IOU_;
454         MAX_YAYS = MAX_YAYS_;
455     }
456 
457     function lock(uint wad)
458         public
459         note
460     {
461         GOV.pull(msg.sender, wad);
462         IOU.mint(msg.sender, wad);
463         deposits[msg.sender] = add(deposits[msg.sender], wad);
464         addWeight(wad, votes[msg.sender]);
465     }
466 
467     function free(uint wad)
468         public
469         note
470     {
471         deposits[msg.sender] = sub(deposits[msg.sender], wad);
472         subWeight(wad, votes[msg.sender]);
473         IOU.burn(msg.sender, wad);
474         GOV.push(msg.sender, wad);
475     }
476 
477     function etch(address[] memory yays)
478         public
479         note
480         returns (bytes32 slate)
481     {
482         require( yays.length <= MAX_YAYS );
483         requireByteOrderedSet(yays);
484 
485         bytes32 hash = keccak256(abi.encodePacked(yays));
486         slates[hash] = yays;
487         emit Etch(hash);
488         return hash;
489     }
490 
491     function vote(address[] memory yays) public returns (bytes32)
492         // note  both sub-calls note
493     {
494         bytes32 slate = etch(yays);
495         vote(slate);
496         return slate;
497     }
498 
499     function vote(bytes32 slate)
500         public
501         note
502     {
503         require(slates[slate].length > 0 || 
504             slate == 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470, "ds-chief-invalid-slate");
505         uint weight = deposits[msg.sender];
506         subWeight(weight, votes[msg.sender]);
507         votes[msg.sender] = slate;
508         addWeight(weight, votes[msg.sender]);
509     }
510 
511     // like `drop`/`swap` except simply "elect this address if it is higher than current hat"
512     function lift(address whom)
513         public
514         note
515     {
516         require(approvals[whom] > approvals[hat]);
517         hat = whom;
518     }
519 
520     function addWeight(uint weight, bytes32 slate)
521         internal
522     {
523         address[] storage yays = slates[slate];
524         for( uint i = 0; i < yays.length; i++) {
525             approvals[yays[i]] = add(approvals[yays[i]], weight);
526         }
527     }
528 
529     function subWeight(uint weight, bytes32 slate)
530         internal
531     {
532         address[] storage yays = slates[slate];
533         for( uint i = 0; i < yays.length; i++) {
534             approvals[yays[i]] = sub(approvals[yays[i]], weight);
535         }
536     }
537 
538     // Throws unless the array of addresses is a ordered set.
539     function requireByteOrderedSet(address[] memory yays)
540         internal
541         pure
542     {
543         if( yays.length == 0 || yays.length == 1 ) {
544             return;
545         }
546         for( uint i = 0; i < yays.length - 1; i++ ) {
547             // strict inequality ensures both ordering and uniqueness
548             require(uint(yays[i]) < uint(yays[i+1]));
549         }
550     }
551 }
552 
553 
554 // `hat` address is unique root user (has every role) and the
555 // unique owner of role 0 (typically 'sys' or 'internal')
556 contract DSChief is DSRoles, DSChiefApprovals {
557 
558     constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)
559              DSChiefApprovals (GOV, IOU, MAX_YAYS)
560         public
561     {
562         authority = this;
563         owner = address(0);
564     }
565 
566     function setOwner(address owner_) public {
567         owner_;
568         revert();
569     }
570 
571     function setAuthority(DSAuthority authority_) public {
572         authority_;
573         revert();
574     }
575 
576     function isUserRoot(address who)
577         public view
578         returns (bool)
579     {
580         return (who == hat);
581     }
582     function setRootUser(address who, bool enabled) public {
583         who; enabled;
584         revert();
585     }
586 }
587 
588 contract DSChiefFab {
589     function newChief(DSToken gov, uint MAX_YAYS) public returns (DSChief chief) {
590         DSToken iou = new DSToken('IOU');
591         chief = new DSChief(gov, iou, MAX_YAYS);
592         iou.setOwner(address(chief));
593     }
594 }
595 
596 
597 contract VoteProxy {
598     address public cold;
599     address public hot;
600     DSToken public gov;
601     DSToken public iou;
602     DSChief public chief;
603 
604     constructor(DSChief _chief, address _cold, address _hot) public {
605         chief = _chief;
606         cold = _cold;
607         hot = _hot;
608 
609         gov = chief.GOV();
610         iou = chief.IOU();
611         gov.approve(address(chief), uint256(-1));
612         iou.approve(address(chief), uint256(-1));
613     }
614 
615     modifier auth() {
616         require(msg.sender == hot || msg.sender == cold, "Sender must be a Cold or Hot Wallet");
617         _;
618     }
619 
620     function lock(uint256 wad) public auth {
621         gov.pull(cold, wad);   // mkr from cold
622         chief.lock(wad);       // mkr out, ious in
623     }
624 
625     function free(uint256 wad) public auth {
626         chief.free(wad);       // ious out, mkr in
627         gov.push(cold, wad);   // mkr to cold
628     }
629 
630     function freeAll() public auth {
631         chief.free(chief.deposits(address(this)));
632         gov.push(cold, gov.balanceOf(address(this)));
633     }
634 
635     function vote(address[] memory yays) public auth returns (bytes32) {
636         return chief.vote(yays);
637     }
638 
639     function vote(bytes32 slate) public auth {
640         chief.vote(slate);
641     }
642 }