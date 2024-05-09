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
349   uint public minted;
350 
351   function mintTokens(address to, uint tokens) internal;
352 
353 }
354 
355 // File: contracts/MintTokensFeature.sol
356 
357 contract MintTokensFeature is MintTokensInterface {
358 
359   using SafeMath for uint;
360 
361   function mintTokens(address to, uint tokens) internal {
362     token.mint(to, tokens);
363     minted = minted.add(tokens);
364   }
365 
366 }
367 
368 // File: contracts/PercentRateProvider.sol
369 
370 contract PercentRateProvider {
371 
372   uint public percentRate = 100;
373 
374 }
375 
376 // File: contracts/PercentRateFeature.sol
377 
378 contract PercentRateFeature is Ownable, PercentRateProvider {
379 
380   function setPercentRate(uint newPercentRate) public onlyOwner {
381     percentRate = newPercentRate;
382   }
383 
384 }
385 
386 // File: contracts/RetrieveTokensFeature.sol
387 
388 contract RetrieveTokensFeature is Ownable {
389 
390   function retrieveTokens(address to, address anotherToken) public onlyOwner {
391     ERC20 alienToken = ERC20(anotherToken);
392     alienToken.transfer(to, alienToken.balanceOf(this));
393   }
394 
395 }
396 
397 // File: contracts/WalletProvider.sol
398 
399 contract WalletProvider is Ownable {
400 
401   address public wallet;
402 
403   function setWallet(address newWallet) public onlyOwner {
404     wallet = newWallet;
405   }
406 
407 }
408 
409 // File: contracts/CommonSale.sol
410 
411 contract CommonSale is PercentRateFeature, InvestedProvider, WalletProvider, RetrieveTokensFeature, MintTokensFeature {
412 
413   address public directMintAgent;
414 
415   uint public price;
416 
417   uint public start;
418 
419   uint public minInvestedLimit;
420 
421   uint public hardcap;
422 
423   modifier isUnderHardcap() {
424     require(invested <= hardcap);
425     _;
426   }
427 
428   function setHardcap(uint newHardcap) public onlyOwner {
429     hardcap = newHardcap;
430   }
431 
432   modifier onlyDirectMintAgentOrOwner() {
433     require(directMintAgent == msg.sender || owner == msg.sender);
434     _;
435   }
436 
437   modifier minInvestLimited(uint value) {
438     require(value >= minInvestedLimit);
439     _;
440   }
441 
442   function setStart(uint newStart) public onlyOwner {
443     start = newStart;
444   }
445 
446   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
447     minInvestedLimit = newMinInvestedLimit;
448   }
449 
450   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
451     directMintAgent = newDirectMintAgent;
452   }
453 
454   function setPrice(uint newPrice) public onlyOwner {
455     price = newPrice;
456   }
457 
458   function calculateTokens(uint _invested) internal returns(uint);
459 
460   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
461     mintTokens(to, tokens);
462   }
463 
464   function endSaleDate() public view returns(uint);
465 
466   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
467     updateInvested(_invested);
468     return mintTokensByETH(to, _invested);
469   }
470 
471   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
472     uint tokens = calculateTokens(_invested);
473     mintTokens(to, tokens);
474     return tokens;
475   }
476 
477   function transferToWallet(uint value) internal {
478     wallet.transfer(value);
479   }
480 
481   function updateInvested(uint value) internal {
482     invested = invested.add(value);
483   }
484 
485   function fallback() internal minInvestLimited(msg.value) returns(uint) {
486     require(now >= start && now < endSaleDate());
487     transferToWallet(msg.value);
488     updateInvested(msg.value);
489     return mintTokensByETH(msg.sender, msg.value);
490   }
491 
492   function () public payable {
493     fallback();
494   }
495 
496 }
497 
498 // File: contracts/SpecialWallet.sol
499 
500 contract SpecialWallet is PercentRateFeature {
501   
502   using SafeMath for uint;
503 
504   uint public endDate;
505 
506   uint initialBalance;
507 
508   bool public started;
509 
510   uint public startDate;
511 
512   uint availableAfterStart;
513 
514   uint public withdrawed;
515 
516   uint public startQuater;
517 
518   uint public quater1;
519 
520   uint public quater2;
521 
522   uint public quater3;
523 
524   uint public quater4;
525 
526   modifier notStarted() {
527     require(!started);
528     _;
529   }
530 
531   function start() public onlyOwner notStarted {
532     started = true;
533     startDate = now;
534 
535     uint year = 1 years;
536     uint quater = year.div(4);
537     uint prevYear = endDate.sub(1 years);
538 
539     quater1 = prevYear;
540     quater2 = prevYear.add(quater);
541     quater3 = prevYear.add(quater.mul(2));
542     quater4 = prevYear.add(quater.mul(3));
543 
544     initialBalance = this.balance;
545 
546     startQuater = curQuater();
547   }
548 
549   function curQuater() public view returns (uint) {
550     if(now > quater4) 
551       return 4;
552     if(now > quater3) 
553       return 3;
554     if(now > quater2) 
555       return 2;
556     return 1;
557   }
558  
559   function setAvailableAfterStart(uint newAvailableAfterStart) public onlyOwner notStarted {
560     availableAfterStart = newAvailableAfterStart;
561   }
562 
563   function setEndDate(uint newEndDate) public onlyOwner notStarted {
564     endDate = newEndDate;
565   }
566 
567   function withdraw(address to) public onlyOwner {
568     require(started);
569     if(now >= endDate) {
570       to.transfer(this.balance);
571     } else {
572       uint cQuater = curQuater();
573       uint toTransfer = initialBalance.mul(availableAfterStart).div(percentRate);
574       if(startQuater < 4 && cQuater > startQuater) {
575         uint secondInitialBalance = initialBalance.sub(toTransfer);
576         uint quaters = 4;
577         uint allQuaters = quaters.sub(startQuater);        
578         uint value = secondInitialBalance.mul(cQuater.sub(startQuater)).div(allQuaters);         
579         toTransfer = toTransfer.add(value);
580       }
581       toTransfer = toTransfer.sub(withdrawed); 
582       to.transfer(toTransfer);
583       withdrawed = withdrawed.add(toTransfer);        
584     }
585   }
586 
587   function () public payable {
588   }
589 
590 }
591 
592 // File: contracts/AssembledCommonSale.sol
593 
594 contract AssembledCommonSale is CommonSale {
595 
596   uint public period;
597 
598   SpecialWallet public specialWallet;
599 
600   function setSpecialWallet(address addrSpecialWallet) public onlyOwner {
601     specialWallet = SpecialWallet(addrSpecialWallet);
602   }
603 
604   function setPeriod(uint newPeriod) public onlyOwner {
605     period = newPeriod;
606   }
607 
608   function endSaleDate() public view returns(uint) {
609     return start.add(period * 1 days);
610   }
611 
612 }
613 
614 // File: contracts/WalletsPercents.sol
615 
616 contract WalletsPercents is Ownable {
617 
618   address[] public wallets;
619 
620   mapping (address => uint) percents;
621 
622   function addWallet(address wallet, uint percent) public onlyOwner {
623     wallets.push(wallet);
624     percents[wallet] = percent;
625   }
626  
627   function cleanWallets() public onlyOwner {
628     wallets.length = 0;
629   }
630 
631 
632 }
633 
634 // File: contracts/ExtendedWalletsMintTokensFeature.sol
635 
636 //import './PercentRateProvider.sol';
637 
638 contract ExtendedWalletsMintTokensFeature is /*PercentRateProvider,*/ MintTokensInterface, WalletsPercents {
639 
640   using SafeMath for uint;
641 
642   uint public percentRate = 100;
643 
644   function mintExtendedTokens() public onlyOwner {
645     uint summaryTokensPercent = 0;
646     for(uint i = 0; i < wallets.length; i++) {
647       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
648     }
649     uint mintedTokens = token.totalSupply();
650     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
651     for(uint k = 0; k < wallets.length; k++) {
652       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
653     }
654 
655   }
656 
657 }
658 
659 // File: contracts/StagedCrowdsale.sol
660 
661 contract StagedCrowdsale is Ownable {
662 
663   using SafeMath for uint;
664 
665   struct Milestone {
666     uint period;
667     uint bonus;
668   }
669 
670   uint public totalPeriod;
671 
672   Milestone[] public milestones;
673 
674   function milestonesCount() public view returns(uint) {
675     return milestones.length;
676   }
677 
678   function addMilestone(uint period, uint bonus) public onlyOwner {
679     require(period > 0);
680     milestones.push(Milestone(period, bonus));
681     totalPeriod = totalPeriod.add(period);
682   }
683 
684   function removeMilestone(uint8 number) public onlyOwner {
685     require(number < milestones.length);
686     Milestone storage milestone = milestones[number];
687     totalPeriod = totalPeriod.sub(milestone.period);
688 
689     delete milestones[number];
690 
691     for (uint i = number; i < milestones.length - 1; i++) {
692       milestones[i] = milestones[i+1];
693     }
694 
695     milestones.length--;
696   }
697 
698   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
699     require(number < milestones.length);
700     Milestone storage milestone = milestones[number];
701 
702     totalPeriod = totalPeriod.sub(milestone.period);
703 
704     milestone.period = period;
705     milestone.bonus = bonus;
706 
707     totalPeriod = totalPeriod.add(period);
708   }
709 
710   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
711     require(numberAfter < milestones.length);
712 
713     totalPeriod = totalPeriod.add(period);
714 
715     milestones.length++;
716 
717     for (uint i = milestones.length - 2; i > numberAfter; i--) {
718       milestones[i + 1] = milestones[i];
719     }
720 
721     milestones[numberAfter + 1] = Milestone(period, bonus);
722   }
723 
724   function clearMilestones() public onlyOwner {
725     require(milestones.length > 0);
726     for (uint i = 0; i < milestones.length; i++) {
727       delete milestones[i];
728     }
729     milestones.length -= milestones.length;
730     totalPeriod = 0;
731   }
732 
733   function lastSaleDate(uint start) public view returns(uint) {
734     return start + totalPeriod * 1 days;
735   }
736 
737   function currentMilestone(uint start) public view returns(uint) {
738     uint previousDate = start;
739     for(uint i=0; i < milestones.length; i++) {
740       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
741         return i;
742       }
743       previousDate = previousDate.add(milestones[i].period * 1 days);
744     }
745     revert();
746   }
747 
748 }
749 
750 // File: contracts/ITO.sol
751 
752 contract ITO is ExtendedWalletsMintTokensFeature, AssembledCommonSale {
753 
754   function calculateTokens(uint _invested) internal returns(uint) {
755     return  _invested.mul(price).div(1 ether);
756   }
757 
758   function setSpecialWallet(address addrSpecialWallet) public onlyOwner {
759     super.setSpecialWallet(addrSpecialWallet);
760     setWallet(addrSpecialWallet);
761   }
762 
763   function finish() public onlyOwner {
764      mintExtendedTokens();
765      token.finishMinting();
766      specialWallet.start();
767      specialWallet.transferOwnership(owner);
768   }
769 
770 }
771 
772 // File: contracts/NextSaleAgentFeature.sol
773 
774 contract NextSaleAgentFeature is Ownable {
775 
776   address public nextSaleAgent;
777 
778   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
779     nextSaleAgent = newNextSaleAgent;
780   }
781 
782 }
783 
784 // File: contracts/SoftcapFeature.sol
785 
786 contract SoftcapFeature is InvestedProvider, WalletProvider {
787 
788   using SafeMath for uint;
789 
790   mapping(address => uint) public balances;
791 
792   bool public softcapAchieved;
793 
794   bool public refundOn;
795 
796   bool public feePayed;
797 
798   uint public softcap;
799 
800   uint public constant devLimit = 26500000000000000000;
801 
802   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
803 
804   address public constant special = 0x1D0B575b48a6667FD8E59Da3b01a49c33005d2F1;
805 
806   function setSoftcap(uint newSoftcap) public onlyOwner {
807     softcap = newSoftcap;
808   }
809 
810   function withdraw() public {
811     require(msg.sender == owner || msg.sender == devWallet);
812     require(softcapAchieved);
813     if(!feePayed) {
814       devWallet.transfer(devLimit.sub(18 ether));
815       special.transfer(18 ether);
816       feePayed = true;
817     }
818     wallet.transfer(this.balance);
819   }
820 
821   function updateBalance(address to, uint amount) internal {
822     balances[to] = balances[to].add(amount);
823     if (!softcapAchieved && invested >= softcap) {
824       softcapAchieved = true;
825       softcapReachedCallabck();
826     }
827   }
828 
829   function softcapReachedCallabck() internal {
830   }
831 
832   function refund() public {
833     require(refundOn && balances[msg.sender] > 0);
834     uint value = balances[msg.sender];
835     balances[msg.sender] = 0;
836     msg.sender.transfer(value);
837   }
838 
839   function updateRefundState() internal returns(bool) {
840     if (!softcapAchieved) {
841       refundOn = true;
842     }
843     return refundOn;
844   }
845 
846 }
847 
848 // File: contracts/PreITO.sol
849 
850 contract PreITO is SoftcapFeature, NextSaleAgentFeature, AssembledCommonSale {
851 
852   uint public firstBonusTokensLimit;
853 
854   uint public firstBonus;
855 
856   uint public secondBonus;
857 
858   function setFirstBonusTokensLimit(uint _tokens) public onlyOwner {
859     firstBonusTokensLimit = _tokens;
860   }
861 
862   function setFirstBonus(uint newFirstBonus) public onlyOwner {
863     firstBonus = newFirstBonus;
864   }
865 
866   function setSecondBonus(uint newSecondBonus) public onlyOwner {
867     secondBonus = newSecondBonus;
868   }
869 
870   function calculateTokens(uint _invested) internal returns(uint) {
871     uint tokens = _invested.mul(price).div(1 ether);
872     if(minted <= firstBonusTokensLimit) {
873       if(firstBonus > 0) {
874         tokens = tokens.add(tokens.mul(firstBonus).div(percentRate));
875       }
876     } else {
877       if(secondBonus > 0) {
878         tokens = tokens.add(tokens.mul(secondBonus).div(percentRate));
879       }
880     }
881     return tokens;
882   }
883 
884   function softcapReachedCallabck() internal {
885     wallet = specialWallet;
886   }
887 
888   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
889     uint _tokens = super.mintTokensByETH(to, _invested);
890     updateBalance(to, _invested);
891     return _tokens;
892   }
893 
894   function finish() public onlyOwner {
895     if (updateRefundState()) {
896       token.finishMinting();
897     } else {
898       withdraw();
899       specialWallet.transferOwnership(nextSaleAgent);
900       token.setSaleAgent(nextSaleAgent);
901     }
902   }
903 
904   function fallback() internal minInvestLimited(msg.value) returns(uint) {
905     require(now >= start && now < endSaleDate());
906     updateInvested(msg.value);
907     return mintTokensByETH(msg.sender, msg.value);
908   }
909 
910 }
911 
912 // File: contracts/ReceivingContractCallback.sol
913 
914 contract ReceivingContractCallback {
915 
916   function tokenFallback(address _from, uint _value) public;
917 
918 }
919 
920 // File: contracts/Token.sol
921 
922 contract Token is MintableToken {
923 
924   string public constant name = "Blockchain Agro Trading Token";
925 
926   string public constant symbol = "BATT";
927 
928   uint32 public constant decimals = 18;
929 
930   mapping(address => bool)  public registeredCallbacks;
931 
932   function transfer(address _to, uint256 _value) public returns (bool) {
933     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
934   }
935 
936   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
937     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
938   }
939 
940   function registerCallback(address callback) public onlyOwner {
941     registeredCallbacks[callback] = true;
942   }
943 
944   function deregisterCallback(address callback) public onlyOwner {
945     registeredCallbacks[callback] = false;
946   }
947 
948   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
949     if (result && registeredCallbacks[to]) {
950       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
951       targetCallback.tokenFallback(from, value);
952     }
953     return result;
954   }
955 
956 }
957 
958 // File: contracts/Configurator.sol
959 
960 contract Configurator is Ownable {
961 
962   Token public token;
963 
964   SpecialWallet public specialWallet;
965 
966   PreITO public preITO;
967 
968   ITO public ito;
969 
970   function deploy() public onlyOwner {
971 
972     address manager = 0x529E6B0e82EF632F070D997dd50C35aAa939cB37;
973 
974     token = new Token();
975     specialWallet = new SpecialWallet();
976     preITO = new PreITO();
977     ito = new ITO();
978 
979     specialWallet.setAvailableAfterStart(50);
980     specialWallet.setEndDate(1546300800);
981     specialWallet.transferOwnership(preITO);
982 
983     commonConfigure(preITO);
984     commonConfigure(ito);
985 
986     preITO.setWallet(0x0fc0b9f68DCc12B72203e579d427d1ddf007e464);
987     preITO.setStart(1524441600);
988     preITO.setSoftcap(1000000000000000000000);
989     preITO.setHardcap(33366000000000000000000);
990     preITO.setFirstBonus(100);
991     preITO.setFirstBonusTokensLimit(30000000000000000000000000);
992     preITO.setSecondBonus(50);
993     preITO.setMinInvestedLimit(1000000000000000000);
994 
995     token.setSaleAgent(preITO);
996 
997     ito.setStart(1527206400);
998     ito.setHardcap(23000000000000000000000);
999 
1000     ito.addWallet(0x8c76033Dedd13FD386F12787Ab4973BcbD1de2A8, 1);
1001     ito.addWallet(0x31Dba1B0b92fa23Eec30e2fF169dc7Cc05eEE915, 1);
1002     ito.addWallet(0x7Ae3c0DdaC135D69cA8E04d05559cd42822ecf14, 8);
1003     ito.setMinInvestedLimit(100000000000000000);
1004 
1005     preITO.setNextSaleAgent(ito);
1006 
1007     token.transferOwnership(manager);
1008     preITO.transferOwnership(manager);
1009     ito.transferOwnership(manager);
1010   }
1011 
1012   function commonConfigure(AssembledCommonSale sale) internal {
1013     sale.setPercentRate(100);
1014     sale.setPeriod(30);
1015     sale.setPrice(30000000000000000000000);
1016     sale.setSpecialWallet(specialWallet);
1017     sale.setToken(token);
1018   }
1019 
1020 }