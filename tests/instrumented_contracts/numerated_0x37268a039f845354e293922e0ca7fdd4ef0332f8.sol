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
282   modifier notLocked(address _from) {
283     require(_from == owner || _from == saleAgent || allowedAddresses[_from] || mintingFinished);
284     _;
285   }
286 
287   function setSaleAgent(address newSaleAgnet) public {
288     require(msg.sender == saleAgent || msg.sender == owner);
289     saleAgent = newSaleAgnet;
290   }
291 
292   function mint(address _to, uint256 _amount) public returns (bool) {
293     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
294     
295     totalSupply = totalSupply.add(_amount);
296     balances[_to] = balances[_to].add(_amount);
297 
298     initialBalances[_to] = balances[_to];
299 
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() public returns (bool) {
310     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
311     mintingFinished = true;
312     MintFinished();
313     return true;
314   }
315 
316   function transfer(address _to, uint256 _value) public notLocked(msg.sender)  returns (bool) {
317     return super.transfer(_to, _value);
318   }
319 
320   function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {
321     return super.transferFrom(from, to, value);
322   }
323 
324 }
325 
326 // File: contracts/TokenProvider.sol
327 
328 contract TokenProvider is Ownable {
329 
330   MintableToken public token;
331 
332   function setToken(address newToken) public onlyOwner {
333     token = MintableToken(newToken);
334   }
335 
336 }
337 
338 // File: contracts/MintTokensInterface.sol
339 
340 contract MintTokensInterface is TokenProvider {
341 
342   function mintTokens(address to, uint tokens) internal;
343 
344 }
345 
346 // File: contracts/MintTokensFeature.sol
347 
348 contract MintTokensFeature is MintTokensInterface {
349 
350   function mintTokens(address to, uint tokens) internal {
351     token.mint(to, tokens);
352   }
353 
354 }
355 
356 // File: contracts/PercentRateProvider.sol
357 
358 contract PercentRateProvider {
359 
360   uint public percentRate = 100;
361 
362 }
363 
364 // File: contracts/PercentRateFeature.sol
365 
366 contract PercentRateFeature is Ownable, PercentRateProvider {
367 
368   function setPercentRate(uint newPercentRate) public onlyOwner {
369     percentRate = newPercentRate;
370   }
371 
372 }
373 
374 // File: contracts/RetrieveTokensFeature.sol
375 
376 contract RetrieveTokensFeature is Ownable {
377 
378   function retrieveTokens(address to, address anotherToken) public onlyOwner {
379     ERC20 alienToken = ERC20(anotherToken);
380     alienToken.transfer(to, alienToken.balanceOf(this));
381   }
382 
383 }
384 
385 // File: contracts/WalletProvider.sol
386 
387 contract WalletProvider is Ownable {
388 
389   address public wallet;
390 
391   function setWallet(address newWallet) public onlyOwner {
392     wallet = newWallet;
393   }
394 
395 }
396 
397 // File: contracts/CommonSale.sol
398 
399 contract CommonSale is InvestedProvider, WalletProvider, PercentRateFeature, RetrieveTokensFeature, MintTokensFeature {
400 
401   using SafeMath for uint;
402 
403   address public directMintAgent;
404 
405   uint public price;
406 
407   uint public start;
408 
409   uint public minInvestedLimit;
410 
411   //MintableToken public token;
412 
413   uint public hardcap;
414 
415   modifier isUnderHardcap() {
416     require(invested < hardcap);
417     _;
418   }
419 
420   function setHardcap(uint newHardcap) public onlyOwner {
421     hardcap = newHardcap;
422   }
423 
424   modifier onlyDirectMintAgentOrOwner() {
425     require(directMintAgent == msg.sender || owner == msg.sender);
426     _;
427   }
428 
429   modifier minInvestLimited(uint value) {
430     require(value >= minInvestedLimit);
431     _;
432   }
433 
434   function setStart(uint newStart) public onlyOwner {
435     start = newStart;
436   }
437 
438   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
439     minInvestedLimit = newMinInvestedLimit;
440   }
441 
442   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
443     directMintAgent = newDirectMintAgent;
444   }
445 
446   function setPrice(uint newPrice) public onlyOwner {
447     price = newPrice;
448   }
449 
450   /*
451   function setToken(address newToken) public onlyOwner {
452     token = MintableToken(newToken);
453   }
454   */
455 
456   function calculateTokens(uint _invested) internal returns(uint);
457 
458   function mintTokensExternal(address to, uint tokens) public onlyDirectMintAgentOrOwner {
459     mintTokens(to, tokens);
460   }
461 /*
462   function mintTokens(address to, uint tokens) internal {
463     token.mint(this, tokens);
464     token.transfer(to, tokens);
465   }
466 */
467   function endSaleDate() public view returns(uint);
468 
469   function mintTokensByETHExternal(address to, uint _invested) public onlyDirectMintAgentOrOwner returns(uint) {
470     return mintTokensByETH(to, _invested);
471   }
472 
473   function mintTokensByETH(address to, uint _invested) internal isUnderHardcap returns(uint) {
474     invested = invested.add(_invested);
475     uint tokens = calculateTokens(_invested);
476     mintTokens(to, tokens);
477     return tokens;
478   }
479 
480   function fallback() internal minInvestLimited(msg.value) returns(uint) {
481     require(now >= start && now < endSaleDate());
482     wallet.transfer(msg.value);
483     return mintTokensByETH(msg.sender, msg.value);
484   }
485 
486   function () public payable {
487     fallback();
488   }
489 
490 }
491 
492 // File: contracts/TimeCountBonusFeature.sol
493 
494 contract TimeCountBonusFeature is CommonSale {
495 
496   struct Milestone {
497     uint hardcap;
498     uint price;
499     uint period;
500     uint invested;
501     uint closed;
502   }
503 
504   uint public period;
505 
506   Milestone[] public milestones;
507 
508   function milestonesCount() public constant returns(uint) {
509     return milestones.length;
510   }
511 
512   function addMilestone(uint _hardcap, uint _price, uint _period) public onlyOwner {
513     require(_hardcap > 0 && _price > 0 && _period > 0);
514     Milestone memory milestone = Milestone(_hardcap.mul(1 ether), _price, _period, 0, 0);
515     milestones.push(milestone);
516     hardcap = hardcap.add(milestone.hardcap);
517     period = period.add(milestone.period);
518   }
519 
520   function removeMilestone(uint8 number) public onlyOwner {
521     require(number >=0 && number < milestones.length);
522     Milestone storage milestone = milestones[number];
523     hardcap = hardcap.sub(milestone.hardcap);    
524     period = period.sub(milestone.period);    
525     delete milestones[number];
526     for (uint i = number; i < milestones.length - 1; i++) {
527       milestones[i] = milestones[i+1];
528     }
529     milestones.length--;
530   }
531 
532   function changeMilestone(uint8 number, uint _hardcap, uint _price, uint _period) public onlyOwner {
533     require(number >= 0 &&number < milestones.length);
534     Milestone storage milestone = milestones[number];
535     hardcap = hardcap.sub(milestone.hardcap);    
536     period = period.sub(milestone.period);    
537     milestone.hardcap = _hardcap.mul(1 ether);
538     milestone.price = _price;
539     milestone.period = _period;
540     hardcap = hardcap.add(milestone.hardcap);    
541     period = period.add(milestone.period);    
542   }
543 
544   function insertMilestone(uint8 numberAfter, uint _hardcap, uint _price, uint _period) public onlyOwner {
545     require(numberAfter < milestones.length);
546     Milestone memory milestone = Milestone(_hardcap.mul(1 ether), _price, _period, 0, 0);
547     hardcap = hardcap.add(milestone.hardcap);
548     period = period.add(milestone.period);
549     milestones.length++;
550     for (uint i = milestones.length - 2; i > numberAfter; i--) {
551       milestones[i + 1] = milestones[i];
552     }
553     milestones[numberAfter + 1] = milestone;
554   }
555 
556   function clearMilestones() public onlyOwner {
557     for (uint i = 0; i < milestones.length; i++) {
558       delete milestones[i];
559     }
560     milestones.length = 0;
561     hardcap = 0;
562     period = 0;
563   }
564 
565   function endSaleDate() public view returns(uint) {
566     return start.add(period * 1 days);
567   }
568 
569   function currentMilestone() public constant returns(uint) {
570     uint closeTime = start;
571     for(uint i=0; i < milestones.length; i++) {
572       closeTime += milestones[i].period.mul(1 days);
573       if(milestones[i].closed == 0 && now < closeTime) {
574         return i;
575       }
576     }
577     revert();
578   }
579 
580   function calculateTokens(uint _invested) internal returns(uint) {
581     uint milestoneIndex = currentMilestone();
582     Milestone storage milestone = milestones[milestoneIndex];
583     uint tokens = milestone.price.mul(_invested).div(1 ether);
584 
585     // update milestone
586     milestone.invested = milestone.invested.add(_invested);
587     if(milestone.invested >= milestone.hardcap) {
588       milestone.closed = now;
589     }
590 
591     return tokens;
592   }
593 
594 
595 }
596 
597 // File: contracts/AssembledCommonSale.sol
598 
599 contract AssembledCommonSale is TimeCountBonusFeature {
600 
601 }
602 
603 // File: contracts/WalletsPercents.sol
604 
605 contract WalletsPercents is Ownable {
606 
607   address[] public wallets;
608 
609   mapping (address => uint) percents;
610 
611   function addWallet(address wallet, uint percent) public onlyOwner {
612     wallets.push(wallet);
613     percents[wallet] = percent;
614   }
615  
616   function cleanWallets() public onlyOwner {
617     wallets.length = 0;
618   }
619 
620 
621 }
622 
623 // File: contracts/ExtendedWalletsMintTokensFeature.sol
624 
625 //import './PercentRateProvider.sol';
626 
627 contract ExtendedWalletsMintTokensFeature is /*PercentRateProvider,*/ MintTokensInterface, WalletsPercents {
628 
629   using SafeMath for uint;
630 
631   uint public percentRate = 100;
632 
633   function mintExtendedTokens() public onlyOwner {
634     uint summaryTokensPercent = 0;
635     for(uint i = 0; i < wallets.length; i++) {
636       summaryTokensPercent = summaryTokensPercent.add(percents[wallets[i]]);
637     }
638     uint mintedTokens = token.totalSupply();
639     uint allTokens = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
640     for(uint k = 0; k < wallets.length; k++) {
641       mintTokens(wallets[k], allTokens.mul(percents[wallets[k]]).div(percentRate));
642     }
643 
644   }
645 
646 }
647 
648 // File: contracts/SoftcapFeature.sol
649 
650 contract SoftcapFeature is InvestedProvider, WalletProvider {
651 
652   using SafeMath for uint;
653 
654   mapping(address => uint) public balances;
655 
656   bool public softcapAchieved;
657 
658   bool public refundOn;
659 
660   bool public feePayed;
661 
662   uint public softcap;
663 
664   uint public constant devLimit = 7500000000000000000;
665 
666   address public constant devWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
667 
668   function setSoftcap(uint newSoftcap) public onlyOwner {
669     softcap = newSoftcap;
670   }
671 
672   function withdraw() public {
673     require(msg.sender == owner || msg.sender == devWallet);
674     require(softcapAchieved);
675     if(!feePayed) {
676       devWallet.transfer(devLimit);
677       feePayed = true;
678     }
679     wallet.transfer(this.balance);
680   }
681 
682   function updateBalance(address to, uint amount) internal {
683     balances[to] = balances[to].add(amount);
684     if (!softcapAchieved && invested >= softcap) {
685       softcapAchieved = true;
686     }
687   }
688 
689   function refund() public {
690     require(refundOn && balances[msg.sender] > 0);
691     uint value = balances[msg.sender];
692     balances[msg.sender] = 0;
693     msg.sender.transfer(value);
694   }
695 
696   function updateRefundState() internal returns(bool) {
697     if (!softcapAchieved) {
698       refundOn = true;
699     }
700     return refundOn;
701   }
702 
703 }
704 
705 // File: contracts/TeamWallet.sol
706 
707 contract TeamWallet is Ownable{
708 	
709   address public token;
710 
711   address public crowdsale;
712 
713   uint public lockPeriod;
714 
715   uint public endLock;
716 
717   bool public started;
718 
719   modifier onlyCrowdsale() {
720     require(crowdsale == msg.sender);
721     _;
722   }
723 
724   function setToken (address _token) public onlyOwner{
725   	token = _token;
726   }
727 
728   function setCrowdsale (address _crowdsale) public onlyOwner{
729     crowdsale = _crowdsale;
730   }
731 
732   function setLockPeriod (uint _lockDays) public onlyOwner{
733   	require(!started);
734   	lockPeriod = 1 days * _lockDays;
735   }
736 
737   function start () public onlyCrowdsale{
738   	started = true;
739   	endLock = now + lockPeriod;
740   }
741 
742   function withdrawTokens (address _to) public onlyOwner{
743   	require(now > endLock);
744   	ERC20 ERC20token = ERC20(token);
745     ERC20token.transfer(_to, ERC20token.balanceOf(this));  
746   }
747   
748 }
749 
750 // File: contracts/ITO.sol
751 
752 contract ITO is ExtendedWalletsMintTokensFeature, SoftcapFeature, AssembledCommonSale {
753 
754   address public teamWallet;
755 
756   bool public paused;
757 
758   function setTeamWallet (address _teamWallet) public onlyOwner{
759     teamWallet = _teamWallet;
760   }
761 
762   function mintTokensByETH(address to, uint _invested) internal returns(uint) {
763     uint _tokens = super.mintTokensByETH(to, _invested);
764     updateBalance(to, _invested);
765     return _tokens;
766   }
767 
768   function finish() public onlyOwner {
769     if (updateRefundState()) {
770       token.finishMinting();
771     } else {
772       withdraw();
773       mintExtendedTokens();
774       token.finishMinting();
775       TeamWallet tWallet = TeamWallet(teamWallet);
776       tWallet.start();
777     }
778   }
779 
780   function fallback() internal minInvestLimited(msg.value) returns(uint) {
781     require(now >= start && now < endSaleDate());
782     require(!paused);
783     return mintTokensByETH(msg.sender, msg.value);
784   }
785 
786   function pauseITO() public onlyOwner {
787     paused = true;
788   }
789 
790   function continueITO() public onlyOwner {
791     paused = false;
792   }
793 
794 }
795 
796 // File: contracts/ReceivingContractCallback.sol
797 
798 contract ReceivingContractCallback {
799 
800   function tokenFallback(address _from, uint _value) public;
801 
802 }
803 
804 // File: contracts/Token.sol
805 
806 contract Token is MintableToken {
807 
808   string public constant name = "HelixHill";
809 
810   string public constant symbol = "HILL";
811 
812   uint32 public constant decimals = 18;
813 
814   mapping(address => bool)  public registeredCallbacks;
815 
816   function transfer(address _to, uint256 _value) public returns (bool) {
817     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
818   }
819 
820   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
821     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
822   }
823 
824   function registerCallback(address callback) public onlyOwner {
825     registeredCallbacks[callback] = true;
826   }
827 
828   function deregisterCallback(address callback) public onlyOwner {
829     registeredCallbacks[callback] = false;
830   }
831 
832   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
833     if (result && registeredCallbacks[to]) {
834       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
835       targetCallback.tokenFallback(from, value);
836     }
837     return result;
838   }
839 
840 }
841 
842 // File: contracts/Configurator.sol
843 
844 contract Configurator is Ownable {
845 
846   Token public token;
847   ITO public ito;
848   TeamWallet public teamWallet;
849 
850   function deploy() public onlyOwner {
851 
852     address manager = 0xd6561BF111dAfe86A896D6c844F82AE4a5bbc707;
853 
854     token = new Token();
855     ito = new ITO();
856     teamWallet = new TeamWallet();
857 
858     token.setSaleAgent(ito);
859 
860     ito.setStart(1530622800);
861     ito.addMilestone(2000, 5000000000000000000000, 146);
862     ito.addMilestone(1000, 2000000000000000000000, 30);
863     ito.addMilestone(1000, 1950000000000000000000, 30);
864     ito.addMilestone(2000, 1800000000000000000000, 30);
865     ito.addMilestone(3000, 1750000000000000000000, 30);
866     ito.addMilestone(3500, 1600000000000000000000, 30);
867     ito.addMilestone(4000, 1550000000000000000000, 30);
868     ito.addMilestone(4500, 1500000000000000000000, 30);
869     ito.addMilestone(5000, 1450000000000000000000, 30);
870     ito.addMilestone(6000, 1400000000000000000000, 30);
871     ito.addMilestone(8000, 1000000000000000000000, 30);
872     ito.setSoftcap(2000000000000000000000);
873     ito.setMinInvestedLimit(100000000000000000);
874     ito.setWallet(0x3047e47EfC33cF8f6F9C3bdD1ACcaEda75B66f2A);
875     ito.addWallet(0xe129b76dF45bFE35FE4a3fA52986CC8004538C98, 6);
876     ito.addWallet(0x26Db091BF1Bcc2c439A2cA7140D76B4e909C7b4e, 2);
877     ito.addWallet(teamWallet, 15);
878     ito.addWallet(0x2A3b94CB5b9E10E12f97c72d6B5E09BD5A0E6bF1, 12);
879     ito.setPercentRate(100);
880     ito.setToken(token);
881     ito.setTeamWallet(teamWallet);
882 
883     teamWallet.setToken(token);
884     teamWallet.setCrowdsale(ito);
885     teamWallet.setLockPeriod(180);
886 
887     token.transferOwnership(manager);
888     ito.transferOwnership(manager);
889     teamWallet.transferOwnership(manager);
890   }
891 
892 }