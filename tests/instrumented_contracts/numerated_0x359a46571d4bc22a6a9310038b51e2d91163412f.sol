1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ApproveAndCallReceiver {
30     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
31 }
32 
33 contract TokenFactoryInterface {
34 
35     function createCloneToken(
36         address _parentToken,
37         uint _snapshotBlock,
38         string _tokenName,
39         string _tokenSymbol
40       ) public returns (ServusToken newToken);
41 }
42 
43 /**
44  * @title Controllable
45  * @dev The Controllable contract has an controller address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Controllable {
49   address public controller;
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
54    */
55   function Controllable() public {
56     controller = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyController() {
63     require(msg.sender == controller);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newController The address to transfer ownership to.
70    */
71   function transferControl(address newController) public onlyController {
72     if (newController != address(0)) {
73       controller = newController;
74     }
75   }
76 
77 }
78 
79 /**
80  * @title ServusToken (SRV)
81  * Standard Mintable ERC20 Token
82  * https://github.com/ethereum/EIPs/issues/20
83  * Based on code by FirstBlood:
84  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract ServusTokenInterface is Controllable {
87 
88   event Mint(address indexed to, uint256 amount);
89   event MintFinished();
90   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
91   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
92   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 
95   function totalSupply() public constant returns (uint);
96   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
97   function balanceOf(address _owner) public constant returns (uint256 balance);
98   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
99   function transfer(address _to, uint256 _amount) public returns (bool success);
100   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
101   function approve(address _spender, uint256 _amount) public returns (bool success);
102   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
103   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
104   function mint(address _owner, uint _amount) public returns (bool);
105   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
106   function lockPresaleBalances() public returns (bool);
107   function finishMinting() public returns (bool);
108   function enableTransfers(bool _value) public;
109   function enableMasterTransfers(bool _value) public;
110   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
111 
112 }
113 /**
114  * @title Ownable
115  * @dev The Ownable contract has an owner address, and provides basic authorization control
116  * functions, this simplifies the implementation of "user permissions".
117  */
118 contract Ownable {
119   address public owner;
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
124    */
125   function Ownable() public {
126     owner = msg.sender;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address newOwner) public onlyOwner {
142     if (newOwner != address(0)) {
143       owner = newOwner;
144     }
145   }
146 
147 }
148 
149 contract ServusToken is Controllable {
150 
151   using SafeMath for uint256;
152   ServusTokenInterface public parentToken;
153   TokenFactoryInterface public tokenFactory;
154 
155   string public name;
156   string public symbol;
157   string public version;
158   uint8 public decimals;
159 
160   uint256 public parentSnapShotBlock;
161   uint256 public creationBlock;
162   bool public transfersEnabled;
163 
164   bool public masterTransfersEnabled;
165   address public masterWallet = 0x9d23cc4efa366b70f34f1879bc6178e6f3342441;
166 
167 
168   struct Checkpoint {
169     uint128 fromBlock;
170     uint128 value;
171   }
172 
173   Checkpoint[] totalSupplyHistory;
174   mapping(address => Checkpoint[]) balances;
175   mapping (address => mapping (address => uint)) allowed;
176 
177   bool public mintingFinished = false;
178   bool public presaleBalancesLocked = false;
179 
180   uint256 public constant TOTAL_PRESALE_TOKENS = 2896000000000000000000;
181 
182   event Mint(address indexed to, uint256 amount);
183   event MintFinished();
184   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
185   event NewCloneToken(address indexed cloneToken);
186   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 
189 
190 
191 
192   function ServusToken(
193     address _tokenFactory,
194     address _parentToken,
195     uint256 _parentSnapShotBlock,
196     string _tokenName,
197     string _tokenSymbol
198     ) public {
199       tokenFactory = TokenFactoryInterface(_tokenFactory);
200       parentToken = ServusTokenInterface(_parentToken);
201       parentSnapShotBlock = _parentSnapShotBlock;
202       name = _tokenName;
203       symbol = _tokenSymbol;
204       decimals = 6;
205       transfersEnabled = false;
206       masterTransfersEnabled = false;
207       creationBlock = block.number;
208       version = '0.1';
209   }
210 
211   function() public payable {
212     revert();
213   }
214 
215 
216   /**
217   * Returns the total Servus token supply at the current block
218   * @return total supply {uint256}
219   */
220   function totalSupply() public constant returns (uint256) {
221     return totalSupplyAt(block.number);
222   }
223 
224   /**
225   * Returns the total Servus token supply at the given block number
226   * @param _blockNumber {uint256}
227   * @return total supply {uint256}
228   */
229   function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
230     // These next few lines are used when the totalSupply of the token is
231     //  requested before a check point was ever created for this token, it
232     //  requires that the `parentToken.totalSupplyAt` be queried at the
233     //  genesis block for this token as that contains totalSupply of this
234     //  token at this block number.
235     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
236         if (address(parentToken) != 0) {
237             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
238         } else {
239             return 0;
240         }
241 
242     // This will return the expected totalSupply during normal situations
243     } else {
244         return getValueAt(totalSupplyHistory, _blockNumber);
245     }
246   }
247 
248   /**
249   * Returns the token holder balance at the current block
250   * @param _owner {address}
251   * @return balance {uint256}
252    */
253   function balanceOf(address _owner) public constant returns (uint256 balance) {
254     return balanceOfAt(_owner, block.number);
255   }
256 
257   /**
258   * Returns the token holder balance the the given block number
259   * @param _owner {address}
260   * @param _blockNumber {uint256}
261   * @return balance {uint256}
262   */
263   function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
264     // These next few lines are used when the balance of the token is
265     //  requested before a check point was ever created for this token, it
266     //  requires that the `parentToken.balanceOfAt` be queried at the
267     //  genesis block for that token as this contains initial balance of
268     //  this token
269     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
270         if (address(parentToken) != 0) {
271             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
272         } else {
273             // Has no parent
274             return 0;
275         }
276 
277     // This will return the expected balance during normal situations
278     } else {
279         return getValueAt(balances[_owner], _blockNumber);
280     }
281   }
282 
283   /**
284   * Standard ERC20 transfer tokens function
285   * @param _to {address}
286   * @param _amount {uint}
287   * @return success {bool}
288   */
289   function transfer(address _to, uint256 _amount) public returns (bool success) {
290     return doTransfer(msg.sender, _to, _amount);
291   }
292 
293   /**
294   * Standard ERC20 transferFrom function
295   * @param _from {address}
296   * @param _to {address}
297   * @param _amount {uint256}
298   * @return success {bool}
299   */
300   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
301     require(allowed[_from][msg.sender] >= _amount);
302     allowed[_from][msg.sender] -= _amount;
303     return doTransfer(_from, _to, _amount);
304   }
305 
306   /**
307   * Standard ERC20 approve function
308   * @param _spender {address}
309   * @param _amount {uint256}
310   * @return success {bool}
311   */
312   function approve(address _spender, uint256 _amount) public returns (bool success) {
313     require(transfersEnabled);
314 
315     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
317 
318     allowed[msg.sender][_spender] = _amount;
319     Approval(msg.sender, _spender, _amount);
320     return true;
321   }
322 
323   /**
324   * Standard ERC20 approve function
325   * @param _spender {address}
326   * @param _amount {uint256}
327   * @return success {bool}
328   */
329   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
330     approve(_spender, _amount);
331 
332     ApproveAndCallReceiver(_spender).receiveApproval(
333         msg.sender,
334         _amount,
335         this,
336         _extraData
337     );
338 
339     return true;
340   }
341 
342   /**
343   * Standard ERC20 allowance function
344   * @param _owner {address}
345   * @param _spender {address}
346   * @return remaining {uint256}
347    */
348   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
349     return allowed[_owner][_spender];
350   }
351 
352   /**
353   * Internal Transfer function - Updates the checkpoint ledger
354   * @param _from {address}
355   * @param _to {address}
356   * @param _amount {uint256}
357   * @return success {bool}
358   */
359   function doTransfer(address _from, address _to, uint256 _amount) internal returns(bool) {
360 
361     if (msg.sender != masterWallet) {
362       require(transfersEnabled);
363     } else {
364       require(masterTransfersEnabled);
365     }
366 
367     require(_amount > 0);
368     require(parentSnapShotBlock < block.number);
369     require((_to != 0) && (_to != address(this)));
370 
371     // If the amount being transfered is more than the balance of the
372     // account the transfer returns false
373     uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
374     require(previousBalanceFrom >= _amount);
375 
376     // First update the balance array with the new value for the address
377     //  sending the tokens
378     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
379 
380     // Then update the balance array with the new value for the address
381     //  receiving the tokens
382     uint256 previousBalanceTo = balanceOfAt(_to, block.number);
383     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
384     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
385 
386     // An event to make the transfer easy to find on the blockchain
387     Transfer(_from, _to, _amount);
388     return true;
389   }
390 
391 
392   /**
393   * Token creation functions - can only be called by the tokensale controller during the tokensale period
394   * @param _owner {address}
395   * @param _amount {uint256}
396   * @return success {bool}
397   */
398   function mint(address _owner, uint256 _amount) public onlyController canMint returns (bool) {
399     uint256 curTotalSupply = totalSupply();
400     uint256 previousBalanceTo = balanceOf(_owner);
401 
402     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
403     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
404 
405     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
406     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
407     Transfer(0, _owner, _amount);
408     return true;
409   }
410 
411   modifier canMint() {
412     require(!mintingFinished);
413     _;
414   }
415 
416 
417   /**
418    * Import presale balances before the start of the token sale. After importing
419    * balances, lockPresaleBalances() has to be called to prevent further modification
420    * of presale balances.
421    * @param _addresses {address[]} Array of presale addresses
422    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
423    * @return success {bool}
424    */
425   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
426     require(presaleBalancesLocked == false);
427 
428     for (uint256 i = 0; i < _addresses.length; i++) {
429       updateValueAtNow(balances[_addresses[i]], _balances[i]);
430       Transfer(0, _addresses[i], _balances[i]);
431     }
432 
433     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
434     return true;
435   }
436 
437   /**
438    * Lock presale balances after successful presale balance import
439    * @return A boolean that indicates if the operation was successful.
440    */
441   function lockPresaleBalances() public onlyController returns (bool) {
442     presaleBalancesLocked = true;
443     return true;
444   }
445 
446   /**
447    * Lock the minting of Servus Tokens - to be called after the presale
448    * @return {bool} success
449   */
450   function finishMinting() public onlyController returns (bool) {
451     mintingFinished = true;
452     MintFinished();
453     return true;
454   }
455 
456   /**
457    * Enable or block transfers - to be called in case of emergency
458    * @param _value {bool}
459   */
460   function enableTransfers(bool _value) public onlyController {
461     transfersEnabled = _value;
462   }
463 
464   /**
465    * Enable or block transfers - to be called in case of emergency
466    * @param _value {bool}
467   */
468   function enableMasterTransfers(bool _value) public onlyController {
469     masterTransfersEnabled = _value;
470   }
471 
472   /**
473    * Internal balance method - gets a certain checkpoint value a a certain _block
474    * @param _checkpoints {Checkpoint[]} List of checkpoints - supply history or balance history
475    * @return value {uint256} Value of _checkpoints at _block
476   */
477   function getValueAt(Checkpoint[] storage _checkpoints, uint256 _block) constant internal returns (uint256) {
478 
479       if (_checkpoints.length == 0)
480         return 0;
481       // Shortcut for the actual value
482       if (_block >= _checkpoints[_checkpoints.length-1].fromBlock)
483         return _checkpoints[_checkpoints.length-1].value;
484       if (_block < _checkpoints[0].fromBlock)
485         return 0;
486 
487       // Binary search of the value in the array
488       uint256 min = 0;
489       uint256 max = _checkpoints.length-1;
490       while (max > min) {
491           uint256 mid = (max + min + 1) / 2;
492           if (_checkpoints[mid].fromBlock<=_block) {
493               min = mid;
494           } else {
495               max = mid-1;
496           }
497       }
498       return _checkpoints[min].value;
499   }
500 
501 
502   /**
503   * Internal update method - updates the checkpoint ledger at the current block
504   * @param _checkpoints {Checkpoint[]}  List of checkpoints - supply history or balance history
505   * @return value {uint256} Value to add to the checkpoints ledger
506    */
507   function updateValueAtNow(Checkpoint[] storage _checkpoints, uint256 _value) internal {
508       if ((_checkpoints.length == 0) || (_checkpoints[_checkpoints.length-1].fromBlock < block.number)) {
509               Checkpoint storage newCheckPoint = _checkpoints[_checkpoints.length++];
510               newCheckPoint.fromBlock = uint128(block.number);
511               newCheckPoint.value = uint128(_value);
512           } else {
513               Checkpoint storage oldCheckPoint = _checkpoints[_checkpoints.length-1];
514               oldCheckPoint.value = uint128(_value);
515           }
516   }
517 
518 
519   function min(uint256 a, uint256 b) internal constant returns (uint) {
520       return a < b ? a : b;
521   }
522 
523   /**
524   * Clones Servus Token at the given snapshot block
525   * @param _snapshotBlock {uint256}
526   * @param _name {string} - The cloned token name
527   * @param _symbol {string} - The cloned token symbol
528   * @return clonedTokenAddress {address}
529    */
530   function createCloneToken(uint256 _snapshotBlock, string _name, string _symbol) public returns(address) {
531 
532       if (_snapshotBlock == 0) {
533         _snapshotBlock = block.number;
534       }
535 
536       if (_snapshotBlock > block.number) {
537         _snapshotBlock = block.number;
538       }
539 
540       ServusToken cloneToken = tokenFactory.createCloneToken(
541           this,
542           _snapshotBlock,
543           _name,
544           _symbol
545         );
546 
547 
548       cloneToken.transferControl(msg.sender);
549 
550       // An event to make the token easy to find on the blockchain
551       NewCloneToken(address(cloneToken));
552       return address(cloneToken);
553     }
554 
555 }
556 
557 /**
558  * @title Pausable
559  * @dev Base contract which allows children to implement an emergency stop mechanism.
560  */
561 contract Pausable is Ownable {
562   event Pause();
563   event Unpause();
564 
565   bool public paused = false;
566 
567   function Pausable() public {}
568 
569   /**
570    * @dev modifier to allow actions only when the contract IS paused
571    */
572   modifier whenNotPaused() {
573     require(!paused);
574     _;
575   }
576 
577   /**
578    * @dev modifier to allow actions only when the contract IS NOT paused
579    */
580   modifier whenPaused {
581     require(paused);
582     _;
583   }
584 
585   /**
586    * @dev called by the owner to pause, triggers stopped state
587    */
588   function pause() public onlyOwner whenNotPaused returns (bool) {
589     paused = true;
590     Pause();
591     return true;
592   }
593 
594   /**
595    * @dev called by the owner to unpause, returns to normal state
596    */
597   function unpause() public onlyOwner whenPaused returns (bool) {
598     paused = false;
599     Unpause();
600     return true;
601   }
602 }
603 
604 /**
605  * @title Tokensale
606  * Tokensale allows investors to make token purchases and assigns them tokens based
607 
608  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
609  */
610 contract TokenSale is Pausable {
611 
612   using SafeMath for uint256;
613 
614   ServusTokenInterface public servusToken;
615   uint256 public totalWeiRaised;
616   uint256 public tokensMinted;
617   uint256 public totalSupply;
618   uint256 public contributors;
619   uint256 public decimalsMultiplier;
620   uint256 public startTime;
621   uint256 public endTime;
622   uint256 public remainingTokens;
623   uint256 public allocatedTokens;
624 
625   bool public finalized;
626 
627   bool public servusTokensAllocated;
628   address public servusMultiSig = 0x0cc3e09c8a52fa0313154321be706635cdbdec37;
629 
630   uint256 public constant BASE_PRICE_IN_WEI = 1000000000000000;
631   uint256 public constant PUBLIC_TOKENS = 100000000 * (10 ** 6);
632   uint256 public constant TOTAL_PRESALE_TOKENS = 50000000 * (10 ** 6);
633   uint256 public constant TOKENS_ALLOCATED_TO_SERVUS = 100000000 * (10 ** 6);
634 
635 
636 
637   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
638   uint256 public cap = tokenCap;
639   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
640 
641   uint256 public firstDiscountPrice = (BASE_PRICE_IN_WEI * 85) / 100;
642   uint256 public secondDiscountPrice = (BASE_PRICE_IN_WEI * 90) / 100;
643   uint256 public thirdDiscountPrice = (BASE_PRICE_IN_WEI * 95) / 100;
644 
645   uint256 public firstDiscountCap = (weiCap * 5) / 100;
646   uint256 public secondDiscountCap = (weiCap * 10) / 100;
647   uint256 public thirdDiscountCap = (weiCap * 20) / 100;
648 
649   bool public started = false;
650 
651   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
652   event NewClonedToken(address indexed _cloneToken);
653   event OnTransfer(address _from, address _to, uint _amount);
654   event OnApprove(address _owner, address _spender, uint _amount);
655   event LogInt(string _name, uint256 _value);
656   event Finalized();
657 
658   function TokenSale(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
659     require(_tokenAddress != 0x0);
660     require(_startTime > 0);
661     require(_endTime > _startTime);
662 
663     startTime = _startTime;
664     endTime = _endTime;
665     servusToken = ServusTokenInterface(_tokenAddress);
666 
667     decimalsMultiplier = (10 ** 6);
668   }
669 
670 
671   /**
672    * High level token purchase function
673    */
674   function() public payable {
675     buyTokens(msg.sender);
676   }
677 
678   /**
679    * Low level token purchase function
680    * @param _beneficiary will receive the tokens.
681    */
682   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
683     require(_beneficiary != 0x0);
684     require(validPurchase());
685 
686     uint256 weiAmount = msg.value;
687     uint256 priceInWei = getPriceInWei();
688     totalWeiRaised = totalWeiRaised.add(weiAmount);
689 
690     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
691     tokensMinted = tokensMinted.add(tokens);
692     require(tokensMinted < tokenCap);
693 
694     contributors = contributors.add(1);
695 
696     servusToken.mint(_beneficiary, tokens);
697     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
698     forwardFunds();
699   }
700 
701 
702   /**
703    * Get the price in wei for current premium
704    * @return price {uint256}
705    */
706   function getPriceInWei() constant public returns (uint256) {
707 
708     uint256 price;
709 
710     if (totalWeiRaised < firstDiscountCap) {
711       price = firstDiscountPrice;
712     } else if (totalWeiRaised < secondDiscountCap) {
713       price = secondDiscountPrice;
714     } else if (totalWeiRaised < thirdDiscountCap) {
715       price = thirdDiscountPrice;
716     } else {
717       price = BASE_PRICE_IN_WEI;
718     }
719 
720     return price;
721   }
722 
723   /**
724   * Forwards funds to the tokensale wallet
725   */
726   function forwardFunds() internal {
727     servusMultiSig.transfer(msg.value);
728   }
729 
730 
731   /**
732   * Validates the purchase (period, minimum amount, within cap)
733   * @return {bool} valid
734   */
735   function validPurchase() internal constant returns (bool) {
736     uint256 current = now;
737     bool presaleStarted = (current >= startTime || started);
738     bool presaleNotEnded = current <= endTime;
739     bool nonZeroPurchase = msg.value != 0;
740     return nonZeroPurchase && presaleStarted && presaleNotEnded;
741   }
742 
743   /**
744   * Returns the total Servus token supply
745   * @return totalSupply {uint256} Servus Token Total Supply
746   */
747   function totalSupply() public constant returns (uint256) {
748     return servusToken.totalSupply();
749   }
750 
751   /**
752   * Returns token holder Servus Token balance
753   * @param _owner {address} Token holder address
754   * @return balance {uint256} Corresponding token holder balance
755   */
756   function balanceOf(address _owner) public constant returns (uint256) {
757     return servusToken.balanceOf(_owner);
758   }
759 
760   /**
761   * Change the Servus Token controller
762   * @param _newController {address} New Servus Token controller
763   */
764   function changeController(address _newController) public {
765     require(isContract(_newController));
766     servusToken.transferControl(_newController);
767   }
768 
769 
770   function enableTransfers() public {
771     if (now < endTime) {
772       require(msg.sender == owner);
773     }
774     servusToken.enableTransfers(true);
775   }
776 
777   function lockTransfers() public onlyOwner {
778     require(now < endTime);
779     servusToken.enableTransfers(false);
780   }
781 
782   function enableMasterTransfers() public onlyOwner {
783     servusToken.enableMasterTransfers(true);
784   }
785 
786   function lockMasterTransfers() public onlyOwner {
787     servusToken.enableMasterTransfers(false);
788   }
789 
790   function forceStart() public onlyOwner {
791     started = true;
792   }
793 
794   function allocateServusTokens() public onlyOwner whenNotFinalized {
795     require(!servusTokensAllocated);
796     servusToken.mint(servusMultiSig, TOKENS_ALLOCATED_TO_SERVUS);
797     servusTokensAllocated = true;
798   }
799 
800   function finalize() public onlyOwner {
801     require(paused);
802     require(servusTokensAllocated);
803 
804     servusToken.finishMinting();
805     servusToken.enableTransfers(true);
806     Finalized();
807 
808     finalized = true;
809   }
810 
811 
812   function isContract(address _addr) constant internal returns(bool) {
813     uint size;
814     if (_addr == 0)
815       return false;
816     assembly {
817         size := extcodesize(_addr)
818     }
819     return size>0;
820   }
821 
822   modifier whenNotFinalized() {
823     require(!finalized);
824     _;
825   }
826 
827 }