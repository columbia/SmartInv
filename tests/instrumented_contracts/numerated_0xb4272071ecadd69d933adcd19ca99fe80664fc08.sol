1 pragma solidity "0.4.25";
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  C:\projects\BTCS.CHFToken\contracts\Chftoken\CryptoFranc.sol
6 // flattened :  Wednesday, 24-Oct-18 14:07:18 UTC
7 contract InterestRateInterface {
8 
9     uint256 public constant SCALEFACTOR = 1e18;
10 
11     /// @notice get compounding level for currenct day
12     function getCurrentCompoundingLevel() public view returns (uint256);
13 
14     /// @notice get compounding level for _date `_date`
15     /// @param _date The date 
16     function getCompoundingLevelDate(uint256 _date) public view returns (uint256);
17 
18 }
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ERC20Interface {
46     /// total amount of tokens
47     function totalSupply() public view returns(uint256 supply);
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return The balance
51     function balanceOf(address _owner) public view returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of tokens to be approved for transfer
69     /// @return Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) public returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76 
77     // EVENTS
78     
79     // solhint-disable-next-line no-simple-event-func-name
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 contract Ownable {
85     address public owner;
86     address public newOwner;
87 
88     // MODIFIERS
89 
90     /// @dev Throws if called by any account other than the owner.
91     modifier onlyOwner() {
92         require(msg.sender == owner, "Only Owner");
93         _;
94     }
95 
96     /// @dev Throws if called by any account other than the new owner.
97     modifier onlyNewOwner() {
98         require(msg.sender == newOwner, "Only New Owner");
99         _;
100     }
101 
102     modifier notNull(address _address) {
103         require(_address != 0,"address is Null");
104         _;
105     }
106 
107     // CONSTRUCTORS
108 
109     /**
110     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111     * account.
112     */
113     constructor() public {
114         owner = msg.sender;
115     }
116 
117     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
118     /// @param _newOwner The address to transfer ownership to.
119     
120     function transferOwnership(address _newOwner) public notNull(_newOwner) onlyOwner {
121         newOwner = _newOwner;
122     }
123 
124     /// @dev Allow the new owner to claim ownership and so proving that the newOwner is valid.
125     function acceptOwnership() public onlyNewOwner {
126         address oldOwner = owner;
127         owner = newOwner;
128         newOwner = address(0);
129         emit OwnershipTransferred(oldOwner, owner);
130     }
131 
132     // EVENTS
133     
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 }
136 
137 contract InterestRateNone is InterestRateInterface {
138     
139     /// @notice get compounding level for currenct day
140     function getCurrentCompoundingLevel() public view returns (uint256) {
141         return SCALEFACTOR;
142     }
143 
144     /// @notice get compounding level for day `_date`
145     /// param _date The daynumber 
146     function getCompoundingLevelDate(uint256 /* _date */) public view returns (uint256) {
147         return SCALEFACTOR;
148     }
149 
150 }
151 contract MigrationAgent is Ownable {
152 
153     address public migrationToContract; // the contract to migrate to
154     address public migrationFromContract; // the conttactto migate from
155 
156     // MODIFIERS
157     
158     modifier onlyMigrationFromContract() {
159         require(msg.sender == migrationFromContract, "Only from migration contract");
160         _;
161     }
162     // EXTERNAL FUNCTIONS
163 
164     // PUBLIC FUNCTIONS
165 
166     /// @dev set contract to migrate to 
167     /// @param _toContract Then contract address to migrate to
168     function startMigrateToContract(address _toContract) public onlyOwner {
169         migrationToContract = _toContract;
170         require(MigrationAgent(migrationToContract).isMigrationAgent(), "not a migratable contract");
171         emit StartMigrateToContract(address(this), _toContract);
172     }
173 
174     /// @dev set contract to migrate from
175     /// @param _fromConstract Then contract address to migrate from
176     function startMigrateFromContract(address _fromConstract) public onlyOwner {
177         migrationFromContract = _fromConstract;
178         require(MigrationAgent(migrationFromContract).isMigrationAgent(), "not a migratable contract");
179         emit StartMigrateFromContract(_fromConstract, address(this));
180     }
181 
182     /// @dev Each user calls the migrate function on the original contract to migrate the users’ tokens to the migration agent migrateFrom on the `migrationToContract` contract
183     function migrate() public;   
184 
185     /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
186     /// @param _from The account to be migrated into new contract
187     /// @param _value The token balance to be migrated
188     function migrateFrom(address _from, uint256 _value) public returns(bool);
189 
190     /// @dev is a valid migration agent
191     /// @return true if contract is a migratable contract
192     function isMigrationAgent() public pure returns(bool) {
193         return true;
194     }
195 
196     // INTERNAL FUNCTIONS
197 
198     // PRIVATE FUNCTIONS
199 
200     // EVENTS
201 
202     event StartMigrateToContract(address indexed fromConstract, address indexed toContract);
203 
204     event StartMigrateFromContract(address indexed fromConstract, address indexed toContract);
205 
206     event MigratedTo(address indexed owner, address indexed _contract, uint256 value);
207 
208     event MigratedFrom(address indexed owner, address indexed _contract, uint256 value);
209 }
210 contract Pausable is Ownable {
211 
212     bool public paused = false;
213 
214     // MODIFIERS
215 
216     /**
217     * @dev Modifier to make a function callable only when the contract is not paused.
218     */
219     modifier whenNotPaused() {
220         require(!paused, "only when not paused");
221         _;
222     }
223 
224     /**
225     * @dev Modifier to make a function callable only when the contract is paused.
226     */
227     modifier whenPaused() {
228         require(paused, "only when paused");
229         _;
230     }
231 
232     /**
233     * @dev called by the owner to pause, triggers stopped state
234     */
235     function pause() public onlyOwner whenNotPaused {
236         paused = true;
237         emit Pause();
238     }
239 
240     /**
241     * @dev called by the owner to unpause, returns to normal state
242     */
243     function unpause() public onlyOwner whenPaused {
244         paused = false;
245         emit Unpause();
246     }
247 
248     // EVENTS
249 
250     event Pause();
251 
252     event Unpause();
253 }
254 
255 contract Operator is Ownable {
256 
257     address public operator;
258 
259     // MODIFIERS
260 
261     /**
262      * @dev modifier check for operator
263      */
264     modifier onlyOperator {
265         require(msg.sender == operator, "Only Operator");
266         _;
267     }
268 
269     // CONSTRUCTORS
270 
271     constructor() public {
272         operator = msg.sender;
273     }
274     /**
275      * @dev Transfer operator to `newOperator`.
276      *
277      * @param _newOperator   The address of the new operator
278      * @return balance Balance of the `_owner`.
279      */
280     function transferOperator(address _newOperator) public notNull(_newOperator) onlyOwner {
281         operator = _newOperator;
282         emit TransferOperator(operator, _newOperator);
283     }
284 
285     // EVENTS
286     
287     event TransferOperator(address indexed from, address indexed to);
288 }
289 
290 contract ERC20Token is Ownable, ERC20Interface {
291 
292     using SafeMath for uint256;
293 
294     mapping(address => uint256) internal balances;
295     mapping (address => mapping (address => uint256)) internal allowed;
296 
297     // CONSTRUCTORS
298 
299     constructor() public {
300     }
301 
302     // EXTERNAL FUNCTIONS
303 
304     // PUBLIC FUNCTIONS
305 
306     /// @notice send `_value` token to `_to` from `msg.sender`
307     /// @param _to The address of the recipient
308     /// @param _value The amount of token to be transferred
309     /// @return Whether the transfer was successful or not
310     function transfer(address _to, uint256 _value) public returns (bool success) {
311 
312         return transferInternal(msg.sender, _to, _value);
313     }
314 
315     /* ALLOW FUNCTIONS */
316 
317     /**
318     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
319     *
320     * Beware that changing an allowance with this method brings the risk that someone may use both the old
321     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
322     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
323     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
324     */
325    
326     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens   
327     /// @param _spender The address of the account able to transfer the tokens
328     /// @param _value The amount of tokens to be approved for transfer
329     /// @return Whether the approval was successful or not
330     function approve(address _spender, uint256 _value) public notNull(_spender) returns (bool success) {
331         allowed[msg.sender][_spender] = _value;
332         emit Approval(msg.sender, _spender, _value);
333         return true;
334     }
335 
336     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
337     /// @param _from The address of the sender
338     /// @param _to The address of the recipient
339     /// @param _value The amount of token to be transferred
340     /// @return Whether the transfer was successful or not
341     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
342         require(_value <= allowed[_from][msg.sender], "insufficient tokens");
343 
344         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
345         return transferInternal(_from, _to, _value);
346     }
347 
348     /**
349      * @dev Returns balance of the `_owner`.
350      *
351      * @param _owner   The address whose balance will be returned.
352      * @return balance Balance of the `_owner`.
353      */
354     function balanceOf(address _owner) public view returns (uint256) {
355         return balances[_owner];
356     }
357 
358     /// @param _owner The address of the account owning tokens
359     /// @param _spender The address of the account able to transfer the tokens
360     /// @return Amount of remaining tokens allowed to spent
361     function allowance(address _owner, address _spender) public view returns (uint256) {
362         return allowed[_owner][_spender];
363     }
364 
365     // INTERNAL FUNCTIONS
366 
367     /// @notice internal send `_value` token to `_to` from `_from` 
368     /// @param _from The address of the sender (null check performed in subTokens)
369     /// @param _to The address of the recipient (null check performed in addTokens)
370     /// @param _value The amount of token to be transferred 
371     /// @return Whether the transfer was successful or not
372     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool) {
373         uint256 value = subTokens(_from, _value);
374         addTokens(_to, value);
375         emit Transfer(_from, _to, value);
376         return true;
377     }
378    
379     /// @notice add tokens `_value` tokens to `owner`
380     /// @param _owner The address of the account
381     /// @param _value The amount of tokens to be added
382     function addTokens(address _owner, uint256 _value) internal;
383 
384     /// @notice subtract tokens `_value` tokens from `owner`
385     /// @param _owner The address of the account
386     /// @param _value The amount of tokens to be subtracted
387     function subTokens(address _owner, uint256 _value) internal returns (uint256 _valueDeducted );
388     
389     /// @notice set balance of account `owner` to `_value`
390     /// @param _owner The address of the account
391     /// @param _value The new balance 
392     function setBalance(address _owner, uint256 _value) internal notNull(_owner) {
393         balances[_owner] = _value;
394     }
395 
396     // PRIVATE FUNCTIONS
397 
398 }
399 
400 contract PausableToken is ERC20Token, Pausable {
401 
402     /// @notice send `_value` token to `_to` from `msg.sender`
403     /// @param _to The address of the recipient
404     /// @param _value The amount of token to be transferred
405     /// @return Whether the transfer was successful or not
406     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
407         return super.transfer(_to, _value);
408     }
409 
410     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
411     /// @param _from The address of the sender
412     /// @param _to The address of the recipient
413     /// @param _value The amount of token to be transferred
414     /// @return Whether the transfer was successful or not
415     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
416         return super.transferFrom(_from, _to, _value);
417     }
418 
419     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
420     /// @param _spender The address of the account able to transfer the tokens
421     /// @param _value The amount of tokens to be approved for transfer
422     /// @return Whether the approval was successful or not
423     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
424         return super.approve(_spender, _value);
425     }
426 }
427 
428 contract MintableToken is PausableToken
429 {
430     using SafeMath for uint256;
431 
432     address public minter; // minter
433 
434     uint256 internal minted; // total minted tokens
435     uint256 internal burned; // total burned tokens
436 
437     // MODIFIERS
438 
439     modifier onlyMinter {
440         assert(msg.sender == minter);
441         _; 
442     }
443 
444     constructor() public {
445         minter = msg.sender;   // Set the owner to minter
446     }
447 
448     // EXTERNAL FUNCTIONS
449 
450     // PUBLIC FUNCTIONS
451 
452     /// @dev  mint tokens to address
453     /// @notice mint `_value` token to `_to`
454     /// @param _to The address of the recipient
455     /// @param _value The amount of token to be minted
456     function mint(address _to, uint256 _value) public notNull(_to) onlyMinter {
457         addTokens(_to, _value);
458         notifyMinted(_to, _value);
459     }
460 
461     /// @dev burn tokens, e.g. when migrating
462     /// @notice burn `_value` token to `_to`
463     /// @param _value The amount of token to be burned from the callers account
464     function burn(uint256 _value) public whenNotPaused {
465         uint256 value = subTokens(msg.sender, _value);
466         notifyBurned(msg.sender, value);
467     }
468 
469     /// @dev transfer minter to new address
470     /// @notice transfer minter addres from  `minter` to `_newMinter`
471     /// @param _newMinter The address of the recipient
472     function transferMinter(address _newMinter) public notNull(_newMinter) onlyOwner {
473         address oldMinter = minter;
474         minter = _newMinter;
475         emit TransferMinter(oldMinter, _newMinter);
476     }
477 
478     // INTERNAL FUNCTIONS
479 
480     /// @dev update burned and emit Transfer event of burned tokens
481     /// @notice burn `_value` token from `_owner`
482     /// @param _owner The address of the owner
483     /// @param _value The amount of token burned
484     function notifyBurned(address _owner, uint256 _value) internal {
485         burned = burned.add(_value);
486         emit Transfer(_owner, address(0), _value);
487     }
488 
489     /// @dev update burned and emit Transfer event of burned tokens
490     /// @notice mint `_value` token to `_to`
491     /// @param _to The address of the recipient
492     /// @param _value The amount of token minted
493     function notifyMinted(address _to, uint256 _value) internal {
494         minted = minted.add(_value);
495         emit Transfer(address(0), _to, _value);
496     }
497 
498     /// @dev helper function to update token supply state and emit events 
499     /// @notice checkMintOrBurn for account `_owner` tokens chainging  from `_balanceBefore` to `_balanceAfter`
500     /// @param _owner The address of the owner
501     /// @param _balanceBefore The balance before the transaction
502     /// @param _balanceAfter The balance after the tranaaction
503     function checkMintOrBurn(address _owner, uint256 _balanceBefore, uint256 _balanceAfter) internal {
504         if (_balanceBefore > _balanceAfter) {
505             uint256 burnedTokens = _balanceBefore.sub(_balanceAfter);
506             notifyBurned(_owner, burnedTokens);
507         } else if (_balanceBefore < _balanceAfter) {
508             uint256 mintedTokens = _balanceAfter.sub(_balanceBefore);
509             notifyMinted(_owner, mintedTokens);
510         }
511     }
512 
513     /// @dev return total amount of tokens
514     function totalSupply() public view returns(uint256 supply) {
515         return minted.sub(burned);
516     }
517 
518     // PRIVATE FUNCTIONS
519 
520     // EVENTS
521     
522     event TransferMinter(address indexed from, address indexed to);
523 }
524 
525 contract CryptoFranc is MintableToken, MigrationAgent, Operator, InterestRateNone {
526 
527     using SafeMath for uint256;
528 
529     string constant public name = "CryptoFranc";
530     string constant public symbol = "XCHF";
531     uint256 constant public decimals = 18;
532     string constant public version = "1.0.0.0";
533     uint256 public dustAmount;
534 
535     // Changes as the token is converted to the next vintage
536     string public currentFullName;
537     string public announcedFullName;
538     uint256 public currentMaturityDate;
539     uint256 public announcedMaturityDate;
540     uint256 public currentTermEndDate;
541     uint256 public announcedTermEndDate;
542     InterestRateInterface public currentTerms;
543     InterestRateInterface public announcedTerms;
544 
545     mapping(address => uint256) internal compoundedInterestFactor;
546 
547     // CONSTRUCTORS
548 
549     constructor(string _initialFullName, uint256 _dustAmount) public {
550         // initially, there is no interest. This contract has an interest-free default implementation
551         // of the InterestRateInterface. Having this internalized saves gas in comparison to having an
552         // external, separate smart contract.
553         currentFullName = _initialFullName;
554         announcedFullName = _initialFullName;
555         dustAmount = _dustAmount;    
556         currentTerms = this;
557         announcedTerms = this;
558         announcedMaturityDate = block.timestamp;
559         announcedTermEndDate = block.timestamp;
560     }
561 
562     // EXTERNAL FUNCTIONS
563 
564     // PUBLIC FUNCTIONS
565 
566     /// @dev Invoked by the issuer to convert all the outstanding tokens into bonds of the latest vintage.
567     /// @param _newName Name of announced bond
568     /// @param _newTerms Address of announced bond
569     /// @param _newMaturityDate Maturity Date of announced bond
570     /// @param _newTermEndDate End Date of announced bond
571     function announceRollover(string _newName, address _newTerms, uint256 _newMaturityDate, uint256 _newTermEndDate) public notNull(_newTerms) onlyOperator {
572         // a new term can not be announced before the current is expired
573         require(block.timestamp >= announcedMaturityDate);
574 
575         // for test purposes
576         uint256 newMaturityDate;
577         if (_newMaturityDate == 0)
578             newMaturityDate = block.timestamp;
579         else
580             newMaturityDate = _newMaturityDate;
581 
582         // new newMaturityDate must be at least or greater than the existing announced terms end date
583         require(newMaturityDate >= announcedTermEndDate);
584 
585         //require new term dates not too far in the future
586         //this is to prevent severe operator time calculaton errors
587         require(newMaturityDate <= block.timestamp.add(100 days),"sanitycheck on newMaturityDate");
588         require(newMaturityDate <= _newTermEndDate,"term must start before it ends");
589         require(_newTermEndDate <= block.timestamp.add(200 days),"sanitycheck on newTermEndDate");
590 
591         InterestRateInterface terms = InterestRateInterface(_newTerms);
592         
593         // ensure that _newTerms begins at the compoundLevel that the announcedTerms ends
594         // they must align
595         uint256 newBeginLevel = terms.getCompoundingLevelDate(newMaturityDate);
596         uint256 annEndLevel = announcedTerms.getCompoundingLevelDate(newMaturityDate);
597         require(annEndLevel == newBeginLevel,"new initialCompoundingLevel <> old finalCompoundingLevel");
598 
599         //rollover
600         currentTerms = announcedTerms;
601         currentFullName = announcedFullName;
602         currentMaturityDate = announcedMaturityDate;
603         currentTermEndDate = announcedTermEndDate;
604         announcedTerms = terms;
605         announcedFullName = _newName;
606         announcedMaturityDate = newMaturityDate;
607         announcedTermEndDate = _newTermEndDate;
608 
609         emit AnnounceRollover(_newName, _newTerms, newMaturityDate, _newTermEndDate);
610     }
611 
612     /// @dev collectInterest is called to update the internal state of `_owner` balance and force a interest payment
613     /// This function does not change the effective amount of the `_owner` as returned by balanceOf
614     /// and thus, can be called by anyone willing to pay for the gas.
615     /// The designed usage for this function is to allow the CryptoFranc owner to collect interest from inactive accounts, 
616     /// since interest collection is updated automatically in normal transfers
617     /// calling collectInterest is functional equivalent to transfer 0 tokens to `_owner`
618     /// @param _owner The account being updated
619     function collectInterest( address _owner) public notNull(_owner) whenNotPaused {
620         uint256 rawBalance = super.balanceOf(_owner);
621         uint256 adjustedBalance = getAdjustedValue(_owner);
622         setBalance(_owner, adjustedBalance);
623         checkMintOrBurn(_owner, rawBalance, adjustedBalance);
624     }
625 
626     /*
627         MIGRATE FUNCTIONS
628      */
629     // safe migrate function
630     /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
631     /// @param _from The account to be migrated into new contract
632     /// @param _value The token balance to be migrated
633     function migrateFrom(address _from, uint256 _value) public onlyMigrationFromContract returns(bool) {
634         addTokens(_from, _value);
635         notifyMinted(_from, _value);
636 
637         emit MigratedFrom(_from, migrationFromContract, _value);
638         return true;
639     }
640 
641     /// @dev Each user calls the migrate function on the original contract to migrate the users’ tokens to the migration agent migrateFrom on the `migrationToContract` contract
642     function migrate() public whenNotPaused {
643         require(migrationToContract != 0, "not in migration mode"); // revert if not in migrate mode
644         uint256 value = balanceOf(msg.sender);
645         require (value > 0, "no balance"); // revert if not value left to transfer
646         value = subTokens(msg.sender, value);
647         notifyBurned(msg.sender, value);
648         require(MigrationAgent(migrationToContract).migrateFrom(msg.sender, value)==true, "migrateFrom must return true");
649 
650         emit MigratedTo(msg.sender, migrationToContract, value);
651     }
652 
653     /*
654         Helper FUNCTIONS
655     */
656 
657     /// @dev helper function to return foreign tokens accidental send to contract address
658     /// @param _tokenaddress Address of foreign ERC20 contract
659     /// @param _to Address to send foreign tokens to
660     function refundForeignTokens(address _tokenaddress,address _to) public notNull(_to) onlyOperator {
661         ERC20Interface token = ERC20Interface(_tokenaddress);
662         // transfer current balance for this contract to _to  in token contract
663         token.transfer(_to, token.balanceOf(this));
664     }
665 
666     /// @dev get fullname of active interest contract
667     function getFullName() public view returns (string) {
668         if ((block.timestamp <= announcedMaturityDate))
669             return currentFullName;
670         else
671             return announcedFullName;
672     }
673 
674     /// @dev get compounding level of an owner account
675     /// @param _owner tokens address
676     /// @return The compouding level
677     function getCompoundingLevel(address _owner) public view returns (uint256) {
678         uint256 level = compoundedInterestFactor[_owner];
679         if (level == 0) {
680             // important note that for InterestRateNone or empty accounts the compoundedInterestFactor is newer stored by setBalance
681             return SCALEFACTOR;
682         } else {
683             return level;
684         }
685     }
686 
687     /// @param _owner The address from which the balance will be retrieved
688     /// @return The balance
689     function balanceOf(address _owner) public view returns (uint256) {
690         return getAdjustedValue(_owner);
691     }
692 
693     // INTERNAL FUNCTIONS
694 
695     /// @notice add tokens `_value` tokens to `owner`
696     /// @param _owner The address of the account
697     /// @param _value The amount of tokens to be added
698     function addTokens(address _owner,uint256 _value) notNull(_owner) internal {
699         uint256 rawBalance = super.balanceOf(_owner);
700         uint256 adjustedBalance = getAdjustedValue(_owner);
701         setBalance(_owner, adjustedBalance.add(_value));
702         checkMintOrBurn(_owner, rawBalance, adjustedBalance);
703     }
704 
705     /// @notice subtract tokens `_value` tokens from `owner`
706     /// @param _owner The address of the account
707     /// @param _value The amount of tokens to be subtracted
708     function subTokens(address _owner, uint256 _value) internal notNull(_owner) returns (uint256 _valueDeducted ) {
709         uint256 rawBalance = super.balanceOf(_owner);
710         uint256 adjustedBalance = getAdjustedValue(_owner);
711         uint256 newBalance = adjustedBalance.sub(_value);
712         if (newBalance <= dustAmount) {
713             // dont leave balance below dust, empty account
714             _valueDeducted = _value.add(newBalance);
715             newBalance =  0;
716         } else {
717             _valueDeducted = _value;
718         }
719         setBalance(_owner, newBalance);
720         checkMintOrBurn(_owner, rawBalance, adjustedBalance);
721     }
722 
723     /// @notice set balance of account `owner` to `_value`
724     /// @param _owner The address of the account
725     /// @param _value The new balance 
726     function setBalance(address _owner, uint256 _value) internal {
727         super.setBalance(_owner, _value);
728         // update `owner`s compoundLevel
729         if (_value == 0) {
730             // stall account release storage
731             delete compoundedInterestFactor[_owner];
732         } else {
733             // only update compoundedInterestFactor when value has changed 
734             // important note: for InterestRateNone the compoundedInterestFactor is newer stored because the default value for getCompoundingLevel is SCALEFACTOR
735             uint256 currentLevel = getInterestRate().getCurrentCompoundingLevel();
736             if (currentLevel != getCompoundingLevel(_owner)) {
737                 compoundedInterestFactor[_owner] = currentLevel;
738             }
739         }
740     }
741 
742     /// @dev get address of active bond
743     function getInterestRate() internal view returns (InterestRateInterface) {
744         if ((block.timestamp <= announcedMaturityDate))
745             return currentTerms;
746         else
747             return announcedTerms;
748     }
749 
750     /// @notice get adjusted balance of account `owner`
751     /// @param _owner The address of the account
752     function getAdjustedValue(address _owner) internal view returns (uint256) {
753         uint256 _rawBalance = super.balanceOf(_owner);
754         // if _rawBalance is 0 dont perform calculations
755         if (_rawBalance == 0)
756             return 0;
757         // important note: for empty/new account the getCompoundingLevel value is not meaningfull
758         uint256 startLevel = getCompoundingLevel(_owner);
759         uint256 currentLevel = getInterestRate().getCurrentCompoundingLevel();
760         return _rawBalance.mul(currentLevel).div(startLevel);
761     }
762 
763     /// @notice get adjusted balance of account `owner` at data `date`
764     /// @param _owner The address of the account
765     /// @param _date The date of the balance NB: MUST be within valid current and announced Terms date range
766     function getAdjustedValueDate(address _owner,uint256 _date) public view returns (uint256) {
767         uint256 _rawBalance = super.balanceOf(_owner);
768         // if _rawBalance is 0 dont perform calculations
769         if (_rawBalance == 0)
770             return 0;
771         // important note: for empty/new account the getCompoundingLevel value is not meaningfull
772         uint256 startLevel = getCompoundingLevel(_owner);
773 
774         InterestRateInterface dateTerms;
775         if (_date <= announcedMaturityDate)
776             dateTerms = currentTerms;
777         else
778             dateTerms = announcedTerms;
779 
780         uint256 dateLevel = dateTerms.getCompoundingLevelDate(_date);
781         return _rawBalance.mul(dateLevel).div(startLevel);
782     }
783 
784     // PRIVATE FUNCTIONS
785 
786     // EVENTS
787 
788     event AnnounceRollover(string newName, address indexed newTerms, uint256 indexed newMaturityDate, uint256 indexed newTermEndDate);
789 }