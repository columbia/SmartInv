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
303  * DockToken is a standard ERC20 token with some additional functionalities:
304  * - Transfers are only enabled after contract owner enables it (after the ICO)
305  *
306  * Note: Token Offering == Initial Coin Offering(ICO)
307  */
308 
309 contract DockToken is StandardToken, Ownable {
310     string public constant symbol = "DOCK";
311     string public constant name = "DockToken";
312     uint8 public constant decimals = 18;
313     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
314     uint256 public constant TOKEN_OFFERING_ALLOWANCE = 1000000000 * (10 ** uint256(decimals));
315     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
316     
317     // Address of token admin
318     address public adminAddr;
319 
320     // Address of token offering
321 	  address public tokenOfferingAddr;
322 
323     // Enable transfers after conclusion of token offering
324     bool public transferEnabled = false;
325     
326     /**
327      * Check if transfer is allowed
328      *
329      * Permissions:
330      *                                                       Owner    Admin    OffeirngContract    Others
331      * transfer (before transferEnabled is true)               x        x            x               x
332      * transferFrom (before transferEnabled is true)           x        v            v               x
333      * transfer/transferFrom after transferEnabled is true     v        x            x               v
334      */
335     modifier onlyWhenTransferAllowed() {
336         require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
337         _;
338     }
339 
340     /**
341      * Check if token offering address is set or not
342      */
343     modifier onlyTokenOfferingAddrNotSet() {
344         require(tokenOfferingAddr == address(0x0));
345         _;
346     }
347 
348     /**
349      * Check if address is a valid destination to transfer tokens to
350      * - must not be zero address
351      * - must not be the token address
352      * - must not be the owner's address
353      * - must not be the admin's address
354      * - must not be the token offering contract address
355      */
356     modifier validDestination(address to) {
357         require(to != address(0x0));
358         require(to != address(this));
359         require(to != owner);
360         require(to != address(adminAddr));
361         require(to != address(tokenOfferingAddr));
362         _;
363     }
364     
365     /**
366      * Token contract constructor
367      *
368      * @param admin Address of admin account
369      */
370     function DockToken(address admin) public {
371         totalSupply = INITIAL_SUPPLY;
372         
373         // Mint tokens
374         balances[msg.sender] = totalSupply;
375         Transfer(address(0x0), msg.sender, totalSupply);
376 
377         // Approve allowance for admin account
378         adminAddr = admin;
379         approve(adminAddr, ADMIN_ALLOWANCE);
380     }
381 
382     /**
383      * Set token offering to approve allowance for offering contract to distribute tokens
384      *
385      * @param offeringAddr Address of token offering contract
386      * @param amountForSale Amount of tokens for sale, set 0 to max out
387      */
388     function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
389         require(!transferEnabled);
390 
391         uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
392         require(amount <= TOKEN_OFFERING_ALLOWANCE);
393 
394         approve(offeringAddr, amount);
395         tokenOfferingAddr = offeringAddr;
396     }
397     
398     /**
399      * Enable transfers
400      */
401     function enableTransfer() external onlyOwner {
402         transferEnabled = true;
403 
404         // End the offering
405         approve(tokenOfferingAddr, 0);
406     }
407 
408     /**
409      * Transfer from sender to another account
410      *
411      * @param to Destination address
412      * @param value Amount of docks to send
413      */
414     function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
415         return super.transfer(to, value);
416     }
417     
418     /**
419      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
420      *
421      * @param from Origin address
422      * @param to Destination address
423      * @param value Amount of docks to send
424      */
425     function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
426         return super.transferFrom(from, to, value);
427     }
428     
429 }
430 
431 contract DockCrowdsale is Pausable {
432     using SafeMath for uint256;
433 
434      // Token to be sold
435     DockToken public token;
436 
437     // Start and end timestamps where contributions are allowed (both inclusive)
438     uint256 public startTime;
439     uint256 public endTime;
440 
441     // Address where funds are collected
442     address public beneficiary;
443 
444     // Price of the tokens as in tokens per ether
445     uint256 public rate;
446 
447     // Amount of raised in Wei 
448     uint256 public weiRaised;
449 
450     // Timelines for contribution limit policy
451     uint256 public capReleaseTimestamp;
452 
453     uint256 public extraTime;
454 
455     // Whitelists of participant address
456     mapping(address => bool) public whitelists;
457 
458     // Contributions in Wei for each participant
459     mapping(address => uint256) public contributions;
460 
461     // Funding cap in ETH. 
462     uint256 public constant FUNDING_ETH_HARD_CAP = 9123 * 1 ether;
463 
464     // Min contribution is 0.01 ether
465     uint256 public minContribution = 10**16;
466 
467     // Max contribution is 1 ether
468     uint256 public maxContribution = 10**18;
469 
470     //remainCap
471     uint256 public remainCap;
472 
473     // The current stage of the offering
474     Stages public stage;
475 
476     enum Stages { 
477         Setup,
478         OfferingStarted,
479         OfferingEnded
480     }
481 
482     event OfferingOpens(uint256 startTime, uint256 endTime);
483     event OfferingCloses(uint256 endTime, uint256 totalWeiRaised);
484     /**
485      * Event for token purchase logging
486      *
487      * @param purchaser Who paid for the tokens
488      * @param value Weis paid for purchase
489      * @return amount Amount of tokens purchased
490      */
491     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
492 
493     /**
494      * Modifier that requires certain stage before executing the main function body
495      *
496      * @param expectedStage Value that the current stage is required to match
497      */
498     modifier atStage(Stages expectedStage) {
499         require(stage == expectedStage);
500         _;
501     }
502 
503     
504     /**
505      * The constructor of the contract.
506      * @param dockToEtherRate Number of docks per ether
507      * @param beneficiaryAddr Address where funds are collected
508      */
509     function DockCrowdsale(
510         uint256 dockToEtherRate, 
511         address beneficiaryAddr, 
512         address tokenAddress
513     ) public {
514         require(dockToEtherRate > 0);
515         require(beneficiaryAddr != address(0));
516         require(tokenAddress != address(0));
517 
518         token = DockToken(tokenAddress);
519         rate = dockToEtherRate;
520         beneficiary = beneficiaryAddr;
521         stage = Stages.Setup;
522     }
523 
524     /**
525      * Fallback function can be used to buy tokens
526      */
527     function () public payable {
528         buy();
529     }
530 
531     /**
532      * Withdraw available ethers into beneficiary account, serves as a safety, should never be needed
533      */
534     function ownerSafeWithdrawal() external onlyOwner {
535         beneficiary.transfer(this.balance);
536     }
537 
538     function updateRate(uint256 dockToEtherRate) public onlyOwner atStage(Stages.Setup) {
539         rate = dockToEtherRate;
540     }
541 
542     /**
543      * Whitelist participant address 
544      * 
545      * 
546      * @param users Array of addresses to be whitelisted
547      */
548     function whitelist(address[] users) public onlyOwner {
549         for (uint32 i = 0; i < users.length; i++) {
550             whitelists[users[i]] = true;
551         }
552     }
553     function whitelistRemove(address user) public onlyOwner{
554       require(whitelists[user]);
555       whitelists[user] = false;
556     }
557     /**
558      * Start the offering
559      *
560      * @param durationInSeconds Extra duration of the offering on top of the minimum 4 hours
561      */
562     function startOffering(uint256 durationInSeconds) public onlyOwner atStage(Stages.Setup) {
563         stage = Stages.OfferingStarted;
564         startTime = now;
565         capReleaseTimestamp = startTime + 5 hours;
566         extraTime = capReleaseTimestamp + 7 days;
567         endTime = extraTime.add(durationInSeconds);
568         OfferingOpens(startTime, endTime);
569     }
570 
571     /**
572      * End the offering
573      */
574     function endOffering() public onlyOwner atStage(Stages.OfferingStarted) {
575         endOfferingImpl();
576     }
577     
578   
579     /**
580      * Function to invest ether to buy tokens, can be called directly or called by the fallback function
581      * Only whitelisted users can buy tokens.
582      *
583      * @return bool Return true if purchase succeeds, false otherwise
584      */
585     function buy() public payable whenNotPaused atStage(Stages.OfferingStarted) returns (bool) {
586         if (whitelists[msg.sender]) {
587               buyTokens();
588               return true;
589         }
590         revert();
591     }
592 
593     /**
594      * Function that returns whether offering has ended
595      * 
596      * @return bool Return true if token offering has ended
597      */
598     function hasEnded() public view returns (bool) {
599         return now > endTime || stage == Stages.OfferingEnded;
600     }
601 
602     /**
603      * Modifier that validates a purchase at a tier
604      * All the following has to be met:
605      * - current time within the offering period
606      * - valid sender address and ether value greater than 0.1
607      * - total Wei raised not greater than FUNDING_ETH_HARD_CAP
608      * - contribution per perticipant within contribution limit
609      *
610      * 
611      */
612     modifier validPurchase() {
613         require(now >= startTime && now <= endTime && stage == Stages.OfferingStarted);
614         if(now > capReleaseTimestamp) {
615           maxContribution = 9123 * 1 ether;
616         }
617         uint256 contributionInWei = msg.value;
618         address participant = msg.sender; 
619 
620 
621         require(contributionInWei <= maxContribution.sub(contributions[participant]));
622         require(participant != address(0) && contributionInWei >= minContribution && contributionInWei <= maxContribution);
623         require(weiRaised.add(contributionInWei) <= FUNDING_ETH_HARD_CAP);
624         
625         _;
626     }
627 
628 
629     function buyTokens() internal validPurchase {
630       
631         uint256 contributionInWei = msg.value;
632         address participant = msg.sender;
633 
634         // Calculate token amount to be distributed
635         uint256 tokens = contributionInWei.mul(rate);
636         
637         if (!token.transferFrom(token.owner(), participant, tokens)) {
638             revert();
639         }
640 
641         weiRaised = weiRaised.add(contributionInWei);
642         contributions[participant] = contributions[participant].add(contributionInWei);
643 
644         remainCap = FUNDING_ETH_HARD_CAP.sub(weiRaised);
645 
646         
647         // Check if the funding cap has been reached, end the offering if so
648         if (weiRaised >= FUNDING_ETH_HARD_CAP) {
649             endOfferingImpl();
650         }
651         
652         // Transfer funds to beneficiary
653         beneficiary.transfer(contributionInWei);
654         TokenPurchase(msg.sender, contributionInWei, tokens);       
655     }
656 
657 
658     /**
659      * End token offering by set the stage and endTime
660      */
661     function endOfferingImpl() internal {
662         endTime = now;
663         stage = Stages.OfferingEnded;
664         OfferingCloses(endTime, weiRaised);
665     }
666 
667     /**
668      * Allocate tokens for presale participants before public offering, can only be executed at Stages.Setup stage.
669      *
670      * @param to Participant address to send docks to
671      * @param tokens Amount of docks to be sent to parcitipant 
672      */
673     function allocateTokensBeforeOffering(address to, uint256 tokens) public onlyOwner atStage(Stages.Setup) returns (bool) {
674         if (!token.transferFrom(token.owner(), to, tokens)) {
675             revert();
676         }
677         return true;
678     }
679     
680     /**
681      * Bulk version of allocateTokensBeforeOffering
682      */
683     function batchAllocateTokensBeforeOffering(address[] toList, uint256[] tokensList) external onlyOwner  atStage(Stages.Setup)  returns (bool)  {
684         require(toList.length == tokensList.length);
685 
686         for (uint32 i = 0; i < toList.length; i++) {
687             allocateTokensBeforeOffering(toList[i], tokensList[i]);
688         }
689         return true;
690     }
691 
692 }