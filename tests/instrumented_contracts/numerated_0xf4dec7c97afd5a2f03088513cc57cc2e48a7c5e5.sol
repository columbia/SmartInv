1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: @tokenfoundry/sale-contracts/contracts/DisbursementHandler.sol
121 
122 /// @title Disbursement handler - Manages time locked disbursements of ERC20 tokens
123 contract DisbursementHandler is Ownable {
124     using SafeMath for uint256;
125 
126     struct Disbursement {
127         // Tokens cannot be withdrawn before this timestamp
128         uint256 timestamp;
129 
130         // Amount of tokens to be disbursed
131         uint256 tokens;
132     }
133 
134     event LogSetup(address indexed vestor, uint256 timestamp, uint256 tokens);
135     event LogWithdraw(address indexed to, uint256 value);
136 
137     ERC20 public token;
138     uint256 public totalAmount;
139     mapping(address => Disbursement[]) public disbursements;
140     mapping(address => uint256) public withdrawnTokens;
141 
142     function DisbursementHandler(address _token) public {
143         token = ERC20(_token);
144     }
145 
146     /// @dev Called by the sale contract to create a disbursement.
147     /// @param vestor The address of the beneficiary.
148     /// @param tokens Amount of tokens to be locked.
149     /// @param timestamp Funds will be locked until this timestamp.
150     function setupDisbursement(
151         address vestor,
152         uint256 tokens,
153         uint256 timestamp
154     )
155         external
156         onlyOwner
157     {
158         require(block.timestamp < timestamp);
159         disbursements[vestor].push(Disbursement(timestamp, tokens));
160         totalAmount = totalAmount.add(tokens);
161         LogSetup(vestor, timestamp, tokens);
162     }
163 
164     /// @dev Transfers tokens to the withdrawer
165     function withdraw()
166         external
167     {
168         uint256 withdrawAmount = calcMaxWithdraw(msg.sender);
169         require(withdrawAmount != 0);
170         withdrawnTokens[msg.sender] = withdrawnTokens[msg.sender].add(withdrawAmount);
171         require(token.transfer(msg.sender, withdrawAmount));
172         LogWithdraw(msg.sender, withdrawAmount);
173     }
174 
175     /// @dev Calculates the maximum amount of vested tokens
176     /// @return Number of vested tokens that can be withdrawn
177     function calcMaxWithdraw(address beneficiary)
178         public
179         view
180         returns (uint256)
181     {
182         uint256 maxTokens = 0;
183 
184         // Go over all the disbursements and calculate how many tokens can be withdrawn
185         Disbursement[] storage temp = disbursements[beneficiary];
186         uint256 tempLength = temp.length;
187         for (uint256 i = 0; i < tempLength; i++) {
188             if (block.timestamp > temp[i].timestamp) {
189                 maxTokens = maxTokens.add(temp[i].tokens);
190             }
191         }
192 
193         // Return the computed amount minus the tokens already withdrawn
194         return maxTokens.sub(withdrawnTokens[beneficiary]);
195     }
196 }
197 
198 // File: zeppelin-solidity/contracts/math/Math.sol
199 
200 /**
201  * @title Math
202  * @dev Assorted math operations
203  */
204 library Math {
205   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
206     return a >= b ? a : b;
207   }
208 
209   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
210     return a < b ? a : b;
211   }
212 
213   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
214     return a >= b ? a : b;
215   }
216 
217   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
218     return a < b ? a : b;
219   }
220 }
221 
222 // File: @tokenfoundry/sale-contracts/contracts/Vault.sol
223 
224 // Adapted from Open Zeppelin's RefundVault
225 
226 /**
227  * @title Vault
228  * @dev This contract is used for storing funds while a crowdsale
229  * is in progress. Supports refunding the money if crowdsale fails,
230  * and forwarding it if crowdsale is successful.
231  */
232 contract Vault is Ownable {
233     using SafeMath for uint256;
234 
235     enum State { Active, Success, Refunding, Closed }
236 
237     uint256 public constant DISBURSEMENT_DURATION = 4 weeks;
238 
239     mapping (address => uint256) public deposited;
240     uint256 public disbursementAmount; // The amount to be disbursed to the wallet every month
241     address public trustedWallet; // Wallet from the project team
242 
243     uint256 public initialAmount; // The eth amount the team will get initially if the sale is successful
244 
245     uint256 public lastDisbursement; // Timestamp of the last disbursement made
246 
247     uint256 public totalDeposited; // Total amount that was deposited
248     uint256 public refundable; // Amount that can be refunded
249 
250     uint256 public closingDuration;
251     uint256 public closingDeadline; // Vault can't be closed before this deadline
252 
253     State public state;
254 
255     event LogClosed();
256     event LogRefundsEnabled();
257     event LogRefunded(address indexed contributor, uint256 amount);
258 
259     modifier atState(State _state) {
260         require(state == _state);
261         _;
262     }
263 
264     function Vault(
265         address wallet,
266         uint256 _initialAmount,
267         uint256 _disbursementAmount,
268         uint256 _closingDuration
269     ) 
270         public 
271     {
272         require(wallet != address(0));
273         require(_disbursementAmount != 0);
274         require(_closingDuration != 0);
275         trustedWallet = wallet;
276         initialAmount = _initialAmount;
277         disbursementAmount = _disbursementAmount;
278         closingDuration = _closingDuration;
279         state = State.Active;
280     }
281 
282     /// @dev Called by the sale contract to deposit ether for a contributor.
283     function deposit(address contributor) onlyOwner external payable {
284         require(state == State.Active || state == State.Success);
285         totalDeposited = totalDeposited.add(msg.value);
286         refundable = refundable.add(msg.value);
287         deposited[contributor] = deposited[contributor].add(msg.value);
288     }
289 
290     /// @dev Sends initial funds to the wallet.
291     function saleSuccessful() onlyOwner external atState(State.Active){
292         state = State.Success;
293         refundable = refundable.sub(initialAmount);
294         if (initialAmount != 0) {
295           trustedWallet.transfer(initialAmount);
296         }
297     }
298 
299     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
300     function enableRefunds() onlyOwner external {
301         state = State.Refunding;
302         LogRefundsEnabled();
303     }
304 
305     /// @dev Refunds ether to the contributors if in the Refunding state.
306     function refund(address contributor) external atState(State.Refunding) {
307         uint256 refundAmount = deposited[contributor].mul(refundable).div(totalDeposited);
308         deposited[contributor] = 0;
309         contributor.transfer(refundAmount);
310         LogRefunded(contributor, refundAmount);
311     }
312 
313     /// @dev Sets the closingDeadline variable
314     function beginClosingPeriod() external onlyOwner atState(State.Success) {
315         require(closingDeadline == 0);
316         closingDeadline = now.add(closingDuration);
317     }
318 
319     /// @dev Called by anyone if the sale was successful and the project delivered.
320     function close() external atState(State.Success) {
321         require(closingDeadline != 0 && closingDeadline <= now);
322         state = State.Closed;
323         LogClosed();
324     }
325 
326     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
327     function sendFundsToWallet() external atState(State.Closed) {
328         require(lastDisbursement.add(DISBURSEMENT_DURATION) <= now);
329 
330         lastDisbursement = now;
331         uint256 amountToSend = Math.min256(address(this).balance, disbursementAmount);
332         refundable = amountToSend > refundable ? 0 : refundable.sub(amountToSend);
333         trustedWallet.transfer(amountToSend);
334     }
335 }
336 
337 // File: @tokenfoundry/sale-contracts/contracts/Whitelistable.sol
338 
339 /**
340  * @title Whitelistable
341  * @dev This contract is used to implement a signature based whitelisting mechanism
342  */
343 contract Whitelistable is Ownable {
344     bytes constant PREFIX = "\x19Ethereum Signed Message:\n32";
345 
346     address public whitelistAdmin;
347 
348     // addresses map to false by default
349     mapping(address => bool) public blacklist;
350 
351     event LogAdminUpdated(address indexed newAdmin);
352 
353     modifier validAdmin(address _admin) {
354         require(_admin != 0);
355         _;
356     }
357 
358     modifier onlyAdmin {
359         require(msg.sender == whitelistAdmin);
360         _;
361     }
362 
363     /// @dev Constructor for Whitelistable contract
364     /// @param _admin the address of the admin that will generate the signatures
365     function Whitelistable(address _admin) public validAdmin(_admin) {
366         whitelistAdmin = _admin;        
367     }
368 
369     /// @dev Updates whitelistAdmin address 
370     /// @dev Can only be called by the current owner
371     /// @param _admin the new admin address
372     function changeAdmin(address _admin)
373         external
374         onlyOwner
375         validAdmin(_admin)
376     {
377         LogAdminUpdated(_admin);
378         whitelistAdmin = _admin;
379     }
380 
381     // @dev blacklists the given address to ban them from contributing
382     // @param _contributor Address of the contributor to blacklist 
383     function addToBlacklist(address _contributor)
384         external
385         onlyAdmin
386     {
387         blacklist[_contributor] = true;
388     }
389 
390     // @dev removes a previously blacklisted contributor from the blacklist
391     // @param _contributor Address of the contributor remove 
392     function removeFromBlacklist(address _contributor)
393         external
394         onlyAdmin
395     {
396         blacklist[_contributor] = false;
397     }
398 
399     /// @dev Checks if contributor is whitelisted (main Whitelistable function)
400     /// @param contributor Address of who was whitelisted
401     /// @param contributionLimit Limit for the user contribution
402     /// @param currentSaleCap Cap of contributions to the sale at the current point in time
403     /// @param v Recovery id
404     /// @param r Component of the ECDSA signature
405     /// @param s Component of the ECDSA signature
406     /// @return Is the signature correct?
407     function checkWhitelisted(
408         address contributor,
409         uint256 contributionLimit,
410         uint256 currentSaleCap,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) public view returns(bool) {
415         bytes32 prefixed = keccak256(PREFIX, keccak256(contributor, contributionLimit, currentSaleCap));
416         return !(blacklist[contributor]) && (whitelistAdmin == ecrecover(prefixed, v, r, s));
417     }
418 }
419 
420 // File: @tokenfoundry/state-machine/contracts/StateMachine.sol
421 
422 contract StateMachine {
423 
424     struct State { 
425         bytes32 nextStateId;
426         mapping(bytes4 => bool) allowedFunctions;
427         function() internal[] transitionCallbacks;
428         function(bytes32) internal returns(bool)[] startConditions;
429     }
430 
431     mapping(bytes32 => State) states;
432 
433     // The current state id
434     bytes32 private currentStateId;
435 
436     event LogTransition(bytes32 stateId, uint256 blockNumber);
437 
438     /* This modifier performs the conditional transitions and checks that the function 
439      * to be executed is allowed in the current State
440      */
441     modifier checkAllowed {
442         conditionalTransitions();
443         require(states[currentStateId].allowedFunctions[msg.sig]);
444         _;
445     }
446 
447     ///@dev transitions the state machine into the state it should currently be in
448     ///@dev by taking into account the current conditions and how many further transitions can occur 
449     function conditionalTransitions() public {
450 
451         bytes32 next = states[currentStateId].nextStateId;
452         bool stateChanged;
453 
454         while (next != 0) {
455             // If one of the next state's conditions is met, go to this state and continue
456             stateChanged = false;
457             for (uint256 i = 0; i < states[next].startConditions.length; i++) {
458                 if (states[next].startConditions[i](next)) {
459                     goToNextState();
460                     next = states[next].nextStateId;
461                     stateChanged = true;
462                     break;
463                 }
464             }
465             // If none of the next state's conditions are met, then we are in the right current state
466             if (!stateChanged) break;
467         }
468     }
469 
470     function getCurrentStateId() view public returns(bytes32) {
471         return currentStateId;
472     }
473 
474 
475     /// @dev Setup the state machine with the given states.
476     /// @param _stateIds Array of state ids.
477     function setStates(bytes32[] _stateIds) internal {
478         require(_stateIds.length > 0);
479         require(currentStateId == 0);
480 
481         require(_stateIds[0] != 0);
482 
483         currentStateId = _stateIds[0];
484 
485         for (uint256 i = 1; i < _stateIds.length; i++) {
486             require(_stateIds[i] != 0);
487 
488             states[_stateIds[i - 1]].nextStateId = _stateIds[i];
489 
490             // Check that the state appears only once in the array
491             require(states[_stateIds[i]].nextStateId == 0);
492         }
493     }
494 
495     /// @dev Allow a function in the given state.
496     /// @param _stateId The id of the state
497     /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
498     function allowFunction(bytes32 _stateId, bytes4 _functionSelector) internal {
499         states[_stateId].allowedFunctions[_functionSelector] = true;
500     }
501 
502     /// @dev Goes to the next state if possible (if the next state is valid)
503     function goToNextState() internal {
504         bytes32 next = states[currentStateId].nextStateId;
505         require(next != 0);
506 
507         currentStateId = next;
508         for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
509             states[next].transitionCallbacks[i]();
510         }
511 
512         LogTransition(next, block.number);
513     }
514 
515     ///@dev add a function returning a boolean as a start condition for a state
516     ///@param _stateId The ID of the state to add the condition for
517     ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
518     function addStartCondition(bytes32 _stateId, function(bytes32) internal returns(bool) _condition) internal {
519         states[_stateId].startConditions.push(_condition);
520     }
521 
522     ///@dev add a callback function for a state
523     ///@param _stateId The ID of the state to add a callback function for
524     ///@param _callback The callback function to add
525     function addCallback(bytes32 _stateId, function() internal _callback) internal {
526         states[_stateId].transitionCallbacks.push(_callback);
527     }
528 
529 }
530 
531 // File: @tokenfoundry/state-machine/contracts/TimedStateMachine.sol
532 
533 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
534 contract TimedStateMachine is StateMachine {
535 
536     event LogSetStateStartTime(bytes32 indexed _stateId, uint256 _startTime);
537 
538     // Stores the start timestamp for each state (the value is 0 if the state doesn't have a start timestamp).
539     mapping(bytes32 => uint256) private startTime;
540 
541     /// @dev Returns the timestamp for the given state id.
542     /// @param _stateId The id of the state for which we want to set the start timestamp.
543     function getStateStartTime(bytes32 _stateId) public view returns(uint256) {
544         return startTime[_stateId];
545     }
546 
547     /// @dev Sets the starting timestamp for a state.
548     /// @param _stateId The id of the state for which we want to set the start timestamp.
549     /// @param _timestamp The start timestamp for the given state. It should be bigger than the current one.
550     function setStateStartTime(bytes32 _stateId, uint256 _timestamp) internal {
551         require(block.timestamp < _timestamp);
552 
553         if (startTime[_stateId] == 0) {
554             addStartCondition(_stateId, hasStartTimePassed);
555         }
556 
557         startTime[_stateId] = _timestamp;
558 
559         LogSetStateStartTime(_stateId, _timestamp);
560     }
561 
562     function hasStartTimePassed(bytes32 _stateId) internal returns(bool) {
563         return startTime[_stateId] <= block.timestamp;
564     }
565 
566 }
567 
568 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
569 
570 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
571 contract TokenControllerI {
572 
573     /// @dev Specifies whether a transfer is allowed or not.
574     /// @return True if the transfer is allowed
575     function transferAllowed(address _from, address _to) external view returns (bool);
576 }
577 
578 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
579 
580 /**
581  * @title Basic token
582  * @dev Basic version of StandardToken, with no allowances.
583  */
584 contract BasicToken is ERC20Basic {
585   using SafeMath for uint256;
586 
587   mapping(address => uint256) balances;
588 
589   uint256 totalSupply_;
590 
591   /**
592   * @dev total number of tokens in existence
593   */
594   function totalSupply() public view returns (uint256) {
595     return totalSupply_;
596   }
597 
598   /**
599   * @dev transfer token for a specified address
600   * @param _to The address to transfer to.
601   * @param _value The amount to be transferred.
602   */
603   function transfer(address _to, uint256 _value) public returns (bool) {
604     require(_to != address(0));
605     require(_value <= balances[msg.sender]);
606 
607     // SafeMath.sub will throw if there is not enough balance.
608     balances[msg.sender] = balances[msg.sender].sub(_value);
609     balances[_to] = balances[_to].add(_value);
610     Transfer(msg.sender, _to, _value);
611     return true;
612   }
613 
614   /**
615   * @dev Gets the balance of the specified address.
616   * @param _owner The address to query the the balance of.
617   * @return An uint256 representing the amount owned by the passed address.
618   */
619   function balanceOf(address _owner) public view returns (uint256 balance) {
620     return balances[_owner];
621   }
622 
623 }
624 
625 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
626 
627 /**
628  * @title Standard ERC20 token
629  *
630  * @dev Implementation of the basic standard token.
631  * @dev https://github.com/ethereum/EIPs/issues/20
632  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
633  */
634 contract StandardToken is ERC20, BasicToken {
635 
636   mapping (address => mapping (address => uint256)) internal allowed;
637 
638 
639   /**
640    * @dev Transfer tokens from one address to another
641    * @param _from address The address which you want to send tokens from
642    * @param _to address The address which you want to transfer to
643    * @param _value uint256 the amount of tokens to be transferred
644    */
645   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
646     require(_to != address(0));
647     require(_value <= balances[_from]);
648     require(_value <= allowed[_from][msg.sender]);
649 
650     balances[_from] = balances[_from].sub(_value);
651     balances[_to] = balances[_to].add(_value);
652     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
653     Transfer(_from, _to, _value);
654     return true;
655   }
656 
657   /**
658    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
659    *
660    * Beware that changing an allowance with this method brings the risk that someone may use both the old
661    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
662    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
663    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
664    * @param _spender The address which will spend the funds.
665    * @param _value The amount of tokens to be spent.
666    */
667   function approve(address _spender, uint256 _value) public returns (bool) {
668     allowed[msg.sender][_spender] = _value;
669     Approval(msg.sender, _spender, _value);
670     return true;
671   }
672 
673   /**
674    * @dev Function to check the amount of tokens that an owner allowed to a spender.
675    * @param _owner address The address which owns the funds.
676    * @param _spender address The address which will spend the funds.
677    * @return A uint256 specifying the amount of tokens still available for the spender.
678    */
679   function allowance(address _owner, address _spender) public view returns (uint256) {
680     return allowed[_owner][_spender];
681   }
682 
683   /**
684    * @dev Increase the amount of tokens that an owner allowed to a spender.
685    *
686    * approve should be called when allowed[_spender] == 0. To increment
687    * allowed value is better to use this function to avoid 2 calls (and wait until
688    * the first transaction is mined)
689    * From MonolithDAO Token.sol
690    * @param _spender The address which will spend the funds.
691    * @param _addedValue The amount of tokens to increase the allowance by.
692    */
693   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
694     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
695     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
696     return true;
697   }
698 
699   /**
700    * @dev Decrease the amount of tokens that an owner allowed to a spender.
701    *
702    * approve should be called when allowed[_spender] == 0. To decrement
703    * allowed value is better to use this function to avoid 2 calls (and wait until
704    * the first transaction is mined)
705    * From MonolithDAO Token.sol
706    * @param _spender The address which will spend the funds.
707    * @param _subtractedValue The amount of tokens to decrease the allowance by.
708    */
709   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
710     uint oldValue = allowed[msg.sender][_spender];
711     if (_subtractedValue > oldValue) {
712       allowed[msg.sender][_spender] = 0;
713     } else {
714       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
715     }
716     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
717     return true;
718   }
719 
720 }
721 
722 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
723 
724 /**
725  * @title Controllable ERC20 token
726  *
727  * @dev Token that queries a token controller contract to check if a transfer is allowed.
728  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
729  * implemented transferAllowed() function.
730  */
731 contract ControllableToken is Ownable, StandardToken {
732     TokenControllerI public controller;
733 
734     /// @dev Executes transferAllowed() function from the Controller. 
735     modifier isAllowed(address _from, address _to) {
736         require(controller.transferAllowed(_from, _to));
737         _;
738     }
739 
740     /// @dev Sets the controller that is going to be used by isAllowed modifier
741     function setController(TokenControllerI _controller) onlyOwner public {
742         require(_controller != address(0));
743         controller = _controller;
744     }
745 
746     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
747     /// @return True if the token is transfered with success
748     function transfer(address _to, uint256 _value) isAllowed(msg.sender, _to) public returns (bool) {        
749         return super.transfer(_to, _value);
750     }
751 
752     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
753     /// @return True if the token is transfered with success 
754     function transferFrom(address _from, address _to, uint256 _value) isAllowed(_from, _to) public returns (bool) {
755         return super.transferFrom(_from, _to, _value);
756     }
757 }
758 
759 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
760 
761 contract DetailedERC20 is ERC20 {
762   string public name;
763   string public symbol;
764   uint8 public decimals;
765 
766   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
767     name = _name;
768     symbol = _symbol;
769     decimals = _decimals;
770   }
771 }
772 
773 // File: @tokenfoundry/token-contracts/contracts/Token.sol
774 
775 /**
776  * @title Token base contract - Defines basic structure for a token
777  *
778  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
779  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
780  */
781 contract Token is ControllableToken, DetailedERC20 {
782 
783 	/**
784 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
785 	* @param _supply Total supply of tokens.
786     * @param _name Is the long name by which the token contract should be known
787     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
788     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
789 	*/
790     function Token(
791         uint256 _supply,
792         string _name,
793         string _symbol,
794         uint8 _decimals
795     ) DetailedERC20(_name, _symbol, _decimals) public {
796         require(_supply != 0);
797         totalSupply_ = _supply;
798         balances[msg.sender] = _supply;
799         Transfer(address(0), msg.sender, _supply);  //event
800     }
801 }
802 
803 // File: @tokenfoundry/sale-contracts/contracts/Sale.sol
804 
805 /// @title Sale base contract
806 contract Sale is Ownable, Whitelistable, TimedStateMachine, TokenControllerI {
807     using SafeMath for uint256;
808 
809     // State machine states
810     bytes32 private constant SETUP = 'setup';
811     bytes32 private constant FREEZE = 'freeze';
812     bytes32 private constant SALE_IN_PROGRESS = 'saleInProgress';
813     bytes32 private constant SALE_ENDED = 'saleEnded';
814     bytes32[] public states = [SETUP, FREEZE, SALE_IN_PROGRESS, SALE_ENDED];
815 
816     // Stores the contribution for each user
817     mapping(address => uint256) public contributions;
818     // Records which users have contributed throughout the sale
819     mapping(address => bool) public hasContributed;
820 
821     DisbursementHandler public disbursementHandler;
822 
823     uint256 public weiContributed = 0;
824     uint256 public totalSaleCap;
825     uint256 public minContribution;
826     uint256 public minThreshold;
827 
828     // How many tokens a user will receive per each wei contributed
829     uint256 public tokensPerWei;
830     uint256 public tokensForSale;
831 
832     Token public trustedToken;
833     Vault public trustedVault;
834 
835     event LogContribution(address indexed contributor, uint256 value, uint256 excess);
836     event LogTokensAllocated(address indexed contributor, uint256 amount);
837 
838     function Sale(
839         uint256 _totalSaleCap,
840         uint256 _minContribution,
841         uint256 _minThreshold,
842         uint256 _maxTokens,
843         address _whitelistAdmin,
844         address _wallet,
845         uint256 _closingDuration,
846         uint256 _vaultInitialAmount,
847         uint256 _vaultDisbursementAmount,
848         uint256 _startTime,
849         string _tokenName,
850         string _tokenSymbol,
851         uint8 _tokenDecimals
852     ) 
853         Whitelistable(_whitelistAdmin)
854         public 
855     {
856         require(_totalSaleCap != 0);
857         require(_maxTokens != 0);
858         require(_wallet != 0);
859         require(_minThreshold <= _totalSaleCap);
860         require(_vaultInitialAmount <= _minThreshold);
861         require(now < _startTime);
862 
863         totalSaleCap = _totalSaleCap;
864         minContribution = _minContribution;
865         minThreshold = _minThreshold;
866 
867         // Setup the necessary contracts
868         trustedToken = new Token(_maxTokens, _tokenName, _tokenSymbol, _tokenDecimals);
869         disbursementHandler = new DisbursementHandler(trustedToken);
870 
871         trustedToken.setController(this);
872 
873         trustedVault = new Vault(
874             _wallet,
875             _vaultInitialAmount,
876             _vaultDisbursementAmount, // disbursement amount
877             _closingDuration
878         );
879 
880         // Set the states
881         setStates(states);
882 
883         allowFunction(SETUP, this.setup.selector);
884         allowFunction(FREEZE, this.setEndTime.selector);
885         allowFunction(SALE_IN_PROGRESS, this.setEndTime.selector);
886         allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
887         allowFunction(SALE_IN_PROGRESS, this.endSale.selector);
888         allowFunction(SALE_ENDED, this.allocateTokens.selector);
889 
890         // End the sale when the cap is reached
891         addStartCondition(SALE_ENDED, wasCapReached);
892 
893         // Set the onSaleEnded callback (will be called when the sale ends)
894         addCallback(SALE_ENDED, onSaleEnded);
895 
896         // Set the start and end times for the sale
897         setStateStartTime(SALE_IN_PROGRESS, _startTime);
898     }
899 
900     /// @dev Setup the disbursements and tokens for sale.
901     /// @dev This needs to be outside the constructor because the token needs to query the sale for allowed transfers.
902     function setup() public onlyOwner checkAllowed {
903         require(trustedToken.transfer(disbursementHandler, disbursementHandler.totalAmount()));
904         tokensForSale = trustedToken.balanceOf(this);       
905         require(tokensForSale >= totalSaleCap);
906 
907         // Go to freeze state
908         goToNextState();
909     }
910 
911     /// @dev Called by users to contribute ETH to the sale.
912     function contribute(uint256 contributionLimit, uint256 currentSaleCap, uint8 v, bytes32 r, bytes32 s) 
913         external 
914         payable
915         checkAllowed 
916     {
917         // Check that the signature is valid
918         require(currentSaleCap <= totalSaleCap);
919         require(weiContributed < currentSaleCap);
920         require(checkWhitelisted(msg.sender, contributionLimit, currentSaleCap, v, r, s));
921 
922         uint256 current = contributions[msg.sender];
923         require(current < contributionLimit);
924 
925         // Get the max amount that the user can contribute
926         uint256 remaining = Math.min256(contributionLimit.sub(current), currentSaleCap.sub(weiContributed));
927 
928         // Check if it goes over the contribution limit of the user or the eth cap. 
929         uint256 contribution = Math.min256(msg.value, remaining);
930 
931         // Get the total contribution for the contributor after the previous checks
932         uint256 totalContribution = current.add(contribution);
933         require(totalContribution >= minContribution);
934 
935         contributions[msg.sender] = totalContribution;
936         hasContributed[msg.sender] = true;
937 
938         weiContributed = weiContributed.add(contribution);
939 
940         trustedVault.deposit.value(contribution)(msg.sender);
941 
942         if (weiContributed >= minThreshold && trustedVault.state() != Vault.State.Success) trustedVault.saleSuccessful();
943 
944         // If there is an excess, return it to the user
945         uint256 excess = msg.value.sub(contribution);
946         if (excess > 0) msg.sender.transfer(excess);
947 
948         LogContribution(msg.sender, contribution, excess);
949 
950         assert(totalContribution <= contributionLimit);
951     }
952 
953     /// @dev Sets the end time for the sale
954     /// @param _endTime The timestamp at which the sale will end.
955     function setEndTime(uint256 _endTime) external onlyOwner checkAllowed {
956         require(now < _endTime);
957         require(getStateStartTime(SALE_ENDED) == 0);
958         setStateStartTime(SALE_ENDED, _endTime);
959     }
960 
961     /// @dev Called to allocate the tokens depending on eth contributed by the end of the sale.
962     /// @param _contributor The address of the contributor.
963     function allocateTokens(address _contributor) external checkAllowed {
964         require(contributions[_contributor] != 0);
965 
966         // Transfer the respective tokens to the contributor
967         uint256 amount = contributions[_contributor].mul(tokensPerWei);
968 
969         // Set contributions to 0
970         contributions[_contributor] = 0;
971 
972         require(trustedToken.transfer(_contributor, amount));
973 
974         LogTokensAllocated(_contributor, amount);
975     }
976 
977     /// @dev Called to end the sale by the owner. Can only be called in SALE_IN_PROGRESS state
978     function endSale() external onlyOwner checkAllowed {
979         goToNextState();
980     }
981 
982     /// @dev Since Sale is TokenControllerI, it has to implement transferAllowed() function
983     /// @notice only the Sale and DisbursementHandler can disburse the initial tokens to their future owners
984     function transferAllowed(address _from, address) external view returns (bool) {
985         return _from == address(this) || _from == address(disbursementHandler);
986     }
987 
988     /// @dev Called internally by the sale to setup a disbursement (it has to be called in the constructor of child sales)
989     /// param _beneficiary Tokens will be disbursed to this address.
990     /// param _amount Number of tokens to be disbursed.
991     /// param _duration Tokens will be locked for this long.
992     function setupDisbursement(address _beneficiary, uint256 _amount, uint256 _duration) internal {
993         require(tokensForSale == 0);
994         disbursementHandler.setupDisbursement(_beneficiary, _amount, now.add(_duration));
995     }
996    
997     /// @dev Returns true if the cap was reached.
998     function wasCapReached(bytes32) internal returns (bool) {
999         return totalSaleCap <= weiContributed;
1000     }
1001 
1002     /// @dev Callback that gets called when entering the SALE_ENDED state.
1003     function onSaleEnded() internal {
1004         // If the minimum threshold wasn't reached, enable refunds
1005         if (weiContributed < minThreshold) {
1006             trustedVault.enableRefunds();
1007         } else {
1008             trustedVault.beginClosingPeriod();
1009             tokensPerWei = tokensForSale.div(weiContributed);
1010         }
1011 
1012         trustedToken.transferOwnership(owner); 
1013         trustedVault.transferOwnership(owner);
1014     }
1015 
1016 }
1017 
1018 // File: contracts/VirtuePokerSale.sol
1019 
1020 contract VirtuePokerSale is Sale {
1021 
1022     function VirtuePokerSale() 
1023         Sale(
1024             25000 ether, // Total sale cap
1025             1 ether, // Min contribution
1026             12000 ether, // Min threshold
1027             500000000 * (10 ** 18), // Max tokens
1028             0x13ebf15f2e32d05ea944927ef5e6a3cad8187440, // Whitelist Admin
1029             0xaa0aE3459F9f3472d1237015CaFC1aAfc6F03C63, // Wallet
1030             28 days, // Closing duration
1031             12000 ether, // Vault initial amount
1032             25000 ether, // Vault disbursement amount
1033             1524218400, // Start time
1034             "Virtue Player Points", // Token name
1035             "VPP", // Token symbol
1036             18 // Token decimals
1037         )
1038         public 
1039     {
1040         // Team Wallet (50,000,000 VPP, 25% per year)
1041         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 1 years);
1042         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 2 years);
1043         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 3 years);
1044         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 4 years);
1045 
1046         // Company Wallet (250,000,000 VPP, no lock-up)
1047         setupDisbursement(0xaa0aE3459F9f3472d1237015CaFC1aAfc6F03C63, 250000000 * (10 ** 18), 1 days);
1048 
1049         // Founder Allocations (total 100,000,000, 12.5% per 6 months)
1050         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 0.5 years);
1051         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 1 years);
1052         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 1.5 years);
1053         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 2 years);
1054         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 2.5 years);
1055         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 3 years);
1056         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 3.5 years);
1057         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 4 years);
1058 
1059         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 0.5 years);
1060         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 1 years);
1061         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 1.5 years);
1062         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 2 years);
1063         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 2.5 years);
1064         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 3 years);
1065         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 3.5 years);
1066         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 4 years);
1067 
1068         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 0.5 years);
1069         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 1 years);
1070         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 1.5 years);
1071         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 2 years);
1072         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 2.5 years);
1073         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 3 years);
1074         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 3.5 years);
1075         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 4 years);
1076     }
1077 }