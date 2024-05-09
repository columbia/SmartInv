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
361   function mintTokensBatch(uint amount, address[] to) public onlyOwner {
362     for(uint i = 0; i < to.length; i++) {
363       token.mint(to[i], amount);
364     }
365   }
366 
367 }
368 
369 // File: contracts/PercentRateProvider.sol
370 
371 contract PercentRateProvider {
372 
373   uint public percentRate = 100;
374 
375 }
376 
377 // File: contracts/PercentRateFeature.sol
378 
379 contract PercentRateFeature is Ownable, PercentRateProvider {
380 
381   function setPercentRate(uint newPercentRate) public onlyOwner {
382     percentRate = newPercentRate;
383   }
384 
385 }
386 
387 // File: contracts/RetrieveTokensFeature.sol
388 
389 contract RetrieveTokensFeature is Ownable {
390 
391   function retrieveTokens(address to, address anotherToken) public onlyOwner {
392     ERC20 alienToken = ERC20(anotherToken);
393     alienToken.transfer(to, alienToken.balanceOf(this));
394   }
395 
396 }
397 
398 // File: contracts/WalletProvider.sol
399 
400 contract WalletProvider is Ownable {
401 
402   address public wallet;
403 
404   function setWallet(address newWallet) public onlyOwner {
405     wallet = newWallet;
406   }
407 
408 }
409 
410 // File: contracts/CommonSale.sol
411 
412 contract CommonSale is PercentRateFeature, InvestedProvider, WalletProvider, RetrieveTokensFeature, MintTokensFeature {
413 
414   using SafeMath for uint;
415 
416   address public directMintAgent;
417 
418   uint public price;
419 
420   uint public start;
421 
422   uint public minInvestedLimit;
423 
424   uint public hardcap;
425 
426   modifier isUnderHardcap() {
427     require(invested <= hardcap);
428     _;
429   }
430 
431   function setHardcap(uint newHardcap) public onlyOwner {
432     hardcap = newHardcap;
433   }
434 
435   modifier onlyDirectMintAgentOrOwner() {
436     require(directMintAgent == msg.sender || owner == msg.sender);
437     _;
438   }
439 
440   modifier minInvestLimited(uint value) {
441     require(value >= minInvestedLimit);
442     _;
443   }
444 
445   function setStart(uint newStart) public onlyOwner {
446     start = newStart;
447   }
448 
449   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
450     minInvestedLimit = newMinInvestedLimit;
451   }
452 
453   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
454     directMintAgent = newDirectMintAgent;
455   }
456 
457   function setPrice(uint newPrice) public onlyOwner {
458     price = newPrice;
459   }
460 
461   function calculateTokens(uint _invested) internal returns(uint);
462 
463   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
464     mintTokens(to, tokens);
465   }
466 
467   function endSaleDate() public view returns(uint);
468 
469   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
470     updateInvested(_invested);
471     return mintTokensByETH(to, _invested);
472   }
473 
474   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
475     uint tokens = calculateTokens(_invested);
476     mintTokens(to, tokens);
477     return tokens;
478   }
479 
480   function transferToWallet(uint value) internal {
481     wallet.transfer(value);
482   }
483 
484   function updateInvested(uint value) internal {
485     invested = invested.add(value);
486   }
487 
488   function fallback() internal minInvestLimited(msg.value) returns(uint) {
489     require(now >= start && now < endSaleDate());
490     transferToWallet(msg.value);
491     updateInvested(msg.value);
492     return mintTokensByETH(msg.sender, msg.value);
493   }
494 
495   function () public payable {
496     fallback();
497   }
498 
499 }
500 
501 // File: contracts/AssembledCommonSale.sol
502 
503 contract AssembledCommonSale is CommonSale {
504 
505 }
506 
507 // File: contracts/WalletsPercents.sol
508 
509 contract WalletsPercents is Ownable {
510 
511   address[] public wallets;
512 
513   mapping (address => uint) percents;
514 
515   function addWallet(address wallet, uint percent) public onlyOwner {
516     wallets.push(wallet);
517     percents[wallet] = percent;
518   }
519  
520   function cleanWallets() public onlyOwner {
521     wallets.length = 0;
522   }
523 
524 
525 }
526 
527 // File: contracts/ExtendedWalletsMintTokensFeature.sol
528 
529 //import './PercentRateProvider.sol';
530 
531 contract ExtendedWalletsMintTokensFeature is /*PercentRateProvider,*/ MintTokensInterface, WalletsPercents {
532 
533   using SafeMath for uint;
534 
535   uint public percentRate = 100;
536 
537   function mintExtendedTokens() public onlyOwner {
538     uint summaryTokensPercent = 0;
539     for(uint i = 0; i < wallets.length; i++) {
540       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
541     }
542     uint mintedTokens = token.totalSupply();
543     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
544     for(uint k = 0; k < wallets.length; k++) {
545       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
546     }
547 
548   }
549 
550 }
551 
552 // File: contracts/StagedCrowdsale.sol
553 
554 contract StagedCrowdsale is Ownable {
555 
556   using SafeMath for uint;
557 
558   struct Milestone {
559     uint period;
560     uint bonus;
561   }
562 
563   uint public totalPeriod;
564 
565   Milestone[] public milestones;
566 
567   function milestonesCount() public view returns(uint) {
568     return milestones.length;
569   }
570 
571   function addMilestone(uint period, uint bonus) public onlyOwner {
572     require(period > 0);
573     milestones.push(Milestone(period, bonus));
574     totalPeriod = totalPeriod.add(period);
575   }
576 
577   function removeMilestone(uint8 number) public onlyOwner {
578     require(number < milestones.length);
579     Milestone storage milestone = milestones[number];
580     totalPeriod = totalPeriod.sub(milestone.period);
581 
582     delete milestones[number];
583 
584     for (uint i = number; i < milestones.length - 1; i++) {
585       milestones[i] = milestones[i+1];
586     }
587 
588     milestones.length--;
589   }
590 
591   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
592     require(number < milestones.length);
593     Milestone storage milestone = milestones[number];
594 
595     totalPeriod = totalPeriod.sub(milestone.period);
596 
597     milestone.period = period;
598     milestone.bonus = bonus;
599 
600     totalPeriod = totalPeriod.add(period);
601   }
602 
603   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
604     require(numberAfter < milestones.length);
605 
606     totalPeriod = totalPeriod.add(period);
607 
608     milestones.length++;
609 
610     for (uint i = milestones.length - 2; i > numberAfter; i--) {
611       milestones[i + 1] = milestones[i];
612     }
613 
614     milestones[numberAfter + 1] = Milestone(period, bonus);
615   }
616 
617   function clearMilestones() public onlyOwner {
618     require(milestones.length > 0);
619     for (uint i = 0; i < milestones.length; i++) {
620       delete milestones[i];
621     }
622     milestones.length -= milestones.length;
623     totalPeriod = 0;
624   }
625 
626   function lastSaleDate(uint start) public view returns(uint) {
627     return start + totalPeriod * 1 days;
628   }
629 
630   function currentMilestone(uint start) public view returns(uint) {
631     uint previousDate = start;
632     for(uint i=0; i < milestones.length; i++) {
633       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
634         return i;
635       }
636       previousDate = previousDate.add(milestones[i].period * 1 days);
637     }
638     revert();
639   }
640 
641 }
642 
643 // File: contracts/ITO.sol
644 
645 contract ITO is ExtendedWalletsMintTokensFeature, StagedCrowdsale, AssembledCommonSale {
646 
647   mapping(address => uint) public lockDays;
648 
649   function lockAddress(address newLockAddress, uint newLockDays) public onlyOwner {
650     lockDays[newLockAddress] = newLockDays;
651   }
652 
653   function calculateTokens(uint _invested) internal returns(uint) {
654     uint milestoneIndex = currentMilestone(start);
655     Milestone storage milestone = milestones[milestoneIndex];
656     uint tokens = _invested.mul(price).div(1 ether);
657     if(milestone.bonus > 0) {
658       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
659     }
660     return tokens;
661   }
662 
663   function endSaleDate() public view returns(uint) {
664     return lastSaleDate(start);
665   }
666 
667   function finish() public onlyOwner {
668      mintExtendedTokens();
669      for(uint i = 0; i < wallets.length; i++) {
670       if (lockDays[wallets[i]] != 0){
671         token.lock(wallets[i], lockDays[wallets[i]]);
672       }
673       
674     }
675      token.finishMinting();
676   }
677 
678 }
679 
680 // File: contracts/NextSaleAgentFeature.sol
681 
682 contract NextSaleAgentFeature is Ownable {
683 
684   address public nextSaleAgent;
685 
686   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
687     nextSaleAgent = newNextSaleAgent;
688   }
689 
690 }
691 
692 // File: contracts/SoftcapFeature.sol
693 
694 contract SoftcapFeature is InvestedProvider, WalletProvider {
695 
696   using SafeMath for uint;
697 
698   mapping(address => uint) public balances;
699 
700   bool public softcapAchieved;
701 
702   bool public refundOn;
703 
704   bool feePayed;
705 
706   uint public softcap;
707 
708   uint public constant devLimit = 19500000000000000000;
709 
710   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
711 
712   function setSoftcap(uint newSoftcap) public onlyOwner {
713     softcap = newSoftcap;
714   }
715 
716   function withdraw() public {
717     require(msg.sender == owner || msg.sender == devWallet);
718     require(softcapAchieved);
719     if(!feePayed) {
720       devWallet.transfer(devLimit);
721       feePayed = true;
722     }
723     wallet.transfer(this.balance);
724   }
725 
726   function updateBalance(address to, uint amount) internal {
727     balances[to] = balances[to].add(amount);
728     if (!softcapAchieved && invested >= softcap) {
729       softcapAchieved = true;
730     }
731   }
732 
733   function refund() public {
734     require(refundOn && balances[msg.sender] > 0);
735     uint value = balances[msg.sender];
736     balances[msg.sender] = 0;
737     msg.sender.transfer(value);
738   }
739 
740   function updateRefundState() internal returns(bool) {
741     if (!softcapAchieved) {
742       refundOn = true;
743     }
744     return refundOn;
745   }
746 
747 }
748 
749 // File: contracts/PreITO.sol
750 
751 contract PreITO is SoftcapFeature, NextSaleAgentFeature, AssembledCommonSale {
752 
753   uint public period;
754 
755   function calculateTokens(uint _invested) internal returns(uint) {
756     return _invested.mul(price).div(1 ether);
757   }
758 
759   function setPeriod(uint newPeriod) public onlyOwner {
760     period = newPeriod;
761   }
762 
763   function endSaleDate() public view returns(uint) {
764     return start.add(period * 1 days);
765   }
766 
767   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
768     uint _tokens = super.mintTokensByETH(to, _invested);
769     updateBalance(to, _invested);
770     return _tokens;
771   }
772 
773   function finish() public onlyOwner {
774     if (updateRefundState()) {
775       token.finishMinting();
776     } else {
777       withdraw();
778       token.setSaleAgent(nextSaleAgent);
779     }
780   }
781 
782   function fallback() internal minInvestLimited(msg.value) returns(uint) {
783     require(now >= start && now < endSaleDate());
784     updateInvested(msg.value);
785     return mintTokensByETH(msg.sender, msg.value);
786   }
787 
788 }
789 
790 // File: contracts/ReceivingContractCallback.sol
791 
792 contract ReceivingContractCallback {
793 
794   function tokenFallback(address _from, uint _value) public;
795 
796 }
797 
798 // File: contracts/Token.sol
799 
800 contract Token is MintableToken {
801 
802   string public constant name = "BUILD";
803 
804   string public constant symbol = "BUILD";
805 
806   uint32 public constant decimals = 18;
807 
808   mapping(address => bool)  public registeredCallbacks;
809 
810   function transfer(address _to, uint256 _value) public returns (bool) {
811     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
812   }
813 
814   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
815     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
816   }
817 
818   function registerCallback(address callback) public onlyOwner {
819     registeredCallbacks[callback] = true;
820   }
821 
822   function deregisterCallback(address callback) public onlyOwner {
823     registeredCallbacks[callback] = false;
824   }
825 
826   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
827     if (result && registeredCallbacks[to]) {
828       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
829       targetCallback.tokenFallback(from, value);
830     }
831     return result;
832   }
833 
834 }
835 
836 // File: contracts/Configurator.sol
837 
838 contract Configurator is Ownable {
839 
840   Token public token;
841 
842   PreITO public preITO;
843 
844   ITO public ito;
845 
846   function deploy() public onlyOwner {
847 
848     address manager = 0x66C1833F667eAE8ea1890560e009F139A680F939;
849 
850     token = new Token();
851 
852     preITO = new PreITO();
853     ito = new ITO();
854 
855     commonConfigure(preITO);
856     commonConfigure(ito);
857 
858     preITO.setWallet(0xB53E3f252fBCD041e46Aad82CFaEe326E04d1396);
859     preITO.setStart(1530921600); // 07 Jul 2018 00:00:00 GMT
860     preITO.setPeriod(42);
861     preITO.setPrice(6650000000000000000000);
862     preITO.setSoftcap(2500000000000000000000);
863     preITO.setHardcap(12000000000000000000000);
864 
865     token.setSaleAgent(preITO);
866 
867     ito.setWallet(0x8f1C4E049907Fa4329dAC9c504f4013620Fa39c9);
868     ito.setStart(1535155200); // 25 Aug 2018 00:00:00 GMT
869     ito.setHardcap(23000000000000000000000);
870     ito.setPrice(5000000000000000000000);
871 
872     ito.addMilestone(10, 25);
873     ito.addMilestone(15, 20);
874     ito.addMilestone(15, 15);
875     ito.addMilestone(15, 10);
876     ito.addMilestone(30, 5);
877 
878 
879     ito.addWallet(0x3180e7B6E726B23B1d18D9963bDe3264f5107aef, 2);
880     ito.addWallet(0x36A8b67fe7800Cd169Fd46Cd75824DC016a54d13, 3);
881     ito.addWallet(0xDf9CAAE51eED1F23B4ae9AeCDbdeb926252eFFC4, 11);
882     ito.addWallet(0x7D648BcAbf05CEf119C9a11b8E05756a41Bd29Ad, 4);
883 
884     ito.lockAddress(0x3180e7B6E726B23B1d18D9963bDe3264f5107aef,30);
885     ito.lockAddress(0x36A8b67fe7800Cd169Fd46Cd75824DC016a54d13,90);
886     ito.lockAddress(0xDf9CAAE51eED1F23B4ae9AeCDbdeb926252eFFC4,180);
887 
888     preITO.setNextSaleAgent(ito);
889 
890     token.transferOwnership(manager);
891     preITO.transferOwnership(manager);
892     ito.transferOwnership(manager);
893   }
894 
895   function commonConfigure(AssembledCommonSale sale) internal {
896     sale.setPercentRate(100);
897     sale.setMinInvestedLimit(100000000000000000);
898     sale.setToken(token);
899   }
900 
901 }