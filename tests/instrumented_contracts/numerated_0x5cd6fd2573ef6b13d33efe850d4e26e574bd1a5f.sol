1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41     uint256 public totalSupply = 90000000 * 10 ** 18;
42 
43     function balanceOf(address who) public constant returns (uint256);
44 
45     function transfer(address to, uint256 value) public returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public constant returns (uint256);
57 
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59 
60     function approve(address spender, uint256 value) public returns (bool);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71     using SafeMath for uint256;
72 
73     mapping (address => uint256) public balances;
74 
75     /**
76     * @dev transfer token for a specified address
77     * @param _to The address to transfer to.
78     * @param _value The amount to be transferred.
79     */
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82 
83         // SafeMath.sub will throw if there is not enough balance.
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91     * @dev Gets the balance of the specified address.
92     * @param _owner The address to query the the balance of.
93     * @return An uint256 representing the amount owned by the passed address.
94     */
95     function balanceOf(address _owner) public constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) allowed;
112 
113 
114     /**
115      * @dev Transfer tokens from one address to another
116      * @param _from address The address which you want to send tokens from
117      * @param _to address The address which you want to transfer to
118      * @param _value uint256 the amount of tokens to be transferred
119      */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122 
123         uint256 _allowance = allowed[_from][msg.sender];
124 
125         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126         // require (_value <= _allowance);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = _allowance.sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      *
138      * Beware that changing an allowance with this method brings the risk that someone may use both the old
139      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      * @param _spender The address which will spend the funds.
143      * @param _value The amount of tokens to be spent.
144      */
145     function approve(address _spender, uint256 _value) public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param _owner address The address which owns the funds.
154      * @param _spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
158         return allowed[_owner][_spender];
159     }
160 
161     /**
162      * approve should be called when allowed[_spender] == 0. To increment
163      * allowed value is better to use this function to avoid 2 calls (and wait until
164      * the first transaction is mined)
165      * From MonolithDAO Token.sol
166      */
167     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
168         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173     function decreaseApproval(address _spender, uint _subtractedValue)
174     public returns (bool success) {
175         uint oldValue = allowed[msg.sender][_spender];
176         if (_subtractedValue > oldValue) {
177             allowed[msg.sender][_spender] = 0;
178         }
179         else {
180             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181         }
182         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 
186 }
187 
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195 
196     address public owner;
197 
198     /**
199      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200      * account.
201      */
202     function Ownable() public {
203         owner = msg.sender;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(msg.sender == owner);
211         _;
212     }
213 
214     /**
215      * @dev Allows the current owner to transfer control of the contract to a newOwner.
216      * @param newOwner The address to transfer ownership to.
217      */
218     function transferOwnership(address newOwner) onlyOwner public {
219         require(newOwner != address(0));
220         owner = newOwner;
221     }
222 }
223 
224 
225 /*
226  * ChargCoinContract
227  *
228  * Simple ERC20 Token example, with crowdsale token creation
229  */
230 contract ChargCoinContract is StandardToken, Ownable {
231 
232     string public standard = "CHG";
233     string public name = "Charg Coin";
234     string public symbol = "CHG";
235 
236     uint public decimals = 18;
237 
238     address public multisig = 0x482EFd447bE88748e7625e2b7c522c388970B790;
239 
240     struct ChargingData {
241     address node;
242     uint startTime;
243     uint endTime;
244     uint256 fixedRate;
245     bool initialized;
246     uint256 predefinedAmount;
247     }
248 
249     struct ParkingData {
250     address node;
251     uint startTime;
252     uint endTime;
253     uint256 fixedRate;
254     bool initialized;
255     uint256 predefinedAmount;
256     }
257 
258     mapping (address => uint256) public authorized;
259 
260     mapping (address => uint256) public rateOfCharging;
261     mapping (address => uint256) public rateOfParking;
262 
263     mapping (address => ChargingData) public chargingSwitches;
264     mapping (address => ParkingData) public parkingSwitches;
265 
266     mapping (address => uint256) public reservedFundsCharging;
267     mapping (address => uint256) public reservedFundsParking;
268 
269     // 1 ETH = 500 CHARG tokens (1 CHARG = 0.59 USD)
270     uint PRICE = 500;
271 
272     struct ContributorData {
273     uint contributionAmount;
274     uint tokensIssued;
275     }
276 
277     function ChargCoinContract() public {
278         balances[msg.sender] = totalSupply;
279     }
280 
281     mapping (address => ContributorData) public contributorList;
282 
283     uint nextContributorIndex;
284 
285     mapping (uint => address) contributorIndexes;
286 
287     state public crowdsaleState = state.pendingStart;
288     enum state {pendingStart, crowdsale, crowdsaleEnded}
289 
290     event CrowdsaleStarted(uint blockNumber);
291 
292     event CrowdsaleEnded(uint blockNumber);
293 
294     event ErrorSendingETH(address to, uint amount);
295 
296     event MinCapReached(uint blockNumber);
297 
298     event MaxCapReached(uint blockNumber);
299 
300     uint public constant BEGIN_TIME = 1513896982;
301 
302     uint public constant END_TIME = 1545432981;
303 
304     uint public minCap = 1 ether;
305 
306     uint public maxCap = 70200 ether;
307 
308     uint public ethRaised = 0;
309 
310     uint public totalSupply = 90000000 * 10 ** decimals;
311 
312     uint crowdsaleTokenCap = 10000000 * 10 ** decimals; // 39%
313     uint foundersAndTeamTokens = 9000000 * 10 ** decimals; // 10%
314     uint slushFundTokens = 45900000 * 10 ** decimals; // 51%
315 
316     bool foundersAndTeamTokensClaimed = false;
317     bool slushFundTokensClaimed = false;
318 
319     uint nextContributorToClaim;
320 
321     mapping (address => bool) hasClaimedEthWhenFail;
322 
323     function() payable public {
324         require(msg.value != 0);
325         require(crowdsaleState != state.crowdsaleEnded);
326         // Check if crowdsale has ended
327 
328         bool stateChanged = checkCrowdsaleState();
329         // Check blocks and calibrate crowdsale state
330 
331         if (crowdsaleState == state.crowdsale) {
332             createTokens(msg.sender);
333             // Process transaction and issue tokens
334         }
335         else {
336             refundTransaction(stateChanged);
337             // Set state and return funds or throw
338         }
339     }
340 
341     //
342     // Check crowdsale state and calibrate it
343     //
344     function checkCrowdsaleState() internal returns (bool) {
345         if (ethRaised >= maxCap && crowdsaleState != state.crowdsaleEnded) {// Check if max cap is reached
346             crowdsaleState = state.crowdsaleEnded;
347             CrowdsaleEnded(block.number);
348             // Raise event
349             return true;
350         }
351 
352         if (now >= END_TIME) {
353             crowdsaleState = state.crowdsaleEnded;
354             CrowdsaleEnded(block.number);
355             // Raise event
356             return true;
357         }
358 
359         if (now >= BEGIN_TIME && now < END_TIME) {// Check if we are in crowdsale state
360             if (crowdsaleState != state.crowdsale) {// Check if state needs to be changed
361                 crowdsaleState = state.crowdsale;
362                 // Set new state
363                 CrowdsaleStarted(block.number);
364                 // Raise event
365                 return true;
366             }
367         }
368 
369         return false;
370     }
371 
372     //
373     // Decide if throw or only return ether
374     //
375     function refundTransaction(bool _stateChanged) internal {
376         if (_stateChanged) {
377             msg.sender.transfer(msg.value);
378         }
379         else {
380             revert();
381         }
382     }
383 
384     function createTokens(address _contributor) payable public {
385 
386         uint _amount = msg.value;
387 
388         uint contributionAmount = _amount;
389         uint returnAmount = 0;
390 
391         if (_amount > (maxCap - ethRaised)) {// Check if max contribution is lower than _amount sent
392             contributionAmount = maxCap - ethRaised;
393             // Set that user contibutes his maximum alowed contribution
394             returnAmount = _amount - contributionAmount;
395             // Calculate how much he must get back
396         }
397 
398         if (ethRaised + contributionAmount > minCap && minCap > ethRaised) {
399             MinCapReached(block.number);
400         }
401 
402         if (ethRaised + contributionAmount == maxCap && ethRaised < maxCap) {
403             MaxCapReached(block.number);
404         }
405 
406         if (contributorList[_contributor].contributionAmount == 0) {
407             contributorIndexes[nextContributorIndex] = _contributor;
408             nextContributorIndex += 1;
409         }
410 
411         contributorList[_contributor].contributionAmount += contributionAmount;
412         ethRaised += contributionAmount;
413         // Add to eth raised
414 
415         uint256 tokenAmount = calculateEthToChargcoin(contributionAmount);
416         // Calculate how much tokens must contributor get
417         if (tokenAmount > 0) {
418             transferToContributor(_contributor, tokenAmount);
419             contributorList[_contributor].tokensIssued += tokenAmount;
420             // log token issuance
421         }
422 
423         if (!multisig.send(msg.value)) {
424             revert();
425         }
426     }
427 
428 
429     function transferToContributor(address _to, uint256 _value)  public {
430         balances[owner] = balances[owner].sub(_value);
431         balances[_to] = balances[_to].add(_value);
432     }
433 
434     function calculateEthToChargcoin(uint _eth) constant public returns (uint256) {
435 
436         uint tokens = _eth.mul(getPrice());
437         uint percentage = 0;
438 
439         if (ethRaised > 0) {
440             percentage = ethRaised * 100 / maxCap;
441         }
442 
443         return tokens + getAmountBonus(tokens);
444     }
445 
446     function getAmountBonus(uint tokens) pure public returns (uint) {
447         uint amountBonus = 0;
448 
449         if (tokens >= 10000) amountBonus = tokens;
450         else if (tokens >= 5000) amountBonus = tokens * 60 / 100;
451         else if (tokens >= 1000) amountBonus = tokens * 30 / 100;
452         else if (tokens >= 500) amountBonus = tokens * 10 / 100;
453         else if (tokens >= 100) amountBonus = tokens * 5 / 100;
454         else if (tokens >= 10) amountBonus = tokens * 1 / 100;
455 
456         return amountBonus;
457     }
458 
459     // replace this with any other price function
460     function getPrice() constant public returns (uint result) {
461         return PRICE;
462     }
463 
464     //
465     // Owner can batch return contributors contributions(eth)
466     //
467     function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
468         require(crowdsaleState != state.crowdsaleEnded);
469         // Check if crowdsale has ended
470         require(ethRaised < minCap);
471         // Check if crowdsale has failed
472         address currentParticipantAddress;
473         uint contribution;
474         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
475             currentParticipantAddress = contributorIndexes[nextContributorToClaim];
476             // Get next unclaimed participant
477             if (currentParticipantAddress == 0x0) return;
478             // Check if all the participants were compensated
479             if (!hasClaimedEthWhenFail[currentParticipantAddress]) {// Check if participant has already claimed
480                 contribution = contributorList[currentParticipantAddress].contributionAmount;
481                 // Get contribution of participant
482                 hasClaimedEthWhenFail[currentParticipantAddress] = true;
483                 // Set that he has claimed
484                 balances[currentParticipantAddress] = 0;
485                 if (!currentParticipantAddress.send(contribution)) {// Refund eth
486                     ErrorSendingETH(currentParticipantAddress, contribution);
487                     // If there is an issue raise event for manual recovery
488                 }
489             }
490             nextContributorToClaim += 1;
491             // Repeat
492         }
493     }
494 
495     //
496     // Owner can set multisig address for crowdsale
497     //
498     function setMultisigAddress(address _newAddress) onlyOwner public {
499         multisig = _newAddress;
500     }
501 
502     //
503     // Registers node with rate
504     //
505     function registerNode(uint256 chargingRate, uint256 parkingRate) public {
506         if (authorized[msg.sender] == 1) revert();
507 
508         rateOfCharging[msg.sender] = chargingRate;
509         rateOfParking[msg.sender] = parkingRate;
510         authorized[msg.sender] = 1;
511     }
512 
513     // 
514     // Block node
515     //
516     function blockNode (address node) onlyOwner public {
517         authorized[node] = 0;
518     }
519 
520     //
521     // Updates node charging rate
522     // 
523     function updateChargingRate (uint256 rate) public {
524         rateOfCharging[msg.sender] = rate;
525     }
526 
527     //
528     // Updates node parking rate
529     // 
530     function updateParkingRate (uint256 rate) public {
531         rateOfCharging[msg.sender] = rate;
532     }
533 
534     function chargeOn (address node, uint time) public {
535         // Prevent from not authorized nodes
536         if (authorized[node] == 0) revert();
537         // Prevent from double charging
538         if (chargingSwitches[msg.sender].initialized) revert();
539 
540         // Determine endTime
541         uint endTime = now + time;
542 
543         // Prevent from past dates
544         if (endTime <= now) revert();
545 
546         // Calculate the amount of tokens has to be taken from users account
547         uint256 predefinedAmount = (endTime - now) * rateOfCharging[node];
548 
549         if (balances[msg.sender] < predefinedAmount) revert();
550 
551         chargingSwitches[msg.sender] = ChargingData(node, now, endTime, rateOfCharging[node], true, predefinedAmount);
552         balances[msg.sender] = balances[msg.sender].sub(predefinedAmount);
553         reservedFundsCharging[msg.sender] = reservedFundsCharging[msg.sender].add(predefinedAmount);
554     }
555 
556     function chargeOff (address node) public {
557         // Check that initialization happened
558         if (!chargingSwitches[msg.sender].initialized) revert();
559         // Calculate the amount depending on rate
560         uint256 amount = (now - chargingSwitches[msg.sender].startTime) * chargingSwitches[msg.sender].fixedRate;
561         // Maximum can be predefinedAmount, if it less than that, return tokens
562         amount = amount > chargingSwitches[msg.sender].predefinedAmount ? chargingSwitches[msg.sender].predefinedAmount : amount;
563 
564         // Take tokens from reserFunds and put it on balance
565         balances[node] = balances[node] + amount;
566         reservedFundsCharging[msg.sender] = reservedFundsCharging[msg.sender] - amount;
567 
568         // When amount is less than predefinedAmount, return other tokens to user
569         if (reservedFundsCharging[msg.sender] > 0) {
570             balances[msg.sender] = balances[msg.sender] + reservedFundsCharging[msg.sender];
571             reservedFundsCharging[msg.sender] = 0;
572         }
573 
574         // Uninitialize
575         chargingSwitches[msg.sender].node = 0;
576         chargingSwitches[msg.sender].startTime = 0;
577         chargingSwitches[msg.sender].endTime = 0;
578         chargingSwitches[msg.sender].fixedRate = 0;
579         chargingSwitches[msg.sender].initialized = false;
580         chargingSwitches[msg.sender].predefinedAmount = 0;
581     }
582 
583     function parkingOn (address node, uint time) public {
584         // Prevent from not authorized nodes
585         if (authorized[node] == 0) revert();
586         // Prevent from double charging
587         if (parkingSwitches[msg.sender].initialized) revert();
588 
589         if (balances[msg.sender] < predefinedAmount) revert();
590 
591         uint endTime = now + time;
592 
593         // Prevent from past dates
594         if (endTime <= now) revert();
595 
596         uint256 predefinedAmount = (endTime - now) * rateOfParking[node];
597 
598         parkingSwitches[msg.sender] = ParkingData(node, now, endTime, rateOfParking[node], true, predefinedAmount);
599         balances[msg.sender] = balances[msg.sender].sub(predefinedAmount);
600         reservedFundsParking[msg.sender] = reservedFundsParking[msg.sender].add(predefinedAmount);
601     }
602 
603     // Parking off     
604     function parkingOff (address node) public {
605         if (!parkingSwitches[msg.sender].initialized) revert();
606 
607         // Calculate the amount depending on rate
608         uint256 amount = (now - parkingSwitches[msg.sender].startTime) * parkingSwitches[msg.sender].fixedRate;
609         // Maximum can be predefinedAmount, if it less than that, return tokens
610         amount = amount > parkingSwitches[msg.sender].predefinedAmount ? parkingSwitches[msg.sender].predefinedAmount : amount;
611 
612         balances[node] = balances[node] + amount;
613         reservedFundsParking[msg.sender] = reservedFundsParking[msg.sender] - amount;
614 
615         //  
616         if (reservedFundsParking[msg.sender] > 0) {
617             balances[msg.sender] = balances[msg.sender] + reservedFundsParking[msg.sender];
618             // all tokens taken, set to 0
619             reservedFundsParking[msg.sender] = 0;
620         }
621 
622         // Uninitialize
623         parkingSwitches[msg.sender].node = 0;
624         parkingSwitches[msg.sender].startTime = 0;
625         parkingSwitches[msg.sender].endTime = 0;
626         parkingSwitches[msg.sender].fixedRate = 0;
627         parkingSwitches[msg.sender].initialized = false;
628         parkingSwitches[msg.sender].predefinedAmount = 0;
629     }
630 }
631 
632 contract ChgUsdConverter is Ownable{
633     address public contractAddress = 0xC4A86561cb0b7EA1214904f26E6D50FD357C7986;
634     address public dashboardAddress = 0x482EFd447bE88748e7625e2b7c522c388970B790;
635     uint public ETHUSDPRICE = 810;
636     uint public CHGUSDPRICE = 4; // $0.4
637 
638     function setETHUSDPrice(uint newPrice) public {
639         if (msg.sender != dashboardAddress) revert();
640         
641         ETHUSDPRICE = newPrice;
642     }
643 
644     function setCHGUSDPrice(uint newPrice) public {
645         if (msg.sender != dashboardAddress) revert();
646 
647         CHGUSDPRICE = newPrice;
648     }
649 
650     function calculateCHGAmountToEther(uint etherAmount) view public returns (uint){
651         return ((etherAmount * ETHUSDPRICE) / CHGUSDPRICE) * 10;
652     }
653 
654     function balances(address a) view public returns (uint) {
655         ChargCoinContract c = ChargCoinContract(contractAddress);
656         return c.balances(a);
657     }
658 
659     function currentBalance() view public returns (uint) {
660         ChargCoinContract c = ChargCoinContract(contractAddress);
661         return c.balances(address(this));
662     }
663 
664     function() payable public {
665         uint calculatedAmount = calculateCHGAmountToEther(msg.value);
666 
667         ChargCoinContract c = ChargCoinContract(contractAddress);
668 
669         if (currentBalance() < calculatedAmount) {
670             revert();
671         }
672 
673         if (!c.transfer(msg.sender, calculatedAmount)) {
674             revert();
675         }
676 
677     }
678 }