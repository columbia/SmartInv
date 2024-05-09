1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 
58 
59 
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     if (a == 0) {
72       return 0;
73     }
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106  /* Standard SafeMath implementation from Zeppelin */
107 
108 
109 
110 
111 
112 
113 /**
114  * @title Claimable
115  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
116  * This allows the new owner to accept the transfer.
117  */
118 contract Claimable is Ownable {
119   address public pendingOwner;
120 
121   /**
122    * @dev Modifier throws if called by any account other than the pendingOwner.
123    */
124   modifier onlyPendingOwner() {
125     require(msg.sender == pendingOwner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to set the pendingOwner address.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) onlyOwner public {
134     pendingOwner = newOwner;
135   }
136 
137   /**
138    * @dev Allows the pendingOwner address to finalize the transfer.
139    */
140   function claimOwnership() onlyPendingOwner public {
141     emit OwnershipTransferred(owner, pendingOwner);
142     owner = pendingOwner;
143     pendingOwner = address(0);
144   }
145 }
146  /* Standard Claimable implementation from Zeppelin */
147 
148 
149 
150 
151 
152 
153 
154 
155 
156 
157 
158 
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256) {
199     return balances[_owner];
200   }
201 
202 }
203 
204 
205 
206 /**
207  * @title Burnable Token
208  * @dev Token that can be irreversibly burned (destroyed).
209  */
210 contract BurnableToken is BasicToken {
211 
212   event Burn(address indexed burner, uint256 value);
213 
214   /**
215    * @dev Burns a specific amount of tokens.
216    * @param _value The amount of token to be burned.
217    */
218   function burn(uint256 _value) public {
219     _burn(msg.sender, _value);
220   }
221 
222   function _burn(address _who, uint256 _value) internal {
223     require(_value <= balances[_who]);
224     // no need to require value <= totalSupply, since that would imply the
225     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
226 
227     balances[_who] = balances[_who].sub(_value);
228     totalSupply_ = totalSupply_.sub(_value);
229     emit Burn(_who, _value);
230     emit Transfer(_who, address(0), _value);
231   }
232 }
233 
234 
235 
236 
237 
238 
239 
240 
241 
242 /**
243  * @title ERC20 interface
244  * @dev see https://github.com/ethereum/EIPs/issues/20
245  */
246 contract ERC20 is ERC20Basic {
247   function allowance(address owner, address spender) public view returns (uint256);
248   function transferFrom(address from, address to, uint256 value) public returns (bool);
249   function approve(address spender, uint256 value) public returns (bool);
250   event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 
254 
255 /**
256  * @title Standard ERC20 token
257  *
258  * @dev Implementation of the basic standard token.
259  * @dev https://github.com/ethereum/EIPs/issues/20
260  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
261  */
262 contract StandardToken is ERC20, BasicToken {
263 
264   mapping (address => mapping (address => uint256)) internal allowed;
265 
266 
267   /**
268    * @dev Transfer tokens from one address to another
269    * @param _from address The address which you want to send tokens from
270    * @param _to address The address which you want to transfer to
271    * @param _value uint256 the amount of tokens to be transferred
272    */
273   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
274     require(_to != address(0));
275     require(_value <= balances[_from]);
276     require(_value <= allowed[_from][msg.sender]);
277 
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     emit Transfer(_from, _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    *
288    * Beware that changing an allowance with this method brings the risk that someone may use both the old
289    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
290    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
291    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292    * @param _spender The address which will spend the funds.
293    * @param _value The amount of tokens to be spent.
294    */
295   function approve(address _spender, uint256 _value) public returns (bool) {
296     allowed[msg.sender][_spender] = _value;
297     emit Approval(msg.sender, _spender, _value);
298     return true;
299   }
300 
301   /**
302    * @dev Function to check the amount of tokens that an owner allowed to a spender.
303    * @param _owner address The address which owns the funds.
304    * @param _spender address The address which will spend the funds.
305    * @return A uint256 specifying the amount of tokens still available for the spender.
306    */
307   function allowance(address _owner, address _spender) public view returns (uint256) {
308     return allowed[_owner][_spender];
309   }
310 
311   /**
312    * @dev Increase the amount of tokens that an owner allowed to a spender.
313    *
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _addedValue The amount of tokens to increase the allowance by.
320    */
321   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
322     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    *
330    * approve should be called when allowed[_spender] == 0. To decrement
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _subtractedValue The amount of tokens to decrease the allowance by.
336    */
337   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
338     uint oldValue = allowed[msg.sender][_spender];
339     if (_subtractedValue > oldValue) {
340       allowed[msg.sender][_spender] = 0;
341     } else {
342       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
343     }
344     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345     return true;
346   }
347 
348 }
349 
350 
351 /**
352  * @title Standard Burnable Token
353  * @dev Adds burnFrom method to ERC20 implementations
354  */
355 contract StandardBurnableToken is BurnableToken, StandardToken {
356 
357   /**
358    * @dev Burns a specific amount of tokens from the target address and decrements allowance
359    * @param _from address The address which you want to send tokens from
360    * @param _value uint256 The amount of token to be burned
361    */
362   function burnFrom(address _from, uint256 _value) public {
363     require(_value <= allowed[_from][msg.sender]);
364     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
365     // this function needs to emit an event with the updated approval.
366     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367     _burn(_from, _value);
368   }
369 }
370  // Standard burnable token implementation from Zeppelin
371 
372 
373 
374 
375 
376 
377 
378 
379 
380 /**
381  * @title Pausable
382  * @dev Base contract which allows children to implement an emergency stop mechanism.
383  */
384 contract Pausable is Ownable {
385   event Pause();
386   event Unpause();
387 
388   bool public paused = false;
389 
390 
391   /**
392    * @dev Modifier to make a function callable only when the contract is not paused.
393    */
394   modifier whenNotPaused() {
395     require(!paused);
396     _;
397   }
398 
399   /**
400    * @dev Modifier to make a function callable only when the contract is paused.
401    */
402   modifier whenPaused() {
403     require(paused);
404     _;
405   }
406 
407   /**
408    * @dev called by the owner to pause, triggers stopped state
409    */
410   function pause() onlyOwner whenNotPaused public {
411     paused = true;
412     emit Pause();
413   }
414 
415   /**
416    * @dev called by the owner to unpause, returns to normal state
417    */
418   function unpause() onlyOwner whenPaused public {
419     paused = false;
420     emit Unpause();
421   }
422 }
423 
424 
425 
426 /**
427  * @title Pausable token
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 contract PausableToken is StandardToken, Pausable {
431 
432   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
433     return super.transfer(_to, _value);
434   }
435 
436   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
437     return super.transferFrom(_from, _to, _value);
438   }
439 
440   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
441     return super.approve(_spender, _value);
442   }
443 
444   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
445     return super.increaseApproval(_spender, _addedValue);
446   }
447 
448   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
449     return super.decreaseApproval(_spender, _subtractedValue);
450   }
451 }
452  // PausableToken implementation from Zeppelin
453  // Claimable implementation from Zeppelin
454 
455 interface CrowdsaleContract {
456   function isActive() public view returns(bool);
457 }
458 
459 contract BulleonToken is StandardBurnableToken, PausableToken, Claimable {
460   /* Additional events */
461   event AddedToWhitelist(address wallet);
462   event RemoveWhitelist(address wallet);
463 
464   /* Base params */
465   string public constant name = "Bulleon"; /* solium-disable-line uppercase */
466   string public constant symbol = "BUL"; /* solium-disable-line uppercase */
467   uint8 public constant decimals = 18; /* solium-disable-line uppercase */
468   uint256 constant exchangersBalance = 39991750231582759746295 + 14715165984103328399573 + 1846107707643607869274; // YoBit + Etherdelta + IDEX
469 
470   /* Premine and start balance settings */
471   address constant premineWallet = 0x286BE9799488cA4543399c2ec964e7184077711C;
472   uint256 constant premineAmount = 178420 * (10 ** uint256(decimals));
473 
474   /* Additional params */
475   address public CrowdsaleAddress;
476   CrowdsaleContract crowdsale;
477   mapping(address=>bool) whitelist; // Users that may transfer tokens before ICO ended
478 
479   /**
480    * @dev Constructor that gives msg.sender all availabel of existing tokens.
481    */
482   constructor() public {
483     totalSupply_ = 7970000 * (10 ** uint256(decimals));
484     balances[msg.sender] = totalSupply_;
485     transfer(premineWallet, premineAmount.add(exchangersBalance));
486 
487     addToWhitelist(msg.sender);
488     addToWhitelist(premineWallet);
489     paused = true; // Lock token at start
490   }
491 
492   /**
493    * @dev Sets crowdsale contract address (used for checking ICO status)
494    */
495   function setCrowdsaleAddress(address _ico) public onlyOwner {
496     CrowdsaleAddress = _ico;
497     crowdsale = CrowdsaleContract(CrowdsaleAddress);
498     addToWhitelist(CrowdsaleAddress);
499   }
500 
501   /**
502    * @dev called by user the to pause, triggers stopped state
503    * not actualy used
504    */
505   function pause() onlyOwner whenNotPaused public {
506     revert();
507   }
508 
509   /**
510    * @dev Modifier to make a function callable only when the contract is not paused or when sender is whitelisted.
511    */
512   modifier whenNotPaused() {
513     require(!paused || whitelist[msg.sender]);
514     _;
515   }
516 
517   /**
518    * @dev called by the user to unpause at ICO end or by owner, returns token to unlocked state
519    */
520   function unpause() whenPaused public {
521     require(!crowdsale.isActive() || msg.sender == owner); // Checks that ICO is ended
522     paused = false;
523     emit Unpause();
524   }
525 
526   /**
527    * @dev Add wallet address to transfer whitelist (may transfer tokens before ICO ended)
528    */
529   function addToWhitelist(address wallet) public onlyOwner {
530     require(!whitelist[wallet]);
531     whitelist[wallet] = true;
532     emit AddedToWhitelist(wallet);
533   }
534 
535   /**
536    * @dev Delete wallet address to transfer whitelist (may transfer tokens before ICO ended)
537    */
538   function delWhitelist(address wallet) public onlyOwner {
539     require(whitelist[wallet]);
540     whitelist[wallet] = false;
541     emit RemoveWhitelist(wallet);
542   }
543 }
544  /* Bulleon Token Contract */
545 
546 
547 contract BulleonCrowdsale is Claimable {
548     using SafeMath for uint256;
549     /* Additionals events */
550     event AddedToBlacklist(address wallet);
551     event RemovedFromBlacklist(address wallet);
552     event Log(uint256 value);
553 
554     /* Infomational vars */
555     string public name = "Bulleon Crowdsale";
556     string public version = "2.0";
557 
558     /* ICO params */
559     address public withdrawWallet = 0xAd74Bd38911fE4C19c95D14b5733372c3978C2D9;
560     uint256 public endDate = 1546300799; // Monday, 31-Dec-18 23:59:59 UTC
561     BulleonToken public rewardToken;
562     // Tokens rate (BUL / ETH) on stage
563     uint256[] public tokensRate = [
564       1000, // stage 1
565       800, // stage 2
566       600, // stage 3
567       400, // stage 4
568       200, // stage 5
569       100, // stage 6
570       75, // stage 7
571       50, // stage 8
572       25, // stage 9
573       10 // stage 10
574     ];
575     // Tokens cap (max sold tokens) on stage
576     uint256[] public tokensCap = [
577       760000, // stage 1
578       760000, // stage 2
579       760000, // stage 3
580       760000, // stage 4
581       760000, // stage 5
582       760000, // stage 6
583       760000, // stage 7
584       760000, // stage 8
585       760000, // stage 9
586       759000  // stage 10
587     ];
588     mapping(address=>bool) public isBlacklisted;
589 
590     /* ICO stats */
591     uint256 public totalSold = 329406072304513072322000; // ! Update on publish
592     uint256 public soldOnStage = 329406072304513072322000; // ! Update on publish
593     uint8 public currentStage = 0;
594 
595     /* Bonus params */
596     uint256 public bonus = 0;
597     uint256 constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
598     mapping(address=>uint256) public investmentsOf; // Investments made by wallet
599 
600 
601 
602    /**
603     * @dev Returns crowdsale status (if active returns true).
604     */
605     function isActive() public view returns (bool) {
606       return !(availableTokens() == 0 || now > endDate);
607     }
608 
609     /* ICO stats methods */
610 
611     /**
612      * @dev Returns tokens amount cap for current stage.
613      */
614     function stageCap() public view returns(uint256) {
615       return tokensCap[currentStage].mul(1 ether);
616     }
617 
618     /**
619      * @dev Returns tokens amount available to sell at current stage.
620      */
621     function availableOnStage() public view returns(uint256) {
622         return stageCap().sub(soldOnStage) > availableTokens() ? availableTokens() : stageCap().sub(soldOnStage);
623     }
624 
625     /**
626      * @dev Returns base rate (BUL/ETH) of current stage.
627      */
628     function stageBaseRate() public view returns(uint256) {
629       return tokensRate[currentStage];
630     }
631 
632     /**
633      * @dev Returns actual (base + bonus %) rate (BUL/ETH) of current stage.
634      */
635     function stageRate() public view returns(uint256) {
636       return stageBaseRate().mul(BONUS_COEFF.add(getBonus())).div(BONUS_COEFF);
637     }
638 
639     constructor(address token) public {
640         require(token != 0x0);
641         rewardToken = BulleonToken(token);
642     }
643 
644     function () payable {
645         buyTokens(msg.sender);
646     }
647 
648     /**
649      * @dev Main token puchase function
650      */
651     function buyTokens(address beneficiary) public payable {
652       bool validPurchase = beneficiary != 0x0 && msg.value != 0 && !isBlacklisted[msg.sender];
653       uint256 currentTokensAmount = availableTokens();
654       // Check that ICO is Active and purchase tx is valid
655       require(isActive() && validPurchase);
656       investmentsOf[msg.sender] = investmentsOf[msg.sender].add(msg.value);
657       uint256 boughtTokens;
658       uint256 refundAmount = 0;
659 
660       // Calculate tokens and refund amount at multiple stage
661       uint256[2] memory tokensAndRefund = calcMultiStage();
662       boughtTokens = tokensAndRefund[0];
663       refundAmount = tokensAndRefund[1];
664       // Check that bought tokens amount less then current
665       require(boughtTokens <= currentTokensAmount);
666 
667       totalSold = totalSold.add(boughtTokens); // Increase stats variable
668 
669       if(soldOnStage >= stageCap()) {
670         toNextStage();
671       }
672 
673       rewardToken.transfer(beneficiary, boughtTokens);
674 
675       if (refundAmount > 0)
676           refundMoney(refundAmount);
677 
678       withdrawFunds(this.balance);
679     }
680 
681     /**
682      * @dev Forcibility withdraw contract ETH balance.
683      */
684     function forceWithdraw() public onlyOwner {
685       withdrawFunds(this.balance);
686     }
687 
688     /**
689      * @dev Calculate tokens amount and refund amount at purchase procedure.
690      */
691     function calcMultiStage() internal returns(uint256[2]) {
692       uint256 stageBoughtTokens;
693       uint256 undistributedAmount = msg.value;
694       uint256 _boughtTokens = 0;
695       uint256 undistributedTokens = availableTokens();
696 
697       while(undistributedAmount > 0 && undistributedTokens > 0) {
698         bool needNextStage = false;
699 
700         stageBoughtTokens = getTokensAmount(undistributedAmount);
701 
702         if (stageBoughtTokens > availableOnStage()) {
703           stageBoughtTokens = availableOnStage();
704           needNextStage = true;
705         }
706 
707         _boughtTokens = _boughtTokens.add(stageBoughtTokens);
708         undistributedTokens = undistributedTokens.sub(stageBoughtTokens);
709         undistributedAmount = undistributedAmount.sub(getTokensCost(stageBoughtTokens));
710         soldOnStage = soldOnStage.add(stageBoughtTokens);
711         if (needNextStage)
712           toNextStage();
713       }
714       return [_boughtTokens,undistributedAmount];
715     }
716 
717     /**
718      * @dev Sets withdraw wallet address. (called by owner)
719      */
720     function setWithdraw(address _withdrawWallet) public onlyOwner {
721         require(_withdrawWallet != 0x0);
722         withdrawWallet = _withdrawWallet;
723     }
724 
725     /**
726      * @dev Make partical refund at purchasing procedure
727      */
728     function refundMoney(uint256 refundAmount) internal {
729       msg.sender.transfer(refundAmount);
730     }
731 
732     /**
733      * @dev Give owner ability to burn some tokens amount at ICO contract
734      */
735     function burnTokens(uint256 amount) public onlyOwner {
736       rewardToken.burn(amount);
737     }
738 
739     /**
740      * @dev Returns costs of given tokens amount
741      */
742     function getTokensCost(uint256 _tokensAmount) public view returns(uint256) {
743       return _tokensAmount.div(stageRate());
744     }
745 
746     function getTokensAmount(uint256 _amountInWei) public view returns(uint256) {
747       return _amountInWei.mul(stageRate());
748     }
749 
750 
751 
752     /**
753      * @dev Switch contract to next stage and reset stage stats
754      */
755     function toNextStage() internal {
756         if (
757           currentStage < tokensRate.length &&
758           currentStage < tokensCap.length
759         ) {
760           currentStage++;
761           soldOnStage = 0;
762         }
763     }
764 
765     function availableTokens() public view returns(uint256) {
766         return rewardToken.balanceOf(address(this));
767     }
768 
769     function withdrawFunds(uint256 amount) internal {
770         withdrawWallet.transfer(amount);
771     }
772 
773     function kill() public onlyOwner {
774       require(!isActive()); // Check that ICO is Ended (!= Active)
775       rewardToken.burn(availableTokens()); // Burn tokens
776       selfdestruct(owner); // Destruct ICO contract
777     }
778 
779     function setBonus(uint256 bonusAmount) public onlyOwner {
780       require(
781         bonusAmount < 100 * BONUS_COEFF &&
782         bonusAmount >= 0
783       );
784       bonus = bonusAmount;
785     }
786 
787     function getBonus() public view returns(uint256) {
788       uint256 _bonus = bonus;
789       uint256 investments = investmentsOf[msg.sender];
790       if(investments > 50 ether)
791         _bonus += 250; // 25%
792       else
793       if(investments > 20 ether)
794         _bonus += 200; // 20%
795       else
796       if(investments > 10 ether)
797         _bonus += 150; // 15%
798       else
799       if(investments > 5 ether)
800         _bonus += 100; // 10%
801       else
802       if(investments > 1 ether)
803         _bonus += 50; // 5%
804 
805       return _bonus;
806     }
807 
808     function addBlacklist(address wallet) public onlyOwner {
809       require(!isBlacklisted[wallet]);
810       isBlacklisted[wallet] = true;
811       emit AddedToBlacklist(wallet);
812     }
813 
814     function delBlacklist(address wallet) public onlyOwner {
815       require(isBlacklisted[wallet]);
816       isBlacklisted[wallet] = false;
817       emit RemovedFromBlacklist(wallet);
818     }
819 }