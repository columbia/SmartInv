1 pragma solidity ^0.5.0;
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
57         emit LogSetAuthority(address(authority));
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     modifier auth {
66         require(isAuthorized(msg.sender, msg.sig));
67         _;
68     }
69 
70     modifier authorized(bytes4 sig) {
71         require(isAuthorized(msg.sender, sig));
72         _;
73     }
74 
75     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
76         if (src == address(this)) {
77             return true;
78         } else if (src == owner) {
79             return true;
80         } else if (authority == DSAuthority(0)) {
81             return false;
82         } else {
83             return authority.canCall(src, address(this), sig);
84         }
85     }
86 
87 }
88 
89 
90 contract DSStop is DSAuth, DSNote {
91 
92     bool public stopped;
93 
94     modifier stoppable {
95         require(!stopped);
96         _;
97     }
98 
99     function stop() public payable auth note {
100         stopped = true;
101     }
102 
103     function start() public payable auth note {
104         stopped = false;
105     }
106 
107 }
108 
109 
110 contract DSMath {
111 
112     function add(uint x, uint y) internal pure returns (uint z) {
113         require((z = x + y) >= x, "ds-math-add-overflow");
114     }
115 
116     function sub(uint x, uint y) internal pure returns (uint z) {
117         require((z = x - y) <= x, "ds-math-sub-underflow");
118     }
119 
120     function mul(uint x, uint y) internal pure returns (uint z) {
121         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
122     }
123 
124     function min(uint x, uint y) internal pure returns (uint z) {
125         return x <= y ? x : y;
126     }
127 
128     function max(uint x, uint y) internal pure returns (uint z) {
129         return x >= y ? x : y;
130     }
131 
132     function imin(int x, int y) internal pure returns (int z) {
133         return x <= y ? x : y;
134     }
135 
136     function imax(int x, int y) internal pure returns (int z) {
137         return x >= y ? x : y;
138     }
139 
140     uint constant WAD = 10 ** 18;
141     uint constant RAY = 10 ** 27;
142 
143     function wmul(uint x, uint y) internal pure returns (uint z) {
144         z = add(mul(x, y), WAD / 2) / WAD;
145     }
146 
147     function rmul(uint x, uint y) internal pure returns (uint z) {
148         z = add(mul(x, y), RAY / 2) / RAY;
149     }
150 
151     function wdiv(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, WAD), y / 2) / y;
153     }
154 
155     function rdiv(uint x, uint y) internal pure returns (uint z) {
156         z = add(mul(x, RAY), y / 2) / y;
157     }
158 
159     // This famous algorithm is called "exponentiation by squaring"
160     // and calculates x^n with x as fixed-point and n as regular unsigned.
161     //
162     // It's O(log n), instead of O(n) for naive repeated multiplication.
163     //
164     // These facts are why it works:
165     //
166     //  If n is even, then x^n = (x^2)^(n/2).
167     //  If n is odd,  then x^n = x * x^(n-1),
168     //   and applying the equation for even x gives
169     //    x^n = x * (x^2)^((n-1) / 2).
170     //
171     //  Also, EVM division is flooring and
172     //    floor[(n-1) / 2] = floor[n / 2].
173     //
174     function rpow(uint x, uint n) internal pure returns (uint z) {
175         z = n % 2 != 0 ? x : RAY;
176 
177         for (n /= 2; n != 0; n /= 2) {
178             x = rmul(x, x);
179 
180             if (n % 2 != 0) {
181                 z = rmul(z, x);
182             }
183         }
184     }
185 }
186 
187 
188 contract ERC20 {
189 
190     function totalSupply() public view returns (uint);
191 
192     function balanceOf(address guy) public view returns (uint);
193 
194     function allowance(address src, address guy) public view returns (uint);
195 
196     function approve(address guy, uint wad) public returns (bool);
197 
198     function transfer(address dst, uint wad) public returns (bool);
199 
200     function transferFrom(address src, address dst, uint wad) public returns (bool);
201 
202     event Approval(address indexed src, address indexed guy, uint wad);
203     event Transfer(address indexed src, address indexed dst, uint wad);
204 }
205 
206 
207 contract ERC677 is ERC20 {
208     function transferAndCall(address dst, uint wad, bytes memory data) public returns (bool success);
209 
210     event Transfer(address indexed from, address indexed to, uint value, bytes data);
211 }
212 
213 
214 contract ERC677Receiver {
215     function onTokenTransfer(address sender, uint wad, bytes memory data) public ;
216 }
217 
218 
219 contract DSTokenBase is ERC20, DSMath {
220     uint256                                            _supply;
221     mapping(address => uint256)                       _balances;
222     mapping(address => mapping(address => uint256))  _approvals;
223     mapping (address => bool) public               frozenAccount;
224 
225     event FrozenFunds(address target, bool frozen);
226 
227     function totalSupply() public view returns (uint) {
228         return _supply;
229     }
230 
231     function balanceOf(address src) public view returns (uint) {
232         return _balances[src];
233     }
234 
235     function allowance(address src, address guy) public view returns (uint) {
236         return _approvals[src][guy];
237     }
238 
239     function transfer(address dst, uint wad) public returns (bool) {
240         require(dst != address(0) && wad > 0);
241         require(_balances[msg.sender] >= wad);
242         require(!frozenAccount[msg.sender]);
243         require(!frozenAccount[dst]);
244 
245         _balances[msg.sender] = sub(_balances[msg.sender], wad);
246         _balances[dst] = add(_balances[dst], wad);
247 
248         emit Transfer(msg.sender, dst, wad);
249 
250         return true;
251     }
252 
253     function transferFrom(address src, address dst, uint wad) public returns (bool) {
254         require(dst != address(0) && wad > 0);
255         require(_balances[src] >= wad);
256         require(_approvals[src][msg.sender] >= wad);
257         require(!frozenAccount[src]);
258         require(!frozenAccount[dst]);
259 
260         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
261         _balances[src] = sub(_balances[src], wad);
262         _balances[dst] = add(_balances[dst], wad);
263 
264         emit Transfer(src, dst, wad);
265         return true;
266     }
267 
268     function approve(address guy, uint wad) public returns (bool) {
269         require(guy != address(0) && wad >= 0);
270         _approvals[msg.sender][guy] = wad;
271 
272         emit Approval(msg.sender, guy, wad);
273         return true;
274     }
275 
276     function freezeAccount(address target, bool freeze) public returns (bool) {
277         frozenAccount[target] = freeze;
278         emit FrozenFunds(target, freeze);
279         return true;
280     }
281 }
282 
283 
284 contract ERC677Token is ERC677 {
285 
286     function transferAndCall(address dst, uint wad, bytes memory data) public returns (bool success) {
287         super.transfer(dst, wad);
288         emit Transfer(msg.sender, dst, wad, data);
289         if (isContract(dst)) {
290             contractFallback(dst, wad, data);
291         }
292         return true;
293     }
294 
295     function contractFallback(address dst, uint wad, bytes memory data) private {
296         ERC677Receiver receiver = ERC677Receiver(dst);
297         receiver.onTokenTransfer(msg.sender, wad, data);
298     }
299 
300     function isContract(address _addr) internal view returns (bool) {
301         uint size;
302         if (_addr == address(0)) return false;
303         assembly {
304             size := extcodesize(_addr)
305         }
306         return size>0;
307     }
308 }
309 
310 
311 contract GMAToken is DSTokenBase, ERC677Token, DSStop {
312     string  public  symbol = "GMAT";
313     string  public name = "GoWithMi";
314     uint256  public  decimals = 18;
315 
316     string public version = "G1.0"; // GMAT version
317 
318     constructor() public {
319         _supply = 14900000000000000000000000000;
320         _balances[msg.sender] = _supply;
321     }
322 
323     function transferAndCall(address dst, uint wad, bytes memory data) public stoppable returns (bool success) {
324         return super.transferAndCall(dst, wad, data);
325     }
326 
327     function transfer(address dst, uint wad) public stoppable returns (bool) {
328         return super.transfer(dst, wad);
329     }
330 
331     function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
332         return super.transferFrom(src, dst, wad);
333     }
334 
335     function approve(address guy, uint wad) public stoppable returns (bool) {
336         return super.approve(guy, wad);
337     }
338 
339     function push(address dst, uint wad) public returns (bool) {
340         return transfer(dst, wad);
341     }
342 
343     function pull(address src, uint wad) public returns (bool) {
344         return transferFrom(src, msg.sender, wad);
345     }
346 
347     function freezeAccount(address target, bool freeze) public onlyOwner returns (bool) {
348         return super.freezeAccount(target, freeze);
349     }
350 }