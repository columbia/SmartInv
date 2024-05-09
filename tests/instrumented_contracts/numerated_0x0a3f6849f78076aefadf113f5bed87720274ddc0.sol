1 // chief.sol - select an authority by consensus
2 
3 // Copyright (C) 2017  DappHub, LLC
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity >=0.4.23;
19 
20 contract DSMath {
21     function add(uint x, uint y) internal pure returns (uint z) {
22         require((z = x + y) >= x, "ds-math-add-overflow");
23     }
24     function sub(uint x, uint y) internal pure returns (uint z) {
25         require((z = x - y) <= x, "ds-math-sub-underflow");
26     }
27     function mul(uint x, uint y) internal pure returns (uint z) {
28         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
29     }
30 
31     function min(uint x, uint y) internal pure returns (uint z) {
32         return x <= y ? x : y;
33     }
34     function max(uint x, uint y) internal pure returns (uint z) {
35         return x >= y ? x : y;
36     }
37     function imin(int x, int y) internal pure returns (int z) {
38         return x <= y ? x : y;
39     }
40     function imax(int x, int y) internal pure returns (int z) {
41         return x >= y ? x : y;
42     }
43 
44     uint constant WAD = 10 ** 18;
45     uint constant RAY = 10 ** 27;
46 
47     //rounds to zero if x*y < WAD / 2
48     function wmul(uint x, uint y) internal pure returns (uint z) {
49         z = add(mul(x, y), WAD / 2) / WAD;
50     }
51     //rounds to zero if x*y < WAD / 2
52     function rmul(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, y), RAY / 2) / RAY;
54     }
55     //rounds to zero if x*y < WAD / 2
56     function wdiv(uint x, uint y) internal pure returns (uint z) {
57         z = add(mul(x, WAD), y / 2) / y;
58     }
59     //rounds to zero if x*y < RAY / 2
60     function rdiv(uint x, uint y) internal pure returns (uint z) {
61         z = add(mul(x, RAY), y / 2) / y;
62     }
63 
64     // This famous algorithm is called "exponentiation by squaring"
65     // and calculates x^n with x as fixed-point and n as regular unsigned.
66     //
67     // It's O(log n), instead of O(n) for naive repeated multiplication.
68     //
69     // These facts are why it works:
70     //
71     //  If n is even, then x^n = (x^2)^(n/2).
72     //  If n is odd,  then x^n = x * x^(n-1),
73     //   and applying the equation for even x gives
74     //    x^n = x * (x^2)^((n-1) / 2).
75     //
76     //  Also, EVM division is flooring and
77     //    floor[(n-1) / 2] = floor[n / 2].
78     //
79     function rpow(uint x, uint n) internal pure returns (uint z) {
80         z = n % 2 != 0 ? x : RAY;
81 
82         for (n /= 2; n != 0; n /= 2) {
83             x = rmul(x, x);
84 
85             if (n % 2 != 0) {
86                 z = rmul(z, x);
87             }
88         }
89     }
90 }
91 
92 interface DSAuthority {
93     function canCall(
94         address src, address dst, bytes4 sig
95     ) external view returns (bool);
96 }
97 
98 contract DSAuthEvents {
99     event LogSetAuthority (address indexed authority);
100     event LogSetOwner     (address indexed owner);
101 }
102 
103 contract DSAuth is DSAuthEvents {
104     DSAuthority  public  authority;
105     address      public  owner;
106 
107     constructor() public {
108         owner = msg.sender;
109         emit LogSetOwner(msg.sender);
110     }
111 
112     function setOwner(address owner_)
113         public
114         auth
115     {
116         owner = owner_;
117         emit LogSetOwner(owner);
118     }
119 
120     function setAuthority(DSAuthority authority_)
121         public
122         auth
123     {
124         authority = authority_;
125         emit LogSetAuthority(address(authority));
126     }
127 
128     modifier auth {
129         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
130         _;
131     }
132 
133     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
134         if (src == address(this)) {
135             return true;
136         } else if (src == owner) {
137             return true;
138         } else if (authority == DSAuthority(0)) {
139             return false;
140         } else {
141             return authority.canCall(src, address(this), sig);
142         }
143     }
144 }
145 
146 contract DSToken is DSMath, DSAuth {
147     bool                                              public  stopped;
148     uint256                                           public  totalSupply;
149     mapping (address => uint256)                      public  balanceOf;
150     mapping (address => mapping (address => uint256)) public  allowance;
151     bytes32                                           public  symbol;
152     uint256                                           public  decimals = 18; // standard token precision. override to customize
153     bytes32                                           public  name = "";     // Optional token name
154 
155     constructor(bytes32 symbol_) public {
156         symbol = symbol_;
157     }
158 
159     event Approval(address indexed src, address indexed guy, uint wad);
160     event Transfer(address indexed src, address indexed dst, uint wad);
161     event Mint(address indexed guy, uint wad);
162     event Burn(address indexed guy, uint wad);
163     event Stop();
164     event Start();
165 
166     modifier stoppable {
167         require(!stopped, "ds-stop-is-stopped");
168         _;
169     }
170 
171     function approve(address guy) external returns (bool) {
172         return approve(guy, uint(-1));
173     }
174 
175     function approve(address guy, uint wad) public stoppable returns (bool) {
176         allowance[msg.sender][guy] = wad;
177 
178         emit Approval(msg.sender, guy, wad);
179 
180         return true;
181     }
182 
183     function transfer(address dst, uint wad) external returns (bool) {
184         return transferFrom(msg.sender, dst, wad);
185     }
186 
187     function transferFrom(address src, address dst, uint wad)
188         public
189         stoppable
190         returns (bool)
191     {
192         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
193             require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
194             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
195         }
196 
197         require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
198         balanceOf[src] = sub(balanceOf[src], wad);
199         balanceOf[dst] = add(balanceOf[dst], wad);
200 
201         emit Transfer(src, dst, wad);
202 
203         return true;
204     }
205 
206     function push(address dst, uint wad) external {
207         transferFrom(msg.sender, dst, wad);
208     }
209 
210     function pull(address src, uint wad) external {
211         transferFrom(src, msg.sender, wad);
212     }
213 
214     function move(address src, address dst, uint wad) external {
215         transferFrom(src, dst, wad);
216     }
217 
218 
219     function mint(uint wad) external {
220         mint(msg.sender, wad);
221     }
222 
223     function burn(uint wad) external {
224         burn(msg.sender, wad);
225     }
226 
227     function mint(address guy, uint wad) public auth stoppable {
228         balanceOf[guy] = add(balanceOf[guy], wad);
229         totalSupply = add(totalSupply, wad);
230         emit Mint(guy, wad);
231     }
232 
233     function burn(address guy, uint wad) public auth stoppable {
234         if (guy != msg.sender && allowance[guy][msg.sender] != uint(-1)) {
235             require(allowance[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
236             allowance[guy][msg.sender] = sub(allowance[guy][msg.sender], wad);
237         }
238 
239         require(balanceOf[guy] >= wad, "ds-token-insufficient-balance");
240         balanceOf[guy] = sub(balanceOf[guy], wad);
241         totalSupply = sub(totalSupply, wad);
242         emit Burn(guy, wad);
243     }
244 
245     function stop() public auth {
246         stopped = true;
247         emit Stop();
248     }
249 
250     function start() public auth {
251         stopped = false;
252         emit Start();
253     }
254 
255     function setName(bytes32 name_) external auth {
256         name = name_;
257     }
258 }
259 
260 contract DSRoles is DSAuth, DSAuthority
261 {
262     mapping(address=>bool) _root_users;
263     mapping(address=>bytes32) _user_roles;
264     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
265     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
266 
267     function getUserRoles(address who)
268         public
269         view
270         returns (bytes32)
271     {
272         return _user_roles[who];
273     }
274 
275     function getCapabilityRoles(address code, bytes4 sig)
276         public
277         view
278         returns (bytes32)
279     {
280         return _capability_roles[code][sig];
281     }
282 
283     function isUserRoot(address who)
284         public
285         view
286         returns (bool)
287     {
288         return _root_users[who];
289     }
290 
291     function isCapabilityPublic(address code, bytes4 sig)
292         public
293         view
294         returns (bool)
295     {
296         return _public_capabilities[code][sig];
297     }
298 
299     function hasUserRole(address who, uint8 role)
300         public
301         view
302         returns (bool)
303     {
304         bytes32 roles = getUserRoles(who);
305         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
306         return bytes32(0) != roles & shifted;
307     }
308 
309     function canCall(address caller, address code, bytes4 sig)
310         public
311         view
312         returns (bool)
313     {
314         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
315             return true;
316         } else {
317             bytes32 has_roles = getUserRoles(caller);
318             bytes32 needs_one_of = getCapabilityRoles(code, sig);
319             return bytes32(0) != has_roles & needs_one_of;
320         }
321     }
322 
323     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
324         return (input ^ bytes32(uint(-1)));
325     }
326 
327     function setRootUser(address who, bool enabled)
328         public
329         auth
330     {
331         _root_users[who] = enabled;
332     }
333 
334     function setUserRole(address who, uint8 role, bool enabled)
335         public
336         auth
337     {
338         bytes32 last_roles = _user_roles[who];
339         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
340         if( enabled ) {
341             _user_roles[who] = last_roles | shifted;
342         } else {
343             _user_roles[who] = last_roles & BITNOT(shifted);
344         }
345     }
346 
347     function setPublicCapability(address code, bytes4 sig, bool enabled)
348         public
349         auth
350     {
351         _public_capabilities[code][sig] = enabled;
352     }
353 
354     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
355         public
356         auth
357     {
358         bytes32 last_roles = _capability_roles[code][sig];
359         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
360         if( enabled ) {
361             _capability_roles[code][sig] = last_roles | shifted;
362         } else {
363             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
364         }
365 
366     }
367 
368 }
369 
370 contract DSNote {
371     event LogNote(
372         bytes4   indexed  sig,
373         address  indexed  guy,
374         bytes32  indexed  foo,
375         bytes32  indexed  bar,
376         uint256           wad,
377         bytes             fax
378     ) anonymous;
379 
380     modifier note {
381         bytes32 foo;
382         bytes32 bar;
383         uint256 wad;
384 
385         assembly {
386             foo := calldataload(4)
387             bar := calldataload(36)
388             wad := callvalue()
389         }
390 
391         _;
392 
393         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
394     }
395 }
396 
397 contract DSThing is DSAuth, DSNote, DSMath {
398     function S(string memory s) internal pure returns (bytes4) {
399         return bytes4(keccak256(abi.encodePacked(s)));
400     }
401 
402 }
403 
404 // The right way to use this contract is probably to mix it with some kind
405 // of `DSAuthority`, like with `ds-roles`.
406 //   SEE DSChief
407 contract DSChiefApprovals is DSThing {
408     mapping(bytes32=>address[]) public slates;
409     mapping(address=>bytes32) public votes;
410     mapping(address=>uint256) public approvals;
411     mapping(address=>uint256) public deposits;
412     DSToken public GOV; // voting token that gets locked up
413     DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms
414     address public hat; // the chieftain's hat
415 
416     uint256 public MAX_YAYS;
417 
418     mapping(address=>uint256) public last;
419 
420     bool public live;
421 
422     uint256 constant LAUNCH_THRESHOLD = 80_000 * 10 ** 18; // 80K MKR launch threshold
423 
424     event Etch(bytes32 indexed slate);
425 
426     // IOU constructed outside this contract reduces deployment costs significantly
427     // lock/free/vote are quite sensitive to token invariants. Caution is advised.
428     constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public
429     {
430         GOV = GOV_;
431         IOU = IOU_;
432         MAX_YAYS = MAX_YAYS_;
433     }
434 
435     function launch()
436         public
437         note
438     {
439         require(!live);
440         require(hat == address(0) && approvals[address(0)] >= LAUNCH_THRESHOLD);
441         live = true;
442     }
443 
444     function lock(uint wad)
445         public
446         note
447     {
448         last[msg.sender] = block.number;
449         GOV.pull(msg.sender, wad);
450         IOU.mint(msg.sender, wad);
451         deposits[msg.sender] = add(deposits[msg.sender], wad);
452         addWeight(wad, votes[msg.sender]);
453     }
454 
455     function free(uint wad)
456         public
457         note
458     {
459         require(block.number > last[msg.sender]);
460         deposits[msg.sender] = sub(deposits[msg.sender], wad);
461         subWeight(wad, votes[msg.sender]);
462         IOU.burn(msg.sender, wad);
463         GOV.push(msg.sender, wad);
464     }
465 
466     function etch(address[] memory yays)
467         public
468         note
469         returns (bytes32 slate)
470     {
471         require( yays.length <= MAX_YAYS );
472         requireByteOrderedSet(yays);
473 
474         bytes32 hash = keccak256(abi.encodePacked(yays));
475         slates[hash] = yays;
476         emit Etch(hash);
477         return hash;
478     }
479 
480     function vote(address[] memory yays) public returns (bytes32)
481         // note  both sub-calls note
482     {
483         bytes32 slate = etch(yays);
484         vote(slate);
485         return slate;
486     }
487 
488     function vote(bytes32 slate)
489         public
490         note
491     {
492         require(slates[slate].length > 0 ||
493             slate == 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470, "ds-chief-invalid-slate");
494         uint weight = deposits[msg.sender];
495         subWeight(weight, votes[msg.sender]);
496         votes[msg.sender] = slate;
497         addWeight(weight, votes[msg.sender]);
498     }
499 
500     // like `drop`/`swap` except simply "elect this address if it is higher than current hat"
501     function lift(address whom)
502         public
503         note
504     {
505         require(approvals[whom] > approvals[hat]);
506         hat = whom;
507     }
508 
509     function addWeight(uint weight, bytes32 slate)
510         internal
511     {
512         address[] storage yays = slates[slate];
513         for( uint i = 0; i < yays.length; i++) {
514             approvals[yays[i]] = add(approvals[yays[i]], weight);
515         }
516     }
517 
518     function subWeight(uint weight, bytes32 slate)
519         internal
520     {
521         address[] storage yays = slates[slate];
522         for( uint i = 0; i < yays.length; i++) {
523             approvals[yays[i]] = sub(approvals[yays[i]], weight);
524         }
525     }
526 
527     // Throws unless the array of addresses is a ordered set.
528     function requireByteOrderedSet(address[] memory yays)
529         internal
530         pure
531     {
532         if( yays.length == 0 || yays.length == 1 ) {
533             return;
534         }
535         for( uint i = 0; i < yays.length - 1; i++ ) {
536             // strict inequality ensures both ordering and uniqueness
537             require(uint(yays[i]) < uint(yays[i+1]));
538         }
539     }
540 }
541 
542 
543 // `hat` address is unique root user (has every role) and the
544 // unique owner of role 0 (typically 'sys' or 'internal')
545 contract DSChief is DSRoles, DSChiefApprovals {
546 
547     constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)
548              DSChiefApprovals (GOV, IOU, MAX_YAYS)
549         public
550     {
551         authority = this;
552         owner = address(0);
553     }
554 
555     function setOwner(address owner_) public {
556         owner_;
557         revert();
558     }
559 
560     function setAuthority(DSAuthority authority_) public {
561         authority_;
562         revert();
563     }
564 
565     function isUserRoot(address who)
566         public view
567         returns (bool)
568     {
569         return (live && who == hat);
570     }
571     function setRootUser(address who, bool enabled) public {
572         who; enabled;
573         revert();
574     }
575 }