1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, May 7, 2019
3  (UTC) */
4 
5 contract DSNote {
6     event LogNote(
7         bytes4   indexed  sig,
8         address  indexed  guy,
9         bytes32  indexed  foo,
10         bytes32  indexed  bar,
11         uint256           wad,
12         bytes             fax
13     ) anonymous;
14 
15     modifier note {
16         bytes32 foo;
17         bytes32 bar;
18         uint256 wad;
19 
20         assembly {
21             foo := calldataload(4)
22             bar := calldataload(36)
23             wad := callvalue
24         }
25 
26         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
27 
28         _;
29     }
30 }
31 
32 contract DSAuthority {
33     function canCall(
34         address src, address dst, bytes4 sig
35     ) public view returns (bool);
36 }
37 
38 contract DSAuthEvents {
39     event LogSetAuthority (address indexed authority);
40     event LogSetOwner     (address indexed owner);
41 }
42 
43 contract DSAuth is DSAuthEvents {
44     DSAuthority  public  authority;
45     address      public  owner;
46 
47     constructor() public {
48         owner = msg.sender;
49         emit LogSetOwner(msg.sender);
50     }
51 
52     function setOwner(address owner_)
53         public
54         auth
55     {
56         owner = owner_;
57         emit LogSetOwner(owner);
58     }
59 
60     function setAuthority(DSAuthority authority_)
61         public
62         auth
63     {
64         authority = authority_;
65         emit LogSetAuthority(address(authority));
66     }
67 
68     modifier auth {
69         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
70         _;
71     }
72 
73     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
74         if (src == address(this)) {
75             return true;
76         } else if (src == owner) {
77             return true;
78         } else if (authority == DSAuthority(0)) {
79             return false;
80         } else {
81             return authority.canCall(src, address(this), sig);
82         }
83     }
84 }
85 
86 contract DSMath {
87     function add(uint x, uint y) internal pure returns (uint z) {
88         require((z = x + y) >= x, "ds-math-add-overflow");
89     }
90     function sub(uint x, uint y) internal pure returns (uint z) {
91         require((z = x - y) <= x, "ds-math-sub-underflow");
92     }
93     function mul(uint x, uint y) internal pure returns (uint z) {
94         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
95     }
96 
97     function min(uint x, uint y) internal pure returns (uint z) {
98         return x <= y ? x : y;
99     }
100     function max(uint x, uint y) internal pure returns (uint z) {
101         return x >= y ? x : y;
102     }
103     function imin(int x, int y) internal pure returns (int z) {
104         return x <= y ? x : y;
105     }
106     function imax(int x, int y) internal pure returns (int z) {
107         return x >= y ? x : y;
108     }
109 
110     uint constant WAD = 10 ** 18;
111     uint constant RAY = 10 ** 27;
112 
113     function wmul(uint x, uint y) internal pure returns (uint z) {
114         z = add(mul(x, y), WAD / 2) / WAD;
115     }
116     function rmul(uint x, uint y) internal pure returns (uint z) {
117         z = add(mul(x, y), RAY / 2) / RAY;
118     }
119     function wdiv(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, WAD), y / 2) / y;
121     }
122     function rdiv(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, RAY), y / 2) / y;
124     }
125 
126     // This famous algorithm is called "exponentiation by squaring"
127     // and calculates x^n with x as fixed-point and n as regular unsigned.
128     //
129     // It's O(log n), instead of O(n) for naive repeated multiplication.
130     //
131     // These facts are why it works:
132     //
133     //  If n is even, then x^n = (x^2)^(n/2).
134     //  If n is odd,  then x^n = x * x^(n-1),
135     //   and applying the equation for even x gives
136     //    x^n = x * (x^2)^((n-1) / 2).
137     //
138     //  Also, EVM division is flooring and
139     //    floor[(n-1) / 2] = floor[n / 2].
140     //
141     function rpow(uint x, uint n) internal pure returns (uint z) {
142         z = n % 2 != 0 ? x : RAY;
143 
144         for (n /= 2; n != 0; n /= 2) {
145             x = rmul(x, x);
146 
147             if (n % 2 != 0) {
148                 z = rmul(z, x);
149             }
150         }
151     }
152 }
153 
154 contract DSStop is DSNote, DSAuth {
155     bool public stopped;
156 
157     modifier stoppable {
158         require(!stopped, "ds-stop-is-stopped");
159         _;
160     }
161     function stop() public auth note {
162         stopped = true;
163     }
164     function start() public auth note {
165         stopped = false;
166     }
167 
168 }
169 
170 contract DSThing is DSAuth, DSNote, DSMath {
171     function S(string memory s) internal pure returns (bytes4) {
172         return bytes4(keccak256(abi.encodePacked(s)));
173     }
174 
175 }
176 
177 contract ERC20Events {
178     event Approval(address indexed src, address indexed guy, uint wad);
179     event Transfer(address indexed src, address indexed dst, uint wad);
180 }
181 
182 contract ERC20 is ERC20Events {
183     function totalSupply() public view returns (uint);
184     function balanceOf(address guy) public view returns (uint);
185     function allowance(address src, address guy) public view returns (uint);
186 
187     function approve(address guy, uint wad) public returns (bool);
188     function transfer(address dst, uint wad) public returns (bool);
189     function transferFrom(
190         address src, address dst, uint wad
191     ) public returns (bool);
192 }
193 
194 
195 contract DSTokenBase is ERC20, DSMath {
196     uint256                                            _supply;
197     mapping (address => uint256)                       _balances;
198     mapping (address => mapping (address => uint256))  _approvals;
199 
200     constructor(uint supply) public {
201         _balances[msg.sender] = supply;
202         _supply = supply;
203     }
204 
205     function totalSupply() public view returns (uint) {
206         return _supply;
207     }
208     function balanceOf(address src) public view returns (uint) {
209         return _balances[src];
210     }
211     function allowance(address src, address guy) public view returns (uint) {
212         return _approvals[src][guy];
213     }
214 
215     function transfer(address dst, uint wad) public returns (bool) {
216         return transferFrom(msg.sender, dst, wad);
217     }
218 
219     function transferFrom(address src, address dst, uint wad)
220         public
221         returns (bool)
222     {
223         if (src != msg.sender) {
224             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
225             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
226         }
227 
228         require(_balances[src] >= wad, "ds-token-insufficient-balance");
229         _balances[src] = sub(_balances[src], wad);
230         _balances[dst] = add(_balances[dst], wad);
231 
232         emit Transfer(src, dst, wad);
233 
234         return true;
235     }
236 
237     function approve(address guy, uint wad) public returns (bool) {
238         _approvals[msg.sender][guy] = wad;
239 
240         emit Approval(msg.sender, guy, wad);
241 
242         return true;
243     }
244 }
245 
246 contract DSToken is DSTokenBase(0), DSStop {
247 
248     bytes32  public  symbol;
249     uint256  public  decimals = 18; // standard token precision. override to customize
250 
251     constructor(bytes32 symbol_) public {
252         symbol = symbol_;
253     }
254 
255     event Mint(address indexed guy, uint wad);
256     event Burn(address indexed guy, uint wad);
257 
258     function approve(address guy) public stoppable returns (bool) {
259         return super.approve(guy, uint(-1));
260     }
261 
262     function approve(address guy, uint wad) public stoppable returns (bool) {
263         return super.approve(guy, wad);
264     }
265 
266     function transferFrom(address src, address dst, uint wad)
267         public
268         stoppable
269         returns (bool)
270     {
271         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
272             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
273             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
274         }
275 
276         require(_balances[src] >= wad, "ds-token-insufficient-balance");
277         _balances[src] = sub(_balances[src], wad);
278         _balances[dst] = add(_balances[dst], wad);
279 
280         emit Transfer(src, dst, wad);
281 
282         return true;
283     }
284 
285     function push(address dst, uint wad) public {
286         transferFrom(msg.sender, dst, wad);
287     }
288     function pull(address src, uint wad) public {
289         transferFrom(src, msg.sender, wad);
290     }
291     function move(address src, address dst, uint wad) public {
292         transferFrom(src, dst, wad);
293     }
294 
295     function mint(uint wad) public {
296         mint(msg.sender, wad);
297     }
298     function burn(uint wad) public {
299         burn(msg.sender, wad);
300     }
301     function mint(address guy, uint wad) public auth stoppable {
302         _balances[guy] = add(_balances[guy], wad);
303         _supply = add(_supply, wad);
304         emit Mint(guy, wad);
305     }
306     function burn(address guy, uint wad) public auth stoppable {
307         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
308             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
309             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
310         }
311 
312         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
313         _balances[guy] = sub(_balances[guy], wad);
314         _supply = sub(_supply, wad);
315         emit Burn(guy, wad);
316     }
317 
318     // Optional token name
319     bytes32   public  name = "";
320 
321     function setName(bytes32 name_) public auth {
322         name = name_;
323     }
324 }
325 
326 
327 
328 contract DSRoles is DSAuth, DSAuthority
329 {
330     mapping(address=>bool) _root_users;
331     mapping(address=>bytes32) _user_roles;
332     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
333     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
334 
335     function getUserRoles(address who)
336         public
337         view
338         returns (bytes32)
339     {
340         return _user_roles[who];
341     }
342 
343     function getCapabilityRoles(address code, bytes4 sig)
344         public
345         view
346         returns (bytes32)
347     {
348         return _capability_roles[code][sig];
349     }
350 
351     function isUserRoot(address who)
352         public
353         view
354         returns (bool)
355     {
356         return _root_users[who];
357     }
358 
359     function isCapabilityPublic(address code, bytes4 sig)
360         public
361         view
362         returns (bool)
363     {
364         return _public_capabilities[code][sig];
365     }
366 
367     function hasUserRole(address who, uint8 role)
368         public
369         view
370         returns (bool)
371     {
372         bytes32 roles = getUserRoles(who);
373         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
374         return bytes32(0) != roles & shifted;
375     }
376 
377     function canCall(address caller, address code, bytes4 sig)
378         public
379         view
380         returns (bool)
381     {
382         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
383             return true;
384         } else {
385             bytes32 has_roles = getUserRoles(caller);
386             bytes32 needs_one_of = getCapabilityRoles(code, sig);
387             return bytes32(0) != has_roles & needs_one_of;
388         }
389     }
390 
391     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
392         return (input ^ bytes32(uint(-1)));
393     }
394 
395     function setRootUser(address who, bool enabled)
396         public
397         auth
398     {
399         _root_users[who] = enabled;
400     }
401 
402     function setUserRole(address who, uint8 role, bool enabled)
403         public
404         auth
405     {
406         bytes32 last_roles = _user_roles[who];
407         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
408         if( enabled ) {
409             _user_roles[who] = last_roles | shifted;
410         } else {
411             _user_roles[who] = last_roles & BITNOT(shifted);
412         }
413     }
414 
415     function setPublicCapability(address code, bytes4 sig, bool enabled)
416         public
417         auth
418     {
419         _public_capabilities[code][sig] = enabled;
420     }
421 
422     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
423         public
424         auth
425     {
426         bytes32 last_roles = _capability_roles[code][sig];
427         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
428         if( enabled ) {
429             _capability_roles[code][sig] = last_roles | shifted;
430         } else {
431             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
432         }
433 
434     }
435 
436 }
437 
438 
439 contract DSChiefApprovals is DSThing {
440     mapping(bytes32=>address[]) public slates;
441     mapping(address=>bytes32) public votes;
442     mapping(address=>uint256) public approvals;
443     mapping(address=>uint256) public deposits;
444     DSToken public GOV; // voting token that gets locked up
445     DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms
446     address public hat; // the chieftain's hat
447 
448     uint256 public MAX_YAYS;
449 
450     event Etch(bytes32 indexed slate);
451 
452     // IOU constructed outside this contract reduces deployment costs significantly
453     // lock/free/vote are quite sensitive to token invariants. Caution is advised.
454     constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public
455     {
456         GOV = GOV_;
457         IOU = IOU_;
458         MAX_YAYS = MAX_YAYS_;
459     }
460 
461     function lock(uint wad)
462         public
463         note
464     {
465         GOV.pull(msg.sender, wad);
466         IOU.mint(msg.sender, wad);
467         deposits[msg.sender] = add(deposits[msg.sender], wad);
468         addWeight(wad, votes[msg.sender]);
469     }
470 
471     function free(uint wad)
472         public
473         note
474     {
475         deposits[msg.sender] = sub(deposits[msg.sender], wad);
476         subWeight(wad, votes[msg.sender]);
477         IOU.burn(msg.sender, wad);
478         GOV.push(msg.sender, wad);
479     }
480 
481     function etch(address[] memory yays)
482         public
483         note
484         returns (bytes32 slate)
485     {
486         require( yays.length <= MAX_YAYS );
487         requireByteOrderedSet(yays);
488 
489         bytes32 hash = keccak256(abi.encodePacked(yays));
490         slates[hash] = yays;
491         emit Etch(hash);
492         return hash;
493     }
494 
495     function vote(address[] memory yays) public returns (bytes32)
496         // note  both sub-calls note
497     {
498         bytes32 slate = etch(yays);
499         vote(slate);
500         return slate;
501     }
502 
503     function vote(bytes32 slate)
504         public
505         note
506     {
507         require(slates[slate].length > 0 || 
508             slate == 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470, "ds-chief-invalid-slate");
509         uint weight = deposits[msg.sender];
510         subWeight(weight, votes[msg.sender]);
511         votes[msg.sender] = slate;
512         addWeight(weight, votes[msg.sender]);
513     }
514 
515     // like `drop`/`swap` except simply "elect this address if it is higher than current hat"
516     function lift(address whom)
517         public
518         note
519     {
520         require(approvals[whom] > approvals[hat]);
521         hat = whom;
522     }
523 
524     function addWeight(uint weight, bytes32 slate)
525         internal
526     {
527         address[] storage yays = slates[slate];
528         for( uint i = 0; i < yays.length; i++) {
529             approvals[yays[i]] = add(approvals[yays[i]], weight);
530         }
531     }
532 
533     function subWeight(uint weight, bytes32 slate)
534         internal
535     {
536         address[] storage yays = slates[slate];
537         for( uint i = 0; i < yays.length; i++) {
538             approvals[yays[i]] = sub(approvals[yays[i]], weight);
539         }
540     }
541 
542     // Throws unless the array of addresses is a ordered set.
543     function requireByteOrderedSet(address[] memory yays)
544         internal
545         pure
546     {
547         if( yays.length == 0 || yays.length == 1 ) {
548             return;
549         }
550         for( uint i = 0; i < yays.length - 1; i++ ) {
551             // strict inequality ensures both ordering and uniqueness
552             require(uint(yays[i]) < uint(yays[i+1]));
553         }
554     }
555 }
556 
557 
558 // `hat` address is unique root user (has every role) and the
559 // unique owner of role 0 (typically 'sys' or 'internal')
560 contract DSChief is DSRoles, DSChiefApprovals {
561 
562     constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)
563              DSChiefApprovals (GOV, IOU, MAX_YAYS)
564         public
565     {
566         authority = this;
567         owner = address(0);
568     }
569 
570     function setOwner(address owner_) public {
571         owner_;
572         revert();
573     }
574 
575     function setAuthority(DSAuthority authority_) public {
576         authority_;
577         revert();
578     }
579 
580     function isUserRoot(address who)
581         public view
582         returns (bool)
583     {
584         return (who == hat);
585     }
586     function setRootUser(address who, bool enabled) public {
587         who; enabled;
588         revert();
589     }
590 }
591 
592 contract DSChiefFab {
593     function newChief(DSToken gov, uint MAX_YAYS) public returns (DSChief chief) {
594         DSToken iou = new DSToken('IOU');
595         chief = new DSChief(gov, iou, MAX_YAYS);
596         iou.setOwner(address(chief));
597     }
598 }
599 
600 
601 contract VoteProxy {
602     address public cold;
603     address public hot;
604     DSToken public gov;
605     DSToken public iou;
606     DSChief public chief;
607 
608     constructor(DSChief _chief, address _cold, address _hot) public {
609         chief = _chief;
610         cold = _cold;
611         hot = _hot;
612 
613         gov = chief.GOV();
614         iou = chief.IOU();
615         gov.approve(address(chief), uint256(-1));
616         iou.approve(address(chief), uint256(-1));
617     }
618 
619     modifier auth() {
620         require(msg.sender == hot || msg.sender == cold, "Sender must be a Cold or Hot Wallet");
621         _;
622     }
623 
624     function lock(uint256 wad) public auth {
625         gov.pull(cold, wad);   // mkr from cold
626         chief.lock(wad);       // mkr out, ious in
627     }
628 
629     function free(uint256 wad) public auth {
630         chief.free(wad);       // ious out, mkr in
631         gov.push(cold, wad);   // mkr to cold
632     }
633 
634     function freeAll() public auth {
635         chief.free(chief.deposits(address(this)));
636         gov.push(cold, gov.balanceOf(address(this)));
637     }
638 
639     function vote(address[] memory yays) public auth returns (bytes32) {
640         return chief.vote(yays);
641     }
642 
643     function vote(bytes32 slate) public auth {
644         chief.vote(slate);
645     }
646 }
647 
648 contract VoteProxyFactory {
649     DSChief public chief;
650     mapping(address => VoteProxy) public hotMap;
651     mapping(address => VoteProxy) public coldMap;
652     mapping(address => address) public linkRequests;
653 
654     event LinkRequested(address indexed cold, address indexed hot);
655     event LinkConfirmed(address indexed cold, address indexed hot, address indexed voteProxy);
656 
657     constructor(DSChief chief_) public { chief = chief_; }
658 
659     function hasProxy(address guy) public view returns (bool) {
660         return (address(coldMap[guy]) != address(0x0) || address(hotMap[guy]) != address(0x0));
661     }
662 
663     function initiateLink(address hot) public {
664         require(!hasProxy(msg.sender), "Cold wallet is already linked to another Vote Proxy");
665         require(!hasProxy(hot), "Hot wallet is already linked to another Vote Proxy");
666 
667         linkRequests[msg.sender] = hot;
668         emit LinkRequested(msg.sender, hot);
669     }
670 
671     function approveLink(address cold) public returns (VoteProxy voteProxy) {
672         require(linkRequests[cold] == msg.sender, "Cold wallet must initiate a link first");
673         require(!hasProxy(msg.sender), "Hot wallet is already linked to another Vote Proxy");
674 
675         voteProxy = new VoteProxy(chief, cold, msg.sender);
676         hotMap[msg.sender] = voteProxy;
677         coldMap[cold] = voteProxy;
678         delete linkRequests[cold];
679         emit LinkConfirmed(cold, msg.sender, address(voteProxy));
680     }
681 
682     function breakLink() public {
683         require(hasProxy(msg.sender), "No VoteProxy found for this sender");
684 
685         VoteProxy voteProxy = address(coldMap[msg.sender]) != address(0x0)
686             ? coldMap[msg.sender] : hotMap[msg.sender];
687         address cold = voteProxy.cold();
688         address hot = voteProxy.hot();
689         require(chief.deposits(address(voteProxy)) == 0, "VoteProxy still has funds attached to it");
690 
691         delete coldMap[cold];
692         delete hotMap[hot];
693     }
694 
695     function linkSelf() public returns (VoteProxy voteProxy) {
696         initiateLink(msg.sender);
697         return approveLink(msg.sender);
698     }
699 }