1 pragma solidity ^0.4.13;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an account access to this role
10    */
11   function add(Role storage role, address account) internal {
12     require(account != address(0));
13     role.bearer[account] = true;
14   }
15 
16   /**
17    * @dev remove an account's access to this role
18    */
19   function remove(Role storage role, address account) internal {
20     require(account != address(0));
21     role.bearer[account] = false;
22   }
23 
24   /**
25    * @dev check if an account has this role
26    * @return bool
27    */
28   function has(Role storage role, address account)
29     internal
30     view
31     returns (bool)
32   {
33     require(account != address(0));
34     return role.bearer[account];
35   }
36 }
37 
38 contract CapperRole {
39   using Roles for Roles.Role;
40 
41   event CapperAdded(address indexed account);
42   event CapperRemoved(address indexed account);
43 
44   Roles.Role private cappers;
45 
46   constructor() public {
47     cappers.add(msg.sender);
48   }
49 
50   modifier onlyCapper() {
51     require(isCapper(msg.sender));
52     _;
53   }
54 
55   function isCapper(address account) public view returns (bool) {
56     return cappers.has(account);
57   }
58 
59   function addCapper(address account) public onlyCapper {
60     cappers.add(account);
61     emit CapperAdded(account);
62   }
63 
64   function renounceCapper() public {
65     cappers.remove(msg.sender);
66   }
67 
68   function _removeCapper(address account) internal {
69     cappers.remove(account);
70     emit CapperRemoved(account);
71   }
72 }
73 
74 contract MinterRole {
75   using Roles for Roles.Role;
76 
77   event MinterAdded(address indexed account);
78   event MinterRemoved(address indexed account);
79 
80   Roles.Role private minters;
81 
82   constructor() public {
83     minters.add(msg.sender);
84   }
85 
86   modifier onlyMinter() {
87     require(isMinter(msg.sender));
88     _;
89   }
90 
91   function isMinter(address account) public view returns (bool) {
92     return minters.has(account);
93   }
94 
95   function addMinter(address account) public onlyMinter {
96     minters.add(account);
97     emit MinterAdded(account);
98   }
99 
100   function renounceMinter() public {
101     minters.remove(msg.sender);
102   }
103 
104   function _removeMinter(address account) internal {
105     minters.remove(account);
106     emit MinterRemoved(account);
107   }
108 }
109 
110 contract Crowdsale {
111   using SafeMath for uint256;
112   using SafeERC20 for IERC20;
113 
114   // The token being sold
115   IERC20 private _token;
116 
117   // Address where funds are collected
118   address private _wallet;
119 
120   // How many token units a buyer gets per wei.
121   // The rate is the conversion between wei and the smallest and indivisible token unit.
122   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
123   // 1 wei will give you 1 unit, or 0.001 TOK.
124   uint256 private _rate;
125 
126   // Amount of wei raised
127   uint256 private _weiRaised;
128 
129   /**
130    * Event for token purchase logging
131    * @param purchaser who paid for the tokens
132    * @param beneficiary who got the tokens
133    * @param value weis paid for purchase
134    * @param amount amount of tokens purchased
135    */
136   event TokensPurchased(
137     address indexed purchaser,
138     address indexed beneficiary,
139     uint256 value,
140     uint256 amount
141   );
142 
143   /**
144    * @param rate Number of token units a buyer gets per wei
145    * @dev The rate is the conversion between wei and the smallest and indivisible
146    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
147    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
148    * @param wallet Address where collected funds will be forwarded to
149    * @param token Address of the token being sold
150    */
151   constructor(uint256 rate, address wallet, IERC20 token) public {
152     require(rate > 0);
153     require(wallet != address(0));
154     require(token != address(0));
155 
156     _rate = rate;
157     _wallet = wallet;
158     _token = token;
159   }
160 
161   // -----------------------------------------
162   // Crowdsale external interface
163   // -----------------------------------------
164 
165   /**
166    * @dev fallback function ***DO NOT OVERRIDE***
167    */
168   function () external payable {
169     buyTokens(msg.sender);
170   }
171 
172   /**
173    * @return the token being sold.
174    */
175   function token() public view returns(IERC20) {
176     return _token;
177   }
178 
179   /**
180    * @return the address where funds are collected.
181    */
182   function wallet() public view returns(address) {
183     return _wallet;
184   }
185 
186   /**
187    * @return the number of token units a buyer gets per wei.
188    */
189   function rate() public view returns(uint256) {
190     return _rate;
191   }
192 
193   /**
194    * @return the mount of wei raised.
195    */
196   function weiRaised() public view returns (uint256) {
197     return _weiRaised;
198   }
199 
200   /**
201    * @dev low level token purchase ***DO NOT OVERRIDE***
202    * @param beneficiary Address performing the token purchase
203    */
204   function buyTokens(address beneficiary) public payable {
205 
206     uint256 weiAmount = msg.value;
207     _preValidatePurchase(beneficiary, weiAmount);
208 
209     // calculate token amount to be created
210     uint256 tokens = _getTokenAmount(weiAmount);
211 
212     // update state
213     _weiRaised = _weiRaised.add(weiAmount);
214 
215     _processPurchase(beneficiary, tokens);
216     emit TokensPurchased(
217       msg.sender,
218       beneficiary,
219       weiAmount,
220       tokens
221     );
222 
223     _updatePurchasingState(beneficiary, weiAmount);
224 
225     _forwardFunds();
226     _postValidatePurchase(beneficiary, weiAmount);
227   }
228 
229   // -----------------------------------------
230   // Internal interface (extensible)
231   // -----------------------------------------
232 
233   /**
234    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
235    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
236    *   super._preValidatePurchase(beneficiary, weiAmount);
237    *   require(weiRaised().add(weiAmount) <= cap);
238    * @param beneficiary Address performing the token purchase
239    * @param weiAmount Value in wei involved in the purchase
240    */
241   function _preValidatePurchase(
242     address beneficiary,
243     uint256 weiAmount
244   )
245     internal
246   {
247     require(beneficiary != address(0));
248     require(weiAmount != 0);
249   }
250 
251   /**
252    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
253    * @param beneficiary Address performing the token purchase
254    * @param weiAmount Value in wei involved in the purchase
255    */
256   function _postValidatePurchase(
257     address beneficiary,
258     uint256 weiAmount
259   )
260     internal
261   {
262     // optional override
263   }
264 
265   /**
266    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
267    * @param beneficiary Address performing the token purchase
268    * @param tokenAmount Number of tokens to be emitted
269    */
270   function _deliverTokens(
271     address beneficiary,
272     uint256 tokenAmount
273   )
274     internal
275   {
276     _token.safeTransfer(beneficiary, tokenAmount);
277   }
278 
279   /**
280    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
281    * @param beneficiary Address receiving the tokens
282    * @param tokenAmount Number of tokens to be purchased
283    */
284   function _processPurchase(
285     address beneficiary,
286     uint256 tokenAmount
287   )
288     internal
289   {
290     _deliverTokens(beneficiary, tokenAmount);
291   }
292 
293   /**
294    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
295    * @param beneficiary Address receiving the tokens
296    * @param weiAmount Value in wei involved in the purchase
297    */
298   function _updatePurchasingState(
299     address beneficiary,
300     uint256 weiAmount
301   )
302     internal
303   {
304     // optional override
305   }
306 
307   /**
308    * @dev Override to extend the way in which ether is converted to tokens.
309    * @param weiAmount Value in wei to be converted into tokens
310    * @return Number of tokens that can be purchased with the specified _weiAmount
311    */
312   function _getTokenAmount(uint256 weiAmount)
313     internal view returns (uint256)
314   {
315     return weiAmount.mul(_rate);
316   }
317 
318   /**
319    * @dev Determines how ETH is stored/forwarded on purchases.
320    */
321   function _forwardFunds() internal {
322     _wallet.transfer(msg.value);
323   }
324 }
325 
326 contract MintedCrowdsale is Crowdsale {
327 
328   /**
329    * @dev Overrides delivery by minting tokens upon purchase.
330    * @param beneficiary Token purchaser
331    * @param tokenAmount Number of tokens to be minted
332    */
333   function _deliverTokens(
334     address beneficiary,
335     uint256 tokenAmount
336   )
337     internal
338   {
339     // Potentially dangerous assumption about the type of the token.
340     require(
341       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
342   }
343 }
344 
345 contract CappedCrowdsale is Crowdsale {
346   using SafeMath for uint256;
347 
348   uint256 private _cap;
349 
350   /**
351    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
352    * @param cap Max amount of wei to be contributed
353    */
354   constructor(uint256 cap) public {
355     require(cap > 0);
356     _cap = cap;
357   }
358 
359   /**
360    * @return the cap of the crowdsale.
361    */
362   function cap() public view returns(uint256) {
363     return _cap;
364   }
365 
366   /**
367    * @dev Checks whether the cap has been reached.
368    * @return Whether the cap was reached
369    */
370   function capReached() public view returns (bool) {
371     return weiRaised() >= _cap;
372   }
373 
374   /**
375    * @dev Extend parent behavior requiring purchase to respect the funding cap.
376    * @param beneficiary Token purchaser
377    * @param weiAmount Amount of wei contributed
378    */
379   function _preValidatePurchase(
380     address beneficiary,
381     uint256 weiAmount
382   )
383     internal
384   {
385     super._preValidatePurchase(beneficiary, weiAmount);
386     require(weiRaised().add(weiAmount) <= _cap);
387   }
388 
389 }
390 
391 contract IndividuallyCappedCrowdsale is Crowdsale, CapperRole {
392   using SafeMath for uint256;
393 
394   mapping(address => uint256) private _contributions;
395   mapping(address => uint256) private _caps;
396 
397   /**
398    * @dev Sets a specific beneficiary's maximum contribution.
399    * @param beneficiary Address to be capped
400    * @param cap Wei limit for individual contribution
401    */
402   function setCap(address beneficiary, uint256 cap) external onlyCapper {
403     _caps[beneficiary] = cap;
404   }
405 
406   /**
407    * @dev Returns the cap of a specific beneficiary.
408    * @param beneficiary Address whose cap is to be checked
409    * @return Current cap for individual beneficiary
410    */
411   function getCap(address beneficiary) public view returns (uint256) {
412     return _caps[beneficiary];
413   }
414 
415   /**
416    * @dev Returns the amount contributed so far by a specific beneficiary.
417    * @param beneficiary Address of contributor
418    * @return Beneficiary contribution so far
419    */
420   function getContribution(address beneficiary)
421     public view returns (uint256)
422   {
423     return _contributions[beneficiary];
424   }
425 
426   /**
427    * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
428    * @param beneficiary Token purchaser
429    * @param weiAmount Amount of wei contributed
430    */
431   function _preValidatePurchase(
432     address beneficiary,
433     uint256 weiAmount
434   )
435     internal
436   {
437     super._preValidatePurchase(beneficiary, weiAmount);
438     require(
439       _contributions[beneficiary].add(weiAmount) <= _caps[beneficiary]);
440   }
441 
442   /**
443    * @dev Extend parent behavior to update beneficiary contributions
444    * @param beneficiary Token purchaser
445    * @param weiAmount Amount of wei contributed
446    */
447   function _updatePurchasingState(
448     address beneficiary,
449     uint256 weiAmount
450   )
451     internal
452   {
453     super._updatePurchasingState(beneficiary, weiAmount);
454     _contributions[beneficiary] = _contributions[beneficiary].add(
455       weiAmount);
456   }
457 
458 }
459 
460 contract TimedCrowdsale is Crowdsale {
461   using SafeMath for uint256;
462 
463   uint256 private _openingTime;
464   uint256 private _closingTime;
465 
466   /**
467    * @dev Reverts if not in crowdsale time range.
468    */
469   modifier onlyWhileOpen {
470     require(isOpen());
471     _;
472   }
473 
474   /**
475    * @dev Constructor, takes crowdsale opening and closing times.
476    * @param openingTime Crowdsale opening time
477    * @param closingTime Crowdsale closing time
478    */
479   constructor(uint256 openingTime, uint256 closingTime) public {
480     // solium-disable-next-line security/no-block-members
481     require(openingTime >= block.timestamp);
482     require(closingTime >= openingTime);
483 
484     _openingTime = openingTime;
485     _closingTime = closingTime;
486   }
487 
488   /**
489    * @return the crowdsale opening time.
490    */
491   function openingTime() public view returns(uint256) {
492     return _openingTime;
493   }
494 
495   /**
496    * @return the crowdsale closing time.
497    */
498   function closingTime() public view returns(uint256) {
499     return _closingTime;
500   }
501 
502   /**
503    * @return true if the crowdsale is open, false otherwise.
504    */
505   function isOpen() public view returns (bool) {
506     // solium-disable-next-line security/no-block-members
507     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
508   }
509 
510   /**
511    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
512    * @return Whether crowdsale period has elapsed
513    */
514   function hasClosed() public view returns (bool) {
515     // solium-disable-next-line security/no-block-members
516     return block.timestamp > _closingTime;
517   }
518 
519   /**
520    * @dev Extend parent behavior requiring to be within contributing period
521    * @param beneficiary Token purchaser
522    * @param weiAmount Amount of wei contributed
523    */
524   function _preValidatePurchase(
525     address beneficiary,
526     uint256 weiAmount
527   )
528     internal
529     onlyWhileOpen
530   {
531     super._preValidatePurchase(beneficiary, weiAmount);
532   }
533 
534 }
535 
536 library SafeMath {
537 
538   /**
539   * @dev Multiplies two numbers, reverts on overflow.
540   */
541   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
542     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
543     // benefit is lost if 'b' is also tested.
544     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
545     if (a == 0) {
546       return 0;
547     }
548 
549     uint256 c = a * b;
550     require(c / a == b);
551 
552     return c;
553   }
554 
555   /**
556   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
557   */
558   function div(uint256 a, uint256 b) internal pure returns (uint256) {
559     require(b > 0); // Solidity only automatically asserts when dividing by 0
560     uint256 c = a / b;
561     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
562 
563     return c;
564   }
565 
566   /**
567   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
568   */
569   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
570     require(b <= a);
571     uint256 c = a - b;
572 
573     return c;
574   }
575 
576   /**
577   * @dev Adds two numbers, reverts on overflow.
578   */
579   function add(uint256 a, uint256 b) internal pure returns (uint256) {
580     uint256 c = a + b;
581     require(c >= a);
582 
583     return c;
584   }
585 
586   /**
587   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
588   * reverts when dividing by zero.
589   */
590   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
591     require(b != 0);
592     return a % b;
593   }
594 }
595 
596 interface IERC20 {
597   function totalSupply() external view returns (uint256);
598 
599   function balanceOf(address who) external view returns (uint256);
600 
601   function allowance(address owner, address spender)
602     external view returns (uint256);
603 
604   function transfer(address to, uint256 value) external returns (bool);
605 
606   function approve(address spender, uint256 value)
607     external returns (bool);
608 
609   function transferFrom(address from, address to, uint256 value)
610     external returns (bool);
611 
612   event Transfer(
613     address indexed from,
614     address indexed to,
615     uint256 value
616   );
617 
618   event Approval(
619     address indexed owner,
620     address indexed spender,
621     uint256 value
622   );
623 }
624 
625 contract ERC20 is IERC20 {
626   using SafeMath for uint256;
627 
628   mapping (address => uint256) private _balances;
629 
630   mapping (address => mapping (address => uint256)) private _allowed;
631 
632   uint256 private _totalSupply;
633 
634   /**
635   * @dev Total number of tokens in existence
636   */
637   function totalSupply() public view returns (uint256) {
638     return _totalSupply;
639   }
640 
641   /**
642   * @dev Gets the balance of the specified address.
643   * @param owner The address to query the the balance of.
644   * @return An uint256 representing the amount owned by the passed address.
645   */
646   function balanceOf(address owner) public view returns (uint256) {
647     return _balances[owner];
648   }
649 
650   /**
651    * @dev Function to check the amount of tokens that an owner allowed to a spender.
652    * @param owner address The address which owns the funds.
653    * @param spender address The address which will spend the funds.
654    * @return A uint256 specifying the amount of tokens still available for the spender.
655    */
656   function allowance(
657     address owner,
658     address spender
659    )
660     public
661     view
662     returns (uint256)
663   {
664     return _allowed[owner][spender];
665   }
666 
667   /**
668   * @dev Transfer token for a specified address
669   * @param to The address to transfer to.
670   * @param value The amount to be transferred.
671   */
672   function transfer(address to, uint256 value) public returns (bool) {
673     require(value <= _balances[msg.sender]);
674     require(to != address(0));
675 
676     _balances[msg.sender] = _balances[msg.sender].sub(value);
677     _balances[to] = _balances[to].add(value);
678     emit Transfer(msg.sender, to, value);
679     return true;
680   }
681 
682   /**
683    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
684    * Beware that changing an allowance with this method brings the risk that someone may use both the old
685    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
686    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
687    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
688    * @param spender The address which will spend the funds.
689    * @param value The amount of tokens to be spent.
690    */
691   function approve(address spender, uint256 value) public returns (bool) {
692     require(spender != address(0));
693 
694     _allowed[msg.sender][spender] = value;
695     emit Approval(msg.sender, spender, value);
696     return true;
697   }
698 
699   /**
700    * @dev Transfer tokens from one address to another
701    * @param from address The address which you want to send tokens from
702    * @param to address The address which you want to transfer to
703    * @param value uint256 the amount of tokens to be transferred
704    */
705   function transferFrom(
706     address from,
707     address to,
708     uint256 value
709   )
710     public
711     returns (bool)
712   {
713     require(value <= _balances[from]);
714     require(value <= _allowed[from][msg.sender]);
715     require(to != address(0));
716 
717     _balances[from] = _balances[from].sub(value);
718     _balances[to] = _balances[to].add(value);
719     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
720     emit Transfer(from, to, value);
721     return true;
722   }
723 
724   /**
725    * @dev Increase the amount of tokens that an owner allowed to a spender.
726    * approve should be called when allowed_[_spender] == 0. To increment
727    * allowed value is better to use this function to avoid 2 calls (and wait until
728    * the first transaction is mined)
729    * From MonolithDAO Token.sol
730    * @param spender The address which will spend the funds.
731    * @param addedValue The amount of tokens to increase the allowance by.
732    */
733   function increaseAllowance(
734     address spender,
735     uint256 addedValue
736   )
737     public
738     returns (bool)
739   {
740     require(spender != address(0));
741 
742     _allowed[msg.sender][spender] = (
743       _allowed[msg.sender][spender].add(addedValue));
744     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
745     return true;
746   }
747 
748   /**
749    * @dev Decrease the amount of tokens that an owner allowed to a spender.
750    * approve should be called when allowed_[_spender] == 0. To decrement
751    * allowed value is better to use this function to avoid 2 calls (and wait until
752    * the first transaction is mined)
753    * From MonolithDAO Token.sol
754    * @param spender The address which will spend the funds.
755    * @param subtractedValue The amount of tokens to decrease the allowance by.
756    */
757   function decreaseAllowance(
758     address spender,
759     uint256 subtractedValue
760   )
761     public
762     returns (bool)
763   {
764     require(spender != address(0));
765 
766     _allowed[msg.sender][spender] = (
767       _allowed[msg.sender][spender].sub(subtractedValue));
768     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
769     return true;
770   }
771 
772   /**
773    * @dev Internal function that mints an amount of the token and assigns it to
774    * an account. This encapsulates the modification of balances such that the
775    * proper events are emitted.
776    * @param account The account that will receive the created tokens.
777    * @param amount The amount that will be created.
778    */
779   function _mint(address account, uint256 amount) internal {
780     require(account != 0);
781     _totalSupply = _totalSupply.add(amount);
782     _balances[account] = _balances[account].add(amount);
783     emit Transfer(address(0), account, amount);
784   }
785 
786   /**
787    * @dev Internal function that burns an amount of the token of a given
788    * account.
789    * @param account The account whose tokens will be burnt.
790    * @param amount The amount that will be burnt.
791    */
792   function _burn(address account, uint256 amount) internal {
793     require(account != 0);
794     require(amount <= _balances[account]);
795 
796     _totalSupply = _totalSupply.sub(amount);
797     _balances[account] = _balances[account].sub(amount);
798     emit Transfer(account, address(0), amount);
799   }
800 
801   /**
802    * @dev Internal function that burns an amount of the token of a given
803    * account, deducting from the sender's allowance for said account. Uses the
804    * internal burn function.
805    * @param account The account whose tokens will be burnt.
806    * @param amount The amount that will be burnt.
807    */
808   function _burnFrom(address account, uint256 amount) internal {
809     require(amount <= _allowed[account][msg.sender]);
810 
811     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
812     // this function needs to emit an event with the updated approval.
813     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
814       amount);
815     _burn(account, amount);
816   }
817 }
818 
819 contract ERC20Mintable is ERC20, MinterRole {
820   event MintingFinished();
821 
822   bool private _mintingFinished = false;
823 
824   modifier onlyBeforeMintingFinished() {
825     require(!_mintingFinished);
826     _;
827   }
828 
829   /**
830    * @return true if the minting is finished.
831    */
832   function mintingFinished() public view returns(bool) {
833     return _mintingFinished;
834   }
835 
836   /**
837    * @dev Function to mint tokens
838    * @param to The address that will receive the minted tokens.
839    * @param amount The amount of tokens to mint.
840    * @return A boolean that indicates if the operation was successful.
841    */
842   function mint(
843     address to,
844     uint256 amount
845   )
846     public
847     onlyMinter
848     onlyBeforeMintingFinished
849     returns (bool)
850   {
851     _mint(to, amount);
852     return true;
853   }
854 
855   /**
856    * @dev Function to stop minting new tokens.
857    * @return True if the operation was successful.
858    */
859   function finishMinting()
860     public
861     onlyMinter
862     onlyBeforeMintingFinished
863     returns (bool)
864   {
865     _mintingFinished = true;
866     emit MintingFinished();
867     return true;
868   }
869 }
870 
871 library SafeERC20 {
872   function safeTransfer(
873     IERC20 token,
874     address to,
875     uint256 value
876   )
877     internal
878   {
879     require(token.transfer(to, value));
880   }
881 
882   function safeTransferFrom(
883     IERC20 token,
884     address from,
885     address to,
886     uint256 value
887   )
888     internal
889   {
890     require(token.transferFrom(from, to, value));
891   }
892 
893   function safeApprove(
894     IERC20 token,
895     address spender,
896     uint256 value
897   )
898     internal
899   {
900     require(token.approve(spender, value));
901   }
902 }
903 
904 contract BoltCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale,
905   TimedCrowdsale, IndividuallyCappedCrowdsale {
906     constructor(
907         uint256 rate,         // rate, in BOLTbits to wei
908         address wallet,       // wallet to send Ether to
909         ERC20 token,          // the token
910         uint256 cap,          // total cap, in wei
911         uint256 openingTime,  // opening time in unix epoch seconds
912         uint256 closingTime   // closing time in unix epoch seconds
913     )
914         MintedCrowdsale()
915         IndividuallyCappedCrowdsale()
916         TimedCrowdsale(openingTime, closingTime)
917         CappedCrowdsale(cap)
918         Crowdsale(rate, wallet, token)
919         public
920     {}
921 }