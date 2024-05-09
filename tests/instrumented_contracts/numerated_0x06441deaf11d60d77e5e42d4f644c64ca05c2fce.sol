1 pragma solidity ^0.4.23;
2 pragma experimental "v0.5.0";
3 /*
4   This file is part of The Colony Network.
5 
6   The Colony Network is free software: you can redistribute it and/or modify
7   it under the terms of the GNU General Public License as published by
8   the Free Software Foundation, either version 3 of the License, or
9   (at your option) any later version.
10 
11   The Colony Network is distributed in the hope that it will be useful,
12   but WITHOUT ANY WARRANTY; without even the implied warranty of
13   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14   GNU General Public License for more details.
15 
16   You should have received a copy of the GNU General Public License
17   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
18 */
19 
20 
21 
22 
23 
24 // This program is free software: you can redistribute it and/or modify
25 // it under the terms of the GNU General Public License as published by
26 // the Free Software Foundation, either version 3 of the License, or
27 // (at your option) any later version.
28 
29 // This program is distributed in the hope that it will be useful,
30 // but WITHOUT ANY WARRANTY; without even the implied warranty of
31 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
32 // GNU General Public License for more details.
33 
34 // You should have received a copy of the GNU General Public License
35 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
36 
37 
38 
39 contract DSAuthority {
40     function canCall(
41         address src, address dst, bytes4 sig
42     ) public view returns (bool);
43 }
44 
45 contract DSAuthEvents {
46     event LogSetAuthority (address indexed authority);
47     event LogSetOwner     (address indexed owner);
48 }
49 
50 contract DSAuth is DSAuthEvents {
51     DSAuthority  public  authority;
52     address      public  owner;
53 
54     constructor() public {
55         owner = msg.sender;
56         emit LogSetOwner(msg.sender);
57     }
58 
59     function setOwner(address owner_)
60         public
61         auth
62     {
63         owner = owner_;
64         emit LogSetOwner(owner);
65     }
66 
67     function setAuthority(DSAuthority authority_)
68         public
69         auth
70     {
71         authority = authority_;
72         emit LogSetAuthority(authority);
73     }
74 
75     modifier auth {
76         require(isAuthorized(msg.sender, msg.sig));
77         _;
78     }
79 
80     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
81         if (src == address(this)) {
82             return true;
83         } else if (src == owner) {
84             return true;
85         } else if (authority == DSAuthority(0)) {
86             return false;
87         } else {
88             return authority.canCall(src, this, sig);
89         }
90     }
91 }
92 /// base.sol -- basic ERC20 implementation
93 
94 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
95 
96 // This program is free software: you can redistribute it and/or modify
97 // it under the terms of the GNU General Public License as published by
98 // the Free Software Foundation, either version 3 of the License, or
99 // (at your option) any later version.
100 
101 // This program is distributed in the hope that it will be useful,
102 // but WITHOUT ANY WARRANTY; without even the implied warranty of
103 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
104 // GNU General Public License for more details.
105 
106 // You should have received a copy of the GNU General Public License
107 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
108 
109 
110 
111 /// erc20.sol -- API for the ERC20 token standard
112 
113 // See <https://github.com/ethereum/EIPs/issues/20>.
114 
115 // This file likely does not meet the threshold of originality
116 // required for copyright to apply.  As a result, this is free and
117 // unencumbered software belonging to the public domain.
118 
119 
120 
121 contract ERC20Events {
122     event Approval(address indexed src, address indexed guy, uint wad);
123     event Transfer(address indexed src, address indexed dst, uint wad);
124 }
125 
126 contract ERC20 is ERC20Events {
127     function totalSupply() public view returns (uint);
128     function balanceOf(address guy) public view returns (uint);
129     function allowance(address src, address guy) public view returns (uint);
130 
131     function approve(address guy, uint wad) public returns (bool);
132     function transfer(address dst, uint wad) public returns (bool);
133     function transferFrom(
134         address src, address dst, uint wad
135     ) public returns (bool);
136 }
137 /// math.sol -- mixin for inline numerical wizardry
138 
139 // This program is free software: you can redistribute it and/or modify
140 // it under the terms of the GNU General Public License as published by
141 // the Free Software Foundation, either version 3 of the License, or
142 // (at your option) any later version.
143 
144 // This program is distributed in the hope that it will be useful,
145 // but WITHOUT ANY WARRANTY; without even the implied warranty of
146 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
147 // GNU General Public License for more details.
148 
149 // You should have received a copy of the GNU General Public License
150 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
151 
152 
153 
154 contract DSMath {
155     function add(uint x, uint y) internal pure returns (uint z) {
156         require((z = x + y) >= x);
157     }
158     function sub(uint x, uint y) internal pure returns (uint z) {
159         require((z = x - y) <= x);
160     }
161     function mul(uint x, uint y) internal pure returns (uint z) {
162         require(y == 0 || (z = x * y) / y == x);
163     }
164 
165     function min(uint x, uint y) internal pure returns (uint z) {
166         return x <= y ? x : y;
167     }
168     function max(uint x, uint y) internal pure returns (uint z) {
169         return x >= y ? x : y;
170     }
171     function imin(int x, int y) internal pure returns (int z) {
172         return x <= y ? x : y;
173     }
174     function imax(int x, int y) internal pure returns (int z) {
175         return x >= y ? x : y;
176     }
177 
178     uint constant WAD = 10 ** 18;
179     uint constant RAY = 10 ** 27;
180 
181     function wmul(uint x, uint y) internal pure returns (uint z) {
182         z = add(mul(x, y), WAD / 2) / WAD;
183     }
184     function rmul(uint x, uint y) internal pure returns (uint z) {
185         z = add(mul(x, y), RAY / 2) / RAY;
186     }
187     function wdiv(uint x, uint y) internal pure returns (uint z) {
188         z = add(mul(x, WAD), y / 2) / y;
189     }
190     function rdiv(uint x, uint y) internal pure returns (uint z) {
191         z = add(mul(x, RAY), y / 2) / y;
192     }
193 
194     // This famous algorithm is called "exponentiation by squaring"
195     // and calculates x^n with x as fixed-point and n as regular unsigned.
196     //
197     // It's O(log n), instead of O(n) for naive repeated multiplication.
198     //
199     // These facts are why it works:
200     //
201     //  If n is even, then x^n = (x^2)^(n/2).
202     //  If n is odd,  then x^n = x * x^(n-1),
203     //   and applying the equation for even x gives
204     //    x^n = x * (x^2)^((n-1) / 2).
205     //
206     //  Also, EVM division is flooring and
207     //    floor[(n-1) / 2] = floor[n / 2].
208     //
209     function rpow(uint x, uint n) internal pure returns (uint z) {
210         z = n % 2 != 0 ? x : RAY;
211 
212         for (n /= 2; n != 0; n /= 2) {
213             x = rmul(x, x);
214 
215             if (n % 2 != 0) {
216                 z = rmul(z, x);
217             }
218         }
219     }
220 }
221 
222 contract DSTokenBase is ERC20, DSMath {
223     uint256                                            _supply;
224     mapping (address => uint256)                       _balances;
225     mapping (address => mapping (address => uint256))  _approvals;
226 
227     constructor(uint supply) public {
228         _balances[msg.sender] = supply;
229         _supply = supply;
230     }
231 
232     function totalSupply() public view returns (uint) {
233         return _supply;
234     }
235     function balanceOf(address src) public view returns (uint) {
236         return _balances[src];
237     }
238     function allowance(address src, address guy) public view returns (uint) {
239         return _approvals[src][guy];
240     }
241 
242     function transfer(address dst, uint wad) public returns (bool) {
243         return transferFrom(msg.sender, dst, wad);
244     }
245 
246     function transferFrom(address src, address dst, uint wad)
247         public
248         returns (bool)
249     {
250         if (src != msg.sender) {
251             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
252         }
253 
254         _balances[src] = sub(_balances[src], wad);
255         _balances[dst] = add(_balances[dst], wad);
256 
257         emit Transfer(src, dst, wad);
258 
259         return true;
260     }
261 
262     function approve(address guy, uint wad) public returns (bool) {
263         _approvals[msg.sender][guy] = wad;
264 
265         emit Approval(msg.sender, guy, wad);
266 
267         return true;
268     }
269 }
270 /*
271   This file is part of The Colony Network.
272 
273   The Colony Network is free software: you can redistribute it and/or modify
274   it under the terms of the GNU General Public License as published by
275   the Free Software Foundation, either version 3 of the License, or
276   (at your option) any later version.
277 
278   The Colony Network is distributed in the hope that it will be useful,
279   but WITHOUT ANY WARRANTY; without even the implied warranty of
280   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
281   GNU General Public License for more details.
282 
283   You should have received a copy of the GNU General Public License
284   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
285 */
286 
287 
288 
289 
290 
291 
292 
293 contract ERC20Extended is ERC20 {
294   event Mint(address indexed guy, uint wad);
295   event Burn(address indexed guy, uint wad);
296 
297   function mint(uint wad) public;
298   
299   function burn(uint wad) public;
300 }
301 
302 
303 contract Token is DSTokenBase(0), DSAuth, ERC20Extended {
304   uint8 public decimals;
305   string public symbol;
306   string public name;
307 
308   bool public locked;
309 
310   modifier unlocked {
311     if (locked) {
312       require(isAuthorized(msg.sender, msg.sig));
313     }
314     _;
315   }
316 
317   constructor(string _name, string _symbol, uint8 _decimals) public {
318     name = _name;
319     symbol = _symbol;
320     decimals = _decimals;
321     locked = true;
322   }
323 
324   function transferFrom(address src, address dst, uint wad) public 
325   unlocked
326   returns (bool)
327   {
328     return super.transferFrom(src, dst, wad);
329   }
330 
331   function mint(uint wad) public
332   auth
333   {
334     _balances[msg.sender] = add(_balances[msg.sender], wad);
335     _supply = add(_supply, wad);
336 
337     emit Mint(msg.sender, wad);
338   }
339 
340   function burn(uint wad) public {
341     _balances[msg.sender] = sub(_balances[msg.sender], wad);
342     _supply = sub(_supply, wad);
343 
344     emit Burn(msg.sender, wad);
345   }
346 
347   function unlock() public
348   auth
349   {
350     locked = false;
351   }
352 }