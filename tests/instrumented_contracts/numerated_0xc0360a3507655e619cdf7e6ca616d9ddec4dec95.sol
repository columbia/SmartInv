1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of.
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) public constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80 
81   /**
82    * @dev Transfer tokens from one address to another
83    * @param _from address The address which you want to send tokens from
84    * @param _to address The address which you want to transfer to
85    * @param _value uint256 the amount of tokens to be transferred
86    */
87   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[_from]);
90     require(_value <= allowed[_from][msg.sender]);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    *
102    * Beware that changing an allowance with this method brings the risk that someone may use both the old
103    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106    * @param _spender The address which will spend the funds.
107    * @param _value The amount of tokens to be spent.
108    */
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125   /**
126    * approve should be called when allowed[_spender] == 0. To increment
127    * allowed value is better to use this function to avoid 2 calls (and wait until
128    * the first transaction is mined)
129    * From MonolithDAO Token.sol
130    */
131   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
132     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148   function () public payable {
149     revert();
150   }
151 
152 }
153 
154 contract Ownable {
155   address public owner;
156 
157 
158   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() public {
166     owner = msg.sender;
167   }
168 
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner public {
184     require(newOwner != address(0));
185     OwnershipTransferred(owner, newOwner);
186     owner = newOwner;
187   }
188 
189 }
190 
191 contract Pausable is Ownable {
192   event Pause();
193   event Unpause();
194 
195   bool public paused = false;
196 
197 
198   /**
199    * @dev Modifier to make a function callable only when the contract is not paused.
200    */
201   modifier whenNotPaused() {
202     require(!paused);
203     _;
204   }
205 
206   /**
207    * @dev Modifier to make a function callable only when the contract is paused.
208    */
209   modifier whenPaused() {
210     require(paused);
211     _;
212   }
213 
214   /**
215    * @dev called by the owner to pause, triggers stopped state
216    */
217   function pause() onlyOwner whenNotPaused public {
218     paused = true;
219     Pause();
220   }
221 
222   /**
223    * @dev called by the owner to unpause, returns to normal state
224    */
225   function unpause() onlyOwner whenPaused public {
226     paused = false;
227     Unpause();
228   }
229 }
230 
231 contract MintableToken is StandardToken, Ownable {
232     
233   event Mint(address indexed to, uint256 amount);
234   
235   event MintFinished();
236 
237   event SaleAgentUpdated(address currentSaleAgent);
238 
239   bool public mintingFinished = false;
240 
241   address public saleAgent;
242 
243   modifier notLocked() {
244     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
245     _;
246   }
247 
248   function setSaleAgent(address newSaleAgnet) public {
249     require(msg.sender == saleAgent || msg.sender == owner);
250     saleAgent = newSaleAgnet;
251     SaleAgentUpdated(saleAgent);
252   }
253 
254   function mint(address _to, uint256 _amount) public returns (bool) {
255     require(msg.sender == saleAgent && !mintingFinished);
256     totalSupply = totalSupply.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     Mint(_to, _amount);
259     return true;
260   }
261 
262   /**
263    * @dev Function to stop minting new tokens.
264    * @return True if the operation was successful.
265    */
266   function finishMinting() public returns (bool) {
267     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 
273   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
274     return super.transfer(_to, _value);
275   }
276 
277   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
278     return super.transferFrom(from, to, value);
279   }
280   
281 }
282 
283 contract StagedCrowdsale is Pausable {
284 
285   using SafeMath for uint;
286 
287   //Structure of stage information 
288   struct Stage {
289     uint hardcap;
290     uint price;
291     uint invested;
292     uint closed;
293   }
294 
295   //start date of sale
296   uint public start;
297 
298   //period in days of sale
299   uint public period;
300 
301   //sale's hardcap
302   uint public totalHardcap;
303  
304   //total invested so far in the sale in wei
305   uint public totalInvested;
306 
307   //sale's softcap
308   uint public softcap;
309 
310   //sale's stages
311   Stage[] public stages;
312 
313   event MilestoneAdded(uint hardcap, uint price);
314 
315   modifier saleIsOn() {
316     require(stages.length > 0 && now >= start && now < lastSaleDate());
317     _;
318   }
319 
320   modifier saleIsFinished() {
321     require(totalInvested >= softcap || now > lastSaleDate());
322     _;
323   }
324   
325   modifier isUnderHardcap() {
326     require(totalInvested <= totalHardcap);
327     _;
328   }
329 
330   modifier saleIsUnsuccessful() {
331     require(totalInvested < softcap || now > lastSaleDate());
332     _;
333   }
334 
335   /**
336     * counts current sale's stages
337     */
338   function stagesCount() public constant returns(uint) {
339     return stages.length;
340   }
341 
342   /**
343     * sets softcap
344     * @param newSoftcap new softcap
345     */
346   function setSoftcap(uint newSoftcap) public onlyOwner {
347     require(newSoftcap > 0);
348     softcap = newSoftcap.mul(1 ether);
349   }
350 
351   /**
352     * sets start date
353     * @param newStart new softcap
354     */
355   function setStart(uint newStart) public onlyOwner {
356     start = newStart;
357   }
358 
359   /**
360     * sets period of sale
361     * @param newPeriod new period of sale
362     */
363   function setPeriod(uint newPeriod) public onlyOwner {
364     period = newPeriod;
365   }
366 
367   /**
368     * adds stage to sale
369     * @param hardcap stage's hardcap in ethers
370     * @param price stage's price
371     */
372   function addStage(uint hardcap, uint price) public onlyOwner {
373     require(hardcap > 0 && price > 0);
374     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
375     stages.push(stage);
376     totalHardcap = totalHardcap.add(stage.hardcap);
377     MilestoneAdded(hardcap, price);
378   }
379 
380   /**
381     * removes stage from sale
382     * @param number index of item to delete
383     */
384   function removeStage(uint8 number) public onlyOwner {
385     require(number >= 0 && number < stages.length);
386     Stage storage stage = stages[number];
387     totalHardcap = totalHardcap.sub(stage.hardcap);    
388     delete stages[number];
389     for (uint i = number; i < stages.length - 1; i++) {
390       stages[i] = stages[i+1];
391     }
392     stages.length--;
393   }
394 
395   /**
396     * updates stage
397     * @param number index of item to update
398     * @param hardcap stage's hardcap in ethers
399     * @param price stage's price
400     */
401   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
402     require(number >= 0 && number < stages.length);
403     Stage storage stage = stages[number];
404     totalHardcap = totalHardcap.sub(stage.hardcap);    
405     stage.hardcap = hardcap.mul(1 ether);
406     stage.price = price;
407     totalHardcap = totalHardcap.add(stage.hardcap);    
408   }
409 
410   /**
411     * inserts stage
412     * @param numberAfter index to insert
413     * @param hardcap stage's hardcap in ethers
414     * @param price stage's price
415     */
416   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
417     require(numberAfter < stages.length);
418     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
419     totalHardcap = totalHardcap.add(stage.hardcap);
420     stages.length++;
421     for (uint i = stages.length - 2; i > numberAfter; i--) {
422       stages[i + 1] = stages[i];
423     }
424     stages[numberAfter + 1] = stage;
425   }
426 
427   /**
428     * deletes all stages
429     */
430   function clearStages() public onlyOwner {
431     for (uint i = 0; i < stages.length; i++) {
432       delete stages[i];
433     }
434     stages.length -= stages.length;
435     totalHardcap = 0;
436   }
437 
438   /**
439     * calculates last sale date
440     */
441   function lastSaleDate() public constant returns(uint) {
442     return start + period * 1 days;
443   }  
444 
445   /**
446     * returns index of current stage
447     */
448   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
449     for(uint i = 0; i < stages.length; i++) {
450       if(stages[i].closed == 0) {
451         return i;
452       }
453     }
454     revert();
455   }
456 
457 }
458 
459 contract CommonSale is StagedCrowdsale {
460 
461   //Our MYTC token
462   MYTCToken public token;  
463 
464   //slave wallet percentage
465   uint public slaveWalletPercent = 50;
466 
467   //total percent rate
468   uint public percentRate = 100;
469 
470   //min investment value in wei
471   uint public minInvestment;
472   
473   //bool to check if wallet is initialized
474   bool public slaveWalletInitialized;
475 
476   //bool to check if wallet percentage is initialized
477   bool public slaveWalletPercentInitialized;
478 
479   //master wallet address
480   address public masterWallet;
481 
482   //slave wallet address
483   address public slaveWallet;
484   
485   //Agent for direct minting
486   address public directMintAgent;
487 
488   // How much ETH each address has invested in crowdsale
489   mapping (address => uint256) public investedAmountOf;
490 
491   // How much tokens crowdsale has credited for each investor address
492   mapping (address => uint256) public tokenAmountOf;
493 
494   // Crowdsale contributors
495   mapping (uint => address) public contributors;
496 
497   // Crowdsale unique contributors number
498   uint public uniqueContributors;  
499 
500   /**
501       * event for token purchases logging
502       * @param purchaser who paid for the tokens
503       * @param value weis paid for purchase
504       * @param purchaseDate time of log
505       */
506   event TokenPurchased(address indexed purchaser, uint256 value, uint256 purchaseDate);
507 
508   /**
509       * event for token mint logging
510       * @param to tokens destination
511       * @param tokens minted
512       * @param mintedDate time of log
513       */
514   event TokenMinted(address to, uint tokens, uint256 mintedDate);
515 
516   /**
517       * event for token refund
518       * @param investor refunded account address
519       * @param amount weis refunded
520       * @param returnDate time of log
521       */
522   event InvestmentReturned(address indexed investor, uint256 amount, uint256 returnDate);
523   
524   modifier onlyDirectMintAgentOrOwner() {
525     require(directMintAgent == msg.sender || owner == msg.sender);
526     _;
527   }  
528 
529   /**
530     * sets MYTC token
531     * @param newToken new token
532     */
533   function setToken(address newToken) public onlyOwner {
534     token = MYTCToken(newToken);
535   }
536 
537   /**
538     * sets minimum investement threshold
539     * @param newMinInvestment new minimum investement threshold
540     */
541   function setMinInvestment(uint newMinInvestment) public onlyOwner {
542     minInvestment = newMinInvestment;
543   }  
544 
545   /**
546     * sets master wallet address
547     * @param newMasterWallet new master wallet address
548     */
549   function setMasterWallet(address newMasterWallet) public onlyOwner {
550     masterWallet = newMasterWallet;
551   }
552 
553   /**
554     * sets slave wallet address
555     * @param newSlaveWallet new slave wallet address
556     */
557   function setSlaveWallet(address newSlaveWallet) public onlyOwner {
558     require(!slaveWalletInitialized);
559     slaveWallet = newSlaveWallet;
560     slaveWalletInitialized = true;
561   }
562 
563   /**
564     * sets slave wallet percentage
565     * @param newSlaveWalletPercent new wallet percentage
566     */
567   function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
568     require(!slaveWalletPercentInitialized);
569     slaveWalletPercent = newSlaveWalletPercent;
570     slaveWalletPercentInitialized = true;
571   }
572 
573   /**
574     * sets direct mint agent
575     * @param newDirectMintAgent new agent
576     */
577   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
578     directMintAgent = newDirectMintAgent;
579   }  
580 
581   /**
582     * mints directly from network
583     * @param to invesyor's adress to transfer the minted tokens to
584     * @param investedWei number of wei invested
585     */
586   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
587     calculateAndMintTokens(to, investedWei);
588     TokenPurchased(to, investedWei, now);
589   }
590 
591   /**
592     * splits investment into master and slave wallets for security reasons
593     */
594   function createTokens() public whenNotPaused payable {
595     require(msg.value >= minInvestment);
596     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
597     uint slaveValue = msg.value.sub(masterValue);
598     masterWallet.transfer(masterValue);
599     slaveWallet.transfer(slaveValue);
600     calculateAndMintTokens(msg.sender, msg.value);
601     TokenPurchased(msg.sender, msg.value, now);
602   }
603 
604   /**
605     * Calculates and records contributions
606     * @param to invesyor's adress to transfer the minted tokens to
607     * @param weiInvested number of wei invested
608     */
609   function calculateAndMintTokens(address to, uint weiInvested) internal {
610     //calculate number of tokens
611     uint stageIndex = currentStage();
612     Stage storage stage = stages[stageIndex];
613     uint tokens = weiInvested.mul(stage.price);
614     //if we have a new contributor
615     if(investedAmountOf[msg.sender] == 0) {
616         contributors[uniqueContributors] = msg.sender;
617         uniqueContributors += 1;
618     }
619     //record contribution and tokens assigned
620     investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(weiInvested);
621     tokenAmountOf[msg.sender] = tokenAmountOf[msg.sender].add(tokens);
622     //mint and update invested values
623     mintTokens(to, tokens);
624     totalInvested = totalInvested.add(weiInvested);
625     stage.invested = stage.invested.add(weiInvested);
626     //check if cap of staged is reached
627     if(stage.invested >= stage.hardcap) {
628       stage.closed = now;
629     }
630   }
631 
632   /**
633     * Mint tokens
634     * @param to adress destination to transfer the tokens to
635     * @param tokens number of tokens to mint and transfer
636     */
637   function mintTokens(address to, uint tokens) internal {
638     token.mint(this, tokens);
639     token.transfer(to, tokens);
640     TokenMinted(to, tokens, now);
641   }
642 
643   /**
644     * Payable function
645     */
646   function() external payable {
647     createTokens();
648   }
649   
650   /**
651     * Function to retrieve and transfer back external tokens
652     * @param anotherToken external token received
653     * @param to address destination to transfer the token to
654     */
655   function retrieveExternalTokens(address anotherToken, address to) public onlyOwner {
656     ERC20 alienToken = ERC20(anotherToken);
657     alienToken.transfer(to, alienToken.balanceOf(this));
658   }
659 
660   /**
661     * Function to refund funds if softcap is not reached and sale period is over 
662     */
663   function refund() public saleIsUnsuccessful {
664     uint value = investedAmountOf[msg.sender];
665     investedAmountOf[msg.sender] = 0;
666     msg.sender.transfer(value);
667     InvestmentReturned(msg.sender, value, now);
668   }
669 
670 }
671 
672 contract WhiteListToken is CommonSale {
673 
674   mapping(address => bool)  public whiteList;
675 
676   modifier onlyIfWhitelisted() {
677     require(whiteList[msg.sender]);
678     _;
679   }
680 
681   function addToWhiteList(address _address) public onlyDirectMintAgentOrOwner {
682     whiteList[_address] = true;
683   }
684 
685   function addAddressesToWhitelist(address[] _addresses) public onlyDirectMintAgentOrOwner {
686     for (uint256 i = 0; i < _addresses.length; i++) {
687       addToWhiteList(_addresses[i]);
688     }
689   }
690 
691   function deleteFromWhiteList(address _address) public onlyDirectMintAgentOrOwner {
692     whiteList[_address] = false;
693   }
694 
695   function deleteAddressesFromWhitelist(address[] _addresses) public onlyDirectMintAgentOrOwner {
696     for (uint256 i = 0; i < _addresses.length; i++) {
697       deleteFromWhiteList(_addresses[i]);
698     }
699   }
700 
701 }
702 
703 contract MYTCToken is MintableToken {	
704     
705   //Token name
706   string public constant name = "MYTC";
707    
708   //Token symbol
709   string public constant symbol = "MYTC";
710     
711   //Token's number of decimals
712   uint32 public constant decimals = 18;
713 
714   //Dictionary with locked accounts
715   mapping (address => uint) public locked;
716 
717   /**
718     * transfer for unlocked accounts
719     */
720   function transfer(address _to, uint256 _value) public returns (bool) {
721     require(locked[msg.sender] < now);
722     return super.transfer(_to, _value);
723   }
724 
725   /**
726     * transfer from for unlocked accounts
727     */
728   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
729     require(locked[_from] < now);
730     return super.transferFrom(_from, _to, _value);
731   }
732   
733   /**
734     * locks an account for given a number of days
735     * @param addr account address to be locked
736     * @param periodInDays days to be locked
737     */
738   function lock(address addr, uint periodInDays) public {
739     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
740     locked[addr] = now + periodInDays * 1 days;
741   }
742 
743 }
744 
745 contract PreTge is CommonSale {
746 
747   //TGE 
748   Tge public tge;
749 
750   /**
751       * event for PreTGE finalization logging
752       * @param finalizer account who trigger finalization
753       * @param saleEnded time of log
754       */
755   event PreTgeFinalized(address indexed finalizer, uint256 saleEnded);
756 
757   /**
758     * sets TGE to pass agent when sale is finished
759     * @param newMainsale adress of TGE contract
760     */
761   function setMainsale(address newMainsale) public onlyOwner {
762     tge = Tge(newMainsale);
763   }
764 
765   /**
766     * sets TGE as new sale agent when sale is finished
767     */
768   function setTgeAsSaleAgent() public whenNotPaused saleIsFinished onlyOwner {
769     token.setSaleAgent(tge);
770     PreTgeFinalized(msg.sender, now);
771   }
772 }
773 
774 
775 contract Tge is WhiteListToken {
776 
777   //Team wallet address
778   address public teamTokensWallet;
779   
780   //Bounty and advisors wallet address
781   address public bountyTokensWallet;
782 
783   //Reserved tokens wallet address
784   address public reservedTokensWallet;
785   
786   //Team percentage
787   uint public teamTokensPercent;
788   
789   //Bounty and advisors percentage
790   uint public bountyTokensPercent;
791 
792   //Reserved tokens percentage
793   uint public reservedTokensPercent;
794   
795   //Lock period in days for team's wallet
796   uint public lockPeriod;  
797 
798   //maximum amount of tokens ever minted
799   uint public totalTokenSupply;
800 
801   /**
802       * event for TGE finalization logging
803       * @param finalizer account who trigger finalization
804       * @param saleEnded time of log
805       */
806   event TgeFinalized(address indexed finalizer, uint256 saleEnded);
807 
808   /**
809     * sets lock period in days for team's wallet
810     * @param newLockPeriod new lock period in days
811     */
812   function setLockPeriod(uint newLockPeriod) public onlyOwner {
813     lockPeriod = newLockPeriod;
814   }
815 
816   /**
817     * sets percentage for team's wallet
818     * @param newTeamTokensPercent new percentage for team's wallet
819     */
820   function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
821     teamTokensPercent = newTeamTokensPercent;
822   }
823 
824   /**
825     * sets percentage for bounty's wallet
826     * @param newBountyTokensPercent new percentage for bounty's wallet
827     */
828   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
829     bountyTokensPercent = newBountyTokensPercent;
830   }
831 
832   /**
833     * sets percentage for reserved wallet
834     * @param newReservedTokensPercent new percentage for reserved wallet
835     */
836   function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
837     reservedTokensPercent = newReservedTokensPercent;
838   }
839   
840   /**
841     * sets max number of tokens to ever mint
842     * @param newTotalTokenSupply max number of tokens (incl. 18 dec points)
843     */
844   function setTotalTokenSupply(uint newTotalTokenSupply) public onlyOwner {
845     totalTokenSupply = newTotalTokenSupply;
846   }
847 
848   /**
849     * sets address for team's wallet
850     * @param newTeamTokensWallet new address for team's wallet
851     */
852   function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
853     teamTokensWallet = newTeamTokensWallet;
854   }
855 
856   /**
857     * sets address for bountys's wallet
858     * @param newBountyTokensWallet new address for bountys's wallet
859     */
860   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
861     bountyTokensWallet = newBountyTokensWallet;
862   }
863 
864   /**
865     * sets address for reserved wallet
866     * @param newReservedTokensWallet new address for reserved wallet
867     */
868   function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
869     reservedTokensWallet = newReservedTokensWallet;
870   }
871 
872   /**
873     * Mints remaining tokens and finishes minting when sale is successful
874     * No further tokens will be minted ever
875     */
876   function endSale() public whenNotPaused saleIsFinished onlyOwner {    
877     // uint remainingPercentage = bountyTokensPercent.add(teamTokensPercent).add(reservedTokensPercent);
878     // uint tokensGenerated = token.totalSupply();
879 
880     uint foundersTokens = totalTokenSupply.mul(teamTokensPercent).div(percentRate);
881     uint reservedTokens = totalTokenSupply.mul(reservedTokensPercent).div(percentRate);
882     uint bountyTokens = totalTokenSupply.mul(bountyTokensPercent).div(percentRate); 
883     mintTokens(reservedTokensWallet, reservedTokens);
884     mintTokens(teamTokensWallet, foundersTokens);
885     mintTokens(bountyTokensWallet, bountyTokens); 
886     uint currentSupply = token.totalSupply();
887     if (currentSupply < totalTokenSupply) {
888       // send remaining tokens to reserved wallet
889       mintTokens(reservedTokensWallet, totalTokenSupply.sub(currentSupply));
890     }  
891     token.lock(teamTokensWallet, lockPeriod);      
892     token.finishMinting();
893     TgeFinalized(msg.sender, now);
894   }
895 
896     /**
897     * Payable function
898     */
899   function() external onlyIfWhitelisted payable {
900     require(now >= start && now < lastSaleDate());
901     createTokens();
902   }
903 }