1 pragma solidity 0.4.24;
2 
3 // File: @tokenfoundry/sale-contracts/contracts/interfaces/VaultI.sol
4 
5 interface VaultI {
6     function deposit(address contributor) external payable;
7     function saleSuccessful() external;
8     function enableRefunds() external;
9     function refund(address contributor) external;
10     function close() external;
11     function sendFundsToWallet() external;
12 }
13 
14 // File: openzeppelin-solidity/contracts/math/Math.sol
15 
16 /**
17  * @title Math
18  * @dev Assorted math operations
19  */
20 library Math {
21   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
22     return a >= b ? a : b;
23   }
24 
25   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
26     return a < b ? a : b;
27   }
28 
29   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
30     return a >= b ? a : b;
31   }
32 
33   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
34     return a < b ? a : b;
35   }
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    */
127   function renounceOwnership() public onlyOwner {
128     emit OwnershipRenounced(owner);
129     owner = address(0);
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address _newOwner) public onlyOwner {
137     _transferOwnership(_newOwner);
138   }
139 
140   /**
141    * @dev Transfers control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function _transferOwnership(address _newOwner) internal {
145     require(_newOwner != address(0));
146     emit OwnershipTransferred(owner, _newOwner);
147     owner = _newOwner;
148   }
149 }
150 
151 // File: @tokenfoundry/sale-contracts/contracts/Vault.sol
152 
153 // Adapted from Open Zeppelin's RefundVault
154 
155 /**
156  * @title Vault
157  * @dev This contract is used for storing funds while a crowdsale
158  * is in progress. Supports refunding the money if crowdsale fails,
159  * and forwarding it if crowdsale is successful.
160  */
161 contract Vault is VaultI, Ownable {
162     using SafeMath for uint256;
163 
164     enum State { Active, Success, Refunding, Closed }
165 
166     // The timestamp of the first deposit
167     uint256 public firstDepositTimestamp; 
168 
169     mapping (address => uint256) public deposited;
170 
171     // The amount to be disbursed to the wallet every month
172     uint256 public disbursementWei;
173     uint256 public disbursementDuration;
174 
175     // Wallet from the project team
176     address public trustedWallet;
177 
178     // The eth amount the team will get initially if the sale is successful
179     uint256 public initialWei;
180 
181     // Timestamp that has to pass before sending funds to the wallet
182     uint256 public nextDisbursement;
183     
184     // Total amount that was deposited
185     uint256 public totalDeposited;
186 
187     // Amount that can be refunded
188     uint256 public refundable;
189 
190     State public state;
191 
192     event Closed();
193     event RefundsEnabled();
194     event Refunded(address indexed contributor, uint256 amount);
195 
196     modifier atState(State _state) {
197         require(state == _state, "This function cannot be called in the current vault state.");
198         _;
199     }
200 
201     constructor (
202         address _wallet,
203         uint256 _initialWei,
204         uint256 _disbursementWei,
205         uint256 _disbursementDuration
206     ) 
207         public 
208     {
209         require(_wallet != address(0), "Wallet address should not be 0.");
210         require(_disbursementWei != 0, "Disbursement Wei should be greater than 0.");
211         trustedWallet = _wallet;
212         initialWei = _initialWei;
213         disbursementWei = _disbursementWei;
214         disbursementDuration = _disbursementDuration;
215         state = State.Active;
216     }
217 
218     /// @dev Called by the sale contract to deposit ether for a contributor.
219     function deposit(address _contributor) onlyOwner external payable {
220         require(state == State.Active || state == State.Success , "Vault state must be Active or Success.");
221         if (firstDepositTimestamp == 0) {
222             firstDepositTimestamp = now;
223         }
224         totalDeposited = totalDeposited.add(msg.value);
225         deposited[_contributor] = deposited[_contributor].add(msg.value);
226     }
227 
228     /// @dev Sends initial funds to the wallet.
229     function saleSuccessful()
230         onlyOwner 
231         external 
232         atState(State.Active)
233     {
234         state = State.Success;
235         transferToWallet(initialWei);
236     }
237 
238     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
239     function enableRefunds() onlyOwner external {
240         require(state != State.Refunding, "Vault state is not Refunding");
241         state = State.Refunding;
242         uint256 currentBalance = address(this).balance;
243         refundable = currentBalance <= totalDeposited ? currentBalance : totalDeposited;
244         emit RefundsEnabled();
245     }
246 
247     /// @dev Refunds ether to the contributors if in the Refunding state.
248     function refund(address _contributor) external atState(State.Refunding) {
249         require(deposited[_contributor] > 0, "Refund not allowed if contributor deposit is 0.");
250         uint256 refundAmount = deposited[_contributor].mul(refundable).div(totalDeposited);
251         deposited[_contributor] = 0;
252         _contributor.transfer(refundAmount);
253         emit Refunded(_contributor, refundAmount);
254     }
255 
256     /// @dev Called by the owner if the sale has ended.
257     function close() external atState(State.Success) onlyOwner {
258         state = State.Closed;
259         nextDisbursement = now;
260         emit Closed();
261     }
262 
263     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
264     function sendFundsToWallet() external atState(State.Closed) {
265         require(firstDepositTimestamp.add(4 weeks) <= now, "First contributor\ń0027s deposit was less than 28 days ago");
266         require(nextDisbursement <= now, "Next disbursement period timestamp has not yet passed, too early to withdraw.");
267 
268         if (disbursementDuration == 0) {
269             trustedWallet.transfer(address(this).balance);
270             return;
271         }
272 
273         uint256 numberOfDisbursements = now.sub(nextDisbursement).div(disbursementDuration).add(1);
274 
275         nextDisbursement = nextDisbursement.add(disbursementDuration.mul(numberOfDisbursements));
276 
277         transferToWallet(disbursementWei.mul(numberOfDisbursements));
278     }
279 
280     function transferToWallet(uint256 _amount) internal {
281         uint256 amountToSend = Math.min256(_amount, address(this).balance);
282         trustedWallet.transfer(amountToSend);
283     }
284 }
285 
286 // File: @tokenfoundry/sale-contracts/contracts/interfaces/WhitelistableI.sol
287 
288 interface WhitelistableI {
289     function changeAdmin(address _admin) external;
290     function invalidateHash(bytes32 _hash) external;
291     function invalidateHashes(bytes32[] _hashes) external;
292 }
293 
294 // File: openzeppelin-solidity/contracts/ECRecovery.sol
295 
296 /**
297  * @title Eliptic curve signature operations
298  *
299  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
300  *
301  * TODO Remove this library once solidity supports passing a signature to ecrecover.
302  * See https://github.com/ethereum/solidity/issues/864
303  *
304  */
305 
306 library ECRecovery {
307 
308   /**
309    * @dev Recover signer address from a message by using their signature
310    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
311    * @param sig bytes signature, the signature is generated using web3.eth.sign()
312    */
313   function recover(bytes32 hash, bytes sig)
314     internal
315     pure
316     returns (address)
317   {
318     bytes32 r;
319     bytes32 s;
320     uint8 v;
321 
322     // Check the signature length
323     if (sig.length != 65) {
324       return (address(0));
325     }
326 
327     // Divide the signature in r, s and v variables
328     // ecrecover takes the signature parameters, and the only way to get them
329     // currently is to use assembly.
330     // solium-disable-next-line security/no-inline-assembly
331     assembly {
332       r := mload(add(sig, 32))
333       s := mload(add(sig, 64))
334       v := byte(0, mload(add(sig, 96)))
335     }
336 
337     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
338     if (v < 27) {
339       v += 27;
340     }
341 
342     // If the version is correct return the signer address
343     if (v != 27 && v != 28) {
344       return (address(0));
345     } else {
346       // solium-disable-next-line arg-overflow
347       return ecrecover(hash, v, r, s);
348     }
349   }
350 
351   /**
352    * toEthSignedMessageHash
353    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
354    * @dev and hash the result
355    */
356   function toEthSignedMessageHash(bytes32 hash)
357     internal
358     pure
359     returns (bytes32)
360   {
361     // 32 is the length in bytes of hash,
362     // enforced by the type signature above
363     return keccak256(
364       "\x19Ethereum Signed Message:\n32",
365       hash
366     );
367   }
368 }
369 
370 // File: @tokenfoundry/sale-contracts/contracts/Whitelistable.sol
371 
372 /**
373  * @title Whitelistable
374  * @dev This contract is used to implement a signature based whitelisting mechanism
375  */
376 contract Whitelistable is WhitelistableI, Ownable {
377     using ECRecovery for bytes32;
378 
379     address public whitelistAdmin;
380 
381     // True if the hash has been invalidated
382     mapping(bytes32 => bool) public invalidHash;
383 
384     event AdminUpdated(address indexed newAdmin);
385 
386     modifier validAdmin(address _admin) {
387         require(_admin != 0, "Admin address cannot be 0");
388         _;
389     }
390 
391     modifier onlyAdmin {
392         require(msg.sender == whitelistAdmin, "Only the whitelist admin may call this function");
393         _;
394     }
395 
396     modifier isWhitelisted(bytes32 _hash, bytes _sig) {
397         require(checkWhitelisted(_hash, _sig), "The provided hash is not whitelisted");
398         _;
399     }
400 
401     /// @dev Constructor for Whitelistable contract
402     /// @param _admin the address of the admin that will generate the signatures
403     constructor(address _admin) public validAdmin(_admin) {
404         whitelistAdmin = _admin;        
405     }
406 
407     /// @dev Updates whitelistAdmin address 
408     /// @dev Can only be called by the current owner
409     /// @param _admin the new admin address
410     function changeAdmin(address _admin)
411         external
412         onlyOwner
413         validAdmin(_admin)
414     {
415         emit AdminUpdated(_admin);
416         whitelistAdmin = _admin;
417     }
418 
419     // @dev blacklists the given address to ban them from contributing
420     // @param _contributor Address of the contributor to blacklist 
421     function invalidateHash(bytes32 _hash) external onlyAdmin {
422         invalidHash[_hash] = true;
423     }
424 
425     function invalidateHashes(bytes32[] _hashes) external onlyAdmin {
426         for (uint i = 0; i < _hashes.length; i++) {
427             invalidHash[_hashes[i]] = true;
428         }
429     }
430 
431     /// @dev Checks if a hash has been signed by the whitelistAdmin
432     /// @param _rawHash The hash that was used to generate the signature
433     /// @param _sig The EC signature generated by the whitelistAdmin
434     /// @return Was the signature generated by the admin for the hash?
435     function checkWhitelisted(
436         bytes32 _rawHash,
437         bytes _sig
438     )
439         public
440         view
441         returns(bool)
442     {
443         bytes32 hash = _rawHash.toEthSignedMessageHash();
444         return !invalidHash[_rawHash] && whitelistAdmin == hash.recover(_sig);
445     }
446 }
447 
448 // File: @tokenfoundry/sale-contracts/contracts/interfaces/EthPriceFeedI.sol
449 
450 interface EthPriceFeedI {
451     function getUnit() external view returns(string);
452     function getRate() external view returns(uint256);
453     function getLastTimeUpdated() external view returns(uint256); 
454 }
455 
456 // File: @tokenfoundry/state-machine/contracts/StateMachine.sol
457 
458 contract StateMachine {
459 
460     struct State { 
461         bytes32 nextStateId;
462         mapping(bytes4 => bool) allowedFunctions;
463         function() internal[] transitionCallbacks;
464         function(bytes32) internal returns(bool)[] startConditions;
465     }
466 
467     mapping(bytes32 => State) states;
468 
469     // The current state id
470     bytes32 private currentStateId;
471 
472     event Transition(bytes32 stateId, uint256 blockNumber);
473 
474     /* This modifier performs the conditional transitions and checks that the function 
475      * to be executed is allowed in the current State
476      */
477     modifier checkAllowed {
478         conditionalTransitions();
479         require(states[currentStateId].allowedFunctions[msg.sig]);
480         _;
481     }
482 
483     ///@dev transitions the state machine into the state it should currently be in
484     ///@dev by taking into account the current conditions and how many further transitions can occur 
485     function conditionalTransitions() public {
486         bool checkNextState; 
487         do {
488             checkNextState = false;
489 
490             bytes32 next = states[currentStateId].nextStateId;
491             // If one of the next state's conditions is met, go to this state and continue
492 
493             for (uint256 i = 0; i < states[next].startConditions.length; i++) {
494                 if (states[next].startConditions[i](next)) {
495                     goToNextState();
496                     checkNextState = true;
497                     break;
498                 }
499             } 
500         } while (checkNextState);
501     }
502 
503     function getCurrentStateId() view public returns(bytes32) {
504         return currentStateId;
505     }
506 
507     /// @dev Setup the state machine with the given states.
508     /// @param _stateIds Array of state ids.
509     function setStates(bytes32[] _stateIds) internal {
510         require(_stateIds.length > 0);
511         require(currentStateId == 0);
512 
513         require(_stateIds[0] != 0);
514 
515         currentStateId = _stateIds[0];
516 
517         for (uint256 i = 1; i < _stateIds.length; i++) {
518             require(_stateIds[i] != 0);
519 
520             states[_stateIds[i - 1]].nextStateId = _stateIds[i];
521 
522             // Check that the state appears only once in the array
523             require(states[_stateIds[i]].nextStateId == 0);
524         }
525     }
526 
527     /// @dev Allow a function in the given state.
528     /// @param _stateId The id of the state
529     /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
530     function allowFunction(bytes32 _stateId, bytes4 _functionSelector) 
531         internal 
532     {
533         states[_stateId].allowedFunctions[_functionSelector] = true;
534     }
535 
536     /// @dev Goes to the next state if possible (if the next state is valid)
537     function goToNextState() internal {
538         bytes32 next = states[currentStateId].nextStateId;
539         require(next != 0);
540 
541         currentStateId = next;
542         for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
543             states[next].transitionCallbacks[i]();
544         }
545 
546         emit Transition(next, block.number);
547     }
548 
549     ///@dev Add a function returning a boolean as a start condition for a state. 
550     /// If any condition returns true, the StateMachine will transition to the next state.
551     /// If s.startConditions is empty, the StateMachine will need to enter state s through invoking
552     /// the goToNextState() function. 
553     /// A start condition should never throw. (Otherwise, the StateMachine may fail to enter into the
554     /// correct state, and succeeding start conditions may return true.)
555     /// A start condition should be gas-inexpensive since every one of them is invoked in the same call to 
556     /// transition the state. 
557     ///@param _stateId The ID of the state to add the condition for
558     ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
559     function addStartCondition(
560         bytes32 _stateId,
561         function(bytes32) internal returns(bool) _condition
562     ) 
563         internal 
564     {
565         states[_stateId].startConditions.push(_condition);
566     }
567 
568     ///@dev Add a callback function for a state. All callbacks are invoked immediately after entering the state. 
569     /// Callback functions should never throw. (Otherwise, the StateMachine may fail to enter a state.)
570     /// Callback functions should also be gas-inexpensive as all callbacks are invoked in the same call to enter the state.
571     ///@param _stateId The ID of the state to add a callback function for
572     ///@param _callback The callback function to add
573     function addCallback(bytes32 _stateId, function() internal _callback)
574         internal 
575     {
576         states[_stateId].transitionCallbacks.push(_callback);
577     }
578 }
579 
580 // File: @tokenfoundry/state-machine/contracts/TimedStateMachine.sol
581 
582 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
583 contract TimedStateMachine is StateMachine {
584 
585     event StateStartTimeSet(bytes32 indexed _stateId, uint256 _startTime);
586 
587     // Stores the start timestamp for each state (the value is 0 if the state doesn't have a start timestamp).
588     mapping(bytes32 => uint256) private startTime;
589 
590     /// @dev Returns the timestamp for the given state id.
591     /// @param _stateId The id of the state for which we want to set the start timestamp.
592     function getStateStartTime(bytes32 _stateId) public view returns(uint256) {
593         return startTime[_stateId];
594     }
595 
596     /// @dev Sets the starting timestamp for a state as a startCondition. If other start conditions exist and are 
597     /// met earlier, then the state may be entered into earlier than the specified start time. 
598     /// @param _stateId The id of the state for which we want to set the start timestamp.
599     /// @param _timestamp The start timestamp for the given state. It should be bigger than the current one.
600     function setStateStartTime(bytes32 _stateId, uint256 _timestamp) internal {
601         require(block.timestamp < _timestamp);
602 
603         if (startTime[_stateId] == 0) {
604             addStartCondition(_stateId, hasStartTimePassed);
605         }
606 
607         startTime[_stateId] = _timestamp;
608 
609         emit StateStartTimeSet(_stateId, _timestamp);
610     }
611 
612     function hasStartTimePassed(bytes32 _stateId) internal returns(bool) {
613         return startTime[_stateId] <= block.timestamp;
614     }
615 
616 }
617 
618 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
619 
620 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
621 contract TokenControllerI {
622 
623     /// @dev Specifies whether a transfer is allowed or not.
624     /// @return True if the transfer is allowed
625     function transferAllowed(address _from, address _to)
626         external
627         view 
628         returns (bool);
629 }
630 
631 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
632 
633 /**
634  * @title ERC20Basic
635  * @dev Simpler version of ERC20 interface
636  * @dev see https://github.com/ethereum/EIPs/issues/179
637  */
638 contract ERC20Basic {
639   function totalSupply() public view returns (uint256);
640   function balanceOf(address who) public view returns (uint256);
641   function transfer(address to, uint256 value) public returns (bool);
642   event Transfer(address indexed from, address indexed to, uint256 value);
643 }
644 
645 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
646 
647 /**
648  * @title Basic token
649  * @dev Basic version of StandardToken, with no allowances.
650  */
651 contract BasicToken is ERC20Basic {
652   using SafeMath for uint256;
653 
654   mapping(address => uint256) balances;
655 
656   uint256 totalSupply_;
657 
658   /**
659   * @dev total number of tokens in existence
660   */
661   function totalSupply() public view returns (uint256) {
662     return totalSupply_;
663   }
664 
665   /**
666   * @dev transfer token for a specified address
667   * @param _to The address to transfer to.
668   * @param _value The amount to be transferred.
669   */
670   function transfer(address _to, uint256 _value) public returns (bool) {
671     require(_to != address(0));
672     require(_value <= balances[msg.sender]);
673 
674     balances[msg.sender] = balances[msg.sender].sub(_value);
675     balances[_to] = balances[_to].add(_value);
676     emit Transfer(msg.sender, _to, _value);
677     return true;
678   }
679 
680   /**
681   * @dev Gets the balance of the specified address.
682   * @param _owner The address to query the the balance of.
683   * @return An uint256 representing the amount owned by the passed address.
684   */
685   function balanceOf(address _owner) public view returns (uint256) {
686     return balances[_owner];
687   }
688 
689 }
690 
691 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
692 
693 /**
694  * @title ERC20 interface
695  * @dev see https://github.com/ethereum/EIPs/issues/20
696  */
697 contract ERC20 is ERC20Basic {
698   function allowance(address owner, address spender)
699     public view returns (uint256);
700 
701   function transferFrom(address from, address to, uint256 value)
702     public returns (bool);
703 
704   function approve(address spender, uint256 value) public returns (bool);
705   event Approval(
706     address indexed owner,
707     address indexed spender,
708     uint256 value
709   );
710 }
711 
712 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
713 
714 /**
715  * @title Standard ERC20 token
716  *
717  * @dev Implementation of the basic standard token.
718  * @dev https://github.com/ethereum/EIPs/issues/20
719  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
720  */
721 contract StandardToken is ERC20, BasicToken {
722 
723   mapping (address => mapping (address => uint256)) internal allowed;
724 
725 
726   /**
727    * @dev Transfer tokens from one address to another
728    * @param _from address The address which you want to send tokens from
729    * @param _to address The address which you want to transfer to
730    * @param _value uint256 the amount of tokens to be transferred
731    */
732   function transferFrom(
733     address _from,
734     address _to,
735     uint256 _value
736   )
737     public
738     returns (bool)
739   {
740     require(_to != address(0));
741     require(_value <= balances[_from]);
742     require(_value <= allowed[_from][msg.sender]);
743 
744     balances[_from] = balances[_from].sub(_value);
745     balances[_to] = balances[_to].add(_value);
746     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
747     emit Transfer(_from, _to, _value);
748     return true;
749   }
750 
751   /**
752    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
753    *
754    * Beware that changing an allowance with this method brings the risk that someone may use both the old
755    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
756    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
757    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
758    * @param _spender The address which will spend the funds.
759    * @param _value The amount of tokens to be spent.
760    */
761   function approve(address _spender, uint256 _value) public returns (bool) {
762     allowed[msg.sender][_spender] = _value;
763     emit Approval(msg.sender, _spender, _value);
764     return true;
765   }
766 
767   /**
768    * @dev Function to check the amount of tokens that an owner allowed to a spender.
769    * @param _owner address The address which owns the funds.
770    * @param _spender address The address which will spend the funds.
771    * @return A uint256 specifying the amount of tokens still available for the spender.
772    */
773   function allowance(
774     address _owner,
775     address _spender
776    )
777     public
778     view
779     returns (uint256)
780   {
781     return allowed[_owner][_spender];
782   }
783 
784   /**
785    * @dev Increase the amount of tokens that an owner allowed to a spender.
786    *
787    * approve should be called when allowed[_spender] == 0. To increment
788    * allowed value is better to use this function to avoid 2 calls (and wait until
789    * the first transaction is mined)
790    * From MonolithDAO Token.sol
791    * @param _spender The address which will spend the funds.
792    * @param _addedValue The amount of tokens to increase the allowance by.
793    */
794   function increaseApproval(
795     address _spender,
796     uint _addedValue
797   )
798     public
799     returns (bool)
800   {
801     allowed[msg.sender][_spender] = (
802       allowed[msg.sender][_spender].add(_addedValue));
803     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
804     return true;
805   }
806 
807   /**
808    * @dev Decrease the amount of tokens that an owner allowed to a spender.
809    *
810    * approve should be called when allowed[_spender] == 0. To decrement
811    * allowed value is better to use this function to avoid 2 calls (and wait until
812    * the first transaction is mined)
813    * From MonolithDAO Token.sol
814    * @param _spender The address which will spend the funds.
815    * @param _subtractedValue The amount of tokens to decrease the allowance by.
816    */
817   function decreaseApproval(
818     address _spender,
819     uint _subtractedValue
820   )
821     public
822     returns (bool)
823   {
824     uint oldValue = allowed[msg.sender][_spender];
825     if (_subtractedValue > oldValue) {
826       allowed[msg.sender][_spender] = 0;
827     } else {
828       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
829     }
830     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
831     return true;
832   }
833 
834 }
835 
836 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
837 
838 /**
839  * @title Controllable ERC20 token
840  *
841  * @dev Token that queries a token controller contract to check if a transfer is allowed.
842  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
843  * implemented transferAllowed() function.
844  */
845 contract ControllableToken is Ownable, StandardToken {
846     TokenControllerI public controller;
847 
848     /// @dev Executes transferAllowed() function from the Controller. 
849     modifier isAllowed(address _from, address _to) {
850         require(controller.transferAllowed(_from, _to), "Token Controller does not permit transfer.");
851         _;
852     }
853 
854     /// @dev Sets the controller that is going to be used by isAllowed modifier
855     function setController(TokenControllerI _controller) onlyOwner public {
856         require(_controller != address(0), "Controller address should not be zero.");
857         controller = _controller;
858     }
859 
860     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
861     /// @return True if the token is transfered with success
862     function transfer(address _to, uint256 _value) 
863         isAllowed(msg.sender, _to)
864         public
865         returns (bool)
866     {
867         return super.transfer(_to, _value);
868     }
869 
870     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
871     /// @return True if the token is transfered with success 
872     function transferFrom(address _from, address _to, uint256 _value)
873         isAllowed(_from, _to) 
874         public 
875         returns (bool)
876     {
877         return super.transferFrom(_from, _to, _value);
878     }
879 }
880 
881 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
882 
883 /**
884  * @title DetailedERC20 token
885  * @dev The decimals are only for visualization purposes.
886  * All the operations are done using the smallest and indivisible token unit,
887  * just as on Ethereum all the operations are done in wei.
888  */
889 contract DetailedERC20 is ERC20 {
890   string public name;
891   string public symbol;
892   uint8 public decimals;
893 
894   constructor(string _name, string _symbol, uint8 _decimals) public {
895     name = _name;
896     symbol = _symbol;
897     decimals = _decimals;
898   }
899 }
900 
901 // File: @tokenfoundry/token-contracts/contracts/Token.sol
902 
903 /**
904  * @title Token base contract - Defines basic structure for a token
905  *
906  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
907  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
908  */
909 contract Token is ControllableToken, DetailedERC20 {
910 
911 	/**
912 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
913 	* @param _supply Total supply of tokens.
914     * @param _name Is the long name by which the token contract should be known
915     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
916     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
917 	*/
918     constructor(
919         uint256 _supply,
920         string _name,
921         string _symbol,
922         uint8 _decimals
923     ) DetailedERC20(_name, _symbol, _decimals) public {
924         require(_supply != 0, "Supply should be greater than 0.");
925         totalSupply_ = _supply;
926         balances[msg.sender] = _supply;
927         emit Transfer(address(0), msg.sender, _supply);  //event
928     }
929 }
930 
931 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
932 
933 /**
934  * @title SafeERC20
935  * @dev Wrappers around ERC20 operations that throw on failure.
936  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
937  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
938  */
939 library SafeERC20 {
940   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
941     require(token.transfer(to, value));
942   }
943 
944   function safeTransferFrom(
945     ERC20 token,
946     address from,
947     address to,
948     uint256 value
949   )
950     internal
951   {
952     require(token.transferFrom(from, to, value));
953   }
954 
955   function safeApprove(ERC20 token, address spender, uint256 value) internal {
956     require(token.approve(spender, value));
957   }
958 }
959 
960 // File: contracts/Sale.sol
961 
962 /// @title Sale base contract
963 contract Sale is Ownable, Whitelistable, TimedStateMachine, TokenControllerI {
964     using SafeMath for uint256;
965     using SafeERC20 for Token;
966 
967     // State machine states
968     bytes32 private constant SETUP = "setup";
969     bytes32 private constant FREEZE = "freeze";
970     bytes32 private constant SALE_IN_PROGRESS = "saleInProgress";
971     bytes32 private constant SALE_ENDED = "saleEnded";
972     // solium-disable-next-line arg-overflow
973     bytes32[] public states = [SETUP, FREEZE, SALE_IN_PROGRESS, SALE_ENDED];
974 
975     // Stores the contribution for each user
976     mapping(address => uint256) public unitContributions;
977 
978     uint256 public totalContributedUnits = 0; // Units
979     uint256 public totalSaleCapUnits; // Units
980     uint256 public minContributionUnits; // Units
981     uint256 public minThresholdUnits; // Units
982 
983     Token public trustedToken;
984     Vault public trustedVault;
985     EthPriceFeedI public ethPriceFeed; 
986 
987     event Contribution(
988         address indexed contributor,
989         address indexed sender,
990         uint256 valueUnit,
991         uint256 valueWei,
992         uint256 excessWei,
993         uint256 weiPerUnitRate
994     );
995 
996     event EthPriceFeedChanged(address previousEthPriceFeed, address newEthPriceFeed);
997 
998     constructor (
999         uint256 _totalSaleCapUnits, // Units
1000         uint256 _minContributionUnits, // Units
1001         uint256 _minThresholdUnits, // Units
1002         uint256 _maxTokens,
1003         address _whitelistAdmin,
1004         address _wallet,
1005         uint256 _vaultInitialDisburseWei, // Wei
1006         uint256 _vaultDisbursementWei, // Wei
1007         uint256 _vaultDisbursementDuration,
1008         uint256 _startTime,
1009         string _tokenName,
1010         string _tokenSymbol,
1011         uint8 _tokenDecimals, 
1012         EthPriceFeedI _ethPriceFeed
1013     ) 
1014         Whitelistable(_whitelistAdmin)
1015         public 
1016     {
1017         require(_totalSaleCapUnits != 0, "Total sale cap units must be > 0");
1018         require(_maxTokens != 0, "The maximum number of tokens must be > 0");
1019         require(_wallet != 0, "The team's wallet address cannot be 0");
1020         require(_minThresholdUnits <= _totalSaleCapUnits, "The minimum threshold (units) cannot be larger than the sale cap (units)");
1021         require(_ethPriceFeed != address(0), "The ETH price feed cannot be the 0 address");
1022         require(now < _startTime, "The start time must be in the future");
1023 
1024         totalSaleCapUnits = _totalSaleCapUnits;
1025         minContributionUnits = _minContributionUnits;
1026         minThresholdUnits = _minThresholdUnits;
1027 
1028         // Setup the necessary contracts
1029         trustedToken = new Token(
1030             _maxTokens,
1031             _tokenName,
1032             _tokenSymbol,
1033             _tokenDecimals
1034         );
1035 
1036         ethPriceFeed = _ethPriceFeed; 
1037 
1038         // The token will query the isTransferAllowed function contained in this contract
1039         trustedToken.setController(this);
1040 
1041         trustedToken.transferOwnership(owner); 
1042 
1043         trustedVault = new Vault(
1044             _wallet,
1045             _vaultInitialDisburseWei,
1046             _vaultDisbursementWei, // disbursement amount
1047             _vaultDisbursementDuration
1048         );
1049 
1050         // Set the states
1051         setStates(states);
1052 
1053         // Specify which functions are allowed in each state
1054         allowFunction(SETUP, this.setup.selector);
1055         allowFunction(FREEZE, this.setEndTime.selector);
1056         allowFunction(SALE_IN_PROGRESS, this.setEndTime.selector);
1057         allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
1058         allowFunction(SALE_IN_PROGRESS, this.endSale.selector);
1059 
1060         // End the sale when the cap is reached
1061         addStartCondition(SALE_ENDED, wasCapReached);
1062 
1063         // Set the start time for the sale
1064         setStateStartTime(SALE_IN_PROGRESS, _startTime);
1065 
1066         // Set the onSaleEnded callback (will be called when the sale ends)
1067         addCallback(SALE_ENDED, onSaleEnded);
1068 
1069     }
1070 
1071     /// @dev Send tokens to the multisig for future distribution.
1072     /// @dev This needs to be outside the constructor because the token needs to query the sale for allowed transfers.
1073     function setup() external onlyOwner checkAllowed {
1074         trustedToken.safeTransfer(trustedVault.trustedWallet(), trustedToken.balanceOf(this));
1075 
1076         // Go to freeze state
1077         goToNextState();
1078     }
1079 
1080     /// @dev To change the EthPriceFeed contract if needed 
1081     function changeEthPriceFeed(EthPriceFeedI _ethPriceFeed) external onlyOwner {
1082         require(_ethPriceFeed != address(0), "ETH price feed address cannot be 0");
1083         emit EthPriceFeedChanged(ethPriceFeed, _ethPriceFeed);
1084         ethPriceFeed = _ethPriceFeed;
1085     }
1086 
1087     /// @dev Called by users to contribute ETH to the sale.
1088     function contribute(
1089         address _contributor,
1090         uint256 _contributionLimitUnits, 
1091         uint256 _payloadExpiration,
1092         bytes _sig
1093     ) 
1094         external 
1095         payable
1096         checkAllowed 
1097         isWhitelisted(keccak256(
1098             abi.encodePacked(
1099                 _contributor,
1100                 _contributionLimitUnits, 
1101                 _payloadExpiration
1102             )
1103         ), _sig)
1104     {
1105         require(msg.sender == _contributor, "Contributor address different from whitelisted address");
1106         require(now < _payloadExpiration, "Payload has expired"); 
1107 
1108         uint256 weiPerUnitRate = ethPriceFeed.getRate(); 
1109         require(weiPerUnitRate != 0, "Wei per unit rate from feed is 0");
1110 
1111         uint256 previouslyContributedUnits = unitContributions[_contributor];
1112 
1113         // Check that the contribution amount doesn't go over the sale cap or personal contributionLimitUnits 
1114         uint256 currentContributionUnits = min256(
1115             _contributionLimitUnits.sub(previouslyContributedUnits),
1116             totalSaleCapUnits.sub(totalContributedUnits),
1117             msg.value.div(weiPerUnitRate)
1118         );
1119 
1120         require(currentContributionUnits != 0, "No contribution permitted (contributor or sale has reached cap)");
1121 
1122         // Check that it is higher than minContributionUnits
1123         require(currentContributionUnits >= minContributionUnits || previouslyContributedUnits != 0, "Minimum contribution not reached");
1124 
1125         // Update the state
1126         unitContributions[_contributor] = previouslyContributedUnits.add(currentContributionUnits);
1127         totalContributedUnits = totalContributedUnits.add(currentContributionUnits);
1128 
1129         uint256 currentContributionWei = currentContributionUnits.mul(weiPerUnitRate);
1130         trustedVault.deposit.value(currentContributionWei)(msg.sender);
1131 
1132         // If the minThresholdUnits is reached for the first time, notify the vault
1133         if (totalContributedUnits >= minThresholdUnits &&
1134             trustedVault.state() != Vault.State.Success) {
1135             trustedVault.saleSuccessful();
1136         }
1137 
1138         // If there is an excess, return it to the sender
1139         uint256 excessWei = msg.value.sub(currentContributionWei);
1140         if (excessWei > 0) {
1141             msg.sender.transfer(excessWei);
1142         }
1143 
1144         emit Contribution(
1145             _contributor, 
1146             msg.sender,
1147             currentContributionUnits, 
1148             currentContributionWei, 
1149             excessWei,
1150             weiPerUnitRate
1151         );
1152     }
1153 
1154     /// @dev Sets the end time for the sale
1155     /// @param _endTime The timestamp at which the sale will end.
1156     function setEndTime(uint256 _endTime) external onlyOwner checkAllowed {
1157         require(now < _endTime, "Cannot set end time in the past");
1158         require(getStateStartTime(SALE_ENDED) == 0, "End time already set");
1159         setStateStartTime(SALE_ENDED, _endTime);
1160     }
1161 
1162     /// @dev Called to enable refunds by the owner. Can only be called in any state (without triggering conditional transitions)
1163     /// @dev This is only meant to be used if there is an emergency and the endSale() function can't be called
1164     function enableRefunds() external onlyOwner {
1165         trustedVault.enableRefunds();
1166     }
1167 
1168     /// @dev Called to end the sale by the owner. Can only be called in SALE_IN_PROGRESS state
1169     function endSale() external onlyOwner checkAllowed {
1170         goToNextState();
1171     }
1172 
1173     /// @dev Since Sale is TokenControllerI, it has to implement transferAllowed() function
1174     /// @notice only the Sale is allowed to send tokens
1175     function transferAllowed(address _from, address)
1176         external
1177         view
1178         returns (bool)
1179     {
1180         return _from == address(this);
1181     }
1182    
1183     /// @dev Returns true if the cap was reached.
1184     function wasCapReached(bytes32) internal returns (bool) {
1185         return totalSaleCapUnits <= totalContributedUnits;
1186     }
1187 
1188     /// @dev Callback that gets called when entering the SALE_ENDED state.
1189     function onSaleEnded() internal {
1190         // Close the vault and transfer ownership to the owner of the sale
1191         if (totalContributedUnits == 0 && minThresholdUnits == 0) {
1192             return;
1193         }
1194         
1195         if (totalContributedUnits < minThresholdUnits) {
1196             trustedVault.enableRefunds();
1197         } else {
1198             trustedVault.close();
1199         }
1200         trustedVault.transferOwnership(owner);
1201     }
1202 
1203     /// @dev a function to return the minimum of 3 values
1204     function min256(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {
1205         return Math.min256(x, Math.min256(y, z));
1206     }
1207 
1208 }
1209 
1210 // File: contracts/CivilSale.sol
1211 
1212 contract CivilSale is Sale {
1213 
1214     address public constant WALLET = 0xFe6eeE8911d866F3196d9cb003ee0Af50D1875C1;
1215 
1216     // Just to make it compatible with our services
1217     uint256 public saleTokensPerUnit = 36000000 * (10**18) / 24000000;
1218     uint256 public extraTokensPerUnit = 0;
1219 
1220     constructor() 
1221         Sale(
1222             24000000, // Total sale cap (usd)
1223             10, // Min contribution (usd)
1224             1, // Min threshold (usd)
1225             100000000 * (10 ** 18), // Max tokens
1226             0x8D6267Fe5404f8cB33782379543b2c8856ACF4A7, // Whitelist Admin
1227             WALLET, // Wallet
1228             0, // Vault initial Wei (Not using this value)
1229             1, // Vault disbursement Wei (Not using this value)
1230             0, // Vault disbursement duration (0 means transfer everything right away)
1231             now + 10 minutes, // Start time
1232             "Civil", // Token name
1233             "CVL", // Token symbol
1234             18, // Token decimals
1235             EthPriceFeedI(0x54bF24e1070784D7F0760095932b47CE55eb3A91) // Eth price feed
1236         )
1237         public 
1238     {
1239     }
1240 
1241     function transferAllowed(address _from, address)
1242         external
1243         view
1244         returns (bool)
1245     {
1246         return _from == WALLET || _from == address(this);
1247     }
1248 
1249 }