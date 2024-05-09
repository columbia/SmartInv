1 pragma solidity
2 ^0.4.21;
3 
4 /*
5 http://www.cryptophoenixes.fun/
6 CryptoPhoenixes: Civil War Edition
7 
8 Original game design and website development by Anyhowclick.
9 Art design by Tilly.
10 */
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 }
36 
37 /**
38  * @title Pausable
39  * @dev Base contract which allows children to implement an emergency stop mechanism.
40  */
41 contract Pausable is Ownable {
42   event Pause();
43   event Unpause();
44 
45   bool public paused = false;
46 
47 
48   /**
49    * @dev Modifier to make a function callable only when the contract is not paused.
50    */
51   modifier whenNotPaused() {
52     require(!paused);
53     _;
54   }
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is paused.
58    */
59   modifier whenPaused() {
60     require(paused);
61     _;
62   }
63 
64   /**
65    * @dev called by the owner to pause, triggers stopped state
66    */
67   function pause() onlyOwner whenNotPaused public {
68     paused = true;
69     emit Pause();
70   }
71 
72   /**
73    * @dev called by the owner to unpause, returns to normal state
74    */
75   function unpause() onlyOwner whenPaused public {
76     paused = false;
77     emit Unpause();
78   }
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a * b;
88     assert(a == 0 || c / a == b);
89     return c;
90   }
91 
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103   
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 contract CryptoPhoenixesCivilWar is Ownable, Pausable {
112   using SafeMath for uint256;
113 
114   address public subDevOne;
115   address public subDevTwo;
116   
117   Phoenix[] public PHOENIXES;
118   /*
119   id 0: Rainbow Phoenix
120   ids 1-2: Red / Blue capt respectively
121   ids 3-6: Red bombers
122   ids 7-10: Red thieves
123   ids 11-14: Blue bombers
124   ids 15-18: Blue thieves
125   */
126   
127   uint256 public DENOMINATOR = 10000; //Eg explosivePower = 300 -> 3%
128   
129   uint256[2] public POOLS; //0 = red, 1 = blue
130   uint256[2] public SCORES; //0 = red, 1 = blue
131   
132   bool public GAME_STARTED = false;
133   uint public GAME_END = 0;
134   
135   // devFunds
136   mapping (address => uint256) public devFunds;
137 
138   // userFunds
139   mapping (address => uint256) public userFunds;
140 
141   // Constant
142   uint256 constant public BASE_PRICE = 0.0025 ether;
143   
144   //Permission control
145   modifier onlyAuthorized() {
146       require(msg.sender == owner || msg.sender == subDevOne); //subDevTwo is NOT authorized
147       _;
148   }
149   
150   //to check that a game has ended
151   modifier gameHasEnded() {
152       require(GAME_STARTED); //Check if a game was started in the first place
153       require(now >= GAME_END); //Check if game has ended
154       _;
155   }
156   
157   //to check that a game is in progress
158   modifier gameInProgress() {
159       require(GAME_STARTED);
160       require(now <= GAME_END);
161       _;
162   }
163   
164   //to check the reverse, that no game is in progress
165   modifier noGameInProgress() {
166       require(!GAME_STARTED);
167       _;
168   }
169   
170   // Events
171   event GameStarted();
172       
173   event PhoenixPurchased(
174       uint256 phoenixID,
175       address newOwner,
176       uint256 price,
177       uint256 nextPrice,
178       uint256 currentPower,
179       uint abilityAvailTime
180   );
181 
182   event CaptainAbilityUsed(
183       uint256 captainID
184   );
185   
186   event PhoenixAbilityUsed(
187       uint256 phoenixID,
188       uint256 payout,
189       uint256 price,
190       uint256 currentPower,
191       uint abilityAvailTime,
192       address previousOwner
193   );
194   
195   event GameEnded();
196 
197   event WithdrewFunds(
198     address owner
199   );
200   
201   // Struct to store Phoenix Data
202   struct Phoenix {
203     uint256 price;  // Current price of phoenix
204     uint256 payoutPercentage; // The percent of the funds awarded upon explosion / steal / end game
205     uint abilityAvailTime; // Time when phoenix's ability is available
206     uint cooldown; // Time to add after cooldown
207     uint cooldownDecreaseAmt; // Amt of time to decrease upon each flip
208     uint basePower; // Starting exploding / stealing power of phoenix
209     uint currentPower; // Current exploding / stealing power of phoenix
210     uint powerIncreaseAmt; // Amt of power to increase with every flip
211     uint powerDrop; // Power drop of phoenix upon ability usage
212     uint powerCap; // Power should not exceed this amount
213     address previousOwner;  // Owner of phoenix in previous round
214     address currentOwner; // Current owner of phoenix
215   }
216   
217 // Main function to set the beta period and sub developer
218   function CryptoPhoenixesCivilWar(address _subDevOne, address _subDevTwo) {
219     subDevOne = _subDevOne;
220     subDevTwo = _subDevTwo;
221     createPhoenixes();
222   }
223 
224   function createPhoenixes() private {
225       //First, create rainbow phoenix and captains
226       for (uint256 i = 0; i < 3; i++) {
227           Phoenix memory phoenix = Phoenix({
228               price: 0.005 ether,
229               payoutPercentage: 2400, //redundant for rainbow phoenix. Set to 24% for captains
230               cooldown: 20 hours, //redundant for rainbow phoenix
231               abilityAvailTime: 0, //will be set when game starts
232               //Everything else not used
233               cooldownDecreaseAmt: 0,
234               basePower: 0,
235               currentPower: 0,
236               powerIncreaseAmt: 0,
237               powerDrop: 0,
238               powerCap: 0,
239               previousOwner: address(0),
240               currentOwner: address(0)
241           });
242           
243           PHOENIXES.push(phoenix);
244       }
245       
246       //set rainbow phoenix price to 0.01 ether
247       PHOENIXES[0].price = 0.01 ether;
248       
249       //Now, for normal phoenixes
250       uint16[4] memory PAYOUTS = [400,700,1100,1600]; //4%, 7%, 11%, 16%
251       uint16[4] memory COOLDOWN = [2 hours, 4 hours, 8 hours, 16 hours];
252       uint16[4] memory COOLDOWN_DECREASE = [9 minutes, 15 minutes, 26 minutes, 45 minutes];
253       uint8[4] memory POWER_INC_AMT = [25,50,100,175]; //0.25%, 0.5%, 1%, 1.75%
254       uint16[4] memory POWER_DROP = [150,300,600,1000]; //1.5%, 3%, 6%, 10%
255       uint16[4] memory CAPPED_POWER = [800,1500,3000,5000]; //8%, 15%, 30%, 50%
256       
257       
258       for (i = 0; i < 4; i++) {
259           for (uint256 j = 0; j < 4; j++) {
260               phoenix = Phoenix({
261               price: BASE_PRICE,
262               payoutPercentage: PAYOUTS[j],
263               abilityAvailTime: 0,
264               cooldown: COOLDOWN[j],
265               cooldownDecreaseAmt: COOLDOWN_DECREASE[j],
266               basePower: (j+1)*100, //100, 200, 300, 400 = 1%, 2%, 3%, 4%
267               currentPower: (j+1)*100,
268               powerIncreaseAmt: POWER_INC_AMT[j],
269               powerDrop: POWER_DROP[j],
270               powerCap: CAPPED_POWER[j],
271               previousOwner: address(0),
272               currentOwner: address(0)
273               });
274               
275               PHOENIXES.push(phoenix);
276           }
277       }
278   }
279   
280   function startGame() public noGameInProgress onlyAuthorized {
281       //reset scores
282       SCORES[0] = 0;
283       SCORES[1] = 0;
284       
285       //reset normal phoenixes' abilityAvailTimes
286       for (uint i = 1; i < 19; i++) {
287           PHOENIXES[i].abilityAvailTime = now + PHOENIXES[i].cooldown;
288       }
289       
290       GAME_STARTED = true;
291       //set game duration to be 1 day
292       GAME_END = now + 1 days;
293       emit GameStarted();
294   }
295   
296   //Set bag holders from version 1.0
297   function setPhoenixOwners(address[19] _owners) onlyOwner public {
298       require(PHOENIXES[0].previousOwner == address(0)); //Just need check once
299       for (uint256 i = 0; i < 19; i++) {
300           Phoenix storage phoenix = PHOENIXES[i];
301           phoenix.previousOwner = _owners[i];
302           phoenix.currentOwner = _owners[i];
303       }
304   }
305 
306 function purchasePhoenix(uint256 _phoenixID) whenNotPaused gameInProgress public payable {
307       //checking prerequisite
308       require(_phoenixID < 19);
309     
310       Phoenix storage phoenix = PHOENIXES[_phoenixID];
311       //Get current price of phoenix
312       uint256 price = phoenix.price;
313       
314       //checking more prerequisites
315       require(phoenix.currentOwner != address(0)); //check if phoenix was initialised
316       require(msg.value >= phoenix.price);
317       require(phoenix.currentOwner != msg.sender); //prevent consecutive purchases
318       
319       uint256 outgoingOwnerCut;
320       uint256 purchaseExcess;
321       uint256 poolCut;
322       uint256 rainbowCut;
323       uint256 captainCut;
324       
325       (outgoingOwnerCut, 
326       purchaseExcess, 
327       poolCut,
328       rainbowCut,
329       captainCut) = calculateCuts(msg.value,price);
330       
331       //give 1% for previous owner, abusing variable name here
332       userFunds[phoenix.previousOwner] = userFunds[phoenix.previousOwner].add(captainCut); 
333       
334       //If purchasing rainbow phoenix, give the 2% rainbowCut and 1% captainCut to outgoingOwner
335       if (_phoenixID == 0) {
336           outgoingOwnerCut = outgoingOwnerCut.add(rainbowCut).add(captainCut);
337           rainbowCut = 0; //necessary to set to zero since variable is used for other cases
338           poolCut = poolCut.div(2); //split poolCut equally into 2, distribute to both POOLS
339           POOLS[0] = POOLS[0].add(poolCut); //add pool cut to red team
340           POOLS[1] = POOLS[1].add(poolCut); //add pool cut to blue team
341           
342       } else if (_phoenixID < 3) { //if captain, return 1% captainCut to outgoingOwner
343           outgoingOwnerCut = outgoingOwnerCut.add(captainCut);
344           uint256 poolID = _phoenixID.sub(1); //1 --> 0, 2--> 1 (detemine which pool to add pool cut to)
345           POOLS[poolID] = POOLS[poolID].add(poolCut);
346           
347       } else if (_phoenixID < 11) { //for normal red phoenixes, set captain and adjust stats
348           //transfer 1% captainCut to red captain
349           userFunds[PHOENIXES[1].currentOwner] = userFunds[PHOENIXES[1].currentOwner].add(captainCut);
350           upgradePhoenixStats(_phoenixID);
351           POOLS[0] = POOLS[0].add(poolCut); //add pool cut to red team
352       } else {
353           //transfer 1% captainCut to blue captain
354           userFunds[PHOENIXES[2].currentOwner] = userFunds[PHOENIXES[2].currentOwner].add(captainCut);
355           upgradePhoenixStats(_phoenixID);
356           POOLS[1] = POOLS[1].add(poolCut); //add pool cut to blue team
357       }
358       
359       //transfer rainbowCut to rainbow phoenix owner
360       userFunds[PHOENIXES[0].currentOwner] = userFunds[PHOENIXES[0].currentOwner].add(rainbowCut);
361 
362       // set new price
363       phoenix.price = getNextPrice(price);
364       
365       // send funds to old owner 
366       sendFunds(phoenix.currentOwner, outgoingOwnerCut);
367     
368       // set new owner
369       phoenix.currentOwner = msg.sender;
370 
371       // Send refund to owner if needed
372       if (purchaseExcess > 0) {
373         sendFunds(msg.sender,purchaseExcess);
374       }
375       
376       // raise event
377       emit PhoenixPurchased(_phoenixID, msg.sender, price, phoenix.price, phoenix.currentPower, phoenix.abilityAvailTime);
378   }
379   
380   function calculateCuts(
381       uint256 _amtPaid,
382       uint256 _price
383       )
384       private
385       returns (uint256 outgoingOwnerCut, uint256 purchaseExcess, uint256 poolCut, uint256 rainbowCut, uint256 captainCut)
386       {
387       outgoingOwnerCut = _price;
388       purchaseExcess = _amtPaid.sub(_price);
389       
390       //Take 5% cut from excess
391       uint256 excessPoolCut = purchaseExcess.div(20); //5%, will be added to poolCut
392       purchaseExcess = purchaseExcess.sub(excessPoolCut);
393       
394       //3% of price to devs
395       uint256 cut = _price.mul(3).div(100); //3%
396       outgoingOwnerCut = outgoingOwnerCut.sub(cut);
397       distributeDevCut(cut);
398       
399       //1% of price to owner in previous round, 1% to captain (if applicable)
400       //abusing variable name to use for previous owner and captain fees, since they are the same
401       captainCut = _price.div(100); //1%
402       outgoingOwnerCut = outgoingOwnerCut.sub(captainCut).sub(captainCut); //subtract twice, reason as explained
403       
404       //2% of price to rainbow (if applicable)
405       rainbowCut = _price.mul(2).div(100); //2%
406       outgoingOwnerCut = outgoingOwnerCut.sub(rainbowCut);
407       
408       //11-13% of price will go to the respective team pools
409       poolCut = calculatePoolCut(_price);
410       outgoingOwnerCut = outgoingOwnerCut.sub(poolCut);
411       /*
412       add the poolCut and excessPoolCut together
413       so poolCut = 11-13% of price + 5% of purchaseExcess
414       */
415       poolCut = poolCut.add(excessPoolCut);
416   }
417   
418   function distributeDevCut(uint256 _cut) private {
419       devFunds[owner] = devFunds[owner].add(_cut.div(2)); //50% to owner
420       devFunds[subDevOne] = devFunds[subDevOne].add(_cut.div(4)); //25% to subDevOne
421       devFunds[subDevTwo] = devFunds[subDevTwo].add(_cut.div(4)); //25% to subDevTwo
422   }
423   
424 /**
425   * @dev Determines next price of phoenix
426 */
427   function getNextPrice (uint256 _price) private pure returns (uint256 _nextPrice) {
428     if (_price < 0.25 ether) {
429       return _price.mul(3).div(2); //1.5x
430     } else if (_price < 1 ether) {
431       return _price.mul(14).div(10); //1.4x
432     } else {
433       return _price.mul(13).div(10); //1.3x
434     }
435   }
436   
437   function calculatePoolCut (uint256 _price) private pure returns (uint256 poolCut) {
438       if (_price < 0.25 ether) {
439           poolCut = _price.mul(13).div(100); //13%
440       } else if (_price < 1 ether) {
441           poolCut = _price.mul(12).div(100); //12%
442       } else {
443           poolCut = _price.mul(11).div(100); //11%
444       }
445   }
446  
447   function upgradePhoenixStats(uint256 _phoenixID) private {
448       Phoenix storage phoenix = PHOENIXES[_phoenixID];
449       //increase current power of phoenix
450       phoenix.currentPower = phoenix.currentPower.add(phoenix.powerIncreaseAmt);
451       //handle boundary case where current power exceeds cap
452       if (phoenix.currentPower > phoenix.powerCap) {
453           phoenix.currentPower = phoenix.powerCap;
454       }
455       //decrease cooldown of phoenix
456       //no base case to take care off. Time shouldnt decrease too much to ever reach zero
457       phoenix.abilityAvailTime = phoenix.abilityAvailTime.sub(phoenix.cooldownDecreaseAmt);
458   }
459   
460   function useCaptainAbility(uint256 _captainID) whenNotPaused gameInProgress public {
461       require(_captainID > 0 && _captainID < 3); //either 1 or 2
462       Phoenix storage captain = PHOENIXES[_captainID];
463       require(msg.sender == captain.currentOwner); //Only owner of captain can use ability
464       require(now >= captain.abilityAvailTime); //Ability must be available for use
465       
466       if (_captainID == 1) { //red team
467           uint groupIDStart = 3; //Start index of _groupID in PHOENIXES
468           uint groupIDEnd = 11; //End index (excluding) of _groupID in PHOENIXES
469       } else {
470           groupIDStart = 11; 
471           groupIDEnd = 19; 
472       }
473       
474       for (uint i = groupIDStart; i < groupIDEnd; i++) {
475           //Multiply team power by 1.5x
476           PHOENIXES[i].currentPower = PHOENIXES[i].currentPower.mul(3).div(2); 
477           //ensure cap not breached
478           if (PHOENIXES[i].currentPower > PHOENIXES[i].powerCap) {
479               PHOENIXES[i].currentPower = PHOENIXES[i].powerCap;
480           }
481       }
482       
483       captain.abilityAvailTime = GAME_END + 10 seconds; //Prevent ability from being used again in current round
484       
485       emit CaptainAbilityUsed(_captainID);
486   }
487   
488   function useAbility(uint256 _phoenixID) whenNotPaused gameInProgress public {
489       //phoenixID must be between 3 to 18
490       require(_phoenixID > 2);
491       require(_phoenixID < 19);
492       
493       Phoenix storage phoenix = PHOENIXES[_phoenixID];
494       require(msg.sender == phoenix.currentOwner); //Only owner of phoenix can use ability
495       require(now >= phoenix.abilityAvailTime); //Ability must be available for use
496 
497       //calculate which pool to take from
498       //ids 3-6, 15-18 --> red
499       //ids 7-14 --> blue
500       if (_phoenixID >=7 &&  _phoenixID <= 14) {
501           require(POOLS[1] > 0); //blue pool
502           uint256 payout = POOLS[1].mul(phoenix.currentPower).div(DENOMINATOR); //calculate payout
503           POOLS[1] = POOLS[1].sub(payout); //subtract from pool
504       } else {
505           require(POOLS[0] > 0); //red pool
506           payout = POOLS[0].mul(phoenix.currentPower).div(DENOMINATOR);
507           POOLS[0] = POOLS[0].sub(payout);
508       }
509       
510       //determine which team the phoenix is on
511       if (_phoenixID < 11) { //red team
512           bool isRed = true; //to determine which team to distribute the 9% payout to
513           SCORES[0] = SCORES[0].add(payout); //add payout to score (ie. payout is the score)
514       } else {
515           //blue team
516           isRed = false;
517           SCORES[1] = SCORES[1].add(payout);
518       }
519       
520       uint256 ownerCut = payout;
521       
522       //drop power of phoenix
523       decreasePower(_phoenixID);
524       
525       //decrease phoenix price
526       decreasePrice(_phoenixID);
527       
528       //reset cooldown
529       phoenix.abilityAvailTime = now + phoenix.cooldown;
530 
531       // set previous owner to be current owner, so he can get the 1% dividend from subsequent purchases
532       phoenix.previousOwner = msg.sender;
533       
534       // Calculate the different cuts
535       // 2% to rainbow
536       uint256 cut = payout.div(50); //2%
537       ownerCut = ownerCut.sub(cut);
538       userFunds[PHOENIXES[0].currentOwner] = userFunds[PHOENIXES[0].currentOwner].add(cut);
539       
540       // 1% to dev
541       cut = payout.div(100); //1%
542       ownerCut = ownerCut.sub(cut);
543       distributeDevCut(cut);
544       
545       //9% to team
546       cut = payout.mul(9).div(100); //9%
547       ownerCut = ownerCut.sub(cut);
548       distributeTeamCut(isRed,cut);
549       
550       //Finally, send money to user
551       sendFunds(msg.sender,ownerCut);
552       
553       emit PhoenixAbilityUsed(_phoenixID,ownerCut,phoenix.price,phoenix.currentPower,phoenix.abilityAvailTime,phoenix.previousOwner);
554   }
555   
556   function decreasePrice(uint256 _phoenixID) private {
557       Phoenix storage phoenix = PHOENIXES[_phoenixID];
558       if (phoenix.price >= 0.75 ether) {
559         phoenix.price = phoenix.price.mul(20).div(100); //drop to 20%
560       } else {
561         phoenix.price = phoenix.price.mul(10).div(100); //drop to 10%
562         if (phoenix.price < BASE_PRICE) {
563           phoenix.price = BASE_PRICE;
564           }
565       }
566   }
567   
568   function decreasePower(uint256 _phoenixID) private {
569       Phoenix storage phoenix = PHOENIXES[_phoenixID];
570       phoenix.currentPower = phoenix.currentPower.sub(phoenix.powerDrop);
571       //handle boundary case where currentPower is below basePower
572       if (phoenix.currentPower < phoenix.basePower) {
573           phoenix.currentPower = phoenix.basePower; 
574       }
575   }
576   
577   function distributeTeamCut(bool _isRed, uint256 _cut) private {
578       /* 
579       Note that captain + phoenixes payout percentages add up to 100%.
580       Captain: 24%
581       Phoenix 1 & 5: 4% x 2 = 8%
582       Phoenix 2 & 6: 7% x 2 = 14%
583       Phoenix 3 & 7: 11% x 2 = 22%
584       Phoenix 4 & 8: 16% x 2 = 32%
585       */
586       
587       if (_isRed) {
588           uint captainID = 1;
589           uint groupIDStart = 3;
590           uint groupIDEnd = 11;
591       } else {
592           captainID = 2;
593           groupIDStart = 11;
594           groupIDEnd = 19;
595       }
596       
597       //calculate and transfer capt payout
598       uint256 payout = PHOENIXES[captainID].payoutPercentage.mul(_cut).div(DENOMINATOR);
599       userFunds[PHOENIXES[captainID].currentOwner] = userFunds[PHOENIXES[captainID].currentOwner].add(payout);
600       
601       for (uint i = groupIDStart; i < groupIDEnd; i++) {
602           //calculate how much to pay to each phoenix owner in the team
603           payout = PHOENIXES[i].payoutPercentage.mul(_cut).div(DENOMINATOR);
604           //transfer payout
605           userFunds[PHOENIXES[i].currentOwner] = userFunds[PHOENIXES[i].currentOwner].add(payout);
606       }
607   }
608   
609   function endGame() gameHasEnded public {
610       GAME_STARTED = false; //to allow this function to only be called once after the end of every round
611       uint256 remainingPoolAmt = POOLS[0].add(POOLS[1]); //add the 2 pools together
612       
613       //Distribution structure -> 15% rainbow, 75% teams, 10% for next game
614       uint256 rainbowCut = remainingPoolAmt.mul(15).div(100); //15% to rainbow
615       uint256 teamCut = remainingPoolAmt.mul(75).div(100); //75% to teams
616       remainingPoolAmt = remainingPoolAmt.sub(rainbowCut).sub(teamCut);
617       
618       //distribute 15% to rainbow phoenix owner
619       userFunds[PHOENIXES[0].currentOwner] = userFunds[PHOENIXES[0].currentOwner].add(rainbowCut);
620       
621       //distribute 75% to teams
622       //in the unlikely event of a draw, split evenly, so 37.5% cut to each team
623       if (SCORES[0] == SCORES[1]) {
624           teamCut = teamCut.div(2);
625           distributeTeamCut(true,teamCut); //redTeam
626           distributeTeamCut(false,teamCut); //blueTeam
627       } else {
628           //25% to losing team
629           uint256 losingTeamCut = teamCut.div(3); // 1 third of 75% = 25%
630           //SCORES[0] = red, SCORES[1] = blue
631           //if red > blue, then award to redTeam, so bool _isRed = red > blue
632           distributeTeamCut((SCORES[0] > SCORES[1]),losingTeamCut);
633           
634           //50% to winning team
635           teamCut = teamCut.sub(losingTeamCut); //take the remainder
636           //inverse of the winning condition
637           distributeTeamCut(!(SCORES[0] > SCORES[1]),teamCut); 
638       }
639       
640       // 5% to each pool for next game
641       POOLS[0] = remainingPoolAmt.div(2);
642       POOLS[1] = POOLS[0];
643       
644       resetPhoenixes();
645       emit GameEnded();
646   }
647   
648   function resetPhoenixes() private {
649       //reset attributes of phoenixes
650       PHOENIXES[0].price = 0.01 ether;
651       PHOENIXES[1].price = 0.005 ether;
652       PHOENIXES[2].price = 0.005 ether;
653       
654       for (uint i = 0; i < 3; i++) {
655           PHOENIXES[i].previousOwner = PHOENIXES[i].currentOwner;
656       }
657       
658       for (i = 3; i < 19; i++) {
659           //Reset price and power levels of phoenixes
660           //Ability time will be set during game start
661           Phoenix storage phoenix = PHOENIXES[i];
662           phoenix.price = BASE_PRICE;
663           phoenix.currentPower = phoenix.basePower;
664           phoenix.previousOwner = phoenix.currentOwner;
665       }
666   }
667   
668 /**
669 * @dev Try to send funds immediately
670 * If it fails, user has to manually withdraw.
671 */
672   function sendFunds(address _user, uint256 _payout) private {
673     if (!_user.send(_payout)) {
674       userFunds[_user] = userFunds[_user].add(_payout);
675     }
676   }
677 
678 /**
679 * @dev Withdraw dev cut.
680 */
681   function devWithdraw() public {
682     uint256 funds = devFunds[msg.sender];
683     require(funds > 0);
684     devFunds[msg.sender] = 0;
685     msg.sender.transfer(funds);
686   }
687 
688 /**
689 * @dev Users can withdraw their funds
690 */
691   function withdrawFunds() public {
692     uint256 funds = userFunds[msg.sender];
693     require(funds > 0);
694     userFunds[msg.sender] = 0;
695     msg.sender.transfer(funds);
696     emit WithdrewFunds(msg.sender);
697   }
698 
699 /**
700 * @dev Transfer contract balance in case of bug or contract upgrade
701 */ 
702  function upgradeContract(address _newContract) public onlyOwner whenPaused {
703         _newContract.transfer(address(this).balance);
704  }
705 }