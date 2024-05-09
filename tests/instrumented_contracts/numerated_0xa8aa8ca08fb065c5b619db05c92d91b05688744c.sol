1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/token/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (a == 0) {
97       return 0;
98     }
99 
100     c = a * b;
101     assert(c / a == b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 a, uint256 b) internal pure returns (uint256) {
109     // assert(b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = a / b;
111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112     return a / b;
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
126   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
127     c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 }
132 
133 // File: contracts/token/BasicToken.sol
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
144   uint256 totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: contracts/token/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender)
187     public view returns (uint256);
188 
189   function transferFrom(address from, address to, uint256 value)
190     public returns (bool);
191 
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: contracts/token/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_to != address(0));
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts/MintableToken.sol
322 
323 contract MintableToken is StandardToken, Ownable {
324 
325   event Mint(address indexed to, uint256 amount);
326 
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331   address public saleAgent;
332 
333   mapping(address => bool) public unlockedAddressesDuringITO;
334 
335   address[] public tokenHolders;
336 
337   modifier onlyOwnerOrSaleAgent() {
338     require(msg.sender == saleAgent || msg.sender == owner);
339     _;
340   }
341 
342   function unlockAddressDuringITO(address addressToUnlock) public onlyOwnerOrSaleAgent {
343     unlockedAddressesDuringITO[addressToUnlock] = true;
344   }
345 
346   function lockAddressDuringITO(address addressToUnlock) public onlyOwnerOrSaleAgent {
347     unlockedAddressesDuringITO[addressToUnlock] = false;
348   }
349 
350   modifier notLocked(address sender) {
351     require(mintingFinished ||
352             sender == saleAgent || 
353             sender == owner ||
354             (!mintingFinished && unlockedAddressesDuringITO[sender]));
355     _;
356   }
357 
358   function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {
359     saleAgent = newSaleAgnet;
360   }
361 
362   function mint(address _to, uint256 _amount) public returns (bool) {
363     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
364     if(balances[_to] == 0) tokenHolders.push(_to);
365     totalSupply_ = totalSupply_.add(_amount);
366     balances[_to] = balances[_to].add(_amount);
367     emit Mint(_to, _amount);
368     emit Transfer(address(0), _to, _amount);
369     return true;
370   }
371 
372   /**
373    * @dev Function to stop minting new tokens.
374    * @return True if the operation was successful.
375    */
376   function finishMinting() public returns (bool) {
377     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
378     mintingFinished = true;
379     emit MintFinished();
380     return true;
381   }
382 
383   function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {
384     return super.transfer(_to, _value);
385   }
386 
387   function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {
388     return super.transferFrom(from, to, value);
389   }
390 
391 }
392 
393 // File: contracts/ReceivingContractCallback.sol
394 
395 contract ReceivingContractCallback {
396 
397   function tokenFallback(address _from, uint _value) public;
398 
399 }
400 
401 // File: contracts/Token.sol
402 
403 contract Token is MintableToken {
404 
405   string public constant name = "AutomateToken";
406 
407   string public constant symbol = "AMT";
408 
409   uint32 public constant decimals = 18;
410 
411   mapping(address => bool)  public registeredCallbacks;
412 
413   function transfer(address _to, uint256 _value) public returns (bool) {
414     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
415   }
416 
417   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
418     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
419   }
420 
421   function registerCallback(address callback) public onlyOwner {
422     registeredCallbacks[callback] = true;
423   }
424 
425   function deregisterCallback(address callback) public onlyOwner {
426     registeredCallbacks[callback] = false;
427   }
428 
429   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
430     if (result && registeredCallbacks[to]) {
431       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
432       targetCallback.tokenFallback(from, value);
433     }
434     return result;
435   }
436 
437 }
438 
439 // File: contracts/PercentRateProvider.sol
440 
441 contract PercentRateProvider is Ownable {
442 
443   uint public percentRate = 100;
444 
445   function setPercentRate(uint newPercentRate) public onlyOwner {
446     percentRate = newPercentRate;
447   }
448 
449 }
450 
451 // File: contracts/WalletProvider.sol
452 
453 contract WalletProvider is Ownable {
454 
455   address public wallet;
456 
457   function setWallet(address newWallet) public onlyOwner {
458     wallet = newWallet;
459   }
460 
461 }
462 
463 // File: contracts/InvestedProvider.sol
464 
465 contract InvestedProvider is Ownable {
466 
467   uint public invested;
468 
469 }
470 
471 // File: contracts/RetrieveTokensFeature.sol
472 
473 contract RetrieveTokensFeature is Ownable {
474 
475   function retrieveTokens(address to, address anotherToken) public onlyOwner {
476     ERC20 alienToken = ERC20(anotherToken);
477     alienToken.transfer(to, alienToken.balanceOf(this));
478   }
479 
480 }
481 
482 // File: contracts/TokenProvider.sol
483 
484 contract TokenProvider is Ownable {
485 
486   MintableToken public token;
487 
488   function setToken(address newToken) public onlyOwner {
489     token = MintableToken(newToken);
490   }
491 
492 }
493 
494 // File: contracts/MintTokensInterface.sol
495 
496 contract MintTokensInterface is TokenProvider {
497 
498   function mintTokens(address to, uint tokens) internal;
499 
500 }
501 
502 // File: contracts/MintTokensFeature.sol
503 
504 contract MintTokensFeature is MintTokensInterface {
505 
506   function mintTokens(address to, uint tokens) internal {
507     token.mint(to, tokens);
508   }
509 
510   function mintTokensBatch(uint amount, address[] to) public onlyOwner {
511     for(uint i = 0; i < to.length; i++) {
512       token.mint(to[i], amount);
513     }
514   }
515 
516 }
517 
518 // File: contracts/CommonSale.sol
519 
520 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature, MintTokensFeature {
521 
522   using SafeMath for uint;
523 
524   address public directMintAgent;
525 
526   uint public price;
527 
528   uint public start;
529 
530   uint public minInvestedLimit;
531 
532   uint public hardcap;
533 
534   modifier isUnderHardcap() {
535     require(invested <= hardcap);
536     _;
537   }
538 
539   function setHardcap(uint newHardcap) public onlyOwner {
540     hardcap = newHardcap;
541   }
542 
543   modifier onlyDirectMintAgentOrOwner() {
544     require(directMintAgent == msg.sender || owner == msg.sender);
545     _;
546   }
547 
548   modifier minInvestLimited(uint value) {
549     require(value >= minInvestedLimit);
550     _;
551   }
552 
553   function setStart(uint newStart) public onlyOwner {
554     start = newStart;
555   }
556 
557   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
558     minInvestedLimit = newMinInvestedLimit;
559   }
560 
561   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
562     directMintAgent = newDirectMintAgent;
563   }
564 
565   function setPrice(uint newPrice) public onlyOwner {
566     price = newPrice;
567   }
568 
569   function setToken(address newToken) public onlyOwner {
570     token = MintableToken(newToken);
571   }
572 
573   function calculateTokens(uint _invested) internal returns(uint);
574 
575   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
576     mintTokens(to, tokens);
577   }
578 
579   function endSaleDate() public view returns(uint);
580 
581   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner {
582     updateInvested(_invested);
583     mintTokensByETH(to, _invested);
584   }
585 
586   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
587     uint tokens = calculateTokens(_invested);
588     mintTokens(to, tokens);
589     return tokens;
590   }
591 
592   function updateInvested(uint value) internal {
593     invested = invested.add(value);
594   }
595 
596   function fallback() internal minInvestLimited(msg.value) returns(uint) {
597     require(now >= start && now < endSaleDate());
598     wallet.transfer(msg.value);
599     updateInvested(msg.value);
600     return mintTokensByETH(msg.sender, msg.value);
601   }
602 
603   function () public payable {
604     fallback();
605   }
606 
607 }
608 
609 // File: contracts/StagedCrowdsale.sol
610 
611 contract StagedCrowdsale is Ownable {
612 
613   using SafeMath for uint;
614 
615   struct Milestone {
616     uint period;
617     uint bonus;
618   }
619 
620   uint public totalPeriod;
621 
622   Milestone[] public milestones;
623 
624   function milestonesCount() public view returns(uint) {
625     return milestones.length;
626   }
627 
628   function addMilestone(uint period, uint bonus) public onlyOwner {
629     require(period > 0);
630     milestones.push(Milestone(period, bonus));
631     totalPeriod = totalPeriod.add(period);
632   }
633 
634   function removeMilestone(uint8 number) public onlyOwner {
635     require(number < milestones.length);
636     Milestone storage milestone = milestones[number];
637     totalPeriod = totalPeriod.sub(milestone.period);
638 
639     delete milestones[number];
640 
641     for (uint i = number; i < milestones.length - 1; i++) {
642       milestones[i] = milestones[i+1];
643     }
644 
645     milestones.length--;
646   }
647 
648   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
649     require(number < milestones.length);
650     Milestone storage milestone = milestones[number];
651 
652     totalPeriod = totalPeriod.sub(milestone.period);
653 
654     milestone.period = period;
655     milestone.bonus = bonus;
656 
657     totalPeriod = totalPeriod.add(period);
658   }
659 
660   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
661     require(numberAfter < milestones.length);
662 
663     totalPeriod = totalPeriod.add(period);
664 
665     milestones.length++;
666 
667     for (uint i = milestones.length - 2; i > numberAfter; i--) {
668       milestones[i + 1] = milestones[i];
669     }
670 
671     milestones[numberAfter + 1] = Milestone(period, bonus);
672   }
673 
674   function clearMilestones() public onlyOwner {
675     require(milestones.length > 0);
676     for (uint i = 0; i < milestones.length; i++) {
677       delete milestones[i];
678     }
679     milestones.length -= milestones.length;
680     totalPeriod = 0;
681   }
682 
683   function lastSaleDate(uint start) public view returns(uint) {
684     return start + totalPeriod * 1 days;
685   }
686 
687   function currentMilestone(uint start) public view returns(uint) {
688     uint previousDate = start;
689     for(uint i=0; i < milestones.length; i++) {
690       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
691         return i;
692       }
693       previousDate = previousDate.add(milestones[i].period * 1 days);
694     }
695     revert();
696   }
697 
698 }
699 
700 // File: contracts/AssembledCommonSale.sol
701 
702 contract AssembledCommonSale is StagedCrowdsale, CommonSale {
703 
704   function endSaleDate() public view returns(uint) {
705     return lastSaleDate(start);
706   }
707 
708   function calculateTokens(uint _invested) internal returns(uint) {
709     uint milestoneIndex = currentMilestone(start);
710     Milestone storage milestone = milestones[milestoneIndex];
711     uint tokens = _invested.mul(price).div(1 ether);
712     if(milestone.bonus > 0) {
713       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
714     }
715     return tokens;
716   }
717 
718 }
719 
720 // File: contracts/NextSaleAgentFeature.sol
721 
722 contract NextSaleAgentFeature is Ownable {
723 
724   address public nextSaleAgent;
725 
726   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
727     nextSaleAgent = newNextSaleAgent;
728   }
729 
730 }
731 
732 // File: contracts/FeeFeature.sol
733 
734 contract FeeFeature is CommonSale {
735 
736   uint public constant devLimit = 19500000000000000000;
737 
738   uint public devFeePaid;
739 
740   address public constant feeWallet = 0x63AC028FB29A01916C67Ed39794e5072F9e0F1Da;
741 
742   function fallback() internal minInvestLimited(msg.value) returns(uint) {
743     require(now >= start && now < endSaleDate());
744     uint toWallet = msg.value;
745     if(devFeePaid < devLimit) {
746       uint feeNeeds = devLimit.sub(devFeePaid);
747       if(feeNeeds >= toWallet) {
748         feeWallet.transfer(toWallet);
749         devFeePaid = devFeePaid.add(toWallet);
750         toWallet = 0;
751       } else {
752         feeWallet.transfer(feeNeeds);
753         devFeePaid = devFeePaid.add(feeNeeds);
754         toWallet = toWallet.sub(feeNeeds);
755       }
756     }
757     if(toWallet != 0) {
758       wallet.transfer(toWallet);
759     }
760     updateInvested(msg.value);
761     return mintTokensByETH(msg.sender, msg.value);
762   }
763 
764 }
765 
766 // File: contracts/PreITO.sol
767 
768 contract PreITO is NextSaleAgentFeature, FeeFeature, AssembledCommonSale {
769 
770   function finish() public onlyOwner {
771     token.setSaleAgent(nextSaleAgent);
772   }
773 
774 }
775 
776 // File: contracts/WalletsPercents.sol
777 
778 contract WalletsPercents is Ownable {
779 
780   address[] public wallets;
781 
782   mapping (address => uint) percents;
783 
784   function addWallet(address wallet, uint percent) public onlyOwner {
785     wallets.push(wallet);
786     percents[wallet] = percent;
787   }
788  
789   function cleanWallets() public onlyOwner {
790     wallets.length = 0;
791   }
792 
793 
794 }
795 
796 // File: contracts/ExtendedWalletsMintTokensFeature.sol
797 
798 contract ExtendedWalletsMintTokensFeature is MintTokensInterface, WalletsPercents {
799 
800   using SafeMath for uint;
801 
802   uint public percentRate = 100;
803 
804   function mintExtendedTokens() public onlyOwner {
805     uint summaryTokensPercent = 0;
806     for(uint i = 0; i < wallets.length; i++) {
807       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
808     }
809     uint mintedTokens = token.totalSupply();
810     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
811     for(uint k = 0; k < wallets.length; k++) {
812       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
813     }
814 
815   }
816 
817 }
818 
819 // File: contracts/ITO.sol
820 
821 contract ITO is ExtendedWalletsMintTokensFeature, AssembledCommonSale {
822 
823   function finish() public onlyOwner {
824     mintExtendedTokens();
825     token.finishMinting();
826   }
827 
828 }
829 
830 // File: contracts/Configurator.sol
831 
832 contract Configurator is Ownable {
833 
834   Token public token;
835 
836   PreITO public preITO;
837 
838   ITO public ito;
839 
840   function deploy() public onlyOwner {
841 
842     token = new Token();
843 
844     preITO = new PreITO();
845 
846     preITO.setWallet(0xE4cfb1d905e922a93ddcA8528ab0f87b31E9e335);
847     preITO.setStart(1540339200);
848     preITO.addMilestone(30, 30);
849     preITO.addMilestone(30, 15);
850     preITO.setPrice(100000000000000000000);
851     preITO.setMinInvestedLimit(100000000000000000);
852     preITO.setHardcap(10000000000000000000000);
853     preITO.setToken(token);
854 
855     token.setSaleAgent(preITO);
856 
857     ito = new ITO();
858 
859     ito.setWallet(0xE4cfb1d905e922a93ddcA8528ab0f87b31E9e335);
860     ito.setStart(1545609600);
861     ito.addMilestone(30, 10);
862     ito.addMilestone(60, 0);
863     ito.setPrice(100000000000000000000);
864     ito.setMinInvestedLimit(100000000000000000);
865     ito.setHardcap(20000000000000000000000);
866     ito.addWallet(0xA6b01Ed54c51f5158e1D8c85BFb3c45cB28F323C, 8);
867     ito.setToken(token);
868 
869     preITO.setNextSaleAgent(ito);
870 
871     address manager = 0xdc820f1BD6DaDF2DaD597D2e85255003c596Ad8a;
872 
873     token.transferOwnership(manager);
874     preITO.transferOwnership(manager);
875     ito.transferOwnership(manager);
876   }
877 
878 }