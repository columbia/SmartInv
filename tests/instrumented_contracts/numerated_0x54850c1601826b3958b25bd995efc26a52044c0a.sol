1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function totalSupply() constant public returns (uint supply);
5     function balanceOf( address who ) constant public returns (uint value);
6     function allowance( address owner, address spender ) constant public returns (uint _allowance);
7 
8     function transfer( address to, uint value) public returns (bool ok);
9     function transferFrom( address from, address to, uint value) public returns (bool ok);
10     function approve( address spender, uint value ) public returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSNote {
17     event LogNote(
18         bytes4   indexed  sig,
19         address  indexed  guy,
20         bytes32  indexed  foo,
21         bytes32  indexed  bar,
22         uint              wad,
23         bytes             fax
24     ) anonymous;
25 
26     modifier note {
27         bytes32 foo;
28         bytes32 bar;
29 
30         assembly {
31             foo := calldataload(4)
32             bar := calldataload(36)
33         }
34 
35         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
36 
37         _;
38     }
39 }
40 
41 contract DSAuthority {
42     function canCall(
43         address src, address dst, bytes4 sig
44     ) constant public returns (bool);
45 }
46 
47 contract DSAuthEvents {
48     event LogSetAuthority (address indexed authority);
49     event LogSetOwner     (address indexed owner);
50 }
51 
52 contract DSAuth is DSAuthEvents {
53     DSAuthority  public  authority;
54     address      public  owner;
55 
56     constructor() public {
57         owner = msg.sender;
58         emit LogSetOwner(msg.sender);
59     }
60 
61     function setOwner(address owner_) public
62         auth
63     {
64         require(owner_ != address(0));
65         
66         owner = owner_;
67         emit LogSetOwner(owner);
68     }
69 
70     function setAuthority(DSAuthority authority_) public
71         auth
72     {
73         authority = authority_;
74         emit LogSetAuthority(authority);
75     }
76 
77     modifier auth {
78         assert(isAuthorized(msg.sender, msg.sig));
79         _;
80     }
81 
82     modifier authorized(bytes4 sig) {
83         assert(isAuthorized(msg.sender, sig));
84         _;
85     }
86 
87     function isAuthorized(address src, bytes4 sig) view internal returns (bool) {
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
98 }
99 
100 contract DSStop is DSAuth, DSNote {
101 
102     bool public stopped;
103 
104     modifier stoppable {
105         assert (!stopped);
106         _;
107     }
108     
109     function stop() public auth note {
110         stopped = true;
111     }
112     
113     function start() public auth note {
114         stopped = false;
115     }
116 
117 }
118 
119 contract DSMath {
120     
121     /*
122     standard uint256 functions
123      */
124 
125     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
126         assert((z = x + y) >= x);
127     }
128 
129     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
130         assert((z = x - y) <= x);
131     }
132 
133     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
134         assert((z = x * y) >= x);
135     }
136 
137     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
138         z = x / y;
139     }
140 
141     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
142         return x <= y ? x : y;
143     }
144     
145     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
146         return x >= y ? x : y;
147     }
148     
149 
150     /*
151     uint128 functions (h is for half)
152      */
153 
154     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
155         assert((z = x + y) >= x);
156     }
157 
158     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
159         assert((z = x - y) <= x);
160     }
161 
162     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
163         assert((z = x * y) >= x);
164     }
165 
166     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
167         z = x / y;
168     }
169 
170     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
171         return x <= y ? x : y;
172     }
173     
174     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
175         return x >= y ? x : y;
176     }
177 
178 
179     /*
180     int256 functions
181      */
182 
183     function imin(int256 x, int256 y) pure internal returns (int256 z) {
184         return x <= y ? x : y;
185     }
186     
187     function imax(int256 x, int256 y) pure internal returns (int256 z) {
188         return x >= y ? x : y;
189     }
190 
191     /*
192     WAD math
193      */
194 
195     uint128 constant WAD = 10 ** 18;
196 
197     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
198         return hadd(x, y);
199     }
200 
201     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
202         return hsub(x, y);
203     }
204 
205     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
206         z = cast((uint256(x) * y + WAD / 2) / WAD);
207     }
208 
209     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
210         z = cast((uint256(x) * WAD + y / 2) / y);
211     }
212 
213     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
214         return hmin(x, y);
215     }
216     
217     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
218         return hmax(x, y);
219     }
220 
221     /*
222     RAY math
223      */
224 
225     uint128 constant RAY = 10 ** 27;
226 
227     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
228         return hadd(x, y);
229     }
230 
231     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
232         return hsub(x, y);
233     }
234 
235     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
236         z = cast((uint256(x) * y + RAY / 2) / RAY);
237     }
238 
239     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
240         z = cast((uint256(x) * RAY + y / 2) / y);
241     }
242 
243     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
244         // This famous algorithm is called "exponentiation by squaring"
245         // and calculates x^n with x as fixed-point and n as regular unsigned.
246         //
247         // It's O(log n), instead of O(n) for naive repeated multiplication.
248         //
249         // These facts are why it works:
250         //
251         //  If n is even, then x^n = (x^2)^(n/2).
252         //  If n is odd,  then x^n = x * x^(n-1),
253         //   and applying the equation for even x gives
254         //    x^n = x * (x^2)^((n-1) / 2).
255         //
256         //  Also, EVM division is flooring and
257         //    floor[(n-1) / 2] = floor[n / 2].
258 
259         z = n % 2 != 0 ? x : RAY;
260 
261         for (n /= 2; n != 0; n /= 2) {
262             x = rmul(x, x);
263 
264             if (n % 2 != 0) {
265                 z = rmul(z, x);
266             }
267         }
268     }
269 
270     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
271         return hmin(x, y);
272     }
273     
274     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
275         return hmax(x, y);
276     }
277 
278     function cast(uint256 x) pure internal returns (uint128 z) {
279         assert((z = uint128(x)) == x);
280     }
281 
282 }
283 
284 contract DSTokenBase is ERC20, DSMath {
285     uint256                                            _supply;
286     mapping (address => uint256)                       _balances;
287     mapping (address => mapping (address => uint256))  _approvals;
288     
289     
290     constructor(uint256 supply) public {
291         _balances[msg.sender] = supply;
292         _supply = supply;
293     }
294     
295     function totalSupply() public constant returns (uint256) {
296         return _supply;
297     }
298     
299     function balanceOf(address src) public constant returns (uint256) {
300         return _balances[src];
301     }
302     
303     function allowance(address src, address guy) public constant returns (uint256) {
304         return _approvals[src][guy];
305     }
306     
307     function transfer(address dst, uint wad) public returns (bool) {
308         assert(_balances[msg.sender] >= wad);
309         
310         _balances[msg.sender] = sub(_balances[msg.sender], wad);
311         _balances[dst] = add(_balances[dst], wad);
312         
313         emit Transfer(msg.sender, dst, wad);
314         
315         return true;
316     }
317     
318     function transferFrom(address src, address dst, uint wad) public returns (bool) {
319         assert(_balances[src] >= wad);
320         assert(_approvals[src][msg.sender] >= wad);
321         
322         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
323         _balances[src] = sub(_balances[src], wad);
324         _balances[dst] = add(_balances[dst], wad);
325         
326         emit Transfer(src, dst, wad);
327         
328         return true;
329     }
330     
331     function approve(address guy, uint256 wad) public returns (bool) {
332         _approvals[msg.sender][guy] = wad;
333         
334         emit Approval(msg.sender, guy, wad);
335         
336         return true;
337     }
338 }
339 
340 contract DSToken is DSTokenBase(0), DSStop {
341 
342     string public name = "ERC20 CES";
343     string public symbol = "CES"; // token name
344     uint8  public decimals = 0;   // standard token precision
345 
346     function transfer(address dst, uint wad) public stoppable note returns (bool) {
347         return super.transfer(dst, wad);
348     }
349     
350     function transferFrom(address src, address dst, uint wad) 
351         public stoppable note returns (bool) {
352         return super.transferFrom(src, dst, wad);
353     }
354     
355     function approve(address guy, uint wad) public stoppable note returns (bool) {
356         return super.approve(guy, wad);
357     }
358 
359     function push(address dst, uint128 wad) public returns (bool) {
360         return transfer(dst, wad);
361     }
362     
363     function pull(address src, uint128 wad) public returns (bool) {
364         return transferFrom(src, msg.sender, wad);
365     }
366 
367     function mint(uint128 wad) public auth stoppable note {
368         _balances[msg.sender] = add(_balances[msg.sender], wad);
369         _supply = add(_supply, wad);
370     }
371 
372     function burn(uint128 wad) public auth stoppable note {
373         _balances[msg.sender] = sub(_balances[msg.sender], wad);
374         _supply = sub(_supply, wad);
375     }
376     
377     /*
378     function setName(string name_, string symbol_) public auth {
379         name = name_;
380         symbol = symbol_;
381     }
382     */
383 }
384 
385 
386 contract CESVendue is DSAuth, DSMath {
387     
388     DSToken public CES;
389     
390     uint public totalETH;      // total ETH was got by vendue
391     uint public price;         // vendue Reserve price
392     
393     uint32 public iaSupply;    // total initialize account for vendue
394     uint32 public iaLeft;      // how many initialize account was left
395     
396     struct accountInfo {
397         // vendue ETH
398         uint ethVendue;
399         
400         // The account name used at CES block chain ecocsystem
401         string accountName;
402         // The public key used for your account
403         string publicKey;
404         // The pinblock used for your account calc by your password
405         string pinblock;
406     }
407     
408     struct elfInfo {
409         // whether get the elf
410         bool bGetElf;
411         
412         // The elf sex
413         uint8 elfSex;
414         // The elf type
415         uint16 elfType;
416     }
417     
418     mapping (address => elfInfo)     public elfInfos;
419     mapping (address => accountInfo) public initAccInfos; //   init account
420     mapping (address => string)      public commonAccs;   // common account
421     
422     address public godOwner;// the owner who got the god after vendue was closed
423     uint16  public godID;   // god owner select his god
424     
425     bool public vendueClose = false;
426     bool public tokenFreeze = false;
427     
428     address[] public addrLists;
429     
430     uint startLine;
431     
432     
433     event LogFund(address backer, uint amount, bool isContribution, uint gift);
434     event LogFreeze();
435     event LogElf(address user, uint8 elfSex, uint16 elfType);
436     event LogGod(address owner, uint16 godID);
437     event LogInitAcc(address user, string account, string key, string pin);
438     event LogRegister(address user, string key, uint token);
439     
440 
441     constructor() public {
442         iaSupply = 20000;
443         iaLeft = iaSupply;
444         startLine = now;
445         price = 5 ether;
446     }
447     
448     function initialize(DSToken tokenReward) public auth {
449         assert(address(CES) == address(0));
450         assert(tokenReward.owner() == address(this));
451         assert(tokenReward.authority() == DSAuthority(0));
452         assert(tokenReward.totalSupply() == 0);
453         
454         uint128 totalIssue     = 1000000000; //   1 billion coin total issue
455         uint128 coinDisable    =  600000000; // 0.6 billion coin for disable
456         uint128 coinContribute =  200000000; // 0.2 billion coin for contribute
457       //uint128 coinGiftA      =  100000000; // 0.1 billion coin gift for vendue
458         uint128 coinGiftB      =  100000000; // 0.1 billion coin for chain, APP, airdrops
459                                              
460         startLine = now;
461         
462         CES = tokenReward;
463         CES.mint(totalIssue);
464         CES.push(0x00, hadd(coinDisable, coinContribute));
465         CES.push(msg.sender, coinGiftB);
466     }
467     
468     function setPrice(uint price_) external auth {
469         require(!vendueClose);
470         
471         price = price_;
472     }
473     
474     function balanceToken() public view returns (uint256) {
475         assert(address(CES) != address(0));
476         
477         return CES.balanceOf(this);
478     }
479     
480     function todayDays() public view returns (uint) {
481         return (div(sub(now, startLine), 1 days) + 1);
482     }
483 
484     function () public payable {
485         require(!vendueClose);
486         require(iaLeft > 0);
487         require(msg.value >= price);
488         require(initAccInfos[msg.sender].ethVendue == 0);
489         
490         uint money = msg.value;
491         initAccInfos[msg.sender].ethVendue = money;
492         totalETH = add(totalETH, money);
493         
494         iaLeft--;
495         
496         // release period is 7 day 
497         // elf gift at first month
498         uint dayNow = todayDays();
499         if(dayNow <= (30 + 7)) {
500             elfInfos[msg.sender].bGetElf = true;
501         }
502         
503         uint coinNeed;
504         uint giftLeft = balanceToken();
505         
506         // coin gift by initialize account
507         if(dayNow <= (90 + 7)) {
508             if(giftLeft >= 3500) {
509                 coinNeed = 3500;
510             }
511         }
512         else {
513             if(giftLeft >= 2000) {
514                 coinNeed = 2000;
515             }
516         }
517         
518         // coin gift by overflow ETH
519         if(money > price) {
520             uint multiple = div(sub(money, price), 1 ether);
521             uint moreGift = mul(multiple, 800);
522 
523             if(moreGift > 0 && (sub(giftLeft, coinNeed) >= moreGift)) {
524                 coinNeed = add(coinNeed, moreGift);
525             }
526         }
527 
528         if(coinNeed > 0) {
529             CES.transfer(msg.sender, coinNeed);
530         }
531         
532         pushAddr(msg.sender);
533         
534         emit LogFund(msg.sender, money, true, coinNeed);
535     }
536     
537     function withdrawal() external auth {
538         
539         uint takeNow = sub(address(this).balance, 1 finney);
540         
541         if(takeNow > 0) {
542             if (msg.sender.send(takeNow)) {
543                 emit LogFund(msg.sender, takeNow, false, 0);
544             }
545         } 
546     }
547     
548     function vendueClosed() external auth {
549         vendueClose = true;
550         distillGodOwner();
551     }
552     
553     function freezeToken() external auth {
554         require(vendueClose);
555 
556         tokenFreeze = true;
557         CES.stop();
558         
559         emit LogFreeze();
560     }
561     
562     function distillGodOwner() public auth {
563         require(vendueClose);
564 
565         uint ethHighest = 0;
566         address addrHighest = address(0);
567         
568         address addr;
569         for(uint i = 0; i < addrLists.length; i++) {
570             addr = addrLists[i];
571             
572             if(address(addr) == address(0)) {
573                 continue;
574             }
575             
576             if(initAccInfos[addr].ethVendue > ethHighest) {
577                 ethHighest  = initAccInfos[addr].ethVendue;
578                 addrHighest = addr;
579             }
580         }
581         
582         godOwner = addrHighest;
583     }
584     
585     function pushAddr(address dst) internal {
586 
587         bool bExist = false;
588         address addr;
589         for(uint i = 0; i < addrLists.length; i++) {
590             addr = addrLists[i];
591             
592             if(address(addr) == address(dst)) {
593                 bExist = true;
594                 break;
595             }
596         }
597         
598         if(!bExist)
599         {
600             addrLists.push(dst);
601         }
602     }
603     
604     // Do this after we provide elf type to you select
605     function selectElf(uint8 elfSex, uint16 elfType) external {
606         require(elfInfos[msg.sender].bGetElf);
607 
608         elfInfos[msg.sender].elfSex = elfSex;
609         elfInfos[msg.sender].elfType = elfType;
610     
611         emit LogElf(msg.sender, elfSex, elfType);
612     }
613     
614     // Do this after we provide god to you select
615     function selectGod(uint16 godID_) external {
616         require(vendueClose);
617         require(msg.sender == godOwner);
618 
619         godID = godID_;
620         
621         emit LogGod(godOwner, godID);
622     }
623     
624     // Do this after we provide tool to produce public key and encrypt your password
625     function regInitAccount(string account, string publicKey, string pinblock) external {
626         require(initAccInfos[msg.sender].ethVendue > 0);
627 
628         assert(bytes(account).length <= 10 && bytes(account).length >= 2);
629         assert(bytes(publicKey).length <= 128); //maybe public key is 64 bytes
630         assert(bytes(pinblock).length == 16 || bytes(pinblock).length == 32);
631 
632         initAccInfos[msg.sender].accountName = account;
633         initAccInfos[msg.sender].publicKey = publicKey;
634         initAccInfos[msg.sender].pinblock = pinblock;
635     
636         emit LogInitAcc(msg.sender, account, publicKey, pinblock);
637     }
638     
639     // register your account then tell me your public key for transform token to coin
640     // init account don't need to do this
641     function register(string publicKey) external {
642         require(tokenFreeze);
643 
644         assert(bytes(publicKey).length <= 128); //maybe public key is 64 bytes
645 
646         commonAccs[msg.sender] = publicKey;
647         
648         uint token = CES.balanceOf(msg.sender);
649         emit LogRegister(msg.sender, publicKey, token);
650     }
651     
652 }