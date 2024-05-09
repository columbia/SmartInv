1 pragma solidity^0.4.21;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
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
18     function DSAuth() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
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
82 
83 contract DSMath {
84     function add(uint x, uint y) internal pure returns (uint z) {
85         require((z = x + y) >= x);
86     }
87     function sub(uint x, uint y) internal pure returns (uint z) {
88         require((z = x - y) <= x);
89     }
90     function mul(uint x, uint y) internal pure returns (uint z) {
91         require(y == 0 || (z = x * y) / y == x);
92     }
93 
94     function min(uint x, uint y) internal pure returns (uint z) {
95         return x <= y ? x : y;
96     }
97     function max(uint x, uint y) internal pure returns (uint z) {
98         return x >= y ? x : y;
99     }
100     function imin(int x, int y) internal pure returns (int z) {
101         return x <= y ? x : y;
102     }
103     function imax(int x, int y) internal pure returns (int z) {
104         return x >= y ? x : y;
105     }
106 
107     uint constant WAD = 10 ** 18;
108     uint constant RAY = 10 ** 27;
109 
110     function wmul(uint x, uint y) internal pure returns (uint z) {
111         z = add(mul(x, y), WAD / 2) / WAD;
112     }
113     function rmul(uint x, uint y) internal pure returns (uint z) {
114         z = add(mul(x, y), RAY / 2) / RAY;
115     }
116     function wdiv(uint x, uint y) internal pure returns (uint z) {
117         z = add(mul(x, WAD), y / 2) / y;
118     }
119     function rdiv(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, RAY), y / 2) / y;
121     }
122 
123     // This famous algorithm is called "exponentiation by squaring"
124     // and calculates x^n with x as fixed-point and n as regular unsigned.
125     //
126     // It's O(log n), instead of O(n) for naive repeated multiplication.
127     //
128     // These facts are why it works:
129     //
130     //  If n is even, then x^n = (x^2)^(n/2).
131     //  If n is odd,  then x^n = x * x^(n-1),
132     //   and applying the equation for even x gives
133     //    x^n = x * (x^2)^((n-1) / 2).
134     //
135     //  Also, EVM division is flooring and
136     //    floor[(n-1) / 2] = floor[n / 2].
137     //
138     function rpow(uint x, uint n) internal pure returns (uint z) {
139         z = n % 2 != 0 ? x : RAY;
140 
141         for (n /= 2; n != 0; n /= 2) {
142             x = rmul(x, x);
143 
144             if (n % 2 != 0) {
145                 z = rmul(z, x);
146             }
147         }
148     }
149 }
150 
151 contract DSThing is DSAuth, DSNote, DSMath {
152 
153     function S(string s) internal pure returns (bytes4) {
154         return bytes4(keccak256(s));
155     }
156 
157 }
158 
159 
160 contract ERC20 {
161 
162     function totalSupply() public constant returns (uint);
163 
164     function balanceOf(address tokenOwner) public constant returns (uint balance);
165 
166     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
167 
168     function transfer(address to, uint tokens) public returns (bool success);
169 
170     function approve(address spender, uint tokens) public returns (bool success);
171 
172     function transferFrom(address from, address to, uint tokens) public returns (bool success);
173  
174     event Transfer(address indexed from, address indexed to, uint tokens);
175     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
176  
177 }
178 
179 contract DSTokenBase is ERC20, DSMath {
180     uint256                                            _supply;
181     mapping (address => uint256)                       _balances;
182     mapping (address => mapping (address => uint256))  _approvals;
183 
184     function DSTokenBase(uint supply) public {
185         _balances[msg.sender] = supply;
186         _supply = supply;
187     }
188 
189     function totalSupply() public view returns (uint) {
190         return _supply;
191     }
192     function balanceOf(address src) public view returns (uint) {
193         return _balances[src];
194     }
195     function allowance(address src, address guy) public view returns (uint) {
196         return _approvals[src][guy];
197     }
198 
199     function transfer(address dst, uint wad) public returns (bool) {
200         return transferFrom(msg.sender, dst, wad);
201     }
202 
203     function transferFrom(address src, address dst, uint wad)
204         public
205         returns (bool)
206     {
207         if (src != msg.sender) {
208             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
209         }
210 
211         _balances[src] = sub(_balances[src], wad);
212         _balances[dst] = add(_balances[dst], wad);
213 
214         Transfer(src, dst, wad);
215 
216         return true;
217     }
218 
219     function approve(address guy, uint wad) public returns (bool) {
220         _approvals[msg.sender][guy] = wad;
221 
222         Approval(msg.sender, guy, wad);
223 
224         return true;
225     }
226 }
227 
228 contract DSStop is DSNote, DSAuth {
229 
230     bool public stopped;
231 
232     modifier stoppable {
233         require(!stopped);
234         _;
235     }
236     function stop() public auth note {
237         stopped = true;
238     }
239     function start() public auth note {
240         stopped = false;
241     }
242 
243 }
244 
245 
246 contract DSToken is DSTokenBase(0), DSStop {
247 
248     string  public  symbol;
249     uint256  public  decimals = 18; // standard token precision. override to customize
250 
251     function DSToken(string symbol_) public {
252         symbol = symbol_;
253     }
254 
255     event Mint(address indexed guy, uint wad);
256     event Burn(address indexed guy, uint wad);
257 
258     function approve(address guy) public stoppable returns (bool) {
259         return super.approve(guy, uint(-1));
260     }
261 
262     function approve(address guy, uint wad) public stoppable returns (bool) {
263         return super.approve(guy, wad);
264     }
265 
266     function transferFrom(address src, address dst, uint wad)
267         public
268         stoppable
269         returns (bool)
270     {
271         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
272             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
273         }
274 
275         _balances[src] = sub(_balances[src], wad);
276         _balances[dst] = add(_balances[dst], wad);
277 
278         Transfer(src, dst, wad);
279 
280         return true;
281     }
282 
283     function push(address dst, uint wad) public {
284         transferFrom(msg.sender, dst, wad);
285     }
286     function pull(address src, uint wad) public {
287         transferFrom(src, msg.sender, wad);
288     }
289     function move(address src, address dst, uint wad) public {
290         transferFrom(src, dst, wad);
291     }
292 
293     function mint(uint wad) public {
294         mint(msg.sender, wad);
295     }
296     function burn(uint wad) public {
297         burn(msg.sender, wad);
298     }
299     function mint(address guy, uint wad) public auth stoppable {
300         _balances[guy] = add(_balances[guy], wad);
301         _supply = add(_supply, wad);
302         Mint(guy, wad);
303     }
304     function burn(address guy, uint wad) public auth stoppable {
305         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
306             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
307         }
308 
309         _balances[guy] = sub(_balances[guy], wad);
310         _supply = sub(_supply, wad);
311         Burn(guy, wad);
312     }
313 
314     // Optional token name
315     string  name = "";
316 
317     function setName(string name_) public auth {
318         name = name_;
319     }
320 }
321 
322 contract DSProxy is DSAuth, DSNote {
323     DSProxyCache public cache;  // global cache for contracts
324 
325     function DSProxy(address _cacheAddr) public {
326         require(setCache(_cacheAddr));
327     }
328 
329     function() public payable {
330     }
331 
332     // use the proxy to execute calldata _data on contract _code
333     function execute(bytes _code, bytes _data)
334         public
335         payable
336         returns (address target, bytes32 response)
337     {
338         target = cache.read(_code);
339         if (target == 0x0) {
340             // deploy contract & store its address in cache
341             target = cache.write(_code);
342         }
343 
344         response = execute(target, _data);
345     }
346 
347     function execute(address _target, bytes _data)
348         public
349         auth
350         note
351         payable
352         returns (bytes32 response)
353     {
354         require(_target != 0x0);
355 
356         // call contract in current context
357         assembly {
358             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 32)
359             response := mload(0)      // load delegatecall output
360             switch iszero(succeeded)
361             case 1 {
362                 // throw if delegatecall failed
363                 revert(0, 0)
364             }
365         }
366     }
367 
368     //set new cache
369     function setCache(address _cacheAddr)
370         public
371         auth
372         note
373         returns (bool)
374     {
375         require(_cacheAddr != 0x0);        // invalid cache address
376         cache = DSProxyCache(_cacheAddr);  // overwrite cache
377         return true;
378     }
379 }
380 
381 // DSProxyFactory
382 // This factory deploys new proxy instances through build()
383 // Deployed proxy addresses are logged
384 contract DSProxyFactory {
385     event Created(address indexed sender, address proxy, address cache);
386     mapping(address=>bool) public isProxy;
387     DSProxyCache public cache = new DSProxyCache();
388 
389     // deploys a new proxy instance
390     // sets owner of proxy to caller
391     function build() public returns (DSProxy proxy) {
392         proxy = build(msg.sender);
393     }
394 
395     // deploys a new proxy instance
396     // sets custom owner of proxy
397     function build(address owner) public returns (DSProxy proxy) {
398         proxy = new DSProxy(cache);
399         Created(owner, address(proxy), address(cache));
400         proxy.setOwner(owner);
401         isProxy[proxy] = true;
402     }
403 }
404 
405 // DSProxyCache
406 // This global cache stores addresses of contracts previously deployed
407 // by a proxy. This saves gas from repeat deployment of the same
408 // contracts and eliminates blockchain bloat.
409 
410 // By default, all proxies deployed from the same factory store
411 // contracts in the same cache. The cache a proxy instance uses can be
412 // changed.  The cache uses the sha3 hash of a contract's bytecode to
413 // lookup the address
414 contract DSProxyCache {
415     mapping(bytes32 => address) cache;
416 
417     function read(bytes _code) public view returns (address) {
418         bytes32 hash = keccak256(_code);
419         return cache[hash];
420     }
421 
422     function write(bytes _code) public returns (address target) {
423         assembly {
424             target := create(0, add(_code, 0x20), mload(_code))
425             switch iszero(extcodesize(target))
426             case 1 {
427                 // throw if contract failed to deploy
428                 revert(0, 0)
429             }
430         }
431         bytes32 hash = keccak256(_code);
432         cache[hash] = target;
433     }
434 }
435 
436 interface DSValue {
437     function peek() external constant returns (bytes32, bool);
438     function read() external constant returns (bytes32);
439 }
440 
441 contract TubInterface {
442 
443     function mat() public view returns(uint);
444 
445     // function cups(bytes32 cup) public view returns(Cup);
446 
447     function ink(bytes32 cup) public view returns (uint);
448     function tab(bytes32 cup) public returns (uint);
449     function rap(bytes32 cup) public returns (uint);
450 
451     //--Collateral-wrapper----------------------------------------------
452     // Wrapper ratio (gem per skr)
453     function per() public view returns (uint ray);
454     // Join price (gem per skr)
455     function ask(uint wad) public view returns (uint);
456     // Exit price (gem per skr)
457     function bid(uint wad) public view returns (uint);
458     function join(uint wad) public;
459     function exit(uint wad) public;
460 
461     //--CDP-risk-indicator----------------------------------------------
462     // Abstracted collateral price (ref per skr)
463     function tag() public view returns (uint wad);
464     // Returns true if cup is well-collateralized
465     function safe(bytes32 cup) public returns (bool);
466 
467     //--CDP-operations--------------------------------------------------
468     function open() public returns (bytes32 cup);
469     function give(bytes32 cup, address guy) public;
470     function lock(bytes32 cup, uint wad) public;
471     function free(bytes32 cup, uint wad) public;
472     function draw(bytes32 cup, uint wad) public;
473     function wipe(bytes32 cup, uint wad) public;
474     function shut(bytes32 cup) public;
475     function bite(bytes32 cup) public;
476 }
477 
478 interface OtcInterface {
479     function sellAllAmount(address, uint, address, uint) public returns (uint);
480     function buyAllAmount(address, uint, address, uint) public returns (uint);
481     function getPayAmount(address, address, uint) public constant returns (uint);
482 }
483 
484 interface ProxyCreationAndExecute {
485     
486     function createAndSellAllAmount(
487         DSProxyFactory factory, 
488         OtcInterface otc, 
489         ERC20 payToken, 
490         uint payAmt, 
491         ERC20 buyToken,
492         uint minBuyAmt) public 
493         returns (DSProxy proxy, uint buyAmt);
494 
495     function createAndSellAllAmountPayEth(
496         DSProxyFactory factory, 
497         OtcInterface otc, 
498         ERC20 buyToken, 
499         uint minBuyAmt) public payable returns (DSProxy proxy, uint buyAmt);
500 
501     function createAndSellAllAmountBuyEth(
502         DSProxyFactory factory, 
503         OtcInterface otc, 
504         ERC20 payToken, 
505         uint payAmt, 
506         uint minBuyAmt) public returns (DSProxy proxy, uint wethAmt);
507 
508     function createAndBuyAllAmount(
509         DSProxyFactory factory, 
510         OtcInterface otc, 
511         ERC20 buyToken, 
512         uint buyAmt, 
513         ERC20 payToken, 
514         uint maxPayAmt) public returns (DSProxy proxy, uint payAmt);
515 
516     function createAndBuyAllAmountPayEth(
517         DSProxyFactory factory, 
518         OtcInterface otc, 
519         ERC20 buyToken, 
520         uint buyAmt) public payable returns (DSProxy proxy, uint wethAmt);
521 
522     function createAndBuyAllAmountBuyEth(
523         DSProxyFactory factory, 
524         OtcInterface otc, 
525         uint wethAmt, 
526         ERC20 payToken, 
527         uint maxPayAmt) public returns (DSProxy proxy, uint payAmt);
528 } 
529 
530 interface OasisDirectInterface {
531     
532     function sellAllAmount(
533         OtcInterface otc, 
534         ERC20 payToken, 
535         uint payAmt, 
536         ERC20 buyToken,
537         uint minBuyAmt) public 
538         returns (uint buyAmt);
539 
540     function sellAllAmountPayEth(
541         OtcInterface otc, 
542         ERC20 buyToken, 
543         uint minBuyAmt) public payable returns (uint buyAmt);
544 
545     function sellAllAmountBuyEth(
546         OtcInterface otc, 
547         ERC20 payToken, 
548         uint payAmt, 
549         uint minBuyAmt) public returns (uint wethAmt);
550 
551     function buyAllAmount(
552         OtcInterface otc, 
553         ERC20 buyToken, 
554         uint buyAmt, 
555         ERC20 payToken, 
556         uint maxPayAmt) public returns (uint payAmt);
557 
558     function buyAllAmountPayEth(
559         OtcInterface otc, 
560         ERC20 buyToken, 
561         uint buyAmt) public payable returns (uint wethAmt);
562 
563     function buyAllAmountBuyEth(
564         OtcInterface otc, 
565         uint wethAmt, 
566         ERC20 payToken, 
567         uint maxPayAmt) public returns (uint payAmt);
568 }
569 
570 contract WETH is ERC20 {
571     function deposit() public payable;
572     function withdraw(uint wad) public;
573 }
574 
575 /**
576     A contract to help creating creating CDPs in MakerDAO's system
577     The motivation for this is simply to save time and automate some steps for people who
578     want to create CDPs often
579 */
580 contract CDPer is DSStop, DSMath {
581 
582     ///Main Net\\\
583     uint public slippage = WAD / 50;//2%
584     TubInterface public tub = TubInterface(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
585     DSToken public dai = DSToken(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);  // Stablecoin
586     DSToken public skr = DSToken(0xf53AD2c6851052A81B42133467480961B2321C09);  // Abstracted collateral - PETH
587     WETH public gem = WETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);  // Underlying collateral - WETH
588     DSToken public gov = DSToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);  // MKR Token
589     DSValue public feed = DSValue(0x729D19f657BD0614b4985Cf1D82531c67569197B);  // Price feed
590     OtcInterface public otc = OtcInterface(0x14FBCA95be7e99C15Cc2996c6C9d841e54B79425);
591 
592     ///Kovan test net\\\
593     ///This is the acceptable price difference when exchanging at the otc. 0.01 * 10^18 == 1% acceptable slippage 
594     // uint public slippage = 99*10**16;//99%
595     // TubInterface public tub = TubInterface(0xa71937147b55Deb8a530C7229C442Fd3F31b7db2);
596     // DSToken public dai = DSToken(0xC4375B7De8af5a38a93548eb8453a498222C4fF2);  // Stablecoin
597     // DSToken public skr = DSToken(0xf4d791139cE033Ad35DB2B2201435fAd668B1b64);  // Abstracted collateral - PETH
598     // DSToken public gov = DSToken(0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD);  // MKR Token
599     // WETH public gem = WETH(0xd0A1E359811322d97991E03f863a0C30C2cF029C);  // Underlying collateral - WETH
600     // DSValue public feed = DSValue(0xA944bd4b25C9F186A846fd5668941AA3d3B8425F);  // Price feed
601     // OtcInterface public otc = OtcInterface(0x8cf1Cab422A0b6b554077A361f8419cDf122a9F9);
602 
603     ///You won't be able to create a CDP or trade less than these values
604     uint public minETH = WAD / 20; //0.05 ETH
605     uint public minDai = WAD * 50; //50 Dai
606 
607     //if you recursively want to invest your CDP, this will be the target liquidation price
608     uint public liquidationPriceWad = 320 * WAD;
609 
610     /// liquidation ratio from Maker tub (can be updated manually)
611     uint ratio;
612 
613     function CDPer() public {
614 
615     }
616 
617     /**
618      @notice Sets all allowances and updates tub liquidation ratio
619      */
620     function init() public auth {
621         gem.approve(tub, uint(-1));
622         skr.approve(tub, uint(-1));
623         dai.approve(tub, uint(-1));
624         gov.approve(tub, uint(-1));
625         
626         gem.approve(owner, uint(-1));
627         skr.approve(owner, uint(-1));
628         dai.approve(owner, uint(-1));
629         gov.approve(owner, uint(-1));
630 
631         dai.approve(otc, uint(-1));
632         gem.approve(otc, uint(-1));
633 
634         tubParamUpdate();
635     }
636 
637     /**
638      @notice updates tub liquidation ratio
639      */
640     function tubParamUpdate() public auth {
641         ratio = tub.mat() / 10**9; //liquidation ratio
642     }
643 
644      /**
645      @notice create a CDP and join with the ETH sent to this function
646      @dev This function wraps ETH, converts to PETH, creates a CDP, joins with the PETH created and gives the CDP to the sender. Will revert if there's not enough WETH to buy with the acceptable slippage
647      */
648     function createAndJoinCDP() public stoppable payable returns(bytes32 id) {
649 
650         require(msg.value >= minETH);
651 
652         gem.deposit.value(msg.value)();
653         
654         id = _openAndJoinCDPWETH(msg.value);
655 
656         tub.give(id, msg.sender);
657     }
658 
659     /**
660      @notice create a CDP from all the Dai in the sender's balance - needs Dai transfer approval
661      @dev this function will sell the Dai at otc for weth and then do the same as create and JoinCDP.  Will revert if there's not enough WETH to buy with the acceptable slippage
662      */
663     function createAndJoinCDPAllDai() public returns(bytes32 id) {
664         return createAndJoinCDPDai(dai.balanceOf(msg.sender));
665     }
666 
667     /**
668      @notice create a CDP from the given amount of Dai in the sender's balance - needs Dai transfer approval
669      @dev this function will sell the Dai at otc for weth and then do the same as create and JoinCDP.  Will revert if there's not enough WETH to buy with the acceptable slippage
670      @param amount - dai to transfer from the sender's balance (needs approval)
671      */
672     function createAndJoinCDPDai(uint amount) public auth stoppable returns(bytes32 id) {
673         require(amount >= minDai);
674 
675         uint price = uint(feed.read());
676 
677         require(dai.transferFrom(msg.sender, this, amount));
678 
679         uint bought = otc.sellAllAmount(dai, amount,
680             gem, wmul(WAD - slippage, wdiv(amount, price)));
681         
682         id = _openAndJoinCDPWETH(bought);
683         
684         tub.give(id, msg.sender);
685     }
686 
687 
688     /**
689      @notice create a CDP from the ETH sent, and then create Dai and reinvest it in the CDP until the target liquidation price is reached (or the minimum investment amount)
690      @dev same as openAndJoinCDP, but then draw and reinvest dai. Will revert if trades are not possible.
691      */
692     function createCDPLeveraged() public auth stoppable payable returns(bytes32 id) {
693         require(msg.value >= minETH);
694 
695         uint price = uint(feed.read());
696 
697         gem.deposit.value(msg.value)();
698 
699         id = _openAndJoinCDPWETH(msg.value);
700 
701         while(_reinvest(id, price)) {}
702 
703         tub.give(id, msg.sender);
704     }
705 
706     /**
707      @notice create a CDP all the Dai in the sender's balance (needs approval), and then create Dai and reinvest it in the CDP until the target liquidation price is reached (or the minimum investment amount)
708      @dev same as openAndJoinCDPDai, but then draw and reinvest dai. Will revert if trades are not possible.
709      */
710     function createCDPLeveragedAllDai() public returns(bytes32 id) {
711         return createCDPLeveragedDai(dai.balanceOf(msg.sender)); 
712     }
713     
714     /**
715      @notice create a CDP the given amount of Dai in the sender's balance (needs approval), and then create Dai and reinvest it in the CDP until the target liquidation price is reached (or the minimum investment amount)
716      @dev same as openAndJoinCDPDai, but then draw and reinvest dai. Will revert if trades are not possible.
717      */
718     function createCDPLeveragedDai(uint amount) public auth stoppable returns(bytes32 id) {
719 
720         require(amount >= minDai);
721 
722         uint price = uint(feed.read());
723 
724         require(dai.transferFrom(msg.sender, this, amount));
725         uint bought = otc.sellAllAmount(dai, amount,
726             gem, wmul(WAD - slippage, wdiv(amount, price)));
727 
728         id = _openAndJoinCDPWETH(bought);
729 
730         while(_reinvest(id, price)) {}
731 
732         tub.give(id, msg.sender);
733     }
734 
735     /**
736      @notice Shuts a CDP and returns the value in the form of ETH. You need to give permission for the amount of debt in Dai, so that the contract will draw it from your account. You need to give the CDP to this contract before using this function. You also need to send a small amount of MKR to this contract so that the fee can be paid.
737      @dev this function pays all debt(from the sender's account) and fees(there must be enough MKR present on this account), then it converts PETH to WETH, and then WETH to ETH, finally it sends the balance to the sender
738      @param _id id of the CDP to shut - it must be given to this contract
739      */
740     function shutForETH(uint _id) public auth stoppable {
741         bytes32 id = bytes32(_id);
742         uint debt = tub.tab(id);
743         if (debt > 0) {
744             require(dai.transferFrom(msg.sender, this, debt));
745         }
746         uint ink = tub.ink(id);// locked collateral
747         tub.shut(id);
748         uint gemBalance = tub.bid(ink);
749         tub.exit(ink);
750 
751         gem.withdraw(min(gemBalance, gem.balanceOf(this)));
752         
753         msg.sender.transfer(min(gemBalance, address(this).balance));
754     }
755 
756     /**
757      @notice shuts the CDP and returns all the value in the form of Dai. You need to give permission for the amount of debt in Dai, so that the contract will draw it from your account. You need to give the CDP to this contract before using this function. You also need to send a small amount of MKR to this contract so that the fee can be paid.
758      @dev this function pays all debt(from the sender's account) and fees(there must be enough MKR present on this account), then it converts PETH to WETH, then trades WETH for Dai, and sends it to the sender
759      @param _id id of the CDP to shut - it must be given to this contract
760      */
761     function shutForDai(uint _id) public auth stoppable {
762         bytes32 id = bytes32(_id);
763         uint debt = tub.tab(id);
764         if (debt > 0) {
765             require(dai.transferFrom(msg.sender, this, debt));
766         }
767         uint ink = tub.ink(id);// locked collateral
768         tub.shut(id);
769         uint gemBalance = tub.bid(ink);
770         tub.exit(ink);
771 
772         uint price = uint(feed.read());
773 
774         uint bought = otc.sellAllAmount(gem, min(gemBalance, gem.balanceOf(this)), 
775             dai, wmul(WAD - slippage, wmul(gemBalance, price)));
776         
777         require(dai.transfer(msg.sender, bought));
778     }
779 
780     /**
781      @notice give ownership of a CDP back to the sender
782      @param id id of the CDP owned by this contract
783      */
784     function giveMeCDP(uint id) public auth {
785         tub.give(bytes32(id), msg.sender);
786     }
787 
788     /**
789      @notice transfer any token from this contract to the sender
790      @param token : token contract address
791      */
792     function giveMeToken(DSToken token) public auth {
793         token.transfer(msg.sender, token.balanceOf(this));
794     }
795 
796     /**
797      @notice transfer all ETH balance from this contract to the sender
798      */
799     function giveMeETH() public auth {
800         msg.sender.transfer(address(this).balance);
801     }
802 
803     /**
804      @notice transfer all ETH balance from this contract to the sender and destroy the contract. Must be stopped
805      */
806     function destroy() public auth {
807         require(stopped);
808         selfdestruct(msg.sender);
809     }
810 
811     /**
812      @notice set the acceptable price slippage for trades.
813      @param slip E.g: 0.01 * 10^18 == 1% acceptable slippage 
814      */
815     function setSlippage(uint slip) public auth {
816         require(slip < WAD);
817         slippage = slip;
818     }
819 
820     /**
821      @notice set the target liquidation price for leveraged CDPs created 
822      @param wad E.g. 300 * 10^18 == 300 USD target liquidation price
823      */
824     function setLiqPrice(uint wad) public auth {        
825         liquidationPriceWad = wad;
826     }
827 
828     /**
829      @notice set the minimal ETH for trades (depends on otc)
830      @param wad minimal ETH to trade
831      */
832     function setMinETH(uint wad) public auth {
833         minETH = wad;
834     }
835 
836     /**
837      @notice set the minimal Dai for trades (depends on otc)
838      @param wad minimal Dai to trade
839      */
840     function setMinDai(uint wad) public auth {
841         minDai = wad;
842     }
843 
844     function setTub(TubInterface _tub) public auth {
845         tub = _tub;
846     }
847 
848     function setDai(DSToken _dai) public auth {
849         dai = _dai;
850     }
851 
852     function setSkr(DSToken _skr) public auth {
853         skr = _skr;
854     }
855     function setGov(DSToken _gov) public auth {
856         gov = _gov;
857     }
858     function setGem(WETH _gem) public auth {
859         gem = _gem;
860     }
861     function setFeed(DSValue _feed) public auth {
862         feed = _feed;
863     }
864     function setOTC(OtcInterface _otc) public auth {
865         otc = _otc;
866     }
867 
868     function _openAndJoinCDPWETH(uint amount) internal returns(bytes32 id) {
869         id = tub.open();
870 
871         _joinCDP(id, amount);
872     }
873 
874     function _joinCDP(bytes32 id, uint amount) internal {
875 
876         uint skRate = tub.ask(WAD);
877         
878         uint valueSkr = wdiv(amount, skRate);
879 
880         tub.join(valueSkr); 
881 
882         tub.lock(id, min(valueSkr, skr.balanceOf(this)));
883     }
884 
885     function _reinvest(bytes32 id, uint latestPrice) internal returns(bool ok) {
886         
887         // Cup memory cup = tab.cups(id);
888         uint debt = tub.tab(id);
889         uint ink = tub.ink(id);// locked collateral
890         
891         uint maxInvest = wdiv(wmul(liquidationPriceWad, ink), ratio);
892         
893         if(debt >= maxInvest) {
894             return false;
895         }
896         
897         uint leftOver = sub(maxInvest, debt);
898         
899         if(leftOver >= minDai) {
900             tub.draw(id, leftOver);
901 
902             uint bought = otc.sellAllAmount(dai, min(leftOver, dai.balanceOf(this)),
903                 gem, wmul(WAD - slippage, wdiv(leftOver, latestPrice)));
904             
905             _joinCDP(id, bought);
906 
907             return true;
908         } else {
909             return false;
910         }
911     }
912 
913 }
914 
915 contract CDPerFactory {
916     event Created(address indexed sender, address cdper);
917     mapping(address=>bool) public isCDPer;
918 
919     // deploys a new CDPer instance
920     // sets owner of CDPer to caller
921     function build() public returns (CDPer cdper) {
922         cdper = build(msg.sender);
923     }
924 
925     // deploys a new CDPer instance
926     // sets custom owner of CDPer
927     function build(address owner) public returns (CDPer cdper) {
928         cdper = new CDPer();
929         emit Created(owner, address(cdper));
930         cdper.setOwner(owner);
931         isCDPer[cdper] = true;
932     }
933 }