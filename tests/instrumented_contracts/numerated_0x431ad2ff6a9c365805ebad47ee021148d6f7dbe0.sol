1 pragma solidity ^0.5.2;
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
14     function div(uint x, uint y) internal pure returns (uint z) {
15         require(y > 0, "ds-math-div-overflow");
16         z = x / y;
17     }
18 
19     function min(uint x, uint y) internal pure returns (uint z) {
20         return x <= y ? x : y;
21     }
22     function max(uint x, uint y) internal pure returns (uint z) {
23         return x >= y ? x : y;
24     }
25     // function imin(int x, int y) internal pure returns (int z) {
26     //     return x <= y ? x : y;
27     // }
28     // function imax(int x, int y) internal pure returns (int z) {
29     //     return x >= y ? x : y;
30     // }
31 
32     uint constant WAD = 10 ** 18;
33     // uint constant RAY = 10 ** 27;
34 
35     // function wmul(uint x, uint y) internal pure returns (uint z) {
36     //     z = add(mul(x, y), WAD / 2) / WAD;
37     // }
38     // function rmul(uint x, uint y) internal pure returns (uint z) {
39     //     z = add(mul(x, y), RAY / 2) / RAY;
40     // }
41     function wdiv(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, WAD), y / 2) / y;
43     }
44     // function rdiv(uint x, uint y) internal pure returns (uint z) {
45     //     z = add(mul(x, RAY), y / 2) / y;
46     // }
47 
48     // This famous algorithm is called "exponentiation by squaring"
49     // and calculates x^n with x as fixed-point and n as regular unsigned.
50     //
51     // It's O(log n), instead of O(n) for naive repeated multiplication.
52     //
53     // These facts are why it works:
54     //
55     //  If n is even, then x^n = (x^2)^(n/2).
56     //  If n is odd,  then x^n = x * x^(n-1),
57     //   and applying the equation for even x gives
58     //    x^n = x * (x^2)^((n-1) / 2).
59     //
60     //  Also, EVM division is flooring and
61     //    floor[(n-1) / 2] = floor[n / 2].
62     //
63     // function rpow(uint _x, uint n) internal pure returns (uint z) {
64     //     uint x = _x;
65     //     z = n % 2 != 0 ? x : RAY;
66 
67     //     for (n /= 2; n != 0; n /= 2) {
68     //         x = rmul(x, x);
69 
70     //         if (n % 2 != 0) {
71     //             z = rmul(z, x);
72     //         }
73     //     }
74     // }
75 
76     /**
77      * @dev x to the power of y power(base, exponent)
78      */
79     function pow(uint256 base, uint256 exponent) public pure returns (uint256) {
80         if (exponent == 0) {
81             return 1;
82         }
83         else if (exponent == 1) {
84             return base;
85         }
86         else if (base == 0 && exponent != 0) {
87             return 0;
88         }
89         else {
90             uint256 z = base;
91             for (uint256 i = 1; i < exponent; i++)
92                 z = mul(z, base);
93             return z;
94         }
95     }
96 }
97 
98 contract DSAuthEvents {
99     event LogSetAuthority (address indexed authority);
100     event LogSetOwner     (address indexed owner);
101 }
102 
103 contract DSAuth is DSAuthEvents {
104     address      public  authority;
105     address      public  owner;
106 
107     constructor() public {
108         owner = msg.sender;
109         emit LogSetOwner(msg.sender);
110     }
111 
112     function setOwner(address owner_)
113         public
114         onlyOwner
115     {
116         require(owner_ != address(0), "invalid owner address");
117         owner = owner_;
118         emit LogSetOwner(owner);
119     }
120 
121     function setAuthority(address authority_)
122         public
123         onlyOwner
124     {
125         authority = authority_;
126         emit LogSetAuthority(address(authority));
127     }
128 
129     modifier auth {
130         require(isAuthorized(msg.sender), "ds-auth-unauthorized");
131         _;
132     }
133 
134     modifier onlyOwner {
135         require(isOwner(msg.sender), "ds-auth-non-owner");
136         _;
137     }
138 
139     function isOwner(address src) public view returns (bool) {
140         return bool(src == owner);
141     }
142 
143     function isAuthorized(address src) internal view returns (bool) {
144         if (src == address(this)) {
145             return true;
146         } else if (src == owner) {
147             return true;
148         } else if (authority == address(0)) {
149             return false;
150         } else if (src == authority) {
151             return true;
152         } else {
153             return false;
154         }
155     }
156 }
157 
158 contract DSNote {
159     event LogNote(
160         bytes4   indexed  sig,
161         address  indexed  guy,
162         bytes32  indexed  foo,
163         bytes32  indexed  bar,
164         uint256           wad,
165         bytes             fax
166     ) anonymous;
167 
168     modifier note {
169         bytes32 foo;
170         bytes32 bar;
171         uint256 wad;
172 
173         assembly {
174             foo := calldataload(4)
175             bar := calldataload(36)
176             wad := callvalue
177         }
178 
179         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
180 
181         _;
182     }
183 }
184 
185 contract DSStop is DSNote, DSAuth, DSMath {
186     bool public stopped;
187 
188     modifier stoppable {
189         require(!stopped, "ds-stop-is-stopped");
190         _;
191     }
192     function stop() public onlyOwner note {
193         stopped = true;
194     }
195     function start() public onlyOwner note {
196         stopped = false;
197     }
198 }
199 
200 contract ERC20Events {
201     event Approval(address indexed src, address indexed guy, uint wad);
202     event Transfer(address indexed src, address indexed dst, uint wad);
203 }
204 
205 contract ERC20 is ERC20Events {
206     function totalSupply() public view returns (uint);
207     function balanceOf(address guy) public view returns (uint);
208     function allowance(address src, address guy) public view returns (uint);
209 
210     function approve(address guy, uint wad) public returns (bool);
211     function transfer(address dst, uint wad) public returns (bool);
212     function transferFrom(address src, address dst, uint wad) public returns (bool);
213 }
214 
215 contract DSTokenBase is ERC20, DSMath {
216     uint256                                            _supply;
217     mapping (address => uint256)                       _balances;
218     mapping (address => mapping (address => uint256))  _approvals;
219 
220     constructor(uint supply) public {
221         _supply = supply;
222     }
223 
224     function totalSupply() public view returns (uint) {
225         return _supply;
226     }
227     function balanceOf(address src) public view returns (uint) {
228         return _balances[src];
229     }
230     function allowance(address src, address guy) public view returns (uint) {
231         return _approvals[src][guy];
232     }
233 
234     function transfer(address dst, uint wad) public returns (bool) {
235         return transferFrom(msg.sender, dst, wad);
236     }
237 
238     function transferFrom(address src, address dst, uint wad)
239         public
240         returns (bool)
241     {
242         if (src != msg.sender) {
243             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
244             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
245         }
246 
247         require(_balances[src] >= wad, "ds-token-insufficient-balance");
248         _balances[src] = sub(_balances[src], wad);
249         _balances[dst] = add(_balances[dst], wad);
250 
251         emit Transfer(src, dst, wad);
252 
253         return true;
254     }
255 
256     function approve(address guy, uint wad) public returns (bool) {
257         _approvals[msg.sender][guy] = wad;
258 
259         emit Approval(msg.sender, guy, wad);
260 
261         return true;
262     }
263 }
264 
265 contract DSToken is DSTokenBase(0), DSStop {
266 
267     bytes32  public  name = "";
268     bytes32  public  symbol;
269     uint256  public  decimals = 18;
270 
271     constructor(bytes32 symbol_) public {
272         symbol = symbol_;
273     }
274 
275     function setName(bytes32 name_) public onlyOwner {
276         name = name_;
277     }
278 
279     function approvex(address guy) public stoppable returns (bool) {
280         return super.approve(guy, uint(-1));
281     }
282 
283     function approve(address guy, uint wad) public stoppable returns (bool) {
284         require(_approvals[msg.sender][guy] == 0 || wad == 0); //take care of re-approve.
285         return super.approve(guy, wad);
286     }
287 
288     function transferFrom(address src, address dst, uint wad)
289         public
290         stoppable
291         returns (bool)
292     {
293         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
294             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
295             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
296         }
297 
298         require(_balances[src] >= wad, "ds-token-insufficient-balance");
299         _balances[src] = sub(_balances[src], wad);
300         _balances[dst] = add(_balances[dst], wad);
301 
302         emit Transfer(src, dst, wad);
303 
304         return true;
305     }
306 
307     function mint(address guy, uint wad) public auth stoppable {
308         _mint(guy, wad);
309     }
310 
311     function burn(address guy, uint wad) public auth stoppable {
312         _burn(guy, wad);
313     }
314 
315     function _mint(address guy, uint wad) internal {
316         require(guy != address(0), "ds-token-mint: mint to the zero address");
317 
318         _balances[guy] = add(_balances[guy], wad);
319         _supply = add(_supply, wad);
320         emit Transfer(address(0), guy, wad);
321     }
322 
323     function _burn(address guy, uint wad) internal {
324         require(guy != address(0), "ds-token-burn: burn from the zero address");
325         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
326 
327         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
328             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
329             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
330         }
331 
332         _balances[guy] = sub(_balances[guy], wad);
333         _supply = sub(_supply, wad);
334         emit Transfer(guy, address(0), wad);
335     }
336 }