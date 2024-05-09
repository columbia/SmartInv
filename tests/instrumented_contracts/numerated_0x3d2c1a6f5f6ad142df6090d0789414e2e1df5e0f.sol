1 pragma solidity ^0.4.24;
2 // pragma experimental ABIEncoderV2;
3 
4 interface CitizenInterface {
5     function addEarlyIncome(address _sender) external payable;
6     function pushTicketRefIncome(address _sender) external payable;
7     function addTicketEthSpend(address _citizen, uint256 _value) external payable;
8     function addWinIncome(address _citizen, uint256 _value) external;
9     function pushEarlyIncome() external payable;
10     function getRef(address _address) external view returns(address);
11     function isCitizen(address _address) external view returns(bool);
12 }
13 
14 interface DAAInterface {
15     function pushDividend() external payable;
16 }
17 
18 library SafeMath {
19     int256 constant private INT256_MIN = -2**255;
20 
21     /**
22     * @dev Multiplies two unsigned integers, reverts on overflow.
23     */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b);
34 
35         return c;
36     }
37 
38     /**
39     * @dev Multiplies two signed integers, reverts on overflow.
40     */
41     function mul(int256 a, int256 b) internal pure returns (int256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
50 
51         int256 c = a * b;
52         require(c / a == b);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59     */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0);
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
71     */
72     function div(int256 a, int256 b) internal pure returns (int256) {
73         require(b != 0); // Solidity only automatically asserts when dividing by 0
74         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
75 
76         int256 c = a / b;
77 
78         return c;
79     }
80 
81     /**
82     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
83     */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b <= a);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92     * @dev Subtracts two signed integers, reverts on overflow.
93     */
94     function sub(int256 a, int256 b) internal pure returns (int256) {
95         int256 c = a - b;
96         require((b >= 0 && c <= a) || (b < 0 && c > a));
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two unsigned integers, reverts on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a);
107 
108         return c;
109     }
110 
111     /**
112     * @dev Adds two signed integers, reverts on overflow.
113     */
114     function add(int256 a, int256 b) internal pure returns (int256) {
115         int256 c = a + b;
116         require((b >= 0 && c >= a) || (b < 0 && c < a));
117 
118         return c;
119     }
120 
121     /**
122     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
123     * reverts when dividing by zero.
124     */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b != 0);
127         return a % b;
128     }
129 }
130 
131 
132 library Helper {
133     using SafeMath for uint256;
134     
135         
136     function bytes32ToUint(bytes32 n) 
137         public
138         pure
139         returns (uint256) 
140     {
141         return uint256(n);
142     }
143     
144     function stringToBytes32(string memory source) 
145         public
146         pure
147         returns (bytes32 result) 
148     {
149         bytes memory tempEmptyStringTest = bytes(source);
150         if (tempEmptyStringTest.length == 0) {
151             return 0x0;
152         }
153 
154         assembly {
155             result := mload(add(source, 32))
156         }
157     }
158     
159     function stringToUint(string memory source) 
160         public
161         pure
162         returns (uint256)
163     {
164         return bytes32ToUint(stringToBytes32(source));
165     }
166     
167     function validUsername(string _username)
168         public
169         pure
170         returns(bool)
171     {
172         uint256 len = bytes(_username).length;
173         // Im Raum [4, 18]
174         if ((len < 4) || (len > 18)) return false;
175         // Letzte Char != ' '
176         if (bytes(_username)[len-1] == 32) return false;
177         // Erste Char != '0'
178         return uint256(bytes(_username)[0]) != 48;
179     }   
180     
181     function getRandom(uint256 _seed, uint256 _range)
182         public
183         pure
184         returns(uint256)
185     {
186         if (_range == 0) return _seed;
187         return (_seed % _range) + 1;
188     }
189 
190 }
191 
192 contract Ticket {
193     using SafeMath for uint256;
194     
195     modifier buyable() {
196         require(block.timestamp > round[currentRound].startRound, "Not start, back later please");
197         require(block.timestamp < round[currentRound].endRoundByClock1&&(round[currentRound].endRoundByClock2==0 ||block.timestamp < round[currentRound].endRoundByClock2), "round over");
198         _;
199     }
200     
201     modifier onlyAdmin() {
202         require(msg.sender == devTeam1, "admin required");
203         _;
204     }
205     
206     modifier registered(){
207         require(citizenContract.isCitizen(msg.sender), "must be a citizen");
208         _;
209     }
210         
211     modifier onlyCoreContract() {
212         require(isCoreContract[msg.sender], "admin required");
213         _;
214     }
215     
216     event BuyATicket(
217         address indexed buyer,
218         uint256 ticketFrom,
219         uint256 ticketTo,
220         uint256 creationDate
221     );
222 
223     address devTeam1;
224     address devTeam2;
225     address devTeam3;
226     address devTeam4;
227     
228     uint256 TICKET_PRICE = 2*10**15; // 3 demical 0.002
229     
230     uint256 constant public ZOOM = 1000;
231     uint256 constant public PBASE = 24;
232     uint256 constant public RDIVIDER = 50000;
233     uint256 constant public PMULTI = 48;
234     
235     // percent
236     uint256 constant public EARLY_PERCENT = 20;
237     uint256 constant public EARLY_PERCENT_FOR_CURRENT = 70;
238     uint256 constant public EARLY_PERCENT_FOR_PREVIOUS = 30;
239     uint256 constant public REVENUE_PERCENT = 17;
240     uint256 constant public DEV_PERCENT = 3;
241     uint256 constant public DIVIDEND_PERCENT = 10;
242     uint256 constant public REWARD_PERCENT = 50;
243     
244     //  reward part
245     uint256 constant public LAST_BUY_PERCENT = 20;
246     uint8[6] public JACKPOT_PERCENT = [uint8(25),5,5,5,5,5];
247     uint256 constant public MOST_SPENDER_PERCENT = 5;
248     uint256 constant public MOST_F1_EARNED_PERCENT = 4;
249     uint8[5] public DRAW_PERCENT = [uint8(6),1,1,1,1]; // 3 demicel 0.2%
250     uint256 constant public NEXTROUND_PERCENT = 20;
251     
252     uint256 constant public F1_LIMIT = 1 ether;
253     
254     // clock
255     uint8 constant public MULTI_TICKET = 3;
256     uint256 constant public LIMMIT_CLOCK_2_ETH = 300 ether;
257     uint256 constant public ONE_MIN = 60;
258     uint256 constant public ONE_HOUR = 3600; 
259     uint256 constant public ONE_DAY = 24 * ONE_HOUR;
260     
261     // contract
262     CitizenInterface public citizenContract;
263     DAAInterface public DAAContract;
264     mapping (address => bool) public isCoreContract;
265     uint256 public coreContractSum;
266     address[] public coreContracts;
267     
268     struct Round {
269         uint256 priviousTicketSum;
270         uint256 ticketSum;
271         uint256 totalEth;
272         uint256 totalEthRoundSpend;
273 
274         address[] participant;
275         mapping(address => uint256) participantTicketAmount;
276         mapping(address => uint256) citizenTicketSpend;
277         mapping(address => uint256) RefF1Sum;
278         mapping(uint256 => Slot) ticketSlot; // from 1
279         uint256 ticketSlotSum;              // last
280         mapping( address => uint256[]) pSlot;
281         
282         uint256 earlyIncomeMarkSum;
283         mapping(address => uint256) earlyIncomeMark;
284         
285         uint256 startRound;
286         uint256 endRoundByClock1;
287         uint256 endRoundByClock2;
288         uint256 endRound;
289         uint8 numberClaimed;
290         
291         
292         bool is_running_clock2;
293     }
294     uint256 public totalEthSpendTicket;
295     uint256 public ticketSum;
296     mapping(address => uint256) public ticketSumByAddress;
297     mapping(uint256=> Round) public round;
298     uint256 public currentRound=0;
299     mapping(address => uint256) earlyIncomeRoundPulled;
300     address[4] mostSpender;
301     address[4] mostF1Earnerd;
302     mapping(address => uint256) mostF1EarnerdId;
303     mapping(address => uint256) mostSpenderId;
304     mapping(uint256 => address[])  roundWinner;
305         
306     struct Slot {
307         address buyer;
308         uint256 ticketFrom;
309         uint256 ticketTo;
310     }
311     
312     
313 
314     constructor (address[4] _devTeam)
315         public
316     {
317         devTeam1 = _devTeam[0]; 
318         devTeam2 = _devTeam[1]; 
319         devTeam3 = _devTeam[2]; 
320         devTeam4 = _devTeam[3]; 
321         currentRound=0;
322         round[currentRound].startRound = 1560693600;
323         round[currentRound].endRoundByClock1 = round[currentRound].startRound.add(48*ONE_HOUR);
324         round[currentRound].endRound = round[currentRound].endRoundByClock1;
325     }
326     
327        // DAAContract, TicketContract, CitizenContract 
328     function joinNetwork(address[3] _contract)
329         public
330     {
331         require(address(citizenContract) == 0x0,"already setup");
332         citizenContract = CitizenInterface(_contract[2]);
333         DAAContract = DAAInterface(_contract[0]);
334         for(uint256 i =0; i<3; i++){
335             isCoreContract[_contract[i]]=true;
336             coreContracts.push(_contract[i]);
337         }
338         coreContractSum = 3;
339     }
340     
341     function addCoreContract(address _address) public  // [dev1]
342         onlyAdmin()
343     {
344         require(_address!=0x0,"Invalid address");
345         isCoreContract[_address] = true;
346         coreContracts.push(_address);
347         coreContractSum+=1;
348     }
349     
350     function getRestHour() private view returns(uint256){
351         uint256 tempCurrentRound;
352         if (now>round[currentRound].startRound){
353             tempCurrentRound=currentRound;
354         }
355         else{
356             tempCurrentRound=currentRound-1;
357         }
358         if (now>round[tempCurrentRound].endRound) return 0;
359         return round[tempCurrentRound].endRound.sub(now);
360     }
361     
362     function getRestHourClock2() private view returns(uint256){
363         if (round[currentRound].is_running_clock2){
364             if ((round[currentRound].endRoundByClock2.sub(now)).div(ONE_HOUR)>0){
365                 return (round[currentRound].endRoundByClock2.sub(now)).div(ONE_HOUR);
366             }
367             return 0;
368         }
369         return 48;
370     }
371     
372     function getTicketPrice() public view returns(uint256){
373         if (round[currentRound].is_running_clock2){
374             return TICKET_PRICE + TICKET_PRICE*(50-getRestHourClock2())*4/100;
375         }
376         return TICKET_PRICE;
377     }
378     
379     function softMostF1(address _ref) private {
380         uint256 citizen_spender = round[currentRound].RefF1Sum[_ref];
381         uint256 i=1;
382         while (i<4) {
383             if (mostF1Earnerd[i]==0x0||(mostF1Earnerd[i]!=0x0&&round[currentRound].RefF1Sum[mostF1Earnerd[i]]<citizen_spender)){
384                 if (mostF1EarnerdId[_ref]!=0&&mostF1EarnerdId[_ref]<i){
385                     break;
386                 }
387                 if (mostF1EarnerdId[_ref]!=0){
388                     mostF1Earnerd[mostF1EarnerdId[_ref]]=0x0;
389                 }
390                 address temp1 = mostF1Earnerd[i];
391                 address temp2;
392                 uint256 j=i+1;
393                 while (j<4&&temp1!=0x0){
394                     temp2 = mostF1Earnerd[j];
395                     mostF1Earnerd[j]=temp1;
396                     mostF1EarnerdId[temp1]=j;
397                     temp1 = temp2;
398                     j++;
399                 }
400                 mostF1Earnerd[i]=_ref;
401                 mostF1EarnerdId[_ref]=i;
402                 break;
403             }
404             i++;
405         }
406     } 
407     
408 
409     function softMostSpender(address _ref) private {
410         uint256 citizen_spender = round[currentRound].citizenTicketSpend[_ref];
411         uint256 i=1;
412         while (i<4) {
413             if (mostSpender[i]==0x0||(mostSpender[i]!=0x0&&round[currentRound].citizenTicketSpend[mostSpender[i]]<citizen_spender)){
414                 if (mostSpenderId[_ref]!=0&&mostSpenderId[_ref]<i){
415                     break;
416                 }
417                 if (mostSpenderId[_ref]!=0){
418                     mostSpender[mostSpenderId[_ref]]=0x0;
419                 }
420                 address temp1 = mostSpender[i];
421                 address temp2;
422                 uint256 j=i+1;
423                 while (j<4&&temp1!=0x0){
424                     temp2 = mostSpender[j];
425                     mostSpender[j]=temp1;
426                     mostSpenderId[temp1]=j;
427                     temp1 = temp2;
428                     j++;
429                 }
430                 mostSpender[i]=_ref;
431                 mostSpenderId[_ref]=i;
432                 break;
433             }
434             i++;
435         }
436     } 
437     
438     function addTicketEthSpend(address _sender,uint256 _value) private{
439         citizenContract.addTicketEthSpend(_sender,_value);
440         
441         address refAdress = citizenContract.getRef(_sender);
442         if (refAdress != devTeam3 && round[currentRound].citizenTicketSpend[_sender]<F1_LIMIT){ // devTeam3 cannot receiver this arward.
443             uint256 valueFromF1;
444             
445             //  limmit at 1 ether
446             if (round[currentRound].citizenTicketSpend[_sender].add(_value)>F1_LIMIT){
447                 uint256 temp = round[currentRound].citizenTicketSpend[_sender].add(_value).sub(F1_LIMIT);
448                 valueFromF1 = _value.sub(temp);
449             } else {
450                 valueFromF1 = _value;
451             }
452             
453             // sum f1 deposit
454             round[currentRound].RefF1Sum[refAdress] = round[currentRound].RefF1Sum[refAdress].add(valueFromF1);
455             
456             //  find max mostF1Earnerd
457             softMostF1(refAdress);
458             
459         }
460         
461         round[currentRound].citizenTicketSpend[_sender] = round[currentRound].citizenTicketSpend[_sender].add(_value);
462         
463         // find max mostSpender
464         softMostSpender(_sender);
465         
466         // calculate total
467         totalEthSpendTicket = totalEthSpendTicket.add(_value);
468     }
469     
470     
471     function isAddressTicket(uint256 _round,uint256 _slot, uint256 _ticket) private view returns(bool){
472         Slot storage temp = round[_round].ticketSlot[_slot];
473         if (temp.ticketFrom<=_ticket&&_ticket<=temp.ticketTo) return true;
474         return false;
475     }
476     
477     function getAddressTicket(uint256 _round, uint256 _ticket) public view returns(address){
478         uint256 _from = 0;
479         uint256 _to = round[_round].ticketSlotSum;
480         uint256 _mid;
481         
482         while(_from<=_to){
483             _mid = (_from+_to).div(2);
484             if (isAddressTicket(_round,_mid,_ticket)) return round[_round].ticketSlot[_mid].buyer;
485             if (_ticket<round[_round].ticketSlot[_mid].ticketFrom){
486                 _to = _mid-1;
487             }
488             else {
489                 _from = _mid+1;
490             }
491         }
492         
493         // if errors
494         return round[_round].ticketSlot[_mid].buyer;
495     }
496     
497     function drawWinner() public registered() {
498         // require(round[currentRound].participantTicketAmount[msg.sender] > 0, "must buy at least 1 ticket");
499         require(round[currentRound].endRound.add(ONE_MIN)<now);
500         
501         // address lastbuy = getAddressTicket(currentRound, round[currentRound].ticketSum-1);
502         address lastbuy = round[currentRound].ticketSlot[round[currentRound].ticketSlotSum].buyer;
503         roundWinner[currentRound].push(lastbuy);
504         uint256 arward_last_buy = round[currentRound].totalEth*LAST_BUY_PERCENT/100;
505         lastbuy.transfer(arward_last_buy);
506         citizenContract.addWinIncome(lastbuy,arward_last_buy);
507         
508         mostSpender[1].transfer(round[currentRound].totalEth*MOST_SPENDER_PERCENT/100);
509         citizenContract.addWinIncome(mostSpender[1],round[currentRound].totalEth*MOST_SPENDER_PERCENT/100);
510         mostF1Earnerd[1].transfer(round[currentRound].totalEth*MOST_F1_EARNED_PERCENT/100);
511         citizenContract.addWinIncome(mostF1Earnerd[1],round[currentRound].totalEth*MOST_F1_EARNED_PERCENT/100);
512         roundWinner[currentRound].push(mostSpender[1]);
513         roundWinner[currentRound].push(mostF1Earnerd[1]);
514         
515         uint256 _seed = getSeed();
516         for (uint256 i = 0; i < 6; i++){
517             uint256 winNumber = Helper.getRandom(_seed, round[currentRound].ticketSum);
518             if (winNumber==0) winNumber= round[currentRound].ticketSum;
519             address winCitizen = getAddressTicket(currentRound,winNumber);
520             winCitizen.transfer(round[currentRound].totalEth.mul(JACKPOT_PERCENT[i]).div(100));
521             citizenContract.addWinIncome(winCitizen,round[currentRound].totalEth.mul(JACKPOT_PERCENT[i]).div(100));
522             roundWinner[currentRound].push(winCitizen);
523             _seed = _seed + (_seed / 10);
524         }
525         
526         
527         uint256 totalEthLastRound = round[currentRound].totalEth*NEXTROUND_PERCENT/100;
528         // Next Round
529         delete mostSpender;
530         delete mostF1Earnerd;
531         currentRound = currentRound+1;
532         round[currentRound].startRound = now.add(12*ONE_HOUR);
533         round[currentRound].totalEth = totalEthLastRound;
534         round[currentRound].endRoundByClock1 = now.add(60*ONE_HOUR); //12+48
535         round[currentRound].endRound = round[currentRound].endRoundByClock1;
536         claim();
537     }
538     
539     function claim() public registered() {
540         // require drawed winner
541         require(currentRound>0&&round[currentRound].ticketSum==0);
542         uint256 lastRound = currentRound-1;
543         // require 5 citizen can draw
544         require(round[lastRound].numberClaimed<5);
545         // require time;
546         require(round[lastRound].endRound.add(ONE_MIN)<now);
547         address _sender = msg.sender;
548         roundWinner[lastRound].push(_sender);
549         uint256 numberClaimed = round[lastRound].numberClaimed;
550         uint256 _arward = round[currentRound-1].totalEth*DRAW_PERCENT[numberClaimed]/1000;
551         _sender.transfer(_arward);
552         citizenContract.addWinIncome(_sender,_arward);
553         round[lastRound].numberClaimed = round[lastRound].numberClaimed+1;
554         round[lastRound].endRound = now.add(5*ONE_MIN);
555     }
556     
557     function getEarlyIncomeMark(uint256 _ticketSum) public pure returns(uint256){
558         uint256 base = _ticketSum * ZOOM / RDIVIDER;
559         uint256 expo = base.mul(base).mul(base); //^3
560         expo = expo.mul(expo).mul(PMULTI); 
561         expo =  expo.div(ZOOM**5);
562         return (1 + PBASE*ZOOM / (1*ZOOM + expo));
563     }
564 
565     function buyTicket(uint256 _quantity) payable public registered() buyable() returns(bool) {
566         uint256 ethDeposit = msg.value;
567         address _sender = msg.sender;
568         require(_quantity*getTicketPrice()==ethDeposit,"Not enough eth for current quantity");
569         
570         // after one day sale  | extra time
571         if (now>=round[currentRound].startRound.add(ONE_DAY)){
572             uint256 extraTime = _quantity.mul(30);
573             if (round[currentRound].endRoundByClock1.add(extraTime)>now.add(ONE_DAY)){
574                 round[currentRound].endRoundByClock1 = now.add(ONE_DAY);
575             } else {
576                 round[currentRound].endRoundByClock1 = round[currentRound].endRoundByClock1.add(extraTime);
577             }
578         }
579         
580         // F1, most spender
581         addTicketEthSpend(_sender, ethDeposit);
582         
583         
584         if (round[currentRound].participantTicketAmount[_sender]==0){
585             round[currentRound].participant.push(_sender);
586         }
587         // //  Occupied Slot
588         if(round[currentRound].is_running_clock2){
589             _quantity=_quantity.mul(MULTI_TICKET);
590         }
591         
592         uint256 ticketSlotSumTemp = round[currentRound].ticketSlotSum.add(1);
593         round[currentRound].ticketSlotSum = ticketSlotSumTemp;
594         round[currentRound].ticketSlot[ticketSlotSumTemp].buyer = _sender;
595         round[currentRound].ticketSlot[ticketSlotSumTemp].ticketFrom = round[currentRound].ticketSum+1;
596         
597         // 20% Early Income Mark
598         uint256 earlyIncomeMark = getEarlyIncomeMark(round[currentRound].ticketSum);
599         earlyIncomeMark = earlyIncomeMark.mul(_quantity);
600         round[currentRound].earlyIncomeMarkSum = earlyIncomeMark.add(round[currentRound].earlyIncomeMarkSum);
601         round[currentRound].earlyIncomeMark[_sender] = earlyIncomeMark.add(round[currentRound].earlyIncomeMark[_sender]);
602         
603         round[currentRound].ticketSum = round[currentRound].ticketSum.add(_quantity);
604         ticketSum = ticketSum.add(_quantity);
605         ticketSumByAddress[_sender] = ticketSumByAddress[_sender].add(_quantity);
606         round[currentRound].ticketSlot[ticketSlotSumTemp].ticketTo = round[currentRound].ticketSum;
607         round[currentRound].participantTicketAmount[_sender] = round[currentRound].participantTicketAmount[_sender].add(_quantity);
608         round[currentRound].pSlot[_sender].push(ticketSlotSumTemp);
609         emit BuyATicket(_sender, round[currentRound].ticketSlot[ticketSlotSumTemp].ticketFrom, round[currentRound].ticketSlot[ticketSlotSumTemp].ticketTo, now);
610             
611         // 20% EarlyIncome
612         uint256 earlyIncome=  ethDeposit*EARLY_PERCENT/100;
613         citizenContract.pushEarlyIncome.value(earlyIncome)();
614         
615         // 17% Revenue
616         uint256 revenue =  ethDeposit*REVENUE_PERCENT/100;
617         citizenContract.pushTicketRefIncome.value(revenue)(_sender);
618         
619         // 10% Devidend
620         uint256 devidend =  ethDeposit*DIVIDEND_PERCENT/100;
621         DAAContract.pushDividend.value(devidend)();
622         
623         // 3% devTeam
624         uint256 devTeamPaid = ethDeposit*DEV_PERCENT/100;
625         devTeam1.transfer(devTeamPaid);
626         
627         // 50% reward
628         uint256 rewardPaid = ethDeposit*REWARD_PERCENT/100;
629         round[currentRound].totalEth = rewardPaid.add(round[currentRound].totalEth);
630         
631         round[currentRound].totalEthRoundSpend = ethDeposit.add(round[currentRound].totalEthRoundSpend);
632         
633         // Run clock 2
634         if (round[currentRound].is_running_clock2==false&&((currentRound==0 && round[currentRound].totalEth>=LIMMIT_CLOCK_2_ETH)||(currentRound>0&&round[currentRound].totalEth>round[currentRound-1].totalEth))){
635             round[currentRound].is_running_clock2=true;
636             round[currentRound].endRoundByClock2 = now.add(48*ONE_HOUR);
637         }
638         uint256 tempEndRound = round[currentRound].endRoundByClock2;
639         // update endround Time
640         if (round[currentRound].endRoundByClock2>round[currentRound].endRoundByClock1||round[currentRound].endRoundByClock2==0){
641             tempEndRound = round[currentRound].endRoundByClock1;
642         }
643         round[currentRound].endRound = tempEndRound;
644         
645         return true;
646     }
647     
648     // early income real time display
649     function getEarlyIncomeView(address _sender, bool _current) public view returns(uint256){
650         uint256 _last_round = earlyIncomeRoundPulled[_sender];
651         uint256 _currentRound = currentRound;
652         if (_current) {
653             _currentRound = _currentRound.add(1);
654         }
655         if (_last_round + 100 < _currentRound) _last_round = _currentRound - 100;
656 
657         uint256 _sum;
658         for (uint256 i = _last_round;i<_currentRound;i++){
659             _sum = _sum.add(getEarlyIncomeByRound(_sender, i));
660         }
661         return _sum;
662     }
663     
664     //  early income pull
665     function getEarlyIncomePull(address _sender) onlyCoreContract() public returns(uint256){
666         uint256 _last_round = earlyIncomeRoundPulled[_sender];
667         if (_last_round + 100 < currentRound) _last_round = currentRound - 100;
668         uint256 _sum;
669         for (uint256 i = _last_round;i<currentRound;i++){
670             _sum = _sum.add(getEarlyIncomeByRound(_sender, i));
671         }
672         earlyIncomeRoundPulled[_sender] = currentRound;
673         return _sum;
674     }
675     
676     function getEarlyIncomeByRound(address _buyer, uint256 _round) public view returns(uint256){
677         uint256 _previous_round;
678         _previous_round = _round-1;
679             if (_round==0) _previous_round = 0;
680         uint256 _sum=0;
681         uint256 _totalEth = round[_round].totalEthRoundSpend*EARLY_PERCENT/100;
682         uint256 _currentAmount = _totalEth*EARLY_PERCENT_FOR_CURRENT/100;
683         uint256 _previousAmount = _totalEth*EARLY_PERCENT_FOR_PREVIOUS/100;
684         
685         if (round[_round].earlyIncomeMarkSum>0){
686              _sum = round[_round].earlyIncomeMark[_buyer].mul(_currentAmount).div(round[_round].earlyIncomeMarkSum);
687         }
688         if (round[_previous_round].earlyIncomeMarkSum>0){
689             _sum = _sum.add(round[_previous_round].earlyIncomeMark[_buyer].mul(_previousAmount).div(round[_previous_round].earlyIncomeMarkSum));
690         }
691         return _sum;
692     }
693 
694     function getSeed()
695         public
696         view
697         returns (uint64)
698     {
699         return uint64(keccak256(block.timestamp, block.difficulty));
700     }
701     
702     function sendTotalEth() onlyAdmin() public {
703         DAAContract.pushDividend.value(address(this).balance)();
704         round[currentRound].totalEth=0;
705     }
706     
707     function getMostSpender() public view returns(address[4]){
708         return mostSpender;
709     }
710     
711     function getMostF1Earnerd() public view returns(address[4]){
712         return mostF1Earnerd;
713     }
714     
715     function getResultWinner(uint256 _round) public view returns(address[]){
716         require(_round<currentRound);
717         return roundWinner[_round];
718     }
719     
720     function getCitizenTicketSpend(uint256 _round, address _sender) public view returns(uint256){
721         return round[_round].citizenTicketSpend[_sender];
722     }
723     
724     function getCititzenTicketSum(uint256 _round) public view returns(uint256){
725         address _sender =msg.sender;
726         return round[_round].participantTicketAmount[_sender];
727     }
728     
729     function getRefF1Sum(uint256 _round, address _sender) public view returns(uint256){
730         return round[_round].RefF1Sum[_sender];
731     }
732     
733     function getLastBuy(uint256 _round) public view returns(address){
734         return round[_round].ticketSlot[round[_round].ticketSlotSum].buyer;
735     }
736     
737     function getCitizenSumSlot(uint256 _round) public view returns(uint256){
738         address _sender = msg.sender;
739         return round[_round].pSlot[_sender].length;
740     }
741     
742     function getCitizenSlotId(uint256 _round, uint256 _id) public view returns(uint256){
743         address _sender = msg.sender;
744         return round[_round].pSlot[_sender][_id];
745     }
746     
747     function getCitizenSlot(uint256 _round, uint256 _slotId) public view returns(address, uint256, uint256){
748         Slot memory _slot = round[_round].ticketSlot[_slotId];
749         return (_slot.buyer,_slot.ticketFrom,_slot.ticketTo);
750     }
751     
752 }