1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93     function start() public auth note {
94         stopped = false;
95     }
96 
97 }
98 
99 contract ERC20 {
100     function totalSupply() public view returns (uint supply);
101     function balanceOf( address who ) public view returns (uint value);
102     function allowance( address owner, address spender ) public view returns (uint _allowance);
103 
104     function transfer( address to, uint value) public returns (bool ok);
105     function transferFrom( address from, address to, uint value) public returns (bool ok);
106     function approve( address spender, uint value ) public returns (bool ok);
107 
108     event Transfer( address indexed from, address indexed to, uint value);
109     event Approval( address indexed owner, address indexed spender, uint value);
110 }
111 
112 contract DSMath {
113     function add(uint x, uint y) internal pure returns (uint z) {
114         require((z = x + y) >= x);
115     }
116     function sub(uint x, uint y) internal pure returns (uint z) {
117         require((z = x - y) <= x);
118     }
119     function mul(uint x, uint y) internal pure returns (uint z) {
120         require(y == 0 || (z = x * y) / y == x);
121     }
122 
123     function min(uint x, uint y) internal pure returns (uint z) {
124         return x <= y ? x : y;
125     }
126     function max(uint x, uint y) internal pure returns (uint z) {
127         return x >= y ? x : y;
128     }
129     function imin(int x, int y) internal pure returns (int z) {
130         return x <= y ? x : y;
131     }
132     function imax(int x, int y) internal pure returns (int z) {
133         return x >= y ? x : y;
134     }
135 
136     uint constant WAD = 10 ** 18;
137     uint constant RAY = 10 ** 27;
138 
139     function wmul(uint x, uint y) internal pure returns (uint z) {
140         z = add(mul(x, y), WAD / 2) / WAD;
141     }
142     function rmul(uint x, uint y) internal pure returns (uint z) {
143         z = add(mul(x, y), RAY / 2) / RAY;
144     }
145     function wdiv(uint x, uint y) internal pure returns (uint z) {
146         z = add(mul(x, WAD), y / 2) / y;
147     }
148     function rdiv(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, RAY), y / 2) / y;
150     }
151 
152     // This famous algorithm is called "exponentiation by squaring"
153     // and calculates x^n with x as fixed-point and n as regular unsigned.
154     //
155     // It's O(log n), instead of O(n) for naive repeated multiplication.
156     //
157     // These facts are why it works:
158     //
159     //  If n is even, then x^n = (x^2)^(n/2).
160     //  If n is odd,  then x^n = x * x^(n-1),
161     //   and applying the equation for even x gives
162     //    x^n = x * (x^2)^((n-1) / 2).
163     //
164     //  Also, EVM division is flooring and
165     //    floor[(n-1) / 2] = floor[n / 2].
166     //
167     function rpow(uint x, uint n) internal pure returns (uint z) {
168         z = n % 2 != 0 ? x : RAY;
169 
170         for (n /= 2; n != 0; n /= 2) {
171             x = rmul(x, x);
172 
173             if (n % 2 != 0) {
174                 z = rmul(z, x);
175             }
176         }
177     }
178 }
179 
180 contract DSTokenBase is ERC20, DSMath {
181     uint256                                            _supply;
182     mapping (address => uint256)                       _balances;
183     mapping (address => mapping (address => uint256))  _approvals;
184 
185     function DSTokenBase(uint supply) public {
186         _balances[msg.sender] = supply;
187         _supply = supply;
188     }
189 
190     function totalSupply() public view returns (uint) {
191         return _supply;
192     }
193     function balanceOf(address src) public view returns (uint) {
194         return _balances[src];
195     }
196     function allowance(address src, address guy) public view returns (uint) {
197         return _approvals[src][guy];
198     }
199 
200     function transfer(address dst, uint wad) public returns (bool) {
201         return transferFrom(msg.sender, dst, wad);
202     }
203 
204     function transferFrom(address src, address dst, uint wad)
205         public
206         returns (bool)
207     {
208         if (src != msg.sender) {
209             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
210         }
211 
212         _balances[src] = sub(_balances[src], wad);
213         _balances[dst] = add(_balances[dst], wad);
214 
215         Transfer(src, dst, wad);
216 
217         return true;
218     }
219 
220     function approve(address guy, uint wad) public returns (bool) {
221         _approvals[msg.sender][guy] = wad;
222 
223         Approval(msg.sender, guy, wad);
224 
225         return true;
226     }
227 }
228 
229 contract DSToken is DSTokenBase(0), DSStop {
230 
231     mapping (address => mapping (address => bool)) _trusted;
232 
233     bytes32  public  symbol;
234     uint256  public  decimals = 18; // standard token precision. override to customize
235 
236     function DSToken(bytes32 symbol_) public {
237         symbol = symbol_;
238     }
239 
240     event Trust(address indexed src, address indexed guy, bool wat);
241     event Mint(address indexed guy, uint wad);
242     event Burn(address indexed guy, uint wad);
243 
244     function trusted(address src, address guy) public view returns (bool) {
245         return _trusted[src][guy];
246     }
247     function trust(address guy, bool wat) public stoppable {
248         _trusted[msg.sender][guy] = wat;
249         Trust(msg.sender, guy, wat);
250     }
251 
252     function approve(address guy, uint wad) public stoppable returns (bool) {
253         return super.approve(guy, wad);
254     }
255     function transferFrom(address src, address dst, uint wad)
256         public
257         stoppable
258         returns (bool)
259     {
260         if (src != msg.sender && !_trusted[src][msg.sender]) {
261             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
262         }
263 
264         _balances[src] = sub(_balances[src], wad);
265         _balances[dst] = add(_balances[dst], wad);
266 
267         Transfer(src, dst, wad);
268 
269         return true;
270     }
271 
272     function push(address dst, uint wad) public {
273         transferFrom(msg.sender, dst, wad);
274     }
275     function pull(address src, uint wad) public {
276         transferFrom(src, msg.sender, wad);
277     }
278     function move(address src, address dst, uint wad) public {
279         transferFrom(src, dst, wad);
280     }
281 
282     function mint(uint wad) public {
283         mint(msg.sender, wad);
284     }
285     function burn(uint wad) public {
286         burn(msg.sender, wad);
287     }
288     function mint(address guy, uint wad) public auth stoppable {
289         _balances[guy] = add(_balances[guy], wad);
290         _supply = add(_supply, wad);
291         Mint(guy, wad);
292     }
293     function burn(address guy, uint wad) public auth stoppable {
294         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
295             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
296         }
297 
298         _balances[guy] = sub(_balances[guy], wad);
299         _supply = sub(_supply, wad);
300         Burn(guy, wad);
301     }
302 
303     // Optional token name
304     bytes32   public  name = "";
305 
306     function setName(bytes32 name_) public auth {
307         name = name_;
308     }
309 }