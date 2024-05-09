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
30 contract ERC20 {
31 
32     function totalSupply() public view returns (uint);
33 
34     function balanceOf(address guy) public view returns (uint);
35 
36     function allowance(address src, address guy) public view returns (uint);
37 
38     function approve(address guy, uint wad) public returns (bool);
39 
40     function transfer(address dst, uint wad) public returns (bool);
41 
42     function transferFrom(address src, address dst, uint wad) public returns (bool);
43 
44     event Approval(address indexed src, address indexed guy, uint wad);
45     event Transfer(address indexed src, address indexed dst, uint wad);
46 }
47 
48 
49 contract DSAuthority {
50     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
51 }
52 
53 
54 contract DSAuthEvents {
55     event LogSetAuthority (address indexed authority);
56     event LogSetOwner     (address indexed owner);
57 }
58 
59 
60 contract DSAuth is DSAuthEvents {
61     DSAuthority  public  authority;
62     address      public  owner;
63 
64     constructor() public{
65         owner = msg.sender;
66         emit LogSetOwner(msg.sender);
67     }
68 
69     function setOwner(address owner_) public auth {
70         owner = owner_;
71         emit LogSetOwner(owner);
72     }
73 
74     function setAuthority(DSAuthority authority_) public auth {
75         authority = authority_;
76         emit LogSetAuthority(authority);
77     }
78 
79 
80     modifier auth {
81         require(isAuthorized(msg.sender, msg.sig));
82         _;
83     }
84 
85     modifier authorized(bytes4 sig) {
86         require(isAuthorized(msg.sender, sig));
87         _;
88     }
89 
90     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
91         if (src == address(this)) {
92             return true;
93         } else if (src == owner) {
94             return true;
95         } else if (authority == DSAuthority(0)) {
96             return false;
97         } else {
98             return authority.canCall(src, this, sig);
99         }
100     }
101 
102     modifier onlyOwner {
103         require(isOwner(msg.sender));
104         _;
105     }
106 
107     function isOwner(address src) internal view returns (bool) {
108         if (src == owner) {
109             return true;
110         }
111     }
112 }
113 
114 
115 contract DSMath {
116 
117     function add(uint x, uint y) internal pure returns (uint z) {
118         require((z = x + y) >= x);
119     }
120 
121     function sub(uint x, uint y) internal pure returns (uint z) {
122         require((z = x - y) <= x);
123     }
124 
125     function mul(uint x, uint y) internal pure returns (uint z) {
126         require(y == 0 || (z = x * y) / y == x);
127     }
128 
129     function min(uint x, uint y) internal pure returns (uint z) {
130         return x <= y ? x : y;
131     }
132 
133     function max(uint x, uint y) internal pure returns (uint z) {
134         return x >= y ? x : y;
135     }
136 
137     function imin(int x, int y) internal pure returns (int z) {
138         return x <= y ? x : y;
139     }
140 
141     function imax(int x, int y) internal pure returns (int z) {
142         return x >= y ? x : y;
143     }
144 
145     uint constant WAD = 10 ** 18;
146     uint constant RAY = 10 ** 27;
147 
148     function wmul(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, y), WAD / 2) / WAD;
150     }
151 
152     function rmul(uint x, uint y) internal pure returns (uint z) {
153         z = add(mul(x, y), RAY / 2) / RAY;
154     }
155 
156     function wdiv(uint x, uint y) internal pure returns (uint z) {
157         z = add(mul(x, WAD), y / 2) / y;
158     }
159 
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
192 
193 contract DSStop is DSAuth, DSNote {
194 
195     bool public stopped;
196 
197     modifier stoppable {
198         require(!stopped);
199         _;
200     }
201 
202     function stop() public auth note {
203         stopped = true;
204     }
205 
206     function start() public auth note {
207         stopped = false;
208     }
209 
210 }
211 
212 
213 contract DSTokenBase is ERC20, DSMath {
214     uint256                                            _supply;
215     mapping(address => uint256)                       _balances;
216     mapping(address => mapping(address => uint256))  _approvals;
217 
218 
219     function totalSupply() public view returns (uint) {
220         return _supply;
221     }
222 
223     function balanceOf(address src) public view returns (uint) {
224         return _balances[src];
225     }
226 
227     function allowance(address src, address guy) public view returns (uint) {
228         return _approvals[src][guy];
229     }
230 
231     function transfer(address dst, uint wad) public returns (bool) {
232         require(dst != address(0) && wad > 0);
233         require(_balances[msg.sender] >= wad);
234 
235         _balances[msg.sender] = sub(_balances[msg.sender], wad);
236         _balances[dst] = add(_balances[dst], wad);
237 
238         emit Transfer(msg.sender, dst, wad);
239 
240         return true;
241     }
242 
243     function transferFrom(address src, address dst, uint wad) public returns (bool) {
244         require(dst != address(0) && wad > 0);
245         require(_balances[src] >= wad);
246         require(_approvals[src][msg.sender] >= wad);
247 
248         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
249         _balances[src] = sub(_balances[src], wad);
250         _balances[dst] = add(_balances[dst], wad);
251 
252         emit Transfer(src, dst, wad);
253         return true;
254     }
255 
256     function approve(address guy, uint wad) public returns (bool) {
257         require(guy != address(0) && wad >= 0);
258         _approvals[msg.sender][guy] = wad;
259 
260         emit Approval(msg.sender, guy, wad);
261         return true;
262     }
263 
264 }
265 
266 
267 contract MCoinToken is DSTokenBase, DSStop {
268     string  public  symbol = "MC";
269     string  public name = "MCoin";
270     uint256  public  decimals = 18;
271 
272     string public version = "M0.1"; // GMAT version
273 
274     constructor() public {
275         _supply = 14900000000000000000000000000;
276         _balances[msg.sender] = _supply;
277     }
278 
279     function transfer(address dst, uint wad) public stoppable note returns (bool) {
280         return super.transfer(dst, wad);
281     }
282 
283     function transferFrom(address src, address dst, uint wad) public stoppable note returns (bool) {
284         return super.transferFrom(src, dst, wad);
285     }
286 
287     function approve(address guy, uint wad) public stoppable note returns (bool) {
288         return super.approve(guy, wad);
289     }
290 
291     function push(address dst, uint wad) public returns (bool) {
292         return transfer(dst, wad);
293     }
294 
295     function pull(address src, uint wad) public returns (bool) {
296         return transferFrom(src, msg.sender, wad);
297     }
298 
299 }