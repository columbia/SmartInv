1 pragma solidity ^0.4.24;
2 
3 
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
15   external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20   external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23   external returns (bool);
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
38 interface IPickFlixToken {
39   function totalSupply() external view returns (uint256);
40 
41   function balanceOf(address who) external view returns (uint256);
42 
43   function allowance(address owner, address spender)
44   external view returns (uint256);
45 
46   function transfer(address to, uint256 value) external returns (bool);
47 
48   function approve(address spender, uint256 value)
49   external returns (bool);
50 
51   function transferFrom(address from, address to, uint256 value)
52   external returns (bool);
53 
54   event Transfer(
55     address indexed from,
56     address indexed to,
57     uint256 value
58   );
59 
60   event Approval(
61     address indexed owner,
62     address indexed spender,
63     uint256 value
64   );
65 
66   function closeNow() public;
67   function kill() public;
68   function rate() public view returns(uint256);
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that revert on error
75  */
76 library SafeMath {
77 
78   /**
79    * @dev Multiplies two numbers, reverts on overflow.
80    */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (a == 0) {
86       return 0;
87     }
88 
89     uint256 c = a * b;
90     require(c / a == b);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b > 0); // Solidity only automatically asserts when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   /**
106    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107    */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b <= a);
110     uint256 c = a - b;
111     return c;
112   }
113 
114   /**
115    * @dev Adds two numbers, reverts on overflow.
116    */
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     require(c >= a);
120     return c;
121   }
122 
123   /**
124    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125    * reverts when dividing by zero.
126    */
127   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128     require(b != 0);
129     return a % b;
130   }
131 }
132 
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
140  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract ERC20 is IERC20 {
143   using SafeMath for uint256;
144 
145   mapping (address => uint256) private _balances;
146 
147   mapping (address => mapping (address => uint256)) private _allowed;
148 
149   uint256 private _totalSupply;
150 
151   /**
152   * @dev Total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return _totalSupply;
156   }
157 
158   /**
159    * @dev Gets the balance of the specified address.
160    * @param owner The address to query the balance of.
161    * @return An uint256 representing the amount owned by the passed address.
162    */
163   function balanceOf(address owner) public view returns (uint256) {
164     return _balances[owner];
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param owner address The address which owns the funds.
170    * @param spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(
174       address owner,
175       address spender
176       )
177     public
178     view
179     returns (uint256)
180     {
181       return _allowed[owner][spender];
182     }
183 
184   /**
185    * @dev Transfer token for a specified address
186    * @param to The address to transfer to.
187    * @param value The amount to be transferred.
188    */
189   function transfer(address to, uint256 value) public returns (bool) {
190     _transfer(msg.sender, to, value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param spender The address which will spend the funds.
201    * @param value The amount of tokens to be spent.
202    */
203   function approve(address spender, uint256 value) public returns (bool) {
204     require(spender != address(0));
205 
206   _allowed[msg.sender][spender] = value;
207   emit Approval(msg.sender, spender, value);
208   return true;
209 }
210 
211 /**
212  * @dev Transfer tokens from one address to another
213  * @param from address The address which you want to send tokens from
214  * @param to address The address which you want to transfer to
215  * @param value uint256 the amount of tokens to be transferred
216  */
217 function transferFrom(
218     address from,
219     address to,
220     uint256 value
221     )
222   public
223 returns (bool)
224 {
225   require(value <= _allowed[from][msg.sender]);
226 
227 _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
228 _transfer(from, to, value);
229 return true;
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed_[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param spender The address which will spend the funds.
239    * @param addedValue The amount of tokens to increase the allowance by.
240    */
241 function increaseAllowance(
242     address spender,
243     uint256 addedValue
244     )
245   public
246 returns (bool)
247 {
248   require(spender != address(0));
249 
250   _allowed[msg.sender][spender] = (
251     _allowed[msg.sender][spender].add(addedValue));
252     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed_[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param spender The address which will spend the funds.
263    * @param subtractedValue The amount of tokens to decrease the allowance by.
264    */
265 function decreaseAllowance(
266     address spender,
267     uint256 subtractedValue
268     )
269   public
270 returns (bool)
271 {
272   require(spender != address(0));
273 
274   _allowed[msg.sender][spender] = (
275     _allowed[msg.sender][spender].sub(subtractedValue));
276     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
277     return true;
278   }
279 
280   /**
281   * @dev Transfer token for a specified addresses
282   * @param from The address to transfer from.
283     * @param to The address to transfer to.
284       * @param value The amount to be transferred.
285       */
286   function _transfer(address from, address to, uint256 value) internal {
287     require(value <= _balances[from]);
288     require(to != address(0));
289 
290     _balances[from] = _balances[from].sub(value);
291     _balances[to] = _balances[to].add(value);
292     emit Transfer(from, to, value);
293   }
294 
295   /**
296   * @dev Internal function that mints an amount of the token and assigns it to
297   * an account. This encapsulates the modification of balances such that the
298   * proper events are emitted.
299     * @param account The account that will receive the created tokens.
300     * @param value The amount that will be created.
301     */
302   function _mint(address account, uint256 value) internal {
303     require(account != 0);
304     _totalSupply = _totalSupply.add(value);
305     _balances[account] = _balances[account].add(value);
306     emit Transfer(address(0), account, value);
307   }
308 
309   /**
310   * @dev Internal function that burns an amount of the token of a given
311   * account.
312     * @param account The account whose tokens will be burnt.
313     * @param value The amount that will be burnt.
314     */
315   function _burn(address account, uint256 value) internal {
316     require(account != 0);
317     require(value <= _balances[account]);
318 
319     _totalSupply = _totalSupply.sub(value);
320     _balances[account] = _balances[account].sub(value);
321     emit Transfer(account, address(0), value);
322   }
323 
324   /**
325   * @dev Internal function that burns an amount of the token of a given
326   * account, deducting from the sender's allowance for said account. Uses the
327   * internal burn function.
328   * @param account The account whose tokens will be burnt.
329     * @param value The amount that will be burnt.
330     */
331   function _burnFrom(address account, uint256 value) internal {
332     require(value <= _allowed[account][msg.sender]);
333 
334     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
335     // this function needs to emit an event with the updated approval.
336     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
337       value);
338       _burn(account, value);
339   }
340 }
341 
342 
343 
344 /**
345  * @title Roles
346  * @dev Library for managing addresses assigned to a Role.
347  */
348 library Roles {
349   struct Role {
350     mapping (address => bool) bearer;
351   }
352 
353   /**
354    * @dev give an account access to this role
355    */
356   function add(Role storage role, address account) internal {
357     require(account != address(0));
358     role.bearer[account] = true;
359   }
360 
361   /**
362    * @dev remove an account's access to this role
363    */
364   function remove(Role storage role, address account) internal {
365     require(account != address(0));
366     role.bearer[account] = false;
367   }
368 
369   /**
370    * @dev check if an account has this role
371    * @return bool
372    */
373   function has(Role storage role, address account)
374   internal
375   view
376   returns (bool)
377   {
378     require(account != address(0));
379     return role.bearer[account];
380   }
381 }
382 
383 
384 
385 contract MinterRole {
386   using Roles for Roles.Role;
387 
388   event MinterAdded(address indexed account);
389   event MinterRemoved(address indexed account);
390 
391   Roles.Role private minters;
392 
393   constructor(address minter) public {
394     if(minter == 0x0) {
395       _addMinter(msg.sender);
396     } else {
397       _addMinter(minter);
398     }
399   }
400 
401   modifier onlyMinter() {
402     require(isMinter(msg.sender), "Only minter can do this");
403     _;
404   }
405 
406   function isMinter(address account) public view returns (bool) {
407     return minters.has(account);
408   }
409 
410   function addMinter(address account) public onlyMinter {
411     _addMinter(account);
412   }
413 
414   function renounceMinter() public {
415     _removeMinter(msg.sender);
416   }
417 
418   function _addMinter(address account) internal {
419     minters.add(account);
420     emit MinterAdded(account);
421   }
422 
423   function _removeMinter(address account) internal {
424     minters.remove(account);
425     emit MinterRemoved(account);
426   }
427 }
428 
429 
430 
431 /**
432  * @title ERC20Mintable
433  * @dev ERC20 minting logic
434  */
435 contract ERC20Mintable is ERC20, MinterRole {
436   /**
437    * @dev Function to mint tokens
438    * @param to The address that will receive the minted tokens.
439    * @param value The amount of tokens to mint.
440    * @return A boolean that indicates if the operation was successful.
441    */
442   function mint(
443     address to,
444     uint256 value
445   )
446   public
447   onlyMinter
448   returns (bool)
449   {
450     _mint(to, value);
451     return true;
452   }
453 }
454 
455 
456 
457 /**
458  * @title SafeERC20
459  * @dev Wrappers around ERC20 operations that throw on failure.
460  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
461  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
462  */
463 library SafeERC20 {
464   function safeTransfer(
465     IERC20 token,
466     address to,
467     uint256 value
468   )
469   internal
470   {
471     require(token.transfer(to, value));
472   }
473 
474   function safeTransferFrom(
475     IERC20 token,
476     address from,
477     address to,
478     uint256 value
479   )
480   internal
481   {
482     require(token.transferFrom(from, to, value));
483   }
484 
485   function safeApprove(
486     IERC20 token,
487     address spender,
488     uint256 value
489   )
490   internal
491   {
492     require(token.approve(spender, value));
493   }
494 }
495 
496 
497 
498 /**
499  * @title Crowdsale
500  * @dev Crowdsale is a base contract for managing a token crowdsale,
501  * allowing players to purchase tokens with ether. This contract implements
502  * such functionality in its most fundamental form and can be extended to provide additional
503  * functionality and/or custom behavior.
504  * The external interface represents the basic interface for purchasing tokens, and conform
505  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
506  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
507  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
508  * behavior.
509  */
510 contract Crowdsale {
511   using SafeMath for uint256;
512   using SafeERC20 for IERC20;
513 
514   // The token being sold
515   IERC20 private _token;
516 
517   // Address where funds are collected
518   address private _wallet;
519 
520   // How many token units a buyer gets per wei.
521   // The rate is the conversion between wei and the smallest and indivisible token unit.
522   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
523   // 1 wei will give you 1 unit, or 0.001 TOK.
524   uint256 private _rate;
525 
526   // Amount of wei raised
527   uint256 private _weiRaised;
528 
529   /**
530   * Event for token purchase logging
531   * @param purchaser who paid for the tokens
532   * @param beneficiary who got the tokens
533   * @param value weis paid for purchase
534   * @param amount amount of tokens purchased
535    */
536   event TokensPurchased(
537     address indexed purchaser,
538     address indexed beneficiary,
539     uint256 value,
540     uint256 amount
541   );
542 
543   /**
544    * @param rate Number of token units a buyer gets per wei
545    * @dev The rate is the conversion between wei and the smallest and indivisible
546    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
547    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
548    * @param wallet Address where collected funds will be forwarded to
549    * @param token Address of the token being sold
550    */
551   constructor(uint256 rate, address wallet, IERC20 token) public {
552     require(rate > 0);
553     require(wallet != address(0));
554     require(token != address(0));
555 
556     _rate = rate;
557     _wallet = wallet;
558     _token = token;
559   }
560 
561   // -----------------------------------------
562   // Crowdsale external interface
563   // -----------------------------------------
564 
565   /**
566    * @dev fallback function ***DO NOT OVERRIDE***
567    */
568   function () external payable {
569     buyTokens(msg.sender);
570   }
571 
572   /**
573    * @return the token being sold.
574    */
575   function token() public view returns(IERC20) {
576     return _token;
577   }
578 
579   /**
580    * @return the address where funds are collected.
581    */
582   function wallet() public view returns(address) {
583     return _wallet;
584   }
585 
586   /**
587    * @return the number of token units a buyer gets per wei.
588    */
589   function rate() public view returns(uint256) {
590     return _rate;
591   }
592 
593   /**
594    * @return the mount of wei raised.
595    */
596   function weiRaised() public view returns (uint256) {
597     return _weiRaised;
598   }
599 
600   /**
601    * @dev low level token purchase ***DO NOT OVERRIDE***
602    * @param beneficiary Address performing the token purchase
603    */
604   function buyTokens(address beneficiary) public payable {
605 
606     uint256 weiAmount = msg.value;
607     _preValidatePurchase(beneficiary, weiAmount);
608 
609     // calculate token amount to be created
610     uint256 tokens = _getTokenAmount(weiAmount);
611 
612     // update state
613     _weiRaised = _weiRaised.add(weiAmount);
614 
615     _processPurchase(beneficiary, tokens);
616     emit TokensPurchased(
617       msg.sender,
618       beneficiary,
619       weiAmount,
620       tokens
621     );
622 
623     _updatePurchasingState(beneficiary, weiAmount);
624 
625     _forwardFunds();
626     _postValidatePurchase(beneficiary, weiAmount);
627   }
628 
629   // -----------------------------------------
630   // Internal interface (extensible)
631   // -----------------------------------------
632 
633   /**
634    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
635    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
636    *   super._preValidatePurchase(beneficiary, weiAmount);
637    *   require(weiRaised().add(weiAmount) <= cap);
638    * @param beneficiary Address performing the token purchase
639    * @param weiAmount Value in wei involved in the purchase
640    */
641   function _preValidatePurchase(
642     address beneficiary,
643     uint256 weiAmount
644   )
645   internal
646   {
647     require(beneficiary != address(0));
648     require(weiAmount != 0);
649   }
650 
651   /**
652   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
653   * @param beneficiary Address performing the token purchase
654   * @param weiAmount Value in wei involved in the purchase
655   */
656   function _postValidatePurchase(
657     address beneficiary,
658     uint256 weiAmount
659   )
660   internal
661   {
662     // optional override
663   }
664 
665   /**
666   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
667   * @param beneficiary Address performing the token purchase
668   * @param tokenAmount Number of tokens to be emitted
669   */
670   function _deliverTokens(
671     address beneficiary,
672     uint256 tokenAmount
673   )
674   internal
675   {
676     _token.safeTransfer(beneficiary, tokenAmount);
677   }
678 
679   /**
680   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
681   * @param beneficiary Address receiving the tokens
682   * @param tokenAmount Number of tokens to be purchased
683   */
684   function _processPurchase(
685     address beneficiary,
686     uint256 tokenAmount
687   )
688   internal
689   {
690     _deliverTokens(beneficiary, tokenAmount);
691   }
692 
693   /**
694   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
695   * @param beneficiary Address receiving the tokens
696   * @param weiAmount Value in wei involved in the purchase
697    */
698   function _updatePurchasingState(
699     address beneficiary,
700     uint256 weiAmount
701   )
702   internal
703   {
704     // optional override
705   }
706 
707   /**
708   * @dev Override to extend the way in which ether is converted to tokens.
709   * @param weiAmount Value in wei to be converted into tokens
710   * @return Number of tokens that can be purchased with the specified _weiAmount
711    */
712   function _getTokenAmount(uint256 weiAmount)
713   internal view returns (uint256)
714   {
715     return weiAmount.mul(_rate);
716   }
717 
718   /**
719    * @dev Determines how ETH is stored/forwarded on purchases.
720    */
721   function _forwardFunds() internal {
722     _wallet.transfer(msg.value);
723   }
724 }
725 
726 
727 
728 /**
729  * @title TimedCrowdsale
730  * @dev Crowdsale accepting contributions only within a time frame.
731  */
732 contract TimedCrowdsale is Crowdsale {
733   using SafeMath for uint256;
734 
735   uint256 private _openingTime;
736   uint256 internal _closingTime;
737 
738   /**
739    * @dev Reverts if not in crowdsale time range.
740    */
741   modifier onlyWhileOpen {
742     require(isOpen(), "Crowdsale is no longer open");
743     _;
744   }
745 
746   /**
747    * @dev Constructor, takes crowdsale opening and closing times.
748    * @param openingTime Crowdsale opening time
749    * @param closingTime Crowdsale closing time
750    */
751   constructor(uint256 openingTime, uint256 closingTime) public {
752     // solium-disable-next-line security/no-block-members
753     require(openingTime >= block.timestamp, "The Crowdsale must not start in the past");
754     require(closingTime >= openingTime, "The Crowdsale must end in the future");
755 
756     _openingTime = openingTime;
757     _closingTime = closingTime;
758   }
759 
760   /**
761    * @return the crowdsale opening time.
762    */
763   function openingTime() public view returns(uint256) {
764     return _openingTime;
765   }
766 
767   /**
768    * @return the crowdsale closing time.
769    */
770   function closingTime() public view returns(uint256) {
771     return _closingTime;
772   }
773 
774   /**
775    * @return true if the crowdsale is open, false otherwise.
776    */
777   function isOpen() public view returns (bool) {
778     // solium-disable-next-line security/no-block-members
779     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
780   }
781 
782   /**
783    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
784    * @return Whether crowdsale period has elapsed
785    */
786   function hasClosed() public view returns (bool) {
787     // solium-disable-next-line security/no-block-members
788     return block.timestamp > _closingTime;
789   }
790 
791   /**
792    * @dev Extend parent behavior requiring to be within contributing period
793    * @param beneficiary Token purchaser
794    * @param weiAmount Amount of wei contributed
795    */
796   function _preValidatePurchase(
797     address beneficiary,
798     uint256 weiAmount
799   )
800   internal
801   onlyWhileOpen
802   {
803     super._preValidatePurchase(beneficiary, weiAmount);
804   }
805 
806 }
807 
808 
809 
810 /**
811  * @title TimedCrowdsale
812  * @dev Crowdsale accepting contributions only within a time frame.
813  */
814 contract DeadlineCrowdsale is TimedCrowdsale {
815   constructor(uint256 closingTime) public TimedCrowdsale(block.timestamp, closingTime) { }
816 }
817 
818 
819 
820 /**
821  * @title MintedCrowdsale
822  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
823  * Token ownership should be transferred to MintedCrowdsale for minting.
824  */
825 contract MintedCrowdsale is Crowdsale {
826 
827   /**
828    * @dev Overrides delivery by minting tokens upon purchase.
829    * @param beneficiary Token purchaser
830    * @param tokenAmount Number of tokens to be minted
831    */
832   function _deliverTokens(
833     address beneficiary,
834     uint256 tokenAmount
835   )
836   internal
837   {
838     // Potentially dangerous assumption about the type of the token.
839     require(
840       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
841   }
842 }
843 
844 
845 
846 contract PickFlixToken is ERC20Mintable, DeadlineCrowdsale, MintedCrowdsale {
847 
848   string public name = "";
849   string public symbol = "";
850   string public externalID = "";
851   uint public decimals = 18;
852 
853   constructor(string _name, string _symbol, uint256 _rate, address _wallet, uint _closeDate, string _externalID)
854   public
855   Crowdsale(_rate, _wallet, this)
856   ERC20Mintable()
857   MinterRole(this)
858   DeadlineCrowdsale(_closeDate)  {
859     externalID = _externalID;
860     name = _name;
861     symbol = _symbol;
862   }
863 
864   function closeNow() public {
865     require(msg.sender == wallet(), "Must be the creator to close this token");
866     _closingTime = block.timestamp - 1;
867   }
868 
869   function kill() public {
870     require(msg.sender == wallet(), "Must be the creator to kill this token");
871     require(balanceOf(wallet()) >=  0, "Must have no tokens, or the creator owns all the tokens");
872     selfdestruct(wallet());
873   }
874 }
875 
876 
877 
878 /**
879  * @title Ownable
880  * @dev The Ownable contract has an owner address, and provides basic authorization control
881  * functions, this simplifies the implementation of "user permissions".
882  */
883 contract Ownable {
884   address private _owner;
885 
886   event OwnershipTransferred(
887     address indexed previousOwner,
888     address indexed newOwner
889   );
890 
891   /**
892    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
893    * account.
894    */
895   constructor() public {
896     _owner = msg.sender;
897     emit OwnershipTransferred(address(0), _owner);
898   }
899 
900   /**
901   * @return the address of the owner.
902   */
903   function owner() public view returns(address) {
904     return _owner;
905   }
906 
907   /**
908   * @dev Throws if called by any account other than the owner.
909   */
910   modifier onlyOwner() {
911     require(isOwner(), "Must be owner");
912     _;
913   }
914 
915   /**
916   * @return true if `msg.sender` is the owner of the contract.
917   */
918   function isOwner() public view returns(bool) {
919     return msg.sender == _owner;
920   }
921 
922   /**
923   * @dev Allows the current owner to relinquish control of the contract.
924   * @notice Renouncing to ownership will leave the contract without an owner.
925     * It will not be possible to call the functions with the `onlyOwner`
926   * modifier anymore.
927     */
928   function renounceOwnership() public onlyOwner {
929     emit OwnershipTransferred(_owner, address(0));
930     _owner = address(0);
931   }
932 
933   /**
934    * @dev Allows the current owner to transfer control of the contract to a newOwner.
935    * @param newOwner The address to transfer ownership to.
936    */
937   function transferOwnership(address newOwner) public onlyOwner {
938     _transferOwnership(newOwner);
939   }
940 
941   /**
942    * @dev Transfers control of the contract to a newOwner.
943    * @param newOwner The address to transfer ownership to.
944    */
945   function _transferOwnership(address newOwner) internal {
946     require(newOwner != address(0), "Must provide a valid owner address");
947     emit OwnershipTransferred(_owner, newOwner);
948     _owner = newOwner;
949   }
950 }
951 
952 
953 
954 contract PickflixGameMaster is Ownable {
955   // this library helps protect against overflows for large integers
956   using SafeMath for uint256;
957 
958   // fires off events for receiving and sending Ether
959   event Sent(address indexed payee, uint256 amount, uint256 balance);
960   event Received(address indexed payer, uint256 amount, uint256 balance);
961 
962   string public gameName;
963   uint public openDate;
964   uint public closeDate;
965   bool public gameDone;
966   
967   // create a mapping for box office totals for particular movies
968   // address is the token contract address
969   mapping (address => uint256) public boxOfficeTotals;
970 
971   // let's make a Movie struct to make all of this code cleaner
972   struct Movie {
973     uint256 boxOfficeTotal;
974     uint256 totalPlayerRewards;
975     bool accepted;
976   }
977   // map token addresses to Movie structs
978   mapping (address => Movie) public movies;
979 
980   // count the total number of tokens issued
981   uint256 public tokensIssued = 0; // this number will change
982 
983   // more global variables, for calculating payouts and game results
984   uint256 public oracleFee = 0;
985   uint256 public oracleFeePercent = 0;
986   uint256 public totalPlayerRewards = 0;
987   uint256 public totalBoxOffice = 0;
988 
989 
990   // owner is set to original message sender during contract migration
991   constructor(string _gameName, uint _closeDate, uint _oracleFeePercent) Ownable() public {
992     gameName = _gameName;
993     closeDate = _closeDate;
994     openDate = block.timestamp;
995     gameDone = false;
996     oracleFeePercent = _oracleFeePercent;
997   }
998 
999   /**
1000     * calculate a percentage with parts per notation.
1001     * the value returned will be in terms of 10e precision
1002   */
1003   function percent(uint numerator, uint denominator, uint precision) private pure returns(uint quotient) {
1004     // caution, keep this a private function so the numbers are safe
1005     uint _numerator = (numerator * 10 ** (precision+1));
1006     // with rounding of last digit
1007     uint _quotient = ((_numerator / denominator)) / 10;
1008     return ( _quotient);
1009   }
1010 
1011   /**
1012   * @dev wallet can receive funds.
1013   */
1014   function () public payable {
1015     emit Received(msg.sender, msg.value, address(this).balance);
1016   }
1017 
1018   /**
1019   * @dev wallet can send funds
1020   */
1021   function sendTo(address _payee, uint256 _amount) private {
1022     require(_payee != 0 && _payee != address(this), "Burning tokens and self transfer not allowed");
1023     require(_amount > 0, "Must transfer greater than zero");
1024     _payee.transfer(_amount);
1025     emit Sent(_payee, _amount, address(this).balance);
1026   }
1027 
1028   /**
1029   * @dev function to see the balance of Ether in the wallet
1030   */
1031   function balanceOf() public view returns (uint256) {
1032     return address(this).balance;
1033   }
1034 
1035   /**
1036   * @dev function for the player to cash in tokens
1037   */
1038   function redeemTokens(address _player, address _tokenAddress) public returns (bool success) {
1039     require(acceptedToken(_tokenAddress), "Token must be a registered token");
1040     require(block.timestamp >= closeDate, "Game must be closed");
1041     require(gameDone == true, "Can't redeem tokens until results have been uploaded");
1042     // instantiate a token contract instance from the deployed address
1043     IPickFlixToken _token = IPickFlixToken(_tokenAddress);
1044     // check token allowance player has given to GameMaster contract
1045     uint256 _allowedValue = _token.allowance(_player, address(this));
1046     // transfer tokens to GameMaster
1047     _token.transferFrom(_player, address(this), _allowedValue);
1048     // check balance of tokens actually transfered
1049     uint256 _transferedTokens = _allowedValue;
1050     // calculate the percentage of the total token supply represented by the transfered tokens
1051     uint256 _playerPercentage = percent(_transferedTokens, _token.totalSupply(), 4);
1052     // calculate the particular player's rewards, as a percentage of total player rewards for the movie
1053     uint256 _playerRewards = movies[_tokenAddress].totalPlayerRewards.mul(_playerPercentage).div(10**4);
1054     // pay out ETH to the player
1055     sendTo(_player, _playerRewards);
1056     // return that the function succeeded
1057     return true;
1058   }
1059 
1060   // checks if a token is an accepted game token
1061   function acceptedToken(address _tokenAddress) public view returns (bool) {
1062     return movies[_tokenAddress].accepted;
1063   }
1064 
1065   /**
1066   * @dev functions to calculate game results and payouts
1067   */
1068   function calculateTokensIssued(address _tokenAddress) private view returns (uint256) {
1069     IPickFlixToken _token = IPickFlixToken(_tokenAddress);
1070     return _token.totalSupply();
1071   }
1072 
1073   function closeToken(address _tokenAddress) private {
1074     IPickFlixToken _token = IPickFlixToken(_tokenAddress);
1075     _token.closeNow();
1076   }
1077 
1078   function calculateTokenRate(address _tokenAddress) private view returns (uint256) {
1079     IPickFlixToken _token = IPickFlixToken(_tokenAddress);
1080     return _token.rate();
1081   }
1082 
1083   // "15" in this function means 15%. Change that number to raise or lower
1084   // the oracle fee.
1085   function calculateOracleFee() private view returns (uint256) {
1086     return balanceOf().mul(oracleFeePercent).div(100);
1087   }
1088 
1089   // this calculates how much Ether is available for player rewards
1090   function calculateTotalPlayerRewards() private view returns (uint256) {
1091     return balanceOf().sub(oracleFee);
1092   }
1093 
1094   // this calculates the total box office earnings of all movies in USD
1095   function calculateTotalBoxOffice(uint256[] _boxOfficeTotals) private pure returns (uint256) {
1096     uint256 _totalBoxOffice = 0;
1097     for (uint256 i = 0; i < _boxOfficeTotals.length; i++) {
1098       _totalBoxOffice = _totalBoxOffice.add(_boxOfficeTotals[i]);
1099     }
1100     return _totalBoxOffice;
1101   }
1102 
1103   // this calculates how much Ether to reward for each game token
1104   function calculateTotalPlayerRewardsPerMovie(uint256 _boxOfficeTotal) public view returns (uint256) {
1105     // 234 means 23.4%, using parts-per notation with three decimals of precision
1106     uint256 _boxOfficePercentage = percent(_boxOfficeTotal, totalBoxOffice, 4);
1107     // calculate the Ether rewards available for each movie
1108     uint256 _rewards = totalPlayerRewards.mul(_boxOfficePercentage).div(10**4);
1109     return _rewards;
1110   }
1111 
1112   function calculateRewardPerToken(uint256 _boxOfficeTotal, address tokenAddress) public view returns (uint256) {
1113     IPickFlixToken token = IPickFlixToken(tokenAddress);
1114     uint256 _playerBalance = token.balanceOf(msg.sender);
1115     uint256 _playerPercentage = percent(_playerBalance, token.totalSupply(), 4);
1116     // calculate the particular player's rewards, as a percentage of total player rewards for the movie
1117     uint256 _playerRewards = movies[tokenAddress].totalPlayerRewards.mul(_playerPercentage).div(10**4);
1118     return _playerRewards;
1119   }
1120 
1121   /**
1122   * @dev add box office results and token addresses for the movies, and calculate game results
1123   */
1124   function calculateGameResults(address[] _tokenAddresses, uint256[] _boxOfficeTotals) public onlyOwner {
1125     // check that there are as many box office totals as token addresses
1126     require(_tokenAddresses.length == _boxOfficeTotals.length, "Must have box office results per token");
1127     // calculate Oracle Fee and amount of Ether available for player rewards
1128     require(gameDone == false, "Can only submit results once");
1129     require(block.timestamp >= closeDate, "Game must have ended before results can be entered");
1130     oracleFee = calculateOracleFee();
1131     totalPlayerRewards = calculateTotalPlayerRewards();
1132     totalBoxOffice = calculateTotalBoxOffice(_boxOfficeTotals);
1133 
1134     // create Movies (see: Movie struct) and calculate player rewards
1135     for (uint256 i = 0; i < _tokenAddresses.length; i++) {
1136       tokensIssued = tokensIssued.add(calculateTokensIssued(_tokenAddresses[i]));
1137       movies[_tokenAddresses[i]] = Movie(_boxOfficeTotals[i], calculateTotalPlayerRewardsPerMovie(_boxOfficeTotals[i]), true);
1138     }
1139 
1140     // The owner will be the Factory that deploys this contract.
1141     owner().transfer(oracleFee);
1142     gameDone = true;
1143   }
1144 
1145   /**
1146    * @dev add box office results and token addresses for the movies, and calculate game results
1147    */
1148   function abortGame(address[] _tokenAddresses) public onlyOwner {
1149     // calculate Oracle Fee and amount of Ether available for player rewards
1150     require(gameDone == false, "Can only submit results once");
1151     oracleFee = 0;
1152     totalPlayerRewards = calculateTotalPlayerRewards();
1153     closeDate = block.timestamp;
1154 
1155     for (uint256 i = 0; i < _tokenAddresses.length; i++) {
1156       uint tokenSupply = calculateTokensIssued(_tokenAddresses[i]);
1157       tokensIssued = tokensIssued.add(tokenSupply);
1158       closeToken(_tokenAddresses[i]);
1159     }
1160     totalBoxOffice = tokensIssued;
1161 
1162     // create Movies (see: Movie struct) and calculate player rewards
1163     for (i = 0; i < _tokenAddresses.length; i++) {
1164       tokenSupply = calculateTokensIssued(_tokenAddresses[i]);
1165       movies[_tokenAddresses[i]] = Movie(tokenSupply, calculateTotalPlayerRewardsPerMovie(tokenSupply), true);
1166     }
1167 
1168     gameDone = true;
1169   }
1170 
1171   function killGame(address[] _tokenAddresses) public onlyOwner {
1172     for (uint i = 0; i < _tokenAddresses.length; i++) {
1173       IPickFlixToken token = IPickFlixToken(_tokenAddresses[i]);
1174       require(token.balanceOf(this) == token.totalSupply());
1175       token.kill();
1176     }
1177     selfdestruct(owner());
1178   }
1179 }
1180 
1181 
1182 
1183 //The contract in charge of creating games
1184 contract PickflixGameFactory {
1185 
1186   struct Game {
1187     string gameName;
1188     address gameMaster;
1189     uint openDate;
1190     uint closeDate;
1191   }
1192 
1193   // The list of all games this factory has created
1194   Game[] public games;
1195 
1196   // Each game master has a list of tokens
1197   mapping(address => address[]) public gameTokens;
1198 
1199   // The owner of the factory, i.e. GoBlock
1200   address public owner;
1201 
1202   // The address which will receive the oracle fee
1203   address public oracleFeeReceiver;
1204 
1205   // An event emitted when the oracle fee is received
1206   event OraclePayoutReceived(uint value);
1207 
1208   constructor() public {
1209     owner = msg.sender;
1210     oracleFeeReceiver = msg.sender;
1211   }
1212 
1213   function () public payable {
1214     emit OraclePayoutReceived(msg.value);
1215   }
1216 
1217   // Throw an error if the sender is not the owner
1218   modifier onlyOwner {
1219     require(msg.sender == owner, "Only owner can execute this");
1220     _;
1221   }
1222 
1223   // Create a new game master and add it to the factories game list
1224   function createGame(string gameName, uint closeDate, uint oracleFeePercent) public onlyOwner returns (address){
1225     address gameMaster = new PickflixGameMaster(gameName, closeDate, oracleFeePercent);
1226     games.push(Game({
1227       gameName: gameName,
1228       gameMaster: gameMaster,
1229       openDate: block.timestamp,
1230       closeDate: closeDate
1231     }));
1232     return gameMaster;
1233   }
1234 
1235   // Create a token and associate it with a game
1236   function createTokenForGame(uint gameIndex, string tokenName, string tokenSymbol, uint rate, string externalID) public onlyOwner returns (address) {
1237     Game storage game = games[gameIndex];
1238     address token = new PickFlixToken(tokenName, tokenSymbol, rate, game.gameMaster, game.closeDate, externalID);
1239     gameTokens[game.gameMaster].push(token);
1240     return token;
1241   }
1242 
1243   // Upload the results for a game
1244   function closeGame(uint gameIndex, address[] _tokenAddresses, uint256[] _boxOfficeTotals) public onlyOwner {
1245     PickflixGameMaster(games[gameIndex].gameMaster).calculateGameResults(_tokenAddresses, _boxOfficeTotals);
1246   }
1247 
1248   // Cancel a game and refund participants
1249   function abortGame(uint gameIndex) public onlyOwner {
1250     address gameMaster = games[gameIndex].gameMaster;
1251     PickflixGameMaster(gameMaster).abortGame(gameTokens[gameMaster]);
1252   }
1253 
1254   // Delete a game from the factory
1255   function killGame(uint gameIndex) public onlyOwner {
1256     address gameMaster = games[gameIndex].gameMaster;
1257     PickflixGameMaster(gameMaster).killGame(gameTokens[gameMaster]);
1258     games[gameIndex] = games[games.length-1];
1259     delete games[games.length-1];
1260     games.length--;
1261   }
1262 
1263   // Change the owner address
1264   function setOwner(address newOwner) public onlyOwner {
1265     owner = newOwner;
1266   }
1267 
1268   // Change the address that receives the oracle fee
1269   function setOracleFeeReceiver(address newReceiver) public onlyOwner {
1270     oracleFeeReceiver = newReceiver;
1271   }
1272 
1273   // Send the ether to the oracle fee receiver
1274   function sendOraclePayout() public {
1275     oracleFeeReceiver.transfer(address(this).balance);
1276   }
1277 }