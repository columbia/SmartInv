1 pragma solidity 0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42     function getOwner() public view returns (address) {
43         return owner;
44     }
45 
46     function getOwnerStatic(address ownableContract) internal view returns (address) {
47         bytes memory callcodeOwner = abi.encodeWithSignature("getOwner()");
48         (bool success, bytes memory returnData) = address(ownableContract).staticcall(callcodeOwner);
49         require(success, "input address has to be a valid ownable contract");
50         return parseAddr(returnData);
51     }
52 
53     function getTokenVestingStatic(address tokenFactoryContract) internal view returns (address) {
54         bytes memory callcodeTokenVesting = abi.encodeWithSignature("getTokenVesting()");
55         (bool success, bytes memory returnData) = address(tokenFactoryContract).staticcall(callcodeTokenVesting);
56         require(success, "input address has to be a valid TokenFactory contract");
57         return parseAddr(returnData);
58     }
59 
60 
61     function parseAddr(bytes memory data) public pure returns (address parsed){
62         assembly {parsed := mload(add(data, 32))}
63     }
64 
65 
66 
67 
68 }
69 
70 /**
71  * @title Registry contract for storing token proposals
72  * @dev For storing token proposals. This can be understood as a state contract with minimal CRUD logic.
73  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
74  */
75 contract Registry is Ownable {
76 
77     struct Creator {
78         address token;
79         string name;
80         string symbol;
81         uint8 decimals;
82         uint256 totalSupply;
83         address proposer;
84         address vestingBeneficiary;
85         uint8 initialPercentage;
86         uint256 vestingPeriodInWeeks;
87         bool approved;
88     }
89 
90     mapping(bytes32 => Creator) public rolodex;
91     mapping(string => bytes32)  nameToIndex;
92     mapping(string => bytes32)  symbolToIndex;
93 
94     event LogProposalSubmit(string name, string symbol, address proposer, bytes32 indexed hashIndex);
95     event LogProposalApprove(string name, address indexed tokenAddress);
96 
97     /**
98      * @dev Submit token proposal to be stored, only called by Owner, which is set to be the Manager contract
99      * @param _name string Name of token
100      * @param _symbol string Symbol of token
101      * @param _decimals uint8 Decimals of token
102      * @param _totalSupply uint256 Total Supply of token
103      * @param _initialPercentage uint8 Initial Percentage of total supply to Vesting Beneficiary
104      * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for
105      * @param _vestingBeneficiary address Address of Vesting Beneficiary
106      * @param _proposer address Address of Proposer of Token, also the msg.sender of function call in Manager contract
107      * @return bytes32 It will return a hash index which is calculated as keccak256(_name, _symbol, _proposer)
108      */
109     function submitProposal(
110         string memory _name,
111         string memory _symbol,
112         uint8 _decimals,
113         uint256 _totalSupply,
114         uint8 _initialPercentage,
115         uint256 _vestingPeriodInWeeks,
116         address _vestingBeneficiary,
117         address _proposer
118     )
119     public
120     onlyOwner
121     returns (bytes32 hashIndex)
122     {
123         nameDoesNotExist(_name);
124         symbolDoesNotExist(_symbol);
125         hashIndex = keccak256(abi.encodePacked(_name, _symbol, _proposer));
126         rolodex[hashIndex] = Creator({
127             token : address(0),
128             name : _name,
129             symbol : _symbol,
130             decimals : _decimals,
131             totalSupply : _totalSupply,
132             proposer : _proposer,
133             vestingBeneficiary : _vestingBeneficiary,
134             initialPercentage : _initialPercentage,
135             vestingPeriodInWeeks : _vestingPeriodInWeeks,
136             approved : false
137         });
138         emit LogProposalSubmit(_name, _symbol, msg.sender, hashIndex);
139     }
140 
141     /**
142      * @dev Approve token proposal, only called by Owner, which is set to be the Manager contract
143      * @param _hashIndex bytes32 Hash Index of Token proposal
144      * @param _token address Address of Token which has already been launched
145      * @return bool Whether it has completed the function
146      * @dev Notice that the only things that have changed from an approved proposal to one that is not
147      * is simply the .token and .approved object variables.
148      */
149     function approveProposal(
150         bytes32 _hashIndex,
151         address _token
152     )
153     external
154     onlyOwner
155     returns (bool)
156     {
157         Creator memory c = rolodex[_hashIndex];
158         nameDoesNotExist(c.name);
159         symbolDoesNotExist(c.symbol);
160         rolodex[_hashIndex].token = _token;
161         rolodex[_hashIndex].approved = true;
162         nameToIndex[c.name] = _hashIndex;
163         symbolToIndex[c.symbol] = _hashIndex;
164         emit LogProposalApprove(c.name, _token);
165         return true;
166     }
167 
168     //Getters
169 
170     function getIndexByName(
171         string memory _name
172         )
173     public
174     view
175     returns (bytes32)
176     {
177         return nameToIndex[_name];
178     }
179 
180     function getIndexSymbol(
181         string memory _symbol
182         )
183     public
184     view
185     returns (bytes32)
186     {
187         return symbolToIndex[_symbol];
188     }
189 
190     function getCreatorByIndex(
191         bytes32 _hashIndex
192     )
193     external
194     view
195     returns (Creator memory)
196     {
197         return rolodex[_hashIndex];
198     }
199 
200 
201 
202     //Assertive functions
203 
204     function nameDoesNotExist(string memory _name) internal view {
205         require(nameToIndex[_name] == 0x0, "Name already exists");
206     }
207 
208     function symbolDoesNotExist(string memory _name) internal view {
209         require(symbolToIndex[_name] == 0x0, "Symbol already exists");
210     }
211 }
212 
213 /**
214  * @title SafeMath
215  * @dev Math operations with safety checks that throw on error
216  */
217 library SafeMath {
218 
219   /**
220   * @dev Multiplies two numbers, throws on overflow.
221   */
222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
223         if (a == 0) {
224             return 0;
225     }
226         uint256 c = a * b;
227         assert(c / a == b);
228         return c;
229     }
230 
231   /**
232   * @dev Integer division of two numbers, truncating the quotient.
233   */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235     // assert(b > 0); // Solidity automatically throws when dividing by 0
236     // uint256 c = a / b;
237     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238         return a / b;
239     }
240 
241   /**
242   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
243   */
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         assert(b <= a);
246         return a - b;
247     }
248 
249   /**
250   * @dev Adds two numbers, throws on overflow.
251   */
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         assert(c >= a);
255         return c;
256     }
257 }
258 
259 /**
260  * @title ERC20 interface
261  * @dev see https://github.com/ethereum/EIPs/issues/20
262  */
263 interface IERC20 {
264   function totalSupply() external view returns (uint256);
265 
266   function balanceOf(address who) external view returns (uint256);
267 
268   function allowance(address owner, address spender)
269     external view returns (uint256);
270 
271   function transfer(address to, uint256 value) external returns (bool);
272 
273   function approve(address spender, uint256 value)
274     external returns (bool);
275 
276   function transferFrom(address from, address to, uint256 value)
277     external returns (bool);
278 
279   event Transfer(
280     address indexed from,
281     address indexed to,
282     uint256 value
283   );
284 
285   event Approval(
286     address indexed owner,
287     address indexed spender,
288     uint256 value
289   );
290 }
291 
292     /**
293     * @title Standard ERC20 token
294     *
295     * @dev Implementation of the basic standard token.
296     * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
297     * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
298     */
299 contract ERC20 is IERC20 {
300     using SafeMath for uint256;
301 
302     mapping (address => uint256) private _balances;
303 
304     mapping (address => mapping (address => uint256)) private _allowed;
305 
306     uint256 private _totalSupply;
307     string public name;
308     string public symbol;
309     uint8 public decimals;
310 
311     /**
312     * @dev Total number of tokens in existence
313     */
314     function totalSupply() public view returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319     * @dev Gets the balance of the specified address.
320     * @param owner The address to query the the balance of.
321     * @return An uint256 representing the amount owned by the passed address.
322     */
323     function balanceOf(address owner) public view returns (uint256) {
324         return _balances[owner];
325     }
326 
327     /**
328     * @dev Function to check the amount of tokens that an owner allowed to a spender.
329     * @param owner address The address which owns the funds.
330     * @param spender address The address which will spend the funds.
331     * @return A uint256 specifying the amount of tokens still available for the spender.
332     */
333     function allowance(
334         address owner,
335         address spender
336     )
337         public
338         view
339         returns (uint256)
340     {
341         return _allowed[owner][spender];
342     }
343 
344 
345     /**
346     * @dev Transfer token for a specified address
347     * @param to The address to transfer to.
348     * @param value The amount to be transferred.
349     */
350     function transfer(address to, uint256 value) public returns (bool) {
351         require(value <= _balances[msg.sender]);
352         require(to != address(0));
353 
354         _balances[msg.sender] = _balances[msg.sender].sub(value);
355         _balances[to] = _balances[to].add(value);
356         emit Transfer(msg.sender, to, value);
357         return true;
358     }
359 
360     /**
361     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
362     * Beware that changing an allowance with this method brings the risk that someone may use both the old
363     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
364     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
365     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366     * @param spender The address which will spend the funds.
367     * @param value The amount of tokens to be spent.
368     */
369     function approve(address spender, uint256 value) public returns (bool) {
370         require(spender != address(0));
371 
372         _allowed[msg.sender][spender] = value;
373         emit Approval(msg.sender, spender, value);
374         return true;
375     }
376 
377     /**
378     * @dev Transfer tokens from one address to another
379     * @param from address The address which you want to send tokens from
380     * @param to address The address which you want to transfer to
381     * @param value uint256 the amount of tokens to be transferred
382     */
383     function transferFrom(
384         address from,
385         address to,
386         uint256 value
387     )
388         public
389         returns (bool)
390     {
391         require(value <= _balances[from]);
392         require(value <= _allowed[from][msg.sender]);
393         require(to != address(0));
394 
395         _balances[from] = _balances[from].sub(value);
396         _balances[to] = _balances[to].add(value);
397         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
398         emit Transfer(from, to, value);
399         return true;
400     }
401 
402     /**
403     * @dev Increase the amount of tokens that an owner allowed to a spender.
404     * approve should be called when allowed_[_spender] == 0. To increment
405     * allowed value is better to use this function to avoid 2 calls (and wait until
406     * the first transaction is mined)
407     * From MonolithDAO Token.sol
408     * @param spender The address which will spend the funds.
409     * @param addedValue The amount of tokens to increase the allowance by.
410     */
411     function increaseAllowance(
412         address spender,
413         uint256 addedValue
414     )
415         public
416         returns (bool)
417     {
418         require(spender != address(0));
419 
420         _allowed[msg.sender][spender] = (
421         _allowed[msg.sender][spender].add(addedValue));
422         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
423         return true;
424     }
425 
426     /**
427     * @dev Decrease the amount of tokens that an owner allowed to a spender.
428     * approve should be called when allowed_[_spender] == 0. To decrement
429     * allowed value is better to use this function to avoid 2 calls (and wait until
430     * the first transaction is mined)
431     * From MonolithDAO Token.sol
432     * @param spender The address which will spend the funds.
433     * @param subtractedValue The amount of tokens to decrease the allowance by.
434     */
435     function decreaseAllowance(
436         address spender,
437         uint256 subtractedValue
438     )
439         public
440         returns (bool)
441     {
442         require(spender != address(0));
443 
444         _allowed[msg.sender][spender] = (
445         _allowed[msg.sender][spender].sub(subtractedValue));
446         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
447         return true;
448     }
449 
450     /**
451     * @dev Internal function that mints an amount of the token and assigns it to
452     * an account. This encapsulates the modification of balances such that the
453     * proper events are emitted.
454     * @param account The account that will receive the created tokens.
455     * @param amount The amount that will be created.
456     */
457     function _mint(address account, uint256 amount) internal {
458         require(account != address(0));
459         _totalSupply = _totalSupply.add(amount);
460         _balances[account] = _balances[account].add(amount);
461         emit Transfer(address(0), account, amount);
462     }
463 
464     /**
465     * @dev Internal function that burns an amount of the token of a given
466     * account.
467     * @param account The account whose tokens will be burnt.
468     * @param amount The amount that will be burnt.
469     */
470     function _burn(address account, uint256 amount) internal {
471         require(account != address(0));
472         require(amount <= _balances[account]);
473 
474         _totalSupply = _totalSupply.sub(amount);
475         _balances[account] = _balances[account].sub(amount);
476         emit Transfer(account, address(0), amount);
477     }
478 
479     /**
480     * @dev Internal function that burns an amount of the token of a given
481     * account, deducting from the sender's allowance for said account. Uses the
482     * internal burn function.
483     * @param account The account whose tokens will be burnt.
484     * @param amount The amount that will be burnt.
485     */
486     function _burnFrom(address account, uint256 amount) internal {
487         require(amount <= _allowed[account][msg.sender]);
488 
489         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
490         // this function needs to emit an event with the updated approval.
491         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
492         amount);
493         _burn(account, amount);
494     }
495 
496     function burnFrom(address account, uint256 amount) public {
497         _burnFrom(account, amount);
498     }
499 }
500 
501 /**
502  * @title Template contract for social money, to be used by TokenFactory
503  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
504  */
505 
506 
507 
508 contract SocialMoney is ERC20 {
509 
510     /**
511      * @dev Constructor on SocialMoney
512      * @param _name string Name parameter of Token
513      * @param _symbol string Symbol parameter of Token
514      * @param _decimals uint8 Decimals parameter of Token
515      * @param _proportions uint256[3] Parameter that dictates how totalSupply will be divvied up,
516                             _proportions[0] = Vesting Beneficiary Initial Supply
517                             _proportions[1] = Turing Supply
518                             _proportions[2] = Vesting Beneficiary Vesting Supply
519      * @param _vestingBeneficiary address Address of the Vesting Beneficiary
520      * @param _platformWallet Address of Turing platform wallet
521      * @param _tokenVestingInstance address Address of Token Vesting contract
522      */
523     constructor(
524         string memory _name,
525         string memory _symbol,
526         uint8 _decimals,
527         uint256[3] memory _proportions,
528         address _vestingBeneficiary,
529         address _platformWallet,
530         address _tokenVestingInstance
531     )
532     public
533     {
534         name = _name;
535         symbol = _symbol;
536         decimals = _decimals;
537 
538         uint256 totalProportions = _proportions[0].add(_proportions[1]).add(_proportions[2]);
539 
540         _mint(_vestingBeneficiary, _proportions[0]);
541         _mint(_platformWallet, _proportions[1]);
542         _mint(_tokenVestingInstance, _proportions[2]);
543 
544         //Sanity check that the totalSupply is exactly where we want it to be
545         assert(totalProportions == totalSupply());
546     }
547 }
548 
549 /**
550  * @title TokenVesting contract for linearly vesting tokens to the respective vesting beneficiary
551  * @dev This contract receives accepted proposals from the Manager contract, and holds in lieu
552  * @dev all the tokens to be vested by the vesting beneficiary. It releases these tokens when called
553  * @dev upon in a continuous-like linear fashion.
554  * @notice This contract was written with reference to the TokenVesting contract from openZeppelin
555  * @notice @ https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/drafts/TokenVesting.sol
556  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
557  */
558 contract TokenVesting is Ownable{
559 
560     using SafeMath for uint256;
561 
562     event Released(address indexed token, address vestingBeneficiary, uint256 amount);
563     event LogTokenAdded(address indexed token, address vestingBeneficiary, uint256 vestingPeriodInWeeks);
564 
565     uint256 constant public WEEKS_IN_SECONDS = 1 * 7 * 24 * 60 * 60;
566 
567     struct VestingInfo {
568         address vestingBeneficiary;
569         uint256 releasedSupply;
570         uint256 start;
571         uint256 duration;
572     }
573 
574     mapping(address => VestingInfo) public vestingInfo;
575 
576     /**
577      * @dev Method to add a token into TokenVesting
578      * @param _token address Address of token
579      * @param _vestingBeneficiary address Address of vesting beneficiary
580      * @param _vestingPeriodInWeeks uint256 Period of vesting, in units of Weeks, to be converted
581      * @notice This emits an Event LogTokenAdded which is indexed by the token address
582      */
583     function addToken
584     (
585         address _token,
586         address _vestingBeneficiary,
587         uint256 _vestingPeriodInWeeks
588     )
589     external
590     onlyOwner
591     {
592         vestingInfo[_token] = VestingInfo({
593             vestingBeneficiary : _vestingBeneficiary,
594             releasedSupply : 0,
595             start : now,
596             duration : uint256(_vestingPeriodInWeeks).mul(WEEKS_IN_SECONDS)
597         });
598         emit LogTokenAdded(_token, _vestingBeneficiary, _vestingPeriodInWeeks);
599     }
600 
601     /**
602      * @dev Method to release any already vested but not yet received tokens
603      * @param _token address Address of Token
604      * @notice This emits an Event LogTokenAdded which is indexed by the token address
605      */
606 
607     function release
608     (
609         address _token
610     )
611     external
612     {
613         uint256 unreleased = releaseableAmount(_token);
614         require(unreleased > 0);
615         vestingInfo[_token].releasedSupply = vestingInfo[_token].releasedSupply.add(unreleased);
616         bool success = ERC20(_token).transfer(vestingInfo[_token].vestingBeneficiary, unreleased);
617         require(success, "transfer from vesting to beneficiary has to succeed");
618         emit Released(_token, vestingInfo[_token].vestingBeneficiary, unreleased);
619     }
620 
621     /**
622      * @dev Method to check the quantity of token that is already vested but not yet received
623      * @param _token address Address of Token
624      * @return uint256 Quantity of token that is already vested but not yet received
625      */
626     function releaseableAmount
627     (
628         address _token
629     )
630     public
631     view
632     returns(uint256)
633     {
634         return vestedAmount(_token).sub(vestingInfo[_token].releasedSupply);
635     }
636 
637     /**
638      * @dev Method to check the quantity of token vested at current block
639      * @param _token address Address of Token
640      * @return uint256 Quantity of token that is vested at current block
641      */
642 
643     function vestedAmount
644     (
645         address _token
646     )
647     public
648     view
649     returns(uint256)
650     {
651         VestingInfo memory info = vestingInfo[_token];
652         uint256 currentBalance = ERC20(_token).balanceOf(address(this));
653         uint256 totalBalance = currentBalance.add(info.releasedSupply);
654         if (now >= info.start.add(info.duration)) {
655             return totalBalance;
656         } else {
657             return totalBalance.mul(now.sub(info.start)).div(info.duration);
658         }
659 
660     }
661 
662 
663     function getVestingInfo
664     (
665         address _token
666     )
667     external
668     view
669     returns(VestingInfo memory)
670     {
671         return vestingInfo[_token];
672     }
673 
674 
675 }
676 
677 /**
678  * @title TokenFactory contract for creating tokens from token proposals
679  * @dev For creating tokens from pre-set parameters. This can be understood as a contract factory.
680  * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
681  */
682 contract TokenFactory is Ownable{
683 
684     using SafeMath for uint256;
685 
686     uint8 public PLATFORM_PERCENTAGE;
687     address public PLATFORM_WALLET;
688     TokenVesting public TokenVestingInstance;
689 
690     event LogTokenCreated(string name, string symbol, address indexed token, address vestingBeneficiary);
691     event LogPlatformPercentageChanged(uint8 oldP, uint8 newP);
692     event LogPlatformWalletChanged(address oldPW, address newPW);
693     event LogTokenVestingChanged(address oldTV, address newTV);
694     event LogTokenFactoryMigrated(address newTokenFactory);
695 
696     /**
697      * @dev Constructor method
698      * @param _tokenVesting address Address of tokenVesting contract. If set to address(0), it will create one instead.
699      * @param _turingWallet address Turing Wallet address for sending out proportion of tokens alloted to it.
700      */
701     constructor(
702         address _tokenVesting,
703         address _turingWallet,
704         uint8 _platformPercentage
705     )
706     validatePercentage(_platformPercentage)
707     validateAddress(_turingWallet)
708     public
709     {
710 
711         require(_turingWallet != address(0), "Turing Wallet address must be non zero");
712         PLATFORM_WALLET = _turingWallet;
713         PLATFORM_PERCENTAGE = _platformPercentage;
714         if (_tokenVesting == address(0)){
715             TokenVestingInstance = new TokenVesting();
716         }
717         else{
718             TokenVestingInstance = TokenVesting(_tokenVesting);
719         }
720 
721     }
722 
723 
724     /**
725      * @dev Create token method
726      * @param _name string Name parameter of Token
727      * @param _symbol string Symbol parameter of Token
728      * @param _decimals uint8 Decimals parameter of Token, restricted to < 18
729      * @param _totalSupply uint256 Total Supply paramter of Token
730      * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
731      * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for, restricted to > 1
732      * @param _vestingBeneficiary address Address of the Vesting Beneficiary
733      * @return address Address of token that has been created by those parameters
734      */
735     function createToken(
736         string memory _name,
737         string memory _symbol,
738         uint8 _decimals,
739         uint256 _totalSupply,
740         uint8 _initialPercentage,
741         uint256 _vestingPeriodInWeeks,
742         address _vestingBeneficiary
743 
744     )
745     public
746     onlyOwner
747     returns (address token)
748     {
749         uint256[3] memory proportions = calculateProportions(_totalSupply, _initialPercentage);
750         require(proportions[0].add(proportions[1]).add(proportions[2]) == _totalSupply,
751         "The supply must be same as the proportion, sanity check.");
752         SocialMoney sm = new SocialMoney(
753             _name,
754             _symbol,
755             _decimals,
756             proportions,
757             _vestingBeneficiary,
758             PLATFORM_WALLET,
759             address(TokenVestingInstance)
760         );
761         TokenVestingInstance.addToken(address(sm), _vestingBeneficiary, _vestingPeriodInWeeks);
762         token = address(sm);
763         emit LogTokenCreated(_name, _symbol, token, _vestingBeneficiary);
764     }
765 
766     /**
767      * @dev Calculate proportions method
768      * @param _totalSupply uint256 Total Supply parameter of Token
769      * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
770      * @dev Calculates supply given to the Turing platform, the Creator and the vesting supply
771      * @return bytes32 Hash Index which is composed by the keccak256(name, symbol, msg.sender)
772      */
773     function calculateProportions(
774         uint256 _totalSupply,
775         uint8 _initialPercentage
776     )
777     private
778     view
779     validateTotalPercentage(_initialPercentage)
780     returns (uint256[3] memory proportions)
781     {
782         proportions[0] = (_totalSupply).mul(_initialPercentage).div(100); //Initial Supply to Creator
783         proportions[1] = (_totalSupply).mul(PLATFORM_PERCENTAGE).div(100); //Supply to Platform
784         proportions[2] = (_totalSupply).sub(proportions[0]).sub(proportions[1]); // Remaining Supply to vest on
785     }
786 
787 
788 
789     function setPlatformPercentage(
790         uint8 _newPercentage
791     )
792     external
793     validatePercentage(_newPercentage)
794     onlyOwner
795     {
796         emit LogPlatformPercentageChanged(PLATFORM_PERCENTAGE, _newPercentage);
797         PLATFORM_PERCENTAGE = _newPercentage;
798     }
799 
800     function setPlatformWallet(
801         address _newPlatformWallet
802     )
803     external
804     validateAddress(_newPlatformWallet)
805     onlyOwner
806     {
807         emit LogPlatformWalletChanged(PLATFORM_WALLET, _newPlatformWallet);
808         PLATFORM_WALLET = _newPlatformWallet;
809     }
810 
811     function migrateTokenFactory(
812         address _newTokenFactory
813     )
814     external
815     onlyOwner
816     {
817         TokenVestingInstance.transferOwnership(_newTokenFactory);
818         emit LogTokenFactoryMigrated(_newTokenFactory);
819     }
820 
821     function setTokenVesting(
822         address _newTokenVesting
823     )
824     external
825     onlyOwner
826     {
827         require(getOwnerStatic(_newTokenVesting) == address(this), "new TokenVesting not owned by TokenFactory");
828         emit LogTokenVestingChanged(address(TokenVestingInstance), address(_newTokenVesting));
829         TokenVestingInstance = TokenVesting(_newTokenVesting);
830     }
831 
832 
833 
834     modifier validatePercentage(uint8 percentage){
835         require(percentage > 0 && percentage < 100);
836         _;
837     }
838 
839     modifier validateAddress(address addr){
840         require(addr != address(0));
841         _;
842     }
843 
844     modifier validateTotalPercentage(uint8 _x) {
845         require(PLATFORM_PERCENTAGE + _x < 100);
846         _;
847     }
848 
849     function getTokenVesting() external view returns (address) {
850         return address(TokenVestingInstance);
851     }
852 }
853 
854 
855 /**
856  * FOR THE AUDITOR
857  * This contract was designed with the idea that it would be owned by
858  * another multi-party governance-like contract such as a multi-sig
859  * or a yet-to-be researched governance protocol to be placed on top of
860  */
861 
862 
863 /**
864  * @title Manager contract for receiving proposals and creating tokens
865  * @dev For receiving token proposals and creating said tokens from such parameters.
866  * @dev State is separated onto Registry contract
867  * @dev To set up a working version of the entire platform, first create TokenFactory,
868  * Registry, then transfer ownership to the Manager contract. Ensure as well that TokenVesting is
869  * created for a valid TokenFactory. See the truffle
870  * test, especially manager_test.js to understand how this would be done offline.
871  * @author Jake Goh Si Yuan @jakegsy, jake@jakegsy.com
872  */
873 contract Manager is Ownable {
874 
875     using SafeMath for uint256;
876 
877     Registry public RegistryInstance;
878     TokenFactory public TokenFactoryInstance;
879 
880     event LogTokenFactoryChanged(address oldTF, address newTF);
881     event LogRegistryChanged(address oldR, address newR);
882     event LogManagerMigrated(address indexed newManager);
883 
884     /**
885      * @dev Constructor on Manager
886      * @param _registry address Address of Registry contract
887      * @param _tokenFactory address Address of TokenFactory contract
888      * @notice It is recommended that all the component contracts be launched before Manager
889      */
890     constructor(
891         address _registry,
892         address _tokenFactory
893     )
894     public
895     {
896         require(_registry != address(0) && _tokenFactory != address(0));
897         TokenFactoryInstance = TokenFactory(_tokenFactory);
898         RegistryInstance = Registry(_registry);
899     }
900 
901     /**
902      * @dev Submit Token Proposal
903      * @param _name string Name parameter of Token
904      * @param _symbol string Symbol parameter of Token
905      * @param _decimals uint8 Decimals parameter of Token, restricted to < 18
906      * @param _totalSupply uint256 Total Supply paramter of Token
907      * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
908      * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for, restricted to > 1
909      * @param _vestingBeneficiary address Address of the Vesting Beneficiary
910      * @return bytes32 Hash Index which is composed by the keccak256(name, symbol, msg.sender)
911      */
912 
913     function submitProposal(
914         string memory _name,
915         string memory _symbol,
916         uint8 _decimals,
917         uint256 _totalSupply,
918         uint8 _initialPercentage,
919         uint256 _vestingPeriodInWeeks,
920         address _vestingBeneficiary
921     )
922     validatePercentage(_initialPercentage)
923     validateDecimals(_decimals)
924     validateVestingPeriod(_vestingPeriodInWeeks)
925     isInitialized()
926     public
927     returns (bytes32 hashIndex)
928     {
929         hashIndex = RegistryInstance.submitProposal(_name,_symbol,_decimals,_totalSupply,
930         _initialPercentage, _vestingPeriodInWeeks, _vestingBeneficiary, msg.sender);
931     }
932 
933     /**
934      * @dev Approve Token Proposal
935      * @param _hashIndex bytes32 Hash Index of Token Proposal, given by keccak256(name, symbol, msg.sender)
936      */
937     function approveProposal(
938         bytes32 _hashIndex
939     )
940     isInitialized()
941     onlyOwner
942     external
943     {
944         //Registry.Creator memory approvedProposal = RegistryInstance.rolodex(_hashIndex);
945         Registry.Creator memory approvedProposal = RegistryInstance.getCreatorByIndex(_hashIndex);
946         address ac = TokenFactoryInstance.createToken(
947             approvedProposal.name,
948             approvedProposal.symbol,
949             approvedProposal.decimals,
950             approvedProposal.totalSupply,
951             approvedProposal.initialPercentage,
952             approvedProposal.vestingPeriodInWeeks,
953             approvedProposal.vestingBeneficiary
954             );
955         bool success = RegistryInstance.approveProposal(_hashIndex, ac);
956         require(success, "Registry approve proposal has to succeed");
957     }
958 
959 
960     /*
961      * CHANGE PLATFORM VARIABLES AND INSTANCES
962      */
963 
964 
965     function setPlatformWallet(
966         address _newPlatformWallet
967     )
968     onlyOwner
969     isInitialized()
970     external
971     {
972         TokenFactoryInstance.setPlatformWallet(_newPlatformWallet);
973     }
974 
975     function setTokenFactoryPercentage(
976         uint8 _newPercentage
977     )
978     onlyOwner
979     validatePercentage(_newPercentage)
980     isInitialized()
981     external
982     {
983         TokenFactoryInstance.setPlatformPercentage(_newPercentage);
984     }
985 
986     function setTokenFactory(
987         address _newTokenFactory
988     )
989     onlyOwner
990     external
991     {
992 
993         require(getOwnerStatic(_newTokenFactory) == address(this), "new TokenFactory has to be owned by Manager");
994         require(getTokenVestingStatic(_newTokenFactory) == address(TokenFactoryInstance.TokenVestingInstance()), "TokenVesting has to be the same");
995         TokenFactoryInstance.migrateTokenFactory(_newTokenFactory);
996         require(getOwnerStatic(getTokenVestingStatic(_newTokenFactory))== address(_newTokenFactory), "TokenFactory does not own TokenVesting");
997         emit LogTokenFactoryChanged(address(TokenFactoryInstance), address(_newTokenFactory));
998         TokenFactoryInstance = TokenFactory(_newTokenFactory);
999     }
1000 
1001     function setRegistry(
1002         address _newRegistry
1003     )
1004 
1005     onlyOwner
1006     external
1007     {
1008         require(getOwnerStatic(_newRegistry) == address(this), "new Registry has to be owned by Manager");
1009         emit LogRegistryChanged(address(RegistryInstance), _newRegistry);
1010         RegistryInstance = Registry(_newRegistry);
1011     }
1012 
1013     function setTokenVesting(
1014         address _newTokenVesting
1015     )
1016     onlyOwner
1017     external
1018     {
1019         TokenFactoryInstance.setTokenVesting(_newTokenVesting);
1020     }
1021 
1022     function migrateManager(
1023         address _newManager
1024     )
1025     onlyOwner
1026     isInitialized()
1027     external
1028     {
1029         RegistryInstance.transferOwnership(_newManager);
1030         TokenFactoryInstance.transferOwnership(_newManager);
1031         emit LogManagerMigrated(_newManager);
1032     }
1033 
1034     modifier validatePercentage(uint8 percentage) {
1035         require(percentage > 0 && percentage < 100, "has to be above 0 and below 100");
1036         _;
1037     }
1038 
1039     modifier validateDecimals(uint8 decimals) {
1040         require(decimals > 0 && decimals < 18, "has to be above 0 and below 18");
1041         _;
1042     }
1043 
1044     modifier validateVestingPeriod(uint256 vestingPeriod) {
1045         require(vestingPeriod > 1, "has to be above 1");
1046         _;
1047     }
1048 
1049     modifier isInitialized() {
1050         require(initialized(), "manager not initialized");
1051         _;
1052     }
1053 
1054     function initialized() public view returns (bool){
1055         return (RegistryInstance.owner() == address(this)) &&
1056             (TokenFactoryInstance.owner() == address(this)) &&
1057             (TokenFactoryInstance.TokenVestingInstance().owner() == address(TokenFactoryInstance));
1058     }
1059 
1060 
1061 
1062 }