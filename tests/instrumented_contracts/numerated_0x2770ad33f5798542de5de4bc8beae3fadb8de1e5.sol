1 //import "ds-auth/auth.sol";
2 contract DSAuthority {
3     function canCall(
4     address src, address dst, bytes4 sig
5     ) constant returns (bool);
6 }
7 
8 contract DSAuthEvents {
9     event LogSetAuthority (address indexed authority);
10     event LogSetOwner     (address indexed owner);
11 }
12 
13 contract DSAuth is DSAuthEvents {
14     DSAuthority  public  authority;
15     address      public  owner;
16 
17     function DSAuth() {
18         owner = msg.sender;
19         LogSetOwner(msg.sender);
20     }
21 
22     function setOwner(address owner_)
23     auth
24     {
25         owner = owner_;
26         LogSetOwner(owner);
27     }
28 
29     function setAuthority(DSAuthority authority_)
30     auth
31     {
32         authority = authority_;
33         LogSetAuthority(authority);
34     }
35 
36     modifier auth {
37         assert(isAuthorized(msg.sender, msg.sig));
38         _;
39     }
40 
41     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
42         if (src == address(this)) {
43             return true;
44         } else if (src == owner) {
45             return true;
46         } else if (authority == DSAuthority(0)) {
47             return false;
48         } else {
49             return authority.canCall(src, this, sig);
50         }
51     }
52 
53     function assert(bool x) internal {
54         if (!x) throw;
55     }
56 }
57 
58 //import "ds-note/note.sol";
59 contract DSNote {
60     event LogNote(
61     bytes4   indexed  sig,
62     address  indexed  guy,
63     bytes32  indexed  foo,
64     bytes32  indexed  bar,
65     uint        wad,
66     bytes             fax
67     ) anonymous;
68 
69     modifier note {
70         bytes32 foo;
71         bytes32 bar;
72 
73         assembly {
74         foo := calldataload(4)
75         bar := calldataload(36)
76         }
77 
78         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
79 
80         _;
81     }
82 }
83 
84 
85 //import "ds-math/math.sol";
86 contract DSMath {
87 
88     /*
89     standard uint256 functions
90      */
91 
92     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
93         assert((z = x + y) >= x);
94     }
95 
96     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
97         assert((z = x - y) <= x);
98     }
99 
100     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
101         z = x * y;
102         assert(x == 0 || z / x == y);
103     }
104 
105     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
106         z = x / y;
107     }
108 
109     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
110         return x <= y ? x : y;
111     }
112     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
113         return x >= y ? x : y;
114     }
115 
116     /*
117     uint128 functions (h is for half)
118      */
119 
120 
121     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
122         assert((z = x + y) >= x);
123     }
124 
125     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
126         assert((z = x - y) <= x);
127     }
128 
129     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
130         z = x * y;
131         assert(x == 0 || z / x == y);
132     }
133 
134     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         z = x / y;
136     }
137 
138     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
139         return x <= y ? x : y;
140     }
141     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
142         return x >= y ? x : y;
143     }
144 
145 
146     /*
147     int256 functions
148      */
149 
150     function imin(int256 x, int256 y) constant internal returns (int256 z) {
151         return x <= y ? x : y;
152     }
153     function imax(int256 x, int256 y) constant internal returns (int256 z) {
154         return x >= y ? x : y;
155     }
156 
157     /*
158     WAD math
159      */
160 
161     uint128 constant WAD = 10 ** 18;
162 
163     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
164         return hadd(x, y);
165     }
166 
167     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
168         return hsub(x, y);
169     }
170 
171     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
172         z = cast((uint256(x) * y + WAD / 2) / WAD);
173     }
174 
175     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
176         z = cast((uint256(x) * WAD + y / 2) / y);
177     }
178 
179     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
180         return hmin(x, y);
181     }
182     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
183         return hmax(x, y);
184     }
185 
186     /*
187     RAY math
188      */
189 
190     uint128 constant RAY = 10 ** 27;
191 
192     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
193         return hadd(x, y);
194     }
195 
196     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
197         return hsub(x, y);
198     }
199 
200     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
201         z = cast((uint256(x) * y + RAY / 2) / RAY);
202     }
203 
204     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
205         z = cast((uint256(x) * RAY + y / 2) / y);
206     }
207 
208     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
209         // This famous algorithm is called "exponentiation by squaring"
210         // and calculates x^n with x as fixed-point and n as regular unsigned.
211         //
212         // It's O(log n), instead of O(n) for naive repeated multiplication.
213         //
214         // These facts are why it works:
215         //
216         //  If n is even, then x^n = (x^2)^(n/2).
217         //  If n is odd,  then x^n = x * x^(n-1),
218         //   and applying the equation for even x gives
219         //    x^n = x * (x^2)^((n-1) / 2).
220         //
221         //  Also, EVM division is flooring and
222         //    floor[(n-1) / 2] = floor[n / 2].
223 
224         z = n % 2 != 0 ? x : RAY;
225 
226         for (n /= 2; n != 0; n /= 2) {
227             x = rmul(x, x);
228 
229             if (n % 2 != 0) {
230                 z = rmul(z, x);
231             }
232         }
233     }
234 
235     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
236         return hmin(x, y);
237     }
238     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
239         return hmax(x, y);
240     }
241 
242     function cast(uint256 x) constant internal returns (uint128 z) {
243         assert((z = uint128(x)) == x);
244     }
245 
246 }
247 
248 //import "erc20/erc20.sol";
249 contract ERC20 {
250     function totalSupply() constant returns (uint supply);
251     function balanceOf( address who ) constant returns (uint value);
252     function allowance( address owner, address spender ) constant returns (uint _allowance);
253 
254     function transfer( address to, uint value) returns (bool ok);
255     function transferFrom( address from, address to, uint value) returns (bool ok);
256     function approve( address spender, uint value ) returns (bool ok);
257 
258     event Transfer( address indexed from, address indexed to, uint value);
259     event Approval( address indexed owner, address indexed spender, uint value);
260 }
261 
262 
263 
264 //import "ds-token/base.sol";
265 contract DSTokenBase is ERC20, DSMath {
266     uint256                                            _supply;
267     mapping (address => uint256)                       _balances;
268     mapping (address => mapping (address => uint256))  _approvals;
269 
270     function DSTokenBase(uint256 supply) {
271         _balances[msg.sender] = supply;
272         _supply = supply;
273     }
274 
275     function totalSupply() constant returns (uint256) {
276         return _supply;
277     }
278     function balanceOf(address src) constant returns (uint256) {
279         return _balances[src];
280     }
281     function allowance(address src, address guy) constant returns (uint256) {
282         return _approvals[src][guy];
283     }
284 
285     function transfer(address dst, uint wad) returns (bool) {
286         assert(_balances[msg.sender] >= wad);
287 
288         _balances[msg.sender] = sub(_balances[msg.sender], wad);
289         _balances[dst] = add(_balances[dst], wad);
290 
291         Transfer(msg.sender, dst, wad);
292 
293         return true;
294     }
295 
296     function transferFrom(address src, address dst, uint wad) returns (bool) {
297         assert(_balances[src] >= wad);
298         assert(_approvals[src][msg.sender] >= wad);
299 
300         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
301         _balances[src] = sub(_balances[src], wad);
302         _balances[dst] = add(_balances[dst], wad);
303 
304         Transfer(src, dst, wad);
305 
306         return true;
307     }
308 
309     function approve(address guy, uint256 wad) returns (bool) {
310         _approvals[msg.sender][guy] = wad;
311 
312         Approval(msg.sender, guy, wad);
313 
314         return true;
315     }
316 
317 }
318 
319 
320 //import "ds-stop/stop.sol";
321 contract DSStop is DSAuth, DSNote {
322 
323     bool public stopped;
324 
325     modifier stoppable {
326         assert (!stopped);
327         _;
328     }
329     function stop() auth note {
330         stopped = true;
331     }
332     function start() auth note {
333         stopped = false;
334     }
335 
336 }
337 
338 
339 //import "ds-token/token.sol";
340 contract DSToken is DSTokenBase(0), DSStop {
341 
342     bytes32  public  symbol;
343     uint256  public  decimals = 18; // standard token precision. override to customize
344     address  public  generator;
345 
346     modifier onlyGenerator {
347         if(msg.sender!=generator) throw;
348         _;
349     }
350 
351     function DSToken(bytes32 symbol_) {
352         symbol = symbol_;
353         generator=msg.sender;
354     }
355 
356     function transfer(address dst, uint wad) stoppable note returns (bool) {
357         return super.transfer(dst, wad);
358     }
359     function transferFrom(
360     address src, address dst, uint wad
361     ) stoppable note returns (bool) {
362         return super.transferFrom(src, dst, wad);
363     }
364     function approve(address guy, uint wad) stoppable note returns (bool) {
365         return super.approve(guy, wad);
366     }
367 
368     function push(address dst, uint128 wad) returns (bool) {
369         return transfer(dst, wad);
370     }
371     function pull(address src, uint128 wad) returns (bool) {
372         return transferFrom(src, msg.sender, wad);
373     }
374 
375     function mint(uint128 wad) auth stoppable note {
376         _balances[msg.sender] = add(_balances[msg.sender], wad);
377         _supply = add(_supply, wad);
378     }
379     function burn(uint128 wad) auth stoppable note {
380         _balances[msg.sender] = sub(_balances[msg.sender], wad);
381         _supply = sub(_supply, wad);
382     }
383 
384     // owner can transfer token even stop,
385     function generatorTransfer(address dst, uint wad) onlyGenerator note returns (bool) {
386         return super.transfer(dst, wad);
387     }
388 
389     // Optional token name
390 
391     bytes32   public  name = "";
392 
393     function setName(bytes32 name_) auth {
394         name = name_;
395     }
396 
397 }