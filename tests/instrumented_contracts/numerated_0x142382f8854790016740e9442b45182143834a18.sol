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
67 // File: contracts/InvestedProvider.sol
68 
69 contract InvestedProvider is Ownable {
70 
71   uint public invested;
72 
73 }
74 
75 // File: contracts/math/SafeMath.sol
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return a / b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 // File: contracts/token/ERC20Basic.sol
128 
129 /**
130  * @title ERC20Basic
131  * @dev Simpler version of ERC20 interface
132  * See https://github.com/ethereum/EIPs/issues/179
133  */
134 contract ERC20Basic {
135   function totalSupply() public view returns (uint256);
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 // File: contracts/token/BasicToken.sol
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev Total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 // File: contracts/token/ERC20.sol
188 
189 /**
190  * @title ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/20
192  */
193 contract ERC20 is ERC20Basic {
194   function allowance(address owner, address spender)
195     public view returns (uint256);
196 
197   function transferFrom(address from, address to, uint256 value)
198     public returns (bool);
199 
200   function approve(address spender, uint256 value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 // File: contracts/token/StandardToken.sol
209 
210 /**
211  * @title Standard ERC20 token
212  *
213  * @dev Implementation of the basic standard token.
214  * https://github.com/ethereum/EIPs/issues/20
215  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
216  */
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_to != address(0));
237     require(_value <= balances[_from]);
238     require(_value <= allowed[_from][msg.sender]);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address _owner,
270     address _spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(
289     address _spender,
290     uint256 _addedValue
291   )
292     public
293     returns (bool)
294   {
295     allowed[msg.sender][_spender] = (
296       allowed[msg.sender][_spender].add(_addedValue));
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(
311     address _spender,
312     uint256 _subtractedValue
313   )
314     public
315     returns (bool)
316   {
317     uint256 oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue > oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327 }
328 
329 // File: contracts/MintableToken.sol
330 
331 contract MintableToken is StandardToken, Ownable {
332 
333   event Mint(address indexed to, uint256 amount);
334 
335   event MintFinished();
336 
337   bool public mintingFinished = false;
338 
339   address public saleAgent;
340 
341   mapping(address => bool) public unlockedAddressesDuringITO;
342 
343   address[] public tokenHolders;
344 
345   modifier onlyOwnerOrSaleAgent() {
346     require(msg.sender == saleAgent || msg.sender == owner);
347     _;
348   }
349 
350   function unlockAddressDuringITO(address addressToUnlock) public onlyOwnerOrSaleAgent {
351     unlockedAddressesDuringITO[addressToUnlock] = true;
352   }
353 
354   modifier notLocked(address sender) {
355     require(mintingFinished ||
356             sender == saleAgent || 
357             sender == owner ||
358             (!mintingFinished && unlockedAddressesDuringITO[sender]));
359     _;
360   }
361 
362   function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {
363     saleAgent = newSaleAgnet;
364   }
365 
366   function mint(address _to, uint256 _amount) public returns (bool) {
367     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
368     if(balances[_to] == 0) tokenHolders.push(_to);
369     totalSupply_ = totalSupply_.add(_amount);
370     balances[_to] = balances[_to].add(_amount);
371     emit Mint(_to, _amount);
372     emit Transfer(address(0), _to, _amount);
373     return true;
374   }
375 
376   /**
377    * @dev Function to stop minting new tokens.
378    * @return True if the operation was successful.
379    */
380   function finishMinting() public returns (bool) {
381     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
382     mintingFinished = true;
383     emit MintFinished();
384     return true;
385   }
386 
387   function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {
388     return super.transfer(_to, _value);
389   }
390 
391   function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {
392     return super.transferFrom(from, to, value);
393   }
394 
395 }
396 
397 // File: contracts/TokenProvider.sol
398 
399 contract TokenProvider is Ownable {
400 
401   MintableToken public token;
402 
403   function setToken(address newToken) public onlyOwner {
404     token = MintableToken(newToken);
405   }
406 
407 }
408 
409 // File: contracts/MintTokensInterface.sol
410 
411 contract MintTokensInterface is TokenProvider {
412 
413   function mintTokens(address to, uint tokens) internal;
414 
415 }
416 
417 // File: contracts/MintTokensFeature.sol
418 
419 contract MintTokensFeature is MintTokensInterface {
420 
421   function mintTokens(address to, uint tokens) internal {
422     token.mint(to, tokens);
423   }
424 
425   function mintTokensBatch(uint amount, address[] to) public onlyOwner {
426     for(uint i = 0; i < to.length; i++) {
427       token.mint(to[i], amount);
428     }
429   }
430 
431 }
432 
433 // File: contracts/PercentRateProvider.sol
434 
435 contract PercentRateProvider is Ownable {
436 
437   uint public percentRate = 100;
438 
439   function setPercentRate(uint newPercentRate) public onlyOwner {
440     percentRate = newPercentRate;
441   }
442 
443 }
444 
445 // File: contracts/RetrieveTokensFeature.sol
446 
447 contract RetrieveTokensFeature is Ownable {
448 
449   function retrieveTokens(address to, address anotherToken) public onlyOwner {
450     ERC20 alienToken = ERC20(anotherToken);
451     alienToken.transfer(to, alienToken.balanceOf(this));
452   }
453 
454 }
455 
456 // File: contracts/WalletProvider.sol
457 
458 contract WalletProvider is Ownable {
459 
460   address public wallet;
461 
462   function setWallet(address newWallet) public onlyOwner {
463     wallet = newWallet;
464   }
465 
466 }
467 
468 // File: contracts/CommonSale.sol
469 
470 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature, MintTokensFeature {
471 
472   using SafeMath for uint;
473 
474   address public directMintAgent;
475 
476   uint public price;
477 
478   uint public start;
479 
480   uint public minInvestedLimit;
481 
482   uint public hardcap;
483 
484   modifier isUnderHardcap() {
485     require(invested <= hardcap);
486     _;
487   }
488 
489   function setHardcap(uint newHardcap) public onlyOwner {
490     hardcap = newHardcap;
491   }
492 
493   modifier onlyDirectMintAgentOrOwner() {
494     require(directMintAgent == msg.sender || owner == msg.sender);
495     _;
496   }
497 
498   modifier minInvestLimited(uint value) {
499     require(value >= minInvestedLimit);
500     _;
501   }
502 
503   function setStart(uint newStart) public onlyOwner {
504     start = newStart;
505   }
506 
507   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
508     minInvestedLimit = newMinInvestedLimit;
509   }
510 
511   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
512     directMintAgent = newDirectMintAgent;
513   }
514 
515   function setPrice(uint newPrice) public onlyOwner {
516     price = newPrice;
517   }
518 
519   function setToken(address newToken) public onlyOwner {
520     token = MintableToken(newToken);
521   }
522 
523   function calculateTokens(uint _invested) internal returns(uint);
524 
525   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
526     mintTokens(to, tokens);
527   }
528 
529   function endSaleDate() public view returns(uint);
530 
531   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner {
532     updateInvested(_invested);
533     mintTokensByETH(to, _invested);
534   }
535 
536   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
537     uint tokens = calculateTokens(_invested);
538     mintTokens(to, tokens);
539     return tokens;
540   }
541 
542   function updateInvested(uint value) internal {
543     invested = invested.add(value);
544   }
545 
546   function fallback() internal minInvestLimited(msg.value) returns(uint) {
547     require(now >= start && now < endSaleDate());
548     wallet.transfer(msg.value);
549     updateInvested(msg.value);
550     return mintTokensByETH(msg.sender, msg.value);
551   }
552 
553   function () public payable {
554     fallback();
555   }
556 
557 }
558 
559 // File: contracts/AssembledCommonSale.sol
560 
561 contract AssembledCommonSale is CommonSale {
562 
563 }
564 
565 // File: contracts/WalletsPercents.sol
566 
567 contract WalletsPercents is Ownable {
568 
569   address[] public wallets;
570 
571   mapping (address => uint) percents;
572 
573   function addWallet(address wallet, uint percent) public onlyOwner {
574     wallets.push(wallet);
575     percents[wallet] = percent;
576   }
577  
578   function cleanWallets() public onlyOwner {
579     wallets.length = 0;
580   }
581 
582 
583 }
584 
585 // File: contracts/ExtendedWalletsMintTokensFeature.sol
586 
587 contract ExtendedWalletsMintTokensFeature is MintTokensInterface, WalletsPercents {
588 
589   using SafeMath for uint;
590 
591   uint public percentRate = 100;
592 
593   function mintExtendedTokens() public onlyOwner {
594     uint summaryTokensPercent = 0;
595     for(uint i = 0; i < wallets.length; i++) {
596       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
597     }
598     uint mintedTokens = token.totalSupply();
599     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
600     for(uint k = 0; k < wallets.length; k++) {
601       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
602     }
603 
604   }
605 
606 }
607 
608 // File: contracts/StagedCrowdsale.sol
609 
610 contract StagedCrowdsale is Ownable {
611 
612   using SafeMath for uint;
613 
614   struct Milestone {
615     uint period;
616     uint bonus;
617   }
618 
619   uint public totalPeriod;
620 
621   Milestone[] public milestones;
622 
623   function milestonesCount() public view returns(uint) {
624     return milestones.length;
625   }
626 
627   function addMilestone(uint period, uint bonus) public onlyOwner {
628     require(period > 0);
629     milestones.push(Milestone(period, bonus));
630     totalPeriod = totalPeriod.add(period);
631   }
632 
633   function removeMilestone(uint8 number) public onlyOwner {
634     require(number < milestones.length);
635     Milestone storage milestone = milestones[number];
636     totalPeriod = totalPeriod.sub(milestone.period);
637 
638     delete milestones[number];
639 
640     for (uint i = number; i < milestones.length - 1; i++) {
641       milestones[i] = milestones[i+1];
642     }
643 
644     milestones.length--;
645   }
646 
647   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
648     require(number < milestones.length);
649     Milestone storage milestone = milestones[number];
650 
651     totalPeriod = totalPeriod.sub(milestone.period);
652 
653     milestone.period = period;
654     milestone.bonus = bonus;
655 
656     totalPeriod = totalPeriod.add(period);
657   }
658 
659   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
660     require(numberAfter < milestones.length);
661 
662     totalPeriod = totalPeriod.add(period);
663 
664     milestones.length++;
665 
666     for (uint i = milestones.length - 2; i > numberAfter; i--) {
667       milestones[i + 1] = milestones[i];
668     }
669 
670     milestones[numberAfter + 1] = Milestone(period, bonus);
671   }
672 
673   function clearMilestones() public onlyOwner {
674     require(milestones.length > 0);
675     for (uint i = 0; i < milestones.length; i++) {
676       delete milestones[i];
677     }
678     milestones.length -= milestones.length;
679     totalPeriod = 0;
680   }
681 
682   function lastSaleDate(uint start) public view returns(uint) {
683     return start + totalPeriod * 1 days;
684   }
685 
686   function currentMilestone(uint start) public view returns(uint) {
687     uint previousDate = start;
688     for(uint i=0; i < milestones.length; i++) {
689       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
690         return i;
691       }
692       previousDate = previousDate.add(milestones[i].period * 1 days);
693     }
694     revert();
695   }
696 
697 }
698 
699 // File: contracts/ITO.sol
700 
701 contract ITO is ExtendedWalletsMintTokensFeature, StagedCrowdsale, AssembledCommonSale {
702 
703   function endSaleDate() public view returns(uint) {
704     return lastSaleDate(start);
705   }
706 
707   function calculateTokens(uint _invested) internal returns(uint) {
708     uint milestoneIndex = currentMilestone(start);
709     Milestone storage milestone = milestones[milestoneIndex];
710     uint tokens = _invested.mul(price).div(1 ether);
711     if(milestone.bonus > 0) {
712       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
713     }
714     return tokens;
715   }
716 
717   function finish() public onlyOwner {
718     mintExtendedTokens();
719     token.finishMinting();
720   }
721 
722 }
723 
724 // File: contracts/NextSaleAgentFeature.sol
725 
726 contract NextSaleAgentFeature is Ownable {
727 
728   address public nextSaleAgent;
729 
730   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
731     nextSaleAgent = newNextSaleAgent;
732   }
733 
734 }
735 
736 // File: contracts/SoftcapFeature.sol
737 
738 contract SoftcapFeature is InvestedProvider, WalletProvider {
739 
740   using SafeMath for uint;
741 
742   mapping(address => uint) public balances;
743 
744   bool public softcapAchieved;
745 
746   bool public refundOn;
747 
748   uint public softcap;
749 
750   uint public constant devLimit = 22500000000000000000;
751 
752   bool public devFeePaid;
753 
754   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
755 
756   function setSoftcap(uint newSoftcap) public onlyOwner {
757     softcap = newSoftcap;
758   }
759 
760   function withdraw() public {
761     require(msg.sender == owner || msg.sender == devWallet);
762     require(softcapAchieved);
763     if(!devFeePaid) {
764       devWallet.transfer(devLimit);
765       devFeePaid = true;
766     }
767     wallet.transfer(address(this).balance);
768   }
769 
770   function updateBalance(address to, uint amount) internal {
771     balances[to] = balances[to].add(amount);
772     if (!softcapAchieved && invested >= softcap) {
773       softcapAchieved = true;
774     }
775   }
776 
777   function refund() public {
778     require(refundOn && balances[msg.sender] > 0);
779     uint value = balances[msg.sender];
780     balances[msg.sender] = 0;
781     msg.sender.transfer(value);
782   }
783 
784   function updateRefundState() internal returns(bool) {
785     if (!softcapAchieved) {
786       refundOn = true;
787     }
788     return refundOn;
789   }
790 
791 }
792 
793 // File: contracts/PreITO.sol
794 
795 contract PreITO is NextSaleAgentFeature, SoftcapFeature, AssembledCommonSale {
796 
797   uint public period;
798 
799   function calculateTokens(uint _invested) internal returns(uint) {
800     return _invested.mul(price).div(1 ether);
801   }
802 
803   function setPeriod(uint newPeriod) public onlyOwner {
804     period = newPeriod;
805   }
806 
807   function endSaleDate() public view returns(uint) {
808     return start.add(period * 1 days);
809   }
810   
811   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
812     uint _tokens = super.mintTokensByETH(to, _invested);
813     updateBalance(to, _invested);
814     return _tokens;
815   }
816 
817   function finish() public onlyOwner {
818     if (updateRefundState()) {
819       token.finishMinting();
820     } else {
821       withdraw();
822       token.setSaleAgent(nextSaleAgent);
823     }
824   }
825 
826   function fallback() internal minInvestLimited(msg.value) returns(uint) {
827     require(now >= start && now < endSaleDate());
828     updateInvested(msg.value);
829     return mintTokensByETH(msg.sender, msg.value);
830   }
831 
832 }
833 
834 // File: contracts/ReceivingContractCallback.sol
835 
836 contract ReceivingContractCallback {
837 
838   function tokenFallback(address _from, uint _value) public;
839 
840 }
841 
842 // File: contracts/Token.sol
843 
844 contract Token is MintableToken {
845 
846   string public constant name = "FRSCoin";
847 
848   string public constant symbol = "FRS";
849 
850   uint32 public constant decimals = 18;
851 
852   mapping(address => bool)  public registeredCallbacks;
853 
854   function transfer(address _to, uint256 _value) public returns (bool) {
855     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
856   }
857 
858   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
859     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
860   }
861 
862   function registerCallback(address callback) public onlyOwner {
863     registeredCallbacks[callback] = true;
864   }
865 
866   function deregisterCallback(address callback) public onlyOwner {
867     registeredCallbacks[callback] = false;
868   }
869 
870   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
871     if (result && registeredCallbacks[to]) {
872       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
873       targetCallback.tokenFallback(from, value);
874     }
875     return result;
876   }
877 
878 }
879 
880 // File: contracts/Configurator.sol
881 
882 contract Configurator is Ownable {
883 
884   Token public token;
885 
886   PreITO public preITO;
887 
888   ITO public ito;
889 
890   function deploy() public onlyOwner {
891 
892     token = new Token();
893 
894     preITO = new PreITO();
895 
896     preITO.setWallet(0x89C92383bCF3EecD5180aBd055Bf319ceFD2D516);
897     preITO.setStart(1531612800);
898     preITO.setPeriod(48);
899     preITO.setPrice(1080000000000000000000);
900     preITO.setMinInvestedLimit(100000000000000000);
901     preITO.setSoftcap(1000000000000000000000);
902     preITO.setHardcap(4000000000000000000000);
903     preITO.setToken(token);
904     preITO.setDirectMintAgent(0xF3D57FC2903Cbdfe1e1d33bE38Ad0A0753E72406);
905 
906     token.setSaleAgent(preITO);
907 
908     ito = new ITO();
909 
910     ito.setWallet(0xb13a4803bcC374B8BbCaf625cdD0a3Ac85CdC0DA);
911     ito.setStart(1535760000);
912     ito.addMilestone(7, 15);
913     ito.addMilestone(7, 13);
914     ito.addMilestone(7, 11);
915     ito.addMilestone(7, 9);
916     ito.addMilestone(7, 7);
917     ito.addMilestone(7, 5);
918     ito.addMilestone(7, 3);
919     ito.setPrice(900000000000000000000);
920     ito.setMinInvestedLimit(100000000000000000);
921     ito.setHardcap(32777000000000000000000);
922     ito.addWallet(0xA5A5cf5325AeDA4aB32b9b0E0E8fa91aBDb64DdC, 10);
923     ito.setToken(token);
924     ito.setDirectMintAgent(0xF3D57FC2903Cbdfe1e1d33bE38Ad0A0753E72406);
925 
926     preITO.setNextSaleAgent(ito);
927 
928     address manager = 0xd8Fe93097F0Ef354fEfee2e77458eeCc19D8D704;
929 
930     token.transferOwnership(manager);
931     preITO.transferOwnership(manager);
932     ito.transferOwnership(manager);
933   }
934 
935 }