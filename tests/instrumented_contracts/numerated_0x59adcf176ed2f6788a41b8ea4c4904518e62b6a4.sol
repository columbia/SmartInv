1 pragma solidity ^0.4.10;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) constant returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         auth
25     {
26         owner = owner_;
27         LogSetOwner(owner);
28     }
29 
30     function setAuthority(DSAuthority authority_)
31         auth
32     {
33         authority = authority_;
34         LogSetAuthority(authority);
35     }
36 
37     modifier auth {
38         assert(isAuthorized(msg.sender, msg.sig));
39         _;
40     }
41 
42     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
43         if (src == address(this)) {
44             return true;
45         } else if (src == owner) {
46             return true;
47         } else if (authority == DSAuthority(0)) {
48             return false;
49         } else {
50             return authority.canCall(src, this, sig);
51         }
52     }
53 
54     function assert(bool x) internal {
55         if (!x) throw;
56     }
57 }
58 
59 contract DSNote {
60     event LogNote(
61         bytes4   indexed  sig,
62         address  indexed  guy,
63         bytes32  indexed  foo,
64         bytes32  indexed  bar,
65 	uint	 	  wad,
66         bytes             fax
67     ) anonymous;
68 
69     modifier note {
70         bytes32 foo;
71         bytes32 bar;
72 
73         assembly {
74             foo := calldataload(4)
75             bar := calldataload(36)
76         }
77 
78         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
79 
80         _;
81     }
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
92     function stop() auth note {
93         stopped = true;
94     }
95     function start() auth note {
96         stopped = false;
97     }
98 
99 }
100 
101 contract ERC20 {
102     function totalSupply() constant returns (uint supply);
103     function balanceOf( address who ) constant returns (uint value);
104     function allowance( address owner, address spender ) constant returns (uint _allowance);
105 
106     function transfer( address to, uint value) returns (bool ok);
107     function transferFrom( address from, address to, uint value) returns (bool ok);
108     function approve( address spender, uint value ) returns (bool ok);
109 
110     event Transfer( address indexed from, address indexed to, uint value);
111     event Approval( address indexed owner, address indexed spender, uint value);
112 }
113 
114 contract DSMath {
115     
116     /*
117     standard uint256 functions
118      */
119 
120     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
121         assert((z = x + y) >= x);
122     }
123 
124     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
125         assert((z = x - y) <= x);
126     }
127 
128     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
129         z = x * y;
130         assert(x == 0 || z / x == y);
131     }
132 
133     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
134         z = x / y;
135     }
136 
137     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
138         return x <= y ? x : y;
139     }
140     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
141         return x >= y ? x : y;
142     }
143 
144     /*
145     uint128 functions (h is for half)
146      */
147 
148 
149     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
150         assert((z = x + y) >= x);
151     }
152 
153     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
154         assert((z = x - y) <= x);
155     }
156 
157     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
158         z = x * y;
159         assert(x == 0 || z / x == y);
160     }
161 
162     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
163         z = x / y;
164     }
165 
166     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
167         return x <= y ? x : y;
168     }
169     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
170         return x >= y ? x : y;
171     }
172 
173 
174     /*
175     int256 functions
176      */
177 
178     function imin(int256 x, int256 y) constant internal returns (int256 z) {
179         return x <= y ? x : y;
180     }
181     function imax(int256 x, int256 y) constant internal returns (int256 z) {
182         return x >= y ? x : y;
183     }
184 
185     /*
186     WAD math
187      */
188 
189     uint128 constant WAD = 10 ** 18;
190 
191     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
192         return hadd(x, y);
193     }
194 
195     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
196         return hsub(x, y);
197     }
198 
199     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
200         z = cast((uint256(x) * y + WAD / 2) / WAD);
201     }
202 
203     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
204         z = cast((uint256(x) * WAD + y / 2) / y);
205     }
206 
207     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
208         return hmin(x, y);
209     }
210     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
211         return hmax(x, y);
212     }
213 
214     /*
215     RAY math
216      */
217 
218     uint128 constant RAY = 10 ** 27;
219 
220     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
221         return hadd(x, y);
222     }
223 
224     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
225         return hsub(x, y);
226     }
227 
228     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
229         z = cast((uint256(x) * y + RAY / 2) / RAY);
230     }
231 
232     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
233         z = cast((uint256(x) * RAY + y / 2) / y);
234     }
235 
236     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
237         // This famous algorithm is called "exponentiation by squaring"
238         // and calculates x^n with x as fixed-point and n as regular unsigned.
239         //
240         // It's O(log n), instead of O(n) for naive repeated multiplication.
241         //
242         // These facts are why it works:
243         //
244         //  If n is even, then x^n = (x^2)^(n/2).
245         //  If n is odd,  then x^n = x * x^(n-1),
246         //   and applying the equation for even x gives
247         //    x^n = x * (x^2)^((n-1) / 2).
248         //
249         //  Also, EVM division is flooring and
250         //    floor[(n-1) / 2] = floor[n / 2].
251 
252         z = n % 2 != 0 ? x : RAY;
253 
254         for (n /= 2; n != 0; n /= 2) {
255             x = rmul(x, x);
256 
257             if (n % 2 != 0) {
258                 z = rmul(z, x);
259             }
260         }
261     }
262 
263     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
264         return hmin(x, y);
265     }
266     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
267         return hmax(x, y);
268     }
269 
270     function cast(uint256 x) constant internal returns (uint128 z) {
271         assert((z = uint128(x)) == x);
272     }
273 
274 }
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
330 contract DSToken is DSTokenBase(0), DSStop {
331 
332     bytes32  public  symbol;
333     uint256  public  decimals = 18; // standard token precision. override to customize
334 
335     function DSToken(bytes32 symbol_) {
336         symbol = symbol_;
337     }
338 
339     function transfer(address dst, uint wad) stoppable note returns (bool) {
340         return super.transfer(dst, wad);
341     }
342     function transferFrom(
343         address src, address dst, uint wad
344     ) stoppable note returns (bool) {
345         return super.transferFrom(src, dst, wad);
346     }
347     function approve(address guy, uint wad) stoppable note returns (bool) {
348         return super.approve(guy, wad);
349     }
350 
351     function push(address dst, uint128 wad) returns (bool) {
352         return transfer(dst, wad);
353     }
354     function pull(address src, uint128 wad) returns (bool) {
355         return transferFrom(src, msg.sender, wad);
356     }
357 
358     function mint(uint128 wad) auth stoppable note {
359         _balances[msg.sender] = add(_balances[msg.sender], wad);
360         _supply = add(_supply, wad);
361     }
362     function burn(uint128 wad) auth stoppable note {
363         _balances[msg.sender] = sub(_balances[msg.sender], wad);
364         _supply = sub(_supply, wad);
365     }
366 
367     // Optional token name
368 
369     bytes32   public  name = "";
370     
371     function setName(bytes32 name_) auth {
372         name = name_;
373     }
374 
375 }