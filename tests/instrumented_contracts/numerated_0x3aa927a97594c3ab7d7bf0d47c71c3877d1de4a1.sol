1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint supply);
5     function balanceOf( address who ) constant returns (uint value);
6     function allowance( address owner, address spender ) constant returns (uint _allowance);
7 
8     function transfer( address to, uint value) returns (bool ok);
9     function transferFrom( address from, address to, uint value) returns (bool ok);
10     function approve( address spender, uint value ) returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSMath {
17     
18     /*
19     standard uint256 functions
20      */
21 
22     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x + y) >= x);
24     }
25 
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29 
30     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
31         z = x * y;
32         assert(x == 0 || z / x == y);
33     }
34 
35     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
36         z = x / y;
37     }
38 
39     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
40         return x <= y ? x : y;
41     }
42     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
43         return x >= y ? x : y;
44     }
45 
46     /*
47     uint128 functions (h is for half)
48      */
49 
50 
51     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
52         assert((z = x + y) >= x);
53     }
54 
55     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
56         assert((z = x - y) <= x);
57     }
58 
59     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
60         z = x * y;
61         assert(x == 0 || z / x == y);
62     }
63 
64     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
65         z = x / y;
66     }
67 
68     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
69         return x <= y ? x : y;
70     }
71     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
72         return x >= y ? x : y;
73     }
74 
75 
76     /*
77     int256 functions
78      */
79 
80     function imin(int256 x, int256 y) constant internal returns (int256 z) {
81         return x <= y ? x : y;
82     }
83     function imax(int256 x, int256 y) constant internal returns (int256 z) {
84         return x >= y ? x : y;
85     }
86 
87     /*
88     WAD math
89      */
90 
91     uint128 constant WAD = 10 ** 18;
92 
93     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
94         return hadd(x, y);
95     }
96 
97     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
98         return hsub(x, y);
99     }
100 
101     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
102         z = cast((uint256(x) * y + WAD / 2) / WAD);
103     }
104 
105     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
106         z = cast((uint256(x) * WAD + y / 2) / y);
107     }
108 
109     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
110         return hmin(x, y);
111     }
112     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
113         return hmax(x, y);
114     }
115 
116     /*
117     RAY math
118      */
119 
120     uint128 constant RAY = 10 ** 27;
121 
122     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
123         return hadd(x, y);
124     }
125 
126     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
127         return hsub(x, y);
128     }
129 
130     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
131         z = cast((uint256(x) * y + RAY / 2) / RAY);
132     }
133 
134     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         z = cast((uint256(x) * RAY + y / 2) / y);
136     }
137 
138     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
139         // This famous algorithm is called "exponentiation by squaring"
140         // and calculates x^n with x as fixed-point and n as regular unsigned.
141         //
142         // It's O(log n), instead of O(n) for naive repeated multiplication.
143         //
144         // These facts are why it works:
145         //
146         //  If n is even, then x^n = (x^2)^(n/2).
147         //  If n is odd,  then x^n = x * x^(n-1),
148         //   and applying the equation for even x gives
149         //    x^n = x * (x^2)^((n-1) / 2).
150         //
151         //  Also, EVM division is flooring and
152         //    floor[(n-1) / 2] = floor[n / 2].
153 
154         z = n % 2 != 0 ? x : RAY;
155 
156         for (n /= 2; n != 0; n /= 2) {
157             x = rmul(x, x);
158 
159             if (n % 2 != 0) {
160                 z = rmul(z, x);
161             }
162         }
163     }
164 
165     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
166         return hmin(x, y);
167     }
168     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
169         return hmax(x, y);
170     }
171 
172     function cast(uint256 x) constant internal returns (uint128 z) {
173         assert((z = uint128(x)) == x);
174     }
175 
176 }
177 
178 contract DSNote {
179     event LogNote(
180         bytes4   indexed  sig,
181         address  indexed  guy,
182         bytes32  indexed  foo,
183         bytes32  indexed  bar,
184         uint              wad,
185         bytes             fax
186     ) anonymous;
187 
188     modifier note {
189         bytes32 foo;
190         bytes32 bar;
191 
192         assembly {
193             foo := calldataload(4)
194             bar := calldataload(36)
195         }
196 
197         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
198 
199         _;
200     }
201 }
202 
203 contract DSAuthority {
204     function canCall(
205         address src, address dst, bytes4 sig
206     ) constant returns (bool);
207 }
208 
209 contract DSAuthEvents {
210     event LogSetAuthority (address indexed authority);
211     event LogSetOwner     (address indexed owner);
212 }
213 
214 contract DSAuth is DSAuthEvents {
215     DSAuthority  public  authority;
216     address      public  owner;
217 
218     function DSAuth() {
219         owner = msg.sender;
220         LogSetOwner(msg.sender);
221     }
222 
223     function setOwner(address owner_)
224         auth
225     {
226         owner = owner_;
227         LogSetOwner(owner);
228     }
229 
230     function setAuthority(DSAuthority authority_)
231         auth
232     {
233         authority = authority_;
234         LogSetAuthority(authority);
235     }
236 
237     modifier auth {
238         assert(isAuthorized(msg.sender, msg.sig));
239         _;
240     }
241 
242     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
243         if (src == address(this)) {
244             return true;
245         } else if (src == owner) {
246             return true;
247         } else if (authority == DSAuthority(0)) {
248             return false;
249         } else {
250             return authority.canCall(src, this, sig);
251         }
252     }
253 
254     function assert(bool x) internal {
255         if (!x) revert();
256     }
257 }
258 
259 contract EventfulMarket {
260     event LogItemUpdate(uint id);
261     event LogTrade(uint pay_amt, address indexed pay_gem,
262                    uint buy_amt, address indexed buy_gem);
263 
264     event LogMake(
265         bytes32  indexed  id,
266         bytes32  indexed  pair,
267         address  indexed  maker,
268         ERC20             pay_gem,
269         ERC20             buy_gem,
270         uint128           pay_amt,
271         uint128           buy_amt,
272         uint64            timestamp
273     );
274 
275     event LogBump(
276         bytes32  indexed  id,
277         bytes32  indexed  pair,
278         address  indexed  maker,
279         ERC20             pay_gem,
280         ERC20             buy_gem,
281         uint128           pay_amt,
282         uint128           buy_amt,
283         uint64            timestamp
284     );
285 
286     event LogTake(
287         bytes32           id,
288         bytes32  indexed  pair,
289         address  indexed  maker,
290         ERC20             pay_gem,
291         ERC20             buy_gem,
292         address  indexed  taker,
293         uint128           take_amt,
294         uint128           give_amt,
295         uint64            timestamp
296     );
297 
298     event LogKill(
299         bytes32  indexed  id,
300         bytes32  indexed  pair,
301         address  indexed  maker,
302         ERC20             pay_gem,
303         ERC20             buy_gem,
304         uint128           pay_amt,
305         uint128           buy_amt,
306         uint64            timestamp
307     );
308 }
309 
310 contract SimpleMarket is EventfulMarket, DSMath {
311 
312     uint public last_offer_id;
313 
314     mapping (uint => OfferInfo) public offers;
315 
316     bool locked;
317 
318     struct OfferInfo {
319         uint     pay_amt;
320         ERC20    pay_gem;
321         uint     buy_amt;
322         ERC20    buy_gem;
323         address  owner;
324         bool     active;
325         uint64   timestamp;
326     }
327 
328     modifier can_buy(uint id) {
329         require(isActive(id));
330         _;
331     }
332 
333     modifier can_cancel(uint id) {
334         require(isActive(id));
335         require(getOwner(id) == msg.sender);
336         _;
337     }
338 
339     modifier can_offer {
340         _;
341     }
342 
343     modifier synchronized {
344         assert(!locked);
345         locked = true;
346         _;
347         locked = false;
348     }
349 
350     function isActive(uint id) constant returns (bool active) {
351         return offers[id].active;
352     }
353 
354     function getOwner(uint id) constant returns (address owner) {
355         return offers[id].owner;
356     }
357 
358     function getOffer(uint id) constant returns (uint, ERC20, uint, ERC20) {
359       var offer = offers[id];
360       return (offer.pay_amt, offer.pay_gem,
361               offer.buy_amt, offer.buy_gem);
362     }
363 
364     // ---- Public entrypoints ---- //
365 
366     function bump(bytes32 id_)
367         can_buy(uint256(id_))
368     {
369         var id = uint256(id_);
370         LogBump(
371             id_,
372             sha3(offers[id].pay_gem, offers[id].buy_gem),
373             offers[id].owner,
374             offers[id].pay_gem,
375             offers[id].buy_gem,
376             uint128(offers[id].pay_amt),
377             uint128(offers[id].buy_amt),
378             offers[id].timestamp
379         );
380     }
381 
382     // Accept given `quantity` of an offer. Transfers funds from caller to
383     // offer maker, and from market to caller.
384     function buy(uint id, uint quantity)
385         can_buy(id)
386         synchronized
387         returns (bool)
388     {
389         OfferInfo memory offer = offers[id];
390         uint spend = mul(quantity, offer.buy_amt) / offer.pay_amt;
391 
392         require(uint128(spend) == spend);
393         require(uint128(quantity) == quantity);
394 
395         // For backwards semantic compatibility.
396         if (quantity == 0 || spend == 0 ||
397             quantity > offer.pay_amt || spend > offer.buy_amt)
398         {
399             return false;
400         }
401 
402         offers[id].pay_amt = sub(offer.pay_amt, quantity);
403         offers[id].buy_amt = sub(offer.buy_amt, spend);
404         assert( offer.buy_gem.transferFrom(msg.sender, offer.owner, spend) );
405         assert( offer.pay_gem.transfer(msg.sender, quantity) );
406 
407         LogItemUpdate(id);
408         LogTake(
409             bytes32(id),
410             sha3(offer.pay_gem, offer.buy_gem),
411             offer.owner,
412             offer.pay_gem,
413             offer.buy_gem,
414             msg.sender,
415             uint128(quantity),
416             uint128(spend),
417             uint64(now)
418         );
419         LogTrade(quantity, offer.pay_gem, spend, offer.buy_gem);
420 
421         if (offers[id].pay_amt == 0) {
422           delete offers[id];
423         }
424 
425         return true;
426     }
427 
428     // Cancel an offer. Refunds offer maker.
429     function cancel(uint id)
430         can_cancel(id)
431         synchronized
432         returns (bool success)
433     {
434         // read-only offer. Modify an offer by directly accessing offers[id]
435         OfferInfo memory offer = offers[id];
436         delete offers[id];
437 
438         assert( offer.pay_gem.transfer(offer.owner, offer.pay_amt) );
439 
440         LogItemUpdate(id);
441         LogKill(
442             bytes32(id),
443             sha3(offer.pay_gem, offer.buy_gem),
444             offer.owner,
445             offer.pay_gem,
446             offer.buy_gem,
447             uint128(offer.pay_amt),
448             uint128(offer.buy_amt),
449             uint64(now)
450         );
451 
452         success = true;
453     }
454 
455     function kill(bytes32 id) {
456         assert(cancel(uint256(id)));
457     }
458 
459     function make(
460         ERC20    pay_gem,
461         ERC20    buy_gem,
462         uint128  pay_amt,
463         uint128  buy_amt
464     ) returns (bytes32 id) {
465         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
466     }
467 
468     // Make a new offer. Takes funds from the caller into market escrow.
469     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem)
470         can_offer
471         synchronized
472         returns (uint id)
473     {
474         require(uint128(pay_amt) == pay_amt);
475         require(uint128(buy_amt) == buy_amt);
476         require(pay_amt > 0);
477         require(pay_gem != ERC20(0x0));
478         require(buy_amt > 0);
479         require(buy_gem != ERC20(0x0));
480         require(pay_gem != buy_gem);
481 
482         OfferInfo memory info;
483         info.pay_amt = pay_amt;
484         info.pay_gem = pay_gem;
485         info.buy_amt = buy_amt;
486         info.buy_gem = buy_gem;
487         info.owner = msg.sender;
488         info.active = true;
489         info.timestamp = uint64(now);
490         id = _next_id();
491         offers[id] = info;
492 
493         assert( pay_gem.transferFrom(msg.sender, this, pay_amt) );
494 
495         LogItemUpdate(id);
496         LogMake(
497             bytes32(id),
498             sha3(pay_gem, buy_gem),
499             msg.sender,
500             pay_gem,
501             buy_gem,
502             uint128(pay_amt),
503             uint128(buy_amt),
504             uint64(now)
505         );
506     }
507 
508     function take(bytes32 id, uint128 maxTakeAmount) {
509         assert(buy(uint256(id), maxTakeAmount));
510     }
511 
512     function _next_id() internal returns (uint) {
513         last_offer_id++; return last_offer_id;
514     }
515 }
516 
517 // Simple Market with a market lifetime. When the close_time has been reached,
518 // offers can only be cancelled (offer and buy will throw).
519 contract ExpiringMarket is DSAuth, SimpleMarket {
520     uint64 public close_time;
521     bool public stopped;
522 
523     // after close_time has been reached, no new offers are allowed
524     modifier can_offer {
525         assert(!isClosed());
526         _;
527     }
528 
529     // after close, no new buys are allowed
530     modifier can_buy(uint id) {
531         require(isActive(id));
532         require(!isClosed());
533         _;
534     }
535 
536     // after close, anyone can cancel an offer
537     modifier can_cancel(uint id) {
538         require(isActive(id));
539         require(isClosed() || (msg.sender == getOwner(id)));
540         _;
541     }
542 
543     function ExpiringMarket(uint64 _close_time) {
544         close_time = _close_time;
545     }
546 
547     function isClosed() constant returns (bool closed) {
548         return stopped || getTime() > close_time;
549     }
550 
551     function getTime() returns (uint64) {
552         return uint64(now);
553     }
554 
555     function stop() auth {
556         stopped = true;
557     }
558 }
559 
560 contract MatchingEvents {
561     event LogBuyEnabled(bool isEnabled);
562     event LogMinSell(address pay_gem, uint min_amount);
563     event LogMatchingEnabled(bool isEnabled);
564     event LogUnsortedOffer(uint id);
565     event LogSortedOffer(uint id);
566     event LogAddTokenPairWhitelist(ERC20 baseToken, ERC20 quoteToken);
567     event LogRemTokenPairWhitelist(ERC20 baseToken, ERC20 quoteToken);
568 }
569 
570 contract MatchingMarket is MatchingEvents, ExpiringMarket, DSNote {
571     bool public buyEnabled = true;      //buy enabled
572     bool public matchingEnabled = true; //true: enable matching,
573                                          //false: revert to expiring market
574     struct sortInfo {
575         uint next;  //points to id of next higher offer
576         uint prev;  //points to id of previous lower offer
577     }
578     mapping(uint => sortInfo) public _rank;                     //doubly linked lists of sorted offer ids
579     mapping(address => mapping(address => uint)) public _best;  //id of the highest offer for a token pair
580     mapping(address => mapping(address => uint)) public _span;  //number of offers stored for token pair in sorted orderbook
581     mapping(address => uint) public _dust;                      //minimum sell amount for a token to avoid dust offers
582     mapping(uint => uint) public _near;         //next unsorted offer id
583     mapping(bytes32 => bool) public _menu;      //whitelist tracking which token pairs can be traded
584     uint _head;                                 //first unsorted offer id
585 
586     //check if token pair is enabled
587     modifier isWhitelist(ERC20 buy_gem, ERC20 pay_gem) {
588         require(_menu[sha3(buy_gem, pay_gem)] || _menu[sha3(pay_gem, buy_gem)]);
589         _;
590     }
591 
592     function MatchingMarket(uint64 close_time) ExpiringMarket(close_time) {
593     }
594 
595     // ---- Public entrypoints ---- //
596 
597     function make(
598         ERC20    pay_gem,
599         ERC20    buy_gem,
600         uint128  pay_amt,
601         uint128  buy_amt
602     )
603     returns (bytes32) {
604         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
605     }
606 
607     function take(bytes32 id, uint128 maxTakeAmount) {
608         assert(buy(uint256(id), maxTakeAmount));
609     }
610 
611     function kill(bytes32 id) {
612         assert(cancel(uint256(id)));
613     }
614 
615     // Make a new offer. Takes funds from the caller into market escrow.
616     //
617     // If matching is enabled:
618     //     * creates new offer without putting it in
619     //       the sorted list.
620     //     * available to authorized contracts only!
621     //     * keepers should call insert(id,pos)
622     //       to put offer in the sorted list.
623     //
624     // If matching is disabled:
625     //     * calls expiring market's offer().
626     //     * available to everyone without authorization.
627     //     * no sorting is done.
628     //
629     function offer(
630         uint pay_amt,    //maker (ask) sell how much
631         ERC20 pay_gem,   //maker (ask) sell which token
632         uint buy_amt,    //taker (ask) buy how much
633         ERC20 buy_gem    //taker (ask) buy which token
634     )
635     isWhitelist(pay_gem, buy_gem)
636     /* NOT synchronized!!! */
637     returns (uint)
638     {
639         var fn = matchingEnabled ? _offeru : super.offer;
640         return fn(pay_amt, pay_gem, buy_amt, buy_gem);
641     }
642 
643     // Make a new offer. Takes funds from the caller into market escrow.
644     function offer(
645         uint pay_amt,    //maker (ask) sell how much
646         ERC20 pay_gem,   //maker (ask) sell which token
647         uint buy_amt,    //maker (ask) buy how much
648         ERC20 buy_gem,   //maker (ask) buy which token
649         uint pos         //position to insert offer, 0 should be used if unknown
650     )
651     isWhitelist(pay_gem, buy_gem)
652     /*NOT synchronized!!! */
653     can_offer
654     returns (uint)
655     {
656         return offer(pay_amt, pay_gem, buy_amt, buy_gem, pos, false);
657     }
658 
659     function offer(
660         uint pay_amt,    //maker (ask) sell how much
661         ERC20 pay_gem,   //maker (ask) sell which token
662         uint buy_amt,    //maker (ask) buy how much
663         ERC20 buy_gem,   //maker (ask) buy which token
664         uint pos,        //position to insert offer, 0 should be used if unknown
665         bool rounding    //match "close enough" orders?
666     )
667     isWhitelist(pay_gem, buy_gem)
668     /*NOT synchronized!!! */
669     can_offer
670     returns (uint)
671     {
672         require(_dust[pay_gem] <= pay_amt);
673 
674         if (matchingEnabled) {
675           return _matcho(pay_amt, pay_gem, buy_amt, buy_gem, pos, rounding);
676         }
677         return super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
678     }
679 
680     //Transfers funds from caller to offer maker, and from market to caller.
681     function buy(uint id, uint amount)
682     /*NOT synchronized!!! */
683     can_buy(id)
684     returns (bool)
685     {
686         var fn = matchingEnabled ? _buys : super.buy;
687         return fn(id, amount);
688     }
689 
690     // Cancel an offer. Refunds offer maker.
691     function cancel(uint id)
692     /*NOT synchronized!!! */
693     can_cancel(id)
694     returns (bool success)
695     {
696         if (matchingEnabled) {
697             if (isOfferSorted(id)) {
698                 assert(_unsort(id));
699             } else {
700                 assert(_hide(id));
701             }
702         }
703         return super.cancel(id);    //delete the offer.
704     }
705 
706     //insert offer into the sorted list
707     //keepers need to use this function
708     function insert(
709         uint id,   //maker (ask) id
710         uint pos   //position to insert into
711     )
712     returns (bool)
713     {
714         address buy_gem = address(offers[id].buy_gem);
715         address pay_gem = address(offers[id].pay_gem);
716 
717         require(!isOfferSorted(id));    //make sure offers[id] is not yet sorted
718         require(isActive(id));          //make sure offers[id] is active
719         require(pos == 0 || isActive(pos));
720 
721         require(_hide(id));             //remove offer from unsorted offers list
722         _sort(id, pos);                 //put offer into the sorted offers list
723         return true;
724     }
725 
726     //returns true if token is succesfully added to whitelist
727     //  Function is used to add a token pair to the whitelist
728     //  All incoming offers are checked against the whitelist.
729     function addTokenPairWhitelist(
730         ERC20 baseToken,
731         ERC20 quoteToken
732     )
733     public
734     auth
735     note
736     returns (bool)
737     {
738         require(!isTokenPairWhitelisted(baseToken, quoteToken));
739         require(address(baseToken) != 0x0 && address(quoteToken) != 0x0);
740 
741         _menu[sha3(baseToken, quoteToken)] = true;
742         LogAddTokenPairWhitelist(baseToken, quoteToken);
743         return true;
744     }
745 
746     //returns true if token is successfully removed from whitelist
747     //  Function is used to remove a token pair from the whitelist.
748     //  All incoming offers are checked against the whitelist.
749     function remTokenPairWhitelist(
750         ERC20 baseToken,
751         ERC20 quoteToken
752     )
753     public
754     auth
755     note
756     returns (bool)
757     {
758         require(isTokenPairWhitelisted(baseToken, quoteToken));
759 
760         delete _menu[sha3(baseToken, quoteToken)];
761         delete _menu[sha3(quoteToken, baseToken)];
762         LogRemTokenPairWhitelist(baseToken, quoteToken);
763         return true;
764     }
765 
766     function isTokenPairWhitelisted(
767         ERC20 baseToken,
768         ERC20 quoteToken
769     )
770     public
771     constant
772     returns (bool)
773     {
774         return (_menu[sha3(baseToken, quoteToken)] || _menu[sha3(quoteToken, baseToken)]);
775     }
776 
777     //set the minimum sell amount for a token
778     //    Function is used to avoid "dust offers" that have
779     //    very small amount of tokens to sell, and it would
780     //    cost more gas to accept the offer, than the value
781     //    of tokens received.
782     function setMinSell(
783         ERC20 pay_gem,     //token to assign minimum sell amount to
784         uint dust          //maker (ask) minimum sell amount
785     )
786     auth
787     note
788     returns (bool)
789     {
790         _dust[pay_gem] = dust;
791         LogMinSell(pay_gem, dust);
792         return true;
793     }
794 
795     //returns the minimum sell amount for an offer
796     function getMinSell(
797         ERC20 pay_gem      //token for which minimum sell amount is queried
798     )
799     constant
800     returns (uint) {
801         return _dust[pay_gem];
802     }
803 
804     //set buy functionality enabled/disabled
805     function setBuyEnabled(bool buyEnabled_) auth  returns (bool) {
806         buyEnabled = buyEnabled_;
807         LogBuyEnabled(buyEnabled);
808         return true;
809     }
810 
811     //set matching enabled/disabled
812     //    If matchingEnabled true(default), then inserted offers are matched.
813     //    Except the ones inserted by contracts, because those end up
814     //    in the unsorted list of offers, that must be later sorted by
815     //    keepers using insert().
816     //    If matchingEnabled is false then MatchingMarket is reverted to ExpiringMarket,
817     //    and matching is not done, and sorted lists are disabled.
818     function setMatchingEnabled(bool matchingEnabled_) auth  returns (bool) {
819         matchingEnabled = matchingEnabled_;
820         LogMatchingEnabled(matchingEnabled);
821         return true;
822     }
823 
824     //return the best offer for a token pair
825     //      the best offer is the lowest one if it's an ask,
826     //      and highest one if it's a bid offer
827     function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) constant returns(uint) {
828         return _best[sell_gem][buy_gem];
829     }
830 
831     //return the next worse offer in the sorted list
832     //      the worse offer is the higher one if its an ask,
833     //      and lower one if its a bid offer
834     function getWorseOffer(uint id) constant returns(uint) {
835         return _rank[id].prev;
836     }
837 
838     //return the next better offer in the sorted list
839     //      the better offer is in the lower priced one if its an ask,
840     //      and next higher priced one if its a bid offer
841     function getBetterOffer(uint id) constant returns(uint) {
842         return _rank[id].next;
843     }
844 
845     //return the amount of better offers for a token pair
846     function getOfferCount(ERC20 sell_gem, ERC20 buy_gem) constant returns(uint) {
847         return _span[sell_gem][buy_gem];
848     }
849 
850     //get the first unsorted offer that was inserted by a contract
851     //      Contracts can't calculate the insertion position of their offer because it is not an O(1) operation.
852     //      Their offers get put in the unsorted list of offers.
853     //      Keepers can calculate the insertion position offchain and pass it to the insert() function to insert
854     //      the unsorted offer into the sorted list. Unsorted offers will not be matched, but can be bought with buy().
855     function getFirstUnsortedOffer() constant returns(uint) {
856         return _head;
857     }
858 
859     //get the next unsorted offer
860     //      Can be used to cycle through all the unsorted offers.
861     function getNextUnsortedOffer(uint id) constant returns(uint) {
862         return _near[id];
863     }
864 
865     function isOfferSorted(uint id) constant returns(bool) {
866         address buy_gem = address(offers[id].buy_gem);
867         address pay_gem = address(offers[id].pay_gem);
868         return (_rank[id].next != 0 || _rank[id].prev != 0 || _best[pay_gem][buy_gem] == id) ? true : false;
869     }
870 
871 
872     // ---- Internal Functions ---- //
873 
874 
875     function _buys(uint id, uint amount)
876     internal
877     returns (bool)
878     {
879         require(buyEnabled);
880 
881         if (amount == offers[id].pay_amt && isOfferSorted(id)) {
882             //offers[id] must be removed from sorted list because all of it is bought
883             _unsort(id);
884         }
885         assert(super.buy(id, amount));
886         return true;
887     }
888 
889     //find the id of the next higher offer after offers[id]
890     function _find(uint id)
891     internal
892     returns (uint)
893     {
894         require( id > 0 );
895 
896         address buy_gem = address(offers[id].buy_gem);
897         address pay_gem = address(offers[id].pay_gem);
898         uint top = _best[pay_gem][buy_gem];
899         uint old_top = 0;
900 
901         // Find the larger-than-id order whose successor is less-than-id.
902         while (top != 0 && _isLtOrEq(id, top)) {
903             old_top = top;
904             top = _rank[top].prev;
905         }
906         return old_top;
907     }
908 
909     //return true if offers[low] priced less than or equal to offers[high]
910     function _isLtOrEq(
911         uint low,   //lower priced offer's id
912         uint high   //higher priced offer's id
913     )
914     internal
915     returns (bool)
916     {
917         return mul(offers[low].buy_amt, offers[high].pay_amt)
918           >= mul(offers[high].buy_amt, offers[low].pay_amt);
919     }
920 
921     //these variables are global only because of solidity local variable limit
922 
923     //match offers with taker offer, and execute token transactions
924     function _matcho(
925         uint t_pay_amt,    //taker sell how much
926         ERC20 t_pay_gem,   //taker sell which token
927         uint t_buy_amt,    //taker buy how much
928         ERC20 t_buy_gem,   //taker buy which token
929         uint pos,          //position id
930         bool rounding      //match "close enough" orders?
931     )
932     internal
933     returns (uint id)
934     {
935         uint best_maker_id;    //highest maker id
936         uint t_buy_amt_old;              //taker buy how much saved
937         uint m_buy_amt;        //maker offer wants to buy this much token
938         uint m_pay_amt;        //maker offer wants to sell this much token
939 
940         require(pos == 0
941                || !isActive(pos)
942                || t_buy_gem == offers[pos].buy_gem
943                   && t_pay_gem == offers[pos].pay_gem);
944 
945         // there is at least one offer stored for token pair
946         while (_best[t_buy_gem][t_pay_gem] > 0) {
947             best_maker_id = _best[t_buy_gem][t_pay_gem];
948             m_buy_amt = offers[best_maker_id].buy_amt;
949             m_pay_amt = offers[best_maker_id].pay_amt;
950 
951             // Ugly hack to work around rounding errors. Based on the idea that
952             // the furthest the amounts can stray from their "true" values is 1.
953             // Ergo the worst case has t_pay_amt and m_pay_amt at +1 away from
954             // their "correct" values and m_buy_amt and t_buy_amt at -1.
955             // Since (c - 1) * (d - 1) > (a + 1) * (b + 1) is equivalent to
956             // c * d > a * b + a + b + c + d, we write...
957             if (mul(m_buy_amt, t_buy_amt) > mul(t_pay_amt, m_pay_amt) +
958                 (rounding ? m_buy_amt + t_buy_amt + t_pay_amt + m_pay_amt : 0))
959             {
960                 break;
961             }
962             // ^ The `rounding` parameter is a compromise borne of a couple days
963             // of discussion.
964 
965             buy(best_maker_id, min(m_pay_amt, t_buy_amt));
966             t_buy_amt_old = t_buy_amt;
967             t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
968             t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
969 
970             if (t_pay_amt == 0 || t_buy_amt == 0) {
971                 break;
972             }
973         }
974 
975         if (t_buy_amt > 0 && t_pay_amt > 0) {
976             //new offer should be created
977             id = super.offer(t_pay_amt, t_pay_gem, t_buy_amt, t_buy_gem);
978             //insert offer into the sorted list
979             _sort(id, pos);
980         }
981     }
982 
983     // Make a new offer without putting it in the sorted list.
984     // Takes funds from the caller into market escrow.
985     // ****Available to authorized contracts only!**********
986     // Keepers should call insert(id,pos) to put offer in the sorted list.
987     function _offeru(
988         uint pay_amt,      //maker (ask) sell how much
989         ERC20 pay_gem,     //maker (ask) sell which token
990         uint buy_amt,      //maker (ask) buy how much
991         ERC20 buy_gem      //maker (ask) buy which token
992     )
993     internal
994     /*NOT synchronized!!! */
995     returns (uint id)
996     {
997         id = super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
998         _near[id] = _head;
999         _head = id;
1000         LogUnsortedOffer(id);
1001     }
1002 
1003     //put offer into the sorted list
1004     function _sort(
1005         uint id,    //maker (ask) id
1006         uint pos    //position to insert into
1007     )
1008     internal
1009     {
1010         require(isActive(id));
1011 
1012         address buy_gem = address(offers[id].buy_gem);
1013         address pay_gem = address(offers[id].pay_gem);
1014         uint prev_id; //maker (ask) id
1015 
1016         if (pos == 0
1017             || !isActive(pos)
1018             || !_isLtOrEq(id, pos)
1019             || (_rank[pos].prev != 0 && _isLtOrEq(id, _rank[pos].prev))
1020         ) {
1021             //client did not provide valid position, so we have to find it
1022             pos = _find(id);
1023         }
1024 
1025         //assert `pos` is in the sorted list or is 0
1026         require(pos == 0 || _rank[pos].next != 0 || _rank[pos].prev != 0 || _best[pay_gem][buy_gem] == pos);
1027 
1028         if (pos != 0) {
1029             //offers[id] is not the highest offer
1030             require(_isLtOrEq(id, pos));
1031             prev_id = _rank[pos].prev;
1032             _rank[pos].prev = id;
1033             _rank[id].next = pos;
1034 
1035         } else {
1036             //offers[id] is the highest offer
1037             prev_id = _best[pay_gem][buy_gem];
1038             _best[pay_gem][buy_gem] = id;
1039         }
1040 
1041         require(prev_id == 0 || offers[prev_id].pay_gem == offers[id].pay_gem);
1042         require(prev_id == 0 || offers[prev_id].buy_gem == offers[id].buy_gem);
1043 
1044         if (prev_id != 0) {
1045             //if lower offer does exist
1046             require(!_isLtOrEq(id, prev_id));
1047             _rank[prev_id].next = id;
1048             _rank[id].prev = prev_id;
1049         }
1050 
1051         _span[pay_gem][buy_gem]++;
1052         LogSortedOffer(id);
1053     }
1054 
1055     // Remove offer from the sorted list (does not cancel offer)
1056     function _unsort(
1057         uint id    //id of maker (ask) offer to remove from sorted list
1058     )
1059     internal
1060     returns (bool)
1061     {
1062         address buy_gem = address(offers[id].buy_gem);
1063         address pay_gem = address(offers[id].pay_gem);
1064         require(_span[pay_gem][buy_gem] > 0);
1065 
1066         //assert id is in the sorted list
1067         require(_rank[id].next != 0 || _rank[id].prev != 0 || _best[pay_gem][buy_gem] == id);
1068 
1069         if (id != _best[pay_gem][buy_gem]) {
1070             // offers[id] is not the highest offer
1071             _rank[_rank[id].next].prev = _rank[id].prev;
1072 
1073         } else {
1074             //offers[id] is the highest offer
1075             _best[pay_gem][buy_gem] = _rank[id].prev;
1076         }
1077 
1078         if (_rank[id].prev != 0) {
1079             //offers[id] is not the lowest offer
1080             _rank[_rank[id].prev].next = _rank[id].next;
1081         }
1082 
1083         _span[pay_gem][buy_gem]--;
1084         delete _rank[id];
1085         return true;
1086     }
1087     //Hide offer from the unsorted order book (does not cancel offer)
1088     function _hide(
1089         uint id     //id of maker offer to remove from unsorted list
1090     )
1091     internal
1092     returns (bool)
1093     {
1094         uint uid = _head;               //id of an offer in unsorted offers list 
1095         uint pre = uid;                 //id of previous offer in unsorted offers list
1096 
1097         require(!isOfferSorted(id));    //make sure offer id is not in sorted offers list
1098 
1099         if (_head == id) {              //check if offer is first offer in unsorted offers list
1100             _head = _near[id];          //set head to new first unsorted offer
1101             _near[id] = 0;              //delete order from unsorted order list
1102             return true;
1103         }
1104         while (uid > 0 && uid != id) {  //find offer in unsorted order list
1105             pre = uid;
1106             uid = _near[uid];
1107         }
1108         if (uid != id) {                //did not find offer id in unsorted offers list
1109             return false;
1110         }
1111         _near[pre] = _near[id];         //set previous unsorted offer to point to offer after offer id
1112         _near[id] = 0;                  //delete order from unsorted order list
1113         return true;
1114     }
1115 }