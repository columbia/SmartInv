1 pragma solidity 0.4.15;
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
309 
310 /// @author Merunas Grincalaitis
311 contract PallyCoin is PausableToken {
312    using SafeMath for uint256;
313 
314    string public constant name = 'PallyCoin';
315 
316    string public constant symbol = 'PAL';
317 
318    uint8 public constant decimals = 18;
319 
320    uint256 public constant totalSupply = 100e24; // 100M tokens with 18 decimals
321 
322    // The tokens already used for the presale buyers
323    uint256 public tokensDistributedPresale = 0;
324 
325    // The tokens already used for the ICO buyers
326    uint256 public tokensDistributedCrowdsale = 0;
327 
328    address public crowdsale;
329 
330    /// @notice Only allows the execution of the function if it's comming from crowdsale
331    modifier onlyCrowdsale() {
332       require(msg.sender == crowdsale);
333       _;
334    }
335 
336    // When someone refunds tokens
337    event RefundedTokens(address indexed user, uint256 tokens);
338 
339    /// @notice Constructor used to set the platform & development tokens. This is
340    /// The 20% + 20% of the 100 M tokens used for platform and development team.
341    /// The owner, msg.sender, is able to do allowance for other contracts. Remember
342    /// to use `transferFrom()` if you're allowed
343    function PallyCoin() {
344       balances[msg.sender] = 40e24; // 40M tokens wei
345    }
346 
347    /// @notice Function to set the crowdsale smart contract's address only by the owner of this token
348    /// @param _crowdsale The address that will be used
349    function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
350       require(_crowdsale != address(0));
351 
352       crowdsale = _crowdsale;
353    }
354 
355    /// @notice Distributes the presale tokens. Only the owner can do this
356    /// @param _buyer The address of the buyer
357    /// @param tokens The amount of tokens corresponding to that buyer
358    function distributePresaleTokens(address _buyer, uint tokens) external onlyOwner whenNotPaused {
359       require(_buyer != address(0));
360       require(tokens > 0 && tokens <= 10e24);
361 
362       // Check that the limit of 10M presale tokens hasn't been met yet
363       require(tokensDistributedPresale < 10e24);
364 
365       tokensDistributedPresale = tokensDistributedPresale.add(tokens);
366       balances[_buyer] = balances[_buyer].add(tokens);
367    }
368 
369    /// @notice Distributes the ICO tokens. Only the crowdsale address can execute this
370    /// @param _buyer The buyer address
371    /// @param tokens The amount of tokens to send to that address
372    function distributeICOTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
373       require(_buyer != address(0));
374       require(tokens > 0);
375 
376       // Check that the limit of 50M ICO tokens hasn't been met yet
377       require(tokensDistributedCrowdsale < 50e24);
378 
379       tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
380       balances[_buyer] = balances[_buyer].add(tokens);
381    }
382 
383    /// @notice Deletes the amount of tokens refunded from that buyer balance
384    /// @param _buyer The buyer that wants the refund
385    /// @param tokens The tokens to return
386    function refundTokens(address _buyer, uint256 tokens) external onlyCrowdsale whenNotPaused {
387       require(_buyer != address(0));
388       require(tokens > 0);
389       require(balances[_buyer] >= tokens);
390 
391       balances[_buyer] = balances[_buyer].sub(tokens);
392       RefundedTokens(_buyer, tokens);
393    }
394 }
395 
396 /// @title Crowdsale contract to carry out an ICO with the PallyCoin
397 /// Crowdsales have a start and end timestamps, where investors can make
398 /// token purchases and the crowdsale will assign them tokens based
399 /// on a token per ETH rate. Funds collected are forwarded to a wallet
400 /// as they arrive.
401 /// @author Merunas Grincalaitis <merunasgrincalaitis@gmail.com>
402 contract Crowdsale is Pausable {
403    using SafeMath for uint256;
404 
405    // The token being sold
406    PallyCoin public token;
407 
408    // The vault that will store the ether until the goal is reached
409    RefundVault public vault;
410 
411    // The block number of when the crowdsale starts
412    // 10/15/2017 @ 11:00am (UTC)
413    // 10/15/2017 @ 12:00pm (GMT + 1)
414    uint256 public startTime = 1508065200;
415 
416    // The block number of when the crowdsale ends
417    // 11/13/2017 @ 11:00am (UTC)
418    // 11/13/2017 @ 12:00pm (GMT + 1)
419    uint256 public endTime = 1510570800;
420 
421    // The wallet that holds the Wei raised on the crowdsale
422    address public wallet;
423 
424    // The rate of tokens per ether. Only applied for the first tier, the first
425    // 12.5 million tokens sold
426    uint256 public rate;
427 
428    // The rate of tokens per ether. Only applied for the second tier, at between
429    // 12.5 million tokens sold and 25 million tokens sold
430    uint256 public rateTier2;
431 
432    // The rate of tokens per ether. Only applied for the third tier, at between
433    // 25 million tokens sold and 37.5 million tokens sold
434    uint256 public rateTier3;
435 
436    // The rate of tokens per ether. Only applied for the fourth tier, at between
437    // 37.5 million tokens sold and 50 million tokens sold
438    uint256 public rateTier4;
439 
440    // The maximum amount of wei for each tier
441    uint256 public limitTier1 = 12.5e24;
442    uint256 public limitTier2 = 25e24;
443    uint256 public limitTier3 = 37.5e24;
444 
445    // The amount of wei raised
446    uint256 public weiRaised = 0;
447 
448    // The amount of tokens raised
449    uint256 public tokensRaised = 0;
450 
451    // You can only buy up to 50 M tokens during the ICO
452    uint256 public constant maxTokensRaised = 50e24;
453 
454    // The minimum amount of Wei you must pay to participate in the crowdsale
455    uint256 public constant minPurchase = 100 finney; // 0.1 ether
456 
457    // The max amount of Wei that you can pay to participate in the crowdsale
458    uint256 public constant maxPurchase = 1000 ether;
459 
460    // Minimum amount of tokens to be raised. 7.5 million tokens which is the 15%
461    // of the total of 50 million tokens sold in the crowdsale
462    // 7.5e6 + 1e18
463    uint256 public constant minimumGoal = 7.5e24;
464 
465    // If the crowdsale wasn't successful, this will be true and users will be able
466    // to claim the refund of their ether
467    bool public isRefunding = false;
468 
469    // If the crowdsale has ended or not
470    bool public isEnded = false;
471 
472    // The number of transactions
473    uint256 public numberOfTransactions;
474 
475    // The gas price to buy tokens must be 50 gwei or below
476    uint256 public limitGasPrice = 50000000000 wei;
477 
478    // How much each user paid for the crowdsale
479    mapping(address => uint256) public crowdsaleBalances;
480 
481    // How many tokens each user got for the crowdsale
482    mapping(address => uint256) public tokensBought;
483 
484    // To indicate who purchased what amount of tokens and who received what amount of wei
485    event TokenPurchase(address indexed buyer, uint256 value, uint256 amountOfTokens);
486 
487    // Indicates if the crowdsale has ended
488    event Finalized();
489 
490    // Only allow the execution of the function before the crowdsale starts
491    modifier beforeStarting() {
492       require(now < startTime);
493       _;
494    }
495 
496    /// @notice Constructor of the crowsale to set up the main variables and create a token
497    /// @param _wallet The wallet address that stores the Wei raised
498    /// @param _tokenAddress The token used for the ICO
499    function Crowdsale(
500       address _wallet,
501       address _tokenAddress,
502       uint256 _startTime,
503       uint256 _endTime
504    ) public {
505       require(_wallet != address(0));
506       require(_tokenAddress != address(0));
507 
508       // If you send the start and end time on the constructor, the end must be larger
509       if(_startTime > 0 && _endTime > 0)
510          require(_startTime < _endTime);
511 
512       wallet = _wallet;
513       token = PallyCoin(_tokenAddress);
514       vault = new RefundVault(_wallet);
515 
516       if(_startTime > 0)
517          startTime = _startTime;
518 
519       if(_endTime > 0)
520          endTime = _endTime;
521    }
522 
523    /// @notice Fallback function to buy tokens
524    function () payable {
525       buyTokens();
526    }
527 
528    /// @notice To buy tokens given an address
529    function buyTokens() public payable whenNotPaused {
530       require(validPurchase());
531 
532       uint256 tokens = 0;
533       uint256 amountPaid = calculateExcessBalance();
534 
535       if(tokensRaised < limitTier1) {
536 
537          // Tier 1
538          tokens = amountPaid.mul(rate);
539 
540          // If the amount of tokens that you want to buy gets out of this tier
541          if(tokensRaised.add(tokens) > limitTier1)
542             tokens = calculateExcessTokens(amountPaid, limitTier1, 1, rate);
543       } else if(tokensRaised >= limitTier1 && tokensRaised < limitTier2) {
544 
545          // Tier 2
546          tokens = amountPaid.mul(rateTier2);
547 
548          // If the amount of tokens that you want to buy gets out of this tier
549          if(tokensRaised.add(tokens) > limitTier2)
550             tokens = calculateExcessTokens(amountPaid, limitTier2, 2, rateTier2);
551       } else if(tokensRaised >= limitTier2 && tokensRaised < limitTier3) {
552 
553          // Tier 3
554          tokens = amountPaid.mul(rateTier3);
555 
556          // If the amount of tokens that you want to buy gets out of this tier
557          if(tokensRaised.add(tokens) > limitTier3)
558             tokens = calculateExcessTokens(amountPaid, limitTier3, 3, rateTier3);
559       } else if(tokensRaised >= limitTier3) {
560 
561          // Tier 4
562          tokens = amountPaid.mul(rateTier4);
563       }
564 
565       weiRaised = weiRaised.add(amountPaid);
566       tokensRaised = tokensRaised.add(tokens);
567       token.distributeICOTokens(msg.sender, tokens);
568 
569       // Keep a record of how many tokens everybody gets in case we need to do refunds
570       tokensBought[msg.sender] = tokensBought[msg.sender].add(tokens);
571       TokenPurchase(msg.sender, amountPaid, tokens);
572       numberOfTransactions = numberOfTransactions.add(1);
573 
574       forwardFunds(amountPaid);
575    }
576 
577    /// @notice Sends the funds to the wallet or to the refund vault smart contract
578    /// if the minimum goal of tokens hasn't been reached yet
579    /// @param amountPaid The amount of ether paid
580    function forwardFunds(uint256 amountPaid) internal whenNotPaused {
581       if(goalReached()) {
582          wallet.transfer(amountPaid);
583       } else {
584          vault.deposit.value(amountPaid)(msg.sender);
585       }
586 
587       // If the minimum goal of the ICO has been reach, close the vault to send
588       // the ether to the wallet of the crowdsale
589       checkCompletedCrowdsale();
590    }
591 
592    /// @notice Calculates how many ether will be used to generate the tokens in
593    /// case the buyer sends more than the maximum balance but has some balance left
594    /// and updates the balance of that buyer.
595    /// For instance if he's 500 balance and he sends 1000, it will return 500
596    /// and refund the other 500 ether
597    function calculateExcessBalance() internal whenNotPaused returns(uint256) {
598       uint256 amountPaid = msg.value;
599       uint256 differenceWei = 0;
600       uint256 exceedingBalance = 0;
601 
602       // If we're in the last tier, check that the limit hasn't been reached
603       // and if so, refund the difference and return what will be used to
604       // buy the remaining tokens
605       if(tokensRaised >= limitTier3) {
606          uint256 addedTokens = tokensRaised.add(amountPaid.mul(rateTier4));
607 
608          // If tokensRaised + what you paid converted to tokens is bigger than the max
609          if(addedTokens > maxTokensRaised) {
610 
611             // Refund the difference
612             uint256 difference = addedTokens.sub(maxTokensRaised);
613             differenceWei = difference.div(rateTier4);
614             amountPaid = amountPaid.sub(differenceWei);
615          }
616       }
617 
618       uint256 addedBalance = crowdsaleBalances[msg.sender].add(amountPaid);
619 
620       // Checking that the individual limit of 1000 ETH per user is not reached
621       if(addedBalance <= maxPurchase) {
622          crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
623       } else {
624 
625          // Substracting 1000 ether in wei
626          exceedingBalance = addedBalance.sub(maxPurchase);
627          amountPaid = amountPaid.sub(exceedingBalance);
628 
629          // Add that balance to the balances
630          crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
631       }
632 
633       // Make the transfers at the end of the function for security purposes
634       if(differenceWei > 0)
635          msg.sender.transfer(differenceWei);
636 
637       if(exceedingBalance > 0) {
638 
639          // Return the exceeding balance to the buyer
640          msg.sender.transfer(exceedingBalance);
641       }
642 
643       return amountPaid;
644    }
645 
646    /// @notice Set's the rate of tokens per ether for each tier. Use it after the
647    /// smart contract is deployed to set the price according to the ether price
648    /// at the start of the ICO
649    /// @param tier1 The amount of tokens you get in the tier one
650    /// @param tier2 The amount of tokens you get in the tier two
651    /// @param tier3 The amount of tokens you get in the tier three
652    /// @param tier4 The amount of tokens you get in the tier four
653    function setTierRates(uint256 tier1, uint256 tier2, uint256 tier3, uint256 tier4)
654       external onlyOwner whenNotPaused beforeStarting
655    {
656       require(tier1 > 0 && tier2 > 0 && tier3 > 0 && tier4 > 0);
657       require(tier1 > tier2 && tier2 > tier3 && tier3 > tier4);
658 
659       rate = tier1;
660       rateTier2 = tier2;
661       rateTier3 = tier3;
662       rateTier4 = tier4;
663    }
664 
665    /// @notice Check if the crowdsale has ended and enables refunds only in case the
666    /// goal hasn't been reached
667    function checkCompletedCrowdsale() public whenNotPaused {
668       if(!isEnded) {
669          if(hasEnded() && !goalReached()){
670             vault.enableRefunds();
671 
672             isRefunding = true;
673             isEnded = true;
674             Finalized();
675          } else if(hasEnded() && goalReached()) {
676             vault.close();
677 
678             isEnded = true;
679             Finalized();
680          }
681       }
682    }
683 
684    /// @notice If crowdsale is unsuccessful, investors can claim refunds here
685    function claimRefund() public whenNotPaused {
686      require(hasEnded() && !goalReached() && isRefunding);
687 
688      vault.refund(msg.sender);
689      token.refundTokens(msg.sender, tokensBought[msg.sender]);
690    }
691 
692    /// @notice Buys the tokens for the specified tier and for the next one
693    /// @param amount The amount of ether paid to buy the tokens
694    /// @param tokensThisTier The limit of tokens of that tier
695    /// @param tierSelected The tier selected
696    /// @param _rate The rate used for that `tierSelected`
697    /// @return uint The total amount of tokens bought combining the tier prices
698    function calculateExcessTokens(
699       uint256 amount,
700       uint256 tokensThisTier,
701       uint256 tierSelected,
702       uint256 _rate
703    ) public returns(uint256 totalTokens) {
704       require(amount > 0 && tokensThisTier > 0 && _rate > 0);
705       require(tierSelected >= 1 && tierSelected <= 4);
706 
707       uint weiThisTier = tokensThisTier.sub(tokensRaised).div(_rate);
708       uint weiNextTier = amount.sub(weiThisTier);
709       uint tokensNextTier = 0;
710       bool returnTokens = false;
711 
712       // If there's excessive wei for the last tier, refund those
713       if(tierSelected != 4)
714          tokensNextTier = calculateTokensTier(weiNextTier, tierSelected.add(1));
715       else
716          returnTokens = true;
717 
718       totalTokens = tokensThisTier.sub(tokensRaised).add(tokensNextTier);
719 
720       // Do the transfer at the end
721       if(returnTokens) msg.sender.transfer(weiNextTier);
722    }
723 
724    /// @notice Buys the tokens given the price of the tier one and the wei paid
725    /// @param weiPaid The amount of wei paid that will be used to buy tokens
726    /// @param tierSelected The tier that you'll use for thir purchase
727    /// @return calculatedTokens Returns how many tokens you've bought for that wei paid
728    function calculateTokensTier(uint256 weiPaid, uint256 tierSelected)
729         internal constant returns(uint256 calculatedTokens)
730    {
731       require(weiPaid > 0);
732       require(tierSelected >= 1 && tierSelected <= 4);
733 
734       if(tierSelected == 1)
735          calculatedTokens = weiPaid.mul(rate);
736       else if(tierSelected == 2)
737          calculatedTokens = weiPaid.mul(rateTier2);
738       else if(tierSelected == 3)
739          calculatedTokens = weiPaid.mul(rateTier3);
740       else
741          calculatedTokens = weiPaid.mul(rateTier4);
742    }
743 
744 
745    /// @notice Checks if a purchase is considered valid
746    /// @return bool If the purchase is valid or not
747    function validPurchase() internal constant returns(bool) {
748       bool withinPeriod = now >= startTime && now <= endTime;
749       bool nonZeroPurchase = msg.value > 0;
750       bool withinTokenLimit = tokensRaised < maxTokensRaised;
751       bool minimumPurchase = msg.value >= minPurchase;
752       bool hasBalanceAvailable = crowdsaleBalances[msg.sender] < maxPurchase;
753 
754       // We want to limit the gas to avoid giving priority to the biggest paying contributors
755       bool limitGas = tx.gasprice <= limitGasPrice;
756 
757       return withinPeriod && nonZeroPurchase && withinTokenLimit && minimumPurchase && hasBalanceAvailable && limitGas;
758    }
759 
760    /// @notice To see if the minimum goal of tokens of the ICO has been reached
761    /// @return bool True if the tokens raised are bigger than the goal or false otherwise
762    function goalReached() public constant returns(bool) {
763       return tokensRaised >= minimumGoal;
764    }
765 
766    /// @notice Public function to check if the crowdsale has ended or not
767    function hasEnded() public constant returns(bool) {
768       return now > endTime || tokensRaised >= maxTokensRaised;
769    }
770 }