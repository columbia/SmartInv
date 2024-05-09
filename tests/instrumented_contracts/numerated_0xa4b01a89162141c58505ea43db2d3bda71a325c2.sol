1 /* *******************************************************************
2 
3     ~~~888~~~ Y88b    /  e88~-_  ,d88~~\           888           
4        888     Y88b  /  d888   \ 8888      /~~~8e  888  e88~~8e  
5        888      Y88b/   8888     `Y88b         88b 888 d888  88b 
6        888      /Y88b   8888      `Y88b,  e88~-888 888 8888__888 
7        888     /  Y88b  Y888   /    8888 C888  888 888 Y888    , 
8        888    /    Y88b  "88_-~  \__88P'  "88_-888 888  "88___/  
9                                                              
10 
11     Minting contract for TXC ERC20 subscriptions. Subscriptions aren't
12     subdivisible, and for security reasons, the code only takes payments
13     of whole units of ETH. That is, this address only takes purchases
14     of 1, 2, 3, and so on whole units of ETH.
15     The subscription sale mints whole units of TXC, and these are capped
16     at a total of 5000. Subscriptions are transferable and serve several
17     purposes.
18     
19     Note: This address is the only authorised minter of TXC and this
20     address does not have an owner. It is a fully standalone minter.
21     
22     More information at https://web3.txcast.io.
23     
24     Thank you to the people at OpenZeppelin for the amazing templates
25     that keep us same.
26 ******************************************************************* */
27 
28 pragma solidity 0.5.1;
29 
30 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 interface IERC20 {
37   function totalSupply() external view returns (uint256);
38 
39   function balanceOf(address who) external view returns (uint256);
40 
41   function allowance(address owner, address spender)
42     external view returns (uint256);
43 
44   function transfer(address to, uint256 value) external returns (bool);
45 
46   function approve(address spender, uint256 value)
47     external returns (bool);
48 
49   function transferFrom(address from, address to, uint256 value)
50     external returns (bool);
51 
52   event Transfer(
53     address indexed from,
54     address indexed to,
55     uint256 value
56   );
57 
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint256 value
62   );
63 }
64 
65 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that revert on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, reverts on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78     // benefit is lost if 'b' is also tested.
79     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
80     if (a == 0) {
81       return 0;
82     }
83 
84     uint256 c = a * b;
85     require(c / a == b);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     require(b > 0); // Solidity only automatically asserts when dividing by 0
95     uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97 
98     return c;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b <= a);
106     uint256 c = a - b;
107 
108     return c;
109   }
110 
111   /**
112   * @dev Adds two numbers, reverts on overflow.
113   */
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     require(c >= a);
117 
118     return c;
119   }
120 
121   /**
122   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
123   * reverts when dividing by zero.
124   */
125   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126     require(b != 0);
127     return a % b;
128   }
129 }
130 
131 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
138  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract ERC20 is IERC20 {
141   using SafeMath for uint256;
142 
143   mapping (address => uint256) private _balances;
144 
145   mapping (address => mapping (address => uint256)) private _allowed;
146 
147   uint256 private _totalSupply;
148 
149   /**
150   * @dev Total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return _totalSupply;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param owner The address to query the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address owner) public view returns (uint256) {
162     return _balances[owner];
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param owner address The address which owns the funds.
168    * @param spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(
172     address owner,
173     address spender
174    )
175     public
176     view
177     returns (uint256)
178   {
179     return _allowed[owner][spender];
180   }
181 
182   /**
183   * @dev Transfer token for a specified address
184   * @param to The address to transfer to.
185   * @param value The amount to be transferred.
186   */
187   function transfer(address to, uint256 value) public returns (bool) {
188     _transfer(msg.sender, to, value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param spender The address which will spend the funds.
199    * @param value The amount of tokens to be spent.
200    */
201   function approve(address spender, uint256 value) public returns (bool) {
202     require(spender != address(0));
203 
204     _allowed[msg.sender][spender] = value;
205     emit Approval(msg.sender, spender, value);
206     return true;
207   }
208 
209   /**
210    * @dev Transfer tokens from one address to another
211    * @param from address The address which you want to send tokens from
212    * @param to address The address which you want to transfer to
213    * @param value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(
216     address from,
217     address to,
218     uint256 value
219   )
220     public
221     returns (bool)
222   {
223     require(value <= _allowed[from][msg.sender]);
224 
225     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
226     _transfer(from, to, value);
227     return true;
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed_[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param spender The address which will spend the funds.
237    * @param addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseAllowance(
240     address spender,
241     uint256 addedValue
242   )
243     public
244     returns (bool)
245   {
246     require(spender != address(0));
247 
248     _allowed[msg.sender][spender] = (
249       _allowed[msg.sender][spender].add(addedValue));
250     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed_[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param spender The address which will spend the funds.
261    * @param subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseAllowance(
264     address spender,
265     uint256 subtractedValue
266   )
267     public
268     returns (bool)
269   {
270     require(spender != address(0));
271 
272     _allowed[msg.sender][spender] = (
273       _allowed[msg.sender][spender].sub(subtractedValue));
274     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
275     return true;
276   }
277 
278   /**
279   * @dev Transfer token for a specified addresses
280   * @param from The address to transfer from.
281   * @param to The address to transfer to.
282   * @param value The amount to be transferred.
283   */
284   function _transfer(address from, address to, uint256 value) internal {
285     require(value <= _balances[from]);
286     require(to != address(0));
287 
288     _balances[from] = _balances[from].sub(value);
289     _balances[to] = _balances[to].add(value);
290     emit Transfer(from, to, value);
291   }
292 
293   /**
294    * @dev Internal function that mints an amount of the token and assigns it to
295    * an account. This encapsulates the modification of balances such that the
296    * proper events are emitted.
297    * @param account The account that will receive the created tokens.
298    * @param value The amount that will be created.
299    */
300   function _mint(address account, uint256 value) internal {
301     require(account != address(0));
302     _totalSupply = _totalSupply.add(value);
303     _balances[account] = _balances[account].add(value);
304     emit Transfer(address(0), account, value);
305   }
306 
307   /**
308    * @dev Internal function that burns an amount of the token of a given
309    * account.
310    * @param account The account whose tokens will be burnt.
311    * @param value The amount that will be burnt.
312    */
313   function _burn(address account, uint256 value) internal {
314     require(account != address(0));
315     require(value <= _balances[account]);
316 
317     _totalSupply = _totalSupply.sub(value);
318     _balances[account] = _balances[account].sub(value);
319     emit Transfer(account, address(0), value);
320   }
321 
322   /**
323    * @dev Internal function that burns an amount of the token of a given
324    * account, deducting from the sender's allowance for said account. Uses the
325    * internal burn function.
326    * @param account The account whose tokens will be burnt.
327    * @param value The amount that will be burnt.
328    */
329   function _burnFrom(address account, uint256 value) internal {
330     require(value <= _allowed[account][msg.sender]);
331 
332     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
333     // this function needs to emit an event with the updated approval.
334     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
335       value);
336     _burn(account, value);
337   }
338 }
339 
340 // File: openzeppelin-solidity/contracts/access/Roles.sol
341 
342 /**
343  * @title Roles
344  * @dev Library for managing addresses assigned to a Role.
345  */
346 library Roles {
347   struct Role {
348     mapping (address => bool) bearer;
349   }
350 
351   /**
352    * @dev give an account access to this role
353    */
354   function add(Role storage role, address account) internal {
355     require(account != address(0));
356     require(!has(role, account));
357 
358     role.bearer[account] = true;
359   }
360 
361   /**
362    * @dev remove an account's access to this role
363    */
364   function remove(Role storage role, address account) internal {
365     require(account != address(0));
366     require(has(role, account));
367 
368     role.bearer[account] = false;
369   }
370 
371   /**
372    * @dev check if an account has this role
373    * @return bool
374    */
375   function has(Role storage role, address account)
376     internal
377     view
378     returns (bool)
379   {
380     require(account != address(0));
381     return role.bearer[account];
382   }
383 }
384 
385 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
386 
387 contract MinterRole {
388   using Roles for Roles.Role;
389 
390   event MinterAdded(address indexed account);
391   event MinterRemoved(address indexed account);
392 
393   Roles.Role private minters;
394 
395   constructor() internal {
396     _addMinter(msg.sender);
397   }
398 
399   modifier onlyMinter() {
400     require(isMinter(msg.sender));
401     _;
402   }
403 
404   function isMinter(address account) public view returns (bool) {
405     return minters.has(account);
406   }
407 
408   function addMinter(address account) public onlyMinter {
409     _addMinter(account);
410   }
411 
412   function renounceMinter() public {
413     _removeMinter(msg.sender);
414   }
415 
416   function _addMinter(address account) internal {
417     minters.add(account);
418     emit MinterAdded(account);
419   }
420 
421   function _removeMinter(address account) internal {
422     minters.remove(account);
423     emit MinterRemoved(account);
424   }
425 }
426 
427 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
428 
429 /**
430  * @title ERC20Mintable
431  * @dev ERC20 minting logic
432  */
433 contract ERC20Mintable is ERC20, MinterRole {
434   /**
435    * @dev Function to mint tokens
436    * @param to The address that will receive the minted tokens.
437    * @param value The amount of tokens to mint.
438    * @return A boolean that indicates if the operation was successful.
439    */
440   function mint(
441     address to,
442     uint256 value
443   )
444     public
445     onlyMinter
446     returns (bool)
447   {
448     _mint(to, value);
449     return true;
450   }
451 }
452 
453 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
454 
455 /**
456  * @title ERC20Detailed token
457  * @dev The decimals are only for visualization purposes.
458  * All the operations are done using the smallest and indivisible token unit,
459  * just as on Ethereum all the operations are done in wei.
460  */
461 contract ERC20Detailed is IERC20 {
462   string private _name;
463   string private _symbol;
464   uint8 private _decimals;
465 
466   constructor(string memory name, string memory symbol, uint8 decimals) public {
467     _name = name;
468     _symbol = symbol;
469     _decimals = decimals;
470   }
471 
472   /**
473    * @return the name of the token.
474    */
475   function name() public view returns(string memory) {
476     return _name;
477   }
478 
479   /**
480    * @return the symbol of the token.
481    */
482   function symbol() public view returns(string memory) {
483     return _symbol;
484   }
485 
486   /**
487    * @return the number of decimals of the token.
488    */
489   function decimals() public view returns(uint8) {
490     return _decimals;
491   }
492 }
493 
494 // File: contracts/TXCast.sol
495 
496 contract TXCast is ERC20Mintable, ERC20Detailed {
497   constructor () public ERC20Detailed("TXCast", "TXC", 0) {}
498 }
499 
500 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
501 
502 /**
503  * @title SafeERC20
504  * @dev Wrappers around ERC20 operations that throw on failure.
505  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509 
510   using SafeMath for uint256;
511 
512   function safeTransfer(
513     IERC20 token,
514     address to,
515     uint256 value
516   )
517     internal
518   {
519     require(token.transfer(to, value));
520   }
521 
522   function safeTransferFrom(
523     IERC20 token,
524     address from,
525     address to,
526     uint256 value
527   )
528     internal
529   {
530     require(token.transferFrom(from, to, value));
531   }
532 
533   function safeApprove(
534     IERC20 token,
535     address spender,
536     uint256 value
537   )
538     internal
539   {
540     // safeApprove should only be called when setting an initial allowance, 
541     // or when resetting it to zero. To increase and decrease it, use 
542     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
543     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
544     require(token.approve(spender, value));
545   }
546 
547   function safeIncreaseAllowance(
548     IERC20 token,
549     address spender,
550     uint256 value
551   )
552     internal
553   {
554     uint256 newAllowance = token.allowance(address(this), spender).add(value);
555     require(token.approve(spender, newAllowance));
556   }
557 
558   function safeDecreaseAllowance(
559     IERC20 token,
560     address spender,
561     uint256 value
562   )
563     internal
564   {
565     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
566     require(token.approve(spender, newAllowance));
567   }
568 }
569 
570 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
571 
572 /**
573  * @title Helps contracts guard against reentrancy attacks.
574  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
575  * @dev If you mark a function `nonReentrant`, you should also
576  * mark it `external`.
577  */
578 contract ReentrancyGuard {
579 
580   /// @dev counter to allow mutex lock with only one SSTORE operation
581   uint256 private _guardCounter;
582 
583   constructor() internal {
584     // The counter starts at one to prevent changing it from zero to a non-zero
585     // value, which is a more expensive operation.
586     _guardCounter = 1;
587   }
588 
589   /**
590    * @dev Prevents a contract from calling itself, directly or indirectly.
591    * Calling a `nonReentrant` function from another `nonReentrant`
592    * function is not supported. It is possible to prevent this from happening
593    * by making the `nonReentrant` function external, and make it call a
594    * `private` function that does the actual work.
595    */
596   modifier nonReentrant() {
597     _guardCounter += 1;
598     uint256 localCounter = _guardCounter;
599     _;
600     require(localCounter == _guardCounter);
601   }
602 
603 }
604 
605 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
606 
607 /**
608  * @title Crowdsale
609  * @dev Crowdsale is a base contract for managing a token crowdsale,
610  * allowing investors to purchase tokens with ether. This contract implements
611  * such functionality in its most fundamental form and can be extended to provide additional
612  * functionality and/or custom behavior.
613  * The external interface represents the basic interface for purchasing tokens, and conform
614  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
615  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
616  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
617  * behavior.
618  */
619 contract Crowdsale is ReentrancyGuard {
620   using SafeMath for uint256;
621   using SafeERC20 for IERC20;
622 
623   // The token being sold
624   IERC20 private _token;
625 
626   // Address where funds are collected
627   address payable private _wallet;
628 
629   // How many token units a buyer gets per wei.
630   // The rate is the conversion between wei and the smallest and indivisible token unit.
631   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
632   // 1 wei will give you 1 unit, or 0.001 TOK.
633   uint256 private _rate;
634 
635   // Amount of wei raised
636   uint256 private _weiRaised;
637 
638   /**
639    * Event for token purchase logging
640    * @param purchaser who paid for the tokens
641    * @param beneficiary who got the tokens
642    * @param value weis paid for purchase
643    * @param amount amount of tokens purchased
644    */
645   event TokensPurchased(
646     address indexed purchaser,
647     address indexed beneficiary,
648     uint256 value,
649     uint256 amount
650   );
651 
652   /**
653    * @param rate Number of token units a buyer gets per wei
654    * @dev The rate is the conversion between wei and the smallest and indivisible
655    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
656    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
657    * @param wallet Address where collected funds will be forwarded to
658    */
659   constructor(uint256 rate, address payable wallet/*, IERC20 token*/) internal {
660     require(rate > 0);
661     require(wallet != address(0));
662     //require(address(token) != address(0));
663 
664     _rate = rate;
665     _wallet = wallet;
666     _token = new TXCast();
667   }
668 
669   // -----------------------------------------
670   // Crowdsale external interface
671   // -----------------------------------------
672 
673   /**
674    * @dev fallback function ***DO NOT OVERRIDE***
675    * Note that other contracts will transfer fund with a base gas stipend
676    * of 2300, which is not enough to call buyTokens. Consider calling
677    * buyTokens directly when purchasing tokens from a contract.
678    */
679   function () external payable {
680     buyTokens(msg.sender);
681   }
682 
683   /**
684    * @return the token being sold.
685    */
686   function token() public view returns(IERC20) {
687     return _token;
688   }
689 
690   /**
691    * @return the address where funds are collected.
692    */
693   function wallet() public view returns(address) {
694     return _wallet;
695   }
696 
697   /**
698    * @return the number of token units a buyer gets per wei.
699    */
700   function rate() public view returns(uint256) {
701     return _rate;
702   }
703 
704   /**
705    * @return the amount of wei raised.
706    */
707   function weiRaised() public view returns (uint256) {
708     return _weiRaised;
709   }
710 
711   /**
712    * @dev low level token purchase ***DO NOT OVERRIDE***
713    * This function has a non-reentrancy guard, so it shouldn't be called by
714    * another `nonReentrant` function.
715    * @param beneficiary Recipient of the token purchase
716    */
717   function buyTokens(address beneficiary) public nonReentrant payable {
718 
719     uint256 weiAmount = msg.value;
720     _preValidatePurchase(beneficiary, weiAmount);
721 
722     // calculate token amount to be created
723     uint256 tokens = _getTokenAmount(weiAmount);
724 
725     // update state
726     _weiRaised = _weiRaised.add(weiAmount);
727 
728     _processPurchase(beneficiary, tokens);
729     emit TokensPurchased(
730       msg.sender,
731       beneficiary,
732       weiAmount,
733       tokens
734     );
735 
736     _updatePurchasingState(beneficiary, weiAmount);
737 
738     _forwardFunds();
739     _postValidatePurchase(beneficiary, weiAmount);
740   }
741 
742   // -----------------------------------------
743   // Internal interface (extensible)
744   // -----------------------------------------
745 
746   /**
747    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
748    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
749    *   super._preValidatePurchase(beneficiary, weiAmount);
750    *   require(weiRaised().add(weiAmount) <= cap);
751    * @param beneficiary Address performing the token purchase
752    * @param weiAmount Value in wei involved in the purchase
753    */
754   function _preValidatePurchase(
755     address beneficiary,
756     uint256 weiAmount
757   )
758     internal
759     view
760   {
761     require(beneficiary != address(0));
762     require(weiAmount != 0);
763     require(uint(weiAmount >> 18) << 18 == weiAmount);
764   }
765 
766   /**
767    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
768    * @param beneficiary Address performing the token purchase
769    * @param weiAmount Value in wei involved in the purchase
770    */
771   function _postValidatePurchase(
772     address beneficiary,
773     uint256 weiAmount
774   )
775     internal
776     view
777   {
778     // optional override
779   }
780 
781   /**
782    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
783    * @param beneficiary Address performing the token purchase
784    * @param tokenAmount Number of tokens to be emitted
785    */
786   function _deliverTokens(
787     address beneficiary,
788     uint256 tokenAmount
789   )
790     internal
791   {
792     _token.safeTransfer(beneficiary, tokenAmount);
793   }
794 
795   /**
796    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
797    * @param beneficiary Address receiving the tokens
798    * @param tokenAmount Number of tokens to be purchased
799    */
800   function _processPurchase(
801     address beneficiary,
802     uint256 tokenAmount
803   )
804     internal
805   {
806     _deliverTokens(beneficiary, tokenAmount);
807   }
808 
809   /**
810    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
811    * @param beneficiary Address receiving the tokens
812    * @param weiAmount Value in wei involved in the purchase
813    */
814   function _updatePurchasingState(
815     address beneficiary,
816     uint256 weiAmount
817   )
818     internal
819   {
820     // optional override
821   }
822 
823   /**
824    * @dev Override to extend the way in which ether is converted to tokens.
825    * @param weiAmount Value in wei to be converted into tokens
826    * @return Number of tokens that can be purchased with the specified _weiAmount
827    */
828   function _getTokenAmount(uint256 weiAmount)
829     internal view returns (uint256)
830   {
831     return weiAmount.div(1 ether);
832   }
833 
834   /**
835    * @dev Determines how ETH is stored/forwarded on purchases.
836    */
837   function _forwardFunds() internal {
838     _wallet.transfer(msg.value);
839   }
840 }
841 
842 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
843 
844 /**
845  * @title MintedCrowdsale
846  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
847  * Token ownership should be transferred to MintedCrowdsale for minting.
848  */
849 contract MintedCrowdsale is Crowdsale {
850   constructor() internal {}
851 
852   /**
853    * @dev Overrides delivery by minting tokens upon purchase.
854    * @param beneficiary Token purchaser
855    * @param tokenAmount Number of tokens to be minted
856    */
857   function _deliverTokens(
858     address beneficiary,
859     uint256 tokenAmount
860   )
861     internal
862   {
863     // Potentially dangerous assumption about the type of the token.
864     require(
865       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
866   }
867 }
868 
869 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
870 
871 /**
872  * @title CappedCrowdsale
873  * @dev Crowdsale with a limit for total contributions.
874  */
875 contract CappedCrowdsale is Crowdsale {
876   using SafeMath for uint256;
877 
878   uint256 private _cap;
879 
880   /**
881    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
882    * @param cap Max amount of wei to be contributed
883    */
884   constructor(uint256 cap) internal {
885     require(cap > 0);
886     _cap = cap;
887   }
888 
889   /**
890    * @return the cap of the crowdsale.
891    */
892   function cap() public view returns(uint256) {
893     return _cap;
894   }
895 
896   /**
897    * @dev Checks whether the cap has been reached.
898    * @return Whether the cap was reached
899    */
900   function capReached() public view returns (bool) {
901     return weiRaised() >= _cap;
902   }
903 
904   /**
905    * @dev Extend parent behavior requiring purchase to respect the funding cap.
906    * @param beneficiary Token purchaser
907    * @param weiAmount Amount of wei contributed
908    */
909   function _preValidatePurchase(
910     address beneficiary,
911     uint256 weiAmount
912   )
913     internal
914     view
915   {
916     super._preValidatePurchase(beneficiary, weiAmount);
917     require(weiRaised().add(weiAmount) <= _cap);
918   }
919 
920 }
921 
922 // File: contracts/TXCSale.sol
923 
924 contract TXCSale is CappedCrowdsale, MintedCrowdsale {
925   constructor
926   (
927     uint256 _cap,
928     address payable _wallet
929   )
930   public
931   Crowdsale(1 ether, _wallet)
932   CappedCrowdsale(_cap * 1 ether) {
933       
934   }
935 }