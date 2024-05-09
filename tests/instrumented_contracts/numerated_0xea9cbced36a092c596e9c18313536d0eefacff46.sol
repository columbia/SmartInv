1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     if (a == 0) {
53       return 0;
54     }
55     uint256 c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 contract AddressesFilterFeature is Ownable {
235 
236   mapping(address => bool) public allowedAddresses;
237 
238   function addAllowedAddress(address allowedAddress) public onlyOwner {
239     allowedAddresses[allowedAddress] = true;
240   }
241 
242   function removeAllowedAddress(address allowedAddress) public onlyOwner {
243     allowedAddresses[allowedAddress] = false;
244   }
245 
246 }
247 
248 contract ValueBonusFeature is Ownable {
249 
250   using SafeMath for uint;
251 
252   uint percentRate = 1000;
253 
254   struct ValueBonus {
255     uint from;
256     uint bonus;
257   }
258 
259   ValueBonus[] public valueBonuses;
260 
261   function addValueBonus(uint from, uint bonus) public onlyOwner {
262     valueBonuses.push(ValueBonus(from, bonus));
263   }
264 
265   function getValueBonusTokens(uint tokens, uint invested) public view returns(uint) {
266     uint valueBonus = getValueBonus(invested);
267     if(valueBonus == 0) {
268       return 0;
269     }
270     return tokens.mul(valueBonus).div(percentRate);
271   }
272 
273   function getValueBonus(uint value) public view returns(uint) {
274     uint bonus = 0;
275     for(uint i = 0; i < valueBonuses.length; i++) {
276       if(value >= valueBonuses[i].from) {
277         bonus = valueBonuses[i].bonus;
278       } else {
279         return bonus;
280       }
281     }
282     return bonus;
283   }
284 
285 }
286 
287 contract WalletProvider is Ownable {
288 
289   address public wallet;
290 
291   function setWallet(address newWallet) public onlyOwner {
292     wallet = newWallet;
293   }
294 
295 }
296 
297 contract WalletsPercents is Ownable {
298 
299   address[] public wallets;
300 
301   mapping (address => uint) percents;
302 
303   function addWallet(address wallet, uint percent) public onlyOwner {
304     wallets.push(wallet);
305     percents[wallet] = percent;
306   }
307  
308   function cleanWallets() public onlyOwner {
309     wallets.length = 0;
310   }
311 
312 
313 }
314 
315 contract PercentRateProvider {
316 
317   uint public percentRate = 100;
318 
319 }
320 
321 
322 
323 
324 contract PercentRateFeature is Ownable, PercentRateProvider {
325 
326   function setPercentRate(uint newPercentRate) public onlyOwner {
327     percentRate = newPercentRate;
328   }
329 
330 }
331 
332 
333 contract InvestedProvider is Ownable {
334 
335   uint public invested;
336 
337 }
338 
339 contract ReceivingContractCallback {
340 
341   function tokenFallback(address _from, uint _value) public;
342 
343 }
344 
345 contract RetrieveTokensFeature is Ownable {
346 
347   function retrieveTokens(address to, address anotherToken) public onlyOwner {
348     ERC20 alienToken = ERC20(anotherToken);
349     alienToken.transfer(to, alienToken.balanceOf(this));
350   }
351 
352 }
353 
354 contract StagedCrowdsale is Ownable {
355 
356   using SafeMath for uint;
357 
358   struct Milestone {
359     uint period;
360     uint bonus;
361   }
362 
363   uint public totalPeriod;
364 
365   Milestone[] public milestones;
366 
367   function milestonesCount() public view returns(uint) {
368     return milestones.length;
369   }
370 
371   function addMilestone(uint period, uint bonus) public onlyOwner {
372     require(period > 0);
373     milestones.push(Milestone(period, bonus));
374     totalPeriod = totalPeriod.add(period);
375   }
376 
377   function removeMilestone(uint8 number) public onlyOwner {
378     require(number < milestones.length);
379     Milestone storage milestone = milestones[number];
380     totalPeriod = totalPeriod.sub(milestone.period);
381 
382     delete milestones[number];
383 
384     for (uint i = number; i < milestones.length - 1; i++) {
385       milestones[i] = milestones[i+1];
386     }
387 
388     milestones.length--;
389   }
390 
391   function changeMilestone(uint8 number, uint period, uint bonus) public onlyOwner {
392     require(number < milestones.length);
393     Milestone storage milestone = milestones[number];
394 
395     totalPeriod = totalPeriod.sub(milestone.period);
396 
397     milestone.period = period;
398     milestone.bonus = bonus;
399 
400     totalPeriod = totalPeriod.add(period);
401   }
402 
403   function insertMilestone(uint8 numberAfter, uint period, uint bonus) public onlyOwner {
404     require(numberAfter < milestones.length);
405 
406     totalPeriod = totalPeriod.add(period);
407 
408     milestones.length++;
409 
410     for (uint i = milestones.length - 2; i > numberAfter; i--) {
411       milestones[i + 1] = milestones[i];
412     }
413 
414     milestones[numberAfter + 1] = Milestone(period, bonus);
415   }
416 
417   function clearMilestones() public onlyOwner {
418     require(milestones.length > 0);
419     for (uint i = 0; i < milestones.length; i++) {
420       delete milestones[i];
421     }
422     milestones.length -= milestones.length;
423     totalPeriod = 0;
424   }
425 
426   function lastSaleDate(uint start) public view returns(uint) {
427     return start + totalPeriod * 1 days;
428   }
429 
430   function currentMilestone(uint start) public view returns(uint) {
431     uint previousDate = start;
432     for(uint i=0; i < milestones.length; i++) {
433       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
434         return i;
435       }
436       previousDate = previousDate.add(milestones[i].period * 1 days);
437     }
438     revert();
439   }
440 
441 }
442 
443 
444 contract TokenProvider is Ownable {
445 
446   MintableToken public token;
447 
448   function setToken(address newToken) public onlyOwner {
449     token = MintableToken(newToken);
450   }
451 
452 }
453 
454 contract MintableToken is AddressesFilterFeature, StandardToken {
455 
456   event Mint(address indexed to, uint256 amount);
457 
458   event MintFinished();
459 
460   bool public mintingFinished = false;
461 
462   address public saleAgent;
463 
464   mapping (address => uint) public initialBalances;
465 
466   uint public vestingPercent;
467 
468   uint public constant percentRate = 100;
469 
470   modifier notLocked(address _from, uint _value) {
471     if(!(_from == owner || _from == saleAgent || allowedAddresses[_from])) {
472       require(mintingFinished);
473       if((vestingPercent <= percentRate) && (vestingPercent != 0)) {
474         uint minLockedBalance = initialBalances[_from].mul(vestingPercent).div(percentRate);
475         require(minLockedBalance <= balances[_from].sub(_value));
476       }
477     }
478     _;
479   }
480 
481   function setVestingPercent(uint newVestingPercent) public {
482     require(msg.sender == saleAgent || msg.sender == owner);
483     vestingPercent = newVestingPercent;
484   }
485 
486   function setSaleAgent(address newSaleAgnet) public {
487     require(msg.sender == saleAgent || msg.sender == owner);
488     saleAgent = newSaleAgnet;
489   }
490 
491   function mint(address _to, uint256 _amount) public returns (bool) {
492     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
493     
494     totalSupply = totalSupply.add(_amount);
495     balances[_to] = balances[_to].add(_amount);
496 
497     initialBalances[_to] = balances[_to];
498 
499     Mint(_to, _amount);
500     Transfer(address(0), _to, _amount);
501     return true;
502   }
503 
504   /**
505    * @dev Function to stop minting new tokens.
506    * @return True if the operation was successful.
507    */
508   function finishMinting() public returns (bool) {
509     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
510     mintingFinished = true;
511     MintFinished();
512     return true;
513   }
514 
515   function transfer(address _to, uint256 _value) public notLocked(msg.sender, _value)  returns (bool) {
516     return super.transfer(_to, _value);
517   }
518 
519   function transferFrom(address from, address to, uint256 value) public notLocked(from, value) returns (bool) {
520     return super.transferFrom(from, to, value);
521   }
522 
523 }
524 
525 contract Token is MintableToken {
526 
527   string public constant name = "Worldopoly";
528 
529   string public constant symbol = "WPT";
530 
531   uint32 public constant decimals = 18;
532 
533   mapping(address => bool)  public registeredCallbacks;
534 
535   function transfer(address _to, uint256 _value) public returns (bool) {
536     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
537   }
538 
539   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
540     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
541   }
542 
543   function registerCallback(address callback) public onlyOwner {
544     registeredCallbacks[callback] = true;
545   }
546 
547   function deregisterCallback(address callback) public onlyOwner {
548     registeredCallbacks[callback] = false;
549   }
550 
551   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
552     if (result && registeredCallbacks[to]) {
553       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
554       targetCallback.tokenFallback(from, value);
555     }
556     return result;
557   }
558 
559 }
560 
561 contract MintTokensInterface is TokenProvider {
562 
563   function mintTokens(address to, uint tokens) internal;
564 
565 }
566 
567 contract MintTokensFeature is MintTokensInterface {
568 
569   function mintTokens(address to, uint tokens) internal {
570     token.mint(to, tokens);
571   }
572 
573 }
574 
575 contract CommonSale is PercentRateFeature, InvestedProvider, WalletProvider, RetrieveTokensFeature, MintTokensFeature {
576 
577   using SafeMath for uint;
578 
579   address public directMintAgent;
580 
581   uint public price;
582 
583   uint public start;
584 
585   uint public minInvestedLimit;
586 
587   uint public hardcap;
588 
589   modifier isUnderHardcap() {
590     require(invested <= hardcap);
591     _;
592   }
593 
594   function setHardcap(uint newHardcap) public onlyOwner {
595     hardcap = newHardcap;
596   }
597 
598   modifier onlyDirectMintAgentOrOwner() {
599     require(directMintAgent == msg.sender || owner == msg.sender);
600     _;
601   }
602 
603   modifier minInvestLimited(uint value) {
604     require(value >= minInvestedLimit);
605     _;
606   }
607 
608   function setStart(uint newStart) public onlyOwner {
609     start = newStart;
610   }
611 
612   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
613     minInvestedLimit = newMinInvestedLimit;
614   }
615 
616   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
617     directMintAgent = newDirectMintAgent;
618   }
619 
620   function setPrice(uint newPrice) public onlyDirectMintAgentOrOwner {
621     price = newPrice;
622   }
623 
624   function calculateTokens(uint _invested) internal returns(uint);
625 
626   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
627     mintTokens(to, tokens);
628   }
629 
630   function endSaleDate() public view returns(uint);
631 
632   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
633     updateInvested(_invested);
634     return mintTokensByETH(to, _invested);
635   }
636 
637   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
638     uint tokens = calculateTokens(_invested);
639     mintTokens(to, tokens);
640     return tokens;
641   }
642 
643   function transferToWallet(uint value) internal {
644     wallet.transfer(value);
645   }
646 
647   function updateInvested(uint value) internal {
648     invested = invested.add(value);
649   }
650 
651   function fallback() internal minInvestLimited(msg.value) returns(uint) {
652     require(now >= start && now < endSaleDate());
653     transferToWallet(msg.value);
654     updateInvested(msg.value);
655     return mintTokensByETH(msg.sender, msg.value);
656   }
657 
658   function () public payable {
659     fallback();
660   }
661 
662 }
663 
664 contract AssembledCommonSale is ValueBonusFeature, CommonSale {
665 
666 }
667 
668 
669 
670 contract DevFeeFeature is CommonSale {
671 
672   using SafeMath for uint;
673 
674   uint public constant devLimit = 19500000000000000000;
675 
676   uint public devBalance;
677 
678   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
679 
680   function transferToWallet(uint value) internal {
681     uint toDev = devLimit - devBalance;
682     if(toDev > 0) {
683       if(toDev > value) {
684         toDev = value;
685       } else { 
686         wallet.transfer(value.sub(toDev));
687       }
688       devWallet.transfer(toDev);
689       devBalance = devBalance.add(toDev);
690     } else {
691       wallet.transfer(value);
692     }
693   }
694 
695 }
696 
697 contract ERC20Cutted {
698     
699   function balanceOf(address who) public constant returns (uint256);
700   
701   function transfer(address to, uint256 value) public returns (bool);
702   
703 }
704 
705 contract ExtendedWalletsMintTokensFeature is MintTokensInterface, WalletsPercents {
706 
707   using SafeMath for uint;
708 
709   uint public percentRate = 1000;
710 
711   function mintExtendedTokens() public onlyOwner {
712     uint summaryTokensPercent = 0;
713     for(uint i = 0; i < wallets.length; i++) {
714       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
715     }
716     uint mintedTokens = token.totalSupply();
717     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
718     for(uint k = 0; k < wallets.length; k++) {
719       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
720     }
721 
722   }
723 
724 }
725 
726 contract ByteBallWallet is Ownable {
727     
728     address public target = 0x7E5f0D4070a55EbCf0a8A7D6F7abCEf96312C129;
729     
730     uint public locked;
731     
732     address public token;
733     
734     function setToken(address _token) public onlyOwner {
735         token = _token;
736     }
737     
738     function setLocked(uint _locked) public onlyOwner {
739         locked = _locked;
740     }
741     
742     function setTarget(address _target) public onlyOwner {
743         target = _target;
744     }
745     
746     function retreiveTokens() public {
747         require(now > locked);
748         ERC20Basic(token).transfer(target, ERC20Basic(token).balanceOf(this));
749     }
750     
751 }
752 
753 contract ITO is ExtendedWalletsMintTokensFeature, AssembledCommonSale {
754 
755   uint public period;
756 
757   uint public firstBonusPercent;
758 
759   uint public firstBonusLimitPercent;
760   
761   ByteBallWallet public bbwallet = new ByteBallWallet();
762 
763   function setFirstBonusPercent(uint newFirstBonusPercent) public onlyOwner {
764     firstBonusPercent = newFirstBonusPercent;
765   }
766 
767   function setFirstBonusLimitPercent(uint newFirstBonusLimitPercent) public onlyOwner {
768     firstBonusLimitPercent = newFirstBonusLimitPercent;
769   }
770 
771   function calculateTokens(uint _invested) internal returns(uint) {
772     uint tokens = _invested.mul(price).div(1 ether);
773     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
774     if(invested < hardcap.mul(firstBonusLimitPercent).div(percentRate)) {
775       tokens = tokens.add(tokens.mul(firstBonusPercent).div(percentRate));
776     }
777     return tokens.add(valueBonusTokens);
778   }
779 
780   function setPeriod(uint newPeriod) public onlyOwner {
781     period = newPeriod;
782   }
783 
784   function endSaleDate() public view returns(uint) {
785     return start.add(period * 1 days);
786   }
787 
788   function finish() public onlyOwner {
789      mintExtendedTokens();
790      bbwallet.setToken(token);
791      mintTokens(address(bbwallet),5000000000000000000000000);
792      bbwallet.transferOwnership(owner);
793      token.finishMinting();
794   }
795 
796 }
797 
798 
799 contract NextSaleAgentFeature is Ownable {
800 
801   address public nextSaleAgent;
802 
803   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
804     nextSaleAgent = newNextSaleAgent;
805   }
806 
807 }
808 
809 
810 contract PreITO is DevFeeFeature, NextSaleAgentFeature, StagedCrowdsale, AssembledCommonSale {
811 
812   function calculateTokens(uint _invested) internal returns(uint) {
813     uint milestoneIndex = currentMilestone(start);
814     Milestone storage milestone = milestones[milestoneIndex];
815     uint tokens = _invested.mul(price).div(1 ether);
816     uint valueBonusTokens = getValueBonusTokens(tokens, _invested);
817     if(milestone.bonus > 0) {
818       tokens = tokens.add(tokens.mul(milestone.bonus).div(percentRate));
819     }
820     return tokens.add(valueBonusTokens);
821   }
822 
823   function endSaleDate() public view returns(uint) {
824     return lastSaleDate(start);
825   }
826 
827   function finish() public onlyOwner {
828     token.setSaleAgent(nextSaleAgent);
829   }
830 
831 }
832 
833 
834 contract Configurator is Ownable {
835 
836   Token public token;
837 
838   PreITO public preITO;
839 
840   ITO public ito;
841 
842   function deploy() public onlyOwner {
843 
844     address manager = 0xB8A4799a4E2f10e4b30b6C6E9F762833C13eCDF4;
845 
846     token = new Token();
847 
848     preITO = new PreITO();
849     ito = new ITO();
850 
851     commonConfigure(preITO);
852     commonConfigure(ito);
853 
854     preITO.setWallet(0x28D1e6eeBf60b5eb747E2Ee7a185472Ae073Ab7e);
855     preITO.setStart(1524441600);
856     preITO.addMilestone(10, 200);
857     preITO.addMilestone(10, 150);
858     preITO.addMilestone(10, 100);
859     preITO.setHardcap(6282000000000000000000);
860 
861     token.setSaleAgent(preITO);
862     token.setVestingPercent(0);
863 
864     ito.setWallet(0x029fa7ef4E852Bb53CcbafA2308eE728320A5B8d);
865     ito.setStart(1527206400);
866     ito.setPeriod(44);
867     ito.setFirstBonusPercent(50);
868     ito.setFirstBonusLimitPercent(200);
869     ito.setHardcap(37697000000000000000000);
870 
871     ito.addWallet(0xd4Dde5011e330f8bFB246ce60d163AA5900ba71E, 150);
872     ito.addWallet(0x752A9D3d59b8DFbd0798C70c59CAf4A95b5D896e, 50);
873     ito.addWallet(0xae3182c9B850843773714dC5384A38116F6ec135, 50);
874 
875     preITO.setNextSaleAgent(ito);
876 
877     token.transferOwnership(manager);
878     preITO.transferOwnership(manager);
879     ito.transferOwnership(manager);
880   }
881 
882   function commonConfigure(AssembledCommonSale sale) internal {
883     sale.setPercentRate(1000);
884     sale.setMinInvestedLimit(20000000000000000);
885     sale.setPrice(3184000000000000000000);
886     sale.addValueBonus(3000000000000000000, 10);
887     sale.addValueBonus(6000000000000000000, 15);
888     sale.addValueBonus(9000000000000000000, 20);
889     sale.addValueBonus(12000000000000000000, 25);
890     sale.addValueBonus(15000000000000000000, 30);
891     sale.addValueBonus(21000000000000000000, 40);
892     sale.addValueBonus(30000000000000000000, 50);
893     sale.addValueBonus(48000000000000000000, 60);
894     sale.addValueBonus(75000000000000000000, 70);
895     sale.addValueBonus(120000000000000000000, 80);
896     sale.addValueBonus(150000000000000000000, 90);
897     sale.addValueBonus(225000000000000000000, 100);
898     sale.addValueBonus(300000000000000000000, 110);
899     sale.addValueBonus(450000000000000000000, 120);
900     sale.addValueBonus(600000000000000000000, 130);
901     sale.addValueBonus(900000000000000000000, 150);
902     sale.setToken(token);
903   }
904 
905 }