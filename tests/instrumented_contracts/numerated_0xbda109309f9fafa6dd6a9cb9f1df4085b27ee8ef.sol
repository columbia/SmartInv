1 // hevm: flattened sources of src/tap.sol
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
74 ////// lib/ds-spell/lib/ds-note/src/note.sol
75 /// note.sol -- the `note' modifier, for logging calls as events
76 
77 // This program is free software: you can redistribute it and/or modify
78 // it under the terms of the GNU General Public License as published by
79 // the Free Software Foundation, either version 3 of the License, or
80 // (at your option) any later version.
81 
82 // This program is distributed in the hope that it will be useful,
83 // but WITHOUT ANY WARRANTY; without even the implied warranty of
84 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
85 // GNU General Public License for more details.
86 
87 // You should have received a copy of the GNU General Public License
88 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
89 
90 /* pragma solidity ^0.4.13; */
91 
92 contract DSNote {
93     event LogNote(
94         bytes4   indexed  sig,
95         address  indexed  guy,
96         bytes32  indexed  foo,
97         bytes32  indexed  bar,
98         uint              wad,
99         bytes             fax
100     ) anonymous;
101 
102     modifier note {
103         bytes32 foo;
104         bytes32 bar;
105 
106         assembly {
107             foo := calldataload(4)
108             bar := calldataload(36)
109         }
110 
111         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
112 
113         _;
114     }
115 }
116 
117 ////// lib/ds-thing/lib/ds-math/src/math.sol
118 /// math.sol -- mixin for inline numerical wizardry
119 
120 // This program is free software: you can redistribute it and/or modify
121 // it under the terms of the GNU General Public License as published by
122 // the Free Software Foundation, either version 3 of the License, or
123 // (at your option) any later version.
124 
125 // This program is distributed in the hope that it will be useful,
126 // but WITHOUT ANY WARRANTY; without even the implied warranty of
127 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
128 // GNU General Public License for more details.
129 
130 // You should have received a copy of the GNU General Public License
131 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
132 
133 /* pragma solidity ^0.4.13; */
134 
135 contract DSMath {
136     function add(uint x, uint y) internal pure returns (uint z) {
137         require((z = x + y) >= x);
138     }
139     function sub(uint x, uint y) internal pure returns (uint z) {
140         require((z = x - y) <= x);
141     }
142     function mul(uint x, uint y) internal pure returns (uint z) {
143         require(y == 0 || (z = x * y) / y == x);
144     }
145 
146     function min(uint x, uint y) internal pure returns (uint z) {
147         return x <= y ? x : y;
148     }
149     function max(uint x, uint y) internal pure returns (uint z) {
150         return x >= y ? x : y;
151     }
152     function imin(int x, int y) internal pure returns (int z) {
153         return x <= y ? x : y;
154     }
155     function imax(int x, int y) internal pure returns (int z) {
156         return x >= y ? x : y;
157     }
158 
159     uint constant WAD = 10 ** 18;
160     uint constant RAY = 10 ** 27;
161 
162     function wmul(uint x, uint y) internal pure returns (uint z) {
163         z = add(mul(x, y), WAD / 2) / WAD;
164     }
165     function rmul(uint x, uint y) internal pure returns (uint z) {
166         z = add(mul(x, y), RAY / 2) / RAY;
167     }
168     function wdiv(uint x, uint y) internal pure returns (uint z) {
169         z = add(mul(x, WAD), y / 2) / y;
170     }
171     function rdiv(uint x, uint y) internal pure returns (uint z) {
172         z = add(mul(x, RAY), y / 2) / y;
173     }
174 
175     // This famous algorithm is called "exponentiation by squaring"
176     // and calculates x^n with x as fixed-point and n as regular unsigned.
177     //
178     // It's O(log n), instead of O(n) for naive repeated multiplication.
179     //
180     // These facts are why it works:
181     //
182     //  If n is even, then x^n = (x^2)^(n/2).
183     //  If n is odd,  then x^n = x * x^(n-1),
184     //   and applying the equation for even x gives
185     //    x^n = x * (x^2)^((n-1) / 2).
186     //
187     //  Also, EVM division is flooring and
188     //    floor[(n-1) / 2] = floor[n / 2].
189     //
190     function rpow(uint x, uint n) internal pure returns (uint z) {
191         z = n % 2 != 0 ? x : RAY;
192 
193         for (n /= 2; n != 0; n /= 2) {
194             x = rmul(x, x);
195 
196             if (n % 2 != 0) {
197                 z = rmul(z, x);
198             }
199         }
200     }
201 }
202 
203 ////// lib/ds-thing/src/thing.sol
204 // thing.sol - `auth` with handy mixins. your things should be DSThings
205 
206 // Copyright (C) 2017  DappHub, LLC
207 
208 // This program is free software: you can redistribute it and/or modify
209 // it under the terms of the GNU General Public License as published by
210 // the Free Software Foundation, either version 3 of the License, or
211 // (at your option) any later version.
212 
213 // This program is distributed in the hope that it will be useful,
214 // but WITHOUT ANY WARRANTY; without even the implied warranty of
215 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
216 // GNU General Public License for more details.
217 
218 // You should have received a copy of the GNU General Public License
219 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
220 
221 /* pragma solidity ^0.4.13; */
222 
223 /* import 'ds-auth/auth.sol'; */
224 /* import 'ds-note/note.sol'; */
225 /* import 'ds-math/math.sol'; */
226 
227 contract DSThing is DSAuth, DSNote, DSMath {
228 
229     function S(string s) internal pure returns (bytes4) {
230         return bytes4(keccak256(s));
231     }
232 
233 }
234 
235 ////// lib/ds-token/lib/ds-stop/src/stop.sol
236 /// stop.sol -- mixin for enable/disable functionality
237 
238 // Copyright (C) 2017  DappHub, LLC
239 
240 // This program is free software: you can redistribute it and/or modify
241 // it under the terms of the GNU General Public License as published by
242 // the Free Software Foundation, either version 3 of the License, or
243 // (at your option) any later version.
244 
245 // This program is distributed in the hope that it will be useful,
246 // but WITHOUT ANY WARRANTY; without even the implied warranty of
247 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
248 // GNU General Public License for more details.
249 
250 // You should have received a copy of the GNU General Public License
251 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
252 
253 /* pragma solidity ^0.4.13; */
254 
255 /* import "ds-auth/auth.sol"; */
256 /* import "ds-note/note.sol"; */
257 
258 contract DSStop is DSNote, DSAuth {
259 
260     bool public stopped;
261 
262     modifier stoppable {
263         require(!stopped);
264         _;
265     }
266     function stop() public auth note {
267         stopped = true;
268     }
269     function start() public auth note {
270         stopped = false;
271     }
272 
273 }
274 
275 ////// lib/ds-token/lib/erc20/src/erc20.sol
276 /// erc20.sol -- API for the ERC20 token standard
277 
278 // See <https://github.com/ethereum/EIPs/issues/20>.
279 
280 // This file likely does not meet the threshold of originality
281 // required for copyright to apply.  As a result, this is free and
282 // unencumbered software belonging to the public domain.
283 
284 /* pragma solidity ^0.4.8; */
285 
286 contract ERC20Events {
287     event Approval(address indexed src, address indexed guy, uint wad);
288     event Transfer(address indexed src, address indexed dst, uint wad);
289 }
290 
291 contract ERC20 is ERC20Events {
292     function totalSupply() public view returns (uint);
293     function balanceOf(address guy) public view returns (uint);
294     function allowance(address src, address guy) public view returns (uint);
295 
296     function approve(address guy, uint wad) public returns (bool);
297     function transfer(address dst, uint wad) public returns (bool);
298     function transferFrom(
299         address src, address dst, uint wad
300     ) public returns (bool);
301 }
302 
303 ////// lib/ds-token/src/base.sol
304 /// base.sol -- basic ERC20 implementation
305 
306 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
307 
308 // This program is free software: you can redistribute it and/or modify
309 // it under the terms of the GNU General Public License as published by
310 // the Free Software Foundation, either version 3 of the License, or
311 // (at your option) any later version.
312 
313 // This program is distributed in the hope that it will be useful,
314 // but WITHOUT ANY WARRANTY; without even the implied warranty of
315 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
316 // GNU General Public License for more details.
317 
318 // You should have received a copy of the GNU General Public License
319 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
320 
321 /* pragma solidity ^0.4.13; */
322 
323 /* import "erc20/erc20.sol"; */
324 /* import "ds-math/math.sol"; */
325 
326 contract DSTokenBase is ERC20, DSMath {
327     uint256                                            _supply;
328     mapping (address => uint256)                       _balances;
329     mapping (address => mapping (address => uint256))  _approvals;
330 
331     function DSTokenBase(uint supply) public {
332         _balances[msg.sender] = supply;
333         _supply = supply;
334     }
335 
336     function totalSupply() public view returns (uint) {
337         return _supply;
338     }
339     function balanceOf(address src) public view returns (uint) {
340         return _balances[src];
341     }
342     function allowance(address src, address guy) public view returns (uint) {
343         return _approvals[src][guy];
344     }
345 
346     function transfer(address dst, uint wad) public returns (bool) {
347         return transferFrom(msg.sender, dst, wad);
348     }
349 
350     function transferFrom(address src, address dst, uint wad)
351         public
352         returns (bool)
353     {
354         if (src != msg.sender) {
355             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
356         }
357 
358         _balances[src] = sub(_balances[src], wad);
359         _balances[dst] = add(_balances[dst], wad);
360 
361         Transfer(src, dst, wad);
362 
363         return true;
364     }
365 
366     function approve(address guy, uint wad) public returns (bool) {
367         _approvals[msg.sender][guy] = wad;
368 
369         Approval(msg.sender, guy, wad);
370 
371         return true;
372     }
373 }
374 
375 ////// lib/ds-token/src/token.sol
376 /// token.sol -- ERC20 implementation with minting and burning
377 
378 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
379 
380 // This program is free software: you can redistribute it and/or modify
381 // it under the terms of the GNU General Public License as published by
382 // the Free Software Foundation, either version 3 of the License, or
383 // (at your option) any later version.
384 
385 // This program is distributed in the hope that it will be useful,
386 // but WITHOUT ANY WARRANTY; without even the implied warranty of
387 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
388 // GNU General Public License for more details.
389 
390 // You should have received a copy of the GNU General Public License
391 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
392 
393 /* pragma solidity ^0.4.13; */
394 
395 /* import "ds-stop/stop.sol"; */
396 
397 /* import "./base.sol"; */
398 
399 contract DSToken is DSTokenBase(0), DSStop {
400 
401     bytes32  public  symbol;
402     uint256  public  decimals = 18; // standard token precision. override to customize
403 
404     function DSToken(bytes32 symbol_) public {
405         symbol = symbol_;
406     }
407 
408     event Mint(address indexed guy, uint wad);
409     event Burn(address indexed guy, uint wad);
410 
411     function approve(address guy) public stoppable returns (bool) {
412         return super.approve(guy, uint(-1));
413     }
414 
415     function approve(address guy, uint wad) public stoppable returns (bool) {
416         return super.approve(guy, wad);
417     }
418 
419     function transferFrom(address src, address dst, uint wad)
420         public
421         stoppable
422         returns (bool)
423     {
424         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
425             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
426         }
427 
428         _balances[src] = sub(_balances[src], wad);
429         _balances[dst] = add(_balances[dst], wad);
430 
431         Transfer(src, dst, wad);
432 
433         return true;
434     }
435 
436     function push(address dst, uint wad) public {
437         transferFrom(msg.sender, dst, wad);
438     }
439     function pull(address src, uint wad) public {
440         transferFrom(src, msg.sender, wad);
441     }
442     function move(address src, address dst, uint wad) public {
443         transferFrom(src, dst, wad);
444     }
445 
446     function mint(uint wad) public {
447         mint(msg.sender, wad);
448     }
449     function burn(uint wad) public {
450         burn(msg.sender, wad);
451     }
452     function mint(address guy, uint wad) public auth stoppable {
453         _balances[guy] = add(_balances[guy], wad);
454         _supply = add(_supply, wad);
455         Mint(guy, wad);
456     }
457     function burn(address guy, uint wad) public auth stoppable {
458         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
459             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
460         }
461 
462         _balances[guy] = sub(_balances[guy], wad);
463         _supply = sub(_supply, wad);
464         Burn(guy, wad);
465     }
466 
467     // Optional token name
468     bytes32   public  name = "";
469 
470     function setName(bytes32 name_) public auth {
471         name = name_;
472     }
473 }
474 
475 ////// lib/ds-value/src/value.sol
476 /// value.sol - a value is a simple thing, it can be get and set
477 
478 // Copyright (C) 2017  DappHub, LLC
479 
480 // This program is free software: you can redistribute it and/or modify
481 // it under the terms of the GNU General Public License as published by
482 // the Free Software Foundation, either version 3 of the License, or
483 // (at your option) any later version.
484 
485 // This program is distributed in the hope that it will be useful,
486 // but WITHOUT ANY WARRANTY; without even the implied warranty of
487 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
488 // GNU General Public License for more details.
489 
490 // You should have received a copy of the GNU General Public License
491 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
492 
493 /* pragma solidity ^0.4.13; */
494 
495 /* import 'ds-thing/thing.sol'; */
496 
497 contract DSValue is DSThing {
498     bool    has;
499     bytes32 val;
500     function peek() public view returns (bytes32, bool) {
501         return (val,has);
502     }
503     function read() public view returns (bytes32) {
504         var (wut, haz) = peek();
505         assert(haz);
506         return wut;
507     }
508     function poke(bytes32 wut) public note auth {
509         val = wut;
510         has = true;
511     }
512     function void() public note auth {  // unset the value
513         has = false;
514     }
515 }
516 
517 ////// src/vox.sol
518 /// vox.sol -- target price feed
519 
520 // Copyright (C) 2016, 2017  Nikolai Mushegian <nikolai@dapphub.com>
521 // Copyright (C) 2016, 2017  Daniel Brockman <daniel@dapphub.com>
522 // Copyright (C) 2017        Rain Break <rainbreak@riseup.net>
523 
524 // This program is free software: you can redistribute it and/or modify
525 // it under the terms of the GNU General Public License as published by
526 // the Free Software Foundation, either version 3 of the License, or
527 // (at your option) any later version.
528 
529 // This program is distributed in the hope that it will be useful,
530 // but WITHOUT ANY WARRANTY; without even the implied warranty of
531 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
532 // GNU General Public License for more details.
533 
534 // You should have received a copy of the GNU General Public License
535 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
536 
537 /* pragma solidity ^0.4.18; */
538 
539 /* import "ds-thing/thing.sol"; */
540 
541 contract SaiVox is DSThing {
542     uint256  _par;
543     uint256  _way;
544 
545     uint256  public  fix;
546     uint256  public  how;
547     uint256  public  tau;
548 
549     function SaiVox(uint par_) public {
550         _par = fix = par_;
551         _way = RAY;
552         tau  = era();
553     }
554 
555     function era() public view returns (uint) {
556         return block.timestamp;
557     }
558 
559     function mold(bytes32 param, uint val) public note auth {
560         if (param == 'way') _way = val;
561     }
562 
563     // Dai Target Price (ref per dai)
564     function par() public returns (uint) {
565         prod();
566         return _par;
567     }
568     function way() public returns (uint) {
569         prod();
570         return _way;
571     }
572 
573     function tell(uint256 ray) public note auth {
574         fix = ray;
575     }
576     function tune(uint256 ray) public note auth {
577         how = ray;
578     }
579 
580     function prod() public note {
581         var age = era() - tau;
582         if (age == 0) return;  // optimised
583         tau = era();
584 
585         if (_way != RAY) _par = rmul(_par, rpow(_way, age));  // optimised
586 
587         if (how == 0) return;  // optimised
588         var wag = int128(how * age);
589         _way = inj(prj(_way) + (fix < _par ? wag : -wag));
590     }
591 
592     function inj(int128 x) internal pure returns (uint256) {
593         return x >= 0 ? uint256(x) + RAY
594             : rdiv(RAY, RAY + uint256(-x));
595     }
596     function prj(uint256 x) internal pure returns (int128) {
597         return x >= RAY ? int128(x - RAY)
598             : int128(RAY) - int128(rdiv(RAY, x));
599     }
600 }
601 
602 ////// src/tub.sol
603 /// tub.sol -- simplified CDP engine (baby brother of `vat')
604 
605 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
606 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
607 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
608 
609 // This program is free software: you can redistribute it and/or modify
610 // it under the terms of the GNU General Public License as published by
611 // the Free Software Foundation, either version 3 of the License, or
612 // (at your option) any later version.
613 
614 // This program is distributed in the hope that it will be useful,
615 // but WITHOUT ANY WARRANTY; without even the implied warranty of
616 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
617 // GNU General Public License for more details.
618 
619 // You should have received a copy of the GNU General Public License
620 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
621 
622 /* pragma solidity ^0.4.18; */
623 
624 /* import "ds-thing/thing.sol"; */
625 /* import "ds-token/token.sol"; */
626 /* import "ds-value/value.sol"; */
627 
628 /* import "./vox.sol"; */
629 
630 contract SaiTubEvents {
631     event LogNewCup(address indexed lad, bytes32 cup);
632 }
633 
634 contract SaiTub is DSThing, SaiTubEvents {
635     DSToken  public  sai;  // Stablecoin
636     DSToken  public  sin;  // Debt (negative sai)
637 
638     DSToken  public  skr;  // Abstracted collateral
639     ERC20    public  gem;  // Underlying collateral
640 
641     DSToken  public  gov;  // Governance token
642 
643     SaiVox   public  vox;  // Target price feed
644     DSValue  public  pip;  // Reference price feed
645     DSValue  public  pep;  // Governance price feed
646 
647     address  public  tap;  // Liquidator
648     address  public  pit;  // Governance Vault
649 
650     uint256  public  axe;  // Liquidation penalty
651     uint256  public  cap;  // Debt ceiling
652     uint256  public  mat;  // Liquidation ratio
653     uint256  public  tax;  // Stability fee
654     uint256  public  fee;  // Governance fee
655     uint256  public  gap;  // Join-Exit Spread
656 
657     bool     public  off;  // Cage flag
658     bool     public  out;  // Post cage exit
659 
660     uint256  public  fit;  // REF per SKR (just before settlement)
661 
662     uint256  public  rho;  // Time of last drip
663     uint256         _chi;  // Accumulated Tax Rates
664     uint256         _rhi;  // Accumulated Tax + Fee Rates
665     uint256  public  rum;  // Total normalised debt
666 
667     uint256                   public  cupi;
668     mapping (bytes32 => Cup)  public  cups;
669 
670     struct Cup {
671         address  lad;      // CDP owner
672         uint256  ink;      // Locked collateral (in SKR)
673         uint256  art;      // Outstanding normalised debt (tax only)
674         uint256  ire;      // Outstanding normalised debt
675     }
676 
677     function lad(bytes32 cup) public view returns (address) {
678         return cups[cup].lad;
679     }
680     function ink(bytes32 cup) public view returns (uint) {
681         return cups[cup].ink;
682     }
683     function tab(bytes32 cup) public returns (uint) {
684         return rmul(cups[cup].art, chi());
685     }
686     function rap(bytes32 cup) public returns (uint) {
687         return sub(rmul(cups[cup].ire, rhi()), tab(cup));
688     }
689 
690     // Total CDP Debt
691     function din() public returns (uint) {
692         return rmul(rum, chi());
693     }
694     // Backing collateral
695     function air() public view returns (uint) {
696         return skr.balanceOf(this);
697     }
698     // Raw collateral
699     function pie() public view returns (uint) {
700         return gem.balanceOf(this);
701     }
702 
703     //------------------------------------------------------------------
704 
705     function SaiTub(
706         DSToken  sai_,
707         DSToken  sin_,
708         DSToken  skr_,
709         ERC20    gem_,
710         DSToken  gov_,
711         DSValue  pip_,
712         DSValue  pep_,
713         SaiVox   vox_,
714         address  pit_
715     ) public {
716         gem = gem_;
717         skr = skr_;
718 
719         sai = sai_;
720         sin = sin_;
721 
722         gov = gov_;
723         pit = pit_;
724 
725         pip = pip_;
726         pep = pep_;
727         vox = vox_;
728 
729         axe = RAY;
730         mat = RAY;
731         tax = RAY;
732         fee = RAY;
733         gap = WAD;
734 
735         _chi = RAY;
736         _rhi = RAY;
737 
738         rho = era();
739     }
740 
741     function era() public constant returns (uint) {
742         return block.timestamp;
743     }
744 
745     //--Risk-parameter-config-------------------------------------------
746 
747     function mold(bytes32 param, uint val) public note auth {
748         if      (param == 'cap') cap = val;
749         else if (param == 'mat') { require(val >= RAY); mat = val; }
750         else if (param == 'tax') { require(val >= RAY); drip(); tax = val; }
751         else if (param == 'fee') { require(val >= RAY); drip(); fee = val; }
752         else if (param == 'axe') { require(val >= RAY); axe = val; }
753         else if (param == 'gap') { require(val >= WAD); gap = val; }
754         else return;
755     }
756 
757     //--Price-feed-setters----------------------------------------------
758 
759     function setPip(DSValue pip_) public note auth {
760         pip = pip_;
761     }
762     function setPep(DSValue pep_) public note auth {
763         pep = pep_;
764     }
765     function setVox(SaiVox vox_) public note auth {
766         vox = vox_;
767     }
768 
769     //--Tap-setter------------------------------------------------------
770     function turn(address tap_) public note {
771         require(tap  == 0);
772         require(tap_ != 0);
773         tap = tap_;
774     }
775 
776     //--Collateral-wrapper----------------------------------------------
777 
778     // Wrapper ratio (gem per skr)
779     function per() public view returns (uint ray) {
780         return skr.totalSupply() == 0 ? RAY : rdiv(pie(), skr.totalSupply());
781     }
782     // Join price (gem per skr)
783     function ask(uint wad) public view returns (uint) {
784         return rmul(wad, wmul(per(), gap));
785     }
786     // Exit price (gem per skr)
787     function bid(uint wad) public view returns (uint) {
788         return rmul(wad, wmul(per(), sub(2 * WAD, gap)));
789     }
790     function join(uint wad) public note {
791         require(!off);
792         require(ask(wad) > 0);
793         require(gem.transferFrom(msg.sender, this, ask(wad)));
794         skr.mint(msg.sender, wad);
795     }
796     function exit(uint wad) public note {
797         require(!off || out);
798         require(gem.transfer(msg.sender, bid(wad)));
799         skr.burn(msg.sender, wad);
800     }
801 
802     //--Stability-fee-accumulation--------------------------------------
803 
804     // Accumulated Rates
805     function chi() public returns (uint) {
806         drip();
807         return _chi;
808     }
809     function rhi() public returns (uint) {
810         drip();
811         return _rhi;
812     }
813     function drip() public note {
814         if (off) return;
815 
816         var rho_ = era();
817         var age = rho_ - rho;
818         if (age == 0) return;    // optimised
819         rho = rho_;
820 
821         var inc = RAY;
822 
823         if (tax != RAY) {  // optimised
824             var _chi_ = _chi;
825             inc = rpow(tax, age);
826             _chi = rmul(_chi, inc);
827             sai.mint(tap, rmul(sub(_chi, _chi_), rum));
828         }
829 
830         // optimised
831         if (fee != RAY) inc = rmul(inc, rpow(fee, age));
832         if (inc != RAY) _rhi = rmul(_rhi, inc);
833     }
834 
835 
836     //--CDP-risk-indicator----------------------------------------------
837 
838     // Abstracted collateral price (ref per skr)
839     function tag() public view returns (uint wad) {
840         return off ? fit : wmul(per(), uint(pip.read()));
841     }
842     // Returns true if cup is well-collateralized
843     function safe(bytes32 cup) public returns (bool) {
844         var pro = rmul(tag(), ink(cup));
845         var con = rmul(vox.par(), tab(cup));
846         var min = rmul(con, mat);
847         return pro >= min;
848     }
849 
850 
851     //--CDP-operations--------------------------------------------------
852 
853     function open() public note returns (bytes32 cup) {
854         require(!off);
855         cupi = add(cupi, 1);
856         cup = bytes32(cupi);
857         cups[cup].lad = msg.sender;
858         LogNewCup(msg.sender, cup);
859     }
860     function give(bytes32 cup, address guy) public note {
861         require(msg.sender == cups[cup].lad);
862         require(guy != 0);
863         cups[cup].lad = guy;
864     }
865 
866     function lock(bytes32 cup, uint wad) public note {
867         require(!off);
868         cups[cup].ink = add(cups[cup].ink, wad);
869         skr.pull(msg.sender, wad);
870         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
871     }
872     function free(bytes32 cup, uint wad) public note {
873         require(msg.sender == cups[cup].lad);
874         cups[cup].ink = sub(cups[cup].ink, wad);
875         skr.push(msg.sender, wad);
876         require(safe(cup));
877         require(cups[cup].ink == 0 || cups[cup].ink > 0.005 ether);
878     }
879 
880     function draw(bytes32 cup, uint wad) public note {
881         require(!off);
882         require(msg.sender == cups[cup].lad);
883         require(rdiv(wad, chi()) > 0);
884 
885         cups[cup].art = add(cups[cup].art, rdiv(wad, chi()));
886         rum = add(rum, rdiv(wad, chi()));
887 
888         cups[cup].ire = add(cups[cup].ire, rdiv(wad, rhi()));
889         sai.mint(cups[cup].lad, wad);
890 
891         require(safe(cup));
892         require(sai.totalSupply() <= cap);
893     }
894     function wipe(bytes32 cup, uint wad) public note {
895         require(!off);
896 
897         var owe = rmul(wad, rdiv(rap(cup), tab(cup)));
898 
899         cups[cup].art = sub(cups[cup].art, rdiv(wad, chi()));
900         rum = sub(rum, rdiv(wad, chi()));
901 
902         cups[cup].ire = sub(cups[cup].ire, rdiv(add(wad, owe), rhi()));
903         sai.burn(msg.sender, wad);
904 
905         var (val, ok) = pep.peek();
906         if (ok && val != 0) gov.move(msg.sender, pit, wdiv(owe, uint(val)));
907     }
908 
909     function shut(bytes32 cup) public note {
910         require(!off);
911         require(msg.sender == cups[cup].lad);
912         if (tab(cup) != 0) wipe(cup, tab(cup));
913         if (ink(cup) != 0) free(cup, ink(cup));
914         delete cups[cup];
915     }
916 
917     function bite(bytes32 cup) public note {
918         require(!safe(cup) || off);
919 
920         // Take on all of the debt, except unpaid fees
921         var rue = tab(cup);
922         sin.mint(tap, rue);
923         rum = sub(rum, cups[cup].art);
924         cups[cup].art = 0;
925         cups[cup].ire = 0;
926 
927         // Amount owed in SKR, including liquidation penalty
928         var owe = rdiv(rmul(rmul(rue, axe), vox.par()), tag());
929 
930         if (owe > cups[cup].ink) {
931             owe = cups[cup].ink;
932         }
933 
934         skr.push(tap, owe);
935         cups[cup].ink = sub(cups[cup].ink, owe);
936     }
937 
938     //------------------------------------------------------------------
939 
940     function cage(uint fit_, uint jam) public note auth {
941         require(!off && fit_ != 0);
942         off = true;
943         axe = RAY;
944         gap = WAD;
945         fit = fit_;         // ref per skr
946         require(gem.transfer(tap, jam));
947     }
948     function flow() public note auth {
949         require(off);
950         out = true;
951     }
952 }
953 
954 ////// src/tap.sol
955 /// tap.sol -- liquidation engine (see also `vow`)
956 
957 // Copyright (C) 2017  Nikolai Mushegian <nikolai@dapphub.com>
958 // Copyright (C) 2017  Daniel Brockman <daniel@dapphub.com>
959 // Copyright (C) 2017  Rain Break <rainbreak@riseup.net>
960 
961 // This program is free software: you can redistribute it and/or modify
962 // it under the terms of the GNU General Public License as published by
963 // the Free Software Foundation, either version 3 of the License, or
964 // (at your option) any later version.
965 
966 // This program is distributed in the hope that it will be useful,
967 // but WITHOUT ANY WARRANTY; without even the implied warranty of
968 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
969 // GNU General Public License for more details.
970 
971 // You should have received a copy of the GNU General Public License
972 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
973 
974 /* pragma solidity ^0.4.18; */
975 
976 /* import "./tub.sol"; */
977 
978 contract SaiTap is DSThing {
979     DSToken  public  sai;
980     DSToken  public  sin;
981     DSToken  public  skr;
982 
983     SaiVox   public  vox;
984     SaiTub   public  tub;
985 
986     uint256  public  gap;  // Boom-Bust Spread
987     bool     public  off;  // Cage flag
988     uint256  public  fix;  // Cage price
989 
990     // Surplus
991     function joy() public view returns (uint) {
992         return sai.balanceOf(this);
993     }
994     // Bad debt
995     function woe() public view returns (uint) {
996         return sin.balanceOf(this);
997     }
998     // Collateral pending liquidation
999     function fog() public view returns (uint) {
1000         return skr.balanceOf(this);
1001     }
1002 
1003 
1004     function SaiTap(SaiTub tub_) public {
1005         tub = tub_;
1006 
1007         sai = tub.sai();
1008         sin = tub.sin();
1009         skr = tub.skr();
1010 
1011         vox = tub.vox();
1012 
1013         gap = WAD;
1014     }
1015 
1016     function mold(bytes32 param, uint val) public note auth {
1017         if (param == 'gap') gap = val;
1018     }
1019 
1020     // Cancel debt
1021     function heal() public note {
1022         if (joy() == 0 || woe() == 0) return;  // optimised
1023         var wad = min(joy(), woe());
1024         sai.burn(wad);
1025         sin.burn(wad);
1026     }
1027 
1028     // Feed price (sai per skr)
1029     function s2s() public returns (uint) {
1030         var tag = tub.tag();    // ref per skr
1031         var par = vox.par();    // ref per sai
1032         return rdiv(tag, par);  // sai per skr
1033     }
1034     // Boom price (sai per skr)
1035     function bid(uint wad) public returns (uint) {
1036         return rmul(wad, wmul(s2s(), sub(2 * WAD, gap)));
1037     }
1038     // Bust price (sai per skr)
1039     function ask(uint wad) public returns (uint) {
1040         return rmul(wad, wmul(s2s(), gap));
1041     }
1042     function flip(uint wad) internal {
1043         require(ask(wad) > 0);
1044         skr.push(msg.sender, wad);
1045         sai.pull(msg.sender, ask(wad));
1046         heal();
1047     }
1048     function flop(uint wad) internal {
1049         skr.mint(sub(wad, fog()));
1050         flip(wad);
1051         require(joy() == 0);  // can't flop into surplus
1052     }
1053     function flap(uint wad) internal {
1054         heal();
1055         sai.push(msg.sender, bid(wad));
1056         skr.burn(msg.sender, wad);
1057     }
1058     function bust(uint wad) public note {
1059         require(!off);
1060         if (wad > fog()) flop(wad);
1061         else flip(wad);
1062     }
1063     function boom(uint wad) public note {
1064         require(!off);
1065         flap(wad);
1066     }
1067 
1068     //------------------------------------------------------------------
1069 
1070     function cage(uint fix_) public note auth {
1071         require(!off);
1072         off = true;
1073         fix = fix_;
1074     }
1075     function cash(uint wad) public note {
1076         require(off);
1077         sai.burn(msg.sender, wad);
1078         require(tub.gem().transfer(msg.sender, rmul(wad, fix)));
1079     }
1080     function mock(uint wad) public note {
1081         require(off);
1082         sai.mint(msg.sender, wad);
1083         require(tub.gem().transferFrom(msg.sender, this, rmul(wad, fix)));
1084     }
1085     function vent() public note {
1086         require(off);
1087         skr.burn(fog());
1088     }
1089 }