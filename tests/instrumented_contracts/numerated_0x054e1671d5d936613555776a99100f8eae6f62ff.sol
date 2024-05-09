1 pragma solidity ^0.4.18;
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/InvestedProvider.sol
48 
49 contract InvestedProvider is Ownable {
50 
51   uint public invested;
52 
53 }
54 
55 // File: contracts/AddressesFilterFeature.sol
56 
57 contract AddressesFilterFeature is Ownable {
58 
59   mapping(address => bool) public allowedAddresses;
60 
61   function addAllowedAddress(address allowedAddress) public onlyOwner {
62     allowedAddresses[allowedAddress] = true;
63   }
64 
65   function removeAllowedAddress(address allowedAddress) public onlyOwner {
66     allowedAddresses[allowedAddress] = false;
67   }
68 
69 }
70 
71 // File: contracts/math/SafeMath.sol
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 // File: contracts/token/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   uint256 public totalSupply;
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: contracts/token/BasicToken.sol
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     // SafeMath.sub will throw if there is not enough balance.
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 // File: contracts/token/ERC20.sol
159 
160 /**
161  * @title ERC20 interface
162  * @dev see https://github.com/ethereum/EIPs/issues/20
163  */
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) public view returns (uint256);
166   function transferFrom(address from, address to, uint256 value) public returns (bool);
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 // File: contracts/token/StandardToken.sol
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182   mapping (address => mapping (address => uint256)) internal allowed;
183 
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    *
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) public view returns (uint256) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
240     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 // File: contracts/MintableToken.sol
269 
270 contract MintableToken is AddressesFilterFeature, StandardToken {
271 
272   event Mint(address indexed to, uint256 amount);
273 
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278   address public saleAgent;
279 
280   mapping (address => uint) public initialBalances;
281 
282   mapping (address => uint) public lockedAddresses;
283 
284   modifier notLocked(address _from, uint _value) {
285     require(msg.sender == owner || msg.sender == saleAgent || allowedAddresses[_from] || (mintingFinished && now > lockedAddresses[_from]));
286     _;
287   }
288 
289   function lock(address _from, uint lockDays) public {
290     require(msg.sender == saleAgent || msg.sender == owner);
291     lockedAddresses[_from] = now + 1 days * lockDays;
292   }
293 
294   function setSaleAgent(address newSaleAgnet) public {
295     require(msg.sender == saleAgent || msg.sender == owner);
296     saleAgent = newSaleAgnet;
297   }
298 
299   function mint(address _to, uint256 _amount) public returns (bool) {
300     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
301     
302     totalSupply = totalSupply.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304 
305     initialBalances[_to] = balances[_to];
306 
307     Mint(_to, _amount);
308     Transfer(address(0), _to, _amount);
309     return true;
310   }
311 
312   /**
313    * @dev Function to stop minting new tokens.
314    * @return True if the operation was successful.
315    */
316   function finishMinting() public returns (bool) {
317     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
318     mintingFinished = true;
319     MintFinished();
320     return true;
321   }
322 
323   function transfer(address _to, uint256 _value) public notLocked(msg.sender, _value)  returns (bool) {
324     return super.transfer(_to, _value);
325   }
326 
327   function transferFrom(address from, address to, uint256 value) public notLocked(from, value) returns (bool) {
328     return super.transferFrom(from, to, value);
329   }
330 
331 }
332 
333 // File: contracts/TokenProvider.sol
334 
335 contract TokenProvider is Ownable {
336 
337   MintableToken public token;
338 
339   function setToken(address newToken) public onlyOwner {
340     token = MintableToken(newToken);
341   }
342 
343 }
344 
345 // File: contracts/MintTokensInterface.sol
346 
347 contract MintTokensInterface is TokenProvider {
348 
349   function mintTokens(address to, uint tokens) internal;
350 
351 }
352 
353 // File: contracts/MintTokensFeature.sol
354 
355 contract MintTokensFeature is MintTokensInterface {
356 
357   function mintTokens(address to, uint tokens) internal {
358     token.mint(to, tokens);
359   }
360 
361 }
362 
363 // File: contracts/PercentRateProvider.sol
364 
365 contract PercentRateProvider {
366 
367   uint public percentRate = 100;
368 
369 }
370 
371 // File: contracts/PercentRateFeature.sol
372 
373 contract PercentRateFeature is Ownable, PercentRateProvider {
374 
375   function setPercentRate(uint newPercentRate) public onlyOwner {
376     percentRate = newPercentRate;
377   }
378 
379 }
380 
381 // File: contracts/RetrieveTokensFeature.sol
382 
383 contract RetrieveTokensFeature is Ownable {
384 
385   function retrieveTokens(address to, address anotherToken) public onlyOwner {
386     ERC20 alienToken = ERC20(anotherToken);
387     alienToken.transfer(to, alienToken.balanceOf(this));
388   }
389 
390 }
391 
392 // File: contracts/WalletProvider.sol
393 
394 contract WalletProvider is Ownable {
395 
396   address public wallet;
397 
398   function setWallet(address newWallet) public onlyOwner {
399     wallet = newWallet;
400   }
401 
402 }
403 
404 // File: contracts/CommonSale.sol
405 
406 contract CommonSale is PercentRateFeature, InvestedProvider, WalletProvider, RetrieveTokensFeature, MintTokensFeature {
407 
408   using SafeMath for uint;
409 
410   address public directMintAgent;
411 
412   uint public price;
413 
414   uint public start;
415 
416   uint public minInvestedLimit;
417 
418   uint public hardcap;
419 
420   modifier isUnderHardcap() {
421     require(invested <= hardcap);
422     _;
423   }
424 
425   function setHardcap(uint newHardcap) public onlyOwner {
426     hardcap = newHardcap;
427   }
428 
429   modifier onlyDirectMintAgentOrOwner() {
430     require(directMintAgent == msg.sender || owner == msg.sender);
431     _;
432   }
433 
434   modifier minInvestLimited(uint value) {
435     require(value >= minInvestedLimit);
436     _;
437   }
438 
439   function setStart(uint newStart) public onlyOwner {
440     start = newStart;
441   }
442 
443   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
444     minInvestedLimit = newMinInvestedLimit;
445   }
446 
447   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
448     directMintAgent = newDirectMintAgent;
449   }
450 
451   function setPrice(uint newPrice) public onlyOwner {
452     price = newPrice;
453   }
454 
455   function calculateTokens(uint _invested) internal returns(uint);
456 
457   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
458     mintTokens(to, tokens);
459   }
460 
461   function endSaleDate() public view returns(uint);
462 
463   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
464     updateInvested(_invested);
465     return mintTokensByETH(to, _invested);
466   }
467 
468   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
469     uint tokens = calculateTokens(_invested);
470     mintTokens(to, tokens);
471     return tokens;
472   }
473 
474   function transferToWallet(uint value) internal {
475     wallet.transfer(value);
476   }
477 
478   function updateInvested(uint value) internal {
479     invested = invested.add(value);
480   }
481 
482   function fallback() internal minInvestLimited(msg.value) returns(uint) {
483     require(now >= start && now < endSaleDate());
484     transferToWallet(msg.value);
485     updateInvested(msg.value);
486     return mintTokensByETH(msg.sender, msg.value);
487   }
488 
489   function () public payable {
490     fallback();
491   }
492 
493 }
494 
495 // File: contracts/AssembledCommonSale.sol
496 
497 contract AssembledCommonSale is CommonSale {
498 
499 }
500 
501 // File: contracts/WalletsPercents.sol
502 
503 contract WalletsPercents is Ownable {
504 
505   address[] public wallets;
506 
507   mapping (address => uint) percents;
508 
509   function addWallet(address wallet, uint percent) public onlyOwner {
510     wallets.push(wallet);
511     percents[wallet] = percent;
512   }
513  
514   function cleanWallets() public onlyOwner {
515     wallets.length = 0;
516   }
517 
518 
519 }
520 
521 // File: contracts/ExtendedWalletsMintTokensFeature.sol
522 
523 //import './PercentRateProvider.sol';
524 
525 contract ExtendedWalletsMintTokensFeature is /*PercentRateProvider,*/ MintTokensInterface, WalletsPercents {
526 
527   using SafeMath for uint;
528 
529   uint public percentRate = 100;
530 
531   function mintExtendedTokens() public onlyOwner {
532     uint summaryTokensPercent = 0;
533     for(uint i = 0; i < wallets.length; i++) {
534       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
535     }
536     uint mintedTokens = token.totalSupply();
537     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
538     for(uint k = 0; k < wallets.length; k++) {
539       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
540     }
541 
542   }
543 
544 }
545 
546 // File: contracts/StagedCrowdsale.sol
547 
548 contract StagedCrowdsale is Ownable {
549 
550   using SafeMath for uint;
551 
552   struct Milestone {
553     uint period;
554     uint bonus;
555   }
556 
557   uint public totalPeriod;
558 
559   Milestone[] public milestones;
560 
561   function milestonesCount() public view returns(uint) {
562     return milestones.length;
563   }
564 
565   function addMilestone(uint period, uint bonus) public onlyOwner {
566     require(period > 0);
567     milestones.push(Milestone(period, bonus));
568     totalPeriod = totalPeriod.add(period);
569   }
570 
571   function removeMilestone(uint8 number) public onlyOwner {
572     require(number < milestones.length);
573     Milestone storage milestone = milestones[number];
574     totalPeriod = totalPeriod.sub(milestone.period);
575 
576     delete milestones[number];
577 
578     for (uint i = number; i < milestones.length - 1; i++) {
579       milestones[i] = milestones[i+1];
580     }
581 
582     milestones.length--;
583   }
584 
585   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
586     require(number < milestones.length);
587     Milestone storage milestone = milestones[number];
588 
589     totalPeriod = totalPeriod.sub(milestone.period);
590 
591     milestone.period = period;
592     milestone.bonus = bonus;
593 
594     totalPeriod = totalPeriod.add(period);
595   }
596 
597   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
598     require(numberAfter < milestones.length);
599 
600     totalPeriod = totalPeriod.add(period);
601 
602     milestones.length++;
603 
604     for (uint i = milestones.length - 2; i > numberAfter; i--) {
605       milestones[i + 1] = milestones[i];
606     }
607 
608     milestones[numberAfter + 1] = Milestone(period, bonus);
609   }
610 
611   function clearMilestones() public onlyOwner {
612     require(milestones.length > 0);
613     for (uint i = 0; i < milestones.length; i++) {
614       delete milestones[i];
615     }
616     milestones.length -= milestones.length;
617     totalPeriod = 0;
618   }
619 
620   function lastSaleDate(uint start) public view returns(uint) {
621     return start + totalPeriod * 1 days;
622   }
623 
624   function currentMilestone(uint start) public view returns(uint) {
625     uint previousDate = start;
626     for(uint i=0; i < milestones.length; i++) {
627       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
628         return i;
629       }
630       previousDate = previousDate.add(milestones[i].period * 1 days);
631     }
632     revert();
633   }
634 
635 }
636 
637 // File: contracts/ITO.sol
638 
639 contract ITO is ExtendedWalletsMintTokensFeature, StagedCrowdsale, AssembledCommonSale {
640 
641   address public lockAddress;
642 
643   uint public lockDays;
644 
645   function lockAddress(address newLockAddress, uint newLockDays) public onlyOwner {
646     lockAddress = newLockAddress;
647     lockDays = newLockDays;
648   }
649 
650   function calculateTokens(uint _invested) internal returns(uint) {
651     uint milestoneIndex = currentMilestone(start);
652     Milestone storage milestone = milestones[milestoneIndex];
653     uint tokens = _invested.mul(price).div(1 ether);
654     if(milestone.bonus > 0) {
655       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
656     }
657     return tokens;
658   }
659 
660   function endSaleDate() public view returns(uint) {
661     return lastSaleDate(start);
662   }
663 
664   function finish() public onlyOwner {
665      mintExtendedTokens();
666      token.lock(lockAddress, lockDays);
667      token.finishMinting();
668   }
669 
670 }
671 
672 // File: contracts/NextSaleAgentFeature.sol
673 
674 contract NextSaleAgentFeature is Ownable {
675 
676   address public nextSaleAgent;
677 
678   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
679     nextSaleAgent = newNextSaleAgent;
680   }
681 
682 }
683 
684 // File: contracts/SoftcapFeature.sol
685 
686 contract SoftcapFeature is InvestedProvider, WalletProvider {
687 
688   using SafeMath for uint;
689 
690   mapping(address => uint) public balances;
691 
692   bool public softcapAchieved;
693 
694   bool public refundOn;
695 
696   bool feePayed;
697 
698   uint public softcap;
699 
700   uint public constant devLimit = 7500000000000000000;
701 
702   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
703 
704   function setSoftcap(uint newSoftcap) public onlyOwner {
705     softcap = newSoftcap;
706   }
707 
708   function withdraw() public {
709     require(msg.sender == owner || msg.sender == devWallet);
710     require(softcapAchieved);
711     if(!feePayed) {
712       devWallet.transfer(devLimit);
713       feePayed = true;
714     }
715     wallet.transfer(this.balance);
716   }
717 
718   function updateBalance(address to, uint amount) internal {
719     balances[to] = balances[to].add(amount);
720     if (!softcapAchieved && invested >= softcap) {
721       softcapAchieved = true;
722     }
723   }
724 
725   function refund() public {
726     require(refundOn && balances[msg.sender] > 0);
727     uint value = balances[msg.sender];
728     balances[msg.sender] = 0;
729     msg.sender.transfer(value);
730   }
731 
732   function updateRefundState() internal returns(bool) {
733     if (!softcapAchieved) {
734       refundOn = true;
735     }
736     return refundOn;
737   }
738 
739 }
740 
741 // File: contracts/PreITO.sol
742 
743 contract PreITO is SoftcapFeature, NextSaleAgentFeature, AssembledCommonSale {
744 
745   uint public period;
746 
747   function calculateTokens(uint _invested) internal returns(uint) {
748     return _invested.mul(price).div(1 ether);
749   }
750 
751   function setPeriod(uint newPeriod) public onlyOwner {
752     period = newPeriod;
753   }
754 
755   function endSaleDate() public view returns(uint) {
756     return start.add(period * 1 days);
757   }
758 
759   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
760     uint _tokens = super.mintTokensByETH(to, _invested);
761     updateBalance(to, _invested);
762     return _tokens;
763   }
764 
765   function finish() public onlyOwner {
766     if (updateRefundState()) {
767       token.finishMinting();
768     } else {
769       withdraw();
770       token.setSaleAgent(nextSaleAgent);
771     }
772   }
773 
774   function fallback() internal minInvestLimited(msg.value) returns(uint) {
775     require(now >= start && now < endSaleDate());
776     updateInvested(msg.value);
777     return mintTokensByETH(msg.sender, msg.value);
778   }
779 
780 }
781 
782 // File: contracts/ReceivingContractCallback.sol
783 
784 contract ReceivingContractCallback {
785 
786   function tokenFallback(address _from, uint _value) public;
787 
788 }
789 
790 // File: contracts/Token.sol
791 
792 contract Token is MintableToken {
793 
794   string public constant name = "BUILD";
795 
796   string public constant symbol = "BUILD";
797 
798   uint32 public constant decimals = 18;
799 
800   mapping(address => bool)  public registeredCallbacks;
801 
802   function transfer(address _to, uint256 _value) public returns (bool) {
803     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
804   }
805 
806   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
807     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
808   }
809 
810   function registerCallback(address callback) public onlyOwner {
811     registeredCallbacks[callback] = true;
812   }
813 
814   function deregisterCallback(address callback) public onlyOwner {
815     registeredCallbacks[callback] = false;
816   }
817 
818   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
819     if (result && registeredCallbacks[to]) {
820       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
821       targetCallback.tokenFallback(from, value);
822     }
823     return result;
824   }
825 
826 }
827 
828 // File: contracts/Configurator.sol
829 
830 contract Configurator is Ownable {
831 
832   Token public token;
833 
834   PreITO public preITO;
835 
836   ITO public ito;
837 
838   function deploy() public onlyOwner {
839 
840     address manager = 0x66C1833F667eAE8ea1890560e009F139A680F939;
841 
842     token = new Token();
843 
844     preITO = new PreITO();
845     ito = new ITO();
846 
847     commonConfigure(preITO);
848     commonConfigure(ito);
849 
850     preITO.setWallet(0xB53E3f252fBCD041e46Aad82CFaEe326E04d1396);
851     preITO.setStart(1524441600);
852     preITO.setPeriod(42);
853     preITO.setPrice(6650000000000000000000);
854     preITO.setSoftcap(2500000000000000000000);
855     preITO.setHardcap(12000000000000000000000);
856 
857     token.setSaleAgent(preITO);
858 
859     ito.setWallet(0x8f1C4E049907Fa4329dAC9c504f4013620Fa39c9);
860     ito.setStart(1527206400);
861     ito.setHardcap(23000000000000000000000);
862     ito.setPrice(5000000000000000000000);
863 
864     ito.addMilestone(10, 25);
865     ito.addMilestone(15, 20);
866     ito.addMilestone(15, 15);
867     ito.addMilestone(15, 10);
868     ito.addMilestone(30, 0);
869 
870 
871     ito.addWallet(0x3180e7B6E726B23B1d18D9963bDe3264f5107aef, 2);
872     ito.addWallet(0x36A8b67fe7800Cd169Fd46Cd75824DC016a54d13, 3);
873     ito.addWallet(0xDf9CAAE51eED1F23B4ae9AeCDbdeb926252eFFC4, 11);
874     ito.addWallet(0x7D648BcAbf05CEf119C9a11b8E05756a41Bd29Ad, 4);
875 
876     ito.lockAddress(0x3180e7B6E726B23B1d18D9963bDe3264f5107aef,30);
877 
878     preITO.setNextSaleAgent(ito);
879 
880     token.transferOwnership(manager);
881     preITO.transferOwnership(manager);
882     ito.transferOwnership(manager);
883   }
884 
885   function commonConfigure(AssembledCommonSale sale) internal {
886     sale.setPercentRate(100);
887     sale.setMinInvestedLimit(100000000000000000);
888     sale.setToken(token);
889   }
890 
891 }