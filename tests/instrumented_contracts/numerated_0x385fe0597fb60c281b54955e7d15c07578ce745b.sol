1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18 
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
24         assert(b <= a);
25 
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32 
33         return c;
34     }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address and
40  *      provides basic authorization control functions
41  */
42 contract Ownable {
43     // Public properties
44     address public owner;
45 
46     // Log if ownership has been changed
47     event ChangeOwnership(address indexed _owner, address indexed _newOwner);
48 
49     // Checks if address is an owner
50     modifier OnlyOwner() {
51         require(msg.sender == owner);
52 
53         _;
54     }
55 
56     // The Ownable constructor sets the owner address
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     // Transfer current ownership to the new account
62     function transferOwnership(address _newOwner) public OnlyOwner {
63         require(_newOwner != address(0x0));
64 
65         owner = _newOwner;
66 
67         emit ChangeOwnership(owner, _newOwner);
68     }
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76     /*
77     * @dev Event to notify listeners about pause.
78     * @param pauseReason  string Reason the token was paused for.
79     */
80     event Pause(string pauseReason);
81     /*
82     * @dev Event to notify listeners about pause.
83     * @param unpauseReason  string Reason the token was unpaused for.
84     */
85     event Unpause(string unpauseReason);
86 
87     bool public isPaused;
88     string public pauseNotice;
89 
90     /**
91      * @dev Modifier to make a function callable only when the contract is not paused.
92      */
93     modifier IsNotPaused() {
94         require(!isPaused);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable only when the contract is paused.
100      */
101     modifier IsPaused() {
102         require(isPaused);
103         _;
104     }
105 
106     /**
107     * @dev called by the owner to pause, triggers stopped state
108     * @param _reason string The reason for the pause.
109     */
110     function pause(string _reason) OnlyOwner IsNotPaused public {
111         isPaused = true;
112         pauseNotice = _reason;
113         emit Pause(_reason);
114     }
115 
116     /**
117      * @dev called by the owner to unpause, returns to normal state
118      * @param _reason string Reason for the un pause.
119      */
120     function unpause(string _reason) OnlyOwner IsPaused public {
121         isPaused = false;
122         pauseNotice = _reason;
123         emit Unpause(_reason);
124     }
125 }
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133     uint256 public totalSupply;
134 
135     function balanceOf(address who) public view returns(uint256 theBalance);
136     function transfer(address to, uint256 value) public returns(bool success);
137 
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146     function allowance(address owner, address spender) public view returns(uint256 theAllowance);
147     function transferFrom(address from, address to, uint256 value) public returns(bool success);
148     function approve(address spender, uint256 value) public returns(bool success);
149 
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken without allowances.
156  */
157 contract BasicToken is ERC20Basic {
158     using SafeMath for uint256;
159 
160     // Balances for each account
161     mapping(address => uint256) balances;
162 
163     /**
164     * @dev Get the token balance for account
165     * @param _address The address to query the balance of._address
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168     function balanceOf(address _address) public constant returns(uint256 theBalance){
169         return balances[_address];
170     }
171 
172     /**
173     * @dev Transfer the balance from owner's account to another account
174     * @param _to The address to transfer to.
175     * @param _value The amount to be transferred.
176     * @return Returns true if transfer has been successful
177     */
178     function transfer(address _to, uint256 _value) public returns(bool success){
179         require(_to != address(0x0) && _value <= balances[msg.sender]);
180 
181         balances[msg.sender] = balances[msg.sender].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183 
184         emit Transfer(msg.sender, _to, _value);
185 
186         return true;
187     }
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  */
196 contract StandardToken is BasicToken, ERC20 {
197     // Owner of account approves the transfer of an amount to another account
198     mapping (address => mapping (address => uint256)) allowed;
199 
200     /**
201      * @dev Returns the amount of tokens approved by the owner that can be transferred to the spender's account
202      * @param _owner The address which owns the funds.
203      * @param _spender The address which will spend the funds.
204      * @return An uint256 specifying the amount of tokens still available for the spender.
205      */
206     function allowance(address _owner, address _spender) public constant returns(uint256 theAllowance){
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212      *
213      * To change the approve amount you first have to reduce the addresses`
214      * allowance to zero by calling `approve(_spender, 0)` if it is not
215      * already 0 to mitigate the race condition described here:
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217      *
218      * @param _spender The address which will spend the funds.
219      * @param _value The amount of tokens to be spent.
220      */
221     function approve(address _spender, uint256 _value) public returns(bool success){
222         require(allowed[msg.sender][_spender] == 0 || _value == 0);
223 
224         allowed[msg.sender][_spender] = _value;
225         emit Approval(msg.sender, _spender, _value);
226 
227         return true;
228     }
229 
230     /**
231      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
232      *
233      * @param _from  Origin address
234      * @param _to    Destination address
235      * @param _value Amount of CHR tokens to send
236      */
237     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
238         require(_to != address(0));
239         require(_value <= balances[_from]);
240         require(_value <= allowed[_from][msg.sender]);
241 
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244 
245         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246 
247         emit Transfer(_from, _to, _value);
248 
249         return true;
250     }
251 }
252 
253 /**
254  * @title Burnable Token
255  * @dev Token that can be irreversibly burned (destroyed).
256  */
257 contract BurnableToken is BasicToken {
258     event Burn(address indexed burner, uint256 value);
259 
260     /**
261      * @dev Burns a specific amount of tokens.
262      * @param _value The amount of token to be burned.
263      */
264     function burn(uint256 _value) public {
265         require(_value <= balances[msg.sender]);
266 
267         balances[msg.sender] = balances[msg.sender].sub(_value);
268         totalSupply = totalSupply.sub(_value);
269 
270         emit Burn(msg.sender, _value);
271     }
272 }
273 
274 /**
275  * CHERR.IO is a standard ERC20 token with some additional functionalities:
276  * - Transfers are only enabled after contract owner enables it (after the ICO)
277  * - Contract sets 60% of the total supply as allowance for ICO contract
278  */
279 contract Cherrio is StandardToken, BurnableToken, Ownable, Pausable {
280     using SafeMath for uint256;
281 
282     // Metadata
283     string  public constant name = "CHERR.IO";
284     string  public constant symbol = "CHR";
285     uint8   public constant decimals = 18;
286 
287     // Token supplies
288     uint256 public constant INITIAL_SUPPLY =  200000000 * (10 ** uint256(decimals));
289     uint256 public constant ADMIN_ALLOWANCE =  80000000 * (10 ** uint256(decimals));
290     uint256 public constant CONTRACT_ALLOWANCE = INITIAL_SUPPLY - ADMIN_ALLOWANCE;
291 
292     // Funding cap in ETH. Change to equal $12M at time of token offering
293     uint256 public constant FUNDING_ETH_HARD_CAP = 15000 ether;
294     // Minimum cap in ETH. Change to equal $3M at time of token offering
295     uint256 public constant MINIMUM_ETH_SOFT_CAP = 3750 ether;
296     // Min contribution is 0.1 ether
297     uint256 public constant MINIMUM_CONTRIBUTION = 100 finney;
298     // Price of the tokens as in tokens per ether
299     uint256 public constant RATE = 5333;
300     // Price of the tokens in tier 1
301     uint256 public constant RATE_TIER1 = 8743;
302     // Price of the tokens in tier 2
303     uint256 public constant RATE_TIER2 = 7306;
304     // Price of the tokens in tier 3
305     uint256 public constant RATE_TIER3 = 6584;
306     // Price of the tokens in public sale for limited timeline
307     uint256 public constant RATE_PUBLIC_SALE = 5926;
308     // Maximum cap for tier 1 (60M CHR tokens)
309     uint256 public constant TIER1_CAP = 60000000 * (10 ** uint256(decimals));
310     // Maximum cap for tier 2 (36M CHR tokens)
311     uint256 public constant TIER2_CAP = 36000000 * (10 ** uint256(decimals));
312 
313     // Maximum cap for each contributor in tier 1
314     uint256 public participantCapTier1;
315     // Maximum cap for each contributor in tier 2
316     uint256 public participantCapTier2;
317 
318     // ETH cap for pool addres only in tier 1
319     uint256 public poolAddressCapTier1;
320     // ETH cap for pool addres only in tier 2
321     uint256 public poolAddressCapTier2;
322 
323     // The address of the token admin
324     address public adminAddress;
325     // The address where ETH funds are collected
326     address public beneficiaryAddress;
327     // The address of the contract
328     address public contractAddress;
329     // The address of the pool who can send unlimited ETH to the contract
330     address public poolAddress;
331 
332     // Enable transfers after conclusion of the token offering
333     bool public transferIsEnabled;
334 
335     // Amount of raised in Wei
336     uint256 public weiRaised;
337 
338     // Amount of CHR tokens sent to participant for presale and public sale
339     uint256[4] public tokensSent;
340 
341     // Start of public pre-sale in timestamp
342     uint256 startTimePresale;
343 
344     // Start and end time of public sale in timestamp
345     uint256 startTime;
346     uint256 endTime;
347 
348     // Discount period for public sale
349     uint256 publicSaleDiscountEndTime;
350 
351     // End time limits in timestamp for each tier bonus
352     uint256[3] public tierEndTime;
353 
354     //Check if contract address is already set
355     bool contractAddressIsSet;
356 
357     struct Contributor {
358         bool canContribute;
359         uint8 tier;
360         uint256 contributionInWeiTier1;
361         uint256 contributionInWeiTier2;
362         uint256 contributionInWeiTier3;
363         uint256 contributionInWeiPublicSale;
364     }
365 
366     struct Pool {
367         uint256 contributionInWei;
368     }
369 
370     enum Stages {
371         Pending,
372         PreSale,
373         PublicSale,
374         Ended
375     }
376 
377     // The current stage of the offering
378     Stages public stage;
379 
380     mapping(address => Contributor) public contributors;
381     mapping(address => mapping(uint8 => Pool)) public pool;
382 
383     // Check if transfer is enabled
384     modifier TransferIsEnabled {
385         require(transferIsEnabled || msg.sender == adminAddress || msg.sender == contractAddress);
386 
387         _;
388     }
389 
390     /**
391      * @dev Check if address is a valid destination to transfer tokens to
392      * - must not be zero address
393      * - must not be the token address
394      * - must not be the owner's address
395      * - must not be the admin's address
396      * - must not be the token offering contract address
397      * - must not be the beneficiary address
398      */
399     modifier ValidDestination(address _to) {
400         require(_to != address(0x0));
401         require(_to != address(this));
402         require(_to != owner);
403         require(_to != address(adminAddress));
404         require(_to != address(contractAddress));
405         require(_to != address(beneficiaryAddress));
406 
407         _;
408     }
409 
410     /**
411      * Modifier that requires certain stage before executing the main function body
412      *
413      * @param _expectedStage Value that the current stage is required to match
414      */
415     modifier AtStage(Stages _expectedStage) {
416         require(stage == _expectedStage);
417 
418         _;
419     }
420 
421     // Check if ICO is live
422     modifier CheckIfICOIsLive() {
423         require(stage != Stages.Pending && stage != Stages.Ended);
424 
425         if(stage == Stages.PreSale) {
426             require(
427                 startTimePresale > 0 &&
428                 now >= startTimePresale &&
429                 now <= tierEndTime[2]
430             );
431         }
432         else {
433             require(
434                 startTime > 0 &&
435                 now >= startTime &&
436                 now <= endTime
437             );
438         }
439 
440         _;
441     }
442 
443     // Check if participant sent more then miniminum required contribution
444     modifier CheckPurchase() {
445         require(msg.value >= MINIMUM_CONTRIBUTION);
446 
447         _;
448     }
449 
450     /**
451      * Event for token purchase logging
452      *
453      * @param _purchaser Participant who paid for CHR tokens
454      * @param _value     Amount in WEI paid for token
455      * @param _tokens    Amount of tokens purchased
456      */
457     event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _tokens);
458 
459     /**
460      * Event when token offering started
461      *
462      * @param _msg       Message
463      * @param _startTime Start time in timestamp
464      * @param _endTime   End time in timestamp
465      */
466     event OfferingOpens(string _msg, uint256 _startTime, uint256 _endTime);
467 
468     /**
469      * Event when token offering ended and how much has been raised in wei
470      *
471      * @param _endTime        End time in timestamp
472      * @param _totalWeiRaised Total raised funds in wei
473      */
474     event OfferingCloses(uint256 _endTime, uint256 _totalWeiRaised);
475 
476     /**
477      * Cherrio constructor
478      */
479     function Cherrio() public {
480         totalSupply = INITIAL_SUPPLY;
481 
482         // Mint tokens
483         balances[msg.sender] = totalSupply;
484         emit Transfer(address(0x0), msg.sender, totalSupply);
485 
486         // Aprove an allowance for admin account
487         adminAddress = 0xe0509bB3921aacc433108D403f020a7c2f92e936;
488         approve(adminAddress, ADMIN_ALLOWANCE);
489 
490         participantCapTier1 = 100 ether;
491         participantCapTier2 = 100 ether;
492         poolAddressCapTier1 = 2000 ether; 
493         poolAddressCapTier2 = 2000 ether;
494 
495         weiRaised = 0;
496         startTimePresale = 0;
497         startTime = 0;
498         endTime = 0;
499         publicSaleDiscountEndTime = 0;
500         transferIsEnabled = false;
501         contractAddressIsSet = false;
502     }
503 
504     /**
505      * Add approved addresses
506      *
507      * @param _addresses Array of approved addresses
508      * @param _tier      Tier
509      */
510     function addApprovedAddresses(address[] _addresses, uint8 _tier) external OnlyOwner {
511         uint256 length = _addresses.length;
512 
513         for(uint256 i = 0; i < length; i++) {
514             if(!contributors[_addresses[i]].canContribute) {
515                 contributors[_addresses[i]].canContribute = true;
516                 contributors[_addresses[i]].tier = _tier;
517                 contributors[_addresses[i]].contributionInWeiTier1 = 0;
518                 contributors[_addresses[i]].contributionInWeiTier2 = 0;
519                 contributors[_addresses[i]].contributionInWeiTier3 = 0;
520                 contributors[_addresses[i]].contributionInWeiPublicSale = 0;
521             }
522         }
523     }
524 
525     /**
526      * Add approved address
527      *
528      * @param _address Approved address
529      * @param _tier    Tier
530      */
531     function addSingleApprovedAddress(address _address, uint8 _tier) external OnlyOwner {
532         if(!contributors[_address].canContribute) {
533             contributors[_address].canContribute = true;
534             contributors[_address].tier = _tier;
535             contributors[_address].contributionInWeiTier1 = 0;
536             contributors[_address].contributionInWeiTier2 = 0;
537             contributors[_address].contributionInWeiTier3 = 0;
538             contributors[_address].contributionInWeiPublicSale = 0;
539         }
540     }
541 
542     /**
543      * Set token offering address to approve allowance for offering contract to distribute tokens
544      */
545     function setTokenOffering() external OnlyOwner{
546         require(!contractAddressIsSet);
547         require(!transferIsEnabled);
548 
549         contractAddress = address(this);
550         approve(contractAddress, CONTRACT_ALLOWANCE);
551 
552         beneficiaryAddress = 0xAec8c4242c8c2E532c6D6478A7de380263234845;
553         poolAddress = 0x1A2C916B640520E1e93A78fEa04A49D8345a5aa9;
554 
555         pool[poolAddress][0].contributionInWei = 0;
556         pool[poolAddress][1].contributionInWei = 0;
557         pool[poolAddress][2].contributionInWei = 0;
558         pool[poolAddress][3].contributionInWei = 0;
559 
560         tokensSent[0] = 0;
561         tokensSent[1] = 0;
562         tokensSent[2] = 0;
563         tokensSent[3] = 0;
564 
565         stage = Stages.Pending;
566         contractAddressIsSet = true;
567     }
568 
569     /**
570      * Set when presale starts
571      *
572      * @param _startTimePresale Start time of presale in timestamp
573      */
574     function startPresale(uint256 _startTimePresale) external OnlyOwner AtStage(Stages.Pending) {
575         if(_startTimePresale == 0) {
576             startTimePresale = now;
577         }
578         else {
579             startTimePresale = _startTimePresale;
580         }
581 
582         setTierEndTime();
583 
584         stage = Stages.PreSale;
585     }
586 
587     /**
588      * Set when public sale starts
589      *
590      * @param _startTime Start time of public sale in timestamp
591      */
592     function startPublicSale(uint256 _startTime) external OnlyOwner AtStage(Stages.PreSale) {
593         if(_startTime == 0) {
594             startTime = now;
595         }
596         else {
597             startTime = _startTime;
598         }
599 
600         endTime = startTime + 15 days;
601         publicSaleDiscountEndTime = startTime + 3 days;
602 
603         stage = Stages.PublicSale;
604     }
605 
606     // Fallback function can be used to buy CHR tokens
607     function () public payable {
608         buy();
609     }
610 
611     function buy() public payable IsNotPaused CheckIfICOIsLive returns(bool _success) {
612         uint8 currentTier = getCurrentTier();
613 
614         if(currentTier > 3) {
615             revert();
616         }
617 
618         if(!buyTokens(currentTier)) {
619             revert();
620         }
621 
622         return true;
623     }
624 
625     /**
626      * @param _tier Current Token Sale tier
627      */
628     function buyTokens(uint8 _tier) internal ValidDestination(msg.sender) CheckPurchase returns(bool _success) {
629         if(weiRaised.add(msg.value) > FUNDING_ETH_HARD_CAP) {
630             revert();
631         }
632 
633         uint256 contributionInWei = msg.value;
634 
635         if(!checkTierCap(_tier, contributionInWei)) {
636             revert();
637         }
638 
639         uint256 rate = getTierTokens(_tier);
640         uint256 tokens = contributionInWei.mul(rate);
641 
642         if(msg.sender != poolAddress) {
643             if(stage == Stages.PreSale) {
644                 if(!checkAllowedTier(msg.sender, _tier)) {
645                     revert();
646                 }
647             }
648 
649             if(!checkAllowedContribution(msg.sender, contributionInWei, _tier)) {
650                 revert();
651             }
652 
653             if(!this.transferFrom(owner, msg.sender, tokens)) {
654                 revert();
655             }
656 
657             if(stage == Stages.PreSale) {
658                 if(_tier == 0) {
659                     contributors[msg.sender].contributionInWeiTier1 = contributors[msg.sender].contributionInWeiTier1.add(contributionInWei);
660                 }
661                 else if(_tier == 1) {
662                     contributors[msg.sender].contributionInWeiTier2 = contributors[msg.sender].contributionInWeiTier2.add(contributionInWei);
663                 }
664                 else if(_tier == 2) {
665                     contributors[msg.sender].contributionInWeiTier3 = contributors[msg.sender].contributionInWeiTier3.add(contributionInWei);
666                 }
667             }
668             else {
669                 contributors[msg.sender].contributionInWeiPublicSale = contributors[msg.sender].contributionInWeiPublicSale.add(contributionInWei);
670             }
671         }
672         else {
673             if(!checkPoolAddressTierCap(_tier, contributionInWei)) {
674                 revert();
675             }
676 
677             if(!this.transferFrom(owner, msg.sender, tokens)) {
678                 revert();
679             }
680 
681             pool[poolAddress][_tier].contributionInWei = pool[poolAddress][_tier].contributionInWei.add(contributionInWei);
682         }
683 
684         weiRaised = weiRaised.add(contributionInWei);
685         tokensSent[_tier] = tokensSent[_tier].add(tokens);
686 
687         if(weiRaised >= FUNDING_ETH_HARD_CAP) {
688             offeringEnded();
689         }
690 
691         beneficiaryAddress.transfer(address(this).balance);
692         emit TokenPurchase(msg.sender, contributionInWei, tokens);
693 
694         return true;
695     }
696 
697     /**
698      * Manually withdraw tokens to private investors
699      *
700      * @param _to    Address of private investor
701      * @param _value The number of tokens to send to private investor
702      */
703     function withdrawCrowdsaleTokens(address _to, uint256 _value) external OnlyOwner ValidDestination(_to) returns (bool _success) {
704         if(!this.transferFrom(owner, _to, _value)) {
705             revert();
706         }
707 
708         return true;
709     }
710 
711     /**
712      * Transfer from sender to another account
713      *
714      * @param _to    Destination address
715      * @param _value Amount of CHR tokens to send
716      */
717     function transfer(address _to, uint256 _value) public ValidDestination(_to) TransferIsEnabled IsNotPaused returns(bool _success){
718          return super.transfer(_to, _value);
719     }
720 
721     /**
722      * Transfer from `from` account to `to` account using allowance in `from` account to the sender
723      *
724      * @param _from  Origin address
725      * @param _to    Destination address
726      * @param _value Amount of CHR tokens to send
727      */
728     function transferFrom(address _from, address _to, uint256 _value) public ValidDestination(_to) TransferIsEnabled IsNotPaused returns(bool _success){
729         return super.transferFrom(_from, _to, _value);
730     }
731 
732     /**
733      * Check if participant is allowed to contribute in current tier
734      *
735      * @param _address Participant address
736      * @param _tier    Current tier
737      */
738     function checkAllowedTier(address _address, uint8 _tier) internal view returns (bool _allowed) {
739         if(contributors[_address].tier <= _tier) {
740             return true;
741         }
742         else{
743           return false;
744         }
745     }
746 
747     /**
748      * Check contribution cap for only tier 1 and 2
749      *
750      * @param _tier  Current tier
751      * @param _value Participant contribution
752      */
753     function checkTierCap(uint8 _tier, uint256 _value) internal view returns (bool _success) {
754         uint256 currentlyTokensSent = tokensSent[_tier];
755         bool status = true;
756 
757         if(_tier == 0) {
758             if(TIER1_CAP < currentlyTokensSent.add(_value)) {
759                 status = false;
760             }
761         }
762         else if(_tier == 1) {
763             if(TIER2_CAP < currentlyTokensSent.add(_value)) {
764                 status = false;
765             }
766         }
767 
768         return status;
769     }
770     
771     /**
772      * Check cap for pool address in tier 1 and 2
773      *
774      * @param _tier  Current tier
775      * @param _value Pool contribution
776      */
777     function checkPoolAddressTierCap(uint8 _tier, uint256 _value) internal view returns (bool _success) {
778         uint256 currentContribution = pool[poolAddress][_tier].contributionInWei;
779 
780         if((_tier == 0 && (poolAddressCapTier1 < currentContribution.add(_value))) || (_tier == 1 && (poolAddressCapTier2 < currentContribution.add(_value)))) {
781             return false;
782         }
783 
784         return true;
785     }
786 
787     /**
788      * Check cap for pool address in tier 1 and 2
789      *
790      * @param _address  Participant address
791      * @param _value    Participant contribution
792      * @param _tier     Current tier
793      */
794     function checkAllowedContribution(address _address, uint256 _value, uint8 _tier) internal view returns (bool _success) {
795         bool status = false;
796 
797         if(contributors[_address].canContribute) {
798             if(_tier == 0) {
799                 if(participantCapTier1 >= contributors[_address].contributionInWeiTier1.add(_value)) {
800                     status = true;
801                 }
802             }
803             else if(_tier == 1) {
804                 if(participantCapTier2 >= contributors[_address].contributionInWeiTier2.add(_value)) {
805                     status = true;
806                 }
807             }
808             else if(_tier == 2) {
809                 status = true;
810             }
811             else {
812                 status = true;
813             }
814         }
815 
816         return status;
817     }
818     
819     /**
820      * Get current tier tokens rate
821      *
822      * @param _tier     Current tier
823      */
824     function getTierTokens(uint8 _tier) internal view returns(uint256 _tokens) {
825         uint256 tokens = RATE_TIER1;
826 
827         if(_tier == 1) {
828             tokens = RATE_TIER2;
829         }
830         else if(_tier == 2) {
831             tokens = RATE_TIER3;
832         }
833         else if(_tier == 3) {
834             if(now <= publicSaleDiscountEndTime) {
835                 tokens = RATE_PUBLIC_SALE;
836             }
837             else {
838                 tokens = RATE;
839             }
840         }
841 
842         return tokens;
843     }
844 
845     // Get current tier
846     function getCurrentTier() public view returns(uint8 _tier) {
847         uint8 currentTier = 3; // 3 is public sale
848 
849         if(stage == Stages.PreSale) {
850             if(now <= tierEndTime[0]) {
851                 currentTier = 0;
852             }
853             else if(now <= tierEndTime[1]) {
854                 currentTier = 1;
855             }
856             else if(now <= tierEndTime[2]) {
857                 currentTier = 2;
858             }
859         }
860         else {
861             if(now > endTime) {
862                 currentTier = 4; // Token offering ended
863             }
864         }
865 
866         return currentTier;
867     }
868 
869     // Set end time for each tier
870     function setTierEndTime() internal AtStage(Stages.Pending) {
871         tierEndTime[0] = startTimePresale + 1 days; 
872         tierEndTime[1] = tierEndTime[0] + 2 days;   
873         tierEndTime[2] = tierEndTime[1] + 6 days;   
874     }
875 
876     // End the token offering
877     function endOffering() public OnlyOwner {
878         offeringEnded();
879     }
880 
881     // Token offering is ended
882     function offeringEnded() internal {
883         endTime = now;
884         stage = Stages.Ended;
885 
886         emit OfferingCloses(endTime, weiRaised);
887     }
888 
889     // Enable transfers, burn unsold tokens & set tokenOfferingAddress to 0
890     function enableTransfer() public OnlyOwner returns(bool _success){
891         transferIsEnabled = true;
892         uint256 tokensToBurn = allowed[msg.sender][contractAddress];
893 
894         if(tokensToBurn != 0){
895             burn(tokensToBurn);
896             approve(contractAddress, 0);
897         }
898 
899         return true;
900     }
901     
902     /**
903      * Extend end time
904      *
905      * @param _addedTime Addtional time in secods
906      */
907     function extendEndTime(uint256 _addedTime) external OnlyOwner {
908         endTime = endTime + _addedTime;
909     }
910     
911     /**
912      * Extend public sale discount time
913      *
914      * @param _addedPublicSaleDiscountEndTime Addtional time in secods
915      */
916     function extendPublicSaleDiscountEndTime(uint256 _addedPublicSaleDiscountEndTime) external OnlyOwner {
917         publicSaleDiscountEndTime = publicSaleDiscountEndTime + _addedPublicSaleDiscountEndTime;
918     }
919     
920     /**
921      * Update pool cap for tier 1
922      *
923      * @param _poolAddressCapTier1 Tier cap
924      */
925     function updatePoolAddressCapTier1(uint256 _poolAddressCapTier1) external OnlyOwner {
926         poolAddressCapTier1 = _poolAddressCapTier1;
927     }
928     
929     /**
930      * Update pool cap for tier 2
931      *
932      * @param _poolAddressCapTier2 Tier cap
933      */
934     function updatePoolAddressCapTier2(uint256 _poolAddressCapTier2) external OnlyOwner {
935         poolAddressCapTier2 = _poolAddressCapTier2;
936     }
937 
938     //
939     
940     /**
941      * Update participant cap for tier 1
942      *
943      * @param _participantCapTier1 Tier cap
944      */
945     function updateParticipantCapTier1(uint256 _participantCapTier1) external OnlyOwner {
946         participantCapTier1 = _participantCapTier1;
947     }
948     
949     /**
950      * Update participant cap for tier 2
951      *
952      * @param _participantCapTier2 Tier cap
953      */
954     function updateParticipantCapTier2(uint256 _participantCapTier2) external OnlyOwner {
955         participantCapTier2 = _participantCapTier2;
956     }
957 }