1 pragma solidity ^0.4.24;
2 
3 pragma experimental ABIEncoderV2;
4 
5 contract JanKenPonEvents {
6 	event onJoinGame(
7         address player,
8         uint256 buyer_keys,
9         uint256 round,
10         uint256 curPrice,
11         uint256 endTime
12     );
13     
14     event onWithdrawBenefit();
15     
16     event onSellOrder();
17     
18     event onCancelOrder();
19     
20     event onBuyOrder();
21     
22     event onStartGame(
23         uint256 curPrice,
24         uint256 round,
25         uint256 endTime
26     );
27     
28     event onPK(
29         uint256 playerA,
30         uint256 cardA,
31         uint256 playerB,
32         uint256 cardB
33     );
34 }
35 
36 library JanKenPonData {
37 
38 	 struct playerPacket{
39         uint256 pId;
40         address owner;
41         uint8[3] cards;
42         uint8 cardIndex;
43         uint8 stars;
44         bool isSelling;
45         uint256 price;
46         uint256 count;
47 		bool isWithDrawWiner;
48         bool isWithDrawShare;
49         bool isWithdrawBenefit;
50 		bool isWithDrawLastBuyer;
51     }
52 
53     struct rateTeam {
54         uint256 curPrice;
55         uint256 incPrice;
56         uint256 rateCom;
57         uint256 rateWin;
58         uint256 rateLast;
59         uint256 rateBen;
60         uint256 rateShare;
61         uint256 rateNext;
62     }
63 
64     struct Round {
65         address lastWiner;
66         uint256 lastBuyerId;
67         uint256 pId_inc;
68         uint256 rand_begin;
69         uint256[] success_pIds;
70         uint256[] failed_pIds;
71         uint256[] order_pIds;
72         uint256  endTime;
73         uint256 totalCoin;
74         uint256 totalCount;
75         bool  is_activated;
76 		bool  isWithDrawCom;
77         rateTeam team;
78         mapping(address => uint256[])  mAddr_pid;
79         mapping(uint256 => JanKenPonData.playerPacket)  mId_upk;
80         mapping(uint8 => uint256) mCardId_count;
81     }
82 }
83 
84 
85 contract JanKenPon is JanKenPonEvents {
86 
87     using SafeMath for *;
88 
89     address private creator;
90     uint256 private round_Id;
91     uint256 private rand_nonce;
92     
93     uint256 private indexA;
94     
95     uint256 constant private conmaxTime = 72 hours;
96     uint256 constant private intervelTime = 30 seconds;
97     
98     mapping (uint256 => JanKenPonData.Round) private rounds;
99 
100     
101 
102    
103     
104 constructor ()
105         public
106     {
107         creator = msg.sender;
108     }
109     
110 function updateEndTime(uint256 keys)
111     private
112     {
113      uint256 nowTime = now;
114      uint256 newTime;
115 
116      if (nowTime > rounds[round_Id].endTime){
117          setGameOver();
118          rounds[round_Id].totalCoin = address(this).balance;
119          return;
120      }
121      
122      newTime = (keys).mul(intervelTime).add(rounds[round_Id].endTime);
123 
124      if (newTime < (conmaxTime).add(nowTime))
125             rounds[round_Id].endTime = newTime;
126      else
127             rounds[round_Id].endTime = conmaxTime.add(now);
128      
129      }
130 
131 function getGameInfo()
132     public
133     constant
134     returns(uint256,uint256,uint256,uint256,uint256)
135     {
136         return(round_Id,rounds[round_Id].pId_inc,rounds[round_Id].success_pIds.length,rounds[round_Id].failed_pIds.length,address(this).balance);
137     }
138     
139 function getEndTime()
140     public
141     constant
142     returns(uint256)
143     {
144         return rounds[round_Id].endTime;
145     }
146 
147 function getRand()
148     constant
149     public
150     returns(uint256)
151     {
152         return rounds[round_Id].rand_begin;
153     }
154 
155 function getJKPCount()
156     constant
157     public
158     returns(uint256,uint256,uint256)
159     {
160         return (rounds[round_Id].mCardId_count[0],rounds[round_Id].mCardId_count[1],rounds[round_Id].mCardId_count[2]);
161     }
162     
163 function destoryGame()
164     isCreator()
165     public
166     {
167         selfdestruct(creator);
168     }
169     
170 function startGame()
171     isCreator()
172     isOver()
173     public
174     {   
175         round_Id ++;
176         
177         rounds[round_Id] = JanKenPonData.Round({
178             lastWiner:address(0),
179             lastBuyerId: 0,
180             pId_inc:0,
181             rand_begin:rand_pId(7,15),
182             success_pIds: new uint256[](0),
183             failed_pIds: new uint256[](0),
184             order_pIds: new uint256[](0),
185             endTime: now.add(conmaxTime),
186             is_activated:true,
187 			isWithDrawCom:false,
188             totalCoin:0,
189             totalCount:0,
190             team:JanKenPonData.rateTeam({
191                 rateCom:10,
192                 rateNext:20,
193                 rateWin:5,
194                 rateLast:10,
195                 rateBen:25,
196                 rateShare:30,
197                 curPrice:uint256(2000000000000000)+uint256(10000000000000).mul(round_Id-1),
198                 incPrice:10000000000000
199             })
200         });
201         emit onStartGame(rounds[round_Id].team.curPrice,round_Id,rounds[round_Id].endTime);
202     }
203 
204 function getRate()
205     public
206     constant
207     returns(uint256,uint256,uint256,uint256,uint256,uint256)
208     {
209         return (rounds[round_Id].team.rateCom,rounds[round_Id].team.rateNext,rounds[round_Id].team.rateWin,rounds[round_Id].team.rateLast,rounds[round_Id].team.rateBen,rounds[round_Id].team.rateShare);
210     }
211     
212 function getCreator() 
213     public
214     constant
215     returns(address)
216     {
217         return creator;
218     }
219 
220 function getSuccessAndFailedIds()
221     public
222     constant
223     returns(uint256[],uint256[])
224     {
225         return(rounds[round_Id].success_pIds,rounds[round_Id].failed_pIds);
226     }
227     
228 function getPlayerIds(address player)
229     public
230     constant
231     returns(uint256[])
232     {
233         return rounds[round_Id].mAddr_pid[player];
234     }
235     
236 function getSuccessDetail(uint256 id)
237     public
238     constant
239     returns(address,uint8[3],uint8,bool,uint256,uint256)
240     {
241         JanKenPonData.playerPacket memory player = rounds[round_Id].mId_upk[id];
242         
243         return (player.owner,player.cards,player.stars,player.isSelling,player.price,player.count);
244     }
245     
246 function getFailedDetail(uint256 id)
247     public
248     constant
249     returns(address,uint8[3],uint8,uint256)
250     {
251          JanKenPonData.playerPacket memory player = rounds[round_Id].mId_upk[id];
252         
253         return (player.owner,player.cards,player.stars,player.count);
254     }
255 
256 function getBalance()
257     public
258     constant
259     returns(uint256)
260 {
261     return address(this).balance;
262 }
263 
264 function getRoundBalance(uint256 roundId)
265     public
266     constant
267     returns(uint256)
268     {
269         return rounds[roundId].totalCoin;
270     }
271 
272 function getLastWiner(uint256 roundId)
273     public 
274     constant
275     returns(address)
276     {
277         return rounds[roundId].lastWiner;
278     }
279 
280 function getGameStatus() 
281     public
282     constant
283     returns(uint256,bool)
284     {
285         return (round_Id,rounds[round_Id].is_activated);
286     }
287 
288 function setLastWiner(address ply)
289     private
290     {
291         rounds[round_Id].lastWiner = ply;
292     }
293 
294 
295 function joinGame(uint8[3] cards, uint256 count) 
296     isActivated()
297     isHuman()
298     isEnough(msg.value)
299     payable
300     public
301     {    
302         require(msg.value >= currentPrice().mul(count),"value not enough");
303 
304         for (uint256 j = 0; j < cards.length; j ++){
305             require(cards[j] == 0 || cards[j] == 1 || cards[j] == 2,"card type not right");
306             rounds[round_Id].mCardId_count[cards[j]]++;
307         }
308         
309         updateEndTime(count);
310         rounds[round_Id].mAddr_pid[msg.sender].push(rounds[round_Id].pId_inc);
311         rounds[round_Id].mId_upk[rounds[round_Id].pId_inc] = JanKenPonData.playerPacket({
312             pId:rounds[round_Id].pId_inc,
313             owner:msg.sender,
314             stars:3,
315             cards:cards,
316             cardIndex:0,
317             isSelling:false,
318             price:0,
319             isWithDrawWiner:false,
320             isWithDrawShare:false,
321             isWithDrawLastBuyer:false,
322             isWithdrawBenefit:false,
323             count:count
324         });
325         rounds[round_Id].lastBuyerId = rounds[round_Id].pId_inc;
326         indexPK(rounds[round_Id].pId_inc);
327         rounds[round_Id].pId_inc ++;
328         rounds[round_Id].totalCount += count;
329         rounds[round_Id].totalCoin += msg.value;
330         emit onJoinGame(msg.sender,cards.length,round_Id,currentPrice(),rounds[round_Id].endTime);
331     }
332 
333 function getLastKey(uint256 roundId)
334     public
335     constant
336     returns(uint256)
337     {
338         return rounds[roundId].lastBuyerId;
339     }
340     
341 function currentPrice()
342     public
343     constant
344     returns(uint256)
345     {
346         return rounds[round_Id].team.curPrice;
347     }
348 
349 function getOrders()
350     public
351     constant
352     returns(uint256[])
353     {
354         return rounds[round_Id].order_pIds;
355     }
356     
357 function doOrder(uint256 pid,uint256 price)
358     isActivated()
359     public
360     {
361         require(rounds[round_Id].mId_upk[pid].owner == msg.sender && rounds[round_Id].mId_upk[pid].stars > 5 &&  rounds[round_Id].mId_upk[pid].cardIndex > 2 &&  rounds[round_Id].mId_upk[pid].isSelling == false,"condition not ok");
362         
363          rounds[round_Id].mId_upk[pid].isSelling = true;
364          rounds[round_Id].mId_upk[pid].price = price;
365          
366          rounds[round_Id].order_pIds.push(pid);
367          
368          emit onSellOrder();
369     }
370 
371 function cancelOrder(uint256 pid)
372     isActivated()
373     public
374     {
375         require(rounds[round_Id].mId_upk[pid].isSelling == true && rounds[round_Id].mId_upk[pid].owner == msg.sender,"condition not ok");
376 
377         rounds[round_Id].mId_upk[pid].isSelling = false;
378         rounds[round_Id].mId_upk[pid].price = 0;
379         
380         emit onCancelOrder();
381     }
382 
383 function buyOrder(uint256 buyerId,uint256 sellerId)
384     isActivated()
385     payable
386     public  
387 {
388     require(rounds[round_Id].mId_upk[sellerId].isSelling == true && msg.value >= rounds[round_Id].mId_upk[sellerId].price && rounds[round_Id].mId_upk[buyerId].owner == msg.sender,"condition not right");
389 
390     rounds[round_Id].mId_upk[sellerId].owner.transfer(msg.value.mul(9)/10);
391     rounds[round_Id].mId_upk[sellerId].stars --;
392     rounds[round_Id].mId_upk[buyerId].stars ++;
393     
394     if(rounds[round_Id].mId_upk[buyerId].stars > 4){
395         rounds[round_Id].success_pIds.push(buyerId);
396     }
397 
398     rounds[round_Id].mId_upk[sellerId].price = 0;
399     rounds[round_Id].mId_upk[sellerId].isSelling = false;
400     
401     emit onBuyOrder();
402 }
403 
404 function withdrawWiner(uint256 roundId,uint256 pId)
405 	isOver()
406     payable
407     public
408 {
409     JanKenPonData.playerPacket memory player = rounds[roundId].mId_upk[pId];
410     
411     if (player.stars > 4 && player.cardIndex > 2 && player.isWithDrawWiner == false && player.owner == rounds[roundId].lastWiner) {
412         uint256 winer = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateWin)/100;
413         rounds[roundId].mId_upk[pId].owner.transfer(winer);
414         rounds[roundId].mId_upk[pId].isWithDrawWiner = true;
415     }
416 }
417 
418 function getWithdrawShare(uint256 roundId)
419     constant
420     public
421     returns(uint256)
422     {
423         uint256 share = 0;
424         uint256 lastwin = 0;
425 
426         share = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateShare)/100/rounds[roundId].success_pIds.length;
427 
428         if(msg.sender == rounds[roundId].lastWiner){
429                 lastwin = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateWin)/100;
430         }
431         return share.add(lastwin);
432     }
433     
434 function withdrawShare(uint256 roundId,uint256 pId)
435 	isOver()
436     payable
437     public
438 {   
439     uint256 share = 0;
440     uint256 lastwin = 0;
441     
442     JanKenPonData.playerPacket memory player = rounds[roundId].mId_upk[pId];
443 
444     if (player.stars > 4 && player.cardIndex > 2 && player.isWithDrawShare == false && rounds[roundId].success_pIds.length > 0) {
445 
446             share = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateShare)/100/rounds[roundId].success_pIds.length;
447 
448             if(player.owner == rounds[roundId].lastWiner && player.isWithDrawWiner == false){
449                 lastwin = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateWin)/100;
450                 rounds[roundId].mId_upk[pId].isWithDrawWiner = true;
451             }
452             rounds[roundId].mId_upk[pId].owner.transfer(share.add(lastwin));
453             rounds[roundId].mId_upk[pId].isWithDrawShare = true;
454     }
455 }
456 
457 function withdrawCom(uint256 roundId)
458     isCreator()
459 	isOver()
460     payable
461     public
462 {
463      if (rounds[roundId].isWithDrawCom == false){
464         uint256 comm = (rounds[roundId].totalCoin).mul(rounds[roundId].team.rateCom)/100;
465         creator.transfer(comm);
466         rounds[roundId].isWithDrawCom = true;
467     }
468 }
469 
470 function withdrawBenefit(uint256 roundId,uint256 pId)
471 	isOver()
472     payable
473     public
474     {
475         uint256 benefit = 0;
476         uint256 lastbuyer = 0;
477 
478         if (rounds[roundId].pId_inc > 1 && rounds[roundId].mId_upk[pId].owner == msg.sender && pId != rounds[roundId].lastBuyerId  && rounds[roundId].mId_upk[pId].isWithdrawBenefit == false){
479            
480             uint256 curPid = rounds[roundId].pId_inc.sub(1);
481             
482             uint256 totleIds = curPid.mul(curPid.add(1))/2;
483             
484             uint256 uAmount = rounds[roundId].mId_upk[pId].count;
485             
486             JanKenPonData.Round  memory r= rounds[roundId];
487             
488             uint256 benefitCoin = r.totalCoin.mul(r.team.rateBen)/100;
489             
490             benefit = (benefitCoin.mul(uAmount).mul(curPid.sub(pId))/r.totalCount/totleIds);
491             
492             if (pId == rounds[roundId].lastBuyerId && rounds[roundId].mId_upk[pId].isWithDrawLastBuyer == false) {
493                  lastbuyer = (rounds[round_Id].totalCoin).mul(rounds[roundId].team.rateLast)/100;
494                  rounds[roundId].mId_upk[pId].isWithDrawLastBuyer = true;
495             }
496 
497             msg.sender.transfer(benefit.add(lastbuyer));
498             
499             rounds[roundId].mId_upk[pId].isWithdrawBenefit = true;
500         }
501         
502         emit onWithdrawBenefit();
503     }
504 
505 function getBenefit(uint256 roundId,uint256 pId)
506     public
507     constant
508     returns(uint256,uint256,bool,bool)
509     {   
510         uint256 benefit = 0;
511         uint256 lastbuyer = 0;
512     
513         JanKenPonData.Round memory r = rounds[roundId];
514         JanKenPonData.playerPacket memory p =  rounds[roundId].mId_upk[pId];
515         
516         if (r.pId_inc > 1){
517             
518             uint256 curPid = r.pId_inc.sub(1);
519             
520             uint256 totleIds = curPid.mul(curPid.add(1))/2;
521             
522             uint256 benefitCoin = r.totalCoin.mul(r.team.rateBen)/100;
523             
524             benefit = (benefitCoin.mul(p.count).mul(curPid.sub(pId))/r.totalCount/totleIds);
525 
526              if (pId == r.lastBuyerId &&  rounds[roundId].mId_upk[pId].isWithDrawLastBuyer == false) {
527                  lastbuyer = (r.totalCoin).mul(r.team.rateLast)/100;
528             }
529             return ( p.count,benefit.add(lastbuyer), p.isWithdrawBenefit,r.is_activated);
530         }else{
531             return (0,0,false,false);
532         }
533     }
534     
535 function setGameOver()
536     private
537 {
538     require(rounds[round_Id].is_activated, "the game has ended");
539 
540     rounds[round_Id].is_activated = false;
541 }
542 
543 function()
544     payable
545     {
546     }
547 
548 function getTotalCount(uint256 roundId)
549     constant
550     public
551     returns(uint256)
552     {
553         return rounds[roundId].totalCount;
554     }
555 
556 function getSuccessCount()
557     constant
558     public
559     returns(uint256)
560     {
561         return rounds[round_Id].success_pIds.length;
562     }
563 
564 function getFailedCount()
565     constant
566     public
567     returns(uint256)
568     {
569         return rounds[round_Id].failed_pIds.length;
570     }
571     
572 function indexPK(uint256 indexB) 
573     private
574 {
575         if (rounds[round_Id].pId_inc < rounds[round_Id].rand_begin){
576             return;
577         }
578         uint8 cardA = rounds[round_Id].mId_upk[indexA].cards[rounds[round_Id].mId_upk[indexA].cardIndex];
579         uint8 cardB = rounds[round_Id].mId_upk[indexB].cards[rounds[round_Id].mId_upk[indexB].cardIndex];
580         
581         uint8 result = cardPK(cardA,cardB);
582 
583         if (result == 0){
584             rounds[round_Id].mId_upk[indexA].stars ++;
585             rounds[round_Id].mId_upk[indexB].stars --;
586         }else if (result == 2){
587             rounds[round_Id].mId_upk[indexA].stars --;
588             rounds[round_Id].mId_upk[indexB].stars ++;
589         }
590 
591         rounds[round_Id].mId_upk[indexA].cardIndex ++;
592         rounds[round_Id].mId_upk[indexB].cardIndex ++;
593 
594         if (rounds[round_Id].mId_upk[indexA].cardIndex > 2){
595             if (rounds[round_Id].mId_upk[indexA].stars > 4) {
596                 rounds[round_Id].success_pIds.push(indexA);
597                 rounds[round_Id].lastWiner = rounds[round_Id].mId_upk[indexA].owner;
598             }else{
599                  rounds[round_Id].failed_pIds.push(indexA);
600             }
601             indexA++;
602         }
603         emit onPK(indexA,cardA,indexB,cardB);
604 }
605 
606 function cardPK(uint8 cA,uint8 cB)
607     isCardOK(cA)
608     isCardOK(cB)
609     private
610     returns(uint8) 
611 {
612     rounds[round_Id].mCardId_count[cA]--;
613     rounds[round_Id].mCardId_count[cB]--;
614     
615     if(cA == 0){
616             if(cB == 2){
617                 return 0;
618             }else if (cB == 1){
619                 return 2;
620             }
621             return 1;
622     }
623     if (cA == 1){
624             if(cB == 0){
625                 return 0;
626             }else if (cB == 2){
627                 return 2;
628             }
629             return 1;
630     }
631     if (cA == 2){
632             if(cB == 1){
633                 return 0;
634             }else if (cB == 0){
635                 return 2;
636             }
637             return 1;
638     }                 
639 }
640 
641 
642 function rand_pId(uint256 min,uint256 max)
643         private 
644         returns(uint256)
645     {   
646         if (max == 0){
647             return 0;
648         }
649         rand_nonce++;
650         uint256 seed = uint256(keccak256(abi.encodePacked(
651              (block.timestamp).add
652              (rand_nonce).add
653              (now)
654             )));
655         return uint256(min + (seed%(max-min)));
656     }
657 
658 //====================================modifier=============================//
659 
660 modifier isCreator() {
661     require(msg.sender == creator, "only creator can do");
662     _;
663 }
664 
665 modifier isHuman() {
666         address addr = msg.sender;
667         uint256 codeLength;
668         
669         assembly {codeLength := extcodesize(addr)}
670         require(codeLength == 0, "sorry humans only");
671         _;
672     }
673 
674 modifier isOver() {
675         require(rounds[round_Id].is_activated == false, "game is activated");
676         _;
677     }
678 
679 modifier isActivated() {
680         require(rounds[round_Id].is_activated == true, "game not begin"); 
681         _;
682     }
683 
684 modifier isEnough(uint256 eth) {
685     require(eth >= 1000000000, "not a valid currency");
686     _;
687 }
688 
689 modifier isCardsOK(uint8[3] cards){
690     bool isOK = true;
691     for(uint256 i=0;i< cards.length;i++){
692         if (cards[i] != 0 && cards[i] != 1 && cards[i] != 2) {
693             isOK = false;
694         }
695     }
696     require(isOK, "card type not right");
697     _;
698 }
699 
700 modifier isCardOK(uint256 card) {
701     bool isOK = false;
702     if (card == 0 || card == 1 || card == 2) {
703             isOK = true;
704     }
705      require(isOK, "card type not right");
706     _;
707 }
708  //==========================================================================//
709 
710 }
711 
712 
713 
714 library SafeMath {
715     
716     /**
717     * @dev Multiplies two numbers, throws on overflow.
718     */
719     function mul(uint256 a, uint256 b) 
720         internal 
721         pure 
722         returns (uint256 c) 
723     {
724         if (a == 0) {
725             return 0;
726         }
727         c = a * b;
728         require(c / a == b, "SafeMath mul failed");
729         return c;
730     }
731 
732     /**
733     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
734     */
735     function sub(uint256 a, uint256 b)
736         internal
737         pure
738         returns (uint256) 
739     {
740         require(b <= a, "SafeMath sub failed");
741         return a - b;
742     }
743 
744     /**
745     * @dev Adds two numbers, throws on overflow.
746     */
747     function add(uint256 a, uint256 b)
748         internal
749         pure
750         returns (uint256 c) 
751     {
752         c = a + b;
753         require(c >= a, "SafeMath add failed");
754         return c;
755     }
756     
757     /**
758      * @dev gives square root of given x.
759      */
760     function sqrt(uint256 x)
761         internal
762         pure
763         returns (uint256 y) 
764     {
765         uint256 z = ((add(x,1)) / 2);
766         y = x;
767         while (z < y) 
768         {
769             y = z;
770             z = ((add((x / z),z)) / 2);
771         }
772     }
773     
774     /**
775      * @dev gives square. multiplies x by x
776      */
777     function sq(uint256 x)
778         internal
779         pure
780         returns (uint256)
781     {
782         return (mul(x,x));
783     }
784     
785     /**
786      * @dev x to the power of y 
787      */
788     function pwr(uint256 x, uint256 y)
789         internal 
790         pure 
791         returns (uint256)
792     {
793         if (x==0)
794             return (0);
795         else if (y==0)
796             return (1);
797         else 
798         {
799             uint256 z = x;
800             for (uint256 i=1; i < y; i++)
801                 z = mul(z,x);
802             return (z);
803         }
804     }
805 }