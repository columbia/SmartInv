1 /*
2  * Kryptium House Smart Contract v.2.0.0
3  * Copyright © 2019 Kryptium Team <info@kryptium.io>
4  * Author: Giannis Zarifis <jzarifis@kryptium.io>
5  * 
6  * A decentralised betting house in the form of an Ethereum smart contract which 
7  * registers bets, escrows the amounts wagered and transfers funds following the 
8  * outcomes of the corresponding events. It can be fully autonomous or managed 
9  * and might charge a commission for its services.
10  *
11  * This program is free to use according the Terms of Use available at
12  * <https://kryptium.io/terms-of-use/>. You cannot resell it or copy any
13  * part of it or modify it without permission from the Kryptium Team.
14  *
15  * This program is distributed in the hope that it will be useful, but WITHOUT 
16  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
17  * FOR A PARTICULAR PURPOSE. See the Terms of Use for more details.
18  */
19 
20 pragma solidity ^0.5.0;
21 
22 /**
23  * SafeMath
24  * Math operations with safety checks that throw on error
25  */
26 contract SafeMath {
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a * b;
29         assert(a == 0 || c / a == b);
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b != 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 
51     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
52         return div(mul(number, numerator), denominator);
53     }
54 }
55 
56 contract Owned {
57 
58     address payable public owner;
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address payable newOwner) onlyOwner public {
70         require(newOwner != address(0x0));
71         owner = newOwner;
72     }
73 }
74 
75 /*
76 Oracle smart contract interface
77 */
78 interface OracleContract {
79     function eventOutputs(uint eventId, uint outputId) external view returns (bool isSet, string memory title, uint possibleResultsCount, uint  eventOutputType, string memory announcement, uint decimals); 
80     function owner() external view returns (address);
81     function getEventForHousePlaceBet(uint id) external view returns (uint closeDateTime, uint freezeDateTime, bool isCancelled); 
82     function getEventOutcomeIsSet(uint eventId, uint outputId) external view returns (bool isSet);
83     function getEventOutcome(uint eventId, uint outputId) external view returns (uint outcome); 
84     function getEventOutcomeNumeric(uint eventId, uint outputId) external view returns(uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6);
85 }
86 
87 /*
88 House smart contract interface
89 */
90 interface HouseContract {
91     function owner() external view returns (address payable); 
92     function isHouse() external view returns (bool); 
93 }
94 
95 
96 
97 /*
98  * Kryptium House Smart Contract.
99  */
100 contract House is SafeMath, Owned {
101 
102     //enum Category { football, basket }
103 
104     enum BetType { headtohead, multiuser, poolbet }
105 
106     enum BetEvent { placeBet, callBet, removeBet, refuteBet, settleWinnedBet, settleCancelledBet, increaseWager, cancelledByHouse }
107 
108     uint private betNextId;
109 
110 
111     struct Bet { 
112         uint id;
113         address oracleAddress;
114         uint eventId;
115         uint outputId;
116         uint outcome;
117         bool isOutcomeSet;
118         uint closeDateTime;
119         uint freezeDateTime;
120         bool isCancelled;
121         uint256 minimumWager;
122         uint256 maximumWager;
123         uint256 payoutRate;
124         address createdBy;
125         BetType betType;
126     } 
127 
128 
129     struct HouseData { 
130         bool managed;
131         string  name;
132         string  creatorName;
133         string  countryISO; 
134         address oracleAddress;
135         address oldOracleAddress;       
136         bool  newBetsPaused;
137         uint  housePercentage;
138         uint oraclePercentage;   
139         uint version;
140         string shortMessage;              
141     } 
142 
143     address public _newHouseAddress;
144 
145     HouseData public houseData;  
146 
147     // This creates an array with all bets
148     mapping (uint => Bet) public bets;
149 
150     // User balances
151     mapping (address => uint256) public balance;
152 
153 
154     //Last betting activity timestamp
155     uint public lastBettingActivity;
156 
157 
158     //Total amount on Bet
159     mapping (uint => uint256) public betTotalAmount;
160 
161     //Totalbets on bet
162     mapping (uint => uint) public betTotalBets;
163 
164     //Bet Refutes amount
165     mapping (uint => uint256) public betRefutedAmount;
166 
167     //Total amount placed on a bet forecast
168     mapping (uint => mapping (uint => uint256)) public betForcastTotalAmount;    
169 
170     //Player bet total amount on a Bet
171     mapping (address => mapping (uint => uint256)) public playerBetTotalAmount;
172 
173     //Player bet total bets on a Bet
174     mapping (address => mapping (uint => uint)) public playerBetTotalBets;
175 
176     //Player wager for a Bet.Output.Forecast
177     mapping (address => mapping (uint => mapping (uint => uint256))) public playerBetForecastWager;
178 
179     //head to head bets forecasts
180     mapping (uint => mapping (address => uint)) public headToHeadForecasts;  
181 
182     //head to head bets max accepted forecasts
183     mapping (uint => uint) public headToHeadMaxAcceptedForecasts;  
184 
185 
186     //Player bet Refuted
187     mapping (address => mapping (uint => bool)) public playerBetRefuted;    
188 
189     //Player bet Settled
190     mapping (address => mapping (uint => bool)) public playerBetSettled; 
191 
192 
193     // Stores the house owners percentage as part per thousand 
194     mapping (address => uint) public ownerPerc;
195 
196     //The array of house owners
197     address payable[] public owners;
198 
199     //The House and Oracle edge has been paid
200     mapping (uint => bool) public housePaid;
201 
202     //Player has placed at leat one bet
203     mapping (address => bool) public playerHasBet;
204 
205     // Notifies clients that a new house is launched
206     event HouseCreated();
207 
208     // Notifies clients that a house data has changed
209     event HousePropertiesUpdated();    
210 
211     event BetPlacedOrModified(uint id, address sender, BetEvent betEvent, uint256 amount, uint forecast, string createdBy, uint closeDateTime);
212 
213 
214     event transfer(address indexed wallet, uint256 amount,bool inbound);
215 
216     event testevent(uint betTotalAmount, uint AcceptedWager, uint headToHeadForecastsOPEN, uint matchedANDforecast, uint matchedORforecast, uint headToHeadMaxAcceptedForecast);
217 
218 
219     /**
220      * Constructor function
221      * Initializes House contract
222      */
223     constructor(bool managed, string memory houseName, string memory houseCreatorName, string memory houseCountryISO, address oracleAddress, address payable[] memory ownerAddress, uint[] memory ownerPercentage, uint housePercentage,uint oraclePercentage, uint version) public {
224         require(add(housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
225         houseData.managed = managed;
226         houseData.name = houseName;
227         houseData.creatorName = houseCreatorName;
228         houseData.countryISO = houseCountryISO;
229         houseData.housePercentage = housePercentage;
230         houseData.oraclePercentage = oraclePercentage; 
231         houseData.oracleAddress = oracleAddress;
232         houseData.shortMessage = "";
233         houseData.newBetsPaused = true;
234         houseData.version = version;
235         uint ownersTotal = 0;
236         for (uint i = 0; i<ownerAddress.length; i++) {
237             owners.push(ownerAddress[i]);
238             ownerPerc[ownerAddress[i]] = ownerPercentage[i];
239             ownersTotal += ownerPercentage[i];
240             }
241         require(ownersTotal == 1000);    
242         emit HouseCreated();
243     }
244 
245 
246 
247     /**
248      * Check if valid house contract
249      */
250     function isHouse() public pure returns(bool response) {
251         return true;    
252     }
253 
254      /**
255      * Updates House Data function
256      *
257      */
258     function updateHouseProperties(string memory houseName, string memory houseCreatorName, string memory houseCountryISO) onlyOwner public {
259         houseData.name = houseName;
260         houseData.creatorName = houseCreatorName;
261         houseData.countryISO = houseCountryISO;     
262         emit HousePropertiesUpdated();
263     }    
264 
265     /**
266      * Updates House Oracle function
267      *
268      */
269     function changeHouseOracle(address oracleAddress, uint oraclePercentage) onlyOwner public {
270         require(add(houseData.housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
271         if (oracleAddress != houseData.oracleAddress) {
272             houseData.oldOracleAddress = houseData.oracleAddress;
273             houseData.oracleAddress = oracleAddress;
274         }
275         houseData.oraclePercentage = oraclePercentage;
276         emit HousePropertiesUpdated();
277     } 
278 
279     /**
280      * Updates House percentage function
281      *
282      */
283     function changeHouseEdge(uint housePercentage) onlyOwner public {
284         require(housePercentage != houseData.housePercentage,"New percentage is identical with current");
285         require(add(housePercentage,houseData.oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
286         houseData.housePercentage = housePercentage;
287         emit HousePropertiesUpdated();
288     } 
289 
290 
291 
292     function updateBetDataFromOracle(uint betId) private {
293         if (!bets[betId].isOutcomeSet) {
294             (bets[betId].isOutcomeSet) = OracleContract(bets[betId].oracleAddress).getEventOutcomeIsSet(bets[betId].eventId,bets[betId].outputId); 
295             if (bets[betId].isOutcomeSet) {
296                 (bets[betId].outcome) = OracleContract(bets[betId].oracleAddress).getEventOutcome(bets[betId].eventId,bets[betId].outputId); 
297             }
298         }     
299         if (!bets[betId].isCancelled) {
300         (bets[betId].closeDateTime, bets[betId].freezeDateTime, bets[betId].isCancelled) = OracleContract(bets[betId].oracleAddress).getEventForHousePlaceBet(bets[betId].eventId);      
301         }  
302         if (!bets[betId].isOutcomeSet && bets[betId].freezeDateTime <= now) {
303             bets[betId].isCancelled = true;
304         }
305     }
306 
307     /**
308      * Get the possibleResultsCount of an Event.Output as uint.
309      * Should be changed in a future version to use an Oracle function that directly returns possibleResultsCount instead of receive the whole eventOutputs structure
310      */
311     function getEventOutputMaxUint(address oracleAddress, uint eventId, uint outputId) private view returns (uint) {
312         (bool isSet, string memory title, uint possibleResultsCount, uint  eventOutputType, string memory announcement, uint decimals) = OracleContract(oracleAddress).eventOutputs(eventId,outputId);
313         return 2 ** possibleResultsCount - 1;
314     }
315 
316 
317 function checkPayoutRate(uint256 payoutRate) public view {
318     uint256 multBase = 10 ** 18;
319     uint256 houseFees = houseData.housePercentage + houseData.oraclePercentage;
320     uint256 check1 = div(multBase , (1000 - houseFees));
321     check1 = div(mul(100000 , check1), multBase);
322     uint256 check2 = 10000;
323     if (houseFees > 0) {
324         check2 =  div(multBase , houseFees);
325         check2 = div(mul(100000 ,check2), multBase);
326     }
327     require(payoutRate>check1 && payoutRate<check2,"Payout rate out of accepted range");
328 }
329 
330 
331     /*
332      * Places a Pool Bet
333      */
334     function placePoolBet(uint eventId, uint outputId, uint forecast, uint closingDateTime, uint256 minimumWager, uint256 maximumWager, string memory createdBy) payable public {
335         require(msg.value > 0,"Wager should be greater than zero");
336         require(!houseData.newBetsPaused,"Bets are paused right now");
337         betNextId += 1;
338         bets[betNextId].id = betNextId;
339         bets[betNextId].oracleAddress = houseData.oracleAddress;
340         bets[betNextId].outputId = outputId;
341         bets[betNextId].eventId = eventId;
342         bets[betNextId].betType = BetType.poolbet;
343         bets[betNextId].createdBy = msg.sender;
344         updateBetDataFromOracle(betNextId);
345         require(!bets[betNextId].isCancelled,"Event has been cancelled");
346         require(!bets[betNextId].isOutcomeSet,"Event has already an outcome");
347         if (closingDateTime>0) {
348             bets[betNextId].closeDateTime = closingDateTime;
349         }  
350         require(bets[betNextId].closeDateTime >= now,"Close time has passed");
351         if (minimumWager != 0) {
352             bets[betNextId].minimumWager = minimumWager;
353         } else {
354             bets[betNextId].minimumWager = msg.value;
355         }
356         if (maximumWager != 0) {
357             bets[betNextId].maximumWager = maximumWager;
358         }
359 
360               
361         playerBetTotalBets[msg.sender][betNextId] = 1;
362         betTotalBets[betNextId] = 1;
363         betTotalAmount[betNextId] = msg.value;
364  
365         betForcastTotalAmount[betNextId][forecast] = msg.value;
366 
367         playerBetTotalAmount[msg.sender][betNextId] = msg.value;
368 
369         playerBetForecastWager[msg.sender][betNextId][forecast] = msg.value;
370 
371         lastBettingActivity = block.number;
372 
373         playerHasBet[msg.sender] = true;
374         
375         emit BetPlacedOrModified(betNextId, msg.sender, BetEvent.placeBet, msg.value, forecast, createdBy, bets[betNextId].closeDateTime);
376     }  
377 
378     /*
379      * Places a HeadToHEad Bet
380      */
381     function placeH2HBet(uint eventId, uint outputId, uint forecast, uint closingDateTime, uint256 payoutRate, string memory createdBy) payable public {
382         require(msg.value > 0,"Wager should be greater than zero");
383         require(!houseData.newBetsPaused,"Bets are paused right now");
384         betNextId += 1;
385         bets[betNextId].id = betNextId;
386         bets[betNextId].oracleAddress = houseData.oracleAddress;
387         bets[betNextId].outputId = outputId;
388         bets[betNextId].eventId = eventId;
389         bets[betNextId].betType = BetType.headtohead;
390         bets[betNextId].createdBy = msg.sender;
391         updateBetDataFromOracle(betNextId);
392         require(!bets[betNextId].isCancelled,"Event has been cancelled");
393         require(!bets[betNextId].isOutcomeSet,"Event has already an outcome");
394         if (closingDateTime>0) {
395             bets[betNextId].closeDateTime = closingDateTime;
396         }  
397         require(bets[betNextId].closeDateTime >= now,"Close time has passed");
398 
399         checkPayoutRate(payoutRate);
400         uint maxAcceptedForecast = getEventOutputMaxUint(bets[betNextId].oracleAddress, bets[betNextId].eventId, bets[betNextId].outputId);
401         headToHeadMaxAcceptedForecasts[betNextId] = maxAcceptedForecast;
402         require(forecast>0 && forecast < maxAcceptedForecast,"Forecast should be greater than zero and less than Max accepted forecast(All options true)");
403         bets[betNextId].payoutRate = payoutRate;
404         headToHeadForecasts[betNextId][msg.sender] = forecast;
405         
406               
407         playerBetTotalBets[msg.sender][betNextId] = 1;
408         betTotalBets[betNextId] = 1;
409         betTotalAmount[betNextId] = msg.value;
410  
411         betForcastTotalAmount[betNextId][forecast] = msg.value;
412 
413         playerBetTotalAmount[msg.sender][betNextId] = msg.value;
414 
415         playerBetForecastWager[msg.sender][betNextId][forecast] = msg.value;
416 
417         lastBettingActivity = block.number;
418         
419         playerHasBet[msg.sender] = true;
420 
421         emit BetPlacedOrModified(betNextId, msg.sender, BetEvent.placeBet, msg.value, forecast, createdBy, bets[betNextId].closeDateTime);
422     }
423 
424     /*
425      * Call a Bet
426      */
427     function callBet(uint betId, uint forecast, string memory createdBy) payable public {
428         require(msg.value>0,"Wager should be greater than zero");
429         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
430         require(bets[betId].betType != BetType.headtohead || betTotalBets[betId] == 1,"Head to head bet has been already called");
431         require(msg.value>=bets[betId].minimumWager,"Wager is lower than the minimum accepted");
432         require(bets[betId].maximumWager==0 || msg.value<=bets[betId].maximumWager,"Wager is higher then the maximum accepted");
433         updateBetDataFromOracle(betId);
434         require(!bets[betId].isCancelled,"Bet has been cancelled");
435         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
436         require(bets[betId].closeDateTime >= now,"Close time has passed");
437         if (bets[betId].betType == BetType.headtohead) {
438             require(bets[betId].createdBy != msg.sender,"Player has been opened the bet");
439             require(msg.value == mulByFraction( betTotalAmount[betId], bets[betId].payoutRate - 100, 100),"Wager should be equal to [Opened bet Wager  * PayoutRate - 100]");
440             require(headToHeadForecasts[betId][bets[betId].createdBy] & forecast == 0,"Forecast overlaps opened bet forecast");
441             require(headToHeadForecasts[betId][bets[betId].createdBy] | forecast == headToHeadMaxAcceptedForecasts[betId],"Forecast should be opposite to the opened");
442             headToHeadForecasts[betId][msg.sender] = forecast;           
443         } else if (bets[betId].betType == BetType.poolbet) {
444             require(playerBetForecastWager[msg.sender][betId][forecast] == 0,"Already placed a bet on this forecast, use increaseWager method instead");
445         }
446 
447         betTotalBets[betId] += 1;
448         betTotalAmount[betId] += msg.value;
449 
450         playerBetTotalBets[msg.sender][betId] += 1;
451 
452         betForcastTotalAmount[betId][forecast] += msg.value;
453 
454         playerBetTotalAmount[msg.sender][betId] += msg.value;
455 
456         playerBetForecastWager[msg.sender][betId][forecast] = msg.value;
457 
458         lastBettingActivity = block.number;
459 
460         playerHasBet[msg.sender] = true;
461 
462         emit BetPlacedOrModified(betId, msg.sender, BetEvent.callBet, msg.value, forecast, createdBy, bets[betId].closeDateTime);   
463     }  
464 
465     /*
466      * Increase wager
467      */
468     function increaseWager(uint betId, uint forecast, string memory createdBy) payable public {
469         require(msg.value > 0,"Increase wager amount should be greater than zero");
470         require(bets[betId].betType == BetType.poolbet,"Only poolbet supports the increaseWager");
471         require(playerBetForecastWager[msg.sender][betId][forecast] > 0,"Haven't placed any bet for this forecast. Use callBet instead");
472         uint256 wager = playerBetForecastWager[msg.sender][betId][forecast] + msg.value;
473         require(bets[betId].maximumWager==0 || wager<=bets[betId].maximumWager,"The updated wager is higher then the maximum accepted");
474         updateBetDataFromOracle(betId);
475         require(!bets[betId].isCancelled,"Bet has been cancelled");
476         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
477         require(bets[betId].closeDateTime >= now,"Close time has passed");
478         betTotalAmount[betId] += msg.value;
479 
480         betForcastTotalAmount[betId][forecast] += msg.value;
481 
482         playerBetTotalAmount[msg.sender][betId] += msg.value;
483 
484         playerBetForecastWager[msg.sender][betId][forecast] += msg.value;
485 
486         lastBettingActivity = block.number;
487 
488         emit BetPlacedOrModified(betId, msg.sender, BetEvent.increaseWager, msg.value, forecast, createdBy, bets[betId].closeDateTime);       
489     }
490 
491     /*
492      * Remove a Bet
493      */
494     function removeBet(uint betId, string memory createdBy) public {
495         require(bets[betId].createdBy == msg.sender,"Caller and player created don't match");
496         require(playerBetTotalBets[msg.sender][betId] > 0, "Player should has placed at least one bet");
497         require(betTotalBets[betId] == playerBetTotalBets[msg.sender][betId],"The bet has been called by other player");
498         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
499         updateBetDataFromOracle(betId);  
500         bets[betId].isCancelled = true;
501         uint256 wager = betTotalAmount[betId];
502         betTotalBets[betId] = 0;
503         betTotalAmount[betId] = 0;
504         playerBetTotalAmount[msg.sender][betId] = 0;
505         playerBetTotalBets[msg.sender][betId] = 0;
506         lastBettingActivity = block.number;    
507         msg.sender.transfer(wager);   
508         emit BetPlacedOrModified(betId, msg.sender, BetEvent.removeBet, wager, 0, createdBy, bets[betId].closeDateTime);      
509     } 
510 
511     /*
512      * Refute a Bet
513      */
514     function refuteBet(uint betId, string memory createdBy) public {
515         require(playerBetTotalAmount[msg.sender][betId]>0,"Caller hasn't placed any bet");
516         require(!playerBetRefuted[msg.sender][betId],"Already refuted");
517         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
518         updateBetDataFromOracle(betId);  
519         require(bets[betId].isOutcomeSet, "Refute isn't allowed when no outcome has been set");
520         require(bets[betId].freezeDateTime > now, "Refute isn't allowed when Event freeze has passed");
521         playerBetRefuted[msg.sender][betId] = true;
522         betRefutedAmount[betId] += playerBetTotalAmount[msg.sender][betId];
523         if (betRefutedAmount[betId] >= betTotalAmount[betId]) {
524             bets[betId].isCancelled = true;   
525         }
526         lastBettingActivity = block.number;       
527         emit BetPlacedOrModified(betId, msg.sender, BetEvent.refuteBet, 0, 0, createdBy, bets[betId].closeDateTime);    
528     } 
529 
530     function settleHouseFees(uint betId, uint256 houseEdgeAmountForBet, uint256 oracleEdgeAmountForBet) private {
531             if (!housePaid[betId]) {
532                 housePaid[betId] = true;
533                 if (houseEdgeAmountForBet > 0) {
534                     for (uint i = 0; i<owners.length; i++) {
535                         owners[i].transfer(mulByFraction(houseEdgeAmountForBet, ownerPerc[owners[i]], 1000));
536                     }
537                 } 
538                 if (oracleEdgeAmountForBet > 0) {
539                     address payable oracleOwner = HouseContract(bets[betId].oracleAddress).owner();
540                     oracleOwner.transfer(oracleEdgeAmountForBet);
541                 } 
542             }
543     }
544 
545     /*
546      * Settle a Bet
547      */
548     function settleBet(uint betId, string memory createdBy) public {
549         require(playerBetTotalAmount[msg.sender][betId]>0, "Caller hasn't placed any bet");
550         require(!playerBetSettled[msg.sender][betId],"Already settled");
551         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
552         updateBetDataFromOracle(betId);
553         require(bets[betId].isCancelled || bets[betId].isOutcomeSet,"Bet should be cancelled or has an outcome");
554         require(bets[betId].freezeDateTime <= now,"Bet payments are freezed");
555         BetEvent betEvent;
556         uint256 playerOutputFromBet = 0;
557         if (bets[betId].isCancelled) {
558             betEvent = BetEvent.settleCancelledBet;
559             playerOutputFromBet = playerBetTotalAmount[msg.sender][betId];            
560         } else {
561             uint256 houseEdgeAmountForBet = mulByFraction(betTotalAmount[betId], houseData.housePercentage, 1000);
562             uint256 oracleEdgeAmountForBet = mulByFraction(betTotalAmount[betId], houseData.oraclePercentage, 1000);
563             settleHouseFees(betId, houseEdgeAmountForBet, oracleEdgeAmountForBet);
564             uint256 totalBetAmountAfterFees = betTotalAmount[betId] - houseEdgeAmountForBet - oracleEdgeAmountForBet;
565             betEvent = BetEvent.settleWinnedBet;
566             if (bets[betId].betType == BetType.poolbet) {
567                 if (betForcastTotalAmount[betId][bets[betId].outcome]>0) {                  
568                     playerOutputFromBet = mulByFraction(totalBetAmountAfterFees, playerBetForecastWager[msg.sender][betId][bets[betId].outcome], betForcastTotalAmount[betId][bets[betId].outcome]);            
569                 } else {
570                     playerOutputFromBet = playerBetTotalAmount[msg.sender][betId] - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.housePercentage, 1000) - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.oraclePercentage, 1000);
571                     betEvent = BetEvent.settleCancelledBet;
572                 }
573             } else if (bets[betId].betType == BetType.headtohead) {
574                 if (headToHeadForecasts[betId][msg.sender] & (2 ** bets[betId].outcome) > 0) {
575                     playerOutputFromBet = totalBetAmountAfterFees;
576                 } else {
577                     playerOutputFromBet = 0;
578                 }
579             }
580             require(playerOutputFromBet > 0,"Settled amount should be greater than zero");         
581         }      
582         playerBetSettled[msg.sender][betId] = true;
583         lastBettingActivity = block.number;
584         msg.sender.transfer(playerOutputFromBet); 
585         emit BetPlacedOrModified(betId, msg.sender, betEvent, playerOutputFromBet,0, createdBy, bets[betId].closeDateTime);  
586     } 
587 
588     function() external payable {
589         revert();
590     }
591 
592     /**
593     * Withdraw the requested amount to the sender address
594     */
595     function withdraw(uint256 amount) public {
596         require(address(this).balance>=amount,"Insufficient House balance. Shouldn't have happened");
597         require(balance[msg.sender]>=amount,"Insufficient balance");
598         balance[msg.sender] = sub(balance[msg.sender],amount);
599         msg.sender.transfer(amount);
600         emit transfer(msg.sender,amount,false);
601     }
602 
603     /**
604     * Withdraw the requested amount to an address
605     */
606     function withdrawToAddress(address payable destinationAddress,uint256 amount) public {
607         require(address(this).balance>=amount);
608         require(balance[msg.sender]>=amount,"Insufficient balance");
609         balance[msg.sender] = sub(balance[msg.sender],amount);
610         destinationAddress.transfer(amount);
611         emit transfer(msg.sender,amount,false);
612     }
613 
614 
615 
616     /**
617     * Checks if a player has betting activity on House 
618     */
619     function isPlayer(address playerAddress) public view returns(bool) {
620         return (playerHasBet[playerAddress]);
621     }
622 
623     /**
624     * Update House short message 
625     */
626     function updateShortMessage(string memory shortMessage) onlyOwner public {
627         houseData.shortMessage = shortMessage;
628         emit HousePropertiesUpdated();
629     }
630 
631 
632     /**
633     * Starts betting
634     */
635     function startNewBets(string memory shortMessage) onlyOwner public {
636         houseData.shortMessage = shortMessage;
637         houseData.newBetsPaused = false;
638         emit HousePropertiesUpdated();
639     }
640 
641     /**
642     * Pauses betting
643     */
644     function stopNewBets(string memory shortMessage) onlyOwner public {
645         houseData.shortMessage = shortMessage;
646         houseData.newBetsPaused = true;
647         emit HousePropertiesUpdated();
648     }
649 
650     /**
651     * Link House to a new version
652     */
653     function linkToNewHouse(address newHouseAddress) onlyOwner public {
654         require(newHouseAddress!=address(this),"New address is current address");
655         require(HouseContract(newHouseAddress).isHouse(),"New address should be a House smart contract");
656         _newHouseAddress = newHouseAddress;
657         houseData.newBetsPaused = true;
658         emit HousePropertiesUpdated();
659     }
660 
661     /**
662     * UnLink House from a newer version
663     */
664     function unLinkNewHouse() onlyOwner public {
665         _newHouseAddress = address(0);
666         houseData.newBetsPaused = false;
667         emit HousePropertiesUpdated();
668     }
669 
670     /**
671     * Cancels a Bet
672     */
673     function cancelBet(uint betId) onlyOwner public {
674         require(houseData.managed, "Cancel available on managed Houses");
675         updateBetDataFromOracle(betId);
676         require(bets[betId].freezeDateTime > now,"Freeze time passed");       
677         bets[betId].isCancelled = true;
678         emit BetPlacedOrModified(betId, msg.sender, BetEvent.cancelledByHouse, 0, 0, "", bets[betId].closeDateTime);  
679     }
680 
681     /**
682     * Settle fees of Oracle and House for a bet
683     */
684     function settleBetFees(uint betId) onlyOwner public {
685         require(bets[betId].isCancelled || bets[betId].isOutcomeSet,"Bet should be cancelled or has an outcome");
686         require(bets[betId].freezeDateTime <= now,"Bet payments are freezed");
687         settleHouseFees(betId, mulByFraction(betTotalAmount[betId], houseData.housePercentage, 1000), mulByFraction(betTotalAmount[betId], houseData.oraclePercentage, 1000));
688     }
689 
690 
691 
692 
693 }