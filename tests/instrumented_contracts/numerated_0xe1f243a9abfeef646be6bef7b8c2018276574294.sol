1 pragma solidity ^0.4.16;
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
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) external onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal constant returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal constant returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) balances;
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public constant returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 
124 
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 contract ERC20 is ERC20Basic {
130   function allowance(address owner, address spender) public constant returns (uint256);
131   function transferFrom(address from, address to, uint256 value) public returns (bool);
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amout of tokens to be transfered
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     var _allowance = allowed[_from][msg.sender];
158 
159     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160     // require (_value <= _allowance);
161 
162     balances[_to] = balances[_to].add(_value);
163     balances[_from] = balances[_from].sub(_value);
164     allowed[_from][msg.sender] = _allowance.sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175 
176     // To change the approve amount you first have to reduce the addresses`
177     //  allowance to zero by calling `approve(_spender, 0)` if it is not
178     //  already 0 to mitigate the race condition described here:
179     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181 
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifing the amount of tokens still avaible for the spender.
192    */
193   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
194     return allowed[_owner][_spender];
195   }
196 
197 }
198 
199 
200 
201 /**
202  * @title Manageable
203  * @dev Contract that allows to grant permissions to any address
204  * @dev In real life we are no able to perform all actions with just one Ethereum address
205  * @dev because risks are too high.
206  * @dev Instead owner delegates rights to manage an contract to the different addresses and
207  * @dev stay able to revoke permissions at any time.
208  */
209 contract Manageable is Ownable {
210 
211   /* Storage */
212 
213   mapping (address => bool) managerEnabled;  // hard switch for a manager - on/off
214   mapping (address => mapping (string => bool)) managerPermissions;  // detailed info about manager`s permissions
215 
216 
217   /* Events */
218 
219   event ManagerEnabledEvent(address indexed manager);
220   event ManagerDisabledEvent(address indexed manager);
221   event ManagerPermissionGrantedEvent(address indexed manager, string permission);
222   event ManagerPermissionRevokedEvent(address indexed manager, string permission);
223 
224 
225   /* Configure contract */
226 
227   /**
228    * @dev Function to add new manager
229    * @param _manager address New manager
230    */
231   function enableManager(address _manager) external onlyOwner onlyValidAddress(_manager) {
232     require(managerEnabled[_manager] == false);
233 
234     managerEnabled[_manager] = true;
235     ManagerEnabledEvent(_manager);
236   }
237 
238   /**
239    * @dev Function to remove existing manager
240    * @param _manager address Existing manager
241    */
242   function disableManager(address _manager) external onlyOwner onlyValidAddress(_manager) {
243     require(managerEnabled[_manager] == true);
244 
245     managerEnabled[_manager] = false;
246     ManagerDisabledEvent(_manager);
247   }
248 
249   /**
250    * @dev Function to grant new permission to the manager
251    * @param _manager        address Existing manager
252    * @param _permissionName string  Granted permission name
253    */
254   function grantManagerPermission(
255     address _manager, string _permissionName
256   )
257     external
258     onlyOwner
259     onlyValidAddress(_manager)
260     onlyValidPermissionName(_permissionName)
261   {
262     require(managerPermissions[_manager][_permissionName] == false);
263 
264     managerPermissions[_manager][_permissionName] = true;
265     ManagerPermissionGrantedEvent(_manager, _permissionName);
266   }
267 
268   /**
269    * @dev Function to revoke permission of the manager
270    * @param _manager        address Existing manager
271    * @param _permissionName string  Revoked permission name
272    */
273   function revokeManagerPermission(
274     address _manager, string _permissionName
275   )
276     external
277     onlyOwner
278     onlyValidAddress(_manager)
279     onlyValidPermissionName(_permissionName)
280   {
281     require(managerPermissions[_manager][_permissionName] == true);
282 
283     managerPermissions[_manager][_permissionName] = false;
284     ManagerPermissionRevokedEvent(_manager, _permissionName);
285   }
286 
287 
288   /* Getters */
289 
290   /**
291    * @dev Function to check manager status
292    * @param _manager address Manager`s address
293    * @return True if manager is enabled
294    */
295   function isManagerEnabled(address _manager) public constant onlyValidAddress(_manager) returns (bool) {
296     return managerEnabled[_manager];
297   }
298 
299   /**
300    * @dev Function to check permissions of a manager
301    * @param _manager        address Manager`s address
302    * @param _permissionName string  Permission name
303    * @return True if manager has been granted needed permission
304    */
305   function isPermissionGranted(
306     address _manager, string _permissionName
307   )
308     public
309     constant
310     onlyValidAddress(_manager)
311     onlyValidPermissionName(_permissionName)
312     returns (bool)
313   {
314     return managerPermissions[_manager][_permissionName];
315   }
316 
317   /**
318    * @dev Function to check if the manager can perform the action or not
319    * @param _manager        address Manager`s address
320    * @param _permissionName string  Permission name
321    * @return True if manager is enabled and has been granted needed permission
322    */
323   function isManagerAllowed(
324     address _manager, string _permissionName
325   )
326     public
327     constant
328     onlyValidAddress(_manager)
329     onlyValidPermissionName(_permissionName)
330     returns (bool)
331   {
332     return (managerEnabled[_manager] && managerPermissions[_manager][_permissionName]);
333   }
334 
335 
336   /* Helpers */
337 
338   /**
339    * @dev Modifier to check manager address
340    */
341   modifier onlyValidAddress(address _manager) {
342     require(_manager != address(0x0));
343     _;
344   }
345 
346   /**
347    * @dev Modifier to check name of manager permission
348    */
349   modifier onlyValidPermissionName(string _permissionName) {
350     require(bytes(_permissionName).length != 0);
351     _;
352   }
353 
354 
355   /* Outcome */
356 
357   /**
358    * @dev Modifier to use in derived contracts
359    */
360   modifier onlyAllowedManager(string _permissionName) {
361     require(isManagerAllowed(msg.sender, _permissionName) == true);
362     _;
363   }
364 }
365 
366 
367 
368 /**
369  * @title Pausable
370  * @dev Base contract which allows children to implement an emergency stop mechanism.
371  * @dev Based on zeppelin's Pausable, but integrated with Manageable
372  * @dev Contract is in paused state by default and should be explicitly unlocked
373  */
374 contract Pausable is Manageable {
375 
376   /**
377    * Events
378    */
379 
380   event PauseEvent();
381   event UnpauseEvent();
382 
383 
384   /**
385    * Storage
386    */
387 
388   bool paused = true;
389 
390 
391   /**
392    * @dev modifier to allow actions only when the contract IS paused
393    */
394   modifier whenContractNotPaused() {
395     require(paused == false);
396     _;
397   }
398 
399   /**
400    * @dev modifier to allow actions only when the contract IS NOT paused
401    */
402   modifier whenContractPaused {
403     require(paused == true);
404     _;
405   }
406 
407   /**
408    * @dev called by the manager to pause, triggers stopped state
409    */
410   function pauseContract() external onlyAllowedManager('pause_contract') whenContractNotPaused {
411     paused = true;
412     PauseEvent();
413   }
414 
415   /**
416    * @dev called by the manager to unpause, returns to normal state
417    */
418   function unpauseContract() external onlyAllowedManager('unpause_contract') whenContractPaused {
419     paused = false;
420     UnpauseEvent();
421   }
422 
423   /**
424    * @dev The getter for "paused" contract variable
425    */
426   function getPaused() external constant returns (bool) {
427     return paused;
428   }
429 }
430 
431 
432 
433 /**
434  * @title NamedToken
435  */
436 contract NamedToken {
437   string public name;
438   string public symbol;
439   uint8 public decimals;
440 
441   function NamedToken(string _name, string _symbol, uint8 _decimals) public {
442     name = _name;
443     symbol = _symbol;
444     decimals = _decimals;
445   }
446 
447   /**
448    * @dev Function to calculate hash of the token`s name.
449    * @dev Function needed because we can not just return name of the token to another contract - strings have variable length
450    * @return Hash of the token`s name
451    */
452   function getNameHash() external constant returns (bytes32 result){
453     return keccak256(name);
454   }
455 
456   /**
457    * @dev Function to calculate hash of the token`s symbol.
458    * @dev Function needed because we can not just return symbol of the token to another contract - strings have variable length
459    * @return Hash of the token`s symbol
460    */
461   function getSymbolHash() external constant returns (bytes32 result){
462     return keccak256(symbol);
463   }
464 }
465 
466 
467 
468 /**
469  * @title AngelToken
470  */
471 contract AngelToken is StandardToken, NamedToken, Pausable {
472 
473   /* Events */
474 
475   event MintEvent(address indexed account, uint value);
476   event BurnEvent(address indexed account, uint value);
477   event SpendingBlockedEvent(address indexed account);
478   event SpendingUnblockedEvent(address indexed account);
479 
480 
481   /* Storage */
482 
483   address public centralBankAddress = 0x0;
484   mapping (address => uint) spendingBlocksNumber;
485 
486 
487   /* Constructor */
488 
489   function AngelToken() public NamedToken('Angel Token', 'ANGL', 18) {
490     centralBankAddress = msg.sender;
491   }
492 
493 
494   /* Methods */
495 
496   function transfer(address _to, uint _value) public returns (bool) {
497     if (_to != centralBankAddress) {
498       require(!paused);
499     }
500     require(spendingBlocksNumber[msg.sender] == 0);
501 
502     bool result = super.transfer(_to, _value);
503     if (result == true && _to == centralBankAddress) {
504       AngelCentralBank(centralBankAddress).angelBurn(msg.sender, _value);
505     }
506     return result;
507   }
508 
509   function approve(address _spender, uint _value) public whenContractNotPaused returns (bool){
510     return super.approve(_spender, _value);
511   }
512 
513   function transferFrom(address _from, address _to, uint _value) public whenContractNotPaused returns (bool){
514     require(spendingBlocksNumber[_from] == 0);
515 
516     bool result = super.transferFrom(_from, _to, _value);
517     if (result == true && _to == centralBankAddress) {
518       AngelCentralBank(centralBankAddress).angelBurn(_from, _value);
519     }
520     return result;
521   }
522 
523 
524   function mint(address _account, uint _value) external onlyAllowedManager('mint_tokens') {
525     balances[_account] = balances[_account].add(_value);
526     totalSupply = totalSupply.add(_value);
527     MintEvent(_account, _value);
528     Transfer(address(0x0), _account, _value); // required for blockexplorers
529   }
530 
531   function burn(uint _value) external onlyAllowedManager('burn_tokens') {
532     balances[msg.sender] = balances[msg.sender].sub(_value);
533     totalSupply = totalSupply.sub(_value);
534     BurnEvent(msg.sender, _value);
535   }
536 
537   function blockSpending(address _account) external onlyAllowedManager('block_spending') {
538     spendingBlocksNumber[_account] = spendingBlocksNumber[_account].add(1);
539     SpendingBlockedEvent(_account);
540   }
541 
542   function unblockSpending(address _account) external onlyAllowedManager('unblock_spending') {
543     spendingBlocksNumber[_account] = spendingBlocksNumber[_account].sub(1);
544     SpendingUnblockedEvent(_account);
545   }
546 }
547 
548 
549 
550 /**
551  * @title AngelCentralBank
552  *
553  * @dev Crowdsale and escrow contract
554  */
555 contract AngelCentralBank {
556 
557   /* Data structures */
558 
559   struct InvestmentRecord {
560     uint tokensSoldBeforeWei;
561     uint investedEthWei;
562     uint purchasedTokensWei;
563     uint refundedEthWei;
564     uint returnedTokensWei;
565   }
566 
567 
568   /* Storage - config */
569 
570   uint public constant icoCap = 70000000 * (10 ** 18);
571 
572   uint public initialTokenPrice = 1 * (10 ** 18) / (10 ** 4); // means 0.0001 ETH for one token
573 
574   uint public constant landmarkSize = 1000000 * (10 ** 18);
575   uint public constant landmarkPriceStepNumerator = 10;
576   uint public constant landmarkPriceStepDenominator = 100;
577 
578   uint public constant firstRefundRoundRateNumerator = 80;
579   uint public constant firstRefundRoundRateDenominator = 100;
580   uint public constant secondRefundRoundRateNumerator = 40;
581   uint public constant secondRefundRoundRateDenominator = 100;
582 
583   uint public constant initialFundsReleaseNumerator = 20; // part of investment
584   uint public constant initialFundsReleaseDenominator = 100;
585   uint public constant afterFirstRefundRoundFundsReleaseNumerator = 50; // part of remaining funds
586   uint public constant afterFirstRefundRoundFundsReleaseDenominator = 100;
587 
588   uint public constant angelFoundationShareNumerator = 30;
589   uint public constant angelFoundationShareDenominator = 100;
590 
591   /* Storage - state */
592 
593   address public angelFoundationAddress = address(0x2b0556a6298eA3D35E90F1df32cc126b31F59770);
594   uint public icoLaunchTimestamp = 1511784000;  // November 27th 12:00 GMT
595   uint public icoFinishTimestamp = 1513727999;  // December 19th 23:59:59 GMT
596   uint public firstRefundRoundFinishTimestamp = 1520424000;  // March 7th 2018 12:00 GMT
597   uint public secondRefundRoundFinishTimestamp = 1524744000;  // April 26th 2018 12:00 GMT
598 
599 
600   AngelToken public angelToken;
601 
602   mapping (address => InvestmentRecord[]) public investments; // investorAddress => list of investments
603   mapping (address => bool) public investors;
604   uint public totalInvestors = 0;
605   uint public totalTokensSold = 0;
606 
607   bool isIcoFinished = false;
608   bool firstRefundRoundFundsWithdrawal = false;
609 
610 
611   /* Events */
612 
613   event InvestmentEvent(address indexed investor, uint eth, uint angel);
614   event RefundEvent(address indexed investor, uint eth, uint angel);
615 
616 
617   /* Constructor and config */
618 
619   function AngelCentralBank() public {
620     angelToken = new AngelToken();
621     angelToken.enableManager(address(this));
622     angelToken.grantManagerPermission(address(this), 'mint_tokens');
623     angelToken.grantManagerPermission(address(this), 'burn_tokens');
624     angelToken.grantManagerPermission(address(this), 'unpause_contract');
625     angelToken.transferOwnership(angelFoundationAddress);
626   }
627 
628   /* Investments */
629 
630   /**
631    * @dev Fallback function receives ETH and sends tokens back
632    */
633   function () public payable {
634     angelRaise();
635   }
636 
637   /**
638    * @dev Process new ETH investment and sends tokens back
639    */
640   function angelRaise() internal {
641     require(msg.value > 0);
642     require(now >= icoLaunchTimestamp && now < icoFinishTimestamp);
643 
644     // calculate amount of tokens for received ETH
645     uint _purchasedTokensWei = 0;
646     uint _notProcessedEthWei = 0;
647     (_purchasedTokensWei, _notProcessedEthWei) = calculatePurchasedTokens(totalTokensSold, msg.value);
648     uint _actualInvestment = (msg.value - _notProcessedEthWei);
649 
650     // create record for the investment
651     uint _newRecordIndex = investments[msg.sender].length;
652     investments[msg.sender].length += 1;
653     investments[msg.sender][_newRecordIndex].tokensSoldBeforeWei = totalTokensSold;
654     investments[msg.sender][_newRecordIndex].investedEthWei = _actualInvestment;
655     investments[msg.sender][_newRecordIndex].purchasedTokensWei = _purchasedTokensWei;
656     investments[msg.sender][_newRecordIndex].refundedEthWei = 0;
657     investments[msg.sender][_newRecordIndex].returnedTokensWei = 0;
658 
659     // calculate stats
660     if (investors[msg.sender] == false) {
661       totalInvestors += 1;
662     }
663     investors[msg.sender] = true;
664     totalTokensSold += _purchasedTokensWei;
665 
666     // transfer tokens and ETH
667     angelToken.mint(msg.sender, _purchasedTokensWei);
668     angelToken.mint(angelFoundationAddress,
669                     _purchasedTokensWei * angelFoundationShareNumerator / (angelFoundationShareDenominator - angelFoundationShareNumerator));
670     angelFoundationAddress.transfer(_actualInvestment * initialFundsReleaseNumerator / initialFundsReleaseDenominator);
671     if (_notProcessedEthWei > 0) {
672       msg.sender.transfer(_notProcessedEthWei);
673     }
674 
675     // finish ICO if cap reached
676     if (totalTokensSold >= icoCap) {
677       icoFinishTimestamp = now;
678 
679       finishIco();
680     }
681 
682     // fire event
683     InvestmentEvent(msg.sender, _actualInvestment, _purchasedTokensWei);
684   }
685 
686   /**
687    * @dev Calculate amount of tokens for received ETH
688    * @param _totalTokensSoldBefore uint Amount of tokens sold before this investment [token wei]
689    * @param _investedEthWei        uint Investment amount [ETH wei]
690    * @return Purchased amount of tokens [token wei]
691    */
692   function calculatePurchasedTokens(
693     uint _totalTokensSoldBefore,
694     uint _investedEthWei)
695     constant public returns (uint _purchasedTokensWei, uint _notProcessedEthWei)
696   {
697     _purchasedTokensWei = 0;
698     _notProcessedEthWei = _investedEthWei;
699 
700     uint _landmarkPrice;
701     uint _maxLandmarkTokensWei;
702     uint _maxLandmarkEthWei;
703     bool _isCapReached = false;
704     do {
705       // get landmark values
706       _landmarkPrice = calculateLandmarkPrice(_totalTokensSoldBefore + _purchasedTokensWei);
707       _maxLandmarkTokensWei = landmarkSize - ((_totalTokensSoldBefore + _purchasedTokensWei) % landmarkSize);
708       if (_totalTokensSoldBefore + _purchasedTokensWei + _maxLandmarkTokensWei >= icoCap) {
709         _maxLandmarkTokensWei = icoCap - _totalTokensSoldBefore - _purchasedTokensWei;
710         _isCapReached = true;
711       }
712       _maxLandmarkEthWei = _maxLandmarkTokensWei * _landmarkPrice / (10 ** 18);
713 
714       // check investment against landmark values
715       if (_notProcessedEthWei >= _maxLandmarkEthWei) {
716         _purchasedTokensWei += _maxLandmarkTokensWei;
717         _notProcessedEthWei -= _maxLandmarkEthWei;
718       }
719       else {
720         _purchasedTokensWei += _notProcessedEthWei * (10 ** 18) / _landmarkPrice;
721         _notProcessedEthWei = 0;
722       }
723     }
724     while ((_notProcessedEthWei > 0) && (_isCapReached == false));
725 
726     assert(_purchasedTokensWei > 0);
727 
728     return (_purchasedTokensWei, _notProcessedEthWei);
729   }
730 
731 
732   /* Refunds */
733 
734   function angelBurn(
735     address _investor,
736     uint _returnedTokensWei
737   )
738     external returns (uint)
739   {
740     require(msg.sender == address(angelToken));
741     require(now >= icoLaunchTimestamp && now < secondRefundRoundFinishTimestamp);
742 
743     uint _notProcessedTokensWei = _returnedTokensWei;
744     uint _refundedEthWei = 0;
745 
746     uint _allRecordsNumber = investments[_investor].length;
747     uint _recordMaxReturnedTokensWei = 0;
748     uint _recordTokensWeiToProcess = 0;
749     uint _tokensSoldWei = 0;
750     uint _recordRefundedEthWei = 0;
751     uint _recordNotProcessedTokensWei = 0;
752     for (uint _recordID = 0; _recordID < _allRecordsNumber; _recordID += 1) {
753       if (investments[_investor][_recordID].purchasedTokensWei <= investments[_investor][_recordID].returnedTokensWei ||
754           investments[_investor][_recordID].investedEthWei <= investments[_investor][_recordID].refundedEthWei) {
755         // tokens already refunded
756         continue;
757       }
758 
759       // calculate amount of tokens to refund with this record
760       _recordMaxReturnedTokensWei = investments[_investor][_recordID].purchasedTokensWei -
761                                     investments[_investor][_recordID].returnedTokensWei;
762       _recordTokensWeiToProcess = (_notProcessedTokensWei < _recordMaxReturnedTokensWei) ? _notProcessedTokensWei :
763                                                                                            _recordMaxReturnedTokensWei;
764       assert(_recordTokensWeiToProcess > 0);
765 
766       // calculate amount of ETH to send back
767       _tokensSoldWei = investments[_investor][_recordID].tokensSoldBeforeWei + investments[_investor][_recordID].returnedTokensWei;
768       (_recordRefundedEthWei, _recordNotProcessedTokensWei) = calculateRefundedEth(_tokensSoldWei, _recordTokensWeiToProcess);
769       if (_recordRefundedEthWei > (investments[_investor][_recordID].investedEthWei - investments[_investor][_recordID].refundedEthWei)) {
770         // this can happen due to rounding error
771         _recordRefundedEthWei = (investments[_investor][_recordID].investedEthWei - investments[_investor][_recordID].refundedEthWei);
772       }
773       assert(_recordRefundedEthWei > 0);
774       assert(_recordNotProcessedTokensWei == 0);
775 
776       // persist changes to the storage
777       _refundedEthWei += _recordRefundedEthWei;
778       _notProcessedTokensWei -= _recordTokensWeiToProcess;
779 
780       investments[_investor][_recordID].refundedEthWei += _recordRefundedEthWei;
781       investments[_investor][_recordID].returnedTokensWei += _recordTokensWeiToProcess;
782       assert(investments[_investor][_recordID].refundedEthWei <= investments[_investor][_recordID].investedEthWei);
783       assert(investments[_investor][_recordID].returnedTokensWei <= investments[_investor][_recordID].purchasedTokensWei);
784 
785       // stop if we already refunded all tokens
786       if (_notProcessedTokensWei == 0) {
787         break;
788       }
789     }
790 
791     // throw if we do not have tokens to refund
792     require(_notProcessedTokensWei < _returnedTokensWei);
793     require(_refundedEthWei > 0);
794 
795     // calculate refund discount
796     uint _refundedEthWeiWithDiscount = calculateRefundedEthWithDiscount(_refundedEthWei);
797 
798     // transfer ETH and remaining tokens
799     angelToken.burn(_returnedTokensWei - _notProcessedTokensWei);
800     if (_notProcessedTokensWei > 0) {
801       angelToken.transfer(_investor, _notProcessedTokensWei);
802     }
803     _investor.transfer(_refundedEthWeiWithDiscount);
804 
805     // fire event
806     RefundEvent(_investor, _refundedEthWeiWithDiscount, _returnedTokensWei - _notProcessedTokensWei);
807   }
808 
809   /**
810    * @dev Calculate discounted amount of ETH for refunded tokens
811    * @param _refundedEthWei uint Calculated amount of ETH to refund [ETH wei]
812    * @return Discounted amount of ETH for refunded [ETH wei]
813    */
814   function calculateRefundedEthWithDiscount(
815     uint _refundedEthWei
816   )
817     public constant returns (uint)
818   {
819     if (now <= firstRefundRoundFinishTimestamp) {
820       return (_refundedEthWei * firstRefundRoundRateNumerator / firstRefundRoundRateDenominator);
821     }
822     else {
823       return (_refundedEthWei * secondRefundRoundRateNumerator / secondRefundRoundRateDenominator);
824     }
825   }
826 
827   /**
828    * @dev Calculate amount of ETH for refunded tokens. Just abstract price ladder
829    * @param _totalTokensSoldBefore     uint Amount of tokens that have been sold (starting point) [token wei]
830    * @param _returnedTokensWei uint Amount of tokens to refund [token wei]
831    * @return Refunded amount of ETH [ETH wei] (without discounts)
832    */
833   function calculateRefundedEth(
834     uint _totalTokensSoldBefore,
835     uint _returnedTokensWei
836   )
837     public constant returns (uint _refundedEthWei, uint _notProcessedTokensWei)
838   {
839     _refundedEthWei = 0;
840     uint _refundedTokensWei = 0;
841     _notProcessedTokensWei = _returnedTokensWei;
842 
843     uint _landmarkPrice = 0;
844     uint _maxLandmarkTokensWei = 0;
845     uint _maxLandmarkEthWei = 0;
846     bool _isCapReached = false;
847     do {
848       // get landmark values
849       _landmarkPrice = calculateLandmarkPrice(_totalTokensSoldBefore + _refundedTokensWei);
850       _maxLandmarkTokensWei = landmarkSize - ((_totalTokensSoldBefore + _refundedTokensWei) % landmarkSize);
851       if (_totalTokensSoldBefore + _refundedTokensWei + _maxLandmarkTokensWei >= icoCap) {
852         _maxLandmarkTokensWei = icoCap - _totalTokensSoldBefore - _refundedTokensWei;
853         _isCapReached = true;
854       }
855       _maxLandmarkEthWei = _maxLandmarkTokensWei * _landmarkPrice / (10 ** 18);
856 
857       // check investment against landmark values
858       if (_notProcessedTokensWei > _maxLandmarkTokensWei) {
859         _refundedEthWei += _maxLandmarkEthWei;
860         _refundedTokensWei += _maxLandmarkTokensWei;
861         _notProcessedTokensWei -= _maxLandmarkTokensWei;
862       }
863       else {
864         _refundedEthWei += _notProcessedTokensWei * _landmarkPrice / (10 ** 18);
865         _refundedTokensWei += _notProcessedTokensWei;
866         _notProcessedTokensWei = 0;
867       }
868     }
869     while ((_notProcessedTokensWei > 0) && (_isCapReached == false));
870 
871     assert(_refundedEthWei > 0);
872 
873     return (_refundedEthWei, _notProcessedTokensWei);
874   }
875 
876 
877   /* Calculation of the price */
878 
879   /**
880    * @dev Calculate price for tokens
881    * @param _totalTokensSoldBefore uint Amount of tokens sold before [token wei]
882    * @return Calculated price
883    */
884   function calculateLandmarkPrice(uint _totalTokensSoldBefore) public constant returns (uint) {
885     return initialTokenPrice + initialTokenPrice
886                                * landmarkPriceStepNumerator / landmarkPriceStepDenominator
887                                * (_totalTokensSoldBefore / landmarkSize);
888   }
889 
890 
891   /* Lifecycle */
892 
893   function finishIco() public {
894     require(now >= icoFinishTimestamp);
895     require(isIcoFinished == false);
896 
897     isIcoFinished = true;
898 
899     angelToken.unpauseContract();
900   }
901 
902   function withdrawFoundationFunds() external {
903     require(now > firstRefundRoundFinishTimestamp);
904 
905     if (now > firstRefundRoundFinishTimestamp && now <= secondRefundRoundFinishTimestamp) {
906       require(firstRefundRoundFundsWithdrawal == false);
907 
908       firstRefundRoundFundsWithdrawal = true;
909       angelFoundationAddress.transfer(this.balance * afterFirstRefundRoundFundsReleaseNumerator / afterFirstRefundRoundFundsReleaseDenominator);
910     } else {
911       angelFoundationAddress.transfer(this.balance);
912     }
913   }
914 }