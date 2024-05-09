1 // The MIT License (MIT)
2 // Copyright (c) 2017 Viewly (https://view.ly)
3 
4 pragma solidity ^0.4.16;
5 
6 contract DSMath {
7     function add(uint x, uint y) internal pure returns (uint z) {
8         require((z = x + y) >= x);
9     }
10     function sub(uint x, uint y) internal pure returns (uint z) {
11         require((z = x - y) <= x);
12     }
13     function mul(uint x, uint y) internal pure returns (uint z) {
14         require(y == 0 || (z = x * y) / y == x);
15     }
16 
17     function min(uint x, uint y) internal pure returns (uint z) {
18         return x <= y ? x : y;
19     }
20     function max(uint x, uint y) internal pure returns (uint z) {
21         return x >= y ? x : y;
22     }
23     function imin(int x, int y) internal pure returns (int z) {
24         return x <= y ? x : y;
25     }
26     function imax(int x, int y) internal pure returns (int z) {
27         return x >= y ? x : y;
28     }
29 
30     uint constant WAD = 10 ** 18;
31     uint constant RAY = 10 ** 27;
32 
33     function wmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), WAD / 2) / WAD;
35     }
36     function rmul(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, y), RAY / 2) / RAY;
38     }
39     function wdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, WAD), y / 2) / y;
41     }
42     function rdiv(uint x, uint y) internal pure returns (uint z) {
43         z = add(mul(x, RAY), y / 2) / y;
44     }
45 
46     // This famous algorithm is called "exponentiation by squaring"
47     // and calculates x^n with x as fixed-point and n as regular unsigned.
48     //
49     // It's O(log n), instead of O(n) for naive repeated multiplication.
50     //
51     // These facts are why it works:
52     //
53     //  If n is even, then x^n = (x^2)^(n/2).
54     //  If n is odd,  then x^n = x * x^(n-1),
55     //   and applying the equation for even x gives
56     //    x^n = x * (x^2)^((n-1) / 2).
57     //
58     //  Also, EVM division is flooring and
59     //    floor[(n-1) / 2] = floor[n / 2].
60     //
61     function rpow(uint x, uint n) internal pure returns (uint z) {
62         z = n % 2 != 0 ? x : RAY;
63 
64         for (n /= 2; n != 0; n /= 2) {
65             x = rmul(x, x);
66 
67             if (n % 2 != 0) {
68                 z = rmul(z, x);
69             }
70         }
71     }
72 }
73 
74 contract DSAuthority {
75     function canCall(
76         address src, address dst, bytes4 sig
77     ) public view returns (bool);
78 }
79 
80 contract DSAuthEvents {
81     event LogSetAuthority (address indexed authority);
82     event LogSetOwner     (address indexed owner);
83 }
84 
85 contract DSAuth is DSAuthEvents {
86     DSAuthority  public  authority;
87     address      public  owner;
88 
89     function DSAuth() public {
90         owner = msg.sender;
91         LogSetOwner(msg.sender);
92     }
93 
94     function setOwner(address owner_)
95         public
96         auth
97     {
98         owner = owner_;
99         LogSetOwner(owner);
100     }
101 
102     function setAuthority(DSAuthority authority_)
103         public
104         auth
105     {
106         authority = authority_;
107         LogSetAuthority(authority);
108     }
109 
110     modifier auth {
111         require(isAuthorized(msg.sender, msg.sig));
112         _;
113     }
114 
115     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
116         if (src == address(this)) {
117             return true;
118         } else if (src == owner) {
119             return true;
120         } else if (authority == DSAuthority(0)) {
121             return false;
122         } else {
123             return authority.canCall(src, this, sig);
124         }
125     }
126 }
127 
128 contract DSNote {
129     event LogNote(
130         bytes4   indexed  sig,
131         address  indexed  guy,
132         bytes32  indexed  foo,
133         bytes32  indexed  bar,
134         uint              wad,
135         bytes             fax
136     ) anonymous;
137 
138     modifier note {
139         bytes32 foo;
140         bytes32 bar;
141 
142         assembly {
143             foo := calldataload(4)
144             bar := calldataload(36)
145         }
146 
147         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
148 
149         _;
150     }
151 }
152 
153 contract DSStop is DSNote, DSAuth {
154 
155     bool public stopped;
156 
157     modifier stoppable {
158         require(!stopped);
159         _;
160     }
161     function stop() public auth note {
162         stopped = true;
163     }
164     function start() public auth note {
165         stopped = false;
166     }
167 
168 }
169 
170 contract ERC20 {
171     function totalSupply() public view returns (uint supply);
172     function balanceOf( address who ) public view returns (uint value);
173     function allowance( address owner, address spender ) public view returns (uint _allowance);
174 
175     function transfer( address to, uint value) public returns (bool ok);
176     function transferFrom( address from, address to, uint value) public returns (bool ok);
177     function approve( address spender, uint value ) public returns (bool ok);
178 
179     event Transfer( address indexed from, address indexed to, uint value);
180     event Approval( address indexed owner, address indexed spender, uint value);
181 }
182 
183 contract DSTokenBase is ERC20, DSMath {
184     uint256                                            _supply;
185     mapping (address => uint256)                       _balances;
186     mapping (address => mapping (address => uint256))  _approvals;
187 
188     function DSTokenBase(uint supply) public {
189         _balances[msg.sender] = supply;
190         _supply = supply;
191     }
192 
193     function totalSupply() public view returns (uint) {
194         return _supply;
195     }
196     function balanceOf(address src) public view returns (uint) {
197         return _balances[src];
198     }
199     function allowance(address src, address guy) public view returns (uint) {
200         return _approvals[src][guy];
201     }
202 
203     function transfer(address dst, uint wad) public returns (bool) {
204         return transferFrom(msg.sender, dst, wad);
205     }
206 
207     function transferFrom(address src, address dst, uint wad)
208         public
209         returns (bool)
210     {
211         if (src != msg.sender) {
212             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
213         }
214 
215         _balances[src] = sub(_balances[src], wad);
216         _balances[dst] = add(_balances[dst], wad);
217 
218         Transfer(src, dst, wad);
219 
220         return true;
221     }
222 
223     function approve(address guy, uint wad) public returns (bool) {
224         _approvals[msg.sender][guy] = wad;
225 
226         Approval(msg.sender, guy, wad);
227 
228         return true;
229     }
230 }
231 
232 contract DSToken is DSTokenBase(0), DSStop {
233 
234     mapping (address => mapping (address => bool)) _trusted;
235 
236     bytes32  public  symbol;
237     uint256  public  decimals = 18; // standard token precision. override to customize
238 
239     function DSToken(bytes32 symbol_) public {
240         symbol = symbol_;
241     }
242 
243     event Trust(address indexed src, address indexed guy, bool wat);
244     event Mint(address indexed guy, uint wad);
245     event Burn(address indexed guy, uint wad);
246 
247     function trusted(address src, address guy) public view returns (bool) {
248         return _trusted[src][guy];
249     }
250     function trust(address guy, bool wat) public stoppable {
251         _trusted[msg.sender][guy] = wat;
252         Trust(msg.sender, guy, wat);
253     }
254 
255     function approve(address guy, uint wad) public stoppable returns (bool) {
256         return super.approve(guy, wad);
257     }
258     function transferFrom(address src, address dst, uint wad)
259         public
260         stoppable
261         returns (bool)
262     {
263         if (src != msg.sender && !_trusted[src][msg.sender]) {
264             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
265         }
266 
267         _balances[src] = sub(_balances[src], wad);
268         _balances[dst] = add(_balances[dst], wad);
269 
270         Transfer(src, dst, wad);
271 
272         return true;
273     }
274 
275     function push(address dst, uint wad) public {
276         transferFrom(msg.sender, dst, wad);
277     }
278     function pull(address src, uint wad) public {
279         transferFrom(src, msg.sender, wad);
280     }
281     function move(address src, address dst, uint wad) public {
282         transferFrom(src, dst, wad);
283     }
284 
285     function mint(uint wad) public {
286         mint(msg.sender, wad);
287     }
288     function burn(uint wad) public {
289         burn(msg.sender, wad);
290     }
291     function mint(address guy, uint wad) public auth stoppable {
292         _balances[guy] = add(_balances[guy], wad);
293         _supply = add(_supply, wad);
294         Mint(guy, wad);
295     }
296     function burn(address guy, uint wad) public auth stoppable {
297         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
298             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
299         }
300 
301         _balances[guy] = sub(_balances[guy], wad);
302         _supply = sub(_supply, wad);
303         Burn(guy, wad);
304     }
305 
306     // Optional token name
307     bytes32   public  name = "";
308 
309     function setName(bytes32 name_) public auth {
310         name = name_;
311     }
312 }
313 
314 /* ViewlyBountyRewards is a simple contract that allows distributing VIEW tokens
315    earned through Viewly Bounty program.
316  */
317 contract ViewlyBountyRewards is DSAuth, DSMath {
318     // total tokens rewarded is capped at 3% of token supply
319     uint constant public MAX_TOKEN_REWARDS = 3000000 ether;
320 
321     // VIEW token contract
322     DSToken public viewToken;
323 
324     uint public totalTokenRewards;
325     mapping (address => uint) public tokenRewards;
326 
327 
328     event LogTokenReward(
329         address recipient,
330         uint tokens
331     );
332 
333 
334     function ViewlyBountyRewards(DSToken viewToken_) {
335         viewToken = viewToken_;
336     }
337 
338     function sendTokenReward(address recipient, uint tokens) auth {
339         require(tokens > 0);
340         require(add(tokens, totalTokenRewards) <= MAX_TOKEN_REWARDS);
341 
342         tokenRewards[recipient] += tokens;
343         totalTokenRewards = add(tokens, totalTokenRewards);
344 
345         viewToken.mint(recipient, tokens);
346         LogTokenReward(recipient, tokens);
347     }
348 }