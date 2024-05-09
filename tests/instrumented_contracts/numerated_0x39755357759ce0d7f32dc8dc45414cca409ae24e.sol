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
619     uint public dustId;                         // id of the latest offer marked as dust
620 
621 
622     function MatchingMarket(uint64 close_time) ExpiringMarket(close_time) public {
623     }
624 
625     // After close, anyone can cancel an offer
626     modifier can_cancel(uint id) {
627         require(isActive(id), "Offer was deleted or taken, or never existed.");
628         require(
629             isClosed() || msg.sender == getOwner(id) || id == dustId,
630             "Offer can not be cancelled because user is not owner, and market is open, and offer sells required amount of tokens."
631         );
632         _;
633     }
634 
635     // ---- Public entrypoints ---- //
636 
637     function make(
638         ERC20    pay_gem,
639         ERC20    buy_gem,
640         uint128  pay_amt,
641         uint128  buy_amt
642     )
643         public
644         returns (bytes32)
645     {
646         return bytes32(offer(pay_amt, pay_gem, buy_amt, buy_gem));
647     }
648 
649     function take(bytes32 id, uint128 maxTakeAmount) public {
650         require(buy(uint256(id), maxTakeAmount));
651     }
652 
653     function kill(bytes32 id) public {
654         require(cancel(uint256(id)));
655     }
656 
657     // Make a new offer. Takes funds from the caller into market escrow.
658     //
659     // If matching is enabled:
660     //     * creates new offer without putting it in
661     //       the sorted list.
662     //     * available to authorized contracts only!
663     //     * keepers should call insert(id,pos)
664     //       to put offer in the sorted list.
665     //
666     // If matching is disabled:
667     //     * calls expiring market's offer().
668     //     * available to everyone without authorization.
669     //     * no sorting is done.
670     //
671     function offer(
672         uint pay_amt,    //maker (ask) sell how much
673         ERC20 pay_gem,   //maker (ask) sell which token
674         uint buy_amt,    //taker (ask) buy how much
675         ERC20 buy_gem    //taker (ask) buy which token
676     )
677         public
678         returns (uint)
679     {
680         require(!locked, "Reentrancy attempt");
681         var fn = matchingEnabled ? _offeru : super.offer;
682         return fn(pay_amt, pay_gem, buy_amt, buy_gem);
683     }
684 
685     // Make a new offer. Takes funds from the caller into market escrow.
686     function offer(
687         uint pay_amt,    //maker (ask) sell how much
688         ERC20 pay_gem,   //maker (ask) sell which token
689         uint buy_amt,    //maker (ask) buy how much
690         ERC20 buy_gem,   //maker (ask) buy which token
691         uint pos         //position to insert offer, 0 should be used if unknown
692     )
693         public
694         can_offer
695         returns (uint)
696     {
697         return offer(pay_amt, pay_gem, buy_amt, buy_gem, pos, true);
698     }
699 
700     function offer(
701         uint pay_amt,    //maker (ask) sell how much
702         ERC20 pay_gem,   //maker (ask) sell which token
703         uint buy_amt,    //maker (ask) buy how much
704         ERC20 buy_gem,   //maker (ask) buy which token
705         uint pos,        //position to insert offer, 0 should be used if unknown
706         bool rounding    //match "close enough" orders?
707     )
708         public
709         can_offer
710         returns (uint)
711     {
712         require(!locked, "Reentrancy attempt");
713         require(_dust[pay_gem] <= pay_amt);
714 
715         if (matchingEnabled) {
716           return _matcho(pay_amt, pay_gem, buy_amt, buy_gem, pos, rounding);
717         }
718         return super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
719     }
720 
721     //Transfers funds from caller to offer maker, and from market to caller.
722     function buy(uint id, uint amount)
723         public
724         can_buy(id)
725         returns (bool)
726     {
727         require(!locked, "Reentrancy attempt");
728         var fn = matchingEnabled ? _buys : super.buy;
729         return fn(id, amount);
730     }
731 
732     // Cancel an offer. Refunds offer maker.
733     function cancel(uint id)
734         public
735         can_cancel(id)
736         returns (bool success)
737     {
738         require(!locked, "Reentrancy attempt");
739         if (matchingEnabled) {
740             if (isOfferSorted(id)) {
741                 require(_unsort(id));
742             } else {
743                 require(_hide(id));
744             }
745         }
746         return super.cancel(id);    //delete the offer.
747     }
748 
749     //insert offer into the sorted list
750     //keepers need to use this function
751     function insert(
752         uint id,   //maker (ask) id
753         uint pos   //position to insert into
754     )
755         public
756         returns (bool)
757     {
758         require(!locked, "Reentrancy attempt");
759         require(!isOfferSorted(id));    //make sure offers[id] is not yet sorted
760         require(isActive(id));          //make sure offers[id] is active
761 
762         _hide(id);                      //remove offer from unsorted offers list
763         _sort(id, pos);                 //put offer into the sorted offers list
764         LogInsert(msg.sender, id);
765         return true;
766     }
767 
768     //deletes _rank [id]
769     //  Function should be called by keepers.
770     function del_rank(uint id)
771         public
772         returns (bool)
773     {
774         require(!locked, "Reentrancy attempt");
775         require(!isActive(id) && _rank[id].delb != 0 && _rank[id].delb < block.number - 10);
776         delete _rank[id];
777         LogDelete(msg.sender, id);
778         return true;
779     }
780 
781     //set the minimum sell amount for a token
782     //    Function is used to avoid "dust offers" that have
783     //    very small amount of tokens to sell, and it would
784     //    cost more gas to accept the offer, than the value
785     //    of tokens received.
786     function setMinSell(
787         ERC20 pay_gem,     //token to assign minimum sell amount to
788         uint dust          //maker (ask) minimum sell amount
789     )
790         public
791         auth
792         note
793         returns (bool)
794     {
795         _dust[pay_gem] = dust;
796         LogMinSell(pay_gem, dust);
797         return true;
798     }
799 
800     //returns the minimum sell amount for an offer
801     function getMinSell(
802         ERC20 pay_gem      //token for which minimum sell amount is queried
803     )
804         public
805         constant
806         returns (uint)
807     {
808         return _dust[pay_gem];
809     }
810 
811     //set buy functionality enabled/disabled
812     function setBuyEnabled(bool buyEnabled_) public auth returns (bool) {
813         buyEnabled = buyEnabled_;
814         LogBuyEnabled(buyEnabled);
815         return true;
816     }
817 
818     //set matching enabled/disabled
819     //    If matchingEnabled true(default), then inserted offers are matched.
820     //    Except the ones inserted by contracts, because those end up
821     //    in the unsorted list of offers, that must be later sorted by
822     //    keepers using insert().
823     //    If matchingEnabled is false then MatchingMarket is reverted to ExpiringMarket,
824     //    and matching is not done, and sorted lists are disabled.
825     function setMatchingEnabled(bool matchingEnabled_) public auth returns (bool) {
826         matchingEnabled = matchingEnabled_;
827         LogMatchingEnabled(matchingEnabled);
828         return true;
829     }
830 
831     //return the best offer for a token pair
832     //      the best offer is the lowest one if it's an ask,
833     //      and highest one if it's a bid offer
834     function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
835         return _best[sell_gem][buy_gem];
836     }
837 
838     //return the next worse offer in the sorted list
839     //      the worse offer is the higher one if its an ask,
840     //      a lower one if its a bid offer,
841     //      and in both cases the newer one if they're equal.
842     function getWorseOffer(uint id) public constant returns(uint) {
843         return _rank[id].prev;
844     }
845 
846     //return the next better offer in the sorted list
847     //      the better offer is in the lower priced one if its an ask,
848     //      the next higher priced one if its a bid offer
849     //      and in both cases the older one if they're equal.
850     function getBetterOffer(uint id) public constant returns(uint) {
851 
852         return _rank[id].next;
853     }
854 
855     //return the amount of better offers for a token pair
856     function getOfferCount(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint) {
857         return _span[sell_gem][buy_gem];
858     }
859 
860     //get the first unsorted offer that was inserted by a contract
861     //      Contracts can't calculate the insertion position of their offer because it is not an O(1) operation.
862     //      Their offers get put in the unsorted list of offers.
863     //      Keepers can calculate the insertion position offchain and pass it to the insert() function to insert
864     //      the unsorted offer into the sorted list. Unsorted offers will not be matched, but can be bought with buy().
865     function getFirstUnsortedOffer() public constant returns(uint) {
866         return _head;
867     }
868 
869     //get the next unsorted offer
870     //      Can be used to cycle through all the unsorted offers.
871     function getNextUnsortedOffer(uint id) public constant returns(uint) {
872         return _near[id];
873     }
874 
875     function isOfferSorted(uint id) public constant returns(bool) {
876         return _rank[id].next != 0
877                || _rank[id].prev != 0
878                || _best[offers[id].pay_gem][offers[id].buy_gem] == id;
879     }
880 
881     function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount)
882         public
883         returns (uint fill_amt)
884     {
885         require(!locked, "Reentrancy attempt");
886         uint offerId;
887         while (pay_amt > 0) {                           //while there is amount to sell
888             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
889             require(offerId != 0);                      //Fails if there are not more offers
890 
891             // There is a chance that pay_amt is smaller than 1 wei of the other token
892             if (pay_amt * 1 ether < wdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) {
893                 break;                                  //We consider that all amount is sold
894             }
895             if (pay_amt >= offers[offerId].buy_amt) {                       //If amount to sell is higher or equal than current offer amount to buy
896                 fill_amt = add(fill_amt, offers[offerId].pay_amt);          //Add amount bought to acumulator
897                 pay_amt = sub(pay_amt, offers[offerId].buy_amt);            //Decrease amount to sell
898                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
899             } else { // if lower
900                 var baux = rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9;
901                 fill_amt = add(fill_amt, baux);         //Add amount bought to acumulator
902                 take(bytes32(offerId), uint128(baux));  //We take the portion of the offer that we need
903                 pay_amt = 0;                            //All amount is sold
904             }
905         }
906         require(fill_amt >= min_fill_amount);
907     }
908 
909     function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount)
910         public
911         returns (uint fill_amt)
912     {
913         require(!locked, "Reentrancy attempt");
914         uint offerId;
915         while (buy_amt > 0) {                           //Meanwhile there is amount to buy
916             offerId = getBestOffer(buy_gem, pay_gem);   //Get the best offer for the token pair
917             require(offerId != 0);
918 
919             // There is a chance that buy_amt is smaller than 1 wei of the other token
920             if (buy_amt * 1 ether < wdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) {
921                 break;                                  //We consider that all amount is sold
922             }
923             if (buy_amt >= offers[offerId].pay_amt) {                       //If amount to buy is higher or equal than current offer amount to sell
924                 fill_amt = add(fill_amt, offers[offerId].buy_amt);          //Add amount sold to acumulator
925                 buy_amt = sub(buy_amt, offers[offerId].pay_amt);            //Decrease amount to buy
926                 take(bytes32(offerId), uint128(offers[offerId].pay_amt));   //We take the whole offer
927             } else {                                                        //if lower
928                 fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add amount sold to acumulator
929                 take(bytes32(offerId), uint128(buy_amt));                   //We take the portion of the offer that we need
930                 buy_amt = 0;                                                //All amount is bought
931             }
932         }
933         require(fill_amt <= max_fill_amount);
934     }
935 
936     function getBuyAmount(ERC20 buy_gem, ERC20 pay_gem, uint pay_amt) public constant returns (uint fill_amt) {
937         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
938         while (pay_amt > offers[offerId].buy_amt) {
939             fill_amt = add(fill_amt, offers[offerId].pay_amt);  //Add amount to buy accumulator
940             pay_amt = sub(pay_amt, offers[offerId].buy_amt);    //Decrease amount to pay
941             if (pay_amt > 0) {                                  //If we still need more offers
942                 offerId = getWorseOffer(offerId);               //We look for the next best offer
943                 require(offerId != 0);                          //Fails if there are not enough offers to complete
944             }
945         }
946         fill_amt = add(fill_amt, rmul(pay_amt * 10 ** 9, rdiv(offers[offerId].pay_amt, offers[offerId].buy_amt)) / 10 ** 9); //Add proportional amount of last offer to buy accumulator
947     }
948 
949     function getPayAmount(ERC20 pay_gem, ERC20 buy_gem, uint buy_amt) public constant returns (uint fill_amt) {
950         var offerId = getBestOffer(buy_gem, pay_gem);           //Get best offer for the token pair
951         while (buy_amt > offers[offerId].pay_amt) {
952             fill_amt = add(fill_amt, offers[offerId].buy_amt);  //Add amount to pay accumulator
953             buy_amt = sub(buy_amt, offers[offerId].pay_amt);    //Decrease amount to buy
954             if (buy_amt > 0) {                                  //If we still need more offers
955                 offerId = getWorseOffer(offerId);               //We look for the next best offer
956                 require(offerId != 0);                          //Fails if there are not enough offers to complete
957             }
958         }
959         fill_amt = add(fill_amt, rmul(buy_amt * 10 ** 9, rdiv(offers[offerId].buy_amt, offers[offerId].pay_amt)) / 10 ** 9); //Add proportional amount of last offer to pay accumulator
960     }
961 
962     // ---- Internal Functions ---- //
963 
964     function _buys(uint id, uint amount)
965         internal
966         returns (bool)
967     {
968         require(buyEnabled);
969         if (amount == offers[id].pay_amt) {
970             if (isOfferSorted(id)) {
971                 //offers[id] must be removed from sorted list because all of it is bought
972                 _unsort(id);
973             }else{
974                 _hide(id);
975             }
976         }
977         require(super.buy(id, amount));
978         // If offer has become dust during buy, we cancel it
979         if (isActive(id) && offers[id].pay_amt < _dust[offers[id].pay_gem]) {
980             dustId = id; //enable current msg.sender to call cancel(id)
981             cancel(id);
982         }
983         return true;
984     }
985 
986     //find the id of the next higher offer after offers[id]
987     function _find(uint id)
988         internal
989         view
990         returns (uint)
991     {
992         require( id > 0 );
993 
994         address buy_gem = address(offers[id].buy_gem);
995         address pay_gem = address(offers[id].pay_gem);
996         uint top = _best[pay_gem][buy_gem];
997         uint old_top = 0;
998 
999         // Find the larger-than-id order whose successor is less-than-id.
1000         while (top != 0 && _isPricedLtOrEq(id, top)) {
1001             old_top = top;
1002             top = _rank[top].prev;
1003         }
1004         return old_top;
1005     }
1006 
1007     //find the id of the next higher offer after offers[id]
1008     function _findpos(uint id, uint pos)
1009         internal
1010         view
1011         returns (uint)
1012     {
1013         require(id > 0);
1014 
1015         // Look for an active order.
1016         while (pos != 0 && !isActive(pos)) {
1017             pos = _rank[pos].prev;
1018         }
1019 
1020         if (pos == 0) {
1021             //if we got to the end of list without a single active offer
1022             return _find(id);
1023 
1024         } else {
1025             // if we did find a nearby active offer
1026             // Walk the order book down from there...
1027             if(_isPricedLtOrEq(id, pos)) {
1028                 uint old_pos;
1029 
1030                 // Guaranteed to run at least once because of
1031                 // the prior if statements.
1032                 while (pos != 0 && _isPricedLtOrEq(id, pos)) {
1033                     old_pos = pos;
1034                     pos = _rank[pos].prev;
1035                 }
1036                 return old_pos;
1037 
1038             // ...or walk it up.
1039             } else {
1040                 while (pos != 0 && !_isPricedLtOrEq(id, pos)) {
1041                     pos = _rank[pos].next;
1042                 }
1043                 return pos;
1044             }
1045         }
1046     }
1047 
1048     //return true if offers[low] priced less than or equal to offers[high]
1049     function _isPricedLtOrEq(
1050         uint low,   //lower priced offer's id
1051         uint high   //higher priced offer's id
1052     )
1053         internal
1054         view
1055         returns (bool)
1056     {
1057         return mul(offers[low].buy_amt, offers[high].pay_amt)
1058           >= mul(offers[high].buy_amt, offers[low].pay_amt);
1059     }
1060 
1061     //these variables are global only because of solidity local variable limit
1062 
1063     //match offers with taker offer, and execute token transactions
1064     function _matcho(
1065         uint t_pay_amt,    //taker sell how much
1066         ERC20 t_pay_gem,   //taker sell which token
1067         uint t_buy_amt,    //taker buy how much
1068         ERC20 t_buy_gem,   //taker buy which token
1069         uint pos,          //position id
1070         bool rounding      //match "close enough" orders?
1071     )
1072         internal
1073         returns (uint id)
1074     {
1075         uint best_maker_id;    //highest maker id
1076         uint t_buy_amt_old;    //taker buy how much saved
1077         uint m_buy_amt;        //maker offer wants to buy this much token
1078         uint m_pay_amt;        //maker offer wants to sell this much token
1079 
1080         // there is at least one offer stored for token pair
1081         while (_best[t_buy_gem][t_pay_gem] > 0) {
1082             best_maker_id = _best[t_buy_gem][t_pay_gem];
1083             m_buy_amt = offers[best_maker_id].buy_amt;
1084             m_pay_amt = offers[best_maker_id].pay_amt;
1085 
1086             // Ugly hack to work around rounding errors. Based on the idea that
1087             // the furthest the amounts can stray from their "true" values is 1.
1088             // Ergo the worst case has t_pay_amt and m_pay_amt at +1 away from
1089             // their "correct" values and m_buy_amt and t_buy_amt at -1.
1090             // Since (c - 1) * (d - 1) > (a + 1) * (b + 1) is equivalent to
1091             // c * d > a * b + a + b + c + d, we write...
1092             if (mul(m_buy_amt, t_buy_amt) > mul(t_pay_amt, m_pay_amt) +
1093                 (rounding ? m_buy_amt + t_buy_amt + t_pay_amt + m_pay_amt : 0))
1094             {
1095                 break;
1096             }
1097             // ^ The `rounding` parameter is a compromise borne of a couple days
1098             // of discussion.
1099             buy(best_maker_id, min(m_pay_amt, t_buy_amt));
1100             t_buy_amt_old = t_buy_amt;
1101             t_buy_amt = sub(t_buy_amt, min(m_pay_amt, t_buy_amt));
1102             t_pay_amt = mul(t_buy_amt, t_pay_amt) / t_buy_amt_old;
1103 
1104             if (t_pay_amt == 0 || t_buy_amt == 0) {
1105                 break;
1106             }
1107         }
1108 
1109         if (t_buy_amt > 0 && t_pay_amt > 0 && t_pay_amt >= _dust[t_pay_gem]) {
1110             //new offer should be created
1111             id = super.offer(t_pay_amt, t_pay_gem, t_buy_amt, t_buy_gem);
1112             //insert offer into the sorted list
1113             _sort(id, pos);
1114         }
1115     }
1116 
1117     // Make a new offer without putting it in the sorted list.
1118     // Takes funds from the caller into market escrow.
1119     // ****Available to authorized contracts only!**********
1120     // Keepers should call insert(id,pos) to put offer in the sorted list.
1121     function _offeru(
1122         uint pay_amt,      //maker (ask) sell how much
1123         ERC20 pay_gem,     //maker (ask) sell which token
1124         uint buy_amt,      //maker (ask) buy how much
1125         ERC20 buy_gem      //maker (ask) buy which token
1126     )
1127         internal
1128         returns (uint id)
1129     {
1130         require(_dust[pay_gem] <= pay_amt);
1131         id = super.offer(pay_amt, pay_gem, buy_amt, buy_gem);
1132         _near[id] = _head;
1133         _head = id;
1134         LogUnsortedOffer(id);
1135     }
1136 
1137     //put offer into the sorted list
1138     function _sort(
1139         uint id,    //maker (ask) id
1140         uint pos    //position to insert into
1141     )
1142         internal
1143     {
1144         require(isActive(id));
1145 
1146         address buy_gem = address(offers[id].buy_gem);
1147         address pay_gem = address(offers[id].pay_gem);
1148         uint prev_id;                                      //maker (ask) id
1149 
1150         pos = pos == 0 || offers[pos].pay_gem != pay_gem || offers[pos].buy_gem != buy_gem || !isOfferSorted(pos)
1151         ?
1152             _find(id)
1153         :
1154             _findpos(id, pos);
1155 
1156         if (pos != 0) {                                    //offers[id] is not the highest offer
1157             //requirement below is satisfied by statements above
1158             //require(_isPricedLtOrEq(id, pos));
1159             prev_id = _rank[pos].prev;
1160             _rank[pos].prev = id;
1161             _rank[id].next = pos;
1162         } else {                                           //offers[id] is the highest offer
1163             prev_id = _best[pay_gem][buy_gem];
1164             _best[pay_gem][buy_gem] = id;
1165         }
1166 
1167         if (prev_id != 0) {                               //if lower offer does exist
1168             //requirement below is satisfied by statements above
1169             //require(!_isPricedLtOrEq(id, prev_id));
1170             _rank[prev_id].next = id;
1171             _rank[id].prev = prev_id;
1172         }
1173 
1174         _span[pay_gem][buy_gem]++;
1175         LogSortedOffer(id);
1176     }
1177 
1178     // Remove offer from the sorted list (does not cancel offer)
1179     function _unsort(
1180         uint id    //id of maker (ask) offer to remove from sorted list
1181     )
1182         internal
1183         returns (bool)
1184     {
1185         address buy_gem = address(offers[id].buy_gem);
1186         address pay_gem = address(offers[id].pay_gem);
1187         require(_span[pay_gem][buy_gem] > 0);
1188 
1189         require(_rank[id].delb == 0 &&                    //assert id is in the sorted list
1190                  isOfferSorted(id));
1191 
1192         if (id != _best[pay_gem][buy_gem]) {              // offers[id] is not the highest offer
1193             require(_rank[_rank[id].next].prev == id);
1194             _rank[_rank[id].next].prev = _rank[id].prev;
1195         } else {                                          //offers[id] is the highest offer
1196             _best[pay_gem][buy_gem] = _rank[id].prev;
1197         }
1198 
1199         if (_rank[id].prev != 0) {                        //offers[id] is not the lowest offer
1200             require(_rank[_rank[id].prev].next == id);
1201             _rank[_rank[id].prev].next = _rank[id].next;
1202         }
1203 
1204         _span[pay_gem][buy_gem]--;
1205         _rank[id].delb = block.number;                    //mark _rank[id] for deletion
1206         return true;
1207     }
1208 
1209     //Hide offer from the unsorted order book (does not cancel offer)
1210     function _hide(
1211         uint id     //id of maker offer to remove from unsorted list
1212     )
1213         internal
1214         returns (bool)
1215     {
1216         uint uid = _head;               //id of an offer in unsorted offers list
1217         uint pre = uid;                 //id of previous offer in unsorted offers list
1218 
1219         require(!isOfferSorted(id));    //make sure offer id is not in sorted offers list
1220 
1221         if (_head == id) {              //check if offer is first offer in unsorted offers list
1222             _head = _near[id];          //set head to new first unsorted offer
1223             _near[id] = 0;              //delete order from unsorted order list
1224             return true;
1225         }
1226         while (uid > 0 && uid != id) {  //find offer in unsorted order list
1227             pre = uid;
1228             uid = _near[uid];
1229         }
1230         if (uid != id) {                //did not find offer id in unsorted offers list
1231             return false;
1232         }
1233         _near[pre] = _near[id];         //set previous unsorted offer to point to offer after offer id
1234         _near[id] = 0;                  //delete order from unsorted order list
1235         return true;
1236     }
1237 }