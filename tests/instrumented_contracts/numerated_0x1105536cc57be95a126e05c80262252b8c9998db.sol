1 pragma solidity 0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66    require(newOwner != address(0));
67    owner = newOwner;
68   }
69 
70 }
71 
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev modifier to allow actions only when the contract IS paused
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev modifier to allow actions only when the contract IS NOT paused
94    */
95   modifier whenPaused {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused returns (bool) {
104     paused = true;
105     Pause();
106     return true;
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused returns (bool) {
113     paused = false;
114     Unpause();
115     return true;
116   }
117 }
118 
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) constant returns (uint256);
128   function transfer(address to, uint256 value) returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) returns (bool) {
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) constant returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) returns (bool);
173   function approve(address spender, uint256 value) returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amout of tokens to be transfered
195    */
196   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
197     uint256 _allowance = allowed[_from][msg.sender];
198 
199     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
200     // require (_value <= _allowance);
201 
202     balances[_from] = balances[_from].sub(_value);
203     allowed[_from][msg.sender] = _allowance.sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) returns (bool) {
215 
216     // To change the approve amount you first have to reduce the addresses`
217     //  allowance to zero by calling `approve(_spender, 0)` if it is not
218     //  already 0 to mitigate the race condition described here:
219     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
221 
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifing the amount of tokens still avaible for the spender.
232    */
233   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
234     return allowed[_owner][_spender];
235   }
236 
237 }
238 
239 
240 /**
241  * Pausable token
242  *
243  * Simple ERC20 Token example, with pausable token creation
244  **/
245 contract PausableToken is StandardToken, Pausable {
246 
247   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
248     return super.transfer(_to, _value);
249   }
250 
251   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
252     return super.transferFrom(_from, _to, _value);
253   }
254 }
255 
256 
257 /**
258  * @title RefundVault
259  * @dev This contract is used for storing funds while a crowdsale
260  * is in progress. Supports refunding the money if crowdsale fails,
261  * and forwarding it if crowdsale is successful.
262  */
263 contract RefundVault is Ownable {
264   using SafeMath for uint256;
265 
266   enum State { Active, Refunding, Closed }
267 
268   mapping (address => uint256) public deposited;
269   address public wallet;
270   State public state;
271 
272   event Closed();
273   event RefundsEnabled();
274   event Refunded(address indexed beneficiary, uint256 weiAmount);
275 
276   function RefundVault(address _wallet) {
277     require(_wallet != 0x0);
278     wallet = _wallet;
279     state = State.Active;
280   }
281 
282   function deposit(address investor) onlyOwner payable {
283     require(state == State.Active);
284     deposited[investor] = deposited[investor].add(msg.value);
285   }
286 
287   function close() onlyOwner {
288     require(state == State.Active);
289     state = State.Closed;
290     Closed();
291     wallet.transfer(this.balance);
292   }
293 
294   function enableRefunds() onlyOwner {
295     require(state == State.Active);
296     state = State.Refunding;
297     RefundsEnabled();
298   }
299 
300   function refund(address investor) {
301     require(state == State.Refunding);
302     uint256 depositedValue = deposited[investor];
303     deposited[investor] = 0;
304     investor.transfer(depositedValue);
305     Refunded(investor, depositedValue);
306   }
307 }
308 
309 // @title The PallyCoin
310 /// @author Manoj Patidar
311 contract PallyCoin is PausableToken {
312    using SafeMath for uint256;
313 
314    string public constant name = 'PallyCoin';
315 
316    string public constant symbol = 'PLL';
317 
318    uint8 public constant decimals = 18;
319 
320    uint256 public  totalSupply = 100e24; // 100M tokens with 18 decimals
321 
322    bool public remainingTokenBurnt = false;
323 
324    // The tokens already used for the presale buyers
325    uint256 public tokensDistributedPresale = 0;
326 
327    // The tokens already used for the ICO buyers
328    uint256 public tokensDistributedCrowdsale = 0;
329 
330    // The address of the crowdsale
331    address public crowdsale;
332 
333    // The initial supply used for platform and development as specified in the whitepaper
334    uint256 public initialSupply = 40e24;
335 
336    // The maximum amount of tokens for the presale investors
337    uint256 public limitPresale = 10e24;
338 
339    // The maximum amount of tokens sold in the crowdsale
340    uint256 public limitCrowdsale = 50e24;
341 
342    /// @notice Only allows the execution of the function if it's comming from crowdsale
343    modifier onlyCrowdsale() {
344       require(msg.sender == crowdsale);
345       _;
346    }
347 
348    // When someone refunds tokens
349    event RefundedTokens(address indexed user, uint256 tokens);
350 
351    /// @notice Constructor used to set the platform & development tokens. This is
352    /// The 20% + 20% of the 100 M tokens used for platform and development team.
353    /// The owner, msg.sender, is able to do allowance for other contracts. Remember
354    /// to use `transferFrom()` if you're allowed
355    function PallyCoin() {
356       balances[msg.sender] = initialSupply; // 40M tokens wei
357    }
358 
359    /// @notice Function to set the crowdsale smart contract's address only by the owner of this token
360    /// @param _crowdsale The address that will be used
361    function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
362       require(_crowdsale != address(0));
363 
364       crowdsale = _crowdsale;
365    }
366 
367    /// @notice Distributes the presale tokens. Only the owner can do this
368    /// @param _buyer The address of the buyer
369    /// @param tokens The amount of tokens corresponding to that buyer
370    function distributePresaleTokens(address _buyer, uint tokens) external onlyOwner whenNotPaused {
371       require(_buyer != address(0));
372       require(tokens > 0 && tokens <= limitPresale);
373 
374       // Check that the limit of 10M presale tokens hasn't been met yet
375       require(tokensDistributedPresale < limitPresale);
376       require(tokensDistributedPresale.add(tokens) < limitPresale);
377 
378       tokensDistributedPresale = tokensDistributedPresale.add(tokens);
379       balances[_buyer] = balances[_buyer].add(tokens);
380    }
381 
382    /// @notice Distributes the ICO tokens. Only the crowdsale address can execute this
383    /// @param _buyer The buyer address
384    /// @param tokens The amount of tokens to send to that address
385    function distributeICOTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
386       require(_buyer != address(0));
387       require(tokens > 0);
388 
389       // Check that the limit of 50M ICO tokens hasn't been met yet
390       require(tokensDistributedCrowdsale < limitCrowdsale);
391       require(tokensDistributedCrowdsale.add(tokens) <= limitCrowdsale);
392 
393       tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
394       balances[_buyer] = balances[_buyer].add(tokens);
395    }
396 
397    /// @notice Deletes the amount of tokens refunded from that buyer balance
398    /// @param _buyer The buyer that wants the refund
399    /// @param tokens The tokens to return
400    function refundTokens(address _buyer, uint256 tokens) external onlyCrowdsale whenNotPaused {
401       require(_buyer != address(0));
402       require(tokens > 0);
403       require(balances[_buyer] >= tokens);
404 
405       balances[_buyer] = balances[_buyer].sub(tokens);
406       RefundedTokens(_buyer, tokens);
407    }
408 
409    /// @notice Burn the amount of tokens remaining after ICO ends
410    function burnTokens() external onlyCrowdsale whenNotPaused {
411       
412       uint256 remainingICOToken = limitCrowdsale.sub(tokensDistributedCrowdsale);
413       if(remainingICOToken > 0 && !remainingTokenBurnt) {
414       remainingTokenBurnt = true;    
415       limitCrowdsale = limitCrowdsale.sub(remainingICOToken);  
416       totalSupply = totalSupply.sub(remainingICOToken);
417       }
418    }
419 }
420 /// 1. First you set the address of the wallet in the RefundVault contract that will store the deposit of ether
421 // 2. If the goal is reached, the state of the vault will change and the ether will be sent to the address
422 // 3. If the goal is not reached , the state of the vault will change to refunding and the users will be able to call claimRefund() to get their ether
423 
424 /// @title Crowdsale contract to carry out an ICO with the PallyCoin
425 /// Crowdsales have a start and end timestamps, where investors can make
426 /// token purchases and the crowdsale will assign them tokens based
427 /// on a token per ETH rate. Funds collected are forwarded to a wallet
428 /// as they arrive.
429 /// @author Manoj Patidar <patidarmanoj@gmail.com>
430 contract Crowdsale is Pausable {
431    using SafeMath for uint256;
432 
433    // The token being sold
434    PallyCoin public token;
435 
436    // The vault that will store the ether until the goal is reached
437    RefundVault public vault;
438 
439    // The block number of when the crowdsale starts
440    // 10/15/2017 @ 11:00am (UTC)
441    // 10/15/2017 @ 12:00pm (GMT + 1)
442    uint256 public startTime = 1511068829;
443 
444    // The block number of when the crowdsale ends
445    // 11/13/2017 @ 11:00am (UTC)
446    // 11/13/2017 @ 12:00pm (GMT + 1)
447    uint256 public endTime = 1512021029;
448 
449    // The wallet that holds the Wei raised on the crowdsale
450    address public wallet;
451 
452    // The wallet that holds the Wei raised on the crowdsale after soft cap reached
453    address public walletB;
454 
455    // The rate of tokens per ether. Only applied for the first tier, the first
456    // 12.5 million tokens sold
457    uint256 public rate;
458 
459    // The rate of tokens per ether. Only applied for the second tier, at between
460    // 12.5 million tokens sold and 25 million tokens sold
461    uint256 public rateTier2;
462 
463    // The rate of tokens per ether. Only applied for the third tier, at between
464    // 25 million tokens sold and 37.5 million tokens sold
465    uint256 public rateTier3;
466 
467    // The rate of tokens per ether. Only applied for the fourth tier, at between
468    // 37.5 million tokens sold and 50 million tokens sold
469    uint256 public rateTier4;
470 
471    // The maximum amount of wei for each tier
472    uint256 public limitTier1 = 12.5e24;
473    uint256 public limitTier2 = 25e24;
474    uint256 public limitTier3 = 37.5e24;
475 
476    // The amount of wei raised
477    uint256 public weiRaised = 0;
478 
479    // The amount of tokens raised
480    uint256 public tokensRaised = 0;
481 
482    // You can only buy up to 50 M tokens during the ICO
483    uint256 public constant maxTokensRaised = 50e24;
484 
485    // The minimum amount of Wei you must pay to participate in the crowdsale
486    uint256 public constant minPurchase = 10 finney; // 0.01 ether
487 
488    // The max amount of Wei that you can pay to participate in the crowdsale
489    uint256 public constant maxPurchase = 2000 ether;
490 
491    // Minimum amount of tokens to be raised. 7.5 million tokens which is the 15%
492    // of the total of 50 million tokens sold in the crowdsale
493    // 7.5e6 + 1e18
494    uint256 public constant minimumGoal = 4266e18;//5.33e24;
495 
496    // If the crowdsale wasn't successful, this will be true and users will be able
497    // to claim the refund of their ether
498    bool public isRefunding = false;
499 
500    // If the crowdsale has ended or not
501    bool public isEnded = false;
502 
503    // The number of transactions
504    uint256 public numberOfTransactions;
505 
506    // The gas price to buy tokens must be 50 gwei or below
507    uint256 public limitGasPrice = 50000000000 wei;
508 
509    // How much each user paid for the crowdsale
510    mapping(address => uint256) public crowdsaleBalances;
511 
512    // How many tokens each user got for the crowdsale
513    mapping(address => uint256) public tokensBought;
514 
515    // To indicate who purchased what amount of tokens and who received what amount of wei
516    event TokenPurchase(address indexed buyer, uint256 value, uint256 amountOfTokens);
517 
518    // Indicates if the crowdsale has ended
519    event Finalized();
520 
521    // Only allow the execution of the function before the crowdsale starts
522    modifier beforeStarting() {
523       require(now < startTime);
524       _;
525    }
526 
527    /// @notice Constructor of the crowsale to set up the main variables and create a token
528    /// @param _wallet The wallet address that stores the Wei raised
529    /// @param _walletB The wallet address that stores the Wei raised after soft cap reached
530    /// @param _tokenAddress The token used for the ICO
531    function Crowdsale(
532       address _wallet,
533       address _walletB,
534       address _tokenAddress,
535       uint256 _startTime,
536       uint256 _endTime
537    ) public {
538       require(_wallet != address(0));
539       require(_tokenAddress != address(0));
540       require(_walletB != address(0));
541 
542       // If you send the start and end time on the constructor, the end must be larger
543       if(_startTime > 0 && _endTime > 0)
544          require(_startTime < _endTime);
545 
546       wallet = _wallet;
547       walletB = _walletB;
548       token = PallyCoin(_tokenAddress);
549       vault = new RefundVault(_wallet);
550 
551       if(_startTime > 0)
552          startTime = _startTime;
553 
554       if(_endTime > 0)
555          endTime = _endTime;
556    }
557 
558    /// @notice Fallback function to buy tokens
559    function () payable {
560       buyTokens();
561    }
562 
563    /// @notice To buy tokens given an address
564    function buyTokens() public payable whenNotPaused {
565       require(validPurchase());
566 
567       uint256 tokens = 0;
568       
569       uint256 amountPaid = calculateExcessBalance();
570 
571       if(tokensRaised < limitTier1) {
572 
573          // Tier 1
574          tokens = amountPaid.mul(rate);
575 
576          // If the amount of tokens that you want to buy gets out of this tier
577          if(tokensRaised.add(tokens) > limitTier1)
578             tokens = calculateExcessTokens(amountPaid, limitTier1, 1, rate);
579       } else if(tokensRaised >= limitTier1 && tokensRaised < limitTier2) {
580 
581          // Tier 2
582          tokens = amountPaid.mul(rateTier2);
583 
584          // If the amount of tokens that you want to buy gets out of this tier
585          if(tokensRaised.add(tokens) > limitTier2)
586             tokens = calculateExcessTokens(amountPaid, limitTier2, 2, rateTier2);
587       } else if(tokensRaised >= limitTier2 && tokensRaised < limitTier3) {
588 
589          // Tier 3
590          tokens = amountPaid.mul(rateTier3);
591 
592          // If the amount of tokens that you want to buy gets out of this tier
593          if(tokensRaised.add(tokens) > limitTier3)
594             tokens = calculateExcessTokens(amountPaid, limitTier3, 3, rateTier3);
595       } else if(tokensRaised >= limitTier3) {
596 
597          // Tier 4
598          tokens = amountPaid.mul(rateTier4);
599       }
600 
601       weiRaised = weiRaised.add(amountPaid);
602       uint256 tokensRaisedBeforeThisTransaction = tokensRaised;
603       tokensRaised = tokensRaised.add(tokens);
604       token.distributeICOTokens(msg.sender, tokens);
605 
606       // Keep a record of how many tokens everybody gets in case we need to do refunds
607       tokensBought[msg.sender] = tokensBought[msg.sender].add(tokens);
608       TokenPurchase(msg.sender, amountPaid, tokens);
609       numberOfTransactions = numberOfTransactions.add(1);
610 
611       if(tokensRaisedBeforeThisTransaction > minimumGoal) {
612 
613          walletB.transfer(amountPaid);
614 
615       } else {
616          vault.deposit.value(amountPaid)(msg.sender);
617          if(goalReached()) {
618           vault.close();
619          }
620          
621       }
622 
623       // If the minimum goal of the ICO has been reach, close the vault to send
624       // the ether to the wallet of the crowdsale
625       checkCompletedCrowdsale();
626    }
627 
628    /// @notice Calculates how many ether will be used to generate the tokens in
629    /// case the buyer sends more than the maximum balance but has some balance left
630    /// and updates the balance of that buyer.
631    /// For instance if he's 500 balance and he sends 1000, it will return 500
632    /// and refund the other 500 ether
633    function calculateExcessBalance() internal whenNotPaused returns(uint256) {
634       uint256 amountPaid = msg.value;
635       uint256 differenceWei = 0;
636       uint256 exceedingBalance = 0;
637 
638       // If we're in the last tier, check that the limit hasn't been reached
639       // and if so, refund the difference and return what will be used to
640       // buy the remaining tokens
641       if(tokensRaised >= limitTier3) {
642          uint256 addedTokens = tokensRaised.add(amountPaid.mul(rateTier4));
643 
644          // If tokensRaised + what you paid converted to tokens is bigger than the max
645          if(addedTokens > maxTokensRaised) {
646 
647             // Refund the difference
648             uint256 difference = addedTokens.sub(maxTokensRaised);
649             differenceWei = difference.div(rateTier4);
650             amountPaid = amountPaid.sub(differenceWei);
651          }
652       }
653 
654       uint256 addedBalance = crowdsaleBalances[msg.sender].add(amountPaid);
655 
656       // Checking that the individual limit of 1000 ETH per user is not reached
657       if(addedBalance <= maxPurchase) {
658          crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
659       } else {
660 
661          // Substracting 1000 ether in wei
662          exceedingBalance = addedBalance.sub(maxPurchase);
663          amountPaid = amountPaid.sub(exceedingBalance);
664 
665          // Add that balance to the balances
666          crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
667       }
668 
669       // Make the transfers at the end of the function for security purposes
670       if(differenceWei > 0)
671          msg.sender.transfer(differenceWei);
672 
673       if(exceedingBalance > 0) {
674 
675          // Return the exceeding balance to the buyer
676          msg.sender.transfer(exceedingBalance);
677       }
678 
679       return amountPaid;
680    }
681 
682    /// @notice Set's the rate of tokens per ether for each tier. Use it after the
683    /// smart contract is deployed to set the price according to the ether price
684    /// at the start of the ICO
685    /// @param tier1 The amount of tokens you get in the tier one
686    /// @param tier2 The amount of tokens you get in the tier two
687    /// @param tier3 The amount of tokens you get in the tier three
688    /// @param tier4 The amount of tokens you get in the tier four
689    function setTierRates(uint256 tier1, uint256 tier2, uint256 tier3, uint256 tier4)
690       external onlyOwner whenNotPaused
691    {
692       require(tier1 > 0 && tier2 > 0 && tier3 > 0 && tier4 > 0);
693       require(tier1 > tier2 && tier2 > tier3 && tier3 > tier4);
694 
695       rate = tier1;
696       rateTier2 = tier2;
697       rateTier3 = tier3;
698       rateTier4 = tier4;
699    }
700 
701    /// @notice Allow to extend ICO end date
702    /// @param _endTime Endtime of ICO
703    function setEndDate(uint256 _endTime)
704       external onlyOwner whenNotPaused
705    {
706       require(now <= _endTime);
707       require(startTime < _endTime);
708       
709       endTime = _endTime;
710    }
711 
712 
713    /// @notice Check if the crowdsale has ended and enables refunds only in case the
714    /// goal hasn't been reached
715    function checkCompletedCrowdsale() public whenNotPaused {
716       if(!isEnded) {
717          if(hasEnded() && !goalReached()){
718             vault.enableRefunds();
719 
720             isRefunding = true;
721             isEnded = true;
722             Finalized();
723          } else if(hasEnded()  && goalReached()) {
724             
725             
726             isEnded = true; 
727 
728 
729             // Burn token only when minimum goal reached and maxGoal not reached. 
730             if(tokensRaised < maxTokensRaised) {
731 
732                token.burnTokens();
733 
734             } 
735 
736             Finalized();
737          } 
738          
739          
740       }
741    }
742 
743    /// @notice If crowdsale is unsuccessful, investors can claim refunds here
744    function claimRefund() public whenNotPaused {
745      require(hasEnded() && !goalReached() && isRefunding);
746 
747      vault.refund(msg.sender);
748      token.refundTokens(msg.sender, tokensBought[msg.sender]);
749    }
750 
751    /// @notice Buys the tokens for the specified tier and for the next one
752    /// @param amount The amount of ether paid to buy the tokens
753    /// @param tokensThisTier The limit of tokens of that tier
754    /// @param tierSelected The tier selected
755    /// @param _rate The rate used for that `tierSelected`
756    /// @return uint The total amount of tokens bought combining the tier prices
757    function calculateExcessTokens(
758       uint256 amount,
759       uint256 tokensThisTier,
760       uint256 tierSelected,
761       uint256 _rate
762    ) public returns(uint256 totalTokens) {
763       require(amount > 0 && tokensThisTier > 0 && _rate > 0);
764       require(tierSelected >= 1 && tierSelected <= 4);
765 
766       uint weiThisTier = tokensThisTier.sub(tokensRaised).div(_rate);
767       uint weiNextTier = amount.sub(weiThisTier);
768       uint tokensNextTier = 0;
769       bool returnTokens = false;
770 
771       // If there's excessive wei for the last tier, refund those
772       if(tierSelected != 4)
773          tokensNextTier = calculateTokensTier(weiNextTier, tierSelected.add(1));
774       else
775          returnTokens = true;
776 
777       totalTokens = tokensThisTier.sub(tokensRaised).add(tokensNextTier);
778 
779       // Do the transfer at the end
780       if(returnTokens) msg.sender.transfer(weiNextTier);
781    }
782 
783    /// @notice Buys the tokens given the price of the tier one and the wei paid
784    /// @param weiPaid The amount of wei paid that will be used to buy tokens
785    /// @param tierSelected The tier that you'll use for thir purchase
786    /// @return calculatedTokens Returns how many tokens you've bought for that wei paid
787    function calculateTokensTier(uint256 weiPaid, uint256 tierSelected)
788         internal constant returns(uint256 calculatedTokens)
789    {
790       require(weiPaid > 0);
791       require(tierSelected >= 1 && tierSelected <= 4);
792 
793       if(tierSelected == 1)
794          calculatedTokens = weiPaid.mul(rate);
795       else if(tierSelected == 2)
796          calculatedTokens = weiPaid.mul(rateTier2);
797       else if(tierSelected == 3)
798          calculatedTokens = weiPaid.mul(rateTier3);
799       else
800          calculatedTokens = weiPaid.mul(rateTier4);
801    }
802 
803 
804    /// @notice Checks if a purchase is considered valid
805    /// @return bool If the purchase is valid or not
806    function validPurchase() internal constant returns(bool) {
807       bool withinPeriod = now >= startTime && now <= endTime;
808       bool nonZeroPurchase = msg.value > 0;
809       bool withinTokenLimit = tokensRaised < maxTokensRaised;
810       bool minimumPurchase = msg.value >= minPurchase;
811       bool hasBalanceAvailable = crowdsaleBalances[msg.sender] < maxPurchase;
812 
813       // We want to limit the gas to avoid giving priority to the biggest paying contributors
814       //bool limitGas = tx.gasprice <= limitGasPrice;
815 
816       return withinPeriod && nonZeroPurchase && withinTokenLimit && minimumPurchase && hasBalanceAvailable;
817    }
818 
819    /// @notice To see if the minimum goal of tokens of the ICO has been reached
820    /// @return bool True if the tokens raised are bigger than the goal or false otherwise
821    function goalReached() public constant returns(bool) {
822       return tokensRaised >= minimumGoal;
823    }
824 
825    /// @notice Public function to check if the crowdsale has ended or not
826    function hasEnded() public constant returns(bool) {
827       return now > endTime || tokensRaised >= maxTokensRaised;
828    }
829 }