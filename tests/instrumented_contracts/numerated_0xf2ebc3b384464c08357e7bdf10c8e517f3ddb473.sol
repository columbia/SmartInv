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
47 // File: contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: contracts/MintableToken.sol
245 
246 contract MintableToken is StandardToken, Ownable {
247 
248   event Mint(address indexed to, uint256 amount);
249 
250   event MintFinished();
251 
252   bool public mintingFinished = false;
253 
254   address public saleAgent;
255 
256   modifier notLocked() {
257     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
258     _;
259   }
260 
261   function setSaleAgent(address newSaleAgnet) public {
262     require(msg.sender == saleAgent || msg.sender == owner);
263     saleAgent = newSaleAgnet;
264   }
265 
266   function mint(address _to, uint256 _amount) public returns (bool) {
267     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
268     
269     totalSupply = totalSupply.add(_amount);
270     balances[_to] = balances[_to].add(_amount);
271     Mint(_to, _amount);
272     return true;
273   }
274 
275   /**
276    * @dev Function to stop minting new tokens.
277    * @return True if the operation was successful.
278    */
279   function finishMinting() public returns (bool) {
280     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
281     mintingFinished = true;
282     MintFinished();
283     return true;
284   }
285 
286   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
291     return super.transferFrom(from, to, value);
292   }
293 
294 }
295 
296 // File: contracts/ReceivingContractCallback.sol
297 
298 contract ReceivingContractCallback {
299 
300   function tokenFallback(address _from, uint _value) public;
301 
302 }
303 
304 // File: contracts/BuyAndSellToken.sol
305 
306 contract BuyAndSellToken is MintableToken {
307 
308   string public constant name = "BUY&SELL Token";
309 
310   string public constant symbol = "BAS";
311 
312   uint32 public constant decimals = 18;
313 
314   mapping(address => bool)  public registeredCallbacks;
315 
316   function transfer(address _to, uint256 _value) public returns (bool) {
317     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
318   }
319 
320   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
321     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
322   }
323 
324   function registerCallback(address callback) public onlyOwner {
325     registeredCallbacks[callback] = true;
326   }
327 
328   function deregisterCallback(address callback) public onlyOwner {
329     registeredCallbacks[callback] = false;
330   }
331 
332   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
333     if (result && registeredCallbacks[to]) {
334       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
335       targetCallback.tokenFallback(from, value);
336     }
337     return result;
338   }
339 
340 }
341 
342 // File: contracts/InvestedProvider.sol
343 
344 contract InvestedProvider is Ownable {
345 
346   uint public invested;
347 
348 }
349 
350 // File: contracts/PercentRateProvider.sol
351 
352 contract PercentRateProvider is Ownable {
353 
354   uint public percentRate = 100;
355 
356   function setPercentRate(uint newPercentRate) public onlyOwner {
357     percentRate = newPercentRate;
358   }
359 
360 }
361 
362 // File: contracts/RetrieveTokensFeature.sol
363 
364 contract RetrieveTokensFeature is Ownable {
365 
366   function retrieveTokens(address to, address anotherToken) public onlyOwner {
367     ERC20 alienToken = ERC20(anotherToken);
368     alienToken.transfer(to, alienToken.balanceOf(this));
369   }
370 
371 }
372 
373 // File: contracts/WalletProvider.sol
374 
375 contract WalletProvider is Ownable {
376 
377   address public wallet;
378 
379   function setWallet(address newWallet) public onlyOwner {
380     wallet = newWallet;
381   }
382 
383 }
384 
385 // File: contracts/CommonSale.sol
386 
387 contract CommonSale is InvestedProvider, WalletProvider, PercentRateProvider, RetrieveTokensFeature {
388 
389   using SafeMath for uint;
390 
391   address public directMintAgent;
392 
393   uint public price;
394 
395   uint public start;
396 
397   uint public minInvestedLimit;
398 
399   MintableToken public token;
400 
401   uint public hardcap;
402 
403   modifier isUnderHardcap() {
404     require(invested < hardcap);
405     _;
406   }
407 
408   function setHardcap(uint newHardcap) public onlyOwner {
409     hardcap = newHardcap;
410   }
411 
412   modifier onlyDirectMintAgentOrOwner() {
413     require(directMintAgent == msg.sender || owner == msg.sender);
414     _;
415   }
416 
417   modifier minInvestLimited(uint value) {
418     require(value >= minInvestedLimit);
419     _;
420   }
421 
422   function setStart(uint newStart) public onlyOwner {
423     start = newStart;
424   }
425 
426   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
427     minInvestedLimit = newMinInvestedLimit;
428   }
429 
430   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
431     directMintAgent = newDirectMintAgent;
432   }
433 
434   function setPrice(uint newPrice) public onlyOwner {
435     price = newPrice;
436   }
437 
438   function setToken(address newToken) public onlyOwner {
439     token = MintableToken(newToken);
440   }
441 
442   function calculateTokens(uint _invested) internal returns(uint);
443 
444   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
445     mintTokens(to, tokens);
446   }
447 
448   function mintTokens(address to, uint tokens) internal {
449     token.mint(this, tokens);
450     token.transfer(to, tokens);
451   }
452 
453   function endSaleDate() public view returns(uint);
454 
455   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
456     return mintTokensByETH(to, _invested);
457   }
458 
459   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
460     invested = invested.add(_invested);
461     uint tokens = calculateTokens(_invested);
462     mintTokens(to, tokens);
463     return tokens;
464   }
465 
466   function fallback() internal minInvestLimited(msg.value) returns(uint) {
467     require(now >= start && now < endSaleDate());
468     wallet.transfer(msg.value);
469     return mintTokensByETH(msg.sender, msg.value);
470   }
471 
472   function () public payable {
473     fallback();
474   }
475 
476 }
477 
478 // File: contracts/StagedCrowdsale.sol
479 
480 contract StagedCrowdsale is Ownable {
481 
482   using SafeMath for uint;
483 
484   struct Milestone {
485     uint period;
486     uint bonus;
487   }
488 
489   uint public totalPeriod;
490 
491   Milestone[] public milestones;
492 
493   function milestonesCount() public view returns(uint) {
494     return milestones.length;
495   }
496 
497   function addMilestone(uint period, uint bonus) public onlyOwner {
498     require(period > 0);
499     milestones.push(Milestone(period, bonus));
500     totalPeriod = totalPeriod.add(period);
501   }
502 
503   function removeMilestone(uint8 number) public onlyOwner {
504     require(number < milestones.length);
505     Milestone storage milestone = milestones[number];
506     totalPeriod = totalPeriod.sub(milestone.period);
507 
508     delete milestones[number];
509 
510     for (uint i = number; i < milestones.length - 1; i++) {
511       milestones[i] = milestones[i+1];
512     }
513 
514     milestones.length--;
515   }
516 
517   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
518     require(number < milestones.length);
519     Milestone storage milestone = milestones[number];
520 
521     totalPeriod = totalPeriod.sub(milestone.period);
522 
523     milestone.period = period;
524     milestone.bonus = bonus;
525 
526     totalPeriod = totalPeriod.add(period);
527   }
528 
529   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
530     require(numberAfter < milestones.length);
531 
532     totalPeriod = totalPeriod.add(period);
533 
534     milestones.length++;
535 
536     for (uint i = milestones.length - 2; i > numberAfter; i--) {
537       milestones[i + 1] = milestones[i];
538     }
539 
540     milestones[numberAfter + 1] = Milestone(period, bonus);
541   }
542 
543   function clearMilestones() public onlyOwner {
544     require(milestones.length > 0);
545     for (uint i = 0; i < milestones.length; i++) {
546       delete milestones[i];
547     }
548     milestones.length -= milestones.length;
549     totalPeriod = 0;
550   }
551 
552   function lastSaleDate(uint start) public view returns(uint) {
553     return start + totalPeriod * 1 days;
554   }
555 
556   function currentMilestone(uint start) public view returns(uint) {
557     uint previousDate = start;
558     for(uint i=0; i < milestones.length; i++) {
559       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
560         return i;
561       }
562       previousDate = previousDate.add(milestones[i].period * 1 days);
563     }
564     revert();
565   }
566 
567 }
568 
569 // File: contracts/BASCommonSale.sol
570 
571 contract BASCommonSale is StagedCrowdsale, CommonSale {
572 
573   function calculateTokens(uint _invested) internal returns(uint) {
574     uint milestoneIndex = currentMilestone(start);
575     Milestone storage milestone = milestones[milestoneIndex];
576 
577     uint tokens = _invested.mul(price).div(1 ether);
578     if(milestone.bonus > 0) {
579       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
580     }
581     return tokens;
582   }
583 
584   function endSaleDate() public view returns(uint) {
585     return lastSaleDate(start);
586   }
587 
588 }
589 
590 // File: contracts/ICO.sol
591 
592 contract ICO is BASCommonSale {
593 
594   function finish() public onlyOwner {
595      token.finishMinting();
596   }
597 
598 }
599 
600 // File: contracts/NextSaleAgentFeature.sol
601 
602 contract NextSaleAgentFeature is Ownable {
603 
604   address public nextSaleAgent;
605 
606   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
607     nextSaleAgent = newNextSaleAgent;
608   }
609 
610 }
611 
612 // File: contracts/SoftcapFeature.sol
613 
614 contract SoftcapFeature is InvestedProvider, WalletProvider {
615 
616   using SafeMath for uint;
617 
618   mapping(address => uint) public balances;
619 
620   bool public softcapAchieved;
621 
622   bool public refundOn;
623 
624   uint public softcap;
625 
626   uint public constant devLimit = 4500000000000000000;
627 
628   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
629 
630   function setSoftcap(uint newSoftcap) public onlyOwner {
631     softcap = newSoftcap;
632   }
633 
634   function withdraw() public {
635     require(msg.sender == owner || msg.sender == devWallet);
636     require(softcapAchieved);
637     devWallet.transfer(devLimit);
638     wallet.transfer(this.balance);
639   }
640 
641   function updateBalance(address to, uint amount) internal {
642     balances[to] = balances[to].add(amount);
643     if (!softcapAchieved && invested >= softcap) {
644       softcapAchieved = true;
645     }
646   }
647 
648   function refund() public {
649     require(refundOn && balances[msg.sender] > 0);
650     uint value = balances[msg.sender];
651     balances[msg.sender] = 0;
652     msg.sender.transfer(value);
653   }
654 
655   function updateRefundState() internal returns(bool) {
656     if (!softcapAchieved) {
657       refundOn = true;
658     }
659     return refundOn;
660   }
661 
662 }
663 
664 // File: contracts/PreICO.sol
665 
666 contract PreICO is NextSaleAgentFeature, SoftcapFeature, BASCommonSale {
667 
668   address public bountyTokensWallet;
669 
670   address public advisorsTokensWallet;
671 
672   address public developersTokensWallet;
673 
674   uint public bountyTokens;
675 
676   uint public advisorsTokens;
677 
678   uint public developersTokens;
679 
680   bool public extraMinted;
681 
682   function setBountyTokens(uint newBountyTokens) public onlyOwner {
683     bountyTokens = newBountyTokens;
684   }
685 
686   function setAdvisorsTokens(uint newAdvisorsTokens) public onlyOwner {
687     advisorsTokens = newAdvisorsTokens;
688   }
689 
690   function setDevelopersTokens(uint newDevelopersTokens) public onlyOwner {
691     developersTokens = newDevelopersTokens;
692   }
693 
694   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
695     bountyTokensWallet = newBountyTokensWallet;
696   }
697 
698   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
699     advisorsTokensWallet = newAdvisorsTokensWallet;
700   }
701 
702   function setDevelopersTokensWallet(address newDevelopersTokensWallet) public onlyOwner {
703     developersTokensWallet = newDevelopersTokensWallet;
704   }
705 
706   function mintExtraTokens() public onlyOwner {
707     require(!extraMinted);
708     mintTokens(bountyTokensWallet, bountyTokens);
709     mintTokens(advisorsTokensWallet, advisorsTokens);
710     mintTokens(developersTokensWallet, developersTokens);
711     extraMinted = true;
712   }
713 
714   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
715     uint _tokens = super.mintTokensByETH(to, _invested);
716     updateBalance(to, _invested);
717     return _tokens;
718   }
719 
720   function finish() public onlyOwner {
721     if (updateRefundState()) {
722       token.finishMinting();
723     } else {
724       withdraw();
725       token.setSaleAgent(nextSaleAgent);
726     }
727   }
728 
729   function fallback() internal minInvestLimited(msg.value) returns(uint) {
730     require(now >= start && now < endSaleDate());
731     return mintTokensByETH(msg.sender, msg.value);
732   }
733 
734 }
735 
736 // File: contracts/Configurator.sol
737 
738 contract Configurator is Ownable {
739 
740   BuyAndSellToken public token;
741 
742   PreICO public preICO;
743 
744   ICO public ico;
745 
746   function deploy() public onlyOwner {
747 
748     address manager = 0xb3e3fFeE7bcEC75cbC98bf6Fa5Eb35488b0a0904;
749 
750     token = new BuyAndSellToken();
751     preICO = new PreICO();
752     ico = new ICO();
753 
754     token.setSaleAgent(preICO);
755 
756     preICO.setStart(1526428800); // 16 May 2018 00:00:00 GMT
757     preICO.addMilestone(1, 40);
758     preICO.addMilestone(13, 30);
759     preICO.setToken(token);
760     preICO.setPrice(9000000000000000000000);
761     preICO.setHardcap(16000000000000000000000);
762     preICO.setSoftcap(500000000000000000000);
763     preICO.setMinInvestedLimit(100000000000000000);
764     preICO.setWallet(0x1cbeeCf1b8a71E7CEB7Bc7dFcf76f7aA1092EA42);
765     preICO.setBountyTokensWallet(0x040Dd0f72c2350DCC043E45b8f9425E16190D7e3);
766     preICO.setAdvisorsTokensWallet(0x9dd06c9697c5c4fc9D4D526b4976Bf5A9960FE55);
767     preICO.setDevelopersTokensWallet(0x9fb9B9a8ABdA6626d5d739E7A1Ed80F519ac156D);
768     preICO.setBountyTokens(7200000000000000000000000);
769     preICO.setAdvisorsTokens(4800000000000000000000000);
770     preICO.setDevelopersTokens(48000000000000000000000000);
771     preICO.setNextSaleAgent(ico);
772 
773     preICO.mintExtraTokens();
774 
775     ico.setStart(1529107200); // 16 Jun 2018 00:00:00 GMT
776     ico.addMilestone(7, 25);
777     ico.addMilestone(7, 15);
778     ico.addMilestone(14, 10);
779     ico.setToken(token);
780     ico.setPrice(4500000000000000000000);
781     ico.setHardcap(24000000000000000000000);
782     ico.setMinInvestedLimit(100000000000000000);
783     ico.setWallet(0x4cF77fF6230A31280F886b5D7dc7324c22443eB5);
784 
785     token.transferOwnership(manager);
786     preICO.transferOwnership(manager);
787     ico.transferOwnership(manager);
788   }
789 
790 }