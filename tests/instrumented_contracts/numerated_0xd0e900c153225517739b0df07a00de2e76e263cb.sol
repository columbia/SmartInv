1 /// price feed, with expiration and medianizer poke
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
12 pragma solidity ^0.4.15;
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
53     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
54         if (src == address(this)) {
55             return true;
56         } else if (src == owner) {
57             return true;
58         } else if (authority == DSAuthority(0)) {
59             return false;
60         } else {
61             return authority.canCall(src, this, sig);
62         }
63     }
64 }
65 
66 contract DSNote {
67     event LogNote(
68         bytes4   indexed  sig,
69         address  indexed  guy,
70         bytes32  indexed  foo,
71         bytes32  indexed  bar,
72         uint              wad,
73         bytes             fax
74     ) anonymous;
75 
76     modifier note {
77         bytes32 foo;
78         bytes32 bar;
79 
80         assembly {
81             foo := calldataload(4)
82             bar := calldataload(36)
83         }
84 
85         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
86 
87         _;
88     }
89 }
90 
91 contract DSMath {
92     
93     /*
94     standard uint256 functions
95      */
96 
97     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
98         assert((z = x + y) >= x);
99     }
100 
101     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
102         assert((z = x - y) <= x);
103     }
104 
105     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
106         z = x * y;
107         assert(x == 0 || z / x == y);
108     }
109 
110     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
111         z = x / y;
112     }
113 
114     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
115         return x <= y ? x : y;
116     }
117     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
118         return x >= y ? x : y;
119     }
120 
121     /*
122     uint128 functions (h is for half)
123      */
124 
125 
126     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
127         assert((z = x + y) >= x);
128     }
129 
130     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
131         assert((z = x - y) <= x);
132     }
133 
134     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         z = x * y;
136         assert(x == 0 || z / x == y);
137     }
138 
139     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
140         z = x / y;
141     }
142 
143     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
144         return x <= y ? x : y;
145     }
146     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
147         return x >= y ? x : y;
148     }
149 
150 
151     /*
152     int256 functions
153      */
154 
155     function imin(int256 x, int256 y) constant internal returns (int256 z) {
156         return x <= y ? x : y;
157     }
158     function imax(int256 x, int256 y) constant internal returns (int256 z) {
159         return x >= y ? x : y;
160     }
161 
162     /*
163     WAD math
164      */
165 
166     uint128 constant WAD = 10 ** 18;
167 
168     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
169         return hadd(x, y);
170     }
171 
172     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
173         return hsub(x, y);
174     }
175 
176     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
177         z = cast((uint256(x) * y + WAD / 2) / WAD);
178     }
179 
180     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         z = cast((uint256(x) * WAD + y / 2) / y);
182     }
183 
184     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
185         return hmin(x, y);
186     }
187     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
188         return hmax(x, y);
189     }
190 
191     /*
192     RAY math
193      */
194 
195     uint128 constant RAY = 10 ** 27;
196 
197     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
198         return hadd(x, y);
199     }
200 
201     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
202         return hsub(x, y);
203     }
204 
205     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
206         z = cast((uint256(x) * y + RAY / 2) / RAY);
207     }
208 
209     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
210         z = cast((uint256(x) * RAY + y / 2) / y);
211     }
212 
213     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
214         // This famous algorithm is called "exponentiation by squaring"
215         // and calculates x^n with x as fixed-point and n as regular unsigned.
216         //
217         // It's O(log n), instead of O(n) for naive repeated multiplication.
218         //
219         // These facts are why it works:
220         //
221         //  If n is even, then x^n = (x^2)^(n/2).
222         //  If n is odd,  then x^n = x * x^(n-1),
223         //   and applying the equation for even x gives
224         //    x^n = x * (x^2)^((n-1) / 2).
225         //
226         //  Also, EVM division is flooring and
227         //    floor[(n-1) / 2] = floor[n / 2].
228 
229         z = n % 2 != 0 ? x : RAY;
230 
231         for (n /= 2; n != 0; n /= 2) {
232             x = rmul(x, x);
233 
234             if (n % 2 != 0) {
235                 z = rmul(z, x);
236             }
237         }
238     }
239 
240     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
241         return hmin(x, y);
242     }
243     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
244         return hmax(x, y);
245     }
246 
247     function cast(uint256 x) constant internal returns (uint128 z) {
248         assert((z = uint128(x)) == x);
249     }
250 
251 }
252 
253 contract DSThing is DSAuth, DSNote, DSMath {
254 }
255 
256 contract DSPrice is DSThing {
257 
258     uint128 public val;
259     uint32 public zzz;
260 
261     function peek()
262         constant
263         returns (bytes32,bool)
264     {
265         return (bytes32(val), now < zzz);
266     }
267 
268     function read()
269         constant
270         returns (bytes32)
271     {
272         assert(now < zzz);
273         return bytes32(val);
274     }
275 
276     function post(uint128 val_, uint32 zzz_, address med_)
277         note
278         auth
279     {
280         val = val_;
281         zzz = zzz_;
282         med_.call(bytes4(sha3("poke()")));
283     }
284 
285     function void()
286         note
287         auth
288     {
289         zzz = 0;
290     }
291 
292 }