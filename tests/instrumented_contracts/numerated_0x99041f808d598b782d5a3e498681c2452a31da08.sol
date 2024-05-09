1 // Medianizer
2 // Copyright (C) 2017 Dapphub
3 
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU General Public License for more details.
13 
14 // You should have received a copy of the GNU General Public License
15 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
16 
17 // hevm: flattened sources of src/medianizer.sol
18 pragma solidity ^0.4.18;
19 
20 ////// lib/ds-value/lib/ds-thing/lib/ds-auth/src/auth.sol
21 // This program is free software: you can redistribute it and/or modify
22 // it under the terms of the GNU General Public License as published by
23 // the Free Software Foundation, either version 3 of the License, or
24 // (at your option) any later version.
25 
26 // This program is distributed in the hope that it will be useful,
27 // but WITHOUT ANY WARRANTY; without even the implied warranty of
28 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
29 // GNU General Public License for more details.
30 
31 // You should have received a copy of the GNU General Public License
32 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
33 
34 /* pragma solidity ^0.4.13; */
35 
36 contract DSAuthority {
37     function canCall(
38         address src, address dst, bytes4 sig
39     ) public view returns (bool);
40 }
41 
42 contract DSAuthEvents {
43     event LogSetAuthority (address indexed authority);
44     event LogSetOwner     (address indexed owner);
45 }
46 
47 contract DSAuth is DSAuthEvents {
48     DSAuthority  public  authority;
49     address      public  owner;
50 
51     function DSAuth() public {
52         owner = msg.sender;
53         LogSetOwner(msg.sender);
54     }
55 
56     function setOwner(address owner_)
57         public
58         auth
59     {
60         owner = owner_;
61         LogSetOwner(owner);
62     }
63 
64     function setAuthority(DSAuthority authority_)
65         public
66         auth
67     {
68         authority = authority_;
69         LogSetAuthority(authority);
70     }
71 
72     modifier auth {
73         require(isAuthorized(msg.sender, msg.sig));
74         _;
75     }
76 
77     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
78         if (src == address(this)) {
79             return true;
80         } else if (src == owner) {
81             return true;
82         } else if (authority == DSAuthority(0)) {
83             return false;
84         } else {
85             return authority.canCall(src, this, sig);
86         }
87     }
88 }
89 
90 ////// lib/ds-value/lib/ds-thing/lib/ds-math/src/math.sol
91 /// math.sol -- mixin for inline numerical wizardry
92 
93 // This program is free software: you can redistribute it and/or modify
94 // it under the terms of the GNU General Public License as published by
95 // the Free Software Foundation, either version 3 of the License, or
96 // (at your option) any later version.
97 
98 // This program is distributed in the hope that it will be useful,
99 // but WITHOUT ANY WARRANTY; without even the implied warranty of
100 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
101 // GNU General Public License for more details.
102 
103 // You should have received a copy of the GNU General Public License
104 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
105 
106 /* pragma solidity ^0.4.13; */
107 
108 contract DSMath {
109     function add(uint x, uint y) internal pure returns (uint z) {
110         require((z = x + y) >= x);
111     }
112     function sub(uint x, uint y) internal pure returns (uint z) {
113         require((z = x - y) <= x);
114     }
115     function mul(uint x, uint y) internal pure returns (uint z) {
116         require(y == 0 || (z = x * y) / y == x);
117     }
118 
119     function min(uint x, uint y) internal pure returns (uint z) {
120         return x <= y ? x : y;
121     }
122     function max(uint x, uint y) internal pure returns (uint z) {
123         return x >= y ? x : y;
124     }
125     function imin(int x, int y) internal pure returns (int z) {
126         return x <= y ? x : y;
127     }
128     function imax(int x, int y) internal pure returns (int z) {
129         return x >= y ? x : y;
130     }
131 
132     uint constant WAD = 10 ** 18;
133     uint constant RAY = 10 ** 27;
134 
135     function wmul(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, y), WAD / 2) / WAD;
137     }
138     function rmul(uint x, uint y) internal pure returns (uint z) {
139         z = add(mul(x, y), RAY / 2) / RAY;
140     }
141     function wdiv(uint x, uint y) internal pure returns (uint z) {
142         z = add(mul(x, WAD), y / 2) / y;
143     }
144     function rdiv(uint x, uint y) internal pure returns (uint z) {
145         z = add(mul(x, RAY), y / 2) / y;
146     }
147 
148     // This famous algorithm is called "exponentiation by squaring"
149     // and calculates x^n with x as fixed-point and n as regular unsigned.
150     //
151     // It's O(log n), instead of O(n) for naive repeated multiplication.
152     //
153     // These facts are why it works:
154     //
155     //  If n is even, then x^n = (x^2)^(n/2).
156     //  If n is odd,  then x^n = x * x^(n-1),
157     //   and applying the equation for even x gives
158     //    x^n = x * (x^2)^((n-1) / 2).
159     //
160     //  Also, EVM division is flooring and
161     //    floor[(n-1) / 2] = floor[n / 2].
162     //
163     function rpow(uint x, uint n) internal pure returns (uint z) {
164         z = n % 2 != 0 ? x : RAY;
165 
166         for (n /= 2; n != 0; n /= 2) {
167             x = rmul(x, x);
168 
169             if (n % 2 != 0) {
170                 z = rmul(z, x);
171             }
172         }
173     }
174 }
175 
176 ////// lib/ds-value/lib/ds-thing/lib/ds-note/src/note.sol
177 /// note.sol -- the `note' modifier, for logging calls as events
178 
179 // This program is free software: you can redistribute it and/or modify
180 // it under the terms of the GNU General Public License as published by
181 // the Free Software Foundation, either version 3 of the License, or
182 // (at your option) any later version.
183 
184 // This program is distributed in the hope that it will be useful,
185 // but WITHOUT ANY WARRANTY; without even the implied warranty of
186 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
187 // GNU General Public License for more details.
188 
189 // You should have received a copy of the GNU General Public License
190 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
191 
192 /* pragma solidity ^0.4.13; */
193 
194 contract DSNote {
195     event LogNote(
196         bytes4   indexed  sig,
197         address  indexed  guy,
198         bytes32  indexed  foo,
199         bytes32  indexed  bar,
200         uint              wad,
201         bytes             fax
202     ) anonymous;
203 
204     modifier note {
205         bytes32 foo;
206         bytes32 bar;
207 
208         assembly {
209             foo := calldataload(4)
210             bar := calldataload(36)
211         }
212 
213         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
214 
215         _;
216     }
217 }
218 
219 ////// lib/ds-value/lib/ds-thing/src/thing.sol
220 // thing.sol - `auth` with handy mixins. your things should be DSThings
221 
222 // Copyright (C) 2017  DappHub, LLC
223 
224 // This program is free software: you can redistribute it and/or modify
225 // it under the terms of the GNU General Public License as published by
226 // the Free Software Foundation, either version 3 of the License, or
227 // (at your option) any later version.
228 
229 // This program is distributed in the hope that it will be useful,
230 // but WITHOUT ANY WARRANTY; without even the implied warranty of
231 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
232 // GNU General Public License for more details.
233 
234 // You should have received a copy of the GNU General Public License
235 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
236 
237 /* pragma solidity ^0.4.13; */
238 
239 /* import 'ds-auth/auth.sol'; */
240 /* import 'ds-note/note.sol'; */
241 /* import 'ds-math/math.sol'; */
242 
243 contract DSThing is DSAuth, DSNote, DSMath {
244 }
245 
246 ////// lib/ds-value/src/value.sol
247 /// value.sol - a value is a simple thing, it can be get and set
248 
249 // Copyright (C) 2017  DappHub, LLC
250 
251 // This program is free software: you can redistribute it and/or modify
252 // it under the terms of the GNU General Public License as published by
253 // the Free Software Foundation, either version 3 of the License, or
254 // (at your option) any later version.
255 
256 // This program is distributed in the hope that it will be useful,
257 // but WITHOUT ANY WARRANTY; without even the implied warranty of
258 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
259 // GNU General Public License for more details.
260 
261 // You should have received a copy of the GNU General Public License
262 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
263 
264 /* pragma solidity ^0.4.13; */
265 
266 /* import 'ds-thing/thing.sol'; */
267 
268 contract DSValue is DSThing {
269     bool    has;
270     bytes32 val;
271     function peek() public view returns (bytes32, bool) {
272         return (val,has);
273     }
274     function read() public view returns (bytes32) {
275         var (wut, haz) = peek();
276         assert(haz);
277         return wut;
278     }
279     function poke(bytes32 wut) public note auth {
280         val = wut;
281         has = true;
282     }
283     function void() public note auth {  // unset the value
284         has = false;
285     }
286 }
287 
288 ////// src/medianizer.sol
289 /* pragma solidity ^0.4.18; */
290 
291 /* import 'ds-value/value.sol'; */
292 
293 contract MedianizerEvents {
294     event LogValue(bytes32 val);
295 }
296 
297 contract Medianizer is DSValue, MedianizerEvents {
298     mapping (bytes12 => address) public values;
299     mapping (address => bytes12) public indexes;
300     bytes12 public next = 0x1;
301 
302     uint96 public min = 0x1;
303 
304     function set(address wat) public auth {
305         bytes12 nextId = bytes12(uint96(next) + 1);
306         assert(nextId != 0x0);
307         this.set(next, wat);
308         next = nextId;
309     }
310 
311     function set(bytes12 pos, address wat) public note auth {
312         require(pos != 0x0);
313         require(wat == 0 || indexes[wat] == 0);
314 
315         indexes[values[pos]] = 0x0; // Making sure to remove a possible existing address in that position
316 
317         if (wat != 0) {
318             indexes[wat] = pos;
319         }
320 
321         values[pos] = wat;
322     }
323 
324     function setMin(uint96 min_) public note auth {
325         require(min_ != 0x0);
326         min = min_;
327     }
328 
329     function setNext(bytes12 next_) public note auth {
330         require(next_ != 0x0);
331         next = next_;
332     }
333 
334     function unset(bytes12 pos) public auth {
335         this.set(pos, 0);
336     }
337 
338     function unset(address wat) public auth {
339         this.set(indexes[wat], 0);
340     }
341 
342     function poke() public {
343         poke(0);
344     }
345 
346     function poke(bytes32) public note {
347         (val, has) = compute();
348         LogValue(val);
349     }
350 
351     function compute() public constant returns (bytes32, bool) {
352         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
353         uint96 ctr = 0;
354         for (uint96 i = 1; i < uint96(next); i++) {
355             if (values[bytes12(i)] != 0) {
356                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
357                 if (wuz) {
358                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
359                         wuts[ctr] = wut;
360                     } else {
361                         uint96 j = 0;
362                         while (wut >= wuts[j]) {
363                             j++;
364                         }
365                         for (uint96 k = ctr; k > j; k--) {
366                             wuts[k] = wuts[k - 1];
367                         }
368                         wuts[j] = wut;
369                     }
370                     ctr++;
371                 }
372             }
373         }
374 
375         if (ctr < min) {
376             return (val, false);
377         }
378 
379         bytes32 value;
380         if (ctr % 2 == 0) {
381             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
382             uint128 val2 = uint128(wuts[ctr / 2]);
383             value = bytes32(wdiv(add(val1, val2), 2 ether));
384         } else {
385             value = wuts[(ctr - 1) / 2];
386         }
387 
388         return (value, true);
389     }
390 
391 }