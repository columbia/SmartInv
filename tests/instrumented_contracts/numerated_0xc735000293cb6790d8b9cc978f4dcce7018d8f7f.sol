1 pragma solidity 0.5.0;
2 
3 /*
4 * In Contracts We Trust
5 *
6 * Countdown3D is a provably-fair multi tier lottery played using Ether
7 *
8 * ======================== *
9 *     CRYPTO COUNTDOWN     *
10 *          3 2 1           *
11 * ======================== *
12 * [x] Provably Fair
13 * [x] Open Source
14 * [x] Multi Tier Rewards
15 * [x] Battle Tested with the Team Just community!
16 *
17 */
18 
19 // Invest in Hourglass Contract Interface
20 // 0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe
21 interface HourglassInterface {
22     // Invest in dividends for bigger better shinier future jackpots
23     function buy(address _playerAddress) external payable returns(uint256);
24     // Withdraw hourglass dividends to the round pot
25     function withdraw() external;
26     // Would you look at all those divs
27     function dividendsOf(address _playerAddress) external view returns(uint256);
28     // Check out that hourglass balance
29     function balanceOf(address _playerAddress) external view returns(uint256);
30 }
31 
32 
33 contract Countdown3D {
34 
35     /* ==== INTERFACE ==== */
36     HourglassInterface internal hourglass;
37 
38     /* ==== EVENTS ==== */
39     // Emit event onBuy
40     event OnBuy(address indexed _playerAddress, uint indexed _roundId, uint _tickets, uint _value);
41     // Emit event when round is capped
42     event OnRoundCap(uint _roundId);
43     // Emit event when new round starts
44     event OnRoundStart(uint _roundId);
45 
46     /* ==== GLOBALS ==== */
47     // Crypto Countdown timer
48     uint256 constant public COOLDOWN = 7 days;
49 
50     // Cost per ticket
51     uint256 constant public COST = 0.01 ether;
52 
53     // Claim your winnings within 5 rounds
54     uint256 constant public EXPIRATION = 5;
55 
56     // Minimum number of tickets needed to build a pyramid
57     uint256 constant public QUORUM = 21;
58 
59     // Maximum tickets an account can hold at any given time
60     uint256 constant public TICKET_MAX = 101;
61 
62     // The Current Round
63     uint256 public currentRoundId;
64 
65     // Developers
66     address private dev1;
67     address private dev2;
68 
69     /* ==== STRUCT ==== */
70     struct Round {
71         // Balance set after the round is capped
72         uint256 balance;
73         // Block number that caps this round
74         uint256 blockCap;
75         // Ether claimed from this round
76         uint256 claimed;
77         // Pot is composed of tickets, donations, unclaimed winnings, percent of previous round, and hourglass dividends
78         uint256 pot;
79         // Random index from the future
80         uint256 random;
81         // Timestamp when this round kicks off
82         uint256 startTime;
83         // Total tickets in this round
84         uint256 tickets;
85         // Value of a ticket in each winning tier
86         mapping (uint256 => uint256) caste;
87         // Validate a round to score a reward
88         mapping (address => uint256) reward;
89     }
90 
91     struct Account {
92         // Store each round an account holds tickets
93         uint256[] roundsActive;
94         // Store each round an account holds validation rewards
95         uint256[] rewards;
96         // Map Round id to ticket sets
97         mapping(uint256 => TicketSet[]) ticketSets;
98         // Total tickets held by account
99         uint256 tickets;
100     }
101 
102     // A set of tickets
103     struct TicketSet {
104         // Index of first ticket in set
105         uint256 start;
106         // Index of last ticket in the set
107         uint256 end;
108     }
109 
110     // Map a round id to a round
111     mapping (uint256 => Round) internal rounds;
112     // Map an address to an account
113     mapping (address => Account) internal accounts;
114 
115     /* ==== CONSTRUCTOR ==== */
116     constructor(address hourglassAddress, address dev1Address, address dev2Address) public {
117         // Set round 0 start time here
118         rounds[0].startTime = now + 7 days;
119         // Set hourglass interface
120         hourglass = HourglassInterface(hourglassAddress);
121         // Set dev1
122         dev1 = dev1Address;
123         // Set dev2
124         dev2 = dev2Address;
125     }
126     /* ==== PUBLIC WRITE ==== */
127 
128     // Ether sent directly to contract gets donated to the pot
129     function ()
130         external
131         payable
132     {
133         // Donate ETH sent directly to contract as long as the sender is not the hourglass contract
134         if (msg.sender != address(hourglass)) {
135             donateToPot();
136         }
137     }
138 
139     // Buy a ticket or tickets
140     function buy()
141         public
142         payable
143     {
144         // Current round or next round
145         (Round storage round, uint256 roundId) = getRoundInProgress();
146 
147         // Calculate number of tickets and any change
148         (uint256 tickets, uint256 change) = processTickets();
149 
150         // Send change to the round pot
151         round.pot = round.pot + change;
152 
153         // Allocate tickets to account
154         if (tickets > 0) {
155             // Give player their tickets
156             pushTicketSetToAccount(roundId, tickets);
157             // Increment tickets in the round
158             round.tickets = round.tickets + tickets;
159         }
160         // Broadcast an event when a ticket set is purchased
161         emit OnBuy(msg.sender, roundId, tickets, msg.value);
162     }
163 
164     // Support a good cause, invest in dividends
165     function donateToDivs()
166         public
167         payable
168     {
169         // Buys investment tokens from hourglass contract
170         hourglass.buy.value(msg.value)(msg.sender);
171     }
172 
173     // Support a good cause, donate to the round pot
174     function donateToPot()
175         public
176         payable
177     {
178         if (msg.value > 0) {
179             // Current round or next round
180             (Round storage round,) = getRoundInProgress();
181             round.pot = round.pot + msg.value;
182         }
183     }
184 
185     // Complete and Secure the round
186     function validate()
187         public
188     {
189         // Current Round
190         Round storage round = rounds[currentRoundId];
191 
192         // First check if round was already validated
193         require(round.random == 0);
194 
195         // Require minimum number of tickets to build a pyramid
196         require(round.tickets >= QUORUM);
197 
198         // Require cooldown between rounds
199         require(round.startTime + COOLDOWN <= now);
200 
201         // If blockcap is not set yet, cap the round
202         if (round.blockCap == 0) {
203             allocateToPot(round);
204             allocateFromPot(round);
205 
206             // Set blockcap
207             round.blockCap = block.number;
208             emit OnRoundCap(currentRoundId);
209         } else {
210             // Require a future block
211             require(block.number > round.blockCap);
212 
213             // Get blockhash from the blockcap block
214             uint32 blockhash_ = uint32(bytes4(blockhash(round.blockCap)));
215 
216             // Confirm blockhash has not expired on network
217             if (blockhash_ != 0) {
218                 closeTheRound(round, blockhash_);
219             } else {
220                 // Cap round again
221                 round.blockCap = block.number;
222                 emit OnRoundCap(currentRoundId);
223             }
224         }
225     }
226 
227     // Withdraw ticket winnings
228     function withdraw()
229         public
230     {
231         // Total amount to withdraw
232         uint256 total;
233         // Flag to check if account holds current or next round tickets
234         bool withholdRounds;
235         // Player account
236         Account storage account = accounts[msg.sender];
237         // Total number of rounds a player holds tickets
238         uint256 accountRoundsActiveLength = account.roundsActive.length;
239 
240         // Loop through each round the player holds tickets
241         for (uint256 i = 0; i < accountRoundsActiveLength; i++) {
242             uint256 roundId = account.roundsActive[i];
243 
244             // Only check if round was already validated
245             if (roundId < currentRoundId) {
246                 // Get amount won in the round
247                 (uint256 amount, uint256 totalTickets) = getRoundWinnings(msg.sender, roundId);
248 
249                 // Subtract tickets from account
250                 account.tickets = account.tickets - totalTickets;
251 
252                 // Delete round from player's account
253                 delete account.ticketSets[roundId];
254 
255                 // If the player won during the round
256                 if (amount > 0) {
257                     // Increment amount claimed
258                     rounds[roundId].claimed = rounds[roundId].claimed + amount;
259                     // Add to total withdraw
260                     total = total + amount;
261                 }
262             } else {
263                 // Flag to check if account holds current or next round tickets
264                 withholdRounds = true;
265             }
266         }
267 
268         // Delete processed rounds
269         sweepRoundsActive(withholdRounds);
270 
271         // Last but not least, send ticket winnings
272         if (total > 0) {
273             msg.sender.transfer(total);
274         }
275     }
276 
277     // Did you validate a round, claim your rewards here
278     function claimRewards()
279         public
280     {
281         // Total amount to withdraw
282         uint256 total;
283         // Player account
284         Account storage account = accounts[msg.sender];
285         // Total number of rounds with rewards
286         uint256 accountRewardsLength = account.rewards.length;
287 
288         // Loop through each round the player holds rewards
289         for (uint256 i = 0; i < accountRewardsLength; i++) {
290             // Round with a reward
291             uint256 roundId = account.rewards[i];
292             // Get reward amount won in the round
293             uint256 amount = getRewardWinnings(msg.sender, roundId);
294             // Delete reward from round
295             delete rounds[roundId].reward[msg.sender];
296 
297             // If player has rewards in the round
298             if (amount > 0) {
299                 // Increment amount claimed
300                 rounds[roundId].claimed = rounds[roundId].claimed + amount;
301                 // Add to total withdraw
302                 total = total + amount;
303             }
304         }
305 
306         // Delete processed rewards
307         delete accounts[msg.sender].rewards;
308 
309         // Transfer rewards to player
310         if (total > 0) {
311             msg.sender.transfer(total);
312         }
313     }
314 
315     /* ==== PUBLIC READ ==== */
316     // Get global game constants
317     function getConfig()
318         public
319         pure
320         returns(uint256 cooldown, uint256 cost, uint256 expiration, uint256 quorum, uint256 ticketMax)
321     {
322         return(COOLDOWN, COST, EXPIRATION, QUORUM, TICKET_MAX);
323     }
324 
325     // Get info for a given Round
326     function getRound(uint256 roundId)
327         public
328         view
329         returns(
330             uint256 balance, 
331             uint256 blockCap, 
332             uint256 claimed, 
333             uint256 pot, 
334             uint256 random, 
335             uint256 startTime, 
336             uint256 tickets)
337     {
338         Round storage round = rounds[roundId];
339 
340         return(round.balance, round.blockCap, round.claimed, round.pot, round.random, round.startTime, round.tickets);
341     }
342 
343     // Get total number of tickets held by account
344     function getTotalTickets(address accountAddress)
345         public
346         view
347         returns(uint256 tickets)
348     {
349         return accounts[accountAddress].tickets;
350     }
351 
352     // Get value of ticket held in each winning caste
353     function getRoundCasteValues(uint256 roundId)
354         public
355         view
356         returns(uint256 caste0, uint256 caste1, uint256 caste2)
357     {
358         return(rounds[roundId].caste[0], rounds[roundId].caste[1], rounds[roundId].caste[2]);
359     }
360 
361     // Get rounds account is active
362     function getRoundsActive(address accountAddress)
363         public
364         view
365         returns(uint256[] memory)
366     {
367         return accounts[accountAddress].roundsActive;
368     }
369 
370     // Get the rounds an account has unclaimed rewards
371     function getRewards(address accountAddress)
372         public
373         view
374         returns(uint256[] memory)
375     {
376         return accounts[accountAddress].rewards;
377     }
378 
379     // Get the total number of ticket sets an account holds for a given round
380     function getTotalTicketSetsForRound(address accountAddress, uint256 roundId)
381         public
382         view
383         returns(uint256 ticketSets)
384     {
385         return accounts[accountAddress].ticketSets[roundId].length;
386     }
387 
388     // Get an account's individual ticket set from a round
389     function getTicketSet(address accountAddress, uint256 roundId, uint256 index)
390         public
391         view
392         returns(uint256 start, uint256 end)
393     {
394         TicketSet storage ticketSet = accounts[accountAddress].ticketSets[roundId][index];
395 
396         // Starting ticket and ending ticket in set
397         return (ticketSet.start, ticketSet.end);
398     }
399 
400     // Get the value of a ticket
401     function getTicketValue(uint256 roundId, uint256 ticketIndex)
402         public
403         view
404         returns(uint256 ticketValue)
405     {
406         // Check if the round expired
407         if (currentRoundId > roundId && (currentRoundId - roundId) >= EXPIRATION) {
408             return 0;
409         }
410 
411         Round storage round = rounds[roundId];
412         // Set which tier the ticket is in
413         uint256 tier = getTier(roundId, ticketIndex);
414 
415         // Return ticket value based on tier
416         if (tier == 5) {
417             return 0;
418         } else if (tier == 4) {
419             return COST / 2;
420         } else if (tier == 3) {
421             return COST;
422         } else {
423             return round.caste[tier];
424         }
425     }
426 
427     // Get which tier a ticket is in
428     function getTier(uint256 roundId, uint256 ticketIndex)
429         public
430         view
431         returns(uint256 tier)
432     {
433         Round storage round = rounds[roundId];
434         // Distance from random index
435         uint256 distance = Math.distance(round.random, ticketIndex, round.tickets);
436         // Tier based on ticket index
437         uint256 ticketTier = Caste.tier(distance, round.tickets - 1);
438 
439         return ticketTier;
440     }
441 
442     // Get the amount won in a round
443     function getRoundWinnings(address accountAddress, uint256 roundId)
444         public
445         view
446         returns(uint256 totalWinnings, uint256 totalTickets)
447     {
448         // Player account
449         Account storage account = accounts[accountAddress];
450         // Ticket sets an account holds in a given round
451         TicketSet[] storage ticketSets = account.ticketSets[roundId];
452 
453         // Holds total winnings in a round
454         uint256 total;
455         // Total number of ticket sets
456         uint256 ticketSetLength = ticketSets.length;
457         // Holds total individual tickets in a round
458         uint256 totalTicketsInRound;
459 
460         // Check if round expired
461         if (currentRoundId > roundId && (currentRoundId - roundId) >= EXPIRATION) {
462             // Round expired
463             // Loop through each ticket set
464             for (uint256 i = 0; i < ticketSetLength; i++) {
465                 // Calculate the total number of tickets in a set
466                 uint256 totalTicketsInSet = (ticketSets[i].end - ticketSets[i].start) + 1;
467                 // Add the total number of tickets to the total number of tickets in the round
468                 totalTicketsInRound = totalTicketsInRound + totalTicketsInSet;
469             }
470 
471             // After looping through all of the tickets, return total winnings and total tickets in round
472             return (total, totalTicketsInRound);
473         }
474 
475         // If the round has not expired, Loop through each ticket set
476         for (uint256 i = 0; i < ticketSetLength; i++) {
477             // Subtract one to get true ticket index
478             uint256 startIndex = ticketSets[i].start - 1;
479             uint256 endIndex = ticketSets[i].end - 1;
480             // Loop through each ticket
481             for (uint256 j = startIndex; j <= endIndex; j++) {
482                 // Add the ticket value to total round winnings
483                 total = total + getTicketWinnings(roundId, j);
484             }
485             // Calculate the total number of tickets in a set
486             uint256 totalTicketsInSet = (ticketSets[i].end - ticketSets[i].start) + 1;
487             // Set the total number of tickets in a round
488             totalTicketsInRound = totalTicketsInRound + totalTicketsInSet;
489         }
490         // After looping through all of the tickets, return total winnings and total tickets in round
491         return (total, totalTicketsInRound);
492     }
493 
494     // Get the value of a reward in a round such as validator reward
495     function getRewardWinnings(address accountAddress, uint256 roundId)
496         public
497         view
498         returns(uint256 reward)
499     {
500         // Check if round expired
501         if (currentRoundId > roundId && (currentRoundId - roundId) >= EXPIRATION) {
502             // Reward expired
503             return 0;
504         }
505         // Reward did not expire
506         return rounds[roundId].reward[accountAddress];
507     }
508 
509     // Get dividends from hourglass contract
510     function getDividends()
511         public
512         view
513         returns(uint256 dividends)
514     {
515         return hourglass.dividendsOf(address(this));
516     }
517 
518     // Get total amount of tokens owned by contract
519     function getHourglassBalance()
520         public
521         view
522         returns(uint256 hourglassBalance)
523     {
524         return hourglass.balanceOf(address(this));
525     }
526 
527     /* ==== PRIVATE ==== */
528     // At the end of the round, distribute percentages from the pot
529     function allocateFromPot(Round storage round)
530         private
531     {
532         // 75% to winning Castes
533         (round.caste[0], round.caste[1], round.caste[2]) = Caste.values((round.tickets - 1), round.pot, COST);
534 
535         // 15% to next generation
536         rounds[currentRoundId + 1].pot = (round.pot * 15) / 100;
537 
538         // 2% to each dev
539         uint256 percent2 = (round.pot * 2) / 100;
540         round.reward[dev1] = percent2;
541         round.reward[dev2] = percent2;
542 
543         // Cleanup unclaimed dev rewards
544         if (accounts[dev1].rewards.length == TICKET_MAX) {
545             delete accounts[dev1].rewards;
546         }
547         if (accounts[dev2].rewards.length == TICKET_MAX) {
548             delete accounts[dev2].rewards;
549         }
550         // Store round with reward
551         accounts[dev1].rewards.push(currentRoundId);
552         accounts[dev2].rewards.push(currentRoundId);
553 
554         // 5% buys hourglass token
555         hourglass.buy.value((round.pot * 5) / 100)(msg.sender);
556 
557         // 20% of round pot claimed from 15% to next round and 5% investment in hourglass token
558         round.claimed = (round.pot * 20) / 100;
559     }
560 
561     // At the end of the round, allocate investment dividends and bottom tiers to the pot
562     function allocateToPot(Round storage round)
563         private
564     {
565         // Balance is seed pot combined with total tickets
566         round.balance = round.pot + (round.tickets * COST);
567 
568         // Bottom tiers to the pot
569         round.pot = round.pot + Caste.pool(round.tickets - 1, COST);
570 
571         // Check investment dividends accrued
572         uint256 dividends = getDividends();
573         // If there are dividends available
574         if (dividends > 0) {
575             // Withdraw dividends from hourglass contract
576             hourglass.withdraw();
577             // Allocate dividends to the round pot
578             round.pot = round.pot + dividends;
579         }
580     }
581 
582     // Close the round
583     function closeTheRound(Round storage round, uint32 blockhash_)
584         private
585     {
586         // Prevent devs from validating round since they already get a reward
587         require(round.reward[msg.sender] == 0);
588         // Reward the validator
589         round.reward[msg.sender] = round.pot / 100;
590         // If validator hits a limit without withdrawing their rewards
591         if (accounts[msg.sender].rewards.length == TICKET_MAX) {
592             delete accounts[msg.sender].rewards;
593         }
594 
595         // Store round id validator holds a reward
596         accounts[msg.sender].rewards.push(currentRoundId);
597 
598         // Set random number
599         round.random = Math.random(blockhash_, round.tickets);
600 
601         // Set current round id
602         currentRoundId = currentRoundId + 1;
603 
604         // New Round
605         Round storage newRound = rounds[currentRoundId];
606 
607         // Set next round start time
608         newRound.startTime = now;
609 
610         // Start expiring rounds at Round 5
611         if (currentRoundId >= EXPIRATION) {
612             // Set expired round
613             Round storage expired = rounds[currentRoundId - EXPIRATION];
614             // Check if expired round has a balance
615             if (expired.balance > expired.claimed) {
616                 // Allocate expired funds to next round
617                 newRound.pot = newRound.pot + (expired.balance - expired.claimed);
618             }
619         }
620 
621         // Broadcast a new round is starting
622         emit OnRoundStart(currentRoundId);
623     }
624 
625     // Get Current round or next round depending on whether blockcap is set
626     function getRoundInProgress()
627         private
628         view
629         returns(Round storage, uint256 roundId)
630     {
631         // Current Round if blockcap not set yet
632         if (rounds[currentRoundId].blockCap == 0) {
633             return (rounds[currentRoundId], currentRoundId);
634         }
635         // Next round if blockcap is set
636         return (rounds[currentRoundId + 1], currentRoundId + 1);
637     }
638 
639     // Get the value of an individual ticket in a given round
640     function getTicketWinnings(uint256 roundId, uint256 index)
641         private
642         view
643         returns(uint256 ticketValue)
644     {
645         Round storage round = rounds[roundId];
646         // Set which tier the ticket is in
647         uint256 tier = getTier(roundId, index);
648 
649         // Return ticket value based on tier
650         if (tier == 5) {
651             return 0;
652         } else if (tier == 4) {
653             return COST / 2;
654         } else if (tier == 3) {
655             return COST;
656         } else {
657             return round.caste[tier];
658         }
659     }
660 
661     // Calculate total tickets and remainder based on message value
662     function processTickets()
663         private
664         view
665         returns(uint256 totalTickets, uint256 totalRemainder)
666     {
667         // Calculate total tickets based on msg.value and ticket cost
668         uint256 tickets = Math.divide(msg.value, COST);
669         // Calculate remainder based on msg.value and ticket cost
670         uint256 remainder = Math.remainder(msg.value, COST);
671 
672         return (tickets, remainder);
673     }
674 
675     // Stores ticket set in player account
676     function pushTicketSetToAccount(uint256 roundId, uint256 tickets)
677         private
678     {
679         // Player account
680         Account storage account = accounts[msg.sender];
681         // Round to add tickets
682         Round storage round = rounds[roundId];
683 
684         // Store which rounds the player buys tickets in
685         if (account.ticketSets[roundId].length == 0) {
686             account.roundsActive.push(roundId);
687         }
688 
689         // Require existing tickets plus new tickets
690         // Is less than maximum allowable tickets an account can hold
691         require((account.tickets + tickets) < TICKET_MAX);
692         account.tickets = account.tickets + tickets;
693 
694         // Store ticket set
695         account.ticketSets[roundId].push(TicketSet(round.tickets + 1, round.tickets + tickets));
696     }
697 
698     // Delete unused state after withdrawing to lower gas cost for the player
699     function sweepRoundsActive(bool withholdRounds)
700         private
701     {
702         // Delete any rounds that are not current or next round
703         if (withholdRounds != true) {
704             // Remove active rounds from player account
705             delete accounts[msg.sender].roundsActive;
706         } else {
707             bool current;
708             bool next;
709             // Total number of active rounds
710             uint256 roundActiveLength = accounts[msg.sender].roundsActive.length;
711 
712             // Loop each round account was active
713             for (uint256 i = 0; i < roundActiveLength; i++) {
714                 uint256 roundId = accounts[msg.sender].roundsActive[i];
715 
716                 // Flag if account has tickets in current round
717                 if (roundId == currentRoundId) {
718                     current = true;
719                 }
720                 // Flag if account has tickets in next round
721                 if (roundId > currentRoundId) {
722                     next = true;
723                 }
724             }
725 
726             // Remove active rounds from player account
727             delete accounts[msg.sender].roundsActive;
728 
729             // Add back current round if player holds tickets in current round
730             if (current == true) {
731                 accounts[msg.sender].roundsActive.push(currentRoundId);
732             }
733             // Add back current round if player holds tickets in next round
734             if (next == true) {
735                 accounts[msg.sender].roundsActive.push(currentRoundId + 1);
736             }
737         }
738     }
739 }
740 
741 
742 /**
743  * @title Math
744  * @dev Math operations with safety checks that throw on error
745  */
746 library Math {
747     /**
748     * @dev Calculates a distance between start and finish wrapping around total
749     */
750     function distance(uint256 start, uint256 finish, uint256 total)
751         internal
752         pure
753         returns(uint256)
754     {
755         if (start < finish) {
756             return finish - start;
757         }
758         if (start > finish) {
759             return (total - start) + finish;
760         }
761         if (start == finish) {
762             return 0;
763         }
764     }
765 
766     /**
767     * @dev Calculates the quotient between the numerator and denominator.
768     */
769     function divide(uint256 numerator, uint256 denominator)
770         internal
771         pure
772         returns (uint256)
773     {
774         // EVM does not allow division by zero
775         return numerator / denominator;
776     }
777 
778     /**
779     * @dev Generate random number from blockhash
780     */
781     function random(uint32 blockhash_, uint256 max)
782         internal
783         pure
784         returns(uint256)
785     {
786         // encoded blockhash as uint256
787         uint256 encodedBlockhash = uint256(keccak256(abi.encodePacked(blockhash_)));
788         // random number from 0 to (max - 1)
789         return (encodedBlockhash % max);
790     }
791 
792     /**
793     * @dev Calculates the remainder between the numerator and denominator.
794     */
795     function remainder(uint256 numerator, uint256 denominator)
796         internal
797         pure
798         returns (uint256)
799     {
800         // EVM does not allow division by zero
801         return numerator % denominator;
802     }
803 }
804 
805 
806 /**
807  * @title Caste
808  * @dev Caste operations
809  */
810 library Caste {
811 
812     /**
813     * @dev Calculates amount of ether to transfer to the pot from the caste pool
814     * total is 1 less than total number of tickets to take 0 index into account
815     */
816     function pool(uint256 total, uint256 cost)
817         internal
818         pure
819         returns(uint256)
820     {
821         uint256 tier4 = ((total * 70) / 100) - ((total * 45) / 100);
822         uint256 tier5 = total - ((total * 70) / 100);
823 
824         return (tier5 * cost) + ((tier4 * cost) / 2);
825     }
826 
827     /**
828     * @dev Provides the tier based on an index and total in the caste pool
829     */
830     function tier(uint256 distance, uint256 total)
831         internal
832         pure
833         returns(uint256)
834     {
835         uint256 percent = (distance * (10**18)) / total;
836 
837         if (percent > 700000000000000000) {
838             return 5;
839         }
840         if (percent > 450000000000000000) {
841             return 4;
842         }
843         if (percent > 250000000000000000) {
844             return 3;
845         }
846         if (percent > 100000000000000000) {
847             return 2;
848         }
849         if (percent > 0) {
850             return 1;
851         }
852         if (distance == 0) {
853             return 0;
854         } else {
855             return 1;
856         }
857     }
858 
859     /**
860     * @dev Calculates value per winning caste
861     */
862     function values(uint256 total, uint256 pot, uint256 cost)
863         internal
864         pure
865         returns(uint256, uint256, uint256)
866     {
867         uint256 percent10 = (total * 10) / 100;
868         uint256 percent25 = (total * 25) / 100;
869         uint256 caste0 = (pot * 25) / 100;
870         uint256 caste1 = cost + (caste0 / percent10);
871         uint256 caste2 = cost + (caste0 / (percent25 - percent10));
872 
873         return (caste0 + cost, caste1, caste2);
874     }
875 }