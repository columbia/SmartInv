1 // hevm: flattened sources of src/VoteProxyFactory.sol
2 pragma solidity ^0.4.24;
3 
4 ////// lib/ds-token/lib/ds-stop/lib/ds-auth/src/auth.sol
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
18 /* pragma solidity ^0.4.23; */
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
53         emit LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
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
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 ////// lib/ds-chief/lib/ds-roles/src/roles.sol
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
92 /* pragma solidity ^0.4.13; */
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
206 ////// lib/ds-token/lib/ds-math/src/math.sol
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
222 /* pragma solidity ^0.4.13; */
223 
224 contract DSMath {
225     function add(uint x, uint y) internal pure returns (uint z) {
226         require((z = x + y) >= x);
227     }
228     function sub(uint x, uint y) internal pure returns (uint z) {
229         require((z = x - y) <= x);
230     }
231     function mul(uint x, uint y) internal pure returns (uint z) {
232         require(y == 0 || (z = x * y) / y == x);
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
292 ////// lib/ds-token/lib/ds-stop/lib/ds-note/src/note.sol
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
308 /* pragma solidity ^0.4.23; */
309 
310 contract DSNote {
311     event LogNote(
312         bytes4   indexed  sig,
313         address  indexed  guy,
314         bytes32  indexed  foo,
315         bytes32  indexed  bar,
316         uint              wad,
317         bytes             fax
318     ) anonymous;
319 
320     modifier note {
321         bytes32 foo;
322         bytes32 bar;
323 
324         assembly {
325             foo := calldataload(4)
326             bar := calldataload(36)
327         }
328 
329         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
330 
331         _;
332     }
333 }
334 
335 ////// lib/ds-chief/lib/ds-thing/src/thing.sol
336 // thing.sol - `auth` with handy mixins. your things should be DSThings
337 
338 // Copyright (C) 2017  DappHub, LLC
339 
340 // This program is free software: you can redistribute it and/or modify
341 // it under the terms of the GNU General Public License as published by
342 // the Free Software Foundation, either version 3 of the License, or
343 // (at your option) any later version.
344 
345 // This program is distributed in the hope that it will be useful,
346 // but WITHOUT ANY WARRANTY; without even the implied warranty of
347 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
348 // GNU General Public License for more details.
349 
350 // You should have received a copy of the GNU General Public License
351 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
352 
353 /* pragma solidity ^0.4.23; */
354 
355 /* import 'ds-auth/auth.sol'; */
356 /* import 'ds-note/note.sol'; */
357 /* import 'ds-math/math.sol'; */
358 
359 contract DSThing is DSAuth, DSNote, DSMath {
360 
361     function S(string s) internal pure returns (bytes4) {
362         return bytes4(keccak256(abi.encodePacked(s)));
363     }
364 
365 }
366 
367 ////// lib/ds-token/lib/ds-stop/src/stop.sol
368 /// stop.sol -- mixin for enable/disable functionality
369 
370 // Copyright (C) 2017  DappHub, LLC
371 
372 // This program is free software: you can redistribute it and/or modify
373 // it under the terms of the GNU General Public License as published by
374 // the Free Software Foundation, either version 3 of the License, or
375 // (at your option) any later version.
376 
377 // This program is distributed in the hope that it will be useful,
378 // but WITHOUT ANY WARRANTY; without even the implied warranty of
379 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
380 // GNU General Public License for more details.
381 
382 // You should have received a copy of the GNU General Public License
383 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
384 
385 /* pragma solidity ^0.4.23; */
386 
387 /* import "ds-auth/auth.sol"; */
388 /* import "ds-note/note.sol"; */
389 
390 contract DSStop is DSNote, DSAuth {
391 
392     bool public stopped;
393 
394     modifier stoppable {
395         require(!stopped);
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
416 /* pragma solidity ^0.4.8; */
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
453 /* pragma solidity ^0.4.23; */
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
487             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
488         }
489 
490         _balances[src] = sub(_balances[src], wad);
491         _balances[dst] = add(_balances[dst], wad);
492 
493         emit Transfer(src, dst, wad);
494 
495         return true;
496     }
497 
498     function approve(address guy, uint wad) public returns (bool) {
499         _approvals[msg.sender][guy] = wad;
500 
501         emit Approval(msg.sender, guy, wad);
502 
503         return true;
504     }
505 }
506 
507 ////// lib/ds-token/src/token.sol
508 /// token.sol -- ERC20 implementation with minting and burning
509 
510 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
511 
512 // This program is free software: you can redistribute it and/or modify
513 // it under the terms of the GNU General Public License as published by
514 // the Free Software Foundation, either version 3 of the License, or
515 // (at your option) any later version.
516 
517 // This program is distributed in the hope that it will be useful,
518 // but WITHOUT ANY WARRANTY; without even the implied warranty of
519 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
520 // GNU General Public License for more details.
521 
522 // You should have received a copy of the GNU General Public License
523 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
524 
525 /* pragma solidity ^0.4.23; */
526 
527 /* import "ds-stop/stop.sol"; */
528 
529 /* import "./base.sol"; */
530 
531 contract DSToken is DSTokenBase(0), DSStop {
532 
533     bytes32  public  symbol;
534     uint256  public  decimals = 18; // standard token precision. override to customize
535 
536     constructor(bytes32 symbol_) public {
537         symbol = symbol_;
538     }
539 
540     event Mint(address indexed guy, uint wad);
541     event Burn(address indexed guy, uint wad);
542 
543     function approve(address guy) public stoppable returns (bool) {
544         return super.approve(guy, uint(-1));
545     }
546 
547     function approve(address guy, uint wad) public stoppable returns (bool) {
548         return super.approve(guy, wad);
549     }
550 
551     function transferFrom(address src, address dst, uint wad)
552         public
553         stoppable
554         returns (bool)
555     {
556         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
557             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
558         }
559 
560         _balances[src] = sub(_balances[src], wad);
561         _balances[dst] = add(_balances[dst], wad);
562 
563         emit Transfer(src, dst, wad);
564 
565         return true;
566     }
567 
568     function push(address dst, uint wad) public {
569         transferFrom(msg.sender, dst, wad);
570     }
571     function pull(address src, uint wad) public {
572         transferFrom(src, msg.sender, wad);
573     }
574     function move(address src, address dst, uint wad) public {
575         transferFrom(src, dst, wad);
576     }
577 
578     function mint(uint wad) public {
579         mint(msg.sender, wad);
580     }
581     function burn(uint wad) public {
582         burn(msg.sender, wad);
583     }
584     function mint(address guy, uint wad) public auth stoppable {
585         _balances[guy] = add(_balances[guy], wad);
586         _supply = add(_supply, wad);
587         emit Mint(guy, wad);
588     }
589     function burn(address guy, uint wad) public auth stoppable {
590         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
591             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
592         }
593 
594         _balances[guy] = sub(_balances[guy], wad);
595         _supply = sub(_supply, wad);
596         emit Burn(guy, wad);
597     }
598 
599     // Optional token name
600     bytes32   public  name = "";
601 
602     function setName(bytes32 name_) public auth {
603         name = name_;
604     }
605 }
606 
607 ////// lib/ds-chief/src/chief.sol
608 // chief.sol - select an authority by consensus
609 
610 // Copyright (C) 2017  DappHub, LLC
611 
612 // This program is free software: you can redistribute it and/or modify
613 // it under the terms of the GNU General Public License as published by
614 // the Free Software Foundation, either version 3 of the License, or
615 // (at your option) any later version.
616 
617 // This program is distributed in the hope that it will be useful,
618 // but WITHOUT ANY WARRANTY; without even the implied warranty of
619 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
620 // GNU General Public License for more details.
621 
622 // You should have received a copy of the GNU General Public License
623 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
624 
625 /* pragma solidity ^0.4.23; */
626 
627 /* import 'ds-token/token.sol'; */
628 /* import 'ds-roles/roles.sol'; */
629 /* import 'ds-thing/thing.sol'; */
630 
631 // The right way to use this contract is probably to mix it with some kind
632 // of `DSAuthority`, like with `ds-roles`.
633 //   SEE DSChief
634 contract DSChiefApprovals is DSThing {
635     mapping(bytes32=>address[]) public slates;
636     mapping(address=>bytes32) public votes;
637     mapping(address=>uint256) public approvals;
638     mapping(address=>uint256) public deposits;
639     DSToken public GOV; // voting token that gets locked up
640     DSToken public IOU; // non-voting representation of a token, for e.g. secondary voting mechanisms
641     address public hat; // the chieftain's hat
642 
643     uint256 public MAX_YAYS;
644 
645     event Etch(bytes32 indexed slate);
646 
647     // IOU constructed outside this contract reduces deployment costs significantly
648     // lock/free/vote are quite sensitive to token invariants. Caution is advised.
649     constructor(DSToken GOV_, DSToken IOU_, uint MAX_YAYS_) public
650     {
651         GOV = GOV_;
652         IOU = IOU_;
653         MAX_YAYS = MAX_YAYS_;
654     }
655 
656     function lock(uint wad)
657         public
658         note
659     {
660         GOV.pull(msg.sender, wad);
661         IOU.mint(msg.sender, wad);
662         deposits[msg.sender] = add(deposits[msg.sender], wad);
663         addWeight(wad, votes[msg.sender]);
664     }
665 
666     function free(uint wad)
667         public
668         note
669     {
670         deposits[msg.sender] = sub(deposits[msg.sender], wad);
671         subWeight(wad, votes[msg.sender]);
672         IOU.burn(msg.sender, wad);
673         GOV.push(msg.sender, wad);
674     }
675 
676     function etch(address[] yays)
677         public
678         note
679         returns (bytes32 slate)
680     {
681         require( yays.length <= MAX_YAYS );
682         requireByteOrderedSet(yays);
683 
684         bytes32 hash = keccak256(abi.encodePacked(yays));
685         slates[hash] = yays;
686         emit Etch(hash);
687         return hash;
688     }
689 
690     function vote(address[] yays) public returns (bytes32)
691         // note  both sub-calls note
692     {
693         bytes32 slate = etch(yays);
694         vote(slate);
695         return slate;
696     }
697 
698     function vote(bytes32 slate)
699         public
700         note
701     {
702         uint weight = deposits[msg.sender];
703         subWeight(weight, votes[msg.sender]);
704         votes[msg.sender] = slate;
705         addWeight(weight, votes[msg.sender]);
706     }
707 
708     // like `drop`/`swap` except simply "elect this address if it is higher than current hat"
709     function lift(address whom)
710         public
711         note
712     {
713         require(approvals[whom] > approvals[hat]);
714         hat = whom;
715     }
716 
717     function addWeight(uint weight, bytes32 slate)
718         internal
719     {
720         address[] storage yays = slates[slate];
721         for( uint i = 0; i < yays.length; i++) {
722             approvals[yays[i]] = add(approvals[yays[i]], weight);
723         }
724     }
725 
726     function subWeight(uint weight, bytes32 slate)
727         internal
728     {
729         address[] storage yays = slates[slate];
730         for( uint i = 0; i < yays.length; i++) {
731             approvals[yays[i]] = sub(approvals[yays[i]], weight);
732         }
733     }
734 
735     // Throws unless the array of addresses is a ordered set.
736     function requireByteOrderedSet(address[] yays)
737         internal
738         pure
739     {
740         if( yays.length == 0 || yays.length == 1 ) {
741             return;
742         }
743         for( uint i = 0; i < yays.length - 1; i++ ) {
744             // strict inequality ensures both ordering and uniqueness
745             require(uint(bytes32(yays[i])) < uint256(bytes32(yays[i+1])));
746         }
747     }
748 }
749 
750 
751 // `hat` address is unique root user (has every role) and the
752 // unique owner of role 0 (typically 'sys' or 'internal')
753 contract DSChief is DSRoles, DSChiefApprovals {
754 
755     constructor(DSToken GOV, DSToken IOU, uint MAX_YAYS)
756              DSChiefApprovals (GOV, IOU, MAX_YAYS)
757         public
758     {
759         authority = this;
760         owner = 0;
761     }
762 
763     function setOwner(address owner_) public {
764         owner_;
765         revert();
766     }
767 
768     function setAuthority(DSAuthority authority_) public {
769         authority_;
770         revert();
771     }
772 
773     function isUserRoot(address who)
774         public
775         constant
776         returns (bool)
777     {
778         return (who == hat);
779     }
780     function setRootUser(address who, bool enabled) public {
781         who; enabled;
782         revert();
783     }
784 }
785 
786 contract DSChiefFab {
787     function newChief(DSToken gov, uint MAX_YAYS) public returns (DSChief chief) {
788         DSToken iou = new DSToken('IOU');
789         chief = new DSChief(gov, iou, MAX_YAYS);
790         iou.setOwner(chief);
791     }
792 }
793 
794 ////// src/VoteProxy.sol
795 // VoteProxy - vote w/ a hot or cold wallet using a proxy identity
796 /* pragma solidity ^0.4.24; */
797 
798 /* import "ds-token/token.sol"; */
799 /* import "ds-chief/chief.sol"; */
800 
801 contract VoteProxy {
802     address public cold;
803     address public hot;
804     DSToken public gov;
805     DSToken public iou;
806     DSChief public chief;
807 
808     constructor(DSChief _chief, address _cold, address _hot) public {
809         chief = _chief;
810         cold = _cold;
811         hot = _hot;
812         
813         gov = chief.GOV();
814         iou = chief.IOU();
815         gov.approve(chief, uint256(-1));
816         iou.approve(chief, uint256(-1));
817     }
818 
819     modifier auth() {
820         require(msg.sender == hot || msg.sender == cold, "Sender must be a Cold or Hot Wallet");
821         _;
822     }
823     
824     function lock(uint256 wad) public auth {
825         gov.pull(cold, wad);   // mkr from cold
826         chief.lock(wad);       // mkr out, ious in
827     }
828 
829     function free(uint256 wad) public auth {
830         chief.free(wad);       // ious out, mkr in
831         gov.push(cold, wad);   // mkr to cold
832     }
833 
834     function freeAll() public auth {
835         chief.free(chief.deposits(this));            
836         gov.push(cold, gov.balanceOf(this)); 
837     }
838 
839     function vote(address[] yays) public auth returns (bytes32) {
840         return chief.vote(yays);
841     }
842 
843     function vote(bytes32 slate) public auth {
844         chief.vote(slate);
845     }
846 }
847 
848 ////// src/VoteProxyFactory.sol
849 // VoteProxyFactory - create and keep record of proxy identities
850 /* pragma solidity ^0.4.24; */
851 
852 /* import "./VoteProxy.sol"; */
853 
854 contract VoteProxyFactory {
855     DSChief public chief;
856     mapping(address => VoteProxy) public hotMap;
857     mapping(address => VoteProxy) public coldMap;
858     mapping(address => address) public linkRequests;
859 
860     event LinkRequested(address indexed cold, address indexed hot);
861     event LinkConfirmed(address indexed cold, address indexed hot, address indexed voteProxy);
862     
863     constructor(DSChief chief_) public { chief = chief_; }
864 
865     function hasProxy(address guy) public view returns (bool) {
866         return (coldMap[guy] != address(0) || hotMap[guy] != address(0));
867     }
868 
869     function initiateLink(address hot) public {
870         require(!hasProxy(msg.sender), "Cold wallet is already linked to another Vote Proxy");
871         require(!hasProxy(hot), "Hot wallet is already linked to another Vote Proxy");
872 
873         linkRequests[msg.sender] = hot;
874         emit LinkRequested(msg.sender, hot);
875     }
876 
877     function approveLink(address cold) public returns (VoteProxy voteProxy) {
878         require(linkRequests[cold] == msg.sender, "Cold wallet must initiate a link first");
879         require(!hasProxy(msg.sender), "Hot wallet is already linked to another Vote Proxy");
880 
881         voteProxy = new VoteProxy(chief, cold, msg.sender);
882         hotMap[msg.sender] = voteProxy;
883         coldMap[cold] = voteProxy;
884         delete linkRequests[cold];
885         emit LinkConfirmed(cold, msg.sender, voteProxy);
886     }
887 
888     function breakLink() public {
889         require(hasProxy(msg.sender), "No VoteProxy found for this sender");
890 
891         VoteProxy voteProxy = coldMap[msg.sender] != address(0)
892             ? coldMap[msg.sender] : hotMap[msg.sender];
893         address cold = voteProxy.cold();
894         address hot = voteProxy.hot();
895         require(chief.deposits(voteProxy) == 0, "VoteProxy still has funds attached to it");
896 
897         delete coldMap[cold];
898         delete hotMap[hot];
899     }
900 
901     function linkSelf() public returns (VoteProxy voteProxy) {
902         initiateLink(msg.sender);
903         return approveLink(msg.sender);
904     }
905 }