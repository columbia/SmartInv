1 // hevm: flattened sources of src/token.sol
2 pragma solidity ^0.4.23;
3 
4 ////// lib/ds-math/src/math.sol
5 /// math.sol -- mixin for inline numerical wizardry
6 
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
22 contract DSMath {
23     function add(uint x, uint y) internal pure returns (uint z) {
24         require((z = x + y) >= x);
25     }
26     function sub(uint x, uint y) internal pure returns (uint z) {
27         require((z = x - y) <= x);
28     }
29     function mul(uint x, uint y) internal pure returns (uint z) {
30         require(y == 0 || (z = x * y) / y == x);
31     }
32 
33     function min(uint x, uint y) internal pure returns (uint z) {
34         return x <= y ? x : y;
35     }
36     function max(uint x, uint y) internal pure returns (uint z) {
37         return x >= y ? x : y;
38     }
39     function imin(int x, int y) internal pure returns (int z) {
40         return x <= y ? x : y;
41     }
42     function imax(int x, int y) internal pure returns (int z) {
43         return x >= y ? x : y;
44     }
45 
46     uint constant WAD = 10 ** 18;
47     uint constant RAY = 10 ** 27;
48 
49     function wmul(uint x, uint y) internal pure returns (uint z) {
50         z = add(mul(x, y), WAD / 2) / WAD;
51     }
52     function rmul(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, y), RAY / 2) / RAY;
54     }
55     function wdiv(uint x, uint y) internal pure returns (uint z) {
56         z = add(mul(x, WAD), y / 2) / y;
57     }
58     function rdiv(uint x, uint y) internal pure returns (uint z) {
59         z = add(mul(x, RAY), y / 2) / y;
60     }
61 
62     // This famous algorithm is called "exponentiation by squaring"
63     // and calculates x^n with x as fixed-point and n as regular unsigned.
64     //
65     // It's O(log n), instead of O(n) for naive repeated multiplication.
66     //
67     // These facts are why it works:
68     //
69     //  If n is even, then x^n = (x^2)^(n/2).
70     //  If n is odd,  then x^n = x * x^(n-1),
71     //   and applying the equation for even x gives
72     //    x^n = x * (x^2)^((n-1) / 2).
73     //
74     //  Also, EVM division is flooring and
75     //    floor[(n-1) / 2] = floor[n / 2].
76     //
77     function rpow(uint x, uint n) internal pure returns (uint z) {
78         z = n % 2 != 0 ? x : RAY;
79 
80         for (n /= 2; n != 0; n /= 2) {
81             x = rmul(x, x);
82 
83             if (n % 2 != 0) {
84                 z = rmul(z, x);
85             }
86         }
87     }
88 }
89 
90 ////// lib/ds-stop/lib/ds-auth/src/auth.sol
91 // This program is free software: you can redistribute it and/or modify
92 // it under the terms of the GNU General Public License as published by
93 // the Free Software Foundation, either version 3 of the License, or
94 // (at your option) any later version.
95 
96 // This program is distributed in the hope that it will be useful,
97 // but WITHOUT ANY WARRANTY; without even the implied warranty of
98 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
99 // GNU General Public License for more details.
100 
101 // You should have received a copy of the GNU General Public License
102 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
103 
104 /* pragma solidity ^0.4.23; */
105 
106 contract DSAuthority {
107     function canCall(
108         address src, address dst, bytes4 sig
109     ) public view returns (bool);
110 }
111 
112 contract DSAuthEvents {
113     event LogSetAuthority (address indexed authority);
114     event LogSetOwner     (address indexed owner);
115 }
116 
117 contract DSAuth is DSAuthEvents {
118     DSAuthority  public  authority;
119     address      public  owner;
120 
121     constructor() public {
122         owner = msg.sender;
123         emit LogSetOwner(msg.sender);
124     }
125 
126     function setOwner(address owner_)
127         public
128         auth
129     {
130         owner = owner_;
131         emit LogSetOwner(owner);
132     }
133 
134     function setAuthority(DSAuthority authority_)
135         public
136         auth
137     {
138         authority = authority_;
139         emit LogSetAuthority(authority);
140     }
141 
142     modifier auth {
143         require(isAuthorized(msg.sender, msg.sig));
144         _;
145     }
146 
147     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
148         if (src == address(this)) {
149             return true;
150         } else if (src == owner) {
151             return true;
152         } else if (authority == DSAuthority(0)) {
153             return false;
154         } else {
155             return authority.canCall(src, this, sig);
156         }
157     }
158 }
159 
160 ////// lib/ds-stop/lib/ds-note/src/note.sol
161 /// note.sol -- the `note' modifier, for logging calls as events
162 
163 // This program is free software: you can redistribute it and/or modify
164 // it under the terms of the GNU General Public License as published by
165 // the Free Software Foundation, either version 3 of the License, or
166 // (at your option) any later version.
167 
168 // This program is distributed in the hope that it will be useful,
169 // but WITHOUT ANY WARRANTY; without even the implied warranty of
170 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
171 // GNU General Public License for more details.
172 
173 // You should have received a copy of the GNU General Public License
174 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
175 
176 /* pragma solidity ^0.4.23; */
177 
178 contract DSNote {
179     event LogNote(
180         bytes4   indexed  sig,
181         address  indexed  guy,
182         bytes32  indexed  foo,
183         bytes32  indexed  bar,
184         uint              wad,
185         bytes             fax
186     ) anonymous;
187 
188     modifier note {
189         bytes32 foo;
190         bytes32 bar;
191 
192         assembly {
193             foo := calldataload(4)
194             bar := calldataload(36)
195         }
196 
197         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
198 
199         _;
200     }
201 }
202 
203 ////// lib/ds-stop/src/stop.sol
204 /// stop.sol -- mixin for enable/disable functionality
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
221 /* pragma solidity ^0.4.23; */
222 
223 /* import "ds-auth/auth.sol"; */
224 /* import "ds-note/note.sol"; */
225 
226 contract DSStop is DSNote, DSAuth {
227 
228     bool public stopped;
229 
230     modifier stoppable {
231         require(!stopped);
232         _;
233     }
234     function stop() public auth note {
235         stopped = true;
236     }
237     function start() public auth note {
238         stopped = false;
239     }
240 
241 }
242 
243 ////// lib/erc20/src/erc20.sol
244 /// erc20.sol -- API for the ERC20 token standard
245 
246 // See <https://github.com/ethereum/EIPs/issues/20>.
247 
248 // This file likely does not meet the threshold of originality
249 // required for copyright to apply.  As a result, this is free and
250 // unencumbered software belonging to the public domain.
251 
252 /* pragma solidity ^0.4.8; */
253 
254 contract ERC20Events {
255     event Approval(address indexed src, address indexed guy, uint wad);
256     event Transfer(address indexed src, address indexed dst, uint wad);
257 }
258 
259 contract ERC20 is ERC20Events {
260     function totalSupply() public view returns (uint);
261     function balanceOf(address guy) public view returns (uint);
262     function allowance(address src, address guy) public view returns (uint);
263 
264     function approve(address guy, uint wad) public returns (bool);
265     function transfer(address dst, uint wad) public returns (bool);
266     function transferFrom(
267         address src, address dst, uint wad
268     ) public returns (bool);
269 }
270 
271 ////// src/base.sol
272 /// base.sol -- basic ERC20 implementation
273 
274 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
275 
276 // This program is free software: you can redistribute it and/or modify
277 // it under the terms of the GNU General Public License as published by
278 // the Free Software Foundation, either version 3 of the License, or
279 // (at your option) any later version.
280 
281 // This program is distributed in the hope that it will be useful,
282 // but WITHOUT ANY WARRANTY; without even the implied warranty of
283 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
284 // GNU General Public License for more details.
285 
286 // You should have received a copy of the GNU General Public License
287 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
288 
289 /* pragma solidity ^0.4.23; */
290 
291 /* import "erc20/erc20.sol"; */
292 /* import "ds-math/math.sol"; */
293 
294 contract DSTokenBase is ERC20, DSMath {
295     uint256                                            _supply;
296     mapping (address => uint256)                       _balances;
297     mapping (address => mapping (address => uint256))  _approvals;
298 
299     constructor(uint supply) public {
300         _balances[msg.sender] = supply;
301         _supply = supply;
302     }
303 
304     function totalSupply() public view returns (uint) {
305         return _supply;
306     }
307     function balanceOf(address src) public view returns (uint) {
308         return _balances[src];
309     }
310     function allowance(address src, address guy) public view returns (uint) {
311         return _approvals[src][guy];
312     }
313 
314     function transfer(address dst, uint wad) public returns (bool) {
315         return transferFrom(msg.sender, dst, wad);
316     }
317 
318     function transferFrom(address src, address dst, uint wad)
319         public
320         returns (bool)
321     {
322         if (src != msg.sender) {
323             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
324         }
325 
326         _balances[src] = sub(_balances[src], wad);
327         _balances[dst] = add(_balances[dst], wad);
328 
329         emit Transfer(src, dst, wad);
330 
331         return true;
332     }
333 
334     function approve(address guy, uint wad) public returns (bool) {
335         _approvals[msg.sender][guy] = wad;
336 
337         emit Approval(msg.sender, guy, wad);
338 
339         return true;
340     }
341 }
342 
343 ////// src/token.sol
344 /// token.sol -- ERC20 implementation with minting and burning
345 
346 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
347 
348 // This program is free software: you can redistribute it and/or modify
349 // it under the terms of the GNU General Public License as published by
350 // the Free Software Foundation, either version 3 of the License, or
351 // (at your option) any later version.
352 
353 // This program is distributed in the hope that it will be useful,
354 // but WITHOUT ANY WARRANTY; without even the implied warranty of
355 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
356 // GNU General Public License for more details.
357 
358 // You should have received a copy of the GNU General Public License
359 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
360 
361 /* pragma solidity ^0.4.23; */
362 
363 /* import "ds-stop/stop.sol"; */
364 
365 /* import "./base.sol"; */
366 
367 contract DSToken is DSTokenBase(0), DSStop {
368 
369     bytes32  public  symbol;
370     uint256  public  decimals = 18; // standard token precision. override to customize
371 
372     constructor(bytes32 symbol_) public {
373         symbol = symbol_;
374     }
375 
376     event Mint(address indexed guy, uint wad);
377     event Burn(address indexed guy, uint wad);
378 
379     function approve(address guy) public stoppable returns (bool) {
380         return super.approve(guy, uint(-1));
381     }
382 
383     function approve(address guy, uint wad) public stoppable returns (bool) {
384         return super.approve(guy, wad);
385     }
386 
387     function transferFrom(address src, address dst, uint wad)
388         public
389         stoppable
390         returns (bool)
391     {
392         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
393             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
394         }
395 
396         _balances[src] = sub(_balances[src], wad);
397         _balances[dst] = add(_balances[dst], wad);
398 
399         emit Transfer(src, dst, wad);
400 
401         return true;
402     }
403 
404     function push(address dst, uint wad) public {
405         transferFrom(msg.sender, dst, wad);
406     }
407     function pull(address src, uint wad) public {
408         transferFrom(src, msg.sender, wad);
409     }
410     function move(address src, address dst, uint wad) public {
411         transferFrom(src, dst, wad);
412     }
413 
414     function mint(uint wad) public {
415         mint(msg.sender, wad);
416     }
417     function burn(uint wad) public {
418         burn(msg.sender, wad);
419     }
420     function mint(address guy, uint wad) public auth stoppable {
421         _balances[guy] = add(_balances[guy], wad);
422         _supply = add(_supply, wad);
423         emit Mint(guy, wad);
424     }
425     function burn(address guy, uint wad) public auth stoppable {
426         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
427             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
428         }
429 
430         _balances[guy] = sub(_balances[guy], wad);
431         _supply = sub(_supply, wad);
432         emit Burn(guy, wad);
433     }
434 
435     // Optional token name
436     bytes32   public  name = "";
437 
438     function setName(bytes32 name_) public auth {
439         name = name_;
440     }
441 }