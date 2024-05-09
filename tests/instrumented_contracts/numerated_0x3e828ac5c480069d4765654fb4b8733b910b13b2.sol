1 pragma solidity ^0.5.8;
2 /*
3   This file is part of The Colony Network.
4 
5   The Colony Network is free software: you can redistribute it and/or modify
6   it under the terms of the GNU General Public License as published by
7   the Free Software Foundation, either version 3 of the License, or
8   (at your option) any later version.
9 
10   The Colony Network is distributed in the hope that it will be useful,
11   but WITHOUT ANY WARRANTY; without even the implied warranty of
12   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13   GNU General Public License for more details.
14 
15   You should have received a copy of the GNU General Public License
16   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
17 */
18 
19 
20 
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
34 
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
51     constructor() public {
52         owner = msg.sender;
53         emit LogSetOwner(msg.sender);
54     }
55 
56     function setOwner(address owner_)
57         public
58         auth
59     {
60         owner = owner_;
61         emit LogSetOwner(owner);
62     }
63 
64     function setAuthority(DSAuthority authority_)
65         public
66         auth
67     {
68         authority = authority_;
69         emit LogSetAuthority(address(authority));
70     }
71 
72     modifier auth {
73         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
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
85             return authority.canCall(src, address(this), sig);
86         }
87     }
88 }
89 /// base.sol -- basic ERC20 implementation
90 
91 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
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
106 
107 
108 /// erc20.sol -- API for the ERC20 token standard
109 
110 // See <https://github.com/ethereum/EIPs/issues/20>.
111 
112 // This file likely does not meet the threshold of originality
113 // required for copyright to apply.  As a result, this is free and
114 // unencumbered software belonging to the public domain.
115 
116 
117 
118 contract ERC20Events {
119     event Approval(address indexed src, address indexed guy, uint wad);
120     event Transfer(address indexed src, address indexed dst, uint wad);
121 }
122 
123 contract ERC20 is ERC20Events {
124     function totalSupply() public view returns (uint);
125     function balanceOf(address guy) public view returns (uint);
126     function allowance(address src, address guy) public view returns (uint);
127 
128     function approve(address guy, uint wad) public returns (bool);
129     function transfer(address dst, uint wad) public returns (bool);
130     function transferFrom(
131         address src, address dst, uint wad
132     ) public returns (bool);
133 }
134 /// math.sol -- mixin for inline numerical wizardry
135 
136 // This program is free software: you can redistribute it and/or modify
137 // it under the terms of the GNU General Public License as published by
138 // the Free Software Foundation, either version 3 of the License, or
139 // (at your option) any later version.
140 
141 // This program is distributed in the hope that it will be useful,
142 // but WITHOUT ANY WARRANTY; without even the implied warranty of
143 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
144 // GNU General Public License for more details.
145 
146 // You should have received a copy of the GNU General Public License
147 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
148 
149 
150 
151 contract DSMath {
152     function add(uint x, uint y) internal pure returns (uint z) {
153         require((z = x + y) >= x, "ds-math-add-overflow");
154     }
155     function sub(uint x, uint y) internal pure returns (uint z) {
156         require((z = x - y) <= x, "ds-math-sub-underflow");
157     }
158     function mul(uint x, uint y) internal pure returns (uint z) {
159         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
160     }
161 
162     function min(uint x, uint y) internal pure returns (uint z) {
163         return x <= y ? x : y;
164     }
165     function max(uint x, uint y) internal pure returns (uint z) {
166         return x >= y ? x : y;
167     }
168     function imin(int x, int y) internal pure returns (int z) {
169         return x <= y ? x : y;
170     }
171     function imax(int x, int y) internal pure returns (int z) {
172         return x >= y ? x : y;
173     }
174 
175     uint constant WAD = 10 ** 18;
176     uint constant RAY = 10 ** 27;
177 
178     function wmul(uint x, uint y) internal pure returns (uint z) {
179         z = add(mul(x, y), WAD / 2) / WAD;
180     }
181     function rmul(uint x, uint y) internal pure returns (uint z) {
182         z = add(mul(x, y), RAY / 2) / RAY;
183     }
184     function wdiv(uint x, uint y) internal pure returns (uint z) {
185         z = add(mul(x, WAD), y / 2) / y;
186     }
187     function rdiv(uint x, uint y) internal pure returns (uint z) {
188         z = add(mul(x, RAY), y / 2) / y;
189     }
190 
191     // This famous algorithm is called "exponentiation by squaring"
192     // and calculates x^n with x as fixed-point and n as regular unsigned.
193     //
194     // It's O(log n), instead of O(n) for naive repeated multiplication.
195     //
196     // These facts are why it works:
197     //
198     //  If n is even, then x^n = (x^2)^(n/2).
199     //  If n is odd,  then x^n = x * x^(n-1),
200     //   and applying the equation for even x gives
201     //    x^n = x * (x^2)^((n-1) / 2).
202     //
203     //  Also, EVM division is flooring and
204     //    floor[(n-1) / 2] = floor[n / 2].
205     //
206     function rpow(uint x, uint n) internal pure returns (uint z) {
207         z = n % 2 != 0 ? x : RAY;
208 
209         for (n /= 2; n != 0; n /= 2) {
210             x = rmul(x, x);
211 
212             if (n % 2 != 0) {
213                 z = rmul(z, x);
214             }
215         }
216     }
217 }
218 
219 contract DSTokenBase is ERC20, DSMath {
220     uint256                                            _supply;
221     mapping (address => uint256)                       _balances;
222     mapping (address => mapping (address => uint256))  _approvals;
223 
224     constructor(uint supply) public {
225         _balances[msg.sender] = supply;
226         _supply = supply;
227     }
228 
229     function totalSupply() public view returns (uint) {
230         return _supply;
231     }
232     function balanceOf(address src) public view returns (uint) {
233         return _balances[src];
234     }
235     function allowance(address src, address guy) public view returns (uint) {
236         return _approvals[src][guy];
237     }
238 
239     function transfer(address dst, uint wad) public returns (bool) {
240         return transferFrom(msg.sender, dst, wad);
241     }
242 
243     function transferFrom(address src, address dst, uint wad)
244         public
245         returns (bool)
246     {
247         if (src != msg.sender) {
248             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
249             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
250         }
251 
252         require(_balances[src] >= wad, "ds-token-insufficient-balance");
253         _balances[src] = sub(_balances[src], wad);
254         _balances[dst] = add(_balances[dst], wad);
255 
256         emit Transfer(src, dst, wad);
257 
258         return true;
259     }
260 
261     function approve(address guy, uint wad) public returns (bool) {
262         _approvals[msg.sender][guy] = wad;
263 
264         emit Approval(msg.sender, guy, wad);
265 
266         return true;
267     }
268 }
269 /*
270   This file is part of The Colony Network.
271 
272   The Colony Network is free software: you can redistribute it and/or modify
273   it under the terms of the GNU General Public License as published by
274   the Free Software Foundation, either version 3 of the License, or
275   (at your option) any later version.
276 
277   The Colony Network is distributed in the hope that it will be useful,
278   but WITHOUT ANY WARRANTY; without even the implied warranty of
279   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
280   GNU General Public License for more details.
281 
282   You should have received a copy of the GNU General Public License
283   along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
284 */
285 
286 
287 
288 
289 
290 
291 contract ERC20Extended is ERC20 {
292   event Mint(address indexed guy, uint wad);
293   event Burn(address indexed guy, uint wad);
294 
295   function mint(uint wad) public;
296   function mint(address guy, uint wad) public;
297   function burn(uint wad) public;
298   function burn(address guy, uint wad) public;
299 }
300 
301 
302 contract Token is DSTokenBase(0), DSAuth, ERC20Extended {
303   uint8 public decimals;
304   string public symbol;
305   string public name;
306 
307   bool public locked;
308 
309   modifier unlocked {
310     if (locked) {
311       require(isAuthorized(msg.sender, msg.sig), "colony-token-unauthorised");
312     }
313     _;
314   }
315 
316   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
317     name = _name;
318     symbol = _symbol;
319     decimals = _decimals;
320     locked = true;
321   }
322 
323   function transferFrom(address src, address dst, uint wad) public 
324   unlocked
325   returns (bool)
326   {
327     return super.transferFrom(src, dst, wad);
328   }
329 
330   function mint(uint wad) public auth {
331     mint(msg.sender, wad);
332   }
333 
334   function burn(uint wad) public {
335     burn(msg.sender, wad);
336   }
337 
338   function mint(address guy, uint wad) public auth {
339     _balances[guy] = add(_balances[guy], wad);
340     _supply = add(_supply, wad);
341     emit Mint(guy, wad);
342     emit Transfer(address(0x0), guy, wad);
343   }
344 
345   function burn(address guy, uint wad) public {
346     if (guy != msg.sender) {
347       require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
348       _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
349     }
350 
351     require(_balances[guy] >= wad, "ds-token-insufficient-balance");
352     _balances[guy] = sub(_balances[guy], wad);
353     _supply = sub(_supply, wad);
354     emit Burn(guy, wad);
355   }
356 
357   function unlock() public
358   auth
359   {
360     locked = false;
361   }
362 }