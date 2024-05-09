1 // hevm: flattened sources of src/token.sol
2 pragma solidity >0.4.13 >=0.4.23;
3 
4 ////// lib/ds-auth/src/auth.sol
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
18 /* pragma solidity >=0.4.23; */
19 
20 interface DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) external view returns (bool);
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
53         emit LogSetAuthority(address(authority));
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
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
69             return authority.canCall(src, address(this), sig);
70         }
71     }
72 }
73 
74 ////// lib/ds-math/src/math.sol
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
90 /* pragma solidity >0.4.13; */
91 
92 contract DSMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x, "ds-math-add-overflow");
95     }
96     function sub(uint x, uint y) internal pure returns (uint z) {
97         require((z = x - y) <= x, "ds-math-sub-underflow");
98     }
99     function mul(uint x, uint y) internal pure returns (uint z) {
100         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
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
119     //rounds to zero if x*y < WAD / 2
120     function wmul(uint x, uint y) internal pure returns (uint z) {
121         z = add(mul(x, y), WAD / 2) / WAD;
122     }
123     //rounds to zero if x*y < WAD / 2
124     function rmul(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, y), RAY / 2) / RAY;
126     }
127     //rounds to zero if x*y < WAD / 2
128     function wdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, WAD), y / 2) / y;
130     }
131     //rounds to zero if x*y < RAY / 2
132     function rdiv(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, RAY), y / 2) / y;
134     }
135 
136     // This famous algorithm is called "exponentiation by squaring"
137     // and calculates x^n with x as fixed-point and n as regular unsigned.
138     //
139     // It's O(log n), instead of O(n) for naive repeated multiplication.
140     //
141     // These facts are why it works:
142     //
143     //  If n is even, then x^n = (x^2)^(n/2).
144     //  If n is odd,  then x^n = x * x^(n-1),
145     //   and applying the equation for even x gives
146     //    x^n = x * (x^2)^((n-1) / 2).
147     //
148     //  Also, EVM division is flooring and
149     //    floor[(n-1) / 2] = floor[n / 2].
150     //
151     function rpow(uint x, uint n) internal pure returns (uint z) {
152         z = n % 2 != 0 ? x : RAY;
153 
154         for (n /= 2; n != 0; n /= 2) {
155             x = rmul(x, x);
156 
157             if (n % 2 != 0) {
158                 z = rmul(z, x);
159             }
160         }
161     }
162 }
163 
164 ////// src/token.sol
165 /// token.sol -- ERC20 implementation with minting and burning
166 
167 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
168 
169 // This program is free software: you can redistribute it and/or modify
170 // it under the terms of the GNU General Public License as published by
171 // the Free Software Foundation, either version 3 of the License, or
172 // (at your option) any later version.
173 
174 // This program is distributed in the hope that it will be useful,
175 // but WITHOUT ANY WARRANTY; without even the implied warranty of
176 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
177 // GNU General Public License for more details.
178 
179 // You should have received a copy of the GNU General Public License
180 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
181 
182 /* pragma solidity >=0.4.23; */
183 
184 /* import "ds-math/math.sol"; */
185 /* import "ds-auth/auth.sol"; */
186 
187 
188 contract DSToken is DSMath, DSAuth {
189     bool                                              public  stopped;
190     uint256                                           public  totalSupply;
191     mapping (address => uint256)                      public  balanceOf;
192     mapping (address => mapping (address => uint256)) public  allowance;
193     bytes32                                           public  symbol;
194     uint256                                           public  decimals = 18; // standard token precision. override to customize
195     bytes32                                           public  name = "";     // Optional token name
196 
197     constructor(bytes32 symbol_) public {
198         symbol = symbol_;
199     }
200 
201     event Approval(address indexed src, address indexed guy, uint wad);
202     event Transfer(address indexed src, address indexed dst, uint wad);
203     event Mint(address indexed guy, uint wad);
204     event Burn(address indexed guy, uint wad);
205     event Stop();
206     event Start();
207 
208     modifier stoppable {
209         require(!stopped, "ds-stop-is-stopped");
210         _;
211     }
212 
213     function approve(address guy) external returns (bool) {
214         return approve(guy, uint(-1));
215     }
216 
217     function approve(address guy, uint wad) public stoppable returns (bool) {
218         allowance[msg.sender][guy] = wad;
219 
220         emit Approval(msg.sender, guy, wad);
221 
222         return true;
223     }
224 
225     function transfer(address dst, uint wad) external returns (bool) {
226         return transferFrom(msg.sender, dst, wad);
227     }
228 
229     function transferFrom(address src, address dst, uint wad)
230         public
231         stoppable
232         returns (bool)
233     {
234         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
235             require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
236             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
237         }
238 
239         require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
240         balanceOf[src] = sub(balanceOf[src], wad);
241         balanceOf[dst] = add(balanceOf[dst], wad);
242 
243         emit Transfer(src, dst, wad);
244 
245         return true;
246     }
247 
248     function push(address dst, uint wad) external {
249         transferFrom(msg.sender, dst, wad);
250     }
251 
252     function pull(address src, uint wad) external {
253         transferFrom(src, msg.sender, wad);
254     }
255 
256     function move(address src, address dst, uint wad) external {
257         transferFrom(src, dst, wad);
258     }
259 
260 
261     function mint(uint wad) external {
262         mint(msg.sender, wad);
263     }
264 
265     function burn(uint wad) external {
266         burn(msg.sender, wad);
267     }
268 
269     function mint(address guy, uint wad) public auth stoppable {
270         balanceOf[guy] = add(balanceOf[guy], wad);
271         totalSupply = add(totalSupply, wad);
272         emit Mint(guy, wad);
273     }
274 
275     function burn(address guy, uint wad) public auth stoppable {
276         if (guy != msg.sender && allowance[guy][msg.sender] != uint(-1)) {
277             require(allowance[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
278             allowance[guy][msg.sender] = sub(allowance[guy][msg.sender], wad);
279         }
280 
281         require(balanceOf[guy] >= wad, "ds-token-insufficient-balance");
282         balanceOf[guy] = sub(balanceOf[guy], wad);
283         totalSupply = sub(totalSupply, wad);
284         emit Burn(guy, wad);
285     }
286 
287     function stop() public auth {
288         stopped = true;
289         emit Stop();
290     }
291 
292     function start() public auth {
293         stopped = false;
294         emit Start();
295     }
296 
297     function setName(bytes32 name_) external auth {
298         name = name_;
299     }
300 }
