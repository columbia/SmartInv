1 // hevm: flattened sources of src/price-feed.sol
2 pragma solidity ^0.4.23;
3 
4 ////// lib/ds-thing/lib/ds-auth/src/auth.sol
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
18 /* pragma solidity ^0.4.23; */
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
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(authority);
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
74 ////// lib/ds-thing/lib/ds-math/src/math.sol
75 /// math.sol -- mixin for inline numerical wizardry
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
92 contract DSMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x);
95     }
96     function sub(uint x, uint y) internal pure returns (uint z) {
97         require((z = x - y) <= x);
98     }
99     function mul(uint x, uint y) internal pure returns (uint z) {
100         require(y == 0 || (z = x * y) / y == x);
101     }
102 
103     function min(uint x, uint y) internal pure returns (uint z) {
104         return x <= y ? x : y;
105     }
106     function max(uint x, uint y) internal pure returns (uint z) {
107         return x >= y ? x : y;
108     }
109     function imin(int x, int y) internal pure returns (int z) {
110         return x <= y ? x : y;
111     }
112     function imax(int x, int y) internal pure returns (int z) {
113         return x >= y ? x : y;
114     }
115 
116     uint constant WAD = 10 ** 18;
117     uint constant RAY = 10 ** 27;
118 
119     function wmul(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, y), WAD / 2) / WAD;
121     }
122     function rmul(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, y), RAY / 2) / RAY;
124     }
125     function wdiv(uint x, uint y) internal pure returns (uint z) {
126         z = add(mul(x, WAD), y / 2) / y;
127     }
128     function rdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, RAY), y / 2) / y;
130     }
131 
132     // This famous algorithm is called "exponentiation by squaring"
133     // and calculates x^n with x as fixed-point and n as regular unsigned.
134     //
135     // It's O(log n), instead of O(n) for naive repeated multiplication.
136     //
137     // These facts are why it works:
138     //
139     //  If n is even, then x^n = (x^2)^(n/2).
140     //  If n is odd,  then x^n = x * x^(n-1),
141     //   and applying the equation for even x gives
142     //    x^n = x * (x^2)^((n-1) / 2).
143     //
144     //  Also, EVM division is flooring and
145     //    floor[(n-1) / 2] = floor[n / 2].
146     //
147     function rpow(uint x, uint n) internal pure returns (uint z) {
148         z = n % 2 != 0 ? x : RAY;
149 
150         for (n /= 2; n != 0; n /= 2) {
151             x = rmul(x, x);
152 
153             if (n % 2 != 0) {
154                 z = rmul(z, x);
155             }
156         }
157     }
158 }
159 
160 ////// lib/ds-thing/lib/ds-note/src/note.sol
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
221 /* pragma solidity ^0.4.23; */
222 
223 /* import 'ds-auth/auth.sol'; */
224 /* import 'ds-note/note.sol'; */
225 /* import 'ds-math/math.sol'; */
226 
227 contract DSThing is DSAuth, DSNote, DSMath {
228 
229     function S(string s) internal pure returns (bytes4) {
230         return bytes4(keccak256(abi.encodePacked(s)));
231     }
232 
233 }
234 
235 ////// src/price-feed.sol
236 /// price-feed.sol - ds-value like that also pokes a medianizer
237 
238 // Copyright (C) 2017, 2018  DappHub, LLC
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
253 /* pragma solidity ^0.4.23; */
254 
255 /* import "ds-thing/thing.sol"; */
256 
257 interface Medianizer {
258     function poke() external;
259 }
260 
261 contract PriceFeed is DSThing {
262 
263     uint128       val;
264     uint32 public zzz;
265 
266     function peek() external view returns (bytes32,bool)
267     {
268         return (bytes32(val), now < zzz);
269     }
270 
271     function read() external view returns (bytes32)
272     {
273         require(now < zzz);
274         return bytes32(val);
275     }
276 
277     function poke(uint128 val_, uint32 zzz_) external note auth
278     {
279         val = val_;
280         zzz = zzz_;
281     }
282 
283     function post(uint128 val_, uint32 zzz_, Medianizer med_) external note auth
284     {
285         val = val_;
286         zzz = zzz_;
287         med_.poke();
288     }
289 
290     function void() external note auth
291     {
292         zzz = 0;
293     }
294 
295 }