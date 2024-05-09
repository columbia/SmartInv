1 // hevm: flattened sources of src/vox.sol
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
235 ////// src/vox.sol
236 /// vox.sol -- target price feed
237 
238 // Copyright (C) 2016, 2017  Nikolai Mushegian <nikolai@dapphub.com>
239 // Copyright (C) 2016, 2017  Daniel Brockman <daniel@dapphub.com>
240 // Copyright (C) 2017        Rain Break <rainbreak@riseup.net>
241 
242 // This program is free software: you can redistribute it and/or modify
243 // it under the terms of the GNU General Public License as published by
244 // the Free Software Foundation, either version 3 of the License, or
245 // (at your option) any later version.
246 
247 // This program is distributed in the hope that it will be useful,
248 // but WITHOUT ANY WARRANTY; without even the implied warranty of
249 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
250 // GNU General Public License for more details.
251 
252 // You should have received a copy of the GNU General Public License
253 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
254 
255 /* pragma solidity ^0.4.18; */
256 
257 /* import "ds-thing/thing.sol"; */
258 
259 contract SaiVox is DSThing {
260     uint256  _par;
261     uint256  _way;
262 
263     uint256  public  fix;
264     uint256  public  how;
265     uint256  public  tau;
266 
267     function SaiVox(uint par_) public {
268         _par = fix = par_;
269         _way = RAY;
270         tau  = era();
271     }
272 
273     function era() public view returns (uint) {
274         return block.timestamp;
275     }
276 
277     function mold(bytes32 param, uint val) public note auth {
278         if (param == 'way') _way = val;
279     }
280 
281     // Dai Target Price (ref per dai)
282     function par() public returns (uint) {
283         prod();
284         return _par;
285     }
286     function way() public returns (uint) {
287         prod();
288         return _way;
289     }
290 
291     function tell(uint256 ray) public note auth {
292         fix = ray;
293     }
294     function tune(uint256 ray) public note auth {
295         how = ray;
296     }
297 
298     function prod() public note {
299         var age = era() - tau;
300         if (age == 0) return;  // optimised
301         tau = era();
302 
303         if (_way != RAY) _par = rmul(_par, rpow(_way, age));  // optimised
304 
305         if (how == 0) return;  // optimised
306         var wag = int128(how * age);
307         _way = inj(prj(_way) + (fix < _par ? wag : -wag));
308     }
309 
310     function inj(int128 x) internal pure returns (uint256) {
311         return x >= 0 ? uint256(x) + RAY
312             : rdiv(RAY, RAY + uint256(-x));
313     }
314     function prj(uint256 x) internal pure returns (int128) {
315         return x >= RAY ? int128(x - RAY)
316             : int128(RAY) - int128(rdiv(RAY, x));
317     }
318 }