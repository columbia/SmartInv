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
73     mapping (address => uint256) balances;
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
269     // 1 ETH = 800 CHARG tokens (1 CHARG = 0.59 USD)
270     uint PRICE = 800;
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
300     uint public constant BEGIN_TIME = 1512319965;
301 
302     uint public constant END_TIME = 1514764800;
303 
304     uint public minCap = 1 ether;
305 
306     uint public maxCap = 12500 ether;
307 
308     uint public ethRaised = 0;
309 
310     uint public totalSupply = 90000000 * 10 ** decimals;
311 
312     uint crowdsaleTokenCap = 10000000 * 10 ** decimals; // 11.11%
313     uint foundersAndTeamTokens = 9000000 * 10 ** decimals; // 10%
314     uint DistroFundTokens = 69000000 * 10 ** decimals; // 76.67%
315 	uint BountyTokens = 2000000 * 10 ** decimals; // 2.22%
316 
317     bool foundersAndTeamTokensClaimed = false;
318     bool DistroFundTokensClaimed = false;
319 	bool BountyTokensClaimed = false;
320 
321     uint nextContributorToClaim;
322 
323     mapping (address => bool) hasClaimedEthWhenFail;
324 
325     function() payable public {
326         require(msg.value != 0);
327         require(crowdsaleState != state.crowdsaleEnded);
328         // Check if crowdsale has ended
329 
330         bool stateChanged = checkCrowdsaleState();
331         // Check blocks and calibrate crowdsale state
332 
333         if (crowdsaleState == state.crowdsale) {
334             createTokens(msg.sender);
335             // Process transaction and issue tokens
336 
337         }
338         else {
339             refundTransaction(stateChanged);
340             // Set state and return funds or throw
341         }
342     }
343 
344     //
345     // Check crowdsale state and calibrate it
346     //
347     function checkCrowdsaleState() internal returns (bool) {
348         if (ethRaised >= maxCap && crowdsaleState != state.crowdsaleEnded) {// Check if max cap is reached
349             crowdsaleState = state.crowdsaleEnded;
350             CrowdsaleEnded(block.number);
351             // Raise event
352             return true;
353         }
354 
355         if (now >= END_TIME) {
356             crowdsaleState = state.crowdsaleEnded;
357             CrowdsaleEnded(block.number);
358             // Raise event
359             return true;
360         }
361 
362         if (now >= BEGIN_TIME && now < END_TIME) {// Check if we are in crowdsale state
363             if (crowdsaleState != state.crowdsale) {// Check if state needs to be changed
364                 crowdsaleState = state.crowdsale;
365                 // Set new state
366                 CrowdsaleStarted(block.number);
367                 // Raise event
368                 return true;
369             }
370         }
371 
372         return false;
373     }
374 
375     //
376     // Decide if throw or only return ether
377     //
378     function refundTransaction(bool _stateChanged) internal {
379         if (_stateChanged) {
380             msg.sender.transfer(msg.value);
381         }
382         else {
383             revert();
384         }
385     }
386 
387     function createTokens(address _contributor) payable public {
388 
389         uint _amount = msg.value;
390 
391         uint contributionAmount = _amount;
392         uint returnAmount = 0;
393 
394         if (_amount > (maxCap - ethRaised)) {// Check if max contribution is lower than _amount sent
395             contributionAmount = maxCap - ethRaised;
396             // Set that user contibutes his maximum alowed contribution
397             returnAmount = _amount - contributionAmount;
398             // Calculate how much he must get back
399         }
400 
401         if (ethRaised + contributionAmount > minCap && minCap > ethRaised) {
402             MinCapReached(block.number);
403         }
404 
405         if (ethRaised + contributionAmount == maxCap && ethRaised < maxCap) {
406             MaxCapReached(block.number);
407         }
408 
409         if (contributorList[_contributor].contributionAmount == 0) {
410             contributorIndexes[nextContributorIndex] = _contributor;
411             nextContributorIndex += 1;
412         }
413 
414         contributorList[_contributor].contributionAmount += contributionAmount;
415         ethRaised += contributionAmount;
416         // Add to eth raised
417 
418         uint256 tokenAmount = calculateEthToChargcoin(contributionAmount);
419         // Calculate how much tokens must contributor get
420         if (tokenAmount > 0) {
421             transferToContributor(_contributor, tokenAmount);
422             contributorList[_contributor].tokensIssued += tokenAmount;
423             // log token issuance
424         }
425 
426         if (!multisig.send(msg.value)) {
427             revert();
428         }
429     }
430 
431 
432     function transferToContributor(address _to, uint256 _value)  public {
433         balances[owner] = balances[owner].sub(_value);
434         balances[_to] = balances[_to].add(_value);
435     }
436 
437     function calculateEthToChargcoin(uint _eth) constant public returns (uint256) {
438 
439         uint tokens = _eth.mul(getPrice());
440         uint percentage = 0;
441 
442         if (ethRaised > 0) {
443             percentage = ethRaised * 100 / maxCap;
444         }
445 
446         return tokens + getAmountBonus(tokens);
447     }
448 
449     function getAmountBonus(uint tokens) pure public returns (uint) {
450         uint amountBonus = 0;
451 
452         if (tokens >= 10000) amountBonus = tokens;
453         else if (tokens >= 5000) amountBonus = tokens * 60 / 100;
454         else if (tokens >= 1000) amountBonus = tokens * 30 / 100;
455         else if (tokens >= 500) amountBonus = tokens * 10 / 100;
456         else if (tokens >= 100) amountBonus = tokens * 5 / 100;
457         else if (tokens >= 10) amountBonus = tokens * 1 / 100;
458 
459         return amountBonus;
460     }
461 
462     // replace this with any other price function
463     function getPrice() constant public returns (uint result) {
464         return PRICE;
465     }
466 
467     //
468     // Owner can batch return contributors contributions(eth)
469     //
470     function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
471         require(crowdsaleState != state.crowdsaleEnded);
472         // Check if crowdsale has ended
473         require(ethRaised < minCap);
474         // Check if crowdsale has failed
475         address currentParticipantAddress;
476         uint contribution;
477         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
478             currentParticipantAddress = contributorIndexes[nextContributorToClaim];
479             // Get next unclaimed participant
480             if (currentParticipantAddress == 0x0) return;
481             // Check if all the participants were compensated
482             if (!hasClaimedEthWhenFail[currentParticipantAddress]) {// Check if participant has already claimed
483                 contribution = contributorList[currentParticipantAddress].contributionAmount;
484                 // Get contribution of participant
485                 hasClaimedEthWhenFail[currentParticipantAddress] = true;
486                 // Set that he has claimed
487                 balances[currentParticipantAddress] = 0;
488                 if (!currentParticipantAddress.send(contribution)) {// Refund eth
489                     ErrorSendingETH(currentParticipantAddress, contribution);
490                     // If there is an issue raise event for manual recovery
491                 }
492             }
493             nextContributorToClaim += 1;
494             // Repeat
495         }
496     }
497 
498     //
499     // Owner can set multisig address for crowdsale
500     //
501     function setMultisigAddress(address _newAddress) onlyOwner public {
502         multisig = _newAddress;
503     }
504 
505     //
506     // Registers node with rate
507     //
508     function registerNode(uint256 chargingRate, uint256 parkingRate) public {
509         if (authorized[msg.sender] == 1) revert();
510 
511         rateOfCharging[msg.sender] = chargingRate;
512         rateOfParking[msg.sender] = parkingRate;
513         authorized[msg.sender] = 1;
514     }
515 
516     // 
517     // Block node
518     //
519     function blockNode (address node) onlyOwner public {
520         authorized[node] = 0;
521     }
522 
523     //
524     // Updates node charging rate
525     // 
526     function updateChargingRate (uint256 rate) public {
527         rateOfCharging[msg.sender] = rate;
528     }
529 
530     //
531     // Updates node parking rate
532     // 
533     function updateParkingRate (uint256 rate) public {
534         rateOfCharging[msg.sender] = rate;
535     }
536 
537     function chargeOn (address node, uint time) public {
538         // Prevent from not authorized nodes
539         if (authorized[node] == 0) revert();
540         // Prevent from double charging
541         if (chargingSwitches[msg.sender].initialized) revert();
542 
543         // Determine endTime
544         uint endTime = now + time;
545 
546         // Prevent from past dates
547         if (endTime <= now) revert();
548 
549         // Calculate the amount of tokens has to be taken from users account
550         uint256 predefinedAmount = (endTime - now) * rateOfCharging[node];
551 
552         if (balances[msg.sender] < predefinedAmount) revert();
553 
554         chargingSwitches[msg.sender] = ChargingData(node, now, endTime, rateOfCharging[node], true, predefinedAmount);
555         balances[msg.sender] = balances[msg.sender].sub(predefinedAmount);
556         reservedFundsCharging[msg.sender] = reservedFundsCharging[msg.sender].add(predefinedAmount);
557     }
558 
559     function chargeOff (address node) public {
560         // Check that initialization happened
561         if (!chargingSwitches[msg.sender].initialized) revert();
562         // Calculate the amount depending on rate
563         uint256 amount = (now - chargingSwitches[msg.sender].startTime) * chargingSwitches[msg.sender].fixedRate;
564         // Maximum can be predefinedAmount, if it less than that, return tokens
565         amount = amount > chargingSwitches[msg.sender].predefinedAmount ? chargingSwitches[msg.sender].predefinedAmount : amount;
566 
567         // Take tokens from reserFunds and put it on balance
568         balances[node] = balances[node] + amount;
569         reservedFundsCharging[msg.sender] = reservedFundsCharging[msg.sender] - amount;
570 
571         // When amount is less than predefinedAmount, return other tokens to user
572         if (reservedFundsCharging[msg.sender] > 0) {
573             balances[msg.sender] = balances[msg.sender] + reservedFundsCharging[msg.sender];
574             reservedFundsCharging[msg.sender] = 0;
575         }
576 
577         // Uninitialize
578         chargingSwitches[msg.sender].node = 0;
579         chargingSwitches[msg.sender].startTime = 0;
580         chargingSwitches[msg.sender].endTime = 0;
581         chargingSwitches[msg.sender].fixedRate = 0;
582         chargingSwitches[msg.sender].initialized = false;
583         chargingSwitches[msg.sender].predefinedAmount = 0;
584     }
585 
586     function parkingOn (address node, uint time) public {
587         // Prevent from not authorized nodes
588         if (authorized[node] == 0) revert();
589         // Prevent from double charging
590         if (parkingSwitches[msg.sender].initialized) revert();
591 
592         if (balances[msg.sender] < predefinedAmount) revert();
593 
594         uint endTime = now + time;
595 
596         // Prevent from past dates
597         if (endTime <= now) revert();
598 
599         uint256 predefinedAmount = (endTime - now) * rateOfParking[node];
600 
601         parkingSwitches[msg.sender] = ParkingData(node, now, endTime, rateOfParking[node], true, predefinedAmount);
602         balances[msg.sender] = balances[msg.sender].sub(predefinedAmount);
603         reservedFundsParking[msg.sender] = reservedFundsParking[msg.sender].add(predefinedAmount);
604     }
605 
606     // Parking off     
607     function parkingOff (address node) public {
608         if (!parkingSwitches[msg.sender].initialized) revert();
609 
610         // Calculate the amount depending on rate
611         uint256 amount = (now - parkingSwitches[msg.sender].startTime) * parkingSwitches[msg.sender].fixedRate;
612         // Maximum can be predefinedAmount, if it less than that, return tokens
613         amount = amount > parkingSwitches[msg.sender].predefinedAmount ? parkingSwitches[msg.sender].predefinedAmount : amount;
614 
615         balances[node] = balances[node] + amount;
616         reservedFundsParking[msg.sender] = reservedFundsParking[msg.sender] - amount;
617 
618         //  
619         if (reservedFundsParking[msg.sender] > 0) {
620             balances[msg.sender] = balances[msg.sender] + reservedFundsParking[msg.sender];
621             // all tokens taken, set to 0
622             reservedFundsParking[msg.sender] = 0;
623         }
624 
625         // Uninitialize
626         parkingSwitches[msg.sender].node = 0;
627         parkingSwitches[msg.sender].startTime = 0;
628         parkingSwitches[msg.sender].endTime = 0;
629         parkingSwitches[msg.sender].fixedRate = 0;
630         parkingSwitches[msg.sender].initialized = false;
631         parkingSwitches[msg.sender].predefinedAmount = 0;
632     }
633 
634 }