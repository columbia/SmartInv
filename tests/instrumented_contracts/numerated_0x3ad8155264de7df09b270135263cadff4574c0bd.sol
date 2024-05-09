1 pragma solidity ^0.5.7;
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
71 contract ERC20Events {
72     event Approval(address indexed src, address indexed guy, uint wad);
73     event Transfer(address indexed src, address indexed dst, uint wad);
74 }
75 
76 contract ERC20 is ERC20Events {
77     function totalSupply() public view returns (uint);
78     function balanceOf(address guy) public view returns (uint);
79     function allowance(address src, address guy) public view returns (uint);
80 
81     function approve(address guy, uint wad) public returns (bool);
82     function transfer(address dst, uint wad) public returns (bool);
83     function transferFrom(
84         address src, address dst, uint wad
85     ) public returns (bool);
86 }
87 
88 contract DSTokenBase is ERC20, DSMath {
89     uint256                                            _supply;
90     mapping (address => uint256)                       _balances;
91     mapping (address => mapping (address => uint256))  _approvals;
92 
93     constructor(uint supply) public {
94         _balances[msg.sender] = supply;
95         _supply = supply;
96     }
97 
98     function totalSupply() public view returns (uint) {
99         return _supply;
100     }
101     function balanceOf(address src) public view returns (uint) {
102         return _balances[src];
103     }
104     function allowance(address src, address guy) public view returns (uint) {
105         return _approvals[src][guy];
106     }
107 
108     function transfer(address dst, uint wad) public returns (bool) {
109         return transferFrom(msg.sender, dst, wad);
110     }
111 
112     function transferFrom(address src, address dst, uint wad)
113         public
114         returns (bool)
115     {
116         if (src != msg.sender) {
117             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
118             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
119         }
120 
121         require(_balances[src] >= wad, "ds-token-insufficient-balance");
122         _balances[src] = sub(_balances[src], wad);
123         _balances[dst] = add(_balances[dst], wad);
124 
125         emit Transfer(src, dst, wad);
126 
127         return true;
128     }
129 
130     function approve(address guy, uint wad) public returns (bool) {
131         _approvals[msg.sender][guy] = wad;
132 
133         emit Approval(msg.sender, guy, wad);
134 
135         return true;
136     }
137 }
138 contract DSNote {
139     event LogNote(
140         bytes4   indexed  sig,
141         address  indexed  guy,
142         bytes32  indexed  foo,
143         bytes32  indexed  bar,
144         uint              wad,
145         bytes             fax
146     ) anonymous;
147 
148     modifier note {
149         bytes32 foo;
150         bytes32 bar;
151 
152         assembly {
153             foo := calldataload(4)
154             bar := calldataload(36)
155         }
156 
157         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
158 
159         _;
160     }
161 }
162 
163 contract DSAuthority {
164     function canCall(
165         address src, address dst, bytes4 sig
166     ) public view returns (bool);
167 }
168 
169 contract DSAuthEvents {
170     event LogSetAuthority (address indexed authority);
171     event LogSetOwner     (address indexed owner);
172 }
173 
174 contract DSAuth is DSAuthEvents {
175     DSAuthority  public  authority;
176     address      public  owner;
177 
178     constructor() public {
179         owner = msg.sender;
180         emit LogSetOwner(msg.sender);
181     }
182 
183     function setOwner(address owner_)
184         public
185         auth
186     {
187         owner = owner_;
188         emit LogSetOwner(owner);
189     }
190 
191     function setAuthority(DSAuthority authority_)
192         public
193         auth
194     {
195         authority = authority_;
196         emit LogSetAuthority(address(authority));
197     }
198 
199     modifier auth {
200         require(isAuthorized(msg.sender, msg.sig));
201         _;
202     }
203 
204     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
205         if (src == address(this)) {
206             return true;
207         } else if (src == owner) {
208             return true;
209         } else if (authority == DSAuthority(0)) {
210             return false;
211         } else {
212             return authority.canCall(src, address(this), sig);
213         }
214     }
215 }
216 
217 contract DSStop is DSNote, DSAuth {
218 
219     bool public stopped;
220 
221     modifier stoppable {
222         require(!stopped);
223         _;
224     }
225     function stop() public payable auth note {
226         stopped = true;
227     }
228     function start() public payable auth note {
229         stopped = false;
230     }
231 
232 }
233 contract HedgeTrade is DSTokenBase(0), DSStop {
234 
235     mapping (address => mapping (address => bool)) _trusted;
236 
237     bytes32  public  symbol;
238     uint256  public  decimals = 18; // standard token precision. override to customize
239 
240     constructor (bytes32 symbol_) public {
241         symbol = symbol_;
242     }
243 
244     event Trust(address indexed src, address indexed guy, bool wat);
245     event Mint(address indexed guy, uint wad);
246     event Burn(address indexed guy, uint wad);
247 
248     function trusted(address src, address guy) public view returns (bool) {
249         return _trusted[src][guy];
250     }
251     function trust(address guy, bool wat) public stoppable {
252         _trusted[msg.sender][guy] = wat;
253         emit Trust(msg.sender, guy, wat);
254     }
255 
256     function approve(address guy, uint wad) public stoppable returns (bool) {
257         return super.approve(guy, wad);
258     }
259     function transferFrom(address src, address dst, uint wad)
260         public
261         stoppable
262         returns (bool)
263     {
264         if (src != msg.sender && !_trusted[src][msg.sender]) {
265             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
266         }
267 
268         _balances[src] = sub(_balances[src], wad);
269         _balances[dst] = add(_balances[dst], wad);
270 
271         emit Transfer(src, dst, wad);
272 
273         return true;
274     }
275 
276     function push(address dst, uint wad) public {
277         transferFrom(msg.sender, dst, wad);
278     }
279     function pull(address src, uint wad) public {
280         transferFrom(src, msg.sender, wad);
281     }
282     function move(address src, address dst, uint wad) public {
283         transferFrom(src, dst, wad);
284     }
285 
286     function mint(uint wad) public {
287         mint(msg.sender, wad);
288     }
289     function burn(uint wad) public {
290         burn(msg.sender, wad);
291     }
292     function mint(address guy, uint wad) public auth stoppable {
293         _balances[guy] = add(_balances[guy], wad);
294         _supply = add(_supply, wad);
295         emit Mint(guy, wad);
296     }
297     function burn(address guy, uint wad) public auth stoppable {
298         _balances[guy] = sub(_balances[guy], wad);
299         _supply = sub(_supply, wad);
300         emit Burn(guy, wad);
301     }
302 
303     // Optional token name
304     bytes32 public  name = "";
305 
306     function setName(bytes32 name_) public auth {
307         name = name_;
308     }
309 }