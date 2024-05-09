1 pragma solidity ^0.4.24;
2 
3 
4 contract DSNote {
5     event LogNote(
6         bytes4   indexed sig,
7         address  indexed guy,
8         bytes32  indexed foo,
9         bytes32  indexed bar,
10         uint wad,
11         bytes fax
12     ) anonymous;
13 
14     modifier note {
15         bytes32 foo;
16         bytes32 bar;
17 
18         assembly {
19             foo := calldataload(4)
20             bar := calldataload(36)
21         }
22 
23         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
24 
25         _;
26     }
27 }
28 
29 
30 contract DSAuthority {
31     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
32 }
33 
34 
35 contract DSAuthEvents {
36     event LogSetAuthority (address indexed authority);
37     event LogSetOwner     (address indexed owner);
38 }
39 
40 
41 contract DSAuth is DSAuthEvents {
42     DSAuthority  public  authority;
43     address      public  owner;
44 
45     constructor() public{
46         owner = msg.sender;
47         emit LogSetOwner(msg.sender);
48     }
49 
50     function setOwner(address owner_) public auth {
51         owner = owner_;
52         emit LogSetOwner(owner);
53     }
54 
55     function setAuthority(DSAuthority authority_) public auth {
56         authority = authority_;
57         emit LogSetAuthority(authority);
58     }
59 
60 
61     modifier auth {
62         require(isAuthorized(msg.sender, msg.sig));
63         _;
64     }
65 
66     modifier authorized(bytes4 sig) {
67         require(isAuthorized(msg.sender, sig));
68         _;
69     }
70 
71     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
72         if (src == address(this)) {
73             return true;
74         } else if (src == owner) {
75             return true;
76         } else if (authority == DSAuthority(0)) {
77             return false;
78         } else {
79             return authority.canCall(src, this, sig);
80         }
81     }
82 
83 }
84 
85 
86 contract DSStop is DSAuth, DSNote {
87 
88     bool public stopped;
89 
90     modifier stoppable {
91         require(!stopped);
92         _;
93     }
94 
95     function stop() public auth note {
96         stopped = true;
97     }
98 
99     function start() public auth note {
100         stopped = false;
101     }
102 
103 }
104 
105 
106 contract DSMath {
107 
108     function add(uint x, uint y) internal pure returns (uint z) {
109         require((z = x + y) >= x);
110     }
111 
112     function sub(uint x, uint y) internal pure returns (uint z) {
113         require((z = x - y) <= x);
114     }
115 
116     function mul(uint x, uint y) internal pure returns (uint z) {
117         require(y == 0 || (z = x * y) / y == x);
118     }
119 
120     function min(uint x, uint y) internal pure returns (uint z) {
121         return x <= y ? x : y;
122     }
123 
124     function max(uint x, uint y) internal pure returns (uint z) {
125         return x >= y ? x : y;
126     }
127 
128     function imin(int x, int y) internal pure returns (int z) {
129         return x <= y ? x : y;
130     }
131 
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
142 
143     function rmul(uint x, uint y) internal pure returns (uint z) {
144         z = add(mul(x, y), RAY / 2) / RAY;
145     }
146 
147     function wdiv(uint x, uint y) internal pure returns (uint z) {
148         z = add(mul(x, WAD), y / 2) / y;
149     }
150 
151     function rdiv(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, RAY), y / 2) / y;
153     }
154 
155     // This famous algorithm is called "exponentiation by squaring"
156     // and calculates x^n with x as fixed-point and n as regular unsigned.
157     //
158     // It's O(log n), instead of O(n) for naive repeated multiplication.
159     //
160     // These facts are why it works:
161     //
162     //  If n is even, then x^n = (x^2)^(n/2).
163     //  If n is odd,  then x^n = x * x^(n-1),
164     //   and applying the equation for even x gives
165     //    x^n = x * (x^2)^((n-1) / 2).
166     //
167     //  Also, EVM division is flooring and
168     //    floor[(n-1) / 2] = floor[n / 2].
169     //
170     function rpow(uint x, uint n) internal pure returns (uint z) {
171         z = n % 2 != 0 ? x : RAY;
172 
173         for (n /= 2; n != 0; n /= 2) {
174             x = rmul(x, x);
175 
176             if (n % 2 != 0) {
177                 z = rmul(z, x);
178             }
179         }
180     }
181 }
182 
183 
184 contract ERC20 {
185 
186     function totalSupply() public view returns (uint);
187 
188     function balanceOf(address guy) public view returns (uint);
189 
190     function allowance(address src, address guy) public view returns (uint);
191 
192     function approve(address guy, uint wad) public returns (bool);
193 
194     function transfer(address dst, uint wad) public returns (bool);
195 
196     function transferFrom(address src, address dst, uint wad) public returns (bool);
197 
198     event Approval(address indexed src, address indexed guy, uint wad);
199     event Transfer(address indexed src, address indexed dst, uint wad);
200 }
201 
202 
203 contract DSTokenBase is ERC20, DSMath {
204     uint256                                            _supply;
205     mapping(address => uint256)                       _balances;
206     mapping(address => mapping(address => uint256))  _approvals;
207 
208 
209     function totalSupply() public view returns (uint) {
210         return _supply;
211     }
212 
213     function balanceOf(address src) public view returns (uint) {
214         return _balances[src];
215     }
216 
217     function allowance(address src, address guy) public view returns (uint) {
218         return _approvals[src][guy];
219     }
220 
221     function transfer(address dst, uint wad) public returns (bool) {
222         require(dst != address(0) && wad > 0);
223         require(_balances[msg.sender] >= wad);
224 
225         _balances[msg.sender] = sub(_balances[msg.sender], wad);
226         _balances[dst] = add(_balances[dst], wad);
227 
228         emit Transfer(msg.sender, dst, wad);
229 
230         return true;
231     }
232 
233     function transferFrom(address src, address dst, uint wad) public returns (bool) {
234         require(dst != address(0) && wad > 0);
235         require(_balances[src] >= wad);
236         require(_approvals[src][msg.sender] >= wad);
237 
238         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
239         _balances[src] = sub(_balances[src], wad);
240         _balances[dst] = add(_balances[dst], wad);
241 
242         emit Transfer(src, dst, wad);
243         return true;
244     }
245 
246     function approve(address guy, uint wad) public returns (bool) {
247         require(guy != address(0) && wad >= 0);
248         _approvals[msg.sender][guy] = wad;
249 
250         emit Approval(msg.sender, guy, wad);
251         return true;
252     }
253 
254 }
255 
256 
257 contract GMAToken is DSTokenBase, DSStop {
258     string  public  symbol = "GMAT";
259     string  public name = "GoWithMi";
260     uint256  public  decimals = 18;
261 
262     string public version = "G0.1"; // GMAT version
263 
264     constructor() public {
265         _supply = 14900000000000000000000000000;
266         _balances[msg.sender] = _supply;
267     }
268 
269     function transfer(address dst, uint wad) public stoppable note returns (bool) {
270         return super.transfer(dst, wad);
271     }
272 
273     function transferFrom(address src, address dst, uint wad) public stoppable note returns (bool) {
274         return super.transferFrom(src, dst, wad);
275     }
276 
277     function approve(address guy, uint wad) public stoppable note returns (bool) {
278         return super.approve(guy, wad);
279     }
280 
281     function push(address dst, uint wad) public returns (bool) {
282         return transfer(dst, wad);
283     }
284 
285     function pull(address src, uint wad) public returns (bool) {
286         return transferFrom(src, msg.sender, wad);
287     }
288 
289 }