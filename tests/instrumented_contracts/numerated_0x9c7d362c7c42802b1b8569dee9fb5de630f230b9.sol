1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: zeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (a == 0) {
129       return 0;
130     }
131 
132     c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return a / b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * See https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender)
187     public view returns (uint256);
188 
189   function transferFrom(address from, address to, uint256 value)
190     public returns (bool);
191 
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
201 
202 /**
203  * @title SafeERC20
204  * @dev Wrappers around ERC20 operations that throw on failure.
205  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
206  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
207  */
208 library SafeERC20 {
209   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
210     require(token.transfer(to, value));
211   }
212 
213   function safeTransferFrom(
214     ERC20 token,
215     address from,
216     address to,
217     uint256 value
218   )
219     internal
220   {
221     require(token.transferFrom(from, to, value));
222   }
223 
224   function safeApprove(ERC20 token, address spender, uint256 value) internal {
225     require(token.approve(spender, value));
226   }
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
230 
231 /**
232  * @title Basic token
233  * @dev Basic version of StandardToken, with no allowances.
234  */
235 contract BasicToken is ERC20Basic {
236   using SafeMath for uint256;
237 
238   mapping(address => uint256) balances;
239 
240   uint256 totalSupply_;
241 
242   /**
243   * @dev Total number of tokens in existence
244   */
245   function totalSupply() public view returns (uint256) {
246     return totalSupply_;
247   }
248 
249   /**
250   * @dev Transfer token for a specified address
251   * @param _to The address to transfer to.
252   * @param _value The amount to be transferred.
253   */
254   function transfer(address _to, uint256 _value) public returns (bool) {
255     require(_to != address(0));
256     require(_value <= balances[msg.sender]);
257 
258     balances[msg.sender] = balances[msg.sender].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     emit Transfer(msg.sender, _to, _value);
261     return true;
262   }
263 
264   /**
265   * @dev Gets the balance of the specified address.
266   * @param _owner The address to query the the balance of.
267   * @return An uint256 representing the amount owned by the passed address.
268   */
269   function balanceOf(address _owner) public view returns (uint256) {
270     return balances[_owner];
271   }
272 
273 }
274 
275 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
276 
277 /**
278  * @title Standard ERC20 token
279  *
280  * @dev Implementation of the basic standard token.
281  * https://github.com/ethereum/EIPs/issues/20
282  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
283  */
284 contract StandardToken is ERC20, BasicToken {
285 
286   mapping (address => mapping (address => uint256)) internal allowed;
287 
288 
289   /**
290    * @dev Transfer tokens from one address to another
291    * @param _from address The address which you want to send tokens from
292    * @param _to address The address which you want to transfer to
293    * @param _value uint256 the amount of tokens to be transferred
294    */
295   function transferFrom(
296     address _from,
297     address _to,
298     uint256 _value
299   )
300     public
301     returns (bool)
302   {
303     require(_to != address(0));
304     require(_value <= balances[_from]);
305     require(_value <= allowed[_from][msg.sender]);
306 
307     balances[_from] = balances[_from].sub(_value);
308     balances[_to] = balances[_to].add(_value);
309     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
310     emit Transfer(_from, _to, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
316    * Beware that changing an allowance with this method brings the risk that someone may use both the old
317    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
318    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
319    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320    * @param _spender The address which will spend the funds.
321    * @param _value The amount of tokens to be spent.
322    */
323   function approve(address _spender, uint256 _value) public returns (bool) {
324     allowed[msg.sender][_spender] = _value;
325     emit Approval(msg.sender, _spender, _value);
326     return true;
327   }
328 
329   /**
330    * @dev Function to check the amount of tokens that an owner allowed to a spender.
331    * @param _owner address The address which owns the funds.
332    * @param _spender address The address which will spend the funds.
333    * @return A uint256 specifying the amount of tokens still available for the spender.
334    */
335   function allowance(
336     address _owner,
337     address _spender
338    )
339     public
340     view
341     returns (uint256)
342   {
343     return allowed[_owner][_spender];
344   }
345 
346   /**
347    * @dev Increase the amount of tokens that an owner allowed to a spender.
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(
356     address _spender,
357     uint256 _addedValue
358   )
359     public
360     returns (bool)
361   {
362     allowed[msg.sender][_spender] = (
363       allowed[msg.sender][_spender].add(_addedValue));
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    * approve should be called when allowed[_spender] == 0. To decrement
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _subtractedValue The amount of tokens to decrease the allowance by.
376    */
377   function decreaseApproval(
378     address _spender,
379     uint256 _subtractedValue
380   )
381     public
382     returns (bool)
383   {
384     uint256 oldValue = allowed[msg.sender][_spender];
385     if (_subtractedValue > oldValue) {
386       allowed[msg.sender][_spender] = 0;
387     } else {
388       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
389     }
390     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391     return true;
392   }
393 
394 }
395 
396 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
397 
398 /**
399  * @title Mintable token
400  * @dev Simple ERC20 Token example, with mintable token creation
401  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
402  */
403 contract MintableToken is StandardToken, Ownable {
404   event Mint(address indexed to, uint256 amount);
405   event MintFinished();
406 
407   bool public mintingFinished = false;
408 
409 
410   modifier canMint() {
411     require(!mintingFinished);
412     _;
413   }
414 
415   modifier hasMintPermission() {
416     require(msg.sender == owner);
417     _;
418   }
419 
420   /**
421    * @dev Function to mint tokens
422    * @param _to The address that will receive the minted tokens.
423    * @param _amount The amount of tokens to mint.
424    * @return A boolean that indicates if the operation was successful.
425    */
426   function mint(
427     address _to,
428     uint256 _amount
429   )
430     hasMintPermission
431     canMint
432     public
433     returns (bool)
434   {
435     totalSupply_ = totalSupply_.add(_amount);
436     balances[_to] = balances[_to].add(_amount);
437     emit Mint(_to, _amount);
438     emit Transfer(address(0), _to, _amount);
439     return true;
440   }
441 
442   /**
443    * @dev Function to stop minting new tokens.
444    * @return True if the operation was successful.
445    */
446   function finishMinting() onlyOwner canMint public returns (bool) {
447     mintingFinished = true;
448     emit MintFinished();
449     return true;
450   }
451 }
452 
453 // File: contracts/NectarToken.sol
454 
455 contract NectarToken is MintableToken {
456     string public name = "Nectar";
457     string public symbol = "NCT";
458     uint8 public decimals = 18;
459 
460     bool public transfersEnabled = false;
461     event TransfersEnabled();
462 
463     // Disable transfers until after the sale
464     modifier whenTransfersEnabled() {
465         require(transfersEnabled, "Transfers not enabled");
466         _;
467     }
468 
469     modifier whenTransfersNotEnabled() {
470         require(!transfersEnabled, "Transfers enabled");
471         _;
472     }
473 
474     function enableTransfers() public onlyOwner whenTransfersNotEnabled {
475         transfersEnabled = true;
476         emit TransfersEnabled();
477     }
478 
479     function transfer(address to, uint256 value) public whenTransfersEnabled returns (bool) {
480         return super.transfer(to, value);
481     }
482 
483     function transferFrom(address from, address to, uint256 value) public whenTransfersEnabled returns (bool) {
484         return super.transferFrom(from, to, value);
485     }
486 
487     // Approves and then calls the receiving contract
488     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
489         allowed[msg.sender][_spender] = _value;
490         emit Approval(msg.sender, _spender, _value);
491 
492         // Call the receiveApproval function on the contract you want to be notified.
493         // This crafts the function signature manually so one doesn't have to include a contract in here just for this.
494         //
495         // receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
496         //
497         // It is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
498 
499         // solium-disable-next-line security/no-low-level-calls, indentation
500         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))),
501             msg.sender, _value, this, _extraData), "receiveApproval failed");
502         return true;
503     }
504 }
505 
506 // File: contracts/ArbiterStaking.sol
507 
508 //import "./ArbiterStaking.sol";
509 
510 
511 
512 contract BountyRegistry is Pausable {
513     using SafeMath for uint256;
514     using SafeERC20 for NectarToken;
515 
516     string public constant VERSION = "1.0.0";
517 
518     struct Bounty {
519         uint128 guid;
520         address author;
521         uint256 amount;
522         string artifactURI;
523         uint256 numArtifacts;
524         uint256 expirationBlock;
525         address assignedArbiter;
526         bool quorumReached;
527         uint256 quorumBlock;
528         uint256 quorumMask;
529     }
530 
531     struct Assertion {
532         address author;
533         uint256 bid;
534         uint256 mask;
535         uint256 commitment;
536         uint256 nonce;
537         uint256 verdicts;
538         string metadata;
539     }
540 
541     struct Vote {
542         address author;
543         uint256 votes;
544         bool validBloom;
545     }
546 
547     event AddedArbiter(
548         address arbiter,
549         uint256 blockNumber
550     );
551 
552     event RemovedArbiter(
553         address arbiter,
554         uint256 blockNumber
555     );
556 
557     event NewBounty(
558         uint128 guid,
559         address author,
560         uint256 amount,
561         string artifactURI,
562         uint256 expirationBlock
563     );
564 
565     event NewAssertion(
566         uint128 bountyGuid,
567         address author,
568         uint256 index,
569         uint256 bid,
570         uint256 mask,
571         uint256 numArtifacts,
572         uint256 commitment
573     );
574 
575     event RevealedAssertion(
576         uint128 bountyGuid,
577         address author,
578         uint256 index,
579         uint256 nonce,
580         uint256 verdicts,
581         uint256 numArtifacts,
582         string metadata
583     );
584 
585     event NewVote(
586         uint128 bountyGuid,
587         uint256 votes,
588         uint256 numArtifacts,
589         address voter
590     );
591 
592     event QuorumReached(
593         uint128 bountyGuid
594     );
595 
596     event SettledBounty(
597         uint128 bountyGuid,
598         address settler,
599         uint256 payout
600     );
601 
602     ArbiterStaking public staking;
603     NectarToken internal token;
604 
605     uint256 public constant BOUNTY_FEE = 62500000000000000;
606     uint256 public constant ASSERTION_FEE = 31250000000000000;
607     uint256 public constant BOUNTY_AMOUNT_MINIMUM = 62500000000000000;
608     uint256 public constant ASSERTION_BID_MINIMUM = 62500000000000000;
609     uint256 public constant ARBITER_LOOKBACK_RANGE = 100;
610     uint256 public constant MAX_DURATION = 100; // BLOCKS
611     uint256 public constant ASSERTION_REVEAL_WINDOW = 25; // BLOCKS
612     uint256 public constant MALICIOUS_VOTE_COEFFICIENT = 10;
613     uint256 public constant BENIGN_VOTE_COEFFICIENT = 1;
614     uint256 public constant VALID_HASH_PERIOD = 256; // number of blocks in the past you can still get a blockhash
615 
616 
617     uint256 public arbiterCount;
618     uint256 public arbiterVoteWindow;
619     uint128[] public bountyGuids;
620     mapping (uint128 => Bounty) public bountiesByGuid;
621     mapping (uint128 => Assertion[]) public assertionsByGuid;
622     mapping (uint128 => Vote[]) public votesByGuid;
623     mapping (uint128 => uint256[8]) public bloomByGuid;
624     mapping (uint128 => mapping (uint256 => uint256)) public quorumVotesByGuid;
625     mapping (address => bool) public arbiters;
626     mapping (uint256 => mapping (uint256 => uint256)) public voteCountByGuid;
627     mapping (uint256 => mapping (address => bool)) public arbiterVoteRegistryByGuid;
628     mapping (uint256 => mapping (address => bool)) public expertAssertionResgistryByGuid;
629     mapping (uint128 => mapping (address => bool)) public bountySettled;
630 
631     /**
632      * Construct a new BountyRegistry
633      *
634      * @param _token address of NCT token to use
635      */
636     constructor(address _token, address _arbiterStaking, uint256 _arbiterVoteWindow) Ownable() public {
637         owner = msg.sender;
638         token = NectarToken(_token);
639         staking = ArbiterStaking(_arbiterStaking);
640         arbiterVoteWindow = _arbiterVoteWindow;
641     }
642 
643     /**
644      * Function to check if an address is a valid arbiter
645      *
646      * @param addr The address to check
647      * @return true if addr is a valid arbiter else false
648      */
649     function isArbiter(address addr) public view returns (bool) {
650         // Remove arbiter requirements for now, while we are whitelisting
651         // arbiters on the platform
652         //return arbiters[addr] && staking.isEligible(addr);
653         return arbiters[addr];
654     }
655 
656     /** Function only callable by arbiter */
657     modifier onlyArbiter() {
658         require(isArbiter(msg.sender), "msg.sender is not an arbiter");
659         _;
660     }
661 
662     /**
663      * Function called to add an arbiter, emits an evevnt with the added arbiter
664      * and block number used to calculate their arbiter status based on public
665      * arbiter selection algorithm.
666      *
667      * @param newArbiter the arbiter to add
668      * @param blockNumber the block number the determination to add was
669      *      calculated from
670      */
671     function addArbiter(address newArbiter, uint256 blockNumber) external whenNotPaused onlyOwner {
672         require(newArbiter != address(0), "Invalid arbiter address");
673         require(!arbiters[newArbiter], "Address is already an arbiter");
674         arbiterCount = arbiterCount.add(1);
675         arbiters[newArbiter] = true;
676         emit AddedArbiter(newArbiter, blockNumber);
677     }
678 
679     /**
680      * Function called to remove an arbiter, emits an evevnt with the removed
681      * arbiter and block number used to calculate their arbiter status based on
682      * public arbiter selection algorithm.
683      *
684      * @param arbiter the arbiter to remove
685      * @param blockNumber the block number the determination to remove was
686      *      calculated from
687      */
688     function removeArbiter(address arbiter, uint256 blockNumber) external whenNotPaused onlyOwner {
689         arbiters[arbiter] = false;
690         arbiterCount = arbiterCount.sub(1);
691         emit RemovedArbiter(arbiter, blockNumber);
692     }
693 
694     /**
695      * Function called by end users and ambassadors to post a bounty
696      *
697      * @param guid the guid of the bounty, must be unique
698      * @param amount the amount of NCT to post as a reward
699      * @param artifactURI uri of the artifacts comprising this bounty
700      * @param durationBlocks duration of this bounty in blocks
701      */
702     function postBounty(
703         uint128 guid,
704         uint256 amount,
705         string artifactURI,
706         uint256 numArtifacts,
707         uint256 durationBlocks,
708         uint256[8] bloom
709     )
710     external
711     whenNotPaused
712     {
713         // Check if a bounty with this GUID has already been initialized
714         require(bountiesByGuid[guid].author == address(0), "GUID already in use");
715         // Check that our bounty amount is sufficient
716         require(amount >= BOUNTY_AMOUNT_MINIMUM, "Bounty amount below minimum");
717         // Check that our URI is non-empty
718         require(bytes(artifactURI).length > 0, "Invalid artifact URI");
719         // Check that our number of artifacts is valid
720         require(numArtifacts <= 256, "Too many artifacts in bounty");
721         require(numArtifacts > 0, "Not enough artifacts in bounty");
722         // Check that our duration is non-zero and less than or equal to the max
723         require(durationBlocks > 0 && durationBlocks <= MAX_DURATION, "Invalid bounty duration");
724 
725         // Assess fees and transfer bounty amount into escrow
726         token.safeTransferFrom(msg.sender, address(this), amount.add(BOUNTY_FEE));
727 
728         bountiesByGuid[guid].guid = guid;
729         bountiesByGuid[guid].author = msg.sender;
730         bountiesByGuid[guid].amount = amount;
731         bountiesByGuid[guid].artifactURI = artifactURI;
732 
733         // Number of artifacts is submitted as part of the bounty, we have no
734         // way to check how many exist in this IPFS resource. For an IPFS
735         // resource with N artifacts, if numArtifacts < N only the first
736         // numArtifacts artifacts are included in this bounty, if numArtifacts >
737         // N then the last N - numArtifacts bounties are considered benign.
738         bountiesByGuid[guid].numArtifacts = numArtifacts;
739         bountiesByGuid[guid].expirationBlock = durationBlocks.add(block.number);
740 
741         bountyGuids.push(guid);
742 
743         bloomByGuid[guid] = bloom;
744 
745         emit NewBounty(
746             bountiesByGuid[guid].guid,
747             bountiesByGuid[guid].author,
748             bountiesByGuid[guid].amount,
749             bountiesByGuid[guid].artifactURI,
750             bountiesByGuid[guid].expirationBlock
751         );
752     }
753 
754     /**
755      * Function called by security experts to post an assertion on a bounty
756      *
757      * @param bountyGuid the guid of the bounty to assert on
758      * @param bid the amount of NCT to stake
759      * @param mask the artifacts to assert on from the set in the bounty
760      * @param commitment a commitment hash of the verdicts being asserted, equal
761      *      to keccak256(verdicts ^ keccak256(nonce)) where nonce != 0
762      */
763     function postAssertion(
764         uint128 bountyGuid,
765         uint256 bid,
766         uint256 mask,
767         uint256 commitment
768     )
769         external
770         whenNotPaused
771     {
772         // Check if this bounty has been initialized
773         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
774         // Check that our bid amount is sufficient
775         require(bid >= ASSERTION_BID_MINIMUM, "Assertion bid below minimum");
776         // Check if this bounty is active
777         require(bountiesByGuid[bountyGuid].expirationBlock > block.number, "Bounty inactive");
778         // Check if the sender has already made an assertion
779         require(expertAssertionResgistryByGuid[bountyGuid][msg.sender] == false, "Sender has already asserted");
780         // Assess fees and transfer bid amount into escrow
781         token.safeTransferFrom(msg.sender, address(this), bid.add(ASSERTION_FEE));
782 
783         expertAssertionResgistryByGuid[bountyGuid][msg.sender] = true;
784 
785         Assertion memory a = Assertion(
786             msg.sender,
787             bid,
788             mask,
789             commitment,
790             0,
791             0,
792             ""
793         );
794 
795         uint256 index = assertionsByGuid[bountyGuid].push(a) - 1;
796         uint256 numArtifacts = bountiesByGuid[bountyGuid].numArtifacts;
797 
798         emit NewAssertion(
799             bountyGuid,
800             a.author,
801             index,
802             a.bid,
803             a.mask,
804             numArtifacts,
805             a.commitment
806         );
807     }
808 
809     // https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity
810     function uint256_to_bytes(uint256 x) internal pure returns (bytes b) {
811         b = new bytes(32);
812         // solium-disable-next-line security/no-inline-assembly
813         assembly { mstore(add(b, 32), x) }
814     }
815 
816     /**
817      * Function called by security experts to reveal an assertion after bounty
818      * expiration
819      *
820      * @param bountyGuid the guid of the bounty to assert on
821      * @param assertionId the id of the assertion to reveal
822      * @param assertionId the id of the assertion to reveal
823      * @param nonce the nonce used to generate the commitment hash
824      * @param verdicts the verdicts making up this assertion
825      * @param metadata optional metadata to include in the assertion
826      */
827     function revealAssertion(
828         uint128 bountyGuid,
829         uint256 assertionId,
830         uint256 nonce,
831         uint256 verdicts,
832         string metadata
833     )
834         external
835         whenNotPaused
836     {
837         // Check if this bounty has been initialized
838         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
839         // Check that the bounty is no longer active
840         require(bountiesByGuid[bountyGuid].expirationBlock <= block.number, "Bounty is still active");
841         // Check if the reveal round has closed
842         require(bountiesByGuid[bountyGuid].expirationBlock.add(ASSERTION_REVEAL_WINDOW) > block.number, "Reveal round has closed");
843         // Get numArtifacts to help decode all zero verdicts
844         uint256 numArtifacts = bountiesByGuid[bountyGuid].numArtifacts;
845 
846         // Zero is defined as an invalid nonce
847         require(nonce != 0, "Invalid nonce");
848 
849         // Check our id
850         require(assertionId < assertionsByGuid[bountyGuid].length, "Invalid assertion ID");
851 
852         Assertion storage a = assertionsByGuid[bountyGuid][assertionId];
853         require(a.author == msg.sender, "Incorrect assertion author");
854         require(a.nonce == 0, "Bounty already revealed");
855 
856         // Check our commitment hash, by xor-ing verdicts with the hashed nonce
857         // and the sender's address prevent copying assertions by submitting the
858         // same commitment hash and nonce during the reveal round
859         uint256 hashed_nonce = uint256(keccak256(uint256_to_bytes(nonce)));
860         uint256 commitment = uint256(keccak256(uint256_to_bytes(verdicts ^ hashed_nonce ^ uint256(msg.sender))));
861         require(commitment == a.commitment, "Commitment hash mismatch");
862 
863         a.nonce = nonce;
864         a.verdicts = verdicts;
865         a.metadata = metadata;
866 
867         emit RevealedAssertion(
868             bountyGuid,
869             a.author,
870             assertionId,
871             a.nonce,
872             a.verdicts,
873             numArtifacts,
874             a.metadata
875         );
876     }
877 
878     /**
879      * Function called by arbiter after bounty expiration to settle with their
880      * ground truth determination and pay out assertion rewards
881      *
882      * @param bountyGuid the guid of the bounty to settle
883      * @param votes bitset of votes representing ground truth for the
884      *      bounty's artifacts
885      */
886     function voteOnBounty(
887         uint128 bountyGuid,
888         uint256 votes,
889         bool validBloom
890     )
891         external
892         onlyArbiter
893         whenNotPaused
894     {
895         Bounty storage bounty = bountiesByGuid[bountyGuid];
896         Vote[] storage bountyVotes = votesByGuid[bountyGuid];
897 
898         // Check if this bounty has been initialized
899         require(bounty.author != address(0), "Bounty has not been initialized");
900         // Check that the reveal round has closed
901         require(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW) <= block.number, "Reveal round is still active");
902         // Check if the voting round has closed
903         require(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow) > block.number, "Voting round has closed");
904         // Check to make sure arbiters can't double vote
905         require(arbiterVoteRegistryByGuid[bountyGuid][msg.sender] == false, "Arbiter has already voted");
906 
907         Vote memory a = Vote(
908             msg.sender,
909             votes,
910             validBloom
911         );
912 
913         votesByGuid[bountyGuid].push(a);
914 
915         staking.recordBounty(msg.sender, bountyGuid, block.number);
916         arbiterVoteRegistryByGuid[bountyGuid][msg.sender] = true;
917         uint256 tempQuorumMask = 0;
918         uint256 quorumCount = 0;
919         mapping (uint256 => uint256) quorumVotes = quorumVotesByGuid[bountyGuid];
920         for (uint256 i = 0; i < bounty.numArtifacts; i++) {
921 
922             if (bounty.quorumMask != 0 && (bounty.quorumMask & (1 << i) != 0)) {
923                 tempQuorumMask = tempQuorumMask.add(calculateMask(i, 1));
924                 quorumCount = quorumCount.add(1);
925                 continue;
926             }
927 
928             if (votes & (1 << i) != 0) {
929                 quorumVotes[i] = quorumVotes[i].add(1);
930             }
931 
932             uint256 benignVotes = bountyVotes.length.sub(quorumVotes[i]);
933             uint256 maxBenignValue = arbiterCount.sub(quorumVotes[i]).mul(BENIGN_VOTE_COEFFICIENT);
934             uint256 maxMalValue = arbiterCount.sub(benignVotes).mul(MALICIOUS_VOTE_COEFFICIENT);
935 
936             if (quorumVotes[i].mul(MALICIOUS_VOTE_COEFFICIENT) >= maxBenignValue || benignVotes.mul(BENIGN_VOTE_COEFFICIENT) > maxMalValue) {
937                 tempQuorumMask = tempQuorumMask.add(calculateMask(i, 1));
938                 quorumCount = quorumCount.add(1);
939             }
940         }
941 
942         // set new mask
943         bounty.quorumMask = tempQuorumMask;
944 
945         // check if all arbiters have voted or if we have quorum for all the artifacts
946         if ((bountyVotes.length == arbiterCount || quorumCount == bounty.numArtifacts) && !bounty.quorumReached)  {
947             bounty.quorumReached = true;
948             bounty.quorumBlock = block.number.sub(bountiesByGuid[bountyGuid].expirationBlock);
949             emit QuorumReached(bountyGuid);
950         }
951 
952         emit NewVote(bountyGuid, votes, bounty.numArtifacts, msg.sender);
953     }
954 
955     // This struct exists to move state from settleBounty into memory from stack
956     // to avoid solidity limitations
957     struct ArtifactPot {
958         uint256 numWinners;
959         uint256 numLosers;
960         uint256 winnerPool;
961         uint256 loserPool;
962     }
963 
964     /**
965      * Function to calculate the reward disbursment of a bounty
966      *
967      * @param bountyGuid the guid of the bounty to calculate
968      * @return Rewards distributed by the bounty
969      */
970     function calculateBountyRewards(
971         uint128 bountyGuid
972     )
973         public
974         view
975         returns (uint256 bountyRefund, uint256 arbiterReward, uint256[] expertRewards)
976     {
977         Bounty storage bounty = bountiesByGuid[bountyGuid];
978         Assertion[] storage assertions = assertionsByGuid[bountyGuid];
979         Vote[] storage votes = votesByGuid[bountyGuid];
980         mapping (uint256 => uint256) quorumVotes = quorumVotesByGuid[bountyGuid];
981 
982         // Check if this bountiesByGuid[bountyGuid] has been initialized
983         require(bounty.author != address(0), "Bounty has not been initialized");
984         // Check if this bounty has been previously resolved for the sender
985         require(!bountySettled[bountyGuid][msg.sender], "Bounty has already been settled for sender");
986         // Check that the voting round has closed
987         // solium-disable-next-line indentation
988         require(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow) <= block.number || bounty.quorumReached,
989             "Voting round is still active and quorum has not been reached");
990 
991         expertRewards = new uint256[](assertions.length);
992 
993         ArtifactPot memory ap = ArtifactPot({numWinners: 0, numLosers: 0, winnerPool: 0, loserPool: 0});
994 
995         uint256 i = 0;
996         uint256 j = 0;
997 
998         if (assertions.length == 0 && votes.length == 0) {
999             // Refund the bounty amount and fees to ambassador
1000             bountyRefund = bounty.numArtifacts.mul(bounty.amount.add(BOUNTY_FEE));
1001         } else if (assertions.length == 0) {
1002             // Refund the bounty amount ambassador
1003             bountyRefund = bounty.amount.mul(bounty.numArtifacts);
1004         } else if (votes.length == 0) {
1005             // Refund bids, fees, and distribute the bounty amount evenly to experts
1006             bountyRefund = BOUNTY_FEE.mul(bounty.numArtifacts);
1007             for (j = 0; j < assertions.length; j++) {
1008                 expertRewards[j] = expertRewards[j].add(ASSERTION_FEE);
1009                 expertRewards[j] = expertRewards[j].add(assertions[j].bid);
1010                 expertRewards[j] = expertRewards[j].add(bounty.amount.div(assertions.length));
1011                 expertRewards[j] = expertRewards[j].mul(bounty.numArtifacts);
1012             }
1013         } else {
1014             for (i = 0; i < bounty.numArtifacts; i++) {
1015                 ap = ArtifactPot({numWinners: 0, numLosers: 0, winnerPool: 0, loserPool: 0});
1016                 bool consensus = quorumVotes[i].mul(MALICIOUS_VOTE_COEFFICIENT) >= votes.length.sub(quorumVotes[i]).mul(BENIGN_VOTE_COEFFICIENT);
1017 
1018                 for (j = 0; j < assertions.length; j++) {
1019                     bool malicious;
1020 
1021                     // If we didn't assert on this artifact
1022                     if (assertions[j].mask & (1 << i) == 0) {
1023                         continue;
1024                     }
1025 
1026                     // If we haven't revealed set to incorrect value
1027                     if (assertions[j].nonce == 0) {
1028                         malicious = !consensus;
1029                     } else {
1030                         malicious = (assertions[j].verdicts & assertions[j].mask) & (1 << i) != 0;
1031                     }
1032 
1033                     if (malicious == consensus) {
1034                         ap.numWinners = ap.numWinners.add(1);
1035                         ap.winnerPool = ap.winnerPool.add(assertions[j].bid);
1036                     } else {
1037                         ap.numLosers = ap.numLosers.add(1);
1038                         ap.loserPool = ap.loserPool.add(assertions[j].bid);
1039                     }
1040                 }
1041 
1042                 // If nobody asserted on this artifact, refund the ambassador
1043                 if (ap.numWinners == 0 && ap.numLosers == 0) {
1044                     bountyRefund = bountyRefund.add(bounty.amount);
1045                     for (j = 0; j < assertions.length; j++) {
1046                         expertRewards[j] = expertRewards[j].add(assertions[j].bid);
1047                     }
1048                 } else {
1049                     for (j = 0; j < assertions.length; j++) {
1050                         expertRewards[j] = expertRewards[j].add(assertions[j].bid);
1051 
1052                         // If we didn't assert on this artifact
1053                         if (assertions[j].mask & (1 << i) == 0) {
1054                             continue;
1055                         }
1056 
1057                         // If we haven't revealed set to incorrect value
1058                         if (assertions[j].nonce == 0) {
1059                             malicious = !consensus;
1060                         } else {
1061                             malicious = (assertions[j].verdicts & assertions[j].mask) & (1 << i) != 0;
1062                         }
1063 
1064                         if (malicious == consensus) {
1065                             expertRewards[j] = expertRewards[j].add(assertions[j].bid.mul(ap.loserPool).div(ap.winnerPool));
1066                             expertRewards[j] = expertRewards[j].add(bounty.amount.mul(assertions[j].bid).div(ap.winnerPool));
1067                         } else {
1068                             expertRewards[j] = expertRewards[j].sub(assertions[j].bid);
1069                         }
1070                     }
1071                 }
1072             }
1073         }
1074 
1075         // Calculate rewards
1076         uint256 pot = bounty.amount.add(BOUNTY_FEE.add(ASSERTION_FEE.mul(assertions.length)));
1077         for (i = 0; i < assertions.length; i++) {
1078             pot = pot.add(assertions[i].bid);
1079         }
1080 
1081         bountyRefund = bountyRefund.div(bounty.numArtifacts);
1082         pot = pot.sub(bountyRefund);
1083 
1084         for (i = 0; i < assertions.length; i++) {
1085             expertRewards[i] = expertRewards[i].div(bounty.numArtifacts);
1086             pot = pot.sub(expertRewards[i]);
1087         }
1088 
1089         arbiterReward = pot;
1090     }
1091 
1092     /**
1093      * Function called after window has closed to handle reward disbursal
1094      *
1095      * This function will pay out rewards if the the bounty has a super majority
1096      * @param bountyGuid the guid of the bounty to settle
1097      */
1098     function settleBounty(uint128 bountyGuid) external whenNotPaused {
1099         Bounty storage bounty = bountiesByGuid[bountyGuid];
1100         Assertion[] storage assertions = assertionsByGuid[bountyGuid];
1101 
1102         // Check if this bountiesByGuid[bountyGuid] has been initialized
1103         require(bounty.author != address(0), "Bounty has not been initialized");
1104         // Check if this bounty has been previously resolved for the sender
1105         require(!bountySettled[bountyGuid][msg.sender], "Bounty has already been settled for sender");
1106         // Check that the voting round has closed
1107         // solium-disable-next-line indentation
1108         require(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow) <= block.number || bounty.quorumReached,
1109             "Voting round is still active and quorum has not been reached");
1110 
1111         if (isArbiter(msg.sender)) {
1112             require(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow) <= block.number, "Voting round still active");
1113             if (bounty.assignedArbiter == address(0)) {
1114                 if (bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow).add(VALID_HASH_PERIOD) >= block.number) {
1115                     bounty.assignedArbiter = getWeightedRandomArbiter(bountyGuid);
1116                 } else {
1117                     bounty.assignedArbiter = msg.sender;
1118                 }
1119             }
1120         }
1121 
1122         uint256 payout = 0;
1123         uint256 bountyRefund;
1124         uint256 arbiterReward;
1125         uint256[] memory expertRewards;
1126         (bountyRefund, arbiterReward, expertRewards) = calculateBountyRewards(bountyGuid);
1127 
1128         bountySettled[bountyGuid][msg.sender] = true;
1129 
1130         // Disburse rewards
1131         if (bountyRefund != 0 && bounty.author == msg.sender) {
1132             token.safeTransfer(bounty.author, bountyRefund);
1133             payout = payout.add(bountyRefund);
1134         }
1135 
1136         for (uint256 i = 0; i < assertions.length; i++) {
1137             if (expertRewards[i] != 0 && assertions[i].author == msg.sender) {
1138                 token.safeTransfer(assertions[i].author, expertRewards[i]);
1139                 payout = payout.add(expertRewards[i]);
1140             }
1141         }
1142 
1143         if (arbiterReward != 0 && bounty.assignedArbiter == msg.sender) {
1144             token.safeTransfer(bounty.assignedArbiter, arbiterReward);
1145             payout = payout.add(arbiterReward);
1146         }
1147 
1148         emit SettledBounty(bountyGuid, msg.sender, payout);
1149     }
1150 
1151     /**
1152      *  Generates a random number from 0 to range based on the last block hash
1153      *
1154      *  @param seed random number for reproducing
1155      *  @param range end range for random number
1156      */
1157     function randomGen(uint256 targetBlock, uint seed, uint256 range) private view returns (int256 randomNumber) {
1158         return int256(uint256(keccak256(abi.encodePacked(blockhash(targetBlock), seed))) % range);
1159     }
1160 
1161     /**
1162      * Gets a random Arbiter weighted by the amount of Nectar they have
1163      *
1164      * @param bountyGuid the guid of the bounty
1165      */
1166     function getWeightedRandomArbiter(uint128 bountyGuid) public view returns (address voter) {
1167         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
1168 
1169         Bounty memory bounty = bountiesByGuid[bountyGuid];
1170         Vote[] memory votes = votesByGuid[bountyGuid];
1171 
1172         if (votes.length == 0) {
1173             return address(0);
1174         }
1175 
1176         uint i;
1177         uint256 sum = 0;
1178         int256 randomNum;
1179 
1180         for (i = 0; i < votes.length; i++) {
1181             sum = sum.add(staking.balanceOf(votes[i].author));
1182         }
1183 
1184         randomNum = randomGen(bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow), block.number, sum);
1185 
1186         for (i = 0; i < votes.length; i++) {
1187             randomNum -= int256(staking.balanceOf(votes[i].author));
1188 
1189             if (randomNum <= 0) {
1190                 voter = votes[i].author;
1191                 break;
1192             }
1193         }
1194 
1195     }
1196 
1197     /**
1198      * Get the total number of bounties tracked by the contract
1199      * @return total number of bounties
1200      */
1201     function getNumberOfBounties() external view returns (uint) {
1202         return bountyGuids.length;
1203     }
1204 
1205     /**
1206      * Get the current round for a bounty
1207      *
1208      * @param bountyGuid the guid of the bounty
1209      * @return the current round
1210      *      0 = assertions being accepted
1211      *      1 = assertions being revealed
1212      *      2 = arbiters voting
1213      *      3 = bounty finished
1214      */
1215     function getCurrentRound(uint128 bountyGuid) external view returns (uint) {
1216         // Check if this bounty has been initialized
1217         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
1218 
1219         Bounty memory bounty = bountiesByGuid[bountyGuid];
1220 
1221         if (bounty.expirationBlock > block.number) {
1222             return 0;
1223         } else if (bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW) > block.number) {
1224             return 1;
1225         } else if (bounty.expirationBlock.add(ASSERTION_REVEAL_WINDOW).add(arbiterVoteWindow) > block.number &&
1226                   !bounty.quorumReached) {
1227             return 2;
1228         } else {
1229             return 3;
1230         }
1231     }
1232 
1233     /**
1234      * Gets the number of assertions for a bounty
1235      *
1236      * @param bountyGuid the guid of the bounty
1237      * @return number of assertions for the given bounty
1238      */
1239     function getNumberOfAssertions(uint128 bountyGuid) external view returns (uint) {
1240         // Check if this bounty has been initialized
1241         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
1242 
1243         return assertionsByGuid[bountyGuid].length;
1244     }
1245 
1246     /**
1247      * Gets the vote count for a specific bounty
1248      *
1249      * @param bountyGuid the guid of the bounty
1250      */
1251     function getNumberOfVotes(uint128 bountyGuid) external view returns (uint) {
1252         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
1253 
1254         return votesByGuid[bountyGuid].length;
1255     }
1256 
1257     /**
1258      * Gets all the voters for a specific bounty
1259      *
1260      * @param bountyGuid the guid of the bounty
1261      */
1262     function getVoters(uint128 bountyGuid) external view returns (address[]) {
1263         require(bountiesByGuid[bountyGuid].author != address(0), "Bounty has not been initialized");
1264 
1265         Vote[] memory votes = votesByGuid[bountyGuid];
1266         uint count = votes.length;
1267 
1268         address[] memory voters = new address[](count);
1269 
1270         for (uint i = 0; i < count; i++) {
1271             voters[i] = votes[i].author;
1272         }
1273 
1274         return voters;
1275     }
1276 
1277     /** Candidate for future arbiter */
1278     struct Candidate {
1279         address addr;
1280         uint256 count;
1281     }
1282 
1283     /**
1284      * View function displays most active bounty posters over past
1285      * ARBITER_LOOKBACK_RANGE bounties to select future arbiters
1286      *
1287      * @return sorted array of most active bounty posters
1288      */
1289     function getArbiterCandidates() external view returns (address[]) {
1290         require(bountyGuids.length > 0, "No bounties have been placed");
1291 
1292         uint256 count = 0;
1293         Candidate[] memory candidates = new Candidate[](ARBITER_LOOKBACK_RANGE);
1294 
1295         uint256 lastBounty = 0;
1296         if (bountyGuids.length > ARBITER_LOOKBACK_RANGE) {
1297             lastBounty = bountyGuids.length.sub(ARBITER_LOOKBACK_RANGE);
1298         }
1299 
1300         for (uint256 i = bountyGuids.length; i > lastBounty; i--) {
1301             address addr = bountiesByGuid[bountyGuids[i.sub(1)]].author;
1302             bool found = false;
1303             for (uint256 j = 0; j < count; j++) {
1304                 if (candidates[j].addr == addr) {
1305                     candidates[j].count = candidates[j].count.add(1);
1306                     found = true;
1307                     break;
1308                 }
1309             }
1310 
1311             if (!found) {
1312                 candidates[count] = Candidate(addr, 1);
1313                 count = count.add(1);
1314             }
1315         }
1316 
1317         address[] memory ret = new address[](count);
1318 
1319         for (i = 0; i < ret.length; i++) {
1320             uint256 next = 0;
1321             uint256 value = candidates[0].count;
1322 
1323 
1324 
1325             for (j = 0; j < count; j++) {
1326                 if (candidates[j].count > value) {
1327                     next = j;
1328                     value = candidates[j].count;
1329                 }
1330             }
1331 
1332             ret[i] = candidates[next].addr;
1333             candidates[next] = candidates[count.sub(1)];
1334             count = count.sub(1);
1335         }
1336 
1337         return ret;
1338     }
1339 
1340     function calculateMask(uint256 i, uint256 b) public pure returns(uint256) {
1341         if (b != 0) {
1342             return 1 << i;
1343         }
1344 
1345         return 0;
1346     }
1347 
1348     /**
1349      * View function displays the most active bounty voters over past
1350      * ARBITER_LOOKBACK_RANGE bounties to select future arbiters
1351      *
1352      * @return a sorted array of most active bounty voters and a boolean array of whether
1353      * or not they were active in 90% of bounty votes
1354      */
1355 
1356     function getActiveArbiters() external view returns (address[], bool[]) {
1357         require(bountyGuids.length > 0, "No bounties have been placed");
1358         uint256 count = 0;
1359         uint256 threshold = bountyGuids.length.div(10).mul(9);
1360         address[] memory ret_addr = new address[](count);
1361         bool[] memory ret_arbiter_ativity_threshold = new bool[](count);
1362 
1363         Candidate[] memory candidates = new Candidate[](ARBITER_LOOKBACK_RANGE);
1364 
1365         uint256 lastBounty = 0;
1366         if (bountyGuids.length > ARBITER_LOOKBACK_RANGE) {
1367             lastBounty = bountyGuids.length.sub(ARBITER_LOOKBACK_RANGE);
1368             threshold = lastBounty.div(10).mul(9);
1369         }
1370 
1371         for (uint256 i = bountyGuids.length.sub(1); i > lastBounty; i--) {
1372             Vote[] memory votes = votesByGuid[bountyGuids[i]];
1373 
1374             for (uint256 j = 0; j < votes.length; j++) {
1375                 bool found = false;
1376                 address addr = votes[j].author;
1377 
1378                 for (uint256 k = 0; k < count; k++) {
1379                     if (candidates[k].addr == addr) {
1380                         candidates[k].count = candidates[k].count.add(1);
1381                         found = true;
1382                         break;
1383                     }
1384                 }
1385 
1386                 if (!found) {
1387                     candidates[count] = Candidate(addr, 1);
1388                     count = count.add(1);
1389                 }
1390 
1391             }
1392 
1393         }
1394 
1395 
1396         for (i = 0; i < ret_addr.length; i++) {
1397             uint256 next = 0;
1398             uint256 value = candidates[0].count;
1399 
1400             for (j = 0; j < count; j++) {
1401                 if (candidates[j].count > value) {
1402                     next = j;
1403                     value = candidates[j].count;
1404                 }
1405             }
1406 
1407             ret_addr[i] = candidates[next].addr;
1408             if (candidates[next].count.div(10).mul(9) < threshold) {
1409                 ret_arbiter_ativity_threshold[i] = false;
1410             } else {
1411                 ret_arbiter_ativity_threshold[i] = true;
1412             }
1413 
1414             count = count.sub(1);
1415             candidates[next] = candidates[count];
1416         }
1417 
1418         return (ret_addr, ret_arbiter_ativity_threshold);
1419 
1420     }
1421 
1422 }
1423 pragma solidity ^0.4.21;
1424 
1425 
1426 
1427 
1428 //import "./BountyRegistry.sol";
1429 
1430 contract ArbiterStaking is Pausable {
1431     using SafeMath for uint256;
1432     using SafeERC20 for NectarToken;
1433 
1434     uint256 public constant MINIMUM_STAKE = 10000000 * 10 ** 18;
1435     uint256 public constant MAXIMUM_STAKE = 100000000 * 10 ** 18;
1436     uint8 public constant VOTE_RATIO_NUMERATOR = 9;
1437     uint8 public constant VOTE_RATIO_DENOMINATOR = 10;
1438     string public constant VERSION = "1.0.0";
1439 
1440     // Deposits
1441     struct Deposit {
1442         uint256 blockNumber;
1443         uint256 value;
1444     }
1445 
1446     event NewDeposit(
1447         address indexed from,
1448         uint256 value
1449     );
1450 
1451     event NewWithdrawal(
1452         address indexed to,
1453         uint256 value
1454     );
1455 
1456     mapping(address => Deposit[]) public deposits;
1457 
1458     // Bounties
1459     event BountyRecorded(
1460         uint128 indexed guid,
1461         uint256 blockNumber
1462     );
1463 
1464     event BountyVoteRecorded(
1465         address arbiter
1466     );
1467 
1468     uint256 public numBounties;
1469     mapping(uint128 => bool) public bounties;
1470     mapping(address => uint256) public bountyResponses;
1471     mapping(uint128 => mapping(address => bool)) public bountyResponseByGuidAndAddress;
1472 
1473     uint256 public stakeDuration;
1474     NectarToken internal token;
1475     BountyRegistry internal registry;
1476 
1477     /**
1478      * Construct a new ArbiterStaking
1479      *
1480      * @param _token address of NCT token to use
1481      */
1482     constructor(address _token, uint256 _stakeDuration) Ownable() public {
1483         token = NectarToken(_token);
1484         stakeDuration = _stakeDuration;
1485     }
1486 
1487     /**
1488      * Sets the registry value with the live BountyRegistry
1489 
1490      * @param _bountyRegistry Address of BountyRegistry contract
1491      */
1492     function setBountyRegistry(address _bountyRegistry) public onlyOwner {
1493         registry = BountyRegistry(_bountyRegistry);
1494     }
1495 
1496     /**
1497      * Handle a deposit upon receiving approval for a token transfer
1498      * Called from NectarToken.approveAndCall
1499      *
1500      * @param _from Account depositing NCT
1501      * @param _value Amount of NCT being deposited
1502      * @param _tokenContract Address of the NCT contract
1503      * @return true if successful else false
1504      */
1505     function receiveApproval(
1506         address _from,
1507         uint256 _value,
1508         address _tokenContract,
1509         bytes
1510     )
1511         public
1512         whenNotPaused
1513         returns (bool)
1514     {
1515         require(msg.sender == address(token), "Must be called from the token.");
1516         return receiveApprovalInternal(_from, _value, _tokenContract, new bytes(0));
1517     }
1518 
1519     function receiveApprovalInternal(
1520         address _from,
1521         uint256 _value,
1522         address _tokenContract,
1523         bytes
1524     )
1525         internal
1526         whenNotPaused
1527         returns (bool)
1528     {
1529         require(registry.isArbiter(_from), "Deposit target is not an arbiter");
1530         // Ensure we are depositing something
1531         require(_value > 0, "Zero value being deposited");
1532         // Ensure we are called from he right token contract
1533         require(_tokenContract == address(token), "Invalid token being deposited");
1534         // Ensure that we are not staking more than the maximum
1535         require(balanceOf(_from).add(_value) <= MAXIMUM_STAKE, "Value greater than maximum stake");
1536 
1537         token.safeTransferFrom(_from, this, _value);
1538         deposits[_from].push(Deposit(block.number, _value));
1539         emit NewDeposit(_from, _value);
1540 
1541         return true;
1542     }
1543 
1544     /**
1545      * Deposit NCT (requires prior approval)
1546      *
1547      * @param value The amount of NCT to deposit
1548      */
1549     function deposit(uint256 value) public whenNotPaused {
1550         require(receiveApprovalInternal(msg.sender, value, token, new bytes(0)), "Depositing stake failed");
1551     }
1552 
1553     /**
1554      * Retrieve the (total) current balance of staked NCT for an account
1555      *
1556      * @param addr The account whos balance to retrieve
1557      * @return The current (total) balance of the account
1558      */
1559     function balanceOf(address addr) public view returns (uint256) {
1560         uint256 ret = 0;
1561         Deposit[] storage ds = deposits[addr];
1562         for (uint256 i = 0; i < ds.length; i++) {
1563             ret = ret.add(ds[i].value);
1564         }
1565         return ret;
1566     }
1567 
1568     /**
1569      * Retrieve the withdrawable current balance of staked NCT for an account
1570      *
1571      * @param addr The account whos balance to retrieve
1572      * @return The current withdrawable balance of the account
1573      */
1574     function withdrawableBalanceOf(address addr) public view returns (uint256) {
1575         uint256 ret = 0;
1576         if (block.number < stakeDuration) {
1577             return ret;
1578         }
1579         uint256 latest_block = block.number.sub(stakeDuration);
1580         Deposit[] storage ds = deposits[addr];
1581         for (uint256 i = 0; i < ds.length; i++) {
1582             if (ds[i].blockNumber <= latest_block) {
1583                 ret = ret.add(ds[i].value);
1584             } else {
1585                 break;
1586             }
1587         }
1588         return ret;
1589     }
1590 
1591     /**
1592      * Withdraw staked NCT
1593      * @param value The amount of NCT to withdraw
1594      */
1595     function withdraw(uint256 value) public whenNotPaused {
1596         require(deposits[msg.sender].length > 0, "Cannot withdraw without some deposits.");
1597         uint256 remaining = value;
1598         uint256 latest_block = block.number.sub(stakeDuration);
1599         Deposit[] storage ds = deposits[msg.sender];
1600 
1601         require(value <= withdrawableBalanceOf(msg.sender), "Value exceeds withdrawable balance");
1602 
1603         // Determine which deposits we will modifiy
1604         for (uint256 end = 0; end < ds.length; end++) {
1605             if (ds[end].blockNumber <= latest_block) {
1606                 if (ds[end].value >= remaining) {
1607                     ds[end].value = ds[end].value.sub(remaining);
1608                     if (ds[end].value == 0) {
1609                         end++;
1610                     }
1611                     remaining = 0;
1612                     break;
1613                 } else {
1614                     remaining = remaining.sub(ds[end].value);
1615                 }
1616             } else {
1617                 break;
1618             }
1619         }
1620 
1621         // If we haven't hit our value by now, we don't have enough available
1622         // funds
1623         require(remaining == 0, "Value exceeds withdrawable balance");
1624 
1625         // Delete the obsolete deposits
1626         for (uint256 i = 0; i < ds.length.sub(end); i++) {
1627             ds[i] = ds[i.add(end)];
1628         }
1629 
1630         for (i = ds.length.sub(end); i < ds.length; i++) {
1631             delete ds[i];
1632         }
1633 
1634         ds.length = ds.length.sub(end);
1635 
1636         // Do the transfer
1637         token.safeTransfer(msg.sender, value);
1638         emit NewWithdrawal(msg.sender, value);
1639     }
1640 
1641     /**
1642      * Is an address an eligible arbiter?
1643      * @param addr The address to validate
1644      * @return true if address is eligible else false
1645      */
1646     function isEligible(address addr) public view returns (bool) {
1647         uint256 num;
1648         uint256 den;
1649         (num, den) = arbiterResponseRate(addr);
1650 
1651         return balanceOf(addr) >= MINIMUM_STAKE &&
1652             (den < VOTE_RATIO_DENOMINATOR || num.mul(VOTE_RATIO_DENOMINATOR).div(den) >= VOTE_RATIO_NUMERATOR);
1653     }
1654 
1655     /**
1656      * Record a bounty that an arbiter has voted on
1657      *
1658      * @param arbiter The address of the arbiter
1659      * @param bountyGuid The guid of the bounty
1660      */
1661     function recordBounty(address arbiter, uint128 bountyGuid, uint256 blockNumber) public {
1662         require(msg.sender == address(registry), "Can only be called by the BountyRegistry.");
1663         require(arbiter != address(0), "Invalid arbiter address");
1664         require(blockNumber != 0, "Invalid block number");
1665 
1666         // New bounty
1667         if (!bounties[bountyGuid]) {
1668             bounties[bountyGuid] = true;
1669             numBounties = numBounties.add(1);
1670             emit BountyRecorded(bountyGuid, blockNumber);
1671         }
1672 
1673         // First response to this bounty by this arbiter
1674         if (!bountyResponseByGuidAndAddress[bountyGuid][arbiter]) {
1675             bountyResponseByGuidAndAddress[bountyGuid][arbiter] = true;
1676             bountyResponses[arbiter] = bountyResponses[arbiter].add(1);
1677         }
1678 
1679         emit BountyVoteRecorded(arbiter);
1680     }
1681 
1682     /**
1683      * Determines the ratio of past bounties that the arbiter has responded to
1684      *
1685      * @param arbiter The address of the arbiter
1686      * @return number of bounties responded to, number of bounties considered
1687      */
1688     function arbiterResponseRate(address arbiter) public view returns (uint256 num, uint256 den) {
1689         num = bountyResponses[arbiter];
1690         den = numBounties;
1691     }
1692 }