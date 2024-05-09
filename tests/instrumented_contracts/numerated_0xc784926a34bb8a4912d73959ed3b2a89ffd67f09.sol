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
323 contract AMOCoin is StandardToken, BurnableToken, Ownable {
324     using SafeMath for uint256;
325 
326     string public constant symbol = "AMO";
327     string public constant name = "AMO Coin";
328     uint8 public constant decimals = 18;
329     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
330     uint256 public constant TOKEN_SALE_ALLOWANCE = 10000000000 * (10 ** uint256(decimals));
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
395      * The constructor of AMOCoin contract
396      *
397      * @param _adminAddr: Address of token administrator
398      */
399     function AMOCoin(address _adminAddr) public {
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
465      * @param value: Amount of AMO Coin to transfer
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
480      * @param value: Amount of AMO Coin to burn
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
517 
518 contract AMOCoinSale is Pausable {
519     using SafeMath for uint256;
520 
521     // Start time of sale
522     uint256 public startTime;
523     // End time of sale
524     uint256 public endTime;
525     // Address to collect fund
526     address private fundAddr;
527     // Token contract instance
528     AMOCoin public token;
529     // Amount of raised in Wei (1 ether)
530     uint256 public totalWeiRaised;
531     // Base hard cap for each round in ether
532     uint256 public constant BASE_HARD_CAP_PER_ROUND = 12000 * 1 ether;
533 
534     uint256 public constant UINT256_MAX = ~uint256(0);
535     // Base AMO to Ether rate
536     uint256 public constant BASE_AMO_TO_ETH_RATE = 200000;
537     // Base minimum contribution
538     uint256 public constant BASE_MIN_CONTRIBUTION = 0.1 * 1 ether;
539     // Whitelisted addresses
540     mapping(address => bool) public whitelist;
541     // Whitelisted users' contributions per round
542     mapping(address => mapping(uint8 => uint256)) public contPerRound;
543 
544     // For each round, there are three stages.
545     enum Stages {
546         SetUp,
547         Started,
548         Ended
549     }
550     // The current stage of the sale
551     Stages public stage;
552 
553     // There are three rounds in sale
554     enum SaleRounds {
555         EarlyInvestment,
556         PreSale,
557         CrowdSale
558     }
559     // The current round of the sale
560     SaleRounds public round;
561 
562     // Each round has different information
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
663      * Constructor for AMOCoinSale contract
664      *
665      * @param AMOToEtherRate: Number of AMO tokens per Ether
666      * @param fundAddress: Address where funds are collected
667      * @param tokenAddress: Address of AMO Token Contract
668      */
669     function AMOCoinSale(
670         address fundAddress,
671         address tokenAddress
672     )
673         public
674     {
675         require(fundAddress != address(0));
676         require(tokenAddress != address(0));
677 
678         token = AMOCoin(tokenAddress);
679         fundAddr = fundAddress;
680         stage = Stages.Ended;
681         round = SaleRounds.EarlyInvestment;
682         uint8 roundIndex = uint8(round);
683 
684         roundInfos[roundIndex].minContribution = BASE_MIN_CONTRIBUTION;
685         roundInfos[roundIndex].maxContribution = UINT256_MAX;
686         roundInfos[roundIndex].hardCap = BASE_HARD_CAP_PER_ROUND;
687         roundInfos[roundIndex].weiRaised = 0;
688         roundInfos[roundIndex].rate = BASE_AMO_TO_ETH_RATE;
689     }
690 
691     /*
692      * Fallback function to buy AMO tokens
693      */
694     function () public payable {
695         buy();
696     }
697 
698     /*
699      * Withdraw ethers to fund address
700      */
701     function withdraw() external onlyOwner {
702         fundAddr.transfer(this.balance);
703     }
704 
705     /*
706      * Add users to whitelist
707      * Whitelisted users are accumulated on each round
708      *
709      * @param users: Addresses of users who passed KYC
710      */
711     function addManyToWhitelist(address[] users) external onlyOwner {
712         for (uint32 i = 0; i < users.length; i++) {
713             addToWhitelist(users[i]);
714         }
715     }
716 
717     /*
718      * Add one user to whitelist
719      *
720      * @param user: Address of user who passed KYC
721      */
722     function addToWhitelist(address user) public onlyOwner {
723         whitelist[user] = true;
724     }
725 
726     /*
727      * Remove users from whitelist
728      *
729      * @param users: Addresses of users who should not belong to whitelist
730      */
731     function removeManyFromWhitelist(address[] users) external onlyOwner {
732         for (uint32 i = 0; i < users.length; i++) {
733             removeFromWhitelist(users[i]);
734         }
735     }
736 
737     /*
738      * Remove users from whitelist
739      *
740      * @param users: Addresses of users who should not belong to whitelist
741      */
742     function removeFromWhitelist(address user) public onlyOwner {
743         whitelist[user] = false;
744     }
745 
746     /*
747      * Set minimum contribution for round
748      * User have to send more ether than minimum contribution
749      *
750      * @param _round: Round to set
751      * @param _minContribution: Minimum contribution in wei
752      */
753     function setMinContributionForRound(
754         SaleRounds _round,
755         uint256 _minContribution
756     )
757         public
758         onlyOwner
759         atStage(Stages.SetUp)
760     {
761         require(round <= _round);
762         roundInfos[uint8(_round)].minContribution =
763             (_minContribution == 0) ? BASE_MIN_CONTRIBUTION : _minContribution;
764     }
765 
766     /*
767      * Set max contribution for round
768      * User can't send more ether than the max contributions in round
769      *
770      * @param _round: Round to set
771      * @param _maxContribution: Max contribution in wei
772      */
773     function setMaxContributionForRound(
774         SaleRounds _round,
775         uint256 _maxContribution
776     )
777         public
778         onlyOwner
779         atStage(Stages.SetUp)
780     {
781         require(round <= _round);
782         roundInfos[uint8(_round)].maxContribution =
783             (_maxContribution == 0) ? UINT256_MAX : _maxContribution;
784     }
785 
786     /*
787      * Set hard cap for round
788      * Total wei raised in round should be smaller than hard cap
789      *
790      * @param _round: Round to set
791      * @param _hardCap: Hard cap in wei
792      */
793     function setHardCapForRound(
794         SaleRounds _round,
795         uint256 _hardCap
796     )
797         public
798         onlyOwner
799         atStage(Stages.SetUp)
800     {
801         require(round <= _round);
802         roundInfos[uint8(_round)].hardCap =
803             (_hardCap == 0) ? BASE_HARD_CAP_PER_ROUND : _hardCap;
804     }
805 
806     /*
807      * Set AMO to Ether rate for round
808      *
809      * @param _round: Round to set
810      * @param _rate: AMO to Ether _rate
811      */
812     function setRateForRound(
813         SaleRounds _round,
814         uint256 _rate
815     )
816         public
817         onlyOwner
818         atStage(Stages.SetUp)
819     {
820         require(round <= _round);
821         roundInfos[uint8(_round)].rate =
822             (_rate == 0) ? BASE_AMO_TO_ETH_RATE : _rate;
823     }
824 
825     /*
826      * Set up several information for next round
827      * Only owner can call this method
828      */
829     function setUpSale(
830         SaleRounds _round,
831         uint256 _minContribution,
832         uint256 _maxContribution,
833         uint256 _hardCap,
834         uint256 _rate
835     )
836         external
837         onlyOwner
838         atStage(Stages.Ended)
839     {
840         require(round <= _round);
841         stage = Stages.SetUp;
842         round = _round;
843         setMinContributionForRound(_round, _minContribution);
844         setMaxContributionForRound(_round, _maxContribution);
845         setHardCapForRound(_round, _hardCap);
846         setRateForRound(_round, _rate);
847     }
848 
849     /*
850      * Start sale in current round
851      */
852     function startSale(uint256 durationInSeconds)
853         external
854         onlyOwner
855         atStage(Stages.SetUp)
856     {
857         require(roundInfos[uint8(round)].minContribution > 0
858             && roundInfos[uint8(round)].hardCap > 0);
859         stage = Stages.Started;
860         startTime = now;
861         endTime = startTime.add(durationInSeconds);
862         SaleStarted(startTime, endTime, round);
863     }
864 
865     /*
866      * End sale in crrent round
867      */
868     function endSale() external onlyOwner atStage(Stages.Started) {
869         endTime = now;
870         stage = Stages.Ended;
871 
872         SaleEnded(endTime, totalWeiRaised, round);
873     }
874 
875     function buy()
876         public
877         payable
878         whenNotPaused
879         atStage(Stages.Started)
880         onlyValidPurchase()
881         returns (bool)
882     {
883         address purchaser = msg.sender;
884         uint256 contributionInWei = msg.value;
885         uint256 tokenAmount = contributionInWei.mul(roundInfos[uint8(round)].rate);
886 
887         if (!token.transferFrom(token.owner(), purchaser, tokenAmount)) {
888             revert();
889         }
890 
891         totalWeiRaised = totalWeiRaised.add(contributionInWei);
892         roundInfos[uint8(round)].weiRaised =
893             roundInfos[uint8(round)].weiRaised.add(contributionInWei);
894 
895         contPerRound[purchaser][uint8(round)] =
896             contPerRound[purchaser][uint8(round)].add(contributionInWei);
897 
898         // Transfer contributions to fund address
899         fundAddr.transfer(contributionInWei);
900         TokenPurchase(msg.sender, contributionInWei, tokenAmount);
901 
902         return true;
903     }
904 
905     /*
906      * Add user and his allowed amount to allocation list
907      *
908      * @param user: Address of user to be allocated tokens
909      * @param amount: Allowed allocation amount of user
910      */
911     function addToAllocationList(address user, uint256 amount)
912         public
913         onlyOwner
914         atRound(SaleRounds.EarlyInvestment)
915     {
916         allocationList[user].isAllowed = true;
917         allocationList[user].allowedAmount = amount;
918     }
919 
920     /*
921      * Add users and their allowed amount to allocation list
922      *
923      * @param users: List of Address to be allocated tokens
924      * @param amount: List of allowed allocation amount of each user
925      */
926     function addManyToAllocationList(address[] users, uint256[] amounts)
927         external
928         onlyOwner
929         atRound(SaleRounds.EarlyInvestment)
930     {
931         require(users.length == amounts.length);
932 
933         for (uint32 i = 0; i < users.length; i++) {
934             addToAllocationList(users[i], amounts[i]);
935         }
936     }
937 
938     /*
939      * Remove user from allocation list
940      *
941      * @param user: Address of user to be removed
942      */
943     function removeFromAllocationList(address user)
944         public
945         onlyOwner
946         atRound(SaleRounds.EarlyInvestment)
947     {
948         allocationList[user].isAllowed = false;
949     }
950 
951     /*
952      * Remove users from allocation list
953      *
954      * @param user: Address list of users to be removed
955      */
956     function removeManyFromAllocationList(address[] users)
957         external
958         onlyOwner
959         atRound(SaleRounds.EarlyInvestment)
960     {
961         for (uint32 i = 0; i < users.length; i++) {
962             removeFromAllocationList(users[i]);
963         }
964     }
965 
966 
967     /*
968      * Allocate  tokens to user
969      * Only avaliable on early investment
970      *
971      * @param to: Address of user to be allocated tokens
972      * @param tokenAmount: Amount of tokens to be allocated
973      */
974     function allocateTokens(address to, uint256 tokenAmount)
975         public
976         onlyOwner
977         atRound(SaleRounds.EarlyInvestment)
978         returns (bool)
979     {
980         require(allocationList[to].isAllowed
981             && tokenAmount <= allocationList[to].allowedAmount);
982 
983         if (!token.transferFrom(token.owner(), to, tokenAmount)) {
984             revert();
985         }
986         return true;
987     }
988 
989     /*
990      * Allocate  tokens to user
991      * Only avaliable on early investment
992      *
993      * @param toList: List of addresses to be allocated tokens
994      * @param tokenAmountList: List of token amount to be allocated to each address
995      */
996     function allocateTokensToMany(address[] toList, uint256[] tokenAmountList)
997         external
998         onlyOwner
999         atRound(SaleRounds.EarlyInvestment)
1000         returns (bool)
1001     {
1002         require(toList.length == tokenAmountList.length);
1003 
1004         for (uint32 i = 0; i < toList.length; i++) {
1005             allocateTokens(toList[i], tokenAmountList[i]);
1006         }
1007         return true;
1008     }
1009 }