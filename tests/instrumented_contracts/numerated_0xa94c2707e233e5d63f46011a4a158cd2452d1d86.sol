1 pragma solidity ^0.4.18;
2 
3 // ----------------- 
4 //begin Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 //end Ownable.sol
49 // ----------------- 
50 //begin SafeMath.sol
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 //end SafeMath.sol
86 // ----------------- 
87 //begin ERC20Basic.sol
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 //end ERC20Basic.sol
102 // ----------------- 
103 //begin Pausable.sol
104 
105 
106 
107 /**
108  * @title Pausable
109  * @dev Base contract which allows children to implement an emergency stop mechanism.
110  */
111 contract Pausable is Ownable {
112   event Pause();
113   event Unpause();
114 
115   bool public paused = false;
116 
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is not paused.
120    */
121   modifier whenNotPaused() {
122     require(!paused);
123     _;
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is paused.
128    */
129   modifier whenPaused() {
130     require(paused);
131     _;
132   }
133 
134   /**
135    * @dev called by the owner to pause, triggers stopped state
136    */
137   function pause() onlyOwner whenNotPaused public {
138     paused = true;
139     Pause();
140   }
141 
142   /**
143    * @dev called by the owner to unpause, returns to normal state
144    */
145   function unpause() onlyOwner whenPaused public {
146     paused = false;
147     Unpause();
148   }
149 }
150 
151 //end Pausable.sol
152 // ----------------- 
153 //begin BasicToken.sol
154 
155 
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
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256 balance) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 //end BasicToken.sol
194 // ----------------- 
195 //begin ERC20.sol
196 
197 
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address owner, address spender) public view returns (uint256);
205   function transferFrom(address from, address to, uint256 value) public returns (bool);
206   function approve(address spender, uint256 value) public returns (bool);
207   event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 //end ERC20.sol
211 // ----------------- 
212 //begin StandardToken.sol
213 
214 
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225   mapping (address => mapping (address => uint256)) internal allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235     require(_to != address(0));
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248    *
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(address _owner, address _spender) public view returns (uint256) {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 //end StandardToken.sol
312 // ----------------- 
313 //begin MintableToken.sol
314 
315 
316 
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344     totalSupply = totalSupply.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     Mint(_to, _amount);
347     Transfer(address(0), _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() onlyOwner canMint public returns (bool) {
356     mintingFinished = true;
357     MintFinished();
358     return true;
359   }
360 }
361 
362 //end MintableToken.sol
363 // ----------------- 
364 //begin PausableToken.sol
365 
366 /**
367  * @title Pausable token
368  *
369  * @dev StandardToken modified with pausable transfers.
370  **/
371 
372 contract PausableToken is StandardToken, Pausable {
373 
374   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
375     return super.transfer(_to, _value);
376   }
377 
378   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
379     return super.transferFrom(_from, _to, _value);
380   }
381 
382   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
383     return super.approve(_spender, _value);
384   }
385 
386   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
387     return super.increaseApproval(_spender, _addedValue);
388   }
389 
390   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
391     return super.decreaseApproval(_spender, _subtractedValue);
392   }
393 }
394 
395 //end PausableToken.sol
396 // ----------------- 
397 //begin RestartEnergyToken.sol
398 
399 contract RestartEnergyToken is MintableToken, PausableToken {
400     string public name = "RED MWAT";
401     string public symbol = "MWAT";
402     uint256 public decimals = 18;
403 }
404 
405 //end RestartEnergyToken.sol
406 // ----------------- 
407 //begin Crowdsale.sol
408 
409 /**
410  * @title Crowdsale
411  * @dev Crowdsale is a base contract for managing a token crowdsale.
412  * Crowdsales have a start and end timestamps, where investors can make
413  * token purchases and the crowdsale will assign them tokens based
414  * on a token per ETH rate. Funds collected are forwarded to a wallet
415  * as they arrive.
416  */
417 contract Crowdsale {
418   using SafeMath for uint256;
419 
420   // The token being sold
421   MintableToken public token;
422 
423   // start and end timestamps where investments are allowed (both inclusive)
424   uint256 public startTime;
425   uint256 public endTime;
426 
427   // address where funds are collected
428   address public wallet;
429 
430   // how many token units a buyer gets per wei
431   uint256 public rate;
432 
433   // amount of raised money in wei
434   uint256 public weiRaised;
435 
436   /**
437    * event for token purchase logging
438    * @param purchaser who paid for the tokens
439    * @param beneficiary who got the tokens
440    * @param value weis paid for purchase
441    * @param amount amount of tokens purchased
442    */
443   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
444 
445 
446   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
447     require(_startTime >= now);
448     require(_endTime >= _startTime);
449     require(_rate > 0);
450     require(_wallet != address(0));
451 
452     token = createTokenContract();
453     startTime = _startTime;
454     endTime = _endTime;
455     rate = _rate;
456     wallet = _wallet;
457   }
458 
459   // creates the token to be sold.
460   // override this method to have crowdsale of a specific mintable token.
461   function createTokenContract() internal returns (MintableToken) {
462     return new MintableToken();
463   }
464 
465 
466   // fallback function can be used to buy tokens
467   function () external payable {
468     buyTokens(msg.sender);
469   }
470 
471   // low level token purchase function
472   function buyTokens(address beneficiary) public payable {
473     require(beneficiary != address(0));
474     require(validPurchase());
475 
476     uint256 weiAmount = msg.value;
477 
478     // calculate token amount to be created
479     uint256 tokens = weiAmount.mul(rate);
480 
481     // update state
482     weiRaised = weiRaised.add(weiAmount);
483 
484     token.mint(beneficiary, tokens);
485     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
486 
487     forwardFunds();
488   }
489 
490   // send ether to the fund collection wallet
491   // override to create custom fund forwarding mechanisms
492   function forwardFunds() internal {
493     wallet.transfer(msg.value);
494   }
495 
496   // @return true if the transaction can buy tokens
497   function validPurchase() internal view returns (bool) {
498     bool withinPeriod = now >= startTime && now <= endTime;
499     bool nonZeroPurchase = msg.value != 0;
500     return withinPeriod && nonZeroPurchase;
501   }
502 
503   // @return true if crowdsale event has ended
504   function hasEnded() public view returns (bool) {
505     return now > endTime;
506   }
507 
508 
509 }
510 
511 //end Crowdsale.sol
512 // ----------------- 
513 //begin TimedCrowdsale.sol
514 
515 
516 
517 contract TimedCrowdsale is Crowdsale, Ownable {
518 
519     uint256 public presaleStartTime;
520 
521     uint256 public presaleEndTime;
522 
523     event EndTimeChanged(uint newEndTime);
524 
525     event StartTimeChanged(uint newStartTime);
526 
527     event PresaleStartTimeChanged(uint newPresaleStartTime);
528 
529     event PresaleEndTimeChanged(uint newPresaleEndTime);
530 
531     function setEndTime(uint time) public onlyOwner {
532         require(now < time);
533         require(time > startTime);
534 
535         endTime = time;
536         EndTimeChanged(endTime);
537     }
538 
539     function setStartTime(uint time) public onlyOwner {
540         require(now < time);
541         require(time > presaleEndTime);
542 
543         startTime = time;
544         StartTimeChanged(startTime);
545     }
546 
547     function setPresaleStartTime(uint time) public onlyOwner {
548         require(now < time);
549         require(time < presaleEndTime);
550 
551         presaleStartTime = time;
552         PresaleStartTimeChanged(presaleStartTime);
553     }
554 
555     function setPresaleEndTime(uint time) public onlyOwner {
556         require(now < time);
557         require(time > presaleStartTime);
558 
559         presaleEndTime = time;
560         PresaleEndTimeChanged(presaleEndTime);
561     }
562 
563 }
564 
565 //end TimedCrowdsale.sol
566 // ----------------- 
567 //begin FinalizableCrowdsale.sol
568 
569 /**
570  * @title FinalizableCrowdsale
571  * @dev Extension of Crowdsale where an owner can do extra work
572  * after finishing.
573  */
574 contract FinalizableCrowdsale is Crowdsale, Ownable {
575   using SafeMath for uint256;
576 
577   bool public isFinalized = false;
578 
579   event Finalized();
580 
581   /**
582    * @dev Must be called after crowdsale ends, to do some extra finalization
583    * work. Calls the contract's finalization function.
584    */
585   function finalize() onlyOwner public {
586     require(!isFinalized);
587     require(hasEnded());
588 
589     finalization();
590     Finalized();
591 
592     isFinalized = true;
593   }
594 
595   /**
596    * @dev Can be overridden to add finalization logic. The overriding function
597    * should call super.finalization() to ensure the chain of finalization is
598    * executed entirely.
599    */
600   function finalization() internal {
601   }
602 }
603 
604 //end FinalizableCrowdsale.sol
605 // ----------------- 
606 //begin TokenCappedCrowdsale.sol
607 
608 
609 
610 contract TokenCappedCrowdsale is FinalizableCrowdsale {
611     using SafeMath for uint256;
612 
613     uint256 public hardCap;
614     uint256 public totalTokens;
615 
616     function TokenCappedCrowdsale() internal {
617 
618         hardCap = 400000000 * 1 ether;
619         totalTokens = 500000000 * 1 ether;
620     }
621 
622     function notExceedingSaleLimit(uint256 amount) internal constant returns (bool) {
623         return hardCap >= amount.add(token.totalSupply());
624     }
625 
626     /**
627     * Finalization logic. We take the expected sale cap
628     * ether and find the difference from the actual minted tokens.
629     * The remaining balance and the reserved amount for the team are minted
630     * to the team wallet.
631     */
632     function finalization() internal {
633         super.finalization();
634     }
635 }
636 
637 //end TokenCappedCrowdsale.sol
638 // ----------------- 
639 //begin RestartEnergyCrowdsale.sol
640 
641 
642 
643 
644 contract RestartEnergyCrowdsale is TimedCrowdsale, TokenCappedCrowdsale, Pausable {
645 
646     uint256 public presaleLimit = 10 * 1 ether;
647 
648     // how many token units a buyer gets per ether with basic presale discount
649     uint16 public presaleRate = 120;
650 
651     uint256 public soldTokens = 0;
652 
653     uint16 public etherRate = 130;
654 
655     // address where tokens for team, advisors and bounty ar minted
656     address public tokensWallet;
657 
658     // How much ETH each address has invested to this crowdsale
659     mapping(address => uint256) public purchasedAmountOf;
660 
661     // How many tokens this crowdsale has credited for each investor address
662     mapping(address => uint256) public tokenAmountOf;
663 
664 
665     function RestartEnergyCrowdsale(uint256 _presaleStartTime, uint256 _presaleEndTime,
666         uint256 _startTime, uint256 _endTime, address _wallet, address _tokensWallet) public TokenCappedCrowdsale() Crowdsale(_startTime, _endTime, 100, _wallet) {
667         presaleStartTime = _presaleStartTime;
668         presaleEndTime = _presaleEndTime;
669         tokensWallet = _tokensWallet;
670 
671         require(now <= presaleStartTime);
672         require(presaleEndTime > presaleStartTime);
673         require(presaleEndTime < startTime);
674     }
675 
676     /**
677     * Creates the token automatically (inherited from zeppelin Crowdsale)
678     */
679     function createTokenContract() internal returns (MintableToken) {
680         return RestartEnergyToken(0x0);
681     }
682 
683     /**
684     * create the token manually to consume less gas per transaction when deploying
685     */
686     function buildTokenContract() public onlyOwner {
687         require(token == address(0x0));
688         RestartEnergyToken _token = new RestartEnergyToken();
689         _token.pause();
690         token = _token;
691     }
692 
693     function buy() public whenNotPaused payable {
694         buyTokens(msg.sender);
695     }
696 
697     function buyTokens(address beneficiary) public whenNotPaused payable {
698         require(!isFinalized);
699         require(beneficiary != 0x0);
700         require(validPresalePurchase() || validPurchase());
701 
702         uint256 weiAmount = msg.value;
703 
704         // calculate token amount to be created
705         uint256 tokens = weiAmount.mul(getRate());
706 
707         require(notExceedingSaleLimit(tokens));
708 
709         // update state
710         weiRaised = weiRaised.add(weiAmount);
711 
712         soldTokens = soldTokens.add(tokens);
713 
714         // mint the tokens
715         token.mint(beneficiary, tokens);
716 
717         // update purchaser
718         purchasedAmountOf[msg.sender] = purchasedAmountOf[msg.sender].add(msg.value);
719         tokenAmountOf[msg.sender] = tokenAmountOf[msg.sender].add(tokens);
720 
721         //event
722         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
723 
724         //forward funds to our wallet
725         forwardFunds();
726     }
727 
728     /**
729     * Send tokens by the owner directly to an address.
730     */
731     function sendTokensToAddress(uint256 amount, address to) public onlyOwner {
732         require(!isFinalized);
733         require(notExceedingSaleLimit(amount));
734         tokenAmountOf[to] = tokenAmountOf[to].add(amount);
735         soldTokens = soldTokens.add(amount);
736         token.mint(to, amount);
737 
738         TokenPurchase(msg.sender, to, 0, amount);
739     }
740 
741     function enableTokenTransfers() public onlyOwner {
742         require(isFinalized);
743         require(now > endTime + 15 days);
744         require(RestartEnergyToken(token).paused());
745         RestartEnergyToken(token).unpause();
746     }
747 
748     // the team wallet is the 'wallet' field
749     bool public firstPartOfTeamTokensClaimed = false;
750     bool public secondPartOfTeamTokensClaimed = false;
751 
752 
753     function claimTeamTokens() public onlyOwner {
754         require(isFinalized);
755         require(!secondPartOfTeamTokensClaimed);
756         require(now > endTime + 182 days);
757 
758         uint256 tokensToMint = totalTokens.mul(3).div(100);
759         if (!firstPartOfTeamTokensClaimed) {
760             token.mint(tokensWallet, tokensToMint);
761             firstPartOfTeamTokensClaimed = true;
762         }
763         else {
764             require(now > endTime + 365 days);
765             token.mint(tokensWallet, tokensToMint);
766             secondPartOfTeamTokensClaimed = true;
767             token.finishMinting();
768         }
769     }
770 
771     /**
772     * the rate (how much tokens are given for 1 ether)
773     * is calculated according to presale/sale period and the amount of ether
774     */
775     function getRate() internal view returns (uint256) {
776         uint256 calcRate = rate;
777         //check if this sale is in presale period
778         if (validPresalePurchase()) {
779             calcRate = presaleRate;
780         }
781         else {
782             //if not validPresalePurchase() and not validPurchase() this function is not called
783             // so no need to check validPurchase() again here
784             uint256 daysPassed = (now - startTime) / 1 days;
785             if (daysPassed < 15) {
786                 calcRate = 100 + (15 - daysPassed);
787             }
788         }
789         calcRate = calcRate.mul(etherRate);
790         return calcRate;
791     }
792 
793 
794     function setEtherRate(uint16 _etherRate) public onlyOwner {
795         etherRate = _etherRate;
796 
797         // the presaleLimit must be $10000 in eth at the defined 'etherRate'
798         presaleLimit = uint256(1 ether).mul(10000).div(etherRate).div(10);
799     }
800 
801     // @return true if the transaction can buy tokens in presale
802     function validPresalePurchase() internal constant returns (bool) {
803         bool withinPeriod = now >= presaleStartTime && now <= presaleEndTime;
804         bool nonZeroPurchase = msg.value != 0;
805         bool validPresaleLimit = msg.value >= presaleLimit;
806         return withinPeriod && nonZeroPurchase && validPresaleLimit;
807     }
808 
809     function finalization() internal {
810         super.finalization();
811 
812         // mint 14% of total Tokens (3% for bounty, 5% for advisors, 6% for team) into team wallet
813         uint256 toMintNow = totalTokens.mul(14).div(100);
814         token.mint(tokensWallet, toMintNow);
815     }
816 }
817 
818 //end RestartEnergyCrowdsale.sol