1 pragma solidity ^0.5.6;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x, "ds-math-add-overflow");
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x, "ds-math-sub-underflow");
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 
72 contract ERC20Events {
73     event Approval(address indexed src, address indexed guy, uint wad);
74     event Transfer(address indexed src, address indexed dst, uint wad);
75 }
76 
77 contract ERC20 is ERC20Events {
78     function totalSupply() public view returns (uint);
79     function balanceOf(address guy) public view returns (uint);
80     function allowance(address src, address guy) public view returns (uint);
81 
82     function approve(address guy, uint wad) public returns (bool);
83     function transfer(address dst, uint wad) public returns (bool);
84     function transferFrom(
85         address src, address dst, uint wad
86     ) public returns (bool);
87 }
88 
89 contract DSTokenBase is ERC20, DSMath {
90     uint256                                            _supply;
91     mapping (address => uint256)                       _balances;
92     mapping (address => mapping (address => uint256))  _approvals;
93 
94     constructor(uint supply) public {
95         _balances[msg.sender] = supply;
96         _supply = supply;
97     }
98 
99     function totalSupply() public view returns (uint) {
100         return _supply;
101     }
102     function balanceOf(address src) public view returns (uint) {
103         return _balances[src];
104     }
105     function allowance(address src, address guy) public view returns (uint) {
106         return _approvals[src][guy];
107     }
108 
109     function transfer(address dst, uint wad) public returns (bool) {
110         return transferFrom(msg.sender, dst, wad);
111     }
112 
113     function transferFrom(address src, address dst, uint wad)
114         public
115         returns (bool)
116     {
117         if (src != msg.sender) {
118             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
119             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
120         }
121 
122         require(_balances[src] >= wad, "ds-token-insufficient-balance");
123         _balances[src] = sub(_balances[src], wad);
124         _balances[dst] = add(_balances[dst], wad);
125 
126         emit Transfer(src, dst, wad);
127 
128         return true;
129     }
130 
131     function approve(address guy, uint wad) public returns (bool) {
132         _approvals[msg.sender][guy] = wad;
133 
134         emit Approval(msg.sender, guy, wad);
135 
136         return true;
137     }
138 }
139 contract DSNote {
140     event LogNote(
141         bytes4   indexed  sig,
142         address  indexed  guy,
143         bytes32  indexed  foo,
144         bytes32  indexed  bar,
145         uint              wad,
146         bytes             fax
147     ) anonymous;
148 
149     modifier note {
150         bytes32 foo;
151         bytes32 bar;
152 
153         assembly {
154             foo := calldataload(4)
155             bar := calldataload(36)
156         }
157 
158         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
159 
160         _;
161     }
162 }
163 
164 contract DSAuthority {
165     function canCall(
166         address src, address dst, bytes4 sig
167     ) public view returns (bool);
168 }
169 
170 contract DSAuthEvents {
171     event LogSetAuthority (address indexed authority);
172     event LogSetOwner     (address indexed owner);
173 }
174 
175 contract DSAuth is DSAuthEvents {
176     DSAuthority  public  authority;
177     address      public  owner;
178 
179     constructor() public {
180         owner = msg.sender;
181         emit LogSetOwner(msg.sender);
182     }
183 
184     function setOwner(address owner_)
185         public
186         auth
187     {
188         owner = owner_;
189         emit LogSetOwner(owner);
190     }
191 
192     function setAuthority(DSAuthority authority_)
193         public
194         auth
195     {
196         authority = authority_;
197         emit LogSetAuthority(address(authority));
198     }
199 
200     modifier auth {
201         require(isAuthorized(msg.sender, msg.sig));
202         _;
203     }
204 
205     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
206         if (src == address(this)) {
207             return true;
208         } else if (src == owner) {
209             return true;
210         } else if (authority == DSAuthority(0)) {
211             return false;
212         } else {
213             return authority.canCall(src, address(this), sig);
214         }
215     }
216 }
217 
218 contract DSStop is DSNote, DSAuth {
219 
220     bool public stopped;
221 
222     modifier stoppable {
223         require(!stopped);
224         _;
225     }
226     function stop() public payable auth note {
227         stopped = true;
228     }
229     function start() public payable auth note {
230         stopped = false;
231     }
232 
233 }
234 contract HedgeTrade is DSTokenBase(0), DSStop {
235 
236     mapping (address => mapping (address => bool)) _trusted;
237 
238     bytes32  public  symbol;
239     uint256  public  decimals = 18; // standard token precision. override to customize
240 
241     function DSToken(bytes32 symbol_) public {
242         symbol = symbol_;
243     }
244 
245     event Trust(address indexed src, address indexed guy, bool wat);
246     event Mint(address indexed guy, uint wad);
247     event Burn(address indexed guy, uint wad);
248 
249     function trusted(address src, address guy) public view returns (bool) {
250         return _trusted[src][guy];
251     }
252     function trust(address guy, bool wat) public stoppable {
253         _trusted[msg.sender][guy] = wat;
254         emit Trust(msg.sender, guy, wat);
255     }
256 
257     function approve(address guy, uint wad) public stoppable returns (bool) {
258         return super.approve(guy, wad);
259     }
260     function transferFrom(address src, address dst, uint wad)
261         public
262         stoppable
263         returns (bool)
264     {
265         if (src != msg.sender && !_trusted[src][msg.sender]) {
266             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
267         }
268 
269         _balances[src] = sub(_balances[src], wad);
270         _balances[dst] = add(_balances[dst], wad);
271 
272         emit Transfer(src, dst, wad);
273 
274         return true;
275     }
276 
277     function push(address dst, uint wad) public {
278         transferFrom(msg.sender, dst, wad);
279     }
280     function pull(address src, uint wad) public {
281         transferFrom(src, msg.sender, wad);
282     }
283     function move(address src, address dst, uint wad) public {
284         transferFrom(src, dst, wad);
285     }
286 
287     function mint(uint wad) public {
288         mint(msg.sender, wad);
289     }
290     function burn(uint wad) public {
291         burn(msg.sender, wad);
292     }
293     function mint(address guy, uint wad) public auth stoppable {
294         _balances[guy] = add(_balances[guy], wad);
295         _supply = add(_supply, wad);
296         emit Mint(guy, wad);
297     }
298     function burn(address guy, uint wad) public auth stoppable {
299         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
300             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
301         }
302 
303         _balances[guy] = sub(_balances[guy], wad);
304         _supply = sub(_supply, wad);
305         emit Burn(guy, wad);
306     }
307 
308     // Optional token name
309     bytes32   public  name = "";
310 
311     function setName(bytes32 name_) public auth {
312         name = name_;
313     }
314 }