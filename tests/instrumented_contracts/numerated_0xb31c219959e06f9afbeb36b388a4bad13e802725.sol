1 pragma solidity ^0.4.24;
2 contract DSNote {
3     event LogNote(
4         bytes4   indexed  sig,
5         address  indexed  guy,
6         bytes32  indexed  foo,
7         bytes32  indexed  bar,
8         uint              wad,
9         bytes             fax
10     ) anonymous;
11 
12     modifier note {
13         bytes32 foo;
14         bytes32 bar;
15 
16         assembly {
17             foo := calldataload(4)
18             bar := calldataload(36)
19         }
20 
21         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
22         _;
23     }
24 }
25 
26 contract DSAuthority {
27     function canCall(address src, address dst, bytes4 sig) public constant returns (bool);
28 }
29 
30 contract DSAuthEvents {
31     event LogSetAuthority (address indexed authority);
32     event LogSetOwner     (address indexed owner);
33 }
34 
35 contract DSAuth is DSAuthEvents {
36     DSAuthority  public  authority;
37     address      public  owner;
38 
39     constructor() public {
40         owner = msg.sender;
41         emit LogSetOwner(msg.sender);
42     }
43 
44     function setOwner(address owner_) public auth 
45     {
46         require(owner_ != address(0));
47         owner = owner_;
48         emit LogSetOwner(owner);
49     }
50 
51     function setAuthority(DSAuthority authority_) public auth
52     {
53         authority = authority_;
54         emit LogSetAuthority(authority);
55     }
56 
57     modifier auth {
58         assert(isAuthorized(msg.sender, msg.sig));
59         _;
60     }
61 
62     modifier authorized(bytes4 sig) {
63         assert(isAuthorized(msg.sender, sig));
64         _;
65     }
66 
67     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
68         if (src == address(this)) {
69             return true;
70         } else if (src == owner) {
71             return true;
72         } else if (authority == DSAuthority(0)) {
73             return false;
74         } else {
75             return authority.canCall(src, this, sig);
76         }
77     }
78 
79     // function assert(bool x) internal pure{
80     //     if (!x) revert();
81     // }
82 }
83 
84 contract DSStop is DSAuth, DSNote {
85 
86     bool public stopped;
87 
88     modifier stoppable {
89         assert (!stopped);
90         _;
91     }
92     function stop() public auth note {
93         stopped = true;
94     }
95     function start() public auth note {
96         stopped = false;
97     }
98 
99 }
100 
101 contract DSMath {
102     
103     /*
104     standard uint256 functions
105      */
106 
107     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
108         assert((z = x + y) >= x);
109     }
110 
111     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
112         assert((z = x - y) <= x);
113     }
114 
115     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
116         assert(y == 0 || (z = x * y) / y == x);
117     }
118 
119     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
120         z = x / y;
121     }
122 
123     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
124         return x <= y ? x : y;
125     }
126     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
127         return x >= y ? x : y;
128     }
129 
130     /*
131     uint128 functions (h is for half)
132      */
133 
134 
135     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
136         assert((z = x + y) >= x);
137     }
138 
139     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
140         assert((z = x - y) <= x);
141     }
142 
143     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
144         assert(y == 0 || (z = x * y) / y == x);
145     }
146 
147     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
148         z = x / y;
149     }
150 
151     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
152         return x <= y ? x : y;
153     }
154     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
155         return x >= y ? x : y;
156     }
157 
158 
159     /*
160     int256 functions
161      */
162 
163     function imin(int256 x, int256 y) pure internal returns (int256 z) {
164         return x <= y ? x : y;
165     }
166     function imax(int256 x, int256 y) pure internal returns (int256 z) {
167         return x >= y ? x : y;
168     }
169 
170     /*
171     WAD math
172      */
173 
174     uint128 constant WAD = 10 ** 18;
175 
176     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
177         return hadd(x, y);
178     }
179 
180     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
181         return hsub(x, y);
182     }
183 
184     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
185         z = cast(add(mul(uint256(x), y), WAD/2) / WAD);
186     }
187 
188     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
189         z = cast(add(mul(uint256(x), WAD), y/2) / y);
190     }
191 
192     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
193         return hmin(x, y);
194     }
195     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
196         return hmax(x, y);
197     }
198 
199     /*
200     RAY math
201      */
202 
203     uint128 constant RAY = 10 ** 27;
204 
205     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
206         return hadd(x, y);
207     }
208 
209     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
210         return hsub(x, y);
211     }
212 
213     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
214         z = cast(add(mul(uint256(x), y), RAY/2) / RAY);
215     }
216 
217     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
218         z = cast(add(mul(uint256(x), RAY), y/2) / y);
219     }
220 
221     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
222         // This famous algorithm is called "exponentiation by squaring"
223         // and calculates x^n with x as fixed-point and n as regular unsigned.
224         //
225         // It's O(log n), instead of O(n) for naive repeated multiplication.
226         //
227         // These facts are why it works:
228         //
229         //  If n is even, then x^n = (x^2)^(n/2).
230         //  If n is odd,  then x^n = x * x^(n-1),
231         //   and applying the equation for even x gives
232         //    x^n = x * (x^2)^((n-1) / 2).
233         //
234         //  Also, EVM division is flooring and
235         //    floor[(n-1) / 2] = floor[n / 2].
236 
237         z = n % 2 != 0 ? x : RAY;
238 
239         for (n /= 2; n != 0; n /= 2) {
240             x = rmul(x, x);
241 
242             if (n % 2 != 0) {
243                 z = rmul(z, x);
244             }
245         }
246     }
247 
248     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
249         return hmin(x, y);
250     }
251     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
252         return hmax(x, y);
253     }
254 
255     function cast(uint256 x) pure internal returns (uint128 z) {
256         assert((z = uint128(x)) == x);
257     }
258 
259 }
260 
261 contract ERC20 {
262     function totalSupply() public view returns (uint supply);
263     function balanceOf( address who ) public view returns (uint value);
264     function allowance( address owner, address spender ) public view returns (uint _allowance);
265 
266     function transfer( address to, uint value) public returns (bool ok);
267     function transferFrom( address from, address to, uint value) public returns (bool ok);
268     function approve( address spender, uint value ) public returns (bool ok);
269 
270     event Transfer( address indexed from, address indexed to, uint value);
271     event Approval( address indexed owner, address indexed spender, uint value);
272 }
273 
274 contract DSTokenBase is ERC20, DSMath {
275     uint256                                            _supply;
276     mapping (address => uint256)                       _balances;
277     mapping (address => mapping (address => uint256))  _approvals;
278     
279     constructor(uint256 supply) public{
280         _balances[msg.sender] = supply;
281         _supply = supply;
282     }
283     
284     function totalSupply() public view returns (uint256) {
285         return _supply;
286     }
287     function balanceOf(address src) public view returns (uint256) {
288         return _balances[src];
289     }
290     function allowance(address src, address guy) public view returns (uint256) {
291         return _approvals[src][guy];
292     }
293     
294     function transfer(address dst, uint wad) public returns (bool) {
295         assert(_balances[msg.sender] >= wad);
296         
297         _balances[msg.sender] = sub(_balances[msg.sender], wad);
298         _balances[dst] = add(_balances[dst], wad);
299         
300         emit Transfer(msg.sender, dst, wad);
301         
302         return true;
303     }
304     
305     function transferFrom(address src, address dst, uint wad) public returns (bool) {
306         assert(_balances[src] >= wad);
307         assert(_approvals[src][msg.sender] >= wad);
308         
309         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
310         _balances[src] = sub(_balances[src], wad);
311         _balances[dst] = add(_balances[dst], wad);
312         
313         emit Transfer(src, dst, wad);
314         
315         return true;
316     }
317     
318     function approve(address guy, uint256 wad) public returns (bool) {
319         _approvals[msg.sender][guy] = wad;
320         
321         emit Approval(msg.sender, guy, wad);
322         
323         return true;
324     }
325 
326 }
327 
328 contract DSToken is DSTokenBase(0), DSStop {
329 
330     bytes32  public  symbol;
331     bytes32  public  name;
332     uint256  public  decimals = 18; // standard token precision. override to customize
333     uint256  public  MAX_MINT_NUMBER = 1000*10**26;
334 
335     constructor(bytes32 symbol_, bytes32 name_) public{
336         symbol = symbol_;
337         name = name_;
338     }
339 
340     function transfer(address dst, uint wad) public stoppable note returns (bool) {
341         return super.transfer(dst, wad);
342     }
343     function transferFrom(
344         address src, address dst, uint wad
345     ) public stoppable note returns (bool) {
346         return super.transferFrom(src, dst, wad);
347     }
348     function approve(address guy, uint wad) public stoppable note returns (bool) {
349         return super.approve(guy, wad);
350     }
351 
352     function push(address dst, uint128 wad) public returns (bool) {
353         return transfer(dst, wad);
354     }
355     function pull(address src, uint128 wad) public returns (bool) {
356         return transferFrom(src, msg.sender, wad);
357     }
358 
359     function mint(uint128 wad) public auth stoppable note {
360         assert (add(_supply, wad) <= MAX_MINT_NUMBER);
361         _balances[msg.sender] = add(_balances[msg.sender], wad);
362         _supply = add(_supply, wad);
363     }
364     function burn(uint128 wad) public auth stoppable note {
365         _balances[msg.sender] = sub(_balances[msg.sender], wad);
366         _supply = sub(_supply, wad);
367     }
368 }