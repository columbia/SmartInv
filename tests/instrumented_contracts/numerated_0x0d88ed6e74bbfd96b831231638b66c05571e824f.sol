1 contract DSAuthority {
2     function canCall(
3         address src, address dst, bytes4 sig
4     ) constant returns (bool);
5 }
6 
7 contract DSAuthEvents {
8     event LogSetAuthority (address indexed authority);
9     event LogSetOwner     (address indexed owner);
10 }
11 
12 contract DSAuth is DSAuthEvents {
13     DSAuthority  public  authority;
14     address      public  owner;
15 
16     function DSAuth() {
17         owner = msg.sender;
18         LogSetOwner(msg.sender);
19     }
20 
21     function setOwner(address owner_)
22         auth
23     {
24         owner = owner_;
25         LogSetOwner(owner);
26     }
27 
28     function setAuthority(DSAuthority authority_)
29         auth
30     {
31         authority = authority_;
32         LogSetAuthority(authority);
33     }
34 
35     modifier auth {
36         assert(isAuthorized(msg.sender, msg.sig));
37         _;
38     }
39 
40     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
41         if (src == address(this)) {
42             return true;
43         } else if (src == owner) {
44             return true;
45         } else if (authority == DSAuthority(0)) {
46             return false;
47         } else {
48             return authority.canCall(src, this, sig);
49         }
50     }
51 
52     function assert(bool x) internal {
53         if (!x) throw;
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63 	uint	 	  wad,
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
82 contract DSStop is DSAuth, DSNote {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         assert (!stopped);
88         _;
89     }
90     function stop() auth note {
91         stopped = true;
92     }
93     function start() auth note {
94         stopped = false;
95     }
96 
97 }
98 contract ERC20 {
99     function totalSupply() constant returns (uint supply);
100     function balanceOf( address who ) constant returns (uint value);
101     function allowance( address owner, address spender ) constant returns (uint _allowance);
102 
103     function transfer( address to, uint value) returns (bool ok);
104     function transferFrom( address from, address to, uint value) returns (bool ok);
105     function approve( address spender, uint value ) returns (bool ok);
106 
107     event Transfer( address indexed from, address indexed to, uint value);
108     event Approval( address indexed owner, address indexed spender, uint value);
109 }
110 
111 
112 
113 contract DSMath {
114     
115     /*
116     standard uint256 functions
117      */
118 
119     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
120         assert((z = x + y) >= x);
121     }
122 
123     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
124         assert((z = x - y) <= x);
125     }
126 
127     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
128         z = x * y;
129         assert(x == 0 || z / x == y);
130     }
131 
132     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
133         z = x / y;
134     }
135 
136     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
137         return x <= y ? x : y;
138     }
139     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
140         return x >= y ? x : y;
141     }
142 
143     /*
144     uint128 functions (h is for half)
145      */
146 
147 
148     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
149         assert((z = x + y) >= x);
150     }
151 
152     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
153         assert((z = x - y) <= x);
154     }
155 
156     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
157         z = x * y;
158         assert(x == 0 || z / x == y);
159     }
160 
161     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
162         z = x / y;
163     }
164 
165     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
166         return x <= y ? x : y;
167     }
168     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
169         return x >= y ? x : y;
170     }
171 
172 
173     /*
174     int256 functions
175      */
176 
177     function imin(int256 x, int256 y) constant internal returns (int256 z) {
178         return x <= y ? x : y;
179     }
180     function imax(int256 x, int256 y) constant internal returns (int256 z) {
181         return x >= y ? x : y;
182     }
183 
184     /*
185     WAD math
186      */
187 
188     uint128 constant WAD = 10 ** 18;
189 
190     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
191         return hadd(x, y);
192     }
193 
194     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
195         return hsub(x, y);
196     }
197 
198     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
199         z = cast((uint256(x) * y + WAD / 2) / WAD);
200     }
201 
202     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
203         z = cast((uint256(x) * WAD + y / 2) / y);
204     }
205 
206     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
207         return hmin(x, y);
208     }
209     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
210         return hmax(x, y);
211     }
212 
213     /*
214     RAY math
215      */
216 
217     uint128 constant RAY = 10 ** 27;
218 
219     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
220         return hadd(x, y);
221     }
222 
223     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
224         return hsub(x, y);
225     }
226 
227     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
228         z = cast((uint256(x) * y + RAY / 2) / RAY);
229     }
230 
231     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
232         z = cast((uint256(x) * RAY + y / 2) / y);
233     }
234 
235     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
236         // This famous algorithm is called "exponentiation by squaring"
237         // and calculates x^n with x as fixed-point and n as regular unsigned.
238         //
239         // It's O(log n), instead of O(n) for naive repeated multiplication.
240         //
241         // These facts are why it works:
242         //
243         //  If n is even, then x^n = (x^2)^(n/2).
244         //  If n is odd,  then x^n = x * x^(n-1),
245         //   and applying the equation for even x gives
246         //    x^n = x * (x^2)^((n-1) / 2).
247         //
248         //  Also, EVM division is flooring and
249         //    floor[(n-1) / 2] = floor[n / 2].
250 
251         z = n % 2 != 0 ? x : RAY;
252 
253         for (n /= 2; n != 0; n /= 2) {
254             x = rmul(x, x);
255 
256             if (n % 2 != 0) {
257                 z = rmul(z, x);
258             }
259         }
260     }
261 
262     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
263         return hmin(x, y);
264     }
265     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
266         return hmax(x, y);
267     }
268 
269     function cast(uint256 x) constant internal returns (uint128 z) {
270         assert((z = uint128(x)) == x);
271     }
272 
273 }
274 
275 
276 contract DSTokenBase is ERC20, DSMath {
277     uint256                                            _supply;
278     mapping (address => uint256)                       _balances;
279     mapping (address => mapping (address => uint256))  _approvals;
280     
281     function DSTokenBase(uint256 supply) {
282         _balances[msg.sender] = supply;
283         _supply = supply;
284     }
285     
286     function totalSupply() constant returns (uint256) {
287         return _supply;
288     }
289     function balanceOf(address src) constant returns (uint256) {
290         return _balances[src];
291     }
292     function allowance(address src, address guy) constant returns (uint256) {
293         return _approvals[src][guy];
294     }
295     
296     function transfer(address dst, uint wad) returns (bool) {
297         assert(_balances[msg.sender] >= wad);
298         
299         _balances[msg.sender] = sub(_balances[msg.sender], wad);
300         _balances[dst] = add(_balances[dst], wad);
301         
302         Transfer(msg.sender, dst, wad);
303         
304         return true;
305     }
306     
307     function transferFrom(address src, address dst, uint wad) returns (bool) {
308         assert(_balances[src] >= wad);
309         assert(_approvals[src][msg.sender] >= wad);
310         
311         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
312         _balances[src] = sub(_balances[src], wad);
313         _balances[dst] = add(_balances[dst], wad);
314         
315         Transfer(src, dst, wad);
316         
317         return true;
318     }
319     
320     function approve(address guy, uint256 wad) returns (bool) {
321         _approvals[msg.sender][guy] = wad;
322         
323         Approval(msg.sender, guy, wad);
324         
325         return true;
326     }
327 
328 }
329 
330 
331 contract DSToken is DSTokenBase(0), DSStop {
332 
333     bytes32  public  symbol;
334     uint256  public  decimals = 18; // standard token precision. override to customize
335 
336     function DSToken(bytes32 symbol_) {
337         symbol = symbol_;
338     }
339 
340     function transfer(address dst, uint wad) stoppable note returns (bool) {
341         return super.transfer(dst, wad);
342     }
343     function transferFrom(
344         address src, address dst, uint wad
345     ) stoppable note returns (bool) {
346         return super.transferFrom(src, dst, wad);
347     }
348     function approve(address guy, uint wad) stoppable note returns (bool) {
349         return super.approve(guy, wad);
350     }
351 
352     function push(address dst, uint128 wad) returns (bool) {
353         return transfer(dst, wad);
354     }
355     function pull(address src, uint128 wad) returns (bool) {
356         return transferFrom(src, msg.sender, wad);
357     }
358 
359     function mint(uint128 wad) auth stoppable note {
360         _balances[msg.sender] = add(_balances[msg.sender], wad);
361         _supply = add(_supply, wad);
362     }
363     function burn(uint128 wad) auth stoppable note {
364         _balances[msg.sender] = sub(_balances[msg.sender], wad);
365         _supply = sub(_supply, wad);
366     }
367 
368     // Optional token name
369 
370     bytes32   public  name = "";
371     
372     function setName(bytes32 name_) auth {
373         name = name_;
374     }
375 
376 }