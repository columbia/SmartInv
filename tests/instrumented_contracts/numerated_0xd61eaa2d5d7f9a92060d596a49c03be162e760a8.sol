1 /// MKR Token
2 /// token.sol -- ERC20 implementation with minting and burning
3 
4 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
5 
6 // Licensed under the Apache License, Version 2.0 (the "License").
7 // You may not use this file except in compliance with the License.
8 
9 // Unless required by applicable law or agreed to in writing, software
10 // distributed under the License is distributed on an "AS IS" BASIS,
11 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
12 
13 pragma solidity ^0.4.13;
14 
15 contract DSAuthority {
16     function canCall(
17         address src, address dst, bytes4 sig
18     ) public view returns (bool);
19 }
20 
21 contract DSAuthEvents {
22     event LogSetAuthority (address indexed authority);
23     event LogSetOwner     (address indexed owner);
24 }
25 
26 contract DSAuth is DSAuthEvents {
27     DSAuthority  public  authority;
28     address      public  owner;
29 
30     function DSAuth() public {
31         owner = msg.sender;
32         LogSetOwner(msg.sender);
33     }
34 
35     function setOwner(address owner_)
36         public
37         auth
38     {
39         owner = owner_;
40         LogSetOwner(owner);
41     }
42 
43     function setAuthority(DSAuthority authority_)
44         public
45         auth
46     {
47         authority = authority_;
48         LogSetAuthority(authority);
49     }
50 
51     modifier auth {
52         require(isAuthorized(msg.sender, msg.sig));
53         _;
54     }
55 
56     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
57         if (src == address(this)) {
58             return true;
59         } else if (src == owner) {
60             return true;
61         } else if (authority == DSAuthority(0)) {
62             return false;
63         } else {
64             return authority.canCall(src, this, sig);
65         }
66     }
67 }
68 
69 contract DSNote {
70     event LogNote(
71         bytes4   indexed  sig,
72         address  indexed  guy,
73         bytes32  indexed  foo,
74         bytes32  indexed  bar,
75         uint              wad,
76         bytes             fax
77     ) anonymous;
78 
79     modifier note {
80         bytes32 foo;
81         bytes32 bar;
82 
83         assembly {
84             foo := calldataload(4)
85             bar := calldataload(36)
86         }
87 
88         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
89 
90         _;
91     }
92 }
93 
94 contract DSStop is DSNote, DSAuth {
95 
96     bool public stopped;
97 
98     modifier stoppable {
99         require(!stopped);
100         _;
101     }
102     function stop() public auth note {
103         stopped = true;
104     }
105     function start() public auth note {
106         stopped = false;
107     }
108 
109 }
110 
111 contract ERC20 {
112     function totalSupply() public view returns (uint supply);
113     function balanceOf( address who ) public view returns (uint value);
114     function allowance( address owner, address spender ) public view returns (uint _allowance);
115 
116     function transfer( address to, uint value) public returns (bool ok);
117     function transferFrom( address from, address to, uint value) public returns (bool ok);
118     function approve( address spender, uint value ) public returns (bool ok);
119 
120     event Transfer( address indexed from, address indexed to, uint value);
121     event Approval( address indexed owner, address indexed spender, uint value);
122 }
123 
124 contract DSMath {
125     function add(uint x, uint y) internal pure returns (uint z) {
126         require((z = x + y) >= x);
127     }
128     function sub(uint x, uint y) internal pure returns (uint z) {
129         require((z = x - y) <= x);
130     }
131     function mul(uint x, uint y) internal pure returns (uint z) {
132         require(y == 0 || (z = x * y) / y == x);
133     }
134 
135     function min(uint x, uint y) internal pure returns (uint z) {
136         return x <= y ? x : y;
137     }
138     function max(uint x, uint y) internal pure returns (uint z) {
139         return x >= y ? x : y;
140     }
141     function imin(int x, int y) internal pure returns (int z) {
142         return x <= y ? x : y;
143     }
144     function imax(int x, int y) internal pure returns (int z) {
145         return x >= y ? x : y;
146     }
147 
148     uint constant WAD = 10 ** 18;
149     uint constant RAY = 10 ** 27;
150 
151     function wmul(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, y), WAD / 2) / WAD;
153     }
154     function rmul(uint x, uint y) internal pure returns (uint z) {
155         z = add(mul(x, y), RAY / 2) / RAY;
156     }
157     function wdiv(uint x, uint y) internal pure returns (uint z) {
158         z = add(mul(x, WAD), y / 2) / y;
159     }
160     function rdiv(uint x, uint y) internal pure returns (uint z) {
161         z = add(mul(x, RAY), y / 2) / y;
162     }
163 
164     // This famous algorithm is called "exponentiation by squaring"
165     // and calculates x^n with x as fixed-point and n as regular unsigned.
166     //
167     // It's O(log n), instead of O(n) for naive repeated multiplication.
168     //
169     // These facts are why it works:
170     //
171     //  If n is even, then x^n = (x^2)^(n/2).
172     //  If n is odd,  then x^n = x * x^(n-1),
173     //   and applying the equation for even x gives
174     //    x^n = x * (x^2)^((n-1) / 2).
175     //
176     //  Also, EVM division is flooring and
177     //    floor[(n-1) / 2] = floor[n / 2].
178     //
179     function rpow(uint x, uint n) internal pure returns (uint z) {
180         z = n % 2 != 0 ? x : RAY;
181 
182         for (n /= 2; n != 0; n /= 2) {
183             x = rmul(x, x);
184 
185             if (n % 2 != 0) {
186                 z = rmul(z, x);
187             }
188         }
189     }
190 }
191 
192 contract DSTokenBase is ERC20, DSMath {
193     uint256                                            _supply;
194     mapping (address => uint256)                       _balances;
195     mapping (address => mapping (address => uint256))  _approvals;
196 
197     function DSTokenBase(uint supply) public {
198         _balances[msg.sender] = supply;
199         _supply = supply;
200     }
201 
202     function totalSupply() public view returns (uint) {
203         return _supply;
204     }
205     function balanceOf(address src) public view returns (uint) {
206         return _balances[src];
207     }
208     function allowance(address src, address guy) public view returns (uint) {
209         return _approvals[src][guy];
210     }
211 
212     function transfer(address dst, uint wad) public returns (bool) {
213         return transferFrom(msg.sender, dst, wad);
214     }
215 
216     function transferFrom(address src, address dst, uint wad)
217         public
218         returns (bool)
219     {
220         if (src != msg.sender) {
221             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
222         }
223 
224         _balances[src] = sub(_balances[src], wad);
225         _balances[dst] = add(_balances[dst], wad);
226 
227         Transfer(src, dst, wad);
228 
229         return true;
230     }
231 
232     function approve(address guy, uint wad) public returns (bool) {
233         _approvals[msg.sender][guy] = wad;
234 
235         Approval(msg.sender, guy, wad);
236 
237         return true;
238     }
239 }
240 
241 contract DSToken is DSTokenBase(0), DSStop {
242 
243     mapping (address => mapping (address => bool)) _trusted;
244 
245     bytes32  public  symbol;
246     uint256  public  decimals = 18; // standard token precision. override to customize
247 
248     function DSToken(bytes32 symbol_) public {
249         symbol = symbol_;
250     }
251 
252     event Trust(address indexed src, address indexed guy, bool wat);
253     event Mint(address indexed guy, uint wad);
254     event Burn(address indexed guy, uint wad);
255 
256     function trusted(address src, address guy) public view returns (bool) {
257         return _trusted[src][guy];
258     }
259     function trust(address guy, bool wat) public stoppable {
260         _trusted[msg.sender][guy] = wat;
261         Trust(msg.sender, guy, wat);
262     }
263 
264     function approve(address guy, uint wad) public stoppable returns (bool) {
265         return super.approve(guy, wad);
266     }
267     function transferFrom(address src, address dst, uint wad)
268         public
269         stoppable
270         returns (bool)
271     {
272         if (src != msg.sender && !_trusted[src][msg.sender]) {
273             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
274         }
275 
276         _balances[src] = sub(_balances[src], wad);
277         _balances[dst] = add(_balances[dst], wad);
278 
279         Transfer(src, dst, wad);
280 
281         return true;
282     }
283 
284     function push(address dst, uint wad) public {
285         transferFrom(msg.sender, dst, wad);
286     }
287     function pull(address src, uint wad) public {
288         transferFrom(src, msg.sender, wad);
289     }
290     function move(address src, address dst, uint wad) public {
291         transferFrom(src, dst, wad);
292     }
293 
294     function mint(uint wad) public {
295         mint(msg.sender, wad);
296     }
297     function burn(uint wad) public {
298         burn(msg.sender, wad);
299     }
300     function mint(address guy, uint wad) public auth stoppable {
301         _balances[guy] = add(_balances[guy], wad);
302         _supply = add(_supply, wad);
303         Mint(guy, wad);
304     }
305     function burn(address guy, uint wad) public auth stoppable {
306         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
307             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
308         }
309 
310         _balances[guy] = sub(_balances[guy], wad);
311         _supply = sub(_supply, wad);
312         Burn(guy, wad);
313     }
314 
315     // Optional token name
316     bytes32   public  name = "";
317 
318     function setName(bytes32 name_) public auth {
319         name = name_;
320     }
321 }