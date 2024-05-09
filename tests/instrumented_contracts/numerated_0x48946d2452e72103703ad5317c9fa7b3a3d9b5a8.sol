1 // Copyright (C) 2017 DappHub, LLC
2 
3 pragma solidity ^0.4.11;
4 
5 //import "ds-exec/exec.sol";
6 
7 contract DSExec {
8     function tryExec( address target, bytes calldata, uint value)
9     internal
10     returns (bool call_ret)
11     {
12         return target.call.value(value)(calldata);
13     }
14     function exec( address target, bytes calldata, uint value)
15     internal
16     {
17         if(!tryExec(target, calldata, value)) {
18             throw;
19         }
20     }
21 
22     // Convenience aliases
23     function exec( address t, bytes c )
24     internal
25     {
26         exec(t, c, 0);
27     }
28     function exec( address t, uint256 v )
29     internal
30     {
31         bytes memory c; exec(t, c, v);
32     }
33     function tryExec( address t, bytes c )
34     internal
35     returns (bool)
36     {
37         return tryExec(t, c, 0);
38     }
39     function tryExec( address t, uint256 v )
40     internal
41     returns (bool)
42     {
43         bytes memory c; return tryExec(t, c, v);
44     }
45 }
46 
47 //import "ds-auth/auth.sol";
48 contract DSAuthority {
49     function canCall(
50     address src, address dst, bytes4 sig
51     ) constant returns (bool);
52 }
53 
54 contract DSAuthEvents {
55     event LogSetAuthority (address indexed authority);
56     event LogSetOwner     (address indexed owner);
57 }
58 
59 contract DSAuth is DSAuthEvents {
60     DSAuthority  public  authority;
61     address      public  owner;
62 
63     function DSAuth() {
64         owner = msg.sender;
65         LogSetOwner(msg.sender);
66     }
67 
68     function setOwner(address owner_)
69     auth
70     {
71         owner = owner_;
72         LogSetOwner(owner);
73     }
74 
75     function setAuthority(DSAuthority authority_)
76     auth
77     {
78         authority = authority_;
79         LogSetAuthority(authority);
80     }
81 
82     modifier auth {
83         assert(isAuthorized(msg.sender, msg.sig));
84         _;
85     }
86 
87     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
88         if (src == address(this)) {
89             return true;
90         } else if (src == owner) {
91             return true;
92         } else if (authority == DSAuthority(0)) {
93             return false;
94         } else {
95             return authority.canCall(src, this, sig);
96         }
97     }
98 
99     function assert(bool x) internal {
100         if (!x) throw;
101     }
102 }
103 
104 //import "ds-note/note.sol";
105 contract DSNote {
106     event LogNote(
107     bytes4   indexed  sig,
108     address  indexed  guy,
109     bytes32  indexed  foo,
110     bytes32  indexed  bar,
111     uint        wad,
112     bytes             fax
113     ) anonymous;
114 
115     modifier note {
116         bytes32 foo;
117         bytes32 bar;
118 
119         assembly {
120         foo := calldataload(4)
121         bar := calldataload(36)
122         }
123 
124         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
125 
126         _;
127     }
128 }
129 
130 
131 //import "ds-math/math.sol";
132 contract DSMath {
133 
134     /*
135     standard uint256 functions
136      */
137 
138     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
139         assert((z = x + y) >= x);
140     }
141 
142     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
143         assert((z = x - y) <= x);
144     }
145 
146     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
147         z = x * y;
148         assert(x == 0 || z / x == y);
149     }
150 
151     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
152         z = x / y;
153     }
154 
155     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
156         return x <= y ? x : y;
157     }
158     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
159         return x >= y ? x : y;
160     }
161 
162     /*
163     uint128 functions (h is for half)
164      */
165 
166 
167     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
168         assert((z = x + y) >= x);
169     }
170 
171     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
172         assert((z = x - y) <= x);
173     }
174 
175     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
176         z = x * y;
177         assert(x == 0 || z / x == y);
178     }
179 
180     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         z = x / y;
182     }
183 
184     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
185         return x <= y ? x : y;
186     }
187     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
188         return x >= y ? x : y;
189     }
190 
191 
192     /*
193     int256 functions
194      */
195 
196     function imin(int256 x, int256 y) constant internal returns (int256 z) {
197         return x <= y ? x : y;
198     }
199     function imax(int256 x, int256 y) constant internal returns (int256 z) {
200         return x >= y ? x : y;
201     }
202 
203     /*
204     WAD math
205      */
206 
207     uint128 constant WAD = 10 ** 18;
208 
209     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
210         return hadd(x, y);
211     }
212 
213     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
214         return hsub(x, y);
215     }
216 
217     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
218         z = cast((uint256(x) * y + WAD / 2) / WAD);
219     }
220 
221     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
222         z = cast((uint256(x) * WAD + y / 2) / y);
223     }
224 
225     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
226         return hmin(x, y);
227     }
228     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
229         return hmax(x, y);
230     }
231 
232     /*
233     RAY math
234      */
235 
236     uint128 constant RAY = 10 ** 27;
237 
238     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
239         return hadd(x, y);
240     }
241 
242     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
243         return hsub(x, y);
244     }
245 
246     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
247         z = cast((uint256(x) * y + RAY / 2) / RAY);
248     }
249 
250     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
251         z = cast((uint256(x) * RAY + y / 2) / y);
252     }
253 
254     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
255         // This famous algorithm is called "exponentiation by squaring"
256         // and calculates x^n with x as fixed-point and n as regular unsigned.
257         //
258         // It's O(log n), instead of O(n) for naive repeated multiplication.
259         //
260         // These facts are why it works:
261         //
262         //  If n is even, then x^n = (x^2)^(n/2).
263         //  If n is odd,  then x^n = x * x^(n-1),
264         //   and applying the equation for even x gives
265         //    x^n = x * (x^2)^((n-1) / 2).
266         //
267         //  Also, EVM division is flooring and
268         //    floor[(n-1) / 2] = floor[n / 2].
269 
270         z = n % 2 != 0 ? x : RAY;
271 
272         for (n /= 2; n != 0; n /= 2) {
273             x = rmul(x, x);
274 
275             if (n % 2 != 0) {
276                 z = rmul(z, x);
277             }
278         }
279     }
280 
281     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
282         return hmin(x, y);
283     }
284     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
285         return hmax(x, y);
286     }
287 
288     function cast(uint256 x) constant internal returns (uint128 z) {
289         assert((z = uint128(x)) == x);
290     }
291 
292 }
293 
294 //import "erc20/erc20.sol";
295 contract ERC20 {
296     function totalSupply() constant returns (uint supply);
297     function balanceOf( address who ) constant returns (uint value);
298     function allowance( address owner, address spender ) constant returns (uint _allowance);
299 
300     function transfer( address to, uint value) returns (bool ok);
301     function transferFrom( address from, address to, uint value) returns (bool ok);
302     function approve( address spender, uint value ) returns (bool ok);
303 
304     event Transfer( address indexed from, address indexed to, uint value);
305     event Approval( address indexed owner, address indexed spender, uint value);
306 }
307 
308 
309 
310 //import "ds-token/base.sol";
311 contract DSTokenBase is ERC20, DSMath {
312     uint256                                            _supply;
313     mapping (address => uint256)                       _balances;
314     mapping (address => mapping (address => uint256))  _approvals;
315 
316     function DSTokenBase(uint256 supply) {
317         _balances[msg.sender] = supply;
318         _supply = supply;
319     }
320 
321     function totalSupply() constant returns (uint256) {
322         return _supply;
323     }
324     function balanceOf(address src) constant returns (uint256) {
325         return _balances[src];
326     }
327     function allowance(address src, address guy) constant returns (uint256) {
328         return _approvals[src][guy];
329     }
330 
331     function transfer(address dst, uint wad) returns (bool) {
332         assert(_balances[msg.sender] >= wad);
333 
334         _balances[msg.sender] = sub(_balances[msg.sender], wad);
335         _balances[dst] = add(_balances[dst], wad);
336 
337         Transfer(msg.sender, dst, wad);
338 
339         return true;
340     }
341 
342     function transferFrom(address src, address dst, uint wad) returns (bool) {
343         assert(_balances[src] >= wad);
344         assert(_approvals[src][msg.sender] >= wad);
345 
346         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
347         _balances[src] = sub(_balances[src], wad);
348         _balances[dst] = add(_balances[dst], wad);
349 
350         Transfer(src, dst, wad);
351 
352         return true;
353     }
354 
355     function approve(address guy, uint256 wad) returns (bool) {
356         _approvals[msg.sender][guy] = wad;
357 
358         Approval(msg.sender, guy, wad);
359 
360         return true;
361     }
362 
363 }
364 
365 
366 //import "ds-stop/stop.sol";
367 contract DSStop is DSAuth, DSNote {
368 
369     bool public stopped;
370 
371     modifier stoppable {
372         assert (!stopped);
373         _;
374     }
375     function stop() auth note {
376         stopped = true;
377     }
378     function start() auth note {
379         stopped = false;
380     }
381 
382 }
383 
384 
385 //import "ds-token/token.sol";
386 contract DSToken is DSTokenBase(0), DSStop {
387 
388     bytes32  public  symbol;
389     uint256  public  decimals = 18; // standard token precision. override to customize
390     address  public  generator;
391 
392     modifier onlyGenerator {
393         if(msg.sender!=generator) throw;
394         _;
395     }
396 
397     function DSToken(bytes32 symbol_) {
398         symbol = symbol_;
399         generator=msg.sender;
400     }
401 
402     function transfer(address dst, uint wad) stoppable note returns (bool) {
403         return super.transfer(dst, wad);
404     }
405     function transferFrom(
406     address src, address dst, uint wad
407     ) stoppable note returns (bool) {
408         return super.transferFrom(src, dst, wad);
409     }
410     function approve(address guy, uint wad) stoppable note returns (bool) {
411         return super.approve(guy, wad);
412     }
413 
414     function push(address dst, uint128 wad) returns (bool) {
415         return transfer(dst, wad);
416     }
417     function pull(address src, uint128 wad) returns (bool) {
418         return transferFrom(src, msg.sender, wad);
419     }
420 
421     function mint(uint128 wad) auth stoppable note {
422         _balances[msg.sender] = add(_balances[msg.sender], wad);
423         _supply = add(_supply, wad);
424     }
425     function burn(uint128 wad) auth stoppable note {
426         _balances[msg.sender] = sub(_balances[msg.sender], wad);
427         _supply = sub(_supply, wad);
428     }
429 
430     // owner can transfer token even stop,
431     function generatorTransfer(address dst, uint wad) onlyGenerator note returns (bool) {
432         return super.transfer(dst, wad);
433     }
434 
435     // Optional token name
436 
437     bytes32   public  name = "";
438 
439     function setName(bytes32 name_) auth {
440         name = name_;
441     }
442 
443 }
444 
445 
446 contract kkkTokenSale is DSStop, DSMath, DSExec {
447 
448     DSToken public kkk;
449 
450     // kkk PRICES (ETH/kkk)
451     uint128 public constant PUBLIC_SALE_PRICE = 200000 ether;
452 
453     uint128 public constant TOTAL_SUPPLY = 10 ** 11 * 1 ether;  // 100 billion kkk in total
454 
455     uint128 public constant SELL_SOFT_LIMIT = TOTAL_SUPPLY * 12 / 100; // soft limit is 12% , 60000 eth
456     uint128 public constant SELL_HARD_LIMIT = TOTAL_SUPPLY * 16 / 100; // hard limit is 16% , 80000 eth
457 
458     uint128 public constant FUTURE_DISTRIBUTE_LIMIT = TOTAL_SUPPLY * 84 / 100; // 84% for future distribution
459 
460     uint128 public constant USER_BUY_LIMIT = 500 ether; // 500 ether limit
461     uint128 public constant MAX_GAS_PRICE = 50000000000;  // 50GWei
462 
463     uint public startTime;
464     uint public endTime;
465 
466     bool public moreThanSoftLimit;
467 
468     mapping (address => uint)  public  userBuys; // limit to 500 eth
469 
470     address public destFoundation; //multisig account , 4-of-6
471 
472     uint128 public sold;
473     uint128 public constant soldByChannels = 40000 * 200000 ether; // 2 ICO websites, each 20000 eth
474 
475     function kkkTokenSale(uint startTime_, address destFoundation_) {
476 
477         kkk = new DSToken("kkk");
478 
479         destFoundation = destFoundation_;
480 
481         startTime = startTime_;
482         endTime = startTime + 14 days;
483 
484         sold = soldByChannels; // sold by 3rd party ICO websites;
485         kkk.mint(TOTAL_SUPPLY);
486 
487         kkk.transfer(destFoundation, FUTURE_DISTRIBUTE_LIMIT);
488         kkk.transfer(destFoundation, soldByChannels);
489 
490         //disable transfer
491         kkk.stop();
492     }
493 
494     // overrideable for easy testing
495     function time() constant returns (uint) {
496         return now;
497     }
498 
499     function isContract(address _addr) constant internal returns(bool) {
500         uint size;
501         if (_addr == 0) return false;
502         assembly {
503         size := extcodesize(_addr)
504         }
505         return size > 0;
506     }
507 
508     function canBuy(uint total) returns (bool) {
509         return total <= USER_BUY_LIMIT;
510     }
511 
512     function() payable stoppable note {
513 
514         require(!isContract(msg.sender));
515         require(msg.value >= 0.01 ether);
516         require(tx.gasprice <= MAX_GAS_PRICE);
517 
518         assert(time() >= startTime && time() < endTime);
519 
520         var toFund = cast(msg.value);
521 
522         var requested = wmul(toFund, PUBLIC_SALE_PRICE);
523 
524         // selling SELL_HARD_LIMIT tokens ends the sale
525         if( add(sold, requested) >= SELL_HARD_LIMIT) {
526             requested = SELL_HARD_LIMIT - sold;
527             toFund = wdiv(requested, PUBLIC_SALE_PRICE);
528 
529             endTime = time();
530         }
531 
532         // User cannot buy more than USER_BUY_LIMIT
533         var totalUserBuy = add(userBuys[msg.sender], toFund);
534         assert(canBuy(totalUserBuy));
535         userBuys[msg.sender] = totalUserBuy;
536 
537         sold = hadd(sold, requested);
538 
539         // Soft limit triggers the sale to close in 24 hours
540         if( !moreThanSoftLimit && sold >= SELL_SOFT_LIMIT ) {
541             moreThanSoftLimit = true;
542             endTime = time() + 24 hours; // last 24 hours after soft limit,
543         }
544 
545         kkk.start();
546         kkk.transfer(msg.sender, requested);
547         kkk.stop();
548 
549         exec(destFoundation, toFund); // send collected ETH to multisig
550 
551         // return excess ETH to the user
552         uint toReturn = sub(msg.value, toFund);
553         if(toReturn > 0) {
554             exec(msg.sender, toReturn);
555         }
556     }
557 
558     function setStartTime(uint startTime_) auth note {
559         require(time() <= startTime && time() <= startTime_);
560 
561         startTime = startTime_;
562         endTime = startTime + 14 days;
563     }
564 
565     function finalize() auth note {
566         require(time() >= endTime);
567 
568         // enable transfer
569         kkk.start();
570 
571         // transfer undistributed kkk
572         kkk.transfer(destFoundation, kkk.balanceOf(this));
573 
574         // owner -> destFoundation
575         kkk.setOwner(destFoundation);
576     }
577 
578 
579     // @notice This method can be used by the controller to extract mistakenly
580     //  sent tokens to this contract.
581     // @param dst The address that will be receiving the tokens
582     // @param wad The amount of tokens to transfer
583     // @param _token The address of the token contract that you want to recover
584     function transferTokens(address dst, uint wad, address _token) public auth note {
585         ERC20 token = ERC20(_token);
586         token.transfer(dst, wad);
587     }
588 
589     function summary()constant returns(
590         uint128 _sold,
591         uint _startTime,
592         uint _endTime)
593         {
594         _sold = sold;
595         _startTime = startTime;
596         _endTime = endTime;
597         return;
598     }
599 
600 }