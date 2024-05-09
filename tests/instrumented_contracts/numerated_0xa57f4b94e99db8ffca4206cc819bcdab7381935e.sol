1 // Copyright 2018 Dapphub
2 // medianizer.sol
3 
4 // hevm: flattened sources of src/medianizer.sol
5 pragma solidity ^0.4.19;
6 
7 ////// lib/medianizer/lib/ds-value/lib/ds-thing/lib/ds-auth/src/auth.sol
8 // This program is free software: you can redistribute it and/or modify
9 // it under the terms of the GNU General Public License as published by
10 // the Free Software Foundation, either version 3 of the License, or
11 // (at your option) any later version.
12 
13 // This program is distributed in the hope that it will be useful,
14 // but WITHOUT ANY WARRANTY; without even the implied warranty of
15 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16 // GNU General Public License for more details.
17 
18 // You should have received a copy of the GNU General Public License
19 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
20 
21 /* pragma solidity ^0.4.13; */
22 
23 contract DSAuthority {
24     function canCall(
25         address src, address dst, bytes4 sig
26     ) public view returns (bool);
27 }
28 
29 contract DSAuthEvents {
30     event LogSetAuthority (address indexed authority);
31     event LogSetOwner     (address indexed owner);
32 }
33 
34 contract DSAuth is DSAuthEvents {
35     DSAuthority  public  authority;
36     address      public  owner;
37 
38     function DSAuth() public {
39         owner = msg.sender;
40         LogSetOwner(msg.sender);
41     }
42 
43     function setOwner(address owner_)
44         public
45         auth
46     {
47         owner = owner_;
48         LogSetOwner(owner);
49     }
50 
51     function setAuthority(DSAuthority authority_)
52         public
53         auth
54     {
55         authority = authority_;
56         LogSetAuthority(authority);
57     }
58 
59     modifier auth {
60         require(isAuthorized(msg.sender, msg.sig));
61         _;
62     }
63 
64     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
65         if (src == address(this)) {
66             return true;
67         } else if (src == owner) {
68             return true;
69         } else if (authority == DSAuthority(0)) {
70             return false;
71         } else {
72             return authority.canCall(src, this, sig);
73         }
74     }
75 }
76 
77 ////// lib/medianizer/lib/ds-value/lib/ds-thing/lib/ds-math/src/math.sol
78 /// math.sol -- mixin for inline numerical wizardry
79 
80 // This program is free software: you can redistribute it and/or modify
81 // it under the terms of the GNU General Public License as published by
82 // the Free Software Foundation, either version 3 of the License, or
83 // (at your option) any later version.
84 
85 // This program is distributed in the hope that it will be useful,
86 // but WITHOUT ANY WARRANTY; without even the implied warranty of
87 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
88 // GNU General Public License for more details.
89 
90 // You should have received a copy of the GNU General Public License
91 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
92 
93 /* pragma solidity ^0.4.13; */
94 
95 contract DSMath {
96     function add(uint x, uint y) internal pure returns (uint z) {
97         require((z = x + y) >= x);
98     }
99     function sub(uint x, uint y) internal pure returns (uint z) {
100         require((z = x - y) <= x);
101     }
102     function mul(uint x, uint y) internal pure returns (uint z) {
103         require(y == 0 || (z = x * y) / y == x);
104     }
105 
106     function min(uint x, uint y) internal pure returns (uint z) {
107         return x <= y ? x : y;
108     }
109     function max(uint x, uint y) internal pure returns (uint z) {
110         return x >= y ? x : y;
111     }
112     function imin(int x, int y) internal pure returns (int z) {
113         return x <= y ? x : y;
114     }
115     function imax(int x, int y) internal pure returns (int z) {
116         return x >= y ? x : y;
117     }
118 
119     uint constant WAD = 10 ** 18;
120     uint constant RAY = 10 ** 27;
121 
122     function wmul(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, y), WAD / 2) / WAD;
124     }
125     function rmul(uint x, uint y) internal pure returns (uint z) {
126         z = add(mul(x, y), RAY / 2) / RAY;
127     }
128     function wdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, WAD), y / 2) / y;
130     }
131     function rdiv(uint x, uint y) internal pure returns (uint z) {
132         z = add(mul(x, RAY), y / 2) / y;
133     }
134 
135     // This famous algorithm is called "exponentiation by squaring"
136     // and calculates x^n with x as fixed-point and n as regular unsigned.
137     //
138     // It's O(log n), instead of O(n) for naive repeated multiplication.
139     //
140     // These facts are why it works:
141     //
142     //  If n is even, then x^n = (x^2)^(n/2).
143     //  If n is odd,  then x^n = x * x^(n-1),
144     //   and applying the equation for even x gives
145     //    x^n = x * (x^2)^((n-1) / 2).
146     //
147     //  Also, EVM division is flooring and
148     //    floor[(n-1) / 2] = floor[n / 2].
149     //
150     function rpow(uint x, uint n) internal pure returns (uint z) {
151         z = n % 2 != 0 ? x : RAY;
152 
153         for (n /= 2; n != 0; n /= 2) {
154             x = rmul(x, x);
155 
156             if (n % 2 != 0) {
157                 z = rmul(z, x);
158             }
159         }
160     }
161 }
162 
163 ////// lib/medianizer/lib/ds-value/lib/ds-thing/lib/ds-note/src/note.sol
164 /// note.sol -- the `note' modifier, for logging calls as events
165 
166 // This program is free software: you can redistribute it and/or modify
167 // it under the terms of the GNU General Public License as published by
168 // the Free Software Foundation, either version 3 of the License, or
169 // (at your option) any later version.
170 
171 // This program is distributed in the hope that it will be useful,
172 // but WITHOUT ANY WARRANTY; without even the implied warranty of
173 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
174 // GNU General Public License for more details.
175 
176 // You should have received a copy of the GNU General Public License
177 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
178 
179 /* pragma solidity ^0.4.13; */
180 
181 contract DSNote {
182     event LogNote(
183         bytes4   indexed  sig,
184         address  indexed  guy,
185         bytes32  indexed  foo,
186         bytes32  indexed  bar,
187         uint              wad,
188         bytes             fax
189     ) anonymous;
190 
191     modifier note {
192         bytes32 foo;
193         bytes32 bar;
194 
195         assembly {
196             foo := calldataload(4)
197             bar := calldataload(36)
198         }
199 
200         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
201 
202         _;
203     }
204 }
205 
206 ////// lib/medianizer/lib/ds-value/lib/ds-thing/src/thing.sol
207 // thing.sol - `auth` with handy mixins. your things should be DSThings
208 
209 // Copyright (C) 2017  DappHub, LLC
210 
211 // This program is free software: you can redistribute it and/or modify
212 // it under the terms of the GNU General Public License as published by
213 // the Free Software Foundation, either version 3 of the License, or
214 // (at your option) any later version.
215 
216 // This program is distributed in the hope that it will be useful,
217 // but WITHOUT ANY WARRANTY; without even the implied warranty of
218 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
219 // GNU General Public License for more details.
220 
221 // You should have received a copy of the GNU General Public License
222 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
223 
224 /* pragma solidity ^0.4.13; */
225 
226 /* import 'ds-auth/auth.sol'; */
227 /* import 'ds-note/note.sol'; */
228 /* import 'ds-math/math.sol'; */
229 
230 contract DSThing is DSAuth, DSNote, DSMath {
231 }
232 
233 ////// lib/medianizer/lib/ds-value/src/value.sol
234 /// value.sol - a value is a simple thing, it can be get and set
235 
236 // Copyright (C) 2017  DappHub, LLC
237 
238 // This program is free software: you can redistribute it and/or modify
239 // it under the terms of the GNU General Public License as published by
240 // the Free Software Foundation, either version 3 of the License, or
241 // (at your option) any later version.
242 
243 // This program is distributed in the hope that it will be useful,
244 // but WITHOUT ANY WARRANTY; without even the implied warranty of
245 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
246 // GNU General Public License for more details.
247 
248 // You should have received a copy of the GNU General Public License
249 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
250 
251 /* pragma solidity ^0.4.13; */
252 
253 /* import 'ds-thing/thing.sol'; */
254 
255 contract DSValue is DSThing {
256     bool    has;
257     bytes32 val;
258     function peek() public view returns (bytes32, bool) {
259         return (val,has);
260     }
261     function read() public view returns (bytes32) {
262         var (wut, haz) = peek();
263         assert(haz);
264         return wut;
265     }
266     function poke(bytes32 wut) public note auth {
267         val = wut;
268         has = true;
269     }
270     function void() public note auth {  // unset the value
271         has = false;
272     }
273 }
274 
275 ////// lib/medianizer/src/medianizer.sol
276 /* pragma solidity ^0.4.18; */
277 
278 /* import 'ds-value/value.sol'; */
279 
280 contract MedianizerEvents {
281     event LogValue(bytes32 val);
282 }
283 
284 contract Medianizer is DSValue, MedianizerEvents {
285     mapping (bytes12 => address) public values;
286     mapping (address => bytes12) public indexes;
287     bytes12 public next = 0x1;
288 
289     uint96 public min = 0x1;
290 
291     function set(address wat) public auth {
292         bytes12 nextId = bytes12(uint96(next) + 1);
293         assert(nextId != 0x0);
294         this.set(next, wat);
295         next = nextId;
296     }
297 
298     function set(bytes12 pos, address wat) public note auth {
299         require(pos != 0x0);
300         require(wat == 0 || indexes[wat] == 0);
301 
302         indexes[values[pos]] = 0x0; // Making sure to remove a possible existing address in that position
303 
304         if (wat != 0) {
305             indexes[wat] = pos;
306         }
307 
308         values[pos] = wat;
309     }
310 
311     function setMin(uint96 min_) public note auth {
312         require(min_ != 0x0);
313         min = min_;
314     }
315 
316     function setNext(bytes12 next_) public note auth {
317         require(next_ != 0x0);
318         next = next_;
319     }
320 
321     function unset(bytes12 pos) public auth {
322         this.set(pos, 0);
323     }
324 
325     function unset(address wat) public auth {
326         this.set(indexes[wat], 0);
327     }
328 
329     function poke() public {
330         poke(0);
331     }
332 
333     function poke(bytes32) public note {
334         (val, has) = compute();
335         LogValue(val);
336     }
337 
338     function compute() public constant returns (bytes32, bool) {
339         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
340         uint96 ctr = 0;
341         for (uint96 i = 1; i < uint96(next); i++) {
342             if (values[bytes12(i)] != 0) {
343                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
344                 if (wuz) {
345                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
346                         wuts[ctr] = wut;
347                     } else {
348                         uint96 j = 0;
349                         while (wut >= wuts[j]) {
350                             j++;
351                         }
352                         for (uint96 k = ctr; k > j; k--) {
353                             wuts[k] = wuts[k - 1];
354                         }
355                         wuts[j] = wut;
356                     }
357                     ctr++;
358                 }
359             }
360         }
361 
362         if (ctr < min) {
363             return (val, false);
364         }
365 
366         bytes32 value;
367         if (ctr % 2 == 0) {
368             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
369             uint128 val2 = uint128(wuts[ctr / 2]);
370             value = bytes32(wdiv(add(val1, val2), 2 ether));
371         } else {
372             value = wuts[(ctr - 1) / 2];
373         }
374 
375         return (value, true);
376     }
377 
378 }