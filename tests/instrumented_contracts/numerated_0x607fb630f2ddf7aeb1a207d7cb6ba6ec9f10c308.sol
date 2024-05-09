1 pragma solidity ^0.4.11;
2 
3 contract DSNote {
4     event LogNote(
5     bytes4   indexed  sig,
6     address  indexed  guy,
7     bytes32  indexed  foo,
8     bytes32  indexed  bar,
9     uint	 	  wad,
10     bytes             fax
11     ) anonymous;
12 
13     modifier note {
14         bytes32 foo;
15         bytes32 bar;
16 
17         assembly {
18         foo := calldataload(4)
19         bar := calldataload(36)
20         }
21 
22         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
23 
24         _;
25     }
26 }
27 
28 contract ERC20 {
29     function totalSupply() constant returns (uint supply);
30     function balanceOf( address who ) constant returns (uint value);
31     function allowance( address owner, address spender ) constant returns (uint _allowance);
32 
33     function transfer( address to, uint value) returns (bool ok);
34     function transferFrom( address from, address to, uint value) returns (bool ok);
35     function approve( address spender, uint value ) returns (bool ok);
36 
37     event Transfer( address indexed from, address indexed to, uint value);
38     event Approval( address indexed owner, address indexed spender, uint value);
39 }
40 
41 contract DSAuthority {
42     function canCall(
43     address src, address dst, bytes4 sig
44     ) constant returns (bool);
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
56     function DSAuth() {
57         owner = msg.sender;
58         LogSetOwner(msg.sender);
59     }
60 
61     function setOwner(address owner_)
62     auth
63     {
64         owner = owner_;
65         LogSetOwner(owner);
66     }
67 
68     function setAuthority(DSAuthority authority_)
69     auth
70     {
71         authority = authority_;
72         LogSetAuthority(authority);
73     }
74 
75     modifier auth {
76         assert(isAuthorized(msg.sender, msg.sig));
77         _;
78     }
79 
80     modifier authorized(bytes4 sig) {
81         assert(isAuthorized(msg.sender, sig));
82         _;
83     }
84 
85     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
86         if (src == address(this)) {
87             return true;
88         } else if (src == owner) {
89             return true;
90         } else if (authority == DSAuthority(0)) {
91             return false;
92         } else {
93             return authority.canCall(src, this, sig);
94         }
95     }
96 
97     function assert(bool x) internal {
98         if (!x) revert();
99     }
100 }
101 
102 contract DSExec {
103     function tryExec( address target, bytes calldata, uint value)
104     internal
105     returns (bool call_ret)
106     {
107         return target.call.value(value)(calldata);
108     }
109     function exec( address target, bytes calldata, uint value)
110     internal
111     {
112         if(!tryExec(target, calldata, value)) {
113             revert();
114         }
115     }
116 
117     // Convenience aliases
118     function exec( address t, bytes c )
119     internal
120     {
121         exec(t, c, 0);
122     }
123     function exec( address t, uint256 v )
124     internal
125     {
126         bytes memory c; exec(t, c, v);
127     }
128     function tryExec( address t, bytes c )
129     internal
130     returns (bool)
131     {
132         return tryExec(t, c, 0);
133     }
134     function tryExec( address t, uint256 v )
135     internal
136     returns (bool)
137     {
138         bytes memory c; return tryExec(t, c, v);
139     }
140 }
141 
142 contract DSMath {
143 
144     /*
145     standard uint256 functions
146      */
147 
148     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
149         assert((z = x + y) >= x);
150     }
151 
152     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
153         assert((z = x - y) <= x);
154     }
155 
156     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
157         assert((z = x * y) >= x);
158     }
159 
160     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
161         z = x / y;
162     }
163 
164     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
165         return x <= y ? x : y;
166     }
167     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
168         return x >= y ? x : y;
169     }
170 
171     /*
172     uint128 functions (h is for half)
173      */
174 
175 
176     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
177         assert((z = x + y) >= x);
178     }
179 
180     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         assert((z = x - y) <= x);
182     }
183 
184     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
185         assert((z = x * y) >= x);
186     }
187 
188     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
189         z = x / y;
190     }
191 
192     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
193         return x <= y ? x : y;
194     }
195     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
196         return x >= y ? x : y;
197     }
198 
199 
200     /*
201     int256 functions
202      */
203 
204     function imin(int256 x, int256 y) constant internal returns (int256 z) {
205         return x <= y ? x : y;
206     }
207     function imax(int256 x, int256 y) constant internal returns (int256 z) {
208         return x >= y ? x : y;
209     }
210 
211     /*
212     WAD math
213      */
214 
215     uint128 constant WAD = 10 ** 18;
216 
217     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
218         return hadd(x, y);
219     }
220 
221     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
222         return hsub(x, y);
223     }
224 
225     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
226         z = cast((uint256(x) * y + WAD / 2) / WAD);
227     }
228 
229     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
230         z = cast((uint256(x) * WAD + y / 2) / y);
231     }
232 
233     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
234         return hmin(x, y);
235     }
236     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
237         return hmax(x, y);
238     }
239 
240     /*
241     RAY math
242      */
243 
244     uint128 constant RAY = 10 ** 27;
245 
246     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
247         return hadd(x, y);
248     }
249 
250     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
251         return hsub(x, y);
252     }
253 
254     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
255         z = cast((uint256(x) * y + RAY / 2) / RAY);
256     }
257 
258     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
259         z = cast((uint256(x) * RAY + y / 2) / y);
260     }
261 
262     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
263         // This famous algorithm is called "exponentiation by squaring"
264         // and calculates x^n with x as fixed-point and n as regular unsigned.
265         //
266         // It's O(log n), instead of O(n) for naive repeated multiplication.
267         //
268         // These facts are why it works:
269         //
270         //  If n is even, then x^n = (x^2)^(n/2).
271         //  If n is odd,  then x^n = x * x^(n-1),
272         //   and applying the equation for even x gives
273         //    x^n = x * (x^2)^((n-1) / 2).
274         //
275         //  Also, EVM division is flooring and
276         //    floor[(n-1) / 2] = floor[n / 2].
277 
278         z = n % 2 != 0 ? x : RAY;
279 
280         for (n /= 2; n != 0; n /= 2) {
281             x = rmul(x, x);
282 
283             if (n % 2 != 0) {
284                 z = rmul(z, x);
285             }
286         }
287     }
288 
289     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
290         return hmin(x, y);
291     }
292     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
293         return hmax(x, y);
294     }
295 
296     function cast(uint256 x) constant internal returns (uint128 z) {
297         assert((z = uint128(x)) == x);
298     }
299 
300 }
301 
302 contract DSStop is DSAuth, DSNote {
303 
304     bool public stopped;
305 
306     modifier stoppable {
307         assert (!stopped);
308         _;
309     }
310     function stop() auth note {
311         stopped = true;
312     }
313     function start() auth note {
314         stopped = false;
315     }
316 
317 }
318 
319 contract DSTokenBase is ERC20, DSMath {
320     uint256                                            _supply;
321     mapping (address => uint256)                       _balances;
322     mapping (address => mapping (address => uint256))  _approvals;
323 
324     function DSTokenBase(uint256 supply) {
325         _balances[msg.sender] = supply;
326         _supply = supply;
327     }
328 
329     function totalSupply() constant returns (uint256) {
330         return _supply;
331     }
332     function balanceOf(address src) constant returns (uint256) {
333         return _balances[src];
334     }
335     function allowance(address src, address guy) constant returns (uint256) {
336         return _approvals[src][guy];
337     }
338 
339     function transfer(address dst, uint wad) returns (bool) {
340         assert(_balances[msg.sender] >= wad);
341 
342         _balances[msg.sender] = sub(_balances[msg.sender], wad);
343         _balances[dst] = add(_balances[dst], wad);
344 
345         Transfer(msg.sender, dst, wad);
346 
347         return true;
348     }
349 
350     function transferFrom(address src, address dst, uint wad) returns (bool) {
351         assert(_balances[src] >= wad);
352         assert(_approvals[src][msg.sender] >= wad);
353 
354         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
355         _balances[src] = sub(_balances[src], wad);
356         _balances[dst] = add(_balances[dst], wad);
357 
358         Transfer(src, dst, wad);
359 
360         return true;
361     }
362 
363     function approve(address guy, uint256 wad) returns (bool) {
364         _approvals[msg.sender][guy] = wad;
365 
366         Approval(msg.sender, guy, wad);
367 
368         return true;
369     }
370 
371 }
372 
373 contract DSToken is DSTokenBase(0), DSStop {
374 
375     string  public  symbol;
376     uint256  public  decimals = 8; // standard token precision. override to customize
377 
378     function DSToken(string symbol_) {
379         symbol = symbol_;
380     }
381 
382     function transfer(address dst, uint wad) stoppable note returns (bool) {
383         return super.transfer(dst, wad);
384     }
385     function transferFrom(
386     address src, address dst, uint wad
387     ) stoppable note returns (bool) {
388         return super.transferFrom(src, dst, wad);
389     }
390     function approve(address guy, uint wad) stoppable note returns (bool) {
391         return super.approve(guy, wad);
392     }
393 
394     function push(address dst, uint128 wad) returns (bool) {
395         return transfer(dst, wad);
396     }
397 
398     function pull(address src, uint128 wad) returns (bool) {
399         return transferFrom(src, msg.sender, wad);
400     }
401 
402     function mint(uint128 wad) auth stoppable note {
403         _balances[msg.sender] = add(_balances[msg.sender], wad);
404         _supply = add(_supply, wad);
405     }
406     function burn(uint128 wad) auth stoppable note {
407         _balances[msg.sender] = sub(_balances[msg.sender], wad);
408         _supply = sub(_supply, wad);
409     }
410 
411     // Optional token name
412 
413     string public  name = "";
414 
415     function setName(string name_) auth {
416         name = name_;
417     }
418 
419 }
420 
421 contract WordCoin is DSToken('Word'){
422     address public OfferContract;
423 
424     uint public tokenSellCost;
425     uint public tokenBuyCost;
426     bool public isSellable;
427     uint public secondsAfter;
428     uint public depositPercents;
429 
430     address public ICOContract;
431     address public preICOContract;
432 
433     struct Deposit {
434     uint amount;
435     uint time;
436     }
437 
438     mapping (address => uint) public reservedCoins;
439     mapping (address => Deposit) public deposits;
440 
441     event LogBounty(address user, uint amount, string message);
442     event LogEtherBounty(address user, uint amount, string message);
443     event LogSendReward(address from, address to, string message);
444     event LogBuyCoins(address user, uint value, string message);
445     event LogGetEther(address user, uint value, string message);
446     event LogMakeDeposit(address user, uint value, string message);
447     event LogGetDeposit(address user, uint value, string message);
448 
449     function WordCoin(){
450     }
451 
452 
453     modifier sellable {
454         assert(isSellable);
455         _;
456     }
457 
458     modifier onlyOffer {
459         assert(msg.sender == OfferContract);
460         _;
461     }
462 
463     modifier onlypreICO {
464         assert(msg.sender == preICOContract);
465         _;
466     }
467 
468     modifier onlyICO {
469         assert(msg.sender == ICOContract);
470         _;
471     }
472 
473     function setICO(address ICO) auth {
474         ICOContract = ICO;
475     }
476 
477     function setPreICO(address preICO) auth {
478         preICOContract = preICO;
479     }
480 
481     function preICOmint(uint128 wad) onlypreICO {
482         _balances[msg.sender] = add(_balances[msg.sender], wad);
483         _supply = add(_supply, wad);
484     }
485 
486 
487     function ICOmint(uint128 wad) onlyICO {
488         _balances[msg.sender] = add(_balances[msg.sender], wad);
489         _supply = add(_supply, wad);
490     }
491 
492 
493     function bounty(address user, uint amount) auth {
494         assert(_balances[this] >= amount);
495 
496         _balances[user] += amount;
497         _balances[this] -= amount;
498         LogBounty(user, amount, "Sent bounty");
499     }
500 
501 
502     function etherBounty(address user, uint amount) auth {
503         assert(this.balance >= amount);
504         user.transfer(amount);
505         LogEtherBounty(user, amount, "Sent ether bounty");
506     }
507 
508 
509     function sendReward(address from, address to, uint value) onlyOffer {
510         reservedCoins[from] -= value;
511         _balances[to] += value;
512         LogSendReward(from, to, "Sent reward");
513     }
514 
515 
516     function reserveCoins(address from, uint value) onlyOffer {
517         _balances[from] -= value;
518         reservedCoins[from] += value;
519     }
520 
521 
522     function declineCoins(address from, uint value) onlyOffer {
523         _balances[from] += value;
524         reservedCoins[from] -= value;
525     }
526 
527 
528     function getEther(uint128 amount) sellable {
529         // exchange coins to Ethers with exchange course
530         assert(tokenSellCost > 0);
531         assert(div(mul(_balances[msg.sender], 10), 100) >= amount);
532         super.push(this, amount);
533         msg.sender.transfer(amount * tokenSellCost);
534         LogGetEther(msg.sender, amount * tokenSellCost, "Got Ether");
535     }
536 
537 
538     function makeDeposit(uint amount) {
539         assert(_balances[msg.sender] > amount);
540         assert(deposits[msg.sender].amount == 0);
541 
542         deposits[msg.sender].amount = amount;
543         deposits[msg.sender].time = now;
544         _balances[msg.sender] -= amount;
545         _balances[this] += amount;
546         LogMakeDeposit(msg.sender, amount, "Made deposit");
547     }
548 
549 
550     function getDeposit() {
551         assert(deposits[msg.sender].amount != 0);
552         assert(now > (deposits[msg.sender].time + mul(secondsAfter, 1 seconds)));
553         assert(_balances[this] > div(mul(deposits[msg.sender].amount, add(100, depositPercents)), 100));
554 
555         uint amount = div(mul(deposits[msg.sender].amount, add(100, depositPercents)), 100);
556         deposits[msg.sender].amount = 0;
557         _balances[msg.sender]  += amount;
558         _balances[this] -= amount;
559         LogGetDeposit(msg.sender, amount, "Got deposit");
560     }
561 
562 
563     function setBuyCourse(uint course) auth {
564         isSellable = false;
565         tokenBuyCost = course;
566     }
567 
568     function setSellCourse(uint course) auth {
569         isSellable = false;
570         tokenSellCost = course;
571     }
572 
573     function setSellable(bool sellable) auth {
574         isSellable = sellable;
575     }
576 
577 
578     function setOfferContract(address offerContract) auth {
579         OfferContract = offerContract;
580     }
581 
582 
583     function setSecondsAfter(uint secondsForDeposit) auth {
584         secondsAfter = secondsForDeposit;
585     }
586 
587 
588     function setDepositPercents(uint percents) auth {
589         depositPercents = percents;
590     }
591 
592 
593     function takeEther() payable auth {}
594 
595 
596     function () payable sellable {
597         uint amount = div(msg.value, tokenBuyCost);
598         _balances[this] -= amount;
599         _balances[msg.sender] += amount;
600         LogBuyCoins(msg.sender, amount, "Coins bought");
601     }
602 }
603 
604 contract preICO is DSAuth, DSExec, DSMath {
605 
606     WordCoin  public  coin;
607     address public ICO;
608 
609     address[] investorsArray;
610 
611     struct Investor {
612     uint amount;
613     uint tokenAmount;
614     bool tokenSent;
615     bool rewardSent;
616     bool largeBonusSent;
617     }
618 
619     mapping (address => Investor) public investors;
620 
621     uint public deadline;
622     uint public start;
623     uint public countDays;
624 
625     bool public autoTokenSent;
626 
627     uint public totalDonations;
628     uint public totalDonationsWithBonuses;
629     uint public donationsCount;
630     uint public ethReward;
631 
632     uint128 public preICOTokenAmount;
633     uint128 public preICOTokenRemaining;
634 
635     uint128 public preICOTokenReward;
636     uint128 public preICOTokenRewardRemaining;
637 
638     event LogBounty(address user, uint128 amount, string result);
639     event LogBounty256(address user, uint amount, string result);
640     event LogPush(address user, uint128 amount, string result);
641     event LogTokenSent(address user, bool amount, string result);
642 
643     modifier afterDeadline() {
644         assert(now >= deadline);
645         _;
646     }
647 
648     event LogDonation(address user, string message);
649     event LogTransferOwnership(address user, string message);
650     event LogSendTokens(address user, uint amount, string message);
651     event LogSendPOSTokens(address user, uint amount, string message);
652 
653     function preICO(uint initCountDays){
654         countDays = initCountDays;
655         preICOTokenAmount = 200000000000000;
656         preICOTokenRemaining = 200000000000000;
657         preICOTokenReward = 20000000000000;
658         preICOTokenRewardRemaining = 20000000000000;
659     }
660 
661 
662     function setCoin(WordCoin initCoin) auth {
663         assert(preICOTokenAmount > 0);
664         start = now;
665         deadline = now + countDays * 1 days;
666         coin = initCoin;
667         coin.preICOmint(uint128(add(uint256(preICOTokenReward),uint256(preICOTokenAmount))));
668     }
669 
670 
671     function sendTokens() afterDeadline {
672         assert(!investors[msg.sender].tokenSent);
673 
674         uint amount = div(mul(investors[msg.sender].amount, preICOTokenAmount), uint256(totalDonationsWithBonuses));
675 
676         coin.push(msg.sender, uint128(amount));
677         preICOTokenRemaining -= uint128(amount);
678         investors[msg.sender].tokenSent = true;
679         investors[msg.sender].tokenAmount = amount;
680         LogSendTokens(msg.sender, amount, "Sent tokens");
681     }
682 
683     function autoSend() afterDeadline {
684         LogDonation(msg.sender, "START");
685         assert(!autoTokenSent);
686         for (uint i = 0; i < investorsArray.length; i++) {
687             LogSendTokens(msg.sender, uint256(totalDonationsWithBonuses), "TOTAL");
688             uint amount = div(mul(investors[investorsArray[i]].amount, preICOTokenAmount), uint256(totalDonationsWithBonuses));
689             LogSendTokens(msg.sender, amount, "TOTAL");
690             if (!investors[investorsArray[i]].tokenSent) {
691                 coin.push(investorsArray[i], uint128(amount));
692                 LogSendTokens(msg.sender, amount, "PUSH");
693                 investors[investorsArray[i]].tokenAmount = amount;
694                 investors[investorsArray[i]].tokenSent = true;
695             }
696         }
697         autoTokenSent = true;
698     }
699 
700     function setICOContract(address ico) auth{
701         ICO = ico;
702     }
703 
704 
705     function getEthers(uint amount) auth {
706         assert(amount > 0);
707         assert(this.balance - amount >= 0);
708         assert(msg.sender == owner);
709         owner.transfer(amount);
710     }
711 
712 
713     function getLargeBonus() {
714         assert(investors[msg.sender].amount > 7 ether);
715         assert(!investors[msg.sender].largeBonusSent);
716 
717         uint amount = div(mul(investors[msg.sender].tokenAmount,10),100);
718         coin.push(msg.sender, uint128(amount));
719         preICOTokenRewardRemaining -= uint128(amount);
720         investors[msg.sender].largeBonusSent = true;
721 
722         LogSendTokens(msg.sender, amount, "Sent tokens for 7 Eth donate");
723     }
724 
725     function sendICOTokensBack(uint128 amount) afterDeadline auth{
726         assert(coin.balanceOf(this) > amount);
727         coin.push(msg.sender, amount);
728     }
729 
730     function part( address who ) public constant returns (uint part) {
731         part = div(mul(investors[who].amount, 1000000), totalDonationsWithBonuses);
732     }
733 
734     function rewardWasSent (address who) public constant returns (bool wasSent)  {
735         wasSent = investors[who].rewardSent;
736     }
737 
738     function setRewardWasSent (address who) {
739         assert(msg.sender == ICO);
740         investors[who].rewardSent = true;
741     }
742 
743     function () payable {
744         assert(now <= deadline);
745         assert(msg.sender !=  address(0));
746         assert(msg.value != 0);
747         assert(preICOTokenRemaining > 0);
748 
749         uint percents = 0;
750 
751         if (sub(now,start) < 24 hours) {
752             percents = sub(24, div(sub(now,start), 1 hours));
753         }
754 
755         uint extraDonation = div(msg.value, 100) * percents;
756 
757         investors[msg.sender].tokenSent = false;
758         totalDonationsWithBonuses += add(msg.value, extraDonation);
759         totalDonations += msg.value;
760 
761         investors[msg.sender].amount += add(msg.value, extraDonation);
762         donationsCount++;
763 
764         investorsArray.push(msg.sender);
765 
766         LogDonation(msg.sender, "Donation was made");
767     }
768 }
769 
770 
771 contract ICO is DSAuth, DSExec, DSMath {
772     uint128 public ICOAmount;
773     uint128 public ICOReward;
774 
775     address[] investorsArray;
776 
777     struct preICOInvestor {
778     uint amount;
779     bool tokenSent;
780     bool rewardSent;
781     bool largeBonusSent;
782     }
783 
784     mapping (address => preICOInvestor) public investors;
785 
786     preICO public preico;
787     WordCoin public coin;
788     bool public canGiveMoneyBack;
789     bool public rewardSent;
790     uint public cost;
791     uint public tokenCost;
792 
793     bool public isICOStopped;
794 
795     uint public totalDonations;
796 
797     uint public totalDonationsWithBonuses;
798 
799     modifier allowGetMoneyBack() {
800         assert(canGiveMoneyBack);
801         _;
802     }
803 
804     modifier ICOStopped() {
805         assert(isICOStopped);
806         _;
807     }
808 
809     event LogSetPreICO(preICO preicoAddress, string message);
810     event LogStartWeek(string message);
811     event LogGetMoneyBack(address user, uint value, string message);
812     event LogMoneyToPreICO(address user, uint value, string message);
813     event LogBuyTokens(address user, uint value, string message);
814     event LogSendPOSTokens(address user, uint value, string message);
815     event LogTransferOwnership(address user, string message);
816     event Log1(uint128 la, string message);
817     event Log2(bool la, string message);
818 
819     function ICO(){
820         ICOAmount = 500000000000000;
821         ICOReward = 10000000000000;
822     }
823 
824     function setPreICO(preICO initPreICO) auth {
825         assert(initPreICO != address(0));
826         preico = initPreICO;
827     }
828 
829     function getEthers(uint amount) auth {
830         assert(amount > 0);
831         assert(this.balance - amount >= 0);
832         assert(msg.sender == owner);
833         owner.transfer(amount);
834     }
835 
836     function startWeekOne() auth {
837         assert(preico != address(0));
838         tokenCost = div(preico.totalDonations(), preico.preICOTokenAmount());
839         cost = 100;
840         LogStartWeek("First week started");
841     }
842 
843 
844     function startWeekTwo() auth {
845         cost = 105;
846         LogStartWeek("Second week started");
847     }
848 
849     function startWeekThree() auth {
850         cost = 110;
851         LogStartWeek("Third week started");
852     }
853 
854 
855     function startWeekFour() auth {
856         cost = 115;
857         LogStartWeek("Fourth week started");
858     }
859 
860 
861     function startWeekFive() auth {
862         cost = 120;
863         LogStartWeek("Last week started");
864     }
865 
866 
867     function setCanGetMoneyBack(bool value) auth {
868         canGiveMoneyBack = value;
869     }
870 
871 
872     function setTokenCost(uint newTokenCost) auth {
873         assert(newTokenCost > 0);
874         tokenCost = newTokenCost;
875     }
876 
877 
878     function getMoneyBack() allowGetMoneyBack {
879         assert(investors[msg.sender].amount > 0);
880         msg.sender.transfer(investors[msg.sender].amount);
881         investors[msg.sender].amount = 0;
882         LogGetMoneyBack(msg.sender, investors[msg.sender].amount, "Money returned");
883     }
884 
885 
886     function setCoin(WordCoin initCoin) auth {
887         assert(ICOAmount > 0);
888         coin = initCoin;
889         coin.ICOmint(uint128(add(uint256(ICOAmount),uint256(ICOReward))));
890     }
891 
892     function sendPOSTokens() ICOStopped {
893         assert(!investors[msg.sender].rewardSent);
894         assert(investors[msg.sender].amount > 0);
895         assert(ICOReward > 0);
896 
897         uint amount = div(mul(investors[msg.sender].amount, ICOReward), uint256(totalDonations));
898 
899         investors[msg.sender].rewardSent = true;
900 
901         coin.push(msg.sender, uint128(amount));
902         ICOReward -= uint128(amount);
903         LogSendPOSTokens(msg.sender, amount, "Sent prize tokens");
904     }
905 
906     function sendEthForReward() ICOStopped {
907         assert(!preico.rewardWasSent(msg.sender));
908         uint amount = div(mul(totalDonations, 3), 100);
909         uint ethAmountForReward = div(mul(amount,preico.part(msg.sender)), 1000000);
910         preico.setRewardWasSent(msg.sender);
911         msg.sender.transfer(ethAmountForReward);
912     }
913 
914     function sendICOTokensBack(uint128 amount) ICOStopped auth{
915         assert(coin.balanceOf(this) > amount);
916         coin.push(msg.sender, amount);
917     }
918 
919     function setBigICOStopped(bool stop) auth{
920         isICOStopped = stop;
921     }
922 
923     function() payable {
924         assert(msg.sender !=  address(0));
925         assert(msg.value != 0);
926         assert(cost > 0);
927         assert(tokenCost > 0);
928         assert(ICOAmount > 0);
929         assert(!isICOStopped);
930 
931         investors[msg.sender].amount += msg.value;
932 
933         totalDonations += msg.value;
934         uint amount = div(msg.value, div(mul(tokenCost, cost), 100));
935         if (msg.value > 7 ether) {
936             amount = div(mul(amount, 110),100);
937         }
938         coin.push(msg.sender, uint128(amount));
939         ICOAmount -= uint128(amount);
940 
941         investorsArray.push(msg.sender);
942 
943         LogBuyTokens(msg.sender, amount, "Tokens bought");
944     }
945 }