1 pragma solidity ^0.4.11;
2 contract DSNote {
3     event LogNote(
4         bytes4   indexed  sig,
5         address  indexed  guy,
6         bytes32  indexed  foo,
7         bytes32  indexed  bar,
8 	uint	 	  wad,
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
21         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
22 
23         _;
24     }
25 }
26 
27 contract ERC20 {
28     function totalSupply() constant returns (uint supply);
29     function balanceOf( address who ) constant returns (uint value);
30     function allowance( address owner, address spender ) constant returns (uint _allowance);
31 
32     function transfer( address to, uint value) returns (bool ok);
33     function transferFrom( address from, address to, uint value) returns (bool ok);
34     function approve( address spender, uint value ) returns (bool ok);
35 
36     event Transfer( address indexed from, address indexed to, uint value);
37     event Approval( address indexed owner, address indexed spender, uint value);
38 }
39 
40 contract DSAuthority {
41     function canCall(
42         address src, address dst, bytes4 sig
43     ) constant returns (bool);
44 }
45 
46 contract DSAuthEvents {
47     event LogSetAuthority (address indexed authority);
48     event LogSetOwner     (address indexed owner);
49 }
50 
51 contract DSAuth is DSAuthEvents {
52     DSAuthority  public  authority;
53     address      public  owner;
54 
55     function DSAuth() {
56         owner = msg.sender;
57         LogSetOwner(msg.sender);
58     }
59 
60     function setOwner(address owner_)
61         auth
62     {
63         owner = owner_;
64         LogSetOwner(owner);
65     }
66 
67     function setAuthority(DSAuthority authority_)
68         auth
69     {
70         authority = authority_;
71         LogSetAuthority(authority);
72     }
73 
74     modifier auth {
75         assert(isAuthorized(msg.sender, msg.sig));
76         _;
77     }
78 
79     modifier authorized(bytes4 sig) {
80         assert(isAuthorized(msg.sender, sig));
81         _;
82     }
83 
84     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
85         if (src == address(this)) {
86             return true;
87         } else if (src == owner) {
88             return true;
89         } else if (authority == DSAuthority(0)) {
90             return false;
91         } else {
92             return authority.canCall(src, this, sig);
93         }
94     }
95 
96     function assert(bool x) internal {
97         if (!x) throw;
98     }
99 }
100 
101 contract DSExec {
102     function tryExec( address target, bytes calldata, uint value)
103              internal
104              returns (bool call_ret)
105     {
106         return target.call.value(value)(calldata);
107     }
108     function exec( address target, bytes calldata, uint value)
109              internal
110     {
111         if(!tryExec(target, calldata, value)) {
112             throw;
113         }
114     }
115 
116     // Convenience aliases
117     function exec( address t, bytes c )
118         internal
119     {
120         exec(t, c, 0);
121     }
122     function exec( address t, uint256 v )
123         internal
124     {
125         bytes memory c; exec(t, c, v);
126     }
127     function tryExec( address t, bytes c )
128         internal
129         returns (bool)
130     {
131         return tryExec(t, c, 0);
132     }
133     function tryExec( address t, uint256 v )
134         internal
135         returns (bool)
136     {
137         bytes memory c; return tryExec(t, c, v);
138     }
139 }
140 
141 contract DSMath {
142     
143     /*
144     standard uint256 functions
145      */
146 
147     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
148         assert((z = x + y) >= x);
149     }
150 
151     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
152         assert((z = x - y) <= x);
153     }
154 
155     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
156         assert((z = x * y) >= x);
157     }
158 
159     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
160         z = x / y;
161     }
162 
163     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
164         return x <= y ? x : y;
165     }
166     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
167         return x >= y ? x : y;
168     }
169 
170     /*
171     uint128 functions (h is for half)
172      */
173 
174 
175     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
176         assert((z = x + y) >= x);
177     }
178 
179     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
180         assert((z = x - y) <= x);
181     }
182 
183     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
184         assert((z = x * y) >= x);
185     }
186 
187     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
188         z = x / y;
189     }
190 
191     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
192         return x <= y ? x : y;
193     }
194     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
195         return x >= y ? x : y;
196     }
197 
198 
199     /*
200     int256 functions
201      */
202 
203     function imin(int256 x, int256 y) constant internal returns (int256 z) {
204         return x <= y ? x : y;
205     }
206     function imax(int256 x, int256 y) constant internal returns (int256 z) {
207         return x >= y ? x : y;
208     }
209 
210     /*
211     WAD math
212      */
213 
214     uint128 constant WAD = 10 ** 18;
215 
216     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
217         return hadd(x, y);
218     }
219 
220     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
221         return hsub(x, y);
222     }
223 
224     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
225         z = cast((uint256(x) * y + WAD / 2) / WAD);
226     }
227 
228     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
229         z = cast((uint256(x) * WAD + y / 2) / y);
230     }
231 
232     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
233         return hmin(x, y);
234     }
235     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
236         return hmax(x, y);
237     }
238 
239     /*
240     RAY math
241      */
242 
243     uint128 constant RAY = 10 ** 27;
244 
245     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
246         return hadd(x, y);
247     }
248 
249     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
250         return hsub(x, y);
251     }
252 
253     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
254         z = cast((uint256(x) * y + RAY / 2) / RAY);
255     }
256 
257     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
258         z = cast((uint256(x) * RAY + y / 2) / y);
259     }
260 
261     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
262         // This famous algorithm is called "exponentiation by squaring"
263         // and calculates x^n with x as fixed-point and n as regular unsigned.
264         //
265         // It's O(log n), instead of O(n) for naive repeated multiplication.
266         //
267         // These facts are why it works:
268         //
269         //  If n is even, then x^n = (x^2)^(n/2).
270         //  If n is odd,  then x^n = x * x^(n-1),
271         //   and applying the equation for even x gives
272         //    x^n = x * (x^2)^((n-1) / 2).
273         //
274         //  Also, EVM division is flooring and
275         //    floor[(n-1) / 2] = floor[n / 2].
276 
277         z = n % 2 != 0 ? x : RAY;
278 
279         for (n /= 2; n != 0; n /= 2) {
280             x = rmul(x, x);
281 
282             if (n % 2 != 0) {
283                 z = rmul(z, x);
284             }
285         }
286     }
287 
288     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
289         return hmin(x, y);
290     }
291     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
292         return hmax(x, y);
293     }
294 
295     function cast(uint256 x) constant internal returns (uint128 z) {
296         assert((z = uint128(x)) == x);
297     }
298 
299 }
300 
301 contract DSStop is DSAuth, DSNote {
302 
303     bool public stopped;
304 
305     modifier stoppable {
306         assert (!stopped);
307         _;
308     }
309     function stop() auth note {
310         stopped = true;
311     }
312     function start() auth note {
313         stopped = false;
314     }
315 
316 }
317 
318 contract DSTokenBase is ERC20, DSMath {
319     uint256                                            _supply;
320     mapping (address => uint256)                       _balances;
321     mapping (address => mapping (address => uint256))  _approvals;
322     
323     function DSTokenBase(uint256 supply) {
324         _balances[msg.sender] = supply;
325         _supply = supply;
326     }
327     
328     function totalSupply() constant returns (uint256) {
329         return _supply;
330     }
331     function balanceOf(address src) constant returns (uint256) {
332         return _balances[src];
333     }
334     function allowance(address src, address guy) constant returns (uint256) {
335         return _approvals[src][guy];
336     }
337     
338     function transfer(address dst, uint wad) returns (bool) {
339         assert(_balances[msg.sender] >= wad);
340         
341         _balances[msg.sender] = sub(_balances[msg.sender], wad);
342         _balances[dst] = add(_balances[dst], wad);
343         
344         Transfer(msg.sender, dst, wad);
345         
346         return true;
347     }
348     
349     function transferFrom(address src, address dst, uint wad) returns (bool) {
350         assert(_balances[src] >= wad);
351         assert(_approvals[src][msg.sender] >= wad);
352         
353         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
354         _balances[src] = sub(_balances[src], wad);
355         _balances[dst] = add(_balances[dst], wad);
356         
357         Transfer(src, dst, wad);
358         
359         return true;
360     }
361     
362     function approve(address guy, uint256 wad) returns (bool) {
363         _approvals[msg.sender][guy] = wad;
364         
365         Approval(msg.sender, guy, wad);
366         
367         return true;
368     }
369 
370 }
371 
372 contract DSToken is DSTokenBase(0), DSStop {
373 
374     bytes32  public  symbol;
375     uint256  public  decimals = 8; // standard token precision. override to customize
376 
377     function DSToken(bytes32 symbol_) {
378         symbol = symbol_;
379     }
380 
381     function transfer(address dst, uint wad) stoppable note returns (bool) {
382         return super.transfer(dst, wad);
383     }
384     function transferFrom(
385         address src, address dst, uint wad
386     ) stoppable note returns (bool) {
387         return super.transferFrom(src, dst, wad);
388     }
389     function approve(address guy, uint wad) stoppable note returns (bool) {
390         return super.approve(guy, wad);
391     }
392 
393     function push(address dst, uint128 wad) returns (bool) {
394         return transfer(dst, wad);
395     }
396     function pull(address src, uint128 wad) returns (bool) {
397         return transferFrom(src, msg.sender, wad);
398     }
399 
400     function mint(uint128 wad) auth stoppable note {
401         _balances[msg.sender] = add(_balances[msg.sender], wad);
402         _supply = add(_supply, wad);
403     }
404     //function burn(uint128 wad) auth stoppable note {
405      //   _balances[msg.sender] = sub(_balances[msg.sender], wad);
406      //   _supply = sub(_supply, wad);
407    // }
408 
409     // Optional token name
410 
411     bytes32   public  name = "";
412     
413     function setName(bytes32 name_) auth {
414         name = name_;
415     }
416 
417 }
418 
419 contract UFCSale is DSAuth, DSExec, DSMath {
420     DSToken  public  UFC;                  // The UFC token itself
421     uint128  public  totalSupply;          // Total UFC amount created
422     uint128  public  foundersAllocation;   // Amount given to founders
423     string   public  foundersKey;          // Public key of founders
424 
425     uint     public  openTime;             // Time of window 0 opening
426     uint     public  createFirstDay;       // Tokens sold in window 0
427     uint public breakTime;
428     uint public totalFirstDay;
429     uint     public  startTime;            // Time of window 1 opening
430     uint     public  numberOfDays;         // Number of windows after 0
431     uint     public  createPerDay;         // Tokens sold in each window
432     bool     public  close;
433     mapping (uint => uint)    public dayindex;
434     mapping (uint=>mapping (uint=>address)) public dayindexuser;
435     mapping (uint => uint)                       public  dailyTotals;
436     mapping (uint => mapping (address => uint))  public  userBuys;
437     mapping (uint => mapping (address => bool))  public  claimed;
438     mapping (address => string)                  public  keys;
439     
440     event LogBuy      (uint window, address user, uint amount);
441     event LogClaim    (uint window, address user, uint amount);
442     event LogRegister (address user, string key);
443     event LogCollect  (uint amount);
444     event LogHelpClaimEnd (bool);
445     event LogFreeze   ();
446 
447     function UFCSale(
448         uint     _numberOfDays,
449         uint128  _totalSupply,
450         uint     _openTime,
451         uint _breakTime,
452         uint     _startTime,
453         uint128  _foundersAllocation,
454         uint128  _firstdaySupplyPrice,
455         uint128  _firstdayTotal,
456         string   _foundersKey
457     ) {
458         numberOfDays       = _numberOfDays;
459         totalSupply        = _totalSupply;
460         openTime           = _openTime;
461         startTime          = _startTime;
462         foundersAllocation = _foundersAllocation;
463         foundersKey        = _foundersKey;
464         breakTime = _breakTime;
465         createFirstDay = _firstdaySupplyPrice;
466         totalFirstDay = _firstdayTotal;
467         close = false;
468         for(uint i = 0;i < numberOfDays;i++){
469             dayindex[i] = 0;
470         }
471         createPerDay = div(
472             sub(sub(totalSupply, foundersAllocation),mul(createFirstDay,totalFirstDay)),
473             numberOfDays
474         );
475 
476         assert(numberOfDays > 0);
477         assert(totalSupply > foundersAllocation);
478         assert(openTime < startTime);
479     }
480 
481     function initialize(DSToken ufc) auth {
482         assert(address(UFC) == address(0));
483         assert(ufc.owner() == address(this));
484         assert(ufc.authority() == DSAuthority(0));
485         assert(ufc.totalSupply() == 0);
486 
487         UFC = ufc;
488         UFC.mint(totalSupply);
489 
490         UFC.push(msg.sender, foundersAllocation);
491         keys[msg.sender] = foundersKey;
492         LogRegister(msg.sender, foundersKey);
493     }
494 
495     function time() constant returns (uint) {
496         return block.timestamp;
497     }
498 
499     function today() constant returns (uint) {
500         return dayFor(time());
501     }
502 
503     // Each window is 23 hours long so that end-of-window rotates
504     // around the clock for all timezones.
505     function dayFor(uint timestamp) constant returns (uint) {
506         return timestamp < startTime
507             ? 0
508             : sub(timestamp, startTime) / 24 hours + 1;
509     }
510 
511     function createOnDay(uint day) constant returns (uint) {
512         return day == 0 ? createFirstDay : createPerDay;
513     }
514 
515     // This method provides the buyer some protections regarding which
516     // day the buy order is submitted and the maximum price prior to
517     // applying this payment that will be allowed.
518     function buyWithLimit(uint day, uint limit) payable {
519         assert(time() >= openTime && today() <= numberOfDays);
520         assert(msg.value >= 0.1 ether);
521         if(time() <= breakTime){
522             day = 0;
523         }
524         if(time() > breakTime && time() < startTime){
525             revert();
526         }
527         assert(day >= today());
528         assert(day <= numberOfDays);
529         if(day == 0){
530             if((userBuys[day][msg.sender] + msg.value) > 100 ether){
531                 revert();
532             }
533             if((dailyTotals[day] + msg.value) > mul(totalFirstDay , 1 ether)){
534                 revert();
535             }
536         }
537         userBuys[day][msg.sender] += msg.value;
538         dailyTotals[day] += msg.value;
539 
540         if (limit != 0) {
541             assert(dailyTotals[day] <= limit);
542         }
543         uint userindex =  dayindex[day];
544         dayindex[day] = userindex+1;
545         dayindexuser[day][userindex] = msg.sender;
546         LogBuy(day, msg.sender, msg.value);
547     }
548 
549     function buy() payable {
550        buyWithLimit(today(), 0);
551     }
552 
553     function () payable {
554        buy();
555     }
556 
557     function claim(uint day) {
558         assert(today() > day);
559 
560         if (claimed[day][msg.sender] || dailyTotals[day] == 0) {
561             return;
562         }
563 
564         // This will have small rounding errors, but the token is
565         // going to be truncated to 8 decimal places or less anyway
566         // when launched on its own chain.
567         
568         var dailyTotal = cast(dailyTotals[day]);
569         var userTotal  = cast(userBuys[day][msg.sender]);
570         var price      = wdiv(cast(createOnDay(day)), dailyTotal);
571         if(day == 0){
572             price = cast(createOnDay(day));
573         }
574         var reward = wmul(price, userTotal);
575 
576         claimed[day][msg.sender] = true;
577         UFC.push(msg.sender, reward);
578 
579         LogClaim(day, msg.sender, reward);
580     }
581 
582     function claimAll() {
583         for (uint i = 0; i < today(); i++) {
584             claim(i);
585         }
586     }
587 
588     // Value should be a public key.  Read full key import policy.
589     // Manually registering requires a base58
590     // encoded using the UFC public key format.
591     function register(string key) {
592         //assert(today() <=  numberOfDays + 1);
593         if(close){
594             revert();
595         }
596         assert(bytes(key).length <= 128);
597 
598         keys[msg.sender] = key;
599 
600         LogRegister(msg.sender, key);
601     }
602 
603     // Crowdsale owners can collect ETH any number of times
604     function collect() auth {
605         //assert(today() > 0); // Prevent recycling during window 0
606         LogCollect(this.balance);
607         exec(msg.sender, this.balance);
608         LogCollect(this.balance);
609     }
610     function close() auth{
611         assert(today() > numberOfDays + 1);
612         UFC.stop();
613         close = true;
614     }
615     function start() auth{
616         assert(today() > numberOfDays + 1);
617         UFC.start();
618         close = false;
619     }
620     function help_claim(uint day,uint start_index,uint limitnum)auth{
621         assert(today() > day);
622         if (dailyTotals[day] == 0 || start_index >= dayindex[day]) {
623             return;
624         }
625         var dailyTotal = cast(dailyTotals[day]);
626         var price      = wdiv(cast(createOnDay(day)), dailyTotal);
627         if(day == 0){
628             price = cast(createOnDay(day));
629         }
630         uint loopLimit = min(dayindex[day],limitnum+start_index);
631         for(uint i = start_index;i <loopLimit;i++){
632 
633             address sender = dayindexuser[day][i];
634             if(claimed[day][sender]){
635                 continue;
636             }
637             
638             var userTotal  = cast(userBuys[day][sender]);
639             var reward     = wmul(price, userTotal);
640         
641             claimed[day][sender] = true;
642             UFC.push(sender, reward);
643             //LogClaim(day,sender, reward);
644         }
645         if(start_index + limitnum >= dayindex[day]){
646             LogHelpClaimEnd(true);
647         }
648         else{
649             LogHelpClaimEnd(false);
650         }
651     }
652     //function set_start(uint start_t)auth{
653     //    startTime = start_t;
654     //}
655     // function set_break(uint break_t)auth{
656     //    breakTime = break_t;
657     //}
658 }