1 /// matching_market.sol
2 
3 //
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU Affero General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 //
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU Affero General Public License for more details.
13 //
14 // You should have received a copy of the GNU Affero General Public License
15 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
16 
17 pragma solidity ^0.5.12;
18 
19 
20 contract DSNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  guy,
24         bytes32  indexed  foo,
25         bytes32  indexed  bar,
26         uint256           wad,
27         bytes             fax
28     ) anonymous;
29 
30     modifier note {
31         bytes32 foo;
32         bytes32 bar;
33         uint256 wad;
34 
35         assembly {
36             foo := calldataload(4)
37             bar := calldataload(36)
38             wad := callvalue
39         }
40 
41         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
42 
43         _;
44     }
45 }
46 
47 
48 contract DSAuthority {
49     function canCall(
50         address src, address dst, bytes4 sig
51     ) public view returns (bool);
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
63     constructor() public {
64         owner = msg.sender;
65         emit LogSetOwner(msg.sender);
66     }
67 
68     function setOwner(address owner_)
69         public
70         auth
71     {
72         owner = owner_;
73         emit LogSetOwner(owner);
74     }
75 
76     function setAuthority(DSAuthority authority_)
77         public
78         auth
79     {
80         authority = authority_;
81         emit LogSetAuthority(address(authority));
82     }
83 
84     modifier auth {
85         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
86         _;
87     }
88 
89     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
90         if (src == address(this)) {
91             return true;
92         } else if (src == owner) {
93             return true;
94         } else if (authority == DSAuthority(0)) {
95             return false;
96         } else {
97             return authority.canCall(src, address(this), sig);
98         }
99     }
100 }
101 
102 contract DSMath {
103     function add(uint x, uint y) internal pure returns (uint z) {
104         require((z = x + y) >= x, "ds-math-add-overflow");
105     }
106     function sub(uint x, uint y) internal pure returns (uint z) {
107         require((z = x - y) <= x, "ds-math-sub-underflow");
108     }
109     function mul(uint x, uint y) internal pure returns (uint z) {
110         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
111     }
112 
113     function min(uint x, uint y) internal pure returns (uint z) {
114         return x <= y ? x : y;
115     }
116     function max(uint x, uint y) internal pure returns (uint z) {
117         return x >= y ? x : y;
118     }
119     function imin(int x, int y) internal pure returns (int z) {
120         return x <= y ? x : y;
121     }
122     function imax(int x, int y) internal pure returns (int z) {
123         return x >= y ? x : y;
124     }
125 
126     uint constant WAD = 10 ** 18;
127     uint constant RAY = 10 ** 27;
128 
129     function wmul(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, y), WAD / 2) / WAD;
131     }
132     function rmul(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, y), RAY / 2) / RAY;
134     }
135     function wdiv(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, WAD), y / 2) / y;
137     }
138     function rdiv(uint x, uint y) internal pure returns (uint z) {
139         z = add(mul(x, RAY), y / 2) / y;
140     }
141 
142     // This famous algorithm is called "exponentiation by squaring"
143     // and calculates x^n with x as fixed-point and n as regular unsigned.
144     //
145     // It's O(log n), instead of O(n) for naive repeated multiplication.
146     //
147     // These facts are why it works:
148     //
149     //  If n is even, then x^n = (x^2)^(n/2).
150     //  If n is odd,  then x^n = x * x^(n-1),
151     //   and applying the equation for even x gives
152     //    x^n = x * (x^2)^((n-1) / 2).
153     //
154     //  Also, EVM division is flooring and
155     //    floor[(n-1) / 2] = floor[n / 2].
156     //
157     function rpow(uint x, uint n) internal pure returns (uint z) {
158         z = n % 2 != 0 ? x : RAY;
159 
160         for (n /= 2; n != 0; n /= 2) {
161             x = rmul(x, x);
162 
163             if (n % 2 != 0) {
164                 z = rmul(z, x);
165             }
166         }
167     }
168 }
169 
170 
171 contract ERC20Events {
172     event Approval(address indexed src, address indexed guy, uint wad);
173     event Transfer(address indexed src, address indexed dst, uint wad);
174 }
175 
176 contract ERC20 is ERC20Events {
177     function totalSupply() public view returns (uint);
178     function balanceOf(address guy) public view returns (uint);
179     function allowance(address src, address guy) public view returns (uint);
180 
181     function approve(address guy, uint wad) public returns (bool);
182     function transfer(address dst, uint wad) public;
183 
184     function transferFrom(address src, address dst, uint wad) public;
185 
186 }
187 
188 
189 contract EventfulMarket {
190     event LogItemUpdate(uint id);
191     event LogTrade(uint pay_amt, address indexed pay_gem,
192                    uint buy_amt, address indexed buy_gem);
193 
194     event LogMake(
195         bytes32  indexed  id,
196         bytes32  indexed  pair,
197         address  indexed  maker,
198         ERC20             pay_gem,
199         ERC20             buy_gem,
200         uint128           pay_amt,
201         uint128           buy_amt,
202         uint64            timestamp
203     );
204 
205     event LogBump(
206         bytes32  indexed  id,
207         bytes32  indexed  pair,
208         address  indexed  maker,
209         ERC20             pay_gem,
210         ERC20             buy_gem,
211         uint128           pay_amt,
212         uint128           buy_amt,
213         uint64            timestamp
214     );
215 
216     event LogTake(
217         bytes32           id,
218         bytes32  indexed  pair,
219         address  indexed  maker,
220         ERC20             pay_gem,
221         ERC20             buy_gem,
222         address  indexed  taker,
223         uint128           take_amt,
224         uint128           give_amt,
225         uint64            timestamp
226     );
227 
228     event LogKill(
229         bytes32  indexed  id,
230         bytes32  indexed  pair,
231         address  indexed  maker,
232         ERC20             pay_gem,
233         ERC20             buy_gem,
234         uint128           pay_amt,
235         uint128           buy_amt,
236         uint64            timestamp
237     );
238 }
239 
240 contract SimpleMarket is EventfulMarket, DSMath {
241 
242     uint public last_offer_id;
243 
244     mapping (uint => OfferInfo) public offers;
245 
246     bool locked;
247 
248     struct OfferInfo {
249         uint     pay_amt;
250         ERC20    pay_gem;
251         uint     buy_amt;
252         ERC20    buy_gem;
253         address  owner;
254         uint64   timestamp;
255     }
256 
257     modifier can_buy(uint id) {
258         require(isActive(id));
259         _;
260     }
261 
262     modifier can_cancel(uint id) {
263         require(isActive(id));
264         require(getOwner(id) == msg.sender);
265         _;
266     }
267 
268     modifier can_offer {
269         _;
270     }
271 
272     modifier synchronized {
273         require(!locked);
274         locked = true;
275         _;
276         locked = false;
277     }
278 
279     function isActive(uint id) public view returns (bool active) {
280         return offers[id].timestamp > 0;
281     }
282 
283     function getOwner(uint id) public view returns (address owner) {
284         return offers[id].owner;
285     }
286 
287     function getOffer(uint id) public view returns (uint, ERC20, uint, ERC20) {
288       OfferInfo memory offer = offers[id];
289       return (offer.pay_amt, offer.pay_gem,
290               offer.buy_amt, offer.buy_gem);
291     }
292 
293     // ---- Public entrypoints ---- //
294 
295     function bump(bytes32 id_)
296         public
297         can_buy(uint256(id_))
298     {
299         uint256 id = uint256(id_);
300         emit LogBump(
301             id_,
302             keccak256(abi.encodePacked(offers[id].pay_gem, offers[id].buy_gem)),
303             offers[id].owner,
304             offers[id].pay_gem,
305             offers[id].buy_gem,
306             uint128(offers[id].pay_amt),
307             uint128(offers[id].buy_amt),
308             offers[id].timestamp
309         );
310     }
311 
312     // Accept given `quantity` of an offer. Transfers funds from caller to
313     // offer maker, and from market to caller.
314     function buy(uint id, uint quantity)
315         public
316         can_buy(id)
317         synchronized
318         returns (bool)
319     {
320         OfferInfo memory offer = offers[id];
321         uint spend = mul(quantity, offer.buy_amt) / offer.pay_amt;
322 
323         require(uint128(spend) == spend);
324         require(uint128(quantity) == quantity);
325 
326         // For backwards semantic compatibility.
327         if (quantity == 0 || spend == 0 ||
328             quantity > offer.pay_amt || spend > offer.buy_amt)
329         {
330             return false;
331         }
332 
333         offers[id].pay_amt = sub(offer.pay_amt, quantity);
334         offers[id].buy_amt = sub(offer.buy_amt, spend);
335         offer.buy_gem.transferFrom(msg.sender, offer.owner, spend);
336         offer.pay_gem.transfer(msg.sender, quantity);
337 
338         emit LogItemUpdate(id);
339         emit LogTake(
340             bytes32(id),
341             keccak256(abi.encodePacked(offer.pay_gem, offer.buy_gem)),
342             offer.owner,
343             offer.pay_gem,
344             offer.buy_gem,
345             msg.sender,
346             uint128(quantity),
347             uint128(spend),
348             uint64(now)
349         );
350         emit LogTrade(quantity, address(offer.pay_gem), spend, address(offer.buy_gem));
351 
352         if (offers[id].pay_amt == 0) {
353           delete offers[id];
354         }
355 
356         return true;
357     }
358 
359     // Cancel an offer. Refunds offer maker.
360     function cancel(uint id)
361         public
362         can_cancel(id)
363         synchronized
364         returns (bool success)
365     {
366         // read-only offer. Modify an offer by directly accessing offers[id]
367         OfferInfo memory offer = offers[id];
368         delete offers[id];
369 
370         offer.pay_gem.transfer(offer.owner, offer.pay_amt);
371 
372         emit LogItemUpdate(id);
373         emit LogKill(
374             bytes32(id),
375             keccak256(abi.encodePacked(offer.pay_gem, offer.buy_gem)),
376             offer.owner,
377             offer.pay_gem,
378             offer.buy_gem,
379             uint128(offer.pay_amt),
380             uint128(offer.buy_amt),
381             uint64(now)
382         );
383 
384         success = true;
385     }
386 
387     function kill(bytes32 id)
388         public
389     {
390         require(cancel(uint256(id)));
391     }
392 
393     function make(
394         ERC20    pay_gem,
395         ERC20    buy_gem,
396         uint128  pay_amt,
397         uint128  buy_amt
398     )
399         public
400         returns (bytes32 id)
401     {
402         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
403     }
404 
405     // Make a new offer. Takes funds from the caller into market escrow.
406     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem)
407         public
408         can_offer
409         synchronized
410         returns (uint id)
411     {
412         require(uint128(pay_amt) == pay_amt);
413         require(uint128(buy_amt) == buy_amt);
414         require(pay_amt > 0);
415         require(pay_gem != ERC20(0x0));
416         require(buy_amt > 0);
417         require(buy_gem != ERC20(0x0));
418         require(pay_gem != buy_gem);
419 
420         OfferInfo memory info;
421         info.pay_amt = pay_amt;
422         info.pay_gem = pay_gem;
423         info.buy_amt = buy_amt;
424         info.buy_gem = buy_gem;
425         info.owner = msg.sender;
426         info.timestamp = uint64(now);
427         id = _next_id();
428         offers[id] = info;
429 
430         pay_gem.transferFrom(msg.sender, address(this), pay_amt);
431 
432         emit LogItemUpdate(id);
433         emit LogMake(
434             bytes32(id),
435             keccak256(abi.encodePacked(pay_gem, buy_gem)),
436             msg.sender,
437             pay_gem,
438             buy_gem,
439             uint128(pay_amt),
440             uint128(buy_amt),
441             uint64(now)
442         );
443     }
444 
445     function take(bytes32 id, uint128 maxTakeAmount)
446         public
447     {
448         require(buy(uint256(id), maxTakeAmount));
449     }
450 
451     function _next_id()
452         internal
453         returns (uint)
454     {
455         last_offer_id++; return last_offer_id;
456     }
457 }
458 
459 // Simple Market with a market lifetime. When the close_time has been reached,
460 // offers can only be cancelled (offer and buy will throw).
461 
462 contract ExpiringMarket is DSAuth, SimpleMarket {
463     uint64 public close_time;
464     bool public stopped;
465 
466     // after close_time has been reached, no new offers are allowed
467     modifier can_offer {
468         require(!isClosed());
469         _;
470     }
471 
472     // after close, no new buys are allowed
473     modifier can_buy(uint id) {
474         require(isActive(id));
475         require(!isClosed());
476         _;
477     }
478 
479     // after close, anyone can cancel an offer
480     modifier can_cancel(uint id) {
481         require(isActive(id));
482         require((msg.sender == getOwner(id)) || isClosed());
483         _;
484     }
485 
486     constructor(uint64 _close_time)
487         public
488     {
489         close_time = _close_time;
490     }
491 
492     function isClosed() public view returns (bool closed) {
493         return stopped || getTime() > close_time;
494     }
495 
496     function getTime() public view returns (uint64) {
497         return uint64(now);
498     }
499 
500     function stop() public auth {
501         stopped = true;
502     }
503 }
504 
505 
506 contract MatchingEvents {
507     event LogBuyEnabled(bool isEnabled);
508     event LogMinSell(address pay_gem, uint min_amount);
509     event LogMatchingEnabled(bool isEnabled);
510     event LogUnsortedOffer(uint id);
511     event LogSortedOffer(uint id);
512     event LogInsert(address keeper, uint id);
513     event LogDelete(address keeper, uint id);
514 }
515 
516 contract MatchingMarket is MatchingEvents, ExpiringMarket, DSNote {
517     bool public buyEnabled = true;      // buy enabled
518     bool public matchingEnabled = true; // true: enable matching,
519                                         // false: revert to expiring market
520     struct sortInfo {
521         uint next;  // points to id of next higher offer
522         uint prev;  // points to id of previous lower offer
523         uint delb;  // the blocknumber where this entry was marked for delete
524     }
525     mapping(uint => sortInfo) public _rank;                     // doubly linked lists of sorted offer ids
526     mapping(address => mapping(address => uint)) public _best;  // id of the highest offer for a token pair
527     mapping(address => mapping(address => uint)) public _span;  // number of offers stored for token pair in sorted orderbook
528     mapping(address => uint) public _dust;                      // minimum sell amount for a token to avoid dust offers
529     mapping(uint => uint) public _near;         // next unsorted offer id
530     uint _head;                                 // first unsorted offer id
531     uint public dustId;                         // id of the latest offer marked as dust
532 
533 
534     constructor(uint64 close_time) ExpiringMarket(close_time) public {}
535 
536     // After close, anyone can cancel an offer
537     modifier can_cancel(uint id) {
538         require(isActive(id), "Offer was deleted or taken, or never existed.");
539         require(
540             isClosed() || msg.sender == getOwner(id) || id == dustId,
541             "Offer can not be cancelled because user is not owner, and market is open, and offer sells required amount of tokens."
542         );
543         _;
544     }
545 
546     // ---- Public entrypoints ---- //
547 
548     function make(ERC20 pay_gem, ERC20 buy_gem, uint128 pay_amt, uint128 buy_amt) public returns (bytes32) {
549         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
550     }
551 
552     function take(bytes32 id, uint128 maxTakeAmount) public {
553         require(buy(uint256(id), maxTakeAmount));
554     }
555 
556     function kill(bytes32 id) public {
557         require(cancel(uint256(id)));
558     }
559 
560     // Make a new offer. Takes funds from the caller into market escrow.
561     //
562     // If matching is enabled:
563     //     * creates new offer without putting it in
564     //       the sorted list.
565     //     * available to authorized contracts only!
566     //     * keepers should call insert(id,pos)
567     //       to put offer in the sorted list.
568     //
569     // If matching is disabled:
570     //     * calls expiring market's offer().
571     //     * available to everyone without authorization.
572     //     * no sorting is done.
573     //
574     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem) public returns (uint) {
575         // params:
576             //  uint pay_amt maker: (ask) sell how much
577             //  ERC20 pay_gem maker: (ask) sell which token
578             //  uint buy_amt: taker (ask) buy how much
579             //  ERC20 buy_gem: taker (ask) buy which token
580         // returns:
581             // uint
582         require(!locked, "Reentrancy attempt");
583         function (uint256,ERC20,uint256,ERC20) returns (uint256) fn = matchingEnabled ? _offeru : super.offer;
584         return fn(pay_amt, pay_gem, buy_amt, buy_gem);
585     }
586 
587     // Make a new offer. Takes funds from the caller into market escrow.
588     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem, uint pos) public can_offer returns (uint) {
589         // params:
590             // uint pay_amt: maker (ask) sell how much
591             // ERC20 pay_gem: maker (ask) sell which token
592             // uint buy_amt: maker (ask) buy how much
593             // ERC20 buy_gem: maker (ask) buy which token
594             // uint pos: position to insert offer, 0 should be used if unknown
595         // returns:
596             // uint
597         return offer(pay_amt, pay_gem, buy_amt, buy_gem, pos, true);
598     }
599 
600     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt,
601                    ERC20 buy_gem,uint pos, bool rounding) public can_offer returns (uint) {
602         // params:
603             // uint pay_amt: maker (ask) sell how much
604             // ERC20 pay_gem: maker (ask) sell which token
605             // uint buy_amt: maker (ask) buy how much
606             // ERC20 buy_gem: maker (ask) buy which token
607             // uint pos: position to insert offer, 0 should be used if unknown
608             // bool rounding: match "close enough" orders?
609         // returns:
610             // uint
611         require(!locked, "Reentrancy attempt");
612         require(_dust[address(pay_gem)] <= pay_amt);
613 
614         if (matchingEnabled) {
615           return _matcho(pay_amt, pay_gem, buy_amt, buy_gem, pos, rounding);
616         }
617         return super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
618     }
619 
620     //Transfers funds from caller to offer maker, and from market to caller.
621     function buy(uint id, uint amount) public can_buy(id) returns (bool) {
622         require(!locked, "Reentrancy attempt");
623         function (uint256,uint256) returns (bool) fn = matchingEnabled ? _buys : super.buy;
624         return fn(id, amount);
625     }
626 
627     // Cancel an offer. Refunds offer maker.
628     function cancel(uint id) public can_cancel(id) returns (bool success) {
629         require(!locked, "Reentrancy attempt");
630 
631         if (matchingEnabled) {
632             if (isOfferSorted(id)) {
633                 require(_unsort(id));
634             }
635             else {
636                 require(_hide(id));
637             }
638         }
639         return super.cancel(id);    //delete the offer.
640     }
641 
642     //insert offer into the sorted list
643     //keepers need to use this function
644     function insert(uint id, uint pos) public returns (bool) {
645         // params:
646             //uint id: maker (ask) id
647             //uint pos: position to insert into
648         // returns:
649             // bool
650 
651         require(!locked, "Reentrancy attempt");
652         require(!isOfferSorted(id));    //make sure offers[id] is not yet sorted
653         require(isActive(id));          //make sure offers[id] is active
654 
655         _hide(id);                      //remove offer from unsorted offers list
656         _sort(id, pos);                 //put offer into the sorted offers list
657         emit LogInsert(msg.sender, id);
658         return true;
659     }
660 
661     //deletes _rank [id]
662     //  Function should be called by keepers.
663     function del_rank(uint id) public returns (bool) {
664         require(!locked, "Reentrancy attempt");
665         require(!isActive(id) && _rank[id].delb != 0 && _rank[id].delb < block.number - 10);
666 
667         delete _rank[id];
668 
669         emit LogDelete(msg.sender, id);
670         return true;
671     }
672 
673     //set the minimum sell amount for a token
674     //    Function is used to avoid "dust offers" that have
675     //    very small amount of tokens to sell, and it would
676     //    cost more gas to accept the offer, than the value
677     //    of tokens received.
678     function setMinSell(ERC20 pay_gem, uint dust) public auth note returns (bool) {
679 
680         // params:
681             // ERC20 pay_gem: token to assign minimum sell amount to
682             // uint dust: maker (ask) minimum sell amount
683         // returns:
684             // bool
685 
686         _dust[address(pay_gem)] = dust;
687 
688         emit LogMinSell(address(pay_gem), dust);
689 
690         return true;
691     }
692 
693     //returns the minimum sell amount for an offer
694     function getMinSell(ERC20 pay_gem) public view returns (uint) {
695         // params:
696             // ERC20 pay_gem      //token for which minimum sell amount is queried
697         // returns:
698             // uint
699 
700         return _dust[address(pay_gem)];
701     }
702 
703     //set buy functionality enabled/disabled
704     function setBuyEnabled(bool buyEnabled_) public auth returns (bool) {
705         buyEnabled = buyEnabled_;
706         emit LogBuyEnabled(buyEnabled);
707         return true;
708     }
709 
710     //set matching enabled/disabled
711     //    If matchingEnabled true(default), then inserted offers are matched.
712     //    Except the ones inserted by contracts, because those end up
713     //    in the unsorted list of offers, that must be later sorted by
714     //    keepers using insert().
715     //    If matchingEnabled is false then MatchingMarket is reverted to ExpiringMarket,
716     //    and matching is not done, and sorted lists are disabled.
717     function setMatchingEnabled(bool matchingEnabled_) public auth returns (bool) {
718         matchingEnabled = matchingEnabled_;
719         emit LogMatchingEnabled(matchingEnabled);
720         return true;
721     }
722 
723     //return the best offer for a token pair
724     //      the best offer is the lowest one if it's an ask,
725     //      and highest one if it's a bid offer
726     function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public view returns(uint) {
727         return _best[address(sell_gem)][address(buy_gem)];
728     }
729 
730     //return the next worse offer in the sorted list
731     //      the worse offer is the higher one if its an ask,
732     //      a lower one if its a bid offer,
733     //      and in both cases the newer one if they're equal.
734     function getWorseOffer(uint id) public view returns(uint) {
735         return _rank[id].prev;
736     }
737 
738     //return the next better offer in the sorted list
739     //      the better offer is in the lower priced one if its an ask,
740     //      the next higher priced one if its a bid offer
741     //      and in both cases the older one if they're equal.
742     function getBetterOffer(uint id) public view returns(uint) {
743 
744         return _rank[id].next;
745     }
746 
747     //return the amount of better offers for a token pair
748     function getOfferCount(ERC20 sell_gem, ERC20 buy_gem) public view returns(uint) {
749         return _span[address(sell_gem)][address(buy_gem)];
750     }
751 
752     //get the first unsorted offer that was inserted by a contract
753     //      Contracts can't calculate the insertion position of their offer because it is not an O(1) operation.
754     //      Their offers get put in the unsorted list of offers.
755     //      Keepers can calculate the insertion position offchain and pass it to the insert() function to insert
756     //      the unsorted offer into the sorted list. Unsorted offers will not be matched, but can be bought with buy().
757     function getFirstUnsortedOffer() public view returns(uint) {
758         return _head;
759     }
760 
761     //get the next unsorted offer
762     //      Can be used to cycle through all the unsorted offers.
763     function getNextUnsortedOffer(uint id) public view returns(uint) {
764         return _near[id];
765     }
766 
767     function isOfferSorted(uint id) public view returns(bool) {
768         return _rank[id].next != 0
769                || _rank[id].prev != 0
770                || _best[address(offers[id].pay_gem)][address(offers[id].buy_gem)] == id;
771     }
772 
773     function sellAllAmount(ERC20 pay_gem, uint pay_amt,
774                            ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt) {
775 
776         require(!locked, "Reentrancy attempt");
777 
778         uint offerId;
779 
780         while (pay_amt > 0) {                           //while there is amount to sell
781             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
782             require(offerId != 0);                      //Fails if there are not more offers
783 
784             // There is a chance that pay_amt is smaller than 1 wei of the other token
785             if (pay_amt * 1 ether < wdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) {
786                 break;                                  //We consider that all amount is sold
787             }
788             if (pay_amt >= offers[offerId].buy_amt) {                       //If amount to sell is higher or equal than current offer amount to buy
789                 fill_amt = add(fill_amt, offers[offerId].pay_amt);          //Add amount bought to acumulator
790                 pay_amt = sub(pay_amt, offers[offerId].buy_amt);            //Decrease amount to sell
791                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
792             } else { // if lower
793                 uint256 baux = rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9;
794                 fill_amt = add(fill_amt, baux);         //Add amount bought to acumulator
795                 take(bytes32(offerId), uint128(baux));  //We take the portion of the offer that we need
796                 pay_amt = 0;                            //All amount is sold
797             }
798         }
799         require(fill_amt >= min_fill_amount);
800     }
801 
802     function buyAllAmount(ERC20 buy_gem, uint buy_amt,
803                           ERC20 pay_gem, uint max_fill_amount) public returns (uint fill_amt) {
804 
805         require(!locked, "Reentrancy attempt");
806 
807         uint offerId;
808 
809         while (buy_amt > 0) {                           //Meanwhile there is amount to buy
810             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
811             require(offerId != 0);
812 
813             // There is a chance that buy_amt is smaller than 1 wei of the other token
814             if (buy_amt * 1 ether < wdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) {
815                 break;                                  //We consider that all amount is sold
816             }
817             if (buy_amt >= offers[offerId].pay_amt) {                       //If amount to buy is higher or equal than current offer amount to sell
818                 fill_amt = add(fill_amt, offers[offerId].buy_amt);          //Add amount sold to acumulator
819                 buy_amt = sub(buy_amt, offers[offerId].pay_amt);            //Decrease amount to buy
820                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
821             } else {                                                        //if lower
822                 fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add amount sold to acumulator
823                 take(bytes32(offerId), uint128(buy_amt));                   //We take the portion of the offer that we need
824                 buy_amt = 0;                                                //All amount is bought
825             }
826         }
827         require(fill_amt <= max_fill_amount);
828     }
829 
830     function getBuyAmount(ERC20 buy_gem, ERC20 pay_gem, uint pay_amt) public view returns (uint fill_amt) {
831         uint256 offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
832         while (pay_amt > offers[offerId].buy_amt) {
833             fill_amt = add(fill_amt, offers[offerId].pay_amt);  //Add amount to buy accumulator
834             pay_amt = sub(pay_amt, offers[offerId].buy_amt);    //Decrease amount to pay
835             if (pay_amt > 0) {                                  //If we still need more offers
836                 offerId = getWorseOffer(offerId);               //We look for the next best offer
837                 require(offerId != 0);                          //Fails if there are not enough offers to complete
838             }
839         }
840          //Add proportional amount of last offer to buy accumulator
841         fill_amt = add(fill_amt, rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9);
842     }
843 
844     function getPayAmount(ERC20 pay_gem, ERC20 buy_gem, uint buy_amt) public view returns (uint fill_amt) {
845         uint256 offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
846         while (buy_amt > offers[offerId].pay_amt) {
847             fill_amt = add(fill_amt, offers[offerId].buy_amt);  //Add amount to pay accumulator
848             buy_amt = sub(buy_amt, offers[offerId].pay_amt);    //Decrease amount to buy
849             if (buy_amt > 0) {                                  //If we still need more offers
850                 offerId = getWorseOffer(offerId);               //We look for the next best offer
851                 require(offerId != 0);                          //Fails if there are not enough offers to complete
852             }
853         }
854          //Add proportional amount of last offer to pay accumulator
855         fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9);
856     }
857 
858     // ---- Internal Functions ---- //
859 
860     function _buys(uint id, uint amount) internal returns (bool) {
861         require(buyEnabled);
862 
863         if (amount == offers[id].pay_amt) {
864             if (isOfferSorted(id)) {
865                 //offers[id] must be removed from sorted list because all of it is bought
866                 _unsort(id);
867             }else{
868                 _hide(id);
869             }
870         }
871         require(super.buy(id, amount));
872         // If offer has become dust during buy, we cancel it
873         if (isActive(id) && offers[id].pay_amt < _dust[address(offers[id].pay_gem)]) {
874             dustId = id; //enable current msg.sender to call cancel(id)
875             cancel(id);
876         }
877         return true;
878     }
879 
880     //find the id of the next higher offer after offers[id]
881     function _find(uint id) internal view returns (uint) {
882         require( id > 0 );
883 
884         address buy_gem = address(offers[id].buy_gem);
885         address pay_gem = address(offers[id].pay_gem);
886         uint top = _best[pay_gem][buy_gem];
887         uint old_top = 0;
888 
889         // Find the larger-than-id order whose successor is less-than-id.
890         while (top != 0 && _isPricedLtOrEq(id, top)) {
891             old_top = top;
892             top = _rank[top].prev;
893         }
894         return old_top;
895     }
896 
897     //find the id of the next higher offer after offers[id]
898     function _findpos(uint id, uint pos) internal view returns (uint) {
899         require(id > 0);
900 
901         // Look for an active order.
902         while (pos != 0 && !isActive(pos)) {
903             pos = _rank[pos].prev;
904         }
905 
906         if (pos == 0) {
907             //if we got to the end of list without a single active offer
908             return _find(id);
909 
910         } else {
911             // if we did find a nearby active offer
912             // Walk the order book down from there...
913             if (_isPricedLtOrEq(id, pos)) {
914                 uint old_pos;
915 
916                 // Guaranteed to run at least once because of
917                 // the prior if statements.
918                 while (pos != 0 && _isPricedLtOrEq(id, pos)) {
919                     old_pos = pos;
920                     pos = _rank[pos].prev;
921                 }
922                 return old_pos;
923 
924             // ...or walk it up.
925             } else {
926                 while (pos != 0 && !_isPricedLtOrEq(id, pos)) {
927                     pos = _rank[pos].next;
928                 }
929                 return pos;
930             }
931         }
932     }
933 
934     //return true if offers[low] priced less than or equal to offers[high]
935     function _isPricedLtOrEq(uint low, uint high) internal view returns (bool) {
936         // params:
937             // uint low: lower priced offer's id
938             // uint high: higher priced offer's id
939         // returns:
940             // bool
941 
942         return mul(offers[low].buy_amt, offers[high].pay_amt) >= mul(offers[high].buy_amt, offers[low].pay_amt);
943     }
944 
945     //these variables are global only because of solidity local variable limit
946 
947     //match offers with taker offer, and execute token transactions
948     function _matcho(uint t_pay_amt, ERC20 t_pay_gem,
949                      uint t_buy_amt, ERC20 t_buy_gem, uint pos, bool rounding) internal returns (uint id) {
950 
951         // params:
952             // uint t_pay_amt: taker sell how much
953             // ERC20 t_pay_gem: taker sell which token
954             // uint t_buy_amt: taker buy how much
955             // ERC20 t_buy_gem: taker buy which token
956             // uint pos: position id
957             // bool rounding: match "close enough" orders?
958         // returns:
959             // uint id
960 
961         uint best_maker_id;    //highest maker id
962         uint t_buy_amt_old;    //taker buy how much saved
963         uint m_buy_amt;        //maker offer wants to buy this much token
964         uint m_pay_amt;        //maker offer wants to sell this much token
965 
966         // there is at least one offer stored for token pair
967         while (_best[address(t_buy_gem)][address(t_pay_gem)] > 0) {
968             best_maker_id = _best[address(t_buy_gem)][address(t_pay_gem)];
969             m_buy_amt = offers[best_maker_id].buy_amt;
970             m_pay_amt = offers[best_maker_id].pay_amt;
971 
972             // Ugly hack to work around rounding errors. Based on the idea that
973             // the furthest the amounts can stray from their "true" values is 1.
974             // Ergo the worst case has t_pay_amt and m_pay_amt at +1 away from
975             // their "correct" values and m_buy_amt and t_buy_amt at -1.
976             // Since (c - 1) * (d - 1) > (a + 1) * (b + 1) is equivalent to
977             // c * d > a * b + a + b + c + d, we write...
978             if (mul(m_buy_amt, t_buy_amt) > mul(t_pay_amt, m_pay_amt) +
979                 (rounding ? m_buy_amt + t_buy_amt + t_pay_amt + m_pay_amt : 0))
980             {
981                 break;
982             }
983             // ^ The `rounding` parameter is a compromise borne of a couple days
984             // of discussion.
985             buy(best_maker_id, min(m_pay_amt, t_buy_amt));
986             t_buy_amt_old = t_buy_amt;
987             t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
988             t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
989 
990             if (t_pay_amt == 0 || t_buy_amt == 0) {
991                 break;
992             }
993         }
994 
995         if (t_buy_amt > 0 && t_pay_amt > 0 && t_pay_amt >= _dust[address(t_pay_gem)]) {
996             //new offer should be created
997             id = super.offer(t_pay_amt, t_pay_gem, t_buy_amt, t_buy_gem);
998             //insert offer into the sorted list
999             _sort(id, pos);
1000         }
1001     }
1002 
1003     // Make a new offer without putting it in the sorted list.
1004     // Takes funds from the caller into market escrow.
1005     // ****Available to authorized contracts only!**********
1006     // Keepers should call insert(id,pos) to put offer in the sorted list.
1007     function _offeru(uint pay_amt, ERC20 pay_gem,uint buy_amt, ERC20 buy_gem) internal returns (uint id) {
1008         // params:
1009             // uint pay_amt: maker (ask) sell how much
1010             // ERC20 pay_gem: maker (ask) sell which token
1011             // uint buy_amt: maker (ask) buy how much
1012             // ERC20 buy_gem: maker (ask) buy which token
1013         // returns:
1014             // uint id: offer id
1015 
1016         require(_dust[address(pay_gem)] <= pay_amt);
1017 
1018         id = super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
1019         _near[id] = _head;
1020         _head = id;
1021         emit LogUnsortedOffer(id);
1022     }
1023 
1024     //put offer into the sorted list
1025     function _sort(uint id, uint pos) internal {
1026         // params:
1027             // uint id: maker (ask) id
1028             // uint pos: position to insert into
1029 
1030         require(isActive(id));
1031 
1032         ERC20 buy_gem = offers[id].buy_gem;
1033         ERC20 pay_gem = offers[id].pay_gem;
1034         uint prev_id;                                      //maker (ask) id
1035 
1036         pos = pos == 0 || offers[pos].pay_gem != pay_gem || offers[pos].buy_gem != buy_gem || !isOfferSorted(pos)
1037         ?
1038             _find(id)
1039         :
1040             _findpos(id, pos);
1041 
1042         if (pos != 0) {                                    //offers[id] is not the highest offer
1043             //requirement below is satisfied by statements above
1044             //require(_isPricedLtOrEq(id, pos));
1045             prev_id = _rank[pos].prev;
1046             _rank[pos].prev = id;
1047             _rank[id].next = pos;
1048         } else {                                           //offers[id] is the highest offer
1049             prev_id = _best[address(pay_gem)][address(buy_gem)];
1050             _best[address(pay_gem)][address(buy_gem)] = id;
1051         }
1052 
1053         if (prev_id != 0) {                               //if lower offer does exist
1054             //requirement below is satisfied by statements above
1055             //require(!_isPricedLtOrEq(id, prev_id));
1056             _rank[prev_id].next = id;
1057             _rank[id].prev = prev_id;
1058         }
1059 
1060         _span[address(pay_gem)][address(buy_gem)]++;
1061         emit LogSortedOffer(id);
1062     }
1063 
1064     // Remove offer from the sorted list (does not cancel offer)
1065     function _unsort(uint id) internal returns (bool) {
1066         // params:
1067             // uint id: id of maker (ask) offer to remove from sorted list
1068         // returns:
1069             // bool
1070 
1071         address buy_gem = address(offers[id].buy_gem);
1072         address pay_gem = address(offers[id].pay_gem);
1073         require(_span[pay_gem][buy_gem] > 0);
1074 
1075         require(_rank[id].delb == 0 &&                    //assert id is in the sorted list
1076                  isOfferSorted(id));
1077 
1078         if (id != _best[pay_gem][buy_gem]) {              // offers[id] is not the highest offer
1079             require(_rank[_rank[id].next].prev == id);
1080             _rank[_rank[id].next].prev = _rank[id].prev;
1081         } else {                                          //offers[id] is the highest offer
1082             _best[pay_gem][buy_gem] = _rank[id].prev;
1083         }
1084 
1085         if (_rank[id].prev != 0) {                        //offers[id] is not the lowest offer
1086             require(_rank[_rank[id].prev].next == id);
1087             _rank[_rank[id].prev].next = _rank[id].next;
1088         }
1089 
1090         _span[pay_gem][buy_gem]--;
1091         _rank[id].delb = block.number;                    //mark _rank[id] for deletion
1092         return true;
1093     }
1094 
1095     //Hide offer from the unsorted order book (does not cancel offer)
1096     function _hide(uint id) internal returns (bool) {
1097         // params:
1098             // uint id: id of maker offer to remove from unsorted list
1099         // returns:
1100             // bool
1101 
1102         uint uid = _head;               // id of an offer in unsorted offers list
1103         uint pre = uid;                 // id of previous offer in unsorted offers list
1104 
1105         require(!isOfferSorted(id));    //make sure offer id is not in sorted offers list
1106 
1107         if (_head == id) {              //check if offer is first offer in unsorted offers list
1108             _head = _near[id];          //set head to new first unsorted offer
1109             _near[id] = 0;              //delete order from unsorted order list
1110             return true;
1111         }
1112         while (uid > 0 && uid != id) {  //find offer in unsorted order list
1113             pre = uid;
1114             uid = _near[uid];
1115         }
1116         if (uid != id) {                //did not find offer id in unsorted offers list
1117             return false;
1118         }
1119         _near[pre] = _near[id];         //set previous unsorted offer to point to offer after offer id
1120         _near[id] = 0;                  //delete order from unsorted order list
1121         return true;
1122     }
1123 }