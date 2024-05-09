1 /// return median value of feeds
2 
3 // Copyright (C) 2017  DappHub, LLC
4 
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 pragma solidity ^0.4.8;
13 
14 contract DSAuthority {
15     function canCall(
16         address src, address dst, bytes4 sig
17     ) constant returns (bool);
18 }
19 
20 contract DSAuthEvents {
21     event LogSetAuthority (address indexed authority);
22     event LogSetOwner     (address indexed owner);
23 }
24 
25 contract DSAuth is DSAuthEvents {
26     DSAuthority  public  authority;
27     address      public  owner;
28 
29     function DSAuth() {
30         owner = msg.sender;
31         LogSetOwner(msg.sender);
32     }
33 
34     function setOwner(address owner_)
35         auth
36     {
37         owner = owner_;
38         LogSetOwner(owner);
39     }
40 
41     function setAuthority(DSAuthority authority_)
42         auth
43     {
44         authority = authority_;
45         LogSetAuthority(authority);
46     }
47 
48     modifier auth {
49         assert(isAuthorized(msg.sender, msg.sig));
50         _;
51     }
52 
53     modifier authorized(bytes4 sig) {
54         assert(isAuthorized(msg.sender, sig));
55         _;
56     }
57 
58     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
59         if (src == address(this)) {
60             return true;
61         } else if (src == owner) {
62             return true;
63         } else if (authority == DSAuthority(0)) {
64             return false;
65         } else {
66             return authority.canCall(src, this, sig);
67         }
68     }
69 
70     function assert(bool x) internal {
71         if (!x) throw;
72     }
73 }
74 
75 contract DSNote {
76     event LogNote(
77         bytes4   indexed  sig,
78         address  indexed  guy,
79         bytes32  indexed  foo,
80         bytes32  indexed  bar,
81 	uint	 	  wad,
82         bytes             fax
83     ) anonymous;
84 
85     modifier note {
86         bytes32 foo;
87         bytes32 bar;
88 
89         assembly {
90             foo := calldataload(4)
91             bar := calldataload(36)
92         }
93 
94         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
95 
96         _;
97     }
98 }
99 
100 contract DSMath {
101     
102     /*
103     standard uint256 functions
104      */
105 
106     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
107         assert((z = x + y) >= x);
108     }
109 
110     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
111         assert((z = x - y) <= x);
112     }
113 
114     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
115         assert((z = x * y) >= x);
116     }
117 
118     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
119         z = x / y;
120     }
121 
122     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
123         return x <= y ? x : y;
124     }
125     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
126         return x >= y ? x : y;
127     }
128 
129     /*
130     uint128 functions (h is for half)
131      */
132 
133 
134     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         assert((z = x + y) >= x);
136     }
137 
138     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
139         assert((z = x - y) <= x);
140     }
141 
142     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
143         assert((z = x * y) >= x);
144     }
145 
146     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
147         z = x / y;
148     }
149 
150     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
151         return x <= y ? x : y;
152     }
153     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
154         return x >= y ? x : y;
155     }
156 
157 
158     /*
159     int256 functions
160      */
161 
162     function imin(int256 x, int256 y) constant internal returns (int256 z) {
163         return x <= y ? x : y;
164     }
165     function imax(int256 x, int256 y) constant internal returns (int256 z) {
166         return x >= y ? x : y;
167     }
168 
169     /*
170     WAD math
171      */
172 
173     uint128 constant WAD = 10 ** 18;
174 
175     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
176         return hadd(x, y);
177     }
178 
179     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
180         return hsub(x, y);
181     }
182 
183     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
184         z = cast((uint256(x) * y + WAD / 2) / WAD);
185     }
186 
187     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
188         z = cast((uint256(x) * WAD + y / 2) / y);
189     }
190 
191     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
192         return hmin(x, y);
193     }
194     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
195         return hmax(x, y);
196     }
197 
198     /*
199     RAY math
200      */
201 
202     uint128 constant RAY = 10 ** 27;
203 
204     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
205         return hadd(x, y);
206     }
207 
208     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
209         return hsub(x, y);
210     }
211 
212     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
213         z = cast((uint256(x) * y + RAY / 2) / RAY);
214     }
215 
216     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
217         z = cast((uint256(x) * RAY + y / 2) / y);
218     }
219 
220     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
221         // This famous algorithm is called "exponentiation by squaring"
222         // and calculates x^n with x as fixed-point and n as regular unsigned.
223         //
224         // It's O(log n), instead of O(n) for naive repeated multiplication.
225         //
226         // These facts are why it works:
227         //
228         //  If n is even, then x^n = (x^2)^(n/2).
229         //  If n is odd,  then x^n = x * x^(n-1),
230         //   and applying the equation for even x gives
231         //    x^n = x * (x^2)^((n-1) / 2).
232         //
233         //  Also, EVM division is flooring and
234         //    floor[(n-1) / 2] = floor[n / 2].
235 
236         z = n % 2 != 0 ? x : RAY;
237 
238         for (n /= 2; n != 0; n /= 2) {
239             x = rmul(x, x);
240 
241             if (n % 2 != 0) {
242                 z = rmul(z, x);
243             }
244         }
245     }
246 
247     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
248         return hmin(x, y);
249     }
250     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
251         return hmax(x, y);
252     }
253 
254     function cast(uint256 x) constant internal returns (uint128 z) {
255         assert((z = uint128(x)) == x);
256     }
257 
258 }
259 
260 contract DSThing is DSAuth, DSNote, DSMath {
261 }
262 
263 contract DSValue is DSThing {
264     bool    has;
265     bytes32 val;
266     function peek() constant returns (bytes32, bool) {
267         return (val,has);
268     }
269     function read() constant returns (bytes32) {
270         var (wut, has) = peek();
271         assert(has);
272         return wut;
273     }
274     function poke(bytes32 wut) note auth {
275         val = wut;
276         has = true;
277     }
278     function void() note auth { // unset the value
279         has = false;
280     }
281 }
282 
283 contract Medianizer is DSValue {
284     mapping (bytes12 => address) public values;
285     mapping (address => bytes12) public indexes;
286     bytes12 public next = 0x1;
287 
288     uint96 public min = 0x1;
289 
290     function set(address wat) auth {
291         bytes12 nextId = bytes12(uint96(next) + 1);
292         assert(nextId != 0x0);
293         set(next, wat);
294         next = nextId;
295     }
296 
297     function set(bytes12 pos, address wat) note auth {
298         if (pos == 0x0) throw;
299 
300         if (wat != 0 && indexes[wat] != 0) throw;
301 
302         indexes[values[pos]] = 0; // Making sure to remove a possible existing address in that position
303 
304         if (wat != 0) {
305             indexes[wat] = pos;
306         }
307 
308         values[pos] = wat;
309     }
310 
311     function setMin(uint96 min_) note auth {
312         if (min_ == 0x0) throw;
313         min = min_;
314     }
315 
316     function setNext(bytes12 next_) note auth {
317         if (next_ == 0x0) throw;
318         next = next_;
319     }
320 
321     function unset(bytes12 pos) {
322         set(pos, 0);
323     }
324 
325     function unset(address wat) {
326         set(indexes[wat], 0);
327     }
328 
329     function poke() {
330         poke(0);
331     }
332 
333     function poke(bytes32) note {
334         (val, has) = compute();
335     }
336 
337     function compute() constant returns (bytes32, bool) {
338         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
339         uint96 ctr = 0;
340         for (uint96 i = 1; i < uint96(next); i++) {
341             if (values[bytes12(i)] != 0) {
342                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
343                 if (wuz) {
344                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
345                         wuts[ctr] = wut;
346                     } else {
347                         uint96 j = 0;
348                         while (wut >= wuts[j]) {
349                             j++;
350                         }
351                         for (uint96 k = ctr; k > j; k--) {
352                             wuts[k] = wuts[k - 1];
353                         }
354                         wuts[j] = wut;
355                     }
356                     ctr++;
357                 }
358             }
359         }
360 
361         if (ctr < min) return (val, false);
362 
363         bytes32 value;
364         if (ctr % 2 == 0) {
365             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
366             uint128 val2 = uint128(wuts[ctr / 2]);
367             value = bytes32(wdiv(hadd(val1, val2), 2 ether));
368         } else {
369             value = wuts[(ctr - 1) / 2];
370         }
371 
372         return (value, true);
373     }
374 
375 }