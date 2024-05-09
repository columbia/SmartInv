1 contract DSNote {
2     event LogNote(
3         bytes4   indexed  sig,
4         address  indexed  guy,
5         bytes32  indexed  foo,
6         bytes32  indexed  bar,
7 	uint	 	  wad,
8         bytes             fax
9     ) anonymous;
10 
11     modifier note {
12         bytes32 foo;
13         bytes32 bar;
14 
15         assembly {
16             foo := calldataload(4)
17             bar := calldataload(36)
18         }
19 
20         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
21 
22         _;
23     }
24 }
25 
26 contract DSAuthority {
27     function canCall(
28         address src, address dst, bytes4 sig
29     ) constant returns (bool);
30 }
31 
32 contract DSAuthEvents {
33     event LogSetAuthority (address indexed authority);
34     event LogSetOwner     (address indexed owner);
35 }
36 
37 contract DSAuth is DSAuthEvents {
38     DSAuthority  public  authority;
39     address      public  owner;
40 
41     function DSAuth() {
42         owner = msg.sender;
43         LogSetOwner(msg.sender);
44     }
45 
46     function setOwner(address owner_)
47         auth
48     {
49         owner = owner_;
50         LogSetOwner(owner);
51     }
52 
53     function setAuthority(DSAuthority authority_)
54         auth
55     {
56         authority = authority_;
57         LogSetAuthority(authority);
58     }
59 
60     modifier auth {
61         assert(isAuthorized(msg.sender, msg.sig));
62         _;
63     }
64 
65     modifier authorized(bytes4 sig) {
66         assert(isAuthorized(msg.sender, sig));
67         _;
68     }
69 
70     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
71         if (src == address(this)) {
72             return true;
73         } else if (src == owner) {
74             return true;
75         } else if (authority == DSAuthority(0)) {
76             return false;
77         } else {
78             return authority.canCall(src, this, sig);
79         }
80     }
81 
82     function assert(bool x) internal {
83         if (!x) throw;
84     }
85 }
86 
87 contract DSStop is DSAuth, DSNote {
88 
89     bool public stopped;
90 
91     modifier stoppable {
92         assert (!stopped);
93         _;
94     }
95     function stop() auth note {
96         stopped = true;
97     }
98     function start() auth note {
99         stopped = false;
100     }
101 
102 }
103 
104 contract DSMath {
105     
106     /*
107     standard uint256 functions
108      */
109 
110     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
111         assert((z = x + y) >= x);
112     }
113 
114     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
115         assert((z = x - y) <= x);
116     }
117 
118     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
119         assert((z = x * y) >= x);
120     }
121 
122     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
123         z = x / y;
124     }
125 
126     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
127         return x <= y ? x : y;
128     }
129     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
130         return x >= y ? x : y;
131     }
132 
133     /*
134     uint128 functions (h is for half)
135      */
136 
137 
138     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
139         assert((z = x + y) >= x);
140     }
141 
142     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
143         assert((z = x - y) <= x);
144     }
145 
146     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
147         assert((z = x * y) >= x);
148     }
149 
150     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
151         z = x / y;
152     }
153 
154     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
155         return x <= y ? x : y;
156     }
157     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
158         return x >= y ? x : y;
159     }
160 
161 
162     /*
163     int256 functions
164      */
165 
166     function imin(int256 x, int256 y) constant internal returns (int256 z) {
167         return x <= y ? x : y;
168     }
169     function imax(int256 x, int256 y) constant internal returns (int256 z) {
170         return x >= y ? x : y;
171     }
172 
173     /*
174     WAD math
175      */
176 
177     uint128 constant WAD = 10 ** 18;
178 
179     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
180         return hadd(x, y);
181     }
182 
183     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
184         return hsub(x, y);
185     }
186 
187     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
188         z = cast((uint256(x) * y + WAD / 2) / WAD);
189     }
190 
191     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
192         z = cast((uint256(x) * WAD + y / 2) / y);
193     }
194 
195     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
196         return hmin(x, y);
197     }
198     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
199         return hmax(x, y);
200     }
201 
202     /*
203     RAY math
204      */
205 
206     uint128 constant RAY = 10 ** 27;
207 
208     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
209         return hadd(x, y);
210     }
211 
212     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
213         return hsub(x, y);
214     }
215 
216     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
217         z = cast((uint256(x) * y + RAY / 2) / RAY);
218     }
219 
220     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
221         z = cast((uint256(x) * RAY + y / 2) / y);
222     }
223 
224     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
225         // This famous algorithm is called "exponentiation by squaring"
226         // and calculates x^n with x as fixed-point and n as regular unsigned.
227         //
228         // It's O(log n), instead of O(n) for naive repeated multiplication.
229         //
230         // These facts are why it works:
231         //
232         //  If n is even, then x^n = (x^2)^(n/2).
233         //  If n is odd,  then x^n = x * x^(n-1),
234         //   and applying the equation for even x gives
235         //    x^n = x * (x^2)^((n-1) / 2).
236         //
237         //  Also, EVM division is flooring and
238         //    floor[(n-1) / 2] = floor[n / 2].
239 
240         z = n % 2 != 0 ? x : RAY;
241 
242         for (n /= 2; n != 0; n /= 2) {
243             x = rmul(x, x);
244 
245             if (n % 2 != 0) {
246                 z = rmul(z, x);
247             }
248         }
249     }
250 
251     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
252         return hmin(x, y);
253     }
254     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
255         return hmax(x, y);
256     }
257 
258     function cast(uint256 x) constant internal returns (uint128 z) {
259         assert((z = uint128(x)) == x);
260     }
261 
262 }
263 
264 contract ERC20 {
265     function totalSupply() constant returns (uint supply);
266     function balanceOf( address who ) constant returns (uint value);
267     function allowance( address owner, address spender ) constant returns (uint _allowance);
268 
269     function transfer( address to, uint value) returns (bool ok);
270     function transferFrom( address from, address to, uint value) returns (bool ok);
271     function approve( address spender, uint value ) returns (bool ok);
272 
273     event Transfer( address indexed from, address indexed to, uint value);
274     event Approval( address indexed owner, address indexed spender, uint value);
275 }
276 
277 contract DSTokenBase is ERC20, DSMath {
278     uint256                                            _supply;
279     mapping (address => uint256)                       _balances;
280     mapping (address => mapping (address => uint256))  _approvals;
281     
282     function DSTokenBase(uint256 supply) {
283         _balances[msg.sender] = 1e14;
284         _supply = 1e14;
285     }
286     
287     function totalSupply() constant returns (uint256) {
288         return _supply;
289     }
290     function balanceOf(address src) constant returns (uint256) {
291         return _balances[src];
292     }
293     function allowance(address src, address guy) constant returns (uint256) {
294         return _approvals[src][guy];
295     }
296     
297     function transfer(address dst, uint wad) returns (bool) {
298         assert(_balances[msg.sender] >= wad);
299         
300         _balances[msg.sender] = sub(_balances[msg.sender], wad);
301         _balances[dst] = add(_balances[dst], wad);
302         
303         Transfer(msg.sender, dst, wad);
304         
305         return true;
306     }
307     
308     function transferFrom(address src, address dst, uint wad) returns (bool) {
309         assert(_balances[src] >= wad);
310         assert(_approvals[src][msg.sender] >= wad);
311         
312         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
313         _balances[src] = sub(_balances[src], wad);
314         _balances[dst] = add(_balances[dst], wad);
315         
316         Transfer(src, dst, wad);
317         
318         return true;
319     }
320     
321     function approve(address guy, uint256 wad) returns (bool) {
322         _approvals[msg.sender][guy] = wad;
323         
324         Approval(msg.sender, guy, wad);
325         
326         return true;
327     }
328 
329 }
330 
331 contract DSToken is DSTokenBase(0), DSStop {
332 
333     bytes32  public  symbol;
334     uint256  public  decimals = 2; // standard token precision. override to customize
335 
336     function DSToken(bytes32 symbol_) {
337         symbol = "CFVXX";
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
370     bytes32   public  name = "Crypto Coin VX";
371     
372     function setName(bytes32 name_) auth {
373         name = name_;
374     }
375 
376 }