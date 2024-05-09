1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 
74 /**
75  * @title SafeERC20
76  * @dev Wrappers around ERC20 operations that throw on failure.
77  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
78  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
79  */
80 library SafeERC20 {
81   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
82     assert(token.transfer(to, value));
83   }
84 
85   function safeTransferFrom(
86     ERC20 token,
87     address from,
88     address to,
89     uint256 value
90   )
91     internal
92   {
93     assert(token.transferFrom(from, to, value));
94   }
95 
96   function safeApprove(ERC20 token, address spender, uint256 value) internal {
97     assert(token.approve(spender, value));
98   }
99 }
100 
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) public onlyOwner {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140 }
141 
142 
143  /* Standard SafeMath implementation from Zeppelin */
144 
145 
146 
147 
148 
149 
150 /**
151  * @title Claimable
152  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
153  * This allows the new owner to accept the transfer.
154  */
155 contract Claimable is Ownable {
156   address public pendingOwner;
157 
158   /**
159    * @dev Modifier throws if called by any account other than the pendingOwner.
160    */
161   modifier onlyPendingOwner() {
162     require(msg.sender == pendingOwner);
163     _;
164   }
165 
166   /**
167    * @dev Allows the current owner to set the pendingOwner address.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) onlyOwner public {
171     pendingOwner = newOwner;
172   }
173 
174   /**
175    * @dev Allows the pendingOwner address to finalize the transfer.
176    */
177   function claimOwnership() onlyPendingOwner public {
178     emit OwnershipTransferred(owner, pendingOwner);
179     owner = pendingOwner;
180     pendingOwner = address(0);
181   }
182 }
183  /* Standard Claimable implementation from Zeppelin */
184 
185 
186 
187 
188 
189 
190 
191 /**
192  * @title Contracts that should be able to recover tokens
193  * @author SylTi
194  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
195  * This will prevent any accidental loss of tokens.
196  */
197 contract CanReclaimToken is Ownable {
198   using SafeERC20 for ERC20Basic;
199 
200   /**
201    * @dev Reclaim all ERC20Basic compatible tokens
202    * @param token ERC20Basic The address of the token contract
203    */
204   function reclaimToken(ERC20Basic token) external onlyOwner {
205     uint256 balance = token.balanceOf(this);
206     token.safeTransfer(owner, balance);
207   }
208 
209 }
210  /* Standard Claimable implementation from Zeppelin */
211 
212 
213 
214 
215 
216 
217 
218 
219 
220 
221 
222 
223 
224 /**
225  * @title Basic token
226  * @dev Basic version of StandardToken, with no allowances.
227  */
228 contract BasicToken is ERC20Basic {
229   using SafeMath for uint256;
230 
231   mapping(address => uint256) balances;
232 
233   uint256 totalSupply_;
234 
235   /**
236   * @dev total number of tokens in existence
237   */
238   function totalSupply() public view returns (uint256) {
239     return totalSupply_;
240   }
241 
242   /**
243   * @dev transfer token for a specified address
244   * @param _to The address to transfer to.
245   * @param _value The amount to be transferred.
246   */
247   function transfer(address _to, uint256 _value) public returns (bool) {
248     require(_to != address(0));
249     require(_value <= balances[msg.sender]);
250 
251     balances[msg.sender] = balances[msg.sender].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     emit Transfer(msg.sender, _to, _value);
254     return true;
255   }
256 
257   /**
258   * @dev Gets the balance of the specified address.
259   * @param _owner The address to query the the balance of.
260   * @return An uint256 representing the amount owned by the passed address.
261   */
262   function balanceOf(address _owner) public view returns (uint256) {
263     return balances[_owner];
264   }
265 
266 }
267 
268 
269 
270 /**
271  * @title Burnable Token
272  * @dev Token that can be irreversibly burned (destroyed).
273  */
274 contract BurnableToken is BasicToken {
275 
276   event Burn(address indexed burner, uint256 value);
277 
278   /**
279    * @dev Burns a specific amount of tokens.
280    * @param _value The amount of token to be burned.
281    */
282   function burn(uint256 _value) public {
283     _burn(msg.sender, _value);
284   }
285 
286   function _burn(address _who, uint256 _value) internal {
287     require(_value <= balances[_who]);
288     // no need to require value <= totalSupply, since that would imply the
289     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
290 
291     balances[_who] = balances[_who].sub(_value);
292     totalSupply_ = totalSupply_.sub(_value);
293     emit Burn(_who, _value);
294     emit Transfer(_who, address(0), _value);
295   }
296 }
297 
298 
299 
300 
301 
302 
303 
304 /**
305  * @title Standard ERC20 token
306  *
307  * @dev Implementation of the basic standard token.
308  * @dev https://github.com/ethereum/EIPs/issues/20
309  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
310  */
311 contract StandardToken is ERC20, BasicToken {
312 
313   mapping (address => mapping (address => uint256)) internal allowed;
314 
315 
316   /**
317    * @dev Transfer tokens from one address to another
318    * @param _from address The address which you want to send tokens from
319    * @param _to address The address which you want to transfer to
320    * @param _value uint256 the amount of tokens to be transferred
321    */
322   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
323     require(_to != address(0));
324     require(_value <= balances[_from]);
325     require(_value <= allowed[_from][msg.sender]);
326 
327     balances[_from] = balances[_from].sub(_value);
328     balances[_to] = balances[_to].add(_value);
329     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
330     emit Transfer(_from, _to, _value);
331     return true;
332   }
333 
334   /**
335    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
336    *
337    * Beware that changing an allowance with this method brings the risk that someone may use both the old
338    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
339    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
340    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341    * @param _spender The address which will spend the funds.
342    * @param _value The amount of tokens to be spent.
343    */
344   function approve(address _spender, uint256 _value) public returns (bool) {
345     allowed[msg.sender][_spender] = _value;
346     emit Approval(msg.sender, _spender, _value);
347     return true;
348   }
349 
350   /**
351    * @dev Function to check the amount of tokens that an owner allowed to a spender.
352    * @param _owner address The address which owns the funds.
353    * @param _spender address The address which will spend the funds.
354    * @return A uint256 specifying the amount of tokens still available for the spender.
355    */
356   function allowance(address _owner, address _spender) public view returns (uint256) {
357     return allowed[_owner][_spender];
358   }
359 
360   /**
361    * @dev Increase the amount of tokens that an owner allowed to a spender.
362    *
363    * approve should be called when allowed[_spender] == 0. To increment
364    * allowed value is better to use this function to avoid 2 calls (and wait until
365    * the first transaction is mined)
366    * From MonolithDAO Token.sol
367    * @param _spender The address which will spend the funds.
368    * @param _addedValue The amount of tokens to increase the allowance by.
369    */
370   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
371     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
372     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376   /**
377    * @dev Decrease the amount of tokens that an owner allowed to a spender.
378    *
379    * approve should be called when allowed[_spender] == 0. To decrement
380    * allowed value is better to use this function to avoid 2 calls (and wait until
381    * the first transaction is mined)
382    * From MonolithDAO Token.sol
383    * @param _spender The address which will spend the funds.
384    * @param _subtractedValue The amount of tokens to decrease the allowance by.
385    */
386   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
387     uint oldValue = allowed[msg.sender][_spender];
388     if (_subtractedValue > oldValue) {
389       allowed[msg.sender][_spender] = 0;
390     } else {
391       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
392     }
393     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
394     return true;
395   }
396 
397 }
398 
399 
400 /**
401  * @title Standard Burnable Token
402  * @dev Adds burnFrom method to ERC20 implementations
403  */
404 contract StandardBurnableToken is BurnableToken, StandardToken {
405 
406   /**
407    * @dev Burns a specific amount of tokens from the target address and decrements allowance
408    * @param _from address The address which you want to send tokens from
409    * @param _value uint256 The amount of token to be burned
410    */
411   function burnFrom(address _from, uint256 _value) public {
412     require(_value <= allowed[_from][msg.sender]);
413     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
414     // this function needs to emit an event with the updated approval.
415     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
416     _burn(_from, _value);
417   }
418 }
419  // Standard burnable token implementation from Zeppelin
420 
421 
422 
423 
424 
425 
426 
427 
428 
429 /**
430  * @title Pausable
431  * @dev Base contract which allows children to implement an emergency stop mechanism.
432  */
433 contract Pausable is Ownable {
434   event Pause();
435   event Unpause();
436 
437   bool public paused = false;
438 
439 
440   /**
441    * @dev Modifier to make a function callable only when the contract is not paused.
442    */
443   modifier whenNotPaused() {
444     require(!paused);
445     _;
446   }
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is paused.
450    */
451   modifier whenPaused() {
452     require(paused);
453     _;
454   }
455 
456   /**
457    * @dev called by the owner to pause, triggers stopped state
458    */
459   function pause() onlyOwner whenNotPaused public {
460     paused = true;
461     emit Pause();
462   }
463 
464   /**
465    * @dev called by the owner to unpause, returns to normal state
466    */
467   function unpause() onlyOwner whenPaused public {
468     paused = false;
469     emit Unpause();
470   }
471 }
472 
473 
474 
475 /**
476  * @title Pausable token
477  * @dev StandardToken modified with pausable transfers.
478  **/
479 contract PausableToken is StandardToken, Pausable {
480 
481   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
482     return super.transfer(_to, _value);
483   }
484 
485   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
486     return super.transferFrom(_from, _to, _value);
487   }
488 
489   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
490     return super.approve(_spender, _value);
491   }
492 
493   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
494     return super.increaseApproval(_spender, _addedValue);
495   }
496 
497   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
498     return super.decreaseApproval(_spender, _subtractedValue);
499   }
500 }
501  // PausableToken implementation from Zeppelin
502  // Claimable implementation from Zeppelin
503  /* Standard Claimable implementation from Zeppelin */
504 
505 interface CrowdsaleContract {
506   function isActive() public view returns(bool);
507 }
508 
509 contract BulleonToken is StandardBurnableToken, PausableToken, Claimable, CanReclaimToken {
510   /* Additional events */
511   event AddedToWhitelist(address wallet);
512   event RemoveWhitelist(address wallet);
513 
514   /* Base params */
515   string public constant name = "Bulleon"; /* solium-disable-line uppercase */
516   string public constant symbol = "BUL"; /* solium-disable-line uppercase */
517   uint8 public constant decimals = 18; /* solium-disable-line uppercase */
518   uint256 constant exchangersBalance = 39991750231582759746295 + 14715165984103328399573 + 1846107707643607869274; // YoBit + Etherdelta + IDEX
519 
520   /* Premine and start balance settings */
521   address constant premineWallet = 0x286BE9799488cA4543399c2ec964e7184077711C;
522   uint256 constant premineAmount = 178420 * (10 ** uint256(decimals));
523 
524   /* Additional params */
525   address public CrowdsaleAddress;
526   CrowdsaleContract crowdsale;
527   mapping(address=>bool) whitelist; // Users that may transfer tokens before ICO ended
528 
529   /**
530    * @dev Constructor that gives msg.sender all availabel of existing tokens.
531    */
532   constructor() public {
533     totalSupply_ = 7970000 * (10 ** uint256(decimals));
534     balances[msg.sender] = totalSupply_;
535     transfer(premineWallet, premineAmount.add(exchangersBalance));
536 
537     addToWhitelist(msg.sender);
538     addToWhitelist(premineWallet);
539     paused = true; // Lock token at start
540   }
541 
542   /**
543    * @dev Sets crowdsale contract address (used for checking ICO status)
544    */
545   function setCrowdsaleAddress(address _ico) public onlyOwner {
546     CrowdsaleAddress = _ico;
547     crowdsale = CrowdsaleContract(CrowdsaleAddress);
548     addToWhitelist(CrowdsaleAddress);
549   }
550 
551   /**
552    * @dev called by user the to pause, triggers stopped state
553    * not actualy used
554    */
555   function pause() onlyOwner whenNotPaused public {
556     revert();
557   }
558 
559   /**
560    * @dev Modifier to make a function callable only when the contract is not paused or when sender is whitelisted.
561    */
562   modifier whenNotPaused() {
563     require(!paused || whitelist[msg.sender]);
564     _;
565   }
566 
567   /**
568    * @dev called by the user to unpause at ICO end or by owner, returns token to unlocked state
569    */
570   function unpause() whenPaused public {
571     require(!crowdsale.isActive() || msg.sender == owner); // Checks that ICO is ended
572     paused = false;
573     emit Unpause();
574   }
575 
576   /**
577    * @dev Add wallet address to transfer whitelist (may transfer tokens before ICO ended)
578    */
579   function addToWhitelist(address wallet) public onlyOwner {
580     require(!whitelist[wallet]);
581     whitelist[wallet] = true;
582     emit AddedToWhitelist(wallet);
583   }
584 
585   /**
586    * @dev Delete wallet address to transfer whitelist (may transfer tokens before ICO ended)
587    */
588   function delWhitelist(address wallet) public onlyOwner {
589     require(whitelist[wallet]);
590     whitelist[wallet] = false;
591     emit RemoveWhitelist(wallet);
592   }
593 
594   // DELETE IT!
595   function kill() onlyOwner {
596     selfdestruct(owner);
597   }
598 }
599 
600 
601 
602 contract BulleonCrowdsale is Claimable, CanReclaimToken {
603     using SafeMath for uint256;
604     /* Additionals events */
605     event AddedToBlacklist(address wallet);
606     event RemovedFromBlacklist(address wallet);
607 
608     /* Infomational vars */
609     string public version = "2.0";
610 
611     /* ICO params */
612     address public withdrawWallet = 0xAd74Bd38911fE4C19c95D14b5733372c3978C2D9;
613     uint256 public endDate = 1546300799; // Monday, 31-Dec-18 23:59:59 UTC
614     BulleonToken public rewardToken;
615     // Tokens rate (BUL / ETH) on stage
616     uint256[] public tokensRate = [
617       1000, // stage 1
618       800, // stage 2
619       600, // stage 3
620       400, // stage 4
621       200, // stage 5
622       100, // stage 6
623       75, // stage 7
624       50, // stage 8
625       25, // stage 9
626       10 // stage 10
627     ];
628     // Tokens cap (max sold tokens) on stage
629     uint256[] public tokensCap = [
630       760000, // stage 1
631       760000, // stage 2
632       760000, // stage 3
633       760000, // stage 4
634       760000, // stage 5
635       760000, // stage 6
636       760000, // stage 7
637       760000, // stage 8
638       760000, // stage 9
639       759000  // stage 10
640     ];
641     mapping(address=>bool) public isBlacklisted;
642 
643     /* ICO stats */
644     uint256 public totalSold = 329406072304513072322000; // ! Update on publish
645     uint256 public soldOnStage = 329406072304513072322000; // ! Update on publish
646     uint8 public currentStage = 0;
647 
648     /* Bonus params */
649     uint256 public bonus = 0;
650     uint256 constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
651     mapping(address=>uint256) public investmentsOf; // Investments made by wallet
652 
653    /**
654     * @dev Returns crowdsale status (if active returns true).
655     */
656     function isActive() public view returns (bool) {
657       return !(availableTokens() == 0 || now > endDate);
658     }
659 
660     /* ICO stats methods */
661 
662     /**
663      * @dev Returns tokens amount cap for current stage.
664      */
665     function stageCap() public view returns(uint256) {
666       return tokensCap[currentStage].mul(1 ether);
667     }
668 
669     /**
670      * @dev Returns tokens amount available to sell at current stage.
671      */
672     function availableOnStage() public view returns(uint256) {
673         return stageCap().sub(soldOnStage) > availableTokens() ? availableTokens() : stageCap().sub(soldOnStage);
674     }
675 
676     /**
677      * @dev Returns base rate (BUL/ETH) of current stage.
678      */
679     function stageBaseRate() public view returns(uint256) {
680       return tokensRate[currentStage];
681     }
682 
683     /**
684      * @dev Returns actual (base + bonus %) rate (BUL/ETH) of current stage.
685      */
686     function stageRate() public view returns(uint256) {
687       return stageBaseRate().mul(BONUS_COEFF.add(getBonus())).div(BONUS_COEFF);
688     }
689 
690     constructor(address token) public {
691         require(token != 0x0);
692         rewardToken = BulleonToken(token);
693     }
694 
695     function () public payable {
696         buyTokens(msg.sender);
697     }
698 
699     /**
700      * @dev Main token puchase function
701      */
702     function buyTokens(address beneficiary) public payable {
703       bool validPurchase = beneficiary != 0x0 && msg.value != 0 && !isBlacklisted[msg.sender];
704       uint256 currentTokensAmount = availableTokens();
705       // Check that ICO is Active and purchase tx is valid
706       require(isActive() && validPurchase);
707       investmentsOf[msg.sender] = investmentsOf[msg.sender].add(msg.value);
708       uint256 boughtTokens;
709       uint256 refundAmount = 0;
710 
711       // Calculate tokens and refund amount at multiple stage
712       uint256[2] memory tokensAndRefund = calcMultiStage();
713       boughtTokens = tokensAndRefund[0];
714       refundAmount = tokensAndRefund[1];
715       // Check that bought tokens amount less then current
716       require(boughtTokens <= currentTokensAmount);
717 
718       totalSold = totalSold.add(boughtTokens); // Increase stats variable
719 
720       if(soldOnStage >= stageCap()) {
721         toNextStage();
722       }
723 
724       rewardToken.transfer(beneficiary, boughtTokens);
725 
726       if (refundAmount > 0)
727           refundMoney(refundAmount);
728 
729       withdrawFunds(this.balance);
730     }
731 
732     /**
733      * @dev Forcibility withdraw contract ETH balance.
734      */
735     function forceWithdraw() public onlyOwner {
736       withdrawFunds(this.balance);
737     }
738 
739     /**
740      * @dev Calculate tokens amount and refund amount at purchase procedure.
741      */
742     function calcMultiStage() internal returns(uint256[2]) {
743       uint256 stageBoughtTokens;
744       uint256 undistributedAmount = msg.value;
745       uint256 _boughtTokens = 0;
746       uint256 undistributedTokens = availableTokens();
747 
748       while(undistributedAmount > 0 && undistributedTokens > 0) {
749         bool needNextStage = false;
750 
751         stageBoughtTokens = getTokensAmount(undistributedAmount);
752 
753         if (stageBoughtTokens > availableOnStage()) {
754           stageBoughtTokens = availableOnStage();
755           needNextStage = true;
756         }
757 
758         _boughtTokens = _boughtTokens.add(stageBoughtTokens);
759         undistributedTokens = undistributedTokens.sub(stageBoughtTokens);
760         undistributedAmount = undistributedAmount.sub(getTokensCost(stageBoughtTokens));
761         soldOnStage = soldOnStage.add(stageBoughtTokens);
762         if (needNextStage)
763           toNextStage();
764       }
765       return [_boughtTokens,undistributedAmount];
766     }
767 
768     /**
769      * @dev Sets withdraw wallet address. (called by owner)
770      */
771     function setWithdraw(address _withdrawWallet) public onlyOwner {
772         require(_withdrawWallet != 0x0);
773         withdrawWallet = _withdrawWallet;
774     }
775 
776     /**
777      * @dev Make partical refund at purchasing procedure
778      */
779     function refundMoney(uint256 refundAmount) internal {
780       msg.sender.transfer(refundAmount);
781     }
782 
783     /**
784      * @dev Give owner ability to burn some tokens amount at ICO contract
785      */
786     function burnTokens(uint256 amount) public onlyOwner {
787       rewardToken.burn(amount);
788     }
789 
790     /**
791      * @dev Returns costs of given tokens amount
792      */
793     function getTokensCost(uint256 _tokensAmount) public view returns(uint256) {
794       return _tokensAmount.div(stageRate());
795     }
796 
797     function getTokensAmount(uint256 _amountInWei) public view returns(uint256) {
798       return _amountInWei.mul(stageRate());
799     }
800 
801 
802 
803     /**
804      * @dev Switch contract to next stage and reset stage stats
805      */
806     function toNextStage() internal {
807         if (
808           currentStage < tokensRate.length &&
809           currentStage < tokensCap.length
810         ) {
811           currentStage++;
812           soldOnStage = 0;
813         }
814     }
815 
816     function availableTokens() public view returns(uint256) {
817         return rewardToken.balanceOf(address(this));
818     }
819 
820     function withdrawFunds(uint256 amount) internal {
821         withdrawWallet.transfer(amount);
822     }
823 
824     function kill() public onlyOwner {
825       require(!isActive()); // Check that ICO is Ended (!= Active)
826       rewardToken.burn(availableTokens()); // Burn tokens
827       selfdestruct(owner); // Destruct ICO contract
828     }
829 
830     function setBonus(uint256 bonusAmount) public onlyOwner {
831       require(
832         bonusAmount < 100 * BONUS_COEFF &&
833         bonusAmount >= 0
834       );
835       bonus = bonusAmount;
836     }
837 
838     function getBonus() public view returns(uint256) {
839       uint256 _bonus = bonus;
840       uint256 investments = investmentsOf[msg.sender];
841       if(investments > 50 ether)
842         _bonus += 250; // 25%
843       else
844       if(investments > 20 ether)
845         _bonus += 200; // 20%
846       else
847       if(investments > 10 ether)
848         _bonus += 150; // 15%
849       else
850       if(investments > 5 ether)
851         _bonus += 100; // 10%
852       else
853       if(investments > 1 ether)
854         _bonus += 50; // 5%
855 
856       return _bonus;
857     }
858 
859     function addBlacklist(address wallet) public onlyOwner {
860       require(!isBlacklisted[wallet]);
861       isBlacklisted[wallet] = true;
862       emit AddedToBlacklist(wallet);
863     }
864 
865     function delBlacklist(address wallet) public onlyOwner {
866       require(isBlacklisted[wallet]);
867       isBlacklisted[wallet] = false;
868       emit RemovedFromBlacklist(wallet);
869     }
870     
871 }