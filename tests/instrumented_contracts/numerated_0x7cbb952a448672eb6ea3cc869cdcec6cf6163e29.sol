1 /*
2  * Kryptium House Smart Contract v.1.0.0
3  * Copyright © 2018 Kryptium Team <info@kryptium.io>
4  * Author: Giannis Zarifis <jzarifis@kryptium.io>
5  * 
6  * A decentralised betting house in the form of an Ethereum smart contract which 
7  * registers bets, escrows the amounts wagered and transfers funds following the 
8  * outcomes of the corresponding events. It can be fully autonomous or managed 
9  * and might charge a commission for its services.
10  *
11  * This program is free to use according the Terms and Conditions available at
12  * <https://kryptium.io/terms-and-conditions/>. You cannot resell it or copy any
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
79     function owner() external view returns (address);
80     function getEventForHousePlaceBet(uint id) external view returns (uint closeDateTime, uint freezeDateTime, bool isCancelled); 
81     function getEventOutcomeIsSet(uint eventId, uint outputId) external view returns (bool isSet);
82     function getEventOutcome(uint eventId, uint outputId) external view returns (uint outcome); 
83     function getEventOutcomeNumeric(uint eventId, uint outputId) external view returns(uint256 outcome1, uint256 outcome2,uint256 outcome3,uint256 outcome4, uint256 outcome5, uint256 outcome6);
84 }
85 
86 /*
87 House smart contract interface
88 */
89 interface HouseContract {
90     function owner() external view returns (address); 
91     function isHouse() external view returns (bool); 
92 }
93 
94 
95 
96 /*
97  * Kryptium House Smart Contract.
98  */
99 contract House is SafeMath, Owned {
100 
101     //enum Category { football, basket }
102 
103     enum BetType { headtohead, multiuser, poolbet }
104 
105     enum BetEvent { placeBet, callBet, removeBet, refuteBet, settleWinnedBet, settleCancelledBet, increaseWager, cancelledByHouse }
106 
107     uint private betNextId;
108 
109     struct Bet { 
110         uint id;
111         address oracleAddress;
112         uint eventId;
113         uint outputId;
114         uint outcome;
115         bool isOutcomeSet;
116         uint closeDateTime;
117         uint freezeDateTime;
118         bool isCancelled;
119         uint256 minimumWager;
120         uint256 maximumWager;
121         uint256 payoutRate;
122         address createdBy;
123         BetType betType;
124     } 
125 
126 
127     struct HouseData { 
128         bool managed;
129         string  name;
130         string  creatorName;
131         string  countryISO; 
132         address oracleAddress;
133         address oldOracleAddress;       
134         bool  newBetsPaused;
135         uint  housePercentage;
136         uint oraclePercentage;   
137         uint version;
138         string shortMessage;              
139     } 
140 
141     address public _newHouseAddress;
142 
143     HouseData public houseData;  
144 
145     // This creates an array with all bets
146     mapping (uint => Bet) public bets;
147 
148     //Total bets
149     uint public totalBets;
150 
151     //Total amount played on bets
152     uint public totalAmountOnBets;
153 
154     //Total amount on Bet
155     mapping (uint => uint256) public betTotalAmount;
156 
157     //Totalbets on bet
158     mapping (uint => uint) public betTotalBets;
159 
160     //Bet Refutes amount
161     mapping (uint => uint256) public betRefutedAmount;
162 
163     //Total amount placed on a bet forecast
164     mapping (uint => mapping (uint => uint256)) public betForcastTotalAmount;    
165 
166     //Player bet total amount on a Bet
167     mapping (address => mapping (uint => uint256)) public playerBetTotalAmount;
168 
169     //Player bet total bets on a Bet
170     mapping (address => mapping (uint => uint)) public playerBetTotalBets;
171 
172     //Player wager for a Bet.Output.Forecast
173     mapping (address => mapping (uint => mapping (uint => uint256))) public playerBetForecastWager;
174 
175     //Player output(cause or win or refund)  of a bet
176     mapping (address => mapping (uint => uint256)) public playerOutputFromBet;    
177 
178     //Player bet Refuted
179     mapping (address => mapping (uint => bool)) public playerBetRefuted;    
180 
181     //Player bet Settled
182     mapping (address => mapping (uint => bool)) public playerBetSettled; 
183 
184 
185     //Total bets placed by player
186     mapping (address => uint) public totalPlayerBets;
187 
188 
189     //Total amount placed for bets by player
190     mapping (address => uint256) public totalPlayerBetsAmount;
191 
192     // User balances
193     mapping (address => uint256) public balance;
194 
195     // Stores the house owners percentage as part per thousand 
196     mapping (address => uint) public ownerPerc;
197 
198     //The array of house owners
199     address[] public owners;
200 
201     //The House and Oracle edge has been paid
202     mapping (uint => bool) public housePaid;
203 
204     //The total remaining House amount collected from fees for Bet
205     mapping (uint => uint256) public houseEdgeAmountForBet;
206 
207     //The total remaining Oracle amount collected from fees for Bet
208     mapping (uint => uint256) public oracleEdgeAmountForBet;
209 
210     //The total House fees
211     uint256 public houseTotalFees;
212 
213     //The total Oracle fees
214     mapping (address => uint256) public oracleTotalFees;
215 
216     // Notifies clients that a new house is launched
217     event HouseCreated();
218 
219     // Notifies clients that a house data has changed
220     event HousePropertiesUpdated();    
221 
222     event BetPlacedOrModified(uint id, address sender, BetEvent betEvent, uint256 amount, uint forecast, string createdBy, uint closeDateTime);
223 
224 
225     event transfer(address indexed wallet, uint256 amount,bool inbound);
226 
227 
228     /**
229      * Constructor function
230      * Initializes House contract
231      */
232     constructor(bool managed, string memory houseName, string memory houseCreatorName, string memory houseCountryISO, address oracleAddress, address[] memory ownerAddress, uint[] memory ownerPercentage, uint housePercentage,uint oraclePercentage, uint version) public {
233         require(add(housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
234         houseData.managed = managed;
235         houseData.name = houseName;
236         houseData.creatorName = houseCreatorName;
237         houseData.countryISO = houseCountryISO;
238         houseData.housePercentage = housePercentage;
239         houseData.oraclePercentage = oraclePercentage; 
240         houseData.oracleAddress = oracleAddress;
241         houseData.shortMessage = "";
242         houseData.newBetsPaused = true;
243         houseData.version = version;
244         uint ownersTotal = 0;
245         for (uint i = 0; i<ownerAddress.length; i++) {
246             owners.push(ownerAddress[i]);
247             ownerPerc[ownerAddress[i]] = ownerPercentage[i];
248             ownersTotal += ownerPercentage[i];
249             }
250         require(ownersTotal == 1000);    
251         emit HouseCreated();
252     }
253 
254     /**
255      * Check if valid house contract
256      */
257     function isHouse() public pure returns(bool response) {
258         return true;    
259     }
260 
261      /**
262      * Updates House Data function
263      *
264      */
265     function updateHouseProperties(string memory houseName, string memory houseCreatorName, string memory houseCountryISO) onlyOwner public {
266         houseData.name = houseName;
267         houseData.creatorName = houseCreatorName;
268         houseData.countryISO = houseCountryISO;     
269         emit HousePropertiesUpdated();
270     }    
271 
272     /**
273      * Updates House Oracle function
274      *
275      */
276     function changeHouseOracle(address oracleAddress, uint oraclePercentage) onlyOwner public {
277         require(add(houseData.housePercentage,oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
278         if (oracleAddress != houseData.oracleAddress) {
279             houseData.oldOracleAddress = houseData.oracleAddress;
280             houseData.oracleAddress = oracleAddress;
281         }
282         houseData.oraclePercentage = oraclePercentage;
283         emit HousePropertiesUpdated();
284     } 
285 
286     /**
287      * Updates House percentage function
288      *
289      */
290     function changeHouseEdge(uint housePercentage) onlyOwner public {
291         require(housePercentage != houseData.housePercentage,"New percentage is identical with current");
292         require(add(housePercentage,houseData.oraclePercentage)<1000,"House + Oracle percentage should be lower than 100%");
293         houseData.housePercentage = housePercentage;
294         emit HousePropertiesUpdated();
295     } 
296 
297 
298     function updateBetDataFromOracle(uint betId) private {
299         if (!bets[betId].isOutcomeSet) {
300             (bets[betId].isOutcomeSet) = OracleContract(bets[betId].oracleAddress).getEventOutcomeIsSet(bets[betId].eventId,bets[betId].outputId); 
301             if (bets[betId].isOutcomeSet) {
302                 (bets[betId].outcome) = OracleContract(bets[betId].oracleAddress).getEventOutcome(bets[betId].eventId,bets[betId].outputId); 
303             }
304         }     
305         if (!bets[betId].isCancelled) {
306         (bets[betId].closeDateTime, bets[betId].freezeDateTime, bets[betId].isCancelled) = OracleContract(bets[betId].oracleAddress).getEventForHousePlaceBet(bets[betId].eventId);      
307         }  
308         if (!bets[betId].isOutcomeSet && bets[betId].freezeDateTime <= now) {
309             bets[betId].isCancelled = true;
310         }
311     }
312 
313 
314     /*
315      * Place a Bet
316      */
317     function placeBet(uint eventId, BetType betType,uint outputId, uint forecast, uint256 wager, uint closingDateTime, uint256 minimumWager, uint256 maximumWager, uint256 payoutRate, string memory createdBy) public {
318         require(wager>0,"Wager should be greater than zero");
319         require(balance[msg.sender]>=wager,"Not enough balance");
320         require(!houseData.newBetsPaused,"Bets are paused right now");
321         betNextId += 1;
322         bets[betNextId].id = betNextId;
323         bets[betNextId].oracleAddress = houseData.oracleAddress;
324         bets[betNextId].outputId = outputId;
325         bets[betNextId].eventId = eventId;
326         bets[betNextId].betType = betType;
327         bets[betNextId].createdBy = msg.sender;
328         updateBetDataFromOracle(betNextId);
329         require(!bets[betNextId].isCancelled,"Event has been cancelled");
330         require(!bets[betNextId].isOutcomeSet,"Event has already an outcome");
331         if (closingDateTime>0) {
332             bets[betNextId].closeDateTime = closingDateTime;
333         }  
334         require(bets[betNextId].closeDateTime >= now,"Close time has passed");
335         if (minimumWager != 0) {
336             bets[betNextId].minimumWager = minimumWager;
337         } else {
338             bets[betNextId].minimumWager = wager;
339         }
340         if (maximumWager != 0) {
341             bets[betNextId].maximumWager = maximumWager;
342         }
343         if (payoutRate != 0) {
344             bets[betNextId].payoutRate = payoutRate;
345         }       
346 
347         playerBetTotalBets[msg.sender][betNextId] = 1;
348         betTotalBets[betNextId] = 1;
349         betTotalAmount[betNextId] = wager;
350         totalBets += 1;
351         totalAmountOnBets += wager;
352         if (houseData.housePercentage>0) {
353             houseEdgeAmountForBet[betNextId] += mulByFraction(wager, houseData.housePercentage, 1000);
354         }
355         if (houseData.oraclePercentage>0) {
356             oracleEdgeAmountForBet[betNextId] += mulByFraction(wager, houseData.oraclePercentage, 1000);
357         }
358 
359         balance[msg.sender] -= wager;
360 
361  
362         betForcastTotalAmount[betNextId][forecast] = wager;
363 
364         playerBetTotalAmount[msg.sender][betNextId] = wager;
365 
366         playerBetForecastWager[msg.sender][betNextId][forecast] = wager;
367 
368         totalPlayerBets[msg.sender] += 1;
369 
370         totalPlayerBetsAmount[msg.sender] += wager;
371 
372         emit BetPlacedOrModified(betNextId, msg.sender, BetEvent.placeBet, wager, forecast, createdBy, bets[betNextId].closeDateTime);
373     }  
374 
375     /*
376      * Call a Bet
377      */
378     function callBet(uint betId, uint forecast, uint256 wager, string memory createdBy) public {
379         require(wager>0,"Wager should be greater than zero");
380         require(balance[msg.sender]>=wager,"Not enough balance");
381         require(playerBetForecastWager[msg.sender][betId][forecast] == 0,"Already placed a bet for this forecast, use increaseWager method instead");
382         require(bets[betId].betType != BetType.headtohead || betTotalBets[betId] == 1,"Head to head bet has been already called");
383         require(wager>=bets[betId].minimumWager,"Wager is lower than the minimum accepted");
384         require(bets[betId].maximumWager==0 || wager<=bets[betId].maximumWager,"Wager is higher then the maximum accepted");
385         updateBetDataFromOracle(betId);
386         require(!bets[betId].isCancelled,"Bet has been cancelled");
387         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
388         require(bets[betId].closeDateTime >= now,"Close time has passed");
389         betTotalBets[betId] += 1;
390         betTotalAmount[betId] += wager;
391         totalAmountOnBets += wager;
392         if (houseData.housePercentage>0) {
393             houseEdgeAmountForBet[betId] += mulByFraction(wager, houseData.housePercentage, 1000);
394         }
395         if (houseData.oraclePercentage>0) {
396             oracleEdgeAmountForBet[betId] += mulByFraction(wager, houseData.oraclePercentage, 1000);
397         }
398 
399         balance[msg.sender] -= wager;
400 
401         playerBetTotalBets[msg.sender][betId] += 1;
402 
403         betForcastTotalAmount[betId][forecast] += wager;
404 
405         playerBetTotalAmount[msg.sender][betId] += wager;
406 
407         playerBetForecastWager[msg.sender][betId][forecast] = wager;
408 
409         totalPlayerBets[msg.sender] += 1;
410 
411         totalPlayerBetsAmount[msg.sender] += wager;
412 
413         emit BetPlacedOrModified(betId, msg.sender, BetEvent.callBet, wager, forecast, createdBy, bets[betId].closeDateTime);   
414     }  
415 
416     /*
417      * Increase wager
418      */
419     function increaseWager(uint betId, uint forecast, uint256 additionalWager, string memory createdBy) public {
420         require(additionalWager>0,"Increase wager amount should be greater than zero");
421         require(balance[msg.sender]>=additionalWager,"Not enough balance");
422         require(playerBetForecastWager[msg.sender][betId][forecast] > 0,"Haven't placed any bet for this forecast. Use callBet instead");
423         require(bets[betId].betType != BetType.headtohead || betTotalBets[betId] == 1,"Head to head bet has been already called");
424         uint256 wager = playerBetForecastWager[msg.sender][betId][forecast] + additionalWager;
425         require(bets[betId].maximumWager==0 || wager<=bets[betId].maximumWager,"The updated wager is higher then the maximum accepted");
426         updateBetDataFromOracle(betId);
427         require(!bets[betId].isCancelled,"Bet has been cancelled");
428         require(!bets[betId].isOutcomeSet,"Event has already an outcome");
429         require(bets[betId].closeDateTime >= now,"Close time has passed");
430         betTotalAmount[betId] += additionalWager;
431         totalAmountOnBets += additionalWager;
432         if (houseData.housePercentage>0) {
433             houseEdgeAmountForBet[betId] += mulByFraction(additionalWager, houseData.housePercentage, 1000);
434         }
435         if (houseData.oraclePercentage>0) {
436             oracleEdgeAmountForBet[betId] += mulByFraction(additionalWager, houseData.oraclePercentage, 1000);
437         }
438 
439         balance[msg.sender] -= additionalWager;
440 
441         betForcastTotalAmount[betId][forecast] += additionalWager;
442 
443         playerBetTotalAmount[msg.sender][betId] += additionalWager;
444 
445         playerBetForecastWager[msg.sender][betId][forecast] += additionalWager;
446 
447         totalPlayerBetsAmount[msg.sender] += additionalWager;
448 
449         emit BetPlacedOrModified(betId, msg.sender, BetEvent.increaseWager, additionalWager, forecast, createdBy, bets[betId].closeDateTime);       
450     }
451 
452     /*
453      * Remove a Bet
454      */
455     function removeBet(uint betId, string memory createdBy) public {
456         require(bets[betId].createdBy == msg.sender,"Caller and player created don't match");
457         require(playerBetTotalBets[msg.sender][betId] > 0, "Player should has placed at least one bet");
458         require(betTotalBets[betId] == playerBetTotalBets[msg.sender][betId],"The bet has been called by other player");
459         updateBetDataFromOracle(betId);  
460         bets[betId].isCancelled = true;
461         uint256 wager = betTotalAmount[betId];
462         betTotalBets[betId] = 0;
463         betTotalAmount[betId] = 0;
464         totalBets -= playerBetTotalBets[msg.sender][betId];
465         totalAmountOnBets -= wager;
466         houseEdgeAmountForBet[betId] = 0;
467         oracleEdgeAmountForBet[betId] = 0;
468         balance[msg.sender] += wager;
469         playerBetTotalAmount[msg.sender][betId] = 0;
470         totalPlayerBets[msg.sender] -= playerBetTotalBets[msg.sender][betId];
471         totalPlayerBetsAmount[msg.sender] -= wager;
472         playerBetTotalBets[msg.sender][betId] = 0;
473         emit BetPlacedOrModified(betId, msg.sender, BetEvent.removeBet, wager, 0, createdBy, bets[betId].closeDateTime);      
474     } 
475 
476     /*
477      * Refute a Bet
478      */
479     function refuteBet(uint betId, string memory createdBy) public {
480         require(playerBetTotalAmount[msg.sender][betId]>0,"Caller hasn't placed any bet");
481         require(!playerBetRefuted[msg.sender][betId],"Already refuted");
482         updateBetDataFromOracle(betId);  
483         require(bets[betId].isOutcomeSet, "Refute isn't allowed when no outcome has been set");
484         require(bets[betId].freezeDateTime > now, "Refute isn't allowed when Event freeze has passed");
485         playerBetRefuted[msg.sender][betId] = true;
486         betRefutedAmount[betId] += playerBetTotalAmount[msg.sender][betId];
487         if (betRefutedAmount[betId] >= betTotalAmount[betId]) {
488             bets[betId].isCancelled = true;   
489         }
490         emit BetPlacedOrModified(betId, msg.sender, BetEvent.refuteBet, 0, 0, createdBy, bets[betId].closeDateTime);    
491     } 
492 
493     /*
494      * Calculates bet outcome for player
495      */
496     function calculateBetOutcome(uint betId, bool isCancelled, uint forecast) public view returns (uint256 betOutcome) {
497         require(playerBetTotalAmount[msg.sender][betId]>0, "Caller hasn't placed any bet");
498         if (isCancelled) {
499             return playerBetTotalAmount[msg.sender][betId];            
500         } else {
501             if (betForcastTotalAmount[betId][forecast]>0) {
502                 uint256 totalBetAmountAfterFees = betTotalAmount[betId] - houseEdgeAmountForBet[betId] - oracleEdgeAmountForBet[betId];
503                 return mulByFraction(totalBetAmountAfterFees, playerBetForecastWager[msg.sender][betId][forecast], betForcastTotalAmount[betId][forecast]);            
504             } else {
505                 return playerBetTotalAmount[msg.sender][betId] - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.housePercentage, 1000) - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.oraclePercentage, 1000);
506             }
507         }
508     }
509 
510     /*
511      * Settle a Bet
512      */
513     function settleBet(uint betId, string memory createdBy) public {
514         require(playerBetTotalAmount[msg.sender][betId]>0, "Caller hasn't placed any bet");
515         require(!playerBetSettled[msg.sender][betId],"Already settled");
516         updateBetDataFromOracle(betId);
517         require(bets[betId].isCancelled || bets[betId].isOutcomeSet,"Bet should be cancelled or has an outcome");
518         require(bets[betId].freezeDateTime <= now,"Bet payments are freezed");
519         BetEvent betEvent;
520         if (bets[betId].isCancelled) {
521             betEvent = BetEvent.settleCancelledBet;
522             houseEdgeAmountForBet[betId] = 0;
523             oracleEdgeAmountForBet[betId] = 0;
524             playerOutputFromBet[msg.sender][betId] = playerBetTotalAmount[msg.sender][betId];            
525         } else {
526             if (!housePaid[betId] && houseEdgeAmountForBet[betId] > 0) {
527                 for (uint i = 0; i<owners.length; i++) {
528                     balance[owners[i]] += mulByFraction(houseEdgeAmountForBet[betId], ownerPerc[owners[i]], 1000);
529                 }
530                 houseTotalFees += houseEdgeAmountForBet[betId];
531             }   
532             if (!housePaid[betId] && oracleEdgeAmountForBet[betId] > 0) {
533                 address oracleOwner = HouseContract(bets[betId].oracleAddress).owner();
534                 balance[oracleOwner] += oracleEdgeAmountForBet[betId];
535                 oracleTotalFees[bets[betId].oracleAddress] += oracleEdgeAmountForBet[betId];
536             }
537             if (betForcastTotalAmount[betId][bets[betId].outcome]>0) {
538                 uint256 totalBetAmountAfterFees = betTotalAmount[betId] - houseEdgeAmountForBet[betId] - oracleEdgeAmountForBet[betId];
539                 playerOutputFromBet[msg.sender][betId] = mulByFraction(totalBetAmountAfterFees, playerBetForecastWager[msg.sender][betId][bets[betId].outcome], betForcastTotalAmount[betId][bets[betId].outcome]);            
540             } else {
541                 playerOutputFromBet[msg.sender][betId] = playerBetTotalAmount[msg.sender][betId] - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.housePercentage, 1000) - mulByFraction(playerBetTotalAmount[msg.sender][betId], houseData.oraclePercentage, 1000);
542             }
543             if (playerOutputFromBet[msg.sender][betId] > 0) {
544                 betEvent = BetEvent.settleWinnedBet;
545             }
546         }
547         housePaid[betId] = true;
548         playerBetSettled[msg.sender][betId] = true;
549         balance[msg.sender] += playerOutputFromBet[msg.sender][betId];
550         emit BetPlacedOrModified(betId, msg.sender, betEvent, playerOutputFromBet[msg.sender][betId],0, createdBy, bets[betId].closeDateTime);  
551     } 
552 
553     function() external payable {
554         balance[msg.sender] = add(balance[msg.sender],msg.value);
555         emit transfer(msg.sender,msg.value,true);
556     }
557 
558 
559     /**
560     * Checks if a player has betting activity on House 
561     */
562     function isPlayer(address playerAddress) public view returns(bool) {
563         return (totalPlayerBets[playerAddress] > 0);
564     }
565 
566     function updateShortMessage(string memory shortMessage) onlyOwner public {
567         houseData.shortMessage = shortMessage;
568         emit HousePropertiesUpdated();
569     }
570 
571     function startNewBets(string memory shortMessage) onlyOwner public {
572         houseData.shortMessage = shortMessage;
573         houseData.newBetsPaused = false;
574         emit HousePropertiesUpdated();
575     }
576 
577     function stopNewBets(string memory shortMessage) onlyOwner public {
578         houseData.shortMessage = shortMessage;
579         houseData.newBetsPaused = true;
580         emit HousePropertiesUpdated();
581     }
582 
583     function linkToNewHouse(address newHouseAddress) onlyOwner public {
584         require(newHouseAddress!=address(this),"New address is current address");
585         require(HouseContract(newHouseAddress).isHouse(),"New address should be a House smart contract");
586         _newHouseAddress = newHouseAddress;
587         houseData.newBetsPaused = true;
588         emit HousePropertiesUpdated();
589     }
590 
591     function unLinkNewHouse() onlyOwner public {
592         _newHouseAddress = address(0);
593         houseData.newBetsPaused = false;
594         emit HousePropertiesUpdated();
595     }
596 
597     function cancelBet(uint betId) onlyOwner public {
598         require(bets[betId].freezeDateTime > now,"Freeze time passed");
599         require(houseData.managed, "Cancel available on managed Houses");
600         bets[betId].isCancelled = true;
601         emit BetPlacedOrModified(betId, msg.sender, BetEvent.cancelledByHouse, 0, 0, "", bets[betId].closeDateTime);  
602     }
603 
604 
605     function withdraw(uint256 amount) public {
606         require(address(this).balance>=amount,"Insufficient House balance. Shouldn't have happened");
607         require(balance[msg.sender]>=amount,"Insufficient balance");
608         balance[msg.sender] = sub(balance[msg.sender],amount);
609         msg.sender.transfer(amount);
610         emit transfer(msg.sender,amount,false);
611     }
612 
613     function withdrawToAddress(address payable destinationAddress,uint256 amount) public {
614         require(address(this).balance>=amount);
615         require(balance[msg.sender]>=amount,"Insufficient balance");
616         balance[msg.sender] = sub(balance[msg.sender],amount);
617         destinationAddress.transfer(amount);
618         emit transfer(msg.sender,amount,false);
619     }
620 
621 }