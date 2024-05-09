1 pragma solidity ^0.5.1;
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
19 //   function Ownable() public {
20   constructor() public payable{
21       
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0;
99     }
100     uint256 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     assert(c >= a);
120     return c;
121   }
122   
123 function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
124     uint256 c = add(a,m);
125     uint256 d = sub(c,1);
126     return mul(div(d,m),m);
127   }
128 }
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158   using SafeMath for uint256;
159   uint256 public basePercent = 100;
160 
161   mapping(address => uint256) balances;
162 
163  function findTwoAnfHalfPercent(uint256 value) public view returns (uint256)  {
164     uint256 roundValue = value.ceil(basePercent);
165     uint256 onePercent = roundValue.mul(basePercent).div(4000);
166     return onePercent;
167   }
168   
169   function transfer(address to, uint256 value) public returns (bool) {
170     require(to != address(0));
171     require(value <= balances[msg.sender]);
172 
173     uint256 tokensToBurn = findTwoAnfHalfPercent(value);
174     uint256 tokensToTransfer = value.sub(tokensToBurn);
175 
176      balances[msg.sender] = balances[msg.sender].sub(value);
177      balances[to] = balances[to].add(tokensToTransfer);
178 
179     totalSupply = totalSupply.sub(tokensToBurn);
180 
181     emit Transfer(msg.sender, to, tokensToTransfer);
182     emit Transfer(msg.sender, address(0), tokensToBurn);
183     return true;
184   }
185   
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191 //   function transfer(address _to, uint256 _value) public returns (bool) {
192 //     require(_to != address(0));
193 //     require(_value <= balances[msg.sender]);
194 
195 //     // SafeMath.sub will throw if there is not enough balance.
196 //     balances[msg.sender] = balances[msg.sender].sub(_value);
197 //     balances[_to] = balances[_to].add(_value);
198 //     emit Transfer(msg.sender, _to, _value);
199 //     return true;
200 //   }
201   
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256 balance) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 /**
215  * @title Burnable Token
216  * @dev Token that can be irreversibly burned (destroyed).
217  */
218 contract BurnableToken is BasicToken {
219 
220     event Burn(address indexed burner, uint256 value);
221 
222     /**
223      * @dev Burns a specific amount of tokens.
224      * @param _value The amount of token to be burned.
225      */
226     function burn(uint256 _value) public {
227         require(_value <= balances[msg.sender]);
228         // no need to require value <= totalSupply, since that would imply the
229         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
230 
231         address burner = msg.sender;
232         balances[burner] = balances[burner].sub(_value);
233         totalSupply = totalSupply.sub(_value);
234         emit Burn(burner, _value);
235     }
236 }
237 
238 
239 /**
240  * @title Standard ERC20 token
241  *
242  * @dev Implementation of the basic standard token.
243  * @dev https://github.com/ethereum/EIPs/issues/20
244  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
245  */
246 contract StandardToken is ERC20, BasicToken {
247 
248   mapping (address => mapping (address => uint256)) internal allowed;
249 
250 
251   /**
252    * @dev Transfer tokens from one address to another
253    * @param _from address The address which you want to send tokens from
254    * @param _to address The address which you want to transfer to
255    * @param _value uint256 the amount of tokens to be transferred
256    */
257   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
258     require(_to != address(0));
259     require(_value <= balances[_from]);
260     require(_value <= allowed[_from][msg.sender]);
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271    *
272    * Beware that changing an allowance with this method brings the risk that someone may use both the old
273    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
274    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
275    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
276    * @param _spender The address which will spend the funds.
277    * @param _value The amount of tokens to be spent.
278    */
279   function approve(address _spender, uint256 _value) public returns (bool) {
280     allowed[msg.sender][_spender] = _value;
281     emit Approval(msg.sender, _spender, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Function to check the amount of tokens that an owner allowed to a spender.
287    * @param _owner address The address which owns the funds.
288    * @param _spender address The address which will spend the funds.
289    * @return A uint256 specifying the amount of tokens still available for the spender.
290    */
291   function allowance(address _owner, address _spender) public view returns (uint256) {
292     return allowed[_owner][_spender];
293   }
294 
295   /**
296    * @dev Increase the amount of tokens that an owner allowed to a spender.
297    *
298    * approve should be called when allowed[_spender] == 0. To increment
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    * @param _spender The address which will spend the funds.
303    * @param _addedValue The amount of tokens to increase the allowance by.
304    */
305   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
306     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311   /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender.
313    *
314    * approve should be called when allowed[_spender] == 0. To decrement
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _subtractedValue The amount of tokens to decrease the allowance by.
320    */
321   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
322     uint oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue > oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332 }
333 
334 
335 /*
336  * EqvcToken is a standard ERC20 token with some additional functionalities:
337  * - Transfers are only enabled after contract owner enables it (after the ICO)
338  *
339  * Note: Token Offering == Initial Coin Offering(ICO)
340  */
341 
342 contract EqvcTokens is StandardToken, Ownable {
343     string public constant symbol = "EQVC";
344     string public constant name = "EqvcToken";
345     uint8 public constant decimals = 0;
346     uint256 public constant INITIAL_SUPPLY = 2000000;
347     uint256 public constant TOKEN_OFFERING_ALLOWANCE = 2000000;
348     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
349     
350     // Address of token admin
351     address public adminAddr;
352 
353     // Address of token offering
354 	  address public tokenOfferingAddr;
355 
356     // Enable transfers after conclusion of token offering
357     bool public transferEnabled = false;
358     
359     /**
360      * Check if transfer is allowed
361      *
362      * Permissions:
363      *                                                       Owner    Admin    OffeirngContract    Others
364      * transfer (before transferEnabled is true)               x        x            x               x
365      * transferFrom (before transferEnabled is true)           x        v            v               x
366      * transfer/transferFrom after transferEnabled is true     v        x            x               v
367      */
368     modifier onlyWhenTransferAllowed() {
369         require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
370         _;
371     }
372 
373     /**
374      * Check if token offering address is set or not
375      */
376     modifier onlyTokenOfferingAddrNotSet() {
377         require(tokenOfferingAddr == address(0x0));
378         _;
379     }
380 
381     /**
382      * Check if address is a valid destination to transfer tokens to
383      * - must not be zero address
384      * - must not be the token address
385      * - must not be the owner's address
386      * - must not be the admin's address
387      * - must not be the token offering contract address
388      */
389     modifier validDestination(address to) {
390         require(to != address(0x0));
391         require(to != address(this));
392         require(to != owner);
393         require(to != address(adminAddr));
394         require(to != address(tokenOfferingAddr));
395         _;
396     }
397     
398     /**
399      * Token contract constructor
400      *
401      * @param admin Address of admin account
402      */
403     function EqvcToken(address admin) public {
404         totalSupply = INITIAL_SUPPLY;
405         
406         // Mint tokens
407         balances[msg.sender] = totalSupply;
408         emit Transfer(address(0x0), msg.sender, totalSupply);
409 
410         // Approve allowance for admin account
411         adminAddr = admin;
412         approve(adminAddr, ADMIN_ALLOWANCE);
413     }
414     
415     
416  
417 
418     /**
419      * Set token offering to approve allowance for offering contract to distribute tokens
420      *
421      * @param offeringAddr Address of token offering contract
422      * @param amountForSale Amount of tokens for sale, set 0 to max out
423      */
424     function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
425         require(!transferEnabled);
426 
427         uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
428         require(amount <= TOKEN_OFFERING_ALLOWANCE);
429 
430         approve(offeringAddr, amount);
431         tokenOfferingAddr = offeringAddr;
432     }
433     
434     /**
435      * Enable transfers
436      */
437     function enableTransfer() external onlyOwner {
438         transferEnabled = true;
439 
440         // End the offering
441         approve(tokenOfferingAddr, 0);
442     }
443 
444     /**
445      * Transfer from sender to another account
446      *
447      * @param to Destination address
448      * @param value Amount of Eqvcs to send
449      */
450     function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
451         return super.transfer(to, value);
452     }
453     
454     /**
455      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
456      *
457      * @param from Origin address
458      * @param to Destination address
459      * @param value Amount of Eqvcs to send
460      */
461     function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
462         return super.transferFrom(from, to, value);
463     }
464     
465 }
466 
467 contract EqvcsCrowdsale is Pausable {
468     using SafeMath for uint256;
469 
470      // Token to be sold
471     EqvcTokens public token;
472 
473     // Start and end timestamps where contributions are allowed (both inclusive)
474     uint256 public startTime;
475     uint256 public endTime;
476 
477     // Address where funds are collected
478     address payable  beneficiary;
479 
480     // Price of the tokens as in tokens per ether
481     uint256 public rate;
482 
483     // Amount of raised in Wei 
484     uint256 public EthRaised;
485 
486     // Timelines for contribution limit policy
487     uint256 public capReleaseTimestamp;
488 
489     uint256 public extraTime;
490 
491     // Whitelists of participant address
492     // mapping(address => bool) public whitelists;
493 
494     // Contributions in Wei for each participant
495     mapping(address => uint256) public contributions;
496 
497     // Funding cap in ETH. 
498      uint256 public constant FUNDING_ETH_HARD_CAP = 1300;
499 
500     // Min contribution is 0.1 ether
501     uint256 public minContribution = 1 ;
502 
503     // Max contribution is 10 ether
504     uint256 public maxContribution = 15;
505 
506     //remainCap
507      uint256 public remainCap;
508 
509     // The current stage of the offering
510     Stages public stage;
511 
512     enum Stages { 
513         Setup,
514         OfferingStarted,
515         OfferingEnded
516     }
517 
518     event OfferingOpens(uint256 startTime, uint256 endTime);
519     event OfferingCloses(uint256 endTime, uint256 totalEthRaised);
520     /**
521      * Event for token purchase logging
522      *
523      * @param purchaser Who paid for the tokens
524      * @param value Weis paid for purchase
525      * @return amount Amount of tokens purchased
526      */
527     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
528 
529     /**
530      * Modifier that requires certain stage before executing the main function body
531      *
532      * @param expectedStage Value that the current stage is required to match
533      */
534     modifier atStage(Stages expectedStage) {
535         require(stage == expectedStage);
536         _;
537     }
538 
539     
540     /**
541      * The constructor of the contract.
542      * @param eqvcToEtherRate Number of Eqvcs per ether
543      * @param beneficiaryAddr Address where funds are collected
544      */
545     function EqvcCrowdsale(
546         uint256 eqvcToEtherRate, 
547         address payable beneficiaryAddr, 
548         address tokenAddress
549     ) public {
550         require(eqvcToEtherRate > 0);
551         require(beneficiaryAddr != address(0));
552         require(tokenAddress != address(0));
553 
554         token = EqvcTokens(tokenAddress);
555         rate = eqvcToEtherRate;
556         beneficiary = beneficiaryAddr;
557         stage = Stages.Setup;
558     }
559 
560     /**
561      * Fallback function can be used to buy tokens
562      */
563     function ()  payable external {
564         buy();
565     }
566 
567     // /**
568     //  * Withdraw available ethers into beneficiary account, serves as a safety, should never be needed
569     //  */
570     function ownerSafeWithdrawal() external onlyOwner {
571         beneficiary.transfer(address(this).balance);
572     }
573 
574     function updateRate(uint256 eqvcToEtherRate) public onlyOwner atStage(Stages.Setup) {
575         rate = eqvcToEtherRate;
576     }
577 
578     /**
579      * Whitelist participant address 
580      * 
581      * 
582      * @param users Array of addresses to be whitelisted
583      */
584     // function whitelist(address[] memory users) public onlyOwner {
585     //     for (uint32 i = 0; i < users.length; i++) {
586     //         whitelists[users[i]] = true;
587     //     }
588     // }
589     // function whitelistRemove(address user) public onlyOwner{
590     //   require(whitelists[user]);
591     //   whitelists[user] = false;
592     // }
593     /**
594      * Start the offering
595      *
596      * @param durationInSeconds Extra duration of the offering on top of the minimum 4 hours
597      */
598     function startOffering(uint256 durationInSeconds) public onlyOwner atStage(Stages.Setup) {
599         stage = Stages.OfferingStarted;
600         startTime = now;
601         capReleaseTimestamp = startTime + 1 days;
602         extraTime = capReleaseTimestamp + 365 days;
603         endTime = extraTime.add(durationInSeconds);
604         emit OfferingOpens(startTime, endTime);
605     }
606 
607     /**
608      * End the offering
609      */
610     function endOffering() public onlyOwner atStage(Stages.OfferingStarted) {
611         endOfferingImpl();
612     }
613     
614   
615     /**
616      * Function to invest ether to buy tokens, can be called directly or called by the fallback function
617      * Only whitelisted users can buy tokens.
618      *
619      * @return bool Return true if purchase succeeds, false otherwise
620      */
621     function buy() public payable whenNotPaused atStage(Stages.OfferingStarted) returns (bool) {
622         // if (whitelists[msg.sender]) {
623               buyTokens();
624               return true;
625         // }
626         revert();
627     }
628 
629     /**
630      * Function that returns whether offering has ended
631      * 
632      * @return bool Return true if token offering has ended
633      */
634     function hasEnded() public view returns (bool) {
635         return now > endTime || stage == Stages.OfferingEnded;
636     }
637 
638     /**
639      * Modifier that validates a purchase at a tier
640      * All the following has to be met:
641      * - current time within the offering period
642      * - valid sender address and ether value greater than 0.1
643      * - total Wei raised not greater than FUNDING_ETH_HARD_CAP
644      * - contribution per perticipant within contribution limit
645      *
646      * 
647      */
648     modifier validPurchase() {
649         require(now >= startTime && now <= endTime && stage == Stages.OfferingStarted);
650         if(now > capReleaseTimestamp) {
651           maxContribution = 2000;
652         }
653         uint256 contributionInETH = uint256(msg.value).div(10**18);
654         address participant = msg.sender; 
655 
656 
657         require(contributionInETH <= maxContribution.sub(contributions[participant]));
658         require(participant != address(0) && contributionInETH >= minContribution && contributionInETH <= maxContribution);
659         require(EthRaised.add(contributionInETH) <= FUNDING_ETH_HARD_CAP);
660         
661         _;
662     }
663 
664 
665     function buyTokens() internal validPurchase {
666       
667         // contributionInETH amount in eth
668         uint256 contributionInETH = uint256(msg.value).div(10**18);
669         address participant = msg.sender;
670 
671         // Calculate token amount to be distributed
672         uint256 tokens = contributionInETH.mul(rate);
673         
674         if (!token.transferFrom(token.owner(), participant, tokens)) {
675             revert();
676         }
677 
678         EthRaised = EthRaised.add(contributionInETH);
679         contributions[participant] = contributions[participant].add(contributionInETH);
680 
681         remainCap = FUNDING_ETH_HARD_CAP.sub(EthRaised);
682 
683         
684        // Check if the funding cap has been reached, end the offering if so
685         if (EthRaised >= FUNDING_ETH_HARD_CAP) {
686             endOfferingImpl();
687         }
688         
689         // // Transfer funds to beneficiary
690         // transfer(beneficiary,contributionInETH);
691         beneficiary.transfer(contributionInETH.mul(10**18));
692         emit TokenPurchase(msg.sender, contributionInETH, tokens);          
693     }
694 
695 
696     /**
697      * End token offering by set the stage and endTime
698      */
699     function endOfferingImpl() internal{
700         endTime = now;
701         stage = Stages.OfferingEnded;
702         emit OfferingCloses(endTime, EthRaised);
703     }
704 
705     /**
706      * Allocate tokens for presale participants before public offering, can only be executed at Stages.Setup stage.
707      *
708      * @param to Participant address to send Eqvcs to
709      * @param tokens Amount of Eqvcs to be sent to parcitipant 
710      */
711     function allocateTokens(address to, uint256 tokens) public onlyOwner returns (bool) {
712         if (!token.transferFrom(token.owner(), to, tokens)) {
713             revert();
714         }
715         return true;
716     }
717     
718     /**
719      * Bulk version of allocateTokens
720      */
721     function batchallocateTokens(address[] memory toList, uint256[] memory tokensList)  public onlyOwner  returns (bool)  {
722         require(toList.length == tokensList.length);
723 
724         for (uint32 i = 0; i < toList.length; i++) {
725             allocateTokens(toList[i], tokensList[i]);
726         }
727         return true;
728     }
729 
730 }