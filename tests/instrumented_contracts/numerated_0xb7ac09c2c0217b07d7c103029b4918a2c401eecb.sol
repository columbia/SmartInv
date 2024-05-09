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
17 pragma solidity ^0.4.18;
18 
19 /// expiring_market.sol
20 
21 //
22 // This program is free software: you can redistribute it and/or modify
23 // it under the terms of the GNU Affero General Public License as published by
24 // the Free Software Foundation, either version 3 of the License, or
25 // (at your option) any later version.
26 //
27 // This program is distributed in the hope that it will be useful,
28 // but WITHOUT ANY WARRANTY; without even the implied warranty of
29 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
30 // GNU Affero General Public License for more details.
31 //
32 // You should have received a copy of the GNU Affero General Public License
33 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
34 
35 pragma solidity ^0.4.18;
36 
37 // This program is free software: you can redistribute it and/or modify
38 // it under the terms of the GNU General Public License as published by
39 // the Free Software Foundation, either version 3 of the License, or
40 // (at your option) any later version.
41 
42 // This program is distributed in the hope that it will be useful,
43 // but WITHOUT ANY WARRANTY; without even the implied warranty of
44 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
45 // GNU General Public License for more details.
46 
47 // You should have received a copy of the GNU General Public License
48 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
49 
50 pragma solidity ^0.4.13;
51 
52 contract DSAuthority {
53     function canCall(
54         address src, address dst, bytes4 sig
55     ) public view returns (bool);
56 }
57 
58 contract DSAuthEvents {
59     event LogSetAuthority (address indexed authority);
60     event LogSetOwner     (address indexed owner);
61 }
62 
63 contract DSAuth is DSAuthEvents {
64     DSAuthority  public  authority;
65     address      public  owner;
66 
67     function DSAuth() public {
68         owner = msg.sender;
69         LogSetOwner(msg.sender);
70     }
71 
72     function setOwner(address owner_)
73         public
74         auth
75     {
76         owner = owner_;
77         LogSetOwner(owner);
78     }
79 
80     function setAuthority(DSAuthority authority_)
81         public
82         auth
83     {
84         authority = authority_;
85         LogSetAuthority(authority);
86     }
87 
88     modifier auth {
89         require(isAuthorized(msg.sender, msg.sig));
90         _;
91     }
92 
93     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
94         if (src == address(this)) {
95             return true;
96         } else if (src == owner) {
97             return true;
98         } else if (authority == DSAuthority(0)) {
99             return false;
100         } else {
101             return authority.canCall(src, this, sig);
102         }
103     }
104 }
105 
106 /// simple_market.sol
107 
108 //
109 // This program is free software: you can redistribute it and/or modify
110 // it under the terms of the GNU Affero General Public License as published by
111 // the Free Software Foundation, either version 3 of the License, or
112 // (at your option) any later version.
113 //
114 // This program is distributed in the hope that it will be useful,
115 // but WITHOUT ANY WARRANTY; without even the implied warranty of
116 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
117 // GNU Affero General Public License for more details.
118 //
119 // You should have received a copy of the GNU Affero General Public License
120 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
121 
122 pragma solidity ^0.4.18;
123 
124 /// math.sol -- mixin for inline numerical wizardry
125 
126 // This program is free software: you can redistribute it and/or modify
127 // it under the terms of the GNU General Public License as published by
128 // the Free Software Foundation, either version 3 of the License, or
129 // (at your option) any later version.
130 
131 // This program is distributed in the hope that it will be useful,
132 // but WITHOUT ANY WARRANTY; without even the implied warranty of
133 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
134 // GNU General Public License for more details.
135 
136 // You should have received a copy of the GNU General Public License
137 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
138 
139 pragma solidity ^0.4.13;
140 
141 contract DSMath {
142     function add(uint x, uint y) internal pure returns (uint z) {
143         require((z = x + y) >= x);
144     }
145     function sub(uint x, uint y) internal pure returns (uint z) {
146         require((z = x - y) <= x);
147     }
148     function mul(uint x, uint y) internal pure returns (uint z) {
149         require(y == 0 || (z = x * y) / y == x);
150     }
151 
152     function min(uint x, uint y) internal pure returns (uint z) {
153         return x <= y ? x : y;
154     }
155     function max(uint x, uint y) internal pure returns (uint z) {
156         return x >= y ? x : y;
157     }
158     function imin(int x, int y) internal pure returns (int z) {
159         return x <= y ? x : y;
160     }
161     function imax(int x, int y) internal pure returns (int z) {
162         return x >= y ? x : y;
163     }
164 
165     uint constant WAD = 10 ** 18;
166     uint constant RAY = 10 ** 27;
167 
168     function wmul(uint x, uint y) internal pure returns (uint z) {
169         z = add(mul(x, y), WAD / 2) / WAD;
170     }
171     function rmul(uint x, uint y) internal pure returns (uint z) {
172         z = add(mul(x, y), RAY / 2) / RAY;
173     }
174     function wdiv(uint x, uint y) internal pure returns (uint z) {
175         z = add(mul(x, WAD), y / 2) / y;
176     }
177     function rdiv(uint x, uint y) internal pure returns (uint z) {
178         z = add(mul(x, RAY), y / 2) / y;
179     }
180 
181     // This famous algorithm is called "exponentiation by squaring"
182     // and calculates x^n with x as fixed-point and n as regular unsigned.
183     //
184     // It's O(log n), instead of O(n) for naive repeated multiplication.
185     //
186     // These facts are why it works:
187     //
188     //  If n is even, then x^n = (x^2)^(n/2).
189     //  If n is odd,  then x^n = x * x^(n-1),
190     //   and applying the equation for even x gives
191     //    x^n = x * (x^2)^((n-1) / 2).
192     //
193     //  Also, EVM division is flooring and
194     //    floor[(n-1) / 2] = floor[n / 2].
195     //
196     function rpow(uint x, uint n) internal pure returns (uint z) {
197         z = n % 2 != 0 ? x : RAY;
198 
199         for (n /= 2; n != 0; n /= 2) {
200             x = rmul(x, x);
201 
202             if (n % 2 != 0) {
203                 z = rmul(z, x);
204             }
205         }
206     }
207 }
208 
209 /// erc20.sol -- API for the ERC20 token standard
210 
211 // See <https://github.com/ethereum/EIPs/issues/20>.
212 
213 // This file likely does not meet the threshold of originality
214 // required for copyright to apply.  As a result, this is free and
215 // unencumbered software belonging to the public domain.
216 
217 pragma solidity ^0.4.8;
218 
219 contract ERC20Events {
220     event Approval(address indexed src, address indexed guy, uint wad);
221     event Transfer(address indexed src, address indexed dst, uint wad);
222 }
223 
224 contract ERC20 is ERC20Events {
225     function totalSupply() public view returns (uint);
226     function balanceOf(address guy) public view returns (uint);
227     function allowance(address src, address guy) public view returns (uint);
228 
229     function approve(address guy, uint wad) public returns (bool);
230     function transfer(address dst, uint wad) public returns (bool);
231     function transferFrom(
232         address src, address dst, uint wad
233     ) public returns (bool);
234 }
235 
236 contract EventfulMarket {
237     event LogItemUpdate(uint id);
238     event LogTrade(uint pay_amt, address indexed pay_gem,
239                    uint buy_amt, address indexed buy_gem);
240 
241     event LogMake(
242         bytes32  indexed  id,
243         bytes32  indexed  pair,
244         address  indexed  maker,
245         ERC20             pay_gem,
246         ERC20             buy_gem,
247         uint128           pay_amt,
248         uint128           buy_amt,
249         uint64            timestamp
250     );
251 
252     event LogBump(
253         bytes32  indexed  id,
254         bytes32  indexed  pair,
255         address  indexed  maker,
256         ERC20             pay_gem,
257         ERC20             buy_gem,
258         uint128           pay_amt,
259         uint128           buy_amt,
260         uint64            timestamp
261     );
262 
263     event LogTake(
264         bytes32           id,
265         bytes32  indexed  pair,
266         address  indexed  maker,
267         ERC20             pay_gem,
268         ERC20             buy_gem,
269         address  indexed  taker,
270         uint128           take_amt,
271         uint128           give_amt,
272         uint64            timestamp
273     );
274 
275     event LogKill(
276         bytes32  indexed  id,
277         bytes32  indexed  pair,
278         address  indexed  maker,
279         ERC20             pay_gem,
280         ERC20             buy_gem,
281         uint128           pay_amt,
282         uint128           buy_amt,
283         uint64            timestamp
284     );
285 }
286 
287 contract SimpleMarket is EventfulMarket, DSMath {
288 
289     uint public last_offer_id;
290 
291     mapping (uint => OfferInfo) public offers;
292 
293     bool locked;
294 
295     struct OfferInfo {
296         uint     pay_amt;
297         ERC20    pay_gem;
298         uint     buy_amt;
299         ERC20    buy_gem;
300         address  owner;
301         uint64   timestamp;
302     }
303 
304     modifier can_buy(uint id) {
305         require(isActive(id));
306         _;
307     }
308 
309     modifier can_cancel(uint id) {
310         require(isActive(id));
311         require(getOwner(id) == msg.sender);
312         _;
313     }
314 
315     modifier can_offer {
316         _;
317     }
318 
319     modifier synchronized {
320         require(!locked);
321         locked = true;
322         _;
323         locked = false;
324     }
325 
326     function isActive(uint id) public constant returns (bool active) {
327         return offers[id].timestamp > 0;
328     }
329 
330     function getOwner(uint id) public constant returns (address owner) {
331         return offers[id].owner;
332     }
333 
334     function getOffer(uint id) public constant returns (uint, ERC20, uint, ERC20) {
335       var offer = offers[id];
336       return (offer.pay_amt, offer.pay_gem,
337               offer.buy_amt, offer.buy_gem);
338     }
339 
340     // ---- Public entrypoints ---- //
341 
342     function bump(bytes32 id_)
343         public
344         can_buy(uint256(id_))
345     {
346         var id = uint256(id_);
347         LogBump(
348             id_,
349             keccak256(offers[id].pay_gem, offers[id].buy_gem),
350             offers[id].owner,
351             offers[id].pay_gem,
352             offers[id].buy_gem,
353             uint128(offers[id].pay_amt),
354             uint128(offers[id].buy_amt),
355             offers[id].timestamp
356         );
357     }
358 
359     // Accept given `quantity` of an offer. Transfers funds from caller to
360     // offer maker, and from market to caller.
361     function buy(uint id, uint quantity)
362         public
363         can_buy(id)
364         synchronized
365         returns (bool)
366     {
367         OfferInfo memory offer = offers[id];
368         uint spend = mul(quantity, offer.buy_amt) / offer.pay_amt;
369 
370         require(uint128(spend) == spend);
371         require(uint128(quantity) == quantity);
372 
373         // For backwards semantic compatibility.
374         if (quantity == 0 || spend == 0 ||
375             quantity > offer.pay_amt || spend > offer.buy_amt)
376         {
377             return false;
378         }
379 
380         offers[id].pay_amt = sub(offer.pay_amt, quantity);
381         offers[id].buy_amt = sub(offer.buy_amt, spend);
382         require( offer.buy_gem.transferFrom(msg.sender, offer.owner, spend) );
383         require( offer.pay_gem.transfer(msg.sender, quantity) );
384 
385         LogItemUpdate(id);
386         LogTake(
387             bytes32(id),
388             keccak256(offer.pay_gem, offer.buy_gem),
389             offer.owner,
390             offer.pay_gem,
391             offer.buy_gem,
392             msg.sender,
393             uint128(quantity),
394             uint128(spend),
395             uint64(now)
396         );
397         LogTrade(quantity, offer.pay_gem, spend, offer.buy_gem);
398 
399         if (offers[id].pay_amt == 0) {
400           delete offers[id];
401         }
402 
403         return true;
404     }
405 
406     // Cancel an offer. Refunds offer maker.
407     function cancel(uint id)
408         public
409         can_cancel(id)
410         synchronized
411         returns (bool success)
412     {
413         // read-only offer. Modify an offer by directly accessing offers[id]
414         OfferInfo memory offer = offers[id];
415         delete offers[id];
416 
417         require( offer.pay_gem.transfer(offer.owner, offer.pay_amt) );
418 
419         LogItemUpdate(id);
420         LogKill(
421             bytes32(id),
422             keccak256(offer.pay_gem, offer.buy_gem),
423             offer.owner,
424             offer.pay_gem,
425             offer.buy_gem,
426             uint128(offer.pay_amt),
427             uint128(offer.buy_amt),
428             uint64(now)
429         );
430 
431         success = true;
432     }
433 
434     function kill(bytes32 id)
435         public
436     {
437         require(cancel(uint256(id)));
438     }
439 
440     function make(
441         ERC20    pay_gem,
442         ERC20    buy_gem,
443         uint128  pay_amt,
444         uint128  buy_amt
445     )
446         public
447         returns (bytes32 id)
448     {
449         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
450     }
451 
452     // Make a new offer. Takes funds from the caller into market escrow.
453     function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem)
454         public
455         can_offer
456         synchronized
457         returns (uint id)
458     {
459         require(uint128(pay_amt) == pay_amt);
460         require(uint128(buy_amt) == buy_amt);
461         require(pay_amt > 0);
462         require(pay_gem != ERC20(0x0));
463         require(buy_amt > 0);
464         require(buy_gem != ERC20(0x0));
465         require(pay_gem != buy_gem);
466 
467         OfferInfo memory info;
468         info.pay_amt = pay_amt;
469         info.pay_gem = pay_gem;
470         info.buy_amt = buy_amt;
471         info.buy_gem = buy_gem;
472         info.owner = msg.sender;
473         info.timestamp = uint64(now);
474         id = _next_id();
475         offers[id] = info;
476 
477         require( pay_gem.transferFrom(msg.sender, this, pay_amt) );
478 
479         LogItemUpdate(id);
480         LogMake(
481             bytes32(id),
482             keccak256(pay_gem, buy_gem),
483             msg.sender,
484             pay_gem,
485             buy_gem,
486             uint128(pay_amt),
487             uint128(buy_amt),
488             uint64(now)
489         );
490     }
491 
492     function take(bytes32 id, uint128 maxTakeAmount)
493         public
494     {
495         require(buy(uint256(id), maxTakeAmount));
496     }
497 
498     function _next_id()
499         internal
500         returns (uint)
501     {
502         last_offer_id++; return last_offer_id;
503     }
504 }
505 
506 // Simple Market with a market lifetime. When the close_time has been reached,
507 // offers can only be cancelled (offer and buy will throw).
508 
509 contract ExpiringMarket is DSAuth, SimpleMarket {
510     uint64 public close_time;
511     bool public stopped;
512 
513     // after close_time has been reached, no new offers are allowed
514     modifier can_offer {
515         require(!isClosed());
516         _;
517     }
518 
519     // after close, no new buys are allowed
520     modifier can_buy(uint id) {
521         require(isActive(id));
522         require(!isClosed());
523         _;
524     }
525 
526     // after close, anyone can cancel an offer
527     modifier can_cancel(uint id) {
528         require(isActive(id));
529         require((msg.sender == getOwner(id)) || isClosed());
530         _;
531     }
532 
533     function ExpiringMarket(uint64 _close_time)
534         public
535     {
536         close_time = _close_time;
537     }
538 
539     function isClosed() public constant returns (bool closed) {
540         return stopped || getTime() > close_time;
541     }
542 
543     function getTime() public constant returns (uint64) {
544         return uint64(now);
545     }
546 
547     function stop() public auth {
548         stopped = true;
549     }
550 }
551 
552 /// note.sol -- the `note' modifier, for logging calls as events
553 
554 // This program is free software: you can redistribute it and/or modify
555 // it under the terms of the GNU General Public License as published by
556 // the Free Software Foundation, either version 3 of the License, or
557 // (at your option) any later version.
558 
559 // This program is distributed in the hope that it will be useful,
560 // but WITHOUT ANY WARRANTY; without even the implied warranty of
561 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
562 // GNU General Public License for more details.
563 
564 // You should have received a copy of the GNU General Public License
565 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
566 
567 pragma solidity ^0.4.13;
568 
569 contract DSNote {
570     event LogNote(
571         bytes4   indexed  sig,
572         address  indexed  guy,
573         bytes32  indexed  foo,
574         bytes32  indexed  bar,
575         uint              wad,
576         bytes             fax
577     ) anonymous;
578 
579     modifier note {
580         bytes32 foo;
581         bytes32 bar;
582 
583         assembly {
584             foo := calldataload(4)
585             bar := calldataload(36)
586         }
587 
588         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
589 
590         _;
591     }
592 }
593 
594 contract MatchingEvents {
595     event LogBuyEnabled(bool isEnabled);
596     event LogMinSell(address pay_gem, uint min_amount);
597     event LogMatchingEnabled(bool isEnabled);
598     event LogUnsortedOffer(uint id);
599     event LogSortedOffer(uint id);
600     event LogInsert(address keeper, uint id);
601     event LogDelete(address keeper, uint id);
602 }
603 
604 contract MatchingMarket is MatchingEvents, ExpiringMarket, DSNote {
605     bool public buyEnabled = true;      //buy enabled
606     bool public matchingEnabled = true; //true: enable matching,
607                                          //false: revert to expiring market
608     struct sortInfo {
609         uint next;  //points to id of next higher offer
610         uint prev;  //points to id of previous lower offer
611         uint delb;  //the blocknumber where this entry was marked for delete
612     }
613     mapping(uint => sortInfo) public _rank;                     //doubly linked lists of sorted offer ids
614     mapping(address => mapping(address => uint)) public _best;  //id of the highest offer for a token pair
615     mapping(address => mapping(address => uint)) public _span;  //number of offers stored for token pair in sorted orderbook
616     mapping(address => uint) public _dust;                      //minimum sell amount for a token to avoid dust offers
617     mapping(uint => uint) public _near;         //next unsorted offer id
618     uint _head;                                 //first unsorted offer id
619 
620     function MatchingMarket(uint64 close_time) ExpiringMarket(close_time) public {
621     }
622 
623     // ---- Public entrypoints ---- //
624 
625     function make(
626         ERC20    pay_gem,
627         ERC20    buy_gem,
628         uint128  pay_amt,
629         uint128  buy_amt
630     )
631         public
632         returns (bytes32)
633     {
634         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
635     }
636 
637     function take(bytes32 id, uint128 maxTakeAmount) public {
638         require(buy(uint256(id), maxTakeAmount));
639     }
640 
641     function kill(bytes32 id) public {
642         require(cancel(uint256(id)));
643     }
644 
645     // Make a new offer. Takes funds from the caller into market escrow.
646     //
647     // If matching is enabled:
648     //     * creates new offer without putting it in
649     //       the sorted list.
650     //     * available to authorized contracts only!
651     //     * keepers should call insert(id,pos)
652     //       to put offer in the sorted list.
653     //
654     // If matching is disabled:
655     //     * calls expiring market's offer().
656     //     * available to everyone without authorization.
657     //     * no sorting is done.
658     //
659     function offer(
660         uint pay_amt,    //maker (ask) sell how much
661         ERC20 pay_gem,   //maker (ask) sell which token
662         uint buy_amt,    //taker (ask) buy how much
663         ERC20 buy_gem    //taker (ask) buy which token
664     )
665         public
666         returns (uint)
667     {
668         require(!locked, "Reentrancy attempt");
669         var fn = matchingEnabled ? _offeru : super.offer;
670         return fn(pay_amt, pay_gem, buy_amt, buy_gem);
671     }
672 
673     // Make a new offer. Takes funds from the caller into market escrow.
674     function offer(
675         uint pay_amt,    //maker (ask) sell how much
676         ERC20 pay_gem,   //maker (ask) sell which token
677         uint buy_amt,    //maker (ask) buy how much
678         ERC20 buy_gem,   //maker (ask) buy which token
679         uint pos         //position to insert offer, 0 should be used if unknown
680     )
681         public
682         can_offer
683         returns (uint)
684     {
685         return offer(pay_amt, pay_gem, buy_amt, buy_gem, pos, false);
686     }
687 
688     function offer(
689         uint pay_amt,    //maker (ask) sell how much
690         ERC20 pay_gem,   //maker (ask) sell which token
691         uint buy_amt,    //maker (ask) buy how much
692         ERC20 buy_gem,   //maker (ask) buy which token
693         uint pos,        //position to insert offer, 0 should be used if unknown
694         bool rounding    //match "close enough" orders?
695     )
696         public
697         can_offer
698         returns (uint)
699     {
700         require(!locked, "Reentrancy attempt");
701         require(_dust[pay_gem] <= pay_amt);
702 
703         if (matchingEnabled) {
704           return _matcho(pay_amt, pay_gem, buy_amt, buy_gem, pos, rounding);
705         }
706         return super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
707     }
708 
709     //Transfers funds from caller to offer maker, and from market to caller.
710     function buy(uint id, uint amount)
711         public
712         can_buy(id)
713         returns (bool)
714     {
715         require(!locked, "Reentrancy attempt");
716         var fn = matchingEnabled ? _buys : super.buy;
717         return fn(id, amount);
718     }
719 
720     // Cancel an offer. Refunds offer maker.
721     function cancel(uint id)
722         public
723         can_cancel(id)
724         returns (bool success)
725     {
726         require(!locked, "Reentrancy attempt");
727         if (matchingEnabled) {
728             if (isOfferSorted(id)) {
729                 require(_unsort(id));
730             } else {
731                 require(_hide(id));
732             }
733         }
734         return super.cancel(id);    //delete the offer.
735     }
736 
737     //insert offer into the sorted list
738     //keepers need to use this function
739     function insert(
740         uint id,   //maker (ask) id
741         uint pos   //position to insert into
742     )
743         public
744         returns (bool)
745     {
746         require(!locked, "Reentrancy attempt");
747         require(!isOfferSorted(id));    //make sure offers[id] is not yet sorted
748         require(isActive(id));          //make sure offers[id] is active
749 
750         _hide(id);                      //remove offer from unsorted offers list
751         _sort(id, pos);                 //put offer into the sorted offers list
752         LogInsert(msg.sender, id);
753         return true;
754     }
755 
756     //deletes _rank [id]
757     //  Function should be called by keepers.
758     function del_rank(uint id)
759         public
760         returns (bool)
761     {
762         require(!locked, "Reentrancy attempt");
763         require(!isActive(id) && _rank[id].delb != 0 && _rank[id].delb < block.number - 10);
764         delete _rank[id];
765         LogDelete(msg.sender, id);
766         return true;
767     }
768 
769     //set the minimum sell amount for a token
770     //    Function is used to avoid "dust offers" that have
771     //    very small amount of tokens to sell, and it would
772     //    cost more gas to accept the offer, than the value
773     //    of tokens received.
774     function setMinSell(
775         ERC20 pay_gem,     //token to assign minimum sell amount to
776         uint dust          //maker (ask) minimum sell amount
777     )
778         public
779         auth
780         note
781         returns (bool)
782     {
783         _dust[pay_gem] = dust;
784         LogMinSell(pay_gem, dust);
785         return true;
786     }
787 
788     //returns the minimum sell amount for an offer
789     function getMinSell(
790         ERC20 pay_gem      //token for which minimum sell amount is queried
791     )
792         public
793         constant
794         returns (uint)
795     {
796         return _dust[pay_gem];
797     }
798 
799     //set buy functionality enabled/disabled
800     function setBuyEnabled(bool buyEnabled_) public auth returns (bool) {
801         buyEnabled = buyEnabled_;
802         LogBuyEnabled(buyEnabled);
803         return true;
804     }
805 
806     //set matching enabled/disabled
807     //    If matchingEnabled true(default), then inserted offers are matched.
808     //    Except the ones inserted by contracts, because those end up
809     //    in the unsorted list of offers, that must be later sorted by
810     //    keepers using insert().
811     //    If matchingEnabled is false then MatchingMarket is reverted to ExpiringMarket,
812     //    and matching is not done, and sorted lists are disabled.
813     function setMatchingEnabled(bool matchingEnabled_) public auth returns (bool) {
814         matchingEnabled = matchingEnabled_;
815         LogMatchingEnabled(matchingEnabled);
816         return true;
817     }
818 
819     //return the best offer for a token pair
820     //      the best offer is the lowest one if it's an ask,
821     //      and highest one if it's a bid offer
822     function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
823         return _best[sell_gem][buy_gem];
824     }
825 
826     //return the next worse offer in the sorted list
827     //      the worse offer is the higher one if its an ask,
828     //      a lower one if its a bid offer,
829     //      and in both cases the newer one if they're equal.
830     function getWorseOffer(uint id) public constant returns(uint) {
831         return _rank[id].prev;
832     }
833 
834     //return the next better offer in the sorted list
835     //      the better offer is in the lower priced one if its an ask,
836     //      the next higher priced one if its a bid offer
837     //      and in both cases the older one if they're equal.
838     function getBetterOffer(uint id) public constant returns(uint) {
839 
840         return _rank[id].next;
841     }
842 
843     //return the amount of better offers for a token pair
844     function getOfferCount(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
845         return _span[sell_gem][buy_gem];
846     }
847 
848     //get the first unsorted offer that was inserted by a contract
849     //      Contracts can't calculate the insertion position of their offer because it is not an O(1) operation.
850     //      Their offers get put in the unsorted list of offers.
851     //      Keepers can calculate the insertion position offchain and pass it to the insert() function to insert
852     //      the unsorted offer into the sorted list. Unsorted offers will not be matched, but can be bought with buy().
853     function getFirstUnsortedOffer() public constant returns(uint) {
854         return _head;
855     }
856 
857     //get the next unsorted offer
858     //      Can be used to cycle through all the unsorted offers.
859     function getNextUnsortedOffer(uint id) public constant returns(uint) {
860         return _near[id];
861     }
862 
863     function isOfferSorted(uint id) public constant returns(bool) {
864         return _rank[id].next != 0
865                || _rank[id].prev != 0
866                || _best[offers[id].pay_gem][offers[id].buy_gem] == id;
867     }
868 
869     function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount)
870         public
871         returns (uint fill_amt)
872     {
873         require(!locked, "Reentrancy attempt");
874         uint offerId;
875         while (pay_amt > 0) {                           //while there is amount to sell
876             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
877             require(offerId != 0);                      //Fails if there are not more offers
878 
879             // There is a chance that pay_amt is smaller than 1 wei of the other token
880             if (pay_amt * 1 ether < wdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) {
881                 break;                                  //We consider that all amount is sold
882             }
883             if (pay_amt >= offers[offerId].buy_amt) {                       //If amount to sell is higher or equal than current offer amount to buy
884                 fill_amt = add(fill_amt, offers[offerId].pay_amt);          //Add amount bought to acumulator
885                 pay_amt = sub(pay_amt, offers[offerId].buy_amt);            //Decrease amount to sell
886                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
887             } else { // if lower
888                 var baux = rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9;
889                 fill_amt = add(fill_amt, baux);         //Add amount bought to acumulator
890                 take(bytes32(offerId), uint128(baux));  //We take the portion of the offer that we need
891                 pay_amt = 0;                            //All amount is sold
892             }
893         }
894         require(fill_amt >= min_fill_amount);
895     }
896 
897     function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount)
898         public
899         returns (uint fill_amt)
900     {
901         require(!locked, "Reentrancy attempt");
902         uint offerId;
903         while (buy_amt > 0) {                           //Meanwhile there is amount to buy
904             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
905             require(offerId != 0);
906 
907             // There is a chance that buy_amt is smaller than 1 wei of the other token
908             if (buy_amt * 1 ether < wdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) {
909                 break;                                  //We consider that all amount is sold
910             }
911             if (buy_amt >= offers[offerId].pay_amt) {                       //If amount to buy is higher or equal than current offer amount to sell
912                 fill_amt = add(fill_amt, offers[offerId].buy_amt);          //Add amount sold to acumulator
913                 buy_amt = sub(buy_amt, offers[offerId].pay_amt);            //Decrease amount to buy
914                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
915             } else {                                                        //if lower
916                 fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add amount sold to acumulator
917                 take(bytes32(offerId), uint128(buy_amt));                   //We take the portion of the offer that we need
918                 buy_amt = 0;                                                //All amount is bought
919             }
920         }
921         require(fill_amt <= max_fill_amount);
922     }
923 
924     function getBuyAmount(ERC20 buy_gem, ERC20 pay_gem, uint pay_amt) public constant returns (uint fill_amt) {
925         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
926         while (pay_amt > offers[offerId].buy_amt) {
927             fill_amt = add(fill_amt, offers[offerId].pay_amt);  //Add amount to buy accumulator
928             pay_amt = sub(pay_amt, offers[offerId].buy_amt);    //Decrease amount to pay
929             if (pay_amt > 0) {                                  //If we still need more offers
930                 offerId = getWorseOffer(offerId);               //We look for the next best offer
931                 require(offerId != 0);                          //Fails if there are not enough offers to complete
932             }
933         }
934         fill_amt = add(fill_amt, rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9); //Add proportional amount of last offer to buy accumulator
935     }
936 
937     function getPayAmount(ERC20 pay_gem, ERC20 buy_gem, uint buy_amt) public constant returns (uint fill_amt) {
938         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
939         while (buy_amt > offers[offerId].pay_amt) {
940             fill_amt = add(fill_amt, offers[offerId].buy_amt);  //Add amount to pay accumulator
941             buy_amt = sub(buy_amt, offers[offerId].pay_amt);    //Decrease amount to buy
942             if (buy_amt > 0) {                                  //If we still need more offers
943                 offerId = getWorseOffer(offerId);               //We look for the next best offer
944                 require(offerId != 0);                          //Fails if there are not enough offers to complete
945             }
946         }
947         fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add proportional amount of last offer to pay accumulator
948     }
949 
950     // ---- Internal Functions ---- //
951 
952     function _buys(uint id, uint amount)
953         internal
954         returns (bool)
955     {
956         require(buyEnabled);
957 
958         if (amount == offers[id].pay_amt && isOfferSorted(id)) {
959             //offers[id] must be removed from sorted list because all of it is bought
960             _unsort(id);
961         }
962         require(super.buy(id, amount));
963         return true;
964     }
965 
966     //find the id of the next higher offer after offers[id]
967     function _find(uint id)
968         internal
969         view
970         returns (uint)
971     {
972         require( id > 0 );
973 
974         address buy_gem = address(offers[id].buy_gem);
975         address pay_gem = address(offers[id].pay_gem);
976         uint top = _best[pay_gem][buy_gem];
977         uint old_top = 0;
978 
979         // Find the larger-than-id order whose successor is less-than-id.
980         while (top != 0 && _isPricedLtOrEq(id, top)) {
981             old_top = top;
982             top = _rank[top].prev;
983         }
984         return old_top;
985     }
986 
987     //find the id of the next higher offer after offers[id]
988     function _findpos(uint id, uint pos)
989         internal
990         view
991         returns (uint)
992     {
993         require(id > 0);
994 
995         // Look for an active order.
996         while (pos != 0 && !isActive(pos)) {
997             pos = _rank[pos].prev;
998         }
999 
1000         if (pos == 0) {
1001             //if we got to the end of list without a single active offer
1002             return _find(id);
1003 
1004         } else {
1005             // if we did find a nearby active offer
1006             // Walk the order book down from there...
1007             if(_isPricedLtOrEq(id, pos)) {
1008                 uint old_pos;
1009 
1010                 // Guaranteed to run at least once because of
1011                 // the prior if statements.
1012                 while (pos != 0 && _isPricedLtOrEq(id, pos)) {
1013                     old_pos = pos;
1014                     pos = _rank[pos].prev;
1015                 }
1016                 return old_pos;
1017 
1018             // ...or walk it up.
1019             } else {
1020                 while (pos != 0 && !_isPricedLtOrEq(id, pos)) {
1021                     pos = _rank[pos].next;
1022                 }
1023                 return pos;
1024             }
1025         }
1026     }
1027 
1028     //return true if offers[low] priced less than or equal to offers[high]
1029     function _isPricedLtOrEq(
1030         uint low,   //lower priced offer's id
1031         uint high   //higher priced offer's id
1032     )
1033         internal
1034         view
1035         returns (bool)
1036     {
1037         return mul(offers[low].buy_amt, offers[high].pay_amt)
1038           >= mul(offers[high].buy_amt, offers[low].pay_amt);
1039     }
1040 
1041     //these variables are global only because of solidity local variable limit
1042 
1043     //match offers with taker offer, and execute token transactions
1044     function _matcho(
1045         uint t_pay_amt,    //taker sell how much
1046         ERC20 t_pay_gem,   //taker sell which token
1047         uint t_buy_amt,    //taker buy how much
1048         ERC20 t_buy_gem,   //taker buy which token
1049         uint pos,          //position id
1050         bool rounding      //match "close enough" orders?
1051     )
1052         internal
1053         returns (uint id)
1054     {
1055         uint best_maker_id;    //highest maker id
1056         uint t_buy_amt_old;    //taker buy how much saved
1057         uint m_buy_amt;        //maker offer wants to buy this much token
1058         uint m_pay_amt;        //maker offer wants to sell this much token
1059 
1060         // there is at least one offer stored for token pair
1061         while (_best[t_buy_gem][t_pay_gem] > 0) {
1062             best_maker_id = _best[t_buy_gem][t_pay_gem];
1063             m_buy_amt = offers[best_maker_id].buy_amt;
1064             m_pay_amt = offers[best_maker_id].pay_amt;
1065 
1066             // Ugly hack to work around rounding errors. Based on the idea that
1067             // the furthest the amounts can stray from their "true" values is 1.
1068             // Ergo the worst case has t_pay_amt and m_pay_amt at +1 away from
1069             // their "correct" values and m_buy_amt and t_buy_amt at -1.
1070             // Since (c - 1) * (d - 1) > (a + 1) * (b + 1) is equivalent to
1071             // c * d > a * b + a + b + c + d, we write...
1072             if (mul(m_buy_amt, t_buy_amt) > mul(t_pay_amt, m_pay_amt) +
1073                 (rounding ? m_buy_amt + t_buy_amt + t_pay_amt + m_pay_amt : 0))
1074             {
1075                 break;
1076             }
1077             // ^ The `rounding` parameter is a compromise borne of a couple days
1078             // of discussion.
1079 
1080             buy(best_maker_id, min(m_pay_amt, t_buy_amt));
1081             t_buy_amt_old = t_buy_amt;
1082             t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
1083             t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
1084 
1085             if (t_pay_amt == 0 || t_buy_amt == 0) {
1086                 break;
1087             }
1088         }
1089 
1090         if (t_buy_amt > 0 && t_pay_amt > 0) {
1091             //new offer should be created
1092             id = super.offer(t_pay_amt, t_pay_gem, t_buy_amt, t_buy_gem);
1093             //insert offer into the sorted list
1094             _sort(id, pos);
1095         }
1096     }
1097 
1098     // Make a new offer without putting it in the sorted list.
1099     // Takes funds from the caller into market escrow.
1100     // ****Available to authorized contracts only!**********
1101     // Keepers should call insert(id,pos) to put offer in the sorted list.
1102     function _offeru(
1103         uint pay_amt,      //maker (ask) sell how much
1104         ERC20 pay_gem,     //maker (ask) sell which token
1105         uint buy_amt,      //maker (ask) buy how much
1106         ERC20 buy_gem      //maker (ask) buy which token
1107     )
1108         internal
1109         returns (uint id)
1110     {
1111         require(_dust[pay_gem] <= pay_amt);
1112         id = super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
1113         _near[id] = _head;
1114         _head = id;
1115         LogUnsortedOffer(id);
1116     }
1117 
1118     //put offer into the sorted list
1119     function _sort(
1120         uint id,    //maker (ask) id
1121         uint pos    //position to insert into
1122     )
1123         internal
1124     {
1125         require(isActive(id));
1126 
1127         address buy_gem = address(offers[id].buy_gem);
1128         address pay_gem = address(offers[id].pay_gem);
1129         uint prev_id;                                      //maker (ask) id
1130 
1131         if (pos == 0 || !isOfferSorted(pos)) {
1132             pos = _find(id);
1133         } else {
1134             pos = _findpos(id, pos);
1135 
1136             //if user has entered a `pos` that belongs to another currency pair
1137             //we start from scratch
1138             if(pos != 0 && (offers[pos].pay_gem != offers[id].pay_gem
1139                       || offers[pos].buy_gem != offers[id].buy_gem))
1140             {
1141                 pos = 0;
1142                 pos=_find(id);
1143             }
1144         }
1145 
1146 
1147         //requirement below is satisfied by statements above
1148         //require(pos == 0 || isOfferSorted(pos));
1149 
1150 
1151         if (pos != 0) {                                    //offers[id] is not the highest offer
1152             //requirement below is satisfied by statements above
1153             //require(_isPricedLtOrEq(id, pos));
1154             prev_id = _rank[pos].prev;
1155             _rank[pos].prev = id;
1156             _rank[id].next = pos;
1157         } else {                                           //offers[id] is the highest offer
1158             prev_id = _best[pay_gem][buy_gem];
1159             _best[pay_gem][buy_gem] = id;
1160         }
1161 
1162         if (prev_id != 0) {                               //if lower offer does exist
1163             //requirement below is satisfied by statements above
1164             //require(!_isPricedLtOrEq(id, prev_id));
1165             _rank[prev_id].next = id;
1166             _rank[id].prev = prev_id;
1167         }
1168 
1169         _span[pay_gem][buy_gem]++;
1170         LogSortedOffer(id);
1171     }
1172 
1173     // Remove offer from the sorted list (does not cancel offer)
1174     function _unsort(
1175         uint id    //id of maker (ask) offer to remove from sorted list
1176     )
1177         internal
1178         returns (bool)
1179     {
1180         address buy_gem = address(offers[id].buy_gem);
1181         address pay_gem = address(offers[id].pay_gem);
1182         require(_span[pay_gem][buy_gem] > 0);
1183 
1184         require(_rank[id].delb == 0 &&                    //assert id is in the sorted list
1185                  isOfferSorted(id));
1186 
1187         if (id != _best[pay_gem][buy_gem]) {              // offers[id] is not the highest offer
1188             require(_rank[_rank[id].next].prev == id);
1189             _rank[_rank[id].next].prev = _rank[id].prev;
1190         } else {                                          //offers[id] is the highest offer
1191             _best[pay_gem][buy_gem] = _rank[id].prev;
1192         }
1193 
1194         if (_rank[id].prev != 0) {                        //offers[id] is not the lowest offer
1195             require(_rank[_rank[id].prev].next == id);
1196             _rank[_rank[id].prev].next = _rank[id].next;
1197         }
1198 
1199         _span[pay_gem][buy_gem]--;
1200         _rank[id].delb = block.number;                    //mark _rank[id] for deletion
1201         return true;
1202     }
1203 
1204     //Hide offer from the unsorted order book (does not cancel offer)
1205     function _hide(
1206         uint id     //id of maker offer to remove from unsorted list
1207     )
1208         internal
1209         returns (bool)
1210     {
1211         uint uid = _head;               //id of an offer in unsorted offers list
1212         uint pre = uid;                 //id of previous offer in unsorted offers list
1213 
1214         require(!isOfferSorted(id));    //make sure offer id is not in sorted offers list
1215 
1216         if (_head == id) {              //check if offer is first offer in unsorted offers list
1217             _head = _near[id];          //set head to new first unsorted offer
1218             _near[id] = 0;              //delete order from unsorted order list
1219             return true;
1220         }
1221         while (uid > 0 && uid != id) {  //find offer in unsorted order list
1222             pre = uid;
1223             uid = _near[uid];
1224         }
1225         if (uid != id) {                //did not find offer id in unsorted offers list
1226             return false;
1227         }
1228         _near[pre] = _near[id];         //set previous unsorted offer to point to offer after offer id
1229         _near[id] = 0;                  //delete order from unsorted order list
1230         return true;
1231     }
1232 }