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
26 contract ERC20 {
27     function totalSupply() constant returns (uint supply);
28     function balanceOf( address who ) constant returns (uint value);
29     function allowance( address owner, address spender ) constant returns (uint _allowance);
30 
31     function transfer( address to, uint value) returns (bool ok);
32     function transferFrom( address from, address to, uint value) returns (bool ok);
33     function approve( address spender, uint value ) returns (bool ok);
34 
35     event Transfer( address indexed from, address indexed to, uint value);
36     event Approval( address indexed owner, address indexed spender, uint value);
37 }
38 
39 contract DSAuthority {
40     function canCall(
41         address src, address dst, bytes4 sig
42     ) constant returns (bool);
43 }
44 
45 contract DSAuthEvents {
46     event LogSetAuthority (address indexed authority);
47     event LogSetOwner     (address indexed owner);
48 }
49 
50 contract DSAuth is DSAuthEvents {
51     DSAuthority  public  authority;
52     address      public  owner;
53 
54     function DSAuth() {
55         owner = msg.sender;
56         LogSetOwner(msg.sender);
57     }
58 
59     function setOwner(address owner_)
60         auth
61     {
62         owner = owner_;
63         LogSetOwner(owner);
64     }
65 
66     function setAuthority(DSAuthority authority_)
67         auth
68     {
69         authority = authority_;
70         LogSetAuthority(authority);
71     }
72 
73     modifier auth {
74         assert(isAuthorized(msg.sender, msg.sig));
75         _;
76     }
77 
78     modifier authorized(bytes4 sig) {
79         assert(isAuthorized(msg.sender, sig));
80         _;
81     }
82 
83     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
84         if (src == address(this)) {
85             return true;
86         } else if (src == owner) {
87             return true;
88         } else if (authority == DSAuthority(0)) {
89             return false;
90         } else {
91             return authority.canCall(src, this, sig);
92         }
93     }
94 
95     function assert(bool x) internal {
96         if (!x) throw;
97     }
98 }
99 
100 contract DSExec {
101     function tryExec( address target, bytes calldata, uint value)
102              internal
103              returns (bool call_ret)
104     {
105         return target.call.value(value)(calldata);
106     }
107     function exec( address target, bytes calldata, uint value)
108              internal
109     {
110         if(!tryExec(target, calldata, value)) {
111             throw;
112         }
113     }
114 
115     // Convenience aliases
116     function exec( address t, bytes c )
117         internal
118     {
119         exec(t, c, 0);
120     }
121     function exec( address t, uint256 v )
122         internal
123     {
124         bytes memory c; exec(t, c, v);
125     }
126     function tryExec( address t, bytes c )
127         internal
128         returns (bool)
129     {
130         return tryExec(t, c, 0);
131     }
132     function tryExec( address t, uint256 v )
133         internal
134         returns (bool)
135     {
136         bytes memory c; return tryExec(t, c, v);
137     }
138 }
139 
140 contract DSMath {
141     
142     /*
143     standard uint256 functions
144      */
145 
146     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
147         assert((z = x + y) >= x);
148     }
149 
150     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
151         assert((z = x - y) <= x);
152     }
153 
154     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
155         assert((z = x * y) >= x);
156     }
157 
158     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
159         z = x / y;
160     }
161 
162     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
163         return x <= y ? x : y;
164     }
165     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
166         return x >= y ? x : y;
167     }
168 
169     /*
170     uint128 functions (h is for half)
171      */
172 
173 
174     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
175         assert((z = x + y) >= x);
176     }
177 
178     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
179         assert((z = x - y) <= x);
180     }
181 
182     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
183         assert((z = x * y) >= x);
184     }
185 
186     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
187         z = x / y;
188     }
189 
190     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
191         return x <= y ? x : y;
192     }
193     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
194         return x >= y ? x : y;
195     }
196 
197 
198     /*
199     int256 functions
200      */
201 
202     function imin(int256 x, int256 y) constant internal returns (int256 z) {
203         return x <= y ? x : y;
204     }
205     function imax(int256 x, int256 y) constant internal returns (int256 z) {
206         return x >= y ? x : y;
207     }
208 
209     /*
210     WAD math
211      */
212 
213     uint128 constant WAD = 10 ** 18;
214 
215     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
216         return hadd(x, y);
217     }
218 
219     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
220         return hsub(x, y);
221     }
222 
223     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
224         z = cast((uint256(x) * y + WAD / 2) / WAD);
225     }
226 
227     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
228         z = cast((uint256(x) * WAD + y / 2) / y);
229     }
230 
231     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
232         return hmin(x, y);
233     }
234     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
235         return hmax(x, y);
236     }
237 
238     /*
239     RAY math
240      */
241 
242     uint128 constant RAY = 10 ** 27;
243 
244     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
245         return hadd(x, y);
246     }
247 
248     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
249         return hsub(x, y);
250     }
251 
252     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
253         z = cast((uint256(x) * y + RAY / 2) / RAY);
254     }
255 
256     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
257         z = cast((uint256(x) * RAY + y / 2) / y);
258     }
259 
260     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
261         // This famous algorithm is called "exponentiation by squaring"
262         // and calculates x^n with x as fixed-point and n as regular unsigned.
263         //
264         // It's O(log n), instead of O(n) for naive repeated multiplication.
265         //
266         // These facts are why it works:
267         //
268         //  If n is even, then x^n = (x^2)^(n/2).
269         //  If n is odd,  then x^n = x * x^(n-1),
270         //   and applying the equation for even x gives
271         //    x^n = x * (x^2)^((n-1) / 2).
272         //
273         //  Also, EVM division is flooring and
274         //    floor[(n-1) / 2] = floor[n / 2].
275 
276         z = n % 2 != 0 ? x : RAY;
277 
278         for (n /= 2; n != 0; n /= 2) {
279             x = rmul(x, x);
280 
281             if (n % 2 != 0) {
282                 z = rmul(z, x);
283             }
284         }
285     }
286 
287     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
288         return hmin(x, y);
289     }
290     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
291         return hmax(x, y);
292     }
293 
294     function cast(uint256 x) constant internal returns (uint128 z) {
295         assert((z = uint128(x)) == x);
296     }
297 
298 }
299 
300 contract DSStop is DSAuth, DSNote {
301 
302     bool public stopped;
303 
304     modifier stoppable {
305         assert (!stopped);
306         _;
307     }
308     function stop() auth note {
309         stopped = true;
310     }
311     function start() auth note {
312         stopped = false;
313     }
314 
315 }
316 
317 contract DSTokenBase is ERC20, DSMath {
318     uint256                                            _supply;
319     mapping (address => uint256)                       _balances;
320     mapping (address => mapping (address => uint256))  _approvals;
321     
322     function DSTokenBase(uint256 supply) {
323         _balances[msg.sender] = supply;
324         _supply = supply;
325     }
326     
327     function totalSupply() constant returns (uint256) {
328         return _supply;
329     }
330     function balanceOf(address src) constant returns (uint256) {
331         return _balances[src];
332     }
333     function allowance(address src, address guy) constant returns (uint256) {
334         return _approvals[src][guy];
335     }
336     
337     function transfer(address dst, uint wad) returns (bool) {
338         assert(_balances[msg.sender] >= wad);
339         
340         _balances[msg.sender] = sub(_balances[msg.sender], wad);
341         _balances[dst] = add(_balances[dst], wad);
342         
343         Transfer(msg.sender, dst, wad);
344         
345         return true;
346     }
347     
348     function transferFrom(address src, address dst, uint wad) returns (bool) {
349         assert(_balances[src] >= wad);
350         assert(_approvals[src][msg.sender] >= wad);
351         
352         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
353         _balances[src] = sub(_balances[src], wad);
354         _balances[dst] = add(_balances[dst], wad);
355         
356         Transfer(src, dst, wad);
357         
358         return true;
359     }
360     
361     function approve(address guy, uint256 wad) returns (bool) {
362         _approvals[msg.sender][guy] = wad;
363         
364         Approval(msg.sender, guy, wad);
365         
366         return true;
367     }
368 
369 }
370 
371 contract DSToken is DSTokenBase(0), DSStop {
372 
373     bytes32  public  symbol;
374     uint256  public  decimals = 18; // standard token precision. override to customize
375 
376     function DSToken(bytes32 symbol_) {
377         symbol = symbol_;
378     }
379 
380     function transfer(address dst, uint wad) stoppable note returns (bool) {
381         return super.transfer(dst, wad);
382     }
383     function transferFrom(
384         address src, address dst, uint wad
385     ) stoppable note returns (bool) {
386         return super.transferFrom(src, dst, wad);
387     }
388     function approve(address guy, uint wad) stoppable note returns (bool) {
389         return super.approve(guy, wad);
390     }
391 
392     function push(address dst, uint128 wad) returns (bool) {
393         return transfer(dst, wad);
394     }
395     function pull(address src, uint128 wad) returns (bool) {
396         return transferFrom(src, msg.sender, wad);
397     }
398 
399     function mint(uint128 wad) auth stoppable note {
400         _balances[msg.sender] = add(_balances[msg.sender], wad);
401         _supply = add(_supply, wad);
402     }
403     function burn(uint128 wad) auth stoppable note {
404         _balances[msg.sender] = sub(_balances[msg.sender], wad);
405         _supply = sub(_supply, wad);
406     }
407 
408     // Optional token name
409 
410     bytes32   public  name = "";
411     
412     function setName(bytes32 name_) auth {
413         name = name_;
414     }
415 
416 }
417 
418 contract EOSSale is DSAuth, DSExec, DSMath {
419     DSToken  public  EOS;                  // The EOS token itself
420     uint128  public  totalSupply;          // Total EOS amount created
421     uint128  public  foundersAllocation;   // Amount given to founders
422     string   public  foundersKey;          // Public key of founders
423 
424     uint     public  openTime;             // Time of window 0 opening
425     uint     public  createFirstDay;       // Tokens sold in window 0
426 
427     uint     public  startTime;            // Time of window 1 opening
428     uint     public  numberOfDays;         // Number of windows after 0
429     uint     public  createPerDay;         // Tokens sold in each window
430 
431     mapping (uint => uint)                       public  dailyTotals;
432     mapping (uint => mapping (address => uint))  public  userBuys;
433     mapping (uint => mapping (address => bool))  public  claimed;
434     mapping (address => string)                  public  keys;
435 
436     event LogBuy      (uint window, address user, uint amount);
437     event LogClaim    (uint window, address user, uint amount);
438     event LogRegister (address user, string key);
439     event LogCollect  (uint amount);
440     event LogFreeze   ();
441 
442     function EOSSale(
443         uint     _numberOfDays,
444         uint128  _totalSupply,
445         uint     _openTime,
446         uint     _startTime,
447         uint128  _foundersAllocation,
448         string   _foundersKey
449     ) {
450         numberOfDays       = _numberOfDays;
451         totalSupply        = _totalSupply;
452         openTime           = _openTime;
453         startTime          = _startTime;
454         foundersAllocation = _foundersAllocation;
455         foundersKey        = _foundersKey;
456 
457         createFirstDay = wmul(totalSupply, 0.2 ether);
458         createPerDay = div(
459             sub(sub(totalSupply, foundersAllocation), createFirstDay),
460             numberOfDays
461         );
462 
463         assert(numberOfDays > 0);
464         assert(totalSupply > foundersAllocation);
465         assert(openTime < startTime);
466     }
467 
468     function initialize(DSToken eos) auth {
469         assert(address(EOS) == address(0));
470         assert(eos.owner() == address(this));
471         assert(eos.authority() == DSAuthority(0));
472         assert(eos.totalSupply() == 0);
473 
474         EOS = eos;
475         EOS.mint(totalSupply);
476 
477         // Address 0xb1 is provably non-transferrable
478         EOS.push(0xb1, foundersAllocation);
479         keys[0xb1] = foundersKey;
480         LogRegister(0xb1, foundersKey);
481     }
482 
483     function time() constant returns (uint) {
484         return block.timestamp;
485     }
486 
487     function today() constant returns (uint) {
488         return dayFor(time());
489     }
490 
491     // Each window is 23 hours long so that end-of-window rotates
492     // around the clock for all timezones.
493     function dayFor(uint timestamp) constant returns (uint) {
494         return timestamp < startTime
495             ? 0
496             : sub(timestamp, startTime) / 23 hours + 1;
497     }
498 
499     function createOnDay(uint day) constant returns (uint) {
500         return day == 0 ? createFirstDay : createPerDay;
501     }
502 
503     // This method provides the buyer some protections regarding which
504     // day the buy order is submitted and the maximum price prior to
505     // applying this payment that will be allowed.
506     function buyWithLimit(uint day, uint limit) payable {
507         assert(time() >= openTime && today() <= numberOfDays);
508         assert(msg.value >= 0.01 ether);
509 
510         assert(day >= today());
511         assert(day <= numberOfDays);
512 
513         userBuys[day][msg.sender] += msg.value;
514         dailyTotals[day] += msg.value;
515 
516         if (limit != 0) {
517             assert(dailyTotals[day] <= limit);
518         }
519 
520         LogBuy(day, msg.sender, msg.value);
521     }
522 
523     function buy() payable {
524        buyWithLimit(today(), 0);
525     }
526 
527     function () payable {
528        buy();
529     }
530 
531     function claim(uint day) {
532         assert(today() > day);
533 
534         if (claimed[day][msg.sender] || dailyTotals[day] == 0) {
535             return;
536         }
537 
538         // This will have small rounding errors, but the token is
539         // going to be truncated to 8 decimal places or less anyway
540         // when launched on its own chain.
541 
542         var dailyTotal = cast(dailyTotals[day]);
543         var userTotal  = cast(userBuys[day][msg.sender]);
544         var price      = wdiv(cast(createOnDay(day)), dailyTotal);
545         var reward     = wmul(price, userTotal);
546 
547         claimed[day][msg.sender] = true;
548         EOS.push(msg.sender, reward);
549 
550         LogClaim(day, msg.sender, reward);
551     }
552 
553     function claimAll() {
554         for (uint i = 0; i < today(); i++) {
555             claim(i);
556         }
557     }
558 
559     // Value should be a public key.  Read full key import policy.
560     // Manually registering requires a base58
561     // encoded using the STEEM, BTS, or EOS public key format.
562     function register(string key) {
563         assert(today() <=  numberOfDays + 1);
564         assert(bytes(key).length <= 64);
565 
566         keys[msg.sender] = key;
567 
568         LogRegister(msg.sender, key);
569     }
570 
571     // Crowdsale owners can collect ETH any number of times
572     function collect() auth {
573         assert(today() > 0); // Prevent recycling during window 0
574         exec(msg.sender, this.balance);
575         LogCollect(this.balance);
576     }
577 
578     // Anyone can freeze the token 1 day after the sale ends
579     function freeze() {
580         assert(today() > numberOfDays + 1);
581         EOS.stop();
582         LogFreeze();
583     }
584 }