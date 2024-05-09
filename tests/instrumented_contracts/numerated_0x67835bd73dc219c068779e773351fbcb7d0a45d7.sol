1 pragma solidity ^0.4.25;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b > 0); // Solidity only automatically asserts when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b <= a);
37     uint256 c = a - b;
38 
39     return c;
40   }
41 
42   /**
43   * @dev Adds two numbers, reverts on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     require(c >= a);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54   * reverts when dividing by zero.
55   */
56   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b != 0);
58     return a % b;
59   }
60 }
61 
62 interface IERC20 {
63   function totalSupply() external view returns (uint256);
64 
65   function balanceOf(address who) external view returns (uint256);
66 
67   function allowance(address owner, address spender)
68     external view returns (uint256);
69 
70   function transfer(address to, uint256 value) external returns (bool);
71 
72   function approve(address spender, uint256 value)
73     external returns (bool);
74 
75   function transferFrom(address from, address to, uint256 value)
76     external returns (bool);
77 
78   event Transfer(
79     address indexed from,
80     address indexed to,
81     uint256 value
82   );
83 
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 library Roles {
92   struct Role {
93     mapping (address => bool) bearer;
94   }
95 
96   /**
97    * @dev give an account access to this role
98    */
99   function add(Role storage role, address account) internal {
100     require(account != address(0));
101     role.bearer[account] = true;
102   }
103 
104   /**
105    * @dev remove an account's access to this role
106    */
107   function remove(Role storage role, address account) internal {
108     require(account != address(0));
109     role.bearer[account] = false;
110   }
111 
112   /**
113    * @dev check if an account has this role
114    * @return bool
115    */
116   function has(Role storage role, address account)
117     internal
118     view
119     returns (bool)
120   {
121     require(account != address(0));
122     return role.bearer[account];
123   }
124 }
125 
126 contract MinterRole {
127   using Roles for Roles.Role;
128 
129   event MinterAdded(address indexed account);
130   event MinterRemoved(address indexed account);
131 
132   Roles.Role private minters;
133 
134   constructor() public {
135     minters.add(msg.sender);
136   }
137 
138   modifier onlyMinter() {
139     require(isMinter(msg.sender));
140     _;
141   }
142 
143   function isMinter(address account) public view returns (bool) {
144     return minters.has(account);
145   }
146 
147   function addMinter(address account) public onlyMinter {
148     minters.add(account);
149     emit MinterAdded(account);
150   }
151 
152   function renounceMinter() public {
153     minters.remove(msg.sender);
154   }
155 
156   function _removeMinter(address account) internal {
157     minters.remove(account);
158     emit MinterRemoved(account);
159   }
160 }
161 
162 contract CapperRole {
163   using Roles for Roles.Role;
164 
165   event CapperAdded(address indexed account);
166   event CapperRemoved(address indexed account);
167 
168   Roles.Role private cappers;
169 
170   constructor() public {
171     cappers.add(msg.sender);
172   }
173 
174   modifier onlyCapper() {
175     require(isCapper(msg.sender));
176     _;
177   }
178 
179   function isCapper(address account) public view returns (bool) {
180     return cappers.has(account);
181   }
182 
183   function addCapper(address account) public onlyCapper {
184     cappers.add(account);
185     emit CapperAdded(account);
186   }
187 
188   function renounceCapper() public {
189     cappers.remove(msg.sender);
190   }
191 
192   function _removeCapper(address account) internal {
193     cappers.remove(account);
194     emit CapperRemoved(account);
195   }
196 }
197 
198 contract ERC20 is IERC20 {
199   using SafeMath for uint256;
200 
201   mapping (address => uint256) private _balances;
202 
203   mapping (address => mapping (address => uint256)) private _allowed;
204 
205   uint256 private _totalSupply;
206 
207   /**
208   * @dev Total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return _totalSupply;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address owner) public view returns (uint256) {
220     return _balances[owner];
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param owner address The address which owns the funds.
226    * @param spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(
230     address owner,
231     address spender
232    )
233     public
234     view
235     returns (uint256)
236   {
237     return _allowed[owner][spender];
238   }
239 
240   /**
241   * @dev Transfer token for a specified address
242   * @param to The address to transfer to.
243   * @param value The amount to be transferred.
244   */
245   function transfer(address to, uint256 value) public returns (bool) {
246     require(value <= _balances[msg.sender]);
247     require(to != address(0));
248 
249     _balances[msg.sender] = _balances[msg.sender].sub(value);
250     _balances[to] = _balances[to].add(value);
251     emit Transfer(msg.sender, to, value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param spender The address which will spend the funds.
262    * @param value The amount of tokens to be spent.
263    */
264   function approve(address spender, uint256 value) public returns (bool) {
265     require(spender != address(0));
266 
267     _allowed[msg.sender][spender] = value;
268     emit Approval(msg.sender, spender, value);
269     return true;
270   }
271 
272   /**
273    * @dev Transfer tokens from one address to another
274    * @param from address The address which you want to send tokens from
275    * @param to address The address which you want to transfer to
276    * @param value uint256 the amount of tokens to be transferred
277    */
278   function transferFrom(
279     address from,
280     address to,
281     uint256 value
282   )
283     public
284     returns (bool)
285   {
286     require(value <= _balances[from]);
287     require(value <= _allowed[from][msg.sender]);
288     require(to != address(0));
289 
290     _balances[from] = _balances[from].sub(value);
291     _balances[to] = _balances[to].add(value);
292     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
293     emit Transfer(from, to, value);
294     return true;
295   }
296 
297   /**
298    * @dev Increase the amount of tokens that an owner allowed to a spender.
299    * approve should be called when allowed_[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param spender The address which will spend the funds.
304    * @param addedValue The amount of tokens to increase the allowance by.
305    */
306   function increaseAllowance(
307     address spender,
308     uint256 addedValue
309   )
310     public
311     returns (bool)
312   {
313     require(spender != address(0));
314 
315     _allowed[msg.sender][spender] = (
316       _allowed[msg.sender][spender].add(addedValue));
317     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
318     return true;
319   }
320 
321   /**
322    * @dev Decrease the amount of tokens that an owner allowed to a spender.
323    * approve should be called when allowed_[_spender] == 0. To decrement
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param spender The address which will spend the funds.
328    * @param subtractedValue The amount of tokens to decrease the allowance by.
329    */
330   function decreaseAllowance(
331     address spender,
332     uint256 subtractedValue
333   )
334     public
335     returns (bool)
336   {
337     require(spender != address(0));
338 
339     _allowed[msg.sender][spender] = (
340       _allowed[msg.sender][spender].sub(subtractedValue));
341     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Internal function that mints an amount of the token and assigns it to
347    * an account. This encapsulates the modification of balances such that the
348    * proper events are emitted.
349    * @param account The account that will receive the created tokens.
350    * @param amount The amount that will be created.
351    */
352   function _mint(address account, uint256 amount) internal {
353     require(account != 0);
354     _totalSupply = _totalSupply.add(amount);
355     _balances[account] = _balances[account].add(amount);
356     emit Transfer(address(0), account, amount);
357   }
358 
359   /**
360    * @dev Internal function that burns an amount of the token of a given
361    * account.
362    * @param account The account whose tokens will be burnt.
363    * @param amount The amount that will be burnt.
364    */
365   function _burn(address account, uint256 amount) internal {
366     require(account != 0);
367     require(amount <= _balances[account]);
368 
369     _totalSupply = _totalSupply.sub(amount);
370     _balances[account] = _balances[account].sub(amount);
371     emit Transfer(account, address(0), amount);
372   }
373 
374   /**
375    * @dev Internal function that burns an amount of the token of a given
376    * account, deducting from the sender's allowance for said account. Uses the
377    * internal burn function.
378    * @param account The account whose tokens will be burnt.
379    * @param amount The amount that will be burnt.
380    */
381   function _burnFrom(address account, uint256 amount) internal {
382     require(amount <= _allowed[account][msg.sender]);
383 
384     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
385     // this function needs to emit an event with the updated approval.
386     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
387       amount);
388     _burn(account, amount);
389   }
390 }
391 
392 library SafeERC20 {
393   function safeTransfer(
394     IERC20 token,
395     address to,
396     uint256 value
397   )
398     internal
399   {
400     require(token.transfer(to, value));
401   }
402 
403   function safeTransferFrom(
404     IERC20 token,
405     address from,
406     address to,
407     uint256 value
408   )
409     internal
410   {
411     require(token.transferFrom(from, to, value));
412   }
413 
414   function safeApprove(
415     IERC20 token,
416     address spender,
417     uint256 value
418   )
419     internal
420   {
421     require(token.approve(spender, value));
422   }
423 }
424 
425 contract ERC20Mintable is ERC20, MinterRole {
426   event MintingFinished();
427 
428   bool private _mintingFinished = false;
429 
430   modifier onlyBeforeMintingFinished() {
431     require(!_mintingFinished);
432     _;
433   }
434 
435   /**
436    * @return true if the minting is finished.
437    */
438   function mintingFinished() public view returns(bool) {
439     return _mintingFinished;
440   }
441 
442   /**
443    * @dev Function to mint tokens
444    * @param to The address that will receive the minted tokens.
445    * @param amount The amount of tokens to mint.
446    * @return A boolean that indicates if the operation was successful.
447    */
448   function mint(
449     address to,
450     uint256 amount
451   )
452     public
453     onlyMinter
454     onlyBeforeMintingFinished
455     returns (bool)
456   {
457     _mint(to, amount);
458     return true;
459   }
460 
461   /**
462    * @dev Function to stop minting new tokens.
463    * @return True if the operation was successful.
464    */
465   function finishMinting()
466     public
467     onlyMinter
468     onlyBeforeMintingFinished
469     returns (bool)
470   {
471     _mintingFinished = true;
472     emit MintingFinished();
473     return true;
474   }
475 }
476 
477 contract Crowdsale {
478   using SafeMath for uint256;
479   using SafeERC20 for IERC20;
480 
481   // The token being sold
482   IERC20 private _token;
483 
484   // Address where funds are collected
485   address private _wallet;
486 
487   // How many token units a buyer gets per wei.
488   // The rate is the conversion between wei and the smallest and indivisible token unit.
489   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
490   // 1 wei will give you 1 unit, or 0.001 TOK.
491   uint256 private _rate;
492 
493   // Amount of wei raised
494   uint256 private _weiRaised;
495 
496   /**
497    * Event for token purchase logging
498    * @param purchaser who paid for the tokens
499    * @param beneficiary who got the tokens
500    * @param value weis paid for purchase
501    * @param amount amount of tokens purchased
502    */
503   event TokensPurchased(
504     address indexed purchaser,
505     address indexed beneficiary,
506     uint256 value,
507     uint256 amount
508   );
509 
510   /**
511    * @param rate Number of token units a buyer gets per wei
512    * @dev The rate is the conversion between wei and the smallest and indivisible
513    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
514    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
515    * @param wallet Address where collected funds will be forwarded to
516    * @param token Address of the token being sold
517    */
518   constructor(uint256 rate, address wallet, IERC20 token) public {
519     require(rate > 0);
520     require(wallet != address(0));
521     require(token != address(0));
522 
523     _rate = rate;
524     _wallet = wallet;
525     _token = token;
526   }
527 
528   // -----------------------------------------
529   // Crowdsale external interface
530   // -----------------------------------------
531 
532   /**
533    * @dev fallback function ***DO NOT OVERRIDE***
534    */
535   function () external payable {
536     buyTokens(msg.sender);
537   }
538 
539   /**
540    * @return the token being sold.
541    */
542   function token() public view returns(IERC20) {
543     return _token;
544   }
545 
546   /**
547    * @return the address where funds are collected.
548    */
549   function wallet() public view returns(address) {
550     return _wallet;
551   }
552 
553   /**
554    * @return the number of token units a buyer gets per wei.
555    */
556   function rate() public view returns(uint256) {
557     return _rate;
558   }
559 
560   /**
561    * @return the mount of wei raised.
562    */
563   function weiRaised() public view returns (uint256) {
564     return _weiRaised;
565   }
566 
567   /**
568    * @dev low level token purchase ***DO NOT OVERRIDE***
569    * @param beneficiary Address performing the token purchase
570    */
571   function buyTokens(address beneficiary) public payable {
572 
573     uint256 weiAmount = msg.value;
574     _preValidatePurchase(beneficiary, weiAmount);
575 
576     // calculate token amount to be created
577     uint256 tokens = _getTokenAmount(weiAmount);
578 
579     // update state
580     _weiRaised = _weiRaised.add(weiAmount);
581 
582     _processPurchase(beneficiary, tokens);
583     emit TokensPurchased(
584       msg.sender,
585       beneficiary,
586       weiAmount,
587       tokens
588     );
589 
590     _updatePurchasingState(beneficiary, weiAmount);
591 
592     _forwardFunds();
593     _postValidatePurchase(beneficiary, weiAmount);
594   }
595 
596   // -----------------------------------------
597   // Internal interface (extensible)
598   // -----------------------------------------
599 
600   /**
601    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
602    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
603    *   super._preValidatePurchase(beneficiary, weiAmount);
604    *   require(weiRaised().add(weiAmount) <= cap);
605    * @param beneficiary Address performing the token purchase
606    * @param weiAmount Value in wei involved in the purchase
607    */
608   function _preValidatePurchase(
609     address beneficiary,
610     uint256 weiAmount
611   )
612     internal
613   {
614     require(beneficiary != address(0));
615     require(weiAmount != 0);
616   }
617 
618   /**
619    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
620    * @param beneficiary Address performing the token purchase
621    * @param weiAmount Value in wei involved in the purchase
622    */
623   function _postValidatePurchase(
624     address beneficiary,
625     uint256 weiAmount
626   )
627     internal
628   {
629     // optional override
630   }
631 
632   /**
633    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
634    * @param beneficiary Address performing the token purchase
635    * @param tokenAmount Number of tokens to be emitted
636    */
637   function _deliverTokens(
638     address beneficiary,
639     uint256 tokenAmount
640   )
641     internal
642   {
643     _token.safeTransfer(beneficiary, tokenAmount);
644   }
645 
646   /**
647    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
648    * @param beneficiary Address receiving the tokens
649    * @param tokenAmount Number of tokens to be purchased
650    */
651   function _processPurchase(
652     address beneficiary,
653     uint256 tokenAmount
654   )
655     internal
656   {
657     _deliverTokens(beneficiary, tokenAmount);
658   }
659 
660   /**
661    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
662    * @param beneficiary Address receiving the tokens
663    * @param weiAmount Value in wei involved in the purchase
664    */
665   function _updatePurchasingState(
666     address beneficiary,
667     uint256 weiAmount
668   )
669     internal
670   {
671     // optional override
672   }
673 
674   /**
675    * @dev Override to extend the way in which ether is converted to tokens.
676    * @param weiAmount Value in wei to be converted into tokens
677    * @return Number of tokens that can be purchased with the specified _weiAmount
678    */
679   function _getTokenAmount(uint256 weiAmount)
680     internal view returns (uint256)
681   {
682     return weiAmount.mul(_rate);
683   }
684 
685   /**
686    * @dev Determines how ETH is stored/forwarded on purchases.
687    */
688   function _forwardFunds() internal {
689     _wallet.transfer(msg.value);
690   }
691 }
692 
693 contract TimedCrowdsale is Crowdsale {
694   using SafeMath for uint256;
695 
696   uint256 private _openingTime;
697   uint256 private _closingTime;
698 
699   /**
700    * @dev Reverts if not in crowdsale time range.
701    */
702   modifier onlyWhileOpen {
703     require(isOpen());
704     _;
705   }
706 
707   /**
708    * @dev Constructor, takes crowdsale opening and closing times.
709    * @param openingTime Crowdsale opening time
710    * @param closingTime Crowdsale closing time
711    */
712   constructor(uint256 openingTime, uint256 closingTime) public {
713     // solium-disable-next-line security/no-block-members
714     require(openingTime >= block.timestamp);
715     require(closingTime >= openingTime);
716 
717     _openingTime = openingTime;
718     _closingTime = closingTime;
719   }
720 
721   /**
722    * @return the crowdsale opening time.
723    */
724   function openingTime() public view returns(uint256) {
725     return _openingTime;
726   }
727 
728   /**
729    * @return the crowdsale closing time.
730    */
731   function closingTime() public view returns(uint256) {
732     return _closingTime;
733   }
734 
735   /**
736    * @return true if the crowdsale is open, false otherwise.
737    */
738   function isOpen() public view returns (bool) {
739     // solium-disable-next-line security/no-block-members
740     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
741   }
742 
743   /**
744    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
745    * @return Whether crowdsale period has elapsed
746    */
747   function hasClosed() public view returns (bool) {
748     // solium-disable-next-line security/no-block-members
749     return block.timestamp > _closingTime;
750   }
751 
752   /**
753    * @dev Extend parent behavior requiring to be within contributing period
754    * @param beneficiary Token purchaser
755    * @param weiAmount Amount of wei contributed
756    */
757   function _preValidatePurchase(
758     address beneficiary,
759     uint256 weiAmount
760   )
761     internal
762     onlyWhileOpen
763   {
764     super._preValidatePurchase(beneficiary, weiAmount);
765   }
766 
767 }
768 
769 contract MintedCrowdsale is Crowdsale {
770 
771   /**
772    * @dev Overrides delivery by minting tokens upon purchase.
773    * @param beneficiary Token purchaser
774    * @param tokenAmount Number of tokens to be minted
775    */
776   function _deliverTokens(
777     address beneficiary,
778     uint256 tokenAmount
779   )
780     internal
781   {
782     // Potentially dangerous assumption about the type of the token.
783     require(
784       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
785   }
786 }
787 
788 contract CappedCrowdsale is Crowdsale {
789   using SafeMath for uint256;
790 
791   uint256 private _cap;
792 
793   /**
794    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
795    * @param cap Max amount of wei to be contributed
796    */
797   constructor(uint256 cap) public {
798     require(cap > 0);
799     _cap = cap;
800   }
801 
802   /**
803    * @return the cap of the crowdsale.
804    */
805   function cap() public view returns(uint256) {
806     return _cap;
807   }
808 
809   /**
810    * @dev Checks whether the cap has been reached.
811    * @return Whether the cap was reached
812    */
813   function capReached() public view returns (bool) {
814     return weiRaised() >= _cap;
815   }
816 
817   /**
818    * @dev Extend parent behavior requiring purchase to respect the funding cap.
819    * @param beneficiary Token purchaser
820    * @param weiAmount Amount of wei contributed
821    */
822   function _preValidatePurchase(
823     address beneficiary,
824     uint256 weiAmount
825   )
826     internal
827   {
828     super._preValidatePurchase(beneficiary, weiAmount);
829     require(weiRaised().add(weiAmount) <= _cap);
830   }
831 
832 }
833 
834 contract BoltCrowdsaleTwo is Crowdsale, CappedCrowdsale, TimedCrowdsale, CapperRole {
835   using SafeMath for uint256;
836 
837   // Individual contribution amounts and caps
838   mapping(address => uint256) private _contributions;
839   mapping(address => uint256) private _caps;
840 
841   // Bonus tokens locked in this contract
842   mapping(address => uint256) private _lockedTokens;
843   uint256 private _bonusAvailableUntil;
844   uint256 private _bonusUnlockTime;
845 
846   constructor(
847       uint256 rate,               // rate, in BOLTbits to wei
848       address wallet,             // wallet to send Ether to
849       ERC20 token,                // the token
850       uint256 cap,                // total cap, in wei
851       uint256 openingTime,        // opening time in unix epoch seconds
852       uint256 closingTime,        // closing time in unix epoch seconds
853       uint256 bonusUnlockTime,    // unlocking time for bonus tokens in unix epoch seconds
854       uint256 bonusAvailableUntil // cutoff time for bonus tokens to be issued when minting
855   )
856       CapperRole()
857       TimedCrowdsale(openingTime, closingTime)
858       CappedCrowdsale(cap)
859       Crowdsale(rate, wallet, token)
860       public
861   {
862     require(
863       bonusUnlockTime > closingTime,
864       "Cannot unlock bonus tokens before crowdsale ends"
865     );
866 
867     require(
868       bonusAvailableUntil >= openingTime && bonusAvailableUntil <= closingTime,
869       "Cannot unlock bonus tokens before crowdsale ends"
870     );
871 
872     _bonusUnlockTime = bonusUnlockTime;
873     _bonusAvailableUntil = bonusAvailableUntil;
874   }
875 
876   /**
877    * @dev Checks whether bonus is currently available.
878    * @return Returns whether bonus tokens are available
879    */
880   function _isBonusAvailable()
881     private
882     view
883     returns (bool)
884   {
885     // solium-disable-next-line security/no-block-members
886     return block.timestamp <= _bonusAvailableUntil;
887   }
888 
889   /**
890    * @dev Overrides the way in which ether to tokens conversion calculation to give bonus tokens.
891    * @param weiAmount Value in wei to be converted into tokens
892    * @return Number of tokens that can be purchased with the specified _weiAmount
893    */
894   function _getTokenAmount(uint256 weiAmount)
895     internal
896     view
897     returns (uint256)
898   {
899     uint256 baseTokenAmount = weiAmount.mul(rate());
900     uint256 bonusAmount = _isBonusAvailable() ?
901       baseTokenAmount.div(5) : // 20% bonus
902       0;
903 
904     return baseTokenAmount + bonusAmount;
905   }
906 
907   /**
908     * @dev Overrides delivery by minting tokens upon purchase.
909     * @param beneficiary Token purchaser
910     * @param tokenAmount Number of tokens to be minted
911     */
912   function _deliverTokens(address beneficiary, uint256 tokenAmount)
913     internal
914   {
915     uint256 baseAmount = _isBonusAvailable() ?
916       tokenAmount.div(6).mul(5) : // 20% total, may be slightly inaccurate, but doesn't matter
917       0;
918     uint256 lockedBonusAmount = tokenAmount.sub(baseAmount);
919 
920     require(
921       ERC20Mintable(address(token())).mint(beneficiary, baseAmount),
922       "Could not mint tokens to beneficiary."
923     );
924 
925     if (lockedBonusAmount > 0) {
926       require(
927         ERC20Mintable(address(token())).mint(this, lockedBonusAmount),
928         "Could not mint tokens to self for lockup."
929       );
930       _lockedTokens[beneficiary] = _lockedTokens[beneficiary].add(lockedBonusAmount);
931     }
932   }
933 
934   /**
935    * @dev Gets the amount of locked bonus tokens for the beneficiary.
936    * @param beneficiary Address whose locked bonus token balance is to be checked
937    * @return Current locked bonus token balance for individual beneficiary
938    */
939   function getLockedTokens(address beneficiary)
940     public
941     view
942     returns (uint256)
943   {
944     return _lockedTokens[beneficiary];
945   }
946 
947   /**
948     * @dev Deliver bonus tokens that were previously locked during purchase to multiple beneficiaries.
949     * @param beneficiaries Token purchaser
950     */
951   function deliverBonusTokens(address[] beneficiaries)
952     external
953   {
954     require(
955       // solium-disable-next-line security/no-block-members
956       _bonusUnlockTime <= block.timestamp,
957       "Tokens are not yet unlocked."
958     );
959 
960     for (uint8 i = 0; i < beneficiaries.length && i < 255; i ++) {
961       _deliverBonusTokens(beneficiaries[i]);
962     }
963   }
964 
965   /**
966     * @dev Deliver bonus tokens that were previously locked during purchase to a single beneficiary .
967     * @param beneficiary Token purchaser
968     */
969   function _deliverBonusTokens(address beneficiary)
970     private
971   {
972     require(
973       _lockedTokens[beneficiary] > 0,
974       "No tokens to unlock."
975     );
976 
977     _lockedTokens[beneficiary] = 0;
978 
979     require(
980       ERC20(address(token())).transfer(beneficiary, _lockedTokens[beneficiary]),
981       "Could not transfer tokens."
982     );
983   }
984 
985   /**
986    * @dev Sets multiple beneficiary's maximum contribution.
987    * @param beneficiaries Address to be capped
988    * @param caps Wei limit for each addresses contribution
989    */
990   function setCaps(address[] beneficiaries, uint256[] caps)
991     external
992     onlyCapper
993   {
994     for (uint8 i = 0; i < beneficiaries.length && i < 255; i ++) {
995       _caps[beneficiaries[i]] = caps[i];
996     }
997   }
998 
999   /**
1000    * @dev Sets a specific beneficiary's maximum contribution.
1001    * @param beneficiary Address to be capped
1002    * @param cap Wei limit for individual contribution
1003    */
1004   function setCap(address beneficiary, uint256 cap)
1005     external
1006     onlyCapper
1007   {
1008     _caps[beneficiary] = cap;
1009   }
1010 
1011   /**
1012    * @dev Returns the cap of a specific beneficiary.
1013    * @param beneficiary Address whose cap is to be checked
1014    * @return Current cap for individual beneficiary
1015    */
1016   function getCap(address beneficiary)
1017     public
1018     view
1019     returns (uint256)
1020   {
1021     return _caps[beneficiary];
1022   }
1023 
1024   /**
1025    * @dev Returns the amount contributed so far by a specific beneficiary.
1026    * @param beneficiary Address of contributor
1027    * @return Beneficiary contribution so far
1028    */
1029   function getContribution(address beneficiary)
1030     public
1031     view
1032     returns (uint256)
1033   {
1034     return _contributions[beneficiary];
1035   }
1036 
1037   /**
1038    * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1039    * @param beneficiary Token purchaser
1040    * @param weiAmount Amount of wei contributed
1041    */
1042   function _preValidatePurchase(
1043     address beneficiary,
1044     uint256 weiAmount
1045   )
1046     internal
1047   {
1048     super._preValidatePurchase(beneficiary, weiAmount);
1049     require(
1050       _contributions[beneficiary].add(weiAmount) <= _caps[beneficiary],
1051       "Contribution cap exceeded."
1052     );
1053   }
1054 
1055   /**
1056    * @dev Extend parent behavior to update beneficiary contributions
1057    * @param beneficiary Token purchaser
1058    * @param weiAmount Amount of wei contributed
1059    */
1060   function _updatePurchasingState(
1061     address beneficiary,
1062     uint256 weiAmount
1063   )
1064     internal
1065   {
1066     super._updatePurchasingState(beneficiary, weiAmount);
1067     _contributions[beneficiary] = _contributions[beneficiary].add(
1068       weiAmount);
1069   }
1070 }