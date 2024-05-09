1 /// token.sol -- ERC20 implementation with minting and burning
2 
3 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
4 
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
18 pragma solidity >=0.4.23;
19 
20 contract DSMath {
21     function add(uint x, uint y) internal pure returns (uint z) {
22         require((z = x + y) >= x, "ds-math-add-overflow");
23     }
24     function sub(uint x, uint y) internal pure returns (uint z) {
25         require((z = x - y) <= x, "ds-math-sub-underflow");
26     }
27     function mul(uint x, uint y) internal pure returns (uint z) {
28         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
29     }
30 
31     function min(uint x, uint y) internal pure returns (uint z) {
32         return x <= y ? x : y;
33     }
34     function max(uint x, uint y) internal pure returns (uint z) {
35         return x >= y ? x : y;
36     }
37     function imin(int x, int y) internal pure returns (int z) {
38         return x <= y ? x : y;
39     }
40     function imax(int x, int y) internal pure returns (int z) {
41         return x >= y ? x : y;
42     }
43 
44     uint constant WAD = 10 ** 18;
45     uint constant RAY = 10 ** 27;
46 
47     //rounds to zero if x*y < WAD / 2
48     function wmul(uint x, uint y) internal pure returns (uint z) {
49         z = add(mul(x, y), WAD / 2) / WAD;
50     }
51     //rounds to zero if x*y < WAD / 2
52     function rmul(uint x, uint y) internal pure returns (uint z) {
53         z = add(mul(x, y), RAY / 2) / RAY;
54     }
55     //rounds to zero if x*y < WAD / 2
56     function wdiv(uint x, uint y) internal pure returns (uint z) {
57         z = add(mul(x, WAD), y / 2) / y;
58     }
59     //rounds to zero if x*y < RAY / 2
60     function rdiv(uint x, uint y) internal pure returns (uint z) {
61         z = add(mul(x, RAY), y / 2) / y;
62     }
63 
64     // This famous algorithm is called "exponentiation by squaring"
65     // and calculates x^n with x as fixed-point and n as regular unsigned.
66     //
67     // It's O(log n), instead of O(n) for naive repeated multiplication.
68     //
69     // These facts are why it works:
70     //
71     //  If n is even, then x^n = (x^2)^(n/2).
72     //  If n is odd,  then x^n = x * x^(n-1),
73     //   and applying the equation for even x gives
74     //    x^n = x * (x^2)^((n-1) / 2).
75     //
76     //  Also, EVM division is flooring and
77     //    floor[(n-1) / 2] = floor[n / 2].
78     //
79     function rpow(uint x, uint n) internal pure returns (uint z) {
80         z = n % 2 != 0 ? x : RAY;
81 
82         for (n /= 2; n != 0; n /= 2) {
83             x = rmul(x, x);
84 
85             if (n % 2 != 0) {
86                 z = rmul(z, x);
87             }
88         }
89     }
90 }
91 
92 interface DSAuthority {
93     function canCall(
94         address src, address dst, bytes4 sig
95     ) external view returns (bool);
96 }
97 
98 contract DSAuthEvents {
99     event LogSetAuthority (address indexed authority);
100     event LogSetOwner     (address indexed owner);
101 }
102 
103 contract DSAuth is DSAuthEvents {
104     DSAuthority  public  authority;
105     address      public  owner;
106 
107     constructor() public {
108         owner = msg.sender;
109         emit LogSetOwner(msg.sender);
110     }
111 
112     function setOwner(address owner_)
113         public
114         auth
115     {
116         owner = owner_;
117         emit LogSetOwner(owner);
118     }
119 
120     function setAuthority(DSAuthority authority_)
121         public
122         auth
123     {
124         authority = authority_;
125         emit LogSetAuthority(address(authority));
126     }
127 
128     modifier auth {
129         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
130         _;
131     }
132 
133     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
134         if (src == address(this)) {
135             return true;
136         } else if (src == owner) {
137             return true;
138         } else if (authority == DSAuthority(0)) {
139             return false;
140         } else {
141             return authority.canCall(src, address(this), sig);
142         }
143     }
144 }
145 
146 contract DSToken is DSMath, DSAuth {
147     bool                                              public  stopped;
148     uint256                                           public  totalSupply;
149     mapping (address => uint256)                      public  balanceOf;
150     mapping (address => mapping (address => uint256)) public  allowance;
151     bytes32                                           public  symbol;
152     uint256                                           public  decimals = 18; // standard token precision. override to customize
153     bytes32                                           public  name = "";     // Optional token name
154 
155     constructor(bytes32 symbol_) public {
156         symbol = symbol_;
157     }
158 
159     event Approval(address indexed src, address indexed guy, uint wad);
160     event Transfer(address indexed src, address indexed dst, uint wad);
161     event Mint(address indexed guy, uint wad);
162     event Burn(address indexed guy, uint wad);
163     event Stop();
164     event Start();
165 
166     modifier stoppable {
167         require(!stopped, "ds-stop-is-stopped");
168         _;
169     }
170 
171     function approve(address guy) external returns (bool) {
172         return approve(guy, uint(-1));
173     }
174 
175     function approve(address guy, uint wad) public stoppable returns (bool) {
176         allowance[msg.sender][guy] = wad;
177 
178         emit Approval(msg.sender, guy, wad);
179 
180         return true;
181     }
182 
183     function transfer(address dst, uint wad) external returns (bool) {
184         return transferFrom(msg.sender, dst, wad);
185     }
186 
187     function transferFrom(address src, address dst, uint wad)
188         public
189         stoppable
190         returns (bool)
191     {
192         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
193             require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");
194             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
195         }
196 
197         require(balanceOf[src] >= wad, "ds-token-insufficient-balance");
198         balanceOf[src] = sub(balanceOf[src], wad);
199         balanceOf[dst] = add(balanceOf[dst], wad);
200 
201         emit Transfer(src, dst, wad);
202 
203         return true;
204     }
205 
206     function push(address dst, uint wad) external {
207         transferFrom(msg.sender, dst, wad);
208     }
209 
210     function pull(address src, uint wad) external {
211         transferFrom(src, msg.sender, wad);
212     }
213 
214     function move(address src, address dst, uint wad) external {
215         transferFrom(src, dst, wad);
216     }
217 
218 
219     function mint(uint wad) external {
220         mint(msg.sender, wad);
221     }
222 
223     function burn(uint wad) external {
224         burn(msg.sender, wad);
225     }
226 
227     function mint(address guy, uint wad) public auth stoppable {
228         balanceOf[guy] = add(balanceOf[guy], wad);
229         totalSupply = add(totalSupply, wad);
230         emit Mint(guy, wad);
231     }
232 
233     function burn(address guy, uint wad) public auth stoppable {
234         if (guy != msg.sender && allowance[guy][msg.sender] != uint(-1)) {
235             require(allowance[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
236             allowance[guy][msg.sender] = sub(allowance[guy][msg.sender], wad);
237         }
238 
239         require(balanceOf[guy] >= wad, "ds-token-insufficient-balance");
240         balanceOf[guy] = sub(balanceOf[guy], wad);
241         totalSupply = sub(totalSupply, wad);
242         emit Burn(guy, wad);
243     }
244 
245     function stop() public auth {
246         stopped = true;
247         emit Stop();
248     }
249 
250     function start() public auth {
251         stopped = false;
252         emit Start();
253     }
254 
255     function setName(bytes32 name_) external auth {
256         name = name_;
257     }
258 }