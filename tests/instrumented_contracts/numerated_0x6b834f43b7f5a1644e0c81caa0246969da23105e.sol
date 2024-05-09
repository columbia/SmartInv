1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 
79 
80 /// @title A library for implementing a generic state machine pattern.
81 library StateMachineLib {
82 
83     struct Stage {
84         // The id of the next stage
85         bytes32 nextId;
86 
87         // The identifiers for the available functions in each stage
88         mapping(bytes4 => bool) allowedFunctions;
89     }
90 
91     struct State {
92         // The current stage id
93         bytes32 currentStageId;
94 
95         // A callback that is called when entering this stage
96         function(bytes32) internal onTransition;
97 
98         // Checks if a stage id is valid
99         mapping(bytes32 => bool) validStage;
100 
101         // Maps stage ids to their Stage structs
102         mapping(bytes32 => Stage) stages;
103     }
104 
105     /// @dev Creates and sets the initial stage. It has to be called before creating any transitions.
106     /// @param stageId The id of the (new) stage to set as initial stage.
107     function setInitialStage(State storage self, bytes32 stageId) internal {
108         self.validStage[stageId] = true;
109         self.currentStageId = stageId;
110     }
111 
112     /// @dev Creates a transition from 'fromId' to 'toId'. If fromId already had a nextId, it deletes the now unreachable stage.
113     /// @param fromId The id of the stage from which the transition begins.
114     /// @param toId The id of the stage that will be reachable from "fromId".
115     function createTransition(State storage self, bytes32 fromId, bytes32 toId) internal {
116         require(self.validStage[fromId]);
117 
118         Stage storage from = self.stages[fromId];
119 
120         // Invalidate the stage that won't be reachable any more
121         if (from.nextId != 0) {
122             self.validStage[from.nextId] = false;
123             delete self.stages[from.nextId];
124         }
125 
126         from.nextId = toId;
127         self.validStage[toId] = true;
128     }
129 
130     /// @dev Goes to the next stage if posible (if the next stage is valid)
131     function goToNextStage(State storage self) internal {
132         Stage storage current = self.stages[self.currentStageId];
133 
134         require(self.validStage[current.nextId]);
135 
136         self.currentStageId = current.nextId;
137 
138         self.onTransition(current.nextId);
139     }
140 
141     /// @dev Checks if the a function is allowed in the current stage.
142     /// @param selector A function selector (bytes4[keccak256(functionSignature)])
143     /// @return true If the function is allowed in the current stage
144     function checkAllowedFunction(State storage self, bytes4 selector) internal constant returns(bool) {
145         return self.stages[self.currentStageId].allowedFunctions[selector];
146     }
147 
148     /// @dev Allow a function in the given stage.
149     /// @param stageId The id of the stage
150     /// @param selector A function selector (bytes4[keccak256(functionSignature)])
151     function allowFunction(State storage self, bytes32 stageId, bytes4 selector) internal {
152         require(self.validStage[stageId]);
153         self.stages[stageId].allowedFunctions[selector] = true;
154     }
155 
156 
157 }
158 
159 
160 
161 contract StateMachine {
162     using StateMachineLib for StateMachineLib.State;
163 
164     event LogTransition(bytes32 indexed stageId, uint256 blockNumber);
165 
166     StateMachineLib.State internal state;
167 
168     /* This modifier performs the conditional transitions and checks that the function 
169      * to be executed is allowed in the current stage
170      */
171     modifier checkAllowed {
172         conditionalTransitions();
173         require(state.checkAllowedFunction(msg.sig));
174         _;
175     }
176 
177     function StateMachine() public {
178         // Register the startConditions function and the onTransition callback
179         state.onTransition = onTransition;
180     }
181 
182     /// @dev Gets the current stage id.
183     /// @return The current stage id.
184     function getCurrentStageId() public view returns(bytes32) {
185         return state.currentStageId;
186     }
187 
188     /// @dev Performs conditional transitions. Can be called by anyone.
189     function conditionalTransitions() public {
190 
191         bytes32 nextId = state.stages[state.currentStageId].nextId;
192 
193         while (state.validStage[nextId]) {
194             StateMachineLib.Stage storage next = state.stages[nextId];
195             // If the next stage's condition is true, go to next stage and continue
196             if (startConditions(nextId)) {
197                 state.goToNextStage();
198                 nextId = next.nextId;
199             } else {
200                 break;
201             }
202         }
203     }
204 
205     /// @dev Determines whether the conditions for transitioning to the given stage are met.
206     /// @return true if the conditions are met for the given stageId. False by default (must override in child contracts).
207     function startConditions(bytes32) internal constant returns(bool) {
208         return false;
209     }
210 
211     /// @dev Callback called when there is a stage transition. It should be overridden for additional functionality.
212     function onTransition(bytes32 stageId) internal {
213         LogTransition(stageId, block.number);
214     }
215 
216 
217 }
218 
219 /// @title A contract that implements the state machine pattern and adds time dependant transitions.
220 contract TimedStateMachine is StateMachine {
221 
222     event LogSetStageStartTime(bytes32 indexed stageId, uint256 startTime);
223 
224     // Stores the start timestamp for each stage (the value is 0 if the stage doesn't have a start timestamp).
225     mapping(bytes32 => uint256) internal startTime;
226 
227     /// @dev This function overrides the startConditions function in the parent class in order to enable automatic transitions that depend on the timestamp.
228     function startConditions(bytes32 stageId) internal constant returns(bool) {
229         // Get the startTime for stage
230         uint256 start = startTime[stageId];
231         // If the startTime is set and has already passed, return true.
232         return start != 0 && block.timestamp > start;
233     }
234 
235     /// @dev Sets the starting timestamp for a stage.
236     /// @param stageId The id of the stage for which we want to set the start timestamp.
237     /// @param timestamp The start timestamp for the given stage. It should be bigger than the current one.
238     function setStageStartTime(bytes32 stageId, uint256 timestamp) internal {
239         require(state.validStage[stageId]);
240         require(timestamp > block.timestamp);
241 
242         startTime[stageId] = timestamp;
243         LogSetStageStartTime(stageId, timestamp);
244     }
245 
246     /// @dev Returns the timestamp for the given stage id.
247     /// @param stageId The id of the stage for which we want to set the start timestamp.
248     function getStageStartTime(bytes32 stageId) public view returns(uint256) {
249         return startTime[stageId];
250     }
251 }
252 
253 contract ERC20Basic {
254   uint256 public totalSupply;
255   function balanceOf(address who) public view returns (uint256);
256   function transfer(address to, uint256 value) public returns (bool);
257   event Transfer(address indexed from, address indexed to, uint256 value);
258 }
259 
260 
261 contract ERC20 is ERC20Basic {
262   function allowance(address owner, address spender) public view returns (uint256);
263   function transferFrom(address from, address to, uint256 value) public returns (bool);
264   function approve(address spender, uint256 value) public returns (bool);
265   event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 contract DetailedERC20 is ERC20 {
269   string public name;
270   string public symbol;
271   uint8 public decimals;
272 
273   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
274     name = _name;
275     symbol = _symbol;
276     decimals = _decimals;
277   }
278 }
279 
280 /**
281  * @title Basic token
282  * @dev Basic version of StandardToken, with no allowances.
283  */
284 contract BasicToken is ERC20Basic {
285   using SafeMath for uint256;
286 
287   mapping(address => uint256) balances;
288 
289   /**
290   * @dev transfer token for a specified address
291   * @param _to The address to transfer to.
292   * @param _value The amount to be transferred.
293   */
294   function transfer(address _to, uint256 _value) public returns (bool) {
295     require(_to != address(0));
296     require(_value <= balances[msg.sender]);
297 
298     // SafeMath.sub will throw if there is not enough balance.
299     balances[msg.sender] = balances[msg.sender].sub(_value);
300     balances[_to] = balances[_to].add(_value);
301     Transfer(msg.sender, _to, _value);
302     return true;
303   }
304 
305   /**
306   * @dev Gets the balance of the specified address.
307   * @param _owner The address to query the the balance of.
308   * @return An uint256 representing the amount owned by the passed address.
309   */
310   function balanceOf(address _owner) public view returns (uint256 balance) {
311     return balances[_owner];
312   }
313 
314 }
315 
316 /**
317  * @title Standard ERC20 token
318  *
319  * @dev Implementation of the basic standard token.
320  * @dev https://github.com/ethereum/EIPs/issues/20
321  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
322  */
323 contract StandardToken is ERC20, BasicToken {
324 
325   mapping (address => mapping (address => uint256)) internal allowed;
326 
327 
328   /**
329    * @dev Transfer tokens from one address to another
330    * @param _from address The address which you want to send tokens from
331    * @param _to address The address which you want to transfer to
332    * @param _value uint256 the amount of tokens to be transferred
333    */
334   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335     require(_to != address(0));
336     require(_value <= balances[_from]);
337     require(_value <= allowed[_from][msg.sender]);
338 
339     balances[_from] = balances[_from].sub(_value);
340     balances[_to] = balances[_to].add(_value);
341     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
342     Transfer(_from, _to, _value);
343     return true;
344   }
345 
346   /**
347    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
348    *
349    * Beware that changing an allowance with this method brings the risk that someone may use both the old
350    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
351    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
352    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353    * @param _spender The address which will spend the funds.
354    * @param _value The amount of tokens to be spent.
355    */
356   function approve(address _spender, uint256 _value) public returns (bool) {
357     allowed[msg.sender][_spender] = _value;
358     Approval(msg.sender, _spender, _value);
359     return true;
360   }
361 
362   /**
363    * @dev Function to check the amount of tokens that an owner allowed to a spender.
364    * @param _owner address The address which owns the funds.
365    * @param _spender address The address which will spend the funds.
366    * @return A uint256 specifying the amount of tokens still available for the spender.
367    */
368   function allowance(address _owner, address _spender) public view returns (uint256) {
369     return allowed[_owner][_spender];
370   }
371 
372   /**
373    * approve should be called when allowed[_spender] == 0. To increment
374    * allowed value is better to use this function to avoid 2 calls (and wait until
375    * the first transaction is mined)
376    * From MonolithDAO Token.sol
377    */
378   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
379     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
380     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
385     uint oldValue = allowed[msg.sender][_spender];
386     if (_subtractedValue > oldValue) {
387       allowed[msg.sender][_spender] = 0;
388     } else {
389       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
390     }
391     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394 
395 }
396 
397 /**
398  * @title Mintable token
399  * @dev Simple ERC20 Token example, with mintable token creation
400  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
401  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
402  */
403 
404 contract MintableToken is StandardToken, Ownable {
405   event Mint(address indexed to, uint256 amount);
406   event MintFinished();
407 
408   bool public mintingFinished = false;
409 
410 
411   modifier canMint() {
412     require(!mintingFinished);
413     _;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param _to The address that will receive the minted tokens.
419    * @param _amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
423     totalSupply = totalSupply.add(_amount);
424     balances[_to] = balances[_to].add(_amount);
425     Mint(_to, _amount);
426     Transfer(address(0), _to, _amount);
427     return true;
428   }
429 
430   /**
431    * @dev Function to stop minting new tokens.
432    * @return True if the operation was successful.
433    */
434   function finishMinting() onlyOwner canMint public returns (bool) {
435     mintingFinished = true;
436     MintFinished();
437     return true;
438   }
439 }
440 
441 
442 contract ERC223Basic is ERC20Basic {
443 
444     /**
445       * @dev Transfer the specified amount of tokens to the specified address.
446       *      Now with a new parameter _data.
447       *
448       * @param _to    Receiver address.
449       * @param _value Amount of tokens that will be transferred.
450       * @param _data  Transaction metadata.
451       */
452     function transfer(address _to, uint _value, bytes _data) public returns (bool);
453 
454     /**
455       * @dev triggered when transfer is successfully called.
456       *
457       * @param _from  Sender address.
458       * @param _to    Receiver address.
459       * @param _value Amount of tokens that will be transferred.
460       * @param _data  Transaction metadata.
461       */
462     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
463 }
464 
465 /// @title Contract that supports the receival of ERC223 tokens.
466 contract ERC223ReceivingContract {
467 
468     /// @dev Standard ERC223 function that will handle incoming token transfers.
469     /// @param _from  Token sender address.
470     /// @param _value Amount of tokens.
471     /// @param _data  Transaction metadata.
472     function tokenFallback(address _from, uint _value, bytes _data);
473 
474 }
475 
476 /**
477  * @title ERC223 standard token implementation.
478  */
479 contract ERC223BasicToken is ERC223Basic, BasicToken {
480 
481     /**
482       * @dev Transfer the specified amount of tokens to the specified address.
483       *      Invokes the `tokenFallback` function if the recipient is a contract.
484       *      The token transfer fails if the recipient is a contract
485       *      but does not implement the `tokenFallback` function
486       *      or the fallback function to receive funds.
487       *
488       * @param _to    Receiver address.
489       * @param _value Amount of tokens that will be transferred.
490       * @param _data  Transaction metadata.
491       */
492     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
493         // Standard function transfer similar to ERC20 transfer with no _data .
494         // Added due to backwards compatibility reasons .
495         uint codeLength;
496 
497         assembly {
498             // Retrieve the size of the code on target address, this needs assembly .
499             codeLength := extcodesize(_to)
500         }
501 
502         require(super.transfer(_to, _value));
503 
504         if(codeLength>0) {
505             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
506             receiver.tokenFallback(msg.sender, _value, _data);
507         }
508         Transfer(msg.sender, _to, _value, _data);
509         return true;
510     }
511 
512       /**
513       * @dev Transfer the specified amount of tokens to the specified address.
514       *      Invokes the `tokenFallback` function if the recipient is a contract.
515       *      The token transfer fails if the recipient is a contract
516       *      but does not implement the `tokenFallback` function
517       *      or the fallback function to receive funds.
518       *
519       * @param _to    Receiver address.
520       * @param _value Amount of tokens that will be transferred.
521       */
522     function transfer(address _to, uint256 _value) public returns (bool) {
523         bytes memory empty;
524         require(transfer(_to, _value, empty));
525         return true;
526     }
527 
528 }
529 
530 
531 
532 /// @title Token for the Pryze project.
533 contract PryzeToken is DetailedERC20, MintableToken, ERC223BasicToken {
534     string constant NAME = "Pryze";
535     string constant SYMBOL = "PRYZ";
536     uint8 constant DECIMALS = 18;
537 
538     //// @dev Constructor that sets details of the ERC20 token.
539     function PryzeToken()
540         DetailedERC20(NAME, SYMBOL, DECIMALS)
541         public
542     {}
543 }
544 
545 
546 
547 contract Whitelistable is Ownable {
548     
549     event LogUserRegistered(address indexed sender, address indexed userAddress);
550     event LogUserUnregistered(address indexed sender, address indexed userAddress);
551     
552     mapping(address => bool) public whitelisted;
553 
554     function registerUser(address userAddress) 
555         public 
556         onlyOwner 
557     {
558         require(userAddress != 0);
559         whitelisted[userAddress] = true;
560         LogUserRegistered(msg.sender, userAddress);
561     }
562 
563     function unregisterUser(address userAddress) 
564         public 
565         onlyOwner 
566     {
567         require(whitelisted[userAddress] == true);
568         whitelisted[userAddress] = false;
569         LogUserUnregistered(msg.sender, userAddress);
570     }
571 }
572 
573 
574 contract DisbursementHandler is Ownable {
575 
576     struct Disbursement {
577         uint256 timestamp;
578         uint256 tokens;
579     }
580 
581     event LogSetup(address indexed vestor, uint256 tokens, uint256 timestamp);
582     event LogChangeTimestamp(address indexed vestor, uint256 index, uint256 timestamp);
583     event LogWithdraw(address indexed to, uint256 value);
584 
585     ERC20 public token;
586     mapping(address => Disbursement[]) public disbursements;
587     mapping(address => uint256) public withdrawnTokens;
588 
589     function DisbursementHandler(address _token) public {
590         token = ERC20(_token);
591     }
592 
593     /// @dev Called by the sale contract to create a disbursement.
594     /// @param vestor The address of the beneficiary.
595     /// @param tokens Amount of tokens to be locked.
596     /// @param timestamp Funds will be locked until this timestamp.
597     function setupDisbursement(
598         address vestor,
599         uint256 tokens,
600         uint256 timestamp
601     )
602         public
603         onlyOwner
604     {
605         require(block.timestamp < timestamp);
606         disbursements[vestor].push(Disbursement(timestamp, tokens));
607         LogSetup(vestor, timestamp, tokens);
608     }
609 
610     /// @dev Change an existing disbursement.
611     /// @param vestor The address of the beneficiary.
612     /// @param timestamp Funds will be locked until this timestamp.
613     /// @param index Index of the DisbursementVesting in the vesting array.
614     function changeTimestamp(
615         address vestor,
616         uint256 index,
617         uint256 timestamp
618     )
619         public
620         onlyOwner
621     {
622         require(block.timestamp < timestamp);
623         require(index < disbursements[vestor].length);
624         disbursements[vestor][index].timestamp = timestamp;
625         LogChangeTimestamp(vestor, index, timestamp);
626     }
627 
628     /// @dev Transfers tokens to a given address
629     /// @param to Address of token receiver
630     /// @param value Number of tokens to transfer
631     function withdraw(address to, uint256 value)
632         public
633     {
634         uint256 maxTokens = calcMaxWithdraw();
635         uint256 withdrawAmount = value < maxTokens ? value : maxTokens;
636         withdrawnTokens[msg.sender] = SafeMath.add(withdrawnTokens[msg.sender], withdrawAmount);
637         token.transfer(to, withdrawAmount);
638         LogWithdraw(to, value);
639     }
640 
641     /// @dev Calculates the maximum amount of vested tokens
642     /// @return Number of vested tokens to withdraw
643     function calcMaxWithdraw()
644         public
645         constant
646         returns (uint256)
647     {
648         uint256 maxTokens = 0;
649         Disbursement[] storage temp = disbursements[msg.sender];
650         for (uint256 i = 0; i < temp.length; i++) {
651             if (block.timestamp > temp[i].timestamp) {
652                 maxTokens = SafeMath.add(maxTokens, temp[i].tokens);
653             }
654         }
655         maxTokens = SafeMath.sub(maxTokens, withdrawnTokens[msg.sender]);
656         return maxTokens;
657     }
658 }
659 
660 
661 /// @title Sale base contract
662 contract Sale is Ownable, TimedStateMachine {
663     using SafeMath for uint256;
664 
665     event LogContribution(address indexed contributor, uint256 amountSent, uint256 excessRefunded);
666     event LogTokenAllocation(address indexed contributor, uint256 contribution, uint256 tokens);
667     event LogDisbursement(address indexed beneficiary, uint256 tokens);
668 
669     // Stages for the state machine
670     bytes32 public constant SETUP = "setup";
671     bytes32 public constant SETUP_DONE = "setupDone";
672     bytes32 public constant SALE_IN_PROGRESS = "saleInProgress";
673     bytes32 public constant SALE_ENDED = "saleEnded";
674 
675     mapping(address => uint256) public contributions;
676 
677     uint256 public weiContributed = 0;
678     uint256 public contributionCap;
679 
680     // Wallet where funds will be sent
681     address public wallet;
682 
683     MintableToken public token;
684 
685     DisbursementHandler public disbursementHandler;
686 
687     function Sale(
688         address _wallet, 
689         uint256 _contributionCap
690     ) 
691         public 
692     {
693         require(_wallet != 0);
694         require(_contributionCap != 0);
695 
696         wallet = _wallet;
697 
698         token = createTokenContract();
699         disbursementHandler = new DisbursementHandler(token);
700 
701         contributionCap = _contributionCap;
702 
703         setupStages();
704     }
705 
706     function() external payable {
707         contribute();
708     }
709 
710     /// @dev Sets the start timestamp for the SALE_IN_PROGRESS stage.
711     /// @param timestamp The start timestamp.
712     function setSaleStartTime(uint256 timestamp) 
713         external 
714         onlyOwner 
715         checkAllowed
716     {
717         // require(_startTime < getStageStartTime(SALE_ENDED));
718         setStageStartTime(SALE_IN_PROGRESS, timestamp);
719     }
720 
721     /// @dev Sets the start timestamp for the SALE_ENDED stage.
722     /// @param timestamp The start timestamp.
723     function setSaleEndTime(uint256 timestamp) 
724         external 
725         onlyOwner 
726         checkAllowed
727     {
728         require(getStageStartTime(SALE_IN_PROGRESS) < timestamp);
729         setStageStartTime(SALE_ENDED, timestamp);
730     }
731 
732     /// @dev Called in the SETUP stage, check configurations and to go to the SETUP_DONE stage.
733     function setupDone() 
734         public 
735         onlyOwner 
736         checkAllowed
737     {
738         uint256 _startTime = getStageStartTime(SALE_IN_PROGRESS);
739         uint256 _endTime = getStageStartTime(SALE_ENDED);
740         require(block.timestamp < _startTime);
741         require(_startTime < _endTime);
742 
743         state.goToNextStage();
744     }
745 
746     /// @dev Called by users to contribute ETH to the sale.
747     function contribute() 
748         public 
749         payable
750         checkAllowed 
751     {
752         require(msg.value > 0);   
753 
754         uint256 contributionLimit = getContributionLimit(msg.sender);
755         require(contributionLimit > 0);
756 
757         // Check that the user is allowed to contribute
758         uint256 totalContribution = contributions[msg.sender].add(msg.value);
759         uint256 excess = 0;
760 
761         // Check if it goes over the eth cap for the sale.
762         if (weiContributed.add(msg.value) > contributionCap) {
763             // Subtract the excess
764             excess = weiContributed.add(msg.value).sub(contributionCap);
765             totalContribution = totalContribution.sub(excess);
766         }
767 
768         // Check if it goes over the contribution limit of the user. 
769         if (totalContribution > contributionLimit) {
770             excess = excess.add(totalContribution).sub(contributionLimit);
771             contributions[msg.sender] = contributionLimit;
772         } else {
773             contributions[msg.sender] = totalContribution;
774         }
775 
776         // We are only able to refund up to msg.value because the contract will not contain ether
777         excess = excess < msg.value ? excess : msg.value;
778 
779         weiContributed = weiContributed.add(msg.value).sub(excess);
780 
781         if (excess > 0) {
782             msg.sender.transfer(excess);
783         }
784 
785         wallet.transfer(this.balance);
786 
787         assert(contributions[msg.sender] <= contributionLimit);
788         LogContribution(msg.sender, msg.value, excess);
789     }
790 
791     /// @dev Create a disbursement of tokens.
792     /// @param beneficiary The beneficiary of the disbursement.
793     /// @param tokenAmount Amount of tokens to be locked.
794     /// @param timestamp Tokens will be locked until this timestamp.
795     function distributeTimelockedTokens(
796         address beneficiary,
797         uint256 tokenAmount,
798         uint256 timestamp
799     ) 
800         external
801         onlyOwner
802         checkAllowed
803     { 
804         disbursementHandler.setupDisbursement(
805             beneficiary,
806             tokenAmount,
807             timestamp
808         );
809         token.mint(disbursementHandler, tokenAmount);
810         LogDisbursement(beneficiary, tokenAmount);
811     }
812     
813     function setupStages() internal {
814         // Set the stages
815         state.setInitialStage(SETUP);
816         state.createTransition(SETUP, SETUP_DONE);
817         state.createTransition(SETUP_DONE, SALE_IN_PROGRESS);
818         state.createTransition(SALE_IN_PROGRESS, SALE_ENDED);
819 
820         // The selectors should be hardcoded
821         state.allowFunction(SETUP, this.distributeTimelockedTokens.selector);
822         state.allowFunction(SETUP, this.setSaleStartTime.selector);
823         state.allowFunction(SETUP, this.setSaleEndTime.selector);
824         state.allowFunction(SETUP, this.setupDone.selector);
825         state.allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
826         state.allowFunction(SALE_IN_PROGRESS, 0); // fallback
827     }
828 
829     // Override in the child sales
830     function createTokenContract() internal returns (MintableToken);
831     function getContributionLimit(address userAddress) internal returns (uint256);
832 
833     /// @dev Stage start conditions.
834     function startConditions(bytes32 stageId) internal constant returns (bool) {
835         // If the cap has been reached, end the sale.
836         if (stageId == SALE_ENDED && contributionCap == weiContributed) {
837             return true;
838         }
839         return super.startConditions(stageId);
840     }
841 
842     /// @dev State transitions callbacks.
843     function onTransition(bytes32 stageId) internal {
844         if (stageId == SALE_ENDED) { 
845             onSaleEnded(); 
846         }
847         super.onTransition(stageId);
848     }
849 
850     /// @dev Callback that gets called when entering the SALE_ENDED stage.
851     function onSaleEnded() internal {}
852 }
853 
854 
855 
856 contract PryzeSale is Sale, Whitelistable {
857 
858     uint256 public constant PRESALE_WEI = 10695.303 ether; // Amount raised in the presale
859     uint256 public constant PRESALE_WEI_WITH_BONUS = 10695.303 ether * 1.5; // Amount raised in the presale times the bonus
860 
861     uint256 public constant MAX_WEI = 24695.303 ether; // Max wei to raise, including PRESALE_WEI
862     uint256 public constant WEI_CAP = 14000 ether; // MAX_WEI - PRESALE_WEI
863     uint256 public constant MAX_TOKENS = 400000000 * 1000000000000000000; // 4mm times 10^18 (18 decimals)
864 
865     uint256 public presaleWeiContributed = 0;
866     uint256 private weiAllocated = 0;
867 
868     mapping(address => uint256) public presaleContributions;
869 
870     function PryzeSale(
871         address _wallet
872     )
873         Sale(_wallet, WEI_CAP)
874         public 
875     {
876     }
877 
878     /// @dev Sets the presale contribution for a contributor.
879     /// @param _contributor The contributor.
880     /// @param _amount The amount contributed in the presale (without the bonus).
881     function presaleContribute(address _contributor, uint256 _amount)
882         external
883         onlyOwner
884         checkAllowed
885     {
886         // If presale contribution is already set, replace the amount in the presaleWeiContributed variable
887         if (presaleContributions[_contributor] != 0) {
888             presaleWeiContributed = presaleWeiContributed.sub(presaleContributions[_contributor]);
889         } 
890         presaleWeiContributed = presaleWeiContributed.add(_amount);
891         require(presaleWeiContributed <= PRESALE_WEI);
892         presaleContributions[_contributor] = _amount;
893     }
894 
895     /// @dev Called to allocate the tokens depending on eth contributed.
896     /// @param contributor The address of the contributor.
897     function allocateTokens(address contributor) 
898         external 
899         checkAllowed
900     {
901         require(presaleContributions[contributor] != 0 || contributions[contributor] != 0);
902         uint256 tokensToAllocate = calculateAllocation(contributor);
903 
904         // We keep a record of how much wei contributed has already been used for allocations
905         weiAllocated = weiAllocated.add(presaleContributions[contributor]).add(contributions[contributor]);
906 
907         // Set contributions to 0
908         presaleContributions[contributor] = 0;
909         contributions[contributor] = 0;
910 
911         // Mint the respective tokens to the contributor
912         token.mint(contributor, tokensToAllocate);
913 
914         // If all tokens were allocated, stop minting functionality
915         if (weiAllocated == PRESALE_WEI.add(weiContributed)) {
916           token.finishMinting();
917         }
918     }
919 
920     function setupDone() 
921         public 
922         onlyOwner 
923         checkAllowed
924     {
925         require(presaleWeiContributed == PRESALE_WEI);
926         super.setupDone();
927     }
928 
929     /// @dev Calculate the PRYZ allocation for the given contributor. The allocation is proportional to the amount of wei contributed.
930     /// @param contributor The address of the contributor
931     /// @return The amount of tokens to allocate
932     function calculateAllocation(address contributor) public constant returns (uint256) {
933         uint256 presale = presaleContributions[contributor].mul(15).div(10); // Multiply by 1.5
934         uint256 totalContribution = presale.add(contributions[contributor]);
935         return totalContribution.mul(MAX_TOKENS).div(PRESALE_WEI_WITH_BONUS.add(weiContributed));
936     }
937 
938     function setupStages() internal {
939         super.setupStages();
940         state.allowFunction(SETUP, this.presaleContribute.selector);
941         state.allowFunction(SALE_ENDED, this.allocateTokens.selector);
942     }
943 
944     function createTokenContract() internal returns(MintableToken) {
945         return new PryzeToken();
946     }
947 
948     function getContributionLimit(address userAddress) internal returns (uint256) {
949         // No contribution cap if whitelisted
950         return whitelisted[userAddress] ? 2**256 - 1 : 0;
951     }
952 
953 }