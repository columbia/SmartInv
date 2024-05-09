1 pragma solidity 0.4.24;
2 
3 // File: @tokenfoundry/sale-contracts/contracts/interfaces/DisbursementHandlerI.sol
4 
5 interface DisbursementHandlerI {
6     function withdraw(address _beneficiary, uint256 _index) external;
7 }
8 
9 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipRenounced(address indexed previousOwner);
73   event OwnershipTransferred(
74     address indexed previousOwner,
75     address indexed newOwner
76   );
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to relinquish control of the contract.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   function totalSupply() public view returns (uint256);
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender)
144     public view returns (uint256);
145 
146   function transferFrom(address from, address to, uint256 value)
147     public returns (bool);
148 
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(
151     address indexed owner,
152     address indexed spender,
153     uint256 value
154   );
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
158 
159 /**
160  * @title SafeERC20
161  * @dev Wrappers around ERC20 operations that throw on failure.
162  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
163  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
164  */
165 library SafeERC20 {
166   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
167     require(token.transfer(to, value));
168   }
169 
170   function safeTransferFrom(
171     ERC20 token,
172     address from,
173     address to,
174     uint256 value
175   )
176     internal
177   {
178     require(token.transferFrom(from, to, value));
179   }
180 
181   function safeApprove(ERC20 token, address spender, uint256 value) internal {
182     require(token.approve(spender, value));
183   }
184 }
185 
186 // File: @tokenfoundry/sale-contracts/contracts/DisbursementHandler.sol
187 
188 /// @title Disbursement handler - Manages time locked disbursements of ERC20 tokens
189 contract DisbursementHandler is DisbursementHandlerI, Ownable {
190     using SafeMath for uint256;
191     using SafeERC20 for ERC20;
192 
193     struct Disbursement {
194         // Tokens cannot be withdrawn before this timestamp
195         uint256 timestamp;
196 
197         // Amount of tokens to be disbursed
198         uint256 value;
199     }
200 
201     event Setup(address indexed _beneficiary, uint256 _timestamp, uint256 _value);
202     event TokensWithdrawn(address indexed _to, uint256 _value);
203 
204     ERC20 public token;
205     uint256 public totalAmount;
206     mapping(address => Disbursement[]) public disbursements;
207 
208     bool public closed;
209 
210     modifier isOpen {
211         require(!closed, "Disbursement Handler is closed");
212         _;
213     }
214 
215     modifier isClosed {
216         require(closed, "Disbursement Handler is open");
217         _;
218     }
219 
220 
221     constructor(ERC20 _token) public {
222         require(_token != address(0), "Token cannot have address 0");
223         token = _token;
224     }
225 
226     /// @dev Called to create disbursements.
227     /// @param _beneficiaries The addresses of the beneficiaries.
228     /// @param _values The number of tokens to be locked for each disbursement.
229     /// @param _timestamps Funds will be locked until this timestamp for each disbursement.
230     function setupDisbursements(
231         address[] _beneficiaries,
232         uint256[] _values,
233         uint256[] _timestamps
234     )
235         external
236         onlyOwner
237         isOpen
238     {
239         require((_beneficiaries.length == _values.length) && (_beneficiaries.length == _timestamps.length), "Arrays not of equal length");
240         require(_beneficiaries.length > 0, "Arrays must have length > 0");
241 
242         for (uint256 i = 0; i < _beneficiaries.length; i++) {
243             setupDisbursement(_beneficiaries[i], _values[i], _timestamps[i]);
244         }
245     }
246 
247     function close() external onlyOwner isOpen {
248         closed = true;
249     }
250 
251     /// @dev Called by the sale contract to create a disbursement.
252     /// @param _beneficiary The address of the beneficiary.
253     /// @param _value Amount of tokens to be locked.
254     /// @param _timestamp Funds will be locked until this timestamp.
255     function setupDisbursement(
256         address _beneficiary,
257         uint256 _value,
258         uint256 _timestamp
259     )
260         internal
261     {
262         require(block.timestamp < _timestamp, "Disbursement timestamp in the past");
263         disbursements[_beneficiary].push(Disbursement(_timestamp, _value));
264         totalAmount = totalAmount.add(_value);
265         emit Setup(_beneficiary, _timestamp, _value);
266     }
267 
268     /// @dev Transfers tokens to a beneficiary
269     /// @param _beneficiary The address to transfer tokens to
270     /// @param _index The index of the disbursement
271     function withdraw(address _beneficiary, uint256 _index)
272         external
273         isClosed
274     {
275         Disbursement[] storage beneficiaryDisbursements = disbursements[_beneficiary];
276         require(_index < beneficiaryDisbursements.length, "Supplied index out of disbursement range");
277 
278         Disbursement memory disbursement = beneficiaryDisbursements[_index];
279         require(disbursement.timestamp < now && disbursement.value > 0, "Disbursement timestamp not reached, or disbursement value of 0");
280 
281         // Remove the withdrawn disbursement
282         delete beneficiaryDisbursements[_index];
283 
284         token.safeTransfer(_beneficiary, disbursement.value);
285         emit TokensWithdrawn(_beneficiary, disbursement.value);
286     }
287 }
288 
289 // File: @tokenfoundry/sale-contracts/contracts/interfaces/VaultI.sol
290 
291 interface VaultI {
292     function deposit(address contributor) external payable;
293     function saleSuccessful() external;
294     function enableRefunds() external;
295     function refund(address contributor) external;
296     function close() external;
297     function sendFundsToWallet() external;
298 }
299 
300 // File: openzeppelin-solidity/contracts/math/Math.sol
301 
302 /**
303  * @title Math
304  * @dev Assorted math operations
305  */
306 library Math {
307   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
308     return a >= b ? a : b;
309   }
310 
311   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
312     return a < b ? a : b;
313   }
314 
315   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
316     return a >= b ? a : b;
317   }
318 
319   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
320     return a < b ? a : b;
321   }
322 }
323 
324 // File: @tokenfoundry/sale-contracts/contracts/Vault.sol
325 
326 // Adapted from Open Zeppelin's RefundVault
327 
328 /**
329  * @title Vault
330  * @dev This contract is used for storing funds while a crowdsale
331  * is in progress. Supports refunding the money if crowdsale fails,
332  * and forwarding it if crowdsale is successful.
333  */
334 contract Vault is VaultI, Ownable {
335     using SafeMath for uint256;
336 
337     enum State { Active, Success, Refunding, Closed }
338 
339     // The timestamp of the first deposit
340     uint256 public firstDepositTimestamp; 
341 
342     mapping (address => uint256) public deposited;
343 
344     // The amount to be disbursed to the wallet every month
345     uint256 public disbursementWei;
346     uint256 public disbursementDuration;
347 
348     // Wallet from the project team
349     address public trustedWallet;
350 
351     // The eth amount the team will get initially if the sale is successful
352     uint256 public initialWei;
353 
354     // Timestamp that has to pass before sending funds to the wallet
355     uint256 public nextDisbursement;
356     
357     // Total amount that was deposited
358     uint256 public totalDeposited;
359 
360     // Amount that can be refunded
361     uint256 public refundable;
362 
363     State public state;
364 
365     event Closed();
366     event RefundsEnabled();
367     event Refunded(address indexed contributor, uint256 amount);
368 
369     modifier atState(State _state) {
370         require(state == _state, "This function cannot be called in the current vault state.");
371         _;
372     }
373 
374     constructor (
375         address _wallet,
376         uint256 _initialWei,
377         uint256 _disbursementWei,
378         uint256 _disbursementDuration
379     ) 
380         public 
381     {
382         require(_wallet != address(0), "Wallet address should not be 0.");
383         require(_disbursementWei != 0, "Disbursement Wei should be greater than 0.");
384         trustedWallet = _wallet;
385         initialWei = _initialWei;
386         disbursementWei = _disbursementWei;
387         disbursementDuration = _disbursementDuration;
388         state = State.Active;
389     }
390 
391     /// @dev Called by the sale contract to deposit ether for a contributor.
392     function deposit(address _contributor) onlyOwner external payable {
393         require(state == State.Active || state == State.Success , "Vault state must be Active or Success.");
394         if (firstDepositTimestamp == 0) {
395             firstDepositTimestamp = now;
396         }
397         totalDeposited = totalDeposited.add(msg.value);
398         deposited[_contributor] = deposited[_contributor].add(msg.value);
399     }
400 
401     /// @dev Sends initial funds to the wallet.
402     function saleSuccessful()
403         onlyOwner 
404         external 
405         atState(State.Active)
406     {
407         state = State.Success;
408         transferToWallet(initialWei);
409     }
410 
411     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
412     function enableRefunds() onlyOwner external {
413         require(state != State.Refunding, "Vault state is not Refunding");
414         state = State.Refunding;
415         uint256 currentBalance = address(this).balance;
416         refundable = currentBalance <= totalDeposited ? currentBalance : totalDeposited;
417         emit RefundsEnabled();
418     }
419 
420     /// @dev Refunds ether to the contributors if in the Refunding state.
421     function refund(address _contributor) external atState(State.Refunding) {
422         require(deposited[_contributor] > 0, "Refund not allowed if contributor deposit is 0.");
423         uint256 refundAmount = deposited[_contributor].mul(refundable).div(totalDeposited);
424         deposited[_contributor] = 0;
425         _contributor.transfer(refundAmount);
426         emit Refunded(_contributor, refundAmount);
427     }
428 
429     /// @dev Called by the owner if the sale has ended.
430     function close() external atState(State.Success) onlyOwner {
431         state = State.Closed;
432         nextDisbursement = now;
433         emit Closed();
434     }
435 
436     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
437     function sendFundsToWallet() external atState(State.Closed) {
438         require(firstDepositTimestamp.add(4 weeks) <= now, "First contributor\ń0027s deposit was less than 28 days ago");
439         require(nextDisbursement <= now, "Next disbursement period timestamp has not yet passed, too early to withdraw.");
440 
441         if (disbursementDuration == 0) {
442             trustedWallet.transfer(address(this).balance);
443             return;
444         }
445 
446         uint256 numberOfDisbursements = now.sub(nextDisbursement).div(disbursementDuration).add(1);
447 
448         nextDisbursement = nextDisbursement.add(disbursementDuration.mul(numberOfDisbursements));
449 
450         transferToWallet(disbursementWei.mul(numberOfDisbursements));
451     }
452 
453     function transferToWallet(uint256 _amount) internal {
454         uint256 amountToSend = Math.min256(_amount, address(this).balance);
455         trustedWallet.transfer(amountToSend);
456     }
457 }
458 
459 // File: @tokenfoundry/sale-contracts/contracts/interfaces/WhitelistableI.sol
460 
461 interface WhitelistableI {
462     function changeAdmin(address _admin) external;
463     function invalidateHash(bytes32 _hash) external;
464     function invalidateHashes(bytes32[] _hashes) external;
465 }
466 
467 // File: openzeppelin-solidity/contracts/ECRecovery.sol
468 
469 /**
470  * @title Eliptic curve signature operations
471  *
472  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
473  *
474  * TODO Remove this library once solidity supports passing a signature to ecrecover.
475  * See https://github.com/ethereum/solidity/issues/864
476  *
477  */
478 
479 library ECRecovery {
480 
481   /**
482    * @dev Recover signer address from a message by using their signature
483    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
484    * @param sig bytes signature, the signature is generated using web3.eth.sign()
485    */
486   function recover(bytes32 hash, bytes sig)
487     internal
488     pure
489     returns (address)
490   {
491     bytes32 r;
492     bytes32 s;
493     uint8 v;
494 
495     // Check the signature length
496     if (sig.length != 65) {
497       return (address(0));
498     }
499 
500     // Divide the signature in r, s and v variables
501     // ecrecover takes the signature parameters, and the only way to get them
502     // currently is to use assembly.
503     // solium-disable-next-line security/no-inline-assembly
504     assembly {
505       r := mload(add(sig, 32))
506       s := mload(add(sig, 64))
507       v := byte(0, mload(add(sig, 96)))
508     }
509 
510     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
511     if (v < 27) {
512       v += 27;
513     }
514 
515     // If the version is correct return the signer address
516     if (v != 27 && v != 28) {
517       return (address(0));
518     } else {
519       // solium-disable-next-line arg-overflow
520       return ecrecover(hash, v, r, s);
521     }
522   }
523 
524   /**
525    * toEthSignedMessageHash
526    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
527    * @dev and hash the result
528    */
529   function toEthSignedMessageHash(bytes32 hash)
530     internal
531     pure
532     returns (bytes32)
533   {
534     // 32 is the length in bytes of hash,
535     // enforced by the type signature above
536     return keccak256(
537       "\x19Ethereum Signed Message:\n32",
538       hash
539     );
540   }
541 }
542 
543 // File: @tokenfoundry/sale-contracts/contracts/Whitelistable.sol
544 
545 /**
546  * @title Whitelistable
547  * @dev This contract is used to implement a signature based whitelisting mechanism
548  */
549 contract Whitelistable is WhitelistableI, Ownable {
550     using ECRecovery for bytes32;
551 
552     address public whitelistAdmin;
553 
554     // True if the hash has been invalidated
555     mapping(bytes32 => bool) public invalidHash;
556 
557     event AdminUpdated(address indexed newAdmin);
558 
559     modifier validAdmin(address _admin) {
560         require(_admin != 0, "Admin address cannot be 0");
561         _;
562     }
563 
564     modifier onlyAdmin {
565         require(msg.sender == whitelistAdmin, "Only the whitelist admin may call this function");
566         _;
567     }
568 
569     modifier isWhitelisted(bytes32 _hash, bytes _sig) {
570         require(checkWhitelisted(_hash, _sig), "The provided hash is not whitelisted");
571         _;
572     }
573 
574     /// @dev Constructor for Whitelistable contract
575     /// @param _admin the address of the admin that will generate the signatures
576     constructor(address _admin) public validAdmin(_admin) {
577         whitelistAdmin = _admin;        
578     }
579 
580     /// @dev Updates whitelistAdmin address 
581     /// @dev Can only be called by the current owner
582     /// @param _admin the new admin address
583     function changeAdmin(address _admin)
584         external
585         onlyOwner
586         validAdmin(_admin)
587     {
588         emit AdminUpdated(_admin);
589         whitelistAdmin = _admin;
590     }
591 
592     // @dev blacklists the given address to ban them from contributing
593     // @param _contributor Address of the contributor to blacklist 
594     function invalidateHash(bytes32 _hash) external onlyAdmin {
595         invalidHash[_hash] = true;
596     }
597 
598     function invalidateHashes(bytes32[] _hashes) external onlyAdmin {
599         for (uint i = 0; i < _hashes.length; i++) {
600             invalidHash[_hashes[i]] = true;
601         }
602     }
603 
604     /// @dev Checks if a hash has been signed by the whitelistAdmin
605     /// @param _rawHash The hash that was used to generate the signature
606     /// @param _sig The EC signature generated by the whitelistAdmin
607     /// @return Was the signature generated by the admin for the hash?
608     function checkWhitelisted(
609         bytes32 _rawHash,
610         bytes _sig
611     )
612         public
613         view
614         returns(bool)
615     {
616         bytes32 hash = _rawHash.toEthSignedMessageHash();
617         return !invalidHash[_rawHash] && whitelistAdmin == hash.recover(_sig);
618     }
619 }
620 
621 // File: @tokenfoundry/sale-contracts/contracts/interfaces/EthPriceFeedI.sol
622 
623 interface EthPriceFeedI {
624     function getUnit() external view returns(string);
625     function getRate() external view returns(uint256);
626     function getLastTimeUpdated() external view returns(uint256); 
627 }
628 
629 // File: @tokenfoundry/sale-contracts/contracts/interfaces/SaleI.sol
630 
631 interface SaleI {
632     function setup() external;  
633     function changeEthPriceFeed(EthPriceFeedI newPriceFeed) external;
634     function contribute(address _contributor, uint256 _limit, uint256 _expiration, bytes _sig) external payable; 
635     function allocateExtraTokens(address _contributor) external;
636     function setEndTime(uint256 _endTime) external;
637     function endSale() external;
638 }
639 
640 // File: @tokenfoundry/state-machine/contracts/StateMachine.sol
641 
642 contract StateMachine {
643 
644     struct State { 
645         bytes32 nextStateId;
646         mapping(bytes4 => bool) allowedFunctions;
647         function() internal[] transitionCallbacks;
648         function(bytes32) internal returns(bool)[] startConditions;
649     }
650 
651     mapping(bytes32 => State) states;
652 
653     // The current state id
654     bytes32 private currentStateId;
655 
656     event Transition(bytes32 stateId, uint256 blockNumber);
657 
658     /* This modifier performs the conditional transitions and checks that the function 
659      * to be executed is allowed in the current State
660      */
661     modifier checkAllowed {
662         conditionalTransitions();
663         require(states[currentStateId].allowedFunctions[msg.sig]);
664         _;
665     }
666 
667     ///@dev transitions the state machine into the state it should currently be in
668     ///@dev by taking into account the current conditions and how many further transitions can occur 
669     function conditionalTransitions() public {
670         bool checkNextState; 
671         do {
672             checkNextState = false;
673 
674             bytes32 next = states[currentStateId].nextStateId;
675             // If one of the next state's conditions is met, go to this state and continue
676 
677             for (uint256 i = 0; i < states[next].startConditions.length; i++) {
678                 if (states[next].startConditions[i](next)) {
679                     goToNextState();
680                     checkNextState = true;
681                     break;
682                 }
683             } 
684         } while (checkNextState);
685     }
686 
687     function getCurrentStateId() view public returns(bytes32) {
688         return currentStateId;
689     }
690 
691     /// @dev Setup the state machine with the given states.
692     /// @param _stateIds Array of state ids.
693     function setStates(bytes32[] _stateIds) internal {
694         require(_stateIds.length > 0);
695         require(currentStateId == 0);
696 
697         require(_stateIds[0] != 0);
698 
699         currentStateId = _stateIds[0];
700 
701         for (uint256 i = 1; i < _stateIds.length; i++) {
702             require(_stateIds[i] != 0);
703 
704             states[_stateIds[i - 1]].nextStateId = _stateIds[i];
705 
706             // Check that the state appears only once in the array
707             require(states[_stateIds[i]].nextStateId == 0);
708         }
709     }
710 
711     /// @dev Allow a function in the given state.
712     /// @param _stateId The id of the state
713     /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
714     function allowFunction(bytes32 _stateId, bytes4 _functionSelector) 
715         internal 
716     {
717         states[_stateId].allowedFunctions[_functionSelector] = true;
718     }
719 
720     /// @dev Goes to the next state if possible (if the next state is valid)
721     function goToNextState() internal {
722         bytes32 next = states[currentStateId].nextStateId;
723         require(next != 0);
724 
725         currentStateId = next;
726         for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
727             states[next].transitionCallbacks[i]();
728         }
729 
730         emit Transition(next, block.number);
731     }
732 
733     ///@dev Add a function returning a boolean as a start condition for a state. 
734     /// If any condition returns true, the StateMachine will transition to the next state.
735     /// If s.startConditions is empty, the StateMachine will need to enter state s through invoking
736     /// the goToNextState() function. 
737     /// A start condition should never throw. (Otherwise, the StateMachine may fail to enter into the
738     /// correct state, and succeeding start conditions may return true.)
739     /// A start condition should be gas-inexpensive since every one of them is invoked in the same call to 
740     /// transition the state. 
741     ///@param _stateId The ID of the state to add the condition for
742     ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
743     function addStartCondition(
744         bytes32 _stateId,
745         function(bytes32) internal returns(bool) _condition
746     ) 
747         internal 
748     {
749         states[_stateId].startConditions.push(_condition);
750     }
751 
752     ///@dev Add a callback function for a state. All callbacks are invoked immediately after entering the state. 
753     /// Callback functions should never throw. (Otherwise, the StateMachine may fail to enter a state.)
754     /// Callback functions should also be gas-inexpensive as all callbacks are invoked in the same call to enter the state.
755     ///@param _stateId The ID of the state to add a callback function for
756     ///@param _callback The callback function to add
757     function addCallback(bytes32 _stateId, function() internal _callback)
758         internal 
759     {
760         states[_stateId].transitionCallbacks.push(_callback);
761     }
762 }
763 
764 // File: @tokenfoundry/state-machine/contracts/TimedStateMachine.sol
765 
766 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
767 contract TimedStateMachine is StateMachine {
768 
769     event StateStartTimeSet(bytes32 indexed _stateId, uint256 _startTime);
770 
771     // Stores the start timestamp for each state (the value is 0 if the state doesn't have a start timestamp).
772     mapping(bytes32 => uint256) private startTime;
773 
774     /// @dev Returns the timestamp for the given state id.
775     /// @param _stateId The id of the state for which we want to set the start timestamp.
776     function getStateStartTime(bytes32 _stateId) public view returns(uint256) {
777         return startTime[_stateId];
778     }
779 
780     /// @dev Sets the starting timestamp for a state as a startCondition. If other start conditions exist and are 
781     /// met earlier, then the state may be entered into earlier than the specified start time. 
782     /// @param _stateId The id of the state for which we want to set the start timestamp.
783     /// @param _timestamp The start timestamp for the given state. It should be bigger than the current one.
784     function setStateStartTime(bytes32 _stateId, uint256 _timestamp) internal {
785         require(block.timestamp < _timestamp);
786 
787         if (startTime[_stateId] == 0) {
788             addStartCondition(_stateId, hasStartTimePassed);
789         }
790 
791         startTime[_stateId] = _timestamp;
792 
793         emit StateStartTimeSet(_stateId, _timestamp);
794     }
795 
796     function hasStartTimePassed(bytes32 _stateId) internal returns(bool) {
797         return startTime[_stateId] <= block.timestamp;
798     }
799 
800 }
801 
802 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
803 
804 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
805 contract TokenControllerI {
806 
807     /// @dev Specifies whether a transfer is allowed or not.
808     /// @return True if the transfer is allowed
809     function transferAllowed(address _from, address _to)
810         external
811         view 
812         returns (bool);
813 }
814 
815 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
816 
817 /**
818  * @title Basic token
819  * @dev Basic version of StandardToken, with no allowances.
820  */
821 contract BasicToken is ERC20Basic {
822   using SafeMath for uint256;
823 
824   mapping(address => uint256) balances;
825 
826   uint256 totalSupply_;
827 
828   /**
829   * @dev total number of tokens in existence
830   */
831   function totalSupply() public view returns (uint256) {
832     return totalSupply_;
833   }
834 
835   /**
836   * @dev transfer token for a specified address
837   * @param _to The address to transfer to.
838   * @param _value The amount to be transferred.
839   */
840   function transfer(address _to, uint256 _value) public returns (bool) {
841     require(_to != address(0));
842     require(_value <= balances[msg.sender]);
843 
844     balances[msg.sender] = balances[msg.sender].sub(_value);
845     balances[_to] = balances[_to].add(_value);
846     emit Transfer(msg.sender, _to, _value);
847     return true;
848   }
849 
850   /**
851   * @dev Gets the balance of the specified address.
852   * @param _owner The address to query the the balance of.
853   * @return An uint256 representing the amount owned by the passed address.
854   */
855   function balanceOf(address _owner) public view returns (uint256) {
856     return balances[_owner];
857   }
858 
859 }
860 
861 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
862 
863 /**
864  * @title Standard ERC20 token
865  *
866  * @dev Implementation of the basic standard token.
867  * @dev https://github.com/ethereum/EIPs/issues/20
868  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
869  */
870 contract StandardToken is ERC20, BasicToken {
871 
872   mapping (address => mapping (address => uint256)) internal allowed;
873 
874 
875   /**
876    * @dev Transfer tokens from one address to another
877    * @param _from address The address which you want to send tokens from
878    * @param _to address The address which you want to transfer to
879    * @param _value uint256 the amount of tokens to be transferred
880    */
881   function transferFrom(
882     address _from,
883     address _to,
884     uint256 _value
885   )
886     public
887     returns (bool)
888   {
889     require(_to != address(0));
890     require(_value <= balances[_from]);
891     require(_value <= allowed[_from][msg.sender]);
892 
893     balances[_from] = balances[_from].sub(_value);
894     balances[_to] = balances[_to].add(_value);
895     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
896     emit Transfer(_from, _to, _value);
897     return true;
898   }
899 
900   /**
901    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
902    *
903    * Beware that changing an allowance with this method brings the risk that someone may use both the old
904    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
905    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
906    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
907    * @param _spender The address which will spend the funds.
908    * @param _value The amount of tokens to be spent.
909    */
910   function approve(address _spender, uint256 _value) public returns (bool) {
911     allowed[msg.sender][_spender] = _value;
912     emit Approval(msg.sender, _spender, _value);
913     return true;
914   }
915 
916   /**
917    * @dev Function to check the amount of tokens that an owner allowed to a spender.
918    * @param _owner address The address which owns the funds.
919    * @param _spender address The address which will spend the funds.
920    * @return A uint256 specifying the amount of tokens still available for the spender.
921    */
922   function allowance(
923     address _owner,
924     address _spender
925    )
926     public
927     view
928     returns (uint256)
929   {
930     return allowed[_owner][_spender];
931   }
932 
933   /**
934    * @dev Increase the amount of tokens that an owner allowed to a spender.
935    *
936    * approve should be called when allowed[_spender] == 0. To increment
937    * allowed value is better to use this function to avoid 2 calls (and wait until
938    * the first transaction is mined)
939    * From MonolithDAO Token.sol
940    * @param _spender The address which will spend the funds.
941    * @param _addedValue The amount of tokens to increase the allowance by.
942    */
943   function increaseApproval(
944     address _spender,
945     uint _addedValue
946   )
947     public
948     returns (bool)
949   {
950     allowed[msg.sender][_spender] = (
951       allowed[msg.sender][_spender].add(_addedValue));
952     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
953     return true;
954   }
955 
956   /**
957    * @dev Decrease the amount of tokens that an owner allowed to a spender.
958    *
959    * approve should be called when allowed[_spender] == 0. To decrement
960    * allowed value is better to use this function to avoid 2 calls (and wait until
961    * the first transaction is mined)
962    * From MonolithDAO Token.sol
963    * @param _spender The address which will spend the funds.
964    * @param _subtractedValue The amount of tokens to decrease the allowance by.
965    */
966   function decreaseApproval(
967     address _spender,
968     uint _subtractedValue
969   )
970     public
971     returns (bool)
972   {
973     uint oldValue = allowed[msg.sender][_spender];
974     if (_subtractedValue > oldValue) {
975       allowed[msg.sender][_spender] = 0;
976     } else {
977       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
978     }
979     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
980     return true;
981   }
982 
983 }
984 
985 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
986 
987 /**
988  * @title Controllable ERC20 token
989  *
990  * @dev Token that queries a token controller contract to check if a transfer is allowed.
991  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
992  * implemented transferAllowed() function.
993  */
994 contract ControllableToken is Ownable, StandardToken {
995     TokenControllerI public controller;
996 
997     /// @dev Executes transferAllowed() function from the Controller. 
998     modifier isAllowed(address _from, address _to) {
999         require(controller.transferAllowed(_from, _to), "Token Controller does not permit transfer.");
1000         _;
1001     }
1002 
1003     /// @dev Sets the controller that is going to be used by isAllowed modifier
1004     function setController(TokenControllerI _controller) onlyOwner public {
1005         require(_controller != address(0), "Controller address should not be zero.");
1006         controller = _controller;
1007     }
1008 
1009     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
1010     /// @return True if the token is transfered with success
1011     function transfer(address _to, uint256 _value) 
1012         isAllowed(msg.sender, _to)
1013         public
1014         returns (bool)
1015     {
1016         return super.transfer(_to, _value);
1017     }
1018 
1019     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
1020     /// @return True if the token is transfered with success 
1021     function transferFrom(address _from, address _to, uint256 _value)
1022         isAllowed(_from, _to) 
1023         public 
1024         returns (bool)
1025     {
1026         return super.transferFrom(_from, _to, _value);
1027     }
1028 }
1029 
1030 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
1031 
1032 /**
1033  * @title DetailedERC20 token
1034  * @dev The decimals are only for visualization purposes.
1035  * All the operations are done using the smallest and indivisible token unit,
1036  * just as on Ethereum all the operations are done in wei.
1037  */
1038 contract DetailedERC20 is ERC20 {
1039   string public name;
1040   string public symbol;
1041   uint8 public decimals;
1042 
1043   constructor(string _name, string _symbol, uint8 _decimals) public {
1044     name = _name;
1045     symbol = _symbol;
1046     decimals = _decimals;
1047   }
1048 }
1049 
1050 // File: @tokenfoundry/token-contracts/contracts/Token.sol
1051 
1052 /**
1053  * @title Token base contract - Defines basic structure for a token
1054  *
1055  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
1056  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
1057  */
1058 contract Token is ControllableToken, DetailedERC20 {
1059 
1060 	/**
1061 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
1062 	* @param _supply Total supply of tokens.
1063     * @param _name Is the long name by which the token contract should be known
1064     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
1065     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
1066 	*/
1067     constructor(
1068         uint256 _supply,
1069         string _name,
1070         string _symbol,
1071         uint8 _decimals
1072     ) DetailedERC20(_name, _symbol, _decimals) public {
1073         require(_supply != 0, "Supply should be greater than 0.");
1074         totalSupply_ = _supply;
1075         balances[msg.sender] = _supply;
1076         emit Transfer(address(0), msg.sender, _supply);  //event
1077     }
1078 }
1079 
1080 // File: @tokenfoundry/sale-contracts/contracts/Sale.sol
1081 
1082 /// @title Sale base contract
1083 contract Sale is SaleI, Ownable, Whitelistable, TimedStateMachine, TokenControllerI {
1084     using SafeMath for uint256;
1085     using SafeERC20 for Token;
1086 
1087     // State machine states
1088     bytes32 private constant SETUP = "setup";
1089     bytes32 private constant FREEZE = "freeze";
1090     bytes32 private constant SALE_IN_PROGRESS = "saleInProgress";
1091     bytes32 private constant SALE_ENDED = "saleEnded";
1092     // solium-disable-next-line arg-overflow
1093     bytes32[] public states = [SETUP, FREEZE, SALE_IN_PROGRESS, SALE_ENDED];
1094 
1095     // Stores the contribution for each user
1096     mapping(address => uint256) public unitContributions;
1097 
1098     // Records extra tokens were allocated
1099     mapping(address => bool) public extraTokensAllocated;
1100 
1101     DisbursementHandler public disbursementHandler;
1102 
1103     uint256 public totalContributedUnits = 0; // Units
1104     uint256 public totalSaleCapUnits; // Units
1105     uint256 public minContributionUnits; // Units
1106     uint256 public minThresholdUnits; // Units
1107 
1108     // How many tokens a user will receive per each unit contributed
1109     uint256 public saleTokensPerUnit;
1110     // Rate that will be used to calculate extra tokens if Sale is not sold out
1111     uint256 public extraTokensPerUnit;
1112     // Total amount of tokens that the sale will distribute to contributors
1113     uint256 public tokensForSale;
1114 
1115     Token public trustedToken;
1116     Vault public trustedVault;
1117     EthPriceFeedI public ethPriceFeed; 
1118 
1119     event Contribution(
1120         address indexed contributor,
1121         address indexed sender,
1122         uint256 valueUnit,
1123         uint256 valueWei,
1124         uint256 excessWei,
1125         uint256 weiPerUnitRate
1126     );
1127 
1128     event EthPriceFeedChanged(address previousEthPriceFeed, address newEthPriceFeed);
1129 
1130     event TokensAllocated(address indexed contributor, uint256 tokenAmount);
1131 
1132     constructor (
1133         uint256 _totalSaleCapUnits, // Units
1134         uint256 _minContributionUnits, // Units
1135         uint256 _minThresholdUnits, // Units
1136         uint256 _maxTokens,
1137         address _whitelistAdmin,
1138         address _wallet,
1139         uint256 _vaultInitialDisburseWei, // Wei
1140         uint256 _vaultDisbursementWei, // Wei
1141         uint256 _vaultDisbursementDuration,
1142         uint256 _startTime,
1143         string _tokenName,
1144         string _tokenSymbol,
1145         uint8 _tokenDecimals, 
1146         EthPriceFeedI _ethPriceFeed
1147     ) 
1148         Whitelistable(_whitelistAdmin)
1149         public 
1150     {
1151         require(_totalSaleCapUnits != 0, "Total sale cap units must be > 0");
1152         require(_maxTokens != 0, "The maximum number of tokens must be > 0");
1153         require(_wallet != 0, "The team's wallet address cannot be 0");
1154         require(_minThresholdUnits <= _totalSaleCapUnits, "The minimum threshold (units) cannot be larger than the sale cap (units)");
1155         require(_ethPriceFeed != address(0), "The ETH price feed cannot be the 0 address");
1156         require(now < _startTime, "The start time must be in the future");
1157 
1158         totalSaleCapUnits = _totalSaleCapUnits;
1159         minContributionUnits = _minContributionUnits;
1160         minThresholdUnits = _minThresholdUnits;
1161 
1162         // Setup the necessary contracts
1163         trustedToken = new Token(
1164             _maxTokens,
1165             _tokenName,
1166             _tokenSymbol,
1167             _tokenDecimals
1168         );
1169 
1170         disbursementHandler = new DisbursementHandler(trustedToken);
1171 
1172         disbursementHandler.transferOwnership(owner);
1173 
1174         ethPriceFeed = _ethPriceFeed; 
1175 
1176         // The token will query the isTransferAllowed function contained in this contract
1177         trustedToken.setController(this);
1178 
1179         trustedVault = new Vault(
1180             _wallet,
1181             _vaultInitialDisburseWei,
1182             _vaultDisbursementWei, // disbursement amount
1183             _vaultDisbursementDuration
1184         );
1185 
1186         // Set the states
1187         setStates(states);
1188 
1189         // Specify which functions are allowed in each state
1190         allowFunction(SETUP, this.setup.selector);
1191         allowFunction(FREEZE, this.setEndTime.selector);
1192         allowFunction(SALE_IN_PROGRESS, this.setEndTime.selector);
1193         allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
1194         allowFunction(SALE_IN_PROGRESS, this.endSale.selector);
1195         allowFunction(SALE_ENDED, this.allocateExtraTokens.selector);
1196 
1197         // End the sale when the cap is reached
1198         addStartCondition(SALE_ENDED, wasCapReached);
1199 
1200         // Set the start time for the sale
1201         setStateStartTime(SALE_IN_PROGRESS, _startTime);
1202 
1203         // Set the onSaleEnded callback (will be called when the sale ends)
1204         addCallback(SALE_ENDED, onSaleEnded);
1205 
1206     }
1207 
1208     /// @dev Setup the disbursements and the number of tokens for sale.
1209     /// @dev This needs to be outside the constructor because the token needs to query the sale for allowed transfers.
1210     function setup() external onlyOwner checkAllowed {
1211         require(disbursementHandler.closed(), "Disbursement handler not closed");
1212         trustedToken.safeTransfer(disbursementHandler, disbursementHandler.totalAmount());
1213 
1214         tokensForSale = trustedToken.balanceOf(this);     
1215         require(tokensForSale >= totalSaleCapUnits, "Higher sale cap units than tokens for sale => tokens per unit would be 0");
1216 
1217         // Set the worst rate of tokens per unit
1218         // If sale doesn't sell out, extra tokens will be disbursed after the sale ends.
1219         saleTokensPerUnit = tokensForSale.div(totalSaleCapUnits);
1220 
1221         // Go to freeze state
1222         goToNextState();
1223     }
1224 
1225     /// @dev To change the EthPriceFeed contract if needed 
1226     function changeEthPriceFeed(EthPriceFeedI _ethPriceFeed) external onlyOwner {
1227         require(_ethPriceFeed != address(0), "ETH price feed address cannot be 0");
1228         emit EthPriceFeedChanged(ethPriceFeed, _ethPriceFeed);
1229         ethPriceFeed = _ethPriceFeed;
1230     }
1231 
1232     /// @dev Called by users to contribute ETH to the sale.
1233     function contribute(
1234         address _contributor,
1235         uint256 _contributionLimitUnits, 
1236         uint256 _payloadExpiration,
1237         bytes _sig
1238     ) 
1239         external 
1240         payable
1241         checkAllowed 
1242         isWhitelisted(keccak256(
1243             abi.encodePacked(
1244                 _contributor,
1245                 _contributionLimitUnits, 
1246                 _payloadExpiration
1247             )
1248         ), _sig)
1249     {
1250         require(msg.sender == _contributor, "Contributor address different from whitelisted address");
1251         require(now < _payloadExpiration, "Payload has expired"); 
1252 
1253         uint256 weiPerUnitRate = ethPriceFeed.getRate(); 
1254         require(weiPerUnitRate != 0, "Wei per unit rate from feed is 0");
1255 
1256         uint256 previouslyContributedUnits = unitContributions[_contributor];
1257 
1258         // Check that the contribution amount doesn't go over the sale cap or personal contributionLimitUnits 
1259         uint256 currentContributionUnits = min256(
1260             _contributionLimitUnits.sub(previouslyContributedUnits),
1261             totalSaleCapUnits.sub(totalContributedUnits),
1262             msg.value.div(weiPerUnitRate)
1263         );
1264 
1265         require(currentContributionUnits != 0, "No contribution permitted (contributor or sale has reached cap)");
1266 
1267         // Check that it is higher than minContributionUnits
1268         require(currentContributionUnits >= minContributionUnits || previouslyContributedUnits != 0, "Minimum contribution not reached");
1269 
1270         // Update the state
1271         unitContributions[_contributor] = previouslyContributedUnits.add(currentContributionUnits);
1272         totalContributedUnits = totalContributedUnits.add(currentContributionUnits);
1273 
1274         uint256 currentContributionWei = currentContributionUnits.mul(weiPerUnitRate);
1275         trustedVault.deposit.value(currentContributionWei)(msg.sender);
1276 
1277         // If the minThresholdUnits is reached for the first time, notify the vault
1278         if (totalContributedUnits >= minThresholdUnits &&
1279             trustedVault.state() != Vault.State.Success) {
1280             trustedVault.saleSuccessful();
1281         }
1282 
1283         // If there is an excess, return it to the sender
1284         uint256 excessWei = msg.value.sub(currentContributionWei);
1285         if (excessWei > 0) {
1286             msg.sender.transfer(excessWei);
1287         }
1288 
1289         emit Contribution(
1290             _contributor, 
1291             msg.sender,
1292             currentContributionUnits, 
1293             currentContributionWei, 
1294             excessWei,
1295             weiPerUnitRate
1296         );
1297 
1298         // Allocate tokens     
1299         uint256 tokenAmount = currentContributionUnits.mul(saleTokensPerUnit);
1300         trustedToken.safeTransfer(_contributor, tokenAmount);
1301         emit TokensAllocated(_contributor, tokenAmount);
1302     }
1303 
1304     /// @dev Called to allocate the tokens depending on amount contributed by the end of the sale.
1305     /// @param _contributor The address of the contributor.
1306     function allocateExtraTokens(address _contributor)
1307         external 
1308         checkAllowed
1309     {    
1310         require(!extraTokensAllocated[_contributor], "Extra tokens already allocated to contributor");
1311         require(unitContributions[_contributor] != 0, "Address didn't contribute to sale");
1312         // Allocate extra tokens only if total sale cap is not reached
1313         require(totalContributedUnits < totalSaleCapUnits, "The sale cap was reached, no extra tokens to allocate");
1314 
1315         // Transfer the respective tokens to the contributor
1316         extraTokensAllocated[_contributor] = true;
1317         uint256 tokenAmount = unitContributions[_contributor].mul(extraTokensPerUnit);
1318         trustedToken.safeTransfer(_contributor, tokenAmount);
1319 
1320         emit TokensAllocated(_contributor, tokenAmount);
1321     }
1322 
1323     /// @dev Sets the end time for the sale
1324     /// @param _endTime The timestamp at which the sale will end.
1325     function setEndTime(uint256 _endTime) external onlyOwner checkAllowed {
1326         require(now < _endTime, "Cannot set end time in the past");
1327         require(getStateStartTime(SALE_ENDED) == 0, "End time already set");
1328         setStateStartTime(SALE_ENDED, _endTime);
1329     }
1330 
1331     /// @dev Called to enable refunds by the owner. Can only be called in any state (without triggering conditional transitions)
1332     /// @dev This is only meant to be used if there is an emergency and the endSale() function can't be called
1333     function enableRefunds() external onlyOwner {
1334         trustedVault.enableRefunds();
1335     }
1336 
1337     /// @dev Called to end the sale by the owner. Can only be called in SALE_IN_PROGRESS state
1338     function endSale() external onlyOwner checkAllowed {
1339         goToNextState();
1340     }
1341 
1342     /// @dev Since Sale is TokenControllerI, it has to implement transferAllowed() function
1343     /// @notice only the Sale and DisbursementHandler can disburse the initial tokens to their future owners
1344     function transferAllowed(address _from, address)
1345         external
1346         view
1347         returns (bool)
1348     {
1349         return _from == address(this) || _from == address(disbursementHandler);
1350     }
1351    
1352     /// @dev Returns true if the cap was reached.
1353     function wasCapReached(bytes32) internal returns (bool) {
1354         return totalSaleCapUnits <= totalContributedUnits;
1355     }
1356 
1357     /// @dev Callback that gets called when entering the SALE_ENDED state.
1358     function onSaleEnded() internal {
1359 
1360         trustedToken.transferOwnership(owner); 
1361 
1362         if (totalContributedUnits == 0) {
1363 
1364             // If no tokens were sold, transfer them back to the project team
1365             trustedToken.safeTransfer(trustedVault.trustedWallet(), tokensForSale);
1366 
1367         } else if (totalContributedUnits < minThresholdUnits) {
1368 
1369             // If the minimum threshold wasn't reached, enable refunds
1370             trustedVault.enableRefunds();
1371 
1372         } else {
1373 
1374             // Calculate the rate for the extra tokens (if the sale was sold out, it will be 0)
1375             extraTokensPerUnit = tokensForSale.div(totalContributedUnits).sub(saleTokensPerUnit);
1376 
1377             // Close the vault and transfer ownership to the owner of the sale
1378             trustedVault.close();
1379             trustedVault.transferOwnership(owner);
1380 
1381         }
1382     }
1383 
1384     /// @dev a function to return the minimum of 3 values
1385     function min256(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
1386         return Math.min256(x, Math.min256(y, z));
1387     }
1388 
1389 }
1390 
1391 // File: contracts/GamerTokenSale.sol
1392 
1393 contract GamerTokenSale is Sale {
1394 
1395     constructor() 
1396         Sale(
1397             25000000, // Total sale cap (usd)
1398             5, // Min contribution (usd)
1399             2000000, // Min threshold (usd)
1400             1000000000 * (10 ** 18), // Max tokens
1401             0x38a61BDEbAa1f312d6a7765165EF2c05d4957152, // Whitelist Admin
1402             0xEE8A84b3B964AfB5433ecd55F517c4D3F43049B5, // Wallet
1403             10000 ether, // Vault initial Wei
1404             90000 ether, // Vault disbursement Wei
1405             0, // Vault disbursement duration (0 means transfer everything right away)
1406             now + 10 minutes, // Start time
1407             "GamerToken", // Token name
1408             "GTX", // Token symbol
1409             18, // Token decimals
1410             EthPriceFeedI(0x54bF24e1070784D7F0760095932b47CE55eb3A91) // Eth price feed
1411         )
1412         public 
1413     {
1414     }
1415 }