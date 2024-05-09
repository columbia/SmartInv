1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     require(value <= _balances[msg.sender]);
162     require(to != address(0));
163 
164     _balances[msg.sender] = _balances[msg.sender].sub(value);
165     _balances[to] = _balances[to].add(value);
166     emit Transfer(msg.sender, to, value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param spender The address which will spend the funds.
177    * @param value The amount of tokens to be spent.
178    */
179   function approve(address spender, uint256 value) public returns (bool) {
180     require(spender != address(0));
181 
182     _allowed[msg.sender][spender] = value;
183     emit Approval(msg.sender, spender, value);
184     return true;
185   }
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param from address The address which you want to send tokens from
190    * @param to address The address which you want to transfer to
191    * @param value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(
194     address from,
195     address to,
196     uint256 value
197   )
198     public
199     returns (bool)
200   {
201     require(value <= _balances[from]);
202     require(value <= _allowed[from][msg.sender]);
203     require(to != address(0));
204 
205     _balances[from] = _balances[from].sub(value);
206     _balances[to] = _balances[to].add(value);
207     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
208     emit Transfer(from, to, value);
209     return true;
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    * approve should be called when allowed_[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param spender The address which will spend the funds.
219    * @param addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseAllowance(
222     address spender,
223     uint256 addedValue
224   )
225     public
226     returns (bool)
227   {
228     require(spender != address(0));
229 
230     _allowed[msg.sender][spender] = (
231       _allowed[msg.sender][spender].add(addedValue));
232     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed_[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param spender The address which will spend the funds.
243    * @param subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseAllowance(
246     address spender,
247     uint256 subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     require(spender != address(0));
253 
254     _allowed[msg.sender][spender] = (
255       _allowed[msg.sender][spender].sub(subtractedValue));
256     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param amount The amount that will be created.
266    */
267   function _mint(address account, uint256 amount) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(amount);
270     _balances[account] = _balances[account].add(amount);
271     emit Transfer(address(0), account, amount);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param amount The amount that will be burnt.
279    */
280   function _burn(address account, uint256 amount) internal {
281     require(account != 0);
282     require(amount <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(amount);
285     _balances[account] = _balances[account].sub(amount);
286     emit Transfer(account, address(0), amount);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param amount The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 amount) internal {
297     require(amount <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       amount);
303     _burn(account, amount);
304   }
305 }
306 
307 // File: openzeppelin-solidity/contracts/access/Roles.sol
308 
309 /**
310  * @title Roles
311  * @dev Library for managing addresses assigned to a Role.
312  */
313 library Roles {
314   struct Role {
315     mapping (address => bool) bearer;
316   }
317 
318   /**
319    * @dev give an account access to this role
320    */
321   function add(Role storage role, address account) internal {
322     require(account != address(0));
323     role.bearer[account] = true;
324   }
325 
326   /**
327    * @dev remove an account's access to this role
328    */
329   function remove(Role storage role, address account) internal {
330     require(account != address(0));
331     role.bearer[account] = false;
332   }
333 
334   /**
335    * @dev check if an account has this role
336    * @return bool
337    */
338   function has(Role storage role, address account)
339     internal
340     view
341     returns (bool)
342   {
343     require(account != address(0));
344     return role.bearer[account];
345   }
346 }
347 
348 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
349 
350 contract MinterRole {
351   using Roles for Roles.Role;
352 
353   event MinterAdded(address indexed account);
354   event MinterRemoved(address indexed account);
355 
356   Roles.Role private minters;
357 
358   constructor() public {
359     minters.add(msg.sender);
360   }
361 
362   modifier onlyMinter() {
363     require(isMinter(msg.sender));
364     _;
365   }
366 
367   function isMinter(address account) public view returns (bool) {
368     return minters.has(account);
369   }
370 
371   function addMinter(address account) public onlyMinter {
372     minters.add(account);
373     emit MinterAdded(account);
374   }
375 
376   function renounceMinter() public {
377     minters.remove(msg.sender);
378   }
379 
380   function _removeMinter(address account) internal {
381     minters.remove(account);
382     emit MinterRemoved(account);
383   }
384 }
385 
386 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
387 
388 /**
389  * @title ERC20Mintable
390  * @dev ERC20 minting logic
391  */
392 contract ERC20Mintable is ERC20, MinterRole {
393   event MintingFinished();
394 
395   bool private _mintingFinished = false;
396 
397   modifier onlyBeforeMintingFinished() {
398     require(!_mintingFinished);
399     _;
400   }
401 
402   /**
403    * @return true if the minting is finished.
404    */
405   function mintingFinished() public view returns(bool) {
406     return _mintingFinished;
407   }
408 
409   /**
410    * @dev Function to mint tokens
411    * @param to The address that will receive the minted tokens.
412    * @param amount The amount of tokens to mint.
413    * @return A boolean that indicates if the operation was successful.
414    */
415   function mint(
416     address to,
417     uint256 amount
418   )
419     public
420     onlyMinter
421     onlyBeforeMintingFinished
422     returns (bool)
423   {
424     _mint(to, amount);
425     return true;
426   }
427 
428   /**
429    * @dev Function to stop minting new tokens.
430    * @return True if the operation was successful.
431    */
432   function finishMinting()
433     public
434     onlyMinter
435     onlyBeforeMintingFinished
436     returns (bool)
437   {
438     _mintingFinished = true;
439     emit MintingFinished();
440     return true;
441   }
442 }
443 
444 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
445 
446 /**
447  * @title Burnable Token
448  * @dev Token that can be irreversibly burned (destroyed).
449  */
450 contract ERC20Burnable is ERC20 {
451 
452   /**
453    * @dev Burns a specific amount of tokens.
454    * @param value The amount of token to be burned.
455    */
456   function burn(uint256 value) public {
457     _burn(msg.sender, value);
458   }
459 
460   /**
461    * @dev Burns a specific amount of tokens from the target address and decrements allowance
462    * @param from address The address which you want to send tokens from
463    * @param value uint256 The amount of token to be burned
464    */
465   function burnFrom(address from, uint256 value) public {
466     _burnFrom(from, value);
467   }
468 
469   /**
470    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
471    * an additional Burn event.
472    */
473   function _burn(address who, uint256 value) internal {
474     super._burn(who, value);
475   }
476 }
477 
478 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
479 
480 /**
481  * @title ERC20Detailed token
482  * @dev The decimals are only for visualization purposes.
483  * All the operations are done using the smallest and indivisible token unit,
484  * just as on Ethereum all the operations are done in wei.
485  */
486 contract ERC20Detailed is IERC20 {
487   string private _name;
488   string private _symbol;
489   uint8 private _decimals;
490 
491   constructor(string name, string symbol, uint8 decimals) public {
492     _name = name;
493     _symbol = symbol;
494     _decimals = decimals;
495   }
496 
497   /**
498    * @return the name of the token.
499    */
500   function name() public view returns(string) {
501     return _name;
502   }
503 
504   /**
505    * @return the symbol of the token.
506    */
507   function symbol() public view returns(string) {
508     return _symbol;
509   }
510 
511   /**
512    * @return the number of decimals of the token.
513    */
514   function decimals() public view returns(uint8) {
515     return _decimals;
516   }
517 }
518 
519 // File: contracts/robonomics/XRT.sol
520 
521 contract XRT is ERC20Mintable, ERC20Burnable, ERC20Detailed {
522     constructor() public ERC20Detailed("XRT", "Robonomics Beta", 9) {
523         uint256 INITIAL_SUPPLY = 1000 * (10 ** 9);
524         _mint(msg.sender, INITIAL_SUPPLY);
525     }
526 }
527 
528 // File: contracts/robonomics/RobotLiabilityAPI.sol
529 
530 //import './LiabilityFactory.sol';
531 
532 
533 contract RobotLiabilityAPI {
534     bytes   public model;
535     bytes   public objective;
536     bytes   public result;
537 
538     ERC20   public token;
539     uint256 public cost;
540     uint256 public lighthouseFee;
541     uint256 public validatorFee;
542 
543     bytes32 public demandHash;
544     bytes32 public offerHash;
545 
546     address public promisor;
547     address public promisee;
548     address public validator;
549 
550     bool    public isSuccess;
551     bool    public isFinalized;
552 
553     LiabilityFactory public factory;
554 
555     event Finalized(bool indexed success, bytes result);
556 }
557 
558 // File: contracts/robonomics/LightContract.sol
559 
560 contract LightContract {
561     /**
562      * @dev Shared code smart contract 
563      */
564     address lib;
565 
566     constructor(address _library) public {
567         lib = _library;
568     }
569 
570     function() public {
571         require(lib.delegatecall(msg.data));
572     }
573 }
574 
575 // File: contracts/robonomics/RobotLiability.sol
576 
577 // Standard robot liability light contract
578 contract RobotLiability is RobotLiabilityAPI, LightContract {
579     constructor(address _lib) public LightContract(_lib)
580     { factory = LiabilityFactory(msg.sender); }
581 }
582 
583 // File: contracts/robonomics/SingletonHash.sol
584 
585 contract SingletonHash {
586     event HashConsumed(bytes32 indexed hash);
587 
588     /**
589      * @dev Used hash accounting
590      */
591     mapping(bytes32 => bool) public isHashConsumed;
592 
593     /**
594      * @dev Parameter can be used only once
595      * @param _hash Single usage hash
596      */
597     function singletonHash(bytes32 _hash) internal {
598         require(!isHashConsumed[_hash]);
599         isHashConsumed[_hash] = true;
600         emit HashConsumed(_hash);
601     }
602 }
603 
604 // File: contracts/robonomics/DutchAuction.sol
605 
606 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
607 /// @author Stefan George - <stefan.george@consensys.net>
608 /// @author Airalab - <research@aira.life> 
609 contract DutchAuction {
610 
611     /*
612      *  Events
613      */
614     event BidSubmission(address indexed sender, uint256 amount);
615 
616     /*
617      *  Constants
618      */
619     uint constant public MAX_TOKENS_SOLD = 800 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
620     uint constant public WAITING_PERIOD = 0; // 1 days;
621 
622     /*
623      *  Storage
624      */
625     XRT     public xrt;
626     address public ambix;
627     address public wallet;
628     address public owner;
629     uint public ceiling;
630     uint public priceFactor;
631     uint public startBlock;
632     uint public endTime;
633     uint public totalReceived;
634     uint public finalPrice;
635     mapping (address => uint) public bids;
636     Stages public stage;
637 
638     /*
639      *  Enums
640      */
641     enum Stages {
642         AuctionDeployed,
643         AuctionSetUp,
644         AuctionStarted,
645         AuctionEnded,
646         TradingStarted
647     }
648 
649     /*
650      *  Modifiers
651      */
652     modifier atStage(Stages _stage) {
653         // Contract on stage
654         require(stage == _stage);
655         _;
656     }
657 
658     modifier isOwner() {
659         // Only owner is allowed to proceed
660         require(msg.sender == owner);
661         _;
662     }
663 
664     modifier isWallet() {
665         // Only wallet is allowed to proceed
666         require(msg.sender == wallet);
667         _;
668     }
669 
670     modifier isValidPayload() {
671         require(msg.data.length == 4 || msg.data.length == 36);
672         _;
673     }
674 
675     modifier timedTransitions() {
676         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
677             finalizeAuction();
678         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
679             stage = Stages.TradingStarted;
680         _;
681     }
682 
683     /*
684      *  Public functions
685      */
686     /// @dev Contract constructor function sets owner.
687     /// @param _wallet Multisig wallet.
688     /// @param _ceiling Auction ceiling.
689     /// @param _priceFactor Auction price factor.
690     constructor(address _wallet, uint _ceiling, uint _priceFactor)
691         public
692     {
693         require(_wallet != 0 && _ceiling > 0 && _priceFactor > 0);
694 
695         owner = msg.sender;
696         wallet = _wallet;
697         ceiling = _ceiling;
698         priceFactor = _priceFactor;
699         stage = Stages.AuctionDeployed;
700     }
701 
702     /// @dev Setup function sets external contracts' addresses.
703     /// @param _xrt Robonomics token address.
704     /// @param _ambix Distillation cube address.
705     function setup(address _xrt, address _ambix)
706         public
707         isOwner
708         atStage(Stages.AuctionDeployed)
709     {
710         // Validate argument
711         require(_xrt != 0 && _ambix != 0);
712 
713         xrt = XRT(_xrt);
714         ambix = _ambix;
715 
716         // Validate token balance
717         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
718 
719         stage = Stages.AuctionSetUp;
720     }
721 
722     /// @dev Starts auction and sets startBlock.
723     function startAuction()
724         public
725         isWallet
726         atStage(Stages.AuctionSetUp)
727     {
728         stage = Stages.AuctionStarted;
729         startBlock = block.number;
730     }
731 
732     /// @dev Calculates current token price.
733     /// @return Returns token price.
734     function calcCurrentTokenPrice()
735         public
736         timedTransitions
737         returns (uint)
738     {
739         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
740             return finalPrice;
741         return calcTokenPrice();
742     }
743 
744     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
745     /// @return Returns current auction stage.
746     function updateStage()
747         public
748         timedTransitions
749         returns (Stages)
750     {
751         return stage;
752     }
753 
754     /// @dev Allows to send a bid to the auction.
755     /// @param receiver Bid will be assigned to this address if set.
756     function bid(address receiver)
757         public
758         payable
759         isValidPayload
760         timedTransitions
761         atStage(Stages.AuctionStarted)
762         returns (uint amount)
763     {
764         require(msg.value > 0);
765         amount = msg.value;
766 
767         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
768         if (receiver == 0)
769             receiver = msg.sender;
770 
771         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
772         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
773         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
774         if (maxWeiBasedOnTotalReceived < maxWei)
775             maxWei = maxWeiBasedOnTotalReceived;
776 
777         // Only invest maximum possible amount.
778         if (amount > maxWei) {
779             amount = maxWei;
780             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
781             receiver.transfer(msg.value - amount);
782         }
783 
784         // Forward funding to ether wallet
785         wallet.transfer(amount);
786 
787         bids[receiver] += amount;
788         totalReceived += amount;
789         emit BidSubmission(receiver, amount);
790 
791         // Finalize auction when maxWei reached
792         if (amount == maxWei)
793             finalizeAuction();
794     }
795 
796     /// @dev Claims tokens for bidder after auction.
797     /// @param receiver Tokens will be assigned to this address if set.
798     function claimTokens(address receiver)
799         public
800         isValidPayload
801         timedTransitions
802         atStage(Stages.TradingStarted)
803     {
804         if (receiver == 0)
805             receiver = msg.sender;
806         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
807         bids[receiver] = 0;
808         require(xrt.transfer(receiver, tokenCount));
809     }
810 
811     /// @dev Calculates stop price.
812     /// @return Returns stop price.
813     function calcStopPrice()
814         view
815         public
816         returns (uint)
817     {
818         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
819     }
820 
821     /// @dev Calculates token price.
822     /// @return Returns token price.
823     function calcTokenPrice()
824         view
825         public
826         returns (uint)
827     {
828         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
829     }
830 
831     /*
832      *  Private functions
833      */
834     function finalizeAuction()
835         private
836     {
837         stage = Stages.AuctionEnded;
838         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
839         uint soldTokens = totalReceived * 10**9 / finalPrice;
840 
841         if (totalReceived == ceiling) {
842             // Auction contract transfers all unsold tokens to Ambix contract
843             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
844         } else {
845             // Auction contract burn all unsold tokens
846             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
847         }
848 
849         endTime = now;
850     }
851 }
852 
853 // File: contracts/robonomics/LighthouseAPI.sol
854 
855 //import './LiabilityFactory.sol';
856 
857 
858 contract LighthouseAPI {
859     address[] public members;
860 
861     function membersLength() public view returns (uint256)
862     { return members.length; }
863 
864     mapping(address => uint256) indexOf;
865 
866     mapping(address => uint256) public balances;
867 
868     uint256 public minimalFreeze;
869     uint256 public timeoutBlocks;
870 
871     LiabilityFactory public factory;
872     XRT              public xrt;
873 
874     uint256 public keepaliveBlock = 0;
875     uint256 public marker = 0;
876     uint256 public quota = 0;
877 
878     function quotaOf(address _member) public view returns (uint256)
879     { return balances[_member] / minimalFreeze; }
880 }
881 
882 // File: contracts/robonomics/Lighthouse.sol
883 
884 contract Lighthouse is LighthouseAPI, LightContract {
885     constructor(
886         address _lib,
887         uint256 _minimalFreeze,
888         uint256 _timeoutBlocks
889     ) 
890         public
891         LightContract(_lib)
892     {
893         require(_minimalFreeze > 0 && _timeoutBlocks > 0);
894 
895         minimalFreeze = _minimalFreeze;
896         timeoutBlocks = _timeoutBlocks;
897         factory = LiabilityFactory(msg.sender);
898         xrt = factory.xrt();
899     }
900 }
901 
902 // File: ens/contracts/AbstractENS.sol
903 
904 contract AbstractENS {
905     function owner(bytes32 node) constant returns(address);
906     function resolver(bytes32 node) constant returns(address);
907     function ttl(bytes32 node) constant returns(uint64);
908     function setOwner(bytes32 node, address owner);
909     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
910     function setResolver(bytes32 node, address resolver);
911     function setTTL(bytes32 node, uint64 ttl);
912 
913     // Logged when the owner of a node assigns a new owner to a subnode.
914     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
915 
916     // Logged when the owner of a node transfers ownership to a new account.
917     event Transfer(bytes32 indexed node, address owner);
918 
919     // Logged when the resolver for a node changes.
920     event NewResolver(bytes32 indexed node, address resolver);
921 
922     // Logged when the TTL of a node changes
923     event NewTTL(bytes32 indexed node, uint64 ttl);
924 }
925 
926 // File: ens/contracts/ENS.sol
927 
928 /**
929  * The ENS registry contract.
930  */
931 contract ENS is AbstractENS {
932     struct Record {
933         address owner;
934         address resolver;
935         uint64 ttl;
936     }
937 
938     mapping(bytes32=>Record) records;
939 
940     // Permits modifications only by the owner of the specified node.
941     modifier only_owner(bytes32 node) {
942         if(records[node].owner != msg.sender) throw;
943         _;
944     }
945 
946     /**
947      * Constructs a new ENS registrar.
948      */
949     function ENS() {
950         records[0].owner = msg.sender;
951     }
952 
953     /**
954      * Returns the address that owns the specified node.
955      */
956     function owner(bytes32 node) constant returns (address) {
957         return records[node].owner;
958     }
959 
960     /**
961      * Returns the address of the resolver for the specified node.
962      */
963     function resolver(bytes32 node) constant returns (address) {
964         return records[node].resolver;
965     }
966 
967     /**
968      * Returns the TTL of a node, and any records associated with it.
969      */
970     function ttl(bytes32 node) constant returns (uint64) {
971         return records[node].ttl;
972     }
973 
974     /**
975      * Transfers ownership of a node to a new address. May only be called by the current
976      * owner of the node.
977      * @param node The node to transfer ownership of.
978      * @param owner The address of the new owner.
979      */
980     function setOwner(bytes32 node, address owner) only_owner(node) {
981         Transfer(node, owner);
982         records[node].owner = owner;
983     }
984 
985     /**
986      * Transfers ownership of a subnode sha3(node, label) to a new address. May only be
987      * called by the owner of the parent node.
988      * @param node The parent node.
989      * @param label The hash of the label specifying the subnode.
990      * @param owner The address of the new owner.
991      */
992     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) {
993         var subnode = sha3(node, label);
994         NewOwner(node, label, owner);
995         records[subnode].owner = owner;
996     }
997 
998     /**
999      * Sets the resolver address for the specified node.
1000      * @param node The node to update.
1001      * @param resolver The address of the resolver.
1002      */
1003     function setResolver(bytes32 node, address resolver) only_owner(node) {
1004         NewResolver(node, resolver);
1005         records[node].resolver = resolver;
1006     }
1007 
1008     /**
1009      * Sets the TTL for the specified node.
1010      * @param node The node to update.
1011      * @param ttl The TTL in seconds.
1012      */
1013     function setTTL(bytes32 node, uint64 ttl) only_owner(node) {
1014         NewTTL(node, ttl);
1015         records[node].ttl = ttl;
1016     }
1017 }
1018 
1019 // File: ens/contracts/PublicResolver.sol
1020 
1021 /**
1022  * A simple resolver anyone can use; only allows the owner of a node to set its
1023  * address.
1024  */
1025 contract PublicResolver {
1026     AbstractENS ens;
1027     mapping(bytes32=>address) addresses;
1028     mapping(bytes32=>bytes32) hashes;
1029 
1030     modifier only_owner(bytes32 node) {
1031         if(ens.owner(node) != msg.sender) throw;
1032         _;
1033     }
1034 
1035     /**
1036      * Constructor.
1037      * @param ensAddr The ENS registrar contract.
1038      */
1039     function PublicResolver(AbstractENS ensAddr) {
1040         ens = ensAddr;
1041     }
1042 
1043     /**
1044      * Fallback function.
1045      */
1046     function() {
1047         throw;
1048     }
1049 
1050     /**
1051      * Returns true if the specified node has the specified record type.
1052      * @param node The ENS node to query.
1053      * @param kind The record type name, as specified in EIP137.
1054      * @return True if this resolver has a record of the provided type on the
1055      *         provided node.
1056      */
1057     function has(bytes32 node, bytes32 kind) constant returns (bool) {
1058         return (kind == "addr" && addresses[node] != 0) || (kind == "hash" && hashes[node] != 0);
1059     }
1060 
1061     /**
1062      * Returns true if the resolver implements the interface specified by the provided hash.
1063      * @param interfaceID The ID of the interface to check for.
1064      * @return True if the contract implements the requested interface.
1065      */
1066     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
1067         return interfaceID == 0x3b3b57de || interfaceID == 0xd8389dc5;
1068     }
1069 
1070     /**
1071      * Returns the address associated with an ENS node.
1072      * @param node The ENS node to query.
1073      * @return The associated address.
1074      */
1075     function addr(bytes32 node) constant returns (address ret) {
1076         ret = addresses[node];
1077     }
1078 
1079     /**
1080      * Sets the address associated with an ENS node.
1081      * May only be called by the owner of that node in the ENS registry.
1082      * @param node The node to update.
1083      * @param addr The address to set.
1084      */
1085     function setAddr(bytes32 node, address addr) only_owner(node) {
1086         addresses[node] = addr;
1087     }
1088 
1089     /**
1090      * Returns the content hash associated with an ENS node.
1091      * Note that this resource type is not standardized, and will likely change
1092      * in future to a resource type based on multihash.
1093      * @param node The ENS node to query.
1094      * @return The associated content hash.
1095      */
1096     function content(bytes32 node) constant returns (bytes32 ret) {
1097         ret = hashes[node];
1098     }
1099 
1100     /**
1101      * Sets the content hash associated with an ENS node.
1102      * May only be called by the owner of that node in the ENS registry.
1103      * Note that this resource type is not standardized, and will likely change
1104      * in future to a resource type based on multihash.
1105      * @param node The node to update.
1106      * @param hash The content hash to set
1107      */
1108     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
1109         hashes[node] = hash;
1110     }
1111 }
1112 
1113 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1114 
1115 /**
1116  * @title SafeERC20
1117  * @dev Wrappers around ERC20 operations that throw on failure.
1118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1120  */
1121 library SafeERC20 {
1122   function safeTransfer(
1123     IERC20 token,
1124     address to,
1125     uint256 value
1126   )
1127     internal
1128   {
1129     require(token.transfer(to, value));
1130   }
1131 
1132   function safeTransferFrom(
1133     IERC20 token,
1134     address from,
1135     address to,
1136     uint256 value
1137   )
1138     internal
1139   {
1140     require(token.transferFrom(from, to, value));
1141   }
1142 
1143   function safeApprove(
1144     IERC20 token,
1145     address spender,
1146     uint256 value
1147   )
1148     internal
1149   {
1150     require(token.approve(spender, value));
1151   }
1152 }
1153 
1154 // File: contracts/robonomics/LiabilityFactory.sol
1155 
1156 contract LiabilityFactory is SingletonHash {
1157     constructor(
1158         address _robot_liability_lib,
1159         address _lighthouse_lib,
1160         DutchAuction _auction,
1161         XRT _xrt,
1162         ENS _ens
1163     ) public {
1164         robotLiabilityLib = _robot_liability_lib;
1165         lighthouseLib = _lighthouse_lib;
1166         auction = _auction;
1167         xrt = _xrt;
1168         ens = _ens;
1169     }
1170 
1171     using SafeERC20 for XRT;
1172     using SafeERC20 for ERC20;
1173 
1174     /**
1175      * @dev New liability created 
1176      */
1177     event NewLiability(address indexed liability);
1178 
1179     /**
1180      * @dev New lighthouse created
1181      */
1182     event NewLighthouse(address indexed lighthouse, string name);
1183 
1184     /**
1185      * @dev Robonomics dutch auction contract
1186      */
1187     DutchAuction public auction;
1188 
1189     /**
1190      * @dev Robonomics network protocol token
1191      */
1192     XRT public xrt;
1193 
1194     /**
1195      * @dev Ethereum name system
1196      */
1197     ENS public ens;
1198 
1199     /**
1200      * @dev Total GAS utilized by Robonomics network
1201      */
1202     uint256 public totalGasUtilizing = 0;
1203 
1204     /**
1205      * @dev GAS utilized by liability contracts
1206      */
1207     mapping(address => uint256) public gasUtilizing;
1208 
1209     /**
1210      * @dev The count of utilized gas for switch to next epoch 
1211      */
1212     uint256 public constant gasEpoch = 347 * 10**10;
1213 
1214     /**
1215      * @dev Weighted average gasprice
1216      */
1217     uint256 public constant gasPrice = 10 * 10**9;
1218 
1219     /**
1220      * @dev Lighthouse accounting
1221      */
1222     mapping(address => bool) public isLighthouse;
1223 
1224     /**
1225      * @dev Robot liability shared code smart contract
1226      */
1227     address public robotLiabilityLib;
1228 
1229     /**
1230      * @dev Lightouse shared code smart contract
1231      */
1232     address public lighthouseLib;
1233 
1234     /**
1235      * @dev XRT emission value for utilized gas
1236      */
1237     function wnFromGas(uint256 _gas) public view returns (uint256) {
1238         // Just return wn=gas when auction isn't finish
1239         if (auction.finalPrice() == 0)
1240             return _gas;
1241 
1242         // Current gas utilization epoch
1243         uint256 epoch = totalGasUtilizing / gasEpoch;
1244 
1245         // XRT emission with addition coefficient by gas utilzation epoch
1246         uint256 wn = _gas * 10**9 * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1247 
1248         // Check to not permit emission decrease below wn=gas
1249         return wn < _gas ? _gas : wn;
1250     }
1251 
1252     /**
1253      * @dev Only lighthouse guard
1254      */
1255     modifier onlyLighthouse {
1256         require(isLighthouse[msg.sender]);
1257         _;
1258     }
1259 
1260     /**
1261      * @dev Create robot liability smart contract
1262      * @param _demand ABI-encoded demand message 
1263      * @param _offer ABI-encoded offer message 
1264      */
1265     function createLiability(
1266         bytes _demand,
1267         bytes _offer
1268     )
1269         external 
1270         onlyLighthouse
1271         returns (RobotLiability liability)
1272     {
1273         // Store in memory available gas
1274         uint256 gasinit = gasleft();
1275 
1276         // Create liability
1277         liability = new RobotLiability(robotLiabilityLib);
1278         emit NewLiability(liability);
1279 
1280         // Parse messages
1281         require(liability.call(abi.encodePacked(bytes4(0x0be8947a), _demand))); // liability.demand(...)
1282         singletonHash(liability.demandHash());
1283 
1284         require(liability.call(abi.encodePacked(bytes4(0x87bca1cf), _offer))); // liability.offer(...)
1285         singletonHash(liability.offerHash());
1286 
1287         // Transfer lighthouse fee to lighthouse worker directly
1288         if (liability.lighthouseFee() > 0)
1289             xrt.safeTransferFrom(liability.promisor(),
1290                                  tx.origin,
1291                                  liability.lighthouseFee());
1292 
1293         // Transfer liability security and hold on contract
1294         ERC20 token = liability.token();
1295         if (liability.cost() > 0)
1296             token.safeTransferFrom(liability.promisee(),
1297                                    liability,
1298                                    liability.cost());
1299 
1300         // Transfer validator fee and hold on contract
1301         if (address(liability.validator()) != 0 && liability.validatorFee() > 0)
1302             xrt.safeTransferFrom(liability.promisee(),
1303                                  liability,
1304                                  liability.validatorFee());
1305 
1306         // Accounting gas usage of transaction
1307         uint256 gas = gasinit - gasleft() + 110525; // Including observation error
1308         totalGasUtilizing       += gas;
1309         gasUtilizing[liability] += gas;
1310      }
1311 
1312     /**
1313      * @dev Create lighthouse smart contract
1314      * @param _minimalFreeze Minimal freeze value of XRT token
1315      * @param _timeoutBlocks Max time of lighthouse silence in blocks
1316      * @param _name Lighthouse subdomain,
1317      *              example: for 'my-name' will created 'my-name.lighthouse.1.robonomics.eth' domain
1318      */
1319     function createLighthouse(
1320         uint256 _minimalFreeze,
1321         uint256 _timeoutBlocks,
1322         string  _name
1323     )
1324         external
1325         returns (address lighthouse)
1326     {
1327         bytes32 lighthouseNode
1328             // lighthouse.2.robonomics.eth
1329             = 0xa058d6058d5ec525aa555c572720908a8d6ea6e2781b460bdecb2abf8bf56d4c;
1330 
1331         // Name reservation check
1332         bytes32 subnode = keccak256(abi.encodePacked(lighthouseNode, keccak256(_name)));
1333         require(ens.resolver(subnode) == 0);
1334 
1335         // Create lighthouse
1336         lighthouse = new Lighthouse(lighthouseLib, _minimalFreeze, _timeoutBlocks);
1337         emit NewLighthouse(lighthouse, _name);
1338         isLighthouse[lighthouse] = true;
1339 
1340         // Register subnode
1341         ens.setSubnodeOwner(lighthouseNode, keccak256(_name), this);
1342 
1343         // Register lighthouse address
1344         PublicResolver resolver = PublicResolver(ens.resolver(lighthouseNode));
1345         ens.setResolver(subnode, resolver);
1346         resolver.setAddr(subnode, lighthouse);
1347     }
1348 
1349     /**
1350      * @dev Is called whan after liability finalization
1351      * @param _gas Liability finalization gas expenses
1352      */
1353     function liabilityFinalized(
1354         uint256 _gas
1355     )
1356         external
1357         returns (bool)
1358     {
1359         require(gasUtilizing[msg.sender] > 0);
1360 
1361         uint256 gas = _gas - gasleft();
1362         require(_gas > gas);
1363 
1364         totalGasUtilizing        += gas;
1365         gasUtilizing[msg.sender] += gas;
1366         require(xrt.mint(tx.origin, wnFromGas(gasUtilizing[msg.sender])));
1367         return true;
1368     }
1369 }