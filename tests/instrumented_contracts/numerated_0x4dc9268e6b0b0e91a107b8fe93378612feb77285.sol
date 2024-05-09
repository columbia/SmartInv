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
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is Ownable {
48   event Pause();
49   event Unpause();
50 
51   bool public paused = false;
52 
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not paused.
56    */
57   modifier whenNotPaused() {
58     require(!paused);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is paused.
64    */
65   modifier whenPaused() {
66     require(paused);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     Pause();
76   }
77 
78   /**
79    * @dev called by the owner to unpause, returns to normal state
80    */
81   function unpause() onlyOwner whenPaused public {
82     paused = false;
83     Unpause();
84   }
85 }
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0;
99     }
100     uint256 c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     // assert(b > 0); // Solidity automatically throws when dividing by 0
110     uint256 c = a / b;
111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 }
132 
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   uint256 totalSupply_;
167 
168   /**
169   * @dev total number of tokens in existence
170   */
171   function totalSupply() public view returns (uint256) {
172     return totalSupply_;
173   }
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[msg.sender]);
183 
184     // SafeMath.sub will throw if there is not enough balance.
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256 balance) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is BasicToken {
207 
208   event Burn(address indexed burner, uint256 value);
209 
210   /**
211    * @dev Burns a specific amount of tokens.
212    * @param _value The amount of token to be burned.
213    */
214   function burn(uint256 _value) public {
215     require(_value <= balances[msg.sender]);
216     // no need to require value <= totalSupply, since that would imply the
217     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
218 
219     address burner = msg.sender;
220     balances[burner] = balances[burner].sub(_value);
221     totalSupply_ = totalSupply_.sub(_value);
222     Burn(burner, _value);
223     Transfer(burner, address(0), _value);
224   }
225 }
226 
227 
228 /**
229  * @title Standard ERC20 token
230  *
231  * @dev Implementation of the basic standard token.
232  * @dev https://github.com/ethereum/EIPs/issues/20
233  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
234  */
235 contract StandardToken is ERC20, BasicToken {
236 
237   mapping (address => mapping (address => uint256)) internal allowed;
238 
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
247     require(_to != address(0));
248     require(_value <= balances[_from]);
249     require(_value <= allowed[_from][msg.sender]);
250 
251     balances[_from] = balances[_from].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
254     Transfer(_from, _to, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
260    *
261    * Beware that changing an allowance with this method brings the risk that someone may use both the old
262    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265    * @param _spender The address which will spend the funds.
266    * @param _value The amount of tokens to be spent.
267    */
268   function approve(address _spender, uint256 _value) public returns (bool) {
269     allowed[msg.sender][_spender] = _value;
270     Approval(msg.sender, _spender, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Function to check the amount of tokens that an owner allowed to a spender.
276    * @param _owner address The address which owns the funds.
277    * @param _spender address The address which will spend the funds.
278    * @return A uint256 specifying the amount of tokens still available for the spender.
279    */
280   function allowance(address _owner, address _spender) public view returns (uint256) {
281     return allowed[_owner][_spender];
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To increment
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _addedValue The amount of tokens to increase the allowance by.
293    */
294   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
295     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   /**
301    * @dev Decrease the amount of tokens that an owner allowed to a spender.
302    *
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
311     uint oldValue = allowed[msg.sender][_spender];
312     if (_subtractedValue > oldValue) {
313       allowed[msg.sender][_spender] = 0;
314     } else {
315       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
316     }
317     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 
321 }
322 
323 contract Cloudbric is StandardToken, BurnableToken, Ownable {
324     using SafeMath for uint256;
325 
326     string public constant symbol = "CLB";
327     string public constant name = "Cloudbric";
328     uint8 public constant decimals = 18;
329     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
330     uint256 public constant TOKEN_SALE_ALLOWANCE = 540000000 * (10 ** uint256(decimals));
331     uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_SALE_ALLOWANCE;
332 
333     // Address of token administrator
334     address public adminAddr;
335 
336     // Address of token sale contract
337     address public tokenSaleAddr;
338 
339     // Enable transfer after token sale is completed
340     bool public transferEnabled = false;
341 
342     // Accounts to be locked for certain period
343     mapping(address => uint256) private lockedAccounts;
344 
345     /*
346      *
347      * Permissions when transferEnabled is false :
348      *              ContractOwner    Admin    SaleContract    Others
349      * transfer            x           v            v           x
350      * transferFrom        x           v            v           x
351      *
352      * Permissions when transferEnabled is true :
353      *              ContractOwner    Admin    SaleContract    Others
354      * transfer            v           v            v           v
355      * transferFrom        v           v            v           v
356      *
357      */
358 
359     /*
360      * Check if token transfer is allowed
361      * Permission table above is result of this modifier
362      */
363     modifier onlyWhenTransferAllowed() {
364         require(transferEnabled == true
365             || msg.sender == adminAddr
366             || msg.sender == tokenSaleAddr);
367         _;
368     }
369 
370     /*
371      * Check if token sale address is not set
372      */
373     modifier onlyWhenTokenSaleAddrNotSet() {
374         require(tokenSaleAddr == address(0x0));
375         _;
376     }
377 
378     /*
379      * Check if token transfer destination is valid
380      */
381     modifier onlyValidDestination(address to) {
382         require(to != address(0x0)
383             && to != address(this)
384             && to != owner
385             && to != adminAddr
386             && to != tokenSaleAddr);
387         _;
388     }
389 
390     modifier onlyAllowedAmount(address from, uint256 amount) {
391         require(balances[from].sub(amount) >= lockedAccounts[from]);
392         _;
393     }
394     /*
395      * The constructor of Cloudbric contract
396      *
397      * @param _adminAddr: Address of token administrator
398      */
399     function Cloudbric(address _adminAddr) public {
400         totalSupply_ = INITIAL_SUPPLY;
401 
402         balances[msg.sender] = totalSupply_;
403         Transfer(address(0x0), msg.sender, totalSupply_);
404 
405         adminAddr = _adminAddr;
406         approve(adminAddr, ADMIN_ALLOWANCE);
407     }
408 
409     /*
410      * Set amount of token sale to approve allowance for sale contract
411      *
412      * @param _tokenSaleAddr: Address of sale contract
413      * @param _amountForSale: Amount of token for sale
414      */
415     function setTokenSaleAmount(address _tokenSaleAddr, uint256 amountForSale)
416         external
417         onlyOwner
418         onlyWhenTokenSaleAddrNotSet
419     {
420         require(!transferEnabled);
421 
422         uint256 amount = (amountForSale == 0) ? TOKEN_SALE_ALLOWANCE : amountForSale;
423         require(amount <= TOKEN_SALE_ALLOWANCE);
424 
425         approve(_tokenSaleAddr, amount);
426         tokenSaleAddr = _tokenSaleAddr;
427     }
428 
429     /*
430      * Set transferEnabled variable to true
431      */
432     function enableTransfer() external onlyOwner {
433         transferEnabled = true;
434         approve(tokenSaleAddr, 0);
435     }
436 
437     /*
438      * Set transferEnabled variable to false
439      */
440     function disableTransfer() external onlyOwner {
441         transferEnabled = false;
442     }
443 
444     /*
445      * Transfer token from message sender to another
446      *
447      * @param to: Destination address
448      * @param value: Amount of AMO token to transfer
449      */
450     function transfer(address to, uint256 value)
451         public
452         onlyWhenTransferAllowed
453         onlyValidDestination(to)
454         onlyAllowedAmount(msg.sender, value)
455         returns (bool)
456     {
457         return super.transfer(to, value);
458     }
459 
460     /*
461      * Transfer token from 'from' address to 'to' addreess
462      *
463      * @param from: Origin address
464      * @param to: Destination address
465      * @param value: Amount of tokens to transfer
466      */
467     function transferFrom(address from, address to, uint256 value)
468         public
469         onlyWhenTransferAllowed
470         onlyValidDestination(to)
471         onlyAllowedAmount(from, value)
472         returns (bool)
473     {
474         return super.transferFrom(from, to, value);
475     }
476 
477     /*
478      * Burn token, only owner is allowed
479      *
480      * @param value: Amount of tokens to burn
481      */
482     function burn(uint256 value) public onlyOwner {
483         require(transferEnabled);
484         super.burn(value);
485     }
486 
487     /*
488      * Disable transfering tokens more than allowed amount from certain account
489      *
490      * @param addr: Account to set allowed amount
491      * @param amount: Amount of tokens to allow
492      */
493     function lockAccount(address addr, uint256 amount)
494         external
495         onlyOwner
496         onlyValidDestination(addr)
497     {
498         require(amount > 0);
499         lockedAccounts[addr] = amount;
500     }
501 
502     /*
503      * Enable transfering tokens of locked account
504      *
505      * @param addr: Account to unlock
506      */
507 
508     function unlockAccount(address addr)
509         external
510         onlyOwner
511         onlyValidDestination(addr)
512     {
513         lockedAccounts[addr] = 0;
514     }
515 }
516 
517 contract CloudbricSale is Pausable {
518     using SafeMath for uint256;
519 
520     // Start time of sale
521     uint256 public startTime;
522     // End time of sale
523     uint256 public endTime;
524     // Address to collect fund
525     address private fundAddr;
526     // Token contract instance
527     Cloudbric public token;
528     // Amount of raised in Wei (1 ether)
529     uint256 public totalWeiRaised;
530     // Base hard cap for each round in ether
531     uint256 public constant BASE_HARD_CAP_PER_ROUND = 20000 * 1 ether;
532 
533     uint256 public constant UINT256_MAX = ~uint256(0);
534     // Base CLB to Ether rate
535     uint256 public constant BASE_CLB_TO_ETH_RATE = 10000;
536     // Base minimum contribution
537     uint256 public constant BASE_MIN_CONTRIBUTION = 0.1 * 1 ether;
538     // Whitelisted addresses
539     mapping(address => bool) public whitelist;
540     // Whitelisted users' contributions per round
541     mapping(address => mapping(uint8 => uint256)) public contPerRound;
542 
543     // For each round, there are three stages.
544     enum Stages {
545         SetUp,
546         Started,
547         Ended
548     }
549     // The current stage of the sale
550     Stages public stage;
551 
552     // There are three rounds in sale
553     enum SaleRounds {
554         EarlyInvestment,
555         PreSale1,
556         PreSale2,
557         CrowdSale
558     }
559     // The current round of the sale
560     SaleRounds public round;
561 
562     // Each round has different inforamation
563     struct RoundInfo {
564         uint256 minContribution;
565         uint256 maxContribution;
566         uint256 hardCap;
567         uint256 rate;
568         uint256 weiRaised;
569     }
570 
571     // SaleRounds(key) : RoundInfo(value) map
572     // Since solidity does not support enum as key of map, converted enum to uint8
573     mapping(uint8 => RoundInfo) public roundInfos;
574 
575     struct AllocationInfo {
576         bool isAllowed;
577         uint256 allowedAmount;
578     }
579 
580     // List of users who will be allocated tokens and their allowed amount
581     mapping(address => AllocationInfo) private allocationList;
582 
583     /*
584      * Event for sale start logging
585      *
586      * @param startTime: Start date of sale
587      * @param endTime: End date of sale
588      * @param round: Round of sale started
589      */
590     event SaleStarted(uint256 startTime, uint256 endTime, SaleRounds round);
591 
592     /*
593      * Event for sale end logging
594      *
595      * @param endTime: End date of sale
596      * @param totalWeiRaised: Total amount of raised in Wei after sale ended
597      * @param round: Round of sale ended
598      */
599     event SaleEnded(uint256 endTime, uint256 totalWeiRaised, SaleRounds round);
600 
601     /*
602      * Event for token purchase
603      *
604      * @param purchaser: Who paid for the tokens
605      * @param value: Amount in Wei paid for purchase
606      * @param amount: Amount of tokens purchased
607      */
608     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
609 
610     /*
611      * Modifier to check current stage is same as expected stage
612      *
613      * @param expectedStage: Expected current stage
614      */
615     modifier atStage(Stages expectedStage) {
616         require(stage == expectedStage);
617         _;
618     }
619 
620     /*
621      * Modifier to check current round is sane as expected round
622      *
623      * @param expectedRound: Expected current round
624      */
625     modifier atRound(SaleRounds expectedRound) {
626         require(round == expectedRound);
627         _;
628     }
629 
630     /*
631      * Modifier to check purchase is valid
632      *
633      * 1. Current round must be smaller than CrowdSale
634      * 2. Current time must be within sale period
635      * 3. Purchaser must be enrolled to whitelist
636      * 4. Purchaser address must be correct
637      * 5. Contribution must be bigger than minimum contribution for current round
638      * 6. Sum of contributions must be smaller than max contribution for current round
639      * 7. Total funds raised in current round must be smaller than hard cap for current round
640      */
641     modifier onlyValidPurchase() {
642         require(round <= SaleRounds.CrowdSale);
643         require(now >= startTime && now <= endTime);
644 
645         uint256 contributionInWei = msg.value;
646         address purchaser = msg.sender;
647 
648         require(whitelist[purchaser]);
649         require(purchaser != address(0));
650         require(contributionInWei >= roundInfos[uint8(round)].minContribution);
651         require(
652             contPerRound[purchaser][uint8(round)].add(contributionInWei)
653             <= roundInfos[uint8(round)].maxContribution
654         );
655         require(
656             roundInfos[uint8(round)].weiRaised.add(contributionInWei)
657             <= roundInfos[uint8(round)].hardCap
658         );
659         _;
660     }
661 
662     /*
663      * Constructor for CloudbricSale contract
664      *
665      * @param fundAddress: Address where funds are collected
666      * @param tokenAddress: Address of Cloudbric Token Contract
667      */
668     function CloudbricSale(
669         address fundAddress,
670         address tokenAddress
671     )
672         public
673     {
674         require(fundAddress != address(0));
675         require(tokenAddress != address(0));
676 
677         token = Cloudbric(tokenAddress);
678         fundAddr = fundAddress;
679         stage = Stages.Ended;
680         round = SaleRounds.EarlyInvestment;
681         uint8 roundIndex = uint8(round);
682 
683         roundInfos[roundIndex].minContribution = BASE_MIN_CONTRIBUTION;
684         roundInfos[roundIndex].maxContribution = UINT256_MAX;
685         roundInfos[roundIndex].hardCap = BASE_HARD_CAP_PER_ROUND;
686         roundInfos[roundIndex].weiRaised = 0;
687         roundInfos[roundIndex].rate = BASE_CLB_TO_ETH_RATE;
688     }
689 
690     /*
691      * Fallback function to buy Cloudbric tokens
692      */
693     function () public payable {
694         buy();
695     }
696 
697     /*
698      * Withdraw ethers to fund address
699      */
700     function withdraw() external onlyOwner {
701         fundAddr.transfer(this.balance);
702     }
703 
704     /*
705      * Add users to whitelist
706      * Whitelisted users are accumulated on each round
707      *
708      * @param users: Addresses of users who passed KYC
709      */
710     function addManyToWhitelist(address[] users) external onlyOwner {
711         for (uint32 i = 0; i < users.length; i++) {
712             addToWhitelist(users[i]);
713         }
714     }
715 
716     /*
717      * Add one user to whitelist
718      *
719      * @param user: Address of user who passed KYC
720      */
721     function addToWhitelist(address user) public onlyOwner {
722         whitelist[user] = true;
723     }
724 
725     /*
726      * Remove users from whitelist
727      *
728      * @param users: Addresses of users who should not belong to whitelist
729      */
730     function removeManyFromWhitelist(address[] users) external onlyOwner {
731         for (uint32 i = 0; i < users.length; i++) {
732             removeFromWhitelist(users[i]);
733         }
734     }
735 
736     /*
737      * Remove users from whitelist
738      *
739      * @param users: Addresses of users who should not belong to whitelist
740      */
741     function removeFromWhitelist(address user) public onlyOwner {
742         whitelist[user] = false;
743     }
744 
745     /*
746      * Set minimum contribution for round
747      * User have to send more ether than minimum contribution
748      *
749      * @param _round: Round to set
750      * @param _minContribution: Minimum contribution in wei
751      */
752     function setMinContributionForRound(
753         SaleRounds _round,
754         uint256 _minContribution
755     )
756         public
757         onlyOwner
758         atStage(Stages.SetUp)
759     {
760         require(round <= _round);
761         roundInfos[uint8(_round)].minContribution =
762             (_minContribution == 0) ? BASE_MIN_CONTRIBUTION : _minContribution;
763     }
764 
765     /*
766      * Set max contribution for round
767      * User can't send more ether than the max contributions in round
768      *
769      * @param _round: Round to set
770      * @param _maxContribution: Max contribution in wei
771      */
772     function setMaxContributionForRound(
773         SaleRounds _round,
774         uint256 _maxContribution
775     )
776         public
777         onlyOwner
778         atStage(Stages.SetUp)
779     {
780         require(round <= _round);
781         roundInfos[uint8(_round)].maxContribution =
782             (_maxContribution == 0) ? UINT256_MAX : _maxContribution;
783     }
784 
785     /*
786      * Set hard cap for round
787      * Total wei raised in round should be smaller than hard cap
788      *
789      * @param _round: Round to set
790      * @param _hardCap: Hard cap in wei
791      */
792     function setHardCapForRound(
793         SaleRounds _round,
794         uint256 _hardCap
795     )
796         public
797         onlyOwner
798         atStage(Stages.SetUp)
799     {
800         require(round <= _round);
801         roundInfos[uint8(_round)].hardCap =
802             (_hardCap == 0) ? BASE_HARD_CAP_PER_ROUND : _hardCap;
803     }
804 
805     /*
806      * Set CLB to Ether rate for round
807      *
808      * @param _round: Round to set
809      * @param _rate: CLB to Ether rate
810      */
811     function setRateForRound(
812         SaleRounds _round,
813         uint256 _rate
814     )
815         public
816         onlyOwner
817         atStage(Stages.SetUp)
818     {
819         require(round <= _round);
820         roundInfos[uint8(_round)].rate =
821             (_rate == 0) ? BASE_CLB_TO_ETH_RATE : _rate;
822     }
823 
824     /*
825      * Set up several information for next round
826      * Only owner can call this method
827      */
828     function setUpSale(
829         SaleRounds _round,
830         uint256 _minContribution,
831         uint256 _maxContribution,
832         uint256 _hardCap,
833         uint256 _rate
834     )
835         external
836         onlyOwner
837         atStage(Stages.Ended)
838     {
839         require(round <= _round);
840         stage = Stages.SetUp;
841         round = _round;
842         setMinContributionForRound(_round, _minContribution);
843         setMaxContributionForRound(_round, _maxContribution);
844         setHardCapForRound(_round, _hardCap);
845         setRateForRound(_round, _rate);
846     }
847 
848     /*
849      * Start sale in current round
850      */
851     function startSale(uint256 durationInSeconds)
852         external
853         onlyOwner
854         atStage(Stages.SetUp)
855     {
856         require(roundInfos[uint8(round)].minContribution > 0
857             && roundInfos[uint8(round)].hardCap > 0);
858         stage = Stages.Started;
859         startTime = now;
860         endTime = startTime.add(durationInSeconds);
861         SaleStarted(startTime, endTime, round);
862     }
863 
864     /*
865      * End sale in crrent round
866      */
867     function endSale() external onlyOwner atStage(Stages.Started) {
868         endTime = now;
869         stage = Stages.Ended;
870 
871         SaleEnded(endTime, totalWeiRaised, round);
872     }
873 
874     function buy()
875         public
876         payable
877         whenNotPaused
878         atStage(Stages.Started)
879         onlyValidPurchase()
880         returns (bool)
881     {
882         address purchaser = msg.sender;
883         uint256 contributionInWei = msg.value;
884         uint256 tokenAmount = contributionInWei.mul(roundInfos[uint8(round)].rate);
885 
886         if (!token.transferFrom(token.owner(), purchaser, tokenAmount)) {
887             revert();
888         }
889 
890         totalWeiRaised = totalWeiRaised.add(contributionInWei);
891         roundInfos[uint8(round)].weiRaised =
892             roundInfos[uint8(round)].weiRaised.add(contributionInWei);
893 
894         contPerRound[purchaser][uint8(round)] =
895             contPerRound[purchaser][uint8(round)].add(contributionInWei);
896 
897         // Transfer contributions to fund address
898         fundAddr.transfer(contributionInWei);
899         TokenPurchase(msg.sender, contributionInWei, tokenAmount);
900 
901         return true;
902     }
903 
904     /*
905      * Add user and his allowed amount to allocation list
906      *
907      * @param user: Address of user to be allocated tokens
908      * @param amount: Allowed allocation amount of user
909      */
910     function addToAllocationList(address user, uint256 amount)
911         public
912         onlyOwner
913         atRound(SaleRounds.EarlyInvestment)
914     {
915         allocationList[user].isAllowed = true;
916         allocationList[user].allowedAmount = amount;
917     }
918 
919     /*
920      * Add users and their allowed amount to allocation list
921      *
922      * @param users: List of Address to be allocated tokens
923      * @param amount: List of allowed allocation amount of each user
924      */
925     function addManyToAllocationList(address[] users, uint256[] amounts)
926         external
927         onlyOwner
928         atRound(SaleRounds.EarlyInvestment)
929     {
930         require(users.length == amounts.length);
931 
932         for (uint32 i = 0; i < users.length; i++) {
933             addToAllocationList(users[i], amounts[i]);
934         }
935     }
936 
937     /*
938      * Remove user from allocation list
939      *
940      * @param user: Address of user to be removed
941      */
942     function removeFromAllocationList(address user)
943         public
944         onlyOwner
945         atRound(SaleRounds.EarlyInvestment)
946     {
947         allocationList[user].isAllowed = false;
948     }
949 
950     /*
951      * Remove users from allocation list
952      *
953      * @param user: Address list of users to be removed
954      */
955     function removeManyFromAllocationList(address[] users)
956         external
957         onlyOwner
958         atRound(SaleRounds.EarlyInvestment)
959     {
960         for (uint32 i = 0; i < users.length; i++) {
961             removeFromAllocationList(users[i]);
962         }
963     }
964 
965 
966     /*
967      * Allocate  tokens to user
968      * Only avaliable on early investment
969      *
970      * @param to: Address of user to be allocated tokens
971      * @param tokenAmount: Amount of tokens to be allocated
972      */
973     function allocateTokens(address to, uint256 tokenAmount)
974         public
975         onlyOwner
976         atRound(SaleRounds.EarlyInvestment)
977         returns (bool)
978     {
979         require(allocationList[to].isAllowed
980             && tokenAmount <= allocationList[to].allowedAmount);
981 
982         if (!token.transferFrom(token.owner(), to, tokenAmount)) {
983             revert();
984         }
985         return true;
986     }
987 
988     /*
989      * Allocate  tokens to user
990      * Only avaliable on early investment
991      *
992      * @param toList: List of addresses to be allocated tokens
993      * @param tokenAmountList: List of token amount to be allocated to each address
994      */
995     function allocateTokensToMany(address[] toList, uint256[] tokenAmountList)
996         external
997         onlyOwner
998         atRound(SaleRounds.EarlyInvestment)
999         returns (bool)
1000     {
1001         require(toList.length == tokenAmountList.length);
1002 
1003         for (uint32 i = 0; i < toList.length; i++) {
1004             allocateTokens(toList[i], tokenAmountList[i]);
1005         }
1006         return true;
1007     }
1008 }