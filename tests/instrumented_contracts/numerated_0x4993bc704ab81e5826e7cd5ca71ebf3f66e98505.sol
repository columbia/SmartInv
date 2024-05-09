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
626     /* Address where fees will be transferred */
627     address public feeChargingAddress;
628 
629     /* Nonces */
630     mapping(address => uint256) public nonces;
631 
632     function setFeeChargingAddress(address _feeChargingAddress) external onlyOwner {
633         feeChargingAddress = _feeChargingAddress;
634         emit FeeChargingAddressChanges(_feeChargingAddress);
635     }
636 
637     /* Fee charging address changed */
638     event FeeChargingAddressChanges(address newFeeChargingAddress);
639 
640     /**
641      * @dev Constructor that gives msg.sender all of existing tokens.
642      */
643     constructor() public ERC20Detailed("SignkeysToken", "KEYS", DECIMALS) {
644         _mint(owner(), INITIAL_SUPPLY);
645     }
646 
647     function transferWithSignature(
648         address from,
649         address to,
650         uint256 amount,
651         uint256 feeAmount,
652         uint256 nonce,
653         uint256 expiration,
654         uint8 v,
655         bytes32 r,
656         bytes32 s) public {
657         require(expiration >= now, "Signature expired");
658         require(feeChargingAddress != 0x0, "Fee charging address must be set");
659 
660         address receivedSigner = ecrecover(
661             keccak256(
662                 abi.encodePacked(
663                     from, to, amount, feeAmount, nonce, expiration
664                 )
665             ), v, r, s);
666 
667         require(nonce > nonces[from], "Wrong nonce");
668         nonces[from] = nonce;
669 
670         require(receivedSigner == from, "Something wrong with signature");
671         _transfer(from, to, amount);
672         _transfer(from, feeChargingAddress, feeAmount);
673     }
674 
675     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool success) {
676         require(_spender != address(this));
677         require(super.approve(_spender, _value));
678         require(_spender.call(_data));
679         return true;
680     }
681 
682     function() payable external {
683         revert();
684     }
685 }
686 
687 contract SignkeysBonusProgram is Ownable {
688     using SafeMath for uint256;
689 
690     /* Token contract */
691     SignkeysToken public token;
692 
693     /* Crowdsale contract */
694     SignkeysCrowdsale public crowdsale;
695 
696     /* SignkeysBonusProgramRewards contract to keep bonus state */
697     SignkeysBonusProgramRewards public bonusProgramRewards;
698 
699     /* Ranges in which we transfer the given amount of tokens as reward. See arrays below.
700      For example, if this array is [199, 1000, 10000] and referrerRewards array is [5, 50],
701        it considers as follows:
702        [0, 199] - 0 tokens
703        [200, 1000] - 5 tokens
704        [1001, 10000] - 50 tokens,
705        > 10000 - 50 tokens
706        */
707     uint256[] public referralBonusTokensAmountRanges = [199, 1000, 10000, 100000, 1000000, 10000000];
708 
709     /* Amount of tokens as bonus for referrer according to referralBonusTokensAmountRanges */
710     uint256[] public referrerRewards = [5, 50, 500, 5000, 50000];
711 
712     /* Amount of tokens as bonus for buyer according to referralBonusTokensAmountRanges */
713     uint256[] public buyerRewards = [5, 50, 500, 5000, 50000];
714 
715     /* Purchase amount ranges in cents for any purchase.
716      For example, if this array is [2000, 1000000, 10000000] and purchaseRewardsPercents array is [10, 15, 20],
717        it considers as follows:
718        [2000, 1000000) - 10% of tokens
719        [1000000, 10000000) - 15% of tokens
720        > 100000000 - 20% tokens
721        */
722     uint256[] public purchaseAmountRangesInCents = [2000, 1000000, 10000000];
723 
724     /* Percetage of reward for any purchase according to purchaseAmountRangesInCents */
725     uint256[] public purchaseRewardsPercents = [10, 15, 20];
726 
727     event BonusSent(
728         address indexed referrerAddress,
729         uint256 referrerBonus,
730         address indexed buyerAddress,
731         uint256 buyerBonus,
732         uint256 purchaseBonus,
733         uint256 couponBonus
734     );
735 
736     constructor(address _token, address _bonusProgramRewards) public {
737         token = SignkeysToken(_token);
738         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
739     }
740 
741     function setCrowdsaleContract(address _crowdsale) public onlyOwner {
742         crowdsale = SignkeysCrowdsale(_crowdsale);
743     }
744 
745     function setBonusProgramRewardsContract(address _bonusProgramRewards) public onlyOwner {
746         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
747     }
748 
749     /* Calculate bonus for the given amount of tokens according to referralBonusTokensAmountRanges
750     and rewards array which is one of referrerRewards or buyerRewards */
751     function calcBonus(uint256 tokensAmount, uint256[] rewards) private view returns (uint256) {
752         uint256 multiplier = 10 ** uint256(token.decimals());
753         if (tokensAmount <= multiplier.mul(referralBonusTokensAmountRanges[0])) {
754             return 0;
755         }
756         for (uint i = 1; i < referralBonusTokensAmountRanges.length; i++) {
757             uint min = referralBonusTokensAmountRanges[i - 1];
758             uint max = referralBonusTokensAmountRanges[i];
759             if (tokensAmount > min.mul(multiplier) && tokensAmount <= max.mul(multiplier)) {
760                 return multiplier.mul(rewards[i - 1]);
761             }
762         }
763         if (tokensAmount >= referralBonusTokensAmountRanges[referralBonusTokensAmountRanges.length - 1].mul(multiplier)) {
764             return multiplier.mul(rewards[rewards.length - 1]);
765         }
766     }
767 
768     function calcPurchaseBonus(uint256 amountCents, uint256 tokensAmount) private view returns (uint256) {
769         if (amountCents < purchaseAmountRangesInCents[0]) {
770             return 0;
771         }
772         for (uint i = 1; i < purchaseAmountRangesInCents.length; i++) {
773             if (amountCents >= purchaseAmountRangesInCents[i - 1] && amountCents < purchaseAmountRangesInCents[i]) {
774                 return tokensAmount.mul(purchaseRewardsPercents[i - 1]).div(100);
775             }
776         }
777         if (amountCents >= purchaseAmountRangesInCents[purchaseAmountRangesInCents.length - 1]) {
778             return tokensAmount.mul(purchaseRewardsPercents[purchaseAmountRangesInCents.length - 1]).div(100);
779         }
780     }
781 
782     /* Having referrer, buyer, amount of purchased tokens, value of purchased tokens in cents and coupon campaign id
783     this method transfer all the required bonuses to referrer and buyer */
784     function sendBonus(address referrer, address buyer, uint256 _tokensAmount, uint256 _valueCents, uint256 _couponCampaignId) external returns (uint256)  {
785         require(msg.sender == address(crowdsale), "Bonus may be sent only by crowdsale contract");
786 
787         uint256 referrerBonus = 0;
788         uint256 buyerBonus = 0;
789         uint256 purchaseBonus = 0;
790         uint256 couponBonus = 0;
791 
792         uint256 referrerBonusAmount = calcBonus(_tokensAmount, referrerRewards);
793         uint256 buyerBonusAmount = calcBonus(_tokensAmount, buyerRewards);
794         uint256 purchaseBonusAmount = calcPurchaseBonus(_valueCents, _tokensAmount);
795 
796         if (referrer != 0x0 && !bonusProgramRewards.areReferralBonusesSent(buyer)) {
797             if (referrerBonusAmount > 0 && token.balanceOf(this) > referrerBonusAmount) {
798                 token.transfer(referrer, referrerBonusAmount);
799                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
800                 referrerBonus = referrerBonusAmount;
801             }
802 
803             if (buyerBonusAmount > 0 && token.balanceOf(this) > buyerBonusAmount) {
804                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
805                 buyerBonus = buyerBonusAmount;
806             }
807         }
808 
809         if (token.balanceOf(this) > purchaseBonusAmount.add(buyerBonus)) {
810             purchaseBonus = purchaseBonusAmount;
811         }
812 
813         if (_couponCampaignId > 0 && !bonusProgramRewards.isCouponUsed(buyer, _couponCampaignId)) {
814             if (
815                 token.balanceOf(this) > purchaseBonusAmount
816                 .add(buyerBonus)
817                 .add(bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId))
818             ) {
819                 bonusProgramRewards.setCouponUsed(buyer, _couponCampaignId, true);
820                 couponBonus = bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId);
821             }
822         }
823 
824         if (buyerBonus > 0 || purchaseBonus > 0 || couponBonus > 0) {
825             token.transfer(buyer, buyerBonus.add(purchaseBonus).add(couponBonus));
826         }
827 
828         emit BonusSent(referrer, referrerBonus, buyer, buyerBonus, purchaseBonus, couponBonus);
829     }
830 
831     function getReferralBonusTokensAmountRanges() public view returns (uint256[]) {
832         return referralBonusTokensAmountRanges;
833     }
834 
835     function getReferrerRewards() public view returns (uint256[]) {
836         return referrerRewards;
837     }
838 
839     function getBuyerRewards() public view returns (uint256[]) {
840         return buyerRewards;
841     }
842 
843     function getPurchaseRewardsPercents() public view returns (uint256[]) {
844         return purchaseRewardsPercents;
845     }
846 
847     function getPurchaseAmountRangesInCents() public view returns (uint256[]) {
848         return purchaseAmountRangesInCents;
849     }
850 
851     function setReferralBonusTokensAmountRanges(uint[] ranges) public onlyOwner {
852         referralBonusTokensAmountRanges = ranges;
853     }
854 
855     function setReferrerRewards(uint[] rewards) public onlyOwner {
856         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
857         referrerRewards = rewards;
858     }
859 
860     function setBuyerRewards(uint[] rewards) public onlyOwner {
861         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
862         buyerRewards = rewards;
863     }
864 
865     function setPurchaseAmountRangesInCents(uint[] ranges) public onlyOwner {
866         purchaseAmountRangesInCents = ranges;
867     }
868 
869     function setPurchaseRewardsPercents(uint[] rewards) public onlyOwner {
870         require(rewards.length == purchaseAmountRangesInCents.length);
871         purchaseRewardsPercents = rewards;
872     }
873 
874     /* Withdraw all tokens from contract for any emergence case */
875     function withdrawTokens() external onlyOwner {
876         uint256 amount = token.balanceOf(this);
877         address tokenOwner = token.owner();
878         token.transfer(tokenOwner, amount);
879     }
880 }
881 
882 contract SignkeysBonusProgramRewards is Ownable {
883     using SafeMath for uint256;
884 
885     /* Bonus program contract */
886     SignkeysBonusProgram public bonusProgram;
887 
888     /* How much bonuses to send according for the given coupon campaign */
889     mapping(uint256 => uint256) private _couponCampaignBonusTokensAmount;
890 
891     /* Check if referrer already got the bonuses from the invited token receiver */
892     mapping(address => bool) private _areReferralBonusesSent;
893 
894     /* Check if coupon of the given campaign was used by the token receiver */
895     mapping(address => mapping(uint256 => bool)) private _isCouponUsed;
896 
897     function setBonusProgram(address _bonusProgram) public onlyOwner {
898         bonusProgram = SignkeysBonusProgram(_bonusProgram);
899     }
900 
901     modifier onlyBonusProgramContract() {
902         require(msg.sender == address(bonusProgram), "Bonus program rewards state may be changed only by bonus program contract");
903         _;
904     }
905 
906     function addCouponCampaignBonusTokensAmount(uint256 _couponCampaignId, uint256 amountOfBonuses) public onlyOwner {
907         _couponCampaignBonusTokensAmount[_couponCampaignId] = amountOfBonuses;
908     }
909 
910     function getCouponCampaignBonusTokensAmount(uint256 _couponCampaignId) public view returns (uint256)  {
911         return _couponCampaignBonusTokensAmount[_couponCampaignId];
912     }
913 
914     function isCouponUsed(address buyer, uint256 couponCampaignId) public view returns (bool)  {
915         return _isCouponUsed[buyer][couponCampaignId];
916     }
917 
918     function setCouponUsed(address buyer, uint256 couponCampaignId, bool isUsed) public onlyBonusProgramContract {
919         _isCouponUsed[buyer][couponCampaignId] = isUsed;
920     }
921 
922     function areReferralBonusesSent(address buyer) public view returns (bool)  {
923         return _areReferralBonusesSent[buyer];
924     }
925 
926     function setReferralBonusesSent(address buyer, bool areBonusesSent) public onlyBonusProgramContract {
927         _areReferralBonusesSent[buyer] = areBonusesSent;
928     }
929 }
930 
931 /**
932  * @title Helps contracts guard against reentrancy attacks.
933  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
934  * @dev If you mark a function `nonReentrant`, you should also
935  * mark it `external`.
936  */
937 contract ReentrancyGuard {
938 
939   /// @dev counter to allow mutex lock with only one SSTORE operation
940   uint256 private _guardCounter;
941 
942   constructor() internal {
943     // The counter starts at one to prevent changing it from zero to a non-zero
944     // value, which is a more expensive operation.
945     _guardCounter = 1;
946   }
947 
948   /**
949    * @dev Prevents a contract from calling itself, directly or indirectly.
950    * Calling a `nonReentrant` function from another `nonReentrant`
951    * function is not supported. It is possible to prevent this from happening
952    * by making the `nonReentrant` function external, and make it call a
953    * `private` function that does the actual work.
954    */
955   modifier nonReentrant() {
956     _guardCounter += 1;
957     uint256 localCounter = _guardCounter;
958     _;
959     require(localCounter == _guardCounter);
960   }
961 
962 }
963 
964 contract SignkeysCrowdsale is Ownable, ReentrancyGuard {
965     using SafeMath for uint256;
966 
967     uint256 public constant INITIAL_TOKEN_PRICE_CENTS = 10;
968 
969     /* Token contract */
970     SignkeysToken public signkeysToken;
971 
972     /* Bonus program contract*/
973     SignkeysBonusProgram public signkeysBonusProgram;
974 
975     /* signer address, can be set by owner only */
976     address public signer;
977 
978     /* ETH funds will be transferred to this address */
979     address public wallet;
980 
981     /* Role that provide tokens calling sendTokens method */
982     address public administrator;
983 
984     /* Current token price in cents */
985     uint256 public tokenPriceCents;
986 
987     /* Buyer bought the amount of tokens with tokenPrice */
988     event BuyTokens(
989         address indexed buyer,
990         address indexed tokenReceiver,
991         uint256 tokenPrice,
992         uint256 amount
993     );
994 
995     /* Admin sent the amount of tokens to the tokenReceiver */
996     event SendTokens(
997         address indexed tokenReceiver,
998         uint256 amount
999     );
1000 
1001     /* Wallet changed */
1002     event WalletChanged(address newWallet);
1003 
1004     /* Administrator changed */
1005     event AdministratorChanged(address newAdministrator);
1006 
1007     /* Signer changed */
1008     event CrowdsaleSignerChanged(address newSigner);
1009 
1010     /* Token price changed */
1011     event TokenPriceChanged(uint256 oldPrice, uint256 newPrice);
1012 
1013     constructor(
1014         address _token,
1015         address _bonusProgram,
1016         address _wallet,
1017         address _signer
1018     ) public {
1019         require(_token != 0x0, "Token contract for crowdsale must be set");
1020         require(_bonusProgram != 0x0, "Referrer smart contract for crowdsale must be set");
1021 
1022         require(_wallet != 0x0, "Wallet for fund transferring must be set");
1023         require(_signer != 0x0, "Signer must be set");
1024 
1025         signkeysToken = SignkeysToken(_token);
1026         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
1027 
1028         signer = _signer;
1029         wallet = _wallet;
1030 
1031         tokenPriceCents = INITIAL_TOKEN_PRICE_CENTS;
1032     }
1033 
1034     function setSignerAddress(address _signer) external onlyOwner {
1035         signer = _signer;
1036         emit CrowdsaleSignerChanged(_signer);
1037     }
1038 
1039     function setWalletAddress(address _wallet) external onlyOwner {
1040         wallet = _wallet;
1041         emit WalletChanged(_wallet);
1042     }
1043 
1044     function setAdministratorAddress(address _administrator) external onlyOwner {
1045         administrator = _administrator;
1046         emit AdministratorChanged(_administrator);
1047     }
1048 
1049     function setBonusProgram(address _bonusProgram) external onlyOwner {
1050         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
1051     }
1052 
1053     function setTokenPriceCents(uint256 _tokenPriceCents) external onlyOwner {
1054         emit TokenPriceChanged(tokenPriceCents, _tokenPriceCents);
1055         tokenPriceCents = _tokenPriceCents;
1056     }
1057 
1058     /**
1059      * @dev Make an investment.
1060      *
1061      * @param _tokenReceiver address where the tokens need to be transfered
1062      * @param _referrer address of user that invited _tokenReceiver for this purchase
1063      * @param _tokenPrice price per one token including decimals
1064      * @param _minWei minimal amount of wei buyer should invest
1065      * @param _expiration expiration on token
1066      */
1067     function buyTokens(
1068         address _tokenReceiver,
1069         address _referrer,
1070         uint256 _couponCampaignId, // starts with 1 if there is some, 0 means no coupon
1071         uint256 _tokenPrice,
1072         uint256 _minWei,
1073         uint256 _expiration,
1074         uint8 _v,
1075         bytes32 _r,
1076         bytes32 _s
1077     ) payable external nonReentrant {
1078         require(_expiration >= now, "Signature expired");
1079         require(_tokenReceiver != 0x0, "Token receiver must be provided");
1080         require(_minWei > 0, "Minimal amount to purchase must be greater than 0");
1081 
1082         require(wallet != 0x0, "Wallet must be set");
1083         require(msg.value >= _minWei, "Purchased amount is less than min amount to invest");
1084 
1085         address receivedSigner = ecrecover(
1086             keccak256(
1087                 abi.encodePacked(
1088                     _tokenPrice, _minWei, _tokenReceiver, _referrer, _couponCampaignId, _expiration
1089                 )
1090             ), _v, _r, _s);
1091 
1092         require(receivedSigner == signer, "Something wrong with signature");
1093 
1094         uint256 tokensAmount = msg.value.mul(10 ** uint256(signkeysToken.decimals())).div(_tokenPrice);
1095         require(signkeysToken.balanceOf(this) >= tokensAmount, "Not enough tokens in sale contract");
1096 
1097         // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our wallet
1098         wallet.transfer(msg.value);
1099 
1100         _sendTokens(_tokenReceiver, _referrer, _couponCampaignId, tokensAmount);
1101 
1102         emit BuyTokens(msg.sender, _tokenReceiver, _tokenPrice, tokensAmount);
1103     }
1104 
1105     function sendTokens(
1106         address _tokenReceiver,
1107         address _referrer,
1108         uint256 _couponCampaignId,
1109         uint256 tokensAmount
1110     ) external {
1111         require(msg.sender == administrator, "sendTokens() method may be called only by administrator ");
1112         _sendTokens(_tokenReceiver, _referrer, _couponCampaignId, tokensAmount);
1113         emit SendTokens(_tokenReceiver, tokensAmount);
1114     }
1115 
1116     function _sendTokens(
1117         address _tokenReceiver,
1118         address _referrer,
1119         uint256 _couponCampaignId,
1120         uint256 tokensAmount
1121     ) private {
1122         signkeysToken.transfer(_tokenReceiver, tokensAmount);
1123 
1124         // send bonuses according to signkeys bonus program
1125         signkeysBonusProgram.sendBonus(
1126             _referrer,
1127             _tokenReceiver,
1128             tokensAmount,
1129             (tokensAmount.mul(tokenPriceCents).div(10 ** uint256(signkeysToken.decimals()))),
1130             _couponCampaignId);
1131     }
1132 
1133 
1134     /**
1135      * Don't expect to just send in money and get tokens.
1136      */
1137     function() payable external {
1138         revert();
1139     }
1140 
1141     /* Withdraw all tokens from contract for any emergence case */
1142     function withdrawTokens() external onlyOwner {
1143         uint256 amount = signkeysToken.balanceOf(this);
1144         address tokenOwner = signkeysToken.owner();
1145         signkeysToken.transfer(tokenOwner, amount);
1146     }
1147 }