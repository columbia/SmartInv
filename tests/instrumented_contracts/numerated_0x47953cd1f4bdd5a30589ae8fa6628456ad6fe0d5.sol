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
502 // File: contracts/robonomics/DutchAuction.sol
503 
504 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
505 /// @author Stefan George - <stefan.george@consensys.net>
506 /// @author Airalab - <research@aira.life> 
507 contract DutchAuction {
508 
509     /*
510      *  Events
511      */
512     event BidSubmission(address indexed sender, uint256 amount);
513 
514     /*
515      *  Constants
516      */
517     uint constant public MAX_TOKENS_SOLD = 800 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
518     uint constant public WAITING_PERIOD = 0; // 1 days;
519 
520     /*
521      *  Storage
522      */
523     XRT     public xrt;
524     address public ambix;
525     address public wallet;
526     address public owner;
527     uint public ceiling;
528     uint public priceFactor;
529     uint public startBlock;
530     uint public endTime;
531     uint public totalReceived;
532     uint public finalPrice;
533     mapping (address => uint) public bids;
534     Stages public stage;
535 
536     /*
537      *  Enums
538      */
539     enum Stages {
540         AuctionDeployed,
541         AuctionSetUp,
542         AuctionStarted,
543         AuctionEnded,
544         TradingStarted
545     }
546 
547     /*
548      *  Modifiers
549      */
550     modifier atStage(Stages _stage) {
551         // Contract on stage
552         require(stage == _stage);
553         _;
554     }
555 
556     modifier isOwner() {
557         // Only owner is allowed to proceed
558         require(msg.sender == owner);
559         _;
560     }
561 
562     modifier isWallet() {
563         // Only wallet is allowed to proceed
564         require(msg.sender == wallet);
565         _;
566     }
567 
568     modifier isValidPayload() {
569         require(msg.data.length == 4 || msg.data.length == 36);
570         _;
571     }
572 
573     modifier timedTransitions() {
574         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
575             finalizeAuction();
576         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
577             stage = Stages.TradingStarted;
578         _;
579     }
580 
581     /*
582      *  Public functions
583      */
584     /// @dev Contract constructor function sets owner.
585     /// @param _wallet Multisig wallet.
586     /// @param _ceiling Auction ceiling.
587     /// @param _priceFactor Auction price factor.
588     constructor(address _wallet, uint _ceiling, uint _priceFactor)
589         public
590     {
591         require(_wallet != 0 && _ceiling > 0 && _priceFactor > 0);
592 
593         owner = msg.sender;
594         wallet = _wallet;
595         ceiling = _ceiling;
596         priceFactor = _priceFactor;
597         stage = Stages.AuctionDeployed;
598     }
599 
600     /// @dev Setup function sets external contracts' addresses.
601     /// @param _xrt Robonomics token address.
602     /// @param _ambix Distillation cube address.
603     function setup(address _xrt, address _ambix)
604         public
605         isOwner
606         atStage(Stages.AuctionDeployed)
607     {
608         // Validate argument
609         require(_xrt != 0 && _ambix != 0);
610 
611         xrt = XRT(_xrt);
612         ambix = _ambix;
613 
614         // Validate token balance
615         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
616 
617         stage = Stages.AuctionSetUp;
618     }
619 
620     /// @dev Starts auction and sets startBlock.
621     function startAuction()
622         public
623         isWallet
624         atStage(Stages.AuctionSetUp)
625     {
626         stage = Stages.AuctionStarted;
627         startBlock = block.number;
628     }
629 
630     /// @dev Calculates current token price.
631     /// @return Returns token price.
632     function calcCurrentTokenPrice()
633         public
634         timedTransitions
635         returns (uint)
636     {
637         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
638             return finalPrice;
639         return calcTokenPrice();
640     }
641 
642     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
643     /// @return Returns current auction stage.
644     function updateStage()
645         public
646         timedTransitions
647         returns (Stages)
648     {
649         return stage;
650     }
651 
652     /// @dev Allows to send a bid to the auction.
653     /// @param receiver Bid will be assigned to this address if set.
654     function bid(address receiver)
655         public
656         payable
657         isValidPayload
658         timedTransitions
659         atStage(Stages.AuctionStarted)
660         returns (uint amount)
661     {
662         require(msg.value > 0);
663         amount = msg.value;
664 
665         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
666         if (receiver == 0)
667             receiver = msg.sender;
668 
669         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
670         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
671         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
672         if (maxWeiBasedOnTotalReceived < maxWei)
673             maxWei = maxWeiBasedOnTotalReceived;
674 
675         // Only invest maximum possible amount.
676         if (amount > maxWei) {
677             amount = maxWei;
678             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
679             receiver.transfer(msg.value - amount);
680         }
681 
682         // Forward funding to ether wallet
683         wallet.transfer(amount);
684 
685         bids[receiver] += amount;
686         totalReceived += amount;
687         emit BidSubmission(receiver, amount);
688 
689         // Finalize auction when maxWei reached
690         if (amount == maxWei)
691             finalizeAuction();
692     }
693 
694     /// @dev Claims tokens for bidder after auction.
695     /// @param receiver Tokens will be assigned to this address if set.
696     function claimTokens(address receiver)
697         public
698         isValidPayload
699         timedTransitions
700         atStage(Stages.TradingStarted)
701     {
702         if (receiver == 0)
703             receiver = msg.sender;
704         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
705         bids[receiver] = 0;
706         require(xrt.transfer(receiver, tokenCount));
707     }
708 
709     /// @dev Calculates stop price.
710     /// @return Returns stop price.
711     function calcStopPrice()
712         view
713         public
714         returns (uint)
715     {
716         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
717     }
718 
719     /// @dev Calculates token price.
720     /// @return Returns token price.
721     function calcTokenPrice()
722         view
723         public
724         returns (uint)
725     {
726         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
727     }
728 
729     /*
730      *  Private functions
731      */
732     function finalizeAuction()
733         private
734     {
735         stage = Stages.AuctionEnded;
736         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
737         uint soldTokens = totalReceived * 10**9 / finalPrice;
738 
739         if (totalReceived == ceiling) {
740             // Auction contract transfers all unsold tokens to Ambix contract
741             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
742         } else {
743             // Auction contract burn all unsold tokens
744             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
745         }
746 
747         endTime = now;
748     }
749 }