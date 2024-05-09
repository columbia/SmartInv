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
131   * @param owner The address to query the balance of.
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
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _allowed[from][msg.sender]);
197 
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     _transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(value <= _balances[from]);
259     require(to != address(0));
260 
261     _balances[from] = _balances[from].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(value);
276     _balances[account] = _balances[account].add(value);
277     emit Transfer(address(0), account, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param value The amount that will be burnt.
285    */
286   function _burn(address account, uint256 value) internal {
287     require(account != 0);
288     require(value <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(value);
291     _balances[account] = _balances[account].sub(value);
292     emit Transfer(account, address(0), value);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param value The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 value) internal {
303     require(value <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 // File: openzeppelin-solidity/contracts/access/Roles.sol
314 
315 /**
316  * @title Roles
317  * @dev Library for managing addresses assigned to a Role.
318  */
319 library Roles {
320   struct Role {
321     mapping (address => bool) bearer;
322   }
323 
324   /**
325    * @dev give an account access to this role
326    */
327   function add(Role storage role, address account) internal {
328     require(account != address(0));
329     require(!has(role, account));
330 
331     role.bearer[account] = true;
332   }
333 
334   /**
335    * @dev remove an account's access to this role
336    */
337   function remove(Role storage role, address account) internal {
338     require(account != address(0));
339     require(has(role, account));
340 
341     role.bearer[account] = false;
342   }
343 
344   /**
345    * @dev check if an account has this role
346    * @return bool
347    */
348   function has(Role storage role, address account)
349     internal
350     view
351     returns (bool)
352   {
353     require(account != address(0));
354     return role.bearer[account];
355   }
356 }
357 
358 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
359 
360 contract MinterRole {
361   using Roles for Roles.Role;
362 
363   event MinterAdded(address indexed account);
364   event MinterRemoved(address indexed account);
365 
366   Roles.Role private minters;
367 
368   constructor() internal {
369     _addMinter(msg.sender);
370   }
371 
372   modifier onlyMinter() {
373     require(isMinter(msg.sender));
374     _;
375   }
376 
377   function isMinter(address account) public view returns (bool) {
378     return minters.has(account);
379   }
380 
381   function addMinter(address account) public onlyMinter {
382     _addMinter(account);
383   }
384 
385   function renounceMinter() public {
386     _removeMinter(msg.sender);
387   }
388 
389   function _addMinter(address account) internal {
390     minters.add(account);
391     emit MinterAdded(account);
392   }
393 
394   function _removeMinter(address account) internal {
395     minters.remove(account);
396     emit MinterRemoved(account);
397   }
398 }
399 
400 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
401 
402 /**
403  * @title ERC20Mintable
404  * @dev ERC20 minting logic
405  */
406 contract ERC20Mintable is ERC20, MinterRole {
407   /**
408    * @dev Function to mint tokens
409    * @param to The address that will receive the minted tokens.
410    * @param value The amount of tokens to mint.
411    * @return A boolean that indicates if the operation was successful.
412    */
413   function mint(
414     address to,
415     uint256 value
416   )
417     public
418     onlyMinter
419     returns (bool)
420   {
421     _mint(to, value);
422     return true;
423   }
424 }
425 
426 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
427 
428 /**
429  * @title Burnable Token
430  * @dev Token that can be irreversibly burned (destroyed).
431  */
432 contract ERC20Burnable is ERC20 {
433 
434   /**
435    * @dev Burns a specific amount of tokens.
436    * @param value The amount of token to be burned.
437    */
438   function burn(uint256 value) public {
439     _burn(msg.sender, value);
440   }
441 
442   /**
443    * @dev Burns a specific amount of tokens from the target address and decrements allowance
444    * @param from address The address which you want to send tokens from
445    * @param value uint256 The amount of token to be burned
446    */
447   function burnFrom(address from, uint256 value) public {
448     _burnFrom(from, value);
449   }
450 }
451 
452 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
453 
454 /**
455  * @title ERC20Detailed token
456  * @dev The decimals are only for visualization purposes.
457  * All the operations are done using the smallest and indivisible token unit,
458  * just as on Ethereum all the operations are done in wei.
459  */
460 contract ERC20Detailed is IERC20 {
461   string private _name;
462   string private _symbol;
463   uint8 private _decimals;
464 
465   constructor(string name, string symbol, uint8 decimals) public {
466     _name = name;
467     _symbol = symbol;
468     _decimals = decimals;
469   }
470 
471   /**
472    * @return the name of the token.
473    */
474   function name() public view returns(string) {
475     return _name;
476   }
477 
478   /**
479    * @return the symbol of the token.
480    */
481   function symbol() public view returns(string) {
482     return _symbol;
483   }
484 
485   /**
486    * @return the number of decimals of the token.
487    */
488   function decimals() public view returns(uint8) {
489     return _decimals;
490   }
491 }
492 
493 // File: contracts/robonomics/XRT.sol
494 
495 contract XRT is ERC20Mintable, ERC20Burnable, ERC20Detailed {
496     constructor() public ERC20Detailed("Robonomics Beta 3", "XRT", 9) {
497         uint256 INITIAL_SUPPLY = 1000 * (10 ** 9);
498         _mint(msg.sender, INITIAL_SUPPLY);
499     }
500 }
501 
502 // File: contracts/robonomics/RobotLiabilityAPI.sol
503 
504 //import './LiabilityFactory.sol';
505 
506 
507 contract RobotLiabilityAPI {
508     bytes   public model;
509     bytes   public objective;
510     bytes   public result;
511 
512     ERC20   public token;
513     uint256 public cost;
514     uint256 public lighthouseFee;
515     uint256 public validatorFee;
516 
517     bytes32 public demandHash;
518     bytes32 public offerHash;
519 
520     address public promisor;
521     address public promisee;
522     address public lighthouse;
523     address public validator;
524 
525     bool    public isSuccess;
526     bool    public isFinalized;
527 
528     LiabilityFactory public factory;
529 
530     event Finalized(bool indexed success, bytes result);
531 }
532 
533 // File: contracts/robonomics/LightContract.sol
534 
535 contract LightContract {
536     /**
537      * @dev Shared code smart contract 
538      */
539     address lib;
540 
541     constructor(address _library) public {
542         lib = _library;
543     }
544 
545     function() public {
546         require(lib.delegatecall(msg.data));
547     }
548 }
549 
550 // File: contracts/robonomics/RobotLiability.sol
551 
552 // Standard robot liability light contract
553 contract RobotLiability is RobotLiabilityAPI, LightContract {
554     constructor(address _lib) public LightContract(_lib)
555     { factory = LiabilityFactory(msg.sender); }
556 }
557 
558 // File: contracts/robonomics/SingletonHash.sol
559 
560 contract SingletonHash {
561     event HashConsumed(bytes32 indexed hash);
562 
563     /**
564      * @dev Used hash accounting
565      */
566     mapping(bytes32 => bool) public isHashConsumed;
567 
568     /**
569      * @dev Parameter can be used only once
570      * @param _hash Single usage hash
571      */
572     function singletonHash(bytes32 _hash) internal {
573         require(!isHashConsumed[_hash]);
574         isHashConsumed[_hash] = true;
575         emit HashConsumed(_hash);
576     }
577 }
578 
579 // File: contracts/robonomics/DutchAuction.sol
580 
581 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
582 /// @author Stefan George - <stefan.george@consensys.net>
583 /// @author Airalab - <research@aira.life> 
584 contract DutchAuction {
585 
586     /*
587      *  Events
588      */
589     event BidSubmission(address indexed sender, uint256 amount);
590 
591     /*
592      *  Constants
593      */
594     uint constant public MAX_TOKENS_SOLD = 800 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
595     uint constant public WAITING_PERIOD = 0; // 1 days;
596 
597     /*
598      *  Storage
599      */
600     XRT     public xrt;
601     address public ambix;
602     address public wallet;
603     address public owner;
604     uint public ceiling;
605     uint public priceFactor;
606     uint public startBlock;
607     uint public endTime;
608     uint public totalReceived;
609     uint public finalPrice;
610     mapping (address => uint) public bids;
611     Stages public stage;
612 
613     /*
614      *  Enums
615      */
616     enum Stages {
617         AuctionDeployed,
618         AuctionSetUp,
619         AuctionStarted,
620         AuctionEnded,
621         TradingStarted
622     }
623 
624     /*
625      *  Modifiers
626      */
627     modifier atStage(Stages _stage) {
628         // Contract on stage
629         require(stage == _stage);
630         _;
631     }
632 
633     modifier isOwner() {
634         // Only owner is allowed to proceed
635         require(msg.sender == owner);
636         _;
637     }
638 
639     modifier isWallet() {
640         // Only wallet is allowed to proceed
641         require(msg.sender == wallet);
642         _;
643     }
644 
645     modifier isValidPayload() {
646         require(msg.data.length == 4 || msg.data.length == 36);
647         _;
648     }
649 
650     modifier timedTransitions() {
651         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
652             finalizeAuction();
653         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
654             stage = Stages.TradingStarted;
655         _;
656     }
657 
658     /*
659      *  Public functions
660      */
661     /// @dev Contract constructor function sets owner.
662     /// @param _wallet Multisig wallet.
663     /// @param _ceiling Auction ceiling.
664     /// @param _priceFactor Auction price factor.
665     constructor(address _wallet, uint _ceiling, uint _priceFactor)
666         public
667     {
668         require(_wallet != 0 && _ceiling > 0 && _priceFactor > 0);
669 
670         owner = msg.sender;
671         wallet = _wallet;
672         ceiling = _ceiling;
673         priceFactor = _priceFactor;
674         stage = Stages.AuctionDeployed;
675     }
676 
677     /// @dev Setup function sets external contracts' addresses.
678     /// @param _xrt Robonomics token address.
679     /// @param _ambix Distillation cube address.
680     function setup(address _xrt, address _ambix)
681         public
682         isOwner
683         atStage(Stages.AuctionDeployed)
684     {
685         // Validate argument
686         require(_xrt != 0 && _ambix != 0);
687 
688         xrt = XRT(_xrt);
689         ambix = _ambix;
690 
691         // Validate token balance
692         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
693 
694         stage = Stages.AuctionSetUp;
695     }
696 
697     /// @dev Starts auction and sets startBlock.
698     function startAuction()
699         public
700         isWallet
701         atStage(Stages.AuctionSetUp)
702     {
703         stage = Stages.AuctionStarted;
704         startBlock = block.number;
705     }
706 
707     /// @dev Calculates current token price.
708     /// @return Returns token price.
709     function calcCurrentTokenPrice()
710         public
711         timedTransitions
712         returns (uint)
713     {
714         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
715             return finalPrice;
716         return calcTokenPrice();
717     }
718 
719     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
720     /// @return Returns current auction stage.
721     function updateStage()
722         public
723         timedTransitions
724         returns (Stages)
725     {
726         return stage;
727     }
728 
729     /// @dev Allows to send a bid to the auction.
730     /// @param receiver Bid will be assigned to this address if set.
731     function bid(address receiver)
732         public
733         payable
734         isValidPayload
735         timedTransitions
736         atStage(Stages.AuctionStarted)
737         returns (uint amount)
738     {
739         require(msg.value > 0);
740         amount = msg.value;
741 
742         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
743         if (receiver == 0)
744             receiver = msg.sender;
745 
746         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
747         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
748         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
749         if (maxWeiBasedOnTotalReceived < maxWei)
750             maxWei = maxWeiBasedOnTotalReceived;
751 
752         // Only invest maximum possible amount.
753         if (amount > maxWei) {
754             amount = maxWei;
755             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
756             receiver.transfer(msg.value - amount);
757         }
758 
759         // Forward funding to ether wallet
760         wallet.transfer(amount);
761 
762         bids[receiver] += amount;
763         totalReceived += amount;
764         emit BidSubmission(receiver, amount);
765 
766         // Finalize auction when maxWei reached
767         if (amount == maxWei)
768             finalizeAuction();
769     }
770 
771     /// @dev Claims tokens for bidder after auction.
772     /// @param receiver Tokens will be assigned to this address if set.
773     function claimTokens(address receiver)
774         public
775         isValidPayload
776         timedTransitions
777         atStage(Stages.TradingStarted)
778     {
779         if (receiver == 0)
780             receiver = msg.sender;
781         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
782         bids[receiver] = 0;
783         require(xrt.transfer(receiver, tokenCount));
784     }
785 
786     /// @dev Calculates stop price.
787     /// @return Returns stop price.
788     function calcStopPrice()
789         view
790         public
791         returns (uint)
792     {
793         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
794     }
795 
796     /// @dev Calculates token price.
797     /// @return Returns token price.
798     function calcTokenPrice()
799         view
800         public
801         returns (uint)
802     {
803         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
804     }
805 
806     /*
807      *  Private functions
808      */
809     function finalizeAuction()
810         private
811     {
812         stage = Stages.AuctionEnded;
813         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
814         uint soldTokens = totalReceived * 10**9 / finalPrice;
815 
816         if (totalReceived == ceiling) {
817             // Auction contract transfers all unsold tokens to Ambix contract
818             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
819         } else {
820             // Auction contract burn all unsold tokens
821             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
822         }
823 
824         endTime = now;
825     }
826 }
827 
828 // File: contracts/robonomics/LighthouseAPI.sol
829 
830 //import './LiabilityFactory.sol';
831 
832 
833 contract LighthouseAPI {
834     address[] public members;
835 
836     function membersLength() public view returns (uint256)
837     { return members.length; }
838 
839     mapping(address => uint256) indexOf;
840 
841     mapping(address => uint256) public balances;
842 
843     uint256 public minimalFreeze;
844     uint256 public timeoutBlocks;
845 
846     LiabilityFactory public factory;
847     XRT              public xrt;
848 
849     uint256 public keepaliveBlock = 0;
850     uint256 public marker = 0;
851     uint256 public quota = 0;
852 
853     function quotaOf(address _member) public view returns (uint256)
854     { return balances[_member] / minimalFreeze; }
855 }
856 
857 // File: contracts/robonomics/Lighthouse.sol
858 
859 contract Lighthouse is LighthouseAPI, LightContract {
860     constructor(
861         address _lib,
862         uint256 _minimalFreeze,
863         uint256 _timeoutBlocks
864     ) 
865         public
866         LightContract(_lib)
867     {
868         require(_minimalFreeze > 0 && _timeoutBlocks > 0);
869 
870         minimalFreeze = _minimalFreeze;
871         timeoutBlocks = _timeoutBlocks;
872         factory = LiabilityFactory(msg.sender);
873         xrt = factory.xrt();
874     }
875 }
876 
877 // File: ens/contracts/AbstractENS.sol
878 
879 contract AbstractENS {
880     function owner(bytes32 node) constant returns(address);
881     function resolver(bytes32 node) constant returns(address);
882     function ttl(bytes32 node) constant returns(uint64);
883     function setOwner(bytes32 node, address owner);
884     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
885     function setResolver(bytes32 node, address resolver);
886     function setTTL(bytes32 node, uint64 ttl);
887 
888     // Logged when the owner of a node assigns a new owner to a subnode.
889     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
890 
891     // Logged when the owner of a node transfers ownership to a new account.
892     event Transfer(bytes32 indexed node, address owner);
893 
894     // Logged when the resolver for a node changes.
895     event NewResolver(bytes32 indexed node, address resolver);
896 
897     // Logged when the TTL of a node changes
898     event NewTTL(bytes32 indexed node, uint64 ttl);
899 }
900 
901 // File: ens/contracts/ENS.sol
902 
903 /**
904  * The ENS registry contract.
905  */
906 contract ENS is AbstractENS {
907     struct Record {
908         address owner;
909         address resolver;
910         uint64 ttl;
911     }
912 
913     mapping(bytes32=>Record) records;
914 
915     // Permits modifications only by the owner of the specified node.
916     modifier only_owner(bytes32 node) {
917         if(records[node].owner != msg.sender) throw;
918         _;
919     }
920 
921     /**
922      * Constructs a new ENS registrar.
923      */
924     function ENS() {
925         records[0].owner = msg.sender;
926     }
927 
928     /**
929      * Returns the address that owns the specified node.
930      */
931     function owner(bytes32 node) constant returns (address) {
932         return records[node].owner;
933     }
934 
935     /**
936      * Returns the address of the resolver for the specified node.
937      */
938     function resolver(bytes32 node) constant returns (address) {
939         return records[node].resolver;
940     }
941 
942     /**
943      * Returns the TTL of a node, and any records associated with it.
944      */
945     function ttl(bytes32 node) constant returns (uint64) {
946         return records[node].ttl;
947     }
948 
949     /**
950      * Transfers ownership of a node to a new address. May only be called by the current
951      * owner of the node.
952      * @param node The node to transfer ownership of.
953      * @param owner The address of the new owner.
954      */
955     function setOwner(bytes32 node, address owner) only_owner(node) {
956         Transfer(node, owner);
957         records[node].owner = owner;
958     }
959 
960     /**
961      * Transfers ownership of a subnode sha3(node, label) to a new address. May only be
962      * called by the owner of the parent node.
963      * @param node The parent node.
964      * @param label The hash of the label specifying the subnode.
965      * @param owner The address of the new owner.
966      */
967     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) {
968         var subnode = sha3(node, label);
969         NewOwner(node, label, owner);
970         records[subnode].owner = owner;
971     }
972 
973     /**
974      * Sets the resolver address for the specified node.
975      * @param node The node to update.
976      * @param resolver The address of the resolver.
977      */
978     function setResolver(bytes32 node, address resolver) only_owner(node) {
979         NewResolver(node, resolver);
980         records[node].resolver = resolver;
981     }
982 
983     /**
984      * Sets the TTL for the specified node.
985      * @param node The node to update.
986      * @param ttl The TTL in seconds.
987      */
988     function setTTL(bytes32 node, uint64 ttl) only_owner(node) {
989         NewTTL(node, ttl);
990         records[node].ttl = ttl;
991     }
992 }
993 
994 // File: ens/contracts/PublicResolver.sol
995 
996 /**
997  * A simple resolver anyone can use; only allows the owner of a node to set its
998  * address.
999  */
1000 contract PublicResolver {
1001     AbstractENS ens;
1002     mapping(bytes32=>address) addresses;
1003     mapping(bytes32=>bytes32) hashes;
1004 
1005     modifier only_owner(bytes32 node) {
1006         if(ens.owner(node) != msg.sender) throw;
1007         _;
1008     }
1009 
1010     /**
1011      * Constructor.
1012      * @param ensAddr The ENS registrar contract.
1013      */
1014     function PublicResolver(AbstractENS ensAddr) {
1015         ens = ensAddr;
1016     }
1017 
1018     /**
1019      * Fallback function.
1020      */
1021     function() {
1022         throw;
1023     }
1024 
1025     /**
1026      * Returns true if the specified node has the specified record type.
1027      * @param node The ENS node to query.
1028      * @param kind The record type name, as specified in EIP137.
1029      * @return True if this resolver has a record of the provided type on the
1030      *         provided node.
1031      */
1032     function has(bytes32 node, bytes32 kind) constant returns (bool) {
1033         return (kind == "addr" && addresses[node] != 0) || (kind == "hash" && hashes[node] != 0);
1034     }
1035 
1036     /**
1037      * Returns true if the resolver implements the interface specified by the provided hash.
1038      * @param interfaceID The ID of the interface to check for.
1039      * @return True if the contract implements the requested interface.
1040      */
1041     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
1042         return interfaceID == 0x3b3b57de || interfaceID == 0xd8389dc5;
1043     }
1044 
1045     /**
1046      * Returns the address associated with an ENS node.
1047      * @param node The ENS node to query.
1048      * @return The associated address.
1049      */
1050     function addr(bytes32 node) constant returns (address ret) {
1051         ret = addresses[node];
1052     }
1053 
1054     /**
1055      * Sets the address associated with an ENS node.
1056      * May only be called by the owner of that node in the ENS registry.
1057      * @param node The node to update.
1058      * @param addr The address to set.
1059      */
1060     function setAddr(bytes32 node, address addr) only_owner(node) {
1061         addresses[node] = addr;
1062     }
1063 
1064     /**
1065      * Returns the content hash associated with an ENS node.
1066      * Note that this resource type is not standardized, and will likely change
1067      * in future to a resource type based on multihash.
1068      * @param node The ENS node to query.
1069      * @return The associated content hash.
1070      */
1071     function content(bytes32 node) constant returns (bytes32 ret) {
1072         ret = hashes[node];
1073     }
1074 
1075     /**
1076      * Sets the content hash associated with an ENS node.
1077      * May only be called by the owner of that node in the ENS registry.
1078      * Note that this resource type is not standardized, and will likely change
1079      * in future to a resource type based on multihash.
1080      * @param node The node to update.
1081      * @param hash The content hash to set
1082      */
1083     function setContent(bytes32 node, bytes32 hash) only_owner(node) {
1084         hashes[node] = hash;
1085     }
1086 }
1087 
1088 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1089 
1090 /**
1091  * @title SafeERC20
1092  * @dev Wrappers around ERC20 operations that throw on failure.
1093  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1094  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1095  */
1096 library SafeERC20 {
1097 
1098   using SafeMath for uint256;
1099 
1100   function safeTransfer(
1101     IERC20 token,
1102     address to,
1103     uint256 value
1104   )
1105     internal
1106   {
1107     require(token.transfer(to, value));
1108   }
1109 
1110   function safeTransferFrom(
1111     IERC20 token,
1112     address from,
1113     address to,
1114     uint256 value
1115   )
1116     internal
1117   {
1118     require(token.transferFrom(from, to, value));
1119   }
1120 
1121   function safeApprove(
1122     IERC20 token,
1123     address spender,
1124     uint256 value
1125   )
1126     internal
1127   {
1128     // safeApprove should only be called when setting an initial allowance, 
1129     // or when resetting it to zero. To increase and decrease it, use 
1130     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1131     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
1132     require(token.approve(spender, value));
1133   }
1134 
1135   function safeIncreaseAllowance(
1136     IERC20 token,
1137     address spender,
1138     uint256 value
1139   )
1140     internal
1141   {
1142     uint256 newAllowance = token.allowance(address(this), spender).add(value);
1143     require(token.approve(spender, newAllowance));
1144   }
1145 
1146   function safeDecreaseAllowance(
1147     IERC20 token,
1148     address spender,
1149     uint256 value
1150   )
1151     internal
1152   {
1153     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1154     require(token.approve(spender, newAllowance));
1155   }
1156 }
1157 
1158 // File: contracts/robonomics/LiabilityFactory.sol
1159 
1160 contract LiabilityFactory is SingletonHash {
1161     constructor(
1162         address _robot_liability_lib,
1163         address _lighthouse_lib,
1164         DutchAuction _auction,
1165         XRT _xrt,
1166         ENS _ens
1167     ) public {
1168         robotLiabilityLib = _robot_liability_lib;
1169         lighthouseLib = _lighthouse_lib;
1170         auction = _auction;
1171         xrt = _xrt;
1172         ens = _ens;
1173     }
1174 
1175     using SafeERC20 for XRT;
1176     using SafeERC20 for ERC20;
1177 
1178     /**
1179      * @dev New liability created 
1180      */
1181     event NewLiability(address indexed liability);
1182 
1183     /**
1184      * @dev New lighthouse created
1185      */
1186     event NewLighthouse(address indexed lighthouse, string name);
1187 
1188     /**
1189      * @dev Robonomics dutch auction contract
1190      */
1191     DutchAuction public auction;
1192 
1193     /**
1194      * @dev Robonomics network protocol token
1195      */
1196     XRT public xrt;
1197 
1198     /**
1199      * @dev Ethereum name system
1200      */
1201     ENS public ens;
1202 
1203     /**
1204      * @dev Total GAS utilized by Robonomics network
1205      */
1206     uint256 public totalGasUtilizing = 0;
1207 
1208     /**
1209      * @dev GAS utilized by liability contracts
1210      */
1211     mapping(address => uint256) public gasUtilizing;
1212 
1213     /**
1214      * @dev The count of utilized gas for switch to next epoch 
1215      */
1216     uint256 public constant gasEpoch = 347 * 10**10;
1217 
1218     /**
1219      * @dev SMMA filter with function: SMMA(i) = (SMMA(i-1)*(n-1) + PRICE(i)) / n
1220      * @param _prePrice PRICE[n-1]
1221      * @param _price PRICE[n]
1222      * @return filtered price
1223      */
1224     function smma(uint256 _prePrice, uint256 _price) internal returns (uint256) {
1225         return (_prePrice * (smmaPeriod - 1) + _price) / smmaPeriod;
1226     }
1227 
1228     /**
1229      * @dev SMMA filter period
1230      */
1231     uint256 public constant smmaPeriod = 100;
1232 
1233     /**
1234      * @dev Current gas price in wei
1235      */
1236     uint256 public gasPrice = 10 * 10**9;
1237 
1238     /**
1239      * @dev Lighthouse accounting
1240      */
1241     mapping(address => bool) public isLighthouse;
1242 
1243     /**
1244      * @dev Robot liability shared code smart contract
1245      */
1246     address public robotLiabilityLib;
1247 
1248     /**
1249      * @dev Lightouse shared code smart contract
1250      */
1251     address public lighthouseLib;
1252 
1253     /**
1254      * @dev XRT emission value for utilized gas
1255      */
1256     function wnFromGas(uint256 _gas) view returns (uint256) {
1257         // Just return wn=gas when auction isn't finish
1258         if (auction.finalPrice() == 0)
1259             return _gas;
1260 
1261         // Current gas utilization epoch
1262         uint256 epoch = totalGasUtilizing / gasEpoch;
1263 
1264         // XRT emission with addition coefficient by gas utilzation epoch
1265         uint256 wn = _gas * 10**9 * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1266 
1267         // Check to not permit emission decrease below wn=gas
1268         return wn < _gas ? _gas : wn;
1269     }
1270 
1271     /**
1272      * @dev Only lighthouse guard
1273      */
1274     modifier onlyLighthouse {
1275         require(isLighthouse[msg.sender]);
1276         _;
1277     }
1278 
1279     modifier gasPriceEstimated {
1280         gasPrice = smma(gasPrice, tx.gasprice);
1281         _;
1282     }
1283 
1284 
1285     /**
1286      * @dev Create robot liability smart contract
1287      * @param _demand ABI-encoded demand message 
1288      * @param _offer ABI-encoded offer message 
1289      */
1290     function createLiability(
1291         bytes _demand,
1292         bytes _offer
1293     )
1294         external 
1295         onlyLighthouse
1296         gasPriceEstimated
1297         returns (RobotLiability liability) { // Store in memory available gas
1298         uint256 gasinit = gasleft();
1299 
1300         // Create liability
1301         liability = new RobotLiability(robotLiabilityLib);
1302         emit NewLiability(liability);
1303 
1304         // Parse messages
1305         require(liability.call(abi.encodePacked(bytes4(0xd9ff764a), _demand))); // liability.demand(...)
1306         singletonHash(liability.demandHash());
1307 
1308         require(liability.call(abi.encodePacked(bytes4(0xd5056962), _offer))); // liability.offer(...)
1309         singletonHash(liability.offerHash());
1310 
1311         // Transfer lighthouse fee to lighthouse worker directly
1312         if (liability.lighthouseFee() > 0)
1313             xrt.safeTransferFrom(liability.promisor(),
1314                                  tx.origin,
1315                                  liability.lighthouseFee());
1316 
1317         // Transfer liability security and hold on contract
1318         ERC20 token = liability.token();
1319         if (liability.cost() > 0)
1320             token.safeTransferFrom(liability.promisee(),
1321                                    liability,
1322                                    liability.cost());
1323 
1324         // Transfer validator fee and hold on contract
1325         if (address(liability.validator()) != 0 && liability.validatorFee() > 0)
1326             xrt.safeTransferFrom(liability.promisee(),
1327                                  liability,
1328                                  liability.validatorFee());
1329 
1330         // Accounting gas usage of transaction
1331         uint256 gas = gasinit - gasleft() + 110525; // Including observation error
1332         totalGasUtilizing       += gas;
1333         gasUtilizing[liability] += gas;
1334      }
1335 
1336     /**
1337      * @dev Create lighthouse smart contract
1338      * @param _minimalFreeze Minimal freeze value of XRT token
1339      * @param _timeoutBlocks Max time of lighthouse silence in blocks
1340      * @param _name Lighthouse subdomain,
1341      *              example: for 'my-name' will created 'my-name.lighthouse.1.robonomics.eth' domain
1342      */
1343     function createLighthouse(
1344         uint256 _minimalFreeze,
1345         uint256 _timeoutBlocks,
1346         string  _name
1347     )
1348         external
1349         returns (address lighthouse)
1350     {
1351         bytes32 lighthouseNode
1352             // lighthouse.3.robonomics.eth
1353             = 0x87bd923a85f096b00a4a347fb56cef68e95319b3d9dae1dff59259db094afd02;
1354 
1355         // Name reservation check
1356         bytes32 subnode = keccak256(abi.encodePacked(lighthouseNode, keccak256(_name)));
1357         require(ens.resolver(subnode) == 0);
1358 
1359         // Create lighthouse
1360         lighthouse = new Lighthouse(lighthouseLib, _minimalFreeze, _timeoutBlocks);
1361         emit NewLighthouse(lighthouse, _name);
1362         isLighthouse[lighthouse] = true;
1363 
1364         // Register subnode
1365         ens.setSubnodeOwner(lighthouseNode, keccak256(_name), this);
1366 
1367         // Register lighthouse address
1368         PublicResolver resolver = PublicResolver(ens.resolver(lighthouseNode));
1369         ens.setResolver(subnode, resolver);
1370         resolver.setAddr(subnode, lighthouse);
1371     }
1372 
1373     /**
1374      * @dev Is called whan after liability finalization
1375      * @param _gas Liability finalization gas expenses
1376      */
1377     function liabilityFinalized(
1378         uint256 _gas
1379     )
1380         external
1381         gasPriceEstimated
1382         returns (bool)
1383     {
1384         require(gasUtilizing[msg.sender] > 0);
1385 
1386         uint256 gas = _gas - gasleft();
1387         require(_gas > gas);
1388 
1389         totalGasUtilizing        += gas;
1390         gasUtilizing[msg.sender] += gas;
1391 
1392         require(xrt.mint(tx.origin, wnFromGas(gasUtilizing[msg.sender])));
1393         return true;
1394     }
1395 }