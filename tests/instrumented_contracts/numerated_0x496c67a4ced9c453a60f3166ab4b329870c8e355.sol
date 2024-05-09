1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-08
3 */
4 
5 // hevm: flattened sources of src/chief.sol
6 pragma solidity >=0.4.23;
7 
8 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU General Public License for more details.
18 
19 // You should have received a copy of the GNU General Public License
20 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22 /* pragma solidity >=0.4.23; */
23 
24 contract DSAuthority {
25     function canCall(
26         address src, address dst, bytes4 sig
27     ) public view returns (bool);
28 }
29 
30 contract DSAuthEvents {
31     event LogSetAuthority (address indexed authority);
32     event LogSetOwner     (address indexed owner);
33 }
34 
35 contract DSAuth is DSAuthEvents {
36     DSAuthority  public  authority;
37     address      public  owner;
38 
39     constructor() public {
40         owner = msg.sender;
41         emit LogSetOwner(msg.sender);
42     }
43 
44     function setOwner(address owner_)
45         public
46         auth
47     {
48         owner = owner_;
49         emit LogSetOwner(owner);
50     }
51 
52     function setAuthority(DSAuthority authority_)
53         public
54         auth
55     {
56         authority = authority_;
57         emit LogSetAuthority(address(authority));
58     }
59 
60     modifier auth {
61         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
62         _;
63     }
64 
65     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
66         if (src == address(this)) {
67             return true;
68         } else if (src == owner) {
69             return true;
70         } else if (authority == DSAuthority(0)) {
71             return false;
72         } else {
73             return authority.canCall(src, address(this), sig);
74         }
75     }
76 }
77 
78 ////// lib/ds-roles/src/roles.sol
79 // roles.sol - roled based authentication
80 
81 // Copyright (C) 2017  DappHub, LLC
82 
83 // This program is free software: you can redistribute it and/or modify
84 // it under the terms of the GNU General Public License as published by
85 // the Free Software Foundation, either version 3 of the License, or
86 // (at your option) any later version.
87 
88 // This program is distributed in the hope that it will be useful,
89 // but WITHOUT ANY WARRANTY; without even the implied warranty of
90 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
91 // GNU General Public License for more details.
92 
93 // You should have received a copy of the GNU General Public License
94 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
95 
96 /* pragma solidity >=0.4.23; */
97 
98 /* import 'ds-auth/auth.sol'; */
99 
100 contract DSRoles is DSAuth, DSAuthority
101 {
102     mapping(address=>bool) _root_users;
103     mapping(address=>bytes32) _user_roles;
104     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
105     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
106 
107     function getUserRoles(address who)
108         public
109         view
110         returns (bytes32)
111     {
112         return _user_roles[who];
113     }
114 
115     function getCapabilityRoles(address code, bytes4 sig)
116         public
117         view
118         returns (bytes32)
119     {
120         return _capability_roles[code][sig];
121     }
122 
123     function isUserRoot(address who)
124         public
125         view
126         returns (bool)
127     {
128         return _root_users[who];
129     }
130 
131     function isCapabilityPublic(address code, bytes4 sig)
132         public
133         view
134         returns (bool)
135     {
136         return _public_capabilities[code][sig];
137     }
138 
139     function hasUserRole(address who, uint8 role)
140         public
141         view
142         returns (bool)
143     {
144         bytes32 roles = getUserRoles(who);
145         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
146         return bytes32(0) != roles & shifted;
147     }
148 
149     function canCall(address caller, address code, bytes4 sig)
150         public
151         view
152         returns (bool)
153     {
154         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
155             return true;
156         } else {
157             bytes32 has_roles = getUserRoles(caller);
158             bytes32 needs_one_of = getCapabilityRoles(code, sig);
159             return bytes32(0) != has_roles & needs_one_of;
160         }
161     }
162 
163     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
164         return (input ^ bytes32(uint(-1)));
165     }
166 
167     function setRootUser(address who, bool enabled)
168         public
169         auth
170     {
171         _root_users[who] = enabled;
172     }
173 
174     function setUserRole(address who, uint8 role, bool enabled)
175         public
176         auth
177     {
178         bytes32 last_roles = _user_roles[who];
179         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
180         if( enabled ) {
181             _user_roles[who] = last_roles | shifted;
182         } else {
183             _user_roles[who] = last_roles & BITNOT(shifted);
184         }
185     }
186 
187     function setPublicCapability(address code, bytes4 sig, bool enabled)
188         public
189         auth
190     {
191         _public_capabilities[code][sig] = enabled;
192     }
193 
194     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
195         public
196         auth
197     {
198         bytes32 last_roles = _capability_roles[code][sig];
199         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
200         if( enabled ) {
201             _capability_roles[code][sig] = last_roles | shifted;
202         } else {
203             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
204         }
205 
206     }
207 
208 }
209 
210 ////// lib/ds-thing/lib/ds-math/src/math.sol
211 /// math.sol -- mixin for inline numerical wizardry
212 
213 // This program is free software: you can redistribute it and/or modify
214 // it under the terms of the GNU General Public License as published by
215 // the Free Software Foundation, either version 3 of the License, or
216 // (at your option) any later version.
217 
218 // This program is distributed in the hope that it will be useful,
219 // but WITHOUT ANY WARRANTY; without even the implied warranty of
220 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
221 // GNU General Public License for more details.
222 
223 // You should have received a copy of the GNU General Public License
224 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
225 
226 /* pragma solidity >0.4.13; */
227 
228 contract DSMath {
229     function add(uint x, uint y) internal pure returns (uint z) {
230         require((z = x + y) >= x, "ds-math-add-overflow");
231     }
232     function sub(uint x, uint y) internal pure returns (uint z) {
233         require((z = x - y) <= x, "ds-math-sub-underflow");
234     }
235     function mul(uint x, uint y) internal pure returns (uint z) {
236         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
237     }
238 
239     function min(uint x, uint y) internal pure returns (uint z) {
240         return x <= y ? x : y;
241     }
242     function max(uint x, uint y) internal pure returns (uint z) {
243         return x >= y ? x : y;
244     }
245     function imin(int x, int y) internal pure returns (int z) {
246         return x <= y ? x : y;
247     }
248     function imax(int x, int y) internal pure returns (int z) {
249         return x >= y ? x : y;
250     }
251 
252     uint constant WAD = 10 ** 18;
253     uint constant RAY = 10 ** 27;
254 
255     function wmul(uint x, uint y) internal pure returns (uint z) {
256         z = add(mul(x, y), WAD / 2) / WAD;
257     }
258     function rmul(uint x, uint y) internal pure returns (uint z) {
259         z = add(mul(x, y), RAY / 2) / RAY;
260     }
261     function wdiv(uint x, uint y) internal pure returns (uint z) {
262         z = add(mul(x, WAD), y / 2) / y;
263     }
264     function rdiv(uint x, uint y) internal pure returns (uint z) {
265         z = add(mul(x, RAY), y / 2) / y;
266     }
267 
268     // This famous algorithm is called "exponentiation by squaring"
269     // and calculates x^n with x as fixed-point and n as regular unsigned.
270     //
271     // It's O(log n), instead of O(n) for naive repeated multiplication.
272     //
273     // These facts are why it works:
274     //
275     //  If n is even, then x^n = (x^2)^(n/2).
276     //  If n is odd,  then x^n = x * x^(n-1),
277     //   and applying the equation for even x gives
278     //    x^n = x * (x^2)^((n-1) / 2).
279     //
280     //  Also, EVM division is flooring and
281     //    floor[(n-1) / 2] = floor[n / 2].
282     //
283     function rpow(uint x, uint n) internal pure returns (uint z) {
284         z = n % 2 != 0 ? x : RAY;
285 
286         for (n /= 2; n != 0; n /= 2) {
287             x = rmul(x, x);
288 
289             if (n % 2 != 0) {
290                 z = rmul(z, x);
291             }
292         }
293     }
294 }
295 
296 ////// lib/ds-thing/lib/ds-note/src/note.sol
297 /// note.sol -- the `note' modifier, for logging calls as events
298 
299 // This program is free software: you can redistribute it and/or modify
300 // it under the terms of the GNU General Public License as published by
301 // the Free Software Foundation, either version 3 of the License, or
302 // (at your option) any later version.
303 
304 // This program is distributed in the hope that it will be useful,
305 // but WITHOUT ANY WARRANTY; without even the implied warranty of
306 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
307 // GNU General Public License for more details.
308 
309 // You should have received a copy of the GNU General Public License
310 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
311 
312 /* pragma solidity >=0.4.23; */
313 
314 contract DSNote {
315     event LogNote(
316         bytes4   indexed  sig,
317         address  indexed  guy,
318         bytes32  indexed  foo,
319         bytes32  indexed  bar,
320         uint256           wad,
321         bytes             fax
322     ) anonymous;
323 
324     modifier note {
325         bytes32 foo;
326         bytes32 bar;
327         uint256 wad;
328 
329         assembly {
330             foo := calldataload(4)
331             bar := calldataload(36)
332             wad := callvalue
333         }
334 
335         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
336 
337         _;
338     }
339 }
340 
341 ////// lib/ds-thing/src/thing.sol
342 // thing.sol - `auth` with handy mixins. your things should be DSThings
343 
344 // Copyright (C) 2017  DappHub, LLC
345 
346 // This program is free software: you can redistribute it and/or modify
347 // it under the terms of the GNU General Public License as published by
348 // the Free Software Foundation, either version 3 of the License, or
349 // (at your option) any later version.
350 
351 // This program is distributed in the hope that it will be useful,
352 // but WITHOUT ANY WARRANTY; without even the implied warranty of
353 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
354 // GNU General Public License for more details.
355 
356 // You should have received a copy of the GNU General Public License
357 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
358 
359 /* pragma solidity >=0.4.23; */
360 
361 /* import 'ds-auth/auth.sol'; */
362 /* import 'ds-note/note.sol'; */
363 /* import 'ds-math/math.sol'; */
364 
365 contract DSThing is DSAuth, DSNote, DSMath {
366     function S(string memory s) internal pure returns (bytes4) {
367         return bytes4(keccak256(abi.encodePacked(s)));
368     }
369 
370 }
371 
372 ////// lib/ds-token/lib/ds-stop/src/stop.sol
373 /// stop.sol -- mixin for enable/disable functionality
374 
375 // Copyright (C) 2017  DappHub, LLC
376 
377 // This program is free software: you can redistribute it and/or modify
378 // it under the terms of the GNU General Public License as published by
379 // the Free Software Foundation, either version 3 of the License, or
380 // (at your option) any later version.
381 
382 // This program is distributed in the hope that it will be useful,
383 // but WITHOUT ANY WARRANTY; without even the implied warranty of
384 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
385 // GNU General Public License for more details.
386 
387 // You should have received a copy of the GNU General Public License
388 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
389 
390 /* pragma solidity >=0.4.23; */
391 
392 /* import "ds-auth/auth.sol"; */
393 /* import "ds-note/note.sol"; */
394 
395 contract DSStop is DSNote, DSAuth {
396     bool public stopped;
397 
398     modifier stoppable {
399         require(!stopped, "ds-stop-is-stopped");
400         _;
401     }
402     function stop() public auth note {
403         stopped = true;
404     }
405     function start() public auth note {
406         stopped = false;
407     }
408 
409 }
410 
411 ////// lib/ds-token/lib/erc20/src/erc20.sol
412 /// erc20.sol -- API for the ERC20 token standard
413 
414 // See <https://github.com/ethereum/EIPs/issues/20>.
415 
416 // This file likely does not meet the threshold of originality
417 // required for copyright to apply.  As a result, this is free and
418 // unencumbered software belonging to the public domain.
419 
420 /* pragma solidity >0.4.20; */
421 
422 contract ERC20Events {
423     event Approval(address indexed src, address indexed guy, uint wad);
424     event Transfer(address indexed src, address indexed dst, uint wad);
425 }
426 
427 contract ERC20 is ERC20Events {
428     function totalSupply() public view returns (uint);
429     function balanceOf(address guy) public view returns (uint);
430     function allowance(address src, address guy) public view returns (uint);
431 
432     function approve(address guy, uint wad) public returns (bool);
433     function transfer(address dst, uint wad) public returns (bool);
434     function transferFrom(
435         address src, address dst, uint wad
436     ) public returns (bool);
437 }
438 
439 ////// lib/ds-token/src/base.sol
440 /// base.sol -- basic ERC20 implementation
441 
442 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
443 
444 // This program is free software: you can redistribute it and/or modify
445 // it under the terms of the GNU General Public License as published by
446 // the Free Software Foundation, either version 3 of the License, or
447 // (at your option) any later version.
448 
449 // This program is distributed in the hope that it will be useful,
450 // but WITHOUT ANY WARRANTY; without even the implied warranty of
451 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
452 // GNU General Public License for more details.
453 
454 // You should have received a copy of the GNU General Public License
455 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
456 
457 /* pragma solidity >=0.4.23; */
458 
459 /* import "erc20/erc20.sol"; */
460 /* import "ds-math/math.sol"; */
461 
462 contract DSTokenBase is ERC20, DSMath {
463     uint256                                            _supply;
464     mapping (address => uint256)                       _balances;
465     mapping (address => mapping (address => uint256))  _approvals;
466 
467     constructor(uint supply) public {
468         _balances[msg.sender] = supply;
469         _supply = supply;
470     }
471 
472     function totalSupply() public view returns (uint) {
473         return _supply;
474     }
475     function balanceOf(address src) public view returns (uint) {
476         return _balances[src];
477     }
478     function allowance(address src, address guy) public view returns (uint) {
479         return _approvals[src][guy];
480     }
481 
482     function transfer(address dst, uint wad) public returns (bool) {
483         return transferFrom(msg.sender, dst, wad);
484     }
485 
486     function transferFrom(address src, address dst, uint wad)
487         public
488         returns (bool)
489     {
490         if (src != msg.sender) {
491             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
492             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
493         }
494 
495         require(_balances[src] >= wad, "ds-token-insufficient-balance");
496         _balances[src] = sub(_balances[src], wad);
497         _balances[dst] = add(_balances[dst], wad);
498 
499         emit Transfer(src, dst, wad);
500 
501         return true;
502     }
503 
504     function approve(address guy, uint wad) public returns (bool) {
505         _approvals[msg.sender][guy] = wad;
506 
507         emit Approval(msg.sender, guy, wad);
508 
509         return true;
510     }
511 }
512 
513 ////// lib/ds-token/src/token.sol
514 /// token.sol -- ERC20 implementation with minting and burning
515 
516 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
517 
518 // This program is free software: you can redistribute it and/or modify
519 // it under the terms of the GNU General Public License as published by
520 // the Free Software Foundation, either version 3 of the License, or
521 // (at your option) any later version.
522 
523 // This program is distributed in the hope that it will be useful,
524 // but WITHOUT ANY WARRANTY; without even the implied warranty of
525 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
526 // GNU General Public License for more details.
527 
528 // You should have received a copy of the GNU General Public License
529 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
530 
531 /* pragma solidity >=0.4.23; */
532 
533 /* import "ds-stop/stop.sol"; */
534 
535 /* import "./base.sol"; */
536 
537 contract DSToken is DSTokenBase(0), DSStop {
538 
539     bytes32  public  symbol;
540     uint256  public  decimals = 18; // standard token precision. override to customize
541 
542     constructor(bytes32 symbol_) public {
543         symbol = symbol_;
544     }
545 
546     event Mint(address indexed guy, uint wad);
547     event Burn(address indexed guy, uint wad);
548 
549     function approve(address guy) public stoppable returns (bool) {
550         return super.approve(guy, uint(-1));
551     }
552 
553     function approve(address guy, uint wad) public stoppable returns (bool) {
554         return super.approve(guy, wad);
555     }
556 
557     function transferFrom(address src, address dst, uint wad)
558         public
559         stoppable
560         returns (bool)
561     {
562         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
563             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
564             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
565         }
566 
567         require(_balances[src] >= wad, "ds-token-insufficient-balance");
568         _balances[src] = sub(_balances[src], wad);
569         _balances[dst] = add(_balances[dst], wad);
570 
571         emit Transfer(src, dst, wad);
572 
573         return true;
574     }
575 
576     function push(address dst, uint wad) public {
577         transferFrom(msg.sender, dst, wad);
578     }
579     function pull(address src, uint wad) public {
580         transferFrom(src, msg.sender, wad);
581     }
582     function move(address src, address dst, uint wad) public {
583         transferFrom(src, dst, wad);
584     }
585 
586     function mint(uint wad) public {
587         mint(msg.sender, wad);
588     }
589     function burn(uint wad) public {
590         burn(msg.sender, wad);
591     }
592     function mint(address guy, uint wad) public auth stoppable {
593         _balances[guy] = add(_balances[guy], wad);
594         _supply = add(_supply, wad);
595         emit Mint(guy, wad);
596     }
597     function burn(address guy, uint wad) public auth stoppable {
598         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
599             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
600             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
601         }
602 
603         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
604         _balances[guy] = sub(_balances[guy], wad);
605         _supply = sub(_supply, wad);
606         emit Burn(guy, wad);
607     }
608 
609     // Optional token name
610     bytes32   public  name = "";
611 
612     function setName(bytes32 name_) public auth {
613         name = name_;
614     }
615 }