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
528 // File: contracts/robonomics/DutchAuction.sol
529 
530 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
531 /// @author Stefan George - <stefan.george@consensys.net>
532 /// @author Airalab - <research@aira.life> 
533 contract DutchAuction {
534 
535     /*
536      *  Events
537      */
538     event BidSubmission(address indexed sender, uint256 amount);
539 
540     /*
541      *  Constants
542      */
543     uint constant public MAX_TOKENS_SOLD = 800 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
544     uint constant public WAITING_PERIOD = 0; // 1 days;
545 
546     /*
547      *  Storage
548      */
549     XRT     public xrt;
550     address public ambix;
551     address public wallet;
552     address public owner;
553     uint public ceiling;
554     uint public priceFactor;
555     uint public startBlock;
556     uint public endTime;
557     uint public totalReceived;
558     uint public finalPrice;
559     mapping (address => uint) public bids;
560     Stages public stage;
561 
562     /*
563      *  Enums
564      */
565     enum Stages {
566         AuctionDeployed,
567         AuctionSetUp,
568         AuctionStarted,
569         AuctionEnded,
570         TradingStarted
571     }
572 
573     /*
574      *  Modifiers
575      */
576     modifier atStage(Stages _stage) {
577         // Contract on stage
578         require(stage == _stage);
579         _;
580     }
581 
582     modifier isOwner() {
583         // Only owner is allowed to proceed
584         require(msg.sender == owner);
585         _;
586     }
587 
588     modifier isWallet() {
589         // Only wallet is allowed to proceed
590         require(msg.sender == wallet);
591         _;
592     }
593 
594     modifier isValidPayload() {
595         require(msg.data.length == 4 || msg.data.length == 36);
596         _;
597     }
598 
599     modifier timedTransitions() {
600         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
601             finalizeAuction();
602         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
603             stage = Stages.TradingStarted;
604         _;
605     }
606 
607     /*
608      *  Public functions
609      */
610     /// @dev Contract constructor function sets owner.
611     /// @param _wallet Multisig wallet.
612     /// @param _ceiling Auction ceiling.
613     /// @param _priceFactor Auction price factor.
614     constructor(address _wallet, uint _ceiling, uint _priceFactor)
615         public
616     {
617         require(_wallet != 0 && _ceiling > 0 && _priceFactor > 0);
618 
619         owner = msg.sender;
620         wallet = _wallet;
621         ceiling = _ceiling;
622         priceFactor = _priceFactor;
623         stage = Stages.AuctionDeployed;
624     }
625 
626     /// @dev Setup function sets external contracts' addresses.
627     /// @param _xrt Robonomics token address.
628     /// @param _ambix Distillation cube address.
629     function setup(address _xrt, address _ambix)
630         public
631         isOwner
632         atStage(Stages.AuctionDeployed)
633     {
634         // Validate argument
635         require(_xrt != 0 && _ambix != 0);
636 
637         xrt = XRT(_xrt);
638         ambix = _ambix;
639 
640         // Validate token balance
641         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
642 
643         stage = Stages.AuctionSetUp;
644     }
645 
646     /// @dev Starts auction and sets startBlock.
647     function startAuction()
648         public
649         isWallet
650         atStage(Stages.AuctionSetUp)
651     {
652         stage = Stages.AuctionStarted;
653         startBlock = block.number;
654     }
655 
656     /// @dev Calculates current token price.
657     /// @return Returns token price.
658     function calcCurrentTokenPrice()
659         public
660         timedTransitions
661         returns (uint)
662     {
663         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
664             return finalPrice;
665         return calcTokenPrice();
666     }
667 
668     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
669     /// @return Returns current auction stage.
670     function updateStage()
671         public
672         timedTransitions
673         returns (Stages)
674     {
675         return stage;
676     }
677 
678     /// @dev Allows to send a bid to the auction.
679     /// @param receiver Bid will be assigned to this address if set.
680     function bid(address receiver)
681         public
682         payable
683         isValidPayload
684         timedTransitions
685         atStage(Stages.AuctionStarted)
686         returns (uint amount)
687     {
688         require(msg.value > 0);
689         amount = msg.value;
690 
691         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
692         if (receiver == 0)
693             receiver = msg.sender;
694 
695         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
696         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
697         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
698         if (maxWeiBasedOnTotalReceived < maxWei)
699             maxWei = maxWeiBasedOnTotalReceived;
700 
701         // Only invest maximum possible amount.
702         if (amount > maxWei) {
703             amount = maxWei;
704             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
705             receiver.transfer(msg.value - amount);
706         }
707 
708         // Forward funding to ether wallet
709         wallet.transfer(amount);
710 
711         bids[receiver] += amount;
712         totalReceived += amount;
713         emit BidSubmission(receiver, amount);
714 
715         // Finalize auction when maxWei reached
716         if (amount == maxWei)
717             finalizeAuction();
718     }
719 
720     /// @dev Claims tokens for bidder after auction.
721     /// @param receiver Tokens will be assigned to this address if set.
722     function claimTokens(address receiver)
723         public
724         isValidPayload
725         timedTransitions
726         atStage(Stages.TradingStarted)
727     {
728         if (receiver == 0)
729             receiver = msg.sender;
730         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
731         bids[receiver] = 0;
732         require(xrt.transfer(receiver, tokenCount));
733     }
734 
735     /// @dev Calculates stop price.
736     /// @return Returns stop price.
737     function calcStopPrice()
738         view
739         public
740         returns (uint)
741     {
742         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
743     }
744 
745     /// @dev Calculates token price.
746     /// @return Returns token price.
747     function calcTokenPrice()
748         view
749         public
750         returns (uint)
751     {
752         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
753     }
754 
755     /*
756      *  Private functions
757      */
758     function finalizeAuction()
759         private
760     {
761         stage = Stages.AuctionEnded;
762         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
763         uint soldTokens = totalReceived * 10**9 / finalPrice;
764 
765         if (totalReceived == ceiling) {
766             // Auction contract transfers all unsold tokens to Ambix contract
767             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
768         } else {
769             // Auction contract burn all unsold tokens
770             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
771         }
772 
773         endTime = now;
774     }
775 }