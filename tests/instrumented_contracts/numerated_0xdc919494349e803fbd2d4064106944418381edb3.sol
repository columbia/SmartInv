1 pragma solidity ^0.4.24;
2 // hevm: flattened sources of src/tub.sol
3 
4 
5 ////// lib/ds-guard/lib/ds-auth/src/auth.sol
6 // This program is free software: you can redistribute it and/or modify
7 // it under the terms of the GNU General Public License as published by
8 // the Free Software Foundation, either version 3 of the License, or
9 // (at your option) any later version.
10 
11 // This program is distributed in the hope that it will be useful,
12 // but WITHOUT ANY WARRANTY; without even the implied warranty of
13 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 // GNU General Public License for more details.
15 
16 // You should have received a copy of the GNU General Public License
17 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 
19 /*  */
20 
21 contract DSAuthority {
22     function canCall(
23         address src, address dst, bytes4 sig
24     ) public view returns (bool);
25 }
26 
27 contract DSAuthEvents {
28     event LogSetAuthority (address indexed authority);
29     event LogSetOwner     (address indexed owner);
30 }
31 
32 contract DSAuth is DSAuthEvents {
33     DSAuthority  public  authority;
34     address      public  owner;
35 
36     function DSAuth() public {
37         owner = msg.sender;
38         LogSetOwner(msg.sender);
39     }
40 
41     function setOwner(address owner_)
42         public
43         auth
44     {
45         owner = owner_;
46         LogSetOwner(owner);
47     }
48 
49     function setAuthority(DSAuthority authority_)
50         public
51         auth
52     {
53         authority = authority_;
54         LogSetAuthority(authority);
55     }
56 
57     modifier auth {
58         require(isAuthorized(msg.sender, msg.sig));
59         _;
60     }
61 
62     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
63         if (src == address(this)) {
64             return true;
65         } else if (src == owner) {
66             return true;
67         } else if (authority == DSAuthority(0)) {
68             return false;
69         } else {
70             return authority.canCall(src, this, sig);
71         }
72     }
73 }
74 
75 ////// lib/ds-spell/lib/ds-note/src/note.sol
76 /// note.sol -- the `note' modifier, for logging calls as events
77 
78 // This program is free software: you can redistribute it and/or modify
79 // it under the terms of the GNU General Public License as published by
80 // the Free Software Foundation, either version 3 of the License, or
81 // (at your option) any later version.
82 
83 // This program is distributed in the hope that it will be useful,
84 // but WITHOUT ANY WARRANTY; without even the implied warranty of
85 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
86 // GNU General Public License for more details.
87 
88 // You should have received a copy of the GNU General Public License
89 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
90 
91 /*  */
92 
93 contract DSNote {
94     event LogNote(
95         bytes4   indexed  sig,
96         address  indexed  guy,
97         bytes32  indexed  foo,
98         bytes32  indexed  bar,
99         uint              wad,
100         bytes             fax
101     ) anonymous;
102 
103     modifier note {
104         bytes32 foo;
105         bytes32 bar;
106 
107         assembly {
108             foo := calldataload(4)
109             bar := calldataload(36)
110         }
111 
112         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
113 
114         _;
115     }
116 }
117 
118 ////// lib/ds-thing/lib/ds-math/src/math.sol
119 /// math.sol -- mixin for inline numerical wizardry
120 
121 // This program is free software: you can redistribute it and/or modify
122 // it under the terms of the GNU General Public License as published by
123 // the Free Software Foundation, either version 3 of the License, or
124 // (at your option) any later version.
125 
126 // This program is distributed in the hope that it will be useful,
127 // but WITHOUT ANY WARRANTY; without even the implied warranty of
128 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
129 // GNU General Public License for more details.
130 
131 // You should have received a copy of the GNU General Public License
132 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
133 
134 /*  */
135 
136 contract DSMath {
137     function add(uint x, uint y) internal pure returns (uint z) {
138         require((z = x + y) >= x);
139     }
140     function sub(uint x, uint y) internal pure returns (uint z) {
141         require((z = x - y) <= x);
142     }
143     function mul(uint x, uint y) internal pure returns (uint z) {
144         require(y == 0 || (z = x * y) / y == x);
145     }
146 
147     function min(uint x, uint y) internal pure returns (uint z) {
148         return x <= y ? x : y;
149     }
150     function max(uint x, uint y) internal pure returns (uint z) {
151         return x >= y ? x : y;
152     }
153     function imin(int x, int y) internal pure returns (int z) {
154         return x <= y ? x : y;
155     }
156     function imax(int x, int y) internal pure returns (int z) {
157         return x >= y ? x : y;
158     }
159 
160     uint constant WAD = 10 ** 18;
161     uint constant RAY = 10 ** 27;
162 
163     function wmul(uint x, uint y) internal pure returns (uint z) {
164         z = add(mul(x, y), WAD / 2) / WAD;
165     }
166     function rmul(uint x, uint y) internal pure returns (uint z) {
167         z = add(mul(x, y), RAY / 2) / RAY;
168     }
169     function wdiv(uint x, uint y) internal pure returns (uint z) {
170         z = add(mul(x, WAD), y / 2) / y;
171     }
172     function rdiv(uint x, uint y) internal pure returns (uint z) {
173         z = add(mul(x, RAY), y / 2) / y;
174     }
175 
176     // This famous algorithm is called "exponentiation by squaring"
177     // and calculates x^n with x as fixed-point and n as regular unsigned.
178     //
179     // It's O(log n), instead of O(n) for naive repeated multiplication.
180     //
181     // These facts are why it works:
182     //
183     //  If n is even, then x^n = (x^2)^(n/2).
184     //  If n is odd,  then x^n = x * x^(n-1),
185     //   and applying the equation for even x gives
186     //    x^n = x * (x^2)^((n-1) / 2).
187     //
188     //  Also, EVM division is flooring and
189     //    floor[(n-1) / 2] = floor[n / 2].
190     //
191     function rpow(uint x, uint n) internal pure returns (uint z) {
192         z = n % 2 != 0 ? x : RAY;
193 
194         for (n /= 2; n != 0; n /= 2) {
195             x = rmul(x, x);
196 
197             if (n % 2 != 0) {
198                 z = rmul(z, x);
199             }
200         }
201     }
202 }
203 
204 ////// lib/ds-thing/src/thing.sol
205 // thing.sol - `auth` with handy mixins. your things should be DSThings
206 
207 // Copyright (C) 2017  DappHub, LLC
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
222 /*  */
223 
224 /* import 'ds-auth/auth.sol'; */
225 /* import 'ds-note/note.sol'; */
226 /* import 'ds-math/math.sol'; */
227 
228 contract DSThing is DSAuth, DSNote, DSMath {
229 
230     function S(string s) internal pure returns (bytes4) {
231         return bytes4(keccak256(s));
232     }
233 
234 }
235 
236 ////// lib/ds-token/lib/ds-stop/src/stop.sol
237 /// stop.sol -- mixin for enable/disable functionality
238 
239 // Copyright (C) 2017  DappHub, LLC
240 
241 // This program is free software: you can redistribute it and/or modify
242 // it under the terms of the GNU General Public License as published by
243 // the Free Software Foundation, either version 3 of the License, or
244 // (at your option) any later version.
245 
246 // This program is distributed in the hope that it will be useful,
247 // but WITHOUT ANY WARRANTY; without even the implied warranty of
248 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
249 // GNU General Public License for more details.
250 
251 // You should have received a copy of the GNU General Public License
252 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
253 
254 /*  */
255 
256 /* import "ds-auth/auth.sol"; */
257 /* import "ds-note/note.sol"; */
258 
259 contract DSStop is DSNote, DSAuth {
260 
261     bool public stopped;
262 
263     modifier stoppable {
264         require(!stopped);
265         _;
266     }
267     function stop() public auth note {
268         stopped = true;
269     }
270     function start() public auth note {
271         stopped = false;
272     }
273 
274 }
275 
276 ////// lib/ds-token/lib/erc20/src/erc20.sol
277 /// erc20.sol -- API for the ERC20 token standard
278 
279 // See <https://github.com/ethereum/EIPs/issues/20>.
280 
281 // This file likely does not meet the threshold of originality
282 // required for copyright to apply.  As a result, this is free and
283 // unencumbered software belonging to the public domain.
284 
285 /*  */
286 
287 contract ERC20Events {
288     event Approval(address indexed src, address indexed guy, uint wad);
289     event Transfer(address indexed src, address indexed dst, uint wad);
290 }
291 
292 contract ERC20 is ERC20Events {
293     function totalSupply() public view returns (uint);
294     function balanceOf(address guy) public view returns (uint);
295     function allowance(address src, address guy) public view returns (uint);
296 
297     function approve(address guy, uint wad) public returns (bool);
298     function transfer(address dst, uint wad) public returns (bool);
299     function transferFrom(
300         address src, address dst, uint wad
301     ) public returns (bool);
302 }
303 
304 ////// lib/ds-token/src/base.sol
305 /// base.sol -- basic ERC20 implementation
306 
307 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
308 
309 // This program is free software: you can redistribute it and/or modify
310 // it under the terms of the GNU General Public License as published by
311 // the Free Software Foundation, either version 3 of the License, or
312 // (at your option) any later version.
313 
314 // This program is distributed in the hope that it will be useful,
315 // but WITHOUT ANY WARRANTY; without even the implied warranty of
316 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
317 // GNU General Public License for more details.
318 
319 // You should have received a copy of the GNU General Public License
320 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
321 
322 /*  */
323 
324 /* import "erc20/erc20.sol"; */
325 /* import "ds-math/math.sol"; */
326 
327 contract DSTokenBase is ERC20, DSMath {
328     uint256                                            _supply;
329     mapping (address => uint256)                       _balances;
330     mapping (address => mapping (address => uint256))  _approvals;
331 
332     function DSTokenBase(uint supply) public {
333         _balances[msg.sender] = supply;
334         _supply = supply;
335     }
336 
337     function totalSupply() public view returns (uint) {
338         return _supply;
339     }
340     function balanceOf(address src) public view returns (uint) {
341         return _balances[src];
342     }
343     function allowance(address src, address guy) public view returns (uint) {
344         return _approvals[src][guy];
345     }
346 
347     function transfer(address dst, uint wad) public returns (bool) {
348         return transferFrom(msg.sender, dst, wad);
349     }
350 
351     function transferFrom(address src, address dst, uint wad)
352         public
353         returns (bool)
354     {
355         if (src != msg.sender) {
356             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
357         }
358 
359         _balances[src] = sub(_balances[src], wad);
360         _balances[dst] = add(_balances[dst], wad);
361 
362         Transfer(src, dst, wad);
363 
364         return true;
365     }
366 
367     function approve(address guy, uint wad) public returns (bool) {
368         _approvals[msg.sender][guy] = wad;
369 
370         Approval(msg.sender, guy, wad);
371 
372         return true;
373     }
374 }
375 
376 ////// lib/ds-token/src/token.sol
377 /// token.sol -- ERC20 implementation with minting and burning
378 
379 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
380 
381 // This program is free software: you can redistribute it and/or modify
382 // it under the terms of the GNU General Public License as published by
383 // the Free Software Foundation, either version 3 of the License, or
384 // (at your option) any later version.
385 
386 // This program is distributed in the hope that it will be useful,
387 // but WITHOUT ANY WARRANTY; without even the implied warranty of
388 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
389 // GNU General Public License for more details.
390 
391 // You should have received a copy of the GNU General Public License
392 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
393 
394 /*  */
395 
396 /* import "ds-stop/stop.sol"; */
397 
398 /* import "./base.sol"; */
399 
400 contract DSToken is DSTokenBase(0), DSStop {
401 
402     bytes32  public  symbol;
403     uint256  public  decimals = 18; // standard token precision. override to customize
404 
405     function DSToken(bytes32 symbol_) public {
406         symbol = symbol_;
407     }
408 
409     event Mint(address indexed guy, uint wad);
410     event Burn(address indexed guy, uint wad);
411 
412     function approve(address guy) public stoppable returns (bool) {
413         return super.approve(guy, uint(-1));
414     }
415 
416     function approve(address guy, uint wad) public stoppable returns (bool) {
417         return super.approve(guy, wad);
418     }
419 
420     function transferFrom(address src, address dst, uint wad)
421         public
422         stoppable
423         returns (bool)
424     {
425         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
426             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
427         }
428 
429         _balances[src] = sub(_balances[src], wad);
430         _balances[dst] = add(_balances[dst], wad);
431 
432         Transfer(src, dst, wad);
433 
434         return true;
435     }
436 
437     function push(address dst, uint wad) public {
438         transferFrom(msg.sender, dst, wad);
439     }
440     function pull(address src, uint wad) public {
441         transferFrom(src, msg.sender, wad);
442     }
443     function move(address src, address dst, uint wad) public {
444         transferFrom(src, dst, wad);
445     }
446 
447     function mint(uint wad) public {
448         mint(msg.sender, wad);
449     }
450     function burn(uint wad) public {
451         burn(msg.sender, wad);
452     }
453     function mint(address guy, uint wad) public auth stoppable {
454         _balances[guy] = add(_balances[guy], wad);
455         _supply = add(_supply, wad);
456         Mint(guy, wad);
457     }
458     function burn(address guy, uint wad) public auth stoppable {
459         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
460             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
461         }
462 
463         _balances[guy] = sub(_balances[guy], wad);
464         _supply = sub(_supply, wad);
465         Burn(guy, wad);
466     }
467 
468     // Optional token name
469     bytes32   public  name = "";
470 
471     function setName(bytes32 name_) public auth {
472         name = name_;
473     }
474 }
475 
476 ////// lib/ds-value/src/value.sol
477 /// value.sol - a value is a simple thing, it can be get and set
478 
479 // Copyright (C) 2017  DappHub, LLC
480 
481 // This program is free software: you can redistribute it and/or modify
482 // it under the terms of the GNU General Public License as published by
483 // the Free Software Foundation, either version 3 of the License, or
484 // (at your option) any later version.
485 
486 // This program is distributed in the hope that it will be useful,
487 // but WITHOUT ANY WARRANTY; without even the implied warranty of
488 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
489 // GNU General Public License for more details.
490 
491 // You should have received a copy of the GNU General Public License
492 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
493 
494 /*  */
495 
496 /* import 'ds-thing/thing.sol'; */
497 
498 contract DSValue is DSThing {
499     bool    has;
500     bytes32 val;
501     function peek() public view returns (bytes32, bool) {
502         return (val,has);
503     }
504     function read() public view returns (bytes32) {
505         var (wut, haz) = peek();
506         assert(haz);
507         return wut;
508     }
509     function poke(bytes32 wut) public note auth {
510         val = wut;
511         has = true;
512     }
513     function void() public note auth {  // unset the value
514         has = false;
515     }
516 }
517 
518 ////// src/vox.sol
519 /// vox.sol -- target price feed
520 
521 // Copyright (C) 2016, 2017  Nikolai Mushegian <nikolai@dapphub.com>
522 // Copyright (C) 2016, 2017  Daniel Brockman <daniel@dapphub.com>
523 // Copyright (C) 2017        Rain Break <rainbreak@riseup.net>
524 
525 // This program is free software: you can redistribute it and/or modify
526 // it under the terms of the GNU General Public License as published by
527 // the Free Software Foundation, either version 3 of the License, or
528 // (at your option) any later version.
529 
530 // This program is distributed in the hope that it will be useful,
531 // but WITHOUT ANY WARRANTY; without even the implied warranty of
532 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
533 // GNU General Public License for more details.
534 
535 // You should have received a copy of the GNU General Public License
536 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
537 
538 /*  */
539 
540 /* import "ds-thing/thing.sol"; */
541 
542 contract SaiVox is DSThing {
543     uint256  _par;
544     uint256  _way;
545 
546     uint256  public  fix;
547     uint256  public  how;
548     uint256  public  tau;
549 
550     function SaiVox(uint par_) public {
551         _par = fix = par_;
552         _way = RAY;
553         tau  = era();
554     }
555 
556     function era() public view returns (uint) {
557         return block.timestamp;
558     }
559 
560     function mold(bytes32 param, uint val) public note auth {
561         if (param == 'way') _way = val;
562     }
563 
564     // Dai Target Price (ref per dai)
565     function par() public returns (uint) {
566         prod();
567         return _par;
568     }
569     function way() public returns (uint) {
570         prod();
571         return _way;
572     }
573 
574     function tell(uint256 ray) public note auth {
575         fix = ray;
576     }
577     function tune(uint256 ray) public note auth {
578         how = ray;
579     }
580 
581     function prod() public note {
582         var age = era() - tau;
583         if (age == 0) return;  // optimised
584         tau = era();
585 
586         if (_way != RAY) _par = rmul(_par, rpow(_way, age));  // optimised
587 
588         if (how == 0) return;  // optimised
589         var wag = int128(how * age);
590         _way = inj(prj(_way) + (fix < _par ? wag : -wag));
591     }
592 
593     function inj(int128 x) internal pure returns (uint256) {
594         return x >= 0 ? uint256(x) + RAY
595             : rdiv(RAY, RAY + uint256(-x));
596     }
597     function prj(uint256 x) internal pure returns (int128) {
598         return x >= RAY ? int128(x - RAY)
599             : int128(RAY) - int128(rdiv(RAY, x));
600     }
601 }
602 
603 ////// src/tub.sol
604 /// tub.sol -- simplified CDP engine (baby brother of `vat')
605 
606 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
607 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
608 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
609 
610 // This program is free software: you can redistribute it and/or modify
611 // it under the terms of the GNU General Public License as published by
612 // the Free Software Foundation, either version 3 of the License, or
613 // (at your option) any later version.
614 
615 // This program is distributed in the hope that it will be useful,
616 // but WITHOUT ANY WARRANTY; without even the implied warranty of
617 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
618 // GNU General Public License for more details.
619 
620 // You should have received a copy of the GNU General Public License
621 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
622 
623 /*  */
624 
625 /* import "ds-thing/thing.sol"; */
626 /* import "ds-token/token.sol"; */
627 /* import "ds-value/value.sol"; */
628 
629 /* import "./vox.sol"; */
630 
631 contract SaiTubEvents {
632     event LogNewCup(address indexed lad, bytes32 cup);
633 }
634 
635 contract SaiTub is DSThing, SaiTubEvents {
636     DSToken  public  sai;  // Stablecoin
637     DSToken  public  sin;  // Debt (negative sai)
638 
639     DSToken  public  skr;  // Abstracted collateral
640     ERC20    public  gem;  // Underlying collateral
641 
642     DSToken  public  gov;  // Governance token
643 
644     SaiVox   public  vox;  // Target price feed
645     DSValue  public  pip;  // Reference price feed
646     DSValue  public  pep;  // Governance price feed
647 
648     address  public  tap;  // Liquidator
649     address  public  pit;  // Governance Vault
650 
651     uint256  public  axe;  // Liquidation penalty
652     uint256  public  cap;  // Debt ceiling
653     uint256  public  mat;  // Liquidation ratio
654     uint256  public  tax;  // Stability fee
655     uint256  public  fee;  // Governance fee
656     uint256  public  gap;  // Join-Exit Spread
657 
658     bool     public  off;  // Cage flag
659     bool     public  out;  // Post cage exit
660 
661     uint256  public  fit;  // REF per SKR (just before settlement)
662 
663     uint256  public  rho;  // Time of last drip
664     uint256         _chi;  // Accumulated Tax Rates
665     uint256         _rhi;  // Accumulated Tax + Fee Rates
666     uint256  public  rum;  // Total normalised debt
667 
668     uint256                   public  cupi;
669     mapping (bytes32 => Cup)  public  cups;
670 
671     struct Cup {
672         address  lad;      // CDP owner
673         uint256  ink;      // Locked collateral (in SKR)
674         uint256  art;      // Outstanding normalised debt (tax only)
675         uint256  ire;      // Outstanding normalised debt
676     }
677 
678     function lad(bytes32 cup) public view returns (address) {
679         return cups[cup].lad;
680     }
681     function ink(bytes32 cup) public view returns (uint) {
682         return cups[cup].ink;
683     }
684     function tab(bytes32 cup) public returns (uint) {
685         return rmul(cups[cup].art, chi());
686     }
687     function rap(bytes32 cup) public returns (uint) {
688         return sub(rmul(cups[cup].ire, rhi()), tab(cup));
689     }
690 
691     // Total CDP Debt
692     function din() public returns (uint) {
693         return rmul(rum, chi());
694     }
695     // Backing collateral
696     function air() public view returns (uint) {
697         return skr.balanceOf(this);
698     }
699     // Raw collateral
700     function pie() public view returns (uint) {
701         return gem.balanceOf(this);
702     }
703 
704     //------------------------------------------------------------------
705 
706     function SaiTub(
707         DSToken  sai_,
708         DSToken  sin_,
709         DSToken  skr_,
710         ERC20    gem_,
711         DSToken  gov_,
712         DSValue  pip_,
713         DSValue  pep_,
714         SaiVox   vox_,
715         address  pit_
716     ) public {
717         gem = gem_;
718         skr = skr_;
719 
720         sai = sai_;
721         sin = sin_;
722 
723         gov = gov_;
724         pit = pit_;
725 
726         pip = pip_;
727         pep = pep_;
728         vox = vox_;
729 
730         axe = RAY;
731         mat = RAY;
732         tax = RAY;
733         fee = RAY;
734         gap = WAD;
735 
736         _chi = RAY;
737         _rhi = RAY;
738 
739         rho = era();
740     }
741 
742     function era() public constant returns (uint) {
743         return block.timestamp;
744     }
745 
746     //--Risk-parameter-config-------------------------------------------
747 
748     function mold(bytes32 param, uint val) public note auth {
749         if      (param == 'cap') cap = val;
750         else if (param == 'mat') { require(val >= RAY); mat = val; }
751         else if (param == 'tax') { require(val >= RAY); drip(); tax = val; }
752         else if (param == 'fee') { require(val >= RAY); drip(); fee = val; }
753         else if (param == 'axe') { require(val >= RAY); axe = val; }
754         else if (param == 'gap') { require(val >= WAD); gap = val; }
755         else return;
756     }
757 
758     //--Price-feed-setters----------------------------------------------
759 
760     function setPip(DSValue pip_) public note auth {
761         pip = pip_;
762     }
763     function setPep(DSValue pep_) public note auth {
764         pep = pep_;
765     }
766     function setVox(SaiVox vox_) public note auth {
767         vox = vox_;
768     }
769 
770     //--Tap-setter------------------------------------------------------
771     function turn(address tap_) public note {
772         require(tap  == 0);
773         require(tap_ != 0);
774         tap = tap_;
775     }
776 
777     //--Collateral-wrapper----------------------------------------------
778 
779     // Wrapper ratio (gem per skr)
780     function per() public view returns (uint ray) {
781         return skr.totalSupply() == 0 ? RAY : rdiv(pie(), skr.totalSupply());
782     }
783     // Join price (gem per skr)
784     function ask(uint wad) public view returns (uint) {
785         return rmul(wad, wmul(per(), gap));
786     }
787     // Exit price (gem per skr)
788     function bid(uint wad) public view returns (uint) {
789         return rmul(wad, wmul(per(), sub(2 * WAD, gap)));
790     }
791     function join(uint wad) public note {
792         require(!off);
793         require(ask(wad) > 0);
794         require(gem.transferFrom(msg.sender, this, ask(wad)));
795         skr.mint(msg.sender, wad);
796     }
797     function exit(uint wad) public note {
798         require(!off || out);
799         require(gem.transfer(msg.sender, bid(wad)));
800         skr.burn(msg.sender, wad);
801     }
802 
803     //--Stability-fee-accumulation--------------------------------------
804 
805     // Accumulated Rates
806     function chi() public returns (uint) {
807         drip();
808         return _chi;
809     }
810     function rhi() public returns (uint) {
811         drip();
812         return _rhi;
813     }
814     function drip() public note {
815         if (off) return;
816 
817         var rho_ = era();
818         var age = rho_ - rho;
819         if (age == 0) return;    // optimised
820         rho = rho_;
821 
822         var inc = RAY;
823 
824         if (tax != RAY) {  // optimised
825             var _chi_ = _chi;
826             inc = rpow(tax, age);
827             _chi = rmul(_chi, inc);
828             sai.mint(tap, rmul(sub(_chi, _chi_), rum));
829         }
830 
831         // optimised
832         if (fee != RAY) inc = rmul(inc, rpow(fee, age));
833         if (inc != RAY) _rhi = rmul(_rhi, inc);
834     }
835 
836 
837     //--CDP-risk-indicator----------------------------------------------
838 
839     // Abstracted collateral price (ref per skr)
840     function tag() public view returns (uint wad) {
841         return off ? fit : wmul(per(), uint(pip.read()));
842     }
843     // Returns true if cup is well-collateralized
844     function safe(bytes32 cup) public returns (bool) {
845         var pro = rmul(tag(), ink(cup));
846         var con = rmul(vox.par(), tab(cup));
847         var min = rmul(con, mat);
848         return pro >= min;
849     }
850 
851 
852     //--CDP-operations--------------------------------------------------
853 
854     function open() public note returns (bytes32 cup) {
855         require(!off);
856         cupi = add(cupi, 1);
857         cup = bytes32(cupi);
858         cups[cup].lad = msg.sender;
859         LogNewCup(msg.sender, cup);
860     }
861     function give(bytes32 cup, address guy) public note {
862         require(msg.sender == cups[cup].lad);
863         require(guy != 0);
864         cups[cup].lad = guy;
865     }
866 
867     function lock(bytes32 cup, uint wad) public note {
868         require(!off);
869         cups[cup].ink = add(cups[cup].ink, wad);
870         skr.pull(msg.sender, wad);
871         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
872     }
873     function free(bytes32 cup, uint wad) public note {
874         require(msg.sender == cups[cup].lad);
875         cups[cup].ink = sub(cups[cup].ink, wad);
876         skr.push(msg.sender, wad);
877         require(safe(cup));
878         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
879     }
880 
881     function draw(bytes32 cup, uint wad) public note {
882         require(!off);
883         require(msg.sender == cups[cup].lad);
884         require(rdiv(wad, chi()) > 0);
885 
886         cups[cup].art = add(cups[cup].art, rdiv(wad, chi()));
887         rum = add(rum, rdiv(wad, chi()));
888 
889         cups[cup].ire = add(cups[cup].ire, rdiv(wad, rhi()));
890         sai.mint(cups[cup].lad, wad);
891 
892         require(safe(cup));
893         require(sai.totalSupply() <= cap);
894     }
895     function wipe(bytes32 cup, uint wad) public note {
896         require(!off);
897 
898         var owe = rmul(wad, rdiv(rap(cup), tab(cup)));
899 
900         cups[cup].art = sub(cups[cup].art, rdiv(wad, chi()));
901         rum = sub(rum, rdiv(wad, chi()));
902 
903         cups[cup].ire = sub(cups[cup].ire, rdiv(add(wad, owe), rhi()));
904         sai.burn(msg.sender, wad);
905 
906         var (val, ok) = pep.peek();
907         if (ok && val != 0) gov.move(msg.sender, pit, wdiv(owe, uint(val)));
908     }
909 
910     function shut(bytes32 cup) public note {
911         require(!off);
912         require(msg.sender == cups[cup].lad);
913         if (tab(cup) != 0) wipe(cup, tab(cup));
914         if (ink(cup) != 0) free(cup, ink(cup));
915         delete cups[cup];
916     }
917 
918     function bite(bytes32 cup) public note {
919         require(!safe(cup) || off);
920 
921         // Take on all of the debt, except unpaid fees
922         var rue = tab(cup);
923         sin.mint(tap, rue);
924         rum = sub(rum, cups[cup].art);
925         cups[cup].art = 0;
926         cups[cup].ire = 0;
927 
928         // Amount owed in SKR, including liquidation penalty
929         var owe = rdiv(rmul(rmul(rue, axe), vox.par()), tag());
930 
931         if (owe > cups[cup].ink) {
932             owe = cups[cup].ink;
933         }
934 
935         skr.push(tap, owe);
936         cups[cup].ink = sub(cups[cup].ink, owe);
937     }
938 
939     //------------------------------------------------------------------
940 
941     function cage(uint fit_, uint jam) public note auth {
942         require(!off && fit_ != 0);
943         off = true;
944         axe = RAY;
945         gap = WAD;
946         fit = fit_;         // ref per skr
947         require(gem.transfer(tap, jam));
948     }
949     function flow() public note auth {
950         require(off);
951         out = true;
952     }
953 }
954 // Copyright (C) 2015, 2016, 2017 Dapphub
955 
956 // This program is free software: you can redistribute it and/or modify
957 // it under the terms of the GNU General Public License as published by
958 // the Free Software Foundation, either version 3 of the License, or
959 // (at your option) any later version.
960 
961 // This program is distributed in the hope that it will be useful,
962 // but WITHOUT ANY WARRANTY; without even the implied warranty of
963 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
964 // GNU General Public License for more details.
965 
966 // You should have received a copy of the GNU General Public License
967 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
968 
969 
970 
971 contract WETH9 {
972     string public name     = "Wrapped Ether";
973     string public symbol   = "WETH";
974     uint8  public decimals = 18;
975 
976     event  Approval(address indexed src, address indexed guy, uint wad);
977     event  Transfer(address indexed src, address indexed dst, uint wad);
978     event  Deposit(address indexed dst, uint wad);
979     event  Withdrawal(address indexed src, uint wad);
980 
981     mapping (address => uint)                       public  balanceOf;
982     mapping (address => mapping (address => uint))  public  allowance;
983 
984     function() public payable {
985         deposit();
986     }
987     function deposit() public payable {
988         balanceOf[msg.sender] += msg.value;
989         Deposit(msg.sender, msg.value);
990     }
991     function withdraw(uint wad) public {
992         require(balanceOf[msg.sender] >= wad);
993         balanceOf[msg.sender] -= wad;
994         msg.sender.transfer(wad);
995         Withdrawal(msg.sender, wad);
996     }
997 
998     function totalSupply() public view returns (uint) {
999         return this.balance;
1000     }
1001 
1002     function approve(address guy, uint wad) public returns (bool) {
1003         allowance[msg.sender][guy] = wad;
1004         Approval(msg.sender, guy, wad);
1005         return true;
1006     }
1007 
1008     function transfer(address dst, uint wad) public returns (bool) {
1009         return transferFrom(msg.sender, dst, wad);
1010     }
1011 
1012     function transferFrom(address src, address dst, uint wad)
1013         public
1014         returns (bool)
1015     {
1016         require(balanceOf[src] >= wad);
1017 
1018         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
1019             require(allowance[src][msg.sender] >= wad);
1020             allowance[src][msg.sender] -= wad;
1021         }
1022 
1023         balanceOf[src] -= wad;
1024         balanceOf[dst] += wad;
1025 
1026         Transfer(src, dst, wad);
1027 
1028         return true;
1029     }
1030 }
1031 
1032 
1033 /*
1034                     GNU GENERAL PUBLIC LICENSE
1035                        Version 3, 29 June 2007
1036 
1037  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
1038  Everyone is permitted to copy and distribute verbatim copies
1039  of this license document, but changing it is not allowed.
1040 
1041                             Preamble
1042 
1043   The GNU General Public License is a free, copyleft license for
1044 software and other kinds of works.
1045 
1046   The licenses for most software and other practical works are designed
1047 to take away your freedom to share and change the works.  By contrast,
1048 the GNU General Public License is intended to guarantee your freedom to
1049 share and change all versions of a program--to make sure it remains free
1050 software for all its users.  We, the Free Software Foundation, use the
1051 GNU General Public License for most of our software; it applies also to
1052 any other work released this way by its authors.  You can apply it to
1053 your programs, too.
1054 
1055   When we speak of free software, we are referring to freedom, not
1056 price.  Our General Public Licenses are designed to make sure that you
1057 have the freedom to distribute copies of free software (and charge for
1058 them if you wish), that you receive source code or can get it if you
1059 want it, that you can change the software or use pieces of it in new
1060 free programs, and that you know you can do these things.
1061 
1062   To protect your rights, we need to prevent others from denying you
1063 these rights or asking you to surrender the rights.  Therefore, you have
1064 certain responsibilities if you distribute copies of the software, or if
1065 you modify it: responsibilities to respect the freedom of others.
1066 
1067   For example, if you distribute copies of such a program, whether
1068 gratis or for a fee, you must pass on to the recipients the same
1069 freedoms that you received.  You must make sure that they, too, receive
1070 or can get the source code.  And you must show them these terms so they
1071 know their rights.
1072 
1073   Developers that use the GNU GPL protect your rights with two steps:
1074 (1) assert copyright on the software, and (2) offer you this License
1075 giving you legal permission to copy, distribute and/or modify it.
1076 
1077   For the developers' and authors' protection, the GPL clearly explains
1078 that there is no warranty for this free software.  For both users' and
1079 authors' sake, the GPL requires that modified versions be marked as
1080 changed, so that their problems will not be attributed erroneously to
1081 authors of previous versions.
1082 
1083   Some devices are designed to deny users access to install or run
1084 modified versions of the software inside them, although the manufacturer
1085 can do so.  This is fundamentally incompatible with the aim of
1086 protecting users' freedom to change the software.  The systematic
1087 pattern of such abuse occurs in the area of products for individuals to
1088 use, which is precisely where it is most unacceptable.  Therefore, we
1089 have designed this version of the GPL to prohibit the practice for those
1090 products.  If such problems arise substantially in other domains, we
1091 stand ready to extend this provision to those domains in future versions
1092 of the GPL, as needed to protect the freedom of users.
1093 
1094   Finally, every program is threatened constantly by software patents.
1095 States should not allow patents to restrict development and use of
1096 software on general-purpose computers, but in those that do, we wish to
1097 avoid the special danger that patents applied to a free program could
1098 make it effectively proprietary.  To prevent this, the GPL assures that
1099 patents cannot be used to render the program non-free.
1100 
1101   The precise terms and conditions for copying, distribution and
1102 modification follow.
1103 
1104                        TERMS AND CONDITIONS
1105 
1106   0. Definitions.
1107 
1108   "This License" refers to version 3 of the GNU General Public License.
1109 
1110   "Copyright" also means copyright-like laws that apply to other kinds of
1111 works, such as semiconductor masks.
1112 
1113   "The Program" refers to any copyrightable work licensed under this
1114 License.  Each licensee is addressed as "you".  "Licensees" and
1115 "recipients" may be individuals or organizations.
1116 
1117   To "modify" a work means to copy from or adapt all or part of the work
1118 in a fashion requiring copyright permission, other than the making of an
1119 exact copy.  The resulting work is called a "modified version" of the
1120 earlier work or a work "based on" the earlier work.
1121 
1122   A "covered work" means either the unmodified Program or a work based
1123 on the Program.
1124 
1125   To "propagate" a work means to do anything with it that, without
1126 permission, would make you directly or secondarily liable for
1127 infringement under applicable copyright law, except executing it on a
1128 computer or modifying a private copy.  Propagation includes copying,
1129 distribution (with or without modification), making available to the
1130 public, and in some countries other activities as well.
1131 
1132   To "convey" a work means any kind of propagation that enables other
1133 parties to make or receive copies.  Mere interaction with a user through
1134 a computer network, with no transfer of a copy, is not conveying.
1135 
1136   An interactive user interface displays "Appropriate Legal Notices"
1137 to the extent that it includes a convenient and prominently visible
1138 feature that (1) displays an appropriate copyright notice, and (2)
1139 tells the user that there is no warranty for the work (except to the
1140 extent that warranties are provided), that licensees may convey the
1141 work under this License, and how to view a copy of this License.  If
1142 the interface presents a list of user commands or options, such as a
1143 menu, a prominent item in the list meets this criterion.
1144 
1145   1. Source Code.
1146 
1147   The "source code" for a work means the preferred form of the work
1148 for making modifications to it.  "Object code" means any non-source
1149 form of a work.
1150 
1151   A "Standard Interface" means an interface that either is an official
1152 standard defined by a recognized standards body, or, in the case of
1153 interfaces specified for a particular programming language, one that
1154 is widely used among developers working in that language.
1155 
1156   The "System Libraries" of an executable work include anything, other
1157 than the work as a whole, that (a) is included in the normal form of
1158 packaging a Major Component, but which is not part of that Major
1159 Component, and (b) serves only to enable use of the work with that
1160 Major Component, or to implement a Standard Interface for which an
1161 implementation is available to the public in source code form.  A
1162 "Major Component", in this context, means a major essential component
1163 (kernel, window system, and so on) of the specific operating system
1164 (if any) on which the executable work runs, or a compiler used to
1165 produce the work, or an object code interpreter used to run it.
1166 
1167   The "Corresponding Source" for a work in object code form means all
1168 the source code needed to generate, install, and (for an executable
1169 work) run the object code and to modify the work, including scripts to
1170 control those activities.  However, it does not include the work's
1171 System Libraries, or general-purpose tools or generally available free
1172 programs which are used unmodified in performing those activities but
1173 which are not part of the work.  For example, Corresponding Source
1174 includes interface definition files associated with source files for
1175 the work, and the source code for shared libraries and dynamically
1176 linked subprograms that the work is specifically designed to require,
1177 such as by intimate data communication or control flow between those
1178 subprograms and other parts of the work.
1179 
1180   The Corresponding Source need not include anything that users
1181 can regenerate automatically from other parts of the Corresponding
1182 Source.
1183 
1184   The Corresponding Source for a work in source code form is that
1185 same work.
1186 
1187   2. Basic Permissions.
1188 
1189   All rights granted under this License are granted for the term of
1190 copyright on the Program, and are irrevocable provided the stated
1191 conditions are met.  This License explicitly affirms your unlimited
1192 permission to run the unmodified Program.  The output from running a
1193 covered work is covered by this License only if the output, given its
1194 content, constitutes a covered work.  This License acknowledges your
1195 rights of fair use or other equivalent, as provided by copyright law.
1196 
1197   You may make, run and propagate covered works that you do not
1198 convey, without conditions so long as your license otherwise remains
1199 in force.  You may convey covered works to others for the sole purpose
1200 of having them make modifications exclusively for you, or provide you
1201 with facilities for running those works, provided that you comply with
1202 the terms of this License in conveying all material for which you do
1203 not control copyright.  Those thus making or running the covered works
1204 for you must do so exclusively on your behalf, under your direction
1205 and control, on terms that prohibit them from making any copies of
1206 your copyrighted material outside their relationship with you.
1207 
1208   Conveying under any other circumstances is permitted solely under
1209 the conditions stated below.  Sublicensing is not allowed; section 10
1210 makes it unnecessary.
1211 
1212   3. Protecting Users' Legal Rights From Anti-Circumvention Law.
1213 
1214   No covered work shall be deemed part of an effective technological
1215 measure under any applicable law fulfilling obligations under article
1216 11 of the WIPO copyright treaty adopted on 20 December 1996, or
1217 similar laws prohibiting or restricting circumvention of such
1218 measures.
1219 
1220   When you convey a covered work, you waive any legal power to forbid
1221 circumvention of technological measures to the extent such circumvention
1222 is effected by exercising rights under this License with respect to
1223 the covered work, and you disclaim any intention to limit operation or
1224 modification of the work as a means of enforcing, against the work's
1225 users, your or third parties' legal rights to forbid circumvention of
1226 technological measures.
1227 
1228   4. Conveying Verbatim Copies.
1229 
1230   You may convey verbatim copies of the Program's source code as you
1231 receive it, in any medium, provided that you conspicuously and
1232 appropriately publish on each copy an appropriate copyright notice;
1233 keep intact all notices stating that this License and any
1234 non-permissive terms added in accord with section 7 apply to the code;
1235 keep intact all notices of the absence of any warranty; and give all
1236 recipients a copy of this License along with the Program.
1237 
1238   You may charge any price or no price for each copy that you convey,
1239 and you may offer support or warranty protection for a fee.
1240 
1241   5. Conveying Modified Source Versions.
1242 
1243   You may convey a work based on the Program, or the modifications to
1244 produce it from the Program, in the form of source code under the
1245 terms of section 4, provided that you also meet all of these conditions:
1246 
1247     a) The work must carry prominent notices stating that you modified
1248     it, and giving a relevant date.
1249 
1250     b) The work must carry prominent notices stating that it is
1251     released under this License and any conditions added under section
1252     7.  This requirement modifies the requirement in section 4 to
1253     "keep intact all notices".
1254 
1255     c) You must license the entire work, as a whole, under this
1256     License to anyone who comes into possession of a copy.  This
1257     License will therefore apply, along with any applicable section 7
1258     additional terms, to the whole of the work, and all its parts,
1259     regardless of how they are packaged.  This License gives no
1260     permission to license the work in any other way, but it does not
1261     invalidate such permission if you have separately received it.
1262 
1263     d) If the work has interactive user interfaces, each must display
1264     Appropriate Legal Notices; however, if the Program has interactive
1265     interfaces that do not display Appropriate Legal Notices, your
1266     work need not make them do so.
1267 
1268   A compilation of a covered work with other separate and independent
1269 works, which are not by their nature extensions of the covered work,
1270 and which are not combined with it such as to form a larger program,
1271 in or on a volume of a storage or distribution medium, is called an
1272 "aggregate" if the compilation and its resulting copyright are not
1273 used to limit the access or legal rights of the compilation's users
1274 beyond what the individual works permit.  Inclusion of a covered work
1275 in an aggregate does not cause this License to apply to the other
1276 parts of the aggregate.
1277 
1278   6. Conveying Non-Source Forms.
1279 
1280   You may convey a covered work in object code form under the terms
1281 of sections 4 and 5, provided that you also convey the
1282 machine-readable Corresponding Source under the terms of this License,
1283 in one of these ways:
1284 
1285     a) Convey the object code in, or embodied in, a physical product
1286     (including a physical distribution medium), accompanied by the
1287     Corresponding Source fixed on a durable physical medium
1288     customarily used for software interchange.
1289 
1290     b) Convey the object code in, or embodied in, a physical product
1291     (including a physical distribution medium), accompanied by a
1292     written offer, valid for at least three years and valid for as
1293     long as you offer spare parts or customer support for that product
1294     model, to give anyone who possesses the object code either (1) a
1295     copy of the Corresponding Source for all the software in the
1296     product that is covered by this License, on a durable physical
1297     medium customarily used for software interchange, for a price no
1298     more than your reasonable cost of physically performing this
1299     conveying of source, or (2) access to copy the
1300     Corresponding Source from a network server at no charge.
1301 
1302     c) Convey individual copies of the object code with a copy of the
1303     written offer to provide the Corresponding Source.  This
1304     alternative is allowed only occasionally and noncommercially, and
1305     only if you received the object code with such an offer, in accord
1306     with subsection 6b.
1307 
1308     d) Convey the object code by offering access from a designated
1309     place (gratis or for a charge), and offer equivalent access to the
1310     Corresponding Source in the same way through the same place at no
1311     further charge.  You need not require recipients to copy the
1312     Corresponding Source along with the object code.  If the place to
1313     copy the object code is a network server, the Corresponding Source
1314     may be on a different server (operated by you or a third party)
1315     that supports equivalent copying facilities, provided you maintain
1316     clear directions next to the object code saying where to find the
1317     Corresponding Source.  Regardless of what server hosts the
1318     Corresponding Source, you remain obligated to ensure that it is
1319     available for as long as needed to satisfy these requirements.
1320 
1321     e) Convey the object code using peer-to-peer transmission, provided
1322     you inform other peers where the object code and Corresponding
1323     Source of the work are being offered to the general public at no
1324     charge under subsection 6d.
1325 
1326   A separable portion of the object code, whose source code is excluded
1327 from the Corresponding Source as a System Library, need not be
1328 included in conveying the object code work.
1329 
1330   A "User Product" is either (1) a "consumer product", which means any
1331 tangible personal property which is normally used for personal, family,
1332 or household purposes, or (2) anything designed or sold for incorporation
1333 into a dwelling.  In determining whether a product is a consumer product,
1334 doubtful cases shall be resolved in favor of coverage.  For a particular
1335 product received by a particular user, "normally used" refers to a
1336 typical or common use of that class of product, regardless of the status
1337 of the particular user or of the way in which the particular user
1338 actually uses, or expects or is expected to use, the product.  A product
1339 is a consumer product regardless of whether the product has substantial
1340 commercial, industrial or non-consumer uses, unless such uses represent
1341 the only significant mode of use of the product.
1342 
1343   "Installation Information" for a User Product means any methods,
1344 procedures, authorization keys, or other information required to install
1345 and execute modified versions of a covered work in that User Product from
1346 a modified version of its Corresponding Source.  The information must
1347 suffice to ensure that the continued functioning of the modified object
1348 code is in no case prevented or interfered with solely because
1349 modification has been made.
1350 
1351   If you convey an object code work under this section in, or with, or
1352 specifically for use in, a User Product, and the conveying occurs as
1353 part of a transaction in which the right of possession and use of the
1354 User Product is transferred to the recipient in perpetuity or for a
1355 fixed term (regardless of how the transaction is characterized), the
1356 Corresponding Source conveyed under this section must be accompanied
1357 by the Installation Information.  But this requirement does not apply
1358 if neither you nor any third party retains the ability to install
1359 modified object code on the User Product (for example, the work has
1360 been installed in ROM).
1361 
1362   The requirement to provide Installation Information does not include a
1363 requirement to continue to provide support service, warranty, or updates
1364 for a work that has been modified or installed by the recipient, or for
1365 the User Product in which it has been modified or installed.  Access to a
1366 network may be denied when the modification itself materially and
1367 adversely affects the operation of the network or violates the rules and
1368 protocols for communication across the network.
1369 
1370   Corresponding Source conveyed, and Installation Information provided,
1371 in accord with this section must be in a format that is publicly
1372 documented (and with an implementation available to the public in
1373 source code form), and must require no special password or key for
1374 unpacking, reading or copying.
1375 
1376   7. Additional Terms.
1377 
1378   "Additional permissions" are terms that supplement the terms of this
1379 License by making exceptions from one or more of its conditions.
1380 Additional permissions that are applicable to the entire Program shall
1381 be treated as though they were included in this License, to the extent
1382 that they are valid under applicable law.  If additional permissions
1383 apply only to part of the Program, that part may be used separately
1384 under those permissions, but the entire Program remains governed by
1385 this License without regard to the additional permissions.
1386 
1387   When you convey a copy of a covered work, you may at your option
1388 remove any additional permissions from that copy, or from any part of
1389 it.  (Additional permissions may be written to require their own
1390 removal in certain cases when you modify the work.)  You may place
1391 additional permissions on material, added by you to a covered work,
1392 for which you have or can give appropriate copyright permission.
1393 
1394   Notwithstanding any other provision of this License, for material you
1395 add to a covered work, you may (if authorized by the copyright holders of
1396 that material) supplement the terms of this License with terms:
1397 
1398     a) Disclaiming warranty or limiting liability differently from the
1399     terms of sections 15 and 16 of this License; or
1400 
1401     b) Requiring preservation of specified reasonable legal notices or
1402     author attributions in that material or in the Appropriate Legal
1403     Notices displayed by works containing it; or
1404 
1405     c) Prohibiting misrepresentation of the origin of that material, or
1406     requiring that modified versions of such material be marked in
1407     reasonable ways as different from the original version; or
1408 
1409     d) Limiting the use for publicity purposes of names of licensors or
1410     authors of the material; or
1411 
1412     e) Declining to grant rights under trademark law for use of some
1413     trade names, trademarks, or service marks; or
1414 
1415     f) Requiring indemnification of licensors and authors of that
1416     material by anyone who conveys the material (or modified versions of
1417     it) with contractual assumptions of liability to the recipient, for
1418     any liability that these contractual assumptions directly impose on
1419     those licensors and authors.
1420 
1421   All other non-permissive additional terms are considered "further
1422 restrictions" within the meaning of section 10.  If the Program as you
1423 received it, or any part of it, contains a notice stating that it is
1424 governed by this License along with a term that is a further
1425 restriction, you may remove that term.  If a license document contains
1426 a further restriction but permits relicensing or conveying under this
1427 License, you may add to a covered work material governed by the terms
1428 of that license document, provided that the further restriction does
1429 not survive such relicensing or conveying.
1430 
1431   If you add terms to a covered work in accord with this section, you
1432 must place, in the relevant source files, a statement of the
1433 additional terms that apply to those files, or a notice indicating
1434 where to find the applicable terms.
1435 
1436   Additional terms, permissive or non-permissive, may be stated in the
1437 form of a separately written license, or stated as exceptions;
1438 the above requirements apply either way.
1439 
1440   8. Termination.
1441 
1442   You may not propagate or modify a covered work except as expressly
1443 provided under this License.  Any attempt otherwise to propagate or
1444 modify it is void, and will automatically terminate your rights under
1445 this License (including any patent licenses granted under the third
1446 paragraph of section 11).
1447 
1448   However, if you cease all violation of this License, then your
1449 license from a particular copyright holder is reinstated (a)
1450 provisionally, unless and until the copyright holder explicitly and
1451 finally terminates your license, and (b) permanently, if the copyright
1452 holder fails to notify you of the violation by some reasonable means
1453 prior to 60 days after the cessation.
1454 
1455   Moreover, your license from a particular copyright holder is
1456 reinstated permanently if the copyright holder notifies you of the
1457 violation by some reasonable means, this is the first time you have
1458 received notice of violation of this License (for any work) from that
1459 copyright holder, and you cure the violation prior to 30 days after
1460 your receipt of the notice.
1461 
1462   Termination of your rights under this section does not terminate the
1463 licenses of parties who have received copies or rights from you under
1464 this License.  If your rights have been terminated and not permanently
1465 reinstated, you do not qualify to receive new licenses for the same
1466 material under section 10.
1467 
1468   9. Acceptance Not Required for Having Copies.
1469 
1470   You are not required to accept this License in order to receive or
1471 run a copy of the Program.  Ancillary propagation of a covered work
1472 occurring solely as a consequence of using peer-to-peer transmission
1473 to receive a copy likewise does not require acceptance.  However,
1474 nothing other than this License grants you permission to propagate or
1475 modify any covered work.  These actions infringe copyright if you do
1476 not accept this License.  Therefore, by modifying or propagating a
1477 covered work, you indicate your acceptance of this License to do so.
1478 
1479   10. Automatic Licensing of Downstream Recipients.
1480 
1481   Each time you convey a covered work, the recipient automatically
1482 receives a license from the original licensors, to run, modify and
1483 propagate that work, subject to this License.  You are not responsible
1484 for enforcing compliance by third parties with this License.
1485 
1486   An "entity transaction" is a transaction transferring control of an
1487 organization, or substantially all assets of one, or subdividing an
1488 organization, or merging organizations.  If propagation of a covered
1489 work results from an entity transaction, each party to that
1490 transaction who receives a copy of the work also receives whatever
1491 licenses to the work the party's predecessor in interest had or could
1492 give under the previous paragraph, plus a right to possession of the
1493 Corresponding Source of the work from the predecessor in interest, if
1494 the predecessor has it or can get it with reasonable efforts.
1495 
1496   You may not impose any further restrictions on the exercise of the
1497 rights granted or affirmed under this License.  For example, you may
1498 not impose a license fee, royalty, or other charge for exercise of
1499 rights granted under this License, and you may not initiate litigation
1500 (including a cross-claim or counterclaim in a lawsuit) alleging that
1501 any patent claim is infringed by making, using, selling, offering for
1502 sale, or importing the Program or any portion of it.
1503 
1504   11. Patents.
1505 
1506   A "contributor" is a copyright holder who authorizes use under this
1507 License of the Program or a work on which the Program is based.  The
1508 work thus licensed is called the contributor's "contributor version".
1509 
1510   A contributor's "essential patent claims" are all patent claims
1511 owned or controlled by the contributor, whether already acquired or
1512 hereafter acquired, that would be infringed by some manner, permitted
1513 by this License, of making, using, or selling its contributor version,
1514 but do not include claims that would be infringed only as a
1515 consequence of further modification of the contributor version.  For
1516 purposes of this definition, "control" includes the right to grant
1517 patent sublicenses in a manner consistent with the requirements of
1518 this License.
1519 
1520   Each contributor grants you a non-exclusive, worldwide, royalty-free
1521 patent license under the contributor's essential patent claims, to
1522 make, use, sell, offer for sale, import and otherwise run, modify and
1523 propagate the contents of its contributor version.
1524 
1525   In the following three paragraphs, a "patent license" is any express
1526 agreement or commitment, however denominated, not to enforce a patent
1527 (such as an express permission to practice a patent or covenant not to
1528 sue for patent infringement).  To "grant" such a patent license to a
1529 party means to make such an agreement or commitment not to enforce a
1530 patent against the party.
1531 
1532   If you convey a covered work, knowingly relying on a patent license,
1533 and the Corresponding Source of the work is not available for anyone
1534 to copy, free of charge and under the terms of this License, through a
1535 publicly available network server or other readily accessible means,
1536 then you must either (1) cause the Corresponding Source to be so
1537 available, or (2) arrange to deprive yourself of the benefit of the
1538 patent license for this particular work, or (3) arrange, in a manner
1539 consistent with the requirements of this License, to extend the patent
1540 license to downstream recipients.  "Knowingly relying" means you have
1541 actual knowledge that, but for the patent license, your conveying the
1542 covered work in a country, or your recipient's use of the covered work
1543 in a country, would infringe one or more identifiable patents in that
1544 country that you have reason to believe are valid.
1545 
1546   If, pursuant to or in connection with a single transaction or
1547 arrangement, you convey, or propagate by procuring conveyance of, a
1548 covered work, and grant a patent license to some of the parties
1549 receiving the covered work authorizing them to use, propagate, modify
1550 or convey a specific copy of the covered work, then the patent license
1551 you grant is automatically extended to all recipients of the covered
1552 work and works based on it.
1553 
1554   A patent license is "discriminatory" if it does not include within
1555 the scope of its coverage, prohibits the exercise of, or is
1556 conditioned on the non-exercise of one or more of the rights that are
1557 specifically granted under this License.  You may not convey a covered
1558 work if you are a party to an arrangement with a third party that is
1559 in the business of distributing software, under which you make payment
1560 to the third party based on the extent of your activity of conveying
1561 the work, and under which the third party grants, to any of the
1562 parties who would receive the covered work from you, a discriminatory
1563 patent license (a) in connection with copies of the covered work
1564 conveyed by you (or copies made from those copies), or (b) primarily
1565 for and in connection with specific products or compilations that
1566 contain the covered work, unless you entered into that arrangement,
1567 or that patent license was granted, prior to 28 March 2007.
1568 
1569   Nothing in this License shall be construed as excluding or limiting
1570 any implied license or other defenses to infringement that may
1571 otherwise be available to you under applicable patent law.
1572 
1573   12. No Surrender of Others' Freedom.
1574 
1575   If conditions are imposed on you (whether by court order, agreement or
1576 otherwise) that contradict the conditions of this License, they do not
1577 excuse you from the conditions of this License.  If you cannot convey a
1578 covered work so as to satisfy simultaneously your obligations under this
1579 License and any other pertinent obligations, then as a consequence you may
1580 not convey it at all.  For example, if you agree to terms that obligate you
1581 to collect a royalty for further conveying from those to whom you convey
1582 the Program, the only way you could satisfy both those terms and this
1583 License would be to refrain entirely from conveying the Program.
1584 
1585   13. Use with the GNU Affero General Public License.
1586 
1587   Notwithstanding any other provision of this License, you have
1588 permission to link or combine any covered work with a work licensed
1589 under version 3 of the GNU Affero General Public License into a single
1590 combined work, and to convey the resulting work.  The terms of this
1591 License will continue to apply to the part which is the covered work,
1592 but the special requirements of the GNU Affero General Public License,
1593 section 13, concerning interaction through a network will apply to the
1594 combination as such.
1595 
1596   14. Revised Versions of this License.
1597 
1598   The Free Software Foundation may publish revised and/or new versions of
1599 the GNU General Public License from time to time.  Such new versions will
1600 be similar in spirit to the present version, but may differ in detail to
1601 address new problems or concerns.
1602 
1603   Each version is given a distinguishing version number.  If the
1604 Program specifies that a certain numbered version of the GNU General
1605 Public License "or any later version" applies to it, you have the
1606 option of following the terms and conditions either of that numbered
1607 version or of any later version published by the Free Software
1608 Foundation.  If the Program does not specify a version number of the
1609 GNU General Public License, you may choose any version ever published
1610 by the Free Software Foundation.
1611 
1612   If the Program specifies that a proxy can decide which future
1613 versions of the GNU General Public License can be used, that proxy's
1614 public statement of acceptance of a version permanently authorizes you
1615 to choose that version for the Program.
1616 
1617   Later license versions may give you additional or different
1618 permissions.  However, no additional obligations are imposed on any
1619 author or copyright holder as a result of your choosing to follow a
1620 later version.
1621 
1622   15. Disclaimer of Warranty.
1623 
1624   THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
1625 APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
1626 HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
1627 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
1628 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
1629 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
1630 IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
1631 ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
1632 
1633   16. Limitation of Liability.
1634 
1635   IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
1636 WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
1637 THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
1638 GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
1639 USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
1640 DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
1641 PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
1642 EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
1643 SUCH DAMAGES.
1644 
1645   17. Interpretation of Sections 15 and 16.
1646 
1647   If the disclaimer of warranty and limitation of liability provided
1648 above cannot be given local legal effect according to their terms,
1649 reviewing courts shall apply local law that most closely approximates
1650 an absolute waiver of all civil liability in connection with the
1651 Program, unless a warranty or assumption of liability accompanies a
1652 copy of the Program in return for a fee.
1653 
1654                      END OF TERMS AND CONDITIONS
1655 
1656             How to Apply These Terms to Your New Programs
1657 
1658   If you develop a new program, and you want it to be of the greatest
1659 possible use to the public, the best way to achieve this is to make it
1660 free software which everyone can redistribute and change under these terms.
1661 
1662   To do so, attach the following notices to the program.  It is safest
1663 to attach them to the start of each source file to most effectively
1664 state the exclusion of warranty; and each file should have at least
1665 the "copyright" line and a pointer to where the full notice is found.
1666 
1667     <one line to give the program's name and a brief idea of what it does.>
1668     Copyright (C) <year>  <name of author>
1669 
1670     This program is free software: you can redistribute it and/or modify
1671     it under the terms of the GNU General Public License as published by
1672     the Free Software Foundation, either version 3 of the License, or
1673     (at your option) any later version.
1674 
1675     This program is distributed in the hope that it will be useful,
1676     but WITHOUT ANY WARRANTY; without even the implied warranty of
1677     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1678     GNU General Public License for more details.
1679 
1680     You should have received a copy of the GNU General Public License
1681     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1682 
1683 Also add information on how to contact you by electronic and paper mail.
1684 
1685   If the program does terminal interaction, make it output a short
1686 notice like this when it starts in an interactive mode:
1687 
1688     <program>  Copyright (C) <year>  <name of author>
1689     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
1690     This is free software, and you are welcome to redistribute it
1691     under certain conditions; type `show c' for details.
1692 
1693 The hypothetical commands `show w' and `show c' should show the appropriate
1694 parts of the General Public License.  Of course, your program's commands
1695 might be different; for a GUI interface, you would use an "about box".
1696 
1697   You should also get your employer (if you work as a programmer) or school,
1698 if any, to sign a "copyright disclaimer" for the program, if necessary.
1699 For more information on this, and how to apply and follow the GNU GPL, see
1700 <http://www.gnu.org/licenses/>.
1701 
1702   The GNU General Public License does not permit incorporating your program
1703 into proprietary programs.  If your program is a subroutine library, you
1704 may consider it more useful to permit linking proprietary applications with
1705 the library.  If this is what you want to do, use the GNU Lesser General
1706 Public License instead of this License.  But first, please read
1707 <http://www.gnu.org/philosophy/why-not-lgpl.html>.
1708 
1709 */
1710 
1711 contract CDPCreator is DSMath {
1712     WETH9 public weth;
1713     ERC20 public peth;
1714     ERC20 public dai;
1715     SaiTub public tub;
1716 
1717     event CDPCreated(bytes32 id, address creator, uint256 dai);
1718 
1719     constructor(address _weth, address _peth, address _dai, address _tub) public {
1720         require(_weth != address(0) && _peth != address(0) && _tub != address(0) && _dai != address(0));
1721         weth = WETH9(_weth);
1722         peth = ERC20(_peth);
1723         dai = ERC20(_dai);
1724         tub = SaiTub(_tub);
1725 
1726         weth.approve(address(tub), uint(-1));
1727         peth.approve(address(tub), uint(-1));
1728     }
1729 
1730     function createCDP(uint256 amountDAI) payable external {
1731         require(msg.value >= 0.005 ether);
1732         require(address(weth).call.value(msg.value)());
1733 
1734         bytes32 cupID = tub.open();
1735         
1736         uint256 amountPETH = rdiv(msg.value, tub.per());
1737         tub.join(amountPETH);
1738         tub.lock(cupID, amountPETH);
1739         tub.draw(cupID, amountDAI);
1740 
1741         tub.give(cupID, msg.sender);
1742         dai.transfer(msg.sender, amountDAI);
1743 
1744         emit CDPCreated(cupID, msg.sender, amountDAI);
1745     }
1746 
1747     function lockETH(uint256 id) payable external {
1748         require(address(weth).call.value(msg.value)());
1749 
1750         uint256 amountPETH = rdiv(msg.value, tub.per());
1751         tub.join(amountPETH);
1752 
1753         tub.lock(bytes32(id), amountPETH);
1754     }
1755 
1756     function convertETHToPETH() payable external {
1757         require(address(weth).call.value(msg.value)());
1758 
1759         uint256 amountPETH = rdiv(msg.value, tub.per());
1760         tub.join(amountPETH);
1761         peth.transfer(msg.sender, amountPETH);
1762     }
1763 
1764     function convertPETHToETH(uint256 amountPETH) external {
1765         require(peth.transferFrom(msg.sender, address(this), amountPETH));
1766         
1767         uint256 bid = tub.bid(amountPETH);
1768         tub.exit(amountPETH);
1769         weth.withdraw(bid);
1770         msg.sender.transfer(bid);
1771     }
1772 
1773     function () payable external {
1774         //only accept payments from WETH withdrawal
1775         require(msg.sender == address(weth));
1776     }
1777 }