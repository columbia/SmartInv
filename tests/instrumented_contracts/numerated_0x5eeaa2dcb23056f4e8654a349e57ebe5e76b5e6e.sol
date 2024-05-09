1 /**
2  *Submitted for verification at Etherscan.io on 2018-04-20
3 */
4 
5 pragma solidity 0.4.19;
6 
7 // File: zeppelin-solidity/contracts/math/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: @tokenfoundry/sale-contracts/contracts/DisbursementHandler.sol
125 
126 /// @title Disbursement handler - Manages time locked disbursements of ERC20 tokens
127 contract DisbursementHandler is Ownable {
128     using SafeMath for uint256;
129 
130     struct Disbursement {
131         // Tokens cannot be withdrawn before this timestamp
132         uint256 timestamp;
133 
134         // Amount of tokens to be disbursed
135         uint256 tokens;
136     }
137 
138     event LogSetup(address indexed vestor, uint256 timestamp, uint256 tokens);
139     event LogWithdraw(address indexed to, uint256 value);
140 
141     ERC20 public token;
142     uint256 public totalAmount;
143     mapping(address => Disbursement[]) public disbursements;
144     mapping(address => uint256) public withdrawnTokens;
145 
146     function DisbursementHandler(address _token) public {
147         token = ERC20(_token);
148     }
149 
150     /// @dev Called by the sale contract to create a disbursement.
151     /// @param vestor The address of the beneficiary.
152     /// @param tokens Amount of tokens to be locked.
153     /// @param timestamp Funds will be locked until this timestamp.
154     function setupDisbursement(
155         address vestor,
156         uint256 tokens,
157         uint256 timestamp
158     )
159         external
160         onlyOwner
161     {
162         require(block.timestamp < timestamp);
163         disbursements[vestor].push(Disbursement(timestamp, tokens));
164         totalAmount = totalAmount.add(tokens);
165         LogSetup(vestor, timestamp, tokens);
166     }
167 
168     /// @dev Transfers tokens to the withdrawer
169     function withdraw()
170         external
171     {
172         uint256 withdrawAmount = calcMaxWithdraw(msg.sender);
173         require(withdrawAmount != 0);
174         withdrawnTokens[msg.sender] = withdrawnTokens[msg.sender].add(withdrawAmount);
175         require(token.transfer(msg.sender, withdrawAmount));
176         LogWithdraw(msg.sender, withdrawAmount);
177     }
178 
179     /// @dev Calculates the maximum amount of vested tokens
180     /// @return Number of vested tokens that can be withdrawn
181     function calcMaxWithdraw(address beneficiary)
182         public
183         view
184         returns (uint256)
185     {
186         uint256 maxTokens = 0;
187 
188         // Go over all the disbursements and calculate how many tokens can be withdrawn
189         Disbursement[] storage temp = disbursements[beneficiary];
190         uint256 tempLength = temp.length;
191         for (uint256 i = 0; i < tempLength; i++) {
192             if (block.timestamp > temp[i].timestamp) {
193                 maxTokens = maxTokens.add(temp[i].tokens);
194             }
195         }
196 
197         // Return the computed amount minus the tokens already withdrawn
198         return maxTokens.sub(withdrawnTokens[beneficiary]);
199     }
200 }
201 
202 // File: zeppelin-solidity/contracts/math/Math.sol
203 
204 /**
205  * @title Math
206  * @dev Assorted math operations
207  */
208 library Math {
209   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
210     return a >= b ? a : b;
211   }
212 
213   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
214     return a < b ? a : b;
215   }
216 
217   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
218     return a >= b ? a : b;
219   }
220 
221   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
222     return a < b ? a : b;
223   }
224 }
225 
226 // File: @tokenfoundry/sale-contracts/contracts/Vault.sol
227 
228 // Adapted from Open Zeppelin's RefundVault
229 
230 /**
231  * @title Vault
232  * @dev This contract is used for storing funds while a crowdsale
233  * is in progress. Supports refunding the money if crowdsale fails,
234  * and forwarding it if crowdsale is successful.
235  */
236 contract Vault is Ownable {
237     using SafeMath for uint256;
238 
239     enum State { Active, Success, Refunding, Closed }
240 
241     uint256 public constant DISBURSEMENT_DURATION = 4 weeks;
242 
243     mapping (address => uint256) public deposited;
244     uint256 public disbursementAmount; // The amount to be disbursed to the wallet every month
245     address public trustedWallet; // Wallet from the project team
246 
247     uint256 public initialAmount; // The eth amount the team will get initially if the sale is successful
248 
249     uint256 public lastDisbursement; // Timestamp of the last disbursement made
250 
251     uint256 public totalDeposited; // Total amount that was deposited
252     uint256 public refundable; // Amount that can be refunded
253 
254     uint256 public closingDuration;
255     uint256 public closingDeadline; // Vault can't be closed before this deadline
256 
257     State public state;
258 
259     event LogClosed();
260     event LogRefundsEnabled();
261     event LogRefunded(address indexed contributor, uint256 amount);
262 
263     modifier atState(State _state) {
264         require(state == _state);
265         _;
266     }
267 
268     function Vault(
269         address wallet,
270         uint256 _initialAmount,
271         uint256 _disbursementAmount,
272         uint256 _closingDuration
273     ) 
274         public 
275     {
276         require(wallet != address(0));
277         require(_disbursementAmount != 0);
278         require(_closingDuration != 0);
279         trustedWallet = wallet;
280         initialAmount = _initialAmount;
281         disbursementAmount = _disbursementAmount;
282         closingDuration = _closingDuration;
283         state = State.Active;
284     }
285 
286     /// @dev Called by the sale contract to deposit ether for a contributor.
287     function deposit(address contributor) onlyOwner external payable {
288         require(state == State.Active || state == State.Success);
289         totalDeposited = totalDeposited.add(msg.value);
290         refundable = refundable.add(msg.value);
291         deposited[contributor] = deposited[contributor].add(msg.value);
292     }
293 
294     /// @dev Sends initial funds to the wallet.
295     function saleSuccessful() onlyOwner external atState(State.Active){
296         state = State.Success;
297         refundable = refundable.sub(initialAmount);
298         if (initialAmount != 0) {
299           trustedWallet.transfer(initialAmount);
300         }
301     }
302 
303     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
304     function enableRefunds() onlyOwner external {
305         state = State.Refunding;
306         LogRefundsEnabled();
307     }
308 
309     /// @dev Refunds ether to the contributors if in the Refunding state.
310     function refund(address contributor) external atState(State.Refunding) {
311         uint256 refundAmount = deposited[contributor].mul(refundable).div(totalDeposited);
312         deposited[contributor] = 0;
313         contributor.transfer(refundAmount);
314         LogRefunded(contributor, refundAmount);
315     }
316 
317     /// @dev Sets the closingDeadline variable
318     function beginClosingPeriod() external onlyOwner atState(State.Success) {
319         require(closingDeadline == 0);
320         closingDeadline = now.add(closingDuration);
321     }
322 
323     /// @dev Called by anyone if the sale was successful and the project delivered.
324     function close() external atState(State.Success) {
325         require(closingDeadline != 0 && closingDeadline <= now);
326         state = State.Closed;
327         LogClosed();
328     }
329 
330     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
331     function sendFundsToWallet() external atState(State.Closed) {
332         require(lastDisbursement.add(DISBURSEMENT_DURATION) <= now);
333 
334         lastDisbursement = now;
335         uint256 amountToSend = Math.min256(address(this).balance, disbursementAmount);
336         refundable = amountToSend > refundable ? 0 : refundable.sub(amountToSend);
337         trustedWallet.transfer(amountToSend);
338     }
339 }
340 
341 // File: @tokenfoundry/sale-contracts/contracts/Whitelistable.sol
342 
343 /**
344  * @title Whitelistable
345  * @dev This contract is used to implement a signature based whitelisting mechanism
346  */
347 contract Whitelistable is Ownable {
348     bytes constant PREFIX = "\x19Ethereum Signed Message:\n32";
349 
350     address public whitelistAdmin;
351 
352     // addresses map to false by default
353     mapping(address => bool) public blacklist;
354 
355     event LogAdminUpdated(address indexed newAdmin);
356 
357     modifier validAdmin(address _admin) {
358         require(_admin != 0);
359         _;
360     }
361 
362     modifier onlyAdmin {
363         require(msg.sender == whitelistAdmin);
364         _;
365     }
366 
367     /// @dev Constructor for Whitelistable contract
368     /// @param _admin the address of the admin that will generate the signatures
369     function Whitelistable(address _admin) public validAdmin(_admin) {
370         whitelistAdmin = _admin;        
371     }
372 
373     /// @dev Updates whitelistAdmin address 
374     /// @dev Can only be called by the current owner
375     /// @param _admin the new admin address
376     function changeAdmin(address _admin)
377         external
378         onlyOwner
379         validAdmin(_admin)
380     {
381         LogAdminUpdated(_admin);
382         whitelistAdmin = _admin;
383     }
384 
385     // @dev blacklists the given address to ban them from contributing
386     // @param _contributor Address of the contributor to blacklist 
387     function addToBlacklist(address _contributor)
388         external
389         onlyAdmin
390     {
391         blacklist[_contributor] = true;
392     }
393 
394     // @dev removes a previously blacklisted contributor from the blacklist
395     // @param _contributor Address of the contributor remove 
396     function removeFromBlacklist(address _contributor)
397         external
398         onlyAdmin
399     {
400         blacklist[_contributor] = false;
401     }
402 
403     /// @dev Checks if contributor is whitelisted (main Whitelistable function)
404     /// @param contributor Address of who was whitelisted
405     /// @param contributionLimit Limit for the user contribution
406     /// @param currentSaleCap Cap of contributions to the sale at the current point in time
407     /// @param v Recovery id
408     /// @param r Component of the ECDSA signature
409     /// @param s Component of the ECDSA signature
410     /// @return Is the signature correct?
411     function checkWhitelisted(
412         address contributor,
413         uint256 contributionLimit,
414         uint256 currentSaleCap,
415         uint8 v,
416         bytes32 r,
417         bytes32 s
418     ) public view returns(bool) {
419         bytes32 prefixed = keccak256(PREFIX, keccak256(contributor, contributionLimit, currentSaleCap));
420         return !(blacklist[contributor]) && (whitelistAdmin == ecrecover(prefixed, v, r, s));
421     }
422 }
423 
424 // File: @tokenfoundry/state-machine/contracts/StateMachine.sol
425 
426 contract StateMachine {
427 
428     struct State { 
429         bytes32 nextStateId;
430         mapping(bytes4 => bool) allowedFunctions;
431         function() internal[] transitionCallbacks;
432         function(bytes32) internal returns(bool)[] startConditions;
433     }
434 
435     mapping(bytes32 => State) states;
436 
437     // The current state id
438     bytes32 private currentStateId;
439 
440     event LogTransition(bytes32 stateId, uint256 blockNumber);
441 
442     /* This modifier performs the conditional transitions and checks that the function 
443      * to be executed is allowed in the current State
444      */
445     modifier checkAllowed {
446         conditionalTransitions();
447         require(states[currentStateId].allowedFunctions[msg.sig]);
448         _;
449     }
450 
451     ///@dev transitions the state machine into the state it should currently be in
452     ///@dev by taking into account the current conditions and how many further transitions can occur 
453     function conditionalTransitions() public {
454 
455         bytes32 next = states[currentStateId].nextStateId;
456         bool stateChanged;
457 
458         while (next != 0) {
459             // If one of the next state's conditions is met, go to this state and continue
460             stateChanged = false;
461             for (uint256 i = 0; i < states[next].startConditions.length; i++) {
462                 if (states[next].startConditions[i](next)) {
463                     goToNextState();
464                     next = states[next].nextStateId;
465                     stateChanged = true;
466                     break;
467                 }
468             }
469             // If none of the next state's conditions are met, then we are in the right current state
470             if (!stateChanged) break;
471         }
472     }
473 
474     function getCurrentStateId() view public returns(bytes32) {
475         return currentStateId;
476     }
477 
478 
479     /// @dev Setup the state machine with the given states.
480     /// @param _stateIds Array of state ids.
481     function setStates(bytes32[] _stateIds) internal {
482         require(_stateIds.length > 0);
483         require(currentStateId == 0);
484 
485         require(_stateIds[0] != 0);
486 
487         currentStateId = _stateIds[0];
488 
489         for (uint256 i = 1; i < _stateIds.length; i++) {
490             require(_stateIds[i] != 0);
491 
492             states[_stateIds[i - 1]].nextStateId = _stateIds[i];
493 
494             // Check that the state appears only once in the array
495             require(states[_stateIds[i]].nextStateId == 0);
496         }
497     }
498 
499     /// @dev Allow a function in the given state.
500     /// @param _stateId The id of the state
501     /// @param _functionSelector A function selector (bytes4[keccak256(functionSignature)])
502     function allowFunction(bytes32 _stateId, bytes4 _functionSelector) internal {
503         states[_stateId].allowedFunctions[_functionSelector] = true;
504     }
505 
506     /// @dev Goes to the next state if possible (if the next state is valid)
507     function goToNextState() internal {
508         bytes32 next = states[currentStateId].nextStateId;
509         require(next != 0);
510 
511         currentStateId = next;
512         for (uint256 i = 0; i < states[next].transitionCallbacks.length; i++) {
513             states[next].transitionCallbacks[i]();
514         }
515 
516         LogTransition(next, block.number);
517     }
518 
519     ///@dev add a function returning a boolean as a start condition for a state
520     ///@param _stateId The ID of the state to add the condition for
521     ///@param _condition Start condition function - returns true if a start condition (for a given state ID) is met
522     function addStartCondition(bytes32 _stateId, function(bytes32) internal returns(bool) _condition) internal {
523         states[_stateId].startConditions.push(_condition);
524     }
525 
526     ///@dev add a callback function for a state
527     ///@param _stateId The ID of the state to add a callback function for
528     ///@param _callback The callback function to add
529     function addCallback(bytes32 _stateId, function() internal _callback) internal {
530         states[_stateId].transitionCallbacks.push(_callback);
531     }
532 
533 }
534 
535 // File: @tokenfoundry/state-machine/contracts/TimedStateMachine.sol
536 
537 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
538 contract TimedStateMachine is StateMachine {
539 
540     event LogSetStateStartTime(bytes32 indexed _stateId, uint256 _startTime);
541 
542     // Stores the start timestamp for each state (the value is 0 if the state doesn't have a start timestamp).
543     mapping(bytes32 => uint256) private startTime;
544 
545     /// @dev Returns the timestamp for the given state id.
546     /// @param _stateId The id of the state for which we want to set the start timestamp.
547     function getStateStartTime(bytes32 _stateId) public view returns(uint256) {
548         return startTime[_stateId];
549     }
550 
551     /// @dev Sets the starting timestamp for a state.
552     /// @param _stateId The id of the state for which we want to set the start timestamp.
553     /// @param _timestamp The start timestamp for the given state. It should be bigger than the current one.
554     function setStateStartTime(bytes32 _stateId, uint256 _timestamp) internal {
555         require(block.timestamp < _timestamp);
556 
557         if (startTime[_stateId] == 0) {
558             addStartCondition(_stateId, hasStartTimePassed);
559         }
560 
561         startTime[_stateId] = _timestamp;
562 
563         LogSetStateStartTime(_stateId, _timestamp);
564     }
565 
566     function hasStartTimePassed(bytes32 _stateId) internal returns(bool) {
567         return startTime[_stateId] <= block.timestamp;
568     }
569 
570 }
571 
572 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
573 
574 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
575 contract TokenControllerI {
576 
577     /// @dev Specifies whether a transfer is allowed or not.
578     /// @return True if the transfer is allowed
579     function transferAllowed(address _from, address _to) external view returns (bool);
580 }
581 
582 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
583 
584 /**
585  * @title Basic token
586  * @dev Basic version of StandardToken, with no allowances.
587  */
588 contract BasicToken is ERC20Basic {
589   using SafeMath for uint256;
590 
591   mapping(address => uint256) balances;
592 
593   uint256 totalSupply_;
594 
595   /**
596   * @dev total number of tokens in existence
597   */
598   function totalSupply() public view returns (uint256) {
599     return totalSupply_;
600   }
601 
602   /**
603   * @dev transfer token for a specified address
604   * @param _to The address to transfer to.
605   * @param _value The amount to be transferred.
606   */
607   function transfer(address _to, uint256 _value) public returns (bool) {
608     require(_to != address(0));
609     require(_value <= balances[msg.sender]);
610 
611     // SafeMath.sub will throw if there is not enough balance.
612     balances[msg.sender] = balances[msg.sender].sub(_value);
613     balances[_to] = balances[_to].add(_value);
614     Transfer(msg.sender, _to, _value);
615     return true;
616   }
617 
618   /**
619   * @dev Gets the balance of the specified address.
620   * @param _owner The address to query the the balance of.
621   * @return An uint256 representing the amount owned by the passed address.
622   */
623   function balanceOf(address _owner) public view returns (uint256 balance) {
624     return balances[_owner];
625   }
626 
627 }
628 
629 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
630 
631 /**
632  * @title Standard ERC20 token
633  *
634  * @dev Implementation of the basic standard token.
635  * @dev https://github.com/ethereum/EIPs/issues/20
636  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
637  */
638 contract StandardToken is ERC20, BasicToken {
639 
640   mapping (address => mapping (address => uint256)) internal allowed;
641 
642 
643   /**
644    * @dev Transfer tokens from one address to another
645    * @param _from address The address which you want to send tokens from
646    * @param _to address The address which you want to transfer to
647    * @param _value uint256 the amount of tokens to be transferred
648    */
649   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
650     require(_to != address(0));
651     require(_value <= balances[_from]);
652     require(_value <= allowed[_from][msg.sender]);
653 
654     balances[_from] = balances[_from].sub(_value);
655     balances[_to] = balances[_to].add(_value);
656     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
657     Transfer(_from, _to, _value);
658     return true;
659   }
660 
661   /**
662    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
663    *
664    * Beware that changing an allowance with this method brings the risk that someone may use both the old
665    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
666    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
667    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
668    * @param _spender The address which will spend the funds.
669    * @param _value The amount of tokens to be spent.
670    */
671   function approve(address _spender, uint256 _value) public returns (bool) {
672     allowed[msg.sender][_spender] = _value;
673     Approval(msg.sender, _spender, _value);
674     return true;
675   }
676 
677   /**
678    * @dev Function to check the amount of tokens that an owner allowed to a spender.
679    * @param _owner address The address which owns the funds.
680    * @param _spender address The address which will spend the funds.
681    * @return A uint256 specifying the amount of tokens still available for the spender.
682    */
683   function allowance(address _owner, address _spender) public view returns (uint256) {
684     return allowed[_owner][_spender];
685   }
686 
687   /**
688    * @dev Increase the amount of tokens that an owner allowed to a spender.
689    *
690    * approve should be called when allowed[_spender] == 0. To increment
691    * allowed value is better to use this function to avoid 2 calls (and wait until
692    * the first transaction is mined)
693    * From MonolithDAO Token.sol
694    * @param _spender The address which will spend the funds.
695    * @param _addedValue The amount of tokens to increase the allowance by.
696    */
697   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
698     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
699     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
700     return true;
701   }
702 
703   /**
704    * @dev Decrease the amount of tokens that an owner allowed to a spender.
705    *
706    * approve should be called when allowed[_spender] == 0. To decrement
707    * allowed value is better to use this function to avoid 2 calls (and wait until
708    * the first transaction is mined)
709    * From MonolithDAO Token.sol
710    * @param _spender The address which will spend the funds.
711    * @param _subtractedValue The amount of tokens to decrease the allowance by.
712    */
713   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
714     uint oldValue = allowed[msg.sender][_spender];
715     if (_subtractedValue > oldValue) {
716       allowed[msg.sender][_spender] = 0;
717     } else {
718       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
719     }
720     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
721     return true;
722   }
723 
724 }
725 
726 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
727 
728 /**
729  * @title Controllable ERC20 token
730  *
731  * @dev Token that queries a token controller contract to check if a transfer is allowed.
732  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
733  * implemented transferAllowed() function.
734  */
735 contract ControllableToken is Ownable, StandardToken {
736     TokenControllerI public controller;
737 
738     /// @dev Executes transferAllowed() function from the Controller. 
739     modifier isAllowed(address _from, address _to) {
740         require(controller.transferAllowed(_from, _to));
741         _;
742     }
743 
744     /// @dev Sets the controller that is going to be used by isAllowed modifier
745     function setController(TokenControllerI _controller) onlyOwner public {
746         require(_controller != address(0));
747         controller = _controller;
748     }
749 
750     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
751     /// @return True if the token is transfered with success
752     function transfer(address _to, uint256 _value) isAllowed(msg.sender, _to) public returns (bool) {        
753         return super.transfer(_to, _value);
754     }
755 
756     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
757     /// @return True if the token is transfered with success 
758     function transferFrom(address _from, address _to, uint256 _value) isAllowed(_from, _to) public returns (bool) {
759         return super.transferFrom(_from, _to, _value);
760     }
761 }
762 
763 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
764 
765 contract DetailedERC20 is ERC20 {
766   string public name;
767   string public symbol;
768   uint8 public decimals;
769 
770   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
771     name = _name;
772     symbol = _symbol;
773     decimals = _decimals;
774   }
775 }
776 
777 // File: @tokenfoundry/token-contracts/contracts/Token.sol
778 
779 /**
780  * @title Token base contract - Defines basic structure for a token
781  *
782  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
783  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
784  */
785 contract Token is ControllableToken, DetailedERC20 {
786 
787 	/**
788 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
789 	* @param _supply Total supply of tokens.
790     * @param _name Is the long name by which the token contract should be known
791     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
792     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
793 	*/
794     function Token(
795         uint256 _supply,
796         string _name,
797         string _symbol,
798         uint8 _decimals
799     ) DetailedERC20(_name, _symbol, _decimals) public {
800         require(_supply != 0);
801         totalSupply_ = _supply;
802         balances[msg.sender] = _supply;
803         Transfer(address(0), msg.sender, _supply);  //event
804     }
805 }
806 
807 // File: @tokenfoundry/sale-contracts/contracts/Sale.sol
808 
809 /// @title Sale base contract
810 contract Sale is Ownable, Whitelistable, TimedStateMachine, TokenControllerI {
811     using SafeMath for uint256;
812 
813     // State machine states
814     bytes32 private constant SETUP = 'setup';
815     bytes32 private constant FREEZE = 'freeze';
816     bytes32 private constant SALE_IN_PROGRESS = 'saleInProgress';
817     bytes32 private constant SALE_ENDED = 'saleEnded';
818     bytes32[] public states = [SETUP, FREEZE, SALE_IN_PROGRESS, SALE_ENDED];
819 
820     // Stores the contribution for each user
821     mapping(address => uint256) public contributions;
822     // Records which users have contributed throughout the sale
823     mapping(address => bool) public hasContributed;
824 
825     DisbursementHandler public disbursementHandler;
826 
827     uint256 public weiContributed = 0;
828     uint256 public totalSaleCap;
829     uint256 public minContribution;
830     uint256 public minThreshold;
831 
832     // How many tokens a user will receive per each wei contributed
833     uint256 public tokensPerWei;
834     uint256 public tokensForSale;
835 
836     Token public trustedToken;
837     Vault public trustedVault;
838 
839     event LogContribution(address indexed contributor, uint256 value, uint256 excess);
840     event LogTokensAllocated(address indexed contributor, uint256 amount);
841 
842     function Sale(
843         uint256 _totalSaleCap,
844         uint256 _minContribution,
845         uint256 _minThreshold,
846         uint256 _maxTokens,
847         address _whitelistAdmin,
848         address _wallet,
849         uint256 _closingDuration,
850         uint256 _vaultInitialAmount,
851         uint256 _vaultDisbursementAmount,
852         uint256 _startTime,
853         string _tokenName,
854         string _tokenSymbol,
855         uint8 _tokenDecimals
856     ) 
857         Whitelistable(_whitelistAdmin)
858         public 
859     {
860         require(_totalSaleCap != 0);
861         require(_maxTokens != 0);
862         require(_wallet != 0);
863         require(_minThreshold <= _totalSaleCap);
864         require(_vaultInitialAmount <= _minThreshold);
865         require(now < _startTime);
866 
867         totalSaleCap = _totalSaleCap;
868         minContribution = _minContribution;
869         minThreshold = _minThreshold;
870 
871         // Setup the necessary contracts
872         trustedToken = new Token(_maxTokens, _tokenName, _tokenSymbol, _tokenDecimals);
873         disbursementHandler = new DisbursementHandler(trustedToken);
874 
875         trustedToken.setController(this);
876 
877         trustedVault = new Vault(
878             _wallet,
879             _vaultInitialAmount,
880             _vaultDisbursementAmount, // disbursement amount
881             _closingDuration
882         );
883 
884         // Set the states
885         setStates(states);
886 
887         allowFunction(SETUP, this.setup.selector);
888         allowFunction(FREEZE, this.setEndTime.selector);
889         allowFunction(SALE_IN_PROGRESS, this.setEndTime.selector);
890         allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
891         allowFunction(SALE_IN_PROGRESS, this.endSale.selector);
892         allowFunction(SALE_ENDED, this.allocateTokens.selector);
893 
894         // End the sale when the cap is reached
895         addStartCondition(SALE_ENDED, wasCapReached);
896 
897         // Set the onSaleEnded callback (will be called when the sale ends)
898         addCallback(SALE_ENDED, onSaleEnded);
899 
900         // Set the start and end times for the sale
901         setStateStartTime(SALE_IN_PROGRESS, _startTime);
902     }
903 
904     /// @dev Setup the disbursements and tokens for sale.
905     /// @dev This needs to be outside the constructor because the token needs to query the sale for allowed transfers.
906     function setup() public onlyOwner checkAllowed {
907         require(trustedToken.transfer(disbursementHandler, disbursementHandler.totalAmount()));
908         tokensForSale = trustedToken.balanceOf(this);       
909         require(tokensForSale >= totalSaleCap);
910 
911         // Go to freeze state
912         goToNextState();
913     }
914 
915     /// @dev Called by users to contribute ETH to the sale.
916     function contribute(uint256 contributionLimit, uint256 currentSaleCap, uint8 v, bytes32 r, bytes32 s) 
917         external 
918         payable
919         checkAllowed 
920     {
921         // Check that the signature is valid
922         require(currentSaleCap <= totalSaleCap);
923         require(weiContributed < currentSaleCap);
924         require(checkWhitelisted(msg.sender, contributionLimit, currentSaleCap, v, r, s));
925 
926         uint256 current = contributions[msg.sender];
927         require(current < contributionLimit);
928 
929         // Get the max amount that the user can contribute
930         uint256 remaining = Math.min256(contributionLimit.sub(current), currentSaleCap.sub(weiContributed));
931 
932         // Check if it goes over the contribution limit of the user or the eth cap. 
933         uint256 contribution = Math.min256(msg.value, remaining);
934 
935         // Get the total contribution for the contributor after the previous checks
936         uint256 totalContribution = current.add(contribution);
937         require(totalContribution >= minContribution);
938 
939         contributions[msg.sender] = totalContribution;
940         hasContributed[msg.sender] = true;
941 
942         weiContributed = weiContributed.add(contribution);
943 
944         trustedVault.deposit.value(contribution)(msg.sender);
945 
946         if (weiContributed >= minThreshold && trustedVault.state() != Vault.State.Success) trustedVault.saleSuccessful();
947 
948         // If there is an excess, return it to the user
949         uint256 excess = msg.value.sub(contribution);
950         if (excess > 0) msg.sender.transfer(excess);
951 
952         LogContribution(msg.sender, contribution, excess);
953 
954         assert(totalContribution <= contributionLimit);
955     }
956 
957     /// @dev Sets the end time for the sale
958     /// @param _endTime The timestamp at which the sale will end.
959     function setEndTime(uint256 _endTime) external onlyOwner checkAllowed {
960         require(now < _endTime);
961         require(getStateStartTime(SALE_ENDED) == 0);
962         setStateStartTime(SALE_ENDED, _endTime);
963     }
964 
965     /// @dev Called to allocate the tokens depending on eth contributed by the end of the sale.
966     /// @param _contributor The address of the contributor.
967     function allocateTokens(address _contributor) external checkAllowed {
968         require(contributions[_contributor] != 0);
969 
970         // Transfer the respective tokens to the contributor
971         uint256 amount = contributions[_contributor].mul(tokensPerWei);
972 
973         // Set contributions to 0
974         contributions[_contributor] = 0;
975 
976         require(trustedToken.transfer(_contributor, amount));
977 
978         LogTokensAllocated(_contributor, amount);
979     }
980 
981     /// @dev Called to end the sale by the owner. Can only be called in SALE_IN_PROGRESS state
982     function endSale() external onlyOwner checkAllowed {
983         goToNextState();
984     }
985 
986     /// @dev Since Sale is TokenControllerI, it has to implement transferAllowed() function
987     /// @notice only the Sale and DisbursementHandler can disburse the initial tokens to their future owners
988     function transferAllowed(address _from, address) external view returns (bool) {
989         return _from == address(this) || _from == address(disbursementHandler);
990     }
991 
992     /// @dev Called internally by the sale to setup a disbursement (it has to be called in the constructor of child sales)
993     /// param _beneficiary Tokens will be disbursed to this address.
994     /// param _amount Number of tokens to be disbursed.
995     /// param _duration Tokens will be locked for this long.
996     function setupDisbursement(address _beneficiary, uint256 _amount, uint256 _duration) internal {
997         require(tokensForSale == 0);
998         disbursementHandler.setupDisbursement(_beneficiary, _amount, now.add(_duration));
999     }
1000    
1001     /// @dev Returns true if the cap was reached.
1002     function wasCapReached(bytes32) internal returns (bool) {
1003         return totalSaleCap <= weiContributed;
1004     }
1005 
1006     /// @dev Callback that gets called when entering the SALE_ENDED state.
1007     function onSaleEnded() internal {
1008         // If the minimum threshold wasn't reached, enable refunds
1009         if (weiContributed < minThreshold) {
1010             trustedVault.enableRefunds();
1011         } else {
1012             trustedVault.beginClosingPeriod();
1013             tokensPerWei = tokensForSale.div(weiContributed);
1014         }
1015 
1016         trustedToken.transferOwnership(owner); 
1017         trustedVault.transferOwnership(owner);
1018     }
1019 
1020 }
1021 
1022 // File: contracts/VirtuePokerSale.sol
1023 
1024 contract VirtuePokerSale is Sale {
1025 
1026     function VirtuePokerSale() 
1027         Sale(
1028             25000 ether, // Total sale cap
1029             1 ether, // Min contribution
1030             12000 ether, // Min threshold
1031             500000000 * (10 ** 18), // Max tokens
1032             0x13ebf15f2e32d05ea944927ef5e6a3cad8187440, // Whitelist Admin
1033             0xaa0aE3459F9f3472d1237015CaFC1aAfc6F03C63, // Wallet
1034             28 days, // Closing duration
1035             12000 ether, // Vault initial amount
1036             25000 ether, // Vault disbursement amount
1037             1524218400, // Start time
1038             "Virtue Player Points", // Token name
1039             "VPP", // Token symbol
1040             18 // Token decimals
1041         )
1042         public 
1043     {
1044         // Team Wallet (50,000,000 VPP, 25% per year)
1045         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 1 years);
1046         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 2 years);
1047         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 3 years);
1048         setupDisbursement(0x2e286dA6Ee6E8e0Afb2c1CfADb1B74669a3cD642, 12500000 * (10 ** 18), 4 years);
1049 
1050         // Company Wallet (250,000,000 VPP, no lock-up)
1051         setupDisbursement(0xaa0aE3459F9f3472d1237015CaFC1aAfc6F03C63, 250000000 * (10 ** 18), 1 days);
1052 
1053         // Founder Allocations (total 100,000,000, 12.5% per 6 months)
1054         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 0.5 years);
1055         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 1 years);
1056         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 1.5 years);
1057         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 2 years);
1058         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 2.5 years);
1059         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 3 years);
1060         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 3.5 years);
1061         setupDisbursement(0x5ca71f050865092468CF8184D09e087F3DC58e31, 8000000 * (10 ** 18), 4 years);
1062 
1063         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 0.5 years);
1064         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 1 years);
1065         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 1.5 years);
1066         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 2 years);
1067         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 2.5 years);
1068         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 3 years);
1069         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 3.5 years);
1070         setupDisbursement(0x35fc8cA81E1b5992a0727c6Aa87DbeB8cca42094, 2250000 * (10 ** 18), 4 years);
1071 
1072         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 0.5 years);
1073         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 1 years);
1074         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 1.5 years);
1075         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 2 years);
1076         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 2.5 years);
1077         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 3 years);
1078         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 3.5 years);
1079         setupDisbursement(0xce3EFA6763e23DF21aF74DA46C6489736F96d4B6, 2250000 * (10 ** 18), 4 years);
1080     }
1081 }