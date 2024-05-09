1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract EstateParticipationUnit  
51 {
52     using SafeMath for uint256;  
53     
54     enum VoteType
55     {
56         NONE,
57         ALLOW_TRANSFER,
58         CHANGE_ADMIN_WALLET,
59         CHANGE_BUY_SELL_LIMITS,
60         CHANGE_BUY_SELL_PRICE,
61         SEND_WEI_FROM_EXCHANGE,
62         SEND_WEI_FROM_PAYMENT,
63         TRANSFER_EXCHANGE_WEI_TO_PAYMENT,
64         START_PAYMENT
65     }
66     
67     struct VoteData
68     {
69         bool voteYes;
70         bool voteCancel;
71         address person;
72         uint lastVoteId;
73     }
74     
75     struct PaymentData
76     {
77         uint weiTotal;
78         uint weiReceived;
79         uint unitsTotal;
80         uint unitsReceived;
81         uint weiForSingleUnit;
82     }
83     
84     struct BalanceData
85     {
86         uint balance;
87         uint transferAllowed;
88         uint balancePaymentSeries;
89         VoteData vote;
90         mapping (address => uint) allowed;
91         bytes32 paymentBalances;
92     }
93     
94     struct ChangeBuySellPriceVoteData
95     {
96         bool ignoreSecurityLimits;
97         uint buyPrice;
98         uint buyAddUnits;
99         uint sellPrice;
100         uint sellAddUnits;
101     }
102     
103     struct AllowTransferVoteData
104     {
105         address addressTo;
106         uint amount;
107     }
108     
109     struct ChangeAdminAddressVoteData
110     {
111         uint index;
112         address adminAddress;
113     }
114     
115     struct ChangeBuySellLimitsVoteData
116     {
117         uint buyPriceMin;
118         uint buyPriceMax;
119         uint sellPriceMin;
120         uint sellPriceMax;
121     }
122     
123     struct SendWeiFromExchangeVoteData
124     {
125         address addressTo;
126         uint amount;
127     }
128     
129     struct SendWeiFromPaymentVoteData
130     {
131         address addressTo;
132         uint amount;
133     }
134     
135     struct TransferWeiFromExchangeToPaymentVoteData
136     {
137         bool reverse;
138         uint amount;
139     }
140     
141     struct StartPaymentVoteData
142     {
143         uint weiToShare;
144         uint date;
145     }
146     
147     struct PriceSumData
148     {
149         uint price;
150         uint amount;
151     }
152     
153     modifier onlyAdmin()
154     {
155         require (isAdmin(msg.sender));
156         _;
157     }
158     
159     address private mainBalanceAdmin;
160     address private buyBalanceAdmin;
161     address private sellBalanceAdmin;
162     string public constant name = "Estate Participation Unit";
163     string public constant symbol = "EPU";
164     uint8 public constant decimals = 0;
165     uint public amountOfUnitsOutsideAdminWallet = 0;
166     uint private constant maxUnits = 200000000;
167     uint public paymentNumber = 0;
168     uint public paymentSortId = 0;
169     uint private paymentSeries = 0;
170     bytes32 private paymentHistory;
171     uint public weiForPayment = 0;
172     uint public totalAmountOfWeiPaidToUsers = 0;
173     uint private totalAmountOfWeiPaidToUsersPerSeries = 0;
174     uint private totalAmountOfWeiOnPaymentsPerSeries = 0;
175     uint public lastPaymentDate;
176     
177     uint private weiBuyPrice = 50000000000000000;
178     uint private securityWeiBuyPriceFrom = 0;
179     uint private securityWeiBuyPriceTo = 0;
180     
181     uint private weiSellPrice = 47000000000000000;
182     uint public unitsToSell = 0;
183     uint private securityWeiSellPriceFrom = 0;
184     uint private securityWeiSellPriceTo = 0;
185     uint public weiFromExchange = 0;
186     
187     PriceSumData private buySum;
188     PriceSumData private sellSum;
189     
190     uint private voteId = 0;
191     bool private voteInProgress;
192     uint private votesTotalYes;
193     uint private votesTotalNo;
194     uint private voteCancel;
195     
196     AllowTransferVoteData private allowTransferVoteData;
197     ChangeAdminAddressVoteData private changeAdminAddressVoteData;
198     ChangeBuySellLimitsVoteData private changeBuySellLimitsVoteData;
199     ChangeBuySellPriceVoteData private changeBuySellPriceVoteData;
200     SendWeiFromExchangeVoteData private sendWeiFromExchangeVoteData;
201     SendWeiFromPaymentVoteData private sendWeiFromPaymentVoteData;
202     TransferWeiFromExchangeToPaymentVoteData private transferWeiFromExchangeToPaymentVoteData;
203     StartPaymentVoteData private startPaymentVoteData;
204     
205     VoteType private voteType = VoteType.NONE;
206     
207     mapping(address => BalanceData) private balances;
208     
209     event Transfer(address indexed from, address indexed to, uint units);
210     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
211     event OnEmitNewUnitsFromMainWallet(uint units, uint totalOutside);
212     event OnAddNewUnitsToMainWallet(uint units, uint totalOutside);
213     event NewPayment(uint indexed index, uint totalWei, uint totalUnits, uint date);
214     event PaymentReceived(address indexed owner, uint paymentId, uint weiAmount, uint units);
215     event UnitsBuy(address indexed buyer, uint amount);
216     event UnitsSell(address indexed seller, uint amount);
217     event OnExchangeBuyUpdate(uint newValue, uint unitsToBuy);
218     event OnExchangeSellUpdate(uint newValue, uint unitsToSell);
219     
220     modifier startVoting
221     {
222         require(voteType == VoteType.NONE);
223         _;
224     }
225     
226     constructor(
227         uint paymentOffset,
228         address mainBalanceAdminAddress, 
229         address buyBalanceAdminAddress, 
230         address sellBalanceAdminAddress
231     ) 
232     payable
233     public
234     {
235         paymentNumber = paymentOffset;
236         mainBalanceAdmin = mainBalanceAdminAddress;
237         buyBalanceAdmin = buyBalanceAdminAddress;
238         sellBalanceAdmin = sellBalanceAdminAddress;
239         BalanceData storage b = balances[mainBalanceAdminAddress];
240         b.balance = maxUnits;
241         weiForPayment = weiForPayment.add(msg.value);
242     }
243     
244     function  getAdminAccounts()
245     external onlyAdmin view
246     returns(
247         address mainBalanceAdminAddress, 
248         address buyBalanceAdminAddress, 
249         address sellBalanceAdminAddress
250     )
251     {
252         mainBalanceAdminAddress = mainBalanceAdmin;
253         buyBalanceAdminAddress = buyBalanceAdmin;
254         sellBalanceAdminAddress = sellBalanceAdmin;
255     }
256     
257     function getBuySellSum()
258     external onlyAdmin view
259     returns(
260         uint buyPrice,
261         uint buyAmount,
262         uint sellPrice,
263         uint sellAmount
264     )
265     {
266         buyPrice = buySum.price;
267         buyAmount = buySum.amount;
268         sellPrice = sellSum.price;
269         sellAmount = sellSum.amount;
270     }
271     
272     function getSecurityLimits() 
273     external view 
274     returns(
275         uint buyPriceFrom, 
276         uint buyPriceTo, 
277         uint sellPriceFrom, 
278         uint sellPriceTo
279     )
280     {
281         buyPriceFrom = securityWeiBuyPriceFrom;
282         buyPriceTo = securityWeiBuyPriceTo;
283         sellPriceFrom = securityWeiSellPriceFrom;
284         sellPriceTo = securityWeiSellPriceTo;
285     }
286     
287     function getThisAddress() 
288     external view 
289     returns (address)
290     {
291         return address(this);
292     }
293     
294     function() payable external 
295     {
296         weiForPayment = weiForPayment.add(msg.value);
297     }
298     
299      function startVotingForAllowTransfer(
300          address addressTo, 
301          uint amount
302     )
303         external onlyAdmin startVoting
304     {
305         voteType = VoteType.ALLOW_TRANSFER;
306         allowTransferVoteData.addressTo = addressTo;
307         allowTransferVoteData.amount = amount;
308         internalStartVoting();
309     }
310     
311     function startVotingForChangeAdminAddress(
312         uint index, 
313         address adminAddress
314     )
315         external onlyAdmin startVoting
316     {
317         require(!isAdmin(adminAddress));
318         voteType = VoteType.CHANGE_ADMIN_WALLET;
319         changeAdminAddressVoteData.index = index;
320         changeAdminAddressVoteData.adminAddress = adminAddress;
321         internalStartVoting();
322     }
323     
324     function startVotingForChangeBuySellLimits(
325         uint buyPriceMin, 
326         uint buyPriceMax, 
327         uint sellPriceMin, 
328         uint sellPriceMax
329     )
330         external onlyAdmin startVoting
331     {
332         if(buyPriceMin > 0 && buyPriceMax > 0)
333         {
334             require(buyPriceMin < buyPriceMax);
335         }
336         if(sellPriceMin > 0 && sellPriceMax > 0)
337         {
338             require(sellPriceMin < sellPriceMax);
339         }
340         if(buyPriceMin > 0 && sellPriceMax > 0)
341         {
342             require(buyPriceMin >= sellPriceMax);
343         }
344         voteType = VoteType.CHANGE_BUY_SELL_LIMITS;
345         changeBuySellLimitsVoteData.buyPriceMin = buyPriceMin;
346         changeBuySellLimitsVoteData.buyPriceMax = buyPriceMax;
347         changeBuySellLimitsVoteData.sellPriceMin = sellPriceMin;
348         changeBuySellLimitsVoteData.sellPriceMax = sellPriceMax;
349         internalStartVoting();
350     }
351     
352     function startVotingForChangeBuySellPrice(
353         uint buyPrice, 
354         uint buyAddUnits, 
355         uint sellPrice, 
356         uint sellAddUnits, 
357         bool ignoreSecurityLimits
358     )
359         external onlyAdmin startVoting
360     {
361         require(buyPrice >= sellPrice);
362         require(sellAddUnits * sellPrice <= weiFromExchange);
363         voteType = VoteType.CHANGE_BUY_SELL_PRICE;
364         changeBuySellPriceVoteData.buyPrice = buyPrice;
365         changeBuySellPriceVoteData.buyAddUnits = buyAddUnits;
366         changeBuySellPriceVoteData.sellPrice = sellPrice;
367         changeBuySellPriceVoteData.sellAddUnits = sellAddUnits;
368         changeBuySellPriceVoteData.ignoreSecurityLimits = ignoreSecurityLimits;
369         internalStartVoting();
370     }
371     
372     function startVotingForSendWeiFromExchange(
373         address addressTo, 
374         uint amount
375     )
376         external onlyAdmin startVoting
377     {
378         require(amount <= weiFromExchange);
379         voteType = VoteType.SEND_WEI_FROM_EXCHANGE;
380         sendWeiFromExchangeVoteData.addressTo = addressTo;
381         sendWeiFromExchangeVoteData.amount = amount;
382         internalStartVoting();
383     }
384     
385     function startVotingForSendWeiFromPayment(
386         address addressTo, 
387         uint amount
388     )
389         external onlyAdmin startVoting
390     {
391         uint balance = address(this).balance.sub(weiFromExchange);
392         require(amount <= balance && amount <= weiForPayment);
393         voteType = VoteType.SEND_WEI_FROM_PAYMENT;
394         sendWeiFromPaymentVoteData.addressTo = addressTo;
395         sendWeiFromPaymentVoteData.amount = amount;
396         internalStartVoting();
397     }
398     
399     function startVotingForTransferWeiFromExchangeToPayment(
400         bool reverse,
401         uint amount
402     )
403         external onlyAdmin startVoting
404     {
405         if(reverse)
406         {
407             require(amount <= weiForPayment);
408         }
409         else
410         {
411             require(amount <= weiFromExchange);
412         }
413         voteType = VoteType.TRANSFER_EXCHANGE_WEI_TO_PAYMENT; 
414         transferWeiFromExchangeToPaymentVoteData.reverse = reverse;
415         transferWeiFromExchangeToPaymentVoteData.amount = amount;
416         internalStartVoting();
417     }
418     
419     function startVotingForStartPayment(
420         uint weiToShare,
421         uint date
422     )
423         external onlyAdmin startVoting
424     {
425         require(weiToShare > 0 && weiToShare <= weiForPayment);
426         voteType = VoteType.START_PAYMENT;
427         startPaymentVoteData.weiToShare = weiToShare;
428         startPaymentVoteData.date = date;
429         internalStartVoting();
430     }
431     
432      function voteForCurrent(bool voteYes)
433         external onlyAdmin
434     {
435         require(voteType != VoteType.NONE);
436         VoteData storage d = balances[msg.sender].vote;
437         // already voted
438         if(d.lastVoteId == voteId)
439         {
440             // ...but changed mind
441             if(voteYes != d.voteYes)
442             {
443                 if(voteYes)
444                 {
445                     votesTotalYes = votesTotalYes.add(1);
446                     votesTotalNo = votesTotalNo.sub(1);
447                 }
448                 else
449                 {
450                     votesTotalYes = votesTotalYes.sub(1);
451                     votesTotalNo = votesTotalNo.add(1);
452                 }
453             }
454         }
455         // a new vote
456         // adding 'else' costs more gas
457         if(d.lastVoteId < voteId)
458         {
459             if(voteYes)
460             {
461                 votesTotalYes = votesTotalYes.add(1);
462             }
463             else
464             {
465                 votesTotalNo = votesTotalNo.add(1);
466             }
467         }
468         // 5 / 10 means something is voted out
469         if(votesTotalYes.mul(10).div(3) > 5)
470         {
471             // adding 'else' for each vote type costs more gas
472             if(voteType == VoteType.ALLOW_TRANSFER)
473             {
474                 internalAllowTransfer(
475                     allowTransferVoteData.addressTo, 
476                     allowTransferVoteData.amount
477                 );
478             }
479             if(voteType == VoteType.CHANGE_ADMIN_WALLET)
480             {
481                 internalChangeAdminWallet(
482                     changeAdminAddressVoteData.index, 
483                     changeAdminAddressVoteData.adminAddress
484                 );
485             }
486             if(voteType == VoteType.CHANGE_BUY_SELL_LIMITS)
487             {
488                 internalChangeBuySellLimits(
489                     changeBuySellLimitsVoteData.buyPriceMin, 
490                     changeBuySellLimitsVoteData.buyPriceMax, 
491                     changeBuySellLimitsVoteData.sellPriceMin, 
492                     changeBuySellLimitsVoteData.sellPriceMax
493                 );
494             }
495             if(voteType == VoteType.CHANGE_BUY_SELL_PRICE)
496             {
497                 internalChangeBuySellPrice(
498                     changeBuySellPriceVoteData.buyPrice, 
499                     changeBuySellPriceVoteData.buyAddUnits, 
500                     changeBuySellPriceVoteData.sellPrice, 
501                     changeBuySellPriceVoteData.sellAddUnits,
502                     changeBuySellPriceVoteData.ignoreSecurityLimits
503                 );
504             }
505             if(voteType == VoteType.SEND_WEI_FROM_EXCHANGE)
506             {
507                 internalSendWeiFromExchange(
508                     sendWeiFromExchangeVoteData.addressTo, 
509                     sendWeiFromExchangeVoteData.amount
510                 );
511             }
512             if(voteType == VoteType.SEND_WEI_FROM_PAYMENT)
513             {
514                 internalSendWeiFromPayment(
515                     sendWeiFromPaymentVoteData.addressTo, 
516                     sendWeiFromPaymentVoteData.amount
517                 );
518             }
519             if(voteType == VoteType.TRANSFER_EXCHANGE_WEI_TO_PAYMENT)
520             {
521                 internalTransferExchangeWeiToPayment(
522                     transferWeiFromExchangeToPaymentVoteData.reverse,
523                     transferWeiFromExchangeToPaymentVoteData.amount
524                 );
525             }
526             if(voteType == VoteType.START_PAYMENT)
527             {
528                 internalStartPayment(
529                     startPaymentVoteData.weiToShare,
530                     startPaymentVoteData.date
531                 );
532             }
533             voteType = VoteType.NONE;
534             internalResetVotingData();
535         }
536         if(votesTotalNo.mul(10).div(3) > 5)
537         {
538             voteType = VoteType.NONE;
539             internalResetVotingData();
540         }
541         d.voteYes = voteYes;
542         d.lastVoteId = voteId;
543     }
544     
545     function voteCancelCurrent() 
546         external onlyAdmin
547     {
548         require(voteType != VoteType.NONE);
549         VoteData storage d = balances[msg.sender].vote;
550         if(d.lastVoteId <= voteId || !d.voteCancel)
551         {
552             d.voteCancel = true;
553             d.lastVoteId = voteId;
554             voteCancel++;
555         }
556         uint votesCalc = voteCancel.mul(10);
557         // 3 admins
558         votesCalc = votesCalc.div(3);
559         // 5 / 10 means something is voted out
560         if(votesCalc > 5)
561         {
562             voteType = VoteType.NONE;
563             internalResetVotingData();
564         }
565     }
566     
567     function addEthForSell() 
568         external payable onlyAdmin
569     {
570         require(msg.value > 0);
571         weiFromExchange = weiFromExchange.add(msg.value);
572     }
573     
574     function addEthForPayment() 
575         external payable
576     {
577         weiForPayment = weiForPayment.add(msg.value);
578     }
579     
580     function buyEPU() 
581     public payable
582     {
583         // how many units has client bought
584         uint amount = msg.value.div(weiBuyPrice);
585         uint b = balances[buyBalanceAdmin].balance;
586         // can't buy more than main account balance
587         if(amount >= b)
588         {
589             amount = b;
590         }
591         // the needed price for bought units
592         uint price = amount.mul(weiBuyPrice);
593         weiFromExchange = weiFromExchange.add(price);
594         if(amount > 0)
595         {
596             buySum.price = buySum.price.add(price);
597             buySum.amount = buySum.amount.add(amount);
598             internalAllowTransfer(msg.sender, amount);
599            // send units to client
600             internalTransfer(buyBalanceAdmin, msg.sender, amount);
601             // emit event
602             emit UnitsBuy(msg.sender, amount);
603             //buyBalanceAdmin.transfer(price); 
604         }
605         // if client sent more than needed
606         if(msg.value > price)
607         {
608             // send him the rest back
609             msg.sender.transfer(msg.value.sub(price));
610         }
611     }
612     
613     function sellEPU(uint amount) 
614         external payable 
615         returns(uint revenue)
616     {
617         require(amount > 0);
618         uint fixedAmount = amount;
619         BalanceData storage b = balances[msg.sender];
620         uint balance = b.balance;
621         uint max = balance < unitsToSell ? balance : unitsToSell;
622         if(fixedAmount > max)
623         {
624             fixedAmount = max;
625         }
626         uint price = fixedAmount.mul(weiSellPrice);
627         require(price > 0 && price <= weiFromExchange);
628         sellSum.price = sellSum.price.add(price);
629         sellSum.amount = sellSum.amount.add(amount);
630         internalTransfer(msg.sender, sellBalanceAdmin, fixedAmount);
631         weiFromExchange = weiFromExchange.sub(price);
632         emit UnitsSell(msg.sender, fixedAmount);
633         msg.sender.transfer(price);
634         return price;
635     }
636     
637     function checkPayment() 
638         external
639     {
640         internalCheckPayment(msg.sender);
641     }
642     
643     function checkPaymentFor(
644         address person
645     )
646         external
647     {
648         internalCheckPayment(person);
649     }
650     
651     function accountData() 
652         external view 
653         returns (
654             uint unitsBalance, 
655             uint payableUnits, 
656             uint totalWeiToReceive, 
657             uint weiBuyPriceForUnit, 
658             uint buyUnitsLeft, 
659             uint weiSellPriceForUnit, 
660             uint sellUnitsLeft
661         )
662     {
663         BalanceData storage b = balances[msg.sender];
664         unitsBalance = b.balance;
665         if(b.balancePaymentSeries < paymentSeries)
666         {
667             payableUnits = unitsBalance;
668             for(uint i = 0; i <= paymentSortId; i++)
669             {
670                 totalWeiToReceive = totalWeiToReceive.add(getPaymentWeiPerUnit(i).mul(payableUnits));
671             }
672         }
673         else
674         {
675             (totalWeiToReceive, payableUnits) = getAddressWeiFromPayments(b);
676         }
677         weiBuyPriceForUnit = weiBuyPrice;
678         buyUnitsLeft = balances[buyBalanceAdmin].balance;
679         weiSellPriceForUnit = weiSellPrice;
680         sellUnitsLeft = unitsToSell;
681     }
682     
683     function getBuyUnitsInformations() 
684         external view 
685         returns(
686             uint weiBuyPriceForUnit, 
687             uint unitsLeft
688         )
689     {
690         weiBuyPriceForUnit = weiBuyPrice;
691         unitsLeft = balances[buyBalanceAdmin].balance;
692     }
693     
694     function getSellUnitsInformations() 
695         external view 
696         returns(
697             uint weiSellPriceForUnit, 
698             uint unitsLeft
699         )
700     {
701         weiSellPriceForUnit = weiSellPrice;
702         unitsLeft = unitsToSell;
703     }
704     
705     function checkVotingForAllowTransfer() 
706         external view onlyAdmin 
707         returns(
708             address allowTo, 
709             uint amount, 
710             uint votesYes, 
711             uint votesNo, 
712             bool stillActive
713         )
714     {
715         require(voteType == VoteType.ALLOW_TRANSFER);
716         return (
717             allowTransferVoteData.addressTo, 
718             allowTransferVoteData.amount, 
719             votesTotalYes, 
720             votesTotalNo, 
721             voteType == VoteType.ALLOW_TRANSFER
722         );
723     }
724     
725     function checkVotingForChangeAdminAddress() 
726         external view onlyAdmin 
727         returns(
728             uint adminId, 
729             address newAdminAddress, 
730             uint votesYes, 
731             uint votesNo, 
732             bool stillActive
733         )
734     {
735         require(voteType == VoteType.CHANGE_ADMIN_WALLET);
736         return (
737             changeAdminAddressVoteData.index, 
738             changeAdminAddressVoteData.adminAddress, 
739             votesTotalYes, 
740             votesTotalNo, 
741             voteType == VoteType.CHANGE_ADMIN_WALLET
742         );
743     }
744     
745     function checkVotingForChangeBuySellLimits() 
746         external view onlyAdmin 
747         returns(
748             uint buyPriceMin, 
749             uint buyPriceMax, 
750             uint sellPriceMin, 
751             uint sellPriceMax, 
752             uint votesYes, 
753             uint votesNo, 
754             bool stillActive
755         )
756     {
757         require(voteType == VoteType.CHANGE_BUY_SELL_LIMITS);
758         return (
759             changeBuySellLimitsVoteData.buyPriceMin,
760             changeBuySellLimitsVoteData.buyPriceMax, 
761             changeBuySellLimitsVoteData.sellPriceMin, 
762             changeBuySellLimitsVoteData.sellPriceMax, 
763             votesTotalYes, 
764             votesTotalNo, 
765             voteType == VoteType.CHANGE_BUY_SELL_LIMITS
766         );
767     }
768     
769     function checkVotingForChangeBuySellPrice() 
770         external view onlyAdmin
771         returns(
772             uint buyPrice, 
773             uint buyAddUnits, 
774             uint sellPrice, 
775             uint sellAddUnits, 
776             bool ignoreSecurityLimits, 
777             uint votesYes, 
778             uint votesNo, 
779             bool stillActive
780         )
781     {
782         require(voteType == VoteType.CHANGE_BUY_SELL_PRICE);
783         return (
784             changeBuySellPriceVoteData.buyPrice, 
785             changeBuySellPriceVoteData.buyAddUnits, 
786             changeBuySellPriceVoteData.sellPrice, 
787             changeBuySellPriceVoteData.sellAddUnits, 
788             changeBuySellPriceVoteData.ignoreSecurityLimits, 
789             votesTotalYes, 
790             votesTotalNo, 
791             voteType == VoteType.CHANGE_BUY_SELL_PRICE
792         );
793     }
794     
795     function checkVotingForSendWeiFromExchange() 
796         external view onlyAdmin 
797         returns(
798             address addressTo, 
799             uint weiAmount, 
800             uint votesYes, 
801             uint votesNo, 
802             bool stillActive
803         )
804     {
805         require(voteType == VoteType.SEND_WEI_FROM_EXCHANGE);
806         return (
807             sendWeiFromExchangeVoteData.addressTo, 
808             sendWeiFromExchangeVoteData.amount, 
809             votesTotalYes, 
810             votesTotalNo, 
811             voteType == VoteType.SEND_WEI_FROM_EXCHANGE
812         );
813     }
814     
815     function checkVotingForSendWeiFromPayment() 
816         external view onlyAdmin
817         returns(
818             address addressTo, 
819             uint weiAmount, 
820             uint votesYes, 
821             uint votesNo, 
822             bool stillActive
823         )
824     {
825         require(voteType == VoteType.SEND_WEI_FROM_PAYMENT);
826         return (
827             sendWeiFromPaymentVoteData.addressTo, 
828             sendWeiFromPaymentVoteData.amount, 
829             votesTotalYes, 
830             votesTotalNo, 
831             voteType == VoteType.SEND_WEI_FROM_PAYMENT
832         );
833     }
834     
835     function checkVotingForTransferWeiFromExchangeToPayment() 
836         external view onlyAdmin
837         returns (
838             bool reverse,
839             uint amount, 
840             uint votesYes, 
841             uint votesNo, 
842             bool stillActive
843         )
844     {
845         require(voteType == VoteType.TRANSFER_EXCHANGE_WEI_TO_PAYMENT);
846         return (
847             transferWeiFromExchangeToPaymentVoteData.reverse,
848             transferWeiFromExchangeToPaymentVoteData.amount, 
849             votesTotalYes, 
850             votesTotalNo, 
851             voteType == VoteType.TRANSFER_EXCHANGE_WEI_TO_PAYMENT
852         );
853     }
854     
855     function checkVotingForStartPayment() 
856         external view onlyAdmin 
857         returns(
858             uint weiToShare, 
859             uint date,
860             uint votesYes, 
861             uint votesNo, 
862             bool stillActive
863         )
864     {
865         require(voteType == VoteType.START_PAYMENT);
866         return (
867             startPaymentVoteData.weiToShare, 
868             startPaymentVoteData.date,
869             votesTotalYes, 
870             votesTotalNo, 
871             voteType == VoteType.START_PAYMENT
872         );
873     }
874     
875     
876     function totalSupply() 
877         public constant 
878         returns (uint)
879     {
880         return maxUnits - balances[mainBalanceAdmin].balance;
881     }
882     
883     
884      //  important to display balance in the wallet.
885     function balanceOf(address unitOwner) 
886         public constant 
887         returns (uint balance) 
888     {
889         balance = balances[unitOwner].balance;
890     }
891     
892     function transferFrom(
893         address from, 
894         address to, uint units
895     ) 
896         public 
897         returns (bool success) 
898     {
899         BalanceData storage b = balances[from];
900         uint a = b.allowed[msg.sender];
901         a = a.sub(units);
902         b.allowed[msg.sender] = a;
903         success = internalTransfer(from, to, units);
904     }
905     
906     function approve(
907         address spender, 
908         uint units
909     ) 
910         public 
911         returns (bool success) 
912     {
913         balances[msg.sender].allowed[spender] = units;
914         emit Approval(msg.sender, spender, units);
915         success = true;
916     }
917     
918     function allowance(
919         address unitOwner, 
920         address spender
921     ) 
922         public constant 
923         returns (uint remaining) 
924     {
925         remaining = balances[unitOwner].allowed[spender];
926     }
927     
928     function transfer(
929         address to, 
930         uint value
931     ) 
932         public 
933         returns (bool success)
934     {
935         return internalTransfer(msg.sender, to, value);
936     }
937     
938     function getMaskForPaymentBytes() private pure returns(bytes32)
939     {
940         return bytes32(uint(2**32 - 1));
941     }
942     
943     function getPaymentBytesIndexSize(uint index) private pure returns (uint)
944     {
945         return 32 * index;
946     }
947     
948     function getPaymentWeiPerUnit(uint index) private view returns(uint weiPerUnit)
949     {
950         bytes32 mask = getMaskForPaymentBytes();
951         uint offsetIndex = getPaymentBytesIndexSize(index);
952         mask = shiftLeft(mask, offsetIndex);
953         bytes32 before = paymentHistory & mask;
954         weiPerUnit = uint(shiftRight(before, offsetIndex)).mul(1000000000000);
955     }
956     
957     //bytes32 private dataBytes;
958     
959     function getMask() private pure returns (bytes32)
960     {
961         return bytes32(uint(2**32 - 1));
962     }
963     
964     function getBitIndex(uint index) private pure returns (uint)
965     {
966         return 32 * index;
967     }
968     
969     function shiftLeft (bytes32 a, uint n) private pure returns (bytes32) 
970     {
971         uint shifted = uint(a) * 2 ** uint(n);
972         return bytes32(shifted);
973     }
974     
975     function shiftRight (bytes32 a, uint n) private pure returns (bytes32) 
976     {
977         uint shifted = uint(a) / 2  ** uint(n);
978         return bytes32(shifted);
979     }
980     
981     function internalStartVoting() 
982         private onlyAdmin
983     {
984         internalResetVotingData();
985         voteId = voteId.add(1);
986     }
987     
988     function internalResetVotingData() 
989         private onlyAdmin
990     {
991         votesTotalYes = 0;
992         votesTotalNo = 0;
993         voteCancel = 0;
994     }
995     
996     function internalAllowTransfer(
997         address from, 
998         uint amount
999     ) 
1000         private
1001     {
1002         BalanceData storage b = balances[from];
1003         b.transferAllowed = b.transferAllowed.add(amount);
1004     }
1005     
1006     function internalChangeAdminWallet(
1007         uint index, 
1008         address addr
1009     ) 
1010         private onlyAdmin
1011     {
1012         // adding 'else' for each index costs more gas
1013         if(index == 0)
1014         {
1015             internalTransferAccount(mainBalanceAdmin, addr);
1016             mainBalanceAdmin = addr;
1017         }
1018         if(index == 1)
1019         {
1020             internalTransferAccount(buyBalanceAdmin, addr);
1021             buyBalanceAdmin = addr;
1022         }
1023         if(index == 2)
1024         {
1025             internalTransferAccount(sellBalanceAdmin, addr);
1026             sellBalanceAdmin = addr;
1027         }
1028     }
1029     
1030     function internalAddBuyUnits(
1031         uint price, 
1032         uint addUnits, 
1033         bool ignoreLimits
1034     ) 
1035         private onlyAdmin
1036     {
1037         if(price > 0)
1038         {
1039             weiBuyPrice = price;
1040             if(!ignoreLimits && securityWeiBuyPriceFrom > 0 && weiBuyPrice < securityWeiBuyPriceFrom)
1041             {
1042                 weiBuyPrice = securityWeiBuyPriceFrom;
1043             }
1044             if(!ignoreLimits && securityWeiBuyPriceTo > 0 && weiBuyPrice > securityWeiBuyPriceTo)
1045             {
1046                 weiBuyPrice = securityWeiBuyPriceTo;
1047             }
1048         }
1049         if(addUnits > 0)
1050         {
1051             uint b = balances[mainBalanceAdmin].balance;
1052             if(addUnits > b)
1053             {
1054                 addUnits = b;
1055             }
1056             internalAllowTransfer(buyBalanceAdmin, addUnits);
1057             internalTransfer(mainBalanceAdmin, buyBalanceAdmin, addUnits);
1058         }
1059         emit OnExchangeBuyUpdate(weiBuyPrice, balances[buyBalanceAdmin].balance);
1060     }
1061     
1062     function internalAddSellUnits(
1063         uint price, 
1064         uint addUnits, 
1065         bool ignoreLimits
1066     ) 
1067         private onlyAdmin
1068     {
1069         if(price > 0)
1070         {
1071             weiSellPrice = price;
1072             if(!ignoreLimits)
1073             {
1074                 if(securityWeiSellPriceFrom > 0 && weiSellPrice < securityWeiSellPriceFrom)
1075                 {
1076                     weiSellPrice = securityWeiSellPriceFrom;
1077                 }
1078                 if(securityWeiSellPriceTo > 0 && weiSellPrice > securityWeiSellPriceTo)
1079                 {
1080                     weiSellPrice = securityWeiSellPriceTo;
1081                 }   
1082             }
1083         }
1084         if(addUnits > 0)
1085         {
1086             unitsToSell = unitsToSell.add(addUnits);
1087             //uint requireWei = unitsToSell * weiSellPrice;
1088             uint maxUnitsAccountCanBuy = sellBalanceAdmin.balance.div(weiSellPrice);
1089             if(unitsToSell > maxUnitsAccountCanBuy)
1090             {
1091                 unitsToSell = maxUnitsAccountCanBuy;
1092             }
1093             //internalTransfer(mainBalanceAdmin, sellBalanceAdmin, unitsToSell);
1094             //balances[mainBalanceAdmin] = balances[mainBalanceAdmin].sub(unitsToSell);
1095         }
1096         emit OnExchangeSellUpdate(weiSellPrice, unitsToSell);
1097     }
1098     
1099     function internalChangeBuySellLimits(
1100         uint buyPriceMin, 
1101         uint buyPriceMax, 
1102         uint sellPriceMin, 
1103         uint sellPriceMax
1104     ) 
1105         private onlyAdmin
1106     {
1107         if(buyPriceMin > 0)
1108         {
1109             securityWeiBuyPriceFrom = buyPriceMin;
1110         }
1111         if(buyPriceMax > 0)
1112         {
1113             securityWeiBuyPriceTo = buyPriceMax;
1114         }
1115         if(sellPriceMin > 0)
1116         {
1117             securityWeiSellPriceFrom = sellPriceMin;
1118         }
1119         if(sellPriceMax > 0)
1120         {
1121             securityWeiSellPriceTo = sellPriceMax;
1122         }
1123     }
1124     
1125     function internalChangeBuySellPrice(
1126         uint buyPrice, 
1127         uint buyAddUnits, 
1128         uint sellPrice, 
1129         uint sellAddUnits, 
1130         bool ignoreSecurityLimits
1131     ) 
1132         private onlyAdmin
1133     {
1134         internalAddBuyUnits(buyPrice, buyAddUnits, ignoreSecurityLimits);
1135         internalAddSellUnits(sellPrice, sellAddUnits, ignoreSecurityLimits);
1136     }
1137     
1138     // Executed when there is too much wei on the exchange
1139     function internalSendWeiFromExchange(
1140         address addressTo, 
1141         uint amount
1142     ) 
1143         private onlyAdmin
1144     {
1145         internalRemoveWeiFromExchange(amount);
1146         addressTo.transfer(amount);
1147     }
1148     
1149     function internalTransferExchangeWeiToPayment(bool reverse, uint amount)
1150         private onlyAdmin
1151     {
1152         if(reverse)
1153         {
1154             weiFromExchange = weiFromExchange.add(amount);
1155             weiForPayment = weiForPayment.sub(amount);
1156         }
1157         else
1158         {
1159             internalRemoveWeiFromExchange(amount);
1160             weiForPayment = weiForPayment.add(amount);
1161         }
1162     }
1163     
1164     function internalRemoveWeiFromExchange(uint amount) 
1165         private onlyAdmin
1166     {
1167         weiFromExchange = weiFromExchange.sub(amount);
1168         uint units = weiFromExchange.div(weiSellPrice);
1169         if(units < unitsToSell)
1170         {
1171             unitsToSell = units;
1172         }
1173     }
1174     
1175     function internalSendWeiFromPayment(
1176         address addressTo,
1177         uint amount
1178     ) 
1179         private onlyAdmin
1180     {
1181         weiForPayment = weiForPayment.sub(amount);
1182         addressTo.transfer(amount);
1183     }
1184     
1185     function getAmountOfUnitsOnPaymentId(
1186         BalanceData storage b, 
1187         uint index
1188     ) 
1189         private view
1190         returns(uint)
1191     {
1192         bytes32 mask = getMask();
1193         uint offsetIndex = getBitIndex(index);
1194         mask = shiftLeft(mask, offsetIndex);
1195         bytes32 before = b.paymentBalances & mask;
1196         before = shiftRight(before, offsetIndex);
1197         uint r = uint(before);
1198         // special case of error
1199         if(r > amountOfUnitsOutsideAdminWallet)
1200         {
1201             return 0;
1202         }
1203         return r;
1204     }
1205     
1206     function setAmountOfUnitsOnPaymentId(
1207         BalanceData storage b, 
1208         uint index,
1209         uint value
1210     )
1211     private
1212     {
1213         bytes32 mask = getMask();
1214         uint offsetIndex = getBitIndex(index);
1215         mask = shiftLeft(mask, offsetIndex);
1216         b.paymentBalances = (b.paymentBalances ^ mask) & b.paymentBalances;
1217         bytes32 field = bytes32(value);
1218         field = shiftLeft(field, offsetIndex);
1219         b.paymentBalances = b.paymentBalances | field;
1220     }
1221     
1222     function internalTransferAccount(
1223         address addrA, 
1224         address addrB
1225     ) 
1226         private onlyAdmin
1227     {
1228         if(addrA != 0x0 && addrB != 0x0)
1229         {
1230             BalanceData storage from = balances[addrA];
1231             BalanceData storage to = balances[addrB];
1232 
1233             if(from.balancePaymentSeries < paymentSeries)
1234             {
1235                 from.paymentBalances = bytes32(0);
1236                 setAmountOfUnitsOnPaymentId(from, 0, from.balance);
1237                 from.balancePaymentSeries = paymentSeries;
1238             }
1239             
1240             if(to.balancePaymentSeries < paymentSeries)
1241             {
1242                 to.paymentBalances = bytes32(0);
1243                 setAmountOfUnitsOnPaymentId(to, 0, to.balance);
1244                 to.balancePaymentSeries = paymentSeries;
1245             }
1246 
1247             uint nextPaymentFirstUnits = getAmountOfUnitsOnPaymentId(from, 0);
1248             setAmountOfUnitsOnPaymentId(from, 0, 0);
1249             setAmountOfUnitsOnPaymentId(to, 1, nextPaymentFirstUnits);
1250             for(uint i = 0; i <= 5; i++)
1251             {
1252                 uint existingUnits = getAmountOfUnitsOnPaymentId(from, i);
1253                 existingUnits = existingUnits.add(getAmountOfUnitsOnPaymentId(to, i));
1254                 
1255                 setAmountOfUnitsOnPaymentId(from, i, 0);
1256                 setAmountOfUnitsOnPaymentId(to, i, existingUnits);
1257             }
1258             to.balance = to.balance.add(from.balance);
1259             from.balance = 0;
1260         }
1261     }
1262     
1263     // metamask error with start payment? Ensure if it's not dividing by 0!
1264     
1265     function internalStartPayment(uint weiTotal, uint date) 
1266         private onlyAdmin
1267     {
1268         require(weiTotal >= amountOfUnitsOutsideAdminWallet);
1269         paymentNumber = paymentNumber.add(1);
1270         paymentSortId = paymentNumber % 6;
1271         if(paymentSortId == 0)
1272         {
1273             paymentHistory = bytes32(0);
1274             paymentSeries = paymentSeries.add(1);
1275             
1276             uint weiLeft = totalAmountOfWeiOnPaymentsPerSeries.sub(totalAmountOfWeiPaidToUsersPerSeries);
1277             if(weiLeft > 0)
1278             {
1279                 weiForPayment = weiForPayment.add(weiLeft);
1280             }
1281             totalAmountOfWeiPaidToUsersPerSeries = 0;
1282             totalAmountOfWeiOnPaymentsPerSeries = 0;
1283         }
1284         buySum.price = 0;
1285         buySum.amount = 0;
1286         sellSum.price = 0;
1287         sellSum.amount = 0;
1288         bytes32 mask = getMaskForPaymentBytes();
1289         uint offsetIndex = getPaymentBytesIndexSize(paymentSortId);
1290         mask = shiftLeft(mask, offsetIndex);
1291         paymentHistory = (paymentHistory ^ mask) & paymentHistory;
1292         // amount of microether (1 / 1 000 000 eth)  per unit
1293         bytes32 field = bytes32((weiTotal.div(1000000000000)).div(amountOfUnitsOutsideAdminWallet));
1294         field = shiftLeft(field, offsetIndex);
1295         paymentHistory = paymentHistory | field;
1296         weiForPayment = weiForPayment.sub(weiTotal);
1297         totalAmountOfWeiOnPaymentsPerSeries = totalAmountOfWeiOnPaymentsPerSeries.add(weiTotal);
1298         internalCheckPayment(buyBalanceAdmin);
1299         internalCheckPayment(sellBalanceAdmin);
1300         lastPaymentDate = date;
1301         emit NewPayment(paymentNumber, weiTotal, amountOfUnitsOutsideAdminWallet, lastPaymentDate);
1302     }
1303     
1304     function internalCheckPayment(address person) 
1305         private
1306     {
1307         require(person != mainBalanceAdmin);
1308         BalanceData storage b = balances[person];
1309         if(b.balancePaymentSeries < paymentSeries)
1310         {
1311             b.balancePaymentSeries = paymentSeries;
1312             b.paymentBalances = bytes32(b.balance);
1313         }
1314         (uint weiToSendSum, uint unitsReceived) = getAddressWeiFromPayments(b);
1315         b.paymentBalances = bytes32(0);
1316         setAmountOfUnitsOnPaymentId(b, paymentSortId.add(1), b.balance);
1317         if(weiToSendSum > 0)
1318         {
1319             totalAmountOfWeiPaidToUsers = totalAmountOfWeiPaidToUsers.add(weiToSendSum);
1320             totalAmountOfWeiPaidToUsersPerSeries = totalAmountOfWeiPaidToUsersPerSeries.add(weiToSendSum);
1321             emit PaymentReceived(person, paymentNumber, weiToSendSum, unitsReceived);
1322             person.transfer(weiToSendSum);   
1323         }
1324     }
1325     
1326     function getAddressWeiFromPayments(BalanceData storage b)
1327         private view
1328         returns(uint weiSum, uint unitsSum)
1329     {
1330         for(uint i = 0; i <= paymentSortId; i++)
1331         {
1332             unitsSum = unitsSum.add(getAmountOfUnitsOnPaymentId(b, i));
1333             weiSum = weiSum.add(getPaymentWeiPerUnit(i).mul(unitsSum));
1334         }
1335     }
1336     
1337     function proceedTransferFromMainAdmin(BalanceData storage bT, uint value)
1338         private
1339     {
1340         if(bT.balancePaymentSeries < paymentSeries)
1341         {
1342             bT.paymentBalances = bytes32(0);
1343             setAmountOfUnitsOnPaymentId(bT, 0, bT.balance);
1344             bT.balancePaymentSeries = paymentSeries;
1345         }
1346         amountOfUnitsOutsideAdminWallet = amountOfUnitsOutsideAdminWallet.add(value);   
1347         uint fixedNewPayment = paymentNumber.add(1);
1348         uint curr = getAmountOfUnitsOnPaymentId(bT, fixedNewPayment).add(value);
1349         setAmountOfUnitsOnPaymentId(bT, fixedNewPayment, curr);
1350     }
1351     
1352     function proceedTransferToMainAdmin(BalanceData storage bF, uint value)
1353         private
1354     {
1355         amountOfUnitsOutsideAdminWallet = amountOfUnitsOutsideAdminWallet.sub(value);
1356         if(bF.balancePaymentSeries < paymentSeries)
1357         {
1358             bF.paymentBalances = bytes32(0);
1359             setAmountOfUnitsOnPaymentId(bF, 0, bF.balance);
1360             bF.balancePaymentSeries = paymentSeries;
1361         }
1362         uint maxVal = paymentSortId.add(1);
1363         for(uint i = 0; i <= maxVal; i++)
1364         {
1365             uint v = getAmountOfUnitsOnPaymentId(bF, i);
1366             if(v >= value)
1367             {
1368                 setAmountOfUnitsOnPaymentId(bF, i, v.sub(value));
1369                 break;
1370             }
1371             value = value.sub(v);
1372             setAmountOfUnitsOnPaymentId(bF, i, 0);
1373         }
1374     }
1375     
1376     function proceedTransferFromUserToUser(BalanceData storage bF, BalanceData storage bT, uint value)
1377         private
1378     {
1379         if(bF.balancePaymentSeries < paymentSeries)
1380         {
1381             bF.paymentBalances = bytes32(0);
1382             setAmountOfUnitsOnPaymentId(bF, 0, bF.balance);
1383             bF.balancePaymentSeries = paymentSeries;
1384         }
1385         if(bT.balancePaymentSeries < paymentSeries)
1386         {
1387             bT.paymentBalances = bytes32(0);
1388             setAmountOfUnitsOnPaymentId(bT, 0, bT.balance);
1389             bT.balancePaymentSeries = paymentSeries;
1390         }
1391         uint maxVal = paymentSortId.add(1);
1392         for(uint i = 0; i <= maxVal; i++)
1393         {
1394             uint fromAmount = getAmountOfUnitsOnPaymentId(bF, i);
1395             uint toAmount = getAmountOfUnitsOnPaymentId(bT, i);
1396             if(fromAmount >= value)
1397             {
1398                 setAmountOfUnitsOnPaymentId(bT, i, toAmount.add(value));
1399                 setAmountOfUnitsOnPaymentId(bF, i, fromAmount.sub(value));
1400                 break;
1401             }
1402             value = value.sub(fromAmount);
1403             setAmountOfUnitsOnPaymentId(bT, i, toAmount.add(fromAmount));
1404             setAmountOfUnitsOnPaymentId(bF, i, 0);
1405         }
1406     }
1407     
1408     function internalTransfer(
1409         address from, 
1410         address to, 
1411         uint value
1412     ) 
1413         private 
1414         returns (bool success)
1415     {
1416         BalanceData storage bF = balances[from];
1417         BalanceData storage bT = balances[to];
1418         if(to == 0x0 || bF.balance < value)
1419         {
1420             return false;
1421         }
1422         bool fromMainAdmin = from == mainBalanceAdmin;
1423         bool fromAdminToNonAdmin = isAdmin(from) && !isAdmin(to);
1424         if(fromMainAdmin || fromAdminToNonAdmin)
1425         {
1426             assert(bT.transferAllowed > 0);
1427             if(value > bT.transferAllowed)
1428             {
1429                 value = bT.transferAllowed;
1430             }
1431             bT.transferAllowed = bT.transferAllowed.sub(value);
1432         }
1433         if(to == sellBalanceAdmin)
1434         {
1435             require(unitsToSell > 0);
1436             if(value > unitsToSell)
1437             {
1438                 value = unitsToSell;
1439             }
1440             unitsToSell = unitsToSell.sub(value);
1441         }
1442         
1443         if(fromMainAdmin)
1444         {
1445             proceedTransferFromMainAdmin(bT, value);
1446             emit OnEmitNewUnitsFromMainWallet(value, amountOfUnitsOutsideAdminWallet);
1447         }
1448         else if(to == mainBalanceAdmin)
1449         {
1450             proceedTransferToMainAdmin(bF, value);
1451             emit OnAddNewUnitsToMainWallet(value, amountOfUnitsOutsideAdminWallet);
1452         }
1453         else
1454         {
1455             proceedTransferFromUserToUser(bF, bT, value);
1456         }
1457         bF.balance = bF.balance.sub(value);
1458         bT.balance = bT.balance.add(value);
1459         emit Transfer(from, to, value);
1460         return true;
1461     }
1462     
1463     function isAdmin(address  person) private view 
1464     returns(bool)
1465     {
1466         return (person == mainBalanceAdmin || person == buyBalanceAdmin || person == sellBalanceAdmin);
1467     }
1468 }