1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is Ownable {
82   event Pause();
83   event Unpause();
84 
85   bool public paused = false;
86 
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() onlyOwner whenNotPaused public {
108     paused = true;
109     Pause();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() onlyOwner whenPaused public {
116     paused = false;
117     Unpause();
118   }
119 }
120 
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
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public view returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value <= allowed[_from][msg.sender]);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public view returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 
267 /**
268  * @title Pausable token
269  *
270  * @dev StandardToken modified with pausable transfers.
271  **/
272 
273 contract PausableToken is StandardToken, Pausable {
274 
275   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
280     return super.transferFrom(_from, _to, _value);
281   }
282 
283   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
284     return super.approve(_spender, _value);
285   }
286 
287   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
288     return super.increaseApproval(_spender, _addedValue);
289   }
290 
291   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
292     return super.decreaseApproval(_spender, _subtractedValue);
293   }
294 }
295 
296 contract CostumeToken is PausableToken {
297   using SafeMath for uint256;
298 
299   // Token Details
300   string public constant name = 'Costume Token';
301   string public constant symbol = 'COST';
302   uint8 public constant decimals = 18;
303 
304   // 200 Million Total Supply
305   uint256 public constant totalSupply = 200e24;
306 
307   // 120 Million - Supply not for Crowdsale
308   uint256 public initialSupply = 120e24;
309 
310   // 80 Million - Crowdsale limit
311   uint256 public limitCrowdsale = 80e24;
312 
313   // Tokens Distributed - Crowdsale Buyers
314   uint256 public tokensDistributedCrowdsale = 0;
315 
316   // The address of the crowdsale
317   address public crowdsale;
318 
319   // -- MODIFIERS
320 
321   // Modifier, must be called from Crowdsale contract
322   modifier onlyCrowdsale() {
323     require(msg.sender == crowdsale);
324     _;
325   }
326 
327   // Constructor - send initial supply to owner
328   function CostumeToken() public {
329     balances[msg.sender] = initialSupply;
330   }
331 
332   // Set crowdsale address, only by owner
333   // @param - crowdsale address
334   function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
335     require(crowdsale == address(0));
336     require(_crowdsale != address(0));
337     crowdsale = _crowdsale;
338   }
339 
340   // Distribute tokens, only by crowdsale
341   // @param _buyer The buyer address
342   // @param tokens The amount of tokens to send to that address
343   function distributeCrowdsaleTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
344     require(_buyer != address(0));
345     require(tokens > 0);
346 
347     require(tokensDistributedCrowdsale < limitCrowdsale);
348     require(tokensDistributedCrowdsale.add(tokens) <= limitCrowdsale);
349 
350     // Tick up the distributed amount
351     tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
352 
353     // Add the funds to buyer address
354     balances[_buyer] = balances[_buyer].add(tokens);
355   }
356 
357 }
358 
359 contract Crowdsale is Pausable {
360    using SafeMath for uint256;
361 
362    // The token being sold
363    CostumeToken public token;
364 
365    // 12.15.2017 - 12:00:00 GMT
366    uint256 public startTime = 1513339200;
367 
368    // 1.31.2018 - 12:00:00 GMT
369    uint256 public endTime = 1517400000;
370 
371    // Costume Wallet
372    address public wallet;
373 
374    // Set tier rates
375    uint256 public rate = 3400;
376    uint256 public rateTier2 = 3200;
377    uint256 public rateTier3 = 3000;
378    uint256 public rateTier4 = 2800;
379 
380    // The maximum amount of wei for each tier
381    // 20 Million Intervals
382    uint256 public limitTier1 = 20e24;
383    uint256 public limitTier2 = 40e24;
384    uint256 public limitTier3 = 60e24;
385 
386    // 80 Million Tokens available for crowdsale
387    uint256 public constant maxTokensRaised = 80e24;
388 
389    // The amount of wei raised
390    uint256 public weiRaised = 0;
391 
392    // The amount of tokens raised
393    uint256 public tokensRaised = 0;
394 
395    // 0.1 ether minumum per contribution
396    uint256 public constant minPurchase = 100 finney;
397 
398    // Crowdsale tokens not purchased
399    bool public remainingTransfered = false;
400 
401    // The number of transactions
402    uint256 public numberOfTransactions;
403 
404    // -- DATA-SETS
405 
406    // Amount each address paid for tokens
407    mapping(address => uint256) public crowdsaleBalances;
408 
409    // Amount of tokens each address received
410    mapping(address => uint256) public tokensBought;
411 
412    // -- EVENTS
413 
414    // Trigger TokenPurchase event
415    event TokenPurchase(address indexed buyer, uint256 value, uint256 amountOfTokens);
416 
417    // Crowdsale Ended
418    event Finalized();
419 
420    // -- MODIFIERS
421 
422    // Only allow the execution of the function before the crowdsale starts
423    modifier beforeStarting() {
424       require(now < startTime);
425       _;
426    }
427 
428    // Main Constructor
429    // @param _wallet - Fund wallet address
430    // @param _tokenAddress - Associated token address
431    // @param _startTime - Crowdsale start time
432    // @param _endTime - Crowdsale end time
433    function Crowdsale(
434       address _wallet,
435       address _tokenAddress,
436       uint256 _startTime,
437       uint256 _endTime
438    ) public {
439       require(_wallet != address(0));
440       require(_tokenAddress != address(0));
441 
442       if (_startTime > 0 && _endTime > 0) {
443           require(_startTime < _endTime);
444       }
445 
446       wallet = _wallet;
447       token = CostumeToken(_tokenAddress);
448 
449       if (_startTime > 0) {
450           startTime = _startTime;
451       }
452 
453       if (_endTime > 0) {
454           endTime = _endTime;
455       }
456 
457    }
458 
459    /// Buy tokens fallback
460    function () external payable {
461       buyTokens();
462    }
463 
464    /// Buy tokens main
465    function buyTokens() public payable whenNotPaused {
466       require(validPurchase());
467 
468       uint256 tokens = 0;
469       uint256 amountPaid = adjustAmountValue();
470 
471       if (tokensRaised < limitTier1) {
472 
473          // Tier 1
474          tokens = amountPaid.mul(rate);
475 
476          // If the amount of tokens that you want to buy gets out of this tier
477          if (tokensRaised.add(tokens) > limitTier1) {
478 
479             tokens = adjustTokenTierValue(amountPaid, limitTier1, 1, rate);
480          }
481 
482       } else if (tokensRaised >= limitTier1 && tokensRaised < limitTier2) {
483 
484          // Tier 2
485          tokens = amountPaid.mul(rateTier2);
486 
487           // Breaks tier cap
488          if (tokensRaised.add(tokens) > limitTier2) {
489             tokens = adjustTokenTierValue(amountPaid, limitTier2, 2, rateTier2);
490          }
491 
492       } else if (tokensRaised >= limitTier2 && tokensRaised < limitTier3) {
493 
494          // Tier 3
495          tokens = amountPaid.mul(rateTier3);
496 
497          // Breaks tier cap
498          if (tokensRaised.add(tokens) > limitTier3) {
499             tokens = adjustTokenTierValue(amountPaid, limitTier3, 3, rateTier3);
500          }
501 
502       } else if (tokensRaised >= limitTier3) {
503 
504          // Tier 4
505          tokens = amountPaid.mul(rateTier4);
506 
507       }
508 
509       weiRaised = weiRaised.add(amountPaid);
510       tokensRaised = tokensRaised.add(tokens);
511       token.distributeCrowdsaleTokens(msg.sender, tokens);
512 
513       // Keep the records
514       tokensBought[msg.sender] = tokensBought[msg.sender].add(tokens);
515 
516       // Broadcast event
517       TokenPurchase(msg.sender, amountPaid, tokens);
518 
519       // Update records
520       numberOfTransactions = numberOfTransactions.add(1);
521 
522       forwardFunds(amountPaid);
523    }
524 
525    // Forward funds to fund wallet
526    function forwardFunds(uint256 amountPaid) internal whenNotPaused {
527 
528      // Send directly to dev wallet
529      wallet.transfer(amountPaid);
530    }
531 
532    // Adjust wei based on tier, refund if necessaey
533    function adjustAmountValue() internal whenNotPaused returns(uint256) {
534       uint256 amountPaid = msg.value;
535       uint256 differenceWei = 0;
536 
537       // Check final tier
538       if(tokensRaised >= limitTier3) {
539          uint256 addedTokens = tokensRaised.add(amountPaid.mul(rateTier4));
540 
541          // Have we reached the max?
542          if(addedTokens > maxTokensRaised) {
543 
544             // Find the amount over the max
545             uint256 difference = addedTokens.sub(maxTokensRaised);
546             differenceWei = difference.div(rateTier4);
547             amountPaid = amountPaid.sub(differenceWei);
548          }
549       }
550 
551       // Update balances dataset
552       crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
553 
554       // Transfer at the end
555       if (differenceWei > 0) msg.sender.transfer(differenceWei);
556 
557       return amountPaid;
558    }
559 
560    // Set / change tier rates
561    // @param tier1 - tier4 - Rate per tier
562    function setTierRates(uint256 tier1, uint256 tier2, uint256 tier3, uint256 tier4)
563       external onlyOwner whenNotPaused {
564 
565       require(tier1 > 0 && tier2 > 0 && tier3 > 0 && tier4 > 0);
566       require(tier1 > tier2 && tier2 > tier3 && tier3 > tier4);
567 
568       rate = tier1;
569       rateTier2 = tier2;
570       rateTier3 = tier3;
571       rateTier4 = tier4;
572    }
573 
574    // Adjust token per tier, return wei if necessay
575    // @param amount - Amount buyer paid
576    // @param tokensThisTier - Tokens in tier
577    // @param tierSelected - The current tier
578    // @param _rate - Current rate
579    function adjustTokenTierValue(
580       uint256 amount,
581       uint256 tokensThisTier,
582       uint256 tierSelected,
583       uint256 _rate
584    ) internal returns(uint256 totalTokens) {
585       require(amount > 0 && tokensThisTier > 0 && _rate > 0);
586       require(tierSelected >= 1 && tierSelected <= 4);
587 
588       uint weiThisTier = tokensThisTier.sub(tokensRaised).div(_rate);
589       uint weiNextTier = amount.sub(weiThisTier);
590       uint tokensNextTier = 0;
591       bool returnTokens = false;
592 
593       // If there's excessive wei for the last tier, refund those
594       if(tierSelected != 4) {
595 
596          tokensNextTier = calculateTokensPerTier(weiNextTier, tierSelected.add(1));
597 
598       } else {
599 
600          returnTokens = true;
601 
602       }
603 
604       totalTokens = tokensThisTier.sub(tokensRaised).add(tokensNextTier);
605 
606       // Do the transfer at the end
607       if (returnTokens) msg.sender.transfer(weiNextTier);
608    }
609 
610    // Return token amount based on wei paid
611    // @param weiPaid - Amount buyer paid
612    // @param tierSelected - The current tier
613    function calculateTokensPerTier(uint256 weiPaid, uint256 tierSelected)
614         internal constant returns(uint256 calculatedTokens)
615     {
616       require(weiPaid > 0);
617       require(tierSelected >= 1 && tierSelected <= 4);
618 
619       if (tierSelected == 1) {
620 
621          calculatedTokens = weiPaid.mul(rate);
622 
623       } else if (tierSelected == 2) {
624 
625          calculatedTokens = weiPaid.mul(rateTier2);
626 
627       } else if (tierSelected == 3) {
628 
629          calculatedTokens = weiPaid.mul(rateTier3);
630 
631       } else {
632 
633          calculatedTokens = weiPaid.mul(rateTier4);
634      }
635    }
636 
637    // Confirm valid purchase
638    function validPurchase() internal constant returns(bool) {
639       bool withinPeriod = now >= startTime && now <= endTime;
640       bool nonZeroPurchase = msg.value > 0;
641       bool withinTokenLimit = tokensRaised < maxTokensRaised;
642       bool minimumPurchase = msg.value >= minPurchase;
643 
644       return withinPeriod && nonZeroPurchase && withinTokenLimit && minimumPurchase;
645    }
646 
647    // Check if sale ended
648    function hasEnded() public constant returns(bool) {
649        return now > endTime || tokensRaised >= maxTokensRaised;
650    }
651 
652    // Finalize if ended
653    function completeCrowdsale() external onlyOwner whenNotPaused {
654        require(hasEnded());
655 
656        // Transfer left over tokens
657        transferTokensLeftOver();
658 
659        // Call finalized event
660        Finalized();
661    }
662 
663    // Transfer any remaining tokens from Crowdsale
664    function transferTokensLeftOver() internal {
665        require(!remainingTransfered);
666        require(maxTokensRaised > tokensRaised);
667 
668        remainingTransfered = true;
669 
670        uint256 remainingTokens = maxTokensRaised.sub(tokensRaised);
671        token.distributeCrowdsaleTokens(msg.sender, remainingTokens);
672    }
673 
674    // Change dates before crowdsale has started
675    // @param _startTime - New start time
676    // @param _endTime - New end time
677    function changeDates(uint256 _startTime, uint256 _endTime)
678         external onlyOwner beforeStarting
679     {
680 
681        if (_startTime > 0 && _endTime > 0) {
682            require(_startTime < _endTime);
683        }
684 
685        if (_startTime > 0) {
686            startTime = _startTime;
687        }
688 
689        if (_endTime > 0) {
690            endTime = _endTime;
691        }
692    }
693 
694    // Change the end date
695    // @param _endTime - New end time
696    function changeEndDate(uint256 _endTime) external onlyOwner {
697        require(_endTime > startTime);
698        require(_endTime > now);
699        require(!hasEnded());
700 
701        if (_endTime > 0) {
702            endTime = _endTime;
703        }
704    }
705 
706 }