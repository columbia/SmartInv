1 pragma solidity ^0.4.24;
2 
3 contract TokenInfo {
4     // Base prices in wei, going off from an Ether value of $500
5     uint256 public constant PRIVATESALE_BASE_PRICE_IN_WEI = 200000000000000;
6     uint256 public constant PRESALE_BASE_PRICE_IN_WEI = 600000000000000;
7     uint256 public constant ICO_BASE_PRICE_IN_WEI = 800000000000000;
8     uint256 public constant FIRSTSALE_BASE_PRICE_IN_WEI = 200000000000000;
9 
10     // First sale minimum and maximum contribution, going off from an Ether value of $500
11     uint256 public constant MIN_PURCHASE_OTHERSALES = 80000000000000000;
12     uint256 public constant MIN_PURCHASE = 1000000000000000000;
13     uint256 public constant MAX_PURCHASE = 1000000000000000000000;
14 
15     // Bonus percentages for each respective sale level
16 
17     uint256 public constant PRESALE_PERCENTAGE_1 = 10;
18     uint256 public constant PRESALE_PERCENTAGE_2 = 15;
19     uint256 public constant PRESALE_PERCENTAGE_3 = 20;
20     uint256 public constant PRESALE_PERCENTAGE_4 = 25;
21     uint256 public constant PRESALE_PERCENTAGE_5 = 35;
22 
23     uint256 public constant ICO_PERCENTAGE_1 = 5;
24     uint256 public constant ICO_PERCENTAGE_2 = 10;
25     uint256 public constant ICO_PERCENTAGE_3 = 15;
26     uint256 public constant ICO_PERCENTAGE_4 = 20;
27     uint256 public constant ICO_PERCENTAGE_5 = 25;
28 
29     // Bonus levels in wei for each respective level
30 
31     uint256 public constant PRESALE_LEVEL_1 = 5000000000000000000;
32     uint256 public constant PRESALE_LEVEL_2 = 10000000000000000000;
33     uint256 public constant PRESALE_LEVEL_3 = 15000000000000000000;
34     uint256 public constant PRESALE_LEVEL_4 = 20000000000000000000;
35     uint256 public constant PRESALE_LEVEL_5 = 25000000000000000000;
36 
37     uint256 public constant ICO_LEVEL_1 = 6666666666666666666;
38     uint256 public constant ICO_LEVEL_2 = 13333333333333333333;
39     uint256 public constant ICO_LEVEL_3 = 20000000000000000000;
40     uint256 public constant ICO_LEVEL_4 = 26666666666666666666;
41     uint256 public constant ICO_LEVEL_5 = 33333333333333333333;
42 
43     // Caps for the respective sales, the amount of tokens allocated to the team and the total cap
44     uint256 public constant PRIVATESALE_TOKENCAP = 18750000;
45     uint256 public constant PRESALE_TOKENCAP = 18750000;
46     uint256 public constant ICO_TOKENCAP = 22500000;
47     uint256 public constant FIRSTSALE_TOKENCAP = 5000000;
48     uint256 public constant LEDTEAM_TOKENS = 35000000;
49     uint256 public constant TOTAL_TOKENCAP = 100000000;
50 
51     uint256 public constant DECIMALS_MULTIPLIER = 1 ether;
52 
53     address public constant LED_MULTISIG = 0x865e785f98b621c5fdde70821ca7cea9eeb77ef4;
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     if (newOwner != address(0)) {
86       owner = newOwner;
87     }
88   }
89 
90 }
91 
92 
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99   constructor() public {}
100 
101   /**
102    * @dev modifier to allow actions only when the contract IS paused
103    */
104   modifier whenNotPaused() {
105     require(!paused);
106     _;
107   }
108 
109   /**
110    * @dev modifier to allow actions only when the contract IS NOT paused
111    */
112   modifier whenPaused {
113     require(paused);
114     _;
115   }
116 
117   /**
118    * @dev called by the owner to pause, triggers stopped state
119    */
120   function pause() public onlyOwner whenNotPaused returns (bool) {
121     paused = true;
122     emit Pause();
123     return true;
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() public onlyOwner whenPaused returns (bool) {
130     paused = false;
131     emit Unpause();
132     return true;
133   }
134 }
135 
136 contract ApproveAndCallReceiver {
137     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
138 }
139 
140 /**
141  * @title Controllable
142  * @dev The Controllable contract has an controller address, and provides basic authorization control
143  * functions, this simplifies the implementation of "user permissions".
144  */
145 contract Controllable {
146   address public controller;
147 
148 
149   /**
150    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
151    */
152   constructor() public {
153     controller = msg.sender;
154   }
155 
156   /**
157    * @dev Throws if called by any account other than the owner.
158    */
159   modifier onlyController() {
160     require(msg.sender == controller);
161     _;
162   }
163 
164   /**
165    * @dev Allows the current owner to transfer control of the contract to a newOwner.
166    * @param newController The address to transfer ownership to.
167    */
168   function transferControl(address newController) public onlyController {
169     if (newController != address(0)) {
170       controller = newController;
171     }
172   }
173 
174 }
175 
176 /// @dev The token controller contract must implement these functions
177 contract ControllerInterface {
178 
179     function proxyPayment(address _owner) public payable returns(bool);
180     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
181     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
182 }
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 {
189 
190   uint256 public totalSupply;
191 
192   function balanceOf(address _owner) public constant returns (uint256);
193   function transfer(address _to, uint256 _value) public returns (bool);
194   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool);
195   function approve(address _spender, uint256 _amount) public returns (bool);
196   function allowance(address _owner, address _spender) public constant returns (uint256);
197 
198   event Transfer(address indexed from, address indexed to, uint256 value);
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200 
201 }
202 
203 contract Crowdsale is Pausable, TokenInfo {
204 
205   using SafeMath for uint256;
206 
207   LedTokenInterface public ledToken;
208   uint256 public startTime;
209   uint256 public endTime;
210 
211   uint256 public totalWeiRaised;
212   uint256 public tokensMinted;
213   uint256 public totalSupply;
214   uint256 public contributors;
215   uint256 public surplusTokens;
216 
217   bool public finalized;
218 
219   bool public ledTokensAllocated;
220   address public ledMultiSig = LED_MULTISIG;
221 
222   //uint256 public tokenCap = FIRSTSALE_TOKENCAP;
223   //uint256 public cap = tokenCap * DECIMALS_MULTIPLIER;
224   //uint256 public weiCap = tokenCap * FIRSTSALE_BASE_PRICE_IN_WEI;
225 
226   bool public started = false;
227 
228   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
229   event NewClonedToken(address indexed _cloneToken);
230   event OnTransfer(address _from, address _to, uint _amount);
231   event OnApprove(address _owner, address _spender, uint _amount);
232   event LogInt(string _name, uint256 _value);
233   event Finalized();
234 
235   // constructor(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
236     
237 
238   //   startTime = _startTime;
239   //   endTime = _endTime;
240   //   ledToken = LedTokenInterface(_tokenAddress);
241 
242   //   assert(_tokenAddress != 0x0);
243   //   assert(_startTime > 0);
244   //   assert(_endTime > _startTime);
245   // }
246 
247   /**
248    * Low level token purchase function
249    * @param _beneficiary will receive the tokens.
250    */
251   /*function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
252     require(_beneficiary != 0x0);
253     require(validPurchase());
254 
255     uint256 weiAmount = msg.value;
256     require(weiAmount >= MIN_PURCHASE && weiAmount <= MAX_PURCHASE);
257     uint256 priceInWei = FIRSTSALE_BASE_PRICE_IN_WEI;
258     totalWeiRaised = totalWeiRaised.add(weiAmount);
259 
260     uint256 tokens = weiAmount.mul(DECIMALS_MULTIPLIER).div(priceInWei);
261     tokensMinted = tokensMinted.add(tokens);
262     require(tokensMinted < cap);
263 
264     contributors = contributors.add(1);
265 
266     ledToken.mint(_beneficiary, tokens);
267     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
268     forwardFunds();
269   }*/
270 
271 
272   /**
273   * Forwards funds to the tokensale wallet
274   */
275   function forwardFunds() internal {
276     ledMultiSig.transfer(msg.value);
277   }
278 
279 
280   /**
281   * Validates the purchase (period, minimum amount, within cap)
282   * @return {bool} valid
283   */
284   function validPurchase() internal constant returns (bool) {
285     uint256 current = now;
286     bool presaleStarted = (current >= startTime || started);
287     bool presaleNotEnded = current <= endTime;
288     bool nonZeroPurchase = msg.value != 0;
289     return nonZeroPurchase && presaleStarted && presaleNotEnded;
290   }
291 
292   /**
293   * Returns the total Led token supply
294   * @return totalSupply {uint256} Led Token Total Supply
295   */
296   function totalSupply() public constant returns (uint256) {
297     return ledToken.totalSupply();
298   }
299 
300   /**
301   * Returns token holder Led Token balance
302   * @param _owner {address} Token holder address
303   * @return balance {uint256} Corresponding token holder balance
304   */
305   function balanceOf(address _owner) public constant returns (uint256) {
306     return ledToken.balanceOf(_owner);
307   }
308 
309   /**
310   * Change the Led Token controller
311   * @param _newController {address} New Led Token controller
312   */
313   function changeController(address _newController) public onlyOwner {
314     require(isContract(_newController));
315     ledToken.transferControl(_newController);
316   }
317 
318   function enableMasterTransfers() public onlyOwner {
319     ledToken.enableMasterTransfers(true);
320   }
321 
322   function lockMasterTransfers() public onlyOwner {
323     ledToken.enableMasterTransfers(false);
324   }
325 
326   function forceStart() public onlyOwner {
327     started = true;
328   }
329 
330   /*function finalize() public onlyOwner {
331     require(paused);
332     require(!finalized);
333     surplusTokens = cap - tokensMinted;
334     ledToken.mint(ledMultiSig, surplusTokens);
335     ledToken.transferControl(owner);
336 
337     emit Finalized();
338 
339     finalized = true;
340   }*/
341 
342   function isContract(address _addr) constant internal returns(bool) {
343     uint size;
344     if (_addr == 0)
345       return false;
346     assembly {
347         size := extcodesize(_addr)
348     }
349     return size>0;
350   }
351 
352   modifier whenNotFinalized() {
353     require(!finalized);
354     _;
355   }
356 
357 }
358 /**
359  * @title FirstSale
360  * FirstSale allows investors to make token purchases and assigns them tokens based
361 
362  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
363  */
364 contract FirstSale is Crowdsale {
365 
366   uint256 public tokenCap = FIRSTSALE_TOKENCAP;
367   uint256 public cap = tokenCap * DECIMALS_MULTIPLIER;
368   uint256 public weiCap = tokenCap * FIRSTSALE_BASE_PRICE_IN_WEI;
369 
370   constructor(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
371     
372 
373     startTime = _startTime;
374     endTime = _endTime;
375     ledToken = LedTokenInterface(_tokenAddress);
376 
377     assert(_tokenAddress != 0x0);
378     assert(_startTime > 0);
379     assert(_endTime > _startTime);
380   }
381 
382     /**
383    * High level token purchase function
384    */
385   function() public payable {
386     buyTokens(msg.sender);
387   }
388 
389   /**
390    * Low level token purchase function
391    * @param _beneficiary will receive the tokens.
392    */
393   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
394     require(_beneficiary != 0x0);
395     require(validPurchase());
396 
397     uint256 weiAmount = msg.value;
398     require(weiAmount >= MIN_PURCHASE && weiAmount <= MAX_PURCHASE);
399     uint256 priceInWei = FIRSTSALE_BASE_PRICE_IN_WEI;
400     totalWeiRaised = totalWeiRaised.add(weiAmount);
401 
402     uint256 tokens = weiAmount.mul(DECIMALS_MULTIPLIER).div(priceInWei);
403     tokensMinted = tokensMinted.add(tokens);
404     require(tokensMinted < cap);
405 
406     contributors = contributors.add(1);
407 
408     ledToken.mint(_beneficiary, tokens);
409     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
410     forwardFunds();
411   }
412 
413   function getInfo() public view returns(uint256, uint256, string, bool,  uint256, uint256, uint256, 
414   bool, uint256, uint256){
415     uint256 decimals = 18;
416     string memory symbol = "LED";
417     bool transfersEnabled = ledToken.transfersEnabled();
418     return (
419       TOTAL_TOKENCAP, // Tokencap with the decimal point in place. should be 100.000.000
420       decimals, // Decimals
421       symbol,
422       transfersEnabled,
423       contributors,
424       totalWeiRaised,
425       tokenCap, // Tokencap for the first sale with the decimal point in place.
426       started,
427       startTime, // Start time and end time in Unix timestamp format with a length of 10 numbers.
428       endTime
429     );
430   }
431 
432   function finalize() public onlyOwner {
433     require(paused);
434     require(!finalized);
435     surplusTokens = cap - tokensMinted;
436     ledToken.mint(ledMultiSig, surplusTokens);
437     ledToken.transferControl(owner);
438 
439     emit Finalized();
440 
441     finalized = true;
442   }
443 
444 }
445 
446 contract LedToken is Controllable {
447 
448   using SafeMath for uint256;
449   LedTokenInterface public parentToken;
450   TokenFactoryInterface public tokenFactory;
451 
452   string public name;
453   string public symbol;
454   string public version;
455   uint8 public decimals;
456 
457   uint256 public parentSnapShotBlock;
458   uint256 public creationBlock;
459   bool public transfersEnabled;
460 
461   bool public masterTransfersEnabled;
462   address public masterWallet = 0x865e785f98b621c5fdde70821ca7cea9eeb77ef4;
463 
464 
465   struct Checkpoint {
466     uint128 fromBlock;
467     uint128 value;
468   }
469 
470   Checkpoint[] totalSupplyHistory;
471   mapping(address => Checkpoint[]) balances;
472   mapping (address => mapping (address => uint)) allowed;
473 
474   bool public mintingFinished = false;
475   bool public presaleBalancesLocked = false;
476 
477   uint256 public totalSupplyAtCheckpoint;
478 
479   event MintFinished();
480   event NewCloneToken(address indexed cloneToken);
481   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
482   event Transfer(address indexed from, address indexed to, uint256 value);
483 
484 
485 
486 
487   constructor(
488     address _tokenFactory,
489     address _parentToken,
490     uint256 _parentSnapShotBlock,
491     string _tokenName,
492     string _tokenSymbol
493     ) public {
494       tokenFactory = TokenFactoryInterface(_tokenFactory);
495       parentToken = LedTokenInterface(_parentToken);
496       parentSnapShotBlock = _parentSnapShotBlock;
497       name = _tokenName;
498       symbol = _tokenSymbol;
499       decimals = 18;
500       transfersEnabled = false;
501       masterTransfersEnabled = false;
502       creationBlock = block.number;
503       version = '0.1';
504   }
505 
506 
507   /**
508   * Returns the total Led token supply at the current block
509   * @return total supply {uint256}
510   */
511   function totalSupply() public constant returns (uint256) {
512     return totalSupplyAt(block.number);
513   }
514 
515   /**
516   * Returns the total Led token supply at the given block number
517   * @param _blockNumber {uint256}
518   * @return total supply {uint256}
519   */
520   function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
521     // These next few lines are used when the totalSupply of the token is
522     //  requested before a check point was ever created for this token, it
523     //  requires that the `parentToken.totalSupplyAt` be queried at the
524     //  genesis block for this token as that contains totalSupply of this
525     //  token at this block number.
526     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
527         if (address(parentToken) != 0x0) {
528             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
529         } else {
530             return 0;
531         }
532 
533     // This will return the expected totalSupply during normal situations
534     } else {
535         return getValueAt(totalSupplyHistory, _blockNumber);
536     }
537   }
538 
539   /**
540   * Returns the token holder balance at the current block
541   * @param _owner {address}
542   * @return balance {uint256}
543    */
544   function balanceOf(address _owner) public constant returns (uint256 balance) {
545     return balanceOfAt(_owner, block.number);
546   }
547 
548   /**
549   * Returns the token holder balance the the given block number
550   * @param _owner {address}
551   * @param _blockNumber {uint256}
552   * @return balance {uint256}
553   */
554   function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
555     // These next few lines are used when the balance of the token is
556     //  requested before a check point was ever created for this token, it
557     //  requires that the `parentToken.balanceOfAt` be queried at the
558     //  genesis block for that token as this contains initial balance of
559     //  this token
560     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
561         if (address(parentToken) != 0x0) {
562             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
563         } else {
564             // Has no parent
565             return 0;
566         }
567 
568     // This will return the expected balance during normal situations
569     } else {
570         return getValueAt(balances[_owner], _blockNumber);
571     }
572   }
573 
574   /**
575   * Standard ERC20 transfer tokens function
576   * @param _to {address}
577   * @param _amount {uint}
578   * @return success {bool}
579   */
580   function transfer(address _to, uint256 _amount) public returns (bool success) {
581     return doTransfer(msg.sender, _to, _amount);
582   }
583 
584   /**
585   * Standard ERC20 transferFrom function
586   * @param _from {address}
587   * @param _to {address}
588   * @param _amount {uint256}
589   * @return success {bool}
590   */
591   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
592     require(allowed[_from][msg.sender] >= _amount);
593     allowed[_from][msg.sender] -= _amount;
594     return doTransfer(_from, _to, _amount);
595   }
596 
597   /**
598   * Standard ERC20 approve function
599   * @param _spender {address}
600   * @param _amount {uint256}
601   * @return success {bool}
602   */
603   function approve(address _spender, uint256 _amount) public returns (bool success) {
604     require(transfersEnabled);
605 
606     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
607     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
608 
609     allowed[msg.sender][_spender] = _amount;
610     emit Approval(msg.sender, _spender, _amount);
611     return true;
612   }
613 
614   /**
615   * Standard ERC20 approve function
616   * @param _spender {address}
617   * @param _amount {uint256}
618   * @return success {bool}
619   */
620   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
621     approve(_spender, _amount);
622 
623     ApproveAndCallReceiver(_spender).receiveApproval(
624         msg.sender,
625         _amount,
626         this,
627         _extraData
628     );
629 
630     return true;
631   }
632 
633   /**
634   * Standard ERC20 allowance function
635   * @param _owner {address}
636   * @param _spender {address}
637   * @return remaining {uint256}
638    */
639   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
640     return allowed[_owner][_spender];
641   }
642 
643   /**
644   * Internal Transfer function - Updates the checkpoint ledger
645   * @param _from {address}
646   * @param _to {address}
647   * @param _amount {uint256}
648   * @return success {bool}
649   */
650   function doTransfer(address _from, address _to, uint256 _amount) internal returns(bool) {
651 
652     if (msg.sender != masterWallet) {
653       require(transfersEnabled);
654     } else {
655       require(masterTransfersEnabled);
656     }
657 
658     require(_amount > 0);
659     require(parentSnapShotBlock < block.number);
660     require((_to != address(0)) && (_to != address(this)));
661 
662     // If the amount being transfered is more than the balance of the
663     // account the transfer returns false
664     uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
665     require(previousBalanceFrom >= _amount);
666 
667     // First update the balance array with the new value for the address
668     //  sending the tokens
669     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
670 
671     // Then update the balance array with the new value for the address
672     //  receiving the tokens
673     uint256 previousBalanceTo = balanceOfAt(_to, block.number);
674     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
675     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
676 
677     // An event to make the transfer easy to find on the blockchain
678     emit Transfer(_from, _to, _amount);
679     return true;
680   }
681 
682 
683   /**
684   * Token creation functions - can only be called by the tokensale controller during the tokensale period
685   * @param _owner {address}
686   * @param _amount {uint256}
687   * @return success {bool}
688   */
689   function mint(address _owner, uint256 _amount) public onlyController canMint returns (bool) {
690     uint256 curTotalSupply = totalSupply();
691     uint256 previousBalanceTo = balanceOf(_owner);
692 
693     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
694     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
695 
696     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
697     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
698     emit Transfer(0, _owner, _amount);
699     return true;
700   }
701 
702   modifier canMint() {
703     require(!mintingFinished);
704     _;
705   }
706 
707 
708   /**
709    * Import presale balances before the start of the token sale. After importing
710    * balances, lockPresaleBalances() has to be called to prevent further modification
711    * of presale balances.
712    * @param _addresses {address[]} Array of presale addresses
713    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
714    * @return success {bool}
715    */
716   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
717     require(presaleBalancesLocked == false);
718 
719     for (uint256 i = 0; i < _addresses.length; i++) {
720       totalSupplyAtCheckpoint += _balances[i];
721       updateValueAtNow(balances[_addresses[i]], _balances[i]);
722       updateValueAtNow(totalSupplyHistory, totalSupplyAtCheckpoint);
723       emit Transfer(0, _addresses[i], _balances[i]);
724     }
725     return true;
726   }
727 
728   /**
729    * Lock presale balances after successful presale balance import
730    * @return A boolean that indicates if the operation was successful.
731    */
732   function lockPresaleBalances() public onlyController returns (bool) {
733     presaleBalancesLocked = true;
734     return true;
735   }
736 
737   /**
738    * Lock the minting of Led Tokens - to be called after the presale
739    * @return {bool} success
740   */
741   function finishMinting() public onlyController returns (bool) {
742     mintingFinished = true;
743     emit MintFinished();
744     return true;
745   }
746 
747   /**
748    * Enable or block transfers - to be called in case of emergency
749    * @param _value {bool}
750   */
751   function enableTransfers(bool _value) public onlyController {
752     transfersEnabled = _value;
753   }
754 
755   /**
756    * Enable or block transfers - to be called in case of emergency
757    * @param _value {bool}
758   */
759   function enableMasterTransfers(bool _value) public onlyController {
760     masterTransfersEnabled = _value;
761   }
762 
763   /**
764    * Internal balance method - gets a certain checkpoint value a a certain _block
765    * @param _checkpoints {Checkpoint[]} List of checkpoints - supply history or balance history
766    * @return value {uint256} Value of _checkpoints at _block
767   */
768   function getValueAt(Checkpoint[] storage _checkpoints, uint256 _block) constant internal returns (uint256) {
769 
770       if (_checkpoints.length == 0)
771         return 0;
772       // Shortcut for the actual value
773       if (_block >= _checkpoints[_checkpoints.length-1].fromBlock)
774         return _checkpoints[_checkpoints.length-1].value;
775       if (_block < _checkpoints[0].fromBlock)
776         return 0;
777 
778       // Binary search of the value in the array
779       uint256 min = 0;
780       uint256 max = _checkpoints.length-1;
781       while (max > min) {
782           uint256 mid = (max + min + 1) / 2;
783           if (_checkpoints[mid].fromBlock<=_block) {
784               min = mid;
785           } else {
786               max = mid-1;
787           }
788       }
789       return _checkpoints[min].value;
790   }
791 
792 
793   /**
794   * Internal update method - updates the checkpoint ledger at the current block
795   * @param _checkpoints {Checkpoint[]}  List of checkpoints - supply history or balance history
796   * @return value {uint256} Value to add to the checkpoints ledger
797    */
798   function updateValueAtNow(Checkpoint[] storage _checkpoints, uint256 _value) internal {
799       if ((_checkpoints.length == 0) || (_checkpoints[_checkpoints.length-1].fromBlock < block.number)) {
800               Checkpoint storage newCheckPoint = _checkpoints[_checkpoints.length++];
801               newCheckPoint.fromBlock = uint128(block.number);
802               newCheckPoint.value = uint128(_value);
803           } else {
804               Checkpoint storage oldCheckPoint = _checkpoints[_checkpoints.length-1];
805               oldCheckPoint.value = uint128(_value);
806           }
807   }
808 
809 
810   function min(uint256 a, uint256 b) internal pure returns (uint) {
811       return a < b ? a : b;
812   }
813 
814   /**
815   * Clones Led Token at the given snapshot block
816   * @param _snapshotBlock {uint256}
817   * @param _name {string} - The cloned token name
818   * @param _symbol {string} - The cloned token symbol
819   * @return clonedTokenAddress {address}
820    */
821   function createCloneToken(uint256 _snapshotBlock, string _name, string _symbol) public returns(address) {
822 
823       if (_snapshotBlock == 0) {
824         _snapshotBlock = block.number;
825       }
826 
827       if (_snapshotBlock > block.number) {
828         _snapshotBlock = block.number;
829       }
830 
831       LedToken cloneToken = tokenFactory.createCloneToken(
832           this,
833           _snapshotBlock,
834           _name,
835           _symbol
836         );
837 
838 
839       cloneToken.transferControl(msg.sender);
840 
841       // An event to make the token easy to find on the blockchain
842       emit NewCloneToken(address(cloneToken));
843       return address(cloneToken);
844     }
845 
846 }
847 
848 /**
849  * @title LedToken (LED)
850  * Standard Mintable ERC20 Token
851  * https://github.com/ethereum/EIPs/issues/20
852  * Based on code by FirstBlood:
853  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
854  */
855 contract LedTokenInterface is Controllable {
856 
857   bool public transfersEnabled;
858 
859   event Mint(address indexed to, uint256 amount);
860   event MintFinished();
861   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
862   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
863   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
864   event Transfer(address indexed from, address indexed to, uint256 value);
865 
866   function totalSupply() public constant returns (uint);
867   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
868   function balanceOf(address _owner) public constant returns (uint256 balance);
869   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
870   function transfer(address _to, uint256 _amount) public returns (bool success);
871   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
872   function approve(address _spender, uint256 _amount) public returns (bool success);
873   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
874   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
875   function mint(address _owner, uint _amount) public returns (bool);
876   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
877   function lockPresaleBalances() public returns (bool);
878   function finishMinting() public returns (bool);
879   function enableTransfers(bool _value) public;
880   function enableMasterTransfers(bool _value) public;
881   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
882 
883 }
884 
885 /**
886  * @title Presale
887  * Presale allows investors to make token purchases and assigns them tokens based
888 
889  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
890  */
891 contract Presale is Crowdsale {
892 
893   uint256 public tokenCap = PRESALE_TOKENCAP;
894   uint256 public cap = tokenCap * DECIMALS_MULTIPLIER;
895   uint256 public weiCap = tokenCap * PRESALE_BASE_PRICE_IN_WEI;
896 
897   constructor(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
898     
899 
900     startTime = _startTime;
901     endTime = _endTime;
902     ledToken = LedTokenInterface(_tokenAddress);
903 
904     assert(_tokenAddress != 0x0);
905     assert(_startTime > 0);
906     assert(_endTime > _startTime);
907   }
908 
909     /**
910    * High level token purchase function
911    */
912   function() public payable {
913     buyTokens(msg.sender);
914   }
915 
916   /**
917    * Low level token purchase function
918    * @param _beneficiary will receive the tokens.
919    */
920   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
921     require(_beneficiary != 0x0);
922     require(validPurchase());
923 
924     uint256 weiAmount = msg.value;
925     require(weiAmount >= MIN_PURCHASE_OTHERSALES && weiAmount <= MAX_PURCHASE);
926     uint256 priceInWei = PRESALE_BASE_PRICE_IN_WEI;
927     
928     totalWeiRaised = totalWeiRaised.add(weiAmount);
929 
930     uint256 bonusPercentage = determineBonus(weiAmount);
931     uint256 bonusTokens;
932 
933     uint256 initialTokens = weiAmount.mul(DECIMALS_MULTIPLIER).div(priceInWei);
934     if(bonusPercentage>0){
935       uint256 initialDivided = initialTokens.div(100);
936       bonusTokens = initialDivided.mul(bonusPercentage);
937     } else {
938       bonusTokens = 0;
939     }
940     uint256 tokens = initialTokens.add(bonusTokens);
941     tokensMinted = tokensMinted.add(tokens);
942     require(tokensMinted < cap);
943 
944     contributors = contributors.add(1);
945 
946     ledToken.mint(_beneficiary, tokens);
947     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
948     forwardFunds();
949   }
950 
951   function determineBonus(uint256 _wei) public view returns (uint256) {
952     if(_wei > PRESALE_LEVEL_1) {
953       if(_wei > PRESALE_LEVEL_2) {
954         if(_wei > PRESALE_LEVEL_3) {
955           if(_wei > PRESALE_LEVEL_4) {
956             if(_wei > PRESALE_LEVEL_5) {
957               return PRESALE_PERCENTAGE_5;
958             } else {
959               return PRESALE_PERCENTAGE_4;
960             }
961           } else {
962             return PRESALE_PERCENTAGE_3;
963           }
964         } else {
965           return PRESALE_PERCENTAGE_2;
966         }
967       } else {
968         return PRESALE_PERCENTAGE_1;
969       }
970     } else {
971       return 0;
972     }
973   }
974 
975   function finalize() public onlyOwner {
976     require(paused);
977     require(!finalized);
978     surplusTokens = cap - tokensMinted;
979     ledToken.mint(ledMultiSig, surplusTokens);
980     ledToken.transferControl(owner);
981 
982     emit Finalized();
983 
984     finalized = true;
985   }
986 
987   function getInfo() public view returns(uint256, uint256, string, bool,  uint256, uint256, uint256, 
988   bool, uint256, uint256){
989     uint256 decimals = 18;
990     string memory symbol = "LED";
991     bool transfersEnabled = ledToken.transfersEnabled();
992     return (
993       TOTAL_TOKENCAP, // Tokencap with the decimal point in place. should be 100.000.000
994       decimals, // Decimals
995       symbol,
996       transfersEnabled,
997       contributors,
998       totalWeiRaised,
999       tokenCap, // Tokencap for the first sale with the decimal point in place.
1000       started,
1001       startTime, // Start time and end time in Unix timestamp format with a length of 10 numbers.
1002       endTime
1003     );
1004   }
1005   
1006   function getInfoLevels() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, 
1007   uint256, uint256, uint256, uint256){
1008     return (
1009       PRESALE_LEVEL_1, // Amount of ether needed per bonus level
1010       PRESALE_LEVEL_2,
1011       PRESALE_LEVEL_3,
1012       PRESALE_LEVEL_4,
1013       PRESALE_LEVEL_5,
1014       PRESALE_PERCENTAGE_1, // Bonus percentage per bonus level
1015       PRESALE_PERCENTAGE_2,
1016       PRESALE_PERCENTAGE_3,
1017       PRESALE_PERCENTAGE_4,
1018       PRESALE_PERCENTAGE_5
1019     );
1020   }
1021 
1022 }
1023 
1024 /**
1025  * @title PrivateSale
1026  * PrivateSale allows investors to make token purchases and assigns them tokens based
1027 
1028  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
1029  */
1030 contract PrivateSale is Crowdsale {
1031 
1032   uint256 public tokenCap = PRIVATESALE_TOKENCAP;
1033   uint256 public cap = tokenCap * DECIMALS_MULTIPLIER;
1034   uint256 public weiCap = tokenCap * PRIVATESALE_BASE_PRICE_IN_WEI;
1035 
1036   constructor(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
1037     
1038 
1039     startTime = _startTime;
1040     endTime = _endTime;
1041     ledToken = LedTokenInterface(_tokenAddress);
1042 
1043     assert(_tokenAddress != 0x0);
1044     assert(_startTime > 0);
1045     assert(_endTime > _startTime);
1046   }
1047 
1048     /**
1049    * High level token purchase function
1050    */
1051   function() public payable {
1052     buyTokens(msg.sender);
1053   }
1054 
1055   /**
1056    * Low level token purchase function
1057    * @param _beneficiary will receive the tokens.
1058    */
1059   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
1060     require(_beneficiary != 0x0);
1061     require(validPurchase());
1062 
1063 
1064     uint256 weiAmount = msg.value;
1065     require(weiAmount >= MIN_PURCHASE_OTHERSALES && weiAmount <= MAX_PURCHASE);
1066     uint256 priceInWei = PRIVATESALE_BASE_PRICE_IN_WEI;
1067     totalWeiRaised = totalWeiRaised.add(weiAmount);
1068 
1069     uint256 tokens = weiAmount.mul(DECIMALS_MULTIPLIER).div(priceInWei);
1070     tokensMinted = tokensMinted.add(tokens);
1071     require(tokensMinted < cap);
1072 
1073     contributors = contributors.add(1);
1074 
1075     ledToken.mint(_beneficiary, tokens);
1076     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
1077     forwardFunds();
1078   }
1079 
1080   function finalize() public onlyOwner {
1081     require(paused);
1082     require(!finalized);
1083     surplusTokens = cap - tokensMinted;
1084     ledToken.mint(ledMultiSig, surplusTokens);
1085     ledToken.transferControl(owner);
1086 
1087     emit Finalized();
1088 
1089     finalized = true;
1090   }
1091 
1092   function getInfo() public view returns(uint256, uint256, string, bool,  uint256, uint256, uint256, 
1093   bool, uint256, uint256){
1094     uint256 decimals = 18;
1095     string memory symbol = "LED";
1096     bool transfersEnabled = ledToken.transfersEnabled();
1097     return (
1098       TOTAL_TOKENCAP, // Tokencap with the decimal point in place. should be 100.000.000
1099       decimals, // Decimals
1100       symbol,
1101       transfersEnabled,
1102       contributors,
1103       totalWeiRaised,
1104       tokenCap, // Tokencap for the first sale with the decimal point in place.
1105       started,
1106       startTime, // Start time and end time in Unix timestamp format with a length of 10 numbers.
1107       endTime
1108     );
1109   }
1110 
1111 }
1112 
1113 /**
1114  * @title SafeMath
1115  * @dev Math operations with safety checks that throw on error
1116  */
1117 library SafeMath {
1118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1119     uint256 c = a * b;
1120     assert(a == 0 || c / a == b);
1121     return c;
1122   }
1123 
1124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1125     // assert(b > 0); // Solidity automatically throws when dividing by 0
1126     uint256 c = a / b;
1127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1128     return c;
1129   }
1130 
1131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1132     assert(b <= a);
1133     return a - b;
1134   }
1135 
1136   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1137     uint256 c = a + b;
1138     assert(c >= a);
1139     return c;
1140   }
1141 }
1142 
1143 contract TokenFactory {
1144 
1145     function createCloneToken(
1146         address _parentToken,
1147         uint _snapshotBlock,
1148         string _tokenName,
1149         string _tokenSymbol
1150         ) public returns (LedToken) {
1151 
1152         LedToken newToken = new LedToken(
1153             this,
1154             _parentToken,
1155             _snapshotBlock,
1156             _tokenName,
1157             _tokenSymbol
1158         );
1159 
1160         newToken.transferControl(msg.sender);
1161         return newToken;
1162     }
1163 }
1164 
1165 contract TokenFactoryInterface {
1166 
1167     function createCloneToken(
1168         address _parentToken,
1169         uint _snapshotBlock,
1170         string _tokenName,
1171         string _tokenSymbol
1172       ) public returns (LedToken newToken);
1173 }
1174 
1175 /**
1176  * @title Tokensale
1177  * Tokensale allows investors to make token purchases and assigns them tokens based
1178 
1179  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
1180  */
1181 contract TokenSale is Crowdsale {
1182 
1183   uint256 public tokenCap = ICO_TOKENCAP;
1184   uint256 public cap = tokenCap * DECIMALS_MULTIPLIER;
1185   uint256 public weiCap = tokenCap * ICO_BASE_PRICE_IN_WEI;
1186 
1187   uint256 public allocatedTokens;
1188 
1189   constructor(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
1190     
1191 
1192     startTime = _startTime;
1193     endTime = _endTime;
1194     ledToken = LedTokenInterface(_tokenAddress);
1195 
1196     assert(_tokenAddress != 0x0);
1197     assert(_startTime > 0);
1198     assert(_endTime > _startTime);
1199   }
1200 
1201     /**
1202    * High level token purchase function
1203    */
1204   function() public payable {
1205     buyTokens(msg.sender);
1206   }
1207 
1208   /**
1209    * Low level token purchase function
1210    * @param _beneficiary will receive the tokens.
1211    */
1212   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
1213     require(_beneficiary != 0x0);
1214     require(validPurchase());
1215 
1216     uint256 weiAmount = msg.value;
1217     require(weiAmount >= MIN_PURCHASE_OTHERSALES && weiAmount <= MAX_PURCHASE);
1218     uint256 priceInWei = ICO_BASE_PRICE_IN_WEI;
1219     totalWeiRaised = totalWeiRaised.add(weiAmount);
1220 
1221     uint256 bonusPercentage = determineBonus(weiAmount);
1222     uint256 bonusTokens;
1223 
1224     uint256 initialTokens = weiAmount.mul(DECIMALS_MULTIPLIER).div(priceInWei);
1225     if(bonusPercentage>0){
1226       uint256 initialDivided = initialTokens.div(100);
1227       bonusTokens = initialDivided.mul(bonusPercentage);
1228     } else {
1229       bonusTokens = 0;
1230     }
1231     uint256 tokens = initialTokens.add(bonusTokens);
1232     tokensMinted = tokensMinted.add(tokens);
1233     require(tokensMinted < cap);
1234 
1235     contributors = contributors.add(1);
1236 
1237     ledToken.mint(_beneficiary, tokens);
1238     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
1239     forwardFunds();
1240   }
1241 
1242   function determineBonus(uint256 _wei) public view returns (uint256) {
1243     if(_wei > ICO_LEVEL_1) {
1244       if(_wei > ICO_LEVEL_2) {
1245         if(_wei > ICO_LEVEL_3) {
1246           if(_wei > ICO_LEVEL_4) {
1247             if(_wei > ICO_LEVEL_5) {
1248               return ICO_PERCENTAGE_5;
1249             } else {
1250               return ICO_PERCENTAGE_4;
1251             }
1252           } else {
1253             return ICO_PERCENTAGE_3;
1254           }
1255         } else {
1256           return ICO_PERCENTAGE_2;
1257         }
1258       } else {
1259         return ICO_PERCENTAGE_1;
1260       }
1261     } else {
1262       return 0;
1263     }
1264   }
1265 
1266   function allocateLedTokens() public onlyOwner whenNotFinalized {
1267     require(!ledTokensAllocated);
1268     allocatedTokens = LEDTEAM_TOKENS.mul(DECIMALS_MULTIPLIER);
1269     ledToken.mint(ledMultiSig, allocatedTokens);
1270     ledTokensAllocated = true;
1271   }
1272 
1273   function finalize() public onlyOwner {
1274     require(paused);
1275     require(ledTokensAllocated);
1276 
1277     surplusTokens = cap - tokensMinted;
1278     ledToken.mint(ledMultiSig, surplusTokens);
1279 
1280     ledToken.finishMinting();
1281     ledToken.enableTransfers(true);
1282     emit Finalized();
1283 
1284     finalized = true;
1285   }
1286 
1287   function getInfo() public view returns(uint256, uint256, string, bool,  uint256, uint256, uint256, 
1288   bool, uint256, uint256){
1289     uint256 decimals = 18;
1290     string memory symbol = "LED";
1291     bool transfersEnabled = ledToken.transfersEnabled();
1292     return (
1293       TOTAL_TOKENCAP, // Tokencap with the decimal point in place. should be 100.000.000
1294       decimals, // Decimals
1295       symbol,
1296       transfersEnabled,
1297       contributors,
1298       totalWeiRaised,
1299       tokenCap, // Tokencap for the first sale with the decimal point in place.
1300       started,
1301       startTime, // Start time and end time in Unix timestamp format with a length of 10 numbers.
1302       endTime
1303     );
1304   }
1305   
1306   function getInfoLevels() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, 
1307   uint256, uint256, uint256, uint256){
1308     return (
1309       ICO_LEVEL_1, // Amount of ether needed per bonus level
1310       ICO_LEVEL_2,
1311       ICO_LEVEL_3,
1312       ICO_LEVEL_4,
1313       ICO_LEVEL_5,
1314       ICO_PERCENTAGE_1, // Bonus percentage per bonus level
1315       ICO_PERCENTAGE_2,
1316       ICO_PERCENTAGE_3,
1317       ICO_PERCENTAGE_4,
1318       ICO_PERCENTAGE_5
1319     );
1320   }
1321 
1322 }