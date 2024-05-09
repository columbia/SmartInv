1 // hevm: flattened sources of src/chief.sol
2 pragma solidity >0.4.13 >0.4.20 >=0.4.23;
3 
4 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
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
18 /* pragma solidity >=0.4.23; */
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(address(authority));
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, address(this), sig);
70         }
71     }
72 }
73 
74 ////// lib/ds-roles/src/roles.sol
75 // roles.sol - roled based authentication
76 
77 // Copyright (C) 2017  DappHub, LLC
78 
79 // This program is free software: you can redistribute it and/or modify
80 // it under the terms of the GNU General Public License as published by
81 // the Free Software Foundation, either version 3 of the License, or
82 // (at your option) any later version.
83 
84 // This program is distributed in the hope that it will be useful,
85 // but WITHOUT ANY WARRANTY; without even the implied warranty of
86 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
87 // GNU General Public License for more details.
88 
89 // You should have received a copy of the GNU General Public License
90 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
91 
92 /* pragma solidity >=0.4.23; */
93 
94 /* import 'ds-auth/auth.sol'; */
95 
96 contract DSRoles is DSAuth, DSAuthority
97 {
98     mapping(address=>bool) _root_users;
99     mapping(address=>bytes32) _user_roles;
100     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
101     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
102 
103     function getUserRoles(address who)
104         public
105         view
106         returns (bytes32)
107     {
108         return _user_roles[who];
109     }
110 
111     function getCapabilityRoles(address code, bytes4 sig)
112         public
113         view
114         returns (bytes32)
115     {
116         return _capability_roles[code][sig];
117     }
118 
119     function isUserRoot(address who)
120         public
121         view
122         returns (bool)
123     {
124         return _root_users[who];
125     }
126 
127     function isCapabilityPublic(address code, bytes4 sig)
128         public
129         view
130         returns (bool)
131     {
132         return _public_capabilities[code][sig];
133     }
134 
135     function hasUserRole(address who, uint8 role)
136         public
137         view
138         returns (bool)
139     {
140         bytes32 roles = getUserRoles(who);
141         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
142         return bytes32(0) != roles & shifted;
143     }
144 
145     function canCall(address caller, address code, bytes4 sig)
146         public
147         view
148         returns (bool)
149     {
150         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
151             return true;
152         } else {
153             bytes32 has_roles = getUserRoles(caller);
154             bytes32 needs_one_of = getCapabilityRoles(code, sig);
155             return bytes32(0) != has_roles & needs_one_of;
156         }
157     }
158 
159     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
160         return (input ^ bytes32(uint(-1)));
161     }
162 
163     function setRootUser(address who, bool enabled)
164         public
165         auth
166     {
167         _root_users[who] = enabled;
168     }
169 
170     function setUserRole(address who, uint8 role, bool enabled)
171         public
172         auth
173     {
174         bytes32 last_roles = _user_roles[who];
175         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
176         if( enabled ) {
177             _user_roles[who] = last_roles | shifted;
178         } else {
179             _user_roles[who] = last_roles & BITNOT(shifted);
180         }
181     }
182 
183     function setPublicCapability(address code, bytes4 sig, bool enabled)
184         public
185         auth
186     {
187         _public_capabilities[code][sig] = enabled;
188     }
189 
190     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
191         public
192         auth
193     {
194         bytes32 last_roles = _capability_roles[code][sig];
195         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
196         if( enabled ) {
197             _capability_roles[code][sig] = last_roles | shifted;
198         } else {
199             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
200         }
201 
202     }
203 
204 }
205 
206 ////// lib/ds-thing/lib/ds-math/src/math.sol
207 /// math.sol -- mixin for inline numerical wizardry
208 
209 // This program is free software: you can redistribute it and/or modify
210 // it under the terms of the GNU General Public License as published by
211 // the Free Software Foundation, either version 3 of the License, or
212 // (at your option) any later version.
213 
214 // This program is distributed in the hope that it will be useful,
215 // but WITHOUT ANY WARRANTY; without even the implied warranty of
216 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
217 // GNU General Public License for more details.
218 
219 // You should have received a copy of the GNU General Public License
220 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
221 
222 /* pragma solidity >0.4.13; */
223 
224 contract DSMath {
225     function add(uint x, uint y) internal pure returns (uint z) {
226         require((z = x + y) >= x, "ds-math-add-overflow");
227     }
228     function sub(uint x, uint y) internal pure returns (uint z) {
229         require((z = x - y) <= x, "ds-math-sub-underflow");
230     }
231     function mul(uint x, uint y) internal pure returns (uint z) {
232         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
233     }
234 
235     function min(uint x, uint y) internal pure returns (uint z) {
236         return x <= y ? x : y;
237     }
238     function max(uint x, uint y) internal pure returns (uint z) {
239         return x >= y ? x : y;
240     }
241     function imin(int x, int y) internal pure returns (int z) {
242         return x <= y ? x : y;
243     }
244     function imax(int x, int y) internal pure returns (int z) {
245         return x >= y ? x : y;
246     }
247 
248     uint constant WAD = 10 ** 18;
249     uint constant RAY = 10 ** 27;
250 
251     function wmul(uint x, uint y) internal pure returns (uint z) {
252         z = add(mul(x, y), WAD / 2) / WAD;
253     }
254     function rmul(uint x, uint y) internal pure returns (uint z) {
255         z = add(mul(x, y), RAY / 2) / RAY;
256     }
257     function wdiv(uint x, uint y) internal pure returns (uint z) {
258         z = add(mul(x, WAD), y / 2) / y;
259     }
260     function rdiv(uint x, uint y) internal pure returns (uint z) {
261         z = add(mul(x, RAY), y / 2) / y;
262     }
263 
264     // This famous algorithm is called "exponentiation by squaring"
265     // and calculates x^n with x as fixed-point and n as regular unsigned.
266     //
267     // It's O(log n), instead of O(n) for naive repeated multiplication.
268     //
269     // These facts are why it works:
270     //
271     //  If n is even, then x^n = (x^2)^(n/2).
272     //  If n is odd,  then x^n = x * x^(n-1),
273     //   and applying the equation for even x gives
274     //    x^n = x * (x^2)^((n-1) / 2).
275     //
276     //  Also, EVM division is flooring and
277     //    floor[(n-1) / 2] = floor[n / 2].
278     //
279     function rpow(uint x, uint n) internal pure returns (uint z) {
280         z = n % 2 != 0 ? x : RAY;
281 
282         for (n /= 2; n != 0; n /= 2) {
283             x = rmul(x, x);
284 
285             if (n % 2 != 0) {
286                 z = rmul(z, x);
287             }
288         }
289     }
290 }
291 
292 ////// lib/ds-thing/lib/ds-note/src/note.sol
293 /// note.sol -- the `note' modifier, for logging calls as events
294 
295 // This program is free software: you can redistribute it and/or modify
296 // it under the terms of the GNU General Public License as published by
297 // the Free Software Foundation, either version 3 of the License, or
298 // (at your option) any later version.
299 
300 // This program is distributed in the hope that it will be useful,
301 // but WITHOUT ANY WARRANTY; without even the implied warranty of
302 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
303 // GNU General Public License for more details.
304 
305 // You should have received a copy of the GNU General Public License
306 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
307 
308 /* pragma solidity >=0.4.23; */
309 
310 contract DSNote {
311     event LogNote(
312         bytes4   indexed  sig,
313         address  indexed  guy,
314         bytes32  indexed  foo,
315         bytes32  indexed  bar,
316         uint256           wad,
317         bytes             fax
318     ) anonymous;
319 
320     modifier note {
321         bytes32 foo;
322         bytes32 bar;
323         uint256 wad;
324 
325         assembly {
326             foo := calldataload(4)
327             bar := calldataload(36)
328             wad := callvalue
329         }
330 
331         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
332 
333         _;
334     }
335 }
336 
337 ////// lib/ds-thing/src/thing.sol
338 // thing.sol - `auth` with handy mixins. your things should be DSThings
339 
340 // Copyright (C) 2017  DappHub, LLC
341 
342 // This program is free software: you can redistribute it and/or modify
343 // it under the terms of the GNU General Public License as published by
344 // the Free Software Foundation, either version 3 of the License, or
345 // (at your option) any later version.
346 
347 // This program is distributed in the hope that it will be useful,
348 // but WITHOUT ANY WARRANTY; without even the implied warranty of
349 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
350 // GNU General Public License for more details.
351 
352 // You should have received a copy of the GNU General Public License
353 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
354 
355 /* pragma solidity >=0.4.23; */
356 
357 /* import 'ds-auth/auth.sol'; */
358 /* import 'ds-note/note.sol'; */
359 /* import 'ds-math/math.sol'; */
360 
361 contract DSThing is DSAuth, DSNote, DSMath {
362     function S(string memory s) internal pure returns (bytes4) {
363         return bytes4(keccak256(abi.encodePacked(s)));
364     }
365 
366 }
367 
368 ////// lib/ds-token/lib/ds-stop/src/stop.sol
369 /// stop.sol -- mixin for enable/disable functionality
370 
371 // Copyright (C) 2017  DappHub, LLC
372 
373 // This program is free software: you can redistribute it and/or modify
374 // it under the terms of the GNU General Public License as published by
375 // the Free Software Foundation, either version 3 of the License, or
376 // (at your option) any later version.
377 
378 // This program is distributed in the hope that it will be useful,
379 // but WITHOUT ANY WARRANTY; without even the implied warranty of
380 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
381 // GNU General Public License for more details.
382 
383 // You should have received a copy of the GNU General Public License
384 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
385 
386 /* pragma solidity >=0.4.23; */
387 
388 /* import "ds-auth/auth.sol"; */
389 /* import "ds-note/note.sol"; */
390 
391 contract DSStop is DSNote, DSAuth {
392     bool public stopped;
393 
394     modifier stoppable {
395         require(!stopped, "ds-stop-is-stopped");
396         _;
397     }
398     function stop() public auth note {
399         stopped = true;
400     }
401     function start() public auth note {
402         stopped = false;
403     }
404 
405 }
406 
407 ////// lib/ds-token/lib/erc20/src/erc20.sol
408 /// erc20.sol -- API for the ERC20 token standard
409 
410 // See <https://github.com/ethereum/EIPs/issues/20>.
411 
412 // This file likely does not meet the threshold of originality
413 // required for copyright to apply.  As a result, this is free and
414 // unencumbered software belonging to the public domain.
415 
416 /* pragma solidity >0.4.20; */
417 
418 contract ERC20Events {
419     event Approval(address indexed src, address indexed guy, uint wad);
420     event Transfer(address indexed src, address indexed dst, uint wad);
421 }
422 
423 contract ERC20 is ERC20Events {
424     function totalSupply() public view returns (uint);
425     function balanceOf(address guy) public view returns (uint);
426     function allowance(address src, address guy) public view returns (uint);
427 
428     function approve(address guy, uint wad) public returns (bool);
429     function transfer(address dst, uint wad) public returns (bool);
430     function transferFrom(
431         address src, address dst, uint wad
432     ) public returns (bool);
433 }
434 
435 ////// lib/ds-token/src/base.sol
436 /// base.sol -- basic ERC20 implementation
437 
438 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
439 
440 // This program is free software: you can redistribute it and/or modify
441 // it under the terms of the GNU General Public License as published by
442 // the Free Software Foundation, either version 3 of the License, or
443 // (at your option) any later version.
444 
445 // This program is distributed in the hope that it will be useful,
446 // but WITHOUT ANY WARRANTY; without even the implied warranty of
447 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
448 // GNU General Public License for more details.
449 
450 // You should have received a copy of the GNU General Public License
451 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
452 
453 /* pragma solidity >=0.4.23; */
454 
455 /* import "erc20/erc20.sol"; */
456 /* import "ds-math/math.sol"; */
457 
458 contract DSTokenBase is ERC20, DSMath {
459     uint256                                            _supply;
460     mapping (address => uint256)                       _balances;
461     mapping (address => mapping (address => uint256))  _approvals;
462 
463     constructor(uint supply) public {
464         _balances[msg.sender] = supply;
465         _supply = supply;
466     }
467 
468     function totalSupply() public view returns (uint) {
469         return _supply;
470     }
471     function balanceOf(address src) public view returns (uint) {
472         return _balances[src];
473     }
474     function allowance(address src, address guy) public view returns (uint) {
475         return _approvals[src][guy];
476     }
477 
478     function transfer(address dst, uint wad) public returns (bool) {
479         return transferFrom(msg.sender, dst, wad);
480     }
481 
482     function transferFrom(address src, address dst, uint wad)
483         public
484         returns (bool)
485     {
486         if (src != msg.sender) {
487             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
488             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
489         }
490 
491         require(_balances[src] >= wad, "ds-token-insufficient-balance");
492         _balances[src] = sub(_balances[src], wad);
493         _balances[dst] = add(_balances[dst], wad);
494 
495         emit Transfer(src, dst, wad);
496 
497         return true;
498     }
499 
500     function approve(address guy, uint wad) public returns (bool) {
501         _approvals[msg.sender][guy] = wad;
502 
503         emit Approval(msg.sender, guy, wad);
504 
505         return true;
506     }
507 }
508 
509 ////// lib/ds-token/src/token.sol
510 /// token.sol -- ERC20 implementation with minting and burning
511 
512 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
513 
514 // This program is free software: you can redistribute it and/or modify
515 // it under the terms of the GNU General Public License as published by
516 // the Free Software Foundation, either version 3 of the License, or
517 // (at your option) any later version.
518 
519 // This program is distributed in the hope that it will be useful,
520 // but WITHOUT ANY WARRANTY; without even the implied warranty of
521 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
522 // GNU General Public License for more details.
523 
524 // You should have received a copy of the GNU General Public License
525 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
526 
527 /* pragma solidity >=0.4.23; */
528 
529 /* import "ds-stop/stop.sol"; */
530 
531 /* import "./base.sol"; */
532 
533 contract DSToken is DSTokenBase(0), DSStop {
534 
535     bytes32  public  symbol;
536     uint256  public  decimals = 18; // standard token precision. override to customize
537 
538     constructor(bytes32 symbol_) public {
539         symbol = symbol_;
540     }
541 
542     event Mint(address indexed guy, uint wad);
543     event Burn(address indexed guy, uint wad);
544 
545     function approve(address guy) public stoppable returns (bool) {
546         return super.approve(guy, uint(-1));
547     }
548 
549     function approve(address guy, uint wad) public stoppable returns (bool) {
550         return super.approve(guy, wad);
551     }
552 
553     function transferFrom(address src, address dst, uint wad)
554         public
555         stoppable
556         returns (bool)
557     {
558         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
559             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
560             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
561         }
562 
563         require(_balances[src] >= wad, "ds-token-insufficient-balance");
564         _balances[src] = sub(_balances[src], wad);
565         _balances[dst] = add(_balances[dst], wad);
566 
567         emit Transfer(src, dst, wad);
568 
569         return true;
570     }
571 
572     function push(address dst, uint wad) public {
573         transferFrom(msg.sender, dst, wad);
574     }
575     function pull(address src, uint wad) public {
576         transferFrom(src, msg.sender, wad);
577     }
578     function move(address src, address dst, uint wad) public {
579         transferFrom(src, dst, wad);
580     }
581 
582     function mint(uint wad) public {
583         mint(msg.sender, wad);
584     }
585     function burn(uint wad) public {
586         burn(msg.sender, wad);
587     }
588     function mint(address guy, uint wad) public auth stoppable {
589         _balances[guy] = add(_balances[guy], wad);
590         _supply = add(_supply, wad);
591         emit Mint(guy, wad);
592     }
593     function burn(address guy, uint wad) public auth stoppable {
594         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
595             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
596             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
597         }
598 
599         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
600         _balances[guy] = sub(_balances[guy], wad);
601         _supply = sub(_supply, wad);
602         emit Burn(guy, wad);
603     }
604 
605     // Optional token name
606     bytes32   public  name = "";
607 
608     function setName(bytes32 name_) public auth {
609         name = name_;
610     }
611 }
612 
613 ////// src/chief.sol
614 // chief.sol - select an authority by consensus
615 
616 // Copyright (C) 2017  DappHub, LLC
617 
618 // This program is free software: you can redistribute it and/or modify
619 // it under the terms of the GNU General Public License as published by
620 // the Free Software Foundation, either version 3 of the License, or
621 // (at your option) any later version.
622 
623 // This program is distributed in the hope that it will be useful,
624 // but WITHOUT ANY WARRANTY; without even the implied warranty of
625 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
626 // GNU General Public License for more details.
627 
628 // You should have received a copy of the GNU General Public License
629 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
630 
631 /* pragma solidity >=0.4.23; */
632 
633 /* import 'ds-token/token.sol'; */
634 /* import 'ds-roles/roles.sol'; */
635 /* import 'ds-thing/thing.sol'; */
636 
637 // The right way to use this contract is probably to mix it with some kind
638 // of `DSAuthority`, like with `ds-roles`.
639 //   SEE DSChief
640 contract DSChiefApprovals is DSThing {
641     mapping(bytes32=>address[]) public slates;
642     mapping(address=>bytes32) public votes;
643     mapping(address=>uint256) public approvals;
644     mapping(address=>uint256) public deposits;
645     DSToken public GOV; // voting token that gets locked up
646     DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms
647     address public hat; // the chieftain's hat
648 
649     uint256 public MAX_YAYS;
650 
651     event Etch(bytes32 indexed slate);
652 
653     // IOU constructed outside this contract reduces deployment costs significantly
654     // lock/free/vote are quite sensitive to token invariants. Caution is advised.
655     constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public
656     {
657         GOV = GOV_;
658         IOU = IOU_;
659         MAX_YAYS = MAX_YAYS_;
660     }
661 
662     function lock(uint wad)
663         public
664         note
665     {
666         GOV.pull(msg.sender, wad);
667         IOU.mint(msg.sender, wad);
668         deposits[msg.sender] = add(deposits[msg.sender], wad);
669         addWeight(wad, votes[msg.sender]);
670     }
671 
672     function free(uint wad)
673         public
674         note
675     {
676         deposits[msg.sender] = sub(deposits[msg.sender], wad);
677         subWeight(wad, votes[msg.sender]);
678         IOU.burn(msg.sender, wad);
679         GOV.push(msg.sender, wad);
680     }
681 
682     function etch(address[] memory yays)
683         public
684         note
685         returns (bytes32 slate)
686     {
687         require( yays.length <= MAX_YAYS );
688         requireByteOrderedSet(yays);
689 
690         bytes32 hash = keccak256(abi.encodePacked(yays));
691         slates[hash] = yays;
692         emit Etch(hash);
693         return hash;
694     }
695 
696     function vote(address[] memory yays) public returns (bytes32)
697         // note  both sub-calls note
698     {
699         bytes32 slate = etch(yays);
700         vote(slate);
701         return slate;
702     }
703 
704     function vote(bytes32 slate)
705         public
706         note
707     {
708         require(slates[slate].length > 0 || 
709             slate == 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470, "ds-chief-invalid-slate");
710         uint weight = deposits[msg.sender];
711         subWeight(weight, votes[msg.sender]);
712         votes[msg.sender] = slate;
713         addWeight(weight, votes[msg.sender]);
714     }
715 
716     // like `drop`/`swap` except simply "elect this address if it is higher than current hat"
717     function lift(address whom)
718         public
719         note
720     {
721         require(approvals[whom] > approvals[hat]);
722         hat = whom;
723     }
724 
725     function addWeight(uint weight, bytes32 slate)
726         internal
727     {
728         address[] storage yays = slates[slate];
729         for( uint i = 0; i < yays.length; i++) {
730             approvals[yays[i]] = add(approvals[yays[i]], weight);
731         }
732     }
733 
734     function subWeight(uint weight, bytes32 slate)
735         internal
736     {
737         address[] storage yays = slates[slate];
738         for( uint i = 0; i < yays.length; i++) {
739             approvals[yays[i]] = sub(approvals[yays[i]], weight);
740         }
741     }
742 
743     // Throws unless the array of addresses is a ordered set.
744     function requireByteOrderedSet(address[] memory yays)
745         internal
746         pure
747     {
748         if( yays.length == 0 || yays.length == 1 ) {
749             return;
750         }
751         for( uint i = 0; i < yays.length - 1; i++ ) {
752             // strict inequality ensures both ordering and uniqueness
753             require(uint(yays[i]) < uint(yays[i+1]));
754         }
755     }
756 }
757 
758 
759 // `hat` address is unique root user (has every role) and the
760 // unique owner of role 0 (typically 'sys' or 'internal')
761 contract DSChief is DSRoles, DSChiefApprovals {
762 
763     constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)
764              DSChiefApprovals (GOV, IOU, MAX_YAYS)
765         public
766     {
767         authority = this;
768         owner = address(0);
769     }
770 
771     function setOwner(address owner_) public {
772         owner_;
773         revert();
774     }
775 
776     function setAuthority(DSAuthority authority_) public {
777         authority_;
778         revert();
779     }
780 
781     function isUserRoot(address who)
782         public view
783         returns (bool)
784     {
785         return (who == hat);
786     }
787     function setRootUser(address who, bool enabled) public {
788         who; enabled;
789         revert();
790     }
791 }
792 
793 contract DSChiefFab {
794     function newChief(DSToken gov, uint MAX_YAYS) public returns (DSChief chief) {
795         DSToken iou = new DSToken('IOU');
796         chief = new DSChief(gov, iou, MAX_YAYS);
797         iou.setOwner(address(chief));
798     }
799 }