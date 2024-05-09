1 pragma solidity ^0.4.11;
2 
3 /// poker.sol -- ds-cache with medianizer poke
4 
5 // Copyright (C) 2017  DappHub, LLC
6 
7 // Licensed under the Apache License, Version 2.0 (the "License").
8 // You may not use this file except in compliance with the License.
9 
10 // Unless required by applicable law or agreed to in writing, software
11 // distributed under the License is distributed on an "AS IS" BASIS,
12 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
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
75 
76 contract DSNote {
77     event LogNote(
78         bytes4   indexed  sig,
79         address  indexed  guy,
80         bytes32  indexed  foo,
81         bytes32  indexed  bar,
82 	uint	 	  wad,
83         bytes             fax
84     ) anonymous;
85 
86     modifier note {
87         bytes32 foo;
88         bytes32 bar;
89 
90         assembly {
91             foo := calldataload(4)
92             bar := calldataload(36)
93         }
94 
95         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
96 
97         _;
98     }
99 }
100 
101 contract DSMath {
102     
103     /*
104     standard uint256 functions
105      */
106 
107     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
108         assert((z = x + y) >= x);
109     }
110 
111     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
112         assert((z = x - y) <= x);
113     }
114 
115     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
116         z = x * y;
117         assert(x == 0 || z / x == y);
118     }
119 
120     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
121         z = x / y;
122     }
123 
124     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
125         return x <= y ? x : y;
126     }
127     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
128         return x >= y ? x : y;
129     }
130 
131     /*
132     uint128 functions (h is for half)
133      */
134 
135 
136     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
137         assert((z = x + y) >= x);
138     }
139 
140     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
141         assert((z = x - y) <= x);
142     }
143 
144     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
145         z = x * y;
146         assert(x == 0 || z / x == y);
147     }
148 
149     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
150         z = x / y;
151     }
152 
153     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
154         return x <= y ? x : y;
155     }
156     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
157         return x >= y ? x : y;
158     }
159 
160 
161     /*
162     int256 functions
163      */
164 
165     function imin(int256 x, int256 y) constant internal returns (int256 z) {
166         return x <= y ? x : y;
167     }
168     function imax(int256 x, int256 y) constant internal returns (int256 z) {
169         return x >= y ? x : y;
170     }
171 
172     /*
173     WAD math
174      */
175 
176     uint128 constant WAD = 10 ** 18;
177 
178     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
179         return hadd(x, y);
180     }
181 
182     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
183         return hsub(x, y);
184     }
185 
186     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
187         z = cast((uint256(x) * y + WAD / 2) / WAD);
188     }
189 
190     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
191         z = cast((uint256(x) * WAD + y / 2) / y);
192     }
193 
194     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
195         return hmin(x, y);
196     }
197     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
198         return hmax(x, y);
199     }
200 
201     /*
202     RAY math
203      */
204 
205     uint128 constant RAY = 10 ** 27;
206 
207     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
208         return hadd(x, y);
209     }
210 
211     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
212         return hsub(x, y);
213     }
214 
215     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
216         z = cast((uint256(x) * y + RAY / 2) / RAY);
217     }
218 
219     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
220         z = cast((uint256(x) * RAY + y / 2) / y);
221     }
222 
223     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
224         // This famous algorithm is called "exponentiation by squaring"
225         // and calculates x^n with x as fixed-point and n as regular unsigned.
226         //
227         // It's O(log n), instead of O(n) for naive repeated multiplication.
228         //
229         // These facts are why it works:
230         //
231         //  If n is even, then x^n = (x^2)^(n/2).
232         //  If n is odd,  then x^n = x * x^(n-1),
233         //   and applying the equation for even x gives
234         //    x^n = x * (x^2)^((n-1) / 2).
235         //
236         //  Also, EVM division is flooring and
237         //    floor[(n-1) / 2] = floor[n / 2].
238 
239         z = n % 2 != 0 ? x : RAY;
240 
241         for (n /= 2; n != 0; n /= 2) {
242             x = rmul(x, x);
243 
244             if (n % 2 != 0) {
245                 z = rmul(z, x);
246             }
247         }
248     }
249 
250     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
251         return hmin(x, y);
252     }
253     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
254         return hmax(x, y);
255     }
256 
257     function cast(uint256 x) constant internal returns (uint128 z) {
258         assert((z = uint128(x)) == x);
259     }
260 
261 }
262 
263 contract DSThing is DSAuth, DSNote, DSMath {
264 }
265 
266 contract DSValue is DSThing {
267     bool    has;
268     bytes32 val;
269     function peek() constant returns (bytes32, bool) {
270         return (val,has);
271     }
272     function read() constant returns (bytes32) {
273         var (wut, has) = peek();
274         assert(has);
275         return wut;
276     }
277     function poke(bytes32 wut) note auth {
278         val = wut;
279         has = true;
280     }
281     function void() note auth { // unset the value
282         has = false;
283     }
284 }
285 
286 contract DSCache is DSValue
287 {
288     uint128 public zzz;
289 //  from DSValue:
290 //  bool    has;
291 //  bytes32 val;
292     function peek() constant returns (bytes32, bool) {
293         return (val, has && now < zzz);
294     }
295     function read() constant returns (bytes32) {
296         var (wut, has) = peek();
297         assert(now < zzz);
298         assert(has);
299         return wut;
300     }
301     function prod(bytes32 wut, uint128 Zzz) note auth {
302         zzz = Zzz;
303         poke(wut);
304     }
305     // from DSValue:
306     // function poke(bytes32 wut) note auth {
307     //     val = wut;
308     //     has = true;
309     // }
310     // function void() note auth { // unset the value
311     //     has = false;
312     // }
313 
314 }
315 
316 contract Poker is DSCache {
317 
318     function poke(address med, bytes32 wut) auth {
319         super.poke(wut);
320         assert(med.call(bytes4(sha3("poke()"))));
321         //Medianizer(med).poke();
322     }
323 
324     function prod(address med, bytes32 wut, uint128 zzz) auth {
325         super.prod(wut, zzz);
326         assert(med.call(bytes4(sha3("poke()"))));
327         //Medianizer(med).poke();
328     }
329 }