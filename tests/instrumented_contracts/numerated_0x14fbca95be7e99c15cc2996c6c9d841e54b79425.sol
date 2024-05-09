1 pragma solidity ^0.4.18;
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
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
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
57 contract DSMath {
58     function add(uint x, uint y) internal pure returns (uint z) {
59         require((z = x + y) >= x);
60     }
61     function sub(uint x, uint y) internal pure returns (uint z) {
62         require((z = x - y) <= x);
63     }
64     function mul(uint x, uint y) internal pure returns (uint z) {
65         require(y == 0 || (z = x * y) / y == x);
66     }
67 
68     function min(uint x, uint y) internal pure returns (uint z) {
69         return x <= y ? x : y;
70     }
71     function max(uint x, uint y) internal pure returns (uint z) {
72         return x >= y ? x : y;
73     }
74     function imin(int x, int y) internal pure returns (int z) {
75         return x <= y ? x : y;
76     }
77     function imax(int x, int y) internal pure returns (int z) {
78         return x >= y ? x : y;
79     }
80 
81     uint constant WAD = 10 ** 18;
82     uint constant RAY = 10 ** 27;
83 
84     function wmul(uint x, uint y) internal pure returns (uint z) {
85         z = add(mul(x, y), WAD / 2) / WAD;
86     }
87     function rmul(uint x, uint y) internal pure returns (uint z) {
88         z = add(mul(x, y), RAY / 2) / RAY;
89     }
90     function wdiv(uint x, uint y) internal pure returns (uint z) {
91         z = add(mul(x, WAD), y / 2) / y;
92     }
93     function rdiv(uint x, uint y) internal pure returns (uint z) {
94         z = add(mul(x, RAY), y / 2) / y;
95     }
96 
97     // This famous algorithm is called "exponentiation by squaring"
98     // and calculates x^n with x as fixed-point and n as regular unsigned.
99     //
100     // It's O(log n), instead of O(n) for naive repeated multiplication.
101     //
102     // These facts are why it works:
103     //
104     //  If n is even, then x^n = (x^2)^(n/2).
105     //  If n is odd,  then x^n = x * x^(n-1),
106     //   and applying the equation for even x gives
107     //    x^n = x * (x^2)^((n-1) / 2).
108     //
109     //  Also, EVM division is flooring and
110     //    floor[(n-1) / 2] = floor[n / 2].
111     //
112     function rpow(uint x, uint n) internal pure returns (uint z) {
113         z = n % 2 != 0 ? x : RAY;
114 
115         for (n /= 2; n != 0; n /= 2) {
116             x = rmul(x, x);
117 
118             if (n % 2 != 0) {
119                 z = rmul(z, x);
120             }
121         }
122     }
123 }
124 
125 contract ERC20Events {
126     event Approval(address indexed src, address indexed guy, uint wad);
127     event Transfer(address indexed src, address indexed dst, uint wad);
128 }
129 
130 contract ERC20 is ERC20Events {
131     function totalSupply() public view returns (uint);
132     function balanceOf(address guy) public view returns (uint);
133     function allowance(address src, address guy) public view returns (uint);
134 
135     function approve(address guy, uint wad) public returns (bool);
136     function transfer(address dst, uint wad) public returns (bool);
137     function transferFrom(
138         address src, address dst, uint wad
139     ) public returns (bool);
140 }
141 
142 contract EventfulMarket {
143     event LogItemUpdate(uint id);
144     event LogTrade(uint pay_amt, address indexed pay_gem,
145                    uint buy_amt, address indexed buy_gem);
146 
147     event LogMake(
148         bytes32  indexed  id,
149         bytes32  indexed  pair,
150         address  indexed  maker,
151         ERC20             pay_gem,
152         ERC20             buy_gem,
153         uint128           pay_amt,
154         uint128           buy_amt,
155         uint64            timestamp
156     );
157 
158     event LogBump(
159         bytes32  indexed  id,
160         bytes32  indexed  pair,
161         address  indexed  maker,
162         ERC20             pay_gem,
163         ERC20             buy_gem,
164         uint128           pay_amt,
165         uint128           buy_amt,
166         uint64            timestamp
167     );
168 
169     event LogTake(
170         bytes32           id,
171         bytes32  indexed  pair,
172         address  indexed  maker,
173         ERC20             pay_gem,
174         ERC20             buy_gem,
175         address  indexed  taker,
176         uint128           take_amt,
177         uint128           give_amt,
178         uint64            timestamp
179     );
180 
181     event LogKill(
182         bytes32  indexed  id,
183         bytes32  indexed  pair,
184         address  indexed  maker,
185         ERC20             pay_gem,
186         ERC20             buy_gem,
187         uint128           pay_amt,
188         uint128           buy_amt,
189         uint64            timestamp
190     );
191 }
192 
193 contract SimpleMarket is EventfulMarket, DSMath {
194 
195     uint public last_offer_id;
196 
197     mapping (uint => OfferInfo) public offers;
198 
199     bool locked;
200 
201     struct OfferInfo {
202         uint     pay_amt;
203         ERC20    pay_gem;
204         uint     buy_amt;
205         ERC20    buy_gem;
206         address  owner;
207         uint64   timestamp;
208     }
209 
210     modifier can_buy(uint id) {
211         require(isActive(id));
212         _;
213     }
214 
215     modifier can_cancel(uint id) {
216         require(isActive(id));
217         require(getOwner(id) == msg.sender);
218         _;
219     }
220 
221     modifier can_offer {
222         _;
223     }
224 
225     modifier synchronized {
226         require(!locked);
227         locked = true;
228         _;
229         locked = false;
230     }
231 
232     function isActive(uint id) public constant returns (bool active) {
233         return offers[id].timestamp > 0;
234     }
235 
236     function getOwner(uint id) public constant returns (address owner) {
237         return offers[id].owner;
238     }
239 
240     function getOffer(uint id) public constant returns (uint, ERC20, uint, ERC20) {
241       var offer = offers[id];
242       return (offer.pay_amt, offer.pay_gem,
243               offer.buy_amt, offer.buy_gem);
244     }
245 
246     // ---- Public entrypoints ---- //
247 
248     function bump(bytes32 id_)
249         public
250         can_buy(uint256(id_))
251     {
252         var id = uint256(id_);
253         LogBump(
254             id_,
255             keccak256(offers[id].pay_gem, offers[id].buy_gem),
256             offers[id].owner,
257             offers[id].pay_gem,
258             offers[id].buy_gem,
259             uint128(offers[id].pay_amt),
260             uint128(offers[id].buy_amt),
261             offers[id].timestamp
262         );
263     }
264 
265     // Accept given `quantity` of an offer. Transfers funds from caller to
266     // offer maker, and from market to caller.
267     function buy(uint id, uint quantity)
268         public
269         can_buy(id)
270         synchronized
271         returns (bool)
272     {
273         OfferInfo memory offer = offers[id];
274         uint spend = mul(quantity, offer.buy_amt) / offer.pay_amt;
275 
276         require(uint128(spend) == spend);
277         require(uint128(quantity) == quantity);
278 
279         // For backwards semantic compatibility.
280         if (quantity == 0 || spend == 0 ||
281             quantity > offer.pay_amt || spend > offer.buy_amt)
282         {
283             return false;
284         }
285 
286         offers[id].pay_amt = sub(offer.pay_amt, quantity);
287         offers[id].buy_amt = sub(offer.buy_amt, spend);
288         require( offer.buy_gem.transferFrom(msg.sender, offer.owner, spend) );
289         require( offer.pay_gem.transfer(msg.sender, quantity) );
290 
291         LogItemUpdate(id);
292         LogTake(
293             bytes32(id),
294             keccak256(offer.pay_gem, offer.buy_gem),
295             offer.owner,
296             offer.pay_gem,
297             offer.buy_gem,
298             msg.sender,
299             uint128(quantity),
300             uint128(spend),
301             uint64(now)
302         );
303         LogTrade(quantity, offer.pay_gem, spend, offer.buy_gem);
304 
305         if (offers[id].pay_amt == 0) {
306           delete offers[id];
307         }
308 
309         return true;
310     }
311 
312     // Cancel an offer. Refunds offer maker.
313     function cancel(uint id)
314         public
315         can_cancel(id)
316         synchronized
317         returns (bool success)
318     {
319         // read-only offer. Modify an offer by directly accessing offers[id]
320         OfferInfo memory offer = offers[id];
321         delete offers[id];
322 
323         require( offer.pay_gem.transfer(offer.owner, offer.pay_amt) );
324 
325         LogItemUpdate(id);
326         LogKill(
327             bytes32(id),
328             keccak256(offer.pay_gem, offer.buy_gem),
329             offer.owner,
330             offer.pay_gem,
331             offer.buy_gem,
332             uint128(offer.pay_amt),
333             uint128(offer.buy_amt),
334             uint64(now)
335         );
336 
337         success = true;
338     }
339 
340     function kill(bytes32 id)
341         public
342     {
343         require(cancel(uint256(id)));
344     }
345 
346     function make(
347         ERC20    pay_gem,
348         ERC20    buy_gem,
349         uint128  pay_amt,
350         uint128  buy_amt
351     )
352         public
353         returns (bytes32 id)
354     {
355         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
356     }
357 
358     // Make a new offer. Takes funds from the caller into market escrow.
359     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem)
360         public
361         can_offer
362         synchronized
363         returns (uint id)
364     {
365         require(uint128(pay_amt) == pay_amt);
366         require(uint128(buy_amt) == buy_amt);
367         require(pay_amt > 0);
368         require(pay_gem != ERC20(0x0));
369         require(buy_amt > 0);
370         require(buy_gem != ERC20(0x0));
371         require(pay_gem != buy_gem);
372 
373         OfferInfo memory info;
374         info.pay_amt = pay_amt;
375         info.pay_gem = pay_gem;
376         info.buy_amt = buy_amt;
377         info.buy_gem = buy_gem;
378         info.owner = msg.sender;
379         info.timestamp = uint64(now);
380         id = _next_id();
381         offers[id] = info;
382 
383         require( pay_gem.transferFrom(msg.sender, this, pay_amt) );
384 
385         LogItemUpdate(id);
386         LogMake(
387             bytes32(id),
388             keccak256(pay_gem, buy_gem),
389             msg.sender,
390             pay_gem,
391             buy_gem,
392             uint128(pay_amt),
393             uint128(buy_amt),
394             uint64(now)
395         );
396     }
397 
398     function take(bytes32 id, uint128 maxTakeAmount)
399         public
400     {
401         require(buy(uint256(id), maxTakeAmount));
402     }
403 
404     function _next_id()
405         internal
406         returns (uint)
407     {
408         last_offer_id++; return last_offer_id;
409     }
410 }
411 
412 // Simple Market with a market lifetime. When the close_time has been reached,
413 // offers can only be cancelled (offer and buy will throw).
414 
415 contract ExpiringMarket is DSAuth, SimpleMarket {
416     uint64 public close_time;
417     bool public stopped;
418 
419     // after close_time has been reached, no new offers are allowed
420     modifier can_offer {
421         require(!isClosed());
422         _;
423     }
424 
425     // after close, no new buys are allowed
426     modifier can_buy(uint id) {
427         require(isActive(id));
428         require(!isClosed());
429         _;
430     }
431 
432     // after close, anyone can cancel an offer
433     modifier can_cancel(uint id) {
434         require(isActive(id));
435         require(isClosed() || (msg.sender == getOwner(id)));
436         _;
437     }
438 
439     function ExpiringMarket(uint64 _close_time)
440         public
441     {
442         close_time = _close_time;
443     }
444 
445     function isClosed() public constant returns (bool closed) {
446         return stopped || getTime() > close_time;
447     }
448 
449     function getTime() public constant returns (uint64) {
450         return uint64(now);
451     }
452 
453     function stop() public auth {
454         stopped = true;
455     }
456 }
457 
458 contract DSNote {
459     event LogNote(
460         bytes4   indexed  sig,
461         address  indexed  guy,
462         bytes32  indexed  foo,
463         bytes32  indexed  bar,
464         uint              wad,
465         bytes             fax
466     ) anonymous;
467 
468     modifier note {
469         bytes32 foo;
470         bytes32 bar;
471 
472         assembly {
473             foo := calldataload(4)
474             bar := calldataload(36)
475         }
476 
477         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
478 
479         _;
480     }
481 }
482 
483 contract MatchingEvents {
484     event LogBuyEnabled(bool isEnabled);
485     event LogMinSell(address pay_gem, uint min_amount);
486     event LogMatchingEnabled(bool isEnabled);
487     event LogUnsortedOffer(uint id);
488     event LogSortedOffer(uint id);
489     event LogAddTokenPairWhitelist(ERC20 baseToken, ERC20 quoteToken);
490     event LogRemTokenPairWhitelist(ERC20 baseToken, ERC20 quoteToken);
491     event LogInsert(address keeper, uint id);
492     event LogDelete(address keeper, uint id);
493 }
494 
495 contract MatchingMarket is MatchingEvents, ExpiringMarket, DSNote {
496     bool public buyEnabled = true;      //buy enabled
497     bool public matchingEnabled = true; //true: enable matching,
498                                          //false: revert to expiring market
499     struct sortInfo {
500         uint next;  //points to id of next higher offer
501         uint prev;  //points to id of previous lower offer
502         uint delb;  //the blocknumber where this entry was marked for delete
503     }
504     mapping(uint => sortInfo) public _rank;                     //doubly linked lists of sorted offer ids
505     mapping(address => mapping(address => uint)) public _best;  //id of the highest offer for a token pair
506     mapping(address => mapping(address => uint)) public _span;  //number of offers stored for token pair in sorted orderbook
507     mapping(address => uint) public _dust;                      //minimum sell amount for a token to avoid dust offers
508     mapping(uint => uint) public _near;         //next unsorted offer id
509     mapping(bytes32 => bool) public _menu;      //whitelist tracking which token pairs can be traded
510     uint _head;                                 //first unsorted offer id
511 
512     //check if token pair is enabled
513     modifier isWhitelist(ERC20 buy_gem, ERC20 pay_gem) {
514         require(_menu[keccak256(buy_gem, pay_gem)] || _menu[keccak256(pay_gem, buy_gem)]);
515         _;
516     }
517 
518     function MatchingMarket(uint64 close_time) ExpiringMarket(close_time) public {
519     }
520 
521     // ---- Public entrypoints ---- //
522 
523     function make(
524         ERC20    pay_gem,
525         ERC20    buy_gem,
526         uint128  pay_amt,
527         uint128  buy_amt
528     )
529         public
530         returns (bytes32)
531     {
532         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
533     }
534 
535     function take(bytes32 id, uint128 maxTakeAmount) public {
536         require(buy(uint256(id), maxTakeAmount));
537     }
538 
539     function kill(bytes32 id) public {
540         require(cancel(uint256(id)));
541     }
542 
543     // Make a new offer. Takes funds from the caller into market escrow.
544     //
545     // If matching is enabled:
546     //     * creates new offer without putting it in
547     //       the sorted list.
548     //     * available to authorized contracts only!
549     //     * keepers should call insert(id,pos)
550     //       to put offer in the sorted list.
551     //
552     // If matching is disabled:
553     //     * calls expiring market's offer().
554     //     * available to everyone without authorization.
555     //     * no sorting is done.
556     //
557     function offer(
558         uint pay_amt,    //maker (ask) sell how much
559         ERC20 pay_gem,   //maker (ask) sell which token
560         uint buy_amt,    //taker (ask) buy how much
561         ERC20 buy_gem    //taker (ask) buy which token
562     )
563         public
564         isWhitelist(pay_gem, buy_gem)
565         /* NOT synchronized!!! */
566         returns (uint)
567     {
568         var fn = matchingEnabled ? _offeru : super.offer;
569         return fn(pay_amt, pay_gem, buy_amt, buy_gem);
570     }
571 
572     // Make a new offer. Takes funds from the caller into market escrow.
573     function offer(
574         uint pay_amt,    //maker (ask) sell how much
575         ERC20 pay_gem,   //maker (ask) sell which token
576         uint buy_amt,    //maker (ask) buy how much
577         ERC20 buy_gem,   //maker (ask) buy which token
578         uint pos         //position to insert offer, 0 should be used if unknown
579     )
580         public
581         isWhitelist(pay_gem, buy_gem)
582         /*NOT synchronized!!! */
583         can_offer
584         returns (uint)
585     {
586         return offer(pay_amt, pay_gem, buy_amt, buy_gem, pos, false);
587     }
588 
589     function offer(
590         uint pay_amt,    //maker (ask) sell how much
591         ERC20 pay_gem,   //maker (ask) sell which token
592         uint buy_amt,    //maker (ask) buy how much
593         ERC20 buy_gem,   //maker (ask) buy which token
594         uint pos,        //position to insert offer, 0 should be used if unknown
595         bool rounding    //match "close enough" orders?
596     )
597         public
598         isWhitelist(pay_gem, buy_gem)
599         /*NOT synchronized!!! */
600         can_offer
601         returns (uint)
602     {
603         require(_dust[pay_gem] <= pay_amt);
604 
605         if (matchingEnabled) {
606           return _matcho(pay_amt, pay_gem, buy_amt, buy_gem, pos, rounding);
607         }
608         return super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
609     }
610 
611     //Transfers funds from caller to offer maker, and from market to caller.
612     function buy(uint id, uint amount)
613         public
614         /*NOT synchronized!!! */
615         can_buy(id)
616         returns (bool)
617     {
618         var fn = matchingEnabled ? _buys : super.buy;
619         return fn(id, amount);
620     }
621 
622     // Cancel an offer. Refunds offer maker.
623     function cancel(uint id)
624         public
625         /*NOT synchronized!!! */
626         can_cancel(id)
627         returns (bool success)
628     {
629         if (matchingEnabled) {
630             if (isOfferSorted(id)) {
631                 require(_unsort(id));
632             } else {
633                 require(_hide(id));
634             }
635         }
636         return super.cancel(id);    //delete the offer.
637     }
638 
639     //insert offer into the sorted list
640     //keepers need to use this function
641     function insert(
642         uint id,   //maker (ask) id
643         uint pos   //position to insert into
644     )
645         public
646         returns (bool)
647     {
648         require(!isOfferSorted(id));    //make sure offers[id] is not yet sorted
649         require(isActive(id));          //make sure offers[id] is active
650 
651         _hide(id);                      //remove offer from unsorted offers list
652         _sort(id, pos);                 //put offer into the sorted offers list
653         LogInsert(msg.sender, id);
654         return true;
655     }
656 
657     //deletes _rank [id]
658     //  Function should be called by keepers.
659     function del_rank(uint id)
660         public
661     returns (bool)
662     {
663         require(!isActive(id) && _rank[id].delb != 0 && _rank[id].delb < block.number - 10);
664         delete _rank[id];
665         LogDelete(msg.sender, id);
666         return true;
667     }
668 
669     //returns true if token is succesfully added to whitelist
670     //  Function is used to add a token pair to the whitelist
671     //  All incoming offers are checked against the whitelist.
672     function addTokenPairWhitelist(
673         ERC20 baseToken,
674         ERC20 quoteToken
675     )
676         public
677         auth
678         note
679     returns (bool)
680     {
681         require(!isTokenPairWhitelisted(baseToken, quoteToken));
682         require(address(baseToken) != 0x0 && address(quoteToken) != 0x0);
683 
684         _menu[keccak256(baseToken, quoteToken)] = true;
685         LogAddTokenPairWhitelist(baseToken, quoteToken);
686         return true;
687     }
688 
689     //returns true if token is successfully removed from whitelist
690     //  Function is used to remove a token pair from the whitelist.
691     //  All incoming offers are checked against the whitelist.
692     function remTokenPairWhitelist(
693         ERC20 baseToken,
694         ERC20 quoteToken
695     )
696         public
697         auth
698         note
699     returns (bool)
700     {
701         require(isTokenPairWhitelisted(baseToken, quoteToken));
702 
703         delete _menu[keccak256(baseToken, quoteToken)];
704         delete _menu[keccak256(quoteToken, baseToken)];
705         LogRemTokenPairWhitelist(baseToken, quoteToken);
706         return true;
707     }
708 
709     function isTokenPairWhitelisted(
710         ERC20 baseToken,
711         ERC20 quoteToken
712     )
713         public
714         constant
715         returns (bool)
716     {
717         return (_menu[keccak256(baseToken, quoteToken)] || _menu[keccak256(quoteToken, baseToken)]);
718     }
719 
720     //set the minimum sell amount for a token
721     //    Function is used to avoid "dust offers" that have
722     //    very small amount of tokens to sell, and it would
723     //    cost more gas to accept the offer, than the value
724     //    of tokens received.
725     function setMinSell(
726         ERC20 pay_gem,     //token to assign minimum sell amount to
727         uint dust          //maker (ask) minimum sell amount
728     )
729         public
730         auth
731         note
732         returns (bool)
733     {
734         _dust[pay_gem] = dust;
735         LogMinSell(pay_gem, dust);
736         return true;
737     }
738 
739     //returns the minimum sell amount for an offer
740     function getMinSell(
741         ERC20 pay_gem      //token for which minimum sell amount is queried
742     )
743         public
744         constant
745         returns (uint)
746     {
747         return _dust[pay_gem];
748     }
749 
750     //set buy functionality enabled/disabled
751     function setBuyEnabled(bool buyEnabled_) public auth returns (bool) {
752         buyEnabled = buyEnabled_;
753         LogBuyEnabled(buyEnabled);
754         return true;
755     }
756 
757     //set matching enabled/disabled
758     //    If matchingEnabled true(default), then inserted offers are matched.
759     //    Except the ones inserted by contracts, because those end up
760     //    in the unsorted list of offers, that must be later sorted by
761     //    keepers using insert().
762     //    If matchingEnabled is false then MatchingMarket is reverted to ExpiringMarket,
763     //    and matching is not done, and sorted lists are disabled.
764     function setMatchingEnabled(bool matchingEnabled_) public auth returns (bool) {
765         matchingEnabled = matchingEnabled_;
766         LogMatchingEnabled(matchingEnabled);
767         return true;
768     }
769 
770     //return the best offer for a token pair
771     //      the best offer is the lowest one if it's an ask,
772     //      and highest one if it's a bid offer
773     function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
774         return _best[sell_gem][buy_gem];
775     }
776 
777     //return the next worse offer in the sorted list
778     //      the worse offer is the higher one if its an ask,
779     //      a lower one if its a bid offer,
780     //      and in both cases the newer one if they're equal.
781     function getWorseOffer(uint id) public constant returns(uint) {
782         return _rank[id].prev;
783     }
784 
785     //return the next better offer in the sorted list
786     //      the better offer is in the lower priced one if its an ask,
787     //      the next higher priced one if its a bid offer
788     //      and in both cases the older one if they're equal.
789     function getBetterOffer(uint id) public constant returns(uint) {
790 
791         return _rank[id].next;
792     }
793 
794     //return the amount of better offers for a token pair
795     function getOfferCount(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
796         return _span[sell_gem][buy_gem];
797     }
798 
799     //get the first unsorted offer that was inserted by a contract
800     //      Contracts can't calculate the insertion position of their offer because it is not an O(1) operation.
801     //      Their offers get put in the unsorted list of offers.
802     //      Keepers can calculate the insertion position offchain and pass it to the insert() function to insert
803     //      the unsorted offer into the sorted list. Unsorted offers will not be matched, but can be bought with buy().
804     function getFirstUnsortedOffer() public constant returns(uint) {
805         return _head;
806     }
807 
808     //get the next unsorted offer
809     //      Can be used to cycle through all the unsorted offers.
810     function getNextUnsortedOffer(uint id) public constant returns(uint) {
811         return _near[id];
812     }
813 
814     function isOfferSorted(uint id) public constant returns(bool) {
815         return _rank[id].next != 0
816                || _rank[id].prev != 0
817                || _best[offers[id].pay_gem][offers[id].buy_gem] == id;
818     }
819 
820     function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount)
821         public
822         returns (uint fill_amt)
823     {
824         uint offerId;
825         while (pay_amt > 0) {                           //while there is amount to sell
826             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
827             require(offerId != 0);                      //Fails if there are not more offers
828 
829             // There is a chance that pay_amt is smaller than 1 wei of the other token
830             if (pay_amt * 1 ether < wdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) {
831                 break;                                  //We consider that all amount is sold
832             }
833             if (pay_amt >= offers[offerId].buy_amt) {                       //If amount to sell is higher or equal than current offer amount to buy
834                 fill_amt = add(fill_amt, offers[offerId].pay_amt);          //Add amount bought to acumulator
835                 pay_amt = sub(pay_amt, offers[offerId].buy_amt);            //Decrease amount to sell
836                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
837             } else { // if lower
838                 var baux = rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9;
839                 fill_amt = add(fill_amt, baux);         //Add amount bought to acumulator
840                 take(bytes32(offerId), uint128(baux));  //We take the portion of the offer that we need
841                 pay_amt = 0;                            //All amount is sold
842             }
843         }
844         require(fill_amt >= min_fill_amount);
845     }
846 
847     function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount)
848         public
849         returns (uint fill_amt)
850     {
851         uint offerId;
852         while (buy_amt > 0) {                           //Meanwhile there is amount to buy
853             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
854             require(offerId != 0);
855 
856             // There is a chance that buy_amt is smaller than 1 wei of the other token
857             if (buy_amt * 1 ether < wdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) {
858                 break;                                  //We consider that all amount is sold
859             }
860             if (buy_amt >= offers[offerId].pay_amt) {                       //If amount to buy is higher or equal than current offer amount to sell
861                 fill_amt = add(fill_amt, offers[offerId].buy_amt);          //Add amount sold to acumulator
862                 buy_amt = sub(buy_amt, offers[offerId].pay_amt);            //Decrease amount to buy
863                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
864             } else {                                                        //if lower
865                 fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add amount sold to acumulator
866                 take(bytes32(offerId), uint128(buy_amt));                   //We take the portion of the offer that we need
867                 buy_amt = 0;                                                //All amount is bought
868             }
869         }
870         require(fill_amt <= max_fill_amount);
871     }
872 
873     function getBuyAmount(ERC20 buy_gem, ERC20 pay_gem, uint pay_amt) public constant returns (uint fill_amt) {
874         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
875         while (pay_amt > offers[offerId].buy_amt) {
876             fill_amt = add(fill_amt, offers[offerId].pay_amt);  //Add amount to buy accumulator
877             pay_amt = sub(pay_amt, offers[offerId].buy_amt);    //Decrease amount to pay
878             if (pay_amt > 0) {                                  //If we still need more offers
879                 offerId = getWorseOffer(offerId);               //We look for the next best offer
880                 require(offerId != 0);                          //Fails if there are not enough offers to complete
881             }
882         }
883         fill_amt = add(fill_amt, rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9); //Add proportional amount of last offer to buy accumulator
884     }
885 
886     function getPayAmount(ERC20 pay_gem, ERC20 buy_gem, uint buy_amt) public constant returns (uint fill_amt) {
887         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
888         while (buy_amt > offers[offerId].pay_amt) {
889             fill_amt = add(fill_amt, offers[offerId].buy_amt);  //Add amount to pay accumulator
890             buy_amt = sub(buy_amt, offers[offerId].pay_amt);    //Decrease amount to buy
891             if (buy_amt > 0) {                                  //If we still need more offers
892                 offerId = getWorseOffer(offerId);               //We look for the next best offer
893                 require(offerId != 0);                          //Fails if there are not enough offers to complete
894             }
895         }
896         fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add proportional amount of last offer to pay accumulator
897     }
898 
899     // ---- Internal Functions ---- //
900 
901     function _buys(uint id, uint amount)
902         internal
903         returns (bool)
904     {
905         require(buyEnabled);
906 
907         if (amount == offers[id].pay_amt && isOfferSorted(id)) {
908             //offers[id] must be removed from sorted list because all of it is bought
909             _unsort(id);
910         }
911         require(super.buy(id, amount));
912         return true;
913     }
914 
915     //find the id of the next higher offer after offers[id]
916     function _find(uint id)
917         internal
918         view
919         returns (uint)
920     {
921         require( id > 0 );
922 
923         address buy_gem = address(offers[id].buy_gem);
924         address pay_gem = address(offers[id].pay_gem);
925         uint top = _best[pay_gem][buy_gem];
926         uint old_top = 0;
927 
928         // Find the larger-than-id order whose successor is less-than-id.
929         while (top != 0 && _isPricedLtOrEq(id, top)) {
930             old_top = top;
931             top = _rank[top].prev;
932         }
933         return old_top;
934     }
935 
936     //find the id of the next higher offer after offers[id]
937     function _findpos(uint id, uint pos)
938         internal
939         view
940     returns (uint)
941     {
942         require(id > 0);
943 
944         // Look for an active order.
945         while (pos != 0 && !isActive(pos)) {
946             pos = _rank[pos].prev;
947         }
948 
949         if (pos == 0) {
950             //if we got to the end of list without a single active offer
951             return _find(id);
952 
953         } else {
954             // if we did find a nearby active offer
955             // Walk the order book down from there...
956             if(_isPricedLtOrEq(id, pos)) {
957                 uint old_pos;
958 
959                 // Guaranteed to run at least once because of
960                 // the prior if statements.
961                 while (pos != 0 && _isPricedLtOrEq(id, pos)) {
962                     old_pos = pos;
963                     pos = _rank[pos].prev;
964                 }
965                 return old_pos;
966 
967             // ...or walk it up.
968             } else {
969                 while (pos != 0 && !_isPricedLtOrEq(id, pos)) {
970                     pos = _rank[pos].next;
971                 }
972                 return pos;
973             }
974         }
975     }
976 
977     //return true if offers[low] priced less than or equal to offers[high]
978     function _isPricedLtOrEq(
979         uint low,   //lower priced offer's id
980         uint high   //higher priced offer's id
981     )
982         internal
983         view
984         returns (bool)
985     {
986         return mul(offers[low].buy_amt, offers[high].pay_amt)
987           >= mul(offers[high].buy_amt, offers[low].pay_amt);
988     }
989 
990     //these variables are global only because of solidity local variable limit
991 
992     //match offers with taker offer, and execute token transactions
993     function _matcho(
994         uint t_pay_amt,    //taker sell how much
995         ERC20 t_pay_gem,   //taker sell which token
996         uint t_buy_amt,    //taker buy how much
997         ERC20 t_buy_gem,   //taker buy which token
998         uint pos,          //position id
999         bool rounding      //match "close enough" orders?
1000     )
1001         internal
1002         returns (uint id)
1003     {
1004         uint best_maker_id;    //highest maker id
1005         uint t_buy_amt_old;    //taker buy how much saved
1006         uint m_buy_amt;        //maker offer wants to buy this much token
1007         uint m_pay_amt;        //maker offer wants to sell this much token
1008 
1009         // there is at least one offer stored for token pair
1010         while (_best[t_buy_gem][t_pay_gem] > 0) {
1011             best_maker_id = _best[t_buy_gem][t_pay_gem];
1012             m_buy_amt = offers[best_maker_id].buy_amt;
1013             m_pay_amt = offers[best_maker_id].pay_amt;
1014 
1015             // Ugly hack to work around rounding errors. Based on the idea that
1016             // the furthest the amounts can stray from their "true" values is 1.
1017             // Ergo the worst case has t_pay_amt and m_pay_amt at +1 away from
1018             // their "correct" values and m_buy_amt and t_buy_amt at -1.
1019             // Since (c - 1) * (d - 1) > (a + 1) * (b + 1) is equivalent to
1020             // c * d > a * b + a + b + c + d, we write...
1021             if (mul(m_buy_amt, t_buy_amt) > mul(t_pay_amt, m_pay_amt) +
1022                 (rounding ? m_buy_amt + t_buy_amt + t_pay_amt + m_pay_amt : 0))
1023             {
1024                 break;
1025             }
1026             // ^ The `rounding` parameter is a compromise borne of a couple days
1027             // of discussion.
1028 
1029             buy(best_maker_id, min(m_pay_amt, t_buy_amt));
1030             t_buy_amt_old = t_buy_amt;
1031             t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
1032             t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
1033 
1034             if (t_pay_amt == 0 || t_buy_amt == 0) {
1035                 break;
1036             }
1037         }
1038 
1039         if (t_buy_amt > 0 && t_pay_amt > 0) {
1040             //new offer should be created
1041             id = super.offer(t_pay_amt, t_pay_gem, t_buy_amt, t_buy_gem);
1042             //insert offer into the sorted list
1043             _sort(id, pos);
1044         }
1045     }
1046 
1047     // Make a new offer without putting it in the sorted list.
1048     // Takes funds from the caller into market escrow.
1049     // ****Available to authorized contracts only!**********
1050     // Keepers should call insert(id,pos) to put offer in the sorted list.
1051     function _offeru(
1052         uint pay_amt,      //maker (ask) sell how much
1053         ERC20 pay_gem,     //maker (ask) sell which token
1054         uint buy_amt,      //maker (ask) buy how much
1055         ERC20 buy_gem      //maker (ask) buy which token
1056     )
1057         internal
1058         /*NOT synchronized!!! */
1059         returns (uint id)
1060     {
1061         require(_dust[pay_gem] <= pay_amt);
1062         id = super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
1063         _near[id] = _head;
1064         _head = id;
1065         LogUnsortedOffer(id);
1066     }
1067 
1068     //put offer into the sorted list
1069     function _sort(
1070         uint id,    //maker (ask) id
1071         uint pos    //position to insert into
1072     )
1073         internal
1074     {
1075         require(isActive(id));
1076 
1077         address buy_gem = address(offers[id].buy_gem);
1078         address pay_gem = address(offers[id].pay_gem);
1079         uint prev_id;                                      //maker (ask) id
1080 
1081         if (pos == 0 || !isOfferSorted(pos)) {
1082             pos = _find(id);
1083         } else {
1084             pos = _findpos(id, pos);
1085 
1086             //if user has entered a `pos` that belongs to another currency pair
1087             //we start from scratch
1088             if(pos != 0 && (offers[pos].pay_gem != offers[id].pay_gem
1089                       || offers[pos].buy_gem != offers[id].buy_gem))
1090             {
1091                 pos = 0;
1092                 pos=_find(id);
1093             }
1094         }
1095 
1096 
1097         //requirement below is satisfied by statements above
1098         //require(pos == 0 || isOfferSorted(pos));
1099 
1100 
1101         if (pos != 0) {                                    //offers[id] is not the highest offer
1102             //requirement below is satisfied by statements above
1103             //require(_isPricedLtOrEq(id, pos));
1104             prev_id = _rank[pos].prev;
1105             _rank[pos].prev = id;
1106             _rank[id].next = pos;
1107         } else {                                           //offers[id] is the highest offer
1108             prev_id = _best[pay_gem][buy_gem];
1109             _best[pay_gem][buy_gem] = id;
1110         }
1111 
1112         if (prev_id != 0) {                               //if lower offer does exist
1113             //requirement below is satisfied by statements above
1114             //require(!_isPricedLtOrEq(id, prev_id));
1115             _rank[prev_id].next = id;
1116             _rank[id].prev = prev_id;
1117         }
1118 
1119         _span[pay_gem][buy_gem]++;
1120         LogSortedOffer(id);
1121     }
1122 
1123     // Remove offer from the sorted list (does not cancel offer)
1124     function _unsort(
1125         uint id    //id of maker (ask) offer to remove from sorted list
1126     )
1127         internal
1128         returns (bool)
1129     {
1130         address buy_gem = address(offers[id].buy_gem);
1131         address pay_gem = address(offers[id].pay_gem);
1132         require(_span[pay_gem][buy_gem] > 0);
1133 
1134         require(_rank[id].delb == 0 &&                    //assert id is in the sorted list
1135                  isOfferSorted(id));
1136 
1137         if (id != _best[pay_gem][buy_gem]) {              // offers[id] is not the highest offer
1138             require(_rank[_rank[id].next].prev == id);
1139             _rank[_rank[id].next].prev = _rank[id].prev;
1140         } else {                                          //offers[id] is the highest offer
1141             _best[pay_gem][buy_gem] = _rank[id].prev;
1142         }
1143 
1144         if (_rank[id].prev != 0) {                        //offers[id] is not the lowest offer
1145             require(_rank[_rank[id].prev].next == id);
1146             _rank[_rank[id].prev].next = _rank[id].next;
1147         }
1148 
1149         _span[pay_gem][buy_gem]--;
1150         _rank[id].delb = block.number;                    //mark _rank[id] for deletion
1151         return true;
1152     }
1153 
1154     //Hide offer from the unsorted order book (does not cancel offer)
1155     function _hide(
1156         uint id     //id of maker offer to remove from unsorted list
1157     )
1158         internal
1159         returns (bool)
1160     {
1161         uint uid = _head;               //id of an offer in unsorted offers list
1162         uint pre = uid;                 //id of previous offer in unsorted offers list
1163 
1164         require(!isOfferSorted(id));    //make sure offer id is not in sorted offers list
1165 
1166         if (_head == id) {              //check if offer is first offer in unsorted offers list
1167             _head = _near[id];          //set head to new first unsorted offer
1168             _near[id] = 0;              //delete order from unsorted order list
1169             return true;
1170         }
1171         while (uid > 0 && uid != id) {  //find offer in unsorted order list
1172             pre = uid;
1173             uid = _near[uid];
1174         }
1175         if (uid != id) {                //did not find offer id in unsorted offers list
1176             return false;
1177         }
1178         _near[pre] = _near[id];         //set previous unsorted offer to point to offer after offer id
1179         _near[id] = 0;                  //delete order from unsorted order list
1180         return true;
1181     }
1182 }