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
47 // File: contracts/token/ERC20Basic.sol
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   uint256 public totalSupply;
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 // File: contracts/token/ERC20.sol
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 // File: contracts/RetrieveTokenFeature.sol
75 
76 contract RetrieveTokenFeature is Ownable {
77 
78   function retrieveTokens(address to, address anotherToken) public onlyOwner {
79     ERC20 alienToken = ERC20(anotherToken);
80     alienToken.transfer(to, alienToken.balanceOf(this));
81   }
82 
83 }
84 
85 // File: contracts/math/SafeMath.sol
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   function div(uint256 a, uint256 b) internal pure returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106   }
107 
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint256 a, uint256 b) internal pure returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 // File: contracts/StagedCrowdsale.sol
121 
122 contract StagedCrowdsale is RetrieveTokenFeature {
123 
124   using SafeMath for uint;
125 
126   struct Milestone {
127     uint period;
128     uint bonus;
129   }
130 
131   uint public start;
132 
133   uint public totalPeriod;
134 
135   uint public invested;
136 
137   uint public hardCap;
138 
139   Milestone[] public milestones;
140 
141   function milestonesCount() public constant returns(uint) {
142     return milestones.length;
143   }
144 
145   function setStart(uint newStart) public onlyOwner {
146     start = newStart;
147   }
148 
149   function setHardcap(uint newHardcap) public onlyOwner {
150     hardCap = newHardcap;
151   }
152 
153   function addMilestone(uint period, uint bonus) public onlyOwner {
154     require(period > 0);
155     milestones.push(Milestone(period, bonus));
156     totalPeriod = totalPeriod.add(period);
157   }
158 
159   function removeMilestone(uint8 number) public onlyOwner {
160     require(number < milestones.length);
161     Milestone storage milestone = milestones[number];
162     totalPeriod = totalPeriod.sub(milestone.period);
163 
164     delete milestones[number];
165 
166     for (uint i = number; i < milestones.length - 1; i++) {
167       milestones[i] = milestones[i+1];
168     }
169 
170     milestones.length--;
171   }
172 
173   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
174     require(number < milestones.length);
175     Milestone storage milestone = milestones[number];
176 
177     totalPeriod = totalPeriod.sub(milestone.period);
178 
179     milestone.period = period;
180     milestone.bonus = bonus;
181 
182     totalPeriod = totalPeriod.add(period);
183   }
184 
185   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
186     require(numberAfter < milestones.length);
187 
188     totalPeriod = totalPeriod.add(period);
189 
190     milestones.length++;
191 
192     for (uint i = milestones.length - 2; i > numberAfter; i--) {
193       milestones[i + 1] = milestones[i];
194     }
195 
196     milestones[numberAfter + 1] = Milestone(period, bonus);
197   }
198 
199   function clearMilestones() public onlyOwner {
200     require(milestones.length > 0);
201     for (uint i = 0; i < milestones.length; i++) {
202       delete milestones[i];
203     }
204     milestones.length -= milestones.length;
205     totalPeriod = 0;
206   }
207 
208   modifier saleIsOn() {
209     require(milestones.length > 0 && now >= start && now < lastSaleDate());
210     _;
211   }
212 
213   modifier isUnderHardCap() {
214     require(invested <= hardCap);
215     _;
216   }
217 
218   function lastSaleDate() public constant returns(uint) {
219     require(milestones.length > 0);
220     return start + totalPeriod * 1 days;
221   }
222 
223   function currentMilestone() public saleIsOn constant returns(uint) {
224     uint previousDate = start;
225     for(uint i=0; i < milestones.length; i++) {
226       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
227         return i;
228       }
229       previousDate = previousDate.add(milestones[i].period * 1 days);
230     }
231     revert();
232   }
233 
234 }
235 
236 // File: contracts/WalletProvider.sol
237 
238 contract WalletProvider is Ownable {
239 
240   address public wallet;
241 
242   function setWallet(address newWallet) public onlyOwner {
243     wallet = newWallet;
244   }
245 
246 }
247 
248 // File: contracts/token/BasicToken.sol
249 
250 /**
251  * @title Basic token
252  * @dev Basic version of StandardToken, with no allowances.
253  */
254 contract BasicToken is ERC20Basic {
255   using SafeMath for uint256;
256 
257   mapping(address => uint256) balances;
258 
259   /**
260   * @dev transfer token for a specified address
261   * @param _to The address to transfer to.
262   * @param _value The amount to be transferred.
263   */
264   function transfer(address _to, uint256 _value) public returns (bool) {
265     require(_to != address(0));
266     require(_value <= balances[msg.sender]);
267 
268     // SafeMath.sub will throw if there is not enough balance.
269     balances[msg.sender] = balances[msg.sender].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     Transfer(msg.sender, _to, _value);
272     return true;
273   }
274 
275   /**
276   * @dev Gets the balance of the specified address.
277   * @param _owner The address to query the the balance of.
278   * @return An uint256 representing the amount owned by the passed address.
279   */
280   function balanceOf(address _owner) public view returns (uint256 balance) {
281     return balances[_owner];
282   }
283 
284 }
285 
286 // File: contracts/token/StandardToken.sol
287 
288 /**
289  * @title Standard ERC20 token
290  *
291  * @dev Implementation of the basic standard token.
292  * @dev https://github.com/ethereum/EIPs/issues/20
293  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
294  */
295 contract StandardToken is ERC20, BasicToken {
296 
297   mapping (address => mapping (address => uint256)) internal allowed;
298 
299 
300   /**
301    * @dev Transfer tokens from one address to another
302    * @param _from address The address which you want to send tokens from
303    * @param _to address The address which you want to transfer to
304    * @param _value uint256 the amount of tokens to be transferred
305    */
306   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
307     require(_to != address(0));
308     require(_value <= balances[_from]);
309     require(_value <= allowed[_from][msg.sender]);
310 
311     balances[_from] = balances[_from].sub(_value);
312     balances[_to] = balances[_to].add(_value);
313     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
314     Transfer(_from, _to, _value);
315     return true;
316   }
317 
318   /**
319    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
320    *
321    * Beware that changing an allowance with this method brings the risk that someone may use both the old
322    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
323    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
324    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325    * @param _spender The address which will spend the funds.
326    * @param _value The amount of tokens to be spent.
327    */
328   function approve(address _spender, uint256 _value) public returns (bool) {
329     allowed[msg.sender][_spender] = _value;
330     Approval(msg.sender, _spender, _value);
331     return true;
332   }
333 
334   /**
335    * @dev Function to check the amount of tokens that an owner allowed to a spender.
336    * @param _owner address The address which owns the funds.
337    * @param _spender address The address which will spend the funds.
338    * @return A uint256 specifying the amount of tokens still available for the spender.
339    */
340   function allowance(address _owner, address _spender) public view returns (uint256) {
341     return allowed[_owner][_spender];
342   }
343 
344   /**
345    * @dev Increase the amount of tokens that an owner allowed to a spender.
346    *
347    * approve should be called when allowed[_spender] == 0. To increment
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param _spender The address which will spend the funds.
352    * @param _addedValue The amount of tokens to increase the allowance by.
353    */
354   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
355     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
356     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360   /**
361    * @dev Decrease the amount of tokens that an owner allowed to a spender.
362    *
363    * approve should be called when allowed[_spender] == 0. To decrement
364    * allowed value is better to use this function to avoid 2 calls (and wait until
365    * the first transaction is mined)
366    * From MonolithDAO Token.sol
367    * @param _spender The address which will spend the funds.
368    * @param _subtractedValue The amount of tokens to decrease the allowance by.
369    */
370   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
371     uint oldValue = allowed[msg.sender][_spender];
372     if (_subtractedValue > oldValue) {
373       allowed[msg.sender][_spender] = 0;
374     } else {
375       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
376     }
377     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
378     return true;
379   }
380 
381 }
382 
383 // File: contracts/token/MintableToken.sol
384 
385 /**
386  * @title Mintable token
387  * @dev Simple ERC20 Token example, with mintable token creation
388  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
389  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
390  */
391 
392 contract MintableToken is StandardToken, Ownable {
393   event Mint(address indexed to, uint256 amount);
394   event MintFinished();
395 
396   bool public mintingFinished = false;
397 
398 
399   modifier canMint() {
400     require(!mintingFinished);
401     _;
402   }
403 
404   /**
405    * @dev Function to mint tokens
406    * @param _to The address that will receive the minted tokens.
407    * @param _amount The amount of tokens to mint.
408    * @return A boolean that indicates if the operation was successful.
409    */
410   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
411     totalSupply = totalSupply.add(_amount);
412     balances[_to] = balances[_to].add(_amount);
413     Mint(_to, _amount);
414     Transfer(address(0), _to, _amount);
415     return true;
416   }
417 
418   /**
419    * @dev Function to stop minting new tokens.
420    * @return True if the operation was successful.
421    */
422   function finishMinting() onlyOwner canMint public returns (bool) {
423     mintingFinished = true;
424     MintFinished();
425     return true;
426   }
427 }
428 
429 // File: contracts/YayProtoToken.sol
430 
431 contract YayProtoToken is MintableToken {
432 
433   string public constant name = "YayProto";
434 
435   string public constant symbol = "YFN";
436 
437   uint32 public constant decimals = 18;
438 
439   address public saleAgent;
440 
441   modifier notLocked() {
442     require(mintingFinished || msg.sender == owner || msg.sender == saleAgent);
443     _;
444   }
445 
446   modifier onlyOwnerOrSaleAgent() {
447     require(msg.sender == owner || msg.sender == saleAgent);
448     _;
449   }
450 
451   function setSaleAgent(address newSaleAgent) public {
452     require(msg.sender == owner || msg.sender == saleAgent);
453     saleAgent = newSaleAgent;
454   }
455 
456   function mint(address _to, uint256 _amount) onlyOwnerOrSaleAgent canMint public returns (bool) {
457     totalSupply = totalSupply.add(_amount);
458     balances[_to] = balances[_to].add(_amount);
459     Mint(_to, _amount);
460     Transfer(address(0), _to, _amount);
461     return true;
462   }
463 
464   function finishMinting() onlyOwnerOrSaleAgent canMint public returns (bool) {
465     mintingFinished = true;
466     MintFinished();
467     return true;
468   }
469 
470   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
471     return super.transfer(_to, _value);
472   }
473 
474   function transferFrom(address _from, address _to, uint256 _value) public notLocked returns (bool) {
475     return super.transferFrom(_from, _to, _value);
476   }
477 
478 }
479 
480 // File: contracts/CommonSale.sol
481 
482 contract CommonSale is StagedCrowdsale, WalletProvider {
483 
484   address public directMintAgent;
485 
486   uint public percentRate = 100;
487 
488   uint public minPrice;
489 
490   uint public price;
491 
492   YayProtoToken public token;
493 
494   modifier onlyDirectMintAgentOrOwner() {
495     require(directMintAgent == msg.sender || owner == msg.sender);
496     _;
497   }
498 
499   modifier minPriceLimit() {
500     require(msg.value >= minPrice);
501     _;
502   }
503 
504   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
505     directMintAgent = newDirectMintAgent;
506   }
507 
508   function setMinPrice(uint newMinPrice) public onlyOwner {
509     minPrice = newMinPrice;
510   }
511 
512   function setPrice(uint newPrice) public onlyOwner {
513     price = newPrice;
514   }
515 
516   function setToken(address newToken) public onlyOwner {
517     token = YayProtoToken(newToken);
518   }
519 
520   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
521     mintTokens(to, investedWei);
522   }
523 
524   function mintTokens(address to, uint weiInvested) internal {
525     uint milestoneIndex = currentMilestone();
526     Milestone storage milestone = milestones[milestoneIndex];
527     invested = invested.add(msg.value);
528     uint tokens = weiInvested.mul(price).div(1 ether);
529     uint bonusTokens = tokens.mul(milestone.bonus).div(percentRate);
530     uint tokensWithBonus = tokens.add(bonusTokens);
531     createAndTransferTokens(to, tokensWithBonus);
532   }
533 
534   function createAndTransferTokens(address to, uint tokens) internal isUnderHardCap {
535     token.mint(this, tokens);
536     token.transfer(to, tokens);
537   }
538 
539 }
540 
541 // File: contracts/Mainsale.sol
542 
543 contract Mainsale is CommonSale {
544 
545   address public marketingTokensWallet;
546 
547   address public developersTokensWallet;
548 
549   address public advisorsTokensWallet;
550 
551   address public teamTokensWallet;
552 
553   uint public marketingTokensPercent;
554 
555   uint public developersTokensPercent;
556 
557   uint public advisorsTokensPercent;
558 
559   uint public teamTokensPercent;
560 
561   function setMarketingTokensPercent(uint newMarketingTokensPercent) public onlyOwner {
562     marketingTokensPercent = newMarketingTokensPercent;
563   }
564 
565   function setDevelopersTokensPercent(uint newDevelopersTokensPercent) public onlyOwner {
566     developersTokensPercent = newDevelopersTokensPercent;
567   }
568 
569   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
570     advisorsTokensPercent = newAdvisorsTokensPercent;
571   }
572 
573   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
574     teamTokensPercent = newTeamTokensPercent;
575   }
576 
577   function setMarketingTokensWallet(address newMarketingTokensWallet) public onlyOwner {
578     marketingTokensWallet = newMarketingTokensWallet;
579   }
580 
581   function setDevelopersTokensWallet(address newDevelopersTokensWallet) public onlyOwner {
582     developersTokensWallet = newDevelopersTokensWallet;
583   }
584 
585   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
586     advisorsTokensWallet = newAdvisorsTokensWallet;
587   }
588 
589   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
590     teamTokensWallet = newTeamTokensWallet;
591   }
592 
593   function finish() public onlyOwner {
594     uint extendedTokensPercent = marketingTokensPercent.add(teamTokensPercent).add(developersTokensPercent).add(advisorsTokensPercent);
595     uint allTokens = token.totalSupply().mul(percentRate).div(percentRate.sub(extendedTokensPercent));
596     createAndTransferTokens(marketingTokensWallet,allTokens.mul(marketingTokensPercent).div(percentRate));
597     createAndTransferTokens(teamTokensWallet,allTokens.mul(teamTokensPercent).div(percentRate));
598     createAndTransferTokens(developersTokensWallet,allTokens.mul(developersTokensPercent).div(percentRate));
599     createAndTransferTokens(advisorsTokensWallet,allTokens.mul(advisorsTokensPercent).div(percentRate));
600     token.finishMinting();
601   }
602 
603   function () external payable minPriceLimit {
604     wallet.transfer(msg.value);
605     mintTokens(msg.sender, msg.value);
606   }
607 
608 }
609 
610 // File: contracts/SoftcapFeature.sol
611 
612 contract SoftcapFeature is WalletProvider {
613 
614   using SafeMath for uint;
615 
616   mapping(address => uint) balances;
617 
618   bool public softcapAchieved;
619 
620   bool public refundOn;
621 
622   uint public softcap;
623 
624   uint public invested;
625 
626   function setSoftcap(uint newSoftcap) public onlyOwner {
627     softcap = newSoftcap;
628   }
629 
630   function withdraw() public onlyOwner {
631     require(softcapAchieved);
632     wallet.transfer(this.balance);
633   }
634 
635   function updateBalance(address to, uint amount) internal {
636     balances[to] = balances[to].add(amount);
637     invested = invested.add(amount);
638     if (!softcapAchieved && invested >= softcap) {
639       softcapAchieved = true;
640     }
641   }
642 
643   function updateRefundState() internal returns(bool) {
644     if (!softcapAchieved) {
645       refundOn = true;
646     }
647     return refundOn;
648   }
649 
650 }
651 
652 // File: contracts/Presale.sol
653 
654 contract Presale is SoftcapFeature, CommonSale {
655 
656   Mainsale public mainsale;
657 
658   function setMainsale(address newMainsale) public onlyOwner {
659     mainsale = Mainsale(newMainsale);
660   }
661 
662   function finish() public onlyOwner {
663     token.setSaleAgent(mainsale);
664   }
665 
666   function mintTokens(address to, uint weiInvested) internal {
667     super.mintTokens(to, weiInvested);
668     updateBalance(msg.sender, msg.value);
669   }
670 
671   function () external payable minPriceLimit {
672     mintTokens(msg.sender, msg.value);
673   }
674 
675   function refund() public {
676     require(refundOn && balances[msg.sender] > 0);
677     uint value = balances[msg.sender];
678     balances[msg.sender] = 0;
679     msg.sender.transfer(value);
680   }
681 
682   function finishMinting() public onlyOwner {
683     if (updateRefundState()) {
684       token.finishMinting();
685     } else {
686       withdraw();
687       token.setSaleAgent(mainsale);
688     }
689   }
690 
691 }
692 
693 // File: contracts/Configurator.sol
694 
695 contract Configurator is Ownable {
696 
697   YayProtoToken public token;
698 
699   Presale public presale;
700 
701   Mainsale public mainsale;
702 
703   function deploy() public onlyOwner {
704 
705     token = new YayProtoToken();
706     presale = new Presale();
707     mainsale = new Mainsale();
708 
709     presale.setToken(token);
710     presale.setWallet(0x00c286bFbEfa2e7D060259822EDceA2E922a2B7C);
711     presale.setStart(1517356800);
712     presale.setMinPrice(100000000000000000);
713     presale.setPrice(7500000000000000000000);
714     presale.setSoftcap(3000000000000000000000);
715     presale.setHardcap(11250000000000000000000);
716     presale.addMilestone(7,60);
717     presale.addMilestone(7,50);
718     presale.addMilestone(7,40);
719     presale.addMilestone(7,30);
720     presale.addMilestone(7,25);
721     presale.addMilestone(7,20);
722     presale.setMainsale(mainsale);
723 
724     mainsale.setToken(token);
725     mainsale.setPrice(7500000000000000000000);
726     mainsale.setWallet(0x009693f53723315219f681529fE6e05a91a28C41);
727     mainsale.setDevelopersTokensWallet(0x0097895f899559D067016a3d61e3742c0da533ED);
728     mainsale.setTeamTokensWallet(0x00137668FEda9d278A242C69aB520466A348C954);
729     mainsale.setMarketingTokensWallet(0x00A8a63f43ce630dbd3b96F1e040A730341bAa4D);
730     mainsale.setAdvisorsTokensWallet(0x00764817d154237115DdA4FAA76C7aaB5dE3cb25);
731     mainsale.setStart(1523750400);
732     mainsale.setMinPrice(100000000000000000);
733     mainsale.setHardcap(95000000000000000000000);
734     mainsale.setDevelopersTokensPercent(10);
735     mainsale.setTeamTokensPercent(10);
736     mainsale.setMarketingTokensPercent(5);
737     mainsale.setAdvisorsTokensPercent(10);
738     mainsale.addMilestone(7,15);
739     mainsale.addMilestone(7,10);
740     mainsale.addMilestone(7,7);
741     mainsale.addMilestone(7,4);
742     mainsale.addMilestone(7,0);
743 
744     token.setSaleAgent(presale);
745 
746     token.transferOwnership(owner);
747     presale.transferOwnership(owner);
748     mainsale.transferOwnership(owner);
749   }
750 
751 }