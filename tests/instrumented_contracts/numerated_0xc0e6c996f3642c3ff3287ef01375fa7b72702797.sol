1 pragma solidity ^0.4.19;
2 
3 contract BitOpterations {
4             
5         // helper functions set
6         // to manipulate on bits 
7         // with different widht of allocator
8         
9         function set512(bytes32[2] storage allocator,uint16 pos,uint8 value) internal returns( bytes32[2] storage) {
10             
11             bytes32 valueBits = (bytes32)(value);
12         
13             uint8 posOffset = uint8(pos%255);
14         
15             bytes32 one = 1;
16             bytes32 clearBit = (bytes32)(~(one << posOffset));
17             
18             uint8 bytesIndex = pos>255?1:0;
19             
20             allocator[bytesIndex] = (allocator[bytesIndex] & clearBit) | (valueBits << posOffset);
21             
22             return allocator;
23             
24         }
25             
26         function get512(bytes32[2] allocator,uint16 pos) internal pure returns(uint8){
27             
28             uint8 posOffset = uint8(pos%255);
29             uint8 bytesIndex = pos>255?1:0;
30             
31             return (((allocator[bytesIndex] >> posOffset) & 1) == 1)?1:0;   
32         }    
33         
34         function clear512(bytes32[2] storage allocator) internal {
35             allocator[0] = 0x0;
36             allocator[1] = 0x0;
37         }
38         
39         function set32(bytes4 allocator,uint8 pos, uint8 value) internal pure returns(bytes4) {
40             
41             bytes4 valueBits = (bytes4)(value);
42         
43             bytes4 one = 1;
44             bytes4 clearBit = (bytes4)(~(one << pos));
45             allocator = (allocator & clearBit) | (valueBits << pos);
46             
47             return allocator;
48         }
49         
50         function get32(bytes4 allocator,uint8 pos) internal pure returns(uint8){
51            return (((allocator >> pos) & 1) == 1)?1:0;
52         }
53 }
54 
55 contract Random32BigInteger is BitOpterations {
56     
57     uint256[10] public randomBlockStart;
58     bytes4[10] private numberAllocator;
59     bool[10] internal generated;
60     
61     uint256 private generationNumber = 0;
62     
63     function generate(uint8 lotteryId) internal returns(bool) {
64         
65         // to eliminate problem of `same random numbers` lets add 
66         // some offset on each number generation
67         uint8 startOffset = uint8((generationNumber++) % 10); 
68         
69         if (randomBlockStart[lotteryId] == 0) {
70             // start random number generation from next block, 
71             // so we can't influence it 
72              randomBlockStart[lotteryId] = block.number + startOffset;
73         } else {
74             uint256 blockDiffNumber = block.number - randomBlockStart[lotteryId];
75             
76             // revert tx if we haven't enough blocks to calc rand int
77             require(blockDiffNumber >= 32);
78             
79             // its not possible to calc fair random number with start at randomBlockStart
80             // because part of blocks or all blocks are not visible from solidity anymore 
81             // start generation process one more time
82             if (blockDiffNumber > 256) {
83                 randomBlockStart[lotteryId] = block.number + startOffset;
84             } else {
85                 for (uint8 i = 0; i < 32; i++) {
86                     
87                     // get hash of appropriate block
88                     uint256 blockHash = uint256(block.blockhash(randomBlockStart[lotteryId]+i));
89                     
90                     // set appropriate bit in result number
91                     numberAllocator[lotteryId] = set32(numberAllocator[lotteryId],i,uint8(blockHash));
92                 }
93                 generated[lotteryId] = true;
94                 randomBlockStart[lotteryId] = 0;
95             }
96         }
97         return generated[lotteryId];
98     }
99     
100     function clearNumber(uint8 lotteryId) internal {
101         randomBlockStart[lotteryId] = 0;
102         generated[lotteryId] = false;
103     }
104     
105     function getNumberValue(uint8 lotteryId) internal constant returns(uint32) {
106         require(generated[lotteryId]);
107         return uint32(numberAllocator[lotteryId]);
108     }
109 }
110 
111 contract EthereumJackpot is Random32BigInteger {
112     
113     address private owner;
114     
115     event WinnerPicked(uint8 indexed roomId,address winner,uint16 number);
116     event TicketsBought(uint8 indexed roomId,address owner,uint16[] ticketNumbers);
117     event LostPayment(address dest,uint256 amount);
118     
119     struct Winner {
120         uint256 prize;
121         uint256 timestamp;
122         address addr;
123         
124         uint16 number;
125         uint8 percent;
126     }
127     
128     mapping (address => address) public affiliates;
129     
130     Winner[] private winners;
131     
132     uint32 public winnersCount;
133     
134     modifier ownerOnly {
135         require(msg.sender == owner);
136         _;
137     }
138     
139     uint8 public affiliatePercent = 1;
140     uint8 public maxPercentPerPlayer = 49;
141     uint8 public ownerComission = 20;
142     
143     // time on which lottery has started
144     uint256[10] public started;
145     
146     // last activity time on lottery
147     uint256[10] public lastTicketBought;
148     
149     // one ticket price
150     uint256[10] public ticketPrice;
151     
152     // max number of tickets in this lottery
153     uint16[10] public maxTickets;
154     
155     // time to live before refund can be requested
156     uint256[10] public lifetime;
157     
158     address[][10] ticketsAllocator;
159     
160     struct Player {
161         uint256 changedOn;
162         uint16 ticketsCount;
163     }
164     
165     mapping(address => Player)[10] private playerInfoMappings;
166     
167     bytes32[2][10] bitMaskForPlayFields;
168     
169     enum State {Uninitialized,Running,Paused,Finished,Refund}
170     
171     State[10] public state; 
172     
173     // flag that indicates request for pause of lottery[id]
174     bool[10] private requestPause; 
175     
176     // number of sold tickets 
177     uint16[10] public ticketsSold;
178     
179     // this function set flag to pause room on next clearState call (at the game start)
180     function pauseLottery(uint8 lotteryId) public ownerOnly {
181         requestPause[lotteryId] = true;
182     }
183     
184     function setOwner(address newOwner) public ownerOnly {
185         owner = newOwner;
186     }
187     
188     function getTickets(uint8 lotteryId) public view returns(uint8[]) {
189         uint8[] memory result = new uint8[](maxTickets[lotteryId]);
190         
191         for (uint16 i = 0; i < maxTickets[lotteryId]; i++) {
192             result[i] = get512(bitMaskForPlayFields[lotteryId],i);
193         }
194         return result;
195     }
196     
197     function setLotteryOptions(uint8 lotteryId,uint256 price,uint16 tickets,uint256 timeToRefund) public ownerOnly {
198         
199         require(lotteryId >= 0 && lotteryId < 10);
200         // only allow change of lottery opts when it's in pause state, unitialized or no tickets are sold there yet
201         require(state[lotteryId] == State.Paused || state[lotteryId] == State.Uninitialized || ticketsSold[lotteryId] == 0);
202         require(price > 0);
203         require(tickets > 0 && tickets <= 500);
204         require(timeToRefund >= 86400); // require at least one day to sell all tickets
205         
206         ticketPrice[lotteryId] = price;
207         maxTickets[lotteryId] = tickets;
208         lifetime[lotteryId] = timeToRefund;
209         
210         ticketsAllocator[lotteryId].length = tickets;
211         
212         clearState(lotteryId);
213     }
214     
215     // this methods clears the state 
216     // of current lottery
217     function clearState(uint8 lotteryId) private {
218         
219         if (!requestPause[lotteryId]) {
220             
221             // set state of lottery to `running`
222             state[lotteryId] = State.Running;
223             
224             // clear random number data
225             clearNumber(lotteryId);
226         
227             // set current timestamp as start time
228             started[lotteryId]  = block.timestamp;
229             
230             // clear time of last ticket bought
231             lastTicketBought[lotteryId] = 0;
232             
233             // clear number of sold tickets
234             ticketsSold[lotteryId] = 0;
235            
236             // remove previous tickets owner info
237             clear512(bitMaskForPlayFields[lotteryId]);
238             
239         } else {
240             // set state to `pause`
241             state[lotteryId] = State.Paused;
242             requestPause[lotteryId] = false;
243         }
244     }
245     function isInList(address element,address[] memory list) private pure returns (bool) {
246         for (uint16 i =0; i < list.length; i++) {
247             if (list[i] == element) {
248                 return true;
249             }
250         }
251         
252         return false;
253     }
254     function getPlayers(uint8 lotteryId) external view returns (uint16,address[],uint16[]) {
255         
256         if (ticketsSold[lotteryId] == 0) {
257             return;
258         }
259         
260         uint16 currentUser = 0;
261         address[] memory resultAddr = new address[](maxTickets[lotteryId]);
262         uint16[] memory resultCount = new uint16[](maxTickets[lotteryId]);
263         
264         for (uint16 t = 0; t < maxTickets[lotteryId]; t++) {
265             uint8 ticketBoughtHere = get512(bitMaskForPlayFields[lotteryId],t);
266             
267             if (ticketBoughtHere != 0) {
268                 
269                 address currentAddr = ticketsAllocator[lotteryId][t];
270                 
271                 if (!isInList(currentAddr,resultAddr)) {
272                 
273                     Player storage pInfo = playerInfoMappings[lotteryId][currentAddr];
274                     
275                     resultAddr[currentUser] = currentAddr;
276                     resultCount[currentUser] = pInfo.ticketsCount;
277                     ++currentUser;
278                 }
279             }
280         }
281         
282         return (currentUser,resultAddr,resultCount);
283     }
284     
285     // in case lottery tickets weren't sold due some time 
286     // anybody who bought a ticket can 
287     // ask to refund money (- comission to send them) 
288     // function refund(uint8 lotteryId) public {
289         
290     //     // refund state could be reached only from `running` state
291     //     require (state[lotteryId] == State.Running);
292     //     require (block.timestamp > (started[lotteryId] + lifetime[lotteryId]));
293     //     require (ticketsSold[lotteryId] < maxTickets[lotteryId]);
294         
295     //     // check if its a person which plays this lottery
296     //     // or it's a lottery owner
297         
298     //     require(msg.sender == owner  || playerInfoMappings[lotteryId][msg.sender].changedOn > started[lotteryId]);
299         
300     //     uint256 notSend = 0;
301         
302     //     // disallow re-entrancy
303     //     // refund process
304     //     state[lotteryId] = State.Refund; 
305         
306     //     for (uint16 i = 0; i < maxTickets[lotteryId]; i++) {
307             
308     //         address tOwner = ticketsAllocator[lotteryId][i];
309             
310     //         if (tOwner != address(0)) {
311     //             uint256 value = playerInfoMappings[lotteryId][tOwner].ticketsCount*ticketPrice[lotteryId];
312                     
313     //             bool sendResult = tOwner.send(value);
314     //             if (!sendResult) {
315     //                 LostPayment(tOwner,value);
316     //                 notSend += value;
317     //             }
318     //         }
319     //     }
320         
321     //     // send rest to owner if there any
322     //     if (notSend > 0) {
323     //         owner.send(notSend);
324     //     }
325         
326     //     // start new lottery 
327     //     clearState(lotteryId);
328     // }
329     
330     // this method determines current game winner
331     function getWinner(uint8 lotteryId) private view returns(uint16,address) {
332         
333         require(state[lotteryId] == State.Finished);
334       
335         // apply modulo operation 
336         // so any ticket number would be within 0 and totalTickets sold
337         uint16 winningTicket = uint16(getNumberValue(lotteryId)) % maxTickets[lotteryId];
338         
339         return (winningTicket,ticketsAllocator[lotteryId][winningTicket]);
340     }
341     
342     // this method is used to finalize Lottery
343     // it generates random number and sends prize
344     // it uses 32 blocks to generate pseudo random 
345     // value to determine winner of lottery
346     function finalizeRoom(uint8 lotteryId) public {
347         
348         // here we check for re-entrancy
349         require(state[lotteryId] == State.Running);
350         
351         // only if all tickets are sold
352         if (ticketsSold[lotteryId] == maxTickets[lotteryId]) {
353             
354             // if rand number is not yet generated
355             if (generate(lotteryId)) {
356                 
357                 // rand number is generated
358                 // set flag to allow getting winner
359                 // disable re-entrancy
360                 state[lotteryId] = State.Finished;
361                 
362                 var (winNumber, winner) = getWinner(lotteryId);
363                 
364                 uint256 prizeTotal = ticketsSold[lotteryId]*ticketPrice[lotteryId];
365                 
366                 // at start, owner commision value equals to the approproate percent of the jackpot
367                 uint256 ownerComValue = ((prizeTotal*ownerComission)/100);
368                 
369                 // winner prize equals total jackpot sum - owner commision value in any case
370                 uint256 prize = prizeTotal - ownerComValue;
371                 
372                 address affiliate = affiliates[winner];
373                 if (affiliate != address(0)) {
374                     uint256 affiliatePrize = (prizeTotal*affiliatePercent)/100;
375                     
376                     bool afPResult = affiliate.send(affiliatePrize);
377                     
378                     if (!afPResult) {
379                         LostPayment(affiliate,affiliatePrize);
380                     } else {
381                         // minus affiliate prize and "gas price" for that tx from owners com value
382                         ownerComValue -= affiliatePrize;
383                     }
384                 }
385                 
386                 // pay prize
387                 
388                 bool prizeSendResult = winner.send(prize);
389                 if (!prizeSendResult) {
390                     LostPayment(winner,prize);
391                     ownerComValue += prize;
392                 }
393                 
394                 // put winner to winners
395                 uint8 winPercent = uint8(((playerInfoMappings[lotteryId][winner].ticketsCount*100)/maxTickets[lotteryId]));
396                 
397                 addWinner(prize,winner,winNumber,winPercent);
398                 WinnerPicked(lotteryId,winner,winNumber);
399                 
400                 // send owner commision
401                 owner.send(ownerComValue);
402                 
403                 clearState(lotteryId);
404             }
405         }
406     }
407          
408     function buyTicket(uint8 lotteryId,uint16[] tickets,address referer) payable public {
409         
410         // we're actually in `running` state
411         require(state[lotteryId] == State.Running);
412         
413         // not all tickets are sold yet
414         require(maxTickets[lotteryId] > ticketsSold[lotteryId]);
415         
416         if (referer != address(0)) {
417             setReferer(referer);
418         }
419         
420         uint16 ticketsToBuy = uint16(tickets.length);
421         
422         // check payment for ticket
423         uint256 valueRequired = ticketsToBuy*ticketPrice[lotteryId];
424         require(valueRequired <= msg.value);
425         
426         // soft check if player want to buy free tickets
427         require((maxTickets[lotteryId] - ticketsSold[lotteryId]) >= ticketsToBuy); 
428         
429         Player storage pInfo = playerInfoMappings[lotteryId][msg.sender];
430         if (pInfo.changedOn < started[lotteryId]) {
431             pInfo.changedOn = block.timestamp;
432             pInfo.ticketsCount = 0;
433         }
434         
435         // check percentage of user's tickets
436         require ((pInfo.ticketsCount+ticketsToBuy) <= ((maxTickets[lotteryId]*maxPercentPerPlayer)/100));
437         
438         for (uint16 i; i < ticketsToBuy; i++) {
439             
440             require((tickets[i] - 1) >= 0);
441             
442             // if the ticket is taken you would get your ethers back
443             require (get512(bitMaskForPlayFields[lotteryId],tickets[i]-1) == 0);
444             set512(bitMaskForPlayFields[lotteryId],tickets[i]-1,1);
445             ticketsAllocator[lotteryId][tickets[i]-1] = msg.sender;
446         }
447             
448         pInfo.ticketsCount += ticketsToBuy;
449 
450         // set last time of buy
451         lastTicketBought[lotteryId] = block.timestamp;
452         
453         // set new amount of tickets
454         ticketsSold[lotteryId] +=  ticketsToBuy;
455         
456         // start process of random number generation if last ticket was sold 
457         if (ticketsSold[lotteryId] == maxTickets[lotteryId]) {
458             finalizeRoom(lotteryId);
459         }
460         
461         // fire event
462         TicketsBought(lotteryId,msg.sender,tickets);
463     }
464     
465     function roomNeedsFinalization(uint8 lotteryId) internal view  returns (bool){
466           return (state[lotteryId] == State.Running && (ticketsSold[lotteryId] >= maxTickets[lotteryId]) && ((randomBlockStart[lotteryId] == 0) || ((randomBlockStart[lotteryId] > 0) && (block.number - randomBlockStart[lotteryId]) >= 32)));
467     }
468     
469     function EthereumJackpot(address ownerAddress) public {
470         
471         require(ownerAddress != address(0));
472             
473         owner = ownerAddress;
474         
475         winners.length = 5;
476         winnersCount = 0;
477         
478     }
479     
480     function addWinner(uint256 prize,address winner,uint16 number,uint8 percent) private {
481         
482         // check winners size  and resize it if needed
483         if (winners.length == winnersCount) {
484             winners.length += 10;
485         }
486         
487         winners[winnersCount++] =  Winner(prize,block.timestamp,winner,number,percent);
488     }
489     
490     function setReferer(address a) private {
491         if (a != msg.sender) {
492             address addr = affiliates[msg.sender];
493             if (addr == address(0)) {
494                 affiliates[msg.sender] = a;
495             }
496         }
497     }
498     
499     // // returns only x last winners to prevent stack overflow of vm
500     function getWinners(uint256 page) public view returns(uint256[],address[],uint256[],uint16[],uint8[]) {
501         
502         int256 start = winnersCount - int256(10*(page+1));
503         int256 end = start+10;
504         
505         if (start < 0) {
506             start = 0;
507         }
508         
509         if (end <= 0) {
510             return;
511         }
512          
513         address[] memory addr = new address[](uint256(end- start));
514         uint256[] memory sum = new uint256[](uint256(end- start));
515         uint256[] memory time = new uint256[](uint256(end- start));
516         uint16[] memory number = new uint16[](uint256(end- start));
517         uint8[] memory percent = new uint8[](uint256(end- start));
518         
519         for (uint256 i = uint256(start); i < uint256(end); i++) {
520             
521             Winner storage winner = winners[i];
522             addr[i - uint256(start)] = winner.addr;
523             sum[i - uint256(start)] = winner.prize;
524             time[i - uint256(start)] = winner.timestamp;
525             number[i - uint256(start)] = winner.number;
526             percent[i - uint256(start)] = winner.percent;
527         }
528         
529         return (sum,addr,time,number,percent);
530     }
531     
532     
533     function getRomms() public view returns(bool[] active,uint256[] price,uint16[] tickets,uint16[] ticketsBought,uint256[] prize,uint256[] lastActivity,uint8[] comission) {
534         
535         uint8 roomsCount = 10;
536         
537         price = new uint256[](roomsCount);
538         tickets = new uint16[](roomsCount);
539         lastActivity = new uint256[](roomsCount);
540         prize = new uint256[](roomsCount);
541         comission = new uint8[](roomsCount);
542         active = new bool[](roomsCount);
543         ticketsBought = new uint16[](roomsCount);
544         
545         for (uint8 i = 0; i < roomsCount; i++) {
546             price[i] = ticketPrice[i];
547             ticketsBought[i] = ticketsSold[i];
548             tickets[i] = maxTickets[i];
549             prize[i] = maxTickets[i]*ticketPrice[i];
550             lastActivity[i]  = lastTicketBought[i];
551             comission[i] = ownerComission;
552             active[i] = state[i] != State.Paused && state[i] != State.Uninitialized;
553         }
554         
555         return (active,price,tickets,ticketsBought,prize,lastActivity,comission);
556     }
557     
558     // this function allows to destroy current contract in case all rooms are paused or not used
559     function destroy() public ownerOnly {
560         
561         for (uint8 i = 0; i < 10; i++) {
562             // paused or uninitialized 
563             require(state[i] == State.Paused || state[i] == State.Uninitialized);
564         }
565         
566         selfdestruct(owner);
567     }
568     
569     // finalize methods
570     function needsFinalization() public view returns(bool) {
571         for (uint8 i = 0; i < 10; i++) {
572             if (roomNeedsFinalization(i)) {
573                 return true;
574             }
575         }
576         return false;
577     }
578     
579     function finalize() public {
580         for (uint8 i = 0; i < 10; i++) {
581             if (roomNeedsFinalization(i)) {
582                 finalizeRoom(i);
583             }
584         }
585         
586     }
587 }