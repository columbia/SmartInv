1 // hevm: flattened sources of src/fab.sol
2 pragma solidity ^0.4.18;
3 
4 ////// lib/ds-guard/lib/ds-auth/src/auth.sol
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
18 /* pragma solidity ^0.4.13; */
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
35     function DSAuth() public {
36         owner = msg.sender;
37         LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         LogSetAuthority(authority);
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
74 ////// lib/ds-guard/src/guard.sol
75 // guard.sol -- simple whitelist implementation of DSAuthority
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
94 /* import "ds-auth/auth.sol"; */
95 
96 contract DSGuardEvents {
97     event LogPermit(
98         bytes32 indexed src,
99         bytes32 indexed dst,
100         bytes32 indexed sig
101     );
102 
103     event LogForbid(
104         bytes32 indexed src,
105         bytes32 indexed dst,
106         bytes32 indexed sig
107     );
108 }
109 
110 contract DSGuard is DSAuth, DSAuthority, DSGuardEvents {
111     bytes32 constant public ANY = bytes32(uint(-1));
112 
113     mapping (bytes32 => mapping (bytes32 => mapping (bytes32 => bool))) acl;
114 
115     function canCall(
116         address src_, address dst_, bytes4 sig
117     ) public view returns (bool) {
118         var src = bytes32(src_);
119         var dst = bytes32(dst_);
120 
121         return acl[src][dst][sig]
122             || acl[src][dst][ANY]
123             || acl[src][ANY][sig]
124             || acl[src][ANY][ANY]
125             || acl[ANY][dst][sig]
126             || acl[ANY][dst][ANY]
127             || acl[ANY][ANY][sig]
128             || acl[ANY][ANY][ANY];
129     }
130 
131     function permit(bytes32 src, bytes32 dst, bytes32 sig) public auth {
132         acl[src][dst][sig] = true;
133         LogPermit(src, dst, sig);
134     }
135 
136     function forbid(bytes32 src, bytes32 dst, bytes32 sig) public auth {
137         acl[src][dst][sig] = false;
138         LogForbid(src, dst, sig);
139     }
140 
141     function permit(address src, address dst, bytes32 sig) public {
142         permit(bytes32(src), bytes32(dst), sig);
143     }
144     function forbid(address src, address dst, bytes32 sig) public {
145         forbid(bytes32(src), bytes32(dst), sig);
146     }
147 
148 }
149 
150 contract DSGuardFactory {
151     mapping (address => bool)  public  isGuard;
152 
153     function newGuard() public returns (DSGuard guard) {
154         guard = new DSGuard();
155         guard.setOwner(msg.sender);
156         isGuard[guard] = true;
157     }
158 }
159 
160 ////// lib/ds-roles/src/roles.sol
161 // roles.sol - roled based authentication
162 
163 // Copyright (C) 2017  DappHub, LLC
164 
165 // This program is free software: you can redistribute it and/or modify
166 // it under the terms of the GNU General Public License as published by
167 // the Free Software Foundation, either version 3 of the License, or
168 // (at your option) any later version.
169 
170 // This program is distributed in the hope that it will be useful,
171 // but WITHOUT ANY WARRANTY; without even the implied warranty of
172 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
173 // GNU General Public License for more details.
174 
175 // You should have received a copy of the GNU General Public License
176 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
177 
178 /* pragma solidity ^0.4.13; */
179 
180 /* import 'ds-auth/auth.sol'; */
181 
182 contract DSRoles is DSAuth, DSAuthority
183 {
184     mapping(address=>bool) _root_users;
185     mapping(address=>bytes32) _user_roles;
186     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
187     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
188 
189     function getUserRoles(address who)
190         public
191         view
192         returns (bytes32)
193     {
194         return _user_roles[who];
195     }
196 
197     function getCapabilityRoles(address code, bytes4 sig)
198         public
199         view
200         returns (bytes32)
201     {
202         return _capability_roles[code][sig];
203     }
204 
205     function isUserRoot(address who)
206         public
207         view
208         returns (bool)
209     {
210         return _root_users[who];
211     }
212 
213     function isCapabilityPublic(address code, bytes4 sig)
214         public
215         view
216         returns (bool)
217     {
218         return _public_capabilities[code][sig];
219     }
220 
221     function hasUserRole(address who, uint8 role)
222         public
223         view
224         returns (bool)
225     {
226         bytes32 roles = getUserRoles(who);
227         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
228         return bytes32(0) != roles & shifted;
229     }
230 
231     function canCall(address caller, address code, bytes4 sig)
232         public
233         view
234         returns (bool)
235     {
236         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
237             return true;
238         } else {
239             var has_roles = getUserRoles(caller);
240             var needs_one_of = getCapabilityRoles(code, sig);
241             return bytes32(0) != has_roles & needs_one_of;
242         }
243     }
244 
245     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
246         return (input ^ bytes32(uint(-1)));
247     }
248 
249     function setRootUser(address who, bool enabled)
250         public
251         auth
252     {
253         _root_users[who] = enabled;
254     }
255 
256     function setUserRole(address who, uint8 role, bool enabled)
257         public
258         auth
259     {
260         var last_roles = _user_roles[who];
261         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
262         if( enabled ) {
263             _user_roles[who] = last_roles | shifted;
264         } else {
265             _user_roles[who] = last_roles & BITNOT(shifted);
266         }
267     }
268 
269     function setPublicCapability(address code, bytes4 sig, bool enabled)
270         public
271         auth
272     {
273         _public_capabilities[code][sig] = enabled;
274     }
275 
276     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
277         public
278         auth
279     {
280         var last_roles = _capability_roles[code][sig];
281         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
282         if( enabled ) {
283             _capability_roles[code][sig] = last_roles | shifted;
284         } else {
285             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
286         }
287 
288     }
289 
290 }
291 
292 ////// lib/ds-spell/lib/ds-note/src/note.sol
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
308 /* pragma solidity ^0.4.13; */
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
329         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
330 
331         _;
332     }
333 }
334 
335 ////// lib/ds-thing/lib/ds-math/src/math.sol
336 /// math.sol -- mixin for inline numerical wizardry
337 
338 // This program is free software: you can redistribute it and/or modify
339 // it under the terms of the GNU General Public License as published by
340 // the Free Software Foundation, either version 3 of the License, or
341 // (at your option) any later version.
342 
343 // This program is distributed in the hope that it will be useful,
344 // but WITHOUT ANY WARRANTY; without even the implied warranty of
345 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
346 // GNU General Public License for more details.
347 
348 // You should have received a copy of the GNU General Public License
349 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
350 
351 /* pragma solidity ^0.4.13; */
352 
353 contract DSMath {
354     function add(uint x, uint y) internal pure returns (uint z) {
355         require((z = x + y) >= x);
356     }
357     function sub(uint x, uint y) internal pure returns (uint z) {
358         require((z = x - y) <= x);
359     }
360     function mul(uint x, uint y) internal pure returns (uint z) {
361         require(y == 0 || (z = x * y) / y == x);
362     }
363 
364     function min(uint x, uint y) internal pure returns (uint z) {
365         return x <= y ? x : y;
366     }
367     function max(uint x, uint y) internal pure returns (uint z) {
368         return x >= y ? x : y;
369     }
370     function imin(int x, int y) internal pure returns (int z) {
371         return x <= y ? x : y;
372     }
373     function imax(int x, int y) internal pure returns (int z) {
374         return x >= y ? x : y;
375     }
376 
377     uint constant WAD = 10 ** 18;
378     uint constant RAY = 10 ** 27;
379 
380     function wmul(uint x, uint y) internal pure returns (uint z) {
381         z = add(mul(x, y), WAD / 2) / WAD;
382     }
383     function rmul(uint x, uint y) internal pure returns (uint z) {
384         z = add(mul(x, y), RAY / 2) / RAY;
385     }
386     function wdiv(uint x, uint y) internal pure returns (uint z) {
387         z = add(mul(x, WAD), y / 2) / y;
388     }
389     function rdiv(uint x, uint y) internal pure returns (uint z) {
390         z = add(mul(x, RAY), y / 2) / y;
391     }
392 
393     // This famous algorithm is called "exponentiation by squaring"
394     // and calculates x^n with x as fixed-point and n as regular unsigned.
395     //
396     // It's O(log n), instead of O(n) for naive repeated multiplication.
397     //
398     // These facts are why it works:
399     //
400     //  If n is even, then x^n = (x^2)^(n/2).
401     //  If n is odd,  then x^n = x * x^(n-1),
402     //   and applying the equation for even x gives
403     //    x^n = x * (x^2)^((n-1) / 2).
404     //
405     //  Also, EVM division is flooring and
406     //    floor[(n-1) / 2] = floor[n / 2].
407     //
408     function rpow(uint x, uint n) internal pure returns (uint z) {
409         z = n % 2 != 0 ? x : RAY;
410 
411         for (n /= 2; n != 0; n /= 2) {
412             x = rmul(x, x);
413 
414             if (n % 2 != 0) {
415                 z = rmul(z, x);
416             }
417         }
418     }
419 }
420 
421 ////// lib/ds-thing/src/thing.sol
422 // thing.sol - `auth` with handy mixins. your things should be DSThings
423 
424 // Copyright (C) 2017  DappHub, LLC
425 
426 // This program is free software: you can redistribute it and/or modify
427 // it under the terms of the GNU General Public License as published by
428 // the Free Software Foundation, either version 3 of the License, or
429 // (at your option) any later version.
430 
431 // This program is distributed in the hope that it will be useful,
432 // but WITHOUT ANY WARRANTY; without even the implied warranty of
433 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
434 // GNU General Public License for more details.
435 
436 // You should have received a copy of the GNU General Public License
437 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
438 
439 /* pragma solidity ^0.4.13; */
440 
441 /* import 'ds-auth/auth.sol'; */
442 /* import 'ds-note/note.sol'; */
443 /* import 'ds-math/math.sol'; */
444 
445 contract DSThing is DSAuth, DSNote, DSMath {
446 
447     function S(string s) internal pure returns (bytes4) {
448         return bytes4(keccak256(s));
449     }
450 
451 }
452 
453 ////// lib/ds-token/lib/ds-stop/src/stop.sol
454 /// stop.sol -- mixin for enable/disable functionality
455 
456 // Copyright (C) 2017  DappHub, LLC
457 
458 // This program is free software: you can redistribute it and/or modify
459 // it under the terms of the GNU General Public License as published by
460 // the Free Software Foundation, either version 3 of the License, or
461 // (at your option) any later version.
462 
463 // This program is distributed in the hope that it will be useful,
464 // but WITHOUT ANY WARRANTY; without even the implied warranty of
465 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
466 // GNU General Public License for more details.
467 
468 // You should have received a copy of the GNU General Public License
469 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
470 
471 /* pragma solidity ^0.4.13; */
472 
473 /* import "ds-auth/auth.sol"; */
474 /* import "ds-note/note.sol"; */
475 
476 contract DSStop is DSNote, DSAuth {
477 
478     bool public stopped;
479 
480     modifier stoppable {
481         require(!stopped);
482         _;
483     }
484     function stop() public auth note {
485         stopped = true;
486     }
487     function start() public auth note {
488         stopped = false;
489     }
490 
491 }
492 
493 ////// lib/ds-token/lib/erc20/src/erc20.sol
494 /// erc20.sol -- API for the ERC20 token standard
495 
496 // See <https://github.com/ethereum/EIPs/issues/20>.
497 
498 // This file likely does not meet the threshold of originality
499 // required for copyright to apply.  As a result, this is free and
500 // unencumbered software belonging to the public domain.
501 
502 /* pragma solidity ^0.4.8; */
503 
504 contract ERC20Events {
505     event Approval(address indexed src, address indexed guy, uint wad);
506     event Transfer(address indexed src, address indexed dst, uint wad);
507 }
508 
509 contract ERC20 is ERC20Events {
510     function totalSupply() public view returns (uint);
511     function balanceOf(address guy) public view returns (uint);
512     function allowance(address src, address guy) public view returns (uint);
513 
514     function approve(address guy, uint wad) public returns (bool);
515     function transfer(address dst, uint wad) public returns (bool);
516     function transferFrom(
517         address src, address dst, uint wad
518     ) public returns (bool);
519 }
520 
521 ////// lib/ds-token/src/base.sol
522 /// base.sol -- basic ERC20 implementation
523 
524 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
525 
526 // This program is free software: you can redistribute it and/or modify
527 // it under the terms of the GNU General Public License as published by
528 // the Free Software Foundation, either version 3 of the License, or
529 // (at your option) any later version.
530 
531 // This program is distributed in the hope that it will be useful,
532 // but WITHOUT ANY WARRANTY; without even the implied warranty of
533 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
534 // GNU General Public License for more details.
535 
536 // You should have received a copy of the GNU General Public License
537 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
538 
539 /* pragma solidity ^0.4.13; */
540 
541 /* import "erc20/erc20.sol"; */
542 /* import "ds-math/math.sol"; */
543 
544 contract DSTokenBase is ERC20, DSMath {
545     uint256                                            _supply;
546     mapping (address => uint256)                       _balances;
547     mapping (address => mapping (address => uint256))  _approvals;
548 
549     function DSTokenBase(uint supply) public {
550         _balances[msg.sender] = supply;
551         _supply = supply;
552     }
553 
554     function totalSupply() public view returns (uint) {
555         return _supply;
556     }
557     function balanceOf(address src) public view returns (uint) {
558         return _balances[src];
559     }
560     function allowance(address src, address guy) public view returns (uint) {
561         return _approvals[src][guy];
562     }
563 
564     function transfer(address dst, uint wad) public returns (bool) {
565         return transferFrom(msg.sender, dst, wad);
566     }
567 
568     function transferFrom(address src, address dst, uint wad)
569         public
570         returns (bool)
571     {
572         if (src != msg.sender) {
573             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
574         }
575 
576         _balances[src] = sub(_balances[src], wad);
577         _balances[dst] = add(_balances[dst], wad);
578 
579         Transfer(src, dst, wad);
580 
581         return true;
582     }
583 
584     function approve(address guy, uint wad) public returns (bool) {
585         _approvals[msg.sender][guy] = wad;
586 
587         Approval(msg.sender, guy, wad);
588 
589         return true;
590     }
591 }
592 
593 ////// lib/ds-token/src/token.sol
594 /// token.sol -- ERC20 implementation with minting and burning
595 
596 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
597 
598 // This program is free software: you can redistribute it and/or modify
599 // it under the terms of the GNU General Public License as published by
600 // the Free Software Foundation, either version 3 of the License, or
601 // (at your option) any later version.
602 
603 // This program is distributed in the hope that it will be useful,
604 // but WITHOUT ANY WARRANTY; without even the implied warranty of
605 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
606 // GNU General Public License for more details.
607 
608 // You should have received a copy of the GNU General Public License
609 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
610 
611 /* pragma solidity ^0.4.13; */
612 
613 /* import "ds-stop/stop.sol"; */
614 
615 /* import "./base.sol"; */
616 
617 contract DSToken is DSTokenBase(0), DSStop {
618 
619     bytes32  public  symbol;
620     uint256  public  decimals = 18; // standard token precision. override to customize
621 
622     function DSToken(bytes32 symbol_) public {
623         symbol = symbol_;
624     }
625 
626     event Mint(address indexed guy, uint wad);
627     event Burn(address indexed guy, uint wad);
628 
629     function approve(address guy) public stoppable returns (bool) {
630         return super.approve(guy, uint(-1));
631     }
632 
633     function approve(address guy, uint wad) public stoppable returns (bool) {
634         return super.approve(guy, wad);
635     }
636 
637     function transferFrom(address src, address dst, uint wad)
638         public
639         stoppable
640         returns (bool)
641     {
642         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
643             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
644         }
645 
646         _balances[src] = sub(_balances[src], wad);
647         _balances[dst] = add(_balances[dst], wad);
648 
649         Transfer(src, dst, wad);
650 
651         return true;
652     }
653 
654     function push(address dst, uint wad) public {
655         transferFrom(msg.sender, dst, wad);
656     }
657     function pull(address src, uint wad) public {
658         transferFrom(src, msg.sender, wad);
659     }
660     function move(address src, address dst, uint wad) public {
661         transferFrom(src, dst, wad);
662     }
663 
664     function mint(uint wad) public {
665         mint(msg.sender, wad);
666     }
667     function burn(uint wad) public {
668         burn(msg.sender, wad);
669     }
670     function mint(address guy, uint wad) public auth stoppable {
671         _balances[guy] = add(_balances[guy], wad);
672         _supply = add(_supply, wad);
673         Mint(guy, wad);
674     }
675     function burn(address guy, uint wad) public auth stoppable {
676         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
677             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
678         }
679 
680         _balances[guy] = sub(_balances[guy], wad);
681         _supply = sub(_supply, wad);
682         Burn(guy, wad);
683     }
684 
685     // Optional token name
686     bytes32   public  name = "";
687 
688     function setName(bytes32 name_) public auth {
689         name = name_;
690     }
691 }
692 
693 ////// lib/ds-value/src/value.sol
694 /// value.sol - a value is a simple thing, it can be get and set
695 
696 // Copyright (C) 2017  DappHub, LLC
697 
698 // This program is free software: you can redistribute it and/or modify
699 // it under the terms of the GNU General Public License as published by
700 // the Free Software Foundation, either version 3 of the License, or
701 // (at your option) any later version.
702 
703 // This program is distributed in the hope that it will be useful,
704 // but WITHOUT ANY WARRANTY; without even the implied warranty of
705 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
706 // GNU General Public License for more details.
707 
708 // You should have received a copy of the GNU General Public License
709 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
710 
711 /* pragma solidity ^0.4.13; */
712 
713 /* import 'ds-thing/thing.sol'; */
714 
715 contract DSValue is DSThing {
716     bool    has;
717     bytes32 val;
718     function peek() public view returns (bytes32, bool) {
719         return (val,has);
720     }
721     function read() public view returns (bytes32) {
722         var (wut, haz) = peek();
723         assert(haz);
724         return wut;
725     }
726     function poke(bytes32 wut) public note auth {
727         val = wut;
728         has = true;
729     }
730     function void() public note auth {  // unset the value
731         has = false;
732     }
733 }
734 
735 ////// src/vox.sol
736 /// vox.sol -- target price feed
737 
738 // Copyright (C) 2016, 2017  Nikolai Mushegian <nikolai@dapphub.com>
739 // Copyright (C) 2016, 2017  Daniel Brockman <daniel@dapphub.com>
740 // Copyright (C) 2017        Rain Break <rainbreak@riseup.net>
741 
742 // This program is free software: you can redistribute it and/or modify
743 // it under the terms of the GNU General Public License as published by
744 // the Free Software Foundation, either version 3 of the License, or
745 // (at your option) any later version.
746 
747 // This program is distributed in the hope that it will be useful,
748 // but WITHOUT ANY WARRANTY; without even the implied warranty of
749 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
750 // GNU General Public License for more details.
751 
752 // You should have received a copy of the GNU General Public License
753 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
754 
755 /* pragma solidity ^0.4.18; */
756 
757 /* import "ds-thing/thing.sol"; */
758 
759 contract SaiVox is DSThing {
760     uint256  _par;
761     uint256  _way;
762 
763     uint256  public  fix;
764     uint256  public  how;
765     uint256  public  tau;
766 
767     function SaiVox(uint par_) public {
768         _par = fix = par_;
769         _way = RAY;
770         tau  = era();
771     }
772 
773     function era() public view returns (uint) {
774         return block.timestamp;
775     }
776 
777     function mold(bytes32 param, uint val) public note auth {
778         if (param == 'way') _way = val;
779     }
780 
781     // Dai Target Price (ref per dai)
782     function par() public returns (uint) {
783         prod();
784         return _par;
785     }
786     function way() public returns (uint) {
787         prod();
788         return _way;
789     }
790 
791     function tell(uint256 ray) public note auth {
792         fix = ray;
793     }
794     function tune(uint256 ray) public note auth {
795         how = ray;
796     }
797 
798     function prod() public note {
799         var age = era() - tau;
800         if (age == 0) return;  // optimised
801         tau = era();
802 
803         if (_way != RAY) _par = rmul(_par, rpow(_way, age));  // optimised
804 
805         if (how == 0) return;  // optimised
806         var wag = int128(how * age);
807         _way = inj(prj(_way) + (fix < _par ? wag : -wag));
808     }
809 
810     function inj(int128 x) internal pure returns (uint256) {
811         return x >= 0 ? uint256(x) + RAY
812             : rdiv(RAY, RAY + uint256(-x));
813     }
814     function prj(uint256 x) internal pure returns (int128) {
815         return x >= RAY ? int128(x - RAY)
816             : int128(RAY) - int128(rdiv(RAY, x));
817     }
818 }
819 
820 ////// src/tub.sol
821 /// tub.sol -- simplified CDP engine (baby brother of `vat')
822 
823 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
824 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
825 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
826 
827 // This program is free software: you can redistribute it and/or modify
828 // it under the terms of the GNU General Public License as published by
829 // the Free Software Foundation, either version 3 of the License, or
830 // (at your option) any later version.
831 
832 // This program is distributed in the hope that it will be useful,
833 // but WITHOUT ANY WARRANTY; without even the implied warranty of
834 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
835 // GNU General Public License for more details.
836 
837 // You should have received a copy of the GNU General Public License
838 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
839 
840 /* pragma solidity ^0.4.18; */
841 
842 /* import "ds-thing/thing.sol"; */
843 /* import "ds-token/token.sol"; */
844 /* import "ds-value/value.sol"; */
845 
846 /* import "./vox.sol"; */
847 
848 contract SaiTubEvents {
849     event LogNewCup(address indexed lad, bytes32 cup);
850 }
851 
852 contract SaiTub is DSThing, SaiTubEvents {
853     DSToken  public  sai;  // Stablecoin
854     DSToken  public  sin;  // Debt (negative sai)
855 
856     DSToken  public  skr;  // Abstracted collateral
857     ERC20    public  gem;  // Underlying collateral
858 
859     DSToken  public  gov;  // Governance token
860 
861     SaiVox   public  vox;  // Target price feed
862     DSValue  public  pip;  // Reference price feed
863     DSValue  public  pep;  // Governance price feed
864 
865     address  public  tap;  // Liquidator
866     address  public  pit;  // Governance Vault
867 
868     uint256  public  axe;  // Liquidation penalty
869     uint256  public  cap;  // Debt ceiling
870     uint256  public  mat;  // Liquidation ratio
871     uint256  public  tax;  // Stability fee
872     uint256  public  fee;  // Governance fee
873     uint256  public  gap;  // Join-Exit Spread
874 
875     bool     public  off;  // Cage flag
876     bool     public  out;  // Post cage exit
877 
878     uint256  public  fit;  // REF per SKR (just before settlement)
879 
880     uint256  public  rho;  // Time of last drip
881     uint256         _chi;  // Accumulated Tax Rates
882     uint256         _rhi;  // Accumulated Tax + Fee Rates
883     uint256  public  rum;  // Total normalised debt
884 
885     uint256                   public  cupi;
886     mapping (bytes32 => Cup)  public  cups;
887 
888     struct Cup {
889         address  lad;      // CDP owner
890         uint256  ink;      // Locked collateral (in SKR)
891         uint256  art;      // Outstanding normalised debt (tax only)
892         uint256  ire;      // Outstanding normalised debt
893     }
894 
895     function lad(bytes32 cup) public view returns (address) {
896         return cups[cup].lad;
897     }
898     function ink(bytes32 cup) public view returns (uint) {
899         return cups[cup].ink;
900     }
901     function tab(bytes32 cup) public returns (uint) {
902         return rmul(cups[cup].art, chi());
903     }
904     function rap(bytes32 cup) public returns (uint) {
905         return sub(rmul(cups[cup].ire, rhi()), tab(cup));
906     }
907 
908     // Total CDP Debt
909     function din() public returns (uint) {
910         return rmul(rum, chi());
911     }
912     // Backing collateral
913     function air() public view returns (uint) {
914         return skr.balanceOf(this);
915     }
916     // Raw collateral
917     function pie() public view returns (uint) {
918         return gem.balanceOf(this);
919     }
920 
921     //------------------------------------------------------------------
922 
923     function SaiTub(
924         DSToken  sai_,
925         DSToken  sin_,
926         DSToken  skr_,
927         ERC20    gem_,
928         DSToken  gov_,
929         DSValue  pip_,
930         DSValue  pep_,
931         SaiVox   vox_,
932         address  pit_
933     ) public {
934         gem = gem_;
935         skr = skr_;
936 
937         sai = sai_;
938         sin = sin_;
939 
940         gov = gov_;
941         pit = pit_;
942 
943         pip = pip_;
944         pep = pep_;
945         vox = vox_;
946 
947         axe = RAY;
948         mat = RAY;
949         tax = RAY;
950         fee = RAY;
951         gap = WAD;
952 
953         _chi = RAY;
954         _rhi = RAY;
955 
956         rho = era();
957     }
958 
959     function era() public constant returns (uint) {
960         return block.timestamp;
961     }
962 
963     //--Risk-parameter-config-------------------------------------------
964 
965     function mold(bytes32 param, uint val) public note auth {
966         if      (param == 'cap') cap = val;
967         else if (param == 'mat') { require(val >= RAY); mat = val; }
968         else if (param == 'tax') { require(val >= RAY); drip(); tax = val; }
969         else if (param == 'fee') { require(val >= RAY); drip(); fee = val; }
970         else if (param == 'axe') { require(val >= RAY); axe = val; }
971         else if (param == 'gap') { require(val >= WAD); gap = val; }
972         else return;
973     }
974 
975     //--Price-feed-setters----------------------------------------------
976 
977     function setPip(DSValue pip_) public note auth {
978         pip = pip_;
979     }
980     function setPep(DSValue pep_) public note auth {
981         pep = pep_;
982     }
983     function setVox(SaiVox vox_) public note auth {
984         vox = vox_;
985     }
986 
987     //--Tap-setter------------------------------------------------------
988     function turn(address tap_) public note {
989         require(tap  == 0);
990         require(tap_ != 0);
991         tap = tap_;
992     }
993 
994     //--Collateral-wrapper----------------------------------------------
995 
996     // Wrapper ratio (gem per skr)
997     function per() public view returns (uint ray) {
998         return skr.totalSupply() == 0 ? RAY : rdiv(pie(), skr.totalSupply());
999     }
1000     // Join price (gem per skr)
1001     function ask(uint wad) public view returns (uint) {
1002         return rmul(wad, wmul(per(), gap));
1003     }
1004     // Exit price (gem per skr)
1005     function bid(uint wad) public view returns (uint) {
1006         return rmul(wad, wmul(per(), sub(2 * WAD, gap)));
1007     }
1008     function join(uint wad) public note {
1009         require(!off);
1010         require(ask(wad) > 0);
1011         require(gem.transferFrom(msg.sender, this, ask(wad)));
1012         skr.mint(msg.sender, wad);
1013     }
1014     function exit(uint wad) public note {
1015         require(!off || out);
1016         require(gem.transfer(msg.sender, bid(wad)));
1017         skr.burn(msg.sender, wad);
1018     }
1019 
1020     //--Stability-fee-accumulation--------------------------------------
1021 
1022     // Accumulated Rates
1023     function chi() public returns (uint) {
1024         drip();
1025         return _chi;
1026     }
1027     function rhi() public returns (uint) {
1028         drip();
1029         return _rhi;
1030     }
1031     function drip() public note {
1032         if (off) return;
1033 
1034         var rho_ = era();
1035         var age = rho_ - rho;
1036         if (age == 0) return;    // optimised
1037         rho = rho_;
1038 
1039         var inc = RAY;
1040 
1041         if (tax != RAY) {  // optimised
1042             var _chi_ = _chi;
1043             inc = rpow(tax, age);
1044             _chi = rmul(_chi, inc);
1045             sai.mint(tap, rmul(sub(_chi, _chi_), rum));
1046         }
1047 
1048         // optimised
1049         if (fee != RAY) inc = rmul(inc, rpow(fee, age));
1050         if (inc != RAY) _rhi = rmul(_rhi, inc);
1051     }
1052 
1053 
1054     //--CDP-risk-indicator----------------------------------------------
1055 
1056     // Abstracted collateral price (ref per skr)
1057     function tag() public view returns (uint wad) {
1058         return off ? fit : wmul(per(), uint(pip.read()));
1059     }
1060     // Returns true if cup is well-collateralized
1061     function safe(bytes32 cup) public returns (bool) {
1062         var pro = rmul(tag(), ink(cup));
1063         var con = rmul(vox.par(), tab(cup));
1064         var min = rmul(con, mat);
1065         return pro >= min;
1066     }
1067 
1068 
1069     //--CDP-operations--------------------------------------------------
1070 
1071     function open() public note returns (bytes32 cup) {
1072         require(!off);
1073         cupi = add(cupi, 1);
1074         cup = bytes32(cupi);
1075         cups[cup].lad = msg.sender;
1076         LogNewCup(msg.sender, cup);
1077     }
1078     function give(bytes32 cup, address guy) public note {
1079         require(msg.sender == cups[cup].lad);
1080         require(guy != 0);
1081         cups[cup].lad = guy;
1082     }
1083 
1084     function lock(bytes32 cup, uint wad) public note {
1085         require(!off);
1086         cups[cup].ink = add(cups[cup].ink, wad);
1087         skr.pull(msg.sender, wad);
1088         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
1089     }
1090     function free(bytes32 cup, uint wad) public note {
1091         require(msg.sender == cups[cup].lad);
1092         cups[cup].ink = sub(cups[cup].ink, wad);
1093         skr.push(msg.sender, wad);
1094         require(safe(cup));
1095         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
1096     }
1097 
1098     function draw(bytes32 cup, uint wad) public note {
1099         require(!off);
1100         require(msg.sender == cups[cup].lad);
1101         require(rdiv(wad, chi()) > 0);
1102 
1103         cups[cup].art = add(cups[cup].art, rdiv(wad, chi()));
1104         rum = add(rum, rdiv(wad, chi()));
1105 
1106         cups[cup].ire = add(cups[cup].ire, rdiv(wad, rhi()));
1107         sai.mint(cups[cup].lad, wad);
1108 
1109         require(safe(cup));
1110         require(sai.totalSupply() <= cap);
1111     }
1112     function wipe(bytes32 cup, uint wad) public note {
1113         require(!off);
1114 
1115         var owe = rmul(wad, rdiv(rap(cup), tab(cup)));
1116 
1117         cups[cup].art = sub(cups[cup].art, rdiv(wad, chi()));
1118         rum = sub(rum, rdiv(wad, chi()));
1119 
1120         cups[cup].ire = sub(cups[cup].ire, rdiv(add(wad, owe), rhi()));
1121         sai.burn(msg.sender, wad);
1122 
1123         var (val, ok) = pep.peek();
1124         if (ok && val != 0) gov.move(msg.sender, pit, wdiv(owe, uint(val)));
1125     }
1126 
1127     function shut(bytes32 cup) public note {
1128         require(!off);
1129         require(msg.sender == cups[cup].lad);
1130         if (tab(cup) != 0) wipe(cup, tab(cup));
1131         if (ink(cup) != 0) free(cup, ink(cup));
1132         delete cups[cup];
1133     }
1134 
1135     function bite(bytes32 cup) public note {
1136         require(!safe(cup) || off);
1137 
1138         // Take on all of the debt, except unpaid fees
1139         var rue = tab(cup);
1140         sin.mint(tap, rue);
1141         rum = sub(rum, cups[cup].art);
1142         cups[cup].art = 0;
1143         cups[cup].ire = 0;
1144 
1145         // Amount owed in SKR, including liquidation penalty
1146         var owe = rdiv(rmul(rmul(rue, axe), vox.par()), tag());
1147 
1148         if (owe > cups[cup].ink) {
1149             owe = cups[cup].ink;
1150         }
1151 
1152         skr.push(tap, owe);
1153         cups[cup].ink = sub(cups[cup].ink, owe);
1154     }
1155 
1156     //------------------------------------------------------------------
1157 
1158     function cage(uint fit_, uint jam) public note auth {
1159         require(!off && fit_ != 0);
1160         off = true;
1161         axe = RAY;
1162         gap = WAD;
1163         fit = fit_;         // ref per skr
1164         require(gem.transfer(tap, jam));
1165     }
1166     function flow() public note auth {
1167         require(off);
1168         out = true;
1169     }
1170 }
1171 
1172 ////// src/tap.sol
1173 /// tap.sol -- liquidation engine (see also `vow`)
1174 
1175 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
1176 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
1177 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
1178 
1179 // This program is free software: you can redistribute it and/or modify
1180 // it under the terms of the GNU General Public License as published by
1181 // the Free Software Foundation, either version 3 of the License, or
1182 // (at your option) any later version.
1183 
1184 // This program is distributed in the hope that it will be useful,
1185 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1186 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1187 // GNU General Public License for more details.
1188 
1189 // You should have received a copy of the GNU General Public License
1190 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1191 
1192 /* pragma solidity ^0.4.18; */
1193 
1194 /* import "./tub.sol"; */
1195 
1196 contract SaiTap is DSThing {
1197     DSToken  public  sai;
1198     DSToken  public  sin;
1199     DSToken  public  skr;
1200 
1201     SaiVox   public  vox;
1202     SaiTub   public  tub;
1203 
1204     uint256  public  gap;  // Boom-Bust Spread
1205     bool     public  off;  // Cage flag
1206     uint256  public  fix;  // Cage price
1207 
1208     // Surplus
1209     function joy() public view returns (uint) {
1210         return sai.balanceOf(this);
1211     }
1212     // Bad debt
1213     function woe() public view returns (uint) {
1214         return sin.balanceOf(this);
1215     }
1216     // Collateral pending liquidation
1217     function fog() public view returns (uint) {
1218         return skr.balanceOf(this);
1219     }
1220 
1221 
1222     function SaiTap(SaiTub tub_) public {
1223         tub = tub_;
1224 
1225         sai = tub.sai();
1226         sin = tub.sin();
1227         skr = tub.skr();
1228 
1229         vox = tub.vox();
1230 
1231         gap = WAD;
1232     }
1233 
1234     function mold(bytes32 param, uint val) public note auth {
1235         if (param == 'gap') gap = val;
1236     }
1237 
1238     // Cancel debt
1239     function heal() public note {
1240         if (joy() == 0 || woe() == 0) return;  // optimised
1241         var wad = min(joy(), woe());
1242         sai.burn(wad);
1243         sin.burn(wad);
1244     }
1245 
1246     // Feed price (sai per skr)
1247     function s2s() public returns (uint) {
1248         var tag = tub.tag();    // ref per skr
1249         var par = vox.par();    // ref per sai
1250         return rdiv(tag, par);  // sai per skr
1251     }
1252     // Boom price (sai per skr)
1253     function bid(uint wad) public returns (uint) {
1254         return rmul(wad, wmul(s2s(), sub(2 * WAD, gap)));
1255     }
1256     // Bust price (sai per skr)
1257     function ask(uint wad) public returns (uint) {
1258         return rmul(wad, wmul(s2s(), gap));
1259     }
1260     function flip(uint wad) internal {
1261         require(ask(wad) > 0);
1262         skr.push(msg.sender, wad);
1263         sai.pull(msg.sender, ask(wad));
1264         heal();
1265     }
1266     function flop(uint wad) internal {
1267         skr.mint(sub(wad, fog()));
1268         flip(wad);
1269         require(joy() == 0);  // can't flop into surplus
1270     }
1271     function flap(uint wad) internal {
1272         heal();
1273         sai.push(msg.sender, bid(wad));
1274         skr.burn(msg.sender, wad);
1275     }
1276     function bust(uint wad) public note {
1277         require(!off);
1278         if (wad > fog()) flop(wad);
1279         else flip(wad);
1280     }
1281     function boom(uint wad) public note {
1282         require(!off);
1283         flap(wad);
1284     }
1285 
1286     //------------------------------------------------------------------
1287 
1288     function cage(uint fix_) public note auth {
1289         require(!off);
1290         off = true;
1291         fix = fix_;
1292     }
1293     function cash(uint wad) public note {
1294         require(off);
1295         sai.burn(msg.sender, wad);
1296         require(tub.gem().transfer(msg.sender, rmul(wad, fix)));
1297     }
1298     function mock(uint wad) public note {
1299         require(off);
1300         sai.mint(msg.sender, wad);
1301         require(tub.gem().transferFrom(msg.sender, this, rmul(wad, fix)));
1302     }
1303     function vent() public note {
1304         require(off);
1305         skr.burn(fog());
1306     }
1307 }
1308 
1309 ////// src/top.sol
1310 /// top.sol -- global settlement manager
1311 
1312 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
1313 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
1314 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
1315 
1316 // This program is free software: you can redistribute it and/or modify
1317 // it under the terms of the GNU General Public License as published by
1318 // the Free Software Foundation, either version 3 of the License, or
1319 // (at your option) any later version.
1320 
1321 // This program is distributed in the hope that it will be useful,
1322 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1323 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1324 // GNU General Public License for more details.
1325 
1326 // You should have received a copy of the GNU General Public License
1327 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1328 
1329 /* pragma solidity ^0.4.18; */
1330 
1331 /* import "./tub.sol"; */
1332 /* import "./tap.sol"; */
1333 
1334 contract SaiTop is DSThing {
1335     SaiVox   public  vox;
1336     SaiTub   public  tub;
1337     SaiTap   public  tap;
1338 
1339     DSToken  public  sai;
1340     DSToken  public  sin;
1341     DSToken  public  skr;
1342     ERC20    public  gem;
1343 
1344     uint256  public  fix;  // sai cage price (gem per sai)
1345     uint256  public  fit;  // skr cage price (ref per skr)
1346     uint256  public  caged;
1347     uint256  public  cooldown = 6 hours;
1348 
1349     function SaiTop(SaiTub tub_, SaiTap tap_) public {
1350         tub = tub_;
1351         tap = tap_;
1352 
1353         vox = tub.vox();
1354 
1355         sai = tub.sai();
1356         sin = tub.sin();
1357         skr = tub.skr();
1358         gem = tub.gem();
1359     }
1360 
1361     function era() public view returns (uint) {
1362         return block.timestamp;
1363     }
1364 
1365     // force settlement of the system at a given price (sai per gem).
1366     // This is nearly the equivalent of biting all cups at once.
1367     // Important consideration: the gems associated with free skr can
1368     // be tapped to make sai whole.
1369     function cage(uint price) internal {
1370         require(!tub.off() && price != 0);
1371         caged = era();
1372 
1373         tub.drip();  // collect remaining fees
1374         tap.heal();  // absorb any pending fees
1375 
1376         fit = rmul(wmul(price, vox.par()), tub.per());
1377         // Most gems we can get per sai is the full balance of the tub.
1378         // If there is no sai issued, we should still be able to cage.
1379         if (sai.totalSupply() == 0) {
1380             fix = rdiv(WAD, price);
1381         } else {
1382             fix = min(rdiv(WAD, price), rdiv(tub.pie(), sai.totalSupply()));
1383         }
1384 
1385         tub.cage(fit, rmul(fix, sai.totalSupply()));
1386         tap.cage(fix);
1387 
1388         tap.vent();    // burn pending sale skr
1389     }
1390     // cage by reading the last value from the feed for the price
1391     function cage() public note auth {
1392         cage(rdiv(uint(tub.pip().read()), vox.par()));
1393     }
1394 
1395     function flow() public note {
1396         require(tub.off());
1397         var empty = tub.din() == 0 && tap.fog() == 0;
1398         var ended = era() > caged + cooldown;
1399         require(empty || ended);
1400         tub.flow();
1401     }
1402 
1403     function setCooldown(uint cooldown_) public auth {
1404         cooldown = cooldown_;
1405     }
1406 }
1407 
1408 ////// src/mom.sol
1409 /// mom.sol -- admin manager
1410 
1411 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
1412 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
1413 // Copyright (C) 2017  Rain <rainbreak@riseup.net>
1414 
1415 // This program is free software: you can redistribute it and/or modify
1416 // it under the terms of the GNU General Public License as published by
1417 // the Free Software Foundation, either version 3 of the License, or
1418 // (at your option) any later version.
1419 
1420 // This program is distributed in the hope that it will be useful,
1421 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1422 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1423 // GNU General Public License for more details.
1424 
1425 // You should have received a copy of the GNU General Public License
1426 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1427 
1428 /* pragma solidity ^0.4.18; */
1429 
1430 /* import 'ds-thing/thing.sol'; */
1431 /* import './tub.sol'; */
1432 /* import './top.sol'; */
1433 /* import './tap.sol'; */
1434 
1435 contract SaiMom is DSThing {
1436     SaiTub  public  tub;
1437     SaiTap  public  tap;
1438     SaiVox  public  vox;
1439 
1440     function SaiMom(SaiTub tub_, SaiTap tap_, SaiVox vox_) public {
1441         tub = tub_;
1442         tap = tap_;
1443         vox = vox_;
1444     }
1445     // Debt ceiling
1446     function setCap(uint wad) public note auth {
1447         tub.mold("cap", wad);
1448     }
1449     // Liquidation ratio
1450     function setMat(uint ray) public note auth {
1451         tub.mold("mat", ray);
1452         var axe = tub.axe();
1453         var mat = tub.mat();
1454         require(axe >= RAY && axe <= mat);
1455     }
1456     // Stability fee
1457     function setTax(uint ray) public note auth {
1458         tub.mold("tax", ray);
1459         var tax = tub.tax();
1460         require(RAY <= tax);
1461         require(tax < 10002 * 10 ** 23);  // ~200% per hour
1462     }
1463     // Governance fee
1464     function setFee(uint ray) public note auth {
1465         tub.mold("fee", ray);
1466         var fee = tub.fee();
1467         require(RAY <= fee);
1468         require(fee < 10002 * 10 ** 23);  // ~200% per hour
1469     }
1470     // Liquidation fee
1471     function setAxe(uint ray) public note auth {
1472         tub.mold("axe", ray);
1473         var axe = tub.axe();
1474         var mat = tub.mat();
1475         require(axe >= RAY && axe <= mat);
1476     }
1477     // Join/Exit Spread
1478     function setTubGap(uint wad) public note auth {
1479         tub.mold("gap", wad);
1480     }
1481     // ETH/USD Feed
1482     function setPip(DSValue pip_) public note auth {
1483         tub.setPip(pip_);
1484     }
1485     // MKR/USD Feed
1486     function setPep(DSValue pep_) public note auth {
1487         tub.setPep(pep_);
1488     }
1489     // TRFM
1490     function setVox(SaiVox vox_) public note auth {
1491         tub.setVox(vox_);
1492     }
1493     // Boom/Bust Spread
1494     function setTapGap(uint wad) public note auth {
1495         tap.mold("gap", wad);
1496         var gap = tap.gap();
1497         require(gap <= 1.05 ether);
1498         require(gap >= 0.95 ether);
1499     }
1500     // Rate of change of target price (per second)
1501     function setWay(uint ray) public note auth {
1502         require(ray < 10002 * 10 ** 23);  // ~200% per hour
1503         require(ray > 9998 * 10 ** 23);
1504         vox.mold("way", ray);
1505     }
1506     function setHow(uint ray) public note auth {
1507         vox.tune(ray);
1508     }
1509 }
1510 
1511 ////// src/fab.sol
1512 /* pragma solidity ^0.4.18; */
1513 
1514 /* import "ds-auth/auth.sol"; */
1515 /* import 'ds-token/token.sol'; */
1516 /* import 'ds-guard/guard.sol'; */
1517 /* import 'ds-roles/roles.sol'; */
1518 /* import 'ds-value/value.sol'; */
1519 
1520 /* import './mom.sol'; */
1521 
1522 contract GemFab {
1523     function newTok(bytes32 name) public returns (DSToken token) {
1524         token = new DSToken(name);
1525         token.setOwner(msg.sender);
1526     }
1527 }
1528 
1529 contract VoxFab {
1530     function newVox() public returns (SaiVox vox) {
1531         vox = new SaiVox(10 ** 27);
1532         vox.setOwner(msg.sender);
1533     }
1534 }
1535 
1536 contract TubFab {
1537     function newTub(DSToken sai, DSToken sin, DSToken skr, ERC20 gem, DSToken gov, DSValue pip, DSValue pep, SaiVox vox, address pit) public returns (SaiTub tub) {
1538         tub = new SaiTub(sai, sin, skr, gem, gov, pip, pep, vox, pit);
1539         tub.setOwner(msg.sender);
1540     }
1541 }
1542 
1543 contract TapFab {
1544     function newTap(SaiTub tub) public returns (SaiTap tap) {
1545         tap = new SaiTap(tub);
1546         tap.setOwner(msg.sender);
1547     }
1548 }
1549 
1550 contract TopFab {
1551     function newTop(SaiTub tub, SaiTap tap) public returns (SaiTop top) {
1552         top = new SaiTop(tub, tap);
1553         top.setOwner(msg.sender);
1554     }
1555 }
1556 
1557 contract MomFab {
1558     function newMom(SaiTub tub, SaiTap tap, SaiVox vox) public returns (SaiMom mom) {
1559         mom = new SaiMom(tub, tap, vox);
1560         mom.setOwner(msg.sender);
1561     }
1562 }
1563 
1564 contract DadFab {
1565     function newDad() public returns (DSGuard dad) {
1566         dad = new DSGuard();
1567         dad.setOwner(msg.sender);
1568     }
1569 }
1570 
1571 contract DaiFab is DSAuth {
1572     GemFab public gemFab;
1573     VoxFab public voxFab;
1574     TapFab public tapFab;
1575     TubFab public tubFab;
1576     TopFab public topFab;
1577     MomFab public momFab;
1578     DadFab public dadFab;
1579 
1580     DSToken public sai;
1581     DSToken public sin;
1582     DSToken public skr;
1583 
1584     SaiVox public vox;
1585     SaiTub public tub;
1586     SaiTap public tap;
1587     SaiTop public top;
1588 
1589     SaiMom public mom;
1590     DSGuard public dad;
1591 
1592     uint8 public step = 0;
1593 
1594     function DaiFab(GemFab gemFab_, VoxFab voxFab_, TubFab tubFab_, TapFab tapFab_, TopFab topFab_, MomFab momFab_, DadFab dadFab_) public {
1595         gemFab = gemFab_;
1596         voxFab = voxFab_;
1597         tubFab = tubFab_;
1598         tapFab = tapFab_;
1599         topFab = topFab_;
1600         momFab = momFab_;
1601         dadFab = dadFab_;
1602     }
1603 
1604     function makeTokens() public auth {
1605         require(step == 0);
1606         sai = gemFab.newTok('sai');
1607         sin = gemFab.newTok('sin');
1608         skr = gemFab.newTok('skr');
1609         step += 1;
1610     }
1611 
1612     function makeVoxTub(ERC20 gem, DSToken gov, DSValue pip, DSValue pep, address pit) public auth {
1613         require(step == 1);
1614         require(address(gem) != 0x0);
1615         require(address(gov) != 0x0);
1616         require(address(pip) != 0x0);
1617         require(address(pep) != 0x0);
1618         require(pit != 0x0);
1619         vox = voxFab.newVox();
1620         tub = tubFab.newTub(sai, sin, skr, gem, gov, pip, pep, vox, pit);
1621         step += 1;
1622     }
1623 
1624     function makeTapTop() public auth {
1625         require(step == 2);
1626         tap = tapFab.newTap(tub);
1627         tub.turn(tap);
1628         top = topFab.newTop(tub, tap);
1629         step += 1;
1630     }
1631 
1632     function S(string s) internal pure returns (bytes4) {
1633         return bytes4(keccak256(s));
1634     }
1635 
1636     function ray(uint256 wad) internal pure returns (uint256) {
1637         return wad * 10 ** 9;
1638     }
1639 
1640     // Liquidation Ratio   150%
1641     // Liquidation Penalty 13%
1642     // Stability Fee       0.05%
1643     // PETH Fee            0%
1644     // Boom/Bust Spread   -3%
1645     // Join/Exit Spread    0%
1646     // Debt Ceiling        0
1647     function configParams() public auth {
1648         require(step == 3);
1649 
1650         tub.mold("cap", 0);
1651         tub.mold("mat", ray(1.5  ether));
1652         tub.mold("axe", ray(1.13 ether));
1653         tub.mold("fee", 1000000000158153903837946257);  // 0.5% / year
1654         tub.mold("tax", ray(1 ether));
1655         tub.mold("gap", 1 ether);
1656 
1657         tap.mold("gap", 0.97 ether);
1658 
1659         step += 1;
1660     }
1661 
1662     function verifyParams() public auth {
1663         require(step == 4);
1664 
1665         require(tub.cap() == 0);
1666         require(tub.mat() == 1500000000000000000000000000);
1667         require(tub.axe() == 1130000000000000000000000000);
1668         require(tub.fee() == 1000000000158153903837946257);
1669         require(tub.tax() == 1000000000000000000000000000);
1670         require(tub.gap() == 1000000000000000000);
1671 
1672         require(tap.gap() == 970000000000000000);
1673 
1674         require(vox.par() == 1000000000000000000000000000);
1675         require(vox.how() == 0);
1676 
1677         step += 1;
1678     }
1679 
1680     function configAuth(DSAuthority authority) public auth {
1681         require(step == 5);
1682         require(address(authority) != 0x0);
1683 
1684         mom = momFab.newMom(tub, tap, vox);
1685         dad = dadFab.newDad();
1686 
1687         vox.setAuthority(dad);
1688         vox.setOwner(0);
1689         tub.setAuthority(dad);
1690         tub.setOwner(0);
1691         tap.setAuthority(dad);
1692         tap.setOwner(0);
1693         sai.setAuthority(dad);
1694         sai.setOwner(0);
1695         sin.setAuthority(dad);
1696         sin.setOwner(0);
1697         skr.setAuthority(dad);
1698         skr.setOwner(0);
1699 
1700         top.setAuthority(authority);
1701         top.setOwner(0);
1702         mom.setAuthority(authority);
1703         mom.setOwner(0);
1704 
1705         dad.permit(top, tub, S("cage(uint256,uint256)"));
1706         dad.permit(top, tub, S("flow()"));
1707         dad.permit(top, tap, S("cage(uint256)"));
1708 
1709         dad.permit(tub, skr, S('mint(address,uint256)'));
1710         dad.permit(tub, skr, S('burn(address,uint256)'));
1711 
1712         dad.permit(tub, sai, S('mint(address,uint256)'));
1713         dad.permit(tub, sai, S('burn(address,uint256)'));
1714 
1715         dad.permit(tub, sin, S('mint(address,uint256)'));
1716 
1717         dad.permit(tap, sai, S('mint(address,uint256)'));
1718         dad.permit(tap, sai, S('burn(address,uint256)'));
1719         dad.permit(tap, sai, S('burn(uint256)'));
1720         dad.permit(tap, sin, S('burn(uint256)'));
1721 
1722         dad.permit(tap, skr, S('mint(uint256)'));
1723         dad.permit(tap, skr, S('burn(uint256)'));
1724         dad.permit(tap, skr, S('burn(address,uint256)'));
1725 
1726         dad.permit(mom, vox, S("mold(bytes32,uint256)"));
1727         dad.permit(mom, vox, S("tune(uint256)"));
1728         dad.permit(mom, tub, S("mold(bytes32,uint256)"));
1729         dad.permit(mom, tap, S("mold(bytes32,uint256)"));
1730         dad.permit(mom, tub, S("setPip(address)"));
1731         dad.permit(mom, tub, S("setPep(address)"));
1732         dad.permit(mom, tub, S("setVox(address)"));
1733 
1734         dad.setOwner(0);
1735         step += 1;
1736     }
1737 }