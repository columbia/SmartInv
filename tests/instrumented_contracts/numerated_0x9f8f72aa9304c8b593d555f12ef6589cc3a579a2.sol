1 // MKR Token
2 
3 // hevm: flattened sources of src/mkr-499.sol
4 pragma solidity ^0.4.15;
5 
6 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU General Public License as published by
9 // the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU General Public License for more details.
16 
17 // You should have received a copy of the GNU General Public License
18 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
19 
20 /* pragma solidity ^0.4.13; */
21 
22 contract DSAuthority {
23     function canCall(
24         address src, address dst, bytes4 sig
25     ) public view returns (bool);
26 }
27 
28 contract DSAuthEvents {
29     event LogSetAuthority (address indexed authority);
30     event LogSetOwner     (address indexed owner);
31 }
32 
33 contract DSAuth is DSAuthEvents {
34     DSAuthority  public  authority;
35     address      public  owner;
36 
37     function DSAuth() public {
38         owner = msg.sender;
39         LogSetOwner(msg.sender);
40     }
41 
42     function setOwner(address owner_)
43         public
44         auth
45     {
46         owner = owner_;
47         LogSetOwner(owner);
48     }
49 
50     function setAuthority(DSAuthority authority_)
51         public
52         auth
53     {
54         authority = authority_;
55         LogSetAuthority(authority);
56     }
57 
58     modifier auth {
59         require(isAuthorized(msg.sender, msg.sig));
60         _;
61     }
62 
63     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
64         if (src == address(this)) {
65             return true;
66         } else if (src == owner) {
67             return true;
68         } else if (authority == DSAuthority(0)) {
69             return false;
70         } else {
71             return authority.canCall(src, this, sig);
72         }
73     }
74 }
75 
76 ////// lib/ds-thing/lib/ds-math/src/math.sol
77 /// math.sol -- mixin for inline numerical wizardry
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
94 contract DSMath {
95     function add(uint x, uint y) internal pure returns (uint z) {
96         require((z = x + y) >= x);
97     }
98     function sub(uint x, uint y) internal pure returns (uint z) {
99         require((z = x - y) <= x);
100     }
101     function mul(uint x, uint y) internal pure returns (uint z) {
102         require(y == 0 || (z = x * y) / y == x);
103     }
104 
105     function min(uint x, uint y) internal pure returns (uint z) {
106         return x <= y ? x : y;
107     }
108     function max(uint x, uint y) internal pure returns (uint z) {
109         return x >= y ? x : y;
110     }
111     function imin(int x, int y) internal pure returns (int z) {
112         return x <= y ? x : y;
113     }
114     function imax(int x, int y) internal pure returns (int z) {
115         return x >= y ? x : y;
116     }
117 
118     uint constant WAD = 10 ** 18;
119     uint constant RAY = 10 ** 27;
120 
121     function wmul(uint x, uint y) internal pure returns (uint z) {
122         z = add(mul(x, y), WAD / 2) / WAD;
123     }
124     function rmul(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, y), RAY / 2) / RAY;
126     }
127     function wdiv(uint x, uint y) internal pure returns (uint z) {
128         z = add(mul(x, WAD), y / 2) / y;
129     }
130     function rdiv(uint x, uint y) internal pure returns (uint z) {
131         z = add(mul(x, RAY), y / 2) / y;
132     }
133 
134     // This famous algorithm is called "exponentiation by squaring"
135     // and calculates x^n with x as fixed-point and n as regular unsigned.
136     //
137     // It's O(log n), instead of O(n) for naive repeated multiplication.
138     //
139     // These facts are why it works:
140     //
141     //  If n is even, then x^n = (x^2)^(n/2).
142     //  If n is odd,  then x^n = x * x^(n-1),
143     //   and applying the equation for even x gives
144     //    x^n = x * (x^2)^((n-1) / 2).
145     //
146     //  Also, EVM division is flooring and
147     //    floor[(n-1) / 2] = floor[n / 2].
148     //
149     function rpow(uint x, uint n) internal pure returns (uint z) {
150         z = n % 2 != 0 ? x : RAY;
151 
152         for (n /= 2; n != 0; n /= 2) {
153             x = rmul(x, x);
154 
155             if (n % 2 != 0) {
156                 z = rmul(z, x);
157             }
158         }
159     }
160 }
161 
162 ////// lib/ds-thing/lib/ds-note/src/note.sol
163 /// note.sol -- the `note' modifier, for logging calls as events
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
180 contract DSNote {
181     event LogNote(
182         bytes4   indexed  sig,
183         address  indexed  guy,
184         bytes32  indexed  foo,
185         bytes32  indexed  bar,
186         uint              wad,
187         bytes             fax
188     ) anonymous;
189 
190     modifier note {
191         bytes32 foo;
192         bytes32 bar;
193 
194         assembly {
195             foo := calldataload(4)
196             bar := calldataload(36)
197         }
198 
199         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
200 
201         _;
202     }
203 }
204 
205 ////// lib/ds-thing/src/thing.sol
206 // thing.sol - `auth` with handy mixins. your things should be DSThings
207 
208 // Copyright (C) 2017  DappHub, LLC
209 
210 // This program is free software: you can redistribute it and/or modify
211 // it under the terms of the GNU General Public License as published by
212 // the Free Software Foundation, either version 3 of the License, or
213 // (at your option) any later version.
214 
215 // This program is distributed in the hope that it will be useful,
216 // but WITHOUT ANY WARRANTY; without even the implied warranty of
217 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
218 // GNU General Public License for more details.
219 
220 // You should have received a copy of the GNU General Public License
221 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
222 
223 /* pragma solidity ^0.4.13; */
224 
225 /* import 'ds-auth/auth.sol'; */
226 /* import 'ds-note/note.sol'; */
227 /* import 'ds-math/math.sol'; */
228 
229 contract DSThing is DSAuth, DSNote, DSMath {
230 }
231 
232 ////// lib/ds-token/lib/ds-stop/src/stop.sol
233 /// stop.sol -- mixin for enable/disable functionality
234 
235 // Copyright (C) 2017  DappHub, LLC
236 
237 // This program is free software: you can redistribute it and/or modify
238 // it under the terms of the GNU General Public License as published by
239 // the Free Software Foundation, either version 3 of the License, or
240 // (at your option) any later version.
241 
242 // This program is distributed in the hope that it will be useful,
243 // but WITHOUT ANY WARRANTY; without even the implied warranty of
244 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
245 // GNU General Public License for more details.
246 
247 // You should have received a copy of the GNU General Public License
248 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
249 
250 /* pragma solidity ^0.4.13; */
251 
252 /* import "ds-auth/auth.sol"; */
253 /* import "ds-note/note.sol"; */
254 
255 contract DSStop is DSNote, DSAuth {
256 
257     bool public stopped;
258 
259     modifier stoppable {
260         require(!stopped);
261         _;
262     }
263     function stop() public auth note {
264         stopped = true;
265     }
266     function start() public auth note {
267         stopped = false;
268     }
269 
270 }
271 
272 ////// lib/ds-token/lib/erc20/src/erc20.sol
273 // This program is free software: you can redistribute it and/or modify
274 // it under the terms of the GNU General Public License as published by
275 // the Free Software Foundation, either version 3 of the License, or
276 // (at your option) any later version.
277 
278 // This program is distributed in the hope that it will be useful,
279 // but WITHOUT ANY WARRANTY; without even the implied warranty of
280 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
281 // GNU General Public License for more details.
282 
283 // You should have received a copy of the GNU General Public License
284 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
285 
286 /* pragma solidity ^0.4.8; */
287 
288 // Token standard API
289 // https://github.com/ethereum/EIPs/issues/20
290 
291 contract ERC20 {
292     function totalSupply() public view returns (uint supply);
293     function balanceOf( address who ) public view returns (uint value);
294     function allowance( address owner, address spender ) public view returns (uint _allowance);
295 
296     function transfer( address to, uint value) public returns (bool ok);
297     function transferFrom( address from, address to, uint value) public returns (bool ok);
298     function approve( address spender, uint value ) public returns (bool ok);
299 
300     event Transfer( address indexed from, address indexed to, uint value);
301     event Approval( address indexed owner, address indexed spender, uint value);
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
322 /* pragma solidity ^0.4.13; */
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
394 /* pragma solidity ^0.4.13; */
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