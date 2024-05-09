1 contract Whitelist {
2     address public owner;
3     address public sale;
4 
5     mapping (address => uint) public accepted;
6 
7     function Whitelist() {
8         owner = msg.sender;
9     }
10 
11     // Amount in WEI i.e. amount = 1 means 1 WEI
12     function accept(address a, uint amount) {
13         assert (msg.sender == owner || msg.sender == sale);
14 
15         accepted[a] = amount;
16     }
17 
18     function setSale(address sale_) {
19         assert (msg.sender == owner);
20 
21         sale = sale_;
22     } 
23 }
24 
25 
26 contract DSExec {
27     function tryExec( address target, bytes calldata, uint value)
28              internal
29              returns (bool call_ret)
30     {
31         return target.call.value(value)(calldata);
32     }
33     function exec( address target, bytes calldata, uint value)
34              internal
35     {
36         if(!tryExec(target, calldata, value)) {
37             throw;
38         }
39     }
40 
41     // Convenience aliases
42     function exec( address t, bytes c )
43         internal
44     {
45         exec(t, c, 0);
46     }
47     function exec( address t, uint256 v )
48         internal
49     {
50         bytes memory c; exec(t, c, v);
51     }
52     function tryExec( address t, bytes c )
53         internal
54         returns (bool)
55     {
56         return tryExec(t, c, 0);
57     }
58     function tryExec( address t, uint256 v )
59         internal
60         returns (bool)
61     {
62         bytes memory c; return tryExec(t, c, v);
63     }
64 }
65 
66 
67 
68 contract DSAuthority {
69     function canCall(
70         address src, address dst, bytes4 sig
71     ) constant returns (bool);
72 }
73 
74 contract DSAuthEvents {
75     event LogSetAuthority (address indexed authority);
76     event LogSetOwner     (address indexed owner);
77 }
78 
79 contract DSAuth is DSAuthEvents {
80     DSAuthority  public  authority;
81     address      public  owner;
82 
83     function DSAuth() {
84         owner = msg.sender;
85         LogSetOwner(msg.sender);
86     }
87 
88     function setOwner(address owner_)
89         auth
90     {
91         owner = owner_;
92         LogSetOwner(owner);
93     }
94 
95     function setAuthority(DSAuthority authority_)
96         auth
97     {
98         authority = authority_;
99         LogSetAuthority(authority);
100     }
101 
102     modifier auth {
103         assert(isAuthorized(msg.sender, msg.sig));
104         _;
105     }
106 
107     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
108         if (src == address(this)) {
109             return true;
110         } else if (src == owner) {
111             return true;
112         } else if (authority == DSAuthority(0)) {
113             return false;
114         } else {
115             return authority.canCall(src, this, sig);
116         }
117     }
118 
119     function assert(bool x) internal {
120         if (!x) throw;
121     }
122 }
123 
124 
125 contract DSNote {
126     event LogNote(
127         bytes4   indexed  sig,
128         address  indexed  guy,
129         bytes32  indexed  foo,
130         bytes32  indexed  bar,
131 	uint	 	  wad,
132         bytes             fax
133     ) anonymous;
134 
135     modifier note {
136         bytes32 foo;
137         bytes32 bar;
138 
139         assembly {
140             foo := calldataload(4)
141             bar := calldataload(36)
142         }
143 
144         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
145 
146         _;
147     }
148 }
149 
150 
151 
152 contract DSMath {
153     
154     /*
155     standard uint256 functions
156      */
157 
158     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
159         assert((z = x + y) >= x);
160     }
161 
162     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
163         assert((z = x - y) <= x);
164     }
165 
166     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
167         z = x * y;
168         assert(x == 0 || z / x == y);
169     }
170 
171     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
172         z = x / y;
173     }
174 
175     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
176         return x <= y ? x : y;
177     }
178     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
179         return x >= y ? x : y;
180     }
181 
182     /*
183     uint128 functions (h is for half)
184      */
185 
186 
187     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
188         assert((z = x + y) >= x);
189     }
190 
191     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
192         assert((z = x - y) <= x);
193     }
194 
195     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
196         z = x * y;
197         assert(x == 0 || z / x == y);
198     }
199 
200     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
201         z = x / y;
202     }
203 
204     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
205         return x <= y ? x : y;
206     }
207     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
208         return x >= y ? x : y;
209     }
210 
211 
212     /*
213     int256 functions
214      */
215 
216     function imin(int256 x, int256 y) constant internal returns (int256 z) {
217         return x <= y ? x : y;
218     }
219     function imax(int256 x, int256 y) constant internal returns (int256 z) {
220         return x >= y ? x : y;
221     }
222 
223     /*
224     WAD math
225      */
226 
227     uint128 constant WAD = 10 ** 18;
228 
229     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
230         return hadd(x, y);
231     }
232 
233     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
234         return hsub(x, y);
235     }
236 
237     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
238         z = cast((uint256(x) * y + WAD / 2) / WAD);
239     }
240 
241     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
242         z = cast((uint256(x) * WAD + y / 2) / y);
243     }
244 
245     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
246         return hmin(x, y);
247     }
248     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
249         return hmax(x, y);
250     }
251 
252     /*
253     RAY math
254      */
255 
256     uint128 constant RAY = 10 ** 27;
257 
258     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
259         return hadd(x, y);
260     }
261 
262     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
263         return hsub(x, y);
264     }
265 
266     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
267         z = cast((uint256(x) * y + RAY / 2) / RAY);
268     }
269 
270     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
271         z = cast((uint256(x) * RAY + y / 2) / y);
272     }
273 
274     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
275         // This famous algorithm is called "exponentiation by squaring"
276         // and calculates x^n with x as fixed-point and n as regular unsigned.
277         //
278         // It's O(log n), instead of O(n) for naive repeated multiplication.
279         //
280         // These facts are why it works:
281         //
282         //  If n is even, then x^n = (x^2)^(n/2).
283         //  If n is odd,  then x^n = x * x^(n-1),
284         //   and applying the equation for even x gives
285         //    x^n = x * (x^2)^((n-1) / 2).
286         //
287         //  Also, EVM division is flooring and
288         //    floor[(n-1) / 2] = floor[n / 2].
289 
290         z = n % 2 != 0 ? x : RAY;
291 
292         for (n /= 2; n != 0; n /= 2) {
293             x = rmul(x, x);
294 
295             if (n % 2 != 0) {
296                 z = rmul(z, x);
297             }
298         }
299     }
300 
301     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
302         return hmin(x, y);
303     }
304     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
305         return hmax(x, y);
306     }
307 
308     function cast(uint256 x) constant internal returns (uint128 z) {
309         assert((z = uint128(x)) == x);
310     }
311 
312 }
313 
314 
315 contract DSStop is DSAuth, DSNote {
316 
317     bool public stopped;
318 
319     modifier stoppable {
320         assert (!stopped);
321         _;
322     }
323     function stop() auth note {
324         stopped = true;
325     }
326     function start() auth note {
327         stopped = false;
328     }
329 
330 }
331 
332 contract ERC20 {
333     function totalSupply() constant returns (uint supply);
334     function balanceOf( address who ) constant returns (uint value);
335     function allowance( address owner, address spender ) constant returns (uint _allowance);
336 
337     function transfer( address to, uint value) returns (bool ok);
338     function transferFrom( address from, address to, uint value) returns (bool ok);
339     function approve( address spender, uint value ) returns (bool ok);
340 
341     event Transfer( address indexed from, address indexed to, uint value);
342     event Approval( address indexed owner, address indexed spender, uint value);
343 }
344 
345 contract DSTokenBase is ERC20, DSMath {
346     uint256                                            _supply;
347     mapping (address => uint256)                       _balances;
348     mapping (address => mapping (address => uint256))  _approvals;
349     
350     function DSTokenBase(uint256 supply) {
351         _balances[msg.sender] = supply;
352         _supply = supply;
353     }
354     
355     function totalSupply() constant returns (uint256) {
356         return _supply;
357     }
358     function balanceOf(address src) constant returns (uint256) {
359         return _balances[src];
360     }
361     function allowance(address src, address guy) constant returns (uint256) {
362         return _approvals[src][guy];
363     }
364     
365     function transfer(address dst, uint wad) returns (bool) {
366         assert(_balances[msg.sender] >= wad);
367         
368         _balances[msg.sender] = sub(_balances[msg.sender], wad);
369         _balances[dst] = add(_balances[dst], wad);
370         
371         Transfer(msg.sender, dst, wad);
372         
373         return true;
374     }
375     
376     function transferFrom(address src, address dst, uint wad) returns (bool) {
377         assert(_balances[src] >= wad);
378         assert(_approvals[src][msg.sender] >= wad);
379         
380         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
381         _balances[src] = sub(_balances[src], wad);
382         _balances[dst] = add(_balances[dst], wad);
383         
384         Transfer(src, dst, wad);
385         
386         return true;
387     }
388     
389     function approve(address guy, uint256 wad) returns (bool) {
390         _approvals[msg.sender][guy] = wad;
391         
392         Approval(msg.sender, guy, wad);
393         
394         return true;
395     }
396 
397 }
398 
399 
400 contract DSToken is DSTokenBase(0), DSStop {
401 
402     bytes32  public  symbol;
403     uint256  public  decimals = 18; // standard token precision. override to customize
404 
405     function DSToken(bytes32 symbol_) {
406         symbol = symbol_;
407     }
408 
409     function transfer(address dst, uint wad) stoppable note returns (bool) {
410         return super.transfer(dst, wad);
411     }
412     function transferFrom(
413         address src, address dst, uint wad
414     ) stoppable note returns (bool) {
415         return super.transferFrom(src, dst, wad);
416     }
417     function approve(address guy, uint wad) stoppable note returns (bool) {
418         return super.approve(guy, wad);
419     }
420 
421     function push(address dst, uint128 wad) returns (bool) {
422         return transfer(dst, wad);
423     }
424     function pull(address src, uint128 wad) returns (bool) {
425         return transferFrom(src, msg.sender, wad);
426     }
427 
428     function mint(uint128 wad) auth stoppable note {
429         _balances[msg.sender] = add(_balances[msg.sender], wad);
430         _supply = add(_supply, wad);
431     }
432     function burn(uint128 wad) auth stoppable note {
433         _balances[msg.sender] = sub(_balances[msg.sender], wad);
434         _supply = sub(_supply, wad);
435     }
436 
437     // Optional token name
438 
439     bytes32   public  name = "";
440     
441     function setName(bytes32 name_) auth {
442         name = name_;
443     }
444 
445 }
446 
447 
448 
449 contract AVTSale is DSMath, DSNote, DSExec {
450     Whitelist public whitelist;
451     DSToken public avt;
452 
453     // AVT PRICES (ETH/AVT)
454     uint public constant PRIVATE_SALE_PRICE = 110;
455     uint public constant WHITELIST_SALE_PRICE = 92;
456     uint public constant PUBLIC_SALE_PRICE = 92;
457 
458     uint128 public constant CROWDSALE_SUPPLY = 10000000 ether;
459     uint public constant LIQUID_TOKENS = 2500000 ether;
460     uint public constant ILLIQUID_TOKENS = 1500000 ether;
461 
462     // PURCHASE LIMITS
463     uint public constant PRIVATE_SALE_LIMIT = 3000000 ether;
464     uint public constant WHITELIST_SALE_LIMIT = 5000000 ether;
465     uint public constant PUBLIC_SALE_LIMIT = 6000000 ether;
466 
467     uint public privateStart;
468     uint public whitelistStart;
469     uint public publicStart;
470     uint public publicEnd;
471 
472     address public aventus;
473     address public privateBuyer;
474 
475     uint public sold;
476 
477 
478     function AVTSale(uint privateStart_, address aventus_, address privateBuyer_, Whitelist whitelist_) {
479         avt = new DSToken("AVT");
480         
481         aventus = aventus_;
482         privateBuyer = privateBuyer_;
483         whitelist = whitelist_;
484         
485         privateStart = privateStart_;
486         whitelistStart = privateStart + 2 days;
487         publicStart = whitelistStart + 1 days;
488         publicEnd = publicStart + 7 days;
489 
490         avt.mint(CROWDSALE_SUPPLY);
491         avt.setOwner(aventus);
492         avt.transfer(aventus, LIQUID_TOKENS);
493     }
494 
495     // overrideable for easy testing
496     function time() constant returns (uint) {
497         return now;
498     }
499 
500     function() payable note {
501         var (rate, limit) = getRateLimit();
502 
503         uint prize = mul(msg.value, rate);
504 
505         assert(add(sold, prize) <= limit);
506 
507         sold = add(sold, prize);
508 
509         avt.transfer(msg.sender, prize);
510         exec(aventus, msg.value); // send the ETH to multisig
511     }
512 
513     function getRateLimit() private constant returns (uint, uint) {
514         uint t = time();
515 
516         if (t >= privateStart && t < whitelistStart) {
517             assert (msg.sender == privateBuyer);
518 
519             return (PRIVATE_SALE_PRICE, PRIVATE_SALE_LIMIT);
520         }
521         else if (t >= whitelistStart && t < publicStart) {
522             uint allowance = whitelist.accepted(msg.sender);
523 
524             assert (allowance >= msg.value);
525 
526             whitelist.accept(msg.sender, allowance - msg.value);
527 
528             return (WHITELIST_SALE_PRICE, WHITELIST_SALE_LIMIT);
529         }
530         else if (t >= publicStart && t < publicEnd)
531             return (PUBLIC_SALE_PRICE, PUBLIC_SALE_LIMIT);
532 
533         throw;
534     }
535 
536     function claim() {
537         assert(time() >= publicStart + 1 years);
538 
539         avt.transfer(aventus, ILLIQUID_TOKENS);
540     }
541 }