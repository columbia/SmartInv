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
208     constructor(ERC20 _token) public {
209         require(_token != address(0));
210         token = _token;
211     }
212 
213     /// @dev Called by the sale contract to create a disbursement.
214     /// @param _beneficiary The address of the beneficiary.
215     /// @param _value Amount of tokens to be locked.
216     /// @param _timestamp Funds will be locked until this timestamp.
217     function setupDisbursement(
218         address _beneficiary,
219         uint256 _value,
220         uint256 _timestamp
221     )
222         external
223         onlyOwner
224     {
225         require(block.timestamp < _timestamp);
226         disbursements[_beneficiary].push(Disbursement(_timestamp, _value));
227         totalAmount = totalAmount.add(_value);
228         emit Setup(_beneficiary, _timestamp, _value);
229     }
230 
231     /// @dev Transfers tokens to a beneficiary
232     /// @param _beneficiary The address to transfer tokens to
233     /// @param _index The index of the disbursement
234     function withdraw(address _beneficiary, uint256 _index)
235         external
236     {
237         Disbursement[] storage beneficiaryDisbursements = disbursements[_beneficiary];
238         require(_index < beneficiaryDisbursements.length);
239 
240         Disbursement memory disbursement = beneficiaryDisbursements[_index];
241         require(disbursement.timestamp < now && disbursement.value > 0);
242 
243         // Remove the withdrawn disbursement
244         delete beneficiaryDisbursements[_index];
245 
246         token.safeTransfer(_beneficiary, disbursement.value);
247         emit TokensWithdrawn(_beneficiary, disbursement.value);
248     }
249 }
250 
251 // File: @tokenfoundry/sale-contracts/contracts/interfaces/VaultI.sol
252 
253 interface VaultI {
254     function deposit(address contributor) external payable;
255     function saleSuccessful() external;
256     function enableRefunds() external;
257     function refund(address contributor) external;
258     function close() external;
259     function sendFundsToWallet() external;
260 }
261 
262 // File: openzeppelin-solidity/contracts/math/Math.sol
263 
264 /**
265  * @title Math
266  * @dev Assorted math operations
267  */
268 library Math {
269   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
270     return a >= b ? a : b;
271   }
272 
273   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
274     return a < b ? a : b;
275   }
276 
277   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
278     return a >= b ? a : b;
279   }
280 
281   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
282     return a < b ? a : b;
283   }
284 }
285 
286 // File: @tokenfoundry/sale-contracts/contracts/Vault.sol
287 
288 // Adapted from Open Zeppelin's RefundVault
289 
290 /**
291  * @title Vault
292  * @dev This contract is used for storing funds while a crowdsale
293  * is in progress. Supports refunding the money if crowdsale fails,
294  * and forwarding it if crowdsale is successful.
295  */
296 contract Vault is VaultI, Ownable {
297     using SafeMath for uint256;
298 
299     enum State { Active, Success, Refunding, Closed }
300 
301     // The timestamp of the first deposit
302     uint256 public firstDepositTimestamp; 
303 
304     mapping (address => uint256) public deposited;
305 
306     // The amount to be disbursed to the wallet every month
307     uint256 public disbursementWei;
308     uint256 public disbursementDuration;
309 
310     // Wallet from the project team
311     address public trustedWallet;
312 
313     // The eth amount the team will get initially if the sale is successful
314     uint256 public initialWei;
315 
316     // Timestamp that has to pass before sending funds to the wallet
317     uint256 public nextDisbursement;
318     
319     // Total amount that was deposited
320     uint256 public totalDeposited;
321 
322     // Amount that can be refunded
323     uint256 public refundable;
324 
325     State public state;
326 
327     event Closed();
328     event RefundsEnabled();
329     event Refunded(address indexed contributor, uint256 amount);
330 
331     modifier atState(State _state) {
332         require(state == _state);
333         _;
334     }
335 
336     constructor (
337         address _wallet,
338         uint256 _initialWei,
339         uint256 _disbursementWei,
340         uint256 _disbursementDuration
341     ) 
342         public 
343     {
344         require(_wallet != address(0));
345         require(_disbursementWei != 0);
346         trustedWallet = _wallet;
347         initialWei = _initialWei;
348         disbursementWei = _disbursementWei;
349         disbursementDuration = _disbursementDuration;
350         state = State.Active;
351     }
352 
353     /// @dev Called by the sale contract to deposit ether for a contributor.
354     function deposit(address _contributor) onlyOwner external payable {
355         require(state == State.Active || state == State.Success);
356         if (firstDepositTimestamp == 0) {
357             firstDepositTimestamp = now;
358         }
359         totalDeposited = totalDeposited.add(msg.value);
360         deposited[_contributor] = deposited[_contributor].add(msg.value);
361     }
362 
363     /// @dev Sends initial funds to the wallet.
364     function saleSuccessful()
365         onlyOwner 
366         external 
367         atState(State.Active)
368     {
369         state = State.Success;
370         transferToWallet(initialWei);
371     }
372 
373     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
374     function enableRefunds() onlyOwner external {
375         require(state != State.Refunding);
376         state = State.Refunding;
377         uint256 currentBalance = address(this).balance;
378         refundable = currentBalance <= totalDeposited ? currentBalance : totalDeposited;
379         emit RefundsEnabled();
380     }
381 
382     /// @dev Refunds ether to the contributors if in the Refunding state.
383     function refund(address _contributor) external atState(State.Refunding) {
384         require(deposited[_contributor] > 0);
385         uint256 refundAmount = deposited[_contributor].mul(refundable).div(totalDeposited);
386         deposited[_contributor] = 0;
387         _contributor.transfer(refundAmount);
388         emit Refunded(_contributor, refundAmount);
389     }
390 
391     /// @dev Called by the owner if the sale has ended.
392     function close() external atState(State.Success) onlyOwner {
393         state = State.Closed;
394         nextDisbursement = now;
395         emit Closed();
396     }
397 
398     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
399     function sendFundsToWallet() external atState(State.Closed) {
400         require(nextDisbursement <= now);
401 
402         if (disbursementDuration == 0) {
403             trustedWallet.transfer(address(this).balance);
404             return;
405         }
406 
407         uint256 numberOfDisbursements = now.sub(nextDisbursement).div(disbursementDuration).add(1);
408 
409         nextDisbursement = nextDisbursement.add(disbursementDuration.mul(numberOfDisbursements));
410 
411         transferToWallet(disbursementWei.mul(numberOfDisbursements));
412     }
413 
414     function transferToWallet(uint256 _amount) internal {
415         uint256 amountToSend = Math.min256(_amount, address(this).balance);
416         trustedWallet.transfer(amountToSend);
417     }
418 }
419 
420 // File: @tokenfoundry/sale-contracts/contracts/interfaces/WhitelistableI.sol
421 
422 interface WhitelistableI {
423     function changeAdmin(address _admin) external;
424     function invalidateHash(bytes32 _hash) external;
425     function invalidateHashes(bytes32[] _hashes) external;
426 }
427 
428 // File: openzeppelin-solidity/contracts/ECRecovery.sol
429 
430 /**
431  * @title Eliptic curve signature operations
432  *
433  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
434  *
435  * TODO Remove this library once solidity supports passing a signature to ecrecover.
436  * See https://github.com/ethereum/solidity/issues/864
437  *
438  */
439 
440 library ECRecovery {
441 
442   /**
443    * @dev Recover signer address from a message by using their signature
444    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
445    * @param sig bytes signature, the signature is generated using web3.eth.sign()
446    */
447   function recover(bytes32 hash, bytes sig)
448     internal
449     pure
450     returns (address)
451   {
452     bytes32 r;
453     bytes32 s;
454     uint8 v;
455 
456     // Check the signature length
457     if (sig.length != 65) {
458       return (address(0));
459     }
460 
461     // Divide the signature in r, s and v variables
462     // ecrecover takes the signature parameters, and the only way to get them
463     // currently is to use assembly.
464     // solium-disable-next-line security/no-inline-assembly
465     assembly {
466       r := mload(add(sig, 32))
467       s := mload(add(sig, 64))
468       v := byte(0, mload(add(sig, 96)))
469     }
470 
471     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
472     if (v < 27) {
473       v += 27;
474     }
475 
476     // If the version is correct return the signer address
477     if (v != 27 && v != 28) {
478       return (address(0));
479     } else {
480       // solium-disable-next-line arg-overflow
481       return ecrecover(hash, v, r, s);
482     }
483   }
484 
485   /**
486    * toEthSignedMessageHash
487    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
488    * @dev and hash the result
489    */
490   function toEthSignedMessageHash(bytes32 hash)
491     internal
492     pure
493     returns (bytes32)
494   {
495     // 32 is the length in bytes of hash,
496     // enforced by the type signature above
497     return keccak256(
498       "\x19Ethereum Signed Message:\n32",
499       hash
500     );
501   }
502 }
503 
504 // File: @tokenfoundry/sale-contracts/contracts/Whitelistable.sol
505 
506 /**
507  * @title Whitelistable
508  * @dev This contract is used to implement a signature based whitelisting mechanism
509  */
510 contract Whitelistable is WhitelistableI, Ownable {
511     using ECRecovery for bytes32;
512 
513     address public whitelistAdmin;
514 
515     // True if the hash has been invalidated
516     mapping(bytes32 => bool) public invalidHash;
517 
518     event AdminUpdated(address indexed newAdmin);
519 
520     modifier validAdmin(address _admin) {
521         require(_admin != 0);
522         _;
523     }
524 
525     modifier onlyAdmin {
526         require(msg.sender == whitelistAdmin);
527         _;
528     }
529 
530     modifier isWhitelisted(bytes32 _hash, bytes _sig) {
531         require(checkWhitelisted(_hash, _sig));
532         _;
533     }
534 
535     /// @dev Constructor for Whitelistable contract
536     /// @param _admin the address of the admin that will generate the signatures
537     constructor(address _admin) public validAdmin(_admin) {
538         whitelistAdmin = _admin;        
539     }
540 
541     /// @dev Updates whitelistAdmin address 
542     /// @dev Can only be called by the current owner
543     /// @param _admin the new admin address
544     function changeAdmin(address _admin)
545         external
546         onlyOwner
547         validAdmin(_admin)
548     {
549         emit AdminUpdated(_admin);
550         whitelistAdmin = _admin;
551     }
552 
553     // @dev blacklists the given address to ban them from contributing
554     // @param _contributor Address of the contributor to blacklist 
555     function invalidateHash(bytes32 _hash) external onlyAdmin {
556         invalidHash[_hash] = true;
557     }
558 
559     function invalidateHashes(bytes32[] _hashes) external onlyAdmin {
560         for (uint i = 0; i < _hashes.length; i++) {
561             invalidHash[_hashes[i]] = true;
562         }
563     }
564 
565     /// @dev Checks if a hash has been signed by the whitelistAdmin
566     /// @param _rawHash The hash that was used to generate the signature
567     /// @param _sig The EC signature generated by the whitelistAdmin
568     /// @return Was the signature generated by the admin for the hash?
569     function checkWhitelisted(
570         bytes32 _rawHash,
571         bytes _sig
572     )
573         public
574         view
575         returns(bool)
576     {
577         bytes32 hash = _rawHash.toEthSignedMessageHash();
578         return !invalidHash[_rawHash] && whitelistAdmin == hash.recover(_sig);
579     }
580 }
581 
582 // File: @tokenfoundry/sale-contracts/contracts/interfaces/EthPriceFeedI.sol
583 
584 interface EthPriceFeedI {
585     function getUnit() external view returns(string);
586     function getRate() external view returns(uint256);
587     function getLastTimeUpdated() external view returns(uint256); 
588 }
589 
590 // File: @tokenfoundry/sale-contracts/contracts/interfaces/SaleI.sol
591 
592 interface SaleI {
593     function setup() external;  
594     function changeEthPriceFeed(EthPriceFeedI newPriceFeed) external;
595     function contribute(address _contributor, uint256 _limit, uint256 _expiration, bytes _sig) external payable; 
596     function allocateExtraTokens(address _contributor) external;
597     function setEndTime(uint256 _endTime) external;
598     function endSale() external;
599 }
600 
601 // File: @tokenfoundry/state-machine/contracts/StateMachine.sol
602 
603 contract StateMachine {
604 
605     struct State { 
606         bytes32 nextStateId;
607         mapping(bytes4 => bool) allowedFunctions;
608         function() internal[] transitionCallbacks;
609         function(bytes32) internal returns(bool)[] startConditions;
610     }
611 
612     mapping(bytes32 => State) states;
613 
614     // The current state id
615     bytes32 private currentStateId;
616 
617     event Transition(bytes32 stateId, uint256 blockNumber);
618 
619     /* This modifier performs the conditional transitions and checks that the function 
620      * to be executed is allowed in the current State
621      */
622     modifier checkAllowed {
623         conditionalTransitions();
624         require(states[currentStateId].allowedFunctions[msg.sig]);
625         _;
626     }
627 
628     ///@dev transitions the state machine into the state it should currently be in
629     ///@dev by taking into account the current conditions and how many further transitions can occur 
630     function conditionalTransitions() public {
631         bool checkNextState; 
632         do {
633             checkNextState = false;
634 
635             bytes32 next = states[currentStateId].nextStateId;
636             // If one of the next state's conditions is met, go to this state and continue
637 
638             for (uint256 i = 0; i < states[next].startConditions.length; i++) {
639                 if (states[next].startConditions[i](next)) {
640                     goToNextState();
641                     checkNextState = true;
642                     break;
643                 }
644             } 
645         } while (checkNextState);
646     }
647 
648     function getCurrentStateId() view public returns(bytes32) {
649         return currentStateId;
650     }
651 
652     /// @dev Setup the state machine with the given states.
653     /// @param _stateIds Array of state ids.
654     function setStates(bytes32[] _stateIds) internal {
655         require(_stateIds.length > 0);
656         require(currentStateId == 0);
657 
658         require(_stateIds[0] != 0);
659 
660         currentStateId = _stateIds[0];
661 
662         for (uint256 i = 1; i < _stateIds.length; i++) {
663             require(_stateIds[i] != 0);
664 
665             states[_stateIds[i - 1]].nextStateId = _stateIds[i];
666 
667             // Check that the state appears only once in the array
668             require(states[_stateIds[i]].nextStateId == 0);
669         }
670     }
671 
672     /// @dev Allow a function in the given state.
673     /// @param _stateId The id of the state
674     /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
675     function allowFunction(bytes32 _stateId, bytes4 _functionSelector) 
676         internal 
677     {
678         states[_stateId].allowedFunctions[_functionSelector] = true;
679     }
680 
681     /// @dev Goes to the next state if possible (if the next state is valid)
682     function goToNextState() internal {
683         bytes32 next = states[currentStateId].nextStateId;
684         require(next != 0);
685 
686         currentStateId = next;
687         for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
688             states[next].transitionCallbacks[i]();
689         }
690 
691         emit Transition(next, block.number);
692     }
693 
694     ///@dev Add a function returning a boolean as a start condition for a state. 
695     /// If any condition returns true, the StateMachine will transition to the next state.
696     /// If s.startConditions is empty, the StateMachine will need to enter state s through invoking
697     /// the goToNextState() function. 
698     /// A start condition should never throw. (Otherwise, the StateMachine may fail to enter into the
699     /// correct state, and succeeding start conditions may return true.)
700     /// A start condition should be gas-inexpensive since every one of them is invoked in the same call to 
701     /// transition the state. 
702     ///@param _stateId The ID of the state to add the condition for
703     ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
704     function addStartCondition(
705         bytes32 _stateId,
706         function(bytes32) internal returns(bool) _condition
707     ) 
708         internal 
709     {
710         states[_stateId].startConditions.push(_condition);
711     }
712 
713     ///@dev Add a callback function for a state. All callbacks are invoked immediately after entering the state. 
714     /// Callback functions should never throw. (Otherwise, the StateMachine may fail to enter a state.)
715     /// Callback functions should also be gas-inexpensive as all callbacks are invoked in the same call to enter the state.
716     ///@param _stateId The ID of the state to add a callback function for
717     ///@param _callback The callback function to add
718     function addCallback(bytes32 _stateId, function() internal _callback)
719         internal 
720     {
721         states[_stateId].transitionCallbacks.push(_callback);
722     }
723 }
724 
725 // File: @tokenfoundry/state-machine/contracts/TimedStateMachine.sol
726 
727 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
728 contract TimedStateMachine is StateMachine {
729 
730     event StateStartTimeSet(bytes32 indexed _stateId, uint256 _startTime);
731 
732     // Stores the start timestamp for each state (the value is 0 if the state doesn't have a start timestamp).
733     mapping(bytes32 => uint256) private startTime;
734 
735     /// @dev Returns the timestamp for the given state id.
736     /// @param _stateId The id of the state for which we want to set the start timestamp.
737     function getStateStartTime(bytes32 _stateId) public view returns(uint256) {
738         return startTime[_stateId];
739     }
740 
741     /// @dev Sets the starting timestamp for a state as a startCondition. If other start conditions exist and are 
742     /// met earlier, then the state may be entered into earlier than the specified start time. 
743     /// @param _stateId The id of the state for which we want to set the start timestamp.
744     /// @param _timestamp The start timestamp for the given state. It should be bigger than the current one.
745     function setStateStartTime(bytes32 _stateId, uint256 _timestamp) internal {
746         require(block.timestamp < _timestamp);
747 
748         if (startTime[_stateId] == 0) {
749             addStartCondition(_stateId, hasStartTimePassed);
750         }
751 
752         startTime[_stateId] = _timestamp;
753 
754         emit StateStartTimeSet(_stateId, _timestamp);
755     }
756 
757     function hasStartTimePassed(bytes32 _stateId) internal returns(bool) {
758         return startTime[_stateId] <= block.timestamp;
759     }
760 
761 }
762 
763 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
764 
765 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
766 contract TokenControllerI {
767 
768     /// @dev Specifies whether a transfer is allowed or not.
769     /// @return True if the transfer is allowed
770     function transferAllowed(address _from, address _to)
771         external
772         view 
773         returns (bool);
774 }
775 
776 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
777 
778 /**
779  * @title Basic token
780  * @dev Basic version of StandardToken, with no allowances.
781  */
782 contract BasicToken is ERC20Basic {
783   using SafeMath for uint256;
784 
785   mapping(address => uint256) balances;
786 
787   uint256 totalSupply_;
788 
789   /**
790   * @dev total number of tokens in existence
791   */
792   function totalSupply() public view returns (uint256) {
793     return totalSupply_;
794   }
795 
796   /**
797   * @dev transfer token for a specified address
798   * @param _to The address to transfer to.
799   * @param _value The amount to be transferred.
800   */
801   function transfer(address _to, uint256 _value) public returns (bool) {
802     require(_to != address(0));
803     require(_value <= balances[msg.sender]);
804 
805     balances[msg.sender] = balances[msg.sender].sub(_value);
806     balances[_to] = balances[_to].add(_value);
807     emit Transfer(msg.sender, _to, _value);
808     return true;
809   }
810 
811   /**
812   * @dev Gets the balance of the specified address.
813   * @param _owner The address to query the the balance of.
814   * @return An uint256 representing the amount owned by the passed address.
815   */
816   function balanceOf(address _owner) public view returns (uint256) {
817     return balances[_owner];
818   }
819 
820 }
821 
822 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
823 
824 /**
825  * @title Standard ERC20 token
826  *
827  * @dev Implementation of the basic standard token.
828  * @dev https://github.com/ethereum/EIPs/issues/20
829  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
830  */
831 contract StandardToken is ERC20, BasicToken {
832 
833   mapping (address => mapping (address => uint256)) internal allowed;
834 
835 
836   /**
837    * @dev Transfer tokens from one address to another
838    * @param _from address The address which you want to send tokens from
839    * @param _to address The address which you want to transfer to
840    * @param _value uint256 the amount of tokens to be transferred
841    */
842   function transferFrom(
843     address _from,
844     address _to,
845     uint256 _value
846   )
847     public
848     returns (bool)
849   {
850     require(_to != address(0));
851     require(_value <= balances[_from]);
852     require(_value <= allowed[_from][msg.sender]);
853 
854     balances[_from] = balances[_from].sub(_value);
855     balances[_to] = balances[_to].add(_value);
856     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
857     emit Transfer(_from, _to, _value);
858     return true;
859   }
860 
861   /**
862    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
863    *
864    * Beware that changing an allowance with this method brings the risk that someone may use both the old
865    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
866    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
867    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
868    * @param _spender The address which will spend the funds.
869    * @param _value The amount of tokens to be spent.
870    */
871   function approve(address _spender, uint256 _value) public returns (bool) {
872     allowed[msg.sender][_spender] = _value;
873     emit Approval(msg.sender, _spender, _value);
874     return true;
875   }
876 
877   /**
878    * @dev Function to check the amount of tokens that an owner allowed to a spender.
879    * @param _owner address The address which owns the funds.
880    * @param _spender address The address which will spend the funds.
881    * @return A uint256 specifying the amount of tokens still available for the spender.
882    */
883   function allowance(
884     address _owner,
885     address _spender
886    )
887     public
888     view
889     returns (uint256)
890   {
891     return allowed[_owner][_spender];
892   }
893 
894   /**
895    * @dev Increase the amount of tokens that an owner allowed to a spender.
896    *
897    * approve should be called when allowed[_spender] == 0. To increment
898    * allowed value is better to use this function to avoid 2 calls (and wait until
899    * the first transaction is mined)
900    * From MonolithDAO Token.sol
901    * @param _spender The address which will spend the funds.
902    * @param _addedValue The amount of tokens to increase the allowance by.
903    */
904   function increaseApproval(
905     address _spender,
906     uint _addedValue
907   )
908     public
909     returns (bool)
910   {
911     allowed[msg.sender][_spender] = (
912       allowed[msg.sender][_spender].add(_addedValue));
913     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
914     return true;
915   }
916 
917   /**
918    * @dev Decrease the amount of tokens that an owner allowed to a spender.
919    *
920    * approve should be called when allowed[_spender] == 0. To decrement
921    * allowed value is better to use this function to avoid 2 calls (and wait until
922    * the first transaction is mined)
923    * From MonolithDAO Token.sol
924    * @param _spender The address which will spend the funds.
925    * @param _subtractedValue The amount of tokens to decrease the allowance by.
926    */
927   function decreaseApproval(
928     address _spender,
929     uint _subtractedValue
930   )
931     public
932     returns (bool)
933   {
934     uint oldValue = allowed[msg.sender][_spender];
935     if (_subtractedValue > oldValue) {
936       allowed[msg.sender][_spender] = 0;
937     } else {
938       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
939     }
940     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
941     return true;
942   }
943 
944 }
945 
946 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
947 
948 /**
949  * @title Controllable ERC20 token
950  *
951  * @dev Token that queries a token controller contract to check if a transfer is allowed.
952  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
953  * implemented transferAllowed() function.
954  */
955 contract ControllableToken is Ownable, StandardToken {
956     TokenControllerI public controller;
957 
958     /// @dev Executes transferAllowed() function from the Controller. 
959     modifier isAllowed(address _from, address _to) {
960         require(controller.transferAllowed(_from, _to));
961         _;
962     }
963 
964     /// @dev Sets the controller that is going to be used by isAllowed modifier
965     function setController(TokenControllerI _controller) onlyOwner public {
966         require(_controller != address(0));
967         controller = _controller;
968     }
969 
970     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
971     /// @return True if the token is transfered with success
972     function transfer(address _to, uint256 _value) 
973         isAllowed(msg.sender, _to)
974         public
975         returns (bool)
976     {
977         return super.transfer(_to, _value);
978     }
979 
980     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
981     /// @return True if the token is transfered with success 
982     function transferFrom(address _from, address _to, uint256 _value)
983         isAllowed(_from, _to) 
984         public 
985         returns (bool)
986     {
987         return super.transferFrom(_from, _to, _value);
988     }
989 }
990 
991 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
992 
993 /**
994  * @title DetailedERC20 token
995  * @dev The decimals are only for visualization purposes.
996  * All the operations are done using the smallest and indivisible token unit,
997  * just as on Ethereum all the operations are done in wei.
998  */
999 contract DetailedERC20 is ERC20 {
1000   string public name;
1001   string public symbol;
1002   uint8 public decimals;
1003 
1004   constructor(string _name, string _symbol, uint8 _decimals) public {
1005     name = _name;
1006     symbol = _symbol;
1007     decimals = _decimals;
1008   }
1009 }
1010 
1011 // File: @tokenfoundry/token-contracts/contracts/Token.sol
1012 
1013 /**
1014  * @title Token base contract - Defines basic structure for a token
1015  *
1016  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
1017  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
1018  */
1019 contract Token is ControllableToken, DetailedERC20 {
1020 
1021 	/**
1022 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
1023 	* @param _supply Total supply of tokens.
1024     * @param _name Is the long name by which the token contract should be known
1025     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
1026     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
1027 	*/
1028     constructor(
1029         uint256 _supply,
1030         string _name,
1031         string _symbol,
1032         uint8 _decimals
1033     ) DetailedERC20(_name, _symbol, _decimals) public {
1034         require(_supply != 0);
1035         totalSupply_ = _supply;
1036         balances[msg.sender] = _supply;
1037         emit Transfer(address(0), msg.sender, _supply);  //event
1038     }
1039 }
1040 
1041 // File: @tokenfoundry/sale-contracts/contracts/Sale.sol
1042 
1043 /// @title Sale base contract
1044 contract Sale is SaleI, Ownable, Whitelistable, TimedStateMachine, TokenControllerI {
1045     using SafeMath for uint256;
1046     using SafeERC20 for Token;
1047 
1048     // State machine states
1049     bytes32 private constant SETUP = "setup";
1050     bytes32 private constant FREEZE = "freeze";
1051     bytes32 private constant SALE_IN_PROGRESS = "saleInProgress";
1052     bytes32 private constant SALE_ENDED = "saleEnded";
1053     // solium-disable-next-line arg-overflow
1054     bytes32[] public states = [SETUP, FREEZE, SALE_IN_PROGRESS, SALE_ENDED];
1055 
1056     // Stores the contribution for each user
1057     mapping(address => uint256) public unitContributions;
1058 
1059     // Records extra tokens were allocated
1060     mapping(address => bool) public extraTokensAllocated;
1061 
1062     DisbursementHandler public disbursementHandler;
1063 
1064     uint256 public totalContributedUnits = 0; // Units
1065     uint256 public totalSaleCapUnits; // Units
1066     uint256 public minContributionUnits; // Units
1067     uint256 public minThresholdUnits; // Units
1068 
1069     // How many tokens a user will receive per each unit contributed
1070     uint256 public saleTokensPerUnit;
1071     // Rate that will be used to calculate extra tokens if Sale is not sold out
1072     uint256 public extraTokensPerUnit;
1073     // Total amount of tokens that the sale will distribute to contributors
1074     uint256 public tokensForSale;
1075 
1076     Token public trustedToken;
1077     Vault public trustedVault;
1078     EthPriceFeedI public ethPriceFeed; 
1079 
1080     event Contribution(
1081         address indexed contributor,
1082         address indexed sender,
1083         uint256 valueUnit,
1084         uint256 valueWei,
1085         uint256 excessWei,
1086         uint256 weiPerUnitRate
1087     );
1088 
1089     event EthPriceFeedChanged(address previousEthPriceFeed, address newEthPriceFeed);
1090 
1091     event TokensAllocated(address indexed contributor, uint256 tokenAmount);
1092 
1093     constructor (
1094         uint256 _totalSaleCapUnits, // Units
1095         uint256 _minContributionUnits, // Units
1096         uint256 _minThresholdUnits, // Units
1097         uint256 _maxTokens,
1098         address _whitelistAdmin,
1099         address _wallet,
1100         uint256 _vaultInitialDisburseWei, // Wei
1101         uint256 _vaultDisbursementWei, // Wei
1102         uint256 _vaultDisbursementDuration,
1103         uint256 _startTime,
1104         string _tokenName,
1105         string _tokenSymbol,
1106         uint8 _tokenDecimals, 
1107         EthPriceFeedI _ethPriceFeed
1108     ) 
1109         Whitelistable(_whitelistAdmin)
1110         public 
1111     {
1112         require(_totalSaleCapUnits != 0);
1113         require(_maxTokens != 0);
1114         require(_wallet != 0);
1115         require(_minThresholdUnits <= _totalSaleCapUnits);
1116         require(_ethPriceFeed != address(0));
1117         require(now < _startTime);
1118 
1119         totalSaleCapUnits = _totalSaleCapUnits;
1120         minContributionUnits = _minContributionUnits;
1121         minThresholdUnits = _minThresholdUnits;
1122 
1123         // Setup the necessary contracts
1124         trustedToken = new Token(
1125             _maxTokens,
1126             _tokenName,
1127             _tokenSymbol,
1128             _tokenDecimals
1129         );
1130 
1131         disbursementHandler = new DisbursementHandler(trustedToken);
1132         
1133         ethPriceFeed = _ethPriceFeed; 
1134 
1135         // The token will query the isTransferAllowed function contained in this contract
1136         trustedToken.setController(this);
1137 
1138         trustedVault = new Vault(
1139             _wallet,
1140             _vaultInitialDisburseWei,
1141             _vaultDisbursementWei, // disbursement amount
1142             _vaultDisbursementDuration
1143         );
1144 
1145         // Set the states
1146         setStates(states);
1147 
1148         // Specify which functions are allowed in each state
1149         allowFunction(SETUP, this.setup.selector);
1150         allowFunction(FREEZE, this.setEndTime.selector);
1151         allowFunction(SALE_IN_PROGRESS, this.setEndTime.selector);
1152         allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
1153         allowFunction(SALE_IN_PROGRESS, this.endSale.selector);
1154         allowFunction(SALE_ENDED, this.allocateExtraTokens.selector);
1155 
1156         // End the sale when the cap is reached
1157         addStartCondition(SALE_ENDED, wasCapReached);
1158 
1159         // Set the start time for the sale
1160         setStateStartTime(SALE_IN_PROGRESS, _startTime);
1161 
1162         // Set the onSaleEnded callback (will be called when the sale ends)
1163         addCallback(SALE_ENDED, onSaleEnded);
1164 
1165     }
1166 
1167     /// @dev Setup the disbursements and the number of tokens for sale.
1168     /// @dev This needs to be outside the constructor because the token needs to query the sale for allowed transfers.
1169     function setup() external onlyOwner checkAllowed {
1170         trustedToken.safeTransfer(disbursementHandler, disbursementHandler.totalAmount());
1171 
1172         tokensForSale = trustedToken.balanceOf(this);     
1173         require(tokensForSale >= totalSaleCapUnits);
1174 
1175         // Set the worst rate of tokens per unit
1176         // If sale doesn't sell out, extra tokens will be disbursed after the sale ends.
1177         saleTokensPerUnit = tokensForSale.div(totalSaleCapUnits);
1178 
1179         // Go to freeze state
1180         goToNextState();
1181     }
1182 
1183     /// @dev To change the EthPriceFeed contract if needed 
1184     function changeEthPriceFeed(EthPriceFeedI _ethPriceFeed) external onlyOwner {
1185         require(_ethPriceFeed != address(0));
1186         emit EthPriceFeedChanged(ethPriceFeed, _ethPriceFeed);
1187         ethPriceFeed = _ethPriceFeed;
1188     }
1189 
1190     /// @dev Called by users to contribute ETH to the sale.
1191     function contribute(
1192         address _contributor,
1193         uint256 _contributionLimitUnits, 
1194         uint256 _payloadExpiration,
1195         bytes _sig
1196     ) 
1197         external 
1198         payable
1199         checkAllowed 
1200         isWhitelisted(keccak256(
1201             abi.encodePacked(
1202                 _contributor,
1203                 _contributionLimitUnits, 
1204                 _payloadExpiration
1205             )
1206         ), _sig)
1207     {
1208         require(msg.sender == _contributor);
1209         require(now < _payloadExpiration); 
1210 
1211         uint256 weiPerUnitRate = ethPriceFeed.getRate(); 
1212         require(weiPerUnitRate != 0);
1213 
1214         uint256 previouslyContributedUnits = unitContributions[_contributor];
1215 
1216         // Check that the contribution amount doesn't go over the sale cap or personal contributionLimitUnits 
1217         uint256 currentContributionUnits = min256(
1218             _contributionLimitUnits.sub(previouslyContributedUnits),
1219             totalSaleCapUnits.sub(totalContributedUnits),
1220             msg.value.div(weiPerUnitRate)
1221         );
1222 
1223         require(currentContributionUnits != 0);
1224 
1225         // Check that it is higher than minContributionUnits
1226         require(currentContributionUnits >= minContributionUnits || previouslyContributedUnits != 0);
1227 
1228         // Update the state
1229         unitContributions[_contributor] = previouslyContributedUnits.add(currentContributionUnits);
1230         totalContributedUnits = totalContributedUnits.add(currentContributionUnits);
1231 
1232         uint256 currentContributionWei = currentContributionUnits.mul(weiPerUnitRate);
1233         trustedVault.deposit.value(currentContributionWei)(msg.sender);
1234 
1235         // If the minThresholdUnits is reached for the first time, notify the vault
1236         if (totalContributedUnits >= minThresholdUnits &&
1237             trustedVault.state() != Vault.State.Success) {
1238             trustedVault.saleSuccessful();
1239         }
1240 
1241         // If there is an excess, return it to the sender
1242         uint256 excessWei = msg.value.sub(currentContributionWei);
1243         if (excessWei > 0) {
1244             msg.sender.transfer(excessWei);
1245         }
1246 
1247         emit Contribution(
1248             _contributor, 
1249             msg.sender,
1250             currentContributionUnits, 
1251             currentContributionWei, 
1252             excessWei,
1253             weiPerUnitRate
1254         );
1255 
1256         // Allocate tokens     
1257         uint256 tokenAmount = currentContributionUnits.mul(saleTokensPerUnit);
1258         trustedToken.safeTransfer(_contributor, tokenAmount);
1259         emit TokensAllocated(_contributor, tokenAmount);
1260     }
1261 
1262     /// @dev Called to allocate the tokens depending on amount contributed by the end of the sale.
1263     /// @param _contributor The address of the contributor.
1264     function allocateExtraTokens(address _contributor)
1265         external 
1266         checkAllowed
1267     {    
1268         require(!extraTokensAllocated[_contributor]);
1269         require(unitContributions[_contributor] != 0);
1270         // Allocate extra tokens only if total sale cap is not reached
1271         require(totalContributedUnits < totalSaleCapUnits);
1272 
1273         // Transfer the respective tokens to the contributor
1274         extraTokensAllocated[_contributor] = true;
1275         uint256 tokenAmount = unitContributions[_contributor].mul(extraTokensPerUnit);
1276         trustedToken.safeTransfer(_contributor, tokenAmount);
1277 
1278         emit TokensAllocated(_contributor, tokenAmount);
1279     }
1280 
1281     /// @dev Sets the end time for the sale
1282     /// @param _endTime The timestamp at which the sale will end.
1283     function setEndTime(uint256 _endTime) external onlyOwner checkAllowed {
1284         require(now < _endTime);
1285         require(getStateStartTime(SALE_ENDED) == 0);
1286         setStateStartTime(SALE_ENDED, _endTime);
1287     }
1288 
1289     /// @dev Called to enable refunds by the owner. Can only be called in any state (without triggering conditional transitions)
1290     /// @dev This is only meant to be used if there is an emergency and the endSale() function can't be called
1291     function enableRefunds() external onlyOwner {
1292         trustedVault.enableRefunds();
1293     }
1294 
1295     /// @dev Called to end the sale by the owner. Can only be called in SALE_IN_PROGRESS state
1296     function endSale() external onlyOwner checkAllowed {
1297         goToNextState();
1298     }
1299 
1300     /// @dev Since Sale is TokenControllerI, it has to implement transferAllowed() function
1301     /// @notice only the Sale and DisbursementHandler can disburse the initial tokens to their future owners
1302     function transferAllowed(address _from, address)
1303         external
1304         view
1305         returns (bool)
1306     {
1307         return _from == address(this) || _from == address(disbursementHandler);
1308     }
1309 
1310     /// @dev Called internally by the sale to setup a disbursement (it has to be called in the constructor of child sales)
1311     /// param _beneficiary Tokens will be disbursed to this address.
1312     /// param _tokenAmount Number of tokens to be disbursed.
1313     /// param _duration Tokens will be locked for this long.
1314     function setupDisbursement(
1315         address _beneficiary,
1316         uint256 _tokenAmount,
1317         uint256 _duration
1318     )
1319         internal 
1320     {
1321         require(tokensForSale == 0);
1322         disbursementHandler.setupDisbursement(
1323             _beneficiary,
1324             _tokenAmount,
1325             now.add(_duration)
1326         );
1327     }
1328    
1329     /// @dev Returns true if the cap was reached.
1330     function wasCapReached(bytes32) internal returns (bool) {
1331         return totalSaleCapUnits <= totalContributedUnits;
1332     }
1333 
1334     /// @dev Callback that gets called when entering the SALE_ENDED state.
1335     function onSaleEnded() internal {
1336 
1337         trustedToken.transferOwnership(owner); 
1338 
1339         if (totalContributedUnits == 0) {
1340 
1341             // If no tokens were sold, transfer them back to the project team
1342             trustedToken.safeTransfer(trustedVault.trustedWallet(), tokensForSale);
1343 
1344         } else if (totalContributedUnits < minThresholdUnits) {
1345 
1346             // If the minimum threshold wasn't reached, enable refunds
1347             trustedVault.enableRefunds();
1348 
1349         } else {
1350 
1351             // Calculate the rate for the extra tokens (if the sale was sold out, it will be 0)
1352             extraTokensPerUnit = tokensForSale.div(totalContributedUnits).sub(saleTokensPerUnit);
1353 
1354             // Close the vault and transfer ownership to the owner of the sale
1355             trustedVault.close();
1356             trustedVault.transferOwnership(owner);
1357 
1358         }
1359     }
1360 
1361     /// @dev a function to return the minimum of 3 values
1362     function min256(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
1363         return Math.min256(x, Math.min256(y, z));
1364     }
1365 
1366 }
1367 
1368 // File: contracts/FoamSale.sol
1369 
1370 contract FoamSale is Sale {
1371 
1372     address private constant FOAM_WALLET = 0x3061CFBAe69Bff0f933353cea20de6C89Ab16acc;
1373 
1374     constructor() 
1375         Sale(
1376             24000000, // Total sale cap (usd)
1377             90, // Min contribution (usd)
1378             1, // Min threshold (usd)
1379             1000000000 * (10 ** 18), // Max tokens
1380             0x8dAB5379f7979df2Fac963c69B66a25AcdaADbB7, // Whitelist Admin
1381             FOAM_WALLET, // Wallet
1382             1 ether, // Vault initial Wei
1383             25000 ether, // Vault disbursement Wei
1384             0, // Vault disbursement duration (0 means transfer everything right away)
1385             1532803878, // Start time
1386             "FOAM Token", // Token name
1387             "FOAM", // Token symbol
1388             18, // Token decimals
1389             EthPriceFeedI(0x54bF24e1070784D7F0760095932b47CE55eb3A91) // Eth price feed
1390         )
1391         public 
1392     {
1393         // Team Wallet
1394         setupDisbursement(FOAM_WALLET, 700000000 * (10 ** 18), 1 hours);
1395     }
1396 }