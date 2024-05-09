1 /*
2  * Kryptium House Smart Contract v.1.1.0
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
17  * FOR A PARTICULAR PURPOSE. See the Terms and Conditions for more details.
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
58     address public owner;
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
69     function transferOwnership(address newOwner) onlyOwner public {
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
91     function owner() external view returns (address); 
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
150     //Last betting activity timestamp
151     uint public lastBettingActivity;
152 
153     //Total bets
154     uint public totalBets;
155 
156     //Total amount played on bets
157     uint public totalAmountOnBets;
158 
159     //Total amount on Bet
160     mapping (uint => uint256) public betTotalAmount;
161 
162     //Totalbets on bet
163     mapping (uint => uint) public betTotalBets;
164 
165     //Bet Refutes amount
166     mapping (uint => uint256) public betRefutedAmount;
167 
168     //Total amount placed on a bet forecast
169     mapping (uint => mapping (uint => uint256)) public betForcastTotalAmount;    
170 
171     //Player bet total amount on a Bet
172     mapping (address => mapping (uint => uint256)) public playerBetTotalAmount;
173 
174     //Player bet total bets on a Bet
175     mapping (address => mapping (uint => uint)) public playerBetTotalBets;
176 
177     //Player wager for a Bet.Output.Forecast
178     mapping (address => mapping (uint => mapping (uint => uint256))) public playerBetForecastWager;
179 
180     //head to head bets forecasts
181     mapping (uint => mapping (address => uint)) public headToHeadForecasts;  
182 
183     //head to head bets max accepted forecasts
184     mapping (uint => uint) public headToHeadMaxAcceptedForecasts;  
185 
186     //Player output(cause or win or refund)  of a bet
187     mapping (address => mapping (uint => uint256)) public playerOutputFromBet;    
188 
189     //Player bet Refuted
190     mapping (address => mapping (uint => bool)) public playerBetRefuted;    
191 
192     //Player bet Settled
193     mapping (address => mapping (uint => bool)) public playerBetSettled; 
194 
195 
196     //Total bets placed by player
197     mapping (address => uint) public totalPlayerBets;
198 
199 
200     //Total amount placed for bets by player
201     mapping (address => uint256) public totalPlayerBetsAmount;
202 
203     // User balances
204     mapping (address => uint256) public balance;
205 
206     // Stores the house owners percentage as part per thousand 
207     mapping (address => uint) public ownerPerc;
208 
209     //The array of house owners
210     address[] public owners;
211 
212     //The House and Oracle edge has been paid
213     mapping (uint => bool) public housePaid;
214 
215     //The total remaining House amount collected from fees for Bet
216     mapping (uint => uint256) public houseEdgeAmountForBet;
217 
218     //The total remaining Oracle amount collected from fees for Bet
219     mapping (uint => uint256) public oracleEdgeAmountForBet;
220 
221     //The total House fees
222     uint256 public houseTotalFees;
223 
224     //The total Oracle fees
225     mapping (address => uint256) public oracleTotalFees;
226 
227     // Notifies clients that a new house is launched
228     event HouseCreated();
229 
230     // Notifies clients that a house data has changed
231     event HousePropertiesUpdated();    
232 
233     event BetPlacedOrModified(uint id, address sender, BetEvent betEvent, uint256 amount, uint forecast, string createdBy, uint closeDateTime);
234 
235 
236     event transfer(address indexed wallet, uint256 amount,bool inbound);
237 
238     event testevent(uint betTotalAmount, uint AcceptedWager, uint headToHeadForecastsOPEN, uint matchedANDforecast, uint matchedORforecast, uint headToHeadMaxAcceptedForecast);
239 
240 
241     /**
242      * Constructor function
243      * Initializes House contract
244      */
245     constructor(bool managed, string memory houseName, string memory houseCreatorName, string memory houseCountryISO, address oracleAddress, address[] memory ownerAddress, uint[] memory ownerPercentage, uint housePercentage,uint oraclePercentage, uint version) public {
246         require(add(housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
247         houseData.managed = managed;
248         houseData.name = houseName;
249         houseData.creatorName = houseCreatorName;
250         houseData.countryISO = houseCountryISO;
251         houseData.housePercentage = housePercentage;
252         houseData.oraclePercentage = oraclePercentage; 
253         houseData.oracleAddress = oracleAddress;
254         houseData.shortMessage = "";
255         houseData.newBetsPaused = true;
256         houseData.version = version;
257         uint ownersTotal = 0;
258         for (uint i = 0; i<ownerAddress.length; i++) {
259             owners.push(ownerAddress[i]);
260             ownerPerc[ownerAddress[i]] = ownerPercentage[i];
261             ownersTotal += ownerPercentage[i];
262             }
263         require(ownersTotal == 1000);    
264         emit HouseCreated();
265     }
266 
267 
268 
269     /**
270      * Check if valid house contract
271      */
272     function isHouse() public pure returns(bool response) {
273         return true;    
274     }
275 
276      /**
277      * Updates House Data function
278      *
279      */
280     function updateHouseProperties(string memory houseName, string memory houseCreatorName, string memory houseCountryISO) onlyOwner public {
281         houseData.name = houseName;
282         houseData.creatorName = houseCreatorName;
283         houseData.countryISO = houseCountryISO;     
284         emit HousePropertiesUpdated();
285     }    
286 
287     /**
288      * Updates House Oracle function
289      *
290      */
291     function changeHouseOracle(address oracleAddress, uint oraclePercentage) onlyOwner public {
292         require(add(houseData.housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
293         if (oracleAddress != houseData.oracleAddress) {
294             houseData.oldOracleAddress = houseData.oracleAddress;
295             houseData.oracleAddress = oracleAddress;
296         }
297         houseData.oraclePercentage = oraclePercentage;
298         emit HousePropertiesUpdated();
299     } 
300 
301     /**
302      * Updates House percentage function
303      *
304      */
305     function changeHouseEdge(uint housePercentage) onlyOwner public {
306         require(housePercentage != houseData.housePercentage,"New percentage is identical with current");
307         require(add(housePercentage,houseData.oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
308         houseData.housePercentage = housePercentage;
309         emit HousePropertiesUpdated();
310     } 
311 
312 
313 
314     function updateBetDataFromOracle(uint betId) private {
315         if (!bets[betId].isOutcomeSet) {
316             (bets[betId].isOutcomeSet) = OracleContract(bets[betId].oracleAddress).getEventOutcomeIsSet(bets[betId].eventId,bets[betId].outputId); 
317             if (bets[betId].isOutcomeSet) {
318                 (bets[betId].outcome) = OracleContract(bets[betId].oracleAddress).getEventOutcome(bets[betId].eventId,bets[betId].outputId); 
319             }
320         }     
321         if (!bets[betId].isCancelled) {
322         (bets[betId].closeDateTime, bets[betId].freezeDateTime, bets[betId].isCancelled) = OracleContract(bets[betId].oracleAddress).getEventForHousePlaceBet(bets[betId].eventId);      
323         }  
324         if (!bets[betId].isOutcomeSet && bets[betId].freezeDateTime <= now) {
325             bets[betId].isCancelled = true;
326         }
327     }
328 
329     /**
330      * Get the possibleResultsCount of an Event.Output as uint.
331      * Should be changed in a future version to use an Oracle function that directly returns possibleResultsCount instead of receive the whole eventOutputs structure
332      */
333     function getEventOutputMaxUint(address oracleAddress, uint eventId, uint outputId) private view returns (uint) {
334         (bool isSet, string memory title, uint possibleResultsCount, uint  eventOutputType, string memory announcement, uint decimals) = OracleContract(oracleAddress).eventOutputs(eventId,outputId);
335         return 2 ** possibleResultsCount - 1;
336     }
337 
338 
339 function checkPayoutRate(uint256 payoutRate) public view {
340     uint256 multBase = 10 ** 18;
341     uint256 houseFees = houseData.housePercentage + houseData.oraclePercentage;
342     uint256 check1 = div(multBase , (1000 - houseFees));
343     check1 = div(mul(100000 , check1), multBase);
344     uint256 check2 = 10000;
345     if (houseFees > 0) {
346         check2 =  div(multBase , houseFees);
347         check2 = div(mul(100000 ,check2), multBase);
348     }
349     require(payoutRate>check1 && payoutRate<check2,"Payout rate out of accepted range");
350 }
351 
352 
353     /*
354      * Place a Bet
355      */
356     function placeBet(uint eventId, BetType betType,uint outputId, uint forecast, uint256 wager, uint closingDateTime, uint256 minimumWager, uint256 maximumWager, uint256 payoutRate, string memory createdBy) public {
357         require(wager>0,"Wager should be greater than zero");
358         require(balance[msg.sender]>=wager,"Not enough balance");
359         require(!houseData.newBetsPaused,"Bets are paused right now");
360         require(betType == BetType.headtohead || betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
361         betNextId += 1;
362         bets[betNextId].id = betNextId;
363         bets[betNextId].oracleAddress = houseData.oracleAddress;
364         bets[betNextId].outputId = outputId;
365         bets[betNextId].eventId = eventId;
366         bets[betNextId].betType = betType;
367         bets[betNextId].createdBy = msg.sender;
368         updateBetDataFromOracle(betNextId);
369         require(!bets[betNextId].isCancelled,"Event has been cancelled");
370         require(!bets[betNextId].isOutcomeSet,"Event has already an outcome");
371         if (closingDateTime>0) {
372             bets[betNextId].closeDateTime = closingDateTime;
373         }  
374         require(bets[betNextId].closeDateTime >= now,"Close time has passed");
375         if (betType == BetType.poolbet) {
376             if (minimumWager != 0) {
377                 bets[betNextId].minimumWager = minimumWager;
378             } else {
379                 bets[betNextId].minimumWager = wager;
380             }
381             if (maximumWager != 0) {
382                 bets[betNextId].maximumWager = maximumWager;
383             }
384         } else if (betType == BetType.headtohead) {
385             checkPayoutRate(payoutRate);
386             uint maxAcceptedForecast = getEventOutputMaxUint(bets[betNextId].oracleAddress, bets[betNextId].eventId, bets[betNextId].outputId);
387             headToHeadMaxAcceptedForecasts[betNextId] = maxAcceptedForecast;
388             require(forecast>0 && forecast < maxAcceptedForecast,"Forecast should be grater than zero and less than Max accepted forecast(All options true)");
389             bets[betNextId].payoutRate = payoutRate;
390             headToHeadForecasts[betNextId][msg.sender] = forecast;
391         }
392               
393         playerBetTotalBets[msg.sender][betNextId] = 1;
394         betTotalBets[betNextId] = 1;
395         betTotalAmount[betNextId] = wager;
396         totalBets += 1;
397         totalAmountOnBets += wager;
398         if (houseData.housePercentage>0) {
399             houseEdgeAmountForBet[betNextId] += mulByFraction(wager, houseData.housePercentage, 1000);
400         }
401         if (houseData.oraclePercentage>0) {
402             oracleEdgeAmountForBet[betNextId] += mulByFraction(wager, houseData.oraclePercentage, 1000);
403         }
404 
405         balance[msg.sender] -= wager;
406 
407  
408         betForcastTotalAmount[betNextId][forecast] = wager;
409 
410         playerBetTotalAmount[msg.sender][betNextId] = wager;
411 
412         playerBetForecastWager[msg.sender][betNextId][forecast] = wager;
413 
414         totalPlayerBets[msg.sender] += 1;
415 
416         totalPlayerBetsAmount[msg.sender] += wager;
417 
418         lastBettingActivity = block.number;
419         
420         emit BetPlacedOrModified(betNextId, msg.sender, BetEvent.placeBet, wager, forecast, createdBy, bets[betNextId].closeDateTime);
421     }  
422 
423     /*
424      * Call a Bet
425      */
426     function callBet(uint betId, uint forecast, uint256 wager, string memory createdBy) public {
427         require(wager>0,"Wager should be greater than zero");
428         require(balance[msg.sender]>=wager,"Not enough balance");
429         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
430         require(bets[betId].betType != BetType.headtohead || betTotalBets[betId] == 1,"Head to head bet has been already called");
431         require(wager>=bets[betId].minimumWager,"Wager is lower than the minimum accepted");
432         require(bets[betId].maximumWager==0 || wager<=bets[betId].maximumWager,"Wager is higher then the maximum accepted");
433         updateBetDataFromOracle(betId);
434         require(!bets[betId].isCancelled,"Bet has been cancelled");
435         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
436         require(bets[betId].closeDateTime >= now,"Close time has passed");
437         if (bets[betId].betType == BetType.headtohead) {
438             require(bets[betId].createdBy != msg.sender,"Player has been opened the bet");
439             require(wager == mulByFraction( betTotalAmount[betId], bets[betId].payoutRate - 100, 100),"Wager should be equal to [Opened bet Wager  * PayoutRate - 100]");
440             require(headToHeadForecasts[betId][bets[betId].createdBy] & forecast == 0,"Forecast overlaps opened bet forecast");
441             require(headToHeadForecasts[betId][bets[betId].createdBy] | forecast == headToHeadMaxAcceptedForecasts[betId],"Forecast should be opposite to the opened");
442             headToHeadForecasts[betId][msg.sender] = forecast;           
443         } else if (bets[betId].betType == BetType.poolbet) {
444             require(playerBetForecastWager[msg.sender][betId][forecast] == 0,"Already placed a bet on this forecast, use increaseWager method instead");
445         }
446 
447         betTotalBets[betId] += 1;
448         betTotalAmount[betId] += wager;
449         totalAmountOnBets += wager;
450         if (houseData.housePercentage>0) {
451             houseEdgeAmountForBet[betId] += mulByFraction(wager, houseData.housePercentage, 1000);
452         }
453         if (houseData.oraclePercentage>0) {
454             oracleEdgeAmountForBet[betId] += mulByFraction(wager, houseData.oraclePercentage, 1000);
455         }
456 
457 
458         balance[msg.sender] -= wager;
459 
460         playerBetTotalBets[msg.sender][betId] += 1;
461 
462         betForcastTotalAmount[betId][forecast] += wager;
463 
464         playerBetTotalAmount[msg.sender][betId] += wager;
465 
466         playerBetForecastWager[msg.sender][betId][forecast] = wager;
467 
468         totalPlayerBets[msg.sender] += 1;
469 
470         totalPlayerBetsAmount[msg.sender] += wager;
471 
472         lastBettingActivity = block.number;
473 
474         emit BetPlacedOrModified(betId, msg.sender, BetEvent.callBet, wager, forecast, createdBy, bets[betId].closeDateTime);   
475     }  
476 
477     /*
478      * Increase wager
479      */
480     function increaseWager(uint betId, uint forecast, uint256 additionalWager, string memory createdBy) public {
481         require(additionalWager>0,"Increase wager amount should be greater than zero");
482         require(balance[msg.sender]>=additionalWager,"Not enough balance");
483         require(bets[betId].betType == BetType.poolbet,"Only poolbet supports the increaseWager");
484         require(playerBetForecastWager[msg.sender][betId][forecast] > 0,"Haven't placed any bet for this forecast. Use callBet instead");
485         uint256 wager = playerBetForecastWager[msg.sender][betId][forecast] + additionalWager;
486         require(bets[betId].maximumWager==0 || wager<=bets[betId].maximumWager,"The updated wager is higher then the maximum accepted");
487         updateBetDataFromOracle(betId);
488         require(!bets[betId].isCancelled,"Bet has been cancelled");
489         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
490         require(bets[betId].closeDateTime >= now,"Close time has passed");
491         betTotalAmount[betId] += additionalWager;
492         totalAmountOnBets += additionalWager;
493         if (houseData.housePercentage>0) {
494             houseEdgeAmountForBet[betId] += mulByFraction(additionalWager, houseData.housePercentage, 1000);
495         }
496         if (houseData.oraclePercentage>0) {
497             oracleEdgeAmountForBet[betId] += mulByFraction(additionalWager, houseData.oraclePercentage, 1000);
498         }
499 
500         balance[msg.sender] -= additionalWager;
501 
502         betForcastTotalAmount[betId][forecast] += additionalWager;
503 
504         playerBetTotalAmount[msg.sender][betId] += additionalWager;
505 
506         playerBetForecastWager[msg.sender][betId][forecast] += additionalWager;
507 
508         totalPlayerBetsAmount[msg.sender] += additionalWager;
509 
510         lastBettingActivity = block.number;
511 
512         emit BetPlacedOrModified(betId, msg.sender, BetEvent.increaseWager, additionalWager, forecast, createdBy, bets[betId].closeDateTime);       
513     }
514 
515     /*
516      * Remove a Bet
517      */
518     function removeBet(uint betId, string memory createdBy) public {
519         require(bets[betId].createdBy == msg.sender,"Caller and player created don't match");
520         require(playerBetTotalBets[msg.sender][betId] > 0, "Player should has placed at least one bet");
521         require(betTotalBets[betId] == playerBetTotalBets[msg.sender][betId],"The bet has been called by other player");
522         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
523         updateBetDataFromOracle(betId);  
524         bets[betId].isCancelled = true;
525         uint256 wager = betTotalAmount[betId];
526         betTotalBets[betId] = 0;
527         betTotalAmount[betId] = 0;
528         totalBets -= playerBetTotalBets[msg.sender][betId];
529         totalAmountOnBets -= wager;
530         houseEdgeAmountForBet[betId] = 0;
531         oracleEdgeAmountForBet[betId] = 0;
532         balance[msg.sender] += wager;
533         playerBetTotalAmount[msg.sender][betId] = 0;
534         totalPlayerBets[msg.sender] -= playerBetTotalBets[msg.sender][betId];
535         totalPlayerBetsAmount[msg.sender] -= wager;
536         playerBetTotalBets[msg.sender][betId] = 0;
537         lastBettingActivity = block.number;       
538         emit BetPlacedOrModified(betId, msg.sender, BetEvent.removeBet, wager, 0, createdBy, bets[betId].closeDateTime);      
539     } 
540 
541     /*
542      * Refute a Bet
543      */
544     function refuteBet(uint betId, string memory createdBy) public {
545         require(playerBetTotalAmount[msg.sender][betId]>0,"Caller hasn't placed any bet");
546         require(!playerBetRefuted[msg.sender][betId],"Already refuted");
547         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
548         updateBetDataFromOracle(betId);  
549         require(bets[betId].isOutcomeSet, "Refute isn't allowed when no outcome has been set");
550         require(bets[betId].freezeDateTime > now, "Refute isn't allowed when Event freeze has passed");
551         playerBetRefuted[msg.sender][betId] = true;
552         betRefutedAmount[betId] += playerBetTotalAmount[msg.sender][betId];
553         if (betRefutedAmount[betId] >= betTotalAmount[betId]) {
554             bets[betId].isCancelled = true;   
555         }
556         lastBettingActivity = block.number;       
557         emit BetPlacedOrModified(betId, msg.sender, BetEvent.refuteBet, 0, 0, createdBy, bets[betId].closeDateTime);    
558     } 
559 
560 
561     /*
562      * Settle a Bet
563      */
564     function settleBet(uint betId, string memory createdBy) public {
565         require(playerBetTotalAmount[msg.sender][betId]>0, "Caller hasn't placed any bet");
566         require(!playerBetSettled[msg.sender][betId],"Already settled");
567         require(bets[betId].betType == BetType.headtohead || bets[betId].betType == BetType.poolbet,"Only poolbet and headtohead bets are implemented");
568         updateBetDataFromOracle(betId);
569         require(bets[betId].isCancelled || bets[betId].isOutcomeSet,"Bet should be cancelled or has an outcome");
570         require(bets[betId].freezeDateTime <= now,"Bet payments are freezed");
571         BetEvent betEvent;
572         if (bets[betId].isCancelled) {
573             betEvent = BetEvent.settleCancelledBet;
574             houseEdgeAmountForBet[betId] = 0;
575             oracleEdgeAmountForBet[betId] = 0;
576             playerOutputFromBet[msg.sender][betId] = playerBetTotalAmount[msg.sender][betId];            
577         } else {
578             if (!housePaid[betId] && houseEdgeAmountForBet[betId] > 0) {
579                 for (uint i = 0; i<owners.length; i++) {
580                     balance[owners[i]] += mulByFraction(houseEdgeAmountForBet[betId], ownerPerc[owners[i]], 1000);
581                 }
582                 houseTotalFees += houseEdgeAmountForBet[betId];
583             }   
584             if (!housePaid[betId] && oracleEdgeAmountForBet[betId] > 0) {
585                 address oracleOwner = HouseContract(bets[betId].oracleAddress).owner();
586                 balance[oracleOwner] += oracleEdgeAmountForBet[betId];
587                 oracleTotalFees[bets[betId].oracleAddress] += oracleEdgeAmountForBet[betId];
588             }
589             housePaid[betId] = true;
590             uint256 totalBetAmountAfterFees = betTotalAmount[betId] - houseEdgeAmountForBet[betId] - oracleEdgeAmountForBet[betId];
591             if (bets[betId].betType == BetType.poolbet) {
592                 if (betForcastTotalAmount[betId][bets[betId].outcome]>0) {                  
593                     playerOutputFromBet[msg.sender][betId] = mulByFraction(totalBetAmountAfterFees, playerBetForecastWager[msg.sender][betId][bets[betId].outcome], betForcastTotalAmount[betId][bets[betId].outcome]);            
594                 } else {
595                     playerOutputFromBet[msg.sender][betId] = playerBetTotalAmount[msg.sender][betId] - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.housePercentage, 1000) - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.oraclePercentage, 1000);
596                 }
597             } else if (bets[betId].betType == BetType.headtohead) {
598                 if (headToHeadForecasts[betId][msg.sender] & (2 ** bets[betId].outcome) > 0) {
599                     playerOutputFromBet[msg.sender][betId] = totalBetAmountAfterFees;
600                 } else {
601                     playerOutputFromBet[msg.sender][betId] = 0;
602                 }
603             }
604             require(playerOutputFromBet[msg.sender][betId] > 0,"Settled amount should be grater than zero");
605             betEvent = BetEvent.settleWinnedBet;
606         }      
607         playerBetSettled[msg.sender][betId] = true;
608         balance[msg.sender] += playerOutputFromBet[msg.sender][betId];
609         lastBettingActivity = block.number;
610         emit BetPlacedOrModified(betId, msg.sender, betEvent, playerOutputFromBet[msg.sender][betId],0, createdBy, bets[betId].closeDateTime);  
611     } 
612 
613     function() external payable {
614         balance[msg.sender] = add(balance[msg.sender],msg.value);
615         emit transfer(msg.sender,msg.value,true);
616     }
617 
618 
619     /**
620     * Checks if a player has betting activity on House 
621     */
622     function isPlayer(address playerAddress) public view returns(bool) {
623         return (totalPlayerBets[playerAddress] > 0);
624     }
625 
626     /**
627     * Update House short message 
628     */
629     function updateShortMessage(string memory shortMessage) onlyOwner public {
630         houseData.shortMessage = shortMessage;
631         emit HousePropertiesUpdated();
632     }
633 
634 
635     /**
636     * Starts betting
637     */
638     function startNewBets(string memory shortMessage) onlyOwner public {
639         houseData.shortMessage = shortMessage;
640         houseData.newBetsPaused = false;
641         emit HousePropertiesUpdated();
642     }
643 
644     /**
645     * Pauses betting
646     */
647     function stopNewBets(string memory shortMessage) onlyOwner public {
648         houseData.shortMessage = shortMessage;
649         houseData.newBetsPaused = true;
650         emit HousePropertiesUpdated();
651     }
652 
653     /**
654     * Link House to a new version
655     */
656     function linkToNewHouse(address newHouseAddress) onlyOwner public {
657         require(newHouseAddress!=address(this),"New address is current address");
658         require(HouseContract(newHouseAddress).isHouse(),"New address should be a House smart contract");
659         _newHouseAddress = newHouseAddress;
660         houseData.newBetsPaused = true;
661         emit HousePropertiesUpdated();
662     }
663 
664     /**
665     * UnLink House from a newer version
666     */
667     function unLinkNewHouse() onlyOwner public {
668         _newHouseAddress = address(0);
669         houseData.newBetsPaused = false;
670         emit HousePropertiesUpdated();
671     }
672 
673     /**
674     * Cancels a Bet
675     */
676     function cancelBet(uint betId) onlyOwner public {
677         require(houseData.managed, "Cancel available on managed Houses");
678         updateBetDataFromOracle(betId);
679         require(bets[betId].freezeDateTime > now,"Freeze time passed");       
680         bets[betId].isCancelled = true;
681         emit BetPlacedOrModified(betId, msg.sender, BetEvent.cancelledByHouse, 0, 0, "", bets[betId].closeDateTime);  
682     }
683 
684     /**
685     * Settle fees of Oracle and House for a bet
686     */
687     function settleBetFees(uint betId) onlyOwner public {
688         require(bets[betId].isCancelled || bets[betId].isOutcomeSet,"Bet should be cancelled or has an outcome");
689         require(bets[betId].freezeDateTime <= now,"Bet payments are freezed");
690         if (!housePaid[betId] && houseEdgeAmountForBet[betId] > 0) {
691             for (uint i = 0; i<owners.length; i++) {
692                 balance[owners[i]] += mulByFraction(houseEdgeAmountForBet[betId], ownerPerc[owners[i]], 1000);
693             }
694             houseTotalFees += houseEdgeAmountForBet[betId];
695         }   
696         if (!housePaid[betId] && oracleEdgeAmountForBet[betId] > 0) {
697             address oracleOwner = HouseContract(bets[betId].oracleAddress).owner();
698             balance[oracleOwner] += oracleEdgeAmountForBet[betId];
699             oracleTotalFees[bets[betId].oracleAddress] += oracleEdgeAmountForBet[betId];
700         }
701         housePaid[betId] = true;
702     }
703 
704     /**
705     * Withdraw the requested amount to the sender address
706     */
707     function withdraw(uint256 amount) public {
708         require(address(this).balance>=amount,"Insufficient House balance. Shouldn't have happened");
709         require(balance[msg.sender]>=amount,"Insufficient balance");
710         balance[msg.sender] = sub(balance[msg.sender],amount);
711         msg.sender.transfer(amount);
712         emit transfer(msg.sender,amount,false);
713     }
714 
715     /**
716     * Withdraw the requested amount to an address
717     */
718     function withdrawToAddress(address payable destinationAddress,uint256 amount) public {
719         require(address(this).balance>=amount);
720         require(balance[msg.sender]>=amount,"Insufficient balance");
721         balance[msg.sender] = sub(balance[msg.sender],amount);
722         destinationAddress.transfer(amount);
723         emit transfer(msg.sender,amount,false);
724     }
725 
726 }