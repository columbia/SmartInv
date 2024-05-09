1 // Copyright (C) 2017 DappHub, LLC
2 
3 // Copyright (C) 2017 DappHub, LLC
4 
5 pragma solidity ^0.4.11;
6 
7 //import "ds-exec/exec.sol";
8 
9 contract DSExec {
10     function tryExec( address target, bytes calldata, uint value)
11     internal
12     returns (bool call_ret)
13     {
14         return target.call.value(value)(calldata);
15     }
16     function exec( address target, bytes calldata, uint value)
17     internal
18     {
19         if(!tryExec(target, calldata, value)) {
20             throw;
21         }
22     }
23 
24     // Convenience aliases
25     function exec( address t, bytes c )
26     internal
27     {
28         exec(t, c, 0);
29     }
30     function exec( address t, uint256 v )
31     internal
32     {
33         bytes memory c; exec(t, c, v);
34     }
35     function tryExec( address t, bytes c )
36     internal
37     returns (bool)
38     {
39         return tryExec(t, c, 0);
40     }
41     function tryExec( address t, uint256 v )
42     internal
43     returns (bool)
44     {
45         bytes memory c; return tryExec(t, c, v);
46     }
47 }
48 
49 //import "ds-auth/auth.sol";
50 contract DSAuthority {
51     function canCall(
52     address src, address dst, bytes4 sig
53     ) constant returns (bool);
54 }
55 
56 contract DSAuthEvents {
57     event LogSetAuthority (address indexed authority);
58     event LogSetOwner     (address indexed owner);
59 }
60 
61 contract DSAuth is DSAuthEvents {
62     DSAuthority  public  authority;
63     address      public  owner;
64 
65     function DSAuth() {
66         owner = msg.sender;
67         LogSetOwner(msg.sender);
68     }
69 
70     function setOwner(address owner_)
71     auth
72     {
73         owner = owner_;
74         LogSetOwner(owner);
75     }
76 
77     function setAuthority(DSAuthority authority_)
78     auth
79     {
80         authority = authority_;
81         LogSetAuthority(authority);
82     }
83 
84     modifier auth {
85         assert(isAuthorized(msg.sender, msg.sig));
86         _;
87     }
88 
89     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
90         if (src == address(this)) {
91             return true;
92         } else if (src == owner) {
93             return true;
94         } else if (authority == DSAuthority(0)) {
95             return false;
96         } else {
97             return authority.canCall(src, this, sig);
98         }
99     }
100 
101     function assert(bool x) internal {
102         if (!x) throw;
103     }
104 }
105 
106 //import "ds-note/note.sol";
107 contract DSNote {
108     event LogNote(
109     bytes4   indexed  sig,
110     address  indexed  guy,
111     bytes32  indexed  foo,
112     bytes32  indexed  bar,
113     uint        wad,
114     bytes             fax
115     ) anonymous;
116 
117     modifier note {
118         bytes32 foo;
119         bytes32 bar;
120 
121         assembly {
122         foo := calldataload(4)
123         bar := calldataload(36)
124         }
125 
126         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
127 
128         _;
129     }
130 }
131 
132 
133 //import "ds-math/math.sol";
134 contract DSMath {
135 
136     /*
137     standard uint256 functions
138      */
139 
140     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
141         assert((z = x + y) >= x);
142     }
143 
144     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
145         assert((z = x - y) <= x);
146     }
147 
148     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
149         z = x * y;
150         assert(x == 0 || z / x == y);
151     }
152 
153     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
154         z = x / y;
155     }
156 
157     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
158         return x <= y ? x : y;
159     }
160     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
161         return x >= y ? x : y;
162     }
163 
164     /*
165     uint128 functions (h is for half)
166      */
167 
168 
169     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
170         assert((z = x + y) >= x);
171     }
172 
173     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
174         assert((z = x - y) <= x);
175     }
176 
177     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
178         z = x * y;
179         assert(x == 0 || z / x == y);
180     }
181 
182     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
183         z = x / y;
184     }
185 
186     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
187         return x <= y ? x : y;
188     }
189     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
190         return x >= y ? x : y;
191     }
192 
193 
194     /*
195     int256 functions
196      */
197 
198     function imin(int256 x, int256 y) constant internal returns (int256 z) {
199         return x <= y ? x : y;
200     }
201     function imax(int256 x, int256 y) constant internal returns (int256 z) {
202         return x >= y ? x : y;
203     }
204 
205     /*
206     WAD math
207      */
208 
209     uint128 constant WAD = 10 ** 18;
210 
211     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
212         return hadd(x, y);
213     }
214 
215     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
216         return hsub(x, y);
217     }
218 
219     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
220         z = cast((uint256(x) * y + WAD / 2) / WAD);
221     }
222 
223     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
224         z = cast((uint256(x) * WAD + y / 2) / y);
225     }
226 
227     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
228         return hmin(x, y);
229     }
230     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
231         return hmax(x, y);
232     }
233 
234     /*
235     RAY math
236      */
237 
238     uint128 constant RAY = 10 ** 27;
239 
240     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
241         return hadd(x, y);
242     }
243 
244     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
245         return hsub(x, y);
246     }
247 
248     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
249         z = cast((uint256(x) * y + RAY / 2) / RAY);
250     }
251 
252     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
253         z = cast((uint256(x) * RAY + y / 2) / y);
254     }
255 
256     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
257         // This famous algorithm is called "exponentiation by squaring"
258         // and calculates x^n with x as fixed-point and n as regular unsigned.
259         //
260         // It's O(log n), instead of O(n) for naive repeated multiplication.
261         //
262         // These facts are why it works:
263         //
264         //  If n is even, then x^n = (x^2)^(n/2).
265         //  If n is odd,  then x^n = x * x^(n-1),
266         //   and applying the equation for even x gives
267         //    x^n = x * (x^2)^((n-1) / 2).
268         //
269         //  Also, EVM division is flooring and
270         //    floor[(n-1) / 2] = floor[n / 2].
271 
272         z = n % 2 != 0 ? x : RAY;
273 
274         for (n /= 2; n != 0; n /= 2) {
275             x = rmul(x, x);
276 
277             if (n % 2 != 0) {
278                 z = rmul(z, x);
279             }
280         }
281     }
282 
283     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
284         return hmin(x, y);
285     }
286     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
287         return hmax(x, y);
288     }
289 
290     function cast(uint256 x) constant internal returns (uint128 z) {
291         assert((z = uint128(x)) == x);
292     }
293 
294 }
295 
296 //import "erc20/erc20.sol";
297 contract ERC20 {
298     function totalSupply() constant returns (uint supply);
299     function balanceOf( address who ) constant returns (uint value);
300     function allowance( address owner, address spender ) constant returns (uint _allowance);
301 
302     function transfer( address to, uint value) returns (bool ok);
303     function transferFrom( address from, address to, uint value) returns (bool ok);
304     function approve( address spender, uint value ) returns (bool ok);
305 
306     event Transfer( address indexed from, address indexed to, uint value);
307     event Approval( address indexed owner, address indexed spender, uint value);
308 }
309 
310 
311 
312 //import "ds-token/base.sol";
313 contract DSTokenBase is ERC20, DSMath {
314     uint256                                            _supply;
315     mapping (address => uint256)                       _balances;
316     mapping (address => mapping (address => uint256))  _approvals;
317 
318     function DSTokenBase(uint256 supply) {
319         _balances[msg.sender] = supply;
320         _supply = supply;
321     }
322 
323     function totalSupply() constant returns (uint256) {
324         return _supply;
325     }
326     function balanceOf(address src) constant returns (uint256) {
327         return _balances[src];
328     }
329     function allowance(address src, address guy) constant returns (uint256) {
330         return _approvals[src][guy];
331     }
332 
333     function transfer(address dst, uint wad) returns (bool) {
334         assert(_balances[msg.sender] >= wad);
335 
336         _balances[msg.sender] = sub(_balances[msg.sender], wad);
337         _balances[dst] = add(_balances[dst], wad);
338 
339         Transfer(msg.sender, dst, wad);
340 
341         return true;
342     }
343 
344     function transferFrom(address src, address dst, uint wad) returns (bool) {
345         assert(_balances[src] >= wad);
346         assert(_approvals[src][msg.sender] >= wad);
347 
348         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
349         _balances[src] = sub(_balances[src], wad);
350         _balances[dst] = add(_balances[dst], wad);
351 
352         Transfer(src, dst, wad);
353 
354         return true;
355     }
356 
357     function approve(address guy, uint256 wad) returns (bool) {
358         _approvals[msg.sender][guy] = wad;
359 
360         Approval(msg.sender, guy, wad);
361 
362         return true;
363     }
364 
365 }
366 
367 
368 //import "ds-stop/stop.sol";
369 contract DSStop is DSAuth, DSNote {
370 
371     bool public stopped;
372 
373     modifier stoppable {
374         assert (!stopped);
375         _;
376     }
377     function stop() auth note {
378         stopped = true;
379     }
380     function start() auth note {
381         stopped = false;
382     }
383 
384 }
385 
386 
387 //import "ds-token/token.sol";
388 contract DSToken is DSTokenBase(0), DSStop {
389 
390     bytes32  public  symbol;
391     uint256  public  decimals = 18; // standard token precision. override to customize
392     address  public  generator;
393 
394     modifier onlyGenerator {
395         if(msg.sender!=generator) throw;
396         _;
397     }
398 
399     function DSToken(bytes32 symbol_) {
400         symbol = symbol_;
401         generator=msg.sender;
402     }
403 
404     function transfer(address dst, uint wad) stoppable note returns (bool) {
405         return super.transfer(dst, wad);
406     }
407     function transferFrom(
408     address src, address dst, uint wad
409     ) stoppable note returns (bool) {
410         return super.transferFrom(src, dst, wad);
411     }
412     function approve(address guy, uint wad) stoppable note returns (bool) {
413         return super.approve(guy, wad);
414     }
415 
416     function push(address dst, uint128 wad) returns (bool) {
417         return transfer(dst, wad);
418     }
419     function pull(address src, uint128 wad) returns (bool) {
420         return transferFrom(src, msg.sender, wad);
421     }
422 
423     function mint(uint128 wad) auth stoppable note {
424         _balances[msg.sender] = add(_balances[msg.sender], wad);
425         _supply = add(_supply, wad);
426     }
427     function burn(uint128 wad) auth stoppable note {
428         _balances[msg.sender] = sub(_balances[msg.sender], wad);
429         _supply = sub(_supply, wad);
430     }
431 
432     // owner can transfer token even stop,
433     function generatorTransfer(address dst, uint wad) onlyGenerator note returns (bool) {
434         return super.transfer(dst, wad);
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
449 //////////////////////////////////////////////////
450 //
451 //import "ds-token/token.sol";
452 //
453 //    import "ds-stop/stop.sol";
454 //        import "ds-auth/auth.sol";
455 //        import "ds-note/note.sol";
456 //
457 //    import "ds-token/base.sol";
458 //        import "erc20/erc20.sol";
459 //        import "ds-math/math.sol";
460 //
461 //import "ds-exec/exec.sol";
462 //import "ds-auth/auth.sol";
463 //import "ds-note/note.sol";
464 //import "ds-math/math.sol";
465 
466 
467 
468 contract KkkTokenSale is DSStop, DSMath, DSExec {
469 
470     DSToken public key;
471 
472     // KEY PRICES (ETH/KEY)
473     uint128 public constant PUBLIC_SALE_PRICE = 200000 ether;
474 
475     uint128 public constant TOTAL_SUPPLY = 10 ** 11 * 1 ether;  // 100 billion KEY in total
476 
477     uint128 public constant SELL_SOFT_LIMIT = TOTAL_SUPPLY * 12 / 100; // soft limit is 12% , 60000 eth
478     uint128 public constant SELL_HARD_LIMIT = TOTAL_SUPPLY * 16 / 100; // hard limit is 16% , 80000 eth
479 
480     uint128 public constant FUTURE_DISTRIBUTE_LIMIT = TOTAL_SUPPLY * 84 / 100; // 84% for future distribution
481 
482     uint128 public constant USER_BUY_LIMIT = 500 ether; // 500 ether limit
483     uint128 public constant MAX_GAS_PRICE = 50000000000;  // 50GWei
484 
485     uint public startTime;
486     uint public endTime;
487 
488     bool public moreThanSoftLimit;
489 
490     mapping (address => uint)  public  userBuys; // limit to 500 eth
491 
492     address public destFoundation; //multisig account , 4-of-6
493 
494     uint128 public sold;
495     uint128 public constant soldByChannels = 40000 * 200000 ether; // 2 ICO websites, each 20000 eth
496 
497     function KkkTokenSale(uint startTime_, address destFoundation_) {
498 
499         key = new DSToken("KKK");
500 //        key = new DSToken("KEY");
501 
502         destFoundation = destFoundation_;
503 
504         startTime = startTime_;
505         endTime = startTime + 14 days;
506 
507         sold = soldByChannels; // sold by 3rd party ICO websites;
508         key.mint(TOTAL_SUPPLY);
509 
510         key.transfer(destFoundation, FUTURE_DISTRIBUTE_LIMIT);
511         key.transfer(destFoundation, soldByChannels);
512 
513         //disable transfer
514         key.stop();
515     }
516 
517     // overrideable for easy testing
518     function time() constant returns (uint) {
519         return now;
520     }
521 
522     function isContract(address _addr) constant internal returns(bool) {
523         uint size;
524         if (_addr == 0) return false;
525         assembly {
526         size := extcodesize(_addr)
527         }
528         return size > 0;
529     }
530 
531     function canBuy(uint total) returns (bool) {
532         return total <= USER_BUY_LIMIT;
533     }
534 
535     function() payable stoppable note {
536 
537         require(!isContract(msg.sender));
538         require(msg.value >= 0.01 ether);
539         require(tx.gasprice <= MAX_GAS_PRICE);
540 
541         assert(time() >= startTime && time() < endTime);
542 
543         var toFund = cast(msg.value);
544 
545         var requested = wmul(toFund, PUBLIC_SALE_PRICE);
546 
547         // selling SELL_HARD_LIMIT tokens ends the sale
548         if( add(sold, requested) >= SELL_HARD_LIMIT) {
549             requested = SELL_HARD_LIMIT - sold;
550             toFund = wdiv(requested, PUBLIC_SALE_PRICE);
551 
552             endTime = time();
553         }
554 
555         // User cannot buy more than USER_BUY_LIMIT
556         var totalUserBuy = add(userBuys[msg.sender], toFund);
557         assert(canBuy(totalUserBuy));
558         userBuys[msg.sender] = totalUserBuy;
559 
560         sold = hadd(sold, requested);
561 
562         // Soft limit triggers the sale to close in 24 hours
563         if( !moreThanSoftLimit && sold >= SELL_SOFT_LIMIT ) {
564             moreThanSoftLimit = true;
565             endTime = time() + 24 hours; // last 24 hours after soft limit,
566         }
567 
568         key.start();
569         key.transfer(msg.sender, requested);
570         key.stop();
571 
572         exec(destFoundation, toFund); // send collected ETH to multisig
573 
574         // return excess ETH to the user
575         uint toReturn = sub(msg.value, toFund);
576         if(toReturn > 0) {
577             exec(msg.sender, toReturn);
578         }
579     }
580 
581     function setStartTime(uint startTime_) auth note {
582         require(time() <= startTime && time() <= startTime_);
583 
584         startTime = startTime_;
585         endTime = startTime + 14 days;
586     }
587 
588     function finalize() auth note {
589         require(time() >= endTime);
590 
591         // enable transfer
592         key.start();
593 
594         // transfer undistributed KEY
595         key.transfer(destFoundation, key.balanceOf(this));
596 
597         // owner -> destFoundation
598         key.setOwner(destFoundation);
599     }
600 
601 
602     // @notice This method can be used by the controller to extract mistakenly
603     //  sent tokens to this contract.
604     // @param dst The address that will be receiving the tokens
605     // @param wad The amount of tokens to transfer
606     // @param _token The address of the token contract that you want to recover
607     function transferTokens(address dst, uint wad, address _token) public auth note {
608         ERC20 token = ERC20(_token);
609         token.transfer(dst, wad);
610     }
611 
612     function summary()constant returns(
613         uint128 _sold,
614         uint _startTime,
615         uint _endTime)
616         {
617         _sold = sold;
618         _startTime = startTime;
619         _endTime = endTime;
620         return;
621     }
622 
623 }