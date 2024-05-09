1 pragma solidity ^0.4.21;
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 contract DSMath {
17     function add(uint x, uint y) internal pure returns (uint z) {
18         require((z = x + y) >= x);
19     }
20     function sub(uint x, uint y) internal pure returns (uint z) {
21         require((z = x - y) <= x);
22     }
23     function mul(uint x, uint y) internal pure returns (uint z) {
24         require(y == 0 || (z = x * y) / y == x);
25     }
26 
27     function min(uint x, uint y) internal pure returns (uint z) {
28         return x <= y ? x : y;
29     }
30     function max(uint x, uint y) internal pure returns (uint z) {
31         return x >= y ? x : y;
32     }
33     function imin(int x, int y) internal pure returns (int z) {
34         return x <= y ? x : y;
35     }
36     function imax(int x, int y) internal pure returns (int z) {
37         return x >= y ? x : y;
38     }
39 
40     uint constant WAD = 10 ** 18;
41     uint constant RAY = 10 ** 27;
42 
43     function wmul(uint x, uint y) internal pure returns (uint z) {
44         z = add(mul(x, y), WAD / 2) / WAD;
45     }
46     function rmul(uint x, uint y) internal pure returns (uint z) {
47         z = add(mul(x, y), RAY / 2) / RAY;
48     }
49     function wdiv(uint x, uint y) internal pure returns (uint z) {
50         z = add(mul(x, WAD), y / 2) / y;
51     }
52     function rdiv(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, RAY), y / 2) / y;
54     }
55 
56     // This famous algorithm is called "exponentiation by squaring"
57     // and calculates x^n with x as fixed-point and n as regular unsigned.
58     //
59     // It's O(log n), instead of O(n) for naive repeated multiplication.
60     //
61     // These facts are why it works:
62     //
63     //  If n is even, then x^n = (x^2)^(n/2).
64     //  If n is odd,  then x^n = x * x^(n-1),
65     //   and applying the equation for even x gives
66     //    x^n = x * (x^2)^((n-1) / 2).
67     //
68     //  Also, EVM division is flooring and
69     //    floor[(n-1) / 2] = floor[n / 2].
70     //
71     function rpow(uint x, uint n) internal pure returns (uint z) {
72         z = n % 2 != 0 ? x : RAY;
73 
74         for (n /= 2; n != 0; n /= 2) {
75             x = rmul(x, x);
76 
77             if (n % 2 != 0) {
78                 z = rmul(z, x);
79             }
80         }
81     }
82 }
83 
84 // This program is free software: you can redistribute it and/or modify
85 // it under the terms of the GNU General Public License as published by
86 // the Free Software Foundation, either version 3 of the License, or
87 // (at your option) any later version.
88 
89 // This program is distributed in the hope that it will be useful,
90 // but WITHOUT ANY WARRANTY; without even the implied warranty of
91 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
92 // GNU General Public License for more details.
93 
94 // You should have received a copy of the GNU General Public License
95 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
96 
97 contract DSAuthority {
98     function canCall(
99         address src, address dst, bytes4 sig
100     ) public view returns (bool);
101 }
102 
103 contract DSAuthEvents {
104     event LogSetAuthority (address indexed authority);
105     event LogSetOwner     (address indexed owner);
106 }
107 
108 contract DSAuth is DSAuthEvents {
109     DSAuthority  public  authority;
110     address      public  owner;
111 
112     function DSAuth() public {
113         owner = msg.sender;
114         LogSetOwner(msg.sender);
115     }
116 
117     function setOwner(address owner_)
118         public
119         auth
120     {
121         owner = owner_;
122         LogSetOwner(owner);
123     }
124 
125     function setAuthority(DSAuthority authority_)
126         public
127         auth
128     {
129         authority = authority_;
130         LogSetAuthority(authority);
131     }
132 
133     modifier auth {
134         require(isAuthorized(msg.sender, msg.sig));
135         _;
136     }
137 
138     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
139         if (src == address(this)) {
140             return true;
141         } else if (src == owner) {
142             return true;
143         } else if (authority == DSAuthority(0)) {
144             return false;
145         } else {
146             return authority.canCall(src, this, sig);
147         }
148     }
149 }
150 
151 // This program is free software: you can redistribute it and/or modify
152 // it under the terms of the GNU General Public License as published by
153 // the Free Software Foundation, either version 3 of the License, or
154 // (at your option) any later version.
155 
156 // This program is distributed in the hope that it will be useful,
157 // but WITHOUT ANY WARRANTY; without even the implied warranty of
158 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
159 // GNU General Public License for more details.
160 
161 // You should have received a copy of the GNU General Public License
162 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
163 
164 contract DSNote {
165     event LogNote(
166         bytes4   indexed  sig,
167         address  indexed  guy,
168         bytes32  indexed  foo,
169         bytes32  indexed  bar,
170         uint              wad,
171         bytes             fax
172     ) anonymous;
173 
174     modifier note {
175         bytes32 foo;
176         bytes32 bar;
177 
178         assembly {
179             foo := calldataload(4)
180             bar := calldataload(36)
181         }
182 
183         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
184 
185         _;
186     }
187 }
188 
189 // Copyright (C) 2017  DappHub, LLC
190 
191 // This program is free software: you can redistribute it and/or modify
192 // it under the terms of the GNU General Public License as published by
193 // the Free Software Foundation, either version 3 of the License, or
194 // (at your option) any later version.
195 
196 // This program is distributed in the hope that it will be useful,
197 // but WITHOUT ANY WARRANTY; without even the implied warranty of
198 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
199 // GNU General Public License for more details.
200 
201 // You should have received a copy of the GNU General Public License
202 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
203 
204 contract DSStop is DSNote, DSAuth {
205 
206     bool public stopped;
207 
208     modifier stoppable {
209         require(!stopped);
210         _;
211     }
212     function stop() public auth note {
213         stopped = true;
214     }
215     function start() public auth note {
216         stopped = false;
217     }
218 
219 }
220 
221 // See <https://github.com/ethereum/EIPs/issues/20>.
222 
223 // This file likely does not meet the threshold of originality
224 // required for copyright to apply.  As a result, this is free and
225 // unencumbered software belonging to the public domain.
226 
227 contract ERC20Events {
228     event Approval(address indexed src, address indexed guy, uint wad);
229     event Transfer(address indexed src, address indexed dst, uint wad);
230 }
231 
232 contract ERC20 is ERC20Events {
233     function totalSupply() public view returns (uint);
234     function balanceOf(address guy) public view returns (uint);
235     function allowance(address src, address guy) public view returns (uint);
236 
237     function approve(address guy, uint wad) public returns (bool);
238     function transfer(address dst, uint wad) public returns (bool);
239     function transferFrom(
240         address src, address dst, uint wad
241     ) public returns (bool);
242 }
243 
244 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
245 
246 // This program is free software: you can redistribute it and/or modify
247 // it under the terms of the GNU General Public License as published by
248 // the Free Software Foundation, either version 3 of the License, or
249 // (at your option) any later version.
250 
251 // This program is distributed in the hope that it will be useful,
252 // but WITHOUT ANY WARRANTY; without even the implied warranty of
253 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
254 // GNU General Public License for more details.
255 
256 // You should have received a copy of the GNU General Public License
257 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
258 
259 contract DSTokenBase is ERC20, DSMath {
260     uint256                                            _supply;
261     mapping (address => uint256)                       _balances;
262     mapping (address => mapping (address => uint256))  _approvals;
263 
264     function DSTokenBase(uint supply) public {
265         _balances[msg.sender] = supply;
266         _supply = supply;
267     }
268 
269     function totalSupply() public view returns (uint) {
270         return _supply;
271     }
272     function balanceOf(address src) public view returns (uint) {
273         return _balances[src];
274     }
275     function allowance(address src, address guy) public view returns (uint) {
276         return _approvals[src][guy];
277     }
278 
279     function transfer(address dst, uint wad) public returns (bool) {
280         return transferFrom(msg.sender, dst, wad);
281     }
282 
283     function transferFrom(address src, address dst, uint wad)
284         public
285         returns (bool)
286     {
287         if (src != msg.sender) {
288             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
289         }
290 
291         _balances[src] = sub(_balances[src], wad);
292         _balances[dst] = add(_balances[dst], wad);
293 
294         Transfer(src, dst, wad);
295 
296         return true;
297     }
298 
299     function approve(address guy, uint wad) public returns (bool) {
300         _approvals[msg.sender][guy] = wad;
301 
302         Approval(msg.sender, guy, wad);
303 
304         return true;
305     }
306 }
307 
308 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
309 
310 // This program is free software: you can redistribute it and/or modify
311 // it under the terms of the GNU General Public License as published by
312 // the Free Software Foundation, either version 3 of the License, or
313 // (at your option) any later version.
314 
315 // This program is distributed in the hope that it will be useful,
316 // but WITHOUT ANY WARRANTY; without even the implied warranty of
317 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
318 // GNU General Public License for more details.
319 
320 // You should have received a copy of the GNU General Public License
321 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
322 
323 contract DSToken is DSTokenBase(0), DSStop {
324 
325     bytes32  public  symbol;
326     uint256  public  decimals = 18; // standard token precision. override to customize
327 
328     function DSToken(bytes32 symbol_) public {
329         symbol = symbol_;
330     }
331 
332     event Mint(address indexed guy, uint wad);
333     event Burn(address indexed guy, uint wad);
334 
335     function approve(address guy) public stoppable returns (bool) {
336         return super.approve(guy, uint(-1));
337     }
338 
339     function approve(address guy, uint wad) public stoppable returns (bool) {
340         return super.approve(guy, wad);
341     }
342 
343     function transferFrom(address src, address dst, uint wad)
344         public
345         stoppable
346         returns (bool)
347     {
348         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
349             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
350         }
351 
352         _balances[src] = sub(_balances[src], wad);
353         _balances[dst] = add(_balances[dst], wad);
354 
355         Transfer(src, dst, wad);
356 
357         return true;
358     }
359 
360     function push(address dst, uint wad) public {
361         transferFrom(msg.sender, dst, wad);
362     }
363     function pull(address src, uint wad) public {
364         transferFrom(src, msg.sender, wad);
365     }
366     function move(address src, address dst, uint wad) public {
367         transferFrom(src, dst, wad);
368     }
369 
370     function mint(uint wad) public {
371         mint(msg.sender, wad);
372     }
373     function burn(uint wad) public {
374         burn(msg.sender, wad);
375     }
376     function mint(address guy, uint wad) public auth stoppable {
377         _balances[guy] = add(_balances[guy], wad);
378         _supply = add(_supply, wad);
379         Mint(guy, wad);
380     }
381     function burn(address guy, uint wad) public auth stoppable {
382         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
383             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
384         }
385 
386         _balances[guy] = sub(_balances[guy], wad);
387         _supply = sub(_supply, wad);
388         Burn(guy, wad);
389     }
390 
391     // Optional token name
392     bytes32   public  name = "";
393 
394     function setName(bytes32 name_) public auth {
395         name = name_;
396     }
397 }