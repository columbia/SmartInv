1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   /**
26   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   uint256 totalSupply_;
100 
101   /**
102   * @dev total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply_ = totalSupply_.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 contract Whitelistable is Ownable {
261     
262     event LogUserRegistered(address indexed sender, address indexed userAddress);
263     event LogUserUnregistered(address indexed sender, address indexed userAddress);
264     
265     mapping(address => bool) public whitelisted;
266 
267     function registerUser(address userAddress) 
268         public 
269         onlyOwner 
270     {
271         require(userAddress != 0);
272         whitelisted[userAddress] = true;
273         LogUserRegistered(msg.sender, userAddress);
274     }
275 
276     function unregisterUser(address userAddress) 
277         public 
278         onlyOwner 
279     {
280         require(whitelisted[userAddress] == true);
281         whitelisted[userAddress] = false;
282         LogUserUnregistered(msg.sender, userAddress);
283     }
284 }
285 
286 contract DisbursementHandler is Ownable {
287 
288     struct Disbursement {
289         uint256 timestamp;
290         uint256 tokens;
291     }
292 
293     event LogSetup(address indexed vestor, uint256 tokens, uint256 timestamp);
294     event LogChangeTimestamp(address indexed vestor, uint256 index, uint256 timestamp);
295     event LogWithdraw(address indexed to, uint256 value);
296 
297     ERC20 public token;
298     mapping(address => Disbursement[]) public disbursements;
299     mapping(address => uint256) public withdrawnTokens;
300 
301     function DisbursementHandler(address _token) public {
302         token = ERC20(_token);
303     }
304 
305     /// @dev Called by the sale contract to create a disbursement.
306     /// @param vestor The address of the beneficiary.
307     /// @param tokens Amount of tokens to be locked.
308     /// @param timestamp Funds will be locked until this timestamp.
309     function setupDisbursement(
310         address vestor,
311         uint256 tokens,
312         uint256 timestamp
313     )
314         public
315         onlyOwner
316     {
317         require(block.timestamp < timestamp);
318         disbursements[vestor].push(Disbursement(timestamp, tokens));
319         LogSetup(vestor, timestamp, tokens);
320     }
321 
322     /// @dev Change an existing disbursement.
323     /// @param vestor The address of the beneficiary.
324     /// @param timestamp Funds will be locked until this timestamp.
325     /// @param index Index of the DisbursementVesting in the vesting array.
326     function changeTimestamp(
327         address vestor,
328         uint256 index,
329         uint256 timestamp
330     )
331         public
332         onlyOwner
333     {
334         require(block.timestamp < timestamp);
335         require(index < disbursements[vestor].length);
336         disbursements[vestor][index].timestamp = timestamp;
337         LogChangeTimestamp(vestor, index, timestamp);
338     }
339 
340     /// @dev Transfers tokens to a given address
341     /// @param to Address of token receiver
342     /// @param value Number of tokens to transfer
343     function withdraw(address to, uint256 value)
344         public
345     {
346         uint256 maxTokens = calcMaxWithdraw();
347         uint256 withdrawAmount = value < maxTokens ? value : maxTokens;
348         withdrawnTokens[msg.sender] = SafeMath.add(withdrawnTokens[msg.sender], withdrawAmount);
349         token.transfer(to, withdrawAmount);
350         LogWithdraw(to, value);
351     }
352 
353     /// @dev Calculates the maximum amount of vested tokens
354     /// @return Number of vested tokens to withdraw
355     function calcMaxWithdraw()
356         public
357         constant
358         returns (uint256)
359     {
360         uint256 maxTokens = 0;
361         Disbursement[] storage temp = disbursements[msg.sender];
362         for (uint256 i = 0; i < temp.length; i++) {
363             if (block.timestamp > temp[i].timestamp) {
364                 maxTokens = SafeMath.add(maxTokens, temp[i].tokens);
365             }
366         }
367         maxTokens = SafeMath.sub(maxTokens, withdrawnTokens[msg.sender]);
368         return maxTokens;
369     }
370 }
371 
372 library StateMachineLib {
373 
374     struct Stage {
375         // The id of the next stage
376         bytes32 nextId;
377 
378         // The identifiers for the available functions in each stage
379         mapping(bytes4 => bool) allowedFunctions;
380     }
381 
382     struct State {
383         // The current stage id
384         bytes32 currentStageId;
385 
386         // A callback that is called when entering this stage
387         function(bytes32) internal onTransition;
388 
389         // Checks if a stage id is valid
390         mapping(bytes32 => bool) validStage;
391 
392         // Maps stage ids to their Stage structs
393         mapping(bytes32 => Stage) stages;
394     }
395 
396     /// @dev Creates and sets the initial stage. It has to be called before creating any transitions.
397     /// @param stageId The id of the (new) stage to set as initial stage.
398     function setInitialStage(State storage self, bytes32 stageId) internal {
399         self.validStage[stageId] = true;
400         self.currentStageId = stageId;
401     }
402 
403     /// @dev Creates a transition from 'fromId' to 'toId'. If fromId already had a nextId, it deletes the now unreachable stage.
404     /// @param fromId The id of the stage from which the transition begins.
405     /// @param toId The id of the stage that will be reachable from "fromId".
406     function createTransition(State storage self, bytes32 fromId, bytes32 toId) internal {
407         require(self.validStage[fromId]);
408 
409         Stage storage from = self.stages[fromId];
410 
411         // Invalidate the stage that won't be reachable any more
412         if (from.nextId != 0) {
413             self.validStage[from.nextId] = false;
414             delete self.stages[from.nextId];
415         }
416 
417         from.nextId = toId;
418         self.validStage[toId] = true;
419     }
420 
421     /// @dev Goes to the next stage if posible (if the next stage is valid)
422     function goToNextStage(State storage self) internal {
423         Stage storage current = self.stages[self.currentStageId];
424 
425         require(self.validStage[current.nextId]);
426 
427         self.currentStageId = current.nextId;
428 
429         self.onTransition(current.nextId);
430     }
431 
432     /// @dev Checks if the a function is allowed in the current stage.
433     /// @param selector A function selector (bytes4[keccak256(functionSignature)])
434     /// @return true If the function is allowed in the current stage
435     function checkAllowedFunction(State storage self, bytes4 selector) internal constant returns(bool) {
436         return self.stages[self.currentStageId].allowedFunctions[selector];
437     }
438 
439     /// @dev Allow a function in the given stage.
440     /// @param stageId The id of the stage
441     /// @param selector A function selector (bytes4[keccak256(functionSignature)])
442     function allowFunction(State storage self, bytes32 stageId, bytes4 selector) internal {
443         require(self.validStage[stageId]);
444         self.stages[stageId].allowedFunctions[selector] = true;
445     }
446 
447 
448 }
449 
450 contract StateMachine {
451     using StateMachineLib for StateMachineLib.State;
452 
453     event LogTransition(bytes32 indexed stageId, uint256 blockNumber);
454 
455     StateMachineLib.State internal state;
456 
457     /* This modifier performs the conditional transitions and checks that the function 
458      * to be executed is allowed in the current stage
459      */
460     modifier checkAllowed {
461         conditionalTransitions();
462         require(state.checkAllowedFunction(msg.sig));
463         _;
464     }
465 
466     function StateMachine() public {
467         // Register the startConditions function and the onTransition callback
468         state.onTransition = onTransition;
469     }
470 
471     /// @dev Gets the current stage id.
472     /// @return The current stage id.
473     function getCurrentStageId() public view returns(bytes32) {
474         return state.currentStageId;
475     }
476 
477     /// @dev Performs conditional transitions. Can be called by anyone.
478     function conditionalTransitions() public {
479 
480         bytes32 nextId = state.stages[state.currentStageId].nextId;
481 
482         while (state.validStage[nextId]) {
483             StateMachineLib.Stage storage next = state.stages[nextId];
484             // If the next stage's condition is true, go to next stage and continue
485             if (startConditions(nextId)) {
486                 state.goToNextStage();
487                 nextId = next.nextId;
488             } else {
489                 break;
490             }
491         }
492     }
493 
494     /// @dev Determines whether the conditions for transitioning to the given stage are met.
495     /// @return true if the conditions are met for the given stageId. False by default (must override in child contracts).
496     function startConditions(bytes32) internal constant returns(bool) {
497         return false;
498     }
499 
500     /// @dev Callback called when there is a stage transition. It should be overridden for additional functionality.
501     function onTransition(bytes32 stageId) internal {
502         LogTransition(stageId, block.number);
503     }
504 
505 
506 }
507 
508 contract TimedStateMachine is StateMachine {
509 
510     event LogSetStageStartTime(bytes32 indexed stageId, uint256 startTime);
511 
512     // Stores the start timestamp for each stage (the value is 0 if the stage doesn't have a start timestamp).
513     mapping(bytes32 => uint256) internal startTime;
514 
515     /// @dev This function overrides the startConditions function in the parent contract in order to enable automatic transitions that depend on the timestamp.
516     function startConditions(bytes32 stageId) internal constant returns(bool) {
517         // Get the startTime for stage
518         uint256 start = startTime[stageId];
519         // If the startTime is set and has already passed, return true.
520         return start != 0 && block.timestamp > start;
521     }
522 
523     /// @dev Sets the starting timestamp for a stage.
524     /// @param stageId The id of the stage for which we want to set the start timestamp.
525     /// @param timestamp The start timestamp for the given stage. It should be bigger than the current one.
526     function setStageStartTime(bytes32 stageId, uint256 timestamp) internal {
527         require(state.validStage[stageId]);
528         require(timestamp > block.timestamp);
529 
530         startTime[stageId] = timestamp;
531         LogSetStageStartTime(stageId, timestamp);
532     }
533 
534     /// @dev Returns the timestamp for the given stage id.
535     /// @param stageId The id of the stage for which we want to set the start timestamp.
536     function getStageStartTime(bytes32 stageId) public view returns(uint256) {
537         return startTime[stageId];
538     }
539 }
540 
541 contract Sale is Ownable, TimedStateMachine {
542     using SafeMath for uint256;
543 
544     event LogContribution(address indexed contributor, uint256 amountSent, uint256 excessRefunded);
545     event LogTokenAllocation(address indexed contributor, uint256 contribution, uint256 tokens);
546     event LogDisbursement(address indexed beneficiary, uint256 tokens);
547 
548     // Stages for the state machine
549     bytes32 public constant SETUP = "setup";
550     bytes32 public constant SETUP_DONE = "setupDone";
551     bytes32 public constant SALE_IN_PROGRESS = "saleInProgress";
552     bytes32 public constant SALE_ENDED = "saleEnded";
553 
554     mapping(address => uint256) public contributions;
555 
556     uint256 public weiContributed = 0;
557     uint256 public contributionCap;
558 
559     // Wallet where funds will be sent
560     address public wallet;
561 
562     MintableToken public token;
563 
564     DisbursementHandler public disbursementHandler;
565 
566     function Sale(
567         address _wallet, 
568         uint256 _contributionCap
569     ) 
570         public 
571     {
572         require(_wallet != 0);
573         require(_contributionCap != 0);
574 
575         wallet = _wallet;
576 
577         token = createTokenContract();
578         disbursementHandler = new DisbursementHandler(token);
579 
580         contributionCap = _contributionCap;
581 
582         setupStages();
583     }
584 
585     function() external payable {
586         contribute();
587     }
588 
589     /// @dev Sets the start timestamp for the SALE_IN_PROGRESS stage.
590     /// @param timestamp The start timestamp.
591     function setSaleStartTime(uint256 timestamp) 
592         external 
593         onlyOwner 
594         checkAllowed
595     {
596         // require(_startTime < getStageStartTime(SALE_ENDED));
597         setStageStartTime(SALE_IN_PROGRESS, timestamp);
598     }
599 
600     /// @dev Sets the start timestamp for the SALE_ENDED stage.
601     /// @param timestamp The start timestamp.
602     function setSaleEndTime(uint256 timestamp) 
603         external 
604         onlyOwner 
605         checkAllowed
606     {
607         require(getStageStartTime(SALE_IN_PROGRESS) < timestamp);
608         setStageStartTime(SALE_ENDED, timestamp);
609     }
610 
611     /// @dev Called in the SETUP stage, check configurations and to go to the SETUP_DONE stage.
612     function setupDone() 
613         public 
614         onlyOwner 
615         checkAllowed
616     {
617         uint256 _startTime = getStageStartTime(SALE_IN_PROGRESS);
618         uint256 _endTime = getStageStartTime(SALE_ENDED);
619         require(block.timestamp < _startTime);
620         require(_startTime < _endTime);
621 
622         state.goToNextStage();
623     }
624 
625     /// @dev Called by users to contribute ETH to the sale.
626     function contribute() 
627         public 
628         payable
629         checkAllowed 
630     {
631         require(msg.value > 0);   
632 
633         uint256 contributionLimit = getContributionLimit(msg.sender);
634         require(contributionLimit > 0);
635 
636         // Check that the user is allowed to contribute
637         uint256 totalContribution = contributions[msg.sender].add(msg.value);
638         uint256 excess = 0;
639 
640         // Check if it goes over the eth cap for the sale.
641         if (weiContributed.add(msg.value) > contributionCap) {
642             // Subtract the excess
643             excess = weiContributed.add(msg.value).sub(contributionCap);
644             totalContribution = totalContribution.sub(excess);
645         }
646 
647         // Check if it goes over the contribution limit of the user. 
648         if (totalContribution > contributionLimit) {
649             excess = excess.add(totalContribution).sub(contributionLimit);
650             contributions[msg.sender] = contributionLimit;
651         } else {
652             contributions[msg.sender] = totalContribution;
653         }
654 
655         // We are only able to refund up to msg.value because the contract will not contain ether
656         // excess = excess < msg.value ? excess : msg.value;
657         require(excess <= msg.value);
658 
659         weiContributed = weiContributed.add(msg.value).sub(excess);
660 
661         if (excess > 0) {
662             msg.sender.transfer(excess);
663         }
664 
665         wallet.transfer(this.balance);
666 
667         assert(contributions[msg.sender] <= contributionLimit);
668         LogContribution(msg.sender, msg.value, excess);
669     }
670 
671     /// @dev Create a disbursement of tokens.
672     /// @param beneficiary The beneficiary of the disbursement.
673     /// @param tokenAmount Amount of tokens to be locked.
674     /// @param timestamp Tokens will be locked until this timestamp.
675     function distributeTimelockedTokens(
676         address beneficiary,
677         uint256 tokenAmount,
678         uint256 timestamp
679     ) 
680         public
681         onlyOwner
682         checkAllowed
683     { 
684         disbursementHandler.setupDisbursement(
685             beneficiary,
686             tokenAmount,
687             timestamp
688         );
689         token.mint(disbursementHandler, tokenAmount);
690         LogDisbursement(beneficiary, tokenAmount);
691     }
692     
693     function setupStages() internal {
694         // Set the stages
695         state.setInitialStage(SETUP);
696         state.createTransition(SETUP, SETUP_DONE);
697         state.createTransition(SETUP_DONE, SALE_IN_PROGRESS);
698         state.createTransition(SALE_IN_PROGRESS, SALE_ENDED);
699 
700         state.allowFunction(SETUP, this.distributeTimelockedTokens.selector);
701         state.allowFunction(SETUP, this.setSaleStartTime.selector);
702         state.allowFunction(SETUP, this.setSaleEndTime.selector);
703         state.allowFunction(SETUP, this.setupDone.selector);
704         state.allowFunction(SALE_IN_PROGRESS, this.contribute.selector);
705         state.allowFunction(SALE_IN_PROGRESS, 0); // fallback
706     }
707 
708     // Override in the child sales
709     function createTokenContract() internal returns (MintableToken);
710     function getContributionLimit(address userAddress) public view returns (uint256);
711 
712     /// @dev Stage start conditions.
713     function startConditions(bytes32 stageId) internal constant returns (bool) {
714         // If the cap has been reached, end the sale.
715         if (stageId == SALE_ENDED && contributionCap <= weiContributed) {
716             return true;
717         }
718         return super.startConditions(stageId);
719     }
720 
721     /// @dev State transitions callbacks.
722     function onTransition(bytes32 stageId) internal {
723         if (stageId == SALE_ENDED) { 
724             onSaleEnded(); 
725         }
726         super.onTransition(stageId);
727     }
728 
729     /// @dev Callback that gets called when entering the SALE_ENDED stage.
730     function onSaleEnded() internal {}
731 }
732 
733 contract ERC223ReceivingContract {
734 
735     /// @dev Standard ERC223 function that will handle incoming token transfers.
736     /// @param _from  Token sender address.
737     /// @param _value Amount of tokens.
738     /// @param _data  Transaction metadata.
739     function tokenFallback(address _from, uint _value, bytes _data) public;
740 
741 }
742 
743 contract ERC223Basic is ERC20Basic {
744 
745     /**
746       * @dev Transfer the specified amount of tokens to the specified address.
747       *      Now with a new parameter _data.
748       *
749       * @param _to    Receiver address.
750       * @param _value Amount of tokens that will be transferred.
751       * @param _data  Transaction metadata.
752       */
753     function transfer(address _to, uint _value, bytes _data) public returns (bool);
754 
755     /**
756       * @dev triggered when transfer is successfully called.
757       *
758       * @param _from  Sender address.
759       * @param _to    Receiver address.
760       * @param _value Amount of tokens that will be transferred.
761       * @param _data  Transaction metadata.
762       */
763     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
764 }
765 
766 
767 contract ERC223BasicToken is ERC223Basic, BasicToken {
768 
769     /**
770       * @dev Transfer the specified amount of tokens to the specified address.
771       *      Invokes the `tokenFallback` function if the recipient is a contract.
772       *      The token transfer fails if the recipient is a contract
773       *      but does not implement the `tokenFallback` function
774       *      or the fallback function to receive funds.
775       *
776       * @param _to    Receiver address.
777       * @param _value Amount of tokens that will be transferred.
778       * @param _data  Transaction metadata.
779       */
780     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
781         // Standard function transfer similar to ERC20 transfer with no _data .
782         // Added due to backwards compatibility reasons .
783         uint codeLength;
784 
785         assembly {
786             // Retrieve the size of the code on target address, this needs assembly .
787             codeLength := extcodesize(_to)
788         }
789 
790         require(super.transfer(_to, _value));
791 
792         if(codeLength>0) {
793             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
794             receiver.tokenFallback(msg.sender, _value, _data);
795         }
796         Transfer(msg.sender, _to, _value, _data);
797         return true;
798     }
799 
800       /**
801       * @dev Transfer the specified amount of tokens to the specified address.
802       *      Invokes the `tokenFallback` function if the recipient is a contract.
803       *      The token transfer fails if the recipient is a contract
804       *      but does not implement the `tokenFallback` function
805       *      or the fallback function to receive funds.
806       *
807       * @param _to    Receiver address.
808       * @param _value Amount of tokens that will be transferred.
809       */
810     function transfer(address _to, uint256 _value) public returns (bool) {
811         bytes memory empty;
812         require(transfer(_to, _value, empty));
813         return true;
814     }
815 
816 }
817 
818 contract DetailedERC20 is ERC20 {
819   string public name;
820   string public symbol;
821   uint8 public decimals;
822 
823   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
824     name = _name;
825     symbol = _symbol;
826     decimals = _decimals;
827   }
828 }
829 
830 contract DetherToken is DetailedERC20, MintableToken, ERC223BasicToken {
831     string constant NAME = "Dether";
832     string constant SYMBOL = "DTH";
833     uint8 constant DECIMALS = 18;
834 
835     /**
836       *@dev Constructor that set Detailed of the ERC20 token.
837       */
838     function DetherToken()
839         DetailedERC20(NAME, SYMBOL, DECIMALS)
840         public
841     {}
842 }
843 
844 
845 contract DetherSale is Sale, Whitelistable {
846 
847     uint256 public constant PRESALE_WEI = 3956 ether * 1.15 + 490 ether; // Amount raised in the presale including bonus
848 
849     uint256 public constant DECIMALS_MULTIPLIER = 1000000000000000000;
850     uint256 public constant MAX_DTH = 100000000 * DECIMALS_MULTIPLIER;
851 
852     // MAX_WEI - PRESALE_WEI
853     // TODO: change to actual amount
854     uint256 public constant WEI_CAP = 10554 ether;
855 
856     // Duration of the whitelisting phase
857     uint256 public constant WHITELISTING_DURATION = 2 days;
858 
859     // Contribution limit for the whitelisting phase
860     uint256 public constant WHITELISTING_MAX_CONTRIBUTION = 5 ether;
861 
862     // Contribution limit for the public sale
863     uint256 public constant PUBLIC_MAX_CONTRIBUTION = 2**256 - 1;
864 
865     // Minimum contribution allowed
866     uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
867 
868     // wei per DTH
869     uint256 public weiPerDTH;
870     // true if the locked tokens have been distributed
871     bool private lockedTokensDistributed;
872     // true if the presale tokens have been allocated
873     bool private presaleAllocated;
874 
875     // Address for the presale buyers (Dether team will distribute manually)
876     address public presaleAddress;
877 
878     uint256 private weiAllocated;
879 
880     // Contribution limits specified for the presale
881     mapping(address => uint256) public presaleMaxContribution;
882 
883     function DetherSale(address _wallet, address _presaleAddress) Sale(_wallet, WEI_CAP) public {
884       presaleAddress = _presaleAddress;
885     }
886 
887     /// @dev Distributes timed locked tokens
888     function performInitialAllocations() external onlyOwner checkAllowed {
889         require(lockedTokensDistributed == false);
890         lockedTokensDistributed = true;
891 
892         // Advisors
893         distributeTimelockedTokens(0x4dc976cEd66d1B87C099B338E1F1388AE657377d, MAX_DTH.mul(3).div(100), now + 6 * 4 weeks);
894 
895         // Bounty
896         distributeTimelockedTokens(0xfEF675cC3068Ee798f2312e82B12c841157A0A0E, MAX_DTH.mul(3).div(100), now + 1 weeks);
897 
898         // Early Contributors
899         distributeTimelockedTokens(0x8F38C4ddFE09Bd22545262FE160cf441D43d2489, MAX_DTH.mul(25).div(1000), now + 6 * 4 weeks);
900 
901         distributeTimelockedTokens(0x87a4eb1c9fdef835DC9197FAff3E09b8007ADe5b, MAX_DTH.mul(25).div(1000), now + 6 * 4 weeks);
902 
903         // Strategic Partnerships
904         distributeTimelockedTokens(0x6f63D5DF2D8644851cBb5F8607C845704C008284, MAX_DTH.mul(11).div(100), now + 1 weeks);
905 
906         // Team (locked 3 years, 6 months release)
907         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 6 * 4 weeks);
908         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 2 * 6 * 4 weeks);
909         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 3 * 6 * 4 weeks);
910         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 4 * 6 * 4 weeks);
911         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 5 * 6 * 4 weeks);
912         distributeTimelockedTokens(0x24c14796f401D77fc401F9c2FA1dF42A136EbF83, MAX_DTH.mul(3).div(100), now + 6 * 6 * 4 weeks);
913     }
914 
915     /// @dev Registers a user and sets the maximum contribution amount for the whitelisting period
916     function registerPresaleContributor(address userAddress, uint256 maxContribution)
917         external
918         onlyOwner
919     {
920         // Specified contribution has to be lower than the max
921         require(maxContribution <= WHITELISTING_MAX_CONTRIBUTION);
922 
923         // Register user (Whitelistable contract)
924         registerUser(userAddress);
925 
926         // Set contribution
927         presaleMaxContribution[userAddress] = maxContribution;
928     }
929 
930     /// @dev Called to allocate the tokens depending on eth contributed.
931     /// @param contributor The address of the contributor.
932     function allocateTokens(address contributor)
933         external
934         checkAllowed
935     {
936         require(presaleAllocated);
937         require(contributions[contributor] != 0);
938 
939         // We keep a record of how much wei contributed has already been used for allocations
940         weiAllocated = weiAllocated.add(contributions[contributor]);
941 
942         // Mint the respective tokens to the contributor
943         token.mint(contributor, contributions[contributor].mul(DECIMALS_MULTIPLIER).div(weiPerDTH));
944 
945         // Set contributions to 0
946         contributions[contributor] = 0;
947 
948         // If all tokens were allocated, stop minting functionality
949         // and send the remaining (rounding errors) tokens to the owner
950         if (weiAllocated == weiContributed) {
951           uint256 remaining = MAX_DTH.sub(token.totalSupply());
952           token.mint(owner, remaining);
953           token.finishMinting();
954         }
955     }
956 
957     /// @dev Called to allocate the tokens for presale address.
958     function presaleAllocateTokens()
959         external
960         checkAllowed
961     {
962         require(!presaleAllocated);
963         presaleAllocated = true;
964 
965         // Mint the respective tokens to the contributor
966         token.mint(presaleAddress, PRESALE_WEI.mul(DECIMALS_MULTIPLIER).div(weiPerDTH));
967     }
968 
969     function contribute()
970         public
971         payable
972         checkAllowed
973     {
974         require(msg.value >= MIN_CONTRIBUTION);
975 
976         super.contribute();
977     }
978 
979     /// @dev The limit will be different for every address during the whitelist period, and after that phase there is no limit for contributions.
980     function getContributionLimit(address userAddress) public view returns (uint256) {
981         uint256 saleStartTime = getStageStartTime(SALE_IN_PROGRESS);
982 
983         // If not whitelisted or sale has not started, return 0
984         if (!whitelisted[userAddress] || block.timestamp < saleStartTime) {
985             return 0;
986         }
987 
988         // Are we in the first two days?
989         bool whitelistingPeriod = block.timestamp - saleStartTime <= WHITELISTING_DURATION;
990 
991         // If we are in the whitelisting period, return the contribution limit for the user
992         // If not, return the public max contribution
993         return whitelistingPeriod ? presaleMaxContribution[userAddress] : PUBLIC_MAX_CONTRIBUTION;
994     }
995 
996     function createTokenContract() internal returns(MintableToken) {
997         return new DetherToken();
998     }
999 
1000     function setupStages() internal {
1001         super.setupStages();
1002         state.allowFunction(SETUP, this.performInitialAllocations.selector);
1003         state.allowFunction(SALE_ENDED, this.allocateTokens.selector);
1004         state.allowFunction(SALE_ENDED, this.presaleAllocateTokens.selector);
1005     }
1006 
1007     /// @dev The price will be the total wei contributed divided by the amount of tokens to be allocated to contributors.
1008     function calculatePrice() public view returns(uint256) {
1009         return weiContributed.add(PRESALE_WEI).div(60000000).add(1);
1010     }
1011 
1012     function onSaleEnded() internal {
1013         // Calculate DTH per Wei
1014         weiPerDTH = calculatePrice();
1015     }
1016 }