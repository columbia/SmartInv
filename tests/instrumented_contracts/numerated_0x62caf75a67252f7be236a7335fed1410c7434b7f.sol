1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95     if (a == 0) {
96       return 0;
97     }
98     uint256 c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return c;
108   }
109 
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139   function allowance(address owner, address spender) public view returns (uint256);
140   function transferFrom(address from, address to, uint256 value) public returns (bool);
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[msg.sender]);
162 
163     // SafeMath.sub will throw if there is not enough balance.
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param _owner The address to query the the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address _owner) public view returns (uint256 balance) {
176     return balances[_owner];
177   }
178 
179 }
180 
181 /**
182  * @title Burnable Token
183  * @dev Token that can be irreversibly burned (destroyed).
184  */
185 contract BurnableToken is BasicToken {
186 
187     event Burn(address indexed burner, uint256 value);
188 
189     /**
190      * @dev Burns a specific amount of tokens.
191      * @param _value The amount of token to be burned.
192      */
193     function burn(uint256 _value) public {
194         require(_value <= balances[msg.sender]);
195         // no need to require value <= totalSupply, since that would imply the
196         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
197 
198         address burner = msg.sender;
199         balances[burner] = balances[burner].sub(_value);
200         totalSupply = totalSupply.sub(_value);
201         Burn(burner, _value);
202     }
203 }
204 
205 
206 /**
207  * @title Standard ERC20 token
208  *
209  * @dev Implementation of the basic standard token.
210  * @dev https://github.com/ethereum/EIPs/issues/20
211  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
212  */
213 contract StandardToken is ERC20, BasicToken {
214 
215   mapping (address => mapping (address => uint256)) internal allowed;
216 
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param _from address The address which you want to send tokens from
221    * @param _to address The address which you want to transfer to
222    * @param _value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(address _owner, address _spender) public view returns (uint256) {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _addedValue The amount of tokens to increase the allowance by.
271    */
272   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
273     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
274     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _subtractedValue The amount of tokens to decrease the allowance by.
287    */
288   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
289     uint oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue > oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 
302 /*
303  * BeeToken is a standard ERC20 token with some additional functionalities:
304  * - Transfers are only enabled after contract owner enables it (after the ICO)
305  * - Contract sets 30% of the total supply as allowance for ICO contract
306  *
307  * Note: Token Offering == Initial Coin Offering(ICO)
308  */
309 
310 contract BeeToken is StandardToken, BurnableToken, Ownable {
311     string public constant symbol = "BEE";
312     string public constant name = "Bee Token";
313     uint8 public constant decimals = 18;
314     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
315     uint256 public constant TOKEN_OFFERING_ALLOWANCE = 150000000 * (10 ** uint256(decimals));
316     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
317     
318     // Address of token admin
319     address public adminAddr;
320     // Address of token offering
321     address public tokenOfferingAddr;
322     // Enable transfers after conclusion of token offering
323     bool public transferEnabled = false;
324     
325     /**
326      * Check if transfer is allowed
327      *
328      * Permissions:
329      *                                                       Owner    Admin    OffeirngContract    Others
330      * transfer (before transferEnabled is true)               x        x            x               x
331      * transferFrom (before transferEnabled is true)           x        v            v               x
332      * transfer/transferFrom after transferEnabled is true     v        x            x               v
333      */
334     modifier onlyWhenTransferAllowed() {
335         require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
336         _;
337     }
338 
339     /**
340      * Check if token offering address is set or not
341      */
342     modifier onlyTokenOfferingAddrNotSet() {
343         require(tokenOfferingAddr == address(0x0));
344         _;
345     }
346 
347     /**
348      * Check if address is a valid destination to transfer tokens to
349      * - must not be zero address
350      * - must not be the token address
351      * - must not be the owner's address
352      * - must not be the admin's address
353      * - must not be the token offering contract address
354      */
355     modifier validDestination(address to) {
356         require(to != address(0x0));
357         require(to != address(this));
358         require(to != owner);
359         require(to != address(adminAddr));
360         require(to != address(tokenOfferingAddr));
361         _;
362     }
363     
364     /**
365      * Token contract constructor
366      *
367      * @param admin Address of admin account
368      */
369     function BeeToken(address admin) public {
370         totalSupply = INITIAL_SUPPLY;
371         
372         // Mint tokens
373         balances[msg.sender] = totalSupply;
374         Transfer(address(0x0), msg.sender, totalSupply);
375 
376         // Approve allowance for admin account
377         adminAddr = admin;
378         approve(adminAddr, ADMIN_ALLOWANCE);
379     }
380 
381     /**
382      * Set token offering to approve allowance for offering contract to distribute tokens
383      *
384      * @param offeringAddr Address of token offerng contract
385      * @param amountForSale Amount of tokens for sale, set 0 to max out
386      */
387     function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
388         require(!transferEnabled);
389 
390         uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
391         require(amount <= TOKEN_OFFERING_ALLOWANCE);
392 
393         approve(offeringAddr, amount);
394         tokenOfferingAddr = offeringAddr;
395     }
396     
397     /**
398      * Enable transfers
399      */
400     function enableTransfer() external onlyOwner {
401         transferEnabled = true;
402 
403         // End the offering
404         approve(tokenOfferingAddr, 0);
405     }
406 
407     /**
408      * Transfer from sender to another account
409      *
410      * @param to Destination address
411      * @param value Amount of beetokens to send
412      */
413     function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
414         return super.transfer(to, value);
415     }
416     
417     /**
418      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
419      *
420      * @param from Origin address
421      * @param to Destination address
422      * @param value Amount of beetokens to send
423      */
424     function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
425         return super.transferFrom(from, to, value);
426     }
427     
428     /**
429      * Burn token, only owner is allowed to do this
430      *
431      * @param value Amount of tokens to burn
432      */
433     function burn(uint256 value) public {
434         require(transferEnabled || msg.sender == owner);
435         super.burn(value);
436     }
437 }
438 
439 contract BeeTokenOffering is Pausable {
440     using SafeMath for uint256;
441 
442     // Start and end timestamps where contributions are allowed (both inclusive)
443     uint256 public startTime;
444     uint256 public endTime;
445 
446     // Address where funds are collected
447     address public beneficiary;
448 
449     // Token to be sold
450     BeeToken public token;
451 
452     // Price of the tokens as in tokens per ether
453     uint256 public rate;
454 
455     // Amount of raised in Wei (1 ether)
456     uint256 public weiRaised;
457 
458     // Timelines for different contribution limit policy
459     uint256 public capDoublingTimestamp;
460     uint256 public capReleaseTimestamp;
461 
462     // Individual contribution limits in Wei per tier
463     uint256[3] public tierCaps;
464 
465     // Whitelists of participant address for each tier
466     mapping(uint8 => mapping(address => bool)) public whitelists;
467 
468     // Contributions in Wei for each participant
469     mapping(address => uint256) public contributions;
470 
471     // Funding cap in ETH. Change to equal $5M at time of token offering
472     uint256 public constant FUNDING_ETH_HARD_CAP = 5000 * 1 ether;
473 
474     // Min contribution is 0.1 ether
475     uint256 public constant MINIMUM_CONTRIBUTION = 10**17;
476 
477     // The current stage of the offering
478     Stages public stage;
479 
480     enum Stages { 
481         Setup,
482         OfferingStarted,
483         OfferingEnded
484     }
485 
486     event OfferingOpens(uint256 startTime, uint256 endTime);
487     event OfferingCloses(uint256 endTime, uint256 totalWeiRaised);
488     /**
489      * Event for token purchase logging
490      *
491      * @param purchaser Who paid for the tokens
492      * @param value Weis paid for purchase
493      * @return amount Amount of tokens purchased
494      */
495     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
496 
497     /**
498      * Modifier that requires certain stage before executing the main function body
499      *
500      * @param expectedStage Value that the current stage is required to match
501      */
502     modifier atStage(Stages expectedStage) {
503         require(stage == expectedStage);
504         _;
505     }
506 
507     /**
508      * Modifier that validates a purchase at a tier
509      * All the following has to be met:
510      * - current time within the offering period
511      * - valid sender address and ether value greater than 0.1
512      * - total Wei raised not greater than FUNDING_ETH_HARD_CAP
513      * - contribution per perticipant within contribution limit
514      *
515      * @param tier Index of the tier
516      */
517     modifier validPurchase(uint8 tier) {
518         require(tier < tierCaps.length);
519         require(now >= startTime && now <= endTime && stage == Stages.OfferingStarted);
520 
521         uint256 contributionInWei = msg.value;
522         address participant = msg.sender;
523         require(participant != address(0) && contributionInWei >= MINIMUM_CONTRIBUTION);
524         require(weiRaised.add(contributionInWei) <= FUNDING_ETH_HARD_CAP);
525 
526         uint256 initialCapInWei = tierCaps[tier];
527         
528         if (now < capDoublingTimestamp) {
529             require(contributions[participant].add(contributionInWei) <= initialCapInWei);
530         } else if (now < capReleaseTimestamp) {
531             require(contributions[participant].add(contributionInWei) <= initialCapInWei.mul(2));
532         }
533 
534         _;
535     }
536 
537     /**
538      * The constructor of the contract.
539      * Note: tierCaps[tier] define the individual contribution limits in Wei of each address
540      * per tier within the first tranche of the sale (sale start ~ capDoublingTimestamp)
541      * these limits are doubled between capDoublingTimestamp ~ capReleaseTimestamp
542      * and are lifted completely between capReleaseTimestamp ~ end time
543      *  
544      * @param beeToEtherRate Number of beetokens per ether
545      * @param beneficiaryAddr Address where funds are collected
546      * @param baseContributionCapInWei Base contribution limit in Wei per address
547      */
548     function BeeTokenOffering(
549         uint256 beeToEtherRate, 
550         address beneficiaryAddr, 
551         uint256 baseContributionCapInWei,
552         address tokenAddress
553     ) public {
554         require(beeToEtherRate > 0);
555         require(beneficiaryAddr != address(0));
556         require(tokenAddress != address(0));
557         require(baseContributionCapInWei >= MINIMUM_CONTRIBUTION);
558 
559         token = BeeToken(tokenAddress);
560         rate = beeToEtherRate;
561         beneficiary = beneficiaryAddr;
562         stage = Stages.Setup;
563 
564         // Contribution cap per tier in Wei
565         tierCaps[0] = baseContributionCapInWei.mul(3);
566         tierCaps[1] = baseContributionCapInWei.mul(2);
567         tierCaps[2] = baseContributionCapInWei;
568     }
569 
570     /**
571      * Fallback function can be used to buy tokens
572      */
573     function () public payable {
574         buy();
575     }
576 
577     /**
578      * Withdraw available ethers into beneficiary account, serves as a safety, should never be needed
579      */
580     function ownerSafeWithdrawal() external onlyOwner {
581         beneficiary.transfer(this.balance);
582     }
583 
584     function updateRate(uint256 beeToEtherRate) public onlyOwner atStage(Stages.Setup) {
585         rate = beeToEtherRate;
586     }
587 
588     /**
589      * Whitelist participant address per tier
590      * 
591      * @param tiers Array of indices of tier, each value should be less than tierCaps.length
592      * @param users Array of addresses to be whitelisted
593      */
594     function whitelist(uint8[] tiers, address[] users) public onlyOwner {
595         require(tiers.length == users.length);
596         for (uint32 i = 0; i < users.length; i++) {
597             require(tiers[i] < tierCaps.length);
598             whitelists[tiers[i]][users[i]] = true;
599         }
600     }
601 
602     /**
603      * Start the offering
604      *
605      * @param durationInSeconds Extra duration of the offering on top of the minimum 48 hours
606      */
607     function startOffering(uint256 durationInSeconds) public onlyOwner atStage(Stages.Setup) {
608         stage = Stages.OfferingStarted;
609         startTime = now;
610         capDoublingTimestamp = startTime + 24 hours;
611         capReleaseTimestamp = startTime + 48 hours;
612         endTime = capReleaseTimestamp.add(durationInSeconds);
613         OfferingOpens(startTime, endTime);
614     }
615 
616     /**
617      * End the offering
618      */
619     function endOffering() public onlyOwner atStage(Stages.OfferingStarted) {
620         endOfferingImpl();
621     }
622     
623     /**
624      * Function to invest ether to buy tokens, can be called directly or called by the fallback function
625      * Only whitelisted users can buy tokens.
626      *
627      * @return bool Return true if purchase succeeds, false otherwise
628      */
629     function buy() public payable whenNotPaused atStage(Stages.OfferingStarted) returns (bool) {
630         for (uint8 i = 0; i < tierCaps.length; ++i) {
631             if (whitelists[i][msg.sender]) {
632                 buyTokensTier(i);
633                 return true;
634             }
635         }
636         revert();
637     }
638 
639     /**
640      * Function that returns whether offering has ended
641      * 
642      * @return bool Return true if token offering has ended
643      */
644     function hasEnded() public view returns (bool) {
645         return now > endTime || stage == Stages.OfferingEnded;
646     }
647 
648     /**
649      * Internal function that buys token per tier
650      * 
651      * Investiment limit changes over time:
652      * 1) [offering starts ~ capDoublingTimestamp]:     1x of contribution limit per tier (1 * tierCaps[tier])
653      * 2) [capDoublingTimestamp ~ capReleaseTimestamp]: limit per participant is raised to 2x of contribution limit per tier (2 * tierCaps[tier])
654      * 3) [capReleaseTimestamp ~ offering ends]:        no limit per participant as along as total Wei raised is within FUNDING_ETH_HARD_CAP
655      *
656      * @param tier Index of tier of whitelisted participant
657      */
658     function buyTokensTier(uint8 tier) internal validPurchase(tier) {
659         address participant = msg.sender;
660         uint256 contributionInWei = msg.value;
661 
662         // Calculate token amount to be distributed
663         uint256 tokens = contributionInWei.mul(rate);
664         
665         if (!token.transferFrom(token.owner(), participant, tokens)) {
666             revert();
667         }
668 
669         weiRaised = weiRaised.add(contributionInWei);
670         contributions[participant] = contributions[participant].add(contributionInWei);
671         // Check if the funding cap has been reached, end the offering if so
672         if (weiRaised >= FUNDING_ETH_HARD_CAP) {
673             endOfferingImpl();
674         }
675         
676         // Transfer funds to beneficiary
677         beneficiary.transfer(contributionInWei);
678         TokenPurchase(msg.sender, contributionInWei, tokens);       
679     }
680 
681     /**
682      * End token offering by set the stage and endTime
683      */
684     function endOfferingImpl() internal {
685         endTime = now;
686         stage = Stages.OfferingEnded;
687         OfferingCloses(endTime, weiRaised);
688     }
689 
690     /**
691      * Allocate tokens for presale participants before public offering, can only be executed at Stages.Setup stage.
692      *
693      * @param to Participant address to send beetokens to
694      * @param tokens Amount of beetokens to be sent to parcitipant 
695      */
696     function allocateTokensBeforeOffering(address to, uint256 tokens)
697         public
698         onlyOwner
699         atStage(Stages.Setup)
700         returns (bool)
701     {
702         if (!token.transferFrom(token.owner(), to, tokens)) {
703             revert();
704         }
705         return true;
706     }
707     
708     /**
709      * Bulk version of allocateTokensBeforeOffering
710      */
711     function batchAllocateTokensBeforeOffering(address[] toList, uint256[] tokensList)
712         external
713         onlyOwner
714         atStage(Stages.Setup)
715         returns (bool)
716     {
717         require(toList.length == tokensList.length);
718 
719         for (uint32 i = 0; i < toList.length; i++) {
720             allocateTokensBeforeOffering(toList[i], tokensList[i]);
721         }
722         return true;
723     }
724 
725 }