1 pragma solidity ^0.4.19;
2 
3 // 
4 // UberDelta Exchange Contract - v1.0.0
5 // 
6 //  www.uberdelta.com
7 //
8 
9 contract Token {
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function transfer(address _to, uint256 _value) public returns (bool success);
12   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13   function approve(address _spender, uint256 _value) public returns (bool success);
14 }
15 
16 contract SafeMath {
17   function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     require(c / a == b);
23     return c;
24   }
25   
26   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     require(b > 0); //gentler than an assert.
28     c = a / b;
29     return c;
30   }
31 
32 
33   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b <= a);
35     return a - b;
36   }
37 
38 
39   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     require(c >= a);
42     return c;
43   }
44 }
45 
46 contract OwnerManager {
47 
48   address public owner;
49   address public newOwner;
50   address public manager;
51 
52   event OwnershipTransferProposed(address indexed _from, address indexed _to);
53   event OwnershipTransferConfirmed(address indexed _from, address indexed _to);
54   event NewManager(address indexed _newManager);
55 
56 
57   modifier onlyOwner {
58     assert(msg.sender == owner);
59     _;
60   }
61   
62   modifier onlyManager {
63     assert(msg.sender == manager);
64     _;
65   }
66 
67 
68   function OwnerManager() public{
69     owner = msg.sender;
70     manager = msg.sender;
71   }
72 
73 
74   function transferOwnership(address _newOwner) onlyOwner external{
75     require(_newOwner != owner);
76     
77     OwnershipTransferProposed(owner, _newOwner);
78     
79     newOwner = _newOwner;
80   }
81 
82 
83   function confirmOwnership() external {
84     assert(msg.sender == newOwner);
85     
86     OwnershipTransferConfirmed(owner, newOwner);
87     
88     owner = newOwner;
89   }
90 
91 
92   function newManager(address _newManager) onlyOwner external{
93     require(_newManager != address(0x0));
94     
95     NewManager(_newManager);
96     
97     manager = _newManager;
98   }
99 
100 }
101 
102 
103 contract Helper is OwnerManager {
104 
105   mapping (address => bool) public isHelper;
106 
107   modifier onlyHelper {
108     assert(isHelper[msg.sender] == true);
109     _;
110   }
111 
112   event ChangeHelper(
113     address indexed helper,
114     bool status
115   );
116 
117   function Helper() public{
118     isHelper[msg.sender] = true;
119   }
120 
121   function changeHelper(address _helper, bool _status) external onlyManager {
122 	  ChangeHelper(_helper, _status);
123     isHelper[_helper] = _status;
124   }
125 
126 }
127 
128 
129 contract Compliance {
130   function canDeposit(address _user) public view returns (bool isAllowed);
131   function canTrade(address _token, address _user) public view returns (bool isAllowed);
132   function validateTrade(
133     address _token,
134     address _getUser,
135     address _giveUser
136   )
137     public
138     view
139     returns (bool isAllowed)
140   ;
141 }
142 
143 contract OptionRegistry {
144   function registerOptionPair(
145     address _assetTokenAddress,
146     uint256 _assetTokenAmount,
147     address _strikeTokenAddress,
148     uint256 _strikeTokenAmount,
149     uint256 _optionExpires
150   )
151   public
152   returns(bool)
153   ;
154   
155   function isOptionPairRegistered(
156     address _assetTokenAddress,
157     uint256 _assetTokenAmount,
158     address _strikeTokenAddress,
159     uint256 _strikeTokenAmount,
160     uint256 _optionExpires
161   )
162   public
163   view
164   returns(bool)  
165   ;
166   
167 }
168 
169 contract EOS {
170     function register(string key) public;
171 }
172 
173 contract UberDelta is SafeMath, OwnerManager, Helper {
174 
175   // The account that will receive fees
176   address public feeAccount;
177   
178   // The account that will receive lost ERC20 tokens
179   address public sweepAccount;
180   
181   // The address of the compliance engine
182   address public complianceAddress;
183   
184   // The address of the options registry
185   address public optionsRegistryAddress;
186   
187   // The address of the next exchange contract
188   address public newExchange;
189 
190   // Turn off deposits and trades, allow upgrade and withdraw
191   bool public contractLocked;
192   
193   bytes32 signedTradeHash = keccak256(
194     "address contractAddress",
195     "address takerTokenAddress",
196     "uint256 takerTokenAmount",
197     "address makerTokenAddress",
198     "uint256 makerTokenAmount",
199     "uint256 tradeExpires",
200     "uint256 salt",
201     "address maker",
202     "address restrictedTo"
203   );
204   
205   bytes32 signedWithdrawHash = keccak256(
206     "address contractAddress",
207     "uint256 amount",
208     "uint256 fee",
209     "uint256 withdrawExpires",
210     "uint256 salt",
211     "address maker",
212     "address restrictedTo"
213   );
214 
215 
216   // Balance per token, for each user.
217   mapping (address => mapping (address => uint256)) public balances;
218   
219   // global token balance tracking (to detect lost tokens)
220   mapping (address => uint256) public globalBalance;
221   
222   // List of orders created by calling the exchange contract directly.
223   mapping (bytes32 => bool) public orders;
224   
225   // Lists the amount of each order that has been filled or cancelled.
226   mapping (bytes32 => uint256) public orderFills;
227   
228   // Tokens that need to be checked through the compliance engine.
229   mapping (address => bool) public restrictedTokens;
230 
231   // Mapping of fees by user class (default class == 0x0)
232   mapping (uint256 => uint256) public feeByClass;
233   
234   // Mapping of users to user classes.
235   mapping (address => uint256) public userClass; 
236   
237   
238   /*******************************************
239   / Exchange Regular Events
240   /******************************************/
241   
242   // Note: Order creation is usually off-chain
243   event Order(
244     bytes32 indexed tradePair,
245     address indexed maker,
246     address[4] addressData,
247     uint256[4] numberData
248   );
249   
250   event Cancel(
251     bytes32 indexed tradePair,
252     address indexed maker,
253     address[4] addressData,
254     uint256[4] numberData,
255     uint256 status
256   );
257   
258    event FailedTrade( 
259     bytes32 indexed tradePair,
260     address indexed taker,
261     bytes32 hash,
262     uint256 failReason
263   ); 
264   
265   event Trade( 
266     bytes32 indexed tradePair,
267     address indexed maker,
268     address indexed taker,
269     address makerToken,
270     address takerToken,
271     address restrictedTo,
272     uint256[4] numberData,
273     uint256 tradeAmount,
274     bool fillOrKill
275   );
276   
277   event Deposit(
278     address indexed token,
279     address indexed toUser,
280     address indexed sender,
281     uint256 amount
282   );
283   
284   event Withdraw(
285     address indexed token,
286     address indexed toUser,
287     uint256 amount
288   );
289 
290   event InternalTransfer(
291     address indexed token,
292     address indexed toUser,
293     address indexed sender,
294     uint256 amount
295   );
296 
297   event TokenSweep(
298     address indexed token,
299     address indexed sweeper,
300     uint256 amount,
301     uint256 balance
302   );
303   
304   event RestrictToken(
305     address indexed token,
306     bool status
307   );
308   
309   event NewExchange(
310     address newExchange
311   );
312   
313   event ChangeFeeAccount(
314     address feeAccount
315   );
316   
317   event ChangeSweepAccount(
318     address sweepAccount
319   );
320   
321   event ChangeClassFee(
322     uint256 indexed class,
323     uint256 fee
324   );
325   
326   event ChangeUserClass(
327     address indexed user,
328     uint256 class
329   );
330   
331   event LockContract(
332     bool status
333   );
334   
335   event UpdateComplianceAddress(
336     address newComplianceAddress
337   );
338   
339   event UpdateOptionsRegistryAddress(
340     address newOptionsRegistryAddress
341   );
342   
343   event Upgrade(
344     address indexed user,
345     address indexed token,
346     address newExchange,
347     uint256 amount
348   );
349   
350   event RemoteWithdraw(
351     address indexed maker,
352     address indexed sender,
353     uint256 withdrawAmount,
354     uint256 feeAmount,
355     uint256 withdrawExpires,
356     uint256 salt,
357     address restrictedTo
358   );
359   
360   event CancelRemoteWithdraw(
361     address indexed maker,
362     uint256 withdrawAmount,
363     uint256 feeAmount,
364     uint256 withdrawExpires,
365     uint256 salt,
366     address restrictedTo,
367     uint256 status
368   );
369 
370   //Constructor Function, set initial values.
371   function UberDelta() public {
372     feeAccount = owner;
373     sweepAccount = owner;
374     feeByClass[0x0] = 3000000000000000;
375     contractLocked = false;
376     complianceAddress = this;
377     optionsRegistryAddress = this;
378   }
379 
380 
381   // Prevent raw sends of Eth.
382   function() public {
383     revert();
384   }
385   
386   
387   
388   /*******************************************
389   / Contract Control Functions
390   /******************************************/
391   function changeNewExchange(address _newExchange) external onlyOwner {
392     //since _newExchange being zero turns off the upgrade function, lets
393     //allow this to be reset to 0x0.
394     
395     newExchange = _newExchange;
396     
397     NewExchange(_newExchange);
398   }
399 
400 
401   function changeFeeAccount(address _feeAccount) external onlyManager {
402     require(_feeAccount != address(0x0));
403     
404     feeAccount = _feeAccount;
405     
406     ChangeFeeAccount(_feeAccount);
407   }
408 
409   function changeSweepAccount(address _sweepAccount) external onlyManager {
410     require(_sweepAccount != address(0x0));
411     
412     sweepAccount = _sweepAccount;
413     
414     ChangeSweepAccount(_sweepAccount);
415   }
416 
417   function changeClassFee(uint256 _class, uint256 _fee) external onlyManager {
418     require(_fee <= 10000000000000000); //Max 1%.
419 
420     feeByClass[_class] = _fee;
421 
422     ChangeClassFee(_class, _fee);
423   }
424   
425   function changeUserClass(address _user, uint256 _newClass) external onlyHelper {
426     userClass[_user] = _newClass;
427     
428     ChangeUserClass(_user, _newClass);
429   }
430   
431   //Turn off deposits and trades, but still allow withdrawals and upgrades.
432   function lockContract(bool _lock) external onlyManager {
433     contractLocked = _lock;
434     
435     LockContract(_lock);
436   }
437   
438   function updateComplianceAddress(address _newComplianceAddress)
439     external
440     onlyManager
441   {
442     complianceAddress = _newComplianceAddress;
443     
444     UpdateComplianceAddress(_newComplianceAddress);
445   }
446 
447   function updateOptionsRegistryAddress(address _newOptionsRegistryAddress)
448     external
449     onlyManager
450   {
451     optionsRegistryAddress = _newOptionsRegistryAddress;
452     
453     UpdateOptionsRegistryAddress(_newOptionsRegistryAddress);
454   }
455 
456 
457   // restriction function for tokens that need additional verifications
458   function tokenRestriction(address _newToken, bool _status) external onlyHelper {
459     restrictedTokens[_newToken] = _status;
460     
461     RestrictToken(_newToken, _status);
462   }
463 
464   
465   //Turn off deposits and trades, but still allow withdrawals and upgrades.
466   modifier notLocked() {
467     require(!contractLocked);
468     _;
469   }
470   
471   
472   /*******************************************************
473   / Deposit/Withdrawal/Transfer
474   /
475   / In all of the following functions, it should be noted
476   / that the 0x0 address is used to represent ETH.
477   /******************************************************/
478   
479   // SafeMath sanity checks inputs in deposit(), withdraw(), and token functions.
480   
481   // Deposit ETH in the contract to trade with
482   function deposit() external notLocked payable returns(uint256) {
483     require(Compliance(complianceAddress).canDeposit(msg.sender)); 
484     // defaults to true until we change compliance code
485     
486     balances[address(0x0)][msg.sender] = safeAdd(balances[address(0x0)][msg.sender], msg.value);
487     globalBalance[address(0x0)] = safeAdd(globalBalance[address(0x0)], msg.value);
488 
489     Deposit(0x0, msg.sender, msg.sender, msg.value);
490     
491     return(msg.value);
492   }
493 
494   // Withdraw ETH from the contract to your wallet  (internal transaction on etherscan)
495   function withdraw(uint256 _amount) external returns(uint256) {
496     //require(balances[address(0x0)][msg.sender] >= _amount);
497     //handled by safeSub.
498     
499     balances[address(0x0)][msg.sender] = safeSub(balances[address(0x0)][msg.sender], _amount);
500     globalBalance[address(0x0)] = safeSub(globalBalance[address(0x0)], _amount);
501  
502     //transfer has a built in require
503     msg.sender.transfer(_amount);
504     
505     Withdraw(0x0, msg.sender, _amount);
506     
507     return(_amount);
508   }
509 
510 
511   // Deposit ERC20 tokens in the contract to trade with
512   // Token(_token).approve(this, _amount) must be called in advance
513   // ERC223 tokens must be deposited by a transfer to this contract ( see tokenFallBack(..) )
514   function depositToken(address _token, uint256 _amount) external notLocked returns(uint256) {
515     require(_token != address(0x0));
516     
517     require(Compliance(complianceAddress).canDeposit(msg.sender));
518 
519     balances[_token][msg.sender] = safeAdd(balances[_token][msg.sender], _amount);
520     globalBalance[_token] = safeAdd(globalBalance[_token], _amount);
521     
522     require(Token(_token).transferFrom(msg.sender, this, _amount));
523 
524     Deposit(_token, msg.sender, msg.sender, _amount);
525     
526     return(_amount);
527   }
528 
529   // Withdraw ERC20/223 tokens from the contract back to your wallet
530   function withdrawToken(address _token, uint256 _amount)
531     external
532     returns (uint256)
533   {
534     if (_token == address(0x0)){
535       //keep the nulls to reduce gas usage.
536       //require(balances[_token)][msg.sender] >= _amount);
537       //handled by safeSub.
538       balances[address(0x0)][msg.sender] = safeSub(balances[address(0x0)][msg.sender], _amount);
539       globalBalance[address(0x0)] = safeSub(globalBalance[address(0x0)], _amount);
540 
541       //transfer has a built in require
542       msg.sender.transfer(_amount);
543     } else {
544       //require(balances[_token][msg.sender] >= _amount);
545       //handled by safeSub 
546  
547       balances[_token][msg.sender] = safeSub(balances[_token][msg.sender], _amount);
548       globalBalance[_token] = safeSub(globalBalance[_token], _amount);
549 
550       require(Token(_token).transfer(msg.sender, _amount));
551     }    
552 
553     Withdraw(_token, msg.sender, _amount);
554     
555     return _amount;
556   }
557 
558   // Deposit ETH in the contract on behalf of another address
559   // Warning: afterwards, only _user will be able to trade or withdraw these funds
560   function depositToUser(address _toUser) external payable notLocked returns (bool success) {
561     require(
562         (_toUser != address(0x0))
563      && (_toUser != address(this))
564      && (Compliance(complianceAddress).canDeposit(_toUser))
565     );
566     
567     balances[address(0x0)][_toUser] = safeAdd(balances[address(0x0)][_toUser], msg.value);
568     globalBalance[address(0x0)] = safeAdd(globalBalance[address(0x0)], msg.value);
569     
570     Deposit(0x0, _toUser, msg.sender, msg.value);
571     
572     return true;
573   }
574 
575   // Deposit ERC20 tokens in the contract on behalf of another address
576   // Token(_token).approve(this, _amount) must be called in advance
577   // Warning: afterwards, only _toUser will be able to trade or withdraw these funds
578   // ERC223 tokens must be deposited by a transfer to this contract ( see tokenFallBack(..) )
579   function depositTokenToUser(
580     address _toUser,
581     address _token,
582     uint256 _amount
583   )
584     external
585     notLocked
586     returns (bool success)
587   {
588     require(
589         (_token != address(0x0))
590 
591      && (_toUser  != address(0x0))
592      && (_toUser  != address(this))
593      && (_toUser  != _token)
594      && (Compliance(complianceAddress).canDeposit(_toUser))
595     );
596     
597     balances[_token][_toUser] = safeAdd(balances[_token][_toUser], _amount);
598     globalBalance[_token] = safeAdd(globalBalance[_token], _amount);
599 
600     require(Token(_token).transferFrom(msg.sender, this, _amount));
601 
602     Deposit(_token, _toUser, msg.sender, _amount);
603     
604     return true;
605   }
606 
607 
608   //ERC223 Token Acceptor function, called when an ERC2223 token is transferred to this contract
609   // provide _sendTo to make it a deposit on behalf of another address (depositToUser)
610   function tokenFallback(
611     address _from,  // user calling the function
612     uint256 _value, // the number of tokens
613     bytes _sendTo     // "deposit to other user" if exactly 20 bytes sent
614     
615   )
616     external
617     notLocked
618   {
619     //first lets figure out who this is going to.
620     address toUser = _from;     //probably this
621     if (_sendTo.length == 20){  //but use data for sendTo otherwise.
622 
623       // I'm about 90% sure I don't need to do the casting here, but for
624       // like twenty gas, I'll take the protection from potentially
625       // stomping on weird memory locations.
626       
627       uint256 asmAddress;
628       assembly { //uses 50 gas
629         asmAddress := calldataload(120)
630       }
631       toUser = address(asmAddress);
632     }
633     
634     //sanity checks.
635     require(
636         (toUser != address(0x0))
637      && (toUser != address(this))
638      && (toUser != msg.sender)  // msg.sender is the token
639      && (Compliance(complianceAddress).canDeposit(toUser))
640     );
641     
642     // check if a contract is calling this
643     uint256 codeLength;
644     assembly {
645       codeLength := extcodesize(caller)
646     }
647     require(codeLength > 0);    
648     
649     globalBalance[msg.sender] = safeAdd(globalBalance[msg.sender], _value);
650     balances[msg.sender][toUser] = safeAdd(balances[msg.sender][toUser], _value);
651     
652     //sanity check, and as a perk, we check for balanceOf();
653     require(Token(msg.sender).balanceOf(this) >= _value);
654 
655     Deposit(msg.sender, toUser, _from, _value);
656   }
657 
658   // Move deposited tokens or ETH (0x0) from one to another address within the contract
659   function internalTransfer(
660     address _toUser,
661     address _token,
662     uint256 _amount
663   )
664     external
665     notLocked 
666     returns(uint256)
667   {
668     require(
669         (balances[_token][msg.sender] >= _amount)
670      && (_toUser != address(0x0))
671      && (_toUser != address(this))
672      && (_toUser != _token)
673      && (Compliance(complianceAddress).canDeposit(_toUser))
674     );
675  
676     balances[_token][msg.sender] = safeSub(balances[_token][msg.sender], _amount);
677     balances[_token][_toUser] = safeAdd(balances[_token][_toUser], _amount);
678 
679     InternalTransfer(_token, _toUser, msg.sender, _amount);
680     
681     return(_amount);
682   }
683   
684   // return the token/ETH balance a user has deposited in the contract
685   function balanceOf(address _token, address _user) external view returns (uint) {
686     return balances[_token][_user];
687   }
688 
689   
690   // In order to see the ERC20 total balance, we're calling an external contract,
691   // and this contract claims to be ERC20, but we don't know what's really there.
692   // We can't rely on the EVM or solidity to enforce "view", so even though a
693   // normal token can rely on itself to be non-malicious, we can't.
694   // We have no idea what potentially evil tokens we'll be interacting with.
695   // The call to check the reported balance needs to go after the state changes,
696   // even though it's un-natural. Now, on one hand, this function might at first
697   // appear safe, since we're only allowing the sweeper address to access
698   // *this function,* but we are reading the state of the globalBalance.
699   // In theory, a malicious token could do the following:
700   //  1a) Check if the caller of balanceOf is our contract, if it's not, act normally.
701   //  1b) If the caller is our contract, it does the following:
702   //  2) Read our contracts globalBalance for its own address.
703   //  3) Sets our contract's balance of the token (in the token controller) to our internal globalBalance
704   //  4) Allocates some other address the difference in globalBalance and actual balance for our contract.
705   //  5) Report back to this function exactly the amount we had in globalBalance.
706   // (which, by then is true, since they were stolen).
707   // Now we're always going to see 0 extra tokens, and our users have had their tokens perminantly lost.
708   // bonus: this is why there is no "sweep all" function.
709     
710   // Detect ERC20 tokens that have been sent to the contract without a deposit (lost tokens),
711   // which are not included in globalBalance[..]
712   function sweepTokenAmount(address _token, uint256 _amount) external returns(uint256) {
713     assert(msg.sender == sweepAccount);
714 
715     balances[_token][sweepAccount] = safeAdd(balances[_token][sweepAccount], _amount);
716     globalBalance[_token] = safeAdd(globalBalance[_token], _amount);
717     
718     //You go last!
719 	if(_token != address(0x0)) { 
720       require(globalBalance[_token] <= Token(_token).balanceOf(this));
721 	} else {
722 	  // if another contract performs selfdestruct(UberDelta),
723     // ETH can get in here without being in globalBalance
724 	  require(globalBalance[address(0x0)] <= this.balance); 
725 	}
726     
727     TokenSweep(_token, msg.sender, _amount, balances[_token][sweepAccount]);
728     
729     return(_amount);
730   }
731   
732   
733   /*******************************************
734   / Regular Trading functions
735   /******************************************/
736   
737   //now contracts can place orders!
738   
739   
740   // Normal order creation happens off-chain and orders are signed by creators,
741   // this function allows for on-chain orders to be created
742   function order(
743     address[4] _addressData,
744     uint256[4] _numberData //web3 isn't ready for structs.
745   )
746     external
747     notLocked
748     returns (bool success)
749   {
750   
751 //    _addressData[2] is maker;
752     if (msg.sender != _addressData[2]) { return false; }
753     
754     bytes32 hash = getHash(_addressData, _numberData);
755 
756     orders[hash] = true;
757 
758     Order(
759       (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
760       msg.sender,
761       _addressData,
762       _numberData);
763     
764     return true;
765   }  
766 
767 
768   function tradeBalances(
769     address _takerTokenAddress,
770     uint256 _takerTokenAmount,
771     address _makerTokenAddress,
772     uint256 _makerTokenAmount,
773     address _maker,
774     uint256 _tradeAmount
775   )
776     internal
777   {
778     require(_takerTokenAmount > 0); //safeDiv
779 
780     // We charge only the takers this fee
781     uint256 feeValue = safeMul(_tradeAmount, feeByClass[userClass[msg.sender]]) / (1 ether);
782     
783     balances[_takerTokenAddress][_maker] =
784       safeAdd(balances[_takerTokenAddress][_maker], _tradeAmount);
785     balances[_takerTokenAddress][msg.sender] =
786       safeSub(balances[_takerTokenAddress][msg.sender], safeAdd(_tradeAmount, feeValue));
787     
788     balances[_makerTokenAddress][_maker] =
789       safeSub(
790         balances[_makerTokenAddress][_maker],
791         safeMul(_makerTokenAmount, _tradeAmount) / _takerTokenAmount
792       );
793     balances[_makerTokenAddress][msg.sender] =
794       safeAdd(
795         balances[_makerTokenAddress][msg.sender],
796         safeMul(_makerTokenAmount, _tradeAmount) / _takerTokenAmount
797       );
798     
799     balances[_takerTokenAddress][feeAccount] =
800       safeAdd(balances[_takerTokenAddress][feeAccount], feeValue);
801   }
802 
803 
804   function trade(
805     address[4] _addressData,
806     uint256[4] _numberData, //web3 isn't ready for structs.
807     uint8 _v,
808     bytes32 _r,
809     bytes32 _s,
810     uint256 _amount,
811     bool _fillOrKill
812   )
813     external
814     notLocked
815     returns(uint256 tradeAmount)
816   {
817   
818 //      _addressData[0], // takerTokenAddress;
819 //      _numberData[0], // takerTokenAmount;
820 //      _addressData[1], // makerTokenAddress;
821 //      _numberData[1], // makerTokenAmount;
822 //      _numberData[2], // tradeExpires;
823 //      _numberData[3], // salt;
824 //      _addressData[2], // maker;
825 //      _addressData[3] // restrictedTo;
826     
827     bytes32 hash = getHash(_addressData, _numberData);
828     
829     tradeAmount = safeSub(_numberData[0], orderFills[hash]); //avail to trade
830     
831     //balance of giveToken / amount I said I'd give of giveToken * amount I said I want of getToken
832     if (
833       tradeAmount > safeDiv(
834         safeMul(balances[_addressData[1]][_addressData[2]], _numberData[0]),
835         _numberData[1]
836       )
837     )
838     {
839       tradeAmount = safeDiv(
840         safeMul(balances[_addressData[1]][_addressData[2]], _numberData[0]),
841         _numberData[1]
842       );
843     }
844     
845     if (tradeAmount > _amount) { tradeAmount = _amount; }
846     
847         //_numberData[0] is takerTokenAmount
848     if (tradeAmount == 0) { //idfk. There's nothing there to get. Canceled? Traded?
849       if (orderFills[hash] < _numberData[0]) { //Maker seems to be missing tokens?
850         FailedTrade(
851           (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
852           msg.sender,
853           hash,
854           0
855         );
856       } else {  // either cancelled or already traded.
857         FailedTrade(
858           (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
859           msg.sender,
860           hash,
861           1
862         );
863       }
864       return 0;
865     }
866     
867     
868     if (block.number > _numberData[2]) { //order is expired
869       FailedTrade(
870         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
871         msg.sender,
872         hash,
873         2
874       );
875       return 0;
876     }
877 
878 
879     if ((_fillOrKill == true) && (tradeAmount < _amount)) { //didnt fill, so kill
880       FailedTrade(
881         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
882         msg.sender,
883         hash,
884         3
885       );
886       return 0;
887     }
888     
889         
890     uint256 feeValue = safeMul(_amount, feeByClass[userClass[msg.sender]]) / (1 ether);
891 
892     //if they trade more than they have, get 0.
893     if ( (_amount + feeValue) > balances[_addressData[0]][msg.sender])  { 
894       FailedTrade(
895         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
896         msg.sender,
897         hash,
898         4
899       );
900       return 0;
901     }
902     
903     if ( //not a valid order.
904         (ecrecover(keccak256(signedTradeHash, hash), _v, _r, _s) != _addressData[2])
905         && (! orders[hash])
906     )
907     {
908       FailedTrade(
909         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
910         msg.sender,
911         hash,
912         5
913       );
914       return 0;
915     }
916 
917     
918     if ((_addressData[3] != address(0x0)) && (_addressData[3] != msg.sender)) { //check restrictedTo
919       FailedTrade(
920         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
921         msg.sender,
922         hash,
923         6
924       );
925       return 0;
926     }
927         
928     
929     if ( //if there's a compliance restriction.
930       ((_addressData[0] != address(0x0)) //if not Eth, and restricted, check with Compliance.
931         && (restrictedTokens[_addressData[0]] )
932         && ! Compliance(complianceAddress).validateTrade(_addressData[0], _addressData[2], msg.sender)
933       )
934       || ((_addressData[1] != address(0x0))  //ditto
935         && (restrictedTokens[_addressData[1]])
936         && ! Compliance(complianceAddress).validateTrade(_addressData[1], _addressData[2], msg.sender)
937       )
938     )
939     {
940       FailedTrade(
941         (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
942         msg.sender,
943         hash,
944         7
945       );
946       return 0;
947     }
948     
949     //Do the thing!
950     
951     tradeBalances(
952       _addressData[0], // takerTokenAddress;
953       _numberData[0], // takerTokenAmount;
954       _addressData[1], // makerTokenAddress;
955       _numberData[1], // makerTokenAmount;
956       _addressData[2], // maker;
957       tradeAmount
958     );
959 
960     orderFills[hash] = safeAdd(orderFills[hash], tradeAmount);
961 
962     Trade(
963       (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
964       _addressData[2],
965       msg.sender,
966       _addressData[1],
967       _addressData[0],
968       _addressData[3],
969       _numberData,
970       tradeAmount,
971       _fillOrKill
972     );
973     
974     return(tradeAmount);
975   }
976   
977   
978   // Cancel a signed order, once this is confirmed nobody will be able to trade it anymore
979   function cancelOrder(
980     address[4] _addressData,
981     uint256[4] _numberData //web3 isn't ready for structs.
982   )
983     external
984     returns(uint256 amountCancelled)
985   {
986     
987     require(msg.sender == _addressData[2]);
988     
989     //  msg.sender can 'cancel' nonexistent orders since they're offchain.
990     bytes32 hash = getHash(_addressData, _numberData);
991  
992     amountCancelled = safeSub(_numberData[0],orderFills[hash]);
993     
994     orderFills[hash] = _numberData[0];
995  
996     //event trigger is moved ahead of balance resetting to allow expression of the already-filled amount
997 //    _numberData[0] is takerTokenAmount;
998     Cancel(
999       (bytes32(_addressData[0]) ^ bytes32(_addressData[1])),
1000       msg.sender,
1001       _addressData,
1002       _numberData,
1003       amountCancelled);
1004 
1005     return amountCancelled;    
1006   }
1007 
1008 
1009 
1010   /**************************
1011   / Remote Withdraw
1012   ***************************/
1013   
1014   // Perform an ETH withdraw transaction for someone else based on their signed message
1015   // Useful if the owner of the funds does not have enough ETH for gas fees in their wallet.
1016   // msg.sender receives fee for the effort and gas costs
1017   function remoteWithdraw(
1018     uint256 _withdrawAmount,
1019     uint256 _feeAmount,
1020     uint256 _withdrawExpires,
1021     uint256 _salt,
1022     address _maker,
1023     address _restrictedTo, //0x0 = anyone
1024     uint8 _v,
1025     bytes32 _r,
1026     bytes32 _s
1027   )
1028     external
1029     notLocked
1030     returns(bool)
1031   {
1032     //is the withdraw possible?
1033     require(
1034         (balances[address(0x0)][_maker] >= safeAdd(_withdrawAmount, _feeAmount))
1035      && (
1036             (_restrictedTo == address(0x0))
1037          || (_restrictedTo == msg.sender)
1038         )
1039      && ((_feeAmount == 0) || (Compliance(complianceAddress).canDeposit(msg.sender)))
1040     );
1041     
1042     //has this withdraw happened already? (and generate the hash)
1043 
1044     bytes32 hash = keccak256(
1045       this, 
1046       _withdrawAmount,
1047       _feeAmount,
1048       _withdrawExpires,
1049       _salt,
1050       _maker,
1051       _restrictedTo
1052     );
1053 
1054     require(orderFills[hash] == 0);
1055 
1056     //is this real?
1057     require(
1058       ecrecover(keccak256(signedWithdrawHash, hash), _v, _r, _s) == _maker
1059     );
1060     
1061     //only once.
1062     orderFills[hash] = 1;
1063 
1064     balances[address(0x0)][_maker] =
1065       safeSub(balances[address(0x0)][_maker], safeAdd(_withdrawAmount, _feeAmount));
1066     // pay fee to the user performing the remote withdraw
1067     balances[address(0x0)][msg.sender] = safeAdd(balances[address(0x0)][msg.sender], _feeAmount);
1068     
1069     globalBalance[address(0x0)] = safeSub(globalBalance[address(0x0)], _withdrawAmount);
1070 
1071     RemoteWithdraw(
1072       _maker,
1073       msg.sender,
1074       _withdrawAmount,
1075       _feeAmount,
1076       _withdrawExpires,
1077       _salt,
1078       _restrictedTo
1079     );
1080 
1081     //implicit require included.
1082     _maker.transfer(_withdrawAmount);
1083     
1084     return(true);
1085   }
1086 
1087   // cancel a signed request for a remote withdraw
1088   function cancelRemoteWithdraw(
1089     uint256 _withdrawAmount,
1090     uint256 _feeAmount,
1091     uint256 _withdrawExpires,
1092     uint256 _salt,
1093     address _restrictedTo //0x0 = anyone
1094   )
1095     external
1096   {
1097       // msg.sender can cancel nonexsistent orders.
1098     bytes32 hash = keccak256(
1099       this, 
1100       _withdrawAmount,
1101       _feeAmount,
1102       _withdrawExpires,
1103       _salt,
1104       msg.sender,
1105       _restrictedTo
1106     );
1107     
1108     CancelRemoteWithdraw(
1109       msg.sender,
1110       _withdrawAmount,
1111       _feeAmount,
1112       _withdrawExpires,
1113       _salt,
1114       _restrictedTo,
1115       orderFills[hash]
1116     );
1117     
1118     //set to completed after, event shows pre-cancel status.
1119     orderFills[hash] = 1;
1120   }
1121   
1122   
1123  
1124 
1125   /**************************
1126   /Upgrade Function
1127   ***************************/
1128       
1129   // move tokens/ETH over to a new upgraded smart contract  (avoids having to withdraw & deposit)
1130   function upgrade(address _token) external returns(uint256 moveBalance) {
1131     require (newExchange != address(0x0));
1132 
1133     moveBalance = balances[_token][msg.sender];
1134 
1135     globalBalance[_token] = safeSub(globalBalance[_token], moveBalance);
1136     balances[_token][msg.sender] = 0;
1137 
1138     if (_token != address(0x0)){
1139       require(Token(_token).approve(newExchange, moveBalance));
1140       require(UberDelta(newExchange).depositTokenToUser(msg.sender, _token, moveBalance));
1141     } else {
1142       require(UberDelta(newExchange).depositToUser.value(moveBalance)(msg.sender));
1143     }
1144 
1145     Upgrade(msg.sender, _token, newExchange, moveBalance);
1146     
1147     return(moveBalance);
1148   }
1149 
1150 
1151   
1152   /*******************************************
1153   / Data View functions
1154   /******************************************/
1155   
1156   function testTrade(
1157     address[4] _addressData,
1158     uint256[4] _numberData, //web3 isn't ready for structs.
1159     uint8 _v,
1160     bytes32 _r,
1161     bytes32 _s,
1162     uint256 _amount,
1163     address _sender,
1164     bool _fillOrKill
1165   )
1166     public
1167     view
1168     returns(uint256)
1169   {
1170     uint256 feeValue = safeMul(_amount, feeByClass[userClass[_sender]]) / (1 ether);
1171 
1172     if (
1173       contractLocked
1174       ||
1175       ((_addressData[0] != address(0x0)) //if not Eth, and restricted, check with Compliance.
1176         && (restrictedTokens[_addressData[0]] )
1177         && ! Compliance(complianceAddress).validateTrade(_addressData[0], _addressData[2], _sender)
1178       )
1179       || ((_addressData[1] != address(0x0))  //ditto
1180         && (restrictedTokens[_addressData[1]])
1181         && ! Compliance(complianceAddress).validateTrade(_addressData[1], _addressData[2], _sender)
1182       )
1183          //if they trade more than they have, get 0.
1184       || ((_amount + feeValue) > balances[_addressData[0]][_sender]) 
1185       || ((_addressData[3] != address(0x0)) && (_addressData[3] != _sender)) //check restrictedTo
1186     )
1187     {
1188       return 0;
1189     }
1190       
1191     uint256 tradeAmount = availableVolume(
1192         _addressData,
1193         _numberData,
1194         _v,
1195         _r,
1196         _s
1197     );
1198     
1199     if (tradeAmount > _amount) { tradeAmount = _amount; }
1200     
1201     if ((_fillOrKill == true) && (tradeAmount < _amount)) {
1202       return 0;
1203     }
1204 
1205     return tradeAmount;
1206   }
1207 
1208 
1209   // get how much of an order is left (unfilled)
1210   // return value in order of _takerTokenAddress
1211   function availableVolume(
1212     address[4] _addressData,
1213     uint256[4] _numberData, //web3 isn't ready for structs.
1214     uint8 _v,
1215     bytes32 _r,
1216     bytes32 _s
1217   )
1218     public
1219     view
1220     returns(uint256 amountRemaining)
1221   {     
1222 //    _addressData[0] // takerTokenAddress;
1223 //    _numberData[0] // takerTokenAmount;
1224 //    _addressData[1] // makerTokenAddress;
1225 //    _numberData[1] // makerTokenAmount;
1226 //    _numberData[2] // tradeExpires;
1227 //    _numberData[3] // salt;
1228 //    _addressData[2] // maker;
1229 //    _addressData[3] // restrictedTo;
1230 
1231     bytes32 hash = getHash(_addressData, _numberData);
1232 
1233     if (
1234       (block.number > _numberData[2])
1235       || ( 
1236         (ecrecover(keccak256(signedTradeHash, hash), _v, _r, _s) != _addressData[2])
1237         && (! orders[hash])
1238       )
1239     ) { return 0; }
1240 
1241     //uint256 amountRemaining = safeSub(myTrade.takerTokenAmount, orderFills[hash]);
1242      amountRemaining = safeSub(_numberData[0], orderFills[hash]);
1243 
1244     if (
1245       amountRemaining < safeDiv(
1246         safeMul(balances[_addressData[1]][_addressData[2]], _numberData[0]),
1247         _numberData[1]
1248       )
1249     ) return amountRemaining;
1250 
1251     return (
1252       safeDiv(
1253         safeMul(balances[_addressData[1]][_addressData[2]], _numberData[0]),
1254         _numberData[1]
1255       )
1256     );
1257   }
1258 
1259 
1260   // get how much of an order has been filled
1261   // return value in order of _takerTokenAddress
1262   function getUserFee(
1263     address _user
1264   )
1265     external
1266     view
1267     returns(uint256)
1268   {
1269     return feeByClass[userClass[_user]];
1270   }
1271 
1272 
1273   // get how much of an order has been filled
1274   // return value in order of _takerTokenAddress
1275   function amountFilled(
1276     address[4] _addressData,
1277     uint256[4] _numberData //web3 isn't ready for structs.
1278   )
1279     external
1280     view
1281     returns(uint256)
1282   {
1283     bytes32 hash = getHash(_addressData, _numberData);
1284 
1285     return orderFills[hash];
1286   }
1287 
1288   
1289   // check if a request for a remote withdraw is still valid
1290   function testRemoteWithdraw(
1291     uint256 _withdrawAmount,
1292     uint256 _feeAmount,
1293     uint256 _withdrawExpires,
1294     uint256 _salt,
1295     address _maker,
1296     address _restrictedTo,
1297     uint8 _v,
1298     bytes32 _r,
1299     bytes32 _s,
1300     address _sender
1301   )
1302     external
1303     view
1304     returns(uint256)
1305   {
1306     bytes32 hash = keccak256(
1307       this,
1308       _withdrawAmount,
1309       _feeAmount,
1310       _withdrawExpires,
1311       _salt,
1312       _maker,
1313       _restrictedTo
1314     );
1315 
1316     if (
1317       contractLocked
1318       ||
1319       (balances[address(0x0)][_maker] < safeAdd(_withdrawAmount, _feeAmount))
1320       ||((_restrictedTo != address(0x0)) && (_restrictedTo != _sender))
1321       || (orderFills[hash] != 0)
1322       || (ecrecover(keccak256(signedWithdrawHash, hash), _v, _r, _s) != _maker)
1323       || ((_feeAmount > 0) && (! Compliance(complianceAddress).canDeposit(_sender)))
1324     )
1325     {
1326       return 0;
1327     } else {
1328       return _withdrawAmount;
1329     }
1330   }
1331   
1332   
1333   
1334   function getHash(
1335     address[4] _addressData,
1336     uint256[4] _numberData //web3 isn't ready for structs.
1337   )
1338     public
1339     view
1340     returns(bytes32)
1341   {
1342     return(
1343       keccak256(
1344         this,
1345         _addressData[0], // takerTokenAddress;
1346         _numberData[0], // takerTokenAmount;
1347         _addressData[1], // makerTokenAddress;
1348         _numberData[1], // makerTokenAmount;
1349         _numberData[2], // tradeExpires;
1350         _numberData[3], // salt;
1351         _addressData[2], // maker;
1352         _addressData[3] // restrictedTo;
1353       )
1354     );
1355   }
1356   
1357   
1358 
1359   /***********************************
1360   / Compliance View Code
1361   ************************************/
1362   //since the compliance code might move, we should have a way to always
1363   //call a function to this contract to get the current values
1364 
1365     function testCanDeposit(
1366     address _user
1367   )
1368     external
1369     view
1370     returns (bool)
1371   {
1372     return(Compliance(complianceAddress).canDeposit(_user));
1373   }
1374   
1375   function testCanTrade(
1376     address _token,
1377     address _user
1378   )
1379     external
1380     view
1381     returns (bool)
1382   {
1383     return(Compliance(complianceAddress).canTrade(_token, _user));
1384   }
1385 
1386   
1387   function testValidateTrade(
1388     address _token,
1389     address _getUser,
1390     address _giveUser
1391   )
1392     external
1393     view
1394     returns (bool isAllowed)
1395   {
1396     return(Compliance(complianceAddress).validateTrade(_token, _getUser, _giveUser));
1397   }
1398   
1399 
1400 
1401   /**************************
1402   / Default Compliance Code
1403   ***************************/
1404   // These will eventually live in a different contract.
1405   // every can deposit by default, later a registry?
1406   // For now, always say no if called for trades. 
1407   // the earliest use may be halting trade in a token.
1408   function canDeposit(
1409     address _user
1410   )
1411     public
1412     view
1413     returns (bool isAllowed)
1414   {
1415     return(true);
1416   }
1417   
1418   function canTrade(
1419     address _token,
1420     address _user
1421   )
1422     public
1423     view
1424     returns (bool isAllowed)
1425   {
1426     return(false);
1427   }
1428 
1429   
1430   function validateTrade(
1431     address _token,
1432     address _getUser,
1433     address _giveUser
1434   )
1435     public
1436     view
1437     returns (bool isAllowed)
1438   {
1439     return(false);
1440   }
1441   
1442 
1443 
1444   /***********************************
1445   / THIS IS WHERE OPTIONS LIVE!!!!
1446   /**********************************/
1447   
1448   
1449   mapping (address => uint256) public exercisedOptions;
1450   
1451   //get asset for tickets
1452   event CollapseOption(
1453     address indexed user,
1454     address indexed holderTicketAddress,
1455     address indexed writerTicketAddress,
1456     uint256 ticketsCollapsed,
1457     bytes32 optionPair //assetTokenAddress xor strikeTokenAddress
1458   );    
1459   
1460   //get holderticket + asset for strike
1461   event ExcerciseUnwind(
1462     address indexed user,
1463     address indexed holderTicketAddress,
1464     uint256 ticketsUnwound,
1465     bytes32 optionPair,
1466     bool fillOrKill
1467   );  
1468   
1469   //get asset for writerticket
1470   event ExpireOption(
1471     address indexed user,
1472     address indexed writerTicketAddress,
1473     uint256 ticketsExpired,
1474     bytes32 optionPair
1475   );  
1476   
1477   //get tickets for asset
1478   event CreateOption(
1479     address indexed user,
1480     address indexed holderTicketAddress,
1481     address indexed writerTicketAddress,
1482     uint256 ticketsCreated,
1483     bytes32 optionPair
1484   );  
1485   
1486   //get assset for strike + holderticket
1487   event ExcerciseOption(
1488     address indexed user,
1489     address indexed holderTicketAddress,
1490     uint256 ticketsExcercised,
1491     bytes32 optionPair //assetTokenAddress xor strikeTokenAddress
1492   );  
1493   
1494   /******************
1495   / optionFunctions
1496   ******************/
1497   
1498   //if before expiry, deposit asset, get buy ticket, write ticket
1499   // 1 ticket gets (10^18) option units credited to them.
1500   function createOptionPair( //#65
1501     address _assetTokenAddress,
1502     uint256 _assetTokenAmount,
1503     address _strikeTokenAddress,
1504     uint256 _strikeTokenAmount,
1505     uint256 _optionExpires,
1506     uint256 _ticketAmount //tickets times (1 ether)
1507   )
1508     external
1509     notLocked
1510     returns (uint256 ticketsCreated)
1511   {
1512     //if before expiry
1513     require (block.number < _optionExpires); //option would be expired
1514     
1515     //if they have the asset
1516     //[checked by safemath during locking]
1517 
1518     //lock asset to 0x0.
1519     //the percent of one contract times _assetTokenAmount = amount moving
1520     //creation fee?
1521     balances[_assetTokenAddress][0x0] =
1522       safeAdd(
1523         balances[_assetTokenAddress][0x0],
1524         safeDiv(safeMul(_assetTokenAmount, _ticketAmount), 1 ether)
1525       );
1526 
1527     balances[_assetTokenAddress][msg.sender] =
1528       safeSub(
1529         balances[_assetTokenAddress][msg.sender],
1530         safeDiv(safeMul(_assetTokenAmount, _ticketAmount), 1 ether)
1531       );
1532     
1533     
1534     address holderTicketAddress = getOptionAddress(
1535       _assetTokenAddress,
1536       _assetTokenAmount,
1537       _strikeTokenAddress,
1538       _strikeTokenAmount,
1539       _optionExpires,
1540       false
1541     );
1542     
1543     address writerTicketAddress = getOptionAddress(
1544       _assetTokenAddress,
1545       _assetTokenAmount,
1546       _strikeTokenAddress,
1547       _strikeTokenAmount,
1548       _optionExpires,
1549       true
1550     );
1551     
1552     //issue write option
1553     balances[writerTicketAddress][msg.sender] =
1554       safeAdd(balances[writerTicketAddress][msg.sender], _ticketAmount);
1555     globalBalance[writerTicketAddress] =
1556       safeAdd(globalBalance[writerTicketAddress], _ticketAmount);
1557 
1558     //issue hold option
1559     balances[holderTicketAddress][msg.sender] =
1560       safeAdd(balances[holderTicketAddress][msg.sender], _ticketAmount);
1561     globalBalance[holderTicketAddress] =
1562       safeAdd(globalBalance[holderTicketAddress], _ticketAmount);
1563 
1564     CreateOption(
1565       msg.sender,
1566       holderTicketAddress,
1567       writerTicketAddress,
1568       _ticketAmount,
1569       (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress))
1570     );
1571     
1572     //check if we need to register, and do if we do.
1573     if (
1574       OptionRegistry(optionsRegistryAddress).isOptionPairRegistered(
1575         _assetTokenAddress,
1576         _assetTokenAmount,
1577         _strikeTokenAddress,
1578         _strikeTokenAmount,
1579         _optionExpires
1580       )
1581       == false
1582     )
1583     {
1584       require(
1585         OptionRegistry(optionsRegistryAddress).registerOptionPair(
1586           _assetTokenAddress,
1587           _assetTokenAmount,
1588           _strikeTokenAddress,
1589           _strikeTokenAmount,
1590           _optionExpires
1591         )
1592       );
1593     }
1594     return _ticketAmount;
1595   }
1596   
1597   //if own buy & writer ticket get asset, void tickets
1598   // 1 ticket gets 10^18 option units voided.
1599   function collapseOptionPair( //#66
1600     address _assetTokenAddress,
1601     uint256 _assetTokenAmount,
1602     address _strikeTokenAddress,
1603     uint256 _strikeTokenAmount,
1604     uint256 _optionExpires,
1605     uint256 _ticketAmount
1606   )
1607     external
1608     returns (uint256 ticketsCollapsed)
1609   {
1610     
1611     address holderTicketAddress = getOptionAddress(
1612       _assetTokenAddress,
1613       _assetTokenAmount,
1614       _strikeTokenAddress,
1615       _strikeTokenAmount,
1616       _optionExpires,
1617       false
1618     );
1619     
1620     address writerTicketAddress = getOptionAddress(
1621       _assetTokenAddress,
1622       _assetTokenAmount,
1623       _strikeTokenAddress,
1624       _strikeTokenAmount,
1625       _optionExpires,
1626       true
1627     );
1628     
1629     //if they have the write option
1630     //if they have the hold option
1631     require (
1632       (balances[holderTicketAddress][msg.sender] >= _ticketAmount)
1633       && (balances[writerTicketAddress][msg.sender] >= _ticketAmount)
1634     );
1635     //I guess it can be expired, since you have both legs.
1636     
1637     //void write option
1638     balances[writerTicketAddress][msg.sender] =
1639       safeSub(balances[writerTicketAddress][msg.sender], _ticketAmount);
1640     globalBalance[writerTicketAddress] =
1641       safeSub(globalBalance[writerTicketAddress], _ticketAmount);
1642 
1643     //void hold option
1644     balances[holderTicketAddress][msg.sender] =
1645       safeSub(balances[holderTicketAddress][msg.sender], _ticketAmount);
1646     globalBalance[holderTicketAddress] =
1647       safeSub(globalBalance[holderTicketAddress], _ticketAmount);
1648  
1649     //unlock asset
1650     balances[_assetTokenAddress][0x0] = safeSub(
1651       balances[_assetTokenAddress][0x0],
1652       safeDiv(safeMul(_assetTokenAmount, _ticketAmount), 1 ether)
1653     );
1654 
1655     balances[_assetTokenAddress][msg.sender] = safeAdd(
1656       balances[_assetTokenAddress][msg.sender],
1657       safeDiv(safeMul(_assetTokenAmount, _ticketAmount), 1 ether)
1658     );
1659     
1660     //emit event
1661     CollapseOption(
1662       msg.sender,
1663       holderTicketAddress,
1664       writerTicketAddress,
1665       _ticketAmount,
1666       (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress))
1667     );
1668     
1669     return _ticketAmount;
1670   }
1671 
1672   /*about invisableHandOfAdamSmith():
1673     q: why would someone ever want to buy an out-of-the-money,
1674        collaterized call option at strike price?
1675 
1676     a: if an american option is executed, and the collateral's movement
1677        makes it later out of the money, the value of the option would
1678        need to be calculated by including the "pre-executed" amount.
1679        * 
1680        This would prevent an external actor performing weird arb trades
1681        (write a billion tickets, collapse a billion tickets, profit!).
1682        Skip the middle man! Writers are more likely to get 100% token or
1683        strike at expiry, based on market value, and holders still have
1684        their option intact.
1685        * 
1686        Arbers gonna arb. Let them do their thing.
1687 */
1688 
1689   //if there have been executions, Adam Smith can deposit asset, get strike, up to execution amount.
1690 //  function invisibleHandOfAdamSmith( //#67
1691 
1692   function optionExcerciseUnwind(
1693     address _assetTokenAddress,
1694     uint256 _assetTokenAmount,
1695     address _strikeTokenAddress,
1696     uint256 _strikeTokenAmount,
1697     uint256 _optionExpires,
1698     uint256 _ticketAmount,
1699     bool _fillOrKill //do we want? probably...
1700   )
1701     external
1702     notLocked
1703     returns (uint256 ticketsUnwound) //(amountTraded)
1704   {
1705     //only before, equal to expiry
1706     require(block.number <= _optionExpires);
1707     
1708     address holderTicketAddress = getOptionAddress(
1709       _assetTokenAddress,
1710       _assetTokenAmount,
1711       _strikeTokenAddress,
1712       _strikeTokenAmount,
1713       _optionExpires,
1714       false
1715     );
1716     
1717     //if strike-pool[hash] != 0 {
1718     ticketsUnwound = exercisedOptions[holderTicketAddress];
1719 
1720     //fill or kill.
1721     require((_fillOrKill == false) || (ticketsUnwound >= _ticketAmount));
1722 
1723     //get amount to trade.
1724     if (ticketsUnwound > _ticketAmount) ticketsUnwound = _ticketAmount;
1725     
1726     require(ticketsUnwound > 0);
1727     //cant buy zero, either because not avail, or you asked for zero.
1728  
1729     //check compliance, like a trade!
1730     require(
1731       (! restrictedTokens[holderTicketAddress]) //if it is not restricted
1732     || Compliance(complianceAddress).canTrade(holderTicketAddress, msg.sender) // or compliance says yes.
1733     );
1734 
1735     //debit balance of caller of asset tokens, credit 0x0
1736     balances[_assetTokenAddress][msg.sender] = safeSub(
1737       balances[_assetTokenAddress][msg.sender],
1738       safeDiv(safeMul(_assetTokenAmount, ticketsUnwound), 1 ether)
1739     );
1740 
1741     balances[_assetTokenAddress][0x0] = safeAdd(
1742       balances[_assetTokenAddress][0x0],
1743       safeDiv(safeMul(_assetTokenAmount, ticketsUnwound), 1 ether)
1744     );
1745     
1746     //debit balance of exercisedOptions of holdOption, credit caller.
1747     //no change in global balances.
1748     exercisedOptions[holderTicketAddress] =
1749       safeSub(exercisedOptions[holderTicketAddress], ticketsUnwound);
1750     balances[holderTicketAddress][msg.sender] =
1751       safeAdd(balances[holderTicketAddress][msg.sender], ticketsUnwound);
1752 
1753     //debit balance of 0x0 of strike, credit caller.
1754     balances[_strikeTokenAddress][0x0] = safeSub(
1755       balances[_strikeTokenAddress][0x0],
1756       safeDiv(safeMul(_strikeTokenAmount, ticketsUnwound), 1 ether)
1757     );
1758 
1759     balances[_strikeTokenAddress][msg.sender] = safeAdd(
1760       balances[_strikeTokenAddress][msg.sender],
1761       safeDiv(safeMul(_strikeTokenAmount, ticketsUnwound), 1 ether)
1762     );
1763     
1764     //emit event.
1765     ExcerciseUnwind(
1766       msg.sender,
1767       holderTicketAddress,
1768       ticketsUnwound,
1769       (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress)),
1770       _fillOrKill
1771     );
1772     
1773     return ticketsUnwound;
1774   }
1775   
1776   //if before expiry, and own hold ticket, then pay strike, get asset, void hold ticket
1777   function excerciseOption( //#68
1778     address _assetTokenAddress,
1779     uint256 _assetTokenAmount,
1780     address _strikeTokenAddress,
1781     uint256 _strikeTokenAmount,
1782     uint256 _optionExpires,
1783     uint256 _ticketAmount
1784   )
1785   external 
1786   returns (uint256 ticketsExcercised)
1787   {  
1788     //only holder before, equal to expiry
1789     require(block.number <= _optionExpires);
1790     
1791     address holderTicketAddress = getOptionAddress(
1792       _assetTokenAddress,
1793       _assetTokenAmount,
1794       _strikeTokenAddress,
1795       _strikeTokenAmount,
1796       _optionExpires,
1797       false
1798     );
1799     
1800     //get balance of tickets
1801     ticketsExcercised = balances[holderTicketAddress][msg.sender];
1802     require(ticketsExcercised >= _ticketAmount); //its just a balance here.
1803     
1804     //get amount to trade.
1805     if (ticketsExcercised > _ticketAmount) ticketsExcercised = _ticketAmount;
1806     
1807     //cant execute zero, either you have zero, or you asked for zero.
1808     require(ticketsExcercised > 0);
1809     
1810     //debit balance of caller for holdOption, credit exercisedOptions    
1811     balances[holderTicketAddress][msg.sender] =
1812       safeSub(balances[holderTicketAddress][msg.sender], ticketsExcercised);
1813     exercisedOptions[holderTicketAddress] =
1814       safeAdd(exercisedOptions[holderTicketAddress], ticketsExcercised);
1815         
1816     //debit balance of caller for strikeToken, credit 0x0
1817     balances[_strikeTokenAddress][msg.sender] = safeSub(
1818       balances[_strikeTokenAddress][msg.sender],
1819       safeDiv(safeMul(_strikeTokenAmount, ticketsExcercised), 1 ether)
1820     );
1821 
1822     balances[_strikeTokenAddress][0x0] = safeAdd(
1823       balances[_strikeTokenAddress][0x0],
1824       safeDiv(safeMul(_strikeTokenAmount, ticketsExcercised), 1 ether)
1825     );
1826     
1827     //debit balance of 0x0 of asset, credit caller.   
1828     balances[_assetTokenAddress][0x0] = safeSub(
1829       balances[_assetTokenAddress][0x0],
1830       safeDiv(safeMul(_assetTokenAmount, ticketsExcercised), 1 ether)
1831     );
1832     
1833     balances[_assetTokenAddress][msg.sender] = safeAdd(
1834       balances[_assetTokenAddress][msg.sender],
1835       safeDiv(safeMul(_assetTokenAmount, ticketsExcercised), 1 ether)
1836     );
1837 
1838     
1839     //no change in global balances.
1840     //emit event.
1841     ExcerciseOption(
1842       msg.sender,
1843       holderTicketAddress,
1844       ticketsExcercised,
1845       (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress))
1846     );
1847     
1848     return ticketsExcercised;
1849   }
1850 
1851   
1852   //if after expiry, get collateral, void option.
1853   function expireOption( //#69
1854     address _assetTokenAddress,
1855     uint256 _assetTokenAmount,
1856     address _strikeTokenAddress,
1857     uint256 _strikeTokenAmount,
1858     uint256 _optionExpires,
1859     uint256 _ticketAmount
1860   )
1861   external 
1862   returns (uint256 ticketsExpired)
1863   {
1864   //only writer, only after expiry
1865     require(block.number > _optionExpires);
1866         
1867     address holderTicketAddress = getOptionAddress(
1868       _assetTokenAddress,
1869       _assetTokenAmount,
1870       _strikeTokenAddress,
1871       _strikeTokenAmount,
1872       _optionExpires,
1873       false
1874     );
1875     
1876     address writerTicketAddress = getOptionAddress(
1877       _assetTokenAddress,
1878       _assetTokenAmount,
1879       _strikeTokenAddress,
1880       _strikeTokenAmount,
1881       _optionExpires,
1882       true
1883     );
1884     
1885     //get balance of tickets
1886     ticketsExpired = balances[writerTicketAddress][msg.sender];
1887     require(ticketsExpired >= _ticketAmount); //its just a balance here.
1888     
1889     //get amount to trade.
1890     if (ticketsExpired > _ticketAmount) ticketsExpired = _ticketAmount;
1891     
1892     //cant execute zero, either you have zero, or you asked for zero.
1893     require(ticketsExpired > 0);
1894     
1895     // debit holder tickets from user, add to exercisedOptions.
1896     balances[writerTicketAddress][msg.sender] =
1897       safeSub(balances[writerTicketAddress][msg.sender], ticketsExpired);
1898     exercisedOptions[writerTicketAddress] =
1899       safeAdd(exercisedOptions[writerTicketAddress], ticketsExpired);
1900     
1901     //calculate amounts
1902     uint256 strikeTokenAmount =
1903       safeDiv(
1904         safeMul(
1905           safeDiv(safeMul(ticketsExpired, _strikeTokenAmount), 1 ether), //tickets
1906           exercisedOptions[holderTicketAddress]
1907         ),
1908         globalBalance[holderTicketAddress]
1909       );
1910 
1911     uint256 assetTokenAmount =
1912       safeDiv(
1913         safeMul(
1914           safeDiv(safeMul(ticketsExpired, _assetTokenAmount), 1 ether), //tickets
1915           safeSub(globalBalance[holderTicketAddress], exercisedOptions[holderTicketAddress])
1916         ),
1917         globalBalance[holderTicketAddress]
1918       );
1919     
1920 
1921     //debit zero, add to msg.sender
1922     balances[_strikeTokenAddress][0x0] =
1923       safeSub(balances[_strikeTokenAddress][0x0], strikeTokenAmount);
1924     balances[_assetTokenAddress][0x0] =
1925       safeSub(balances[_assetTokenAddress][0x0], assetTokenAmount);
1926     balances[_strikeTokenAddress][msg.sender] =
1927       safeAdd(balances[_strikeTokenAddress][msg.sender], strikeTokenAmount);
1928     balances[_assetTokenAddress][msg.sender] =
1929       safeAdd(balances[_assetTokenAddress][msg.sender], assetTokenAmount);
1930   
1931   //set inactive
1932 
1933     ExpireOption( //#69]
1934       msg.sender,
1935       writerTicketAddress,
1936       ticketsExpired,
1937       (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress))
1938     );
1939     return ticketsExpired;
1940   }
1941 
1942 
1943   //get an option's Hash's address
1944   //  (•_•)  ( •_•)>⌐■-■  (⌐■_■)
1945   //
1946   //going from 32 bytes to 20 bytes still gives us 160 bits of hash goodness.
1947   //that's still a crazy large number, and used by ethereum for addresses.
1948   function getOptionAddress(
1949     address _assetTokenAddress,
1950     uint256 _assetTokenAmount,
1951     address _strikeTokenAddress,
1952     uint256 _strikeTokenAmount,
1953     uint256 _optionExpires,
1954     bool _isWriter
1955   )
1956     public
1957     view
1958     returns(address)
1959   {
1960     return(
1961       address(
1962         keccak256(
1963           _assetTokenAddress,
1964           _assetTokenAmount,
1965           _strikeTokenAddress,
1966           _strikeTokenAmount,
1967           _optionExpires,
1968           _isWriter
1969         )
1970       )
1971     );
1972   }
1973 
1974   /***********************************
1975   / Options View Code
1976   ************************************/
1977   //since the options code might move, we should have a way to always
1978   //call a function to this contract to get the current values
1979   
1980   function testIsOptionPairRegistered(
1981     address _assetTokenAddress,
1982     uint256 _assetTokenAmount,
1983     address _strikeTokenAddress,
1984     uint256 _strikeTokenAmount,
1985     uint256 _optionExpires
1986   )
1987   external
1988   view
1989   returns(bool)
1990   {
1991     return(
1992       OptionRegistry(optionsRegistryAddress).isOptionPairRegistered(
1993         _assetTokenAddress,
1994         _assetTokenAmount,
1995         _strikeTokenAddress,
1996         _strikeTokenAmount,
1997         _optionExpires
1998       )
1999     );
2000   }
2001   
2002 
2003   /***********************************
2004   / Default Options Registration Code
2005   ************************************/
2006   // Register emits an event and adds it to restrictedToken.
2007   // We'll deal with any other needed registration later.
2008   // Set up for upgradeable external contract.
2009   // return bools.
2010   
2011   event RegisterOptionsPair(
2012     bytes32 indexed optionPair, //assetTokenAddress xor strikeTokenAddress
2013     address indexed writerTicketAddress,
2014     address indexed holderTicketAddress,
2015     address _assetTokenAddress,
2016     uint256 _assetTokenAmount,
2017     address _strikeTokenAddress,
2018     uint256 _strikeTokenAmount,
2019     uint256 _optionExpires
2020   );  
2021   
2022     
2023   function registerOptionPair(
2024     address _assetTokenAddress,
2025     uint256 _assetTokenAmount,
2026     address _strikeTokenAddress,
2027     uint256 _strikeTokenAmount,
2028     uint256 _optionExpires
2029   )
2030   public
2031   returns(bool)
2032   {
2033     address holderTicketAddress = getOptionAddress(
2034       _assetTokenAddress,
2035       _assetTokenAmount,
2036       _strikeTokenAddress,
2037       _strikeTokenAmount,
2038       _optionExpires,
2039       false
2040     );
2041     
2042 //    if (
2043 //      isOptionPairRegistered(
2044 //        _assetTokenAddress,
2045 //        _assetTokenAmount,
2046 //        _strikeTokenAddress,
2047 //        _strikeTokenAmount,
2048 //        _optionExpires
2049 //      )
2050 //    )
2051     //cheaper not to make call gaswise, same result.
2052     
2053     if (restrictedTokens[holderTicketAddress]) {
2054       return false;
2055     //return halts execution, but else is better for readibility
2056     } else {
2057 
2058       address writerTicketAddress = getOptionAddress(
2059         _assetTokenAddress,
2060         _assetTokenAmount,
2061         _strikeTokenAddress,
2062         _strikeTokenAmount,
2063         _optionExpires,
2064         true
2065       );
2066     
2067       restrictedTokens[holderTicketAddress] = true;
2068       restrictedTokens[writerTicketAddress] = true;
2069     
2070       //an external contract would need to call something like this:
2071       // after being registered as a helper contract on the main site.
2072       //UberDelta(uberdeltaAddress).tokenRestriction(holderTicketAddress, true);
2073       //UberDelta(uberdeltaAddress).tokenRestriction(writerTicketAddress, true);
2074     
2075       RegisterOptionsPair(
2076         (bytes32(_assetTokenAddress) ^ bytes32(_strikeTokenAddress)),
2077         holderTicketAddress,
2078         writerTicketAddress,
2079         _assetTokenAddress,
2080         _assetTokenAmount,
2081         _strikeTokenAddress,
2082         _strikeTokenAmount,
2083         _optionExpires
2084       );
2085     
2086       return(true);
2087     }
2088   }
2089   
2090   
2091   // for v1, we'll simply return if there's a restriction.
2092   function isOptionPairRegistered(
2093     address _assetTokenAddress,
2094     uint256 _assetTokenAmount,
2095     address _strikeTokenAddress,
2096     uint256 _strikeTokenAmount,
2097     uint256 _optionExpires
2098   )
2099   public
2100   view
2101   returns(bool)
2102   {
2103     address holderTicketAddress = getOptionAddress(
2104       _assetTokenAddress,
2105       _assetTokenAmount,
2106       _strikeTokenAddress,
2107       _strikeTokenAmount,
2108       _optionExpires,
2109       false
2110     );
2111     
2112     return(restrictedTokens[holderTicketAddress]);
2113   }
2114   
2115   
2116   function getOptionPair(
2117     address _assetTokenAddress,
2118     uint256 _assetTokenAmount,
2119     address _strikeTokenAddress,
2120     uint256 _strikeTokenAmount,
2121     uint256 _optionExpires
2122   )
2123   public
2124   view
2125   returns(address holderTicketAddress, address writerTicketAddress)
2126   {
2127     holderTicketAddress = getOptionAddress(
2128       _assetTokenAddress,
2129       _assetTokenAmount,
2130       _strikeTokenAddress,
2131       _strikeTokenAmount,
2132       _optionExpires,
2133       false
2134     );
2135     
2136     writerTicketAddress = getOptionAddress(
2137       _assetTokenAddress,
2138       _assetTokenAmount,
2139       _strikeTokenAddress,
2140       _strikeTokenAmount,
2141       _optionExpires,
2142       true
2143     );
2144     
2145     return(holderTicketAddress, writerTicketAddress);
2146   }
2147   
2148   
2149   /******************
2150   / EOS Registration
2151   ******************/
2152   // some users will accidentally keep EOS on the exchange during the snapshot.
2153   function EOSRegistration (string _key) external onlyOwner{
2154     EOS(0xd0a6E6C54DbC68Db5db3A091B171A77407Ff7ccf).register(_key);
2155   }
2156   
2157 }