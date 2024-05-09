1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender)
87     external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92     external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 value
101   );
102 
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 /**
111  * @title ERC20Detailed token
112  * @dev The decimals are only for visualization purposes.
113  * All the operations are done using the smallest and indivisible token unit,
114  * just as on Ethereum all the operations are done in wei.
115  */
116 contract ERC20Detailed is IERC20 {
117   string private _name;
118   string private _symbol;
119   uint8 private _decimals;
120 
121   constructor(string name, string symbol, uint8 decimals) public {
122     _name = name;
123     _symbol = symbol;
124     _decimals = decimals;
125   }
126 
127   /**
128    * @return the name of the token.
129    */
130   function name() public view returns(string) {
131     return _name;
132   }
133 
134   /**
135    * @return the symbol of the token.
136    */
137   function symbol() public view returns(string) {
138     return _symbol;
139   }
140 
141   /**
142    * @return the number of decimals of the token.
143    */
144   function decimals() public view returns(uint8) {
145     return _decimals;
146   }
147 }
148 
149 /**
150  * @title SafeMath
151  * @dev Math operations with safety checks that revert on error
152  */
153 library SafeMath {
154 
155   /**
156   * @dev Multiplies two numbers, reverts on overflow.
157   */
158   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160     // benefit is lost if 'b' is also tested.
161     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
162     if (a == 0) {
163       return 0;
164     }
165 
166     uint256 c = a * b;
167     require(c / a == b);
168 
169     return c;
170   }
171 
172   /**
173   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
174   */
175   function div(uint256 a, uint256 b) internal pure returns (uint256) {
176     require(b > 0); // Solidity only automatically asserts when dividing by 0
177     uint256 c = a / b;
178     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179 
180     return c;
181   }
182 
183   /**
184   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
185   */
186   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187     require(b <= a);
188     uint256 c = a - b;
189 
190     return c;
191   }
192 
193   /**
194   * @dev Adds two numbers, reverts on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     require(c >= a);
199 
200     return c;
201   }
202 
203   /**
204   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
205   * reverts when dividing by zero.
206   */
207   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208     require(b != 0);
209     return a % b;
210   }
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
218  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract ERC20 is IERC20 {
221   using SafeMath for uint256;
222 
223   mapping (address => uint256) private _balances;
224 
225   mapping (address => mapping (address => uint256)) private _allowed;
226 
227   uint256 private _totalSupply;
228 
229   /**
230   * @dev Total number of tokens in existence
231   */
232   function totalSupply() public view returns (uint256) {
233     return _totalSupply;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param owner The address to query the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address owner) public view returns (uint256) {
242     return _balances[owner];
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param owner address The address which owns the funds.
248    * @param spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address owner,
253     address spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return _allowed[owner][spender];
260   }
261 
262   /**
263   * @dev Transfer token for a specified address
264   * @param to The address to transfer to.
265   * @param value The amount to be transferred.
266   */
267   function transfer(address to, uint256 value) public returns (bool) {
268     _transfer(msg.sender, to, value);
269     return true;
270   }
271 
272   /**
273    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param spender The address which will spend the funds.
279    * @param value The amount of tokens to be spent.
280    */
281   function approve(address spender, uint256 value) public returns (bool) {
282     require(spender != address(0));
283 
284     _allowed[msg.sender][spender] = value;
285     emit Approval(msg.sender, spender, value);
286     return true;
287   }
288 
289   /**
290    * @dev Transfer tokens from one address to another
291    * @param from address The address which you want to send tokens from
292    * @param to address The address which you want to transfer to
293    * @param value uint256 the amount of tokens to be transferred
294    */
295   function transferFrom(
296     address from,
297     address to,
298     uint256 value
299   )
300     public
301     returns (bool)
302   {
303     require(value <= _allowed[from][msg.sender]);
304 
305     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
306     _transfer(from, to, value);
307     return true;
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    * approve should be called when allowed_[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param spender The address which will spend the funds.
317    * @param addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseAllowance(
320     address spender,
321     uint256 addedValue
322   )
323     public
324     returns (bool)
325   {
326     require(spender != address(0));
327 
328     _allowed[msg.sender][spender] = (
329       _allowed[msg.sender][spender].add(addedValue));
330     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed_[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param spender The address which will spend the funds.
341    * @param subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseAllowance(
344     address spender,
345     uint256 subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     require(spender != address(0));
351 
352     _allowed[msg.sender][spender] = (
353       _allowed[msg.sender][spender].sub(subtractedValue));
354     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
355     return true;
356   }
357 
358   /**
359   * @dev Transfer token for a specified addresses
360   * @param from The address to transfer from.
361   * @param to The address to transfer to.
362   * @param value The amount to be transferred.
363   */
364   function _transfer(address from, address to, uint256 value) internal {
365     require(value <= _balances[from]);
366     require(to != address(0));
367 
368     _balances[from] = _balances[from].sub(value);
369     _balances[to] = _balances[to].add(value);
370     emit Transfer(from, to, value);
371   }
372 
373   /**
374    * @dev Internal function that mints an amount of the token and assigns it to
375    * an account. This encapsulates the modification of balances such that the
376    * proper events are emitted.
377    * @param account The account that will receive the created tokens.
378    * @param value The amount that will be created.
379    */
380   function _mint(address account, uint256 value) internal {
381     require(account != 0);
382     _totalSupply = _totalSupply.add(value);
383     _balances[account] = _balances[account].add(value);
384     emit Transfer(address(0), account, value);
385   }
386 
387   /**
388    * @dev Internal function that burns an amount of the token of a given
389    * account.
390    * @param account The account whose tokens will be burnt.
391    * @param value The amount that will be burnt.
392    */
393   function _burn(address account, uint256 value) internal {
394     require(account != 0);
395     require(value <= _balances[account]);
396 
397     _totalSupply = _totalSupply.sub(value);
398     _balances[account] = _balances[account].sub(value);
399     emit Transfer(account, address(0), value);
400   }
401 
402   /**
403    * @dev Internal function that burns an amount of the token of a given
404    * account, deducting from the sender's allowance for said account. Uses the
405    * internal burn function.
406    * @param account The account whose tokens will be burnt.
407    * @param value The amount that will be burnt.
408    */
409   function _burnFrom(address account, uint256 value) internal {
410     require(value <= _allowed[account][msg.sender]);
411 
412     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
413     // this function needs to emit an event with the updated approval.
414     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
415       value);
416     _burn(account, value);
417   }
418 }
419 
420 /**
421  * @title Roles
422  * @dev Library for managing addresses assigned to a Role.
423  */
424 library Roles {
425   struct Role {
426     mapping (address => bool) bearer;
427   }
428 
429   /**
430    * @dev give an account access to this role
431    */
432   function add(Role storage role, address account) internal {
433     require(account != address(0));
434     require(!has(role, account));
435 
436     role.bearer[account] = true;
437   }
438 
439   /**
440    * @dev remove an account's access to this role
441    */
442   function remove(Role storage role, address account) internal {
443     require(account != address(0));
444     require(has(role, account));
445 
446     role.bearer[account] = false;
447   }
448 
449   /**
450    * @dev check if an account has this role
451    * @return bool
452    */
453   function has(Role storage role, address account)
454     internal
455     view
456     returns (bool)
457   {
458     require(account != address(0));
459     return role.bearer[account];
460   }
461 }
462 
463 contract PauserRole {
464   using Roles for Roles.Role;
465 
466   event PauserAdded(address indexed account);
467   event PauserRemoved(address indexed account);
468 
469   Roles.Role private pausers;
470 
471   constructor() internal {
472     _addPauser(msg.sender);
473   }
474 
475   modifier onlyPauser() {
476     require(isPauser(msg.sender));
477     _;
478   }
479 
480   function isPauser(address account) public view returns (bool) {
481     return pausers.has(account);
482   }
483 
484   function addPauser(address account) public onlyPauser {
485     _addPauser(account);
486   }
487 
488   function renouncePauser() public {
489     _removePauser(msg.sender);
490   }
491 
492   function _addPauser(address account) internal {
493     pausers.add(account);
494     emit PauserAdded(account);
495   }
496 
497   function _removePauser(address account) internal {
498     pausers.remove(account);
499     emit PauserRemoved(account);
500   }
501 }
502 
503 /**
504  * @title Pausable
505  * @dev Base contract which allows children to implement an emergency stop mechanism.
506  */
507 contract Pausable is PauserRole {
508   event Paused(address account);
509   event Unpaused(address account);
510 
511   bool private _paused;
512 
513   constructor() internal {
514     _paused = false;
515   }
516 
517   /**
518    * @return true if the contract is paused, false otherwise.
519    */
520   function paused() public view returns(bool) {
521     return _paused;
522   }
523 
524   /**
525    * @dev Modifier to make a function callable only when the contract is not paused.
526    */
527   modifier whenNotPaused() {
528     require(!_paused);
529     _;
530   }
531 
532   /**
533    * @dev Modifier to make a function callable only when the contract is paused.
534    */
535   modifier whenPaused() {
536     require(_paused);
537     _;
538   }
539 
540   /**
541    * @dev called by the owner to pause, triggers stopped state
542    */
543   function pause() public onlyPauser whenNotPaused {
544     _paused = true;
545     emit Paused(msg.sender);
546   }
547 
548   /**
549    * @dev called by the owner to unpause, returns to normal state
550    */
551   function unpause() public onlyPauser whenPaused {
552     _paused = false;
553     emit Unpaused(msg.sender);
554   }
555 }
556 
557 /**
558  * @title Pausable token
559  * @dev ERC20 modified with pausable transfers.
560  **/
561 contract ERC20Pausable is ERC20, Pausable {
562 
563   function transfer(
564     address to,
565     uint256 value
566   )
567     public
568     whenNotPaused
569     returns (bool)
570   {
571     return super.transfer(to, value);
572   }
573 
574   function transferFrom(
575     address from,
576     address to,
577     uint256 value
578   )
579     public
580     whenNotPaused
581     returns (bool)
582   {
583     return super.transferFrom(from, to, value);
584   }
585 
586   function approve(
587     address spender,
588     uint256 value
589   )
590     public
591     whenNotPaused
592     returns (bool)
593   {
594     return super.approve(spender, value);
595   }
596 
597   function increaseAllowance(
598     address spender,
599     uint addedValue
600   )
601     public
602     whenNotPaused
603     returns (bool success)
604   {
605     return super.increaseAllowance(spender, addedValue);
606   }
607 
608   function decreaseAllowance(
609     address spender,
610     uint subtractedValue
611   )
612     public
613     whenNotPaused
614     returns (bool success)
615   {
616     return super.decreaseAllowance(spender, subtractedValue);
617   }
618 }
619 
620 contract SignkeysToken is ERC20Pausable, ERC20Detailed, Ownable {
621 
622     uint8 public constant DECIMALS = 18;
623 
624     uint256 public constant INITIAL_SUPPLY = 2E9 * (10 ** uint256(DECIMALS));
625 
626     /**
627      * @dev Constructor that gives msg.sender all of existing tokens.
628      */
629     constructor() public ERC20Detailed("SignkeysToken", "KEYS", DECIMALS) {
630         _mint(owner(), INITIAL_SUPPLY);
631     }
632 
633     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool success) {
634         require(_spender != address(this));
635         require(super.approve(_spender, _value));
636         require(_spender.call(_data));
637         return true;
638     }
639 
640     function() payable external {
641         revert();
642     }
643 }
644 
645 contract SignkeysBonusProgram is Ownable {
646     using SafeMath for uint256;
647 
648     /* Token contract */
649     SignkeysToken public token;
650 
651     /* Crowdsale contract */
652     SignkeysCrowdsale public crowdsale;
653 
654     /* SignkeysBonusProgramRewards contract to keep bonus state */
655     SignkeysBonusProgramRewards public bonusProgramRewards;
656 
657     /* Ranges in which we transfer the given amount of tokens as reward. See arrays below.
658      For example, if this array is [199, 1000, 10000] and referrerRewards array is [5, 50],
659        it considers as follows:
660        [0, 199] - 0 tokens
661        [200, 1000] - 5 tokens
662        [1001, 10000] - 50 tokens,
663        > 10000 - 50 tokens
664        */
665     uint256[] public referralBonusTokensAmountRanges = [199, 1000, 10000, 100000, 1000000, 10000000];
666 
667     /* Amount of tokens as bonus for referrer according to referralBonusTokensAmountRanges */
668     uint256[] public referrerRewards = [5, 50, 500, 5000, 50000];
669 
670     /* Amount of tokens as bonus for buyer according to referralBonusTokensAmountRanges */
671     uint256[] public buyerRewards = [5, 50, 500, 5000, 50000];
672 
673     /* Purchase amount ranges in cents for any purchase.
674      For example, if this array is [2000, 1000000, 10000000] and purchaseRewardsPercents array is [10, 15, 20],
675        it considers as follows:
676        [2000, 1000000) - 10% of tokens
677        [1000000, 10000000) - 15% of tokens
678        > 100000000 - 20% tokens
679        */
680     uint256[] public purchaseAmountRangesInCents = [2000, 1000000, 10000000];
681 
682     /* Percetage of reward for any purchase according to purchaseAmountRangesInCents */
683     uint256[] public purchaseRewardsPercents = [10, 15, 20];
684 
685     event BonusSent(
686         address indexed referrerAddress,
687         uint256 referrerBonus,
688         address indexed buyerAddress,
689         uint256 buyerBonus,
690         uint256 purchaseBonus,
691         uint256 couponBonus
692     );
693 
694     constructor(address _token, address _bonusProgramRewards) public {
695         token = SignkeysToken(_token);
696         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
697     }
698 
699     function setCrowdsaleContract(address _crowdsale) public onlyOwner {
700         crowdsale = SignkeysCrowdsale(_crowdsale);
701     }
702 
703     function setBonusProgramRewardsContract(address _bonusProgramRewards) public onlyOwner {
704         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
705     }
706 
707     /* Calculate bonus for the given amount of tokens according to referralBonusTokensAmountRanges
708     and rewards array which is one of referrerRewards or buyerRewards */
709     function calcBonus(uint256 tokensAmount, uint256[] rewards) private view returns (uint256) {
710         uint256 multiplier = 10 ** uint256(token.decimals());
711         if (tokensAmount <= multiplier.mul(referralBonusTokensAmountRanges[0])) {
712             return 0;
713         }
714         for (uint i = 1; i < referralBonusTokensAmountRanges.length; i++) {
715             uint min = referralBonusTokensAmountRanges[i - 1];
716             uint max = referralBonusTokensAmountRanges[i];
717             if (tokensAmount > min.mul(multiplier) && tokensAmount <= max.mul(multiplier)) {
718                 return multiplier.mul(rewards[i - 1]);
719             }
720         }
721         if (tokensAmount >= referralBonusTokensAmountRanges[referralBonusTokensAmountRanges.length - 1].mul(multiplier)) {
722             return multiplier.mul(rewards[rewards.length - 1]);
723         }
724     }
725 
726     function calcPurchaseBonus(uint256 amountCents, uint256 tokensAmount) private view returns (uint256) {
727         if (amountCents < purchaseAmountRangesInCents[0]) {
728             return 0;
729         }
730         for (uint i = 1; i < purchaseAmountRangesInCents.length; i++) {
731             if (amountCents >= purchaseAmountRangesInCents[i - 1] && amountCents < purchaseAmountRangesInCents[i]) {
732                 return tokensAmount.mul(purchaseRewardsPercents[i - 1]).div(100);
733             }
734         }
735         if (amountCents >= purchaseAmountRangesInCents[purchaseAmountRangesInCents.length - 1]) {
736             return tokensAmount.mul(purchaseRewardsPercents[purchaseAmountRangesInCents.length - 1]).div(100);
737         }
738     }
739 
740     /* Having referrer, buyer, amount of purchased tokens, value of purchased tokens in cents and coupon campaign id
741     this method transfer all the required bonuses to referrer and buyer */
742     function sendBonus(address referrer, address buyer, uint256 _tokensAmount, uint256 _valueCents, uint256 _couponCampaignId) external returns (uint256)  {
743         require(msg.sender == address(crowdsale), "Bonus may be sent only by crowdsale contract");
744 
745         uint256 referrerBonus = 0;
746         uint256 buyerBonus = 0;
747         uint256 purchaseBonus = 0;
748         uint256 couponBonus = 0;
749 
750         uint256 referrerBonusAmount = calcBonus(_tokensAmount, referrerRewards);
751         uint256 buyerBonusAmount = calcBonus(_tokensAmount, buyerRewards);
752         uint256 purchaseBonusAmount = calcPurchaseBonus(_valueCents, _tokensAmount);
753 
754         if (referrer != 0x0 && !bonusProgramRewards.areReferralBonusesSent(buyer)) {
755             if (referrerBonusAmount > 0 && token.balanceOf(this) > referrerBonusAmount) {
756                 token.transfer(referrer, referrerBonusAmount);
757                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
758                 referrerBonus = referrerBonusAmount;
759             }
760 
761             if (buyerBonusAmount > 0 && token.balanceOf(this) > buyerBonusAmount) {
762                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
763                 buyerBonus = buyerBonusAmount;
764             }
765         }
766 
767         if (token.balanceOf(this) > purchaseBonusAmount.add(buyerBonus)) {
768             purchaseBonus = purchaseBonusAmount;
769         }
770 
771         if (_couponCampaignId > 0 && !bonusProgramRewards.isCouponUsed(buyer, _couponCampaignId)) {
772             if (
773                 token.balanceOf(this) > purchaseBonusAmount
774                 .add(buyerBonus)
775                 .add(bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId))
776             ) {
777                 bonusProgramRewards.setCouponUsed(buyer, _couponCampaignId, true);
778                 couponBonus = bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId);
779             }
780         }
781 
782         if (buyerBonus > 0 || purchaseBonus > 0 || couponBonus > 0) {
783             token.transfer(buyer, buyerBonus.add(purchaseBonus).add(couponBonus));
784         }
785 
786         emit BonusSent(referrer, referrerBonus, buyer, buyerBonus, purchaseBonus, couponBonus);
787     }
788 
789     function getReferralBonusTokensAmountRanges() public view returns (uint256[]) {
790         return referralBonusTokensAmountRanges;
791     }
792 
793     function getReferrerRewards() public view returns (uint256[]) {
794         return referrerRewards;
795     }
796 
797     function getBuyerRewards() public view returns (uint256[]) {
798         return buyerRewards;
799     }
800 
801     function getPurchaseRewardsPercents() public view returns (uint256[]) {
802         return purchaseRewardsPercents;
803     }
804 
805     function getPurchaseAmountRangesInCents() public view returns (uint256[]) {
806         return purchaseAmountRangesInCents;
807     }
808 
809     function setReferralBonusTokensAmountRanges(uint[] ranges) public onlyOwner {
810         referralBonusTokensAmountRanges = ranges;
811     }
812 
813     function setReferrerRewards(uint[] rewards) public onlyOwner {
814         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
815         referrerRewards = rewards;
816     }
817 
818     function setBuyerRewards(uint[] rewards) public onlyOwner {
819         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
820         buyerRewards = rewards;
821     }
822 
823     function setPurchaseAmountRangesInCents(uint[] ranges) public onlyOwner {
824         purchaseAmountRangesInCents = ranges;
825     }
826 
827     function setPurchaseRewardsPercents(uint[] rewards) public onlyOwner {
828         require(rewards.length == purchaseAmountRangesInCents.length);
829         purchaseRewardsPercents = rewards;
830     }
831 
832     /* Withdraw all tokens from contract for any emergence case */
833     function withdrawTokens() external onlyOwner {
834         uint256 amount = token.balanceOf(this);
835         address tokenOwner = token.owner();
836         token.transfer(tokenOwner, amount);
837     }
838 }
839 
840 contract SignkeysBonusProgramRewards is Ownable {
841     using SafeMath for uint256;
842 
843     /* Bonus program contract */
844     SignkeysBonusProgram public bonusProgram;
845 
846     /* How much bonuses to send according for the given coupon campaign */
847     mapping(uint256 => uint256) private _couponCampaignBonusTokensAmount;
848 
849     /* Check if referrer already got the bonuses from the invited token receiver */
850     mapping(address => bool) private _areReferralBonusesSent;
851 
852     /* Check if coupon of the given campaign was used by the token receiver */
853     mapping(address => mapping(uint256 => bool)) private _isCouponUsed;
854 
855     function setBonusProgram(address _bonusProgram) public onlyOwner {
856         bonusProgram = SignkeysBonusProgram(_bonusProgram);
857     }
858 
859     modifier onlyBonusProgramContract() {
860         require(msg.sender == address(bonusProgram), "Bonus program rewards state may be changed only by bonus program contract");
861         _;
862     }
863 
864     function addCouponCampaignBonusTokensAmount(uint256 _couponCampaignId, uint256 amountOfBonuses) public onlyOwner {
865         _couponCampaignBonusTokensAmount[_couponCampaignId] = amountOfBonuses;
866     }
867 
868     function getCouponCampaignBonusTokensAmount(uint256 _couponCampaignId) public view returns (uint256)  {
869         return _couponCampaignBonusTokensAmount[_couponCampaignId];
870     }
871 
872     function isCouponUsed(address buyer, uint256 couponCampaignId) public view returns (bool)  {
873         return _isCouponUsed[buyer][couponCampaignId];
874     }
875 
876     function setCouponUsed(address buyer, uint256 couponCampaignId, bool isUsed) public onlyBonusProgramContract {
877         _isCouponUsed[buyer][couponCampaignId] = isUsed;
878     }
879 
880     function areReferralBonusesSent(address buyer) public view returns (bool)  {
881         return _areReferralBonusesSent[buyer];
882     }
883 
884     function setReferralBonusesSent(address buyer, bool areBonusesSent) public onlyBonusProgramContract {
885         _areReferralBonusesSent[buyer] = areBonusesSent;
886     }
887 }
888 
889 /**
890  * @title Helps contracts guard against reentrancy attacks.
891  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
892  * @dev If you mark a function `nonReentrant`, you should also
893  * mark it `external`.
894  */
895 contract ReentrancyGuard {
896 
897   /// @dev counter to allow mutex lock with only one SSTORE operation
898   uint256 private _guardCounter;
899 
900   constructor() internal {
901     // The counter starts at one to prevent changing it from zero to a non-zero
902     // value, which is a more expensive operation.
903     _guardCounter = 1;
904   }
905 
906   /**
907    * @dev Prevents a contract from calling itself, directly or indirectly.
908    * Calling a `nonReentrant` function from another `nonReentrant`
909    * function is not supported. It is possible to prevent this from happening
910    * by making the `nonReentrant` function external, and make it call a
911    * `private` function that does the actual work.
912    */
913   modifier nonReentrant() {
914     _guardCounter += 1;
915     uint256 localCounter = _guardCounter;
916     _;
917     require(localCounter == _guardCounter);
918   }
919 
920 }
921 
922 contract SignkeysCrowdsale is Ownable, ReentrancyGuard {
923     using SafeMath for uint256;
924 
925     uint256 public INITIAL_TOKEN_PRICE_CENTS = 10;
926 
927     /* Token contract */
928     SignkeysToken public signkeysToken;
929 
930     /* Bonus program contract*/
931     SignkeysBonusProgram public signkeysBonusProgram;
932 
933     /* signer address, can be set by owner only */
934     address public signer;
935 
936     /* ETH funds will be transferred to this address */
937     address public wallet;
938 
939     /* Current token price in cents */
940     uint256 public tokenPriceCents;
941 
942     /* Buyer bought the amount of tokens with tokenPrice */
943     event BuyTokens(
944         address indexed buyer,
945         address indexed tokenReceiver,
946         uint256 tokenPrice,
947         uint256 amount
948     );
949 
950     /* Wallet changed */
951     event WalletChanged(address newWallet);
952 
953     /* Signer changed */
954     event CrowdsaleSignerChanged(address newSigner);
955 
956     /* Token price changed */
957     event TokenPriceChanged(uint256 oldPrice, uint256 newPrice);
958 
959     constructor(
960         address _token,
961         address _bonusProgram,
962         address _wallet,
963         address _signer
964     ) public {
965         require(_token != 0x0, "Token contract for crowdsale must be set");
966         require(_bonusProgram != 0x0, "Referrer smart contract for crowdsale must be set");
967 
968         require(_wallet != 0x0, "Wallet for fund transferring must be set");
969         require(_signer != 0x0, "Signer must be set");
970 
971         signkeysToken = SignkeysToken(_token);
972         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
973 
974         signer = _signer;
975         wallet = _wallet;
976 
977         tokenPriceCents = INITIAL_TOKEN_PRICE_CENTS;
978     }
979 
980     function setSignerAddress(address _signer) external onlyOwner {
981         signer = _signer;
982         emit CrowdsaleSignerChanged(_signer);
983     }
984 
985     function setWalletAddress(address _wallet) external onlyOwner {
986         wallet = _wallet;
987         emit WalletChanged(_wallet);
988     }
989 
990     function setBonusProgram(address _bonusProgram) external onlyOwner {
991         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
992     }
993 
994     function setTokenPriceCents(uint256 _tokenPriceCents) external onlyOwner {
995         emit TokenPriceChanged(tokenPriceCents, _tokenPriceCents);
996         tokenPriceCents = _tokenPriceCents;
997     }
998 
999     /**
1000      * @dev Make an investment.
1001      *
1002      * @param _tokenReceiver address where the tokens need to be transfered
1003      * @param _referrer address of user that invited _tokenReceiver for this purchase
1004      * @param _tokenPrice price per one token including decimals
1005      * @param _minWei minimal amount of wei buyer should invest
1006      * @param _expiration expiration on token
1007      */
1008     function buyTokens(
1009         address _tokenReceiver,
1010         address _referrer,
1011         uint256 _couponCampaignId, // starts with 1 if there is some, 0 means no coupon
1012         uint256 _tokenPrice,
1013         uint256 _minWei,
1014         uint256 _expiration,
1015         uint8 _v,
1016         bytes32 _r,
1017         bytes32 _s
1018     ) payable external nonReentrant {
1019         require(_expiration >= now, "Signature expired");
1020         require(_tokenReceiver != 0x0, "Token receiver must be provided");
1021         require(_minWei > 0, "Minimal amount to purchase must be greater than 0");
1022 
1023         require(wallet != 0x0, "Wallet must be set");
1024         require(msg.value >= _minWei, "Purchased amount is less than min amount to invest");
1025 
1026         address receivedSigner = ecrecover(
1027             keccak256(
1028                 abi.encodePacked(
1029                     _tokenPrice, _minWei, _tokenReceiver, _referrer, _couponCampaignId, _expiration
1030                 )
1031             ), _v, _r, _s);
1032 
1033         require(receivedSigner == signer, "Something wrong with signature");
1034 
1035         uint256 tokensAmount = msg.value.mul(10 ** uint256(signkeysToken.decimals())).div(_tokenPrice);
1036         require(signkeysToken.balanceOf(this) >= tokensAmount, "Not enough tokens in sale contract");
1037 
1038         signkeysToken.transfer(_tokenReceiver, tokensAmount);
1039 
1040         // send bonuses according to signkeys bonus program
1041         signkeysBonusProgram.sendBonus(
1042             _referrer,
1043             _tokenReceiver,
1044             tokensAmount,
1045             (tokensAmount.mul(tokenPriceCents).div(10 ** uint256(signkeysToken.decimals()))),
1046             _couponCampaignId);
1047 
1048         // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our wallet
1049         wallet.transfer(msg.value);
1050 
1051         emit BuyTokens(msg.sender, _tokenReceiver, _tokenPrice, tokensAmount);
1052     }
1053 
1054     /**
1055      * Don't expect to just send in money and get tokens.
1056      */
1057     function() payable external {
1058         revert();
1059     }
1060 
1061     /* Withdraw all tokens from contract for any emergence case */
1062     function withdrawTokens() external onlyOwner {
1063         uint256 amount = signkeysToken.balanceOf(this);
1064         address tokenOwner = signkeysToken.owner();
1065         signkeysToken.transfer(tokenOwner, amount);
1066     }
1067 }