1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 * @title ThorMutual
6 * @author Leo
7 * @dev Thor Mutual for TRX, WAVES, ADA, ERC20 and so on
8 */
9 
10 
11 contract Utils {
12 
13     uint constant DAILY_PERIOD = 1;
14     uint constant WEEKLY_PERIOD = 7;
15 
16     int constant PRICE_DECIMALS = 10 ** 8;
17 
18     int constant INT_MAX = 2 ** 255 - 1;
19 
20     uint constant UINT_MAX = 2 ** 256 - 1;
21 
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     constructor () internal {
39         _owner = msg.sender;
40         emit OwnershipTransferred(address(0), _owner);
41     }
42 
43     /**
44      * @return the address of the owner.
45      */
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(isOwner());
55         _;
56     }
57 
58     /**
59      * @return true if `msg.sender` is the owner of the contract.
60      */
61     function isOwner() public view returns (bool) {
62         return msg.sender == _owner;
63     }
64 
65     // /**
66     //  * @dev Allows the current owner to relinquish control of the contract.
67     //  * @notice Renouncing to ownership will leave the contract without an owner.
68     //  * It will not be possible to call the functions with the `onlyOwner`
69     //  * modifier anymore.
70     //  */
71     // function renounceOwnership() public onlyOwner {
72     //     emit OwnershipTransferred(_owner, address(0));
73     //     _owner = address(0);
74     // }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0));
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 
96 interface ThorMutualInterface {
97     function getCurrentPeriod() external view returns(uint);
98     function settle() external;
99 }
100 
101 
102 /**
103  * @title ThorMutualToken
104  * @dev Every ThorMutualToken contract is related with a specific token such as BTC/ETH/EOS/ERC20
105  * functions, participants send ETH to this contract to take part in the Thor Mutual activity.
106  */
107 contract ThorMutualToken is Ownable, Utils {
108     string public thorMutualToken;
109 
110     // total deposit for a specific period
111     mapping(uint => uint) amountOfDailyPeriod;
112 
113     // total deposit for a specific period
114     mapping(uint => uint) amountOfWeeklyPeriod;
115 
116     // participant's total deposit fund
117     mapping(address => uint) participantAmount;
118 
119     // participants
120     address[] participants;
121 
122     // deposit info
123     struct DepositInfo {
124         uint blockTimeStamp;
125         uint period;
126         string token;
127         uint amount;
128     }
129 
130     // participant's total deposit history
131     //mapping(address => DepositInfo[]) participantsHistory;
132     mapping(address => uint[]) participantsHistoryTime;
133     mapping(address => uint[]) participantsHistoryPeriod;
134     mapping(address => uint[]) participantsHistoryAmount;
135 
136     // participant's total deposit fund for a specific period
137     mapping(uint => mapping(address => uint)) participantAmountOfDailyPeriod;
138 
139     // participant's total deposit fund for a weekly period
140     mapping(uint => mapping(address => uint)) participantAmountOfWeeklyPeriod;
141 
142     // participants for the daily period
143     mapping(uint => address[]) participantsDaily;
144 
145     // participants for the weekly period
146     mapping(uint => address[]) participantsWeekly;
147 
148     ThorMutualInterface public thorMutualContract;
149 
150     constructor(string _thorMutualToken, ThorMutualInterface _thorMutual) public {
151         thorMutualToken = _thorMutualToken;
152         thorMutualContract = _thorMutual;
153     }
154 
155     event ThorDepositToken(address sender, uint256 amount);
156     function() external payable {
157         require(msg.value >= 0.001 ether);
158         
159         require(address(thorMutualContract) != address(0));
160         address(thorMutualContract).transfer(msg.value);
161 
162         //uint currentPeriod;
163         uint actualPeriod = 0;
164         uint actualPeriodWeek = 0;
165 
166         actualPeriod = thorMutualContract.getCurrentPeriod();
167 
168         actualPeriodWeek = actualPeriod / WEEKLY_PERIOD;
169 
170         if (participantAmount[msg.sender] == 0) {
171             participants.push(msg.sender);
172         }
173 
174         if (participantAmountOfDailyPeriod[actualPeriod][msg.sender] == 0) {
175             participantsDaily[actualPeriod].push(msg.sender);
176         }
177 
178         if (participantAmountOfWeeklyPeriod[actualPeriodWeek][msg.sender] == 0) {
179             participantsWeekly[actualPeriodWeek].push(msg.sender);
180         }
181 
182         participantAmountOfDailyPeriod[actualPeriod][msg.sender] += msg.value;
183 
184         participantAmount[msg.sender] += msg.value;
185         
186         participantAmountOfWeeklyPeriod[actualPeriodWeek][msg.sender] += msg.value;
187 
188         amountOfDailyPeriod[actualPeriod] += msg.value;
189 
190         amountOfWeeklyPeriod[actualPeriodWeek] += msg.value;
191 
192         // DepositInfo memory depositInfo = DepositInfo(block.timestamp, actualPeriod, thorMutualToken, msg.value);
193 
194         // participantsHistory[msg.sender].push(depositInfo);
195 
196         participantsHistoryTime[msg.sender].push(block.timestamp);
197         participantsHistoryPeriod[msg.sender].push(actualPeriod);
198         participantsHistoryAmount[msg.sender].push(msg.value);
199 
200         emit ThorDepositToken(msg.sender, msg.value);
201     }
202 
203     function setThorMutualContract(ThorMutualInterface _thorMutualContract) public onlyOwner{
204         require(address(_thorMutualContract) != address(0));
205         thorMutualContract = _thorMutualContract;
206     }
207 
208     function getThorMutualContract() public view returns(address) {
209         return thorMutualContract;
210     }
211 
212     function setThorMutualToken(string _thorMutualToken) public onlyOwner {
213         thorMutualToken = _thorMutualToken;
214     }
215 
216     function getDepositDailyAmountofPeriod(uint period) external view returns(uint) {
217         require(period >= 0);
218 
219         return amountOfDailyPeriod[period];
220     }
221 
222     function getDepositWeeklyAmountofPeriod(uint period) external view returns(uint) {
223         require(period >= 0);
224         uint periodWeekly = period / WEEKLY_PERIOD;
225         return amountOfWeeklyPeriod[periodWeekly];
226     }
227 
228     function getParticipantsDaily(uint period) external view returns(address[], uint) {
229         require(period >= 0);
230 
231         return (participantsDaily[period], participantsDaily[period].length);
232     }
233 
234     function getParticipantsWeekly(uint period) external view returns(address[], uint) {
235         require(period >= 0);
236 
237         uint periodWeekly = period / WEEKLY_PERIOD;
238         return (participantsWeekly[periodWeekly], participantsWeekly[period].length);
239     }
240 
241     function getParticipantAmountDailyPeriod(uint period, address participant) external view returns(uint) {
242         require(period >= 0);
243 
244         return participantAmountOfDailyPeriod[period][participant];
245     }
246 
247     function getParticipantAmountWeeklyPeriod(uint period, address participant) external view returns(uint) {
248         require(period >= 0);
249 
250         uint periodWeekly = period / WEEKLY_PERIOD;
251         return participantAmountOfWeeklyPeriod[periodWeekly][participant];
252     }
253 
254     //function getParticipantHistory(address participant) public view returns(DepositInfo[]) {
255     function getParticipantHistory(address participant) public view returns(uint[], uint[], uint[]) {
256 
257         return (participantsHistoryTime[participant], participantsHistoryPeriod[participant], participantsHistoryAmount[participant]);
258         //return participantsHistory[participant];
259     }
260 
261     function getSelfBalance() public view returns(uint) {
262         return address(this).balance;
263     }
264 
265     function withdraw(address receiver, uint amount) public onlyOwner {
266         require(receiver != address(0));
267 
268         receiver.transfer(amount);
269     }
270 
271 }
272 
273 
274 interface ThorMutualTokenInterface {
275     function getParticipantsDaily(uint period) external view returns(address[], uint);
276     function getParticipantsWeekly(uint period) external view returns(address[], uint);
277     function getDepositDailyAmountofPeriod(uint period) external view returns(uint);
278     function getDepositWeeklyAmountofPeriod(uint period) external view returns(uint);
279     function getParticipantAmountDailyPeriod(uint period, address participant) external view returns(uint);
280     function getParticipantAmountWeeklyPeriod(uint period, address participant) external view returns(uint);
281 }
282 
283 interface ThorMutualTokenPriceInterface {
284     function getMaxDailyDrawdown(uint period) external view returns(address);
285     function getMaxWeeklyDrawdown(uint period) external view returns(address);
286 }
287 
288 interface ThorMutualWeeklyRewardInterface {
289     function settleWeekly(address winner, uint amountWinner) external; 
290 }
291 
292 contract ThorMutual is Ownable, Utils {
293 
294     string public thorMutual;
295 
296     // period update daily
297     uint internal periodUpdateIndex = 0;
298 
299     // initial flag
300     bool internal initialFlag = false;
301 
302     ThorMutualTokenPriceInterface public thorMutualTokenPrice;
303 
304     ThorMutualTokenInterface[] thorMutualTokens;
305 
306     ThorMutualWeeklyReward public thorMutualWeeklyReward;
307 
308     mapping(uint => address) winnerDailyTokens;
309     mapping(uint => address) winnerWeeklyTokens;
310 
311     mapping(uint => uint) winnerDailyParticipantAmounts;
312     mapping(uint => uint) winnerWeeklyParticipantAmounts;
313 
314     mapping(uint => uint) winnerDailyDepositAmounts;
315 
316     mapping(uint => address) winnerWeeklyAccounts;
317 
318     // daily winners' award
319     mapping(uint => mapping(address => uint)) winnerDailyParticipantInfos;
320 
321     // weekly winners' award
322     mapping(uint => mapping(address => uint)) winnerWeeklyParticipantInfos;
323 
324     // struct AwardInfo {
325     //     address winner;
326     //     uint awardAmount;
327     // }
328 
329     // daily winners' address
330     mapping(uint => address[]) winnerDailyParticipantAddrs;
331     mapping(uint => uint[]) winnerDailyParticipantAwards;
332 
333     // weekly winners' info
334     mapping(uint => address) winnerWeeklyParticipantAddrs;
335     mapping(uint => uint) winnerWeeklyParticipantAwards;
336 
337     // 0.001 eth = 1 finney 
338     // uint internal threadReward = 1 * 10 ** 15;
339 
340     // 
341     uint internal distributeRatioOfDaily = 70;
342     uint internal distributeRatioOfWeekly = 20;
343     uint internal distributeRatioOfPlatform = 10;
344 
345     uint internal ratioWeekly = 5;
346 
347     // address of platform
348     address internal rewardAddressOfPlatfrom;
349 
350     constructor() public {
351         thorMutual = "ThorMutual";
352     }
353 
354     event DepositToken(address token, uint256 amount);
355     function() external payable {
356         emit DepositToken(msg.sender, msg.value);
357     }
358 
359     function setThorMutualParms(uint _distributeRatioOfDaily, uint _distributeRatioOfWeekly, uint _distributeRatioOfPlatform, uint _ratioWeekly) public onlyOwner {
360         require(_distributeRatioOfDaily + _distributeRatioOfWeekly + _distributeRatioOfPlatform == 100);
361         require(_ratioWeekly >= 0 && _ratioWeekly <= 10);
362 
363         distributeRatioOfDaily = _distributeRatioOfDaily;
364         distributeRatioOfWeekly = _distributeRatioOfWeekly;
365         distributeRatioOfPlatform = _distributeRatioOfPlatform;
366         ratioWeekly = _ratioWeekly;
367     }
368 
369     function getThorMutualParms() public view returns(uint, uint, uint, uint){
370         return (distributeRatioOfDaily, distributeRatioOfWeekly, distributeRatioOfPlatform, ratioWeekly);
371     }
372 
373     /**
374      * @dev set thorMutualTokens' contract address
375      * @param _thorMutualTokens _thorMutualTokens
376      * @param _length _length
377      */
378     function setThorMutualTokenContracts(ThorMutualTokenInterface[] memory _thorMutualTokens, uint _length) public onlyOwner {
379         require(_thorMutualTokens.length == _length);
380 
381         for (uint i = 0; i < _length; i++) {
382             thorMutualTokens.push(_thorMutualTokens[i]);
383         }
384     }
385 
386     function initialPeriod() internal {
387         periodUpdateIndex++;
388     }
389 
390     /**
391      * @dev return periodUpdateIndex, periodActual
392      * @return the index return periodUpdateIndex, periodActual
393      */
394     function getCurrentPeriod() public view returns(uint) {
395         return periodUpdateIndex;
396     }
397 
398     function settle() external {
399 
400         require(address(thorMutualTokenPrice) == msg.sender);
401 
402         if(initialFlag == false) {
403             initialFlag = true;
404 
405             initialPeriod();
406 
407             return;
408         }
409 
410         dailySettle();
411 
412         if(periodUpdateIndex % WEEKLY_PERIOD == 0){
413             weeklySettle();
414         }
415 
416         periodUpdateIndex++;
417     }
418 
419     event ThorMutualRewardOfPlatfrom(address, uint256);
420 
421     function dailySettle() internal {
422 
423         require(periodUpdateIndex >= 1);
424 
425         address maxDrawdownThorMutualTokenAddress;
426 
427         maxDrawdownThorMutualTokenAddress = thorMutualTokenPrice.getMaxDailyDrawdown(periodUpdateIndex);
428 
429         if (maxDrawdownThorMutualTokenAddress == address(0)) {
430             return;
431         }
432 
433         winnerDailyTokens[periodUpdateIndex-1] = maxDrawdownThorMutualTokenAddress;
434 
435         ThorMutualTokenInterface maxDrawdownThorMutualToken = ThorMutualTokenInterface(maxDrawdownThorMutualTokenAddress);
436 
437         address[] memory winners;
438         (winners, ) = maxDrawdownThorMutualToken.getParticipantsDaily(periodUpdateIndex - 1);
439         uint winnersLength = winners.length;
440 
441         winnerDailyParticipantAmounts[periodUpdateIndex-1] = winnersLength;
442 
443         uint amountOfPeriod = 0;
444         uint i = 0;
445         for (i = 0; i < thorMutualTokens.length; i++) {
446             amountOfPeriod += thorMutualTokens[i].getDepositDailyAmountofPeriod(periodUpdateIndex - 1);
447         }
448 
449         winnerDailyDepositAmounts[periodUpdateIndex-1] = amountOfPeriod;
450 
451         uint rewardAmountOfDaily = amountOfPeriod * distributeRatioOfDaily / 100;
452         uint rewardAmountOfPlatform = amountOfPeriod * distributeRatioOfPlatform / 100;
453         uint rewardAmountOfWeekly = amountOfPeriod - rewardAmountOfDaily - rewardAmountOfPlatform;
454         
455         uint amountOfTokenAndPeriod = maxDrawdownThorMutualToken.getDepositDailyAmountofPeriod(periodUpdateIndex - 1);
456 
457         for (i = 0; i < winnersLength; i++) {
458             address rewardParticipant = winners[i];
459 
460             uint depositAmountOfParticipant = maxDrawdownThorMutualToken.getParticipantAmountDailyPeriod(periodUpdateIndex - 1, rewardParticipant);
461 
462             uint rewardAmountOfParticipant = depositAmountOfParticipant * rewardAmountOfDaily / amountOfTokenAndPeriod;
463 
464             // if (rewardAmountOfParticipant > threadReward) {
465             rewardParticipant.transfer(rewardAmountOfParticipant);
466 
467             // record winner's info
468             winnerDailyParticipantInfos[periodUpdateIndex - 1][rewardParticipant] = rewardAmountOfParticipant;
469 
470             winnerDailyParticipantAddrs[periodUpdateIndex - 1].push(rewardParticipant);
471             winnerDailyParticipantAwards[periodUpdateIndex - 1].push(rewardAmountOfParticipant);
472 
473             // }
474         }
475 
476         rewardAddressOfPlatfrom.transfer(rewardAmountOfPlatform);
477         emit ThorMutualRewardOfPlatfrom(rewardAddressOfPlatfrom, rewardAmountOfPlatform);
478 
479         address(thorMutualWeeklyReward).transfer(rewardAmountOfWeekly);
480 
481     }
482 
483     function weeklySettle() internal {
484 
485         require(periodUpdateIndex >= WEEKLY_PERIOD);
486 
487         address maxDrawdownThorMutualTokenAddress;
488 
489         maxDrawdownThorMutualTokenAddress = thorMutualTokenPrice.getMaxWeeklyDrawdown(periodUpdateIndex);
490 
491         if (maxDrawdownThorMutualTokenAddress == address(0)) {
492             return;
493         }
494 
495         uint weeklyPeriod = (periodUpdateIndex - 1) / WEEKLY_PERIOD;
496 
497         winnerWeeklyTokens[weeklyPeriod] = maxDrawdownThorMutualTokenAddress;
498 
499         ThorMutualTokenInterface maxDrawdownThorMutualToken = ThorMutualTokenInterface(maxDrawdownThorMutualTokenAddress);
500 
501         address[] memory participants;
502         (participants, ) = maxDrawdownThorMutualToken.getParticipantsWeekly(periodUpdateIndex - 1);
503         uint winnersLength = participants.length;
504 
505         winnerWeeklyParticipantAmounts[weeklyPeriod] = winnersLength;
506 
507         //address[] winners;
508         address winner;
509         uint maxDeposit = 0;
510 
511         for (uint i = 0; i < winnersLength; i++) {
512             address rewardParticipant = participants[i];
513 
514             uint depositAmountOfParticipant = maxDrawdownThorMutualToken.getParticipantAmountWeeklyPeriod(periodUpdateIndex - 1, rewardParticipant);
515 
516             if(depositAmountOfParticipant > maxDeposit) {
517                 winner = rewardParticipant;
518                 maxDeposit = depositAmountOfParticipant;
519             }
520 
521         }
522 
523         winnerWeeklyAccounts[weeklyPeriod] = winner;
524 
525         uint thorMutualWeeklyRewardFund = address(thorMutualWeeklyReward).balance;
526 
527         uint winnerWeeklyAward = thorMutualWeeklyRewardFund * ratioWeekly / 10;
528 
529         thorMutualWeeklyReward.settleWeekly(winner, winnerWeeklyAward);
530 
531         // record winner's info
532 
533         winnerWeeklyParticipantInfos[weeklyPeriod][winner] = winnerWeeklyAward;
534 
535         winnerWeeklyParticipantAddrs[weeklyPeriod] = winner;
536         winnerWeeklyParticipantAwards[weeklyPeriod] = winnerWeeklyAward;
537 
538     }
539 
540     function getDailyWinnerTokenInfo(uint period) public view returns(address, uint, uint, address[], uint[]) {
541         require(period >= 0 && period < periodUpdateIndex);
542 
543         address token = winnerDailyTokens[period];
544 
545         uint participantAmount = winnerDailyParticipantAmounts[period];
546 
547         uint depositAmount = winnerDailyDepositAmounts[period];
548 
549         return (token, participantAmount, depositAmount, winnerDailyParticipantAddrs[period], winnerDailyParticipantAwards[period]);
550     }
551 
552     function getWeeklyWinnerTokenInfo(uint period) public view returns(address, uint, address, address, uint) {
553         require(period >= 0 && period < periodUpdateIndex);
554 
555         uint actualPeriod = period / WEEKLY_PERIOD;
556 
557         address token = winnerWeeklyTokens[actualPeriod];
558 
559         uint participantAmount = winnerWeeklyParticipantAmounts[actualPeriod];
560 
561         address winner = winnerWeeklyAccounts[actualPeriod];
562 
563         return (token, participantAmount, winner, winnerWeeklyParticipantAddrs[actualPeriod], winnerWeeklyParticipantAwards[actualPeriod]);
564     }
565 
566     function getDailyAndWeeklyWinnerInfo(uint period, address winner) public view returns(uint, uint){
567         require(period >= 0 && period < periodUpdateIndex);
568 
569         uint periodWeekly = period / WEEKLY_PERIOD;
570 
571         return (winnerDailyParticipantInfos[period][winner], winnerWeeklyParticipantInfos[periodWeekly][winner]);
572     }
573 
574     /**
575      * @dev set thorMutualTokenPrice's contract address
576      * @param _thorMutualTokenPrice _thorMutualTokenPrice
577      */
578     function setThorMutualTokenPrice(ThorMutualTokenPriceInterface _thorMutualTokenPrice) public onlyOwner {
579         require(address(_thorMutualTokenPrice) != address(0));
580         thorMutualTokenPrice = _thorMutualTokenPrice;
581     }
582 
583     function setRewardAddressOfPlatfrom(address _rewardAddressOfPlatfrom) public onlyOwner {
584         require(_rewardAddressOfPlatfrom != address(0));
585         rewardAddressOfPlatfrom = _rewardAddressOfPlatfrom;
586     }
587 
588     function setThorMutualWeeklyReward(address _thorMutualWeeklyReward) public onlyOwner {
589         require(_thorMutualWeeklyReward != address(0));
590         thorMutualWeeklyReward = ThorMutualWeeklyReward(_thorMutualWeeklyReward);
591     }
592 
593     function getSelfBalance() public view returns(uint) {
594         return address(this).balance;
595     }
596 
597     function withdraw(address receiver, uint amount) public onlyOwner {
598         require(receiver != address(0));
599 
600         receiver.transfer(amount);
601     }
602 
603 }
604 
605 contract ThorMutualWeeklyReward is Ownable, Utils {
606 
607     string public thorMutualWeeklyReward;
608 
609     address public thorMutual;
610 
611     constructor(ThorMutualInterface _thorMutual) public {
612         thorMutualWeeklyReward = "ThorMutualWeeklyReward";
613         thorMutual = address(_thorMutual);
614     }
615 
616     event ThorMutualWeeklyRewardDeposit(uint256 amount);
617     function() external payable {
618         emit ThorMutualWeeklyRewardDeposit(msg.value);
619     }
620 
621     event SettleWeekly(address winner, uint256 amount);
622     function settleWeekly(address winner, uint amountWinner) external {
623 
624         require(msg.sender == thorMutual);
625         require(winner != address(0));
626 
627         winner.transfer(amountWinner);
628 
629         emit SettleWeekly(winner, amountWinner);
630     }
631 
632     function setThorMutualContract(address _thorMutualContract) public onlyOwner{
633         require(_thorMutualContract != address(0));
634         thorMutual = _thorMutualContract;
635     }
636 
637     function getSelfBalance() public view returns(uint) {
638         return address(this).balance;
639     }
640 
641     function withdraw(address receiver, uint amount) public onlyOwner {
642         require(receiver != address(0));
643 
644         receiver.transfer(amount);
645     }
646 
647 }
648 
649 contract ThorMutualTokenPrice is Ownable, Utils {
650 
651     string public thorMutualTokenPrice;
652 
653     address[] internal tokensIncluded;
654     mapping(address => bool) isTokenIncluded;
655 
656     ThorMutualInterface public thorMutualContract;
657 
658     struct TokenPrice{
659         uint blockTimeStamp;
660         uint price;
661     }
662     // mapping(address => TokenPrice) tokensPrice;
663 
664     mapping(uint => mapping(address => TokenPrice)) dailyTokensPrices;
665 
666     constructor(ThorMutualInterface _thorMutual) public {
667         thorMutualTokenPrice = "ThorMutualTokenPrice";
668         thorMutualContract = _thorMutual;
669     }
670 
671     mapping(uint => int[]) dailyTokensPricesDrawdown;
672     mapping(uint => int[]) weeklyTokensPricesDrawdown;
673 
674     mapping(uint =>ThorMutualTokenInterface) dailyTokenWinners;
675     mapping(uint =>ThorMutualTokenInterface) weeklyTokenWinners;
676 
677     /**
678      * @dev return all tokens included
679      * @return string[], a list of tokens
680      */
681     function getTokensIncluded() public view returns(address[]) {
682         return tokensIncluded;
683     }
684 
685     function addTokensAndPrices(address[] _newTokens, uint[] _prices, uint _length) public onlyOwner {
686         require(_length == _newTokens.length);
687         require(_length == _prices.length);
688 
689         uint actualPeriod;
690         actualPeriod = thorMutualContract.getCurrentPeriod();
691 
692         for (uint i = 0; i < _length; i++) {
693             require(!isTokenIncluded[_newTokens[i]]);
694             isTokenIncluded[_newTokens[i]] = true;
695             tokensIncluded.push(_newTokens[i]);
696             TokenPrice memory tokenPrice = TokenPrice(block.timestamp, _prices[i]);
697             dailyTokensPrices[actualPeriod][_newTokens[i]] = tokenPrice;
698         }
699     }
700 
701     /**
702      * @dev set prices of a list of tokens
703      * @param _tokens a list of tokens
704      * @param _prices a list of prices, actual price * (10 ** 8)
705      */
706     function setTokensPrice(address[] memory _tokens, uint[] memory _prices, bool isSettle) public onlyOwner {
707 
708         uint length = _tokens.length;
709 
710         uint actualPeriod;
711         actualPeriod = thorMutualContract.getCurrentPeriod();
712 
713         require(length == _prices.length);
714         require(length == tokensIncluded.length);
715 
716         for (uint i = 0; i < length; i++) {
717             address token = _tokens[i];
718             require(isTokenIncluded[token]);
719             TokenPrice memory tokenPrice = TokenPrice(block.timestamp, _prices[i]);
720             // tokensPrice[token] = tokenPrice;
721 
722             dailyTokensPrices[actualPeriod][token] = tokenPrice;
723         }
724 
725         // calculate tokens' maxDrawdown
726         if (isSettle == true && actualPeriod >= 1) {
727             //thorMutualContract.settle();
728             calculateMaxDrawdown(actualPeriod);
729         }
730     }
731 
732     function calculateMaxDrawdown(uint period) internal {
733         ThorMutualTokenInterface dailyWinnerToken;
734         ThorMutualTokenInterface weeklyWinnerToken;
735         (dailyWinnerToken,) = _getMaxDrawdown(DAILY_PERIOD, period);
736 
737         if(period % WEEKLY_PERIOD == 0) {
738             (weeklyWinnerToken,) = _getMaxDrawdown(WEEKLY_PERIOD, period);
739             weeklyTokenWinners[period / WEEKLY_PERIOD] = weeklyWinnerToken;
740         }
741 
742         dailyTokenWinners[period] = dailyWinnerToken;
743         
744     }
745 
746     function settle() public onlyOwner {
747         require(address(thorMutualContract) != address(0));
748         thorMutualContract.settle();
749     }
750 
751     /**
752      * @dev get prices of a list of tokens
753      * @param period period
754      */
755 
756     function getTokenPriceOfPeriod(address token, uint period) public view returns(uint) {
757         require(isTokenIncluded[token]);
758         require(period >= 0);
759 
760         return dailyTokensPrices[period][token].price;
761 
762     }
763 
764     function setThorMutualContract(ThorMutualInterface _thorMutualContract) public onlyOwner {
765         require(address(_thorMutualContract) != address(0));
766         thorMutualContract = _thorMutualContract;
767     }
768 
769     /**
770      * @dev return the index of token with daily maximum drawdown
771      * @return the index of token with maximum drawdown
772      */
773     function getMaxDailyDrawdown(uint period) external view returns(ThorMutualTokenInterface) {
774 
775         return dailyTokenWinners[period];
776     }
777 
778     /**
779      * @dev return the index of token with weekly maximum drawdown
780      * @return the index of token with maximum drawdown
781      */
782     function getMaxWeeklyDrawdown(uint period) external view returns(ThorMutualTokenInterface) {
783 
784         return weeklyTokenWinners[period / WEEKLY_PERIOD];
785     }
786 
787     /**
788      * @dev return the index of token with maximum drawdown
789      * @param period period
790      * @return the index of token with maximum drawdown
791      */
792     function _getMaxDrawdown(uint period, uint actualPeriod) internal returns(ThorMutualTokenInterface, int) {
793 
794         uint currentPeriod = actualPeriod;
795         uint oldPeriod = (actualPeriod - period);
796 
797         uint periodDrawdownMaxIndex = UINT_MAX;
798 
799         uint settlePeriod;
800 
801         int maxDrawdown = INT_MAX;
802         // address[] memory particpantsOfToken;
803         uint amountOfParticipant;
804 
805         for (uint i = 0; i < tokensIncluded.length; i++) {
806             address token = tokensIncluded[i];
807 
808             
809             if (period == DAILY_PERIOD) {
810                 settlePeriod = currentPeriod - 1;
811                 (, amountOfParticipant) = ThorMutualTokenInterface(token).getParticipantsDaily(settlePeriod);
812             } else if (period == WEEKLY_PERIOD) {
813                 settlePeriod = (currentPeriod - 1) / WEEKLY_PERIOD;
814                 (, amountOfParticipant) = ThorMutualTokenInterface(token).getParticipantsWeekly(settlePeriod);
815             }
816 
817             int currentPeriodPrice = int(dailyTokensPrices[currentPeriod][token].price);
818             int oldPeriodPrice = int(dailyTokensPrices[oldPeriod][token].price);
819 
820             int drawdown = (currentPeriodPrice - oldPeriodPrice) * PRICE_DECIMALS / oldPeriodPrice;
821 
822             if (amountOfParticipant > 0) {
823                 if (drawdown < maxDrawdown) {
824                     maxDrawdown = drawdown;
825                     periodDrawdownMaxIndex = i;
826                 }
827             }
828 
829             // daily drawdown data
830             if (period == DAILY_PERIOD) {
831                 settlePeriod = currentPeriod - 1;
832                 dailyTokensPricesDrawdown[settlePeriod].push(drawdown);
833             } else if(period == WEEKLY_PERIOD) {
834                 settlePeriod = (currentPeriod - 1) / WEEKLY_PERIOD;
835                 weeklyTokensPricesDrawdown[settlePeriod].push(drawdown);
836             }
837 
838         }
839 
840         if (periodDrawdownMaxIndex == UINT_MAX) {
841             return (ThorMutualTokenInterface(address(0)), maxDrawdown);
842         }
843 
844         return (ThorMutualTokenInterface(tokensIncluded[periodDrawdownMaxIndex]), maxDrawdown);
845     }
846     
847     function getDailyAndWeeklyPriceDrawdownInfo(uint period) public view returns(address[], int[], int[]) {
848         uint periodWeekly = period / WEEKLY_PERIOD;
849         return (tokensIncluded, dailyTokensPricesDrawdown[period], weeklyTokensPricesDrawdown[periodWeekly]);
850     }
851 
852     function withdraw(address receiver, uint amount) public onlyOwner {
853         require(receiver != address(0));
854 
855         receiver.transfer(amount);
856     }
857 
858 }