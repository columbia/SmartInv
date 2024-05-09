1 pragma solidity ^0.4.24;
2 contract DSNote {
3     event LogNote(
4         bytes4   indexed  sig,
5         address  indexed  guy,
6         bytes32  indexed  foo,
7         bytes32  indexed  bar,
8 	    uint	 	      wad,
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
22 
23         _;
24     }
25 }
26 
27 contract ERC20 {
28     function totalSupply() public view returns (uint supply);
29     function balanceOf( address who ) public view returns (uint value);
30     function allowance( address owner, address spender ) public view returns (uint _allowance);
31 
32     function transfer( address to, uint value) public returns (bool ok);
33     function transferFrom( address from, address to, uint value) public returns (bool ok);
34     function approve( address spender, uint value ) public returns (bool ok);
35 
36     event Transfer( address indexed from, address indexed to, uint value);
37     event Approval( address indexed owner, address indexed spender, uint value);
38 }
39 
40 contract DSAuthority {
41     function canCall(
42         address src, address dst, bytes4 sig
43     ) public constant returns (bool);
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
55     constructor() public{
56         owner = msg.sender;
57         emit LogSetOwner(msg.sender);
58     }
59 
60     function setOwner(address owner_) public auth
61     {
62         require(owner_ != address(0));
63         owner = owner_;
64         emit LogSetOwner(owner);
65     }
66 
67     function setAuthority(DSAuthority authority_) public auth
68     {
69         authority = authority_;
70         emit LogSetAuthority(authority);
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
83     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
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
95 }
96 
97 contract DSExec {
98     function tryExec( address target, bytes calldata, uint value)
99              internal
100              returns (bool call_ret)
101     {
102         return target.call.value(value)(calldata);
103     }
104     function exec( address target, bytes calldata, uint value)
105              internal
106     {
107         if(!tryExec(target, calldata, value)) {
108             revert();
109         }
110     }
111 
112     // Convenience aliases
113     function exec( address t, bytes c )
114         internal
115     {
116         exec(t, c, 0);
117     }
118     function exec( address t, uint256 v )
119         internal
120     {
121         bytes memory c; exec(t, c, v);
122     }
123     function tryExec( address t, bytes c )
124         internal
125         returns (bool)
126     {
127         return tryExec(t, c, 0);
128     }
129     function tryExec( address t, uint256 v )
130         internal
131         returns (bool)
132     {
133         bytes memory c; return tryExec(t, c, v);
134     }
135 }
136 
137 contract DSMath {
138     
139     /*
140     standard uint256 functions
141      */
142 
143     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
144         assert((z = x + y) >= x);
145     }
146 
147     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
148         assert((z = x - y) <= x);
149     }
150 
151     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
152         assert(y == 0 || (z = x * y) / y == x);
153     }
154 
155     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
156         z = x / y;
157     }
158 
159     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
160         return x <= y ? x : y;
161     }
162     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
163         return x >= y ? x : y;
164     }
165 
166     /*
167     uint128 functions (h is for half)
168      */
169 
170 
171     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
172         assert((z = x + y) >= x);
173     }
174 
175     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
176         assert((z = x - y) <= x);
177     }
178 
179     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
180         assert(y == 0 || (z = x * y) / y == x);
181     }
182 
183     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
184         z = x / y;
185     }
186 
187     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
188         return x <= y ? x : y;
189     }
190     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
191         return x >= y ? x : y;
192     }
193 
194 
195     /*
196     int256 functions
197      */
198 
199     function imin(int256 x, int256 y) pure internal returns (int256 z) {
200         return x <= y ? x : y;
201     }
202     function imax(int256 x, int256 y) pure internal returns (int256 z) {
203         return x >= y ? x : y;
204     }
205 
206     /*
207     WAD math
208      */
209 
210     uint128 constant WAD = 10 ** 18;
211 
212     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
213         return hadd(x, y);
214     }
215 
216     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
217         return hsub(x, y);
218     }
219 
220     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
221         z = cast(add(mul(uint256(x), y), WAD/2) / WAD);
222     }
223 
224     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
225         z = cast(add(mul(uint256(x), WAD), y/2) / y);
226     }
227 
228     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
229         return hmin(x, y);
230     }
231     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
232         return hmax(x, y);
233     }
234 
235     /*
236     RAY math
237      */
238 
239     uint128 constant RAY = 10 ** 27;
240 
241     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
242         return hadd(x, y);
243     }
244 
245     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
246         return hsub(x, y);
247     }
248 
249     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
250         z = cast(add(mul(uint256(x), y), RAY/2) / RAY);
251     }
252 
253     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
254         z = cast(add(mul(uint256(x), RAY), y/2) / y);
255     }
256 
257     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
258         // This famous algorithm is called "exponentiation by squaring"
259         // and calculates x^n with x as fixed-point and n as regular unsigned.
260         //
261         // It's O(log n), instead of O(n) for naive repeated multiplication.
262         //
263         // These facts are why it works:
264         //
265         //  If n is even, then x^n = (x^2)^(n/2).
266         //  If n is odd,  then x^n = x * x^(n-1),
267         //   and applying the equation for even x gives
268         //    x^n = x * (x^2)^((n-1) / 2).
269         //
270         //  Also, EVM division is flooring and
271         //    floor[(n-1) / 2] = floor[n / 2].
272 
273         z = n % 2 != 0 ? x : RAY;
274 
275         for (n /= 2; n != 0; n /= 2) {
276             x = rmul(x, x);
277 
278             if (n % 2 != 0) {
279                 z = rmul(z, x);
280             }
281         }
282     }
283 
284     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
285         return hmin(x, y);
286     }
287     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
288         return hmax(x, y);
289     }
290 
291     function cast(uint256 x) pure internal returns (uint128 z) {
292         assert((z = uint128(x)) == x);
293     }
294 
295 }
296 
297 contract DSStop is DSAuth, DSNote {
298 
299     bool public stopped;
300 
301     modifier stoppable {
302         assert (!stopped);
303         _;
304     }
305     function stop() public auth note {
306         stopped = true;
307     }
308     function start() public auth note {
309         stopped = false;
310     }
311 
312 }
313 
314 contract DSTokenBase is ERC20, DSMath {
315     uint256                                            _supply;
316     mapping (address => uint256)                       _balances;
317     mapping (address => mapping (address => uint256))  _approvals;
318     
319     constructor(uint256 supply) public {
320         _balances[msg.sender] = supply;
321         _supply = supply;
322     }
323     
324     function totalSupply() public view returns (uint256) {
325         return _supply;
326     }
327     function balanceOf(address src) public view returns (uint256) {
328         return _balances[src];
329     }
330     function allowance(address src, address guy) public view returns (uint256) {
331         return _approvals[src][guy];
332     }
333     
334     function transfer(address dst, uint wad) public returns (bool) {
335         assert(_balances[msg.sender] >= wad);
336         
337         _balances[msg.sender] = sub(_balances[msg.sender], wad);
338         _balances[dst] = add(_balances[dst], wad);
339         
340         emit Transfer(msg.sender, dst, wad);
341         
342         return true;
343     }
344     
345     function transferFrom(address src, address dst, uint wad) public returns (bool) {
346         assert(_balances[src] >= wad);
347         assert(_approvals[src][msg.sender] >= wad);
348         
349         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
350         _balances[src] = sub(_balances[src], wad);
351         _balances[dst] = add(_balances[dst], wad);
352         
353         emit Transfer(src, dst, wad);
354         
355         return true;
356     }
357     
358     function approve(address guy, uint256 wad) public returns (bool) {
359         _approvals[msg.sender][guy] = wad;
360         
361         emit Approval(msg.sender, guy, wad);
362         
363         return true;
364     }
365 
366 }
367 
368 
369 contract DSToken is DSTokenBase(0), DSStop {
370     bytes32  public  symbol;
371     bytes32  public  name;
372     uint256  public  decimals = 18; // standard token precision. override to customize
373     uint256  public  MAX_MINT_NUMBER = 1000*10**26;
374 
375     constructor(bytes32 symbol_, bytes32 name_) public {
376         symbol = symbol_;
377         name = name_;
378     }
379 
380     function transfer(address dst, uint wad) public stoppable note returns (bool) {
381         return super.transfer(dst, wad);
382     }
383     function transferFrom(
384         address src, address dst, uint wad
385     ) public stoppable note returns (bool) {
386         return super.transferFrom(src, dst, wad);
387     }
388     function approve(address guy, uint wad) public stoppable note returns (bool) {
389         return super.approve(guy, wad);
390     }
391 
392     function push(address dst, uint128 wad) public returns (bool) {
393         return transfer(dst, wad);
394     }
395     function pull(address src, uint128 wad) public returns (bool) {
396         return transferFrom(src, msg.sender, wad);
397     }
398 
399     function mint(uint128 wad) public auth stoppable note {
400         assert (add(_supply, wad) <= MAX_MINT_NUMBER);
401         _balances[msg.sender] = add(_balances[msg.sender], wad);
402         _supply = add(_supply, wad);
403     }
404     function burn(uint128 wad) public auth stoppable note {
405         _balances[msg.sender] = sub(_balances[msg.sender], wad);
406         _supply = sub(_supply, wad);
407     }
408 }
409 
410 contract DSAuthList is DSAuth {
411     mapping(address => bool) public whitelist;
412     mapping(address => bool) public adminlist;
413 
414     modifier onlyIfWhitelisted
415     {
416         assert(whitelist[msg.sender] == true);
417         _;
418     }
419 
420     modifier onlyIfAdmin
421     {
422         assert(adminlist[msg.sender] == true);
423         _;
424     }
425 
426     function addAdminList(address[] addresses) public auth
427     {
428         for (uint256 i=0; i < addresses.length; i++)
429         {
430             adminlist[addresses[i]] = true;
431         }
432     }
433 
434     function removeAdminList(address[] addresses) public auth
435     {
436         for (uint256 i=0; i < addresses.length; i++)
437         {
438             adminlist[addresses[i]] = false;
439         }
440     }
441 
442     function addWhiteList(address[] addresses) public onlyIfAdmin
443     {
444         for (uint256 i=0; i < addresses.length; i++)
445         {
446             whitelist[addresses[i]] = true;
447         }
448     }
449 
450     function removeWhiteList(address[] addresses) public onlyIfAdmin
451     {
452         for (uint256 i=0; i < addresses.length; i++)
453         {
454             whitelist[addresses[i]] = false;
455         }
456     }
457 }
458 
459 contract ONOSale is DSExec, DSMath, DSAuthList {
460     DSToken  public  ONO;                  // The ONO token itself
461     uint128  public  totalSupply;          // Total ONO amount created
462     uint128  public  foundersAllocation;   // Amount given to founders
463     string   public  foundersKey;          // Public key of founders
464 
465     uint     public  openTime;             // Time of window 0 opening
466     uint     public  createFirstRound;       // Tokens sold in window 0
467 
468     uint     public  startTime;            // Time of window 1 opening
469     uint     public  numberOfRounds;         // Number of windows after 0
470     uint     public  createPerRound;         // Tokens sold in each window
471 
472     address  public  founderAddr = 0xF9BaaA91e617dF1dE6c2386b789B401c422E9AB1;
473     address  public  burnAddr    = 0xA3Ad4EFDd5719eAed1B0F2e12c0D7368a6D11037;
474 
475     mapping (uint => uint)                       public  dailyTotals;
476     mapping (uint => mapping (address => uint))  public  userBuys;
477     mapping (uint => mapping (address => bool))  public  claimed;
478     mapping (address => string)                  public  keys;
479 
480     mapping (uint => address[]) public userBuysArray;
481     mapping (uint => bool) public burned; //In one round, If the getted eth insufficient, the remain token will be burned
482 
483     event LogBuy      (uint window, address user, uint amount);
484     event LogClaim    (uint window, address user, uint amount);
485     event LogMint     (address user, uint amount);
486     event LogBurn     (uint window, address user, uint amount);
487     event LogRegister (address user, string key);
488     event LogCollect  (uint amount);
489 
490     constructor(
491         uint     _numberOfRounds,
492         uint128  _totalSupply,
493         uint128  _firstRoundSupply,
494         uint     _openTime,
495         uint     _startTime,
496         uint128  _foundersAllocation,
497         string   _foundersKey
498     ) public {
499         numberOfRounds     = _numberOfRounds;
500         totalSupply        = _totalSupply;
501         openTime           = _openTime;
502         startTime          = _startTime;
503         foundersAllocation = _foundersAllocation;
504         foundersKey        = _foundersKey;
505 
506         createFirstRound = _firstRoundSupply;
507         createPerRound = div(
508             sub(sub(totalSupply, foundersAllocation), createFirstRound),
509             numberOfRounds
510         );
511 
512         assert(numberOfRounds > 0);
513         assert(totalSupply > foundersAllocation);
514         assert(openTime < startTime);
515     }
516 
517     function initialize(DSToken ono) public auth {
518         assert(address(ONO) == address(0));
519         assert(ono.owner() == address(this));
520         assert(ono.authority() == DSAuthority(0));
521         assert(ono.totalSupply() == 0);
522 
523         ONO = ono;
524         ONO.mint(totalSupply);
525 
526         ONO.push(founderAddr, foundersAllocation);
527         keys[founderAddr] = foundersKey;
528 
529         emit LogRegister(founderAddr, foundersKey);
530     }
531 
532     function time() public constant returns (uint) {
533         return block.timestamp;
534     }
535 
536     function currRound() public constant returns (uint) {
537         return roundFor(time());
538     }
539 
540     function roundFor(uint timestamp) public constant returns (uint) {
541         return timestamp < startTime
542             ? 0
543             : sub(timestamp, startTime) / 71 hours + 1;
544     }
545 
546     function createOnRound(uint round) public constant returns (uint) {
547         return round == 0 ? createFirstRound : createPerRound;
548     }
549 
550     function () public payable {
551         buy();
552     }
553 
554     function claim(uint round) public {
555         claimAddress(msg.sender, round);
556     }
557 
558     function claimAll() public {
559         for (uint i = 0; i < currRound(); i++) {
560             claim(i);
561         }
562     }
563 
564     // Value should be a public key.  Read full key import policy.
565     // Manually registering requires a base58
566     // encoded using the STEEM, BTS, or ONO public key format.
567     function register(string key) public {
568         assert(currRound() <=  numberOfRounds + 1);
569         assert(bytes(key).length <= 64);
570 
571         keys[msg.sender] = key;
572 
573         emit LogRegister(msg.sender, key);
574     }
575 
576     function buy() public payable onlyIfWhitelisted{
577         
578         uint round = currRound();
579         
580         assert(time() >= openTime && round <= numberOfRounds);
581         assert(msg.value >= 1 ether);
582 
583         userBuys[round][msg.sender] = add(userBuys[round][msg.sender], msg.value);
584         dailyTotals[round] = add(dailyTotals[round], msg.value);
585         
586         bool founded = false;
587         for (uint i = 0; i < userBuysArray[round].length; i++) {
588             address target = userBuysArray[round][i];
589             if (target == msg.sender) {
590                 founded = true;
591                 break;
592             }
593         }
594 
595         if (founded == false) {
596             userBuysArray[round].push(msg.sender);
597         }
598 
599         emit LogBuy(round, msg.sender, msg.value);
600     }
601 
602     function claimAddresses(address[] addresses, uint round) public onlyIfAdmin {
603         uint arrayLength = addresses.length;
604         for (uint i=0; i < arrayLength; i++) {
605             claimAddress(addresses[i], round);
606         }
607     }
608 
609     function claimAddress(address addr, uint round) public {
610         assert(currRound() > round);
611 
612         if (claimed[round][addr] || dailyTotals[round] == 0) {
613             return;
614         }
615 
616         // This will have small rounding errors, but the token is
617         // going to be truncated to 8 decimal places or less anyway
618         // when launched on its own chain.
619 
620         uint128 dailyTotal = cast(dailyTotals[round]);
621         uint128 userTotal  = cast(userBuys[round][addr]);
622         uint128 price      = wdiv(cast(createOnRound(round)), dailyTotal);
623         uint128 minPrice   = wdiv(600000, 1);//private sale price
624 
625         //cannot lower than private sale price
626         if (price > minPrice) {
627             price = minPrice;
628         }
629         uint128 reward     = wmul(price, userTotal);
630 
631         claimed[round][addr] = true;
632         ONO.push(addr, reward);
633 
634         emit LogClaim(round, addr, reward);
635     }
636 
637     function mint(uint128 deltaSupply) public auth {
638         ONO.mint(deltaSupply);
639         ONO.push(founderAddr, deltaSupply);
640 
641         emit LogMint(founderAddr, deltaSupply);
642     }
643 
644     function burn(uint round) public onlyIfAdmin {
645         assert(time() >= openTime && round <= numberOfRounds);
646 
647         assert (currRound() > round);
648         assert (burned[round] == false);
649         
650         uint128 dailyTotalEth = cast(dailyTotals[round]);
651         uint128 dailyTotalToken = cast(createOnRound(round));
652 
653         if (dailyTotalEth == 0) {
654             burned[round] = true;
655             ONO.push(burnAddr, dailyTotalToken);
656 
657             emit LogBurn(round, burnAddr, dailyTotalToken);
658         }
659         else {
660             uint128 price      = wdiv(dailyTotalToken, dailyTotalEth);
661             uint128 minPrice   = wdiv(600000, 1);//private sale price
662 
663             if (price > minPrice) {
664                 price = minPrice;
665 
666                 uint128 totalReward = wmul(price, dailyTotalEth);
667                 assert(dailyTotalToken > totalReward);
668 
669                 burned[round] = true;
670                 ONO.push(burnAddr, wsub(dailyTotalToken, totalReward));
671                 emit LogBurn(round, burnAddr, wsub(dailyTotalToken, totalReward));
672             } else {
673                 burned[round] = true;
674             }
675         }
676     }
677 
678     // Crowdsale owners can collect ETH any number of times
679     function collect() public auth {
680         assert(currRound() > 0); // Prevent recycling during window 0
681         exec(msg.sender, address(this).balance);
682         emit LogCollect(address(this).balance);
683     }
684 
685     function start() public auth {
686         ONO.start();
687     }
688 
689     function stop() public auth {
690         ONO.stop();
691     }
692 }