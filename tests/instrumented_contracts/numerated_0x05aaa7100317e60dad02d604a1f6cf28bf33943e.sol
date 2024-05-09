1 /*
2 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
3 commit 2307467,  under MIT license. See LICENSE
4 */
5 
6 pragma solidity ^0.4.24;
7 
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
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22     if (a == 0) {
23       return 0;
24     }
25 
26     c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return a / b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 
61 /*
62 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
63 commit 2307467,  under MIT license. See LICENSE
64 */
65 
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * See https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   function totalSupply() public view returns (uint256);
74   function balanceOf(address who) public view returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /*
80 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
81 commit 2307467,  under MIT license. See LICENSE
82 */
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) internal balances;
92 
93   uint256 internal totalSupply_;
94 
95   /**
96   * @dev Total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev Transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_value <= balances[msg.sender]);
109     require(_to != address(0));
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 }
126 
127 /*
128 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
129 commit 2307467,  under MIT license. See LICENSE
130 */
131 
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender)
139     public view returns (uint256);
140 
141   function transferFrom(address from, address to, uint256 value)
142     public returns (bool);
143 
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(
146     address indexed owner,
147     address indexed spender,
148     uint256 value
149   );
150 }
151 
152 
153 /*
154 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
155 commit 2307467,  under MIT license. See LICENSE
156 */
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     require( (allowed[msg.sender][_spender] == 0) || (_value == 0) );
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseApproval(
238     address _spender,
239     uint256 _addedValue
240   )
241     public
242     returns (bool)
243   {
244     allowed[msg.sender][_spender] = (
245       allowed[msg.sender][_spender].add(_addedValue));
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(
260     address _spender,
261     uint256 _subtractedValue
262   )
263     public
264     returns (bool)
265   {
266     uint256 oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue >= oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 
279 /*
280 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
281 commit 2307467,  under MIT license. See LICENSE
282 */
283 
284 /**
285 * @title Ownable
286 * @dev The Ownable contract has an owner address, and provides basic authorization control
287 * functions, this simplifies the implementation of "user permissions".
288 */
289 contract Ownable {
290     address public owner;
291     address public newOwner;
292 
293     event OwnershipRenounced(address indexed previousOwner);
294     event OwnershipTransferInitiated(
295         address indexed previousOwner,
296         address indexed newOwner
297     );
298     event OwnershipTransferred(
299         address indexed previousOwner,
300         address indexed newOwner
301     );
302 
303     /**
304      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
305      * account.
306      */
307     constructor() public {
308         owner = msg.sender;
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the owner.
313      */
314     modifier onlyOwner() {
315         require(msg.sender == owner);
316         _;
317     }
318 
319     /**
320      * @dev Throws if called by any account other than the specific function owner.
321      */
322     modifier ownedBy(address _a) {
323         require( msg.sender == _a );
324         _;
325     }
326 
327     /**
328      * @dev Allows the current owner to relinquish control of the contract.
329      * @notice Renouncing to ownership will leave the contract without an owner.
330      * It will not be possible to call the functions with the `onlyOwner`
331      * modifier anymore.
332      */
333     function renounceOwnership() public onlyOwner {
334         emit OwnershipRenounced(owner);
335         owner = address(0);
336     }
337 
338     /**
339      * @dev Allows the current owner to transfer control of the contract to a newOwner.
340      * @param _newOwner The address to transfer ownership to. Needs to be accepted by
341      * the new owner.
342      */
343     function transferOwnership(address _newOwner) public onlyOwner {
344         _transferOwnership(_newOwner);
345     }
346 
347     /**
348      * @dev Allows the current owner to transfer control of the contract to a newOwner.
349      * @param _newOwner The address to transfer ownership to.
350      */
351     function transferOwnershipAtomic(address _newOwner) public onlyOwner {
352         owner = _newOwner;
353         newOwner = address(0);
354         emit OwnershipTransferred(owner, _newOwner);
355     }
356 
357     /**
358      * @dev Completes the ownership transfer by having the new address confirm the transfer.
359      */
360     function acceptOwnership() public {
361         require(msg.sender == newOwner);
362         emit OwnershipTransferred(owner, msg.sender);
363         owner = msg.sender;
364         newOwner = address(0);
365     }
366 
367     /**
368      * @dev Transfers control of the contract to a newOwner.
369      * @param _newOwner The address to transfer ownership to.
370      */
371     function _transferOwnership(address _newOwner) internal {
372         require(_newOwner != address(0));
373         newOwner = _newOwner;
374         emit OwnershipTransferInitiated(owner, _newOwner);
375     }
376 }
377 
378 /*
379 This source file has been copied with modification from https://github.com/OpenZeppelin/openzeppelin-solidity
380 commit 2307467, under MIT license. See LICENSE
381 */
382 
383 /**
384  * @title Mintable token
385  * @dev Simple ERC20 Token example, with mintable token creation
386  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
387  */
388 contract MintableToken is StandardToken, Ownable {
389     event Mint(address indexed to, uint256 amount);
390     event MintFinished();
391 
392     // Overflow check: 1500 *1e6 * 1e18 < 10^30 < 2^105 < 2^256
393     uint constant public SUPPLY_HARD_CAP = 1500 * 1e6 * 1e18;
394     bool public mintingFinished = false;
395 
396     modifier canMint() {
397         require(!mintingFinished);
398         _;
399     }
400 
401     modifier hasMintPermission() {
402         require(msg.sender == owner);
403         _;
404     }
405 
406     /**
407      * @dev Function to mint tokens
408      * @param _to The address that will receive the minted tokens.
409      * @param _amount The amount of tokens to mint.
410      * @return A boolean that indicates if the operation was successful.
411      */
412     function mint(
413         address _to,
414         uint256 _amount
415     )
416         public
417         hasMintPermission
418         canMint
419         returns (bool)
420     {
421         require( totalSupply_.add(_amount) <= SUPPLY_HARD_CAP );
422         totalSupply_ = totalSupply_.add(_amount);
423         balances[_to] = balances[_to].add(_amount);
424         emit Mint(_to, _amount);
425         emit Transfer(address(0), _to, _amount);
426         return true;
427     }
428 
429     /**
430      * @dev Function to stop minting new tokens.
431      * @return True if the operation was successful.
432      */
433     function finishMinting() public onlyOwner canMint returns (bool) {
434         mintingFinished = true;
435         emit MintFinished();
436         return true;
437     }
438 }
439 
440 contract Allocation is Ownable {
441     using SafeMath for uint256;
442 
443     address public backend;
444     address public team;
445     address public partners;
446     address public toSendFromStorage; address public rewards;
447     OPUCoin public token;
448     Vesting public vesting;
449     ColdStorage public coldStorage;
450 
451     bool public emergencyPaused = false;
452     bool public finalizedHoldingsAndTeamTokens = false;
453     bool public mintingFinished = false;
454 
455     // All the numbers on the following 8 lines are lower than 10^30
456     // Which is in turn lower than 2^105, which is lower than 2^256
457     // So, no overflows are possible, the operations are safe.
458     uint constant internal MIL = 1e6 * 1e18;
459 
460     // Token distribution table, all values in millions of tokens
461     uint constant internal ICO_DISTRIBUTION    = 550 * MIL;
462     uint constant internal TEAM_TOKENS         = 550  * MIL;
463     uint constant internal COLD_STORAGE_TOKENS = 75  * MIL;
464     uint constant internal PARTNERS_TOKENS     = 175  * MIL;
465     uint constant internal REWARDS_POOL        = 150  * MIL;
466 
467     uint internal totalTokensSold = 0;
468 
469     event TokensAllocated(address _buyer, uint _tokens);
470     event TokensAllocatedIntoHolding(address _buyer, uint _tokens);
471     event TokensMintedForRedemption(address _to, uint _tokens);
472     event TokensSentIntoVesting(address _vesting, address _to, uint _tokens);
473     event TokensSentIntoHolding(address _vesting, address _to, uint _tokens);
474     event HoldingAndTeamTokensFinalized();
475     event BackendUpdated(address oldBackend, address newBackend);
476     event TeamUpdated(address oldTeam, address newTeam);
477     event PartnersUpdated(address oldPartners, address newPartners);
478     event ToSendFromStorageUpdated(address oldToSendFromStorage, address newToSendFromStorage);
479 
480     // Human interaction (only accepted from the address that launched the contract)
481     constructor(
482         address _backend,
483         address _team,
484         address _partners,
485         address _toSendFromStorage,
486         address _rewards
487     )
488         public
489     {
490         require( _backend           != address(0) );
491         require( _team              != address(0) );
492         require( _partners          != address(0) );
493         require( _toSendFromStorage != address(0) );
494         require( _rewards != address(0) );
495 
496         backend           = _backend;
497         team              = _team;
498         partners          = _partners;
499         toSendFromStorage = _toSendFromStorage;
500         rewards = _rewards;
501 
502         token       = new OPUCoin();
503         vesting     = new Vesting(address(token), team);
504         coldStorage = new ColdStorage(address(token));
505     }
506 
507     function emergencyPause() public onlyOwner unpaused { emergencyPaused = true; }
508 
509     function emergencyUnpause() public onlyOwner paused { emergencyPaused = false; }
510 
511     function allocate(
512         address _buyer,
513         uint _tokensWithStageBonuses
514     )
515         public
516         ownedBy(backend)
517         mintingEnabled
518     {
519         uint tokensAllocated = _allocateTokens(_buyer, _tokensWithStageBonuses);
520         emit TokensAllocated(_buyer, tokensAllocated);
521     }
522 
523     function finalizeHoldingAndTeamTokens()
524         public
525         ownedBy(backend)
526         unpaused
527     {
528         require( !finalizedHoldingsAndTeamTokens );
529 
530         finalizedHoldingsAndTeamTokens = true;
531 
532         vestTokens(team, TEAM_TOKENS);
533         holdTokens(toSendFromStorage, COLD_STORAGE_TOKENS);
534         token.mint(partners, PARTNERS_TOKENS);
535         token.mint(rewards, REWARDS_POOL);
536 
537         // Can exceed ICO token cap
538 
539         vesting.finalizeVestingAllocation();
540 
541         mintingFinished = true;
542         token.finishMinting();
543 
544         emit HoldingAndTeamTokensFinalized();
545     }
546 
547     function _allocateTokens(
548         address _to,
549         uint _tokensWithStageBonuses
550     )
551         internal
552         unpaused
553         returns (uint)
554     {
555         require( _to != address(0) );
556 
557         checkCapsAndUpdate(_tokensWithStageBonuses);
558 
559         // Calculate the total token sum to allocate
560         uint tokensToAllocate = _tokensWithStageBonuses;
561 
562         // Mint the tokens
563         require( token.mint(_to, tokensToAllocate) );
564         return tokensToAllocate;
565     }
566 
567     function checkCapsAndUpdate(uint _tokensToSell) internal {
568         uint newTotalTokensSold = totalTokensSold.add(_tokensToSell);
569         require( newTotalTokensSold <= ICO_DISTRIBUTION );
570         totalTokensSold = newTotalTokensSold;
571     }
572 
573     function vestTokens(address _to, uint _tokens) internal {
574         require( token.mint(address(vesting), _tokens) );
575         vesting.initializeVesting( _to, _tokens );
576         emit TokensSentIntoVesting(address(vesting), _to, _tokens);
577     }
578 
579     function holdTokens(address _to, uint _tokens) internal {
580         require( token.mint(address(coldStorage), _tokens) );
581         coldStorage.initializeHolding(_to);
582         emit TokensSentIntoHolding(address(coldStorage), _to, _tokens);
583     }
584 
585     function updateBackend(address _newBackend) public onlyOwner {
586         require(_newBackend != address(0));
587         backend = _newBackend;
588         emit BackendUpdated(backend, _newBackend);
589     }
590 
591     function updateTeam(address _newTeam) public onlyOwner {
592         require(_newTeam != address(0));
593         team = _newTeam;
594         emit TeamUpdated(team, _newTeam);
595     }
596 
597     function updatePartners(address _newPartners) public onlyOwner {
598         require(_newPartners != address(0));
599         partners = _newPartners;
600         emit PartnersUpdated(partners, _newPartners);
601     }
602 
603     function updateToSendFromStorage(address _newToSendFromStorage) public onlyOwner {
604         require(_newToSendFromStorage != address(0));
605         toSendFromStorage = _newToSendFromStorage;
606         emit ToSendFromStorageUpdated(toSendFromStorage, _newToSendFromStorage);
607     }
608 
609     modifier unpaused() {
610         require( !emergencyPaused );
611         _;
612     }
613 
614     modifier paused() {
615         require( emergencyPaused );
616         _;
617     }
618 
619     modifier mintingEnabled() {
620         require( !mintingFinished );
621         _;
622     }
623 }
624 
625 contract ColdStorage is Ownable {
626     using SafeMath for uint8;
627     using SafeMath for uint256;
628 
629     ERC20 public token;
630 
631     uint public lockupEnds;
632     uint public lockupPeriod;
633     uint public lockupRewind = 109 days;
634     bool public storageInitialized = false;
635     address public founders;
636 
637     event StorageInitialized(address _to, uint _tokens);
638     event TokensReleased(address _to, uint _tokensReleased);
639 
640     constructor(address _token) public {
641         require( _token != address(0) );
642         token = ERC20(_token);
643         uint lockupYears = 2;
644         lockupPeriod = lockupYears.mul(365 days);
645     }
646 
647     function claimTokens() external {
648         require( now > lockupEnds );
649         require( msg.sender == founders );
650 
651         uint tokensToRelease = token.balanceOf(address(this));
652         require( token.transfer(msg.sender, tokensToRelease) );
653         emit TokensReleased(msg.sender, tokensToRelease);
654     }
655 
656     function initializeHolding(address _to) public onlyOwner {
657         uint tokens = token.balanceOf(address(this));
658         require( !storageInitialized );
659         require( tokens != 0 );
660 
661         lockupEnds = now.sub(lockupRewind).add(lockupPeriod);
662         founders = _to;
663         storageInitialized = true;
664         emit StorageInitialized(_to, tokens);
665     }
666 }
667 
668 
669 contract Migrations {
670   address public owner;
671   uint public last_completed_migration;
672 
673   modifier restricted() {
674     if (msg.sender == owner) _;
675   }
676 
677   function Migrations() public {
678     owner = msg.sender;
679   }
680 
681   function setCompleted(uint completed) public restricted {
682     last_completed_migration = completed;
683   }
684 
685   function upgrade(address new_address) public restricted {
686     Migrations upgraded = Migrations(new_address);
687     upgraded.setCompleted(last_completed_migration);
688   }
689 }
690 
691 contract OPUCoin is MintableToken {
692     string constant public symbol = "OPU";
693     string constant public name = "Opu Coin";
694     uint8 constant public decimals = 18;
695 
696     // -------------------------------------------
697 	// Public functions
698     // -------------------------------------------
699     constructor() public { }
700 }
701 
702 
703 contract Vesting is Ownable {
704     using SafeMath for uint;
705     using SafeMath for uint256;
706 
707     ERC20 public token;
708     mapping (address => Holding) public holdings;
709     address internal founders;
710 
711     uint constant internal PERIOD_INTERVAL = 30 days;
712     uint constant internal FOUNDERS_HOLDING = 365 days;
713     uint constant internal BONUS_HOLDING = 0;
714     uint constant internal TOTAL_PERIODS = 12;
715 
716     uint internal totalTokensCommitted = 0;
717 
718     bool internal vestingStarted = false;
719     uint internal vestingStart = 0;
720     uint vestingRewind = 109 days;
721 
722     struct Holding {
723         uint tokensCommitted;
724         uint tokensRemaining;
725         uint batchesClaimed;
726 
727         bool isFounder;
728         bool isValue;
729     }
730 
731     event TokensReleased(address _to, uint _tokensReleased, uint _tokensRemaining);
732     event VestingInitialized(address _to, uint _tokens);
733     event VestingUpdated(address _to, uint _totalTokens);
734 
735     constructor(address _token, address _founders) public {
736         require( _token != 0x0);
737         require(_founders != 0x0);
738         token = ERC20(_token);
739         founders = _founders;
740     }
741 
742     function claimTokens() external {
743         require( holdings[msg.sender].isValue );
744         require( vestingStarted );
745         uint personalVestingStart =
746             (holdings[msg.sender].isFounder) ? (vestingStart.add(FOUNDERS_HOLDING)) : (vestingStart);
747         require( now > personalVestingStart );
748         uint periodsPassed = now.sub(personalVestingStart).div(PERIOD_INTERVAL);
749         uint batchesToClaim = periodsPassed.sub(holdings[msg.sender].batchesClaimed);
750         require( batchesToClaim > 0 );
751         uint tokensPerBatch = (holdings[msg.sender].tokensRemaining).div(
752             TOTAL_PERIODS.sub(holdings[msg.sender].batchesClaimed)
753         );
754         uint tokensToRelease = 0;
755 
756         if (periodsPassed >= TOTAL_PERIODS) {
757             tokensToRelease = holdings[msg.sender].tokensRemaining;
758             delete holdings[msg.sender];
759         } else {
760             tokensToRelease = tokensPerBatch.mul(batchesToClaim);
761             holdings[msg.sender].tokensRemaining = (holdings[msg.sender].tokensRemaining).sub(tokensToRelease);
762             holdings[msg.sender].batchesClaimed = holdings[msg.sender].batchesClaimed.add(batchesToClaim);
763         }
764         require( token.transfer(msg.sender, tokensToRelease) );
765         emit TokensReleased(msg.sender, tokensToRelease, holdings[msg.sender].tokensRemaining);
766     }
767 
768     function tokensRemainingInHolding(address _user) public view returns (uint) {
769         return holdings[_user].tokensRemaining;
770     }
771 
772     function initializeVesting(address _beneficiary, uint _tokens) public onlyOwner {
773         bool isFounder = (_beneficiary == founders);
774         _initializeVesting(_beneficiary, _tokens, isFounder);
775     }
776 
777     function finalizeVestingAllocation() public onlyOwner {
778         vestingStarted = true;
779         vestingStart = now.sub(vestingRewind);
780     }
781 
782     function _initializeVesting(address _to, uint _tokens, bool _isFounder) internal {
783         require( !vestingStarted );
784         if (!_isFounder) totalTokensCommitted = totalTokensCommitted.add(_tokens);
785         if (!holdings[_to].isValue) {
786             holdings[_to] = Holding({
787                 tokensCommitted: _tokens,
788                 tokensRemaining: _tokens,
789                 batchesClaimed: 0,
790                 isFounder: _isFounder,
791                 isValue: true
792             });
793             emit VestingInitialized(_to, _tokens);
794         } else {
795             holdings[_to].tokensCommitted = (holdings[_to].tokensCommitted).add(_tokens);
796             holdings[_to].tokensRemaining = (holdings[_to].tokensRemaining).add(_tokens);
797             emit VestingUpdated(_to, holdings[_to].tokensRemaining);
798         }
799     }
800 }